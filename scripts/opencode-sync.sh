#!/usr/bin/env bash
# Sincroniza la config global de OpenCode con el repo central del equipo.
# Uso: bash opencode-sync.sh

set -euo pipefail

CONFIG_DIR="$HOME/.config/opencode"

if [ ! -d "$CONFIG_DIR/.git" ]; then
  echo "❌ $CONFIG_DIR no es un repo git. Instálalo primero con:"
  echo "   git clone <url-del-repo> $CONFIG_DIR"
  exit 1
fi

echo "🔄 Actualizando config de OpenCode..."
git -C "$CONFIG_DIR" fetch --quiet
LOCAL=$(git -C "$CONFIG_DIR" rev-parse @)
REMOTE=$(git -C "$CONFIG_DIR" rev-parse @{u})

if [ "$LOCAL" = "$REMOTE" ]; then
  echo "✅ Ya estás en la última versión."
else
  git -C "$CONFIG_DIR" pull --quiet
  echo "✅ Config actualizada a la última versión del repo."
fi
