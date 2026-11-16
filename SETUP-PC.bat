@echo off
REM Sen fleet PC setup - double-click this file. It asks for admin once, then does everything.
net session >nul 2>&1
if %errorlevel% neq 0 (
  powershell -NoProfile -Command "Start-Process '%~f0' -Verb RunAs"
  exit /b
)
powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest 'https://raw.githubusercontent.com/sen-skunkworks/sen-fleet/main/setup-fleet-pc.ps1' -OutFile $env:TEMP\setup-fleet-pc.ps1; & $env:TEMP\setup-fleet-pc.ps1"
echo.
pause
