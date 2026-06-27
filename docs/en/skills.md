---
title: Install skills in Antigravity CLI (optional catalog)
description: How to add skills to the Antigravity CLI agent with the community Antigravity Awesome Skills catalog via npx. Requires Node.js (optional).
---

# Skills for Antigravity CLI (optional)

**Skills** are structured instructions that teach your agent how to perform
specific tasks (web development, testing, DevOps, audits). Antigravity ships with built-in
skills, and you can extend them with a community catalog.

!!! warning "This is 100% optional and NOT required to use `agy`"
    The CLI works without installing any of this. Community skills are distributed via
    **npm**, so this is the only part where you need **Node.js**.

## Step 1 — Install Node.js (if you don't have it)

=== "Linux / macOS (repo script)"

    ```bash
    chmod +x scripts/install_skills.sh
    ./scripts/install_skills.sh
    ```

    Installs Node LTS via NVM in your user space (no `sudo`).

=== "Manual (any OS)"

    Install Node.js LTS from [nodejs.org](https://nodejs.org) or with your favorite
    manager (`nvm`, `fnm`, `volta`…).

## Step 2 — Install the skills catalog

```bash
npx antigravity-awesome-skills
```

The installer is **interactive**: it will ask which agent to integrate the skills into.

!!! danger "Security note (supply-chain)"
    `antigravity-awesome-skills` is a **community** package, not official from Google.
    Running `npx <package>` runs third-party code on your machine. Review the package
    on [npmjs.com](https://www.npmjs.com/package/antigravity-awesome-skills) and consider
    pinning a version (`npx antigravity-awesome-skills@<version>`) in serious environments.

## Where do the skills live?

| Path | Contents |
|---|---|
| `~/.gemini/config/skills/` | Your skills (the ones you install) |
| `~/.gemini/antigravity-cli/builtin/skills/` | Built-in skills |
| `~/.gemini/config/AGENTS.md` | Global agent rules |
| `.agents/skills/` and `.agents/AGENTS.md` | Per-project (workspace) rules and skills |

Antigravity detects these locations automatically at startup.
