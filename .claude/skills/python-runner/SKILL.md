---
name: python-runner
description: Python 프로젝트 실행, 테스트, 문법 검사, 임포트 검증을 위한 크로스 플랫폼(Linux/Windows) 스킬. main.py 실행, pytest 실행, 파일 문법 체크, 임포트 오류 검증 시 사용하세요.
allowed-tools: Bash, Read, Grep, Glob
---

# Python Runner - 파이썬 실행 및 검증 스킬

`.venv` 가상환경을 자동으로 활성화하여 Python 코드를 실행하고 검증하는 크로스 플랫폼 스킬입니다.

## 주요 기능

### 1. 플랫폼 감지 및 가상환경 활성화

Linux/macOS와 Windows를 자동으로 감지하여 적절한 명령어를 사용합니다.

**Linux/macOS:**
```bash
source .venv/bin/activate && python [command]
```

**Windows (PowerShell):**
```powershell
.venv\Scripts\Activate.ps1; python [command]
```

**Windows (CMD):**
```cmd
.venv\Scripts\activate.bat && python [command]
```

### 2. main.py 실행

프로젝트의 진입점(`hidden-number/main.py`)을 실행합니다.

**실행 방법:**
```bash
# Linux/macOS
source .venv/bin/activate && python -m hidden-number.main

# Windows (PowerShell)
.venv\Scripts\Activate.ps1; python -m hidden-number.main
```

**주의사항:**
- 모듈 형태로 실행: `python -m hidden-number.main`
- 직접 파일 실행 시 임포트 오류 가능: `python hidden-number/main.py` (비권장)

### 3. pytest 실행

프로젝트의 모든 테스트 또는 특정 테스트를 실행합니다.

**전체 테스트:**
```bash
# Linux/macOS
source .venv/bin/activate && pytest

# Windows (PowerShell)
.venv\Scripts\Activate.ps1; pytest
```

**특정 파일 테스트:**
```bash
# Linux/macOS
source .venv/bin/activate && pytest hidden-number/tests/test_game.py

# Windows (PowerShell)
.venv\Scripts\Activate.ps1; pytest hidden-number/tests/test_game.py
```

**상세 출력 옵션:**
- `-v`: 상세 출력
- `-s`: print 문 출력
- `-k "test_name"`: 특정 테스트만 실행
- `--tb=short`: 짧은 traceback

**예시:**
```bash
pytest -v -s hidden-number/tests/test_game.py::test_game_creation
```

### 4. 특정 파일 문법 검사

Python 파일의 문법 오류를 검사합니다.

**방법 1: py_compile 사용 (표준 라이브러리)**
```bash
# Linux/macOS
source .venv/bin/activate && python -m py_compile hidden-number/domain/game.py

# Windows (PowerShell)
.venv\Scripts\Activate.ps1; python -m py_compile hidden-number/domain/game.py
```

**방법 2: ast 모듈 사용 (더 상세한 오류 메시지)**
```bash
# Linux/macOS
source .venv/bin/activate && python -c "import ast; ast.parse(open('hidden-number/domain/game.py').read())"

# Windows (PowerShell)
.venv\Scripts\Activate.ps1; python -c "import ast; ast.parse(open('hidden-number/domain/game.py').read())"
```

**출력:**
- 문법 오류가 없으면 아무 출력 없음 (성공)
- 문법 오류가 있으면 `SyntaxError` 발생

### 5. 임포트 검증

프로젝트의 임포트 전략을 검증하고 잘못된 임포트를 찾아 수정을 돕습니다.

#### 5.1 임포트 전략 규칙

이 프로젝트는 다음 임포트 전략을 따릅니다:

**절대 임포트 (Absolute Import) - 권장:**
```python
# ✅ 올바른 임포트
from hidden-number.domain.game import Game
from hidden-number.app.game_service import GameService
from hidden-number.infra.random_generator import RandomGenerator
```

**상대 임포트 (Relative Import) - 비권장:**
```python
# ❌ 잘못된 임포트 (같은 패키지 내에서도 절대 임포트 권장)
from .game import Game
from ..domain.game import Game
```

**pyproject.toml 설정:**
```toml
[tool.hatch.build.targets.wheel]
packages = ["hidden-number"]
```

#### 5.2 임포트 오류 검증 방법

**1단계: 모든 Python 파일에서 임포트 문 검색**
```bash
# Grep으로 모든 import 문 찾기
grep -r "^from\|^import" hidden-number/ --include="*.py"
```

**2단계: 상대 임포트 패턴 검색**
```bash
# 상대 임포트 (.) 찾기
grep -r "^from \." hidden-number/ --include="*.py"
```

**3단계: 잘못된 임포트 패턴 검색**
```bash
# hidden-number 없이 직접 임포트하는 패턴 찾기 (잘못된 패턴)
grep -r "^from domain\|^from app\|^from infra\|^from ui" hidden-number/ --include="*.py"
```

**4단계: 임포트 실제 검증 (실행해보기)**
```bash
# Linux/macOS
source .venv/bin/activate && python -c "from hidden-number.domain.game import Game; print('Import OK')"

# Windows (PowerShell)
.venv\Scripts\Activate.ps1; python -c "from hidden-number.domain.game import Game; print('Import OK')"
```

#### 5.3 임포트 오류 수정 가이드

**잘못된 임포트 발견 시:**

