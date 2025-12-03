# Contributing Guide

Guidelines for adding agents, skills, and maintaining documentation.

---

## Adding New Agent

### 1. Create Agent File

Location: `agent/sub-agent/[agent-name].md`

**Template**:
```markdown
# ROLE
You are a [role description]

# AVAILABLE SKILLS
../../.claude/skills/catchup/SKILL.md
../../.claude/skills/skill-creator/SKILL.md

# CONTEXT
- [Primary responsibility]
- [Focus areas]
- [Guiding principles]

# CORE RESPONSIBILITIES
1. **[Responsibility 1]**: [Description]
2. **[Responsibility 2]**: [Description]

# COMMUNICATION RULES
## Language Output
- **ALWAYS respond in Korean (한국어)**
- Use [tone]: "[example phrases]"
- Be concise

## Encoding Safety
- Always include `# -*- coding: utf-8 -*-` in code examples
- Ensure UTF-8 encoding for Korean comments

# [SPECIFIC FOCUS AREAS]
## 1. [Focus Area 1]
- [Details]

# RESPONSE FORMAT
[Define expected response structure]

# EXAMPLES
[Provide 3-5 examples with <thinking> tags]
```

### 2. Update Agent Index

File: `agent/sub-agent/index.md`

Add entry to:
- Quick Reference table
- Agent Specifications section

### 3. Update AGENTS.md

File: `AGENTS.md`

**NO changes needed** - AGENTS.md references `agent/sub-agent/index.md`

---

## Adding New Skill

### Method 1: Use skill-creator (Recommended)

```
새 스킬을 만들고 싶은데 도와줘
```

skill-creator will guide you through the process.

### Method 2: Manual Creation

#### Step 1: Create Skill Directory

```bash
mkdir -p .claude/skills/[skill-name]
```

#### Step 2: Write SKILL.md

Location: `.claude/skills/[skill-name]/SKILL.md`

**Format**:
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

#### Step 3: Create usage-guide.md (Optional but recommended)

Location: `.claude/skills/[skill-name]/usage-guide.md`

**Contains**:
- Detailed feature breakdown
- Extended use cases
- Platform-specific notes
- Advanced examples

#### Step 4: Update Skill Index

File: `agent/skills/index.md`

Add entry to Quick Reference table

---

## Updating Documentation

### File Organization Rules

1. **200-line target**: Keep files under 200 lines when possible
2. **Single source of truth**: Don't duplicate content
3. **Reference over repeat**: Use file paths to reference detailed content
4. **English for prompts**: Agent prompts in English
5. **Korean for users**: Examples and user-facing content in Korean

### Token Optimization

1. **NO @ symbols**: Use relative paths only (e.g., `agent/sub-agent/navigator.md`)
2. **Compact descriptions**: Clear context in minimal words
3. **Avoid redundancy**: Content lives in one place only
4. **Reference format**:
   ```
   **Details**: See `path/to/file.md` for [specific content description]
   ```

### When to Split Files

Split when:
- File exceeds 250 lines
- Content serves different purposes (index vs guide)
- Detail level varies (quick ref vs comprehensive)

Don't split when:
- Content is cohesive and under 200 lines
- Splitting would create more redundancy
- File serves single, clear purpose

---

## Documentation Structure Principles

### Index Files

**Purpose**: Navigation, quick reference, pointers to details

**Examples**:
- `AGENTS.md` - System overview + references
- `agent/sub-agent/index.md` - Agent specs + TDD transitions
- `agent/skills/index.md` - Skill triggers + activation
- `docs/index.md` - Documentation navigation hub

**Keep**: Tables, summaries, "when to read X" guides

**Don't include**: Full content that exists elsewhere

### Guide Files

**Purpose**: Teach concepts, provide workflows

**Examples**:
- `docs/TDD-guide.md` - TDD methodology
- `docs/directory-structure.md` - Project structure + Clean Arch
- `docs/scenario-examples.md` - Real-world scenarios

**Keep**: Explanations, examples, troubleshooting

**Don't include**: Redundant index information

### Reference Files

**Purpose**: Complete specification, detailed docs

**Examples**:
- `agent/sub-agent/navigator.md` - Full Navigator prompt
- `.claude/skills/catchup/SKILL.md` - Complete skill definition
- `.claude/skills/catchup/usage-guide.md` - Detailed usage

**Keep**: Full specifications, all details

**Don't include**: Summary information (that goes in indexes)

---

## Updating AGENTS.md

**IMPORTANT**: Use `.claude/commands/update-agents.md` command for guidance

### Current Structure (Target: ~100 lines)

```
1. System Overview (~25 lines)
2. Tech Stack + Clean Arch Principles (~25 lines)
3. Agent Index (1-line reference)
4. Skills Index (1-line reference)
5. Documentation Index (1-line reference)
6. Settings & Tips (~30 lines)
```

### What NOT to put in AGENTS.md

- ❌ Full agent descriptions (use `agent/sub-agent/index.md`)
- ❌ TDD cycle details (use `agent/sub-agent/index.md`)
- ❌ Skill details (use `agent/skills/index.md`)
- ❌ Documentation descriptions (use `docs/index.md`)
- ❌ Contribution guide (use `docs/contributing.md`)
- ❌ Usage examples (use `docs/scenario-examples.md`)

### What to KEEP in AGENTS.md

- ✅ System overview (philosophy, collaboration structure)
- ✅ Tech stack table
- ✅ Clean Architecture principles (5-line summary)
- ✅ References to index files (1 line each)
- ✅ Settings & Tips (encoding, commit timing, file paths)

---

## Versioning

Update "Last Updated" date when making significant changes:

```markdown
**Last Updated**: 2025-11-27
```

---

## Testing Changes

Before committing documentation updates:

1. **Check file size**: `wc -l [file]` - should be ≤200 lines ideally
2. **Verify links**: Ensure referenced files exist
3. **Check encoding**: Korean text should display correctly
4. **Test navigation**: Follow references to ensure they lead to right content

---

**Last Updated**: 2025-11-27
