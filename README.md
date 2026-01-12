# Claude Code Sub-agents & Skills Templates

전역 및 프로젝트 레벨에서 사용할 수 있는 Claude Code 템플릿 모음입니다.

## 구조

```
├── global-templates/              # 전역 설정 템플릿 (~/.claude/에 복사)
│   ├── settings.json             # 전역 권한 설정
│   ├── agents/                   # 전역 agents (5개)
│   │   ├── code-reviewer.md
│   │   ├── data-engineer.md
│   │   ├── devops.md
│   │   ├── webapp-dev.md
│   │   └── general-helper.md
│   ├── skills/                   # 전역 skills (5개)
│   │   ├── pr-review/
│   │   ├── data-validation/
│   │   ├── deploy-check/
│   │   ├── security-scan/
│   │   └── sql-optimize/
│   └── README.md
│
├── project-templates/             # 프로젝트 설정 템플릿 (.claude/에 복사)
│   ├── .claude/
│   │   ├── settings.json
│   │   ├── settings.local.json.example
│   │   ├── agents/project-specific.md
│   │   └── skills/custom-workflow/
│   ├── .mcp.json
│   ├── .gitignore
│   └── CLAUDE.md
│
└── mcp-templates/                 # MCP 서버 설정 템플릿
    ├── github.json
    ├── gitlab.json
    ├── database.json
    ├── monitoring.json
    └── generic.json
```

## 빠른 시작

### 1. 전역 템플릿 설치

모든 프로젝트에서 사용할 agents와 skills를 설치합니다:

```bash
# 디렉토리 생성
mkdir -p ~/.claude/agents ~/.claude/skills

# agents 복사
cp global-templates/agents/* ~/.claude/agents/

# skills 복사
cp -r global-templates/skills/* ~/.claude/skills/

# settings 병합 (기존 설정이 없다면)
cp global-templates/settings.json ~/.claude/settings.json
```

### 2. 프로젝트에 적용

새 프로젝트에 템플릿을 적용합니다:

```bash
# 프로젝트 디렉토리로 이동
cd /path/to/your/project

# .claude 디렉토리 복사
cp -r /path/to/sub-agents/project-templates/.claude .

# MCP 설정 복사
cp /path/to/sub-agents/project-templates/.mcp.json .

# .gitignore 복사
cp /path/to/sub-agents/project-templates/.gitignore .

# CLAUDE.md 복사 후 프로젝트에 맞게 수정
cp /path/to/sub-agents/project-templates/CLAUDE.md .
```

## 전역 Agents (5개)

| Agent | 용도 | 모델 |
|-------|------|------|
| `code-reviewer` | 코드 리뷰, PR 검토, 품질 체크 | opus |
| `data-engineer` | 데이터 파이프라인, ETL, SQL 최적화 | sonnet |
| `devops` | 인프라, 배포, CI/CD, 모니터링 | sonnet |
| `webapp-dev` | 웹앱 개발 (React, Node.js 등) | sonnet |
| `general-helper` | 범용 프로그래밍, 코드 설명 | inherit |

## 전역 Skills (5개)

| Skill | 용도 | 트리거 키워드 |
|-------|------|---------------|
| `pr-review` | PR 리뷰 워크플로우 | "review PR", "check pull request" |
| `data-validation` | 데이터 품질 검증 | "validate data", "data quality" |
| `deploy-check` | 배포 준비 상태 확인 | "deployment readiness", "pre-deploy" |
| `security-scan` | 보안 취약점 스캔 | "security audit", "vulnerability scan" |
| `sql-optimize` | SQL 쿼리 최적화 | "optimize query", "slow query" |

## MCP 템플릿

### GitHub 연동
```bash
claude mcp add --transport http --scope project github https://api.githubcopilot.com/mcp/
```

### PostgreSQL 연동
```bash
claude mcp add --transport stdio --scope project db -- npx -y @modelcontextprotocol/server-postgres
```

### Sentry 연동
```bash
claude mcp add --transport http --scope project sentry https://mcp.sentry.dev/mcp
```

자세한 설정은 `mcp-templates/` 디렉토리를 참조하세요.

## 환경 변수

`.claude/settings.local.json.example`을 `.claude/settings.local.json`으로 복사하고 설정:

| 변수 | 용도 |
|------|------|
| `DATABASE_URL` | PostgreSQL 연결 문자열 |
| `SENTRY_AUTH_TOKEN` | Sentry API 토큰 |
| `DATADOG_API_KEY` | Datadog API 키 |
| `GITLAB_TOKEN` | GitLab 개인 액세스 토큰 |

## 사용 예시

```
Review the changes in src/auth/     # code-reviewer agent
Review PR #123                       # pr-review skill
Validate this dataset                # data-validation skill
Check deployment readiness           # deploy-check skill
Scan for security issues             # security-scan skill
Optimize this slow query             # sql-optimize skill
```

## 커스터마이징

### 새 Agent 추가
```markdown
---
name: my-agent
description: When to use this agent...
model: sonnet
tools: [Read, Write, Grep]
---

# Agent instructions here
```

### 새 Skill 추가
```markdown
---
name: my-skill
description: When to activate this skill...
allowed-tools: [Read, Grep]
---

# Skill workflow here
```

## 라이선스

MIT License
