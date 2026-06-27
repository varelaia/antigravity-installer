---
title: Frequently asked questions about Antigravity CLI (agy)
description: Why doesn't Antigravity CLI install with npm? Where does the agy binary live? How is it updated? Answers to common installation questions.
---

# Frequently asked questions

## Why doesn't Antigravity CLI install with `npm`?

Because **`agy` is a native binary compiled in Go**, not a Node.js package. It's
distributed as an executable downloaded directly from Google, not from the npm registry.
Compiling to Go gives it near-instant startup, lower memory usage and
operating-system-level security isolation.

That's why the official way to install it is the direct script:

```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

## So, what is `npm` for in Antigravity?

Only for the **optional** [*Antigravity Awesome Skills*](skills.md) catalog, which is
distributed via npm and installed with `npx`. That does **not** install the CLI, it only
adds skills to your existing configuration. The CLI itself never needs Node.

## Where is the binary installed?

| System | Path |
|---|---|
| Linux / macOS | `~/.local/bin/agy` |
| Windows | `%LOCALAPPDATA%\agy\bin\agy.exe` |

## How do I update Antigravity CLI?

**You don't have to do anything**: the CLI auto-updates in the background during normal
use. If you want a fresh install, delete the binary and run the
installer again (see [Operational manual](manuales/operativo.md)).

## Do I need administrator privileges (`sudo`)?

No. Everything installs in your user space (`~/.local/bin` or `%LOCALAPPDATA%`).

## Is `curl … | bash` safe?

The official installer **verifies the binary's SHA512 checksum** before installing it and
aborts if it doesn't match ("Security Halt"). Even so, if you prefer to inspect before
running, download the script to a file, read it and then run it.

## Where does `agy` store my credentials?

In the operating system's secure keyring: **Keychain** (macOS), **Secret Service /
dbus** (Linux) or **Credential Manager** (Windows).

## Does it work on WSL, Apple Silicon, ARM, Alpine (musl)?

Yes. The installer detects the system, architecture (amd64/arm64) and libc (glibc/musl)
and pulls the correct binary. On **WSL** use the Linux installer, not the Windows one.

## Is this official from Google?

No. This site and its scripts are a **community project** by
[Varela Insights](https://www.varelainsights.com). The installer *delegates* to Google's
official one; it doesn't replace it. Antigravity and `agy` are trademarks of Google LLC.
