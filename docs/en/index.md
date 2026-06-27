---
title: How to install Antigravity CLI (agy) on Linux, macOS and Windows
description: Complete guide to install Antigravity CLI, Google's agy command, on Linux, macOS and Windows. Scripts, manuals and troubleshooting.
---

# How to install Antigravity CLI (`agy`)

**Antigravity CLI** is the terminal interface for Google's AI agent
[Antigravity](https://antigravity.google), invoked with the **`agy`** command. It brings
multi-step reasoning, multi-file editing and agent orchestration straight to your
terminal, optimized for keyboard-driven workflows and remote SSH sessions.

This guide explains how to install it **simply, quickly and verifiably** on
**Linux**, **macOS** and **Windows**, without administrator privileges.

!!! tip "In one sentence"
    Antigravity CLI is a **native Go binary**. It installs with a single command, **needs
    neither Node.js nor npm**, verifies its own SHA512 checksum and auto-updates.

## Quick install

=== "Linux / macOS"

    ```bash
    curl -fsSL https://antigravity.google/cli/install.sh | bash
    ```

=== "Windows (PowerShell)"

    ```powershell
    irm https://antigravity.google/cli/install.ps1 | iex
    ```

=== "Windows (CMD)"

    ```bat
    curl -fsSL https://antigravity.google/cli/install.cmd -o install.cmd && install.cmd && del install.cmd
    ```

Afterwards, open a **new** terminal and check:

```bash
agy --version
```

## What do I need before I start?

| System | Prerequisite |
|---|---|
| **Linux / WSL** | `curl` or `wget` (`sudo apt install -y curl`) |
| **macOS** | Nothing extra; the installer removes quarantine for you |
| **Windows 10/11** | PowerShell 5.1+ (no admin required) |

## Choose your path

<div class="grid cards" markdown>

- :material-linux: **[Linux](linux.md)** — install, PATH, musl, WSL
- :material-apple: **[macOS](macos.md)** — Intel and Apple Silicon, Keychain, zsh
- :material-microsoft-windows: **[Windows](windows.md)** — PowerShell, CMD, user PATH
- :material-puzzle: **[Skills (optional)](skills.md)** — the community catalog via `npx`
- :material-help-circle: **[FAQ](faq.md)** — why not npm?
- :material-wrench: **[Troubleshooting](troubleshooting.md)** — common errors

</div>

## Why this site?

The official installer already handles the hard part well (verified download, platform
detection, auto-update). What it **doesn't** do is persist the binary on your `PATH`
or explain what happened. Here you'll find:

- **Wrapper scripts** that add idempotent PATH persistence on top of the official installer.
- **Manuals**: [technical](manuales/tecnico.md), [operational](manuales/operativo.md) and [user](manuales/usuario.md).
- Answers to the real questions: *where does the binary live? how do I update it? how do I uninstall it?*

> Community project by [Varela Insights](https://www.varelainsights.com). Not affiliated with Google.
