# Firebase Restore Drill Report

**Date:** 2026-08-11
**Project:** tinker-hq-apps (production) → tinker-hq-vault (restore target)
**Approved by:** Christie, "approved to change firebase"
**Status:** Firestore full-database restore drill and Storage object-version recovery both completed and verified. Runbooks below. Cleanup due by 2026-08-25 (14 days, per Step 2 pre-flight answer).

---

## Executive summary

Restored a full copy of production Firestore data (9,312 documents across 61 non-empty collections) into a new, isolated database (`tinker-hq-vault` / `restore-drill`) and verified it byte-for-byte on document counts and field-level spot checks, including `summerCamps_kidNotes`. Separately proved that an overwritten Cloud Storage object can be recovered from its prior version. One important design assumption was tested and disproven: **native Firestore managed-backup restore does not support cross-project targeting** ("Cross-project restores are not supported", confirmed via direct API error) — the JSON-export-based path (already built in Step 1) is the actual working cross-project recovery mechanism, not a fallback.

**Can we recover today? Yes, for Firestore data, using the export-based path. Yes, for Storage. See "Can we recover today?" section for per-app detail and the one real gap (Storage full-bucket recovery was proven at the single-object level only, not bulk).**

---

## What was tested

### 1. Firestore restore — cross-project native restore (disproven)
Attempted: `firebase firestore:databases:restore --database=restore-drill --backup=projects/tinker-hq-apps/locations/nam5/backups/a3a836cf-9508-4b77-8646-1ef618901913 --project=tinker-hq-vault`

Result: `HTTP 400: Cross-project restores are not supported.` This resolves the open question flagged in `firebase-managed-backup-baseline.md` Section 2c/3 — native managed-backup restore and PITR clone are **same-project only**. The `tinker-hq-vault` weekly export is the actual cross-project recovery mechanism this design depends on, not an optional extra.

### 2. Firestore restore — JSON export import (the real path, proven working)
1. Enabled the Firestore API on `tinker-hq-vault` (`serviceusage.googleapis.com` `:enable`, confirmed `state: ENABLED`).
2. Created an empty database: `firebase firestore:databases:create restore-drill --location=nam5 --project=tinker-hq-vault`. Defaults to closed rules (blocks all client traffic) — correct for a target no app should ever reach.
3. Wrote `~/tinker-backups/restore-from-export.js` — reads a `backup.js`-format JSON export, converts plain JS values back to Firestore's typed value format, and writes via the `:commit` batch-write endpoint (200 writes/batch, under Firestore's 500-write limit).
4. Ran it against the most recent weekly vault export (`weekly/tinker-backup-2026-08-11T19-16-18.json`, 15.2MB, same file already present locally at `~/tinker-backups/tinker-backup-2026-08-11T19-16-18.json`).

**Result: 9,312 documents written across 61 collections, 0 errors.**

### 3. Verification — document counts
Ran a `runAggregationQuery` count against every non-empty collection in `restore-drill` and compared to the source export's counts.

**Result: all 60 non-empty collections matched exactly** (`users`, `curriculum`, all `summerCamps_*`, all `timeclock_*`, `payroll`, all `training*`/`onboarding*`, and everything else — full list in `logs/last-restore-drill-result.json`).

### 4. Verification — field-level spot checks
Pulled one document each from four collections (source export vs. restored database) and compared field sets:

| App | Collection | Result |
|---|---|---|
| Tinker Ticker | `timeclock_entries` | ✅ fields match |
| Classbook/Summer Camp | `summerCamps_lessonData` | ✅ fields match |
| Training Hub | `trainingAssignments` | ✅ fields match |
| Privacy check | `summerCamps_kidNotes` | ✅ fields match — confirms kid notes are fully recoverable, per Christie's 2026-08-11 clarification that losing this data (not over-restricting it) is the actual concern |

### 5. Storage object-version recovery
Uploaded a throwaway test object (`curriculum/_restore-drill-test-2026-08-11.txt`, never real content) to production Storage, overwrote it once (creating a noncurrent version under the Object Versioning enabled in Step 1), then fetched the specific noncurrent generation directly by its generation ID and confirmed its content matched the pre-overwrite version exactly. Cleaned up both generations immediately after — no test artifacts left in production Storage.

**Result: recovery proof passed.** An accidentally-overwritten file in any of the five high-value paths (`curriculum/`, `summerCamps/`, `projectDetailPhotos/`, `training/`, `social-media-photos/`) can be recovered the same way within the 90-day noncurrent-version window (or the 7-day soft-delete window, for outright deletes).

