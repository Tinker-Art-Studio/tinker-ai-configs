# Firebase Current State Inventory
**Project:** tinker-hq-apps  
**Inventory date:** 2026-06-26  
**Conducted by:** Claude Code (read-only; no production changes made)  
**Continuity owner:** Christie Hubley (Christie@tinkerartstudio.com) — primary  
**Alternate:** Anika — designated; no independent access confirmed  

---

## Executive Summary

The `tinker-hq-apps` Firebase project has **no cloud-native disaster-recovery protection** for Firestore. Point-in-time recovery is disabled, delete protection is disabled, and there are zero GCP-managed backup schedules. The sole recovery mechanism is a local backup script (`~/tinker-backups/backup.js`) running on Christie's Mac — it ran successfully today but suffered a **14-day outage** (Jun 12–26) due to a token-refresh failure. If Christie's Mac is lost, all backups are lost with it.

Cloud Storage has a 7-day soft-delete window (good) but no object versioning or lifecycle rules. IAM is clean: one human owner (Christie), two service accounts with no user-managed keys. Auth is email/password only, MFA disabled. App Check is not configured on any app.

**Highest-risk items:**
1. No PITR, no cloud backups — Firestore data has a ~14-day blind spot and no granular recovery point
2. Local-only backups — Mac failure = total backup loss
3. MFA disabled for the sole Owner account
4. Delete protection disabled — database can be dropped with one API call

---

## Firestore DR

### Database configuration
```
firebase firestore:databases:get "(default)" output (2026-06-26):

Name:                      projects/tinker-hq-apps/databases/(default)
Create Time:               2026-02-13T14:58:07.244238Z
Last Update Time:          2026-02-13T14:58:07.244238Z
Type:                      FIRESTORE_NATIVE
Edition:                   STANDARD
Location:                  nam5 (US multi-region)
Delete Protection State:   DELETE_PROTECTION_DISABLED   ← risk
Point In Time Recovery:    POINT_IN_TIME_RECOVERY_DISABLED   ← risk
Earliest Version Time:     2026-06-26T19:01:56.263483Z
Version Retention Period:  3600s (1 hour — built-in, not PITR)
```

**PITR: DISABLED.** Firestore keeps only the last 1 hour of version history (the built-in floor). A bad write or accidental deletion older than ~60 minutes is unrecoverable without a backup file.

**Delete protection: DISABLED.** The database can be dropped via API or Console with no additional confirmation step.

### GCP-managed backup schedules
```
firebase firestore:backups:schedules:list output:
  No backup schedules for database (default) found.

firebase firestore:backups:list output:
  No backups found.
```

Zero cloud-managed backups exist. There are no GCS export destinations and no automated backup jobs registered in Firestore.

### Local backup (Christie's Mac)
**Script:** `~/tinker-backups/backup.js`  
**Scheduler:** LaunchAgent `com.tinkerhq.classbook-backup` — runs every 3600s (1 hour), M–F 8am–6pm only (enforced inside script)  
**Storage:** `~/tinker-backups/` — local disk only, no off-site copy  
**Retention:** Last 96 files (≈2 days of hourly weekday snapshots)  

**Collections covered (31 of ~45+ total in the project):**
- summerCamps_lessonData, summerCamps_curriculum, summerCamps_projectDetails, summerCamps_materialsHub, summerCamps_schedule, summerCamps_projectLibrary, summerCamps_stockItems, summerCamps_needToOrder, summerCamps_prepHelpQueue, summerCamps_weeklyPrep, summerCamps_settings, summerCamps_notesNextYear, summerCamps_daysOff, summerCamps_team, summerCamps_openStudio, summerCamps_campComplete, summerCamps_kidNotes
- timeclock_schedules, timeclock_streaks, timeclock_settings, timeclock_timeoff, timeclock_overrides, timeclock_hfwa, timeclock_entries
- trainingAssignments, trainingModules, trainingPrograms, trainingEmailLogs
- curriculum, appConfig, users

