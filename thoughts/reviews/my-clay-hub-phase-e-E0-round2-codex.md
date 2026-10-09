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
session id: 01a1211a-6f72-7642-a4bb-c3bb5369e560
--------
user
Round 2 of the E-0 review. Your round-1 findings: (1) comment said all four fields are copied; (2) the 'never set own role/appAccess' claim was false for admins; (3) self-create can include active. Check the fix commit 00d5fd2 (diff below) resolves them accurately against firestore.rules and the plan ~/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html. Rule logic must be unchanged. Read-only. End with exactly SAFE TO MERGE or NOT SAFE TO MERGE.
diff --git a/firestore.rules b/firestore.rules
index c928f98..2ad2c4a 100644
--- a/firestore.rules
+++ b/firestore.rules
@@ -109,12 +109,14 @@ service cloud.firestore {
     // ═══════════════════════════════════════════════════════════════
 
     match /users/{userId} {
-      // My Clay Hub depends on these (Phase E): the clayhub-link functions copy each users doc's
-      // name, role, active and appAccess to my-clay-hub's staffRoster, which decides who can use
-      // its /staff screens. So a person must never be able to set their own role, active or
-      // appAccess (name is self-editable and is display-only there). Pinned by rules.test.js
-      // "Users — fields My Clay Hub relies on"; loosening any of them changes who is staff in
-      // My Clay Hub too.
+      // My Clay Hub depends on these (Phase E): the clayhub-link functions read each users doc's
+      // role, active and appAccess to decide who is in my-clay-hub's staffRoster (who can use its
+      // /staff screens), and store only name and role there. So no one may raise their own role,
+      // grant themselves appAccess, or change their own active: staff and managers can't touch
+      // any of the three on their own doc; an admin can't change their own active, and changing
+      // their own role or appAccess can only demote them (admins are already granted). name is
+      // self-editable and display-only there. Pinned by rules.test.js "Users — fields My Clay Hub
+      // relies on"; loosening any of this changes who is staff in My Clay Hub too.
       // Own doc read — all authenticated users (auth guard requires it). Not the reminder bot: its
       // grant is GET-only below, and this `read` would let an id-constrained LIST through.
       allow read: if isAuthenticated() && request.auth.uid == userId && !isReminderBot();
diff --git a/rules.test.js b/rules.test.js
index d2570a3..b4e5457 100644
--- a/rules.test.js
+++ b/rules.test.js
@@ -910,9 +910,10 @@ describe('Users — appAccess/studios cannot be self-granted (privilege escalati
 // BDD scenarios from thoughts/plans/archive-employees.html, Phase 1.
 
 // ─── USERS — FIELDS MY CLAY HUB RELIES ON (Phase E, E-0) ─────────────────────
-// My Clay Hub's staff roster is copied from users docs (name, role, active, appAccess), so no one
-// may set their own role, active or appAccess. appAccess/studios self-grants are pinned above and
-// archived self-reactivation below; these pin what wasn't covered.
+// My Clay Hub's staff roster is decided by users docs' role, active and appAccess (it stores name
+// and role), so no one may raise their own role, grant themselves appAccess, or change their own
+// active. appAccess/studios self-grants are pinned above, archived self-reactivation and an admin's
+// own active below; these pin what wasn't covered.
 describe('Users — fields My Clay Hub relies on (no self-promotion, no self-set active)', () => {
   test('a brand-new user CANNOT self-create as manager', async () => {
     const db = getDb('brand-new-uid-mgr');
codex
I’ll verify the commit against the actual rule branches, the complete E-0 tests, and the Phase E plan. I’ll keep this strictly read-only and also confirm the commit contains comment/test-description changes only.
exec
/bin/zsh -lc "git status --short && git show --stat --oneline --decorate --no-renames 00d5fd2 && git show --format=fuller --no-ext-diff --no-renames 00d5fd2 -- firestore.rules rules.test.js && sed -n '1,260p' \""'$HOME/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html"' in /Users/christiehubley/studio-hub
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-RxIowxSo' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-gTIPP5c6' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-ou6FQILS' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-0P7ajuGZ' (errno=Operation not permitted)
00d5fd2 (HEAD -> mch-e0-users-pins) docs(rules): E-0 review round 1 — the comment says what the link reads vs stores, and that an admin's own role/appAccess change can only demote
 firestore.rules | 14 ++++++++------
 rules.test.js   |  7 ++++---
 2 files changed, 12 insertions(+), 9 deletions(-)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-ItU00GUU' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-xgsaDKkW' (errno=Operation not permitted)
commit 00d5fd296f1d88469ca4ea7de18c09dc416e6f46
Author:     Christie Hubley <christie@tinkerartstudio.com>
AuthorDate: Fri Oct 9 08:38:56 2026 -0600
Commit:     Christie Hubley <christie@tinkerartstudio.com>
CommitDate: Fri Oct 9 08:38:56 2026 -0600

    docs(rules): E-0 review round 1 — the comment says what the link reads vs stores, and that an admin's own role/appAccess change can only demote
    
    Codex (not safe: comment wording) + Claude (safe, same nits). No rule logic change.
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/firestore.rules b/firestore.rules
index c928f98..2ad2c4a 100644
--- a/firestore.rules
+++ b/firestore.rules
@@ -109,12 +109,14 @@ service cloud.firestore {
     // ═══════════════════════════════════════════════════════════════
 
     match /users/{userId} {
-      // My Clay Hub depends on these (Phase E): the clayhub-link functions copy each users doc's
-      // name, role, active and appAccess to my-clay-hub's staffRoster, which decides who can use
-      // its /staff screens. So a person must never be able to set their own role, active or
-      // appAccess (name is self-editable and is display-only there). Pinned by rules.test.js
-      // "Users — fields My Clay Hub relies on"; loosening any of them changes who is staff in
-      // My Clay Hub too.
+      // My Clay Hub depends on these (Phase E): the clayhub-link functions read each users doc's
+      // role, active and appAccess to decide who is in my-clay-hub's staffRoster (who can use its
+      // /staff screens), and store only name and role there. So no one may raise their own role,
+      // grant themselves appAccess, or change their own active: staff and managers can't touch
+      // any of the three on their own doc; an admin can't change their own active, and changing
+      // their own role or appAccess can only demote them (admins are already granted). name is
+      // self-editable and display-only there. Pinned by rules.test.js "Users — fields My Clay Hub
+      // relies on"; loosening any of this changes who is staff in My Clay Hub too.
       // Own doc read — all authenticated users (auth guard requires it). Not the reminder bot: its
       // grant is GET-only below, and this `read` would let an id-constrained LIST through.
       allow read: if isAuthenticated() && request.auth.uid == userId && !isReminderBot();
diff --git a/rules.test.js b/rules.test.js
index d2570a3..b4e5457 100644
--- a/rules.test.js
+++ b/rules.test.js
@@ -910,9 +910,10 @@ describe('Users — appAccess/studios cannot be self-granted (privilege escalati
 // BDD scenarios from thoughts/plans/archive-employees.html, Phase 1.
 
 // ─── USERS — FIELDS MY CLAY HUB RELIES ON (Phase E, E-0) ─────────────────────
-// My Clay Hub's staff roster is copied from users docs (name, role, active, appAccess), so no one
-// may set their own role, active or appAccess. appAccess/studios self-grants are pinned above and
-// archived self-reactivation below; these pin what wasn't covered.
+// My Clay Hub's staff roster is decided by users docs' role, active and appAccess (it stores name
+// and role), so no one may raise their own role, grant themselves appAccess, or change their own
+// active. appAccess/studios self-grants are pinned above, archived self-reactivation and an admin's
+// own active below; these pin what wasn't covered.
 describe('Users — fields My Clay Hub relies on (no self-promotion, no self-set active)', () => {
   test('a brand-new user CANNOT self-create as manager', async () => {
     const db = getDb('brand-new-uid-mgr');
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Plan: My Clay Hub Phase E — the live link from Membership Manager</title>
<style>
  body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; max-width: 900px; margin: 2rem auto; padding: 0 1.5rem; color: #1a1a1a; line-height: 1.5; }
  h1 { font-size: 1.55rem; border-bottom: 2px solid #8B30BC; padding-bottom: .5rem; }
  h2 { font-size: 1.15rem; margin-top: 2rem; color: #6052C8; }
  h3 { font-size: 1rem; margin-top: 1.2rem; }
  .meta { background: #f5f0ff; border-left: 4px solid #8B30BC; padding: .75rem 1rem; border-radius: 4px; margin: 1rem 0; font-size: .9rem; }
  .phase { border: 1px solid #e5e7eb; border-radius: 6px; padding: 1rem 1.25rem; margin: 1rem 0; }
  .phase h3 { margin-top: 0; }
  .bdd { background: #fafafa; border: 1px solid #e5e7eb; border-radius: 4px; padding: .5rem .75rem; margin: .5rem 0; font-size: .88rem; font-family: monospace; white-space: pre-wrap; }
  .note { background: #fffbeb; border-left: 4px solid #f59e0b; padding: .6rem 1rem; border-radius: 4px; font-size: .9rem; margin: .5rem 0; }
  .danger { background: #fef2f2; border-left: 4px solid #dc2626; padding: .6rem 1rem; border-radius: 4px; font-size: .9rem; margin: .5rem 0; }
  code { background: #f3f4f6; padding: .1rem .35rem; border-radius: 3px; font-size: .88rem; }
  table { border-collapse: collapse; width: 100%; margin: .75rem 0; }
  th, td { border: 1px solid #e5e7eb; padding: .4rem .75rem; font-size: .88rem; text-align: left; vertical-align: top; }
  th { background: #f9fafb; }
  .status-tag { display: inline-block; font-size: .75rem; font-weight: 700; padding: .15rem .5rem; border-radius: 999px; }
  .not-ready { background: #fef3c7; color: #92400e; }
  .ready { background: #d1fae5; color: #065f46; }
</style>
</head>
<body>

<h1>Plan: My Clay Hub Phase E — the live link from Membership Manager</h1>

<div class="meta">
  <strong>Goal:</strong> When staff add, edit, pause or offboard a member in Membership Manager, My Clay Hub's own copy of that member (<code>members/{memberId}</code>, with the right derived status) matches within a minute — one way only, carrying only the allowed fields, and safe against late, duplicate or out-of-order deliveries. Staff with My Clay Hub access are mirrored the same way into <code>staffRoster</code>.<br>
  <strong>Repos:</strong> <code>/Users/christiehubley/my-clay-hub</code> (the receiving side) and <code>/Users/christiehubley/studio-hub</code> (the sending side: the <code>clayhub-link</code> functions and <code>tinker-hq-apps</code>' own functions guard). Console/IAM work in both projects is Christie's (no gcloud on the Mac; read-only readings by Claude in her Chrome or via Cloud Shell).<br>
  <strong>Parent:</strong> <code>clayhub-members-foundation.html</code> Phase E (the outline this plan expands), decisions D2, D4, D4a, D11, D21, D22, D23 and the IAM inventory; <code>firebase-functions-deploy-guard.html</code> (M1, F13, K10, K11, K13, the round-1 "retry approval" finding); <code>my-clay-hub-d4-vault-export.html</code> (the gate).<br>
  <strong>Gate:</strong> no real member data enters <code>my-clay-hub</code> until D-4's V-4 is complete (first complete vault export — Sunday Oct 11's scheduled run). Phases E-1 to E-6 build and test with no real data and may run before the gate; <strong>E-7 (deploying the link) waits for it.</strong><br>
  <strong>Not in this plan:</strong> any screen, sign-in provider or <code>claimMembership</code> (Phase F); the Tinker HQ tile and the Manage Team <code>my-clay-hub</code> box (Phase F); "change email" in Membership Manager (B4, its own plan); <code>kioskLookup</code>; any write back to Membership Manager (never, D6).<br>
  <strong>Risk:</strong> <strong>HIGH.</strong> The first Cloud Functions ever in <code>tinker-hq-apps</code>, the project every staff app shares; real member personal data crossing projects for the first time; IAM changes in both projects, including one Google makes on its own (K13).<br>
  <strong>Size:</strong> roughly 2 weeks at the D-4 cadence (several review rounds per PR). Christie's hands-on time ≈ 6–10 h (decisions, Console/IAM steps, approvals, a 3-member spot check).<br>
  <strong>Status:</strong> <span class="status-tag ready">execution-ready: true</span> — v4.1, Oct 8, 2026, after four review rounds (round 4: Codex and Claude both "ready after fixes", 0 blocking; all fixes applied). Christie answered Q1–Q9 on Oct 8 (Q7 changed: removed members keep everything but email and phone digits). <strong>Marked execution-ready (all phases) by Christie, Oct 8.</strong> Next: E-pre (its PR review re-checks the Q7 change).
</div>

<h2>Already decided (not reopened here)</h2>
<ul>
  <li><strong>D22 "Re-read, then send a snapshot"</strong> (DECISIONS #53): a trigger on <code>clayHub_members/{id}</code> collects the memberId from before and after; for each, one query on <code>memberId</code> only; live = <code>retired !== true</code>; exactly one live doc → its fields; none → tombstone; more than one → conflict, nothing sent, alert. POST <code>{memberId, snapshot, readTime}</code>; ingest drops anything not newer than the stored <code>sourceReadTime</code>, checks the payload strictly, runs <code>deriveStatus</code>, writes, never deletes. The reconcile uses the same envelope, read in one read-only transaction pinned to one readTime. <code>users/{uid}</code> → <code>staffRoster/staff_{uid}</code> the same way (no memberId, no conflict case).</li>
  <li><strong>D4 / D4a / #34</strong>: status comes only from <code>shared/derive-status.js</code>; Denver calendar dates; recomputed for everyone daily.</li>
  <li><strong>#24</strong>: only <code>phoneLast4</code> leaves <code>tinker-hq-apps</code>, worked out there. <strong>#37 / D6</strong>: never write back. <strong>#42</strong>: IAM one-way; ingest can't delete. <strong>#32 / D2 / M1</strong>: the link is codebase <code>clayhub-link</code> in studio-hub, deployed only by <code>tinker-hq-apps</code>' own functions guard; neither guard can reach the other project. <strong>#54 / D23</strong>: 2nd gen, retries on (<code>retry: true</code> on triggers, retryConfig on schedules), explicit maxInstances, Admin app built once per instance; Firestore <code>nam5</code>, Eventarc location <code>nam5</code>, functions <code>us-central1</code>.</li>
  <li><strong>IAM inventory (D11)</strong>: <code>clayhub-link@tinker-hq-apps</code> = a custom read-only Firestore role (get, list) + <code>eventarc.eventReceiver</code>; <code>ingestmemberupdate</code> is <code>invoker</code>: exactly <code>clayhub-link@tinker-hq-apps</code> (declared; the CLI sets it — never granted by hand); <code>ingest@my-clay-hub</code> = custom role get/list/create/update, no delete. Called at the service's exact run.app URL with an OIDC token from the metadata server.</li>
  <li><strong>#63 / #64</strong>: the vault gate; Force runs keyed by the day they run (deploys Monday Oct 12).</li>
</ul>

<h2 id="facts">Facts this plan relies on (research Oct 8; corrected after review round 1)</h2>
<table>
<tr><th>#</th><th>Fact</th><th>Source</th></tr>
<tr><td>F1</td><td><code>clayHub_members</code>: every doc the app writes has a valid <code>memberId</code> (<code>m_</code> + UUID v4; the app can't create a doc without one). The count, 66/66 valid and unique, comes from the dated Sep 28 backup log, not from code. Doc id = email lowercased with <code>/</code> and <code>.</code> → <code>_</code>. <strong>No stored <code>emailLower</code></strong>. Saves write only changed fields; blank top-level fields are stripped.</td><td>clay-hub-membership firebase-data.js:85-94, 155-208; member-status.js:668-682; save-safety plan log</td></tr>
<tr><td>F2</td><td>Source fields the link reads (and nothing else): <code>memberId</code>, <code>email</code>, <code>name</code> (one string), <code>phone</code> (free text), <code>stage</code>, <code>scheduledPause</code> (null or one of three shapes), <code>pauseHistory[]</code> (modern <code>startDate</code>/<code>endDate</code> or legacy <code>start</code>/<code>end</code>; may carry <code>priorTerm</code>), <code>scheduledCancellation.finalAccessDate</code>, <code>memberSince</code>, <code>retired</code>. <strong>The pause and cancellation objects also carry <code>notes</code>, <code>type</code>, <code>lastBilling</code>, <code>processDate</code>, Sawyer and audit fields</strong> — never copied (see the contract).</td><td>app.js:500, 550-560, 935-938, 3540-3651, 3761-3774; member-status.js:32-36, 721-725</td></tr>
<tr><td>F3</td><td>Never copy: <code>keypadCode</code>, <code>keypadUserId</code>, <code>staffNotes</code>, <code>notes</code>, <code>application</code>, <code>actions</code>, the full phone, the shelf fields, billing fields — at any nesting level.</td><td>save-safety plan, "What My Clay Hub's link needs"</td></tr>
<tr><td>F4</td><td>"Change email" (B4) isn't built; nothing writes <code>retired</code> today. Authorized Clay Hub writers can create documents with no rules-level schema or memberId check (so a delete + re-create can carry a new memberId).</td><td>grep; studio-hub firestore.rules:942</td></tr>
<tr><td>F5</td><td><code>users/{uid}</code>: the link uses only <code>name</code>, <code>role</code>, <code>active</code>, <code>appAccess</code>. Docs carry other fields too (<code>email</code>, <code>createdAt</code>, <code>pin</code>, …), and admins can write other users' docs, so the rules don't guarantee shapes: the link must fail closed on anything unexpected. Missing <code>active</code> means true. Managers/admins are saved with <code>appAccess: []</code>. The <code>my-clay-hub</code> key doesn't exist yet.</td><td>studio-hub js/app.js:148-155, 1144-1145, 1339-1347; firestore.rules:24-38, 67-73, 111-187</td></tr>
<tr><td>F6</td><td><code>deriveStatus(source, todayDenver)</code> needs the <em>source shape</em> (<code>stage</code>, <code>scheduledPause</code>, <code>pauseHistory</code>, <code>scheduledCancellation.finalAccessDate</code>, <code>tombstone</code>, <code>retired</code>). It reads every pause entry including <code>priorTerm</code> ones (intended), and turns an unknown stage, a malformed or missing date, or a non-object pause into <code>review</code>. So malformed values must reach it, as values that are still malformed.</td><td>shared/derive-status.js:6-17, 30-35, 74-80; DATA-MODEL.md:86-88</td></tr>
<tr><td>F7</td><td>studio-hub has no functions and no functions guard. Its <strong>rules guard</strong> runs <code>npm test</code> in a worktree and takes <code>firebase.json</code>, <code>package.json</code> and <code>predeploy-check.sh</code> from <code>origin/main</code>'s tip; its backstop accepts only firestore and storage targets; <code>rules.test.js</code> uses the default emulator port 8080 and <code>firebase.json</code> has no emulators block. Anything E-3/E-4 adds there can break every staff app's rules deploy and rollback, and a rules commit made before E-3/E-4 merge must be deployed before they merge (the control files must match the tip).</td><td>studio-hub scripts/deploy-rules.sh:204-209, 348, 406; predeploy-check.sh:22-24; rules.test.js:76</td></tr>
<tr><td>F8</td><td>K13: the first event-triggered deploy grants the default Compute account project-wide <code>run.invoker</code> and <code>eventarc.eventReceiver</code>; a failed deploy still enables APIs and creates service agents. The runtime identity of a trigger and the identity that delivers its events are different things. The CLI prompts before enabling retries on an event trigger. K10 pins <code>EVENTARC_CLOUD_EVENT_SOURCE</code> to my-clay-hub.</td><td>firebase-functions-deploy-guard.html</td></tr>
<tr><td>F9</td><td>The guard requires UTC schedules with all five retry values declared; an empty invoker list is refused; <code>["private"]</code> means no callers.</td><td>predeploy-check.sh:242-249; deploy-functions.sh:184, 358</td></tr>
<tr><td>F10</td><td>One cross-project grant into <code>tinker-hq-vault</code> was accepted (V-1). Organization policies can differ by project, so the <code>run.invoker</code> binding is proven only by E-7's first real call.</td><td>D-4 log, Oct 2</td></tr>
<tr><td>F11</td><td>A code search found no staff-app server code using <code>tinker-hq-apps</code>' default Compute account. That is <em>not</em> enough to change a production account: E-5 adds a workload inventory and an audit-log check.</td><td>grep</td></tr>
<tr><td>F13</td><td><strong>The pinned CLI (15.22.3) and event triggers:</strong> it sends events <em>as the trigger's own runtime account</em> (<code>eventTrigger.serviceAccountEmail</code> = the function's service account), but sets a Cloud Run invoker only for HTTP-style functions, never for event triggers. On the first event release it adds project-wide bindings: <code>run.invoker</code> and <code>eventarc.eventReceiver</code> for the default Compute account, and Token Creator for the Pub/Sub service agent. So <code>clayhub-link@</code> needs <code>run.invoker</code> on its two trigger services, and nothing in the CLI gives it that (Q9).</td><td>firebase-tools lib/gcp/cloudfunctionsv2.js:214-216; lib/deploy/functions/release/fabricator.js:221-253, 345-389; lib/deploy/functions/checkIam.js:104-160</td></tr>
<tr><td>F12</td><td>Firestore IAM can't be limited to one collection: <code>clayhub-link@</code>'s read role covers the whole <code>tinker-hq-apps</code> database (payroll included). Accepted residual: read-only, one runtime, guarded code.</td><td>Firestore IAM model</td></tr>
</table>

<h2 id="open">Questions for Christie — answered Oct 8</h2>
<p class="note"><strong>Christie, Oct 8:</strong> Q1–Q5, Q6 (option B), Q8 and Q9 agreed as recommended; Q7 changed — a removed member keeps everything last known except email and phone digits (row below).</p>
<table>
<tr><th>#</th><th>Question</th><th>Recommendation (both reviewers agree with Q1–Q5)</th></tr>
<tr><td>Q1</td><td>The guard allows only UTC schedules; "3:30 AM Denver" isn't one.</td><td><strong>09:30 UTC daily</strong> = 3:30 AM MDT / 2:30 AM MST: after Denver midnight, before the 5 AM opening, all year. Recorded as a change to SPEC's "3:30 AM" before any code.</td></tr>
<tr><td>Q2</td><td>The <code>tinker-hq-apps</code> functions guard: inside this plan or its own?</td><td><strong>Inside, as E-3: its own branch, PR and review rounds</strong>, treated as the highest-risk PR (it lives next to every staff app's rules guard).</td></tr>
<tr><td>Q3</td><td>K13: Google's first trigger deploy gives the default Compute account project-wide invoke rights in the staff apps' project.</td><td><strong>Audit, neutralize, deploy, remove, then prove.</strong> E-5 inventories every workload and checks recent audit logs before touching the account. After E-7's deploy, remove Google's two grants, and only count it done when a real event is delivered <em>after</em> the removal. The guard's attestation then refuses if they come back.</td></tr>
<tr><td>Q4</td><td>The staff roster, with no My Clay Hub box in Tinker HQ yet.</td><td><strong>Build the machinery now, no Tinker HQ UI.</strong> It mirrors managers/admins until Phase F adds the box. Strict input, fails closed.</td></tr>
<tr><td>Q5</td><td>"Change email" isn't built; a delete + re-create gives a new memberId.</td><td><strong>Treat it as a new identity:</strong> the old memberId becomes a tombstone (<code>removed</code>), the new one starts fresh. B4 stays its own plan.</td></tr>
<tr><td>Q6 <em>(new)</em></td><td>A "Quick Log" pause request (no <code>scheduledAt</code>) is never started by Membership Manager, but <code>deriveStatus</code> treats its dates as a real pause, so My Clay Hub would show the member as <strong>paused</strong> (no booking) for those dates.</td><td><strong>B (both reviewers):</strong> an unprocessed request doesn't stop a paying member booking. The sender sends <code>scheduledPause.processed</code> instead of the timestamp, using Membership Manager's own test (a pause is processed when <code>scheduledAt</code> is present — <code>member-status.js:127-131</code>); <code>deriveStatus</code> first treats a non-object <code>scheduledPause</code> as malformed (<code>review</code>), and only then ignores an object whose <code>processed</code> isn't <code>true</code> (history entries are processed by definition). A <code>deriveStatus</code> change, made and reviewed in E-pre before E-1's fixtures freeze. Option A (count it) needs no change.</td></tr>
<tr><td>Q7 <em>(new)</em></td><td>When a member is removed, does My Clay Hub keep their name, email and phone digits?</td><td><strong>Christie, Oct 8: keep everything last known except the contact details.</strong> A removed member's <code>members</code> doc keeps their name, <code>firstName</code>, <code>lastInitial</code>, <code>memberSince</code>, stage, pause history, scheduled pause and last-day date (useful for history; not sensitive), and drops <code>email</code>, <code>emailLower</code> and <code>phoneLast4</code>. Their member-facing profile reduces to <code>removed</code>. (Membership Manager keeps the full record either way.)</td></tr>
<tr><td>Q8 <em>(new)</em></td><td>The safety stops at 66 members: "10% of statuses" is 7 people, and the 1st of a month can legitimately move that many (pauses starting and ending).</td><td><strong>Members:</strong> stop when status changes &gt; max(ceil(10% × live held), 10) or removals &gt; max(ceil(5% × live held), 4); additions never count; a removal counts only as a removal. <strong>The reconcile counts only source-driven status changes</strong> and <strong>the recompute only changes no pause or last-day date explains</strong>, so a busy 1st of the month stops neither. <strong>Staff:</strong> stop when more than 1 held staff record would be removed. A stop writes nothing and emails you; the runbook says how you let a legitimate large change through (a scoped, single-use, expiring override you create in the Console after checking the listed ids).</td></tr>
<tr><td>Q9 <em>(new, round 2)</em></td><td>The two link triggers need permission to call their own Cloud Run services (F13), and the CLI never grants it. The guard's rule is "never grant run.invoker by hand".</td><td><strong>One recorded exception, per service:</strong> right after E-7's release, you grant <code>run.invoker</code> to <code>clayhub-link@</code> on exactly the two trigger services (<code>onclayhubmemberwritten</code>, <code>onstaffuserwritten</code>) — never project-wide. The guard declares that expected invoker list for event triggers and its attestation checks it (a wrong or extra grant fails). Until it's granted, deliveries are refused and Eventarc retries them (up to 24 h). Alternative: project-level <code>run.invoker</code> for <code>clayhub-link@</code> — simpler, broader, not recommended.</td></tr>
</table>

<h2 id="contract">The link contract (E-1 writes it down once; both sides test against it)</h2>
<table>
<tr><th>Part</th><th>Exact rule</th></tr>
<tr><td>Envelope</td><td><code>{v:1, kind, readTime, …}</code>; <code>kind</code> ∈ <code>member</code> | <code>staff</code> | <code>reconcile</code>. Any other key, version or kind → 400.</td></tr>
<tr><td><code>readTime</code></td><td><code>{seconds: "&lt;decimal string&gt;", nanos: &lt;int 0..999999999&gt;}</code> from the source read's <code>Timestamp</code>, full nanosecond precision; stored as a Firestore <code>Timestamp</code> (<code>sourceReadTime</code>); compared as (seconds, nanos). Out-of-range or non-canonical → 400.</td></tr>
<tr><td>The gate</td><td>Later than the stored <code>sourceReadTime</code> (or none stored) → apply, and <strong>always advance <code>sourceReadTime</code>, even when nothing else changes</strong> (result <code>unchanged</code>; <code>updatedAt</code> moves only when content does) — otherwise an A→B→A delivered out of order would end on B. Equal or earlier → <code>stale</code>, nothing written.</td></tr>
<tr><td><code>member</code></td><td><code>{memberId, snapshot}</code> or <code>{memberId, tombstone:true}</code>. <code>memberId</code> must match Membership Manager's own pattern (<code>m_</code> + a version-4 UUID).</td></tr>
<tr><td><code>snapshot</code> — rebuilt from allowed keys, never copied and trimmed</td><td>
<code>name</code>, <code>email</code>: a string, trimmed, else <code>null</code> · <code>emailLower</code>: <code>email</code> lowercased, or <code>null</code> · <code>memberSince</code>: a valid <code>YYYY-MM-DD</code>, else <code>null</code> · <code>phoneLast4</code>: Membership Manager's own phone rule (<code>formatPhone</code>: 10 digits, or 11 starting with 1) → its last 4, else <code>null</code> · <code>retired</code>: <code>true</code> only if the source is exactly <code>true</code> · <code>stage</code>: one of the six known stages, else <code>"!malformed"</code> · <code>scheduledPause</code>: <code>null</code>, or <code>{startDate, endDate, processed}</code>, or <code>"!malformed"</code> if not an object · <code>pauseHistory</code>: <code>[]</code>, or a list whose entries are <code>{startDate, endDate, priorTerm?}</code> (legacy <code>start</code>/<code>end</code> mapped, the modern value winning) or <code>"!malformed"</code>, or <code>"!malformed"</code> if not a list · <code>scheduledCancellation</code>: <code>null</code>, or <code>{finalAccessDate}</code>, or <code>"!malformed"</code> if not an object · every date: a valid <code>YYYY-MM-DD</code> as-is, missing or <code>null</code> → absent, anything else → <code>"!malformed"</code> (never raw text); the legacy mapping uses a modern value only when it isn't <code>null</code>/missing · <code>priorTerm</code>: present only as <code>true</code> · <code>processed</code>: <code>true</code> when the source <code>scheduledAt</code> is present (a non-empty value — Membership Manager's own test; real values are ISO strings), else <code>false</code> (Q6).</td></tr>
<tr><td>Status</td><td>Only <code>deriveStatus</code>. Its precedence stays: a removed/retired record is <code>removed</code> and onboarding/touring is <code>not_yet</code> before any malformed pause data is looked at — so the fixtures are stage-qualified.</td></tr>
<tr><td><code>members/{memberId}</code> (stored)</td><td>The snapshot fields + <code>memberId</code>, <code>firstName</code> (first word of <code>name</code>), <code>lastInitial</code> (first letter of the last word, or <code>null</code>), <code>status</code>, <code>statusDate</code> (the Denver date it was derived for), <code>sourceReadTime</code>, <code>updatedAt</code>, <code>tombstone:false</code>.</td></tr>
<tr><td><code>memberProfiles/{memberId}</code> (stored; Phase F lets the member read it)</td><td><code>{memberId, firstName, name, email, status, memberSince, pause, finalAccessDate, updatedAt}</code>. <code>pause</code> = the valid, processed window containing today (Denver), else the earliest valid processed window starting after today, else <code>null</code>, as <code>{startDate, endDate}</code>; <code>finalAccessDate</code> only if valid. <strong>No malformed marker and no phone digits ever reach it.</strong> Date-dependent, so the recompute rewrites it too.</td></tr>
<tr><td><code>staff</code></td><td><code>{uid, staff: {name, role}}</code> — <strong>sent only for granted users</strong> — or <code>{uid, tombstone:true}</code>. Granted = <code>role</code> exactly <code>admin</code>|<code>manager</code>|<code>staff</code>, <code>active</code> absent or <code>true</code>, <code>appAccess</code> absent or a list of strings, and (role manager/admin, or <code>appAccess</code> contains <code>my-clay-hub</code>). A deleted, ungranted or malformed users doc → a tombstone envelope; malformed also logs an error naming the uid only (it repeats each reconcile until fixed — accepted). Never email, PIN or <code>appAccess</code>.</td></tr>
<tr><td><code>staffRoster/staff_{uid}</code> (stored)</td><td><code>{uid, name, role, sourceReadTime, updatedAt, tombstone:false}</code>. The receiver ignores a tombstone for a uid it doesn't hold, so no roster doc is ever created for someone never granted.</td></tr>
<tr><td><code>reconcile</code></td><td><code>{scope:'members', items:[member entries], held:[memberId]}</code> or <code>{scope:'staff', items:[granted staff entries]}</code> — the complete set at one readTime. <strong>Sender:</strong> every live source doc needs a valid memberId; a memberId with more than one live doc goes into <code>held</code> (ids only); a live doc with a missing or malformed memberId aborts the whole member reconcile (nothing sent, error logged). <strong>Receiver:</strong> duplicate ids across <code>items</code>/<code>held</code> → 400; <code>held</code> ids are neither updated nor removed and are left out of every denominator; a held record whose <code>sourceReadTime</code> is at or after the batch's readTime is never removed (a newer trigger already landed).</td></tr>
<tr><td>Tombstones (stored)</td><td>Replace the document. <code>members</code>: the last stored snapshot fields <strong>minus <code>email</code>, <code>emailLower</code> and <code>phoneLast4</code></strong> (Q7), plus <code>{memberId, firstName, lastInitial, tombstone:true, status:'removed', statusDate, sourceReadTime, updatedAt}</code>; if nothing was ever stored for that memberId, only those last fields. <code>memberProfiles</code>: <code>{memberId, tombstone:true, status:'removed', updatedAt}</code>. <code>staffRoster</code>: <code>{uid, tombstone:true, sourceReadTime, updatedAt}</code>. A later live record replaces it with the full allowlist again. (Vault copies taken earlier keep the email and phone digits until the 56-day retention ages them out — noted in DATA-RESTORE.)</td></tr>
<tr><td>Responses</td><td>200 <code>{result: applied|unchanged|stale}</code>; 400 malformed envelope; 409 a reconcile stopped by a threshold. <strong>Terminal for the sender: only 200, 400 and 409</strong> (400 also logs an error: the two repos disagree). Everything else — 401/403/404, 429, 5xx, timeouts — throws, so the trigger is retried.</td></tr>
<tr><td>Logging</td><td>Never request bodies, names, emails, phone digits, notes or source documents — only memberId/uid, kind, result and counts.</td></tr>
</table>

<h2 id="settings">Functions and their settings</h2>
<p>All in <code>us-central1</code>, <code>minInstances</code> 0, ingress <code>ALLOW_ALL</code> (as the canary; access is by IAM). The guard checks that every limit is set and that the live service equals the sealed manifest; the values themselves are pinned by a unit test in each codebase (limits aren't in <code>declarations.json</code>).</p>
<table>
<tr><th>Function</th><th>Project / codebase</th><th>Trigger (declaration)</th><th>Runs as</th><th>timeoutSeconds / memory / cpu / concurrency / maxInstances</th></tr>
<tr><td><code>ingestMemberUpdate</code></td><td>my-clay-hub / <code>members</code></td><td>https; invoker <code>[clayhub-link@tinker-hq-apps…]</code></td><td><code>ingest@</code></td><td>120 / 512MiB / 1 / 10 / 3</td></tr>
<tr><td><code>recomputeStatuses</code></td><td>my-clay-hub / <code>members</code></td><td>schedule <code>every day 09:30</code>, <code>UTC</code>; retryCount 2, maxRetrySeconds 0, minBackoffSeconds 600, maxBackoffSeconds 1200, maxDoublings 1</td><td><code>ingest@</code></td><td>300 / 256MiB / 1 / 1 / 1</td></tr>
<tr><td><code>onClayHubMemberWritten</code></td><td>tinker-hq-apps / <code>clayhub-link</code></td><td>firestore <code>document.written</code>, <code>clayHub_members/{docId}</code>, <code>(default)</code>, <code>nam5</code>, retry true; invoker (Q9) <code>[clayhub-link@]</code></td><td><code>clayhub-link@</code></td><td>60 / 256MiB / 1 / 1 / 5</td></tr>
<tr><td><code>onStaffUserWritten</code></td><td>tinker-hq-apps / <code>clayhub-link</code></td><td>firestore <code>document.written</code>, <code>users/{uid}</code>, as above</td><td><code>clayhub-link@</code></td><td>60 / 256MiB / 1 / 1 / 5</td></tr>
<tr><td><code>reconcileLink</code></td><td>tinker-hq-apps / <code>clayhub-link</code></td><td>schedule <code>every 6 hours from 01:15 to 19:15</code>, <code>UTC</code>; retryCount 1, maxRetrySeconds 0, minBackoffSeconds 600, maxBackoffSeconds 600, maxDoublings 0</td><td><code>clayhub-link@</code></td><td>300 / 512MiB / 1 / 1 / 1</td></tr>
</table>
<p class="note">The ingest URL is a hard-coded constant in the sender, tested. A reconcile and a recompute are each one transaction of up to 500 writes: 2 per member plus 1 to consume an override = <strong>249 members</strong>. Both refuse above that (nothing written, error) and alert from 200.</p>

<h2>Phases</h2>
<div class="note"><strong>Order:</strong> E-pre first, then E-0 (merged <em>and</em> its rules released before E-3/E-4 merge, because the rules guard needs its control files to match <code>main</code>). E-1, E-2 and E-3 can then proceed on separate branches; E-4 needs E-1 and E-3; E-5 before E-6. <strong>E-2 merges only when E-6 can follow within days, and after #64's vault release is attested:</strong> once <code>members/recomputeStatuses</code> is declared on <code>main</code>, any <code>vault</code> or <code>core</code> scheduler attestation fails until that job exists. <strong>E-7 onward waits for every gate</strong> (listed in E-7). Every PR: Codex + Claude implementation review, then Christie's "okay to merge". Every release: that project's guard, <code>--diff</code> pasted, Christie's "approved to change firebase &lt;sha&gt;" for that exact sha and project.</div>

<div class="phase">
<h3>E-pre — Decisions and the status rule, before any link code <span class="status-tag ready">execution-ready: true</span></h3>
<ol>
  <li>Christie's answers to Q1–Q9 → DECISIONS rows in my-clay-hub; SPEC.md (§3: the recompute time) and DATA-MODEL.md (the contract, the never-copy list, tombstones; correct "written only by ingestMemberUpdate" — the recompute writes status and profile fields too) in one docs PR.</li>
  <li>If Q6 = B: <code>deriveStatus</code> checks a <code>scheduledPause</code> in this order — non-object → malformed (<code>review</code>); object with <code>processed !== true</code> → ignored; otherwise as today (history entries unchanged). Its own small PR in <code>shared/</code>, with tests (processed, unprocessed, malformed container, malformed date with <code>processed:true</code>, legacy) under all three time zones, and its own review — before E-1 freezes the fixtures.</li>
</ol>
</div>

<div class="phase">
<h3>E-0 — studio-hub: the users-rules pins <span class="status-tag ready">execution-ready: true</span></h3>
<p>A comment on the <code>users</code> rules naming My Clay Hub's dependency (<code>name</code>, <code>role</code>, <code>active</code>, <code>appAccess</code>). Tests only for what isn't covered (rules.test.js already pins self-granted appAccess and studios): role self-promotion on create (<code>manager</code>, <code>admin</code>), and <code>active</code> on self-update. Released through studio-hub's rules guard (free, sha phrase) <strong>before</strong> E-3 or E-4 merge.</p>
<div class="bdd">Given a signed-in user with no users doc
When they create their own doc with role 'manager' (or 'admin')
Then the write is denied

Given a staff user
When they update their own doc changing active
Then the write is denied</div>
</div>

<div class="phase">
<h3>E-1 — The contract as fixtures (both repos) <span class="status-tag ready">execution-ready: true</span></h3>
<p>One fixture set — source docs (every forbidden field at every nesting level; both pause spellings; <code>priorTerm</code>; processed and unprocessed pauses; malformed dates, stages, containers and memberIds, each stage-qualified; phones of every shape; users docs granted, ungranted, demoted, malformed; conflicts for <code>held</code>) and the exact envelopes and stored documents they must produce — committed byte-identical in both repos, with a test in each pinning its sha-256.</p>
</div>

<div class="phase">
<h3>E-2 — my-clay-hub: the receiving side (codebase <code>members</code>) <span class="status-tag ready">execution-ready: true</span></h3>
<ul>
  <li><strong><code>ingestMemberUpdate</code></strong> — <code>member</code>/<code>staff</code>: one transaction: read the target doc(s), apply the gate, derive status from the snapshot's source shape, write <code>members</code> + <code>memberProfiles</code> (or <code>staffRoster</code>), or replace them with tombstones.</li>
  <li><strong><code>reconcile</code></strong> — validate the whole batch, then <strong>everything inside one transaction, redone from scratch on a retry</strong>: read every target and any override; for each item apply the gate; <strong>source-driven status change</strong> = <code>deriveStatus(stored source shape, today)</code> ≠ <code>deriveStatus(incoming source shape, today)</code> (both for today's Denver date — never compared with the stored, possibly day-old status); removals = live records held, not in <code>items</code>, not in <code>held</code>, with <code>sourceReadTime</code> older than the batch's readTime; apply Q8 (denominators = live held records minus <code>held</code> ids). Pass → write: a record whose <strong>whole snapshot</strong> is unchanged gets only its <code>sourceReadTime</code> advanced (the reconcile never writes a date-driven status — that's the recompute's, and a recompute stop isn't overridden); a record with any snapshot change (a name or email edit included) gets its new snapshot, status and profile. "Source shape" means only the fields <code>deriveStatus</code> reads and is used only for the status comparison. A tombstoned member who reappears counts as an addition, not a status change. Fail → nothing written, 409, and the log lists the counts and the affected <strong>ids</strong> (no personal data) so Christie can check them.</li>
  <li><strong>Overrides</strong> — collection <code>linkOverrides/{id}</code> (deny-all rule and rules test; Console only): exact keys per scope — <code>members</code>: <code>{scope, maxStatusChanges?, maxRemovals?, expiresAt, usedAt: null}</code> with at least one limit (an omitted limit keeps its normal Q8 value); <code>staff</code>: <code>{scope, maxRemovals, expiresAt, usedAt: null}</code>; <code>recompute</code>: <code>{scope, maxStatusChanges, expiresAt, usedAt: null}</code>. Integers 0–249; <code>expiresAt</code> a Timestamp no more than 24 h after the document's own Firestore <code>createTime</code> (refused otherwise); <code>usedAt</code> becomes a server timestamp when consumed. More than one unused, unexpired override for a scope → refuse all of them (error line) rather than choose. An override is used <strong>only when the normal limits would stop the run</strong> and its counts fit it; it's then consumed (<code>usedAt</code>) in the same transaction, and logs an error line naming the override id, scope, limits and counts — so every use emails Christie.</li>
  <li><strong><code>recomputeStatuses</code></strong> (09:30 UTC) — <strong>one transaction</strong> over every live member (above 249 → nothing written, error; alert from 200): re-derive status and the profile's <code>pause</code> for today's Denver date; count only <strong>unexplained</strong> changes — a change is explained when a pause start, a pause end + 1 day or a final-access date + 1 day falls after the member's stored <code>statusDate</code> and on or before today (each member stores <code>statusDate</code>, the Denver date its status was last derived for), so a busy 1st never stops it; over Q8's limit → write nothing, error log; otherwise write every changed <code>members.status</code> and profile together. A transaction retry recomputes everything, so an ingest that lands in between is never overwritten. It never blocks the reconcile, and the reconcile never applies the date-driven changes it stopped.</li>
  <li><strong><code>firestore.rules</code></strong>: explicit deny-all blocks for <code>members</code>, <code>memberProfiles</code>, <code>staffRoster</code>, <code>linkOverrides</code> with rules tests (<code>linkOverrides</code> stays deny-all for every client permanently — Phase F's manager settings never reach it); released through the rules guard <em>before</em> the function.</li>
  <li>Declarations, iam-expectations (<code>ingest@</code> and its custom role), a FUNCTIONS-ROLLBACK section with the stop/resume runbook and "what to do when a stop email arrives".</li>
</ul>
<p><strong>Tests first</strong> (emulator, Node 22): every fixture; the gate (earlier, equal, same millisecond with different nanos, malformed) and <strong>A→B→A out of order, single and through a reconcile</strong>; tombstones keep the last name and dates but drop email, emailLower and phoneLast4 (Q7); re-appearance restores the full allowlist; every D4 row through the real <code>deriveStatus</code>, stage-qualified; reconcile: exact thresholds and small denominators, additions, already-tombstoned, <code>held</code> ids untouched, duplicate ids → 400, a stop leaving every collection untouched, a removal racing a newer trigger (members <em>and</em> staff), source-driven counting (an unrelated edit on a pause's first day counts 0; a status-changing edit on a date boundary counts 1), an unchanged record advancing only <code>sourceReadTime</code>, a name-only change applied by the reconcile with 0 status changes, a reappearing member counted as an addition, the recompute ignoring changes its dates explain (a 1st with 15 pause starts doesn't stop) and stopping on unexplained ones, an override not consumed by a run that would have passed anyway, a transaction retry recomputing the counts, overrides (scope, bounds, expiry, single use, its error line, the 249 cap); recompute: one source change vs date changes, the stop with zero writes, a race with ingest in both orders, profiles' <code>pause</code> moving at a window boundary; staff: grant, ungrant, demotion, malformed, a tombstone for a never-held uid writes nothing, more than 1 removal stops; rules deny every client operation; no log contains a fixture's name, email or phone.</p>
<div class="bdd">Given members/m_7Q holds A with sourceReadTime T1
When envelopes for B (read T2) and A again (read T3) arrive T3 first, then T2
Then members/m_7Q ends at A with sourceReadTime T3

Given a reconcile whose held list contains m_7Q (two live source docs)
When it is posted
Then members/m_7Q is neither updated nor removed and isn't counted

Given a source pause whose endDate is the number 20270201
When its snapshot is ingested for an active-stage member
Then status is 'review', the stored pause holds "!malformed", and the profile shows no pause</div>
</div>

<div class="phase">
<h3>E-3 — studio-hub: <code>tinker-hq-apps</code>' functions guard (highest-risk PR) <span class="status-tag ready">execution-ready: true</span></h3>
<ul>
  <li>A <strong>separate</strong> guard (<code>scripts/deploy-functions.sh</code>, its own functions backstop, its own test suite), pinned to <code>tinker-hq-apps</code>; receipts under <code>deployed/tinker-hq-apps/functions-&lt;cb&gt;/…</code>; K10's event-source pin and the pinned config generalized.</li>
  <li><strong>The rules guard stays untouched:</strong> <code>deploy-rules.sh</code>, its backstop path, what <code>npm test</code> runs. Functions suites use their own npm script, their own emulator config and non-default ports. <code>firebase.json</code> gains only a <code>functions</code> key: a new test in the rules suite pins that (no <code>emulators</code> block, firestore/storage keys unchanged) and proves a rules release still needs neither Node 22 nor any functions install. A dry rules <code>--status</code>/<code>--diff</code> on the branch.</li>
  <li><strong>Firestore event triggers</strong>: declared <code>trigger: "firestore"</code> with event type, document path, database, location <code>nam5</code>, <code>retry: true</code>, service account, and the expected invoker list (Q9); the sealed manifest must match; every other kind still refused by name.</li>
  <li><strong>The retry prompt</strong>: answered only for declared event triggers, matched on its exact text; any other prompt, changed wording or end of input → stop. Never <code>--force</code>.</li>
  <li><strong>Attestation</strong>: each event-triggered service's Cloud Run invoker list equals its declaration (Q9); project role bindings: no undeclared holder of <code>run.invoker</code>, <code>eventarc.eventReceiver</code>, Owner or Editor (basic roles include invoke rights; the expected Owner/Editor rows are listed in iam-expectations); the Pub/Sub service agent holds Token Creator (the CLI grants it on the first event release — F13).</li>
</ul>
<p><strong>Acceptance:</strong> the new suite passes (ported + new: unexpected prompt, wording drift, end of input, a partial release continued on the same sha, every undeclared setting refused); the rules guard's suite passes unchanged plus its isolation test; the guard can't target any project but <code>tinker-hq-apps</code>.</p>
</div>

<div class="phase">
<h3>E-4 — studio-hub: the <code>clayhub-link</code> codebase <span class="status-tag ready">execution-ready: true</span></h3>
<ul>
  <li><code>onClayHubMemberWritten</code>: memberIds from before and after; for each, one query on <code>memberId</code> only (its <code>QuerySnapshot.readTime</code>); the contract envelope; a conflict → error naming the memberId, nothing sent; no memberId → error naming the doc id only.</li>
  <li><code>onStaffUserWritten</code>: re-read <code>users/{uid}</code> (missing → tombstone) with that read's <code>DocumentSnapshot.readTime</code>; the staff rule.</li>
  <li><code>reconcileLink</code>: one read-only transaction pinned to one readTime over <code>clayHub_members</code> and <code>users</code>; validate the member set (held conflicts; abort on a missing/malformed memberId); any read error → nothing sent; then one <code>reconcile</code> call per scope; a 409 is logged as the stop.</li>
  <li>OIDC token from the metadata server, audience = the ingest URL constant; terminal responses only 200/400/409.</li>
  <li><code>functions/</code> sits under studio-hub's Netlify publish root and would be served with Tinker HQ — the code holds no secrets (accepted, as for the rules and scripts already there); <code>node_modules</code> is never committed.</li>
</ul>
<p><strong>Tests first</strong> (Firestore emulator on non-default ports for the source; ingest faked): every fixture; late and duplicate deliveries; delete and re-create in both orders; an email change with the retired-old event before and after the new one; conflicts → <code>held</code> in a reconcile, nothing sent on a trigger; a live doc with a missing memberId aborts the reconcile; memberId A→B and A→B→C; a doc with no <code>retired</code> field is live; a partial read; 200/400/409 return normally, 401/403/404/429/5xx/timeout throw; 120 re-saved members with one real change → one envelope that changes a copied field; no write API is used (a test); no log holds personal data.</p>
<div class="bdd">Given Jane changes email: jane@new written live and jane@old retired in one batch
When the two events arrive old-first, new-first, or one is retried later
Then every envelope sent for her memberId describes the one live doc, jane@new

Given a users doc with role 'Manager' (wrong case) and appAccess containing 'my-clay-hub'
When it is saved
Then a tombstone envelope is sent and an error names only the uid

Given ingest answers 403
When a trigger sends an envelope
Then the function throws, so Eventarc retries it</div>
</div>

<div class="phase">
<h3>E-5 — Christie: identities and IAM (Claude reads before and after) <span class="status-tag ready">execution-ready: true</span></h3>
<ol>
  <li><strong>Inventory first</strong> (read-only): <code>tinker-hq-apps</code>' IAM with Google-provided grants; every service account and what uses it; Cloud Run services, Cloud Functions, Scheduler jobs, build triggers, VMs, App Engine (and the App Engine default account, which often holds Editor); 30 days of audit logs for the default Compute and App Engine accounts. If anything uses them, stop and re-plan.</li>
  <li><code>tinker-hq-apps</code>: enable the APIs (run, eventarc, cloudfunctions, cloudbuild, artifactregistry, pubsub, cloudscheduler, iamcredentials); record the service agents and grants that creates; create <code>gcf-artifacts</code>; neutralize both build candidates and the App Engine default account if unused; give the account Google builds with only the three build roles (as D2-1); an email notification channel for alerts.</li>
  <li><code>tinker-hq-apps</code>: <code>clayhub-link@</code>; a custom role with exactly <code>datastore.entities.get</code> and <code>datastore.entities.list</code>; grant it and <code>eventarc.eventReceiver</code>.</li>
  <li><code>my-clay-hub</code>: <code>ingest@</code>; a custom role with get, list, create, update, no delete; grant it.</li>
  <li>After-readings: each project differs from its before-reading by exactly the recorded rows; <code>clayhub-link@</code> holds nothing in <code>my-clay-hub</code> yet. Christie opens two staff apps.</li>
</ol>
</div>

<div class="phase">
<h3>E-6 — Release the receiving side (my-clay-hub) <span class="status-tag ready">execution-ready: true</span></h3>
<p>Rules first (rules guard, its own phrase); then <code>--diff --codebase members</code>, Christie's phrase, release, readings, <code>--attest</code>. Probe: an unauthenticated POST gets 403; the invoker reading shows exactly <code>clayhub-link@tinker-hq-apps</code>; <code>clayhub-link@</code> holds nothing else in <code>my-clay-hub</code> (the cheap stand-in for a live write-refusal test). No real data: the first authenticated call is E-8's first fill.</p>
</div>

<div class="phase">
<h3>E-7 — Alerts, then release the link (tinker-hq-apps) — after every gate <span class="status-tag ready">execution-ready: true</span></h3>
<p><strong>Gates, all required:</strong> V-4 complete (<code>deploy_verified</code>, <code>iam_attested</code>, <code>scheduler_attested</code> all yes, and a verified complete export); DECISIONS #64's fix released and attested; E-pre done; E-6 verified and attested.</p>
<ol>
  <li>Log-based alerts in both projects: link conflicts, docs without memberId, staff fail-closed, reconcile aborts and stops, recompute stops and failures, every override use, ingest 400 and 5xx, any non-2xx the sender sees, and <strong>4xx/5xx on the two trigger services' own Cloud Run request logs</strong> (an event Eventarc can't deliver never runs the trigger code, so the sender's own alert can't fire).</li>
  <li>Release right after a reconcile boundary (e.g. 07:20 UTC): <code>--diff --codebase clayhub-link</code>; Christie's phrase; release (the guard answers the retry prompt); confirm <code>deploy_verified</code>. Until E-8 step 2 the triggers' events are refused at their own services and Eventarc retries them (up to 24 h).</li>
  <li><strong>Pause <code>reconcileLink</code></strong> straight away (Christie).</li>
  <li><strong>K13</strong>: Christie removes the Compute account's project-wide <code>run.invoker</code> and <code>eventarc.eventReceiver</code> (the CLI's F13 grants, made only on a codebase's first event release — they come back if the triggers are ever deleted and recreated; noted in the rollback runbook).</li>
  <li><strong>Pub/Sub Token Creator reading</strong>: the Pub/Sub service agent holds <code>iam.serviceAccountTokenCreator</code> (the CLI adds it). If it's missing: stop here and ask Christie — a narrowly scoped grant is a recorded decision, not an improvisation.</li>
</ol>
</div>

<div class="phase">
<h3>E-8 — First fill, then delivery, proof, attest, spot check, fresh vault copy <span class="status-tag ready">execution-ready: true</span></h3>
<ol>
  <li><strong>First fill:</strong> Force run the paused <code>reconcileLink</code> (Christie clicks; logged; first confirm in the Console that a paused job can be Force run — if not, resume it, Force run, pause again). This is the first authenticated cross-project call and the first data. Counts match Membership Manager (live members; managers/admins in <code>staffRoster</code>).</li>
  <li><strong>Q9</strong>: Christie grants <code>run.invoker</code> to <code>clayhub-link@</code> on the two trigger services only. Events retried since the release now run: each re-reads its source, so it lands as <code>unchanged</code> or <code>applied</code>. The trigger-service 4xx alert fired as expected from the release until this grant.</li>
  <li><strong>Delivery proof after K13 removal:</strong> Christie saves one member in Membership Manager. Evidence, all three: the trigger's execution log timestamped after the removal, ingest's 200 for that memberId, and its stored <code>sourceReadTime</code> later than the removal. If it fails: <strong>stop the link</strong> (runbook) and re-plan — never restore broad grants.</li>
  <li>Resume <code>reconcileLink</code>; readings; <code>--attest</code> (needs the job ENABLED, Q9's invoker lists, Token Creator, and no K13 grants).</li>
  <li>Spot check three members (active; paused or with pause history; offboarding/cancelled if any) against Membership Manager: status, dates, and no forbidden field or malformed marker in any profile.</li>
  <li>Force run the vault export (fine once #64 is live) and verify the new complete folder — the first off-project copy with real member data. The vault plan's restore rehearsal follows.</li>
</ol>
</div>

<div class="phase">
<h3>E-9 — Close <span class="status-tag ready">execution-ready: true</span></h3>
<p>OPEN-ITEMS; DATA-RESTORE (tombstoned members' old fields stay in earlier vault copies until retention ages them out); the resilience report's IAM inventory (both projects, F12's residual, Q9's exception); both repos' CLAUDE.md; the foundation plan's Phase E marked done.</p>
</div>

<h2 id="stop">Stopping the link (runbook, written in E-2)</h2>
<p>Two kinds of stop. <strong>A link/transport stop</strong> (the sender, the call, IAM): status logic is fine, so <code>recomputeStatuses</code> keeps running. <strong>A status/receiver-integrity stop</strong> (a bad <code>deriveStatus</code>, a bad projection, a bad receiver release): pause <code>recomputeStatuses</code> too, accepting that the <code>members</code> scheduler attestation stays red until recovery.</p>
<ol>
  <li><strong>Immediately</strong> (Christie, Console): pause <code>reconcileLink</code> (and, for an integrity stop, <code>recomputeStatuses</code>); on Cloud Run <code>ingestmemberupdate</code> → Permissions, remove <code>clayhub-link@</code>'s invoker (an emergency removal is allowed; granting by hand isn't, except Q9's recorded grant). Trigger deliveries then get 403, throw, and Eventarc retries them for up to 24 h; the sender-non-2xx alert fires (at most one email per hour).</li>
  <li><strong>Then</strong> record it: a guarded release of <code>members</code> with <code>invoker: ["private"]</code> (sha phrase), attested (for a transport stop the schedule is still enabled, so the scheduler reading passes).</li>
  <li><strong>To resume</strong>: fix the cause; guarded release(s); resume the paused job(s); Force run <code>reconcileLink</code> to catch up whatever the 24-hour retry window dropped; then attest.</li>
  <li><strong>A stop email</strong> (409, recompute stop, or reconcile abort): read the logged counts and ids; check each id in Membership Manager. If the change is real (e.g. many pauses start on the 1st), create a <code>linkOverrides</code> doc for that one scope with limits just above the counts and an <code>expiresAt</code> within 24 h, then Force run the job; its use emails you. If it isn't real, stop the link and investigate. A reconcile <em>abort</em> (a live doc with no valid memberId) blocks catch-up and removals until that doc is fixed in Membership Manager.</li>
</ol>

<h2>Firebase safety checklist</h2>
<ul>
  <li>Every new collection gets an explicit rule and rules tests in the same commit as the code that writes it, deployed before the function (E-2, E-6).</li>
  <li>Writers to my-clay-hub's member data: <code>ingestMemberUpdate</code> (single and reconcile) and <code>recomputeStatuses</code> (status and profile pause only) — both as <code>ingest@</code>, each change one transaction, never deletes.</li>

exec
/bin/zsh -lc 'rg -n -C 8 "E-0|staffRoster|staff rule|role.*active.*appAccess|brand-new|self-create|admin.*own|allow create|allow update" "$HOME/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html" firestore.rules rules.test.js && sed -n '"'1,220p' firestore.rules && sed -n '900,1085p' rules.test.js && git diff --check 00d5fd2"'^ 00d5fd2 && git diff --word-diff=porcelain 00d5fd2''^ 00d5fd2 -- firestore.rules rules.test.js' in /Users/christiehubley/studio-hub
 succeeded in 0ms:
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-24-  .ready { background: #d1fae5; color: #065f46; }
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-25-</style>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-26-</head>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-27-<body>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-28-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-29-<h1>Plan: My Clay Hub Phase E — the live link from Membership Manager</h1>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-30-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-31-<div class="meta">
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:32:  <strong>Goal:</strong> When staff add, edit, pause or offboard a member in Membership Manager, My Clay Hub's own copy of that member (<code>members/{memberId}</code>, with the right derived status) matches within a minute — one way only, carrying only the allowed fields, and safe against late, duplicate or out-of-order deliveries. Staff with My Clay Hub access are mirrored the same way into <code>staffRoster</code>.<br>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-33-  <strong>Repos:</strong> <code>/Users/christiehubley/my-clay-hub</code> (the receiving side) and <code>/Users/christiehubley/studio-hub</code> (the sending side: the <code>clayhub-link</code> functions and <code>tinker-hq-apps</code>' own functions guard). Console/IAM work in both projects is Christie's (no gcloud on the Mac; read-only readings by Claude in her Chrome or via Cloud Shell).<br>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-34-  <strong>Parent:</strong> <code>clayhub-members-foundation.html</code> Phase E (the outline this plan expands), decisions D2, D4, D4a, D11, D21, D22, D23 and the IAM inventory; <code>firebase-functions-deploy-guard.html</code> (M1, F13, K10, K11, K13, the round-1 "retry approval" finding); <code>my-clay-hub-d4-vault-export.html</code> (the gate).<br>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-35-  <strong>Gate:</strong> no real member data enters <code>my-clay-hub</code> until D-4's V-4 is complete (first complete vault export — Sunday Oct 11's scheduled run). Phases E-1 to E-6 build and test with no real data and may run before the gate; <strong>E-7 (deploying the link) waits for it.</strong><br>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-36-  <strong>Not in this plan:</strong> any screen, sign-in provider or <code>claimMembership</code> (Phase F); the Tinker HQ tile and the Manage Team <code>my-clay-hub</code> box (Phase F); "change email" in Membership Manager (B4, its own plan); <code>kioskLookup</code>; any write back to Membership Manager (never, D6).<br>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-37-  <strong>Risk:</strong> <strong>HIGH.</strong> The first Cloud Functions ever in <code>tinker-hq-apps</code>, the project every staff app shares; real member personal data crossing projects for the first time; IAM changes in both projects, including one Google makes on its own (K13).<br>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-38-  <strong>Size:</strong> roughly 2 weeks at the D-4 cadence (several review rounds per PR). Christie's hands-on time ≈ 6–10 h (decisions, Console/IAM steps, approvals, a 3-member spot check).<br>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-39-  <strong>Status:</strong> <span class="status-tag ready">execution-ready: true</span> — v4.1, Oct 8, 2026, after four review rounds (round 4: Codex and Claude both "ready after fixes", 0 blocking; all fixes applied). Christie answered Q1–Q9 on Oct 8 (Q7 changed: removed members keep everything but email and phone digits). <strong>Marked execution-ready (all phases) by Christie, Oct 8.</strong> Next: E-pre (its PR review re-checks the Q7 change).
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-40-</div>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-41-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-42-<h2>Already decided (not reopened here)</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-43-<ul>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:44:  <li><strong>D22 "Re-read, then send a snapshot"</strong> (DECISIONS #53): a trigger on <code>clayHub_members/{id}</code> collects the memberId from before and after; for each, one query on <code>memberId</code> only; live = <code>retired !== true</code>; exactly one live doc → its fields; none → tombstone; more than one → conflict, nothing sent, alert. POST <code>{memberId, snapshot, readTime}</code>; ingest drops anything not newer than the stored <code>sourceReadTime</code>, checks the payload strictly, runs <code>deriveStatus</code>, writes, never deletes. The reconcile uses the same envelope, read in one read-only transaction pinned to one readTime. <code>users/{uid}</code> → <code>staffRoster/staff_{uid}</code> the same way (no memberId, no conflict case).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-45-  <li><strong>D4 / D4a / #34</strong>: status comes only from <code>shared/derive-status.js</code>; Denver calendar dates; recomputed for everyone daily.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-46-  <li><strong>#24</strong>: only <code>phoneLast4</code> leaves <code>tinker-hq-apps</code>, worked out there. <strong>#37 / D6</strong>: never write back. <strong>#42</strong>: IAM one-way; ingest can't delete. <strong>#32 / D2 / M1</strong>: the link is codebase <code>clayhub-link</code> in studio-hub, deployed only by <code>tinker-hq-apps</code>' own functions guard; neither guard can reach the other project. <strong>#54 / D23</strong>: 2nd gen, retries on (<code>retry: true</code> on triggers, retryConfig on schedules), explicit maxInstances, Admin app built once per instance; Firestore <code>nam5</code>, Eventarc location <code>nam5</code>, functions <code>us-central1</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-47-  <li><strong>IAM inventory (D11)</strong>: <code>clayhub-link@tinker-hq-apps</code> = a custom read-only Firestore role (get, list) + <code>eventarc.eventReceiver</code>; <code>ingestmemberupdate</code> is <code>invoker</code>: exactly <code>clayhub-link@tinker-hq-apps</code> (declared; the CLI sets it — never granted by hand); <code>ingest@my-clay-hub</code> = custom role get/list/create/update, no delete. Called at the service's exact run.app URL with an OIDC token from the metadata server.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-48-  <li><strong>#63 / #64</strong>: the vault gate; Force runs keyed by the day they run (deploys Monday Oct 12).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-49-</ul>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-50-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-51-<h2 id="facts">Facts this plan relies on (research Oct 8; corrected after review round 1)</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-52-<table>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-53-<tr><th>#</th><th>Fact</th><th>Source</th></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-54-<tr><td>F1</td><td><code>clayHub_members</code>: every doc the app writes has a valid <code>memberId</code> (<code>m_</code> + UUID v4; the app can't create a doc without one). The count, 66/66 valid and unique, comes from the dated Sep 28 backup log, not from code. Doc id = email lowercased with <code>/</code> and <code>.</code> → <code>_</code>. <strong>No stored <code>emailLower</code></strong>. Saves write only changed fields; blank top-level fields are stripped.</td><td>clay-hub-membership firebase-data.js:85-94, 155-208; member-status.js:668-682; save-safety plan log</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-55-<tr><td>F2</td><td>Source fields the link reads (and nothing else): <code>memberId</code>, <code>email</code>, <code>name</code> (one string), <code>phone</code> (free text), <code>stage</code>, <code>scheduledPause</code> (null or one of three shapes), <code>pauseHistory[]</code> (modern <code>startDate</code>/<code>endDate</code> or legacy <code>start</code>/<code>end</code>; may carry <code>priorTerm</code>), <code>scheduledCancellation.finalAccessDate</code>, <code>memberSince</code>, <code>retired</code>. <strong>The pause and cancellation objects also carry <code>notes</code>, <code>type</code>, <code>lastBilling</code>, <code>processDate</code>, Sawyer and audit fields</strong> — never copied (see the contract).</td><td>app.js:500, 550-560, 935-938, 3540-3651, 3761-3774; member-status.js:32-36, 721-725</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-56-<tr><td>F3</td><td>Never copy: <code>keypadCode</code>, <code>keypadUserId</code>, <code>staffNotes</code>, <code>notes</code>, <code>application</code>, <code>actions</code>, the full phone, the shelf fields, billing fields — at any nesting level.</td><td>save-safety plan, "What My Clay Hub's link needs"</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-57-<tr><td>F4</td><td>"Change email" (B4) isn't built; nothing writes <code>retired</code> today. Authorized Clay Hub writers can create documents with no rules-level schema or memberId check (so a delete + re-create can carry a new memberId).</td><td>grep; studio-hub firestore.rules:942</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:58:<tr><td>F5</td><td><code>users/{uid}</code>: the link uses only <code>name</code>, <code>role</code>, <code>active</code>, <code>appAccess</code>. Docs carry other fields too (<code>email</code>, <code>createdAt</code>, <code>pin</code>, …), and admins can write other users' docs, so the rules don't guarantee shapes: the link must fail closed on anything unexpected. Missing <code>active</code> means true. Managers/admins are saved with <code>appAccess: []</code>. The <code>my-clay-hub</code> key doesn't exist yet.</td><td>studio-hub js/app.js:148-155, 1144-1145, 1339-1347; firestore.rules:24-38, 67-73, 111-187</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-59-<tr><td>F6</td><td><code>deriveStatus(source, todayDenver)</code> needs the <em>source shape</em> (<code>stage</code>, <code>scheduledPause</code>, <code>pauseHistory</code>, <code>scheduledCancellation.finalAccessDate</code>, <code>tombstone</code>, <code>retired</code>). It reads every pause entry including <code>priorTerm</code> ones (intended), and turns an unknown stage, a malformed or missing date, or a non-object pause into <code>review</code>. So malformed values must reach it, as values that are still malformed.</td><td>shared/derive-status.js:6-17, 30-35, 74-80; DATA-MODEL.md:86-88</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-60-<tr><td>F7</td><td>studio-hub has no functions and no functions guard. Its <strong>rules guard</strong> runs <code>npm test</code> in a worktree and takes <code>firebase.json</code>, <code>package.json</code> and <code>predeploy-check.sh</code> from <code>origin/main</code>'s tip; its backstop accepts only firestore and storage targets; <code>rules.test.js</code> uses the default emulator port 8080 and <code>firebase.json</code> has no emulators block. Anything E-3/E-4 adds there can break every staff app's rules deploy and rollback, and a rules commit made before E-3/E-4 merge must be deployed before they merge (the control files must match the tip).</td><td>studio-hub scripts/deploy-rules.sh:204-209, 348, 406; predeploy-check.sh:22-24; rules.test.js:76</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-61-<tr><td>F8</td><td>K13: the first event-triggered deploy grants the default Compute account project-wide <code>run.invoker</code> and <code>eventarc.eventReceiver</code>; a failed deploy still enables APIs and creates service agents. The runtime identity of a trigger and the identity that delivers its events are different things. The CLI prompts before enabling retries on an event trigger. K10 pins <code>EVENTARC_CLOUD_EVENT_SOURCE</code> to my-clay-hub.</td><td>firebase-functions-deploy-guard.html</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-62-<tr><td>F9</td><td>The guard requires UTC schedules with all five retry values declared; an empty invoker list is refused; <code>["private"]</code> means no callers.</td><td>predeploy-check.sh:242-249; deploy-functions.sh:184, 358</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-63-<tr><td>F10</td><td>One cross-project grant into <code>tinker-hq-vault</code> was accepted (V-1). Organization policies can differ by project, so the <code>run.invoker</code> binding is proven only by E-7's first real call.</td><td>D-4 log, Oct 2</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-64-<tr><td>F11</td><td>A code search found no staff-app server code using <code>tinker-hq-apps</code>' default Compute account. That is <em>not</em> enough to change a production account: E-5 adds a workload inventory and an audit-log check.</td><td>grep</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-65-<tr><td>F13</td><td><strong>The pinned CLI (15.22.3) and event triggers:</strong> it sends events <em>as the trigger's own runtime account</em> (<code>eventTrigger.serviceAccountEmail</code> = the function's service account), but sets a Cloud Run invoker only for HTTP-style functions, never for event triggers. On the first event release it adds project-wide bindings: <code>run.invoker</code> and <code>eventarc.eventReceiver</code> for the default Compute account, and Token Creator for the Pub/Sub service agent. So <code>clayhub-link@</code> needs <code>run.invoker</code> on its two trigger services, and nothing in the CLI gives it that (Q9).</td><td>firebase-tools lib/gcp/cloudfunctionsv2.js:214-216; lib/deploy/functions/release/fabricator.js:221-253, 345-389; lib/deploy/functions/checkIam.js:104-160</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-66-<tr><td>F12</td><td>Firestore IAM can't be limited to one collection: <code>clayhub-link@</code>'s read role covers the whole <code>tinker-hq-apps</code> database (payroll included). Accepted residual: read-only, one runtime, guarded code.</td><td>Firestore IAM model</td></tr>
--
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-88-<tr><td><code>readTime</code></td><td><code>{seconds: "&lt;decimal string&gt;", nanos: &lt;int 0..999999999&gt;}</code> from the source read's <code>Timestamp</code>, full nanosecond precision; stored as a Firestore <code>Timestamp</code> (<code>sourceReadTime</code>); compared as (seconds, nanos). Out-of-range or non-canonical → 400.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-89-<tr><td>The gate</td><td>Later than the stored <code>sourceReadTime</code> (or none stored) → apply, and <strong>always advance <code>sourceReadTime</code>, even when nothing else changes</strong> (result <code>unchanged</code>; <code>updatedAt</code> moves only when content does) — otherwise an A→B→A delivered out of order would end on B. Equal or earlier → <code>stale</code>, nothing written.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-90-<tr><td><code>member</code></td><td><code>{memberId, snapshot}</code> or <code>{memberId, tombstone:true}</code>. <code>memberId</code> must match Membership Manager's own pattern (<code>m_</code> + a version-4 UUID).</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-91-<tr><td><code>snapshot</code> — rebuilt from allowed keys, never copied and trimmed</td><td>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-92-<code>name</code>, <code>email</code>: a string, trimmed, else <code>null</code> · <code>emailLower</code>: <code>email</code> lowercased, or <code>null</code> · <code>memberSince</code>: a valid <code>YYYY-MM-DD</code>, else <code>null</code> · <code>phoneLast4</code>: Membership Manager's own phone rule (<code>formatPhone</code>: 10 digits, or 11 starting with 1) → its last 4, else <code>null</code> · <code>retired</code>: <code>true</code> only if the source is exactly <code>true</code> · <code>stage</code>: one of the six known stages, else <code>"!malformed"</code> · <code>scheduledPause</code>: <code>null</code>, or <code>{startDate, endDate, processed}</code>, or <code>"!malformed"</code> if not an object · <code>pauseHistory</code>: <code>[]</code>, or a list whose entries are <code>{startDate, endDate, priorTerm?}</code> (legacy <code>start</code>/<code>end</code> mapped, the modern value winning) or <code>"!malformed"</code>, or <code>"!malformed"</code> if not a list · <code>scheduledCancellation</code>: <code>null</code>, or <code>{finalAccessDate}</code>, or <code>"!malformed"</code> if not an object · every date: a valid <code>YYYY-MM-DD</code> as-is, missing or <code>null</code> → absent, anything else → <code>"!malformed"</code> (never raw text); the legacy mapping uses a modern value only when it isn't <code>null</code>/missing · <code>priorTerm</code>: present only as <code>true</code> · <code>processed</code>: <code>true</code> when the source <code>scheduledAt</code> is present (a non-empty value — Membership Manager's own test; real values are ISO strings), else <code>false</code> (Q6).</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-93-<tr><td>Status</td><td>Only <code>deriveStatus</code>. Its precedence stays: a removed/retired record is <code>removed</code> and onboarding/touring is <code>not_yet</code> before any malformed pause data is looked at — so the fixtures are stage-qualified.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-94-<tr><td><code>members/{memberId}</code> (stored)</td><td>The snapshot fields + <code>memberId</code>, <code>firstName</code> (first word of <code>name</code>), <code>lastInitial</code> (first letter of the last word, or <code>null</code>), <code>status</code>, <code>statusDate</code> (the Denver date it was derived for), <code>sourceReadTime</code>, <code>updatedAt</code>, <code>tombstone:false</code>.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-95-<tr><td><code>memberProfiles/{memberId}</code> (stored; Phase F lets the member read it)</td><td><code>{memberId, firstName, name, email, status, memberSince, pause, finalAccessDate, updatedAt}</code>. <code>pause</code> = the valid, processed window containing today (Denver), else the earliest valid processed window starting after today, else <code>null</code>, as <code>{startDate, endDate}</code>; <code>finalAccessDate</code> only if valid. <strong>No malformed marker and no phone digits ever reach it.</strong> Date-dependent, so the recompute rewrites it too.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:96:<tr><td><code>staff</code></td><td><code>{uid, staff: {name, role}}</code> — <strong>sent only for granted users</strong> — or <code>{uid, tombstone:true}</code>. Granted = <code>role</code> exactly <code>admin</code>|<code>manager</code>|<code>staff</code>, <code>active</code> absent or <code>true</code>, <code>appAccess</code> absent or a list of strings, and (role manager/admin, or <code>appAccess</code> contains <code>my-clay-hub</code>). A deleted, ungranted or malformed users doc → a tombstone envelope; malformed also logs an error naming the uid only (it repeats each reconcile until fixed — accepted). Never email, PIN or <code>appAccess</code>.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:97:<tr><td><code>staffRoster/staff_{uid}</code> (stored)</td><td><code>{uid, name, role, sourceReadTime, updatedAt, tombstone:false}</code>. The receiver ignores a tombstone for a uid it doesn't hold, so no roster doc is ever created for someone never granted.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-98-<tr><td><code>reconcile</code></td><td><code>{scope:'members', items:[member entries], held:[memberId]}</code> or <code>{scope:'staff', items:[granted staff entries]}</code> — the complete set at one readTime. <strong>Sender:</strong> every live source doc needs a valid memberId; a memberId with more than one live doc goes into <code>held</code> (ids only); a live doc with a missing or malformed memberId aborts the whole member reconcile (nothing sent, error logged). <strong>Receiver:</strong> duplicate ids across <code>items</code>/<code>held</code> → 400; <code>held</code> ids are neither updated nor removed and are left out of every denominator; a held record whose <code>sourceReadTime</code> is at or after the batch's readTime is never removed (a newer trigger already landed).</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:99:<tr><td>Tombstones (stored)</td><td>Replace the document. <code>members</code>: the last stored snapshot fields <strong>minus <code>email</code>, <code>emailLower</code> and <code>phoneLast4</code></strong> (Q7), plus <code>{memberId, firstName, lastInitial, tombstone:true, status:'removed', statusDate, sourceReadTime, updatedAt}</code>; if nothing was ever stored for that memberId, only those last fields. <code>memberProfiles</code>: <code>{memberId, tombstone:true, status:'removed', updatedAt}</code>. <code>staffRoster</code>: <code>{uid, tombstone:true, sourceReadTime, updatedAt}</code>. A later live record replaces it with the full allowlist again. (Vault copies taken earlier keep the email and phone digits until the 56-day retention ages them out — noted in DATA-RESTORE.)</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-100-<tr><td>Responses</td><td>200 <code>{result: applied|unchanged|stale}</code>; 400 malformed envelope; 409 a reconcile stopped by a threshold. <strong>Terminal for the sender: only 200, 400 and 409</strong> (400 also logs an error: the two repos disagree). Everything else — 401/403/404, 429, 5xx, timeouts — throws, so the trigger is retried.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-101-<tr><td>Logging</td><td>Never request bodies, names, emails, phone digits, notes or source documents — only memberId/uid, kind, result and counts.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-102-</table>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-103-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-104-<h2 id="settings">Functions and their settings</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-105-<p>All in <code>us-central1</code>, <code>minInstances</code> 0, ingress <code>ALLOW_ALL</code> (as the canary; access is by IAM). The guard checks that every limit is set and that the live service equals the sealed manifest; the values themselves are pinned by a unit test in each codebase (limits aren't in <code>declarations.json</code>).</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-106-<table>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-107-<tr><th>Function</th><th>Project / codebase</th><th>Trigger (declaration)</th><th>Runs as</th><th>timeoutSeconds / memory / cpu / concurrency / maxInstances</th></tr>
--
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-109-<tr><td><code>recomputeStatuses</code></td><td>my-clay-hub / <code>members</code></td><td>schedule <code>every day 09:30</code>, <code>UTC</code>; retryCount 2, maxRetrySeconds 0, minBackoffSeconds 600, maxBackoffSeconds 1200, maxDoublings 1</td><td><code>ingest@</code></td><td>300 / 256MiB / 1 / 1 / 1</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-110-<tr><td><code>onClayHubMemberWritten</code></td><td>tinker-hq-apps / <code>clayhub-link</code></td><td>firestore <code>document.written</code>, <code>clayHub_members/{docId}</code>, <code>(default)</code>, <code>nam5</code>, retry true; invoker (Q9) <code>[clayhub-link@]</code></td><td><code>clayhub-link@</code></td><td>60 / 256MiB / 1 / 1 / 5</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-111-<tr><td><code>onStaffUserWritten</code></td><td>tinker-hq-apps / <code>clayhub-link</code></td><td>firestore <code>document.written</code>, <code>users/{uid}</code>, as above</td><td><code>clayhub-link@</code></td><td>60 / 256MiB / 1 / 1 / 5</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-112-<tr><td><code>reconcileLink</code></td><td>tinker-hq-apps / <code>clayhub-link</code></td><td>schedule <code>every 6 hours from 01:15 to 19:15</code>, <code>UTC</code>; retryCount 1, maxRetrySeconds 0, minBackoffSeconds 600, maxBackoffSeconds 600, maxDoublings 0</td><td><code>clayhub-link@</code></td><td>300 / 512MiB / 1 / 1 / 1</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-113-</table>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-114-<p class="note">The ingest URL is a hard-coded constant in the sender, tested. A reconcile and a recompute are each one transaction of up to 500 writes: 2 per member plus 1 to consume an override = <strong>249 members</strong>. Both refuse above that (nothing written, error) and alert from 200.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-115-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-116-<h2>Phases</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:117:<div class="note"><strong>Order:</strong> E-pre first, then E-0 (merged <em>and</em> its rules released before E-3/E-4 merge, because the rules guard needs its control files to match <code>main</code>). E-1, E-2 and E-3 can then proceed on separate branches; E-4 needs E-1 and E-3; E-5 before E-6. <strong>E-2 merges only when E-6 can follow within days, and after #64's vault release is attested:</strong> once <code>members/recomputeStatuses</code> is declared on <code>main</code>, any <code>vault</code> or <code>core</code> scheduler attestation fails until that job exists. <strong>E-7 onward waits for every gate</strong> (listed in E-7). Every PR: Codex + Claude implementation review, then Christie's "okay to merge". Every release: that project's guard, <code>--diff</code> pasted, Christie's "approved to change firebase &lt;sha&gt;" for that exact sha and project.</div>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-118-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-119-<div class="phase">
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-120-<h3>E-pre — Decisions and the status rule, before any link code <span class="status-tag ready">execution-ready: true</span></h3>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-121-<ol>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-122-  <li>Christie's answers to Q1–Q9 → DECISIONS rows in my-clay-hub; SPEC.md (§3: the recompute time) and DATA-MODEL.md (the contract, the never-copy list, tombstones; correct "written only by ingestMemberUpdate" — the recompute writes status and profile fields too) in one docs PR.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-123-  <li>If Q6 = B: <code>deriveStatus</code> checks a <code>scheduledPause</code> in this order — non-object → malformed (<code>review</code>); object with <code>processed !== true</code> → ignored; otherwise as today (history entries unchanged). Its own small PR in <code>shared/</code>, with tests (processed, unprocessed, malformed container, malformed date with <code>processed:true</code>, legacy) under all three time zones, and its own review — before E-1 freezes the fixtures.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-124-</ol>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-125-</div>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-126-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-127-<div class="phase">
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:128:<h3>E-0 — studio-hub: the users-rules pins <span class="status-tag ready">execution-ready: true</span></h3>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:129:<p>A comment on the <code>users</code> rules naming My Clay Hub's dependency (<code>name</code>, <code>role</code>, <code>active</code>, <code>appAccess</code>). Tests only for what isn't covered (rules.test.js already pins self-granted appAccess and studios): role self-promotion on create (<code>manager</code>, <code>admin</code>), and <code>active</code> on self-update. Released through studio-hub's rules guard (free, sha phrase) <strong>before</strong> E-3 or E-4 merge.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-130-<div class="bdd">Given a signed-in user with no users doc
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-131-When they create their own doc with role 'manager' (or 'admin')
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-132-Then the write is denied
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-133-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-134-Given a staff user
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-135-When they update their own doc changing active
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-136-Then the write is denied</div>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-137-</div>
--
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-139-<div class="phase">
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-140-<h3>E-1 — The contract as fixtures (both repos) <span class="status-tag ready">execution-ready: true</span></h3>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-141-<p>One fixture set — source docs (every forbidden field at every nesting level; both pause spellings; <code>priorTerm</code>; processed and unprocessed pauses; malformed dates, stages, containers and memberIds, each stage-qualified; phones of every shape; users docs granted, ungranted, demoted, malformed; conflicts for <code>held</code>) and the exact envelopes and stored documents they must produce — committed byte-identical in both repos, with a test in each pinning its sha-256.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-142-</div>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-143-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-144-<div class="phase">
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-145-<h3>E-2 — my-clay-hub: the receiving side (codebase <code>members</code>) <span class="status-tag ready">execution-ready: true</span></h3>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-146-<ul>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:147:  <li><strong><code>ingestMemberUpdate</code></strong> — <code>member</code>/<code>staff</code>: one transaction: read the target doc(s), apply the gate, derive status from the snapshot's source shape, write <code>members</code> + <code>memberProfiles</code> (or <code>staffRoster</code>), or replace them with tombstones.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-148-  <li><strong><code>reconcile</code></strong> — validate the whole batch, then <strong>everything inside one transaction, redone from scratch on a retry</strong>: read every target and any override; for each item apply the gate; <strong>source-driven status change</strong> = <code>deriveStatus(stored source shape, today)</code> ≠ <code>deriveStatus(incoming source shape, today)</code> (both for today's Denver date — never compared with the stored, possibly day-old status); removals = live records held, not in <code>items</code>, not in <code>held</code>, with <code>sourceReadTime</code> older than the batch's readTime; apply Q8 (denominators = live held records minus <code>held</code> ids). Pass → write: a record whose <strong>whole snapshot</strong> is unchanged gets only its <code>sourceReadTime</code> advanced (the reconcile never writes a date-driven status — that's the recompute's, and a recompute stop isn't overridden); a record with any snapshot change (a name or email edit included) gets its new snapshot, status and profile. "Source shape" means only the fields <code>deriveStatus</code> reads and is used only for the status comparison. A tombstoned member who reappears counts as an addition, not a status change. Fail → nothing written, 409, and the log lists the counts and the affected <strong>ids</strong> (no personal data) so Christie can check them.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-149-  <li><strong>Overrides</strong> — collection <code>linkOverrides/{id}</code> (deny-all rule and rules test; Console only): exact keys per scope — <code>members</code>: <code>{scope, maxStatusChanges?, maxRemovals?, expiresAt, usedAt: null}</code> with at least one limit (an omitted limit keeps its normal Q8 value); <code>staff</code>: <code>{scope, maxRemovals, expiresAt, usedAt: null}</code>; <code>recompute</code>: <code>{scope, maxStatusChanges, expiresAt, usedAt: null}</code>. Integers 0–249; <code>expiresAt</code> a Timestamp no more than 24 h after the document's own Firestore <code>createTime</code> (refused otherwise); <code>usedAt</code> becomes a server timestamp when consumed. More than one unused, unexpired override for a scope → refuse all of them (error line) rather than choose. An override is used <strong>only when the normal limits would stop the run</strong> and its counts fit it; it's then consumed (<code>usedAt</code>) in the same transaction, and logs an error line naming the override id, scope, limits and counts — so every use emails Christie.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-150-  <li><strong><code>recomputeStatuses</code></strong> (09:30 UTC) — <strong>one transaction</strong> over every live member (above 249 → nothing written, error; alert from 200): re-derive status and the profile's <code>pause</code> for today's Denver date; count only <strong>unexplained</strong> changes — a change is explained when a pause start, a pause end + 1 day or a final-access date + 1 day falls after the member's stored <code>statusDate</code> and on or before today (each member stores <code>statusDate</code>, the Denver date its status was last derived for), so a busy 1st never stops it; over Q8's limit → write nothing, error log; otherwise write every changed <code>members.status</code> and profile together. A transaction retry recomputes everything, so an ingest that lands in between is never overwritten. It never blocks the reconcile, and the reconcile never applies the date-driven changes it stopped.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:151:  <li><strong><code>firestore.rules</code></strong>: explicit deny-all blocks for <code>members</code>, <code>memberProfiles</code>, <code>staffRoster</code>, <code>linkOverrides</code> with rules tests (<code>linkOverrides</code> stays deny-all for every client permanently — Phase F's manager settings never reach it); released through the rules guard <em>before</em> the function.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-152-  <li>Declarations, iam-expectations (<code>ingest@</code> and its custom role), a FUNCTIONS-ROLLBACK section with the stop/resume runbook and "what to do when a stop email arrives".</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-153-</ul>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-154-<p><strong>Tests first</strong> (emulator, Node 22): every fixture; the gate (earlier, equal, same millisecond with different nanos, malformed) and <strong>A→B→A out of order, single and through a reconcile</strong>; tombstones keep the last name and dates but drop email, emailLower and phoneLast4 (Q7); re-appearance restores the full allowlist; every D4 row through the real <code>deriveStatus</code>, stage-qualified; reconcile: exact thresholds and small denominators, additions, already-tombstoned, <code>held</code> ids untouched, duplicate ids → 400, a stop leaving every collection untouched, a removal racing a newer trigger (members <em>and</em> staff), source-driven counting (an unrelated edit on a pause's first day counts 0; a status-changing edit on a date boundary counts 1), an unchanged record advancing only <code>sourceReadTime</code>, a name-only change applied by the reconcile with 0 status changes, a reappearing member counted as an addition, the recompute ignoring changes its dates explain (a 1st with 15 pause starts doesn't stop) and stopping on unexplained ones, an override not consumed by a run that would have passed anyway, a transaction retry recomputing the counts, overrides (scope, bounds, expiry, single use, its error line, the 249 cap); recompute: one source change vs date changes, the stop with zero writes, a race with ingest in both orders, profiles' <code>pause</code> moving at a window boundary; staff: grant, ungrant, demotion, malformed, a tombstone for a never-held uid writes nothing, more than 1 removal stops; rules deny every client operation; no log contains a fixture's name, email or phone.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-155-<div class="bdd">Given members/m_7Q holds A with sourceReadTime T1
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-156-When envelopes for B (read T2) and A again (read T3) arrive T3 first, then T2
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-157-Then members/m_7Q ends at A with sourceReadTime T3
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-158-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-159-Given a reconcile whose held list contains m_7Q (two live source docs)
--
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-176-</ul>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-177-<p><strong>Acceptance:</strong> the new suite passes (ported + new: unexpected prompt, wording drift, end of input, a partial release continued on the same sha, every undeclared setting refused); the rules guard's suite passes unchanged plus its isolation test; the guard can't target any project but <code>tinker-hq-apps</code>.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-178-</div>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-179-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-180-<div class="phase">
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-181-<h3>E-4 — studio-hub: the <code>clayhub-link</code> codebase <span class="status-tag ready">execution-ready: true</span></h3>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-182-<ul>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-183-  <li><code>onClayHubMemberWritten</code>: memberIds from before and after; for each, one query on <code>memberId</code> only (its <code>QuerySnapshot.readTime</code>); the contract envelope; a conflict → error naming the memberId, nothing sent; no memberId → error naming the doc id only.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:184:  <li><code>onStaffUserWritten</code>: re-read <code>users/{uid}</code> (missing → tombstone) with that read's <code>DocumentSnapshot.readTime</code>; the staff rule.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-185-  <li><code>reconcileLink</code>: one read-only transaction pinned to one readTime over <code>clayHub_members</code> and <code>users</code>; validate the member set (held conflicts; abort on a missing/malformed memberId); any read error → nothing sent; then one <code>reconcile</code> call per scope; a 409 is logged as the stop.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-186-  <li>OIDC token from the metadata server, audience = the ingest URL constant; terminal responses only 200/400/409.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-187-  <li><code>functions/</code> sits under studio-hub's Netlify publish root and would be served with Tinker HQ — the code holds no secrets (accepted, as for the rules and scripts already there); <code>node_modules</code> is never committed.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-188-</ul>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-189-<p><strong>Tests first</strong> (Firestore emulator on non-default ports for the source; ingest faked): every fixture; late and duplicate deliveries; delete and re-create in both orders; an email change with the retired-old event before and after the new one; conflicts → <code>held</code> in a reconcile, nothing sent on a trigger; a live doc with a missing memberId aborts the reconcile; memberId A→B and A→B→C; a doc with no <code>retired</code> field is live; a partial read; 200/400/409 return normally, 401/403/404/429/5xx/timeout throw; 120 re-saved members with one real change → one envelope that changes a copied field; no write API is used (a test); no log holds personal data.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-190-<div class="bdd">Given Jane changes email: jane@new written live and jane@old retired in one batch
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-191-When the two events arrive old-first, new-first, or one is retried later
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-192-Then every envelope sent for her memberId describes the one live doc, jane@new
--
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-226-  <li><strong>K13</strong>: Christie removes the Compute account's project-wide <code>run.invoker</code> and <code>eventarc.eventReceiver</code> (the CLI's F13 grants, made only on a codebase's first event release — they come back if the triggers are ever deleted and recreated; noted in the rollback runbook).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-227-  <li><strong>Pub/Sub Token Creator reading</strong>: the Pub/Sub service agent holds <code>iam.serviceAccountTokenCreator</code> (the CLI adds it). If it's missing: stop here and ask Christie — a narrowly scoped grant is a recorded decision, not an improvisation.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-228-</ol>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-229-</div>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-230-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-231-<div class="phase">
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-232-<h3>E-8 — First fill, then delivery, proof, attest, spot check, fresh vault copy <span class="status-tag ready">execution-ready: true</span></h3>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-233-<ol>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:234:  <li><strong>First fill:</strong> Force run the paused <code>reconcileLink</code> (Christie clicks; logged; first confirm in the Console that a paused job can be Force run — if not, resume it, Force run, pause again). This is the first authenticated cross-project call and the first data. Counts match Membership Manager (live members; managers/admins in <code>staffRoster</code>).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-235-  <li><strong>Q9</strong>: Christie grants <code>run.invoker</code> to <code>clayhub-link@</code> on the two trigger services only. Events retried since the release now run: each re-reads its source, so it lands as <code>unchanged</code> or <code>applied</code>. The trigger-service 4xx alert fired as expected from the release until this grant.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-236-  <li><strong>Delivery proof after K13 removal:</strong> Christie saves one member in Membership Manager. Evidence, all three: the trigger's execution log timestamped after the removal, ingest's 200 for that memberId, and its stored <code>sourceReadTime</code> later than the removal. If it fails: <strong>stop the link</strong> (runbook) and re-plan — never restore broad grants.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-237-  <li>Resume <code>reconcileLink</code>; readings; <code>--attest</code> (needs the job ENABLED, Q9's invoker lists, Token Creator, and no K13 grants).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-238-  <li>Spot check three members (active; paused or with pause history; offboarding/cancelled if any) against Membership Manager: status, dates, and no forbidden field or malformed marker in any profile.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-239-  <li>Force run the vault export (fine once #64 is live) and verify the new complete folder — the first off-project copy with real member data. The vault plan's restore rehearsal follows.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-240-</ol>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-241-</div>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-242-
--
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-283-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-284-<h2 id="reviews">Reviews</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-285-<h3>Round 1 (Oct 8) — Codex "not ready" (9 blocking); Claude "ready after fixes" (3 blocking)</h3>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-286-<table>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-287-<tr><th>Finding</th><th>Resolution (v2)</th></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-288-<tr><td>The 10%/5% stops can't work from the sender, a partial reconcile isn't atomic, the first fill would trip them (both, blocking)</td><td>The <code>reconcile</code> kind: the receiver computes the whole change set and writes all-or-nothing; denominators defined; first fill exempt; Q8 floors.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-289-<tr><td>Nested notes/billing would leak; strict validation would hide malformed values from <code>deriveStatus</code> (both, blocking)</td><td>The contract: snapshots rebuilt from allowed keys at every level; malformed values carried as <code>"!malformed"</code>; fixtures for each.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-290-<tr><td>readTime has no wire format; same-millisecond reads collapse (both)</td><td>{seconds, nanos}, stored as a Timestamp, compared as a pair; tests.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:291:<tr><td>Staff input must fail closed; F5 overstated the schema (Codex, blocking; Claude should-fix)</td><td>The staff rule in the contract; F5 corrected; tests.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-292-<tr><td>K13 relies on an unproven delivery identity; a code search isn't a workload audit (Codex, blocking)</td><td>E-5 inventory and audit logs; E-8 step 2 proves delivery after the removal; Q3 rewritten.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-293-<tr><td>The E-6 OIDC probe had no mechanism; the synthetic member (Codex, blocking; Claude should-fix)</td><td>Dropped: E-6 proves 403 and the invoker reading; the first authenticated call is E-8's logged first fill.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-294-<tr><td>The stop procedure is refused by the guard (both)</td><td>"Stopping the link": Console pause + invoker removal, then a guarded <code>["private"]</code> redeploy.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-295-<tr><td>Decisions and gates too late (Codex, blocking)</td><td>E-pre; E-7 lists every gate, including #64; E-8 adds a fresh vault copy.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-296-<tr><td>Recompute needs atomicity and race handling (Codex, blocking)</td><td>Dry run, then per-member transactions re-reading; profiles in step; tests both orders.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-297-<tr><td>Adding functions to studio-hub can break the rules guard (Claude, blocking)</td><td>E-3: rules guard untouched, functions suites outside <code>npm test</code>, an isolation test, a dry rules <code>--status</code>/<code>--diff</code>.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-298-<tr><td>Should-fix: settings; alerts before go-live; schedule boundary; retry handling; tombstone privacy; Quick Log pauses; phone rule; URL constant; App Engine account, Pub/Sub Token Creator; F4/F10/F11 wording; read access to the whole database</td><td>The settings table; E-7 step 1 and its timing; the Responses row; Q7; Q6; the phone row; the note; E-3/E-5; facts corrected; F12.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-299-</table>
--
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-303-<tr><th>Finding</th><th>Resolution (v3)</th></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-304-<tr><td>A conflicted or malformed source set can make the reconcile remove the wrong member (both, blocking)</td><td>The reconcile carries <code>held</code> conflicts; a missing/malformed memberId aborts the member reconcile; the receiver rejects duplicates, never touches <code>held</code>, never removes a record newer than the batch.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-305-<tr><td>"Unchanged" must advance <code>sourceReadTime</code> (Claude, blocking)</td><td>The gate row: every applied envelope advances it; A→B→A tests.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-306-<tr><td>Event triggers have no invoker in the design (Claude, blocking; confirmed in the CLI source)</td><td>F13; Q9; declared invoker lists for event triggers, attested; E-7 step 4.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-307-<tr><td>Staff rule inconsistent; thresholds unsafe for a small roster (Codex, blocking; Claude should-fix)</td><td>Only granted staff are sent; tombstones for never-held uids write nothing; a staff stop at more than 1 removal.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-308-<tr><td>Contract not exact: types, nulls, profiles, tombstones (Codex, blocking; Claude should-fix)</td><td>The contract: every field's type and fallback; <code>memberProfiles</code> and its pause rule; three tombstone schemas; malformed canonicalized (no raw text crosses); <code>processed</code> for Q6.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-309-<tr><td>Recompute not atomic (Codex, blocking)</td><td>One transaction (≤ 250 members), status and profile together, retry recomputes.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-310-<tr><td>Settings table incomplete / wrong names (Codex, blocking; Claude should-fix)</td><td>Rewritten with the guard's exact keys and every limit; values pinned by unit tests.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:311:<tr><td>Should-fix: 401/403 swallowed; stop runbook vs scheduler attestation; a stop cascading; the K13 failure path; Pub/Sub Token Creator; E-7 order vs attestation; E-8 proof that could pass vacuously; first-fill exemption redundant; rules port 8080 and <code>firebase.json</code>; E-0 sequencing; Netlify publish root; alert channel in tinker-hq-apps; 250-member cap; clayhub-link@ reading in my-clay-hub; phone rule</td><td>Responses row; the runbook (recompute keeps running); source-driven counting and <code>settings/linkLimits</code>; "stop and re-plan"; E-3 attestation; E-7/E-8 reordered (pause, Q9, K13, first fill, proof, then attest); evidence-based proof; exemption dropped; E-3 isolation test; E-0 first; E-4 note; E-5 step 2; settings note; E-6; <code>formatPhone</code>.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-312-</table>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-313-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-314-<h3>Round 3 (Oct 8) — Codex "not ready" (2 blocking); Claude "ready after fixes" (0 blocking; its first attempt hit a usage limit and was re-run)</h3>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-315-<table>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-316-<tr><th>Finding</th><th>Resolution (v4)</th></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-317-<tr><td>"Source-driven" has no implementable rule (Codex, blocking); the reconcile would write date-driven changes a recompute stop refused (Claude)</td><td>Counterfactual rule for today's date inside the transaction; unchanged sources advance only <code>sourceReadTime</code>; tests for both coincidences.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-318-<tr><td>The override isn't a safe one-time contract (Codex, blocking); <code>settings</code> opens to managers in Phase F (Claude)</td><td><code>linkOverrides</code>: own deny-all collection, exact schema, scope, bounds, 24 h expiry, consumed in the same transaction, an error line per use; the 249-member cap; the runbook checks ids before creating one.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-319-<tr><td>Q6: <code>processed</code> doesn't match Membership Manager; malformed must be checked first (both)</td><td>Membership Manager's own "present" test; malformed-container-first order; fixtures with the real ISO shape.</td></tr>
--
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-333-<tr><td>The reconcile could skip name/email/phone repairs (Claude)</td><td>"Whole snapshot unchanged" for the advance-only rule; "source shape" only for the status comparison; name-only test.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-334-<tr><td>The recompute still stops on a legitimate busy 1st (Claude)</td><td>It counts only changes no pause/last-day date explains, using a stored <code>statusDate</code>; tests.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-335-<tr><td>Nits: stale step references; "dropped as stale" wording; duplicated test; reappearing member counting</td><td>Fixed; the E-8 step 2 wording and expected alert; a reappearance is an addition.</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-336-</table>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-337-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-338-<h2>Decisions log</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-339-<ul>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-340-  <li><strong>Oct 8:</strong> Christie: "mark it ready and start E-pre" — every phase execution-ready: true.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html:341:  <li><strong>Oct 8 — E-pre done:</strong> PR #13 (docs: DECISIONS #65–#73, SPEC, DATA-MODEL) merged at <code>a4b8e21</code> (head <code>ee1e5b3</code>); PR #14 (<code>deriveStatus</code> ignores an unprocessed <code>scheduledPause</code>, #70) merged at <code>3cd273a</code> (head <code>09c5f95</code>), both with Christie's "yes" to merge. Reviews: round 1 Codex (#13 merge after fixes, 2 blocking — UTC/Denver wording, #72's counting rule; #14 safe) and Claude (#13 merge after fixes, 0 blocking; #14 safe); all applied; round 2 Codex confirming on #13: safe to merge, no findings. Full suite on #14: unit 233, rules guard 199, functions guard 944, emulator 68+2+3, rules 194. Nothing released. Note: Monday's vault <code>--diff</code> will list <code>shared/</code> as changed (the guard pins it; the vault codebase doesn't use it). Next: E-0 (studio-hub users-rules pins), after Monday's V-4 finish and the #64 release.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-342-  <li><strong>Oct 8 — Christie's answers:</strong> Q1 09:30 UTC; Q2 inside, own PR; Q3 audit → strip → remove → prove; Q4 build the roster now; Q5 a new memberId is a new identity; Q6 <strong>B</strong> (unprocessed Quick Log pauses don't block booking); Q7 <strong>keep name, member-since, stage and every pause/last-day date; drop email, emailLower, phoneLast4</strong> (her change: "useful and isn't sensitive"); Q8 as described; Q9 one recorded per-service exception. E-pre writes these into DECISIONS/SPEC/DATA-MODEL.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-343-  <li><strong>Oct 8:</strong> v1 drafted from the foundation plan's Phase E outline after research (F1–F11).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-344-  <li><strong>Oct 8:</strong> review round 1 (Codex "not ready", 9 blocking; Claude "ready after fixes", 3 blocking, 13 should-fix) → v2: the contract, the receiver-side reconcile, E-pre, the stop runbook, the settings table, E-5's audit, the K13 proof; Q6–Q8 added. Review files <code>thoughts/reviews/my-clay-hub-phase-e-plan-round1-*</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-345-  <li><strong>Oct 8:</strong> review round 2 (Codex "not ready", 5 blocking; Claude "ready after fixes", 3 blocking) → v3: <code>held</code> conflicts and race-safe removals, the readTime advance, Q9 (event-trigger invoker — confirmed in firebase-tools 15.22.3 source), exact schemas and tombstones, a one-transaction recompute, the full settings table, the reordered E-7/E-8, the stop-email path. Both reviewers recommend Q6 = B. Review files <code>…-round2-*</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-346-  <li><strong>Oct 8:</strong> review round 3 (Codex "not ready", 2 blocking; Claude "ready after fixes", 0 blocking — both confirm every round-2 finding resolved and Q9's design against the CLI source) → v4: the counterfactual source-driven rule, <code>linkOverrides</code>, Q6's exact rule and order, the E-7/E-8 order, the Token Creator gate, two stop kinds, the trigger-service alert, the E-2 merge timing. Review files <code>…-round3-*</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-347-  <li><strong>Oct 8:</strong> review round 4 (both "ready after fixes", 0 blocking) → v4.1: exact per-scope overrides used only when needed, whole-snapshot repair, the recompute's explained-change rule with <code>statusDate</code>, nits. The plan is ready for execution once Christie answers Q1–Q9 (a confirming pass will re-check anything her answers change). Review files <code>…-round4-*</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-348-</ul>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html-349-
--
firestore.rules-105-    // Manager+: read all user docs.
firestore.rules-106-    // Self-update: role field must not change.
firestore.rules-107-    // Manager update: cannot change role field, cannot delete.
firestore.rules-108-    // Admin: full create / update / delete.
firestore.rules-109-    // ═══════════════════════════════════════════════════════════════
firestore.rules-110-
firestore.rules-111-    match /users/{userId} {
firestore.rules-112-      // My Clay Hub depends on these (Phase E): the clayhub-link functions read each users doc's
firestore.rules:113:      // role, active and appAccess to decide who is in my-clay-hub's staffRoster (who can use its
firestore.rules-114-      // /staff screens), and store only name and role there. So no one may raise their own role,
firestore.rules-115-      // grant themselves appAccess, or change their own active: staff and managers can't touch
firestore.rules:116:      // any of the three on their own doc; an admin can't change their own active, and changing
firestore.rules-117-      // their own role or appAccess can only demote them (admins are already granted). name is
firestore.rules-118-      // self-editable and display-only there. Pinned by rules.test.js "Users — fields My Clay Hub
firestore.rules-119-      // relies on"; loosening any of this changes who is staff in My Clay Hub too.
firestore.rules-120-      // Own doc read — all authenticated users (auth guard requires it). Not the reminder bot: its
firestore.rules-121-      // grant is GET-only below, and this `read` would let an id-constrained LIST through.
firestore.rules-122-      allow read: if isAuthenticated() && request.auth.uid == userId && !isReminderBot();
firestore.rules-123-      // Manager+ reads all user docs (team filters, admin panels, etc.)
firestore.rules-124-      allow read: if isManagerOrAbove();
--
firestore.rules-129-
firestore.rules-130-      // Self-create: role must be 'staff' (prevents self-promotion), and
firestore.rules-131-      // appAccess must be absent or empty — app access is granted by an
firestore.rules-132-      // admin/manager via Manage Team, never by the user themselves.
firestore.rules-133-      // studios is NOT locked to empty here: the real bootstrap write (see
firestore.rules-134-      // js/app.js handleAuthStateChange) always sets studios: ['tinker',
firestore.rules-135-      // 'clayhub'] — both known studios, granted to every new user by
firestore.rules-136-      // default — so hasOnly() permits exactly that shape while still
firestore.rules:137:      // blocking a self-create from injecting any value outside the two
firestore.rules-138-      // known studios (there's no smaller "safe default" to enforce here
firestore.rules-139-      // since the app already grants both to everyone; appAccess is the
firestore.rules-140-      // field that actually gates privilege).
firestore.rules-141-      // The reminder bot is a job, not a person: it can never bootstrap a users doc for itself, so it
firestore.rules-142-      // can never become "an active staff user" to isActiveUser()/hasAppAccess().
firestore.rules:143:      allow create: if isAuthenticated()
firestore.rules-144-        && request.auth.uid == userId
firestore.rules-145-        && !isReminderBot()
firestore.rules-146-        && request.resource.data.role == 'staff'
firestore.rules-147-        && (!('appAccess' in request.resource.data) || request.resource.data.appAccess.size() == 0)
firestore.rules-148-        && (!('studios' in request.resource.data) || request.resource.data.studios.hasOnly(['tinker', 'clayhub']));
firestore.rules-149-
firestore.rules-150-      // Self-update: role, appAccess, and studios must not change.
firestore.rules-151-      // Without pinning appAccess/studios here, any authenticated staff
firestore.rules-152-      // user could grant themselves access to any app (KPI, Classbook,
firestore.rules-153-      // Payroll-adjacent tools, etc.) with a direct Firestore write that
firestore.rules-154-      // bypasses the Manage Team UI entirely.
firestore.rules:155:      allow update: if isAuthenticated()
firestore.rules-156-        && request.auth.uid == userId
firestore.rules-157-        && !isReminderBot()
firestore.rules-158-        && request.resource.data.role == resource.data.role
firestore.rules-159-        && fieldUnchanged('appAccess')
firestore.rules-160-        && fieldUnchanged('studios')
firestore.rules-161-        && fieldUnchanged('active');
firestore.rules-162-
firestore.rules-163-      // Manager update: cannot change role field, cannot delete.
firestore.rules-164-      // Restricted to OTHER users' docs (request.auth.uid != userId) —
firestore.rules-165-      // without this guard, a manager editing their OWN doc would satisfy
firestore.rules-166-      // isManager() and bypass the appAccess/studios pins on the self-update
firestore.rules:167:      // rule above entirely, since Firestore OR's sibling `allow update`
firestore.rules-168-      // rules together. A manager's own self-edits go through the
firestore.rules-169-      // self-update rule instead, which does pin those fields. Found by
firestore.rules-170-      // independent second-model review before this shipped — see
firestore.rules-171-      // firebase-agent-defense-hardening.md.
firestore.rules-172-      // A manager also cannot flip an admin's `active` field (archive/
firestore.rules-173-      // reactivate) — only another admin can. Managers keep full appAccess/
firestore.rules-174-      // studios editing on admins; that pre-existing gap stays out of scope.
firestore.rules:175:      allow update: if isManager()
firestore.rules-176-        && request.auth.uid != userId
firestore.rules-177-        && request.resource.data.role == resource.data.role
firestore.rules-178-        && (resource.data.role != 'admin' || fieldUnchanged('active'));
firestore.rules-179-
firestore.rules-180-      // Admin: full create / update / delete on OTHER users' docs. An admin
firestore.rules-181-      // can never change their OWN `active` field via this (or any) rule —
firestore.rules-182-      // without this guard this blanket rule sits outside the self-update
firestore.rules-183-      // rule's fieldUnchanged('active') pin (Firestore ORs sibling `allow`
--
firestore.rules-208-    // Payroll Tool settings history — an append-only recovery log.
firestore.rules-209-    // Manager+ may read and create; nothing may update or delete an entry.
firestore.rules-210-    // A create must ride in the same transaction that moves the parent's
firestore.rules-211-    // settingsRev (getAfter tie), carry the caller's own email and a server
firestore.rules-212-    // timestamp, and have exactly the declared shape.
firestore.rules-213-    // Plan: tinker-ai-configs/thoughts/plans/payroll-settings-safety-and-seasons.html
firestore.rules-214-    match /payroll/appData/settingsHistory/{histId} {
firestore.rules-215-      allow read: if isManagerOrAbove();
firestore.rules:216:      allow create: if isManagerOrAbove()
firestore.rules-217-        && request.resource.data.keys().hasAll(['settings','hash','rev','savedAt','savedBy','kind','summary','configVersion'])
firestore.rules-218-        && request.resource.data.keys().hasOnly(['settings','hash','rev','savedAt','savedBy','kind','summary','configVersion','recovered'])
firestore.rules-219-        && request.resource.data.settings is map
firestore.rules-220-        && request.resource.data.hash is string
firestore.rules-221-        && request.resource.data.rev is int
firestore.rules-222-        && request.resource.data.summary is string
firestore.rules-223-        && request.resource.data.configVersion is int
firestore.rules-224-        && request.resource.data.savedBy == request.auth.token.email
--
firestore.rules-301-          && d.keys().hasAll(['staff', 'updatedAt', 'checkedAt', 'updatedBy'])
firestore.rules-302-          && d.staff is list && d.staff.size() <= 300
firestore.rules-303-          && isIsoInstant(d.updatedAt) && isIsoInstant(d.checkedAt)
firestore.rules-304-          && d.updatedBy == request.auth.uid;
firestore.rules-305-      }
firestore.rules-306-
firestore.rules-307-      allow get: if !isKiosk() && isActiveUser() && docId != '_summary' && request.auth.uid == docId;
firestore.rules-308-      allow get, list: if !isKiosk() && isManagerOrAbove();
firestore.rules:309:      allow create, update: if !isKiosk() && isManagerOrAbove()
firestore.rules-310-        && (docId == '_summary' ? isCelebrationSummary(request.resource.data)
firestore.rules-311-                                : isCelebrationRecord(request.resource.data));
firestore.rules-312-      // no delete
firestore.rules-313-    }
firestore.rules-314-
firestore.rules-315-
firestore.rules-316-    // ═══════════════════════════════════════════════════════════════
firestore.rules-317-    // TRAINING
--
firestore.rules-334-    match /trainingPrograms/{docId} {
firestore.rules-335-      allow read, create, update: if isManagerOrAbove() || hasAppAccess('training');
firestore.rules-336-      allow delete: if isManagerOrAbove();
firestore.rules-337-    }
firestore.rules-338-
firestore.rules-339-    match /trainingAssignments/{docId} {
firestore.rules-340-      allow read, write: if isManagerOrAbove();
firestore.rules-341-
firestore.rules:342:      allow create: if hasAppAccess('training')
firestore.rules-343-        && request.resource.data.memberId == request.auth.uid;
firestore.rules-344-
firestore.rules-345-      allow read: if hasAppAccess('training')
firestore.rules-346-        && resource.data.memberId == request.auth.uid;
firestore.rules-347-
firestore.rules:348:      allow update: if hasAppAccess('training')
firestore.rules-349-        && resource.data.memberId == request.auth.uid
firestore.rules-350-        && request.resource.data.memberId == resource.data.memberId;
firestore.rules-351-
firestore.rules-352-      allow delete: if isManagerOrAbove();
firestore.rules-353-    }
firestore.rules-354-
firestore.rules-355-    match /trainingEmailLogs/{docId} {
firestore.rules-356-      allow read: if isManagerOrAbove();
firestore.rules:357:      allow create: if isManagerOrAbove();
firestore.rules-358-    }
firestore.rules-359-
firestore.rules-360-    match /trainingObservations/{docId} {
firestore.rules-361-      // Manager creates and reads all observation records
firestore.rules-362-      allow read, write: if isManagerOrAbove();
firestore.rules-363-      // Staff can read only their own PUBLISHED observation notes.
firestore.rules-364-      // The status check is load-bearing: a draft is a manager's unfinished,
firestore.rules-365-      // unreviewed assessment of that person. The Training Hub only filters drafts
--
firestore.rules-459-    // streaks:   Staff with access — own doc only (read/write)
firestore.rules-460-    // ═══════════════════════════════════════════════════════════════
firestore.rules-461-
firestore.rules-462-    match /timeclock_entries/{docId} {
firestore.rules-463-      allow read, write: if isManagerOrAbove();
firestore.rules-464-      // Kiosk: read + create entries (needs to read today's status after PIN entry)
firestore.rules-465-      allow read, create: if isKiosk();
firestore.rules-466-      // Staff with access: own entries only
firestore.rules:467:      allow create: if hasAppAccess('timeclock')
firestore.rules-468-        && request.resource.data.uid == request.auth.uid;
firestore.rules-469-      allow read: if hasAppAccess('timeclock')
firestore.rules-470-        && resource.data.uid == request.auth.uid;
firestore.rules:471:      allow update: if hasAppAccess('timeclock')
firestore.rules-472-        && resource.data.uid == request.auth.uid;
firestore.rules-473-    }
firestore.rules-474-
firestore.rules-475-    match /timeclock_schedules/{uid} {
firestore.rules-476-      allow read, write: if isManagerOrAbove();
firestore.rules-477-      // Staff with access: read-only
firestore.rules-478-      allow read: if hasAppAccess('timeclock');
firestore.rules-479-      // Kiosk: read schedules (to detect late clock-outs)
firestore.rules-480-      allow read: if isKiosk();
firestore.rules-481-      // Reminder bot: read every schedule (list + get) to find flagged shifts; never write.
firestore.rules-482-      allow read: if isReminderBot();
firestore.rules-483-    }
firestore.rules-484-
firestore.rules-485-    match /timeclock_hfwa/{docId} {
firestore.rules-486-      allow read, write: if isManagerOrAbove();
firestore.rules-487-      // Staff with access: own doc only
firestore.rules:488:      allow create: if hasAppAccess('timeclock')
firestore.rules-489-        && request.resource.data.uid == request.auth.uid;
firestore.rules-490-      allow read: if hasAppAccess('timeclock')
firestore.rules-491-        && resource.data.uid == request.auth.uid;
firestore.rules-492-    }
firestore.rules-493-
firestore.rules-494-    match /timeclock_timeoff/{docId} {
firestore.rules-495-      allow read, write: if isManagerOrAbove();
firestore.rules-496-      // Staff with access: own doc only
firestore.rules:497:      allow create: if hasAppAccess('timeclock')
firestore.rules-498-        && request.resource.data.uid == request.auth.uid;
firestore.rules-499-      allow read: if hasAppAccess('timeclock')
firestore.rules-500-        && resource.data.uid == request.auth.uid;
firestore.rules:501:      allow update: if hasAppAccess('timeclock')
firestore.rules-502-        && resource.data.uid == request.auth.uid;
firestore.rules-503-    }
firestore.rules-504-
firestore.rules-505-    match /timeclock_settings/{docId} {
firestore.rules-506-      allow read, write: if isManagerOrAbove();
firestore.rules-507-      // Staff with access: read-only
firestore.rules-508-      allow read: if hasAppAccess('timeclock');
firestore.rules-509-      // Staff can write the employees doc for name claiming
--
firestore.rules-535-    // Tinker Ticker — 48-hour shift reminders: one document per (schedule document, date), created by the
firestore.rules-536-    // reminder bot as a CLAIM before it sends and then resolved (sentAt, or attempts/error). The claim is
firestore.rules-537-    // the dedupe — two overlapping runs cannot both send — and the audit trail the Reminders view shows.
firestore.rules-538-    // Managers read it (it holds staff email addresses, so staff never can). Nobody updates a resolved
firestore.rules-539-    // claim, nobody deletes, and the bot can only create a claim for a schedule that exists.
firestore.rules-540-    match /timeclock_reminder_log/{logId} {
firestore.rules-541-      allow read: if isManagerOrAbove();
firestore.rules-542-      allow get: if isReminderBot();
firestore.rules:543:      allow create: if isReminderBot()
firestore.rules-544-        && request.resource.data.keys().hasOnly(['uid', 'date', 'to', 'shift', 'claimedAt', 'sentAt', 'attempts'])
firestore.rules-545-        && request.resource.data.keys().hasAll(['uid', 'date', 'to', 'shift', 'claimedAt', 'sentAt', 'attempts'])
firestore.rules-546-        && request.resource.data.uid is string
firestore.rules-547-        && request.resource.data.uid.size() > 0 && request.resource.data.uid.size() <= 64
firestore.rules-548-        && request.resource.data.date is string
firestore.rules-549-        && request.resource.data.date.matches('^[0-9]{4}-[0-9]{2}-[0-9]{2}$')
firestore.rules-550-        && logId == request.resource.data.uid + '_' + request.resource.data.date
firestore.rules-551-        && request.resource.data.to is string
--
firestore.rules-557-        && request.resource.data.shift.end is string && request.resource.data.shift.end.size() <= 20
firestore.rules-558-        && request.resource.data.shift.studio is string && request.resource.data.shift.studio.size() <= 40
firestore.rules-559-        && request.resource.data.shift.note is string && request.resource.data.shift.note.size() <= 200
firestore.rules-560-        && request.resource.data.claimedAt == request.time
firestore.rules-561-        && request.resource.data.sentAt == null
firestore.rules-562-        && request.resource.data.attempts == 0
firestore.rules-563-        && exists(/databases/$(database)/documents/timeclock_schedules/$(request.resource.data.uid));
firestore.rules-564-      // Resolving a claim: only while unresolved, only the outcome fields, bounded attempts, server time.
firestore.rules:565:      allow update: if isReminderBot()
firestore.rules-566-        && resource.data.sentAt == null
firestore.rules-567-        && request.resource.data.diff(resource.data).affectedKeys().hasOnly(['sentAt', 'attempts', 'lastAttemptAt', 'error'])
firestore.rules-568-        && request.resource.data.attempts is int
firestore.rules-569-        && request.resource.data.attempts >= resource.data.attempts
firestore.rules-570-        && request.resource.data.attempts <= 3
firestore.rules-571-        && (request.resource.data.sentAt == null || request.resource.data.sentAt == request.time)
firestore.rules-572-        // request.resource.data is the whole POST-write document, so a lastAttemptAt stamped by an earlier
firestore.rules-573-        // failed attempt is still there when a later update only marks sentAt — check it only when this
--
firestore.rules-621-    function onlyActionItemsChanged() {
firestore.rules-622-      return request.resource.data.diff(resource.data).affectedKeys().hasOnly(['summary'])
firestore.rules-623-        && 'summary' in resource.data && resource.data.summary is map
firestore.rules-624-        && 'summary' in request.resource.data && request.resource.data.summary is map
firestore.rules-625-        && request.resource.data.summary.diff(resource.data.summary).affectedKeys().hasOnly(['beforeNextMeeting']);
firestore.rules-626-    }
firestore.rules-627-
firestore.rules-628-    match /meetings/{docId} {
firestore.rules:629:      allow create: if (isManagerOrAbove() || hasAppAccess('recap'))
firestore.rules-630-        && request.resource.data.createdBy == request.auth.uid
firestore.rules-631-        && (request.resource.data.business != 'personal' || isAdmin())
firestore.rules-632-        // A non-manager cannot create a meeting that is already shared —
firestore.rules-633-        // closes the create (and delete-then-recreate) route around the
firestore.rules-634-        // update-time sharedWith pin below.
firestore.rules-635-        && (isManagerOrAbove() || request.resource.data.get('sharedWith', []) == []);
firestore.rules-636-
firestore.rules-637-      allow read: if (isManagerOrAbove() || hasAppAccess('recap'))
firestore.rules-638-        && (
firestore.rules-639-          resource.data.createdBy == request.auth.uid
firestore.rules-640-          || (resource.data.business != 'personal' && (
firestore.rules-641-               request.auth.uid in resource.data.get('sharedWith', [])
firestore.rules-642-               || isManagerOrAbove()
firestore.rules-643-             ))
firestore.rules-644-        );
firestore.rules-645-
firestore.rules:646:      allow update: if (isManagerOrAbove() || hasAppAccess('recap'))
firestore.rules-647-        && (resource.data.business == 'personal' || request.resource.data.business != 'personal' || isAdmin())
firestore.rules-648-        && request.resource.data.createdBy == resource.data.createdBy
firestore.rules-649-        && (
firestore.rules-650-          // Creator — a non-manager creator cannot change who the meeting is
firestore.rules-651-          // shared with. Compared as the EFFECTIVE list, absent ≡ [], so the
firestore.rules-652-          // production-default document (no sharedWith key at all, which is
firestore.rules-653-          // what .add() writes) stays editable, and a harmless round-trip
firestore.rules-654-          // that writes [] onto it still passes; any real change is denied.
--
firestore.rules-787-          && !('spring-2026' in resource.data)
firestore.rules-788-          && exists(/databases/$(database)/documents/curriculum/lessons_spring-2026)
firestore.rules-789-          && !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
firestore.rules-790-          && !springMoveVerified();
firestore.rules-791-      }
firestore.rules-792-
firestore.rules-793-      // Manager+: full access to everything including appData (reads; ordinary-doc writes)
firestore.rules-794-      allow read: if isManagerOrAbove();
firestore.rules:795:      allow create, update, delete: if isManagerOrAbove() && !isStorageMoveDoc();
firestore.rules-796-
firestore.rules-797-      // classbook-admin, curriculum-admin (legacy key), and classbook: full read/write except appData and prepCycleConfig
firestore.rules-798-      // appData (Settings) is manager+ only, always
firestore.rules-799-      // prepCycleConfig (Prep Cycle workflow config) is classbook-admin only
firestore.rules-800-      // NOTE: 'classbook' (plain teacher) access is intentionally NOT
firestore.rules-801-      // isolated per-teacher here — each semester's lessons live in one
firestore.rules-802-      // shared doc, and per-field isolation is enforced by the UI, not
firestore.rules-803-      // by these rules. This is a known, accepted gap (see
firestore.rules-804-      // firebase-agent-defense-hardening.md) pending a possible future
firestore.rules-805-      // data-model change, not something this rule can close on its own.
firestore.rules-806-      allow read: if isClassbookRole();
firestore.rules:807:      allow create, update: if
firestore.rules-808-        isClassbookRole()
firestore.rules-809-        && docId != 'appData'
firestore.rules-810-        && docId != 'prepCycleConfig'
firestore.rules-811-        && !isStorageMoveDoc();
firestore.rules-812-      // Whole-document delete is classbook-admin/curriculum-admin only.
firestore.rules-813-      // Plain 'classbook' (teacher) access never calls a full-document
firestore.rules-814-      // delete in the app (only FieldValue.delete() on specific lesson
firestore.rules-815-      // fields, which is an update, not a delete) — so this closes an
firestore.rules-816-      // unused, high-blast-radius capability with no functional change.
firestore.rules-817-      allow delete: if
firestore.rules-818-        isClassbookAdminRole()
firestore.rules-819-        && docId != 'appData'
firestore.rules-820-        && docId != 'prepCycleConfig'
firestore.rules-821-        && !isStorageMoveDoc();
firestore.rules-822-      // prepCycleConfig: classbook-admin and curriculum-admin write only
firestore.rules:823:      allow create, update, delete: if
firestore.rules-824-        isClassbookAdminRole()
firestore.rules-825-        && docId == 'prepCycleConfig';
firestore.rules-826-
firestore.rules-827-      // lessonData: as before for every semester except 'spring-2026'; no whole-document delete;
firestore.rules-828-      // no new top-level key outside lessonDataAllowedNewKeys(). The manager-only removal/rollback
firestore.rules-829-      // statement below is deliberately NOT fenced: it can only ever touch 'spring-2026'.
firestore.rules:830:      allow create: if docId == 'lessonData'
firestore.rules-831-        && (isManagerOrAbove() || isClassbookRole())
firestore.rules-832-        && !('spring-2026' in request.resource.data)
firestore.rules-833-        && request.resource.data.keys().hasOnly(lessonDataAllowedNewKeys());
firestore.rules:834:      allow update: if docId == 'lessonData'
firestore.rules-835-        && (isManagerOrAbove() || isClassbookRole())
firestore.rules-836-        && springKeyUntouched()
firestore.rules-837-        && noNewLessonDataKeys();
firestore.rules:838:      allow update: if docId == 'lessonData'
firestore.rules-839-        && isManagerOrAbove()
firestore.rules-840-        && (springKeyRemovedOnly() || springKeyRolledBack());
firestore.rules-841-
firestore.rules-842-      // lessons_spring-2026: Spring 2026's lessons after the move.
firestore.rules:843:      allow create: if docId == 'lessons_spring-2026' && isManagerOrAbove();
firestore.rules:844:      allow update: if docId == 'lessons_spring-2026'
firestore.rules-845-        && (isManagerOrAbove() || isClassbookRole())
firestore.rules-846-        && springMoveVerified();
firestore.rules-847-      allow delete: if docId == 'lessons_spring-2026'
firestore.rules-848-        && isManagerOrAbove()
firestore.rules-849-        && !springMoveVerified();
firestore.rules-850-
firestore.rules-851-      // lessons_<semKey>: every other weekly semester's lessons (see the header above).
firestore.rules:852:      allow create: if isNewLessonsDoc()
firestore.rules-853-        && isManagerOrAbove()
firestore.rules-854-        && semesterInConfigAfter(lessonsSemKey());
firestore.rules:855:      allow update: if isNewLessonsDoc()
firestore.rules-856-        && (isManagerOrAbove() || isClassbookRole())
firestore.rules-857-        && migrationAllowsEdit(lessonsSemKey())
firestore.rules-858-        && semesterInConfigAfter(lessonsSemKey());
firestore.rules-859-      allow delete: if isNewLessonsDoc()
firestore.rules-860-        && isManagerOrAbove()
firestore.rules-861-        && (!semesterInConfigAfter(lessonsSemKey()) || !migrationAllowsEdit(lessonsSemKey()));
firestore.rules-862-
firestore.rules-863-      // storageMigrations: the move's record (manager+ writes; read via the read lines above).
--
firestore.rules-868-      function springVerifiedIn(data) {
firestore.rules-869-        return data.get('spring-2026', {}).get('verified', false) == true;
firestore.rules-870-      }
firestore.rules-871-      function springVerifyTransitionOk() {
firestore.rules-872-        return !springVerifiedIn(request.resource.data)
firestore.rules-873-          || (existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
firestore.rules-874-              && !('spring-2026' in getAfter(/databases/$(database)/documents/curriculum/lessonData).data));
firestore.rules-875-      }
firestore.rules:876:      allow create: if docId == 'storageMigrations'
firestore.rules-877-        && isManagerOrAbove()
firestore.rules-878-        && springVerifyTransitionOk();
firestore.rules:879:      allow update: if docId == 'storageMigrations'
firestore.rules-880-        && isManagerOrAbove()
firestore.rules-881-        && (springVerifiedIn(resource.data)
firestore.rules-882-              ? springVerifiedIn(request.resource.data)
firestore.rules-883-              : springVerifyTransitionOk());
firestore.rules-884-    }
firestore.rules-885-
firestore.rules-886-    // ═══════════════════════════════════════════════════════════════
firestore.rules-887-    // CLASSBOOK — SCHOOL DAY OFF CAMPS (SDOCs)
--
firestore.rules-892-    //     summerCamps_lessonData (per-teacher isolation is UI-enforced — the same accepted gap as
firestore.rules-893-    //     summer); whole-document delete is admin-only, like /curriculum's delete clause.
firestore.rules-894-    //   The legacy 'curriculum-admin' key is deliberately NOT extended to these new collections.
firestore.rules-895-    //   Visibility of an unpublished year is UI gating only: every classbook teacher can read these.
firestore.rules-896-    // ═══════════════════════════════════════════════════════════════
firestore.rules-897-
firestore.rules-898-    match /dayOffCamps_events/{docId} {
firestore.rules-899-      allow read: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
firestore.rules:900:      allow create, update, delete: if isManagerOrAbove() || hasAppAccess('classbook-admin');
firestore.rules-901-    }
firestore.rules-902-
firestore.rules-903-    match /dayOffCamps_camps/{docId} {
firestore.rules-904-      allow read: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
firestore.rules:905:      allow create, update, delete: if isManagerOrAbove() || hasAppAccess('classbook-admin');
firestore.rules-906-    }
firestore.rules-907-
firestore.rules-908-    match /dayOffCamps_lessonData/{docId} {
firestore.rules-909-      allow read: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
firestore.rules:910:      allow create, update: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
firestore.rules-911-      allow delete: if isManagerOrAbove() || hasAppAccess('classbook-admin');
firestore.rules-912-    }
firestore.rules-913-
firestore.rules-914-
firestore.rules-915-    // ═══════════════════════════════════════════════════════════════
firestore.rules-916-    // ROSTER MANAGER — Tinker studio only.
firestore.rules-917-    // Manager+ or appAccess('roster-manager'): full read/write.
firestore.rules-918-    // Delete: manager+ only.
--
firestore.rules-975-        || hasAppAccess('summer-camp')
firestore.rules-976-        || hasAppAccess('team')
firestore.rules-977-        || hasAppAccess('classbook')
firestore.rules-978-        || hasAppAccess('classbook-admin')
firestore.rules-979-        || hasAppAccess('curriculum-admin');
firestore.rules-980-
firestore.rules-981-      // A season doc's ID IS its season — both apps look the doc up by ID and then trust the
firestore.rules-982-      // `season` field, so the two must never disagree. Never `_current`, which is the switch.
firestore.rules:983:      allow create, update: if isManagerOrAbove()
firestore.rules-984-        && docId != '_current'
firestore.rules-985-        && request.resource.data.season == docId;
firestore.rules-986-
firestore.rules-987-      // Deleting the season the apps are currently ON would leave `_current` pointing at nothing —
firestore.rules-988-      // the "_current present but its season doc missing" state the app treats as a hard error.
firestore.rules-989-      allow delete: if isManagerOrAbove()
firestore.rules-990-        && docId != '_current'
firestore.rules-991-        && (!exists(/databases/$(database)/documents/summerCamps_seasons/_current)
firestore.rules-992-            || get(/databases/$(database)/documents/summerCamps_seasons/_current).data.season != docId);
firestore.rules-993-
firestore.rules-994-      // `_current` — the single switch that turns season filtering on across BOTH apps. It may only
firestore.rules-995-      // ever name a season doc that already exists: the migration writes it last, after the season
firestore.rules-996-      // doc and after every record is stamped, so a `_current` ahead of its data is always a bug.
firestore.rules-997-      // The app may never delete it; dropping back to legacy mode is a deliberate act in the Firebase
firestore.rules-998-      // Console (rules don't apply there), the same recovery shape as the Ticker's reminder log.
firestore.rules:999:      allow create, update: if isManagerOrAbove()
firestore.rules-1000-        && docId == '_current'
firestore.rules-1001-        && request.resource.data.season is string
firestore.rules-1002-        && request.resource.data.season != '_current'
firestore.rules-1003-        && exists(/databases/$(database)/documents/summerCamps_seasons/$(request.resource.data.season));
firestore.rules-1004-    }
firestore.rules-1005-
firestore.rules-1006-    // — READ + WRITE (create+update) for granted users —
firestore.rules-1007-
--
firestore.rules-1030-      allow read, create, update: if isManagerOrAbove() || hasAppAccess('summer-camp');
firestore.rules-1031-      allow delete: if isManagerOrAbove();
firestore.rules-1032-    }
firestore.rules-1033-
firestore.rules-1034-    // — READ-ONLY for granted users —
firestore.rules-1035-
firestore.rules-1036-    match /summerCamps_curriculum/{docId} {
firestore.rules-1037-      allow read: if isManagerOrAbove() || hasAppAccess('summer-camp') || hasAppAccess('classbook') || hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin');
firestore.rules:1038:      allow create, update, delete: if isManagerOrAbove();
firestore.rules-1039-    }
firestore.rules-1040-
firestore.rules-1041-    match /summerCamps_lessonData/{docId} {
firestore.rules-1042-      allow read: if isManagerOrAbove() || hasAppAccess('summer-camp') || hasAppAccess('classbook');
firestore.rules:1043:      allow create, update, delete: if isManagerOrAbove() || hasAppAccess('classbook');
firestore.rules-1044-    }
firestore.rules-1045-
firestore.rules-1046-    match /summerCamps_campComplete/{docId} {
firestore.rules-1047-      allow read: if isManagerOrAbove() || hasAppAccess('summer-camp') || hasAppAccess('classbook') || hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin');
firestore.rules:1048:      allow create, update: if isManagerOrAbove() || hasAppAccess('classbook');
firestore.rules-1049-      allow delete: if isManagerOrAbove();
firestore.rules-1050-    }
firestore.rules-1051-
firestore.rules-1052-    match /summerCamps_projectDetails/{docId} {
firestore.rules-1053-      allow read: if isManagerOrAbove() || hasAppAccess('summer-camp') || hasAppAccess('classbook') || hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin');
firestore.rules:1054:      allow create, update, delete: if isManagerOrAbove();
firestore.rules-1055-    }
firestore.rules-1056-
firestore.rules-1057-    match /summerCamps_projectLibrary/{docId} {
firestore.rules-1058-      allow read: if isManagerOrAbove() || hasAppAccess('summer-camp');
firestore.rules:1059:      allow create, update, delete: if isManagerOrAbove();
firestore.rules-1060-    }
firestore.rules-1061-
firestore.rules-1062-    match /summerCamps_schedule/{docId} {
firestore.rules-1063-      allow read: if isManagerOrAbove() || hasAppAccess('summer-camp') || hasAppAccess('classbook') || hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin');
firestore.rules:1064:      allow create, update, delete: if isManagerOrAbove();
firestore.rules-1065-    }
firestore.rules-1066-
firestore.rules-1067-    // — MANAGER+ ONLY — no appAccess override —
firestore.rules-1068-
firestore.rules-1069-    match /summerCamps_settings/{docId} {
firestore.rules-1070-      allow read, write: if isManagerOrAbove();
firestore.rules-1071-    }
firestore.rules-1072-
--
firestore.rules-1076-    }
firestore.rules-1077-
firestore.rules-1078-    match /summerCamps_daysOff/{docId} {
firestore.rules-1079-      allow read, create, update, delete: if isManagerOrAbove();
firestore.rules-1080-    }
firestore.rules-1081-
firestore.rules-1082-    match /summerCamps_team/{docId} {
firestore.rules-1083-      allow read: if isManagerOrAbove() || hasAppAccess('team');
firestore.rules:1084:      allow create, update: if isManagerOrAbove();
firestore.rules-1085-      allow delete: if isManagerOrAbove();
firestore.rules-1086-    }
firestore.rules-1087-
firestore.rules-1088-    match /summerCamps_openStudio/{docId} {
firestore.rules-1089-      allow read: if isManagerOrAbove() || hasAppAccess('summer-camp');
firestore.rules:1090:      allow create, update, delete: if isManagerOrAbove();
firestore.rules-1091-    }
firestore.rules-1092-
firestore.rules-1093-    match /summerCamps_kidNotes/{docId} {
firestore.rules-1094-      // All summer-camp staff can read kid notes and add in-camp observations
firestore.rules-1095-      allow read: if isManagerOrAbove() || hasAppAccess('summer-camp');
firestore.rules:1096:      allow update: if isManagerOrAbove() || hasAppAccess('summer-camp');
firestore.rules-1097-      // Only manager+ can create or delete full profile docs (imported or manually added)
firestore.rules:1098:      allow create, delete: if isManagerOrAbove();
firestore.rules-1099-    }
firestore.rules-1100-
firestore.rules-1101-
firestore.rules-1102-    // ═══════════════════════════════════════════════════════════════
firestore.rules-1103-    // PRIVATE EVENTS
firestore.rules-1104-    // Manager+ or appAccess('private-events'): read/write (create+update).
firestore.rules-1105-    // No delete for granted staff users.
firestore.rules-1106-    // ═══════════════════════════════════════════════════════════════
--
firestore.rules-1139-    function isRetiredClayHubMember() {
firestore.rules-1140-      return resource.data.get('retired', false) == true;
firestore.rules-1141-    }
firestore.rules-1142-
firestore.rules-1143-    match /clayHub_members/{docId} {
firestore.rules-1144-      allow read, create: if canWriteClayHub();
firestore.rules-1145-      // resource == null: an update of a doc that no longer exists. Allowed through so Firestore
firestore.rules-1146-      // answers not-found (not permission-denied) and the app's write-it-back fallback runs.
firestore.rules:1147:      allow update: if canWriteClayHub()
firestore.rules-1148-        && (resource == null || (fieldUnchangedOnceSet('memberId') && !isRetiredClayHubMember()));
firestore.rules-1149-      allow delete: if isManagerOrAbove() && belongsToStudio('clayhub');
firestore.rules-1150-    }
firestore.rules-1151-
firestore.rules-1152-    match /clayHub_waitlist/{docId} {
firestore.rules-1153-      allow read, create, update: if canWriteClayHub();
firestore.rules-1154-      allow delete: if isManagerOrAbove() && belongsToStudio('clayhub');
firestore.rules-1155-    }
--
firestore.rules-1244-    // TINKER NOTES
firestore.rules-1245-    // quickNotes: admin + manager read/write all. Creator can also
firestore.rules-1246-    //   read/update their own notes (covers future non-manager admins).
firestore.rules-1247-    //   Delete: manager+ only.
firestore.rules-1248-    // quickNotes_settings: manager+ only (shared category config).
firestore.rules-1249-    // ═══════════════════════════════════════════════════════════════
firestore.rules-1250-
firestore.rules-1251-    match /quickNotes/{docId} {
firestore.rules:1252:      allow create: if isManagerOrAbove()
firestore.rules-1253-        && request.resource.data.createdBy == request.auth.uid;
firestore.rules-1254-      allow read: if isManagerOrAbove()
firestore.rules-1255-        || (isAuthenticated() && resource.data.createdBy == request.auth.uid);
firestore.rules:1256:      allow update: if isManagerOrAbove()
firestore.rules-1257-        || (isAuthenticated() && resource.data.createdBy == request.auth.uid);
firestore.rules-1258-      allow delete: if isManagerOrAbove();
firestore.rules-1259-    }
firestore.rules-1260-
firestore.rules-1261-    match /quickNotes_settings/{docId} {
firestore.rules-1262-      allow read, write: if isManagerOrAbove();
firestore.rules-1263-    }
firestore.rules-1264-
--
rules.test.js-12- *   staffNoAccess — role: 'staff', appAccess: []
rules.test.js-13- *   kioskUser    — special kiosk UID
rules.test.js-14- *   otherUser    — role: 'staff', appAccess: ['timeclock']  (used for ownership tests)
rules.test.js-15- *   classbookAdminUser — role: 'staff', appAccess: ['classbook-admin']
rules.test.js-16- *   trainingUser, otherTrainingUser — role: 'staff', appAccess: ['training']
rules.test.js-17- *   summerCampUser — role: 'staff', appAccess: ['summer-camp']
rules.test.js-18- *   archivedAdminUser — role: 'admin', active: false
rules.test.js-19- *   archivedManagerUser — role: 'manager', active: false
rules.test.js:20: *   archivedStaffUser — role: 'staff', active: false, appAccess: ['kpi','timeclock','clay-membership'], studios: ['tinker','clayhub']
rules.test.js-21- */
rules.test.js-22-
rules.test.js-23-const { initializeTestEnvironment, assertFails, assertSucceeds } = require('@firebase/rules-unit-testing');
rules.test.js-24-const { doc, getDoc, setDoc, updateDoc, deleteDoc, deleteField, increment, collection, addDoc, query, where, getDocs, runTransaction, serverTimestamp, orderBy, limit, documentId, writeBatch } = require('firebase/firestore');
rules.test.js-25-const fs = require('fs');
rules.test.js-26-
rules.test.js-27-const PROJECT_ID = 'tinker-hq-test';
rules.test.js-28-const KIOSK_UID = '06ooFxutK5YTaJvu5SkywY9gZqh2';
--
rules.test.js-54-const TEAM_ONLY_UID = 'team-only-uid';
rules.test.js-55-const STAFF_ENROLLMENT_UID = 'staff-enrollment-uid';
rules.test.js-56-const ARCHIVED_ADMIN_UID = 'archived-admin-uid';
rules.test.js-57-const ARCHIVED_MANAGER_UID = 'archived-manager-uid';
rules.test.js-58-const ARCHIVED_STAFF_UID = 'archived-staff-uid';
rules.test.js-59-// Dedicated, single-use fixtures for tests whose assertSucceeds() call performs
rules.test.js-60-// a REAL, persisted write against the emulator — never reused by a later test
rules.test.js-61-// that expects the original state, to avoid order-dependent test pollution
rules.test.js:62:// (same reasoning as this file's existing brand-new-uid/-2/-3/-4 fixtures).
rules.test.js-63-const DISPOSABLE_ADMIN_FOR_ARCHIVE_UID = 'disposable-admin-for-archive-uid';
rules.test.js-64-const DISPOSABLE_ARCHIVED_ADMIN_FOR_REACTIVATE_UID = 'disposable-archived-admin-for-reactivate-uid';
rules.test.js-65-const DISPOSABLE_STAFF_FOR_ARCHIVE_UID = 'disposable-staff-for-archive-uid';
rules.test.js-66-const DISPOSABLE_ARCHIVED_MANAGER_FOR_REACTIVATE_UID = 'disposable-archived-manager-for-reactivate-uid';
rules.test.js-67-
rules.test.js-68-let testEnv;
rules.test.js-69-
rules.test.js-70-beforeAll(async () => {
--
rules.test.js-428-  });
rules.test.js-429-
rules.test.js-430-  // ── creates (happy) ──
rules.test.js-431-  test('manager can create an entry inside the transaction that bumps the parent rev (real serverTimestamp)', async () => {
rules.test.js-432-    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
rules.test.js-433-    await assertSucceeds(saveWithHistory(db));
rules.test.js-434-  });
rules.test.js-435-
rules.test.js:436:  test('admin can create an entry (own email)', async () => {
rules.test.js-437-    const db = getDb(ADMIN_UID, ADMIN_EMAIL);
rules.test.js-438-    await assertSucceeds(saveWithHistory(db, { payloadOverrides: { savedBy: ADMIN_EMAIL }, updatedBy: ADMIN_EMAIL }));
rules.test.js-439-  });
rules.test.js-440-
rules.test.js-441-  test('baseline + edit entries in ONE transaction both pass (same new rev)', async () => {
rules.test.js-442-    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
rules.test.js-443-    await assertSucceeds(saveWithHistory(db, { entries: 2 }));
rules.test.js-444-  });
--
rules.test.js-793-    // — there is no ownership field the rules check. This succeeding is the
rules.test.js-794-    // gap, tracked in firebase-agent-defense-hardening.md as an unresolved risk.
rules.test.js-795-    await assertSucceeds(updateDoc(doc(db, 'curriculum', 'spring-2026'), { touchedBy: 'someone-elses-teacher' }));
rules.test.js-796-  });
rules.test.js-797-});
rules.test.js-798-
rules.test.js-799-
rules.test.js-800-// ─── USERS — PRIVILEGE ESCALATION VIA SELF-WRITE (FIX APPLIED) ──────────────
rules.test.js:801:// Fix applied in this pass: the self-create/self-update rules previously
rules.test.js-802-// pinned only the `role` field. `appAccess` and `studios` were completely
rules.test.js-803-// unprotected, so any authenticated staff user could grant themselves access
rules.test.js-804-// to nearly every app on the platform (KPI, Classbook, Training, Roster
rules.test.js-805-// Manager, Summer Camp, Clay Hub, Social Media, Playbook, etc.) with a
rules.test.js-806-// direct Firestore write that bypasses the Manage Team UI entirely. Payroll
rules.test.js-807-// and bookkeeping were never reachable this way (they gate on role, not
rules.test.js-808-// appAccess, and role was already protected) but everything else was.
rules.test.js-809-
--
rules.test.js-825-  test('staff CAN still self-update unrelated fields (no regression)', async () => {
rules.test.js-826-    const db = getDb(STAFF_NOACCESS_UID);
rules.test.js-827-    await assertSucceeds(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
rules.test.js-828-      name: 'Updated Name',
rules.test.js-829-      pin: '4321',
rules.test.js-830-    }));
rules.test.js-831-  });
rules.test.js-832-
rules.test.js:833:  test('a brand-new user CANNOT self-create with appAccess already populated', async () => {
rules.test.js:834:    const db = getDb('brand-new-uid');
rules.test.js:835:    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid'), {
rules.test.js-836-      role: 'staff',
rules.test.js-837-      appAccess: ['classbook-admin'],
rules.test.js-838-    }));
rules.test.js-839-  });
rules.test.js-840-
rules.test.js:841:  test('a brand-new user CANNOT self-create with a studio outside the known set', async () => {
rules.test.js:842:    const db = getDb('brand-new-uid-2');
rules.test.js:843:    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-2'), {
rules.test.js-844-      role: 'staff',
rules.test.js-845-      studios: ['tinker', 'some-future-privileged-studio'],
rules.test.js-846-    }));
rules.test.js-847-  });
rules.test.js-848-
rules.test.js:849:  test('a brand-new user CAN self-create with no appAccess/studios (bootstrap)', async () => {
rules.test.js:850:    const db = getDb('brand-new-uid-3');
rules.test.js:851:    await assertSucceeds(setDoc(doc(db, 'users', 'brand-new-uid-3'), {
rules.test.js-852-      role: 'staff',
rules.test.js-853-      name: 'New Hire',
rules.test.js-854-    }));
rules.test.js-855-  });
rules.test.js-856-
rules.test.js-857-  test('the real bootstrap write shape succeeds: role staff, appAccess [], studios [tinker, clayhub]', async () => {
rules.test.js-858-    // Mirrors js/app.js handleAuthStateChange()'s default-user-doc write exactly.
rules.test.js:859:    const db = getDb('brand-new-uid-4');
rules.test.js:860:    await assertSucceeds(setDoc(doc(db, 'users', 'brand-new-uid-4'), {
rules.test.js-861-      name: 'New Hire',
rules.test.js-862-      email: 'newhire@tinkerartstudio.com',
rules.test.js-863-      role: 'staff',
rules.test.js-864-      studios: ['tinker', 'clayhub'],
rules.test.js-865-      appAccess: [],
rules.test.js-866-      createdAt: '2026-08-11T00:00:00.000Z',
rules.test.js-867-    }));
rules.test.js-868-  });
--
rules.test.js-873-      appAccess: ['kpi'],
rules.test.js-874-    }));
rules.test.js-875-  });
rules.test.js-876-
rules.test.js-877-  // Regression test for a gap found by independent second-model review:
rules.test.js-878-  // the separate "Manager update" rule (isManager() && role unchanged) had
rules.test.js-879-  // no request.auth.uid != userId guard, so a manager writing to THEIR OWN
rules.test.js-880-  // doc satisfied it too — bypassing the appAccess/studios pins above
rules.test.js:881:  // entirely, since Firestore ORs sibling `allow update` rules together.
rules.test.js-882-  // Concretely exploitable: belongsToStudio() (gating clayHub_*/rosterManager/
rules.test.js-883-  // clayInventory) doesn't accept isManagerOrAbove(), so a manager scoped to
rules.test.js-884-  // studios:['tinker'] only could have self-granted 'clayhub' this way.
rules.test.js-885-  test('manager CANNOT self-grant studios via the manager-update rule (regression)', async () => {
rules.test.js-886-    const db = getDb(MANAGER_UID);
rules.test.js-887-    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), {
rules.test.js-888-      studios: ['tinker', 'clayhub', 'some-future-privileged-studio'],
rules.test.js-889-    }));
--
rules.test.js-904-    }));
rules.test.js-905-  });
rules.test.js-906-});
rules.test.js-907-
rules.test.js-908-
rules.test.js-909-// ─── USERS — ARCHIVE FEATURE: active:false revokes access everywhere ────────
rules.test.js-910-// BDD scenarios from thoughts/plans/archive-employees.html, Phase 1.
rules.test.js-911-
rules.test.js:912:// ─── USERS — FIELDS MY CLAY HUB RELIES ON (Phase E, E-0) ─────────────────────
rules.test.js:913:// My Clay Hub's staff roster is decided by users docs' role, active and appAccess (it stores name
rules.test.js-914-// and role), so no one may raise their own role, grant themselves appAccess, or change their own
rules.test.js-915-// active. appAccess/studios self-grants are pinned above, archived self-reactivation and an admin's
rules.test.js-916-// own active below; these pin what wasn't covered.
rules.test.js-917-describe('Users — fields My Clay Hub relies on (no self-promotion, no self-set active)', () => {
rules.test.js:918:  test('a brand-new user CANNOT self-create as manager', async () => {
rules.test.js:919:    const db = getDb('brand-new-uid-mgr');
rules.test.js:920:    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-mgr'), { role: 'manager', name: 'New Hire' }));
rules.test.js-921-  });
rules.test.js-922-
rules.test.js:923:  test('a brand-new user CANNOT self-create as admin', async () => {
rules.test.js:924:    const db = getDb('brand-new-uid-adm');
rules.test.js:925:    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-adm'), { role: 'admin', name: 'New Hire' }));
rules.test.js-926-  });
rules.test.js-927-
rules.test.js-928-  test('staff CANNOT self-update their role to manager or admin', async () => {
rules.test.js-929-    const db = getDb(STAFF_NOACCESS_UID);
rules.test.js-930-    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'manager' }));
rules.test.js-931-    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'admin' }));
rules.test.js-932-  });
rules.test.js-933-
--
rules.test.js-1678-      await setDoc(doc(ctx.firestore(), 'meetings', 'disposable-ordinary-edit-meeting'), {
rules.test.js-1679-        createdBy: RECAP_UID, business: 'tinker', title: 'Original title', sharedWith: [],
rules.test.js-1680-      });
rules.test.js-1681-    });
rules.test.js-1682-    await assertSucceeds(updateDoc(ref, { title: 'Updated title' }));
rules.test.js-1683-  });
rules.test.js-1684-});
rules.test.js-1685-
rules.test.js:1686:describe('Recap — a non-admin creator can still edit their own already-personal meeting', () => {
rules.test.js-1687-  test('legacy personal meeting created by a non-admin: creator can still make an ordinary edit', async () => {
rules.test.js-1688-    const db = getDb(RECAP_UID);
rules.test.js-1689-    await assertSucceeds(updateDoc(doc(db, 'meetings', 'legacy-personal-meeting'), { title: 'Updated' }));
rules.test.js-1690-  });
rules.test.js-1691-});
rules.test.js-1692-
rules.test.js-1693-
rules.test.js-1694-// ─── RECAP — PHASE 3: a user in sharedWith can tick off action items, and nothing else ──
--
rules.test.js-2026-
rules.test.js-2027-  test('bot can GET a users doc by uid but cannot LIST users, and cannot write any users doc — including its own', async () => {
rules.test.js-2028-    const db = getDb(REMINDER_BOT_UID);
rules.test.js-2029-    await assertSucceeds(getDoc(doc(db, 'users', STAFF_TIMECLOCK_UID)));
rules.test.js-2030-    await assertFails(getDocs(collection(db, 'users')));
rules.test.js-2031-    await assertFails(updateDoc(doc(db, 'users', STAFF_TIMECLOCK_UID), { email: 'x@y.z' }));
rules.test.js-2032-    // The auth guard's bootstrap write, verbatim: refused, so the bot can never become a user.
rules.test.js-2033-    await assertFails(setDoc(doc(db, 'users', REMINDER_BOT_UID), { uid: REMINDER_BOT_UID, email: 'reminders@tinkerartstudio.com', name: 'reminders', role: 'staff', studios: ['tinker', 'clayhub'], appAccess: ['timeclock'], createdAt: 'now' }));
rules.test.js:2034:    // …and not even the minimal shape the self-create rule would otherwise allow.
rules.test.js-2035-    await assertFails(setDoc(doc(db, 'users', REMINDER_BOT_UID), { role: 'staff' }));
rules.test.js-2036-  });
rules.test.js-2037-
rules.test.js-2038-  test('bot cannot LIST users even constrained to its own id (the self-read grant excludes it)', async () => {
rules.test.js-2039-    const db = getDb(REMINDER_BOT_UID);
rules.test.js-2040-    await assertFails(getDocs(query(collection(db, 'users'), where(documentId(), '==', REMINDER_BOT_UID))));
rules.test.js-2041-  });
rules.test.js-2042-
--
rules.test.js-2292-  test('a plain classbook teacher can create and update a plan', async () => {
rules.test.js-2293-    const db = getDb(CLASSBOOK_UID);
rules.test.js-2294-    await assertSucceeds(setDoc(doc(db, 'dayOffCamps_lessonData', 'teacher-new'), { yearKey: 'sdoc-2026-27', introPitch: 'hi' }));
rules.test.js-2295-    await assertSucceeds(updateDoc(doc(db, 'dayOffCamps_lessonData', SDOC_SEED_ID), { introPitch: 'edited' }));
rules.test.js-2296-  });
rules.test.js-2297-});
rules.test.js-2298-
rules.test.js-2299-describe('Default deny — unlisted collections are blocked', () => {
rules.test.js:2300:  test('admin cannot read an unknown collection', async () => {
rules.test.js-2301-    const db = getDb(ADMIN_UID);
rules.test.js-2302-    await assertFails(getDoc(doc(db, 'someRandomCollection', 'doc')));
rules.test.js-2303-  });
rules.test.js-2304-
rules.test.js-2305-  test('unauthenticated user cannot read an unknown collection', async () => {
rules.test.js-2306-    const db = getUnauthDb();
rules.test.js-2307-    await assertFails(getDoc(doc(db, 'someRandomCollection', 'doc')));
rules.test.js-2308-  });
--
rules.test.js-2404-// removed; default deny now applies to clayMembers, clayBookings, claySpots,
rules.test.js-2405-// clayBlockedSlots and claySettings. The data itself is untouched by the rules change.
rules.test.js-2406-//
rules.test.js-2407-// (a)–(d) are RED on the pre-removal rules: (a) succeeds there, and (b)–(d) then succeed
rules.test.js-2408-// because (a)'s document persists (this file never clears the emulator between tests).
rules.test.js-2409-// Keep (a) first and each check in its own test. CLAY_ESCALATION_UID and CLAY_NO_USERS_DOC_UID are
rules.test.js-2410-// used only inside this describe block — never reuse them elsewhere.
rules.test.js-2411-const CLAY_ESCALATION_UID = 'clay-escalation-uid';   // signed in, no users doc
rules.test.js:2412:const CLAY_NO_USERS_DOC_UID = 'clay-no-users-doc-uid'; // signed in, no users doc, never self-creates
rules.test.js-2413-const CLAY_COLLECTIONS = ['clayMembers', 'clayBookings', 'claySpots', 'clayBlockedSlots', 'claySettings'];
rules.test.js-2414-const CLAY_FIXTURE_ID = {
rules.test.js-2415-  clayMembers: 'fixture-clay-member',
rules.test.js-2416-  clayBookings: 'fixture-clay-booking',
rules.test.js-2417-  claySpots: 'fixture-clay-spot',
rules.test.js-2418-  clayBlockedSlots: 'fixture-clay-blocked-slot',
rules.test.js-2419-  claySettings: 'fixture-clay-settings',
rules.test.js-2420-};
--
rules.test.js-3329-  test('no collection-group route for anyone', async () => {
rules.test.js-3330-    const { collectionGroup } = require('firebase/firestore');
rules.test.js-3331-    await assertFails(getDocs(collectionGroup(mailDb(SELF), COL)));
rules.test.js-3332-  });
rules.test.js-3333-
rules.test.js-3334-  // ── writes ──
rules.test.js-3335-  test('staff cannot create or update records or the summary (each tested separately)', async () => {
rules.test.js-3336-    const db = mailDb(SELF);
rules.test.js:3337:    await assertFails(setDoc(doc(db, COL, 'brand-new-uid'), record()));
rules.test.js-3338-    await assertFails(setDoc(doc(db, COL, SELF), record({ name: 'Changed' })));
rules.test.js-3339-    await assertFails(updateDoc(doc(db, COL, SELF), { name: 'Changed' }));
rules.test.js-3340-    await assertFails(setDoc(doc(db, COL, '_summary'), summary(SELF)));
rules.test.js-3341-  });
rules.test.js-3342-  test('staff-directory override staff cannot write', async () => {
rules.test.js-3343-    const db = mailDb(OVERRIDE_UID);
rules.test.js:3344:    await assertFails(setDoc(doc(db, COL, 'brand-new-uid'), record()));
rules.test.js-3345-    await assertFails(setDoc(doc(db, COL, '_summary'), summary(OVERRIDE_UID)));
rules.test.js-3346-  });
rules.test.js-3347-  test('managers and admins can create and update records and the summary', async () => {
rules.test.js-3348-    for (const uid of [MANAGER_UID, ADMIN_UID]) {
rules.test.js-3349-      const db = mailDb(uid);
rules.test.js-3350-      await assertSucceeds(setDoc(doc(db, COL, `created-by-${uid}`), record()));
rules.test.js-3351-      await assertSucceeds(setDoc(doc(db, COL, OTHER), record({ birthday: '1/2' })));
rules.test.js-3352-      await assertSucceeds(setDoc(doc(db, COL, '_summary'), summary(uid)));
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
      // /staff screens), and store only name and role there. So no one may raise their own role,
      // grant themselves appAccess, or change their own active: staff and managers can't touch
      // any of the three on their own doc; an admin can't change their own active, and changing
      // their own role or appAccess can only demote them (admins are already granted). name is
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
    // settingsRev (getAfter tie), carry the caller's own email and a server
    // timestamp, and have exactly the declared shape.
    // Plan: tinker-ai-configs/thoughts/plans/payroll-settings-safety-and-seasons.html
    match /payroll/appData/settingsHistory/{histId} {
      allow read: if isManagerOrAbove();
      allow create: if isManagerOrAbove()
        && request.resource.data.keys().hasAll(['settings','hash','rev','savedAt','savedBy','kind','summary','configVersion'])
        && request.resource.data.keys().hasOnly(['settings','hash','rev','savedAt','savedBy','kind','summary','configVersion','recovered'])
        && request.resource.data.settings is map
        && request.resource.data.hash is string
    const db = getDb(MANAGER_UID);
    await assertSucceeds(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
      appAccess: ['training'],
      studios: ['tinker', 'clayhub'],
    }));
  });
});


