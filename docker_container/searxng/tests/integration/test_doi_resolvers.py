import os
import yaml
import pytest


def load_settings(path="/workspace/settings.yml"):
    if not os.path.exists(path):
        return {}
    with open(path, "r", encoding="utf-8") as fh:
        return yaml.safe_load(fh) or {}


def test_default_doi_resolver_present():
    cfg = load_settings()
    doi_map = cfg.get("doi_resolvers", {})
    assert isinstance(doi_map, dict)
    default = cfg.get("default_doi_resolver")
    assert default is not None, "default_doi_resolver not set in settings.yml"
    assert default in doi_map, f"default_doi_resolver '{default}' not present in doi_resolvers mapping"


@pytest.mark.integration
def test_doi_resolvers_resolve(searx_url, http):
    cfg = load_settings()
    doi_map = cfg.get("doi_resolvers", {})
    if not doi_map:
        pytest.skip("no doi_resolvers configured in settings.yml")

    sample_doi = "10.1038/nphys1170"

    for resolver, base in doi_map.items():
        if not base:
            pytest.skip(f"resolver '{resolver}' has empty base URL")
        url = base.rstrip("/") + "/" + sample_doi
        # Try once with a short retry to account for transient network issues
        try:
            resp = http.get(url, timeout=30, allow_redirects=True)
        except Exception as e:
            pytest.fail(f"request to DOI resolver '{resolver}' ({url}) raised: {e}")

        assert 200 <= resp.status_code < 400, (
            f"DOI resolver '{resolver}' returned status {resp.status_code} for {url} (len={len(resp.content)})"
        )
