**Verdict: READY.** Both round-2 MEDIUMs are fixed; no new HIGH/MEDIUM.

**Codex MEDIUM (cached complete + failed list) — fixed.** `js/app.js:12919` now withholds on `v.signoffErrors.has(camp.id) || count.failed`, so badge, Undo and button vanish together. `count.failed` is set inside the `projects` map, a `const` evaluated before the section template, so the flag is complete when the head renders. The failing project still shows "Couldn't load this list: …" inline, so the withheld state isn't silent. M26 pins it with a real server sign-off (`refreshDayOffSignoff` left unstubbed) and asserts count 0 for `.sdoc-evmat-done`, `.sdoc-evmat-complete-btn` and `text=Undo` — the gap Codex said M20 missed.

**Claude MEDIUM (superseded open's reads) — fixed.** `12858-12873`: `previous` captured, `await previous`, then `dayOffEventMaterialsView !== view` re-checked *before* any read; `dayOffEventMaterialsJobs = run.catch(() => {})` assigned synchronously before `await run`, so clicks chain in order and a doubly-superseded open reads nothing. Your two questions: **no deadlock** — every job has its own `.catch`, `allSettled` never rejects, and the stored link is `.catch(() => {})`, so even a sync throw lets the next open through; **nothing else awaits it** — the name appears only at 12844/12858/12872. M25 matches the design and always releases its gate.

**Two LOWs, no action needed:**
1. The chain is only as live as its slowest link — a read that never settles now strands every *later* open on "Loading…", not just its own. `get({source:'server'})` rejects when offline, so this needs a genuinely stuck stream.
2. The sign-off pre-check reads (`12796`) and the refused-tick re-read (`12976`) still install into the shared caches outside the chain. Sign off → close → reopen can let the older snapshot land last, but it needs a concurrent edit by someone else and triggers no render or write itself.

Write-up is in the plan file; `…-r3-claude.md` is still 0 bytes — copy it there.
