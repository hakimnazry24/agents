---
name: innutrire-compliance-audit
description: Run a full-repo baseline compliance audit of the five INNUTRIRE repos (frontend_innutrire, django_backend_innutrire, moniteer, tablet-setup-scripts, hospital-server-deployment-iac) against the nine locked standards (ISO 14971, IEC 62304, IEC 62366-1, GDHP cybersecurity, ISO 14155, ISO 13485, IEC 60601-1, IEC 60601-1-2, ISO 10993), save a findings report, and file the findings as de-duplicated cards on the Compliance and standard Trello board. Use when the user asks for a compliance audit, standards audit, compliance gap analysis, "check this repo against the standards", or names one of these nine standards for an INNUTRIRE repo.
model: sonnet
---

# INNUTRIRE compliance audit (baseline)

A read-only, full-repo baseline audit. It finds what evidence each standard expects, what the repo already has, and what is missing. It never changes code.

## Scope lock: nine standards only

| Key | Standard | Checklist |
|---|---|---|
| RM | ISO 14971:2019, risk management | `references/iso-14971.md` |
| SW | IEC 62304:2006+A1:2015 (ed. 1.1), software lifecycle | `references/iec-62304.md` |
| UE | IEC 62366-1:2015+A1:2020 (ed. 1.1), usability engineering | `references/iec-62366-1.md` |
| CS | GDHP Guidance for Medical Device Cybersecurity (GMDC) v1.0, Oct 2024 | `references/gdhp.md` |
| CI | ISO 14155:2020, clinical investigation | `references/iso-14155.md` |
| QM | ISO 13485:2016, quality management system | `references/iso-13485.md` |
| ES | IEC 60601-1:2005+A1:2012 (ed. 3.1), basic safety | `references/iec-60601-1.md` |
| EM | IEC 60601-1-2:2014 (ed. 4.0), EMC | `references/iec-60601-1-2.md` |
| BC | ISO 10993-1:2018 (BS EN ISO 10993-1:2020), biocompatibility | `references/iso-10993.md` |

- Audit against these nine and nothing else. If the user asks for any other standard or law (ISO 27001, IEC 81001-5-1, IEC 82304-1, PDPA, HL7 FHIR, FDA, MDR, etc.), say it is outside the locked scope of this skill and do not add checks or findings for it.
- Do not invent checklist items. Use only the items in the reference files. If something looks important but no item covers it, list it under "Observations outside the checklist" in the report, without a status.
- **Sources.** All nine checklists were written from the full official texts of the editions listed above, so their clause numbers are exact for those editions. GDHP has no ISO-style clauses; its checks cite provision codes (e.g. `VDP.1`) and section numbers. If a hospital or regulator cites a newer edition (e.g. IEC 60601-1 ed. 3.2, IEC 60601-1-2 ed. 4.1), note that clause numbers may differ.
- **Stable check IDs.** Trello cards are matched by check ID, so never renumber or reuse an ID when editing a checklist. Add new checks at the end with the next free number.

## How to run it (model and token use)

The skill runs on Sonnet (`model: sonnet` above, currently Sonnet 5.5) to keep token use down. Split the work this way:

