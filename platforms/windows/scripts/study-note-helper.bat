@echo off
REM ============================================================================
REM study-note-helper.bat - Windows version of study-note-helper.sh
REM ============================================================================
setlocal enabledelayedexpansion

REM UTF-8 encoding
chcp 65001 > nul

REM Change to project root
cd /d "%~dp0\..\.."

REM Configuration
set KATARC_FILE=.katarc

REM Error codes
set ERROR_NO_KATARC=1
set ERROR_NO_CURRENT_KATA=2
set ERROR_MISSING_ARGS=3
set ERROR_STUDY_DIR_CREATE_FAILED=4
set ERROR_APPEND_FAILED=5

REM Colors
set "RED=[31m"
set "GREEN=[32m"
set "YELLOW=[33m"
set "NC=[0m"

REM Load CURRENT_KATA from .katarc
if not exist "%KATARC_FILE%" (
    echo %RED%❌ 오류:%NC% .katarc 파일을 찾을 수 없습니다: %KATARC_FILE%
    exit /b %ERROR_NO_KATARC%
)

for /f "tokens=1,2 delims==" %%a in (%KATARC_FILE%) do (
    if "%%a"=="CURRENT_KATA" set CURRENT_KATA=%%b
)

if "%CURRENT_KATA%"=="" (
    echo %RED%❌ 오류:%NC% .katarc에 CURRENT_KATA 변수가 설정되지 않았습니다.
    exit /b %ERROR_NO_CURRENT_KATA%
)

echo %YELLOW%ℹ%NC%  현재 KATA: %CURRENT_KATA%

REM Paths
set STUDY_PATH=%CURRENT_KATA%\docs\study
set ARCHIVE_PATH=%STUDY_PATH%\아카이브.md

REM Command dispatcher
set COMMAND=%1
shift

if "%COMMAND%"=="" goto usage
if "%COMMAND%"=="add" goto cmd_add
if "%COMMAND%"=="search" goto cmd_search
if "%COMMAND%"=="stats" goto cmd_stats
if "%COMMAND%"=="help" goto usage
if "%COMMAND%"=="--help" goto usage
if "%COMMAND%"=="-h" goto usage
goto unknown_command

:cmd_add
set KEYWORD=
set CONTENT=

:parse_add_args
if "%1"=="" goto validate_add
if "%1"=="--keyword" (
    set KEYWORD=%~2
    shift
    shift
    goto parse_add_args
)
if "%1"=="--content" (
    set CONTENT=%~2
    shift
    shift
    goto parse_add_args
)
echo %RED%❌ 오류:%NC% 알 수 없는 옵션: %1
exit /b %ERROR_MISSING_ARGS%

:validate_add
if "%KEYWORD%"=="" (
    echo %RED%❌ 오류:%NC% --keyword는 필수 인자입니다.
    exit /b %ERROR_MISSING_ARGS%
)
if "%CONTENT%"=="" (
    echo %RED%❌ 오류:%NC% --content는 필수 인자입니다.
    exit /b %ERROR_MISSING_ARGS%
)

REM Ensure study directory exists
if not exist "%STUDY_PATH%" (
    echo %YELLOW%ℹ%NC%  학습 디렉토리가 없습니다. 생성합니다: %STUDY_PATH%
    mkdir "%STUDY_PATH%" 2>nul
    if errorlevel 1 (
        echo %RED%❌ 오류:%NC% 디렉토리 생성 실패: %STUDY_PATH%
        exit /b %ERROR_STUDY_DIR_CREATE_FAILED%
    )
)

REM Initialize archive if it doesn't exist
if not exist "%ARCHIVE_PATH%" (
    echo %YELLOW%ℹ%NC%  아카이브 파일이 없습니다. 새로 생성합니다: %ARCHIVE_PATH%
    (
        echo # 학습 아카이브
        echo.
        echo 이 파일은 학습 중 떠오른 아이디어, 메모, 질문을 시간순으로 기록합니다.
        echo.
        echo ---
        echo.
    ) > "%ARCHIVE_PATH%"
    if errorlevel 1 (
        echo %RED%❌ 오류:%NC% 아카이브 파일 초기화 실패: %ARCHIVE_PATH%
        exit /b %ERROR_APPEND_FAILED%
    )
    echo %GREEN%✅%NC% 아카이브 파일 생성됨: %ARCHIVE_PATH%
)

