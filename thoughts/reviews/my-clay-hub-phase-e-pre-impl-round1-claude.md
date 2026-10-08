Verdict: PR #13 (phase-e-pre-docs): merge after fixes · PR #14 (phase-e-pre-derive-status): safe to merge (the should-fix is cosmetic and can ride along)

Reviewer: Claude (independent), round 1, Oct 8 2026. Read-only. I read both branch diffs against main (70ec0d1), the plan (Q1–Q9, "The link contract", E-pre, Decisions log) and clay-hub-membership (js/app.js, js/member-status.js at f8d69d8). I ran PR #14's code and tests copied to /private/tmp (with main's shared/denver-time.js). New code: 39/39 pass under TZ=UTC, America/Denver and Pacific/Auckland. Main's derive-status.js against the new tests: 3 fail (#70 processed/unprocessed, #70 malformed-before-processed, #70 rule-10 case), so the new tests do fail on main. The "history" and "!malformed marker" tests pass on main, which is expected: they guard against regressions.

No blocking findings in either PR.

## What I confirmed
- **Code (PR #14), shared/derive-status.js:52–53.** The order is right. A non-object `scheduledPause` (a string such as "!malformed", an array or a number) is still pushed and becomes malformed, so it gives `review`. Only an object with `processed === true` (strictly the boolean) counts. History entries are untouched and ignore any `processed` key. A processing-first implementation would fail test L259 ("!malformed" → review), so the order is pinned. Tombstone/retired and not_yet still come before any pause data (L88–89, L278ff).
- **Membership Manager matches #70.** `isProcessedScheduledPause` is `!!(sp && sp.scheduledAt)` (member-status.js:127–131). Quick Log (app.js:3761) writes `{startDate, endDate, notes, loggedAt}` and **doesn't change `stage`**, so rule 10 (paused stage with only an unprocessed request → review) can't be reached from Quick Log. It's only reached by a hand-edited stage, and `review` is correct there. The processed workflow writes `scheduledAt` (app.js:3631) and the auto-correct path also writes it (app.js:505).
- **Nothing else depends on the old behaviour.** The only importers are tests/shared/fingerprint.js, which uses pauseHistory only, and the test file itself. No function code uses it yet.
- **DATA-MODEL rules 1–11 (PR #13, DATA-MODEL.md:69–83) match the PR #14 code** in content and order. The D-5 edge notes are still accurate.
- **Q7 is in DECISIONS #71, DATA-MODEL:116 and :119, and SPEC §3:** everything is kept except email, emailLower and phoneLast4; the profile reduces to `{memberId, tombstone, status:'removed', updatedAt}`.
- **The never-copy list holds.** Through its "anything not listed above" catch-all it covers every real field I found in app.js (workflows, onboardingChecklist, photoRelease, orientation*, tradeStatus, termStart/End, tourDate, invitationStatus, shelf*, keypad*, staffNotes, application, actions) and the nested pause fields (type, notes, completedAt, loggedAt, lastBilling, sawyerProcessedAt, sawyerPending). The phone rule matches `formatPhone` (member-status.js:293–298).
- **#65–#69, #72 and #73 match Q1–Q5, Q8 and Q9.** No "3:30 AM" remains in SPEC, DATA-MODEL or shared/ once both PRs merge.

## PR #13 — docs

1. **should-fix — DATA-MODEL.md:93–95 ("Input shape").** The note lists `stage`, `scheduledPause`, `pauseHistory` and `scheduledCancellation.finalAccessDate`, but not `tombstone`/`retired`. Before Q7 this didn't matter. Now a removed record keeps its stage, pauses and last day (#71). A recompute or reconcile that builds the "source shape" from only the listed fields would turn a removed member back into `active` or `paused` and count it as a status change. The code's header (derive-status.js:10, "plus tombstone/retired") and plan F6 both include them. Add `tombstone`/`retired` to this note and say that a removed record must reach deriveStatus with `tombstone: true`.

2. **should-fix — DATA-MODEL.md:116 (removed member).** Compared with the plan's Tombstones row, this leaves out three things:
   - the fields a removed record always carries: `memberId, firstName, lastInitial, statusDate, sourceReadTime, updatedAt`;
   - "if nothing was ever stored for that memberId, only those fields";
   - "a later live record replaces it with the full allowlist again" (re-appearance).

   The E-1/E-4 implementer will read this file. Copy the row's wording.

3. **should-fix — DATA-MODEL.md:55 (copied fields).** `pauseHistory` is described only as a list of entries. The contract also allows `"!malformed"` for the whole field (not a list) and for an entry (not an object). PR #14's test (L278ff) tests both. Also say `emailLower` is "email lowercased, or null", and that `processed` is true only when the source `scheduledAt` is non-empty (the contract's exact rule). Without that, "`scheduledAt` is reduced to the `processed` flag" (L57) doesn't say how.

4. **should-fix — DATA-MODEL.md:202 ("Their two Cloud Run services' only invoker is clayhub-link@ itself (#73)").** This overclaims. Until #67's removal is done and proven, Google's project-wide grant also gives the default Compute account invoke rights, and project Owners can always invoke. Also, the line sits under `reconcileLink`, so "their two" reads as if it could include the schedule. Use #73's own wording: Christie grants `run.invoker` to `clayhub-link@` on exactly the two trigger services (onclayhubmemberwritten, onstaffuserwritten), never project-wide, and the guard attests the list.

5. **nit — DATA-MODEL.md:110 vs :119 and :206 (what the recompute writes).** L110 says "the profile's `pause`". L119 and L206 say the profile's `status`/`pause`. Make all three say `status`, `statusDate` and the profile's `status`/`pause` (plus `updatedAt` only when content changes, per the contract's gate row).

6. **nit — DATA-MODEL.md:123 (linkOverrides).** Compared with the plan's E-4 override rules, this leaves out: limits are integers 0–249; `members` needs at least one limit; `usedAt` starts `null` and becomes a server timestamp; expiry is measured from the doc's Firestore createTime; two eligible overrides refuse all; an override is used only when the normal limit would stop the run. Either add these or point to the plan as the exact schema, as L59 does for the envelope.

7. **nit — DECISIONS.md:89 (#72).** "max(⌈10% of live members⌉, 10)" is looser than Q8's denominator, which is live held records minus held ids. Consider "live held records (held conflicts excluded)".

8. **nit — rule renumbering.** #70 moves old rules 7–10 to 8–11. DECISIONS #58 and #59 (L75–76) still say "rule 7", which now means the scheduledPause rule. Don't edit historical rows. Instead, add one line under DATA-MODEL's rule list: "#70 (Oct 8) inserted rule 7; rules 8–11 were 7–10 before; older DECISIONS rows use the old numbers."

## PR #14 — deriveStatus

9. **should-fix (cosmetic) — rule numbers in the code and tests still use the old numbering**, while the file header (test L1) and the docs use 1–11:
   - derive-status.js:41 "Malformed (rule 7, C8)" → "rule 8"; the non-object scheduledPause part is now rule 7.
   - derive-status.test.js:62, 72, 77, 82: the test names "rule 7", "rule 8", "rule 9", "rule 10" should be rule 8, 9, 10, 11.
   - derive-status.test.js:195 "cases of rule 10" → rule 11.
   - derive-status.test.js:274 already says "(rule 10)" in the new numbering, so it contradicts L77's "rule 9" for the same rule inside one file.

10. **nit — test coverage the plan lists as "legacy".** There is no #70 case that puts a legacy-spelled history entry (`{start, end}`) next to an unprocessed scheduledPause. The behaviour is obviously right from the code, but one assertion would close the plan's list. Similarly, the totality test (L230–247) could add `{ scheduledPause: {...CURRENT_PAUSE, processed: false} }` and `{ scheduledPause: '!malformed' }` to its pause set (the count assertion would change to 8 × 4 × 7).

11. **nit — derive-status.js:14–15.** The comment says the link sets `processed` true "when … its scheduledAt is present". Add "non-empty" to match the contract and Membership Manager's `!!sp.scheduledAt`.

No other issues. In both PRs the diffs touch only the files named, and PR #14's behaviour change is exactly the one Q6 = B asks for.
