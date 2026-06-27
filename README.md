# Antigravity (AGY) Installer & Environment Setup

Guía rápida y scripts automatizados para instalar de forma correcta y segura **Node.js**, **npm** y la interfaz de terminal de **Antigravity (agy CLI)** en **Linux**, **macOS** y **Windows** sin requerir permisos de administrador (`sudo`/`admin`).

---

## 📋 Requisitos Previos por Sistema Operativo

*   **Linux / WSL (Windows Subsystem for Linux)**:
    *   Tener `curl`, `git` y `bash` instalados:
        ```bash
        sudo apt update && sudo apt install -y curl git
        ```
*   **macOS**:
    *   Tener instalado Xcode Command Line Tools:
        ```bash
        xcode-select --install
        ```
*   **Windows (Nativo)**:
    *   PowerShell 5.1 o superior y habilitada la directiva de ejecución local temporal.

---

## 🛠️ Instalación en Linux & macOS

Ambos sistemas utilizan gestores de entorno locales en el espacio del usuario para evitar conflictos de permisos globales.

### Paso 1: Instalar Node.js y npm (via NVM)
Para instalar NVM (Node Version Manager) y Node.js en su versión estable de soporte a largo plazo (LTS):
```bash
chmod +x install_node_npm.sh
./install_node_npm.sh
```

### Paso 2: Instalar Antigravity CLI
Una vez que cuentas con Node y npm instalados, corre el instalador de `agy`:
```bash
chmod +x install_antigravity.sh
./install_antigravity.sh
```
*Nota: El script detectará dinámicamente si utilizas `bash` o `zsh` en macOS y cargará el PATH en el archivo de perfil correspondiente (`.bashrc` o `.zshrc`). Si el comando `agy` no responde inmediatamente, reinicia tu terminal o ejecuta `source ~/.bashrc` (o `source ~/.zshrc`).*

---

## 🛠️ Instalación en Windows (Nativo)

En Windows nativo utilizamos **FNM (Fast Node Manager)** para una instalación fluida y con excelente rendimiento sobre PowerShell.

### Paso 1: Ejecutar el Script de PowerShell
Abre tu terminal de **PowerShell** (no requiere ejecutarse como Administrador) y ejecuta:
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
./install_windows.ps1
```

*El script se encargará de instalar FNM via Winget, configurar las variables de entorno de tu perfil de PowerShell, instalar Node.js LTS e inicializar la descarga de Antigravity CLI.*

---

## ⚙️ Inicialización de Personalizaciones (Skills & Rules)
Antigravity detecta automáticamente tus configuraciones y perfiles de agentes en las siguientes ubicaciones de tu usuario:
* **Reglas globales y Skills**: `~/.gemini/config/skills/` y `~/.gemini/config/AGENTS.md`
* **Reglas del Proyecto (Workspace)**: `.agents/skills/` y `.agents/AGENTS.md`

