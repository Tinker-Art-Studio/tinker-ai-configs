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
  <strong>Phase C prerequisites:</strong>
  <ul>
    <li>Phase B has been live for 3 days or more (Classbook since Sep 30, so Oct 3 at the earliest).</li>
    <li>Staff are asked the day before to close and reopen the Classbook.</li>
    <li>The five-line <code>tinker-backups/backup.js</code> edit, with Christie's OK confirmed at the time.</li>
    <li>The console procedure is written into this plan, rehearsed by an e2e test in the emulator, and reviewed.</li>
    <li>Christie's go-ahead, at a quiet time.</li>
  </ul>
</div>
<div class="decision">
  <strong>Sep 30, 2026: Phase B (Classbook) DEPLOYED.</strong> Christie approved the merge and deploy. PR #5 was merged as <code>132fef2</code> (tree identical to the reviewed <code>9e551c2</code>). Deployed with <code>npm run deploy</code>, message = full sha, <code>check-live</code> ok (every file MATCH). Spring 2026 now shows the standing "editing is paused" notice. <strong>Studio Hub's half of Phase B isn't deployed yet:</strong> Christie chose to first fix Studio Hub publishing its whole repo (the live site serves <code>setup/migration-log.txt</code> with staff names and UIDs, <code>firebase-agent-defense-hardening.md</code>, <code>CLAUDE.md</code>, rules, test scripts). The fix is to publish only the app's files, deployed together with the alerts update. It must be live before Phase C.
</div>
<div class="decision">
  <strong>Sep 30, 2026: Phase B built and reviewed; ready to deploy (waiting for Christie).</strong><br>
  <strong>Commits:</strong> Classbook <code>claude/spring-own-doc</code>, <code>d34d170</code> → <code>a7f0d0e</code> → <code>9275732</code> → <code>9e551c2</code>. Studio Hub <code>claude/classbook-alerts-own-doc</code>, <code>bd5fd10</code> → <code>85a488c</code>.<br>
  <strong>Deviation from the plan's shape:</strong> <code>lessonStoreFor()</code> still returns <code>'weekly'</code> for Spring, and every weekly write routes through a new <code>weeklyLessonTarget()</code> (document + dotted-path prefix) instead of a new <code>'ownDoc'</code> store value. That's less invasive, and the reviewers confirmed it's complete.<br>
  <strong>Reviews:</strong>
  <ul>
    <li>Codex round 1 (NOT safe): paused Spring actions half-happened (photo upload, Cut Bank, Settings) and the messages were generic; a recheck race; Studio Hub dismissal and error handling; test gaps.</li>
    <li>Codex round 2 (NOT safe): dismissal lifecycle and degraded sources; notice on the migration-listener error; real-UI tests.</li>
    <li>Claude round 2: no code blockers; a test wrote slots into shared emulator data; manager-gate the storage section.</li>
    <li>Codex round 3: <strong>SAFE TO DEPLOY</strong>.</li>
  </ul>
  <strong>Tests:</strong> Classbook 353 passed (the spec has 18 tests, including the real editors with photos, all Q&amp;A, Plan Complete, the verified-path editor save, a real overlapping move→undo, and ratchets; mutation checks confirm the key tests catch their bugs). Studio Hub: 24 unit + 141 guard pass; the emulator rules suite was blocked by another project's emulator on 8080, and there's no rules change. SDOC G1 is flaky on main (tracked as a separate task).<br>
  <strong>Deploys needed:</strong> the Classbook (Netlify credit) and Studio Hub (Netlify credit), both after merging to main.
</div>
<div class="decision">
  <strong>Sep 29, 2026: Phase A DEPLOYED.</strong> studio-hub commits <code>355f515</code>, <code>74de78d</code> and <code>788ad38</code> were merged as PR #2 (<code>0caf415</code>). The Codex implementation review took three rounds: round 1 found the rollback didn't require the target to exist and that <code>verified</code> could be reversed; round 2 found <code>verified</code> was judged on the pre-write state; round 3 said "safe to merge and deploy". 161 new rules tests; full suite 524 rules + 141 guard tests. Christie said "approved to change firebase 0caf4153330fdba7185ba060172d076689047581". Deployed through <code>deploy-rules.sh</code>, receipt <code>deployed/tinker-hq-apps/firestore-rules/20260929T223336Z-0caf415</code>. Rollback target: <code>e572a09</code>. <strong>Spring 2026 is now view-only in production.</strong> Next: Phase B.
</div>
<div class="decision">
  <strong>Sep 29, 2026: revision 5, EXECUTION-READY.</strong> Codex round 3 (<code>…-codex-r3.md</code>) confirmed fixes 2 and 3, and confirmed the rules design is implementable (<code>existsAfter</code>, all split statements constrained). Its single remaining item: the Phase A update-condition summary was missing the rollback branch, which is now added with Codex's exact form. All phases are marked execution-ready. Build waits for Christie's go-ahead. Deploys, the backup.js edit and Phase C each still need her own yes, and Phase A needs the sha phrase.
</div>
<div class="decision">
  <strong>Sep 29, 2026: revision 4, after Codex round 2 (<code>…-codex-r2.md</code>).</strong> Codex confirmed 6 of its 8 round-1 items resolved, including that the forward transaction works under the Phase A rules. Three fixes taken:
  <ol>
    <li>The rollback re-add is explicitly allowed for manager/admin, only while unverified and only with <code>lessons_spring-2026</code> deleted in the same transaction (<code>getAfter</code>). This replaces the test that contradicted it.</li>
    <li>Deleting the new document is manager/admin-only and only while unverified. Other roles are always denied, and everyone is denied after verification until the follow-up plan.</li>
    <li>Studio Hub dismissals are ID-based, so an alert counts as dismissed under its old ID too, and nothing dismissed resurfaces.</li>
  </ol>
</div>
<div class="decision">
  <strong>Sep 29, 2026: revision 3, after Codex's independent round 1 (<code>…-codex-r1.md</code>): NOT ready, 8-point minimum list, all verified and taken.</strong>
commit 05b159b12e37681ab5c6de12d97145d839d43c3f
Author: Christie Hubley <christie@tinkerartstudio.com>
Date:   Wed Sep 30 13:32:37 2026 -0600

    Spring 2026 storage move, Phase C: the console procedure + its emulator rehearsal
    
    scripts/spring-2026-move.console.js is what Christie pastes (as a manager) on the live
    Classbook. It is not deployed (dist/ holds only index.html, assets, css, js).
    Preflight from forced server reads (Spring in lessonData, no own doc, no record) →
    JSON backup download + confirm → ONE transaction: create lessons_spring-2026 from the
    map read inside it, delete lessonData.spring-2026, record count + SHA-256 (verified:
    false) → verify from fresh server reads (count, fingerprint, record, source gone) →
    mark verified (Spring editable again, reports the new size), or on any mismatch undo
    in one transaction (the rules allow it only while unverified) and remove the record.
    Every stop says whether anything changed.
    
    e2e/spring-move-procedure.spec.js runs the EXACT file against the deployed rules:
    happy path (backup contents, server state, the manager tab and an already-open staff
    tab switch to the own doc without ever blanking, and can then save), cancel = no
    change, simulated verification failure = exact undo then a clean re-run, refusals
    when already moved or not a manager, and a ~950 KB document.
    
    Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>

