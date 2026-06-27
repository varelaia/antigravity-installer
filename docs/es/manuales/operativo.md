---
title: Manual operativo — Antigravity CLI (agy)
description: Operar Antigravity CLI: actualizar, reinstalar, desinstalar, instalar en flota/CI, contenedores Docker y directorio personalizado.
---

# Manual operativo

Tareas de operación del día a día: actualizar, desinstalar, automatizar e instalar a
escala.

## Actualizar

No requiere acción: **el CLI se auto-actualiza en segundo plano** durante su uso normal.
Para forzar la última versión con instalación limpia:

```bash
rm ~/.local/bin/agy
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

## Reinstalar / instalación fresca

El instalador es idempotente y no sobrescribe si ya existe. Borra el binario primero:

=== "Linux / macOS"

    ```bash
    rm ~/.local/bin/agy
    ./scripts/install_antigravity.sh
    ```

=== "Windows"

    ```powershell
    Remove-Item "$env:LOCALAPPDATA\agy\bin\agy.exe" -Force
    ./scripts/install_antigravity.ps1
    ```

## Desinstalar

```bash
# Linux / macOS
rm ~/.local/bin/agy
# (opcional) quita la línea del PATH de ~/.bashrc o ~/.zshrc
# (opcional) elimina la config: rm -rf ~/.gemini
```

```powershell
# Windows
Remove-Item "$env:LOCALAPPDATA\agy\bin\agy.exe" -Force
# (opcional) quita la entrada de PATH de usuario y la carpeta %USERPROFILE%\.gemini
```

## Instalación desatendida (CI / flota)

El instalador no es interactivo, así que sirve tal cual en pipelines:

```bash
# Instala en un directorio explícito y añádelo al PATH del job
curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"
agy --version
```

!!! tip "Idempotencia en CI"
    Como sale temprano si ya existe, puedes llamarlo en cada build sin penalización.

## Docker / contenedores

Para imágenes propias, instala en una capa y fija el PATH:

```dockerfile
RUN curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir /usr/local/bin
# /usr/local/bin ya suele estar en el PATH del contenedor
RUN agy --version
```

## Directorio personalizado

```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir /ruta/elegida
```

## Comprobaciones de salud

```bash
command -v agy && agy --version    # instalado y en PATH
echo "$PATH" | tr ':' '\n' | grep -q "$HOME/.local/bin" && echo "PATH OK"
```
