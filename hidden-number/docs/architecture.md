# Hidden Number - Clean Architecture 구현 가이드

## 📐 아키텍처 개요

이 프로젝트는 **Clean Architecture** 원칙에 따라 설계되었습니다. 각 계층은 명확한 책임을 가지며, 의존성은 항상 외부에서 내부로 향합니다.

```
┌─────────────────────────────────────────────┐
│              UI Layer (ui/)                  │
│         Tkinter GUI Components              │
└────────────────┬────────────────────────────┘
                 │ depends on
┌────────────────▼────────────────────────────┐
│         Application Layer (app/)            │
│          Business Logic Services            │
└────────────────┬────────────────────────────┘
                 │ depends on
┌────────────────▼────────────────────────────┐
│          Domain Layer (domain/)             │
│         Entities & Value Objects            │
│            (Pure Python, No Deps)           │
└─────────────────────────────────────────────┘
                 ▲
                 │ implements
┌────────────────┴────────────────────────────┐
│       Infrastructure Layer (infra/)         │
│    External Dependencies (Random, I/O)      │
└─────────────────────────────────────────────┘
```

## 📁 폴더 구조

```
hidden-number/
├── main.py                      # 진입점 (Dependency Injection)
├── domain/                      # 도메인 계층
│   ├── __init__.py
│   └── game.py                 # Game 엔티티 (dataclass)
├── app/                         # 애플리케이션 계층
│   ├── __init__.py
│   └── game_service.py         # 게임 비즈니스 로직
├── infra/                       # 인프라 계층
│   ├── __init__.py
│   └── random_generator.py     # 랜덤 생성기 인터페이스/구현
├── ui/                          # UI 계층
│   ├── __init__.py
│   └── tkinter_ui.py           # Tkinter GUI
├── tests/                       # 테스트
│   ├── __init__.py
│   ├── test_game.py
│   ├── test_game_service.py
│   └── test_random_generator.py
└── docs/
    └── architecture.md          # 이 문서
```

---

## 🏗️ 계층별 상세 설명

### 1. Domain Layer (`domain/`)

**역할**: 핵심 비즈니스 엔티티와 규칙을 정의합니다. 외부 의존성이 전혀 없어야 합니다.

#### `domain/game.py` - Game 엔티티

```python
from dataclasses import dataclass

@dataclass(frozen=True)
class Game:
    """
    게임 상태를 나타내는 불변 엔티티

    Attributes:
        hidden_number: 숨겨진 정답 (1-100)
        attempts: 시도 횟수
        is_finished: 게임 종료 여부
    """
    hidden_number: int
    attempts: int = 0
    is_finished: bool = False

    def __post_init__(self):
        # 비즈니스 규칙 검증
        if not 1 <= self.hidden_number <= 100:
            raise ValueError("Hidden number must be between 1 and 100")
```

**핵심 원칙**:
- `frozen=True`로 불변성 보장
- 비즈니스 규칙을 엔티티 내에서 검증
- 외부 라이브러리 의존성 없음

---

### 2. Infrastructure Layer (`infra/`)

**역할**: 외부 시스템 및 기술적 구현 세부사항을 처리합니다.

#### `infra/random_generator.py` - 랜덤 생성기

```python
from typing import Protocol
import random

class RandomNumberGenerator(Protocol):
    """랜덤 숫자 생성 인터페이스 (의존성 역전)"""
    def generate(self, min_value: int, max_value: int) -> int:
        ...

class StandardRandomGenerator:
    """표준 라이브러리를 사용한 구현체"""
    def generate(self, min_value: int, max_value: int) -> int:
        return random.randint(min_value, max_value)
```

**핵심 원칙**:
- `Protocol`을 사용하여 인터페이스 정의 (Duck Typing)
- 테스트를 위해 Mock 생성 가능
- 구현체는 인터페이스를 따름

---

### 3. Application Layer (`app/`)

**역할**: 비즈니스 로직을 조율하고 유즈케이스를 구현합니다.

#### `app/game_service.py` - 게임 서비스

