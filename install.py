#!/usr/bin/python3
from __future__ import annotations

import sys

if (sys.version_info.major, sys.version_info.minor) < (3, 11):
    print("error: This script requires Python 3.11 or later", file=sys.stderr)
    sys.exit(1)

CONFIGS = """
    XCompose .XCompose
    alacritty.yml .config/alacritty/alacritty.yml
    alsoftrc .alsoftrc
    bash_profile .bash_profile
    bashrc .bashrc
    bin bin
    electron-flags.conf .config/electron-flags.conf
    electron15-flags.conf .config/electron15-flags.conf
    environment.conf .config/environment.d/environment.conf
    fonts.conf .config/fontconfig/fonts.conf
    gammastep.ini .config/gammastep/config.ini
    gemrc .gemrc
    gitconfig .gitconfig
    gtk-3.0-settings.ini .config/gtk-3.0/settings.ini
    gtk-4.0-settings.ini .config/gtk-4.0/settings.ini
    gtkrc-2.0 .gtkrc-2.0
    hyprland.conf .config/hypr/hyprland.conf
    imv .config/imv/config
    index.theme .local/share/icons/default/index.theme
    inputrc .inputrc
    ipython_config.py .ipython/profile_default/ipython_config.py
    kitty.conf .config/kitty/kitty.conf
    mpv.conf .config/mpv/mpv.conf
    nvim .config/nvim
    pipewire/10-zeroconf.conf .config/pipewire/pipewire.conf.d/10-zeroconf.conf
    profile .profile
    pythonrc .pythonrc
    swaylock .config/swaylock/config
    tmux.conf .tmux.conf
    user-dirs.dirs .config/user-dirs.dirs
    wezterm.lua .config/wezterm/wezterm.lua
    sway .config/sway/config
    waybar .config/waybar/config
    waybar.css .config/waybar/style.css
    wayfire.ini .config/wayfire.ini
"""

import logging
import os
import tomllib
from argparse import ArgumentParser, Namespace
from dataclasses import asdict, dataclass
from enum import Enum, auto
from pathlib import Path
from subprocess import PIPE, run
from textwrap import dedent

logger = logging.getLogger()


def main() -> int:
    args = parse_args()
    configure_logging(logging.DEBUG)
    os.chdir(os.path.dirname(__file__))
    env = Environment.load()
    logger.debug("Loaded env: %s", env)

    if args.packages:
        install_packages(env)
    install_configs()


def parse_args() -> Namespace:
    parser = ArgumentParser()
    parser.add_argument("--packages", action="store_true")
    return parser.parse_args()


def configure_logging(level: logging.Level) -> None:
    logging.basicConfig(format="%(levelname)7s %(message)s", level=level)


@dataclass
class Environment:
    desktop: Desktop
    os: OS
    theme: Theme

    def __str__(self) -> str:
        pairs = [f"{key}={value}" for key, value in asdict(self).items()]
        return f"Environment({', '.join(pairs)})"

    @classmethod
    def load(cls) -> Self:
        rawconfig = cls.read_config_toml()
        desktop = Desktop[rawconfig.get("desktop", "gnome").upper()]
        theme = Theme[rawconfig.get("theme", "light").upper()]

        os = cls.determine_os()

        return cls(
            desktop=desktop,
            os=os,
            theme=theme,
        )

    @staticmethod
    def determine_os() -> OS:
        try:
            os_release = Path("/etc/os-release").read_text()
        except FileNotFoundError:
            pass
        else:
            if "Arch Linux" in os_release:
                return OS.ARCH
            elif "Fedora Linux" in os_release:
                return OS.FEDORA
        return OS.OTHER

    @staticmethod
    def read_config_toml() -> dict[str, bool | str]:
        try:
            data = Path("config.toml").read_text()
        except FileNotFoundError:
            return {}
        return tomllib.loads(data)


class Desktop(Enum):
    GNOME = auto()
    HYPRLAND = auto()
    SWAY = auto()
    WAYFIRE = auto()


class OS(Enum):
    ARCH = auto()
    FEDORA = auto()
    OTHER = auto()


class Theme(Enum):
    DARK = auto()
    LIGHT = auto()


def install_packages(env: Environment) -> None:
    if env.os != OS.ARCH:
        logger.debug("Skipping package installation on non-Arch OS")
        return
    logger.warning("Package installation isn't implemented yet")


def install_configs() -> None:
    configs = parse_configs()
    for config in configs:
        if config.is_template:
            logger.warning("Skipping template config %s", config)
            result, message = render_template(config.source, config.dest)
        else:
            result, message = ensure_symlink(config.source, config.dest)
            result.log(config, message)


def render_template(source: Path, dest: Path) -> tuple[Result, str | None]:
    ...


def ensure_symlink(source: Path, dest: Path) -> tuple[Result, str | None]:
    dest_to_source_relpath = os.path.relpath(source, start=dest.parent)
    if dest.is_symlink():
        if os.readlink(dest) == dest_to_source_relpath:
            return (Result.OK, None)
        else:
            return (Result.ERROR, f"dest is already a symlink")
    elif dest.is_dir():
        return (Result.ERROR, f"dest is already a directory")
    elif dest.exists() and not dest.is_file():
        return (Result.ERROR, f"dest exists but is not a symlink, directory, or file")
    else:
        if dest.is_file():
            dest_old = dest.with_name(dest.name + ".old")
            logger.debug("mv %r -> %r", str(dest), str(dest_old))
            dest.rename(dest_old)
        dest_to_source_relpath = os.path.relpath(source, start=dest.parent)
        logger.debug("ln -s %r %r", dest_to_source_relpath, str(dest))
        dest.symlink_to(dest_to_source_relpath)
        return (Result.CHANGED, None)


class Result(Enum):
    OK = auto()
    CHANGED = auto()
    ERROR = auto()

    def log(self, config: Config, message: str) -> str:
        message = f" {message}" if message is not None else ""
        match self:
            case Result.OK:
                logger.info("\033[1mok\033[22m \033[32m%s\033[39m%s", config, message)
            case Result.CHANGED:
                logger.info(
                    "\033[1mchanged\033[22m \033[33m%s\033[39m%s", config, message
                )
            case Result.ERROR:
                logger.info(
                    "\033[1merror\033[22m \033[31m%s\033[39m%s", config, message
                )


@dataclass
class Config:
    source: Path
    dest: Path
    is_template: bool

    def __str__(self) -> str:
        return str(self.dest.relative_to(Path.home()))


def parse_configs() -> list[Config]:
    configs = []
    for line in dedent(CONFIGS).strip().splitlines():
        source, dest = line.split(maxsplit=1)
        source = Path(source)
        dest = Path.home() / dest
        source_template = source.with_name(source.name + ".mustache")
        is_template = False
        if source.exists() and source_template.exists():
            logger.warning(
                "Skipping config %r because both raw file and template exist", source
            )
            continue
        elif not source.exists() and not source_template.exists():
            logger.warning("Skipping config %r because it doesn't exist", source)
            continue
        elif not source.exists() and source_template.exists():
            source = source_template
            is_template = True
        configs.append(Config(source, dest, is_template))
    return configs


def green(s: Any) -> str:
    return f"\033[32m{s}\033[39m"


if __name__ == "__main__":
    sys.exit(main())
