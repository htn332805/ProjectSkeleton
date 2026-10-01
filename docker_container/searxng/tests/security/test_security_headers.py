import pytest


def test_security_headers_present(searx_url, http):
    resp = http.get(f"{searx_url}/", timeout=30)
    headers = resp.headers
    assert headers.get("Content-Security-Policy") is not None
    assert headers.get("X-Frame-Options") is not None
    assert headers.get("Referrer-Policy") is not None
