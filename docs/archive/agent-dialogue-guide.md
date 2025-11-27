# 에이전트 대화 시나리오 가이드

에이전트와 효과적으로 대화하며 TDD를 학습하는 방법을 안내합니다.

---

## 시작하기

```bash
gemini                          # Gemini 시작
```

```
네비게이터가 되서 나와 같이 페어코딩 해줘. 알았으면 네라고 해줘.
hidden-number/README.md 를 참고하여 지금 내가 무엇을 해야할지 알려줘
```

---

## TDD 사이클별 대화

### RED - 테스트 작성

**Navigator (전략)**:
```
다음 테스트 케이스를 제안해줘
```

**Navigator 응답 예시**:
```
제안: 정답보다 큰 숫자 입력 시 "Too High" 반환하는 케이스
근거: 핵심 기능이면서 독립적이라 빠른 피드백 가능
```

**Driver (구현)**:
```
드라이버가 되어 이 시나리오를 테스트 코드로 작성해줘
```

**Driver 응답 예시**:
```python
def test_guess_higher_than_answer():
    # Given: 정답이 50인 게임
    game = Game(answer=50, attempts=0, max_attempts=10)

    # When: 70을 추측
    result = service.make_guess(game, 70)

    # Then: "Too High" 반환
    assert result.message == "Too High"
```

**pytest 실행**: RED 확인

---

### GREEN - 구현

**Driver (구현)**:
```
드라이버가 되어 테스트를 통과시켜줘
```

**Driver 응답 예시**:
```python
def make_guess(self, game: Game, guess: int) -> GuessResult:
    if guess > game.answer:
        new_game = replace(game, attempts=game.attempts + 1)
        return GuessResult(game=new_game, message="Too High")
```

**pytest 실행**: GREEN 확인

---

### REFACTOR - 개선

**Reviewer (리뷰)**:
```
리뷰어가 되어 이 코드를 리뷰해줘
```

**Reviewer 응답 예시**:
```
발견된 스멜: if-elif 체인 확장 가능성
개선 제안: match-case 패턴 사용
핵심 이점: 의도 명확, 확장 용이

개선 코드:
match guess:
    case g if g > game.answer: message = "Too High"
    case g if g < game.answer: message = "Too Low"
    case _: message = "Correct"
```

**Driver (적용)**:
```
드라이버가 되어 리뷰어 제안을 적용해줘
```

**pytest 실행**: GREEN 유지 확인

---

## 막혔을 때

### Coach 호출

**다음 단계 모름**:
```
코치가 되어 지금 상황에서 뭘 해야 할지 모르겠어
```

**Coach 응답 예시**:
```
현재: RED-GREEN 완료, REFACTOR 미완
다음: Reviewer 호출
명령어: "리뷰어가 되어 이 코드를 리뷰해줘"
```

**역할 헷갈림**:
```
역할이 헷갈려. 코칭해줘
```

---

## 학습 대화 패턴

### 문법 질문
```
dataclass가 뭐야?
frozen=True는 왜 쓰는 거야?
match-case 문법을 설명해줘
```

### 개념 이해
```
Protocol이 무엇인지 설명해줘
불변성이 왜 중요한 거야?
```

### 구체화 요청
```
무엇을 해야할지 좀더 자세히 설명해줘
테스트 함수 이름은 어떻게 지으면 좋을지 제안해줘
```

### 실행 방법
```
이 파일 어떻게 실행해?
(오류 메시지) 이거 왜 오류 났는지 분석해서 설명해줘
```

---

## 실전 대화 흐름

### 전체 세션 예시

```
1. 시작
   User: 네비게이터가 되서 페어코딩 해줘
   Nav:  네, 시작하겠습니다!

2. 전략
   User: 다음 테스트 케이스 제안해줘
   Nav:  게임 생성 테스트부터 시작하는 게 어떨까요?

3. 테스트 작성
   User: 드라이버가 되어 테스트 작성해줘
   Drv:  (Given-When-Then 코드 제시)
   User: pytest 돌려줘
   Drv:  (RED 확인)

4. 구현
   User: 테스트를 통과시켜줘
   Drv:  (최소 구현)
   User: pytest 돌려줘
   Drv:  (GREEN 확인)

5. 리팩토링
   User: 리뷰어가 되어 코드 리뷰해줘
   Rev:  (개선 제안)
   User: 드라이버가 되어 제안 적용해줘
   Drv:  (리팩토링)

6. 다음 단계
   User: 다음 작업은 뭐 할까?
   Nav:  (다음 테스트 제안 + 커밋 권장)
```

---

## 체크리스트

### RED
- [ ] Navigator: 다음 테스트 제안
- [ ] Driver: 테스트 작성
- [ ] pytest → RED 확인

### GREEN
- [ ] Driver: 구현
- [ ] pytest → GREEN 확인

### REFACTOR
- [ ] Reviewer: 리뷰
- [ ] Driver: 개선 적용
- [ ] pytest → GREEN 유지

### 다음 사이클
- [ ] Navigator: 다음 단계
- [ ] 필요시 커밋

---

**관련 문서**:
- 명령어: `docs/command-reference.md`
- TDD 개념: `docs/TDD-guide.md`
- 에이전트 상세: `agent/sub-agent/index.md`
