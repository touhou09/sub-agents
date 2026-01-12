# Claude Code Sub-agents & Skills Templates

전역 및 프로젝트 레벨에서 사용할 수 있는 Claude Code 템플릿 모음입니다.

## 빠른 시작

### 1. 전역 템플릿 설치 확인

전역 agents와 skills는 `~/.claude/` 디렉토리에 설치되어 있습니다:

```bash
# 설치된 agents 확인
ls ~/.claude/agents/

# 설치된 skills 확인
ls ~/.claude/skills/
```

### 2. 프로젝트에 적용

이 템플릿을 새 프로젝트에 적용하려면:

```bash
# .claude 디렉토리 복사
cp -r .claude /path/to/your/project/

# MCP 설정 복사
cp .mcp.json /path/to/your/project/

# 필요한 MCP 템플릿 복사
cp mcp-templates/database.json /path/to/your/project/mcp-templates/
```

## 구조

```
├── .claude/
│   ├── settings.json              # 프로젝트 설정
│   ├── settings.local.json.example # 로컬 설정 템플릿
│   ├── agents/
│   │   └── project-specific.md    # 프로젝트 전용 agent 템플릿
│   └── skills/
│       └── custom-workflow/
│           └── SKILL.md           # 커스텀 skill 템플릿
├── mcp-templates/                 # MCP 서버 템플릿
│   ├── github.json               # GitHub 연동
│   ├── gitlab.json               # GitLab 연동
│   ├── database.json             # DB 연동 (PostgreSQL, MySQL, SQLite)
│   ├── monitoring.json           # 모니터링 (Sentry, Datadog)
│   └── generic.json              # 범용 템플릿 (HTTP, SSE, Stdio)
├── .mcp.json                      # 프로젝트 MCP 설정
├── CLAUDE.md                      # 프로젝트 가이드라인
└── README.md                      # 이 파일
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

자세한 설정은 `mcp-templates/` 디렉토리의 각 파일을 참조하세요.

## 환경 변수 설정

`.claude/settings.local.json.example`을 `.claude/settings.local.json`으로 복사하고 값을 설정하세요:

```bash
cp .claude/settings.local.json.example .claude/settings.local.json
```

필요한 환경 변수:

| 변수 | 용도 |
|------|------|
| `DATABASE_URL` | PostgreSQL 연결 문자열 |
| `SENTRY_AUTH_TOKEN` | Sentry API 토큰 |
| `DATADOG_API_KEY` | Datadog API 키 |
| `DATADOG_APP_KEY` | Datadog 앱 키 |
| `GITLAB_TOKEN` | GitLab 개인 액세스 토큰 |
| `GITHUB_TOKEN` | GitHub 개인 액세스 토큰 |

## 사용 예시

### 코드 리뷰 요청
```
Review the changes in src/auth/
```

### PR 리뷰
```
Review PR #123
```

### 데이터 검증
```
Validate the user data in this CSV file
```

### 배포 준비 확인
```
Check if we're ready to deploy to production
```

### 보안 스캔
```
Scan this project for security vulnerabilities
```

### SQL 최적화
```
Optimize this slow query:
SELECT * FROM orders WHERE user_id = 123
```

## 커스터마이징

### 새 Agent 추가
1. `.claude/agents/` 디렉토리에 새 `.md` 파일 생성
2. YAML frontmatter에 `name`, `description`, `tools` 설정
3. 에이전트 지침 작성

### 새 Skill 추가
1. `.claude/skills/<skill-name>/` 디렉토리 생성
2. `SKILL.md` 파일 생성
3. frontmatter에 `name`, `description`, `allowed-tools` 설정
4. 워크플로우 단계 문서화

### MCP 서버 추가
1. `mcp-templates/generic.json`에서 적절한 템플릿 선택
2. `.mcp.json`에 서버 설정 추가
3. 필요한 환경 변수 설정

## 팁

- **Agents는 자동 선택됨**: 요청에 따라 적절한 agent가 자동으로 선택됩니다
- **Skills는 키워드로 활성화**: 요청에 포함된 키워드로 skill이 활성화됩니다
- **전역 설정 우선순위**: 프로젝트 설정 > 전역 설정
- **MCP 인증**: `/mcp` 명령으로 OAuth 인증 가능

## 라이선스

MIT License