**Collections NOT covered (examples):** payroll, bookkeeping, hiring, privateEvents, meetings, materials, supplyList, staffDirectory, playbooks, clayHub_*, quickNotes, scheduleData, onboarding*, socialMedia_*, rosterManager

**Most recent successful backup:** `tinker-backup-2026-06-26T19-04-04.json` — 7,439 docs, 9.0s  
```
[2026-06-26T19:04:04.980Z] ✅ Backup complete: tinker-backup-2026-06-26T19-04-04.json (7439 docs, 9.0s)
```

**Prior successful backup:** `tinker-backup-2026-06-12T22-51-37.json` (Jun 12, 2026 16:51 local)

**Backup gap:** Jun 12 → Jun 26 = **14 calendar days** with no successful backup.  
Cause confirmed in `backup-error.log`:
```
Token refresh failed: {"error":"invalid_grant","error_description":"reauth related error (invalid_rapt)",...}
```
This matches the Firebase CLI auth outage noted in memory (fixed Jun 26). The LaunchAgent was running silently every hour; the script failed immediately at token refresh without alerting (the `osascript` notification also failed due to quoting issue in the error message).

**Restore target:** `~/tinker-backups/restore-lesson-data.js` exists; no tested restore runbook for other collections. No staging project to restore into.

---

## Storage DR

### Bucket
```
Storage API output (2026-06-26):

Name:         tinker-hq-apps.firebasestorage.app
Location:     US-CENTRAL1 (regional — not multi-region)
StorageClass: REGIONAL
Created:      2026-02-24T21:28:25.618Z
```

### Protection status
| Feature | Status | Detail |
|---|---|---|
| Soft-delete | ✅ Enabled | 7 days (604800s), effective since bucket creation |
| Object versioning | ❌ Not enabled | `versioning: undefined` — no version history |
| Lifecycle rules | ❌ None | `lifecycle: undefined` |
| Retention policy | ❌ None | `retentionPolicy: undefined` |
| Uniform bucket-level access | ✅ Enabled | Locked 2026-05-25 (immutable now) |
| Public access prevention | inherited | Not explicitly enforced |

**Soft-delete means:** objects deleted in the last 7 days can be recovered via the Storage Console or API. Beyond 7 days, a deleted file is gone.

**No object versioning:** overwriting a file (e.g., uploading a new photo with the same path) permanently discards the previous version. There is no version history.

### High-value paths confirmed present
```
Storage top-level prefixes (2026-06-26):
["curriculum/","projectDetailPhotos/","social-media-photos/","summerCamps/","training/"]
```
All four high-value paths from the plan are confirmed: `curriculum/`, `summerCamps/`, `projectDetailPhotos/`, `training/`. No estimate of total object count or size was retrieved (read-only, no enumeration).

---

## IAM / Service Accounts

### Project-level IAM bindings
```json
Source: cloudresourcemanager.googleapis.com/v1/projects/tinker-hq-apps:getIamPolicy (2026-06-26)

roles/owner:
  user:Christie@tinkerartstudio.com

roles/firebase.sdkAdminServiceAgent:
  serviceAccount:firebase-adminsdk-fbsvc@tinker-hq-apps.iam.gserviceaccount.com
  serviceAccount:tinker-ticker-notification@tinker-hq-apps.iam.gserviceaccount.com

roles/firebaseauth.admin:
  serviceAccount:firebase-adminsdk-fbsvc@tinker-hq-apps.iam.gserviceaccount.com

roles/iam.serviceAccountTokenCreator:
  serviceAccount:firebase-adminsdk-fbsvc@tinker-hq-apps.iam.gserviceaccount.com

roles/storage.admin:
  serviceAccount:firebase-adminsdk-fbsvc@tinker-hq-apps.iam.gserviceaccount.com

roles/firebase.managementServiceAgent:
  serviceAccount:service-929945075847@gcp-sa-firebase.iam.gserviceaccount.com  (system)

roles/firebaserules.system:
  serviceAccount:service-929945075847@firebase-rules.iam.gserviceaccount.com  (system)

roles/firebasestorage.serviceAgent:
  serviceAccount:service-929945075847@gcp-sa-firebasestorage.iam.gserviceaccount.com  (system)

roles/firestore.serviceAgent:
  serviceAccount:service-929945075847@gcp-sa-firestore.iam.gserviceaccount.com  (system)
```

