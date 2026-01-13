# Claude Code Sub-agents & Skills Templates

전역 및 프로젝트 레벨에서 사용할 수 있는 Claude Code 템플릿 모음입니다.

> **v2.0**: Anthropic 공식 스킬 + obra/superpowers 통합 + AI-Ops 에이전트
> - 스킬: 7개 → **37개**
> - 에이전트: 6개 → **10개** (AI-Ops 특화 추가)
> - Memory Bank: 세션 간 컨텍스트 유지

## 구조

```
~/.claude/                         # 전역 설정 (global-templates/ 복사)
├── CLAUDE.md
├── settings.json
├── agents/*.md
└── skills/<skill-name>/SKILL.md   # 평탄화된 구조
```

```
├── global-templates/              # → ~/.claude/에 복사
│   ├── CLAUDE.md                 # 전역 지침
│   ├── settings.json             # 전역 설정
│   ├── agents/                   # 전역 agents (6개)
│   └── skills/                   # 전역 skills (36개)
│
├── project-templates/             # → 프로젝트에 복사
│   ├── CLAUDE.md                 # 프로젝트 지침
│   ├── .mcp.json                 # MCP 서버
│   └── .claude/                  # 프로젝트별 에이전트/스킬
│
└── external-skills/               # 원본 스킬 저장소 (참조용)
    ├── anthropics-skills/        # github.com/anthropics/skills
    └── obra-superpowers/         # github.com/obra/superpowers
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
cp -r /path/to/sub-agents/project-templates/* .
cp -r /path/to/sub-agents/project-templates/.* . 2>/dev/null
```

---

## 전역 Agents (10개)

### Core Agents (6개)
| Agent | 용도 | 모델 | 주요 Skills |
|-------|------|------|-------------|
| `reviewer` | Testing, Code Review, Git | haiku | pre-commit, webapp-testing, systematic-debugging |
| `data-engineer` | 데이터 파이프라인, ETL | opus | tdd, schema-design, writing-plans |
| `web-dev` | React, FastAPI 개발 | opus | frontend-design, webapp-testing, brainstorming |
| `devops` | Docker, K8s, 배포 | haiku | mcp-setup, mcp-builder, executing-plans |
| `docs-writer` | 문서화, 문서 생성 | haiku | docx, pdf, pptx, xlsx, skill-creator |
| `general-helper` | 코드베이스 탐색, Q&A | opus | brainstorming, writing-plans |

### AI-Ops Agents (4개)
| Agent | 용도 | 모델 | 주요 Skills |
|-------|------|------|-------------|
| `ux-qa` | Visual Testing, Accessibility, E2E | sonnet | webapp-testing, verification-before-completion |
| `cloud-aws` | AWS Lambda, CDK, IAM | sonnet | writing-plans, tdd, schema-design |
| `cloud-gcp` | GKE, Cloud Run, BigQuery | sonnet | perf-optimize, executing-plans |
| `finops` | 비용 최적화, 에러 분석 | haiku | systematic-debugging, executing-plans |

---

## 전역 Skills (37개)

### 🧪 Testing & Quality
| Skill | 용도 | 사용 Agent |
|-------|------|------------|
| `pre-commit` | 커밋 전 품질 검사 | reviewer |
| `webapp-testing` | E2E Playwright 테스트 | reviewer, web-dev |
| `test-driven-development` | RED-GREEN-REFACTOR 사이클 | reviewer, data-engineer |
| `systematic-debugging` | 4단계 근본 원인 분석 | reviewer, data-engineer |
| `verification-before-completion` | 수정 완료 전 검증 | reviewer |

### 🔀 Git & Code Review
| Skill | 용도 | 사용 Agent |
|-------|------|------------|
| `requesting-code-review` | 리뷰 요청 체크리스트 | reviewer |
| `receiving-code-review` | 피드백 반영 관리 | reviewer |
| `using-git-worktrees` | 병렬 브랜치 개발 | reviewer |
| `finishing-a-development-branch` | 머지/PR 결정 | reviewer |

