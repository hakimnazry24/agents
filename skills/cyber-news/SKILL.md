---
name: cyber-news
description: Fetch the last month of cybersecurity news (the 30 days up to today), highlight what happened this week (Monday to today), and present a short digest grouped by topic with source links. Use when the user invokes /cyber-news or asks for this week's or this month's cybersecurity / infosec / security news.
allowed-tools: Bash(python3 -c *) WebSearch Agent
model: sonnet
---

# Cybersecurity News — Last Month, This Week Highlighted

## Date range

!`python3 -c "import datetime as d; t=d.date.today(); print(f'Month from: {t - d.timedelta(days=30):%A %Y-%m-%d}\nWeek from:  {t - d.timedelta(days=t.weekday()):%A %Y-%m-%d}\nTo:         {t:%A %Y-%m-%d}')"`

If the lines above did not render as dates, run that `python3` command yourself to get the range. The month window is the 30 days up to today. The week window starts on Monday of the current week and ends today; it sits inside the month window.

## Steps

1. **Search.** Send these WebSearch calls in parallel (mode `standard`), putting the month(s) and year the month window spans into each query (e.g. "October November 2026"):
   - cybersecurity news this week
   - cybersecurity news this month
   - data breach disclosed
   - zero-day vulnerability actively exploited / CISA KEV added
   - ransomware attack
   - critical CVE patch released
   - healthcare cyberattack / hospital ransomware
   - cybersecurity regulation or law enforcement takedown

   Then send one more `extended` search for the week window, naming today's date (e.g. "cybersecurity news November 17 2026"), so this week's stories are not crowded out by older ones. If any other result set is thin or looks outdated, re-run that query with mode `extended`.

2. **Filter by date.** Keep only stories published inside the month window. Drop anything you can't date confidently. Prefer the original reporting outlet (BleepingComputer, The Hacker News, SecurityWeek, The Record, Dark Reading, KrebsOnSecurity, CISA advisories, vendor advisories) over aggregators. A weekly roundup's page date is not a story's date — weekly roundups usually cover the week before they were posted. Use the original article's date; if only the roundup date is known, mark the item `(~DD MMM, via roundup)` and never put it in **This week** on that basis alone.

3. **Tag this week.** Mark each kept story whose publication date falls inside the week window.

4. **Deduplicate.** The same story from several outlets is one item; keep the best source and the earliest date.

5. **Verify when unsure.** If a headline's key fact (who, what was affected, the CVE number) or its date isn't clear from the search snippet, read the article with the `web-fetch` agent before including it. Never fill gaps from memory.

## Output

Reply in the terminal, no files. Use this layout and omit empty sections:

```
# Cybersecurity news — <DD MMM> to <Day DD MMM YYYY>

## This week (<Mon DD MMM> to <Day DD MMM>)
Every story tagged this week, most important first. If none, one line saying so.

## Earlier this month
### Breaches & incidents
### Vulnerabilities & patches
### Ransomware & threat actors
### Healthcare
### Policy, law & takedowns
```

A story appears once: if it is in **This week**, leave it out of **Earlier this month**. A story from earlier in the month that had a major development this week goes in **This week**, and its sentence names the development.

Each item is one line:

`- **<Headline in plain words>** (<Day DD MMM>) — <one sentence: what happened and who is affected>. [<Outlet>](<url>)`

Keep **This week** under ~12 items and the whole digest under ~35. If the month has more, keep the ones with the widest impact (actively exploited flaws, large breaches, critical infrastructure, healthcare). End with one line stating how many items were found this week and this month, and the date ranges covered.
