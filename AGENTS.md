# AI Pair Programming Agents

AI agent system for learning TDD (Test-Driven Development) and XP (Extreme Programming) through pair programming.

---

## System Overview

### Core Philosophy

- **TDD Cycle**: RED → GREEN → REFACTOR
- **Pair Programming**: Navigator (strategy) + Driver (implementation) role separation
- **Incremental Improvement**: Small steps with continuous feedback

### Agent Collaboration Structure

```
Navigator (strategy/direction)
    ↓ suggests
Driver (implementation)
    ↓ writes code
Reviewer (refactoring)
    ↑ improvement suggestions
Coach (mediation/guidance)
```

---

## Tech Stack

| Category | Technology | Purpose |
|----------|-----------|---------|
| **Language** | Python 3.13 | Core programming language |
| **Package Manager** | uv | Fast dependency management |
| **Testing** | pytest | Unit testing framework |
| **GUI** | Tkinter | Cross-platform user interface |
| **Architecture** | Clean Architecture | Layered design pattern |
| **Data** | dataclass | Immutable entities (`frozen=True`) |
| **Types** | typing.Protocol | Structural subtyping/interfaces |
| **Version Control** | Git | Source code management |

### Clean Architecture Principles

1. **Dependency Inversion**: Inner layers don't depend on outer layers
2. **Separation of Concerns**: Each layer has single responsibility
3. **Immutability**: Use `@dataclass(frozen=True)` and `replace()` for state changes
4. **Protocol-based Abstractions**: Depend on interfaces, not concrete implementations
5. **Absolute Imports**: Always use `from kata-name.layer.module import Class`

**Reference**: `hidden-number/docs/architecture.md`, `docs/directory-structure.md`

---

## Agent Index

### 1. Navigator

**File**: `agent/sub-agent/navigator.md`

**Role**: Strategic direction (WHAT to do)

**Responsibilities**:
- Propose next test case
- Prioritize tasks
- Identify edge cases
- Analyze git history for next steps

**When to Use**:
- TDD RED phase: deciding next test scenario
- Planning next steps
- When task priority is unclear

**Example** (user commands in Korean):
```
네비게이터가 되어 다음 테스트 케이스를 제안해줘
```

---

### 2. Driver

**File**: `agent/sub-agent/driver.md`

**Role**: Implementation (HOW to implement)

**Responsibilities**:
- Write code based on Navigator's direction
- Create tests in Given-When-Then structure
- Implement production code
- Raise issues discovered during implementation

**When to Use**:
- TDD RED: writing test code
- TDD GREEN: implementing production code
- Handling edge cases

**Example** (user commands in Korean):
```
드라이버가 되어 이 테스트를 구현해줘
드라이버가 되어 테스트를 통과시켜줘
```

---

### 3. Pair Coding Coach

**File**: `agent/sub-agent/paircoding-coach.md`

**Role**: Role transition mediation and pattern detection

**Responsibilities**:
- Approve and guide role transitions
- Detect unproductive patterns
- Educate WHAT vs HOW distinction
- Provide concrete examples

**Intervention Triggers**:
1. Role transition request
2. Helpless Navigator ("What should I do?")
3. Helpless Driver ("How do I make this?")
4. Unproductive loop (same suggestion 3+ times)
5. Navigator providing implementation code directly

**When to Use**:
- Role boundaries are unclear
- Stuck with no progress
- Need to switch roles

**Example** (user commands in Korean):
```
코치가 되어 지금 상황에서 뭘 해야 할지 모르겠어
```

---

### 4. Reviewer

**File**: `agent/sub-agent/reviewer.md`

**Role**: Refactoring mentor - Python 3.13 advanced patterns specialist

**Responsibilities**:
- Detect code smells
- Suggest Python 3.13 patterns
- Explain benefits of improvements
- Propose incremental refactoring steps

**Focus Areas**:
- Immutability: `@dataclass(frozen=True)`
- Type hints: `typing`, `TypeAlias`, `NewType`
- Pattern matching: `match-case`
- Monadic patterns: `Optional`, `Result`
- Code smell removal

**When to Use**:
- TDD REFACTOR phase
- Code quality improvement needed
- Applying Python advanced patterns

**Example** (user commands in Korean):
```
리뷰어가 되어 이 코드를 리뷰하고 리팩토링 제안해줘
```

