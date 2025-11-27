# Driver 가이드 (AI Navigator와 함께)

AI Navigator와 함께 TDD로 개발하는 방법을 배웁니다.

**독자**: 드라이버(Driver) 역할을 하는 당신 (주니어 개발자)

**전제**: `agent/sub-agent/navigator.md`를 불러와서 Navigator 페르소나를 활성화한 상태

---

## 당신의 역할 (Your Role)

### 당신: Driver (드라이버)

- ✅ **코드 작성**: 모든 테스트와 구현 코드를 직접 작성
- ✅ **HOW 결정**: 어떻게 구현할지는 당신이 결정
- ✅ **질문 가능**: 모르는 문법/개념은 Navigator에게 질문
- ❌ **전략 결정 안 함**: 무엇을 만들지는 Navigator가 제안

### AI: Navigator (네비게이터)

- ✅ **전략 제시**: 다음에 무엇을 만들지 제안
- ✅ **방향 안내**: 테스트 케이스, 아키텍처 방향 가이드
- ✅ **문법 설명**: 요청 시 Python 문법/개념 설명
- ❌ **코드 작성 안 함**: 완성된 구현 코드는 제공하지 않음

**중요**: 이 역할은 세션 내내 고정됩니다. 역할을 바꾸지 마세요!

---

## Navigator란?

**역할**: 전략을 제시하는 페어 프로그래밍 파트너

- ✅ **무엇을(WHAT)** 구현할지 제안
- ✅ 다음 테스트 케이스 추천
- ✅ 클린 아키텍처 관점에서 방향 안내
- ❌ **어떻게(HOW)** 구현할지는 알려주지 않음 (Driver의 역할)

---

## 시작하기

### Step 1: Navigator 활성화

```
agent/sub-agent/navigator.md 네비게이터가 되서 나와 같이 페어코딩 해줘
```

**Navigator 응답 예시**:
> 네! Navigator로서 당신과 함께 TDD를 진행하겠습니다.
> 무엇을 도와드릴까요?

---

## 자주 사용하는 질문 패턴

### 1. 카타 시작 시: "무엇을 해야 할지 알려줘"

**상황**: 새 카타를 시작하는데 어디서부터 시작해야 할지 모름

**질문**:
```
hidden-number/README.md를 참고하여 지금 내가 무엇을 해야할지 알려줘
```

**Navigator가 해주는 것**:
- README 분석
- 첫 번째 테스트 제안
- 도메인 레이어부터 시작 권장
- 테스트 파일과 구현 파일 경로 제시

**예상 응답**:
> HiddenNumber는 1-100 사이 숫자 맞추기 게임이네요!
>
> 첫 번째 테스트 제안:
> - 테스트: `tests/domain/test_game.py`
> - 구현: `hidden_number/domain/game.py`
> - 내용: 게임 생성 시 1-100 사이 랜덤 숫자 생성 확인

**당신이 할 일**:
1. 제안받은 경로에 테스트 파일 생성
2. 테스트 코드 작성 (RED 단계)
3. 구현 파일 작성 (GREEN 단계)

---

### 2. 작업 완료 후: "다음 작업은 무엇을 할까?"

**상황**: 기능 하나를 완성했고 다음에 무엇을 할지 모름

**질문**:
```
다음 작업은 무엇을 할까?
```

**Navigator가 해주는 것**:
- Git 커밋 히스토리 자동 분석
- 테스트 실행하여 현재 상태 확인
- 완료된 기능과 미완성 기능 비교
- 다음 논리적 단계 제안

**예상 응답**:
> 최근 작업을 확인했습니다...
>
> ✅ 완료: Game 엔티티, secret_number 생성
> ⬜ 미완성: guess 메서드, UI 레이어
>
> 다음은 `guess` 메서드를 TDD로 만들어볼까요?
> 세 가지 케이스를 테스트하면 됩니다:
> 1. 큰 수 입력 → "더 큰 수입니다!"
> 2. 작은 수 입력 → "더 작은 수입니다!"
> 3. 정답 → "정답입니다!"

**당신이 할 일**:
1. 제안받은 테스트 케이스 작성
2. 하나씩 RED-GREEN 사이클 진행

---

### 3. 문법을 몰라서: "~~~ 문법 설명해줘"

**상황**: Python 문법(dataclass, Protocol 등)을 몰라서 막힘

**질문**:
```
dataclass가 무엇인지 설명해줘
```

**Navigator가 해주는 것** (2단계 학습):

