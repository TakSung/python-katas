---
name: skill-creator
description: Claude 스킬을 생성하고 작성하는 것을 도와줍니다. 새로운 스킬 만들기, 스킬 작성 가이드, 베스트 프랙티스 적용 등의 키워드에 반응합니다.
allowed-tools: Write, Read, Bash, Glob
---

# Skill Creator - Claude 스킬 생성 도우미

새로운 Claude 스킬을 생성하고 베스트 프랙티스에 맞게 작성하는 것을 도와주는 스킬입니다.

## 주요 기능

### 1. 스킬 구조 선택

새 스킬을 만들 때 다음 두 가지 패턴 중 선택합니다:

#### 패턴 A: 헬퍼 스크립트 기반 스킬 (권장)

복잡한 로직이나 반복 작업이 필요한 경우:

```
.claude/skills/[skill-name]/
└── SKILL.md

platforms/linux/scripts/
└── [skill-name]-helper.sh

platforms/windows/scripts/
└── [skill-name]-helper.bat
```

**생성 명령어:**
```bash
# 1. 스킬 디렉토리 생성
mkdir -p .claude/skills/[스킬-이름]

# 2. 플랫폼 스크립트 디렉토리 생성
mkdir -p platforms/linux/scripts
mkdir -p platforms/windows/scripts

# 3. 헬퍼 스크립트 생성
touch platforms/linux/scripts/[스킬-이름]-helper.sh
touch platforms/windows/scripts/[스킬-이름]-helper.bat

# 4. Linux 스크립트 실행 권한
chmod +x platforms/linux/scripts/[스킬-이름]-helper.sh
```

**사용 예시:**
- `catchup`: Git 변경사항 추적 (`git-helper.sh`)
- `python-runner`: Python 프로젝트 실행 (`python-runner.sh`)
- `study-note`: 학습 노트 기록 (`study-note-helper.sh`)

#### 패턴 B: 단순 스킬 (헬퍼 스크립트 없음)

간단한 Bash 명령어만 사용하는 경우:

```
.claude/skills/[skill-name]/
└── SKILL.md
```

**사용 예시:**
- 간단한 파일 읽기/검색
- 단일 명령어 실행
- 정보 조회

### 2. SKILL.md 작성 가이드

스킬 파일은 다음 구조를 따릅니다:

```markdown
---
name: skill-name
description: 스킬이 무엇을 하는지 + 언제 사용하는지를 명확히 작성. 트리거 키워드 포함.
allowed-tools: Tool1, Tool2, Tool3
---

# 스킬 제목

간단한 소개

## 주요 기능

### 기능 1: 기능 이름

설명과 예시 코드

### 기능 2: 기능 이름

설명과 예시 코드

## 사용 예시

구체적인 사용 케이스

## 주의사항

알아야 할 제약사항이나 요구사항
```

**SKILL.md에서 헬퍼 스크립트 호출 방법:**

```markdown
## 주요 기능

### 기능 1: 상태 확인

현재 상태를 확인합니다.

| 작업 | 명령어 | 설명 |
|---|---|---|
| **상태 확인** | `./scripts/스킬이름-helper.sh status` | 현재 상태 출력 |

**사용 예시:**
> "상태 확인해줘"

→ `./scripts/스킬이름-helper.sh status`를 실행하여 결과 표시
```

### 3. 헬퍼 스크립트 작성 가이드

헬퍼 스크립트는 다음 구조를 따릅니다:

#### Linux 스크립트 (.sh) 템플릿

```bash
#!/bin/bash

# UTF-8 설정
export LC_ALL=C.UTF-8

# 프로젝트 루트 및 설정 로드
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$PROJECT_ROOT"

KATARC_FILE=".katarc"

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 헬퍼 함수
error_exit() {
    echo -e "${RED}❌ 오류:${NC} $1" >&2
    exit "${2:-1}"
}

success_msg() {
    echo -e "${GREEN}✅${NC} $1"
}

info_msg() {
    echo -e "${YELLOW}ℹ${NC}  $1"
}

# .katarc 로드
load_config() {
    if [ ! -f "$KATARC_FILE" ]; then
        error_exit ".katarc not found"
    fi
    source "$KATARC_FILE"
}

# 사용법 출력
usage() {
    echo "Usage: $0 {command1|command2|help}"
    echo ""
    echo "Commands:"
    echo "  command1    - 설명"
    echo "  command2    - 설명"
    echo "  help        - Show this help message"
}

# 메인 로직
main() {
    load_config

    local command="${1:-help}"
    shift || true

    case "$command" in
        command1)
            # 구현
            ;;
        command2)
            # 구현
            ;;
        help|*)
            usage
            ;;
    esac
}

main "$@"
```

