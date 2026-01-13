---
name: memory-bank
description: |
  Maintain project memory across sessions with activeContext, progress, and decisionLog.
  Trigger on: session start, before context compaction, "save progress", "update context",
  "what did we do", "where were we", "resume", "세션 시작", "진행 상황 저장".
allowed-tools:
  - Read
  - Write
  - Glob
---

# Memory Bank Skill

## Purpose

Maintain persistent project memory across Claude sessions by managing three core files:

1. **activeContext.md** - Current working context and focus areas
2. **progress.md** - Task completion status with percentages
3. **decisionLog.md** - Architectural and design decisions made

## File Locations

```
.context/                    # Project-level memory
├── activeContext.md
├── progress.md
└── decisionLog.md
```

## Workflow

### On Session Start

1. Check if `.context/` directory exists
2. If exists, read all three files
3. Summarize current state to user
4. Ask if they want to continue or start fresh

### During Session

1. Update `progress.md` when tasks complete
2. Update `decisionLog.md` for important decisions
3. Update `activeContext.md` for context changes

### Before Context Compaction

1. Update all three files with current state
2. Ensure progress percentages are accurate
3. Log any pending decisions

### On Session End

1. Update all files with final state
2. Note next steps in `activeContext.md`

## File Templates

### activeContext.md
```markdown
# Active Context

## Current Focus
<!-- What we're working on right now -->

## Key Files
<!-- Most relevant files for current work -->
- path/to/file.ts - description

## Open Questions
<!-- Unresolved questions or blockers -->

## Next Steps
<!-- What to do next session -->

---
*Last updated: YYYY-MM-DD HH:mm*
```

### progress.md
```markdown
# Project Progress

## Current Sprint/Phase
**Overall: XX%**

### Completed ✅
- [x] Task 1 (100%)
- [x] Task 2 (100%)

### In Progress 🔄
- [ ] Task 3 (60%) - notes on current state
- [ ] Task 4 (20%) - blockers if any

### Pending ⏳
- [ ] Task 5 (0%)
- [ ] Task 6 (0%)

---
*Last updated: YYYY-MM-DD HH:mm*
```

### decisionLog.md
```markdown
# Decision Log

## YYYY-MM-DD: Decision Title

### Context
Why this decision was needed.

### Options Considered
1. **Option A** - pros/cons
2. **Option B** - pros/cons

### Decision
What we chose and why.

### Consequences
Expected impact of this decision.

---
```

## Commands

### Initialize Memory Bank
```
User: "Initialize memory bank" or "메모리 뱅크 초기화"

1. Create .context/ directory
2. Create empty templates
3. Ask for initial context
```

### Update Progress
```
User: "Update progress" or "진행 상황 업데이트"

1. Read current progress.md
2. Ask what changed
3. Update percentages
4. Save with timestamp
```

### Log Decision
```
User: "Log decision" or "결정 기록"

1. Ask for decision details
2. Append to decisionLog.md
3. Update activeContext.md if needed
```

### Resume Session
```
User: "Resume" or "이어서"

1. Read all three files
2. Summarize current state
3. Ask where to continue
```

## Integration with Agents

All agents should:
1. Check for `.context/` on task start
2. Update `progress.md` on task completion
3. Log architectural decisions to `decisionLog.md`
4. Reference `activeContext.md` for context

## Token Efficiency

The Memory Bank helps with context window management:
- Before compaction, save critical context
- After compaction, reload from Memory Bank
- Prune old decisions (keep last 20)
- Archive completed tasks monthly

## Output Format

```
## Memory Bank Status

### Active Context
[Summary of activeContext.md]

### Progress
Overall: XX%
- Completed: N tasks
- In Progress: M tasks
- Pending: K tasks

### Recent Decisions
- [Date] Decision 1
- [Date] Decision 2

### Recommended Action
[What to do next based on context]
```
