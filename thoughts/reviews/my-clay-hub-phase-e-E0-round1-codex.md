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
session id: 01a12118-8349-7f53-b02c-36f4a48064a2
--------
user
## Change under review
Repo /Users/christiehubley/studio-hub (Firestore rules for project tinker-hq-apps — shared by ALL staff apps). Branch mch-e0-users-pins, one commit vs main. This is Phase E step E-0 of the plan ~/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html (read its E-0 section and anything it says about users docs / staffRoster):
"A comment on the users rules naming My Clay Hub's dependency (name, role, active, appAccess). Tests only for what isn't covered (rules.test.js already pins self-granted appAccess and studios): role self-promotion on create (manager, admin), and active on self-update."

The change: a comment in firestore.rules (no logic change) + a new describe block in rules.test.js. Each new pin was mutation-checked (removing the role-on-create, role-on-self-update, or active-on-self-update condition makes 2 of the new tests fail). npm test: rules 744/744, guard 141/141.

## What I want
- Does the diff change any rule LOGIC? (It must not.)
- Do the tests cover what E-0 asks, and anything else a person could self-set that would change who counts as Clay Hub staff in My Clay Hub (role, active, appAccess, studios — via create, self-update, or the manager/admin paths on their OWN doc)? Name any uncovered path concretely.
- Are the tests sound (would pass for the right reason, not e.g. because the doc doesn't exist)?
- Is the comment accurate against the plan?
End with exactly SAFE TO MERGE or NOT SAFE TO MERGE. Read-only: do not edit files, change git state, or run deploys.

## Diff
diff --git a/firestore.rules b/firestore.rules
index de1981c..c928f98 100644
--- a/firestore.rules
+++ b/firestore.rules
@@ -109,6 +109,12 @@ service cloud.firestore {
     // ═══════════════════════════════════════════════════════════════
 
     match /users/{userId} {
+      // My Clay Hub depends on these (Phase E): the clayhub-link functions copy each users doc's
+      // name, role, active and appAccess to my-clay-hub's staffRoster, which decides who can use
+      // its /staff screens. So a person must never be able to set their own role, active or
+      // appAccess (name is self-editable and is display-only there). Pinned by rules.test.js
+      // "Users — fields My Clay Hub relies on"; loosening any of them changes who is staff in
+      // My Clay Hub too.
       // Own doc read — all authenticated users (auth guard requires it). Not the reminder bot: its
       // grant is GET-only below, and this `read` would let an id-constrained LIST through.
       allow read: if isAuthenticated() && request.auth.uid == userId && !isReminderBot();
diff --git a/rules.test.js b/rules.test.js
index b08cb2c..d2570a3 100644
--- a/rules.test.js
+++ b/rules.test.js
@@ -909,6 +909,40 @@ describe('Users — appAccess/studios cannot be self-granted (privilege escalati
 // ─── USERS — ARCHIVE FEATURE: active:false revokes access everywhere ────────
 // BDD scenarios from thoughts/plans/archive-employees.html, Phase 1.
 
+// ─── USERS — FIELDS MY CLAY HUB RELIES ON (Phase E, E-0) ─────────────────────
+// My Clay Hub's staff roster is copied from users docs (name, role, active, appAccess), so no one
+// may set their own role, active or appAccess. appAccess/studios self-grants are pinned above and
+// archived self-reactivation below; these pin what wasn't covered.
+describe('Users — fields My Clay Hub relies on (no self-promotion, no self-set active)', () => {
+  test('a brand-new user CANNOT self-create as manager', async () => {
+    const db = getDb('brand-new-uid-mgr');
+    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-mgr'), { role: 'manager', name: 'New Hire' }));
+  });
+
+  test('a brand-new user CANNOT self-create as admin', async () => {
+    const db = getDb('brand-new-uid-adm');
+    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-adm'), { role: 'admin', name: 'New Hire' }));
+  });
+
+  test('staff CANNOT self-update their role to manager or admin', async () => {
+    const db = getDb(STAFF_NOACCESS_UID);
+    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'manager' }));
+    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'admin' }));
+  });
+
+  test('staff CANNOT self-update active (setting it where it was absent, either way)', async () => {
+    const db = getDb(STAFF_NOACCESS_UID);
+    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { active: true }));
+    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { active: false }));
+  });
+
+  test('a manager CANNOT self-update their own active or role', async () => {
+    const db = getDb(MANAGER_UID);
+    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), { active: false }));
+    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), { role: 'admin' }));
+  });
+});
+
 describe('Users — active:false revokes access everywhere (Archive Employees feature)', () => {
   test('archived admin cannot read payroll (isAdmin now requires isActiveUser)', async () => {
     const db = getDb(ARCHIVED_ADMIN_UID);
codex
I’ll inspect the E-0 plan section, the complete users rule, and the surrounding fixtures/tests. I’ll keep this strictly read-only and verify the actual branch diff rather than relying only on the pasted excerpt.
exec
/bin/zsh -lc 'git status --short --branch && git diff --stat main...HEAD && git diff --unified=80 main...HEAD -- firestore.rules rules.test.js && rg -n "E-0|staffRoster|users doc|My Clay Hub|clayhub-link" /Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html' in /Users/christiehubley/studio-hub
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-reumxOBR' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-63UexPcM' (errno=Operation not permitted)
## mch-e0-users-pins
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-gfi8kW5N' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-jDCjg8ZD' (errno=Operation not permitted)
 firestore.rules |  6 ++++++
 rules.test.js   | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-ekGl7VPh' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-M6veUvzN' (errno=Operation not permitted)
diff --git a/firestore.rules b/firestore.rules
index de1981c..c928f98 100644
--- a/firestore.rules
+++ b/firestore.rules
@@ -32,160 +32,166 @@ service cloud.firestore {
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
+      // My Clay Hub depends on these (Phase E): the clayhub-link functions copy each users doc's
+      // name, role, active and appAccess to my-clay-hub's staffRoster, which decides who can use
+      // its /staff screens. So a person must never be able to set their own role, active or
+      // appAccess (name is self-editable and is display-only there). Pinned by rules.test.js
+      // "Users — fields My Clay Hub relies on"; loosening any of them changes who is staff in
+      // My Clay Hub too.
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
diff --git a/rules.test.js b/rules.test.js
index b08cb2c..d2570a3 100644
--- a/rules.test.js
+++ b/rules.test.js
@@ -832,160 +832,194 @@ describe('Users — appAccess/studios cannot be self-granted (privilege escalati
 
   test('a brand-new user CANNOT self-create with appAccess already populated', async () => {
     const db = getDb('brand-new-uid');
     await assertFails(setDoc(doc(db, 'users', 'brand-new-uid'), {
       role: 'staff',
       appAccess: ['classbook-admin'],
     }));
   });
 
   test('a brand-new user CANNOT self-create with a studio outside the known set', async () => {
     const db = getDb('brand-new-uid-2');
     await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-2'), {
       role: 'staff',
       studios: ['tinker', 'some-future-privileged-studio'],
     }));
   });
 
   test('a brand-new user CAN self-create with no appAccess/studios (bootstrap)', async () => {
     const db = getDb('brand-new-uid-3');
     await assertSucceeds(setDoc(doc(db, 'users', 'brand-new-uid-3'), {
       role: 'staff',
       name: 'New Hire',
     }));
   });
 
   test('the real bootstrap write shape succeeds: role staff, appAccess [], studios [tinker, clayhub]', async () => {
     // Mirrors js/app.js handleAuthStateChange()'s default-user-doc write exactly.
     const db = getDb('brand-new-uid-4');
     await assertSucceeds(setDoc(doc(db, 'users', 'brand-new-uid-4'), {
       name: 'New Hire',
       email: 'newhire@tinkerartstudio.com',
       role: 'staff',
       studios: ['tinker', 'clayhub'],
       appAccess: [],
       createdAt: '2026-08-11T00:00:00.000Z',
     }));
   });
 
   test('admin can still grant appAccess to another user', async () => {
     const db = getDb(ADMIN_UID);
     await assertSucceeds(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
       appAccess: ['kpi'],
     }));
   });
 
   // Regression test for a gap found by independent second-model review:
   // the separate "Manager update" rule (isManager() && role unchanged) had
   // no request.auth.uid != userId guard, so a manager writing to THEIR OWN
   // doc satisfied it too — bypassing the appAccess/studios pins above
   // entirely, since Firestore ORs sibling `allow update` rules together.
   // Concretely exploitable: belongsToStudio() (gating clayHub_*/rosterManager/
   // clayInventory) doesn't accept isManagerOrAbove(), so a manager scoped to
   // studios:['tinker'] only could have self-granted 'clayhub' this way.
   test('manager CANNOT self-grant studios via the manager-update rule (regression)', async () => {
     const db = getDb(MANAGER_UID);
     await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), {
       studios: ['tinker', 'clayhub', 'some-future-privileged-studio'],
     }));
   });
 
   test('manager CANNOT self-grant appAccess via the manager-update rule (regression)', async () => {
     const db = getDb(MANAGER_UID);
     await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), {
       appAccess: ['payroll'],
     }));
   });
 
   test('manager CAN still grant appAccess/studios to ANOTHER user (legitimate team management, unaffected by the fix)', async () => {
     const db = getDb(MANAGER_UID);
     await assertSucceeds(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
       appAccess: ['training'],
       studios: ['tinker', 'clayhub'],
     }));
   });
 });
 
 
 // ─── USERS — ARCHIVE FEATURE: active:false revokes access everywhere ────────
 // BDD scenarios from thoughts/plans/archive-employees.html, Phase 1.
 