diff --git a/e2e/spring-move-procedure.spec.js b/e2e/spring-move-procedure.spec.js
new file mode 100644
index 0000000..d74ed9e
--- /dev/null
+++ b/e2e/spring-move-procedure.spec.js
@@ -0,0 +1,144 @@
+/**
+ * Rehearsal of the Phase C console procedure (scripts/spring-2026-move.console.js) —
+ * the EXACT file Christie pastes, run in the emulator against the deployed Phase A rules.
+ * Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase C).
+ *
+ * EMULATOR ONLY. Every test starts from and ends at the seeded state (admin helper).
+ */
+const fs = require('fs');
+const path = require('path');
+const { test, expect } = require('@playwright/test');
+const { login, MANAGER_STATE_PATH } = require('./helpers/login');
+const SM = require('./helpers/storage-move');
+
+const PROCEDURE = fs.readFileSync(path.join(__dirname, '..', 'scripts', 'spring-2026-move.console.js'), 'utf8');
+const LESSON = 'fixtureteacher-fixtureclass-1';
+
+test.describe.configure({ mode: 'serial' });
+test.beforeEach(async () => { await SM.resetStorageMove(); });
+test.afterEach(async () => { await SM.resetStorageMove(); });
+
+async function openAs(browser, role) {
+  const ctx = role === 'manager' ? await browser.newContext({ storageState: MANAGER_STATE_PATH, acceptDownloads: true }) : await browser.newContext({ acceptDownloads: true });
+  const page = await ctx.newPage();
+  await login(page, role === 'manager' ? 'manager' : undefined);
+  await page.waitForFunction(() => lessonDataLoadedSuccessfully === true && currentLessonData?.['spring-2026'], null, { timeout: 25_000 });
+  return { ctx, page };
+}
+// Loads the procedure without auto-running; dialogs answered by `answerConfirm`.
+async function runProcedure(page, { answerConfirm = true, opts = {} } = {}) {
+  const dialogs = [];
+  page.on('dialog', d => { dialogs.push(`${d.type()}: ${d.message()}`); d.type() === 'confirm' ? (answerConfirm ? d.accept() : d.dismiss()) : d.accept(); });
+  await page.addScriptTag({ content: `window.__SPRING_MOVE_NO_AUTORUN = true;\n${PROCEDURE}` });
+  const downloadPromise = page.waitForEvent('download', { timeout: 15_000 }).catch(() => null);
+  const result = await page.evaluate((o) => springMove(o), opts);
+  const download = await downloadPromise;
+  return { result, dialogs, download };
+}
+const snapshotAll = async () => ({
+  lessonData: await SM.readCurriculumDoc('lessonData'),
+  target: await SM.readCurriculumDoc(SM.SPRING_DOC),
+  migrations: await SM.readCurriculumDoc('storageMigrations'),
+});
+const stripStamps = (d) => { const m = { ...(d || {}) }; delete m.lastUpdated; delete m.lastUpdatedBy; return m; };
+
+test.describe('Spring 2026 move procedure (Phase C rehearsal)', () => {
+
+  test('happy path: backup downloaded, one-step move, verified, Spring editable; an open tab follows along', async ({ browser }) => {
+    const other = await openAs(browser, 'staff');   // a staff tab open during the move
+    await other.page.evaluate(() => { window.__minSpring = Infinity; window.__w = setInterval(() => { const n = Object.keys(currentLessonData?.['spring-2026'] || {}).length; if (n < window.__minSpring) window.__minSpring = n; }, 25); });
+    const { ctx, page } = await openAs(browser, 'manager');
+
+    const { result, dialogs, download } = await runProcedure(page);
+    expect(result.ok, JSON.stringify(result)).toBe(true);
+    expect(dialogs.some(d => d.startsWith('confirm:') && /backup of Spring 2026 \(3 lessons\)/.test(d))).toBe(true);
+    expect(dialogs.some(d => d.startsWith('alert:') && /Done ✓/.test(d))).toBe(true);
+
+    // The backup file.
+    expect(download).not.toBeNull();
+    const backup = JSON.parse(fs.readFileSync(await download.path(), 'utf8'));
+    expect(backup.lessons).toEqual(SM.springFixture());
+    expect(backup.lessonCount).toBe(3);
+    expect(backup.sha256).toBe(result.sha256);
+
+    // Server state.
+    const after = await snapshotAll();
+    expect(stripStamps(after.target)).toEqual(SM.springFixture());
+    expect(after.lessonData['spring-2026']).toBeUndefined();
+    expect(after.migrations['spring-2026']).toMatchObject({ verified: true, lessonCount: 3, sha256: result.sha256 });
+
+    // The manager tab: Spring from its own doc, editable.
+    await page.waitForFunction(() => ownDocSource['spring-2026'] === 'ownDoc' && weeklySemesterPausedMessage('spring-2026') === null, null, { timeout: 15_000 });
+    // The staff tab that was open during the move: never blank, now on the own doc, and it can save.
+    await other.page.waitForFunction(() => ownDocSource['spring-2026'] === 'ownDoc' && weeklySemesterPausedMessage('spring-2026') === null, null, { timeout: 15_000 });
+    expect(await other.page.evaluate(() => { clearInterval(window.__w); return window.__minSpring; })).toBe(3);
+    const saved = await other.page.evaluate(async (k) => { try { await saveSingleLesson('spring-2026', k, { shortDetails: 'Edited after the move' }); return 'ok'; } catch (e) { return e.message; } }, LESSON);
+    expect(saved).toBe('ok');
+    expect((await SM.readCurriculumDoc(SM.SPRING_DOC))[LESSON].shortDetails).toBe('Edited after the move');
+    await ctx.close(); await other.ctx.close();
+  });
+
+  test('cancel at the confirmation changes nothing', async ({ browser }) => {
+    const before = await snapshotAll();
+    const { ctx, page } = await openAs(browser, 'manager');
+    const { result } = await runProcedure(page, { answerConfirm: false });
+    expect(result.ok).toBe(false);
+    expect(result.message).toMatch(/Cancelled before the move\. Nothing was changed/);
+    expect(await snapshotAll()).toEqual(before);
+    await ctx.close();
+  });
+
+  test('a failed verification undoes the move exactly (and a later run then succeeds)', async ({ browser }) => {
+    const before = await snapshotAll();
+    const { ctx, page } = await openAs(browser, 'manager');
+    const { result } = await runProcedure(page, { opts: { simulateVerifyFailure: true } });
+    expect(result.ok).toBe(false);
+    expect(result.message).toMatch(/move was undone/);
+    const after = await snapshotAll();
+    expect(after.lessonData['spring-2026']).toEqual(SM.springFixture());
+    expect(after.target).toBeNull();
+    expect(after.migrations?.['spring-2026']).toBeUndefined();
+    expect(stripStamps(after.lessonData)).toEqual(stripStamps(before.lessonData));
+
+    const again = await page.evaluate(() => springMove());
+    expect(again.ok, JSON.stringify(again)).toBe(true);
+    expect((await SM.readCurriculumDoc('storageMigrations'))['spring-2026'].verified).toBe(true);
+    await ctx.close();
+  });
+
+  test('refuses (nothing changed) when Spring was already moved', async ({ browser }) => {
+    await SM.stageMoved({ verified: true });
+    const before = await snapshotAll();
+    const { ctx, page } = await openAs(browser, 'manager');
+    const { result, download } = await runProcedure(page);
+    expect(result.ok).toBe(false);
+    expect(result.message).toMatch(/Nothing was changed/);
+    expect(download).toBeNull();
+    expect(await snapshotAll()).toEqual(before);
+    await ctx.close();
+  });
+
+  test('refuses for a non-manager (nothing changed)', async ({ browser }) => {
+    const before = await snapshotAll();
+    const { ctx, page } = await openAs(browser, 'staff');
+    const { result } = await runProcedure(page);
+    expect(result.ok).toBe(false);
+    expect(result.message).toMatch(/Sign in as a manager/);
+    expect(await snapshotAll()).toEqual(before);
+    await ctx.close();
+  });
+
+  test('works on a near-full-size document (~550 KB Spring + ~400 KB other semester)', async ({ browser }) => {
+    const big = (n) => { const o = {}; for (let i = 0; i < n; i++) o[`teacher-class-${i}`] = { teacher: `T${i % 7}`, shortDetails: 'x'.repeat(600), processStep1: 'y'.repeat(600), introPitch: 'z'.repeat(500) }; return o; };
+    const spring = big(300);
+    await SM.writeCurriculumDoc('lessonData', { 'spring-2026': spring, 'fall-2026': big(230), lastUpdated: 'x' });
+    const { ctx, page } = await openAs(browser, 'manager');
+    const { result } = await runProcedure(page);
+    expect(result.ok, JSON.stringify(result)).toBe(true);
+    expect(result.count).toBe(300);
+    expect(result.lessonDataKB).toBeLessThan(450);
+    expect(stripStamps(await SM.readCurriculumDoc(SM.SPRING_DOC))).toEqual(spring);
+    expect((await SM.readCurriculumDoc('lessonData'))['spring-2026']).toBeUndefined();
+    await ctx.close();
+  });
+});
diff --git a/scripts/spring-2026-move.console.js b/scripts/spring-2026-move.console.js
new file mode 100644
index 0000000..da9a3f6
--- /dev/null
+++ b/scripts/spring-2026-move.console.js
@@ -0,0 +1,165 @@
+// ─── Spring 2026 storage move — Phase C (one-off, run by a manager) ─────────────
+// Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html
+//
+// HOW TO RUN: on https://tinker-classbook.netlify.app, signed in as a manager, open the
+// browser console (⌥⌘J), paste this WHOLE file, press Enter. It never runs on its own
+// from the site — this file isn't deployed (dist/ holds only the app).
+//
+// What it does, in order — stopping with "nothing was changed" at the first problem:
+//   1. Checks you're a manager and reads curriculum/lessonData, lessons_spring-2026 and
+//      storageMigrations fresh from the server: Spring must be in lessonData, its own
+//      document must not exist yet, and there must be no earlier move record.
+//   2. Downloads a JSON backup of Spring's lessons and asks you to confirm.
+//   3. ONE transaction: creates lessons_spring-2026 from the lessons read inside the
+//      transaction, removes spring-2026 from lessonData, and records the move
+//      (lesson count + SHA-256 fingerprint, verified: false). All or nothing.
+//   4. Verifies from fresh server reads: the new document's lessons have the same count
+//      and fingerprint, and lessonData no longer holds Spring. Spring edits are paused by
+//      the rules throughout, so nothing can change in between.
+//   5a. Passed → marks the move verified (Spring becomes editable again) and reports the
+//       new lessonData size.
+//   5b. Failed → one transaction puts Spring back into lessonData and removes the new
+//       document and the record (only allowed while unverified), exactly as before.
+//
+// The Phase A rules (studio-hub 0caf415) allow exactly these writes and nothing else.
+async function springMove(opts = {}) {
+  const K = 'spring-2026';
+  const TARGET = 'lessons_spring-2026';
+  const say = (...a) => console.log('%c[spring-move]', 'color:#6052C8;font-weight:bold', ...a);
+  const stop = (msg) => {
+    console.error('[spring-move] STOPPED:', msg);
+    alert(`Spring 2026 move STOPPED.\n\n${msg}`);
+    return { ok: false, message: msg };
+  };
+
+  const user = getAuthUser();
+  if (!user || !['admin', 'manager'].includes(user.role)) return stop('Sign in as a manager first. Nothing was changed.');
+  if (!curriculumDb) initCurriculumFirestore();
+  const db = curriculumDb;
+  const ref = (id) => db.collection('curriculum').doc(id);
+  const by = user.name || user.email || 'Unknown';
+
+  // A fingerprint independent of key order: sorted keys, Timestamps as seconds/nanos.
+  const canon = (v) => {
+    if (v === null || typeof v !== 'object') return v;
+    if (typeof v.toDate === 'function' && 'seconds' in v) return { __ts: [v.seconds, v.nanoseconds] };
+    if (Array.isArray(v)) return v.map(canon);
+    const out = {};
+    for (const k of Object.keys(v).sort()) out[k] = canon(v[k]);
+    return out;
+  };
+  const sha256 = async (obj) => {
+    const bytes = new TextEncoder().encode(JSON.stringify(canon(obj)));
+    const digest = await crypto.subtle.digest('SHA-256', bytes);
+    return [...new Uint8Array(digest)].map(b => b.toString(16).padStart(2, '0')).join('');
+  };
+  const lessonsOf = (data) => { const m = { ...(data || {}) }; delete m.lastUpdated; delete m.lastUpdatedBy; return m; };
+
+  // 1. Preflight — forced server reads.
+  let ld, tgt, mig;
+  try {
+    [ld, tgt, mig] = await Promise.all([
+      ref('lessonData').get({ source: 'server' }),
+      ref(TARGET).get({ source: 'server' }),
+      ref('storageMigrations').get({ source: 'server' }),
+    ]);
+  } catch (err) {
+    return stop(`Couldn't read the current data from the server (${err.message}). Nothing was changed.`);
+  }
+  const springMap = ld.exists ? ld.data()?.[K] : null;
+  if (!springMap || typeof springMap !== 'object') return stop('Spring 2026 is not in the shared lesson document — it may already have been moved. Nothing was changed.');
+  if (tgt.exists) return stop(`${TARGET} already exists. Nothing was changed.`);
+  if (mig.exists && mig.data()?.[K]) return stop('There is already a Spring 2026 move record. Nothing was changed.');
+  const count = Object.keys(springMap).length;
+  const fingerprint = await sha256(springMap);
+  say(`Spring 2026: ${count} lessons, fingerprint ${fingerprint.slice(0, 12)}…`);
+
+  // 2. Backup download, then confirm.
+  const fileName = `classbook-${K}-lessons-${new Date().toISOString().replace(/[:.]/g, '-')}.json`;
+  const backup = JSON.stringify({ semester: K, takenAt: new Date().toISOString(), takenBy: by, lessonCount: count, sha256: fingerprint, lessons: springMap }, null, 2);
+  const link = document.createElement('a');
+  link.href = URL.createObjectURL(new Blob([backup], { type: 'application/json' }));
+  link.download = fileName;
+  document.body.appendChild(link); link.click(); link.remove();
+  if (!confirm(`A backup of Spring 2026 (${count} lessons) was just downloaded:\n\n${fileName}\n\nCheck it's in your Downloads folder, then press OK to move Spring 2026 into its own storage.\n\nCancel stops here — nothing is changed.`)) {
+    return stop('Cancelled before the move. Nothing was changed.');
+  }
+
+  // 3. The move — one transaction.
+  const movedAt = new Date().toISOString();
+  let moved;
+  try {
+    await db.runTransaction(async (tx) => {
+      const l = await tx.get(ref('lessonData'));
+      const t = await tx.get(ref(TARGET));
+      const m = await tx.get(ref('storageMigrations'));
+      if (t.exists) throw new Error(`${TARGET} appeared`);
+      if (m.exists && m.data()?.[K]) throw new Error('a move record appeared');
+      const inTx = l.exists ? l.data()?.[K] : null;
+      if (!inTx) throw new Error('Spring 2026 is no longer in lessonData');
+      moved = { lessons: inTx, count: Object.keys(inTx).length, sha256: await sha256(inTx) };
+      tx.set(ref(TARGET), { ...inTx, lastUpdated: movedAt, lastUpdatedBy: by });
+      tx.update(ref('lessonData'), { [K]: firebase.firestore.FieldValue.delete() });
+      tx.set(ref('storageMigrations'), { [K]: { movedAt, movedBy: by, lessonCount: moved.count, sha256: moved.sha256, verified: false } }, { merge: true });
+    });
+  } catch (err) {
+    return stop(`The move transaction didn't go through (${err.message}). It's all-or-nothing, so nothing was changed.`);
+  }
+  say('Moved. Verifying from the server…');
+
+  // 4. Verify — fresh server reads.
+  const problems = [];
+  let l2, t2, m2;
+  try {
+    [l2, t2, m2] = await Promise.all([
+      ref('lessonData').get({ source: 'server' }),
+      ref(TARGET).get({ source: 'server' }),
+      ref('storageMigrations').get({ source: 'server' }),
+    ]);
+    const rec = m2.data()?.[K];
+    if (!t2.exists) problems.push('the new document is missing');
+    const targetLessons = lessonsOf(t2.data());
+    if (Object.keys(targetLessons).length !== moved.count) problems.push(`lesson count ${Object.keys(targetLessons).length} ≠ ${moved.count}`);
+    if ((await sha256(targetLessons)) !== moved.sha256) problems.push('fingerprint of the new document differs');
+    if (!rec || rec.sha256 !== moved.sha256 || rec.lessonCount !== moved.count) problems.push('the move record doesn\'t match');
+    if (l2.exists && K in (l2.data() || {})) problems.push('Spring 2026 is still in the shared document');
+    if (opts.simulateVerifyFailure) problems.push('simulated failure (rehearsal)');
+  } catch (err) {
+    problems.push(`couldn't read back from the server (${err.message})`);
+  }
+
+  if (problems.length) {
+    // 5b. Undo — one transaction, allowed by the rules only while unverified.
+    console.error('[spring-move] Verification failed:', problems);
+    try {
+      await db.runTransaction(async (tx) => {
+        const l = await tx.get(ref('lessonData'));
+        const t = await tx.get(ref(TARGET));
+        await tx.get(ref('storageMigrations'));
+        if (!t.exists) throw new Error('the new document is already gone');
+        if (l.exists && K in (l.data() || {})) throw new Error('Spring 2026 is already back in lessonData');

exec
/bin/zsh -lc "sed -n '120,240p' scripts/spring-2026-move.console.js; sed -n '145,260p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseC.diff; rg -n \"Phase C|Decisions Log|decision|backup|transaction|rehears\" /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
    if (!t2.exists) problems.push('the new document is missing');
    const targetLessons = lessonsOf(t2.data());
    if (Object.keys(targetLessons).length !== moved.count) problems.push(`lesson count ${Object.keys(targetLessons).length} ≠ ${moved.count}`);
    if ((await sha256(targetLessons)) !== moved.sha256) problems.push('fingerprint of the new document differs');
    if (!rec || rec.sha256 !== moved.sha256 || rec.lessonCount !== moved.count) problems.push('the move record doesn\'t match');
    if (l2.exists && K in (l2.data() || {})) problems.push('Spring 2026 is still in the shared document');
    if (opts.simulateVerifyFailure) problems.push('simulated failure (rehearsal)');
  } catch (err) {
    problems.push(`couldn't read back from the server (${err.message})`);
  }

  if (problems.length) {
    // 5b. Undo — one transaction, allowed by the rules only while unverified.
    console.error('[spring-move] Verification failed:', problems);
    try {
      await db.runTransaction(async (tx) => {
        const l = await tx.get(ref('lessonData'));
        const t = await tx.get(ref(TARGET));
        await tx.get(ref('storageMigrations'));
        if (!t.exists) throw new Error('the new document is already gone');
        if (l.exists && K in (l.data() || {})) throw new Error('Spring 2026 is already back in lessonData');
        tx.update(ref('lessonData'), { [K]: moved.lessons });
        tx.delete(ref(TARGET));
      });
      await ref('storageMigrations').update({ [K]: firebase.firestore.FieldValue.delete() });
    } catch (err) {
      return stop(`Verification failed (${problems.join('; ')}) AND the automatic undo failed (${err.message}). Don't retry — tell Claude. Spring's lessons are safe in the backup file ${fileName} and in the new document.`);
    }
    return stop(`Verification failed (${problems.join('; ')}), so the move was undone: Spring 2026 is back in the shared document exactly as before. Nothing was lost.`);
  }

  // 5a. Mark verified — Spring becomes editable again.
  try {
    await ref('storageMigrations').update({ [`${K}.verified`]: true, [`${K}.verifiedAt`]: new Date().toISOString(), [`${K}.verifiedBy`]: by });
  } catch (err) {
    return stop(`The move is done and checked, but marking it verified failed (${err.message}). Spring is safe and viewable; its edits stay paused. Tell Claude — this can be retried safely.`);
  }
  const kb = typeof approxFirestoreSize === 'function' ? Math.round(approxFirestoreSize(l2.data() || {}) / 1024) : null;
  const msg = `Spring 2026 moved and verified: ${moved.count} lessons, fingerprint ${moved.sha256.slice(0, 12)}…` + (kb !== null ? `\nShared lesson storage is now about ${kb} KB of 1,024 KB.` : '');
  say(msg);
  alert(`Done ✓\n\n${msg}\n\nSpring 2026 is editable again. Keep the backup file ${fileName}.`);
  return { ok: true, message: msg, count: moved.count, sha256: moved.sha256, lessonDataKB: kb, fileName };
}

// Pasted into the console: run it. (The e2e rehearsal sets __SPRING_MOVE_NO_AUTORUN and calls springMove() itself.)
if (!window.__SPRING_MOVE_NO_AUTORUN) springMove();
+    expect(result.message).toMatch(/Nothing was changed/);
+    expect(download).toBeNull();
+    expect(await snapshotAll()).toEqual(before);
+    await ctx.close();
+  });
+
+  test('refuses for a non-manager (nothing changed)', async ({ browser }) => {
+    const before = await snapshotAll();
+    const { ctx, page } = await openAs(browser, 'staff');
+    const { result } = await runProcedure(page);
+    expect(result.ok).toBe(false);
+    expect(result.message).toMatch(/Sign in as a manager/);
+    expect(await snapshotAll()).toEqual(before);
+    await ctx.close();
+  });
+
+  test('works on a near-full-size document (~550 KB Spring + ~400 KB other semester)', async ({ browser }) => {
+    const big = (n) => { const o = {}; for (let i = 0; i < n; i++) o[`teacher-class-${i}`] = { teacher: `T${i % 7}`, shortDetails: 'x'.repeat(600), processStep1: 'y'.repeat(600), introPitch: 'z'.repeat(500) }; return o; };
+    const spring = big(300);
+    await SM.writeCurriculumDoc('lessonData', { 'spring-2026': spring, 'fall-2026': big(230), lastUpdated: 'x' });
+    const { ctx, page } = await openAs(browser, 'manager');
+    const { result } = await runProcedure(page);
+    expect(result.ok, JSON.stringify(result)).toBe(true);
+    expect(result.count).toBe(300);
+    expect(result.lessonDataKB).toBeLessThan(450);
+    expect(stripStamps(await SM.readCurriculumDoc(SM.SPRING_DOC))).toEqual(spring);
+    expect((await SM.readCurriculumDoc('lessonData'))['spring-2026']).toBeUndefined();
+    await ctx.close();
+  });
+});
diff --git a/scripts/spring-2026-move.console.js b/scripts/spring-2026-move.console.js
new file mode 100644
index 0000000..da9a3f6
--- /dev/null
+++ b/scripts/spring-2026-move.console.js
@@ -0,0 +1,165 @@
+// ─── Spring 2026 storage move — Phase C (one-off, run by a manager) ─────────────
+// Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html
+//
+// HOW TO RUN: on https://tinker-classbook.netlify.app, signed in as a manager, open the
+// browser console (⌥⌘J), paste this WHOLE file, press Enter. It never runs on its own
+// from the site — this file isn't deployed (dist/ holds only the app).
+//
+// What it does, in order — stopping with "nothing was changed" at the first problem:
+//   1. Checks you're a manager and reads curriculum/lessonData, lessons_spring-2026 and
+//      storageMigrations fresh from the server: Spring must be in lessonData, its own
+//      document must not exist yet, and there must be no earlier move record.
+//   2. Downloads a JSON backup of Spring's lessons and asks you to confirm.
+//   3. ONE transaction: creates lessons_spring-2026 from the lessons read inside the
+//      transaction, removes spring-2026 from lessonData, and records the move
+//      (lesson count + SHA-256 fingerprint, verified: false). All or nothing.
+//   4. Verifies from fresh server reads: the new document's lessons have the same count
+//      and fingerprint, and lessonData no longer holds Spring. Spring edits are paused by
+//      the rules throughout, so nothing can change in between.
+//   5a. Passed → marks the move verified (Spring becomes editable again) and reports the
+//       new lessonData size.
+//   5b. Failed → one transaction puts Spring back into lessonData and removes the new
+//       document and the record (only allowed while unverified), exactly as before.
+//
+// The Phase A rules (studio-hub 0caf415) allow exactly these writes and nothing else.
+async function springMove(opts = {}) {
+  const K = 'spring-2026';
+  const TARGET = 'lessons_spring-2026';
+  const say = (...a) => console.log('%c[spring-move]', 'color:#6052C8;font-weight:bold', ...a);
+  const stop = (msg) => {
+    console.error('[spring-move] STOPPED:', msg);
+    alert(`Spring 2026 move STOPPED.\n\n${msg}`);
+    return { ok: false, message: msg };
+  };
+
+  const user = getAuthUser();
+  if (!user || !['admin', 'manager'].includes(user.role)) return stop('Sign in as a manager first. Nothing was changed.');
+  if (!curriculumDb) initCurriculumFirestore();
+  const db = curriculumDb;
+  const ref = (id) => db.collection('curriculum').doc(id);
+  const by = user.name || user.email || 'Unknown';
+
+  // A fingerprint independent of key order: sorted keys, Timestamps as seconds/nanos.
+  const canon = (v) => {
+    if (v === null || typeof v !== 'object') return v;
+    if (typeof v.toDate === 'function' && 'seconds' in v) return { __ts: [v.seconds, v.nanoseconds] };
+    if (Array.isArray(v)) return v.map(canon);
+    const out = {};
+    for (const k of Object.keys(v).sort()) out[k] = canon(v[k]);
+    return out;
+  };
+  const sha256 = async (obj) => {
+    const bytes = new TextEncoder().encode(JSON.stringify(canon(obj)));
+    const digest = await crypto.subtle.digest('SHA-256', bytes);
+    return [...new Uint8Array(digest)].map(b => b.toString(16).padStart(2, '0')).join('');
+  };
+  const lessonsOf = (data) => { const m = { ...(data || {}) }; delete m.lastUpdated; delete m.lastUpdatedBy; return m; };
+
+  // 1. Preflight — forced server reads.
+  let ld, tgt, mig;
+  try {
+    [ld, tgt, mig] = await Promise.all([
+      ref('lessonData').get({ source: 'server' }),
+      ref(TARGET).get({ source: 'server' }),
+      ref('storageMigrations').get({ source: 'server' }),
+    ]);
+  } catch (err) {
+    return stop(`Couldn't read the current data from the server (${err.message}). Nothing was changed.`);
+  }
+  const springMap = ld.exists ? ld.data()?.[K] : null;
+  if (!springMap || typeof springMap !== 'object') return stop('Spring 2026 is not in the shared lesson document — it may already have been moved. Nothing was changed.');
+  if (tgt.exists) return stop(`${TARGET} already exists. Nothing was changed.`);
+  if (mig.exists && mig.data()?.[K]) return stop('There is already a Spring 2026 move record. Nothing was changed.');
+  const count = Object.keys(springMap).length;
+  const fingerprint = await sha256(springMap);
+  say(`Spring 2026: ${count} lessons, fingerprint ${fingerprint.slice(0, 12)}…`);
+
+  // 2. Backup download, then confirm.
+  const fileName = `classbook-${K}-lessons-${new Date().toISOString().replace(/[:.]/g, '-')}.json`;
+  const backup = JSON.stringify({ semester: K, takenAt: new Date().toISOString(), takenBy: by, lessonCount: count, sha256: fingerprint, lessons: springMap }, null, 2);
+  const link = document.createElement('a');
18:  .decision { background: #eff6ff; border-left: 4px solid #2563eb; padding: .6rem 1rem; border-radius: 4px; font-size: .9rem; margin: .5rem 0; }
36:  <strong>Touches:</strong> the Classbook (<code>js/firebase-data.js</code>, <code>js/app.js</code>), <code>studio-hub/firestore.rules</code> + <code>studio-hub/rules.test.js</code> (sha phrase + guard), <code>studio-hub/js/alerts.js</code> (Studio Hub deploy), and <code>tinker-backups/backup.js</code>, <strong>which only Christie edits</strong> (memory: <code>backup-js-uses-cli-token</code>).<br>
41:  <strong>If headroom runs out early:</strong> the move itself is already a single step (Phase C), so the fastest safe route is to do Phases A and B promptly and run Phase C as soon as the 3-day stale-tab cutoff allows. Never remove Spring from <code>lessonData</code> before Phase B's code, which can read the new location, is live. Doing so would make Spring look empty, which is the May 2026 incident on purpose. Phase B adds a headroom readout, so nobody has to remember to paste a snippet.
49:  <tr><td>The 13 in-app <code>doc('lessonData')</code> sites. Reads: <code>:762</code> load, <code>:975</code> <code>readServerSemesterLessonMap</code>, <code>:1171</code> listener, <code>app.js:5835</code> <code>readAdminLessonDoc</code>, <code>app.js:7518</code> <code>computeLiveContentCountByTeacher</code>. Writes: <code>:817</code> <code>saveLessonData</code> (whole-semester merge-set), <code>:830</code> <code>deleteLessonKey</code>, <code>:963</code> <code>deleteLessonData</code>, <code>:1438</code> <code>saveSingleLesson</code>, <code>:1500</code> <code>saveMultipleLessonFields</code>, <code>app.js:3690</code> <code>sendTeacherQaMessage</code>, <code>:7202</code> <code>sendHelpResponse</code>, <code>:7285</code> <code>sendQaReply</code>. Dead code: <code>backupLessonData</code>/<code>restoreFromBackup</code> (<code>:979-1002</code>, no callers).</td><td>as cited</td></tr>
56:      <li><strong><code>tinker-backups/backup.js</code></strong>: it backs up the <code>curriculum</code> collection as Tier 1 (<code>:38, :56</code>; new <code>lessons_*</code> docs are included automatically), and <code>computeClassbookContentByTeacher</code> (<code>:370-389</code>) counts per-teacher content from <code>curriculum/lessonData</code> only, writing <code>backupStatus/latest</code> (<code>:471</code>) with a 10% drop alarm. The Classbook's <code>renderContentCount()</code> (<code>app.js:7578-7600</code>) compares live counts to that baseline.</li>
58:      <li>The <code>summer-camp-app/scripts/backup-firestore.js</code> console script is manual and weekly, not the nightly backup (a round-1 correction).</li>
67:  <li><strong>One-step move (Codex round 1, "simpler safe option"):</strong> Spring's copy and the removal of its old copy happen <em>in one transaction</em>. There's never a multi-day period with two copies, so nothing is double-counted, and the old copy can't be deleted while the new one is missing.</li>
77:  <li>No role can create, add to, or change the <code>spring-2026</code> key, with exactly two manager/admin exceptions. (1) An update that <em>only deletes</em> it, for the Phase C transaction. (2) The <strong>rollback</strong>: an update that <em>only re-adds</em> it, allowed only while <code>storageMigrations.spring-2026.verified != true</code> and only if <code>getAfter(lessons_spring-2026)</code> shows that document deleted in the same transaction (Codex round 2, fix 1).</li>
93:  rollback: manager/admin re-adds only spring-2026 AND deletes lessons_spring-2026 in one transaction, while unverified → allowed
95:  re-add spring-2026 without deleting lessons_spring-2026 in the same transaction → denied
123:  <li><strong>Ratchet:</strong> no <code>doc('lessonData')</code> in the loaded scripts outside the helpers, the legacy load/listener and the dead backup helpers. <code>e2e/</code> is exempt. The seed gains a <code>lessons_spring-2026</code> + <code>storageMigrations</code> fixture set for the own-doc scenarios, and the default seed is unchanged.</li>
148:<h3>Phase C: move Spring in one step (production, one-off, manager) <span class="status-tag ready">execution-ready: true</span></h3>
155:<p><strong>How:</strong> a console procedure that Christie pastes while signed in as manager. The procedure is written into this plan and reviewed before execution, and rehearsed in the emulator by an e2e test that runs the same code.</p>
158:  <li><strong>One transaction:</strong> read <code>lessonData</code>, <code>lessons_spring-2026</code> (which must not exist) and <code>storageMigrations</code>. Then:
160:      <li><code>tx.set(lessons_spring-2026, { ...map, lastUpdated, lastUpdatedBy })</code>, where <code>map</code> is the <code>spring-2026</code> map read <em>inside</em> the transaction</li>
167:  <li><strong>If it fails:</strong> nothing has been edited since the copy, so the reverse transaction is safe: it puts <code>map</code> back into <code>lessonData</code>, which Phase A's rollback allowance permits (a manager/admin, only this key, only while unverified, and only together with deleting <code>lessons_spring-2026</code>), deletes <code>lessons_spring-2026</code>, and records the failure. The download from step 1 remains the last resort.</li>
172:Scenario: verification fails (simulated) → the reverse transaction restores lessonData['spring-2026'] byte-identical and removes the target
174:<div class="note"><strong>The backup script edit (Christie gave permission for this change, Sep 29):</strong> <em>before</em> Phase C, and with Christie's go-ahead confirmed again at that moment, Claude adds the five lines recorded in the Decisions Log to <code>tinker-backups/backup.js</code> (<code>computeClassbookContentByTeacher</code>, just before <code>return counts;</code>). It keeps a <code>.bak</code> copy, checks the syntax with <code>node --check</code>, doesn't run the script, and touches nothing else, above all not the credential code. Because the move is one step, the backup never sees Spring twice.</div>
178:<div class="note">After Phase C, <code>lessonData</code> holds Fall (about 420 KB and growing). <strong>Before Spring 2027 is created</strong> (or before <code>lessonData</code> passes about 70%), a follow-up plan must:
190:  <li><strong>Backups (checked Sep 29):</strong> <code>backup.js</code> fetches <em>every</em> document in each listed collection (<code>fetchCollection</code>, <code>:221-247</code>), so <code>lessons_spring-2026</code> and <code>storageMigrations</code> are in every 30-minute backup automatically. The Tier-1 count check counts documents, and <code>curriculum</code> gains two, so there's no false alarm there. The per-teacher content count is covered by the five-line edit.</li>
191:  <li><strong>Snapshot:</strong> a JSON download right before the move, plus <code>tinker-backups/backup.js</code>'s automatic 30-minute backups of the <code>curriculum</code> collection (Tier 1).</li>
192:  <li><strong>Atomic:</strong> the copy, the old-copy removal and the migration record are one transaction.</li>
194:  <li><strong>Reversible:</strong> a reverse transaction until verified. After that, the download and backups.</li>
203:  <li><strong>Mid-C:</strong> the transaction either committed or didn't. If it committed but isn't verified, Spring is viewable, edits are paused, and the reverse transaction exists.</li>
208:  <li>Read this plan and its Decisions Log. Re-measure lessonData first.</li>
210:  <li>Per phase: commit, run the full suite, then a second-model implementation review. Each deploy, the backup.js edit, and Phase C each need Christie's own yes. Phase A needs the sha phrase.</li>
213:<h2 id="decisions">Decisions Log (append-only)</h2>
214:<div class="decision">
215:  <strong>Sep 30, 2026: the 3-day stale-tab wait is dropped (Christie).</strong> Everyone works in Fall. A pre-Phase-B tab can't lose data, because the Phase A rules refuse its Spring writes, and Fall is untouched by the move. The only effect is that Spring may <em>look</em> empty in such a tab until it's refreshed, which Christie accepts. The move is planned for tonight, Sep 30, after the procedure is written, rehearsed in the emulator and reviewed, and after the backup.js edit. The staff "please refresh" note is optional.
217:<div class="decision">
219:  <strong>Phase C prerequisites:</strong>
223:    <li>The five-line <code>tinker-backups/backup.js</code> edit, with Christie's OK confirmed at the time.</li>
224:    <li>The console procedure is written into this plan, rehearsed by an e2e test in the emulator, and reviewed.</li>
228:<div class="decision">
229:  <strong>Sep 30, 2026: Phase B (Classbook) DEPLOYED.</strong> Christie approved the merge and deploy. PR #5 was merged as <code>132fef2</code> (tree identical to the reviewed <code>9e551c2</code>). Deployed with <code>npm run deploy</code>, message = full sha, <code>check-live</code> ok (every file MATCH). Spring 2026 now shows the standing "editing is paused" notice. <strong>Studio Hub's half of Phase B isn't deployed yet:</strong> Christie chose to first fix Studio Hub publishing its whole repo (the live site serves <code>setup/migration-log.txt</code> with staff names and UIDs, <code>firebase-agent-defense-hardening.md</code>, <code>CLAUDE.md</code>, rules, test scripts). The fix is to publish only the app's files, deployed together with the alerts update. It must be live before Phase C.
231:<div class="decision">
245:<div class="decision">
248:<div class="decision">
249:  <strong>Sep 29, 2026: revision 5, EXECUTION-READY.</strong> Codex round 3 (<code>…-codex-r3.md</code>) confirmed fixes 2 and 3, and confirmed the rules design is implementable (<code>existsAfter</code>, all split statements constrained). Its single remaining item: the Phase A update-condition summary was missing the rollback branch, which is now added with Codex's exact form. All phases are marked execution-ready. Build waits for Christie's go-ahead. Deploys, the backup.js edit and Phase C each still need her own yes, and Phase A needs the sha phrase.
251:<div class="decision">
252:  <strong>Sep 29, 2026: revision 4, after Codex round 2 (<code>…-codex-r2.md</code>).</strong> Codex confirmed 6 of its 8 round-1 items resolved, including that the forward transaction works under the Phase A rules. Three fixes taken:
254:    <li>The rollback re-add is explicitly allowed for manager/admin, only while unverified and only with <code>lessons_spring-2026</code> deleted in the same transaction (<code>getAfter</code>). This replaces the test that contradicted it.</li>
259:<div class="decision">
262:    <li>Adopted Codex's "simpler safe option": the copy and the old-copy removal are <strong>one transaction</strong>, with Spring edits paused by rule until the move is verified. That closes the verification/rollback race (1), the target-missing-at-delete risk (2) and double counting (5), since there's no dual-copy window, and Phases C and D merge.</li>
270:  <strong>Christie (Sep 29):</strong> she can't edit <code>backup.js</code> herself, and gave <strong>permission for Claude to make that one five-line change</strong> (keep a .bak, <code>node --check</code>, don't run it, touch nothing else), to be confirmed again at the time.
272:<div class="decision">
273:  <strong>Sep 29, 2026: Christie's answers.</strong> (Q1) Spring 2026 being view-only from Phase A until Phase C is fine. (Q2) Christie will paste the <code>backup.js</code> change herself (option a) before Phase D. The exact lines, for <code>tinker-backups/backup.js</code> inside <code>computeClassbookContentByTeacher</code>, just before <code>return counts;</code>:
279:  It's generic over <code>lessons_*</code>, so Fall's later move needs no second edit. <code>tally</code> ignores non-lesson values (<code>lastUpdated</code> strings have no <code>.teacher</code>). Also: Christie asked whether Spring stays reachable after the move. Yes: it stays in every semester list and is fully viewable, and it's editable again after Phase C.
281:<div class="decision">
282:  <strong>Sep 29, 2026: revision 2, after review round 1 (Claude; <code>thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md</code>): NOT ready, 11-point minimum list, all taken.</strong> Re-scoped to <strong>Spring only, hard-coded</strong>, with no appData flags, <code>migratedSemesters</code>, UI buttons or "Move back". The copy and the removal are reviewed console procedures. The rules fence uses a literal key (no <code>get(appData)</code>), splits <code>:654</code>, and ships <strong>first</strong>. Fixed: the listener drops own-doc semesters (A); verify races (B, moot now that the fence freezes the source first); Phase D's precondition compares against the hash of what was written (C); vanished keys are loud (D); <code>not-found</code> on first write (E); <code>createNewSemester</code>/<code>deleteSemester</code> deferred to the follow-up plan, with a deadline (F, delete); the missing readers are added (<code>tinker-backups/backup.js</code>, which is Christie's edit, the in-app content count, <code>test-alerts.js</code>, dead backup helpers, e2e exemptions, seed); the backup citation and "nightly" are corrected; the listener generation is decided (no bump); teardown uses an array; a near-1 MB rules fixture is added; there's a headroom readout; and the emergency lever's order is fixed.<br>
283:  <strong>Open questions for Christie:</strong> (Q1) Is it OK that Spring 2026 is read-only ("editing is paused") from Phase A until Phase C, probably a few days? (Q2) Will you make the small <code>backup.js</code> edit before Phase D, or accept one expected content-loss alarm for Spring teachers? (Q3, for the reviewer) Undoing a bad Phase C copy needs a whole-doc delete of <code>lessons_spring-2026</code>; today only classbook-admin/curriculum-admin may whole-doc delete (<code>:675-678</code>). Should Phase A's split give managers delete as well (they have it today through <code>:654</code>'s <code>write</code>)? The plan assumes yes: the split keeps manager delete.
285:<div class="decision">

