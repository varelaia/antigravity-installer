---
title: Install Antigravity CLI (agy) on Linux
description: How to install Google Antigravity's agy command on Linux (Ubuntu, Debian, Fedora, Arch, WSL), configure the PATH and verify the installation.
---

# Install Antigravity CLI on Linux

Works on any 64-bit distribution (Ubuntu, Debian, Fedora, Arch…), on
**WSL** and with **glibc or musl** (Alpine). No `sudo` required.

## Option A — Official installer (1 command)

```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

The installer downloads the binary to `~/.local/bin/agy`, verifies the SHA512 checksum and
configures the CLI. If `~/.local/bin` is not on your `PATH`, you'll have to add it (see below).

## Option B — Script from this repo (installs + fixes the PATH)

Recommended if you want the `PATH` to be persisted automatically:

```bash
git clone https://github.com/varelaia/antigravity-installer.git
cd antigravity-installer
chmod +x scripts/install_antigravity.sh
./scripts/install_antigravity.sh
```

This script wraps the official installer (inheriting its verification) and **persists
`~/.local/bin` in your `~/.bashrc`** idempotently.

## Configure the PATH manually

If you installed with Option A and `agy` is "not found", add the directory to the PATH:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

!!! warning "Why `source` is necessary"
    A child script cannot modify the `PATH` of the terminal that launched it. After
    installing, open a **new** terminal or run `source ~/.bashrc` to use `agy`
    in the current session.

## Verify

```bash
command -v agy        # → /home/USER/.local/bin/agy
agy --version         # → 1.x.x
```

## Linux-specific notes

- **WSL**: treat it as native Linux; use the `.sh` installer, not the Windows one.
- **musl / Alpine**: the official installer detects musl and pulls the correct binary.
- **Custom directory**: `curl -fsSL …/install.sh | bash -s -- --dir /chosen/path`.

Something failing? Check **[Troubleshooting](troubleshooting.md)**.
