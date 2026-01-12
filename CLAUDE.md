# Project Guidelines

## Overview

This repository contains Claude Code templates for sub-agents, skills, and MCP configurations.

## Directory Structure

```
.claude/
├── settings.json           # Project shared settings
├── settings.local.json     # Local settings (gitignored)
├── agents/                 # Project-specific agents
└── skills/                 # Project-specific skills

mcp-templates/              # MCP server configuration templates
├── github.json
├── gitlab.json
├── database.json
├── monitoring.json
└── generic.json

.mcp.json                   # Project MCP servers
```

## Coding Conventions

### Agent Files (.md)
- Use YAML frontmatter for metadata
- Include clear `description` for when to use
- Specify allowed `tools`
- Document the agent's responsibilities

### Skill Files (SKILL.md)
- Place in `skills/<skill-name>/SKILL.md`
- Include `allowed-tools` in frontmatter
- Document when the skill activates
- Provide clear workflow steps

### MCP Configuration
- Use environment variables for secrets: `${VAR_NAME}`
- Document required environment variables
- Prefer project-scoped MCP for team sharing

## Available Global Agents

| Agent | Purpose |
|-------|---------|
| code-reviewer | Code review and PR checks |
| data-engineer | Data pipelines, ETL, SQL optimization |
| devops | Infrastructure, CI/CD, monitoring |
| webapp-dev | Web application development |
| general-helper | General programming assistance |

## Available Global Skills

| Skill | Purpose |
|-------|---------|
| pr-review | Pull request review workflow |
| data-validation | Data quality checks |
| deploy-check | Deployment readiness validation |
| security-scan | Security vulnerability scanning |
| sql-optimize | SQL query optimization |

## Usage

### Using Agents
Agents are automatically selected based on the task. You can also explicitly request:
```
Use the code-reviewer agent to check my changes
```

### Using Skills
Skills activate based on keywords in your request:
```
Review PR #123
Validate this dataset
Check if we're ready to deploy
Scan for security issues
Optimize this SQL query
```

### Adding MCP Servers
```bash
# Add GitHub MCP
claude mcp add --transport http --scope project github https://api.githubcopilot.com/mcp/

# Add PostgreSQL MCP
claude mcp add --transport stdio --scope project db -- npx -y @modelcontextprotocol/server-postgres
```

## Environment Variables

Required for certain features:

| Variable | Purpose |
|----------|---------|
| DATABASE_URL | PostgreSQL connection string |
| SENTRY_AUTH_TOKEN | Sentry API access |
| DATADOG_API_KEY | Datadog metrics |
| GITLAB_TOKEN | GitLab API access |

## Best Practices

1. **Keep secrets out of code** - Use environment variables
2. **Document agent triggers** - Clear descriptions help activation
3. **Test locally first** - Verify agents and skills work
4. **Share with team** - Commit `.claude/settings.json` and `.mcp.json`
5. **Gitignore local settings** - Keep `settings.local.json` private
