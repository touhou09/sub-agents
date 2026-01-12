---
name: pr-review
description: |
  This skill should be used when the user asks to "review a PR", "check pull request",
  "PR review", "code review on GitHub", or mentions GitHub/GitLab pull request URLs.
  Provides comprehensive pull request review guidance.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Bash(gh:*)
  - Bash(git diff:*)
  - Bash(git log:*)
---

# PR Review Skill

Provide systematic pull request reviews following best practices.

## When to Use

Activate when:
- User shares a PR URL
- User asks to review changes before merging
- User mentions "PR review" or "pull request"

## Review Process

### 1. PR Context Analysis
```bash
# Get PR details
gh pr view <PR_NUMBER> --json title,body,files,commits

# Get changed files
gh pr diff <PR_NUMBER> --name-only

# Get full diff
gh pr diff <PR_NUMBER>
```

### 2. Code Change Review

Check for CLAUDE.md compliance and identify potential issues.

### 3. Review Categories

**Security**
- Input validation
- Authentication/authorization
- Sensitive data exposure
- SQL injection, XSS risks

**Performance**
- Algorithm complexity
- Database query efficiency
- Memory usage
- Unnecessary computations

**Maintainability**
- Code readability
- Proper naming
- Documentation
- Test coverage

### 4. Output Format

Provide structured feedback:

```markdown
## Summary
[One-line overall assessment]

## Approved: [Yes/No/Changes Requested]

## Critical Issues (Must Fix)
- **File**: path/to/file.js:123
  - **Issue**: [Description]
  - **Fix**: [Suggested solution]

## Suggestions (Nice to Have)
- ...

## Questions
- ...
```

## Commands Reference

```bash
# Fetch PR details
gh pr view <number>

# Get diff
gh pr diff <number>

# Add comment
gh pr comment <number> --body "comment"

# Request changes
gh pr review <number> --request-changes --body "feedback"

# Approve
gh pr review <number> --approve --body "LGTM"

# List PR files
gh pr diff <number> --name-only
```

## Checklist

- [ ] All tests pass
- [ ] No security vulnerabilities
- [ ] No performance regressions
- [ ] Code follows project conventions
- [ ] Documentation updated if needed
- [ ] No TODO/FIXME in critical paths
