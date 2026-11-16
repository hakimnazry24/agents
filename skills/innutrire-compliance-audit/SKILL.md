---
name: innutrire-compliance-audit
description: Run a full-repo baseline compliance audit of the five INNUTRIRE repos (frontend_innutrire, django_backend_innutrire, moniteer, tablet-setup-scripts, hospital-server-deployment-iac) against the nine locked standards (ISO 14971, IEC 62304, IEC 62366-1, GDHP cybersecurity, ISO 14155, ISO 13485, IEC 60601-1, IEC 60601-1-2, ISO 10993) and save a findings report. Use when the user asks for a compliance audit, standards audit, compliance gap analysis, "check this repo against the standards", or names one of these nine standards for an INNUTRIRE repo.
---

# INNUTRIRE compliance audit (baseline)

A read-only, full-repo baseline audit. It finds what evidence each standard expects, what the repo already has, and what is missing. It never changes code.

## Scope lock: nine standards only

| Key | Standard | Checklist |
|---|---|---|
| RM | ISO 14971:2019, risk management | `references/iso-14971.md` |
| SW | IEC 62304:2006+A1:2015, software lifecycle | `references/iec-62304.md` |
| UE | IEC 62366-1:2015+A1:2020, usability engineering | `references/iec-62366-1.md` |
| CS | GDHP cybersecurity guidance (GMDC 2024) | `references/gdhp.md` |
| CI | ISO 14155:2026, clinical investigation | `references/iso-14155.md` |
| QM | ISO 13485:2016, quality management system | `references/iso-13485.md` |
| ES | IEC 60601-1 ed. 3.2, basic safety | `references/iec-60601-1.md` |
| EM | IEC 60601-1-2 ed. 4.1, EMC | `references/iec-60601-1-2.md` |
| BC | ISO 10993-1:2025, biocompatibility | `references/iso-10993.md` |

- Audit against these nine and nothing else. If the user asks for any other standard or law (ISO 27001, IEC 81001-5-1, IEC 82304-1, PDPA, HL7 FHIR, FDA, MDR, etc.), say it is outside the locked scope of this skill and do not add checks or findings for it.
- Do not invent checklist items. Use only the items in the reference files. If something looks important but no item covers it, list it under "Observations outside the checklist" in the report, without a status.
- Clause numbers in the checklists are for orientation and come from public previews and summaries, not the full texts. Say so in the report.

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
8. **Reply in chat** with: the summary path, one line per repo (count of Met / Partial / Gap), and the top five High-severity gaps across the system. Nothing else.

## Severity

- **High:** could lead to patient harm (wrong calculation, wrong unit, lost data, misleading AI output), exposes patient data, or a core artefact the standard is built around is entirely missing.
- **Medium:** evidence exists but is incomplete or not traceable, or a control is weaker than expected.
- **Low:** documentation polish or a record that is easy to produce.

## Safety rules

- **Read-only.** Never edit, commit, push or run anything that changes repo state. Only read files and run read-only commands (`git log`, `git ls-files`, `grep`, `ls`, test listing). Don't run test suites, builds or deployments.
- **Secrets.** Never print a secret value. If a password, token or key is found, report its path, line and type (e.g. "GitHub token") with the value redacted as `[REDACTED]`.
- **Patient data.** Never open or quote patient-level rows. For data files, report only the path, the file type, and (if needed) column headers. Never names, RNs, dates of birth or row values.
- **No overclaiming.** The audit shows gaps in evidence; it does not certify compliance. Each report ends with the disclaimer from the template.
