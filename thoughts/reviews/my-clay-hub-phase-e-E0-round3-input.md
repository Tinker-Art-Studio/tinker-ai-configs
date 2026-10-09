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
