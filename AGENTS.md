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

**Location**: `agent/sub-agent/index.md`

Complete agent specifications (Navigator, Driver, Coach, Reviewer), TDD cycle transitions (RED-GREEN-REFACTOR), and agent command examples.

---

## Skills Index

**Location**: `agent/skills/index.md`

Skill triggers, activation methods (automatic/explicit), and use case mappings for catchup, python-runner, and skill-creator.

---

## Documentation

**Location**: `docs/index.md`

Documentation navigation hub with guide selection by task: TDD workflow, directory structure, scenario examples, and contributing.

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
❌ BAD:  (at)agent/sub-agent/navigator.md  (wastes context) ((at) == @)
```

The `@` symbol auto-loads files, wasting tokens. Provide paths only and let agents read when needed.

---

**Last Updated**: 2025-11-27
