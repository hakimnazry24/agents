#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$CLAUDE_DIR/backups/agents-$(date +%Y%m%d-%H%M%S)"

mkdir -p "$CLAUDE_DIR/skills" "$BACKUP_DIR"

for file in CLAUDE.md settings.json; do
  if [ -f "$CLAUDE_DIR/$file" ]; then
    cp "$CLAUDE_DIR/$file" "$BACKUP_DIR/"
  fi
  cp "$REPO_DIR/$file" "$CLAUDE_DIR/$file"
done

for skill in "$REPO_DIR"/skills/*/; do
  name="$(basename "$skill")"
  if [ -d "$CLAUDE_DIR/skills/$name" ]; then
    cp -r "$CLAUDE_DIR/skills/$name" "$BACKUP_DIR/"
    rm -rf "$CLAUDE_DIR/skills/$name"
  fi
  cp -r "$skill" "$CLAUDE_DIR/skills/$name"
done

echo "Installed into $CLAUDE_DIR (previous files backed up to $BACKUP_DIR)"
