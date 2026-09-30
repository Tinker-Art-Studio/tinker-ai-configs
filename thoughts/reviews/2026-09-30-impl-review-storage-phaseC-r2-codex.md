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
<ul>
  <li><strong>After A:</strong> Spring is view-only, and nothing else changes.</li>
  <li><strong>After B:</strong> the same, plus the readout and fixed Studio Hub alerts.</li>
  <li><strong>Mid-C:</strong> the transaction either committed or didn't. If it committed but isn't verified, Spring is viewable, edits are paused, and the reverse transaction exists.</li>
</ul>

<h2 id="resume">Resume instructions</h2>
<ol>
  <li>Read this plan and its Decisions Log. Re-measure lessonData first.</li>
  <li>Phase A in <code>studio-hub</code> (branch, merge to main, then the guard). Phase B in a Classbook worktree off <code>origin/main</code>, plus Studio Hub for the alerts. Re-check the line numbers.</li>
  <li>Per phase: commit, run the full suite, then a second-model implementation review. Each deploy, the backup.js edit, and Phase C each need Christie's own yes. Phase A needs the sha phrase.</li>
</ol>

<h2 id="decisions">Decisions Log (append-only)</h2>
<div class="decision">
  <strong>Sep 30, 2026: the 3-day stale-tab wait is dropped (Christie).</strong> Everyone works in Fall. A pre-Phase-B tab can't lose data, because the Phase A rules refuse its Spring writes, and Fall is untouched by the move. The only effect is that Spring may <em>look</em> empty in such a tab until it's refreshed, which Christie accepts. The move is planned for tonight, Sep 30, after the procedure is written, rehearsed in the emulator and reviewed, and after the backup.js edit. The staff "please refresh" note is optional.
</div>
<div class="decision">
  <strong>Sep 30, 2026: Phase B (Studio Hub) DEPLOYED, so Phase B is complete.</strong> Christie approved. studio-hub PR #3 was merged as <code>a254b15</code>: the Q&amp;A alerts union (<code>bd5fd10</code>, <code>85a488c</code>) plus the publishing fix (<code>4b785ca</code>, <code>943d760</code>). Studio Hub now publishes only a <code>git archive</code> allow-list through <code>npm run deploy</code> (pinned site id). The live check was ok: every file MATCH, and all 18 previously exposed private paths are GONE (including <code>setup/migration-log.txt</code> with staff names and uids, and <code>firebase-agent-defense-hardening.md</code>).<br>
commit 058f64f2f88cf1185cf634100dd3b89f9058c5bd
Author: Christie Hubley <christie@tinkerartstudio.com>
Date:   Wed Sep 30 13:39:48 2026 -0600

    Phase C procedure review fixes: re-runnable, atomic undo, exact-types only
    
    Codex review of 05b159b (NOT safe to run):
    - Undo is now ONE transaction: Spring back into lessonData, lessons_spring-2026
      deleted AND the move record removed (the old separate record cleanup could leave a
      stale record that blocked any re-run).
    - Re-runnable: the procedure detects the state first — not moved → move; moved but
      unverified (tab closed, read failure, mark-verified failure) → carries on to verify
      and mark verified or undo; already verified → says so and changes nothing; anything
      else → stops. Verification now checks against the server's move record.
    - Exact types only: before any download or change, every Spring value must be a
      JSON-exact type (finite non -0 numbers, strings, booleans, null, arrays, plain maps)
      or a Firestore Timestamp (tagged __firestoreTimestamp in both the fingerprint and
      the backup); GeoPoint, Bytes, references, NaN/Infinity, or a map already using the
      tag stop the run with the offending paths listed.
    
    Rehearsal (13 tests, deployed rules): + Fall preserved incl. a Fall save while the
    confirmation is open, resume after an interruption right after the move, resume after
    a mark-verified failure, re-run after success = no change, GeoPoint / NaN refused
    before download, Timestamp moved exactly and tagged in the backup.
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/e2e/helpers/storage-move.js b/e2e/helpers/storage-move.js
index 670fa3f..d6e0d5a 100644
--- a/e2e/helpers/storage-move.js
+++ b/e2e/helpers/storage-move.js
@@ -59,4 +59,14 @@ async function deleteCurriculumDoc(docId) {
   await adminDb().collection('curriculum').doc(docId).delete();
 }
 
-module.exports = { SPRING, SPRING_DOC, springFixture, resetStorageMove, stageMoved, readCurriculumDoc, writeCurriculumDoc, deleteCurriculumDoc };
+// Writes a Firestore-typed value into one Spring lesson in lessonData (for the procedure's
+// "only exactly-representable values" check): 'timestamp' | 'geopoint' | 'nan'.
+async function writeSpringTypedValue(lessonKey, field, kind) {
+  const admin = require('firebase-admin');
+  const value = kind === 'timestamp' ? admin.firestore.Timestamp.fromMillis(Date.parse('2026-03-01T12:00:00Z'))
+    : kind === 'geopoint' ? new admin.firestore.GeoPoint(40.0, -105.3)
+    : kind === 'nan' ? NaN : null;
+  await adminDb().collection('curriculum').doc('lessonData').update({ [`${SPRING}.${lessonKey}.${field}`]: value });
+}
+
+module.exports = { writeSpringTypedValue, SPRING, SPRING_DOC, springFixture, resetStorageMove, stageMoved, readCurriculumDoc, writeCurriculumDoc, deleteCurriculumDoc };
diff --git a/e2e/spring-move-procedure.spec.js b/e2e/spring-move-procedure.spec.js
index d74ed9e..70d9849 100644
--- a/e2e/spring-move-procedure.spec.js
+++ b/e2e/spring-move-procedure.spec.js
@@ -26,9 +26,13 @@ async function openAs(browser, role) {
   return { ctx, page };
 }
 // Loads the procedure without auto-running; dialogs answered by `answerConfirm`.
