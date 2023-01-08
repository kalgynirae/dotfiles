#!/usr/bin/env python3
import colorsys
import contextlib
import itertools
import pathlib
import signal
import subprocess
import sys
import tempfile
import time

FPS = 10
DURATION = 1. / FPS
MIN_SLEEP = DURATION / 2

def main():
    colors1 = colorcycle()
    colors2 = itertools.islice(colorcycle(), 10, None)
    #degrees = itertools.cycle(range(0, 360, 2))
    while True:
        start = time.monotonic()
        args = [
            "hyprctl",
            "keyword",
            "general:col.active_border",
            next(colors1),
            next(colors2),
            f"45deg",
        ]
        subprocess.run(
            args,
            stdout=subprocess.DEVNULL,
        )
        elapsed = time.monotonic() - start
        time.sleep(max(DURATION - elapsed, MIN_SLEEP))


colors_hsv = """
 0 90 99
 1 90 99
 2 90 99
 3 95 99
 4 99 99
 5 99 99
 6 99 99
 7 99 99
 8 99 99
 9 99 99
10 99 99
11 99 99
12 99 99
13 99 99
14 99 99
15 99 99
16 99 99
17 99 99
18 99 99
21 99 99
24 99 99
27 99 99
30 99 99
33 99 99
36 99 99
39 99 99
42 99 99
45 99 99
47 99 99
48 99 99
49 99 99
50 99 99
51 99 99
52 99 99
53 85 99
54 85 99
55 85 99
56 85 99
58 80 99
60 70 99
63 60 99
66 55 99
67 55 99
68 55 99
69 55 99
70 55 99
71 55 99
72 65 99
74 65 99
76 65 99
78 65 99
80 65 99
83 70 99
86 70 99
89 75 99
92 75 99
95 80 99
97 85 99
98 90 99
99 90 99
"""


def colorcycle():
    hsvs = [map(int, line.split()) for line in colors_hsv.strip().splitlines()]
    rgbs = map(hsv99_to_rgb255, hsvs)
    for rgb in itertools.cycle(rgbs):
        yield "rgba({:02x}{:02x}{:02x}ff)".format(*rgb)


def hsv99_to_rgb255(hsv99):
    hsv1 = [x / 99 for x in hsv99]
    rgb1 = colorsys.hsv_to_rgb(*hsv1)
    return [int(x * 255) for x in rgb1]


def sigterm_exit(*args):
    raise KeyboardInterrupt


if __name__ == "__main__":
    signal.signal(signal.SIGTERM, sigterm_exit)
    try:
        main()
    except KeyboardInterrupt:
        pass
