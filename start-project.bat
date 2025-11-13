@echo off
REM ============================================
REM PTIT Learning - Quick Start Script
REM ============================================

echo ========================================
echo   PTIT LEARNING - Quick Start
echo ========================================
echo.

REM Set environment variables
set MAVEN_HOME=C:\tools\apache-maven-3.9.9
set PATH=%MAVEN_HOME%\bin;%PATH%

echo [1/4] Stopping any running Tomcat...
taskkill /F /IM java.exe >nul 2>&1
timeout /t 3 /nobreak >nul

echo [2/4] Building project with Maven...
cd /d C:\Users\AD\Downloads\demo
call mvn clean package -DskipTests

if errorlevel 1 (
    echo.
    echo ERROR: Build failed!
    pause
    exit /b 1
)

echo.
echo [3/4] Deploying to Tomcat...
del /Q C:\tomcat10\webapps\ROOT.war 2>nul
rmdir /S /Q C:\tomcat10\webapps\ROOT 2>nul
copy target\ROOT.war C:\tomcat10\webapps\ROOT.war

echo.
echo [4/4] Starting Tomcat 10...
start "Tomcat 10" C:\tomcat10\bin\catalina.bat run

echo.
echo ========================================
echo   Starting complete!
echo ========================================
echo.
echo Waiting for Tomcat to start (15 seconds)...
timeout /t 15 /nobreak >nul

echo.
echo Opening application in browser...
start http://localhost:8080/

echo.
echo ========================================
echo   Application is running!
echo ========================================
echo.
echo Access at: http://localhost:8080/
echo Login: test@ptit.edu.vn / 123456
echo.
echo Press any key to exit (Tomcat will keep running)
pause >nul
