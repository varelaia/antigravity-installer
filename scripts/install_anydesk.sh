#!/usr/bin/env bash
# install_anydesk.sh — Instala AnyDesk para asistencia remota en macOS y ABRE los
# paneles de permisos que macOS exige activar A MANO.
#
# IMPORTANTE (por diseño de macOS): los permisos de "Grabación de pantalla" y
# "Accesibilidad" (TCC) NO se pueden otorgar por script sin MDM corporativo ni
# desactivar SIP — es la protección que evita que un malware se auto-conceda
# control de tu pantalla y teclado. Lo máximo automatizable es: instalar AnyDesk,
# lanzarlo (dispara sus prompts) y ABRIR el panel exacto para que el usuario dé
# 1 clic por permiso. Este script hace justo eso.
set -euo pipefail

# 0) Solo macOS
if [ "$(uname -s)" != "Darwin" ]; then
    echo "✗ Este script es solo para macOS." >&2
    exit 1
fi

OS_VER="$(sw_vers -productVersion 2>/dev/null || echo 0)"
OS_MAJOR="${OS_VER%%.*}"
[ -z "$OS_MAJOR" ] && OS_MAJOR=0
echo "=== 🖥️  Instalador de AnyDesk (asistencia remota) — macOS ${OS_VER} ==="

# Ventura (13+) renombró "Preferencias del Sistema" a "Configuración del Sistema".
if [ "$OS_MAJOR" -ge 13 ] 2>/dev/null; then
    SETTINGS_APP="Configuración del Sistema"
else
    SETTINGS_APP="Preferencias del Sistema"
fi

# 1) Instalar AnyDesk: Homebrew cask si hay brew; si no, .dmg oficial directo.
if [ -d "/Applications/AnyDesk.app" ]; then
    echo "✓ AnyDesk ya está instalado en /Applications/AnyDesk.app."
elif command -v brew >/dev/null 2>&1; then
    echo "⬇ Homebrew detectado — instalando AnyDesk vía cask…"
    brew install --cask anydesk
else
    echo "⬇ Homebrew no encontrado — descargando el .dmg oficial de AnyDesk…"
    TMP="$(mktemp -d)"
    DMG="$TMP/anydesk.dmg"
    MNT="$TMP/mnt"
    mkdir -p "$MNT"
    curl -fSL "https://download.anydesk.com/anydesk.dmg" -o "$DMG"
    hdiutil attach "$DMG" -nobrowse -quiet -mountpoint "$MNT"
    APP="$(find "$MNT" -maxdepth 2 -name 'AnyDesk.app' -print -quit)"
    if [ -z "$APP" ]; then
        echo "✗ No encontré AnyDesk.app dentro del .dmg." >&2
        hdiutil detach "$MNT" -quiet 2>/dev/null || true
        exit 1
    fi
    echo "→ Copiando AnyDesk.app a /Applications (puede pedir tu contraseña)…"
    if ! cp -R "$APP" /Applications/ 2>/dev/null; then
        sudo cp -R "$APP" /Applications/
    fi
    hdiutil detach "$MNT" -quiet 2>/dev/null || true
    # Quitar cuarentena de Gatekeeper para que no bloquee el binario descargado.
    sudo xattr -dr com.apple.quarantine /Applications/AnyDesk.app 2>/dev/null || true
    echo "✓ AnyDesk instalado en /Applications/AnyDesk.app."
fi

# 2) Lanzar AnyDesk: dispara sus propios prompts de permisos y lo hace aparecer en
#    las listas de Privacidad para poder palomearlo.
echo "→ Abriendo AnyDesk…"
open -a AnyDesk 2>/dev/null || true
sleep 2

# 3) Abrir los paneles de Privacidad que hay que ACTIVAR A MANO (macOS no deja
#    palomearlos por script). En macOS 11/12 abren "Preferencias del Sistema →
#    Seguridad y privacidad → Privacidad"; en 13+ abren "Configuración del Sistema".
echo "→ Abriendo los paneles de permisos (Grabación de pantalla y Accesibilidad)…"
open "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture" 2>/dev/null || true
sleep 1
open "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility" 2>/dev/null || true

# 4) Guía para el usuario (los toggles son manuales — 1 clic por permiso).
cat <<EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ AnyDesk instalado. AHORA activa 2 permisos (macOS obliga a hacerlo a mano):

Se te abrieron los paneles de "${SETTINGS_APP} → Privacidad y seguridad".

📲 1) GRABACIÓN DE PANTALLA
   • Activa el interruptor junto a  AnyDesk
   • (mismo panel: activa también tu NAVEGADOR —Chrome/Safari— para que
     Google Meet pueda COMPARTIR PANTALLA)

📲 2) ACCESIBILIDAD
   • Activa el interruptor junto a  AnyDesk
   • (esto permite que quien te asiste controle mouse y teclado)

⚠ Tras activar cada uno, si AnyDesk lo pide: haz clic en "Salir y volver a abrir".
   Si AnyDesk no aparece en la lista, usa el botón "+" y agrégalo desde
   /Applications/AnyDesk.app (o toca "Compartir" una vez para que aparezca).

🔢 Al terminar, dale a la persona que te asiste el número de 9 dígitos que
   muestra AnyDesk (tu "AnyDesk-Address").
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

EOF

echo "=== ✅ Listo. Falta solo palomear los 2 permisos en la ventana que se abrió. ==="
