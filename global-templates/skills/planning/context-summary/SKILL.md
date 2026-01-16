---
name: context-summary
description: |
  Context preservation skill for long-running projects.
  Maintains project memory across sessions using .context/ directory.
  Auto-triggers on session end, context limit warning, or explicit request.
  Trigger: "context summary", "save context", "memory bank", "정리해줘", "세션 정리"
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
---

# Context Summary & Memory Bank

## Overview

이 스킬은 두 가지 패턴을 제공합니다:

1. **Memory Bank** - `.context/` 디렉토리에 프로젝트 컨텍스트를 구조화하여 저장
2. **Session Summary** - 세션 종료 시 대화 내용을 요약하여 저장

## When to Apply

| Trigger | Action |
|---------|--------|
| 세션 종료 요청 | Session Summary 생성 |
| Context limit 경고 | Memory Bank 업데이트 |
| "정리해줘", "save context" | 둘 다 실행 |
| 장기 프로젝트 작업 | Memory Bank 주기적 업데이트 |
| 중요한 결정 후 | decisionLog.md 업데이트 |

---

## Part 1: Memory Bank Pattern

### Directory Structure

```
.context/
├── activeContext.md      # 현재 작업 초점 & 다음 단계
├── progress.md           # 태스크 진행률 (%)
├── decisionLog.md        # 아키텍처/기술 결정 기록
├── codebaseMap.md        # 주요 파일/모듈 맵
└── sessions/             # 세션별 요약 (선택)
    ├── 2026-01-16.md
    └── ...
```

### File Templates

#### activeContext.md
```markdown
# Active Context

## Current Focus
<!-- 현재 작업 중인 기능/버그/태스크 -->
- [ ] 메인 태스크 설명

## Recent Changes
<!-- 최근 변경사항 (최대 5개) -->
- `path/to/file.py` - 변경 내용 요약

## Next Steps
<!-- 다음에 해야 할 작업 -->
1. 첫 번째 다음 단계
2. 두 번째 다음 단계

## Blockers / Questions
<!-- 막힌 부분이나 질문 -->
- 없음

## Last Updated
<!-- 자동 업데이트 -->
2026-01-16 21:30 KST
```

#### progress.md
```markdown
# Project Progress

## Overall: 65%

### Features
| Feature | Status | Progress |
|---------|--------|----------|
| 사용자 인증 | ✅ Done | 100% |
| 대시보드 | 🔄 In Progress | 70% |
| 리포트 생성 | ⏳ Planned | 0% |

### Milestones
- [x] MVP 완료 (2026-01-10)
- [ ] Beta 릴리즈 (2026-01-20)
- [ ] Production (2026-02-01)
```

#### decisionLog.md
```markdown
# Decision Log

## [2026-01-16] 상태 관리 라이브러리 선택

### Context
React 앱의 전역 상태 관리 방식 결정 필요

### Options Considered
1. **Redux Toolkit** - 표준, 에코시스템 풍부
2. **Zustand** - 가벼움, 보일러플레이트 적음
3. **React Context** - 추가 의존성 없음

### Decision
**Zustand** 선택

### Rationale
- 프로젝트 규모가 중소형
- 보일러플레이트 최소화 우선
- 러닝커브 낮음

### Consequences
- Zustand 패턴에 맞춰 store 구조화
- devtools 미들웨어 추가 필요
```

---

## Part 2: Session Summary Pattern

### Session Summary Format

세션 종료 시 다음 형식으로 요약:

```markdown
# Session Summary - 2026-01-16

## Session Goal
사용자가 이 세션에서 달성하려 했던 목표

## Completed Tasks
- [x] 태스크 1 설명
- [x] 태스크 2 설명

## Key Changes
| File | Change |
|------|--------|
| `src/auth/login.py` | 로그인 로직 리팩토링 |
| `tests/test_auth.py` | 테스트 케이스 추가 |

## Decisions Made
- **결정 1**: 이유와 함께 기록
- **결정 2**: 이유와 함께 기록

## Unfinished / Next Session
- [ ] 미완료 태스크 1
- [ ] 미완료 태스크 2

## Notes
추가 메모나 주의사항
```

---

## Workflow

### On Session End

```
1. 대화 내용 분석
   └── 완료된 태스크, 변경된 파일, 결정사항 추출

2. Memory Bank 업데이트
   ├── activeContext.md - 현재 상태 반영
   ├── progress.md - 진행률 업데이트
   └── decisionLog.md - 새 결정 추가 (있으면)

3. Session Summary 생성
   └── .context/sessions/YYYY-MM-DD.md 저장

4. 다음 세션 안내
   └── "다음 세션에서 activeContext.md 참조하세요"
```

### On Context Limit Warning

```
1. 현재까지 진행 상황 캡처
2. Memory Bank 긴급 업데이트
3. 컨텍스트 압축 전 중요 정보 보존
```

---

## Commands

### Initialize Memory Bank
```bash
# 프로젝트에 .context 디렉토리 초기화
mkdir -p .context/sessions
```

### Quick Update
```
User: "context 업데이트해줘"
→ activeContext.md만 빠르게 업데이트
```

### Full Summary
```
User: "세션 정리해줘" / "save context"
→ Memory Bank + Session Summary 모두 실행
```

---

## Output Format

스킬 적용 시 출력:

```markdown
### Applied Skills
- [x] context-summary - session end

### Memory Bank Updated
- ✅ activeContext.md - 현재 초점 업데이트
- ✅ progress.md - 진행률 75% → 80%
- ✅ decisionLog.md - "API 구조 결정" 추가

### Session Summary
📄 Saved to `.context/sessions/2026-01-16.md`

### Next Session Tip
> 다음 세션 시작 시: "activeContext.md 읽어줘"
```

---

## Best Practices

1. **주기적 업데이트**: 큰 태스크 완료 시마다 Memory Bank 업데이트
2. **결정 기록**: 기술적 결정은 반드시 decisionLog.md에 기록
3. **파일 경로 포함**: 변경사항에 항상 파일 경로 명시
4. **진행률 정확히**: progress.md는 실제 완료율 반영
5. **다음 단계 명확히**: activeContext.md의 Next Steps는 구체적으로

## Anti-Patterns

❌ 너무 상세한 기록 (코드 전체 복사)
❌ 모호한 진행률 ("거의 다 됨")
❌ 결정 이유 없이 결과만 기록
❌ 오래된 정보 방치
