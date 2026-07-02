# Codex RTL for macOS

An unofficial RTL runtime patch for `Codex Desktop` on `macOS`.

This project improves right-to-left rendering for Persian and Arabic text in the `Codex` desktop app while preserving left-to-right layout for code, terminals, inline code, commands, and file paths.

## Status

This is a local workaround, not official product support.

It does not modify the installed `Codex.app` bundle.

It launches `Codex` with a local debugging port and injects CSS and JavaScript at runtime.

## Features

- Improves RTL layout for Persian and Arabic conversation text.
- Keeps mixed RTL and LTR text more readable.
- Preserves LTR rendering for code blocks, terminals, file paths, and inline code.
- Avoids patching application files on disk.
- Uses only a local `DevTools` connection.

## Requirements

- `macOS`
- `Codex Desktop`
- `Node.js 22+`

No package installation is required on recent `Node.js` versions with built-in `WebSocket`.

## Quick Start

Clone the repository:

```bash
git clone https://github.com/pooriajahedi/codex-desktop-rtl-macos.git
cd codex-desktop-rtl-macos
```

1. Close `Codex` if it is already running.
2. Launch `Codex` with the local debugging port enabled:

```bash
sh ./desktop/launch-codex-rtl-macos.sh
```

3. After the app opens, inject the RTL patch:

```bash
node ./desktop/inject.mjs
```

You can also use the helper script that performs both steps with a short delay:

```bash
sh ./desktop/run-codex-rtl-macos.sh
```

## Updating

Pull the latest changes before using a newer version:

```bash
git pull
```

The current initial public version is `v0.1.0`.

## Environment Variables

The scripts support these optional environment variables:

- `CODEX_APP_PATH`
- `CODEX_RTL_PORT`
- `CODEX_RTL_DELAY_MS`

Default values:

```bash
CODEX_APP_PATH=/Applications/Codex.app
CODEX_RTL_PORT=9223
CODEX_RTL_DELAY_MS=2500
```

## How It Works

`Codex` is an Electron-based desktop app.

This project starts the app with a local `Chromium DevTools Protocol` port and injects a runtime patch into the renderer process.

The injected logic:

- adds RTL-aware CSS rules,
- detects likely Persian and Arabic text blocks,
- applies RTL direction where appropriate,
- keeps code-like and terminal-like areas in LTR mode.

## Security Notes

- The injector only targets local `DevTools` endpoints.
- Non-local `WebSocket` targets are rejected.
- The patch is applied in memory and does not rewrite application files.

## Limitations

- This is unofficial and may break after future `Codex` UI updates.
- If the renderer fully reloads, you may need to run the injector again.
- DOM selectors may need adjustment across app versions.

## Project Structure

```text
desktop/
  launch-codex-rtl-macos.sh
  run-codex-rtl-macos.sh
  inject.mjs
src/
  rtl-style.css
  injected.js
```

## Suggested GitHub Description

`Unofficial RTL runtime patch for Codex Desktop on macOS.`

## License

`MIT` is a good default choice for this project.
