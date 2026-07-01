#!/bin/bash
# install_macos_brew.sh — Instalación en macOS usando Homebrew y configuración de CLIs de IA
set -euo pipefail

echo "=== 🚀 Iniciando Instalación en macOS via Homebrew ==="

# 0. PRE-FLIGHT OBLIGATORIO: versión de macOS (agy requiere 12.0 Monterey+)
#    agy es un binario built-for-macOS-12: en macOS 11 o anterior se INSTALA pero
#    CRASHEA al hacer TLS (dyld: Symbol not found: _SecTrustCopyCertificateChain).
#    Se valida ANTES de instalar Homebrew/paquetes para no gastar GB de descargas
#    (rust, llvm, ghc…) en un equipo donde agy no va a poder correr.
MIN_MACOS_MAJOR=12
OS_VER="$(sw_vers -productVersion 2>/dev/null || echo 0)"
OS_MAJOR="${OS_VER%%.*}"
echo "macOS detectado: ${OS_VER}"
if ! printf '%s' "$OS_MAJOR" | grep -qE '^[0-9]+$' || [ "$OS_MAJOR" -lt "$MIN_MACOS_MAJOR" ]; then
    {
        echo ""
        echo "❌ macOS ${OS_VER} NO es compatible con Antigravity CLI (agy)."
        echo "   agy requiere macOS ${MIN_MACOS_MAJOR}.0 (Monterey) o superior."
        echo "   En macOS 11 o anterior, agy se instala pero CRASHEA al conectarse:"
        echo "     dyld: Symbol not found: _SecTrustCopyCertificateChain"
        echo ""
        echo "   Qué hacer:"
        echo "     • Actualiza macOS a 12+ (Ajustes/Preferencias → Actualización de software)."
        echo "     • O usa un Mac más nuevo, o Linux/Windows."
        echo ""
        echo "   Abortado ANTES de instalar Homebrew/paquetes (para no llenar tu disco"
        echo "   con software que no vas a poder usar con agy)."
    } >&2
    exit 1
fi

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

# 2. Instalar suite de desarrollo y productividad (Homebrew)
echo "Instalando herramientas y dependencias recomendadas..."
brew install python@3.12 zoxide fzf git-delta btop tldr bat ripgrep fd eza httpie zsh-autosuggestions zsh-syntax-highlighting git node@20 ffmpeg imagemagick yt-dlp

# 3. Configurar variables de entorno y utilidades en ~/.zshrc
echo "Configurando perfil ~/.zshrc..."

# Obtener ruta de Node
if [ -d "/opt/homebrew/opt/node@20/bin" ]; then
    NODE_PATH="/opt/homebrew/opt/node@20/bin"
    BREW_SHARE="/opt/homebrew/share"
    PYTHON_LIBEXEC="/opt/homebrew/opt/python@3.12/libexec/bin"
else
    NODE_PATH="/usr/local/opt/node@20/bin"
    BREW_SHARE="/usr/local/share"
    PYTHON_LIBEXEC="/usr/local/opt/python@3.12/libexec/bin"
fi

# Asegurarse de que el perfil no duplique las entradas
touch "$HOME/.zshrc"

# Configurar PATH de Node@20
if ! grep -q "node@20/bin" "$HOME/.zshrc"; then
    echo "export PATH=\"$NODE_PATH:\$PATH\"" >> "$HOME/.zshrc"
fi

# Configurar PATH de Python 3.12
if ! grep -q "python@3.12" "$HOME/.zshrc"; then
    echo "export PATH=\"$PYTHON_LIBEXEC:\$PATH\"" >> "$HOME/.zshrc"
fi

# Configurar inicialización de zoxide
if ! grep -q "zoxide init" "$HOME/.zshrc"; then
    echo 'eval "$(zoxide init zsh)"' >> "$HOME/.zshrc"
fi

# Configurar inicialización de fzf
if ! grep -q "fzf --zsh" "$HOME/.zshrc"; then
    echo 'source <(fzf --zsh)' >> "$HOME/.zshrc"
fi

# Configurar plugins de Zsh (Autosuggestions & Syntax Highlighting)
if ! grep -q "zsh-autosuggestions.zsh" "$HOME/.zshrc"; then
    echo "source $BREW_SHARE/zsh-autosuggestions/zsh-autosuggestions.zsh" >> "$HOME/.zshrc"
fi
if ! grep -q "zsh-syntax-highlighting.zsh" "$HOME/.zshrc"; then
    echo "source $BREW_SHARE/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> "$HOME/.zshrc"
fi

# 4. Configurar prefijo global de npm en espacio de usuario
echo "Configurando directorio global de npm..."
mkdir -p "$HOME/.npm-global"
export PATH="$NODE_PATH:$PATH"
"$NODE_PATH/npm" config set prefix "$HOME/.npm-global"

if ! grep -q "npm-global/bin" "$HOME/.zshrc"; then
    echo 'export PATH="$HOME/.npm-global/bin:$PATH"' >> "$HOME/.zshrc"
fi

# 5. Instalar CLIs de IA de forma global en npm
echo "Instalando CLIs de IA de forma global..."
export PATH="$HOME/.npm-global/bin:$PATH"
"$NODE_PATH/npm" install -g @google/gemini-cli
"$NODE_PATH/npm" install -g @anthropic-ai/claude-code
"$NODE_PATH/npm" install -g @qwen-code/qwen-code
"$NODE_PATH/npm" install -g @openai/codex

# 6. Instalar la CLI de Antigravity (agy)
echo "Instalando Antigravity CLI..."
mkdir -p "$HOME/.local/bin"
curl -fsSL https://antigravity.google/cli/install.sh | bash

if ! grep -q ".local/bin" "$HOME/.zshrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

# 7. Redirección y espacio de trabajo
echo "Configurando espacio de trabajo ~/Code..."
mkdir -p "$HOME/Code"
if [ ! -L "$HOME/Desktop/Code" ]; then
    ln -s "$HOME/Code" "$HOME/Desktop/Code" 2>/dev/null || true
fi

if ! grep -q "cd \$HOME/Code" "$HOME/.zshrc" && ! grep -q "cd ~/Code" "$HOME/.zshrc"; then
    echo "" >> "$HOME/.zshrc"
    echo "# Abrir siempre en la carpeta de trabajo" >> "$HOME/.zshrc"
    echo "cd \$HOME/Code" >> "$HOME/.zshrc"
fi

# 8. Ajustes ocultos del sistema macOS (Defaults)
echo "Aplicando optimizaciones de sistema macOS (Defaults)..."
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
killall Finder 2>/dev/null || true

# 9. Instalar dependencias de Python para manipulación de archivos (Office & Multimedia)
echo "Instalando dependencias de Python (pandas, openpyxl, reportlab, pypdf, pillow, pydub, audioop-lts)..."
export PATH="$PYTHON_LIBEXEC:$PATH"
pip3 install --user --break-system-packages pandas openpyxl reportlab pypdf pillow pydub audioop-lts 2>/dev/null || pip install --user --break-system-packages pandas openpyxl reportlab pypdf pillow pydub audioop-lts

echo "=== ✅ Instalación de Entorno macOS Completada ==="
echo "Por favor ejecuta en tu terminal: source ~/.zshrc"
