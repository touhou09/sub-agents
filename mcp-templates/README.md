# MCP Templates

.env 기반 MCP 서버 템플릿입니다. 전역 설정 후 프로젝트별로 .env만 설정하면 바로 사용 가능합니다.

## 구조

```
전역 (~/.claude.json)          프로젝트 (.env)
├── postgresql                 DATABASE_URL=postgresql://...
├── mysql                      MYSQL_URL=mysql://...
├── redis                      REDIS_URL=redis://...
├── s3                         AWS_ACCESS_KEY_ID=...
├── sentry                     AWS_SECRET_ACCESS_KEY=...
├── datadog                    S3_BUCKET=...
└── ...                        SENTRY_AUTH_TOKEN=...
```

## 빠른 시작

### 1. 전역 MCP 설치 (1회)

```bash
# 방법 1: CLI로 개별 추가
claude mcp add --transport stdio --scope user postgresql -- npx -y @modelcontextprotocol/server-postgres
claude mcp add --transport stdio --scope user redis -- npx -y @anthropic-ai/mcp-server-redis
claude mcp add --transport http --scope user github https://api.githubcopilot.com/mcp/
claude mcp add --transport http --scope user sentry https://mcp.sentry.dev/mcp

# 방법 2: global-mcp.json을 ~/.claude.json에 병합
# (기존 설정이 있다면 mcpServers 부분만 병합)
```

### 2. 프로젝트별 .env 설정

```bash
cd /path/to/project

# .env.example 복사
cp /path/to/sub-agents/mcp-templates/.env.example .env

# 실제 값 입력
vim .env
```

### 3. 확인

```bash
claude
/mcp  # MCP 서버 상태 확인
```

---

## 전역 MCP 서버 목록

### Database

| 서버 | 환경변수 | 용도 |
|------|----------|------|
| `postgresql` | `DATABASE_URL` | PostgreSQL 읽기/쓰기 |
| `mysql` | `MYSQL_URL` | MySQL 읽기/쓰기 |
| `sqlite` | `DB_PATH` | SQLite 파일 |
| `redis` | `REDIS_URL` | Redis 캐시 |

### Cloud Storage

| 서버 | 환경변수 | 용도 |
|------|----------|------|
| `s3` | `AWS_*`, `S3_BUCKET` | AWS S3 접근 |
| `gcs` | `GOOGLE_*`, `GCS_BUCKET` | Google Cloud Storage |

### Monitoring

| 서버 | 환경변수 | 용도 |
|------|----------|------|
| `sentry` | `SENTRY_AUTH_TOKEN` | 에러 모니터링 |
| `datadog` | `DATADOG_API_KEY`, `DATADOG_APP_KEY` | 메트릭/로그 |

### Git

| 서버 | 환경변수 | 용도 |
|------|----------|------|
| `github` | (OAuth) | GitHub PR, Issue |
| `gitlab` | `GITLAB_TOKEN`, `GITLAB_URL` | GitLab 통합 |

---

## 환경변수 우선순위

```
1. .env.local (개인, gitignore)
2. .env (프로젝트)
3. ~/.claude/settings.local.json
4. 시스템 환경변수
```

---

## 프로젝트별 Override

전역 MCP를 프로젝트에서 다른 설정으로 override:

```bash
# 프로젝트에서 다른 DB 사용
claude mcp add --transport stdio --scope project postgresql -- npx -y @modelcontextprotocol/server-postgres
```

`.mcp.json`에서 같은 이름으로 정의하면 전역 설정을 override 합니다.

---

## 파일 설명

| 파일 | 용도 |
|------|------|
| `global-mcp.json` | 전역 MCP 템플릿 (~/.claude.json에 병합) |
| `.env.example` | 프로젝트 환경변수 템플릿 |
| `database.json` | DB MCP 상세 설정 |
| `storage.json` | S3/GCS MCP 상세 설정 |
| `monitoring.json` | Sentry/Datadog 상세 설정 |
| `github.json` | GitHub MCP |
| `gitlab.json` | GitLab MCP |
| `generic.json` | 커스텀 MCP 템플릿 |

---

## Agent 워크플로우

Agent가 프로젝트 MCP 설정을 도와줄 수 있습니다:

```
User: DB 연결 설정해줘

Agent:
1. .env 파일 확인
2. DATABASE_URL 설정 안내
3. /mcp 로 연결 상태 확인
4. 테스트 쿼리 실행
```