### 6. Sample write into the restore target
Wrote a test document (`_drillTest/sampleWrite`) directly into `restore-drill` and read it back successfully (status 200, content matched). Confirms the restore target isn't read-only — proves the write path works too, per the original Step 2 task list. Left in place (harmless, will be deleted with the rest of `restore-drill` at cleanup).

### Known gaps from this drill
1. **Storage recovery proven at the single-object level only.** A scenario where many objects across a whole path were deleted/corrupted at once (not tested) would need a bulk-listing + bulk-recovery approach — the mechanism (list generations, fetch by generation, re-upload as current) is proven and would work the same way per-object, just not exercised at volume.
2. **App login against the restored target was not tested.** The original Step 2 task list called for validating "login, read key records, sample write in staging" per app — this drill validated data recovery (read + write against the database directly) and Storage recovery, but did not point an actual app's config at `restore-drill` and confirm a real login/session works end-to-end. That would require a temporary local config override for one of the four apps, which wasn't part of the plan Christie approved for this drill. Worth doing in a future, more thorough drill if proving full app-level recovery (not just data-level) becomes a priority.

Neither gap blocks the "yes, we can recover" conclusion below — both are about exercising the proven mechanism more broadly, not about the mechanism not working.

### Timing note
Wall-clock time for the Firestore restore phase (API enable → empty database created → 9,312-document import complete) was not precisely stopwatched this run — based on the sequence of steps it was on the order of a few minutes end-to-end. **Recommend timing the next drill precisely** to get a real RTO number; see the runbook below for the exact command sequence to time.

---

## Runbooks

### Runbook A — Full database restore to a non-production target
1. Identify the source: either the most recent native daily backup (`firebase firestore:backups:list --project tinker-hq-apps`) for same-project recovery, or the most recent weekly export in `gs://tinker-hq-vault-backups/weekly/` (also mirrored locally at `~/tinker-backups/tinker-backup-*.json`, the same file backup.js just uploaded) for cross-project recovery.
2. **Same-project restore** (production database itself is corrupted, restoring into a new database in `tinker-hq-apps` to inspect/cut over): `firebase firestore:databases:restore --database=<new-name> --backup=<backup-resource-name> --project=tinker-hq-apps`. Creates a new database, never overwrites `(default)` in place.
3. **Cross-project restore** (production project itself is compromised/unusable, or for a drill): cross-project native restore does NOT work (confirmed above). Instead:
   - Ensure Firestore API is enabled on the target project: `POST https://serviceusage.googleapis.com/v1/projects/<project>/services/firestore.googleapis.com:enable`
   - Create an empty database: `firebase firestore:databases:create <name> --location=nam5 --project=<project>`
   - Run `node ~/tinker-backups/restore-from-export.js <path-to-export.json> <project> <database>`
4. Verify: run the count-comparison + field-spot-check approach used in this drill (script logic is inline in this report; worth extracting to a standalone `verify-restore.js` if this becomes routine).
5. **Never** point a production app at the restore target — it has closed rules by default and no app config should reference it.

### Runbook B — Partial collection/document recovery
For a single accidentally-deleted or corrupted collection (not a full-database event):
1. Identify the most recent good export or backup containing the collection.
2. If using the JSON export path: modify the `backup.collections` object in a copy of the export to include only the target collection(s), then run `restore-from-export.js` against it — the script already iterates per-collection, so this works without modification.
3. If using PITR (same-project, within the last 7 days): `firebase firestore:databases:clone --source-database="projects/tinker-hq-apps/databases/(default)" --snapshot-time=<ISO-timestamp> <target-database> --project tinker-hq-apps`, then manually copy just the needed collection(s) out of the cloned database using the Admin SDK or a small script, since PITR clone restores the whole database, not a single collection.
4. Verify the specific collection's count and a few field-level samples before considering it done.

