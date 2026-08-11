# Firebase Managed Backup Baseline — Design

**Status: DESIGN ONLY. No Firebase/GCP settings have been changed.**
**Project:** tinker-hq-apps
**Date:** 2026-08-02
**Prepared by:** Claude Code, in design-only mode (per Step 1 of the Firebase Backend Resilience Plan)
**Depends on:** `firebase-current-state-inventory.md` (Step 0, completed 2026-06-26)
**Approval phrase required before any command in this doc is run:** "approved to change firebase"

---

## 0. Pre-flight decisions (resolved today with Christie)

Two items were open in the Step 1 pre-flight table. Both are now resolved:

| Item | Decision |
|---|---|
| Where should the independent backup / restore-drill target live? | Create **one** new project, `tinker-hq-vault` (exact project ID TBD at creation time — GCP project IDs must be globally unique). It does double duty: (a) holds a locked GCS bucket for a periodic off-project export copy, (b) serves as the non-production restore-drill target for Step 2. |
| Retention windows | PITR: 7-day rolling (fixed by GCP, not adjustable). Native managed backup: **DAILY, 98-day (14-week) retention** — the GCP maximum. Off-project export copy: **WEEKLY, keep last 8 + a permanent archive snapshot at the close of each peak season window**. Local `backup.js`: unchanged, ~2-day rolling window as a fast local fallback only — no longer the primary safety net. |

Everything below is built on these two decisions. If Christie wants to change either later, only the commands in Section 6 need to be re-run — nothing else in the design depends on the specific numbers.

---

## 1. RPO/RTO tiers → collection mapping

The four priority apps (and everything else at Tinker HQ) share **one Firestore database** (`(default)`, nam5). This matters: native PITR and the managed backup schedule operate at the *database* level, so **Tier 1, 2, and 3 all get the same native protection automatically, for free** — you cannot back up payroll more aggressively than reproducible catalog data at the native-backup layer. Tiering therefore mainly drives: (a) which collections the independent export script prioritizes and verifies first, (b) which app is restored/validated first in a drill, and (c) alerting sensitivity.

Collection names below are pulled from `/Users/christiehubley/studio-hub/firestore.rules` (the single source of truth) cross-checked against `~/tinker-backups/backup.js` and `summer-camp-app/scripts/backup-firestore.js`.

**Tier 1 — RPO 30 min (Classbook/Summer Camp in-season) / 1 day (Tinker Ticker), RTO ~15 min (peak) / same day**
- Tinker Ticker: `timeclock_entries`, `timeclock_schedules`, `timeclock_timeoff`, `timeclock_overrides`, `timeclock_hfwa`, `timeclock_streaks`, `timeclock_settings`, `payroll`
- Classbook / Summer Camp App teacher content & ops: `summerCamps_lessonData`, `summerCamps_curriculum`, `summerCamps_projectDetails`, `summerCamps_materialsHub`, `summerCamps_schedule`, `summerCamps_projectLibrary`, `summerCamps_stockItems`, `summerCamps_needToOrder`, `summerCamps_prepHelpQueue`, `summerCamps_weeklyPrep`, `summerCamps_settings`, `summerCamps_daysOff`, `summerCamps_team`, `summerCamps_openStudio`, `summerCamps_campComplete`, `curriculum`
- `summerCamps_kidNotes` is operationally Tier 1 (needed same-day) but is handled under a stricter **privacy** rule, not just RPO — see Section 3's privacy carve-out.

**Tier 2 — RPO 30 min (peak) / weekly (off-peak), RTO same day (peak) / flexible**
- Training Hub: `trainingAssignments`, `trainingModules`, `trainingPrograms`, `trainingEmailLogs`, `trainingObservations`, `trainingObservationSchedule`, `onboardingTopics`, `onboardingPeople`, `onboardingSessions`, `onboardingChecklists`

**Tier 3 — reproducible, RPO/RTO flexible**
- `appConfig`/`users` (shared auth/config — reproducible from Firebase Auth + manual re-entry, but small and cheap to include anyway), seed/catalog data for lower-priority apps not in scope for this baseline (materials, supplyList, etc.) — these ride along for free since backups are database-wide, but are not the focus of monitoring or drill prioritization.

