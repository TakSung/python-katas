---
name: skill-creator
description: Claude 스킬을 생성하고 작성하는 것을 도와줍니다. 새로운 스킬 만들기, 스킬 작성 가이드, 베스트 프랙티스 적용 등의 키워드에 반응합니다.
allowed-tools: Write, Read, Bash, Glob
---

# Skill Creator - Claude 스킬 생성 도우미

새로운 Claude 스킬을 생성하고 베스트 프랙티스에 맞게 작성하는 것을 도와주는 스킬입니다.

## 주요 기능

### 1. 새 스킬 생성 프로세스

사용자와 인터뷰하여 필요한 정보를 수집하고 스킬을 생성합니다.

**필수 수집 정보:**
1. **스킬 이름** (kebab-case, 소문자+하이픈, 최대 64자)
2. **스킬 설명** (무엇을 하는지 + 언제 사용하는지, 최대 1024자)
3. **주요 기능** (스킬이 제공할 기능들)
4. **사용 도구** (Bash, Read, Write, Grep, Glob 등)
5. **예시 사용 케이스** (사용자가 어떻게 요청할지)

### 2. 스킬 구조 생성

```bash
# 스킬 디렉토리 생성
mkdir -p .claude/skills/[스킬-이름]

# 필요시 서브 디렉토리 생성
mkdir -p .claude/skills/[스킬-이름]/scripts
mkdir -p .claude/skills/[스킬-이름]/templates
```

### 3. SKILL.md 작성 가이드

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

### 4. 베스트 프랙티스 적용

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

### 5. 스킬 검증 체크리스트

새 스킬을 생성한 후 다음을 확인합니다:

```bash
# 1. 파일 존재 확인
ls -la .claude/skills/[스킬-이름]/SKILL.md

# 2. YAML frontmatter 검증
head -n 10 .claude/skills/[스킬-이름]/SKILL.md

# 3. 스킬 목록 확인 (Claude Code 재시작 후)
# Claude에게 "사용 가능한 스킬 목록 보여줘" 요청
```

**검증 항목:**
- [ ] name이 kebab-case인가?
- [ ] description이 구체적이고 트리거 키워드를 포함하는가?
- [ ] allowed-tools가 필요한 최소한의 도구만 포함하는가?
- [ ] YAML 문법이 올바른가? (---, 들여쓰기, 콜론)
- [ ] 사용 예시가 구체적인가?
- [ ] 한글 인코딩 처리가 필요한 경우 포함되었는가?

## 인터뷰 프로세스

사용자가 새 스킬을 만들고 싶어할 때 다음 순서로 질문합니다:

### 질문 1: 스킬 이름
"어떤 이름의 스킬을 만들고 싶으신가요? (kebab-case, 예: my-skill-name)"

### 질문 2: 스킬 목적
"이 스킬이 무엇을 하길 원하시나요? 어떤 문제를 해결하나요?"

### 질문 3: 트리거 키워드
"사용자가 어떤 말을 했을 때 이 스킬을 사용하길 원하시나요? (예: 'PDF 분석', '코드 리뷰')"

### 질문 4: 필요한 도구
"이 스킬이 사용할 도구는 무엇인가요? (Bash, Read, Write, Grep, Glob 등)"

### 질문 5: 사용 예시
"구체적인 사용 시나리오를 하나 알려주시겠어요?"

## 템플릿 사용

기본 템플릿은 [template.md](template.md)를 참조하세요.

베스트 프랙티스 상세 가이드는 [best-practices.md](best-practices.md)를 참조하세요.

## 사용 예시

**예시 1: 새 스킬 생성**
> "API 문서를 자동으로 생성하는 스킬을 만들고 싶어"

→ 인터뷰 프로세스 시작, 정보 수집 후 스킬 생성

**예시 2: 기존 스킬 개선**
> "catchup 스킬의 description을 더 구체적으로 만들어줘"

→ 스킬 파일 읽고, 베스트 프랙티스 적용하여 개선

**예시 3: 스킬 검증**
> "방금 만든 스킬이 제대로 작성되었는지 확인해줘"

→ 검증 체크리스트 실행

## 주의사항

1. **스킬 이름 규칙**: 소문자, 숫자, 하이픈만 사용 (최대 64자)
2. **Description 중요성**: Claude가 스킬을 발견하는 유일한 방법
3. **도구 최소화**: 필요한 최소한의 도구만 허용
4. **테스트 필수**: 스킬 생성 후 반드시 Claude Code 재시작 후 테스트
5. **한글 지원**: 한글 파일명/내용 처리 시 인코딩 설정 필수

## 참고 자료

- Claude Code 공식 문서: https://code.claude.com/docs/en/agent-skills
- 이 프로젝트의 스킬 예시: [catchup](./../catchup/SKILL.md)
