---
title: Instalar Antigravity CLI (agy) en Linux
description: Cómo instalar el comando agy de Google Antigravity en Linux (Ubuntu, Debian, Fedora, Arch, WSL), configurar el PATH y verificar la instalación.
---

# Instalar Antigravity CLI en Linux

Funciona en cualquier distribución de 64 bits (Ubuntu, Debian, Fedora, Arch…), en
**WSL** y con **glibc o musl** (Alpine). No requiere `sudo`.

## Opción A — Instalador oficial (1 comando)

```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

El instalador descarga el binario en `~/.local/bin/agy`, verifica el checksum SHA512 y
configura el CLI. Si `~/.local/bin` no está en tu `PATH`, tendrás que añadirlo (ver abajo).

## Opción B — Script de este repo (instala + arregla el PATH)

Recomendado si quieres que el `PATH` quede persistente automáticamente:

```bash
git clone https://github.com/varelaia/antigravity-installer.git
cd antigravity-installer
chmod +x scripts/install_antigravity.sh
./scripts/install_antigravity.sh
```

Este script envuelve al instalador oficial (hereda su verificación) y **persiste
`~/.local/bin` en tu `~/.bashrc`** de forma idempotente.

## Configurar el PATH manualmente

Si instalaste con la Opción A y `agy` "no se encuentra", añade el directorio al PATH:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

!!! warning "Por qué `source` es necesario"
    Un script hijo no puede modificar el `PATH` de la terminal que lo lanzó. Tras
    instalar, abre una terminal **nueva** o ejecuta `source ~/.bashrc` para usar `agy`
    en la sesión actual.

## Verificar

```bash
command -v agy        # → /home/USUARIO/.local/bin/agy
agy --version         # → 1.x.x
```

## Notas específicas de Linux

- **WSL**: trátalo como Linux nativo; usa el instalador `.sh`, no el de Windows.
- **musl / Alpine**: el instalador oficial detecta musl y baja el binario correcto.
- **Directorio personalizado**: `curl -fsSL …/install.sh | bash -s -- --dir /ruta/elegida`.

¿Algo falla? Revisa **[Solución de problemas](troubleshooting.md)**.
