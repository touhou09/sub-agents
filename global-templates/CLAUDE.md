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

## Preferred Tools/Frameworks

| Category | Tools |
|----------|-------|
| Frontend | React, Next.js, TypeScript |
| Backend | Python, FastAPI |
| Database | PostgreSQL, Redis, ClickHouse |
| DevOps | Docker, Kubernetes, Terraform |
| Data | Polars, Delta Lake, Apache Arrow (Rust + Python) |