#### Windows 스크립트 (.bat) 템플릿

```batch
@echo off
setlocal enabledelayedexpansion
chcp 65001 > nul

REM Change to project root
cd /d "%~dp0\..\..\"

REM Colors (ANSI escape codes)
set "RED=[31m"
set "GREEN=[32m"
set "YELLOW=[33m"
set "BLUE=[34m"
set "NC=[0m"

REM Load .katarc
set KATARC_FILE=.katarc
if not exist "%KATARC_FILE%" (
    echo %RED%❌ .katarc not found%NC%
    exit /b 1
)

for /f "tokens=1,2 delims==" %%a in (%KATARC_FILE%) do (
    if "%%a"=="CURRENT_KATA" set CURRENT_KATA=%%b
)

REM Main command dispatcher
set COMMAND=%1
if "%COMMAND%"=="" set COMMAND=help
shift

if "%COMMAND%"=="command1" goto cmd_command1
if "%COMMAND%"=="command2" goto cmd_command2
if "%COMMAND%"=="help" goto cmd_help
goto cmd_help

:cmd_command1
echo Processing command1...
exit /b 0

:cmd_command2
echo Processing command2...
exit /b 0

:cmd_help
echo Usage: %~nx0 ^<command^> [options]
echo.
echo Commands:
echo   command1    - 설명
echo   command2    - 설명
echo   help        - Show this help message
exit /b 0
```

### 4. setup-platform.py 연동

헬퍼 스크립트를 생성한 후 `setup-platform.py`를 통해 배포합니다:

```bash
# 플랫폼별 스크립트 복사 및 .katarc 업데이트
python setup-platform.py
```

**setup-platform.py가 하는 일:**
1. 현재 플랫폼 감지 (Linux/Windows)
2. `platforms/{platform}/scripts/`에서 `scripts/`로 스크립트 복사
3. `.katarc`에 플랫폼 설정 추가

**배포 후 스크립트 경로:**
```
scripts/
├── git-helper.sh (또는 .bat)
├── python-runner.sh (또는 .bat)
└── study-note-helper.sh (또는 .bat)
```

### 5. 베스트 프랙티스 적용

새 스킬 작성 시 다음 원칙을 따릅니다:

#### Description 작성 원칙
- **구체적으로**: "문서 처리" ❌ → "PDF 파일에서 텍스트와 표 추출" ✅
- **트리거 포함**: 사용자가 언급할 키워드를 description에 포함
- **언제 사용하는지 명시**: "Use when..." 형태로 사용 시점 설명

**예시:**
```yaml
# 나쁜 예
description: 데이터 분석 도구

# 좋은 예
description: Excel 스프레드시트를 분석하고 피벗 테이블과 차트를 생성합니다. Excel 파일, 스프레드시트, .xlsx 파일 작업 시 사용하세요.
```

#### 스킬 범위
- **집중된 기능**: 하나의 스킬은 하나의 명확한 목적
- **너무 광범위하면 분리**: "문서 처리" → "PDF 처리", "Excel 분석" 등으로 나눔

#### 도구 제한 (allowed-tools)
- **읽기 전용 스킬**: `Read, Grep, Glob`만 허용
- **생성 스킬**: `Write, Bash` 추가
- **분석 스킬**: 필요한 최소한의 도구만 지정

#### 출력 최적화
- 불필요한 메타데이터 제거
- 요약 우선, 상세 내용은 선택적으로
- 에이전트에게 전달될 컨텍스트를 최소화

#### 한글 지원
- Bash 명령어 사용 시: `export LC_ALL=C.UTF-8`
- Git 명령어: `git -c core.quotepath=false`
- 파일 인코딩: UTF-8 사용

