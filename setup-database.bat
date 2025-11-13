@echo off
REM ============================================
REM PTIT Learning - Database Setup (Batch)
REM ============================================

echo ========================================
echo   PTIT Learning - Database Setup
echo ========================================
echo.

set MYSQL_PATH="C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
set SCHEMA_FILE="C:\Users\AD\Downloads\demo\database_schema.sql"
set SAMPLE_FILE="C:\Users\AD\Downloads\demo\sample_data.sql"

echo Step 1: Testing MySQL connection...
echo.
echo Please enter your MySQL root password when prompted:
echo.

%MYSQL_PATH% -u root -p -e "SELECT VERSION() as MySQL_Version;"

if errorlevel 1 (
    echo.
    echo ERROR: Cannot connect to MySQL!
    echo Please check your password and try again.
    pause
    exit /b 1
)

echo.
echo Step 2: Importing database schema...
echo.

%MYSQL_PATH% -u root -p < %SCHEMA_FILE%

if errorlevel 1 (
    echo.
    echo ERROR: Failed to import schema!
    pause
    exit /b 1
)

echo Schema imported successfully!
echo.

if exist %SAMPLE_FILE% (
    echo Step 3: Importing sample data...
    echo.
    %MYSQL_PATH% -u root -p < %SAMPLE_FILE%
    echo Sample data imported!
    echo.
)

echo ========================================
echo   Setup Complete!
echo ========================================
echo.
echo Test Account:
echo   Email: test@ptit.edu.vn
echo   Password: 123456
echo.
echo Access your application at:
echo   http://localhost:8080/
echo.
echo ========================================
echo.

pause
