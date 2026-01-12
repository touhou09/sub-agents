# Project Guidelines

## Project Overview

<!-- Describe your project here -->

## Directory Structure

```
.claude/
├── settings.json           # Project shared settings (commit this)
├── settings.local.json     # Local settings (gitignored)
├── agents/                 # Project-specific agents
└── skills/                 # Project-specific skills

.mcp.json                   # Project MCP servers
```

## Coding Conventions

<!-- Add project-specific coding conventions here -->

### General
- Use meaningful variable names
- Keep functions small and focused
- Write tests for new features

### Naming
- Files: kebab-case
- Classes: PascalCase
- Functions/Variables: camelCase (JS/TS), snake_case (Python)

---

## Available Global Agents

| Agent | Purpose | Model |
|-------|---------|-------|
| `reviewer` | Testing, git management, log monitoring | haiku |
| `data-engineer` | Data pipeline, ETL, Polars/Arrow | opus |
| `web-dev` | Frontend (React), Backend (FastAPI) | opus |
| `devops` | Docker, K8s, deployment, monitoring | haiku |
| `docs-writer` | Documentation, API docs, README | haiku |
| `general-helper` | Codebase exploration, Q&A | opus |

## Available Global Skills

| Skill | Purpose | Used by |
|-------|---------|---------|
| `pre-commit` | Type check, lint, test before commit | reviewer |
| `tdd` | TDD-based development workflow | data-engineer, web-dev |
| `perf-optimize` | Performance optimization | data-engineer, web-dev |
| `schema-design` | Schema design and validation | data-engineer, web-dev |
| `skill-writer` | Update skills for repeated exceptions | docs-writer |
| `context-summary` | Document progress before context compact | docs-writer |

---

## Usage Examples

```
Run tests and commit              # reviewer + pre-commit
Create a data pipeline            # data-engineer + tdd, schema-design
Build a user registration form    # web-dev + tdd, schema-design
This query is slow                # data-engineer + perf-optimize
Setup docker-compose              # devops
Where is authentication handled?  # general-helper
Document this module              # docs-writer
```

---

## Project-Specific Customization

### Adding Project Agent

Create `.claude/agents/<name>.md`:
```markdown
---
name: my-project-agent
description: |
  When to use this agent...
model: sonnet
tools:
  - Read
  - Write
  - Grep
---

# Agent instructions here
```

### Adding Project Skill

Create `.claude/skills/<name>/SKILL.md`:
```markdown
---
name: my-skill
description: |
  When to activate...
allowed-tools:
  - Read
  - Grep
---

# Skill workflow here
```

---

## Environment Variables

Required for certain features (set in `.claude/settings.local.json`):

| Variable | Purpose |
|----------|---------|
| `DATABASE_URL` | PostgreSQL connection |
| `REDIS_URL` | Redis connection |
| `SENTRY_AUTH_TOKEN` | Sentry API |
| `GITHUB_TOKEN` | GitHub API |
