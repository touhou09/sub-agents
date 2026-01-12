---
name: custom-workflow
description: |
  Template for project-specific skill. Use this as a starting point for
  creating custom workflows unique to your project.
allowed-tools:
  - Read
  - Write
  - Grep
  - Glob
---

# Custom Workflow Skill Template

This is a template for creating project-specific skills.

## When to Use

Define when this skill should be activated:
- Specific keywords or phrases
- Types of tasks
- Contexts or situations

## Workflow Steps

### Step 1: [Name]
Description of what to do in this step.

```bash
# Example command
echo "Step 1"
```

### Step 2: [Name]
Description of what to do in this step.

```bash
# Example command
echo "Step 2"
```

### Step 3: [Name]
Description of what to do in this step.

```bash
# Example command
echo "Step 3"
```

## Configuration

Document any configuration needed:
- Environment variables
- Config files
- Dependencies

## Examples

### Example 1: [Scenario]
```
User: [User request]
Action: [What the skill does]
Result: [Expected outcome]
```

### Example 2: [Scenario]
```
User: [User request]
Action: [What the skill does]
Result: [Expected outcome]
```

## Customization

To create a specialized skill for your project:

1. Copy this directory with a new name
2. Update the `name` and `description` in SKILL.md frontmatter
3. Define the workflow steps
4. Add examples
5. Update allowed-tools as needed
