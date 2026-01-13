# Claude Code Sub-agents & Skills Templates

전역 및 프로젝트 레벨에서 사용할 수 있는 Claude Code 템플릿 모음입니다.

- **에이전트**: 6개 (Core)
- **스킬**: 37개 (9개 카테고리)
- **Memory Bank**: 세션 간 컨텍스트 유지

## 구조

```
~/.claude/                              # 전역 설정 (global-templates/ 복사)
├── CLAUDE.md
├── settings.json
├── agents/*.md                         # 6개 에이전트
└── skills/                             # 37개 스킬 (카테고리별)
    ├── testing/                        # 테스트 관련
    ├── git/                            # Git & Code Review
    ├── development/                    # 개발 도구
    ├── planning/                       # 계획 & 협업
    ├── agents/                         # 에이전트 오케스트레이션
    ├── devops/                         # DevOps
    ├── docs/                           # 문서화
    ├── office/                         # Office 문서 생성
    └── design/                         # 디자인
```

```
├── global-templates/                   # → ~/.claude/에 복사
│   ├── CLAUDE.md                       # 전역 지침
│   ├── settings.json                   # 전역 설정
│   ├── agents/                         # 전역 에이전트 (6개)
│   └── skills/                         # 전역 스킬 (37개, 9개 카테고리)
│
└── project-templates/                  # → 프로젝트에 복사
    ├── CLAUDE.md                       # 프로젝트 지침
    ├── .mcp.json                       # MCP 서버
    ├── .context/                       # Memory Bank
    └── .claude/                        # 프로젝트별 에이전트/스킬
```

---

## 빠른 시작

### 자동 설치 (권장)

**Linux / macOS:**
```bash
# Claude Code + Cursor 모두 설치
./scripts/setup.sh --all

# Claude Code만 설치
./scripts/setup.sh --claude

# Cursor만 설치
./scripts/setup.sh --cursor

# 심볼릭 링크 사용 (원본 업데이트 시 자동 반영)
./scripts/setup.sh --all --symlink
```

**Windows (PowerShell):**
```powershell
# Claude Code + Cursor 모두 설치
.\scripts\setup.ps1 -All

# Claude Code만 설치
.\scripts\setup.ps1 -Claude

# 심볼릭 링크 사용 (관리자 권한 필요)
.\scripts\setup.ps1 -All -Symlink
```

### 수동 설치

**Claude Code:**
```bash
cp -r global-templates/* ~/.claude/
```

**Cursor:**
```bash
mkdir -p ~/.cursor/rules
cp global-templates/CLAUDE.md ~/.cursor/rules/global.mdc
```

### 프로젝트에 적용

```bash
cd /path/to/your/project
cp -r /path/to/sub-agents/project-templates/* .
cp -r /path/to/sub-agents/project-templates/.* . 2>/dev/null
```

---

## 지원 플랫폼

