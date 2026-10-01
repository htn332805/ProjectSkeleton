import os
import yaml
import pytest
from concurrent.futures import ThreadPoolExecutor


def load_settings(path="/workspace/settings.yml"):
    if not os.path.exists(path):
        return {}
    with open(path, "r", encoding="utf-8") as fh:
        return yaml.safe_load(fh) or {}


def test_rate_limiter_if_enabled(searx_url, http):
    cfg = load_settings()
    limiter = cfg.get("server", {}).get("limiter", False)
    if not limiter:
        pytest.skip("rate limiter disabled in settings.yml")

    def do_req(_):
        try:
            r = http.get(f"{searx_url}/search", params={"q": "rate limiter test", "format": "json"}, timeout=30)
            return r.status_code
        except Exception:
            return None

    with ThreadPoolExecutor(max_workers=10) as ex:
        results = list(ex.map(do_req, range(20)))

    # Expect at least one non-200 (e.g., 429) when limiter is active
    assert any((r is None) or (r >= 400 and r != 200) for r in results)
