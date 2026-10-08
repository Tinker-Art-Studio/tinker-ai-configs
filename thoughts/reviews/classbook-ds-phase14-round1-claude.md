# Phase 14 review, round 1 — Claude (independent agent, read-only)

Run as a fresh Claude agent from the working session because the `claude --print` CLI's login had expired. Same brief as `classbook-ds-phase14-round1-input.md`.

## Verdict: SAFE TO COMMIT

## Findings
- **MEDIUM (product):** an existing production clash would lock that semester's Settings until a row is renamed, and the renamed row gets fresh empty slots (shared lessons stay with the other row). Recommended a read-only check of the live rosters before deploy, and saying what a rename does in the alert. → Done: live check found no clashes (Fall 2026 25 rows, Spring 2026 19, Spring 2027 25); alert now explains the rename.
- **LOW:** alert said names "only differ in spaces, punctuation or capitals", but makeLessonKey also drops non-ASCII characters. → Wording now includes accented/special characters.
- **LOW:** the camp-season guard's `/same lesson key/` assertion could never fail. → Now asserts the dialogs equal `['Settings saved!']`.
- **LOW (shipped core, not this diff):** no spec covers addMissingLessonSlots refusing after a failed load, or saveSettings' "Settings saved, but … slots weren't created" path. → Not in this change; follow-up.
- **Informational:** validation loops every week though week 1 decides; left as is.

Verified correct: placement in saveSettings (after the semester-mismatch guard, the pause check and the SDOC branch; before the config clone and updateAppData); the numWeeks value matches what is saved and used for slots; isWeeklySemester defaults unknown semesters to weekly, matching settingsFieldPathsFor; rows without a teacher skipped as in the slot creator; pairs identified by JSON [teacher, className]; no new writes or collections.

## Claim 1 (most of Phase 14 already shipped Oct 1, 7873077): CONFIRMED
addMissingLessonSlots is one transaction that reads the semester document and writes only keys absent on the server; existing keys never written; cache merged only with what was created, after commit. Stronger than the plan (no check-to-write gap). Load gate, summer skip and error propagation present. Differences from the plan: a locally-missing/server-present key is left for the listener rather than hydrated; identity-mismatch report not built; atomic all-or-nothing instead of per-key collect-and-report (safer).

## Claim 2 (identity-mismatch check not worth building): AGREE
Candidates are only cache-missing keys, so with a fresh cache drift is silent and the check never runs — it would only catch the stale-cache variant, reintroducing cache-timing dependence; an exact-string compare would flag a capitalization-only rename; nothing is written either way. The general case (a roster row resolving to a lesson left by a removed, differently-spelled row) is a pre-existing behavior of key-based lookup, fixable only by a rename/re-key policy — out of this phase's scope. No missed data-loss path.
