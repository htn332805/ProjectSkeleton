def test_search_json(searx_url, http):
    resp = http.get(f"{searx_url}/search", params={"q": "searxng test", "format": "json"}, timeout=60)
    assert resp.status_code == 200
    data = resp.json()
    assert isinstance(data, dict)
    # Basic sanity: expect query or results field
    assert "results" in data or "query" in data