#### 스킬 참조 패턴 (IMPORTANT)

에이전트 파일에서 스킬을 참조할 때 **@ 기호를 사용하지 마세요**.

**이유**: `@` 기호는 파일 내용을 즉시 로드하여 프롬프트에 포함시킵니다. 이는 불필요한 컨텍스트 낭비를 야기합니다.

**잘못된 패턴 (❌)**:
```text
# AVAILABLE SKILLS

(at)../../.claude/skills/catchup/SKILL.md
(at)../../.claude/skills/skill-creator/SKILL.md
```
→ @ 기호로 인해 스킬 파일 전체가 즉시 프롬프트에 로드되어 컨텍스트 낭비

Note: (at)을 @로 바꿔서 사용하면 안 됩니다!

**올바른 패턴 (✅)**:
```markdown
# AVAILABLE SKILLS

../../.claude/skills/catchup/SKILL.md
../../.claude/skills/skill-creator/SKILL.md
```
→ 경로만 참조 정보로 표시, 필요할 때만 로드

**적용 원칙**:
- 에이전트 파일(`agent/sub-agent/*.md`)에서 스킬 경로를 명시할 때는 `@` 없이 경로만 작성
- 참조 정보로만 활용하고, Claude가 필요 시 스킬을 자동으로 발견하도록 함
- description의 트리거 키워드로 스킬 발견을 유도

**에이전트 파일 vs 스킬 파일 내부 참조 차이**:

1. **에이전트 파일에서 (`agent/sub-agent/*.md`)**:
   - 목적: 사용 가능한 스킬 목록을 문서화/표시
   - 패턴: 단순 경로 텍스트만 사용
   - 예시: `../../.claude/skills/catchup/SKILL.md`
   - 링크 불필요: 마크다운 링크 형식 `[파일](파일.md)` 사용하지 않음
   - 이유: 스킬 발견은 description의 트리거 키워드로 자동 처리

2. **스킬 파일 내부에서 (`SKILL.md` 안에서)**:
   - 목적: Progressive Disclosure를 위한 추가 문서 참조
   - 패턴: 마크다운 링크 형식 사용
   - 예시: `For details, see [reference.md](reference.md)`
   - 링크 필요: Claude가 필요할 때만 lazy loading
   - 이유: 컨텍스트 효율적 관리

### 6. 스킬 검증 체크리스트

새 스킬을 생성한 후 다음을 확인합니다:

```bash
# 1. 파일 존재 확인
ls -la .claude/skills/[스킬-이름]/SKILL.md

# 2. 헬퍼 스크립트 확인 (패턴 A인 경우)
ls -la platforms/linux/scripts/[스킬-이름]-helper.sh
ls -la platforms/windows/scripts/[스킬-이름]-helper.bat

# 3. setup-platform.py 실행
python setup-platform.py

# 4. 스크립트 실행 확인
./scripts/[스킬-이름]-helper.sh help

# 5. YAML frontmatter 검증
head -n 10 .claude/skills/[스킬-이름]/SKILL.md

# 6. 스킬 목록 확인 (Claude Code 재시작 후)
# Claude에게 "사용 가능한 스킬 목록 보여줘" 요청
```

**검증 항목:**
- [ ] name이 kebab-case인가?
- [ ] description이 구체적이고 트리거 키워드를 포함하는가?
- [ ] allowed-tools가 필요한 최소한의 도구만 포함하는가?
- [ ] YAML 문법이 올바른가? (---, 들여쓰기, 콜론)
- [ ] 헬퍼 스크립트가 Linux/Windows 둘 다 존재하는가?
- [ ] 헬퍼 스크립트가 UTF-8을 지원하는가?
- [ ] setup-platform.py로 배포 후 scripts/에 복사되었는가?
- [ ] 사용 예시가 구체적인가?

## 인터뷰 프로세스

사용자가 새 스킬을 만들고 싶어할 때 다음 순서로 진행합니다:

### 1단계: 스킬 패턴 결정

**질문**: "이 스킬은 헬퍼 스크립트가 필요한 복잡한 작업인가요, 아니면 간단한 명령어만 실행하나요?"

- **패턴 A 선택**: 복잡한 로직, 반복 작업, 여러 명령어 조합
- **패턴 B 선택**: 단일 명령어, 간단한 조회

