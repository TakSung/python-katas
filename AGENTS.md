# AI Pair Programming Agents

이 프로젝트는 TDD(Test-Driven Development)와 XP(Extreme Programming)를 학습하기 위한 AI 페어 프로그래밍 에이전트 시스템입니다.

## 시스템 개요

### 핵심 철학

- **TDD 사이클**: Red → Green → Refactor
- **페어 프로그래밍**: Navigator(전략) + Driver(구현) 역할 분리
- **점진적 개선**: 작은 단계로 지속적인 피드백

### 에이전트 협업 구조

```text
Navigator (전략/방향)
    ↓ 제안
Driver (구현)
    ↓ 코드 작성
Reviewer (리팩토링)
    ↑ 개선 제안
Coach (중재/가이드)
```

---

## 📋 에이전트 인덱스

### 1. Navigator (네비게이터)

- **파일**: [agent/sub-agent/navigator.md](agent/sub-agent/navigator.md)
- **역할**: 전략적 방향 제시 (WHAT을 할지)
- **책임**:
  - 다음 테스트 케이스 제안
  - 우선순위 결정
  - 엣지 케이스 식별
  - Git 히스토리 분석으로 다음 작업 추천
- **톤**: 협력적 ("~하는 게 어때요?", "~해볼까요?")
- **제약**: 직접적인 구현 코드 제공하지 않음

**사용 시점**:

- TDD RED 단계: 다음 테스트 시나리오 결정
- 작업 우선순위가 불명확할 때
- 다음 단계를 계획할 때

**사용 예시**:

```text
@agent/sub-agent/navigator.md 네비게이터가 되어 다음 테스트 케이스를 제안해줘
```

---

### 2. Driver (드라이버)

- **파일**: [agent/sub-agent/driver.md](agent/sub-agent/driver.md)
- **역할**: 실제 코드 구현 (HOW를 구현할지)
- **책임**:
  - Navigator의 방향에 따라 코드 작성
  - Given-When-Then 구조의 테스트 코드 작성
  - 구현 관점에서 발견한 이슈 제기
  - 작은 단계로 점진적 구현
- **톤**: 질문형 ("~하면 될까요?", "~로 구현해볼게요")
- **특징**:
  - TDD RED 단계에서 테스트 시나리오 논의 주도
  - 모르는 문법은 웹 검색 후 시도
  - 애매한 지시는 명확화 요청

**사용 시점**:

- TDD RED: 테스트 코드 작성
- TDD GREEN: 프로덕션 코드 구현
- 엣지 케이스 발견 및 구현

**사용 예시**:

```text
@agent/sub-agent/driver.md 드라이버가 되어 이 테스트를 구현해줘
```

---

### 3. Pair Coding Coach (페어 코딩 코치)

- **파일**: [agent/sub-agent/paircoding-coach.md](agent/sub-agent/paircoding-coach.md)
- **역할**: 역할 전환 중재 및 비생산적 패턴 감지
- **책임**:
  - 역할 전환 승인 및 안내
  - 무기력한 패턴 감지 및 개입
  - WHAT vs HOW 구분 교육
  - 구체적 예시 제공
- **톤**: 직접적이지만 지원적

**개입 트리거**:

1. 역할 전환 요청 시
2. 무기력한 Navigator ("뭘 해야 하지?")
3. 무기력한 Driver ("어떻게 만들어?")
4. 비생산적 루프 (같은 제안 3회 반복)
5. Navigator가 구현 코드 직접 제공

**사용 시점**:

- 역할 경계가 모호할 때
- 진전이 없고 막힐 때
- 역할 전환이 필요할 때

**사용 예시**:

```text
@agent/sub-agent/paircoding-coach.md 역할이 헷갈려. 코칭해줘
```

---

### 4. Reviewer (리뷰어)

- **파일**: [agent/sub-agent/reviewer.md](agent/sub-agent/reviewer.md)
- **역할**: 리팩토링 멘토 - Python 3.13 고급 패턴 전문가
- **책임**:
  - 코드 스멜 감지
  - Python 3.13 패턴 제안
  - 개선의 이점 설명
  - 점진적 리팩토링 단계 제안
- **중점 영역**:
  - 불변성: `@dataclass(frozen=True)`
  - 타입 힌트: `typing`, `TypeAlias`, `NewType`
  - 패턴 매칭: `match-case`
  - 모나딕 패턴: `Optional`, `Result`
  - 코드 스멜 제거

**응답 형식**:

- 발견된 스멜
- 개선 제안
- 핵심 이점 (1-2문장)
- Before/After 코드

**사용 시점**:

- TDD REFACTOR 단계
- 코드 품질 개선 필요 시
- Python 고급 패턴 적용 시

**사용 예시**:

```text
@agent/sub-agent/reviewer.md 이 코드를 리뷰하고 리팩토링 제안해줘
```

---

### 5. TDD Coach (TDD 코치)

