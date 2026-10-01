# SETUP_AND_ENVIRONMENT
How to run/dev/test locally; required for onboarding.
> Step-by-step guide to set up the project locally and run it consistently.
>
> Goal: make onboarding fast and reproducible across machines.

---

## 1) Supported platforms

- OS: (macOS/Linux/Windows)
- CPU: (x86_64/arm64)
- Shell: (bash/zsh/powershell)

## 2) Prerequisites

### Required
- Language/runtime: (e.g., Python 3.12)
- Package manager: (e.g., uv/poetry/pip)
- Git

### Optional (recommended)
- Docker
- Make
- Pre-commit

## 3) Repository layout (quick orientation)

- `/README.md` — high-level overview
- `/Tutorial/GETTING_STARTED.md` — first steps
- `/Guidelines/` — non-negotiable rules

## 4) Setup steps (local)

### 4.1 Clone
```bash
git clone <repo_url>
cd <repo>
```

### 4.2 Create environment

Choose one method and standardize it.

#### Option A: Virtual environment
```bash
python -m venv .venv
source .venv/bin/activate
```

#### Option B: Conda
```bash
conda create -n <env> python=<version>
conda activate <env>
```

### 4.3 Install dependencies
```bash
# example
default_install_command_here
```

### 4.4 Configure environment variables

- Create `.env` from `.env.example` (do not commit secrets).
- Required env vars:
  - `VAR_1=`
  - `VAR_2=`

Link to: `/Guidelines/SECURITY_STANDARDS.md`.

### 4.5 Verify setup

Run:
```bash
# example
make test
```

Expected output:
- (what “success” looks like)

---

## 5) Running the project

### Development
```bash
# example
make run
```

### Production-like run
```bash
# example
make run-prod
```

---

## 6) Tooling

### Formatting and linting
- Formatter:
- Linter:
- Type checker:

Commands:
```bash
# example
make lint
make format
make typecheck
```

Link to: `/Guidelines/CODING_STANDARDS.md`.

### Pre-commit hooks (recommended)
```bash
pre-commit install
```

---

## 7) Testing locally

### Unit tests
```bash
# example
make test-unit
```

### Integration tests
```bash
# example
make test-integration
```

### End-to-end tests
```bash
# example
make test-e2e
```

Link to: `/Guidelines/TESTING_STANDARDS.md`.

---

## 8) Optional: Docker environment

If the project uses containers:

### Build
```bash
docker build -t <image> .
```

### Run
```bash
docker run --env-file .env <image>
```

### Compose
```bash
docker compose up
```

---

## 9) Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| Dependency install fails | Version mismatch | Pin versions / recreate env |
| Tests fail on first run | Missing env vars | Copy `.env.example` |
| Permission errors | File perms | Fix ownership / chmod |

---

## 10) Environment “contracts” (consistency rules)

- Do not rely on globally installed packages.
- Keep dependency versions pinned.
- Reproducible installs are mandatory.
- Secrets never committed.

---

## 11) Links

- Build and deploy: `/Documentations/BUILD_AND_DEPLOY.md`
- Dependency management: `/Documentations/DEPENDENCY_MANAGEMENT.md`
- Security standards: `/Guidelines/SECURITY_STANDARDS.md`
