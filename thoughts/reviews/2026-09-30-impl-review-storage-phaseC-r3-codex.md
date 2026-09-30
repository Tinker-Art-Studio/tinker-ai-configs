Reading additional input from stdin...
OpenAI Codex v0.147.0
--------
workdir: /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
model: gpt-5.6-sol
provider: openai
approval: never
sandbox: read-only
reasoning effort: none
reasoning summaries: none
session id: 01a0f3d8-877e-7f03-a706-30e39f359f7d
--------
user
Round 3 (narrow) of your Phase C review. Your round 2: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC-r2-codex.md. Fix diff: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC-r3.diff (worktree read-only /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81, scripts/spring-2026-move.console.js). Check only your two new findings (reserved keys; no undo from a mismatched copy): RESOLVED / NOT with file:line, and whether the fix introduced anything wrong. One-line verdict: SAFE TO RUN IN PRODUCTION after the backup.js edit, or NOT (minimum list). Be brief. Do not edit files or run tests.
codex
I’ll compare the round-2 findings, the supplied fix diff, and the current script—read-only, with no tests.
exec
/bin/zsh -lc "sed -n '1,240p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC-r2-codex.md && sed -n '1,260p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC-r3.diff && rg -n -C 5 \"reserved|__name__|documentId|undo|mismatch|sourceFingerprint|destinationFingerprint|copy\" scripts/spring-2026-move.console.js" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
Reading additional input from stdin...
OpenAI Codex v0.147.0
--------
workdir: /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
model: gpt-5.6-sol
provider: openai
approval: never
sandbox: read-only
reasoning effort: none
reasoning summaries: none
session id: 01a0f3d4-95fa-7422-8ef6-3a1aec1da016
--------
user
Round 2 of your Phase C review. Your round 1: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC-codex.md. Fix diff: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC-r2.diff (worktree read-only: /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81; procedure scripts/spring-2026-move.console.js; live rules: git -C /Users/christiehubley/studio-hub show 0caf415:firestore.rules). For each of your 4 minimum items: RESOLVED / NOT (file:line) — item 4 (backup.js edit) is pending Christie's go-ahead and will be made before the run; say if anything else must be in it. Then adversarially check the new code once more for any path that can lose/alter/duplicate lessons or leave an unrecoverable state, and that every write (incl. the 3-write undo transaction) is allowed by the live rules for a manager. One-line verdict: SAFE TO RUN IN PRODUCTION (after the backup.js edit) or NOT (minimum list). Be concise. Do not edit files or run tests.
codex
I’ll compare the four round-one findings against the supplied fix diff and current procedure, then trace failure/retry/undo paths and validate every write against the specified live rules revision. I’ll only perform read-only inspection.
exec
/bin/zsh -lc "sed -n '1,240p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC-codex.md && sed -n '1,280p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC-r2.diff && sed -n '1,320p' scripts/spring-2026-move.console.js" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
Reading additional input from stdin...
OpenAI Codex v0.147.0
--------
workdir: /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
model: gpt-5.6-sol
provider: openai
approval: never
sandbox: read-only
reasoning effort: none
reasoning summaries: none
session id: 01a0f3ce-4ba7-7531-b6a9-3c06f22a4c12
--------
user
## Implementation review — Phase C console procedure (PRODUCTION data move tonight)
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase C; read the Decisions Log). Diff: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC.diff (commit 05b159b). Worktree (read-only): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 — the procedure is scripts/spring-2026-move.console.js; it runs in the live Classbook page (live code = main 132fef2, Phase B) signed in as a manager. Live rules: /Users/christiehubley/studio-hub/firestore.rules at studio-hub 0caf415 (git -C /Users/christiehubley/studio-hub show 0caf415:firestore.rules).
Production: curriculum/lessonData is ~972 KB (spring-2026 ~551 KB, fall-2026 ~420 KB), teachers actively editing Fall.
Adversarially: (1) can this lose, alter or duplicate any lesson (Spring or Fall), or leave a half state, in any path — preflight, backup, transaction (retries, contention with Fall saves on the ~1 MB doc), verify, mark-verified, undo, undo failure? (2) Does every write match what the Phase A rules allow for a manager (incl. the undo re-add + delete in one transaction, and removing the storageMigrations entry)? (3) Fingerprint soundness (Timestamps, key order, arrays, types that JSON can't represent); backup file completeness. (4) Behaviour of open Classbook tabs (Phase B code) during and after. (5) Rehearsal test quality. Verdict: SAFE TO RUN IN PRODUCTION or NOT (minimum list). Do not edit files or run tests.
codex
I’ll review this as a production safety audit only—no edits or tests. I’m going to read the Phase C plan and Decisions Log, inspect the supplied diff/script and the exact live rules revision, then trace every forward/undo path against Phase B behavior.
exec
/bin/zsh -lc "sed -n '1,260p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html && sed -n '1,320p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Plan: Classbook — move Spring 2026's lessons into their own document (lessonData is at 95% of Firestore's 1 MB cap)</title>
<style>
  body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; max-width: 860px; margin: 2rem auto; padding: 0 1.5rem; color: #1a1a1a; line-height: 1.5; }
  h1 { font-size: 1.6rem; border-bottom: 2px solid #8B30BC; padding-bottom: .5rem; }
  h2 { font-size: 1.15rem; margin-top: 2rem; color: #6052C8; }
  h3 { font-size: 1rem; margin-top: 1.2rem; }
  .meta { background: #f5f0ff; border-left: 4px solid #8B30BC; padding: .75rem 1rem; border-radius: 4px; margin: 1rem 0; font-size: .9rem; }
  .phase { border: 1px solid #e5e7eb; border-radius: 6px; padding: 1rem 1.25rem; margin: 1rem 0; }
  .phase h3 { margin-top: 0; }
  .bdd { background: #fafafa; border: 1px solid #e5e7eb; border-radius: 4px; padding: .5rem .75rem; margin: .5rem 0; font-size: .88rem; font-family: monospace; white-space: pre-wrap; }
  .safe { background: #f0fdf4; border-left: 4px solid #16a34a; padding: .6rem 1rem; border-radius: 4px; font-size: .9rem; margin: .5rem 0; }
  .note { background: #fffbeb; border-left: 4px solid #f59e0b; padding: .6rem 1rem; border-radius: 4px; font-size: .9rem; margin: .5rem 0; }
  .danger { background: #fef2f2; border-left: 4px solid #dc2626; padding: .6rem 1rem; border-radius: 4px; font-size: .9rem; margin: .5rem 0; }
  .decision { background: #eff6ff; border-left: 4px solid #2563eb; padding: .6rem 1rem; border-radius: 4px; font-size: .9rem; margin: .5rem 0; }
  code { background: #f3f4f6; padding: .1rem .35rem; border-radius: 3px; font-size: .88rem; }
  table { border-collapse: collapse; width: 100%; margin: .75rem 0; }
  th, td { border: 1px solid #e5e7eb; padding: .4rem .75rem; font-size: .88rem; text-align: left; vertical-align: top; }
  th { background: #f9fafb; }
  .status-tag { display: inline-block; font-size: .75rem; font-weight: 700; padding: .15rem .5rem; border-radius: 999px; }
  .not-ready { background: #fef3c7; color: #92400e; }
  .ready { background: #dcfce7; color: #166534; }
</style>
</head>
<body>

<h1 id="plan-title">Plan: Classbook — move Spring 2026's lessons into their own document</h1>

<div class="meta" id="plan-meta">
  <strong>Goal:</strong> Teachers never hit a wall where lesson saves stop working. Spring 2026, a finished semester, moves out of the almost-full shared document into its own, with no lesson lost or changed, and Spring stays viewable exactly as today.<br>
  <strong>Why now:</strong> On Sep 29, 2026 Christie measured <code>curriculum/lessonData</code> at <strong>972 KB of 1,024 KB (95%)</strong> from a forced server read: <code>spring-2026</code> 551 KB, <code>fall-2026</code> 420 KB. It's real content spread over hundreds of lessons (the largest field is 2.5 KB), so there's nothing to trim. At the cap, <strong>every weekly lesson save fails for everyone</strong>. Fall is being written into it right now.<br>
  <strong>Scope (revision 2):</strong> <strong>Spring 2026 only, with its key written literally into the code and the rules.</strong> Spring ran Jan–May and is dormant, so the move needs no new UI and no config flags. Moving Fall, making every new semester get its own document, and the <code>createNewSemester</code>/<code>deleteSemester</code> changes that requires are a <strong>follow-up plan</strong>. That plan must land before the next semester is created (see "Follow-up").<br>
  <strong>Touches:</strong> the Classbook (<code>js/firebase-data.js</code>, <code>js/app.js</code>), <code>studio-hub/firestore.rules</code> + <code>studio-hub/rules.test.js</code> (sha phrase + guard), <code>studio-hub/js/alerts.js</code> (Studio Hub deploy), and <code>tinker-backups/backup.js</code>, <strong>which only Christie edits</strong> (memory: <code>backup-js-uses-cli-token</code>).<br>
  <strong>Line numbers</strong> at <code>2ef2e62</code>. <strong>Status:</strong> <span class="status-tag ready">execution-ready: true</span>. Revision 5. Reviewed by Claude (round 1) and Codex (rounds 1–3). Codex round 3 left one edit, now made. Waiting for Christie's go-ahead to build.
</div>

<div class="danger">
  <strong>If headroom runs out early:</strong> the move itself is already a single step (Phase C), so the fastest safe route is to do Phases A and B promptly and run Phase C as soon as the 3-day stale-tab cutoff allows. Never remove Spring from <code>lessonData</code> before Phase B's code, which can read the new location, is live. Doing so would make Spring look empty, which is the May 2026 incident on purpose. Phase B adds a headroom readout, so nobody has to remember to paste a snippet.
</div>

<h2 id="today">What exists today (research, verified in review round 1)</h2>
<table>
  <tr><th>Fact</th><th>Where</th></tr>
  <tr><td><code>curriculum/lessonData</code> = <code>{ &lt;semKey&gt;: { &lt;lessonKey&gt;: lesson }, lastUpdated, lastUpdatedBy, qaData? }</code>. Firestore caps a document at 1 MiB.</td><td>measured Sep 29</td></tr>
  <tr><td>Storage is routed by <code>lessonStoreFor(semKey)</code> (<code>'camp'</code> / <code>'weekly'</code>; throws otherwise). Callers: <code>firebase-data.js:811, 1387, 1479</code>; <code>app.js:3636, 5848, 7155, 7240</code>.</td><td><code>firebase-data.js:55-72</code></td></tr>
  <tr><td>The 13 in-app <code>doc('lessonData')</code> sites. Reads: <code>:762</code> load, <code>:975</code> <code>readServerSemesterLessonMap</code>, <code>:1171</code> listener, <code>app.js:5835</code> <code>readAdminLessonDoc</code>, <code>app.js:7518</code> <code>computeLiveContentCountByTeacher</code>. Writes: <code>:817</code> <code>saveLessonData</code> (whole-semester merge-set), <code>:830</code> <code>deleteLessonKey</code>, <code>:963</code> <code>deleteLessonData</code>, <code>:1438</code> <code>saveSingleLesson</code>, <code>:1500</code> <code>saveMultipleLessonFields</code>, <code>app.js:3690</code> <code>sendTeacherQaMessage</code>, <code>:7202</code> <code>sendHelpResponse</code>, <code>:7285</code> <code>sendQaReply</code>. Dead code: <code>backupLessonData</code>/<code>restoreFromBackup</code> (<code>:979-1002</code>, no callers).</td><td>as cited</td></tr>
  <tr><td><strong>The live listener replaces the whole model</strong>: <code>currentLessonData = doc.data()</code> (<code>:1186</code>), carrying across only camp/SDOC maps through <code>snapshotCampSeasons()</code> (<code>:1094-1100</code>). It bumps <code>globalListenerGeneration</code> (<code>:1181</code>), which gates the summer reload, and a superseded reload never sets <code>lessonDataLoadedSuccessfully</code> (<code>:1131, 1143-1145</code>). It's registered from two places (<code>app.js:676</code>, <code>:5038</code>) with one unsubscribe handle (<code>:1116</code>).</td><td>as cited</td></tr>
  <tr><td><code>setupConfigListener()</code> is never called, so an open tab's <code>currentConfig</code> is frozen at load.</td><td><code>app.js:11328</code></td></tr>
  <tr><td>Rules: <code>:654</code> is <code>allow read, write: if isManagerOrAbove()</code>, and <code>:666</code> is a separate create/update for classbook roles (not appData/prepCycleConfig). Rules OR across statements, so fencing a key for managers too means <strong>splitting <code>:654</code></strong> into per-operation statements. Whole-doc delete is limited to classbook-admin/curriculum-admin (<code>:675-678</code>). <code>studio-hub/rules.test.js</code> has no <code>curriculum/lessonData</code> fixture today.</td><td><code>studio-hub/firestore.rules:652-678</code></td></tr>
  <tr><td>Outside the Classbook, readers of <code>curriculum/lessonData</code>:
    <ul>
      <li>Studio Hub's Q&amp;A alerts (<code>studio-hub/js/alerts.js:559-580</code>, iterating every top-level key).</li>
      <li><strong><code>tinker-backups/backup.js</code></strong>: it backs up the <code>curriculum</code> collection as Tier 1 (<code>:38, :56</code>; new <code>lessons_*</code> docs are included automatically), and <code>computeClassbookContentByTeacher</code> (<code>:370-389</code>) counts per-teacher content from <code>curriculum/lessonData</code> only, writing <code>backupStatus/latest</code> (<code>:471</code>) with a 10% drop alarm. The Classbook's <code>renderContentCount()</code> (<code>app.js:7578-7600</code>) compares live counts to that baseline.</li>
      <li><code>studio-hub/test-alerts.js:98, 143</code>: an Admin SDK test script that writes <code>lessonData.qaData</code>. It bypasses rules and isn't part of the app.</li>
      <li>The <code>summer-camp-app/scripts/backup-firestore.js</code> console script is manual and weekly, not the nightly backup (a round-1 correction).</li>
    </ul></td><td>as cited</td></tr>
</table>

<h2 id="design">Design (revision 3)</h2>
<ul>
  <li><strong>One constant, <code>OWN_DOC_SEMESTERS = ['spring-2026']</code></strong>, in <code>firebase-data.js</code>. It changes only by a code deploy, and the rules fence changes only by a rules deploy.</li>
  <li><strong>Where Spring lives:</strong> <code>curriculum/lessons_spring-2026</code> = <code>{ &lt;lessonKey&gt;: lesson, lastUpdated, lastUpdatedBy }</code>. <code>lessonStoreFor</code> returns <code>'ownDoc'</code> for keys in the constant. Every weekly site goes through <code>weeklyLessonRef(semKey)</code> / <code>weeklyLessonPath(semKey, lessonKey, field?)</code>: paths are rooted at <code>lessonKey</code> for <code>'ownDoc'</code> and at <code>semKey.lessonKey</code> for legacy.</li>
  <li><strong>Transitional read rule:</strong> for an own-doc semester, if <code>lessons_K</code> exists, read it; otherwise read <code>lessonData[K]</code> as today. The code can deploy before the move, and Spring stays viewable at every step.</li>
  <li><strong>One-step move (Codex round 1, "simpler safe option"):</strong> Spring's copy and the removal of its old copy happen <em>in one transaction</em>. There's never a multi-day period with two copies, so nothing is double-counted, and the old copy can't be deleted while the new one is missing.</li>
  <li><strong>Spring edits stay paused, enforced by the rules, until the move is verified.</strong> A rule on <code>curriculum/lessons_spring-2026</code> allows updates only when <code>curriculum/storageMigrations</code> has <code>spring-2026.verified == true</code> (a <code>get()</code> on Spring writes only; Spring is dormant, so the cost is negligible). So nothing can change the new document between the copy and the verification: its hash is stable, and a rollback can't discard a real edit.</li>
</ul>

<h2 id="phases">Phases</h2>

<div class="phase" id="phase-a">
<h3>Phase A: rules that protect Spring during and after the move <span class="status-tag ready">execution-ready: true</span></h3>
<p><strong>Acceptance:</strong> every other <code>/curriculum</code> document behaves exactly as today for every role. For <code>curriculum/lessonData</code>:</p>
<ul>
  <li>No role can create, add to, or change the <code>spring-2026</code> key, with exactly two manager/admin exceptions. (1) An update that <em>only deletes</em> it, for the Phase C transaction. (2) The <strong>rollback</strong>: an update that <em>only re-adds</em> it, allowed only while <code>storageMigrations.spring-2026.verified != true</code> and only if <code>getAfter(lessons_spring-2026)</code> shows that document deleted in the same transaction (Codex round 2, fix 1).</li>
  <li>No role can delete the <strong>whole</strong> <code>lessonData</code> document. This closes Codex's bypass: delete it, then recreate it with a stale Spring.</li>
  <li><code>create</code> of <code>lessonData</code> is refused if it contains <code>spring-2026</code>.</li>
</ul>
<p>For <code>curriculum/lessons_spring-2026</code>: create by a manager only, and only if it doesn't exist. Updates only when <code>storageMigrations.spring-2026.verified == true</code>, for the roles that can update lessons today. Whole-doc delete by <strong>manager/admin only, and only while not yet verified</strong> (the rollback). classbook-admin and curriculum-admin may never delete it, and <strong>nobody</strong> may delete it after verification, until the follow-up plan adds a routed delete/archive (Codex round 2, fix 2).</p>
<p>For <code>curriculum/storageMigrations</code>: manager write, and read for the classbook roles.</p>
<p>It deploys through <code>deploy-rules.sh --approved &lt;sha&gt;</code> after Christie's phrase. It ships first: it breaks nothing, because Spring's edits are already paused (Christie approved view-only).</p>
<p><strong>Shape:</strong> split <code>:654</code> (<code>allow read, write: if isManagerOrAbove()</code>) into <code>read</code> / <code>create</code> / <code>update</code> / <code>delete</code> statements, because rules OR across statements. Manager <code>delete</code> is kept for every curriculum doc except <code>lessonData</code>. The classbook-role statements at <code>:666</code> and <code>:675-678</code> get the same <code>lessonData</code>/<code>lessons_spring-2026</code> conditions. The <code>lessonData</code> update condition is <code>!affectedKeys().hasAny(['spring-2026'])</code>, OR (manager/admin, removal) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; !('spring-2026' in request.resource.data)</code>, OR (manager/admin, <strong>rollback re-add</strong>) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; ('spring-2026' in request.resource.data) &amp;&amp; !('spring-2026' in resource.data) &amp;&amp; !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026) &amp;&amp; get(/databases/$(database)/documents/curriculum/storageMigrations).data.get('spring-2026', {}).get('verified', false) != true</code>. Every split statement is constrained this way, because <code>allow</code> statements OR together.</p>
<div class="bdd">Rules tests (studio-hub/rules.test.js), roles: teacher (classbook), classbook-admin, curriculum-admin, manager, admin.
  lessonData update fall-2026.x.field                              → allowed (every role that can today)
  lessonData update spring-2026.x.field                            → denied (every role)
  lessonData update { spring-2026: delete } only                    → manager/admin allowed; others denied
  lessonData update { spring-2026: delete, fall-2026.x: … }         → denied
  lessonData whole-doc delete                                       → denied (every role)
  lessonData create containing spring-2026                          → denied; create without it → as today
  re-add spring-2026 after removal, plain                           → denied (every role)
  rollback: manager/admin re-adds only spring-2026 AND deletes lessons_spring-2026 in one transaction, while unverified → allowed
  the same rollback after verified                                  → denied
  re-add spring-2026 without deleting lessons_spring-2026 in the same transaction → denied
  lessons_spring-2026 create when absent                            → manager/admin allowed; others denied
  lessons_spring-2026 update before verified                        → denied (every role); after verified → allowed as for lessons today
  lessons_spring-2026 delete before verified                        → manager/admin allowed (rollback); teacher/classbook-admin/curriculum-admin denied
  lessons_spring-2026 delete after verified                         → denied (every role)
  storageMigrations write                                           → manager/admin only; read → classbook roles
  every other /curriculum doc (appData, prepCycleConfig, prepData, cutProjects, changeLog, …) → exactly as today
  A near-1 MB lessonData fixture built from many sub-fields, with its estimated size asserted, reset per mutating test: the allow/deny cases above evaluate correctly
  The whole existing studio-hub suite passes</div>
</div>

<div class="phase" id="phase-b">
<h3>Phase B: the Classbook (and Studio Hub) understand Spring's new home. No data moves yet. <span class="status-tag ready">execution-ready: true</span></h3>
<p><strong>Acceptance:</strong> in production (no <code>lessons_spring-2026</code> yet), everything behaves as today, and Spring is view-only ("editing is paused while Spring 2026 moves to new storage"). In the emulator, with Spring moved and verified, Spring works end to end, and Fall and every other semester are untouched. This is one Classbook deploy (one Netlify credit) plus one Studio Hub deploy.</p>
<ul>
  <li><strong>The listener doesn't drop Spring</strong> (round 1 A). The legacy snapshot's swap carries own-doc semesters across, the way it already carries camp seasons. The <code>lessons_K</code> listener updates only <code>currentLessonData[K]</code>, doesn't bump <code>globalListenerGeneration</code>, and never touches <code>lessonDataLoadedSuccessfully</code>. Its errors go to a visible banner and make Spring unwritable.</li>
  <li><strong>Transitions are loud, never blank.</strong>
    <ul>
      <li>If <code>lessons_K</code> appears (the move committed), Spring switches to it.</li>
      <li>If it disappears (a rollback), the app reloads Spring from the legacy source, or shows "reload the page" if that's gone too.</li>
      <li>If the legacy snapshot lacks a key this tab was rendering from <code>lessonData</code>, the app shows "moved — reload the page".</li>
    </ul>
    The whole teardown uses one unsubscribe array (the listener is registered from <code>app.js:676</code> and <code>:5038</code>).</li>
  <li><strong>Writes to Spring:</strong> they go to <code>lessons_K</code> only when <code>storageMigrations.spring-2026.verified</code> is true, read by a small <code>storageMigrations</code> listener. Otherwise the app shows the "editing is paused" message; the rules refuse those writes anyway. <code>not-found</code> is handled the same way.</li>
  <li><strong>Counts come from one source per semester</strong> (Codex 5). <code>computeLiveContentCountByTeacher</code> uses <code>lessons_K</code> when it exists and skips <code>lessonData[K]</code>, otherwise the legacy map. There's never a dual-copy window anyway, but this protects against a failed rollback state.</li>
  <li><strong>Deleting Spring is disabled</strong> (Codex 7). <code>deleteSemester('spring-2026')</code> refuses with "Spring 2026 can't be deleted while its storage is being changed", until the follow-up plan routes it properly.</li>
  <li><strong>Headroom readout</strong> in Curriculum Admin → Diagnostics (managers): an approximate Firestore-size estimate of <code>lessonData</code>, using the same field-size method as the Sep 29 snippet (not <code>JSON.stringify</code> length). It's labelled "approx.", and it warns above 85%, a conservative buffer.</li>
  <li><strong>Studio Hub alerts</strong> (Codex 6). The listener keeps per-source state: legacy <code>lessonData</code>, plus <code>lessons_spring-2026</code>. It reconciles the <em>union</em>, so each source's snapshot no longer removes the other's alerts. It prefers the own-doc copy for Spring. Alert IDs become <code>classbook-qa-&lt;semKey&gt;-&lt;lessonKey&gt;</code>, fixing today's cross-semester collisions. Studio Hub stores dismissals <em>by ID</em> (<code>alerts.js:6-7, 54-68, 654</code>), so an alert also counts as dismissed if its <strong>old</strong> ID <code>classbook-qa-&lt;lessonKey&gt;</code> is in the dismissed set. This is a one-line compatibility check in <code>addOrUpdateAlert</code>, so nothing already dismissed comes back (Codex round 2, fix 3). An old dismissal applies to that lesson key in every semester, which matches today's behaviour, since today the two collide into one alert.</li>
  <li><strong>Ratchet:</strong> no <code>doc('lessonData')</code> in the loaded scripts outside the helpers, the legacy load/listener and the dead backup helpers. <code>e2e/</code> is exempt. The seed gains a <code>lessons_spring-2026</code> + <code>storageMigrations</code> fixture set for the own-doc scenarios, and the default seed is unchanged.</li>
</ul>
<div class="bdd">Scenario: production state after deploy — regression
  Given no lessons_spring-2026
  Then every existing e2e test passes; Fall behaves as today; Spring is viewable and edits show "editing is paused"

Scenario: Spring moved and verified works end to end (emulator)
  When a teacher views/saves a Spring lesson, sends Q&A; an admin replies, edits, moves/swaps
  Then every write lands in lessons_spring-2026 at lessonKey.field paths; lessonData is untouched

Scenario: moved but not yet verified — edits paused
  Given lessons_spring-2026 exists, verified false
  Then Spring shows the moved lessons and edits show "editing is paused"

Scenario: a Fall save doesn't blank Spring (round 1 A)
Scenario: the target doc disappears (rollback) → Spring falls back to legacy or "reload", never an empty grid
Scenario: own-doc listener error → banner, Spring unwritable, Fall unaffected
Scenario: counts: a teacher with 10 Spring + 5 Fall lessons counts 15, before and after the move
Scenario: deleteSemester('spring-2026') refuses with the storage message
Scenario: Studio Hub: a Fall question and a Spring question both alert, and answering one leaves the other; identical lesson keys in two semesters give two alerts
Scenario: Studio Hub: an alert dismissed under its old ID stays dismissed after the re-key
Scenario: headroom readout shows ≈ N KB of 1,024 (approx.) and warns above 85%</div>
</div>

<div class="phase" id="phase-c">
<h3>Phase C: move Spring in one step (production, one-off, manager) <span class="status-tag ready">execution-ready: true</span></h3>
<p><strong>Preconditions:</strong>
<ul>
  <li>Phase B has been live at least 3 days, and it's a quiet time (evening).</li>
  <li><strong>Stale-tab cutoff</strong> (Codex 4): the day before, Christie asks staff to close and reopen the Classbook. A tab still running pre-Phase-B code can't lose anything, because the Phase A rules refuse its Spring writes. It could show Spring as empty until it's reloaded, and that's the accepted residual.</li>
  <li>Christie's go-ahead.</li>
</ul></p>
<p><strong>How:</strong> a console procedure that Christie pastes while signed in as manager. The procedure is written into this plan and reviewed before execution, and rehearsed in the emulator by an e2e test that runs the same code.</p>
<ol>
  <li>A forced-server read of <code>lessonData</code>. It refuses if <code>spring-2026</code> is missing or <code>lessons_spring-2026</code> exists. Then it downloads <code>classbook-spring-2026-lessons-&lt;ISO&gt;.json</code>.</li>
  <li><strong>One transaction:</strong> read <code>lessonData</code>, <code>lessons_spring-2026</code> (which must not exist) and <code>storageMigrations</code>. Then:
    <ul>
      <li><code>tx.set(lessons_spring-2026, { ...map, lastUpdated, lastUpdatedBy })</code>, where <code>map</code> is the <code>spring-2026</code> map read <em>inside</em> the transaction</li>
      <li><code>tx.update(lessonData, { 'spring-2026': FieldValue.delete() })</code></li>
      <li><code>tx.set(storageMigrations, { 'spring-2026': { movedAt, movedBy, lessonCount, sha256, verified: false } }, { merge: true })</code></li>
    </ul>
    The hash is SHA-256 of canonical (sorted-key) JSON of <code>map</code>. It's all or nothing.</li>
  <li><strong>Verify</strong> from forced-server reads: <code>lessons_spring-2026</code> minus its <code>lastUpdated*</code> hashes to the recorded <code>sha256</code>, its lesson count matches, <code>lessonData</code> no longer has <code>spring-2026</code>, and <code>lessonData</code>'s size is re-estimated (expected about 420 KB). Edits are paused by rule, so these checks are stable.</li>
  <li><strong>If verification passes:</strong> <code>storageMigrations.spring-2026.verified = true</code>, and Spring becomes editable. Spot-check one Spring lesson in the Firebase Console.</li>
  <li><strong>If it fails:</strong> nothing has been edited since the copy, so the reverse transaction is safe: it puts <code>map</code> back into <code>lessonData</code>, which Phase A's rollback allowance permits (a manager/admin, only this key, only while unverified, and only together with deleting <code>lessons_spring-2026</code>), deletes <code>lessons_spring-2026</code>, and records the failure. The download from step 1 remains the last resort.</li>
</ol>
<div class="bdd">Scenario: move (emulator, the same procedure as an e2e test)
  Then lessons_spring-2026 deep-equals the old map (+ lastUpdated*), lessonData has no spring-2026, storageMigrations records count + hash, verified → true, Spring editable, Fall untouched
Scenario: target already exists → refuses before any write
Scenario: verification fails (simulated) → the reverse transaction restores lessonData['spring-2026'] byte-identical and removes the target
Scenario: a pre-Phase-B tab after the move → its Spring edit is refused by the rules (no data loss)</div>
<div class="note"><strong>The backup script edit (Christie gave permission for this change, Sep 29):</strong> <em>before</em> Phase C, and with Christie's go-ahead confirmed again at that moment, Claude adds the five lines recorded in the Decisions Log to <code>tinker-backups/backup.js</code> (<code>computeClassbookContentByTeacher</code>, just before <code>return counts;</code>). It keeps a <code>.bak</code> copy, checks the syntax with <code>node --check</code>, doesn't run the script, and touches nothing else, above all not the credential code. Because the move is one step, the backup never sees Spring twice.</div>
</div>

<h2 id="followup">Follow-up plan (required before the next semester is created)</h2>
<div class="note">After Phase C, <code>lessonData</code> holds Fall (about 420 KB and growing). <strong>Before Spring 2027 is created</strong> (or before <code>lessonData</code> passes about 70%), a follow-up plan must:
<ul>
  <li>move Fall at the end of its term</li>
  <li>create new semesters in their own document (config set before <code>saveLessonData</code>, <code>app.js:4965</code> vs <code>:4980</code>; <code>not-found</code> on the first write)</li>
  <li>route <code>deleteSemester</code>/Archive for own-doc semesters (re-enabling Spring's delete or archive)</li>
  <li>generalise the constant and the rules fence</li>
</ul>
The make-active-semester plan resumes after that.</div>

<h2 id="safety">Firebase safety checklist</h2>
<div class="safe"><ul>
  <li><strong>Rules:</strong> Phase A is a shared-rules change: tests for all five roles, a near-1 MB fixture, the whole suite green, then <code>deploy-rules.sh --approved &lt;sha&gt;</code> after the phrase. The new docs (<code>lessons_spring-2026</code>, <code>storageMigrations</code>) get explicit conditions in the <code>curriculum/{docId}</code> block.</li>
  <li><strong>Backups (checked Sep 29):</strong> <code>backup.js</code> fetches <em>every</em> document in each listed collection (<code>fetchCollection</code>, <code>:221-247</code>), so <code>lessons_spring-2026</code> and <code>storageMigrations</code> are in every 30-minute backup automatically. The Tier-1 count check counts documents, and <code>curriculum</code> gains two, so there's no false alarm there. The per-teacher content count is covered by the five-line edit.</li>
  <li><strong>Snapshot:</strong> a JSON download right before the move, plus <code>tinker-backups/backup.js</code>'s automatic 30-minute backups of the <code>curriculum</code> collection (Tier 1).</li>
  <li><strong>Atomic:</strong> the copy, the old-copy removal and the migration record are one transaction.</li>
  <li><strong>Verified</strong> from forced-server reads while edits are paused by rule, before anything is unpaused.</li>
  <li><strong>Reversible:</strong> a reverse transaction until verified. After that, the download and backups.</li>
  <li><strong>Partial updates:</strong> per-field dotted paths as today. <code>saveLessonData</code>'s whole-semester merge-set becomes a whole-document merge-set for own-doc semesters (still <code>merge: true</code>).</li>
  <li><strong>Spot check:</strong> one Spring lesson in the Firebase Console after verification.</li>
</ul></div>

<h2 id="completeness">If interrupted</h2>
commit 126002ab710506386711b2cf3e98343d11f40a9d
Author: Christie Hubley <christie@tinkerartstudio.com>
Date:   Wed Sep 30 13:44:06 2026 -0600

    Phase C procedure review round 2: refuse reserved keys; never undo from a mismatched copy
    
    Codex round 2 (items 1–3 resolved; two new safeguards):
    - A Spring lesson keyed lastUpdated / lastUpdatedBy would be overwritten by the new
      document's own stamps: refused before confirmation and again inside the transaction.
    - Automatic undo only when the new document matches the recorded count + fingerprint
      (checked in verification AND again inside the undo transaction). Otherwise nothing
      is touched: Spring stays read-only in its new document and recovery uses the backup.
    
    Rehearsal: 15 tests (+ tampered copy is never used to undo; reserved key refused).
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/e2e/spring-move-procedure.spec.js b/e2e/spring-move-procedure.spec.js
index 70d9849..c216e50 100644
--- a/e2e/spring-move-procedure.spec.js
+++ b/e2e/spring-move-procedure.spec.js
@@ -219,4 +219,30 @@ test.describe('Spring 2026 move procedure (Phase C rehearsal)', () => {
     expect(moved.toMillis()).toBe(Date.parse('2026-03-01T12:00:00Z'));   // still a real Timestamp
     await ctx.close();
   });
+
+  test('a new document that does NOT match the record is never used to undo: everything left as is, read-only', async ({ browser }) => {
+    const { ctx, page } = await openAs(browser, 'manager');
+    expect((await runProcedure(page, { opts: { stopAfterMove: true } })).result.stage).toBe('moved');
+    await SM.writeCurriculumDoc(SM.SPRING_DOC, { [LESSON]: { teacher: 'Tampered' } }, { merge: true });   // (admin SDK; the rules forbid this for clients)
+    const before = await snapshotAll();
+    const again = await page.evaluate(() => springMove());
+    expect(again.ok).toBe(false);
+    expect(again.needsRecovery).toBe(true);
+    expect(again.message).toMatch(/NOT used to undo/);
+    expect(await snapshotAll()).toEqual(before);
+    expect(before.migrations['spring-2026'].verified).toBe(false);
+    await ctx.close();
+  });
+
+  test("a lesson named like the new document's own fields is refused before anything changes", async ({ browser }) => {
+    await SM.writeCurriculumDoc('lessonData', { 'spring-2026': { lastUpdated: { teacher: 'X' } } }, { merge: true });
+    const before = await snapshotAll();
+    const { ctx, page } = await openAs(browser, 'manager');
+    const { result, download } = await runProcedure(page);
+    expect(result.ok).toBe(false);
+    expect(result.message).toMatch(/clashes with the new document's own fields/);
+    expect(download).toBeNull();
+    expect(await snapshotAll()).toEqual(before);
+    await ctx.close();
+  });
 });
diff --git a/scripts/spring-2026-move.console.js b/scripts/spring-2026-move.console.js
index bf8a9df..eb7a5b4 100644
--- a/scripts/spring-2026-move.console.js
+++ b/scripts/spring-2026-move.console.js
@@ -70,6 +70,10 @@ async function springMove(opts = {}) {
     return [...new Uint8Array(digest)].map(b => b.toString(16).padStart(2, '0')).join('');
   };
   const lessonsOf = (data) => { const m = { ...(data || {}) }; delete m.lastUpdated; delete m.lastUpdatedBy; return m; };
+  // The new document's own bookkeeping fields — a lesson with one of these keys would be
+  // overwritten, so it's refused up front.
+  const RESERVED = ['lastUpdated', 'lastUpdatedBy'];
+  const reservedIn = (map) => RESERVED.filter(k => Object.prototype.hasOwnProperty.call(map || {}, k));
   const readAll = () => Promise.all([
     ref('lessonData').get({ source: 'server' }),
     ref(TARGET).get({ source: 'server' }),
@@ -88,6 +92,7 @@ async function springMove(opts = {}) {
     // ── Not moved yet: validate, back up, confirm, move. ──
     const springMap = ld.data()[K];
     if (!springMap || typeof springMap !== 'object' || Array.isArray(springMap)) return stop('Spring 2026 in lessonData is not a map of lessons. Nothing was changed.');
+    if (reservedIn(springMap).length) return stop(`Spring 2026 has a lesson named ${reservedIn(springMap).join(', ')}, which clashes with the new document's own fields. Nothing was changed. Tell Claude.`);
     const encoded = encode(springMap, K);
     if (unsupported.length) return stop(`Spring 2026 holds values this procedure can't back up exactly:\n${unsupported.slice(0, 10).join('\n')}${unsupported.length > 10 ? `\n…and ${unsupported.length - 10} more` : ''}\n\nNothing was changed. Tell Claude.`);
     const count = Object.keys(springMap).length;
@@ -114,6 +119,7 @@ async function springMove(opts = {}) {
         if (m.exists && m.data()?.[K]) throw new Error('a move record appeared');
         const inTx = l.exists ? l.data()?.[K] : null;
         if (!inTx) throw new Error('Spring 2026 is no longer in lessonData');
+        if (reservedIn(inTx).length) throw new Error(`a lesson named ${reservedIn(inTx).join(', ')} appeared`);
         unsupported.length = 0;
         const enc = encode(inTx, K);
         if (unsupported.length) throw new Error(`unsupported values appeared: ${unsupported[0]}`);
@@ -137,6 +143,7 @@ async function springMove(opts = {}) {
   // ── Verify (fresh server reads). ──
   const problems = [];
   let l2, t2, rec;
+  let targetIntact = false;   // the new document matches the recorded count + fingerprint
   try {
     let m2;
     [l2, t2, m2] = await readAll();
@@ -147,14 +154,22 @@ async function springMove(opts = {}) {
     unsupported.length = 0;
     const encTarget = encode(targetLessons, TARGET);
     if (unsupported.length) problems.push(`the new document holds unsupported values (${unsupported[0]})`);
-    if (rec && Object.keys(targetLessons).length !== rec.lessonCount) problems.push(`lesson count ${Object.keys(targetLessons).length} ≠ recorded ${rec.lessonCount}`);
-    if (rec && (await sha256Of(encTarget)) !== rec.sha256) problems.push('the new document\'s fingerprint differs from the recorded one');
+    const countOk = !!rec && Object.keys(targetLessons).length === rec.lessonCount;
+    const hashOk = !!rec && !unsupported.length && (await sha256Of(encTarget)) === rec.sha256;
+    if (rec && !countOk) problems.push(`lesson count ${Object.keys(targetLessons).length} ≠ recorded ${rec.lessonCount}`);
+    if (rec && !hashOk) problems.push('the new document\'s fingerprint differs from the recorded one');
+    targetIntact = t2.exists && countOk && hashOk;
     if (l2.exists && Object.prototype.hasOwnProperty.call(l2.data() || {}, K)) problems.push('Spring 2026 is still in the shared document');
     if (opts.simulateVerifyFailure) problems.push('simulated failure (rehearsal)');
   } catch (err) {
     return stop(`Couldn't read back from the server to verify (${err.message}). Spring is safe in its new document and still read-only. Run this procedure again to finish.`, { stage: 'moved' });
   }
 
+  if (problems.length && !targetIntact) {
+    // Never restore FROM a copy that doesn't match what was moved.
+    console.error('[spring-move] Verification failed and the new document does not match the record:', problems);
+    return stop(`Verification failed (${problems.join('; ')}) and the new document doesn't match what was moved, so it was NOT used to undo anything. Everything is left as it is and Spring stays read-only. Don't retry — tell Claude; recovery uses your backup file.`, { stage: 'moved', needsRecovery: true });
+  }
   if (problems.length) {
     // ── Undo — ONE transaction: Spring back, new document and record removed. ──
     console.error('[spring-move] Verification failed:', problems);
@@ -166,7 +181,12 @@ async function springMove(opts = {}) {
         if (!t.exists) throw new Error('the new document is already gone');
         if (m.data()?.[K]?.verified === true) throw new Error('the move is already verified');
         if (l.exists && Object.prototype.hasOwnProperty.call(l.data() || {}, K)) throw new Error('Spring 2026 is already back in lessonData');
-        tx.update(ref('lessonData'), { [K]: lessonsOf(t.data()) });
+        const back = lessonsOf(t.data());
+        unsupported.length = 0;
+        const encBack = encode(back, TARGET);
+        const r = m.data()?.[K];
+        if (!r || unsupported.length || Object.keys(back).length !== r.lessonCount || (await sha256Of(encBack)) !== r.sha256) throw new Error('the new document no longer matches the record');
+        tx.update(ref('lessonData'), { [K]: back });
         tx.delete(ref(TARGET));
         tx.update(ref('storageMigrations'), { [K]: DELETE });
       });
71-  };
72-  const lessonsOf = (data) => { const m = { ...(data || {}) }; delete m.lastUpdated; delete m.lastUpdatedBy; return m; };
73-  // The new document's own bookkeeping fields — a lesson with one of these keys would be
74-  // overwritten, so it's refused up front.
75-  const RESERVED = ['lastUpdated', 'lastUpdatedBy'];
76:  const reservedIn = (map) => RESERVED.filter(k => Object.prototype.hasOwnProperty.call(map || {}, k));
77-  const readAll = () => Promise.all([
78-    ref('lessonData').get({ source: 'server' }),
79-    ref(TARGET).get({ source: 'server' }),
80-    ref('storageMigrations').get({ source: 'server' }),
81-  ]);
--
90-
91-  if (inLessonData && !tgt.exists && !record) {
92-    // ── Not moved yet: validate, back up, confirm, move. ──
93-    const springMap = ld.data()[K];
94-    if (!springMap || typeof springMap !== 'object' || Array.isArray(springMap)) return stop('Spring 2026 in lessonData is not a map of lessons. Nothing was changed.');
95:    if (reservedIn(springMap).length) return stop(`Spring 2026 has a lesson named ${reservedIn(springMap).join(', ')}, which clashes with the new document's own fields. Nothing was changed. Tell Claude.`);
96-    const encoded = encode(springMap, K);
97-    if (unsupported.length) return stop(`Spring 2026 holds values this procedure can't back up exactly:\n${unsupported.slice(0, 10).join('\n')}${unsupported.length > 10 ? `\n…and ${unsupported.length - 10} more` : ''}\n\nNothing was changed. Tell Claude.`);
98-    const count = Object.keys(springMap).length;
99-    const fingerprint = await sha256Of(encoded);
100-    say(`Spring 2026: ${count} lessons, fingerprint ${fingerprint.slice(0, 12)}…`);
--
117-        const m = await tx.get(ref('storageMigrations'));
118-        if (t.exists) throw new Error(`${TARGET} appeared`);
119-        if (m.exists && m.data()?.[K]) throw new Error('a move record appeared');
120-        const inTx = l.exists ? l.data()?.[K] : null;
121-        if (!inTx) throw new Error('Spring 2026 is no longer in lessonData');
122:        if (reservedIn(inTx).length) throw new Error(`a lesson named ${reservedIn(inTx).join(', ')} appeared`);
123-        unsupported.length = 0;
124-        const enc = encode(inTx, K);
125-        if (unsupported.length) throw new Error(`unsupported values appeared: ${unsupported[0]}`);
126-        tx.set(ref(TARGET), { ...inTx, lastUpdated: movedAt, lastUpdatedBy: by });
127-        tx.update(ref('lessonData'), { [K]: DELETE });
--
164-  } catch (err) {
165-    return stop(`Couldn't read back from the server to verify (${err.message}). Spring is safe in its new document and still read-only. Run this procedure again to finish.`, { stage: 'moved' });
166-  }
167-
168-  if (problems.length && !targetIntact) {
169:    // Never restore FROM a copy that doesn't match what was moved.
170-    console.error('[spring-move] Verification failed and the new document does not match the record:', problems);
171:    return stop(`Verification failed (${problems.join('; ')}) and the new document doesn't match what was moved, so it was NOT used to undo anything. Everything is left as it is and Spring stays read-only. Don't retry — tell Claude; recovery uses your backup file.`, { stage: 'moved', needsRecovery: true });
172-  }
173-  if (problems.length) {
174-    // ── Undo — ONE transaction: Spring back, new document and record removed. ──
175-    console.error('[spring-move] Verification failed:', problems);
176-    try {
--
189-        tx.update(ref('lessonData'), { [K]: back });
190-        tx.delete(ref(TARGET));
191-        tx.update(ref('storageMigrations'), { [K]: DELETE });
192-      });
193-    } catch (err) {
194:      return stop(`Verification failed (${problems.join('; ')}), and the automatic undo didn't go through (${err.message}). The undo is all-or-nothing, so Spring is still safe in its new document (read-only), and it's in your backup file. Don't retry — tell Claude.`, { stage: 'moved' });
195-    }
196:    return stop(`Verification failed (${problems.join('; ')}), so the move was undone: Spring 2026 is back in the shared document exactly as before. Nothing was lost.`, { undone: true });
197-  }
198-
199-  // ── Mark verified — Spring becomes editable again. ──
200-  try {
201-    if (opts.failMarkVerified) throw new Error('simulated failure (rehearsal)');

exec
/bin/zsh -lc "tail -n 90 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC-r2-codex.md; nl -ba scripts/spring-2026-move.console.js | sed -n '55,215p'; sed -n '1,240p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC-r3.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
  1462	async function loadCutProjects() {
  1463	  if (!curriculumDb) initCurriculumFirestore();
  1464	  try {
  1465	    const doc = await curriculumDb.collection('curriculum').doc('cutProjects').get();
  1466	    currentCutProjects = doc.exists ? doc.data() : {};
  1467	  } catch (err) {
  1468	    console.error('Error loading cut projects:', err);
  1469	    currentCutProjects = {};
  1470	  }
  1471	  return currentCutProjects;
  1472	}
  1473	
  1474	async function saveCutProjects(semesterKey, projects) {
  1475	  if (!curriculumDb) initCurriculumFirestore();
  1476	  const user = getAuthUser();
  1477	  await curriculumDb.collection('curriculum').doc('cutProjects').set({
  1478	    [semesterKey]: projects,
  1479	    lastUpdated: new Date().toISOString(),
  1480	    lastUpdatedBy: user?.name || 'Unknown'
  1481	  }, { merge: true });
  1482	}
  1483	
  1484	// ─── Future Projects / Idea Bank (curriculum/futureProjects) ──
  1485	
  1486	async function loadFutureProjects() {
  1487	  if (!curriculumDb) initCurriculumFirestore();
  1488	  try {
  1489	    const doc = await curriculumDb.collection('curriculum').doc('futureProjects').get();
  1490	    currentFutureProjects = doc.exists ? doc.data() : { projects: [] };
  1491	  } catch (err) {
  1492	    console.error('Error loading future projects:', err);
  1493	    currentFutureProjects = { projects: [] };
  1494	  }
  1495	  return currentFutureProjects;
  1496	}
  1497	
  1498	async function saveFutureProjects(projects) {
  1499	  if (!curriculumDb) initCurriculumFirestore();
  1500	  const user = getAuthUser();
  1501	  await curriculumDb.collection('curriculum').doc('futureProjects').set({
  1502	    projects: projects,
  1503	    lastUpdated: new Date().toISOString(),
  1504	    lastUpdatedBy: user?.name || 'Unknown'
  1505	  });
  1506	  currentFutureProjects = { projects };
  1507	}
  1508	
  1509	// ─── Change Log (curriculum/changeLog) ───────────────
  1510	
  1511	async function loadChangeLog() {
  1512	  if (!curriculumDb) initCurriculumFirestore();
  1513	  try {
  1514	    const doc = await curriculumDb.collection('curriculum').doc('changeLog').get();
  1515	    currentChangeLog = doc.exists ? doc.data() : {};

codex
1. **RESOLVED** — undo now restores Spring, deletes the target, and removes the migration entry atomically ([spring-2026-move.console.js:162](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:162)).

2. **RESOLVED** — exact unverified-moved state resumes verification; verification-read and mark failures are retryable ([spring-2026-move.console.js:129](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:129)).

3. **RESOLVED** — canonical tagged Timestamps plus rejection of unsupported/non-lossless values before download/write ([spring-2026-move.console.js:44](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:44)).

4. **NOT—pending Christie’s go-ahead** ([backup.js:370](/Users/christiehubley/tinker-backups/backup.js:370)). The planned generic `lessons_*` tally immediately before `return counts`, followed by `node --check`, is sufficient; nothing else belongs in that edit.

New minimum findings:

- Reject source-map keys `lastUpdated` and `lastUpdatedBy` both before confirmation and inside the forward transaction. They are overwritten at line 120 and stripped during undo at lines 146/169, so such a key would be altered and then lost from live data.
- Never automatically restore from a target whose count/fingerprint failed verification. Lines 158–172 currently replace the source with the very data proven not to match. Only auto-undo when the target hash/count matches the recorded original; otherwise leave it read-only and require backup-assisted recovery.

All normal forward, verification, and three-write undo operations are allowed for a manager by rules `0caf415`, including the atomic migration-entry removal. Fall writes are preserved through transaction retries; an over-cap undo fails atomically and leaves the target recoverable.

**NOT SAFE TO RUN IN PRODUCTION — minimum: backup.js edit plus the two safeguards above.**
tokens used
48,684
1. **RESOLVED** — undo now restores Spring, deletes the target, and removes the migration entry atomically ([spring-2026-move.console.js:162](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:162)).

2. **RESOLVED** — exact unverified-moved state resumes verification; verification-read and mark failures are retryable ([spring-2026-move.console.js:129](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:129)).

3. **RESOLVED** — canonical tagged Timestamps plus rejection of unsupported/non-lossless values before download/write ([spring-2026-move.console.js:44](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:44)).

4. **NOT—pending Christie’s go-ahead** ([backup.js:370](/Users/christiehubley/tinker-backups/backup.js:370)). The planned generic `lessons_*` tally immediately before `return counts`, followed by `node --check`, is sufficient; nothing else belongs in that edit.

New minimum findings:

- Reject source-map keys `lastUpdated` and `lastUpdatedBy` both before confirmation and inside the forward transaction. They are overwritten at line 120 and stripped during undo at lines 146/169, so such a key would be altered and then lost from live data.
- Never automatically restore from a target whose count/fingerprint failed verification. Lines 158–172 currently replace the source with the very data proven not to match. Only auto-undo when the target hash/count matches the recorded original; otherwise leave it read-only and require backup-assisted recovery.

All normal forward, verification, and three-write undo operations are allowed for a manager by rules `0caf415`, including the atomic migration-entry removal. Fall writes are preserved through transaction retries; an over-cap undo fails atomically and leaves the target recoverable.

**NOT SAFE TO RUN IN PRODUCTION — minimum: backup.js edit plus the two safeguards above.**
    55	    if (isTimestamp(v)) return { [TS_TAG]: { seconds: v.seconds, nanoseconds: v.nanoseconds } };
    56	    if (Array.isArray(v)) return v.map((x, i) => encode(x, `${where}[${i}]`));
    57	    if (typeof v === 'object' && Object.getPrototypeOf(v) === Object.prototype) {
    58	      const out = {};
    59	      for (const k of Object.keys(v).sort()) {
    60	        if (k === TS_TAG) unsupported.push(`${where}: a field named ${TS_TAG}`);
    61	        out[k] = encode(v[k], `${where}.${k}`);
    62	      }
    63	      return out;
    64	    }
    65	    unsupported.push(`${where}: ${v?.constructor?.name || typeof v}`);
    66	    return null;
    67	  };
    68	  const sha256Of = async (encoded) => {
    69	    const digest = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(JSON.stringify(encoded)));
    70	    return [...new Uint8Array(digest)].map(b => b.toString(16).padStart(2, '0')).join('');
    71	  };
    72	  const lessonsOf = (data) => { const m = { ...(data || {}) }; delete m.lastUpdated; delete m.lastUpdatedBy; return m; };
    73	  // The new document's own bookkeeping fields — a lesson with one of these keys would be
    74	  // overwritten, so it's refused up front.
    75	  const RESERVED = ['lastUpdated', 'lastUpdatedBy'];
    76	  const reservedIn = (map) => RESERVED.filter(k => Object.prototype.hasOwnProperty.call(map || {}, k));
    77	  const readAll = () => Promise.all([
    78	    ref('lessonData').get({ source: 'server' }),
    79	    ref(TARGET).get({ source: 'server' }),
    80	    ref('storageMigrations').get({ source: 'server' }),
    81	  ]);
    82	
    83	  // ── Which state are we in? ──
    84	  let ld, tgt, mig;
    85	  try { [ld, tgt, mig] = await readAll(); } catch (err) {
    86	    return stop(`Couldn't read the current data from the server (${err.message}). Nothing was changed.`);
    87	  }
    88	  const inLessonData = ld.exists && Object.prototype.hasOwnProperty.call(ld.data() || {}, K);
    89	  const record = mig.exists ? mig.data()?.[K] : undefined;
    90	
    91	  if (inLessonData && !tgt.exists && !record) {
    92	    // ── Not moved yet: validate, back up, confirm, move. ──
    93	    const springMap = ld.data()[K];
    94	    if (!springMap || typeof springMap !== 'object' || Array.isArray(springMap)) return stop('Spring 2026 in lessonData is not a map of lessons. Nothing was changed.');
    95	    if (reservedIn(springMap).length) return stop(`Spring 2026 has a lesson named ${reservedIn(springMap).join(', ')}, which clashes with the new document's own fields. Nothing was changed. Tell Claude.`);
    96	    const encoded = encode(springMap, K);
    97	    if (unsupported.length) return stop(`Spring 2026 holds values this procedure can't back up exactly:\n${unsupported.slice(0, 10).join('\n')}${unsupported.length > 10 ? `\n…and ${unsupported.length - 10} more` : ''}\n\nNothing was changed. Tell Claude.`);
    98	    const count = Object.keys(springMap).length;
    99	    const fingerprint = await sha256Of(encoded);
   100	    say(`Spring 2026: ${count} lessons, fingerprint ${fingerprint.slice(0, 12)}…`);
   101	
   102	    const fileName = `classbook-${K}-lessons-${new Date().toISOString().replace(/[:.]/g, '-')}.json`;
   103	    const backup = JSON.stringify({ semester: K, takenAt: new Date().toISOString(), takenBy: by, lessonCount: count, sha256: fingerprint, timestampTag: TS_TAG, lessons: encoded }, null, 2);
   104	    const link = document.createElement('a');
   105	    link.href = URL.createObjectURL(new Blob([backup], { type: 'application/json' }));
   106	    link.download = fileName;
   107	    document.body.appendChild(link); link.click(); link.remove();
   108	    if (!confirm(`A backup of Spring 2026 (${count} lessons) was just downloaded:\n\n${fileName}\n\nCheck it's in your Downloads folder, then press OK to move Spring 2026 into its own storage.\n\nCancel stops here — nothing is changed.`)) {
   109	      return stop('Cancelled before the move. Nothing was changed.');
   110	    }
   111	
   112	    const movedAt = new Date().toISOString();
   113	    try {
   114	      await db.runTransaction(async (tx) => {
   115	        const l = await tx.get(ref('lessonData'));
   116	        const t = await tx.get(ref(TARGET));
   117	        const m = await tx.get(ref('storageMigrations'));
   118	        if (t.exists) throw new Error(`${TARGET} appeared`);
   119	        if (m.exists && m.data()?.[K]) throw new Error('a move record appeared');
   120	        const inTx = l.exists ? l.data()?.[K] : null;
   121	        if (!inTx) throw new Error('Spring 2026 is no longer in lessonData');
   122	        if (reservedIn(inTx).length) throw new Error(`a lesson named ${reservedIn(inTx).join(', ')} appeared`);
   123	        unsupported.length = 0;
   124	        const enc = encode(inTx, K);
   125	        if (unsupported.length) throw new Error(`unsupported values appeared: ${unsupported[0]}`);
   126	        tx.set(ref(TARGET), { ...inTx, lastUpdated: movedAt, lastUpdatedBy: by });
   127	        tx.update(ref('lessonData'), { [K]: DELETE });
   128	        tx.set(ref('storageMigrations'), { [K]: { movedAt, movedBy: by, lessonCount: Object.keys(inTx).length, sha256: await sha256Of(enc), backupFile: fileName, verified: false } }, { merge: true });
   129	      });
   130	    } catch (err) {
   131	      return stop(`The move transaction didn't go through (${err.message}). It's all-or-nothing, so nothing was changed.`);
   132	    }
   133	    say('Moved. Verifying from the server…');
   134	    if (opts.stopAfterMove) return { ok: false, message: 'stopped after the move (rehearsal)', stage: 'moved' };
   135	  } else if (!inLessonData && tgt.exists && record && record.verified !== true) {
   136	    say('Found a move that was interrupted before it was verified — carrying on from there.');
   137	  } else if (!inLessonData && tgt.exists && record?.verified === true) {
   138	    return stop('Spring 2026 has already been moved and verified. Nothing to do; nothing was changed.', { alreadyDone: true });
   139	  } else {
   140	    return stop(`Unexpected state (in lessonData: ${inLessonData}, own document: ${tgt.exists}, record: ${record ? (record.verified ? 'verified' : 'unverified') : 'none'}). Nothing was changed. Tell Claude.`);
   141	  }
   142	
   143	  // ── Verify (fresh server reads). ──
   144	  const problems = [];
   145	  let l2, t2, rec;
   146	  let targetIntact = false;   // the new document matches the recorded count + fingerprint
   147	  try {
   148	    let m2;
   149	    [l2, t2, m2] = await readAll();
   150	    rec = m2.data()?.[K];
   151	    if (!rec) problems.push('the move record is missing');
   152	    if (!t2.exists) problems.push('the new document is missing');
   153	    const targetLessons = lessonsOf(t2.data());
   154	    unsupported.length = 0;
   155	    const encTarget = encode(targetLessons, TARGET);
   156	    if (unsupported.length) problems.push(`the new document holds unsupported values (${unsupported[0]})`);
   157	    const countOk = !!rec && Object.keys(targetLessons).length === rec.lessonCount;
   158	    const hashOk = !!rec && !unsupported.length && (await sha256Of(encTarget)) === rec.sha256;
   159	    if (rec && !countOk) problems.push(`lesson count ${Object.keys(targetLessons).length} ≠ recorded ${rec.lessonCount}`);
   160	    if (rec && !hashOk) problems.push('the new document\'s fingerprint differs from the recorded one');
   161	    targetIntact = t2.exists && countOk && hashOk;
   162	    if (l2.exists && Object.prototype.hasOwnProperty.call(l2.data() || {}, K)) problems.push('Spring 2026 is still in the shared document');
   163	    if (opts.simulateVerifyFailure) problems.push('simulated failure (rehearsal)');
   164	  } catch (err) {
   165	    return stop(`Couldn't read back from the server to verify (${err.message}). Spring is safe in its new document and still read-only. Run this procedure again to finish.`, { stage: 'moved' });
   166	  }
   167	
   168	  if (problems.length && !targetIntact) {
   169	    // Never restore FROM a copy that doesn't match what was moved.
   170	    console.error('[spring-move] Verification failed and the new document does not match the record:', problems);
   171	    return stop(`Verification failed (${problems.join('; ')}) and the new document doesn't match what was moved, so it was NOT used to undo anything. Everything is left as it is and Spring stays read-only. Don't retry — tell Claude; recovery uses your backup file.`, { stage: 'moved', needsRecovery: true });
   172	  }
   173	  if (problems.length) {
   174	    // ── Undo — ONE transaction: Spring back, new document and record removed. ──
   175	    console.error('[spring-move] Verification failed:', problems);
   176	    try {
   177	      await db.runTransaction(async (tx) => {
   178	        const l = await tx.get(ref('lessonData'));
   179	        const t = await tx.get(ref(TARGET));
   180	        const m = await tx.get(ref('storageMigrations'));
   181	        if (!t.exists) throw new Error('the new document is already gone');
   182	        if (m.data()?.[K]?.verified === true) throw new Error('the move is already verified');
   183	        if (l.exists && Object.prototype.hasOwnProperty.call(l.data() || {}, K)) throw new Error('Spring 2026 is already back in lessonData');
   184	        const back = lessonsOf(t.data());
   185	        unsupported.length = 0;
   186	        const encBack = encode(back, TARGET);
   187	        const r = m.data()?.[K];
   188	        if (!r || unsupported.length || Object.keys(back).length !== r.lessonCount || (await sha256Of(encBack)) !== r.sha256) throw new Error('the new document no longer matches the record');
   189	        tx.update(ref('lessonData'), { [K]: back });
   190	        tx.delete(ref(TARGET));
   191	        tx.update(ref('storageMigrations'), { [K]: DELETE });
   192	      });
   193	    } catch (err) {
   194	      return stop(`Verification failed (${problems.join('; ')}), and the automatic undo didn't go through (${err.message}). The undo is all-or-nothing, so Spring is still safe in its new document (read-only), and it's in your backup file. Don't retry — tell Claude.`, { stage: 'moved' });
   195	    }
   196	    return stop(`Verification failed (${problems.join('; ')}), so the move was undone: Spring 2026 is back in the shared document exactly as before. Nothing was lost.`, { undone: true });
   197	  }
   198	
   199	  // ── Mark verified — Spring becomes editable again. ──
   200	  try {
   201	    if (opts.failMarkVerified) throw new Error('simulated failure (rehearsal)');
   202	    await ref('storageMigrations').update({ [`${K}.verified`]: true, [`${K}.verifiedAt`]: new Date().toISOString(), [`${K}.verifiedBy`]: by });
   203	  } catch (err) {
   204	    return stop(`The move is done and checked, but marking it verified failed (${err.message}). Spring is safe and viewable; its edits stay paused. Run this procedure again to finish.`, { stage: 'moved' });
   205	  }
   206	  const kb = typeof approxFirestoreSize === 'function' ? Math.round(approxFirestoreSize(l2.data() || {}) / 1024) : null;
   207	  const msg = `Spring 2026 moved and verified: ${rec.lessonCount} lessons, fingerprint ${String(rec.sha256).slice(0, 12)}…` + (kb !== null ? `\nShared lesson storage is now about ${kb} KB of 1,024 KB.` : '');
   208	  say(msg);
   209	  alert(`Done ✓\n\n${msg}\n\nSpring 2026 is editable again. Keep the backup file${rec.backupFile ? ` ${rec.backupFile}` : ''}.`);
   210	  return { ok: true, message: msg, count: rec.lessonCount, sha256: rec.sha256, lessonDataKB: kb, fileName: rec.backupFile };
   211	}
   212	
   213	// Pasted into the console: run it. (The e2e rehearsal sets __SPRING_MOVE_NO_AUTORUN and calls springMove() itself.)
   214	if (!window.__SPRING_MOVE_NO_AUTORUN) springMove();
commit 126002ab710506386711b2cf3e98343d11f40a9d
Author: Christie Hubley <christie@tinkerartstudio.com>
Date:   Wed Sep 30 13:44:06 2026 -0600

    Phase C procedure review round 2: refuse reserved keys; never undo from a mismatched copy
    
    Codex round 2 (items 1–3 resolved; two new safeguards):
    - A Spring lesson keyed lastUpdated / lastUpdatedBy would be overwritten by the new
      document's own stamps: refused before confirmation and again inside the transaction.
    - Automatic undo only when the new document matches the recorded count + fingerprint
      (checked in verification AND again inside the undo transaction). Otherwise nothing
      is touched: Spring stays read-only in its new document and recovery uses the backup.
    
    Rehearsal: 15 tests (+ tampered copy is never used to undo; reserved key refused).
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/e2e/spring-move-procedure.spec.js b/e2e/spring-move-procedure.spec.js
index 70d9849..c216e50 100644
--- a/e2e/spring-move-procedure.spec.js
+++ b/e2e/spring-move-procedure.spec.js
@@ -219,4 +219,30 @@ test.describe('Spring 2026 move procedure (Phase C rehearsal)', () => {
     expect(moved.toMillis()).toBe(Date.parse('2026-03-01T12:00:00Z'));   // still a real Timestamp
     await ctx.close();
   });
+
+  test('a new document that does NOT match the record is never used to undo: everything left as is, read-only', async ({ browser }) => {
+    const { ctx, page } = await openAs(browser, 'manager');
+    expect((await runProcedure(page, { opts: { stopAfterMove: true } })).result.stage).toBe('moved');
+    await SM.writeCurriculumDoc(SM.SPRING_DOC, { [LESSON]: { teacher: 'Tampered' } }, { merge: true });   // (admin SDK; the rules forbid this for clients)
+    const before = await snapshotAll();
+    const again = await page.evaluate(() => springMove());
+    expect(again.ok).toBe(false);
+    expect(again.needsRecovery).toBe(true);
+    expect(again.message).toMatch(/NOT used to undo/);
+    expect(await snapshotAll()).toEqual(before);
+    expect(before.migrations['spring-2026'].verified).toBe(false);
+    await ctx.close();
+  });
+
+  test("a lesson named like the new document's own fields is refused before anything changes", async ({ browser }) => {
+    await SM.writeCurriculumDoc('lessonData', { 'spring-2026': { lastUpdated: { teacher: 'X' } } }, { merge: true });
+    const before = await snapshotAll();
+    const { ctx, page } = await openAs(browser, 'manager');
+    const { result, download } = await runProcedure(page);
+    expect(result.ok).toBe(false);
+    expect(result.message).toMatch(/clashes with the new document's own fields/);
+    expect(download).toBeNull();
+    expect(await snapshotAll()).toEqual(before);
+    await ctx.close();
+  });
 });
diff --git a/scripts/spring-2026-move.console.js b/scripts/spring-2026-move.console.js
index bf8a9df..eb7a5b4 100644
--- a/scripts/spring-2026-move.console.js
+++ b/scripts/spring-2026-move.console.js
@@ -70,6 +70,10 @@ async function springMove(opts = {}) {
     return [...new Uint8Array(digest)].map(b => b.toString(16).padStart(2, '0')).join('');
   };
   const lessonsOf = (data) => { const m = { ...(data || {}) }; delete m.lastUpdated; delete m.lastUpdatedBy; return m; };
+  // The new document's own bookkeeping fields — a lesson with one of these keys would be
+  // overwritten, so it's refused up front.
+  const RESERVED = ['lastUpdated', 'lastUpdatedBy'];
+  const reservedIn = (map) => RESERVED.filter(k => Object.prototype.hasOwnProperty.call(map || {}, k));
   const readAll = () => Promise.all([
     ref('lessonData').get({ source: 'server' }),
     ref(TARGET).get({ source: 'server' }),
@@ -88,6 +92,7 @@ async function springMove(opts = {}) {
     // ── Not moved yet: validate, back up, confirm, move. ──
     const springMap = ld.data()[K];
     if (!springMap || typeof springMap !== 'object' || Array.isArray(springMap)) return stop('Spring 2026 in lessonData is not a map of lessons. Nothing was changed.');
+    if (reservedIn(springMap).length) return stop(`Spring 2026 has a lesson named ${reservedIn(springMap).join(', ')}, which clashes with the new document's own fields. Nothing was changed. Tell Claude.`);
     const encoded = encode(springMap, K);
     if (unsupported.length) return stop(`Spring 2026 holds values this procedure can't back up exactly:\n${unsupported.slice(0, 10).join('\n')}${unsupported.length > 10 ? `\n…and ${unsupported.length - 10} more` : ''}\n\nNothing was changed. Tell Claude.`);
     const count = Object.keys(springMap).length;
@@ -114,6 +119,7 @@ async function springMove(opts = {}) {
         if (m.exists && m.data()?.[K]) throw new Error('a move record appeared');
         const inTx = l.exists ? l.data()?.[K] : null;
         if (!inTx) throw new Error('Spring 2026 is no longer in lessonData');
+        if (reservedIn(inTx).length) throw new Error(`a lesson named ${reservedIn(inTx).join(', ')} appeared`);
         unsupported.length = 0;
         const enc = encode(inTx, K);
         if (unsupported.length) throw new Error(`unsupported values appeared: ${unsupported[0]}`);
@@ -137,6 +143,7 @@ async function springMove(opts = {}) {
   // ── Verify (fresh server reads). ──
   const problems = [];
   let l2, t2, rec;
+  let targetIntact = false;   // the new document matches the recorded count + fingerprint
   try {
     let m2;
     [l2, t2, m2] = await readAll();
@@ -147,14 +154,22 @@ async function springMove(opts = {}) {
     unsupported.length = 0;
     const encTarget = encode(targetLessons, TARGET);
     if (unsupported.length) problems.push(`the new document holds unsupported values (${unsupported[0]})`);
-    if (rec && Object.keys(targetLessons).length !== rec.lessonCount) problems.push(`lesson count ${Object.keys(targetLessons).length} ≠ recorded ${rec.lessonCount}`);
-    if (rec && (await sha256Of(encTarget)) !== rec.sha256) problems.push('the new document\'s fingerprint differs from the recorded one');
+    const countOk = !!rec && Object.keys(targetLessons).length === rec.lessonCount;
+    const hashOk = !!rec && !unsupported.length && (await sha256Of(encTarget)) === rec.sha256;
+    if (rec && !countOk) problems.push(`lesson count ${Object.keys(targetLessons).length} ≠ recorded ${rec.lessonCount}`);
+    if (rec && !hashOk) problems.push('the new document\'s fingerprint differs from the recorded one');
+    targetIntact = t2.exists && countOk && hashOk;
     if (l2.exists && Object.prototype.hasOwnProperty.call(l2.data() || {}, K)) problems.push('Spring 2026 is still in the shared document');
     if (opts.simulateVerifyFailure) problems.push('simulated failure (rehearsal)');
   } catch (err) {
     return stop(`Couldn't read back from the server to verify (${err.message}). Spring is safe in its new document and still read-only. Run this procedure again to finish.`, { stage: 'moved' });
   }
 
+  if (problems.length && !targetIntact) {
+    // Never restore FROM a copy that doesn't match what was moved.
+    console.error('[spring-move] Verification failed and the new document does not match the record:', problems);
+    return stop(`Verification failed (${problems.join('; ')}) and the new document doesn't match what was moved, so it was NOT used to undo anything. Everything is left as it is and Spring stays read-only. Don't retry — tell Claude; recovery uses your backup file.`, { stage: 'moved', needsRecovery: true });
+  }
   if (problems.length) {
     // ── Undo — ONE transaction: Spring back, new document and record removed. ──
     console.error('[spring-move] Verification failed:', problems);
@@ -166,7 +181,12 @@ async function springMove(opts = {}) {
         if (!t.exists) throw new Error('the new document is already gone');
         if (m.data()?.[K]?.verified === true) throw new Error('the move is already verified');
         if (l.exists && Object.prototype.hasOwnProperty.call(l.data() || {}, K)) throw new Error('Spring 2026 is already back in lessonData');
-        tx.update(ref('lessonData'), { [K]: lessonsOf(t.data()) });
+        const back = lessonsOf(t.data());
+        unsupported.length = 0;
+        const encBack = encode(back, TARGET);
+        const r = m.data()?.[K];
+        if (!r || unsupported.length || Object.keys(back).length !== r.lessonCount || (await sha256Of(encBack)) !== r.sha256) throw new Error('the new document no longer matches the record');
+        tx.update(ref('lessonData'), { [K]: back });
         tx.delete(ref(TARGET));
         tx.update(ref('storageMigrations'), { [K]: DELETE });
       });

codex
- **Reserved keys: RESOLVED** — rejected before backup/confirmation and rechecked inside the transaction ([spring-2026-move.console.js:75](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:75), [line 95](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:95), [line 122](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:122)).

- **No undo from mismatched copy: RESOLVED** — verification refuses automatic undo unless count and fingerprint match, and the transaction rechecks them before writing ([line 157](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:157), [line 168](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:168), [line 184](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:184)).

The fix introduced nothing wrong in this narrow review.

**SAFE TO RUN IN PRODUCTION after the backup.js edit.**
tokens used
23,757
- **Reserved keys: RESOLVED** — rejected before backup/confirmation and rechecked inside the transaction ([spring-2026-move.console.js:75](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:75), [line 95](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:95), [line 122](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:122)).

- **No undo from mismatched copy: RESOLVED** — verification refuses automatic undo unless count and fingerprint match, and the transaction rechecks them before writing ([line 157](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:157), [line 168](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:168), [line 184](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:184)).

The fix introduced nothing wrong in this narrow review.

**SAFE TO RUN IN PRODUCTION after the backup.js edit.**
