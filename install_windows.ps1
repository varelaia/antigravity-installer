# install_windows.ps1 — Script de instalación nativo para Windows (PowerShell)
# Instala FNM (Fast Node Manager), Node.js LTS, y la CLI de Antigravity (agy)
# NO requiere permisos de administrador (sudo / run-as-admin)

# 1. Configurar directiva de ejecución local para permitir correr scripts firmados/locales temporalmente
$InstructionText = @"
======================================================
  Instalador de Entorno Antigravity para Windows
======================================================
"@
Write-Host $InstructionText -ForegroundColor Cyan

# 2. Instalar FNM (Fast Node Manager) vía Winget (paquete oficial en Windows 10/11)
Write-Host "1. Descargando e instalando FNM (Fast Node Manager) via winget..." -ForegroundColor Yellow
winget install Schniz.fnm --accept-source-agreements --accept-package-agreements

# 3. Configurar variables de entorno y perfil de PowerShell
Write-Host "2. Configurando variables de entorno de FNM para PowerShell..." -ForegroundColor Yellow

# Verificar si el archivo de perfil del usuario de PowerShell existe, si no, crearlo
$ProfileDir = Split-Path -Parent $PROFILE
if (!(Test-Path $ProfileDir)) {
    New-Item -Type Directory -Force -Path $ProfileDir | Out-Null
}
if (!(Test-Path $PROFILE)) {
    New-Item -Type File -Force -Path $PROFILE | Out-Null
}

# Añadir cargador de FNM al perfil para persistencia de la sesión de PowerShell
$FnmLoadCmd = 'fnm env --use-on-cd | Out-String | Invoke-Expression'
if ((Get-Content $PROFILE -ErrorAction SilentlyContinue) -notcontains $FnmLoadCmd) {
    Add-Content -Path $PROFILE -Value "`n# Cargar Fast Node Manager (FNM)`n$FnmLoadCmd"
}

# Cargar FNM en la sesión de PowerShell actual activa
& fnm env --use-on-cd | Out-String | Invoke-Expression

# 4. Instalar Node.js versión de Soporte a Largo Plazo (LTS)
Write-Host "3. Instalando Node.js LTS y npm compatible..." -ForegroundColor Yellow
fnm install --lts
fnm default lts

# 5. Descargar e instalar la CLI de Antigravity
Write-Host "4. Instalando Antigravity CLI (agy) para Windows..." -ForegroundColor Yellow
Invoke-RestMethod -Uri "https://antigravity.google/cli/install.ps1" | Invoke-Expression

Write-Host "=== ✅ Instalación Completada ===" -ForegroundColor Green
Write-Host "Por favor cierra y vuelve a abrir tu terminal de PowerShell para activar los cambios." -ForegroundColor Green