**Note found while mapping this:** `summer-camp-app/CLAUDE.md` documents a collection called `summerCamps_materials`; the actual deployed rule (and the two existing backup scripts) use `summerCamps_materialsHub`. No rule exists for `summerCamps_materials`. This looks like a stale doc reference rather than a real second collection — worth a one-line fix in that CLAUDE.md, but out of scope for this backup design.

**Peak windows** (from intake, corrected 2026-08-11): Apr 24–Jun 7, Aug 8–Sep 7, Nov 1–Jan 21 (third window was originally Dec 25–Jan 21; Christie corrected the start date).

---

## 2. Firestore backup design (native, same-project)

### 2a. PITR — target state
Enable Point-in-Time Recovery on the `(default)` database. This extends the built-in version-history window from 1 hour to **7 days** (GCP's fixed maximum for PITR — not configurable higher), letting you recover to any minute-granularity snapshot in that window without a pre-existing backup file.

### 2b. Scheduled backup — cadence and retention
Create one **DAILY** managed backup schedule, retention **98 days (14 weeks)** — the GCP maximum for either daily or weekly recurrence. Daily was chosen over weekly because both cost the same per-GiB rate and Tinker's total Firestore data is small (low hundreds of MB based on `backup.js` output of ~11MB JSON for 7,439 docs across 31 collections); daily gives ~98 recovery points instead of ~14, at a cost difference measured in cents/month.

### 2c. Restore strategy (same project, same-project only — see 2d for cross-project)
Both restore paths create a **new** database — they never overwrite `(default)` in place, which is the safety property you want (inspect before cutting over):

- **From a PITR snapshot** (any minute in the last 7 days):
  `firebase firestore:databases:clone --source-database="projects/tinker-hq-apps/databases/(default)" --snapshot-time="2026-08-01T14:30:00.00Z" tinker-hq-apps-restore-test --project tinker-hq-apps`
- **From a managed backup** (any of the 98 daily snapshots):
  `firebase firestore:databases:restore --database=tinker-hq-apps-restore-test --backup=<backup-resource-name-from-list> --project tinker-hq-apps`

Whether either of these can target `tinker-hq-vault` directly (true cross-project restore) is **not confirmed** — GCP's own docs point to scheduled exports, not managed-backup restore, as "the" cross-project/long-term-archival mechanism (Section 2 will not depend on cross-project native restore working; Section 3's export is the confirmed cross-project path). Step 2 (restore drills) can test cross-project native restore as a bonus and this doc will be updated with the result.

### 2d. Monitoring
- `firebase firestore:backups:schedules:list --database "(default)" --project tinker-hq-apps` and `firebase firestore:backups:list --project tinker-hq-apps` show schedule health and the most recent backup timestamp — this can be run manually or scripted into the `backup.js` upgrade (Section 5) so a stale/failed native backup shows up in the same daily status check as the local export.
- No native "email me if a scheduled backup fails" exists in Firestore itself as of this writing; monitoring is via the CLI check above, folded into the existing alert path in Section 5.

---

## 3. Independent export design (cross-project, `tinker-hq-vault`)

