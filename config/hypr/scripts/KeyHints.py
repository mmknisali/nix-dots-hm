#!/usr/bin/env python3
"""Generate a keybind cheat sheet from the running Hyprland instance.

The list is read back from `hyprctl binds -j`, so it always matches the
configuration that is actually loaded, including the descriptions set with the
`description` bind flag.
"""

import json
import subprocess
import sys

# Modifier bits as used by Hyprland (see CKeybindManager::stringToModMask).
MODIFIERS = [
    (1, "SHIFT"),
    (2, "CAPS"),
    (4, "CTRL"),
    (8, "ALT"),
    (16, "MOD2"),
    (32, "MOD3"),
    (64, "SUPER"),
    (128, "MOD5"),
]

# Keys that are nicer to read in their written form.
KEY_NAMES = {
    "backslash": "\\",
    "slash": "/",
    "Return": "Enter",
    "Escape": "Esc",
    "Delete": "Del",
    "space": "Space",
    "Tab": "Tab",
    "Print": "Print",
    "XF86AudioMute": "XF86AudioMute",
}

# Binds that are not interesting in a cheat sheet.
SKIP_KEYS = {"", "catchall"}


def modifier_names(modmask: int) -> list[str]:
    return [name for bit, name in MODIFIERS if modmask & bit]


def format_key(bind: dict) -> str:
    key = bind.get("key") or ""
    if key.startswith("mouse:"):
        button = key.split(":", 1)[1]
        return f"Mouse {button}"
    key = KEY_NAMES.get(key, key)
    mods = modifier_names(bind.get("modmask", 0))
    return " + ".join(mods + [key]) if mods else key


def collect() -> list[dict]:
    try:
        raw = subprocess.run(
            ["hyprctl", "binds", "-j"],
            check=True,
            capture_output=True,
            text=True,
        ).stdout
        binds = json.loads(raw)
    except (OSError, subprocess.CalledProcessError, json.JSONDecodeError) as error:
        print(f"could not read the keybinds: {error}", file=sys.stderr)
        return []

    seen = set()
    result = []
    for bind in binds:
        key = bind.get("key") or ""
        if key in SKIP_KEYS or key.startswith("mouse:"):
            continue
        description = (bind.get("description") or "").strip()
        if not description:
            continue
        combo = format_key(bind)
        if combo in seen:
            continue
        seen.add(combo)
        result.append({"combo": combo, "description": description})
    return result


def main() -> int:
    binds = collect()
    if not binds:
        print("No keybinds with a description found.", file=sys.stderr)
        return 1

    width = max(len(bind["combo"]) for bind in binds)
    for bind in sorted(binds, key=lambda b: (b["combo"].split(" + ")[0], b["combo"])):
        print(f"  {bind['combo']:<{width}}  {bind['description']}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
