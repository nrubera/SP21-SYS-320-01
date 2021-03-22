# Storyline: SCript that starts and stops windows calculator
Start-Process -FilePath C:\Windows\System32\win32calc.exe

$stopApp = Read-Host -Prompt "Enter process you want to stop"

Stop-Process -Name $stopApp