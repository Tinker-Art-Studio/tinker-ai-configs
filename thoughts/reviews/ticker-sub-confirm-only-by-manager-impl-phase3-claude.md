## What I did

Read the plan's Phase 2 + Phase 3 in full, both Phase 2 reviews, the whole diff, and the surrounding production code (`js/app.js`, `js/firebase-data.js`, `js/schedule-helpers.js`, `index.html`, `sw.js`, `firestore.rules:439–448`).

**What I could not do:** every form of `npm test` / `npx jest` was denied by the permission layer, so **I did not execute the suite**. Every test claim below comes from tracing the regexes and slice boundaries against the actual file text by hand.

---

## Conformance

**64fb45d — all five Phase 2 review findings it targets land.**

| Phase 2 finding | Fixed? |
|---|---|
| Codex BLOCKING: cancel-that-confirms-anyway | ✓ `_confirmSubBusy` + forced closes. Codex's second half (the old operation closing a *newly opened* box) is closed by the `openConfirmSubModal` guard, `js/app.js:7998` |
| Codex BLOCKING / Claude M1: checkbox `value` XSS | ✓ at this call site (`:8022–8043`) — **root cause not fixed, see M1** |
| Claude M2: emulator guard-order case satisfied by an earlier guard | ✓ the new `{confirmed: true}`-only seed (`timeoff-sub-confirm.emulator.test.js:328–334`) walks past `appliedOverrides` and `subUid`, so only the `confirmed`-vs-`dates` order decides it. Swap the two guards and it goes red. Real. |
| Claude L1: box stays open after a `dates` refusal | ✓ `:8211` |
| Claude L5 / Codex LOW `:8099`: all-ticked-unwritable gets a generic message | ✓ `:8124–8128`, and `noShiftDates` is provably non-empty there (every `ctx.dates` entry goes to one bucket or the other) |
| Claude L3: "use custom times" unfollowable after the box closed | ✓ "…or Undo and confirm again with Custom times" (`:8244`) |

**Busy guard, traced:** nothing sits between `_confirmSubBusy = true` (`:8100`) and `try {`, and the `finally` (`:8249`) is the only reset. Everything the write depends on — `mode`, `customStart/End`, `ctx.dates` — is snapshotted *before* the flag is set, so the checkboxes and radios staying live behind the modal cannot change what is written. `closeConfirmSubModal` is still the only thing that removes `.open` from `confirm-sub-modal` (no backdrop or Escape handler covers it), and `_confirmSubCtx` is written only in the two guarded functions. The Undo route is covered too: clicking Undo on the in-flight sub re-reads `confirmed: false`, falls through to the confirm path, and is stopped by the same guard. **The DOM build is injection-free** — `box.value = d`, `createTextNode`, `textContent`; no parsed string anywhere.

**6bf822b vs the Phase 3 spec:** every acceptance bullet and every "Changes" item is implemented at the place the plan names. No omissions. One overreach: the `index.html:711` help-text reword is not in Phase 3 (L2).

**Trace of `updateCoverageStatus` (`js/app.js:8407–8449`)** — all thirteen resolve as specified:

| Case | Written | Manager sees | Dropdown after |
|---|---|---|---|
| Secured, no subs | guarded write, `expect.proposedSubs: null` (matches absent) | toast | Secured |
| all confirmed | guarded write | toast | Secured |
| one unconfirmed → Cancel | nothing | named warning | stored value (fresh re-read) |
| one unconfirmed → OK | guarded write | toast | Secured |
| two unconfirmed | — | "Sam and Alex aren't…" (3 → "Sam, Kayleigh and Alex") | — |
| failed read → Cancel | nothing | "Couldn't check the subs…" | stored value |
| failed read → OK | **plain unguarded** write | toast | Secured — per spec |
| request deleted | nothing | "no longer exists" | "Request not found" |
| sub confirmed/undone in another tab | nothing | "The subs…changed" | the other tab's recomputed value |
| approved → completed between read and write | guarded write succeeds | toast | select gone (correct: not rendered for `completed`) |
| any other status change | nothing | "status changed" | stored value |
| failed write | nothing | generic error, **no toast** | stored value |
| Pending / Partial / Not Needed | plain write, result now checked | toast or error | either way, re-rendered |

