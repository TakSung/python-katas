# Directory Structure

프로젝트 전체 구조와 Clean Architecture 기반 Kata 구조를 설명합니다.

---

## Project-Wide Structure

```
python-katas/
├── .python-version           # Python 3.13 version lock
├── pyproject.toml            # Project config & dependencies
├── uv.lock                   # Dependency lock file
├── .venv/                    # Virtual environment
│
├── AGENTS.md                 # Agent system documentation (master index)
├── CLAUDE.md                 # Claude Code entry point
├── GEMINI.md                 # Gemini CLI entry point
├── README.md                 # Project overview & quick start
│
├── docs/                     # Project documentation
│   ├── TDD-guide.md          # TDD cycle with agent transitions
│   ├── directory-structure.md # This file
│   └── scenario-examples.md  # Usage scenarios & troubleshooting
│
├── .claude/                  # Claude Code configuration
│   ├── settings.local.json   # Claude settings
│   ├── commands/             # Custom slash commands
│   │   ├── catchup.md
│   │   ├── python-runner.md
│   │   └── skill-creator.md
│   └── skills/               # Reusable AI skills
│       ├── catchup/          # Git change tracking
│       ├── python-runner/    # Python execution & validation
│       ├── skill-creator/    # Skill creation helper
│       └── shared/           # Shared utilities
│           ├── git-helper/
│           └── test-runner/
│
├── .gemini/                  # Gemini CLI configuration
│   └── commands/             # Gemini commands (mirrors .claude)
│       ├── catchup.md
│       └── python-runner.md
│
├── agent/                    # AI Pair Programming Agents
│   ├── sub-agent/            # Agent definition files
│   │   ├── driver.md         # Driver agent (HOW - implementation)
│   │   ├── navigator.md      # Navigator agent (WHAT - strategy)
│   │   ├── paircoding-coach.md # Pair coding coach (mediation)
│   │   ├── reviewer.md       # Reviewer agent (refactoring mentor)
│   │   └── tdd-coach.md      # TDD coach (alias)
│   │
│   └── skills/               # Skills index
│       └── index.md          # Skill discovery & reference
│
└── {kata-name}/              # Each kata directory (Clean Architecture)
    ├── README.md             # Kata description & missions
    ├── main.py               # Entry point (Dependency Injection)
    │
    ├── domain/               # Domain Layer (pure business logic)
    │   ├── __init__.py
    │   └── *.py              # Entities, value objects
    │
    ├── app/                  # Application Layer (use cases)
    │   ├── __init__.py
    │   └── *.py              # Services, business logic
    │
    ├── infra/                # Infrastructure Layer (external deps)
    │   ├── __init__.py
    │   └── *.py              # Concrete implementations
    │
    ├── ui/                   # UI Layer
    │   ├── __init__.py
    │   └── *.py              # Tkinter GUI
    │
    ├── tests/                # Test suite
    │   ├── __init__.py
    │   └── test_*.py         # pytest unit tests
    │
    └── docs/                 # Kata documentation
        └── architecture.md   # Architecture design doc
```

---

## Clean Architecture Kata Structure

각 Kata는 Clean Architecture 원칙을 따라 구성됩니다.

### Reference Implementation: hidden-number/

```
hidden-number/
├── main.py                   # 🔧 Entry Point (DI Container)
├── README.md                 # 📖 Game rules & missions
│
├── domain/                   # 🎯 Domain Layer
│   ├── __init__.py
│   └── game.py               # Game entity (immutable dataclass)
│
├── app/                      # 💼 Application Layer
│   ├── __init__.py
│   └── game_service.py       # GameService (business logic)
│
├── infra/                    # 🔌 Infrastructure Layer
│   ├── __init__.py
│   └── random_generator.py  # RandomNumberGenerator (Protocol)
│
├── ui/                       # 🖥️ UI Layer
│   ├── __init__.py
│   └── tkinter_ui.py         # HiddenNumberUI (Tkinter GUI)
│
├── tests/                    # ✅ Test Suite
│   ├── __init__.py
│   ├── test_game.py
│   ├── test_game_service.py
│   └── test_random_generator.py
│
└── docs/
    └── architecture.md       # Detailed architecture guide
```

---

## Layer Responsibilities

### 1. Domain Layer (domain/)

