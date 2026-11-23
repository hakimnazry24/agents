# Brief for a per-repo audit subagent

Fill in before sending: the repo path, its role (from `references/innutrire-context.md`) and today's date. Add repo-specific cautions (e.g. files known to hold secrets or patient rows).

You are auditing exactly one repo (named in your prompt) as part of a five-repo run. Today's date is <YYYY-MM-DD>.

## Do
1. Read `~/.claude/skills/innutrire-compliance-audit/SKILL.md` and follow its **Steps 2 to 6 only** for your repo: read `references/innutrire-context.md`, build the inventory, run **all nine** checklists in `references/` (iso-14971, iec-62304, iec-62366-1, gdhp, iso-14155, iso-13485, iec-60601-1, iec-60601-1-2, iso-10993), back every status with evidence, and write the report with `templates/report.md`.
2. Save the report to `~/Documents/INNUTRIRE-compliance/audits/<YYYY-MM-DD>_<repo>_baseline.md`. If that file exists, use `_2`, `_3`, ... Create the folder if missing.
3. For system-wide documents (risk file, plans, procedures, SOUP list), also search `~/coderepo/compliance_docs` as the context file says, and cite it if found.
4. Record the branch and short commit you audited (`git rev-parse --abbrev-ref HEAD`, `git rev-parse --short HEAD`). Other sessions may switch branches in these repos; if the branch is not `main`, say so in the report header and note it in your final message.

## Don't
- Don't do Step 7 (summary), Step 8 (Trello) or Step 9 (chat reply). The orchestrator does those.
- Don't edit, commit, push, check out branches, install, build, or run tests in any repo. Read-only commands only.
- Never print secret values (write `[REDACTED]` and the secret's type). Never open patient-level rows in data files; path, file type and column headers only.
- Don't audit any other repo.

## Final message (this is what the orchestrator uses; be exact and compact)
1. Report path, branch, commit.
2. Counts: Met / Partial / Gap / Outside repo / N/A.
3. A table of EVERY check with status Gap, Partial or Outside repo, one row each:
   `ID | status | severity | one plain sentence describing the problem in this repo (no file paths, no secret values, no patient data)`
4. A plain list of the IDs that are Met, and the IDs that are Not applicable.
5. Anything you could not check and why.

## Token use
Use `grep`, `ls` and `git ls-files` to find evidence and read only the relevant parts of files, not whole large files. The report must still cover every applicable check with evidence.
