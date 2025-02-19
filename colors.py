from __future__ import annotations

import random
import re
import shutil
import sys
import textwrap
import traceback
from contextlib import contextmanager
from contextvars import ContextVar
from dataclasses import dataclass, field, fields
from enum import Enum
from itertools import cycle, starmap
from math import atan2, cos, degrees, isclose, radians, sin, sqrt
from pathlib import Path
from textwrap import dedent
from typing import Iterator, Self


@dataclass
class Clamped:
    clamped: bool


_clamped = ContextVar("_clamped")


@contextmanager
def detect_clamping() -> Iterator[None]:
    c = Clamped(False)
    token = _clamped.set(c)
    try:
        yield c
    finally:
        _clamped.reset(token)


def clamp(v: float) -> float:
    cv = max(0.0, min(1.0, v))
    if cv != v and (clamped := _clamped.get(None)) is not None:
        clamped.clamped = True
    return cv


# Oklab <-> linear sRGB conversions from https://bottosson.github.io/posts/oklab/
def linear_srgb_to_oklab(r: float, g: float, b: float) -> tuple[float, float, float]:
    l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b
    m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b
    s = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b
    l_ = l ** (1 / 3)
    m_ = m ** (1 / 3)
    s_ = s ** (1 / 3)
    return (
        0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
        1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
        0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_,
    )


def oklab_to_linear_srgb(L: float, a: float, b: float) -> tuple[float, float, float]:
    l_ = L + 0.3963377774 * a + 0.2158037573 * b
    m_ = L - 0.1055613458 * a - 0.0638541728 * b
    s_ = L - 0.0894841775 * a - 1.2914855480 * b
    l = l_ * l_ * l_
    m = m_ * m_ * m_
    s = s_ * s_ * s_
    return (
        4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
        -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
        -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s,
    )


# sRGB linear -> nonlinear transform from https://bottosson.github.io/posts/colorwrong/
def f(x: float) -> float:
    if x >= 0.0031308:
        return (1.055) * x ** (1.0 / 2.4) - 0.055
    else:
        return 12.92 * x


def f_inv(x: float) -> float:
    if x >= 0.04045:
        return ((x + 0.055) / (1 + 0.055)) ** 2.4
    else:
        return x / 12.92


def parse_hex(s: str) -> tuple[int, int, int]:
    hex = s.removeprefix("#")
    return tuple(int(hex[n : n + 2], 16) for n in [0, 2, 4])