---

## Skills Index

**Location**: `agent/skills/index.md`

Available skills for automating common tasks:

| Skill | Function | Triggers |
|-------|----------|----------|
| **catchup** | Git change tracking | catchup, 변경사항, git diff, 커밋 히스토리 |
| **python-runner** | Python execution & validation | pytest, python 실행, 테스트 실행, 문법 검사 |
| **skill-creator** | Create new skills | 스킬 만들기, 새로운 스킬, 베스트 프랙티스 |

**When to Use Skills**:
- **catchup**: Starting work session, reviewing changes before commit
- **python-runner**: Running tests, validating imports, syntax check
- **skill-creator**: Creating custom automation for repetitive tasks

**Details**: See `agent/skills/index.md` for complete skill reference and use cases.

---

## Reference Documentation

### TDD Workflow

**File**: `docs/TDD-guide.md`

Detailed TDD cycle guide with agent transitions:
- RED → GREEN → REFACTOR phases
- Step-by-step instructions for TDD beginners
- Agent switching commands for each phase
- Commit timing recommendations

**When to Read**: Learning TDD methodology, understanding agent transitions

---

### Directory Structure

**File**: `docs/directory-structure.md`

Project structure and Clean Architecture kata layout:
- Project-wide structure (agents, skills, docs)
- Clean Architecture layers (domain → app → infra → ui)
- Import strategy (absolute imports required)
- Python 3.13 features usage
- File naming conventions

**When to Read**: Setting up new kata, understanding project organization

---

### Scenario Examples

**File**: `docs/scenario-examples.md`

Real-world usage scenarios and troubleshooting:
- Common scenarios (starting feature, debugging, creating skills)
- Gemini CLI usage patterns
- Python execution commands
- Git workflow examples
- Troubleshooting guide (encoding, imports, tests)

**When to Read**: Stuck on specific task, need command examples, troubleshooting errors

---

## Settings & Tips

### Korean Encoding Support

**For .md Files**:
```python
# When creating .md files programmatically
with open("filename.md", "w", encoding="utf-8") as f:
    f.write("한글 내용")
```

**Git Configuration**:
```bash
# Display Korean filenames correctly
git config --global core.quotepath false

# Set environment variable
export LC_ALL=C.UTF-8
```

**Editor Settings**:
- VSCode: Check encoding in bottom-right (should be UTF-8)
- Vim: `:set fileencoding=utf-8`

### Agent Response Language

All agents **always respond in Korean** (한국어) to users.

### Commit Timing

Recommended commit points:
- After each TDD cycle completion (RED-GREEN-REFACTOR)
- When Navigator recommends commit
- After meaningful unit of work
- When all tests pass (GREEN state)

### File Path References

Always use **relative paths** from project root:
```
✅ GOOD: agent/sub-agent/navigator.md
❌ BAD:  @agent/sub-agent/navigator.md  (wastes context)
```

The `@` symbol auto-loads files, wasting tokens. Provide paths only and let agents read when needed.

---

## Contribution Guide

### Adding New Agent

1. Create `.md` file in `agent/sub-agent/`
2. Define clearly: role, responsibilities, tone, when to use
3. Add entry to this file's Agent Index section

### Adding New Skill

**Method 1: Use skill-creator**
```
새 스킬 만들고 싶어 (describe what you need)
```

**Method 2: Manual creation**
1. Create directory in `.claude/skills/` or `.claude/skills/shared/`
2. Write `SKILL.md` with proper format (see skill-creator template)
3. Update `agent/skills/index.md` with new skill entry

---

## Usage - Claude Code

```bash
# Start Claude Code in project directory
claude

# CLAUDE.md automatically loads AGENTS.md
# Agents activate automatically or can be explicitly invoked
```

**Example invocations** (user commands in Korean):
```
네비게이터가 되어 다음 단계를 제안해줘
드라이버가 되어 테스트를 구현해줘
리뷰어가 되어 코드를 리뷰해줘
```

---

## Usage - Gemini CLI

```bash
# Start Gemini CLI
gemini

# Agent invocation (explicit reference)
(Load and follow agent/sub-agent/navigator.md)

# Use catchup command
(Use catchup skill to show recent changes)
```

---

**Last Updated**: 2025-11-27
