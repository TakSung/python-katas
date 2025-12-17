@echo off
REM ============================================================================
REM python-runner.bat - Windows version of python-runner.sh
REM ============================================================================
setlocal enabledelayedexpansion

REM Change to project root
cd /d "%~dp0\..\.."

REM Colors (Windows doesn't support ANSI colors in basic cmd, but we can use echo)
set "BLUE=[34m"
set "NC=[0m"
set "RED=[31m"
set "YELLOW=[33m"
set "GREEN=[32m"

REM Load .katarc to get current kata
if not exist ".katarc" (
    echo %RED%❌ .katarc not found. Cannot determine current kata.%NC%
    exit /b 1
)

REM Parse configuration from .katarc
for /f "tokens=1,2 delims==" %%a in (.katarc) do (
    if "%%a"=="CURRENT_KATA" set CURRENT_KATA=%%b
    if "%%a"=="ENV_TYPE" set ENV_TYPE=%%b
    if "%%a"=="CONDA_ENV_NAME" set CONDA_ENV_NAME=%%b
)

if "%CURRENT_KATA%"=="" (
    echo %RED%❌ CURRENT_KATA not set in .katarc%NC%
    exit /b 1
)

REM Main command dispatcher
set COMMAND=%1
if "%COMMAND%"=="" set COMMAND=help
shift

if "%COMMAND%"=="test" goto cmd_test
if "%COMMAND%"=="run" goto cmd_run
if "%COMMAND%"=="syntax-check" goto cmd_syntax_check
if "%COMMAND%"=="import-check" goto cmd_import_check
if "%COMMAND%"=="clean" goto cmd_clean
if "%COMMAND%"=="help" goto cmd_help
goto cmd_help

:cmd_test
set TEST_TARGET=%1
if "%TEST_TARGET%"=="" (
    call :run_in_venv "pytest"
) else (
    call :run_in_venv "pytest %TEST_TARGET%"
)
exit /b %ERRORLEVEL%

:cmd_run
set MODULE=%1
if "%MODULE%"=="" set MODULE=main
call :run_in_venv "cd %CURRENT_KATA% && python -m %MODULE%"
exit /b %ERRORLEVEL%

:cmd_syntax_check
set FILE_PATH=%1
if "%FILE_PATH%"=="" (
    echo %RED%❌ File path for syntax-check is required.%NC%
    exit /b 1
)
call :run_in_venv "python -m py_compile %FILE_PATH%"
exit /b %ERRORLEVEL%

:cmd_import_check
echo %BLUE%=== Checking imports in %CURRENT_KATA%\%NC%
echo.
echo %YELLOW%1. Searching for relative imports (should be none):%NC%
findstr /r /n /s /c:"^from \." "%CURRENT_KATA%\*.py" 2>nul
if errorlevel 1 (
    echo %GREEN%✅ No relative imports found%NC%
) else (
    echo %RED%❌ Found relative imports%NC%
)
echo.
echo %YELLOW%2. Searching for imports without package name (should be none):%NC%
findstr /r /n /s /c:"^from domain\." /c:"^from app\." /c:"^from infra\." /c:"^from ui\." /c:"^from tests\." "%CURRENT_KATA%\*.py" 2>nul
if errorlevel 1 (
    echo %GREEN%✅ No imports without package name found%NC%
) else (
    echo %RED%❌ Found imports without package name%NC%
)
echo.
echo %YELLOW%3. Testing pytest collection (validates all imports):%NC%
call :run_in_venv "pytest --collect-only"
exit /b %ERRORLEVEL%

:cmd_clean
echo %BLUE%=== Cleaning build artifacts%NC%
for /d /r . %%d in (__pycache__) do @if exist "%%d" rd /s /q "%%d" 2>nul
for /r . %%f in (*.pyc) do @if exist "%%f" del /q "%%f" 2>nul
for /d /r . %%d in (.pytest_cache) do @if exist "%%d" rd /s /q "%%d" 2>nul
for /d /r . %%d in (*.egg-info) do @if exist "%%d" rd /s /q "%%d" 2>nul
echo %GREEN%✅ Cleaned successfully%NC%
exit /b 0

:cmd_help
echo Python-Katas Runner Script (Windows)
echo.
echo Usage: %~nx0 ^<command^> [options]
echo.
echo Commands:
echo   test [test_path]            - Run all tests or a specific test
echo   run [module]                - Run a Python module (Default: %CURRENT_KATA%.main)
echo   syntax-check ^<file_path^>    - Check syntax of a Python file
echo   import-check                - Verify import strategy (absolute imports)
echo   clean                       - Clean build artifacts (__pycache__, .pyc, etc)
echo   help                        - Show this help message
echo.
echo All commands are executed inside .venv for the kata defined in .katarc.
exit /b 0

REM Function to run command in venv
:run_in_venv
set CMD_TO_RUN=%~1
echo %BLUE%=== Executing in venv for kata '%CURRENT_KATA%':%NC% %YELLOW%%CMD_TO_RUN%%NC%

REM Check environment type and activate accordingly
if "%ENV_TYPE%"=="conda" (
    REM Conda environment
    if "%CONDA_ENV_NAME%"=="" (
        echo %RED%❌ CONDA_ENV_NAME not set in .katarc%NC%
        exit /b 1
    )

    REM Check if conda is available
    where conda >nul 2>&1
    if errorlevel 1 (
        echo %RED%❌ conda not found. Please install Conda/Miniconda.%NC%
        exit /b 1
    )

    REM Activate conda environment and run command
    call conda activate %CONDA_ENV_NAME% && %CMD_TO_RUN%
    exit /b !ERRORLEVEL!
) else (
    REM Default: venv/uv environment
    if not exist ".venv" (
        echo %RED%❌ .venv not found. Please create virtual environment first.%NC%
        echo %YELLOW%Hint: Run 'uv venv' to create virtual environment%NC%
        exit /b 1
    )

    REM Activate venv and run command
    call .venv\Scripts\activate.bat && %CMD_TO_RUN%
    exit /b !ERRORLEVEL!
)
