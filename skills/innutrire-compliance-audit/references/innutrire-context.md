# INNUTRIRE context

INNUTRIRE estimates the Resting Energy Expenditure (REE, in kcal) of ICU patients with a machine learning model and recommends an energy target adjusted for trauma or burns. Nurses and dietitians enter patient data on a bedside tablet. Gold-standard REE is measured with indirect calorimeters (GE Carescape, COSMED Q-NRG+) made by other manufacturers.

## Deployment models

- **LAN (live):** each hospital has its own server; the tablets talk to it over the hospital network. In use at 4 hospitals (SASMEC, HTAA, HRPZ, HSNZ). Moniteer reaches each server through a private Tailscale tunnel.
- **Standalone (in development):** everything runs on one tablet.
- **Cloud (in development):** tablets in many hospitals talk to one shared, multi-tenant cloud service.

## Field study

A clinical field study runs at the 4 hospitals with a target of 300 patients. Some data is collected on paper outside the system.

## Repos in scope

The audit covers exactly these five repos, all under `/Users/hakimnazry/coderepo/`. The checklists use the role names in their "Applies to" lines.

| Repo | Role | What it is | Safety-critical areas |
|---|---|---|---|
| `django_backend_innutrire` | `backend` | Django REST API on the hospital server: patients, ML inference, XAI, gold-standard records, `/api/agent/*` endpoints for Moniteer | `innutrire/util/ml_model_service.py` (feature preparation, unit handling, BMI and temperature classes), `innutrire/util/injury_factor.py`, `innutrire/api_views/prediction_views.py`, `innutrire/model/*` (deployed model file), `innutrire/data/*.xlsx` (training data: never open rows), `agent/` (patient data leaving the server) |
| `frontend_innutrire` | `tablet-app` | PySide6 tablet app, packaged with PyInstaller | `app/features/ree_calculation`, `app/features/predictive_equations`, `app/components/score_forms` (APACHE, SOFA, SAPS, NUTRIC), `app/components/keyboards` (numeric entry), `app/features/local_cache` (offline storage and sync), `app/features/add_new_patient`, `app/features/edit_patient`, `app/features/xai` |
| `moniteer` | `monitoring` | Django + React/Vite dashboard that monitors every deployment and stores daily data snapshots | `backend/auth`, `backend/patient_records`, `backend/prediction_records`, `backend/gold_standard_records` (copies of patient data), `backend/tablet_health`, `backend/server_health` |
| `tablet-setup-scripts` | `provisioning` | PowerShell scripts that set up a tablet (kiosk shell, Wi-Fi, SSH, static IP, app install) | `config.ps1` (known to contain credentials: never print values), `scripts/*.ps1` |
| `hospital-server-deployment-iac` | `infrastructure` | Ansible for hospital servers (Docker, firewall, tunnel) | `inventory*`, `playbooks/vars`, `roles/*` (firewall, SSH, secrets) |

`Regression_models_innutrire` (research notebooks and training experiments) is out of scope. Do not audit it.

## Where evidence usually lives

- **CI and release:** `.github/workflows/*` (backend: `ci.yml`, `deploy.yml`, `release.yml`, `promote.yml`, `pr-title.yml`; tablet app: `pr-checks.yml`, `release.yml`; Moniteer: `deploy.yml`), `CHANGELOG.md`, conventional-commit PR titles.
- **Tests:** backend `innutrire/tests/`, tablet app `tests/`.
- **Third-party software:** `requirements*.txt`, `pyproject.toml`, `uv.lock`, `package.json`, `package-lock.json`, `frontend_innutrire/licenses/`.
- **Problem tracking:** the Trello boards FE/BE, DevOps/Security and AI. These are outside the repo, so mark the status `Outside repo` unless the repo links to them.
- **Study and regulatory documents:** outside the repos (`~/Documents/INNUTRIRE-compliance/` holds summaries only). Ethics approvals, the study protocol and signed procedures are `Outside repo`.
- **Hardware:** Microsoft Surface tablets and ordinary servers; no INNUTRIRE-made hardware; no cable link to the calorimeters.
