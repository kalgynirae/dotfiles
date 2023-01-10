#!/usr/bin/python3
from __future__ import annotations

import sys

if (sys.version_info.major, sys.version_info.minor) < (3, 10):
    print("error: This script requires Python 3.11 or later", file=sys.stderr)
    sys.exit(1)

import logging
import os
import socket
import tomli
from argparse import ArgumentParser, Namespace
from dataclasses import asdict, dataclass
from difflib import unified_diff
from enum import Enum, auto
from pathlib import Path
from shutil import copyfile
import subprocess
import shlex
from tempfile import NamedTemporaryFile
from textwrap import dedent

from jinja2 import Template

CONFIGS = {
    ".XCompose": "XCompose",
    ".alsoftrc": "alsoftrc",
    ".bash_profile": "bash_profile",
    ".bashrc": "bashrc",
    ".config/alacritty/alacritty.yml": "alacritty.yml.jinja",
    ".config/electron-flags.conf": "electron-flags.conf",
    ".config/electron15-flags.conf": "electron15-flags.conf",
    ".config/environment.d/environment.conf": "environment.conf",
    ".config/fontconfig/fonts.conf": "fonts.conf",
    ".config/gammastep/config.ini": "gammastep.ini.jinja",
    ".config/gtk-3.0/settings.ini": "gtk-3.0-settings.ini.jinja",
    ".config/gtk-4.0/settings.ini": "gtk-4.0-settings.ini",
    ".config/helix/config.toml": "helix.toml",
    ".config/helix/languages.toml": "helix-languages.toml",
    ".config/hypr/hyprland.conf": "hyprland.conf.jinja",
    ".config/imv/config": "imv",
    ".config/kitty/kitty.conf": "kitty.conf.jinja",
    ".config/mpv/mpv.conf": "mpv.conf",
    ".config/nvim": "nvim",
    ".config/pipewire/pipewire.conf.d/10-zeroconf.conf": "pipewire/10-zeroconf.conf",
    ".config/sway/config": "sway.jinja",
    ".config/swaylock/config": "swaylock",
    ".config/user-dirs.dirs": "user-dirs.dirs",
    ".config/waybar/config": "waybar.jinja",
    ".config/waybar/style.css": "waybar.css",
    ".config/wayfire.ini": "wayfire.ini.jinja",
    ".config/wezterm/wezterm.lua": "wezterm.lua.jinja",
    ".gemrc": "gemrc",
    ".gitconfig": "gitconfig",
    ".gtkrc-2.0": "gtkrc-2.0",
    ".inputrc": "inputrc",
    ".ipython/profile_default/ipython_config.py": "ipython_config.py",
    ".local/share/icons/default/index.theme": "index.theme.jinja",
    ".profile": "profile",
    ".pythonrc": "pythonrc",
    ".tmux.conf": "tmux.conf",
}
CONFIGS |= {f".local/share/{p}": str(p) for p in Path("applications").iterdir()}
CONFIGS |= {str(p).removesuffix(".jinja"): str(p) for p in Path("bin").iterdir()}
CONFIGS |= {
    f".config/systemd/user/{p.name}".removesuffix(".jinja"): str(p)
    for p in Path("units").iterdir()
}

environment = None
logger = logging.getLogger()


def main() -> int:
    args = parse_args()
    configure_logging(logging.DEBUG)
    os.chdir(os.path.dirname(__file__))

    global environment
    environment = Environment.load(dry_run=args.dry_run)
    logger.debug("Loaded env: %s", environment)

    if args.packages:
        install_packages()
    install_configs()
    apply_settings()
    compile_terminfo()
    reload_things()


def parse_args() -> Namespace:
    parser = ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--packages", action="store_true")
    return parser.parse_args()


def configure_logging(level: logging.Level) -> None:
    logging.basicConfig(format="%(levelname)7s %(message)s", level=level)


@dataclass
class Environment:
    dry_run: bool
    desktop: Desktop
    host: Host
    os: OS
    theme: Theme
    cursor_blink: bool
    cursor_size: int
    cursor_theme: str
    keyrepeat_delay: int
    keyrepeat_rate: int
    terminal_app: str

    def __str__(self) -> str:
        pairs = [f"{key}={value}" for key, value in asdict(self).items()]
        return f"Environment({', '.join(pairs)})"

    def as_context(self) -> dict[str, str]:
        context = {}
        for key, value in asdict(self).items():
            if isinstance(value, Enum):
                context[key] = value.name.lower().replace("_", "-")
            else:
                context[key] = value
        return context

    @classmethod
    def load(cls, dry_run: bool) -> Self:
        config = cls.read_config_toml()
        host = cls.determine_host()
        os = cls.determine_os()
        return cls(
            dry_run=dry_run,
            desktop=Desktop[config.get("desktop", "gnome").upper()],
            host=host,
            os=os,
            theme=Theme[config.get("theme", "light").upper()],
            cursor_blink=config.get("cursor_blink", False),
            cursor_size=config.get("cursor_size", 32),
            cursor_theme=config.get("cursor_theme", "Adwaita"),
            keyrepeat_delay=config.get("keyrepeat_delay", 145),
            keyrepeat_rate=config.get("keyrepeat_rate", 55),
            terminal_app=config.get("terminal_app", "gnome-terminal"),
        )

    @staticmethod
    def determine_host() -> Host:
        hostname = socket.gethostname()
        for member in Host:
            if member.name.lower().replace("_", "-") in hostname:
                return member
        return Host.OTHER

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
        return tomli.loads(data)


