I could read the plan, both round‑1 reviews, the parent plan, the approved wording file (`my-clay-hub-phase-d-wording.md`), the guard design plan (`firebase-deploy-guard.html`), and the live global `CLAUDE.md`. **I could not read** `~/my-clay-hub/docs/**` or `~/studio-hub/scripts/**` — this session is sandboxed to `~/tinker-ai-configs`. So the SPEC §5/§15 check (Q2) and the guard‑adaptation findings are reasoned from the parent plan's own section map and from `firebase-deploy-guard.html`, not from the files. I flag each of those as "verify against the file."

---

## 1. Are the round‑1 findings resolved? (Q1)

Traced all 36 Claude findings and all 11 Codex findings against the rewrite. **44 of 47 are resolved correctly or reasonably deferred.** Notably good: the D‑4 requirements survive the C3 move essentially intact (poll‑to‑done, custom export role excluding `import`, write‑only bucket role, UTC schedule, before/after read‑back of `tinker-hq-vault-backups`, restore‑after‑failure‑test, `DATA-RESTORE.md`, cost note, fallback bucket name); the `deriveStatus` conflict list uses the parent D4 table's *actual* rule numbers (1–10), correcting round‑1 Claude's mis‑numbering; and the plan correctly rejects round‑1 Claude's "four statuses" in favour of the six the parent D4 table really yields. The lock rebuttal (`deploy-rules.sh:257`) is a source‑level check that beats the design doc, and is right to stand.

Three are not resolved. They are findings **3, 4 and 5** below.

---

## Findings

### 1. BLOCKING — `tests/rules/` in `CONTROL_FILES` is a directory, and the check that consumes it compares files

D‑3 table, row 3: *"Adds `package-lock.json`, `scripts/deploy-rules.test.sh`, `scripts/emulator-safety.js` and **`tests/rules/`** — so an older approved commit can't bring older tests along."*

Per `firebase-deploy-guard.html`, the control‑file comparison is per path via `git -C <repo> show "$SHA:<file>"`. `git show <sha>:tests/rules/` on a directory prints a **tree listing — the entry names only**. Two commits whose `tests/rules/` files have identical names but different contents produce identical output. So the one protection this row exists to add — "an older approved commit can't bring older tests along" — is exactly the case it fails to catch: an approved commit with *weakened* test bodies passes, while an added or deleted test file is caught. The acceptance would be signed off false, and only someone reading `predeploy-check.sh` would ever know.

This is the specific hole Codex #5 asked to close ("an older approved commit could supply stale tests while the guard claims its machinery matches `origin/main`"), so it also makes that finding unresolved in substance.

Suggested replacement for the right‑hand cell:

> Adds `package-lock.json`, `scripts/deploy-rules.test.sh`, `scripts/emulator-safety.js`, and the **test tree** `tests/rules`. Because `CONTROL_FILES` is compared with `git show "$SHA:<path>"`, which on a directory prints only the tree listing and not file contents, the test tree is compared by **tree object id** instead: `git rev-parse "$SHA:tests/rules"` must equal `git rev-parse "origin/main:tests/rules"`. (Equivalent and also acceptable: enumerate every file under `tests/rules/` explicitly.) The adapted test asserts this directly — **an approved commit in which one byte inside one test file differs from `origin/main` is refused**, not just one with a file added or removed.

Verify first: open `scripts/predeploy-check.sh` and confirm the comparison primitive. If it already uses `rev-parse` or `git diff --quiet <sha> origin/main -- <path>`, the directory entry is fine and this finding collapses to a nit.

---

### 2. SHOULD‑FIX — the two‑target first deploy asks for one approval after showing one diff

D‑3 step 5: *"`--status`; `--diff` pasted verbatim; the ask names both targets."* But the targets have different files, and `--diff` is per‑target. Appendix A §1c binds the phrase to *"after seeing that same guard's `--diff`"*. As written Christie approves sha S having seen the Firestore rules diff only, and `--approved S --target storage` then ships a file she was never shown — on the very deploy that establishes the procedure for every future one.

Suggested replacement for step 5:

> In that fresh session: `npm ci`; fetch; `--status` **and `--status --target storage`**; then **both** diffs pasted verbatim — `--diff` and `--diff --target storage` — and the ask: "This ships **firestore:rules and storage** from sha S: two guard runs, two receipts, one approval, both diffs above." Christie says the sentence; then `--approved S` and `--approved S --target storage`.

---

