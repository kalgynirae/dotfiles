from __future__ import annotations

import sys
import traceback
from contextlib import contextmanager
from dataclasses import dataclass
from difflib import unified_diff
from enum import Enum
from pathlib import Path
from textwrap import indent
from typing import Callable, Iterator


def abbreviate_home(path: Path) -> str:
    return str(Path("~") / path.relative_to(Path.home()))


@dataclass
class Result:
    log_func: Callable[[str], None]
    diff_args: tuple[str, str, str, str] | None = None
    exception: Exception | None = None

    def log(self, name: str) -> None:
        self.log_func(name)
        if self.exception:
            log_exception(self.exception)
        if self.diff_args:
            log_diff(*self.diff_args)

    @classmethod
    def ok(cls) -> Result:
        return cls(log_ok)

    @classmethod
    def error(cls, e: Exception) -> Result:
        return cls(log_error, exception=e)

    @classmethod
    def changed(cls, diff_args: tuple[str, str, str, str] | None = None) -> Result:
        return cls(log_changed, diff_args=diff_args)

    @classmethod
    def dry(cls, diff_args: tuple[str, str, str, str] | None = None) -> Result:
        return cls(log_dry, diff_args=diff_args)


@dataclass
class _Color:
    set: str
    reset: str


class Color(Enum):
    RED = _Color("\x1b[31m", "\x1b[39m")
    YELLOW = _Color("\x1b[33m", "\x1b[39m")
    GREEN = _Color("\x1b[32m", "\x1b[39m")
    CYAN = _Color("\x1b[36m", "\x1b[39m")


def log(action: str, color: Color, message: str) -> None:
    print(f"\x1b[1m{action}\x1b[22m {color.value.set}{message}{color.value.reset}")


def log_ok(stepname: str) -> None:
    log("     ok", Color.GREEN, stepname)


def log_changed(stepname: str) -> None:
    log("changed", Color.YELLOW, stepname)


def log_error(stepname: str) -> None:
    log("  error", Color.RED, stepname)


def log_dry(stepname: str) -> None:
    log("    dry", Color.CYAN, stepname)


INDENT = " " * 10


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
        print(f"{INDENT}\033[2m{line}\033[22m", file=sys.stderr)
    for line in difflines:
        match line[0]:
            case "@":
                print(f"{INDENT}\033[2;36m{line}\033[39m", file=sys.stderr)
            case "-":
                print(f"{INDENT}\033[31m{line}\033[39m", file=sys.stderr)
            case "+":
                print(f"{INDENT}\033[32m{line}\033[39m", file=sys.stderr)
            case " ":
                print(f"{INDENT}\033[2m{line}\033[22m", file=sys.stderr)


def log_exception(e: Exception) -> None:
    print(indent("".join(traceback.format_exception(e)), INDENT), end="")


@contextmanager
def step(name: str) -> Iterator[None]:
    try:
        yield
    except Exception as e:
        log_error(name)
        log_exception(e)
    else:
        log_ok(name)
