I read the files rather than working from the diff alone. Findings ordered by severity; areas you asked about that are clean are called out at the end.

## 1. Template edits can be silently lost (regression introduced by 38aa00f) — `js/app.js:9482`

`_tmplSaveTimer` is a single timer shared by all three textareas, but the payload is now only the one key being edited:

```js
let _tmplSaveTimer = null;                     // 9482 — one timer for all 3 inputs
...
clearTimeout(_tmplSaveTimer);                  // 9487
_tmplSaveTimer = setTimeout(function () {
  savePotteryTemplatesToFirestore({ [key]: ta.value })   // 9489 — only this key
}, 1000);
```

Failing scenario: edit the summer Notif 1 text, then click into Notif 2 and start typing less than a second later. The pending timer is cleared and the replacement sends `{notif2: …}` only. Notif 1's new text lives in `state.potteryTemplates` for the rest of the session, so the UI looks correct, but nothing wrote it — on reload `Object.assign(state.potteryTemplates, potteryTmpl)` (`app.js:10060`) restores the *old* saved notif1 and the edit is gone. Before this commit the payload was the whole `state.potteryTemplates`, so the surviving timer flushed both edits; the narrowing to one key is what makes the dropped timer lossy. Fix: keep a timer per template key (`_tmplSaveTimers[key]`), or flush the pending key on `blur`.

## 2. School-year dispose date can already be in the past the day Notif 3 goes out — `js/app.js:8911`, `8924`, `9701`

```js
if (season === 'school' && notif1) return addDays(notif1, 42);   // 8913
```

Dispose is anchored to Notif 1 and completely ignores when the final text actually went out. That matches the "dispose at 6 wks" hint only as long as Notif 3 lands on the suggested `notif1+28`.

