# ============================================
# PTIT Learning - Database Restore Script
# ============================================

param(
    [Parameter(Mandatory=$true)]
    [string]$BackupFile
)

$mysqlPath = "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
$password = "NTHair935@"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Database Restore Tool" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Kiểm tra file backup
if (-not (Test-Path $BackupFile)) {
    Write-Host "ERROR: Backup file not found: $BackupFile" -ForegroundColor Red
    exit 1
}

# Kiểm tra MySQL
if (-not (Test-Path $mysqlPath)) {
    Write-Host "ERROR: mysql not found at $mysqlPath" -ForegroundColor Red
    exit 1
}

Write-Host "Backup file: $BackupFile" -ForegroundColor Gray
Write-Host ""

$confirmation = Read-Host "This will OVERWRITE current database. Continue? (yes/no)"

if ($confirmation -ne "yes" -and $confirmation -ne "y") {
    Write-Host "Restore cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Restoring database..." -ForegroundColor Yellow

try {
    # Restore từ backup file
    $restoreCmd = "source $BackupFile"
    & $mysqlPath -u root "-p$password" -e $restoreCmd 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Database restored successfully!" -ForegroundColor Green
        Write-Host ""
        
        # Verify
        $verifyCmd = @"
USE ptit_learning;
SELECT 'Users' as Table_Name, COUNT(*) as Records FROM users
UNION ALL
SELECT 'Courses', COUNT(*) FROM courses
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders;
"@
        
        $stats = & $mysqlPath -u root "-p$password" -e $verifyCmd 2>&1
        Write-Host "Restored Data:" -ForegroundColor Yellow
        Write-Host $stats
        
    } else {
        Write-Host "ERROR: Restore failed!" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Restore Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