**Case 1: 상대 임포트 → 절대 임포트**
```python
# Before (잘못됨)
from .game import Game

# After (올바름)
from hidden-number.domain.game import Game
```

**Case 2: 패키지명 누락**
```python
# Before (잘못됨)
from domain.game import Game

# After (올바름)
from hidden-number.domain.game import Game
```

**Case 3: 순환 임포트 문제**
```python
# 해결 방법 1: TYPE_CHECKING 사용
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from hidden-number.domain.game import Game

# 해결 방법 2: 늦은 임포트 (함수 내부)
def some_function():
    from hidden-number.domain.game import Game
    # ...
```

#### 5.4 프로젝트 전체 임포트 검증 스크립트

**검증 명령어 조합:**
```bash
# 1. 모든 import 문 확인
grep -r "^from\|^import" hidden-number/ --include="*.py" -n

# 2. 상대 임포트 검색 (있으면 안 됨)
grep -r "^from \." hidden-number/ --include="*.py" -n

# 3. 패키지명 없는 임포트 검색 (있으면 안 됨)
grep -r "^from \(domain\|app\|infra\|ui\|tests\)\." hidden-number/ --include="*.py" -n

# 4. 모든 Python 파일 문법 검사
find hidden-number/ -name "*.py" -exec python -m py_compile {} \;

# 5. pytest로 임포트 검증 (테스트 실행 시 임포트 오류 발생)
pytest --collect-only
```

## 플랫폼별 실행 전략

### Linux/macOS 실행 함수

```bash
run_python() {
    source .venv/bin/activate && "$@"
}

# 사용 예시
run_python python -m hidden-number.main
run_python pytest
run_python python -m py_compile hidden-number/domain/game.py
```

### Windows PowerShell 실행 함수

```powershell
function Run-Python {
    .venv\Scripts\Activate.ps1
    & $args
}

# 사용 예시
Run-Python python -m hidden-number.main
Run-Python pytest
```

## 사용 예시

### 예시 1: main.py 실행

**사용자 요청:**
> "main.py를 실행해줘"

**스킬 동작:**
1. 플랫폼 감지 (Linux/macOS vs Windows)
2. `.venv` 활성화
3. `python -m hidden-number.main` 실행
4. 출력 결과 표시

### 예시 2: 테스트 실행

**사용자 요청:**
> "게임 테스트 실행해줘"

**스킬 동작:**
1. `.venv` 활성화
2. `pytest hidden-number/tests/test_game.py -v` 실행
3. 테스트 결과 요약

### 예시 3: 문법 검사

**사용자 요청:**
> "game.py 파일 문법 검사해줘"

**스킬 동작:**
1. `.venv` 활성화
2. `python -m py_compile hidden-number/domain/game.py` 실행
3. 오류 있으면 상세 내용 표시, 없으면 "OK" 표시

### 예시 4: 임포트 검증

**사용자 요청:**
> "임포트 제대로 됐는지 확인해줘"

**스킬 동작:**
1. Grep으로 모든 import 문 검색
2. 상대 임포트 패턴 검색
3. 잘못된 임포트 발견 시:
   - 파일명과 라인 번호 표시
   - Before/After 수정 예시 제공
4. 임포트 실제 실행 테스트
5. 수정 제안

**출력 예시:**
```
🔍 임포트 검증 결과:

❌ 발견된 문제:
hidden-number/app/game_service.py:3
  Before: from domain.game import Game
  After:  from hidden-number.domain.game import Game

hidden-number/tests/test_game.py:1
  Before: from .domain.game import Game
  After:  from hidden-number.domain.game import Game

✅ 수정 제안:
1. Edit 도구로 위 파일들의 임포트 수정
2. pytest --collect-only로 재검증
```

## 주의사항

### 1. 가상환경 활성화 필수

모든 실행은 `.venv` 활성화 상태에서 진행되어야 합니다.

### 2. 모듈 형태 실행 권장

```bash
# ✅ 권장
python -m hidden-number.main

# ❌ 비권장 (임포트 오류 가능)
python hidden-number/main.py
```

### 3. Windows PowerShell 실행 정책

Windows에서 스크립트 실행이 차단되면:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 4. 한글 인코딩 지원

모든 명령어는 UTF-8 인코딩을 사용합니다:
```bash
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
```

### 5. 임포트 오류 디버깅

임포트 오류 발생 시:
1. `PYTHONPATH` 확인
2. `__init__.py` 파일 존재 확인
3. 순환 임포트 확인
4. 패키지 설치 상태 확인: `pip list | grep python-katas`

## 트러블슈팅

### 문제 1: ModuleNotFoundError

**증상:**
```
ModuleNotFoundError: No module named 'hidden-number'
```

**해결:**
```bash
# uv로 프로젝트 재설치
uv pip install -e .
```

### 문제 2: 가상환경 활성화 실패 (Windows)

**증상:**
```
.venv\Scripts\Activate.ps1 cannot be loaded
```

**해결:**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 문제 3: pytest 찾을 수 없음

**증상:**
```
pytest: command not found
```

**해결:**
```bash
source .venv/bin/activate
pip install pytest
# 또는
uv pip install pytest
```

## 참고 자료

- **pyproject.toml**: 프로젝트 메타데이터 및 빌드 설정
- **pytest 설정**: `[tool.pytest.ini_options]` 참조
- **Python 임포트 시스템**: https://docs.python.org/3/reference/import.html