`result` is assigned on every reachable path; `read.data` is only dereferenced where `ok && exists` is guaranteed by the two preceding guards. `openTimeOffDetail` reads fresh from Firestore, so "the select never shows an unsaved value" holds on all five exits, and no unhandled throw can skip them.

**Firebase invariants: clean.** The only value written is `{ coverageStatus: status }` (one of four literals from the `<select>`). `expect.proposedSubs` is read-only. All three writes are awaited. No new collection, no rules change, no `undefined`.

---

## Findings

### MEDIUM

**M1 — the `escapeHtml` root cause is still open, and two live attribute-context uses remain.** `js/app.js:4502`; instances at `js/app.js:7697` and `:5105/5107/5109/5111`.
64fb45d fixed the one call site both Phase 2 reviewers pointed at, but `escapeHtml` is still `textContent → innerHTML`, which never encodes `"` or `'`. `firestore.rules:446–447` is an unrestricted `allow update` for the request's owner, so a staff member can put `x" onmouseover="…` into their own `proposedSubs[0].email`; `js/app.js:7697` renders it as `href="mailto:${escapeHtml(s.email)}"` in the manager's detail view — the same feature, one screen away from the box that was just hardened. `:5105–5111` are worse (`escapeHtml` inside a *single*-quoted JS string in `onclick`). Claude's Phase 2 review called the one-line fix (`"`→`&quot;`, `'`→`&#39;`) "the one finding I'd act on before the deploy"; the narrow fix taken here leaves the class open with the rationale now written into the code comment at `:8022`.

**M2 — the Phase 3 tests pass a Cancel/OK inversion.** `schedule-editor-wiring.test.js:2396–2406`.
The two Cancel ratchets match on `` Mark coverage Secured anyway?`)) { `` and `Mark coverage Secured anyway?')) { …`. Both `if (!confirm(…))` and `if (confirm(…))` produce that exact text, so swapping the branch — **Cancel writes Secured, OK does not** — leaves all four Phase 3 tests green. Deleting the `if (names.length)` gate (warn even when every sub is confirmed) also passes. This is Codex's unaddressed Phase 2 MEDIUM (`:2316`, "no behavioral test for the orchestration") landing again: the pure-helper tests (`schedule-helpers.test.js:3086–3095`) and the new emulator case are real and do bite, but the five `updateCoverageStatus` assertions are source regexes that pin *presence*, not *polarity*.