- **One subagent per repo, in parallel.** Use the Agent tool with `model: "sonnet"` and `run_in_background: true`, one per target repo, each given `templates/repo-agent-brief.md` (fill in the repo, its role and today's date). Each subagent does Steps 2 to 6 for its repo only and returns a compact table of its findings. It never touches Trello.
- **The main session stays light.** It doesn't read the repos itself. It collects the subagents' tables, then does Steps 7 to 9 (summary, Trello, reply).
- If a run is interrupted, check `~/Documents/INNUTRIRE-compliance/audits/` first: a report that ends with the disclaimer is complete, so read its findings from the report instead of auditing that repo again.

## Steps

1. **Pick the targets.** Every run covers these five repos under `/Users/hakimnazry/coderepo/`, in this order:
   1. `frontend_innutrire`
   2. `django_backend_innutrire`
   3. `moniteer`
   4. `tablet-setup-scripts`
   5. `hospital-server-deployment-iac`

   Audit them one at a time, whichever directory the session started in. Only audit fewer if the user names specific repos from this list. Never audit any other repo; `Regression_models_innutrire` is out of scope. If a repo folder is missing, note it in the combined summary and carry on with the rest.
2. **Read `references/innutrire-context.md`.** Find the repo's role, its safety-critical areas and where existing evidence normally lives.
3. **Build an inventory** before judging anything:
   - top-level tree (two levels) and docs (`README*`, `CLAUDE.md`, `AGENTS.md`, `docs/`, `CHANGELOG*`)
   - CI and release config (`.github/workflows/*`, release-please or semantic-release config, `pyproject.toml`, `package.json`)
   - tests (folders, count of test files, what the CI runs)
   - dependency manifests and lock files (third-party software)
   - config and secrets surfaces (`.env*`, `settings.py`, `config.*`, Dockerfiles, compose files, inventory files)
   - data files (`*.xlsx`, `*.csv`, `*.json` fixtures, `*.joblib`, databases)
4. **Run every checklist.** Read all nine reference files. Each item names the repo roles it applies to. For each item that applies, give one status:
   - **Met:** clear evidence in the repo.
   - **Partial:** some evidence, but incomplete.
   - **Gap:** expected evidence is missing, or the code goes against the item.
   - **Outside repo:** the evidence normally lives outside code (ethics approvals, signed procedures, Trello). Say what to ask for instead of guessing.
   - **Not applicable:** the item doesn't apply to this repo's role. Give the one-line reason.
5. **Back every status with evidence.** Use `path:line` for what exists, and for what is missing, say what was searched (e.g. `searched docs/, README.md and *.md for "risk", "hazard": none`). Never claim something exists without opening it.
6. **Write one report per repo** using `templates/report.md`, save it to `~/Documents/INNUTRIRE-compliance/audits/<YYYY-MM-DD>_<repo>_baseline.md`, and create the folder if it is missing. If a report for the same repo and date exists, add `_2`, `_3`, and so on rather than overwriting it.
7. **Write the combined summary** using `templates/summary.md`, saved to `~/Documents/INNUTRIRE-compliance/audits/<YYYY-MM-DD>_system_summary.md` (same `_2` rule). It totals the statuses across all audited repos and lists the High-severity gaps from every repo.
8. **Sync findings to Trello.** Follow "Trello tickets" below.
9. **Reply in chat** with: the summary path, one line per repo (count of Met / Partial / Gap), the top five High-severity gaps across the system, and the Trello result (cards created, cards commented on, Done or archived cards whose finding came back). Nothing else.

## Trello tickets

Every run files its findings on the **Compliance and standard** board (https://trello.com/b/YCWJIGY0/compliance-and-standard, lists Triage → To do → Doing → Done). Use the Trello MCP tools (`trelloReadCard`, `trelloWriteCard`). If they are not available or the board can't be read, skip this step, say so in the reply, and don't guess.

**What becomes a ticket:** one card per check ID with status Gap, Partial or Outside repo in at least one repo, merged across repos. Met and Not applicable never create cards.

**1. Read the board first.** Call `trelloReadCard` `list_by_board` with `filter: "all"` (open and archived cards, every list), and follow `nextCursor` until `hasNextPage` is false. The result is large and is usually saved to a file; read it with a short `python3 -I` or `jq` script that prints each card's list, archived flag, short URL and title, rather than reading it raw. Build an index from each card's title prefix: a title starts with one or more check IDs, e.g. `RM-01 ...` or `RM-04 / UE-04 ...`. Every ID in the prefix maps to that card, its list and whether it is archived.

**2. Decide per finding (by check ID):**

| Existing card for the ID | Action |
|---|---|
| None | Look for an open card that describes the same problem under another ID (e.g. the same missing document). If one exists, add the new ID to that card's title prefix (`QM-03 / CI-17 ...`) with `update`, and comment that the latest scan also reports it under the new ID. Otherwise create a new card in **Triage**. |
| Open (Triage, To do, Doing) | Don't create a card. If the latest scan finds it in repos missing from the card's "Found in" line, or at a different severity, add one comment: `<date> scan: still <status> in <repos>; severity <level>.` Otherwise leave the card alone. |
| In Done | Don't create a card and don't move it. Add a comment `<date> scan: this finding is back (<status> in <repos>).` and list it in the reply so the user decides whether to reopen it. |
| Archived | The user dismissed it. Don't create, comment on or restore it; list it in the reply only. |

Also, for every open card whose IDs are now **Met or Not applicable in every repo**, add a comment `<date> scan: no longer found in any repo.` Don't move it; the user moves cards to Done.

Never create two cards for the same ID in one run, and never post the same comment twice: before commenting, check the card's latest comments for one from the same date.

**3. Card format** (match the existing cards):
- **Title:** `<ID> <the problem in plain words>`, e.g. `CI-09 Raw entered values are not kept with the result`. Describe the problem, not the checklist title.
- **Description:** two or three plain sentences saying only what is wrong and why it matters. No suggested fix, no file paths, no headings. Then a blank line and a footer: `Found in: <repo names from innutrire-context.md>. Standard: <standard>. Severity: <High | Medium | Low>.` For Outside repo findings, write the description as the missing record ("No ethics approval is on record for ...").
- **List:** Triage. No labels, members or due dates.
- **Order:** create High first, then Medium, then Low; within a severity, in checklist order.

**Safety:** cards must follow the same rules as reports: no secret values, no patient names, RNs, dates of birth or row values. Name the kind of secret ("a database password"), never its value.

## Severity

- **High:** could lead to patient harm (wrong calculation, wrong unit, lost data, misleading AI output), exposes patient data, or a core artefact the standard is built around is entirely missing.
- **Medium:** evidence exists but is incomplete or not traceable, or a control is weaker than expected.
- **Low:** documentation polish or a record that is easy to produce.

## Safety rules

- **Read-only on the repos.** Never edit, commit, push or run anything that changes repo state. The only writes outside the report files are the Trello cards and comments described above. Only read files and run read-only commands (`git log`, `git ls-files`, `grep`, `ls`, test listing). Don't run test suites, builds or deployments.
- **Secrets.** Never print a secret value. If a password, token or key is found, report its path, line and type (e.g. "GitHub token") with the value redacted as `[REDACTED]`.
- **Patient data.** Never open or quote patient-level rows. For data files, report only the path, the file type, and (if needed) column headers. Never names, RNs, dates of birth or row values.
- **No overclaiming.** The audit shows gaps in evidence; it does not certify compliance. Each report ends with the disclaimer from the template.