exec
/bin/zsh -lc "sed -n '140,245p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html; git -C /Users/christiehubley/studio-hub show 0caf415:firestore.rules | sed -n '600,760p'; git show --stat --oneline 05b159b && git status --short" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
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
  <strong>Phase C prerequisites:</strong>
  <ul>
    <li>Phase B has been live for 3 days or more (Classbook since Sep 30, so Oct 3 at the earliest).</li>
    <li>Staff are asked the day before to close and reopen the Classbook.</li>
    <li>The five-line <code>tinker-backups/backup.js</code> edit, with Christie's OK confirmed at the time.</li>
    <li>The console procedure is written into this plan, rehearsed by an e2e test in the emulator, and reviewed.</li>
    <li>Christie's go-ahead, at a quiet time.</li>
  </ul>
</div>
<div class="decision">
  <strong>Sep 30, 2026: Phase B (Classbook) DEPLOYED.</strong> Christie approved the merge and deploy. PR #5 was merged as <code>132fef2</code> (tree identical to the reviewed <code>9e551c2</code>). Deployed with <code>npm run deploy</code>, message = full sha, <code>check-live</code> ok (every file MATCH). Spring 2026 now shows the standing "editing is paused" notice. <strong>Studio Hub's half of Phase B isn't deployed yet:</strong> Christie chose to first fix Studio Hub publishing its whole repo (the live site serves <code>setup/migration-log.txt</code> with staff names and UIDs, <code>firebase-agent-defense-hardening.md</code>, <code>CLAUDE.md</code>, rules, test scripts). The fix is to publish only the app's files, deployed together with the alerts update. It must be live before Phase C.
</div>
<div class="decision">
  <strong>Sep 30, 2026: Phase B built and reviewed; ready to deploy (waiting for Christie).</strong><br>
  <strong>Commits:</strong> Classbook <code>claude/spring-own-doc</code>, <code>d34d170</code> → <code>a7f0d0e</code> → <code>9275732</code> → <code>9e551c2</code>. Studio Hub <code>claude/classbook-alerts-own-doc</code>, <code>bd5fd10</code> → <code>85a488c</code>.<br>
  <strong>Deviation from the plan's shape:</strong> <code>lessonStoreFor()</code> still returns <code>'weekly'</code> for Spring, and every weekly write routes through a new <code>weeklyLessonTarget()</code> (document + dotted-path prefix) instead of a new <code>'ownDoc'</code> store value. That's less invasive, and the reviewers confirmed it's complete.<br>
  <strong>Reviews:</strong>
  <ul>
    <li>Codex round 1 (NOT safe): paused Spring actions half-happened (photo upload, Cut Bank, Settings) and the messages were generic; a recheck race; Studio Hub dismissal and error handling; test gaps.</li>
    <li>Codex round 2 (NOT safe): dismissal lifecycle and degraded sources; notice on the migration-listener error; real-UI tests.</li>
    <li>Claude round 2: no code blockers; a test wrote slots into shared emulator data; manager-gate the storage section.</li>
    <li>Codex round 3: <strong>SAFE TO DEPLOY</strong>.</li>
  </ul>
  <strong>Tests:</strong> Classbook 353 passed (the spec has 18 tests, including the real editors with photos, all Q&amp;A, Plan Complete, the verified-path editor save, a real overlapping move→undo, and ratchets; mutation checks confirm the key tests catch their bugs). Studio Hub: 24 unit + 141 guard pass; the emulator rules suite was blocked by another project's emulator on 8080, and there's no rules change. SDOC G1 is flaky on main (tracked as a separate task).<br>
  <strong>Deploys needed:</strong> the Classbook (Netlify credit) and Studio Hub (Netlify credit), both after merging to main.
