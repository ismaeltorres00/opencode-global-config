# Instalación de la config del equipo de OpenCode.
# Ejecutar UNA sola vez, después de haber clonado este repo.
# Uso: .\scripts\install.ps1

$ConfigDir = Join-Path $env:USERPROFILE "opencode-global-config"
$BeginMarker = "# === OPENCODE TEAM CONFIG (auto-generado, no editar a mano) ==="
$EndMarker   = "# === END OPENCODE TEAM CONFIG ==="

$Block = @"
$BeginMarker
`$env:OPENCODE_CONFIG_DIR = "$ConfigDir"

`$OpencodeBin = (Get-Command opencode -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1).Source

function opencode {
    `$configDir = "$ConfigDir"
    `$syncMarker = "`$configDir\.last_sync"
    `$today = Get-Date -Format "yyyyMMdd"
    `$lastSync = if (Test-Path `$syncMarker) { Get-Content `$syncMarker } else { "" }

    if (`$lastSync -ne `$today) {
        & "`$configDir\scripts\opencode-sync.ps1"
        `$today | Out-File `$syncMarker
    }

    & `$OpencodeBin @args
}
$EndMarker
"@

# Crea el perfil si no existe
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
    Write-Host "Perfil de PowerShell creado en: $PROFILE" -ForegroundColor Cyan
}

$currentContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
if ($null -eq $currentContent) { $currentContent = "" }

if ($currentContent -match [regex]::Escape($BeginMarker)) {
    # Ya existe una instalación previa: la reemplazamos entera para que quede
    # siempre igual a la versión actual del repo (evita duplicados y config vieja).
    $pattern = "(?s)$([regex]::Escape($BeginMarker)).*?$([regex]::Escape($EndMarker))"
    $newContent = $currentContent -replace $pattern, $Block
    Set-Content -Path $PROFILE -Value $newContent
    Write-Host "Config del equipo actualizada en tu perfil." -ForegroundColor Green
} else {
    Add-Content -Path $PROFILE -Value "`n$Block"
    Write-Host "Config del equipo añadida a tu perfil." -ForegroundColor Green
}

# Ejecuta un sync inicial para dejar todo listo desde ya
& (Join-Path $ConfigDir "scripts\opencode-sync.ps1")

Write-Host ""
Write-Host "Listo. Cierra esta ventana de PowerShell y abre una nueva para que tome efecto." -ForegroundColor Yellow
Write-Host "Después prueba con: opencode --agent net-dev" -ForegroundColor Yellow