# Claude 스킬 작성 베스트 프랙티스

## 1. Description 작성 가이드

Description은 Claude가 스킬을 발견하는 **가장 중요한** 요소입니다.

### 좋은 Description의 조건

1. **구체성**: 무엇을 하는지 명확히
2. **트리거 키워드**: 사용자가 언급할 단어 포함
3. **사용 시점**: 언제 사용하는지 명시
4. **간결성**: 1024자 이내, 핵심만 담기

### 나쁜 예시 vs 좋은 예시

#### 예시 1: 파일 분석

❌ **나쁜 예**
```yaml
description: 파일 분석
```

✅ **좋은 예**
```yaml
description: Excel 스프레드시트를 분석하고 피벗 테이블, 차트를 생성합니다. Excel 파일, .xlsx, 스프레드시트, 데이터 분석 작업 시 사용하세요.
```

#### 예시 2: 코드 처리

❌ **나쁜 예**
```yaml
description: 코드 관련 작업
```

✅ **좋은 예**
```yaml
description: Python 코드의 타입 힌트를 추가하고 검증합니다. 타입 체킹, mypy, 타입 애너테이션, Python 타입 힌트 작업 시 사용하세요.
```

#### 예시 3: Git 작업

❌ **나쁜 예**
```yaml
description: Git 도구
```

✅ **좋은 예**
```yaml
description: Git 저장소의 변경사항을 추적하고 요약합니다. 미커밋 코드, 최근 커밋, 커밋 히스토리, catchup 등의 키워드에 반응합니다.
```

## 2. 스킬 범위 설정

### 하나의 스킬 = 하나의 명확한 목적

**집중된 스킬 (권장):**
- `pdf-form-filler`: PDF 폼 채우기
- `excel-analyzer`: Excel 데이터 분석
- `git-commit-helper`: Git 커밋 메시지 생성

**너무 광범위한 스킬 (지양):**
- `document-processor`: 문서 처리 전반 (→ PDF, Excel, Word로 나눔)
- `code-helper`: 코드 관련 모든 것 (→ 린팅, 테스팅, 리팩토링으로 나눔)

### 분리 기준

다음 경우 스킬을 분리하세요:
- 사용하는 도구/라이브러리가 다른 경우
- 트리거 키워드가 완전히 다른 경우
- 사용 시나리오가 겹치지 않는 경우

## 3. allowed-tools 최적화

### 최소 권한 원칙

스킬이 필요한 최소한의 도구만 허용합니다.

#### 읽기 전용 스킬

```yaml
allowed-tools: Read, Grep, Glob
```

**사용 케이스:**
- 코드 분석기
- 로그 조회 도구
- 문서 검색기

#### 데이터 생성 스킬

```yaml
allowed-tools: Read, Write, Bash
```

**사용 케이스:**
- 파일 생성기
- 보고서 생성기
- 코드 스캐폴딩

#### 전체 액세스 스킬

```yaml
allowed-tools: Read, Write, Edit, Bash, Grep, Glob
```

**사용 케이스:**
- 리팩토링 도구
- 프로젝트 설정 도구
- 마이그레이션 스크립트

## 4. 출력 최적화

### 에이전트 컨텍스트 절약

스킬의 출력은 에이전트에게 전달되므로 최소화해야 합니다.

#### 요약 우선

❌ **나쁜 예**
```bash
# 전체 파일 내용 출력
cat large_file.txt
```

✅ **좋은 예**
```bash
# 파일 크기와 라인 수만 출력
wc -l large_file.txt
# 또는 처음 10줄만
head -10 large_file.txt
```

#### 필터링 활용

❌ **나쁜 예**
```bash
git log  # 모든 커밋
```

✅ **좋은 예**
```bash
git log -10 --oneline  # 최근 10개만, 한 줄로
```

#### 불필요한 메타데이터 제거

❌ **나쁜 예**
```bash
git diff  # 모든 메타데이터 포함
```

✅ **좋은 예**
```bash
git diff --stat  # 파일명과 변경량만
```

## 5. 한글 지원

### Bash 명령어 인코딩

```bash
# 항상 UTF-8 인코딩 설정
export LC_ALL=C.UTF-8

# 또는
export LANG=ko_KR.UTF-8
```

### Git 명령어 한글 파일명 처리

```bash
# core.quotepath=false로 한글 파일명 이스케이프 방지
git -c core.quotepath=false diff
git -c core.quotepath=false log
git -c core.quotepath=false status
```

### Python 스크립트 인코딩

```python
# 파일 상단에 인코딩 선언
# -*- coding: utf-8 -*-

# 파일 읽기/쓰기 시 UTF-8 명시
with open('file.txt', 'r', encoding='utf-8') as f:
    content = f.read()
```

