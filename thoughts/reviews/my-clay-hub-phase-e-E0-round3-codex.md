Reading additional input from stdin...
OpenAI Codex v0.147.0
--------
workdir: /Users/christiehubley/studio-hub
model: gpt-5.6-sol
provider: openai
approval: never
sandbox: read-only
reasoning effort: none
reasoning summaries: none
session id: 01a1211b-b6af-7193-955a-b095629646e0
--------
user
Round 3 of the E-0 review. Your round-2 finding: the comment said an admin's own role/appAccess edit 'can only demote them' / 'no one may grant themselves appAccess', inaccurate for admins. Check fix commit 047a84e (diff below) is accurate against firestore.rules and the plan ~/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html (granted = role admin|manager|staff exactly, active absent/true, appAccess absent or list of strings, and role manager/admin or appAccess contains my-clay-hub). Rule logic must be unchanged. Read-only. End with exactly SAFE TO MERGE or NOT SAFE TO MERGE.
diff --git a/firestore.rules b/firestore.rules
index 2ad2c4a..6e9998d 100644
--- a/firestore.rules
+++ b/firestore.rules
@@ -111,10 +111,10 @@ service cloud.firestore {
     match /users/{userId} {
       // My Clay Hub depends on these (Phase E): the clayhub-link functions read each users doc's
       // role, active and appAccess to decide who is in my-clay-hub's staffRoster (who can use its
-      // /staff screens), and store only name and role there. So no one may raise their own role,
-      // grant themselves appAccess, or change their own active: staff and managers can't touch
-      // any of the three on their own doc; an admin can't change their own active, and changing
-      // their own role or appAccess can only demote them (admins are already granted). name is
+      // /staff screens), and store only name and role there. Staff and managers can't change their
+      // own role, active or appAccess, so they can't put themselves in. An admin can't change their
+      // own active; they can edit their own role and appAccess, but that never gives them more
+      // My Clay Hub access than an admin already has (it keeps it or removes it). name is
       // self-editable and display-only there. Pinned by rules.test.js "Users — fields My Clay Hub
       // relies on"; loosening any of this changes who is staff in My Clay Hub too.
       // Own doc read — all authenticated users (auth guard requires it). Not the reminder bot: its
diff --git a/rules.test.js b/rules.test.js
index b4e5457..f80cb42 100644
--- a/rules.test.js
+++ b/rules.test.js
@@ -911,9 +911,10 @@ describe('Users — appAccess/studios cannot be self-granted (privilege escalati
 
 // ─── USERS — FIELDS MY CLAY HUB RELIES ON (Phase E, E-0) ─────────────────────
 // My Clay Hub's staff roster is decided by users docs' role, active and appAccess (it stores name
-// and role), so no one may raise their own role, grant themselves appAccess, or change their own
-// active. appAccess/studios self-grants are pinned above, archived self-reactivation and an admin's
-// own active below; these pin what wasn't covered.
+// and role), so staff and managers may not change their own role, active or appAccess (an admin's
+// own edits can't add My Clay Hub access an admin doesn't already have). appAccess/studios
+// self-grants are pinned above, archived self-reactivation and an admin's own active below; these
+// pin what wasn't covered.
 describe('Users — fields My Clay Hub relies on (no self-promotion, no self-set active)', () => {
   test('a brand-new user CANNOT self-create as manager', async () => {
     const db = getDb('brand-new-uid-mgr');
codex
I’ll verify the commit’s exact diff, the surrounding rule predicates, and the Phase E plan’s grant definition. I’ll also check that only comments changed and finish with the required verdict line.
exec
/bin/zsh -lc "git show --stat --oneline --decorate --no-renames 047a84e && git show --format=fuller --no-ext-diff --no-renames 047a84e -- firestore.rules rules.test.js && sed -n '70,160p' firestore.rules && rg -n -C 5 \"my-clay-hub|staffRoster|appAccess|active|role\" /Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html" in /Users/christiehubley/studio-hub
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-225rRcXs' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-RTpvgent' (errno=Operation not permitted)
047a84e (HEAD -> mch-e0-users-pins) docs(rules): E-0 review round 2 — an admin's own role/appAccess edit keeps or removes access, never adds it
 firestore.rules | 8 ++++----
 rules.test.js   | 7 ++++---
 2 files changed, 8 insertions(+), 7 deletions(-)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-iVW3GYRJ' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-ecslfi79' (errno=Operation not permitted)
commit 047a84e82c84c327490cac6cca431554b58b0569
Author:     Christie Hubley <christie@tinkerartstudio.com>
AuthorDate: Fri Oct 9 08:40:20 2026 -0600
Commit:     Christie Hubley <christie@tinkerartstudio.com>
CommitDate: Fri Oct 9 08:40:20 2026 -0600

    docs(rules): E-0 review round 2 — an admin's own role/appAccess edit keeps or removes access, never adds it
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/firestore.rules b/firestore.rules
index 2ad2c4a..6e9998d 100644
--- a/firestore.rules
+++ b/firestore.rules
@@ -111,10 +111,10 @@ service cloud.firestore {
     match /users/{userId} {
       // My Clay Hub depends on these (Phase E): the clayhub-link functions read each users doc's
       // role, active and appAccess to decide who is in my-clay-hub's staffRoster (who can use its
-      // /staff screens), and store only name and role there. So no one may raise their own role,
-      // grant themselves appAccess, or change their own active: staff and managers can't touch
-      // any of the three on their own doc; an admin can't change their own active, and changing
-      // their own role or appAccess can only demote them (admins are already granted). name is
+      // /staff screens), and store only name and role there. Staff and managers can't change their
+      // own role, active or appAccess, so they can't put themselves in. An admin can't change their
+      // own active; they can edit their own role and appAccess, but that never gives them more
+      // My Clay Hub access than an admin already has (it keeps it or removes it). name is
       // self-editable and display-only there. Pinned by rules.test.js "Users — fields My Clay Hub
       // relies on"; loosening any of this changes who is staff in My Clay Hub too.
       // Own doc read — all authenticated users (auth guard requires it). Not the reminder bot: its
diff --git a/rules.test.js b/rules.test.js
index b4e5457..f80cb42 100644
--- a/rules.test.js
+++ b/rules.test.js
@@ -911,9 +911,10 @@ describe('Users — appAccess/studios cannot be self-granted (privilege escalati
 
 // ─── USERS — FIELDS MY CLAY HUB RELIES ON (Phase E, E-0) ─────────────────────
 // My Clay Hub's staff roster is decided by users docs' role, active and appAccess (it stores name
-// and role), so no one may raise their own role, grant themselves appAccess, or change their own
-// active. appAccess/studios self-grants are pinned above, archived self-reactivation and an admin's
-// own active below; these pin what wasn't covered.
+// and role), so staff and managers may not change their own role, active or appAccess (an admin's
+// own edits can't add My Clay Hub access an admin doesn't already have). appAccess/studios
+// self-grants are pinned above, archived self-reactivation and an admin's own active below; these
+// pin what wasn't covered.
 describe('Users — fields My Clay Hub relies on (no self-promotion, no self-set active)', () => {
   test('a brand-new user CANNOT self-create as manager', async () => {
     const db = getDb('brand-new-uid-mgr');
        && isActiveUser()
        && ('appAccess' in data)
        && appName in data.appAccess;
    }

    // Studio isolation. Admin always passes. Everyone else must have
    // the studio in their studios array. Needs its own explicit isActiveUser()
    // check — the non-admin branch doesn't route through isAdmin()/isManager()/
    // hasAppAccess() at all, so gating those four alone would miss this one.
    function belongsToStudio(studio) {
      return isActiveUser() && (isAdmin() || studio in getUserData().studios);
    }

    // True if `field` is unchanged by this write: same presence
    // (both missing or both present) and, if present, the same value.
    // Used to pin privilege-bearing fields (role, appAccess, studios)
    // during self-writes to the users collection.
    function fieldUnchanged(field) {
      return (field in resource.data) == (field in request.resource.data)
        && (!(field in resource.data) || request.resource.data[field] == resource.data[field]);
    }

    // True if `field` was not set before this write, or keeps the same value:
    // a first-time set is allowed; changing or removing it once set is denied.
    // (request.resource.data is the whole document after the write.)
    function fieldUnchangedOnceSet(field) {
      return !(field in resource.data)
        || (field in request.resource.data && request.resource.data[field] == resource.data[field]);
    }


    // ═══════════════════════════════════════════════════════════════
    // USERS COLLECTION
    // Self-read/create: always allowed for any authenticated user
    // (required for the auth guard to load the app).
    // Manager+: read all user docs.
    // Self-update: role field must not change.
    // Manager update: cannot change role field, cannot delete.
    // Admin: full create / update / delete.
    // ═══════════════════════════════════════════════════════════════

    match /users/{userId} {
      // My Clay Hub depends on these (Phase E): the clayhub-link functions read each users doc's
      // role, active and appAccess to decide who is in my-clay-hub's staffRoster (who can use its
      // /staff screens), and store only name and role there. Staff and managers can't change their
      // own role, active or appAccess, so they can't put themselves in. An admin can't change their
      // own active; they can edit their own role and appAccess, but that never gives them more
      // My Clay Hub access than an admin already has (it keeps it or removes it). name is
      // self-editable and display-only there. Pinned by rules.test.js "Users — fields My Clay Hub
      // relies on"; loosening any of this changes who is staff in My Clay Hub too.
      // Own doc read — all authenticated users (auth guard requires it). Not the reminder bot: its
      // grant is GET-only below, and this `read` would let an id-constrained LIST through.
      allow read: if isAuthenticated() && request.auth.uid == userId && !isReminderBot();
      // Manager+ reads all user docs (team filters, admin panels, etc.)
      allow read: if isManagerOrAbove();
      // Kiosk: read all users (for PIN lookup)
      allow read: if isKiosk();
      // Reminder bot: GET one doc by uid (the account it is about to email) — never a list.
      allow get: if isReminderBot();

      // Self-create: role must be 'staff' (prevents self-promotion), and
      // appAccess must be absent or empty — app access is granted by an
      // admin/manager via Manage Team, never by the user themselves.
      // studios is NOT locked to empty here: the real bootstrap write (see
      // js/app.js handleAuthStateChange) always sets studios: ['tinker',
      // 'clayhub'] — both known studios, granted to every new user by
      // default — so hasOnly() permits exactly that shape while still
      // blocking a self-create from injecting any value outside the two
      // known studios (there's no smaller "safe default" to enforce here
      // since the app already grants both to everyone; appAccess is the
      // field that actually gates privilege).
      // The reminder bot is a job, not a person: it can never bootstrap a users doc for itself, so it
      // can never become "an active staff user" to isActiveUser()/hasAppAccess().
      allow create: if isAuthenticated()
        && request.auth.uid == userId
        && !isReminderBot()
        && request.resource.data.role == 'staff'
        && (!('appAccess' in request.resource.data) || request.resource.data.appAccess.size() == 0)
        && (!('studios' in request.resource.data) || request.resource.data.studios.hasOnly(['tinker', 'clayhub']));

      // Self-update: role, appAccess, and studios must not change.
      // Without pinning appAccess/studios here, any authenticated staff
      // user could grant themselves access to any app (KPI, Classbook,
      // Payroll-adjacent tools, etc.) with a direct Firestore write that
      // bypasses the Manage Team UI entirely.
      allow update: if isAuthenticated()
        && request.auth.uid == userId
        && !isReminderBot()
        && request.resource.data.role == resource.data.role
        && fieldUnchanged('appAccess')
        && fieldUnchanged('studios')
27-<body>
28-
29-<h1>Plan: My Clay Hub Phase E — the live link from Membership Manager</h1>
30-
31-<div class="meta">
32:  <strong>Goal:</strong> When staff add, edit, pause or offboard a member in Membership Manager, My Clay Hub's own copy of that member (<code>members/{memberId}</code>, with the right derived status) matches within a minute — one way only, carrying only the allowed fields, and safe against late, duplicate or out-of-order deliveries. Staff with My Clay Hub access are mirrored the same way into <code>staffRoster</code>.<br>
33:  <strong>Repos:</strong> <code>/Users/christiehubley/my-clay-hub</code> (the receiving side) and <code>/Users/christiehubley/studio-hub</code> (the sending side: the <code>clayhub-link</code> functions and <code>tinker-hq-apps</code>' own functions guard). Console/IAM work in both projects is Christie's (no gcloud on the Mac; read-only readings by Claude in her Chrome or via Cloud Shell).<br>
34:  <strong>Parent:</strong> <code>clayhub-members-foundation.html</code> Phase E (the outline this plan expands), decisions D2, D4, D4a, D11, D21, D22, D23 and the IAM inventory; <code>firebase-functions-deploy-guard.html</code> (M1, F13, K10, K11, K13, the round-1 "retry approval" finding); <code>my-clay-hub-d4-vault-export.html</code> (the gate).<br>
35:  <strong>Gate:</strong> no real member data enters <code>my-clay-hub</code> until D-4's V-4 is complete (first complete vault export — Sunday Oct 11's scheduled run). Phases E-1 to E-6 build and test with no real data and may run before the gate; <strong>E-7 (deploying the link) waits for it.</strong><br>
36:  <strong>Not in this plan:</strong> any screen, sign-in provider or <code>claimMembership</code> (Phase F); the Tinker HQ tile and the Manage Team <code>my-clay-hub</code> box (Phase F); "change email" in Membership Manager (B4, its own plan); <code>kioskLookup</code>; any write back to Membership Manager (never, D6).<br>
37-  <strong>Risk:</strong> <strong>HIGH.</strong> The first Cloud Functions ever in <code>tinker-hq-apps</code>, the project every staff app shares; real member personal data crossing projects for the first time; IAM changes in both projects, including one Google makes on its own (K13).<br>
38-  <strong>Size:</strong> roughly 2 weeks at the D-4 cadence (several review rounds per PR). Christie's hands-on time ≈ 6–10 h (decisions, Console/IAM steps, approvals, a 3-member spot check).<br>
39-  <strong>Status:</strong> <span class="status-tag ready">execution-ready: true</span> — v4.1, Oct 8, 2026, after four review rounds (round 4: Codex and Claude both "ready after fixes", 0 blocking; all fixes applied). Christie answered Q1–Q9 on Oct 8 (Q7 changed: removed members keep everything but email and phone digits). <strong>Marked execution-ready (all phases) by Christie, Oct 8.</strong> Next: E-pre (its PR review re-checks the Q7 change).
40-</div>
41-
42-<h2>Already decided (not reopened here)</h2>
43-<ul>
44:  <li><strong>D22 "Re-read, then send a snapshot"</strong> (DECISIONS #53): a trigger on <code>clayHub_members/{id}</code> collects the memberId from before and after; for each, one query on <code>memberId</code> only; live = <code>retired !== true</code>; exactly one live doc → its fields; none → tombstone; more than one → conflict, nothing sent, alert. POST <code>{memberId, snapshot, readTime}</code>; ingest drops anything not newer than the stored <code>sourceReadTime</code>, checks the payload strictly, runs <code>deriveStatus</code>, writes, never deletes. The reconcile uses the same envelope, read in one read-only transaction pinned to one readTime. <code>users/{uid}</code> → <code>staffRoster/staff_{uid}</code> the same way (no memberId, no conflict case).</li>
45-  <li><strong>D4 / D4a / #34</strong>: status comes only from <code>shared/derive-status.js</code>; Denver calendar dates; recomputed for everyone daily.</li>
46-  <li><strong>#24</strong>: only <code>phoneLast4</code> leaves <code>tinker-hq-apps</code>, worked out there. <strong>#37 / D6</strong>: never write back. <strong>#42</strong>: IAM one-way; ingest can't delete. <strong>#32 / D2 / M1</strong>: the link is codebase <code>clayhub-link</code> in studio-hub, deployed only by <code>tinker-hq-apps</code>' own functions guard; neither guard can reach the other project. <strong>#54 / D23</strong>: 2nd gen, retries on (<code>retry: true</code> on triggers, retryConfig on schedules), explicit maxInstances, Admin app built once per instance; Firestore <code>nam5</code>, Eventarc location <code>nam5</code>, functions <code>us-central1</code>.</li>
47:  <li><strong>IAM inventory (D11)</strong>: <code>clayhub-link@tinker-hq-apps</code> = a custom read-only Firestore role (get, list) + <code>eventarc.eventReceiver</code>; <code>ingestmemberupdate</code> is <code>invoker</code>: exactly <code>clayhub-link@tinker-hq-apps</code> (declared; the CLI sets it — never granted by hand); <code>ingest@my-clay-hub</code> = custom role get/list/create/update, no delete. Called at the service's exact run.app URL with an OIDC token from the metadata server.</li>
48-  <li><strong>#63 / #64</strong>: the vault gate; Force runs keyed by the day they run (deploys Monday Oct 12).</li>
49-</ul>
50-
51-<h2 id="facts">Facts this plan relies on (research Oct 8; corrected after review round 1)</h2>
52-<table>
53-<tr><th>#</th><th>Fact</th><th>Source</th></tr>
54-<tr><td>F1</td><td><code>clayHub_members</code>: every doc the app writes has a valid <code>memberId</code> (<code>m_</code> + UUID v4; the app can't create a doc without one). The count, 66/66 valid and unique, comes from the dated Sep 28 backup log, not from code. Doc id = email lowercased with <code>/</code> and <code>.</code> → <code>_</code>. <strong>No stored <code>emailLower</code></strong>. Saves write only changed fields; blank top-level fields are stripped.</td><td>clay-hub-membership firebase-data.js:85-94, 155-208; member-status.js:668-682; save-safety plan log</td></tr>
55-<tr><td>F2</td><td>Source fields the link reads (and nothing else): <code>memberId</code>, <code>email</code>, <code>name</code> (one string), <code>phone</code> (free text), <code>stage</code>, <code>scheduledPause</code> (null or one of three shapes), <code>pauseHistory[]</code> (modern <code>startDate</code>/<code>endDate</code> or legacy <code>start</code>/<code>end</code>; may carry <code>priorTerm</code>), <code>scheduledCancellation.finalAccessDate</code>, <code>memberSince</code>, <code>retired</code>. <strong>The pause and cancellation objects also carry <code>notes</code>, <code>type</code>, <code>lastBilling</code>, <code>processDate</code>, Sawyer and audit fields</strong> — never copied (see the contract).</td><td>app.js:500, 550-560, 935-938, 3540-3651, 3761-3774; member-status.js:32-36, 721-725</td></tr>
56-<tr><td>F3</td><td>Never copy: <code>keypadCode</code>, <code>keypadUserId</code>, <code>staffNotes</code>, <code>notes</code>, <code>application</code>, <code>actions</code>, the full phone, the shelf fields, billing fields — at any nesting level.</td><td>save-safety plan, "What My Clay Hub's link needs"</td></tr>
57-<tr><td>F4</td><td>"Change email" (B4) isn't built; nothing writes <code>retired</code> today. Authorized Clay Hub writers can create documents with no rules-level schema or memberId check (so a delete + re-create can carry a new memberId).</td><td>grep; studio-hub firestore.rules:942</td></tr>
58:<tr><td>F5</td><td><code>users/{uid}</code>: the link uses only <code>name</code>, <code>role</code>, <code>active</code>, <code>appAccess</code>. Docs carry other fields too (<code>email</code>, <code>createdAt</code>, <code>pin</code>, …), and admins can write other users' docs, so the rules don't guarantee shapes: the link must fail closed on anything unexpected. Missing <code>active</code> means true. Managers/admins are saved with <code>appAccess: []</code>. The <code>my-clay-hub</code> key doesn't exist yet.</td><td>studio-hub js/app.js:148-155, 1144-1145, 1339-1347; firestore.rules:24-38, 67-73, 111-187</td></tr>
59-<tr><td>F6</td><td><code>deriveStatus(source, todayDenver)</code> needs the <em>source shape</em> (<code>stage</code>, <code>scheduledPause</code>, <code>pauseHistory</code>, <code>scheduledCancellation.finalAccessDate</code>, <code>tombstone</code>, <code>retired</code>). It reads every pause entry including <code>priorTerm</code> ones (intended), and turns an unknown stage, a malformed or missing date, or a non-object pause into <code>review</code>. So malformed values must reach it, as values that are still malformed.</td><td>shared/derive-status.js:6-17, 30-35, 74-80; DATA-MODEL.md:86-88</td></tr>
60-<tr><td>F7</td><td>studio-hub has no functions and no functions guard. Its <strong>rules guard</strong> runs <code>npm test</code> in a worktree and takes <code>firebase.json</code>, <code>package.json</code> and <code>predeploy-check.sh</code> from <code>origin/main</code>'s tip; its backstop accepts only firestore and storage targets; <code>rules.test.js</code> uses the default emulator port 8080 and <code>firebase.json</code> has no emulators block. Anything E-3/E-4 adds there can break every staff app's rules deploy and rollback, and a rules commit made before E-3/E-4 merge must be deployed before they merge (the control files must match the tip).</td><td>studio-hub scripts/deploy-rules.sh:204-209, 348, 406; predeploy-check.sh:22-24; rules.test.js:76</td></tr>
61:<tr><td>F8</td><td>K13: the first event-triggered deploy grants the default Compute account project-wide <code>run.invoker</code> and <code>eventarc.eventReceiver</code>; a failed deploy still enables APIs and creates service agents. The runtime identity of a trigger and the identity that delivers its events are different things. The CLI prompts before enabling retries on an event trigger. K10 pins <code>EVENTARC_CLOUD_EVENT_SOURCE</code> to my-clay-hub.</td><td>firebase-functions-deploy-guard.html</td></tr>
62-<tr><td>F9</td><td>The guard requires UTC schedules with all five retry values declared; an empty invoker list is refused; <code>["private"]</code> means no callers.</td><td>predeploy-check.sh:242-249; deploy-functions.sh:184, 358</td></tr>
63-<tr><td>F10</td><td>One cross-project grant into <code>tinker-hq-vault</code> was accepted (V-1). Organization policies can differ by project, so the <code>run.invoker</code> binding is proven only by E-7's first real call.</td><td>D-4 log, Oct 2</td></tr>
64-<tr><td>F11</td><td>A code search found no staff-app server code using <code>tinker-hq-apps</code>' default Compute account. That is <em>not</em> enough to change a production account: E-5 adds a workload inventory and an audit-log check.</td><td>grep</td></tr>
65-<tr><td>F13</td><td><strong>The pinned CLI (15.22.3) and event triggers:</strong> it sends events <em>as the trigger's own runtime account</em> (<code>eventTrigger.serviceAccountEmail</code> = the function's service account), but sets a Cloud Run invoker only for HTTP-style functions, never for event triggers. On the first event release it adds project-wide bindings: <code>run.invoker</code> and <code>eventarc.eventReceiver</code> for the default Compute account, and Token Creator for the Pub/Sub service agent. So <code>clayhub-link@</code> needs <code>run.invoker</code> on its two trigger services, and nothing in the CLI gives it that (Q9).</td><td>firebase-tools lib/gcp/cloudfunctionsv2.js:214-216; lib/deploy/functions/release/fabricator.js:221-253, 345-389; lib/deploy/functions/checkIam.js:104-160</td></tr>
66:<tr><td>F12</td><td>Firestore IAM can't be limited to one collection: <code>clayhub-link@</code>'s read role covers the whole <code>tinker-hq-apps</code> database (payroll included). Accepted residual: read-only, one runtime, guarded code.</td><td>Firestore IAM model</td></tr>
67-</table>
68-
69-<h2 id="open">Questions for Christie — answered Oct 8</h2>
70-<p class="note"><strong>Christie, Oct 8:</strong> Q1–Q5, Q6 (option B), Q8 and Q9 agreed as recommended; Q7 changed — a removed member keeps everything last known except email and phone digits (row below).</p>
71-<table>
--
91-<tr><td><code>snapshot</code> — rebuilt from allowed keys, never copied and trimmed</td><td>
92-<code>name</code>, <code>email</code>: a string, trimmed, else <code>null</code> · <code>emailLower</code>: <code>email</code> lowercased, or <code>null</code> · <code>memberSince</code>: a valid <code>YYYY-MM-DD</code>, else <code>null</code> · <code>phoneLast4</code>: Membership Manager's own phone rule (<code>formatPhone</code>: 10 digits, or 11 starting with 1) → its last 4, else <code>null</code> · <code>retired</code>: <code>true</code> only if the source is exactly <code>true</code> · <code>stage</code>: one of the six known stages, else <code>"!malformed"</code> · <code>scheduledPause</code>: <code>null</code>, or <code>{startDate, endDate, processed}</code>, or <code>"!malformed"</code> if not an object · <code>pauseHistory</code>: <code>[]</code>, or a list whose entries are <code>{startDate, endDate, priorTerm?}</code> (legacy <code>start</code>/<code>end</code> mapped, the modern value winning) or <code>"!malformed"</code>, or <code>"!malformed"</code> if not a list · <code>scheduledCancellation</code>: <code>null</code>, or <code>{finalAccessDate}</code>, or <code>"!malformed"</code> if not an object · every date: a valid <code>YYYY-MM-DD</code> as-is, missing or <code>null</code> → absent, anything else → <code>"!malformed"</code> (never raw text); the legacy mapping uses a modern value only when it isn't <code>null</code>/missing · <code>priorTerm</code>: present only as <code>true</code> · <code>processed</code>: <code>true</code> when the source <code>scheduledAt</code> is present (a non-empty value — Membership Manager's own test; real values are ISO strings), else <code>false</code> (Q6).</td></tr>
93-<tr><td>Status</td><td>Only <code>deriveStatus</code>. Its precedence stays: a removed/retired record is <code>removed</code> and onboarding/touring is <code>not_yet</code> before any malformed pause data is looked at — so the fixtures are stage-qualified.</td></tr>
94-<tr><td><code>members/{memberId}</code> (stored)</td><td>The snapshot fields + <code>memberId</code>, <code>firstName</code> (first word of <code>name</code>), <code>lastInitial</code> (first letter of the last word, or <code>null</code>), <code>status</code>, <code>statusDate</code> (the Denver date it was derived for), <code>sourceReadTime</code>, <code>updatedAt</code>, <code>tombstone:false</code>.</td></tr>
95-<tr><td><code>memberProfiles/{memberId}</code> (stored; Phase F lets the member read it)</td><td><code>{memberId, firstName, name, email, status, memberSince, pause, finalAccessDate, updatedAt}</code>. <code>pause</code> = the valid, processed window containing today (Denver), else the earliest valid processed window starting after today, else <code>null</code>, as <code>{startDate, endDate}</code>; <code>finalAccessDate</code> only if valid. <strong>No malformed marker and no phone digits ever reach it.</strong> Date-dependent, so the recompute rewrites it too.</td></tr>
96:<tr><td><code>staff</code></td><td><code>{uid, staff: {name, role}}</code> — <strong>sent only for granted users</strong> — or <code>{uid, tombstone:true}</code>. Granted = <code>role</code> exactly <code>admin</code>|<code>manager</code>|<code>staff</code>, <code>active</code> absent or <code>true</code>, <code>appAccess</code> absent or a list of strings, and (role manager/admin, or <code>appAccess</code> contains <code>my-clay-hub</code>). A deleted, ungranted or malformed users doc → a tombstone envelope; malformed also logs an error naming the uid only (it repeats each reconcile until fixed — accepted). Never email, PIN or <code>appAccess</code>.</td></tr>
97:<tr><td><code>staffRoster/staff_{uid}</code> (stored)</td><td><code>{uid, name, role, sourceReadTime, updatedAt, tombstone:false}</code>. The receiver ignores a tombstone for a uid it doesn't hold, so no roster doc is ever created for someone never granted.</td></tr>
98-<tr><td><code>reconcile</code></td><td><code>{scope:'members', items:[member entries], held:[memberId]}</code> or <code>{scope:'staff', items:[granted staff entries]}</code> — the complete set at one readTime. <strong>Sender:</strong> every live source doc needs a valid memberId; a memberId with more than one live doc goes into <code>held</code> (ids only); a live doc with a missing or malformed memberId aborts the whole member reconcile (nothing sent, error logged). <strong>Receiver:</strong> duplicate ids across <code>items</code>/<code>held</code> → 400; <code>held</code> ids are neither updated nor removed and are left out of every denominator; a held record whose <code>sourceReadTime</code> is at or after the batch's readTime is never removed (a newer trigger already landed).</td></tr>
99:<tr><td>Tombstones (stored)</td><td>Replace the document. <code>members</code>: the last stored snapshot fields <strong>minus <code>email</code>, <code>emailLower</code> and <code>phoneLast4</code></strong> (Q7), plus <code>{memberId, firstName, lastInitial, tombstone:true, status:'removed', statusDate, sourceReadTime, updatedAt}</code>; if nothing was ever stored for that memberId, only those last fields. <code>memberProfiles</code>: <code>{memberId, tombstone:true, status:'removed', updatedAt}</code>. <code>staffRoster</code>: <code>{uid, tombstone:true, sourceReadTime, updatedAt}</code>. A later live record replaces it with the full allowlist again. (Vault copies taken earlier keep the email and phone digits until the 56-day retention ages them out — noted in DATA-RESTORE.)</td></tr>
100-<tr><td>Responses</td><td>200 <code>{result: applied|unchanged|stale}</code>; 400 malformed envelope; 409 a reconcile stopped by a threshold. <strong>Terminal for the sender: only 200, 400 and 409</strong> (400 also logs an error: the two repos disagree). Everything else — 401/403/404, 429, 5xx, timeouts — throws, so the trigger is retried.</td></tr>
101-<tr><td>Logging</td><td>Never request bodies, names, emails, phone digits, notes or source documents — only memberId/uid, kind, result and counts.</td></tr>
102-</table>
103-
104-<h2 id="settings">Functions and their settings</h2>
105-<p>All in <code>us-central1</code>, <code>minInstances</code> 0, ingress <code>ALLOW_ALL</code> (as the canary; access is by IAM). The guard checks that every limit is set and that the live service equals the sealed manifest; the values themselves are pinned by a unit test in each codebase (limits aren't in <code>declarations.json</code>).</p>
106-<table>
107-<tr><th>Function</th><th>Project / codebase</th><th>Trigger (declaration)</th><th>Runs as</th><th>timeoutSeconds / memory / cpu / concurrency / maxInstances</th></tr>
108:<tr><td><code>ingestMemberUpdate</code></td><td>my-clay-hub / <code>members</code></td><td>https; invoker <code>[clayhub-link@tinker-hq-apps…]</code></td><td><code>ingest@</code></td><td>120 / 512MiB / 1 / 10 / 3</td></tr>
109:<tr><td><code>recomputeStatuses</code></td><td>my-clay-hub / <code>members</code></td><td>schedule <code>every day 09:30</code>, <code>UTC</code>; retryCount 2, maxRetrySeconds 0, minBackoffSeconds 600, maxBackoffSeconds 1200, maxDoublings 1</td><td><code>ingest@</code></td><td>300 / 256MiB / 1 / 1 / 1</td></tr>
110-<tr><td><code>onClayHubMemberWritten</code></td><td>tinker-hq-apps / <code>clayhub-link</code></td><td>firestore <code>document.written</code>, <code>clayHub_members/{docId}</code>, <code>(default)</code>, <code>nam5</code>, retry true; invoker (Q9) <code>[clayhub-link@]</code></td><td><code>clayhub-link@</code></td><td>60 / 256MiB / 1 / 1 / 5</td></tr>
111-<tr><td><code>onStaffUserWritten</code></td><td>tinker-hq-apps / <code>clayhub-link</code></td><td>firestore <code>document.written</code>, <code>users/{uid}</code>, as above</td><td><code>clayhub-link@</code></td><td>60 / 256MiB / 1 / 1 / 5</td></tr>
112-<tr><td><code>reconcileLink</code></td><td>tinker-hq-apps / <code>clayhub-link</code></td><td>schedule <code>every 6 hours from 01:15 to 19:15</code>, <code>UTC</code>; retryCount 1, maxRetrySeconds 0, minBackoffSeconds 600, maxBackoffSeconds 600, maxDoublings 0</td><td><code>clayhub-link@</code></td><td>300 / 512MiB / 1 / 1 / 1</td></tr>
113-</table>
114-<p class="note">The ingest URL is a hard-coded constant in the sender, tested. A reconcile and a recompute are each one transaction of up to 500 writes: 2 per member plus 1 to consume an override = <strong>249 members</strong>. Both refuse above that (nothing written, error) and alert from 200.</p>
--
117-<div class="note"><strong>Order:</strong> E-pre first, then E-0 (merged <em>and</em> its rules released before E-3/E-4 merge, because the rules guard needs its control files to match <code>main</code>). E-1, E-2 and E-3 can then proceed on separate branches; E-4 needs E-1 and E-3; E-5 before E-6. <strong>E-2 merges only when E-6 can follow within days, and after #64's vault release is attested:</strong> once <code>members/recomputeStatuses</code> is declared on <code>main</code>, any <code>vault</code> or <code>core</code> scheduler attestation fails until that job exists. <strong>E-7 onward waits for every gate</strong> (listed in E-7). Every PR: Codex + Claude implementation review, then Christie's "okay to merge". Every release: that project's guard, <code>--diff</code> pasted, Christie's "approved to change firebase &lt;sha&gt;" for that exact sha and project.</div>
118-
119-<div class="phase">
120-<h3>E-pre — Decisions and the status rule, before any link code <span class="status-tag ready">execution-ready: true</span></h3>
121-<ol>
122:  <li>Christie's answers to Q1–Q9 → DECISIONS rows in my-clay-hub; SPEC.md (§3: the recompute time) and DATA-MODEL.md (the contract, the never-copy list, tombstones; correct "written only by ingestMemberUpdate" — the recompute writes status and profile fields too) in one docs PR.</li>
123-  <li>If Q6 = B: <code>deriveStatus</code> checks a <code>scheduledPause</code> in this order — non-object → malformed (<code>review</code>); object with <code>processed !== true</code> → ignored; otherwise as today (history entries unchanged). Its own small PR in <code>shared/</code>, with tests (processed, unprocessed, malformed container, malformed date with <code>processed:true</code>, legacy) under all three time zones, and its own review — before E-1 freezes the fixtures.</li>
124-</ol>
125-</div>
126-
127-<div class="phase">
128-<h3>E-0 — studio-hub: the users-rules pins <span class="status-tag ready">execution-ready: true</span></h3>
129:<p>A comment on the <code>users</code> rules naming My Clay Hub's dependency (<code>name</code>, <code>role</code>, <code>active</code>, <code>appAccess</code>). Tests only for what isn't covered (rules.test.js already pins self-granted appAccess and studios): role self-promotion on create (<code>manager</code>, <code>admin</code>), and <code>active</code> on self-update. Released through studio-hub's rules guard (free, sha phrase) <strong>before</strong> E-3 or E-4 merge.</p>
130-<div class="bdd">Given a signed-in user with no users doc
131:When they create their own doc with role 'manager' (or 'admin')
132-Then the write is denied
133-
134-Given a staff user
135:When they update their own doc changing active
136-Then the write is denied</div>
137-</div>
138-
139-<div class="phase">
140-<h3>E-1 — The contract as fixtures (both repos) <span class="status-tag ready">execution-ready: true</span></h3>
141-<p>One fixture set — source docs (every forbidden field at every nesting level; both pause spellings; <code>priorTerm</code>; processed and unprocessed pauses; malformed dates, stages, containers and memberIds, each stage-qualified; phones of every shape; users docs granted, ungranted, demoted, malformed; conflicts for <code>held</code>) and the exact envelopes and stored documents they must produce — committed byte-identical in both repos, with a test in each pinning its sha-256.</p>
142-</div>
143-
144-<div class="phase">
145:<h3>E-2 — my-clay-hub: the receiving side (codebase <code>members</code>) <span class="status-tag ready">execution-ready: true</span></h3>
146-<ul>
147:  <li><strong><code>ingestMemberUpdate</code></strong> — <code>member</code>/<code>staff</code>: one transaction: read the target doc(s), apply the gate, derive status from the snapshot's source shape, write <code>members</code> + <code>memberProfiles</code> (or <code>staffRoster</code>), or replace them with tombstones.</li>
148-  <li><strong><code>reconcile</code></strong> — validate the whole batch, then <strong>everything inside one transaction, redone from scratch on a retry</strong>: read every target and any override; for each item apply the gate; <strong>source-driven status change</strong> = <code>deriveStatus(stored source shape, today)</code> ≠ <code>deriveStatus(incoming source shape, today)</code> (both for today's Denver date — never compared with the stored, possibly day-old status); removals = live records held, not in <code>items</code>, not in <code>held</code>, with <code>sourceReadTime</code> older than the batch's readTime; apply Q8 (denominators = live held records minus <code>held</code> ids). Pass → write: a record whose <strong>whole snapshot</strong> is unchanged gets only its <code>sourceReadTime</code> advanced (the reconcile never writes a date-driven status — that's the recompute's, and a recompute stop isn't overridden); a record with any snapshot change (a name or email edit included) gets its new snapshot, status and profile. "Source shape" means only the fields <code>deriveStatus</code> reads and is used only for the status comparison. A tombstoned member who reappears counts as an addition, not a status change. Fail → nothing written, 409, and the log lists the counts and the affected <strong>ids</strong> (no personal data) so Christie can check them.</li>
149-  <li><strong>Overrides</strong> — collection <code>linkOverrides/{id}</code> (deny-all rule and rules test; Console only): exact keys per scope — <code>members</code>: <code>{scope, maxStatusChanges?, maxRemovals?, expiresAt, usedAt: null}</code> with at least one limit (an omitted limit keeps its normal Q8 value); <code>staff</code>: <code>{scope, maxRemovals, expiresAt, usedAt: null}</code>; <code>recompute</code>: <code>{scope, maxStatusChanges, expiresAt, usedAt: null}</code>. Integers 0–249; <code>expiresAt</code> a Timestamp no more than 24 h after the document's own Firestore <code>createTime</code> (refused otherwise); <code>usedAt</code> becomes a server timestamp when consumed. More than one unused, unexpired override for a scope → refuse all of them (error line) rather than choose. An override is used <strong>only when the normal limits would stop the run</strong> and its counts fit it; it's then consumed (<code>usedAt</code>) in the same transaction, and logs an error line naming the override id, scope, limits and counts — so every use emails Christie.</li>
150-  <li><strong><code>recomputeStatuses</code></strong> (09:30 UTC) — <strong>one transaction</strong> over every live member (above 249 → nothing written, error; alert from 200): re-derive status and the profile's <code>pause</code> for today's Denver date; count only <strong>unexplained</strong> changes — a change is explained when a pause start, a pause end + 1 day or a final-access date + 1 day falls after the member's stored <code>statusDate</code> and on or before today (each member stores <code>statusDate</code>, the Denver date its status was last derived for), so a busy 1st never stops it; over Q8's limit → write nothing, error log; otherwise write every changed <code>members.status</code> and profile together. A transaction retry recomputes everything, so an ingest that lands in between is never overwritten. It never blocks the reconcile, and the reconcile never applies the date-driven changes it stopped.</li>
151:  <li><strong><code>firestore.rules</code></strong>: explicit deny-all blocks for <code>members</code>, <code>memberProfiles</code>, <code>staffRoster</code>, <code>linkOverrides</code> with rules tests (<code>linkOverrides</code> stays deny-all for every client permanently — Phase F's manager settings never reach it); released through the rules guard <em>before</em> the function.</li>
152:  <li>Declarations, iam-expectations (<code>ingest@</code> and its custom role), a FUNCTIONS-ROLLBACK section with the stop/resume runbook and "what to do when a stop email arrives".</li>
153-</ul>
154-<p><strong>Tests first</strong> (emulator, Node 22): every fixture; the gate (earlier, equal, same millisecond with different nanos, malformed) and <strong>A→B→A out of order, single and through a reconcile</strong>; tombstones keep the last name and dates but drop email, emailLower and phoneLast4 (Q7); re-appearance restores the full allowlist; every D4 row through the real <code>deriveStatus</code>, stage-qualified; reconcile: exact thresholds and small denominators, additions, already-tombstoned, <code>held</code> ids untouched, duplicate ids → 400, a stop leaving every collection untouched, a removal racing a newer trigger (members <em>and</em> staff), source-driven counting (an unrelated edit on a pause's first day counts 0; a status-changing edit on a date boundary counts 1), an unchanged record advancing only <code>sourceReadTime</code>, a name-only change applied by the reconcile with 0 status changes, a reappearing member counted as an addition, the recompute ignoring changes its dates explain (a 1st with 15 pause starts doesn't stop) and stopping on unexplained ones, an override not consumed by a run that would have passed anyway, a transaction retry recomputing the counts, overrides (scope, bounds, expiry, single use, its error line, the 249 cap); recompute: one source change vs date changes, the stop with zero writes, a race with ingest in both orders, profiles' <code>pause</code> moving at a window boundary; staff: grant, ungrant, demotion, malformed, a tombstone for a never-held uid writes nothing, more than 1 removal stops; rules deny every client operation; no log contains a fixture's name, email or phone.</p>
155-<div class="bdd">Given members/m_7Q holds A with sourceReadTime T1
156-When envelopes for B (read T2) and A again (read T3) arrive T3 first, then T2
157-Then members/m_7Q ends at A with sourceReadTime T3
--
159-Given a reconcile whose held list contains m_7Q (two live source docs)
160-When it is posted
161-Then members/m_7Q is neither updated nor removed and isn't counted
162-
163-Given a source pause whose endDate is the number 20270201
164:When its snapshot is ingested for an active-stage member
165-Then status is 'review', the stored pause holds "!malformed", and the profile shows no pause</div>
166-</div>
167-
168-<div class="phase">
169-<h3>E-3 — studio-hub: <code>tinker-hq-apps</code>' functions guard (highest-risk PR) <span class="status-tag ready">execution-ready: true</span></h3>
170-<ul>
171-  <li>A <strong>separate</strong> guard (<code>scripts/deploy-functions.sh</code>, its own functions backstop, its own test suite), pinned to <code>tinker-hq-apps</code>; receipts under <code>deployed/tinker-hq-apps/functions-&lt;cb&gt;/…</code>; K10's event-source pin and the pinned config generalized.</li>
172-  <li><strong>The rules guard stays untouched:</strong> <code>deploy-rules.sh</code>, its backstop path, what <code>npm test</code> runs. Functions suites use their own npm script, their own emulator config and non-default ports. <code>firebase.json</code> gains only a <code>functions</code> key: a new test in the rules suite pins that (no <code>emulators</code> block, firestore/storage keys unchanged) and proves a rules release still needs neither Node 22 nor any functions install. A dry rules <code>--status</code>/<code>--diff</code> on the branch.</li>
173-  <li><strong>Firestore event triggers</strong>: declared <code>trigger: "firestore"</code> with event type, document path, database, location <code>nam5</code>, <code>retry: true</code>, service account, and the expected invoker list (Q9); the sealed manifest must match; every other kind still refused by name.</li>
174-  <li><strong>The retry prompt</strong>: answered only for declared event triggers, matched on its exact text; any other prompt, changed wording or end of input → stop. Never <code>--force</code>.</li>
175:  <li><strong>Attestation</strong>: each event-triggered service's Cloud Run invoker list equals its declaration (Q9); project role bindings: no undeclared holder of <code>run.invoker</code>, <code>eventarc.eventReceiver</code>, Owner or Editor (basic roles include invoke rights; the expected Owner/Editor rows are listed in iam-expectations); the Pub/Sub service agent holds Token Creator (the CLI grants it on the first event release — F13).</li>
176-</ul>
177-<p><strong>Acceptance:</strong> the new suite passes (ported + new: unexpected prompt, wording drift, end of input, a partial release continued on the same sha, every undeclared setting refused); the rules guard's suite passes unchanged plus its isolation test; the guard can't target any project but <code>tinker-hq-apps</code>.</p>
178-</div>
179-
180-<div class="phase">
--
189-<p><strong>Tests first</strong> (Firestore emulator on non-default ports for the source; ingest faked): every fixture; late and duplicate deliveries; delete and re-create in both orders; an email change with the retired-old event before and after the new one; conflicts → <code>held</code> in a reconcile, nothing sent on a trigger; a live doc with a missing memberId aborts the reconcile; memberId A→B and A→B→C; a doc with no <code>retired</code> field is live; a partial read; 200/400/409 return normally, 401/403/404/429/5xx/timeout throw; 120 re-saved members with one real change → one envelope that changes a copied field; no write API is used (a test); no log holds personal data.</p>
190-<div class="bdd">Given Jane changes email: jane@new written live and jane@old retired in one batch
191-When the two events arrive old-first, new-first, or one is retried later
192-Then every envelope sent for her memberId describes the one live doc, jane@new
193-
194:Given a users doc with role 'Manager' (wrong case) and appAccess containing 'my-clay-hub'
195-When it is saved
196-Then a tombstone envelope is sent and an error names only the uid
197-
198-Given ingest answers 403
199-When a trigger sends an envelope
--
202-
203-<div class="phase">
204-<h3>E-5 — Christie: identities and IAM (Claude reads before and after) <span class="status-tag ready">execution-ready: true</span></h3>
205-<ol>
206-  <li><strong>Inventory first</strong> (read-only): <code>tinker-hq-apps</code>' IAM with Google-provided grants; every service account and what uses it; Cloud Run services, Cloud Functions, Scheduler jobs, build triggers, VMs, App Engine (and the App Engine default account, which often holds Editor); 30 days of audit logs for the default Compute and App Engine accounts. If anything uses them, stop and re-plan.</li>
207:  <li><code>tinker-hq-apps</code>: enable the APIs (run, eventarc, cloudfunctions, cloudbuild, artifactregistry, pubsub, cloudscheduler, iamcredentials); record the service agents and grants that creates; create <code>gcf-artifacts</code>; neutralize both build candidates and the App Engine default account if unused; give the account Google builds with only the three build roles (as D2-1); an email notification channel for alerts.</li>
208:  <li><code>tinker-hq-apps</code>: <code>clayhub-link@</code>; a custom role with exactly <code>datastore.entities.get</code> and <code>datastore.entities.list</code>; grant it and <code>eventarc.eventReceiver</code>.</li>
209:  <li><code>my-clay-hub</code>: <code>ingest@</code>; a custom role with get, list, create, update, no delete; grant it.</li>
210:  <li>After-readings: each project differs from its before-reading by exactly the recorded rows; <code>clayhub-link@</code> holds nothing in <code>my-clay-hub</code> yet. Christie opens two staff apps.</li>
211-</ol>
212-</div>
213-
214-<div class="phase">
215:<h3>E-6 — Release the receiving side (my-clay-hub) <span class="status-tag ready">execution-ready: true</span></h3>
216:<p>Rules first (rules guard, its own phrase); then <code>--diff --codebase members</code>, Christie's phrase, release, readings, <code>--attest</code>. Probe: an unauthenticated POST gets 403; the invoker reading shows exactly <code>clayhub-link@tinker-hq-apps</code>; <code>clayhub-link@</code> holds nothing else in <code>my-clay-hub</code> (the cheap stand-in for a live write-refusal test). No real data: the first authenticated call is E-8's first fill.</p>
217-</div>
218-
219-<div class="phase">
220-<h3>E-7 — Alerts, then release the link (tinker-hq-apps) — after every gate <span class="status-tag ready">execution-ready: true</span></h3>
221-<p><strong>Gates, all required:</strong> V-4 complete (<code>deploy_verified</code>, <code>iam_attested</code>, <code>scheduler_attested</code> all yes, and a verified complete export); DECISIONS #64's fix released and attested; E-pre done; E-6 verified and attested.</p>
--
229-</div>
230-
231-<div class="phase">
232-<h3>E-8 — First fill, then delivery, proof, attest, spot check, fresh vault copy <span class="status-tag ready">execution-ready: true</span></h3>
233-<ol>
234:  <li><strong>First fill:</strong> Force run the paused <code>reconcileLink</code> (Christie clicks; logged; first confirm in the Console that a paused job can be Force run — if not, resume it, Force run, pause again). This is the first authenticated cross-project call and the first data. Counts match Membership Manager (live members; managers/admins in <code>staffRoster</code>).</li>
235-  <li><strong>Q9</strong>: Christie grants <code>run.invoker</code> to <code>clayhub-link@</code> on the two trigger services only. Events retried since the release now run: each re-reads its source, so it lands as <code>unchanged</code> or <code>applied</code>. The trigger-service 4xx alert fired as expected from the release until this grant.</li>
236-  <li><strong>Delivery proof after K13 removal:</strong> Christie saves one member in Membership Manager. Evidence, all three: the trigger's execution log timestamped after the removal, ingest's 200 for that memberId, and its stored <code>sourceReadTime</code> later than the removal. If it fails: <strong>stop the link</strong> (runbook) and re-plan — never restore broad grants.</li>
237-  <li>Resume <code>reconcileLink</code>; readings; <code>--attest</code> (needs the job ENABLED, Q9's invoker lists, Token Creator, and no K13 grants).</li>
238:  <li>Spot check three members (active; paused or with pause history; offboarding/cancelled if any) against Membership Manager: status, dates, and no forbidden field or malformed marker in any profile.</li>
239-  <li>Force run the vault export (fine once #64 is live) and verify the new complete folder — the first off-project copy with real member data. The vault plan's restore rehearsal follows.</li>
240-</ol>
241-</div>
242-
243-<div class="phase">
--
255-</ol>
256-
257-<h2>Firebase safety checklist</h2>
258-<ul>
259-  <li>Every new collection gets an explicit rule and rules tests in the same commit as the code that writes it, deployed before the function (E-2, E-6).</li>
260:  <li>Writers to my-clay-hub's member data: <code>ingestMemberUpdate</code> (single and reconcile) and <code>recomputeStatuses</code> (status and profile pause only) — both as <code>ingest@</code>, each change one transaction, never deletes.</li>
261-  <li>Nothing writes to <code>tinker-hq-apps</code>: <code>clayhub-link@</code> holds only get/list; the codebase uses no write API (tested).</li>
262-  <li>No forbidden field at any nesting level, and no full phone, crosses projects (contract + fixtures); no personal data in logs.</li>
263-  <li>Emulator tests only; neither guard can reach the other project; the CLI credential file is never read.</li>
264-  <li>Bulk changes bounded (Q8) and atomic: a reconcile and a recompute are each one transaction (≤ 250 members), so a stopped or failed run writes nothing.</li>
265-</ul>
--
274-</ul>
275-
276-<h2>Resume instructions</h2>
277-<ul>
278-  <li>Read Status and the newest Decisions-log entry.</li>
279:  <li>Branches: <code>git -C ~/my-clay-hub branch -a</code>, <code>git -C ~/studio-hub branch -a</code> (names start <code>phase-e-</code>); open PRs and their review state.</li>
280-  <li>Deploy state: each project's <code>scripts/deploy-functions.sh --status --codebase &lt;cb&gt;</code> (fetch first).</li>
281:  <li>Reviews: <code>~/tinker-ai-configs/thoughts/reviews/my-clay-hub-phase-e-plan-round&lt;n&gt;-*</code>.</li>
282-</ul>
283-
284-<h2 id="reviews">Reviews</h2>
285-<h3>Round 1 (Oct 8) — Codex "not ready" (9 blocking); Claude "ready after fixes" (3 blocking)</h3>
286-<table>
--
306-<tr><td>Event triggers have no invoker in the design (Claude, blocking; confirmed in the CLI source)</td><td>F13; Q9; declared invoker lists for event triggers, attested; E-7 step 4.</td></tr>
307-<tr><td>Staff rule inconsistent; thresholds unsafe for a small roster (Codex, blocking; Claude should-fix)</td><td>Only granted staff are sent; tombstones for never-held uids write nothing; a staff stop at more than 1 removal.</td></tr>
308-<tr><td>Contract not exact: types, nulls, profiles, tombstones (Codex, blocking; Claude should-fix)</td><td>The contract: every field's type and fallback; <code>memberProfiles</code> and its pause rule; three tombstone schemas; malformed canonicalized (no raw text crosses); <code>processed</code> for Q6.</td></tr>
309-<tr><td>Recompute not atomic (Codex, blocking)</td><td>One transaction (≤ 250 members), status and profile together, retry recomputes.</td></tr>
310-<tr><td>Settings table incomplete / wrong names (Codex, blocking; Claude should-fix)</td><td>Rewritten with the guard's exact keys and every limit; values pinned by unit tests.</td></tr>
311:<tr><td>Should-fix: 401/403 swallowed; stop runbook vs scheduler attestation; a stop cascading; the K13 failure path; Pub/Sub Token Creator; E-7 order vs attestation; E-8 proof that could pass vacuously; first-fill exemption redundant; rules port 8080 and <code>firebase.json</code>; E-0 sequencing; Netlify publish root; alert channel in tinker-hq-apps; 250-member cap; clayhub-link@ reading in my-clay-hub; phone rule</td><td>Responses row; the runbook (recompute keeps running); source-driven counting and <code>settings/linkLimits</code>; "stop and re-plan"; E-3 attestation; E-7/E-8 reordered (pause, Q9, K13, first fill, proof, then attest); evidence-based proof; exemption dropped; E-3 isolation test; E-0 first; E-4 note; E-5 step 2; settings note; E-6; <code>formatPhone</code>.</td></tr>
312-</table>
313-
314-<h3>Round 3 (Oct 8) — Codex "not ready" (2 blocking); Claude "ready after fixes" (0 blocking; its first attempt hit a usage limit and was re-run)</h3>
315-<table>
316-<tr><th>Finding</th><th>Resolution (v4)</th></tr>
--
339-<ul>
340-  <li><strong>Oct 8:</strong> Christie: "mark it ready and start E-pre" — every phase execution-ready: true.</li>
341-  <li><strong>Oct 8 — E-pre done:</strong> PR #13 (docs: DECISIONS #65–#73, SPEC, DATA-MODEL) merged at <code>a4b8e21</code> (head <code>ee1e5b3</code>); PR #14 (<code>deriveStatus</code> ignores an unprocessed <code>scheduledPause</code>, #70) merged at <code>3cd273a</code> (head <code>09c5f95</code>), both with Christie's "yes" to merge. Reviews: round 1 Codex (#13 merge after fixes, 2 blocking — UTC/Denver wording, #72's counting rule; #14 safe) and Claude (#13 merge after fixes, 0 blocking; #14 safe); all applied; round 2 Codex confirming on #13: safe to merge, no findings. Full suite on #14: unit 233, rules guard 199, functions guard 944, emulator 68+2+3, rules 194. Nothing released. Note: Monday's vault <code>--diff</code> will list <code>shared/</code> as changed (the guard pins it; the vault codebase doesn't use it). Next: E-0 (studio-hub users-rules pins), after Monday's V-4 finish and the #64 release.</li>
342-  <li><strong>Oct 8 — Christie's answers:</strong> Q1 09:30 UTC; Q2 inside, own PR; Q3 audit → strip → remove → prove; Q4 build the roster now; Q5 a new memberId is a new identity; Q6 <strong>B</strong> (unprocessed Quick Log pauses don't block booking); Q7 <strong>keep name, member-since, stage and every pause/last-day date; drop email, emailLower, phoneLast4</strong> (her change: "useful and isn't sensitive"); Q8 as described; Q9 one recorded per-service exception. E-pre writes these into DECISIONS/SPEC/DATA-MODEL.</li>
343-  <li><strong>Oct 8:</strong> v1 drafted from the foundation plan's Phase E outline after research (F1–F11).</li>
344:  <li><strong>Oct 8:</strong> review round 1 (Codex "not ready", 9 blocking; Claude "ready after fixes", 3 blocking, 13 should-fix) → v2: the contract, the receiver-side reconcile, E-pre, the stop runbook, the settings table, E-5's audit, the K13 proof; Q6–Q8 added. Review files <code>thoughts/reviews/my-clay-hub-phase-e-plan-round1-*</code>.</li>
345-  <li><strong>Oct 8:</strong> review round 2 (Codex "not ready", 5 blocking; Claude "ready after fixes", 3 blocking) → v3: <code>held</code> conflicts and race-safe removals, the readTime advance, Q9 (event-trigger invoker — confirmed in firebase-tools 15.22.3 source), exact schemas and tombstones, a one-transaction recompute, the full settings table, the reordered E-7/E-8, the stop-email path. Both reviewers recommend Q6 = B. Review files <code>…-round2-*</code>.</li>
346-  <li><strong>Oct 8:</strong> review round 3 (Codex "not ready", 2 blocking; Claude "ready after fixes", 0 blocking — both confirm every round-2 finding resolved and Q9's design against the CLI source) → v4: the counterfactual source-driven rule, <code>linkOverrides</code>, Q6's exact rule and order, the E-7/E-8 order, the Token Creator gate, two stop kinds, the trigger-service alert, the E-2 merge timing. Review files <code>…-round3-*</code>.</li>
347-  <li><strong>Oct 8:</strong> review round 4 (both "ready after fixes", 0 blocking) → v4.1: exact per-scope overrides used only when needed, whole-snapshot repair, the recompute's explained-change rule with <code>statusDate</code>, nits. The plan is ready for execution once Christie answers Q1–Q9 (a confirming pass will re-check anything her answers change). Review files <code>…-round4-*</code>.</li>
348-</ul>
349-

exec
/bin/zsh -lc "sed -n '1,90p' firestore.rules && sed -n '105,210p' firestore.rules && rg -n -C 8 \"granted|role.*admin|appAccess.*my-clay-hub|active.*absent|Missing.*active|staffRoster\" /Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html && git diff --check 047a84e"'^ 047a84e && git diff --numstat 047a84e''^ 047a84e && git diff --word-diff=porcelain 047a84e''^ 047a84e -- firestore.rules rules.test.js' in /Users/christiehubley/studio-hub
 succeeded in 0ms:
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // ═══════════════════════════════════════════════════════════════
    // HELPER FUNCTIONS
    // Change a function here → every rule that uses it updates.
    // Never repeat logic inline.
    // ═══════════════════════════════════════════════════════════════

    function isAuthenticated() {
      return request.auth != null;
    }

    function getUserData() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data;
    }

    // Archived users (active:false) lose access everywhere this is required —
    // missing `active` defaults to true, so existing users need no migration.
    // The reminder bot is never an active user, whatever a users doc keyed to its uid might say — so
    // even a doc an admin created by hand can never make isAdmin/isManager/hasAppAccess true for it.
    function isActiveUser() {
      return isAuthenticated() && !isReminderBot() && getUserData().get('active', true) == true;
    }

    function isAdmin() {
      return isAuthenticated() && isActiveUser() && getUserData().role == 'admin';
    }

    function isManager() {
      return isAuthenticated() && isActiveUser() && getUserData().role == 'manager';
    }

    function isManagerOrAbove() {
      return isAuthenticated() && isActiveUser() && getUserData().role in ['admin', 'manager'];
    }

    function isKiosk() {
      return isAuthenticated() && (
        request.auth.uid == '06ooFxutK5YTaJvu5SkywY9gZqh2'
        || request.auth.token.email == 'kiosk@tinkerartstudio.com'
        || request.auth.token.email == 'kiosk2@tinkerartstudio.com'
      );
    }

    // Tinker Ticker's 48-hour shift-reminder job (reminders@tinkerartstudio.com), a Netlify Scheduled
    // Function that signs in with the client SDK — no service account, no key. Pinned by uid ONLY: an
    // email/password account's address is unverified, so the kiosk's email clause is deliberately not
    // copied. It has no users doc and never will (see the users create rule). What it may do is listed
    // per collection below and nowhere else: read schedules, GET (never list) a users doc, and create /
    // resolve its own claim documents in timeclock_reminder_log. Never OR this with a helper that
    // reads users (isManagerOrAbove etc.) — each grant is its own allow line.
    function isReminderBotUid(uid) {
      return uid == 'JO8U8EYw2tgVBbsUXvbqNrbCPlh1';
    }
    function isReminderBot() {
      return isAuthenticated() && isReminderBotUid(request.auth.uid);
    }

    // Checks if an authenticated user has been explicitly granted
    // access to an app via their appAccess array.
    // Manager+ never need this — they're covered by isManagerOrAbove().
    // Finance collections (payroll, bookkeeping) have NO override path —
    // this function is intentionally never called for those.
    function hasAppAccess(appName) {
      let data = getUserData();
      return isAuthenticated()
        && isActiveUser()
        && ('appAccess' in data)
        && appName in data.appAccess;
    }

    // Studio isolation. Admin always passes. Everyone else must have
    // the studio in their studios array. Needs its own explicit isActiveUser()
    // check — the non-admin branch doesn't route through isAdmin()/isManager()/
    // hasAppAccess() at all, so gating those four alone would miss this one.
    function belongsToStudio(studio) {
      return isActiveUser() && (isAdmin() || studio in getUserData().studios);
    }

    // True if `field` is unchanged by this write: same presence
    // (both missing or both present) and, if present, the same value.
    // Used to pin privilege-bearing fields (role, appAccess, studios)
    // during self-writes to the users collection.
    function fieldUnchanged(field) {
      return (field in resource.data) == (field in request.resource.data)
        && (!(field in resource.data) || request.resource.data[field] == resource.data[field]);
    }
    // Manager+: read all user docs.
    // Self-update: role field must not change.
    // Manager update: cannot change role field, cannot delete.
    // Admin: full create / update / delete.
    // ═══════════════════════════════════════════════════════════════

    match /users/{userId} {
      // My Clay Hub depends on these (Phase E): the clayhub-link functions read each users doc's
      // role, active and appAccess to decide who is in my-clay-hub's staffRoster (who can use its
      // /staff screens), and store only name and role there. Staff and managers can't change their
      // own role, active or appAccess, so they can't put themselves in. An admin can't change their
      // own active; they can edit their own role and appAccess, but that never gives them more
      // My Clay Hub access than an admin already has (it keeps it or removes it). name is
      // self-editable and display-only there. Pinned by rules.test.js "Users — fields My Clay Hub
      // relies on"; loosening any of this changes who is staff in My Clay Hub too.
      // Own doc read — all authenticated users (auth guard requires it). Not the reminder bot: its
      // grant is GET-only below, and this `read` would let an id-constrained LIST through.
      allow read: if isAuthenticated() && request.auth.uid == userId && !isReminderBot();
      // Manager+ reads all user docs (team filters, admin panels, etc.)
      allow read: if isManagerOrAbove();
      // Kiosk: read all users (for PIN lookup)
      allow read: if isKiosk();
      // Reminder bot: GET one doc by uid (the account it is about to email) — never a list.
      allow get: if isReminderBot();

      // Self-create: role must be 'staff' (prevents self-promotion), and
      // appAccess must be absent or empty — app access is granted by an
      // admin/manager via Manage Team, never by the user themselves.
      // studios is NOT locked to empty here: the real bootstrap write (see
      // js/app.js handleAuthStateChange) always sets studios: ['tinker',
      // 'clayhub'] — both known studios, granted to every new user by
      // default — so hasOnly() permits exactly that shape while still
      // blocking a self-create from injecting any value outside the two
      // known studios (there's no smaller "safe default" to enforce here
      // since the app already grants both to everyone; appAccess is the
      // field that actually gates privilege).
      // The reminder bot is a job, not a person: it can never bootstrap a users doc for itself, so it
      // can never become "an active staff user" to isActiveUser()/hasAppAccess().
      allow create: if isAuthenticated()
        && request.auth.uid == userId
        && !isReminderBot()
        && request.resource.data.role == 'staff'
        && (!('appAccess' in request.resource.data) || request.resource.data.appAccess.size() == 0)
        && (!('studios' in request.resource.data) || request.resource.data.studios.hasOnly(['tinker', 'clayhub']));

      // Self-update: role, appAccess, and studios must not change.
      // Without pinning appAccess/studios here, any authenticated staff
      // user could grant themselves access to any app (KPI, Classbook,
      // Payroll-adjacent tools, etc.) with a direct Firestore write that
      // bypasses the Manage Team UI entirely.
      allow update: if isAuthenticated()
        && request.auth.uid == userId
        && !isReminderBot()
        && request.resource.data.role == resource.data.role
        && fieldUnchanged('appAccess')
        && fieldUnchanged('studios')
        && fieldUnchanged('active');

      // Manager update: cannot change role field, cannot delete.
      // Restricted to OTHER users' docs (request.auth.uid != userId) —
      // without this guard, a manager editing their OWN doc would satisfy
      // isManager() and bypass the appAccess/studios pins on the self-update
      // rule above entirely, since Firestore OR's sibling `allow update`
      // rules together. A manager's own self-edits go through the
      // self-update rule instead, which does pin those fields. Found by
      // independent second-model review before this shipped — see
      // firebase-agent-defense-hardening.md.
      // A manager also cannot flip an admin's `active` field (archive/
      // reactivate) — only another admin can. Managers keep full appAccess/
      // studios editing on admins; that pre-existing gap stays out of scope.
      allow update: if isManager()
        && request.auth.uid != userId
        && request.resource.data.role == resource.data.role
        && (resource.data.role != 'admin' || fieldUnchanged('active'));

      // Admin: full create / update / delete on OTHER users' docs. An admin
      // can never change their OWN `active` field via this (or any) rule —
      // without this guard this blanket rule sits outside the self-update
      // rule's fieldUnchanged('active') pin (Firestore ORs sibling `allow`
      // rules), so an admin could archive themselves with no recovery path:
      // the moment it commits, isAdmin() requires isActiveUser() and denies
      // them on every future request, including their own attempt to undo
      // it. Same bug shape as the manager self-grant fix above, just for a
      // field that didn't exist yet when that one shipped.
      // …and never a doc keyed to the reminder bot's uid (a job, not a person): create and update are
      // refused so no admin can hand the Netlify-held password a role by typing the uid; delete stays,
      // so a doc created by mistake can be removed.
      allow write: if isAdmin()
        && (request.auth.uid != userId || fieldUnchanged('active'))
        && !(isReminderBotUid(userId) && request.method in ['create', 'update']);
    }


    // ═══════════════════════════════════════════════════════════════
    // FINANCE — HARD LOCKED
    // payroll and bookkeeping: manager+ ONLY. No appAccess override
    // path exists, ever. No exceptions.
    // ═══════════════════════════════════════════════════════════════

    match /payroll/{docId} {
      allow read, write: if isManagerOrAbove();
    }

    // Payroll Tool settings history — an append-only recovery log.
    // Manager+ may read and create; nothing may update or delete an entry.
    // A create must ride in the same transaction that moves the parent's
24-  .ready { background: #d1fae5; color: #065f46; }
25-</style>
26-</head>
27-<body>
28-
29-<h1>Plan: My Clay Hub Phase E — the live link from Membership Manager</h1>
30-
31-<div class="meta">
32:  <strong>Goal:</strong> When staff add, edit, pause or offboard a member in Membership Manager, My Clay Hub's own copy of that member (<code>members/{memberId}</code>, with the right derived status) matches within a minute — one way only, carrying only the allowed fields, and safe against late, duplicate or out-of-order deliveries. Staff with My Clay Hub access are mirrored the same way into <code>staffRoster</code>.<br>
33-  <strong>Repos:</strong> <code>/Users/christiehubley/my-clay-hub</code> (the receiving side) and <code>/Users/christiehubley/studio-hub</code> (the sending side: the <code>clayhub-link</code> functions and <code>tinker-hq-apps</code>' own functions guard). Console/IAM work in both projects is Christie's (no gcloud on the Mac; read-only readings by Claude in her Chrome or via Cloud Shell).<br>
34-  <strong>Parent:</strong> <code>clayhub-members-foundation.html</code> Phase E (the outline this plan expands), decisions D2, D4, D4a, D11, D21, D22, D23 and the IAM inventory; <code>firebase-functions-deploy-guard.html</code> (M1, F13, K10, K11, K13, the round-1 "retry approval" finding); <code>my-clay-hub-d4-vault-export.html</code> (the gate).<br>
35-  <strong>Gate:</strong> no real member data enters <code>my-clay-hub</code> until D-4's V-4 is complete (first complete vault export — Sunday Oct 11's scheduled run). Phases E-1 to E-6 build and test with no real data and may run before the gate; <strong>E-7 (deploying the link) waits for it.</strong><br>
36-  <strong>Not in this plan:</strong> any screen, sign-in provider or <code>claimMembership</code> (Phase F); the Tinker HQ tile and the Manage Team <code>my-clay-hub</code> box (Phase F); "change email" in Membership Manager (B4, its own plan); <code>kioskLookup</code>; any write back to Membership Manager (never, D6).<br>
37-  <strong>Risk:</strong> <strong>HIGH.</strong> The first Cloud Functions ever in <code>tinker-hq-apps</code>, the project every staff app shares; real member personal data crossing projects for the first time; IAM changes in both projects, including one Google makes on its own (K13).<br>
38-  <strong>Size:</strong> roughly 2 weeks at the D-4 cadence (several review rounds per PR). Christie's hands-on time ≈ 6–10 h (decisions, Console/IAM steps, approvals, a 3-member spot check).<br>
39-  <strong>Status:</strong> <span class="status-tag ready">execution-ready: true</span> — v4.1, Oct 8, 2026, after four review rounds (round 4: Codex and Claude both "ready after fixes", 0 blocking; all fixes applied). Christie answered Q1–Q9 on Oct 8 (Q7 changed: removed members keep everything but email and phone digits). <strong>Marked execution-ready (all phases) by Christie, Oct 8.</strong> Next: E-pre (its PR review re-checks the Q7 change).
40-</div>
41-
42-<h2>Already decided (not reopened here)</h2>
43-<ul>
44:  <li><strong>D22 "Re-read, then send a snapshot"</strong> (DECISIONS #53): a trigger on <code>clayHub_members/{id}</code> collects the memberId from before and after; for each, one query on <code>memberId</code> only; live = <code>retired !== true</code>; exactly one live doc → its fields; none → tombstone; more than one → conflict, nothing sent, alert. POST <code>{memberId, snapshot, readTime}</code>; ingest drops anything not newer than the stored <code>sourceReadTime</code>, checks the payload strictly, runs <code>deriveStatus</code>, writes, never deletes. The reconcile uses the same envelope, read in one read-only transaction pinned to one readTime. <code>users/{uid}</code> → <code>staffRoster/staff_{uid}</code> the same way (no memberId, no conflict case).</li>
45-  <li><strong>D4 / D4a / #34</strong>: status comes only from <code>shared/derive-status.js</code>; Denver calendar dates; recomputed for everyone daily.</li>
46-  <li><strong>#24</strong>: only <code>phoneLast4</code> leaves <code>tinker-hq-apps</code>, worked out there. <strong>#37 / D6</strong>: never write back. <strong>#42</strong>: IAM one-way; ingest can't delete. <strong>#32 / D2 / M1</strong>: the link is codebase <code>clayhub-link</code> in studio-hub, deployed only by <code>tinker-hq-apps</code>' own functions guard; neither guard can reach the other project. <strong>#54 / D23</strong>: 2nd gen, retries on (<code>retry: true</code> on triggers, retryConfig on schedules), explicit maxInstances, Admin app built once per instance; Firestore <code>nam5</code>, Eventarc location <code>nam5</code>, functions <code>us-central1</code>.</li>
47:  <li><strong>IAM inventory (D11)</strong>: <code>clayhub-link@tinker-hq-apps</code> = a custom read-only Firestore role (get, list) + <code>eventarc.eventReceiver</code>; <code>ingestmemberupdate</code> is <code>invoker</code>: exactly <code>clayhub-link@tinker-hq-apps</code> (declared; the CLI sets it — never granted by hand); <code>ingest@my-clay-hub</code> = custom role get/list/create/update, no delete. Called at the service's exact run.app URL with an OIDC token from the metadata server.</li>
48-  <li><strong>#63 / #64</strong>: the vault gate; Force runs keyed by the day they run (deploys Monday Oct 12).</li>
49-</ul>
50-
51-<h2 id="facts">Facts this plan relies on (research Oct 8; corrected after review round 1)</h2>
52-<table>
53-<tr><th>#</th><th>Fact</th><th>Source</th></tr>
54-<tr><td>F1</td><td><code>clayHub_members</code>: every doc the app writes has a valid <code>memberId</code> (<code>m_</code> + UUID v4; the app can't create a doc without one). The count, 66/66 valid and unique, comes from the dated Sep 28 backup log, not from code. Doc id = email lowercased with <code>/</code> and <code>.</code> → <code>_</code>. <strong>No stored <code>emailLower</code></strong>. Saves write only changed fields; blank top-level fields are stripped.</td><td>clay-hub-membership firebase-data.js:85-94, 155-208; member-status.js:668-682; save-safety plan log</td></tr>
55-<tr><td>F2</td><td>Source fields the link reads (and nothing else): <code>memberId</code>, <code>email</code>, <code>name</code> (one string), <code>phone</code> (free text), <code>stage</code>, <code>scheduledPause</code> (null or one of three shapes), <code>pauseHistory[]</code> (modern <code>startDate</code>/<code>endDate</code> or legacy <code>start</code>/<code>end</code>; may carry <code>priorTerm</code>), <code>scheduledCancellation.finalAccessDate</code>, <code>memberSince</code>, <code>retired</code>. <strong>The pause and cancellation objects also carry <code>notes</code>, <code>type</code>, <code>lastBilling</code>, <code>processDate</code>, Sawyer and audit fields</strong> — never copied (see the contract).</td><td>app.js:500, 550-560, 935-938, 3540-3651, 3761-3774; member-status.js:32-36, 721-725</td></tr>
56-<tr><td>F3</td><td>Never copy: <code>keypadCode</code>, <code>keypadUserId</code>, <code>staffNotes</code>, <code>notes</code>, <code>application</code>, <code>actions</code>, the full phone, the shelf fields, billing fields — at any nesting level.</td><td>save-safety plan, "What My Clay Hub's link needs"</td></tr>
57-<tr><td>F4</td><td>"Change email" (B4) isn't built; nothing writes <code>retired</code> today. Authorized Clay Hub writers can create documents with no rules-level schema or memberId check (so a delete + re-create can carry a new memberId).</td><td>grep; studio-hub firestore.rules:942</td></tr>
58:<tr><td>F5</td><td><code>users/{uid}</code>: the link uses only <code>name</code>, <code>role</code>, <code>active</code>, <code>appAccess</code>. Docs carry other fields too (<code>email</code>, <code>createdAt</code>, <code>pin</code>, …), and admins can write other users' docs, so the rules don't guarantee shapes: the link must fail closed on anything unexpected. Missing <code>active</code> means true. Managers/admins are saved with <code>appAccess: []</code>. The <code>my-clay-hub</code> key doesn't exist yet.</td><td>studio-hub js/app.js:148-155, 1144-1145, 1339-1347; firestore.rules:24-38, 67-73, 111-187</td></tr>
59-<tr><td>F6</td><td><code>deriveStatus(source, todayDenver)</code> needs the <em>source shape</em> (<code>stage</code>, <code>scheduledPause</code>, <code>pauseHistory</code>, <code>scheduledCancellation.finalAccessDate</code>, <code>tombstone</code>, <code>retired</code>). It reads every pause entry including <code>priorTerm</code> ones (intended), and turns an unknown stage, a malformed or missing date, or a non-object pause into <code>review</code>. So malformed values must reach it, as values that are still malformed.</td><td>shared/derive-status.js:6-17, 30-35, 74-80; DATA-MODEL.md:86-88</td></tr>
60-<tr><td>F7</td><td>studio-hub has no functions and no functions guard. Its <strong>rules guard</strong> runs <code>npm test</code> in a worktree and takes <code>firebase.json</code>, <code>package.json</code> and <code>predeploy-check.sh</code> from <code>origin/main</code>'s tip; its backstop accepts only firestore and storage targets; <code>rules.test.js</code> uses the default emulator port 8080 and <code>firebase.json</code> has no emulators block. Anything E-3/E-4 adds there can break every staff app's rules deploy and rollback, and a rules commit made before E-3/E-4 merge must be deployed before they merge (the control files must match the tip).</td><td>studio-hub scripts/deploy-rules.sh:204-209, 348, 406; predeploy-check.sh:22-24; rules.test.js:76</td></tr>
61-<tr><td>F8</td><td>K13: the first event-triggered deploy grants the default Compute account project-wide <code>run.invoker</code> and <code>eventarc.eventReceiver</code>; a failed deploy still enables APIs and creates service agents. The runtime identity of a trigger and the identity that delivers its events are different things. The CLI prompts before enabling retries on an event trigger. K10 pins <code>EVENTARC_CLOUD_EVENT_SOURCE</code> to my-clay-hub.</td><td>firebase-functions-deploy-guard.html</td></tr>
62-<tr><td>F9</td><td>The guard requires UTC schedules with all five retry values declared; an empty invoker list is refused; <code>["private"]</code> means no callers.</td><td>predeploy-check.sh:242-249; deploy-functions.sh:184, 358</td></tr>
63-<tr><td>F10</td><td>One cross-project grant into <code>tinker-hq-vault</code> was accepted (V-1). Organization policies can differ by project, so the <code>run.invoker</code> binding is proven only by E-7's first real call.</td><td>D-4 log, Oct 2</td></tr>
64-<tr><td>F11</td><td>A code search found no staff-app server code using <code>tinker-hq-apps</code>' default Compute account. That is <em>not</em> enough to change a production account: E-5 adds a workload inventory and an audit-log check.</td><td>grep</td></tr>
65-<tr><td>F13</td><td><strong>The pinned CLI (15.22.3) and event triggers:</strong> it sends events <em>as the trigger's own runtime account</em> (<code>eventTrigger.serviceAccountEmail</code> = the function's service account), but sets a Cloud Run invoker only for HTTP-style functions, never for event triggers. On the first event release it adds project-wide bindings: <code>run.invoker</code> and <code>eventarc.eventReceiver</code> for the default Compute account, and Token Creator for the Pub/Sub service agent. So <code>clayhub-link@</code> needs <code>run.invoker</code> on its two trigger services, and nothing in the CLI gives it that (Q9).</td><td>firebase-tools lib/gcp/cloudfunctionsv2.js:214-216; lib/deploy/functions/release/fabricator.js:221-253, 345-389; lib/deploy/functions/checkIam.js:104-160</td></tr>
66-<tr><td>F12</td><td>Firestore IAM can't be limited to one collection: <code>clayhub-link@</code>'s read role covers the whole <code>tinker-hq-apps</code> database (payroll included). Accepted residual: read-only, one runtime, guarded code.</td><td>Firestore IAM model</td></tr>
--
73-<tr><td>Q1</td><td>The guard allows only UTC schedules; "3:30 AM Denver" isn't one.</td><td><strong>09:30 UTC daily</strong> = 3:30 AM MDT / 2:30 AM MST: after Denver midnight, before the 5 AM opening, all year. Recorded as a change to SPEC's "3:30 AM" before any code.</td></tr>
74-<tr><td>Q2</td><td>The <code>tinker-hq-apps</code> functions guard: inside this plan or its own?</td><td><strong>Inside, as E-3: its own branch, PR and review rounds</strong>, treated as the highest-risk PR (it lives next to every staff app's rules guard).</td></tr>
75-<tr><td>Q3</td><td>K13: Google's first trigger deploy gives the default Compute account project-wide invoke rights in the staff apps' project.</td><td><strong>Audit, neutralize, deploy, remove, then prove.</strong> E-5 inventories every workload and checks recent audit logs before touching the account. After E-7's deploy, remove Google's two grants, and only count it done when a real event is delivered <em>after</em> the removal. The guard's attestation then refuses if they come back.</td></tr>
76-<tr><td>Q4</td><td>The staff roster, with no My Clay Hub box in Tinker HQ yet.</td><td><strong>Build the machinery now, no Tinker HQ UI.</strong> It mirrors managers/admins until Phase F adds the box. Strict input, fails closed.</td></tr>
77-<tr><td>Q5</td><td>"Change email" isn't built; a delete + re-create gives a new memberId.</td><td><strong>Treat it as a new identity:</strong> the old memberId becomes a tombstone (<code>removed</code>), the new one starts fresh. B4 stays its own plan.</td></tr>
78-<tr><td>Q6 <em>(new)</em></td><td>A "Quick Log" pause request (no <code>scheduledAt</code>) is never started by Membership Manager, but <code>deriveStatus</code> treats its dates as a real pause, so My Clay Hub would show the member as <strong>paused</strong> (no booking) for those dates.</td><td><strong>B (both reviewers):</strong> an unprocessed request doesn't stop a paying member booking. The sender sends <code>scheduledPause.processed</code> instead of the timestamp, using Membership Manager's own test (a pause is processed when <code>scheduledAt</code> is present — <code>member-status.js:127-131</code>); <code>deriveStatus</code> first treats a non-object <code>scheduledPause</code> as malformed (<code>review</code>), and only then ignores an object whose <code>processed</code> isn't <code>true</code> (history entries are processed by definition). A <code>deriveStatus</code> change, made and reviewed in E-pre before E-1's fixtures freeze. Option A (count it) needs no change.</td></tr>
79-<tr><td>Q7 <em>(new)</em></td><td>When a member is removed, does My Clay Hub keep their name, email and phone digits?</td><td><strong>Christie, Oct 8: keep everything last known except the contact details.</strong> A removed member's <code>members</code> doc keeps their name, <code>firstName</code>, <code>lastInitial</code>, <code>memberSince</code>, stage, pause history, scheduled pause and last-day date (useful for history; not sensitive), and drops <code>email</code>, <code>emailLower</code> and <code>phoneLast4</code>. Their member-facing profile reduces to <code>removed</code>. (Membership Manager keeps the full record either way.)</td></tr>
80-<tr><td>Q8 <em>(new)</em></td><td>The safety stops at 66 members: "10% of statuses" is 7 people, and the 1st of a month can legitimately move that many (pauses starting and ending).</td><td><strong>Members:</strong> stop when status changes &gt; max(ceil(10% × live held), 10) or removals &gt; max(ceil(5% × live held), 4); additions never count; a removal counts only as a removal. <strong>The reconcile counts only source-driven status changes</strong> and <strong>the recompute only changes no pause or last-day date explains</strong>, so a busy 1st of the month stops neither. <strong>Staff:</strong> stop when more than 1 held staff record would be removed. A stop writes nothing and emails you; the runbook says how you let a legitimate large change through (a scoped, single-use, expiring override you create in the Console after checking the listed ids).</td></tr>
81:<tr><td>Q9 <em>(new, round 2)</em></td><td>The two link triggers need permission to call their own Cloud Run services (F13), and the CLI never grants it. The guard's rule is "never grant run.invoker by hand".</td><td><strong>One recorded exception, per service:</strong> right after E-7's release, you grant <code>run.invoker</code> to <code>clayhub-link@</code> on exactly the two trigger services (<code>onclayhubmemberwritten</code>, <code>onstaffuserwritten</code>) — never project-wide. The guard declares that expected invoker list for event triggers and its attestation checks it (a wrong or extra grant fails). Until it's granted, deliveries are refused and Eventarc retries them (up to 24 h). Alternative: project-level <code>run.invoker</code> for <code>clayhub-link@</code> — simpler, broader, not recommended.</td></tr>
82-</table>
83-
84-<h2 id="contract">The link contract (E-1 writes it down once; both sides test against it)</h2>
85-<table>
86-<tr><th>Part</th><th>Exact rule</th></tr>
87-<tr><td>Envelope</td><td><code>{v:1, kind, readTime, …}</code>; <code>kind</code> ∈ <code>member</code> | <code>staff</code> | <code>reconcile</code>. Any other key, version or kind → 400.</td></tr>
88-<tr><td><code>readTime</code></td><td><code>{seconds: "&lt;decimal string&gt;", nanos: &lt;int 0..999999999&gt;}</code> from the source read's <code>Timestamp</code>, full nanosecond precision; stored as a Firestore <code>Timestamp</code> (<code>sourceReadTime</code>); compared as (seconds, nanos). Out-of-range or non-canonical → 400.</td></tr>
89-<tr><td>The gate</td><td>Later than the stored <code>sourceReadTime</code> (or none stored) → apply, and <strong>always advance <code>sourceReadTime</code>, even when nothing else changes</strong> (result <code>unchanged</code>; <code>updatedAt</code> moves only when content does) — otherwise an A→B→A delivered out of order would end on B. Equal or earlier → <code>stale</code>, nothing written.</td></tr>
90-<tr><td><code>member</code></td><td><code>{memberId, snapshot}</code> or <code>{memberId, tombstone:true}</code>. <code>memberId</code> must match Membership Manager's own pattern (<code>m_</code> + a version-4 UUID).</td></tr>
91-<tr><td><code>snapshot</code> — rebuilt from allowed keys, never copied and trimmed</td><td>
92-<code>name</code>, <code>email</code>: a string, trimmed, else <code>null</code> · <code>emailLower</code>: <code>email</code> lowercased, or <code>null</code> · <code>memberSince</code>: a valid <code>YYYY-MM-DD</code>, else <code>null</code> · <code>phoneLast4</code>: Membership Manager's own phone rule (<code>formatPhone</code>: 10 digits, or 11 starting with 1) → its last 4, else <code>null</code> · <code>retired</code>: <code>true</code> only if the source is exactly <code>true</code> · <code>stage</code>: one of the six known stages, else <code>"!malformed"</code> · <code>scheduledPause</code>: <code>null</code>, or <code>{startDate, endDate, processed}</code>, or <code>"!malformed"</code> if not an object · <code>pauseHistory</code>: <code>[]</code>, or a list whose entries are <code>{startDate, endDate, priorTerm?}</code> (legacy <code>start</code>/<code>end</code> mapped, the modern value winning) or <code>"!malformed"</code>, or <code>"!malformed"</code> if not a list · <code>scheduledCancellation</code>: <code>null</code>, or <code>{finalAccessDate}</code>, or <code>"!malformed"</code> if not an object · every date: a valid <code>YYYY-MM-DD</code> as-is, missing or <code>null</code> → absent, anything else → <code>"!malformed"</code> (never raw text); the legacy mapping uses a modern value only when it isn't <code>null</code>/missing · <code>priorTerm</code>: present only as <code>true</code> · <code>processed</code>: <code>true</code> when the source <code>scheduledAt</code> is present (a non-empty value — Membership Manager's own test; real values are ISO strings), else <code>false</code> (Q6).</td></tr>
93-<tr><td>Status</td><td>Only <code>deriveStatus</code>. Its precedence stays: a removed/retired record is <code>removed</code> and onboarding/touring is <code>not_yet</code> before any malformed pause data is looked at — so the fixtures are stage-qualified.</td></tr>
94-<tr><td><code>members/{memberId}</code> (stored)</td><td>The snapshot fields + <code>memberId</code>, <code>firstName</code> (first word of <code>name</code>), <code>lastInitial</code> (first letter of the last word, or <code>null</code>), <code>status</code>, <code>statusDate</code> (the Denver date it was derived for), <code>sourceReadTime</code>, <code>updatedAt</code>, <code>tombstone:false</code>.</td></tr>
95-<tr><td><code>memberProfiles/{memberId}</code> (stored; Phase F lets the member read it)</td><td><code>{memberId, firstName, name, email, status, memberSince, pause, finalAccessDate, updatedAt}</code>. <code>pause</code> = the valid, processed window containing today (Denver), else the earliest valid processed window starting after today, else <code>null</code>, as <code>{startDate, endDate}</code>; <code>finalAccessDate</code> only if valid. <strong>No malformed marker and no phone digits ever reach it.</strong> Date-dependent, so the recompute rewrites it too.</td></tr>
96:<tr><td><code>staff</code></td><td><code>{uid, staff: {name, role}}</code> — <strong>sent only for granted users</strong> — or <code>{uid, tombstone:true}</code>. Granted = <code>role</code> exactly <code>admin</code>|<code>manager</code>|<code>staff</code>, <code>active</code> absent or <code>true</code>, <code>appAccess</code> absent or a list of strings, and (role manager/admin, or <code>appAccess</code> contains <code>my-clay-hub</code>). A deleted, ungranted or malformed users doc → a tombstone envelope; malformed also logs an error naming the uid only (it repeats each reconcile until fixed — accepted). Never email, PIN or <code>appAccess</code>.</td></tr>
97:<tr><td><code>staffRoster/staff_{uid}</code> (stored)</td><td><code>{uid, name, role, sourceReadTime, updatedAt, tombstone:false}</code>. The receiver ignores a tombstone for a uid it doesn't hold, so no roster doc is ever created for someone never granted.</td></tr>
98:<tr><td><code>reconcile</code></td><td><code>{scope:'members', items:[member entries], held:[memberId]}</code> or <code>{scope:'staff', items:[granted staff entries]}</code> — the complete set at one readTime. <strong>Sender:</strong> every live source doc needs a valid memberId; a memberId with more than one live doc goes into <code>held</code> (ids only); a live doc with a missing or malformed memberId aborts the whole member reconcile (nothing sent, error logged). <strong>Receiver:</strong> duplicate ids across <code>items</code>/<code>held</code> → 400; <code>held</code> ids are neither updated nor removed and are left out of every denominator; a held record whose <code>sourceReadTime</code> is at or after the batch's readTime is never removed (a newer trigger already landed).</td></tr>
99:<tr><td>Tombstones (stored)</td><td>Replace the document. <code>members</code>: the last stored snapshot fields <strong>minus <code>email</code>, <code>emailLower</code> and <code>phoneLast4</code></strong> (Q7), plus <code>{memberId, firstName, lastInitial, tombstone:true, status:'removed', statusDate, sourceReadTime, updatedAt}</code>; if nothing was ever stored for that memberId, only those last fields. <code>memberProfiles</code>: <code>{memberId, tombstone:true, status:'removed', updatedAt}</code>. <code>staffRoster</code>: <code>{uid, tombstone:true, sourceReadTime, updatedAt}</code>. A later live record replaces it with the full allowlist again. (Vault copies taken earlier keep the email and phone digits until the 56-day retention ages them out — noted in DATA-RESTORE.)</td></tr>
100-<tr><td>Responses</td><td>200 <code>{result: applied|unchanged|stale}</code>; 400 malformed envelope; 409 a reconcile stopped by a threshold. <strong>Terminal for the sender: only 200, 400 and 409</strong> (400 also logs an error: the two repos disagree). Everything else — 401/403/404, 429, 5xx, timeouts — throws, so the trigger is retried.</td></tr>
101-<tr><td>Logging</td><td>Never request bodies, names, emails, phone digits, notes or source documents — only memberId/uid, kind, result and counts.</td></tr>
102-</table>
103-
104-<h2 id="settings">Functions and their settings</h2>
105-<p>All in <code>us-central1</code>, <code>minInstances</code> 0, ingress <code>ALLOW_ALL</code> (as the canary; access is by IAM). The guard checks that every limit is set and that the live service equals the sealed manifest; the values themselves are pinned by a unit test in each codebase (limits aren't in <code>declarations.json</code>).</p>
106-<table>
107-<tr><th>Function</th><th>Project / codebase</th><th>Trigger (declaration)</th><th>Runs as</th><th>timeoutSeconds / memory / cpu / concurrency / maxInstances</th></tr>
--
121-<ol>
122-  <li>Christie's answers to Q1–Q9 → DECISIONS rows in my-clay-hub; SPEC.md (§3: the recompute time) and DATA-MODEL.md (the contract, the never-copy list, tombstones; correct "written only by ingestMemberUpdate" — the recompute writes status and profile fields too) in one docs PR.</li>
123-  <li>If Q6 = B: <code>deriveStatus</code> checks a <code>scheduledPause</code> in this order — non-object → malformed (<code>review</code>); object with <code>processed !== true</code> → ignored; otherwise as today (history entries unchanged). Its own small PR in <code>shared/</code>, with tests (processed, unprocessed, malformed container, malformed date with <code>processed:true</code>, legacy) under all three time zones, and its own review — before E-1 freezes the fixtures.</li>
124-</ol>
125-</div>
126-
127-<div class="phase">
128-<h3>E-0 — studio-hub: the users-rules pins <span class="status-tag ready">execution-ready: true</span></h3>
129:<p>A comment on the <code>users</code> rules naming My Clay Hub's dependency (<code>name</code>, <code>role</code>, <code>active</code>, <code>appAccess</code>). Tests only for what isn't covered (rules.test.js already pins self-granted appAccess and studios): role self-promotion on create (<code>manager</code>, <code>admin</code>), and <code>active</code> on self-update. Released through studio-hub's rules guard (free, sha phrase) <strong>before</strong> E-3 or E-4 merge.</p>
130-<div class="bdd">Given a signed-in user with no users doc
131:When they create their own doc with role 'manager' (or 'admin')
132-Then the write is denied
133-
134-Given a staff user
135-When they update their own doc changing active
136-Then the write is denied</div>
137-</div>
138-
139-<div class="phase">
140-<h3>E-1 — The contract as fixtures (both repos) <span class="status-tag ready">execution-ready: true</span></h3>
141:<p>One fixture set — source docs (every forbidden field at every nesting level; both pause spellings; <code>priorTerm</code>; processed and unprocessed pauses; malformed dates, stages, containers and memberIds, each stage-qualified; phones of every shape; users docs granted, ungranted, demoted, malformed; conflicts for <code>held</code>) and the exact envelopes and stored documents they must produce — committed byte-identical in both repos, with a test in each pinning its sha-256.</p>
142-</div>
143-
144-<div class="phase">
145-<h3>E-2 — my-clay-hub: the receiving side (codebase <code>members</code>) <span class="status-tag ready">execution-ready: true</span></h3>
146-<ul>
147:  <li><strong><code>ingestMemberUpdate</code></strong> — <code>member</code>/<code>staff</code>: one transaction: read the target doc(s), apply the gate, derive status from the snapshot's source shape, write <code>members</code> + <code>memberProfiles</code> (or <code>staffRoster</code>), or replace them with tombstones.</li>
148-  <li><strong><code>reconcile</code></strong> — validate the whole batch, then <strong>everything inside one transaction, redone from scratch on a retry</strong>: read every target and any override; for each item apply the gate; <strong>source-driven status change</strong> = <code>deriveStatus(stored source shape, today)</code> ≠ <code>deriveStatus(incoming source shape, today)</code> (both for today's Denver date — never compared with the stored, possibly day-old status); removals = live records held, not in <code>items</code>, not in <code>held</code>, with <code>sourceReadTime</code> older than the batch's readTime; apply Q8 (denominators = live held records minus <code>held</code> ids). Pass → write: a record whose <strong>whole snapshot</strong> is unchanged gets only its <code>sourceReadTime</code> advanced (the reconcile never writes a date-driven status — that's the recompute's, and a recompute stop isn't overridden); a record with any snapshot change (a name or email edit included) gets its new snapshot, status and profile. "Source shape" means only the fields <code>deriveStatus</code> reads and is used only for the status comparison. A tombstoned member who reappears counts as an addition, not a status change. Fail → nothing written, 409, and the log lists the counts and the affected <strong>ids</strong> (no personal data) so Christie can check them.</li>
149-  <li><strong>Overrides</strong> — collection <code>linkOverrides/{id}</code> (deny-all rule and rules test; Console only): exact keys per scope — <code>members</code>: <code>{scope, maxStatusChanges?, maxRemovals?, expiresAt, usedAt: null}</code> with at least one limit (an omitted limit keeps its normal Q8 value); <code>staff</code>: <code>{scope, maxRemovals, expiresAt, usedAt: null}</code>; <code>recompute</code>: <code>{scope, maxStatusChanges, expiresAt, usedAt: null}</code>. Integers 0–249; <code>expiresAt</code> a Timestamp no more than 24 h after the document's own Firestore <code>createTime</code> (refused otherwise); <code>usedAt</code> becomes a server timestamp when consumed. More than one unused, unexpired override for a scope → refuse all of them (error line) rather than choose. An override is used <strong>only when the normal limits would stop the run</strong> and its counts fit it; it's then consumed (<code>usedAt</code>) in the same transaction, and logs an error line naming the override id, scope, limits and counts — so every use emails Christie.</li>
150-  <li><strong><code>recomputeStatuses</code></strong> (09:30 UTC) — <strong>one transaction</strong> over every live member (above 249 → nothing written, error; alert from 200): re-derive status and the profile's <code>pause</code> for today's Denver date; count only <strong>unexplained</strong> changes — a change is explained when a pause start, a pause end + 1 day or a final-access date + 1 day falls after the member's stored <code>statusDate</code> and on or before today (each member stores <code>statusDate</code>, the Denver date its status was last derived for), so a busy 1st never stops it; over Q8's limit → write nothing, error log; otherwise write every changed <code>members.status</code> and profile together. A transaction retry recomputes everything, so an ingest that lands in between is never overwritten. It never blocks the reconcile, and the reconcile never applies the date-driven changes it stopped.</li>
151:  <li><strong><code>firestore.rules</code></strong>: explicit deny-all blocks for <code>members</code>, <code>memberProfiles</code>, <code>staffRoster</code>, <code>linkOverrides</code> with rules tests (<code>linkOverrides</code> stays deny-all for every client permanently — Phase F's manager settings never reach it); released through the rules guard <em>before</em> the function.</li>
152-  <li>Declarations, iam-expectations (<code>ingest@</code> and its custom role), a FUNCTIONS-ROLLBACK section with the stop/resume runbook and "what to do when a stop email arrives".</li>
153-</ul>
154-<p><strong>Tests first</strong> (emulator, Node 22): every fixture; the gate (earlier, equal, same millisecond with different nanos, malformed) and <strong>A→B→A out of order, single and through a reconcile</strong>; tombstones keep the last name and dates but drop email, emailLower and phoneLast4 (Q7); re-appearance restores the full allowlist; every D4 row through the real <code>deriveStatus</code>, stage-qualified; reconcile: exact thresholds and small denominators, additions, already-tombstoned, <code>held</code> ids untouched, duplicate ids → 400, a stop leaving every collection untouched, a removal racing a newer trigger (members <em>and</em> staff), source-driven counting (an unrelated edit on a pause's first day counts 0; a status-changing edit on a date boundary counts 1), an unchanged record advancing only <code>sourceReadTime</code>, a name-only change applied by the reconcile with 0 status changes, a reappearing member counted as an addition, the recompute ignoring changes its dates explain (a 1st with 15 pause starts doesn't stop) and stopping on unexplained ones, an override not consumed by a run that would have passed anyway, a transaction retry recomputing the counts, overrides (scope, bounds, expiry, single use, its error line, the 249 cap); recompute: one source change vs date changes, the stop with zero writes, a race with ingest in both orders, profiles' <code>pause</code> moving at a window boundary; staff: grant, ungrant, demotion, malformed, a tombstone for a never-held uid writes nothing, more than 1 removal stops; rules deny every client operation; no log contains a fixture's name, email or phone.</p>
155-<div class="bdd">Given members/m_7Q holds A with sourceReadTime T1
156-When envelopes for B (read T2) and A again (read T3) arrive T3 first, then T2
157-Then members/m_7Q ends at A with sourceReadTime T3
158-
159-Given a reconcile whose held list contains m_7Q (two live source docs)
--
186-  <li>OIDC token from the metadata server, audience = the ingest URL constant; terminal responses only 200/400/409.</li>
187-  <li><code>functions/</code> sits under studio-hub's Netlify publish root and would be served with Tinker HQ — the code holds no secrets (accepted, as for the rules and scripts already there); <code>node_modules</code> is never committed.</li>
188-</ul>
189-<p><strong>Tests first</strong> (Firestore emulator on non-default ports for the source; ingest faked): every fixture; late and duplicate deliveries; delete and re-create in both orders; an email change with the retired-old event before and after the new one; conflicts → <code>held</code> in a reconcile, nothing sent on a trigger; a live doc with a missing memberId aborts the reconcile; memberId A→B and A→B→C; a doc with no <code>retired</code> field is live; a partial read; 200/400/409 return normally, 401/403/404/429/5xx/timeout throw; 120 re-saved members with one real change → one envelope that changes a copied field; no write API is used (a test); no log holds personal data.</p>
190-<div class="bdd">Given Jane changes email: jane@new written live and jane@old retired in one batch
191-When the two events arrive old-first, new-first, or one is retried later
192-Then every envelope sent for her memberId describes the one live doc, jane@new
193-
194:Given a users doc with role 'Manager' (wrong case) and appAccess containing 'my-clay-hub'
195-When it is saved
196-Then a tombstone envelope is sent and an error names only the uid
197-
198-Given ingest answers 403
199-When a trigger sends an envelope
200-Then the function throws, so Eventarc retries it</div>
201-</div>
202-
--
226-  <li><strong>K13</strong>: Christie removes the Compute account's project-wide <code>run.invoker</code> and <code>eventarc.eventReceiver</code> (the CLI's F13 grants, made only on a codebase's first event release — they come back if the triggers are ever deleted and recreated; noted in the rollback runbook).</li>
227-  <li><strong>Pub/Sub Token Creator reading</strong>: the Pub/Sub service agent holds <code>iam.serviceAccountTokenCreator</code> (the CLI adds it). If it's missing: stop here and ask Christie — a narrowly scoped grant is a recorded decision, not an improvisation.</li>
228-</ol>
229-</div>
230-
231-<div class="phase">
232-<h3>E-8 — First fill, then delivery, proof, attest, spot check, fresh vault copy <span class="status-tag ready">execution-ready: true</span></h3>
233-<ol>
234:  <li><strong>First fill:</strong> Force run the paused <code>reconcileLink</code> (Christie clicks; logged; first confirm in the Console that a paused job can be Force run — if not, resume it, Force run, pause again). This is the first authenticated cross-project call and the first data. Counts match Membership Manager (live members; managers/admins in <code>staffRoster</code>).</li>
235-  <li><strong>Q9</strong>: Christie grants <code>run.invoker</code> to <code>clayhub-link@</code> on the two trigger services only. Events retried since the release now run: each re-reads its source, so it lands as <code>unchanged</code> or <code>applied</code>. The trigger-service 4xx alert fired as expected from the release until this grant.</li>
236-  <li><strong>Delivery proof after K13 removal:</strong> Christie saves one member in Membership Manager. Evidence, all three: the trigger's execution log timestamped after the removal, ingest's 200 for that memberId, and its stored <code>sourceReadTime</code> later than the removal. If it fails: <strong>stop the link</strong> (runbook) and re-plan — never restore broad grants.</li>
237-  <li>Resume <code>reconcileLink</code>; readings; <code>--attest</code> (needs the job ENABLED, Q9's invoker lists, Token Creator, and no K13 grants).</li>
238-  <li>Spot check three members (active; paused or with pause history; offboarding/cancelled if any) against Membership Manager: status, dates, and no forbidden field or malformed marker in any profile.</li>
239-  <li>Force run the vault export (fine once #64 is live) and verify the new complete folder — the first off-project copy with real member data. The vault plan's restore rehearsal follows.</li>
240-</ol>
241-</div>
242-
--
299-</table>
300-
301-<h3>Round 2 (Oct 8) — Codex "not ready" (5 blocking); Claude "ready after fixes" (3 blocking)</h3>
302-<table>
303-<tr><th>Finding</th><th>Resolution (v3)</th></tr>
304-<tr><td>A conflicted or malformed source set can make the reconcile remove the wrong member (both, blocking)</td><td>The reconcile carries <code>held</code> conflicts; a missing/malformed memberId aborts the member reconcile; the receiver rejects duplicates, never touches <code>held</code>, never removes a record newer than the batch.</td></tr>
305-<tr><td>"Unchanged" must advance <code>sourceReadTime</code> (Claude, blocking)</td><td>The gate row: every applied envelope advances it; A→B→A tests.</td></tr>
306-<tr><td>Event triggers have no invoker in the design (Claude, blocking; confirmed in the CLI source)</td><td>F13; Q9; declared invoker lists for event triggers, attested; E-7 step 4.</td></tr>
307:<tr><td>Staff rule inconsistent; thresholds unsafe for a small roster (Codex, blocking; Claude should-fix)</td><td>Only granted staff are sent; tombstones for never-held uids write nothing; a staff stop at more than 1 removal.</td></tr>
308-<tr><td>Contract not exact: types, nulls, profiles, tombstones (Codex, blocking; Claude should-fix)</td><td>The contract: every field's type and fallback; <code>memberProfiles</code> and its pause rule; three tombstone schemas; malformed canonicalized (no raw text crosses); <code>processed</code> for Q6.</td></tr>
309-<tr><td>Recompute not atomic (Codex, blocking)</td><td>One transaction (≤ 250 members), status and profile together, retry recomputes.</td></tr>
310-<tr><td>Settings table incomplete / wrong names (Codex, blocking; Claude should-fix)</td><td>Rewritten with the guard's exact keys and every limit; values pinned by unit tests.</td></tr>
311-<tr><td>Should-fix: 401/403 swallowed; stop runbook vs scheduler attestation; a stop cascading; the K13 failure path; Pub/Sub Token Creator; E-7 order vs attestation; E-8 proof that could pass vacuously; first-fill exemption redundant; rules port 8080 and <code>firebase.json</code>; E-0 sequencing; Netlify publish root; alert channel in tinker-hq-apps; 250-member cap; clayhub-link@ reading in my-clay-hub; phone rule</td><td>Responses row; the runbook (recompute keeps running); source-driven counting and <code>settings/linkLimits</code>; "stop and re-plan"; E-3 attestation; E-7/E-8 reordered (pause, Q9, K13, first fill, proof, then attest); evidence-based proof; exemption dropped; E-3 isolation test; E-0 first; E-4 note; E-5 step 2; settings note; E-6; <code>formatPhone</code>.</td></tr>
312-</table>
313-
314-<h3>Round 3 (Oct 8) — Codex "not ready" (2 blocking); Claude "ready after fixes" (0 blocking; its first attempt hit a usage limit and was re-run)</h3>
315-<table>
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-12vcgxkJ' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-AXQz3tcL' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-YqeggbVB' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-wC9lCw6o' (errno=Operation not permitted)
4	4	firestore.rules
4	3	rules.test.js
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-lRbYEW4Z' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-7F25wg3O' (errno=Operation not permitted)
diff --git a/firestore.rules b/firestore.rules
index 2ad2c4a..6e9998d 100644
--- a/firestore.rules
+++ b/firestore.rules
@@ -111,10 +111,10 @@ service cloud.firestore {
     match /users/{userId} {
~
       // My Clay Hub depends on these (Phase E): the clayhub-link functions read each users doc's
~
       // role, active and appAccess to decide who is in my-clay-hub's staffRoster (who can use its
~
       // /staff screens), and store only name and role there. 
-So no one may raise their own role,
~
-      // grant themselves appAccess, or change their own active: staff
+Staff
  and managers can't 
-touch
~
-      // any of the three on
+change
  their
~
       
+//
  own 
-doc; an
+role, active or appAccess, so they can't put themselves in. An
  admin can't change their
-own active, and changing
~
       // 
+own active; they can edit
  their own role 
-or appAccess can only demote
+and appAccess, but that never gives
  them 
-(admins are
+more
~
+      // My Clay Hub access than an admin
  already 
-granted).
+has (it keeps it or removes it).
  name is
~
       // self-editable and display-only there. Pinned by rules.test.js "Users — fields My Clay Hub
~
       // relies on"; loosening any of this changes who is staff in My Clay Hub too.
~
       // Own doc read — all authenticated users (auth guard requires it). Not the reminder bot: its
~
diff --git a/rules.test.js b/rules.test.js
index b4e5457..f80cb42 100644
--- a/rules.test.js
+++ b/rules.test.js
@@ -911,9 +911,10 @@ describe('Users — appAccess/studios cannot be self-granted (privilege escalati
 
~
 // ─── USERS — FIELDS MY CLAY HUB RELIES ON (Phase E, E-0) ─────────────────────
~
 // My Clay Hub's staff roster is decided by users docs' role, active and appAccess (it stores name
~
 // and role), so 
-no one
+staff and managers
  may 
-raise
+not change
  their own role, 
-grant themselves appAccess,
+active
  or 
-change their own
+appAccess (an admin's
~
 // 
-active.
+own edits can't add My Clay Hub access an admin doesn't already have).
  appAccess/studios
~
+//
  self-grants are pinned above, archived self-reactivation and an admin's
-//
  own active below; these
~
+//
  pin what wasn't covered.
~
 describe('Users — fields My Clay Hub relies on (no self-promotion, no self-set active)', () => {
~
   test('a brand-new user CANNOT self-create as manager', async () => {
~
     const db = getDb('brand-new-uid-mgr');
~

codex
The commit is comment-only: four lines replaced in `firestore.rules` and the corresponding test-suite commentary, with no predicate or executable test change. I’m narrowing the remaining check to whether “keeps it or removes it” covers every valid/malformed post-edit state under the plan’s exact roster contract.
exec
/bin/zsh -lc 'rg -n -i "granted|grant rule|only granted|role.*staff|appAccess.*list|list of strings|absent.*true|active.*true|my-clay-hub.*appAccess|appAccess.*my-clay-hub" /Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html' in /Users/christiehubley/studio-hub
 succeeded in 0ms:
47:  <li><strong>IAM inventory (D11)</strong>: <code>clayhub-link@tinker-hq-apps</code> = a custom read-only Firestore role (get, list) + <code>eventarc.eventReceiver</code>; <code>ingestmemberupdate</code> is <code>invoker</code>: exactly <code>clayhub-link@tinker-hq-apps</code> (declared; the CLI sets it — never granted by hand); <code>ingest@my-clay-hub</code> = custom role get/list/create/update, no delete. Called at the service's exact run.app URL with an OIDC token from the metadata server.</li>
58:<tr><td>F5</td><td><code>users/{uid}</code>: the link uses only <code>name</code>, <code>role</code>, <code>active</code>, <code>appAccess</code>. Docs carry other fields too (<code>email</code>, <code>createdAt</code>, <code>pin</code>, …), and admins can write other users' docs, so the rules don't guarantee shapes: the link must fail closed on anything unexpected. Missing <code>active</code> means true. Managers/admins are saved with <code>appAccess: []</code>. The <code>my-clay-hub</code> key doesn't exist yet.</td><td>studio-hub js/app.js:148-155, 1144-1145, 1339-1347; firestore.rules:24-38, 67-73, 111-187</td></tr>
81:<tr><td>Q9 <em>(new, round 2)</em></td><td>The two link triggers need permission to call their own Cloud Run services (F13), and the CLI never grants it. The guard's rule is "never grant run.invoker by hand".</td><td><strong>One recorded exception, per service:</strong> right after E-7's release, you grant <code>run.invoker</code> to <code>clayhub-link@</code> on exactly the two trigger services (<code>onclayhubmemberwritten</code>, <code>onstaffuserwritten</code>) — never project-wide. The guard declares that expected invoker list for event triggers and its attestation checks it (a wrong or extra grant fails). Until it's granted, deliveries are refused and Eventarc retries them (up to 24 h). Alternative: project-level <code>run.invoker</code> for <code>clayhub-link@</code> — simpler, broader, not recommended.</td></tr>
92:<code>name</code>, <code>email</code>: a string, trimmed, else <code>null</code> · <code>emailLower</code>: <code>email</code> lowercased, or <code>null</code> · <code>memberSince</code>: a valid <code>YYYY-MM-DD</code>, else <code>null</code> · <code>phoneLast4</code>: Membership Manager's own phone rule (<code>formatPhone</code>: 10 digits, or 11 starting with 1) → its last 4, else <code>null</code> · <code>retired</code>: <code>true</code> only if the source is exactly <code>true</code> · <code>stage</code>: one of the six known stages, else <code>"!malformed"</code> · <code>scheduledPause</code>: <code>null</code>, or <code>{startDate, endDate, processed}</code>, or <code>"!malformed"</code> if not an object · <code>pauseHistory</code>: <code>[]</code>, or a list whose entries are <code>{startDate, endDate, priorTerm?}</code> (legacy <code>start</code>/<code>end</code> mapped, the modern value winning) or <code>"!malformed"</code>, or <code>"!malformed"</code> if not a list · <code>scheduledCancellation</code>: <code>null</code>, or <code>{finalAccessDate}</code>, or <code>"!malformed"</code> if not an object · every date: a valid <code>YYYY-MM-DD</code> as-is, missing or <code>null</code> → absent, anything else → <code>"!malformed"</code> (never raw text); the legacy mapping uses a modern value only when it isn't <code>null</code>/missing · <code>priorTerm</code>: present only as <code>true</code> · <code>processed</code>: <code>true</code> when the source <code>scheduledAt</code> is present (a non-empty value — Membership Manager's own test; real values are ISO strings), else <code>false</code> (Q6).</td></tr>
96:<tr><td><code>staff</code></td><td><code>{uid, staff: {name, role}}</code> — <strong>sent only for granted users</strong> — or <code>{uid, tombstone:true}</code>. Granted = <code>role</code> exactly <code>admin</code>|<code>manager</code>|<code>staff</code>, <code>active</code> absent or <code>true</code>, <code>appAccess</code> absent or a list of strings, and (role manager/admin, or <code>appAccess</code> contains <code>my-clay-hub</code>). A deleted, ungranted or malformed users doc → a tombstone envelope; malformed also logs an error naming the uid only (it repeats each reconcile until fixed — accepted). Never email, PIN or <code>appAccess</code>.</td></tr>
97:<tr><td><code>staffRoster/staff_{uid}</code> (stored)</td><td><code>{uid, name, role, sourceReadTime, updatedAt, tombstone:false}</code>. The receiver ignores a tombstone for a uid it doesn't hold, so no roster doc is ever created for someone never granted.</td></tr>
98:<tr><td><code>reconcile</code></td><td><code>{scope:'members', items:[member entries], held:[memberId]}</code> or <code>{scope:'staff', items:[granted staff entries]}</code> — the complete set at one readTime. <strong>Sender:</strong> every live source doc needs a valid memberId; a memberId with more than one live doc goes into <code>held</code> (ids only); a live doc with a missing or malformed memberId aborts the whole member reconcile (nothing sent, error logged). <strong>Receiver:</strong> duplicate ids across <code>items</code>/<code>held</code> → 400; <code>held</code> ids are neither updated nor removed and are left out of every denominator; a held record whose <code>sourceReadTime</code> is at or after the batch's readTime is never removed (a newer trigger already landed).</td></tr>
129:<p>A comment on the <code>users</code> rules naming My Clay Hub's dependency (<code>name</code>, <code>role</code>, <code>active</code>, <code>appAccess</code>). Tests only for what isn't covered (rules.test.js already pins self-granted appAccess and studios): role self-promotion on create (<code>manager</code>, <code>admin</code>), and <code>active</code> on self-update. Released through studio-hub's rules guard (free, sha phrase) <strong>before</strong> E-3 or E-4 merge.</p>
141:<p>One fixture set — source docs (every forbidden field at every nesting level; both pause spellings; <code>priorTerm</code>; processed and unprocessed pauses; malformed dates, stages, containers and memberIds, each stage-qualified; phones of every shape; users docs granted, ungranted, demoted, malformed; conflicts for <code>held</code>) and the exact envelopes and stored documents they must produce — committed byte-identical in both repos, with a test in each pinning its sha-256.</p>
194:Given a users doc with role 'Manager' (wrong case) and appAccess containing 'my-clay-hub'
307:<tr><td>Staff rule inconsistent; thresholds unsafe for a small roster (Codex, blocking; Claude should-fix)</td><td>Only granted staff are sent; tombstones for never-held uids write nothing; a staff stop at more than 1 removal.</td></tr>

codex
No findings.

Commit `047a84e` changes comments only; Firestore rule logic and tests remain unchanged. The revised wording accurately matches the plan’s grant contract:

- An active admin is already granted regardless of `appAccess`.
- Their own `active` field is pinned unchanged.
- Editing their own role/appAccess can only preserve access or produce an ungranted/malformed state.
- Staff and managers cannot change their own role, active, or appAccess.

SAFE TO MERGE
tokens used
29,778
No findings.

Commit `047a84e` changes comments only; Firestore rule logic and tests remain unchanged. The revised wording accurately matches the plan’s grant contract:

- An active admin is already granted regardless of `appAccess`.
- Their own `active` field is pinned unchanged.
- Editing their own role/appAccess can only preserve access or produce an ungranted/malformed state.
- Staff and managers cannot change their own role, active, or appAccess.

SAFE TO MERGE
