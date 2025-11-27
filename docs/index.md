# Documentation Index

Guide selection based on your current task or learning goal.

---

## Quick Navigation

| Document | Purpose | When to Read |
|----------|---------|--------------|
| **command-reference.md** | Gemini, Python, Git 명령어 모음 | 명령어 문법 필요, 트러블슈팅 |
| **agent-dialogue-guide.md** | 에이전트와 효과적으로 대화하는 방법 | TDD 학습 시작, 에이전트 활용법 |
| **TDD-guide.md** | TDD methodology for beginners | Learning TDD concepts and principles |
| **directory-structure.md** | Project & Clean Architecture layout | Setting up kata, understanding layers |
| **contributing.md** | Contribution guidelines | Adding agents/skills, documentation rules |

---

## TDD Workflow

**File**: `docs/TDD-guide.md`

**Contains**:
- What is TDD? (definition, benefits)
- Why use TDD? (motivation for learners)
- TDD flow overview (RED → GREEN → REFACTOR)
- Working with agents (when to use which)
- When stuck (Coach usage guide)
- Commit timing recommendations

**Read this when**:
- New to TDD methodology
- Want to understand the development flow
- Need guidance on agent collaboration
- Confused about what step comes next

**Complements**: `agent/sub-agent/index.md` (for detailed agent transitions)

---

## Directory Structure

**File**: `docs/directory-structure.md`

**Contains**:
- Clean Architecture overview (what, why, big picture)
- Project-wide structure (agents, skills, docs, katas)
- Clean Architecture kata layout (domain → app → infra → ui)
- Layer responsibilities (what each layer does)
- Import strategy (absolute imports required)
- Python 3.13 features usage
- File naming conventions

**Read this when**:
- Creating a new kata
- Understanding project organization
- Confused about which layer to put code in
- Import errors occur
- Want Clean Architecture big picture

**Complements**: `hidden-number/docs/architecture.md` (kata-specific details)

---

## Command Reference

**File**: `docs/command-reference.md`

**Contains** (Korean):
- Gemini CLI commands (setup, execution)
- Python commands (pytest, execution, syntax check)
- Git workflow commands (status, branch, commit)
- Agent invocation commands
- Skill usage commands
- Troubleshooting (encoding, imports, tests)

**Read this when**:
- Need command syntax
- Troubleshooting errors
- Quick reference needed

---

## Agent Dialogue Guide

**File**: `docs/agent-dialogue-guide.md`

**Contains** (Korean):
- How to interact with each agent (Navigator, Driver, Reviewer, Coach)
- TDD cycle dialogue flows (RED-GREEN-REFACTOR)
- Learning-focused conversation patterns
- Real dialogue examples
- Session flow checklist

**Read this when**:
- Starting TDD learning
- Want to learn effectively with agents
- Unsure how to respond to agent suggestions

---

## Contributing

**File**: `docs/contributing.md`

**Contains**:
- Adding new agent
- Adding new skill
- Updating documentation
- File organization rules
- Token optimization guidelines

**Read this when**:
- Want to add new agent or skill
- Contributing to project
- Understanding documentation structure

---

## Selection Guide by Situation

### I'm new to this project
1. Start: `docs/TDD-guide.md` (understand methodology)
2. Then: `docs/directory-structure.md` (understand structure)
3. Keep handy: `docs/scenario-examples.md` (for command reference)

### I want to start a new kata
1. Read: `docs/directory-structure.md` (Clean Arch layers)
2. Reference: `hidden-number/` as example structure
3. Use: `docs/TDD-guide.md` (for development flow)

### I'm stuck / encountering errors
1. Check: `docs/scenario-examples.md` (troubleshooting section)
2. If unclear: Use Coach agent (`코치가 되어 상황 설명`)
3. For imports: `docs/directory-structure.md` (import strategy)

### I want to understand agents
1. Quick ref: `agent/sub-agent/index.md` (agent specs + TDD transitions)
2. Detailed: Read individual agent `.md` files in `agent/sub-agent/`
3. Workflow: `docs/TDD-guide.md` (when to use which agent)

### I want to use skills
1. Index: `agent/skills/index.md` (triggers, when to use)
2. Details: `.claude/skills/[skill-name]/SKILL.md` (full documentation)
3. Usage examples: `.claude/skills/[skill-name]/usage-guide.md`

### I need command syntax
1. Go to: `docs/scenario-examples.md` (quick reference cards)
2. For skills: `agent/skills/index.md` (skill commands)
3. For Git: `docs/scenario-examples.md` (Git workflow section)

---

## Documentation Structure

```
docs/
├── index.md                  # This file - navigation hub
├── TDD-guide.md              # TDD methodology for beginners
├── directory-structure.md    # Project & Clean Arch layout
├── scenario-examples.md      # Usage scenarios & troubleshooting
└── contributing.md           # Contribution guidelines

agent/
├── sub-agent/
│   ├── index.md              # Agent specs + TDD transitions
│   ├── navigator.md          # Navigator agent prompt
│   ├── driver.md             # Driver agent prompt
│   ├── paircoding-coach.md   # Coach agent prompt
│   ├── reviewer.md           # Reviewer agent prompt
│   └── tdd-coach.md          # Alias for paircoding-coach
│
└── skills/
    └── index.md              # Skills reference & activation

.claude/
└── skills/
    ├── catchup/
    │   ├── SKILL.md          # Main skill definition
    │   └── usage-guide.md    # Detailed usage examples
    ├── python-runner/
    │   ├── SKILL.md
    │   └── usage-guide.md
    └── skill-creator/
        ├── SKILL.md
        ├── usage-guide.md
        ├── template.md
        └── best-practices.md
```

---

## Master Index Files

- **AGENTS.md**: System overview, tech stack, references to all documentation
- **agent/sub-agent/index.md**: Complete agent reference + TDD transitions
- **agent/skills/index.md**: Skills trigger keywords + activation methods
- **docs/index.md**: This file - documentation navigation hub

---

**Last Updated**: 2025-11-27