**M3 — `_confirmSubBusy` can latch true for the rest of the session, leaving the box permanently unclosable.** `js/app.js:8100`, `:8249`.
`saveSchedule` (`js/firebase-data.js:288–302`) awaits a compat-SDK `set()`, whose promise resolves only on server acknowledgement — offline it stays pending indefinitely, so the `finally` never runs. From then on × and Cancel both refuse with *"Still saving this confirmation… The box closes when it finishes"* (which it won't), and `openConfirmSubModal` silently returns for every other sub and every other request until the page is reloaded. Before 64fb45d the manager could at least close the box. Low likelihood (needs a network partition mid-write), fully recoverable by reload, and it costs nothing to bound — a timeout on the flag, or clearing it in `openConfirmSubModal` when `confirm-sub-modal` no longer has `.open`.

### LOW

**L1 — the busy guard's refusal to open is silent.** `js/app.js:7998`. On the success path the box closes at `:8216` but the flag stays true through `await getAllTimeOffRequests()` (a full-collection read) and `openTimeOffDetail`. During that window the detail modal still shows Mark Confirmed; a click does a Firestore read and then nothing at all — no modal, no message. A second click works. One `alert` or toast in the guard would close it.

**L2 — the `index.html:711` reword trades one inaccuracy for another, and isn't Phase 3's.** "when Ticker can match them to one person on the roster" fixes Claude's Phase 2 L8 (`ambiguous`) but now over-promises for `unclaimed` — one roster match with no `claimedBy` confirms with no schedule write (`js/schedule-helpers.js:200`, `js/app.js:7953–7960`). Accurate would be "…exactly one person on the roster who has signed in to Ticker". Also the only non-Phase-3 change in 6bf822b.

**L3 — `unconfirmedSubNames` passes `s.name` through raw.** `js/schedule-helpers.js:218`. A legacy or hand-written sub entry with no `name` produces "*undefined* isn't confirmed yet". The app's own `addTimeOffSub` always sets one, so this needs a migrated or console-written doc; `.filter(Boolean)` would end it.

**L4 — `under_review → approved` between the read and the write refuses a harmless label.** `js/app.js:8430`. The tolerance list covers only `approved → completed`, so another manager approving the request while the warning dialog is up produces "This request's status changed, so nothing was saved" for a change that doesn't invalidate the label. Exactly what the plan specifies; retry works. Noting it so the choice is on the record.

**L5 — deploy prerequisites outstanding.** `sw.js:64` is still `tinker-ticker-v24`; the plan requires the bump on the single deploy after Phase 3, and without it a cached page keeps the old `app.js` and none of these checks. The plan's Progress section also still records only Phase 1 — Phases 2 and 3 and their reviews aren't logged — and the Tests section's click-through on :8093 (the Secured warning snapping back) isn't recorded anywhere.

---

## Are the new tests real?

Mixed, and worth stating separately:

- **`unconfirmedSubNames`** (`schedule-helpers.test.js:3086–3095`) — real behavioural tests on the exported helper; order, `confirmed` absent vs false, and the three empty shapes all bite.
- **The emulator guard-order case** (`timeoff-sub-confirm.emulator.test.js:328–334`) — real, and it closes Claude's Phase 2 M2 exactly as described. It also partly closes M3: the mirror's guard *sequence* is now pinned behaviourally, not just by a presence regex.
- **The busy-guard ratchet** (`schedule-editor-wiring.test.js:2361–2374`) — real: the `busyOn < tryAt` ordering, the "no `return` in between", the `finally`, both forced closes and the open-guard all go red on a revert.
- **The DOM-build assertions** (`:2306–2318`) — real; `not.toMatch(/innerHTML/)` and `not.toMatch(/value="\$\{/)` make the old construction unrepresentable.
- **The five `updateCoverageStatus` assertions** — see M2. They catch deletion, not inversion.

---

## Ranked

| | Finding | Where |
|---|---|---|
| BLOCKING | *none* | |
| MEDIUM | M1 `escapeHtml` root cause + two live attribute uses | `js/app.js:4502`, `:7697`, `:5105` |
| MEDIUM | M2 Phase 3 tests pass a Cancel/OK inversion | `schedule-editor-wiring.test.js:2396` |
| MEDIUM | M3 `_confirmSubBusy` can latch true forever | `js/app.js:8100`, `:8249` |
| LOW | L1 silent refusal to open while busy | `js/app.js:7998` |
| LOW | L2 help-text reword over-promises for `unclaimed`; not Phase 3 | `index.html:711` |
| LOW | L3 raw `s.name` in the warning | `js/schedule-helpers.js:218` |
| LOW | L4 `under_review → approved` refuses a harmless label | `js/app.js:8430` |
| LOW | L5 `CACHE_NAME` bump, plan Progress, click-through outstanding | `sw.js:64` |

I could not find a wrong schedule write, a false confirmation, a label written that the warning wasn't decided on, a dropdown left showing an unsaved value, an unguarded or unawaited write, or an `undefined` reaching Firestore.

**Ready to push for deploy review — yes**, with M1 and M2 done first: M1 is a one-line change to `escapeHtml` that also closes older instances the plan's trap box doesn't cover, and M2 is adding the `!` to two regexes (or, better, one behavioural test of the Cancel path). M3 is worth a bounded fix but shouldn't block. The `sw.js` bump belongs to the deploy commit either way.

I have not edited anything, run any test, or touched a deploy.
