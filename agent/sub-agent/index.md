# Agent Index & TDD Workflow

Complete agent reference and TDD cycle transitions for pair programming.

---

## Quick Reference

| Agent | File | Role | When to Use |
|-------|------|------|-------------|
| **Navigator** | `navigator.md` | Strategic direction (WHAT) | TDD RED phase, planning, prioritization |
| **Driver** | `driver.md` | Implementation (HOW) | TDD RED/GREEN, writing tests and code |
| **Coach** | `paircoding-coach.md` | Role mediation | Stuck, unclear roles, unproductive patterns |
| **Reviewer** | `reviewer.md` | Refactoring mentor | TDD REFACTOR phase, code quality improvement |

---

## Agent Specifications

**For detailed agent prompts, read individual .md files in `agent/sub-agent/`**

### Navigator (`navigator.md`)
- **Role**: Strategic direction (WHAT)
- **Use**: TDD RED phase, planning, prioritization
- **Command**: `네비게이터가 되어 다음 테스트 케이스를 제안해줘`

### Driver (`driver.md`)
- **Role**: Implementation (HOW)
- **Use**: TDD RED/GREEN, writing tests/code
- **Command**: `드라이버가 되어 이 테스트를 구현해줘`

### Coach (`paircoding-coach.md`)
- **Role**: Role mediation, pattern detection
- **Use**: Stuck, unclear roles, unproductive patterns
- **Command**: `코치가 되어 지금 상황에서 뭘 해야 할지 모르겠어`

### Reviewer (`reviewer.md`)
- **Role**: Refactoring mentor, Python 3.13 specialist
- **Use**: TDD REFACTOR phase, code quality
- **Focus**: Immutability, types, pattern matching, FP, monads, code smells
- **Command**: `리뷰어가 되어 이 코드를 리뷰해줘`

---

## TDD Cycle Agent Transitions

### Phase 1: RED - Write Failing Test

#### Step 1: Strategy (Navigator)

**Command**:
```
네비게이터가 되어 다음 테스트 케이스를 제안해줘
```

**Navigator provides**:
- Next test scenario
- Priority justification
- Edge cases to consider

---

#### Step 2: Write Test (Driver)

**Command**:
```
드라이버가 되어 이 시나리오를 테스트 코드로 작성해줘
```

**Driver provides**:
- Given-When-Then structured test
- pytest format
- Clear assertions

---

#### Step 3: Verify RED

Run: `pytest`

Expected: Test fails (RED state)

---

### Phase 2: GREEN - Make Test Pass

#### Step 4: Minimal Implementation (Driver)

**Command**:
```
드라이버가 되어 이 테스트를 통과시켜줘
```

**Driver provides**:
- Minimal code to pass test
- Fast feedback over perfection

---

#### Step 5: Verify GREEN

Run: `pytest`

Expected: All tests pass (GREEN state)

---

### Phase 3: REFACTOR - Improve Code

#### Step 6: Code Review (Reviewer)

**Command**:
```
리뷰어가 되어 이 코드를 리뷰해줘
```

**Reviewer checks**:
- Code smells
- Python 3.13 patterns
- Immutability
- Type hints
- Pattern matching opportunities
- Functional programming (pure functions)
- Monadic patterns

**Reviewer provides**:
- Detected smells
- Improvement suggestions
- Benefits (concise)
- Before/After code

---

#### Step 7: Apply Refactoring (Driver)

**Command**:
```
드라이버가 되어 리뷰어 제안을 적용해줘
```

**Driver applies refactoring while maintaining GREEN**

Run: `pytest`

Expected: Still GREEN after refactoring

---

#### Step 8: Plan Next (Navigator)

**Command**:
```
네비게이터가 되어 다음에 뭘 해야 할지 알려줘
```

**Navigator provides**:
- Next steps
- Commit recommendations
- Progress summary

---

## When Stuck

### Use Coach

**Situation**: Don't know what to do, roles unclear, no progress

**Command**:
```
코치가 되어 지금 상황에서 뭘 해야 할지 모르겠어
```

**Coach helps with**:
- Situation analysis
- Appropriate agent transition
- WHAT vs HOW distinction
- Pattern detection and intervention

---

## Summary Table

| Phase | Step | Agent | Command Pattern |
|-------|------|-------|-----------------|
| RED | 1 | Navigator | `네비게이터가 되어 다음 테스트 케이스를 제안해줘` |
| RED | 2 | Driver | `드라이버가 되어 이 시나리오를 테스트 코드로 작성해줘` |
| RED | 3 | - | `pytest` (expect FAIL) |
| GREEN | 4 | Driver | `드라이버가 되어 이 테스트를 통과시켜줘` |
| GREEN | 5 | - | `pytest` (expect PASS) |
| REFACTOR | 6 | Reviewer | `리뷰어가 되어 이 코드를 리뷰해줘` |
| REFACTOR | 7 | Driver | `드라이버가 되어 리뷰어 제안을 적용해줘` |
| REFACTOR | 8 | Navigator | `네비게이터가 되어 다음에 뭘 해야 할지 알려줘` |
| **Stuck** | - | Coach | `코치가 되어 지금 상황에서 뭘 해야 할지 모르겠어` |

---

**Last Updated**: 2025-11-27