// ─── USERS — ARCHIVE FEATURE: active:false revokes access everywhere ────────
// BDD scenarios from thoughts/plans/archive-employees.html, Phase 1.

// ─── USERS — FIELDS MY CLAY HUB RELIES ON (Phase E, E-0) ─────────────────────
// My Clay Hub's staff roster is decided by users docs' role, active and appAccess (it stores name
// and role), so no one may raise their own role, grant themselves appAccess, or change their own
// active. appAccess/studios self-grants are pinned above, archived self-reactivation and an admin's
// own active below; these pin what wasn't covered.
describe('Users — fields My Clay Hub relies on (no self-promotion, no self-set active)', () => {
  test('a brand-new user CANNOT self-create as manager', async () => {
    const db = getDb('brand-new-uid-mgr');
    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-mgr'), { role: 'manager', name: 'New Hire' }));
  });

  test('a brand-new user CANNOT self-create as admin', async () => {
    const db = getDb('brand-new-uid-adm');
    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-adm'), { role: 'admin', name: 'New Hire' }));
  });

  test('staff CANNOT self-update their role to manager or admin', async () => {
    const db = getDb(STAFF_NOACCESS_UID);
    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'manager' }));
    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'admin' }));
  });

  test('staff CANNOT self-update active (setting it where it was absent, either way)', async () => {
    const db = getDb(STAFF_NOACCESS_UID);
    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { active: true }));
    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { active: false }));
  });

  test('a manager CANNOT self-update their own active or role', async () => {
    const db = getDb(MANAGER_UID);
    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), { active: false }));
    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), { role: 'admin' }));
  });
});

