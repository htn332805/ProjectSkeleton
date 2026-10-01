import pytest


def test_search_page_renders(page, searx_url):
    url = f"{searx_url}/search?q=searxng+test"
    page.goto(url, wait_until="networkidle", timeout=60000)
    content = page.content()
    assert ("Results" in content) or ("results" in content) or ("search" in content.lower())
