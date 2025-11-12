# Python Katas

파이썬으로 진행하는 코딩 카타 프로젝트입니다.
실전 프로그래밍 실력을 향상시키기 위해 Clean Architecture와 XP 프로그래밍 방식으로 학습합니다.

## 기술 스택

| 기술 | 용도 |
|------|------|
| **Python 3.13** | 메인 언어 |
| **uv** | 패키지 관리자 및 빌드 도구 |
| **Tkinter** | GUI 애플리케이션 개발 |
| **dataclass** | DDD 엔티티 및 불변성 구현 |
| **pytest** | 단위 테스트 프레임워크 |

## 프로젝트 구조

```
python-katas/
├── .python-version           # Python 버전 고정 (3.13)
├── pyproject.toml            # 프로젝트 설정 및 의존성
├── uv.lock                   # 의존성 잠금 파일
├── .venv/                    # 가상 환경
│
└── {kata-name}/              # 각 카타별 디렉토리
    ├── README.md             # 카타 설명서
    ├── main.py               # 진입점 (의존성 조립)
    │
    ├── domain/               # 도메인 계층 (순수 비즈니스 로직)
    │   └── *.py              # 엔티티, 값 객체
    │
    ├── app/                  # 애플리케이션 계층 (유즈케이스)
    │   └── *.py              # 서비스, 비즈니스 로직
    │
    ├── infra/                # 인프라 계층 (외부 의존성)
    │   └── *.py              # 구체적 구현체
    │
    ├── ui/                   # UI 계층
    │   └── *.py              # Tkinter GUI
    │
    ├── tests/                # 테스트
    │   └── test_*.py         # pytest 단위 테스트
    │
    └── docs/                 # 문서
        └── architecture.md   # 아키텍처 설계 문서
```

### Clean Architecture 원칙

- **의존성 방향**: 외부 → 내부 (UI → App → Domain)
- **의존성 역전 (DIP)**: 고수준 모듈이 저수준 모듈에 의존하지 않음
- **계층 분리**: 각 계층은 명확한 책임과 역할을 가짐
- **불변성**: dataclass의 `frozen=True`로 엔티티 불변성 보장

## 환경 설정

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
git clone <repository-url>
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