Failing scenario: SDOC pottery, Notif 1 emailed 2026-10-14. Notif 2/3 slip (normal — they're manual "on send day" clicks). Christie sends the final text on 2026-12-01 and sets Notif 3 = 12-01. `potteryDisposeDate` returns 2026-11-25, so:
- `getPotteryStatusBadge` (`8928`) immediately renders **"Overdue · Dispose Now"** on every row, and
- the group header reads "Final notice — dispose by Nov 25, 2026" (`9701`–`9704`) — a date in the past,

on the same day the text promised a holding period. Under the summer rule she'd have had until Dec 15. That's a confidently-wrong date attached to an irreversible action (recycling a family's pottery). Suggest `max(notif1+42, notif3+14)`, or clamp to at least a week after Notif 3.

## 3. `patchPotteryField` + a manual key containing a period = silent write loss and phantom rows — `js/firebase-data.js:136`, `js/app.js:10102`

Pre-existing (not from this diff), but it's the dotted-path risk you asked about, and it's live:

```js
const key = 'manual::' + Date.now() + '::' + name.toLowerCase().replace(/\s+/g, '-');   // 10102 — only whitespace is replaced
```

`update({ [entryKey + '.' + fieldName]: value })` (`firebase-data.js:137`) parses dots as path separators, while `set(records, {merge:true})` treats the same key as a literal field name.

Failing scenario: Add Student named `J.R. Smith` → key `manual::1759…::j.r.-smith`. The initial `savePottery({[key]: entry})` writes a literal field with that name (correct). Then setting her Notif 1 date goes through `updatePotteryField` → `patchPotteryField`, whose path resolves to segments `['manual::1759…::j', 'r', '-smith', 'notif1']`, so Firestore creates a junk nested map and the real entry is never touched. The date shows in the UI (local state) and disappears on reload. `deletePotteryEntryFromFirestore` (`firebase-data.js:150`) has the same split, so deleting her succeeds locally, no-ops on the server, and she reappears after refresh — plus the junk key loads back into `state.potteryPickup` and renders an unnamed row under "Unknown Camp". Fix: run the manual key through `potterySlug(name)` (it already strips dots), and consider `FieldPath` instead of string paths.

The *new* key shapes are fine here — `potterySlug(session)` and `potterySlug(campLabel)` strip dots, and the CSV fallback slug strips everything outside `[a-z0-9|]`. The only remaining raw component is `row.internalId` from the Sawyer "Internal ID" column, which is numeric in practice.

## 4. `potteryHasEntry` compares only one contact channel → a whole week can import twice — `js/app.js:8879`

```js
const ek = String(e.parentEmail || e.parentPhone || '').toLowerCase();   // 8879
return !k || !ek || ek === k;
```

Both sides collapse to *email if present, else phone*, so an email-bearing record never matches a phone-only record.

Failing scenario: Christie scans a loaded roster (scan entries carry `parentEmail`, `app.js:9924`), or imports the legacy CSV format which has Parent Email (`8835`). Later she uploads the other Sawyer report for the same class — the non-legacy "Daily Roster", which has no email at all (`8849`, `hasEmail: false`). `k` is now the phone, `ek` is the email, they differ, so the content check returns false for every row and she gets a complete duplicate set of the week (the new key differs too, since `csv::` ≠ `summer::`). Fix: treat it as a match if *either* email or phone matches, and only reject when both sides have a value for the same channel and they differ.

## 5. Camp-mode scan hard-codes `season:'school'`, and a wrong season can't be corrected — `js/app.js:9950`, `9973`, `9637`

Camp Mode is the app's default mode (`index.html:131`) and is generic, not SDOC-specific; `isPotteryActivity` matches `'fired up'`, which is the *summer* camp name (your own summer template says "Fired Up Camp this summer"). Any Fired Up roster loaded in Camp Mode and scanned gets `season:'school'` unconditionally, so it inherits the 3/4/6-week timeline.

Compounding it: nothing in the UI shows or edits an entry's season (the table columns at `9329` have no season cell; the only signal is the group hint text at `9068`), and `potteryHasEntry` ignores season — so re-uploading the same week with the correct Season silently skips every row (`9637`). The only repair is deleting each row individually, then re-importing. Same trap with the CSV `Season` select, whose default comes from `defaultPotterySeason()` (today's month, `8892`): running a catch-up import of a late-summer week *right now* (September) defaults to 🍎 School year and silently gives that week the wrong timeline. Suggest either a per-row/per-group season control, or letting the CSV import update `season` on rows it skips.

## 6. CSV import discards each row's own camp name, so AM+PM in one file collapse — `js/app.js:8833` vs `9631`/`9636`

The legacy parser computes a per-row `csvCampName` including the AM/PM slot (`8833`), but the import uses one `campName` from the text input for every row (`9631`) and for every key (`9636`). A Daily Roster export that spans both Fired Up AM and Fired Up PM imports everyone under `rows[0].csvCampName`, so a child enrolled in both gets one key, one `potteryHasEntry` match, and **one** tracker row for two pieces of pottery — the exact failure 35e5749 fixed on the scan path (`9908`–`9913`). Your acceptance criterion "repeat campers … get separate entries for every week and camp" holds for Scan but not for CSV. Mitigated only by the instruction to export one class at a time (`9114`). Suggest using `r.csvCampName || campName` per row when the parsed file has more than one distinct camp.

## 7. Mixed-season camp group resolves to an arbitrary entry — `js/app.js:8897`

`potteryCampSeason` takes the *first* `Object.values(...)` match, i.e. whichever key happens to sort first in the pottery map. If one group ends up with both seasons (e.g. an Add Student row created with the season select left at its month-based default, in a camp+session already imported the other way), the group hint (`9068`) and the Notif 1 auto-fill (`9729`) describe one season while each row's badge (`8924`) uses its own — so the header can promise a 6-week hold on rows the badge will mark overdue at Notif 3 + 2 weeks. Deciding by majority, or flagging mixed groups in the hint, would make this visible.

## 8. `escapeHtml` doesn't escape quotes, and the new code puts session labels in attributes — `js/app.js:9136`, `9698`

`escapeHtml` is `textContent` → `innerHTML` (`1436`), which escapes `&`, `<`, `>` but **not** `"`. The new datalist writes a label straight into a double-quoted attribute:

```js
'<option value="' + escapeHtml(s) + '">'    // 9136
```

A session renamed (`9423`) to `a" onmouseover="alert(1)` yields `<option value="a" onmouseover="alert(1)">` — attribute injection without needing `>`. Severity is low: only admin/manager reach this tab, so it's staff-to-staff stored script, not an outside vector. The practical breakage is more likely: the new `n1Input` lookup at `9698` interpolates the same value into a CSS attribute selector, so a camp or session name containing `"` makes `querySelector` throw a `SyntaxError`, which aborts `updateDisposeByLabel` and, at `9843`, the whole header-date restore loop. (`9703` and `9835` have the same shape and predate this commit.) Worth a small `escapeAttr` helper (or `CSS.escape` for selectors) rather than reusing `escapeHtml` for both jobs.

## 9. Rollout note — a stale tab can still wipe the new school templates

`savePotteryTemplatesToFirestore` now merges (`firebase-data.js:177`), which is the right fix. But any browser still running the pre-38aa00f bundle does `set(state.potteryTemplates)` with no merge and no `school_*` keys — so one template keystroke from a tab that was open before the deploy deletes all three school templates from `rosterManager/potteryTemplates`. Cheap mitigation: after deploying, have anyone with Roster Manager open hard-refresh.

## 10. Dead code left on the old rule — `js/app.js:8946`

`renderRecycleDateCell` still computes `notif3 + 14` unconditionally. It's unreferenced (the table at `9329`–`9358` doesn't call it), so nothing wrong is displayed today — but if it's wired back up it will contradict `potteryDisposeDate` for school entries. Delete it or route it through `potteryDisposeDate`.

