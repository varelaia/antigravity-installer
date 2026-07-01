---
title: Install Antigravity CLI (agy) on macOS
description: How to install Google Antigravity's agy command on macOS (Intel and Apple Silicon), resolve Gatekeeper quarantine, configure zsh and the Keychain.
---

# Install Antigravity CLI on macOS

Works on **Intel (x86_64)** and **Apple Silicon (arm64)**. No administrator
privileges required. The default shell on modern macOS is **zsh**.

!!! danger "Requirement: macOS 12.0 (Monterey) or later — check this FIRST"
    `agy` is a binary built for **macOS 12.0+**. On **macOS 11 (Big Sur) or earlier** it
    installs but **crashes on connect** (`dyld: Symbol not found: _SecTrustCopyCertificateChain`).
    **Before installing anything**, check your version:

    ```bash
    sw_vers
    ```

    If `ProductVersion` is **below 12.0** → `agy` can't run on that Mac. Update macOS
    (System Settings → Software Update) or use a newer Mac / Linux / Windows.

## Option A — Official installer (1 command)

```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

The installer:

- Detects your architecture (Intel or Apple Silicon) automatically.
- Downloads `agy` to `~/.local/bin/agy` and verifies the SHA512 checksum.
- **Removes Gatekeeper quarantine** (`xattr -d com.apple.quarantine`) so that macOS
  doesn't block the binary.

## Option B — Script from this repo (installs + fixes the PATH)

```bash
git clone https://github.com/varelaia/antigravity-installer.git
cd antigravity-installer
chmod +x scripts/install_antigravity.sh
./scripts/install_antigravity.sh
```

The script detects **zsh** and persists `~/.local/bin` in your `~/.zshrc`.

## Configure the PATH (zsh)

If `agy` is "not found" after Option A:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

!!! note "Using bash on macOS?"
    If you switched your shell to bash, use `~/.bash_profile` instead of `~/.zshrc`.

## "Can't be opened because Apple cannot check it…"

The official installer already removes quarantine. If Gatekeeper still blocks it:

```bash
xattr -d com.apple.quarantine ~/.local/bin/agy
```

## Authentication and Keychain

The first time you run `agy`, the CLI accesses the **macOS Keychain** to
store your credentials securely. Approve the access when the system asks for it.

## Verify

```bash
command -v agy        # → /Users/USER/.local/bin/agy
agy --version         # → 1.x.x
```

Something failing? Check **[Troubleshooting](troubleshooting.md)**.
