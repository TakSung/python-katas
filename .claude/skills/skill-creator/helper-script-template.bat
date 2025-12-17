@echo off
REM ============================================================================
REM [SKILL_NAME] Helper Script - Windows Version
REM ============================================================================
REM Description: [Brief description of what this script does]
REM Usage: scripts\[skill-name]-helper.bat {command1|command2|help}
REM ============================================================================

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

REM ============================================================================
REM Load configuration
REM ============================================================================

set KATARC_FILE=.katarc
if not exist "%KATARC_FILE%" (
    echo %RED%❌ .katarc not found%NC%
    exit /b 1
)

REM Parse .katarc file
for /f "tokens=1,2 delims==" %%a in (%KATARC_FILE%) do (
    if "%%a"=="CURRENT_KATA" set CURRENT_KATA=%%b
    if "%%a"=="ENV_TYPE" set ENV_TYPE=%%b
    if "%%a"=="CONDA_ENV_NAME" set CONDA_ENV_NAME=%%b
)

REM Validate required variables
if "%CURRENT_KATA%"=="" (
    echo %RED%❌ CURRENT_KATA not set in .katarc%NC%
    exit /b 1
)

REM ============================================================================
REM Main command dispatcher
REM ============================================================================

set COMMAND=%1
if "%COMMAND%"=="" set COMMAND=help
shift

if "%COMMAND%"=="command1" goto cmd_command1
if "%COMMAND%"=="command2" goto cmd_command2
if "%COMMAND%"=="help" goto cmd_help
goto cmd_help

REM ============================================================================
REM Command implementations
REM ============================================================================

:cmd_command1
echo %BLUE%=== Executing command1%NC%

REM TODO: Implement command1 logic here
REM Example:
REM set ARG1=%1
REM if "%ARG1%"=="" set ARG1=default_value
REM echo Processing: %ARG1%

echo %GREEN%✅ Command1 completed%NC%
exit /b 0

:cmd_command2
echo %BLUE%=== Executing command2%NC%

REM TODO: Implement command2 logic here
REM Example:
REM set ARG1=%1
REM if "%ARG1%"=="" (
REM     echo %RED%❌ Argument required for command2%NC%
REM     exit /b 1
REM )
REM echo Processing: %ARG1%

echo %GREEN%✅ Command2 completed%NC%
exit /b 0

:cmd_help
echo Usage: %~nx0 ^<command^> [options]
echo.
echo Commands:
echo   command1    - Description of command1
echo   command2    - Description of command2
echo   help        - Show this help message
echo.
echo Examples:
echo   %~nx0 command1
echo   %~nx0 command2 arg1 arg2
exit /b 0
