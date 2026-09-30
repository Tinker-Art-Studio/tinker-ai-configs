I would not deploy `38aa00f` yet. I found four correctness issues, including two likely deployment blockers.

## Findings

1. **High — editing two templates quickly silently loses the first edit.**  
   [js/app.js:9482](/Users/christiehubley/roster-manager/js/app.js:9482)

   All three textareas share `_tmplSaveTimer`, but each timeout now saves only its own key. Edit `notif1`, then begin editing `notif2` within one second: the second input cancels the `notif1` timeout, and only `notif2` reaches Firestore. The UI retains the first edit until reload, making the loss easy to miss.

2. **High — mixed-season camp groups can receive the wrong timeline.**  
   [js/app.js:8897](/Users/christiehubley/roster-manager/js/app.js:8897), [js/app.js:9729](/Users/christiehubley/roster-manager/js/app.js:9729)

   `potteryCampSeason()` uses the first entry matching session + camp. Bulk controls then use that single season for every entry in the group. Mixed groups are possible through CSV or manual additions.

   Failing scenario: an existing summer entry and a new school entry both have session `October 12` and camp `Teen Pottery`. If the summer entry was inserted first, entering Notif 1 auto-fills 2/3-week dates and applies them to the school entry too. Reversing insertion order gives summer entries the school schedule.

3. **Medium — legacy-key re-upload detection is unreliable when contact representation changes.**  
   [js/app.js:8874](/Users/christiehubley/roster-manager/js/app.js:8874), [js/app.js:9636](/Users/christiehubley/roster-manager/js/app.js:9636)

   `potteryHasEntry()` compares only `parentEmail || parentPhone`, without normalizing phone formatting or considering both fields.

   Failing scenarios:

   - Old import contains both email and phone; re-upload uses the phone-only report. Existing comparison selects email, incoming comparison selects phone, so the same child is added again.
   - `(303) 555-1212` versus `303-555-1212` produces a duplicate.
   - Conversely, two different students with the same normalized name and a missing contact are treated as the same person because `!k || !ek` returns true, skipping one despite distinct internal IDs.

   New-key re-uploads are protected by exact key matching; this specifically undermines the promised migration behavior for old keys.

4. **Medium — school entries lacking Notif 1 display a confidently invented summer-style disposal date.**  
   [js/app.js:8911](/Users/christiehubley/roster-manager/js/app.js:8911), [js/app.js:8924](/Users/christiehubley/roster-manager/js/app.js:8924)

   For `season:'school'`, `notif3` present, and `notif1` absent, `potteryDisposeDate()` falls back to `notif3 + 14`. The status badge then presents that as the disposal date even though the school rule is anchored to `notif1 + 42` and cannot be calculated. Example: Notif 3 entered as October 30 with no Notif 1 shows “Dispose by Nov 13.”

5. **Medium, pre-existing — dotted entry keys break field patches and deletes.**  
   [js/firebase-data.js:133](/Users/christiehubley/roster-manager/js/firebase-data.js:133), [js/firebase-data.js:146](/Users/christiehubley/roster-manager/js/firebase-data.js:146), [js/app.js:10102](/Users/christiehubley/roster-manager/js/app.js:10102)

   Updates construct a dotted string path, while deletes pass the key through `update({...})`. A manually added student named `A.B Smith` produces a literal map key containing `.`. Editing a date then targets a nested Firestore path instead of that literal key; deleting it likewise may leave the real entry behind, so it returns after reload. The new session/camp CSV components are safely slugged, but CSV `internalId` remains raw and could have the same problem.

6. **Low — empty template values are written.**  
   [js/app.js:9489](/Users/christiehubley/roster-manager/js/app.js:9489), [js/firebase-data.js:174](/Users/christiehubley/roster-manager/js/firebase-data.js:174)

   Clearing a template writes `{key: ''}` directly, contrary to the stated “no empty fields” requirement. No `undefined` values are introduced by this change.

## Areas that are fine

- **Existing summer data/templates:** No issue. Missing `season` remains summer, saved summer templates are merged over defaults, and per-key `{merge:true}` avoids full-document replacement.
- **Withdrawn students:** No issue. All three scan paths skip them.
- **Repeat campers under the new key scheme:** No issue for normal, stable inputs; week and camp are both included.
- **School date calculation when Notif 1 exists:** No issue. The 3/4/6-week calculations are correct.
- **XSS in new HTML:** No issue found. User/Firestore-derived session and template values are passed through `escapeHtml`.
- **Firestore template write shape:** No full overwrite; the actual Firestore operations are awaited inside their helpers.
- **Syntax:** Both JavaScript files pass `node --check`.

No files were modified.
