---
name: save-context
description: Save the current session's latest context into the persistent auto-memory, creating the memory files (and the MEMORY.md index) first if they don't exist yet. Use when the user invokes /save-context or says "update memory", "save context", "save progress to memory" or "remember where we are" — in any project or kind of session.
---

# Save context

Bring the auto-memory up to date with what happened in this session, so a later session (or this one after compaction) can pick up without the user repeating anything.

## 1. Find the memory

- The memory directory and its rules are in the system prompt's **Memory** section (a path like `~/.claude/projects/<project>/memory/`). Follow those rules: one fact per file, frontmatter `name` / `description` / `metadata.type`, `[[name]]` links, one index line per file in `MEMORY.md`.
- If the directory or `MEMORY.md` doesn't exist, create it now (`MEMORY.md` starts empty; no frontmatter).
- Read `MEMORY.md` and every memory file this session touched or relates to, so you update instead of duplicating.

## 2. Work out what changed this session

Go through the conversation and list, briefly:
- **Work state**: what was done, what's in progress, what's next, and what is waiting on the user (open questions, approvals). Use absolute dates.
- **Decisions the user made** and preferences or corrections they gave (with the why).
- **Facts that took effort to find** and aren't in the code, git history or project docs: ids, URLs, environments, gotchas, recipes, where files were saved.
- **Pointers**: tickets, PRs, dashboards, documents produced.

Leave out anything the repo already records, anything that only mattered for this conversation, and every secret (API keys, passwords, tokens): say where a secret is kept, never its value.

## 3. Write it

- **Existing topic** → edit that memory file: update the status in place, replace outdated lines rather than appending a log, delete facts that turned out wrong. Keep it readable top to bottom (status first, then facts, then open items).
- **New topic** → create a new file with the frontmatter, `**Why:**` / `**How to apply:**` lines for feedback and project memories, and `[[links]]` to related memories.
- **Index** → add or refresh the file's one-line pointer in `MEMORY.md` (`- [Title](file.md) — hook`). Keep the hook short and current; no memory content in the index.
- Check no secret value ended up in any memory file (grep for the values you know).

## 4. Report

Reply in a few lines: which files were created or updated, one line each, plus anything still open for the user.
