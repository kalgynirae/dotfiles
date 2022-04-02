from __future__ import annotations

from dataclasses import dataclass
from enum import Enum
from textwrap import dedent

from colormath.color_conversions import convert_color
from colormath.color_objects import ColorBase, LabColor, LCHabColor, sRGBColor

VERSION = "0.1.1"


@dataclass(frozen=True)
class Color:
    l: float
    c: float
    h: float

    def __str__(self) -> str:
        rgb = self.as_rgb()
        r = min(255, int(rgb.clamped_rgb_r * 256))
        g = min(255, int(rgb.clamped_rgb_g * 256))
        b = min(255, int(rgb.clamped_rgb_b * 256))
        return f"#{r:02x}{g:02x}{b:02x}"

    def set(
        self, l: float | None = None, c: float | None = None, h: float | None = None
    ) -> Color:
        return type(self)(
            l=self.l if l is None else max(l, 0),
            c=self.c if c is None else max(c, 0),
            h=self.h if h is None else h % 360,
        )

    def adjust(self, l: float = 0, c: float = 0, h: float = 0) -> Color:
        return self.set(l=self.l + l, c=self.c + c, h=self.h + h)

    def as_rgb(self) -> sRGBColor:
        return convert_color(LCHabColor(self.l, self.c, self.h), sRGBColor)

    def background(self) -> str:
        rgb = self.as_rgb()
        rgb_sequence = ";".join(
            str(round(val * 255))
            for val in [rgb.clamped_rgb_r, rgb.clamped_rgb_g, rgb.clamped_rgb_b]
        )
        return f"\033[48;2;{rgb_sequence}m{self}\033[m"

    def foreground(self) -> str:
        rgb = self.as_rgb()
        rgb_sequence = ";".join(
            str(round(val * 255))
            for val in [rgb.clamped_rgb_r, rgb.clamped_rgb_g, rgb.clamped_rgb_b]
        )
        return f"\033[38;2;{rgb_sequence}m{self}\033[m"

normal = Color(45, 0, 0)
base_colors = dict(
    black=Color(60, 0, 0),
    red=Color(46, 50, 32),
    orange=Color(49, 50, 58),
    yellow=Color(51, 52, 95),
    green=Color(48, 50, 125),
    cyan=Color(47, 48, 190),
    blue=Color(46, 46, 265),
    violet=Color(47, 48, 298),
    magenta=Color(46, 48, 330),
    white=normal,
)
for name, color in base_colors.items():
    print(name, color.adjust(l=-7, c=-15).foreground(), color.foreground(), color.adjust(l=12, c=4).foreground(), color.adjust(l=48, c=-38).background())
print("normal", normal.adjust(l=-25).foreground())