### 3a. Destination
- New project `tinker-hq-vault` (Spark/free plan — no billing required unless storage grows past the free tier, which is extremely unlikely at this data size).
- One GCS bucket in that project, e.g. `gs://tinker-hq-vault-backups`, region `us-central1` (cheapest US region, matches the existing Storage bucket's region).

### 3b. Why this is actually independent
`tinker-hq-apps`'s two service accounts (`firebase-adminsdk-fbsvc`, `tinker-ticker-notification`) hold **no IAM bindings in `tinker-hq-vault`** — because they're never granted any. Firebase/Firestore security rules (which govern every app's normal read/write path) have no reach into a different GCP project's IAM at all. The only identity that can delete anything in `tinker-hq-vault` is whoever GCP makes Owner of that project at creation time — Christie's own Google account. **The rule going forward: never add any `tinker-hq-apps` service account to `tinker-hq-vault` IAM, for any reason.** That single constraint is what keeps this bucket un-deletable by app/deploy credentials.

### 3c. Retention policy
- Weekly export, keep the **last 8** (~2 months rolling).
- At the close of each peak window (Jun 7, Sep 7, Jan 21), retain that week's export permanently as a season archive (small number of files/year, negligible cost).
- Optional hardening (not required to hit the $20/month ceiling, flagging for awareness): a GCS **bucket lock / retention policy** on the archive prefix would make even Christie's own account unable to delete those objects before the retention period expires — true ransomware/fat-finger insurance. Skip for now; revisit if this baseline is later extended to a compliance-driven retention requirement.

### 3d. IAM
- Christie's own Google account: Owner of `tinker-hq-vault` (automatic on project creation).
- No other principal granted access, initially. If the export job later moves to Cloud Scheduler/Cloud Run (Section 5c), that job's auto-provisioned service identity gets exactly `roles/storage.objectCreator` on this one bucket — nothing broader, and never a downloadable key (see 5c for why that matters given the org policy blocking SA key creation).

### 3e. Collection groups exported
Same list as Section 1 (Tiers 1–3), reusing the already-working per-document REST/JSON approach from `backup.js` rather than the native `:exportDocuments` API — see Section 5 for why.

### 3f. Privacy carve-out — `summerCamps_kidNotes` and future "incident reports"
**Kid notes are fully backed up and fully restorable in a real recovery — this section only restricts who sees them in a *practice* drill and where the local copy lives, not whether they're protected.** Per intake: kid notes and incident reports must never leave Google Cloud or be shared outside Christie's direct control, and must never appear in test dumps or restore drills. No collection literally named "incident reports" exists in `firestore.rules` today — the closest current matches are `summerCamps_kidNotes` and `trainingObservations`/`trainingObservationSchedule`; apply the same rule to any future collection that stores incident-style records.

Practical effect on this design:
- Native PITR/managed backups: **include** `summerCamps_kidNotes` (it never leaves the `tinker-hq-apps` project, and only Christie can restore/read it — this satisfies "under Christie's control").
- Off-project export to `tinker-hq-vault`: **include** it too — `tinker-hq-vault` is still Google Cloud, still Christie-owned, so this doesn't violate "never leaves Google Cloud." The one thing this design changes is **local backup.js should stop writing kid-notes content into plaintext JSON files on local disk** going forward (Section 5b) — that's the one copy that could end up in an iCloud/Dropbox sync, an email attachment, or a Time Machine backup Christie doesn't think of as "kid notes storage."
- Restore drills (Step 2): **exclude** `summerCamps_kidNotes` and any future incident-report collection from whatever gets restored into the drill database, or from any data anyone other than Christie looks at during a drill.

---

## 4. Cloud Storage backup/retention design

Target bucket: `tinker-hq-apps.firebasestorage.app` (US-CENTRAL1, regional). High-value paths already confirmed present: `curriculum/`, `summerCamps/`, `projectDetailPhotos/`, `training/`, `social-media-photos/`.

| Setting | Current | Proposed |
|---|---|---|
| Soft-delete | 7 days ✅ | No change — already adequate |
| Object versioning | Disabled ❌ | **Enable** — protects against silent overwrite (same filename, new upload permanently discarding the old version today) |
| Lifecycle rules | None | Add one rule: once versioning is on, expire noncurrent versions after **90 days** (bounds the storage-cost growth versioning otherwise adds indefinitely) |
| Retention policy / bucket lock | None | Not proposed — would block legitimate deletes (e.g., a teacher removing a mis-uploaded photo) |
| Object inventory manifest | None | Add a **monthly** GCS Inventory report (CSV of object name/size/generation) written to the `tinker-hq-vault` bucket — cheap, gives a point-in-time count/size baseline to notice silent large-scale deletion |

Object versioning and lifecycle rules aren't exposed through the Firebase CLI or a `gsutil`/`gcloud` command (neither is installed) — these are one-time toggles in **Cloud Console → Cloud Storage → Buckets → `tinker-hq-apps.firebasestorage.app` → Protection tab**. This is a click-through, not a CLI command; it'll be listed as a Console step in Section 6, not a shell command.

---

## 5. Local `backup.js` → safer operational approach

### 5a. What stays the same
The core technique — read Christie's own Firebase CLI OAuth refresh token from `~/.config/configstore/firebase-tools.json`, hit the Firestore REST API per-collection, write JSON — is sound, already proven (7,439 docs, 9.0s), and needs no service-account key (works within the Google Workspace org policy that blocks SA key creation). Keep it as the base for both the local fallback and the new off-project export.

### 5b. Near-term fixes (script edits, no new infrastructure)
1. **Fix the silent-alert bug.** The `notify()` function's `osascript` call breaks on messages containing certain characters (this is what caused the 14-day outage to go unnoticed Jun 12–26). Replace/augment with a real email: on catch, `fetch()` a transactional-email API (e.g., Resend free tier, ~$0/month at this volume) to `Christie@tinkerartstudio.com` with subject `⚠️ TINKER BACKUP FAILED` (per intake's required subject line). Keep the `osascript` call too as a secondary, non-blocking local alert.
2. **Expand collection coverage** from the current 31 to the fuller list already inventoried in `summer-camp-app/scripts/backup-firestore.js` (or at minimum, the Tier 1/2/3 list in Section 1 of this doc) — the current script misses `payroll`, `bookkeeping`, `hiring`, and others entirely.
3. **Add the off-project upload step.** After writing the local JSON (unchanged), also `PUT` the same file (or a kid-notes-redacted variant, per 3f) to `gs://tinker-hq-vault-backups/weekly/...` via the GCS JSON API, using the same OAuth token already in hand (Storage write requires Christie's account to have Storage Object Creator on that bucket — automatic, she's Owner). Run this step weekly, not every cycle, per the retention decision in Section 0. A separate scheduled invocation (`--mode=weekly-export`) or a day-of-week check inside the script both work; a day-of-week check is the smaller change.
4. **Add a backup-status record.** Write a small `backupStatus` document (e.g., `appConfig/backupStatus` or a new tiny collection) after each successful run: `{lastSuccessAt, docCount, collectionsBackedUp, errors: []}`. This gives any app (or Christie, via Console) a single place to check "is the backup healthy" without opening a JSON file — and gives the native-backup monitoring check from Section 2d somewhere to log alongside it.
5. **Verification, not just counting.** Compare `totalDocs` and per-collection counts against the previous successful run; if any Tier-1 collection's count drops by more than a configurable threshold (>10% in one cycle) without an explicit "bulk delete" flag set, treat it as a possible data-loss event and escalate the alert (this catches the "rules regression → app silently writes fewer docs" pattern already called out in CLAUDE.md, not just "script crashed").

### 5c. Stretch goal — get the job off Christie's Mac entirely
The known gap flagged in Step 0 ("what happens to backups when the Mac is off overnight/weekend") isn't fixed by anything above — the job still only runs when the laptop is awake. The real fix: move the scheduled run to **Cloud Scheduler → Cloud Run (2nd-gen) job**, using Cloud Run's automatically-provisioned service identity. This is the one approach that satisfies the org policy blocking service-account **key** creation, because Cloud Run's identity is attached at runtime by Google — there is never a downloadable key file to create, request, or leak. Grant that identity `roles/datastore.viewer` (read Firestore) + `roles/storage.objectCreator` (write to the vault bucket) and nothing else. Cost: comfortably inside the free tier for a job running a few times a week (Cloud Run/Cloud Functions free tier is 2M invocations/month). This is scoped as a **later** step, not part of this baseline's immediate ask — flagging it here so it's not lost, and because it directly closes a gap this design otherwise leaves open.

---

## 6. Exact commands / configuration to run — NOT YET RUN, awaiting "approved to change firebase"

Everything below is additive and reversible (see "Rollback / no-op" column). Presented as one list; Christie can approve all of it, a subset, or none.

| # | Action | Command / where | Reversible? |
|---|---|---|---|
| 1 | Enable delete protection (carried over from Step 0's P0 recommendation — free, directly relevant here) | `firebase firestore:databases:update "(default)" --delete-protection ENABLED --project tinker-hq-apps` | Yes — `--delete-protection DISABLED` reverts it. Does not touch data. |
| 2 | Enable PITR | `firebase firestore:databases:update "(default)" --point-in-time-recovery ENABLED --project tinker-hq-apps` | Yes — `--point-in-time-recovery DISABLED` reverts it. No data is moved or deleted; this only extends version-history retention going forward. |
| 3 | Create daily managed backup schedule, 98-day retention | `firebase firestore:backups:schedules:create --database "(default)" --recurrence DAILY --retention 98d --project tinker-hq-apps` | Yes — `firebase firestore:backups:schedules:delete <scheduleId>` stops future backups; existing backups already taken are untouched by deleting the schedule. |
| 4 | Create the `tinker-hq-vault` project | `firebase projects:create tinker-hq-vault --display-name "Tinker HQ Vault" --project tinker-hq-vault` (exact ID may need a suffix if `tinker-hq-vault` is already taken globally) | Yes, in the sense that it's a new/empty project — nothing existing is modified. Deleting it later is a 30-day soft-delete in GCP, not instant. |
| 5 | Create the GCS bucket in `tinker-hq-vault` | Console: Cloud Storage → Create bucket → name `tinker-hq-vault-backups`, region `us-central1`, Standard class | Yes — empty bucket, delete anytime. |
| 6 | Enable Storage object versioning on the *production* bucket | Console: `tinker-hq-apps.firebasestorage.app` → Protection tab → enable Object Versioning | Yes — can be turned back off; existing noncurrent versions remain until they age out or are manually deleted. |
| 7 | Add lifecycle rule: expire noncurrent versions after 90 days | Console: same Protection tab → Lifecycle rule | Yes — edit or remove the rule anytime. |
| 8 | Edit `~/tinker-backups/backup.js` per Section 5b (alert fix, expanded collections, weekly vault upload, status doc, verification) | Local file edit, no Firebase state changed until it runs | Yes — plain code change, `git`/file history if desired. Christie should review the diff before it's live since it now also writes to a new destination. |

**No-op if Christie declines everything:** current state persists exactly as documented in the Step 0 inventory — PITR/delete-protection/managed-backups stay off, `backup.js` keeps running as-is, `tinker-hq-vault` is never created. Nothing in this document self-executes.

---

## 7. Cost estimate vs. $20/month ceiling (raised to $30/month on 2026-08-11 — figures below unaffected, still comfortably under either)

| Item | Basis | Estimated cost |
|---|---|---|
| PITR extra version storage | ~$0.00020/GiB-hour (~$0.146/GiB-month); Firestore total data is in the low hundreds of MB | < $0.10/month |
| Daily managed backups, 98-day retention | ~$0.00004/GiB-hour (~$0.029/GiB-month) × ~98 retained snapshots at this data size | Low single-digit dollars/month at worst; likely under $1 given current data volume |
| `tinker-hq-vault` project itself | Free (Spark plan) | $0 |
| GCS bucket in vault, weekly exports, 8 kept + archives | Standard storage ~$0.02/GiB-month; export files are tens of MB | < $0.50/month |
| Storage object versioning + 90-day lifecycle on prod bucket | Depends on churn rate of `curriculum/`, `projectDetailPhotos/`, etc.; unmeasured total bucket size (flagged as a known unknown in Step 0) | Unknown but expected low — recommend checking Storage usage in Console before/after enabling to confirm |
| Monthly GCS inventory report | Negligible — small CSV files | ~$0 |

**Total estimate: comfortably under $5/month**, well inside the $20 ceiling, with the one open unknown being total Storage bucket size (never enumerated because `gsutil`/`gcloud` aren't installed — can be read directly from Firebase Console → Storage → Usage tab without any CLI).

---

## 8. Open items for Step 2 (restore drills) — not part of this deliverable

- Confirm whether native managed-backup restore actually supports targeting a different project, or whether `tinker-hq-vault`'s Firestore database must be populated via the exported JSON instead (Section 2c/3 already assume the latter as the confirmed path).
- Build the actual restore-from-export script (`~/tinker-backups/restore-lesson-data.js` exists for one collection only; no general-purpose restore runbook exists yet).
- Decide exactly which collections get restored into `tinker-hq-vault` for a drill (excluding `summerCamps_kidNotes` per Section 3f) and who validates the result (Christie, per intake, for all four apps).
- Verify total Cloud Storage bucket size/count (Console → Storage → Usage) to firm up the cost estimate in Section 7.

---

## Implementation evidence

**Executed 2026-08-03, after Christie's "approved to change firebase."** Items 1–4 and 8 from Section 6 are done. Items 5–7 need one Console pass from Christie (no CLI installed for Cloud Storage bucket/lifecycle settings) — see the walkthrough posted in chat and mirrored in the plan doc.

| # | Action | Result |
|---|---|---|
| 1 | Delete protection | ✅ `firebase firestore:databases:update "(default)" --delete-protection ENABLED --project tinker-hq-apps` → confirmed via `firestore:databases:get`: `Delete Protection State: DELETE_PROTECTION_ENABLED` |
| 2 | PITR | ✅ `firebase firestore:databases:update "(default)" --point-in-time-recovery ENABLED --project tinker-hq-apps` → confirmed: `Point In Time Recovery: POINT_IN_TIME_RECOVERY_ENABLED`, `Version Retention Period: 604800s` (7 days) |
| 3 | Daily managed backup schedule | ✅ `firebase firestore:backups:schedules:create --database "(default)" --recurrence DAILY --retention 98d --project tinker-hq-apps` → created `projects/tinker-hq-apps/databases/(default)/backupSchedules/e450c608-7a1c-454f-9690-bec7c0f0df90`, confirmed via `schedules:list`: `Retention: 8467200s` (exactly 98 days), `Recurrence: DAILY`. First automatic snapshot expected within ~24h of creation. |
| 4 | Create `tinker-hq-vault` project | ✅ `firebase projects:create tinker-hq-vault --display-name "Tinker HQ Vault"` → Project ID `tinker-hq-vault` was available as-is (no suffix needed). Firebase Console: https://console.firebase.google.com/project/tinker-hq-vault/overview |
| 5 | Create GCS bucket in `tinker-hq-vault` | ✅ Done 2026-08-11 — `tinker-hq-vault-backups`, us-central1, Standard class. Required linking the same existing billing account already used by `tinker-hq-apps` first (new GCP projects need billing enabled before Cloud Storage works at all) — no new card, same account. |
| 6 | Enable Storage object versioning (prod bucket) | ✅ Done 2026-08-11 |
| 7 | 90-day noncurrent-version lifecycle rule | ✅ Done 2026-08-11 — see correction note below; Google's UI initially created an extra rule that would have defeated this. |
| 8 | `backup.js` upgrade | ✅ Rewrote `~/tinker-backups/backup.js`: fixed the `notify()` shell-quoting bug (now uses `execFileSync` with an argument array, no shell involved); expanded `COLLECTIONS` from 31 to all 67 top-level collections verified against `studio-hub/firestore.rules`; added `checkForDataLoss()` — Tier-1 count-drop verification at **>10%** threshold (per Christie's review comment, changed down from the initially-proposed 20%); added `sendEmailAlert()` via Resend (no-ops cleanly until an API key is supplied — see "Outstanding" below); added `writeBackupStatus()` writing to a new `backupStatus/latest` doc. |

**Rules change required for item 8:** added a `backupStatus/{docId}` rule (manager+ only, mirrors the existing `quickNotes_settings` pattern) to `studio-hub/firestore.rules`. Ran `cd ~/studio-hub && npm test` first — all 29 tests passed — then deployed with `firebase deploy --only firestore:rules`. Deploy succeeded.

**Verification run:** `node ~/tinker-backups/backup.js --force` (2026-08-03T13:23) completed successfully — 67/67 collections fetched, **8,998 total docs**, 14.7s. No data-loss warnings fired (expected — first run against the new 67-collection baseline, nothing to regress against yet for the newly-added collections). Vault upload attempted and failed with a clean, expected 404 ("bucket does not exist") — will start succeeding automatically once item 5 is done, no further script changes needed. Confirmed `backupStatus/latest` was written correctly via a direct Firestore REST read: `lastSuccessAt`, `docCount: 8998`, `collectionsBackedUp: 67`, `errorCollections: []`, `dataLossWarningCollections: []`.

**Items 5–7 completed 2026-08-11.** Two real issues surfaced during that Console walkthrough and were caught and fixed the same day:

1. **`invalid_rapt` re-auth recurrence.** The exact stale-OAuth error that caused the original 14-day outage in June came back — both the Firebase CLI session and `backup.js`'s stored refresh token had gone stale. Checked `~/tinker-backups/logs/backup.log`: local backups had been silently failing every run since **2026-08-05** (6 days) with `Token refresh failed: ... invalid_rapt`. **Native cloud protections were unaffected** — `firebase firestore:backups:list` (once re-checked post-fix) showed a continuous, unbroken run of daily managed backups throughout that entire window, since those run on Google's infrastructure independent of any local login session. Fix: Christie ran `firebase login --reauth` (interactive, browser-based — this specific step has to be done by a human, not automatable), which refreshed the same underlying token file both the CLI and `backup.js` read. Immediately after, `node ~/tinker-backups/backup.js --force` succeeded: 9,312 docs, and — for the first time — the weekly vault upload succeeded too, confirming the bucket and IAM setup end-to-end.
   - **Watch for this recurring.** If local backups silently stop again, `invalid_rapt` in the log is almost certainly why; the fix is the same one-line reauth command. Worth revisiting the Section 5c stretch goal (Cloud Scheduler/Cloud Run, which doesn't depend on any human login session at all) if this keeps recurring.
2. **Google's default lifecycle setup would have silently defeated the 90-day retention.** When Christie enabled Object Versioning and checked "add recommended lifecycle rules," the Console created **two separate rules**: one with the (adjusted) 90-day noncurrent-age condition, and a second with no day threshold at all ("noncurrent + 1 newer version"). Separate GCS lifecycle rules are evaluated independently — an object is deleted if it matches *any* rule, not all of them (they're OR'd, not ANDed). The day-less rule would have deleted every old version almost immediately (within ~24h), silently overriding the 90-day window before it could ever take effect. Caught by reviewing the Lifecycle tab as instructed; fixed by deleting that rule, leaving only the correct 90-day one.

**Email alerting completed and confirmed 2026-08-11, now covering both Christie and Anika.** Christie signed up for Resend, created an API key, and `~/tinker-backups/alert-config.json` was created. One gotcha: Resend's sandbox mode only allows sending to the exact email address the account signed up with, and it's case-sensitive — the config's `Christie@tinkerartstudio.com` 403'd until corrected to lowercase `christie@tinkerartstudio.com`. Live test send confirmed both server-side (Resend returned HTTP 200) and by Christie directly ("yes i got the email"). No code changes were needed for the initial setup — `sendEmailAlert()` was already written; only the config file was missing.

**Same day, added Anika.** Attempted to add `anika@tinkerartstudio.com` as a second recipient and hit the sandbox-mode 403 again (sandbox only allows the account's own signup address). Turned out `tinkerartstudio.com` was already verified in Resend from ~4 months prior (unrelated to this project), so no DNS work was actually needed — just updated the config: `alertEmail` is now an array of both addresses, `fromEmail` set to `alerts@tinkerartstudio.com` (Resend's API accepts an array for `to` natively, so `sendEmailAlert()` needed no code change, only the config). Live test confirmed delivery to both recipients, and a full `backup.js --force` run confirmed nothing broke with the new config shape.

**Correction to an earlier claim in this doc:** desktop (Mac) notifications were previously described as "fixed and confirmed working" — that was inaccurate. The shell-quoting crash bug in `notify()` genuinely is fixed (it no longer throws), but Christie confirmed she never actually saw or heard a live test notification, and doesn't have a "Script Editor" entry in System Settings → Notifications either (the identity that guidance assumed, which appears to not apply on her macOS version/setup). This was deprioritized rather than debugged further, since email alerting — now confirmed working — doesn't depend on any of that macOS-specific ambiguity and was the higher-value channel anyway. Tracked as an open, low-priority item in the plan doc (Step 1b) if it's worth revisiting later.

**How to verify going forward:**
- `firebase firestore:backups:list --project tinker-hq-apps` should show one new backup per day.
- Firebase Console → Firestore Database → Data → `backupStatus` → `latest` should show a `lastSuccessAt` from today's business hours.
- `tail ~/tinker-backups/logs/backup.log` should show recent ✅ lines with no `WARNING`/`FAILED` entries — if `invalid_rapt` appears, run `firebase login --reauth`.
- `gs://tinker-hq-vault-backups/weekly/` (via Console → Cloud Storage) should gain one new file roughly every 6 days.

## Change log

- 2026-08-02 — Initial design-only draft. Pre-flight items resolved with Christie (single `tinker-hq-vault` project; daily/98-day native backup + weekly/8-kept off-project export). No commands executed.
- 2026-08-03 — Christie reviewed the plan-doc version of this deliverable in the browser, left 8 clarifying comments (all answered inline in the plan doc), and requested the data-loss threshold be changed from 20% to 10%. Approved with "approved to change firebase." Items 1–4 and 8 executed and verified; items 5–7 remain as a Console walkthrough for Christie.
- 2026-08-11 — Christie completed items 5–7 via the Console walkthrough. Caught and fixed two issues along the way: a recurrence of the `invalid_rapt` re-auth bug (6-day silent local-backup gap, native backups unaffected) and a Google-default lifecycle-rule setup that would have silently defeated the 90-day retention. **Step 1 is now fully complete**, all 8 items done and verified end-to-end (including the first successful weekly vault upload). Same day: added Step 1b (Operational hardening) to the plan roadmap. Resend email alerting set up, tested, and confirmed received by Christie. Desktop notification reliability found to be unconfirmed/likely broken and deprioritized in favor of email. Cloud Scheduler/Cloud Run (removing dependence on Christie's personal login session) explicitly parked at her request — not to be started without her go-ahead.
- 2026-08-11 (later same day) — Worked through 8 review comments on the original global intake table. Corrections: third peak window changed from Dec 25–Jan 21 to Nov 1–Jan 21; budget ceiling raised $20→$30/month; kid notes (`summerCamps_kidNotes`) reclassified as not especially sensitive per Christie — now included in restore-drill validation (was previously going to be excluded); confirmed branch protection and secret scanning are both unavailable on the current GitHub org plan (Free, private repos — `gh api` returns 403). Also fixed a stranded-work gap: the `firestore.rules` `backupStatus` change from Step 1 was live in production since Aug 3 but never committed to git — committed and pushed (studio-hub `68ba4bb`). Step 2 pre-flight clarifications fully resolved (14-day restore-drill retention, informal incident comms). Cross-referenced the "allowed without asking" resource-creation policy for Christie — confirmed it predates this session; Christie confirmed she wants to keep batch-approval (propose full list, approve once, execute all, report back) rather than per-command confirmation.
- 2026-08-11 (evening) — Anika added to email alerts. Initially thought this needed Resend domain verification (new DNS records), but Christie discovered `tinkerartstudio.com` was already verified in Resend from ~4 months prior — no DNS work needed. Updated `alert-config.json` (array of both addresses, `fromEmail: alerts@tinkerartstudio.com`); no code change required since Resend's API accepts an array natively. Live test confirmed delivery to both; full `backup.js --force` run confirmed no regression.
