#!/usr/bin/env bash
set -euo pipefail

HOST="${1:-}"
PORT="${2:-}"
TIMEOUT="${3:-120}"

if [ -z "$HOST" ] || [ -z "$PORT" ]; then
  echo "Usage: $0 <host> <port> [timeout-seconds]" >&2
  exit 2
fi

END=$((SECONDS + TIMEOUT))
while true; do
  if python3 << EOF >/dev/null 2>&1
import socket
import sys
try:
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(5)
    s.connect(('${HOST}', ${PORT}))
    s.close()
    sys.exit(0)
except Exception:
    sys.exit(1)
EOF
  then
    echo "$HOST:$PORT reachable"
    exit 0
  fi
  if (( SECONDS >= END )); then
    echo "Timed out waiting for $HOST:$PORT" >&2
    exit 1
  fi
  sleep 2
done