describe('Users — active:false revokes access everywhere (Archive Employees feature)', () => {
  test('archived admin cannot read payroll (isAdmin now requires isActiveUser)', async () => {
    const db = getDb(ARCHIVED_ADMIN_UID);
    await assertFails(getDoc(doc(db, 'payroll', 'some-doc')));
  });

  test('archived staff cannot read kpiData even though appAccess still lists kpi', async () => {
    const db = getDb(ARCHIVED_STAFF_UID);
    await assertFails(getDoc(doc(db, 'kpiData', 'some-doc')));
  });

  test('archived staff cannot read their OWN timeclock_entries even though appAccess still lists timeclock', async () => {
    const db = getDb(ARCHIVED_STAFF_UID);
    await assertFails(getDoc(doc(db, 'timeclock_entries', 'archived-staff-entry')));
  });

  test('archived user CAN still read their own doc (app must load, not error)', async () => {
    const db = getDb(ARCHIVED_STAFF_UID);
    await assertSucceeds(getDoc(doc(db, 'users', ARCHIVED_STAFF_UID)));
  });

  test('archived user CAN lightly self-update an unrelated field; active stays false (pinned, unchanged)', async () => {
    const db = getDb(ARCHIVED_STAFF_UID);
    await assertSucceeds(updateDoc(doc(db, 'users', ARCHIVED_STAFF_UID), {
      name: 'Still Archived',
    }));
  });

  test('archived staff CANNOT self-write active:true (no self-reactivation)', async () => {
    const db = getDb(ARCHIVED_STAFF_UID);
    await assertFails(updateDoc(doc(db, 'users', ARCHIVED_STAFF_UID), {
      active: true,
    }));
  });

  test('manager CANNOT archive an admin (write active:false to an active admin doc)', async () => {
    const db = getDb(MANAGER_UID);
    await assertFails(updateDoc(doc(db, 'users', ADMIN_UID), {
      active: false,
    }));
  });

  test('manager CANNOT reactivate an admin (write active:true to an archived admin doc)', async () => {
    const db = getDb(MANAGER_UID);
    await assertFails(updateDoc(doc(db, 'users', ARCHIVED_ADMIN_UID), {
      active: true,
    }));
  });

  test('manager CAN archive another staff member (unchanged from existing appAccess/studios capability)', async () => {
    const db = getDb(MANAGER_UID);
    await assertSucceeds(updateDoc(doc(db, 'users', DISPOSABLE_STAFF_FOR_ARCHIVE_UID), {
      active: false,
    }));
  });

  test('manager CAN reactivate another manager (unchanged from existing appAccess/studios capability)', async () => {
    const db = getDb(MANAGER_UID);
    await assertSucceeds(updateDoc(doc(db, 'users', DISPOSABLE_ARCHIVED_MANAGER_FOR_REACTIVATE_UID), {
      active: true,
    }));
  });

  // The critical self-lockout-prevention test: firestore.rules:128's blanket
  // `allow write: if isAdmin();` sits outside the self-update rule's
  // fieldUnchanged('active') pin (Firestore ORs sibling `allow` rules), so
  // without an explicit guard an admin could archive themselves with no
  // recovery path — same bug shape as the manager self-grant regression
  // above, just for a field that didn't exist yet when that fix shipped.
  test('admin CANNOT write active:false to their OWN doc via any rule path (self-lockout prevention)', async () => {
    const db = getDb(ADMIN_UID);
    await assertFails(updateDoc(doc(db, 'users', ADMIN_UID), {
      active: false,
    }));
  });

  test('admin CAN write active:false to ANOTHER admin doc (archiving admins stays possible)', async () => {
    const db = getDb(ADMIN_UID);
    await assertSucceeds(updateDoc(doc(db, 'users', DISPOSABLE_ADMIN_FOR_ARCHIVE_UID), {
      active: false,
    }));
  });

  test('admin CAN write active:true to ANOTHER admin doc (reactivating admins stays possible)', async () => {
    const db = getDb(ADMIN_UID);
    await assertSucceeds(updateDoc(doc(db, 'users', DISPOSABLE_ARCHIVED_ADMIN_FOR_REACTIVATE_UID), {
      active: true,
    }));
  });

  // belongsToStudio()'s non-admin branch doesn't route through isAdmin()/
  // isManager()/hasAppAccess() at all, so gating those four functions on
  // isActiveUser() would NOT touch this one without its own explicit check.
  test('archived staff cannot read clayHub_members even with clay-membership access and clayhub in studios (belongsToStudio regression)', async () => {
    const db = getDb(ARCHIVED_STAFF_UID);
    await assertFails(getDoc(doc(db, 'clayHub_members', 'some-doc')));
  });

  test('archived manager cannot read payroll (previously isManagerOrAbove()-gated)', async () => {
    const db = getDb(ARCHIVED_MANAGER_UID);
    await assertFails(getDoc(doc(db, 'payroll', 'some-doc')));
  });

  test('non-archived users are unaffected (missing/true active still grants access) — no regression', async () => {
    const adminDb = getDb(ADMIN_UID);
    await assertSucceeds(getDoc(doc(adminDb, 'payroll', 'some-doc')));
    const staffDb = getDb(STAFF_KPI_UID);
    await assertSucceeds(getDoc(doc(staffDb, 'kpiData', 'some-doc')));
  });
});


