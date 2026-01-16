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

## Mandatory Skill Application

**All agents MUST apply these skills when conditions are met.**

### Universal Skills (Apply Regardless of Agent)

| Condition | Skill | Action |
|-----------|-------|--------|
| Writing ANY new code | `tdd` | Write test → Implement → Refactor |
| Task completion | `verification-before-completion` | Verify fix works before marking done |
| Debug/failure | `systematic-debugging` | 4-phase root cause analysis |
| Long-running project | `memory-bank` | Update .context/ files |
| Context limit approaching | `context-summary` | Summarize before compaction |
| Before commit/push | `pre-commit` | Run quality checks |

### Enforcement Rule

```
Before completing ANY task:
1. Check if task matches skill triggers above
2. If match → Apply the skill workflow
3. State which skill(s) were applied in output
4. If no skill applied → Explicitly state "No skill triggers matched"
```

### Output Format (All Agents)

Every response involving code changes MUST include:

```
### Applied Skills
- [x] tdd - writing new function
- [x] verification-before-completion - confirmed tests pass
- [ ] No skill triggers matched (if applicable)
```

---

## Skill Evolution

**When the same exception/edge case occurs 3+ times, create or update a skill.**

### Trigger Condition

1. Agent encounters an exception or edge case
2. Same pattern repeats **3 or more times**
3. Pattern is generalizable (not project-specific)

### Decision: Update vs Create

| Condition | Action | Use Skill |
|-----------|--------|-----------|
| Related skill exists | Update existing skill | `skill-writer` |
| No related skill | Create new skill | `skill-creator` |

### Category Placement

Place new skills in the appropriate category folder:

| Category | Path | When to Use |
|----------|------|-------------|
| `testing/` | Testing, QA, debugging patterns |
| `git/` | Git workflow, code review patterns |
| `development/` | Coding patterns, optimization, design |
| `planning/` | Planning, collaboration, brainstorming |
| `agents/` | Agent orchestration, parallel execution |
| `devops/` | Infrastructure, deployment, MCP |
| `docs/` | Documentation, skill management |
| `office/` | Document generation (docx, pdf, pptx, xlsx) |
| `design/` | Visual design, art generation |

### Workflow

```
1. Detect: Same exception 3+ times
2. Decide: skill-writer (update) or skill-creator (new)
3. Locate: Find correct category folder
4. Execute:
   - Update: Add new trigger/workflow/example to existing SKILL.md
   - Create: Run init_skill.py, fill SKILL.md template
5. Verify: Test the updated/new skill handles the case
```

### Example

```
Exception: "Schema mismatch in CDC pipeline" (3rd occurrence)

→ Related skill exists: development/schema-design
→ Action: Apply skill-writer
→ Update: Add "CDC Schema Evolution" section to SKILL.md
```

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