| 플랫폼 | Claude Code | Cursor |
|--------|-------------|--------|
| **Linux** | `~/.claude/` | `~/.cursor/rules/` |
| **macOS** | `~/.claude/` | `~/.cursor/rules/` |
| **Windows** | `%USERPROFILE%\.claude\` | `%USERPROFILE%\.cursor\rules\` |

> **Note:** Cursor 전역 User Rules는 UI 기반입니다.
> Settings > Cursor Settings > Rules > User Rules에서 직접 설정하세요.

---

## Agents (6개)

| Agent | 용도 | 모델 | 주요 Skills |
|-------|------|------|-------------|
| `reviewer` | Testing, Code Review, Git | haiku | pre-commit, webapp-testing, systematic-debugging |
| `data-engineer` | 데이터 파이프라인, ETL | opus | tdd, schema-design, writing-plans |
| `web-dev` | React, FastAPI 개발 | opus | frontend-design, webapp-testing, brainstorming |
| `devops` | Docker, K8s, 배포 | haiku | mcp-setup, mcp-builder, executing-plans |
| `docs-writer` | 문서화, 문서 생성 | haiku | docx, pdf, pptx, xlsx, skill-creator |
| `general-helper` | 코드베이스 탐색, Q&A | opus | brainstorming, writing-plans |

---

## Skills (37개, 9개 카테고리)

### testing/ (6개)
| Skill | 용도 |
|-------|------|
| `pre-commit` | 커밋 전 품질 검사 |
| `webapp-testing` | E2E Playwright 테스트 |
| `tdd` | TDD 기반 개발 |
| `test-driven-development` | RED-GREEN-REFACTOR 사이클 |
| `systematic-debugging` | 4단계 근본 원인 분석 |
| `verification-before-completion` | 수정 완료 전 검증 |

### git/ (4개)
| Skill | 용도 |
|-------|------|
| `requesting-code-review` | 리뷰 요청 체크리스트 |
| `receiving-code-review` | 피드백 반영 관리 |
| `using-git-worktrees` | 병렬 브랜치 개발 |
| `finishing-a-development-branch` | 머지/PR 결정 |

### development/ (4개)
| Skill | 용도 |
|-------|------|
| `perf-optimize` | 속도/리소스 최적화 |
| `schema-design` | 스키마 설계 및 검증 |
| `frontend-design` | React + Tailwind 가이드 |
| `web-artifacts-builder` | HTML artifact 빌드 |

### planning/ (3개)
| Skill | 용도 |
|-------|------|
| `brainstorming` | 소크라테스식 설계 토론 |
| `writing-plans` | 구현 계획 작성 |
| `executing-plans` | 배치 실행 + 체크포인트 |

### agents/ (2개)
| Skill | 용도 |
|-------|------|
| `dispatching-parallel-agents` | 동시 서브에이전트 워크플로우 |
| `subagent-driven-development` | 2단계 리뷰 빠른 반복 |

### devops/ (2개)
| Skill | 용도 |
|-------|------|
| `mcp-setup` | DB, Redis MCP 연결 설정 |
| `mcp-builder` | MCP 서버 생성 |

### docs/ (6개)
| Skill | 용도 |
|-------|------|
| `skill-writer` | 기존 스킬 업데이트 |
| `skill-creator` | 새 스킬 생성 |
| `writing-skills` | 스킬 작성 베스트 프랙티스 |
| `context-summary` | 컨텍스트 정리 |
| `doc-coauthoring` | 문서 공동 작성 |
| `memory-bank` | 세션 간 컨텍스트 유지 |

### office/ (4개)
| Skill | 용도 |
|-------|------|
| `docx` | Word 문서 생성/편집 |
| `pdf` | PDF 조작 |
| `pptx` | PowerPoint 프레젠테이션 |
| `xlsx` | Excel 스프레드시트 |

### design/ (6개)
| Skill | 용도 |
|-------|------|
| `algorithmic-art` | p5.js 기반 생성 아트 |
| `canvas-design` | PNG/PDF 비주얼 아트 |
| `slack-gif-creator` | Slack용 애니메이션 GIF |
| `theme-factory` | 테마 생성 |
| `brand-guidelines` | 브랜드 가이드라인 |
| `internal-comms` | 내부 커뮤니케이션 |

---

## Memory Bank

프로젝트의 장기 기억을 유지하기 위한 시스템입니다.

```
.context/
├── activeContext.md    # 현재 작업 중인 내용, 다음 단계
├── progress.md         # 작업 진행률 (%)
└── decisionLog.md      # 아키텍처/설계 결정 기록
```

### 사용법

```bash
# 프로젝트에 Memory Bank 초기화
cp -r project-templates/.context .

# 세션 시작 시
Claude: ".context/ 확인하고 이어서 작업"

# 세션 종료 전
Claude: "진행 상황 저장해줘"
```

---

## 사용 예시

```bash
# Testing & Review
Run tests and commit              # reviewer → testing/pre-commit
Run E2E tests with Playwright     # reviewer → testing/webapp-testing
Debug this flaky test             # reviewer → testing/systematic-debugging
Review my PR before merge         # reviewer → git/requesting-code-review

# Development
Create a data pipeline            # data-engineer → development/schema-design, testing/tdd
Build a user registration form    # web-dev → development/frontend-design, testing/tdd
This query is slow                # data-engineer → development/perf-optimize

# Infrastructure
Setup docker-compose              # devops → devops/mcp-setup
Create MCP server for Postgres    # devops → devops/mcp-builder

# Documentation
Create a PDF report               # docs-writer → office/pdf
Generate PowerPoint slides        # docs-writer → office/pptx
Create a new skill                # docs-writer → docs/skill-creator

# Planning & Collaboration
Plan this feature implementation  # general-helper → planning/writing-plans
Discuss design options            # general-helper → planning/brainstorming
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

## 스킬 소스

| 소스 | 저장소 | 스킬 수 |
|------|--------|---------|
| Anthropic Official | [anthropics/skills](https://github.com/anthropics/skills) | 16 |
| obra/superpowers | [obra/superpowers](https://github.com/obra/superpowers) | 14 |
| Custom | 이 저장소 | 7 |

---

## 라이선스

MIT License

Anthropic 공식 스킬은 Apache 2.0 라이선스입니다.
