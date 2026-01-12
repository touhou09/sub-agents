---
name: context-summary
description: |
  Documents progress before context auto-compaction to preserve important state.
  Trigger: Before context window limit is reached, or on explicit request.
  Used by: docs-writer
allowed-tools:
  - Read
  - Write
  - Glob
---

# Context Summary

## Purpose

Create a progress document before context auto-compaction to ensure:
1. Current work state is preserved
2. Next session can continue seamlessly
3. Important decisions/context are not lost

## Trigger Conditions

Create summary when:
1. Context approaching limit (proactive)
2. Complex multi-step task in progress
3. User explicitly requests `/summarize` or "정리해줘"
4. Before ending a long session

## Workflow

### Step 1: Gather Current State

Collect information:
- What task is being worked on?
- What has been completed?
- What is in progress?
- What is remaining?
- Any blockers or decisions needed?

### Step 2: Write Summary Document

Create `.claude/context-summary.md` or update existing:

```markdown
# Context Summary

**Updated**: <timestamp>
**Task**: <main task description>

## Completed
- [x] <completed item 1>
- [x] <completed item 2>

## In Progress
- [ ] <current work> ← Currently here
  - Sub-task status
  - Relevant file: `path/to/file.py:123`

## Remaining
- [ ] <pending item 1>
- [ ] <pending item 2>

## Key Decisions Made
- Decision 1: <what was decided and why>
- Decision 2: <what was decided and why>

## Important Context
- <critical information that must not be lost>
- <file paths, variable names, API endpoints>

## Blockers / Open Questions
- <any unresolved issues>

## Resume Instructions
To continue this work:
1. <step 1>
2. <step 2>
```

### Step 3: Notify User

```
## Context Summary Created

Saved to: `.claude/context-summary.md`

### Current Status
- Completed: 3/7 tasks
- In Progress: API endpoint implementation
- Remaining: 4 tasks

Summary preserved for next session.
```

## Output Format

### Summary Structure

```markdown
# Context Summary - <Task Name>

**Session**: <date/time>
**Status**: <% complete>

## TL;DR
<1-2 sentence summary of current state>

## Progress
<detailed progress tracking>

## Critical Context
<must-know information for continuation>

## Next Steps
<clear action items for next session>
```

## Examples

### Example: Feature Implementation

```markdown
# Context Summary - User Authentication Feature

**Updated**: 2024-01-15 14:30
**Status**: 60% complete

## TL;DR
JWT authentication implemented, working on refresh token logic.

## Completed
- [x] User model and schema
- [x] Login endpoint
- [x] JWT token generation

## In Progress
- [ ] Refresh token implementation
  - Created `src/auth/refresh.py`
  - Need to add token rotation logic

## Remaining
- [ ] Logout endpoint
- [ ] Password reset flow

## Key Decisions
- Using RS256 for JWT signing (more secure)
- Refresh token valid for 7 days

## Resume Instructions
1. Open `src/auth/refresh.py:45`
2. Implement `rotate_refresh_token()` function
3. Add endpoint in `routes.py`
```

### Example: Bug Investigation

```markdown
# Context Summary - Memory Leak Investigation

**Updated**: 2024-01-15 16:00
**Status**: Investigating

## TL;DR
Found memory leak in data processing loop, testing fix.

## Findings
- Leak in `src/pipeline/processor.py:234`
- DataFrame not released after processing
- Occurs with batches > 10k rows

## Attempted Fixes
1. ❌ `del df` - Still leaks
2. ❌ `gc.collect()` - Marginal improvement
3. ✓ `df = None` + `gc.collect()` - Testing

## Next Steps
1. Run memory profiler with fix
2. If resolved, add to all batch processors
```
