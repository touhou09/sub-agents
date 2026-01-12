---
name: skill-writer
description: |
  Updates existing skills when agents encounter repeated exceptions or edge cases.
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

Update existing SKILL.md files to handle repeated edge cases or exceptions that current skill workflows don't cover.

## Trigger Condition

An existing skill should be updated when:
1. An agent encounters an exception/edge case during skill execution
2. The same pattern occurs **3 or more times**
3. The pattern is generalizable (not project-specific)

## Workflow

### Step 1: Detect Pattern

Monitor for repeated exceptions:
```
Exception Log:
- [2024-01-10] data-engineer: Schema mismatch in CDC pipeline (using schema-design)
- [2024-01-12] data-engineer: Schema mismatch in batch ingestion (using schema-design)
- [2024-01-15] data-engineer: Schema mismatch in streaming (using schema-design) → 3회 반복!
```

### Step 2: Identify Target Skill

Find the most relevant existing skill:
1. Check which skill was active when exception occurred
2. Search skills for related keywords
3. Identify the skill that should handle this case

```bash
# Search existing skills
grep -r "schema" skills/
# Result: skills/architect/schema-design/SKILL.md
```

### Step 3: Analyze Gap

Compare current skill with needed behavior:
- What does the skill currently handle?
- What edge case is missing?
- How should the workflow be extended?

### Step 4: Update Skill

Modify the existing SKILL.md:

1. **Add new trigger condition** (if needed)
   ```markdown
   ## When to Apply
   - Existing triggers...
   - NEW: Schema mismatch during CDC/streaming ingestion
   ```

2. **Extend workflow** (add new step or branch)
   ```markdown
   ## Workflow
   ### Step N: Handle Schema Mismatch
   - Detect column differences
   - Apply safe migration strategy
   - Validate backward compatibility
   ```

3. **Add example** (document the new case)
   ```markdown
   ## Examples
   ### Schema Mismatch in Streaming
   ...
   ```

### Step 5: Verify Update

1. Read the updated SKILL.md
2. Confirm the new case is covered
3. Check workflow consistency

## Output Format

```markdown
## Skill Updated

### Trigger
3+ occurrences of: <pattern description>

### Updated Skill
- Path: `skills/<category>/<skill-name>/SKILL.md`
- Used by: <agent(s)>

### Changes Made
1. Added trigger: <new trigger condition>
2. Extended workflow: <new step description>
3. Added example: <example title>

### Diff Summary
- Lines added: N
- Sections modified: <section names>
```

## Examples

### Example: Schema Evolution Handling

**Pattern detected (3 times):**
- Schema column mismatch during data ingestion

**Skill updated:** `skills/architect/schema-design/SKILL.md`
```markdown
Changes:
1. Added "Schema Mismatch Detection" to triggers
2. Added Step 5: "Handle Runtime Schema Changes"
3. Added example: "CDC Schema Evolution"
```

### Example: Rate Limit in API Calls

**Pattern detected (4 times):**
- External API rate limit exceeded

**Skill updated:** `skills/dev-style/perf-optimize/SKILL.md`
```markdown
Changes:
1. Added "API Rate Limiting" to triggers
2. Added Step: "Implement Backoff Strategy"
3. Added example: "External API Rate Limiting"
```

## When to Create New Skill

Only create a NEW skill when:
1. No existing skill is remotely related
2. The pattern requires a completely different workflow
3. Adding to existing skill would make it too complex

In most cases, extending an existing skill is preferred.