class Color:
    __slots__ = ["l", "c", "h"]

    def __init__(self, l: float | int, c: float | int, h: float | int) -> None:
        self.l = float(l)  # roughly 0 to 100
        self.c = float(c)  # roughly 0 to 100
        self.h = float(h) if self.c > 0 else 0.0  # degrees

    def __eq__(self, other: Color) -> bool:
        return all(
            starmap(isclose, zip((self.l, self.c, self.h), (other.l, other.c, other.h)))
        )

    def __repr__(self) -> str:
        return f"{type(self).__name__}(l={self.l}, c={self.c}, h={self.h})"

    @classmethod
    def from_lab(cls, L: float, a: float, b: float) -> Self:
        C = sqrt(a**2 + b**2)
        h = degrees(atan2(b, a)) % 360
        l = L * 100
        c = C * 300
        return cls(l, c, h)

    @classmethod
    def from_rgb(cls, r: float, g: float, b: float) -> Self:
        return cls.from_lab(*linear_srgb_to_oklab(*(map(f_inv, [r, g, b]))))

    @classmethod
    def from_rgb_hex(cls, hex: str) -> Self:
        r, g, b = (i / 255 for i in parse_hex(hex))
        return cls.from_rgb(r, g, b)

    def set(
        self, l: float | None = None, c: float | None = None, h: float | None = None
    ) -> Color:
        return type(self)(
            l=self.l if l is None else max(l, 0.0),
            c=self.c if c is None else max(c, 0.0),
            h=self.h if h is None else h % 360,
        )

    def adjust(self, l: float = 0, c: float = 0, h: float = 0) -> Color:
        return self.set(
            l=self.l + l, c=(self.c + c if self.c > 0 else 0.0), h=self.h + h
        )

    def interpolate(self, other: Color, amount: float) -> Color:
        return Color.from_lab(
            *(
                (1 - amount) * s + amount * o
                for s, o in zip(self.as_lab(), other.as_lab())
            )
        )

    def as_lab(self) -> tuple[float, float, float]:
        L = self.l / 100
        C = self.c / 300
        a = C * cos(radians(self.h))
        b = C * sin(radians(self.h))

        # Verify math
        assert (
            Color.from_lab(L, a, b) == self
        ), f"{Color.from_lab(L, a, b)!r} != {self!r}"

        return L, a, b

    def as_rgb(self) -> tuple[float, float, float]:
        return tuple(map(f, oklab_to_linear_srgb(*self.as_lab())))

    def as_clamped_rgb(self) -> tuple[float, float, float]:
        return tuple(map(clamp, self.as_rgb()))

    def as_rgb_ints(self) -> tuple[int, int, int]:
        return tuple(round(v * 255) for v in self.as_clamped_rgb())

    def as_rgb_hex(self) -> str:
        with detect_clamping() as c:
            hex_digits = "".join(f"{v:02x}" for v in self.as_rgb_ints())
        return f"‼{hex_digits}" if c.clamped else f"#{hex_digits}"

    def as_rgb_hex_noprefix(self) -> str:
        return "".join(f"{v:02x}" for v in self.as_rgb_ints())

    def bg_escape(self) -> str:
        rgb_sequence = ";".join(map(str, self.as_rgb_ints()))
        return f"\033[48;2;{rgb_sequence}m"

    def fg_escape(self) -> str:
        rgb_sequence = ";".join(map(str, self.as_rgb_ints()))
        return f"\033[38;2;{rgb_sequence}m"

    def background(self) -> str:
        return f"{self.bg_escape()}{self.as_rgb_hex()}\033[49m"

    def foreground(self) -> str:
        return f"{self.fg_escape()}{self.as_rgb_hex()}\033[39m"

    def reverse(self) -> str:
        rgb_sequence = ";".join(map(str, self.as_rgb_ints()))
        return f"\033[7;38;2;{rgb_sequence}m{self.as_rgb_hex()}\033[39;27m"

    def lch_foreground(self) -> str:
        return f"{self.fg_escape()}(l={self.l:5.2f}, c={self.c:5.2f}, h={self.h:6.2f})\033[39m"


for hex in ["#000000", "#111111", "#123456", "#ff00ff"]:
    c = Color.from_rgb_hex(hex)
    roundtrip = c.as_rgb_hex()
    assert roundtrip == hex, f"roundtrip: {roundtrip} != {hex}"


_theme = ContextVar("_theme")


@contextmanager
def active_theme(t: Theme) -> Iterator[None]:
    token = _theme.set(t)
    try:
        yield
    finally:
        _theme.reset(token)


@dataclass(frozen=True)
class BaseColor:
    color: Color

    @classmethod
    def from_lch(cls, l: float, c: float, h: float) -> Self:
        return cls(Color(l, c, h))

    @classmethod
    def from_rgb_hex(cls, hex: str) -> Self:
        return cls(Color.from_rgb_hex(hex))

    @property
    def dim(self) -> Color:
        return _theme.get().bg.color

    @property
    def normal(self) -> Color:
        return self.color

    @property
    def bright(self) -> Color:
        return _theme.get().bg.color

    @property
    def highlight(self) -> Color:
        return _theme.get().bg.color

    @property
    def background(self) -> Color:
        return _theme.get().bg.color

    def data(self) -> dict[str, str]:
        return {
            "": self.normal.as_rgb_hex_noprefix(),
        }


