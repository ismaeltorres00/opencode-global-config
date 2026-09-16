# Instalacion de la config del equipo de OpenCode.
# Ejecutar UNA sola vez, despues de haber clonado este repo.
# Funciona igual desde PowerShell o CMD, sin depender de $PROFILE.
# Uso: .\scripts\install.ps1

$ConfigDir = Join-Path $env:USERPROFILE "opencode-global-config"
$SyncScript = Join-Path $ConfigDir "scripts\opencode-sync.ps1"
$TaskName = "OpenCodeTeamConfigSync"

# --- Limpieza de instalaciones antiguas (version con funcion en $PROFILE) ---
$BeginMarker = "# === OPENCODE TEAM CONFIG (auto-generado, no editar a mano) ==="
$EndMarker   = "# === END OPENCODE TEAM CONFIG ==="
if (Test-Path $PROFILE) {
    $currentContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
    if ($currentContent -match [regex]::Escape($BeginMarker)) {
        $pattern = "(?s)$([regex]::Escape($BeginMarker)).*?$([regex]::Escape($EndMarker))"
        $cleaned = $currentContent -replace $pattern, ""
        Set-Content -Path $PROFILE -Value $cleaned
        Write-Host "Eliminada instalacion antigua (funcion en `$PROFILE)." -ForegroundColor DarkGray
    }
}

# --- 1. Variable de entorno a nivel de usuario de Windows ---
# setx la deja disponible en CUALQUIER terminal futura: PowerShell, CMD, Git Bash.
setx OPENCODE_CONFIG_DIR "$ConfigDir" | Out-Null
Write-Host "OPENCODE_CONFIG_DIR configurada a nivel de usuario: $ConfigDir" -ForegroundColor Green

# --- 2. Tarea programada para sincronizar en segundo plano ---
# Se ejecuta al iniciar sesion en Windows y ademas cada 6 horas mientras la
# sesion este abierta. No depende de abrir ninguna terminal ni de recordar nada.
$action = New-ScheduledTaskAction -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$SyncScript`""

$triggerLogon = New-ScheduledTaskTrigger -AtLogOn
$triggerRepeat = New-ScheduledTaskTrigger -Once -At (Get-Date) `
    -RepetitionInterval (New-TimeSpan -Hours 6) `
    -RepetitionDuration (New-TimeSpan -Days 3650)

Register-ScheduledTask -TaskName $TaskName `
    -Action $action `
    -Trigger @($triggerLogon, $triggerRepeat) `
    -Description "Sincroniza la config central de OpenCode del equipo" `
    -Force | Out-Null

Write-Host "Tarea programada '$TaskName' creada (sync al iniciar sesion + cada 6h)." -ForegroundColor Green

# --- 3. Sync inicial inmediato, para dejar todo listo ya mismo ---
& $SyncScript

Write-Host ""
Write-Host "Listo. Cierra esta terminal y abre una nueva (PowerShell o CMD, cualquiera)." -ForegroundColor Yellow
Write-Host "Despues prueba con: opencode --agent net-dev" -ForegroundColor Yellow