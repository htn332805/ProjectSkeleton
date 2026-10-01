import os
import pytest
import requests
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry


@pytest.fixture(scope="session")
def searx_url():
    return os.environ.get("SEARX_URL", "http://searxng:8080")


@pytest.fixture(scope="session")
def http(searx_url):
    s = requests.Session()
    retries = Retry(total=5, backoff_factor=0.5, status_forcelist=[429,500,502,503,504])
    adapter = HTTPAdapter(max_retries=retries)
    s.mount("http://", adapter)
    s.mount("https://", adapter)
    return s