```python
from dataclasses import replace
from domain.game import Game
from infra.random_generator import RandomNumberGenerator

class GameService:
    """게임 비즈니스 로직 서비스"""

    def __init__(self, random_generator: RandomNumberGenerator):
        self._random_generator = random_generator

    def start_new_game(self) -> Game:
        """새 게임 시작"""
        hidden_number = self._random_generator.generate(1, 100)
        return Game(hidden_number=hidden_number)

    def make_guess(self, game: Game, guess: int) -> tuple[Game, str]:
        """
        추측을 처리하고 새로운 게임 상태와 결과 메시지 반환

        Returns:
            (updated_game, message)
            message: "higher", "lower", "correct"
        """
        if game.is_finished:
            return game, "Game already finished"

        new_attempts = game.attempts + 1

        if guess < game.hidden_number:
            new_game = replace(game, attempts=new_attempts)
            return new_game, "higher"
        elif guess > game.hidden_number:
            new_game = replace(game, attempts=new_attempts)
            return new_game, "lower"
        else:
            new_game = replace(game, attempts=new_attempts, is_finished=True)
            return new_game, "correct"
```

**핵심 원칙**:
- 불변 엔티티를 사용하므로 `dataclasses.replace()`로 새 상태 생성
- 의존성을 생성자로 주입받음 (Dependency Injection)
- 순수 함수 스타일 (부작용 없음)

---

### 4. UI Layer (`ui/`)

**역할**: 사용자 인터페이스를 담당합니다. Tkinter를 사용합니다.

#### `ui/tkinter_ui.py` - Tkinter GUI

```python
import tkinter as tk
from tkinter import messagebox
from app.game_service import GameService
from domain.game import Game

class HiddenNumberUI:
    """Tkinter 기반 GUI"""

    def __init__(self, game_service: GameService):
        self._game_service = game_service
        self._current_game: Game | None = None

        # Tkinter 컴포넌트 초기화
        self._root = tk.Tk()
        self._root.title("🎯 Hidden Number")

        # TODO: Label, Entry, Button 위젯 구성
        # TODO: 이벤트 핸들러 바인딩

    def _start_new_game(self):
        """새 게임 시작 핸들러"""
        self._current_game = self._game_service.start_new_game()
        # TODO: UI 초기화

    def _on_guess_clicked(self):
        """추측 버튼 클릭 핸들러"""
        try:
            guess = int(self._entry.get())
            self._current_game, message = self._game_service.make_guess(
                self._current_game, guess
            )
            # TODO: 결과에 따라 UI 업데이트
        except ValueError:
            messagebox.showerror("Error", "올바른 숫자를 입력하세요")

    def run(self):
        """GUI 실행"""
        self._start_new_game()
        self._root.mainloop()
```

**핵심 원칙**:
- GameService를 통해서만 비즈니스 로직 접근
- 이벤트 기반 프로그래밍
- UI 로직과 비즈니스 로직 분리

---

### 5. Entry Point (`main.py`)

**역할**: 모든 의존성을 조립하고 애플리케이션을 시작합니다.

```python
from infra.random_generator import StandardRandomGenerator
from app.game_service import GameService
from ui.tkinter_ui import HiddenNumberUI

def main():
    # 1. 의존성 생성 (외부 → 내부 순서)
    random_generator = StandardRandomGenerator()

    # 2. 서비스 생성 (의존성 주입)
    game_service = GameService(random_generator)

    # 3. UI 생성 (의존성 주입)
    ui = HiddenNumberUI(game_service)

    # 4. 애플리케이션 실행
    ui.run()

if __name__ == "__main__":
    main()
```

**핵심 원칙**:
- 의존성 조립 책임을 한 곳에 집중
- 구체적인 구현체 선택
- 테스트 시 Mock으로 쉽게 교체 가능

---

## 🧪 테스트 전략

### `tests/test_game.py` - 도메인 테스트

