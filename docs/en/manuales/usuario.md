---
title: User manual — install Antigravity CLI step by step
description: Simple, non-technical guide to install Antigravity CLI (agy) on your computer, step by step, on Linux, macOS or Windows.
---

# User manual (step by step)

Simple guide, no jargon. If you just want to get the `agy` command working,
follow these steps.

## What are we going to do?

Install **Antigravity CLI**, a Google tool that puts an AI assistant in your
terminal. When you're done you'll be able to type `agy` and start using it.

## Step 1 — Open your terminal

- **Windows**: Start menu → type **PowerShell** → open it.
- **macOS**: `Cmd + Space` → type **Terminal** → open it.
- **Linux**: `Ctrl + Alt + T`.

## Step 2 — Copy and paste ONE command

=== "Windows"

    ```powershell
    irm https://antigravity.google/cli/install.ps1 | iex
    ```

=== "macOS / Linux"

    ```bash
    curl -fsSL https://antigravity.google/cli/install.sh | bash
    ```

Paste it, press **Enter** and wait for it to finish (a few seconds).

## Step 3 — Open a NEW terminal

Close the terminal and open **another one**. This step is important: it makes the computer
"see" the new command.

!!! tip "Shortcut on Mac/Linux"
    If you don't want to close it, type `source ~/.bashrc` (or `source ~/.zshrc` on Mac) and
    press Enter.

## Step 4 — Check that it works

Type:

```bash
agy --version
```

If you see a version number (like `1.0.12`), **you're done! 🎉** You now have Antigravity CLI.

## Something went wrong?

- **"agy not found / command not found"** → almost always it's Step 3: open a
  **new** terminal. If it persists, go to [Troubleshooting](../troubleshooting.md).
- **On Mac it says it "can't verify the developer"** → go to
  [the macOS guide](../macos.md).

## What if I want the "fully automatic" version?

Use this project's script, which also leaves everything configured:

```bash
git clone https://github.com/varelaia/antigravity-installer.git
cd antigravity-installer
./scripts/install_antigravity.sh     # On Windows: ./scripts/install_antigravity.ps1
```

---

Questions? Each system has its detailed guide: [Linux](../linux.md) ·
[macOS](../macos.md) · [Windows](../windows.md).
