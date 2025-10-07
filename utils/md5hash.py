#!/bin/python
import contextlib
import hashlib
import os
import sys
from pathlib import Path

import click


@click.command()
@click.argument(
    "targetdir",
    type=click.Path(dir_okay=True, writable=True, resolve_path=True),
)
@click.argument(
    "globexp",
    type=click.STRING,
)
def cli(targetdir: str, globexp: str):
    def generate_file_md5(filepath: str, blocksize: int = 2**16):
        m = hashlib.md5()
        with open(filepath, "rb") as f:
            while True:
                buf = f.read(blocksize)
                if not buf:
                    break
                m.update(buf)
        return m.hexdigest()

    for f in [str(x) for x in Path(targetdir).glob(globexp)]:
        md5 = generate_file_md5(f)
        with contextlib.suppress(FileNotFoundError):
            os.remove(f + ".md5")
        with open(f + ".md5", "w") as f:
            f.write(md5)


def cli_wrap():
    """Wrapper for cli"""

    if len(sys.argv) == 1:
        cli.main(["--help"])
    else:
        cli()  # pylint: disable=E1120


if __name__ == "__main__":
    cli_wrap()
