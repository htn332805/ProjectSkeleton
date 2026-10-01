import pytest


def _has_title(result: dict) -> bool:
    for k in ("title", "name", "header", "text", "excerpt"):
        v = result.get(k)
        if isinstance(v, str) and v.strip():
            return True
    return False


def _has_url(result: dict) -> bool:
    for k in ("url", "link", "href", "uri"):
        v = result.get(k)
        if isinstance(v, str) and v.strip():
            return True
    return False


def _has_engine(result: dict) -> bool:
    for k in ("engine", "source", "backend"):
        v = result.get(k)
        if isinstance(v, str) and v.strip():
            return True
    return False


@pytest.mark.integration
def test_search_result_schema_basic(searx_url, http):
    resp = http.get(f"{searx_url}/search", params={"q": "searxng schema test", "format": "json"}, timeout=60)
    assert resp.status_code == 200
    data = resp.json()
    assert isinstance(data, dict)
    results = data.get("results") or []
    assert isinstance(results, list)
    assert len(results) > 0, "search returned no results to validate schema against"

    for r in results:
        assert isinstance(r, dict), f"result item is not a dict: {repr(r)[:200]}"
        assert _has_title(r), f"result missing title-like field: {repr(r)[:200]}"
        assert _has_url(r), f"result missing url-like field: {repr(r)[:200]}"
        assert _has_engine(r), f"result missing engine/source field: {repr(r)[:200]}"
