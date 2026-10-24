#!/usr/bin/env python3
"""Format Kotlin staged bytes with the exact engine used by native Gradle checks."""

import hashlib
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
import urllib.request

VERSION = "1.5.0"
SHA256 = "a27854622198800f50971a049dcdba38f2105d47e7e7258786c7d28045c5735d"
URL = "https://repo.maven.apache.org/maven2/com/pinterest/ktlint/ktlint-cli/1.5.0/ktlint-cli-1.5.0-all.jar"
CACHE = (
    Path(os.environ.get("XDG_CACHE_HOME", str(Path.home() / ".cache")))
    / "hypertext-studio/formatters"
)
JAR = CACHE / ("ktlint-" + VERSION + "-all.jar")


def digest(path):
    result = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            result.update(chunk)
    return result.hexdigest()


def verified():
    return JAR.is_file() and digest(JAR) == SHA256


def setup():
    if not verified():
        CACHE.mkdir(parents=True, exist_ok=True)
        descriptor, name = tempfile.mkstemp(prefix=".ktlint-download-", dir=CACHE)
        temporary = Path(name)
        try:
            with (
                os.fdopen(descriptor, "wb") as output,
                urllib.request.urlopen(URL, timeout=60) as response,
            ):
                size = 0
                while chunk := response.read(1024 * 1024):
                    size += len(chunk)
                    if size > 128 * 1024 * 1024:
                        raise ValueError("KtLint download exceeded 128 MiB")
                    output.write(chunk)
            if digest(temporary) != SHA256:
                raise ValueError("KtLint download does not match its pinned SHA256")
            os.replace(temporary, JAR)
        finally:
            temporary.unlink(missing_ok=True)
    result = subprocess.run(
        java_command() + ["--version"], capture_output=True, timeout=30
    )
    if result.returncode or result.stdout.strip() != b"ktlint version 1.5.0":
        raise ValueError(
            "Pinned KtLint 1.5.0 could not execute; use the repository JDK"
        )
    print("Pinned KtLint 1.5.0 ready in the shared native cache.")


def java_command():
    java = shutil.which("java")
    if not java:
        raise ValueError(
            "Java is unavailable; prepare the repository JDK before formatter setup"
        )
    return [java, "-Djava.awt.headless=true", "-jar", str(JAR)]


def main():
    if sys.argv[1:] == ["--setup"]:
        setup()
        return 0
    if len(sys.argv) != 3 or sys.argv[1] != "ktlint":
        raise ValueError("Unknown native formatter; expected ktlint PATH or --setup")
    if not verified():
        raise ValueError(
            "Pinned KtLint is missing or changed. Run python3 .hypertext/formatter-tools/native.py --setup before committing"
        )
    # The virtual source path preserves nested .editorconfig discovery and script
    # parsing, while --stdin ensures the source file itself is never opened for write.
    virtual_path = Path(sys.argv[2].removesuffix(".template"))
    if not virtual_path.is_absolute():
        virtual_path = Path(__file__).resolve().parents[2] / virtual_path
    command = java_command() + [
        "--log-level=none",
        "--editorconfig=" + str(Path(__file__).with_name("kotlin.editorconfig")),
        "--format",
        "--stdin",
        "--stdin-path",
        str(virtual_path.resolve()),
    ]
    source = sys.stdin.buffer.read()
    result = subprocess.run(command, input=source, capture_output=True)
    sys.stderr.buffer.write(result.stderr)
    if result.returncode:
        return result.returncode
    # KtLint 1.5.0 reports parse errors on stderr while exiting zero and
    # emitting no source. Never let that behavior erase a staged file.
    if b"Not a valid Kotlin file" in result.stderr or (
        source.strip() and not result.stdout.strip()
    ):
        return 1
    sys.stdout.buffer.write(result.stdout)
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (OSError, ValueError, subprocess.SubprocessError) as error:
        print("Native formatter blocked: " + str(error), file=sys.stderr)
        raise SystemExit(1)
