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

## 🛠️ Scripts de este repo (wrappers con persistencia de PATH)

Los scripts envuelven al instalador oficial (heredando su checksum e idempotencia) y
añaden lo único que el oficial no hace: **persistir el PATH** y verificar el resultado.

| Script | Plataforma | Qué hace |
|---|---|---|
| `scripts/install_antigravity.sh` | Linux / macOS | Instala `agy` + persiste `~/.local/bin` en el PATH |
| `scripts/install_antigravity.ps1` | Windows | Instala `agy.exe` + persiste el PATH de usuario |
| `scripts/install_skills.sh` | Linux / macOS | **Opcional**: Node (NVM) para el catálogo de skills |

```bash
# Linux / macOS
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
