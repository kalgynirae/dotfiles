from __future__ import annotations

import socket
from contextvars import ContextVar
from dataclasses import asdict, dataclass
from enum import Enum, auto
from pathlib import Path
from typing import cast

import tomli

environment: ContextVar[Environment] = ContextVar("environment")


@dataclass
class Environment:
    dry_run: bool
    host: Host
    os: OS
    theme: Theme
    cursor_size: int
    cursor_theme: str
    gtk_theme: str
    icon_theme: str
    keyrepeat_delay: int
    keyrepeat_rate: int
    monitors: str
    terminal_app: str
    terminal_font: str
    terminal_font_size: str
    ui_font_name: str
    ui_font_size: str
    waybar_font_size: str
    waybar_height: int

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
    def load(cls, dry_run: bool) -> Environment:
        config = cls.read_config_toml()
        host = Host.load()
        os = OS.load()
        return cls(
            dry_run=dry_run,
            host=host,
            os=os,
            theme=Theme[cast(str, config.get("theme", "dark")).upper()],
            cursor_size=cast(int, config.get("cursor_size", 36)),
            cursor_theme=cast(str, config.get("cursor_theme", "Breeze_Light")),
            gtk_theme=cast(str, config.get("gtk_theme", "Adwaita")),
            icon_theme=cast(str, config.get("icon_theme", "Adwaita")),
            keyrepeat_delay=cast(int, config.get("keyrepeat_delay", 180)),
            keyrepeat_rate=cast(int, config.get("keyrepeat_rate", 50)),
            monitors=cast(str, config.get("monitors", "default")),
            terminal_app=cast(str, config.get("terminal_app", "ghostty")),
            terminal_font=cast(str, config.get("terminal_font", "Iosevka Term")),
            terminal_font_size=cast(str, config.get("terminal_font_size", "15")),
            ui_font_name=cast(str, config.get("ui_font_name", "Noto Sans")),
            ui_font_size=cast(str, config.get("ui_font_size", "10")),
            waybar_font_size=cast(str, config.get("waybar_font_size", "14px")),
            waybar_height=cast(int, config.get("waybar_height", "24")),
        )

    @staticmethod
    def read_config_toml() -> dict[str, bool | str]:
        try:
            data = Path("config.toml").read_text()
        except FileNotFoundError:
            return {}
        return tomli.loads(data)


class Host(Enum):
    APARTMANTWO = auto()
    COLINCHAN_FEDORA = auto()
    FRUITRON = auto()
    OTHER = auto()

    @classmethod
    def load(cls) -> Host:
        hostname = socket.gethostname()
        for member in cls:
            if member.name.lower().replace("_", "-") in hostname:
                return member
        return cls.OTHER


class OS(Enum):
    ARCH = auto()
    FEDORA = auto()
    OTHER = auto()

    @classmethod
    def load(cls) -> OS:
        try:
            os_release = Path("/etc/os-release").read_text()
        except FileNotFoundError:
            pass
        else:
            if "Arch Linux" in os_release:
                return cls.ARCH
            elif "Fedora Linux" in os_release:
                return cls.FEDORA
        return cls.OTHER


class Theme(Enum):
    DARK = auto()
    LIGHT = auto()
