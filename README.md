# Claude Code Sub-agents & Skills Templates

전역 및 프로젝트 레벨에서 사용할 수 있는 Claude Code 템플릿 모음입니다.

## 구조

```
~/.claude/                         # 전역 설정 (global-templates/ 복사)
├── CLAUDE.md
├── settings.json
├── agents/*.md
└── skills/<name>/SKILL.md

~/.claude.json                     # MCP 서버 (별도 파일, CLI로 추가)
```

```
├── global-templates/              # → ~/.claude/에 복사
│   ├── CLAUDE.md                 # 전역 지침
│   ├── settings.json             # 전역 설정 (권한, 모델, 훅 등)
│   ├── agents/                   # 전역 agents (6개)
│   │   ├── reviewer.md           # testing, git, log
│   │   ├── data-engineer.md      # data pipeline, ETL
│   │   ├── web-dev.md            # frontend, backend
│   │   ├── devops.md             # docker, k8s, deploy
│   │   ├── docs-writer.md        # documentation
│   │   └── general-helper.md     # Q&A, explanation
│   └── skills/                   # 전역 skills (7개)
│       ├── pre-commit/SKILL.md
│       ├── dev-style/
│       │   ├── tdd/SKILL.md
│       │   └── perf-optimize/SKILL.md
│       ├── architect/
│       │   └── schema-design/SKILL.md
│       ├── devops/
│       │   └── mcp-setup/SKILL.md
│       └── docs/
│           ├── skill-writer/SKILL.md
│           └── context-summary/SKILL.md
│
├── project-templates/             # 프로젝트 설정 템플릿 (.claude/에 복사)
│   ├── CLAUDE.md                 # 프로젝트 지침 (global 참조 포함)
│   ├── .mcp.json                 # MCP 서버 설정
│   ├── .gitignore                # gitignore 템플릿
│   └── .claude/
│       ├── settings.json         # 프로젝트 공유 설정
│       ├── settings.local.json.example  # 로컬 설정 예시
│       ├── agents/               # 프로젝트 전용 agents
│       │   └── project-specific.md  # 템플릿
│       └── skills/               # 프로젝트 전용 skills
│           └── custom-workflow/SKILL.md  # 템플릿
│
└── mcp-templates/                 # MCP 서버 설정 템플릿
```

---

## 빠른 시작

### 1. 전역 템플릿 설치

```bash
# 전체 복사 (global-templates = ~/.claude)
cp -r global-templates/* ~/.claude/

# 또는 개별 복사
mkdir -p ~/.claude/agents ~/.claude/skills ~/.claude/logs
cp global-templates/CLAUDE.md ~/.claude/
cp global-templates/settings.json ~/.claude/
cp -r global-templates/agents/* ~/.claude/agents/
cp -r global-templates/skills/* ~/.claude/skills/
```

### 1-1. 전역 MCP 설치 (선택)

MCP는 `~/.claude.json` (별도 파일)에 저장됩니다:

```bash
# CLI로 추가 (--scope user = 전역)
claude mcp add --transport stdio --scope user postgresql -- npx -y @modelcontextprotocol/server-postgres
claude mcp add --transport stdio --scope user redis -- npx -y @anthropic-ai/mcp-server-redis
claude mcp add --transport http --scope user github https://api.githubcopilot.com/mcp/
```

### 2. 프로젝트에 적용

```bash
cd /path/to/your/project

cp -r /path/to/sub-agents/project-templates/.claude .
cp /path/to/sub-agents/project-templates/.mcp.json .
cp /path/to/sub-agents/project-templates/.gitignore .
cp /path/to/sub-agents/project-templates/CLAUDE.md .
```

---

## 전역 CLAUDE.md (지침)

`~/.claude/CLAUDE.md`는 모든 프로젝트에 적용되는 전역 지침입니다.

### 포함 내용
- **기본 동작**: 한국어 답변, 내부 영어 사용
- **코드 스타일**: 들여쓰기, 타입 안전성
- **역할 프로필**: Data Engineer, Fullstack, DevOps 모드
- **선호 도구**:
  - Frontend: React, Next.js, TypeScript
  - Backend: Python, FastAPI
  - Database: PostgreSQL, Redis, ClickHouse
  - Data: Polars, Delta Lake, Apache Arrow

### CLAUDE.md 우선순위

```
1. Enterprise policy (최고)
2. ./CLAUDE.md (프로젝트)
3. ./.claude/rules/*.md
4. ~/.claude/CLAUDE.md (전역) ← 이 파일
5. ./CLAUDE.local.md (최저)
```

---

## 전역 Settings.json 상세

### Model (모델)

```json
"model": "claude-opus-4-5-20251101",
"alwaysThinkingEnabled": true
```

### Permissions (권한)

