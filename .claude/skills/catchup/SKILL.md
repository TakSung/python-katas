---
name: catchup
description: Git 저장소의 변경사항을 추적하고 요약합니다. 미커밋 코드, 최근 커밋, 커밋 히스토리를 확인할 때 사용하세요. catchup, 변경사항, git diff, 커밋 히스토리, 작업 내용 파악 등의 키워드에 반응합니다.
allowed-tools: Bash, Read
---

# Catchup - Git 변경사항 추적 스킬

현재 작업 중인 코드의 변경사항을 빠르게 파악하여 컨텍스트를 제공하는 스킬입니다.

## 주요 기능

### 1. 미커밋 변경사항 확인

커밋되지 않은 모든 변경사항(staged + unstaged)을 확인합니다.

```bash
# 한글 인코딩 설정
export LC_ALL=C.UTF-8

# Unstaged 변경사항
echo "📝 Unstaged changes:"
git -c core.quotepath=false diff --stat

# Staged 변경사항
echo ""
echo "✅ Staged changes:"
git -c core.quotepath=false diff --cached --stat

# 변경사항이 있는 경우 상세 diff 제공 (선택적)
if [ -n "$(git status --porcelain)" ]; then
  echo ""
  echo "📊 Detailed diff:"
  git -c core.quotepath=false diff HEAD --compact-summary
fi
```

**사용 시기**: "미커밋된 코드 변경사항 보여줘", "아직 커밋 안 한 코드 확인"

### 2. 직전 커밋 변경사항 확인

바로 직전에 커밋된 내용을 확인합니다.

```bash
export LC_ALL=C.UTF-8

echo "🔖 Latest commit:"
git -c core.quotepath=false log -1 --stat --pretty=format:"%h - %s (%ar)%n"
echo ""
echo ""
echo "📄 Changes in latest commit:"
git -c core.quotepath=false show HEAD --stat --compact-summary
```

**사용 시기**: "직전 커밋 확인", "마지막 커밋 내용 보여줘", "방금 커밋한 내용"

### 3. 최근 10개 커밋 목록 확인

커밋 메시지만 간단히 확인하여 최근 작업 흐름을 파악합니다.

```bash
export LC_ALL=C.UTF-8

echo "📋 최근 10개 커밋 목록:"
git -c core.quotepath=false log -10 --oneline --decorate --color=never
```

**사용 시기**: "최근 커밋 목록", "커밋 히스토리 확인", "최근에 무슨 작업했는지"

### 4. 특정 범위 커밋 변경사항 확인

두 커밋 해시 사이의 모든 변경사항을 커밋별로 나눠서 확인합니다.

```bash
export LC_ALL=C.UTF-8

# 사용자로부터 시작/끝 해시를 받음
START_HASH="<시작_해시>"
END_HASH="<끝_해시>"

echo "📊 커밋 범위: ${START_HASH}..${END_HASH}"
echo ""

# 해당 범위의 커밋 목록
git -c core.quotepath=false log ${START_HASH}..${END_HASH} --oneline --decorate --color=never

echo ""
echo "📝 각 커밋별 상세 변경사항:"
echo ""

# 각 커밋별로 변경사항 출력
for commit in $(git rev-list ${START_HASH}..${END_HASH}); do
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  git -c core.quotepath=false show $commit --stat --pretty=format:"🔖 %h - %s%n👤 %an (%ar)%n" --compact-summary
  echo ""
done
```

**사용 시기**: "특정 커밋 범위 확인", "해시 A부터 해시 B까지 변경사항", "여러 커밋 비교"

## 출력 최적화 가이드

에이전트에게 전달되는 컨텍스트를 최소화하기 위해:

1. **--stat**: 파일명과 변경 라인 수만 표시
2. **--compact-summary**: 파일 추가/삭제/이름변경 정보만 간결하게 표시
3. **--oneline**: 커밋 해시와 메시지만 한 줄로 표시
4. **core.quotepath=false**: 한글 파일명이 이스케이프되지 않도록 설정
5. **LC_ALL=C.UTF-8**: 한글 인코딩 깨짐 방지

## 사용 예시

**예시 1: 현재 작업 파악**
> "지금까지 뭐 작업했는지 catchup 해줘"

→ 미커밋 변경사항 + 최근 커밋 확인

**예시 2: 특정 커밋 조사**
> "커밋 abc123부터 def456까지 뭐가 바뀌었는지 보여줘"

→ 커밋 범위 변경사항 출력

**예시 3: 최근 히스토리 확인**
> "최근에 어떤 작업들을 했는지 커밋 목록 보여줘"

→ 최근 10개 커밋 목록 출력

## 주의사항

- Git 저장소 루트에서 실행되어야 합니다
- 한글 파일명/커밋 메시지가 포함된 경우 반드시 UTF-8 인코딩 설정 필요
- 큰 diff는 --stat으로 요약하여 컨텍스트 절약
- 필요시에만 전체 diff 내용을 제공하도록 선택적으로 사용
