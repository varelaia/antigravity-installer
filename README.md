# Antigravity CLI (`agy`) — Instalador y Guía Completa

> **📖 Documentación completa (sitio): https://varelaia.github.io/antigravity-installer/**

Guía paso a paso, scripts y manuales para instalar **Antigravity CLI** — el comando
`agy` de Google — en **Linux**, **macOS** y **Windows**, sin permisos de administrador.

Antigravity CLI es un **binario nativo en Go**: se descarga de forma directa, **no usa
Node.js ni npm**, verifica su propio checksum SHA512 y se auto-actualiza. Node solo hace
falta para el catálogo *opcional* de skills ([ver por qué](https://varelaia.github.io/antigravity-installer/es/faq/)).

---

## ⚡ Instalación rápida (one-liner oficial)

=== "Linux / macOS"

    ```bash
    curl -fsSL https://antigravity.google/cli/install.sh | bash
    ```

=== "Windows (PowerShell)"

    ```powershell
    irm https://antigravity.google/cli/install.ps1 | iex
    ```

Tras instalar, abre una terminal nueva y verifica:

```bash
agy --version
```

> En Linux/macOS quizá necesites añadir `~/.local/bin` al PATH. Nuestros scripts lo hacen
> por ti de forma idempotente.

---

## ⚡ Instalación Directa One-Liners (Sin Clonar el Repo)

Si deseas instalar el entorno sin tener que clonar este repositorio, puedes copiar y ejecutar directamente los siguientes comandos simplificados en tu terminal según tu sistema operativo:

### 1. macOS (Completo: Homebrew + Node 20 + CLIs de IA + Antigravity)
*Instala Homebrew, Node v20, configura `npm-global` sin `sudo`, instala en lote las CLIs de **Gemini, Claude, Qwen, Codex** y configura `agy`:*
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/varelaia/antigravity-installer/main/scripts/install_macos_brew.sh)"
```
*⚠️ **Importante**: Al finalizar la instalación, debes reiniciar tu terminal o ejecutar en la misma consola:* `source ~/.zshrc`

### 2. Linux / WSL (Completo: NVM + Node LTS + Antigravity)
*Instala NVM, la versión LTS estable de Node.js y npm, y configura la CLI de Antigravity:*
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/varelaia/antigravity-installer/main/scripts/install_skills.sh)"
```
*⚠️ **Importante**: Al finalizar la instalación, debes reiniciar tu terminal o ejecutar en la misma consola:* `source ~/.bashrc`

### 3. Linux / WSL (Básico: Solo Antigravity CLI)
*Instala el binario nativo de la CLI de Antigravity y configura persistentemente el PATH:*
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/varelaia/antigravity-installer/main/scripts/install_antigravity.sh)"
```
*⚠️ **Importante**: Al finalizar la instalación, debes reiniciar tu terminal o ejecutar en la misma consola:* `source ~/.bashrc`

### 4. Windows Nativo (PowerShell sin privilegios de Administrador)
*Descarga e inicializa el instalador de PowerShell que configura FNM, Node.js y Antigravity:*
```
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force; irm https://raw.githubusercontent.com/varelaia/antigravity-installer/main/scripts/install_antigravity.ps1 | iex
```
*⚠️ **Importante**: Asegúrate de ejecutar este comando en una consola de **PowerShell** (no CMD). Al finalizar, cierra y vuelve a abrir tu terminal de PowerShell.*

---

## 🔍 Solución Rápida de Problemas (Troubleshooting Headless / SSH)

Si estás instalando en un servidor remoto o VPS (como Mandalore) vía SSH, puedes experimentar los siguientes incidentes:

### El comando `agy` se queda congelado en `Signing in...`
La CLI de Antigravity intenta abrir un navegador gráfico local para iniciar sesión. Si tu sesión de SSH tiene reenvío de pantalla (`DISPLAY` activo), se congelará intentando comunicarse con un servidor gráfico que no responde.
*   **Solución**: Desactiva la variable de entorno gráfico en tu consola para forzar el flujo headless de terminal:
    ```bash
    unset DISPLAY && agy
    ```
    *Copia la URL de verificación mostrada, ábrela en el navegador de tu computadora local y pega de vuelta el código de confirmación en la consola.*

### La sesión me vuelve a pedir Login cada vez que abro otra terminal
En servidores headless de Linux, no hay un llavero de seguridad activo (`keyring` / `dbus`) en sesiones SSH SSH-non-interactive.
*   **Solución**: Utiliza una API Key de Google Gemini agregándola al final de tu archivo de configuración de shell (`~/.bashrc`):
    ```bash
    export ANTIGRAVITY_API_KEY="tu_api_key_de_gemini"
    ```

---

## 🛠️ Scripts de este repo (wrappers con persistencia de PATH)

Los scripts envuelven al instalador oficial (heredando su checksum e idempotencia) y añaden lo único que el oficial no hace: **persistir el PATH**, instalar dependencias y verificar el resultado.

| Script | Plataforma | Qué hace |
|---|---|---|
| `scripts/install_antigravity.sh` | Linux / macOS | Instala `agy` + persiste `~/.local/bin` en el PATH |
| `scripts/install_antigravity.ps1` | Windows | Instala `agy.exe` + persiste el PATH de usuario |
| `scripts/install_macos_brew.sh` | macOS | **Completo**: Instala Homebrew + Node@20 + CLIs de IA (Gemini, Claude, Qwen, Codex) + `agy` |
| `scripts/install_skills.sh` | Linux / macOS | **Opcional**: Instala Node (NVM) para el catálogo de skills en Linux |

```bash
# macOS (Instalación Completa con Homebrew y CLIs de IA)
chmod +x scripts/install_macos_brew.sh
./scripts/install_macos_brew.sh
```

```bash
# Linux / macOS (Instalación básica de solo agy)
chmod +x scripts/install_antigravity.sh
./scripts/install_antigravity.sh
```

```powershell
# Windows (PowerShell, sin admin)
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
./scripts/install_antigravity.ps1
```

---

## 📚 Contenido del sitio

- **Instalación** detallada por SO ([Linux](https://varelaia.github.io/antigravity-installer/es/linux/) · [macOS](https://varelaia.github.io/antigravity-installer/es/macos/) · [Windows](https://varelaia.github.io/antigravity-installer/es/windows/))
- **[Skills (opcional)](https://varelaia.github.io/antigravity-installer/es/skills/)** — el catálogo comunitario vía `npx`
- **[Preguntas frecuentes](https://varelaia.github.io/antigravity-installer/es/faq/)** — ¿por qué no npm?, ¿dónde queda el binario?, auth
- **[Solución de problemas](https://varelaia.github.io/antigravity-installer/es/troubleshooting/)** — `command not found`, PATH, permisos, musl, checksum
- **Manuales**: [Técnico](https://varelaia.github.io/antigravity-installer/es/manuales/tecnico/) · [Operativo](https://varelaia.github.io/antigravity-installer/es/manuales/operativo/) · [Usuario](https://varelaia.github.io/antigravity-installer/es/manuales/usuario/)

Disponible en **español** e **inglés** (selector de idioma en el sitio).

---

## 🧰 Desarrollo del sitio (local)

```bash
pip install -r requirements.txt
mkdocs serve            # http://127.0.0.1:8000
mkdocs build --strict   # valida que todo compila
```

El sitio se publica solo a GitHub Pages en cada push a `main`
(`.github/workflows/deploy.yml`).

---

## Licencia

[MIT](LICENSE) © 2026 Irving Varela / Varela Insights.
Antigravity, `agy` y Gemini son marcas de Google LLC; este es un proyecto comunitario,
**no afiliado a Google**.
