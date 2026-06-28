#!/usr/bin/env python3
import json
import urllib.request

try:
    req = urllib.request.Request(
        "https://wttr.in/?format=%C+%t&lang=en",
        headers={"User-Agent": "curl/8.0"}
    )
    with urllib.request.urlopen(req, timeout=5) as resp:
        weather = resp.read().decode().strip()
    print(json.dumps({"text": weather, "alt": weather, "tooltip": weather}))
except Exception:
    print(json.dumps({"text": "", "alt": "N/A", "tooltip": "Weather unavailable"}))
