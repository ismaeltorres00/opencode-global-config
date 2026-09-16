# Config central de OpenCode — Equipo Dev CDV

Fuente de verdad para agentes, skills y reglas compartidas por todo el
equipo, sin importar el proyecto en el que trabajes ni el stack (.NET,
PHP, React...).

Esta config **no sobreescribe tu configuración personal de OpenCode**.
Se carga como una capa independiente mediante la variable de entorno
`OPENCODE_CONFIG_DIR`, que se combina (merge) con tu `~/.config/opencode`
sin tocarlo.

---

## Requisitos previos

- OpenCode instalado y funcionando (`opencode --version`).
- Git instalado y con acceso al repo de la organización.
- **Windows**: PowerShell 5.1+ o PowerShell 7+.
- **macOS/Linux**: bash o zsh.

---

## Instalación

### Windows (PowerShell)

```powershell
git clone <URL_DE_ESTE_REPO> "$env:USERPROFILE\opencode-global-config"
cd "$env:USERPROFILE\opencode-global-config"
.\scripts\install.ps1
```

Si PowerShell bloquea la ejecución del script (política por defecto),
ejecuta esto una vez antes:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

`install.ps1` hace todo automáticamente:
- Configura `OPENCODE_CONFIG_DIR` en tu perfil de PowerShell (`$PROFILE`).
- Instala una función `opencode` que sincroniza el repo una vez al día
  antes de arrancar, sin que tengas que acordarte.
- Es seguro ejecutarlo varias veces: si detecta una instalación previa
  del equipo, la reemplaza limpiamente en vez de duplicarla.

**Cierra la ventana de PowerShell y abre una nueva** para que tome efecto.
Luego prueba:

```powershell
opencode --agent net-dev
```

### macOS / Linux

```bash
git clone <URL_DE_ESTE_REPO> ~/opencode-global-config
```

Añade esto a tu `~/.zshrc` o `~/.bashrc`:

```bash
export OPENCODE_CONFIG_DIR="$HOME/opencode-global-config"

# --- OpenCode config autosync (una vez al día) ---
OPENCODE_SYNC_MARKER="$OPENCODE_CONFIG_DIR/.last_sync"
if [ ! -f "$OPENCODE_SYNC_MARKER" ] || [ "$(date -r "$OPENCODE_SYNC_MARKER" +%Y%m%d 2>/dev/null)" != "$(date +%Y%m%d)" ]; then
  bash "$OPENCODE_CONFIG_DIR/scripts/opencode-sync.sh" && touch "$OPENCODE_SYNC_MARKER"
fi
```

Recarga tu shell (`source ~/.zshrc`) y prueba:

```bash
opencode --agent net-dev
```

---

## Cómo funciona (precedencia de config en OpenCode)

OpenCode combina (merge, no reemplaza) varias fuentes de config, en este
orden — cada una puede sobreescribir claves concretas de la anterior:

```
Remote (organización) → Global (~/.config/opencode) → OPENCODE_CONFIG_DIR → Proyecto (.opencode/)
```

Por eso este repo se instala vía `OPENCODE_CONFIG_DIR` y no clonado
directamente encima de `~/.config/opencode`: así tu configuración personal
(tema, modelo por defecto, MCPs propios) queda intacta, y solo se
añaden/sobreescriben las claves que el equipo define explícitamente.

---

## Actualizarse manualmente

Si no quieres esperar al sync automático diario:

**Windows:**
```powershell
& "$env:USERPROFILE\opencode-global-config\scripts\opencode-sync.ps1"
```

**macOS/Linux:**
```bash
bash ~/opencode-global-config/scripts/opencode-sync.sh
```

### Alternativa sin depender de abrir terminal: tarea programada

**Windows (Task Scheduler):**
1. Abre "Programador de tareas" → Crear tarea básica.
2. Desencadenador: Diariamente, a la hora que prefieras.
3. Acción → Iniciar un programa:
   - Programa: `powershell.exe`
   - Argumentos: `-ExecutionPolicy Bypass -File "%USERPROFILE%\opencode-global-config\scripts\opencode-sync.ps1"`

**macOS/Linux (cron), sync cada mañana a las 9:00:**
```bash
crontab -e
# añadir esta línea:
0 9 * * * /usr/bin/bash $HOME/opencode-global-config/scripts/opencode-sync.sh >> $HOME/opencode-global-config/sync.log 2>&1
```

---

## Estructura

```
.
├── AGENTS.md                          # reglas transversales, todo el equipo
├── opencode.json                      # modelo y permisos por defecto
├── README.md
│
├── agents/
│   └── net-dev.md                     # agente .NET (Sabre/Amadeus/AirGateway)
│                                       # añade aquí php-dev.md, react-dev.md...
│
├── skills/
│   └── net-clean-architecture/
│       └── SKILL.md                   # cada skill vive en su propia carpeta
│                                       # añade aquí php-*/,  react-*/,  shared-*/...
│
└── scripts/
    ├── install.ps1                    # instalación automática (Windows, ejecutar 1 vez)
    ├── opencode-sync.ps1              # sync manual/automático (Windows)
    └── opencode-sync.sh               # sync manual/automático (macOS/Linux)
```

