@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul
title Newer File Sync

set "BASE1=C:\ts-maedashi\public-release"
set "BASE2=C:\maedashi-public"

echo ==================================================
echo 新しいファイルを優先して双方向同期します
echo.
echo 1: %BASE1%
echo 2: %BASE2%
echo ==================================================
echo.

call :SyncPair "%BASE1%\docs"   "%BASE2%\docs"
call :SyncPair "%BASE1%\public" "%BASE2%\public"

echo.
echo ==================================================
echo 同期処理が完了しました
echo ==================================================
pause
exit /b 0


:SyncPair
set "DIR1=%~1"
set "DIR2=%~2"

echo.
echo --------------------------------------------------
echo 同期対象:
echo   %DIR1%
echo   %DIR2%
echo --------------------------------------------------
echo.

if not exist "%DIR1%" (
    echo [ERROR] フォルダが存在しません: %DIR1%
    goto :eof
)

if not exist "%DIR2%" (
    echo [ERROR] フォルダが存在しません: %DIR2%
    goto :eof
)

echo [1/2] %DIR1% から %DIR2% へ、新しいファイルのみ同期
robocopy "%DIR1%" "%DIR2%" /E /XO /FFT /R:1 /W:1 /TEE /NP

set "RC=%ERRORLEVEL%"
if %RC% GEQ 8 (
    echo [ERROR] robocopy でエラーが発生しました。終了コード=%RC%
) else (
    echo [OK] %DIR1% → %DIR2% 完了
)

echo.
echo [2/2] %DIR2% から %DIR1% へ、新しいファイルのみ同期
robocopy "%DIR2%" "%DIR1%" /E /XO /FFT /R:1 /W:1 /TEE /NP

set "RC=%ERRORLEVEL%"
if %RC% GEQ 8 (
    echo [ERROR] robocopy でエラーが発生しました。終了コード=%RC%
) else (
    echo [OK] %DIR2% → %DIR1% 完了
)

goto :eof