| 구분 | 내용 |
|------|------|
| **Allow** | git(읽기), gh, npm/yarn/pnpm, pytest, docker ps, kubectl get, Read/Glob/Grep |
| **Deny** | rm -rf, sudo, chmod 777, git push --force, .env, ~/.ssh/**, ~/.aws/** |
| **Ask** | git push, git commit, docker build, kubectl apply, terraform apply |

### Hooks (훅)

| 훅 | 용도 | 로그 파일 |
|----|------|----------|
| `PreToolUse` | Bash 명령 로깅 | `~/.claude/logs/commands.log` |
| `PostToolUse` | 파일 쓰기 로깅 | `~/.claude/logs/files.log` |
| `UserPromptSubmit` | 사용자 입력 로깅 | `~/.claude/logs/prompts.log` |
| `Stop` | 세션 종료 로깅 | `~/.claude/logs/sessions.log` |

### Env (환경 변수)

| 변수 | 설명 | 값 |
|------|------|-----|
| `BASH_DEFAULT_TIMEOUT_MS` | 기본 타임아웃 | 60000 (1분) |
| `BASH_MAX_TIMEOUT_MS` | 최대 타임아웃 | 300000 (5분) |
| `MAX_THINKING_TOKENS` | Extended thinking | 16000 |

### 기타 설정

```json
"enableAllProjectMcpServers": true,
"cleanupPeriodDays": 30,
"outputStyle": "Explanatory"
```

---

## 전역 Agents (6개)

| Agent | 용도 | 모델 |
|-------|------|------|
| `reviewer` | Testing, Git 관리, 로그 모니터링 | haiku |
| `data-engineer` | 데이터 파이프라인, ETL, Polars/Arrow | opus |
| `web-dev` | Frontend (React), Backend (FastAPI) | opus |
| `devops` | Docker, K8s, 배포, 모니터링 | haiku |
| `docs-writer` | 문서화, API docs, README | haiku |
| `general-helper` | 코드베이스 탐색, 범용 Q&A | opus |

## 전역 Skills (6개)

| Skill | 용도 | 사용 Agent |
|-------|------|------------|
| `pre-commit` | Commit 전 품질 검사 (타입체크, 린트, 테스트) | reviewer |
| `dev-style/tdd` | TDD 기반 개발 워크플로우 | data-engineer, web-dev |
| `dev-style/perf-optimize` | 속도/리소스 최적화 | data-engineer, web-dev |
| `architect/schema-design` | 스키마 설계 및 검증 | data-engineer, web-dev |
| `docs/skill-writer` | 반복 예외 시 기존 skill 업데이트 | docs-writer |
| `docs/context-summary` | Context compact 전 진행상황 정리 | docs-writer |
| `devops/mcp-setup` | DB, Redis, S3 MCP 연결 설정 | devops |

---

## 프로젝트 템플릿 (project-templates)

프로젝트별로 복사해서 사용하는 템플릿입니다.

### 구성 요소

| 파일 | 용도 | Git |
|------|------|-----|
| `CLAUDE.md` | 프로젝트 지침, global agents/skills 참조 | commit |
| `.claude/settings.json` | 프로젝트 공유 권한/환경변수 | commit |
| `.claude/settings.local.json` | 로컬 전용 설정 (DB URL 등) | gitignore |
| `.claude/agents/*.md` | 프로젝트 전용 agent | commit |
| `.claude/skills/*/SKILL.md` | 프로젝트 전용 skill | commit |
| `.mcp.json` | MCP 서버 설정 | commit |

### settings.json vs settings.local.json

```
settings.json (공유)          settings.local.json (개인)
├── npm, pytest 허용          ├── psql, redis-cli 허용
├── rm -rf, sudo 차단         ├── DATABASE_URL
└── NODE_ENV=development      ├── REDIS_URL
                              └── API tokens
```

---

## MCP 템플릿

### 전역 MCP 설치 (1회)

```bash
# Database
claude mcp add --transport stdio --scope user postgresql -- npx -y @modelcontextprotocol/server-postgres
claude mcp add --transport stdio --scope user redis -- npx -y @anthropic-ai/mcp-server-redis

# Git
claude mcp add --transport http --scope user github https://api.githubcopilot.com/mcp/

# Monitoring
claude mcp add --transport http --scope user sentry https://mcp.sentry.dev/mcp

# Storage
claude mcp add --transport stdio --scope user s3 -- npx -y @anthropic-ai/mcp-server-aws-s3
```

### 프로젝트별 .env 설정

```bash
# .env.example 복사
cp mcp-templates/.env.example /path/to/project/.env

# 실제 값 입력
DATABASE_URL=postgresql://user:pass@localhost:5432/mydb
REDIS_URL=redis://localhost:6379
```

### 파일 구조

```
mcp-templates/
├── README.md           # 설치/사용 가이드
├── global-mcp.json     # 전역 MCP 템플릿
├── .env.example        # 환경변수 템플릿
├── database.json       # DB 상세 설정
├── storage.json        # S3/GCS 상세 설정
├── monitoring.json     # Sentry/Datadog
├── github.json
├── gitlab.json
└── generic.json        # 커스텀 템플릿
```

자세한 설정은 `mcp-templates/README.md` 참조.

---

## 사용 예시

```
Run tests and commit                 # reviewer agent + pre-commit skill
Create a data pipeline               # data-engineer agent + tdd, schema-design skills
Build a user registration form       # web-dev agent + tdd, schema-design skills
This query is slow                   # data-engineer agent + perf-optimize skill
Optimize page load time              # web-dev agent + perf-optimize skill
Setup docker-compose environment     # devops agent
Deploy to kubernetes                 # devops agent
```

---

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

### 훅 비활성화
```json
"disableAllHooks": true
```

### 모델 변경
```json
"model": "claude-sonnet-4-5-20250929"
```

---

## 라이선스

MIT License
