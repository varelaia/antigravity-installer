---
title: Manual técnico — Antigravity CLI (agy)
description: Cómo funciona internamente el instalador de Antigravity CLI: arquitectura del binario Go, manifiesto, verificación SHA512, detección de plataforma y PATH.
---

# Manual técnico

Detalle de cómo funciona la instalación por dentro. Para uso normal no necesitas esto;
sirve para depurar, automatizar o auditar.

## Arquitectura

`agy` es un **ejecutable nativo compilado en Go**, distribuido como binario "flat" (no es
un paquete npm ni un script). Ventajas de diseño:

- **Arranque casi instantáneo** de la TUI.
- **Bajo consumo de memoria** con múltiples agentes en segundo plano.
- **Aislamiento de seguridad** a nivel de sistema operativo para ejecutar comandos
  autogenerados por la IA (p. ej. `sandbox-exec` en macOS).

## Flujo del instalador oficial

El instalador (`install.sh` / `install.ps1` / `install.cmd`) hace, en orden:

1. **Pre-chequeo de existencia** — si `agy` ya existe, avisa y sale (idempotente).
2. **Detección de plataforma** — `uname -s` (OS), `uname -m` (arch: `amd64`/`arm64`) y
   detección de **musl** en Linux (`/lib/libc.musl-*` o `ldd`). Construye un identificador
   tipo `linux_amd64`, `linux_arm64_musl`, `darwin_arm64`, etc.
3. **Consulta de manifiesto** — descarga `…/manifests/<platform>.json`, que contiene
   `version`, `url` y `sha512` del binario para esa plataforma.
4. **Descarga + verificación** — baja el payload a un directorio de *staging* y compara su
   **SHA512** contra el manifiesto. Si no coincide → **"Security Halt"** y aborta.
5. **Instalación** — extrae/copia el binario a `~/.local/bin/agy` (o
   `%LOCALAPPDATA%\agy\bin\agy.exe`), aplica `chmod +x` y en macOS quita la cuarentena
   (`xattr -d com.apple.quarantine`).
6. **Setup final** — invoca `agy install` para que el propio binario complete su
   configuración.

## Directorios y rutas

| Elemento | Linux / macOS | Windows |
|---|---|---|
| Binario | `~/.local/bin/agy` | `%LOCALAPPDATA%\agy\bin\agy.exe` |
| Staging | bajo `$TMPDIR` / `%LOCALAPPDATA%\antigravity\staging` | idem |
| Config / skills | `~/.gemini/` | `%USERPROFILE%\.gemini\` |
| Credenciales | Keychain / Secret Service | Credential Manager |

## Lo que el oficial NO hace: el PATH

El instalador oficial **no modifica tu `PATH`**. Por eso los wrappers de este repo añaden
esa única pieza. El patrón correcto y por qué importa:

```bash
# Gateamos por si la LÍNEA ya está en el perfil, NO por el $PATH de la sesión.
if ! grep -qsF 'export PATH="$HOME/.local/bin:$PATH"' "$PROFILE"; then
    printf '\n%s\n' 'export PATH="$HOME/.local/bin:$PATH"' >> "$PROFILE"
fi
export PATH="$HOME/.local/bin:$PATH"   # solo afecta a ESTE subshell
```

!!! danger "El bug clásico de PATH"
    Gatear la persistencia con `if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]` decide si
    escribir en `.bashrc` según el PATH de la **sesión actual**. Si el directorio ya está
    en el PATH de esta sesión (pero no en `.bashrc`), se **salta la persistencia** y el
    `agy` desaparece en la siguiente terminal. La pregunta correcta no es "¿está en mi
    PATH ahora?" sino "¿quedará en mis terminales futuras?" → gatear con `grep` sobre el
    archivo de perfil.

!!! note "El `export` no se propaga al padre"
    Un proceso hijo no puede cambiar el entorno del proceso que lo lanzó. Por eso, tras
    correr el instalador, hace falta una terminal nueva o `source ~/.bashrc`.

## Instalación en directorio personalizado

```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir /opt/agy/bin
```

## Verificación del binario

```bash
file ~/.local/bin/agy          # ELF/Mach-O nativo
~/.local/bin/agy --version     # versión instalada
```
