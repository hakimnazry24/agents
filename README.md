# agents

My personal Claude Code setup: global instructions, skills, and settings, so any laptop can be set up the same way.

## Contents

| Path | Installs to | What it is |
|---|---|---|
| `CLAUDE.md` | `~/.claude/CLAUDE.md` | Global instructions for every project |
| `settings.json` | `~/.claude/settings.json` | Model, theme, and plugins (e.g. `i-have-adhd`) |
| `skills/<name>/` | `~/.claude/skills/<name>/` | Custom skills, e.g. `learning-mode` |

Skills synced from claude.ai (docx, pdf, deep-research, etc.) are not stored here. They appear automatically once you log in.

## Install on a new machine

```bash
git clone https://github.com/hakimnazry24/agents.git ~/coderepo/agents
cd ~/coderepo/agents
./install.sh
```

The script asks how to install:

- **Replace**: the repo's `CLAUDE.md`, `settings.json` and skills overwrite yours. Skills you have that aren't in the repo are kept.
- **Merge**: only adds what's missing. New settings, new `##` sections of `CLAUDE.md` and new skills are added; where both have a value, yours wins. Needs `jq`.

On Windows, run it from Git Bash. Existing files are backed up to `~/.claude/backups/` before anything changes. Restart Claude Code afterwards.

## Adding or updating something

1. Edit or add the file in this repo (new skill: `skills/<name>/SKILL.md`).
2. Commit and push.
3. On other machines: `git pull && ./install.sh`.

If you edited a file directly in `~/.claude`, copy it back into this repo before committing.
