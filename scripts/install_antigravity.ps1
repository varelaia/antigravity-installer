# install_antigravity.ps1 — Wrapper del instalador OFICIAL de Antigravity CLI (agy) en Windows.
#
# Filosofía: el CLI 'agy' es un binario Go NATIVO; NO usa Node.js ni npm. Por eso aquí
# NO instalamos FNM/Node (eso solo es necesario para el catálogo OPCIONAL de skills,
# ver install_skills). Delegamos en el instalador oficial (descarga + verificación
# SHA512 + idempotencia) y añadimos lo único que el oficial no garantiza: persistir el
# binario en el PATH de usuario. No requiere permisos de administrador.

$ErrorActionPreference = "Stop"
$BinDir  = Join-Path $env:LOCALAPPDATA "agy\bin"
$BinPath = Join-Path $BinDir "agy.exe"

Write-Host "=== Instalador Antigravity CLI (agy) para Windows ===" -ForegroundColor Cyan

# 1) Idempotencia: si ya existe, no reinstalar (se auto-actualiza solo).
if (Test-Path $BinPath) {
    Write-Host "✓ 'agy.exe' ya está instalado en $BinPath (se auto-actualiza en background)." -ForegroundColor Green
} else {
    Write-Host "⬇ Ejecutando el instalador oficial..." -ForegroundColor Yellow
    Invoke-RestMethod -Uri "https://antigravity.google/cli/install.ps1" | Invoke-Expression
}

# 2) Persistir el PATH de USUARIO de forma idempotente.
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$BinDir*") {
    $newPath = if ([string]::IsNullOrEmpty($userPath)) { $BinDir } else { "$userPath;$BinDir" }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "✓ Añadido $BinDir al PATH de usuario." -ForegroundColor Green
} else {
    Write-Host "✓ $BinDir ya estaba en el PATH de usuario." -ForegroundColor Green
}
# Cargar en la sesión actual de PowerShell.
$env:Path = "$env:Path;$BinDir"

# 3) Verificar.
if (Get-Command agy -ErrorAction SilentlyContinue) {
    Write-Host "`n=== ✅ Antigravity CLI lista ===" -ForegroundColor Green
    Write-Host "Versión: $(agy --version)"
    Write-Host "`n⚠ Abre una terminal NUEVA de PowerShell para que el PATH persista." -ForegroundColor Yellow
} else {
    Write-Host "✗ 'agy' no quedó en el PATH. Abre una terminal NUEVA de PowerShell." -ForegroundColor Red
    exit 1
}
