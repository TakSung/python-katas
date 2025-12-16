#!/bin/bash

# ============================================================================
# study-note-helper.sh
# 학습 노트를 아카이브 파일에 스택 형식으로 추가하는 헬퍼 스크립트
# ============================================================================

# --- Environment Setup ---
export LC_ALL=C.UTF-8
export LANG=ko_KR.UTF-8

# --- Configuration ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
KATARC_FILE="$PROJECT_ROOT/.katarc"

# --- Error Codes ---
ERROR_NO_KATARC=1
ERROR_NO_CURRENT_KATA=2
ERROR_MISSING_ARGS=3
ERROR_STUDY_DIR_CREATE_FAILED=4
ERROR_APPEND_FAILED=5

# --- Colors for terminal output ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# ============================================================================
# Helper Functions
# ============================================================================

# Print error message and exit
error_exit() {
    local message="$1"
    local code="${2:-1}"
    echo -e "${RED}❌ 오류:${NC} $message" >&2
    exit "$code"
}

# Print success message
success_msg() {
    echo -e "${GREEN}✅${NC} $1"
}

# Print info message
info_msg() {
    echo -e "${YELLOW}ℹ${NC}  $1"
}

# Load .katarc configuration
load_katarc() {
    if [[ ! -f "$KATARC_FILE" ]]; then
        error_exit ".katarc 파일을 찾을 수 없습니다: $KATARC_FILE" $ERROR_NO_KATARC
    fi

    # Source the .katarc file to get CURRENT_KATA
    # Using grep/sed for safety instead of direct sourcing
    CURRENT_KATA=$(grep "^CURRENT_KATA=" "$KATARC_FILE" | cut -d'=' -f2 | tr -d ' ')

    if [[ -z "$CURRENT_KATA" ]]; then
        error_exit ".katarc에 CURRENT_KATA 변수가 설정되지 않았습니다." $ERROR_NO_CURRENT_KATA
    fi

    info_msg "현재 KATA: $CURRENT_KATA"
}

# Resolve study directory path
get_study_path() {
    local kata="$1"
    echo "$PROJECT_ROOT/$kata/docs/study"
}

# Get archive file path
get_archive_path() {
    local study_path="$1"
    echo "$study_path/아카이브.md"
}

# Generate timestamp in KST
get_timestamp() {
    # macOS/BSD date format for KST (UTC+9)
    if date --version >/dev/null 2>&1; then
        # GNU date (Linux)
        TZ='Asia/Seoul' date '+%Y-%m-%d %H:%M:%S KST'
    else
        # BSD date (macOS)
        TZ='Asia/Seoul' date '+%Y-%m-%d %H:%M:%S KST'
    fi
}

# Create study directory if it doesn't exist
ensure_study_directory() {
    local study_path="$1"

    if [[ ! -d "$study_path" ]]; then
        info_msg "학습 디렉토리가 없습니다. 생성합니다: $study_path"
        mkdir -p "$study_path" || error_exit "디렉토리 생성 실패: $study_path" $ERROR_STUDY_DIR_CREATE_FAILED
    fi
}

# Initialize archive file if it doesn't exist
initialize_archive() {
    local archive_path="$1"

    if [[ ! -f "$archive_path" ]]; then
        info_msg "아카이브 파일이 없습니다. 새로 생성합니다: $archive_path"
        cat > "$archive_path" <<'EOF'
# 학습 아카이브

이 파일은 학습 중 떠오른 아이디어, 메모, 질문을 시간순으로 기록합니다.

---

EOF
        if [[ $? -ne 0 ]]; then
            error_exit "아카이브 파일 초기화 실패: $archive_path" $ERROR_APPEND_FAILED
        fi
        success_msg "아카이브 파일 생성됨: $archive_path"
    fi
}

