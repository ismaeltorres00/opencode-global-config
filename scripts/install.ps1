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

# --- 2. Sincronizacion automatica en segundo plano ---
# Se intenta primero via Task Scheduler (sync al iniciar sesion + cada 6h).
# En equipos corporativos con permisos restringidos, esto falla con "Access is
# denied" -> se usa automaticamente la carpeta de Inicio de Windows como
# alternativa, que no requiere permisos especiales (sync solo al iniciar sesion).

$TaskCreated = $false
try {
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
        -Force -ErrorAction Stop | Out-Null

    $TaskCreated = $true
    Write-Host "Tarea programada '$TaskName' creada (sync al iniciar sesion + cada 6h)." -ForegroundColor Green
} catch {
    Write-Host "Sin permisos para crear tarea programada (habitual en equipos corporativos)." -ForegroundColor DarkYellow
    Write-Host "Usando alternativa: carpeta de Inicio de Windows (sync al iniciar sesion)." -ForegroundColor DarkYellow
}

if (-not $TaskCreated) {
    $startupDir = [Environment]::GetFolderPath("Startup")
    $launcherPath = Join-Path $startupDir "OpenCodeTeamConfigSync.vbs"

    # .vbs en vez de .bat/.ps1 para que se ejecute totalmente oculto, sin
    # parpadeo de ventana de consola al iniciar sesion.
    $vbsContent = @"
Set objShell = CreateObject("WScript.Shell")
objShell.Run "powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File ""$SyncScript""", 0, False
"@
    Set-Content -Path $launcherPath -Value $vbsContent -Encoding ASCII

    Write-Host "Sync automatico configurado en: $launcherPath" -ForegroundColor Green
    Write-Host "(se ejecutara cada vez que inicies sesion en Windows)" -ForegroundColor Green
}

# --- 3. Sync inicial inmediato, para dejar todo listo ya mismo ---
& $SyncScript

Write-Host ""
Write-Host "Listo. Cierra esta terminal y abre una nueva (PowerShell o CMD, cualquiera)." -ForegroundColor Yellow
Write-Host "Despues prueba con: opencode --agent net-dev" -ForegroundColor Yellow