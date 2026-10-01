Read-only review of `6108d69`. I read the surrounding code (not just the hunks), traced the DOM/CSS interaction, and hand-checked the new regexes byte-for-byte against the source plus the mutations they claim to catch. I did **not** run the suite (repo read-only; my scratchpad regex harness wasn't approved to execute) — the regex verification below is by inspection.

## Does each change resolve its finding?

**1. Detail refresh — `js/app.js:8245-8246` — resolves it, and the hazard was real.**
Verified the failure mode it fixes: `handleSubConfirmToggle` (`js/app.js:7942-7945`) re-reads fresh and, when `sub.confirmed`, goes straight into `unconfirmTimeOffSub` with **no** confirm() on the manager path (`js/app.js:8309+`) — so a stale "Mark Confirmed" click really would have silently un-confirmed and pulled the shift. Now refreshed.
No new swap introduced: `openConfirmSubModal` is reachable only from the detail's own toggle (`js/app.js:7704`), so a same-request box always has *that* request's detail behind it — exactly the stale one. Different-request boxes still skip. The two modals are siblings (`index.html:755` vs `1179`) at equal `z-index:1000` (`css/styles.css:583`), so the re-render paints *under* the open box — the box is not buried and its checkboxes are not in the re-rendered subtree. `closeConfirmSubModal(true, ctx)` has already nulled or bypassed `_confirmSubCtx`, so the `!== ctx` clause is redundant but harmless.

**2. Hung-save message — `js/app.js:8114-8119` — resolves it, polarity correct.**
`_confirmSubBusySince` is assigned synchronously right after `_confirmSubBusy = true` (`8121-8123`), and both readers gate on `_confirmSubBusy` first, so the stale `Since` left behind by `finally` can never be read. No false statement.

**3. Secured wording — `js/app.js:8452` — resolves it.** `unconfirmedSubNames` emits `'a sub with no name'` (`js/schedule-helpers.js:218`), which made the old "next to their name" nonsense; the new phrasing is right for that case.

**4. Tests — `schedule-editor-wiring.test.js:2374, 2382, 2385`.** All three pin what they claim. Traced by hand: swapping the alert branches, flipping `> 60000` to `<`, moving the `const` above `closeConfirmSubModal`, dropping the `requestId` clause, negating `!otherRequestBoxOpen`, and removing/renaming the `submitBtn` lookup each break their regex. The "moving it before the await fails" claim holds.

## Findings

**BLOCKING** — none.

**MEDIUM** — none.

**LOW**
1. `js/app.js:8117` — "Reload the page … check first whether it went through" reads binary, but the flow writes the sub's schedule *before* the request doc, and a reload kills the code that would roll a refused write back. The honest outcome set includes "shift on their schedule, sub not marked confirmed." Consistent with the existing escape-hatch wording (`8071`), so not worth blocking — but "check their schedule as well as the request" would be truer.
2. `schedule-editor-wiring.test.js:2374` — `[^}]*` became `[^]*?`, which now crosses braces. Still anchored tightly enough at both ends (one `if (_confirmSubBusy) {` in the slice, tail pinned to `if (btn) { btn.disabled = true;`), but it would now tolerate arbitrary code inserted inside the gate. `[^}]*` before the `alert(` would keep the old tightness.
3. `schedule-editor-wiring.test.js:2384` — stale comment "a late save does not swap the detail behind another open box" left above the corrected one; on its own it now overstates the rule.
4. `js/app.js:8452` — "`Bob isn't` confirmed yet … next to **each** unconfirmed sub" is grammatically loose in the single case. `${one ? 'that sub' : 'each unconfirmed sub'}` would read right in both without reintroducing the name.

Nothing stale is left on screen, no detail is swapped behind another request's box, and no message states something untrue.

ready to push for deploy review — **yes**
