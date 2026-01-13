---
name: mcp-setup
description: |
  Set up MCP servers for project database, storage, and monitoring connections.
  Trigger: "connect to DB", "setup MCP", "configure database", "S3 setup",
  "connect to redis", "MCP 설정", "DB 연결".
allowed-tools:
  - Read
  - Write
  - Grep
  - Glob
  - Bash(claude mcp:*)
---

# MCP Setup Skill

## Purpose

Help users configure MCP servers for their project by:
1. Checking what services the project needs
2. Guiding .env configuration
3. Adding/verifying MCP servers
4. Testing connections

## Workflow

### Step 1: Detect Required Services

Check project files for service dependencies:

```bash
# Check for database
grep -r "DATABASE_URL\|postgresql\|mysql\|sqlite" . --include="*.py" --include="*.ts" --include="*.env*"

# Check for Redis
grep -r "REDIS_URL\|redis" . --include="*.py" --include="*.ts" --include="*.env*"

# Check for S3
grep -r "S3_BUCKET\|AWS_\|boto3" . --include="*.py" --include="*.ts" --include="*.env*"
```

### Step 2: Check Existing Configuration

```bash
# Check existing .env
cat .env 2>/dev/null || echo "No .env file"

# Check existing MCP
cat .mcp.json 2>/dev/null || echo "No .mcp.json"

# Check global MCP status
claude mcp list
```

### Step 3: Guide .env Setup

If .env is missing or incomplete:

```markdown
## Required Environment Variables

Based on your project, you need:

| Variable | Purpose | Example |
|----------|---------|---------|
| `DATABASE_URL` | PostgreSQL connection | `postgresql://user:pass@localhost:5432/db` |
| `REDIS_URL` | Redis connection | `redis://localhost:6379` |

Create or update `.env`:
```

### Step 4: Add MCP Servers (if needed)

```bash
# Check if server exists globally
claude mcp get postgresql

# If not, add to project scope
claude mcp add --transport stdio --scope project postgresql -- npx -y @modelcontextprotocol/server-postgres
```

### Step 5: Test Connection

```bash
# Verify MCP status
/mcp

# Test database connection (if available)
# Use MCP tools to run a simple query
```

## Output Format

```markdown
## MCP Setup Complete

### Configured Services
- [x] PostgreSQL (DATABASE_URL)
- [x] Redis (REDIS_URL)
- [ ] S3 (not configured)

### .env Status
- Location: `.env`
- Variables set: 2/3

### MCP Servers
| Server | Scope | Status |
|--------|-------|--------|
| postgresql | global | connected |
| redis | global | connected |
| github | global | connected |

### Next Steps
1. Add S3 credentials to .env if needed
2. Run `/mcp` to verify connections
```

## Common Scenarios

### Scenario 1: New Project Setup

```
User: DB 연결 설정해줘

Steps:
1. Check if .env exists
2. Check if DATABASE_URL is set
3. Guide user to set DATABASE_URL
4. Verify global postgresql MCP exists
5. Test connection
```

### Scenario 2: Add New Service

```
User: Redis 연결 추가해줘

Steps:
1. Add REDIS_URL to .env
2. Check global redis MCP
3. If not exists, add with --scope user
4. Test connection
```

### Scenario 3: Project Override

```
User: 이 프로젝트는 다른 DB 서버 써야해

Steps:
1. Update .env with new DATABASE_URL
2. Add project-scope MCP if different config needed
3. Verify override works
```

## Environment Variable Templates

### PostgreSQL
```
DATABASE_URL=postgresql://username:password@host:5432/database
```

### MySQL
```
MYSQL_URL=mysql://username:password@host:3306/database
```

### Redis
```
REDIS_URL=redis://:password@host:6379/0
```

### S3
```
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=us-east-1
S3_BUCKET=my-bucket
```
