# Running the SearxNG End-to-End Test Suite

Prerequisites:

- Docker and docker-compose installed on the host.
- Network access to external search engines you plan to exercise.
- A populated `tests/secrets.env` file if any engines require credentials (see `tests/secrets.example.env`).
- The test-runner will optionally use the Docker socket to restart the `searxng_test` container for settings-reload tests. This requires mounting `/var/run/docker.sock` into the test-runner (the test overlay does this) and grants the tests control over Docker on the host — be aware of the security implications.

Quick run (from repository root):

```bash
cp tests/secrets.example.env tests/secrets.env
# Edit tests/secrets.env to populate any API keys required by configured engines
chmod +x scripts/*.sh
docker-compose -f docker-compose.yml -f docker-compose.test.yml up --build --abort-on-container-exit --exit-code-from test-runner
```

Artifacts are written to `tests/artifacts/` inside the repo by the test-runner.

Notes:

- The suite performs live requests to external services (no mocks). Expect flakiness; use retries and check artifacts for failures.
- If you want faster feedback, run a subset of tests using pytest markers (add markers as you expand the suite).
