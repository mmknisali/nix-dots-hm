#!/usr/bin/env python3
"""Reload each running same-user Hyprland instance after linking its config."""

import json
import os
import subprocess
import sys
from pathlib import Path


def main() -> int:
    runtime = Path(os.environ.get("XDG_RUNTIME_DIR", f"/run/user/{os.getuid()}"))
    if not (runtime / "hypr").is_dir():
        return 0
    env = {**os.environ, "XDG_RUNTIME_DIR": str(runtime)}
    try:
        raw = subprocess.check_output(
            ["hyprctl", "-j", "instances"], env=env, text=True, timeout=10
        )
        # Hyprland 0.56.2 emits a bare closing bracket for an empty instance
        # list. A leftover runtime directory after logout is not an error.
        if raw.strip() == "]":
            return 0
        instances = json.loads(raw)
        if not isinstance(instances, list):
            raise ValueError("instance discovery did not return a list")
        for instance in instances:
            selector = instance["instance"]
            # A full reset also recovers sessions still using the old hyprlang
            # parser after migrating the main configuration to Lua.
            result = subprocess.check_output(
                ["hyprctl", "-i", selector, "reload", "full-reset"],
                env=env, text=True, timeout=15,
            ).strip()
            if result != "ok":
                raise RuntimeError(f"{selector}: reload failed: {result}")
            errors = subprocess.check_output(
                ["hyprctl", "-i", selector, "configerrors"],
                env=env, text=True, timeout=10,
            ).strip()
            if errors:
                raise RuntimeError(f"{selector}: Hyprland config errors:\n{errors}")
    except (OSError, ValueError, KeyError, TypeError, RuntimeError, subprocess.SubprocessError) as error:
        print(f"Hyprland reload: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