@dataclass(frozen=True)
class DarkThemeColor(BaseColor):
    @property
    def dim(self) -> Color:
        return self.color.adjust(c=-8, l=-15)

    @property
    def bright(self) -> Color:
        return self.color.adjust(c=0, l=13)

    @property
    def highlight(self) -> Color:
        return self.color.interpolate(_theme.get().bg.color, 0.35).adjust(l=8)

    @property
    def background(self) -> Color:
        return self.color.adjust(c=-5, l=-25).interpolate(_theme.get().bg.color, 0.5)

    def data(self) -> dict[str, str]:
        return {
            "": self.normal.as_rgb_hex_noprefix(),
            "_dim": self.dim.as_rgb_hex_noprefix(),
            "_bright": self.bright.as_rgb_hex_noprefix(),
            "_hl": self.highlight.as_rgb_hex_noprefix(),
            "_bg": self.background.as_rgb_hex_noprefix(),
        }


@dataclass(frozen=True)
class LightThemeColor(BaseColor):
    @property
    def dim(self) -> Color:
        return self.color.adjust(l=-10).interpolate(_theme.get().bg.color, 0.5)

    @property
    def bright(self) -> Color:
        return self.color.adjust(c=6, l=8)

    @property
    def highlight(self) -> Color:
        return self.color.adjust(l=35)

    @property
    def background(self) -> Color:
        return self.color.adjust(c=-8, l=30).interpolate(_theme.get().bg.color, 0.7)

    def data(self) -> dict[str, str]:
        return {
            "": self.normal.as_rgb_hex_noprefix(),
            "_dim": self.dim.as_rgb_hex_noprefix(),
            "_bright": self.bright.as_rgb_hex_noprefix(),
            "_hl": self.highlight.as_rgb_hex_noprefix(),
            "_bg": self.background.as_rgb_hex_noprefix(),
        }


@dataclass(frozen=True)
class Theme:
    bg: BaseColor
    brightbg: BaseColor
    shadow: BaseColor
    veryfaint: BaseColor
    faint: BaseColor
    subtle: BaseColor
    normal: BaseColor
    bright: BaseColor
    red: BaseColor
    orange: BaseColor
    yellow: BaseColor
    green: BaseColor
    cyan: BaseColor
    blue: BaseColor
    violet: BaseColor
    magenta: BaseColor

    palette: Iterator[BaseColor] = field(init=False)

    def __post_init__(self):
        palette = [
            self.subtle,
            self.bright,
            self.red,
            self.orange,
            self.yellow,
            self.green,
            self.cyan,
            self.blue,
            self.violet,
            self.magenta,
        ]
        object.__setattr__(self, "palette", cycle(random.sample(palette, len(palette))))

    def randcolor(self, s: str) -> str:
        out = []
        for word in s.split():
            if (i := hash(word) % 6) == 0:
                out.append(
                    next(self.palette).color.fg_escape()
                    + word
                    + self.normal.color.fg_escape()
                )
            else:
                out.append(word)
        return " ".join(out)


dark = Theme(
    bg=BaseColor.from_lch(l=21, c=2, h=190),
    brightbg=BaseColor.from_lch(l=25, c=1, h=240),
    shadow=BaseColor.from_lch(l=0, c=0, h=0),
    veryfaint=BaseColor.from_lch(l=30, c=2, h=240),
    faint=BaseColor.from_lch(l=42, c=2, h=240),
    subtle=BaseColor.from_lch(l=60, c=1, h=240),
    normal=BaseColor.from_lch(l=78, c=0, h=0),
    bright=BaseColor.from_lch(l=92, c=0, h=0),
    red=DarkThemeColor.from_lch(l=60, c=46, h=28),
    orange=DarkThemeColor.from_lch(l=63, c=40, h=60),
    yellow=DarkThemeColor.from_lch(l=68, c=38, h=97),
    green=DarkThemeColor.from_lch(l=63, c=48, h=135),
    cyan=DarkThemeColor.from_lch(l=64, c=35, h=182),
    blue=DarkThemeColor.from_lch(l=64, c=45, h=247),
    violet=DarkThemeColor.from_lch(l=61, c=48, h=292),
    magenta=DarkThemeColor.from_lch(l=60, c=44, h=332),
)

