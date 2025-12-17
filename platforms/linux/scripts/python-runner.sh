#!/bin/bash

# Python-Katas Runner Script
# This script acts as a wrapper to run build, test, and analysis commands
# for Python projects using uv and pytest.
#
# Usage: ./scripts/python-runner.sh {test|run|syntax-check|import-check|clean|help} [options]

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

# Colors for output
BLUE='\033[0;34m'
NC='\033[0m' # No Color
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'

# Load .katarc to get the current kata
load_kata_config() {
    if [ -f ".katarc" ]; then
        source .katarc
    else
        echo -e "${RED}❌ .katarc not found. Cannot determine current kata.${NC}"
        exit 1
    fi
}

# Function to activate virtual environment and run command
run_in_venv() {
    local cmd_to_run=$1
    echo -e "${BLUE}==> Executing in venv for kata '${CURRENT_KATA}':${NC} ${YELLOW}${cmd_to_run}${NC}"

    # Check environment type and activate accordingly
    if [ "${ENV_TYPE}" = "conda" ]; then
        # Conda environment
        if [ -z "${CONDA_ENV_NAME}" ]; then
            echo -e "${RED}❌ CONDA_ENV_NAME not set in .katarc${NC}"
            exit 1
        fi

        # Check if conda is available
        if ! command -v conda &> /dev/null; then
            echo -e "${RED}❌ conda not found. Please install Conda/Miniconda.${NC}"
            exit 1
        fi

        # Activate conda environment and run command
        eval "$(conda shell.bash hook)"
        conda activate "${CONDA_ENV_NAME}" && eval "${cmd_to_run}"
    else
        # Default: venv/uv environment
        if [ ! -d ".venv" ]; then
            echo -e "${RED}❌ .venv not found. Please create virtual environment first.${NC}"
            echo -e "${YELLOW}Hint: Run 'uv venv' to create virtual environment${NC}"
            exit 1
        fi

        # Activate venv and run command
        source .venv/bin/activate && eval "${cmd_to_run}"
    fi
}

# Main script logic
main() {
    load_kata_config

    local command="${1:-help}"
    shift || true

    case "$command" in
        test)
            local test_target="${1:-}"
            if [ -z "$test_target" ]; then
                run_in_venv "pytest"
            else
                run_in_venv "pytest ${test_target}"
            fi
            ;;
        run)
            local module="${1:-main}"
            run_in_venv "cd ${CURRENT_KATA} && python -m ${module}"
            ;;
        syntax-check)
            local file_path="${1}"
            if [ -z "$file_path" ]; then
                echo -e "${RED}❌ File path for syntax-check is required.${NC}"
                exit 1
            fi
            run_in_venv "python -m py_compile ${file_path}"
            ;;
        import-check)
            echo -e "${BLUE}==> Checking imports in ${CURRENT_KATA}/${NC}"
            echo ""
            echo -e "${YELLOW}1. Searching for relative imports (should be none):${NC}"
            grep -r "^from \." ${CURRENT_KATA}/ --include="*.py" -n || echo -e "${GREEN}✅ No relative imports found${NC}"
            echo ""
            echo -e "${YELLOW}2. Searching for imports without package name (should be none):${NC}"
            grep -r "^from \(domain\|app\|infra\|ui\|tests\)\." ${CURRENT_KATA}/ --include="*.py" -n || echo -e "${GREEN}✅ No imports without package name found${NC}"
            echo ""
            echo -e "${YELLOW}3. Testing pytest collection (validates all imports):${NC}"
            run_in_venv "pytest --collect-only"
            ;;
        clean)
            echo -e "${BLUE}==> Cleaning build artifacts${NC}"
            find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
            find . -type f -name "*.pyc" -delete 2>/dev/null || true
            find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
            find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
            echo -e "${GREEN}✅ Cleaned successfully${NC}"
            ;;
        help|*)
            echo "Python-Katas Runner Script"
            echo ""
            echo "Usage: $0 <command> [options]"
            echo ""
            echo "Commands:"
            echo "  test [test_path]            - Run all tests or a specific test."
            echo "  run [module]                - Run a Python module. (Default: \${CURRENT_KATA}.main)"
            echo "  syntax-check <file_path>    - Check syntax of a Python file."
            echo "  import-check                - Verify import strategy (absolute imports)."
            echo "  clean                       - Clean build artifacts (__pycache__, .pyc, etc)."
            echo "  help                        - Show this help message."
            echo ""
            echo "All commands are executed inside .venv for the kata defined in .katarc."
            ;;
    esac
}

main "$@"
