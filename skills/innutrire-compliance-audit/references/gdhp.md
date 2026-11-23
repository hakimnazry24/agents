# GDHP Guidance for Medical Device Cybersecurity (GMDC) v1.0, October 2024 (key CS)

**Source:** checked against the full text of the Global Digital Health Partnership (GDHP) *Guidance for Medical Device Cybersecurity (GMDC)*, version 1.0, October 2024 (published under CC BY-SA 4.0). It has no numbered clauses in the ISO sense; each requirement is a **provision** with a code (e.g. `VDP.1`) and a section number (e.g. 8.3.1). Both are given below.

**In plain words:** voluntary guidance from the GDHP (a group of governments and the WHO) on building and running medical devices that resist cyber attack. It is written as a form: for each provision the manufacturer declares Yes / No / Not applicable and attaches evidence. Hospitals can use that declaration when deciding whether to buy a device.

**What the guidance covers that matters for INNUTRIRE:**
- **It applies to INNUTRIRE.** Scope (section 3) covers any medical device, including software, that handles identifiable or clinical data, or connects to a network. INNUTRIRE does both.
- **Four levels** (section 4, adapted from Singapore's Cybersecurity Labelling Scheme for Medical Devices): Level 1 is 6 baseline provisions; Level 2 adds 32 enhanced provisions (38 total); Level 3 adds penetration testing and software binary analysis by a test lab; Level 4 adds advanced security evaluation. Levels 1 and 2 are self-declared with evidence.
- **Level 1 baseline** (8.3): a way to report vulnerabilities (VDP.1), a plan to fix them (CSUP.1) and to watch for new ones (CSUP.4), no universal default passwords (PAUT.3), protection against password guessing (PAUT.4), and cybersecurity inside the risk management process (RDMP.1).
- **"Sensitive data"** (section 6) means three things: identifiable information (name, IC number, address), clinical data, and security secrets (keys, tokens, passwords, certificates). Many provisions apply to all three.
- **Operating system credentials count.** PAUT.3 extends to the OS accounts of the platform the medical software runs on, so tablet Windows accounts, server accounts and database users are in scope, not only app logins.
- **Evidence the guidance expects** is concrete: lists (sensitive data, interfaces, ports, pre-installed accounts, communication channels), an SBOM with author, timestamp, name, version and licence per component, a port scan of each device, and the rate-limit calculation for logins.

**Severity rule for this checklist:** a gap in a Level 1 provision, or one that exposes patient data or secrets, is High. Other Level 2 gaps are Medium unless stated.

**Relation to INNUTRIRE:** the tablet app, hospital server, Moniteer, tablet setup scripts and server setup all hold or move patient data or secrets, so most provisions apply to more than one repo. Hospital-facing documents (security guide, support period, contact details) usually live outside the code.

Check IDs CS-01 to CS-12 keep the same meaning as earlier versions of this checklist, because cards on the Trello board are matched by ID. New checks get new numbers.

---

### CS-01 No secrets in the repository
- **Applies to:** all
- **Clause:** section 6 (security parameters are sensitive data), MSD.1 (9.3.1), PAUT.3 (8.3.4)
- **Look for:** hard-coded `SECRET_KEY`, passwords, PINs, Wi-Fi keys, tokens, API keys and private keys in tracked files (`git ls-files` + grep for `password`, `secret`, `token`, `ghp_`, `BEGIN .* PRIVATE KEY`, `PAT`, `psk`). Also committed `.env` files. Report path and line only; redact values.
- **Met:** none found; `.env.example` holds placeholders only. **Gap:** any secret found.
- **Severity if not met:** High

### CS-02 Authentication on every interface carrying patient data
- **Applies to:** backend, monitoring, tablet-app
- **Clause:** PAUT.1 (9.3.13), PAUT.3 (8.3.4, credentials sent over a secure channel)
- **Look for:** login, token or API-key checks on views, decorators, middleware and DRF permission classes, with special attention to `agent/` endpoints and the Moniteer snapshot endpoints. The guidance also expects a written list of every function that works without login and why (e.g. health check, version, sign-in steps), and that credentials are only ever sent over TLS.
- **Met:** every patient-data endpoint requires authentication and open functions are listed with a reason. **Partial:** some do, or no list of open functions. **Gap:** open endpoints serve patient data.
- **Severity if not met:** High

### CS-03 Role-based access and personal accounts
- **Applies to:** backend, monitoring, tablet-app
- **Clause:** AUTH.1 (9.3.4), AUTH.2 (9.3.5), PAUT.2 (9.3.14)
- **Look for:** personal user accounts (not shared logins); roles that limit what each user can do; an admin who can assign and remove roles; every user able to change their own password or PIN; and only the built-in accounts that are really needed, each with a reason.
- **Met:** personal accounts with roles, role management and credential change. **Partial:** accounts without roles, or no way to change credentials. **Gap:** shared or no accounts.
- **Severity if not met:** Medium

### CS-04 Encryption in transit
- **Applies to:** backend, tablet-app, monitoring, infrastructure
- **Clause:** TXCF.1 (9.3.27), TXIG.1 (9.3.28), OTHR.2 (9.3.31)
- **Look for:** TLS 1.2 or higher between tablet and server and between server and Moniteer (`https://` base URLs, a TLS proxy in IaC or compose files, Django `SECURE_*` settings), integrity protection on the same links, WPA2 or WPA3 on the Wi-Fi the tablets join (tablet setup scripts), and any export to USB or files.
- **Met:** TLS on every link and WPA2+ Wi-Fi. **Partial:** some links rely only on the Tailscale tunnel or the hospital network. **Gap:** plain HTTP on the hospital network.
- **Severity if not met:** High

### CS-05 Encryption at rest for patient data
- **Applies to:** backend, monitoring, tablet-app, infrastructure, provisioning
- **Clause:** STCF.1 (9.3.26)
- **Look for:** for each place sensitive data is stored: database or disk encryption on the server, BitLocker on tablets, an encrypted local cache in the tablet app (`app/features/local_cache`), encrypted backups, and Moniteer's snapshot store. The guidance expects the location, method, algorithm and key size for each.
- **Met:** every store encrypted and documented. **Partial:** some stores. **Gap:** plain-text stores.
- **Severity if not met:** Medium

### CS-06 Production-safe settings and hardening
- **Applies to:** backend, monitoring, infrastructure, provisioning
- **Clause:** SAHD.1 (9.3.19), SAHD.3 (9.3.21)
- **Look for:** `DEBUG` off in production, narrow `ALLOWED_HOSTS`, secure cookies, no default admin credentials, SSH key-only access, database ports not exposed; unneeded services and apps removed from tablets and servers (file sharing, remote desktop, consumer apps, games); and a named hardening reference (e.g. CIS benchmark, OWASP, FDA or IMDRF guidance).
- **Met:** all of these with a named reference. **Partial:** some. **Gap:** debug or wide-open defaults.
- **Severity if not met:** High

### CS-07 Audit trail of patient-data and security events
- **Applies to:** backend, monitoring
- **Clause:** AUDT.2 (9.3.3)
- **Look for:** a record of who viewed, created, changed or deleted patient data and when, plus security events the guidance names: successful and failed sign-ins, sign-outs, account and role changes, use of admin rights, app start and stop, and changes to security settings. Also a written list of what is logged.
- **Met:** patient-data and security events logged with identity, and the list exists. **Partial:** one of the two, or timestamps without identity. **Gap:** none.
- **Severity if not met:** Medium

### CS-08 No patient data or secrets in logs or error messages
- **Applies to:** backend, monitoring, tablet-app
- **Clause:** AUDT.1 (9.3.2)
- **Look for:** logging calls that include names, RNs, IC numbers, dates of birth, whole request bodies, tokens or passwords, and error responses that echo internal detail. If logs must hold sensitive data, it should be masked, pseudonymised or encrypted.
- **Met:** none found. **Gap:** found. Report path and line only.
- **Severity if not met:** High

### CS-09 Sensitive data inventory and minimisation
- **Applies to:** all
- **Clause:** MSD.1 (9.3.1)
- **Look for:** a maintained list of every sensitive data item the system collects or sends, where it goes (server, Moniteer, backups, exports) and why it is needed. Also committed data files with patient-level data (`*.xlsx`, `*.csv`, fixtures, `.sqlite`): report path and file type only, never open rows. And copies that are not needed, such as full patient snapshots in Moniteer.
- **Met:** inventory exists, no patient-level data in repos, only needed data copied. **Partial:** no inventory but no unnecessary copies. **Gap:** patient data in a repo or unneeded copies.
- **Severity if not met:** High

### CS-10 Dependency scanning and software bill of materials
- **Applies to:** backend, tablet-app, monitoring
- **Clause:** SBOM.1 (9.3.18), CSUP.4 (8.3.3), RDMP.2 (9.3.15, software composition analysis)
- **Look for:** Dependabot or Renovate config, `pip-audit`, `npm audit`, CodeQL or Bandit in CI, and an SBOM covering all components including the OS and runtime, with author, timestamp, component name, version and licence for each.
- **Met:** scanning in CI plus a complete SBOM. **Partial:** scanning only, or an SBOM missing required fields. **Gap:** neither.
- **Severity if not met:** Medium

### CS-11 Secure update, approved software only, and rollback
- **Applies to:** backend, tablet-app, infrastructure, provisioning
- **Clause:** SAHD.2 (9.3.20), CSUP.3 (9.3.7), DTBK.2 (9.3.9)
- **Look for:** releases checked by hash or signature before install, an update path that only installs approved builds (signing, or user rights that block other installs, e.g. the kiosk shell), and the ability to restore the previous version and configuration.
- **Met:** all of these. **Partial:** rollback without verification of what is installed. **Gap:** manual unverified updates.
- **Severity if not met:** Medium

### CS-12 Vulnerability disclosure and security contact
- **Applies to:** all
- **Clause:** VDP.1 (8.3.1), section 5 (manufacturer contact details)
- **Look for:** `SECURITY.md` or an equivalent with a named security contact (name, email, phone), and a written process to receive vulnerability reports, tell affected hospitals, and propose fixes or workarounds. A data-breach procedure belongs here too.
- **Met:** contact and process present. **Partial:** contact only. **Gap:** none. Use `Outside repo` if the repo points to an external procedure.
- **Severity if not met:** High (Level 1 baseline)

### CS-13 No shared default passwords anywhere
- **Applies to:** all
- **Clause:** PAUT.3 (8.3.4)
- **Look for:** every login that exists when a tablet or server is first set up (app admin, Django admin, database users, tablet Windows accounts, SSH, Moniteer, Wi-Fi) and whether it is either unique and random per device or must be changed before the system can be used. Check setup scripts and IaC for one password shared across every hospital or tablet.
- **Met:** every initial credential is unique per device or forced to change before use. **Partial:** the app forces a change but OS, database or SSH credentials are shared. **Gap:** the same default credential is used across deployments.
- **Severity if not met:** High (Level 1 baseline)

### CS-14 Protection against password guessing on every login
- **Applies to:** backend, monitoring, infrastructure, provisioning
- **Clause:** PAUT.4 (8.3.5)
- **Look for:** lockout, delay or rate limits on every login interface: the tablet PIN sign-in, Django admin, Moniteer, SSH, and API keys. The guidance expects a written threshold and what happens when it is hit, and, for a delay-based limit, a calculation showing that guessing would take at least 100 days (a 6-digit PIN needs a lockout, not just a delay).
- **Met:** every interface protected, threshold documented. **Partial:** some interfaces, or no calculation. **Gap:** unlimited attempts on any interface.
- **Severity if not met:** High (Level 1 baseline)

### CS-15 Vulnerability monitoring and fix plan
- **Applies to:** all (usually a document, sometimes outside the repo)
- **Clause:** CSUP.1 (8.3.2), CSUP.4 (8.3.3)
- **Look for:** a written process naming the sources watched (CVE list, NVD, GitHub advisories), how the team checks whether INNUTRIRE is affected, a severity scale (critical, high, medium, low) with a threat and risk assessment for each confirmed issue, and a plan to build, test and ship fixes. Scanning tools alone (CS-10) are not enough.
- **Met:** process and plan written. **Partial:** scanning without a written triage and fix process. **Gap:** none.
- **Severity if not met:** High (Level 1 baseline)

### CS-16 Cybersecurity in the risk management process, with security testing
- **Applies to:** all
- **Clause:** RDMP.1 (8.3.6)
- **Look for:** security risks in the risk management plan and file, each with a control, and test evidence that the control works: a traceability table from security risk to control to test, a test method and results. Same evidence as RM-11 and SW-18; reuse it.
- **Met:** security risks traced to controls and tests. **Partial:** risks listed without tests, or tests without a risk link. **Gap:** none.
- **Severity if not met:** High (Level 1 baseline)

### CS-17 Secure development practices
- **Applies to:** backend, tablet-app, monitoring
- **Clause:** RDMP.2 (9.3.15)
- **Look for:** at least one activity in each area the guidance lists: development planning (version control, a secure build environment), requirements (threat model, written security requirements), architecture (least privilege, trust boundaries, secure defaults), implementation (secure coding rules, peer review, static analysis), third-party evaluation (software composition analysis, vendor track record), functional testing (unit and integration tests), and security testing (invalid and unexpected input tests, vulnerability scans, penetration tests). Also which published secure development framework, if any, is followed.
- **Met:** every area covered. **Partial:** some areas (e.g. review and tests but no threat model). **Gap:** none.
- **Severity if not met:** Medium

### CS-18 Data and configuration can be backed up and restored
- **Applies to:** backend, infrastructure, monitoring
- **Clause:** DTBK.1 (9.3.8), DTBK.2 (9.3.9)
- **Look for:** a way to back up patient data to separate storage, a backup of server and app configuration, and a documented restore. Same evidence as CI-12; reuse it.
- **Met:** data and configuration backups with restore steps. **Partial:** data only, or no restore steps. **Gap:** no backups.
- **Severity if not met:** Medium

### CS-19 Malware protection on tablets and servers
- **Applies to:** provisioning, infrastructure
- **Clause:** MLDP.1 (9.3.10)
- **Look for:** at least one malware control set up by the scripts: Microsoft Defender kept on and updated on tablets, an app allow-list or kiosk lock-down, secure boot, or intrusion detection on servers, plus a short reason why it is enough.
- **Met:** a control set up and explained. **Partial:** relies on OS defaults without checking they are on. **Gap:** scripts turn protection off or nothing is in place.
- **Severity if not met:** Medium

### CS-20 Network access limited to known devices
- **Applies to:** backend, infrastructure, provisioning, monitoring
- **Clause:** NAUT.1 (9.3.11)
- **Look for:** a server firewall that only allows the hospital's tablets and Moniteer, Tailscale access rules, and authentication between machines (e.g. the agent API key, certificates), with a reason why this keeps out other devices on the same network.
- **Met:** allow-listing plus machine authentication. **Partial:** one of the two. **Gap:** any device on the hospital network or tailnet can reach the API.
- **Severity if not met:** High

### CS-21 Communication channels, ports and local interfaces declared and minimised
- **Applies to:** backend, infrastructure, provisioning, monitoring
- **Clause:** CONN.1 (9.3.12), SAHD.4 (9.3.22), OTHR.3 (9.3.32)
- **Look for:** a list of every channel each device uses (Wi-Fi, Bluetooth, Ethernet, Tailscale) with its default on or off state; every open port on server and tablet with a reason (the guidance expects a full TCP and UDP port scan as evidence); and unused USB or card-reader ports disabled where they are not needed.
- **Met:** lists exist and unneeded ports and interfaces are closed. **Partial:** ports closed but not listed, or listed but not closed. **Gap:** neither.
- **Severity if not met:** Medium

### CS-22 Support period and third-party end-of-life plan
- **Applies to:** all (support statement usually outside the repo)
- **Clause:** RDMP.3 (9.3.16), RDMP.4 (9.3.17)
- **Look for:** a stated date until which each INNUTRIRE version is supported, shared with hospitals; and a process to track when third-party parts reach end of life or end of support (Python, Django, PySide6, Node, Windows on the tablets, the server OS), assess the impact and plan upgrades.
- **Met:** both. **Partial:** one. **Gap:** neither.
- **Severity if not met:** Medium

### CS-23 Security guide and update guide for hospitals
- **Applies to:** all (usually a document shipped to hospitals)
- **Clause:** SGUD.1 (9.3.23), SGUD.3 (9.3.25), CSUP.2 (9.3.6)
- **Look for:** a document for hospital IT on setting up and running INNUTRIRE securely (accounts and roles, network rules), a list of every built-in account (e.g. the built-in Administrator, service and database accounts), how hospitals are told an update is available and how it is installed, and the internal procedure INNUTRIRE staff follow when they install or update on site.
- **Met:** guide, account list and update procedure exist. **Partial:** internal setup notes only. **Gap:** none.
- **Severity if not met:** Medium

### CS-24 Patient data can be permanently deleted at decommissioning
- **Applies to:** backend, tablet-app, provisioning, infrastructure, monitoring
- **Clause:** SGUD.2 (9.3.24)
- **Look for:** a documented way to wipe all sensitive data when a tablet or server is retired or moved to another hospital: the tablet's local cache, the server database and backups, and Moniteer's copies, with instructions. Note that soft delete (needed for study records) is not permanent deletion, so the wipe is a separate decommissioning step.
- **Met:** wipe procedure for every store. **Partial:** some stores. **Gap:** none.
- **Severity if not met:** Medium

### CS-25 Remote access is authenticated and visible
- **Applies to:** infrastructure, provisioning, monitoring
- **Clause:** RMOT.1 (9.3.29), OTHR.1 (9.3.30)
- **Look for:** how INNUTRIRE staff reach hospital servers and tablets remotely (SSH over Tailscale, remote desktop), whether that requires strong authentication (keys plus MFA on the tailnet, or a documented identity check with the hospital), whether sessions are logged, and whether the hospital can see when a remote session is active.
- **Met:** strong authentication, logging and visibility. **Partial:** authentication without logging or visibility. **Gap:** shared or password-only remote access.
- **Severity if not met:** Medium

### CS-26 Declaration of conformity and target level
- **Applies to:** all (usually outside the repo)
- **Clause:** section 5, 8.2, 9.2, 10, 11
- **Look for:** a filled-in GMDC declaration (Yes / No / Not applicable with evidence for each provision) for the level INNUTRIRE targets, the manufacturer contact block, and, if Level 3 or 4 is targeted, a penetration test and software binary analysis report from a test lab.
- **Met:** declaration for the target level with evidence. **Partial:** target level chosen but declaration incomplete. **Gap:** none. **Outside repo** if kept elsewhere.
- **Severity if not met:** Low
