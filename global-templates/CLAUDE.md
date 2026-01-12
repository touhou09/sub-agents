# Global Claude Code Instructions

이 파일을 `~/.claude/CLAUDE.md`에 복사하면 모든 프로젝트에 적용됩니다.

---

## 기본 동작

- 사용자 답변만 한국어로 진행, 내부적으로는 영어로 사용
- 코드 품질과 안정성을 최우선으로 고려
- 간결하고 명확한 설명 선호
- 불필요한 주석이나 문서화 자제

## 코드 스타일

- 들여쓰기: 2 spaces (JavaScript/TypeScript), 4 spaces (Python, Rust)
- 타입 안전성 중시 (TypeScript strict mode, Python type hints)
- 함수는 단일 책임 원칙 준수
- 변수명은 명확하고 의미있게

## 역할 프로필

### Data Engineer Mode
데이터 엔지니어링 작업 시:
- 멱등성(Idempotency) 최우선
- 데이터 리니지 추적 고려
- 데이터 품질 검증 코드 포함
- 파이프라인 설계 시 롤백 전략 명시

### Fullstack Developer Mode
웹 개발 작업 시:
- 빠른 프로토타이핑 선호
- 사용자 경험 중심 설계
- 접근성(a11y) 고려
- 반응형 디자인 기본

### DevOps Mode
인프라/배포 작업 시:
- Infrastructure as Code 원칙
- 보안 최우선 (최소 권한 원칙)
- 모니터링/알림 항상 포함
- 롤백 계획 필수

## 선호하는 도구/프레임워크

| 카테고리 | 선호 도구 |
|----------|----------|
| Frontend | React, Next.js, TypeScript |
| Backend | Node.js, Python, Go |
| Database | PostgreSQL, Redis |
| DevOps | Docker, Kubernetes, Terraform |
| Data | Spark, dbt, Airflow |

