#!/bin/bash

# Common settings
export LC_ALL=C.UTF-8
GIT_OPTS="-c core.quotepath=false"

# --- Filtering options ---
PATHSPEC_ARRAY=()
GREP_OPTS_ARRAY=()

# Use a while loop to parse all flags
while [[ "$1" == --* ]]; do
    case "$1" in
        --code-only)
            PATHSPEC_ARRAY=(-- . ':(exclude)docs/*' ':(exclude).claude/*' ':(exclude).helix/*' ':(exclude).cmake/*' ':(exclude)*.md' ':(exclude)*.toml' ':(exclude).clang-format' ':(exclude).gitignore' ':(exclude).katarc')
            shift
            ;;
        --no-meta-commits)
            GREP_OPTS_ARRAY=(
                --invert-grep --grep="^prompt"
                --invert-grep --grep="^📌"
                --invert-grep --grep="^docs"
                --invert-grep --grep="^📝"
                --invert-grep --grep="^config"
                --invert-grep --grep="^🔧"
                --invert-grep --grep="^chore"
                --invert-grep --grep="^style"
                --invert-grep --grep="^refactor"
                --invert-grep --grep="^test"
                --invert-grep --grep="^build"
                --invert-grep --grep="^ci"
            )
            shift
            ;;
        *)
            # Unknown option
            break
            ;;
    esac
done


# Help function
usage() {
    echo "Usage: $0 [--code-only] [--no-meta-commits] {status|last|log [n]|diff <start> <end>}"
    echo
    echo "Options:"
    echo "  --code-only         Exclude documentation, config, and script files from the output."
    echo "  --no-meta-commits   Filter out commits related to docs, prompts, and repo maintenance."
    echo
    echo "Commands:"
    echo "  status         Show uncommitted (staged + unstaged) changes."
    echo "  last           Show the last commit details."
    echo "  log [n]        Show the last 'n' commits (default: 10)."
    echo "  diff <start> <end> Show changes between two commit hashes."
}

# Subcommand dispatcher
COMMAND="$1"
shift

case "$COMMAND" in
    status)
        echo "📝 Unstaged changes:"
        git $GIT_OPTS diff --stat # Status is not filtered
        echo ""
        echo "✅ Staged changes:"
        git $GIT_OPTS diff --cached --stat # Status is not filtered
        ;;

    last)
        echo "🔖 Latest commit:"
        git $GIT_OPTS log -1 --stat --pretty=format:"%h - %s (%ar)%n" "${GREP_OPTS_ARRAY[@]}" "${PATHSPEC_ARRAY[@]}"
        ;;

    log)
        COUNT=${1:-10}
        echo "📋 Recent ${COUNT} commits:"
        git $GIT_OPTS log -${COUNT} --oneline --decorate --color=never "${GREP_OPTS_ARRAY[@]}" "${PATHSPEC_ARRAY[@]}"
        ;;

    diff)
        if [ -z "$1" ] || [ -z "$2" ]; then
            echo "Error: Both start and end commit hashes are required for diff."
            usage
            exit 1
        fi
        START_HASH="$1"
        END_HASH="$2"
        echo "📊 Commit range: ${START_HASH}..${END_HASH}"
        echo ""
        git $GIT_OPTS log ${START_HASH}..${END_HASH} --oneline --decorate --color=never "${GREP_OPTS_ARRAY[@]}" "${PATHSPEC_ARRAY[@]}"
        echo ""
        echo "📝 Detailed changes per commit:"
        # Use rev-list with the same filters to get the list of commits to iterate over
        for commit in $(git rev-list ${START_HASH}..${END_HASH} "${GREP_OPTS_ARRAY[@]}"); do
          # Check if the commit has any changes in the specified pathspec
          if [ ${#PATHSPEC_ARRAY[@]} -ne 0 ]; then
              if git diff-tree --quiet $commit "${PATHSPEC_ARRAY[@]}"; then
                # No changes in the pathspec, skip this commit
                continue
              fi
          fi
          echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          git $GIT_OPTS show $commit --stat --pretty=format:"🔖 %h - %s%n👤 %an (%ar)%n" "${PATHSPEC_ARRAY[@]}"
          echo ""
        done
        ;;

    *)
        usage
        exit 1
        ;;
esac
