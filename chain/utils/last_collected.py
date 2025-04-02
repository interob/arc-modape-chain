import sys
from pathlib import Path

import click

from modape.modis import ModisSmoothH5


@click.command()
@click.argument(
    "targetdir",
    type=click.Path(dir_okay=True, writable=True, resolve_path=True),
)
def cli(
    targetdir: str,
):
    last_collected = set()
    for rawfile in [str(x) for x in Path(targetdir).joinpath("VIM").glob("*.h5")]:
        smt_h5 = ModisSmoothH5(str(rawfile), "")
        last_collected.add(smt_h5.last_collected)

    print("".join(last_collected))


def cli_wrap():
    """Wrapper for cli"""

    if len(sys.argv) == 1:
        cli.main(["--help"])
    else:
        cli()  # pylint: disable=E1120


if __name__ == "__main__":
    cli_wrap()