### 3. SHOULD‑FIX — round‑1 Claude #2 (don't enable the six functions APIs yet) is undispositioned, and the rewrite made it stronger

The Reviews table has no row for it. That mattered less in round 1; after C3 and C5 it matters more, because **nothing left in Phase D consumes any of the eight APIs.** The vault export (the only Phase‑D user of Cloud Scheduler) moved to after D2. `build@`'s roles (the only user of Cloud Build / Artifact Registry) moved to D2. D‑2, D‑3 and D‑5 use none of them. So step 9 now enables six APIs whose sole effect inside Phase D is to create the default Compute service account **with Editor**, which step 10 then has to find and remove.

The one real argument for keeping them is service‑agent propagation time before D2's first deploy (parent IAM inventory). Worth stating explicitly rather than leaving implicit. Suggested replacement for step 9 and a matching acceptance line:

> 9. APIs & Services → enable **Cloud Scheduler and IAM Service Account Credentials only**. The other six (Cloud Run, Eventarc, Cloud Functions, Cloud Build, Artifact Registry, Pub/Sub) have no consumer left in Phase D after C3 and C5 — D2 enables them, waits for the service agents, and re‑runs step 10's principal check in the same sitting. *If Christie prefers to enable all eight now for propagation time, that is fine — step 10 is what makes it safe either way; record which path was taken.*

And in the acceptance: `The eight APIs are on` → `The APIs enabled are recorded (two now, or all eight — see step 9), and the principal list shows no default service account holding Editor.`

---

### 4. SHOULD‑FIX — the parent plan is still unamended, so three things the rewrite moved will read as missing

Round‑1 Claude #33 asked for this for the backup schedule; the disposition says "Noted in D‑1", which notes it *here*, not there. `clayhub-members-foundation.html` still says, verbatim:

- Phase D acceptance: *"server-side backups, the IAM baseline (… **the build service account is set**)"* — C5 means it isn't set in Phase D.
- Phase D acceptance: *"a Sunday‑night booking crossing into Monday"* — C6 deletes that case.
- `D-4: the managed backup schedule and vault export (D13)` — the schedule moved to D‑1, the export moved past D2.

A session resuming from the parent will look for all three inside Phase D. Add a step to this plan (D‑3 step 6 is the natural home, since it already updates the resilience record):

> 6b. Update `clayhub-members-foundation.html`'s Phase D in the same commit: acceptance bullet 1 → "…the IAM baseline (the default service account has no Editor, the APIs are enabled, **`build@` exists with no roles — its roles and the deployer's `actAs` land in D2, C5**)…"; acceptance bullet 4 → "…week keys, both DST changes, **the Sunday booking ending at midnight (C6: bookings never cross into Monday)**, and `deriveStatus`'s full table…"; step D‑4 → "**the vault export (D13), after D2 — the managed backup schedule moved to D‑1. Phase E loads no real member data until its first export has completed successfully.**" Add the same two lines to this plan's Decisions log.

---

### 5. SHOULD‑FIX — C3's Phase E gate and D‑4's requirements live only in this plan

C3 says the gate is "added to Phase E's gate" and that D‑4's requirements are "kept in D‑4 so nothing is lost." Neither is true of any file Phase E's executor will read: the parent plan is unedited (finding 4), and once Phase D is signed off this plan is history. D‑4 is now the only off‑project backup for `my-clay-hub`, and it sits behind a phase (D2) that does not yet have a plan.

Suggested addition to the Completeness check, and to D‑4:

> **Phase D is complete when D‑1, D‑2, D‑3 and D‑5 are done.** D‑4 is not part of it. Before Phase D is signed off, two records must exist outside this file, or D‑4 is orphaned: (a) an entry in `~/my-clay-hub/docs/my-clay-hub/OPEN-ITEMS.md` — "vault export: after D2, must have one successful export before Phase E loads real member data (D‑4 of the Phase D plan)"; (b) the same sentence as a hard gate in the parent plan's Phase E. Until D‑4 ships, `my-clay-hub` has **no backup outside the project** — PITR and the managed daily backup live in the project itself and go with it. That is acceptable only while the database is empty, which is what the gate enforces.

---

### 6. SHOULD‑FIX — C5 hands D2 a bootstrap it cannot satisfy as stated

C5's reasoning is right: `gcf-v2-sources-*` / `run-sources-*` and the `gcf-artifacts` repository are created by the first functions deploy, so resource‑scoped grants can't be made before it. But the first functions deploy **needs** `build@` to already have source‑bucket read and Artifact Registry write, or Cloud Build fails. So "D2 grants its roles, scoped to the build buckets and function repository" is circular, and D2 will hit it cold at deploy time.