### 2단계: 기본 정보 수집

**필수 정보:**
1. **스킬 이름** (kebab-case, 소문자+하이픈, 최대 64자)
   - "어떤 이름의 스킬을 만들고 싶으신가요? (예: my-skill-name)"

2. **스킬 설명** (무엇을 + 언제)
   - "이 스킬이 무엇을 하길 원하시나요? 어떤 문제를 해결하나요?"

3. **트리거 키워드**
   - "사용자가 어떤 말을 했을 때 이 스킬을 사용하길 원하시나요? (예: 'PDF 분석', '코드 리뷰')"

4. **필요한 도구**
   - "이 스킬이 사용할 도구는 무엇인가요? (Bash, Read, Write, Grep, Glob 등)"

5. **사용 예시**
   - "구체적인 사용 시나리오를 하나 알려주시겠어요?"

### 3단계: 헬퍼 스크립트 설계 (패턴 A인 경우)

**질문:**
1. "헬퍼 스크립트가 제공할 명령어들은 무엇인가요? (예: status, add, search)"
2. ".katarc에서 필요한 설정 값이 있나요? (예: CURRENT_KATA, ENV_TYPE)"
3. "각 명령어의 입력 인자는 무엇인가요?"

### 4단계: 파일 생성

1. 스킬 디렉토리 및 SKILL.md 생성
2. (패턴 A인 경우) 헬퍼 스크립트 생성 (Linux + Windows)
3. setup-platform.py 실행
4. 검증 체크리스트 실행

## 템플릿 사용

기본 템플릿은 [template.md](template.md)를 참조하세요.

헬퍼 스크립트 템플릿은 다음을 참조하세요:
- Linux: [helper-script-template.sh](helper-script-template.sh)
- Windows: [helper-script-template.bat](helper-script-template.bat)

베스트 프랙티스 상세 가이드는 [best-practices.md](best-practices.md)를 참조하세요.

## 사용 예시

**예시 1: 새 헬퍼 스크립트 기반 스킬 생성**
> "테스트 커버리지를 측정하고 보고서를 생성하는 스킬을 만들고 싶어"

→ 인터뷰 프로세스 시작
→ 패턴 A 선택 (복잡한 작업)
→ coverage-reporter 스킬 + 헬퍼 스크립트 생성
→ setup-platform.py 실행
→ 검증 완료

**예시 2: 단순 스킬 생성**
> "프로젝트 디렉토리 구조를 tree 명령어로 보여주는 스킬"

→ 인터뷰 프로세스 시작
→ 패턴 B 선택 (단일 명령어)
→ tree-viewer 스킬만 생성 (SKILL.md만)
→ 검증 완료

**예시 3: 기존 스킬 개선**
> "catchup 스킬의 description을 더 구체적으로 만들어줘"

→ 스킬 파일 읽고, 베스트 프랙티스 적용하여 개선

**예시 4: 스킬 검증**
> "방금 만든 스킬이 제대로 작성되었는지 확인해줘"

→ 검증 체크리스트 실행

## 주의사항

1. **스킬 이름 규칙**: 소문자, 숫자, 하이픈만 사용 (최대 64자)
2. **Description 중요성**: Claude가 스킬을 발견하는 유일한 방법
3. **도구 최소화**: 필요한 최소한의 도구만 허용
4. **헬퍼 스크립트 위치**: `platforms/{linux|windows}/scripts/`에 생성
5. **setup-platform.py 필수**: 헬퍼 스크립트를 `scripts/`로 복사
6. **플랫폼 독립성**: Linux/Windows 둘 다 구현
7. **UTF-8 인코딩**: 한글 지원 필수
8. **테스트 필수**: 스킬 생성 후 반드시 Claude Code 재시작 후 테스트

## 참고 자료

- Claude Code 공식 문서: https://code.claude.com/docs/en/agent-skills
- 이 프로젝트의 스킬 예시: [catchup](./../catchup/SKILL.md), [python-runner](./../python-runner/SKILL.md), [study-note](./../study-note/SKILL.md)
- 헬퍼 스크립트 예시: [platforms/linux/scripts/](../../platforms/linux/scripts/)