**1단계**: 개념 + 간단한 예시
> dataclass는 클래스를 간편하게 만들어주는 데코레이터에요!
>
> ```python
> @dataclass
> class Person:
>     name: str
>     age: int
> ```
>
> 이해되셨나요? 실제 프로젝트 코드를 보여드릴까요?

**당신의 응답**:
- "응, 보여줘" → 실제 프로젝트 코드 제공
- "잘 모르겠어" → 더 많은 예시 제공 (정답은 아직 안 줌)

**2단계**: 실제 프로젝트 코드 (당신이 "응, 보여줘"라고 했을 때만)
> hidden_number/domain/game.py의 실제 코드:
> ```python
> @dataclass(frozen=True)
> class Game:
>     secret_number: int
> ```

**당신이 할 일**:
1. 개념을 먼저 이해하려고 시도
2. 정말 모르겠으면 실제 코드 요청
3. 직접 작성해보면서 학습

---

### 4. 단어/개념을 몰라서: "~~가 무엇인지 설명해줘"

**상황**: Protocol, DIP 같은 개념이 생소함

**질문**:
```
Protocol이 무엇인지 설명해줘
```

**Navigator가 해주는 것**:
- 개념 설명 (비유 활용)
- 간단한 예시
- 언제 사용하는지 설명
- 실제 코드 보여줄지 물어봄

**예상 응답**:
> Protocol은 "오리처럼 걷고 꽥꽥거리면 오리"라는 덕 타이핑입니다!
>
> Interface (Java): "계약서에 사인 필요" (명시적)
> Protocol (Python): "메서드만 있으면 인정" (암묵적)
>
> [간단한 예시 코드]
>
> 이해되셨나요? 프로젝트에서 어떻게 쓰는지 보여드릴까요?

**당신이 할 일**:
1. 비유로 먼저 이해
2. 예시 코드로 확인
3. 필요하면 실제 사용 예시 요청

---

### 5. 방향은 알겠는데: "좀 더 자세히 설명해줘"

**상황**: "guess 메서드 만들어보세요"라는 방향은 받았는데 구체적으로 모르겠음

**질문**:
```
무엇을 해야할지 좀 더 자세히 설명해줘
```

**Navigator가 해주는 것**:
- 큰 작업을 작은 단계로 분해
- 각 단계별 구체적인 액션 제시
- Given-When-Then 패턴 안내

**예상 응답**:
> Step 1: 테스트 파일에 새 함수 추가
> Step 2: Given-When-Then 패턴으로 작성
> ```python
> def test_guess_returns_too_high():
>     # Given: 정답이 50인 게임
>     # When: 70을 추측
>     # Then: "더 큰 수입니다!" 반환
> ```
> Step 3: 테스트 실행 (RED 확인)
> Step 4: 구현 (GREEN)

**당신이 할 일**:
1. 제시된 단계를 하나씩 따라가기
2. 막히는 부분 있으면 다시 질문

---

### 6. 테스트 함수 이름: "어떻게 지으면 좋을지 제안해줘"

**상황**: 테스트 함수 이름 짓기가 어려움

**질문**:
```
테스트 함수 이름은 어떻게 지으면 좋을지 제안해줘
```

**Navigator가 해주는 것**:
- 네이밍 패턴 제시
- 여러 옵션 제공
- 추천 이유 설명

**예상 응답**:
> 패턴: `test_[메서드명]_[결과]_when_[조건]`
>
> 제안 1: `test_guess_returns_too_high_when_number_is_greater` ⭐ (추천)
> 제안 2: `test_guess_with_greater_number_returns_too_high`
> 제안 3: `test_too_high_message_for_greater_number`
>
> 1번이 가장 명확합니다!

**당신이 할 일**:
1. 제안받은 이름 중 선택
2. 일관된 패턴으로 나머지 테스트 작성

---

### 7. 실행 방법을 몰라서: "어떻게 실행할 수 있을까?"

**상황**: UI 파일 등 단독 실행이 어려운 파일을 만들었음

**질문**:
```
tkinter_ui.py 파일 작성했는데 어떻게 실행할 수 있을까? 방법 알려줘
```

**Navigator가 해주는 것**:
- 실행 방법 여러 개 제시
- 권장 방법 표시
- 자동 실행 및 오류 분석 제안

