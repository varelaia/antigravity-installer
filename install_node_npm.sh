#!/bin/bash
# install_node_npm.sh — Instalación limpia de Node.js y npm sin root/sudo
set -euo pipefail

echo "=== 🚀 Iniciando instalación de Node.js y npm via NVM ==="

# 1. Instalar NVM (Node Version Manager)
echo "1. Descargando e instalando NVM..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# 2. Cargar NVM en la sesión actual de bash (evita tener que reiniciar la terminal)
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    \. "$NVM_DIR/nvm.sh"
    echo "NVM cargado exitosamente."
else
    echo "⚠️ Error: No se pudo localizar nvm.sh"
    exit 1
fi

# 3. Instalar la versión estable más reciente de soporte a largo plazo (LTS)
echo "2. Instalando Node.js (versión LTS) y npm compatible..."
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'

# 4. Verificar las versiones instaladas
echo "=== ✅ Instalación Completada ==="
echo "Node.js: $(node --version)"
echo "npm:     $(npm --version)"
echo "Ubicación de Node: $(which node)"
