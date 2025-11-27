# Scenario-Based Examples & Troubleshooting

실전에서 자주 사용하는 명령어와 시나리오별 대응 방법을 정리한 참고 문서입니다.

---

## Common Usage Patterns

### Gemini CLI Workflow

```bash
# 1. Node.js 버전 전환 (Gemini 실행 전)
nvm use 20.19.0

# 2. Gemini 버전 확인
gemini --version

# 3. Gemini 업데이트 (필요시)
npm update -g @google-cloud/gemini-cli

# 4. Gemini 시작
gemini
```

### Initial Session Setup

Gemini CLI에 진입한 후:

```
# 1. 에이전트 역할 설정
네비게이터가 되서 나와 같이 페어코딩 해줘. 알았으면 네라고 해줘.

# 2. 작업 컨텍스트 파악 (hidden-number 예시)
hidden-number/README.md 를 참고하여 지금 내가 무엇을 해야할지 알려줘
```

---

## Scenario 1: Starting a New Feature

**상황**: 새로운 기능을 시작하려고 합니다.

### Step 1: 현재 상태 파악

```
지금까지 작업 내용 catchup 해줘
```

**목적**: Git 변경사항과 최근 커밋을 확인하여 현재 상태를 이해합니다.

### Step 2: 전략 수립

```
네비게이터가 되어 다음 기능을 위한 테스트 케이스를 제안해줘
```

**목적**: Navigator 에이전트가 다음에 구현할 테스트 시나리오를 제안합니다.

### Step 3: 테스트 작성

```
드라이버가 되어 제안된 테스트를 구현해줘
```

**목적**: Driver 에이전트가 Given-When-Then 구조로 테스트 코드를 작성합니다.

### Step 4: 구현

```
드라이버가 되어 테스트를 통과시켜줘
```

**목적**: 테스트를 통과하는 최소 구현 코드를 작성합니다.

### Step 5: 리팩토링

```
리뷰어가 되어 코드를 리뷰해줘
```

**목적**: 코드 품질을 검토하고 개선점을 제안받습니다.

### Step 6: 다음 단계 계획

```
다음 작업은 무엇을 할까?
```

**목적**: Navigator가 다음 우선순위 작업을 제안합니다.

