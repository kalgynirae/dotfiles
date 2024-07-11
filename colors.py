from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
from itertools import starmap
from math import atan2, cos, degrees, isclose, radians, sin, sqrt
from textwrap import dedent
from typing import Self


def clamp(v: float) -> float:
    return max(0.0, min(1.0, v))


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
    return tuple(int(hex[n:n+2], 16) for n in [0,2,4])


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
            *((1 - amount) * s + amount * o for s, o in zip(self.as_lab(), other.as_lab()))
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
        return "#" + "".join(f"{v:02x}" for v in self.as_rgb_ints())

    def background(self) -> str:
        rgb_sequence = ";".join(map(str, self.as_rgb_ints()))
        return f"\033[48;2;{rgb_sequence}m{self.as_rgb_hex()}\033[m"

    def foreground(self) -> str:
        rgb_sequence = ";".join(map(str, self.as_rgb_ints()))
        return f"\033[38;2;{rgb_sequence}m{self.as_rgb_hex()}\033[m"

    def reverse(self) -> str:
        rgb_sequence = ";".join(map(str, self.as_rgb_ints()))
        return f"\033[7;38;2;{rgb_sequence}m{self.as_rgb_hex()}\033[m"


for hex in ["#000000", "#111111", "#123456", "#ff00ff"]:
    c = Color.from_rgb_hex(hex)
    roundtrip = c.as_rgb_hex()
    assert roundtrip == hex, f"roundtrip: {roundtrip} != {hex}"

DEFINITIONS = """
dark.bg         #1c2022
dark.shadow     #000000
dark.verydark   #38383a
dark.dark       #505050
dark.subtle     #a0a0a0
dark.normal     #c0c0c0
dark.red        #b44738
dark.orange     #af6423
dark.yellow     #a79026
dark.green      #518921
dark.cyan       #008f89
dark.blue       #3982ce
dark.violet     #806acc
dark.magenta    #ae4fa3
light.bg        #f4f4f4
light.shadow    #ffffff
light.verydark  #d0d0d0
light.dark      #a0a0a0
light.subtle    #707070
light.normal    #404040
light.red       #c8514d
light.orange    #b86c00
light.yellow    #9b8700
light.green     #3f8f2b
light.cyan      #00967e
light.blue      #0083cc
light.violet    #8363cc
light.magenta   #ac52a6
"""
COLORS = {}
for line in DEFINITIONS.strip().splitlines():
    name, hex = line.split()
    COLORS[name] = Color.from_rgb_hex(hex)

def generate(name: str, c: Color, background: Color, dark: bool) -> None:
    if dark:
        dim = c.adjust(c=-5).interpolate(background, 0.2)
        bright = c.adjust(c=0, l=10)
        hi = c.interpolate(background, 0.35).adjust(l=8)
        bg = c.interpolate(background, 0.4).adjust(l=-15)
    else:
        dim = c.adjust(c=-10, l=-10)
        bright = c.adjust(c=5, l=5)
        hi = c.interpolate(background, 0.35).adjust(l=8)
        bg = c.interpolate(background, 0.7).adjust(l=10)
    print(
        f"{name:14}",
        dim.foreground(),
        c.foreground(),
        bright.foreground(),
        c.reverse(),
        hi.background(),
        bg.background(),
    )

if __name__ == "__main__":
    print("NAME           DIM     NORMAL  BRIGHT  REVERSE HI      BG")
    darkbg = COLORS["dark.bg"]
    for name, c in COLORS.items():
        if name.startswith("dark."):
            generate(name, c, darkbg, True)
    print()
    print("NAME           DIM     NORMAL  BRIGHT  REVERSE HI      BG")
    lightbg = COLORS["light.bg"]
    for name, c in COLORS.items():
        if name.startswith("light."):
            generate(name, c, lightbg, False)
