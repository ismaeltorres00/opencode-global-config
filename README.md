# Config central de OpenCode — Equipo Dev

Fuente de verdad para agentes, skills y reglas compartidas por todo el
equipo, sin importar el proyecto en el que trabajes.

## Instalación (una sola vez, por dev)

```bash
# Si nunca habéis usado OpenCode en esta máquina:
git clone <URL_DE_ESTE_REPO> ~/.config/opencode

# Si ~/.config/opencode ya existe con contenido propio, haced backup antes:
mv ~/.config/opencode ~/.config/opencode.bak
git clone <URL_DE_ESTE_REPO> ~/.config/opencode
```

Reiniciad OpenCode después de clonar.

## Mantenerse actualizado

Ejecutad el script de sync cuando queráis traer los últimos cambios:

```bash
bash ~/.config/opencode/scripts/opencode-sync.sh
```

### Automatizarlo (recomendado)

**macOS / Linux** — añadid esto a vuestro `~/.zshrc` o `~/.bashrc` para que
se sincronice solo una vez al día, la primera vez que abrís una terminal:

```bash
# --- OpenCode config autosync ---
OPENCODE_SYNC_MARKER="$HOME/.config/opencode/.last_sync"
if [ ! -f "$OPENCODE_SYNC_MARKER" ] || [ "$(date -r "$OPENCODE_SYNC_MARKER" +%Y%m%d 2>/dev/null)" != "$(date +%Y%m%d)" ]; then
  bash "$HOME/.config/opencode/scripts/opencode-sync.sh" && touch "$OPENCODE_SYNC_MARKER"
fi
```

**Alternativa con cron** (Linux/macOS), sync cada mañana a las 9:00:

```bash
crontab -e
# añadir esta línea:
0 9 * * * /usr/bin/bash $HOME/.config/opencode/scripts/opencode-sync.sh >> $HOME/.config/opencode/sync.log 2>&1
```

## Estructura

```
.
├── AGENTS.md                          # reglas transversales, todo el equipo
├── opencode.json                      # modelo y permisos por defecto
├── agent/
│   └── net-dev.md                     # agente .NET (Sabre/Amadeus/AirGateway)
├── skills/
│   └── net-clean-architecture/        # convenciones de arquitectura .NET
└── scripts/
    └── opencode-sync.sh
```

## Convención de nombres (importante al añadir stacks nuevos)

Prefijo por stack en agentes y skills: `net-*`, `php-*`, `react-*`,
`shared-*` (transversal, usable por cualquier stack).

Cada agente restringe qué skills ve mediante `permission.skill` en su
frontmatter, usando esos mismos prefijos. Ver `agent/net-dev.md` como
referencia antes de crear un agente para un stack nuevo.

## Cómo contribuir

1. Rama nueva desde `main`.
2. Añadir/editar agente o skill siguiendo la convención de nombres.
3. Probar localmente: `OPENCODE_CONFIG_DIR=/ruta/a/tu/rama opencode`.
4. PR + revisión de al menos otro dev antes de mergear a `main`.