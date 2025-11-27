# 명령어 레퍼런스 가이드

실전에서 자주 사용하는 명령어 모음입니다. 각 명령어의 사용 상황과 결과를 간단히 설명합니다.

---

## Gemini CLI

```bash
nvm use 20.19.0              # Node.js 버전 전환
gemini --version              # 버전 확인
npm update -g @google-cloud/gemini-cli  # 업데이트
gemini                        # 시작
```

---

## Python 실행

### pytest

```bash
pytest                        # 전체 테스트
pytest hidden-number/tests/   # 특정 디렉토리
pytest path/test_file.py      # 특정 파일
pytest path/test_file.py::test_func  # 특정 함수
pytest -v                     # 상세 모드
pytest -x                     # 첫 실패 시 중단
```

### 프로그램 실행

```bash
python hidden-number/main.py  # 직접 실행
python -m hidden-number.main  # 모듈로 실행 (권장)
```

### 문법 검사

```bash
python -m py_compile file.py  # 문법 검사
python -c "from module import Class"  # 임포트 테스트
```

---

## Git 워크플로우

### 상태 확인

```bash
git status                    # 작업 상태
git diff                      # 변경 내용
git log --oneline -5          # 최근 5개 커밋
```

### 브랜치

```bash
git fetch --all               # 원격 업데이트
git checkout -b feat origin/feat  # 새 브랜치
git pull                      # 변경사항 가져오기
git merge origin/main         # main 병합
```

### 커밋

```bash
git add .                     # 스테이징
git commit -m "feat: 기능"    # 커밋
```

---

## 에이전트 호출

### Navigator (전략)

```
네비게이터가 되어 다음 테스트 케이스를 제안해줘
다음 작업은 무엇을 할까?
테스트 함수 이름은 어떻게 지으면 좋을지 제안해줘
```

### Driver (구현)

```
드라이버가 되어 이 시나리오를 테스트 코드로 작성해줘
드라이버가 되어 테스트를 통과시켜줘
```

### Reviewer (리팩토링)

```
리뷰어가 되어 이 코드를 리뷰하고 리팩토링 제안해줘
```

### Coach (중재)

```
지금 상황에서 뭘 해야 할지 모르겠어. 코치가 되어 설명해줘.
```

### 일반 질문

```
[개념/문법] 에 대해 잘 몰라 설명해줘
무엇을 해야할지 좀더 자세히 설명해줘
[파일명] 작성했는데 어떻게 실행할 수 있을까?
(오류 메시지를 발생시킨 쉘 명령어) 이거 왜 오류 났는지 분석해서 설명해줘
```

---

## 스킬 활용

### catchup

```
지금까지 작업 내용 catchup 해줘
최근 커밋 목록 보여줘
```

### python-runner

```
hidden-number 프로젝트 실행해줘
pytest로 테스트 돌려줘
이 파일 임포트 에러 있는지 확인해줘
```

---

## 트러블슈팅

### 인코딩

```bash
git config --global core.quotepath false  # Git 한글
export LC_ALL=C.UTF-8                     # UTF-8 환경
```

### 임포트 오류

```python
# ❌ 상대 경로
from .domain.game import Game

# ✅ 절대 경로
from hidden-number.domain.game import Game

# ❌ 언더스코어
from hidden_number.domain.game import Game

# ✅ 하이픈
from hidden-number.domain.game import Game
```

### 테스트 발견

```
# ✅ 파일명: test_*.py
# ✅ 함수명: test_*()
```

---

**관련 문서**:
- 에이전트 대화: `docs/agent-dialogue-guide.md`
- TDD 사이클: `docs/TDD-guide.md`
- 에이전트 상세: `agent/sub-agent/index.md`
