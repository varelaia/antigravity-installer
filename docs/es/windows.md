---
title: Instalar Antigravity CLI (agy) en Windows
description: Cómo instalar el comando agy de Google Antigravity en Windows 10/11 con PowerShell o CMD, sin permisos de administrador, y configurar el PATH de usuario.
---

# Instalar Antigravity CLI en Windows

Funciona en **Windows 10 y 11 de 64 bits**. **No requiere permisos de administrador**.
El binario se instala como `agy.exe` en `%LOCALAPPDATA%\agy\bin`.

## Opción A — Instalador oficial (1 comando)

=== "PowerShell"

    ```powershell
    irm https://antigravity.google/cli/install.ps1 | iex
    ```

=== "CMD (símbolo del sistema)"

    ```bat
    curl -fsSL https://antigravity.google/cli/install.cmd -o install.cmd && install.cmd && del install.cmd
    ```

El instalador descarga `agy.exe`, verifica su checksum SHA512 y lo coloca en
`C:\Users\<TuUsuario>\AppData\Local\agy\bin`.

## Opción B — Script de este repo (instala + arregla el PATH)

```powershell
git clone https://github.com/varelaia/antigravity-installer.git
cd antigravity-installer
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
./scripts/install_antigravity.ps1
```

Este script envuelve al instalador oficial y **añade `%LOCALAPPDATA%\agy\bin` al PATH de
usuario** de forma idempotente, para que `agy` funcione en cualquier terminal nueva.

!!! tip "Antigravity CLI NO necesita Node.js ni FNM en Windows"
    Versiones antiguas de guías sugerían instalar FNM/Node con `winget`. **No hace falta**:
    `agy` es un binario nativo. Node solo sirve para el catálogo opcional de
    [skills](skills.md).

## Configurar el PATH manualmente

Si `agy` no se reconoce tras la Opción A, añade el directorio al PATH de usuario:

```powershell
$bin = "$env:LOCALAPPDATA\agy\bin"
$cur = [Environment]::GetEnvironmentVariable("Path","User")
if ($cur -notlike "*$bin*") { [Environment]::SetEnvironmentVariable("Path","$cur;$bin","User") }
```

Cierra y **abre una terminal nueva** para que el cambio surta efecto.

## Verificar

```powershell
Get-Command agy        # muestra la ruta de agy.exe
agy --version          # → 1.x.x
```

## Autenticación

`agy` usa el **Administrador de credenciales de Windows** (Windows Credential Manager)
para guardar tus tokens de forma segura.

¿Algo falla? Revisa **[Solución de problemas](troubleshooting.md)**.
