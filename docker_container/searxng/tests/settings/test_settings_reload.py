import os
import shutil
import time
import yaml
import pytest


def _wait_for_service(searx_url, http, timeout=120):
    end = time.time() + timeout
    while time.time() < end:
        try:
            r = http.get(searx_url + "/", timeout=5)
            if r.status_code in (200, 301, 302):
                return True
        except Exception:
            pass
        time.sleep(2)
    return False


def test_settings_reload_restarts_container(searx_url, http):
    # This test requires access to the Docker socket (mounted into the test-runner)
    try:
        import docker
    except Exception:
        pytest.skip("docker SDK not available in test runtime")

    workspace_settings = "/workspace/settings.yml"
    if not os.path.exists(workspace_settings):
        pytest.skip("no settings.yml mounted into test-runner")

    # backup
    bak = workspace_settings + ".bak"
    shutil.copyfile(workspace_settings, bak)

    try:
        with open(workspace_settings, "r", encoding="utf-8") as fh:
            cfg = yaml.safe_load(fh) or {}

        # toggle a simple boolean under server.limiter (create path if missing)
        server = cfg.setdefault("server", {})
        orig_limiter = server.get("limiter", False)
        server["limiter"] = not orig_limiter

        # write modified settings
        with open(workspace_settings, "w", encoding="utf-8") as fh:
            yaml.safe_dump(cfg, fh)

        # restart the searxng container
        client = docker.from_env()
        try:
            cont = client.containers.get("searxng_test")
        except docker.errors.NotFound:
            pytest.skip("searxng_test container not found by Docker client")

        cont.restart(timeout=30)

        # wait for service
        ok = _wait_for_service(searx_url, http, timeout=120)
        assert ok, "service did not become healthy after restart"

    finally:
        # restore original settings and restart
        shutil.copyfile(bak, workspace_settings)
        try:
            client = None
            import docker
            client = docker.from_env()
            cont = client.containers.get("searxng_test")
            cont.restart(timeout=30)
        except Exception:
            pass