# Append note to archive
append_note() {
    local archive_path="$1"
    local keyword="$2"
    local content="$3"
    local timestamp="$4"

    # Create temporary file to avoid encoding issues
    local temp_file=$(mktemp)

    # Write the new entry to temp file
    cat >> "$temp_file" <<EOF

# [$timestamp]

**키워드**: $keyword

**내용**: $content

---
EOF

    # Append temp file to archive (using cat to preserve UTF-8)
    if cat "$temp_file" >> "$archive_path"; then
        rm -f "$temp_file"
        success_msg "노트가 추가되었습니다."
        info_msg "위치: $archive_path"
        return 0
    else
        rm -f "$temp_file"
        error_exit "노트 추가 실패: $archive_path" $ERROR_APPEND_FAILED
    fi
}

# ============================================================================
# Command: search
# ============================================================================
cmd_search() {
    local keyword=""

    # Parse flags
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --keyword)
                keyword="$2"
                shift 2
                ;;
            *)
                error_exit "알 수 없는 옵션: $1" $ERROR_MISSING_ARGS
                ;;
        esac
    done

    # Validate required arguments
    if [[ -z "$keyword" ]]; then
        error_exit "--keyword는 필수 인자입니다." $ERROR_MISSING_ARGS
    fi

    # Load configuration
    load_katarc

    # Resolve paths
    local study_path=$(get_study_path "$CURRENT_KATA")
    local archive_path=$(get_archive_path "$study_path")

    # Check if archive exists
    if [[ ! -f "$archive_path" ]]; then
        error_exit "아카이브 파일이 없습니다: $archive_path" $ERROR_NO_KATARC
    fi

    info_msg "키워드 '$keyword' 검색 중..."
    echo ""

    # Find all entries containing the keyword
    local in_entry=0
    local found=0
    local current_entry=""
    local current_timestamp=""
    local current_keywords=""
    local show_entry=0

    while IFS= read -r line; do
        # Check if this is a timestamp line (start of new entry)
        if [[ "$line" =~ ^#[[:space:]]\[.*\]$ ]]; then
            # If we were collecting an entry and it matches, display it
            if [[ $show_entry -eq 1 ]]; then
                echo -e "${GREEN}$current_timestamp${NC}"
                echo "$current_keywords"
                echo "$current_entry"
                echo "---"
                echo ""
                ((found++))
            fi

            # Start new entry
            current_timestamp="$line"
            current_keywords=""
            current_entry=""
            show_entry=0

        # Check if this is the keywords line
        elif [[ "$line" =~ ^\*\*키워드\*\*: ]]; then
            current_keywords="$line"
            # Check if keyword matches (case-insensitive)
            if echo "$line" | grep -i "$keyword" >/dev/null 2>&1; then
                show_entry=1
            fi

        # Collect content lines
        elif [[ -n "$line" && "$line" != "---" && "$line" != "# 학습 아카이브" ]]; then
            if [[ -n "$current_entry" ]]; then
                current_entry="$current_entry"$'\n'"$line"
            else
                current_entry="$line"
            fi
        fi
    done < "$archive_path"

    # Check last entry
    if [[ $show_entry -eq 1 ]]; then
        echo -e "${GREEN}$current_timestamp${NC}"
        echo "$current_keywords"
        echo "$current_entry"
        echo "---"
        echo ""
        ((found++))
    fi

    if [[ $found -eq 0 ]]; then
        info_msg "키워드 '$keyword'를 포함하는 노트가 없습니다."
    else
        success_msg "총 ${found}개의 노트를 찾았습니다."
    fi
}

# ============================================================================
# Command: stats
# ============================================================================
cmd_stats() {
    # Load configuration
    load_katarc

    # Resolve paths
    local study_path=$(get_study_path "$CURRENT_KATA")
    local archive_path=$(get_archive_path "$study_path")

    # Check if archive exists
    if [[ ! -f "$archive_path" ]]; then
        error_exit "아카이브 파일이 없습니다: $archive_path" $ERROR_NO_KATARC
    fi

    info_msg "키워드 통계 분석 중..."
    echo ""

    # Create temporary file for keyword counting
    local temp_keywords=$(mktemp)

    # Extract all keywords
    while IFS= read -r line; do
        if [[ "$line" =~ ^\*\*키워드\*\*:[[:space:]](.+)$ ]]; then
            # Extract keywords part
            local keywords="${BASH_REMATCH[1]}"

            # Split by comma and write each keyword to temp file
            echo "$keywords" | tr ',' '\n' | while read -r kw; do
                # Trim whitespace
                kw=$(echo "$kw" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
                if [[ -n "$kw" ]]; then
                    echo "$kw"
                fi
            done >> "$temp_keywords"
        fi
    done < "$archive_path"

    # Count and display results
    if [[ ! -s "$temp_keywords" ]]; then
        info_msg "키워드가 없습니다."
        rm -f "$temp_keywords"
    else
        echo -e "${GREEN}키워드 사용 빈도:${NC}"
        echo ""

        # Sort, count, and display
        sort "$temp_keywords" | uniq -c | sort -rn | while read -r count kw; do
            printf "  %3d회 | %s\n" "$count" "$kw"
        done

        echo ""
        local total_unique=$(sort "$temp_keywords" | uniq | wc -l | tr -d ' ')
        success_msg "총 ${total_unique}개의 고유 키워드"

        rm -f "$temp_keywords"
    fi
}

# ============================================================================
# Command: add
# ============================================================================
cmd_add() {
    local keyword=""
    local content=""

    # Parse flags
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --keyword)
                keyword="$2"
                shift 2
                ;;
            --content)
                content="$2"
                shift 2
                ;;
            *)
                error_exit "알 수 없는 옵션: $1" $ERROR_MISSING_ARGS
                ;;
        esac
    done

    # Validate required arguments
    if [[ -z "$keyword" ]] || [[ -z "$content" ]]; then
        error_exit "--keyword와 --content는 필수 인자입니다." $ERROR_MISSING_ARGS
    fi

    # Load configuration
    load_katarc

    # Resolve paths
    local study_path=$(get_study_path "$CURRENT_KATA")
    local archive_path=$(get_archive_path "$study_path")

    # Ensure directory and file exist
    ensure_study_directory "$study_path"
    initialize_archive "$archive_path"

    # Get timestamp
    local timestamp=$(get_timestamp)

    # Append note
    append_note "$archive_path" "$keyword" "$content" "$timestamp"
}

