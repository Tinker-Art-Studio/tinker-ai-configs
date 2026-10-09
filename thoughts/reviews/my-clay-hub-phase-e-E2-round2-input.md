## E-2 steps 1–2, review round 2
Round-1 findings — Codex (NOT SAFE): removal without a readable sourceReadTime (blocking); 2999-12-31 crash; missing profile not rebuilt; rules comment claimed deny blocks outvote broader allows (Firestore ORs); override times in ms; test gaps. Claude (SAFE): trigger path wrote date-driven status for an unchanged snapshot; staffRoster ids must be staff_{uid}; malformed override silently ignored; statusDate-missing explained everything; missing profile; test gaps. Fix commit dd2852f on phase-e-e2-receiver (diff vs 192be39 below). Decision: a trigger with the same snapshot now advances only sourceReadTime (no date-driven status outside the recompute); a changed snapshot still writes today's status (the plan: 'its new snapshot, status and profile'). Verify every finding is resolved correctly, nothing new broke, and look again at anything that could write when it should stop or remove a live record. Read-only. End with exactly SAFE TO MERGE or NOT SAFE TO MERGE.

## Change under review — My Clay Hub Phase E, E-2 steps 1, 1b, 2 (the receiver's logic and rules; no Firebase wiring yet)
Repo /Users/christiehubley/my-clay-hub, branch phase-e-e2-receiver (4 commits vs main: e88e7c1, bf0e515, 192be39 + the shared copy).
Plan: ~/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-e-link.html — "The link contract", E-2 (text extract: /private/tmp/claude-501/-Users-christiehubley-my-clay-hub/b0a70fea-fa70-4d6d-9b90-7969133b14ed/scratchpad/phase-e.txt). DATA-MODEL.md; DECISIONS #53, #65–#75 (#72 = the safety stops). E-1 fixtures: tests/fixtures/link-contract/fixtures.json.

Files:
- functions/members/lib/contract.js — strict envelope check (400), readTime compare, members/memberProfiles/staffRoster docs, Q7 tombstones, applyEnvelope (the gate; 'unchanged' keeps updatedAt; statusDate/sourceReadTime/updatedAt are "volatile")
- functions/members/lib/batch.js — members/staff reconcile plans, the daily recompute plan, #72 limits, overrides (pickOverride/decide), 249 cap, alert from 200
- functions/members/shared/ — byte-identical copies of shared/derive-status.js and denver-time.js (a deploy uploads only the codebase folder; pinned by a test). The codebase will be ESM ("type": "module", step 3).
- firestore.rules — explicit deny-all blocks for members, memberProfiles, staffRoster, linkOverrides (+ tests in tests/rules/firestore.test.js)
- tests/unit/members-contract.test.js, tests/unit/members-batch.test.js (batch tests mutation-checked: 5 planted bugs each caught)
Tests: unit 270/270, rules 214/214, guard 199/199.

