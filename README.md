# Claude Code Sub-agents & Skills Templates

전역 및 프로젝트 레벨에서 사용할 수 있는 Claude Code 템플릿 모음입니다.

## 구조

```
~/.claude/                         # 전역 설정 (global-templates/ 복사)
├── CLAUDE.md
├── settings.json
├── agents/*.md
└── skills/<name>/SKILL.md
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
│       ├── dev-style/tdd/SKILL.md
│       ├── dev-style/perf-optimize/SKILL.md
│       ├── architect/schema-design/SKILL.md
│       ├── devops/mcp-setup/SKILL.md
│       ├── docs/skill-writer/SKILL.md
│       └── docs/context-summary/SKILL.md
│
└── project-templates/             # → 프로젝트에 복사
    ├── CLAUDE.md                 # 프로젝트 지침
    ├── .mcp.json                 # MCP 서버 (postgresql, redis, github 등)
    ├── .env.example              # 환경변수 템플릿
    ├── .gitignore
    └── .claude/
        ├── settings.json         # 프로젝트 공유 설정
        ├── settings.local.json.example
        ├── agents/project-specific.md
        └── skills/custom-workflow/SKILL.md
```

---

## 빠른 시작

### 1. 전역 템플릿 설치

```bash
cp -r global-templates/* ~/.claude/
```

### 2. 프로젝트에 적용

```bash
cd /path/to/your/project

# 전체 복사
cp -r /path/to/sub-agents/project-templates/* .
cp -r /path/to/sub-agents/project-templates/.* . 2>/dev/null

# .env 설정
cp .env.example .env
# DATABASE_URL, REDIS_URL 등 입력
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

## 전역 Skills (7개)

| Skill | 용도 | 사용 Agent |
|-------|------|------------|
| `pre-commit` | Commit 전 품질 검사 | reviewer |
| `dev-style/tdd` | TDD 기반 개발 | data-engineer, web-dev |
| `dev-style/perf-optimize` | 속도/리소스 최적화 | data-engineer, web-dev |
| `architect/schema-design` | 스키마 설계 및 검증 | data-engineer, web-dev |
| `devops/mcp-setup` | DB, Redis MCP 연결 설정 | devops |
| `docs/skill-writer` | 반복 예외 시 skill 업데이트 | docs-writer |
| `docs/context-summary` | Context compact 전 정리 | docs-writer |

---

## 프로젝트 MCP 설정

프로젝트별 `.mcp.json`에 MCP 서버가 정의되어 있습니다:

| 서버 | 환경변수 | 용도 |
|------|----------|------|
| `postgresql` | `DATABASE_URL` | PostgreSQL 연결 |
| `redis` | `REDIS_URL` | Redis 연결 |
| `github` | OAuth | GitHub PR, Issue |
| `sentry` | OAuth | 에러 모니터링 |
| `filesystem` | - | 로컬 파일 접근 |

### 사용 방법

```bash
# 1. 프로젝트에 템플릿 복사
cp project-templates/.mcp.json .
cp project-templates/.env.example .env

# 2. .env에 실제 값 입력
DATABASE_URL=postgresql://user:pass@localhost:5432/mydb
REDIS_URL=redis://localhost:6379

# 3. Claude Code 실행 시 자동 연결
claude
/mcp  # 연결 상태 확인
```

---

## 사용 예시

```
Run tests and commit              # reviewer + pre-commit
Create a data pipeline            # data-engineer + tdd, schema-design
Build a user registration form    # web-dev + tdd
This query is slow                # data-engineer + perf-optimize
Setup docker-compose              # devops
Where is auth handled?            # general-helper
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
description: When to activate...
allowed-tools: [Read, Grep]
---
# Skill workflow here
```

---

## 라이선스

MIT License
