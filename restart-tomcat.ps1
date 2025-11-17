# Stop Tomcat
Get-Process -Name "java" -ErrorAction SilentlyContinue | Stop-Process -Force

# Wait a bit
Start-Sleep -Seconds 2

# Start Tomcat
Set-Location "C:\tomcat10\bin"
.\startup.bat

# Wait for startup
Start-Sleep -Seconds 10

# Check if port 8080 is listening
$result = Test-NetConnection -ComputerName localhost -Port 8080 -WarningAction SilentlyContinue

if ($result.TcpTestSucceeded) {
    Write-Host "SUCCESS: Tomcat is running on port 8080" -ForegroundColor Green
    Write-Host "URL: http://localhost:8080/demo/" -ForegroundColor Cyan
} else {
    Write-Host "ERROR: Port 8080 is not responding" -ForegroundColor Red
    Write-Host "Checking logs..." -ForegroundColor Yellow
    
    # Show last 20 lines of catalina log
    $latestLog = Get-ChildItem "C:\tomcat10\logs\catalina.*.log" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($latestLog) {
        Write-Host "`nLast 20 lines from $($latestLog.Name):" -ForegroundColor Yellow
        Get-Content $latestLog.FullName | Select-Object -Last 20
    }
}
