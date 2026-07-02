#!/bin/sh

set -eu

PORT="${CODEX_RTL_PORT:-9223}"
APP_PATH="${CODEX_APP_PATH:-/Applications/Codex.app}"
EXECUTABLE="$APP_PATH/Contents/MacOS/Codex"

if ! echo "$PORT" | grep -Eq '^[0-9]+$'; then
  echo "CODEX_RTL_PORT must be an integer."
  exit 1
fi

if [ "$PORT" -lt 1024 ] || [ "$PORT" -gt 65535 ]; then
  echo "CODEX_RTL_PORT must be between 1024 and 65535."
  exit 1
fi

if [ ! -d "$APP_PATH" ]; then
  echo "Codex.app was not found at: $APP_PATH"
  exit 1
fi

if [ ! -x "$EXECUTABLE" ]; then
  echo "Could not find the Codex executable at: $EXECUTABLE"
  exit 1
fi

if pgrep -x "Codex" >/dev/null 2>&1; then
  echo "Codex is already running."
  echo "Close it first, then run this launcher again so the debugging port is enabled."
  exit 1
fi

echo "Starting Codex with local DevTools port $PORT..."
"$EXECUTABLE" \
  --remote-debugging-address=127.0.0.1 \
  --remote-debugging-port="$PORT" \
  >/dev/null 2>&1 &

echo "Codex started."
echo "Keep it open, then run: npm run inject"