class Desktop(Enum):
    GNOME = auto()
    HYPRLAND = auto()
    SWAY = auto()
    WAYFIRE = auto()


class Host(Enum):
    APARTMANTWO = auto()
    COLINCHAN_FEDORA = auto()
    FRUITRON = auto()
    OTHER = auto()


class OS(Enum):
    ARCH = auto()
    FEDORA = auto()
    OTHER = auto()


class Theme(Enum):
    DARK = auto()
    LIGHT = auto()


def install_packages() -> None:
    if environment.os != OS.ARCH:
        logger.debug("Skipping package installation on non-Arch OS")
        return
    logger.warning("Package installation isn't implemented yet")


def install_configs() -> None:
    configs = parse_configs()
    for config in configs:
        try:
            if config.is_template:
                result, message = render_template(config.source, config.dest)
            else:
                result, message = ensure_symlink(config.source, config.dest)
            result.log(config, message)
        except Exception:
            logger.warning(
                "Caught exception while processing config %s",
                config,
                exc_info=True,
            )


def render_template(source: Path, dest: Path) -> tuple[Result, str | Exception | None]:
    if not source.is_file():
        return (Result.ERROR, f"source is not a file")
    template = Template(
        source.read_text(),
        trim_blocks=True,
        lstrip_blocks=True,
        keep_trailing_newline=True,
        autoescape=False,
    )
    try:
        rendered = template.render(environment.as_context())
    except Exception as e:
        return (Result.ERROR, e)
    if dest.is_file() and not dest.is_symlink():
        existing = dest.read_text()
        if rendered == existing:
            return (Result.OK, None)
        log_diff(existing, abbreviate_home(dest), rendered, source.stem)
        if dest.stat().st_mtime > source.stat().st_mtime:
            (Result.ERROR, "dest was updated more recently than source")

    try:
        mkdir_parents_and_backup_existing(dest)
    except RuntimeError as e:
        return (Result.ERROR, str(e))

    if environment.dry_run:
        return (Result.DRY, None)

    # Write to a tempfile and copy into place
    with NamedTemporaryFile(mode="w", prefix=f"{source.stem}-", delete=False) as f:
        f.write(rendered)
    temp = Path(f.name)
    logger.debug("mv %r %r", str(temp), str(dest))
    copyfile(temp, dest, follow_symlinks=False)

    # Set the dest's mtime to the source's mtime
    dest_atime = dest.stat().st_atime_ns
    source_mtime = source.stat().st_mtime_ns
    logger.debug("touch -mr %r %r", str(source), str(dest))
    os.utime(dest, ns=(dest_atime, source_mtime))

    return (Result.CHANGED, None)


def ensure_symlink(source: Path, dest: Path) -> tuple[Result, str | Exception | None]:
    if not source.exists():
        return (Result.ERROR, f"source doesn't exist")
    dest_to_source_relpath = os.path.relpath(source, start=dest.parent)
    if dest.is_symlink():
        if os.readlink(dest) == dest_to_source_relpath:
            return (Result.OK, None)
        else:
            return (Result.ERROR, f"dest is already a symlink")
    if dest.is_dir():
        return (Result.ERROR, f"dest is already a directory")
    if dest.exists() and not dest.is_file():
        return (Result.ERROR, f"dest exists but is not a symlink, directory, or file")

    try:
        mkdir_parents_and_backup_existing(dest)
    except RuntimeError as e:
        return (Result.ERROR, str(e))

    if environment.dry_run:
        return (Result.DRY, None)

    dest_to_source_relpath = os.path.relpath(source, start=dest.parent)
    logger.debug("ln -s %r %r", dest_to_source_relpath, str(dest))
    dest.symlink_to(dest_to_source_relpath)
    return (Result.CHANGED, None)


def mkdir_parents_and_backup_existing(dest: Path) -> None:
    for p in dest.parents:
        if p.is_symlink():
            raise RuntimeError(f"{str(p)!r} is a symlink")
    if environment.dry_run:
        return
    if dest.is_file() or dest.is_symlink():
        dest_old = dest.with_name(dest.name + ".old")
        logger.debug("mv %r -> %r", str(dest), str(dest_old))
        dest.rename(dest_old)
    if not (dest_parent := dest.parent).exists():
        logger.debug("mkdir -p %r", str(dest_parent))
        dest_parent.mkdir(parents=True)


