"""Check effective Rofi settings without launching an interactive menu."""

import os
import re
import subprocess
import unittest
from pathlib import Path


class RofiTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        rofi = os.environ.get("DOTS_ROFI_BIN", "rofi")
        root = Path(os.environ.get("DOTS_ROFI_ROOT", Path(__file__).resolve().parents[1] / "config/rofi"))
        command = [rofi, "-config", str(root / "config.rasi")]
        cls.config = subprocess.check_output(command + ["-dump-config"], text=True, timeout=15)
        cls.theme = subprocess.check_output(command + ["-dump-theme"], text=True, timeout=15)

    def test_sorter_supported_by_rofi_2_0(self):
        # Dumping a configuration does NOT execute config_sanity_check().
        # Rofi 2.0 rejects fzf-v2 at startup despite a successful theme dump.
        method = re.search(r'^\s*sorting-method:\s*"([^"]+)";', self.config, re.M)
        self.assertIsNotNone(method)
        self.assertIn(method[1], {"normal", "levenshtein", "fzf"})

    def test_footer_does_not_replace_error_dialog_text(self):
        textbox = re.search(r"^textbox \{(.*?)^\}", self.theme, re.M | re.S)
        self.assertIsNotNone(textbox)
        self.assertNotRegex(textbox[1], r"\bstr:")

    def test_footer_does_not_expand_into_results(self):
        footer = re.search(r"^textbox-footer \{(.*?)^\}", self.theme, re.M | re.S)
        self.assertIsNotNone(footer)
        self.assertRegex(footer[1], r"\bexpand:\s*false;")
        mainbox = re.search(r"^mainbox \{(.*?)^\}", self.theme, re.M | re.S)
        self.assertIsNotNone(mainbox)
        self.assertIn('"textbox-footer"', mainbox[1])


if __name__ == "__main__":
    unittest.main()
