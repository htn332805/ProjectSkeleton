def test_root_status(searx_url, http):
    resp = http.get(f"{searx_url}/", timeout=30)
    assert resp.status_code in (200, 301, 302)