> **Nota**: las carpetas `agents/` y `skills/` van siempre en **plural**.
> `agent/` (singular) solo se soporta por compatibilidad hacia atrás y
> puede dar problemas de detección — usa siempre plural en este repo.

---

## Convención de nombres (importante al añadir stacks nuevos)

Prefijo por stack en **agentes y skills**: `net-*`, `php-*`, `react-*`,
`shared-*` (transversal, usable por cualquier stack).

Cada agente restringe qué skills ve mediante `permission.skill` en su
frontmatter, usando esos mismos prefijos. Ejemplo (`agents/net-dev.md`):

```yaml
---
name: net-dev
description: Desarrollador Back-End .NET especializado en integraciones aéreas
mode: primary
permission:
  skill:
    "net-*": allow
    "shared-*": allow
    "*": deny
---
```

Esto hace que un dev de PHP no vea skills de .NET en su listado, y
viceversa — no es solo orden, es aislamiento real de contexto.

---

## Cómo crear un agente nuevo

1. Crea `agents/<stack>-dev.md` (o `<stack>-<rol>.md` si necesitas más de
   uno por stack, ej. `net-reviewer.md`).
2. El frontmatter **debe incluir**:
   - `name`: coincide con el nombre del archivo.
   - `description`: una frase clara de qué hace.
   - `mode: primary` — **obligatorio** si quieres poder invocarlo con
     `opencode --agent <nombre>`. Sin este campo, OpenCode no lo expone
     como agente principal seleccionable.
   - `permission.skill` con los prefijos que debe ver.
3. El cuerpo del Markdown es el system prompt del agente.
4. Guarda el archivo **en UTF-8** (en Windows con Notepad: Guardar como →
   Codificación: UTF-8, nunca "ANSI" — si no, los acentos se corrompen).

## Cómo crear una skill nueva

1. Crea la carpeta `skills/<stack>-<nombre>/` y dentro un `SKILL.md`.
2. Frontmatter mínimo:
   ```yaml
   ---
   name: <stack>-<nombre>
   description: Descripción específica de cuándo usar esta skill
   ---
   ```
3. El cuerpo describe la convención/patrón concreto — mejor una skill
   completa y útil que varias a medias.
4. Añade el prefijo correspondiente al `permission.skill` del agente que
   deba poder usarla.

---

## Troubleshooting

**`Agent not found`**
Falta `mode: primary` en el frontmatter del agente, o la carpeta se
llama `agent/` en vez de `agents/`. Corrige y reinicia la terminal.

**Acentos corruptos al hacer `Get-Content` en Windows** (`aÃ©reas` en vez
de `aéreas`)
El archivo se guardó con una codificación distinta a UTF-8. Vuelve a
guardarlo desde Notepad con codificación UTF-8 explícita.

**`no está reconocido como cmdlet` al ejecutar el script de sync en
Windows**
La política de ejecución de scripts está bloqueada por defecto. Ejecuta:
```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
```

**`Get-Command opencode` devuelve varias rutas juntas y falla el
wrapper**
`Get-Command` puede devolver más de una coincidencia (`opencode.cmd` y
`opencode`). Usa siempre `| Select-Object -First 1` al capturar la ruta,
tal como hace `install.ps1`.

**La variable `OPENCODE_CONFIG_DIR` sale vacía después de editar
`$PROFILE`**
Los cambios en `$PROFILE` solo se aplican a ventanas **nuevas** de
PowerShell. Cierra la ventana actual por completo y abre otra.

---

## Cómo contribuir

1. Rama nueva desde `main`.
2. Añade/edita agente o skill siguiendo la convención de nombres
   (prefijo de stack, carpetas en plural, `mode: primary` en agentes).
3. Prueba localmente antes de pedir revisión:
   - Windows: `$env:OPENCODE_CONFIG_DIR = "C:\ruta\a\tu\rama"`
   - macOS/Linux: `OPENCODE_CONFIG_DIR=/ruta/a/tu/rama opencode`
4. Abre PR + pide revisión de al menos otro dev antes de mergear a `main`.

---

## Seguridad

- No commitees credenciales, tokens ni claves de API (Sabre, Amadeus,
  AirGateway) en ningún agente, skill o config de este repo.
- `opencode.json` tiene `bash: "ask"` por defecto — cualquier cambio que
  lo pase a `"allow"` a nivel global debe pasar por PR y revisión, no
  hacerse directamente en `main`.