## 6. YAML 문법 주의사항

### 기본 규칙

```yaml
---
name: skill-name  # 콜론 뒤 공백 필수
description: 설명입니다.  # 특수문자 포함 시 따옴표 사용
allowed-tools: Read, Write  # 쉼표로 구분
---
```

### 여러 줄 Description

```yaml
---
name: complex-skill
description: >
  여러 줄에 걸친 설명을 작성할 때는
  > 기호를 사용합니다. 이렇게 하면
  자동으로 한 줄로 합쳐집니다.
---
```

### 특수문자 이스케이프

```yaml
# 콜론(:)이나 따옴표가 포함된 경우
description: "Use when: analyzing data, creating reports"
```

## 7. 스킬 테스트 가이드

### 테스트 체크리스트

1. **파일 구조 확인**
   ```bash
   ls -la .claude/skills/your-skill/SKILL.md
   ```

2. **YAML 검증**
   ```bash
   head -n 10 .claude/skills/your-skill/SKILL.md
   ```

3. **Claude Code 재시작**
   ```bash
   # Claude Code를 재시작하여 스킬 로드
   ```

4. **트리거 테스트**
   - Description에 명시한 키워드로 요청
   - 예: "Excel 파일 분석해줘" (excel-analyzer 스킬용)

5. **기능 검증**
   - 각 기능이 제대로 동작하는지 확인
   - 출력이 컴팩트한지 확인
   - 한글이 깨지지 않는지 확인

### 디버깅

스킬이 활성화되지 않는 경우:

1. **Description 확인**
   - 트리거 키워드가 포함되어 있나?
   - 충분히 구체적인가?

2. **YAML 문법 확인**
   - 여는 `---`와 닫는 `---`가 있나?
   - 들여쓰기가 올바른가?
   - 탭 대신 스페이스를 사용했나?

3. **파일 위치 확인**
   - `.claude/skills/[name]/SKILL.md` 경로가 맞나?
   - 파일명이 대문자 `SKILL.md`인가?

## 8. 버전 관리

### 스킬 변경 이력 관리

SKILL.md에 버전 히스토리 섹션 추가:

```markdown
## 버전 히스토리

- v2.0.0 (2025-11-26): 새 기능 추가, API 변경
- v1.1.0 (2025-11-20): 한글 인코딩 지원 추가
- v1.0.0 (2025-11-15): 초기 버전
```

### Git 커밋 메시지

```bash
# 스킬 추가
git commit -m "✨ Add new skill: excel-analyzer"

# 스킬 수정
git commit -m "📝 Update catchup skill description"

# 스킬 제거
git commit -m "🗑️ Remove deprecated pdf-processor skill"
```

## 9. 팀 공유

### 프로젝트 스킬 vs 개인 스킬

**프로젝트 스킬** (`.claude/skills/`)
- 팀 전체가 사용
- Git에 커밋
- 프로젝트 규칙/워크플로우

**개인 스킬** (`~/.claude/skills/`)
- 개인 생산성 도구
- Git에 커밋하지 않음
- 개인 선호도

### 문서화

팀 스킬은 README를 추가하여 설명:

```markdown
# Excel Analyzer Skill

팀의 Excel 데이터 분석을 위한 스킬입니다.

## 사용법

"Excel 파일 분석해줘" 또는 "스프레드시트 데이터 요약해줘"

## 의존성

- `openpyxl` 패키지 필요
- Python 3.8 이상
```

## 10. 일반적인 실수

### 실수 1: Description이 너무 짧음

❌ `description: PDF 처리`
✅ `description: PDF 파일에서 텍스트 추출, 폼 채우기, 문서 병합. PDF, 문서 추출, 폼 작업 시 사용하세요.`

### 실수 2: 스킬 이름에 대문자 사용

❌ `name: ExcelAnalyzer`
✅ `name: excel-analyzer`

### 실수 3: allowed-tools 과다 지정

❌ 모든 도구 허용 (필요 없는데도)
✅ 실제 사용하는 도구만 명시

### 실수 4: 출력이 너무 장황함

❌ 모든 로그와 디버그 정보 출력
✅ 요약된 결과만 출력, 상세 내용은 선택적

### 실수 5: 테스트 없이 배포

❌ 작성 후 바로 팀에 공유
✅ 로컬에서 충분히 테스트 후 공유

## 참고 자료

- [Claude Code 공식 문서](https://code.claude.com/docs/en/agent-skills)
- [YAML 문법 가이드](https://yaml.org/spec/1.2.2/)
- 프로젝트 예시: [catchup](./../catchup/SKILL.md)
