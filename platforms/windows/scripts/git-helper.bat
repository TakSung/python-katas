@echo off
REM ============================================================================
REM git-helper.bat - Windows version of git-helper.sh
REM ============================================================================
setlocal enabledelayedexpansion

REM UTF-8 encoding
chcp 65001 > nul

REM Git options
set GIT_OPTS=-c core.quotepath=false

REM Filtering options
set "PATHSPEC="
set "GREP_OPTS="

REM Parse flags
:parse_flags
if "%1"=="" goto dispatch
if "%1"=="--code-only" (
    set PATHSPEC=-- . ":(exclude)docs/*" ":(exclude).claude/*" ":(exclude).helix/*" ":(exclude)*.md" ":(exclude)*.toml" ":(exclude).gitignore" ":(exclude).katarc"
    shift
    goto parse_flags
)
if "%1"=="--no-meta-commits" (
    set GREP_OPTS=--invert-grep --grep="^prompt" --invert-grep --grep="^📌" --invert-grep --grep="^docs" --invert-grep --grep="^📝" --invert-grep --grep="^config" --invert-grep --grep="^🔧" --invert-grep --grep="^chore" --invert-grep --grep="^style" --invert-grep --grep="^refactor" --invert-grep --grep="^test" --invert-grep --grep="^build" --invert-grep --grep="^ci"
    shift
    goto parse_flags
)
goto dispatch

REM Command dispatcher
:dispatch
set COMMAND=%1
shift

if "%COMMAND%"=="" goto usage
if "%COMMAND%"=="status" goto cmd_status
if "%COMMAND%"=="last" goto cmd_last
if "%COMMAND%"=="log" goto cmd_log
if "%COMMAND%"=="diff" goto cmd_diff
goto usage

:cmd_status
echo 📝 Unstaged changes:
git %GIT_OPTS% diff --stat
echo.
echo ✅ Staged changes:
git %GIT_OPTS% diff --cached --stat
exit /b 0

:cmd_last
echo 🔖 Latest commit:
git %GIT_OPTS% log -1 --stat --pretty=format:"%%h - %%s (%%ar)%%n" %GREP_OPTS% %PATHSPEC%
exit /b 0

:cmd_log
set COUNT=%1
if "%COUNT%"=="" set COUNT=10
echo 📋 Recent %COUNT% commits:
git %GIT_OPTS% log -%COUNT% --oneline --decorate --color=never %GREP_OPTS% %PATHSPEC%
exit /b 0

:cmd_diff
if "%1"=="" goto diff_error
if "%2"=="" goto diff_error
set START_HASH=%1
set END_HASH=%2
echo 📊 Commit range: %START_HASH%..%END_HASH%
echo.
git %GIT_OPTS% log %START_HASH%..%END_HASH% --oneline --decorate --color=never %GREP_OPTS% %PATHSPEC%
echo.
echo 📝 Detailed changes per commit:
for /f "tokens=*" %%c in ('git rev-list %START_HASH%..%END_HASH% %GREP_OPTS%') do (
    echo ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    git %GIT_OPTS% show %%c --stat --pretty=format:"🔖 %%h - %%s%%n👤 %%an (%%ar)%%n" %PATHSPEC%
    echo.
)
exit /b 0

:diff_error
echo Error: Both start and end commit hashes are required for diff.
goto usage

:usage
echo Usage: %~nx0 [--code-only] [--no-meta-commits] {status^|last^|log [n]^|diff ^<start^> ^<end^>}
echo.
echo Options:
echo   --code-only         Exclude documentation, config, and script files
echo   --no-meta-commits   Filter out commits related to docs, prompts, and maintenance
echo.
echo Commands:
echo   status              Show uncommitted (staged + unstaged) changes
echo   last                Show the last commit details
echo   log [n]             Show the last 'n' commits (default: 10)
echo   diff ^<start^> ^<end^>  Show changes between two commit hashes
exit /b 1