-async function runProcedure(page, { answerConfirm = true, opts = {} } = {}) {
+async function runProcedure(page, { answerConfirm = true, opts = {}, beforeConfirm = null } = {}) {
   const dialogs = [];
-  page.on('dialog', d => { dialogs.push(`${d.type()}: ${d.message()}`); d.type() === 'confirm' ? (answerConfirm ? d.accept() : d.dismiss()) : d.accept(); });
+  page.on('dialog', async d => {
+    dialogs.push(`${d.type()}: ${d.message()}`);
+    if (d.type() === 'confirm') { if (beforeConfirm) await beforeConfirm(); return answerConfirm ? d.accept() : d.dismiss(); }
+    return d.accept();
+  });
   await page.addScriptTag({ content: `window.__SPRING_MOVE_NO_AUTORUN = true;\n${PROCEDURE}` });
   const downloadPromise = page.waitForEvent('download', { timeout: 15_000 }).catch(() => null);
   const result = await page.evaluate((o) => springMove(o), opts);
@@ -112,7 +116,7 @@ test.describe('Spring 2026 move procedure (Phase C rehearsal)', () => {
     const { ctx, page } = await openAs(browser, 'manager');
     const { result, download } = await runProcedure(page);
     expect(result.ok).toBe(false);
-    expect(result.message).toMatch(/Nothing was changed/);
+    expect(result.message).toMatch(/already been moved and verified.*nothing was changed/i);
     expect(download).toBeNull();
     expect(await snapshotAll()).toEqual(before);
     await ctx.close();
@@ -141,4 +145,78 @@ test.describe('Spring 2026 move procedure (Phase C rehearsal)', () => {
     expect((await SM.readCurriculumDoc('lessonData'))['spring-2026']).toBeUndefined();
     await ctx.close();
   });
+
+  test('Fall is preserved, including a Fall save made while the confirmation is open', async ({ browser }) => {
+    await SM.writeCurriculumDoc('lessonData', { 'fall-2026': { 'fall-1': { teacher: 'T', shortDetails: 'Fall before' } } }, { merge: true });
+    const { ctx, page } = await openAs(browser, 'manager');
+    const { result } = await runProcedure(page, {
+      beforeConfirm: () => SM.writeCurriculumDoc('lessonData', { 'fall-2026': { 'fall-1': { teacher: 'T', shortDetails: 'Fall edited mid-move' } } }, { merge: true }),
+    });
+    expect(result.ok, JSON.stringify(result)).toBe(true);
+    const ld = await SM.readCurriculumDoc('lessonData');
+    expect(ld['fall-2026']['fall-1'].shortDetails).toBe('Fall edited mid-move');
+    expect(ld['spring-2026']).toBeUndefined();
+    expect(Object.keys(ld).sort()).toEqual(['fall-2026', 'lastUpdated', 'lastUpdatedBy']);
+    await ctx.close();
+  });
+
+  test('interrupted right after the move: re-running finishes it (verify + mark verified)', async ({ browser }) => {
+    const { ctx, page } = await openAs(browser, 'manager');
+    const first = await runProcedure(page, { opts: { stopAfterMove: true } });
+    expect(first.result.stage).toBe('moved');
+    expect((await SM.readCurriculumDoc('storageMigrations'))['spring-2026'].verified).toBe(false);
+    await page.waitForFunction(() => ownDocSource['spring-2026'] === 'ownDoc');
+    expect(await page.evaluate(() => weeklySemesterPausedMessage('spring-2026'))).toMatch(/editing it is paused/);   // read-only meanwhile
+    const again = await page.evaluate(() => springMove());
+    expect(again.ok, JSON.stringify(again)).toBe(true);
+    expect(stripStamps(await SM.readCurriculumDoc(SM.SPRING_DOC))).toEqual(SM.springFixture());
+    expect((await SM.readCurriculumDoc('storageMigrations'))['spring-2026'].verified).toBe(true);
+    await ctx.close();
+  });
+
+  test('marking verified fails: re-running finishes it', async ({ browser }) => {
+    const { ctx, page } = await openAs(browser, 'manager');
+    const first = await runProcedure(page, { opts: { failMarkVerified: true } });
+    expect(first.result.ok).toBe(false);
+    expect(first.result.message).toMatch(/Run this procedure again to finish/);
+    const again = await page.evaluate(() => springMove());
+    expect(again.ok, JSON.stringify(again)).toBe(true);
+    await ctx.close();
+  });
+
+  test('re-running after success says it is already done and changes nothing', async ({ browser }) => {
+    const { ctx, page } = await openAs(browser, 'manager');
+    expect((await runProcedure(page)).result.ok).toBe(true);
+    const before = await snapshotAll();
+    const again = await page.evaluate(() => springMove());
+    expect(again.alreadyDone).toBe(true);
+    expect(await snapshotAll()).toEqual(before);
+    await ctx.close();
+  });
+
+  for (const kind of ['geopoint', 'nan']) {
+    test(`a value that can't be backed up exactly (${kind}) stops it before anything is downloaded or changed`, async ({ browser }) => {
+      await SM.writeSpringTypedValue(LESSON, 'odd', kind);
+      const before = await snapshotAll();
+      const { ctx, page } = await openAs(browser, 'manager');
+      const { result, download } = await runProcedure(page);
+      expect(result.ok).toBe(false);
+      expect(result.message).toMatch(/can't back up exactly/);
+      expect(download).toBeNull();
+      expect(await snapshotAll()).toEqual(before);
+      await ctx.close();
+    });
+  }
+
+  test('a Firestore Timestamp is moved exactly and tagged in the backup', async ({ browser }) => {
+    await SM.writeSpringTypedValue(LESSON, 'reviewedAt', 'timestamp');
+    const { ctx, page } = await openAs(browser, 'manager');
+    const { result, download } = await runProcedure(page);
+    expect(result.ok, JSON.stringify(result)).toBe(true);
+    const backup = JSON.parse(fs.readFileSync(await download.path(), 'utf8'));
+    expect(backup.lessons[LESSON].reviewedAt).toEqual({ __firestoreTimestamp: { seconds: Date.parse('2026-03-01T12:00:00Z') / 1000, nanoseconds: 0 } });
+    const moved = (await SM.readCurriculumDoc(SM.SPRING_DOC))[LESSON].reviewedAt;
+    expect(moved.toMillis()).toBe(Date.parse('2026-03-01T12:00:00Z'));   // still a real Timestamp
+    await ctx.close();
+  });
 });
diff --git a/scripts/spring-2026-move.console.js b/scripts/spring-2026-move.console.js
index da9a3f6..bf8a9df 100644
--- a/scripts/spring-2026-move.console.js
+++ b/scripts/spring-2026-move.console.js
@@ -5,31 +5,32 @@
 // browser console (⌥⌘J), paste this WHOLE file, press Enter. It never runs on its own
 // from the site — this file isn't deployed (dist/ holds only the app).
 //
-// What it does, in order — stopping with "nothing was changed" at the first problem:
-//   1. Checks you're a manager and reads curriculum/lessonData, lessons_spring-2026 and
-//      storageMigrations fresh from the server: Spring must be in lessonData, its own
-//      document must not exist yet, and there must be no earlier move record.
-//   2. Downloads a JSON backup of Spring's lessons and asks you to confirm.
-//   3. ONE transaction: creates lessons_spring-2026 from the lessons read inside the
-//      transaction, removes spring-2026 from lessonData, and records the move
-//      (lesson count + SHA-256 fingerprint, verified: false). All or nothing.
-//   4. Verifies from fresh server reads: the new document's lessons have the same count
-//      and fingerprint, and lessonData no longer holds Spring. Spring edits are paused by
-//      the rules throughout, so nothing can change in between.
-//   5a. Passed → marks the move verified (Spring becomes editable again) and reports the
-//       new lessonData size.
-//   5b. Failed → one transaction puts Spring back into lessonData and removes the new
-//       document and the record (only allowed while unverified), exactly as before.
+// SAFE TO RE-RUN. It first works out which state the data is in:
+//   • not moved yet      → checks every value is a plain type it can back up exactly, downloads
+//                          a JSON backup, asks you to confirm, then moves Spring in ONE
+//                          transaction (create lessons_spring-2026 from the lessons read inside
+//                          the transaction, remove spring-2026 from lessonData, record count +
+//                          SHA-256 fingerprint with verified: false) — all or nothing;
+//   • moved, not verified (a previous run was interrupted) → carries on from here;
+//   • moved and verified  → says so and stops;
+//   • anything else       → stops without changing anything.
+// Then it VERIFIES from fresh server reads (the new document's lessons match the recorded
+// count and fingerprint, and lessonData no longer holds Spring — Spring edits are paused by the
+// rules throughout, so nothing can change in between), and either
+//   • marks the move verified (Spring becomes editable again), or
+//   • UNDOES it in ONE transaction: Spring back into lessonData, the new document and the move
+//     record removed — exactly the state before (allowed by the rules only while unverified).
 //
 // The Phase A rules (studio-hub 0caf415) allow exactly these writes and nothing else.
 async function springMove(opts = {}) {
   const K = 'spring-2026';
   const TARGET = 'lessons_spring-2026';
+  const TS_TAG = '__firestoreTimestamp';
   const say = (...a) => console.log('%c[spring-move]', 'color:#6052C8;font-weight:bold', ...a);
-  const stop = (msg) => {
+  const stop = (msg, extra = {}) => {
     console.error('[spring-move] STOPPED:', msg);
     alert(`Spring 2026 move STOPPED.\n\n${msg}`);
-    return { ok: false, message: msg };
+    return { ok: false, message: msg, ...extra };
   };
 
   const user = getAuthUser();
@@ -38,127 +39,155 @@ async function springMove(opts = {}) {
   const db = curriculumDb;
   const ref = (id) => db.collection('curriculum').doc(id);
   const by = user.name || user.email || 'Unknown';
+  const DELETE = firebase.firestore.FieldValue.delete();
 
-  // A fingerprint independent of key order: sorted keys, Timestamps as seconds/nanos.
-  const canon = (v) => {
-    if (v === null || typeof v !== 'object') return v;
-    if (typeof v.toDate === 'function' && 'seconds' in v) return { __ts: [v.seconds, v.nanoseconds] };
-    if (Array.isArray(v)) return v.map(canon);
-    const out = {};
-    for (const k of Object.keys(v).sort()) out[k] = canon(v[k]);
-    return out;
+  // Only values that round-trip exactly through JSON (plus Timestamps, tagged) are allowed —
+  // anything else (NaN, ±Infinity, -0, GeoPoint, Bytes, DocumentReference, a map already using
+  // the tag key…) is reported and the run stops before anything is downloaded or changed.
+  const unsupported = [];
+  const isTimestamp = (v) => v && typeof v === 'object' && typeof v.toDate === 'function' && typeof v.seconds === 'number' && typeof v.nanoseconds === 'number';
+  const encode = (v, where) => {
+    if (v === null || typeof v === 'string' || typeof v === 'boolean') return v;
+    if (typeof v === 'number') {
+      if (!Number.isFinite(v) || Object.is(v, -0)) unsupported.push(`${where}: number ${String(v)}`);
+      return v;
+    }
+    if (isTimestamp(v)) return { [TS_TAG]: { seconds: v.seconds, nanoseconds: v.nanoseconds } };
+    if (Array.isArray(v)) return v.map((x, i) => encode(x, `${where}[${i}]`));
+    if (typeof v === 'object' && Object.getPrototypeOf(v) === Object.prototype) {
+      const out = {};
+      for (const k of Object.keys(v).sort()) {
+        if (k === TS_TAG) unsupported.push(`${where}: a field named ${TS_TAG}`);
+        out[k] = encode(v[k], `${where}.${k}`);
+      }
+      return out;
+    }
+    unsupported.push(`${where}: ${v?.constructor?.name || typeof v}`);
+    return null;
   };
-  const sha256 = async (obj) => {
-    const bytes = new TextEncoder().encode(JSON.stringify(canon(obj)));
-    const digest = await crypto.subtle.digest('SHA-256', bytes);
+  const sha256Of = async (encoded) => {
+    const digest = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(JSON.stringify(encoded)));
     return [...new Uint8Array(digest)].map(b => b.toString(16).padStart(2, '0')).join('');
   };
   const lessonsOf = (data) => { const m = { ...(data || {}) }; delete m.lastUpdated; delete m.lastUpdatedBy; return m; };
+  const readAll = () => Promise.all([
+    ref('lessonData').get({ source: 'server' }),
+    ref(TARGET).get({ source: 'server' }),
+    ref('storageMigrations').get({ source: 'server' }),
+  ]);
 
-  // 1. Preflight — forced server reads.
+  // ── Which state are we in? ──
   let ld, tgt, mig;
-  try {
-    [ld, tgt, mig] = await Promise.all([
-      ref('lessonData').get({ source: 'server' }),
-      ref(TARGET).get({ source: 'server' }),
-      ref('storageMigrations').get({ source: 'server' }),
-    ]);
-  } catch (err) {
+  try { [ld, tgt, mig] = await readAll(); } catch (err) {
     return stop(`Couldn't read the current data from the server (${err.message}). Nothing was changed.`);
   }
-  const springMap = ld.exists ? ld.data()?.[K] : null;
-  if (!springMap || typeof springMap !== 'object') return stop('Spring 2026 is not in the shared lesson document — it may already have been moved. Nothing was changed.');
-  if (tgt.exists) return stop(`${TARGET} already exists. Nothing was changed.`);
-  if (mig.exists && mig.data()?.[K]) return stop('There is already a Spring 2026 move record. Nothing was changed.');
-  const count = Object.keys(springMap).length;
-  const fingerprint = await sha256(springMap);
// ─── Spring 2026 storage move — Phase C (one-off, run by a manager) ─────────────
// Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html
//
// HOW TO RUN: on https://tinker-classbook.netlify.app, signed in as a manager, open the
// browser console (⌥⌘J), paste this WHOLE file, press Enter. It never runs on its own
// from the site — this file isn't deployed (dist/ holds only the app).
//
// SAFE TO RE-RUN. It first works out which state the data is in:
//   • not moved yet      → checks every value is a plain type it can back up exactly, downloads
//                          a JSON backup, asks you to confirm, then moves Spring in ONE
//                          transaction (create lessons_spring-2026 from the lessons read inside
//                          the transaction, remove spring-2026 from lessonData, record count +
//                          SHA-256 fingerprint with verified: false) — all or nothing;
//   • moved, not verified (a previous run was interrupted) → carries on from here;
//   • moved and verified  → says so and stops;
//   • anything else       → stops without changing anything.
// Then it VERIFIES from fresh server reads (the new document's lessons match the recorded
// count and fingerprint, and lessonData no longer holds Spring — Spring edits are paused by the
// rules throughout, so nothing can change in between), and either
//   • marks the move verified (Spring becomes editable again), or
//   • UNDOES it in ONE transaction: Spring back into lessonData, the new document and the move
//     record removed — exactly the state before (allowed by the rules only while unverified).
//
// The Phase A rules (studio-hub 0caf415) allow exactly these writes and nothing else.
async function springMove(opts = {}) {
  const K = 'spring-2026';
  const TARGET = 'lessons_spring-2026';
  const TS_TAG = '__firestoreTimestamp';
  const say = (...a) => console.log('%c[spring-move]', 'color:#6052C8;font-weight:bold', ...a);
  const stop = (msg, extra = {}) => {
    console.error('[spring-move] STOPPED:', msg);
    alert(`Spring 2026 move STOPPED.\n\n${msg}`);
    return { ok: false, message: msg, ...extra };
  };

  const user = getAuthUser();
  if (!user || !['admin', 'manager'].includes(user.role)) return stop('Sign in as a manager first. Nothing was changed.');
  if (!curriculumDb) initCurriculumFirestore();
  const db = curriculumDb;
  const ref = (id) => db.collection('curriculum').doc(id);
  const by = user.name || user.email || 'Unknown';
  const DELETE = firebase.firestore.FieldValue.delete();

  // Only values that round-trip exactly through JSON (plus Timestamps, tagged) are allowed —
  // anything else (NaN, ±Infinity, -0, GeoPoint, Bytes, DocumentReference, a map already using
  // the tag key…) is reported and the run stops before anything is downloaded or changed.
  const unsupported = [];
  const isTimestamp = (v) => v && typeof v === 'object' && typeof v.toDate === 'function' && typeof v.seconds === 'number' && typeof v.nanoseconds === 'number';
  const encode = (v, where) => {
    if (v === null || typeof v === 'string' || typeof v === 'boolean') return v;
    if (typeof v === 'number') {
      if (!Number.isFinite(v) || Object.is(v, -0)) unsupported.push(`${where}: number ${String(v)}`);
      return v;
    }
    if (isTimestamp(v)) return { [TS_TAG]: { seconds: v.seconds, nanoseconds: v.nanoseconds } };
    if (Array.isArray(v)) return v.map((x, i) => encode(x, `${where}[${i}]`));
    if (typeof v === 'object' && Object.getPrototypeOf(v) === Object.prototype) {
      const out = {};
      for (const k of Object.keys(v).sort()) {
        if (k === TS_TAG) unsupported.push(`${where}: a field named ${TS_TAG}`);
        out[k] = encode(v[k], `${where}.${k}`);
      }
      return out;
    }
    unsupported.push(`${where}: ${v?.constructor?.name || typeof v}`);
    return null;
  };
  const sha256Of = async (encoded) => {
    const digest = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(JSON.stringify(encoded)));
    return [...new Uint8Array(digest)].map(b => b.toString(16).padStart(2, '0')).join('');
  };
  const lessonsOf = (data) => { const m = { ...(data || {}) }; delete m.lastUpdated; delete m.lastUpdatedBy; return m; };
  const readAll = () => Promise.all([
    ref('lessonData').get({ source: 'server' }),
    ref(TARGET).get({ source: 'server' }),
    ref('storageMigrations').get({ source: 'server' }),
  ]);

  // ── Which state are we in? ──
  let ld, tgt, mig;
  try { [ld, tgt, mig] = await readAll(); } catch (err) {
    return stop(`Couldn't read the current data from the server (${err.message}). Nothing was changed.`);
  }
  const inLessonData = ld.exists && Object.prototype.hasOwnProperty.call(ld.data() || {}, K);
  const record = mig.exists ? mig.data()?.[K] : undefined;

  if (inLessonData && !tgt.exists && !record) {
    // ── Not moved yet: validate, back up, confirm, move. ──
    const springMap = ld.data()[K];
    if (!springMap || typeof springMap !== 'object' || Array.isArray(springMap)) return stop('Spring 2026 in lessonData is not a map of lessons. Nothing was changed.');
    const encoded = encode(springMap, K);
    if (unsupported.length) return stop(`Spring 2026 holds values this procedure can't back up exactly:\n${unsupported.slice(0, 10).join('\n')}${unsupported.length > 10 ? `\n…and ${unsupported.length - 10} more` : ''}\n\nNothing was changed. Tell Claude.`);
    const count = Object.keys(springMap).length;
    const fingerprint = await sha256Of(encoded);
    say(`Spring 2026: ${count} lessons, fingerprint ${fingerprint.slice(0, 12)}…`);

    const fileName = `classbook-${K}-lessons-${new Date().toISOString().replace(/[:.]/g, '-')}.json`;
    const backup = JSON.stringify({ semester: K, takenAt: new Date().toISOString(), takenBy: by, lessonCount: count, sha256: fingerprint, timestampTag: TS_TAG, lessons: encoded }, null, 2);
    const link = document.createElement('a');
    link.href = URL.createObjectURL(new Blob([backup], { type: 'application/json' }));
    link.download = fileName;
    document.body.appendChild(link); link.click(); link.remove();
    if (!confirm(`A backup of Spring 2026 (${count} lessons) was just downloaded:\n\n${fileName}\n\nCheck it's in your Downloads folder, then press OK to move Spring 2026 into its own storage.\n\nCancel stops here — nothing is changed.`)) {
      return stop('Cancelled before the move. Nothing was changed.');
    }

    const movedAt = new Date().toISOString();
    try {
      await db.runTransaction(async (tx) => {
        const l = await tx.get(ref('lessonData'));
        const t = await tx.get(ref(TARGET));
        const m = await tx.get(ref('storageMigrations'));
        if (t.exists) throw new Error(`${TARGET} appeared`);
        if (m.exists && m.data()?.[K]) throw new Error('a move record appeared');
        const inTx = l.exists ? l.data()?.[K] : null;
        if (!inTx) throw new Error('Spring 2026 is no longer in lessonData');
        unsupported.length = 0;
        const enc = encode(inTx, K);
        if (unsupported.length) throw new Error(`unsupported values appeared: ${unsupported[0]}`);
        tx.set(ref(TARGET), { ...inTx, lastUpdated: movedAt, lastUpdatedBy: by });
        tx.update(ref('lessonData'), { [K]: DELETE });
        tx.set(ref('storageMigrations'), { [K]: { movedAt, movedBy: by, lessonCount: Object.keys(inTx).length, sha256: await sha256Of(enc), backupFile: fileName, verified: false } }, { merge: true });
      });
    } catch (err) {
      return stop(`The move transaction didn't go through (${err.message}). It's all-or-nothing, so nothing was changed.`);
    }
    say('Moved. Verifying from the server…');
    if (opts.stopAfterMove) return { ok: false, message: 'stopped after the move (rehearsal)', stage: 'moved' };
  } else if (!inLessonData && tgt.exists && record && record.verified !== true) {
    say('Found a move that was interrupted before it was verified — carrying on from there.');
  } else if (!inLessonData && tgt.exists && record?.verified === true) {
    return stop('Spring 2026 has already been moved and verified. Nothing to do; nothing was changed.', { alreadyDone: true });
  } else {
    return stop(`Unexpected state (in lessonData: ${inLessonData}, own document: ${tgt.exists}, record: ${record ? (record.verified ? 'verified' : 'unverified') : 'none'}). Nothing was changed. Tell Claude.`);
  }

  // ── Verify (fresh server reads). ──
  const problems = [];
  let l2, t2, rec;
  try {
    let m2;
    [l2, t2, m2] = await readAll();
    rec = m2.data()?.[K];
    if (!rec) problems.push('the move record is missing');
    if (!t2.exists) problems.push('the new document is missing');
    const targetLessons = lessonsOf(t2.data());
    unsupported.length = 0;
    const encTarget = encode(targetLessons, TARGET);
    if (unsupported.length) problems.push(`the new document holds unsupported values (${unsupported[0]})`);
    if (rec && Object.keys(targetLessons).length !== rec.lessonCount) problems.push(`lesson count ${Object.keys(targetLessons).length} ≠ recorded ${rec.lessonCount}`);
    if (rec && (await sha256Of(encTarget)) !== rec.sha256) problems.push('the new document\'s fingerprint differs from the recorded one');
    if (l2.exists && Object.prototype.hasOwnProperty.call(l2.data() || {}, K)) problems.push('Spring 2026 is still in the shared document');
    if (opts.simulateVerifyFailure) problems.push('simulated failure (rehearsal)');
  } catch (err) {
    return stop(`Couldn't read back from the server to verify (${err.message}). Spring is safe in its new document and still read-only. Run this procedure again to finish.`, { stage: 'moved' });
  }

  if (problems.length) {
    // ── Undo — ONE transaction: Spring back, new document and record removed. ──
    console.error('[spring-move] Verification failed:', problems);
    try {
      await db.runTransaction(async (tx) => {
        const l = await tx.get(ref('lessonData'));
        const t = await tx.get(ref(TARGET));
        const m = await tx.get(ref('storageMigrations'));
        if (!t.exists) throw new Error('the new document is already gone');
        if (m.data()?.[K]?.verified === true) throw new Error('the move is already verified');
        if (l.exists && Object.prototype.hasOwnProperty.call(l.data() || {}, K)) throw new Error('Spring 2026 is already back in lessonData');
        tx.update(ref('lessonData'), { [K]: lessonsOf(t.data()) });
        tx.delete(ref(TARGET));
        tx.update(ref('storageMigrations'), { [K]: DELETE });
      });
    } catch (err) {
      return stop(`Verification failed (${problems.join('; ')}), and the automatic undo didn't go through (${err.message}). The undo is all-or-nothing, so Spring is still safe in its new document (read-only), and it's in your backup file. Don't retry — tell Claude.`, { stage: 'moved' });
    }
    return stop(`Verification failed (${problems.join('; ')}), so the move was undone: Spring 2026 is back in the shared document exactly as before. Nothing was lost.`, { undone: true });
  }

  // ── Mark verified — Spring becomes editable again. ──
  try {
    if (opts.failMarkVerified) throw new Error('simulated failure (rehearsal)');
    await ref('storageMigrations').update({ [`${K}.verified`]: true, [`${K}.verifiedAt`]: new Date().toISOString(), [`${K}.verifiedBy`]: by });
  } catch (err) {
    return stop(`The move is done and checked, but marking it verified failed (${err.message}). Spring is safe and viewable; its edits stay paused. Run this procedure again to finish.`, { stage: 'moved' });
  }
  const kb = typeof approxFirestoreSize === 'function' ? Math.round(approxFirestoreSize(l2.data() || {}) / 1024) : null;
  const msg = `Spring 2026 moved and verified: ${rec.lessonCount} lessons, fingerprint ${String(rec.sha256).slice(0, 12)}…` + (kb !== null ? `\nShared lesson storage is now about ${kb} KB of 1,024 KB.` : '');
  say(msg);
  alert(`Done ✓\n\n${msg}\n\nSpring 2026 is editable again. Keep the backup file${rec.backupFile ? ` ${rec.backupFile}` : ''}.`);
  return { ok: true, message: msg, count: rec.lessonCount, sha256: rec.sha256, lessonDataKB: kb, fileName: rec.backupFile };
}

// Pasted into the console: run it. (The e2e rehearsal sets __SPRING_MOVE_NO_AUTORUN and calls springMove() itself.)
if (!window.__SPRING_MOVE_NO_AUTORUN) springMove();

exec
/bin/zsh -lc 'rg -n "''^(##|[0-9]+'"\\.|- \\*\\*|VERDICT|SAFE|NOT SAFE|Minimum|minimum|Item|RESOLVED)\" /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC-codex.md | tail -80 && tail -100 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC-codex.md && nl -ba scripts/spring-2026-move.console.js | sed -n '1,260p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
14:## Implementation review — Phase C console procedure (PRODUCTION data move tonight)
3432:## Verdict: NOT SAFE TO RUN IN PRODUCTION
3436:### Minimum fixes
3438:1. Make rollback fully atomic.
3453:2. Add an idempotent recovery path for an unverified committed move.
3461:3. Make the fingerprint and downloaded backup type-safe, or explicitly reject unsupported values before confirmation.
3479:4. Complete the plan’s backup prerequisite.
3485:### Rules assessment
3498:### Data/concurrency behavior
3504:### Open tabs
3512:### Rehearsal quality
3529:## Verdict: NOT SAFE TO RUN IN PRODUCTION
3533:### Minimum fixes
3535:1. Make rollback fully atomic.
3550:2. Add an idempotent recovery path for an unverified committed move.
3558:3. Make the fingerprint and downloaded backup type-safe, or explicitly reject unsupported values before confirmation.
3576:4. Complete the plan’s backup prerequisite.
3582:### Rules assessment
3595:### Data/concurrency behavior
3601:### Open tabs
3609:### Rehearsal quality
- an already-open tab during rollback.

No files were edited and no tests were run.
tokens used
82,362
## Verdict: NOT SAFE TO RUN IN PRODUCTION

The forward transaction and live rules are fundamentally sound, but four minimum blockers remain.

### Minimum fixes

1. Make rollback fully atomic.

   The rollback restores Spring and deletes `lessons_spring-2026` in one transaction, but removes the migration entry afterward in a separate write: [spring-2026-move.console.js:135](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:135).

   If that second write fails or the tab closes between operations, the result is:

   - Spring restored correctly
   - target deleted
   - stale `storageMigrations.spring-2026` remains
   - subsequent runs refuse to proceed

   Worse, the shared catch says Spring remains “in the new document,” which is false in this path.

   Put the migration-entry deletion inside the reverse transaction. The deployed rules at `0caf415` permit that combined update.

2. Add an idempotent recovery path for an unverified committed move.

   Any interruption after the forward transaction—tab closure, browser crash, verification read failure, or mark-verified failure—leaves a safe but incomplete state: target present, source absent, record `verified:false`.

   Rerunning `springMove()` cannot resume it: preflight refuses because the target or migration record exists ([lines 71–72](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:71)). Consequently, the claim at [line 155](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:155) that marking verified “can be retried safely” is not true through this procedure.

   The procedure needs to recognize the exact unverified moved state, re-read and verify it, then either mark verified or atomically undo it.

3. Make the fingerprint and downloaded backup type-safe, or explicitly reject unsupported values before confirmation.

   What works:

   - Object-map key order is normalized.
   - Array order is preserved.
   - Timestamps are hashed by seconds/nanoseconds.

   What does not:

   - `JSON.stringify` collapses `NaN` and infinities to `null`, and `-0` to `0`.
   - Firestore types such as GeoPoint, Bytes, DocumentReference, and other SDK values are not explicitly tagged.
   - `{__ts: [...]}` can collide with an ordinary map of that shape.
   - The backup at [lines 77–83](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/scripts/spring-2026-move.console.js:77) is not a lossless, directly restorable representation of Firestore-specific types.
   - Generic SDK objects may serialize misleadingly or fail.

   The current data is probably JSON-native, but the procedure never proves that. Either use an unambiguous type-tagged representation for both hashing and backup, or recursively validate that every Spring value belongs to an explicitly supported JSON-safe subset and stop before downloading/confirming otherwise.

4. Complete the plan’s backup prerequisite.

   The required `lessons_*` tally is not present in the currently readable [backup.js:370](/Users/christiehubley/tinker-backups/backup.js:370); the function still returns immediately at [line 388](/Users/christiehubley/tinker-backups/backup.js:388).

   The full curriculum backup will still contain the new document, but the per-teacher baseline will report Spring content disappearing and can trigger the expected loss alarm. The Decisions Log makes this edit a Phase C prerequisite.

### Rules assessment

Every write currently issued by the procedure matches the manager permissions in rules revision `0caf415`:

- Target creation: allowed for manager/admin.
- Removing only `lessonData.spring-2026`: allowed.
- Creating/updating the unverified migration record: allowed.
- Marking verified while the target exists and the source key is absent: allowed.
- Undo re-add plus target deletion in one transaction: allowed while unverified.
- Removing the migration entry afterward: allowed as an update.

Moving that final migration-entry removal into the undo transaction is also allowed.

### Data/concurrency behavior

The forward transaction does not overwrite Fall. A concurrent Fall save changes `lessonData`, causing Firestore to retry; the retry re-reads the latest document and removes only Spring. The copy, source removal, and record creation are all-or-nothing.

Spring cannot change during verification because the rules keep the target unwritable until verified. An undo also re-reads the latest Fall document before restoring Spring, so it preserves concurrent Fall changes. An undo can nevertheless fail if Fall grows enough that recombining it with Spring exceeds the 1 MiB limit; that leaves Spring safely in the unverified target, but requires the missing recovery path above.

### Open tabs

- Phase B tabs should not blank Spring: either listener ordering preserves the old map until the target arrives, and rollback ordering also retains a copy.
- Tabs become writable only after the verified record arrives.
- A pre-Phase-B tab may show Spring empty after the move, as explicitly accepted in the newest Decisions Log. Its Spring writes are denied by rules.
- Fall remains available and writable throughout.
- An interrupted/unverified move remains viewable but read-only.

### Rehearsal quality

The rehearsal is a good baseline: it executes the exact procedure, covers the happy path, cancellation, rule-backed manager execution, simulated rollback, rerun after clean rollback, an open Phase B tab, and a near-full document.

It does not cover the blockers:

- interruption/re-entry after the forward commit;
- mark-verified failure and recovery;
- failure/interruption between rollback and migration cleanup;
- non-JSON Firestore values and canonicalization collisions;
- explicit preservation of Fall on the successful path;
- concurrent Fall writes forcing transaction retries;
- an already-open tab during rollback.

No files were edited and no tests were run.
     1	// ─── Spring 2026 storage move — Phase C (one-off, run by a manager) ─────────────
     2	// Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html
     3	//
     4	// HOW TO RUN: on https://tinker-classbook.netlify.app, signed in as a manager, open the
     5	// browser console (⌥⌘J), paste this WHOLE file, press Enter. It never runs on its own
     6	// from the site — this file isn't deployed (dist/ holds only the app).
     7	//
     8	// SAFE TO RE-RUN. It first works out which state the data is in:
     9	//   • not moved yet      → checks every value is a plain type it can back up exactly, downloads
    10	//                          a JSON backup, asks you to confirm, then moves Spring in ONE
    11	//                          transaction (create lessons_spring-2026 from the lessons read inside
    12	//                          the transaction, remove spring-2026 from lessonData, record count +
    13	//                          SHA-256 fingerprint with verified: false) — all or nothing;
    14	//   • moved, not verified (a previous run was interrupted) → carries on from here;
    15	//   • moved and verified  → says so and stops;
    16	//   • anything else       → stops without changing anything.
    17	// Then it VERIFIES from fresh server reads (the new document's lessons match the recorded
    18	// count and fingerprint, and lessonData no longer holds Spring — Spring edits are paused by the
    19	// rules throughout, so nothing can change in between), and either
    20	//   • marks the move verified (Spring becomes editable again), or
    21	//   • UNDOES it in ONE transaction: Spring back into lessonData, the new document and the move
    22	//     record removed — exactly the state before (allowed by the rules only while unverified).
    23	//
    24	// The Phase A rules (studio-hub 0caf415) allow exactly these writes and nothing else.
    25	async function springMove(opts = {}) {
    26	  const K = 'spring-2026';
    27	  const TARGET = 'lessons_spring-2026';
    28	  const TS_TAG = '__firestoreTimestamp';
    29	  const say = (...a) => console.log('%c[spring-move]', 'color:#6052C8;font-weight:bold', ...a);
    30	  const stop = (msg, extra = {}) => {
    31	    console.error('[spring-move] STOPPED:', msg);
    32	    alert(`Spring 2026 move STOPPED.\n\n${msg}`);
    33	    return { ok: false, message: msg, ...extra };
    34	  };
    35	
    36	  const user = getAuthUser();
    37	  if (!user || !['admin', 'manager'].includes(user.role)) return stop('Sign in as a manager first. Nothing was changed.');
    38	  if (!curriculumDb) initCurriculumFirestore();
    39	  const db = curriculumDb;
    40	  const ref = (id) => db.collection('curriculum').doc(id);
    41	  const by = user.name || user.email || 'Unknown';
    42	  const DELETE = firebase.firestore.FieldValue.delete();
    43	
    44	  // Only values that round-trip exactly through JSON (plus Timestamps, tagged) are allowed —
    45	  // anything else (NaN, ±Infinity, -0, GeoPoint, Bytes, DocumentReference, a map already using
    46	  // the tag key…) is reported and the run stops before anything is downloaded or changed.
    47	  const unsupported = [];
    48	  const isTimestamp = (v) => v && typeof v === 'object' && typeof v.toDate === 'function' && typeof v.seconds === 'number' && typeof v.nanoseconds === 'number';
    49	  const encode = (v, where) => {
    50	    if (v === null || typeof v === 'string' || typeof v === 'boolean') return v;
    51	    if (typeof v === 'number') {
    52	      if (!Number.isFinite(v) || Object.is(v, -0)) unsupported.push(`${where}: number ${String(v)}`);
    53	      return v;
    54	    }
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
    73	  const readAll = () => Promise.all([
    74	    ref('lessonData').get({ source: 'server' }),
    75	    ref(TARGET).get({ source: 'server' }),
    76	    ref('storageMigrations').get({ source: 'server' }),
    77	  ]);
    78	
    79	  // ── Which state are we in? ──
    80	  let ld, tgt, mig;
    81	  try { [ld, tgt, mig] = await readAll(); } catch (err) {
    82	    return stop(`Couldn't read the current data from the server (${err.message}). Nothing was changed.`);
    83	  }
    84	  const inLessonData = ld.exists && Object.prototype.hasOwnProperty.call(ld.data() || {}, K);
    85	  const record = mig.exists ? mig.data()?.[K] : undefined;
    86	
    87	  if (inLessonData && !tgt.exists && !record) {
    88	    // ── Not moved yet: validate, back up, confirm, move. ──
    89	    const springMap = ld.data()[K];
    90	    if (!springMap || typeof springMap !== 'object' || Array.isArray(springMap)) return stop('Spring 2026 in lessonData is not a map of lessons. Nothing was changed.');
    91	    const encoded = encode(springMap, K);
    92	    if (unsupported.length) return stop(`Spring 2026 holds values this procedure can't back up exactly:\n${unsupported.slice(0, 10).join('\n')}${unsupported.length > 10 ? `\n…and ${unsupported.length - 10} more` : ''}\n\nNothing was changed. Tell Claude.`);
    93	    const count = Object.keys(springMap).length;
    94	    const fingerprint = await sha256Of(encoded);
    95	    say(`Spring 2026: ${count} lessons, fingerprint ${fingerprint.slice(0, 12)}…`);
    96	
    97	    const fileName = `classbook-${K}-lessons-${new Date().toISOString().replace(/[:.]/g, '-')}.json`;
    98	    const backup = JSON.stringify({ semester: K, takenAt: new Date().toISOString(), takenBy: by, lessonCount: count, sha256: fingerprint, timestampTag: TS_TAG, lessons: encoded }, null, 2);
    99	    const link = document.createElement('a');
   100	    link.href = URL.createObjectURL(new Blob([backup], { type: 'application/json' }));
   101	    link.download = fileName;
   102	    document.body.appendChild(link); link.click(); link.remove();
   103	    if (!confirm(`A backup of Spring 2026 (${count} lessons) was just downloaded:\n\n${fileName}\n\nCheck it's in your Downloads folder, then press OK to move Spring 2026 into its own storage.\n\nCancel stops here — nothing is changed.`)) {
   104	      return stop('Cancelled before the move. Nothing was changed.');
   105	    }
   106	
   107	    const movedAt = new Date().toISOString();
   108	    try {
   109	      await db.runTransaction(async (tx) => {
   110	        const l = await tx.get(ref('lessonData'));
   111	        const t = await tx.get(ref(TARGET));
   112	        const m = await tx.get(ref('storageMigrations'));
   113	        if (t.exists) throw new Error(`${TARGET} appeared`);
   114	        if (m.exists && m.data()?.[K]) throw new Error('a move record appeared');
   115	        const inTx = l.exists ? l.data()?.[K] : null;
   116	        if (!inTx) throw new Error('Spring 2026 is no longer in lessonData');
   117	        unsupported.length = 0;
   118	        const enc = encode(inTx, K);
   119	        if (unsupported.length) throw new Error(`unsupported values appeared: ${unsupported[0]}`);
   120	        tx.set(ref(TARGET), { ...inTx, lastUpdated: movedAt, lastUpdatedBy: by });
   121	        tx.update(ref('lessonData'), { [K]: DELETE });
   122	        tx.set(ref('storageMigrations'), { [K]: { movedAt, movedBy: by, lessonCount: Object.keys(inTx).length, sha256: await sha256Of(enc), backupFile: fileName, verified: false } }, { merge: true });
   123	      });
   124	    } catch (err) {
   125	      return stop(`The move transaction didn't go through (${err.message}). It's all-or-nothing, so nothing was changed.`);
   126	    }
   127	    say('Moved. Verifying from the server…');
   128	    if (opts.stopAfterMove) return { ok: false, message: 'stopped after the move (rehearsal)', stage: 'moved' };
   129	  } else if (!inLessonData && tgt.exists && record && record.verified !== true) {
   130	    say('Found a move that was interrupted before it was verified — carrying on from there.');
   131	  } else if (!inLessonData && tgt.exists && record?.verified === true) {
   132	    return stop('Spring 2026 has already been moved and verified. Nothing to do; nothing was changed.', { alreadyDone: true });
   133	  } else {
   134	    return stop(`Unexpected state (in lessonData: ${inLessonData}, own document: ${tgt.exists}, record: ${record ? (record.verified ? 'verified' : 'unverified') : 'none'}). Nothing was changed. Tell Claude.`);
   135	  }
   136	
   137	  // ── Verify (fresh server reads). ──
   138	  const problems = [];
   139	  let l2, t2, rec;
   140	  try {
   141	    let m2;
   142	    [l2, t2, m2] = await readAll();
   143	    rec = m2.data()?.[K];
   144	    if (!rec) problems.push('the move record is missing');
   145	    if (!t2.exists) problems.push('the new document is missing');
   146	    const targetLessons = lessonsOf(t2.data());
   147	    unsupported.length = 0;
   148	    const encTarget = encode(targetLessons, TARGET);
   149	    if (unsupported.length) problems.push(`the new document holds unsupported values (${unsupported[0]})`);
   150	    if (rec && Object.keys(targetLessons).length !== rec.lessonCount) problems.push(`lesson count ${Object.keys(targetLessons).length} ≠ recorded ${rec.lessonCount}`);
   151	    if (rec && (await sha256Of(encTarget)) !== rec.sha256) problems.push('the new document\'s fingerprint differs from the recorded one');
   152	    if (l2.exists && Object.prototype.hasOwnProperty.call(l2.data() || {}, K)) problems.push('Spring 2026 is still in the shared document');
   153	    if (opts.simulateVerifyFailure) problems.push('simulated failure (rehearsal)');
   154	  } catch (err) {
   155	    return stop(`Couldn't read back from the server to verify (${err.message}). Spring is safe in its new document and still read-only. Run this procedure again to finish.`, { stage: 'moved' });
   156	  }
   157	
   158	  if (problems.length) {
   159	    // ── Undo — ONE transaction: Spring back, new document and record removed. ──
   160	    console.error('[spring-move] Verification failed:', problems);
   161	    try {
   162	      await db.runTransaction(async (tx) => {
   163	        const l = await tx.get(ref('lessonData'));
   164	        const t = await tx.get(ref(TARGET));
   165	        const m = await tx.get(ref('storageMigrations'));
   166	        if (!t.exists) throw new Error('the new document is already gone');
   167	        if (m.data()?.[K]?.verified === true) throw new Error('the move is already verified');
   168	        if (l.exists && Object.prototype.hasOwnProperty.call(l.data() || {}, K)) throw new Error('Spring 2026 is already back in lessonData');
   169	        tx.update(ref('lessonData'), { [K]: lessonsOf(t.data()) });
   170	        tx.delete(ref(TARGET));
   171	        tx.update(ref('storageMigrations'), { [K]: DELETE });
   172	      });
   173	    } catch (err) {
   174	      return stop(`Verification failed (${problems.join('; ')}), and the automatic undo didn't go through (${err.message}). The undo is all-or-nothing, so Spring is still safe in its new document (read-only), and it's in your backup file. Don't retry — tell Claude.`, { stage: 'moved' });
   175	    }
   176	    return stop(`Verification failed (${problems.join('; ')}), so the move was undone: Spring 2026 is back in the shared document exactly as before. Nothing was lost.`, { undone: true });
   177	  }
   178	
   179	  // ── Mark verified — Spring becomes editable again. ──
   180	  try {
   181	    if (opts.failMarkVerified) throw new Error('simulated failure (rehearsal)');
   182	    await ref('storageMigrations').update({ [`${K}.verified`]: true, [`${K}.verifiedAt`]: new Date().toISOString(), [`${K}.verifiedBy`]: by });
   183	  } catch (err) {
   184	    return stop(`The move is done and checked, but marking it verified failed (${err.message}). Spring is safe and viewable; its edits stay paused. Run this procedure again to finish.`, { stage: 'moved' });
   185	  }
   186	  const kb = typeof approxFirestoreSize === 'function' ? Math.round(approxFirestoreSize(l2.data() || {}) / 1024) : null;
   187	  const msg = `Spring 2026 moved and verified: ${rec.lessonCount} lessons, fingerprint ${String(rec.sha256).slice(0, 12)}…` + (kb !== null ? `\nShared lesson storage is now about ${kb} KB of 1,024 KB.` : '');
   188	  say(msg);
   189	  alert(`Done ✓\n\n${msg}\n\nSpring 2026 is editable again. Keep the backup file${rec.backupFile ? ` ${rec.backupFile}` : ''}.`);
   190	  return { ok: true, message: msg, count: rec.lessonCount, sha256: rec.sha256, lessonDataKB: kb, fileName: rec.backupFile };
   191	}
   192	
   193	// Pasted into the console: run it. (The e2e rehearsal sets __SPRING_MOVE_NO_AUTORUN and calls springMove() itself.)
   194	if (!window.__SPRING_MOVE_NO_AUTORUN) springMove();

codex
The three code blockers are visibly addressed in the current procedure. I’m now checking the less obvious edge cases—especially metadata-key collisions, malformed interrupted states, transaction retries, and whether the rules’ `getAfter` conditions admit the exact three-write rollback.
exec
/bin/zsh -lc "git -C /Users/christiehubley/studio-hub show 0caf415:firestore.rules | nl -ba | sed -n '620,735p' && rg -n \"backup|computeClassbook|lessons_|stopAfterMove|failMarkVerified|simulateVerifyFailure|Timestamp|concurrent|Fall|undo|rerun\" /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC-r2.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-Mu5CnrHL' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-YNLp2XE1' (errno=Operation not permitted)
   620	
   621	    match /recapData/{docId} {
   622	      allow read, write: if isManagerOrAbove() || hasAppAccess('recap');
   623	    }
   624	
   625	    match /series/{docId} {
   626	      allow read, write: if isManagerOrAbove() || hasAppAccess('recap');
   627	    }
   628	
   629	    match /threads/{docId} {
   630	      allow read, write: if isManagerOrAbove() || hasAppAccess('recap');
   631	    }
   632	
   633	
   634	    // ═══════════════════════════════════════════════════════════════
   635	    // CLASSBOOK (Curriculum)
   636	    // NO studio restriction — both studios can access.
   637	    //
   638	    // appAccess('classbook-admin'):
   639	    //   Full read/write on all curriculum docs EXCEPT 'appData'.
   640	    //   appData (Settings doc): manager+ only, always.
   641	    //
   642	    // appAccess('classbook'):
   643	    //   Full read/write on all curriculum docs EXCEPT 'appData'.
   644	    //   The app controls what each teacher actually sees/edits
   645	    //   (all lesson data is in a single document — field-level
   646	    //   isolation is enforced by the UI, not by rules).
   647	    //   appData (Settings doc): manager+ only, always.
   648	    //
   649	    // Manager+: full access including appData.
   650	    // ═══════════════════════════════════════════════════════════════
   651	
   652	    match /curriculum/{docId} {
   653	      // ── Spring 2026 storage move (Sep 29 2026) ──────────────────────────
   654	      // Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase A).
   655	      // curriculum/lessonData holds every Fall/Spring semester in ONE document and was at 95% of
   656	      // Firestore's 1 MiB cap. Spring 2026 moves to curriculum/lessons_spring-2026 in one manager
   657	      // transaction. Three docs therefore get their own rules below; every other curriculum doc
   658	      // keeps exactly the rules it had (the "ordinary docs" lines).
   659	      //   lessonData          — nobody changes its 'spring-2026' key, except manager+ deleting ONLY
   660	      //                         that key (the move) or re-adding ONLY that key while the move is
   661	      //                         unverified AND the new doc is deleted in the same transaction
   662	      //                         (the rollback). Nobody deletes the whole document.
   663	      //   lessons_spring-2026 — created by manager+; edited only once storageMigrations says the move
   664	      //                         is verified; deleted only by manager+ and only while unverified.
   665	      //   storageMigrations   — manager+ writes; classbook roles read.
   666	      function isClassbookRole() {
   667	        return hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook');
   668	      }
   669	      function isClassbookAdminRole() {
   670	        return hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin');
   671	      }
   672	      function isStorageMoveDoc() {
   673	        return docId in ['lessonData', 'lessons_spring-2026', 'storageMigrations'];
   674	      }
   675	      function springMoveVerified() {
   676	        let path = /databases/$(database)/documents/curriculum/storageMigrations;
   677	        return exists(path) && get(path).data.get('spring-2026', {}).get('verified', false) == true;
   678	      }
   679	      function lessonDataChangedKeys() {
   680	        return request.resource.data.diff(resource.data).affectedKeys();
   681	      }
   682	      function springKeyUntouched() {
   683	        return !lessonDataChangedKeys().hasAny(['spring-2026']);
   684	      }
   685	      function springKeyRemovedOnly() {
   686	        return lessonDataChangedKeys().hasOnly(['spring-2026'])
   687	          && !('spring-2026' in request.resource.data);
   688	      }
   689	      function springKeyRolledBack() {
   690	        return lessonDataChangedKeys().hasOnly(['spring-2026'])
   691	          && ('spring-2026' in request.resource.data)
   692	          && !('spring-2026' in resource.data)
   693	          && exists(/databases/$(database)/documents/curriculum/lessons_spring-2026)
   694	          && !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
   695	          && !springMoveVerified();
   696	      }
   697	
   698	      // Manager+: full access to everything including appData (reads; ordinary-doc writes)
   699	      allow read: if isManagerOrAbove();
   700	      allow create, update, delete: if isManagerOrAbove() && !isStorageMoveDoc();
   701	
   702	      // classbook-admin, curriculum-admin (legacy key), and classbook: full read/write except appData and prepCycleConfig
   703	      // appData (Settings) is manager+ only, always
   704	      // prepCycleConfig (Prep Cycle workflow config) is classbook-admin only
   705	      // NOTE: 'classbook' (plain teacher) access is intentionally NOT
   706	      // isolated per-teacher here — each semester's lessons live in one
   707	      // shared doc, and per-field isolation is enforced by the UI, not
   708	      // by these rules. This is a known, accepted gap (see
   709	      // firebase-agent-defense-hardening.md) pending a possible future
   710	      // data-model change, not something this rule can close on its own.
   711	      allow read: if isClassbookRole();
   712	      allow create, update: if
   713	        isClassbookRole()
   714	        && docId != 'appData'
   715	        && docId != 'prepCycleConfig'
   716	        && !isStorageMoveDoc();
   717	      // Whole-document delete is classbook-admin/curriculum-admin only.
   718	      // Plain 'classbook' (teacher) access never calls a full-document
   719	      // delete in the app (only FieldValue.delete() on specific lesson
   720	      // fields, which is an update, not a delete) — so this closes an
   721	      // unused, high-blast-radius capability with no functional change.
   722	      allow delete: if
   723	        isClassbookAdminRole()
   724	        && docId != 'appData'
   725	        && docId != 'prepCycleConfig'
   726	        && !isStorageMoveDoc();
   727	      // prepCycleConfig: classbook-admin and curriculum-admin write only
   728	      allow create, update, delete: if
   729	        isClassbookAdminRole()
   730	        && docId == 'prepCycleConfig';
   731	
   732	      // lessonData: as before for every semester except 'spring-2026'; no whole-document delete.
   733	      allow create: if docId == 'lessonData'
   734	        && (isManagerOrAbove() || isClassbookRole())
   735	        && !('spring-2026' in request.resource.data);
5:    Phase C procedure review fixes: re-runnable, atomic undo, exact-types only
8:    - Undo is now ONE transaction: Spring back into lessonData, lessons_spring-2026
13:      and mark verified or undo; already verified → says so and changes nothing; anything
17:      or a Firestore Timestamp (tagged __firestoreTimestamp in both the fingerprint and
18:      the backup); GeoPoint, Bytes, references, NaN/Infinity, or a map already using the
21:    Rehearsal (13 tests, deployed rules): + Fall preserved incl. a Fall save while the
24:    before download, Timestamp moved exactly and tagged in the backup.
41:+  const value = kind === 'timestamp' ? admin.firestore.Timestamp.fromMillis(Date.parse('2026-03-01T12:00:00Z'))
82:+  test('Fall is preserved, including a Fall save made while the confirmation is open', async ({ browser }) => {
83:+    await SM.writeCurriculumDoc('lessonData', { 'fall-2026': { 'fall-1': { teacher: 'T', shortDetails: 'Fall before' } } }, { merge: true });
86:+      beforeConfirm: () => SM.writeCurriculumDoc('lessonData', { 'fall-2026': { 'fall-1': { teacher: 'T', shortDetails: 'Fall edited mid-move' } } }, { merge: true }),
90:+    expect(ld['fall-2026']['fall-1'].shortDetails).toBe('Fall edited mid-move');
98:+    const first = await runProcedure(page, { opts: { stopAfterMove: true } });
112:+    const first = await runProcedure(page, { opts: { failMarkVerified: true } });
144:+  test('a Firestore Timestamp is moved exactly and tagged in the backup', async ({ browser }) => {
149:+    const backup = JSON.parse(fs.readFileSync(await download.path(), 'utf8'));
150:+    expect(backup.lessons[LESSON].reviewedAt).toEqual({ __firestoreTimestamp: { seconds: Date.parse('2026-03-01T12:00:00Z') / 1000, nanoseconds: 0 } });
152:+    expect(moved.toMillis()).toBe(Date.parse('2026-03-01T12:00:00Z'));   // still a real Timestamp
165:-//   1. Checks you're a manager and reads curriculum/lessonData, lessons_spring-2026 and
168:-//   2. Downloads a JSON backup of Spring's lessons and asks you to confirm.
169:-//   3. ONE transaction: creates lessons_spring-2026 from the lessons read inside the
181:+//                          a JSON backup, asks you to confirm, then moves Spring in ONE
182:+//                          transaction (create lessons_spring-2026 from the lessons read inside
198:   const TARGET = 'lessons_spring-2026';
199:+  const TS_TAG = '__firestoreTimestamp';
216:-  // A fingerprint independent of key order: sorted keys, Timestamps as seconds/nanos.
224:+  // Only values that round-trip exactly through JSON (plus Timestamps, tagged) are allowed —
228:+  const isTimestamp = (v) => v && typeof v === 'object' && typeof v.toDate === 'function' && typeof v.seconds === 'number' && typeof v.nanoseconds === 'number';
235:+    if (isTimestamp(v)) return { [TS_TAG]: { seconds: v.seconds, nanoseconds: v.nanoseconds } };
287:-  const backup = JSON.stringify({ semester: K, takenAt: new Date().toISOString(), takenBy: by, lessonCount: count, sha256: fingerprint, lessons: springMap }, null, 2);
289:-  link.href = URL.createObjectURL(new Blob([backup], { type: 'application/json' }));
292:-  if (!confirm(`A backup of Spring 2026 (${count} lessons) was just downloaded:\n\n${fileName}\n\nCheck it's in your Downloads folder, then press OK to move Spring 2026 into its own storage.\n\nCancel stops here — nothing is changed.`)) {
325:+    const backup = JSON.stringify({ semester: K, takenAt: new Date().toISOString(), takenBy: by, lessonCount: count, sha256: fingerprint, timestampTag: TS_TAG, lessons: encoded }, null, 2);
327:+    link.href = URL.createObjectURL(new Blob([backup], { type: 'application/json' }));
330:+    if (!confirm(`A backup of Spring 2026 (${count} lessons) was just downloaded:\n\n${fileName}\n\nCheck it's in your Downloads folder, then press OK to move Spring 2026 into its own storage.\n\nCancel stops here — nothing is changed.`)) {
349:+        tx.set(ref('storageMigrations'), { [K]: { movedAt, movedBy: by, lessonCount: Object.keys(inTx).length, sha256: await sha256Of(enc), backupFile: fileName, verified: false } }, { merge: true });
355:+    if (opts.stopAfterMove) return { ok: false, message: 'stopped after the move (rehearsal)', stage: 'moved' };
393:     if (opts.simulateVerifyFailure) problems.push('simulated failure (rehearsal)');
420:-      return stop(`Verification failed (${problems.join('; ')}) AND the automatic undo failed (${err.message}). Don't retry — tell Claude. Spring's lessons are safe in the backup file ${fileName} and in the new document.`);
421:+      return stop(`Verification failed (${problems.join('; ')}), and the automatic undo didn't go through (${err.message}). The undo is all-or-nothing, so Spring is still safe in its new document (read-only), and it's in your backup file. Don't retry — tell Claude.`, { stage: 'moved' });
423:-    return stop(`Verification failed (${problems.join('; ')}), so the move was undone: Spring 2026 is back in the shared document exactly as before. Nothing was lost.`);
424:+    return stop(`Verification failed (${problems.join('; ')}), so the move was undone: Spring 2026 is back in the shared document exactly as before. Nothing was lost.`, { undone: true });
430:+    if (opts.failMarkVerified) throw new Error('simulated failure (rehearsal)');
440:-  alert(`Done ✓\n\n${msg}\n\nSpring 2026 is editable again. Keep the backup file ${fileName}.`);
442:+  alert(`Done ✓\n\n${msg}\n\nSpring 2026 is editable again. Keep the backup file${rec.backupFile ? ` ${rec.backupFile}` : ''}.`);
443:+  return { ok: true, message: msg, count: rec.lessonCount, sha256: rec.sha256, lessonDataKB: kb, fileName: rec.backupFile };

exec
/bin/zsh -lc "git -C /Users/christiehubley/studio-hub show 0caf415:firestore.rules | nl -ba | sed -n '730,815p' && sed -n '1,180p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC-r2.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-rf4sYmSV' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-CZUvUpFW' (errno=Operation not permitted)
   730	        && docId == 'prepCycleConfig';
   731	
   732	      // lessonData: as before for every semester except 'spring-2026'; no whole-document delete.
   733	      allow create: if docId == 'lessonData'
   734	        && (isManagerOrAbove() || isClassbookRole())
   735	        && !('spring-2026' in request.resource.data);
   736	      allow update: if docId == 'lessonData'
   737	        && (isManagerOrAbove() || isClassbookRole())
   738	        && springKeyUntouched();
   739	      allow update: if docId == 'lessonData'
   740	        && isManagerOrAbove()
   741	        && (springKeyRemovedOnly() || springKeyRolledBack());
   742	
   743	      // lessons_spring-2026: Spring 2026's lessons after the move.
   744	      allow create: if docId == 'lessons_spring-2026' && isManagerOrAbove();
   745	      allow update: if docId == 'lessons_spring-2026'
   746	        && (isManagerOrAbove() || isClassbookRole())
   747	        && springMoveVerified();
   748	      allow delete: if docId == 'lessons_spring-2026'
   749	        && isManagerOrAbove()
   750	        && !springMoveVerified();
   751	
   752	      // storageMigrations: the move's record (manager+ writes; read via the read lines above).
   753	      // 'verified' is one-way: once true it can never be turned off, removed or replaced (that
   754	      // would reopen delete/rollback). It may become true only when, AFTER the write (existsAfter/getAfter, so it
   755	      // can't be combined with a delete or rollback in one batch), lessons_spring-2026 exists and
   756	      // lessonData no longer holds 'spring-2026'. No role deletes the record.
   757	      function springVerifiedIn(data) {
   758	        return data.get('spring-2026', {}).get('verified', false) == true;
   759	      }
   760	      function springVerifyTransitionOk() {
   761	        return !springVerifiedIn(request.resource.data)
   762	          || (existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
   763	              && !('spring-2026' in getAfter(/databases/$(database)/documents/curriculum/lessonData).data));
   764	      }
   765	      allow create: if docId == 'storageMigrations'
   766	        && isManagerOrAbove()
   767	        && springVerifyTransitionOk();
   768	      allow update: if docId == 'storageMigrations'
   769	        && isManagerOrAbove()
   770	        && (springVerifiedIn(resource.data)
   771	              ? springVerifiedIn(request.resource.data)
   772	              : springVerifyTransitionOk());
   773	    }
   774	
   775	    // ═══════════════════════════════════════════════════════════════
   776	    // CLASSBOOK — SCHOOL DAY OFF CAMPS (SDOCs)
   777	    // Plan: tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html (Phase 1, §1.1)
   778	    //   dayOffCamps_events / dayOffCamps_camps: the admin's planning list for a school year.
   779	    //     classbook-admin (+ manager+) write, plain classbook teachers read.
   780	    //   dayOffCamps_lessonData: one shared plan per camp-project. Teachers create/update like
   781	    //     summerCamps_lessonData (per-teacher isolation is UI-enforced — the same accepted gap as
   782	    //     summer); whole-document delete is admin-only, like /curriculum's delete clause.
   783	    //   The legacy 'curriculum-admin' key is deliberately NOT extended to these new collections.
   784	    //   Visibility of an unpublished year is UI gating only: every classbook teacher can read these.
   785	    // ═══════════════════════════════════════════════════════════════
   786	
   787	    match /dayOffCamps_events/{docId} {
   788	      allow read: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
   789	      allow create, update, delete: if isManagerOrAbove() || hasAppAccess('classbook-admin');
   790	    }
   791	
   792	    match /dayOffCamps_camps/{docId} {
   793	      allow read: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
   794	      allow create, update, delete: if isManagerOrAbove() || hasAppAccess('classbook-admin');
   795	    }
   796	
   797	    match /dayOffCamps_lessonData/{docId} {
   798	      allow read: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
   799	      allow create, update: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
   800	      allow delete: if isManagerOrAbove() || hasAppAccess('classbook-admin');
   801	    }
   802	
   803	
   804	    // ═══════════════════════════════════════════════════════════════
   805	    // ROSTER MANAGER — Tinker studio only.
   806	    // Manager+ or appAccess('roster-manager'): full read/write.
   807	    // Delete: manager+ only.
   808	    // Studio isolation applies to all roles.
   809	    // ═══════════════════════════════════════════════════════════════
   810	
   811	    match /rosterManager/{docId} {
   812	      allow read, create, update: if
   813	        (isManagerOrAbove() || hasAppAccess('roster-manager'))
   814	        && belongsToStudio('tinker');
   815	      allow delete: if isManagerOrAbove() && belongsToStudio('tinker');
commit 058f64f2f88cf1185cf634100dd3b89f9058c5bd
Author: Christie Hubley <christie@tinkerartstudio.com>
Date:   Wed Sep 30 13:39:48 2026 -0600

    Phase C procedure review fixes: re-runnable, atomic undo, exact-types only
    
    Codex review of 05b159b (NOT safe to run):
    - Undo is now ONE transaction: Spring back into lessonData, lessons_spring-2026
      deleted AND the move record removed (the old separate record cleanup could leave a
      stale record that blocked any re-run).
    - Re-runnable: the procedure detects the state first — not moved → move; moved but
      unverified (tab closed, read failure, mark-verified failure) → carries on to verify
      and mark verified or undo; already verified → says so and changes nothing; anything
      else → stops. Verification now checks against the server's move record.
    - Exact types only: before any download or change, every Spring value must be a
      JSON-exact type (finite non -0 numbers, strings, booleans, null, arrays, plain maps)
      or a Firestore Timestamp (tagged __firestoreTimestamp in both the fingerprint and
      the backup); GeoPoint, Bytes, references, NaN/Infinity, or a map already using the
      tag stop the run with the offending paths listed.
    
    Rehearsal (13 tests, deployed rules): + Fall preserved incl. a Fall save while the
    confirmation is open, resume after an interruption right after the move, resume after
    a mark-verified failure, re-run after success = no change, GeoPoint / NaN refused
    before download, Timestamp moved exactly and tagged in the backup.
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/e2e/helpers/storage-move.js b/e2e/helpers/storage-move.js
index 670fa3f..d6e0d5a 100644
--- a/e2e/helpers/storage-move.js
+++ b/e2e/helpers/storage-move.js
@@ -59,4 +59,14 @@ async function deleteCurriculumDoc(docId) {
   await adminDb().collection('curriculum').doc(docId).delete();
 }
 
-module.exports = { SPRING, SPRING_DOC, springFixture, resetStorageMove, stageMoved, readCurriculumDoc, writeCurriculumDoc, deleteCurriculumDoc };
+// Writes a Firestore-typed value into one Spring lesson in lessonData (for the procedure's
+// "only exactly-representable values" check): 'timestamp' | 'geopoint' | 'nan'.
+async function writeSpringTypedValue(lessonKey, field, kind) {
+  const admin = require('firebase-admin');
+  const value = kind === 'timestamp' ? admin.firestore.Timestamp.fromMillis(Date.parse('2026-03-01T12:00:00Z'))
+    : kind === 'geopoint' ? new admin.firestore.GeoPoint(40.0, -105.3)
+    : kind === 'nan' ? NaN : null;
+  await adminDb().collection('curriculum').doc('lessonData').update({ [`${SPRING}.${lessonKey}.${field}`]: value });
+}
+
+module.exports = { writeSpringTypedValue, SPRING, SPRING_DOC, springFixture, resetStorageMove, stageMoved, readCurriculumDoc, writeCurriculumDoc, deleteCurriculumDoc };
diff --git a/e2e/spring-move-procedure.spec.js b/e2e/spring-move-procedure.spec.js
index d74ed9e..70d9849 100644
--- a/e2e/spring-move-procedure.spec.js
+++ b/e2e/spring-move-procedure.spec.js
@@ -26,9 +26,13 @@ async function openAs(browser, role) {
   return { ctx, page };
 }
 // Loads the procedure without auto-running; dialogs answered by `answerConfirm`.
-async function runProcedure(page, { answerConfirm = true, opts = {} } = {}) {
+async function runProcedure(page, { answerConfirm = true, opts = {}, beforeConfirm = null } = {}) {
   const dialogs = [];
-  page.on('dialog', d => { dialogs.push(`${d.type()}: ${d.message()}`); d.type() === 'confirm' ? (answerConfirm ? d.accept() : d.dismiss()) : d.accept(); });
+  page.on('dialog', async d => {
+    dialogs.push(`${d.type()}: ${d.message()}`);
+    if (d.type() === 'confirm') { if (beforeConfirm) await beforeConfirm(); return answerConfirm ? d.accept() : d.dismiss(); }
+    return d.accept();
+  });
   await page.addScriptTag({ content: `window.__SPRING_MOVE_NO_AUTORUN = true;\n${PROCEDURE}` });
   const downloadPromise = page.waitForEvent('download', { timeout: 15_000 }).catch(() => null);
   const result = await page.evaluate((o) => springMove(o), opts);
@@ -112,7 +116,7 @@ test.describe('Spring 2026 move procedure (Phase C rehearsal)', () => {
     const { ctx, page } = await openAs(browser, 'manager');
     const { result, download } = await runProcedure(page);
     expect(result.ok).toBe(false);
-    expect(result.message).toMatch(/Nothing was changed/);
+    expect(result.message).toMatch(/already been moved and verified.*nothing was changed/i);
     expect(download).toBeNull();
     expect(await snapshotAll()).toEqual(before);
     await ctx.close();
@@ -141,4 +145,78 @@ test.describe('Spring 2026 move procedure (Phase C rehearsal)', () => {
     expect((await SM.readCurriculumDoc('lessonData'))['spring-2026']).toBeUndefined();
     await ctx.close();
   });
+
+  test('Fall is preserved, including a Fall save made while the confirmation is open', async ({ browser }) => {
+    await SM.writeCurriculumDoc('lessonData', { 'fall-2026': { 'fall-1': { teacher: 'T', shortDetails: 'Fall before' } } }, { merge: true });
+    const { ctx, page } = await openAs(browser, 'manager');
+    const { result } = await runProcedure(page, {
+      beforeConfirm: () => SM.writeCurriculumDoc('lessonData', { 'fall-2026': { 'fall-1': { teacher: 'T', shortDetails: 'Fall edited mid-move' } } }, { merge: true }),
+    });
+    expect(result.ok, JSON.stringify(result)).toBe(true);
+    const ld = await SM.readCurriculumDoc('lessonData');
+    expect(ld['fall-2026']['fall-1'].shortDetails).toBe('Fall edited mid-move');
+    expect(ld['spring-2026']).toBeUndefined();
+    expect(Object.keys(ld).sort()).toEqual(['fall-2026', 'lastUpdated', 'lastUpdatedBy']);
+    await ctx.close();
+  });
+
+  test('interrupted right after the move: re-running finishes it (verify + mark verified)', async ({ browser }) => {
+    const { ctx, page } = await openAs(browser, 'manager');
+    const first = await runProcedure(page, { opts: { stopAfterMove: true } });
+    expect(first.result.stage).toBe('moved');
+    expect((await SM.readCurriculumDoc('storageMigrations'))['spring-2026'].verified).toBe(false);
+    await page.waitForFunction(() => ownDocSource['spring-2026'] === 'ownDoc');
+    expect(await page.evaluate(() => weeklySemesterPausedMessage('spring-2026'))).toMatch(/editing it is paused/);   // read-only meanwhile
+    const again = await page.evaluate(() => springMove());
+    expect(again.ok, JSON.stringify(again)).toBe(true);
+    expect(stripStamps(await SM.readCurriculumDoc(SM.SPRING_DOC))).toEqual(SM.springFixture());
+    expect((await SM.readCurriculumDoc('storageMigrations'))['spring-2026'].verified).toBe(true);
+    await ctx.close();
+  });
+
+  test('marking verified fails: re-running finishes it', async ({ browser }) => {
+    const { ctx, page } = await openAs(browser, 'manager');
+    const first = await runProcedure(page, { opts: { failMarkVerified: true } });
+    expect(first.result.ok).toBe(false);
+    expect(first.result.message).toMatch(/Run this procedure again to finish/);
+    const again = await page.evaluate(() => springMove());
+    expect(again.ok, JSON.stringify(again)).toBe(true);
+    await ctx.close();
+  });
+
+  test('re-running after success says it is already done and changes nothing', async ({ browser }) => {
+    const { ctx, page } = await openAs(browser, 'manager');
+    expect((await runProcedure(page)).result.ok).toBe(true);
+    const before = await snapshotAll();
+    const again = await page.evaluate(() => springMove());
+    expect(again.alreadyDone).toBe(true);
+    expect(await snapshotAll()).toEqual(before);
+    await ctx.close();
+  });
+
+  for (const kind of ['geopoint', 'nan']) {
+    test(`a value that can't be backed up exactly (${kind}) stops it before anything is downloaded or changed`, async ({ browser }) => {
+      await SM.writeSpringTypedValue(LESSON, 'odd', kind);
+      const before = await snapshotAll();
+      const { ctx, page } = await openAs(browser, 'manager');
+      const { result, download } = await runProcedure(page);
+      expect(result.ok).toBe(false);
+      expect(result.message).toMatch(/can't back up exactly/);
+      expect(download).toBeNull();
+      expect(await snapshotAll()).toEqual(before);
+      await ctx.close();
+    });
+  }
+
+  test('a Firestore Timestamp is moved exactly and tagged in the backup', async ({ browser }) => {
+    await SM.writeSpringTypedValue(LESSON, 'reviewedAt', 'timestamp');
+    const { ctx, page } = await openAs(browser, 'manager');
+    const { result, download } = await runProcedure(page);
+    expect(result.ok, JSON.stringify(result)).toBe(true);
+    const backup = JSON.parse(fs.readFileSync(await download.path(), 'utf8'));
+    expect(backup.lessons[LESSON].reviewedAt).toEqual({ __firestoreTimestamp: { seconds: Date.parse('2026-03-01T12:00:00Z') / 1000, nanoseconds: 0 } });
+    const moved = (await SM.readCurriculumDoc(SM.SPRING_DOC))[LESSON].reviewedAt;
+    expect(moved.toMillis()).toBe(Date.parse('2026-03-01T12:00:00Z'));   // still a real Timestamp
+    await ctx.close();
+  });
 });
diff --git a/scripts/spring-2026-move.console.js b/scripts/spring-2026-move.console.js
index da9a3f6..bf8a9df 100644
--- a/scripts/spring-2026-move.console.js
+++ b/scripts/spring-2026-move.console.js
@@ -5,31 +5,32 @@
 // browser console (⌥⌘J), paste this WHOLE file, press Enter. It never runs on its own
 // from the site — this file isn't deployed (dist/ holds only the app).
 //
-// What it does, in order — stopping with "nothing was changed" at the first problem:
-//   1. Checks you're a manager and reads curriculum/lessonData, lessons_spring-2026 and
-//      storageMigrations fresh from the server: Spring must be in lessonData, its own
-//      document must not exist yet, and there must be no earlier move record.
-//   2. Downloads a JSON backup of Spring's lessons and asks you to confirm.
-//   3. ONE transaction: creates lessons_spring-2026 from the lessons read inside the
-//      transaction, removes spring-2026 from lessonData, and records the move
-//      (lesson count + SHA-256 fingerprint, verified: false). All or nothing.
-//   4. Verifies from fresh server reads: the new document's lessons have the same count
-//      and fingerprint, and lessonData no longer holds Spring. Spring edits are paused by
-//      the rules throughout, so nothing can change in between.
-//   5a. Passed → marks the move verified (Spring becomes editable again) and reports the
-//       new lessonData size.
-//   5b. Failed → one transaction puts Spring back into lessonData and removes the new
-//       document and the record (only allowed while unverified), exactly as before.
+// SAFE TO RE-RUN. It first works out which state the data is in:
+//   • not moved yet      → checks every value is a plain type it can back up exactly, downloads

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/tinker-backups/backup.js | sed -n '340,415p' && rg -n -C 4 \"backup.js|lessons_\\*|computeClassbookContentByTeacher|Phase C prerequisite|tally\" /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
   340	  return { stringValue: String(v) };
   341	}
   342	
   343	async function writeBackupStatus(token, statusData) {
   344	  const url = `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/backupStatus/latest`;
   345	  const fields = {};
   346	  for (const [k, v] of Object.entries(statusData)) {
   347	    fields[k] = toFirestoreValue(v);
   348	  }
   349	  const res = await fetch(url, {
   350	    method: 'PATCH',
   351	    headers: { Authorization: `Bearer ${token}`, 'Content-Type': 'application/json' },
   352	    body: JSON.stringify({ fields }),
   353	  });
   354	  const data = await res.json();
   355	  if (data.error) throw new Error(`Status write failed: ${JSON.stringify(data.error)}`);
   356	}
   357	
   358	// Classbook Data Safety Plan Stage 4A — per-teacher content-doc counts, so the
   359	// Classbook admin dashboard can compare "today's live count" against the most
   360	// recent backup-derived count and flag a per-teacher drop. Reads only from
   361	// data already fetched into memory this run (backup.collections) — no extra
   362	// network calls. Isolated behind its own try/catch at the call site below so
   363	// a bug here can never break the backup run itself for every other app.
   364	const CLASSBOOK_CONTENT_FIELDS = ['introPitch', 'processStep1', 'processStep2', 'processStep3', 'processStep4', 'closure', 'dayOfMaterials'];
   365	
   366	function classbookLessonHasContent(lesson) {
   367	  return !!lesson && CLASSBOOK_CONTENT_FIELDS.some(f => lesson[f] && String(lesson[f]).trim());
   368	}
   369	
   370	function computeClassbookContentByTeacher(collections) {
   371	  const counts = {};
   372	  const tally = (lesson) => {
   373	    if (!lesson || !lesson.teacher || !classbookLessonHasContent(lesson)) return;
   374	    counts[lesson.teacher] = (counts[lesson.teacher] || 0) + 1;
   375	  };
   376	
   377	  // Summer path: summerCamps_lessonData, one doc per lesson, doc has .teacher.
   378	  const summerDocs = collections['summerCamps_lessonData'] || {};
   379	  for (const lesson of Object.values(summerDocs)) tally(lesson);
   380	
   381	  // Non-summer path: curriculum/lessonData doc, nested { semesterKey: { lessonKey: {...} } }.
   382	  const lessonDataDoc = (collections['curriculum'] || {})['lessonData'] || {};
   383	  for (const semesterLessons of Object.values(lessonDataDoc)) {
   384	    if (!semesterLessons || typeof semesterLessons !== 'object') continue;
   385	    for (const lesson of Object.values(semesterLessons)) tally(lesson);
   386	  }
   387	
   388	  return counts;
   389	}
   390	
   391	async function main() {
   392	  if (!isWithinBackupWindow() && !process.argv.includes('--force')) {
   393	    // Silent exit outside business hours
   394	    process.exit(0);
   395	  }
   396	
   397	  log('Starting backup...');
   398	  const startMs = Date.now();
   399	  const previousCounts = loadPreviousCounts();
   400	
   401	  try {
   402	    const token = await getAccessToken();
   403	    log('Authenticated via Firebase CLI credentials');
   404	
   405	    const backup = {
   406	      exportedAt: new Date().toISOString(),
   407	      totalCollections: COLLECTIONS.length,
   408	      collections: {},
   409	    };
   410	
   411	    let totalDocs = 0;
   412	    const errorCollections = [];
   413	    for (const col of COLLECTIONS) {
   414	      try {
   415	        const docs = await fetchCollection(token, col);
32-<div class="meta" id="plan-meta">
33-  <strong>Goal:</strong> Teachers never hit a wall where lesson saves stop working. Spring 2026, a finished semester, moves out of the almost-full shared document into its own, with no lesson lost or changed, and Spring stays viewable exactly as today.<br>
34-  <strong>Why now:</strong> On Sep 29, 2026 Christie measured <code>curriculum/lessonData</code> at <strong>972 KB of 1,024 KB (95%)</strong> from a forced server read: <code>spring-2026</code> 551 KB, <code>fall-2026</code> 420 KB. It's real content spread over hundreds of lessons (the largest field is 2.5 KB), so there's nothing to trim. At the cap, <strong>every weekly lesson save fails for everyone</strong>. Fall is being written into it right now.<br>
35-  <strong>Scope (revision 2):</strong> <strong>Spring 2026 only, with its key written literally into the code and the rules.</strong> Spring ran Jan–May and is dormant, so the move needs no new UI and no config flags. Moving Fall, making every new semester get its own document, and the <code>createNewSemester</code>/<code>deleteSemester</code> changes that requires are a <strong>follow-up plan</strong>. That plan must land before the next semester is created (see "Follow-up").<br>
36:  <strong>Touches:</strong> the Classbook (<code>js/firebase-data.js</code>, <code>js/app.js</code>), <code>studio-hub/firestore.rules</code> + <code>studio-hub/rules.test.js</code> (sha phrase + guard), <code>studio-hub/js/alerts.js</code> (Studio Hub deploy), and <code>tinker-backups/backup.js</code>, <strong>which only Christie edits</strong> (memory: <code>backup-js-uses-cli-token</code>).<br>
37-  <strong>Line numbers</strong> at <code>2ef2e62</code>. <strong>Status:</strong> <span class="status-tag ready">execution-ready: true</span>. Revision 5. Reviewed by Claude (round 1) and Codex (rounds 1–3). Codex round 3 left one edit, now made. Waiting for Christie's go-ahead to build.
38-</div>
39-
40-<div class="danger">
--
52-  <tr><td>Rules: <code>:654</code> is <code>allow read, write: if isManagerOrAbove()</code>, and <code>:666</code> is a separate create/update for classbook roles (not appData/prepCycleConfig). Rules OR across statements, so fencing a key for managers too means <strong>splitting <code>:654</code></strong> into per-operation statements. Whole-doc delete is limited to classbook-admin/curriculum-admin (<code>:675-678</code>). <code>studio-hub/rules.test.js</code> has no <code>curriculum/lessonData</code> fixture today.</td><td><code>studio-hub/firestore.rules:652-678</code></td></tr>
53-  <tr><td>Outside the Classbook, readers of <code>curriculum/lessonData</code>:
54-    <ul>
55-      <li>Studio Hub's Q&amp;A alerts (<code>studio-hub/js/alerts.js:559-580</code>, iterating every top-level key).</li>
56:      <li><strong><code>tinker-backups/backup.js</code></strong>: it backs up the <code>curriculum</code> collection as Tier 1 (<code>:38, :56</code>; new <code>lessons_*</code> docs are included automatically), and <code>computeClassbookContentByTeacher</code> (<code>:370-389</code>) counts per-teacher content from <code>curriculum/lessonData</code> only, writing <code>backupStatus/latest</code> (<code>:471</code>) with a 10% drop alarm. The Classbook's <code>renderContentCount()</code> (<code>app.js:7578-7600</code>) compares live counts to that baseline.</li>
57-      <li><code>studio-hub/test-alerts.js:98, 143</code>: an Admin SDK test script that writes <code>lessonData.qaData</code>. It bypasses rules and isn't part of the app.</li>
58-      <li>The <code>summer-camp-app/scripts/backup-firestore.js</code> console script is manual and weekly, not the nightly backup (a round-1 correction).</li>
59-    </ul></td><td>as cited</td></tr>
60-</table>
--
170-  Then lessons_spring-2026 deep-equals the old map (+ lastUpdated*), lessonData has no spring-2026, storageMigrations records count + hash, verified → true, Spring editable, Fall untouched
171-Scenario: target already exists → refuses before any write
172-Scenario: verification fails (simulated) → the reverse transaction restores lessonData['spring-2026'] byte-identical and removes the target
173-Scenario: a pre-Phase-B tab after the move → its Spring edit is refused by the rules (no data loss)</div>
174:<div class="note"><strong>The backup script edit (Christie gave permission for this change, Sep 29):</strong> <em>before</em> Phase C, and with Christie's go-ahead confirmed again at that moment, Claude adds the five lines recorded in the Decisions Log to <code>tinker-backups/backup.js</code> (<code>computeClassbookContentByTeacher</code>, just before <code>return counts;</code>). It keeps a <code>.bak</code> copy, checks the syntax with <code>node --check</code>, doesn't run the script, and touches nothing else, above all not the credential code. Because the move is one step, the backup never sees Spring twice.</div>
175-</div>
176-
177-<h2 id="followup">Follow-up plan (required before the next semester is created)</h2>
178-<div class="note">After Phase C, <code>lessonData</code> holds Fall (about 420 KB and growing). <strong>Before Spring 2027 is created</strong> (or before <code>lessonData</code> passes about 70%), a follow-up plan must:
--
186-
187-<h2 id="safety">Firebase safety checklist</h2>
188-<div class="safe"><ul>
189-  <li><strong>Rules:</strong> Phase A is a shared-rules change: tests for all five roles, a near-1 MB fixture, the whole suite green, then <code>deploy-rules.sh --approved &lt;sha&gt;</code> after the phrase. The new docs (<code>lessons_spring-2026</code>, <code>storageMigrations</code>) get explicit conditions in the <code>curriculum/{docId}</code> block.</li>
190:  <li><strong>Backups (checked Sep 29):</strong> <code>backup.js</code> fetches <em>every</em> document in each listed collection (<code>fetchCollection</code>, <code>:221-247</code>), so <code>lessons_spring-2026</code> and <code>storageMigrations</code> are in every 30-minute backup automatically. The Tier-1 count check counts documents, and <code>curriculum</code> gains two, so there's no false alarm there. The per-teacher content count is covered by the five-line edit.</li>
191:  <li><strong>Snapshot:</strong> a JSON download right before the move, plus <code>tinker-backups/backup.js</code>'s automatic 30-minute backups of the <code>curriculum</code> collection (Tier 1).</li>
192-  <li><strong>Atomic:</strong> the copy, the old-copy removal and the migration record are one transaction.</li>
193-  <li><strong>Verified</strong> from forced-server reads while edits are paused by rule, before anything is unpaused.</li>
194-  <li><strong>Reversible:</strong> a reverse transaction until verified. After that, the download and backups.</li>
195-  <li><strong>Partial updates:</strong> per-field dotted paths as today. <code>saveLessonData</code>'s whole-semester merge-set becomes a whole-document merge-set for own-doc semesters (still <code>merge: true</code>).</li>
--
206-<h2 id="resume">Resume instructions</h2>
207-<ol>
208-  <li>Read this plan and its Decisions Log. Re-measure lessonData first.</li>
209-  <li>Phase A in <code>studio-hub</code> (branch, merge to main, then the guard). Phase B in a Classbook worktree off <code>origin/main</code>, plus Studio Hub for the alerts. Re-check the line numbers.</li>
210:  <li>Per phase: commit, run the full suite, then a second-model implementation review. Each deploy, the backup.js edit, and Phase C each need Christie's own yes. Phase A needs the sha phrase.</li>
211-</ol>
212-
213-<h2 id="decisions">Decisions Log (append-only)</h2>
214-<div class="decision">
215:  <strong>Sep 30, 2026: the 3-day stale-tab wait is dropped (Christie).</strong> Everyone works in Fall. A pre-Phase-B tab can't lose data, because the Phase A rules refuse its Spring writes, and Fall is untouched by the move. The only effect is that Spring may <em>look</em> empty in such a tab until it's refreshed, which Christie accepts. The move is planned for tonight, Sep 30, after the procedure is written, rehearsed in the emulator and reviewed, and after the backup.js edit. The staff "please refresh" note is optional.
216-</div>
217-<div class="decision">
218-  <strong>Sep 30, 2026: Phase B (Studio Hub) DEPLOYED, so Phase B is complete.</strong> Christie approved. studio-hub PR #3 was merged as <code>a254b15</code>: the Q&amp;A alerts union (<code>bd5fd10</code>, <code>85a488c</code>) plus the publishing fix (<code>4b785ca</code>, <code>943d760</code>). Studio Hub now publishes only a <code>git archive</code> allow-list through <code>npm run deploy</code> (pinned site id). The live check was ok: every file MATCH, and all 18 previously exposed private paths are GONE (including <code>setup/migration-log.txt</code> with staff names and uids, and <code>firebase-agent-defense-hardening.md</code>).<br>
219:  <strong>Phase C prerequisites:</strong>
220-  <ul>
221-    <li>Phase B has been live for 3 days or more (Classbook since Sep 30, so Oct 3 at the earliest).</li>
222-    <li>Staff are asked the day before to close and reopen the Classbook.</li>
223:    <li>The five-line <code>tinker-backups/backup.js</code> edit, with Christie's OK confirmed at the time.</li>
224-    <li>The console procedure is written into this plan, rehearsed by an e2e test in the emulator, and reviewed.</li>
225-    <li>Christie's go-ahead, at a quiet time.</li>
226-  </ul>
227-</div>
--
245-<div class="decision">
246-  <strong>Sep 29, 2026: Phase A DEPLOYED.</strong> studio-hub commits <code>355f515</code>, <code>74de78d</code> and <code>788ad38</code> were merged as PR #2 (<code>0caf415</code>). The Codex implementation review took three rounds: round 1 found the rollback didn't require the target to exist and that <code>verified</code> could be reversed; round 2 found <code>verified</code> was judged on the pre-write state; round 3 said "safe to merge and deploy". 161 new rules tests; full suite 524 rules + 141 guard tests. Christie said "approved to change firebase 0caf4153330fdba7185ba060172d076689047581". Deployed through <code>deploy-rules.sh</code>, receipt <code>deployed/tinker-hq-apps/firestore-rules/20260929T223336Z-0caf415</code>. Rollback target: <code>e572a09</code>. <strong>Spring 2026 is now view-only in production.</strong> Next: Phase B.
247-</div>
248-<div class="decision">
249:  <strong>Sep 29, 2026: revision 5, EXECUTION-READY.</strong> Codex round 3 (<code>…-codex-r3.md</code>) confirmed fixes 2 and 3, and confirmed the rules design is implementable (<code>existsAfter</code>, all split statements constrained). Its single remaining item: the Phase A update-condition summary was missing the rollback branch, which is now added with Codex's exact form. All phases are marked execution-ready. Build waits for Christie's go-ahead. Deploys, the backup.js edit and Phase C each still need her own yes, and Phase A needs the sha phrase.
250-</div>
251-<div class="decision">
252-  <strong>Sep 29, 2026: revision 4, after Codex round 2 (<code>…-codex-r2.md</code>).</strong> Codex confirmed 6 of its 8 round-1 items resolved, including that the forward transaction works under the Phase A rules. Three fixes taken:
253-  <ol>
--
266-    <li>(7) Spring's delete is disabled in Phase B.</li>
267-    <li>(8) Merged <code>storageMigrations</code> writes, target-disappearance behaviour, and a Firestore-size estimator for the readout with an 85% warning.</li>
268-  </ul>
269-  The inventory adds <code>studio-hub/test-alerts-browser.html:227</code> and <code>TESTING-GUIDE.md:115</code> (manual, root <code>qaData</code> only).<br>
270:  <strong>Christie (Sep 29):</strong> she can't edit <code>backup.js</code> herself, and gave <strong>permission for Claude to make that one five-line change</strong> (keep a .bak, <code>node --check</code>, don't run it, touch nothing else), to be confirmed again at the time.
271-</div>
272-<div class="decision">
273:  <strong>Sep 29, 2026: Christie's answers.</strong> (Q1) Spring 2026 being view-only from Phase A until Phase C is fine. (Q2) Christie will paste the <code>backup.js</code> change herself (option a) before Phase D. The exact lines, for <code>tinker-backups/backup.js</code> inside <code>computeClassbookContentByTeacher</code>, just before <code>return counts;</code>:
274-<pre style="font-size:.85rem">  // Own-document semesters: curriculum/lessons_&lt;semKey&gt; = { lessonKey: lesson, lastUpdated, … }.
275-  for (const [docId, doc] of Object.entries(collections['curriculum'] || {})) {
276-    if (!docId.startsWith('lessons_') || !doc || typeof doc !== 'object') continue;
277:    for (const lesson of Object.values(doc)) if (lesson &amp;&amp; typeof lesson === 'object') tally(lesson);
278-  }</pre>
279:  It's generic over <code>lessons_*</code>, so Fall's later move needs no second edit. <code>tally</code> ignores non-lesson values (<code>lastUpdated</code> strings have no <code>.teacher</code>). Also: Christie asked whether Spring stays reachable after the move. Yes: it stays in every semester list and is fully viewable, and it's editable again after Phase C.
280-</div>
281-<div class="decision">
282:  <strong>Sep 29, 2026: revision 2, after review round 1 (Claude; <code>thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md</code>): NOT ready, 11-point minimum list, all taken.</strong> Re-scoped to <strong>Spring only, hard-coded</strong>, with no appData flags, <code>migratedSemesters</code>, UI buttons or "Move back". The copy and the removal are reviewed console procedures. The rules fence uses a literal key (no <code>get(appData)</code>), splits <code>:654</code>, and ships <strong>first</strong>. Fixed: the listener drops own-doc semesters (A); verify races (B, moot now that the fence freezes the source first); Phase D's precondition compares against the hash of what was written (C); vanished keys are loud (D); <code>not-found</code> on first write (E); <code>createNewSemester</code>/<code>deleteSemester</code> deferred to the follow-up plan, with a deadline (F, delete); the missing readers are added (<code>tinker-backups/backup.js</code>, which is Christie's edit, the in-app content count, <code>test-alerts.js</code>, dead backup helpers, e2e exemptions, seed); the backup citation and "nightly" are corrected; the listener generation is decided (no bump); teardown uses an array; a near-1 MB rules fixture is added; there's a headroom readout; and the emergency lever's order is fixed.<br>
283:  <strong>Open questions for Christie:</strong> (Q1) Is it OK that Spring 2026 is read-only ("editing is paused") from Phase A until Phase C, probably a few days? (Q2) Will you make the small <code>backup.js</code> edit before Phase D, or accept one expected content-loss alarm for Spring teachers? (Q3, for the reviewer) Undoing a bad Phase C copy needs a whole-doc delete of <code>lessons_spring-2026</code>; today only classbook-admin/curriculum-admin may whole-doc delete (<code>:675-678</code>). Should Phase A's split give managers delete as well (they have it today through <code>:654</code>'s <code>write</code>)? The plan assumes yes: the split keeps manager delete.
284-</div>
285-<div class="decision">
286-  <strong>Sep 29, 2026: plan created (draft 1).</strong> Found while reviewing the make-active plan's Archive design (now paused behind this plan). Christie measured 972 KB / 1,024 KB.
287-</div>

exec
/bin/zsh -lc 'rg -n "lastUpdated|lastUpdatedBy|weeklyLessonPath|lessonKey" js/firebase-data.js | head -100 && rg -n "function generate|lessonKey =|const lessonKey|lessonId" js/app.js js/firebase-data.js | head -100' in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
106:  delete map.lastUpdated;
107:  delete map.lastUpdatedBy;
364:    lastUpdated: new Date().toISOString(),
365:    lastUpdatedBy: user?.name || 'Unknown',
653:    lastUpdated: null,
654:    lastUpdatedBy: null
691:  weekData.lastUpdated = new Date().toISOString();
692:  weekData.lastUpdatedBy = user?.name || 'Unknown';
861:    lastUpdated: new Date().toISOString(),
862:    lastUpdatedBy: user?.name || 'Unknown'
1012:  const stamp = { lastUpdated: new Date().toISOString(), lastUpdatedBy: user?.name || 'Unknown' };
1027:async function deleteLessonKey(semesterKey, lessonKey) {
1032:    [`${prefix}${lessonKey}`]: firebase.firestore.FieldValue.delete(),
1033:    lastUpdated: new Date().toISOString(),
1034:    lastUpdatedBy: user?.name || 'Unknown'
1051:  // Save each lesson as a separate document (lessonKey as doc ID)
1052:  for (const [lessonKey, lessonData] of Object.entries(lessons)) {
1055:    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
1064:      lastUpdated: new Date().toISOString(),
1065:      lastUpdatedBy: user?.name || 'Unknown'
1114:async function getSummerLessonQaThread(semKey, lessonKey) {
1116:  const doc = await curriculumDb.collection('summerCamps_prepHelpQueue').doc(summerDocIdFor(semKey, lessonKey)).get();
1125:async function sendSummerLessonQaMessage(semKey, lessonKey, lesson, newMsg) {
1132:  const docRef = curriculumDb.collection('summerCamps_prepHelpQueue').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
1144:      lessonKey,
1151:      lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
1157:      lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
1232:const displacedKey = (semKey, lessonKey) => `${semKey}|${lessonKey}`;
1479:    lastUpdated: new Date().toISOString(),
1480:    lastUpdatedBy: user?.name || 'Unknown'
1503:    lastUpdated: new Date().toISOString(),
1504:    lastUpdatedBy: user?.name || 'Unknown'
1567:  dismissals.lastUpdated = new Date().toISOString();
1568:  dismissals.lastUpdatedBy = user?.name || 'Unknown';
1626:async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
1640:  if (isDayOffYear(semesterKey)) return saveDayOffPlan(semesterKey, lessonKey, lessonData, fieldsToClear, opts.dayOffAuth);
1642:  console.log('💾 Attempting to save lesson:', { semesterKey, lessonKey, user: user?.email });
1659:      console.warn('⛔ saveSingleLesson blocked — all content fields empty, refusing to overwrite:', lessonKey);
1674:    console.log('💾 Saving Summer Camp lesson to summerCamps_lessonData:', lessonKey);
1675:    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semesterKey, lessonKey));
1677:    console.log('✅ Saved Summer Camp lesson:', lessonKey);
1693:  // semesterKey.lessonKey path replaces the ENTIRE lesson there — so write
1697:  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear, prefix);
1718:function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = [], prefix = `${semesterKey}.`) {
1726:    updates[`${prefix}${lessonKey}.${field}`] = value;
1754:  for (const { lessonKey, lessonData, fieldsToClear } of writes) {
1757:    Object.assign(combined, buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear || [], prefix));
1759:  for (const lessonKey of deletes) {
1760:    combined[`${prefix}${lessonKey}`] = firebase.firestore.FieldValue.delete();
1762:  combined.lastUpdated = new Date().toISOString();
1763:  combined.lastUpdatedBy = user?.name || 'Unknown';
1793:function getPhotoPath(semesterKey, lessonKey /* filename: ignored — resizeImage() always re-encodes to JPEG */) {
1794:  // Store at curriculum/{semester}/{lessonKey}/demo-{unique}.jpg
1795:  return `curriculum/${semesterKey}/${lessonKey}/demo-${uniquePhotoSuffix()}.jpg`;
1798:async function uploadLessonPhoto(semesterKey, lessonKey, file) {
1803:  const path = getPhotoPath(semesterKey, lessonKey, 'demo.jpg');
1814:async function uploadSummerCampPhoto(semKey, lessonKey, file) {
1827:  const path = `summerCamps/${summerDocIdFor(semKey, lessonKey)}/demo-${uniquePhotoSuffix()}.jpg`;
2039:            const lessonKey = `${teacher}|||${campTopic}|||${blockName}|||${projectTitle}`;
2041:            lessons[lessonKey] = {
2091:        const lessonKey = decodeFirestoreKey(parsed.legacyId);
2095:        if (lessons[lessonKey]) {
2097:          lessons[lessonKey] = {
2098:            ...lessons[lessonKey],
2099:            introPitch: savedData.introPitch || lessons[lessonKey].introPitch,
2100:            processStep1: savedData.processStep1 || lessons[lessonKey].processStep1,
2101:            processStep2: savedData.processStep2 || lessons[lessonKey].processStep2,
2102:            processStep3: savedData.processStep3 || lessons[lessonKey].processStep3,
2103:            processStep4: savedData.processStep4 || lessons[lessonKey].processStep4,
2104:            closure: savedData.closure || lessons[lessonKey].closure,
2105:            dayOfMaterials: savedData.dayOfMaterials || lessons[lessonKey].dayOfMaterials,
2106:            photoUrl: savedData.photoUrl || lessons[lessonKey].photoUrl || '',
2107:            photoPath: savedData.photoPath || lessons[lessonKey].photoPath || '',
2190:let currentDayOffPlans = {};    // yearKey → { lessonKey: plan doc }
2344:      const lessonKey = dayOffLessonKey(yearKey, camp.id, projectTitle);
2345:      slots[lessonKey] = {
2346:        ...(plans[lessonKey] || {}),
2363:        materialsList: plans[lessonKey]?.materialsList || [],
2857:const dayOffVerifiedAt = {};   // yearKey → { lessonKey: seq }
2871:function dayOffInstallVerified(yearKey, lessonKey, data) {
2873:  if (data) map[lessonKey] = data; else delete map[lessonKey];
2874:  (dayOffVerifiedAt[yearKey] = dayOffVerifiedAt[yearKey] || {})[lessonKey] = ++dayOffInstallSeq;
2880:function dayOffFindProject(yearKey, lessonKey) {
2883:      if (dayOffLessonKey(yearKey, camp.id, title) === lessonKey) return { campId: camp.id, projectTitle: title };
2891:async function readDayOffPlanForEditor(yearKey, lessonKey) {
2892:  const slot = dayOffFindProject(yearKey, lessonKey);
2896:  dayOffInstallVerified(yearKey, lessonKey, snap.exists ? snap.data() : null);
2897:  return currentLessonData[yearKey]?.[lessonKey] || null;
2910:async function saveDayOffPlan(yearKey, lessonKey, lessonData, fieldsToClear = [], auth) {
2913:  const found = dayOffFindProject(yearKey, lessonKey);
2916:  if (lessonKey !== dayOffLessonKey(yearKey, campId, projectTitle)) throw new Error('This plan key does not match its camp and project — refusing to save.');
2978:    dayOffInstallVerified(yearKey, lessonKey, null);
2982:  dayOffInstallVerified(yearKey, lessonKey, server);
3099:  const lessonKey = dayOffLessonKey(yearKey, campId, title);
3102:    dayOffInstallVerified(yearKey, lessonKey, null);
3106:  dayOffInstallVerified(yearKey, lessonKey, server);
js/firebase-data.js:1759:  for (const lessonKey of deletes) {
js/firebase-data.js:2039:            const lessonKey = `${teacher}|||${campTopic}|||${blockName}|||${projectTitle}`;
js/firebase-data.js:2091:        const lessonKey = decodeFirestoreKey(parsed.legacyId);
js/firebase-data.js:2344:      const lessonKey = dayOffLessonKey(yearKey, camp.id, projectTitle);
js/firebase-data.js:3099:  const lessonKey = dayOffLessonKey(yearKey, campId, title);
js/app.js:1770:          const lessonKey = dayOffLessonKey(yearKey, camp.id, title);
js/app.js:1808:  const lessonKey = box.dataset.lessonKey;
js/app.js:1811:  const boxes = () => [...document.querySelectorAll('.sdoc-tv-pc-cb')].filter(b => b.dataset.lessonKey === lessonKey);
js/app.js:2019:  const lessonKeyByObject = new Map(Object.entries(lessons).map(([key, l]) => [l, key]));
js/app.js:2317:      let lessonKey = cb.dataset.lessonKey && lessons[cb.dataset.lessonKey] ? cb.dataset.lessonKey : null;
js/app.js:2321:            if (l.teacher === tvCurrentTeacher) { lessonKey = key; break; } // exact match for the current teacher
js/app.js:2322:            if (!lessonKey) lessonKey = key; // fallback (admin viewing another teacher's slot)
js/app.js:2715:  const lessonKey = makeLessonKey(lesson.teacher, lesson.className, lesson.weekNum);
js/app.js:2879:      const lessonKey = cb.dataset.lessonKey;
js/app.js:3883:      const lessonKey = data.lessonKey || decodeFirestoreKey(parseSummerDocId(doc.id).legacyId);
js/app.js:3912:      const lessonKey = data.lessonKey || decodeFirestoreKey(parseSummerDocId(doc.id).legacyId);
js/app.js:4078:function generatePrintOutput(weekNum, weekLessons) {
js/app.js:4509:      const lessonKey = `${sess.teacher}-${campTopic}-${block}-${weekNum}`;
js/app.js:5015:          const lessonKey = makeLessonKey(teacher, className, w);
js/app.js:11530:      const lessonKey = makeLessonKey(teacher, className, weekNum);
js/app.js:11606:  let lessonKey = null;
js/app.js:11611:        lessonKey = key;
js/app.js:11616:        lessonKey = key; // fallback (admin viewing another teacher's slot)
js/app.js:12438:function generateSummerPrintOutput(campName, projects, allCampLessons) {

exec
/bin/zsh -lc "nl -ba js/firebase-data.js | sed -n '45,120p;980,1045p;1440,1515p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
    45	const LEGACY_CAMP_SEMESTER_KEY = 'summer-2026';
    46	function semesterTypeOf(semKey) {
    47	  const stored = currentConfig?.semesters?.[semKey]?.semesterType;
    48	  if (stored) return stored;
    49	  if (semKey === LEGACY_CAMP_SEMESTER_KEY) return SEMESTER_TYPES.camp;
    50	  return SEMESTER_TYPES.weekly;
    51	}
    52	// Read the type only through these — never re-derive it from a key.
    53	function isCampSeason(semKey) { return semesterTypeOf(semKey) === SEMESTER_TYPES.camp; }
    54	function isWeeklySemester(semKey) { return semesterTypeOf(semKey) === SEMESTER_TYPES.weekly; }
    55	
    56	// Which lesson store a semester's lessons live in: 'camp' (one document per
    57	// lesson in summerCamps_lessonData) or 'weekly' (one nested map inside the
    58	// shared curriculum/lessonData document). The seven sites that choose between
    59	// those two stores — the four lesson writers, the two admin reply writers and
    60	// the existence check — all route through this, so a THIRD type is refused
    61	// rather than treated as weekly: the reply writers' weekly branch update()s
    62	// dotted `{semKey}.{key}.qaThread` paths, which for an SDOC key would quietly
    63	// create a nested map inside the shared weekly document (camp seasons
    64	// Phase 1, 1.1; cross-plan with classbook-school-day-off-camps).
    65	function lessonStoreFor(semKey) {
    66	  const type = semesterTypeOf(semKey);
    67	  switch (type) {
    68	    case SEMESTER_TYPES.camp:   return 'camp';
    69	    case SEMESTER_TYPES.weekly: return 'weekly';
    70	    default:
    71	      throw new Error(`Semester "${semKey}" is a "${type}" semester — this app has no lesson store for that type yet, so it refuses to read or write its lessons.`);
    72	  }
    73	}
    74	
    75	// ─── Own-document weekly semesters (Spring 2026 storage move, Sep 2026) ──────
    76	// curriculum/lessonData holds every weekly semester in ONE Firestore document,
    77	// and it reached 95% of the 1 MiB document cap (Sep 29 2026). A finished weekly
    78	// semester moves to its own document, curriculum/lessons_<semKey>, in one manager
    79	// transaction. Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html
    80	// (Phase B). The studio-hub rules (Phase A, deployed 0caf415) fence the key in
    81	// lessonData, and allow edits to the new document only once
    82	// curriculum/storageMigrations says the move is verified.
    83	//
    84	// Changed only by a code deploy, just as the rules fence changes only by a rules deploy.
    85	const OWN_DOC_SEMESTERS = ['spring-2026'];
    86	const OWN_DOC_PAUSED_MESSAGE = 'Spring 2026 is being moved to new storage — editing it is paused for a few days. Viewing works as normal.';
    87	
    88	function isOwnDocSemester(semKey) { return OWN_DOC_SEMESTERS.includes(semKey); }
    89	function ownDocIdFor(semKey) { return `lessons_${semKey}`; }
    90	
    91	// Where each own-doc semester's lessons are served from right now:
    92	// 'legacy' (still inside lessonData), 'ownDoc' (its own document), or 'error'
    93	// (its document couldn't be read — shown from whatever we have, never writable).
    94	const ownDocSource = {};
    95	// curriculum/storageMigrations as last read ({} when absent; null = not yet known).
    96	let storageMigrationState = null;
    97	// The last legacy lessonData snapshot, so a rollback (own doc disappears) can fall
    98	// back to it, and the headroom readout can size it without another read.
    99	let lastLegacyLessonData = null;
   100	
   101	function ownDocMoveVerified(semKey) {
   102	  return storageMigrationState?.[semKey]?.verified === true;
   103	}
   104	function ownDocLessonMap(data) {
   105	  const map = { ...(data || {}) };
   106	  delete map.lastUpdated;
   107	  delete map.lastUpdatedBy;
   108	  return map;
   109	}
   110	
   111	// The ONE place a weekly lesson write learns where to go. Returns the document
   112	// and the dotted-path prefix for a lesson inside it:
   113	//   legacy semester → curriculum/lessonData, '<semKey>.'
   114	//   own-doc semester → curriculum/lessons_<semKey>, '' — only once the move is
   115	//                      verified; before that it throws the "editing is paused" message
   116	//                      (the rules refuse those writes anyway).
   117	function weeklyLessonTarget(semKey) {
   118	  if (!curriculumDb) initCurriculumFirestore();
   119	  if (!isOwnDocSemester(semKey)) {
   120	    return { ref: curriculumDb.collection('curriculum').doc('lessonData'), prefix: `${semKey}.` };
   980	  } catch (err) {
   981	    console.error('Error loading lesson data:', err);
   982	    currentLessonData = {};
   983	    lessonDataLoadedSuccessfully = false;
   984	  }
   985	  return currentLessonData;
   986	}
   987	
   988	// Whole-semester bulk writer (restoreFromBackup, createNewSemester,
   989	// createLessonSlotsForRoster). Guarded the same way as
   990	// saveSingleLesson(): after a failed load, `lessons` is built from an empty or
   991	// partial currentLessonData (or, for restoreFromBackup, would land over a
   992	// semester whose current state this client never confirmed), and merge:true
   993	// would still write it over the real semester map. Throws rather than no-ops —
   994	// every caller treats a resolved promise as "the write landed" (backtracking
   995	// audit, Phase 11).
   996	async function saveLessonData(semesterKey, lessons) {
   997	  if (lessonDataLoadedSuccessfully === false) {
   998	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
   999	  }
  1000	  if (!curriculumDb) initCurriculumFirestore();
  1001	
  1002	  // Route by the semester's TYPE, never by its key (Phase 1, 1.1): camp
  1003	  // seasons go to the per-lesson collection (also dodging the 1MB doc limit),
  1004	  // and any other type is refused rather than misrouted.
  1005	  if (lessonStoreFor(semesterKey) === 'camp') {
  1006	    return await saveSummerCampLessonData(semesterKey, lessons);
  1007	  }
  1008	
  1009	  // Regular semester: save to curriculum/lessonData — or, for an own-doc
  1010	  // semester, to its own document (the whole map at the top level).
  1011	  const user = getAuthUser();
  1012	  const stamp = { lastUpdated: new Date().toISOString(), lastUpdatedBy: user?.name || 'Unknown' };
  1013	  if (isOwnDocSemester(semesterKey)) {
  1014	    const { ref } = weeklyLessonTarget(semesterKey);   // throws "editing is paused" until verified
  1015	    await ref.set({ ...lessons, ...stamp }, { merge: true });
  1016	    return;
  1017	  }
  1018	  await curriculumDb.collection('curriculum').doc('lessonData').set({
  1019	    [semesterKey]: lessons,
  1020	    ...stamp
  1021	  }, { merge: true });
  1022	}
  1023	
  1024	// Explicitly delete a single lesson key from the nested map.
  1025	// More reliable than resaving the full semester when cutting a project,
  1026	// because Firestore's merge:true may not remove nested map keys.
  1027	async function deleteLessonKey(semesterKey, lessonKey) {
  1028	  if (!curriculumDb) initCurriculumFirestore();
  1029	  const user = getAuthUser();
  1030	  const { ref, prefix } = weeklyLessonTarget(semesterKey);
  1031	  await ref.update({
  1032	    [`${prefix}${lessonKey}`]: firebase.firestore.FieldValue.delete(),
  1033	    lastUpdated: new Date().toISOString(),
  1034	    lastUpdatedBy: user?.name || 'Unknown'
  1035	  });
  1036	}
  1037	
  1038	async function saveSummerCampLessonData(semKey, lessons) {
  1039	  if (!curriculumDb) initCurriculumFirestore();
  1040	  // Resolved once, before any batch work — a semester with no valid season
  1041	  // throws here, so nothing is queued.
  1042	  const season = seasonForSemester(semKey);
  1043	  const user = getAuthUser();
  1044	  const batch = curriculumDb.batch();
  1045	
  1440	          // Rolled back: the own document is gone — fall back to lessonData.
  1441	          ownDocSource[semKey] = 'legacy';
  1442	          const legacyMap = lastLegacyLessonData?.[semKey];
  1443	          if (legacyMap) currentLessonData[semKey] = legacyMap;
  1444	          else showStorageNotice(`⚠️ ${semKey} storage changed — please reload the page to see its lessons.`);
  1445	        } else {
  1446	          if (ownDocSource[semKey] !== 'error') ownDocSource[semKey] = 'legacy';
  1447	          return;   // nothing changed for this tab
  1448	        }
  1449	        updateOwnDocPausedNotice();
  1450	        if (callback) callback(currentLessonData);
  1451	      }, err => {
  1452	        console.error(`❌ ${ownDocIdFor(semKey)} listener error:`, err);
  1453	        ownDocSource[semKey] = 'error';
  1454	        showStorageNotice(`⚠️ ${semKey} lessons couldn't be loaded from their new storage — please reload the page.`);
  1455	        updateOwnDocPausedNotice();
  1456	      }));
  1457	  }
  1458	}
  1459	
  1460	// ─── Cut Projects (curriculum/cutProjects) ───────────
  1461	
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
