---
name: pre-commit
description: |
  Run quality checks before git commit. Executes type checking, linting, and tests
  based on detected languages. Reports errors or commits to feature branch on success.
  Trigger: "pre-commit", "commit check", "quality check before commit"
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash(git:*)
  - Bash(gh:*)
  - Bash(tsc:*)
  - Bash(eslint:*)
  - Bash(npm test:*)
  - Bash(mypy:*)
  - Bash(ruff:*)
  - Bash(pytest:*)
  - Bash(cargo:*)
---

# Pre-commit Quality Check

## Workflow

### Step 1: Detect Languages
Check changed files to detect languages:
```bash
git diff --cached --name-only
git diff --name-only
```

| Extension | Language |
|-----------|----------|
| `.ts`, `.tsx`, `.js`, `.jsx` | TypeScript/JavaScript |
| `.py` | Python |
| `.rs` | Rust |

### Step 2: Run Quality Checks

#### TypeScript/JavaScript
```bash
npx tsc --noEmit          # Type check
npx eslint . --ext .ts,.tsx,.js,.jsx  # Lint
npm test                   # Tests
```

#### Python
```bash
mypy .                     # Type check
ruff check .               # Lint
pytest                     # Tests
```

#### Rust
```bash
cargo check                # Compile check
cargo clippy -- -D warnings  # Lint
cargo test                 # Tests
```

### Step 3: Process Results

#### On Failure
Report errors in structured format:

```markdown
## Pre-commit Check Failed

### Type Errors
- file:line - error message

### Lint Errors
- file:line - rule: message

### Test Failures
- test_name - assertion message

Fix these issues before committing.
```

#### On Success
1. Create feature branch (if not exists):
   ```bash
   git checkout -b feat/<feature-name>
   # or
   git checkout -b fix/<bug-name>
   ```

2. Stage and commit:
   ```bash
   git add -A
   git commit -m "<type>: <subject>"
   ```

3. Push to remote:
   ```bash
   git push -u origin <branch-name>
   ```

## Commit Message Format

```
<type>: <subject>

<body (optional)>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `docs`: Documentation
- `test`: Test changes
- `chore`: Maintenance

## Branch Naming

| Type | Branch Pattern | Example |
|------|----------------|---------|
| Feature | `feat/<name>` | `feat/user-auth` |
| Bug fix | `fix/<name>` | `fix/login-error` |
| Refactor | `refactor/<name>` | `refactor/api-client` |

## Rules

- Never push directly to `main` or `master`
- Always create feature branch first
- Run all checks before committing
- Include meaningful commit messages