# ============================================================================
# Usage/Help
# ============================================================================
usage() {
    cat <<EOF
사용법: $0 <command> [options]

명령어:
  add              학습 노트를 아카이브에 추가
  search           특정 키워드를 포함하는 노트 검색
  stats            키워드별 사용 빈도 통계

옵션 (add 명령어):
  --keyword <text>   키워드 (쉼표로 구분된 여러 키워드 가능)
  --content <text>   학습 내용

옵션 (search 명령어):
  --keyword <text>   검색할 키워드

예시:
  # 노트 추가
  $0 add --keyword "fork, exec" --content "fork()는 프로세스를 복제하고, exec()는 새 프로그램으로 교체한다."
  $0 add --keyword "메모리 누수" --content "Valgrind로 메모리 누수를 확인했다. free() 누락 발견."

  # 키워드 검색
  $0 search --keyword "fork"
  $0 search --keyword "메모리"

  # 키워드 통계
  $0 stats

환경:
  .katarc 파일에서 CURRENT_KATA를 읽어 대상 프로젝트를 결정합니다.
  아카이브 위치: \${CURRENT_KATA}/docs/study/아카이브.md

EOF
}

# ============================================================================
# Main Dispatcher
# ============================================================================
COMMAND="${1:-}"

if [[ -z "$COMMAND" ]]; then
    usage
    exit 0
fi

shift  # Remove command from arguments

case "$COMMAND" in
    add)
        cmd_add "$@"
        ;;
    search)
        cmd_search "$@"
        ;;
    stats)
        cmd_stats "$@"
        ;;
    help|--help|-h)
        usage
        ;;
    *)
        error_exit "알 수 없는 명령어: $COMMAND\n사용법을 보려면 '$0 help'를 실행하세요." $ERROR_MISSING_ARGS
        ;;
esac
