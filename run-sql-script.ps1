# Run create-lesson-progress-table.sql script on MySQL database
$MySQLPath = "C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe"
$Database = "ptit_learning"
$User = "root"
$Password = "NTHair935@"
$ScriptPath = "C:\Users\AD\Downloads\demo\create-lesson-progress-table.sql"

if (Test-Path $MySQLPath) {
    Write-Host "Executing SQL script..." -ForegroundColor Green
    & $MySQLPath -u $User -p"$Password" $Database -e "source $ScriptPath"
    Write-Host "SQL script executed successfully!" -ForegroundColor Green
} else {
    Write-Host "MySQL not found at: $MySQLPath" -ForegroundColor Red
    Write-Host "Please update the path in this script." -ForegroundColor Yellow
}