**예상 응답**:
> Tkinter UI는 단독 실행이 어려워요. 메인 진입점이 필요합니다!
>
> 방법 1: main.py 만들기 (권장)
> ```python
> # hidden_number/main.py
> from hidden_number.domain.game import Game
> from hidden_number.infra.tkinter_ui import GameUI
>
> if __name__ == "__main__":
>     game = Game.create()
>     ui = GameUI(game)
>     ui.run()
> ```
> 실행: `python -m hidden_number.main`
>
> 방법 2: Navigator에게 실행 및 오류 분석 요청

**당신이 할 일**:
1. 제안받은 main.py 생성
2. 실행해보기
3. 오류 나면 다시 Navigator에게 물어보기

---

### 8. 오류 분석: "왜 오류 났는지 분석해줘"

**상황**: pytest 실행 시 오류 발생, 원인 모름

**질문**:
```
pytest tests/domain/test_game.py 이거 실행해보고, 왜 오류 났는지 분석해서 설명해줘
```

**Navigator가 해주는 것**:
- 오류 메시지 분석
- 원인 파악
- 해결 방향 제시 (구체적 코드는 X)

**예상 응답**:
> ImportError: attempted relative import with no known parent package
>
> 원인: 상대 경로 import 사용
> ```python
> from ..domain.game import Game  # ❌
> ```
>
> 해결 방향: 절대 경로 import로 변경
> ```python
> from hidden_number.domain.game import Game  # ✅
> ```
>
> 또한 `__init__.py` 파일이 모든 패키지 폴더에 있는지 확인하세요!

**당신이 할 일**:
1. 제안받은 방향으로 수정
2. 다시 실행
3. 여전히 안 되면 전체 오류 메시지 공유

---

## 커뮤니케이션 팁

### ✅ 좋은 질문 방법

1. **구체적으로**:
   - ❌ "이거 어떻게 해?"
   - ✅ "guess 메서드의 테스트 함수 이름 어떻게 지을까요?"

2. **상황 설명**:
   - ❌ "오류나요"
   - ✅ "pytest 실행했는데 ImportError 나요. 메시지는..."

3. **시도한 것 공유**:
   - ❌ "안 돼요"
   - ✅ "이렇게 해봤는데 안 되네요: [코드]"

### ❌ 피해야 할 질문

1. **코드 달라고 직접 요청**:
   - ❌ "코드 다 작성해줘"
   - ✅ "어떤 방향으로 작성하면 좋을까요?"

2. **너무 포괄적**:
   - ❌ "프로젝트 다 만들어줘"
   - ✅ "첫 번째 테스트 무엇부터 시작할까요?"

---

## 학습 흐름

### RED → GREEN → REFACTOR 사이클

1. **RED**: Navigator에게 다음 테스트 제안받기
   ```
   "다음 테스트는 무엇을 작성하면 좋을까요?"
   ```

2. **GREEN**: 막히면 문법/개념 질문
   ```
   "dataclass frozen=True가 뭔가요?"
   ```

3. **REFACTOR**: Reviewer 호출 (Navigator 아님!)
   ```
   agent/sub-agent/reviewer.md 이 코드 리뷰해줘
   ```

4. **다음 사이클**: Navigator에게 다음 작업 질문
   ```
   "다음 작업은 무엇을 할까?"
   ```

---

## Troubleshooting (자주 발생하는 문제)

### 문제 1: ImportError (상대 경로)

**증상**:
```
ImportError: attempted relative import with no known parent package
```

**Navigator에게 물어보기**:
```
ImportError가 나는데 왜 그런지 분석해줘
```

**예상 해결책**:
- 상대 경로 → 절대 경로 변경
- `__init__.py` 파일 확인

---

### 문제 2: 테스트 안 돌아감

**증상**:
```
collected 0 items
```

**Navigator에게 물어보기**:
```
pytest 실행했는데 테스트를 못 찾아요. 뭐가 문제일까요?
```

**예상 해결책**:
- 파일 이름: `test_*.py` 패턴 확인
- 함수 이름: `test_*` 패턴 확인

---

### 문제 3: 다음에 뭘 해야 할지 모름

**상황**: 작업은 끝났는데 막막함

**Navigator에게 물어보기**:
```
다음 작업은 무엇을 할까?
```

**Navigator가 자동으로**:
- Git 히스토리 확인
- 테스트 실행
- 다음 단계 추천

---

## 참고 문서

- **TDD 기본**: [TDD-guide.md](TDD-guide.md)
- **클린 아키텍처**: [directory-structure.md](directory-structure.md)
- **에이전트 대화법**: [agent-dialogue-guide.md](agent-dialogue-guide.md)

---

**Happy Pair Programming! 🚀**
