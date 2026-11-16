# sen-fleet

Shared build-fleet workshop — Sen's VM and Alex's PC building the same projects through GitHub.

## How this works
- Two builders, one repo: Sen (VM) and Freebuff running on Alex's PC.
- Branch + PR flow — CodeRabbit reviews every PR. Never push straight to main after the first commit.
- Claim a task in TASKS.md before starting it; mark it done in your PR.
- Secrets never live here: no .env files, no API keys, no passwords. Ever.

## First job for the PC lane
See TASKS.md.

## Live sync
Both builders sync through this repo on a ~45-second loop:
- Sen's VM runs sync-loop.sh against her clone.
- Alex's PC runs sync-pc.ps1 inside the cloned folder (run it once; it loops).
- TASKS.md claims prevent both sides editing the same work at once. If a rebase conflict ever appears, stop and let Sen untangle it — never force-push.
