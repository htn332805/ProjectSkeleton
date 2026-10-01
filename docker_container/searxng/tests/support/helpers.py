"""Utility helpers for tests."""
import os
import yaml


def load_settings(path: str = "/workspace/settings.yml") -> dict:
    """Load settings.yml if available inside the test-runner container."""
    if not os.path.exists(path):
        return {}
    with open(path, "r", encoding="utf-8") as fh:
        return yaml.safe_load(fh) or {}


def engine_names(settings: dict) -> list:
    return [e.get("name") or e.get("engine") or e.get("shortcut") for e in settings.get("engines", [])]
