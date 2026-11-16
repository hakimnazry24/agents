# GDHP — Cybersecurity guidance (key CS)

**In plain words:** voluntary guidance from the Global Digital Health Partnership (a group of governments) on keeping digital health systems and medical devices safe from attack, including its 2024 Guidance for Medical Device Cybersecurity (GMDC). It is guidance, not a formal standard, so the items below are grouped by topic rather than by clause.

---

### CS-01 No secrets in the repository
- **Applies to:** all
- **Topic:** secure configuration
- **Look for:** hard-coded `SECRET_KEY`, passwords, tokens, API keys and private keys in tracked files (`git ls-files` + grep for `password`, `secret`, `token`, `ghp_`, `BEGIN .* PRIVATE KEY`, `PAT`). Also look for committed `.env` files. Report path and line only; redact values.
- **Met:** none found; `.env.example` holds placeholders only. **Gap:** any secret found.
- **Severity if not met:** High

### CS-02 Authentication on every interface carrying patient data
- **Applies to:** backend, monitoring, tablet-app
- **Topic:** access control
- **Look for:** login, token or API-key checks on views, decorators, middleware and DRF permission classes. Pay particular attention to the `agent/` endpoints and the Moniteer snapshot endpoints.
- **Met:** every patient-data endpoint requires authentication. **Partial:** some do. **Gap:** open endpoints serve patient data.
- **Severity if not met:** High

### CS-03 Role-based access and personal accounts
- **Applies to:** backend, monitoring, tablet-app
- **Topic:** access control
- **Look for:** personal user accounts (not shared logins), roles and permissions.
- **Met:** personal accounts with roles. **Partial:** accounts without roles. **Gap:** shared or no accounts.
- **Severity if not met:** Medium

### CS-04 Encryption in transit
- **Applies to:** backend, tablet-app, monitoring, infrastructure
- **Topic:** data protection
- **Look for:** HTTPS or TLS between the tablet and the server, and between the server and Moniteer: `https://` base URLs, a TLS proxy (nginx or Caddy) in the IaC or compose files, and Django `SECURE_*` settings.
- **Met:** TLS on every link. **Partial:** some links rely only on the tunnel. **Gap:** plain HTTP on the hospital network.
- **Severity if not met:** High

### CS-05 Encryption at rest for patient data
- **Applies to:** backend, monitoring, tablet-app, infrastructure
- **Topic:** data protection
- **Look for:** database or disk encryption, an encrypted local cache on the tablet (`app/features/local_cache`), and encrypted backups.
- **Met:** encrypted. **Partial:** some stores. **Gap:** plain-text stores.
- **Severity if not met:** Medium

### CS-06 Production-safe settings
- **Applies to:** backend, monitoring, infrastructure
- **Topic:** secure configuration
- **Look for:** `DEBUG` off in production, a narrow `ALLOWED_HOSTS`, secure cookies, no default admin credentials, SSH key-only access, a firewall that covers the app ports, and database ports not exposed.
- **Met:** all of these. **Partial:** some. **Gap:** debug or wide-open defaults.
- **Severity if not met:** High

### CS-07 Audit trail
- **Applies to:** backend, monitoring
- **Topic:** logging and accountability
- **Look for:** a record of who viewed, created, changed or deleted patient data and when: audit model or middleware, `django-simple-history`, `auditlog`.
- **Met:** an audit trail with user identity. **Partial:** timestamps without identity. **Gap:** none.
- **Severity if not met:** Medium

### CS-08 No patient data in logs or error messages
- **Applies to:** backend, monitoring, tablet-app
- **Topic:** data minimisation
- **Look for:** logging calls that include names, RNs, dates of birth or whole request bodies, and error responses that echo internal detail.
- **Met:** none. **Gap:** found. Report path and line only.
- **Severity if not met:** High

### CS-09 Data minimisation and patient data in the repo
- **Applies to:** all
- **Topic:** data minimisation
- **Look for:** committed data files containing patient-level data (`*.xlsx`, `*.csv`, fixtures, `.sqlite`). Report path and file type only; do not open rows. Also check whether copies of patient data are made that aren't needed, such as full snapshots in Moniteer.
- **Met:** no patient-level data in the repo; only the data that is needed is copied. **Gap:** found.
- **Severity if not met:** High

### CS-10 Dependency and vulnerability scanning
- **Applies to:** backend, tablet-app, monitoring
- **Topic:** vulnerability management
- **Look for:** Dependabot or Renovate config, `pip-audit`, `npm audit`, CodeQL or Bandit in CI, and a software bill of materials (SBOM).
- **Met:** scanning in CI plus SBOM. **Partial:** scanning only. **Gap:** none.
- **Severity if not met:** Medium

### CS-11 Secure update and rollback
- **Applies to:** backend, tablet-app, infrastructure, provisioning
- **Topic:** patching
- **Look for:** signed or checksummed releases, an update path that is authenticated, and automatic rollback.
- **Met:** all of these. **Partial:** rollback without verification of what is installed. **Gap:** manual unverified updates.
- **Severity if not met:** Medium

### CS-12 Incident response and security contact
- **Applies to:** all
- **Topic:** incident response
- **Look for:** `SECURITY.md`, a documented procedure for a security incident or data breach, and contact details.
- **Met:** present. **Gap:** none. Use `Outside repo` if the repo points to an external procedure.
- **Severity if not met:** Low
