# Create desktop shortcut for easy access
$WshShell = New-Object -ComObject WScript.Shell
$Desktop = [System.Environment]::GetFolderPath('Desktop')
$ShortcutPath = Join-Path $Desktop "PTIT Learning - Start.lnk"

$Shortcut = $WshShell.CreateShortcut($ShortcutPath)
$Shortcut.TargetPath = "C:\Users\AD\Downloads\demo\start-project.bat"
$Shortcut.WorkingDirectory = "C:\Users\AD\Downloads\demo"
$Shortcut.Description = "Start PTIT Learning Application"
$Shortcut.IconLocation = "C:\tomcat10\bin\tomcat10.exe,0"
$Shortcut.Save()

Write-Host "Desktop shortcut created: $ShortcutPath" -ForegroundColor Green
