# Skills Index

Available AI skills for automating common tasks. Skills are automatically triggered by keywords or can be explicitly invoked.

---

## Quick Reference

| Skill | Location | Trigger Keywords | When to Use |
|-------|----------|------------------|-------------|
| **catchup** | `.claude/skills/catchup/` | catchup, 변경사항, git diff, 커밋 히스토리, 작업 내용 파악 | Track git changes, review uncommitted code, analyze commit history |
| **python-runner** | `.claude/skills/python-runner/` | python 실행, pytest, 테스트 실행, main.py 실행, 문법 검사 | Run Python files, execute tests, validate imports, syntax check |
| **skill-creator** | `.claude/skills/skill-creator/` | 스킬 만들기, 새로운 스킬, 스킬 작성, 베스트 프랙티스 | Create new skills, learn skill best practices |

---

## Skill Details

### 1. catchup

**Location**: `.claude/skills/catchup/SKILL.md`

**Function**: Git change tracking and summary

**Features**:
- Uncommitted changes (staged + unstaged)
- Latest commit details
- Recent 10 commits list
- Specific commit range analysis

**Trigger Keywords**:
- `catchup`
- `변경사항`
- `git diff`
- `커밋 히스토리`
- `작업 내용 파악`

**Use Cases**:
```
지금까지 작업 내용 catchup 해줘
최근 커밋 목록 보여줘
미커밋된 코드 변경사항 확인해줘
```

**Tools Allowed**: Bash, Read

**Platform**: Cross-platform (Linux/macOS/Windows)

---

### 2. python-runner

**Location**: `.claude/skills/python-runner/SKILL.md`

**Function**: Python project execution, testing, and validation

**Features**:
- Auto-activate `.venv` virtual environment
- Run `main.py` entry point
- Execute pytest tests
- Syntax validation (`py_compile`)
- Import verification (detect relative imports, missing package prefix)

**Trigger Keywords**:
- `python 실행`
- `pytest`
- `테스트 실행`
- `main.py 실행`
- `문법 검사`
- `임포트 검증`

**Use Cases**:
```
hidden-number 프로젝트 실행해줘
pytest로 테스트 돌려줘
이 파일 임포트 에러 있는지 확인해줘
```

**Tools Allowed**: Bash, Read, Grep, Glob

**Platform**: Cross-platform (Linux/macOS/Windows PowerShell)

**Key Commands**:
- Run main: `python -m hidden-number.main`
- Run tests: `pytest`
- Syntax check: `python -m py_compile file.py`
- Import test: `python -c "from module import Class"`

---

### 3. skill-creator

**Location**: `.claude/skills/skill-creator/SKILL.md`

**Function**: Create new Claude skills with best practices

**Features**:
- Interview-based skill creation process
- Auto-generate skill structure
- Apply best practices automatically
- Skill validation checklist

**Trigger Keywords**:
- `스킬 만들기`
- `새로운 스킬`
- `스킬 작성`
- `베스트 프랙티스`

**Use Cases**:
```
데이터베이스 마이그레이션 스킬 만들고 싶어
API 문서 생성하는 스킬 필요해
스킬 작성할 때 베스트 프랙티스가 뭐야?
```

**Tools Allowed**: Write, Read, Bash, Glob

**Supporting Files**:
- Template: `.claude/skills/skill-creator/template.md`
- Best Practices: `.claude/skills/skill-creator/best-practices.md`

**Output**: New skill directory in `.claude/skills/[skill-name]/`

---

## Use Case → Skill Mapping

### Scenario: Starting a new work session

**Goal**: Understand current project state

**Skill**: catchup

**Command**:
```
지금까지 작업 내용 catchup 해줘
```

**What it provides**:
- Uncommitted changes summary
- Latest commit message
- Recent commit history
- File change statistics

---

### Scenario: Running tests after implementation

**Goal**: Verify code correctness

**Skill**: python-runner

**Command**:
```
pytest로 테스트 실행해줘
```

**What it does**:
- Activates `.venv` automatically
- Runs pytest with proper configuration
- Shows test results with pass/fail status
- Identifies failing test cases

---

### Scenario: Import errors in kata

**Goal**: Validate absolute imports

**Skill**: python-runner

**Command**:
```
hidden-number 프로젝트 임포트 검증해줘
```

**What it checks**:
- Relative imports (forbidden)
- Missing package prefix (e.g., `from domain.game` instead of `from hidden-number.domain.game`)
- Import execution test
- Syntax validation

---

### Scenario: Need a custom automation