There is a clean answer worth naming now: an IAM **condition on a project‑level binding** matches `resource.name` by prefix and applies to resources that do not exist yet.

Suggested addition to C5's "Why" cell:

> D2 resolves the ordering with **conditional project‑level bindings** — `roles/artifactregistry.writer` and `roles/storage.objectViewer` on the project, each with an IAM condition restricting `resource.name` to the `gcf-artifacts` repository and the `gcf-v2-sources-*` / `gcf-v2-uploads-*` / `run-sources-*` prefixes. A condition on a name prefix binds resources created later, so the grant can be made **before** the first deploy without ever being project‑wide in effect. (The fallback — grant broadly, deploy once, then narrow — leaves a window where `build@` is over‑privileged and is not the plan of record.) The deployer's `actAs` on `build@` is granted in the same step.

---

### 7. SHOULD‑FIX — C1 assumes the Storage bucket's location is Christie's to choose

D‑1 step 8: *"Storage → Get started → production mode, location `us-central1`."* Creating Firestore in `nam5` (step 6) creates the project's App Engine application in `nam5`, and the default Firebase Storage bucket's location can be constrained by that. The plan applies exactly the right care to the *vault* bucket in D‑4 ("location confirmed against Google's rule **before** creating it; location is permanent") and none to this one — and unlike Firestore, there is no "wrong location" recovery scenario for it.

Suggested replacement for step 8:

> 8. Storage → Get started → production mode. **Read what the location selector offers before choosing.** If `us-central1` is available, take it (C1). If the default bucket's location is pinned by the `nam5` Firestore/App Engine location, take what it forces, **record it, and treat C1 as amended** — nothing in D‑2, D‑3 or D‑5 depends on the bucket's region, and the location is permanent either way. Then Cloud Console → that bucket → Object versioning on; Lifecycle → delete noncurrent versions after 90 days.

Add to the read‑back: *"Christie reads back the bucket's actual location; it is recorded in the Decisions log next to C1."*

---

### 8. SHOULD‑FIX — Appendix B is correct but not sufficient (Q3)

Checked each item against the live `~/.claude/CLAUDE.md` and against Appendix A's verbatim file.

**B1 — correct but lands on the wrong line.** It edits the first bullet. The unqualified statement is the *lead sentence* above it, which Appendix A does not touch either: *"a matching rule block must be added to `firestore.rules` and deployed before that collection will work."* That sentence is the one a session reads first. Suggested: keep B1's bullet edit **and** change the lead sentence to:

> **Any time a new Firestore collection is added to any app**, a matching rule block must be added to **that project's** rules file (see PROJECT STRUCTURE) and deployed **through that project's guard** before that collection will work. There is no default allow — Firestore denies everything not explicitly listed.

**B2 — correct and complete as drafted.** ✓

**B3 — correct, and my earlier concern about it is unfounded:** Appendix A §1f *does* carry forward "`tinker-hq-apps` rules affect ALL staff apps at once" and "Christie calls 'Tinker HQ' the Studio Hub app". The only two lines §1f drops are exactly the two B3 restores. ✓ One note: B3's third item (`Firestore rules source` → `Rules source (the only place to edit)`) **reverses round‑1 Codex fix (d)** in the wording file, which specifically asked for the column to say "Firestore". Adding "(+ `storage.rules` beside it)" to each cell keeps that specificity, so the resolution is fine — but say so, so Christie isn't approving an unflagged reversal.

**B is missing a fourth item.** The line *below* the SAFE DEPLOY PATTERNS table hardcodes both the receipt namespace and the runbook, and neither Appendix A §1e (which only adds a line *above* the table) nor B2 reaches it:

> Rollback = restore the FILE from an older receipt tag (`deployed/tinker-hq-apps/<target>/…`) onto a new commit on main, then the guard — see `studio-hub/RULES-ROLLBACK.md`.

Suggested B4:

> 4. **The rollback line under the SAFE DEPLOY PATTERNS table** becomes:<br>
> `Rollback = restore the FILE from an older receipt tag for that project (`deployed/tinker-hq-apps/<target>/…` or `deployed/<PROJECT_ID>/<target>/…`) onto a new commit on that repo's main, then that project's guard — see `studio-hub/RULES-ROLLBACK.md` or `my-clay-hub/RULES-ROLLBACK.md`.`<br>
> Why: D‑3 creates a second receipt namespace and a second runbook; this line names only the first of each, and it is the line a session reads while recovering from a bad deploy.

