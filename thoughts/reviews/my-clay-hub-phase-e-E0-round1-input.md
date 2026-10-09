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
