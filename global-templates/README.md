# Global Templates

이 디렉토리의 파일들을 `~/.claude/`에 복사하면 모든 프로젝트에서 사용할 수 있습니다.

## 설치 방법

```bash
# agents 복사
cp -r agents/* ~/.claude/agents/

# skills 복사
cp -r skills/* ~/.claude/skills/

# settings.json 병합 (기존 설정이 있다면 수동으로 병합)
# 기존 설정이 없다면:
cp settings.json ~/.claude/settings.json
```

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

### Settings
- `settings.json` - 기본 권한 설정 (안전한 명령어 허용, 위험한 명령어 거부)

## 기존 설정과 병합

기존 `~/.claude/settings.json`이 있다면 수동으로 병합하세요:

```json
{
  "existingKey": "existingValue",
  "permissions": {
    "allow": [
      // 기존 허용 규칙 유지
      // 새 규칙 추가
    ],
    "deny": [
      // 기존 거부 규칙 유지
      // 새 규칙 추가
    ]
  }
}
```
