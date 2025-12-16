# 플랫폼별 설정 가이드

이 디렉토리는 Windows와 Linux/macOS 플랫폼에 따라 다른 스크립트 및 설정 파일을 관리합니다.

---

## 디렉토리 구조

```
platforms/
├── windows/              # Windows 전용 파일
│   ├── .claude/
│   │   └── skills/      # Windows용 SKILL.md (cmd 명령어)
│   ├── scripts/         # Windows용 배치 스크립트 (.bat)
│   └── .katarc.patch    # Windows 플랫폼 설정
│
├── linux/               # Linux/macOS 전용 파일
│   ├── .claude/
│   │   └── skills/      # Linux용 SKILL.md (bash 명령어)
│   ├── scripts/         # Linux용 쉘 스크립트 (.sh)
│   └── .katarc.patch    # Linux 플랫폼 설정
│
└── README.md            # 이 파일
```

---

## 플랫폼 설정 방법

### 자동 설정 (권장)

`setup-platform.py` 스크립트를 사용하여 자동으로 플랫폼별 파일을 설정할 수 있습니다.

```bash
# 플랫폼 자동 감지
python setup-platform.py

# 또는 플랫폼 명시
python setup-platform.py windows  # Windows 사용자
python setup-platform.py linux    # Linux/macOS 사용자
```

**스크립트 동작**:
1. `.katarc`가 없으면 `.katarc.example`에서 복사
2. `platforms/{platform}/` 파일을 프로젝트 루트로 복사
   - `scripts/` - 플랫폼별 헬퍼 스크립트
   - `.claude/skills/*/SKILL.md` - 플랫폼별 스킬 명세
3. 플랫폼 설정을 `.katarc`에 추가
4. Linux/macOS의 경우 스크립트에 실행 권한 부여

### 수동 설정

자동 설정 스크립트를 사용할 수 없는 경우, 다음과 같이 수동으로 설정할 수 있습니다.

#### Windows

1. **스크립트 복사**
   ```cmd
   xcopy /E /I /Y platforms\windows\scripts scripts
   ```

2. **SKILL.md 복사**
   ```cmd
   xcopy /E /I /Y platforms\windows\.claude .claude
   ```

3. **.katarc 업데이트**
   ```cmd
   type platforms\windows\.katarc.patch >> .katarc
   ```

#### Linux/macOS

1. **스크립트 복사**
   ```bash
   cp -r platforms/linux/scripts/* scripts/
   chmod +x scripts/*.sh
   ```

2. **SKILL.md 복사**
   ```bash
   cp -r platforms/linux/.claude/skills/* .claude/skills/
   ```

3. **.katarc 업데이트**
   ```bash
   cat platforms/linux/.katarc.patch >> .katarc
   ```

---

## 플랫폼별 차이점

### 1. 스크립트 확장자

| 플랫폼 | 확장자 | 예시 |
|--------|--------|------|
| Windows | `.bat` | `git-helper.bat` |
| Linux/macOS | `.sh` | `git-helper.sh` |

### 2. 경로 구분자

| 플랫폼 | 구분자 | 예시 |
|--------|--------|------|
| Windows | `\` (백슬래시) | `scripts\git-helper.bat` |
| Linux/macOS | `/` (슬래시) | `./scripts/git-helper.sh` |

### 3. 명령어 형식

**Windows (cmd):**
```cmd
REM 주석
scripts\git-helper.bat status
```

**Linux/macOS (bash):**
```bash
# 주석
./scripts/git-helper.sh status
```

### 4. 가상환경 활성화

| 플랫폼 | 경로 |
|--------|------|
| Windows | `.venv\Scripts\activate.bat` |
| Linux/macOS | `.venv/bin/activate` |

---

## 파일 설명

### .katarc.patch

플랫폼별 환경 변수를 `.katarc` 파일에 추가하기 위한 패치 파일입니다.

**Windows:**
```bash
PLATFORM=windows
SCRIPT_EXT=.bat
VENV_ACTIVATE=.venv\Scripts\activate.bat
```

**Linux/macOS:**
```bash
PLATFORM=linux
SCRIPT_EXT=.sh
VENV_ACTIVATE=.venv/bin/activate
```

### SKILL.md 파일

Claude 스킬의 명령어 예시가 플랫폼에 맞게 작성되어 있습니다.

- **Windows**: `cmd` 코드 블록, `\` 경로 구분자
- **Linux/macOS**: `bash` 코드 블록, `/` 경로 구분자

---

## Git 충돌 방지

`.gitignore`에 플랫폼별로 생성된 파일들이 등록되어 있어, 서로 다른 플랫폼 사용자 간 충돌이 발생하지 않습니다.

**무시되는 파일:**
- `.claude/skills/catchup/SKILL.md`
- `.claude/skills/python-runner/SKILL.md`
- `.claude/skills/study-note/SKILL.md`
- `scripts/git-helper.*`
- `scripts/python-runner.*`
- `scripts/study-note-helper.*`
- `.katarc`

---

## 트러블슈팅

### 문제: 스크립트 실행 권한 오류 (Linux/macOS)

```bash
chmod +x scripts/*.sh
```

### 문제: UTF-8 인코딩 문제 (Windows)

배치 스크립트는 자동으로 UTF-8 인코딩을 설정합니다 (`chcp 65001`).

### 문제: 가상환경을 찾을 수 없음

```bash
# 가상환경 생성
uv venv
uv sync
```

---

## 기여 가이드

새로운 스크립트를 추가하거나 수정할 때는 **반드시 양쪽 플랫폼 모두 업데이트**해야 합니다:

1. `platforms/linux/scripts/` - Linux/macOS용 `.sh` 스크립트
2. `platforms/windows/scripts/` - Windows용 `.bat` 스크립트
3. 해당 SKILL.md 파일도 플랫폼에 맞게 수정

---

## 참고 자료

- [Git Bash for Windows](https://git-scm.com/download/win)
- [Windows Subsystem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/)
- [uv 패키지 매니저](https://github.com/astral-sh/uv)
