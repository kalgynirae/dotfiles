from __future__ import annotations

import logging
import os
import shlex
import subprocess
from abc import ABCMeta, abstractmethod
from dataclasses import dataclass
from pathlib import Path
from shutil import copyfile
from tempfile import NamedTemporaryFile
from typing import Mapping

from jinja2 import Environment as JinjaEnvironment

from .environment import environment
from .logging import (
    Result,
    abbreviate_home,
    log_changed,
    log_diff,
    log_dry,
    log_error,
    log_ok,
)

logger = logging.getLogger()


def run(args: list[str | Path], env: Mapping[str, str] | None = None) -> None:
    str_args = list(map(str, args))
    if environment.get().dry_run:
        log_dry(f"Run: {shlex.join(str_args)}")
    else:
        subprocess.run(
            str_args, check=True, env=None if env is None else os.environ | env
        )


def gsettings_set(path: str, value: str) -> None:
    schema, key = path.rsplit(".", maxsplit=1)
    run(["gsettings", "set", schema, key, value])


def render(source_relpath: Path | str, *, mode: int | None = None) -> RenderedFile:
    return RenderedFile(Path.home() / "dotfiles" / source_relpath, mode=mode)


def symlink_to(source_relpath: Path | str) -> Symlink:
    return Symlink(Path.home() / "dotfiles" / source_relpath)


class Output(metaclass=ABCMeta):
    def name(self, dest: Path) -> str:
        return f"{type(self).__name__}: {abbreviate_home(dest)}"

    @abstractmethod
    def install(self, dest: Path) -> Result:
        ...


@dataclass
class RenderedFile(Output):
    source: Path
    mode: int | None

    def install(self, dest: Path) -> Result:
        source_data = self.source.read_text()
        jinja_env = JinjaEnvironment(
            trim_blocks=True,
            lstrip_blocks=True,
            keep_trailing_newline=True,
            autoescape=False,
        )
        jinja_env.filters["shellquote"] = shlex.quote
        template = jinja_env.from_string(source_data)
        rendered = template.render(environment.get().as_context())
        diff_args = None
        if dest.is_file() and not dest.is_symlink():
            existing = dest.read_text()
            if rendered == existing:
                return Result.ok()
            if dest.stat().st_mtime > self.source.stat().st_mtime:
                raise RuntimeError("dest was updated more recently than source")
            diff_args = (existing, abbreviate_home(dest), rendered, self.source.stem)

        if environment.get().dry_run:
            return Result.dry(diff_args)

        mkdir_parents_and_backup_existing(dest)

        # Write to a tempfile and copy into place
        with NamedTemporaryFile(
            mode="w", prefix=f"{self.source.stem}-", delete=False
        ) as f:
            f.write(rendered)
        temp = Path(f.name)
        logger.debug("mv %r %r", str(temp), str(dest))
        copyfile(temp, dest, follow_symlinks=False)

        if self.mode is not None:
            dest.chmod(self.mode)

        # Set the dest's mtime to the source's mtime
        dest_atime = dest.stat().st_atime_ns
        source_mtime = self.source.stat().st_mtime_ns
        logger.debug("touch -mr %r %r", str(self.source), str(dest))
        os.utime(dest, ns=(dest_atime, source_mtime))

        return Result.changed(diff_args)


@dataclass
class Symlink(Output):
    target: Path

    def install(self, dest: Path) -> Result:
        if not self.target.exists():
            raise RuntimeError("target doesn't exist")
        dest_to_source_relpath = os.path.relpath(self.target, start=dest.parent)
        if dest.is_symlink():
            if os.readlink(dest) == dest_to_source_relpath:
                return Result.ok()
            else:
                raise RuntimeError("dest is already a symlink")
        if dest.is_dir():
            raise RuntimeError("dest is already a directory")
        if dest.exists() and not dest.is_file():
            raise RuntimeError("dest exists but is not a symlink, directory, or file")

        if environment.get().dry_run:
            return Result.dry()

        mkdir_parents_and_backup_existing(dest)

        logger.debug("ln -s %r %r", dest_to_source_relpath, str(dest))
        dest.symlink_to(dest_to_source_relpath)
        return Result.changed()


def mkdir_parents_and_backup_existing(dest: Path) -> None:
    for p in dest.parents:
        if p.is_symlink():
            raise RuntimeError(f"{str(p)!r} is a symlink")
    if environment.get().dry_run:
        return
    if dest.is_file() or dest.is_symlink():
        dest_old = dest.with_name(dest.name + ".old")
        logger.debug("mv %r -> %r", str(dest), str(dest_old))
        dest.rename(dest_old)
    if not (dest_parent := dest.parent).exists():
        logger.debug("mkdir -p %r", str(dest_parent))
        dest_parent.mkdir(parents=True)