light = Theme(
    bg=BaseColor.from_lch(l=96, c=2, h=60),
    brightbg=BaseColor.from_lch(l=98, c=2, h=60),
    shadow=BaseColor.from_lch(l=92, c=1, h=60),
    veryfaint=BaseColor.from_lch(l=85, c=4, h=60),
    faint=BaseColor.from_lch(l=70, c=3, h=60),
    subtle=BaseColor.from_lch(l=52, c=3, h=60),
    normal=BaseColor.from_lch(l=35, c=2, h=60),
    bright=BaseColor.from_lch(l=5, c=2, h=60),
    red=LightThemeColor.from_lch(l=50, c=38, h=28),
    orange=LightThemeColor.from_lch(l=50, c=35, h=60),
    yellow=LightThemeColor.from_lch(l=55, c=35, h=97),
    green=LightThemeColor.from_lch(l=50, c=38, h=132),
    cyan=LightThemeColor.from_lch(l=49, c=30, h=182),
    blue=LightThemeColor.from_lch(l=50, c=35, h=245),
    violet=LightThemeColor.from_lch(l=50, c=35, h=292),
    magenta=LightThemeColor.from_lch(l=50, c=35, h=332),
)


COLS = shutil.get_terminal_size().columns
ESCAPE_PATTERN = re.compile("\033\\[.*?m")

_print = print


def print(*args: str) -> None:
    theme = _theme.get()
    reset = theme.bg.color.bg_escape() + theme.normal.color.fg_escape()
    parts = [reset]
    width = 0
    for arg in args:
        width += len(ESCAPE_PATTERN.sub("", arg)) + 1
        if width < COLS:
            parts.append(arg)
        else:
            parts.append("…")
            break
    if (remainder := COLS - width) > 1:
        parts.append(" " * (remainder - 1))
    _print(*parts, sep=f"{reset} ")


if __name__ == "__main__":
    namelen = max(len(f.name) for f in fields(Theme))
    for name, theme in [("dark", dark), ("light", light)]:
        if len(sys.argv) == 2 and name != sys.argv[1]:
            continue
        try:
            with active_theme(theme):
                print()
                print(
                    *(
                        f"\033[4m{s}\033[0m"
                        for s in [
                            "NAME".ljust(namelen),
                            "DIM    ",
                            "NORMAL ",
                            "BRIGHT ",
                            "REVERSE",
                            "HI     ",
                            "BG     ",
                            "Color                            ",
                        ]
                    ),
                )
                for field in fields(theme):
                    if field.type != "BaseColor":
                        continue
                    c = getattr(theme, field.name)
                    print(
                        f"{field.name:{namelen}}",
                        c.dim.foreground(),
                        c.normal.foreground(),
                        c.bright.foreground(),
                        c.normal.reverse(),
                        c.highlight.background(),
                        c.background.background(),
                        c.normal.lch_foreground(),
                    )
                print()
                for line in textwrap.fill(
                    """
                    Lorem Ipsum is simply dummy text of the printing and
                    typesetting industry. Lorem Ipsum has been the industry's
                    standard dummy text ever since the 1500s, when an unknown
                    printer took a galley of type and scrambled it to make a
                    type specimen book. It has survived not only five centuries,
                    but also the leap into electronic typesetting, remaining
                    essentially unchanged. It was popularised in the 1960s
                    with the release of Letraset sheets containing Lorem Ipsum
                    passages, and more recently with desktop publishing software
                    like Aldus PageMaker including versions of Lorem Ipsum.
                    """.strip(),
                    width=COLS,
                ).splitlines():
                    print(theme.randcolor(line))
                print()
        except Exception:
            traceback.print_exc()
        finally:
            _print("\033[0m")

    theme_data = {}
    for theme_name, theme in [("dark", dark), ("light", light)]:
        with active_theme(theme):
            for field in fields(theme):
                if field.type != "BaseColor":
                    continue
                c = getattr(theme, field.name)
                for k, v in c.data().items():
                    theme_data[f"{theme_name}_{field.name}{k}"] = v
    data_toml = "".join(f'{k} = "{v}"\n' for k, v in theme_data.items())
    Path("colors.toml").write_text(data_toml)
