# Codex RTL for macOS

An unofficial RTL runtime patch for `Codex Desktop` on `macOS`.

This project improves right-to-left rendering for Persian and Arabic text in the `Codex` desktop app while preserving left-to-right layout for code, terminals, inline code, commands, and file paths.

## Status

This is a local workaround, not official product support.

It does not modify the installed app bundle.

It attempts to launch the desktop app with a local debugging port and inject CSS and JavaScript at runtime.

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

1. Close the app if it is already running.
2. Launch the app with the local debugging port enabled:

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

## Older vs Newer App Versions

Older desktop builds used the app name:

```text
/Applications/Codex.app
```

On those builds, the standard commands were:

```bash
sh ./desktop/launch-codex-rtl-macos.sh
node ./desktop/inject.mjs
```

Newer desktop builds may use the app name:

```text
/Applications/ChatGPT.app
```

If the launcher does not auto-detect the correct bundle, run:

```bash
CODEX_APP_PATH="/Applications/ChatGPT.app" sh ./desktop/launch-codex-rtl-macos.sh
```

Then run:

```bash
node ./desktop/inject.mjs
```

Important note for newer builds:

The app rename from `Codex.app` to `ChatGPT.app` is supported by the launcher, but some newer builds may no longer expose the local `DevTools` endpoint even when launched with `--remote-debugging-port`.

In local testing on app version:

```text
26.707.51957
```

the app launched successfully, but the local endpoint at:

```text
http://127.0.0.1:9223/json
```

did not become available, so the injector could not attach.

This means:

- older builds are more likely to work with the current workaround,
- newer builds may require a different launch strategy or a new workaround.

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
CODEX_APP_PATH=<auto-detected>
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

- This is unofficial and may break after future desktop app updates.
- If the renderer fully reloads, you may need to run the injector again.
- DOM selectors may need adjustment across app versions.
- Some newer app versions may block or ignore the local `DevTools` port used by this workaround.

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

This project is licensed under the `MIT` License. See the `LICENSE` file for details.