**역할**: Pure business logic (순수 비즈니스 로직)

**특징**:
- No external dependencies (외부 의존성 없음)
- Immutable entities (`@dataclass(frozen=True)`)
- Value objects
- Business rules

**Example**:
```python
# domain/game.py
from dataclasses import dataclass

@dataclass(frozen=True)
class Game:
    answer: int
    attempts: int
    max_attempts: int
    is_finished: bool = False
```

**Import 규칙**:
```python
# ✅ ALLOWED - No external imports
from dataclasses import dataclass, replace
from typing import Optional
```

---

### 2. Application Layer (app/)

**역할**: Use cases & business services (유즈케이스 및 비즈니스 서비스)

**특징**:
- Orchestrates domain objects
- Contains business workflows
- Depends on domain layer only
- Uses Protocol for infrastructure abstractions

**Example**:
```python
# app/game_service.py
from hidden-number.domain.game import Game
from dataclasses import replace

class GameService:
    def make_guess(self, game: Game, guess: int) -> GuessResult:
        # Business logic here
        pass
```

**Import 규칙**:
```python
# ✅ ALLOWED
from hidden-number.domain.game import Game
from typing import Protocol

# ❌ FORBIDDEN
from hidden-number.infra.random_generator import RandomNumberGenerator  # Direct infra import
```

---

### 3. Infrastructure Layer (infra/)

**역할**: External dependencies & concrete implementations (외부 의존성 및 구체적 구현)

**특징**:
- Implements Protocol interfaces
- Database, file system, random generators, etc.
- Can depend on domain and app layers

**Example**:
```python
# infra/random_generator.py
from typing import Protocol

class NumberGenerator(Protocol):
    def generate(self, min: int, max: int) -> int:
        ...

class RandomNumberGenerator:
    def generate(self, min: int, max: int) -> int:
        import random
        return random.randint(min, max)
```

**Import 규칙**:
```python
# ✅ ALLOWED
from hidden-number.domain.game import Game
from hidden-number.app.game_service import GameService
import random  # External library
```

---

### 4. UI Layer (ui/)

**역할**: User interface (Tkinter GUI)

**특징**:
- Depends on app and domain layers
- No business logic (only presentation)
- Event handlers call app services

**Example**:
```python
# ui/tkinter_ui.py
from hidden-number.app.game_service import GameService
from hidden-number.domain.game import Game
import tkinter as tk

class HiddenNumberUI:
    def __init__(self, service: GameService):
        self.service = service
        # Tkinter setup here
```

**Import 규칙**:
```python
# ✅ ALLOWED
from hidden-number.app.game_service import GameService
from hidden-number.domain.game import Game
import tkinter as tk  # External library
```

---

### 5. Entry Point (main.py)

**역할**: Dependency Injection Container (의존성 주입 컨테이너)

**특징**:
- Wires all layers together
- Creates concrete implementations
- Injects dependencies
- Starts the application

**Example**:
```python
# main.py
from hidden-number.domain.game import Game
from hidden-number.app.game_service import GameService
from hidden-number.infra.random_generator import RandomNumberGenerator
from hidden-number.ui.tkinter_ui import HiddenNumberUI

def main():
    # Create concrete implementations
    random_gen = RandomNumberGenerator()
    service = GameService(random_gen)
    ui = HiddenNumberUI(service)

    # Start app
    ui.run()

if __name__ == "__main__":
    main()
```

---

## Dependency Flow

```
Domain Layer (domain/)
    ↑ depends on (imports from)
Application Layer (app/)
    ↑ depends on
Infrastructure Layer (infra/)
    ↑ implements
UI Layer (ui/) / Entry Point (main.py)
```

**핵심 원칙**:
- 의존성은 항상 안쪽(domain)을 향함
- Domain은 외부에 대해 아무것도 모름
- Infrastructure는 Protocol을 통해 추상화됨

---

## Import Strategy

### Absolute Imports (Required)

모든 임포트는 **절대 경로**를 사용해야 합니다.

**✅ CORRECT**:
```python
from hidden-number.domain.game import Game
from hidden-number.app.game_service import GameService
from hidden-number.infra.random_generator import RandomNumberGenerator
```

**❌ FORBIDDEN**:
```python
from .domain.game import Game              # Relative import
from domain.game import Game                # Missing package prefix
```

