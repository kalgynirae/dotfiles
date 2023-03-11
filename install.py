from __future__ import annotations

import os
import shlex
import socket
import subprocess
import sys
from argparse import ArgumentParser, Namespace
from dataclasses import asdict, dataclass
from enum import Enum, auto
from os import PathLike
from pathlib import Path
from textwrap import dedent
from typing import Mapping, cast

from installer.environment import OS, Environment, Theme
from installer.logging import abbreviate_home, log, log_diff, log_dry, log_error, step
from installer.outputs import Output, render, symlink_to

CONFIGS: dict[str, Output] = {
    ".XCompose": symlink_to("XCompose"),
    ".alsoftrc": symlink_to("alsoftrc"),
    ".bash_profile": symlink_to("bash_profile"),
    ".bashrc": symlink_to("bashrc"),
    ".config/alacritty/alacritty.yml": render("alacritty.yml.jinja"),
    ".config/electron-flags.conf": symlink_to("electron-flags.conf"),
    ".config/electron15-flags.conf": symlink_to("electron15-flags.conf"),
    ".config/environment.d/environment.conf": symlink_to("environment.conf"),
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
    ".ipython/profile_default/ipython_config.py": symlink_to("ipython_config.py"),
    ".local/share/icons/default/index.theme": render("index.theme.jinja"),
    ".profile": symlink_to("profile"),
    ".pythonrc": symlink_to("pythonrc"),
    ".tmux.conf": symlink_to("tmux.conf"),
}

for path in Path("applications").iterdir():
    CONFIGS[f".local/share/applications/{path.name}"] = symlink_to(path)

for path in Path("bin").iterdir():
    if path.suffix == ".jinja":
        CONFIGS[f"bin/{path.with_suffix('').name}"] = render(path, mode=0o755)
    else:
        CONFIGS[f"bin/{path.name}"] = symlink_to(path)

for path in Path("units").iterdir():
    if path.suffix == ".jinja":
        CONFIGS[f".config/systemd/user/{path.with_suffix('').name}"] = render(path)
    else:
        CONFIGS[f".config/systemd/user/{path.name}"] = symlink_to(path)


environment: Environment = cast(Environment, None)


def main() -> int:
    args = parse_args()
    os.chdir(os.path.dirname(__file__))

    global environment
    environment = Environment.load(dry_run=args.dry_run)
    print(f"Loaded env: {environment}")

    if args.packages:
        if environment.os == OS.ARCH:
            print("Package installation isn't implemented yet")
        else:
            print("Skipping package installation on non-Arch OS")

    for dest_relpath, output in CONFIGS.items():
        dest = Path.home() / dest_relpath
        name = f"file: {abbreviate_home(dest)}"
        try:
            result = output.install(dest, environment=environment)
        except Exception as e:
            log_error(name, e)
        else:
            result.log(name)

    with step("Apply gsettings"):
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
            "org.gnome.desktop.peripherals.keyboard.delay",
            str(environment.keyrepeat_delay),
        )
        gsettings_set(
            "org.gnome.desktop.peripherals.keyboard.repeat-interval",
            str(1000 // environment.keyrepeat_rate),
        )

    with step("Complie terminfo definitions"):
        run(
            ["tic", "-x", "-o", Path.home() / ".terminfo", "terminfos.ti"],
            env={"TERMINFO": "/usr/share/terminfo"},
        )

    with step("Reload kitty config"):
        run(["pkill", "-USR1", "kitty"])

    with step("Reload systemd"):
        run(["systemctl", "--user", "daemon-reload"])

    return 0


def parse_args() -> Namespace:
    parser = ArgumentParser()
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--packages", action="store_true")
    return parser.parse_args()


def gsettings_set(path: str, value: str) -> None:
    schema, key = path.rsplit(".", maxsplit=1)
    run(["gsettings", "set", schema, key, value])


def run(args: list[str | Path], env: Mapping[str, str] | None = None) -> None:
    str_args = list(map(str, args))
    if environment.dry_run:
        log_dry(f"command: {shlex.join(str_args)}")
    else:
        subprocess.run(
            str_args, check=True, env=None if env is None else os.environ | env
        )


if __name__ == "__main__":
    sys.exit(main())
