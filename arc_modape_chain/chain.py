#!/usr/bin/env python
"""
arc_modape_chain.py: Flask Service app for collecting, processing and disseminating filtered NDVI.
         Production the time series leverages the WFP VAM MODAPE toolkit: https://github.com/WFP-VAM/modape

Author: Rob Marjot, (c) ARC 2025

"""

import contextlib
import glob
import hashlib
import itertools
import json
import logging
import os
import re
import shutil
import time
from datetime import date, datetime
from pathlib import Path
from threading import Thread, Timer
from typing import Dict, List
from urllib.parse import urlencode

import boto3
import click
from dateutil.relativedelta import relativedelta
from flask import Flask, jsonify, send_file
from modape.modis import ModisQuery
from modape.scripts.modis_collect import cli as modis_collect
from modape.scripts.modis_download import cli as modis_download
from modape.scripts.modis_smooth import cli as modis_smooth
from modape.scripts.modis_window import cli as modis_window
from requests import post

from arc_modape_chain.modape_helper import (
    curate_downloads,
    get_first_date_in_raw_modis_tiles,
    get_last_date_in_raw_modis_tiles,
    has_collected_dates,
)
from arc_modape_chain.modape_helper.timeslicing import Dekad, ModisInterleavedOctad

logging.basicConfig(
    level=os.environ.get("LOGLEVEL", "INFO"),
    format="[%(asctime)s %(levelname)s] (%(name)s:%(lineno)d) - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)

_log = logging.getLogger(__name__ + "_echo_through_log")
_log.propagate = False
h = logging.StreamHandler()
h.setLevel(os.environ.get("LOGLEVEL", "INFO"))
h.setFormatter(logging.Formatter("[%(asctime)s ECHO] - %(message)s", "%Y-%m-%d %H:%M:%S"))
_log.addHandler(h)


def echo_through_log(message=None, file=None, nl=True, err=False, color=None):
    _log.info(re.sub(r"\s+", " ", message).strip())


click.echo = echo_through_log

log = logging.getLogger(__name__)
log.propagate = False
h = logging.StreamHandler()
h.setLevel(os.environ.get("LOGLEVEL", "INFO"))
h.setFormatter(logging.Formatter("[%(asctime)s %(levelname)s] - %(message)s", "%Y-%m-%d %H:%M:%S"))
log.addHandler(h)


try:
    from types import SimpleNamespace as Namespace
except ImportError:
    from argparse import Namespace

app_state = None


def calculate_sha256(file_path: str):
    """Calculate SHA256 hash of a local file."""
    hash_sha256 = hashlib.sha256()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_sha256.update(chunk)
    return hash_sha256.hexdigest()


def upload_files_to_s3(
    file_paths: list[str],
    bucket_name: str,
    aws_access_key_id: str,
    aws_secret_access_key: str,
    folder: str = "",
    max_retries: int = 3,
    retry_delay: int = 2,
):
    """
    Upload files to S3 bucket, skipping files that already exist with matching hash.
    Handles both single-part and multipart uploads by storing SHA256 in metadata.

    Args:
        file_paths: List of local file paths (strings)
        bucket_name: Name of the S3 bucket
        aws_access_key_id: AWS access key ID
        aws_secret_access_key: AWS secret access key
        folder: Folder path inside the bucket (e.g., 'my-folder' or 'path/to/folder'). Default is root.
        max_retries: Maximum number of retry attempts for failed uploads. Default is 3.
        retry_delay: Delay in seconds between retry attempts. Default is 2.

    Returns:
        bool: True if all files were successfully uploaded or already exist, False otherwise
    """
    s3_client = boto3.client(
        "s3", aws_access_key_id=aws_access_key_id, aws_secret_access_key=aws_secret_access_key
    )

    # Ensure folder ends with '/' if provided and not empty
    if folder and not folder.endswith("/"):
        folder = folder + "/"

    # Get list of all existing objects in the bucket/folder
    try:
        existing_objects = set()
        paginator = s3_client.get_paginator("list_objects_v2")

        if folder:
            pages = paginator.paginate(Bucket=bucket_name, Prefix=folder)
        else:
            pages = paginator.paginate(Bucket=bucket_name)

        for page in pages:
            if "Contents" in page:
                for obj in page["Contents"]:
                    existing_objects.add(obj["Key"])
    except Exception:
        return False

    for file_path in file_paths:
        file_name = os.path.basename(file_path)
        s3_key = folder + file_name

        # Check if file exists locally
        if not os.path.exists(file_path):
            return False

        # Calculate local file hash
        try:
            local_sha256 = calculate_sha256(file_path)
        except Exception:
            return False

        # Check if file already exists in S3
        if s3_key in existing_objects:
            try:
                # Get object metadata
                response = s3_client.head_object(Bucket=bucket_name, Key=s3_key)

                # Check if we stored the SHA256 in metadata
                if "Metadata" in response and "sha256" in response["Metadata"]:
                    s3_sha256 = response["Metadata"]["sha256"]

                    # Compare hashes
                    if local_sha256 == s3_sha256:
                        log.info("Verified: {}...".format(file_name))
                        continue  # File already exists with same content, skip
            except Exception:
                return False

        # Upload the file with retry logic
        upload_success = False
        for attempt in range(max_retries):
            try:
                log.info("Uploading: {}...".format(file_name))
                # Upload with SHA256 stored in metadata
                s3_client.upload_file(
                    file_path, bucket_name, s3_key, ExtraArgs={"Metadata": {"sha256": local_sha256}}
                )
                upload_success = True
                break
            except Exception:
                if attempt < max_retries - 1:
                    time.sleep(retry_delay)
                else:
                    return False

        if not upload_success:
            return False

    return True


def generate_file_md5(filepath: str, blocksize: int = 2**16):
    m = hashlib.md5()
    with open(filepath, "rb") as f:
        while True:
            buf = f.read(blocksize)
            if not buf:
                break
            m.update(buf)
    return m.hexdigest()


def export_tifs(
    src: Path,
    targetdir: Path,
    begin_export_dekad: Dekad,
    end_export_dekad: Dekad,
    roi: List[float],
    region: str,
    **metadataOptions: Dict[str, str],
):
    exports = modis_window.callback(
        src=src,
        targetdir=targetdir,
        begin_date=begin_export_dekad.getDateTimeMid(),
        end_date=end_export_dekad.getDateTimeMid(),
        roi=[roi[0], roi[1], roi[2], roi[3]],
        region=region,
        sgrid=False,
        force_doy=False,
        filter_product=None,
        filter_vampc=None,
        target_srs="EPSG:4326",
        co=[
            "COMPRESS=LZW",
            "PREDICTOR=2",
            "TILED=YES",
            "BLOCKXSIZE=256",
            "BLOCKYSIZE=256",
        ],
        clip_valid=True,
        round_int=2,
        gdal_kwarg={
            "xRes": 0.01,
            "yRes": 0.01,
            "metadataOptions": [f"{key}={value}" for key, value in metadataOptions.items()],
        },
        overwrite=True,
        last_smoothed=None,
    )

    for exp in exports:
        md5 = generate_file_md5(exp)
        with contextlib.suppress(FileNotFoundError):
            os.remove(exp + ".md5")
        with open(exp + ".md5", "w") as f:
            f.write(md5)


def exists_smooth_h5s(product: str, tiles: list[str], basedir: str, collection: str):
    # MXD13A2
    # Check all tiles for a corresponding H5 archive in VIM/SMOOTH:
    return all(
        [
            Path(
                os.path.join(
                    basedir,
                    "VIM",
                    "SMOOTH",
                    "{}.{}.{}.txd.VIM.h5".format(product, tile, collection),
                )
            ).exists()
            for tile in tiles
        ]
    )


def app_index():
    global app_state
    if app_state.fetcherThread.is_alive() and not getattr(app_state, "suspended", False):
        return "Fetcher is running (or suspended), try again later\n", 503
    else:
        files = {}
        for f in sorted(
            glob.glob(
                os.path.join(app_state.basedir, "VIM", "SMOOTH", "EXPORT", app_state.file_pattern)
            )
        ):
            if os.path.isfile(f + ".md5"):
                with open(f + ".md5") as mdf:
                    files[os.path.basename(f)] = re.sub("\\s+", "", mdf.readline())
        return jsonify(files)


def app_download(filename: str):
    global app_state
    if app_state.fetcherThread.is_alive() and not getattr(app_state, "suspended", False):
        return "Fetcher is running (or suspended), try again later\n", 503
    else:
        try:
            return send_file(
                os.path.join(app_state.basedir, "VIM", "SMOOTH", "EXPORT", filename),
                as_attachment=True,
                mimetype=app_state.mimetype,
            )
        except FileNotFoundError:
            return ("", 404)


def app_fetch():
    global app_state
    if app_state.fetcherThread.is_alive() or getattr(app_state, "suspended", False):
        return (
            "[{}] Fetcher is already running (or suspended), try again later\n".format(
                datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            ),
            503,
        )
    else:
        # Check all tiles for a corresponding H5 archive in VIM/SMOOTH:
        if not exists_smooth_h5s(
            app_state.product,
            app_state.tile_filter,
            app_state.basedir,
            getattr(app_state, "collection", "006"),
        ):
            app_state.fetcherThread = Timer(5, app_do_init, ())
            app_state.fetcherThread.start()
            return "[{}] Initialisation is scheduled to start (or resume) in 5 seconds...\n".format(
                datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            )
        else:
            app_state.fetcherThread = Timer(5, app_do_processing, ())
            app_state.fetcherThread.start()
            return "[{}] Fetching and processing is scheduled to start in 5 seconds...\n".format(
                datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            )


def app_suspend():
    global app_state
    app_state.suspended = True
    if app_state.fetcherThread.is_alive():
        return (
            "Fetcher is busy suspending; please check back later to see the suspended state confirmed...\n",
            503,
        )
    else:
        s = "[{}] Fetcher suspended; restart service to resume production.\n".format(
            datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        )
        log.info(s)
        return s


def app_log(filename: str):
    global app_state
    try:
        return send_file(
            os.path.join(app_state.basedir, "log", filename),
            as_attachment=False,
            mimetype="text/plain",
        )
    except FileNotFoundError:
        return (f"No such log: {filename}\n", 404)


def app_do_init():
    global app_state
    do_init(app_state)


def app_do_processing():
    global app_state
    do_processing(app_state)


def do_processing(args: Namespace, only_one_inc=False):
    # download and ingest:
    while True:
        last_date = get_last_date_in_raw_modis_tiles(os.path.join(args.basedir, "VIM"))
        next_date = last_date + relativedelta(days=8)
        if last_date.year < next_date.year:
            # handle turning of the year:
            next_date = datetime(next_date.year, 1, 1).date()

        if getattr(args, "download_only", False) or (
            not getattr(args, "collect_only", False)
            and not getattr(args, "smooth_only", False)
            and not getattr(args, "export_only", False)
        ):
            if next_date > date.today():  # stop after today:
                break

            log.info("Downloading: {}...".format(next_date))
            downloaded = modis_download.callback(
                products=[args.product],
                begin_date=datetime.combine(next_date, datetime.min.time()),
                end_date=datetime.combine(next_date, datetime.min.time()),
                targetdir=args.basedir,
                roi=None,
                target_empty=False,
                tile_filter=",".join(args.tile_filter),
                username=args.username,
                password=args.password,
                match_begin=True,
                print_results=False,
                download=True,
                overwrite=True,
                robust=True,
                max_retries=-1,
                multithread=True,
                nthreads=4,
                collection=getattr(args, "collection", "006"),
                mirror=getattr(args, "mirror", None),
            )

            # anything downloaded?
            if len(downloaded) < 1 or getattr(args, "download_only", False):
                if len(downloaded) < 1 and getattr(args, "expected_latency", 0) > 0:
                    latency = datetime.now() - datetime.combine(
                        next_date + relativedelta(days=16), datetime.min.time()
                    )
                    if latency.total_seconds() > getattr(args, "expected_latency"):
                        post(
                            "{}?{}".format(
                                getattr(
                                    args,
                                    "log_endpoint",
                                    "https://api.africariskview.org/log",
                                ),
                                urlencode(
                                    {
                                        "secret": getattr(args, "log_secret", "TTY665DE9U"),
                                        "source": getattr(args, "log_source", "MODAPE Chain"),
                                        "channel": getattr(args, "log_channel", "DATASETS"),
                                        "topic": "Latency",
                                        "level": 4,
                                        "msg": "Unexpected delay",
                                    }
                                ),
                            ),
                            data="All tiles for the following MODIS time step have unexpected delay: {}".format(
                                next_date
                            ),
                        )
                        log.info(
                            "An error was send for this time step having excessive delay: {}".format(
                                next_date
                            )
                        )
                break  # while True

        if getattr(args, "collect_only", False) or (
            not getattr(args, "smooth_only", False) and not getattr(args, "export_only", False)
        ):
            # check download completeness:
            curated = curate_downloads(args.basedir, args.tile_filter, next_date, next_date)
            if not len(curated):
                latency = datetime.now() - datetime.combine(
                    next_date + relativedelta(days=16), datetime.min.time()
                )
                if latency.total_seconds() > getattr(args, "expected_latency"):
                    post(
                        "{}?{}".format(
                            getattr(
                                args,
                                "log_endpoint",
                                "https://api.africariskview.org/log",
                            ),
                            urlencode(
                                {
                                    "secret": getattr(args, "log_secret", "TTY665DE9U"),
                                    "source": getattr(args, "log_source", "MODAPE Chain"),
                                    "channel": getattr(args, "log_channel", "DATASETS"),
                                    "topic": "Latency",
                                    "level": 4,
                                    "msg": "Unexpected delay",
                                }
                            ),
                        ),
                        data="Some tiles for the following MODIS time step have unexpected delay: {}".format(
                            next_date
                        ),
                    )
                    log.info(
                        "An error was send for some required tiles for this timestep having excessive delay: {}".format(
                            next_date
                        )
                    )
                break

            # Push curated set of files to S3:
            if (
                len(getattr(args, "bucket", "")) > 0
                and len(getattr(args, "aws_access_key_id", "")) > 0
                and len(getattr(args, "aws_secret_access_key", "")) > 0
            ):
                match = re.match(r"[Ss]3://([^/]+)/(.+)", getattr(args, "bucket", ""))
                if match:
                    upload_files_to_s3(
                        curated,
                        match.group(1),
                        getattr(args, "aws_access_key_id", ""),
                        getattr(args, "aws_secret_access_key", ""),
                        match.group(2),
                    )

            # We're OK; now collect;
            modis_collect.callback(
                src_dir=args.basedir,
                targetdir=args.basedir,  # modape appends VIM to the targetdir
                compression="gzip",
                vam_code="VIM",
                interleave=True,
                parallel_tiles=1,
                cleanup=True,
                force=False,
                last_collected=None,
                tiles_required=",".join(args.tile_filter),
                report_collected=False,
            )

            if getattr(args, "collect_only", False):
                break

        # smooth by N/n
        if getattr(args, "smooth_only", False) or (not getattr(args, "export_only", False)):
            modis_smooth.callback(
                src=os.path.join(args.basedir, "VIM"),
                targetdir=os.path.join(args.basedir, "VIM", "SMOOTH"),
                svalue=None,
                srange=[],
                pvalue=None,
                tempint=10,
                tempint_start=None,
                nsmooth=args.nsmooth,
                nupdate=args.nupdate,
                soptimize=None,
                sgrid=None,
                parallel_tiles=1,
                last_collected=None,
            )

            if getattr(args, "smooth_only", False):
                break

        # export dekads, from back to front:
        nexports = 1
        export_octad = ModisInterleavedOctad(
            get_last_date_in_raw_modis_tiles(os.path.join(args.basedir, "VIM"))
        )
        export_dekad = Dekad(export_octad.getDateTimeEnd(), True)

        while (
            Dekad(export_octad.prev().getDateTimeEnd(), True).Equals(export_dekad)
            and nexports <= args.nupdate
        ):
            nexports = nexports + 1
            export_octad = export_octad.prev()

        first_date = get_first_date_in_raw_modis_tiles(os.path.join(args.basedir, "VIM"))
        while (not export_dekad.startsBeforeDate(first_date)) and nexports <= args.nupdate:
            for region, roi in args.export.items():
                if getattr(args, "region_only", region) != region:
                    continue
                export_tifs(
                    os.path.join(args.basedir, "VIM", "SMOOTH"),
                    os.path.join(args.basedir, "VIM", "SMOOTH", "EXPORT"),
                    export_dekad,
                    export_dekad,
                    roi,
                    region,
                    CONSOLIDATION_STAGE=f"{nexports - 1}",
                    FINAL=f"{'FALSE' if nexports < args.nupdate else 'TRUE'}",
                )

            nexports = nexports + 1
            export_octad = export_octad.prev()
            export_dekad = Dekad(export_octad.getDateTimeEnd(), True)
            while (
                Dekad(export_octad.prev().getDateTimeEnd(), True).Equals(export_dekad)
                and nexports <= args.nupdate
            ):
                nexports = nexports + 1
                export_octad = export_octad.prev()

        if only_one_inc or getattr(args, "export_only", False):
            break  # while True


def app_setup(config: str) -> Flask:
    global app_state
    with open(config) as f:
        app_state = json.load(f)
    app_state = Namespace(**app_state)

    flask_app = Flask(app_state.app_name)
    flask_app.config["JSONIFY_PRETTYPRINT_REGULAR"] = True
    flask_app.add_url_rule("/fetch", "fetch", app_fetch)
    flask_app.add_url_rule("/suspend", "suspend", app_suspend)
    flask_app.add_url_rule("/download/<filename>", "download", app_download)
    flask_app.add_url_rule("/log/<filename>", "log", app_log)
    flask_app.add_url_rule("/", "index", app_index)
    app_state.fetcherThread = Thread()
    return flask_app


@click.group(invoke_without_command=True)
@click.option("--debug/--no-debug", default=False)
@click.option("--region")
@click.option("--config")
@click.pass_context
def cli(ctx: click.core.Context, config, region, debug):
    ctx.ensure_object(dict)
    ctx.obj["CONFIG"] = config
    ctx.obj["REGION"] = region
    ctx.obj["DEBUG"] = debug
    if ctx.invoked_subcommand is None:
        ctx.invoke(serve)


@cli.command()
@click.pass_context
def serve(ctx: click.core.Context) -> None:
    if ctx.obj["DEBUG"]:
        with open(ctx.obj["CONFIG"]) as f:
            args = json.load(f)
        args = Namespace(**args)
        if not exists_smooth_h5s(
            app_state.product, args.tile_filter, args.basedir, getattr(args, "collection", "006")
        ):
            raise SystemExit(
                "Cannot run a full time step increment on an uninitialised archive! Run the init command first or run "
                "as a service. "
            )
        else:
            if ctx.obj["REGION"]:
                args.region_only = ctx.obj["REGION"]
            do_processing(args, only_one_inc=True)
    else:
        flask_app = app_setup(ctx.obj["CONFIG"])
        assert ctx.obj["REGION"] is None, (
            "Cannot serve only a specific region! Please run with the debug flag."
        )
        flask_app.run(port=5001, threaded=False)  # Configure for single threaded request handling


@cli.command()
@click.pass_context
def export(ctx: click.core.Context) -> None:
    with open(ctx.obj["CONFIG"]) as f:
        args = json.load(f)
    args = Namespace(**args)

    # Check all tiles for a corresponding H5 archive in VIM/SMOOTH:
    assert exists_smooth_h5s(
        app_state.product, args.tile_filter, args.basedir, getattr(args, "collection", "006")
    )

    if ctx.obj["REGION"]:
        args.region_only = ctx.obj["REGION"]
    args.export_only = True
    do_processing(args)


@cli.command()
@click.pass_context
def smooth(ctx: click.core.Context) -> None:
    with open(ctx.obj["CONFIG"]) as f:
        args = json.load(f)
    args = Namespace(**args)

    assert ctx.obj["REGION"] is None, "Cannot smooth for only a specific region!"
    args.smooth_only = True
    do_processing(args)


@cli.command()
@click.pass_context
def collect(ctx: click.core.Context) -> None:
    with open(ctx.obj["CONFIG"]) as f:
        args = json.load(f)
    args = Namespace(**args)
    assert ctx.obj["REGION"] is None, "Cannot collect for only a specific region!"
    args.collect_only = True
    do_processing(args)


@cli.command()
@click.pass_context
def download(ctx: click.core.Context) -> None:
    with open(ctx.obj["CONFIG"]) as f:
        args = json.load(f)
    args = Namespace(**args)
    assert ctx.obj["REGION"] is None, "Cannot download for only a specific region!"
    args.download_only = True
    do_processing(args)


@cli.command()
@click.pass_context
@click.option("--only-one-inc", is_flag=True, default=False)
def forward(ctx: click.core.Context, only_one_inc: bool) -> None:
    with open(ctx.obj["CONFIG"]) as f:
        args = json.load(f)
    args = Namespace(**args)
    assert ctx.obj["REGION"] is None, "Cannot download for only a specific region!"
    do_processing(args, only_one_inc)


@cli.command()
@click.pass_context
def reset(ctx: click.core.Context) -> None:
    with open(ctx.obj["CONFIG"]) as f:
        args = json.load(f)
    args = Namespace(**args)
    assert ctx.obj["REGION"] is None, "Cannot reset for only a specific region!"
    while os.path.isdir(args.basedir):
        sure = (
            input("Flushing the entire production environment. Are you sure? [y/n]: ")
            .lower()
            .strip()
        )
        if sure == "y" or sure == "yes":
            shutil.rmtree(args.basedir)
            break
        elif sure == "n" or sure == "no":
            log.info("Aborted.")
            break
    os.makedirs(os.path.join(args.basedir, "log"))
    log.info("Done.")


@cli.command()
@click.pass_context
def check(ctx: click.core.Context) -> None:
    with open(ctx.obj["CONFIG"]) as f:
        args = json.load(f)
    args = Namespace(**args)
    assert ctx.obj["REGION"] is None, "Cannot reset for only a specific region!"

    products = []
    for product_code in products:
        if str(args.product).upper().startswith("M?D"):
            products.append(f"MOD{str(args.product)[3:]}".upper())
            products.append(f"MYD{str(args.product)[3:]}".upper())
        else:
            products.append(str(args.product).upper())

    begin_date = ModisInterleavedOctad(datetime.strptime(args.init_start_date, "%Y-%m-%d").date())
    end_date = min([date.today(), begin_date.nextYear().prev().getDateTimeStart().date()])
    begin_date = begin_date.getDateTimeStart().date()
    while begin_date < end_date:
        log.info("Querying: {} - {}...".format(begin_date, end_date))
        q = ModisQuery(
            products=products,
            aoi=None,
            begindate=datetime.combine(begin_date, datetime.min.time()),
            enddate=datetime.combine(end_date, datetime.min.time()),
            tile_filter=",".join(args.tile_filter),
            version=args.collection,
        )
        q.search(match_begin=True)
        if q.nresults == 0:
            log.info(
                "No results found! Please check query or make sure CMR is available / reachable."
            )
        else:
            log.info(f"Found {q.nresults} results!")

        all_dates = set()
        tile_dates = {}
        for values in q.results.values():
            dte = "{}".format(values["time_start"])
            all_dates.add(dte)
            if values["tile"] not in tile_dates:
                tile_dates[values["tile"]] = []
            tile_dates[values["tile"]].append(dte)

        for tile, dte in itertools.product(args.tile_filter, all_dates):
            if dte not in tile_dates[tile]:
                log.error("Missing {} for tile {}".format(dte, tile))

        # move on:
        begin_date = ModisInterleavedOctad(end_date).next()
        end_date = min([date.today(), begin_date.nextYear().prev().getDateTimeStart().date()])
        begin_date = begin_date.getDateTimeStart().date()


@cli.command()
@click.option("--download-only", is_flag=True, default=False)
@click.option("--download-and-collect-only", is_flag=True, default=False)
@click.option("--smooth-only", is_flag=True, default=False)
@click.option("--export-only", is_flag=True, default=False)
@click.option(
    "-b",
    "--export-begin-date",
    type=click.DateTime(formats=["%Y-%m-%d"]),
    help="Begin date for export",
)
@click.option(
    "-e", "--export-end-date", type=click.DateTime(formats=["%Y-%m-%d"]), help="End date for export"
)
@click.pass_context
def init(
    ctx: click.core.Context,
    download_only,
    download_and_collect_only,
    smooth_only,
    export_only,
    export_begin_date,
    export_end_date,
) -> None:
    with open(ctx.obj["CONFIG"]) as f:
        args = json.load(f)
    args = Namespace(**args)

    if ctx.obj["REGION"] is not None:
        assert export_only and exists_smooth_h5s(
            app_state.product, args.tile_filter, args.basedir, getattr(args, "collection", "006")
        ), "Can only do export for a specific region on a initialised archive!"
        args.region_only = ctx.obj["REGION"]

    args.download_only = download_only
    args.download_and_collect_only = download_and_collect_only
    args.smooth_only = smooth_only
    args.export_only = export_only
    args.export_begin_date = export_begin_date
    args.export_end_date = export_end_date
    do_init(args)


def do_init(args: Namespace):
    if not getattr(args, "smooth_only", False) and not getattr(args, "export_only", False):
        # Download and Collect:
        # ---------------------

        begin_date = get_last_date_in_raw_modis_tiles(os.path.join(args.basedir, "VIM"))
        if begin_date is None:
            begin_date = ModisInterleavedOctad(
                datetime.strptime(args.init_start_date, "%Y-%m-%d").date()
            )
        else:
            begin_date = ModisInterleavedOctad(begin_date).next()

        end_date = datetime.strptime(args.init_end_date, "%Y-%m-%d").date()
        if not getattr(args, "download_only", False):
            # We can do incremental processing if we're not restricted to downloading only:
            end_date = min([end_date, begin_date.nextYear().prev().getDateTimeStart().date()])

        begin_date = begin_date.getDateTimeStart().date()
        while begin_date <= end_date:
            if getattr(args, "suspended", False):
                return

            log.info("Downloading: {} - {}...".format(begin_date, end_date))
            downloads = modis_download.callback(
                products=[args.product],
                begin_date=datetime.combine(begin_date, datetime.min.time()),
                end_date=datetime.combine(end_date, datetime.min.time()),
                targetdir=args.basedir,
                roi=None,
                target_empty=False,
                tile_filter=",".join(args.tile_filter),
                username=args.username,
                password=args.password,
                match_begin=True,
                print_results=False,
                download=True,
                overwrite=False,
                robust=True,
                max_retries=-1,
                multithread=True,
                nthreads=4,
                collection=getattr(args, "collection", "006"),
                mirror=getattr(args, "mirror", None),
            )
            if len(downloads) == 0:
                break

            # Check: all downloads are found on disk?
            any_download_missing = False
            for filename in downloads:
                if not os.path.exists(os.path.join(args.basedir, filename)):
                    log.error("Download missing on disk: {}".format(filename))
                    any_download_missing = True
            if any_download_missing:
                return

            # Check download: for ALL distinct dates: is there a download for EACH selected tile? 2022-03-11: we allow 1 missing
            curated = curate_downloads(args.basedir, args.tile_filter, begin_date, end_date, 0)
            if not len(curated):
                return

            # Push curated set of files to S3:
            if (
                len(getattr(args, "bucket", "")) > 0
                and len(getattr(args, "aws_access_key_id", "")) > 0
                and len(getattr(args, "aws_secret_access_key", "")) > 0
            ):
                match = re.match(r"[Ss]3://([^/]+)/(.+)", getattr(args, "bucket", ""))
                if match:
                    upload_files_to_s3(
                        curated,
                        match.group(1),
                        getattr(args, "aws_access_key_id", ""),
                        getattr(args, "aws_secret_access_key", ""),
                        match.group(2),
                    )

            if getattr(args, "download_only", False):
                return

            # We're OK; now collect;
            modis_collect.callback(
                src_dir=args.basedir,
                targetdir=args.basedir,  # modape appends VIM to the targetdir
                compression="gzip",
                vam_code="VIM",
                interleave=True,
                parallel_tiles=1,
                cleanup=True,
                force=False,
                last_collected=None,
                tiles_required=",".join(args.tile_filter),
                report_collected=True,
            )

            # move on:
            begin_date = get_last_date_in_raw_modis_tiles(os.path.join(args.basedir, "VIM"))
            begin_date = ModisInterleavedOctad(begin_date).next()
            end_date = min(
                [
                    datetime.strptime(args.init_end_date, "%Y-%m-%d").date(),
                    begin_date.nextYear().prev().getDateTimeStart().date(),
                ]
            )
            begin_date = begin_date.getDateTimeStart().date()

    if getattr(args, "download_and_collect_only", False) or getattr(args, "download_only", False):
        return

    if not exists_smooth_h5s(
        args.product, args.tile_filter, args.basedir, getattr(args, "collection", "006")
    ):
        # Smooth and interpolate the collected archive
        # --------------------------------------------

        # Check if the raw grid stacks (each tile) contain (and *only* contain) the configured date range
        # for initialisation: init_start_date -- init_end_date:
        begin_date = datetime.strptime(args.init_start_date, "%Y-%m-%d").date()
        end_date = datetime.strptime(args.init_end_date, "%Y-%m-%d").date()
        dates = []
        ts = ModisInterleavedOctad(begin_date)
        while ts.getDateTimeStart().date() < begin_date:
            ts = ts.next()
        while ts.getDateTimeStart().date() <= end_date:
            dates.append(str(ts))
            ts = ts.next()
        tile_has_collected_dates: dict[str, bool] = {}
        for tile in args.tile_filter:
            tile_has_collected_dates[tile] = has_collected_dates(
                os.path.join(
                    args.basedir,
                    "VIM",
                    "{}.{}.{}.VIM.h5".format(
                        args.product, tile, getattr(args, "collection", "006")
                    ),
                ),
                dates,
            )

        for tile, _has_collected_dates in tile_has_collected_dates.items():
            if not _has_collected_dates:
                log.info("Raw .h5 archive for tile {} is incomplete".format(tile))
        assert all(tile_has_collected_dates.values())

        modis_smooth.callback(
            src=os.path.join(args.basedir, "VIM"),
            targetdir=os.path.join(args.basedir, "VIM", "SMOOTH"),
            svalue=None,
            srange=[],
            pvalue=None,
            tempint=10,
            tempint_start=None,
            nsmooth=0,
            nupdate=0,
            soptimize=True,
            sgrid=None,
            parallel_tiles=1,
            last_collected=datetime.strptime(dates[-1], "%Y%j"),
        )

        if getattr(args, "smooth_only", False):
            return

    # Export smoothened slices
    # ------------------------

    # Check all tiles for a corresponding H5 archive in VIM/SMOOTH:
    assert exists_smooth_h5s(
        args.product, args.tile_filter, args.basedir, getattr(args, "collection", "006")
    )

    export_octad = ModisInterleavedOctad(
        get_last_date_in_raw_modis_tiles(os.path.join(args.basedir, "VIM"))
    )
    export_end_dekad = Dekad(export_octad.getDateTimeEnd(), True)
    nexports = 1
    while nexports < args.nupdate or (
        Dekad(export_octad.prev().getDateTimeEnd(), True).Equals(export_end_dekad)
        and nexports < (args.nupdate - 1)
    ):
        nexports += 1
        export_octad = export_octad.prev()
        export_end_dekad = Dekad(export_octad.getDateTimeEnd(), True)

    first_date = max(
        [
            get_first_date_in_raw_modis_tiles(os.path.join(args.basedir, "VIM")),
            datetime.strptime(args.init_start_date, "%Y-%m-%d").date(),
        ]
    )
    export_start_dekad = Dekad(first_date)
    while export_start_dekad.startsBeforeDate(first_date):
        export_start_dekad = export_start_dekad.next()

    for region, roi in args.export.items():
        if getattr(args, "region_only", region) != region:
            continue
        log.info(
            "{} -- Exporting {} to {} ...".format(
                region, str(export_start_dekad), str(export_end_dekad)
            )
        )
        export_tifs(
            os.path.join(args.basedir, "VIM", "SMOOTH"),
            os.path.join(args.basedir, "VIM", "SMOOTH", "EXPORT"),
            export_start_dekad,
            export_end_dekad,
            roi,
            region,
            FINAL="TRUE",
        )


if __name__ == "__main__":
    this_dir, _ = os.path.split(__file__)
    cli(default_map={"config": os.path.join(this_dir, "production.json")})
