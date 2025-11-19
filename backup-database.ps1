# ============================================
# PTIT Learning - Database Backup Script
# ============================================
# CHẠY SCRIPT NÀY ĐỂ BACKUP DATABASE TRƯỚC KHI RESTART SERVER

$mysqldumpPath = "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe"
$mysqlPath = "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
$database = "ptit_learning"
$password = "NTHair935@"
$backupDir = "C:\Users\AD\Downloads\demo\backups"
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$backupFile = "$backupDir\ptit_learning_backup_$timestamp.sql"

# Tạo thư mục backup nếu chưa tồn tại
if (-not (Test-Path $backupDir)) {
    New-Item -ItemType Directory -Path $backupDir | Out-Null
    Write-Host "Created backup directory: $backupDir" -ForegroundColor Green
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Database Backup Tool" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Kiểm tra MySQL tools
if (-not (Test-Path $mysqldumpPath)) {
    Write-Host "ERROR: mysqldump not found at $mysqldumpPath" -ForegroundColor Red
    exit 1
}

Write-Host "Starting backup..." -ForegroundColor Yellow
Write-Host "Database: $database" -ForegroundColor Gray
Write-Host "Backup file: $backupFile" -ForegroundColor Gray
Write-Host ""

# Thực hiện backup
try {
    & $mysqldumpPath -u root "-p$password" --databases $database --result-file="$backupFile" 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        $fileSize = (Get-Item $backupFile).Length / 1KB
        Write-Host "✓ Backup completed successfully!" -ForegroundColor Green
        Write-Host "  File: $backupFile" -ForegroundColor Cyan
        Write-Host "  Size: $([math]::Round($fileSize, 2)) KB" -ForegroundColor Cyan
        Write-Host ""
        
        # Kiểm tra số lượng records
        Write-Host "Database Statistics:" -ForegroundColor Yellow
        $statsCmd = @"
USE ptit_learning;
SELECT 'Users' as Table_Name, COUNT(*) as Records FROM users
UNION ALL
SELECT 'Courses', COUNT(*) FROM courses
UNION ALL
SELECT 'Orders', COUNT(*) FROM orders
UNION ALL
SELECT 'Course Progress', COUNT(*) FROM course_progress
UNION ALL
SELECT 'Lesson Progress', COUNT(*) FROM lesson_progress;
"@
        
        $stats = & $mysqlPath -u root "-p$password" -e $statsCmd 2>&1
        Write-Host $stats
        Write-Host ""
        
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host "  Backup Location" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host $backupFile -ForegroundColor Green
        Write-Host ""
        Write-Host "To restore this backup, run:" -ForegroundColor Yellow
        Write-Host "  .\restore-database.ps1 -BackupFile `"$backupFile`"" -ForegroundColor White
        
    } else {
        Write-Host "ERROR: Backup failed!" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
