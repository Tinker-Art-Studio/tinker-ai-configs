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
