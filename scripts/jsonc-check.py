#!/usr/bin/env python3
"""Validate Waybar JSON/JSONC configuration files.

Waybar parses its configuration with jsoncpp, which accepts `//` and `/* */`
comments as well as trailing commas. Strict JSON parsers do not. This script
reproduces the jsoncpp dialect so the files can be checked with a plain JSON
parser, and reports every file that is still malformed.

Usage: jsonc-check.py FILE [FILE ...]
"""

import json
import re
import sys

_TRAILING_COMMA = re.compile(r",(\s*[}\]])")


def strip_comments(text: str) -> str:
    """Remove // and /* */ comments, leaving string literals untouched."""
    out = []
    i = 0
    n = len(text)
    in_string = False
    while i < n:
        char = text[i]
        if in_string:
            out.append(char)
            if char == "\\" and i + 1 < n:
                out.append(text[i + 1])
                i += 2
                continue
            if char == '"':
                in_string = False
            i += 1
            continue
        if char == '"':
            in_string = True
            out.append(char)
            i += 1
            continue
        if char == "/" and i + 1 < n and text[i + 1] == "/":
            while i < n and text[i] != "\n":
                i += 1
            continue
        if char == "/" and i + 1 < n and text[i + 1] == "*":
            i += 2
            while i + 1 < n and not (text[i] == "*" and text[i + 1] == "/"):
                i += 1
            i += 2
            continue
        out.append(char)
        i += 1
    return "".join(out)


def strip_trailing_commas(text: str) -> str:
    """Remove commas that directly precede a closing brace or bracket."""
    previous = None
    while previous != text:
        previous = text
        text = _TRAILING_COMMA.sub(r"\1", text)
    return text


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print("usage: jsonc-check.py FILE [FILE ...]", file=sys.stderr)
        return 2

    failures = 0
    for path in argv[1:]:
        try:
            with open(path, encoding="utf-8") as handle:
                raw = handle.read()
            json.loads(strip_trailing_commas(strip_comments(raw)))
        except (OSError, ValueError) as error:
            failures += 1
            print(f"FAIL {path}: {error}", file=sys.stderr)

    if failures:
        print(f"{failures} of {len(argv) - 1} file(s) failed to parse", file=sys.stderr)
        return 1

    print(f"ok: {len(argv) - 1} file(s) parsed")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
