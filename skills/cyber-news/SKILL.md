---
name: cyber-news
description: Fetch this week's cybersecurity news, from Monday of the current week up to today, and present a short digest grouped by topic with source links. Use when the user invokes /cyber-news or asks for this week's cybersecurity / infosec / security news.
allowed-tools: Bash(python3 -c *) WebSearch Agent
model: sonnet
---

# Cybersecurity News — This Week

## Date range

!`python3 -c "import datetime as d; t=d.date.today(); print(f'From: {t - d.timedelta(days=t.weekday()):%A %Y-%m-%d}\nTo:   {t:%A %Y-%m-%d}')"`

If the line above did not render as dates, run that `python3` command yourself to get the range. The week always starts on Monday; the range ends today.

## Steps

1. **Search.** Send these WebSearch calls in parallel (mode `standard`), putting the actual month and year of the range into each query:
   - cybersecurity news this week
   - data breach disclosed
   - zero-day vulnerability actively exploited / CISA KEV added
   - ransomware attack
   - critical CVE patch released
   - healthcare cyberattack / hospital ransomware
   - cybersecurity regulation or law enforcement takedown

   If a result set is thin or looks outdated, re-run that one query with mode `extended`.

2. **Filter by date.** Keep only stories published on or after Monday and on or before today. Drop anything you can't date confidently. Prefer the original reporting outlet (BleepingComputer, The Hacker News, SecurityWeek, The Record, Dark Reading, KrebsOnSecurity, CISA advisories, vendor advisories) over aggregators.

3. **Deduplicate.** The same story from several outlets is one item; keep the best source.

4. **Verify when unsure.** If a headline's key fact (who, what was affected, the CVE number) isn't clear from the search snippet, read the article with the `web-fetch` agent before including it. Never fill gaps from memory.

## Output

Reply in the terminal, no files. Use this layout and omit empty sections:

```
# Cybersecurity news — <Mon DD MMM> to <Day DD MMM YYYY>

## Top stories
1–3 items that matter most this week.

## Breaches & incidents
## Vulnerabilities & patches
## Ransomware & threat actors
## Healthcare
## Policy, law & takedowns
```

Each item is one line:

`- **<Headline in plain words>** (<Day DD MMM>) — <one sentence: what happened and who is affected>. [<Outlet>](<url>)`

Keep the whole digest under ~25 items. End with one line stating how many items were found and the date range covered. If nothing was found for the range (e.g. run early on a Monday), say so plainly instead of padding with older news.