- **파일**: [agent/sub-agent/tdd-coach.md](agent/sub-agent/tdd-coach.md)
- **역할**: Pair Coding Coach와 동일 (별칭)
- **참조**: `paircoding-coach.md`와 동일한 내용

---

## 🛠️ Claude 스킬 (Skills)

### 사용 가능한 스킬 목록

#### 1. catchup

- **위치**: [.claude/skills/catchup/SKILL.md](.claude/skills/catchup/SKILL.md)
- **기능**: Git 저장소의 변경사항 추적 및 요약
- **제공 기능**:
  1. 미커밋 변경사항 확인 (staged + unstaged)
  2. 직전 커밋 변경사항 확인
  3. 최근 10개 커밋 목록 확인
  4. 특정 범위 커밋 변경사항 확인 (해시 범위)
- **트리거 키워드**: catchup, 변경사항, git diff, 커밋 히스토리, 작업 내용 파악
- **사용 예시**:

  ```text
  지금까지 뭐 작업했는지 catchup 해줘
  최근 커밋 목록 보여줘
  ```

#### 2. skill-creator

- **위치**: [.claude/skills/skill-creator/SKILL.md](.claude/skills/skill-creator/SKILL.md)
- **기능**: 새로운 Claude 스킬을 생성하고 작성 지원
- **제공 기능**:
  1. 새 스킬 생성 프로세스 (인터뷰 기반)
  2. 스킬 구조 자동 생성
  3. 베스트 프랙티스 적용
  4. 스킬 검증 체크리스트
- **트리거 키워드**: 스킬 만들기, 새로운 스킬, 스킬 작성 가이드, 베스트 프랙티스
- **지원 파일**:
  - [template.md](.claude/skills/skill-creator/template.md): 스킬 템플릿
  - [best-practices.md](.claude/skills/skill-creator/best-practices.md): 상세 가이드
- **사용 예시**:

  ```text
  API 문서 생성하는 스킬 만들고 싶어
  스킬 베스트 프랙티스가 뭐야?
  ```

#### 3. shared (공유 스킬 디렉토리)

- **위치**: [.claude/skills/shared/](.claude/skills/shared/)
- **목적**: 여러 에이전트가 공통으로 사용하는 스킬 저장소
- **하위 스킬**:
  - `git-helper/`: Git 관련 공통 작업
  - `test-runner/`: 테스트 실행 관련

---

## 🔄 TDD 사이클별 에이전트 전환 가이드

### RED 단계: 실패하는 테스트 작성

**1단계: 전략 수립**

- **에이전트**: Navigator
- **작업**: 다음 테스트 케이스 제안
- **명령어**:

  ```text
  @agent/sub-agent/navigator.md 다음 테스트 케이스를 제안해줘
  ```

**2단계: 테스트 구현**

- **에이전트**: Driver
- **작업**: Given-When-Then 구조로 테스트 작성
- **명령어**:

  ```text
  @agent/sub-agent/driver.md 이 시나리오를 테스트 코드로 작성해줘
  ```

**3단계: 실행 확인**

- **스킬**: catchup (변경사항 확인)
- **명령어**: `pytest` 실행하여 RED 확인

---

### GREEN 단계: 테스트 통과시키기

**4단계: 최소 구현**

- **에이전트**: Driver
- **작업**: 테스트를 통과시키는 최소 코드 작성
- **명령어**:

  ```text
  @agent/sub-agent/driver.md 이 테스트를 통과시켜줘
  ```

**5단계: 확인**

- **명령어**: `pytest` 실행하여 GREEN 확인

---

### REFACTOR 단계: 코드 개선

**6단계: 코드 리뷰**

- **에이전트**: Reviewer
- **작업**: 코드 스멜 감지 및 개선 제안
- **명령어**:

  ```text
  @agent/sub-agent/reviewer.md 이 코드를 리뷰해줘
  ```

**7단계: 리팩토링 적용**

- **에이전트**: Driver
- **작업**: Reviewer 제안 적용
- **명령어**:

  ```text
  @agent/sub-agent/driver.md 리뷰어 제안을 적용해줘
  ```

**8단계: 회고 및 다음 계획**

- **에이전트**: Navigator
- **작업**: 다음 단계 제안
- **명령어**:

  ```text
  @agent/sub-agent/navigator.md 다음에 뭘 해야 할까?
  ```

---

## 🚀 사용 방법

### Claude Code 사용법

```bash
# 프로젝트 디렉토리에서 Claude Code 실행
claude

# CLAUDE.md를 통해 자동으로 AGENTS.md 로드됨
# 에이전트는 상황에 맞게 자동 활성화되거나, 명시적으로 호출 가능
```

**명시적 호출 예시**:

```text
@agent/sub-agent/navigator.md 네비게이터가 되어 다음 단계를 제안해줘
```

**스킬 자동 활성화 예시**:

```text
최근 작업 내용 catchup 해줘
→ catchup 스킬 자동 활성화
```

---

### Gemini CLI 사용법