## What I want reviewed
1. Correctness against the plan's E-2 text and #72, line by line: the gate; source-driven counting (deriveStatus(stored, today) vs deriveStatus(incoming, today)); "a record whose whole snapshot is unchanged gets only its sourceReadTime advanced"; removals (live, not in items, not held, older than the batch); N = live held minus held ids; additions/reappearance; staff (>1 removal stops; never-held tombstone writes nothing); overrides (exact keys per scope, 0–249, expiresAt ≤ createTime+24h, >1 open → refuse all, used only when normal limits would stop and counts fit, omitted limit keeps normal, consumed); recompute ("explained" = pause start, end+1, last day+1 in (statusDate, today]; unexplained over the limit → nothing written; 249 cap; alert 200).
2. Things I decided that the plan doesn't state — say if any is wrong: statusDate counts as volatile (a same-day re-apply with the same content is 'unchanged'); an unchanged profile isn't rewritten; the recompute writes statusDate on every live member every day and moves updatedAt only when status changes; trigger path (applyEnvelope) re-derives status for today even when the snapshot is unchanged (only the reconcile is forbidden from date-driven writes); 'too many' counts distinct ids written; the members codebase carries a byte-identical copy of shared/.
3. Anything that would lose data, write when it should stop, count wrongly, or let a client read these collections.
4. Test gaps vs the plan's E-2 test list that the pure layer should already cover.
Read-only: no edits, no git state changes, no network, no deploys. Findings as blocking / should-fix / nit with file:line and a concrete scenario. End with exactly SAFE TO MERGE or NOT SAFE TO MERGE (merge itself waits for step 3 and Monday's gate; judge this logic).

## Diff
diff --git a/firestore.rules b/firestore.rules
index 7da6c8a..4901f2f 100644
--- a/firestore.rules
+++ b/firestore.rules
@@ -13,9 +13,11 @@ rules_version = '2';
 service cloud.firestore {
   match /databases/{database}/documents {
     // Phase E (the one-way link): written only by the members functions (Admin SDK, which rules don't apply to).
-    // Explicit, so a later rule elsewhere can't open them by accident. members holds the projection (never read
-    // by a client); memberProfiles and staffRoster stay closed until Phase F gives each its own read rule;
-    // linkOverrides is Console-only for good — no client, staff or manager, ever reads or writes it.
+    // members holds the projection (never read by a client); memberProfiles and staffRoster stay closed until
+    // Phase F gives each its own read rule; linkOverrides is Console-only for good — no client, staff or manager,
+    // ever reads or writes it. Firestore ORs every matching rule, so these blocks can't outvote a broader allow:
+    // tests/rules/firestore.test.js fails if any rule that can match these paths (a recursive wildcard included)
+    // allows anything.
     match /members/{memberId} {
       allow read, write: if false;
     }
diff --git a/functions/members/lib/batch.js b/functions/members/lib/batch.js
index dc1b146..0f57a06 100644
--- a/functions/members/lib/batch.js
+++ b/functions/members/lib/batch.js
@@ -4,25 +4,17 @@
 // transaction, { ok: false, … } writes nothing.
 //
 // Times in this file: readTimes are wire values {seconds, nanos} (storedReadTime(doc) gives a stored doc's); override
-// times (expiresAt, createTime) and nowMs are milliseconds. stamp.readTime / stamp.now are the opaque stored values
+// times (data.expiresAt, data.usedAt, createTimeNs) and nowNs are BigInt nanoseconds, so the 24-hour bound is exact. stamp.readTime / stamp.now are the opaque stored values
 // (Timestamps in the function, placeholders in tests).
 import { deriveStatus } from '../shared/derive-status.js';
 import { isValidYMD, compareYMD, addDaysYMD } from '../shared/denver-time.js';
-import { compareReadTime, memberDocs, memberTombstoneDocs, staffDocs, staffTombstoneDocs, profilePause } from './contract.js';
+import { compareReadTime, memberDocs, memberTombstoneDocs, staffDocs, staffTombstoneDocs, profilePause, staffDocId,
+  stableJson, snapshotOf, sameSnapshot } from './contract.js';
 
 export const MAX_MEMBERS = 249;     // 2 writes each + 1 to consume an override = 499 of Firestore's 500 per transaction
 export const ALERT_FROM = 200;
-const SNAPSHOT_FIELDS = ['name', 'email', 'emailLower', 'memberSince', 'phoneLast4', 'retired', 'stage',
-  'scheduledPause', 'pauseHistory', 'scheduledCancellation'];
 
 const isObj = v => typeof v === 'object' && v !== null && !Array.isArray(v);
-function stableJson(v) {
-  if (Array.isArray(v)) return `[${v.map(stableJson).join(',')}]`;
-  if (isObj(v)) return `{${Object.keys(v).sort().map(k => `${JSON.stringify(k)}:${stableJson(v[k])}`).join(',')}}`;
-  return JSON.stringify(v);
-}
-const snapshotOf = doc => Object.fromEntries(SNAPSHOT_FIELDS.map(k => [k, doc[k]]));
-const sameSnapshot = (doc, snapshot) => stableJson(snapshotOf(doc)) === stableJson(snapshot);
 const isLive = doc => !!doc && doc.tombstone !== true;
 
 // ---- Limits (#72) ----
@@ -36,7 +28,7 @@ const within = (counts, limits) => Object.entries(limits).every(([k, max]) =>
   (k === 'maxStatusChanges' ? counts.statusChanges : counts.removals) <= max);
 
 // ---- Overrides (linkOverrides/{id}, Console only) ----
-// overrides: [{ id, data, createTimeMs }] as read; data.expiresAt / data.usedAt already turned into ms or null.
+// overrides: [{ id, data, createTimeNs }] as read; data.expiresAt / data.usedAt already turned into BigInt ns, or null.
 // → { override: {id, limits} | null, problems: [line] } — problems are logged as errors (each emails Christie).
 const OVERRIDE_KEYS = {
   members: { required: ['scope', 'expiresAt', 'usedAt'], limits: ['maxStatusChanges', 'maxRemovals'] },
@@ -50,20 +42,34 @@ function overrideProblem(o, scope) {
   const limits = spec.limits.filter(k => k in d);
   if (limits.length === 0) return 'no limit';
   if (!limits.every(k => Number.isInteger(d[k]) && d[k] >= 0 && d[k] <= MAX_MEMBERS)) return 'limit not an integer 0-249';
-  if (!Number.isFinite(o.createTimeMs) || d.expiresAt > o.createTimeMs + 24 * 3600 * 1000) return 'expiresAt more than 24 h after creation';
+  if (typeof o.createTimeNs !== 'bigint' || d.expiresAt > o.createTimeNs + DAY_NS) return 'expiresAt more than 24 h after creation';
   return null;
 }
-export function pickOverride(overrides, scope, nowMs) {
-  const open = overrides.filter(o => isObj(o.data) && o.data.scope === scope && o.data.usedAt === null
-    && Number.isFinite(o.data.expiresAt) && o.data.expiresAt > nowMs);
-  if (open.length === 0) return { override: null, problems: [] };
-  if (open.length > 1) return { override: null, problems: [`more than one open ${scope} override (${open.map(o => o.id).join(', ')}): none used`] };
+// A doc that can't be read as an override at all (unknown scope, usedAt neither null nor a time, expiresAt not a time)
+// is reported every run, so Christie learns why it didn't apply; a used or expired one is just history.
+const DAY_NS = 24n * 3600n * 1_000_000_000n;
+const isTime = v => typeof v === 'bigint';
+export function pickOverride(overrides, scope, nowNs) {
+  const problems = [];
+  const open = [];
+  for (const o of overrides) {
+    const d = o.data;
+    if (!isObj(d) || !(d.scope in OVERRIDE_KEYS)) { if (scope === 'members') problems.push(`override ${o.id} refused: unknown scope`); continue; }
+    if (d.scope !== scope) continue;
+    if (!(d.usedAt === null || isTime(d.usedAt)) || !isTime(d.expiresAt)) {
+      problems.push(`override ${o.id} (${scope}) refused: usedAt must be null and expiresAt a timestamp`);
+      continue;
+    }
+    if (d.usedAt === null && d.expiresAt > nowNs) open.push(o);
+  }
+  if (open.length === 0) return { override: null, problems };
+  if (open.length > 1) return { override: null, problems: [...problems, `more than one open ${scope} override (${open.map(o => o.id).join(', ')}): none used`] };
   const [o] = open;
   const problem = overrideProblem(o, scope);
-  if (problem) return { override: null, problems: [`override ${o.id} (${scope}) refused: ${problem}`] };
+  if (problem) return { override: null, problems: [...problems, `override ${o.id} (${scope}) refused: ${problem}`] };
   const limits = { ...normalLimits(scope, 0) };   // shape only; an omitted limit keeps its normal value (filled in decide())
   for (const k of Object.keys(limits)) if (k in o.data) limits[k] = o.data[k]; else delete limits[k];
-  return { override: { id: o.id, limits }, problems: [] };
+  return { override: { id: o.id, limits }, problems };
 }
 
 // Pass on the normal limits; else on the override (its omitted limits keep the normal value) — then it is consumed.
@@ -93,6 +99,7 @@ export function planMembersReconcile(envelope, stored, { today, stamp, storedRea
     if (!isLive(prior?.members)) { put(memberDocs(memberId, snapshot, today, stamp), memberId); ids.added.push(memberId); continue; }
     if (sameSnapshot(prior.members, snapshot)) {                                                // only the gate advances
       put({ members: { ...prior.members, sourceReadTime: stamp.readTime } }, memberId);
+      if (!prior.memberProfiles) put({ memberProfiles: memberDocs(memberId, snapshot, today, stamp).memberProfiles }, memberId);
       continue;
     }
     const next = memberDocs(memberId, snapshot, today, stamp);
@@ -105,7 +112,7 @@ export function planMembersReconcile(envelope, stored, { today, stamp, storedRea
   for (const [memberId, prior] of stored) {
     if (!isLive(prior.members) || inItems.has(memberId) || held.has(memberId)) continue;
     const priorTime = storedReadTime(prior.members);
-    if (priorTime && compareReadTime(priorTime, envelope.readTime) >= 0) continue;            // newer than the batch
+    if (!priorTime || compareReadTime(priorTime, envelope.readTime) >= 0) continue;           // newer, or unknown: kept
     put(memberTombstoneDocs(memberId, prior.members, today, stamp), memberId);
     ids.removed.push(memberId);
   }
@@ -114,7 +121,7 @@ export function planMembersReconcile(envelope, stored, { today, stamp, storedRea
 }
 
 // ---- Staff reconcile ----
-// stored: Map uid → { staffRoster }.
+// stored: Map uid → { staffRoster } (keyed by uid; writes go to staffRoster/staff_{uid}).
 export function planStaffReconcile(envelope, stored, { stamp, storedReadTime, override }) {
   const inItems = new Set(envelope.items.map(i => i.uid));
   const writes = [];
@@ -123,17 +130,17 @@ export function planStaffReconcile(envelope, stored, { stamp, storedReadTime, ov
     const prior = stored.get(uid)?.staffRoster;
     const priorTime = prior ? storedReadTime(prior) : null;
     if (priorTime && compareReadTime(envelope.readTime, priorTime) <= 0) continue;
-    if (!isLive(prior)) { writes.push({ collection: 'staffRoster', id: uid, doc: staffDocs(uid, staff, stamp).staffRoster }); ids.added.push(uid); continue; }
+    if (!isLive(prior)) { writes.push({ collection: 'staffRoster', id: staffDocId(uid), doc: staffDocs(uid, staff, stamp).staffRoster }); ids.added.push(uid); continue; }
     const doc = prior.name === staff.name && prior.role === staff.role
       ? { ...prior, sourceReadTime: stamp.readTime }
       : staffDocs(uid, staff, stamp).staffRoster;
-    writes.push({ collection: 'staffRoster', id: uid, doc });
+    writes.push({ collection: 'staffRoster', id: staffDocId(uid), doc });
   }
   for (const [uid, { staffRoster: prior }] of stored) {
     if (!isLive(prior) || inItems.has(uid)) continue;
     const priorTime = storedReadTime(prior);
-    if (priorTime && compareReadTime(priorTime, envelope.readTime) >= 0) continue;
-    writes.push({ collection: 'staffRoster', id: uid, doc: staffTombstoneDocs(uid, stamp).staffRoster });
+    if (!priorTime || compareReadTime(priorTime, envelope.readTime) >= 0) continue;           // newer, or unknown: kept
+    writes.push({ collection: 'staffRoster', id: staffDocId(uid), doc: staffTombstoneDocs(uid, stamp).staffRoster });
     ids.removed.push(uid);
   }
   const n = [...stored.values()].filter(p => isLive(p.staffRoster)).length;
@@ -146,6 +153,7 @@ function finish(scope, n, writes, ids, override) {
   if (touched > MAX_MEMBERS) return { ok: false, reason: 'too many', counts, ids, n, touched };
   const d = decide(scope, n, counts, override);
   if (!d.ok) return { ok: false, reason: 'stopped', counts, ids, n, limits: d.limits };
+  // alert: from 200 records written in one transaction (the reconcile) / 200 live members (the recompute)
   return { ok: true, writes, counts, ids, n, limits: d.limits, overrideUsed: d.overrideUsed, alert: touched >= ALERT_FROM };
 }
 
@@ -158,14 +166,18 @@ export function explained(members, today) {
   const windows = [];
   if (isObj(members.scheduledPause) && members.scheduledPause.processed === true) windows.push(members.scheduledPause);
   if (Array.isArray(members.pauseHistory)) windows.push(...members.pauseHistory);
+  // The day after the last supported date (2999-12-31) can't be a Denver today, so it can't explain anything.
+  const dayAfter = ymd => (ymd === '2999-12-31' ? null : addDaysYMD(ymd, 1));
   for (const w of windows) {
     if (!isObj(w)) continue;
     if (isValidYMD(w.startDate)) dates.push(w.startDate);
-    if (isValidYMD(w.endDate)) dates.push(addDaysYMD(w.endDate, 1));
+    if (isValidYMD(w.endDate)) dates.push(dayAfter(w.endDate));
   }
   const fad = isObj(members.scheduledCancellation) ? members.scheduledCancellation.finalAccessDate : null;
-  if (isValidYMD(fad)) dates.push(addDaysYMD(fad, 1));
-  return dates.some(d => (!isValidYMD(after) || compareYMD(d, after) > 0) && compareYMD(d, today) <= 0);
+  if (isValidYMD(fad)) dates.push(dayAfter(fad));
+  const known = dates.filter(Boolean);
+  if (!isValidYMD(after)) return false;   // no known statusDate: nothing explains the change (fail closed)
+  return known.some(d => compareYMD(d, after) > 0 && compareYMD(d, today) <= 0);
 }
 
 // stored: Map memberId → { members, memberProfiles } (live and tombstoned; tombstones are left alone).
@@ -181,7 +193,9 @@ export function planRecompute(stored, { today, stamp, override }) {
     if (statusChanged && !explained(members, today)) ids.statusChanged.push(memberId);
     writes.push({ collection: 'members', id: memberId,
       doc: { ...members, status, statusDate: today, updatedAt: statusChanged ? stamp.now : members.updatedAt } });
-    if (memberProfiles && (memberProfiles.status !== status || stableJson(memberProfiles.pause) !== stableJson(pause))) {
+    if (!memberProfiles) {
+      writes.push({ collection: 'memberProfiles', id: memberId, doc: memberDocs(memberId, snapshotOf(members), today, stamp).memberProfiles });
+    } else if (memberProfiles.status !== status || stableJson(memberProfiles.pause) !== stableJson(pause)) {
       writes.push({ collection: 'memberProfiles', id: memberId, doc: { ...memberProfiles, status, pause, updatedAt: stamp.now } });
     }
   }
diff --git a/functions/members/lib/contract.js b/functions/members/lib/contract.js
index f59a1e7..33ff09a 100644
--- a/functions/members/lib/contract.js
+++ b/functions/members/lib/contract.js
@@ -13,6 +13,10 @@ export const MALFORMED = '!malformed';
 export const MEMBER_ID = /^m_[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/;
 export const STAFF_UID = /^[^/]{1,128}$/;
 export const STAFF_ROLES = Object.freeze(['admin', 'manager', 'staff']);
+// staffRoster/staff_{uid} (DATA-MODEL.md): the prefix keeps every uid a valid doc id ('.', '..', '__x__' aren't).
+export const staffDocId = uid => `staff_${uid}`;
+export const SNAPSHOT_FIELDS = Object.freeze(['name', 'email', 'emailLower', 'memberSince', 'phoneLast4', 'retired', 'stage',
+  'scheduledPause', 'pauseHistory', 'scheduledCancellation']);
 const MAX_SECONDS = 253402300799n;   // Firestore's latest Timestamp (9999-12-31T23:59:59Z)
 const SNAPSHOT_KEYS = 'email,emailLower,memberSince,name,pauseHistory,phoneLast4,retired,scheduledCancellation,scheduledPause,stage';
 
@@ -171,7 +175,7 @@ function sameContent(a, b) {
   const strip = d => Object.fromEntries(Object.entries(d).filter(([k]) => !VOLATILE.includes(k)));
   return stableJson(strip(a)) === stableJson(strip(b));
 }
-function stableJson(v) {
+export function stableJson(v) {
   if (Array.isArray(v)) return `[${v.map(stableJson).join(',')}]`;
   if (isObj(v)) return `{${Object.keys(v).sort().map(k => `${JSON.stringify(k)}:${stableJson(v[k])}`).join(',')}}`;
   return JSON.stringify(v);
@@ -182,11 +186,21 @@ function settle(next, prior) {
   return { doc: next, changed: true };
 }
 
+export const snapshotOf = doc => Object.fromEntries(SNAPSHOT_FIELDS.map(k => [k, doc[k]]));
+export const sameSnapshot = (doc, snapshot) => stableJson(snapshotOf(doc)) === stableJson(snapshot);
+
 export function applyEnvelope(envelope, stored, { today, stamp, storedReadTime }) {
   const primary = envelope.kind === 'member' ? 'members' : 'staffRoster';
   const prior = stored[primary];
   const priorTime = prior ? storedReadTime(prior) : null;
   if (priorTime && compareReadTime(envelope.readTime, priorTime) <= 0) return { result: 'stale', writes: {} };
+  // The same snapshot again: only the gate advances. Status and statusDate stay as stored, so a trigger never writes a
+  // date-driven change — those are the recompute's, counted there (and held back when it stops).
+  if (envelope.kind === 'member' && envelope.snapshot && prior && prior.tombstone !== true && sameSnapshot(prior, envelope.snapshot)) {
+    const writes = { members: { ...prior, sourceReadTime: stamp.readTime } };
+    if (!stored.memberProfiles) writes.memberProfiles = memberDocs(envelope.memberId, envelope.snapshot, today, stamp).memberProfiles;
+    return { result: 'unchanged', writes };
+  }
 
   let built;
   if (envelope.kind === 'member') {
diff --git a/tests/rules/firestore.test.js b/tests/rules/firestore.test.js
index 590ef99..18a208f 100644
--- a/tests/rules/firestore.test.js
+++ b/tests/rules/firestore.test.js
@@ -111,16 +111,29 @@ describe('committed firestore.rules: a stranger can do nothing', () => {
   });
 });
 
-// Phase E: the link's collections each keep an explicit deny-all block, so a Phase F rule for some other path (or a
-// loosened catch-all) can never open them. linkOverrides stays deny-all for every client permanently.
-describe('the link collections have their own deny-all blocks', () => {
+// Phase E: the link's collections each keep an explicit deny-all block. Firestore ORs matching rules, so the real
+// guarantee is that NO rule able to match these paths — their own block, a wildcard collection, or a recursive
+// wildcard — allows anything. linkOverrides stays deny-all for every client permanently.
+describe('nothing can open the link collections', () => {
   const rules = readRules('firestore.rules');
+  const LINK = ['members', 'memberProfiles', 'staffRoster', 'linkOverrides'];
+  // Every match block with its own allow lines (nested blocks aren't used in this file; a test below insists on it).
+  const blocks = [...rules.matchAll(/match\s+((?:[^\s{]|\{[^}]*\})+)\s+\{([^{}]*)\}/g)].map(m => ({ path: m[1], allows: [...m[2].matchAll(/allow[^;]*;/g)].map(a => a[0]) }));
+  const canReach = p => p === '/{document=**}' || /^\/\{[^}]+\}/.test(p) || LINK.some(c => p.startsWith(`/${c}/`));
   for (const [col, id] of [['members', 'memberId'], ['memberProfiles', 'memberId'], ['staffRoster', 'staffId'], ['linkOverrides', 'overrideId']]) {
-    test(`${col} is explicitly denied`, () => {
-      const block = new RegExp(`match /${col}/\\{${id}\\} \\{\\s*allow read, write: if false;\\s*\\}`);
-      if (!block.test(rules)) throw new Error(`no explicit deny-all block for ${col}`);
-      const opens = rules.split('\n').filter(l => l.includes(`/${col}/`) && !l.trim().startsWith('//') && !l.includes('match'));
-      if (opens.length) throw new Error(`${col} appears in another rule: ${opens.join(' | ')}`);
+    test(`${col} has its own deny-all block`, () => {
+      if (!new RegExp(`match /${col}/\\{${id}\\} \\{\\s*allow read, write: if false;\\s*\\}`).test(rules)) throw new Error(`no explicit deny-all block for ${col}`);
     });
   }
+  test('every rule that could match a link path (own block, wildcard or recursive wildcard) only says "if false"', () => {
+    const reaching = blocks.filter(b => canReach(b.path));
+    if (!reaching.some(b => b.path === '/{document=**}')) throw new Error('the catch-all block is missing');
+    for (const b of reaching) for (const a of b.allows) {
+      if (!/:\s*if false;$/.test(a)) throw new Error(`${b.path} has "${a}", which could open a link collection`);
+    }
+  });
+  test('the parser saw every match block (no nesting below the database root it could miss)', () => {
+    const matchCount = (rules.match(/\bmatch\s+\//g) || []).length;
+    if (blocks.length !== matchCount - 1) throw new Error(`saw ${blocks.length} leaf blocks for ${matchCount} match lines`);
+  });
 });
diff --git a/tests/unit/members-batch.test.js b/tests/unit/members-batch.test.js
index 8ef899d..19637f1 100644
--- a/tests/unit/members-batch.test.js
+++ b/tests/unit/members-batch.test.js
@@ -5,6 +5,7 @@ import assert from 'node:assert/strict';
 import { readFileSync } from 'node:fs';
 import { memberDocs, memberTombstoneDocs } from '../../functions/members/lib/contract.js';
 import { planMembersReconcile, planStaffReconcile, planRecompute, pickOverride, normalLimits, explained } from '../../functions/members/lib/batch.js';
+import { applyEnvelope } from '../../functions/members/lib/contract.js';
 
 const FX = JSON.parse(readFileSync(new URL('../fixtures/link-contract/fixtures.json', import.meta.url)));
 const TODAY = '2026-11-15', YESTERDAY = '2026-11-14';
@@ -112,8 +113,8 @@ test('a stale item (a newer trigger already landed) is skipped', () => {
 
 test('overrides: unused when normal limits pass; used and consumed when they fit; omitted limit keeps the normal one', () => {
   const s = store(66);
-  const now = 1_000_000;
-  const o = (data, createTimeMs = now - 1000) => ({ id: 'o1', createTimeMs, data: { scope: 'members', usedAt: null, expiresAt: now + 3600_000, ...data } });
+  const now = 1_000_000_000_000n;
+  const o = (data, createTimeNs = now - 1000n) => ({ id: 'o1', createTimeNs, data: { scope: 'members', usedAt: null, expiresAt: now + 3_600_000_000_000n, ...data } });
   const picked = pickOverride([o({ maxStatusChanges: 20 })], 'members', now);
   assert.equal(picked.override.id, 'o1');
   const pausing = k => it => (Number(it.slice(-2)) <= k ? snap(PAUSE_TODAY) : null);
@@ -126,17 +127,20 @@ test('overrides: unused when normal limits pass; used and consumed when they fit
 });
 
 test('overrides refused: two open, wrong keys, no limit, out of range, expiresAt beyond 24 h; ignored when used or expired', () => {
-  const now = 1_000_000;
-  const base = { scope: 'members', usedAt: null, expiresAt: now + 1000, maxRemovals: 9 };
-  const mk = (id, data, createTimeMs = now) => ({ id, createTimeMs, data: { ...base, ...data } });
+  const now = 1_000_000_000_000n, H = 3_600_000_000_000n;
+  const base = { scope: 'members', usedAt: null, expiresAt: now + 1000n, maxRemovals: 9 };
+  const mk = (id, data, createTimeNs = now) => ({ id, createTimeNs, data: { ...base, ...data } });
   assert.match(pickOverride([mk('a', {}), mk('b', {})], 'members', now).problems[0], /more than one/);
   assert.equal(pickOverride([mk('a', {}), mk('b', {})], 'members', now).override, null);
   assert.match(pickOverride([mk('a', { extra: 1 })], 'members', now).problems[0], /keys/);
-  assert.match(pickOverride([{ id: 'a', createTimeMs: now, data: { scope: 'members', usedAt: null, expiresAt: now + 1000 } }], 'members', now).problems[0], /no limit/);
+  assert.match(pickOverride([{ id: 'a', createTimeNs: now, data: { scope: 'members', usedAt: null, expiresAt: now + 1000n } }], 'members', now).problems[0], /no limit/);
   assert.match(pickOverride([mk('a', { maxRemovals: 250 })], 'members', now).problems[0], /0-249/);
-  assert.match(pickOverride([mk('a', { expiresAt: now + 25 * 3600_000 })], 'members', now).problems[0], /24 h/);
-  assert.equal(pickOverride([mk('a', { usedAt: 5 })], 'members', now).override, null);
-  assert.equal(pickOverride([mk('a', { expiresAt: now - 1 })], 'members', now).override, null);
+  assert.match(pickOverride([mk('a', { expiresAt: now + 25n * H })], 'members', now).problems[0], /24 h/);
+  assert.match(pickOverride([mk('a', { expiresAt: now + 24n * H + 1n })], 'members', now).problems[0], /24 h/, 'one nanosecond over');
+  assert.match(pickOverride([mk('a', { maxRemovals: -1 })], 'members', now).problems[0], /0-249/);
+  assert.match(pickOverride([mk('a', { maxRemovals: 1.5 })], 'members', now).problems[0], /0-249/);
+  assert.equal(pickOverride([mk('a', { usedAt: 5n })], 'members', now).override, null);
+  assert.equal(pickOverride([mk('a', { expiresAt: now - 1n })], 'members', now).override, null);
   assert.equal(pickOverride([mk('a', {})], 'staff', now).override, null, 'scoped');
 });
 
@@ -145,7 +149,7 @@ test('staff reconcile: one removal passes, two stop; unchanged name and role adv
   const e = its => ({ v: 1, kind: 'reconcile', readTime: BATCH, scope: 'staff', items: its });
   const one = planStaffReconcile(e([{ uid: 'u1', staff: { name: 'X', role: 'staff' } }, { uid: 'u2', staff: { name: 'X', role: 'staff' } }]), st, { stamp: STAMP, storedReadTime, override: null });
   assert.equal(one.ok, true);
-  assert.deepEqual(one.writes.find(w => w.id === 'u1').doc, { ...st.get('u1').staffRoster, sourceReadTime: 'batch' });
+  assert.deepEqual(one.writes.find(w => w.id === 'staff_u1').doc, { ...st.get('u1').staffRoster, sourceReadTime: 'batch' });
   assert.equal(planStaffReconcile(e([{ uid: 'u1', staff: { name: 'X', role: 'staff' } }]), st, { stamp: STAMP, storedReadTime, override: null }).ok, false);
 });
 
@@ -184,3 +188,128 @@ test('explained: pause start, end + 1 and last day + 1, after statusDate and on
   assert.equal(explained(m({ pauseHistory: [{ startDate: '2026-11-14', endDate: '2026-11-20' }] }), '2026-11-15'), false, 'started on statusDate: already counted');
   assert.equal(explained(m({}), '2026-11-15'), false);
 });
+
+// ---- Review round 1 additions ----
+const staffStore = (rows) => new Map(rows.map(([uid, over]) => [uid, { staffRoster: { uid, name: 'X', role: 'staff', sourceReadTime: 'old', updatedAt: 'then', tombstone: false, ...over } }]));
+const staffEnv = its => ({ v: 1, kind: 'reconcile', readTime: BATCH, scope: 'staff', items: its });
+const splan = (e, st, override = null) => planStaffReconcile(e, st, { stamp: STAMP, storedReadTime, override });
+
+test('staff: writes go to staffRoster/staff_{uid}; a removal racing a newer trigger is kept; a rename writes the full doc', () => {
+  const st = staffStore([['u1', {}], ['u2', { sourceReadTime: 'newer' }], ['u3', {}]]);
+  const r = splan(staffEnv([{ uid: 'u1', staff: { name: 'Y', role: 'manager' } }, { uid: 'u3', staff: { name: 'X', role: 'staff' } }]), st);
+  assert.equal(r.ok, true);
+  assert.deepEqual(r.ids.removed, [], 'u2 is newer than the batch');
+  assert.ok(r.writes.every(w => w.id.startsWith('staff_')));
+  assert.deepEqual(r.writes.find(w => w.id === 'staff_u1').doc, { uid: 'u1', name: 'Y', role: 'manager', sourceReadTime: 'batch', updatedAt: 'now', tombstone: false });
+});
+
+test('staff: a re-grant over a tombstoned uid is an addition', () => {
+  const st = new Map([['u1', { staffRoster: { uid: 'u1', tombstone: true, sourceReadTime: 'old', updatedAt: 'then' } }]]);
+  const r = splan(staffEnv([{ uid: 'u1', staff: { name: 'X', role: 'staff' } }]), st);
+  assert.deepEqual(r.ids.added, ['u1']);
+  assert.equal(r.counts.removals, 0);
+});
+
+test('reconcile: an already-tombstoned record is neither re-removed nor counted; removals count toward the 249 cap', () => {
+  const s = store(5);
+  s.set(mid(9), memberTombstoneDocs(mid(9), null, YESTERDAY, { readTime: 'old', now: 'then' }));
+  const r = plan(env(items(s)), s);
+  assert.equal(r.counts.removals, 0);
+  assert.ok(!r.writes.some(w => w.id === mid(9)));
+  const big = store(250);
+  assert.equal(plan(env([]), big).reason, 'too many', '250 removals are 250 records written');
+});
+
+test('reconcile: A → B → A out of order — a B batch older than a stored A is skipped', () => {
+  const s = store(1);
+  s.get(mid(1)).members.sourceReadTime = 'newer';      // A again landed (read 3000) before the B batch (read 2000)
+  const r = plan(env([{ memberId: mid(1), snapshot: snap({ name: 'Bea Bee' }) }]), s);
+  assert.equal(r.writes.length, 0);
+});
+
+test('trigger: the same snapshot again advances only sourceReadTime — never a date-driven status', () => {
+  const s = store(1, () => PAUSE_TODAY);
+  const prior = s.get(mid(1));
+  const e = { v: 1, kind: 'member', readTime: BATCH, memberId: mid(1), snapshot: Object.fromEntries(Object.keys(BASE).map(k => [k, prior.members[k]])) };
+  const r = applyEnvelope(e, prior, { today: TODAY, stamp: STAMP, storedReadTime });
+  assert.equal(r.result, 'unchanged');
+  assert.deepEqual(r.writes, { members: { ...prior.members, sourceReadTime: 'batch' } });
+  assert.equal(r.writes.members.status, 'active', 'paused only once the recompute says so');
+});
+
+test('recompute: exact threshold — 10 unexplained pass, 11 stop with no writes; more than 249 live refuses', () => {
+  const s = store(66);
+  for (let i = 1; i <= 10; i++) s.get(mid(i)).members.status = 'review';
+  assert.equal(planRecompute(s, { today: TODAY, stamp: STAMP, override: null }).ok, true);
+  s.get(mid(11)).members.status = 'review';
+  const stop = planRecompute(s, { today: TODAY, stamp: STAMP, override: null });
+  assert.equal(stop.ok, false);
+  assert.equal('writes' in stop, false);
+  assert.equal(planRecompute(store(250), { today: TODAY, stamp: STAMP, override: null }).reason, 'too many');
+});
+
+test('recompute: the profile pause moves at a window boundary (end + 1 → the next window, else null); a missing profile is rebuilt', () => {
+  const s = store(2, i => (i === 1
+    ? { pauseHistory: [{ startDate: '2026-11-01', endDate: '2026-11-14' }, { startDate: '2026-12-01', endDate: '2026-12-10' }] }
+    : { pauseHistory: [{ startDate: '2026-11-01', endDate: '2026-11-14' }] }));
+  s.get(mid(2)).memberProfiles = undefined;
+  const r = planRecompute(s, { today: TODAY, stamp: STAMP, override: null });
+  const prof = id => r.writes.find(w => w.collection === 'memberProfiles' && w.id === id)?.doc;
+  assert.deepEqual(prof(mid(1)).pause, { startDate: '2026-12-01', endDate: '2026-12-10' });
+  assert.equal(prof(mid(2)).pause, null);
+  assert.equal(prof(mid(2)).memberId, mid(2));
+  assert.equal(r.counts.statusChanges, 0, 'paused → active the day after the end is explained');
+});
+
+test('explained fails closed without a statusDate', () => {
+  assert.equal(explained({ pauseHistory: [{ startDate: '2020-01-01', endDate: '2020-01-05' }] }, TODAY), false);
+});
+
+test('overrides: exactly createTime + 24 h is accepted; bad shapes are reported, not silently ignored', () => {
+  const now = 1_000_000_000_000n, day = 24n * 3_600_000_000_000n;
+  const ok = pickOverride([{ id: 'a', createTimeNs: now - 10n, data: { scope: 'members', usedAt: null, expiresAt: now - 10n + day, maxRemovals: 9 } }], 'members', now);
+  assert.equal(ok.override.id, 'a');
+  assert.match(pickOverride([{ id: 'b', createTimeNs: now, data: { scope: 'members', expiresAt: now + 1n, maxRemovals: 9 } }], 'members', now).problems[0], /usedAt/);
+  assert.match(pickOverride([{ id: 'c', createTimeNs: now, data: { scope: 'members', usedAt: null, expiresAt: 'tomorrow', maxRemovals: 9 } }], 'members', now).problems[0], /expiresAt/);
+  assert.match(pickOverride([{ id: 'd', createTimeNs: now, data: { scope: 'member', usedAt: null, expiresAt: now + 1n, maxRemovals: 9 } }], 'members', now).problems[0], /unknown scope/);
+  assert.match(pickOverride([{ id: 'e', createTimeNs: now, data: { scope: 'staff', usedAt: null, expiresAt: now + 1n, maxRemovals: 2, maxStatusChanges: 3 } }], 'staff', now).problems[0], /keys/);
+  assert.match(pickOverride([{ id: 'f', createTimeNs: now, data: { scope: 'recompute', usedAt: null, expiresAt: now + 1n } }], 'recompute', now).problems[0], /keys/);
+});
+
+test('edges: a pause ending 2999-12-31 never crashes the recompute; a record with no sourceReadTime is never removed', () => {
+  const s = store(1, () => ({ scheduledPause: { startDate: '2999-12-01', endDate: '2999-12-31', processed: true } }));
+  assert.doesNotThrow(() => planRecompute(s, { today: TODAY, stamp: STAMP, override: null }));
+  assert.equal(explained({ statusDate: '2999-12-30', scheduledCancellation: { finalAccessDate: '2999-12-31' } }, '2999-12-31'), false);
+  const m = store(1); m.get(mid(1)).members.sourceReadTime = 'missing';
+  assert.deepEqual(plan(env([]), m).ids.removed, []);
+  const st = staffStore([['u1', { sourceReadTime: 'missing' }]]);
+  assert.deepEqual(splan(staffEnv([]), st).ids.removed, []);
+});
+
+test('valid staff and recompute overrides are picked', () => {
+  const now = 1_000_000_000_000n;
+  assert.deepEqual(pickOverride([{ id: 's', createTimeNs: now, data: { scope: 'staff', usedAt: null, expiresAt: now + 1n, maxRemovals: 3 } }], 'staff', now).override, { id: 's', limits: { maxRemovals: 3 } });
+  assert.deepEqual(pickOverride([{ id: 'r', createTimeNs: now, data: { scope: 'recompute', usedAt: null, expiresAt: now + 1n, maxStatusChanges: 30 } }], 'recompute', now).override, { id: 'r', limits: { maxStatusChanges: 30 } });
+});
+
+test('reconcile: a reappearing member gets the full members and profile allowlists back', () => {
+  const s = store(1);
+  const t = memberTombstoneDocs(mid(1), s.get(mid(1)).members, YESTERDAY, { readTime: 'old', now: 'then' });
+  s.set(mid(1), t);
+  const r = plan(env([{ memberId: mid(1), snapshot: BASE }]), s);
+  const want = memberDocs(mid(1), BASE, TODAY, STAMP);
+  assert.deepEqual(r.writes.find(w => w.collection === 'members').doc, want.members);
+  assert.deepEqual(r.writes.find(w => w.collection === 'memberProfiles').doc, want.memberProfiles);
+});
+
+test('recompute: every live statusDate advances; updatedAt moves only when status does; 200 live raises the alert', () => {
+  const s = store(3);
+  s.get(mid(3)).members.status = 'review';
+  const r = planRecompute(s, { today: TODAY, stamp: STAMP, override: null });
+  const doc = id => r.writes.find(w => w.collection === 'members' && w.id === id).doc;
+  assert.equal(doc(mid(1)).statusDate, TODAY);
+  assert.equal(doc(mid(1)).updatedAt, 'then');
+  assert.equal(doc(mid(3)).updatedAt, 'now');
+  assert.equal(planRecompute(store(200), { today: TODAY, stamp: STAMP, override: null }).alert, true);
+  assert.equal(planRecompute(store(199), { today: TODAY, stamp: STAMP, override: null }).alert, false);
+});