**Human accounts with production access:**
- Christie@tinkerartstudio.com — sole **Owner** (full control of everything)
- No other Editor or Viewer bindings — good

**Service accounts (user-created):**

| Account | Role(s) | User-managed keys |
|---|---|---|
| `firebase-adminsdk-fbsvc@tinker-hq-apps.iam.gserviceaccount.com` | sdkAdminServiceAgent, firebaseauth.admin, serviceAccountTokenCreator, storage.admin | **None** ✅ |
| `tinker-ticker-notification@tinker-hq-apps.iam.gserviceaccount.com` | sdkAdminServiceAgent | **None** ✅ |

**No user-managed service account keys exist.** This is the correct posture given that the Google Workspace org policy blocks SA key creation.

**Note on `serviceAccountTokenCreator`:** The firebase-adminsdk SA can impersonate other service accounts. If it were ever compromised, it could mint tokens for any SA in the project. This is a standard Firebase SDK role and is not removable without breaking Firebase functionality.

**Who can create SA keys:** Per intake, blocked by Google Workspace org policy. Christie is Owner but the policy override is at the org level. This is confirmed — no keys exist.

---

## Auth / App Check

### Firebase Auth
```
Source: identitytoolkit.googleapis.com/admin/v2/projects/tinker-hq-apps/config (2026-06-26)
```

**Sign-in providers enabled:** Email/password (only)  
**MFA state: DISABLED** — no second factor for any user, including Christie's admin account  
**Authorized domains:**
```
localhost
tinker-hq-apps.firebaseapp.com
tinker-hq-apps.web.app
tinker-hq.netlify.app
```
Note: Authorized domains are only enforced for OAuth redirect/popup flows. Email/password sign-in is not domain-restricted, which is why the 20+ other Netlify apps work without being listed. If any OAuth provider (Google, GitHub, etc.) is ever added, all app domains would need to be listed first.

**Email privacy:** Improved email privacy enabled (prevents user enumeration).

### Registered Firebase apps
```
firebase apps:list output:
  Recap  |  1:929945075847:web:cdcfee87ad9ce402fcb822  |  WEB
  (1 app total)
```
Only "Recap" is formally registered as a web app in Firebase. All other apps (Classbook, Summer Camp App, Tinker Ticker, Training Hub, etc.) use the Firebase SDK via the project config but are not registered as distinct Firebase App records.

### App Check
**Status: Not configured.**  
The App Check REST API returned 404 for the only registered app. This means no app has App Check enabled or in monitoring mode. Any device or script that knows a valid Firebase API key can make Firestore and Storage requests directly against the project, subject only to Firestore/Storage security rules.

---

## Rules / Deploy Posture

### Firestore rules
**Single source of truth:** `/Users/christiehubley/studio-hub/firestore.rules`  
**Lines:** 734  
**Last deployed:** Jun 3, 2026 (added `trainingObservationSchedule` rule per memory)  
**Collections with explicit rules:** 45+ — no catch-all allow exists; default is deny  
**Deploy command (safe):** `firebase deploy --only firestore:rules` from `/Users/christiehubley/studio-hub/`  

Notable posture:
- Finance collections (payroll, bookkeeping) locked to manager+; no override path exists
- `materials` collection is intentionally fully public (no auth required)
- Delete protection is consistently scoped to manager+ for all collections
- `summerCamps_kidNotes` is readable by any `summer-camp` appAccess user (appropriate but sensitive)

### Storage rules
**File:** `/Users/christiehubley/studio-hub/storage.rules`  
All 5 paths (curriculum/, summerCamps/, social-media-photos/, projectDetailPhotos/, training/) have explicit rules. Default deny is enforced via a catch-all `allow read, write: if false`.  
Note: `social-media-photos/` delete is `allow delete: if request.auth != null` — any authenticated user can delete social media photos; the comment says "manager check handled client-side." This is a rules-level gap.

