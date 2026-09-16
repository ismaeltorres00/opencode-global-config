# Sincroniza la config de OpenCode del equipo con la última versión del repo.
# Uso: .\opencode-sync.ps1

$ConfigDir = Join-Path $env:USERPROFILE "opencode-global-config"

if (-not (Test-Path "$ConfigDir\.git")) {
    Write-Host "$ConfigDir no es un repo git. Clónalo primero con:" -ForegroundColor Red
    Write-Host "  git clone <url-del-repo> `"$ConfigDir`""
    exit 1
}

Write-Host "Actualizando config de OpenCode..." -ForegroundColor Cyan

Push-Location $ConfigDir
git fetch --quiet

$local = git rev-parse '@'
$remote = git rev-parse '@{u}'

if ($local -eq $remote) {
    Write-Host "Ya estás en la última versión." -ForegroundColor Green
} else {
    git pull --quiet
    Write-Host "Config actualizada a la última versión del repo." -ForegroundColor Green
}

Pop-Location