---
title: Instalar Antigravity CLI (agy) en macOS
description: Cómo instalar el comando agy de Google Antigravity en macOS (Intel y Apple Silicon), resolver la cuarentena de Gatekeeper, configurar zsh y el Keychain.
---

# Instalar Antigravity CLI en macOS

Funciona en **Intel (x86_64)** y **Apple Silicon (arm64)**. No requiere permisos de
administrador. El shell por defecto en macOS moderno es **zsh**.

!!! danger "Requisito: macOS 12.0 (Monterey) o superior — verifícalo PRIMERO"
    `agy` es un binario compilado para **macOS 12.0+**. En **macOS 11 (Big Sur) o anterior**
    se instala pero **crashea al conectarse** (`dyld: Symbol not found: _SecTrustCopyCertificateChain`).
    **Antes de instalar nada**, comprueba tu versión:

    ```bash
    sw_vers
    ```

    Si `ProductVersion` es **menor a 12.0** → `agy` no puede correr en ese Mac. Actualiza macOS
    (Ajustes → Actualización de software) o usa un Mac más nuevo / Linux / Windows.

## Opción A — Instalador oficial (1 comando)

```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

El instalador:

- Detecta tu arquitectura (Intel o Apple Silicon) automáticamente.
- Descarga `agy` en `~/.local/bin/agy` y verifica el checksum SHA512.
- **Quita la cuarentena de Gatekeeper** (`xattr -d com.apple.quarantine`) para que macOS
  no bloquee el binario.

## Opción B — Script de este repo (instala + arregla el PATH)

```bash
git clone https://github.com/varelaia/antigravity-installer.git
cd antigravity-installer
chmod +x scripts/install_antigravity.sh
./scripts/install_antigravity.sh
```

El script detecta **zsh** y persiste `~/.local/bin` en tu `~/.zshrc`.

## Configurar el PATH (zsh)

Si `agy` "no se encuentra" tras la Opción A:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

!!! note "¿Usas bash en macOS?"
    Si cambiaste tu shell a bash, usa `~/.bash_profile` en lugar de `~/.zshrc`.

## "No se puede abrir porque Apple no puede comprobar…"

El instalador oficial ya quita la cuarentena. Si aun así Gatekeeper lo bloquea:

```bash
xattr -d com.apple.quarantine ~/.local/bin/agy
```

## Autenticación y Keychain

Al ejecutar `agy` por primera vez, el CLI accede al **Llavero (Keychain) de macOS** para
guardar tus credenciales de forma segura. Aprueba el acceso cuando el sistema lo pida.

## Verificar

```bash
command -v agy        # → /Users/USUARIO/.local/bin/agy
agy --version         # → 1.x.x
```

¿Algo falla? Revisa **[Solución de problemas](troubleshooting.md)**.
