#!/usr/bin/env bash
# install_skills.sh — OPCIONAL. Node.js (vía NVM) + catálogo comunitario de skills.
#
# ⚠ NO es necesario para usar 'agy'. El CLI de Antigravity es un binario Go nativo y
# NO depende de Node.js/npm. Este script solo sirve si quieres instalar "Antigravity
# Awesome Skills" (catálogo comunitario distribuido por npm/npx), que SÍ requiere Node.
#
# Supply-chain: 'antigravity-awesome-skills' es un paquete de la COMUNIDAD, no oficial
# de Google. Por eso aquí instalamos Node y te MOSTRAMOS el comando para que lo corras
# tú de forma consciente (no lo auto-ejecutamos).
set -euo pipefail

echo "=== Node.js + npm (vía NVM) — requisito SOLO para el catálogo de skills ==="

# 1) Instalar NVM (versión pineada).
if [ ! -s "$HOME/.nvm/nvm.sh" ]; then
    echo "⬇ Instalando NVM…"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# 2) Cargar NVM en la sesión actual.
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || { echo "✗ No se pudo cargar nvm.sh" >&2; exit 1; }

# 3) Instalar Node LTS.
echo "⬇ Instalando Node.js LTS…"
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'

echo ""
echo "=== ✅ Node listo ==="
echo "Node.js: $(node --version)   npm: $(npm --version)"
echo ""
echo "Para instalar el catálogo de skills (paquete COMUNITARIO, no oficial), ejecuta:"
echo ""
echo "    npx antigravity-awesome-skills"
echo ""
echo "El instalador es interactivo y te preguntará a qué agente integrarlas."
echo "Los skills viven en  ~/.gemini/config/skills/  (tuyos) y"
echo "                     ~/.gemini/antigravity-cli/builtin/skills/  (de fábrica)."