### Why Absolute Imports?

1. **명확성**: 모듈의 정확한 위치를 명시
2. **일관성**: 어디서 임포트하든 동일한 구문
3. **테스트 용이성**: pytest가 모듈을 정확히 찾을 수 있음
4. **도구 지원**: python-runner skill의 임포트 검증 기능

### Import Validation

`python-runner` skill은 다음을 자동으로 검증합니다:

```bash
# 1. Syntax check
python -m py_compile hidden-number/domain/game.py

# 2. Import test
python -c "from hidden-number.domain.game import Game"

# 3. Detection of forbidden patterns
# - Relative imports (from .domain import ...)
# - Missing package prefix (from domain import ...)
```

---

## File Naming Conventions

### Module Files

- **소문자 + 언더스코어**: `game_service.py`, `random_generator.py`
- **명사형**: 클래스/기능을 나타내는 명사 사용

### Test Files

- **Prefix `test_`**: `test_game.py`, `test_game_service.py`
- **Mirror source structure**: `app/game_service.py` → `tests/test_game_service.py`

### Documentation Files

- **Markdown**: `.md` extension
- **UTF-8 encoding**: 한글 지원 (중요!)
- **Kebab-case**: `directory-structure.md`, `scenario-examples.md`

---

## Python 3.13 Features Used

### 1. Immutable Dataclasses

```python
from dataclasses import dataclass, replace

@dataclass(frozen=True)
class Game:
    answer: int
    attempts: int

# Immutable update
new_game = replace(game, attempts=game.attempts + 1)
```

### 2. Protocol (Structural Subtyping)

```python
from typing import Protocol

class NumberGenerator(Protocol):
    def generate(self, min: int, max: int) -> int:
        ...

# Any class with matching method signature can be used
```

### 3. Type Hints

```python
def make_guess(self, game: Game, guess: int) -> GuessResult:
    ...

# Union types
def find_game(self, id: str) -> Game | None:
    ...
```

### 4. Match-Case Pattern Matching

```python
match guess:
    case g if g > game.answer:
        return "Too High"
    case g if g < game.answer:
        return "Too Low"
    case _:
        return "Correct"
```

---

## Clean Architecture Principles

### 1. Separation of Concerns

각 레이어는 하나의 책임만 가집니다:
- Domain: 비즈니스 규칙
- App: 유즈케이스 오케스트레이션
- Infra: 외부 세계와의 통신
- UI: 사용자 인터페이스

### 2. Dependency Inversion

구체적인 구현이 아닌 **추상화(Protocol)**에 의존합니다.

```python
# app/game_service.py
class GameService:
    def __init__(self, number_gen: NumberGenerator):  # Protocol
        self.number_gen = number_gen

# main.py - Concrete implementation injected
service = GameService(RandomNumberGenerator())  # Concrete class
```

### 3. Single Responsibility

하나의 클래스/함수는 하나의 이유로만 변경됩니다.

### 4. Testability

모든 레이어는 독립적으로 테스트 가능합니다:
- Domain: 순수 함수 테스트
- App: Mock을 사용한 서비스 테스트
- Infra: 실제 구현체 테스트
- UI: 이벤트 핸들러 테스트

### 5. Immutability

상태 변경 대신 **새로운 객체를 생성**합니다.

```python
# ❌ BAD - Mutable state
game.attempts += 1

# ✅ GOOD - Immutable update
new_game = replace(game, attempts=game.attempts + 1)
```

---

## Configuration Files

### pyproject.toml

```toml
[project]
name = "python-katas"
version = "0.1.0"
requires-python = ">=3.13"
dependencies = ["pytest>=8.0.0"]

[tool.hatch.build.targets.wheel]
packages = ["hidden-number"]  # Package recognition

[tool.pytest.ini_options]
testpaths = ["hidden-number/tests"]
python_files = "test_*.py"
```

### .python-version

```
3.13
```

Python 버전을 명시적으로 고정합니다.

---

## Additional References

- **TDD Guide**: `docs/TDD-guide.md`
- **Clean Architecture Details**: `hidden-number/docs/architecture.md`
- **Agent System**: `AGENTS.md`
- **Usage Scenarios**: `docs/scenario-examples.md`
