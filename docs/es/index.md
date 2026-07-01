---
title: Cómo instalar Antigravity CLI (agy) en Linux, macOS y Windows
description: Guía completa para instalar Antigravity CLI, el comando agy de Google, en Linux, macOS y Windows. Scripts, manuales y solución de problemas.
---

# Cómo instalar Antigravity CLI (`agy`)

**Antigravity CLI** es la interfaz de terminal del agente de IA de Google
[Antigravity](https://antigravity.google), invocada con el comando **`agy`**. Lleva el
razonamiento multi-paso, la edición multi-archivo y la orquestación de agentes
directamente a tu terminal, optimizada para flujos por teclado y sesiones SSH remotas.

Esta guía explica cómo instalarlo **de forma simple, rápida y verificable** en
**Linux**, **macOS** y **Windows**, sin permisos de administrador.

!!! tip "En una frase"
    Antigravity CLI es un **binario nativo en Go**. Se instala con un solo comando, **no
    necesita Node.js ni npm**, verifica su propio checksum SHA512 y se auto-actualiza.

## Instalación rápida

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

Después, abre una terminal **nueva** y comprueba:

```bash
agy --version
```

!!! warning "macOS: si dice `agy: command not found`, usa `~/.zshrc` (no `~/.bashrc`)"
    El instalador oficial corre bajo `bash` y sugiere el PATH en `~/.bashrc`, pero macOS usa
    **`zsh`**, que **no lee `~/.bashrc`**. Añádelo a `~/.zshrc` y recarga:

    ```bash
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
    ```

    Más detalle en [Solución de problemas](troubleshooting.md).

## ¿Qué necesito antes de empezar?

| Sistema | Requisito previo |
|---|---|
| **Linux / WSL** | `curl` o `wget` (`sudo apt install -y curl`) |
| **macOS** | **macOS 12.0 (Monterey)+** (verifica con `sw_vers`); nada más — el instalador quita la cuarentena. En macOS 11 o anterior `agy` [crashea](troubleshooting.md). |
| **Windows 10/11** | PowerShell 5.1+ (no requiere admin) |

## Elige tu camino

<div class="grid cards" markdown>

- :material-linux: **[Linux](linux.md)** — instalación, PATH, musl, WSL
- :material-apple: **[macOS](macos.md)** — Intel y Apple Silicon, Keychain, zsh
- :material-microsoft-windows: **[Windows](windows.md)** — PowerShell, CMD, PATH de usuario
- :material-puzzle: **[Skills (opcional)](skills.md)** — el catálogo comunitario vía `npx`
- :material-help-circle: **[Preguntas frecuentes](faq.md)** — ¿por qué no npm?
- :material-wrench: **[Solución de problemas](troubleshooting.md)** — errores comunes

</div>

## ¿Por qué este sitio?

El instalador oficial ya hace bien lo difícil (descarga verificada, detección de
plataforma, auto-actualización). Lo que **no** hace es persistir el binario en tu `PATH`
ni explicarte qué pasó. Aquí encontrarás:

- **Scripts wrapper** que añaden persistencia de PATH idempotente sobre el instalador oficial.
- **Manuales** [técnico](manuales/tecnico.md), [operativo](manuales/operativo.md) y [de usuario](manuales/usuario.md).
- Respuestas a las dudas reales: *¿dónde queda el binario? ¿cómo lo actualizo? ¿cómo lo desinstalo?*

> Proyecto comunitario de [Varela Insights](https://www.varelainsights.com). No afiliado a Google.
