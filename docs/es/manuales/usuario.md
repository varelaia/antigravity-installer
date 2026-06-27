---
title: Manual de usuario — instalar Antigravity CLI paso a paso
description: Guía sencilla y sin tecnicismos para instalar Antigravity CLI (agy) en tu computadora, paso a paso, en Linux, macOS o Windows.
---

# Manual de usuario (paso a paso)

Guía sencilla, sin tecnicismos. Si solo quieres dejar funcionando el comando `agy`,
sigue estos pasos.

## ¿Qué vamos a hacer?

Instalar **Antigravity CLI**, una herramienta de Google que pone un asistente de IA en tu
terminal. Al terminar podrás escribir `agy` y empezar a usarlo.

## Paso 1 — Abre tu terminal

- **Windows**: menú Inicio → escribe **PowerShell** → ábrelo.
- **macOS**: `Cmd + Espacio` → escribe **Terminal** → ábrela.
- **Linux**: `Ctrl + Alt + T`.

## Paso 2 — Copia y pega UN comando

=== "Windows"

    ```powershell
    irm https://antigravity.google/cli/install.ps1 | iex
    ```

=== "macOS / Linux"

    ```bash
    curl -fsSL https://antigravity.google/cli/install.sh | bash
    ```

Pégalo, presiona **Enter** y espera a que termine (unos segundos).

## Paso 3 — Abre una terminal NUEVA

Cierra la terminal y abre **otra**. Este paso es importante: hace que la computadora
"vea" el nuevo comando.

!!! tip "Atajo en Mac/Linux"
    Si no quieres cerrarla, escribe `source ~/.bashrc` (o `source ~/.zshrc` en Mac) y
    presiona Enter.

## Paso 4 — Comprueba que funciona

Escribe:

```bash
agy --version
```

Si ves un número de versión (como `1.0.12`), **¡listo! 🎉** Ya tienes Antigravity CLI.

## ¿Algo salió mal?

- **"agy no se encuentra / command not found"** → casi siempre es el Paso 3: abre una
  terminal **nueva**. Si sigue, ve a [Solución de problemas](../troubleshooting.md).
- **En Mac dice que "no puede comprobar el desarrollador"** → ve a
  [la guía de macOS](../macos.md).

## ¿Y si quiero la versión "todo automático"?

Usa el script de este proyecto, que además deja todo configurado:

```bash
git clone https://github.com/varelaia/antigravity-installer.git
cd antigravity-installer
./scripts/install_antigravity.sh     # En Windows: ./scripts/install_antigravity.ps1
```

---

¿Dudas? Cada sistema tiene su guía detallada: [Linux](../linux.md) ·
[macOS](../macos.md) · [Windows](../windows.md).
