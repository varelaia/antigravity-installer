---
title: Install Antigravity CLI (agy) on Windows
description: How to install Google Antigravity's agy command on Windows 10/11 with PowerShell or CMD, without administrator privileges, and configure the user PATH.
---

# Install Antigravity CLI on Windows

Works on **64-bit Windows 10 and 11**. **No administrator privileges required**.
The binary installs as `agy.exe` in `%LOCALAPPDATA%\agy\bin`.

## Option A — Official installer (1 command)

=== "PowerShell"

    ```powershell
    irm https://antigravity.google/cli/install.ps1 | iex
    ```

=== "CMD (Command Prompt)"

    ```bat
    curl -fsSL https://antigravity.google/cli/install.cmd -o install.cmd && install.cmd && del install.cmd
    ```

The installer downloads `agy.exe`, verifies its SHA512 checksum and places it in
`C:\Users\<YourUser>\AppData\Local\agy\bin`.

## Option B — Script from this repo (installs + fixes the PATH)

```powershell
git clone https://github.com/varelaia/antigravity-installer.git
cd antigravity-installer
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
./scripts/install_antigravity.ps1
```

This script wraps the official installer and **adds `%LOCALAPPDATA%\agy\bin` to the user
PATH** idempotently, so that `agy` works in any new terminal.

!!! tip "Antigravity CLI does NOT need Node.js or FNM on Windows"
    Old versions of guides suggested installing FNM/Node with `winget`. **It's not needed**:
    `agy` is a native binary. Node is only used for the optional
    [skills](skills.md) catalog.

## Configure the PATH manually

If `agy` is not recognized after Option A, add the directory to the user PATH:

```powershell
$bin = "$env:LOCALAPPDATA\agy\bin"
$cur = [Environment]::GetEnvironmentVariable("Path","User")
if ($cur -notlike "*$bin*") { [Environment]::SetEnvironmentVariable("Path","$cur;$bin","User") }
```

Close and **open a new terminal** for the change to take effect.

## Verify

```powershell
Get-Command agy        # shows the path of agy.exe
agy --version          # → 1.x.x
```

## Authentication

`agy` uses the **Windows Credential Manager**
to store your tokens securely.

Something failing? Check **[Troubleshooting](troubleshooting.md)**.
