#!/usr/bin/env bash
set -euo pipefail

# Allow overriding tests root (useful for container mount layouts)
TEST_ROOT=${TEST_ROOT:-/tests}

cd "$TEST_ROOT" || exit 1
mkdir -p "$TEST_ROOT/artifacts"

# Install Python deps if provided
if [ -f requirements.txt ]; then
  python -m pip install --upgrade pip setuptools wheel
  pip install -r requirements.txt
fi

# If playwright is installed, ensure browsers are installed
python - <<'PY'
import importlib.util, sys
if importlib.util.find_spec("playwright") is not None:
    sys.exit(0)
else:
    sys.exit(1)
PY
if [ $? -eq 0 ]; then
  python -m playwright install --with-deps || true
fi

TEST_RC=0

# Run pytest (adjust markers/flags as suite grows)
pytest -q --junitxml="$TEST_ROOT/artifacts/junit.xml" --maxfail=1 --disable-warnings tests || TEST_RC=$?

# Collect docker-compose logs for diagnosis (if available)
if command -v docker-compose >/dev/null 2>&1; then
  docker-compose -f /workspace/docker-compose.yml -f /workspace/docker-compose.test.yml logs --no-color searxng > "$TEST_ROOT/artifacts/searxng.log" || true
fi

exit ${TEST_RC:-0}
