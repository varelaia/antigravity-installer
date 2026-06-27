---
title: Preguntas frecuentes sobre Antigravity CLI (agy)
description: ¿Por qué Antigravity CLI no se instala con npm? ¿Dónde queda el binario agy? ¿Cómo se actualiza? Respuestas a las dudas comunes de instalación.
---

# Preguntas frecuentes

## ¿Por qué Antigravity CLI no se instala con `npm`?

Porque **`agy` es un binario nativo compilado en Go**, no un paquete de Node.js. Se
distribuye como un ejecutable que se descarga directo desde Google, no desde el registro
de npm. La compilación a Go le da arranque casi instantáneo, menor consumo de memoria y
aislamiento de seguridad a nivel del sistema operativo.

Por eso la forma oficial de instalarlo es el script directo:

```bash
curl -fsSL https://antigravity.google/cli/install.sh | bash
```

## Entonces, ¿para qué sirve `npm` en Antigravity?

Solo para el catálogo **opcional** de [*Antigravity Awesome Skills*](skills.md), que sí se
distribuye por npm y se instala con `npx`. Eso **no** instala el CLI, solo añade skills a
tu configuración existente. El CLI en sí nunca necesita Node.

## ¿Dónde queda instalado el binario?

| Sistema | Ruta |
|---|---|
| Linux / macOS | `~/.local/bin/agy` |
| Windows | `%LOCALAPPDATA%\agy\bin\agy.exe` |

## ¿Cómo actualizo Antigravity CLI?

**No tienes que hacer nada**: el CLI se auto-actualiza en segundo plano durante su uso
normal. Si quieres una instalación fresca, borra el binario y vuelve a correr el
instalador (ver [Manual operativo](manuales/operativo.md)).

## ¿Necesito permisos de administrador (`sudo`)?

No. Todo se instala en tu espacio de usuario (`~/.local/bin` o `%LOCALAPPDATA%`).

## ¿Es seguro hacer `curl … | bash`?

El instalador oficial **verifica el checksum SHA512** del binario antes de instalarlo y
aborta si no coincide ("Security Halt"). Aun así, si prefieres inspeccionar antes de
ejecutar, descarga el script a un archivo, léelo y luego córrelo.

## ¿Dónde guarda `agy` mis credenciales?

En el llavero seguro del sistema operativo: **Keychain** (macOS), **Secret Service /
dbus** (Linux) o **Credential Manager** (Windows).

## ¿Funciona en WSL, Apple Silicon, ARM, Alpine (musl)?

Sí. El instalador detecta sistema, arquitectura (amd64/arm64) y libc (glibc/musl) y baja
el binario correcto. En **WSL** usa el instalador de Linux, no el de Windows.

## ¿Esto es oficial de Google?

No. Este sitio y sus scripts son un **proyecto comunitario** de
[Varela Insights](https://www.varelainsights.com). El instalador *delega* en el oficial de
Google; no lo reemplaza. Antigravity y `agy` son marcas de Google LLC.
