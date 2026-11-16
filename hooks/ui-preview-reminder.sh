#!/bin/bash

input=$(cat)
file=$(jq -r '.tool_input.file_path // empty' <<<"$input")
session=$(jq -r '.session_id // "unknown"' <<<"$input")

[[ "$file" =~ \.(tsx|jsx|css)$ ]] || exit 0

marker="${TMPDIR:-/tmp}/claude-ui-preview-reminded-${session}"
[ -e "$marker" ] && exit 0

for config in "$HOME"/ui-previews/*/preview.config.json; do
	[ -e "$config" ] || continue
	frontend=$(jq -r '.frontendPath // empty' "$config")
	[ -n "$frontend" ] || continue
	case "$file" in
	"$frontend"/*)
		touch "$marker"
		project=$(basename "$(dirname "$config")")
		jq -n --arg project "$project" '{
			hookSpecificOutput: {
				hookEventName: "PreToolUse",
				additionalContext: ("UI preview reminder: this edit is in the \($project) frontend. If it changes how the UI looks and the user has not approved a design preview yet, stop and follow the ui-preview skill first (preview in ~/ui-previews/\($project)/). Logic-only edits can go ahead. This reminder shows once per session.")
			}
		}'
		exit 0
		;;
	esac
done

exit 0
