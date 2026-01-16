# Codebase Map

> 프로젝트의 주요 파일과 모듈 구조를 기록합니다.
> 새 세션 시작 시 빠르게 코드베이스를 파악하는 데 사용합니다.

---

## Project Structure

```
project-root/
├── src/                    # 소스 코드
│   ├── components/         # UI 컴포넌트
│   ├── services/           # 비즈니스 로직
│   ├── utils/              # 유틸리티 함수
│   └── types/              # 타입 정의
├── tests/                  # 테스트 코드
├── docs/                   # 문서
└── .context/               # Memory Bank
```

---

## Key Files

### Entry Points
| File | Purpose |
|------|---------|
| `src/main.py` | 애플리케이션 진입점 |
| `src/app.py` | 앱 설정 및 라우팅 |

### Core Modules
| Module | Responsibility |
|--------|----------------|
| `src/services/auth.py` | 인증/인가 로직 |
| `src/services/data.py` | 데이터 처리 |

### Configuration
| File | Purpose |
|------|---------|
| `config.py` | 환경 설정 |
| `.env` | 환경 변수 (gitignore) |

---

## Data Flow

```
User Request
    │
    ▼
[Router] ─────► [Controller] ─────► [Service]
                     │                   │
                     ▼                   ▼
                [Validator]         [Repository]
                                         │
                                         ▼
                                    [Database]
```

---

## Dependencies

### External Services
| Service | Purpose | Config Key |
|---------|---------|------------|
| PostgreSQL | 주 데이터베이스 | `DATABASE_URL` |
| Redis | 캐시/세션 | `REDIS_URL` |

### Key Libraries
| Library | Version | Purpose |
|---------|---------|---------|
| FastAPI | 0.100+ | Web framework |
| Polars | 0.20+ | Data processing |

---

## Conventions

### Naming
- Files: `snake_case.py`
- Classes: `PascalCase`
- Functions: `snake_case`
- Constants: `UPPER_SNAKE_CASE`

### Patterns Used
- Repository Pattern (데이터 접근)
- Service Layer (비즈니스 로직)
- Dependency Injection (의존성 관리)

---
**Last Updated**: 2026-01-16
