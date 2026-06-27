#!/usr/bin/env bash
# install_antigravity.sh — Wrapper del instalador OFICIAL de Antigravity CLI (agy)
# para Linux y macOS.
#
# Filosofía: NO reimplementamos la descarga ni la verificación. El instalador oficial
# ya baja un binario Go nativo, verifica el checksum SHA512, detecta arquitectura/musl,
# quita la cuarentena de macOS y es idempotente (se auto-actualiza solo). Reimplementar
# eso solo agrega riesgo. Este wrapper hace lo ÚNICO que el oficial NO hace:
# persistir ~/.local/bin en el PATH de forma idempotente, y verificar el resultado.
set -euo pipefail

OFFICIAL_URL="https://antigravity.google/cli/install.sh"
BIN_DIR="${AGY_BIN_DIR:-$HOME/.local/bin}"
PATH_LINE='export PATH="$HOME/.local/bin:$PATH"'

say() { printf '%s\n' "$*"; }

# 1) Idempotencia: si ya existe, no reinstalar (el CLI se auto-actualiza en background).
if command -v agy >/dev/null 2>&1 || [ -x "$BIN_DIR/agy" ]; then
    say "✓ 'agy' ya está instalado ($(command -v agy 2>/dev/null || echo "$BIN_DIR/agy"))."
    say "  El Antigravity CLI se auto-actualiza en segundo plano; no hace falta reinstalar."
else
    # 2) Requisito mínimo (igual que el oficial): curl o wget.
    if ! command -v curl >/dev/null 2>&1 && ! command -v wget >/dev/null 2>&1; then
        say "✗ Necesitas 'curl' o 'wget' instalado." >&2
        exit 1
    fi
    say "⬇ Ejecutando el instalador oficial de Antigravity CLI…"
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$OFFICIAL_URL" | bash
    else
        wget -qO- "$OFFICIAL_URL" | bash
    fi
fi

# 3) Persistir el PATH de forma idempotente.
#    Gateamos por si la línea YA está en el archivo de perfil — NO por el PATH de la
#    sesión actual. Ese es el bug clásico: un `export` de sesión no persiste a futuras
#    terminales, y gatear por $PATH puede saltarse la persistencia.
case "$(basename "${SHELL:-bash}")" in
    zsh)  PROFILE="$HOME/.zshrc" ;;
    bash) PROFILE="$HOME/.bashrc" ;;
    *)    PROFILE="$HOME/.profile" ;;
esac
touch "$PROFILE"
if ! grep -qsF "$PATH_LINE" "$PROFILE"; then
    printf '\n# Antigravity CLI (agy)\n%s\n' "$PATH_LINE" >> "$PROFILE"
    say "✓ Añadido \$HOME/.local/bin al PATH en $PROFILE"
else
    say "✓ \$HOME/.local/bin ya estaba en $PROFILE"
fi

# 4) Cargar en la sesión actual (solo este subshell) y verificar.
export PATH="$BIN_DIR:$PATH"
if command -v agy >/dev/null 2>&1; then
    say ""
    say "=== ✅ Antigravity CLI lista ==="
    say "Ruta:    $(command -v agy)"
    say "Versión: $(agy --version 2>/dev/null || echo '(ejecuta: agy --version)')"
    say ""
    say "⚠ Abre una terminal NUEVA o ejecuta:  source $PROFILE"
    say "   (el PATH exportado aquí no se propaga al shell que lanzó este script)."
else
    say "✗ 'agy' no quedó en el PATH. Ejecuta:  source $PROFILE" >&2
    exit 1
fi