With B1's lead sentence and B4 added, Appendix B is sufficient — I found no other single‑project statement left standing across A + B.

---

### 9. SHOULD‑FIX — C6 is sound, but nothing holds the invariant up (Q2)

The reasoning is right and the resolution is the correct one of Codex's three options: `weekKey` comes from the start date, the end is half‑open, and a 22:00→midnight Sunday booking is 120 Sunday minutes in Sunday's ISO week. Confirmed against the parent's settings defaults: *"Opens 5 AM. Closes 11 PM every night at launch (midnight can be turned on per night later; Tuesday is fixed at 11 PM)"* and weekly cap *"20 hours, Mon–Sun, Denver time"* — with a 5 AM open and a ≤ midnight close, no booking can carry minutes into Monday. C7's ISO examples are all arithmetically correct (2026‑12‑28 is a Monday; 2026 is a 53‑week ISO year because Jan 1 2026 is a Thursday; 2027‑01‑01 is a Friday in `2026-W53`; 2027‑01‑04 is `2027-W01`).

But C6 is an invariant that lives in a *settings* value, and nothing in D‑5 or anywhere else enforces it. Turn on a 1 AM close in Phase F — a setting the parent explicitly anticipates ("midnight can be turned on per night later") — and minutes are mis‑attributed with no test failing. Suggested addition to C6 and to D‑5's acceptance:

> Recorded in DATA‑MODEL.md as an **invariant, not just a clarification**: *a booking's end is never later than midnight at the end of its start date, so every booking belongs wholly to its start date's ISO week.* Two things hold it up: (a) settings validation rejects a closing time later than 24:00 (Phase F, noted in DATA‑MODEL.md next to the invariant); (b) `shared/denver-time.js` exposes a check that a booking whose end falls outside its start date's week is **malformed** — it returns no `weekKey` and is flagged, rather than silently taking the start week. One test per branch.

Two smaller points on C6:
- **Section citation.** Per the parent's Phase C hot‑spot map, hours are **SPEC §4** ("§4: capacities and hours") and booking lengths/cutoff are §5 ("§5: D17, D18 and the cutoff"). C6 cites §5 for the hours. Cite both: *"SPEC §4 (opens 5 AM, closes 11 PM, at most midnight) together with §5 (lengths capped at closing) already answer it."* Verify against the file — I could not open SPEC.md.
- Confirm while you are in there that §5 has no overnight/all‑night booking type. If it does, C6 is wrong and this reopens.

---

### 10. SHOULD‑FIX — two round‑1 items dropped in the rewrite