**Goal**: Create a new skill for repetitive task

**Skill**: skill-creator

**Command**:
```
[작업 설명] 스킬 만들고 싶어
```

**Example**:
```
코드 커버리지 리포트 생성하는 스킬 만들고 싶어
```

**What it does**:
- Asks clarifying questions (name, function, tools needed)
- Generates skill structure
- Creates SKILL.md with proper format
- Applies best practices automatically

---

## How to Discover Skills

### Method 1: Ask the AI

```
사용 가능한 스킬 목록 보여줘
```

AI will list all available skills with descriptions.

### Method 2: Read skill files directly

```bash
# List all skills
ls .claude/skills/

# Read specific skill
cat .claude/skills/catchup/SKILL.md
cat .claude/skills/python-runner/SKILL.md
cat .claude/skills/skill-creator/SKILL.md
```

### Method 3: Check this index

Read this file: `agent/skills/index.md`

---

## Skill Activation

### Automatic Activation

Skills activate automatically when you use trigger keywords:

```
지금까지 변경사항 확인해줘
→ catchup skill activates

pytest 돌려줘
→ python-runner skill activates
```

### Explicit Invocation

You can explicitly call a skill:

```
catchup 스킬을 사용해서 작업 내용을 요약해줘
python-runner 스킬로 테스트를 실행해줘
```

---

## Shared Skills

**Location**: `.claude/skills/shared/`

**Purpose**: Common utilities used by multiple agents

**Available Shared Skills**:

### git-helper/

Git-related common operations:
- Branch management
- Commit message formatting
- Merge conflict detection

### test-runner/

Test execution utilities:
- Test discovery
- Test result parsing
- Coverage reporting

**Note**: Shared skills are typically used internally by agents rather than directly invoked by users.

---

## Creating Your Own Skill

### Quick Start

```
새 스킬을 만들고 싶은데 도와줘
```

skill-creator will guide you through:

1. **Skill naming** (kebab-case, max 64 chars)
2. **Description** (what it does + when to use, max 1024 chars)
3. **Key features** (list of functions)
4. **Required tools** (Bash, Read, Write, Grep, Glob, etc.)
5. **Usage examples** (how users will invoke it)

### Skill Structure

```
.claude/skills/[skill-name]/
├── SKILL.md              # Main skill file (required)
├── scripts/              # Optional: helper scripts
└── templates/            # Optional: file templates
```

### SKILL.md Format

```markdown
---
name: skill-name
description: What it does + when to use (include trigger keywords)
allowed-tools: Tool1, Tool2, Tool3
---

# Skill Title

Brief introduction

## Key Features

### Feature 1
Description and code examples

### Feature 2
Description and code examples

## Usage Examples

Example user commands and expected behavior
```

---

## Best Practices

### 1. Clear Trigger Keywords

Include specific, memorable keywords in the description:

```markdown
description: Git 저장사항을 추적합니다. catchup, 변경사항, git diff 등의 키워드에 반응합니다.
```

### 2. Cross-Platform Support

Detect platform and use appropriate commands:

```bash
# Detect platform
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
  # Windows commands
else
  # Linux/macOS commands
fi
```

### 3. UTF-8 Encoding

Always set proper encoding for Korean support:

```bash
export LC_ALL=C.UTF-8
git -c core.quotepath=false status
```

### 4. Error Handling

Provide clear error messages:

```bash
if [ ! -d ".venv" ]; then
  echo "❌ Virtual environment not found. Run: python -m venv .venv"
  exit 1
fi
```

### 5. Documentation

Document all features with examples in SKILL.md.

---

## Skill Management

### Updating a Skill

1. Read current skill: `cat .claude/skills/[skill-name]/SKILL.md`
2. Edit the SKILL.md file
3. Test the skill with sample commands
4. Update this index if triggers or features change

### Removing a Skill

```bash
rm -rf .claude/skills/[skill-name]/
```

Then update this index to remove references.

### Listing All Skills

```bash
find .claude/skills -name "SKILL.md" -type f
```

---

## Additional Resources

- **Skill Creation Guide**: `.claude/skills/skill-creator/SKILL.md`
- **Best Practices**: `.claude/skills/skill-creator/best-practices.md`
- **Skill Template**: `.claude/skills/skill-creator/template.md`
- **Agent System**: `AGENTS.md`
- **TDD Guide**: `docs/TDD-guide.md`
- **Scenario Examples**: `docs/scenario-examples.md`

---

**Last Updated**: 2025-11-27
