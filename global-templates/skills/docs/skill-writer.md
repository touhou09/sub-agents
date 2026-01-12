---
name: skill-writer
description: |
  Creates new skills when agents encounter repeated exceptions not covered by existing skills.
  Trigger: When the same exception pattern occurs 3+ times across agent executions.
  Used by: docs-writer
allowed-tools:
  - Read
  - Write
  - Grep
  - Glob
---

# Skill Writer

## Purpose

Automatically create new skills when agents encounter repeated edge cases or exceptions that existing skills don't handle.

## Trigger Condition

A new skill should be created when:
1. An agent encounters an exception/edge case not covered by existing skills
2. The same pattern occurs **3 or more times**
3. The pattern is generalizable (not project-specific)

## Workflow

### Step 1: Detect Pattern

Monitor for repeated exceptions:
```
Exception Log:
- [2024-01-10] data-engineer: Schema mismatch in CDC pipeline
- [2024-01-12] data-engineer: Schema mismatch in batch ingestion
- [2024-01-15] data-engineer: Schema mismatch in streaming → 3회 반복!
```

### Step 2: Analyze Pattern

Identify commonalities:
- Which agent(s) affected?
- What is the root cause?
- What solution was applied each time?
- Is it generalizable?

### Step 3: Create Skill

```markdown
---
name: <skill-name>
description: |
  <when to use this skill>
allowed-tools:
  - <required tools>
---

# <Skill Title>

## When to Apply
<trigger conditions>

## Workflow
<step-by-step solution>

## Examples
<concrete examples>
```

### Step 4: Register Skill

1. Write skill file to appropriate directory:
   - `dev-style/` - Development patterns
   - `architect/` - Design/architecture patterns
   - `docs/` - Documentation patterns
   - New category if needed

2. Update relevant agent(s) to reference the new skill

## Output Format

```markdown
## New Skill Created

### Trigger
3+ occurrences of: <pattern description>

### Skill Details
- Name: `<skill-name>`
- Path: `skills/<category>/<skill-name>.md`
- Used by: <agent(s)>

### Summary
<what the skill does>

### Agent Updates Required
- [ ] Update <agent>.md to include skill reference
```

## Examples

### Example: Schema Mismatch Handling

**Pattern detected (3 times):**
- Schema column mismatch during data ingestion

**Skill created:**
```
skills/architect/schema-migration.md
- Handles schema evolution during ingestion
- Provides backward compatibility patterns
- Added to data-engineer skill list
```

### Example: API Rate Limiting

**Pattern detected (4 times):**
- External API rate limit exceeded

**Skill created:**
```
skills/dev-style/rate-limit-handler.md
- Implements exponential backoff
- Adds retry logic with jitter
- Added to web-dev, data-engineer skill lists
```
