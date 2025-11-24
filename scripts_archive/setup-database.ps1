# ============================================
# PTIT Learning - Database Setup Script
# ============================================

param(
    [Parameter(Mandatory=$false)]
    [string]$MySQLPassword = ""
)

$mysqlPath = "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
$schemaFile = "C:\Users\AD\Downloads\demo\database_schema.sql"
$sampleDataFile = "C:\Users\AD\Downloads\demo\sample_data.sql"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  PTIT Learning - Database Setup" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if MySQL is installed
if (-not (Test-Path $mysqlPath)) {
    Write-Host "ERROR: MySQL not found at $mysqlPath" -ForegroundColor Red
    exit 1
}

# Check if schema file exists
if (-not (Test-Path $schemaFile)) {
    Write-Host "ERROR: Schema file not found at $schemaFile" -ForegroundColor Red
    exit 1
}

# Get MySQL password if not provided
if ([string]::IsNullOrEmpty($MySQLPassword)) {
    Write-Host "Enter MySQL root password: " -NoNewline -ForegroundColor Yellow
    $securePassword = Read-Host -AsSecureString
    $BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePassword)
    $MySQLPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
}

Write-Host ""
Write-Host "Step 1: Testing MySQL connection..." -ForegroundColor Yellow

# Test connection
$testCmd = "SELECT VERSION() as version;"
$testResult = & $mysqlPath -u root "-p$MySQLPassword" -e $testCmd 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Cannot connect to MySQL. Please check your password." -ForegroundColor Red
    Write-Host "Error details: $testResult" -ForegroundColor Red
    exit 1
}

Write-Host "✓ MySQL connection successful!" -ForegroundColor Green
Write-Host ""

# Drop existing database (optional)
Write-Host "Step 2: Checking existing database..." -ForegroundColor Yellow
$checkDB = "SELECT SCHEMA_NAME FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'ptit_learning';"
$dbExists = & $mysqlPath -u root "-p$MySQLPassword" -e $checkDB 2>&1

if ($dbExists -like "*ptit_learning*") {
    Write-Host "! Database 'ptit_learning' already exists" -ForegroundColor Yellow
    $response = Read-Host "Do you want to DROP and recreate it? (yes/no)"
    if ($response -eq "yes" -or $response -eq "y") {
        Write-Host "Dropping existing database..." -ForegroundColor Yellow
        $dropCmd = "DROP DATABASE ptit_learning;"
        & $mysqlPath -u root "-p$MySQLPassword" -e $dropCmd 2>&1 | Out-Null
        Write-Host "✓ Old database dropped" -ForegroundColor Green
    } else {
        Write-Host "Keeping existing database. Skipping import." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host "  Setup Complete!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Cyan
        exit 0
    }
}

# Import schema
Write-Host ""
Write-Host "Step 3: Importing database schema..." -ForegroundColor Yellow
$importCmd = "source $schemaFile"
$importResult = & $mysqlPath -u root "-p$MySQLPassword" -e $importCmd 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to import schema" -ForegroundColor Red
    Write-Host "Error: $importResult" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Schema imported successfully!" -ForegroundColor Green

# Import sample data if file exists
if (Test-Path $sampleDataFile) {
    Write-Host ""
    Write-Host "Step 4: Importing sample data..." -ForegroundColor Yellow
    $sampleCmd = "source $sampleDataFile"
    & $mysqlPath -u root "-p$MySQLPassword" -e $sampleCmd 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Sample data imported successfully!" -ForegroundColor Green
    } else {
        Write-Host "! Warning: Sample data import had issues (this is optional)" -ForegroundColor Yellow
    }
} else {
    Write-Host ""
    Write-Host "Note: Sample data file not found (optional)" -ForegroundColor Gray
}

# Verify installation
Write-Host ""
Write-Host "Step 5: Verifying database setup..." -ForegroundColor Yellow

$verifyCmd = @"
USE ptit_learning;
SELECT 
    'Tables' as Type, 
    COUNT(*) as Count 
FROM information_schema.tables 
WHERE table_schema = 'ptit_learning'
UNION ALL
SELECT 
    'Users' as Type,
    COUNT(*) as Count
FROM users
UNION ALL
SELECT 
    'Courses' as Type,
    COUNT(*) as Count
FROM courses;
"@

$verifyResult = & $mysqlPath -u root "-p$MySQLPassword" -e $verifyCmd 2>&1

Write-Host ""
Write-Host "Database Statistics:" -ForegroundColor Cyan
Write-Host $verifyResult
Write-Host ""

# Show test account
$accountCmd = "USE ptit_learning; SELECT email, fullname, phone FROM users LIMIT 1;"
$accountResult = & $mysqlPath -u root "-p$MySQLPassword" -e $accountCmd 2>&1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Test Account:" -ForegroundColor Yellow
Write-Host $accountResult
Write-Host ""
Write-Host "Login Credentials:" -ForegroundColor Yellow
Write-Host "  Email: test@ptit.edu.vn" -ForegroundColor Green
Write-Host "  Password: 123456" -ForegroundColor Green
Write-Host ""
Write-Host "Access your application at:" -ForegroundColor Yellow
Write-Host "  http://localhost:8080/" -ForegroundColor Cyan
Write-Host ""

# Update DatabaseConnection.java if password is different
if ($MySQLPassword -ne "123456789") {
    Write-Host "NOTE: Your MySQL password is different from the default in code." -ForegroundColor Yellow
    Write-Host "You need to update the password in:" -ForegroundColor Yellow
    Write-Host "  src/main/java/com/example/util/DatabaseConnection.java" -ForegroundColor Cyan
    Write-Host "  Line 13: private static final String PASSWORD = `"$MySQLPassword`";" -ForegroundColor White
    Write-Host ""
}
