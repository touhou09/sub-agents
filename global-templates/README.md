# Global Templates

이 디렉토리의 파일들을 `~/.claude/`에 복사하면 모든 프로젝트에서 사용할 수 있습니다.

## 설치 방법

```bash
# 디렉토리 생성
mkdir -p ~/.claude/agents ~/.claude/skills ~/.claude/logs

# 전역 지침 복사
cp CLAUDE.md ~/.claude/CLAUDE.md

# agents 복사
cp -r agents/* ~/.claude/agents/

# skills 복사
cp -r skills/* ~/.claude/skills/

# settings.json 복사 (기존 설정이 있다면 수동으로 병합)
cp settings.json ~/.claude/settings.json
```

---

## CLAUDE.md (전역 지침)

`~/.claude/CLAUDE.md`는 모든 프로젝트에 적용되는 전역 지침 파일입니다.

### 포함 내용
- **기본 동작**: 언어, 코드 품질 우선순위
- **코드 스타일**: 들여쓰기, 타입 안전성
- **역할 프로필**: Data Engineer, Fullstack, DevOps 모드
- **선호 도구**: 프레임워크, 라이브러리
- **금지 사항**: 보안, 코드 품질 규칙
- **커밋 규칙**: 메시지 형식

### CLAUDE.md 우선순위

```
1. Enterprise policy (최고)
2. ./CLAUDE.md (프로젝트)
3. ./.claude/rules/*.md
4. ~/.claude/CLAUDE.md (전역) ← 이 파일
5. ./CLAUDE.local.md (최저)
```

---

## Settings.json 상세 설명

### 1. Model (모델)

```json
"model": "claude-opus-4-5-20251101",
"alwaysThinkingEnabled": true
```

| 옵션 | 설명 | 가능한 값 |
|------|------|----------|
| `model` | 기본 사용 모델 | `claude-opus-4-5-20251101`, `claude-sonnet-4-5-20250929` |
| `alwaysThinkingEnabled` | Extended thinking 활성화 | `true` / `false` |

### 2. Permissions (권한)

```json
"permissions": {
  "allow": [...],  // 자동 승인
  "deny": [...],   // 완전 차단
  "ask": [...]     // 실행 전 확인 요청
}
```

#### Allow (자동 승인)
| 카테고리 | 명령어 |
|----------|--------|
| Git (읽기) | `git status`, `git diff`, `git log`, `git branch`, `git show`, `git stash` |
| GitHub CLI | `gh pr`, `gh issue`, `gh repo` |
| 테스트 | `npm test`, `pytest`, `go test`, `cargo test` |
| 빌드 | `npm run`, `yarn`, `pnpm`, `make` |
| 컨테이너 (읽기) | `docker ps`, `docker logs`, `kubectl get`, `kubectl describe` |
| 파일 도구 | `Read`, `Glob`, `Grep` |

#### Deny (차단)
| 카테고리 | 명령어 | 이유 |
|----------|--------|------|
| 시스템 위험 | `rm -rf`, `sudo`, `chmod 777` | 시스템 손상 방지 |
| Git 위험 | `git push --force`, `git push -f` | 히스토리 손실 방지 |
| 민감 파일 | `.env`, `.env.*`, `secrets/**`, `~/.ssh/**`, `~/.aws/**` | 보안 |

#### Ask (확인 요청)
| 명령어 | 이유 |
|--------|------|
| `git push`, `git commit` | 코드 변경 확인 |
| `docker build` | 리소스 사용 |
| `kubectl apply`, `terraform apply` | 인프라 변경 |

### 3. Hooks (훅)

도구 실행 전후로 자동 실행되는 스크립트입니다.

```json
"hooks": {
  "PreToolUse": [...],      // 도구 실행 전
  "PostToolUse": [...],     // 도구 실행 후
  "UserPromptSubmit": [...], // 사용자 입력 시
  "Stop": [...]             // 세션 종료 시
}
```

| 훅 | 용도 | 로그 파일 |
|----|------|----------|
| `PreToolUse` | Bash 명령 실행 로깅 | `~/.claude/logs/commands.log` |
| `PostToolUse` | 파일 쓰기 로깅 | `~/.claude/logs/files.log` |
| `UserPromptSubmit` | 사용자 입력 로깅 | `~/.claude/logs/prompts.log` |
| `Stop` | 세션 종료 로깅 | `~/.claude/logs/sessions.log` |

### 4. Env (환경 변수)

```json
"env": {
  "NODE_ENV": "development",
  "BASH_DEFAULT_TIMEOUT_MS": "60000",
  "BASH_MAX_TIMEOUT_MS": "300000",
  "MAX_THINKING_TOKENS": "16000"
}
```

| 변수 | 설명 | 기본값 |
|------|------|--------|
| `NODE_ENV` | Node.js 환경 | `development` |
| `BASH_DEFAULT_TIMEOUT_MS` | 기본 명령 타임아웃 | `60000` (1분) |
| `BASH_MAX_TIMEOUT_MS` | 최대 명령 타임아웃 | `300000` (5분) |
| `MAX_THINKING_TOKENS` | Extended thinking 토큰 | `16000` |

### 5. MCP 설정

```json
"enableAllProjectMcpServers": true
```

프로젝트의 `.mcp.json`에 정의된 MCP 서버를 자동으로 승인합니다.

### 6. Attribution (저작자 표시)

```json
"attribution": {
  "commit": "...",
  "pr": "..."
}
```

Git 커밋과 PR에 자동으로 추가되는 저작자 표시입니다.

### 7. 기타 설정

| 옵션 | 설명 | 값 |
|------|------|-----|
| `cleanupPeriodDays` | 오래된 세션 자동 삭제 | `30`일 |
| `outputStyle` | 출력 스타일 | `Explanatory` |

---

## 포함된 파일

### Agents (5개)
| 파일 | 용도 | 모델 |
|------|------|------|
| `code-reviewer.md` | 코드 리뷰, PR 검토 | opus |
| `data-engineer.md` | 데이터 파이프라인, ETL, SQL | sonnet |
| `devops.md` | 인프라, CI/CD, 모니터링 | sonnet |
| `webapp-dev.md` | 웹앱 개발 (React, Node.js) | sonnet |
| `general-helper.md` | 범용 프로그래밍 | inherit |

### Skills (5개)
| 디렉토리 | 용도 | 트리거 |
|----------|------|--------|
| `pr-review/` | PR 리뷰 워크플로우 | "review PR" |
| `data-validation/` | 데이터 품질 검증 | "validate data" |
| `deploy-check/` | 배포 준비 확인 | "deployment check" |
| `security-scan/` | 보안 취약점 스캔 | "security audit" |
| `sql-optimize/` | SQL 쿼리 최적화 | "optimize query" |

---

## 커스터마이징

### 권한 추가/제거

```json
"permissions": {
  "allow": [
    // 기존 규칙...
    "Bash(your-command:*)"  // 새 규칙 추가
  ]
}
```

### 훅 비활성화

특정 훅을 비활성화하려면 해당 섹션을 제거하거나:

```json
"disableAllHooks": true
```

### 모델 변경

```json
"model": "claude-sonnet-4-5-20250929"  // 더 빠른 모델로 변경
```

---

## 기존 설정과 병합

기존 `~/.claude/settings.json`이 있다면 수동으로 병합하세요:

```json
{
  "existingKey": "existingValue",
  "permissions": {
    "allow": [
      // 기존 규칙 유지
      // 새 규칙 추가
    ]
  }
}
```
