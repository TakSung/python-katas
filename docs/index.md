# Documentation Index

Guide selection based on your current task or learning goal.

---

## Quick Navigation

| Document | Purpose | When to Read |
|----------|---------|--------------|
| **TDD-guide.md** | TDD methodology for beginners | Learning TDD, understanding RED-GREEN-REFACTOR |
| **directory-structure.md** | Project & Clean Architecture layout | Setting up kata, understanding layers |
| **scenario-examples.md** | Real-world usage & troubleshooting | Stuck on task, need command examples |

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

## Scenario Examples

**File**: `docs/scenario-examples.md`

**Contains**:
- Common scenarios (starting feature, debugging, creating skills)
- Gemini CLI / Claude Code usage patterns
- Python execution commands (`pytest`, `python -m`)
- Git workflow examples (fetch, pull, merge, checkout)
- Troubleshooting guide (encoding, imports, tests)
- Quick reference cards (TDD, Git, Python commands)

**Read this when**:
- Stuck on specific task
- Need command syntax examples
- Troubleshooting errors (imports, encoding, tests)
- Want quick command reference
- Using Gemini CLI for first time

**Complements**: `agent/skills/index.md` (for skill-specific commands)

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
