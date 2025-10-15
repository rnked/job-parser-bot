from __future__ import annotations

import click
from loguru import logger

APP = "pathfinder"


@click.group(context_settings={"help_option_names": ["-h", "--help"]})
@click.version_option(package_name="pathfinder")
def cli() -> None:
    """pathfinder."""


@cli.command()
@click.option("--config", "config_path", type=click.Path(path_type=str))
def run(config_path: str | None) -> None:
    logger.info("run: config={}", config_path or "none")


def main() -> None:
    cli(prog_name=APP)
