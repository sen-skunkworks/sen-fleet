# Alex's PC side: near-live sync for sen-fleet. Run once in the cloned repo folder:
#   powershell -ExecutionPolicy Bypass -File .\sync-pc.ps1
# Pulls Sen's changes, auto-commits yours, pushes — every 45 seconds.
while ($true) {
  git pull --rebase --autostash origin main 2>$null | Out-Null
  $dirty = git status --porcelain
  if ($dirty) {
    git add -A
    git commit -q -m "pc sync $(Get-Date -Format o)" 2>$null | Out-Null
  }
  git push -q origin main 2>$null | Out-Null
  Start-Sleep -Seconds 45
}
