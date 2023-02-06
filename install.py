#!/usr/bin/python3
import sys

if (sys.version_info.major, sys.version_info.minor) < (3, 10):
    print("error: This script requires Python 3.11 or later", file=sys.stderr)
    sys.exit(1)

import logging
import os
import socket
from argparse import ArgumentParser, Namespace
from dataclasses import asdict, dataclass
from difflib import unified_diff
from enum import Enum, auto
from os import PathLike
from pathlib import Path
from shutil import copyfile
import subprocess
import shlex
from tempfile import NamedTemporaryFile
from textwrap import dedent

from jinja2 import Environment as JinjaEnvironment

from installer.environment import Environment
from installer.outputs import render, symlink_to

CONFIGS: dict[str, Output] = {
    ".XCompose": symlink_to("XCompose"),
    ".alsoftrc": symlink_to("alsoftrc"),
    ".bash_profile": symlink_to("bash_profile"),
    ".bashrc": symlink_to("bashrc"),
    ".config/alacritty/alacritty.yml": render("alacritty.yml.jinja"),
    ".config/electron-flags.conf": symlink_to("electron-flags.conf"),
    ".config/electron15-flags.conf": symlink_to("electron15-flags.conf"),
    ".config/environment.d/environment.conf": symlink_to(
        "environment.conf"
    ),
    ".config/fontconfig/fonts.conf": symlink_to("fonts.conf"),
    ".config/gammastep/config.ini": render("gammastep.ini.jinja"),
    ".config/gtk-3.0/settings.ini": render("gtk-3.0-settings.ini.jinja"),
    ".config/gtk-4.0/settings.ini": symlink_to("gtk-4.0-settings.ini"),
    ".config/helix/config.toml": symlink_to("helix/config.toml"),
    ".config/helix/languages.toml": symlink_to("helix/languages.toml"),
    ".config/helix/themes/kalgykai-dark.toml": symlink_to("helix/kalgykai-dark.toml"),
    ".config/hypr/hyprland.conf": render("hyprland.conf.jinja"),
    ".config/imv/config": symlink_to("imv"),
    ".config/kitty/kitty.conf": render("kitty.conf.jinja"),
    ".config/mpv/mpv.conf": symlink_to("mpv.conf"),
    ".config/nvim": symlink_to("nvim"),
    ".config/pipewire/pipewire.conf.d/10-zeroconf.conf": symlink_to(
        "pipewire/10-zeroconf.conf"
    ),
    ".config/sway/config": render("sway.jinja"),
    ".config/swaylock/config": symlink_to("swaylock"),
    ".config/user-dirs.dirs": symlink_to("user-dirs.dirs"),
    ".config/waybar/config": render("waybar.jinja"),
    ".config/waybar/style.css": symlink_to("waybar.css"),
    ".config/wezterm/wezterm.lua": render("wezterm.lua.jinja"),
    ".gemrc": symlink_to("gemrc"),
    ".gitconfig": symlink_to("gitconfig"),
    ".gtkrc-2.0": symlink_to("gtkrc-2.0"),
    ".inputrc": symlink_to("inputrc"),
    ".ipython/profile_default/ipython_config.py": symlink_to(
        "ipython_config.py"
    ),
    ".local/share/icons/default/index.theme": render("index.theme.jinja"),
    ".profile": symlink_to("profile"),
    ".pythonrc": symlink_to("pythonrc"),
    ".tmux.conf": symlink_to("tmux.conf"),
}

for path in Path("applications").iterdir():
    CONFIGS[f".local/share/applications/{path.name}"] = symlink_to(path)

for path in Path("bin").iterdir():
    if path.suffix == ".jinja":
        CONFIGS[f"bin/{path.with_suffix('').name}"] = chmod(0o755, render(path))
    else:
        CONFIGS[f"bin/{path.name}"] = symlink_to(path)

for path in Path("units").iterdir():
    if path.suffix == ".jinja":
        CONFIGS[f".config/systemd/user/{path.with_suffix('').name}"] = render(path)
    else:
        CONFIGS[f".config/systemd/user/{path.name}"] = symlink_to(path)


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
    jinja_env = JinjaEnvironment(
        trim_blocks=True,
        lstrip_blocks=True,
        keep_trailing_newline=True,
        autoescape=False,
    )
    jinja_env.filters["shellquote"] = shlex.quote
    template = jinja_env.from_string(
        source.read_text(),
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
