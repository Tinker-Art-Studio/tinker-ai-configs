## E-2 steps 1–2, review round 3 (narrow)
Your round-2 findings on dd2852f: (blocking) a rebuilt missing profile took today's status; (should-fix) 'in' accepted prototype scopes; unreadable-time ids not surfaced; test gaps (missing-profile boundary for trigger and reconcile, prototype scope, staff 249/250, worst case 499 writes, unreadable surfaced). The uncommitted changes you saw were these fixes, now committed: 935046e and 150b450 on phase-e-e2-receiver (diff vs dd2852f below). Verify each is resolved and nothing new broke. Read-only. End with exactly SAFE TO MERGE or NOT SAFE TO MERGE.

diff --git a/functions/members/lib/batch.js b/functions/members/lib/batch.js
index 0f57a06..32ed558 100644
--- a/functions/members/lib/batch.js
+++ b/functions/members/lib/batch.js
@@ -54,7 +54,7 @@ export function pickOverride(overrides, scope, nowNs) {
   const open = [];
   for (const o of overrides) {
     const d = o.data;
-    if (!isObj(d) || !(d.scope in OVERRIDE_KEYS)) { if (scope === 'members') problems.push(`override ${o.id} refused: unknown scope`); continue; }
+    if (!isObj(d) || !Object.hasOwn(OVERRIDE_KEYS, d.scope)) { if (scope === 'members') problems.push(`override ${o.id} refused: unknown scope`); continue; }
     if (d.scope !== scope) continue;
     if (!(d.usedAt === null || isTime(d.usedAt)) || !isTime(d.expiresAt)) {
       problems.push(`override ${o.id} (${scope}) refused: usedAt must be null and expiresAt a timestamp`);
@@ -89,7 +89,7 @@ export function planMembersReconcile(envelope, stored, { today, stamp, storedRea
   const held = new Set(envelope.held);
   const inItems = new Set(envelope.items.map(i => i.memberId));
   const writes = [];   // { collection, id, doc }
-  const ids = { statusChanged: [], removed: [], added: [] };
+  const ids = { statusChanged: [], removed: [], added: [], unreadable: [] };
   const put = (docs, id) => { for (const [collection, doc] of Object.entries(docs)) writes.push({ collection, id, doc }); };
 
   for (const { memberId, snapshot } of envelope.items) {
@@ -99,7 +99,7 @@ export function planMembersReconcile(envelope, stored, { today, stamp, storedRea
     if (!isLive(prior?.members)) { put(memberDocs(memberId, snapshot, today, stamp), memberId); ids.added.push(memberId); continue; }
     if (sameSnapshot(prior.members, snapshot)) {                                                // only the gate advances
       put({ members: { ...prior.members, sourceReadTime: stamp.readTime } }, memberId);
-      if (!prior.memberProfiles) put({ memberProfiles: memberDocs(memberId, snapshot, today, stamp).memberProfiles }, memberId);
+      if (!prior.memberProfiles) put({ memberProfiles: { ...memberDocs(memberId, snapshot, today, stamp).memberProfiles, status: prior.members.status } }, memberId);
       continue;
     }
     const next = memberDocs(memberId, snapshot, today, stamp);
@@ -112,7 +112,8 @@ export function planMembersReconcile(envelope, stored, { today, stamp, storedRea
   for (const [memberId, prior] of stored) {
     if (!isLive(prior.members) || inItems.has(memberId) || held.has(memberId)) continue;
     const priorTime = storedReadTime(prior.members);
-    if (!priorTime || compareReadTime(priorTime, envelope.readTime) >= 0) continue;           // newer, or unknown: kept
+    if (!priorTime) { ids.unreadable.push(memberId); continue; }                              // unknown age: kept, and logged
+    if (compareReadTime(priorTime, envelope.readTime) >= 0) continue;                         // newer than the batch
     put(memberTombstoneDocs(memberId, prior.members, today, stamp), memberId);
     ids.removed.push(memberId);
   }
@@ -125,7 +126,7 @@ export function planMembersReconcile(envelope, stored, { today, stamp, storedRea
 export function planStaffReconcile(envelope, stored, { stamp, storedReadTime, override }) {
   const inItems = new Set(envelope.items.map(i => i.uid));
   const writes = [];
-  const ids = { statusChanged: [], removed: [], added: [] };
+  const ids = { statusChanged: [], removed: [], added: [], unreadable: [] };
   for (const { uid, staff } of envelope.items) {
     const prior = stored.get(uid)?.staffRoster;
     const priorTime = prior ? storedReadTime(prior) : null;
@@ -139,7 +140,8 @@ export function planStaffReconcile(envelope, stored, { stamp, storedReadTime, ov
   for (const [uid, { staffRoster: prior }] of stored) {
     if (!isLive(prior) || inItems.has(uid)) continue;
     const priorTime = storedReadTime(prior);
-    if (!priorTime || compareReadTime(priorTime, envelope.readTime) >= 0) continue;           // newer, or unknown: kept
+    if (!priorTime) { ids.unreadable.push(uid); continue; }                                   // unknown age: kept, and logged
+    if (compareReadTime(priorTime, envelope.readTime) >= 0) continue;
     writes.push({ collection: 'staffRoster', id: staffDocId(uid), doc: staffTombstoneDocs(uid, stamp).staffRoster });
     ids.removed.push(uid);
   }
diff --git a/functions/members/lib/contract.js b/functions/members/lib/contract.js
index 33ff09a..e91d917 100644
--- a/functions/members/lib/contract.js
+++ b/functions/members/lib/contract.js
@@ -198,7 +198,8 @@ export function applyEnvelope(envelope, stored, { today, stamp, storedReadTime }
   // date-driven change — those are the recompute's, counted there (and held back when it stops).
   if (envelope.kind === 'member' && envelope.snapshot && prior && prior.tombstone !== true && sameSnapshot(prior, envelope.snapshot)) {
     const writes = { members: { ...prior, sourceReadTime: stamp.readTime } };
-    if (!stored.memberProfiles) writes.memberProfiles = memberDocs(envelope.memberId, envelope.snapshot, today, stamp).memberProfiles;
+    // A missing profile is rebuilt with the STORED status (today's pause window is fine): status changes stay the recompute's.
+    if (!stored.memberProfiles) writes.memberProfiles = { ...memberDocs(envelope.memberId, envelope.snapshot, today, stamp).memberProfiles, status: prior.status };
     return { result: 'unchanged', writes };
   }
 
diff --git a/tests/unit/members-batch.test.js b/tests/unit/members-batch.test.js
index 19637f1..dfa0e8f 100644
--- a/tests/unit/members-batch.test.js
+++ b/tests/unit/members-batch.test.js
@@ -282,8 +282,10 @@ test('edges: a pause ending 2999-12-31 never crashes the recompute; a record wit
   assert.equal(explained({ statusDate: '2999-12-30', scheduledCancellation: { finalAccessDate: '2999-12-31' } }, '2999-12-31'), false);
   const m = store(1); m.get(mid(1)).members.sourceReadTime = 'missing';
   assert.deepEqual(plan(env([]), m).ids.removed, []);
+  assert.deepEqual(plan(env([]), m).ids.unreadable, [mid(1)], 'kept, and listed for the log');
   const st = staffStore([['u1', { sourceReadTime: 'missing' }]]);
   assert.deepEqual(splan(staffEnv([]), st).ids.removed, []);
+  assert.deepEqual(splan(staffEnv([]), st).ids.unreadable, ['u1']);
 });
 
 test('valid staff and recompute overrides are picked', () => {
@@ -313,3 +315,29 @@ test('recompute: every live statusDate advances; updatedAt moves only when statu
   assert.equal(planRecompute(store(200), { today: TODAY, stamp: STAMP, override: null }).alert, true);
   assert.equal(planRecompute(store(199), { today: TODAY, stamp: STAMP, override: null }).alert, false);
 });
+
+test('a rebuilt missing profile keeps the stored status; an override scope like "toString" is reported', () => {
+  const s = store(1, () => PAUSE_TODAY);
+  const prior = s.get(mid(1));
+  const e = { v: 1, kind: 'member', readTime: BATCH, memberId: mid(1), snapshot: Object.fromEntries(Object.keys(BASE).map(k => [k, prior.members[k]])) };
+  const r = applyEnvelope(e, { members: prior.members }, { today: TODAY, stamp: STAMP, storedReadTime });
+  assert.equal(r.writes.memberProfiles.status, 'active');
+  const rr = plan(env([{ memberId: mid(1), snapshot: e.snapshot }]), new Map([[mid(1), { members: prior.members }]]));
+  assert.equal(rr.writes.find(w => w.collection === 'memberProfiles').doc.status, 'active');
+  const now = 1_000_000_000_000n;
+  assert.match(pickOverride([{ id: 'x', createTimeNs: now, data: { scope: 'toString', usedAt: null, expiresAt: now + 1n } }], 'members', now).problems[0], /unknown scope/);
+});
+
+test('caps: staff at 249/250 records; the worst member case with an override stays within 499 writes', () => {
+  const rows = n => Array.from({ length: n }, (_, i) => [`u${i}`, {}]);
+  const its = n => Array.from({ length: n }, (_, i) => ({ uid: `u${i}`, staff: { name: 'Y', role: 'staff' } }));
+  assert.equal(splan(staffEnv(its(249)), staffStore(rows(249))).ok, true);
+  assert.equal(splan(staffEnv(its(250)), staffStore(rows(250))).reason, 'too many');
+  // 249 members, every snapshot changed (members + profile each) and an override consumed: 249 × 2 + 1
+  const s = store(249);
+  const r = plan(env(items(s, () => snap({ ...PAUSE_TODAY, name: 'New Name' }))), s,
+    { id: 'o1', limits: { maxStatusChanges: 249, maxRemovals: 249 } });
+  assert.equal(r.ok, true);
+  assert.equal(r.overrideUsed, 'o1');
+  assert.ok(r.writes.length + 1 <= 499, `${r.writes.length} writes + the override`);
+});
