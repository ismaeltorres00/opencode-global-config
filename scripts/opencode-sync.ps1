# Sincroniza la config de OpenCode del equipo con la ultima version del repo.
# Uso: .\opencode-sync.ps1

$ConfigDir = Join-Path $env:USERPROFILE "opencode-global-config"

if (-not (Test-Path "$ConfigDir\.git")) {
    Write-Host "$ConfigDir no es un repo git. Clonalo primero con:" -ForegroundColor Red
    Write-Host "  git clone <url-del-repo> `"$ConfigDir`""
    exit 1
}

Write-Host "Actualizando config de OpenCode..." -ForegroundColor Cyan

Push-Location $ConfigDir
git fetch --quiet

$local = git rev-parse '@'
$remote = git rev-parse '@{u}'

if ($local -eq $remote) {
    Write-Host "Ya estas en la ultima version." -ForegroundColor Green
} else {
    git pull --quiet
    Write-Host "Config actualizada a la ultima version del repo." -ForegroundColor Green
}

Pop-Location