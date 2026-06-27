#!/bin/bash
# install_macos_brew.sh — Instalación en macOS usando Homebrew y configuración de CLIs de IA
set -euo pipefail

echo "=== 🚀 Iniciando Instalación en macOS via Homebrew ==="

# 1. Instalar Homebrew si no está instalado en el sistema
if ! command -v brew &> /dev/null; then
    echo "Homebrew no encontrado. Instalando..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Configurar Homebrew en la sesión y perfil según la arquitectura (Apple Silicon /opt/homebrew vs Intel /usr/local)
    if [ -d "/opt/homebrew/bin" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
    else
        eval "$(/usr/local/bin/brew shellenv)"
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> "$HOME/.zshrc"
    fi
else
    echo "Homebrew ya está instalado."
fi

# 2. Instalar Node.js v20 via Homebrew
echo "Instalando Node.js v20..."
brew install node@20

# 3. Configurar variables de entorno de Node en ~/.zshrc
echo "Configurando PATH para Node@20..."
if [ -d "/opt/homebrew/opt/node@20/bin" ]; then
    NODE_PATH="/opt/homebrew/opt/node@20/bin"
else
    NODE_PATH="/usr/local/opt/node@20/bin"
fi

if [[ ":$PATH:" != *":$NODE_PATH:"* ]]; then
    echo "Añadiendo ruta al PATH en ~/.zshrc..."
    echo "export PATH=\"$NODE_PATH:\$PATH\"" >> "$HOME/.zshrc"
    export PATH="$NODE_PATH:$PATH"
fi

# 4. Configurar prefijo global de npm para evitar el uso de 'sudo' (Mejor Práctica de Seguridad)
# Evita que el comando 'npm install -g' requiera 'sudo' para modificar directorios de sistema
echo "Configurando directorio global de npm en espacio de usuario..."
mkdir -p "$HOME/.npm-global"
export PATH="$NODE_PATH:$PATH" # Cargar Node para poder ejecutar npm
"$NODE_PATH/npm" config set prefix "$HOME/.npm-global"

if [[ ":$PATH:" != *":$HOME/.npm-global/bin:"* ]]; then
    echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> "$HOME/.zshrc"
    export PATH="$HOME/.npm-global/bin:$PATH"
fi

# 5. Instalar CLIs de IA populares (Gemini, Claude, Qwen, Codex)
echo "Instalando CLIs de Inteligencia Artificial de forma global..."
export PATH="$HOME/.npm-global/bin:$PATH"
"$NODE_PATH/npm" install -g @google/gemini-cli
"$NODE_PATH/npm" install -g @anthropic-ai/claude-code
"$NODE_PATH/npm" install -g @qwen-code/qwen-code
"$NODE_PATH/npm" install -g @openai/codex

# 6. Descargar e instalar la CLI de Antigravity (agy)
echo "Instalando Antigravity CLI..."
mkdir -p "$HOME/.local/bin"
curl -fsSL https://antigravity.google/cli/install.sh | bash

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

echo "=== ✅ Instalación de Entorno macOS Completada ==="
echo "Por favor ejecuta en tu terminal: source ~/.zshrc"
