#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
BACKUP_DIR="$CLAUDE_DIR/backups/agents-$(date +%Y%m%d-%H%M%S)"

MERGE_SETTINGS='
def dedupe: reduce .[] as $item ([]; if any(.[]; . == $item) then . else . + [$item] end);
def merge($repo; $laptop):
  if ($repo | type) == "object" and ($laptop | type) == "object" then
    reduce (($laptop | keys_unsorted) + ($repo | keys_unsorted) | dedupe)[] as $key ({};
      .[$key] = if ($laptop | has($key)) and ($repo | has($key)) then merge($repo[$key]; $laptop[$key])
                elif ($laptop | has($key)) then $laptop[$key]
                else $repo[$key] end)
  elif ($repo | type) == "array" and ($laptop | type) == "array" then $laptop + $repo | dedupe
  else $laptop end;
merge(.[0]; .[1])
'

APPEND_MISSING_SECTIONS='
BEGIN { while ((getline line < laptop_file) > 0) if (line ~ /^## /) installed[line] = 1 }
/^## / { keep = !($0 in installed); if (keep) print "" }
keep { print }
'

echo "How should this repo be installed into $CLAUDE_DIR?"
echo "  [r] Replace: overwrite your settings with the repo version"
echo "  [m] Merge: add what is in the repo, keep what you already have"
while true; do
  read -r -p "Choose r or m: " answer
  case "$answer" in
    r|R) MODE=replace; break ;;
    m|M) MODE=merge; break ;;
  esac
done

if [ "$MODE" = merge ] && ! command -v jq >/dev/null; then
  echo "Merge mode needs jq. Install it (macOS: brew install jq, Windows: winget install jqlang.jq) and run again."
  exit 1
fi

mkdir -p "$CLAUDE_DIR/skills" "$BACKUP_DIR"

for file in CLAUDE.md settings.json; do
  if [ -f "$CLAUDE_DIR/$file" ]; then
    cp "$CLAUDE_DIR/$file" "$BACKUP_DIR/"
  fi
done

if [ "$MODE" = merge ] && [ -f "$CLAUDE_DIR/settings.json" ]; then
  merged_settings="$(jq -s "$MERGE_SETTINGS" "$REPO_DIR/settings.json" "$CLAUDE_DIR/settings.json")"
  printf '%s\n' "$merged_settings" > "$CLAUDE_DIR/settings.json"
else
  cp "$REPO_DIR/settings.json" "$CLAUDE_DIR/settings.json"
fi

if [ "$MODE" = merge ] && [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
  missing_sections="$(awk -v laptop_file="$CLAUDE_DIR/CLAUDE.md" "$APPEND_MISSING_SECTIONS" "$REPO_DIR/CLAUDE.md")"
  if [ -n "$missing_sections" ]; then
    printf '%s\n' "$missing_sections" >> "$CLAUDE_DIR/CLAUDE.md"
  fi
else
  cp "$REPO_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
fi

for skill in "$REPO_DIR"/skills/*/; do
  name="$(basename "$skill")"
  target="$CLAUDE_DIR/skills/$name"
  if [ -d "$target" ] && [ "$MODE" = merge ]; then
    echo "Kept your existing skill: $name"
    continue
  fi
  if [ -d "$target" ]; then
    cp -R "$target" "$BACKUP_DIR/"
    rm -rf "$target"
  fi
  cp -R "$skill" "$target"
done

echo "Installed into $CLAUDE_DIR using $MODE mode (previous files backed up to $BACKUP_DIR)"
