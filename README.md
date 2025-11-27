# Python Katas

파이썬으로 진행하는 코딩 카타 프로젝트입니다.
실전 프로그래밍 실력을 향상시키기 위해 Clean Architecture와 XP 프로그래밍 방식으로 학습합니다.

## 실전 가이드

상황별 대응 방법과 명령어 예시는 다음 문서를 참고하세요:

- **TDD 워크플로우**: `docs/TDD-guide.md` - TDD 사이클과 에이전트 전환 가이드
- **시나리오별 예시**: `docs/scenario-examples.md` - Gemini/Claude 사용법, Git 워크플로우, 트러블슈팅
- **AI 에이전트 시스템**: `AGENTS.md` - Navigator, Driver, Reviewer, Coach 활용법
- **스킬 사용법**: `agent/skills/index.md` - catchup, python-runner, skill-creator 스킬 레퍼런스

## 기술 스택

| 기술 | 용도 |
|------|------|
| **Python 3.13** | 메인 언어 |
| **uv** | 패키지 관리자 및 빌드 도구 |
| **Tkinter** | GUI 애플리케이션 개발 |
| **dataclass** | DDD 엔티티 및 불변성 구현 |
| **pytest** | 단위 테스트 프레임워크 |

## 프로젝트 구조

프로젝트 전체 구조와 Clean Architecture 기반 카타 구조는 `docs/directory-structure.md`를 참고하세요.

### Clean Architecture 원칙

- **의존성 방향**: 외부 → 내부 (UI → App → Domain)
- **의존성 역전 (DIP)**: 고수준 모듈이 저수준 모듈에 의존하지 않음
- **계층 분리**: 각 계층은 명확한 책임과 역할을 가짐
- **불변성**: dataclass의 `frozen=True`로 엔티티 불변성 보장
- **절대 경로 임포트**: `from kata-name.layer.module import Class` 형식 사용

자세한 내용: `docs/directory-structure.md`, `hidden-number/docs/architecture.md`

## 환경 설정

### 0. Windows 11 개발 환경 자동 설치 (선택사항)

Windows 11에서 Python, VSCode, Git 등의 개발 도구가 없는 경우, 자동 설치 스크립트를 사용할 수 있습니다.

#### 스크립트 실행 방법

```powershell
# 1. PowerShell을 관리자 권한으로 실행 (방법 1 또는 2 선택)
# 방법 1: 시작 메뉴 → "PowerShell" 검색 → 우클릭 → "관리자 권한으로 실행"
# 방법 2: Windows+R → "powershell" 입력 → Ctrl+Shift+Enter (관리자 권한으로 실행)

# 2. 프로젝트 디렉토리로 이동
cd C:\Users\YourName\source\python\python-katas

# 3. 스크립트 실행
.\window_dev_installer.ps1
```

**설치되는 도구:**
- ✅ Python 3.13
- ✅ Visual Studio Code
- ✅ Git & GitHub CLI
- ✅ Windows Terminal
- ✅ NVM (Node Version Manager)
- ✅ Chocolatey (패키지 매니저) - 자동으로 설치됨

**주의사항:**
- 반드시 **관리자 권한**으로 PowerShell을 실행해야 합니다
- 설치 완료 후 터미널을 재시작하여 환경 변수를 적용합니다

#### 문제 해결

**1. "이 시스템에서 스크립트를 실행할 수 없습니다" 오류**

PowerShell 스크립트 실행 정책 때문에 발생하는 오류입니다. 아래 명령어로 해결:

```powershell
# 현재 사용자에 대해서만 스크립트 실행 허용 (권장)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**명령어 설명:**
- `RemoteSigned`: 로컬 스크립트는 실행 가능, 다운로드한 스크립트는 서명 필요
- `Scope CurrentUser`: 현재 사용자에게만 적용 (관리자 권한 불필요)

**2. Chocolatey 수동 설치가 필요한 경우**

자동 설치 스크립트가 실패한 경우, Chocolatey를 수동으로 설치:

```powershell
# PowerShell 관리자 권한으로 실행 후
Set-ExecutionPolicy Bypass -Scope Process -Force; `
[System.Net.ServicePointManager]::SecurityProtocol = `
[System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

**명령어 설명:**
- `Set-ExecutionPolicy Bypass -Scope Process`: 현재 프로세스에서만 일시적으로 스크립트 실행 허용
- `SecurityProtocol` 설정: TLS 1.2 보안 프로토콜 활성화 (HTTPS 다운로드 필수)
- `iex`: 다운로드한 Chocolatey 설치 스크립트를 즉시 실행

### 1. 필수 조건

- Python 3.13 이상
- uv 패키지 매니저

### 2. uv 설치

```bash
# macOS/Linux
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows
powershell -c "irm https://astral.sh/uv/install.ps1 | iex"
```

### 3. 프로젝트 초기화

```bash
# 저장소 클론
git clone https://github.com/TakSung/python-katas.git
cd python-katas

# 의존성 설치 및 가상환경 생성
uv sync
```

### 4. 개발 환경 활성화

```bash
# 가상환경 활성화
source .venv/bin/activate  # macOS/Linux
# 또는
.venv\Scripts\activate     # Windows
```

## 카타 실행 방법

각 카타는 독립적으로 실행할 수 있습니다.

```bash
# 예시: hidden-number 카타 실행
python hidden-number/main.py
```

## 테스트 실행

```bash
# 전체 테스트 실행
pytest

# 특정 카타 테스트 실행
pytest hidden-number/tests/

# 커버리지와 함께 실행
pytest --cov=hidden-number hidden-number/tests/
```

## 현재 카타 목록

### 1. [Hidden Number](./hidden-number/README.md)

숫자 추측 게임 (Tkinter GUI)

- **학습 목표**: GUI 프로그래밍, 이벤트 처리, Clean Architecture
- **상태**: 구조 생성 완료 (구현 필요)
- **문서**: [Architecture Guide](./hidden-number/docs/architecture.md)

## 개발 가이드라인

### 새 카타 추가하기

1. 카타 디렉토리 생성
2. Clean Architecture 구조 설정
3. `README.md`에 카타 설명 작성
4. `docs/architecture.md`에 설계 문서 작성
5. 빈 파일 생성 (TODO 주석 포함)
6. TDD 방식으로 구현

### 코딩 원칙

- **TDD (Test-Driven Development)**: 테스트 먼저 작성
- **불변성**: 가능한 모든 객체를 불변으로 설계
- **의존성 주입**: 생성자를 통한 의존성 주입
- **단일 책임**: 각 클래스/함수는 하나의 책임만
- **인터페이스 분리**: Protocol을 사용한 인터페이스 정의

## 학습 목표

- Clean Architecture 실전 적용
- DDD (Domain-Driven Design) 패턴 학습
- 의존성 역전 원칙 (DIP) 이해
- 불변 객체 설계
- 테스트 가능한 코드 작성
- XP 프로그래밍 방법론 실습

## 참고 자료

- [Clean Architecture - Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Python Dataclasses - PEP 557](https://peps.python.org/pep-0557/)
- [Protocol (Structural Subtyping) - PEP 544](https://peps.python.org/pep-0544/)
- [uv Documentation](https://github.com/astral-sh/uv)
- [pytest Documentation](https://docs.pytest.org/)

## 라이선스

MIT License

---

> "코드를 작성하는 것은 쉽다. 좋은 코드를 작성하는 것이 어렵다."
> 계속 연습하고 배우자! 🚀