### 🏗️ Development
| Skill | 용도 | 사용 Agent |
|-------|------|------------|
| `tdd` | TDD 기반 개발 | data-engineer, web-dev |
| `perf-optimize` | 속도/리소스 최적화 | data-engineer, web-dev |
| `schema-design` | 스키마 설계 및 검증 | data-engineer, web-dev |
| `frontend-design` | React + Tailwind 가이드 | web-dev |
| `web-artifacts-builder` | HTML artifact 빌드 | web-dev |

### 🤝 Collaboration
| Skill | 용도 | 사용 Agent |
|-------|------|------------|
| `brainstorming` | 소크라테스식 설계 토론 | general-helper, web-dev |
| `writing-plans` | 구현 계획 작성 | general-helper, data-engineer |
| `executing-plans` | 배치 실행 + 체크포인트 | devops, data-engineer |

### 🤖 Agent Orchestration
| Skill | 용도 | 사용 Agent |
|-------|------|------------|
| `dispatching-parallel-agents` | 동시 서브에이전트 워크플로우 | general-helper, data-engineer |
| `subagent-driven-development` | 2단계 리뷰 빠른 반복 | general-helper |

### 🔧 DevOps
| Skill | 용도 | 사용 Agent |
|-------|------|------------|
| `mcp-setup` | DB, Redis MCP 연결 설정 | devops |
| `mcp-builder` | MCP 서버 생성 | devops |

### 📝 Documentation
| Skill | 용도 | 사용 Agent |
|-------|------|------------|
| `skill-writer` | 기존 스킬 업데이트 | docs-writer |
| `skill-creator` | 새 스킬 생성 | docs-writer |
| `writing-skills` | 스킬 작성 베스트 프랙티스 | docs-writer |
| `context-summary` | 컨텍스트 정리 | docs-writer |
| `doc-coauthoring` | 문서 공동 작성 | docs-writer |

### 📄 Document Generation
| Skill | 용도 | 사용 Agent |
|-------|------|------------|
| `docx` | Word 문서 생성/편집 | docs-writer |
| `pdf` | PDF 조작 | docs-writer |
| `pptx` | PowerPoint 프레젠테이션 | docs-writer |
| `xlsx` | Excel 스프레드시트 | docs-writer |

### 🎨 Design
| Skill | 용도 |
|-------|------|
| `algorithmic-art` | p5.js 기반 생성 아트 |
| `canvas-design` | PNG/PDF 비주얼 아트 |
| `slack-gif-creator` | Slack용 애니메이션 GIF |
| `theme-factory` | 테마 생성 |

### 🏢 Enterprise
| Skill | 용도 |
|-------|------|
| `brand-guidelines` | 브랜드 가이드라인 |
| `internal-comms` | 내부 커뮤니케이션 |

### 🧠 Memory Bank
| Skill | 용도 |
|-------|------|
| `memory-bank` | 세션 간 컨텍스트 유지 (activeContext, progress, decisionLog) |

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
Run tests and commit              # reviewer → pre-commit
Run E2E tests with Playwright     # reviewer → webapp-testing
Debug this flaky test             # reviewer → systematic-debugging
Review my PR before merge         # reviewer → requesting-code-review

# Development
Create a data pipeline            # data-engineer → schema-design, tdd
Build a user registration form    # web-dev → frontend-design, tdd
This query is slow                # data-engineer → perf-optimize

# Infrastructure
Setup docker-compose              # devops → mcp-setup
Create MCP server for Postgres    # devops → mcp-builder

# Documentation
Create a PDF report               # docs-writer → pdf
Generate PowerPoint slides        # docs-writer → pptx
Create a new skill                # docs-writer → skill-creator

# Planning & Collaboration
Plan this feature implementation  # general-helper → writing-plans
Discuss design options            # general-helper → brainstorming
```

---

## 스킬 소스

| 소스 | 저장소 | 스킬 수 |
|------|--------|---------|
| Anthropic Official | [anthropics/skills](https://github.com/anthropics/skills) | 16 |
| obra/superpowers | [obra/superpowers](https://github.com/obra/superpowers) | 14 |
| Custom | 이 저장소 | 6 |

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

Anthropic 공식 스킬은 Apache 2.0 라이선스입니다.
