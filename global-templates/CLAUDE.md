# Global Claude Code Instructions

Copy this file to `~/.claude/CLAUDE.md` to apply across all projects.

---

## Default Behavior

- Respond to user in Korean, use English internally
- Prioritize code quality and stability
- Prefer concise and clear explanations
- Avoid unnecessary comments or documentation

## Code Style

- Indentation: 2 spaces (JavaScript/TypeScript), 4 spaces (Python, Rust)
- Type safety: TypeScript strict mode, Python type hints
- Functions follow single responsibility principle
- Use clear and meaningful variable names

---

## Agent Selection Guide

**IMPORTANT: Use specialized agents for better results.**

### When to Use Each Agent

| Trigger Keywords | Agent | Model |
|------------------|-------|-------|
| "test", "commit", "PR", "review", "debug" | `reviewer` | haiku |
| "data pipeline", "ETL", "Polars", "Arrow", "schema" | `data-engineer` | opus |
| "React", "FastAPI", "frontend", "backend", "API" | `web-dev` | opus |
| "docker", "k8s", "deploy", "MCP 설정", "DB 연결" | `devops` | haiku |
| "document", "README", "PDF", "Word", "Excel" | `docs-writer` | haiku |
| "explain", "where is", "architecture", "brainstorm" | `general-helper` | opus |

### Skill-Based Workflow

Agents should apply skills based on task keywords:

| Task Keywords | Apply Skill |
|---------------|-------------|
| "new", "implement", "create", "build" | `tdd` |
| "slow", "optimize", "performance" | `perf-optimize` |
| "schema", "table", "model", "design" | `schema-design` |
| "plan", "architecture", "roadmap" | `writing-plans` |
| "debug", "root cause", "why failing" | `systematic-debugging` |
| "commit", "push" | `pre-commit` |

### Memory Bank Usage

For long-running projects, use `.context/` directory:
- `activeContext.md` - Current focus and next steps
- `progress.md` - Task completion percentages
- `decisionLog.md` - Architectural decisions

---

## Role Profiles

### Data Engineer Mode
For data engineering tasks:
- Idempotency first
- Consider data lineage tracking
- Include data quality validation
- Define rollback strategy for pipelines

### Fullstack Developer Mode
For web development tasks:
- Prefer rapid prototyping
- User experience focused design
- Consider accessibility (a11y)
- Responsive design by default

### DevOps Mode
For infrastructure/deployment tasks:
- Infrastructure as Code principles
- Security first (least privilege)
- Always include monitoring/alerting
- Rollback plan required

---

## Preferred Tools/Frameworks

| Category | Tools |
|----------|-------|
| Frontend | React, Next.js, TypeScript |
| Backend | Python, FastAPI |
| Database | PostgreSQL, Redis, ClickHouse |
| DevOps | Docker, Kubernetes, Terraform |
| Data | Polars, Delta Lake, Apache Arrow (Rust + Python) |
| Cloud | AWS (CDK), GCP (gcloud) |
| Testing | Playwright, pytest, Vitest |
