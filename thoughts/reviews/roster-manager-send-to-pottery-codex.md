## Findings

1. **High — “Send, then upload the same file” can create duplicates because camp names differ.**  
   [js/app.js:8748](/Users/christiehubley/roster-manager/js/app.js:8748), [js/app.js:8849](/Users/christiehubley/roster-manager/js/app.js:8849), [js/app.js:9747](/Users/christiehubley/roster-manager/js/app.js:9747)

   The button prefills the camp with raw `_activityValue`, such as `Fired Up!`, while the Daily Roster importer builds `csvCampName` as `Activity + AM/PM`, such as `Fired Up! AM`. Since both `potteryCSVKey` and `potteryHasEntry` include the camp slug, the later upload does not recognize the sent student and creates another entry.

   Workshop names can diverge more substantially: workshop loading applies `extractActivityTheme()`—for example, `School Day Off // Wheel Workshop` becomes `Wheel Workshop`—while the pottery CSV importer retains the raw Activity and may append a time slot. This also defeats deduplication.

2. **Medium — Uploading the email-bearing CSV after a phone-only send skips the row without backfilling the email.**  
   [js/app.js:9749](/Users/christiehubley/roster-manager/js/app.js:9749), [js/app.js:9644](/Users/christiehubley/roster-manager/js/app.js:9644)

   Scenario:

   - An older roster has phone but no `parentEmail`.
   - Send it to Pottery and import.
   - Upload the same Daily Roster containing the email.
   - `potteryHasEntry` matches the phone, so line 9749 immediately skips the row.
   - The existing entry remains email-less and is excluded from Copy BCC Emails.

   Duplicate prevention works in this exact case, but the better contact data is discarded. The duplicate branch should enrich missing contact fields before skipping.

3. **Medium — “Re-load the roster … to get emails” does not work through Update Roster for existing students.**  
   [js/app.js:8450](/Users/christiehubley/roster-manager/js/app.js:8450), [js/app.js:9206](/Users/christiehubley/roster-manager/js/app.js:9206)

   `diffStudents` parses `parentEmail`, but an exact name+parent match only records the existing ID. It never copies the newly parsed email onto that student. Applying a no-change Update Roster therefore leaves the roster without emails, despite the new message directing the user to reload it. Only entirely new students receive `parentEmail`.

4. **Medium — Empty-field guarantees are not enforced on the new path.**  
   [js/app.js:9735](/Users/christiehubley/roster-manager/js/app.js:9735), [js/app.js:9754](/Users/christiehubley/roster-manager/js/app.js:9754), [js/firebase-data.js:113](/Users/christiehubley/roster-manager/js/firebase-data.js:113)

   Session is trimmed and validated, but camp is neither trimmed nor validated. Clearing it produces the unrelated default `Fired Up! AM`; whitespace is accepted and written as the camp name. Missing contact and status values are also written as `null`, rather than stripped. Much of the null behavior predates this commit, but the new roster action exercises it and therefore does not satisfy the stated “strip empty fields” requirement.

## Requested area checks

- **Withdrawn students:** No issue. `sendStudentsToPottery` filters them before creating pending rows.
- **Sending the same unchanged roster twice:** No issue when camp/session remain identical; the generated key or `potteryHasEntry` skips it.
- **Parent-email parsing:** No issue for the expected `Parent Email` header. Empty emails are not added to roster student objects.
- **XSS:** No issue found in the new HTML. User-controlled camp/session values are escaped, and the added buttons contain static content/internal roster IDs.
- **Prints, normal camp exports, and diff display:** No new email exposure. Camp/workshop prints and camp CSV/TSV exports do not include `parentEmail`; diff panels do not display it.
- **JSON export:** Saved roster emails will now be included because the complete saved data object is exported at [js/app.js:4873](/Users/christiehubley/roster-manager/js/app.js:4873). That is the one newly expanded export surface.
- **PII/storage:** Email joins names, phones, and sensitive roster data in working-state localStorage and saved Firestore sessions. Each Save Again pushes another full roster snapshot at [js/app.js:1931](/Users/christiehubley/roster-manager/js/app.js:1931), so emails marginally accelerate the known 1 MiB single-document limit. The privacy classification is not fundamentally new—the document already holds substantial PII—but JSON backups and cloud retention now include another direct identifier.
- **Syntax:** `node --check` passed for both JavaScript files. No automated test suite was present. No files were modified.