+// ─── USERS — FIELDS MY CLAY HUB RELIES ON (Phase E, E-0) ─────────────────────
+// My Clay Hub's staff roster is copied from users docs (name, role, active, appAccess), so no one
+// may set their own role, active or appAccess. appAccess/studios self-grants are pinned above and
+// archived self-reactivation below; these pin what wasn't covered.
+describe('Users — fields My Clay Hub relies on (no self-promotion, no self-set active)', () => {
+  test('a brand-new user CANNOT self-create as manager', async () => {
+    const db = getDb('brand-new-uid-mgr');
+    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-mgr'), { role: 'manager', name: 'New Hire' }));
+  });
+
+  test('a brand-new user CANNOT self-create as admin', async () => {
+    const db = getDb('brand-new-uid-adm');
+    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-adm'), { role: 'admin', name: 'New Hire' }));
+  });
+
+  test('staff CANNOT self-update their role to manager or admin', async () => {
+    const db = getDb(STAFF_NOACCESS_UID);
+    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'manager' }));
+    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'admin' }));
+  });
+
+  test('staff CANNOT self-update active (setting it where it was absent, either way)', async () => {
+    const db = getDb(STAFF_NOACCESS_UID);
+    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { active: true }));
+    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { active: false }));
+  });
+
+  test('a manager CANNOT self-update their own active or role', async () => {
+    const db = getDb(MANAGER_UID);
+    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), { active: false }));
+    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), { role: 'admin' }));
+  });
+});
+
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
6:<title>Plan: My Clay Hub Phase E — the live link from Membership Manager</title>
29:<h1>Plan: My Clay Hub Phase E — the live link from Membership Manager</h1>
32:  <strong>Goal:</strong> When staff add, edit, pause or offboard a member in Membership Manager, My Clay Hub's own copy of that member (<code>members/{memberId}</code>, with the right derived status) matches within a minute — one way only, carrying only the allowed fields, and safe against late, duplicate or out-of-order deliveries. Staff with My Clay Hub access are mirrored the same way into <code>staffRoster</code>.<br>
33:  <strong>Repos:</strong> <code>/Users/christiehubley/my-clay-hub</code> (the receiving side) and <code>/Users/christiehubley/studio-hub</code> (the sending side: the <code>clayhub-link</code> functions and <code>tinker-hq-apps</code>' own functions guard). Console/IAM work in both projects is Christie's (no gcloud on the Mac; read-only readings by Claude in her Chrome or via Cloud Shell).<br>
44:  <li><strong>D22 "Re-read, then send a snapshot"</strong> (DECISIONS #53): a trigger on <code>clayHub_members/{id}</code> collects the memberId from before and after; for each, one query on <code>memberId</code> only; live = <code>retired !== true</code>; exactly one live doc → its fields; none → tombstone; more than one → conflict, nothing sent, alert. POST <code>{memberId, snapshot, readTime}</code>; ingest drops anything not newer than the stored <code>sourceReadTime</code>, checks the payload strictly, runs <code>deriveStatus</code>, writes, never deletes. The reconcile uses the same envelope, read in one read-only transaction pinned to one readTime. <code>users/{uid}</code> → <code>staffRoster/staff_{uid}</code> the same way (no memberId, no conflict case).</li>
46:  <li><strong>#24</strong>: only <code>phoneLast4</code> leaves <code>tinker-hq-apps</code>, worked out there. <strong>#37 / D6</strong>: never write back. <strong>#42</strong>: IAM one-way; ingest can't delete. <strong>#32 / D2 / M1</strong>: the link is codebase <code>clayhub-link</code> in studio-hub, deployed only by <code>tinker-hq-apps</code>' own functions guard; neither guard can reach the other project. <strong>#54 / D23</strong>: 2nd gen, retries on (<code>retry: true</code> on triggers, retryConfig on schedules), explicit maxInstances, Admin app built once per instance; Firestore <code>nam5</code>, Eventarc location <code>nam5</code>, functions <code>us-central1</code>.</li>
47:  <li><strong>IAM inventory (D11)</strong>: <code>clayhub-link@tinker-hq-apps</code> = a custom read-only Firestore role (get, list) + <code>eventarc.eventReceiver</code>; <code>ingestmemberupdate</code> is <code>invoker</code>: exactly <code>clayhub-link@tinker-hq-apps</code> (declared; the CLI sets it — never granted by hand); <code>ingest@my-clay-hub</code> = custom role get/list/create/update, no delete. Called at the service's exact run.app URL with an OIDC token from the metadata server.</li>
56:<tr><td>F3</td><td>Never copy: <code>keypadCode</code>, <code>keypadUserId</code>, <code>staffNotes</code>, <code>notes</code>, <code>application</code>, <code>actions</code>, the full phone, the shelf fields, billing fields — at any nesting level.</td><td>save-safety plan, "What My Clay Hub's link needs"</td></tr>
65:<tr><td>F13</td><td><strong>The pinned CLI (15.22.3) and event triggers:</strong> it sends events <em>as the trigger's own runtime account</em> (<code>eventTrigger.serviceAccountEmail</code> = the function's service account), but sets a Cloud Run invoker only for HTTP-style functions, never for event triggers. On the first event release it adds project-wide bindings: <code>run.invoker</code> and <code>eventarc.eventReceiver</code> for the default Compute account, and Token Creator for the Pub/Sub service agent. So <code>clayhub-link@</code> needs <code>run.invoker</code> on its two trigger services, and nothing in the CLI gives it that (Q9).</td><td>firebase-tools lib/gcp/cloudfunctionsv2.js:214-216; lib/deploy/functions/release/fabricator.js:221-253, 345-389; lib/deploy/functions/checkIam.js:104-160</td></tr>
66:<tr><td>F12</td><td>Firestore IAM can't be limited to one collection: <code>clayhub-link@</code>'s read role covers the whole <code>tinker-hq-apps</code> database (payroll included). Accepted residual: read-only, one runtime, guarded code.</td><td>Firestore IAM model</td></tr>
76:<tr><td>Q4</td><td>The staff roster, with no My Clay Hub box in Tinker HQ yet.</td><td><strong>Build the machinery now, no Tinker HQ UI.</strong> It mirrors managers/admins until Phase F adds the box. Strict input, fails closed.</td></tr>
78:<tr><td>Q6 <em>(new)</em></td><td>A "Quick Log" pause request (no <code>scheduledAt</code>) is never started by Membership Manager, but <code>deriveStatus</code> treats its dates as a real pause, so My Clay Hub would show the member as <strong>paused</strong> (no booking) for those dates.</td><td><strong>B (both reviewers):</strong> an unprocessed request doesn't stop a paying member booking. The sender sends <code>scheduledPause.processed</code> instead of the timestamp, using Membership Manager's own test (a pause is processed when <code>scheduledAt</code> is present — <code>member-status.js:127-131</code>); <code>deriveStatus</code> first treats a non-object <code>scheduledPause</code> as malformed (<code>review</code>), and only then ignores an object whose <code>processed</code> isn't <code>true</code> (history entries are processed by definition). A <code>deriveStatus</code> change, made and reviewed in E-pre before E-1's fixtures freeze. Option A (count it) needs no change.</td></tr>
79:<tr><td>Q7 <em>(new)</em></td><td>When a member is removed, does My Clay Hub keep their name, email and phone digits?</td><td><strong>Christie, Oct 8: keep everything last known except the contact details.</strong> A removed member's <code>members</code> doc keeps their name, <code>firstName</code>, <code>lastInitial</code>, <code>memberSince</code>, stage, pause history, scheduled pause and last-day date (useful for history; not sensitive), and drops <code>email</code>, <code>emailLower</code> and <code>phoneLast4</code>. Their member-facing profile reduces to <code>removed</code>. (Membership Manager keeps the full record either way.)</td></tr>
81:<tr><td>Q9 <em>(new, round 2)</em></td><td>The two link triggers need permission to call their own Cloud Run services (F13), and the CLI never grants it. The guard's rule is "never grant run.invoker by hand".</td><td><strong>One recorded exception, per service:</strong> right after E-7's release, you grant <code>run.invoker</code> to <code>clayhub-link@</code> on exactly the two trigger services (<code>onclayhubmemberwritten</code>, <code>onstaffuserwritten</code>) — never project-wide. The guard declares that expected invoker list for event triggers and its attestation checks it (a wrong or extra grant fails). Until it's granted, deliveries are refused and Eventarc retries them (up to 24 h). Alternative: project-level <code>run.invoker</code> for <code>clayhub-link@</code> — simpler, broader, not recommended.</td></tr>
96:<tr><td><code>staff</code></td><td><code>{uid, staff: {name, role}}</code> — <strong>sent only for granted users</strong> — or <code>{uid, tombstone:true}</code>. Granted = <code>role</code> exactly <code>admin</code>|<code>manager</code>|<code>staff</code>, <code>active</code> absent or <code>true</code>, <code>appAccess</code> absent or a list of strings, and (role manager/admin, or <code>appAccess</code> contains <code>my-clay-hub</code>). A deleted, ungranted or malformed users doc → a tombstone envelope; malformed also logs an error naming the uid only (it repeats each reconcile until fixed — accepted). Never email, PIN or <code>appAccess</code>.</td></tr>
97:<tr><td><code>staffRoster/staff_{uid}</code> (stored)</td><td><code>{uid, name, role, sourceReadTime, updatedAt, tombstone:false}</code>. The receiver ignores a tombstone for a uid it doesn't hold, so no roster doc is ever created for someone never granted.</td></tr>
99:<tr><td>Tombstones (stored)</td><td>Replace the document. <code>members</code>: the last stored snapshot fields <strong>minus <code>email</code>, <code>emailLower</code> and <code>phoneLast4</code></strong> (Q7), plus <code>{memberId, firstName, lastInitial, tombstone:true, status:'removed', statusDate, sourceReadTime, updatedAt}</code>; if nothing was ever stored for that memberId, only those last fields. <code>memberProfiles</code>: <code>{memberId, tombstone:true, status:'removed', updatedAt}</code>. <code>staffRoster</code>: <code>{uid, tombstone:true, sourceReadTime, updatedAt}</code>. A later live record replaces it with the full allowlist again. (Vault copies taken earlier keep the email and phone digits until the 56-day retention ages them out — noted in DATA-RESTORE.)</td></tr>
108:<tr><td><code>ingestMemberUpdate</code></td><td>my-clay-hub / <code>members</code></td><td>https; invoker <code>[clayhub-link@tinker-hq-apps…]</code></td><td><code>ingest@</code></td><td>120 / 512MiB / 1 / 10 / 3</td></tr>
110:<tr><td><code>onClayHubMemberWritten</code></td><td>tinker-hq-apps / <code>clayhub-link</code></td><td>firestore <code>document.written</code>, <code>clayHub_members/{docId}</code>, <code>(default)</code>, <code>nam5</code>, retry true; invoker (Q9) <code>[clayhub-link@]</code></td><td><code>clayhub-link@</code></td><td>60 / 256MiB / 1 / 1 / 5</td></tr>
111:<tr><td><code>onStaffUserWritten</code></td><td>tinker-hq-apps / <code>clayhub-link</code></td><td>firestore <code>document.written</code>, <code>users/{uid}</code>, as above</td><td><code>clayhub-link@</code></td><td>60 / 256MiB / 1 / 1 / 5</td></tr>
112:<tr><td><code>reconcileLink</code></td><td>tinker-hq-apps / <code>clayhub-link</code></td><td>schedule <code>every 6 hours from 01:15 to 19:15</code>, <code>UTC</code>; retryCount 1, maxRetrySeconds 0, minBackoffSeconds 600, maxBackoffSeconds 600, maxDoublings 0</td><td><code>clayhub-link@</code></td><td>300 / 512MiB / 1 / 1 / 1</td></tr>
117:<div class="note"><strong>Order:</strong> E-pre first, then E-0 (merged <em>and</em> its rules released before E-3/E-4 merge, because the rules guard needs its control files to match <code>main</code>). E-1, E-2 and E-3 can then proceed on separate branches; E-4 needs E-1 and E-3; E-5 before E-6. <strong>E-2 merges only when E-6 can follow within days, and after #64's vault release is attested:</strong> once <code>members/recomputeStatuses</code> is declared on <code>main</code>, any <code>vault</code> or <code>core</code> scheduler attestation fails until that job exists. <strong>E-7 onward waits for every gate</strong> (listed in E-7). Every PR: Codex + Claude implementation review, then Christie's "okay to merge". Every release: that project's guard, <code>--diff</code> pasted, Christie's "approved to change firebase &lt;sha&gt;" for that exact sha and project.</div>
128:<h3>E-0 — studio-hub: the users-rules pins <span class="status-tag ready">execution-ready: true</span></h3>
129:<p>A comment on the <code>users</code> rules naming My Clay Hub's dependency (<code>name</code>, <code>role</code>, <code>active</code>, <code>appAccess</code>). Tests only for what isn't covered (rules.test.js already pins self-granted appAccess and studios): role self-promotion on create (<code>manager</code>, <code>admin</code>), and <code>active</code> on self-update. Released through studio-hub's rules guard (free, sha phrase) <strong>before</strong> E-3 or E-4 merge.</p>
130:<div class="bdd">Given a signed-in user with no users doc
141:<p>One fixture set — source docs (every forbidden field at every nesting level; both pause spellings; <code>priorTerm</code>; processed and unprocessed pauses; malformed dates, stages, containers and memberIds, each stage-qualified; phones of every shape; users docs granted, ungranted, demoted, malformed; conflicts for <code>held</code>) and the exact envelopes and stored documents they must produce — committed byte-identical in both repos, with a test in each pinning its sha-256.</p>
147:  <li><strong><code>ingestMemberUpdate</code></strong> — <code>member</code>/<code>staff</code>: one transaction: read the target doc(s), apply the gate, derive status from the snapshot's source shape, write <code>members</code> + <code>memberProfiles</code> (or <code>staffRoster</code>), or replace them with tombstones.</li>
151:  <li><strong><code>firestore.rules</code></strong>: explicit deny-all blocks for <code>members</code>, <code>memberProfiles</code>, <code>staffRoster</code>, <code>linkOverrides</code> with rules tests (<code>linkOverrides</code> stays deny-all for every client permanently — Phase F's manager settings never reach it); released through the rules guard <em>before</em> the function.</li>
181:<h3>E-4 — studio-hub: the <code>clayhub-link</code> codebase <span class="status-tag ready">execution-ready: true</span></h3>
194:Given a users doc with role 'Manager' (wrong case) and appAccess containing 'my-clay-hub'
208:  <li><code>tinker-hq-apps</code>: <code>clayhub-link@</code>; a custom role with exactly <code>datastore.entities.get</code> and <code>datastore.entities.list</code>; grant it and <code>eventarc.eventReceiver</code>.</li>
210:  <li>After-readings: each project differs from its before-reading by exactly the recorded rows; <code>clayhub-link@</code> holds nothing in <code>my-clay-hub</code> yet. Christie opens two staff apps.</li>
216:<p>Rules first (rules guard, its own phrase); then <code>--diff --codebase members</code>, Christie's phrase, release, readings, <code>--attest</code>. Probe: an unauthenticated POST gets 403; the invoker reading shows exactly <code>clayhub-link@tinker-hq-apps</code>; <code>clayhub-link@</code> holds nothing else in <code>my-clay-hub</code> (the cheap stand-in for a live write-refusal test). No real data: the first authenticated call is E-8's first fill.</p>
224:  <li>Release right after a reconcile boundary (e.g. 07:20 UTC): <code>--diff --codebase clayhub-link</code>; Christie's phrase; release (the guard answers the retry prompt); confirm <code>deploy_verified</code>. Until E-8 step 2 the triggers' events are refused at their own services and Eventarc retries them (up to 24 h).</li>
234:  <li><strong>First fill:</strong> Force run the paused <code>reconcileLink</code> (Christie clicks; logged; first confirm in the Console that a paused job can be Force run — if not, resume it, Force run, pause again). This is the first authenticated cross-project call and the first data. Counts match Membership Manager (live members; managers/admins in <code>staffRoster</code>).</li>
235:  <li><strong>Q9</strong>: Christie grants <code>run.invoker</code> to <code>clayhub-link@</code> on the two trigger services only. Events retried since the release now run: each re-reads its source, so it lands as <code>unchanged</code> or <code>applied</code>. The trigger-service 4xx alert fired as expected from the release until this grant.</li>
251:  <li><strong>Immediately</strong> (Christie, Console): pause <code>reconcileLink</code> (and, for an integrity stop, <code>recomputeStatuses</code>); on Cloud Run <code>ingestmemberupdate</code> → Permissions, remove <code>clayhub-link@</code>'s invoker (an emergency removal is allowed; granting by hand isn't, except Q9's recorded grant). Trigger deliveries then get 403, throw, and Eventarc retries them for up to 24 h; the sender-non-2xx alert fires (at most one email per hour).</li>
261:  <li>Nothing writes to <code>tinker-hq-apps</code>: <code>clayhub-link@</code> holds only get/list; the codebase uses no write API (tested).</li>
311:<tr><td>Should-fix: 401/403 swallowed; stop runbook vs scheduler attestation; a stop cascading; the K13 failure path; Pub/Sub Token Creator; E-7 order vs attestation; E-8 proof that could pass vacuously; first-fill exemption redundant; rules port 8080 and <code>firebase.json</code>; E-0 sequencing; Netlify publish root; alert channel in tinker-hq-apps; 250-member cap; clayhub-link@ reading in my-clay-hub; phone rule</td><td>Responses row; the runbook (recompute keeps running); source-driven counting and <code>settings/linkLimits</code>; "stop and re-plan"; E-3 attestation; E-7/E-8 reordered (pause, Q9, K13, first fill, proof, then attest); evidence-based proof; exemption dropped; E-3 isolation test; E-0 first; E-4 note; E-5 step 2; settings note; E-6; <code>formatPhone</code>.</td></tr>
341:  <li><strong>Oct 8 — E-pre done:</strong> PR #13 (docs: DECISIONS #65–#73, SPEC, DATA-MODEL) merged at <code>a4b8e21</code> (head <code>ee1e5b3</code>); PR #14 (<code>deriveStatus</code> ignores an unprocessed <code>scheduledPause</code>, #70) merged at <code>3cd273a</code> (head <code>09c5f95</code>), both with Christie's "yes" to merge. Reviews: round 1 Codex (#13 merge after fixes, 2 blocking — UTC/Denver wording, #72's counting rule; #14 safe) and Claude (#13 merge after fixes, 0 blocking; #14 safe); all applied; round 2 Codex confirming on #13: safe to merge, no findings. Full suite on #14: unit 233, rules guard 199, functions guard 944, emulator 68+2+3, rules 194. Nothing released. Note: Monday's vault <code>--diff</code> will list <code>shared/</code> as changed (the guard pins it; the vault codebase doesn't use it). Next: E-0 (studio-hub users-rules pins), after Monday's V-4 finish and the #64 release.</li>

codex
The committed diff confirms no executable rules lines changed—only six comment lines plus tests. I’m now tracing every write path to a user’s own document, including the manager/admin sibling allows, and checking fixture existence and field shapes so denials aren’t vacuous.
exec
/bin/zsh -lc "sed -n '124,141p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html
sed -n '1,240p' rules.test.js
rg -n \"const (STAFF_NOACCESS_UID|MANAGER_UID|ADMIN_UID)|STAFF_NOACCESS_UID|MANAGER_UID|ADMIN_UID|users.*setDoc|users.*updateDoc|self-create|self-update|self-grant|OWN doc|own.*role|active:true|active:false\" rules.test.js" in /Users/christiehubley/studio-hub
 succeeded in 0ms:
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
/**
 * Firestore Security Rules Test Suite
 * Run: npm test
 *
 * Each test simulates a specific user type + action + collection
 * and asserts whether it should be allowed or denied.
 *
 * Users:
 *   adminUser    — role: 'admin'
 *   managerUser  — role: 'manager'
 *   staffWithKpi — role: 'staff', appAccess: ['kpi']
 *   staffNoAccess — role: 'staff', appAccess: []
 *   kioskUser    — special kiosk UID
 *   otherUser    — role: 'staff', appAccess: ['timeclock']  (used for ownership tests)
 *   classbookAdminUser — role: 'staff', appAccess: ['classbook-admin']
 *   trainingUser, otherTrainingUser — role: 'staff', appAccess: ['training']
 *   summerCampUser — role: 'staff', appAccess: ['summer-camp']
 *   archivedAdminUser — role: 'admin', active: false
 *   archivedManagerUser — role: 'manager', active: false
 *   archivedStaffUser — role: 'staff', active: false, appAccess: ['kpi','timeclock','clay-membership'], studios: ['tinker','clayhub']
 */

const { initializeTestEnvironment, assertFails, assertSucceeds } = require('@firebase/rules-unit-testing');
const { doc, getDoc, setDoc, updateDoc, deleteDoc, deleteField, increment, collection, addDoc, query, where, getDocs, runTransaction, serverTimestamp, orderBy, limit, documentId, writeBatch } = require('firebase/firestore');
const fs = require('fs');

const PROJECT_ID = 'tinker-hq-test';
const KIOSK_UID = '06ooFxutK5YTaJvu5SkywY9gZqh2';
// Tinker Ticker's 48-hour shift-reminder job (reminders@tinkerartstudio.com) — pinned by uid in isReminderBot()
const REMINDER_BOT_UID = 'JO8U8EYw2tgVBbsUXvbqNrbCPlh1';

// UIDs
const ADMIN_UID = 'admin-uid';
const MANAGER_UID = 'manager-uid';
const STAFF_KPI_UID = 'staff-kpi-uid';
const STAFF_NOACCESS_UID = 'staff-noaccess-uid';
const STAFF_TIMECLOCK_UID = 'staff-timeclock-uid';
const OTHER_TIMECLOCK_UID = 'other-timeclock-uid';
const CLASSBOOK_UID = 'classbook-uid';
const RECAP_UID = 'recap-uid';
const OTHER_RECAP_UID = 'other-recap-uid';
const CLASSBOOK_ADMIN_UID = 'classbook-admin-uid';
const TRAINING_UID = 'training-uid';
const OTHER_TRAINING_UID = 'other-training-uid';
// A third training-enabled staff user, used to prove the sharedWith MEMBERSHIP condition:
// denying someone who also lacks Training Hub access would only prove the appAccess clause.
const THIRD_TRAINING_UID = 'third-training-uid';
const SUMMER_CAMP_UID = 'summer-camp-uid';
const CURRICULUM_ADMIN_ONLY_UID = 'curriculum-admin-only-uid';   // legacy key, no 'classbook'
const ARCHIVED_CLASSBOOK_UID = 'archived-classbook-uid';
// Season-registry audience: the two users the Summer Camp App admits who are NOT
// summer-camp-access staff — a prep-role user and someone whose only grant is `team`.
const SUMMER_PREP_UID = 'summer-prep-uid';
const TEAM_ONLY_UID = 'team-only-uid';
const STAFF_ENROLLMENT_UID = 'staff-enrollment-uid';
const ARCHIVED_ADMIN_UID = 'archived-admin-uid';
const ARCHIVED_MANAGER_UID = 'archived-manager-uid';
const ARCHIVED_STAFF_UID = 'archived-staff-uid';
// Dedicated, single-use fixtures for tests whose assertSucceeds() call performs
// a REAL, persisted write against the emulator — never reused by a later test
// that expects the original state, to avoid order-dependent test pollution
// (same reasoning as this file's existing brand-new-uid/-2/-3/-4 fixtures).
const DISPOSABLE_ADMIN_FOR_ARCHIVE_UID = 'disposable-admin-for-archive-uid';
const DISPOSABLE_ARCHIVED_ADMIN_FOR_REACTIVATE_UID = 'disposable-archived-admin-for-reactivate-uid';
const DISPOSABLE_STAFF_FOR_ARCHIVE_UID = 'disposable-staff-for-archive-uid';
const DISPOSABLE_ARCHIVED_MANAGER_FOR_REACTIVATE_UID = 'disposable-archived-manager-for-reactivate-uid';

let testEnv;

beforeAll(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: PROJECT_ID,
    firestore: {
      rules: fs.readFileSync('firestore.rules', 'utf8'),
      host: 'localhost',
      port: 8080,
    },
  });

  // Seed user docs so helper functions (isAdmin, isManager, hasAppAccess) work
  await testEnv.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'users', ADMIN_UID),         { role: 'admin',   studios: ['tinker', 'clayhub'], appAccess: [] });
    await setDoc(doc(db, 'users', MANAGER_UID),        { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [] });
    await setDoc(doc(db, 'users', STAFF_KPI_UID),      { role: 'staff',   studios: ['tinker'],            appAccess: ['kpi'] });
    await setDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'staff',   studios: ['tinker'],            appAccess: [] });
    await setDoc(doc(db, 'users', STAFF_TIMECLOCK_UID),{ role: 'staff',   studios: ['tinker'],            appAccess: ['timeclock'] });
    await setDoc(doc(db, 'users', OTHER_TIMECLOCK_UID),{ role: 'staff',   studios: ['tinker'],            appAccess: ['timeclock'] });
    await setDoc(doc(db, 'users', CLASSBOOK_UID),      { role: 'staff',   studios: ['tinker'],            appAccess: ['classbook'] });
    await setDoc(doc(db, 'users', RECAP_UID),          { role: 'staff',   studios: ['tinker'],            appAccess: ['recap'] });
    await setDoc(doc(db, 'users', OTHER_RECAP_UID),    { role: 'staff',   studios: ['tinker'],            appAccess: ['recap'] });
    await setDoc(doc(db, 'users', CLASSBOOK_ADMIN_UID),{ role: 'staff',   studios: ['tinker'],            appAccess: ['classbook-admin'] });
    await setDoc(doc(db, 'users', TRAINING_UID),       { role: 'staff',   studios: ['tinker'],            appAccess: ['training'] });
    await setDoc(doc(db, 'users', OTHER_TRAINING_UID), { role: 'staff',   studios: ['tinker'],            appAccess: ['training'] });
    await setDoc(doc(db, 'users', THIRD_TRAINING_UID), { role: 'staff',   studios: ['tinker'],            appAccess: ['training'] });
    await setDoc(doc(db, 'users', SUMMER_CAMP_UID),    { role: 'staff',   studios: ['tinker'],            appAccess: ['summer-camp'] });
    await setDoc(doc(db, 'users', SUMMER_PREP_UID),    { role: 'prep',    studios: ['tinker'],            appAccess: ['summer-camp'] });
    await setDoc(doc(db, 'users', TEAM_ONLY_UID),      { role: 'staff',   studios: ['tinker'],            appAccess: ['team'] });
    await setDoc(doc(db, 'users', STAFF_ENROLLMENT_UID),{ role: 'staff',  studios: ['tinker', 'clayhub'], appAccess: ['enrollment-board'] });
    await setDoc(doc(db, 'users', ARCHIVED_ADMIN_UID),   { role: 'admin',   studios: ['tinker', 'clayhub'], appAccess: [], active: false });
    await setDoc(doc(db, 'users', ARCHIVED_MANAGER_UID), { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [], active: false });
    await setDoc(doc(db, 'users', CURRICULUM_ADMIN_ONLY_UID), { role: 'staff', studios: ['tinker'], appAccess: ['curriculum-admin'] });
    await setDoc(doc(db, 'users', ARCHIVED_CLASSBOOK_UID),    { role: 'staff', studios: ['tinker'], appAccess: ['classbook', 'classbook-admin'], active: false });
    await setDoc(doc(db, 'users', ARCHIVED_STAFF_UID),   { role: 'staff',   studios: ['tinker', 'clayhub'], appAccess: ['kpi', 'timeclock', 'clay-membership'], active: false });
    await setDoc(doc(db, 'users', DISPOSABLE_ADMIN_FOR_ARCHIVE_UID),             { role: 'admin',   studios: ['tinker', 'clayhub'], appAccess: [] });
    await setDoc(doc(db, 'users', DISPOSABLE_ARCHIVED_ADMIN_FOR_REACTIVATE_UID), { role: 'admin',   studios: ['tinker', 'clayhub'], appAccess: [], active: false });
    await setDoc(doc(db, 'users', DISPOSABLE_STAFF_FOR_ARCHIVE_UID),             { role: 'staff',   studios: ['tinker'],            appAccess: [] });
    await setDoc(doc(db, 'users', DISPOSABLE_ARCHIVED_MANAGER_FOR_REACTIVATE_UID), { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [], active: false });

    // Seed a schedule for the reminder-bot tests (read shape + the log's exists() check). Never written
    // by any test that expects it afterwards.
    await setDoc(doc(db, 'timeclock_schedules', 'reminder-sched-uid'), { name: 'Grey', recurring: {}, overrides: { '2026-10-17': { start: '10:00', end: '14:00', studio: 'tinker', remind: true, remindUid: 'reminder-sched-uid' } } });
    await setDoc(doc(db, 'timeclock_settings', 'employees'), { roster: [{ id: 'emp_1', name: 'Grey', pin: '1234', active: true }] });
    // Seed a RESOLVED claim so the "cannot touch a resolved claim" tests do not depend on order.
    await setDoc(doc(db, 'timeclock_reminder_log', 'reminder-sched-uid_2026-10-01'), { uid: 'reminder-sched-uid', date: '2026-10-01', to: 'grey@example.com', shift: { start: '10:00', end: '14:00', studio: 'tinker', note: '' }, claimedAt: new Date(), sentAt: new Date(), attempts: 1 });
    // Seed a timeclock entry owned by STAFF_TIMECLOCK_UID
    await setDoc(doc(db, 'timeclock_entries', 'my-entry'),    { uid: STAFF_TIMECLOCK_UID, type: 'clockIn' });
    // Seed a timeclock entry owned by OTHER_TIMECLOCK_UID
    await setDoc(doc(db, 'timeclock_entries', 'other-entry'), { uid: OTHER_TIMECLOCK_UID, type: 'clockIn' });
    // Seed a timeclock entry owned by ARCHIVED_STAFF_UID, so the archive-feature
    // read-denial test below isolates the hasAppAccess() isActiveUser gate —
    // without this, reading someone else's entry would be denied by the
    // resource.data.uid == request.auth.uid ownership check instead, proving
    // nothing about the archive feature.
    await setDoc(doc(db, 'timeclock_entries', 'archived-staff-entry'), { uid: ARCHIVED_STAFF_UID, type: 'clockIn' });
    // Seed a timeclock entry inside a period that is marked locked below
    await setDoc(doc(db, 'timeclock_entries', 'locked-period-entry'), {
      uid: STAFF_TIMECLOCK_UID, type: 'clockIn', date: '2026-01-05',
    });
    // Mark a pay period locked (mirrors the shape written by lockPayPeriod()
    // in tinker-timeclock/js/firebase-data.js)
    await setDoc(doc(db, 'timeclock_settings', 'lockedPeriods'), {
      '2026-01-01_2026-01-14': { lockedAt: '2026-01-15T00:00:00.000Z', lockedBy: 'manager', employeeTotals: {} },
    });

    // Training Hub fixtures
    await setDoc(doc(db, 'trainingModules', 'module-1'), { title: 'Kiln Safety' });
    await setDoc(doc(db, 'trainingAssignments', 'assign-1'), { memberId: TRAINING_UID, moduleId: 'module-1' });
    await setDoc(doc(db, 'trainingObservations', 'obs-1'), { memberId: TRAINING_UID, notes: 'Great session', status: 'published' });
    // A manager's in-progress draft about the same staff member. Drafts are unfinished,
    // unreviewed notes — the staff member must not be able to read one, even their own.
    await setDoc(doc(db, 'trainingObservations', 'obs-draft'), { memberId: TRAINING_UID, notes: 'Unfinished growth notes', status: 'draft' });
    // A legacy record with no status field at all, modelling a document written before
    // status was enforced. Staff must fail CLOSED on it; the manager must NOT be locked out.
    await setDoc(doc(db, 'trainingObservations', 'obs-nostatus'), { memberId: TRAINING_UID, notes: 'Legacy note, no status' });
    // Another member's draft, so the cross-member case is covered for drafts too.
    await setDoc(doc(db, 'trainingObservations', 'obs-other-draft'), { memberId: OTHER_TRAINING_UID, notes: 'About someone else', status: 'draft' });
    // Shared with a non-manager coordinator (TRAINING_UID) -- a record about someone else.
    await setDoc(doc(db, 'trainingObservations', 'obs-shared'), {
      memberId: OTHER_TRAINING_UID, notes: 'Clay Hub teacher observation', status: 'published',
      sharedWith: [TRAINING_UID]
    });
    // A DRAFT carrying a sharedWith list: must stay unreadable even by the named person.
    await setDoc(doc(db, 'trainingObservations', 'obs-shared-draft'), {
      memberId: OTHER_TRAINING_UID, notes: 'Unfinished', status: 'draft',
      sharedWith: [TRAINING_UID]
    });
    // sharedWith written as a MAP. `in` tests map keys in rules, so without an `is list`
    // guard this would grant THIRD_TRAINING_UID a read of someone else's observation.
    await setDoc(doc(db, 'trainingObservations', 'obs-shared-map'), {
      memberId: OTHER_TRAINING_UID, notes: 'Malformed share list', status: 'published',
      sharedWith: { [THIRD_TRAINING_UID]: true }
    });
    // sharedWith as a bare string — another non-list shape that must fail closed.
    await setDoc(doc(db, 'trainingObservations', 'obs-shared-string'), {
      memberId: OTHER_TRAINING_UID, notes: 'Malformed share list', status: 'published',
      sharedWith: THIRD_TRAINING_UID
    });
    await setDoc(doc(db, 'onboardingChecklists', 'checklist-1'), {
      personId: 'person-1', backgroundCheckSent: true, campSafeSent: false,
    });
    await setDoc(doc(db, 'onboardingPeople', 'person-1'), { name: 'New Hire' });

    // Summer Camp fixtures (shared curriculum + kid notes)
    await setDoc(doc(db, 'summerCamps_curriculum', 'week-1'), { title: 'Week 1' });
    await setDoc(doc(db, 'summerCamps_kidNotes', 'kid-1'), { name: 'Kid One', notes: [] });
    await setDoc(doc(db, 'summerCamps_prepHelpQueue', 'queue-1'), { item: 'Glaze' });
    // Season registry (summer-camp-app-seasons Phase 1 §1.1): one doc per summer, plus the
    // single fixed _current doc. Read at startup by every active user, whatever their access.
    await setDoc(doc(db, 'summerCamps_seasons', '2026'), {
      season: '2026', name: 'Summer 2026',
      startDate: '2026-05-26', endDate: '2026-08-11', numWeeks: 11,
    });
    await setDoc(doc(db, 'summerCamps_seasons', '_current'), { season: '2026' });
    // Only ever deleted by the manager delete test — nothing else may depend on it.
    await setDoc(doc(db, 'summerCamps_seasons', 'disposable-for-delete'), { season: '1999' });

    // Seed a personal recap meeting owned by RECAP_UID
    await setDoc(doc(db, 'meetings', 'personal-meeting'), {
      createdBy: RECAP_UID,
      business: 'personal',
      title: 'Private note',
    });
    // Seed a non-personal recap meeting (no sharedWith field at all — also covers
    // the "missing sharedWith doesn't error" case and the "unshared, not readable
    // by a non-manager staff member" case)
    await setDoc(doc(db, 'meetings', 'team-meeting'), {
      createdBy: RECAP_UID,
      business: 'tinker',
      title: 'Team standup',
    });
    // Seed a non-personal recap meeting shared with OTHER_RECAP_UID
    await setDoc(doc(db, 'meetings', 'shared-meeting'), {
      createdBy: RECAP_UID,
      business: 'tinker',
      title: 'Shared standup',
      sharedWith: [OTHER_RECAP_UID],
    });
    // Seed a non-personal recap meeting owned by OTHER_RECAP_UID, for update-rule
    // bypass tests (a manager attempting to flip someone else's meeting to personal)
    await setDoc(doc(db, 'meetings', 'other-recap-meeting'), {
      createdBy: OTHER_RECAP_UID,
      business: 'tinker',
      title: 'Owned by other recap user',
      sharedWith: [],
    });
    // Seed a legacy personal meeting created by a NON-admin (the exact pre-existing
    // gap this rule closes for create, but must not regress for update/read/delete)
    await setDoc(doc(db, 'meetings', 'legacy-personal-meeting'), {
      createdBy: RECAP_UID,
      business: 'personal',
      title: 'Legacy personal note, non-admin creator',
      sharedWith: [],
    });

    // ── Phase 3 fixtures (shared users can tick off action items) ──
    // A shared, non-personal meeting WITH a summary, so the shared-user update
    // branch's nested diff has something to compare against. Only ever used for
    // writes that must be DENIED — a successful write would mutate it for later
    // tests, so those seed a disposable document instead.
    await setDoc(doc(db, 'meetings', 'shared-meeting-with-tasks'), {
      createdBy: RECAP_UID,
      business: 'tinker',
      title: 'Shared ops sync',
      sharedWith: [OTHER_RECAP_UID],
      summary: {
        beforeNextMeeting: [{ assignee: 'Maryssa', items: [{ text: 'Draft the doc', done: false }] }],
        keyDiscussion: ['unrelated'],
        decisionsLog: ['decided'],
      },
33:const ADMIN_UID = 'admin-uid';
34:const MANAGER_UID = 'manager-uid';
36:const STAFF_NOACCESS_UID = 'staff-noaccess-uid';
42:const CLASSBOOK_ADMIN_UID = 'classbook-admin-uid';
56:const ARCHIVED_ADMIN_UID = 'archived-admin-uid';
57:const ARCHIVED_MANAGER_UID = 'archived-manager-uid';
83:    await setDoc(doc(db, 'users', ADMIN_UID),         { role: 'admin',   studios: ['tinker', 'clayhub'], appAccess: [] });
84:    await setDoc(doc(db, 'users', MANAGER_UID),        { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [] });
86:    await setDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'staff',   studios: ['tinker'],            appAccess: [] });
92:    await setDoc(doc(db, 'users', CLASSBOOK_ADMIN_UID),{ role: 'staff',   studios: ['tinker'],            appAccess: ['classbook-admin'] });
100:    await setDoc(doc(db, 'users', ARCHIVED_ADMIN_UID),   { role: 'admin',   studios: ['tinker', 'clayhub'], appAccess: [], active: false });
101:    await setDoc(doc(db, 'users', ARCHIVED_MANAGER_UID), { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [], active: false });
286:    const db = getDb(MANAGER_UID);
291:    const db = getDb(ADMIN_UID);
301:    const db = getDb(STAFF_NOACCESS_UID);
311:    const db = getDb(STAFF_NOACCESS_UID);
316:    const db = getDb(MANAGER_UID);
321:    const db = getDb(STAFF_NOACCESS_UID);
401:    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
406:    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
411:    const db = getDb(ADMIN_UID, ADMIN_EMAIL);
426:    const db = getDb(ARCHIVED_MANAGER_UID, 'archived@tinkerartstudio.com');
432:    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
437:    const db = getDb(ADMIN_UID, ADMIN_EMAIL);
442:    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
447:    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
455:    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
467:    const db = getDb(ARCHIVED_MANAGER_UID, 'archived@tinkerartstudio.com');
472:    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
477:    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
482:    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
487:    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
492:    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
506:    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
511:    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
516:    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
522:    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
527:    const db = getDb(MANAGER_UID, MANAGER_EMAIL);
532:    const db = getDb(ADMIN_UID, ADMIN_EMAIL);
547:    const db = getDb(STAFF_NOACCESS_UID);
552:    const db = getDb(MANAGER_UID);
565:    const db = getDb(ADMIN_UID);
570:    const db = getDb(MANAGER_UID);
575:    const db = getDb(ADMIN_UID);
585:    const db = getDb(STAFF_NOACCESS_UID);
590:    const db = getDb(STAFF_NOACCESS_UID);
605:    const db = getDb(ADMIN_UID);
616:    const db = getDb(STAFF_NOACCESS_UID);
637:    const db = getDb(MANAGER_UID);
697:    const db = getDb(STAFF_NOACCESS_UID);
744:    const db = getDb(MANAGER_UID);
771:    const db = getDb(CLASSBOOK_ADMIN_UID);
776:    const db = getDb(MANAGER_UID);
801:// Fix applied in this pass: the self-create/self-update rules previously
810:describe('Users — appAccess/studios cannot be self-granted (privilege escalation fix)', () => {
811:  test('staff CANNOT self-update to add appAccess entries', async () => {
812:    const db = getDb(STAFF_NOACCESS_UID);
813:    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
818:  test('staff CANNOT self-update to change studios', async () => {
819:    const db = getDb(STAFF_NOACCESS_UID);
820:    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
825:  test('staff CAN still self-update unrelated fields (no regression)', async () => {
826:    const db = getDb(STAFF_NOACCESS_UID);
827:    await assertSucceeds(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
833:  test('a brand-new user CANNOT self-create with appAccess already populated', async () => {
841:  test('a brand-new user CANNOT self-create with a studio outside the known set', async () => {
849:  test('a brand-new user CAN self-create with no appAccess/studios (bootstrap)', async () => {
871:    const db = getDb(ADMIN_UID);
872:    await assertSucceeds(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
884:  // studios:['tinker'] only could have self-granted 'clayhub' this way.
885:  test('manager CANNOT self-grant studios via the manager-update rule (regression)', async () => {
886:    const db = getDb(MANAGER_UID);
887:    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), {
892:  test('manager CANNOT self-grant appAccess via the manager-update rule (regression)', async () => {
893:    const db = getDb(MANAGER_UID);
894:    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), {
900:    const db = getDb(MANAGER_UID);
901:    await assertSucceeds(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
909:// ─── USERS — ARCHIVE FEATURE: active:false revokes access everywhere ────────
914:// may set their own role, active or appAccess. appAccess/studios self-grants are pinned above and
917:  test('a brand-new user CANNOT self-create as manager', async () => {
922:  test('a brand-new user CANNOT self-create as admin', async () => {
927:  test('staff CANNOT self-update their role to manager or admin', async () => {
928:    const db = getDb(STAFF_NOACCESS_UID);
929:    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'manager' }));
930:    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'admin' }));
933:  test('staff CANNOT self-update active (setting it where it was absent, either way)', async () => {
934:    const db = getDb(STAFF_NOACCESS_UID);
935:    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { active: true }));
936:    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { active: false }));
939:  test('a manager CANNOT self-update their own active or role', async () => {
940:    const db = getDb(MANAGER_UID);
941:    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), { active: false }));
942:    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), { role: 'admin' }));
946:describe('Users — active:false revokes access everywhere (Archive Employees feature)', () => {
948:    const db = getDb(ARCHIVED_ADMIN_UID);
967:  test('archived user CAN lightly self-update an unrelated field; active stays false (pinned, unchanged)', async () => {
974:  test('archived staff CANNOT self-write active:true (no self-reactivation)', async () => {
981:  test('manager CANNOT archive an admin (write active:false to an active admin doc)', async () => {
982:    const db = getDb(MANAGER_UID);
983:    await assertFails(updateDoc(doc(db, 'users', ADMIN_UID), {
988:  test('manager CANNOT reactivate an admin (write active:true to an archived admin doc)', async () => {
989:    const db = getDb(MANAGER_UID);
990:    await assertFails(updateDoc(doc(db, 'users', ARCHIVED_ADMIN_UID), {
996:    const db = getDb(MANAGER_UID);
1003:    const db = getDb(MANAGER_UID);
1010:  // `allow write: if isAdmin();` sits outside the self-update rule's
1013:  // recovery path — same bug shape as the manager self-grant regression
1015:  test('admin CANNOT write active:false to their OWN doc via any rule path (self-lockout prevention)', async () => {
1016:    const db = getDb(ADMIN_UID);
1017:    await assertFails(updateDoc(doc(db, 'users', ADMIN_UID), {
1022:  test('admin CAN write active:false to ANOTHER admin doc (archiving admins stays possible)', async () => {
1023:    const db = getDb(ADMIN_UID);
1029:  test('admin CAN write active:true to ANOTHER admin doc (reactivating admins stays possible)', async () => {
1030:    const db = getDb(ADMIN_UID);
1045:    const db = getDb(ARCHIVED_MANAGER_UID);
1050:    const adminDb = getDb(ADMIN_UID);
1067:    const db = getDb(MANAGER_UID);
1082:    const db = getDb(MANAGER_UID);
1107:    const db = getDb(MANAGER_UID);
1183:    await assertSucceeds(getDoc(doc(getDb(MANAGER_UID), 'trainingObservations', 'obs-shared-map')));
1195:    await assertFails(updateDoc(doc(db, 'trainingObservations', 'obs-shared'), { sharedWith: [TRAINING_UID, STAFF_NOACCESS_UID] }));
1247:    const db = getDb(MANAGER_UID);
1264:    const db = getDb(MANAGER_UID);
1308:    const db = getDb(MANAGER_UID);
1329:    const db = getDb(MANAGER_UID);
1347:    const db = getDb(STAFF_NOACCESS_UID);
1362:    ['admin', () => ADMIN_UID],
1363:    ['manager', () => MANAGER_UID],
1371:    ['staff with classbook-admin access', () => CLASSBOOK_ADMIN_UID],
1382:    const db = getDb(STAFF_NOACCESS_UID);
1398:    ['an archived admin', () => ARCHIVED_ADMIN_UID],
1399:    ['an archived manager', () => ARCHIVED_MANAGER_UID],
1401:  ])('%s cannot read the registry (active:false revokes it like everything else)', async (_label, uid) => {
1414:    const db = getDb(MANAGER_UID);
1421:    const db = getDb(ADMIN_UID);
1430:    ['staff with classbook-admin access', () => CLASSBOOK_ADMIN_UID],
1431:    ['staff with no appAccess at all', () => STAFF_NOACCESS_UID],
1432:    ['an archived manager', () => ARCHIVED_MANAGER_UID],
1441:    for (const uid of [SUMMER_CAMP_UID, SUMMER_PREP_UID, TEAM_ONLY_UID, CLASSBOOK_ADMIN_UID]) {
1460:    const db = getDb(MANAGER_UID);
1466:    const db = getDb(MANAGER_UID);
1471:    const db = getDb(MANAGER_UID);
1477:    const db = getDb(MANAGER_UID);
1482:    const db = getDb(MANAGER_UID);
1490:    const db = getDb(MANAGER_UID);
1495:    const db = getDb(MANAGER_UID);
1500:    const db = getDb(MANAGER_UID);
1539:      const db = getDb(ADMIN_UID);
1545:    const db = getDb(ADMIN_UID);
1550:    const db = getDb(ADMIN_UID);
1571:    const db = getDb(MANAGER_UID);
1597:    const db = getDb(MANAGER_UID);
1602:    const db = getDb(MANAGER_UID);
1624:    const db = getDb(ADMIN_UID);
1629:    const db = getDb(ADMIN_UID);
1643:    const db = getDb(MANAGER_UID);
1645:      createdBy: MANAGER_UID, business: 'personal', title: 'Should fail',
1650:    const db = getDb(ADMIN_UID);
1652:      createdBy: ADMIN_UID, business: 'personal', title: 'Should succeed',
1664:    const db = getDb(MANAGER_UID);
1885:    const db = getDb(MANAGER_UID);
1949:    const db = getDb(MANAGER_UID);
1951:      sharedWith: [OTHER_RECAP_UID], sharedByUid: MANAGER_UID, sharedByName: 'Manager', sharedAt: '2026-09-11T00:00:00Z',
1974:    const db = getDb(MANAGER_UID);
1976:      createdBy: MANAGER_UID, business: 'tinker', title: 'Pre-shared by manager', sharedWith: [OTHER_RECAP_UID],
1981:    await seedDisposableSharedMeeting('disposable-phase3-manager-own-share', { createdBy: MANAGER_UID, sharedWith: [] });
1982:    const db = getDb(MANAGER_UID);
2033:    // …and not even the minimal shape the self-create rule would otherwise allow.
2043:    const admin = getDb(ADMIN_UID);
2202:    await assertSucceeds(getDoc(doc(getDb(MANAGER_UID), ...seeded)));
2203:    await assertSucceeds(getDocs(collection(getDb(ADMIN_UID), 'timeclock_reminder_log')));
2207:    await assertFails(getDoc(doc(getDb(ARCHIVED_MANAGER_UID), ...seeded)));
2209:    for (const uid of [MANAGER_UID, ADMIN_UID, STAFF_TIMECLOCK_UID, KIOSK_UID]) {
2224:const SDOC_ADMIN_WRITERS = [['admin', ADMIN_UID], ['manager', MANAGER_UID], ['classbook-admin', CLASSBOOK_ADMIN_UID]];
2226:  ['summer-camp staff', SUMMER_CAMP_UID], ['no-access staff', STAFF_NOACCESS_UID],
2227:  ['archived admin', ARCHIVED_ADMIN_UID], ['archived manager', ARCHIVED_MANAGER_UID], ['archived staff', ARCHIVED_STAFF_UID],
2230:  // Holds both classbook keys: only the active:false gate can deny it.
2300:    const db = getDb(ADMIN_UID);
2365:    const db = getDb(MANAGER_UID);
2372:        sharedByUid: MANAGER_UID, sharedByName: 'A Manager', sharedAt: '2026-09-23T21:00:00.000Z',
2402:// {isAdmin:true, active:true} (no field pins) and so become a Booking admin. The block is
2411:const CLAY_NO_USERS_DOC_UID = 'clay-no-users-doc-uid'; // signed in, no users doc, never self-creates
2478:    ['an admin', () => getDb(ADMIN_UID)],
2519:  test.each([['Clay Hub staff', CLAY_MEMBERSHIP_STAFF_UID], ['a manager', MANAGER_UID], ['an admin', ADMIN_UID]])(
2529:  test.each([['Clay Hub staff', CLAY_MEMBERSHIP_STAFF_UID], ['a manager', MANAGER_UID], ['an admin', ADMIN_UID]])(
2536:    await assertFails(setDoc(doc(getDb(ADMIN_UID), 'clayHub_members', RETIRED), { email: 'old@example.com', memberId: 'm_old' }));
2574:    await assertSucceeds(deleteDoc(doc(getDb(MANAGER_UID), 'clayHub_members', NO_ID)));
2593:    const db = getDb(MANAGER_UID);
2614:    const db = getDb(STAFF_NOACCESS_UID);
2639:  ['classbook-admin', CLASSBOOK_ADMIN_UID],
2641:  ['manager', MANAGER_UID],
2642:  ['admin', ADMIN_UID],
2818:    await assertSucceeds(updateDoc(doc(getDb(CLASSBOOK_ADMIN_UID), 'curriculum', 'prepCycleConfig'), { a: 2 }));
2826:    await assertFails(getDoc(doc(getDb(STAFF_NOACCESS_UID), 'curriculum', 'cutProjects')));
2827:    await assertFails(updateDoc(doc(getDb(STAFF_NOACCESS_UID), 'curriculum', 'lessonData'), { 'fall-2026.x': {} }));
2868:    await assertSucceeds(runMove(getDb(MANAGER_UID)));
2871:    await assertFails(updateDoc(doc(getDb(MANAGER_UID), 'curriculum', 'lessonData'), { 'spring-2027.teacher-class-1': { teacher: 'X' } }));
3019:    await assertSucceeds(updateDoc(doc(getDb(MANAGER_UID), 'curriculum', 'lessonData'), { qaData: deleteField() }));
3020:    await assertFails(updateDoc(doc(getDb(MANAGER_UID), 'curriculum', 'lessonData'), { qaData: { a: 1 } }));
3036:    await assertSucceeds(setDoc(doc(getDb(MANAGER_UID), 'curriculum', 'lessonData'), { lastUpdated: 'n', lastUpdatedBy: 'm' }));
3090:    await assertSucceeds(setDoc(doc(getDb(MANAGER_UID), 'curriculum', NEW_DOC), { ...newSemMap(), lastUpdated: 'n' }));
3104:    await assertFails(updateDoc(doc(getDb(MANAGER_UID), 'curriculum', NEW_DOC), { 'mariah-tuesday-1.projectTitle': 'x' }));
3106:    await assertFails(setDoc(doc(getDb(MANAGER_UID), 'curriculum', NEW_DOC), newSemMap()));
3110:    const db = getDb(MANAGER_UID);
3117:    await assertSucceeds(setDoc(doc(getDb(MANAGER_UID), 'curriculum', FALL_DOC), { lastUpdated: 'n' }));
3148:    const db = getDb(STAFF_NOACCESS_UID);
3206:    await assertSucceeds(deleteDoc(doc(getDb(CLASSBOOK_ADMIN_UID), 'curriculum', id)));
3211:    await assertSucceeds(runCreateSemester(getDb(MANAGER_UID), { key }));
3227:  const SELF = STAFF_NOACCESS_UID;
3230:  const KIOSK_MANAGER_UID = 'kiosk-manager-uid';          // distinct uid: a manager doc on KIOSK_UID would flip the timeclock kiosk tests
3248:      await setDoc(doc(db, 'users', KIOSK_MANAGER_UID), { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [] });
3257:      await setDoc(doc(db, COL, SUMMARY_UID), summary(MANAGER_UID));
3300:    await assertFails(getDoc(doc(mailDb(ARCHIVED_MANAGER_UID), COL, '_summary')));
3301:    await assertFails(getDocs(collection(mailDb(ARCHIVED_MANAGER_UID), COL)));
3313:    const db = getDb(KIOSK_MANAGER_UID, 'kiosk2@tinkerartstudio.com');
3318:    await assertFails(setDoc(doc(db, COL, '_summary'), summary(KIOSK_MANAGER_UID)));
3321:    for (const uid of [MANAGER_UID, ADMIN_UID]) {
3347:    for (const uid of [MANAGER_UID, ADMIN_UID]) {
3355:    await assertSucceeds(setDoc(doc(mailDb(MANAGER_UID), COL, 'minimal-uid'), { name: 'Min', current: true, updatedAt: NOW }));
3358:    await assertSucceeds(setDoc(doc(mailDb(MANAGER_UID), COL, OTHER), leaver()));
3361:    const db = mailDb(MANAGER_UID);
3383:    ['a summary shape written at a uid',   summary(MANAGER_UID)],
3385:    await assertFails(setDoc(doc(mailDb(MANAGER_UID), COL, 'shape-test-uid'), data));
3390:    ['a foreign updatedBy',                summary(ADMIN_UID)],
3391:    ['a missing checkedAt',                (() => { const s = summary(MANAGER_UID); delete s.checkedAt; return s; })()],
3392:    ['a non-list staff',                   summary(MANAGER_UID, { staff: { a: 1 } })],
3393:    ['a 301-item staff list',              summary(MANAGER_UID, { staff: Array.from({ length: 301 }, (_, i) => ({ id: `row-${i}` })) })],
3394:    ['an extra top-level field',           summary(MANAGER_UID, { note: 'x' })],
3395:    ['a non-ISO checkedAt',                summary(MANAGER_UID, { checkedAt: 'today' })],
3398:    await assertFails(setDoc(doc(mailDb(MANAGER_UID), COL, '_summary'), data));
3403:    for (const uid of [ADMIN_UID, MANAGER_UID, SELF]) {

exec
/bin/zsh -lc "sed -n '270,335p' rules.test.js
sed -n '795,910p' rules.test.js
sed -n '940,1088p' rules.test.js
nl -ba firestore.rules | sed -n '106,190p'
nl -ba rules.test.js | sed -n '805,1038p'" in /Users/christiehubley/studio-hub
 succeeded in 0ms:
  await testEnv.cleanup();
});

// Helper: get an authenticated Firestore context
function getDb(uid, email) {
  return testEnv.authenticatedContext(uid, email ? { email } : {}).firestore();
}
function getUnauthDb() {
  return testEnv.unauthenticatedContext().firestore();
}


// ─── FINANCE — HARD LOCKED ───────────────────────────────────────────────────

describe('Finance — payroll + bookkeeping', () => {
  test('manager can read payroll', async () => {
    const db = getDb(MANAGER_UID);
    await assertSucceeds(getDoc(doc(db, 'payroll', 'some-doc')));
  });

  test('admin can read payroll', async () => {
    const db = getDb(ADMIN_UID);
    await assertSucceeds(getDoc(doc(db, 'payroll', 'some-doc')));
  });

  test('staff WITH kpi access cannot read payroll', async () => {
    const db = getDb(STAFF_KPI_UID);
    await assertFails(getDoc(doc(db, 'payroll', 'some-doc')));
  });

  test('staff with NO access cannot read payroll', async () => {
    const db = getDb(STAFF_NOACCESS_UID);
    await assertFails(getDoc(doc(db, 'payroll', 'some-doc')));
  });

  test('unauthenticated user cannot read payroll', async () => {
    const db = getUnauthDb();
    await assertFails(getDoc(doc(db, 'payroll', 'some-doc')));
  });

  test('staff cannot read bookkeeping', async () => {
    const db = getDb(STAFF_NOACCESS_UID);
    await assertFails(getDoc(doc(db, 'bookkeeping', 'some-doc')));
  });

  test('manager can write payroll', async () => {
    const db = getDb(MANAGER_UID);
    await assertSucceeds(setDoc(doc(db, 'payroll', 'test-write'), { amount: 100 }));
  });

  test('staff cannot write payroll', async () => {
    const db = getDb(STAFF_NOACCESS_UID);
    await assertFails(setDoc(doc(db, 'payroll', 'test-write'), { amount: 100 }));
  });
});


// ─── FINANCE — PAYROLL SETTINGS HISTORY (append-only, transaction-tied) ──────
// payroll/appData/settingsHistory/{histId}: a recovery log for the Payroll
// Tool's settings. Manager+ may read and create; nobody may update or delete.
// Every entry must be created inside the same transaction that writes the
// parent's new settingsRev (getAfter tie), carry the caller's own email and a
// server timestamp, and have exactly the declared shape.
// Plan: ~/tinker-ai-configs/thoughts/plans/payroll-settings-safety-and-seasons.html (Phase 1)

const MANAGER_EMAIL = 'manager@tinkerartstudio.com';
    await assertSucceeds(updateDoc(doc(db, 'curriculum', 'spring-2026'), { touchedBy: 'someone-elses-teacher' }));
  });
});


// ─── USERS — PRIVILEGE ESCALATION VIA SELF-WRITE (FIX APPLIED) ──────────────
// Fix applied in this pass: the self-create/self-update rules previously
// pinned only the `role` field. `appAccess` and `studios` were completely
// unprotected, so any authenticated staff user could grant themselves access
// to nearly every app on the platform (KPI, Classbook, Training, Roster
// Manager, Summer Camp, Clay Hub, Social Media, Playbook, etc.) with a
// direct Firestore write that bypasses the Manage Team UI entirely. Payroll
// and bookkeeping were never reachable this way (they gate on role, not
// appAccess, and role was already protected) but everything else was.

describe('Users — appAccess/studios cannot be self-granted (privilege escalation fix)', () => {
  test('staff CANNOT self-update to add appAccess entries', async () => {
    const db = getDb(STAFF_NOACCESS_UID);
    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
      appAccess: ['classbook-admin', 'payroll', 'training'],
    }));
  });

  test('staff CANNOT self-update to change studios', async () => {
    const db = getDb(STAFF_NOACCESS_UID);
    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
      studios: ['tinker', 'clayhub'],
    }));
  });

  test('staff CAN still self-update unrelated fields (no regression)', async () => {
    const db = getDb(STAFF_NOACCESS_UID);
    await assertSucceeds(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
      name: 'Updated Name',
      pin: '4321',
    }));
  });

  test('a brand-new user CANNOT self-create with appAccess already populated', async () => {
    const db = getDb('brand-new-uid');
    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid'), {
      role: 'staff',
      appAccess: ['classbook-admin'],
    }));
  });

  test('a brand-new user CANNOT self-create with a studio outside the known set', async () => {
    const db = getDb('brand-new-uid-2');
    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-2'), {
      role: 'staff',
      studios: ['tinker', 'some-future-privileged-studio'],
    }));
  });

  test('a brand-new user CAN self-create with no appAccess/studios (bootstrap)', async () => {
    const db = getDb('brand-new-uid-3');
    await assertSucceeds(setDoc(doc(db, 'users', 'brand-new-uid-3'), {
      role: 'staff',
      name: 'New Hire',
    }));
  });

  test('the real bootstrap write shape succeeds: role staff, appAccess [], studios [tinker, clayhub]', async () => {
    // Mirrors js/app.js handleAuthStateChange()'s default-user-doc write exactly.
    const db = getDb('brand-new-uid-4');
    await assertSucceeds(setDoc(doc(db, 'users', 'brand-new-uid-4'), {
      name: 'New Hire',
      email: 'newhire@tinkerartstudio.com',
      role: 'staff',
      studios: ['tinker', 'clayhub'],
      appAccess: [],
      createdAt: '2026-08-11T00:00:00.000Z',
    }));
  });

  test('admin can still grant appAccess to another user', async () => {
    const db = getDb(ADMIN_UID);
    await assertSucceeds(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
      appAccess: ['kpi'],
    }));
  });

  // Regression test for a gap found by independent second-model review:
  // the separate "Manager update" rule (isManager() && role unchanged) had
  // no request.auth.uid != userId guard, so a manager writing to THEIR OWN
  // doc satisfied it too — bypassing the appAccess/studios pins above
  // entirely, since Firestore ORs sibling `allow update` rules together.
  // Concretely exploitable: belongsToStudio() (gating clayHub_*/rosterManager/
  // clayInventory) doesn't accept isManagerOrAbove(), so a manager scoped to
  // studios:['tinker'] only could have self-granted 'clayhub' this way.
  test('manager CANNOT self-grant studios via the manager-update rule (regression)', async () => {
    const db = getDb(MANAGER_UID);
    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), {
      studios: ['tinker', 'clayhub', 'some-future-privileged-studio'],
    }));
  });

  test('manager CANNOT self-grant appAccess via the manager-update rule (regression)', async () => {
    const db = getDb(MANAGER_UID);
    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), {
      appAccess: ['payroll'],
    }));
  });

  test('manager CAN still grant appAccess/studios to ANOTHER user (legitimate team management, unaffected by the fix)', async () => {
    const db = getDb(MANAGER_UID);
    await assertSucceeds(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
      appAccess: ['training'],
      studios: ['tinker', 'clayhub'],
    }));
  });
});


// ─── USERS — ARCHIVE FEATURE: active:false revokes access everywhere ────────
// BDD scenarios from thoughts/plans/archive-employees.html, Phase 1.
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

  test('staff cannot create/write an observation record about themselves (manager-authored only)', async () => {
    const db = getDb(TRAINING_UID);
    await assertFails(setDoc(doc(db, 'trainingObservations', 'obs-2'), { memberId: TRAINING_UID, notes: 'self-authored' }));
   106	    // Self-update: role field must not change.
   107	    // Manager update: cannot change role field, cannot delete.
   108	    // Admin: full create / update / delete.
   109	    // ═══════════════════════════════════════════════════════════════
   110	
   111	    match /users/{userId} {
   112	      // My Clay Hub depends on these (Phase E): the clayhub-link functions copy each users doc's
   113	      // name, role, active and appAccess to my-clay-hub's staffRoster, which decides who can use
   114	      // its /staff screens. So a person must never be able to set their own role, active or
   115	      // appAccess (name is self-editable and is display-only there). Pinned by rules.test.js
   116	      // "Users — fields My Clay Hub relies on"; loosening any of them changes who is staff in
   117	      // My Clay Hub too.
   118	      // Own doc read — all authenticated users (auth guard requires it). Not the reminder bot: its
   119	      // grant is GET-only below, and this `read` would let an id-constrained LIST through.
   120	      allow read: if isAuthenticated() && request.auth.uid == userId && !isReminderBot();
   121	      // Manager+ reads all user docs (team filters, admin panels, etc.)
   122	      allow read: if isManagerOrAbove();
   123	      // Kiosk: read all users (for PIN lookup)
   124	      allow read: if isKiosk();
   125	      // Reminder bot: GET one doc by uid (the account it is about to email) — never a list.
   126	      allow get: if isReminderBot();
   127	
   128	      // Self-create: role must be 'staff' (prevents self-promotion), and
   129	      // appAccess must be absent or empty — app access is granted by an
   130	      // admin/manager via Manage Team, never by the user themselves.
   131	      // studios is NOT locked to empty here: the real bootstrap write (see
   132	      // js/app.js handleAuthStateChange) always sets studios: ['tinker',
   133	      // 'clayhub'] — both known studios, granted to every new user by
   134	      // default — so hasOnly() permits exactly that shape while still
   135	      // blocking a self-create from injecting any value outside the two
   136	      // known studios (there's no smaller "safe default" to enforce here
   137	      // since the app already grants both to everyone; appAccess is the
   138	      // field that actually gates privilege).
   139	      // The reminder bot is a job, not a person: it can never bootstrap a users doc for itself, so it
   140	      // can never become "an active staff user" to isActiveUser()/hasAppAccess().
   141	      allow create: if isAuthenticated()
   142	        && request.auth.uid == userId
   143	        && !isReminderBot()
   144	        && request.resource.data.role == 'staff'
   145	        && (!('appAccess' in request.resource.data) || request.resource.data.appAccess.size() == 0)
   146	        && (!('studios' in request.resource.data) || request.resource.data.studios.hasOnly(['tinker', 'clayhub']));
   147	
   148	      // Self-update: role, appAccess, and studios must not change.
   149	      // Without pinning appAccess/studios here, any authenticated staff
   150	      // user could grant themselves access to any app (KPI, Classbook,
   151	      // Payroll-adjacent tools, etc.) with a direct Firestore write that
   152	      // bypasses the Manage Team UI entirely.
   153	      allow update: if isAuthenticated()
   154	        && request.auth.uid == userId
   155	        && !isReminderBot()
   156	        && request.resource.data.role == resource.data.role
   157	        && fieldUnchanged('appAccess')
   158	        && fieldUnchanged('studios')
   159	        && fieldUnchanged('active');
   160	
   161	      // Manager update: cannot change role field, cannot delete.
   162	      // Restricted to OTHER users' docs (request.auth.uid != userId) —
   163	      // without this guard, a manager editing their OWN doc would satisfy
   164	      // isManager() and bypass the appAccess/studios pins on the self-update
   165	      // rule above entirely, since Firestore OR's sibling `allow update`
   166	      // rules together. A manager's own self-edits go through the
   167	      // self-update rule instead, which does pin those fields. Found by
   168	      // independent second-model review before this shipped — see
   169	      // firebase-agent-defense-hardening.md.
   170	      // A manager also cannot flip an admin's `active` field (archive/
   171	      // reactivate) — only another admin can. Managers keep full appAccess/
   172	      // studios editing on admins; that pre-existing gap stays out of scope.
   173	      allow update: if isManager()
   174	        && request.auth.uid != userId
   175	        && request.resource.data.role == resource.data.role
   176	        && (resource.data.role != 'admin' || fieldUnchanged('active'));
   177	
   178	      // Admin: full create / update / delete on OTHER users' docs. An admin
   179	      // can never change their OWN `active` field via this (or any) rule —
   180	      // without this guard this blanket rule sits outside the self-update
   181	      // rule's fieldUnchanged('active') pin (Firestore ORs sibling `allow`
   182	      // rules), so an admin could archive themselves with no recovery path:
   183	      // the moment it commits, isAdmin() requires isActiveUser() and denies
   184	      // them on every future request, including their own attempt to undo
   185	      // it. Same bug shape as the manager self-grant fix above, just for a
   186	      // field that didn't exist yet when that one shipped.
   187	      // …and never a doc keyed to the reminder bot's uid (a job, not a person): create and update are
   188	      // refused so no admin can hand the Netlify-held password a role by typing the uid; delete stays,
   189	      // so a doc created by mistake can be removed.
   190	      allow write: if isAdmin()
   805	// Manager, Summer Camp, Clay Hub, Social Media, Playbook, etc.) with a
   806	// direct Firestore write that bypasses the Manage Team UI entirely. Payroll
   807	// and bookkeeping were never reachable this way (they gate on role, not
   808	// appAccess, and role was already protected) but everything else was.
   809	
   810	describe('Users — appAccess/studios cannot be self-granted (privilege escalation fix)', () => {
   811	  test('staff CANNOT self-update to add appAccess entries', async () => {
   812	    const db = getDb(STAFF_NOACCESS_UID);
   813	    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
   814	      appAccess: ['classbook-admin', 'payroll', 'training'],
   815	    }));
   816	  });
   817	
   818	  test('staff CANNOT self-update to change studios', async () => {
   819	    const db = getDb(STAFF_NOACCESS_UID);
   820	    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
   821	      studios: ['tinker', 'clayhub'],
   822	    }));
   823	  });
   824	
   825	  test('staff CAN still self-update unrelated fields (no regression)', async () => {
   826	    const db = getDb(STAFF_NOACCESS_UID);
   827	    await assertSucceeds(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
   828	      name: 'Updated Name',
   829	      pin: '4321',
   830	    }));
   831	  });
   832	
   833	  test('a brand-new user CANNOT self-create with appAccess already populated', async () => {
   834	    const db = getDb('brand-new-uid');
   835	    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid'), {
   836	      role: 'staff',
   837	      appAccess: ['classbook-admin'],
   838	    }));
   839	  });
   840	
   841	  test('a brand-new user CANNOT self-create with a studio outside the known set', async () => {
   842	    const db = getDb('brand-new-uid-2');
   843	    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-2'), {
   844	      role: 'staff',
   845	      studios: ['tinker', 'some-future-privileged-studio'],
   846	    }));
   847	  });
   848	
   849	  test('a brand-new user CAN self-create with no appAccess/studios (bootstrap)', async () => {
   850	    const db = getDb('brand-new-uid-3');
   851	    await assertSucceeds(setDoc(doc(db, 'users', 'brand-new-uid-3'), {
   852	      role: 'staff',
   853	      name: 'New Hire',
   854	    }));
   855	  });
   856	
   857	  test('the real bootstrap write shape succeeds: role staff, appAccess [], studios [tinker, clayhub]', async () => {
   858	    // Mirrors js/app.js handleAuthStateChange()'s default-user-doc write exactly.
   859	    const db = getDb('brand-new-uid-4');
   860	    await assertSucceeds(setDoc(doc(db, 'users', 'brand-new-uid-4'), {
   861	      name: 'New Hire',
   862	      email: 'newhire@tinkerartstudio.com',
   863	      role: 'staff',
   864	      studios: ['tinker', 'clayhub'],
   865	      appAccess: [],
   866	      createdAt: '2026-08-11T00:00:00.000Z',
   867	    }));
   868	  });
   869	
   870	  test('admin can still grant appAccess to another user', async () => {
   871	    const db = getDb(ADMIN_UID);
   872	    await assertSucceeds(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
   873	      appAccess: ['kpi'],
   874	    }));
   875	  });
   876	
   877	  // Regression test for a gap found by independent second-model review:
   878	  // the separate "Manager update" rule (isManager() && role unchanged) had
   879	  // no request.auth.uid != userId guard, so a manager writing to THEIR OWN
   880	  // doc satisfied it too — bypassing the appAccess/studios pins above
   881	  // entirely, since Firestore ORs sibling `allow update` rules together.
   882	  // Concretely exploitable: belongsToStudio() (gating clayHub_*/rosterManager/
   883	  // clayInventory) doesn't accept isManagerOrAbove(), so a manager scoped to
   884	  // studios:['tinker'] only could have self-granted 'clayhub' this way.
   885	  test('manager CANNOT self-grant studios via the manager-update rule (regression)', async () => {
   886	    const db = getDb(MANAGER_UID);
   887	    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), {
   888	      studios: ['tinker', 'clayhub', 'some-future-privileged-studio'],
   889	    }));
   890	  });
   891	
   892	  test('manager CANNOT self-grant appAccess via the manager-update rule (regression)', async () => {
   893	    const db = getDb(MANAGER_UID);
   894	    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), {
   895	      appAccess: ['payroll'],
   896	    }));
   897	  });
   898	
   899	  test('manager CAN still grant appAccess/studios to ANOTHER user (legitimate team management, unaffected by the fix)', async () => {
   900	    const db = getDb(MANAGER_UID);
   901	    await assertSucceeds(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), {
   902	      appAccess: ['training'],
   903	      studios: ['tinker', 'clayhub'],
   904	    }));
   905	  });
   906	});
   907	
   908	
   909	// ─── USERS — ARCHIVE FEATURE: active:false revokes access everywhere ────────
   910	// BDD scenarios from thoughts/plans/archive-employees.html, Phase 1.
   911	
   912	// ─── USERS — FIELDS MY CLAY HUB RELIES ON (Phase E, E-0) ─────────────────────
   913	// My Clay Hub's staff roster is copied from users docs (name, role, active, appAccess), so no one
   914	// may set their own role, active or appAccess. appAccess/studios self-grants are pinned above and
   915	// archived self-reactivation below; these pin what wasn't covered.
   916	describe('Users — fields My Clay Hub relies on (no self-promotion, no self-set active)', () => {
   917	  test('a brand-new user CANNOT self-create as manager', async () => {
   918	    const db = getDb('brand-new-uid-mgr');
   919	    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-mgr'), { role: 'manager', name: 'New Hire' }));
   920	  });
   921	
   922	  test('a brand-new user CANNOT self-create as admin', async () => {
   923	    const db = getDb('brand-new-uid-adm');
   924	    await assertFails(setDoc(doc(db, 'users', 'brand-new-uid-adm'), { role: 'admin', name: 'New Hire' }));
   925	  });
   926	
   927	  test('staff CANNOT self-update their role to manager or admin', async () => {
   928	    const db = getDb(STAFF_NOACCESS_UID);
   929	    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'manager' }));
   930	    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'admin' }));
   931	  });
   932	
   933	  test('staff CANNOT self-update active (setting it where it was absent, either way)', async () => {
   934	    const db = getDb(STAFF_NOACCESS_UID);
   935	    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { active: true }));
   936	    await assertFails(updateDoc(doc(db, 'users', STAFF_NOACCESS_UID), { active: false }));
   937	  });
   938	
   939	  test('a manager CANNOT self-update their own active or role', async () => {
   940	    const db = getDb(MANAGER_UID);
   941	    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), { active: false }));
   942	    await assertFails(updateDoc(doc(db, 'users', MANAGER_UID), { role: 'admin' }));
   943	  });
   944	});
   945	
   946	describe('Users — active:false revokes access everywhere (Archive Employees feature)', () => {
   947	  test('archived admin cannot read payroll (isAdmin now requires isActiveUser)', async () => {
   948	    const db = getDb(ARCHIVED_ADMIN_UID);
   949	    await assertFails(getDoc(doc(db, 'payroll', 'some-doc')));
   950	  });
   951	
   952	  test('archived staff cannot read kpiData even though appAccess still lists kpi', async () => {
   953	    const db = getDb(ARCHIVED_STAFF_UID);
   954	    await assertFails(getDoc(doc(db, 'kpiData', 'some-doc')));
   955	  });
   956	
   957	  test('archived staff cannot read their OWN timeclock_entries even though appAccess still lists timeclock', async () => {
   958	    const db = getDb(ARCHIVED_STAFF_UID);
   959	    await assertFails(getDoc(doc(db, 'timeclock_entries', 'archived-staff-entry')));
   960	  });
   961	
   962	  test('archived user CAN still read their own doc (app must load, not error)', async () => {
   963	    const db = getDb(ARCHIVED_STAFF_UID);
   964	    await assertSucceeds(getDoc(doc(db, 'users', ARCHIVED_STAFF_UID)));
   965	  });
   966	
   967	  test('archived user CAN lightly self-update an unrelated field; active stays false (pinned, unchanged)', async () => {
   968	    const db = getDb(ARCHIVED_STAFF_UID);
   969	    await assertSucceeds(updateDoc(doc(db, 'users', ARCHIVED_STAFF_UID), {
   970	      name: 'Still Archived',
   971	    }));
   972	  });
   973	
   974	  test('archived staff CANNOT self-write active:true (no self-reactivation)', async () => {
   975	    const db = getDb(ARCHIVED_STAFF_UID);
   976	    await assertFails(updateDoc(doc(db, 'users', ARCHIVED_STAFF_UID), {
   977	      active: true,
   978	    }));
   979	  });
   980	
   981	  test('manager CANNOT archive an admin (write active:false to an active admin doc)', async () => {
   982	    const db = getDb(MANAGER_UID);
   983	    await assertFails(updateDoc(doc(db, 'users', ADMIN_UID), {
   984	      active: false,
   985	    }));
   986	  });
   987	
   988	  test('manager CANNOT reactivate an admin (write active:true to an archived admin doc)', async () => {
   989	    const db = getDb(MANAGER_UID);
   990	    await assertFails(updateDoc(doc(db, 'users', ARCHIVED_ADMIN_UID), {
   991	      active: true,
   992	    }));
   993	  });
   994	
   995	  test('manager CAN archive another staff member (unchanged from existing appAccess/studios capability)', async () => {
   996	    const db = getDb(MANAGER_UID);
   997	    await assertSucceeds(updateDoc(doc(db, 'users', DISPOSABLE_STAFF_FOR_ARCHIVE_UID), {
   998	      active: false,
   999	    }));
  1000	  });
  1001	
  1002	  test('manager CAN reactivate another manager (unchanged from existing appAccess/studios capability)', async () => {
  1003	    const db = getDb(MANAGER_UID);
  1004	    await assertSucceeds(updateDoc(doc(db, 'users', DISPOSABLE_ARCHIVED_MANAGER_FOR_REACTIVATE_UID), {
  1005	      active: true,
  1006	    }));
  1007	  });
  1008	
  1009	  // The critical self-lockout-prevention test: firestore.rules:128's blanket
  1010	  // `allow write: if isAdmin();` sits outside the self-update rule's
  1011	  // fieldUnchanged('active') pin (Firestore ORs sibling `allow` rules), so
  1012	  // without an explicit guard an admin could archive themselves with no
  1013	  // recovery path — same bug shape as the manager self-grant regression
  1014	  // above, just for a field that didn't exist yet when that fix shipped.
  1015	  test('admin CANNOT write active:false to their OWN doc via any rule path (self-lockout prevention)', async () => {
  1016	    const db = getDb(ADMIN_UID);
  1017	    await assertFails(updateDoc(doc(db, 'users', ADMIN_UID), {
  1018	      active: false,
  1019	    }));
  1020	  });
  1021	
  1022	  test('admin CAN write active:false to ANOTHER admin doc (archiving admins stays possible)', async () => {
  1023	    const db = getDb(ADMIN_UID);
  1024	    await assertSucceeds(updateDoc(doc(db, 'users', DISPOSABLE_ADMIN_FOR_ARCHIVE_UID), {
  1025	      active: false,
  1026	    }));
  1027	  });
  1028	
  1029	  test('admin CAN write active:true to ANOTHER admin doc (reactivating admins stays possible)', async () => {
  1030	    const db = getDb(ADMIN_UID);
  1031	    await assertSucceeds(updateDoc(doc(db, 'users', DISPOSABLE_ARCHIVED_ADMIN_FOR_REACTIVATE_UID), {
  1032	      active: true,
  1033	    }));
  1034	  });
  1035	
  1036	  // belongsToStudio()'s non-admin branch doesn't route through isAdmin()/
  1037	  // isManager()/hasAppAccess() at all, so gating those four functions on
  1038	  // isActiveUser() would NOT touch this one without its own explicit check.

exec
/bin/zsh -lc "nl -ba firestore.rules | sed -n '188,198p'
git log --oneline --decorate -3
git diff --check main...HEAD
rg -n \"staffRoster|Granted =|Never email|name, role|active.*appAccess\" /Users/christiehubley/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html | head -20" in /Users/christiehubley/studio-hub
 succeeded in 0ms:
   188	      // refused so no admin can hand the Netlify-held password a role by typing the uid; delete stays,
   189	      // so a doc created by mistake can be removed.
   190	      allow write: if isAdmin()
   191	        && (request.auth.uid != userId || fieldUnchanged('active'))
   192	        && !(isReminderBotUid(userId) && request.method in ['create', 'update']);
   193	    }
   194	
   195	
   196	    // ═══════════════════════════════════════════════════════════════
   197	    // FINANCE — HARD LOCKED
   198	    // payroll and bookkeeping: manager+ ONLY. No appAccess override
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-4JJ5oH8B' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-EKi1Alxb' (errno=Operation not permitted)
086f73e (HEAD -> mch-e0-users-pins) test(rules): pin the users fields My Clay Hub relies on (Phase E, E-0)
742372a (tag: deployed/tinker-hq-apps/firestore-rules/20261002T024647Z-742372a, origin/main, origin/HEAD, main) Merge pull request #6 from Tinker-Art-Studio/claude/staff-celebrations-rules
4fadc08 (origin/claude/staff-celebrations-rules, claude/staff-celebrations-rules) feat(rules): staffCelebrations — staff GET only their own record; managers maintain them
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-pnJvAXvJ' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-28sBgtQJ' (errno=Operation not permitted)
32:  <strong>Goal:</strong> When staff add, edit, pause or offboard a member in Membership Manager, My Clay Hub's own copy of that member (<code>members/{memberId}</code>, with the right derived status) matches within a minute — one way only, carrying only the allowed fields, and safe against late, duplicate or out-of-order deliveries. Staff with My Clay Hub access are mirrored the same way into <code>staffRoster</code>.<br>
44:  <li><strong>D22 "Re-read, then send a snapshot"</strong> (DECISIONS #53): a trigger on <code>clayHub_members/{id}</code> collects the memberId from before and after; for each, one query on <code>memberId</code> only; live = <code>retired !== true</code>; exactly one live doc → its fields; none → tombstone; more than one → conflict, nothing sent, alert. POST <code>{memberId, snapshot, readTime}</code>; ingest drops anything not newer than the stored <code>sourceReadTime</code>, checks the payload strictly, runs <code>deriveStatus</code>, writes, never deletes. The reconcile uses the same envelope, read in one read-only transaction pinned to one readTime. <code>users/{uid}</code> → <code>staffRoster/staff_{uid}</code> the same way (no memberId, no conflict case).</li>
58:<tr><td>F5</td><td><code>users/{uid}</code>: the link uses only <code>name</code>, <code>role</code>, <code>active</code>, <code>appAccess</code>. Docs carry other fields too (<code>email</code>, <code>createdAt</code>, <code>pin</code>, …), and admins can write other users' docs, so the rules don't guarantee shapes: the link must fail closed on anything unexpected. Missing <code>active</code> means true. Managers/admins are saved with <code>appAccess: []</code>. The <code>my-clay-hub</code> key doesn't exist yet.</td><td>studio-hub js/app.js:148-155, 1144-1145, 1339-1347; firestore.rules:24-38, 67-73, 111-187</td></tr>
96:<tr><td><code>staff</code></td><td><code>{uid, staff: {name, role}}</code> — <strong>sent only for granted users</strong> — or <code>{uid, tombstone:true}</code>. Granted = <code>role</code> exactly <code>admin</code>|<code>manager</code>|<code>staff</code>, <code>active</code> absent or <code>true</code>, <code>appAccess</code> absent or a list of strings, and (role manager/admin, or <code>appAccess</code> contains <code>my-clay-hub</code>). A deleted, ungranted or malformed users doc → a tombstone envelope; malformed also logs an error naming the uid only (it repeats each reconcile until fixed — accepted). Never email, PIN or <code>appAccess</code>.</td></tr>
97:<tr><td><code>staffRoster/staff_{uid}</code> (stored)</td><td><code>{uid, name, role, sourceReadTime, updatedAt, tombstone:false}</code>. The receiver ignores a tombstone for a uid it doesn't hold, so no roster doc is ever created for someone never granted.</td></tr>
99:<tr><td>Tombstones (stored)</td><td>Replace the document. <code>members</code>: the last stored snapshot fields <strong>minus <code>email</code>, <code>emailLower</code> and <code>phoneLast4</code></strong> (Q7), plus <code>{memberId, firstName, lastInitial, tombstone:true, status:'removed', statusDate, sourceReadTime, updatedAt}</code>; if nothing was ever stored for that memberId, only those last fields. <code>memberProfiles</code>: <code>{memberId, tombstone:true, status:'removed', updatedAt}</code>. <code>staffRoster</code>: <code>{uid, tombstone:true, sourceReadTime, updatedAt}</code>. A later live record replaces it with the full allowlist again. (Vault copies taken earlier keep the email and phone digits until the 56-day retention ages them out — noted in DATA-RESTORE.)</td></tr>
129:<p>A comment on the <code>users</code> rules naming My Clay Hub's dependency (<code>name</code>, <code>role</code>, <code>active</code>, <code>appAccess</code>). Tests only for what isn't covered (rules.test.js already pins self-granted appAccess and studios): role self-promotion on create (<code>manager</code>, <code>admin</code>), and <code>active</code> on self-update. Released through studio-hub's rules guard (free, sha phrase) <strong>before</strong> E-3 or E-4 merge.</p>
147:  <li><strong><code>ingestMemberUpdate</code></strong> — <code>member</code>/<code>staff</code>: one transaction: read the target doc(s), apply the gate, derive status from the snapshot's source shape, write <code>members</code> + <code>memberProfiles</code> (or <code>staffRoster</code>), or replace them with tombstones.</li>
151:  <li><strong><code>firestore.rules</code></strong>: explicit deny-all blocks for <code>members</code>, <code>memberProfiles</code>, <code>staffRoster</code>, <code>linkOverrides</code> with rules tests (<code>linkOverrides</code> stays deny-all for every client permanently — Phase F's manager settings never reach it); released through the rules guard <em>before</em> the function.</li>
234:  <li><strong>First fill:</strong> Force run the paused <code>reconcileLink</code> (Christie clicks; logged; first confirm in the Console that a paused job can be Force run — if not, resume it, Force run, pause again). This is the first authenticated cross-project call and the first data. Counts match Membership Manager (live members; managers/admins in <code>staffRoster</code>).</li>

codex
### Findings

1. The new comment is materially inaccurate. [firestore.rules](/Users/christiehubley/studio-hub/firestore.rules:112) says all four fields are copied to `staffRoster`. The plan says `active` and `appAccess` determine eligibility, but only `name` and `role` are sent and stored; `appAccess` is explicitly never copied.

2. The claimed “a person must never be able to set their own role … or appAccess” invariant is not true for admins. The admin allow at [firestore.rules](/Users/christiehubley/studio-hub/firestore.rules:190) permits an active admin to update their own `role`, `appAccess`, and `studios`, provided `active` remains unchanged. Concretely, an admin can atomically change their own document to `{role: 'staff', appAccess: []}`, removing themselves from My Clay Hub’s roster. This own-document admin path is uncovered. `studios` itself does not affect My Clay Hub eligibility.

3. Self-create can include `active:true` or `active:false`. That cannot currently grant My Clay Hub access because self-create requires `role:'staff'` and empty/absent `appAccess`, but it further contradicts the comment’s absolute “never … set their own active” wording.

The executable rules logic is unchanged: the commit adds only comments to `firestore.rules`. The tests do cover the literal E-0 BDD requirements:

- Manager/admin role self-promotion during creation.
- Staff changing `active` on self-update.
- Existing tests cover self-set `appAccess` and `studios`.
- Manager-own bypasses are covered for all four protected fields.
- Admin-own `active` is covered, but admin-own `role`/`appAccess` is not.

The new tests are sound: creation uses absent, unique documents with nearby successful bootstrap controls; updates target seeded existing documents; failed writes do not mutate fixtures. The supplied mutation results also support that the denials exercise the intended predicates.

NOT SAFE TO MERGE
tokens used
40,287
### Findings

1. The new comment is materially inaccurate. [firestore.rules](/Users/christiehubley/studio-hub/firestore.rules:112) says all four fields are copied to `staffRoster`. The plan says `active` and `appAccess` determine eligibility, but only `name` and `role` are sent and stored; `appAccess` is explicitly never copied.

2. The claimed “a person must never be able to set their own role … or appAccess” invariant is not true for admins. The admin allow at [firestore.rules](/Users/christiehubley/studio-hub/firestore.rules:190) permits an active admin to update their own `role`, `appAccess`, and `studios`, provided `active` remains unchanged. Concretely, an admin can atomically change their own document to `{role: 'staff', appAccess: []}`, removing themselves from My Clay Hub’s roster. This own-document admin path is uncovered. `studios` itself does not affect My Clay Hub eligibility.

3. Self-create can include `active:true` or `active:false`. That cannot currently grant My Clay Hub access because self-create requires `role:'staff'` and empty/absent `appAccess`, but it further contradicts the comment’s absolute “never … set their own active” wording.

The executable rules logic is unchanged: the commit adds only comments to `firestore.rules`. The tests do cover the literal E-0 BDD requirements:

- Manager/admin role self-promotion during creation.
- Staff changing `active` on self-update.
- Existing tests cover self-set `appAccess` and `studios`.
- Manager-own bypasses are covered for all four protected fields.
- Admin-own `active` is covered, but admin-own `role`/`appAccess` is not.

The new tests are sound: creation uses absent, unique documents with nearby successful bootstrap controls; updates target seeded existing documents; failed writes do not mutate fixtures. The supplied mutation results also support that the denials exercise the intended predicates.

NOT SAFE TO MERGE