// ─── TRAINING HUB — DELETE BOUNDARIES ────────────────────────────────────────

describe('Training Hub — delete, observation read scoping, and query constraints', () => {
  test('staff with training access cannot delete a training module', async () => {
    const db = getDb(TRAINING_UID);
    await assertFails(deleteDoc(doc(db, 'trainingModules', 'module-1')));
  });

  test('manager can delete a training module', async () => {
    const db = getDb(MANAGER_UID);
    await assertSucceeds(deleteDoc(doc(db, 'trainingModules', 'module-1')));
  });

  test('staff cannot delete their own training assignment', async () => {
    const db = getDb(TRAINING_UID);
    await assertFails(deleteDoc(doc(db, 'trainingAssignments', 'assign-1')));
  });

  test('staff cannot read another staff member\'s training assignment', async () => {
    const db = getDb(OTHER_TRAINING_UID);
    await assertFails(getDoc(doc(db, 'trainingAssignments', 'assign-1')));
  });

  test('manager can delete a training assignment', async () => {
    const db = getDb(MANAGER_UID);
    await assertSucceeds(deleteDoc(doc(db, 'trainingAssignments', 'assign-1')));
  });
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-Of74FgbB' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-s3hq7txE' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-0bVRfkc9' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-MdQj2vi4' (errno=Operation not permitted)
diff --git a/firestore.rules b/firestore.rules
index c928f98..2ad2c4a 100644
--- a/firestore.rules
+++ b/firestore.rules
@@ -109,12 +109,14 @@ service cloud.firestore {
     // ═══════════════════════════════════════════════════════════════
~
 
~
     match /users/{userId} {
~
       // My Clay Hub depends on these (Phase E): the clayhub-link functions 
-copy
+read
  each users doc's
~
       //
-name,
  role, active and appAccess to 
-my-clay-hub's staffRoster, which decides
+decide
  who 
+is in my-clay-hub's staffRoster (who
  can use
-//
  its
~
       
+//
  /staff 
-screens.
+screens), and store only name and role there.
  So 
-a person must never be able to set
+no one may raise
  their own role,
~
       
-active
+// grant themselves appAccess,
  or 
+change their own active: staff and managers can't touch
~
+      // any of the three on their own doc; an admin can't change their own active, and changing
~
       // 
+their own role or
  appAccess 
-(name
+can only demote them (admins are already granted). name
  is
~
       
+//
  self-editable and
-is
  display-only 
-there).
+there.
  Pinned by rules.test.js
-//
  "Users — fields My Clay Hub
~
       
+//
  relies on"; loosening any of 
-them
+this
  changes who is staff in
-//
  My Clay Hub too.
~
       // Own doc read — all authenticated users (auth guard requires it). Not the reminder bot: its
~
       // grant is GET-only below, and this `read` would let an id-constrained LIST through.
~
       allow read: if isAuthenticated() && request.auth.uid == userId && !isReminderBot();
~
diff --git a/rules.test.js b/rules.test.js
index d2570a3..b4e5457 100644
--- a/rules.test.js
+++ b/rules.test.js
@@ -910,9 +910,10 @@ describe('Users — appAccess/studios cannot be self-granted (privilege escalati
 // BDD scenarios from thoughts/plans/archive-employees.html, Phase 1.
~
 
~
 // ─── USERS — FIELDS MY CLAY HUB RELIES ON (Phase E, E-0) ─────────────────────
~
 // My Clay Hub's staff roster is 
-copied from
+decided by
  users 
-docs (name,
+docs'
  role, 
-active, appAccess),
+active and appAccess (it stores name
~
+// and role),
  so no one
-//
  may 
-set
+raise
  their own role, 
-active
+grant themselves appAccess,
  or 
-appAccess.
+change their own
~
+// active.
  appAccess/studios self-grants are pinned 
-above and
~
-//
+above,
  archived self-reactivation 
+and an admin's
~
+// own active
  below; these pin what wasn't covered.
~
 describe('Users — fields My Clay Hub relies on (no self-promotion, no self-set active)', () => {
~
   test('a brand-new user CANNOT self-create as manager', async () => {
~
     const db = getDb('brand-new-uid-mgr');
~

codex
The patch is logic-neutral: the commit changes only comments in `firestore.rules` and `rules.test.js`; the executable rule and test bodies are byte-for-byte unchanged. I’m narrowing the remaining check to whether every new sentence precisely matches the plan’s staff eligibility formula and the rule’s overlapping `allow` behavior.
exec
/bin/zsh -lc 'rg -n -C 5 "staff snapshot|staff rule|staffRoster/|role.*manager|appAccess.*my-clay-hub|active.*false|E-0" "$HOME/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html" | sed -n '"'1,420p'
printf '\\nRULE HELPERS AND USERS BLOCK\\n'
sed -n '1,205p' firestore.rules
printf '\\nRELEVANT TESTS\\n'
rg -n -C 5 \"self-create|self-update|admin CAN.*OWN|admin.*own|appAccess.*self|role.*self|active.*OWN\" rules.test.js | sed -n '1,500p'
printf '\\nCOMMIT NUMSTAT AND FILE TYPES\\n'
git diff --numstat 00d5fd2"'^ 00d5fd2 && git diff --name-status 00d5fd2''^ 00d5fd2' in /Users/christiehubley/studio-hub
 succeeded in 0ms:
39-  <strong>Status:</strong> <span class="status-tag ready">execution-ready: true</span> — v4.1, Oct 8, 2026, after four review rounds (round 4: Codex and Claude both "ready after fixes", 0 blocking; all fixes applied). Christie answered Q1–Q9 on Oct 8 (Q7 changed: removed members keep everything but email and phone digits). <strong>Marked execution-ready (all phases) by Christie, Oct 8.</strong> Next: E-pre (its PR review re-checks the Q7 change).
40-</div>
41-
42-<h2>Already decided (not reopened here)</h2>
43-<ul>
44:  <li><strong>D22 "Re-read, then send a snapshot"</strong> (DECISIONS #53): a trigger on <code>clayHub_members/{id}</code> collects the memberId from before and after; for each, one query on <code>memberId</code> only; live = <code>retired !== true</code>; exactly one live doc → its fields; none → tombstone; more than one → conflict, nothing sent, alert. POST <code>{memberId, snapshot, readTime}</code>; ingest drops anything not newer than the stored <code>sourceReadTime</code>, checks the payload strictly, runs <code>deriveStatus</code>, writes, never deletes. The reconcile uses the same envelope, read in one read-only transaction pinned to one readTime. <code>users/{uid}</code> → <code>staffRoster/staff_{uid}</code> the same way (no memberId, no conflict case).</li>
45-  <li><strong>D4 / D4a / #34</strong>: status comes only from <code>shared/derive-status.js</code>; Denver calendar dates; recomputed for everyone daily.</li>
46-  <li><strong>#24</strong>: only <code>phoneLast4</code> leaves <code>tinker-hq-apps</code>, worked out there. <strong>#37 / D6</strong>: never write back. <strong>#42</strong>: IAM one-way; ingest can't delete. <strong>#32 / D2 / M1</strong>: the link is codebase <code>clayhub-link</code> in studio-hub, deployed only by <code>tinker-hq-apps</code>' own functions guard; neither guard can reach the other project. <strong>#54 / D23</strong>: 2nd gen, retries on (<code>retry: true</code> on triggers, retryConfig on schedules), explicit maxInstances, Admin app built once per instance; Firestore <code>nam5</code>, Eventarc location <code>nam5</code>, functions <code>us-central1</code>.</li>
47-  <li><strong>IAM inventory (D11)</strong>: <code>clayhub-link@tinker-hq-apps</code> = a custom read-only Firestore role (get, list) + <code>eventarc.eventReceiver</code>; <code>ingestmemberupdate</code> is <code>invoker</code>: exactly <code>clayhub-link@tinker-hq-apps</code> (declared; the CLI sets it — never granted by hand); <code>ingest@my-clay-hub</code> = custom role get/list/create/update, no delete. Called at the service's exact run.app URL with an OIDC token from the metadata server.</li>
48-  <li><strong>#63 / #64</strong>: the vault gate; Force runs keyed by the day they run (deploys Monday Oct 12).</li>
49-</ul>
--
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
--
91-<tr><td><code>snapshot</code> — rebuilt from allowed keys, never copied and trimmed</td><td>
92-<code>name</code>, <code>email</code>: a string, trimmed, else <code>null</code> · <code>emailLower</code>: <code>email</code> lowercased, or <code>null</code> · <code>memberSince</code>: a valid <code>YYYY-MM-DD</code>, else <code>null</code> · <code>phoneLast4</code>: Membership Manager's own phone rule (<code>formatPhone</code>: 10 digits, or 11 starting with 1) → its last 4, else <code>null</code> · <code>retired</code>: <code>true</code> only if the source is exactly <code>true</code> · <code>stage</code>: one of the six known stages, else <code>"!malformed"</code> · <code>scheduledPause</code>: <code>null</code>, or <code>{startDate, endDate, processed}</code>, or <code>"!malformed"</code> if not an object · <code>pauseHistory</code>: <code>[]</code>, or a list whose entries are <code>{startDate, endDate, priorTerm?}</code> (legacy <code>start</code>/<code>end</code> mapped, the modern value winning) or <code>"!malformed"</code>, or <code>"!malformed"</code> if not a list · <code>scheduledCancellation</code>: <code>null</code>, or <code>{finalAccessDate}</code>, or <code>"!malformed"</code> if not an object · every date: a valid <code>YYYY-MM-DD</code> as-is, missing or <code>null</code> → absent, anything else → <code>"!malformed"</code> (never raw text); the legacy mapping uses a modern value only when it isn't <code>null</code>/missing · <code>priorTerm</code>: present only as <code>true</code> · <code>processed</code>: <code>true</code> when the source <code>scheduledAt</code> is present (a non-empty value — Membership Manager's own test; real values are ISO strings), else <code>false</code> (Q6).</td></tr>
93-<tr><td>Status</td><td>Only <code>deriveStatus</code>. Its precedence stays: a removed/retired record is <code>removed</code> and onboarding/touring is <code>not_yet</code> before any malformed pause data is looked at — so the fixtures are stage-qualified.</td></tr>
94-<tr><td><code>members/{memberId}</code> (stored)</td><td>The snapshot fields + <code>memberId</code>, <code>firstName</code> (first word of <code>name</code>), <code>lastInitial</code> (first letter of the last word, or <code>null</code>), <code>status</code>, <code>statusDate</code> (the Denver date it was derived for), <code>sourceReadTime</code>, <code>updatedAt</code>, <code>tombstone:false</code>.</td></tr>
95-<tr><td><code>memberProfiles/{memberId}</code> (stored; Phase F lets the member read it)</td><td><code>{memberId, firstName, name, email, status, memberSince, pause, finalAccessDate, updatedAt}</code>. <code>pause</code> = the valid, processed window containing today (Denver), else the earliest valid processed window starting after today, else <code>null</code>, as <code>{startDate, endDate}</code>; <code>finalAccessDate</code> only if valid. <strong>No malformed marker and no phone digits ever reach it.</strong> Date-dependent, so the recompute rewrites it too.</td></tr>
96:<tr><td><code>staff</code></td><td><code>{uid, staff: {name, role}}</code> — <strong>sent only for granted users</strong> — or <code>{uid, tombstone:true}</code>. Granted = <code>role</code> exactly <code>admin</code>|<code>manager</code>|<code>staff</code>, <code>active</code> absent or <code>true</code>, <code>appAccess</code> absent or a list of strings, and (role manager/admin, or <code>appAccess</code> contains <code>my-clay-hub</code>). A deleted, ungranted or malformed users doc → a tombstone envelope; malformed also logs an error naming the uid only (it repeats each reconcile until fixed — accepted). Never email, PIN or <code>appAccess</code>.</td></tr>
97:<tr><td><code>staffRoster/staff_{uid}</code> (stored)</td><td><code>{uid, name, role, sourceReadTime, updatedAt, tombstone:false}</code>. The receiver ignores a tombstone for a uid it doesn't hold, so no roster doc is ever created for someone never granted.</td></tr>
98-<tr><td><code>reconcile</code></td><td><code>{scope:'members', items:[member entries], held:[memberId]}</code> or <code>{scope:'staff', items:[granted staff entries]}</code> — the complete set at one readTime. <strong>Sender:</strong> every live source doc needs a valid memberId; a memberId with more than one live doc goes into <code>held</code> (ids only); a live doc with a missing or malformed memberId aborts the whole member reconcile (nothing sent, error logged). <strong>Receiver:</strong> duplicate ids across <code>items</code>/<code>held</code> → 400; <code>held</code> ids are neither updated nor removed and are left out of every denominator; a held record whose <code>sourceReadTime</code> is at or after the batch's readTime is never removed (a newer trigger already landed).</td></tr>
99-<tr><td>Tombstones (stored)</td><td>Replace the document. <code>members</code>: the last stored snapshot fields <strong>minus <code>email</code>, <code>emailLower</code> and <code>phoneLast4</code></strong> (Q7), plus <code>{memberId, firstName, lastInitial, tombstone:true, status:'removed', statusDate, sourceReadTime, updatedAt}</code>; if nothing was ever stored for that memberId, only those last fields. <code>memberProfiles</code>: <code>{memberId, tombstone:true, status:'removed', updatedAt}</code>. <code>staffRoster</code>: <code>{uid, tombstone:true, sourceReadTime, updatedAt}</code>. A later live record replaces it with the full allowlist again. (Vault copies taken earlier keep the email and phone digits until the 56-day retention ages them out — noted in DATA-RESTORE.)</td></tr>
100-<tr><td>Responses</td><td>200 <code>{result: applied|unchanged|stale}</code>; 400 malformed envelope; 409 a reconcile stopped by a threshold. <strong>Terminal for the sender: only 200, 400 and 409</strong> (400 also logs an error: the two repos disagree). Everything else — 401/403/404, 429, 5xx, timeouts — throws, so the trigger is retried.</td></tr>
101-<tr><td>Logging</td><td>Never request bodies, names, emails, phone digits, notes or source documents — only memberId/uid, kind, result and counts.</td></tr>
102-</table>
--
112-<tr><td><code>reconcileLink</code></td><td>tinker-hq-apps / <code>clayhub-link</code></td><td>schedule <code>every 6 hours from 01:15 to 19:15</code>, <code>UTC</code>; retryCount 1, maxRetrySeconds 0, minBackoffSeconds 600, maxBackoffSeconds 600, maxDoublings 0</td><td><code>clayhub-link@</code></td><td>300 / 512MiB / 1 / 1 / 1</td></tr>
113-</table>
114-<p class="note">The ingest URL is a hard-coded constant in the sender, tested. A reconcile and a recompute are each one transaction of up to 500 writes: 2 per member plus 1 to consume an override = <strong>249 members</strong>. Both refuse above that (nothing written, error) and alert from 200.</p>
115-
116-<h2>Phases</h2>
117:<div class="note"><strong>Order:</strong> E-pre first, then E-0 (merged <em>and</em> its rules released before E-3/E-4 merge, because the rules guard needs its control files to match <code>main</code>). E-1, E-2 and E-3 can then proceed on separate branches; E-4 needs E-1 and E-3; E-5 before E-6. <strong>E-2 merges only when E-6 can follow within days, and after #64's vault release is attested:</strong> once <code>members/recomputeStatuses</code> is declared on <code>main</code>, any <code>vault</code> or <code>core</code> scheduler attestation fails until that job exists. <strong>E-7 onward waits for every gate</strong> (listed in E-7). Every PR: Codex + Claude implementation review, then Christie's "okay to merge". Every release: that project's guard, <code>--diff</code> pasted, Christie's "approved to change firebase &lt;sha&gt;" for that exact sha and project.</div>
118-
119-<div class="phase">
120-<h3>E-pre — Decisions and the status rule, before any link code <span class="status-tag ready">execution-ready: true</span></h3>
121-<ol>
122-  <li>Christie's answers to Q1–Q9 → DECISIONS rows in my-clay-hub; SPEC.md (§3: the recompute time) and DATA-MODEL.md (the contract, the never-copy list, tombstones; correct "written only by ingestMemberUpdate" — the recompute writes status and profile fields too) in one docs PR.</li>
123-  <li>If Q6 = B: <code>deriveStatus</code> checks a <code>scheduledPause</code> in this order — non-object → malformed (<code>review</code>); object with <code>processed !== true</code> → ignored; otherwise as today (history entries unchanged). Its own small PR in <code>shared/</code>, with tests (processed, unprocessed, malformed container, malformed date with <code>processed:true</code>, legacy) under all three time zones, and its own review — before E-1 freezes the fixtures.</li>
124-</ol>
125-</div>
126-
127-<div class="phase">
128:<h3>E-0 — studio-hub: the users-rules pins <span class="status-tag ready">execution-ready: true</span></h3>
129:<p>A comment on the <code>users</code> rules naming My Clay Hub's dependency (<code>name</code>, <code>role</code>, <code>active</code>, <code>appAccess</code>). Tests only for what isn't covered (rules.test.js already pins self-granted appAccess and studios): role self-promotion on create (<code>manager</code>, <code>admin</code>), and <code>active</code> on self-update. Released through studio-hub's rules guard (free, sha phrase) <strong>before</strong> E-3 or E-4 merge.</p>
130-<div class="bdd">Given a signed-in user with no users doc
131:When they create their own doc with role 'manager' (or 'admin')
132-Then the write is denied
133-
134-Given a staff user
135-When they update their own doc changing active
136-Then the write is denied</div>
--
179-
180-<div class="phase">
181-<h3>E-4 — studio-hub: the <code>clayhub-link</code> codebase <span class="status-tag ready">execution-ready: true</span></h3>
182-<ul>
183-  <li><code>onClayHubMemberWritten</code>: memberIds from before and after; for each, one query on <code>memberId</code> only (its <code>QuerySnapshot.readTime</code>); the contract envelope; a conflict → error naming the memberId, nothing sent; no memberId → error naming the doc id only.</li>
184:  <li><code>onStaffUserWritten</code>: re-read <code>users/{uid}</code> (missing → tombstone) with that read's <code>DocumentSnapshot.readTime</code>; the staff rule.</li>
185-  <li><code>reconcileLink</code>: one read-only transaction pinned to one readTime over <code>clayHub_members</code> and <code>users</code>; validate the member set (held conflicts; abort on a missing/malformed memberId); any read error → nothing sent; then one <code>reconcile</code> call per scope; a 409 is logged as the stop.</li>
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
--
286-<table>
287-<tr><th>Finding</th><th>Resolution (v2)</th></tr>
288-<tr><td>The 10%/5% stops can't work from the sender, a partial reconcile isn't atomic, the first fill would trip them (both, blocking)</td><td>The <code>reconcile</code> kind: the receiver computes the whole change set and writes all-or-nothing; denominators defined; first fill exempt; Q8 floors.</td></tr>
289-<tr><td>Nested notes/billing would leak; strict validation would hide malformed values from <code>deriveStatus</code> (both, blocking)</td><td>The contract: snapshots rebuilt from allowed keys at every level; malformed values carried as <code>"!malformed"</code>; fixtures for each.</td></tr>
290-<tr><td>readTime has no wire format; same-millisecond reads collapse (both)</td><td>{seconds, nanos}, stored as a Timestamp, compared as a pair; tests.</td></tr>
291:<tr><td>Staff input must fail closed; F5 overstated the schema (Codex, blocking; Claude should-fix)</td><td>The staff rule in the contract; F5 corrected; tests.</td></tr>
292-<tr><td>K13 relies on an unproven delivery identity; a code search isn't a workload audit (Codex, blocking)</td><td>E-5 inventory and audit logs; E-8 step 2 proves delivery after the removal; Q3 rewritten.</td></tr>
293-<tr><td>The E-6 OIDC probe had no mechanism; the synthetic member (Codex, blocking; Claude should-fix)</td><td>Dropped: E-6 proves 403 and the invoker reading; the first authenticated call is E-8's logged first fill.</td></tr>
294-<tr><td>The stop procedure is refused by the guard (both)</td><td>"Stopping the link": Console pause + invoker removal, then a guarded <code>["private"]</code> redeploy.</td></tr>
295-<tr><td>Decisions and gates too late (Codex, blocking)</td><td>E-pre; E-7 lists every gate, including #64; E-8 adds a fresh vault copy.</td></tr>
296-<tr><td>Recompute needs atomicity and race handling (Codex, blocking)</td><td>Dry run, then per-member transactions re-reading; profiles in step; tests both orders.</td></tr>
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
336-</table>
337-
338-<h2>Decisions log</h2>
339-<ul>
340-  <li><strong>Oct 8:</strong> Christie: "mark it ready and start E-pre" — every phase execution-ready: true.</li>
341:  <li><strong>Oct 8 — E-pre done:</strong> PR #13 (docs: DECISIONS #65–#73, SPEC, DATA-MODEL) merged at <code>a4b8e21</code> (head <code>ee1e5b3</code>); PR #14 (<code>deriveStatus</code> ignores an unprocessed <code>scheduledPause</code>, #70) merged at <code>3cd273a</code> (head <code>09c5f95</code>), both with Christie's "yes" to merge. Reviews: round 1 Codex (#13 merge after fixes, 2 blocking — UTC/Denver wording, #72's counting rule; #14 safe) and Claude (#13 merge after fixes, 0 blocking; #14 safe); all applied; round 2 Codex confirming on #13: safe to merge, no findings. Full suite on #14: unit 233, rules guard 199, functions guard 944, emulator 68+2+3, rules 194. Nothing released. Note: Monday's vault <code>--diff</code> will list <code>shared/</code> as changed (the guard pins it; the vault codebase doesn't use it). Next: E-0 (studio-hub users-rules pins), after Monday's V-4 finish and the #64 release.</li>
342-  <li><strong>Oct 8 — Christie's answers:</strong> Q1 09:30 UTC; Q2 inside, own PR; Q3 audit → strip → remove → prove; Q4 build the roster now; Q5 a new memberId is a new identity; Q6 <strong>B</strong> (unprocessed Quick Log pauses don't block booking); Q7 <strong>keep name, member-since, stage and every pause/last-day date; drop email, emailLower, phoneLast4</strong> (her change: "useful and isn't sensitive"); Q8 as described; Q9 one recorded per-service exception. E-pre writes these into DECISIONS/SPEC/DATA-MODEL.</li>
343-  <li><strong>Oct 8:</strong> v1 drafted from the foundation plan's Phase E outline after research (F1–F11).</li>
344-  <li><strong>Oct 8:</strong> review round 1 (Codex "not ready", 9 blocking; Claude "ready after fixes", 3 blocking, 13 should-fix) → v2: the contract, the receiver-side reconcile, E-pre, the stop runbook, the settings table, E-5's audit, the K13 proof; Q6–Q8 added. Review files <code>thoughts/reviews/my-clay-hub-phase-e-plan-round1-*</code>.</li>
345-  <li><strong>Oct 8:</strong> review round 2 (Codex "not ready", 5 blocking; Claude "ready after fixes", 3 blocking) → v3: <code>held</code> conflicts and race-safe removals, the readTime advance, Q9 (event-trigger invoker — confirmed in firebase-tools 15.22.3 source), exact schemas and tombstones, a one-transaction recompute, the full settings table, the reordered E-7/E-8, the stop-email path. Both reviewers recommend Q6 = B. Review files <code>…-round2-*</code>.</li>
346-  <li><strong>Oct 8:</strong> review round 3 (Codex "not ready", 2 blocking; Claude "ready after fixes", 0 blocking — both confirm every round-2 finding resolved and Q9's design against the CLI source) → v4: the counterfactual source-driven rule, <code>linkOverrides</code>, Q6's exact rule and order, the E-7/E-8 order, the Token Creator gate, two stop kinds, the trigger-service alert, the E-2 merge timing. Review files <code>…-round3-*</code>.</li>

RULE HELPERS AND USERS BLOCK
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
      // /staff screens), and store only name and role there. So no one may raise their own role,
      // grant themselves appAccess, or change their own active: staff and managers can't touch
      // any of the three on their own doc; an admin can't change their own active, and changing
      // their own role or appAccess can only demote them (admins are already granted). name is
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

RELEVANT TESTS
431-  test('manager can create an entry inside the transaction that bumps the parent rev (real serverTimestamp)', async () => {
432-    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
433-    await assertSucceeds(saveWithHistory(db));
434-  });
435-
436:  test('admin can create an entry (own email)', async () => {
437-    const db = getDb(ADMIN_UID, ADMIN_EMAIL);
438-    await assertSucceeds(saveWithHistory(db, { payloadOverrides: { savedBy: ADMIN_EMAIL }, updatedBy: ADMIN_EMAIL }));
439-  });
440-
441-  test('baseline + edit entries in ONE transaction both pass (same new rev)', async () => {
--
796-  });
797-});
798-
799-
800-// ─── USERS — PRIVILEGE ESCALATION VIA SELF-WRITE (FIX APPLIED) ──────────────
801:// Fix applied in this pass: the self-create/self-update rules previously
802-// pinned only the `role` field. `appAccess` and `studios` were completely
803-// unprotected, so any authenticated staff user could grant themselves access
804-// to nearly every app on the platform (KPI, Classbook, Training, Roster
805-// Manager, Summer Camp, Clay Hub, Social Media, Playbook, etc.) with a
806-// direct Firestore write that bypasses the Manage Team UI entirely. Payroll
807-// and bookkeeping were never reachable this way (they gate on role, not
808-// appAccess, and role was already protected) but everything else was.
809-
810:describe('Users — appAccess/studios cannot be self-granted (privilege escalation fix)', () => {
811:  test('staff CANNOT self-update to add appAccess entries', async () => {
812-    const db = getDb(STAFF_NOACCESS_UID);
813-    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
814-      appAccess: ['classbook-admin', 'payroll', 'training'],
815-    }));
816-  });
817-
818:  test('staff CANNOT self-update to change studios', async () => {
819-    const db = getDb(STAFF_NOACCESS_UID);
820-    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
821-      studios: ['tinker', 'clayhub'],
822-    }));
823-  });
824-
825:  test('staff CAN still self-update unrelated fields (no regression)', async () => {
826-    const db = getDb(STAFF_NOACCESS_UID);
827-    await assertSucceeds(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
828-      name: 'Updated Name',
829-      pin: '4321',
830-    }));
831-  });
832-
833:  test('a brand-new user CANNOT self-create with appAccess already populated', async () => {
834-    const db = getDb('brand-new-uid');
835-    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid'), {
836-      role: 'staff',
837-      appAccess: ['classbook-admin'],
838-    }));
839-  });
840-
841:  test('a brand-new user CANNOT self-create with a studio outside the known set', async () => {
842-    const db = getDb('brand-new-uid-2');
843-    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-2'), {
844-      role: 'staff',
845-      studios: ['tinker', 'some-future-privileged-studio'],
846-    }));
847-  });
848-
849:  test('a brand-new user CAN self-create with no appAccess/studios (bootstrap)', async () => {
850-    const db = getDb('brand-new-uid-3');
851-    await assertSucceeds(setDoc(doc(db, 'users', 'brand-new-uid-3'), {
852-      role: 'staff',
853-      name: 'New Hire',
854-    }));
--
910-// BDD scenarios from thoughts/plans/archive-employees.html, Phase 1.
911-
912-// ─── USERS — FIELDS MY CLAY HUB RELIES ON (Phase E, E-0) ─────────────────────
913-// My Clay Hub's staff roster is decided by users docs' role, active and appAccess (it stores name
914-// and role), so no one may raise their own role, grant themselves appAccess, or change their own
915:// active. appAccess/studios self-grants are pinned above, archived self-reactivation and an admin's
916-// own active below; these pin what wasn't covered.
917-describe('Users — fields My Clay Hub relies on (no self-promotion, no self-set active)', () => {
918:  test('a brand-new user CANNOT self-create as manager', async () => {
919-    const db = getDb('brand-new-uid-mgr');
920-    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-mgr'), { role: 'manager', name: 'New Hire' }));
921-  });
922-
923:  test('a brand-new user CANNOT self-create as admin', async () => {
924-    const db = getDb('brand-new-uid-adm');
925-    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-adm'), { role: 'admin', name: 'New Hire' }));
926-  });
927-
928:  test('staff CANNOT self-update their role to manager or admin', async () => {
929-    const db = getDb(STAFF_NOACCESS_UID);
930-    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'manager' }));
931-    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'admin' }));
932-  });
933-
934:  test('staff CANNOT self-update active (setting it where it was absent, either way)', async () => {
935-    const db = getDb(STAFF_NOACCESS_UID);
936-    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { active: true }));
937-    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { active: false }));
938-  });
939-
940:  test('a manager CANNOT self-update their own active or role', async () => {
941-    const db = getDb(MANAGER_UID);
942-    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), { active: false }));
943-    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), { role: 'admin' }));
944-  });
945-});
--
963-  test('archived user CAN still read their own doc (app must load, not error)', async () => {
964-    const db = getDb(ARCHIVED_STAFF_UID);
965-    await assertSucceeds(getDoc(doc(db, 'users', ARCHIVED_STAFF_UID)));
966-  });
967-
968:  test('archived user CAN lightly self-update an unrelated field; active stays false (pinned, unchanged)', async () => {
969-    const db = getDb(ARCHIVED_STAFF_UID);
970-    await assertSucceeds(updateDoc(doc(db, 'users', ARCHIVED_STAFF_UID), {
971-      name: 'Still Archived',
972-    }));
973-  });
--
1006-      active: true,
1007-    }));
1008-  });
1009-
1010-  // The critical self-lockout-prevention test: firestore.rules:128's blanket
1011:  // `allow write: if isAdmin();` sits outside the self-update rule's
1012-  // fieldUnchanged('active') pin (Firestore ORs sibling `allow` rules), so
1013-  // without an explicit guard an admin could archive themselves with no
1014-  // recovery path — same bug shape as the manager self-grant regression
1015-  // above, just for a field that didn't exist yet when that fix shipped.
1016:  test('admin CANNOT write active:false to their OWN doc via any rule path (self-lockout prevention)', async () => {
1017-    const db = getDb(ADMIN_UID);
1018-    await assertFails(updateDoc(doc(db, 'users', ADMIN_UID), {
1019-      active: false,
1020-    }));
1021-  });
--
1681-    });
1682-    await assertSucceeds(updateDoc(ref, { title: 'Updated title' }));
1683-  });
1684-});
1685-
1686:describe('Recap — a non-admin creator can still edit their own already-personal meeting', () => {
1687-  test('legacy personal meeting created by a non-admin: creator can still make an ordinary edit', async () => {
1688-    const db = getDb(RECAP_UID);
1689-    await assertSucceeds(updateDoc(doc(db, 'meetings', 'legacy-personal-meeting'), { title: 'Updated' }));
1690-  });
1691-});
--
2029-    await assertSucceeds(getDoc(doc(db, 'users', STAFF_TIMECLOCK_UID)));
2030-    await assertFails(getDocs(collection(db, 'users')));
2031-    await assertFails(updateDoc(doc(db, 'users', STAFF_TIMECLOCK_UID), { email: 'x@y.z' }));
2032-    // The auth guard's bootstrap write, verbatim: refused, so the bot can never become a user.
2033-    await assertFails(setDoc(doc(db, 'users', REMINDER_BOT_UID), { uid: REMINDER_BOT_UID, email: 'reminders@tinkerartstudio.com', name: 'reminders', role: 'staff', studios: ['tinker', 'clayhub'], appAccess: ['timeclock'], createdAt: 'now' }));
2034:    // …and not even the minimal shape the self-create rule would otherwise allow.
2035-    await assertFails(setDoc(doc(db, 'users', REMINDER_BOT_UID), { role: 'staff' }));
2036-  });
2037-
2038-  test('bot cannot LIST users even constrained to its own id (the self-read grant excludes it)', async () => {
2039-    const db = getDb(REMINDER_BOT_UID);
--
2295-    await assertSucceeds(updateDoc(doc(db, 'dayOffCamps_lessonData', SDOC_SEED_ID), { introPitch: 'edited' }));
2296-  });
2297-});
2298-
2299-describe('Default deny — unlisted collections are blocked', () => {
2300:  test('admin cannot read an unknown collection', async () => {
2301-    const db = getDb(ADMIN_UID);
2302-    await assertFails(getDoc(doc(db, 'someRandomCollection', 'doc')));
2303-  });
2304-
2305-  test('unauthenticated user cannot read an unknown collection', async () => {
--
2407-// (a)–(d) are RED on the pre-removal rules: (a) succeeds there, and (b)–(d) then succeed
2408-// because (a)'s document persists (this file never clears the emulator between tests).
2409-// Keep (a) first and each check in its own test. CLAY_ESCALATION_UID and CLAY_NO_USERS_DOC_UID are
2410-// used only inside this describe block — never reuse them elsewhere.
2411-const CLAY_ESCALATION_UID = 'clay-escalation-uid';   // signed in, no users doc
2412:const CLAY_NO_USERS_DOC_UID = 'clay-no-users-doc-uid'; // signed in, no users doc, never self-creates
2413-const CLAY_COLLECTIONS = ['clayMembers', 'clayBookings', 'claySpots', 'clayBlockedSlots', 'claySettings'];
2414-const CLAY_FIXTURE_ID = {
2415-  clayMembers: 'fixture-clay-member',
2416-  clayBookings: 'fixture-clay-booking',
2417-  claySpots: 'fixture-clay-spot',

COMMIT NUMSTAT AND FILE TYPES
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-X4DNHqnf' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-Jt1ml1PS' (errno=Operation not permitted)
8	6	firestore.rules
4	3	rules.test.js
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-zRt4TvVd' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-WotTnP7n' (errno=Operation not permitted)
M	firestore.rules
M	rules.test.js

codex
Blocking wording issue remains:

- [firestore.rules:114](/Users/christiehubley/studio-hub/firestore.rules:114) says “no one may … grant themselves appAccess” and that an admin changing their own `role` or `appAccess` “can only demote them.”
- But [firestore.rules:183](/Users/christiehubley/studio-hub/firestore.rules:183) allows an active admin to update their own `appAccess` freely as long as `active` is unchanged. An admin can also simultaneously change their role to `staff` and add `my-clay-hub`, remaining granted under the plan’s staff formula. Changing only `appAccess` while remaining admin does not demote them at all.

The other two round-1 findings are fixed accurately: the comment now distinguishes fields read from fields stored, and “change active” no longer falsely excludes `active` on self-create. The commit contains comments only; rule logic is unchanged.

NOT SAFE TO MERGE
tokens used
39,905
Blocking wording issue remains:

- [firestore.rules:114](/Users/christiehubley/studio-hub/firestore.rules:114) says “no one may … grant themselves appAccess” and that an admin changing their own `role` or `appAccess` “can only demote them.”
- But [firestore.rules:183](/Users/christiehubley/studio-hub/firestore.rules:183) allows an active admin to update their own `appAccess` freely as long as `active` is unchanged. An admin can also simultaneously change their role to `staff` and add `my-clay-hub`, remaining granted under the plan’s staff formula. Changing only `appAccess` while remaining admin does not demote them at all.

The other two round-1 findings are fixed accurately: the comment now distinguishes fields read from fields stored, and “change active” no longer falsely excludes `active` on self-create. The commit contains comments only; rule logic is unchanged.

NOT SAFE TO MERGE