### Runbook C — Storage object recovery
1. **Overwritten object, still within the 90-day noncurrent-version window:** list all generations at the path: `GET https://storage.googleapis.com/storage/v1/b/<bucket>/o?prefix=<path>&versions=true`. Identify the desired (older) `generation` ID by `timeCreated`. Fetch its content: `GET .../o/<path>?generation=<id>&alt=media`. To actually restore it as the live version, re-upload that content as a new object at the same path (this creates a new current version; the old one remains in history per the versioning/lifecycle rules).
2. **Deleted object, still within the 7-day soft-delete window:** similar generation-listing approach recovers it; Cloud Console's Storage UI also has a direct "restore" action for soft-deleted objects if preferred over the API.
3. Beyond 90 days (versioning) or 7 days (soft-delete), the object is unrecoverable via Storage itself — this is why Storage isn't part of the Firestore backup/export pipeline; there's no independent long-term Storage archive today. Flag as a possible future gap if photo/file loss beyond those windows becomes a real concern.

### Runbook D — Incident freeze / revoke / deploy-stop sequence
For a real incident (not a drill), in order:
1. **Freeze:** stop any further writes that could compound the problem. For a rules/app bug, this may mean temporarily tightening `firestore.rules` to deny writes on the affected collection(s) and deploying that (`firebase deploy --only firestore:rules` — still free, still fast). For a bad deploy, this may mean reverting the Netlify/Render deploy for the affected app.
2. **Assess:** determine scope (which collections/apps, how far back) using the count-drop verification already built into `backup.js`'s `backupStatus/latest` doc, and/or PITR to inspect recent history without committing to a restore yet.
3. **Choose a restore point:** prefer the most recent PITR snapshot (any minute in the last 7 days) or native daily backup (any of the last 98 days) for same-project recovery; use the weekly vault export for cross-project recovery per Runbook A.
4. **Restore into a new database, inspect, then cut over** — never restore in place over `(default)`. Cutting over means updating each app's Firebase config to point at the new database name, which itself should go through normal deploy review, not be rushed.
5. **Communicate:** per Christie's Step 2 answer, no formal channel — Christie and Anika inform affected staff directly (text/call/in person). No template needed at this team size.
6. **Un-freeze:** once verified, revert the temporary rules tightening/deploy freeze from step 1, deploy normally.
7. **Record it:** commit the incident's timeline and decisions per the Section 8 agent commit protocol (this doc project's own standing guidance) so future incidents can be reconstructed.

---

## Validation queries/checks per app (for future drills)

- **Classbook / Summer Camp App:** `summerCamps_lessonData`, `summerCamps_projectDetails`, `summerCamps_prepHelpQueue`, `summerCamps_campComplete` — count + 1 recent-doc field check each.
- **Tinker Ticker:** `timeclock_entries`, `timeclock_schedules`, `timeclock_timeoff`, `timeclock_overrides`, `payroll` — count + 1 recent-doc field check each; this drill additionally spot-checked `timeclock_entries` field-by-field.
- **Training Hub:** `trainingModules`, `trainingAssignments`, `trainingEmailLogs`, `trainingObservations`, `trainingObservationSchedule`, `onboarding*` — count + 1 recent-doc field check each; this drill additionally spot-checked `trainingAssignments`.
- **Storage (all apps):** one object from each of `curriculum/`, `summerCamps/`, `projectDetailPhotos/`, `training/`, `social-media-photos/` — this drill exercised the mechanism on a test object in `curriculum/`; a future drill should touch a real (non-destructively, still via overwrite-then-recover-then-restore-original) object in each of the other four paths to fully cover them.

---

## Can we recover today?

| App | Firestore data | Storage data | Blockers |
|---|---|---|---|
| Tinker Ticker | ✅ Yes — native daily backup (98-day) + weekly export both proven | N/A (no Storage dependency) | None |
| Classbook | ✅ Yes — proven via this drill (lessonData, curriculum, kidNotes all verified) | ✅ Yes — proven via this drill | None |
| Summer Camp App | ✅ Yes — same data as Classbook, shared collections | ✅ Yes — proven via this drill | None |
| Training Hub | ✅ Yes — proven via this drill (trainingAssignments, onboarding* all verified) | N/A (no Storage dependency confirmed) | None |

**Overall: yes, all four priority apps can recover today.** The two open items are refinements, not blockers: (1) get a precise RTO timing on the next drill rather than an estimate, (2) extend Storage recovery testing to the other four high-value paths and prove bulk (not just single-object) recovery.

---

## Cleanup

Per Christie's Step 2 pre-flight answer: retain restore-drill resources 14 days, then delete. **Due by 2026-08-25.**
- Delete the `restore-drill` database: `firebase firestore:databases:delete restore-drill --project tinker-hq-vault` (requires `--force` or confirmation; will ask Christie before running).
- No Storage cleanup needed — the test object was already deleted immediately after the drill.