```python
import pytest
from domain.game import Game

def test_game_creation():
    game = Game(hidden_number=42)
    assert game.hidden_number == 42
    assert game.attempts == 0
    assert game.is_finished is False

def test_game_immutability():
    game = Game(hidden_number=42)
    with pytest.raises(Exception):  # frozen=True
        game.attempts = 10

def test_invalid_hidden_number():
    with pytest.raises(ValueError):
        Game(hidden_number=101)
```

### `tests/test_game_service.py` - 애플리케이션 로직 테스트

```python
from app.game_service import GameService
from infra.random_generator import RandomNumberGenerator

class MockRandomGenerator:
    """테스트용 Mock"""
    def generate(self, min_value: int, max_value: int) -> int:
        return 50  # 항상 50 반환

def test_make_guess_lower():
    service = GameService(MockRandomGenerator())
    game = service.start_new_game()

    new_game, message = service.make_guess(game, 30)

    assert message == "higher"
    assert new_game.attempts == 1
    assert not new_game.is_finished

def test_make_guess_correct():
    service = GameService(MockRandomGenerator())
    game = service.start_new_game()

    new_game, message = service.make_guess(game, 50)

    assert message == "correct"
    assert new_game.attempts == 1
    assert new_game.is_finished
```

---

## 🎯 의존성 역전 원칙 (DIP)

```
High-level (app/) → Interface (Protocol) ← Low-level (infra/)
```

**Before DIP (나쁜 예)**:
```python
# app/game_service.py
import random  # 직접 의존!

class GameService:
    def start_new_game(self):
        number = random.randint(1, 100)  # 구체적 구현에 의존
```

**After DIP (좋은 예)**:
```python
# app/game_service.py
class GameService:
    def __init__(self, random_generator: RandomNumberGenerator):
        self._random_generator = random_generator  # 인터페이스에 의존

    def start_new_game(self):
        number = self._random_generator.generate(1, 100)
```

---

## ✅ 구현 체크리스트

### 1단계: Domain Layer
- [ ] `Game` dataclass 작성 (frozen=True)
- [ ] 비즈니스 규칙 검증 (`__post_init__`)
- [ ] 단위 테스트 작성

### 2단계: Infrastructure Layer
- [ ] `RandomNumberGenerator` Protocol 정의
- [ ] `StandardRandomGenerator` 구현
- [ ] 단위 테스트 작성

### 3단계: Application Layer
- [ ] `GameService` 클래스 작성
- [ ] `start_new_game()` 구현
- [ ] `make_guess()` 구현
- [ ] Mock을 사용한 단위 테스트 작성

### 4단계: UI Layer
- [ ] `HiddenNumberUI` 클래스 작성
- [ ] Tkinter 위젯 구성 (Label, Entry, Button)
- [ ] 이벤트 핸들러 구현
- [ ] 결과 메시지 표시 로직

### 5단계: Integration
- [ ] `main.py`에서 의존성 조립
- [ ] 전체 통합 테스트
- [ ] 실행 확인

---

## 📚 참고 자료

- **Clean Architecture**: Robert C. Martin의 설계 원칙
- **DDD (Domain-Driven Design)**: Eric Evans의 도메인 중심 설계
- **Python Dataclasses**: [PEP 557](https://peps.python.org/pep-0557/)
- **Protocol (Structural Subtyping)**: [PEP 544](https://peps.python.org/pep-0544/)
- **Tkinter**: [Python 공식 문서](https://docs.python.org/3/library/tkinter.html)

---

## 💡 학습 포인트

1. **불변성 (Immutability)**
   - `frozen=True` dataclass
   - `dataclasses.replace()` 사용

2. **의존성 역전 (DIP)**
   - Protocol을 통한 인터페이스 정의
   - 생성자 주입 (Constructor Injection)

3. **단일 책임 원칙 (SRP)**
   - 각 계층은 하나의 책임만
   - 비즈니스 로직과 UI 분리

4. **테스트 가능성**
   - Mock 객체를 통한 격리된 테스트
   - 순수 함수로 예측 가능한 테스트

---

> "좋은 아키텍처는 결정을 미루게 해준다." - Robert C. Martin

화이팅! 🚀