### Deploy controls
- Netlify deploys: require Christie's explicit approval before each run (enforced by CLAUDE.md)
- Firebase rules deploy: Christie runs from CLI; no branch protection or CI pipeline verified (unknown — see Known Unknowns)
- No staging environment exists yet

---

## Known Unknowns

| Item | Why unknown | How to resolve |
|---|---|---|
| `gcloud` CLI not installed | Not on Christie's PATH | `brew install google-cloud-sdk` or use Cloud Console |
| App Check enforcement level | REST API returned 404 for all paths tried | Check Firebase Console → App Check tab |
| MFA on Christie's Google account | Cannot verify from CLI | Christie checks Google Account security settings |
| Branch protection / secret scanning | Not checked | `gh api repos/Tinker-Art-Studio/<repo>/branches/main/protection` |
| Backup file total size / growth rate | Not measured | `du -sh ~/tinker-backups/*.json` |
| Staging Firebase project | Does not exist | Must be created (Step 0 / Step 1 of resilience plan) |
| What happens to backups when Mac is off overnight/weekend | LaunchAgent is local | No weekend or overnight coverage — gap in RPO |
| Storage total object count and size | Not enumerated | `gsutil du -s gs://tinker-hq-apps.firebasestorage.app` (needs gcloud) |
| `tinker-ticker-notification` SA — what uses it | Not traced | Search codebase for `tinker-ticker-notification` |
| Firebase Hosting configuration | No `hosting` key in firebase.json | Studio Hub serves from Netlify, not Firebase Hosting |

---

## Recommended Immediate Actions

These are ordered by impact. All require Christie's approval before execution ("approved to change firebase" for Firebase/GCP changes).

### P0 — Protect the database (no data movement)
1. **Enable delete protection** on the `(default)` Firestore database.  
   Command (design only, do not run without approval):  
   `firebase firestore:databases:update "(default)" --delete-protection ENABLED`  
   Cost: free.

2. **Enable PITR** on the `(default)` Firestore database.  
   Command (design only):  
   `firebase firestore:databases:update "(default)" --enable-pitr`  
   Cost: ~$0.02/GB/month for the extra version storage. Negligible at this data size.  
   Benefit: granular recovery to any second within the last 7 days.

### P1 — Add a cloud-managed backup schedule
3. **Create a daily GCS backup** via Firestore managed backups.  
   Requires a destination Cloud Storage bucket (new or existing). This is a billable action — needs Christie's approval.  
   Benefit: off-Mac backup that survives a Mac failure.

### P2 — Fix the local backup reliability gap
4. **Add an alert on backup failure** that emails Christie@tinkerartstudio.com directly (the osascript notification was silently broken for 14 days).  
   Can add a `fetch('https://...')` to a free email-relay (e.g., Resend free tier) in the catch block.

5. **Verify the LaunchAgent is loaded** after every Mac restart:  
   `launchctl list | grep tinkerhq` — it shows `- 0 com.tinkerhq.classbook-backup` (loaded, not currently running = normal between fires).

### P3 — Storage versioning
6. **Enable object versioning** on `tinker-hq-apps.firebasestorage.app`.  
   Via Cloud Console → Storage → bucket → Protection tab.  
   Cost: storage for old versions (negligible for images at this scale).

### P4 — Security posture
7. **Enable MFA on Christie's Google/Firebase admin account** — if Christie's account is compromised, the attacker is sole Owner of the entire project.

8. **Fix the social-media-photos delete rule** — currently any authenticated user can delete photos. Change to `isManagerOrAbove()`.

9. **Consider App Check** for Classbook and Summer Camp App — these hold the most sensitive curriculum data. Monitoring mode (not enforcement) would give visibility without breaking anything.

### P5 — Create staging project
10. **Create `tinker-hq-staging` Firebase project** (free Spark plan) as a restore target for drills.  
    This was identified as the next step in the resilience plan (Step 0). Needs Christie's approval to create.

---

*Report generated 2026-06-26 via Firebase CLI + GCP REST API (read-only). No production settings were changed.*
