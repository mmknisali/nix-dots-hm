"""Regression tests for offline validation and instance discovery. No live IPC."""

import importlib.util
import io
import json
import os
import re
import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

SCRIPTS = Path(os.environ.get("DOTS_SCRIPT_ROOT", Path(__file__).resolve().parents[1] / "scripts"))


def load(name):
    spec = importlib.util.spec_from_file_location(name, SCRIPTS / f"{name}.py")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


reload_hyprland = load("reload-hyprland")
jsonc = load("jsonc-check")


class ReloadTests(unittest.TestCase):
    def test_runtime_directory_falls_back_to_uid(self):
        with patch.dict(os.environ, {}, clear=True):
            with patch.object(os, "getuid", return_value=1234):
                with patch.object(Path, "is_dir", return_value=True):
                    with patch.object(subprocess, "check_output", return_value="[]") as ipc:
                        self.assertEqual(reload_hyprland.main(), 0)
                        self.assertEqual(ipc.call_args.kwargs["env"]["XDG_RUNTIME_DIR"], "/run/user/1234")

    def test_no_graphical_session_does_not_call_ipc(self):
        with tempfile.TemporaryDirectory() as runtime:
            with patch.dict(os.environ, {"XDG_RUNTIME_DIR": runtime}, clear=True):
                with patch.object(subprocess, "check_output") as ipc:
                    self.assertEqual(reload_hyprland.main(), 0)
                    ipc.assert_not_called()

    def test_multiple_instances_without_signature(self):
        with tempfile.TemporaryDirectory() as runtime:
            Path(runtime, "hypr").mkdir()
            replies = [json.dumps([{"instance": "first"}, {"instance": "second"}]), "ok\n", "\n", "ok", ""]
            with patch.dict(os.environ, {"XDG_RUNTIME_DIR": runtime}, clear=True):
                with patch.object(subprocess, "check_output", side_effect=replies) as ipc:
                    self.assertEqual(reload_hyprland.main(), 0)
                    self.assertEqual(ipc.call_count, 5)
                    self.assertEqual(ipc.call_args_list[1].args[0], ["hyprctl", "-i", "first", "reload", "full-reset"])
                    self.assertEqual(ipc.call_args_list[3].args[0], ["hyprctl", "-i", "second", "reload", "full-reset"])
                    self.assertNotIn("HYPRLAND_INSTANCE_SIGNATURE", ipc.call_args.kwargs["env"])

    def test_empty_instance_list(self):
        for response in ("[]", "\n]\n\n"):
            with self.subTest(response=response), tempfile.TemporaryDirectory() as runtime:
                Path(runtime, "hypr").mkdir()
                with patch.dict(os.environ, {"XDG_RUNTIME_DIR": runtime}, clear=True):
                    with patch.object(subprocess, "check_output", return_value=response) as ipc:
                        self.assertEqual(reload_hyprland.main(), 0)
                        self.assertEqual(ipc.call_count, 1)

    def test_reload_or_config_errors_are_failures(self):
        for replies in (["not JSON"], ["null"], ["{}"], ['[{"instance":"first"}]', "error"], ['[{"instance":"first"}]', "ok", "invalid rule"]):
            with self.subTest(replies=replies), tempfile.TemporaryDirectory() as runtime:
                Path(runtime, "hypr").mkdir()
                with patch.dict(os.environ, {"XDG_RUNTIME_DIR": runtime}, clear=True):
                    with patch.object(subprocess, "check_output", side_effect=replies), patch("sys.stderr", new_callable=io.StringIO):
                        self.assertEqual(reload_hyprland.main(), 1)


class JsoncTests(unittest.TestCase):
    def test_comments_and_trailing_commas(self):
        raw = '{"url": "https://example.test", /* comment */ "items": [1, 2,],}'
        parsed = json.loads(jsonc.strip_trailing_commas(jsonc.strip_comments(raw)))
        self.assertEqual(parsed, {"url": "https://example.test", "items": [1, 2]})

    def test_root_garbage_is_not_a_trailing_comma(self):
        with self.assertRaises(ValueError):
            json.loads(jsonc.strip_trailing_commas("[],"))


class WaybarTests(unittest.TestCase):
    def test_css_imports_have_their_dependencies(self):
        root = Path(os.environ.get("DOTS_WAYBAR_ROOT", Path(__file__).resolve().parents[1] / "config/waybar"))
        styles = list(root.rglob("*.css"))
        self.assertTrue(styles, "No styles found; the dependency test must not be vacuous")
        for style in styles:
            for dependency in re.findall(r"@import\s+['\"]([^'\"]+)['\"]", style.read_text()):
                with self.subTest(style=style, dependency=dependency):
                    self.assertTrue((style.parent / dependency).is_file())


if __name__ == "__main__":
    unittest.main()
