from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
from math import atan2, cos, degrees, isclose, radians, sin, sqrt
from textwrap import dedent


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


class Color:
    __slots__ = ["l", "c", "h"]

    def __init__(self, l: float | int, c: float | int, h: float | int) -> None:
        self.l = float(l)  # roughly 0 to 100
        self.c = float(c)  # roughly 0 to 100
        self.h = float(h)  # degrees

    def set(
        self, l: float | None = None, c: float | None = None, h: float | None = None
    ) -> Color:
        return type(self)(
            l=self.l if l is None else max(l, 0.0),
            c=self.c if c is None else max(c, 0.0),
            h=self.h if h is None else h % 360,
        )

    def adjust(self, l: float = 0, c: float = 0, h: float = 0) -> Color:
        return self.set(l=self.l + l, c=self.c + c, h=self.h + h)

    def as_rgb(self) -> tuple[float, float, float]:
        L = self.l / 100
        C = self.c / 300
        h = self.h if C > 0 else 0.0
        a = C * cos(radians(h))
        b = C * sin(radians(h))

        # Verify math
        assert isclose(C, sqrt(a**2 + b**2)), f"C={C} != {sqrt(a**2 + b**2)}"
        assert isclose(
            h, degrees(atan2(b, a)) % 360
        ), f"h={h} != {degrees(atan2(b, a))}"

        return tuple(map(f, oklab_to_linear_srgb(L, a, b)))

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


if __name__ == "__main__":
    gray = Color(l=50, c=0, h=0)
    print("normal         ", gray.foreground())
    print(
        "black  ",
        gray.adjust(l=32).foreground(),
        gray.adjust(l=26).foreground(),
        gray.adjust(l=18).foreground(),
    )
    print(
        "white  ",
        gray.adjust(l=-7).foreground(),
        gray.adjust(l=-15).foreground(),
        gray.adjust(l=-30).foreground(),
    )

    colors = dict(
        red=Color(l=53, c=50, h=25),
        green=Color(l=52, c=50, h=140),
        yellow=Color(l=56, c=52, h=102),
        blue=Color(l=52, c=50, h=240),
        magenta=Color(l=52, c=50, h=330),
        cyan=Color(l=52, c=50, h=180),
        orange=Color(l=54, c=50, h=72),
        violet=Color(l=52, c=50, h=295),
    )
    for name, c in colors.items():
        dim = c.adjust(l=-15, c=-0)
        bright = c.adjust(l=15, c=5)
        bg = c.adjust(l=42, c=-35)
        print(
            f"{name:7}",
            dim.foreground(),
            c.foreground(),
            bright.foreground(),
            dim.reverse(),
            c.reverse(),
            bright.reverse(),
            bg.background(),
        )
