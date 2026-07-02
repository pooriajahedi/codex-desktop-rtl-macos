#!/bin/sh

set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
DELAY_MS="${CODEX_RTL_DELAY_MS:-2500}"

if ! echo "$DELAY_MS" | grep -Eq '^[0-9]+$'; then
  echo "CODEX_RTL_DELAY_MS must be an integer."
  exit 1
fi

sh "$ROOT_DIR/desktop/launch-codex-rtl-macos.sh"

sleep_seconds=$(awk "BEGIN { printf \"%.3f\", $DELAY_MS / 1000 }")
sleep "$sleep_seconds"

node "$ROOT_DIR/desktop/inject.mjs"
