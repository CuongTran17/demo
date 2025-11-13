@echo off
REM ============================================
REM PTIT Learning - Stop Script
REM ============================================

echo ========================================
echo   PTIT LEARNING - Stop Server
echo ========================================
echo.

echo Stopping Tomcat...
C:\tomcat10\bin\shutdown.bat

echo.
echo Killing any remaining Java processes...
taskkill /F /IM java.exe >nul 2>&1

echo.
echo ========================================
echo   Server stopped!
echo ========================================
echo.
pause
