import os
import yaml
import pytest


def load_settings(path="/workspace/settings.yml"):
    if not os.path.exists(path):
        return {}
    with open(path, "r", encoding="utf-8") as fh:
        return yaml.safe_load(fh) or {}


def _find_engine_in_results(engine_id: str, results: list) -> bool:
    if not engine_id:
        return False
    needle = engine_id.lower()
    for r in results:
        # check common fields where engine id might appear
        for k in ("engine", "source", "title", "content", "excerpt"):
            v = r.get(k) if isinstance(r, dict) else None
            if isinstance(v, str) and needle in v.lower():
                return True
        # also check nested dicts
        if isinstance(r, dict):
            for val in r.values():
                if isinstance(val, str) and needle in val.lower():
                    return True
    return False


def test_engines_configured_and_presence(searx_url, http):
    cfg = load_settings()
    engines = cfg.get("engines", [])
    assert isinstance(engines, list)
    if not engines:
        pytest.skip("no engines configured in settings.yml")

    for engine in engines:
        engine_id = engine.get("engine") or engine.get("name") or engine.get("shortcut")
        # try a few times to account for external flakiness
        found = False
        last_data = None
        for attempt in range(3):
            resp = http.get(
                f"{searx_url}/search",
                params={"q": f"searxng test {engine_id}", "format": "json"},
                timeout=60,
            )
            assert resp.status_code == 200
            data = resp.json()
            last_data = data
            results = data.get("results") or []
            if _find_engine_in_results(engine_id, results):
                found = True
                break
        assert results is not None and isinstance(results, list)
        assert len(results) > 0, f"no results for engine {engine_id} (last_data={last_data})"
        assert found, f"engine id '{engine_id}' not found in any result fields (last_data={last_data})"
