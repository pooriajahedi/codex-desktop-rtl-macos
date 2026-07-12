#!/bin/sh

set -eu

PORT="${CODEX_RTL_PORT:-9223}"
APP_PATH="${CODEX_APP_PATH:-}"
EXECUTABLE=""

find_default_app() {
  for candidate in \
    "/Applications/Codex.app" \
    "/Applications/ChatGPT.app" \
    "/Applications/ChatGPT Classic.app" \
    "$HOME/Applications/Codex.app" \
    "$HOME/Applications/ChatGPT.app" \
    "$HOME/Applications/ChatGPT Classic.app"
  do
    if [ -d "$candidate" ]; then
      echo "$candidate"
      return 0
    fi
  done

  return 1
}

find_executable() {
  app_path="$1"

  for executable_name in Codex ChatGPT; do
    candidate="$app_path/Contents/MacOS/$executable_name"
    if [ -x "$candidate" ]; then
      echo "$candidate"
      return 0
    fi
  done

  return 1
}

if ! echo "$PORT" | grep -Eq '^[0-9]+$'; then
  echo "CODEX_RTL_PORT must be an integer."
  exit 1
fi

if [ "$PORT" -lt 1024 ] || [ "$PORT" -gt 65535 ]; then
  echo "CODEX_RTL_PORT must be between 1024 and 65535."
  exit 1
fi

if [ -z "$APP_PATH" ]; then
  if ! APP_PATH="$(find_default_app)"; then
    echo "Could not find Codex or ChatGPT in the default Applications folders."
    echo "Set CODEX_APP_PATH explicitly and try again."
    exit 1
  fi
fi

if [ ! -d "$APP_PATH" ]; then
  echo "App bundle was not found at: $APP_PATH"
  exit 1
fi

if ! EXECUTABLE="$(find_executable "$APP_PATH")"; then
  echo "Could not find a supported executable inside: $APP_PATH"
  exit 1
fi

if pgrep -x "Codex" >/dev/null 2>&1 || pgrep -x "ChatGPT" >/dev/null 2>&1; then
  echo "Codex or ChatGPT is already running."
  echo "Close it first, then run this launcher again so the debugging port is enabled."
  exit 1
fi

echo "Starting app with local DevTools port $PORT..."
"$EXECUTABLE" \
  --remote-debugging-address=127.0.0.1 \
  --remote-debugging-port="$PORT" \
  >/dev/null 2>&1 &

echo "App started from: $APP_PATH"
echo "Keep it open, then run: npm run inject"
