---
title: Operational manual — Antigravity CLI (agy)
description: Operating Antigravity CLI: update, reinstall, uninstall, fleet/CI install, Docker containers and custom directory.
---

# Operational manual

Day-to-day operational tasks: update, uninstall, automate and install at
scale.

## Update

No action required: **the CLI auto-updates in the background** during normal use.
To force the latest version with a clean install:

```bash
rm ~/.local/bin/agy
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

## Reinstall / fresh install

The installer is idempotent and does not overwrite if it already exists. Delete the binary first:

=== "Linux / macOS"

    ```bash
    rm ~/.local/bin/agy
    ./scripts/install_antigravity.sh
    ```

=== "Windows"

    ```powershell
    Remove-Item "$env:LOCALAPPDATA\agy\bin\agy.exe" -Force
    ./scripts/install_antigravity.ps1
    ```

## Uninstall

```bash
# Linux / macOS
rm ~/.local/bin/agy
# (optional) remove the PATH line from ~/.bashrc or ~/.zshrc
# (optional) delete the config: rm -rf ~/.gemini
```

```powershell
# Windows
Remove-Item "$env:LOCALAPPDATA\agy\bin\agy.exe" -Force
# (optional) remove the user PATH entry and the %USERPROFILE%\.gemini folder
```

## Unattended install (CI / fleet)

The installer is non-interactive, so it works as-is in pipelines:

```bash
# Install in an explicit directory and add it to the job's PATH
curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"
agy --version
```

!!! tip "Idempotency in CI"
    Since it exits early if it already exists, you can call it on every build without penalty.

## Docker / containers

For your own images, install in a layer and pin the PATH:

```dockerfile
RUN curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir /usr/local/bin
# /usr/local/bin is usually already on the container's PATH
RUN agy --version
```

## Custom directory

```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir /chosen/path
```

## Health checks

```bash
command -v agy && agy --version    # installed and on PATH
echo "$PATH" | tr ':' '\n' | grep -q "$HOME/.local/bin" && echo "PATH OK"
```
