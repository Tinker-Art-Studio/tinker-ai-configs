## Verdict: CHANGES NEEDED — 1 new MEDIUM

**Round-2 findings — all fixed in revision 3** (verified against code @ `2ef2e62`):

- HIGH (no redraw): `refreshDayOffYear()` now awaits the outcome and calls `renderAdminGrid()` itself for any non-`'stale'` outcome including `'failed'`; the "Curriculum Admin sets that listener up" claim is corrected — both `initTeacherView` (`js/app.js:676`) and `initCurriculumAdmin` (`js/app.js:5038`) register it, last wins; shared in-flight promise; BDD added (plan line 681).
- MEDIUM (`source:'server'`): stated plainly, `loadLessonData()` cited (`js/firebase-data.js:775-776`), offline start → guard + banner, Christie's yes asked with the go; BDD added (line 685).
- MEDIUM (editor guard): scoped to the `sdoc` branch only, summer's `: true` untouched — matches `js/app.js:11515`.
- LOWs: `isIsoDate()` (`js/firebase-data.js:2000`) gates the date; stamp also set on startup's install.

## NEW — MEDIUM: two other install paths still redraw through the wrong callback

The fix covers only the outcome `refreshDayOffYear()` awaits. Two paths install SDOC data and move the stamp/guard but redraw via `callback` — after a Teacher View visit that is Teacher View's, which returns without touching the admin grid (`js/app.js:683-687`):

1. **The failure path's own retries** (`js/firebase-data.js:1151-1157`; 5s, 15s). A failed refresh's retry succeeds → data installs, guard and banner clear, stamp advances — while the list still shows stale rows plus "Couldn't refresh — showing the last full refresh (10:42)", and Open plan is silently editable again. The plan's "A later successful reload clears the guard … and the message" (line 621) is untrue for this path.
2. **A snapshot-triggered reload** (`js/firebase-data.js:1190-1194`) while she sits on Curriculum Admin: it re-reads every SDOC year and, per the stamp sentence, advances it with no redraw.

**Fix (one or two sentences):** put the redraw where the install happens — the callback redraws whatever tab is active (codex's round-2 suggestion) — or name these two paths as redrawing too. Add a BDD: refresh fails, retry succeeds → message gone, rows fresh.

Read-only; nothing edited. Plan mode blocked writing the review file to `thoughts/reviews/`.