**참고**: 스킬(agent/skills/*)을 사용하여 현재 상황을 자동으로 파악할 수 있습니다.

---

## Scenario 2: When Stuck

**상황**: 다음에 뭘 해야 할지 모르겠거나 진행이 막혔습니다.

### 코치 호출

```
코치가 되어 지금 상황에서 뭘 해야 할지 모르겠어
```

**Coach가 도와주는 것**:
- 현재 상황 분석
- 적절한 에이전트 전환 제안
- WHAT(전략) vs HOW(구현) 구분 가이드
- 비생산적 패턴 감지 및 개입

### 역할이 헷갈릴 때

```
역할이 헷갈려. 코칭해줘
```

**Coach 응답 예시**:
```
현재 상황을 보니 "어떻게 구현할지" 고민 중이시네요.
이건 Driver의 영역입니다.

Driver로 전환하세요:
"드라이버가 되어 이 기능을 구현해줘"
```

---

## Scenario 3: Understanding Code/Concepts

### 문법을 몰라서 작성이 힘들 때

```
dataclass의 frozen=True 문법에 대해 잘 몰라 설명해줘.
```

**목적**: Python 문법이나 개념을 이해합니다.

### 단어/용어를 몰라서 무슨 말인지 모를 때

```
Protocol이 무엇인지 설명해줘.
```

**목적**: 기술 용어의 의미를 파악합니다.

### 방향성은 있지만 막막할 때

```
무엇을 해야할지 좀더 자세히 설명해줘.
```

**목적**: Navigator의 제안을 더 구체적인 단계로 세분화합니다.

---

## Scenario 4: Testing & Running Code

### 테스트 구현 가이드

**Navigator가 "테스트를 구현해보자"고 방향성만 제시했을 때**:

```
테스트 함수 이름은 어떻게 지으면 좋을지 제안해줘.
```

**목적**: 구체적인 테스트 함수명과 구조를 제안받습니다.

### 테스트 실행

```bash
pytest
```

**전체 테스트 실행**:
```bash
pytest
```

**특정 파일 테스트**:
```bash
pytest hidden-number/tests/test_game.py
```

**특정 테스트 함수 실행**:
```bash
pytest hidden-number/tests/test_game.py::test_game_creation
```

### 파일 실행 방법

**UI 파일 등 실행하기 어려운 파일을 어떻게 실행할지 모를 때**:

```
ui/tkinter_ui.py 파일 작성했는데 어떻게 실행할 수 있을까? 방법 알려줘.
```

**Agent 응답 예시**:
```
main.py에서 의존성을 주입하여 실행할 수 있습니다:

python hidden-number/main.py
```

---

## Scenario 5: Debugging Errors

### 오류 분석 요청

```
(오류난 명령어를 붙여넣으면서)
pytest hidden-number/tests/test_game.py 이거 실행해보고, 왜 오류 났는지 분석해서 설명해줘.
```

**목적**: 에이전트가 직접 명령어를 실행하고 오류를 분석합니다.

### 일반적인 오류 패턴

#### Import Error

**증상**:
```
ImportError: attempted relative import with no known parent package
```

**원인**: 상대 경로 임포트 사용

**해결**:
```python
# ❌ BAD
from .domain.game import Game

# ✅ GOOD
from hidden-number.domain.game import Game
```

**참고**: `docs/directory-structure.md` - Import Strategy 섹션

#### Module Not Found

**증상**:
```
ModuleNotFoundError: No module named 'hidden_number'
```

**원인**: 언더스코어(`_`) 대신 하이픈(`-`) 사용

**해결**:
```python
# ❌ BAD
from hidden_number.domain.game import Game

# ✅ GOOD
from hidden-number.domain.game import Game
```

#### Encoding Error (한글 깨짐)

**증상**: Git 명령어 출력에서 한글 파일명이 깨짐

**해결**:
```bash
# 환경변수 설정
LC_ALL=C.UTF-8 git status

# 또는 Git 옵션 사용
git -c core.quotepath=false status
```

---

## Scenario 6: Creating New Skills

**상황**: 새로운 AI 스킬을 만들고 싶습니다.

### 스킬 생성 요청

```
데이터베이스 마이그레이션을 도와주는 스킬을 만들고 싶어
```

**프로세스**:
1. skill-creator 스킬이 자동으로 활성화됨
2. 인터뷰 형식으로 필요한 정보 수집
3. 스킬 자동 생성
4. 베스트 프랙티스 적용

**참고**: `agent/skills/index.md` - 스킬 생성 가이드

---

## Scenario 7: Git Workflow

### 변경사항 확인

```
지금까지 작업 내용 catchup 해줘
```

또는

```bash
git status
git diff
```

### Checkout & Branch

```bash
# 원격 저장소 업데이트
git fetch --all

# 새 브랜치 생성하며 이동 (원격 wu 브랜치 추적)
git checkout -b wu origin/wu

# 기존 브랜치로 이동
git checkout main
```

### 변경사항 업데이트

```bash
# 원격 저장소 최신 상태 가져오기
git fetch --all

# 현재 브랜치 업데이트
git pull

# main 브랜치 변경사항 병합
git merge origin/main
```

### 커밋 생성

**에이전트에게 커밋 요청**:
```
지금까지 작업 내용을 커밋해줘
```

**수동 커밋**:
```bash
git add .
git commit -m "feat: implement game guess logic

- Add test for guess comparison
- Implement make_guess with match-case pattern
- Refactor to use Python 3.13 features

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>"
```

---

## Python Execution Commands

### 기본 실행

```bash
# main.py 실행
python hidden-number/main.py

# 모듈로 실행
python -m hidden-number.main
```

### 테스트 실행

```bash
# 전체 테스트
pytest

# 특정 디렉토리
pytest hidden-number/tests/

# 특정 파일
pytest hidden-number/tests/test_game.py

# 특정 테스트 함수
pytest hidden-number/tests/test_game.py::test_game_creation

# Verbose 모드
pytest -v

# 실패 시 즉시 중단
pytest -x
```

### 문법 검사

```bash
# 단일 파일 문법 검사
python -m py_compile hidden-number/domain/game.py

# 임포트 테스트
python -c "from hidden-number.domain.game import Game"
```

---

## Agent Interaction Patterns

### 진행 상황 확인

```
다음 작업은 무엇을 할까?
```

**스킬 활용**: catchup, python-runner 등이 자동으로 현재 상황을 분석합니다.

### 역할 명시적 전환

```
# Navigator로 전환
네비게이터가 되어 [요청사항]

# Driver로 전환
드라이버가 되어 [요청사항]

# Reviewer로 전환
리뷰어가 되어 [요청사항]

# Coach로 전환
코치가 되어 [요청사항]
```

### 연속 작업 흐름

```
1. 지금까지 작업 내용 catchup 해줘
2. (catchup 결과 확인 후) 다음 작업은 무엇을 할까?
3. (Navigator 제안 후) 드라이버가 되어 제안된 테스트를 구현해줘
4. (테스트 작성 후) pytest 실행해서 결과 확인해줘
5. (RED 확인 후) 드라이버가 되어 테스트를 통과시켜줘
6. (GREEN 확인 후) 리뷰어가 되어 코드를 리뷰해줘
7. (리팩토링 적용 후) 지금까지 작업 내용을 커밋해줘
```

---

## Troubleshooting Guide

### Issue 1: UTF-8 Encoding in .md Files

**증상**: 한글이 깨지거나 바이너리로 저장됨

**해결**:

1. **파일 생성 시 UTF-8 명시**:
```python
# Python으로 .md 파일 생성 시
with open("filename.md", "w", encoding="utf-8") as f:
    f.write("한글 내용")
```

2. **에디터 설정 확인**:
   - VSCode: 우측 하단 인코딩 확인 (UTF-8)
   - Vim: `:set fileencoding=utf-8`

3. **Git 설정**:
```bash
# 한글 파일명 올바르게 표시
git config --global core.quotepath false
```

### Issue 2: Module Import Failures

**증상**: `ModuleNotFoundError` 또는 `ImportError`

**해결 체크리스트**:

1. ✅ **절대 경로 임포트 사용**:
   ```python
   from hidden-number.domain.game import Game  # ✅
   ```

2. ✅ **패키지 이름 확인** (하이픈 vs 언더스코어):
   ```python
   from hidden-number.app.game_service import GameService  # ✅
   from hidden_number.app.game_service import GameService  # ❌
   ```

3. ✅ **`__init__.py` 파일 존재 확인**:
   ```bash
   ls hidden-number/domain/__init__.py
   ```

4. ✅ **PYTHONPATH 설정** (필요시):
   ```bash
   export PYTHONPATH="${PYTHONPATH}:/Users/takgyun/source/python/python-katas"
   ```

**참고**: `docs/directory-structure.md` - Import Strategy 섹션

### Issue 3: Test Discovery Failures

**증상**: pytest가 테스트를 찾지 못함

**해결**:

1. **파일명 확인** (`test_` prefix):
   ```
   test_game.py  # ✅
   game_test.py  # ❌
   ```

2. **함수명 확인** (`test_` prefix):
   ```python
   def test_game_creation():  # ✅
   def game_creation_test():  # ❌
   ```

3. **pytest 설정 확인** (`pyproject.toml`):
   ```toml
   [tool.pytest.ini_options]
   testpaths = ["hidden-number/tests"]
   python_files = "test_*.py"
   ```

### Issue 4: Gemini CLI Version Issues

**증상**: Gemini 명령어가 작동하지 않음

**해결**:

```bash
# 1. Node.js 버전 확인 및 전환
nvm use 20.19.0

# 2. Gemini 업데이트
npm update -g @google-cloud/gemini-cli

# 3. 버전 확인
gemini --version
```

---

## Quick Reference Cards

### TDD Cycle Quick Commands

| Phase | Command |
|-------|---------|
| **RED** | `네비게이터가 되어 다음 테스트 케이스를 제안해줘` |
| **RED** | `드라이버가 되어 이 시나리오를 테스트 코드로 작성해줘` |
| **RED** | `pytest` (실패 확인) |
| **GREEN** | `드라이버가 되어 이 테스트를 통과시켜줘` |
| **GREEN** | `pytest` (통과 확인) |
| **REFACTOR** | `리뷰어가 되어 이 코드를 리뷰해줘` |
| **REFACTOR** | `드라이버가 되어 리뷰어 제안을 적용해줘` |

### Git Quick Commands

| Task | Command |
|------|---------|
| 상태 확인 | `git status` |
| 변경사항 확인 | `git diff` |
| 스테이징 | `git add .` |
| 커밋 | `git commit -m "message"` |
| 원격 업데이트 | `git fetch --all` |
| 풀 | `git pull` |
| 병합 | `git merge origin/main` |
| 브랜치 생성 | `git checkout -b branch-name origin/branch-name` |

### Python Quick Commands

| Task | Command |
|------|---------|
| 테스트 실행 | `pytest` |
| 파일 실행 | `python hidden-number/main.py` |
| 문법 검사 | `python -m py_compile file.py` |
| 임포트 테스트 | `python -c "from module import Class"` |

---

## Additional Resources

- **TDD Guide**: `docs/TDD-guide.md`
- **Directory Structure**: `docs/directory-structure.md`
- **Agent System**: `AGENTS.md`
- **Skills Index**: `agent/skills/index.md`
- **Clean Architecture**: `hidden-number/docs/architecture.md`
