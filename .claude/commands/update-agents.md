# Update AGENTS.md Command

Guidelines for updating AGENTS.md while maintaining token optimization and structure.

---

## Current Structure (Target: ~100 lines)

```markdown
# AI Pair Programming Agents

[Introduction sentence]

---

## System Overview

### Core Philosophy
[3 bullet points]

### Agent Collaboration Structure
[ASCII diagram]

---

## Tech Stack

[Table: Category | Technology | Purpose]

### Clean Architecture Principles
[5 numbered principles with 1-line descriptions]

**Reference**: `hidden-number/docs/architecture.md`, `docs/directory-structure.md`

---

## Agent Index

**Location**: `agent/sub-agent/index.md`

[1-2 sentences describing what's in that file]

---

## Skills Index

**Location**: `agent/skills/index.md`

[1-2 sentences describing what's in that file]

---

## Documentation

**Location**: `docs/index.md`

[1-2 sentences about documentation navigation]

---

## Settings & Tips

### Korean Encoding Support
[Code examples for .md files, git config, editor settings]

### Agent Response Language
[1 sentence]

### Commit Timing
[4 bullet points]

### File Path References
[Example showing @ vs plain path]

---

**Last Updated**: YYYY-MM-DD
```

---

## Content Rules

### MUST INCLUDE
1. System Overview (philosophy + collaboration diagram)
2. Tech Stack table (8-10 technologies)
3. Clean Architecture Principles (5 principles, 1 line each)
4. References to index files (agent, skills, docs)
5. Settings & Tips (encoding, commit timing, file paths)

### MUST NOT INCLUDE
- ❌ Full agent descriptions → use `agent/sub-agent/index.md`
- ❌ TDD cycle steps → use `agent/sub-agent/index.md`
- ❌ Skill details/triggers → use `agent/skills/index.md`
- ❌ Doc descriptions → use `docs/index.md`
- ❌ Contribution guide → use `docs/contributing.md`
- ❌ Usage examples → use `docs/scenario-examples.md`
- ❌ Agent "Example" commands → keep in `agent/sub-agent/index.md`

---

## Token Optimization Rules

### 1. No @ Symbols
```markdown
✅ GOOD: agent/sub-agent/navigator.md
❌ BAD: (at)agent/sub-agent/navigator.md (auto-loads, wastes tokens) ((at) == @)
```

### 2. Reference Format
```markdown
**[Section Name]**: See `path/to/file.md` for [what it contains in 5-10 words].
```

### 3. Compact Descriptions
Be specific about WHEN to read referenced file:

```markdown
❌ TOO VAGUE:
**Agent Index**: See `agent/sub-agent/index.md`

✅ GOOD:
**Agent Index**: See `agent/sub-agent/index.md` for agent specifications, responsibilities, and TDD cycle transitions.
```

### 4. English for Prompts, Korean for Examples
```markdown
# English
**Role**: Strategic direction (WHAT to do)

# Korean (only in user command examples)
**Example**: `네비게이터가 되어 다음 테스트 케이스를 제안해줘`
```

---

## File Size Target

- **Target**: ~100 lines total
- **Maximum**: 120 lines
- **Check**: `wc -l AGENTS.md`

If exceeding 120 lines:
1. Check for redundant content (should be in other files)
2. Shorten descriptions (be more concise)
3. Remove examples (move to scenario-examples.md)
4. Consolidate sections

---

## Reference File Descriptions

### agent/sub-agent/index.md
**What to say**:
```markdown
**Agent Index**: See `agent/sub-agent/index.md` for complete agent specifications, TDD cycle transitions, and command examples.
```

**Don't say**: "For agent details..." (too vague)

### agent/skills/index.md
**What to say**:
```markdown
**Skills**: See `agent/skills/index.md` for skill triggers, activation methods, and use case mappings.
```

**Don't say**: "For skills..." (too vague)

### docs/index.md
**What to say**:
```markdown
**Documentation**: See `docs/index.md` for documentation navigation and guide selection by task.
```

**Don't say**: "For docs..." (too vague)

---

## Updating Process

### Step 1: Read Current AGENTS.md
```bash
cat AGENTS.md
wc -l AGENTS.md
```

### Step 2: Identify Changes Needed
- What content should move to other files?
- What new content needs adding?
- What references need updating?

### Step 3: Make Changes
- Edit AGENTS.md
- Update referenced files if needed
- Maintain ~100 line target

### Step 4: Verify
```bash
# Check size
wc -l AGENTS.md  # Should be ~100

# Verify no @ symbols
grep -n '@' AGENTS.md  # Should return nothing

# Check Korean only in examples
grep -n '한글' AGENTS.md  # Should only appear in example commands
```

### Step 5: Update Date
```markdown
**Last Updated**: 2025-11-27
```

---

## Common Mistakes to Avoid

1. **Including full agent specs** → Move to `agent/sub-agent/index.md`
2. **Listing all skills with details** → Keep only table, details in `agent/skills/index.md`
3. **Describing each doc file** → Reference `docs/index.md` instead
4. **Using @ for paths** → Use plain relative paths
5. **Exceeding 120 lines** → Extract content to appropriate files
6. **Vague references** → Be specific about what each referenced file contains

---

## Quick Checklist

Before finalizing AGENTS.md update:

- [ ] File is ~100 lines (max 120)
- [ ] No @ symbols in file paths
- [ ] References are specific (not vague)
- [ ] Korean only in user command examples
- [ ] No redundant content (content should live in one place)
- [ ] All referenced files exist
- [ ] Last Updated date is current
- [ ] Follows structure template above

---

**Last Updated**: 2025-11-27