class Result(Enum):
    OK = auto()
    CHANGED = auto()
    DRY = auto()
    ERROR = auto()
    EXEC = auto()

    def log(self, item: object, message: str | Exception | None) -> str:
        if isinstance(message, str):
            msg = f" {message}" if message is not None else ""
            exc = None
        elif isinstance(message, Exception):
            msg = ""
            exc = message
        else:
            msg = ""
            exc = None
        match self:
            case Result.OK:
                logger.info(
                    "\033[1mok\033[22m \033[32m%s\033[39m%s",
                    item,
                    msg,
                    exc_info=exc,
                )
            case Result.CHANGED:
                logger.info(
                    "\033[1mchanged\033[22m \033[33m%s\033[39m%s",
                    item,
                    msg,
                    exc_info=exc,
                )
            case Result.DRY:
                logger.info(
                    "\033[1mdry\033[22m \033[33m%s\033[39m%s",
                    item,
                    msg,
                    exc_info=exc,
                )
            case Result.ERROR:
                logger.info(
                    "\033[1merror\033[22m \033[31m%s\033[39m%s",
                    item,
                    msg,
                    exc_info=exc,
                )
            case Result.EXEC:
                logger.info(
                    "\033[1mexec\033[22m \033[36m%s\033[39m%s",
                    item,
                    msg,
                    exc_info=exc,
                )


@dataclass
class Config:
    source: Path
    dest: Path
    is_template: bool

    def __str__(self) -> str:
        return abbreviate_home(self.dest)


def abbreviate_home(path: Path) -> str:
    return str(Path("~") / path.relative_to(Path.home()))


def parse_configs() -> list[Config]:
    configs = []
    for dest, source in CONFIGS.items():
        source = Path(source)
        dest = Path.home() / dest
        if not source.exists():
            logger.warning("Skipping config %r because it doesn't exist", str(source))
            continue
        configs.append(Config(source, dest, is_template=source.suffix == ".jinja"))
    return configs


def log_diff(
    existing: str, existing_path: str, rendered: str, rendered_path: str
) -> None:
    difflines = unified_diff(
        existing.splitlines(),
        rendered.splitlines(),
        fromfile=f"{existing_path} (existing)",
        tofile=f"{rendered_path} (generated)",
        lineterm="",
    )
    for line in [next(difflines), next(difflines)]:
        print(f"\033[2m{line}\033[22m", file=sys.stderr)
    for line in difflines:
        match line[0]:
            case "@":
                print(f"\033[2;36m{line}\033[39m", file=sys.stderr)
            case "-":
                print(f"\033[31m{line}\033[39m", file=sys.stderr)
            case "+":
                print(f"\033[32m{line}\033[39m", file=sys.stderr)
            case " ":
                print(f"\033[2m{line}\033[22m", file=sys.stderr)


def apply_settings() -> None:
    gsettings_set(
        "org.gnome.desktop.interface.color-scheme",
        "prefer-dark" if environment.theme == Theme.DARK else "default",
    )
    gsettings_set(
        "org.gnome.desktop.interface.cursor-blink",
        "true" if environment.cursor_blink else "false",
    )
    gsettings_set(
        "org.gnome.desktop.interface.cursor-theme", str(environment.cursor_theme)
    )
    gsettings_set(
        "org.gnome.desktop.interface.cursor-size", str(environment.cursor_size)
    )
    gsettings_set(
        "org.gnome.desktop.peripherals.keyboard.delay", str(environment.keyrepeat_delay)
    )
    gsettings_set(
        "org.gnome.desktop.peripherals.keyboard.repeat-interval",
        str(1000 // environment.keyrepeat_rate),
    )


def gsettings_set(path: str, value: str) -> None:
    schema, key = path.rsplit(".", maxsplit=1)
    run(["gsettings", "set", schema, key, value])


def compile_terminfo() -> None:
    run(
        ["tic", "-x", "-o", "~/.terminfo", "terminfos.ti"],
        env={"TERMINFO": "/usr/share/terminfo"},
    )


def reload_things() -> None:
    run(["pkill", "-USR1", "kitty"])
    run(["systemctl", "--user", "daemon-reload"])


def run(args: list[str], env: Mapping[str, str] = None) -> None:
    command = shlex.join(args)
    if environment.dry_run:
        Result.DRY.log(command, None)
        return
    result = subprocess.run(args, env=None if env is None else os.environ | env)
    if result.returncode == 0:
        Result.EXEC.log(command, None)
    else:
        Result.ERROR.log(command, f"exited {result.returncode}")


if __name__ == "__main__":
    sys.exit(main())