```bash
# Gemini CLI 실행
gemini

# 에이전트 호출
@agent/sub-agent/navigator.md 네비게이터가 되서 나와 같이 페어코딩 해줘.

# catchup 명령어 사용 (커스텀 명령어)
@.gemini/commands/catchup.md
```

---

## 📂 디렉토리 구조

```text
python-katas/
├── AGENTS.md                    # 이 파일 - 에이전트 시스템 문서
├── CLAUDE.md                    # @AGENTS.md 참조
├── GEMINI.md                    # @AGENTS.md 참조
│
├── .claude/
│   ├── settings.local.json      # Claude Code 설정
│   ├── commands/
│   │   └── catchup.md           # catchup 커맨드 정의
│   └── skills/                  # Claude 스킬 저장소
│       ├── catchup/             # Git 변경사항 추적
│       ├── skill-creator/       # 스킬 생성 도우미
│       └── shared/              # 에이전트 공유 스킬
│           ├── git-helper/
│           └── test-runner/
│
├── .gemini/
│   └── commands/
│       └── catchup.md           # Gemini용 catchup 커맨드
│
└── agent/
    └── sub-agent/               # 에이전트 정의 파일들
        ├── driver.md            # 드라이버 에이전트
        ├── navigator.md         # 네비게이터 에이전트
        ├── paircoding-coach.md  # 페어 코딩 코치
        ├── reviewer.md          # 리뷰어 에이전트
        └── tdd-coach.md         # TDD 코치 (paircoding-coach 별칭)
```

---

## 💡 실전 시나리오 예시

### 시나리오 1: 새 기능 시작

```bash
# 1. 현재 상태 파악
"지금까지 작업 내용 catchup 해줘"

# 2. 전략 수립
"@agent/sub-agent/navigator.md 다음 기능을 위한 테스트 케이스를 제안해줘"

# 3. 테스트 작성
"@agent/sub-agent/driver.md 제안된 테스트를 구현해줘"

# 4. 구현
"@agent/sub-agent/driver.md 테스트를 통과시켜줘"

# 5. 리팩토링
"@agent/sub-agent/reviewer.md 코드를 리뷰해줘"
```

### 시나리오 2: 막혔을 때

```bash
# 1. 코치 호출
"@agent/sub-agent/paircoding-coach.md 지금 상황에서 뭘 해야 할지 모르겠어"

# 2. 코치의 가이드에 따라 적절한 에이전트로 전환
```

### 시나리오 3: 새 스킬 추가

```bash
# 1. 스킬 생성 요청
"데이터베이스 마이그레이션을 도와주는 스킬을 만들고 싶어"

# 2. skill-creator 스킬이 자동으로 활성화되어 인터뷰 시작
# 3. 필요한 정보 제공 후 스킬 자동 생성
```

---

## 🔍 스킬 발견 가이드

### 사용 가능한 스킬 확인

```text
사용 가능한 스킬 목록 보여줘
```

### 특정 스킬 상세 확인

```bash
# 파일 직접 읽기
cat .claude/skills/catchup/SKILL.md
cat .claude/skills/skill-creator/SKILL.md
```

### 스킬 트리거 키워드

| 스킬 | 트리거 키워드 |
|------|---------------|
| catchup | catchup, 변경사항, git diff, 커밋 히스토리, 작업 내용 |
| skill-creator | 스킬 만들기, 새로운 스킬, 스킬 작성, 베스트 프랙티스 |

---

## ⚙️ 설정 및 팁

### 한글 인코딩

모든 에이전트와 스킬은 한글을 완벽히 지원합니다. Git 명령어 사용 시:

- `LC_ALL=C.UTF-8` 환경변수 설정
- `git -c core.quotepath=false` 옵션 사용

### 에이전트 응답 언어

모든 에이전트는 **항상 한국어**로 응답합니다.

### 커밋 권장 시점

- 각 TDD 사이클(RED-GREEN-REFACTOR) 완료 후
- Navigator가 커밋 권장 시
- 의미 있는 단위 작업 완료 시

---

## 📚 추가 참고 자료

- **Claude Code 문서**: <https://code.claude.com/docs/en/agent-skills>
- **스킬 베스트 프랙티스**: [.claude/skills/skill-creator/best-practices.md](.claude/skills/skill-creator/best-practices.md)
- **스킬 템플릿**: [.claude/skills/skill-creator/template.md](.claude/skills/skill-creator/template.md)

---

## 🤝 기여 가이드

### 새 에이전트 추가

1. `agent/sub-agent/` 디렉토리에 `.md` 파일 생성
2. 역할, 책임, 톤, 사용 시점 명확히 정의
3. `AGENTS.md`에 인덱스 추가

### 새 스킬 추가

1. skill-creator 스킬 사용 또는 수동 생성
2. `.claude/skills/` 또는 `.claude/skills/shared/` 디렉토리에 추가
3. `AGENTS.md`의 스킬 목록 섹션 업데이트

---

**마지막 업데이트**: 2025-11-26
