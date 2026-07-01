---
title: Antigravity CLI (agy) troubleshooting
description: Common errors when installing Antigravity CLI and how to resolve them: agy command not found, PATH, permissions, checksum, macOS quarantine, musl.
---

# Troubleshooting

## `agy: command not found` / `agy not recognized`

The binary was installed but it's not on your `PATH`, or the terminal hasn't reloaded the
profile yet.

=== "Linux / macOS"

    ```bash
    # 1) Confirm the binary exists:
    ls -l ~/.local/bin/agy
    # 2) Add to PATH and reload:
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc   # or ~/.zshrc
    source ~/.bashrc                                            # or ~/.zshrc
    ```

=== "Windows"

    Open a **new** terminal (the PATH doesn't update in the current session). If it's still
    not recognized, check that `%LOCALAPPDATA%\agy\bin` is on the user PATH
    ([see Windows](windows.md)).

!!! info "Why it happens"
    A script cannot change the `PATH` of the terminal that invoked it. You always need
    a **new terminal** or `source` after installing.

!!! warning "macOS: the official installer says `~/.bashrc`, but macOS uses `zsh`"
    Google's official installer (`curl … | bash`) runs under `bash` and suggests adding the
    PATH to `~/.bashrc`. But since macOS Catalina the default shell is **`zsh`**, which **does
    not read `~/.bashrc`** → the binary is installed at `~/.local/bin/agy` but no new terminal
    finds it. The fix is to use **`~/.zshrc`**:

    ```bash
    # 1) Check your shell (on macOS it's usually /bin/zsh):
    echo $SHELL
    # 2) Confirm the binary runs via its absolute path:
    ~/.local/bin/agy --version
    # 3) Add the PATH to the correct zsh file and reload:
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
    source ~/.zshrc
    ```

    You don't need to delete the line left in `~/.bashrc`; it's harmless. Our wrapper
    `scripts/install_antigravity.sh` already detects the shell and writes to the correct file.

## `agy --version` prints nothing

Almost always the same PATH problem: you're invoking an `agy` that doesn't exist in this
session. Try with the absolute path:

```bash
~/.local/bin/agy --version
```

If it does print with the absolute path, it's PATH (see above).

## `Write Error: Permission denied`

The installer couldn't write to `~/.local/bin`. Install in another directory:

```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir "$HOME/bin"
```

Remember to add that directory to your `PATH`.

## `Security Halt: checksum does not match`

The installer detected that the downloaded file doesn't match the expected SHA512
checksum. **Don't ignore it.** Retry (it may have been a corrupt download); if it persists,
check your network/proxy/firewall or a possible server-side problem.

## macOS: "Apple cannot check it for malicious software"

Remove Gatekeeper quarantine:

```bash
xattr -d com.apple.quarantine ~/.local/bin/agy
```

## `Either curl or wget is required`

Install one of the two:

```bash
sudo apt install -y curl     # Debian/Ubuntu
sudo dnf install -y curl     # Fedora
```

## "Already installed" but I want to reinstall

The installer is idempotent. To force a clean install, delete the binary first:

```bash
rm ~/.local/bin/agy                       # Linux/macOS
Remove-Item "$env:LOCALAPPDATA\agy\bin\agy.exe" -Force   # Windows (PowerShell)
```

## Linux musl / Alpine: the binary won't run

The official installer detects musl automatically. If you downloaded it by hand, make sure
to use the `linux_<arch>_musl` variant. More detail in the [Technical manual](manuales/tecnico.md).

## macOS: `agy --version` works but `agy` "does nothing" (crash on macOS &lt; 12)

Typical symptom: `agy --version` prints the version, but `agy` (or `agy -p "hi"`) **returns
to the prompt showing nothing** — no output, no visible error. The real error is in the log:

```bash
tail -40 ~/.gemini/antigravity-cli/cli.log
```

If you see something like:

```
dyld: Symbol not found: _SecTrustCopyCertificateChain
  Referenced from: /Users/<your-user>/.local/bin/agy (which was built for Mac OS X 12.0)
```

…it's a **macOS version incompatibility**, not a PATH, permissions, or library problem:

- `agy` is built for **macOS 12.0 (Monterey)**. The `_SecTrustCopyCertificateChain` symbol is
  an API Apple introduced in macOS 12.0.
- On **macOS 11 (Big Sur) or earlier** that symbol doesn't exist → as soon as `agy` makes an
  **HTTPS** connection (verifying the TLS certificate) it **crashes** (SIGABRT). That's why
  `--version` (no network) works, but any real action dies.

**Always check your version first:**

```bash
sw_vers
```

**Fix:** it's an OS incompatibility — **no installable library fixes it**. Update macOS to
**12.0+** (System Settings → Software Update) or use a newer Mac (or Linux / Windows).

## macOS: allow screen recording for remote assistance (Google Meet)

If you're going to receive remote support over **Google Meet** and need to **share your
screen**, macOS requires you to explicitly authorize your browser to record the screen.

!!! note "For macOS Ventura and later (macOS 13+)"
    1. Click the **Apple** menu (the apple icon in the top-left corner).
    2. Select **System Settings**.
    3. In the left sidebar, click **Privacy & Security**.
    4. Scroll down in the right pane and select **Screen Recording**.
    5. Find the browser you use for Google Meet in the list (for example, **Google Chrome**).
    6. Turn on the switch next to that browser.
    7. The system may ask you to enter your Mac password or use **Touch ID** to confirm the change.
    8. A message will appear saying the browser can't record the screen until it's restarted. Click **Quit & Reopen**.

---

Your case isn't here? Open an *issue* on
[GitHub](https://github.com/varelaia/antigravity-installer/issues).
