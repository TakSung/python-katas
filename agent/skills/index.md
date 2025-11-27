# Skills Index

Available AI skills for automating common tasks. Skills activate automatically via keywords or explicit invocation.

---

## Quick Reference

| Skill | Location | Triggers | When to Use |
|-------|----------|----------|-------------|
| **catchup** | `.claude/skills/catchup/` | catchup, 변경사항, git diff, 커밋 히스토리 | Track git changes, review uncommitted code, analyze commit history |
| **python-runner** | `.claude/skills/python-runner/` | pytest, python 실행, 테스트 실행, 문법 검사 | Run Python files, execute tests, validate imports, syntax check |
| **skill-creator** | `.claude/skills/skill-creator/` | 스킬 만들기, 새로운 스킬, 베스트 프랙티스 | Create new skills, learn skill best practices |

---

## Skill Activation

### Automatic Activation

Skills activate when trigger keywords appear:

```
지금까지 변경사항 확인해줘  → catchup skill activates
pytest 돌려줘  → python-runner skill activates
```

### Explicit Invocation

Directly reference skill:

```
catchup 스킬을 사용해서 작업 내용을 요약해줘
python-runner 스킬로 테스트를 실행해줘
```

---

## Skill Details

**For comprehensive documentation, see each skill's files**:

- **SKILL.md**: Complete skill definition with features and examples
- **usage-guide.md**: Detailed usage scenarios and platform-specific notes

### catchup

**File**: `.claude/skills/catchup/SKILL.md`

**Function**: Git change tracking and summary

**Key Features**:
- Uncommitted changes (staged + unstaged)
- Latest commit details
- Recent 10 commits list
- Commit range analysis

**Usage Example**:
```
지금까지 작업 내용 catchup 해줘
최근 커밋 목록 보여줘
```

**Tools**: Bash, Read | **Platform**: Cross-platform

---

### python-runner

**File**: `.claude/skills/python-runner/SKILL.md`

**Function**: Python execution, testing, and validation

**Key Features**:
- Auto-activate `.venv` virtual environment
- Run main.py entry point
- Execute pytest tests
- Syntax validation
- Import verification (detect relative imports, missing package prefix)

**Usage Example**:
```
hidden-number 프로젝트 실행해줘
pytest로 테스트 돌려줘
이 파일 임포트 에러 있는지 확인해줘
```

**Tools**: Bash, Read, Grep, Glob | **Platform**: Linux/macOS/Windows PowerShell

---

### skill-creator

**File**: `.claude/skills/skill-creator/SKILL.md`

**Function**: Create new Claude skills with best practices

**Key Features**:
- Interview-based skill creation
- Auto-generate skill structure
- Apply best practices
- Skill validation checklist

**Usage Example**:
```
데이터베이스 마이그레이션 스킬 만들고 싶어
스킬 작성할 때 베스트 프랙티스가 뭐야?
```

**Tools**: Write, Read, Bash, Glob

**Supporting Files**: `template.md`, `best-practices.md`

---

## How to Discover Skills

### Method 1: Ask AI
```
사용 가능한 스킬 목록 보여줘
```

### Method 2: Read Skill Files
```bash
ls .claude/skills/
cat .claude/skills/catchup/SKILL.md
```

### Method 3: Check This Index
Read `agent/skills/index.md` (this file)

---

**Last Updated**: 2025-11-27
