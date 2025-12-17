#!/bin/bash

# ============================================================================
# [SKILL_NAME] Helper Script - Linux Version
# ============================================================================
# Description: [Brief description of what this script does]
# Usage: ./scripts/[skill-name]-helper.sh {command1|command2|help}
# ============================================================================

set -euo pipefail

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

# ============================================================================
# 헬퍼 함수
# ============================================================================

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
    echo "  command1    - Description of command1"
    echo "  command2    - Description of command2"
    echo "  help        - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 command1"
    echo "  $0 command2 arg1 arg2"
}

# ============================================================================
# 커맨드 구현
# ============================================================================

cmd_command1() {
    echo -e "${BLUE}=== Executing command1${NC}"

    # TODO: Implement command1 logic here
    # Example:
    # local arg1="${1:-default_value}"
    # echo "Processing: $arg1"

    success_msg "Command1 completed"
}

cmd_command2() {
    echo -e "${BLUE}=== Executing command2${NC}"

    # TODO: Implement command2 logic here
    # Example:
    # if [ -z "${1:-}" ]; then
    #     error_exit "Argument required for command2"
    # fi
    # local arg1="$1"
    # echo "Processing: $arg1"

    success_msg "Command2 completed"
}

# ============================================================================
# 메인 로직
# ============================================================================

main() {
    load_config

    local command="${1:-help}"
    shift || true

    case "$command" in
        command1)
            cmd_command1 "$@"
            ;;
        command2)
            cmd_command2 "$@"
            ;;
        help|*)
            usage
            ;;
    esac
}

main "$@"