**(a) Reversed pause ranges** (Codex #8: *"reversed ranges once their meaning is specified"*). D‑5's totality matrix is `{no pause / past / current / malformed}`. A pause with `end < start` has two *valid* dates, so it isn't "malformed" under parent rule 7, and `start ≤ today ≤ end` is false, so it falls through to rule 10 → **`active`**. That is almost certainly wrong and is silent. Suggested addition to D‑5's pause bullet:

> A pause window whose end is before its start is **`review`** (recorded in DATA‑MODEL.md as an extension of rule 7: "missing, malformed, **or reversed**"). One test, plus one row in the totality matrix.

**(b) Retry idempotency in D‑4** (Codex #3: *"Every retry for one scheduled occurrence must … not create an uncontrolled duplicate export"*). D‑4 says *"Each run writes to its own dated folder (`weekly/<timestamp>`), so a retry never overwrites another run."* With `retryConfig` set, that is the *duplicate* Codex warned about — a transient failure after the export has started spawns a second export under a new prefix. Suggested replacement:

> Each occurrence writes to `weekly/<the scheduled time>` — **the scheduled time, not the run time** — so all retries of one occurrence resolve to the same prefix and cannot produce a second export, while different weeks never collide. Before starting, the function checks whether an export operation for this database is already running and exits cleanly if so.

---

## Nits

11. **`D-2` vs `D2`.** The rewrite introduced seven references to the parent's functions‑guard phase (`D2`) inside a plan whose own second phase is `D-2`. Two characters apart, opposite meanings. Write the parent's as **"Phase D2 (the functions guard)"** on every mention — C3, C5, the meta box, D‑4's heading, the Order line.
12. **D‑1 step 5 loses "record whether it was enforceable."** Setting a project‑level org policy needs `orgpolicy.policyAdmin`; if Christie doesn't have it the step silently fails and only step 10 catches the consequence. Add: *"Record whether it could be enforced, or why not."*
13. **D‑2's predeploy refusal sentence is never un‑edited.** D‑2 ships *"…`scripts/deploy-rules.sh` (arrives in D‑3)"*. Add to D‑3 step 1: *"and drop '(arrives in D‑3)' from `predeploy-check.sh`'s refusal sentence."*
14. **The cross‑project scenario refuses one step earlier than stated.** Per the guard design, step 2 is `git rev-parse --verify` and step 3 is the ancestor check; a studio‑hub sha isn't in my‑clay‑hub's object database at all, so it dies at step 2. Reword to *"it refuses at the rev‑parse/ancestor pair — no judgement involved."*
15. **`firebase-deploy-guard.html:133` still says the lock refuses when "another guard, **or an emulator run**, is in flight,"** which is what produced round‑1 Claude #14. The plan checked the script and found only the guard takes it. Correct the design doc in the same commit so this isn't re‑litigated a third time.
16. **D‑4 has no closing "record it" step** — round‑1 Claude #35 asked for D‑3 *and* D‑4. D‑3 step 6 has it; D‑4 doesn't. Add the vault bucket, both identities and the first receipt to the resilience report and memory.
17. **Zero‑receipt acceptance covers "no receipts at all" but not "receipts for one target, none for the other,"** which is the state between the two D‑3 deploys. One extra assertion in the adapted suite.
18. **`firestore:indexes` keeping `RUN_TESTS=0`** is now arbitrary — `npm test` is one command (rules suite + guard suite), so skipping it for indexes saves nothing and creates a third behaviour to remember. Consider `RUN_TESTS=1` for all three, or say in the table why not.
19. **Codex #11 asked for three fallback bucket names**; D‑4 records two. Add `<PROJECT_ID>-vault-exports-<short suffix>`.

---

## Answers

**Q1 — resolved?** 44 of 47. Not resolved: Claude #2 (finding 3, undispositioned and now stronger), Claude #33 / parent amendment (finding 4, noted here but not written there), Codex #5's stale‑test protection (finding 1, implemented in a form that doesn't work), plus two dropped fragments in finding 10.

**Q2 — are C3/C5/C6/C7 sound?** Yes, all four. C3 is the right call and both reviewers independently established the LRO/2xx problem it solves; its cost is that `my-clay-hub` has no off‑project backup until after Phase D2, which is acceptable only because the gate holds — so write the gate down somewhere durable (finding 5). C5's reasoning is correct; its unstated bootstrap is finding 6. C6 checks out against the parent's settings defaults and needs an enforcement hook (finding 9). C7's ISO arithmetic is correct as written. **Does moving pieces out break the parent's Phase D acceptance in a way that matters?** Not materially — all three moved pieces are gated or deferred to a phase that will do them properly — *provided* finding 4 is applied. Without it, a session resuming from the parent reads three acceptance criteria that Phase D no longer meets and cannot tell whether that was a decision or a miss.

**Q3 — Appendix B?** All three are correct; B3 in particular is exactly right against Appendix A §1f. Not sufficient: B1 edits the bullet but not the lead sentence, and a fourth item is needed for the rollback line under the SAFE DEPLOY PATTERNS table (finding 8). With those, I found nothing else left single‑project across A + B.

**Q4 — new problems?** Findings 1, 2, 6, 7, 9 and 11 are all introduced or newly exposed by the rewrite. Finding 1 is the one that ships a security control that silently doesn't do its job.

---

**Verdict: ready after fixes.**

The shape is right and materially better than round 1 — the three Codex blockers and Claude's blocker are all genuinely closed, and C3 in particular converts a "monitor the thing that can't be monitored" design into an honest one. Fix finding 1 (or confirm `predeploy-check.sh` already compares by tree oid, in which case it's a nit), findings 2–9, and the two dropped fragments in 10, and this is execution‑ready. The nits can be folded in or dropped on Christie's judgement.

One caveat to weigh, the same one round 1 carried: I could not open `~/studio-hub/scripts/*` or `~/my-clay-hub/docs/**`. Findings 1 and 14 need checking against `predeploy-check.sh` and `deploy-rules.sh`, and finding 9's section numbers against SPEC.md, by a session that can read them — which D‑3 already requires ("checked line by line against `deploy-rules.sh`, `predeploy-check.sh` and `deploy-rules.test.sh` when the work starts").
