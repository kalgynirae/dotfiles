from __future__ import annotations

if __name__ != "__main__":
    raise RuntimeError("You accidentally imported install.py somehow")

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

from installer.actions import Output, gsettings_set, render, run, symlink_to
from installer.environment import OS, Environment, Theme, environment
from installer.logging import Result, log, log_diff, log_dry, log_error, step

parser = ArgumentParser()
parser.add_argument("--dry-run", action="store_true")
parser.add_argument("--packages", action="store_true")
args = parser.parse_args()

os.chdir(os.path.dirname(__file__))

environment.set(Environment.load(dry_run=args.dry_run))
print(f"Loaded env: {environment.get()}")

if args.packages:
    if environment.get().os == OS.ARCH:
        print("Package installation isn't implemented yet")
    else:
        print("Skipping package installation on non-Arch OS")

configs: dict[str, Output] = {
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
    ".config/ghostty/config": render("ghostty/config.jinja"),
    ".config/ghostty/themes/kalgykai-dark": render("ghostty/kalgykai-dark.jinja"),
    ".config/ghostty/themes/kalgykai-light": render("ghostty/kalgykai-light.jinja"),
    ".config/gtk-3.0/settings.ini": render("gtk-3.0-settings.ini.jinja"),
    ".config/gtk-4.0/settings.ini": render("gtk-4.0-settings.ini.jinja"),
    ".config/helix/config.toml": render("helix/config.toml.jinja"),
    ".config/helix/languages.toml": symlink_to("helix/languages.toml"),
    ".config/helix/themes/kalgykai-dark.toml": symlink_to("helix/kalgykai-dark.toml"),
    ".config/helix/themes/kalgykai-light.toml": symlink_to("helix/kalgykai-light.toml"),
    ".config/helix/runtime/queries/comment/highlights.scm": symlink_to(
        "helix/queries/comment/highlights.scm"
    ),
    ".config/hypr/hyprland.conf": render("hyprland.conf.jinja"),
    ".config/imv/config": symlink_to("imv"),
    ".config/kitty/kitty.conf": render("kitty.conf.jinja"),
    ".config/mako/config": symlink_to("mako"),
    ".config/mpv/mpv.conf": symlink_to("mpv.conf"),
    ".config/nvim": symlink_to("nvim"),
    ".config/paru/paru.conf": symlink_to("paru.conf"),
    ".config/pipewire/pipewire.conf.d/15-netjack2.conf": symlink_to(
        "pipewire/15-netjack2.conf"
    ),
    ".config/sway/config": render("sway.jinja"),
    ".config/swaylock/config": symlink_to("swaylock"),
    ".config/user-dirs.dirs": symlink_to("user-dirs.dirs"),
    ".config/waybar/config": render("waybar.jinja"),
    ".config/waybar/style.css": render("waybar.css.jinja"),
    ".config/wezterm/wezterm.lua": render("wezterm.lua.jinja"),
    ".config/wireplumber/wireplumber.conf.d/51-focusrite-scarlett-solo-fix.conf": symlink_to(
        "wireplumber/51-focusrite-scarlett-solo-fix.conf"
    ),
    ".config/wireplumber/wireplumber.conf.d/90-prevent-webrtc-adjusting.conf": symlink_to(
        "wireplumber/90-prevent-webrtc-adjusting.conf"
    ),
    ".gemrc": symlink_to("gemrc"),
    ".gitconfig": symlink_to("gitconfig"),
    ".gtkrc-2.0": render("gtkrc-2.0.jinja"),
    ".inputrc": symlink_to("inputrc"),
    ".ipython/profile_default/ipython_config.py": symlink_to("ipython_config.py"),
    ".local/share/icons/default/index.theme": render("index.theme.jinja"),
    ".profile": symlink_to("profile"),
    ".pythonrc": symlink_to("pythonrc"),
    ".tmux.conf": symlink_to("tmux.conf"),
}

for path in Path("applications").iterdir():
    configs[f".local/share/applications/{path.name}"] = symlink_to(path)

for path in Path("bin").iterdir():
    if path.suffix == ".jinja":
        configs[f"bin/{path.with_suffix('').name}"] = render(path, mode=0o755)
    else:
        configs[f"bin/{path.name}"] = symlink_to(path)

for path in Path("units").iterdir():
    if path.suffix == ".jinja":
        configs[f".config/systemd/user/{path.with_suffix('').name}"] = render(path)
    else:
        configs[f".config/systemd/user/{path.name}"] = symlink_to(path)

firefox_profile_dir = None
for dir in (Path.home() / ".mozilla/firefox").iterdir():
    if dir.name.endswith(".default-release"):
        firefox_profile_dir = dir.relative_to(Path.home())
        break
    elif dir.name.endswith(".default"):
        firefox_profile_dir = dir.relative_to(Path.home())
        break
if firefox_profile_dir:
    configs[f"{firefox_profile_dir}/chrome/userChrome.css"] = render("userChrome.css.jinja")
    configs[f"{firefox_profile_dir}/chrome/userContent.css"] = render("userContent.css.jinja")

for dest_relpath, output in configs.items():
    dest = Path.home() / dest_relpath
    name = output.name(dest)
    try:
        result = output.install(dest)
    except Exception as e:
        result = Result.error(e)
    result.log(name)

with step("Apply gsettings"):
    gsettings_set(
        "org.gnome.desktop.interface.color-scheme",
        "prefer-dark" if environment.get().theme == Theme.DARK else "default",
    )
    gsettings_set(
        "org.gnome.desktop.interface.cursor-blink", "false"
    )
    gsettings_set(
        "org.gnome.desktop.interface.cursor-size", str(environment.get().cursor_size)
    )
    gsettings_set(
        "org.gnome.desktop.interface.cursor-theme", str(environment.get().cursor_theme)
    )
    gsettings_set(
        "org.gnome.desktop.interface.font-name", f"{environment.get().ui_font_name} {environment.get().ui_font_size}"
    )
    gsettings_set(
        "org.gnome.desktop.interface.gtk-theme", str(environment.get().gtk_theme)
    )
    gsettings_set(
        "org.gnome.desktop.interface.icon-theme", str(environment.get().icon_theme)
    )
    gsettings_set(
        "org.gnome.desktop.peripherals.keyboard.delay",
        str(environment.get().keyrepeat_delay),
    )
    gsettings_set(
        "org.gnome.desktop.peripherals.keyboard.repeat-interval",
        str(1000 // environment.get().keyrepeat_rate),
    )

with step("Complie terminfo definitions"):
    run(
        ["tic", "-x", "-o", Path.home() / ".terminfo", "terminfos.ti"],
        env={"TERMINFO": "/usr/share/terminfo"},
    )

with step("Reload hyprland config"):
    run(["hyprctl", "reload"])

with step("Reload kitty config"):
    run(["pkill", "-USR1", "kitty"])

with step("Reload systemd"):
    run(["systemctl", "--user", "daemon-reload"])