REM Get timestamp (KST - note: Windows date/time handling is limited)
for /f "tokens=1-3 delims=/ " %%a in ('date /t') do set TODAY=%%a-%%b-%%c
for /f "tokens=1-2 delims=: " %%a in ('time /t') do set NOW=%%a:%%b:00
set TIMESTAMP=%TODAY% %NOW% KST

REM Append note
(
    echo.
    echo # [%TIMESTAMP%]
    echo.
    echo **키워드**: %KEYWORD%
    echo.
    echo **내용**: %CONTENT%
    echo.
    echo ---
) >> "%ARCHIVE_PATH%"

if errorlevel 1 (
    echo %RED%❌ 오류:%NC% 노트 추가 실패: %ARCHIVE_PATH%
    exit /b %ERROR_APPEND_FAILED%
)

echo %GREEN%✅%NC% 노트가 추가되었습니다.
echo %YELLOW%ℹ%NC%  위치: %ARCHIVE_PATH%
exit /b 0

:cmd_search
set KEYWORD=

:parse_search_args
if "%1"=="" goto validate_search
if "%1"=="--keyword" (
    set KEYWORD=%~2
    shift
    shift
    goto parse_search_args
)
echo %RED%❌ 오류:%NC% 알 수 없는 옵션: %1
exit /b %ERROR_MISSING_ARGS%

:validate_search
if "%KEYWORD%"=="" (
    echo %RED%❌ 오류:%NC% --keyword는 필수 인자입니다.
    exit /b %ERROR_MISSING_ARGS%
)

if not exist "%ARCHIVE_PATH%" (
    echo %RED%❌ 오류:%NC% 아카이브 파일이 없습니다: %ARCHIVE_PATH%
    exit /b %ERROR_NO_KATARC%
)

echo %YELLOW%ℹ%NC%  키워드 '%KEYWORD%' 검색 중...
echo.

REM Search for keyword (simple findstr)
findstr /i /c:"%KEYWORD%" "%ARCHIVE_PATH%" >nul
if errorlevel 1 (
    echo %YELLOW%ℹ%NC%  키워드 '%KEYWORD%'를 포함하는 노트가 없습니다.
) else (
    REM Display context around matches
    echo %GREEN%검색 결과:%NC%
    findstr /i /n /c:"%KEYWORD%" "%ARCHIVE_PATH%"
    echo.
    echo %GREEN%✅%NC% 키워드를 포함하는 노트를 찾았습니다.
)
exit /b 0

:cmd_stats
if not exist "%ARCHIVE_PATH%" (
    echo %RED%❌ 오류:%NC% 아카이브 파일이 없습니다: %ARCHIVE_PATH%
    exit /b %ERROR_NO_KATARC%
)

echo %YELLOW%ℹ%NC%  키워드 통계 분석 중...
echo.
echo %GREEN%키워드 목록:%NC%
findstr /i /c:"**키워드**" "%ARCHIVE_PATH%"
echo.
echo %YELLOW%ℹ%NC%  Windows에서는 자동 통계가 제한적입니다. 전체 키워드 목록을 출력합니다.
exit /b 0

:usage
echo 사용법: %~nx0 ^<command^> [options]
echo.
echo 명령어:
echo   add              학습 노트를 아카이브에 추가
echo   search           특정 키워드를 포함하는 노트 검색
echo   stats            키워드별 사용 빈도 통계
echo.
echo 옵션 (add 명령어^):
echo   --keyword ^<text^>   키워드 (쉼표로 구분된 여러 키워드 가능^)
echo   --content ^<text^>   학습 내용
echo.
echo 옵션 (search 명령어^):
echo   --keyword ^<text^>   검색할 키워드
echo.
echo 예시:
echo   # 노트 추가
echo   %~nx0 add --keyword "fork, exec" --content "fork()는 프로세스를 복제하고, exec()는 새 프로그램으로 교체한다."
echo.
echo   # 키워드 검색
echo   %~nx0 search --keyword "fork"
echo.
echo   # 키워드 통계
echo   %~nx0 stats
echo.
echo 환경:
echo   .katarc 파일에서 CURRENT_KATA를 읽어 대상 프로젝트를 결정합니다.
echo   아카이브 위치: %%CURRENT_KATA%%\docs\study\아카이브.md
echo.
exit /b 0

:unknown_command
echo %RED%❌ 오류:%NC% 알 수 없는 명령어: %COMMAND%
echo 사용법을 보려면 '%~nx0 help'를 실행하세요.
exit /b %ERROR_MISSING_ARGS%