</div>
<div class="decision">
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-yVY5cSZT' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-8xdYBxO7' (errno=Operation not permitted)
          (resource.data.createdBy == request.auth.uid
            && (isManagerOrAbove()
                || resource.data.get('sharedWith', []) == request.resource.data.get('sharedWith', [])))
          // Manager/admin — any non-personal meeting, any field.
          || (resource.data.business != 'personal' && isManagerOrAbove())
          // Shared, non-manager user — tick action items and nothing else.
          || (resource.data.business != 'personal'
              // `in` also matches a MAP's keys — require a list so a
              // malformed map-shaped sharedWith cannot grant this branch.
              && resource.data.get('sharedWith', []) is list
              && request.auth.uid in resource.data.get('sharedWith', [])
              && onlyActionItemsChanged())
        );

      allow delete: if (isManagerOrAbove() || hasAppAccess('recap'))
        && (
          resource.data.createdBy == request.auth.uid
          || (resource.data.business != 'personal' && isManagerOrAbove())
        );
    }

    match /recapData/{docId} {
      allow read, write: if isManagerOrAbove() || hasAppAccess('recap');
    }

    match /series/{docId} {
      allow read, write: if isManagerOrAbove() || hasAppAccess('recap');
    }

    match /threads/{docId} {
      allow read, write: if isManagerOrAbove() || hasAppAccess('recap');
    }


    // ═══════════════════════════════════════════════════════════════
    // CLASSBOOK (Curriculum)
    // NO studio restriction — both studios can access.
    //
    // appAccess('classbook-admin'):
    //   Full read/write on all curriculum docs EXCEPT 'appData'.
    //   appData (Settings doc): manager+ only, always.
    //
    // appAccess('classbook'):
    //   Full read/write on all curriculum docs EXCEPT 'appData'.
    //   The app controls what each teacher actually sees/edits
    //   (all lesson data is in a single document — field-level
    //   isolation is enforced by the UI, not by rules).
    //   appData (Settings doc): manager+ only, always.
    //
    // Manager+: full access including appData.
    // ═══════════════════════════════════════════════════════════════

    match /curriculum/{docId} {
      // ── Spring 2026 storage move (Sep 29 2026) ──────────────────────────
      // Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase A).
      // curriculum/lessonData holds every Fall/Spring semester in ONE document and was at 95% of
      // Firestore's 1 MiB cap. Spring 2026 moves to curriculum/lessons_spring-2026 in one manager
      // transaction. Three docs therefore get their own rules below; every other curriculum doc
      // keeps exactly the rules it had (the "ordinary docs" lines).
      //   lessonData          — nobody changes its 'spring-2026' key, except manager+ deleting ONLY
      //                         that key (the move) or re-adding ONLY that key while the move is
      //                         unverified AND the new doc is deleted in the same transaction
      //                         (the rollback). Nobody deletes the whole document.
      //   lessons_spring-2026 — created by manager+; edited only once storageMigrations says the move
      //                         is verified; deleted only by manager+ and only while unverified.
      //   storageMigrations   — manager+ writes; classbook roles read.
      function isClassbookRole() {
        return hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook');
      }
      function isClassbookAdminRole() {
        return hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin');
      }
      function isStorageMoveDoc() {
        return docId in ['lessonData', 'lessons_spring-2026', 'storageMigrations'];
      }
      function springMoveVerified() {
        let path = /databases/$(database)/documents/curriculum/storageMigrations;
        return exists(path) && get(path).data.get('spring-2026', {}).get('verified', false) == true;
      }
      function lessonDataChangedKeys() {
        return request.resource.data.diff(resource.data).affectedKeys();
      }
      function springKeyUntouched() {
        return !lessonDataChangedKeys().hasAny(['spring-2026']);
      }
      function springKeyRemovedOnly() {
        return lessonDataChangedKeys().hasOnly(['spring-2026'])
          && !('spring-2026' in request.resource.data);
      }
      function springKeyRolledBack() {
        return lessonDataChangedKeys().hasOnly(['spring-2026'])
          && ('spring-2026' in request.resource.data)
          && !('spring-2026' in resource.data)
          && exists(/databases/$(database)/documents/curriculum/lessons_spring-2026)
          && !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
          && !springMoveVerified();
      }

      // Manager+: full access to everything including appData (reads; ordinary-doc writes)
      allow read: if isManagerOrAbove();
      allow create, update, delete: if isManagerOrAbove() && !isStorageMoveDoc();

      // classbook-admin, curriculum-admin (legacy key), and classbook: full read/write except appData and prepCycleConfig
      // appData (Settings) is manager+ only, always
      // prepCycleConfig (Prep Cycle workflow config) is classbook-admin only
      // NOTE: 'classbook' (plain teacher) access is intentionally NOT
      // isolated per-teacher here — each semester's lessons live in one
      // shared doc, and per-field isolation is enforced by the UI, not
      // by these rules. This is a known, accepted gap (see
      // firebase-agent-defense-hardening.md) pending a possible future
      // data-model change, not something this rule can close on its own.
      allow read: if isClassbookRole();
      allow create, update: if
        isClassbookRole()
        && docId != 'appData'
        && docId != 'prepCycleConfig'
        && !isStorageMoveDoc();
      // Whole-document delete is classbook-admin/curriculum-admin only.
      // Plain 'classbook' (teacher) access never calls a full-document
      // delete in the app (only FieldValue.delete() on specific lesson
      // fields, which is an update, not a delete) — so this closes an
      // unused, high-blast-radius capability with no functional change.
      allow delete: if
        isClassbookAdminRole()
        && docId != 'appData'
        && docId != 'prepCycleConfig'
        && !isStorageMoveDoc();
      // prepCycleConfig: classbook-admin and curriculum-admin write only
      allow create, update, delete: if
        isClassbookAdminRole()
        && docId == 'prepCycleConfig';

      // lessonData: as before for every semester except 'spring-2026'; no whole-document delete.
      allow create: if docId == 'lessonData'
        && (isManagerOrAbove() || isClassbookRole())
        && !('spring-2026' in request.resource.data);
      allow update: if docId == 'lessonData'
        && (isManagerOrAbove() || isClassbookRole())
        && springKeyUntouched();
      allow update: if docId == 'lessonData'
        && isManagerOrAbove()
        && (springKeyRemovedOnly() || springKeyRolledBack());

      // lessons_spring-2026: Spring 2026's lessons after the move.
      allow create: if docId == 'lessons_spring-2026' && isManagerOrAbove();
      allow update: if docId == 'lessons_spring-2026'
        && (isManagerOrAbove() || isClassbookRole())
        && springMoveVerified();
      allow delete: if docId == 'lessons_spring-2026'
        && isManagerOrAbove()
        && !springMoveVerified();

      // storageMigrations: the move's record (manager+ writes; read via the read lines above).
      // 'verified' is one-way: once true it can never be turned off, removed or replaced (that
      // would reopen delete/rollback). It may become true only when, AFTER the write (existsAfter/getAfter, so it
      // can't be combined with a delete or rollback in one batch), lessons_spring-2026 exists and
      // lessonData no longer holds 'spring-2026'. No role deletes the record.
      function springVerifiedIn(data) {
        return data.get('spring-2026', {}).get('verified', false) == true;
      }
      function springVerifyTransitionOk() {
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-VTyp1YfI' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-gxJdpsHu' (errno=Operation not permitted)
05b159b Spring 2026 storage move, Phase C: the console procedure + its emulator rehearsal
 e2e/spring-move-procedure.spec.js   | 144 +++++++++++++++++++++++++++++++
 scripts/spring-2026-move.console.js | 165 ++++++++++++++++++++++++++++++++++++
 2 files changed, 309 insertions(+)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-uk1nRCkg' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-6MNJmzvc' (errno=Operation not permitted)

exec
/bin/zsh -lc "git -C /Users/christiehubley/studio-hub show 0caf415:firestore.rules | sed -n '760,845p'; nl -ba scripts/spring-2026-move.console.js | sed -n '1,220p'; nl -ba e2e/spring-move-procedure.spec.js | sed -n '1,220p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-5eAHxEtK' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-wDqPf1UX' (errno=Operation not permitted)
      function springVerifyTransitionOk() {
        return !springVerifiedIn(request.resource.data)
          || (existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
              && !('spring-2026' in getAfter(/databases/$(database)/documents/curriculum/lessonData).data));
      }
      allow create: if docId == 'storageMigrations'
        && isManagerOrAbove()
        && springVerifyTransitionOk();
      allow update: if docId == 'storageMigrations'
        && isManagerOrAbove()
        && (springVerifiedIn(resource.data)
              ? springVerifiedIn(request.resource.data)
              : springVerifyTransitionOk());
    }

    // ═══════════════════════════════════════════════════════════════
    // CLASSBOOK — SCHOOL DAY OFF CAMPS (SDOCs)
    // Plan: tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html (Phase 1, §1.1)
    //   dayOffCamps_events / dayOffCamps_camps: the admin's planning list for a school year.
    //     classbook-admin (+ manager+) write, plain classbook teachers read.
    //   dayOffCamps_lessonData: one shared plan per camp-project. Teachers create/update like
    //     summerCamps_lessonData (per-teacher isolation is UI-enforced — the same accepted gap as
    //     summer); whole-document delete is admin-only, like /curriculum's delete clause.
    //   The legacy 'curriculum-admin' key is deliberately NOT extended to these new collections.
    //   Visibility of an unpublished year is UI gating only: every classbook teacher can read these.
    // ═══════════════════════════════════════════════════════════════

    match /dayOffCamps_events/{docId} {
      allow read: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
      allow create, update, delete: if isManagerOrAbove() || hasAppAccess('classbook-admin');
    }

    match /dayOffCamps_camps/{docId} {
      allow read: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
      allow create, update, delete: if isManagerOrAbove() || hasAppAccess('classbook-admin');
    }

    match /dayOffCamps_lessonData/{docId} {
      allow read: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
      allow create, update: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
      allow delete: if isManagerOrAbove() || hasAppAccess('classbook-admin');
    }


    // ═══════════════════════════════════════════════════════════════
    // ROSTER MANAGER — Tinker studio only.
    // Manager+ or appAccess('roster-manager'): full read/write.
    // Delete: manager+ only.
    // Studio isolation applies to all roles.
    // ═══════════════════════════════════════════════════════════════

    match /rosterManager/{docId} {
      allow read, create, update: if
        (isManagerOrAbove() || hasAppAccess('roster-manager'))
        && belongsToStudio('tinker');
      allow delete: if isManagerOrAbove() && belongsToStudio('tinker');
    }

    // CC director: read roster data, read+write sign-in records
    match /rosterManager/appData {
      allow read: if hasAppAccess('coal-creek-signin') && belongsToStudio('tinker');
    }
    match /rosterManager/signIn {
      allow read, write: if hasAppAccess('coal-creek-signin') && belongsToStudio('tinker');
    }


    // ═══════════════════════════════════════════════════════════════
    // SUMMER CAMP APP — Both studios.
    // Most require manager+ or appAccess('summer-camp'); `team` and `seasons` are the exceptions,
    // and several also admit the Classbook's grants where the two apps share data. Each block says so.
    // Same permissions for all granted users — no staff distinction.
    //
    // prepHelpQueue, weeklyPrep, materialsHub, needToOrder, stockItems:
    //   Read + write (create+update). Delete: manager+ only.
    //
    // curriculum, lessonData, projectDetails, projectLibrary, schedule:
    //   Read-only for granted users. Write: manager+ only.
    //
    // settings: manager+ ONLY — no appAccess override, ever.
    //
    // seasons: the season registry — read by anyone who can read ANY summerCamps_* collection,
    //   write manager+ with two integrity guards. The reasons are on the block itself.
    // ═══════════════════════════════════════════════════════════════

    // — THE SEASON REGISTRY —
     1	// ─── Spring 2026 storage move — Phase C (one-off, run by a manager) ─────────────
     2	// Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html
     3	//
     4	// HOW TO RUN: on https://tinker-classbook.netlify.app, signed in as a manager, open the
     5	// browser console (⌥⌘J), paste this WHOLE file, press Enter. It never runs on its own
     6	// from the site — this file isn't deployed (dist/ holds only the app).
     7	//
     8	// What it does, in order — stopping with "nothing was changed" at the first problem:
     9	//   1. Checks you're a manager and reads curriculum/lessonData, lessons_spring-2026 and
    10	//      storageMigrations fresh from the server: Spring must be in lessonData, its own
    11	//      document must not exist yet, and there must be no earlier move record.
    12	//   2. Downloads a JSON backup of Spring's lessons and asks you to confirm.
    13	//   3. ONE transaction: creates lessons_spring-2026 from the lessons read inside the
    14	//      transaction, removes spring-2026 from lessonData, and records the move
    15	//      (lesson count + SHA-256 fingerprint, verified: false). All or nothing.
    16	//   4. Verifies from fresh server reads: the new document's lessons have the same count
    17	//      and fingerprint, and lessonData no longer holds Spring. Spring edits are paused by
    18	//      the rules throughout, so nothing can change in between.
    19	//   5a. Passed → marks the move verified (Spring becomes editable again) and reports the
    20	//       new lessonData size.
    21	//   5b. Failed → one transaction puts Spring back into lessonData and removes the new
    22	//       document and the record (only allowed while unverified), exactly as before.
    23	//
    24	// The Phase A rules (studio-hub 0caf415) allow exactly these writes and nothing else.
    25	async function springMove(opts = {}) {
    26	  const K = 'spring-2026';
    27	  const TARGET = 'lessons_spring-2026';
    28	  const say = (...a) => console.log('%c[spring-move]', 'color:#6052C8;font-weight:bold', ...a);
    29	  const stop = (msg) => {
    30	    console.error('[spring-move] STOPPED:', msg);
    31	    alert(`Spring 2026 move STOPPED.\n\n${msg}`);
    32	    return { ok: false, message: msg };
    33	  };
    34	
    35	  const user = getAuthUser();
    36	  if (!user || !['admin', 'manager'].includes(user.role)) return stop('Sign in as a manager first. Nothing was changed.');
    37	  if (!curriculumDb) initCurriculumFirestore();
    38	  const db = curriculumDb;
    39	  const ref = (id) => db.collection('curriculum').doc(id);
    40	  const by = user.name || user.email || 'Unknown';
    41	
    42	  // A fingerprint independent of key order: sorted keys, Timestamps as seconds/nanos.
    43	  const canon = (v) => {
    44	    if (v === null || typeof v !== 'object') return v;
    45	    if (typeof v.toDate === 'function' && 'seconds' in v) return { __ts: [v.seconds, v.nanoseconds] };
    46	    if (Array.isArray(v)) return v.map(canon);
    47	    const out = {};
    48	    for (const k of Object.keys(v).sort()) out[k] = canon(v[k]);
    49	    return out;
    50	  };
    51	  const sha256 = async (obj) => {
    52	    const bytes = new TextEncoder().encode(JSON.stringify(canon(obj)));
    53	    const digest = await crypto.subtle.digest('SHA-256', bytes);
    54	    return [...new Uint8Array(digest)].map(b => b.toString(16).padStart(2, '0')).join('');
    55	  };
    56	  const lessonsOf = (data) => { const m = { ...(data || {}) }; delete m.lastUpdated; delete m.lastUpdatedBy; return m; };
    57	
    58	  // 1. Preflight — forced server reads.
    59	  let ld, tgt, mig;
    60	  try {
    61	    [ld, tgt, mig] = await Promise.all([
    62	      ref('lessonData').get({ source: 'server' }),
    63	      ref(TARGET).get({ source: 'server' }),
    64	      ref('storageMigrations').get({ source: 'server' }),
    65	    ]);
    66	  } catch (err) {
    67	    return stop(`Couldn't read the current data from the server (${err.message}). Nothing was changed.`);
    68	  }
    69	  const springMap = ld.exists ? ld.data()?.[K] : null;
    70	  if (!springMap || typeof springMap !== 'object') return stop('Spring 2026 is not in the shared lesson document — it may already have been moved. Nothing was changed.');
    71	  if (tgt.exists) return stop(`${TARGET} already exists. Nothing was changed.`);
    72	  if (mig.exists && mig.data()?.[K]) return stop('There is already a Spring 2026 move record. Nothing was changed.');
    73	  const count = Object.keys(springMap).length;
    74	  const fingerprint = await sha256(springMap);
    75	  say(`Spring 2026: ${count} lessons, fingerprint ${fingerprint.slice(0, 12)}…`);
    76	
    77	  // 2. Backup download, then confirm.
    78	  const fileName = `classbook-${K}-lessons-${new Date().toISOString().replace(/[:.]/g, '-')}.json`;
    79	  const backup = JSON.stringify({ semester: K, takenAt: new Date().toISOString(), takenBy: by, lessonCount: count, sha256: fingerprint, lessons: springMap }, null, 2);
    80	  const link = document.createElement('a');
    81	  link.href = URL.createObjectURL(new Blob([backup], { type: 'application/json' }));
    82	  link.download = fileName;
    83	  document.body.appendChild(link); link.click(); link.remove();
    84	  if (!confirm(`A backup of Spring 2026 (${count} lessons) was just downloaded:\n\n${fileName}\n\nCheck it's in your Downloads folder, then press OK to move Spring 2026 into its own storage.\n\nCancel stops here — nothing is changed.`)) {
    85	    return stop('Cancelled before the move. Nothing was changed.');
    86	  }
    87	
    88	  // 3. The move — one transaction.
    89	  const movedAt = new Date().toISOString();
    90	  let moved;
    91	  try {
    92	    await db.runTransaction(async (tx) => {
    93	      const l = await tx.get(ref('lessonData'));
    94	      const t = await tx.get(ref(TARGET));
    95	      const m = await tx.get(ref('storageMigrations'));
    96	      if (t.exists) throw new Error(`${TARGET} appeared`);
    97	      if (m.exists && m.data()?.[K]) throw new Error('a move record appeared');
    98	      const inTx = l.exists ? l.data()?.[K] : null;
    99	      if (!inTx) throw new Error('Spring 2026 is no longer in lessonData');
   100	      moved = { lessons: inTx, count: Object.keys(inTx).length, sha256: await sha256(inTx) };
   101	      tx.set(ref(TARGET), { ...inTx, lastUpdated: movedAt, lastUpdatedBy: by });
   102	      tx.update(ref('lessonData'), { [K]: firebase.firestore.FieldValue.delete() });
   103	      tx.set(ref('storageMigrations'), { [K]: { movedAt, movedBy: by, lessonCount: moved.count, sha256: moved.sha256, verified: false } }, { merge: true });
   104	    });
   105	  } catch (err) {
   106	    return stop(`The move transaction didn't go through (${err.message}). It's all-or-nothing, so nothing was changed.`);
   107	  }
   108	  say('Moved. Verifying from the server…');
   109	
   110	  // 4. Verify — fresh server reads.
   111	  const problems = [];
   112	  let l2, t2, m2;
   113	  try {
   114	    [l2, t2, m2] = await Promise.all([
   115	      ref('lessonData').get({ source: 'server' }),
   116	      ref(TARGET).get({ source: 'server' }),
   117	      ref('storageMigrations').get({ source: 'server' }),
   118	    ]);
   119	    const rec = m2.data()?.[K];
   120	    if (!t2.exists) problems.push('the new document is missing');
   121	    const targetLessons = lessonsOf(t2.data());
   122	    if (Object.keys(targetLessons).length !== moved.count) problems.push(`lesson count ${Object.keys(targetLessons).length} ≠ ${moved.count}`);
   123	    if ((await sha256(targetLessons)) !== moved.sha256) problems.push('fingerprint of the new document differs');
   124	    if (!rec || rec.sha256 !== moved.sha256 || rec.lessonCount !== moved.count) problems.push('the move record doesn\'t match');
   125	    if (l2.exists && K in (l2.data() || {})) problems.push('Spring 2026 is still in the shared document');
   126	    if (opts.simulateVerifyFailure) problems.push('simulated failure (rehearsal)');
   127	  } catch (err) {
   128	    problems.push(`couldn't read back from the server (${err.message})`);
   129	  }
   130	
   131	  if (problems.length) {
   132	    // 5b. Undo — one transaction, allowed by the rules only while unverified.
   133	    console.error('[spring-move] Verification failed:', problems);
   134	    try {
   135	      await db.runTransaction(async (tx) => {
   136	        const l = await tx.get(ref('lessonData'));
   137	        const t = await tx.get(ref(TARGET));
   138	        await tx.get(ref('storageMigrations'));
   139	        if (!t.exists) throw new Error('the new document is already gone');
   140	        if (l.exists && K in (l.data() || {})) throw new Error('Spring 2026 is already back in lessonData');
   141	        tx.update(ref('lessonData'), { [K]: moved.lessons });
   142	        tx.delete(ref(TARGET));
   143	      });
   144	      await ref('storageMigrations').update({ [K]: firebase.firestore.FieldValue.delete() });
   145	    } catch (err) {
   146	      return stop(`Verification failed (${problems.join('; ')}) AND the automatic undo failed (${err.message}). Don't retry — tell Claude. Spring's lessons are safe in the backup file ${fileName} and in the new document.`);
   147	    }
   148	    return stop(`Verification failed (${problems.join('; ')}), so the move was undone: Spring 2026 is back in the shared document exactly as before. Nothing was lost.`);
   149	  }
   150	
   151	  // 5a. Mark verified — Spring becomes editable again.
   152	  try {
   153	    await ref('storageMigrations').update({ [`${K}.verified`]: true, [`${K}.verifiedAt`]: new Date().toISOString(), [`${K}.verifiedBy`]: by });
   154	  } catch (err) {
   155	    return stop(`The move is done and checked, but marking it verified failed (${err.message}). Spring is safe and viewable; its edits stay paused. Tell Claude — this can be retried safely.`);
   156	  }
   157	  const kb = typeof approxFirestoreSize === 'function' ? Math.round(approxFirestoreSize(l2.data() || {}) / 1024) : null;
   158	  const msg = `Spring 2026 moved and verified: ${moved.count} lessons, fingerprint ${moved.sha256.slice(0, 12)}…` + (kb !== null ? `\nShared lesson storage is now about ${kb} KB of 1,024 KB.` : '');
   159	  say(msg);
   160	  alert(`Done ✓\n\n${msg}\n\nSpring 2026 is editable again. Keep the backup file ${fileName}.`);
   161	  return { ok: true, message: msg, count: moved.count, sha256: moved.sha256, lessonDataKB: kb, fileName };
   162	}
   163	
   164	// Pasted into the console: run it. (The e2e rehearsal sets __SPRING_MOVE_NO_AUTORUN and calls springMove() itself.)
   165	if (!window.__SPRING_MOVE_NO_AUTORUN) springMove();
     1	/**
     2	 * Rehearsal of the Phase C console procedure (scripts/spring-2026-move.console.js) —
     3	 * the EXACT file Christie pastes, run in the emulator against the deployed Phase A rules.
     4	 * Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase C).
     5	 *
     6	 * EMULATOR ONLY. Every test starts from and ends at the seeded state (admin helper).
     7	 */
     8	const fs = require('fs');
     9	const path = require('path');
    10	const { test, expect } = require('@playwright/test');
    11	const { login, MANAGER_STATE_PATH } = require('./helpers/login');
    12	const SM = require('./helpers/storage-move');
    13	
    14	const PROCEDURE = fs.readFileSync(path.join(__dirname, '..', 'scripts', 'spring-2026-move.console.js'), 'utf8');
    15	const LESSON = 'fixtureteacher-fixtureclass-1';
    16	
    17	test.describe.configure({ mode: 'serial' });
    18	test.beforeEach(async () => { await SM.resetStorageMove(); });
    19	test.afterEach(async () => { await SM.resetStorageMove(); });
    20	
    21	async function openAs(browser, role) {
    22	  const ctx = role === 'manager' ? await browser.newContext({ storageState: MANAGER_STATE_PATH, acceptDownloads: true }) : await browser.newContext({ acceptDownloads: true });
    23	  const page = await ctx.newPage();
    24	  await login(page, role === 'manager' ? 'manager' : undefined);
    25	  await page.waitForFunction(() => lessonDataLoadedSuccessfully === true && currentLessonData?.['spring-2026'], null, { timeout: 25_000 });
    26	  return { ctx, page };
    27	}
    28	// Loads the procedure without auto-running; dialogs answered by `answerConfirm`.
    29	async function runProcedure(page, { answerConfirm = true, opts = {} } = {}) {
    30	  const dialogs = [];
    31	  page.on('dialog', d => { dialogs.push(`${d.type()}: ${d.message()}`); d.type() === 'confirm' ? (answerConfirm ? d.accept() : d.dismiss()) : d.accept(); });
    32	  await page.addScriptTag({ content: `window.__SPRING_MOVE_NO_AUTORUN = true;\n${PROCEDURE}` });
    33	  const downloadPromise = page.waitForEvent('download', { timeout: 15_000 }).catch(() => null);
    34	  const result = await page.evaluate((o) => springMove(o), opts);
    35	  const download = await downloadPromise;
    36	  return { result, dialogs, download };
    37	}
    38	const snapshotAll = async () => ({
    39	  lessonData: await SM.readCurriculumDoc('lessonData'),
    40	  target: await SM.readCurriculumDoc(SM.SPRING_DOC),
    41	  migrations: await SM.readCurriculumDoc('storageMigrations'),
    42	});
    43	const stripStamps = (d) => { const m = { ...(d || {}) }; delete m.lastUpdated; delete m.lastUpdatedBy; return m; };
    44	
    45	test.describe('Spring 2026 move procedure (Phase C rehearsal)', () => {
    46	
    47	  test('happy path: backup downloaded, one-step move, verified, Spring editable; an open tab follows along', async ({ browser }) => {
    48	    const other = await openAs(browser, 'staff');   // a staff tab open during the move
    49	    await other.page.evaluate(() => { window.__minSpring = Infinity; window.__w = setInterval(() => { const n = Object.keys(currentLessonData?.['spring-2026'] || {}).length; if (n < window.__minSpring) window.__minSpring = n; }, 25); });
    50	    const { ctx, page } = await openAs(browser, 'manager');
    51	
    52	    const { result, dialogs, download } = await runProcedure(page);
    53	    expect(result.ok, JSON.stringify(result)).toBe(true);
    54	    expect(dialogs.some(d => d.startsWith('confirm:') && /backup of Spring 2026 \(3 lessons\)/.test(d))).toBe(true);
    55	    expect(dialogs.some(d => d.startsWith('alert:') && /Done ✓/.test(d))).toBe(true);
    56	
    57	    // The backup file.
    58	    expect(download).not.toBeNull();
    59	    const backup = JSON.parse(fs.readFileSync(await download.path(), 'utf8'));
    60	    expect(backup.lessons).toEqual(SM.springFixture());
    61	    expect(backup.lessonCount).toBe(3);
    62	    expect(backup.sha256).toBe(result.sha256);
    63	
    64	    // Server state.
    65	    const after = await snapshotAll();
    66	    expect(stripStamps(after.target)).toEqual(SM.springFixture());
    67	    expect(after.lessonData['spring-2026']).toBeUndefined();
    68	    expect(after.migrations['spring-2026']).toMatchObject({ verified: true, lessonCount: 3, sha256: result.sha256 });
    69	
    70	    // The manager tab: Spring from its own doc, editable.
    71	    await page.waitForFunction(() => ownDocSource['spring-2026'] === 'ownDoc' && weeklySemesterPausedMessage('spring-2026') === null, null, { timeout: 15_000 });
    72	    // The staff tab that was open during the move: never blank, now on the own doc, and it can save.
    73	    await other.page.waitForFunction(() => ownDocSource['spring-2026'] === 'ownDoc' && weeklySemesterPausedMessage('spring-2026') === null, null, { timeout: 15_000 });
    74	    expect(await other.page.evaluate(() => { clearInterval(window.__w); return window.__minSpring; })).toBe(3);
    75	    const saved = await other.page.evaluate(async (k) => { try { await saveSingleLesson('spring-2026', k, { shortDetails: 'Edited after the move' }); return 'ok'; } catch (e) { return e.message; } }, LESSON);
    76	    expect(saved).toBe('ok');
    77	    expect((await SM.readCurriculumDoc(SM.SPRING_DOC))[LESSON].shortDetails).toBe('Edited after the move');
    78	    await ctx.close(); await other.ctx.close();
    79	  });
    80	
    81	  test('cancel at the confirmation changes nothing', async ({ browser }) => {
    82	    const before = await snapshotAll();
    83	    const { ctx, page } = await openAs(browser, 'manager');
    84	    const { result } = await runProcedure(page, { answerConfirm: false });
    85	    expect(result.ok).toBe(false);
    86	    expect(result.message).toMatch(/Cancelled before the move\. Nothing was changed/);
    87	    expect(await snapshotAll()).toEqual(before);
    88	    await ctx.close();
    89	  });
    90	
    91	  test('a failed verification undoes the move exactly (and a later run then succeeds)', async ({ browser }) => {
    92	    const before = await snapshotAll();
    93	    const { ctx, page } = await openAs(browser, 'manager');
    94	    const { result } = await runProcedure(page, { opts: { simulateVerifyFailure: true } });
    95	    expect(result.ok).toBe(false);
    96	    expect(result.message).toMatch(/move was undone/);
    97	    const after = await snapshotAll();
    98	    expect(after.lessonData['spring-2026']).toEqual(SM.springFixture());
    99	    expect(after.target).toBeNull();
   100	    expect(after.migrations?.['spring-2026']).toBeUndefined();
   101	    expect(stripStamps(after.lessonData)).toEqual(stripStamps(before.lessonData));
   102	
   103	    const again = await page.evaluate(() => springMove());
   104	    expect(again.ok, JSON.stringify(again)).toBe(true);
   105	    expect((await SM.readCurriculumDoc('storageMigrations'))['spring-2026'].verified).toBe(true);
   106	    await ctx.close();
   107	  });
   108	
   109	  test('refuses (nothing changed) when Spring was already moved', async ({ browser }) => {
   110	    await SM.stageMoved({ verified: true });
   111	    const before = await snapshotAll();
   112	    const { ctx, page } = await openAs(browser, 'manager');
   113	    const { result, download } = await runProcedure(page);
   114	    expect(result.ok).toBe(false);
   115	    expect(result.message).toMatch(/Nothing was changed/);
   116	    expect(download).toBeNull();
   117	    expect(await snapshotAll()).toEqual(before);
   118	    await ctx.close();
   119	  });
   120	
   121	  test('refuses for a non-manager (nothing changed)', async ({ browser }) => {
   122	    const before = await snapshotAll();
   123	    const { ctx, page } = await openAs(browser, 'staff');
   124	    const { result } = await runProcedure(page);
   125	    expect(result.ok).toBe(false);
   126	    expect(result.message).toMatch(/Sign in as a manager/);
   127	    expect(await snapshotAll()).toEqual(before);
   128	    await ctx.close();
   129	  });
   130	
   131	  test('works on a near-full-size document (~550 KB Spring + ~400 KB other semester)', async ({ browser }) => {
   132	    const big = (n) => { const o = {}; for (let i = 0; i < n; i++) o[`teacher-class-${i}`] = { teacher: `T${i % 7}`, shortDetails: 'x'.repeat(600), processStep1: 'y'.repeat(600), introPitch: 'z'.repeat(500) }; return o; };
   133	    const spring = big(300);
   134	    await SM.writeCurriculumDoc('lessonData', { 'spring-2026': spring, 'fall-2026': big(230), lastUpdated: 'x' });
   135	    const { ctx, page } = await openAs(browser, 'manager');
   136	    const { result } = await runProcedure(page);
   137	    expect(result.ok, JSON.stringify(result)).toBe(true);
   138	    expect(result.count).toBe(300);
   139	    expect(result.lessonDataKB).toBeLessThan(450);
   140	    expect(stripStamps(await SM.readCurriculumDoc(SM.SPRING_DOC))).toEqual(spring);
   141	    expect((await SM.readCurriculumDoc('lessonData'))['spring-2026']).toBeUndefined();
   142	    await ctx.close();
   143	  });
   144	});

codex
The forward move’s core shape is good: Firestore will retry on concurrent Fall writes, and each retry re-reads the latest shared document, so it does not overwrite Fall. I’ve found a separate rollback atomicity problem and am now checking whether the live rules permit fixing it inside the rollback transaction, plus whether the fingerprint/backup cover every Firestore value type claimed.
exec
/bin/zsh -lc "rg -n \"firebase.*(js|version)|firebase-app|firebase-firestore\" index.html dist/index.html js e2e package.json | head -80; git show 132fef2:js/firebase-data.js | rg -n \"OWN_DOC|ownDoc|storageMigration|setup.*Listener|lessons_spring|legacy|moved|weeklyLessonTarget|lessonDataLoadedSuccessfully\"; git show 132fef2:js/firebase-data.js | sed -n '1,180p'; git show 132fef2:js/firebase-data.js | sed -n '1030,1280p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
e2e/static-checks.spec.js:56:    expect(where[0]).toMatch(/^js\/firebase-data\.js:/);
e2e/static-checks.spec.js:58:    const line = fs.readFileSync(path.join(REPO, 'js/firebase-data.js'), 'utf8').split('\n')[hits[0].line - 1];
js/auth-guard.js:5:// Requires: firebase-config.js loaded first, Firebase SDK in HTML.
e2e/data-safety.spec.js:172:// firebase-data.js — reachable by bare name, not via window.
e2e/data-safety.spec.js:289:    // currentLessonData and lessonDataLoadedSuccessfully are `let` variables in firebase-data.js.
e2e/data-safety.spec.js:2683:      // own body in js/firebase-data.js), the same real-Storage-404 pattern
index.html:580:  <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-app-compat.js"></script>
index.html:581:  <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-auth-compat.js"></script>
index.html:582:  <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-firestore-compat.js"></script>
index.html:583:  <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-storage-compat.js"></script>
index.html:585:  <script src="js/firebase-config.js"></script>
index.html:587:  <script src="js/firebase-data.js"></script>
js/firebase-data.js:1770:  // Single init path: initFirebaseApp() (js/firebase-config.js) is the one
e2e/linkify-xss.spec.js:302:      'js/firebase-data.js: e.target.result',   // FileReader → canvas resize of a picked file (never stored)
js/app.js:5902:// lessonHasContent() now lives in firebase-data.js (CONTENT_FIELDS is the
js/app.js:11921:  // firebase-data.js, a client wall-clock heuristic (ties, missing values —
dist/index.html:580:  <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-app-compat.js"></script>
dist/index.html:581:  <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-auth-compat.js"></script>
dist/index.html:582:  <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-firestore-compat.js"></script>
dist/index.html:583:  <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-storage-compat.js"></script>
dist/index.html:585:  <script src="js/firebase-config.js"></script>
dist/index.html:587:  <script src="js/firebase-data.js"></script>
e2e/README.md:33:1. `e2e/emulators/run.js` writes an emulator-only `firebase.json` into the
e2e/README.md:48:   `js/firebase-config.js` sees that flag and initialises the demo project
e2e/README.md:107:  .emulators/              (gitignored) generated firebase.json + emulator logs
e2e/helpers/firestore.js:7: * `firebase emulators:exec`, see e2e/emulators/run.js) and refuses to do
e2e/helpers/firestore.js:182:// state. Mirrors js/firebase-data.js's saveSingleLesson() whole-object-replace
e2e/helpers/firestore.js:198:// per-field-path technique as js/firebase-data.js's deleteLessonKey().
e2e/helpers/firestore.js:225:// Deletes the entire test lesson key — mirrors js/firebase-data.js's
e2e/helpers/firestore.js:244:// Mirrors js/firebase-data.js's deleteLessonData(). This is a whole-semester
e2e/emulators/inner.js:2: * Runs INSIDE `firebase emulators:exec` (or under run.js --attach), with the
e2e/emulators/test-server.js:11: * js/firebase-config.js, so initFirebaseApp() connects to the emulators on
e2e/emulators/run.js:7: * Default: writes an emulator-only firebase.json into e2e/.emulators/ (rules
e2e/emulators/run.js:36:  const file = path.join(RUN_DIR, 'firebase.json');
e2e/emulators/config.js:58:// Gitignored working dir: generated firebase.json + emulator debug logs.
e2e/emulators/config.js:117:/** Env to export when attaching to emulators started with our firebase.json. */
e2e/emulators/config.js:127:/** The firebase.json the runner hands to the CLI (emulators only, rules by absolute path). */
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-PhwWQuvP' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-2sL5Pz7p' (errno=Operation not permitted)
8://   curriculum/cutProjects — projects removed from schedule, saved for reuse
15:let ownDocUnsubscribes = [];   // own-doc semester + storageMigrations listeners (Spring 2026 storage move)
82:// curriculum/storageMigrations says the move is verified.
85:const OWN_DOC_SEMESTERS = ['spring-2026'];
86:const OWN_DOC_PAUSED_MESSAGE = 'Spring 2026 is being moved to new storage — editing it is paused for a few days. Viewing works as normal.';
88:function isOwnDocSemester(semKey) { return OWN_DOC_SEMESTERS.includes(semKey); }
89:function ownDocIdFor(semKey) { return `lessons_${semKey}`; }
92:// 'legacy' (still inside lessonData), 'ownDoc' (its own document), or 'error'
94:const ownDocSource = {};
95:// curriculum/storageMigrations as last read ({} when absent; null = not yet known).
96:let storageMigrationState = null;
97:// The last legacy lessonData snapshot, so a rollback (own doc disappears) can fall
101:function ownDocMoveVerified(semKey) {
102:  return storageMigrationState?.[semKey]?.verified === true;
104:function ownDocLessonMap(data) {
113://   legacy semester → curriculum/lessonData, '<semKey>.'
117:function weeklyLessonTarget(semKey) {
122:  if (ownDocSource[semKey] !== 'ownDoc' || !ownDocMoveVerified(semKey)) {
123:    throw new Error(OWN_DOC_PAUSED_MESSAGE);
125:  return { ref: curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)), prefix: '' };
134:    const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get(getOpts);
135:    if (own.exists) return ownDocLessonMap(own.data());
137:  const legacy = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
138:  return legacy.exists ? (legacy.data()?.[semKey] ?? null) : null;
167:  return (ownDocSource[semKey] === 'ownDoc' && ownDocMoveVerified(semKey)) ? null : OWN_DOC_PAUSED_MESSAGE;
192:// Bumped on every own-doc or legacy snapshot for a semester, so an in-flight
194:const ownDocTransitionToken = {};
195:function bumpOwnDocToken(semKey) { ownDocTransitionToken[semKey] = (ownDocTransitionToken[semKey] || 0) + 1; return ownDocTransitionToken[semKey]; }
213:// every existing ID unchanged; any other season prefixes the ENTIRE legacy ID
214:// with the reserved token `season-{year}|||`, applied after the legacy ID is
217:// ambiguous against a legacy ID whose first segment happens to be a year.
221:function summerDocId(legacyId, season) {
222:  return season === LEGACY_SEASON ? legacyId : `season-${season}|||${legacyId}`;
224:// (semKey, legacy key) → the document ID in that semester's season. Every
227:function summerDocIdFor(semKey, legacyKey) {
228:  return summerDocId(encodeFirestoreKey(legacyKey), seasonForSemester(semKey));
233:  return m ? { season: m[1], legacyId: docId.slice(m[0].length) }
234:           : { season: LEGACY_SEASON, legacyId: docId };
265:let lessonDataLoadedSuccessfully = null; // null = not yet loaded, true = ok, false = failed
301://                                   lessonDataLoadedSuccessfully = false makes
314:    lessonDataLoadedSuccessfully = false;
430://   legacy   : _current absent → the Summer Camp App has not switched on yet;
441:const SEASON_REGISTRY_MODES = ['filtered', 'legacy', 'error', 'unknown'];
453:  if (!snap || !snap.exists) return 'legacy';
476:  // lessonDataLoadedSuccessfully = true and re-hide the banner this mode just
482:    lessonDataLoadedSuccessfully = false;
566:// follows the Summer Camp App switching on (legacy → filtered) and so an
582:    if (previous === 'filtered' && next === 'legacy') next = 'error';
589:    // Without this a tab whose rule was removed mid-session would sit on
607:// here because the registry may not exist yet when this runs (legacy mode),
658:function setupConfigListener(callback) {
734:function setupPrepDataListener(callback) {
870:// In legacy mode the 2026 season reads unfiltered (it is the only season that
883:      if (seasonRegistryMode === 'legacy') {
890:// One camp season's lessons, or an empty map when legacy mode cannot serve it.
897:// loadLessonData, after the legacy document). A failed read of the record is
904:    const m = await curriculumDb.collection('curriculum').doc('storageMigrations').get();
905:    storageMigrationState = m.exists ? (m.data() || {}) : {};
907:    console.warn('⚠️ Could not read curriculum/storageMigrations — own-doc semesters stay read-only:', err);
908:    storageMigrationState = {};
910:  for (const semKey of OWN_DOC_SEMESTERS) {
912:      const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get();
914:        ownDocSource[semKey] = 'ownDoc';
915:        currentLessonData[semKey] = ownDocLessonMap(own.data());
917:        ownDocSource[semKey] = 'legacy';
920:      console.error(`❌ Could not read curriculum/${ownDocIdFor(semKey)}:`, err);
921:      ownDocSource[semKey] = 'error';
927:// The legacy snapshot no longer holds an own-doc semester this tab was showing
933:    const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get({ source: 'server' });
936:    if (ownDocTransitionToken[semKey] !== token || ownDocSource[semKey] === 'ownDoc') return;
938:      ownDocSource[semKey] = 'ownDoc';
939:      currentLessonData[semKey] = ownDocLessonMap(own.data());
945:    console.warn(`⚠️ Could not check curriculum/${ownDocIdFor(semKey)}:`, err);
947:  if (ownDocTransitionToken[semKey] !== token) return;
948:  showStorageNotice(`⚠️ ${semKey} moved to new storage — please reload the page to see its latest lessons.`);
973:      lessonDataLoadedSuccessfully = true;
978:      lessonDataLoadedSuccessfully = false;
983:    lessonDataLoadedSuccessfully = false;
997:  if (lessonDataLoadedSuccessfully === false) {
1014:    const { ref } = weeklyLessonTarget(semesterKey);   // throws "editing is paused" until verified
1030:  const { ref, prefix } = weeklyLessonTarget(semesterKey);
1083:  if (seasonRegistryMode !== 'legacy') query = query.where('season', '==', seasonForSemester(semKey));
1096:  if (lessonDataLoadedSuccessfully === false) {
1126:  if (lessonDataLoadedSuccessfully === false) {
1268:      // else that was sitting on it (e.g. legacy Q&A mirror fields another
1286:// generation counter is module-scoped across every setupLessonDataListener()
1305:// Set by setupLessonDataListener() so a season-registry mode change (legacy →
1315:function setupLessonDataListener(callback) {
1321:  while (ownDocUnsubscribes.length) { try { ownDocUnsubscribes.pop()(); } catch (e) { /* already gone */ } }
1348:      lessonDataLoadedSuccessfully = true;
1354:      lessonDataLoadedSuccessfully = false;
1392:      // document once moved, so carry them across the swap like the camp seasons —
1395:      for (const semKey of OWN_DOC_SEMESTERS) if (currentLessonData?.[semKey]) previousOwn[semKey] = currentLessonData[semKey];
1399:      for (const semKey of OWN_DOC_SEMESTERS) {
1401:        if (ownDocSource[semKey] === 'ownDoc' || ownDocSource[semKey] === 'error') {
1421:  // lessonDataLoadedSuccessfully — an error here is shown on its own and makes
1423:  ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc('storageMigrations')
1426:      storageMigrationState = snap.exists ? (snap.data() || {}) : {};
1428:    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; updateOwnDocPausedNotice(); }));
1429:  for (const semKey of OWN_DOC_SEMESTERS) {
1430:    ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey))
1435:          ownDocSource[semKey] = 'ownDoc';
1437:          currentLessonData[semKey] = ownDocLessonMap(snap.data());
1439:        } else if (ownDocSource[semKey] === 'ownDoc') {
1441:          ownDocSource[semKey] = 'legacy';
1442:          const legacyMap = lastLegacyLessonData?.[semKey];
1443:          if (legacyMap) currentLessonData[semKey] = legacyMap;
1446:          if (ownDocSource[semKey] !== 'error') ownDocSource[semKey] = 'legacy';
1452:        console.error(`❌ ${ownDocIdFor(semKey)} listener error:`, err);
1453:        ownDocSource[semKey] = 'error';
1585:// distinction setupLessonDataListener already makes for snapshots, above).
1612:// removed rather than silently omitted — most commonly content fields
1627:  if (lessonDataLoadedSuccessfully === false) {
1696:  const { ref: weeklyRef, prefix } = weeklyLessonTarget(semesterKey);   // own-doc semester: its own doc (or "editing is paused")
1739:  if (lessonDataLoadedSuccessfully === false) {
1751:  const { ref: weeklyRef, prefix } = weeklyLessonTarget(semesterKey);
1818:  if (lessonDataLoadedSuccessfully === false) {
1841:  if (lessonDataLoadedSuccessfully === false) {
1897:// season: a 4-digit string, or null for the legacy unfiltered read — which is
1898:// allowed ONLY for 2026 while the registry says legacy, because in that state
1906:  if (season === null && seasonRegistryMode !== 'legacy') {
1907:    throw new Error('An unfiltered summer read is only allowed while the season registry says legacy.');
1915:  // Every successful summer load sets lessonDataLoadedSuccessfully = true and
2091:        const lessonKey = decodeFirestoreKey(parsed.legacyId);
2229:// Ticks that still point at an item (a tick on a removed item never counts).
2250:  if (lessonDataLoadedSuccessfully === false) {
2549:// array or map is written whole so a removed day key cannot linger.
2608:  // Dates cannot be removed from under a camp. Judged against the SERVER's
2612:  if (!serverEvent) throw new DayOffValidationError(['This event was removed in another tab — reload before editing it.']);
2700:  const moved = new Set(pairs.map(p => p.from));
2703:    const leaving = [...dayOffCampTitles(originalForDiff).keys()].filter(t => !after.has(t) && !moved.has(t));
2714:  const movedData = {};
2722:    if (!campSnap.exists) throw new DayOffValidationError(['This camp was removed in another tab — reload before editing it.']);
2745:        movedData[m.to] = data;
2759:    if (movedData[m.to]) planMap[dayOffLessonKey(yearKey, original.id, m.to)] = movedData[m.to];
2819:      throw new DayOffValidationError(['This camp was changed in another tab — reload and try again. Nothing was removed.']);
2823:      throw new DayOffValidationError([`It has projects with a plan or materials list: ${[...new Set(withData)].join(', ')}. Nothing was removed.`]);
2900:const DAY_OFF_RENAMED_MESSAGE = 'This project was renamed or removed by the planner — copy your text, close, and reopen the camp.';
2967:    if (err instanceof DayOffValidationError && /no longer a project|was removed in another tab/.test(err.message)) {
3134:  if (!campSnap.exists) throw new DayOffValidationError(['This camp was removed in another tab — reload.']);
3154:  else delete map[dayOffLessonKey(yearKey, campId, title)];   // moved or removed elsewhere
3176:    if (itemId && !existing[itemId]) throw new DayOffValidationError(['That material was removed in another tab — reload the list.']);
3245:// moved or deleted record). Refused if the item no longer exists.
3257:      throw new DayOffValidationError(['That material was removed or moved — reload the list.']);
3289:// server's counts differ (another planner added/removed items, someone
3296:  if (!campNow.exists) throw new DayOffValidationError(['This camp was removed in another tab — reload.']);
3306:    if (!campSnap.exists) throw new DayOffValidationError(['This camp was removed in another tab — reload.']);
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-tHtCADKW' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-3NRmspLK' (errno=Operation not permitted)
// =====================================================
// Curriculum Manager — Firestore Data Layer
// =====================================================
// Document pattern:
//   curriculum/appData     — semester config (URLs, GIDs, settings)
//   curriculum/prepData    — prep team data by semester/week
//   curriculum/lessonData  — all lesson content by semester (imported from classbooks)
//   curriculum/cutProjects — projects removed from schedule, saved for reuse
//   curriculum/changeLog   — audit trail of moves/swaps/cuts

let curriculumDb = null;
let configUnsubscribe = null;
let prepDataUnsubscribe = null;
let lessonDataUnsubscribe = null;
let ownDocUnsubscribes = [];   // own-doc semester + storageMigrations listeners (Spring 2026 storage move)

// The content fields a lesson's stripping/hasContent/wipe-detection logic
// treats as "real plan content" (as opposed to metadata like teacher/weekNum).
// Single source of truth — previously duplicated across four call sites.
const CONTENT_FIELDS = ['introPitch', 'processStep1', 'processStep2', 'processStep3', 'processStep4', 'closure', 'dayOfMaterials'];
function lessonHasContent(lesson) {
  return !!lesson && CONTENT_FIELDS.some(f => lesson[f] && String(lesson[f]).trim());
}

// Firestore doc IDs cannot contain '/'. Encode lesson keys for storage.
function encodeFirestoreKey(key) { return key.replace(/\//g, '__SLASH__'); }
function decodeFirestoreKey(key) { return key.replace(/__SLASH__/g, '/'); }

// ─── Semester types (camp seasons Phase 1, 1.1) ──────────────────────────────
// Every semester stores its kind explicitly. Nothing in the app may infer a
// kind from a key: "does this key start with summer-?" was how a weekly
// semester named "Summer Enrichment" could be routed into the summer
// collections (R5-3), and how Summer 2026 was the only camp season that could
// ever exist.
const SEMESTER_TYPES = { weekly: 'weekly', camp: 'summer-camp', dayOff: 'day-off-camps' };

// The stored type, or 'weekly' when absent — with ONE quarantined exception:
// an absent type on the literal key `summer-2026` is a camp season. That
// covers two real windows: the minutes between this deploy and Christie
// pressing "Stamp semester types", and a stale pre-Phase-1 tab whose
// whole-document saveConfig() could strip the field. It is the only place
// that literal may appear — a static test fails the build on any other
// functional occurrence. In practice it almost never fires: the May 2026
// auto-add already stored semesterType on the server's summer-2026.
const LEGACY_CAMP_SEMESTER_KEY = 'summer-2026';
function semesterTypeOf(semKey) {
  const stored = currentConfig?.semesters?.[semKey]?.semesterType;
  if (stored) return stored;
  if (semKey === LEGACY_CAMP_SEMESTER_KEY) return SEMESTER_TYPES.camp;
  return SEMESTER_TYPES.weekly;
}
// Read the type only through these — never re-derive it from a key.
function isCampSeason(semKey) { return semesterTypeOf(semKey) === SEMESTER_TYPES.camp; }
function isWeeklySemester(semKey) { return semesterTypeOf(semKey) === SEMESTER_TYPES.weekly; }

// Which lesson store a semester's lessons live in: 'camp' (one document per
// lesson in summerCamps_lessonData) or 'weekly' (one nested map inside the
// shared curriculum/lessonData document). The seven sites that choose between
// those two stores — the four lesson writers, the two admin reply writers and
// the existence check — all route through this, so a THIRD type is refused
// rather than treated as weekly: the reply writers' weekly branch update()s
// dotted `{semKey}.{key}.qaThread` paths, which for an SDOC key would quietly
// create a nested map inside the shared weekly document (camp seasons
// Phase 1, 1.1; cross-plan with classbook-school-day-off-camps).
function lessonStoreFor(semKey) {
  const type = semesterTypeOf(semKey);
  switch (type) {
    case SEMESTER_TYPES.camp:   return 'camp';
    case SEMESTER_TYPES.weekly: return 'weekly';
    default:
      throw new Error(`Semester "${semKey}" is a "${type}" semester — this app has no lesson store for that type yet, so it refuses to read or write its lessons.`);
  }
}

// ─── Own-document weekly semesters (Spring 2026 storage move, Sep 2026) ──────
// curriculum/lessonData holds every weekly semester in ONE Firestore document,
// and it reached 95% of the 1 MiB document cap (Sep 29 2026). A finished weekly
// semester moves to its own document, curriculum/lessons_<semKey>, in one manager
// transaction. Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html
// (Phase B). The studio-hub rules (Phase A, deployed 0caf415) fence the key in
// lessonData, and allow edits to the new document only once
// curriculum/storageMigrations says the move is verified.
//
// Changed only by a code deploy, just as the rules fence changes only by a rules deploy.
const OWN_DOC_SEMESTERS = ['spring-2026'];
const OWN_DOC_PAUSED_MESSAGE = 'Spring 2026 is being moved to new storage — editing it is paused for a few days. Viewing works as normal.';

function isOwnDocSemester(semKey) { return OWN_DOC_SEMESTERS.includes(semKey); }
function ownDocIdFor(semKey) { return `lessons_${semKey}`; }

// Where each own-doc semester's lessons are served from right now:
// 'legacy' (still inside lessonData), 'ownDoc' (its own document), or 'error'
// (its document couldn't be read — shown from whatever we have, never writable).
const ownDocSource = {};
// curriculum/storageMigrations as last read ({} when absent; null = not yet known).
let storageMigrationState = null;
// The last legacy lessonData snapshot, so a rollback (own doc disappears) can fall
// back to it, and the headroom readout can size it without another read.
let lastLegacyLessonData = null;

function ownDocMoveVerified(semKey) {
  return storageMigrationState?.[semKey]?.verified === true;
}
function ownDocLessonMap(data) {
  const map = { ...(data || {}) };
  delete map.lastUpdated;
  delete map.lastUpdatedBy;
  return map;
}

// The ONE place a weekly lesson write learns where to go. Returns the document
// and the dotted-path prefix for a lesson inside it:
//   legacy semester → curriculum/lessonData, '<semKey>.'
//   own-doc semester → curriculum/lessons_<semKey>, '' — only once the move is
//                      verified; before that it throws the "editing is paused" message
//                      (the rules refuse those writes anyway).
function weeklyLessonTarget(semKey) {
  if (!curriculumDb) initCurriculumFirestore();
  if (!isOwnDocSemester(semKey)) {
    return { ref: curriculumDb.collection('curriculum').doc('lessonData'), prefix: `${semKey}.` };
  }
  if (ownDocSource[semKey] !== 'ownDoc' || !ownDocMoveVerified(semKey)) {
    throw new Error(OWN_DOC_PAUSED_MESSAGE);
  }
  return { ref: curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)), prefix: '' };
}

// Forced-server (or cache-permitting) read of one weekly semester's lesson map,
// wherever it lives. An own-doc semester is read from its own document when that
// exists, otherwise from lessonData — independent of this tab's in-memory state.
async function readWeeklySemesterMap(semKey, getOpts) {
  if (!curriculumDb) initCurriculumFirestore();
  if (isOwnDocSemester(semKey)) {
    const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get(getOpts);
    if (own.exists) return ownDocLessonMap(own.data());
  }
  const legacy = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
  return legacy.exists ? (legacy.data()?.[semKey] ?? null) : null;
}

// Approximate Firestore size of a value in bytes — the documented storage-size
// rules (string = UTF-8 bytes + 1, number 8, boolean 1, null 1, map = sum of
// key + value). Used for the headroom readout; the SDK doesn't expose the real size.
function approxFirestoreSize(v) {
  const str = (x) => new TextEncoder().encode(x).length + 1;
  if (v === null || v === undefined) return 1;
  if (typeof v === 'string') return str(v);
  if (typeof v === 'number') return 8;
  if (typeof v === 'boolean') return 1;
  if (v && typeof v.toDate === 'function') return 8;
  if (Array.isArray(v)) return v.reduce((t, x) => t + approxFirestoreSize(x), 0);
  if (typeof v === 'object') return Object.entries(v).reduce((t, [k, x]) => t + str(k) + approxFirestoreSize(x), 0);
  return 8;
}
function approxLessonDataSizeKB() {
  if (!lastLegacyLessonData) return null;
  const docName = 'projects/tinker-hq-apps/databases/(default)/documents/curriculum/lessonData';
  return Math.round((approxFirestoreSize(lastLegacyLessonData) + new TextEncoder().encode(docName).length + 1 + 32) / 1024);
}

// Whether a weekly semester's lessons can be written right now. Every workflow
// that writes lessons calls refuseIfWeeklySemesterPaused() BEFORE its first
// change of any kind (photo upload, cut bank, config, optimistic UI), so a paused
// Spring action changes nothing at all instead of half-happening.
function weeklySemesterPausedMessage(semKey) {
  if (!isOwnDocSemester(semKey)) return null;
  return (ownDocSource[semKey] === 'ownDoc' && ownDocMoveVerified(semKey)) ? null : OWN_DOC_PAUSED_MESSAGE;
}
function refuseIfWeeklySemesterPaused(semKey) {
  const message = weeklySemesterPausedMessage(semKey);
  if (!message) return false;
  alert(message);
  return true;
}
// A standing notice while the selected semester is paused, so nobody discovers
// it by losing a save. Called on load, on semester change and on every state change.
function updateOwnDocPausedNotice() {
  const semKey = typeof globalSemesterKey !== 'undefined' ? globalSemesterKey : null;
  const el = document.getElementById('own-doc-paused-notice');
  const message = semKey ? weeklySemesterPausedMessage(semKey) : null;
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-Kb5znbsa' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-gqjWE0v5' (errno=Operation not permitted)
  const { ref, prefix } = weeklyLessonTarget(semesterKey);
  await ref.update({
    [`${prefix}${lessonKey}`]: firebase.firestore.FieldValue.delete(),
    lastUpdated: new Date().toISOString(),
    lastUpdatedBy: user?.name || 'Unknown'
  });
}

async function saveSummerCampLessonData(semKey, lessons) {
  if (!curriculumDb) initCurriculumFirestore();
  // Resolved once, before any batch work — a semester with no valid season
  // throws here, so nothing is queued.
  const season = seasonForSemester(semKey);
  const user = getAuthUser();
  const batch = curriculumDb.batch();

  console.log('💾 Saving Summer Camp lesson data...', { semKey, season });

  const hasContent = lessonHasContent;

  let writeCount = 0;
  // Save each lesson as a separate document (lessonKey as doc ID)
  for (const [lessonKey, lessonData] of Object.entries(lessons)) {
    // Never overwrite existing docs with empty content — protects against stale in-memory state
    if (!hasContent(lessonData)) continue;
    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
    // Strip empty content fields so stale in-memory empty strings never overwrite
    // real content that a teacher saved in a different browser session.
    const stripped = { ...lessonData };
    CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
    // JSON round-trip strips undefined values that Firestore rejects with invalid-argument
    const cleanData = JSON.parse(JSON.stringify({
      ...stripped,
      season,
      lastUpdated: new Date().toISOString(),
      lastUpdatedBy: user?.name || 'Unknown'
    }));
    batch.set(docRef, cleanData, { merge: true });
    writeCount++;
  }

  await batch.commit();
  console.log(`✅ Saved ${writeCount} Summer Camp lesson slots (skipped ${Object.keys(lessons).length - writeCount} empty)`);
}

// Season-scoped, and it no longer swallows its errors (Phase 1, 1.4): a
// failure used to return {} — every camp-complete checkbox unchecked — and the
// next click would write campComplete: false over a true. The caller renders
// an error state instead. Two equality filters need no composite index.
async function loadCampCompleteData(semKey, teacher) {
  if (!curriculumDb) initCurriculumFirestore();
  const result = {};
  let query = curriculumDb.collection('summerCamps_campComplete').where('teacher', '==', teacher);
  if (seasonRegistryMode !== 'legacy') query = query.where('season', '==', seasonForSemester(semKey));
  const snapshot = await query.get();
  snapshot.forEach(doc => {
    const data = doc.data();
    result[data.campName] = data.campComplete || false;
  });
  return result;
}

// Same load guard as the lesson writers (saveLessonData/saveSingleLesson):
// after a failed load the camp view was drawn from nothing, so its checkbox
// state is not something to write back.
async function saveCampComplete(semKey, teacher, campName, campComplete) {
  if (lessonDataLoadedSuccessfully === false) {
    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  }
  if (!curriculumDb) initCurriculumFirestore();
  const season = seasonForSemester(semKey);
  // Merge, not replace: the doc keeps whatever else it carries — today
  // nothing, after the Summer Camp App's backfill its `season` stamp (which
  // this write re-asserts). A full set() here would have erased the stamp on
  // the first toggle after the backfill.
  await curriculumDb.collection('summerCamps_campComplete').doc(summerDocIdFor(semKey, `${teacher}|||${campName}`)).set({
    teacher,
    campName,
    campComplete,
    season,
    updatedAt: new Date().toISOString()
  }, { merge: true });
}

async function getSummerLessonQaThread(semKey, lessonKey) {
  if (!curriculumDb) initCurriculumFirestore();
  const doc = await curriculumDb.collection('summerCamps_prepHelpQueue').doc(summerDocIdFor(semKey, lessonKey)).get();
  if (!doc.exists) return [];
  return doc.data().qaThread || [];
}

// semKey is the MODAL's semester (captured when it opened), not the header
// selector's — that can move while the modal is open. Only the create path
// stamps `season`; a later message never re-stamps or moves a doc between
// seasons (the Summer Camp App's Season.patch() rule).
async function sendSummerLessonQaMessage(semKey, lessonKey, lesson, newMsg) {
  if (lessonDataLoadedSuccessfully === false) {
    throw new Error('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  }
  if (!curriculumDb) initCurriculumFirestore();
  // Resolved before the read so an invalid semester is refused before anything is touched.
  const season = seasonForSemester(semKey);
  const docRef = curriculumDb.collection('summerCamps_prepHelpQueue').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
  const docSnap = await docRef.get();
  const isAdmin = newMsg.from === 'admin';

  if (!docSnap.exists) {
    await docRef.set({
      queueType: 'teachers',
      campTopic: lesson.campName,
      project: lesson.projectTitle,
      projectTitle: lesson.projectTitle,
      block: lesson.block,
      teacher: lesson.teacher,
      lessonKey,
      season,
      askedBy: newMsg.name,
      question: newMsg.message,
      qaThread: [newMsg],
      status: 'Open',
      createdAt: firebase.firestore.FieldValue.serverTimestamp(),
      lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
    });
  } else {
    await docRef.update({
      qaThread: firebase.firestore.FieldValue.arrayUnion(newMsg),
      status: isAdmin ? 'Resolved' : 'Open',
      lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
    });
  }
}

async function deleteLessonData(semesterKey) {
  if (!curriculumDb) initCurriculumFirestore();
  // An own-doc semester's lessons aren't in lessonData (and the rules fence the
  // key); deleting it is disabled until the follow-up plan routes it.
  if (isOwnDocSemester(semesterKey)) throw new Error(`"${semesterKey}" can't be deleted while its storage is being changed.`);
  await curriculumDb.collection('curriculum').doc('lessonData').update({
    [semesterKey]: firebase.firestore.FieldValue.delete()
  });
}

// Forced-server read of one semester's whole lesson map in curriculum/lessonData
// (null when absent). Bypasses both the in-memory model and the SDK cache —
// used where the local cache is known to be untrustworthy for this key, e.g.
// createNewSemester()'s pre-check (deleteSemester() drops a key locally even
// when its server-side delete failed). Backtracking audit, Phase 11.
async function readServerSemesterLessonMap(semesterKey) {
  if (!curriculumDb) initCurriculumFirestore();
  return await readWeeklySemesterMap(semesterKey, { source: 'server' });
}

async function backupLessonData(semesterKey) {
  if (!curriculumDb) initCurriculumFirestore();
  const existing = currentLessonData?.[semesterKey];
  if (!existing || Object.keys(existing).length === 0) return 0;
  const count = Object.keys(existing).length;
  const user = getAuthUser();
  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
    [semesterKey]: existing,
    backupDate: new Date().toISOString(),
    backupBy: user?.name || 'Unknown'
  }, { merge: true });
  return count;
}

async function restoreFromBackup(semesterKey) {
  if (!curriculumDb) initCurriculumFirestore();
  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
  if (!backupDoc.exists) return null;
  const backupData = backupDoc.data();
  const lessons = backupData?.[semesterKey];
  if (!lessons || Object.keys(lessons).length === 0) return null;
  await saveLessonData(semesterKey, lessons);
  return Object.keys(lessons).length;
}

// "Which copy of a lesson is newer", by lastEditedAt — the only revision
// marker the data has (a client wall-clock heuristic: ties and missing values
// resolve to "not newer"). Shared by the listener merge below and the summer
// editor's own adoption/re-install logic (Backtracking audit Phase 10).
function lessonEditedAtMs(lesson) {
  return Date.parse(lesson?.lastEditedAt || '') || 0;
}

// The fields a saved summerCamps_lessonData doc contributes to a lesson slot
// (everything else on the slot — teacher, camp, materials, sharedWith, class
// size… — is rebuilt from the other collections on every reload and must
// always come from the fresh read).
const SUMMER_SAVED_FIELDS = [...CONTENT_FIELDS, 'photoUrl', 'photoPath', 'planComplete', 'lastEditedBy', 'lastEditedAt'];
// A reload's read can only plausibly predate a save this recent; a stamp
// older than this — or further than this into the future — is a skewed clock
// or a doc deleted/restored underneath us, and the fresh read wins.
const SUMMER_KEEP_MINE_WINDOW_MS = 10 * 60 * 1000;
// When the merge keeps an in-memory copy, the server copy it displaced is
// parked here so the summer editor can fall back to it if the in-flight save
// that made the in-memory copy "newer" then fails (see openLessonModal()).
// Keyed by SEMESTER and lesson (Phase 1, 1.4): two camp seasons legitimately
// share a lesson key — same teacher, camp, block and project in 2026 and
// 2027 — and a single-keyed map would park one season's server copy under
// the other's, then hand it back to the wrong editor.
const displacedSummerServerCopies = new Map();
const displacedKey = (semKey, lessonKey) => `${semKey}|${lessonKey}`;

// Backtracking audit Phase 7, handed over by Phase 10: a reload's collection
// read can predate a save that has since landed (or is in flight,
// optimistically installed). The fresh read is authoritative for WHICH
// lessons exist and for every scaffold-derived field; for the saved-doc
// fields, keep the in-memory copy when it is strictly newer — recently — than
// the freshly read one. The in-memory OBJECT is kept (updated in place), so
// the editor's identity checks on its optimistic entry still hold.
// protectedKeys (SDOC, Phase 2B): lessons whose fresh copy is a VERIFIED save
// newer than this reload's query — taken whole, never overridden by the
// clock-based keepMine below and never parked (a faster clock on an older
// in-memory copy must not put old text back). Defaults to the set
// loadDayOffCampData() attached to its result; summer results carry none.
function mergeSummerReload(semKey, previous, fresh, protectedKeys = fresh?.[DAY_OFF_PROTECTED] || null) {
  // A lesson the fresh scaffold no longer has is gone — nothing parked for it
  // may be resurrected by an editor fallback later. Only THIS semester's
  // parked copies are considered: pruning globally would evict the other
  // season's on every reload.
  const prefix = `${semKey}|`;
  for (const key of displacedSummerServerCopies.keys()) {
    if (!key.startsWith(prefix)) continue;
    if (!(key.slice(prefix.length) in fresh)) displacedSummerServerCopies.delete(key);
  }
  if (!previous) return fresh;
  const now = Date.now();
  for (const key of Object.keys(fresh)) {
    if (protectedKeys?.has(key)) { displacedSummerServerCopies.delete(displacedKey(semKey, key)); continue; }
    const mine = previous[key];
    const mineAt = lessonEditedAtMs(mine);
    const keepMine = mine && mineAt > lessonEditedAtMs(fresh[key]) && Math.abs(now - mineAt) < SUMMER_KEEP_MINE_WINDOW_MS;
    if (keepMine) {
      const saved = {};
      SUMMER_SAVED_FIELDS.forEach(f => { if (f in mine) saved[f] = mine[f]; });
      displacedSummerServerCopies.set(displacedKey(semKey, key), fresh[key]);
      // `mine` becomes exactly "fresh scaffold + my saved fields" — anything
      // else that was sitting on it (e.g. legacy Q&A mirror fields another
      // path installed) goes, so the object never carries stale extras.
      for (const f of Object.keys(mine)) { if (!(f in fresh[key]) && !(f in saved)) delete mine[f]; }
      Object.assign(mine, fresh[key], saved);
      fresh[key] = mine;
    } else {
      displacedSummerServerCopies.delete(displacedKey(semKey, key));
    }
  }
  return fresh;
}

// Backtracking audit Phase 7 (R2-10, R3-7, R4-10): every snapshot of the

exec
/bin/zsh -lc "git show 132fef2:js/firebase-data.js | nl -ba | sed -n '1280,1475p'; git show 132fef2:js/firebase-data.js | nl -ba | sed -n '885,960p'; git show 132fef2:js/app.js | rg -n \"computeLiveContentCount|readAdminLessonDoc|OWN_DOC|ownDoc|weeklySemesterPaused|deleteSemester|sendTeacherQa|sendHelpResponse|sendQaReply\"" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-WOwoUJsY' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-nGrpXEym' (errno=Operation not permitted)
  1280	// Backtracking audit Phase 7 (R2-10, R3-7, R4-10): every snapshot of the
  1281	// shared curriculum/lessonData doc re-runs the summer collection reload.
  1282	// Its outcome now drives the load-guard and the banner like the initial
  1283	// load does — a failure trips them, a later success resets them — and only
  1284	// the LATEST reload's outcome may do so: callbacks resolve out of order, and
  1285	// unsubscribing a listener does not cancel its in-flight callback, so the
  1286	// generation counter is module-scoped across every setupLessonDataListener()
  1287	// call (and bumped by the call itself, so an old listener's in-flight reload
  1288	// is stale from the moment it is replaced). A tripped guard blocks every
  1289	// writer in the app, so a failed reload is retried a bounded number of times
  1290	// on its own — a wifi blip self-heals, a real outage keeps the banner.
  1291	// Handed over by Phase 10: the summer cache is kept in place for the ~1.5 s
  1292	// the reload takes (it used to vanish, so the summer view rendered nothing
  1293	// and an in-flight save's optimistic entry had no map to live in), and the
  1294	// reload is merged per lesson keeping the newer copy (mergeSummerReload).
  1295	const SUMMER_RELOAD_RETRY_DELAYS_MS = [5000, 15000];
  1296	// The camp seasons currently in memory, by semester key.
  1297	function snapshotCampSeasons() {
  1298	  const out = {};
  1299	  for (const semKey of Object.keys(currentLessonData || {})) {
  1300	    if ((isCampSeason(semKey) || isDayOffYear(semKey)) && currentLessonData[semKey]) out[semKey] = currentLessonData[semKey];
  1301	  }
  1302	  return out;
  1303	}
  1304	
  1305	// Set by setupLessonDataListener() so a season-registry mode change (legacy →
  1306	// filtered, or unknown healing) re-runs the summer load through that
  1307	// listener's own generation-gated path — never a second, competing one
  1308	// (Phase 1, 1.3).
  1309	let summerReloadHook = null;
  1310	async function reloadSummerForModeChange() {
  1311	  if (typeof summerReloadHook !== 'function') return 'no-listener';
  1312	  return await summerReloadHook();
  1313	}
  1314	
  1315	function setupLessonDataListener(callback) {
  1316	  console.log('📚 Setting up lesson data listener...');
  1317	  if (!curriculumDb) initCurriculumFirestore();
  1318	  globalListenerGeneration++; // whatever the previous listener still has in flight is now stale
  1319	  if (lessonDataUnsubscribe) lessonDataUnsubscribe();
  1320	  // The own-doc listeners (Spring 2026 storage move) are torn down together.
  1321	  while (ownDocUnsubscribes.length) { try { ownDocUnsubscribes.pop()(); } catch (e) { /* already gone */ } }
  1322	
  1323	  // One reload attempt for one snapshot generation. Only the latest
  1324	  // generation may touch the guard, the banner, or the summer cache.
  1325	  // Resolves 'ok' | 'failed' | 'stale'. Only 'stale' means this generation's
  1326	  // outcome was discarded (a newer snapshot took over while it ran).
  1327	  const reloadSummer = async (myGeneration, previousSummer, attempt) => {
  1328	    const isCurrent = () => myGeneration === globalListenerGeneration;
  1329	    try {
  1330	      console.log('📚 Attempting to load camp season data...' + (attempt ? ` (retry ${attempt})` : ''));
  1331	      const plans = campSeasonLoadPlan();
  1332	      const fresh = {};
  1333	      for (const plan of plans) fresh[plan.semKey] = await loadOneCampSeason(plan, { isCurrent });
  1334	      const dayOffKeys = dayOffYearKeys();
  1335	      for (const yearKey of dayOffKeys) fresh[yearKey] = await loadDayOffCampData({ yearKey, isCurrent });
  1336	      if (!isCurrent()) { console.log('📚 Camp season reload superseded by a newer snapshot — ignoring its result'); return 'stale'; }
  1337	      for (const yearKey of dayOffKeys) {
  1338	        currentLessonData[yearKey] = mergeSummerReload(yearKey, previousSummer?.[yearKey], fresh[yearKey]);
  1339	        healDayOffYearAfterReload(yearKey, fresh[yearKey]);
  1340	      }
  1341	      for (const plan of plans) {
  1342	        // Each season merges against ITS OWN previous map — mergeSummerReload
  1343	        // prunes parked copies that are absent from `fresh`, so merging one
  1344	        // season against another's would evict the other's on every reload.
  1345	        currentLessonData[plan.semKey] = mergeSummerReload(plan.semKey, previousSummer?.[plan.semKey], fresh[plan.semKey]);
  1346	      }
  1347	      console.log('📚 Camp seasons loaded:', plans.map(p => `${p.semKey}=${Object.keys(fresh[p.semKey]).length}`).join(' '));
  1348	      lessonDataLoadedSuccessfully = true;
  1349	      document.getElementById('lesson-load-error-banner')?.classList.add('hidden');
  1350	      return 'ok';
  1351	    } catch (err) {
  1352	      console.error('❌ Could not load camp season / day-off camp data:', err);
  1353	      if (!isCurrent()) return 'stale';
  1354	      lessonDataLoadedSuccessfully = false;
  1355	      document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
  1356	      const delay = SUMMER_RELOAD_RETRY_DELAYS_MS[attempt];
  1357	      if (delay !== undefined) {
  1358	        setTimeout(() => {
  1359	          if (!isCurrent()) return; // a newer snapshot has taken over
  1360	          reloadSummer(myGeneration, snapshotCampSeasons(), attempt + 1).then(outcome => { if (outcome === 'ok' && callback) callback(currentLessonData); });
  1361	        }, delay);
  1362	      }
  1363	      return 'failed';
  1364	    }
  1365	  };
  1366	
  1367	  // The registry-change entry point: same reload, same generation gate, and it
  1368	  // renders through the same callback when it is still the current generation.
  1369	  summerReloadHook = async () => {
  1370	    const myGeneration = ++globalListenerGeneration;
  1371	    const outcome = await reloadSummer(myGeneration, snapshotCampSeasons(), 0);
  1372	    if (outcome !== 'stale' && callback) callback(currentLessonData);
  1373	    return outcome;
  1374	  };
  1375	
  1376	  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
  1377	    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
  1378	      // Skip cache-only updates
  1379	      if (doc.metadata.fromCache && !doc.metadata.hasPendingWrites) {
  1380	        console.log('📚 Skipping cache-only snapshot, waiting for server data...');
  1381	        return;
  1382	      }
  1383	      console.log('📚 Lesson data snapshot received, from cache:', doc.metadata.fromCache, 'exists:', doc.exists);
  1384	      if (!doc.exists) return;
  1385	
  1386	      const myGeneration = ++globalListenerGeneration;
  1387	      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
  1388	      // in their own collection, so carry their current maps across the swap
  1389	      // and let the reload below refresh each one (Phase 1, 1.4).
  1390	      const previousSummer = snapshotCampSeasons();
  1391	      // Own-doc semesters (Spring 2026 storage move): their lessons aren't in this
  1392	      // document once moved, so carry them across the swap like the camp seasons —
  1393	      // their own listeners below keep them current.
  1394	      const previousOwn = {};
  1395	      for (const semKey of OWN_DOC_SEMESTERS) if (currentLessonData?.[semKey]) previousOwn[semKey] = currentLessonData[semKey];
  1396	      currentLessonData = doc.data();
  1397	      lastLegacyLessonData = doc.data();
  1398	      for (const [semKey, map] of Object.entries(previousSummer)) currentLessonData[semKey] = map;
  1399	      for (const semKey of OWN_DOC_SEMESTERS) {
  1400	        const token = bumpOwnDocToken(semKey);
  1401	        if (ownDocSource[semKey] === 'ownDoc' || ownDocSource[semKey] === 'error') {
  1402	          if (previousOwn[semKey]) currentLessonData[semKey] = previousOwn[semKey];
  1403	        } else if (!(semKey in currentLessonData) && previousOwn[semKey]) {
  1404	          currentLessonData[semKey] = previousOwn[semKey];   // never blank it
  1405	          recheckOwnDocAfterLegacyLoss(semKey, callback, token);
  1406	        } else if (semKey in currentLessonData) {
  1407	          document.getElementById('storage-notice-banner')?.classList.add('hidden');
  1408	        }
  1409	      }
  1410	      console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
  1411	
  1412	      const outcome = await reloadSummer(myGeneration, previousSummer, 0);
  1413	      // A superseded reload renders nothing — the newer snapshot's own
  1414	      // callback already did (or will), with the same live object. A failed
  1415	      // one still renders: the non-summer semesters in this snapshot are new.
  1416	      if (outcome !== 'stale' && callback) callback(currentLessonData);
  1417	    });
  1418	
  1419	  // Own-doc semesters: one listener per document, plus the migration record.
  1420	  // They never bump globalListenerGeneration and never touch
  1421	  // lessonDataLoadedSuccessfully — an error here is shown on its own and makes
  1422	  // only that semester unwritable.
  1423	  ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc('storageMigrations')
  1424	    .onSnapshot(snap => {
  1425	      if (snap.metadata.fromCache && !snap.metadata.hasPendingWrites) return;
  1426	      storageMigrationState = snap.exists ? (snap.data() || {}) : {};
  1427	      updateOwnDocPausedNotice();
  1428	    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; updateOwnDocPausedNotice(); }));
  1429	  for (const semKey of OWN_DOC_SEMESTERS) {
  1430	    ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey))
  1431	      .onSnapshot({ includeMetadataChanges: false }, snap => {
  1432	        if (snap.metadata.fromCache && !snap.metadata.hasPendingWrites) return;
  1433	        bumpOwnDocToken(semKey);
  1434	        if (snap.exists) {
  1435	          ownDocSource[semKey] = 'ownDoc';
  1436	          currentLessonData = currentLessonData || {};
  1437	          currentLessonData[semKey] = ownDocLessonMap(snap.data());
  1438	          document.getElementById('storage-notice-banner')?.classList.add('hidden');
  1439	        } else if (ownDocSource[semKey] === 'ownDoc') {
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
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-Rk0ZMF73' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-Jg9OpdIY' (errno=Operation not permitted)
   885	      }
   886	      return { semKey, season };
   887	    });
   888	}
   889	
   890	// One camp season's lessons, or an empty map when legacy mode cannot serve it.
   891	async function loadOneCampSeason(plan, opts = {}) {
   892	  if (plan.unavailable) { currentSummerSessionsBySemester[plan.semKey] = []; return {}; }
   893	  return await loadSummerCampData({ ...opts, season: plan.season, semKey: plan.semKey });
   894	}
   895	
   896	// Initial load for own-doc semesters and the migration record (called by
   897	// loadLessonData, after the legacy document). A failed read of the record is
   898	// treated as "not verified" (edits stay paused); a failed read of a semester's own
   899	// document marks it 'error' — shown from whatever lessonData still holds, never
   900	// writable, with a visible notice.
   901	async function loadOwnDocSemesters() {
   902	  if (!curriculumDb) initCurriculumFirestore();
   903	  try {
   904	    const m = await curriculumDb.collection('curriculum').doc('storageMigrations').get();
   905	    storageMigrationState = m.exists ? (m.data() || {}) : {};
   906	  } catch (err) {
   907	    console.warn('⚠️ Could not read curriculum/storageMigrations — own-doc semesters stay read-only:', err);
   908	    storageMigrationState = {};
   909	  }
   910	  for (const semKey of OWN_DOC_SEMESTERS) {
   911	    try {
   912	      const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get();
   913	      if (own.exists) {
   914	        ownDocSource[semKey] = 'ownDoc';
   915	        currentLessonData[semKey] = ownDocLessonMap(own.data());
   916	      } else {
   917	        ownDocSource[semKey] = 'legacy';
   918	      }
   919	    } catch (err) {
   920	      console.error(`❌ Could not read curriculum/${ownDocIdFor(semKey)}:`, err);
   921	      ownDocSource[semKey] = 'error';
   922	      showStorageNotice(`⚠️ ${semKey} lessons couldn't be loaded from their new storage — please reload the page.`);
   923	    }
   924	  }
   925	}
   926	
   927	// The legacy snapshot no longer holds an own-doc semester this tab was showing
   928	// from lessonData: the move just happened (or the page is stale). Never blank it —
   929	// keep the lessons on screen, look for its own document, and if that isn't there
   930	// either, say so.
   931	async function recheckOwnDocAfterLegacyLoss(semKey, callback, token) {
   932	  try {
   933	    const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get({ source: 'server' });
   934	    // A later snapshot (the own-doc listener, or a rollback) has spoken since this
   935	    // read began — its state is newer than this answer, so drop it.
   936	    if (ownDocTransitionToken[semKey] !== token || ownDocSource[semKey] === 'ownDoc') return;
   937	    if (own.exists) {
   938	      ownDocSource[semKey] = 'ownDoc';
   939	      currentLessonData[semKey] = ownDocLessonMap(own.data());
   940	      updateOwnDocPausedNotice();
   941	      if (callback) callback(currentLessonData);
   942	      return;
   943	    }
   944	  } catch (err) {
   945	    console.warn(`⚠️ Could not check curriculum/${ownDocIdFor(semKey)}:`, err);
   946	  }
   947	  if (ownDocTransitionToken[semKey] !== token) return;
   948	  showStorageNotice(`⚠️ ${semKey} moved to new storage — please reload the page to see its latest lessons.`);
   949	}
   950	
   951	async function loadLessonData() {
   952	  if (!curriculumDb) initCurriculumFirestore();
   953	  try {
   954	    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
   955	    currentLessonData = doc.exists ? doc.data() : {};
   956	    lastLegacyLessonData = doc.exists ? doc.data() : {};
   957	    await loadOwnDocSemesters();
   958	
   959	    // Every camp season gets its own map (Phase 1, 1.4) — no literal key.
   960	    try {
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-YHLGxNkL' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-Dj5Dui3U' (errno=Operation not permitted)
2897:        if (err?.message === OWN_DOC_PAUSED_MESSAGE) alert(OWN_DOC_PAUSED_MESSAGE);
3325:  document.getElementById('te-qa-send-btn').addEventListener('click', () => sendTeacherQaMessage(lessonKey, semKey));
3329:      sendTeacherQaMessage(lessonKey, semKey);
3663:    if (err?.message === OWN_DOC_PAUSED_MESSAGE) alert(OWN_DOC_PAUSED_MESSAGE);
3673:// same atomic-append design sendHelpResponse()/sendQaReply() already use —
3678:async function sendTeacherQaMessage(lessonKey, modalSemKey) {
3712:  // accepted check-to-write residual as sendHelpResponse()/sendQaReply().
3942:// sendTeacherQaMessage()).
4592:      ${!isActive ? `<button class="btn-text ca-delete-sem-btn" onclick="deleteSemester(${escForOnclick(currentKey)})" title="Delete this semester">&#128465; Delete</button>` : ''}
4597:async function deleteSemester(key) {
4979:      // before this call. It can: deleteSemester() drops a key from local
5850:    alert(err?.message === OWN_DOC_PAUSED_MESSAGE ? OWN_DOC_PAUSED_MESSAGE : 'This edit could not be saved. Please try again.');
5910:async function readAdminLessonDoc(semKey, lessonKey, opts = {}) {
5918:// sendHelpResponse()/sendQaReply() (not yet implemented) — forced server
5932:    const data = await readAdminLessonDoc(semKey, key, { source: 'server' });
7175:        <button class="btn-primary ca-help-send-btn" onclick="sendHelpResponse(${escForOnclick(key)})">Respond</button>
7202:// Shared by sendHelpResponse() and sendQaReply() below — seeds arrayUnion's
7223:async function sendHelpResponse(key) {
7312:async function sendQaReply(key) {
7595:async function computeLiveContentCountByTeacher() {
7619:  for (const semKey of OWN_DOC_SEMESTERS) {
7620:    const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get();
7623:    for (const lesson of Object.values(ownDocLessonMap(own.data()))) if (lesson && typeof lesson === 'object') tally(lesson);
7689:    const liveCounts = await computeLiveContentCountByTeacher();
7719:    + `<p class="ca-empty-hint">All Fall/Spring semesters still stored in the shared document. ${OWN_DOC_SEMESTERS.map(k => `${escHtml(k)}: ${ownDocSource[k] === 'ownDoc' ? 'in its own document' : ownDocSource[k] === 'error' ? 'couldn\'t be checked' : 'still in the shared document'}`).join(' · ')}</p>`;
8599:    <button class="btn-primary qa-reply-btn" onclick="sendQaReply(${escForOnclick(key)})">Send</button>

exec
/bin/zsh -lc "git show 132fef2:js/app.js | nl -ba | sed -n '3650,3745p'; git show 132fef2:js/app.js | nl -ba | sed -n '7180,7365p'; rg -n \"serverTimestamp|Timestamp|GeoPoint|Blob|Bytes|DocumentReference|arrayUnion\" js/app.js js/firebase-data.js | head -120; sed -n '1,340p' e2e/helpers/storage-move.js" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-GfXuTC5r' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-AL8Eqixr' (errno=Operation not permitted)
  3650	      dayOfMaterials: snapshot.dayOfMaterials,
  3651	      materialsList: JSON.stringify(snapshot.materialsList || []),
  3652	      planComplete: snapshot.planComplete ? 'true' : 'false'
  3653	    };
  3654	
  3655	    setTimeout(() => {
  3656	      if (saveBtn) { saveBtn.textContent = 'Save'; saveBtn.disabled = false; }
  3657	      if (autoSaveStatus) autoSaveStatus.textContent = '';
  3658	    }, 1500);
  3659	  } catch (err) {
  3660	    console.error('Error saving lesson:', err);
  3661	    if (saveBtn) { saveBtn.disabled = false; saveBtn.textContent = 'Save'; }
  3662	    if (autoSaveStatus) { autoSaveStatus.textContent = '⚠️ Save failed'; autoSaveStatus.style.color = 'var(--error)'; }
  3663	    if (err?.message === OWN_DOC_PAUSED_MESSAGE) alert(OWN_DOC_PAUSED_MESSAGE);
  3664	  }
  3665	}
  3666	
  3667	// Backtracking audit Phase 10 (R3-3, R4-5): this used to rebuild the whole
  3668	// Q&A thread from the modal's lesson object and hand the ENTIRE lesson to
  3669	// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
  3670	// silently dropped any message (or any other field) another client had
  3671	// landed since this modal opened. Now a single targeted .update() touching
  3672	// only this lesson's own Q&A paths, with arrayUnion() for the thread — the
  3673	// same atomic-append design sendHelpResponse()/sendQaReply() already use —
  3674	// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
  3675	// record. `modalSemKey` is the semester the modal was opened under: the
  3676	// global selector can change while the modal stays open, and a dotted-path
  3677	// update under the wrong semester would create a Q&A-only ghost lesson there.
  3678	async function sendTeacherQaMessage(lessonKey, modalSemKey) {
  3679	  const input = document.getElementById('te-qa-input');
  3680	  if (!input) return;
  3681	  const message = input.value.trim();
  3682	  if (!message) return;
  3683	  // Same load-guard saveSingleLesson() enforced on the old path — after a
  3684	  // failed load the cache is empty, so the legacy-thread migration below
  3685	  // would run blind against whatever is really on the server.
  3686	  if (lessonDataLoadedSuccessfully === false) {
  3687	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  3688	    return;
  3689	  }
  3690	
  3691	  const semKey = modalSemKey || getTvSemKey();
  3692	  // This modal never hosts a camp season (the Today View routes those to the
  3693	  // summer editor, whose Q&A lives in summerCamps_prepHelpQueue), so a write
  3694	  // under that key into curriculum/lessonData is never right. Routed by TYPE
  3695	  // now (Phase 1, 1.1) — a third type is refused out loud rather than written
  3696	  // into the shared weekly document.
  3697	  let lessonStore;
  3698	  try {
  3699	    lessonStore = lessonStoreFor(semKey);
  3700	  } catch (err) {
  3701	    alert(err.message);
  3702	    return;
  3703	  }
  3704	  if (lessonStore === 'camp') {
  3705	    alert('Summer camp questions are sent from the camp lesson editor.');
  3706	    return;
  3707	  }
  3708	
  3709	  // Confirm the lesson still exists on the server (an admin may have moved or
  3710	  // deleted it since this modal opened). A dotted-path update would otherwise
  3711	  // recreate the old key as a Q&A-only ghost lesson. Same forced read and
  3712	  // accepted check-to-write residual as sendHelpResponse()/sendQaReply().
  3713	  let check;
  3714	  try {
  3715	    check = await adminLessonStillExistsWithRetry(semKey, lessonKey);
  3716	  } catch (err) {
  3717	    console.warn('⚠️ Existence check retry also failed:', err);
  3718	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  3719	    return;
  3720	  }
  3721	  if (!check.exists) {
  3722	    alert('This lesson was moved or removed elsewhere. Your message was not sent — please close this and check the classbook for its new location.');
  3723	    return;
  3724	  }
  3725	  const existing = check.data;
  3726	
  3727	  const user = getAuthUser();
  3728	  const isAdmin = ['admin', 'manager'].includes(user?.role);
  3729	  const newEntry = {
  3730	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  3731	    from: isAdmin ? 'admin' : 'teacher',
  3732	    name: user?.name || 'Unknown',
  3733	    message,
  3734	    timestamp: new Date().toISOString()
  3735	  };
  3736	  // The fresh server copy decides whether a legacy teacherNotes/adminResponse
  3737	  // thread still needs migrating into qaThread on this lesson's first entry.
  3738	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  3739	  const editedAt = new Date().toISOString();
  3740	  const editedBy = user?.name || 'Unknown';
  3741	
  3742	  let target;
  3743	  try {
  3744	    target = weeklyLessonTarget(semKey);   // own-doc semester: its own doc, or "editing is paused"
  3745	  } catch (err) {
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-r2c0V4Bz' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-pvfvDN4O' (errno=Operation not permitted)
  7180	  container.innerHTML = html;
  7181	}
  7182	
  7183	function toggleHqFilter() {
  7184	  hqFilterNeedsReply = !hqFilterNeedsReply;
  7185	  renderHelpQueue();
  7186	}
  7187	
  7188	function getTimeAgo(timestamp) {
  7189	  const now = Date.now();
  7190	  const then = new Date(timestamp).getTime();
  7191	  const diff = now - then;
  7192	  const mins = Math.floor(diff / 60000);
  7193	  if (mins < 1) return 'just now';
  7194	  if (mins < 60) return `${mins}m ago`;
  7195	  const hours = Math.floor(mins / 60);
  7196	  if (hours < 24) return `${hours}h ago`;
  7197	  const days = Math.floor(hours / 24);
  7198	  if (days === 1) return 'yesterday';
  7199	  return `${days}d ago`;
  7200	}
  7201	
  7202	// Shared by sendHelpResponse() and sendQaReply() below — seeds arrayUnion's
  7203	// argument list with the legacy teacherNotes/adminResponse thread on a
  7204	// lesson's FIRST atomic-append reply, so that legacy content isn't silently
  7205	// lost the moment qaThread gets its first real entry. arrayUnion's deep-
  7206	// equality dedup makes repeating this migration from concurrent senders safe.
  7207	function buildQaThreadUnionArgs(existingLesson, newEntry) {
  7208	  const needsMigration = !existingLesson?.qaThread || existingLesson.qaThread.length === 0;
  7209	  return needsMigration ? [...getQaThread(existingLesson || {}), newEntry] : [newEntry];
  7210	}
  7211	
  7212	// Backtracking audit Phase 11 fix: both admin Q&A reply functions used to
  7213	// resave the ENTIRE cached semester via saveLessonData() — a Firestore
  7214	// set({merge:true}) of every lesson currently sitting in this admin's
  7215	// browser, not just the one being replied to. If a teacher's save landed on
  7216	// the server in the split-second before this admin's live listener caught
  7217	// up, that reply would silently revert the teacher's edit back to this
  7218	// admin's stale cached copy — for ANY lesson in the semester, not just the
  7219	// one in the reply. Now a single targeted Firestore .update() touching only
  7220	// this lesson's own field paths, with arrayUnion() for qaThread (survives a
  7221	// genuinely concurrent sender) and an existence check (a stale, long-open
  7222	// popup can't silently recreate a lesson deleted/moved elsewhere).
  7223	async function sendHelpResponse(key) {
  7224	  const input = document.getElementById(`ca-help-input-${key}`);
  7225	  if (!input) return;
  7226	  const response = input.value.trim();
  7227	  if (!response) return;
  7228	
  7229	  const semKey = getAdminSemKey();
  7230	  // Same load guard as every other lesson writer (Phase 1 review): after a
  7231	  // failed reload the listener deliberately KEEPS the previous summer maps, so
  7232	  // the cached lesson and the existence check both still pass — without this
  7233	  // an admin could write a reply while the banner says saving is disabled.
  7234	  if (lessonDataLoadedSuccessfully === false) {
  7235	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  7236	    return;
  7237	  }
  7238	  // A semester type this writer has no branch for is refused here, before the
  7239	  // existence check below — a throw inside that try would be reported to the
  7240	  // admin as "check your connection", which it isn't (Phase 1, 1.1).
  7241	  let lessonStore;
  7242	  try {
  7243	    lessonStore = lessonStoreFor(semKey);
  7244	  } catch (err) {
  7245	    alert(err.message);
  7246	    return;
  7247	  }
  7248	  const cachedExisting = currentLessonData?.[semKey]?.[key];
  7249	  if (!cachedExisting) return;
  7250	
  7251	  let check;
  7252	  try {
  7253	    check = await adminLessonStillExistsWithRetry(semKey, key);
  7254	  } catch (err) {
  7255	    console.warn('⚠️ Existence check retry also failed:', err);
  7256	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  7257	    return;
  7258	  }
  7259	  if (!check.exists) {
  7260	    alert('This lesson was moved or removed elsewhere. Your response was not sent — please close this and check the grid for its new location.');
  7261	    return;
  7262	  }
  7263	  const existing = check.data || cachedExisting;
  7264	
  7265	  const user = getAuthUser();
  7266	  const newEntry = {
  7267	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  7268	    from: 'admin', name: user?.name || 'Admin', message: response, timestamp: new Date().toISOString()
  7269	  };
  7270	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7271	
  7272	  if (!curriculumDb) initCurriculumFirestore();
  7273	  const isSummer = lessonStore === 'camp';
  7274	  const updates = {};
  7275	  let weekly = null;
  7276	  if (!isSummer) {
  7277	    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
  7278	  }
  7279	  if (isSummer) {
  7280	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7281	    updates.adminResponse = response;
  7282	    updates.status = 'In Progress';
  7283	    updates.lastUpdated = new Date().toISOString();
  7284	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7285	  } else {
  7286	    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7287	    updates[`${weekly.prefix}${key}.adminResponse`] = response;
  7288	    updates[`${weekly.prefix}${key}.status`] = 'In Progress';
  7289	    updates.lastUpdated = new Date().toISOString();
  7290	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7291	  }
  7292	  const docRef = isSummer
  7293	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7294	    : weekly.ref;
  7295	
  7296	  try {
  7297	    await docRef.update(updates);
  7298	  } catch (err) {
  7299	    console.error('Error sending help response:', err);
  7300	    alert('Error sending response: ' + err.message);
  7301	    return;
  7302	  }
  7303	
  7304	  currentLessonData[semKey][key] = {
  7305	    ...existing, adminResponse: response,
  7306	    qaThread: [...(existing.qaThread && existing.qaThread.length > 0 ? existing.qaThread : getQaThread(existing)), newEntry],
  7307	    status: 'In Progress'
  7308	  };
  7309	  renderHelpQueue();
  7310	}
  7311	
  7312	async function sendQaReply(key) {
  7313	  const input = document.getElementById(`qa-reply-${key}`);
  7314	  if (!input) return;
  7315	  const message = input.value.trim();
  7316	  if (!message) return;
  7317	
  7318	  const semKey = getAdminSemKey();
  7319	  // Same load guard as every other lesson writer (Phase 1 review): after a
  7320	  // failed reload the listener deliberately KEEPS the previous summer maps, so
  7321	  // the cached lesson and the existence check both still pass — without this
  7322	  // an admin could write a reply while the banner says saving is disabled.
  7323	  if (lessonDataLoadedSuccessfully === false) {
  7324	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  7325	    return;
  7326	  }
  7327	  // A semester type this writer has no branch for is refused here, before the
  7328	  // existence check below — a throw inside that try would be reported to the
  7329	  // admin as "check your connection", which it isn't (Phase 1, 1.1).
  7330	  let lessonStore;
  7331	  try {
  7332	    lessonStore = lessonStoreFor(semKey);
  7333	  } catch (err) {
  7334	    alert(err.message);
  7335	    return;
  7336	  }
  7337	  const cachedExisting = currentLessonData?.[semKey]?.[key];
  7338	  if (!cachedExisting) return;
  7339	
  7340	  let check;
  7341	  try {
  7342	    check = await adminLessonStillExistsWithRetry(semKey, key);
  7343	  } catch (err) {
  7344	    console.warn('⚠️ Existence check retry also failed:', err);
  7345	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  7346	    return;
  7347	  }
  7348	  if (!check.exists) {
  7349	    alert('This lesson was moved or removed elsewhere. Your reply was not sent — please close this window and check the grid for its new location.');
  7350	    return;
  7351	  }
  7352	  const existing = check.data || cachedExisting;
  7353	
  7354	  const user = getAuthUser();
  7355	  const newEntry = {
  7356	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  7357	    from: 'admin', name: user?.name || 'Admin', message, timestamp: new Date().toISOString()
  7358	  };
  7359	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7360	
  7361	  if (!curriculumDb) initCurriculumFirestore();
  7362	  const isSummer = lessonStore === 'camp';
  7363	  const updates = {};
  7364	  let weekly = null;
  7365	  if (!isSummer) {
js/firebase-data.js:1150:      createdAt: firebase.firestore.FieldValue.serverTimestamp(),
js/firebase-data.js:1151:      lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
js/firebase-data.js:1155:      qaThread: firebase.firestore.FieldValue.arrayUnion(newMsg),
js/firebase-data.js:1157:      lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
js/firebase-data.js:1540:      [semesterKey]: firebase.firestore.FieldValue.arrayUnion(entry)
js/firebase-data.js:1587:// DocumentReference, so the retry path can be tested without real network failures.
js/firebase-data.js:1879:        canvas.toBlob((blob) => {
js/app.js:3574:    // atomic arrayUnion() senders — this form never edits them, and writing
js/app.js:3672:// only this lesson's own Q&A paths, with arrayUnion() for the thread — the
js/app.js:3751:    [`${p}.qaThread`]: firebase.firestore.FieldValue.arrayUnion(...entriesToAdd),
js/app.js:3769:  // write triggers a latency-compensated snapshot (with the arrayUnion
js/app.js:6343:// lesson object (not a hand-picked field list) via FieldValue.arrayUnion()
js/app.js:6394:      [semKey]: firebase.firestore.FieldValue.arrayUnion(archiveEntry)
js/app.js:6500:// cutProject()'s arrayUnion() append-side fix, same document, same reasoning:
js/app.js:7107:function getLatestMessageTimestamp(lesson) {
js/app.js:7133:    .sort((a, b) => getLatestMessageTimestamp(b[1]) - getLatestMessageTimestamp(a[1]));
js/app.js:7202:// Shared by sendHelpResponse() and sendQaReply() below — seeds arrayUnion's
js/app.js:7205:// lost the moment qaThread gets its first real entry. arrayUnion's deep-
js/app.js:7220:// this lesson's own field paths, with arrayUnion() for qaThread (survives a
js/app.js:7280:    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
js/app.js:7286:    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
js/app.js:7369:    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
js/app.js:7374:    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
js/app.js:8532:function buildInitialThread(teacherName, teacherNotes, adminResponse, importTimestamp) {
js/app.js:8534:  const timestamp = importTimestamp || new Date().toISOString();
/**
 * EMULATOR-ONLY state staging for the Spring 2026 storage move specs.
 *
 * The Phase A rules deliberately make a verified move impossible to undo from any
 * client (no delete of lessons_spring-2026, verified is one-way), so these specs
 * reset curriculum/lessonData, curriculum/lessons_spring-2026 and
 * curriculum/storageMigrations with firebase-admin — exactly as
 * e2e/emulators/seed.js does: it refuses to initialise unless the emulator env
 * vars point at loopback, the project is a demo- id, and it never reads a
 * credential file.
 */
const { PROJECT_ID, requireEmulatorEnv } = require('../emulators/config');
const { loadFixtures } = require('../emulators/seed');

const SPRING = 'spring-2026';
const SPRING_DOC = 'lessons_spring-2026';

let db = null;
function adminDb() {
  if (db) return db;
  requireEmulatorEnv('storage-move helper');
  if (!PROJECT_ID.startsWith('demo-')) throw new Error(`[storage-move] PROJECT_ID must be a demo- project (got ${PROJECT_ID})`);
  const admin = require('firebase-admin');
  const app = admin.apps.find(a => a && a.name === 'storage-move') || admin.initializeApp({ projectId: PROJECT_ID }, 'storage-move');
  db = app.firestore();
  return db;
}

const fixtureLessonData = () => JSON.parse(JSON.stringify(loadFixtures().curriculum.lessonData));
const springFixture = () => fixtureLessonData()[SPRING];

// Back to the seeded state: Spring inside lessonData, no own doc, no record.
async function resetStorageMove() {
  const d = adminDb();
  await d.collection('curriculum').doc('lessonData').set(fixtureLessonData());
  await d.collection('curriculum').doc(SPRING_DOC).delete();
  await d.collection('curriculum').doc('storageMigrations').delete();
}

// As if the Phase C transaction ran: Spring in its own doc, gone from lessonData.
async function stageMoved({ verified }) {
  const d = adminDb();
  const lessonData = fixtureLessonData();
  const spring = lessonData[SPRING];
  delete lessonData[SPRING];
  await d.collection('curriculum').doc('lessonData').set(lessonData);
  await d.collection('curriculum').doc(SPRING_DOC).set({ ...spring, lastUpdated: 'staged', lastUpdatedBy: 'e2e' });
  await d.collection('curriculum').doc('storageMigrations').set({ [SPRING]: { verified, lessonCount: Object.keys(spring).length, sha256: 'staged' } });
}

async function readCurriculumDoc(docId) {
  const snap = await adminDb().collection('curriculum').doc(docId).get();
  return snap.exists ? snap.data() : null;
}
async function writeCurriculumDoc(docId, data, { merge = false } = {}) {
  await adminDb().collection('curriculum').doc(docId).set(data, { merge });
}
async function deleteCurriculumDoc(docId) {
  await adminDb().collection('curriculum').doc(docId).delete();
}

module.exports = { SPRING, SPRING_DOC, springFixture, resetStorageMove, stageMoved, readCurriculumDoc, writeCurriculumDoc, deleteCurriculumDoc };

exec
/bin/zsh -lc "if [ -f /Users/christiehubley/tinker-backups/backup.js ]; then rg -n -C 5 \"lessons_|computeClassbookContentByTeacher|return counts\" /Users/christiehubley/tinker-backups/backup.js; git -C /Users/christiehubley/tinker-backups status --short; else echo 'backup.js not readable'; fi; git diff 132fef2..05b159b -- scripts/spring-2026-move.console.js e2e/spring-move-procedure.spec.js --check" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
274-    const data = JSON.parse(fs.readFileSync(path.join(BACKUP_DIR, files[0].name), 'utf8'));
275-    const counts = {};
276-    for (const [col, docs] of Object.entries(data.collections || {})) {
277-      counts[col] = Object.keys(docs || {}).length;
278-    }
279:    return counts;
280-  } catch (_) {
281-    return null;
282-  }
283-}
284-
--
365-
366-function classbookLessonHasContent(lesson) {
367-  return !!lesson && CLASSBOOK_CONTENT_FIELDS.some(f => lesson[f] && String(lesson[f]).trim());
368-}
369-
370:function computeClassbookContentByTeacher(collections) {
371-  const counts = {};
372-  const tally = (lesson) => {
373-    if (!lesson || !lesson.teacher || !classbookLessonHasContent(lesson)) return;
374-    counts[lesson.teacher] = (counts[lesson.teacher] || 0) + 1;
375-  };
--
383-  for (const semesterLessons of Object.values(lessonDataDoc)) {
384-    if (!semesterLessons || typeof semesterLessons !== 'object') continue;
385-    for (const lesson of Object.values(semesterLessons)) tally(lesson);
386-  }
387-
388:  return counts;
389-}
390-
391-async function main() {
392-  if (!isWithinBackupWindow() && !process.argv.includes('--force')) {
393-    // Silent exit outside business hours
--
466-      collectionsBackedUp: COLLECTIONS.length,
467-      errorCollections,
468-      dataLossWarningCollections: dataLossWarnings.map(w => w.collection),
469-    };
470-    try {
471:      statusData.classbookContentByTeacher = computeClassbookContentByTeacher(backup.collections);
472-    } catch (err) {
473-      log(`WARNING: Classbook content-by-teacher tally failed (isolated, does not affect the backup itself): ${err.message}`);
474-    }
475-    try {
476-      await writeBackupStatus(token, statusData);
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-dgNlbFJt' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-t3kuoe3S' (errno=Operation not permitted)
fatal: not a git repository (or any of the parent directories): .git
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-ZSRHcHkj' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-hjfcVh9Z' (errno=Operation not permitted)
diff --git a/e2e/spring-move-procedure.spec.js b/e2e/spring-move-procedure.spec.js
new file mode 100644
index 0000000..d74ed9e
--- /dev/null
+++ b/e2e/spring-move-procedure.spec.js
@@ -0,0 +1,144 @@
+/**
+ * Rehearsal of the Phase C console procedure (scripts/spring-2026-move.console.js) —
+ * the EXACT file Christie pastes, run in the emulator against the deployed Phase A rules.
+ * Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase C).
+ *
+ * EMULATOR ONLY. Every test starts from and ends at the seeded state (admin helper).
+ */
+const fs = require('fs');
+const path = require('path');
+const { test, expect } = require('@playwright/test');
+const { login, MANAGER_STATE_PATH } = require('./helpers/login');
+const SM = require('./helpers/storage-move');
+
+const PROCEDURE = fs.readFileSync(path.join(__dirname, '..', 'scripts', 'spring-2026-move.console.js'), 'utf8');
+const LESSON = 'fixtureteacher-fixtureclass-1';
+
+test.describe.configure({ mode: 'serial' });
+test.beforeEach(async () => { await SM.resetStorageMove(); });
+test.afterEach(async () => { await SM.resetStorageMove(); });
+
+async function openAs(browser, role) {
+  const ctx = role === 'manager' ? await browser.newContext({ storageState: MANAGER_STATE_PATH, acceptDownloads: true }) : await browser.newContext({ acceptDownloads: true });
+  const page = await ctx.newPage();
+  await login(page, role === 'manager' ? 'manager' : undefined);
+  await page.waitForFunction(() => lessonDataLoadedSuccessfully === true && currentLessonData?.['spring-2026'], null, { timeout: 25_000 });
+  return { ctx, page };
+}
+// Loads the procedure without auto-running; dialogs answered by `answerConfirm`.
+async function runProcedure(page, { answerConfirm = true, opts = {} } = {}) {
+  const dialogs = [];
+  page.on('dialog', d => { dialogs.push(`${d.type()}: ${d.message()}`); d.type() === 'confirm' ? (answerConfirm ? d.accept() : d.dismiss()) : d.accept(); });
+  await page.addScriptTag({ content: `window.__SPRING_MOVE_NO_AUTORUN = true;\n${PROCEDURE}` });
+  const downloadPromise = page.waitForEvent('download', { timeout: 15_000 }).catch(() => null);
+  const result = await page.evaluate((o) => springMove(o), opts);
+  const download = await downloadPromise;
+  return { result, dialogs, download };
+}
+const snapshotAll = async () => ({
+  lessonData: await SM.readCurriculumDoc('lessonData'),
+  target: await SM.readCurriculumDoc(SM.SPRING_DOC),
+  migrations: await SM.readCurriculumDoc('storageMigrations'),
+});
+const stripStamps = (d) => { const m = { ...(d || {}) }; delete m.lastUpdated; delete m.lastUpdatedBy; return m; };
+
+test.describe('Spring 2026 move procedure (Phase C rehearsal)', () => {
+
+  test('happy path: backup downloaded, one-step move, verified, Spring editable; an open tab follows along', async ({ browser }) => {
+    const other = await openAs(browser, 'staff');   // a staff tab open during the move
+    await other.page.evaluate(() => { window.__minSpring = Infinity; window.__w = setInterval(() => { const n = Object.keys(currentLessonData?.['spring-2026'] || {}).length; if (n < window.__minSpring) window.__minSpring = n; }, 25); });
+    const { ctx, page } = await openAs(browser, 'manager');
+
+    const { result, dialogs, download } = await runProcedure(page);
+    expect(result.ok, JSON.stringify(result)).toBe(true);
+    expect(dialogs.some(d => d.startsWith('confirm:') && /backup of Spring 2026 \(3 lessons\)/.test(d))).toBe(true);
+    expect(dialogs.some(d => d.startsWith('alert:') && /Done ✓/.test(d))).toBe(true);
+
+    // The backup file.
+    expect(download).not.toBeNull();
+    const backup = JSON.parse(fs.readFileSync(await download.path(), 'utf8'));
+    expect(backup.lessons).toEqual(SM.springFixture());
+    expect(backup.lessonCount).toBe(3);
+    expect(backup.sha256).toBe(result.sha256);
+
+    // Server state.
+    const after = await snapshotAll();
+    expect(stripStamps(after.target)).toEqual(SM.springFixture());
+    expect(after.lessonData['spring-2026']).toBeUndefined();
+    expect(after.migrations['spring-2026']).toMatchObject({ verified: true, lessonCount: 3, sha256: result.sha256 });
+
+    // The manager tab: Spring from its own doc, editable.
+    await page.waitForFunction(() => ownDocSource['spring-2026'] === 'ownDoc' && weeklySemesterPausedMessage('spring-2026') === null, null, { timeout: 15_000 });
+    // The staff tab that was open during the move: never blank, now on the own doc, and it can save.
+    await other.page.waitForFunction(() => ownDocSource['spring-2026'] === 'ownDoc' && weeklySemesterPausedMessage('spring-2026') === null, null, { timeout: 15_000 });
+    expect(await other.page.evaluate(() => { clearInterval(window.__w); return window.__minSpring; })).toBe(3);
+    const saved = await other.page.evaluate(async (k) => { try { await saveSingleLesson('spring-2026', k, { shortDetails: 'Edited after the move' }); return 'ok'; } catch (e) { return e.message; } }, LESSON);
+    expect(saved).toBe('ok');
+    expect((await SM.readCurriculumDoc(SM.SPRING_DOC))[LESSON].shortDetails).toBe('Edited after the move');
+    await ctx.close(); await other.ctx.close();
+  });
+
+  test('cancel at the confirmation changes nothing', async ({ browser }) => {
+    const before = await snapshotAll();
+    const { ctx, page } = await openAs(browser, 'manager');
+    const { result } = await runProcedure(page, { answerConfirm: false });
+    expect(result.ok).toBe(false);
+    expect(result.message).toMatch(/Cancelled before the move\. Nothing was changed/);
+    expect(await snapshotAll()).toEqual(before);
+    await ctx.close();
+  });
+
+  test('a failed verification undoes the move exactly (and a later run then succeeds)', async ({ browser }) => {
+    const before = await snapshotAll();
+    const { ctx, page } = await openAs(browser, 'manager');
+    const { result } = await runProcedure(page, { opts: { simulateVerifyFailure: true } });
+    expect(result.ok).toBe(false);
+    expect(result.message).toMatch(/move was undone/);
+    const after = await snapshotAll();
+    expect(after.lessonData['spring-2026']).toEqual(SM.springFixture());
+    expect(after.target).toBeNull();
+    expect(after.migrations?.['spring-2026']).toBeUndefined();
+    expect(stripStamps(after.lessonData)).toEqual(stripStamps(before.lessonData));
+
+    const again = await page.evaluate(() => springMove());
+    expect(again.ok, JSON.stringify(again)).toBe(true);
+    expect((await SM.readCurriculumDoc('storageMigrations'))['spring-2026'].verified).toBe(true);
+    await ctx.close();
+  });
+
+  test('refuses (nothing changed) when Spring was already moved', async ({ browser }) => {
+    await SM.stageMoved({ verified: true });
+    const before = await snapshotAll();
+    const { ctx, page } = await openAs(browser, 'manager');
+    const { result, download } = await runProcedure(page);
+    expect(result.ok).toBe(false);
+    expect(result.message).toMatch(/Nothing was changed/);
+    expect(download).toBeNull();
+    expect(await snapshotAll()).toEqual(before);
+    await ctx.close();
+  });
+
+  test('refuses for a non-manager (nothing changed)', async ({ browser }) => {
+    const before = await snapshotAll();
+    const { ctx, page } = await openAs(browser, 'staff');
+    const { result } = await runProcedure(page);
+    expect(result.ok).toBe(false);
+    expect(result.message).toMatch(/Sign in as a manager/);
+    expect(await snapshotAll()).toEqual(before);
+    await ctx.close();
+  });
+
+  test('works on a near-full-size document (~550 KB Spring + ~400 KB other semester)', async ({ browser }) => {
+    const big = (n) => { const o = {}; for (let i = 0; i < n; i++) o[`teacher-class-${i}`] = { teacher: `T${i % 7}`, shortDetails: 'x'.repeat(600), processStep1: 'y'.repeat(600), introPitch: 'z'.repeat(500) }; return o; };
+    const spring = big(300);
+    await SM.writeCurriculumDoc('lessonData', { 'spring-2026': spring, 'fall-2026': big(230), lastUpdated: 'x' });
+    const { ctx, page } = await openAs(browser, 'manager');
+    const { result } = await runProcedure(page);
+    expect(result.ok, JSON.stringify(result)).toBe(true);
+    expect(result.count).toBe(300);
+    expect(result.lessonDataKB).toBeLessThan(450);
+    expect(stripStamps(await SM.readCurriculumDoc(SM.SPRING_DOC))).toEqual(spring);
+    expect((await SM.readCurriculumDoc('lessonData'))['spring-2026']).toBeUndefined();
+    await ctx.close();
+  });
+});
diff --git a/scripts/spring-2026-move.console.js b/scripts/spring-2026-move.console.js
new file mode 100644
index 0000000..da9a3f6
--- /dev/null
+++ b/scripts/spring-2026-move.console.js
@@ -0,0 +1,165 @@
+// ─── Spring 2026 storage move — Phase C (one-off, run by a manager) ─────────────
+// Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html
+//
+// HOW TO RUN: on https://tinker-classbook.netlify.app, signed in as a manager, open the
+// browser console (⌥⌘J), paste this WHOLE file, press Enter. It never runs on its own
+// from the site — this file isn't deployed (dist/ holds only the app).
+//
+// What it does, in order — stopping with "nothing was changed" at the first problem:
+//   1. Checks you're a manager and reads curriculum/lessonData, lessons_spring-2026 and
+//      storageMigrations fresh from the server: Spring must be in lessonData, its own
+//      document must not exist yet, and there must be no earlier move record.
+//   2. Downloads a JSON backup of Spring's lessons and asks you to confirm.
+//   3. ONE transaction: creates lessons_spring-2026 from the lessons read inside the
+//      transaction, removes spring-2026 from lessonData, and records the move
+//      (lesson count + SHA-256 fingerprint, verified: false). All or nothing.
+//   4. Verifies from fresh server reads: the new document's lessons have the same count
+//      and fingerprint, and lessonData no longer holds Spring. Spring edits are paused by
+//      the rules throughout, so nothing can change in between.
+//   5a. Passed → marks the move verified (Spring becomes editable again) and reports the
+//       new lessonData size.
+//   5b. Failed → one transaction puts Spring back into lessonData and removes the new
+//       document and the record (only allowed while unverified), exactly as before.
+//
+// The Phase A rules (studio-hub 0caf415) allow exactly these writes and nothing else.
+async function springMove(opts = {}) {
+  const K = 'spring-2026';
+  const TARGET = 'lessons_spring-2026';
+  const say = (...a) => console.log('%c[spring-move]', 'color:#6052C8;font-weight:bold', ...a);
+  const stop = (msg) => {
+    console.error('[spring-move] STOPPED:', msg);
+    alert(`Spring 2026 move STOPPED.\n\n${msg}`);
+    return { ok: false, message: msg };
+  };
+
+  const user = getAuthUser();
+  if (!user || !['admin', 'manager'].includes(user.role)) return stop('Sign in as a manager first. Nothing was changed.');
+  if (!curriculumDb) initCurriculumFirestore();
+  const db = curriculumDb;
+  const ref = (id) => db.collection('curriculum').doc(id);
+  const by = user.name || user.email || 'Unknown';
+
+  // A fingerprint independent of key order: sorted keys, Timestamps as seconds/nanos.
+  const canon = (v) => {
+    if (v === null || typeof v !== 'object') return v;
+    if (typeof v.toDate === 'function' && 'seconds' in v) return { __ts: [v.seconds, v.nanoseconds] };
+    if (Array.isArray(v)) return v.map(canon);
+    const out = {};
+    for (const k of Object.keys(v).sort()) out[k] = canon(v[k]);
+    return out;
+  };
+  const sha256 = async (obj) => {
+    const bytes = new TextEncoder().encode(JSON.stringify(canon(obj)));
+    const digest = await crypto.subtle.digest('SHA-256', bytes);
+    return [...new Uint8Array(digest)].map(b => b.toString(16).padStart(2, '0')).join('');
+  };
+  const lessonsOf = (data) => { const m = { ...(data || {}) }; delete m.lastUpdated; delete m.lastUpdatedBy; return m; };
+
+  // 1. Preflight — forced server reads.
+  let ld, tgt, mig;
+  try {
+    [ld, tgt, mig] = await Promise.all([
+      ref('lessonData').get({ source: 'server' }),
+      ref(TARGET).get({ source: 'server' }),
+      ref('storageMigrations').get({ source: 'server' }),
+    ]);
+  } catch (err) {
+    return stop(`Couldn't read the current data from the server (${err.message}). Nothing was changed.`);
+  }
+  const springMap = ld.exists ? ld.data()?.[K] : null;
+  if (!springMap || typeof springMap !== 'object') return stop('Spring 2026 is not in the shared lesson document — it may already have been moved. Nothing was changed.');
+  if (tgt.exists) return stop(`${TARGET} already exists. Nothing was changed.`);
+  if (mig.exists && mig.data()?.[K]) return stop('There is already a Spring 2026 move record. Nothing was changed.');
+  const count = Object.keys(springMap).length;
+  const fingerprint = await sha256(springMap);
+  say(`Spring 2026: ${count} lessons, fingerprint ${fingerprint.slice(0, 12)}…`);
+
+  // 2. Backup download, then confirm.
+  const fileName = `classbook-${K}-lessons-${new Date().toISOString().replace(/[:.]/g, '-')}.json`;
+  const backup = JSON.stringify({ semester: K, takenAt: new Date().toISOString(), takenBy: by, lessonCount: count, sha256: fingerprint, lessons: springMap }, null, 2);
+  const link = document.createElement('a');
+  link.href = URL.createObjectURL(new Blob([backup], { type: 'application/json' }));
+  link.download = fileName;
+  document.body.appendChild(link); link.click(); link.remove();
+  if (!confirm(`A backup of Spring 2026 (${count} lessons) was just downloaded:\n\n${fileName}\n\nCheck it's in your Downloads folder, then press OK to move Spring 2026 into its own storage.\n\nCancel stops here — nothing is changed.`)) {
+    return stop('Cancelled before the move. Nothing was changed.');
+  }
+
+  // 3. The move — one transaction.
+  const movedAt = new Date().toISOString();
+  let moved;
+  try {
+    await db.runTransaction(async (tx) => {
+      const l = await tx.get(ref('lessonData'));
+      const t = await tx.get(ref(TARGET));
+      const m = await tx.get(ref('storageMigrations'));
+      if (t.exists) throw new Error(`${TARGET} appeared`);
+      if (m.exists && m.data()?.[K]) throw new Error('a move record appeared');
+      const inTx = l.exists ? l.data()?.[K] : null;
+      if (!inTx) throw new Error('Spring 2026 is no longer in lessonData');
+      moved = { lessons: inTx, count: Object.keys(inTx).length, sha256: await sha256(inTx) };
+      tx.set(ref(TARGET), { ...inTx, lastUpdated: movedAt, lastUpdatedBy: by });
+      tx.update(ref('lessonData'), { [K]: firebase.firestore.FieldValue.delete() });
+      tx.set(ref('storageMigrations'), { [K]: { movedAt, movedBy: by, lessonCount: moved.count, sha256: moved.sha256, verified: false } }, { merge: true });
+    });
+  } catch (err) {
+    return stop(`The move transaction didn't go through (${err.message}). It's all-or-nothing, so nothing was changed.`);
+  }
+  say('Moved. Verifying from the server…');
+
+  // 4. Verify — fresh server reads.
+  const problems = [];
+  let l2, t2, m2;
+  try {
+    [l2, t2, m2] = await Promise.all([
+      ref('lessonData').get({ source: 'server' }),
+      ref(TARGET).get({ source: 'server' }),
+      ref('storageMigrations').get({ source: 'server' }),
+    ]);
+    const rec = m2.data()?.[K];
+    if (!t2.exists) problems.push('the new document is missing');
+    const targetLessons = lessonsOf(t2.data());
+    if (Object.keys(targetLessons).length !== moved.count) problems.push(`lesson count ${Object.keys(targetLessons).length} ≠ ${moved.count}`);
+    if ((await sha256(targetLessons)) !== moved.sha256) problems.push('fingerprint of the new document differs');
+    if (!rec || rec.sha256 !== moved.sha256 || rec.lessonCount !== moved.count) problems.push('the move record doesn\'t match');
+    if (l2.exists && K in (l2.data() || {})) problems.push('Spring 2026 is still in the shared document');
+    if (opts.simulateVerifyFailure) problems.push('simulated failure (rehearsal)');
+  } catch (err) {
+    problems.push(`couldn't read back from the server (${err.message})`);
+  }
+
+  if (problems.length) {
+    // 5b. Undo — one transaction, allowed by the rules only while unverified.
+    console.error('[spring-move] Verification failed:', problems);
+    try {
+      await db.runTransaction(async (tx) => {
+        const l = await tx.get(ref('lessonData'));
+        const t = await tx.get(ref(TARGET));
+        await tx.get(ref('storageMigrations'));
+        if (!t.exists) throw new Error('the new document is already gone');
+        if (l.exists && K in (l.data() || {})) throw new Error('Spring 2026 is already back in lessonData');
+        tx.update(ref('lessonData'), { [K]: moved.lessons });
+        tx.delete(ref(TARGET));
+      });
+      await ref('storageMigrations').update({ [K]: firebase.firestore.FieldValue.delete() });
+    } catch (err) {
+      return stop(`Verification failed (${problems.join('; ')}) AND the automatic undo failed (${err.message}). Don't retry — tell Claude. Spring's lessons are safe in the backup file ${fileName} and in the new document.`);
+    }
+    return stop(`Verification failed (${problems.join('; ')}), so the move was undone: Spring 2026 is back in the shared document exactly as before. Nothing was lost.`);
+  }
+
+  // 5a. Mark verified — Spring becomes editable again.
+  try {
+    await ref('storageMigrations').update({ [`${K}.verified`]: true, [`${K}.verifiedAt`]: new Date().toISOString(), [`${K}.verifiedBy`]: by });
+  } catch (err) {
+    return stop(`The move is done and checked, but marking it verified failed (${err.message}). Spring is safe and viewable; its edits stay paused. Tell Claude — this can be retried safely.`);
+  }
+  const kb = typeof approxFirestoreSize === 'function' ? Math.round(approxFirestoreSize(l2.data() || {}) / 1024) : null;
+  const msg = `Spring 2026 moved and verified: ${moved.count} lessons, fingerprint ${moved.sha256.slice(0, 12)}…` + (kb !== null ? `\nShared lesson storage is now about ${kb} KB of 1,024 KB.` : '');
+  say(msg);
+  alert(`Done ✓\n\n${msg}\n\nSpring 2026 is editable again. Keep the backup file ${fileName}.`);
+  return { ok: true, message: msg, count: moved.count, sha256: moved.sha256, lessonDataKB: kb, fileName };
+}
+
+// Pasted into the console: run it. (The e2e rehearsal sets __SPRING_MOVE_NO_AUTORUN and calls springMove() itself.)
+if (!window.__SPRING_MOVE_NO_AUTORUN) springMove();

exec
/bin/zsh -lc "sed -n '268,281p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html; nl -ba /Users/christiehubley/tinker-backups/backup.js | sed -n '366,392p'; git -C /Users/christiehubley/studio-hub show 0caf415:firestore.rules | nl -ba | sed -n '630,790p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
  </ul>
  The inventory adds <code>studio-hub/test-alerts-browser.html:227</code> and <code>TESTING-GUIDE.md:115</code> (manual, root <code>qaData</code> only).<br>
  <strong>Christie (Sep 29):</strong> she can't edit <code>backup.js</code> herself, and gave <strong>permission for Claude to make that one five-line change</strong> (keep a .bak, <code>node --check</code>, don't run it, touch nothing else), to be confirmed again at the time.
</div>
<div class="decision">
  <strong>Sep 29, 2026: Christie's answers.</strong> (Q1) Spring 2026 being view-only from Phase A until Phase C is fine. (Q2) Christie will paste the <code>backup.js</code> change herself (option a) before Phase D. The exact lines, for <code>tinker-backups/backup.js</code> inside <code>computeClassbookContentByTeacher</code>, just before <code>return counts;</code>:
<pre style="font-size:.85rem">  // Own-document semesters: curriculum/lessons_&lt;semKey&gt; = { lessonKey: lesson, lastUpdated, … }.
  for (const [docId, doc] of Object.entries(collections['curriculum'] || {})) {
    if (!docId.startsWith('lessons_') || !doc || typeof doc !== 'object') continue;
    for (const lesson of Object.values(doc)) if (lesson &amp;&amp; typeof lesson === 'object') tally(lesson);
  }</pre>
  It's generic over <code>lessons_*</code>, so Fall's later move needs no second edit. <code>tally</code> ignores non-lesson values (<code>lastUpdated</code> strings have no <code>.teacher</code>). Also: Christie asked whether Spring stays reachable after the move. Yes: it stays in every semester list and is fully viewable, and it's editable again after Phase C.
</div>
<div class="decision">
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
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-B2KtfFZx' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-TENuhrKh' (errno=Operation not permitted)
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

codex
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
