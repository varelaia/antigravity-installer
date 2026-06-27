#!/bin/bash
# install_antigravity.sh — Instalación de la CLI de Antigravity (agy)
set -euo pipefail

echo "=== 🚀 Iniciando instalación de Antigravity CLI ==="

# 1. Crear directorio local de binarios en el HOME si no existe
mkdir -p "$HOME/.local/bin"

# 2. Descarga del instalador oficial
echo "Descargando instalador..."
curl -fsSL https://antigravity.google/cli/install.sh | bash

# 3. Exportar ruta al PATH de bash si no está presente
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo "Añadiendo \$HOME/.local/bin al PATH en .bashrc..."
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    export PATH="$HOME/.local/bin:$PATH"
fi

# 4. Verificar instalación
if command -v agy &> /dev/null; then
    echo "=== ✅ Antigravity CLI instalada con éxito ==="
    echo "Ruta:    $(which agy)"
    echo "Versión: $(agy --version)"
else
    echo "❌ Error: 'agy' no se encuentra en el PATH. Por favor ejecuta 'source ~/.bashrc'"
fi
