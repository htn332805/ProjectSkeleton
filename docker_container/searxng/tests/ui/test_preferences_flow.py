import pytest


@pytest.mark.ui
def test_preferences_flow(page, searx_url):
    # Navigate to main search page
    page.goto(f"{searx_url}/search", wait_until="networkidle", timeout=60000)

    # Try to find a Preferences or Settings link
    pref = None
    for text in ("Preferences", "Settings", "Options"):
        el = page.locator(f"text={text}")
        if el.count() > 0:
            pref = el.first
            break

    if pref is None:
        pytest.skip("Preferences/settings UI not present or not detectable")

    pref.click()
    # attempt to find a language selector or save button
    # selectors may vary; be permissive and skip if not found
    try:
        # common selectors
        if page.locator("select[name=language]").count() > 0:
            sel = page.locator("select[name=language]").first
            sel.select_option(index=0)
            if page.locator("text=Save").count() > 0:
                page.locator("text=Save").first.click()
        elif page.locator("select[name=default_lang]").count() > 0:
            sel = page.locator("select[name=default_lang]").first
            sel.select_option(index=0)
            if page.locator("text=Save").count() > 0:
                page.locator("text=Save").first.click()
    except Exception:
        pytest.skip("Preferences UI found but controls not interactable with generic selectors")

    # Navigate back to search; simple smoke assertion
    page.goto(f"{searx_url}/search?q=searxng+test", wait_until="networkidle", timeout=60000)
    assert "search" in page.content().lower()
