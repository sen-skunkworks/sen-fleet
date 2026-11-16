# Sen fleet PC setup: installs OpenSSH server, plants Sen's public key, starts SSH.
# No secrets in this file - the key below is a PUBLIC key.
$ErrorActionPreference = 'Continue'
Write-Host "=== Sen fleet PC setup ===" -ForegroundColor Cyan

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$zip = "$env:TEMP\OpenSSH-Win64.zip"
$dest = "C:\Program Files\OpenSSH"
if (-not (Test-Path "$dest\OpenSSH-Win64\sshd.exe")) {
  Write-Host "Downloading OpenSSH..."
  Invoke-WebRequest "https://github.com/PowerShell/Win32-OpenSSH/releases/latest/download/OpenSSH-Win64.zip" -OutFile $zip
  Write-Host "Extracting..."
  Expand-Archive $zip -DestinationPath $dest -Force
} else {
  Write-Host "OpenSSH already extracted."
}

Write-Host "Installing sshd service..."
& "$dest\OpenSSH-Win64\install-sshd.ps1"

Write-Host "Planting Sen's key..."
$key = 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBdV6FVVlIeeGFgSP+fxBGQn6GPoAEaXAVchEDxxJynq hatch'
$keyFile = "$env:ProgramData\ssh\administrators_authorized_keys"
New-Item -ItemType Directory -Force -Path "$env:ProgramData\ssh" | Out-Null
if (-not (Test-Path $keyFile) -or -not (Select-String -Path $keyFile -SimpleMatch $key -Quiet)) {
  Add-Content -Path $keyFile -Value $key
}
icacls $keyFile /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F" | Out-Null

Write-Host "Starting sshd + firewall..."
Start-Service sshd
Set-Service sshd -StartupType Automatic
if (-not (Get-NetFirewallRule -Name sshd -ErrorAction SilentlyContinue)) {
  New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22 | Out-Null
}

Write-Host ""
Write-Host "=== DONE ===" -ForegroundColor Green
Get-Service sshd | Format-Table Name, Status, StartType
Write-Host "Tell Sen this line:"
Write-Host ("PC: " + $env:COMPUTERNAME + "   USER: " + $env:USERNAME)