## No issues found

- **Scan AM/PM keying** (`9908`–`9914`): I traced AM-first, PM-first, three-camps-sharing-`student.id`, duplicate identical `campLabel`, and re-scan-after-partial-import. The `holder.campName !== campLabel` test plus the `candidates.some` guard behave correctly in all of them, and existing entries still backfill under their original key.
- **Withdrawn filter** (`9907`, `9940`, `9963`): all three scan paths skip before key construction; no withdrawn student can be added. Already-tracked students who later withdraw keep their entry, which looks intentional (they may still have pottery).
- **`localTodayStr`** (`9015`) and its two call sites (`9770`, `9787`): correct, and it fixes the real UTC-after-6pm-Mountain bug. `addDays`/`nextBusinessDay` still use `toISOString`, but they anchor at `T12:00:00` local, which is safe for any US zone.
- **New key shape vs. Firestore field paths**: no dot risk introduced (see #3 for the pre-existing manual-key case).
- **Field hygiene**: nothing writes `undefined` or `''` — `season` is only set when `'school'` (`9650`, `10107`), so existing summer entries keep their exact shape and the absent-means-summer contract holds. `notes`/contacts use `null`. Every Firestore call's failure path surfaces a toast.
- **No full-document overwrite**: both `rosterManager/pottery` and `rosterManager/potteryTemplates` writes now use `{merge:true}`; no key can be dropped by these paths.
- **Summer timeline unchanged**: `potterySuggestDates` summer branch (`8906`) and `potteryDisposeDate`'s fallback (`8914`) reproduce the old `nbd(n1+14)` / `nbd(n2+7)` / `n3+14` arithmetic exactly, and summer templates survive the merge-based load and save.
- **XSS elsewhere in the new markup**: the season selects, template textareas (`escapeHtml(tmpl[t.key])`), `data-template-key`/`data-template-season` values, and the CSV/season hint strings are all either static or correctly escaped for their context.

I changed nothing in the repo.
