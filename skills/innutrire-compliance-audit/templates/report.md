# Compliance baseline audit: <repo>

- **Date:** <YYYY-MM-DD>
- **Repo:** <repo name> (<role>), commit `<short sha>` on `<branch>`
- **Scope:** nine locked standards: ISO 14971:2019, IEC 62304:2006+A1:2015, IEC 62366-1:2015+A1:2020, GDHP GMDC v1.0, ISO 14155:2020, ISO 13485:2016, IEC 60601-1:2005+A1:2012, IEC 60601-1-2:2014, ISO 10993-1:2018

## Summary

| Standard | Met | Partial | Gap | Outside repo | N/A |
|---|---|---|---|---|---|
| ISO 14971 Risk management | | | | | |
| IEC 62304 Software lifecycle | | | | | |
| IEC 62366-1 Usability | | | | | |
| GDHP Cybersecurity | | | | | |
| ISO 14155 Clinical investigation | | | | | |
| ISO 13485 Quality management | | | | | |
| IEC 60601-1 Basic safety | | | | | |
| IEC 60601-1-2 EMC | | | | | |
| ISO 10993 Biocompatibility | | | | | |

### Top gaps (High severity)

1. `<ID>` <one line>
2. ...

## Findings

Write one section per standard, in the order of the table above. Within each section, list every item that applies, in checklist order:

### <Standard name>

#### <ID> <item title>: <Met | Partial | Gap | Outside repo | Not applicable>

- **Severity:** <High | Medium | Low> (omit for Met and Not applicable)
- **Evidence:** `path:line`, ... or "searched <where> for <what>: none found"
- **What is missing:** <plain words; omit for Met>

## Ask outside the repo

Items marked `Outside repo`, as questions for the team (e.g. "Is there a signed study protocol? Where is it kept?").

## Observations outside the checklist

Anything relevant the checklists don't cover. No status, no severity.

---

*This audit checks for evidence in the code repository only. All nine standards were checked against their full official texts (editions listed in the skill). It does not certify compliance; a qualified person must confirm each finding.*
