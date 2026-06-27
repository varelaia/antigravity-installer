# Antigravity (AGY) Installer & Environment Setup

Guía rápida y scripts automatizados para instalar de forma correcta y segura **Node.js**, **npm** y la interfaz de terminal de **Antigravity (agy CLI)** en entornos Linux/WSL sin requerir permisos de administrador (`sudo`).

## 📋 Requisitos Previos
* Un entorno Linux compatible (Ubuntu/Debian) o Windows Subsystem for Linux (WSL).
* `curl` y `git` instalados en el sistema:
  ```bash
  sudo apt update && sudo apt install -y curl git
  ```

## 🛠️ Instalación Rápida

### Paso 1: Instalar Node.js y npm (via NVM)
Para evitar conflictos de permisos al instalar paquetes de npm globales, utilizamos NVM (Node Version Manager) para aislar la instalación al espacio del usuario local.
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
*Nota: Si el comando `agy` no responde inmediatamente después del script, reinicia tu terminal o ejecuta `source ~/.bashrc`.*

## ⚙️ Inicialización de Personalizaciones (Skills & Rules)
Antigravity detecta automáticamente tus configuraciones y perfiles de agentes en las siguientes ubicaciones de tu usuario:
* **Reglas globales y Skills**: `~/.gemini/config/skills/` y `~/.gemini/config/AGENTS.md`
* **Reglas del Proyecto (Workspace)**: `.agents/skills/` y `.agents/AGENTS.md`
