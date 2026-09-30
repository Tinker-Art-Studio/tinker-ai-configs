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
session id: 01a0ef69-9791-7982-85ba-de847d7020be
--------
user
## Implementation review — Phase B (Classbook + Studio Hub alerts), before deploy
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase B; Phase A rules are LIVE: studio-hub 0caf415).
Diffs:
- Classbook: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-classbook.diff (worktree, read-only: /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81, branch claude/spring-own-doc)
- Studio Hub: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-studiohub.diff (worktree, read-only: /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc)
Note: the implementation keeps lessonStoreFor() returning 'weekly' for Spring and routes writes through a new weeklyLessonTarget() instead of a new 'ownDoc' store value — check that this is complete.
Adversarially review the actual code:
1. Can any lesson edit be lost, misrouted, duplicated, or silently refused for any semester (Fall especially — it must behave exactly as before)? Every writer and reader of weekly lessons, incl. paths not in the diff that read/write currentLessonData and then persist.
2. Listener logic: initial load vs listener ordering, the legacy carry-across, recheckOwnDocAfterLegacyLoss, the move and rollback transitions, error states, teardown/double registration, interaction with globalListenerGeneration / reloadSummer / lessonDataLoadedSuccessfully, SDOC and camp seasons.
3. The "editing is paused" window: every Spring write path refused with a clear message (none throwing obscure errors or half-writing); what the UI shows.
4. Studio Hub alerts: union/rebuild correctness, dismissal migration, cleanup, errors.
5. Tests: meaningful and non-leaking (the admin reset helper), gaps.
Verdict: SAFE TO DEPLOY or NOT (minimum list). Do not edit files or run tests.
codex
I’ll review the plan, both supplied diffs, and the surrounding reader/writer/listener code in each worktree. I’ll keep this strictly read-only and won’t run tests; the final verdict will separate deploy blockers from lower-risk gaps.
exec
/bin/zsh -lc 'wc -l /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-classbook.diff /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-studiohub.diff && git status --short --branch && git -C /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc status --short --branch' in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
     259 /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html
     831 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-classbook.diff
     328 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-studiohub.diff
    1418 total
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-eCCfL6QF' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-L4QG1ql6' (errno=Operation not permitted)
## claude/spring-own-doc...origin/claude/spring-own-doc
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-08lYmUWJ' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-aVJVXQUk' (errno=Operation not permitted)
## claude/classbook-alerts-own-doc...origin/claude/classbook-alerts-own-doc
?? node_modules

exec
/bin/zsh -lc "sed -n '1,320p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html && sed -n '1,900p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-classbook.diff && sed -n '1,380p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-studiohub.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
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
  <ul>
    <li>Adopted Codex's "simpler safe option": the copy and the old-copy removal are <strong>one transaction</strong>, with Spring edits paused by rule until the move is verified. That closes the verification/rollback race (1), the target-missing-at-delete risk (2) and double counting (5), since there's no dual-copy window, and Phases C and D merge.</li>
    <li>(3) The rules also fence <code>lessonData</code> create and whole-doc delete, keep manager delete for other docs, and the tests cover admin and curriculum-admin. Q3 is resolved: manager delete is kept, except for <code>lessonData</code>.</li>
    <li>(4) A stale-tab cutoff: Phase B live for 3 days or more, staff asked to reopen the Classbook, and an old tab can only mis-display, never lose data.</li>
    <li>(6) Studio Hub alerts reconcile a union across sources, with semester-qualified IDs.</li>
    <li>(7) Spring's delete is disabled in Phase B.</li>
    <li>(8) Merged <code>storageMigrations</code> writes, target-disappearance behaviour, and a Firestore-size estimator for the readout with an 85% warning.</li>
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
  <strong>Sep 29, 2026: revision 2, after review round 1 (Claude; <code>thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md</code>): NOT ready, 11-point minimum list, all taken.</strong> Re-scoped to <strong>Spring only, hard-coded</strong>, with no appData flags, <code>migratedSemesters</code>, UI buttons or "Move back". The copy and the removal are reviewed console procedures. The rules fence uses a literal key (no <code>get(appData)</code>), splits <code>:654</code>, and ships <strong>first</strong>. Fixed: the listener drops own-doc semesters (A); verify races (B, moot now that the fence freezes the source first); Phase D's precondition compares against the hash of what was written (C); vanished keys are loud (D); <code>not-found</code> on first write (E); <code>createNewSemester</code>/<code>deleteSemester</code> deferred to the follow-up plan, with a deadline (F, delete); the missing readers are added (<code>tinker-backups/backup.js</code>, which is Christie's edit, the in-app content count, <code>test-alerts.js</code>, dead backup helpers, e2e exemptions, seed); the backup citation and "nightly" are corrected; the listener generation is decided (no bump); teardown uses an array; a near-1 MB rules fixture is added; there's a headroom readout; and the emergency lever's order is fixed.<br>
  <strong>Open questions for Christie:</strong> (Q1) Is it OK that Spring 2026 is read-only ("editing is paused") from Phase A until Phase C, probably a few days? (Q2) Will you make the small <code>backup.js</code> edit before Phase D, or accept one expected content-loss alarm for Spring teachers? (Q3, for the reviewer) Undoing a bad Phase C copy needs a whole-doc delete of <code>lessons_spring-2026</code>; today only classbook-admin/curriculum-admin may whole-doc delete (<code>:675-678</code>). Should Phase A's split give managers delete as well (they have it today through <code>:654</code>'s <code>write</code>)? The plan assumes yes: the split keeps manager delete.
</div>
<div class="decision">
  <strong>Sep 29, 2026: plan created (draft 1).</strong> Found while reviewing the make-active plan's Archive design (now paused behind this plan). Christie measured 972 KB / 1,024 KB.
</div>

</body>
</html>
diff --git a/e2e/helpers/storage-move.js b/e2e/helpers/storage-move.js
new file mode 100644
index 0000000..670fa3f
--- /dev/null
+++ b/e2e/helpers/storage-move.js
@@ -0,0 +1,62 @@
+/**
+ * EMULATOR-ONLY state staging for the Spring 2026 storage move specs.
+ *
+ * The Phase A rules deliberately make a verified move impossible to undo from any
+ * client (no delete of lessons_spring-2026, verified is one-way), so these specs
+ * reset curriculum/lessonData, curriculum/lessons_spring-2026 and
+ * curriculum/storageMigrations with firebase-admin — exactly as
+ * e2e/emulators/seed.js does: it refuses to initialise unless the emulator env
+ * vars point at loopback, the project is a demo- id, and it never reads a
+ * credential file.
+ */
+const { PROJECT_ID, requireEmulatorEnv } = require('../emulators/config');
+const { loadFixtures } = require('../emulators/seed');
+
+const SPRING = 'spring-2026';
+const SPRING_DOC = 'lessons_spring-2026';
+
+let db = null;
+function adminDb() {
+  if (db) return db;
+  requireEmulatorEnv('storage-move helper');
+  if (!PROJECT_ID.startsWith('demo-')) throw new Error(`[storage-move] PROJECT_ID must be a demo- project (got ${PROJECT_ID})`);
+  const admin = require('firebase-admin');
+  const app = admin.apps.find(a => a && a.name === 'storage-move') || admin.initializeApp({ projectId: PROJECT_ID }, 'storage-move');
+  db = app.firestore();
+  return db;
+}
+
+const fixtureLessonData = () => JSON.parse(JSON.stringify(loadFixtures().curriculum.lessonData));
+const springFixture = () => fixtureLessonData()[SPRING];
+
+// Back to the seeded state: Spring inside lessonData, no own doc, no record.
+async function resetStorageMove() {
+  const d = adminDb();
+  await d.collection('curriculum').doc('lessonData').set(fixtureLessonData());
+  await d.collection('curriculum').doc(SPRING_DOC).delete();
+  await d.collection('curriculum').doc('storageMigrations').delete();
+}
+
+// As if the Phase C transaction ran: Spring in its own doc, gone from lessonData.
+async function stageMoved({ verified }) {
+  const d = adminDb();
+  const lessonData = fixtureLessonData();
+  const spring = lessonData[SPRING];
+  delete lessonData[SPRING];
+  await d.collection('curriculum').doc('lessonData').set(lessonData);
+  await d.collection('curriculum').doc(SPRING_DOC).set({ ...spring, lastUpdated: 'staged', lastUpdatedBy: 'e2e' });
+  await d.collection('curriculum').doc('storageMigrations').set({ [SPRING]: { verified, lessonCount: Object.keys(spring).length, sha256: 'staged' } });
+}
+
+async function readCurriculumDoc(docId) {
+  const snap = await adminDb().collection('curriculum').doc(docId).get();
+  return snap.exists ? snap.data() : null;
+}
+async function writeCurriculumDoc(docId, data, { merge = false } = {}) {
+  await adminDb().collection('curriculum').doc(docId).set(data, { merge });
+}
+async function deleteCurriculumDoc(docId) {
+  await adminDb().collection('curriculum').doc(docId).delete();
+}
+
+module.exports = { SPRING, SPRING_DOC, springFixture, resetStorageMove, stageMoved, readCurriculumDoc, writeCurriculumDoc, deleteCurriculumDoc };
diff --git a/e2e/spring-own-doc.spec.js b/e2e/spring-own-doc.spec.js
new file mode 100644
index 0000000..8f71503
--- /dev/null
+++ b/e2e/spring-own-doc.spec.js
@@ -0,0 +1,199 @@
+/**
+ * Spring 2026 storage move — Phase B: the Classbook reads and writes Spring from
+ * curriculum/lessons_spring-2026 once it exists, and never blanks it in between.
+ * Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase B).
+ *
+ * EMULATOR ONLY, against the deployed Phase A rules (studio-hub 0caf415): Spring's
+ * key in lessonData is fenced, the own doc is editable only once
+ * storageMigrations.spring-2026.verified is true. States are staged with the
+ * emulator-only admin helper (e2e/helpers/storage-move.js) because a verified move
+ * can't be undone from a client, and every test starts from — and the file ends
+ * at — the seeded state.
+ */
+const fs = require('fs');
+const path = require('path');
+const { test, expect } = require('@playwright/test');
+const { login } = require('./helpers/login');
+const SM = require('./helpers/storage-move');
+
+const LESSON = 'fixtureteacher-fixtureclass-1';
+const PAUSED = /editing it is paused/;
+
+test.describe.configure({ mode: 'serial' });
+test.beforeEach(async () => { await SM.resetStorageMove(); });
+test.afterAll(async () => { await SM.resetStorageMove(); });
+
+async function openApp(page) {
+  await login(page);
+  await page.waitForFunction(() => lessonDataLoadedSuccessfully === true
+    && currentLessonData && currentLessonData['spring-2026']
+    && Object.keys(currentLessonData['spring-2026']).length > 0, null, { timeout: 25_000 });
+}
+const springKeys = (page) => page.evaluate(() => Object.keys(currentLessonData?.['spring-2026'] || {}).filter(k => !k.startsWith('last')).sort());
+const source = (page) => page.evaluate(() => ownDocSource['spring-2026']);
+const call = (page, fnSrc, arg) => page.evaluate(async ({ fnSrc, arg }) => {
+  try { await (0, eval)(`(${fnSrc})`)(arg); return 'ok'; } catch (e) { return e.message; }
+}, { fnSrc: fnSrc.toString(), arg });
+// Records the smallest Spring lesson count seen, every 25 ms, from now on.
+const watchMinSpring = (page) => page.evaluate(() => {
+  window.__minSpring = Infinity;
+  window.__springWatch = setInterval(() => {
+    const n = Object.keys(currentLessonData?.['spring-2026'] || {}).length;
+    if (n < window.__minSpring) window.__minSpring = n;
+  }, 25);
+});
+const minSpring = (page) => page.evaluate(() => { clearInterval(window.__springWatch); return window.__minSpring; });
+
+const fixtureKeys = () => Object.keys(SM.springFixture()).sort();
+
+test.describe('Spring 2026 storage move — Phase B', () => {
+
+  test('before the move: Spring is viewable, every Spring write is paused, other semesters save', async ({ page }) => {
+    await openApp(page);
+    expect(await source(page)).toBe('legacy');
+    expect(await springKeys(page)).toEqual(fixtureKeys());
+
+    expect(await call(page, ({ LESSON }) => saveSingleLesson('spring-2026', LESSON, { shortDetails: 'E2E' }), { LESSON })).toMatch(PAUSED);
+    expect(await call(page, ({ LESSON }) => saveMultipleLessonFields('spring-2026', [{ lessonKey: LESSON, lessonData: { shortDetails: 'E2E' } }]), { LESSON })).toMatch(PAUSED);
+    expect(await call(page, ({ LESSON }) => deleteLessonKey('spring-2026', LESSON), { LESSON })).toMatch(PAUSED);
+    expect(await call(page, () => saveLessonData('spring-2026', {}))).toMatch(PAUSED);
+
+    const ld = await SM.readCurriculumDoc('lessonData');
+    expect(ld['spring-2026']).toEqual(SM.springFixture());
+
+    // Another weekly semester still saves to lessonData, exactly as before.
+    expect(await call(page, () => saveSingleLesson('e2e-other-semester', 'e2e-lesson', { shortDetails: 'Other' }))).toBe('ok');
+    expect((await SM.readCurriculumDoc('lessonData'))['e2e-other-semester']['e2e-lesson'].shortDetails).toBe('Other');
+  });
+
+  test('moved but not yet verified: Spring shows from its own doc; edits are still paused', async ({ page }) => {
+    await SM.stageMoved({ verified: false });
+    await openApp(page);
+    expect(await source(page)).toBe('ownDoc');
+    expect(await springKeys(page)).toEqual(fixtureKeys());
+    expect(await call(page, ({ LESSON }) => saveSingleLesson('spring-2026', LESSON, { shortDetails: 'E2E' }), { LESSON })).toMatch(PAUSED);
+    expect((await SM.readCurriculumDoc(SM.SPRING_DOC))[LESSON]).toEqual(SM.springFixture()[LESSON]);
+  });
+
+  test('moved and verified: every Spring write lands in its own doc at lessonKey paths; lessonData untouched', async ({ page }) => {
+    await SM.stageMoved({ verified: true });
+    await openApp(page);
+    await page.waitForFunction(() => storageMigrationState?.['spring-2026']?.verified === true);
+    const before = await SM.readCurriculumDoc('lessonData');
+
+    expect(await call(page, ({ LESSON }) => saveSingleLesson('spring-2026', LESSON, { shortDetails: 'Saved to own doc' }), { LESSON })).toBe('ok');
+    expect(await call(page, ({ LESSON }) => saveMultipleLessonFields('spring-2026', [{ lessonKey: LESSON, lessonData: { processStep1: 'Step' } }]), { LESSON })).toBe('ok');
+    const own = await SM.readCurriculumDoc(SM.SPRING_DOC);
+    expect(own[LESSON].shortDetails).toBe('Saved to own doc');
+    expect(own[LESSON].processStep1).toBe('Step');
+    expect(own[LESSON].teacher).toBe(SM.springFixture()[LESSON].teacher);   // a per-field write, not a replace
+
+    const readBack = await page.evaluate(({ LESSON }) => readAdminLessonDoc('spring-2026', LESSON, { source: 'server' }), { LESSON });
+    expect(readBack.shortDetails).toBe('Saved to own doc');
+
+    const other = fixtureKeys().find(k => k !== LESSON);
+    expect(await call(page, ({ other }) => deleteLessonKey('spring-2026', other), { other })).toBe('ok');
+    expect((await SM.readCurriculumDoc(SM.SPRING_DOC))[other]).toBeUndefined();
+
+    const after = await SM.readCurriculumDoc('lessonData');
+    expect(after['spring-2026']).toBeUndefined();
+    expect(after).toEqual(before);
+  });
+
+  test('the move happening while a tab is open: Spring switches to its own doc and is never blank', async ({ page }) => {
+    await openApp(page);
+    expect(await source(page)).toBe('legacy');
+    await watchMinSpring(page);
+    await SM.stageMoved({ verified: true });
+    await page.waitForFunction(() => ownDocSource['spring-2026'] === 'ownDoc', null, { timeout: 15_000 });
+    await page.waitForTimeout(500);
+    expect(await minSpring(page)).toBe(fixtureKeys().length);
+    expect(await springKeys(page)).toEqual(fixtureKeys());
+    expect(await page.locator('#storage-notice-banner:not(.hidden)').count()).toBe(0);
+  });
+
+  test('a later lessonData snapshot (another semester saved) does not blank Spring', async ({ page }) => {
+    await SM.stageMoved({ verified: true });
+    await openApp(page);
+    await watchMinSpring(page);
+    await SM.writeCurriculumDoc('lessonData', { 'e2e-bump': { x: { teacher: 'T' } } }, { merge: true });
+    await page.waitForFunction(() => !!currentLessonData?.['e2e-bump'], null, { timeout: 15_000 });
+    await page.waitForTimeout(300);
+    expect(await minSpring(page)).toBe(fixtureKeys().length);
+    expect(await springKeys(page)).toEqual(fixtureKeys());
+  });
+
+  test('a rollback (own doc removed, Spring back in lessonData) falls back without blanking', async ({ page }) => {
+    await SM.stageMoved({ verified: false });
+    await openApp(page);
+    expect(await source(page)).toBe('ownDoc');
+    await watchMinSpring(page);
+    await SM.writeCurriculumDoc('lessonData', { 'spring-2026': SM.springFixture() }, { merge: true });
+    await SM.deleteCurriculumDoc(SM.SPRING_DOC);
+    await page.waitForFunction(() => ownDocSource['spring-2026'] === 'legacy', null, { timeout: 15_000 });
+    await page.waitForTimeout(500);
+    expect(await minSpring(page)).toBe(fixtureKeys().length);
+    expect(await springKeys(page)).toEqual(fixtureKeys());
+  });
+
+  test('deleting Spring 2026 is refused while its storage is changing', async ({ page }) => {
+    await openApp(page);
+    const alerts = [];
+    page.on('dialog', d => { alerts.push(d.message()); d.dismiss(); });
+    const before = await SM.readCurriculumDoc('appData');
+    await page.evaluate(() => deleteSemester('spring-2026'));
+    expect(alerts.join('\n')).toMatch(/can't be deleted while its storage is being changed/);
+    expect((await SM.readCurriculumDoc('appData')).semesters['spring-2026']).toEqual(before.semesters['spring-2026']);
+  });
+
+  test('content counts: one source per semester — the same before and after the move', async ({ page }) => {
+    await openApp(page);
+    const legacyCounts = await page.evaluate(() => computeLiveContentCountByTeacher());
+    await SM.stageMoved({ verified: true });
+    const movedCounts = await page.evaluate(() => computeLiveContentCountByTeacher());
+    expect(movedCounts).toEqual(legacyCounts);
+  });
+
+  test('Lesson Storage readout shows an approximate size of 1,024 KB', async ({ page }) => {
+    await openApp(page);
+    await page.evaluate(() => { document.getElementById('ca-lesson-storage-content').style.display = 'none'; toggleLessonStorage(); });
+    await expect(page.locator('#ca-lesson-storage-content')).toContainText(/approx\. \d+ KB of 1,024 KB \(\d+%\)/);
+    await expect(page.locator('#ca-lesson-storage-content')).toContainText('spring-2026: still in the shared document');
+    const kb = await page.evaluate(() => approxLessonDataSizeKB());
+    expect(kb).toBeGreaterThan(0);
+    expect(kb).toBeLessThan(1024);
+  });
+
+  test('ratchet: every curriculum/lessonData access is in an allowed function; every weekly writer routes through weeklyLessonTarget', () => {
+    const html = fs.readFileSync(path.join(__dirname, '..', 'index.html'), 'utf8');
+    const scripts = [...html.matchAll(/<script[^>]+src="(js\/[^"]+)"/g)].map(m => m[1]);
+    const ALLOWED = new Set([
+      'weeklyLessonTarget',          // the routing helper itself (legacy branch)
+      'readWeeklySemesterMap',       // reads, routed
+      'loadLessonData',              // the legacy load
+      'saveLessonData',              // legacy branch; own-doc semesters route above it
+      'deleteLessonData',            // refuses own-doc semesters first
+      'setupLessonDataListener',     // the legacy listener
+      'computeLiveContentCountByTeacher', // counts, one source per semester
+    ]);
+    const offenders = [];
+    const bodies = {};
+    for (const file of scripts) {
+      const lines = fs.readFileSync(path.join(__dirname, '..', file), 'utf8').split('\n');
+      let current = null;
+      lines.forEach((line, i) => {
+        const m = line.match(/^(?:async\s+)?function\s+([A-Za-z0-9_$]+)\s*\(/);
+        if (m) current = m[1];
+        if (current) bodies[current] = (bodies[current] || '') + line + '\n';
+        if (/doc\(\s*['"]lessonData['"]\s*\)/.test(line) && !ALLOWED.has(current)) offenders.push(`${file}:${i + 1} in ${current}`);
+      });
+    }
+    expect(offenders, `curriculum/lessonData touched outside the allowed functions:\n${offenders.join('\n')}`).toEqual([]);
+    for (const fn of ['saveSingleLesson', 'saveMultipleLessonFields', 'deleteLessonKey', 'sendTeacherQaMessage', 'sendHelpResponse', 'sendQaReply']) {
+      expect(bodies[fn], `${fn} not found`).toBeTruthy();
+      expect(bodies[fn], `${fn} must route through weeklyLessonTarget`).toMatch(/weeklyLessonTarget\(/);
+    }
+    expect(bodies.saveLessonData).toMatch(/isOwnDocSemester\(semesterKey\)[\s\S]*weeklyLessonTarget\(/);
+    expect(bodies.deleteLessonData).toMatch(/isOwnDocSemester\(semesterKey\)/);
+  });
+});
diff --git a/index.html b/index.html
index b99d2d5..9c50106 100644
--- a/index.html
+++ b/index.html
@@ -351,6 +351,15 @@
         <div class="ca-section-content" id="ca-content-count-content" style="display:none"></div>
       </section>
 
+      <!-- Lesson storage headroom (Spring 2026 storage move, Phase B) -->
+      <section class="ca-section ca-lesson-storage-section">
+        <button class="ca-section-toggle" id="ca-lesson-storage-toggle" onclick="toggleLessonStorage()">
+          <span>Lesson Storage</span>
+          <span class="ca-toggle-arrow">&#9660;</span>
+        </button>
+        <div class="ca-section-content" id="ca-lesson-storage-content" style="display:none"></div>
+      </section>
+
       <!-- Backup Health (Data Safety Plan Stage 4B) -->
       <section class="ca-section ca-backup-health-section">
         <button class="ca-section-toggle" id="ca-backup-health-toggle" onclick="toggleBackupHealth()">
diff --git a/js/app.js b/js/app.js
index ca92b37..f2a48a3 100644
--- a/js/app.js
+++ b/js/app.js
@@ -3728,18 +3728,25 @@ async function sendTeacherQaMessage(lessonKey, modalSemKey) {
   const editedAt = new Date().toISOString();
   const editedBy = user?.name || 'Unknown';
 
+  let target;
+  try {
+    target = weeklyLessonTarget(semKey);   // own-doc semester: its own doc, or "editing is paused"
+  } catch (err) {
+    alert(err.message);
+    return;
+  }
+  const p = `${target.prefix}${lessonKey}`;
   const updates = {
-    [`${semKey}.${lessonKey}.qaThread`]: firebase.firestore.FieldValue.arrayUnion(...entriesToAdd),
-    [`${semKey}.${lessonKey}.lastEditedBy`]: editedBy,
-    [`${semKey}.${lessonKey}.lastEditedAt`]: editedAt,
+    [`${p}.qaThread`]: firebase.firestore.FieldValue.arrayUnion(...entriesToAdd),
+    [`${p}.lastEditedBy`]: editedBy,
+    [`${p}.lastEditedAt`]: editedAt,
   };
   // Legacy mirror fields, kept for compatibility with older readers.
   const legacyField = isAdmin ? 'adminResponse' : 'teacherNotes';
-  updates[`${semKey}.${lessonKey}.${legacyField}`] = message;
+  updates[`${p}.${legacyField}`] = message;
 
   try {
-    if (!curriculumDb) initCurriculumFirestore();
-    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
+    await target.ref.update(updates);
   } catch (err) {
     console.error('Error sending Q&A message:', err);
     alert('Error sending message: ' + err.message);
@@ -4579,6 +4586,12 @@ function renderSemesterSelector() {
 async function deleteSemester(key) {
   const sem = currentConfig?.semesters?.[key];
   if (!sem) return;
+  // Spring 2026 storage move: deleting an own-doc semester is disabled until the
+  // follow-up plan routes it (its lessons may live in their own document).
+  if (isOwnDocSemester(key)) {
+    alert(`"${sem.name}" can't be deleted while its storage is being changed.`);
+    return;
+  }
   if (key === currentConfig.activeSemester) {
     alert('Cannot delete the active semester.');
     return;
@@ -5884,8 +5897,8 @@ function cancelGridAction() {
 async function readAdminLessonDoc(semKey, lessonKey, opts = {}) {
   if (!curriculumDb) initCurriculumFirestore();
   const getOpts = opts.source === 'server' ? { source: 'server' } : undefined;
-  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
-  return snap.exists ? (snap.data()?.[semKey]?.[lessonKey] || null) : null;
+  const map = await readWeeklySemesterMap(semKey, getOpts);   // own-doc semesters read their own document
+  return map?.[lessonKey] || null;
 }
 
 // Backtracking audit, Phase 8: shared by cutProject() below and Phase 11's
@@ -7236,6 +7249,10 @@ async function sendHelpResponse(key) {
   if (!curriculumDb) initCurriculumFirestore();
   const isSummer = lessonStore === 'camp';
   const updates = {};
+  let weekly = null;
+  if (!isSummer) {
+    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
+  }
   if (isSummer) {
     updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
     updates.adminResponse = response;
@@ -7243,15 +7260,15 @@ async function sendHelpResponse(key) {
     updates.lastUpdated = new Date().toISOString();
     updates.lastUpdatedBy = user?.name || 'Unknown';
   } else {
-    updates[`${semKey}.${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
-    updates[`${semKey}.${key}.adminResponse`] = response;
-    updates[`${semKey}.${key}.status`] = 'In Progress';
+    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
+    updates[`${weekly.prefix}${key}.adminResponse`] = response;
+    updates[`${weekly.prefix}${key}.status`] = 'In Progress';
     updates.lastUpdated = new Date().toISOString();
     updates.lastUpdatedBy = user?.name || 'Unknown';
   }
   const docRef = isSummer
     ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
-    : curriculumDb.collection('curriculum').doc('lessonData');
+    : weekly.ref;
 
   try {
     await docRef.update(updates);
@@ -7321,20 +7338,24 @@ async function sendQaReply(key) {
   if (!curriculumDb) initCurriculumFirestore();
   const isSummer = lessonStore === 'camp';
   const updates = {};
+  let weekly = null;
+  if (!isSummer) {
+    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
+  }
   if (isSummer) {
     updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
     updates.adminResponse = message;
     updates.lastUpdated = new Date().toISOString();
     updates.lastUpdatedBy = user?.name || 'Unknown';
   } else {
-    updates[`${semKey}.${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
-    updates[`${semKey}.${key}.adminResponse`] = message;
+    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
+    updates[`${weekly.prefix}${key}.adminResponse`] = message;
     updates.lastUpdated = new Date().toISOString();
     updates.lastUpdatedBy = user?.name || 'Unknown';
   }
   const docRef = isSummer
     ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
-    : curriculumDb.collection('curriculum').doc('lessonData');
+    : weekly.ref;
 
   try {
     await docRef.update(updates);
@@ -7569,7 +7590,17 @@ async function computeLiveContentCountByTeacher() {
 
   const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
   const lessonDataDoc = lessonDataSnap.exists ? lessonDataSnap.data() : {};
-  for (const semesterLessons of Object.values(lessonDataDoc)) {
+  // One source per semester (Spring 2026 storage move): an own-doc semester is
+  // counted from its own document when that exists, and then skipped here.
+  const countedFromOwnDoc = new Set();
+  for (const semKey of OWN_DOC_SEMESTERS) {
+    const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get();
+    if (!own.exists) continue;
+    countedFromOwnDoc.add(semKey);
+    for (const lesson of Object.values(ownDocLessonMap(own.data()))) if (lesson && typeof lesson === 'object') tally(lesson);
+  }
+  for (const [semKey, semesterLessons] of Object.entries(lessonDataDoc)) {
+    if (countedFromOwnDoc.has(semKey)) continue;
     if (!semesterLessons || typeof semesterLessons !== 'object') continue;
     for (const lesson of Object.values(semesterLessons)) tally(lesson);
   }
@@ -7651,6 +7682,27 @@ async function renderContentCount() {
   }
 }
 
+// Lesson storage headroom (Spring 2026 storage move, Phase B): curriculum/lessonData
+// holds every weekly semester in one document under Firestore's 1 MiB cap. The
+// size is an estimate from the last snapshot this page received — no extra read.
+function renderLessonStorage() {
+  const container = document.getElementById('ca-lesson-storage-content');
+  if (!container) return;
+  const kb = approxLessonDataSizeKB();
+  if (kb === null) { container.innerHTML = '<p class="ca-empty-hint">Lesson storage size isn\'t available yet — reload the page.</p>'; return; }
+  const pct = Math.round((kb / 1024) * 100);
+  const warn = pct > 85;
+  container.innerHTML = `<p class="${warn ? 'ca-backup-flag' : 'ca-empty-hint'}">${warn ? '⚠️ ' : ''}Lesson storage: approx. ${kb} KB of 1,024 KB (${pct}%)${warn ? ' — nearly full. When it fills, lesson saves stop working; tell Christie.' : ''}</p>`
+    + `<p class="ca-empty-hint">All Fall/Spring semesters still stored in the shared document. ${OWN_DOC_SEMESTERS.map(k => `${escHtml(k)}: ${ownDocSource[k] === 'ownDoc' ? 'in its own document' : ownDocSource[k] === 'error' ? 'couldn\'t be checked' : 'still in the shared document'}`).join(' · ')}</p>`;
+}
+
+function toggleLessonStorage() {
+  const content = document.getElementById('ca-lesson-storage-content');
+  const wasHidden = content.style.display === 'none';
+  content.style.display = wasHidden ? 'block' : 'none';
+  if (wasHidden) renderLessonStorage();
+}
+
 function toggleContentCount() {
   const content = document.getElementById('ca-content-count-content');
   const wasHidden = content.style.display === 'none';
diff --git a/js/firebase-data.js b/js/firebase-data.js
index c562679..5afb04d 100644
--- a/js/firebase-data.js
+++ b/js/firebase-data.js
@@ -12,6 +12,7 @@ let curriculumDb = null;
 let configUnsubscribe = null;
 let prepDataUnsubscribe = null;
 let lessonDataUnsubscribe = null;
+let ownDocUnsubscribes = [];   // own-doc semester + storageMigrations listeners (Spring 2026 storage move)
 
 // The content fields a lesson's stripping/hasContent/wipe-detection logic
 // treats as "real plan content" (as opposed to metadata like teacher/weekNum).
@@ -71,6 +72,106 @@ function lessonStoreFor(semKey) {
   }
 }
 
+// ─── Own-document weekly semesters (Spring 2026 storage move, Sep 2026) ──────
+// curriculum/lessonData holds every weekly semester in ONE Firestore document,
+// and it reached 95% of the 1 MiB document cap (Sep 29 2026). A finished weekly
+// semester moves to its own document, curriculum/lessons_<semKey>, in one manager
+// transaction. Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html
+// (Phase B). The studio-hub rules (Phase A, deployed 0caf415) fence the key in
+// lessonData, and allow edits to the new document only once
+// curriculum/storageMigrations says the move is verified.
+//
+// Changed only by a code deploy, just as the rules fence changes only by a rules deploy.
+const OWN_DOC_SEMESTERS = ['spring-2026'];
+const OWN_DOC_PAUSED_MESSAGE = 'Spring 2026 is being moved to new storage — editing it is paused for a few days. Viewing works as normal.';
+
+function isOwnDocSemester(semKey) { return OWN_DOC_SEMESTERS.includes(semKey); }
+function ownDocIdFor(semKey) { return `lessons_${semKey}`; }
+
+// Where each own-doc semester's lessons are served from right now:
+// 'legacy' (still inside lessonData), 'ownDoc' (its own document), or 'error'
+// (its document couldn't be read — shown from whatever we have, never writable).
+const ownDocSource = {};
+// curriculum/storageMigrations as last read ({} when absent; null = not yet known).
+let storageMigrationState = null;
+// The last legacy lessonData snapshot, so a rollback (own doc disappears) can fall
+// back to it, and the headroom readout can size it without another read.
+let lastLegacyLessonData = null;
+
+function ownDocMoveVerified(semKey) {
+  return storageMigrationState?.[semKey]?.verified === true;
+}
+function ownDocLessonMap(data) {
+  const map = { ...(data || {}) };
+  delete map.lastUpdated;
+  delete map.lastUpdatedBy;
+  return map;
+}
+
+// The ONE place a weekly lesson write learns where to go. Returns the document
+// and the dotted-path prefix for a lesson inside it:
+//   legacy semester → curriculum/lessonData, '<semKey>.'
+//   own-doc semester → curriculum/lessons_<semKey>, '' — only once the move is
+//                      verified; before that it throws the "editing is paused" message
+//                      (the rules refuse those writes anyway).
+function weeklyLessonTarget(semKey) {
+  if (!curriculumDb) initCurriculumFirestore();
+  if (!isOwnDocSemester(semKey)) {
+    return { ref: curriculumDb.collection('curriculum').doc('lessonData'), prefix: `${semKey}.` };
+  }
+  if (ownDocSource[semKey] !== 'ownDoc' || !ownDocMoveVerified(semKey)) {
+    throw new Error(OWN_DOC_PAUSED_MESSAGE);
+  }
+  return { ref: curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)), prefix: '' };
+}
+
+// Forced-server (or cache-permitting) read of one weekly semester's lesson map,
+// wherever it lives. An own-doc semester is read from its own document when that
+// exists, otherwise from lessonData — independent of this tab's in-memory state.
+async function readWeeklySemesterMap(semKey, getOpts) {
+  if (!curriculumDb) initCurriculumFirestore();
+  if (isOwnDocSemester(semKey)) {
+    const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get(getOpts);
+    if (own.exists) return ownDocLessonMap(own.data());
+  }
+  const legacy = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
+  return legacy.exists ? (legacy.data()?.[semKey] ?? null) : null;
+}
+
+// Approximate Firestore size of a value in bytes — the documented storage-size
+// rules (string = UTF-8 bytes + 1, number 8, boolean 1, null 1, map = sum of
+// key + value). Used for the headroom readout; the SDK doesn't expose the real size.
+function approxFirestoreSize(v) {
+  const str = (x) => new TextEncoder().encode(x).length + 1;
+  if (v === null || v === undefined) return 1;
+  if (typeof v === 'string') return str(v);
+  if (typeof v === 'number') return 8;
+  if (typeof v === 'boolean') return 1;
+  if (v && typeof v.toDate === 'function') return 8;
+  if (Array.isArray(v)) return v.reduce((t, x) => t + approxFirestoreSize(x), 0);
+  if (typeof v === 'object') return Object.entries(v).reduce((t, [k, x]) => t + str(k) + approxFirestoreSize(x), 0);
+  return 8;
+}
+function approxLessonDataSizeKB() {
+  if (!lastLegacyLessonData) return null;
+  const docName = 'projects/tinker-hq-apps/databases/(default)/documents/curriculum/lessonData';
+  return Math.round((approxFirestoreSize(lastLegacyLessonData) + new TextEncoder().encode(docName).length + 1 + 32) / 1024);
+}
+
+function showStorageNotice(message) {
+  let el = document.getElementById('storage-notice-banner');
+  if (!el) {
+    el = document.createElement('div');
+    el.id = 'storage-notice-banner';
+    el.className = 'lesson-load-error-banner';
+    const anchorEl = document.getElementById('lesson-load-error-banner');
+    if (anchorEl?.parentNode) anchorEl.parentNode.insertBefore(el, anchorEl.nextSibling);
+    else document.body.prepend(el);
+  }
+  el.textContent = message;
+  el.classList.remove('hidden');
+}
+
 // ─── Summer document IDs (camp seasons Phase 1, 1.5) ─────────────────────────
 // The cross-app contract, shared with the Summer Camp App: 2026 documents keep
 // every existing ID unchanged; any other season prefixes the ENTIRE legacy ID
@@ -756,11 +857,63 @@ async function loadOneCampSeason(plan, opts = {}) {
   return await loadSummerCampData({ ...opts, season: plan.season, semKey: plan.semKey });
 }
 
+// Initial load for own-doc semesters and the migration record (called by
+// loadLessonData, after the legacy document). A failed read of the record is
+// treated as "not verified" (edits stay paused); a failed read of a semester's own
+// document marks it 'error' — shown from whatever lessonData still holds, never
+// writable, with a visible notice.
+async function loadOwnDocSemesters() {
+  if (!curriculumDb) initCurriculumFirestore();
+  try {
+    const m = await curriculumDb.collection('curriculum').doc('storageMigrations').get();
+    storageMigrationState = m.exists ? (m.data() || {}) : {};
+  } catch (err) {
+    console.warn('⚠️ Could not read curriculum/storageMigrations — own-doc semesters stay read-only:', err);
+    storageMigrationState = {};
+  }
+  for (const semKey of OWN_DOC_SEMESTERS) {
+    try {
+      const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get();
+      if (own.exists) {
+        ownDocSource[semKey] = 'ownDoc';
+        currentLessonData[semKey] = ownDocLessonMap(own.data());
+      } else {
+        ownDocSource[semKey] = 'legacy';
+      }
+    } catch (err) {
+      console.error(`❌ Could not read curriculum/${ownDocIdFor(semKey)}:`, err);
+      ownDocSource[semKey] = 'error';
+      showStorageNotice(`⚠️ ${semKey} lessons couldn't be loaded from their new storage — please reload the page.`);
+    }
+  }
+}
+
+// The legacy snapshot no longer holds an own-doc semester this tab was showing
+// from lessonData: the move just happened (or the page is stale). Never blank it —
+// keep the lessons on screen, look for its own document, and if that isn't there
+// either, say so.
+async function recheckOwnDocAfterLegacyLoss(semKey, callback) {
+  try {
+    const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get({ source: 'server' });
+    if (own.exists) {
+      ownDocSource[semKey] = 'ownDoc';
+      currentLessonData[semKey] = ownDocLessonMap(own.data());
+      if (callback) callback(currentLessonData);
+      return;
+    }
+  } catch (err) {
+    console.warn(`⚠️ Could not check curriculum/${ownDocIdFor(semKey)}:`, err);
+  }
+  showStorageNotice(`⚠️ ${semKey} moved to new storage — please reload the page to see its latest lessons.`);
+}
+
 async function loadLessonData() {
   if (!curriculumDb) initCurriculumFirestore();
   try {
     const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
     currentLessonData = doc.exists ? doc.data() : {};
+    lastLegacyLessonData = doc.exists ? doc.data() : {};
+    await loadOwnDocSemesters();
 
     // Every camp season gets its own map (Phase 1, 1.4) — no literal key.
     try {
@@ -812,12 +965,18 @@ async function saveLessonData(semesterKey, lessons) {
     return await saveSummerCampLessonData(semesterKey, lessons);
   }
 
-  // Regular semester: save to curriculum/lessonData
+  // Regular semester: save to curriculum/lessonData — or, for an own-doc
+  // semester, to its own document (the whole map at the top level).
   const user = getAuthUser();
+  const stamp = { lastUpdated: new Date().toISOString(), lastUpdatedBy: user?.name || 'Unknown' };
+  if (isOwnDocSemester(semesterKey)) {
+    const { ref } = weeklyLessonTarget(semesterKey);   // throws "editing is paused" until verified
+    await ref.set({ ...lessons, ...stamp }, { merge: true });
+    return;
+  }
   await curriculumDb.collection('curriculum').doc('lessonData').set({
     [semesterKey]: lessons,
-    lastUpdated: new Date().toISOString(),
-    lastUpdatedBy: user?.name || 'Unknown'
+    ...stamp
   }, { merge: true });
 }
 
@@ -827,8 +986,9 @@ async function saveLessonData(semesterKey, lessons) {
 async function deleteLessonKey(semesterKey, lessonKey) {
   if (!curriculumDb) initCurriculumFirestore();
   const user = getAuthUser();
-  await curriculumDb.collection('curriculum').doc('lessonData').update({
-    [`${semesterKey}.${lessonKey}`]: firebase.firestore.FieldValue.delete(),
+  const { ref, prefix } = weeklyLessonTarget(semesterKey);
+  await ref.update({
+    [`${prefix}${lessonKey}`]: firebase.firestore.FieldValue.delete(),
     lastUpdated: new Date().toISOString(),
     lastUpdatedBy: user?.name || 'Unknown'
   });
@@ -960,6 +1120,9 @@ async function sendSummerLessonQaMessage(semKey, lessonKey, lesson, newMsg) {
 
 async function deleteLessonData(semesterKey) {
   if (!curriculumDb) initCurriculumFirestore();
+  // An own-doc semester's lessons aren't in lessonData (and the rules fence the
+  // key); deleting it is disabled until the follow-up plan routes it.
+  if (isOwnDocSemester(semesterKey)) throw new Error(`"${semesterKey}" can't be deleted while its storage is being changed.`);
   await curriculumDb.collection('curriculum').doc('lessonData').update({
     [semesterKey]: firebase.firestore.FieldValue.delete()
   });
@@ -972,8 +1135,7 @@ async function deleteLessonData(semesterKey) {
 // when its server-side delete failed). Backtracking audit, Phase 11.
 async function readServerSemesterLessonMap(semesterKey) {
   if (!curriculumDb) initCurriculumFirestore();
-  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
-  return snap.exists ? (snap.data()?.[semesterKey] ?? null) : null;
+  return await readWeeklySemesterMap(semesterKey, { source: 'server' });
 }
 
 async function backupLessonData(semesterKey) {
@@ -1114,6 +1276,8 @@ function setupLessonDataListener(callback) {
   if (!curriculumDb) initCurriculumFirestore();
   globalListenerGeneration++; // whatever the previous listener still has in flight is now stale
   if (lessonDataUnsubscribe) lessonDataUnsubscribe();
+  // The own-doc listeners (Spring 2026 storage move) are torn down together.
+  while (ownDocUnsubscribes.length) { try { ownDocUnsubscribes.pop()(); } catch (e) { /* already gone */ } }
 
   // One reload attempt for one snapshot generation. Only the latest
   // generation may touch the guard, the banner, or the summer cache.
@@ -1183,8 +1347,24 @@ function setupLessonDataListener(callback) {
       // in their own collection, so carry their current maps across the swap
       // and let the reload below refresh each one (Phase 1, 1.4).
       const previousSummer = snapshotCampSeasons();
+      // Own-doc semesters (Spring 2026 storage move): their lessons aren't in this
+      // document once moved, so carry them across the swap like the camp seasons —
+      // their own listeners below keep them current.
+      const previousOwn = {};
+      for (const semKey of OWN_DOC_SEMESTERS) if (currentLessonData?.[semKey]) previousOwn[semKey] = currentLessonData[semKey];
       currentLessonData = doc.data();
+      lastLegacyLessonData = doc.data();
       for (const [semKey, map] of Object.entries(previousSummer)) currentLessonData[semKey] = map;
+      for (const semKey of OWN_DOC_SEMESTERS) {
+        if (ownDocSource[semKey] === 'ownDoc' || ownDocSource[semKey] === 'error') {
+          if (previousOwn[semKey]) currentLessonData[semKey] = previousOwn[semKey];
+        } else if (!(semKey in currentLessonData) && previousOwn[semKey]) {
+          currentLessonData[semKey] = previousOwn[semKey];   // never blank it
+          recheckOwnDocAfterLegacyLoss(semKey, callback);
+        } else if (semKey in currentLessonData) {
+          document.getElementById('storage-notice-banner')?.classList.add('hidden');
+        }
+      }
       console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
 
       const outcome = await reloadSummer(myGeneration, previousSummer, 0);
@@ -1193,6 +1373,42 @@ function setupLessonDataListener(callback) {
       // one still renders: the non-summer semesters in this snapshot are new.
       if (outcome !== 'stale' && callback) callback(currentLessonData);
     });
+
+  // Own-doc semesters: one listener per document, plus the migration record.
+  // They never bump globalListenerGeneration and never touch
+  // lessonDataLoadedSuccessfully — an error here is shown on its own and makes
+  // only that semester unwritable.
+  ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc('storageMigrations')
+    .onSnapshot(snap => {
+      if (snap.metadata.fromCache && !snap.metadata.hasPendingWrites) return;
+      storageMigrationState = snap.exists ? (snap.data() || {}) : {};
+    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; }));
+  for (const semKey of OWN_DOC_SEMESTERS) {
+    ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey))
+      .onSnapshot({ includeMetadataChanges: false }, snap => {
+        if (snap.metadata.fromCache && !snap.metadata.hasPendingWrites) return;
+        if (snap.exists) {
+          ownDocSource[semKey] = 'ownDoc';
+          currentLessonData = currentLessonData || {};
+          currentLessonData[semKey] = ownDocLessonMap(snap.data());
+          document.getElementById('storage-notice-banner')?.classList.add('hidden');
+        } else if (ownDocSource[semKey] === 'ownDoc') {
+          // Rolled back: the own document is gone — fall back to lessonData.
+          ownDocSource[semKey] = 'legacy';
+          const legacyMap = lastLegacyLessonData?.[semKey];
+          if (legacyMap) currentLessonData[semKey] = legacyMap;
+          else showStorageNotice(`⚠️ ${semKey} storage changed — please reload the page to see its lessons.`);
+        } else {
+          if (ownDocSource[semKey] !== 'error') ownDocSource[semKey] = 'legacy';
+          return;   // nothing changed for this tab
+        }
+        if (callback) callback(currentLessonData);
+      }, err => {
+        console.error(`❌ ${ownDocIdFor(semKey)} listener error:`, err);
+        ownDocSource[semKey] = 'error';
+        showStorageNotice(`⚠️ ${semKey} lessons couldn't be loaded from their new storage — please reload the page.`);
+      }));
+  }
 }
 
 // ─── Cut Projects (curriculum/cutProjects) ───────────
@@ -1431,11 +1647,12 @@ async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClea
   // semesterKey.lessonKey path replaces the ENTIRE lesson there — so write
   // explicit per-field dotted paths instead, touching only the fields
   // actually present in lessonData (Data Safety Plan Stage 2D).
-  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear);
+  const { ref: weeklyRef, prefix } = weeklyLessonTarget(semesterKey);   // own-doc semester: its own doc (or "editing is paused")
+  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear, prefix);
 
-  console.log('💾 Saving to curriculum/lessonData with per-field paths:', Object.keys(updates));
+  console.log(`💾 Saving to curriculum/${weeklyRef.id} with per-field paths:`, Object.keys(updates));
   try {
-    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
+    await weeklyRef.update(updates);
     console.log('✅ Successfully saved lesson to Firestore!');
   } catch (error) {
     console.error('❌ Error saving lesson:', error);
@@ -1452,7 +1669,7 @@ async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClea
 // omitting their dotted path entirely — never sending an explicit empty
 // string — and applies clears AFTER the JSON sanitization pass, since
 // FieldValue.delete() is a special sentinel a JSON round-trip would corrupt.
-function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = []) {
+function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = [], prefix = `${semesterKey}.`) {
   // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above saveSingleLesson().
   const stripped = { ...lessonData };
   CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
@@ -1460,7 +1677,7 @@ function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToCle
   fieldsToClear.forEach(f => { cleanData[f] = firebase.firestore.FieldValue.delete(); });
   const updates = {};
   for (const [field, value] of Object.entries(cleanData)) {
-    updates[`${semesterKey}.${lessonKey}.${field}`] = value;
+    updates[`${prefix}${lessonKey}.${field}`] = value;
   }
   return updates;
 }
@@ -1485,19 +1702,20 @@ async function saveMultipleLessonFields(semesterKey, writes = [], deletes = [])
     throw new Error('saveMultipleLessonFields() does not support camp seasons — use saveSingleLesson() per lesson instead.');
   }
   if (!curriculumDb) initCurriculumFirestore();
+  const { ref: weeklyRef, prefix } = weeklyLessonTarget(semesterKey);
   const user = getAuthUser();
   const combined = {};
   for (const { lessonKey, lessonData, fieldsToClear } of writes) {
     lessonData.lastEditedBy = user?.name || 'Unknown';
     lessonData.lastEditedAt = new Date().toISOString();
-    Object.assign(combined, buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear || []));
+    Object.assign(combined, buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear || [], prefix));
   }
   for (const lessonKey of deletes) {
-    combined[`${semesterKey}.${lessonKey}`] = firebase.firestore.FieldValue.delete();
+    combined[`${prefix}${lessonKey}`] = firebase.firestore.FieldValue.delete();
   }
   combined.lastUpdated = new Date().toISOString();
   combined.lastUpdatedBy = user?.name || 'Unknown';
-  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
+  await weeklyRef.update(combined);
 }
 
 // ─── Photo Upload (Firebase Storage) ─────────────────
diff --git a/classbook-qa-alerts.test.js b/classbook-qa-alerts.test.js
new file mode 100644
index 0000000..85413a1
--- /dev/null
+++ b/classbook-qa-alerts.test.js
@@ -0,0 +1,57 @@
+/**
+ * Pure-function tests for js/classbook-qa-alerts.js — no Firestore, no DOM.
+ * Run: npm test
+ */
+const { buildClassbookQaAlerts } = require('./js/classbook-qa-alerts.js');
+
+const NOW = Date.parse('2026-09-30T12:00:00Z');
+const asked = (hoursAgo, extra = {}) => ({
+  teacher: 'Mariah', className: 'Clay', weekNum: 3,
+  qaThread: [{ from: 'teacher', message: 'Glaze?', timestamp: new Date(NOW - hoursAgo * 3600e3).toISOString() }],
+  ...extra,
+});
+const answered = () => ({ teacher: 'Kathy', qaThread: [{ from: 'teacher', message: 'Q' }, { from: 'admin', message: 'A' }] });
+
+describe('buildClassbookQaAlerts', () => {
+  test('one alert per unanswered question, id qualified by semester, legacy id kept', () => {
+    const out = buildClassbookQaAlerts({ lessonData: { 'fall-2026': { 'mariah-tue-1': asked(2), 'kathy-mon-1': answered() }, lastUpdated: 'x' }, ownDocs: {} }, NOW);
+    expect(out.map(a => a.id)).toEqual(['classbook-qa-fall-2026-mariah-tue-1']);
+    expect(out[0].legacyId).toBe('classbook-qa-mariah-tue-1');
+    expect(out[0].metadata).toEqual({ lessonKey: 'mariah-tue-1', semKey: 'fall-2026' });
+    expect(out[0].priority).toBe('info');
+  });
+
+  test('the same lesson key in two semesters gives two alerts (no collision)', () => {
+    const out = buildClassbookQaAlerts({
+      lessonData: { 'fall-2026': { 'k-1': asked(1) } },
+      ownDocs: { 'spring-2026': { 'k-1': asked(30), lastUpdated: 'x' } },
+    }, NOW);
+    expect(out.map(a => a.id).sort()).toEqual(['classbook-qa-fall-2026-k-1', 'classbook-qa-spring-2026-k-1']);
+    expect(out.find(a => a.metadata.semKey === 'spring-2026').priority).toBe('warning');
+  });
+
+  test('a semester with its own document is taken from there, never also from lessonData', () => {
+    const out = buildClassbookQaAlerts({
+      lessonData: { 'spring-2026': { 'stale-1': asked(1) }, 'fall-2026': {} },
+      ownDocs: { 'spring-2026': { 'fresh-1': asked(60), lastUpdatedBy: 'x' } },
+    }, NOW);
+    expect(out.map(a => a.id)).toEqual(['classbook-qa-spring-2026-fresh-1']);
+    expect(out[0].priority).toBe('urgent');
+  });
+
+  test('before the move (own doc absent) Spring comes from lessonData', () => {
+    const out = buildClassbookQaAlerts({ lessonData: { 'spring-2026': { 's-1': asked(1) } }, ownDocs: { 'spring-2026': null } }, NOW);
+    expect(out.map(a => a.id)).toEqual(['classbook-qa-spring-2026-s-1']);
+  });
+
+  test('either source missing yields the other alone; malformed entries are skipped', () => {
+    expect(buildClassbookQaAlerts({ lessonData: null, ownDocs: { 'spring-2026': { a: asked(1) } } }, NOW)).toHaveLength(1);
+    expect(buildClassbookQaAlerts({ lessonData: { x: 'not a map', y: { bad: null, empty: { qaThread: [] } } }, ownDocs: {} }, NOW)).toEqual([]);
+  });
+
+  test('unknown timestamp → warning', () => {
+    const out = buildClassbookQaAlerts({ lessonData: { f: { k: { qaThread: [{ from: 'teacher', message: 'Q' }] } } }, ownDocs: {} }, NOW);
+    expect(out[0].priority).toBe('warning');
+    expect(out[0].subtitle).toMatch(/Unknown time/);
+  });
+});
diff --git a/index.html b/index.html
index 567518f..71bcccb 100644
--- a/index.html
+++ b/index.html
@@ -221,6 +221,7 @@
 
   <!-- Scripts -->
   <script src="js/config.js"></script>
+  <script src="js/classbook-qa-alerts.js"></script>
   <script src="js/alerts.js"></script>
   <script src="js/archive-helpers.js"></script>
   <script src="js/app.js"></script>
diff --git a/js/alerts.js b/js/alerts.js
index 74f5b36..f133be3 100644
--- a/js/alerts.js
+++ b/js/alerts.js
@@ -558,93 +558,73 @@ const AlertEngine = (() => {
   // =====================================================
 
   function listenToClassbook(db) {
-    // Teacher questions - ALL unanswered questions (immediate alerts)
-    const classbookListener = db.collection('curriculum')
-      .doc('lessonData')
-      .onSnapshot(doc => {
-        if (!doc.exists) return;
-
-        const data = doc.data();
-        const now = Date.now();
-        let unansweredQuestions = [];
-        const currentClassbookAlertIds = [];
-
-        // Iterate through all semesters
-        for (const [semKey, lessons] of Object.entries(data)) {
-          // Skip metadata fields
-          if (semKey === 'lastUpdated' || semKey === 'lastUpdatedBy') continue;
-          if (!lessons || typeof lessons !== 'object') continue;
-
-          // Iterate through all lessons in this semester
-          for (const [lessonKey, lesson] of Object.entries(lessons)) {
-            if (!lesson.qaThread || !Array.isArray(lesson.qaThread)) continue;
-
-            // Check if last message is from teacher (unanswered)
-            const thread = lesson.qaThread;
-            if (thread.length === 0) continue;
-
-            const lastMsg = thread[thread.length - 1];
-            if (lastMsg.from === 'teacher') {
-              // This is an unanswered question
-              const questionDate = lastMsg.timestamp?.toMillis ? lastMsg.timestamp.toMillis() :
-                                  lastMsg.timestamp ? new Date(lastMsg.timestamp).getTime() : 0;
-
-              const alertId = `classbook-qa-${lessonKey}`;
-              currentClassbookAlertIds.push(alertId);
-
-              // Calculate priority based on age (or use warning if no timestamp)
-              let priority = 'warning';
-              let timeText = 'Unknown time';
-
-              if (questionDate > 0) {
-                const hoursElapsed = Math.floor((now - questionDate) / (1000 * 60 * 60));
-                timeText = `${hoursElapsed}h ago`;
-
-                // Priority based on age: info (0-24h), warning (25-48h), urgent (49h+)
-                if (hoursElapsed >= 49) {
-                  priority = 'urgent';
-                } else if (hoursElapsed >= 25) {
-                  priority = 'warning';
-                } else {
-                  priority = 'info';
-                }
-              }
-
-              const questionText = lastMsg.message || lastMsg.question || 'Question';
-              const teacherName = lesson.teacher || lastMsg.name || 'Teacher';
+    // Teacher questions — ALL unanswered questions (immediate alerts).
+    // Weekly lessons live in curriculum/lessonData AND, for semesters moved to their
+    // own document (Classbook storage move, Sep 2026), in curriculum/lessons_<semKey>.
+    // Each document has its own listener; alerts are rebuilt from the UNION of the
+    // latest snapshot of each (buildClassbookQaAlerts, js/classbook-qa-alerts.js), so
+    // one listener's snapshot never removes the other's alerts.
+    const sources = { lessonData: null, ownDocs: {} };
+    const received = new Set();   // which documents have delivered at least one snapshot
+    const expected = ['lessonData', ...CLASSBOOK_OWN_DOC_SEMESTERS.map(k => `lessons_${k}`)];
+
+    const rebuild = () => {
+      // Don't build (or prune) until every watched document has reported once, so a
+      // semester never flickers out of the alert list while its source is loading.
+      if (!expected.every(id => received.has(id))) return;
+      const unansweredQuestions = buildClassbookQaAlerts(sources, Date.now());
+      const currentClassbookAlertIds = unansweredQuestions.map(a => a.id);
+
+      // A dismissal saved under the pre-Sep-2026 id (classbook-qa-<lessonKey>) still applies.
+      let migratedDismissals = false;
+      unansweredQuestions.forEach(alert => {
+        if (dismissedAlertIds.has(alert.legacyId) && !dismissedAlertIds.has(alert.id)) {
+          dismissedAlertIds.add(alert.id);
+          migratedDismissals = true;
+        }
+      });
+      if (migratedDismissals) saveDismissedAlerts();
 
-              const alert = {
-                id: alertId,
-                type: 'curriculum',
-                priority: priority,
-                title: `${teacherName}: ${questionText.substring(0, 50)}${questionText.length > 50 ? '...' : ''}`,
-                subtitle: `${lesson.className || 'Class'} - Week ${lesson.weekNum || '?'} - ${timeText}`,
-                timestamp: questionDate > 0 ? new Date(questionDate).toISOString() : new Date().toISOString(),
-                actionLabel: 'View Classbook',
-                actionUrl: 'https://tinker-classbook.netlify.app#curriculum-admin',
-                metadata: { lessonKey, semKey }
-              };
-              unansweredQuestions.push(alert);
-            }
-          }
+      // Remove old Classbook alerts that are no longer unanswered
+      alerts.forEach(alert => {
+        if (alert.type === 'curriculum' && !currentClassbookAlertIds.includes(alert.id)) {
+          removeAlert(alert.id);
         }
+      });
 
-        // Remove old Classbook alerts that are no longer unanswered
-        alerts.forEach(alert => {
-          if (alert.type === 'curriculum' && !currentClassbookAlertIds.includes(alert.id)) {
-            removeAlert(alert.id);
-          }
-        });
+      // Update all Q&A alerts
+      unansweredQuestions.forEach(alert => addOrUpdateAlert(alert));
 
-        // Update all Q&A alerts
-        unansweredQuestions.forEach(alert => addOrUpdateAlert(alert));
+      updateUI();
+    };
 
-        updateUI();
+    const classbookListener = db.collection('curriculum')
+      .doc('lessonData')
+      .onSnapshot(doc => {
+        sources.lessonData = doc.exists ? doc.data() : null;
+        received.add('lessonData');
+        rebuild();
       }, error => {
         console.error('Classbook listener error:', error);
       });
-
     listeners.push(classbookListener);
+
+    CLASSBOOK_OWN_DOC_SEMESTERS.forEach(semKey => {
+      const ownDocListener = db.collection('curriculum')
+        .doc(`lessons_${semKey}`)
+        .onSnapshot(doc => {
+          sources.ownDocs[semKey] = doc.exists ? doc.data() : null;
+          received.add(`lessons_${semKey}`);
+          rebuild();
+        }, error => {
+          // Treat an unreadable own document as absent so the rest still alerts.
+          console.error(`Classbook ${semKey} listener error:`, error);
+          sources.ownDocs[semKey] = null;
+          received.add(`lessons_${semKey}`);
+          rebuild();
+        });
+      listeners.push(ownDocListener);
+    });
   }
 
   // =====================================================
diff --git a/js/classbook-qa-alerts.js b/js/classbook-qa-alerts.js
new file mode 100644
index 0000000..586ad18
--- /dev/null
+++ b/js/classbook-qa-alerts.js
@@ -0,0 +1,78 @@
+// Classbook unanswered-question alerts — pure builder (no Firestore, no DOM).
+//
+// Classbook weekly lessons live in two shapes (Sep 2026, Classbook storage move —
+// tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html):
+//   curriculum/lessonData            { <semKey>: { <lessonKey>: lesson }, lastUpdated, … }
+//   curriculum/lessons_<semKey>      { <lessonKey>: lesson, lastUpdated, lastUpdatedBy }
+// Each is watched by its own listener, so the alert set is rebuilt from the union
+// of both — a snapshot from one must never remove the other's alerts. A semester
+// that has its own document is taken from there (its lessonData copy, if any, is
+// ignored). Alert ids carry the semester (the same lesson key exists in every
+// semester); `legacyId` is the pre-Sep-2026 id, so a dismissal saved under it
+// still applies.
+
+const CLASSBOOK_OWN_DOC_SEMESTERS = ['spring-2026'];
+
+function classbookQaAlertsForSemester(semKey, lessons, now) {
+  const out = [];
+  if (!lessons || typeof lessons !== 'object') return out;
+  for (const [lessonKey, lesson] of Object.entries(lessons)) {
+    if (!lesson || typeof lesson !== 'object') continue;
+    const thread = lesson.qaThread;
+    if (!Array.isArray(thread) || thread.length === 0) continue;
+    const lastMsg = thread[thread.length - 1];
+    if (!lastMsg || lastMsg.from !== 'teacher') continue;
+
+    const questionDate = lastMsg.timestamp?.toMillis ? lastMsg.timestamp.toMillis()
+      : lastMsg.timestamp ? new Date(lastMsg.timestamp).getTime() : 0;
+
+    // Priority by age: info (0-24h), warning (25-48h), urgent (49h+); warning if unknown.
+    let priority = 'warning';
+    let timeText = 'Unknown time';
+    if (questionDate > 0) {
+      const hoursElapsed = Math.floor((now - questionDate) / (1000 * 60 * 60));
+      timeText = `${hoursElapsed}h ago`;
+      priority = hoursElapsed >= 49 ? 'urgent' : hoursElapsed >= 25 ? 'warning' : 'info';
+    }
+
+    const questionText = lastMsg.message || lastMsg.question || 'Question';
+    const teacherName = lesson.teacher || lastMsg.name || 'Teacher';
+    out.push({
+      id: `classbook-qa-${semKey}-${lessonKey}`,
+      legacyId: `classbook-qa-${lessonKey}`,
+      type: 'curriculum',
+      priority,
+      title: `${teacherName}: ${questionText.substring(0, 50)}${questionText.length > 50 ? '...' : ''}`,
+      subtitle: `${lesson.className || 'Class'} - Week ${lesson.weekNum || '?'} - ${timeText}`,
+      timestamp: questionDate > 0 ? new Date(questionDate).toISOString() : new Date(now).toISOString(),
+      actionLabel: 'View Classbook',
+      actionUrl: 'https://tinker-classbook.netlify.app#curriculum-admin',
+      metadata: { lessonKey, semKey },
+    });
+  }
+  return out;
+}
+
+// sources: { lessonData: <data | null>, ownDocs: { <semKey>: <data | null> } }
+// (null = that document doesn't exist, or hasn't been received yet).
+function buildClassbookQaAlerts(sources, now) {
+  const ownDocs = sources?.ownDocs || {};
+  const fromOwnDoc = new Set(Object.keys(ownDocs).filter(k => ownDocs[k]));
+  const alerts = [];
+  for (const [semKey, lessons] of Object.entries(sources?.lessonData || {})) {
+    if (semKey === 'lastUpdated' || semKey === 'lastUpdatedBy') continue;
+    if (fromOwnDoc.has(semKey)) continue;
+    alerts.push(...classbookQaAlertsForSemester(semKey, lessons, now));
+  }
+  for (const semKey of fromOwnDoc) {
+    const lessons = { ...ownDocs[semKey] };
+    delete lessons.lastUpdated;
+    delete lessons.lastUpdatedBy;
+    alerts.push(...classbookQaAlertsForSemester(semKey, lessons, now));
+  }
+  return alerts;
+}
+
+if (typeof module !== 'undefined' && module.exports) {
+  module.exports = { CLASSBOOK_OWN_DOC_SEMESTERS, buildClassbookQaAlerts, classbookQaAlertsForSemester };
+}
diff --git a/package.json b/package.json
index 45f1582..b24c72c 100644
--- a/package.json
+++ b/package.json
@@ -1,7 +1,7 @@
 {
   "scripts": {
     "test": "npm run test:rules && npm run test:guard",
-    "test:rules": "firebase emulators:exec --only firestore \"node --experimental-vm-modules node_modules/.bin/jest rules.test.js archive-helpers.test.js archive-transaction.test.js\"",
+    "test:rules": "firebase emulators:exec --only firestore \"node --experimental-vm-modules node_modules/.bin/jest rules.test.js archive-helpers.test.js archive-transaction.test.js classbook-qa-alerts.test.js\"",
     "test:guard": "bash scripts/deploy-rules.test.sh",
     "deploy:rules": "bash scripts/deploy-rules.sh"
   },

exec
/bin/zsh -lc "sed -n '120,280p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
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
  <ul>
    <li>Adopted Codex's "simpler safe option": the copy and the old-copy removal are <strong>one transaction</strong>, with Spring edits paused by rule until the move is verified. That closes the verification/rollback race (1), the target-missing-at-delete risk (2) and double counting (5), since there's no dual-copy window, and Phases C and D merge.</li>
    <li>(3) The rules also fence <code>lessonData</code> create and whole-doc delete, keep manager delete for other docs, and the tests cover admin and curriculum-admin. Q3 is resolved: manager delete is kept, except for <code>lessonData</code>.</li>
    <li>(4) A stale-tab cutoff: Phase B live for 3 days or more, staff asked to reopen the Classbook, and an old tab can only mis-display, never lose data.</li>
    <li>(6) Studio Hub alerts reconcile a union across sources, with semester-qualified IDs.</li>
    <li>(7) Spring's delete is disabled in Phase B.</li>
    <li>(8) Merged <code>storageMigrations</code> writes, target-disappearance behaviour, and a Firestore-size estimator for the readout with an 85% warning.</li>
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
  <strong>Sep 29, 2026: revision 2, after review round 1 (Claude; <code>thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md</code>): NOT ready, 11-point minimum list, all taken.</strong> Re-scoped to <strong>Spring only, hard-coded</strong>, with no appData flags, <code>migratedSemesters</code>, UI buttons or "Move back". The copy and the removal are reviewed console procedures. The rules fence uses a literal key (no <code>get(appData)</code>), splits <code>:654</code>, and ships <strong>first</strong>. Fixed: the listener drops own-doc semesters (A); verify races (B, moot now that the fence freezes the source first); Phase D's precondition compares against the hash of what was written (C); vanished keys are loud (D); <code>not-found</code> on first write (E); <code>createNewSemester</code>/<code>deleteSemester</code> deferred to the follow-up plan, with a deadline (F, delete); the missing readers are added (<code>tinker-backups/backup.js</code>, which is Christie's edit, the in-app content count, <code>test-alerts.js</code>, dead backup helpers, e2e exemptions, seed); the backup citation and "nightly" are corrected; the listener generation is decided (no bump); teardown uses an array; a near-1 MB rules fixture is added; there's a headroom readout; and the emergency lever's order is fixed.<br>
  <strong>Open questions for Christie:</strong> (Q1) Is it OK that Spring 2026 is read-only ("editing is paused") from Phase A until Phase C, probably a few days? (Q2) Will you make the small <code>backup.js</code> edit before Phase D, or accept one expected content-loss alarm for Spring teachers? (Q3, for the reviewer) Undoing a bad Phase C copy needs a whole-doc delete of <code>lessons_spring-2026</code>; today only classbook-admin/curriculum-admin may whole-doc delete (<code>:675-678</code>). Should Phase A's split give managers delete as well (they have it today through <code>:654</code>'s <code>write</code>)? The plan assumes yes: the split keeps manager delete.
</div>
<div class="decision">
  <strong>Sep 29, 2026: plan created (draft 1).</strong> Found while reviewing the make-active plan's Archive design (now paused behind this plan). Christie measured 972 KB / 1,024 KB.
</div>

</body>
</html>

exec
/bin/zsh -lc "rg '"'^diff --git|''^@@'"' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-studiohub.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
exec
/bin/zsh -lc "rg '"'^diff --git|''^@@'"' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-classbook.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
diff --git a/e2e/helpers/storage-move.js b/e2e/helpers/storage-move.js
@@ -0,0 +1,62 @@
diff --git a/e2e/spring-own-doc.spec.js b/e2e/spring-own-doc.spec.js
@@ -0,0 +1,199 @@
diff --git a/index.html b/index.html
@@ -351,6 +351,15 @@
diff --git a/js/app.js b/js/app.js
@@ -3728,18 +3728,25 @@ async function sendTeacherQaMessage(lessonKey, modalSemKey) {
@@ -4579,6 +4586,12 @@ function renderSemesterSelector() {
@@ -5884,8 +5897,8 @@ function cancelGridAction() {
@@ -7236,6 +7249,10 @@ async function sendHelpResponse(key) {
@@ -7243,15 +7260,15 @@ async function sendHelpResponse(key) {
@@ -7321,20 +7338,24 @@ async function sendQaReply(key) {
@@ -7569,7 +7590,17 @@ async function computeLiveContentCountByTeacher() {
@@ -7651,6 +7682,27 @@ async function renderContentCount() {
diff --git a/js/firebase-data.js b/js/firebase-data.js
@@ -12,6 +12,7 @@ let curriculumDb = null;
@@ -71,6 +72,106 @@ function lessonStoreFor(semKey) {
@@ -756,11 +857,63 @@ async function loadOneCampSeason(plan, opts = {}) {
@@ -812,12 +965,18 @@ async function saveLessonData(semesterKey, lessons) {
@@ -827,8 +986,9 @@ async function saveLessonData(semesterKey, lessons) {
@@ -960,6 +1120,9 @@ async function sendSummerLessonQaMessage(semKey, lessonKey, lesson, newMsg) {
@@ -972,8 +1135,7 @@ async function deleteLessonData(semesterKey) {
@@ -1114,6 +1276,8 @@ function setupLessonDataListener(callback) {
@@ -1183,8 +1347,24 @@ function setupLessonDataListener(callback) {
@@ -1193,6 +1373,42 @@ function setupLessonDataListener(callback) {
@@ -1431,11 +1647,12 @@ async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClea
@@ -1452,7 +1669,7 @@ async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClea
@@ -1460,7 +1677,7 @@ function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToCle
@@ -1485,19 +1702,20 @@ async function saveMultipleLessonFields(semesterKey, writes = [], deletes = [])

 succeeded in 0ms:
diff --git a/classbook-qa-alerts.test.js b/classbook-qa-alerts.test.js
@@ -0,0 +1,57 @@
diff --git a/index.html b/index.html
@@ -221,6 +221,7 @@
diff --git a/js/alerts.js b/js/alerts.js
@@ -558,93 +558,73 @@ const AlertEngine = (() => {
diff --git a/js/classbook-qa-alerts.js b/js/classbook-qa-alerts.js
@@ -0,0 +1,78 @@
diff --git a/package.json b/package.json
@@ -1,7 +1,7 @@

codex
The intended design is clear: Spring remains classified as “weekly,” while `weeklyLessonTarget()` chooses the physical document and blocks unverified writes. I’m now tracing every call site and listener transition to verify that this alternate abstraction is complete—not merely consistent within the changed hunks.
exec
/bin/zsh -lc "nl -ba js/firebase-data.js | sed -n '1,190p;720,1040p;1080,1435p;1580,1765p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
     1	// =====================================================
     2	// Curriculum Manager — Firestore Data Layer
     3	// =====================================================
     4	// Document pattern:
     5	//   curriculum/appData     — semester config (URLs, GIDs, settings)
     6	//   curriculum/prepData    — prep team data by semester/week
     7	//   curriculum/lessonData  — all lesson content by semester (imported from classbooks)
     8	//   curriculum/cutProjects — projects removed from schedule, saved for reuse
     9	//   curriculum/changeLog   — audit trail of moves/swaps/cuts
    10	
    11	let curriculumDb = null;
    12	let configUnsubscribe = null;
    13	let prepDataUnsubscribe = null;
    14	let lessonDataUnsubscribe = null;
    15	let ownDocUnsubscribes = [];   // own-doc semester + storageMigrations listeners (Spring 2026 storage move)
    16	
    17	// The content fields a lesson's stripping/hasContent/wipe-detection logic
    18	// treats as "real plan content" (as opposed to metadata like teacher/weekNum).
    19	// Single source of truth — previously duplicated across four call sites.
    20	const CONTENT_FIELDS = ['introPitch', 'processStep1', 'processStep2', 'processStep3', 'processStep4', 'closure', 'dayOfMaterials'];
    21	function lessonHasContent(lesson) {
    22	  return !!lesson && CONTENT_FIELDS.some(f => lesson[f] && String(lesson[f]).trim());
    23	}
    24	
    25	// Firestore doc IDs cannot contain '/'. Encode lesson keys for storage.
    26	function encodeFirestoreKey(key) { return key.replace(/\//g, '__SLASH__'); }
    27	function decodeFirestoreKey(key) { return key.replace(/__SLASH__/g, '/'); }
    28	
    29	// ─── Semester types (camp seasons Phase 1, 1.1) ──────────────────────────────
    30	// Every semester stores its kind explicitly. Nothing in the app may infer a
    31	// kind from a key: "does this key start with summer-?" was how a weekly
    32	// semester named "Summer Enrichment" could be routed into the summer
    33	// collections (R5-3), and how Summer 2026 was the only camp season that could
    34	// ever exist.
    35	const SEMESTER_TYPES = { weekly: 'weekly', camp: 'summer-camp', dayOff: 'day-off-camps' };
    36	
    37	// The stored type, or 'weekly' when absent — with ONE quarantined exception:
    38	// an absent type on the literal key `summer-2026` is a camp season. That
    39	// covers two real windows: the minutes between this deploy and Christie
    40	// pressing "Stamp semester types", and a stale pre-Phase-1 tab whose
    41	// whole-document saveConfig() could strip the field. It is the only place
    42	// that literal may appear — a static test fails the build on any other
    43	// functional occurrence. In practice it almost never fires: the May 2026
    44	// auto-add already stored semesterType on the server's summer-2026.
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
   121	  }
   122	  if (ownDocSource[semKey] !== 'ownDoc' || !ownDocMoveVerified(semKey)) {
   123	    throw new Error(OWN_DOC_PAUSED_MESSAGE);
   124	  }
   125	  return { ref: curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)), prefix: '' };
   126	}
   127	
   128	// Forced-server (or cache-permitting) read of one weekly semester's lesson map,
   129	// wherever it lives. An own-doc semester is read from its own document when that
   130	// exists, otherwise from lessonData — independent of this tab's in-memory state.
   131	async function readWeeklySemesterMap(semKey, getOpts) {
   132	  if (!curriculumDb) initCurriculumFirestore();
   133	  if (isOwnDocSemester(semKey)) {
   134	    const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get(getOpts);
   135	    if (own.exists) return ownDocLessonMap(own.data());
   136	  }
   137	  const legacy = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
   138	  return legacy.exists ? (legacy.data()?.[semKey] ?? null) : null;
   139	}
   140	
   141	// Approximate Firestore size of a value in bytes — the documented storage-size
   142	// rules (string = UTF-8 bytes + 1, number 8, boolean 1, null 1, map = sum of
   143	// key + value). Used for the headroom readout; the SDK doesn't expose the real size.
   144	function approxFirestoreSize(v) {
   145	  const str = (x) => new TextEncoder().encode(x).length + 1;
   146	  if (v === null || v === undefined) return 1;
   147	  if (typeof v === 'string') return str(v);
   148	  if (typeof v === 'number') return 8;
   149	  if (typeof v === 'boolean') return 1;
   150	  if (v && typeof v.toDate === 'function') return 8;
   151	  if (Array.isArray(v)) return v.reduce((t, x) => t + approxFirestoreSize(x), 0);
   152	  if (typeof v === 'object') return Object.entries(v).reduce((t, [k, x]) => t + str(k) + approxFirestoreSize(x), 0);
   153	  return 8;
   154	}
   155	function approxLessonDataSizeKB() {
   156	  if (!lastLegacyLessonData) return null;
   157	  const docName = 'projects/tinker-hq-apps/databases/(default)/documents/curriculum/lessonData';
   158	  return Math.round((approxFirestoreSize(lastLegacyLessonData) + new TextEncoder().encode(docName).length + 1 + 32) / 1024);
   159	}
   160	
   161	function showStorageNotice(message) {
   162	  let el = document.getElementById('storage-notice-banner');
   163	  if (!el) {
   164	    el = document.createElement('div');
   165	    el.id = 'storage-notice-banner';
   166	    el.className = 'lesson-load-error-banner';
   167	    const anchorEl = document.getElementById('lesson-load-error-banner');
   168	    if (anchorEl?.parentNode) anchorEl.parentNode.insertBefore(el, anchorEl.nextSibling);
   169	    else document.body.prepend(el);
   170	  }
   171	  el.textContent = message;
   172	  el.classList.remove('hidden');
   173	}
   174	
   175	// ─── Summer document IDs (camp seasons Phase 1, 1.5) ─────────────────────────
   176	// The cross-app contract, shared with the Summer Camp App: 2026 documents keep
   177	// every existing ID unchanged; any other season prefixes the ENTIRE legacy ID
   178	// with the reserved token `season-{year}|||`, applied after the legacy ID is
   179	// fully formed (i.e. after encodeFirestoreKey()). `season-` cannot collide
   180	// with a teacher or camp name, and a bare `{year}|||` prefix would have been
   181	// ambiguous against a legacy ID whose first segment happens to be a year.
   182	// parseSummerDocId() is the exact inverse; anything unprefixed is 2026.
   183	const LEGACY_SEASON = '2026';
   184	const SEASON_DOC_ID_PREFIX = /^season-(\d{4})\|\|\|/;
   185	function summerDocId(legacyId, season) {
   186	  return season === LEGACY_SEASON ? legacyId : `season-${season}|||${legacyId}`;
   187	}
   188	// (semKey, legacy key) → the document ID in that semester's season. Every
   189	// summer writer and by-ID reader goes through this; a static test forbids a
   190	// bare .doc() on a summerCamps_* collection anywhere else.
   720	      goals: [
   721	        'Prioritized prep task list ready for Tuesday morning',
   722	        'List ready of items needed from storage',
   723	        'Items returning to storage staged on shelving and ready',
   724	        'Prep any day-of items needed for Friday or Monday',
   725	        'Generate trials and process sheets for shared projects — 3 weeks in advance of project',
   726	        'Use Weekly Curriculum meeting to clarify projects and materials'
   727	      ]
   728	    },
   729	    {
   730	      id: 'return-gather',
   731	      name: 'Return & Gather',
   732	      emoji: '📦',
   733	      days: ['Tuesday'],
   734	      description: "Return staged materials to storage and gather what's needed for this week.",
   735	      goals: [
   736	        'Return staged materials to storage (aim for ~2 trips/week)',
   737	        'Delegated prep tasks completed for the day',
   738	        'Prep task list for Wednesday is ready',
   739	        'Keep up on reset materials (threaded needles, model magic, canvas unwrap, etc.)',
   740	        'Use Weekly Curriculum meeting to clarify projects and materials',
   741	        'Cross reference Teacher Process Sheet with Curriculum Map if prep is missing from Prep Dashboard'
   742	      ]
   743	    },
   744	    {
   745	      id: 'prep',
   746	      name: 'Prep',
   747	      emoji: '🎨',
   748	      days: ['Tuesday', 'Wednesday'],
   749	      description: 'Work blocks — prepare items as requested. Prep work should be 2 weeks ahead of project.',
   750	      goals: [
   751	        'Prep work is 2 weeks ahead of project',
   752	        'Keep on top of low supplies — flag via Supply Low List or to manager',
   753	        'Keep list of Friday/Monday reset tasks and daily resets',
   754	        'Keep in communication with SDOC prep lead — trials, process sheets, materials (several weeks ahead)',
   755	        'Cross reference Teacher Process Sheet with Curriculum Map if prep is missing from Prep Dashboard',
   756	        'Cross reference materials needed with list of reset tasks — include day-of materials'
   757	      ]
   758	    },
   759	    {
   760	      id: 'distribute',
   761	      name: 'Distribute',
   762	      emoji: '📤',
   763	      days: ['Tuesday', 'Wednesday'],
   764	      description: 'Prepped items go to teacher tubs or common project shelving.',
   765	      goals: [
   766	        'Prepped materials labeled for teacher: class code, week #, size, quantity',
   767	        'Delegated prep tasks completed for the day',
   768	        'Labeled prepped items distributed to teacher tubs',
   769	        'Keep up on materials needing reset for current week',
   770	        'Cross reference class totals and totals for multiple class projects',
   771	        'Cross reference materials needed with list of reset tasks — include day-of materials'
   772	      ]
   773	    },
   774	    {
   775	      id: 'stage',
   776	      name: 'Stage',
   777	      emoji: '🗂️',
   778	      days: ['Wednesday'],
   779	      description: 'Stage prepped multi-class projects & items to and from storage.',
   780	      goals: [
   781	        'Multi-class project materials staged on shelf in workroom, labeled with example and process sheet',
   782	        'Materials teachers may need later placed on wait shelf',
   783	        'Workroom reset — weekly clear surfaces, keep labeled and accessible',
   784	        'Storage organized — monthly quick reset; keep Materials Locater updated',
   785	        'Cross reference class totals and totals for multiple class projects',
   786	        'Delegate tasks in prep log — each entry labeled with Week #, Class name, total students, Material, quantity, size'
   787	      ]
   788	    },
   789	    {
   790	      id: 'breakdown',
   791	      name: 'Breakdown',
   792	      emoji: '🔄',
   793	      days: ['Wednesday', 'Thursday'],
   794	      description: 'Breakdown returned & unused materials. Stage items on Return shelf.',
   795	      goals: [
   796	        'Materials no longer needed put away; items going to storage staged on return shelf',
   797	        'Look ahead for materials finished with one project but needed for an upcoming project — redistribute',
   798	        'Thursday: review curriculum for Friday & Monday needs; prep as needed; prep Open Studio for Monday',
   799	        'Keep up on materials needing reset for current week',
   800	        'Delegate tasks in prep log — each entry labeled with Week #, Class name, total students, Material, quantity, size',
   801	        'Generate trials and process sheets for shared projects — 3 weeks in advance of project'
   802	      ]
   803	    }
   804	  ]
   805	};
   806	
   807	async function getPrepCycleConfig() {
   808	  if (!curriculumDb) initCurriculumFirestore();
   809	  try {
   810	    const doc = await curriculumDb.collection('curriculum').doc('prepCycleConfig').get();
   811	    if (doc.exists && doc.data().phases?.length) {
   812	      return doc.data();
   813	    }
   814	  } catch (err) {
   815	    console.warn('Could not load prep cycle config, using defaults:', err);
   816	  }
   817	  return DEFAULT_PREP_CYCLE_CONFIG;
   818	}
   819	
   820	async function savePrepCycleConfig(config) {
   821	  if (!curriculumDb) initCurriculumFirestore();
   822	  const user = getAuthUser();
   823	  const toSave = {
   824	    ...config,
   825	    lastUpdated: new Date().toISOString(),
   826	    lastUpdatedBy: user?.name || 'Unknown'
   827	  };
   828	  await curriculumDb.collection('curriculum').doc('prepCycleConfig').set(toSave);
   829	}
   830	
   831	// ─── Lesson Data (curriculum/lessonData) ─────────────
   832	
   833	// Every camp-season semester in the config, with the season each one reads.
   834	// In legacy mode the 2026 season reads unfiltered (it is the only season that
   835	// exists by definition) and any other camp season loads nothing at all —
   836	// there is nothing stamped for it yet (Phase 1, 1.3/1.4).
   837	function dayOffYearKeys() {
   838	  return Object.keys(currentConfig?.semesters || {}).filter(isDayOffYear);
   839	}
   840	
   841	function campSeasonLoadPlan() {
   842	  const semesters = currentConfig?.semesters || {};
   843	  return Object.keys(semesters)
   844	    .filter(isCampSeason)
   845	    .map(semKey => {
   846	      const season = seasonForSemester(semKey);
   847	      if (seasonRegistryMode === 'legacy') {
   848	        return season === LEGACY_SEASON ? { semKey, season: null } : { semKey, season, unavailable: true };
   849	      }
   850	      return { semKey, season };
   851	    });
   852	}
   853	
   854	// One camp season's lessons, or an empty map when legacy mode cannot serve it.
   855	async function loadOneCampSeason(plan, opts = {}) {
   856	  if (plan.unavailable) { currentSummerSessionsBySemester[plan.semKey] = []; return {}; }
   857	  return await loadSummerCampData({ ...opts, season: plan.season, semKey: plan.semKey });
   858	}
   859	
   860	// Initial load for own-doc semesters and the migration record (called by
   861	// loadLessonData, after the legacy document). A failed read of the record is
   862	// treated as "not verified" (edits stay paused); a failed read of a semester's own
   863	// document marks it 'error' — shown from whatever lessonData still holds, never
   864	// writable, with a visible notice.
   865	async function loadOwnDocSemesters() {
   866	  if (!curriculumDb) initCurriculumFirestore();
   867	  try {
   868	    const m = await curriculumDb.collection('curriculum').doc('storageMigrations').get();
   869	    storageMigrationState = m.exists ? (m.data() || {}) : {};
   870	  } catch (err) {
   871	    console.warn('⚠️ Could not read curriculum/storageMigrations — own-doc semesters stay read-only:', err);
   872	    storageMigrationState = {};
   873	  }
   874	  for (const semKey of OWN_DOC_SEMESTERS) {
   875	    try {
   876	      const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get();
   877	      if (own.exists) {
   878	        ownDocSource[semKey] = 'ownDoc';
   879	        currentLessonData[semKey] = ownDocLessonMap(own.data());
   880	      } else {
   881	        ownDocSource[semKey] = 'legacy';
   882	      }
   883	    } catch (err) {
   884	      console.error(`❌ Could not read curriculum/${ownDocIdFor(semKey)}:`, err);
   885	      ownDocSource[semKey] = 'error';
   886	      showStorageNotice(`⚠️ ${semKey} lessons couldn't be loaded from their new storage — please reload the page.`);
   887	    }
   888	  }
   889	}
   890	
   891	// The legacy snapshot no longer holds an own-doc semester this tab was showing
   892	// from lessonData: the move just happened (or the page is stale). Never blank it —
   893	// keep the lessons on screen, look for its own document, and if that isn't there
   894	// either, say so.
   895	async function recheckOwnDocAfterLegacyLoss(semKey, callback) {
   896	  try {
   897	    const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get({ source: 'server' });
   898	    if (own.exists) {
   899	      ownDocSource[semKey] = 'ownDoc';
   900	      currentLessonData[semKey] = ownDocLessonMap(own.data());
   901	      if (callback) callback(currentLessonData);
   902	      return;
   903	    }
   904	  } catch (err) {
   905	    console.warn(`⚠️ Could not check curriculum/${ownDocIdFor(semKey)}:`, err);
   906	  }
   907	  showStorageNotice(`⚠️ ${semKey} moved to new storage — please reload the page to see its latest lessons.`);
   908	}
   909	
   910	async function loadLessonData() {
   911	  if (!curriculumDb) initCurriculumFirestore();
   912	  try {
   913	    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
   914	    currentLessonData = doc.exists ? doc.data() : {};
   915	    lastLegacyLessonData = doc.exists ? doc.data() : {};
   916	    await loadOwnDocSemesters();
   917	
   918	    // Every camp season gets its own map (Phase 1, 1.4) — no literal key.
   919	    try {
   920	      const plans = campSeasonLoadPlan();
   921	      console.log('📚 Loading camp seasons:', plans.map(p => `${p.semKey}${p.season ? ` (${p.season})` : ' (unfiltered)'}`).join(', ') || 'none');
   922	      for (const plan of plans) {
   923	        currentLessonData[plan.semKey] = await loadOneCampSeason(plan);
   924	        console.log(`📚 ${plan.semKey}: ${Object.keys(currentLessonData[plan.semKey]).length} lessons`);
   925	      }
   926	      // School Day Off Camps years: their own three collections. A failure
   927	      // trips the same app-wide guard — loud, never a quiet empty list.
   928	      for (const yearKey of dayOffYearKeys()) {
   929	        currentLessonData[yearKey] = await loadDayOffCampData({ yearKey });
   930	        console.log(`📚 ${yearKey}: ${Object.keys(currentLessonData[yearKey]).length} day-off camp plans`);
   931	      }
   932	      lessonDataLoadedSuccessfully = true;
   933	    } catch (err) {
   934	      // One season failing trips the guard for the whole app: a partially
   935	      // loaded model is not a safe base for any writer, in any semester.
   936	      console.error('❌ Could not load camp season data:', err);
   937	      lessonDataLoadedSuccessfully = false;
   938	    }
   939	  } catch (err) {
   940	    console.error('Error loading lesson data:', err);
   941	    currentLessonData = {};
   942	    lessonDataLoadedSuccessfully = false;
   943	  }
   944	  return currentLessonData;
   945	}
   946	
   947	// Whole-semester bulk writer (restoreFromBackup, createNewSemester,
   948	// createLessonSlotsForRoster). Guarded the same way as
   949	// saveSingleLesson(): after a failed load, `lessons` is built from an empty or
   950	// partial currentLessonData (or, for restoreFromBackup, would land over a
   951	// semester whose current state this client never confirmed), and merge:true
   952	// would still write it over the real semester map. Throws rather than no-ops —
   953	// every caller treats a resolved promise as "the write landed" (backtracking
   954	// audit, Phase 11).
   955	async function saveLessonData(semesterKey, lessons) {
   956	  if (lessonDataLoadedSuccessfully === false) {
   957	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
   958	  }
   959	  if (!curriculumDb) initCurriculumFirestore();
   960	
   961	  // Route by the semester's TYPE, never by its key (Phase 1, 1.1): camp
   962	  // seasons go to the per-lesson collection (also dodging the 1MB doc limit),
   963	  // and any other type is refused rather than misrouted.
   964	  if (lessonStoreFor(semesterKey) === 'camp') {
   965	    return await saveSummerCampLessonData(semesterKey, lessons);
   966	  }
   967	
   968	  // Regular semester: save to curriculum/lessonData — or, for an own-doc
   969	  // semester, to its own document (the whole map at the top level).
   970	  const user = getAuthUser();
   971	  const stamp = { lastUpdated: new Date().toISOString(), lastUpdatedBy: user?.name || 'Unknown' };
   972	  if (isOwnDocSemester(semesterKey)) {
   973	    const { ref } = weeklyLessonTarget(semesterKey);   // throws "editing is paused" until verified
   974	    await ref.set({ ...lessons, ...stamp }, { merge: true });
   975	    return;
   976	  }
   977	  await curriculumDb.collection('curriculum').doc('lessonData').set({
   978	    [semesterKey]: lessons,
   979	    ...stamp
   980	  }, { merge: true });
   981	}
   982	
   983	// Explicitly delete a single lesson key from the nested map.
   984	// More reliable than resaving the full semester when cutting a project,
   985	// because Firestore's merge:true may not remove nested map keys.
   986	async function deleteLessonKey(semesterKey, lessonKey) {
   987	  if (!curriculumDb) initCurriculumFirestore();
   988	  const user = getAuthUser();
   989	  const { ref, prefix } = weeklyLessonTarget(semesterKey);
   990	  await ref.update({
   991	    [`${prefix}${lessonKey}`]: firebase.firestore.FieldValue.delete(),
   992	    lastUpdated: new Date().toISOString(),
   993	    lastUpdatedBy: user?.name || 'Unknown'
   994	  });
   995	}
   996	
   997	async function saveSummerCampLessonData(semKey, lessons) {
   998	  if (!curriculumDb) initCurriculumFirestore();
   999	  // Resolved once, before any batch work — a semester with no valid season
  1000	  // throws here, so nothing is queued.
  1001	  const season = seasonForSemester(semKey);
  1002	  const user = getAuthUser();
  1003	  const batch = curriculumDb.batch();
  1004	
  1005	  console.log('💾 Saving Summer Camp lesson data...', { semKey, season });
  1006	
  1007	  const hasContent = lessonHasContent;
  1008	
  1009	  let writeCount = 0;
  1010	  // Save each lesson as a separate document (lessonKey as doc ID)
  1011	  for (const [lessonKey, lessonData] of Object.entries(lessons)) {
  1012	    // Never overwrite existing docs with empty content — protects against stale in-memory state
  1013	    if (!hasContent(lessonData)) continue;
  1014	    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
  1015	    // Strip empty content fields so stale in-memory empty strings never overwrite
  1016	    // real content that a teacher saved in a different browser session.
  1017	    const stripped = { ...lessonData };
  1018	    CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
  1019	    // JSON round-trip strips undefined values that Firestore rejects with invalid-argument
  1020	    const cleanData = JSON.parse(JSON.stringify({
  1021	      ...stripped,
  1022	      season,
  1023	      lastUpdated: new Date().toISOString(),
  1024	      lastUpdatedBy: user?.name || 'Unknown'
  1025	    }));
  1026	    batch.set(docRef, cleanData, { merge: true });
  1027	    writeCount++;
  1028	  }
  1029	
  1030	  await batch.commit();
  1031	  console.log(`✅ Saved ${writeCount} Summer Camp lesson slots (skipped ${Object.keys(lessons).length - writeCount} empty)`);
  1032	}
  1033	
  1034	// Season-scoped, and it no longer swallows its errors (Phase 1, 1.4): a
  1035	// failure used to return {} — every camp-complete checkbox unchecked — and the
  1036	// next click would write campComplete: false over a true. The caller renders
  1037	// an error state instead. Two equality filters need no composite index.
  1038	async function loadCampCompleteData(semKey, teacher) {
  1039	  if (!curriculumDb) initCurriculumFirestore();
  1040	  const result = {};
  1080	// semKey is the MODAL's semester (captured when it opened), not the header
  1081	// selector's — that can move while the modal is open. Only the create path
  1082	// stamps `season`; a later message never re-stamps or moves a doc between
  1083	// seasons (the Summer Camp App's Season.patch() rule).
  1084	async function sendSummerLessonQaMessage(semKey, lessonKey, lesson, newMsg) {
  1085	  if (lessonDataLoadedSuccessfully === false) {
  1086	    throw new Error('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  1087	  }
  1088	  if (!curriculumDb) initCurriculumFirestore();
  1089	  // Resolved before the read so an invalid semester is refused before anything is touched.
  1090	  const season = seasonForSemester(semKey);
  1091	  const docRef = curriculumDb.collection('summerCamps_prepHelpQueue').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
  1092	  const docSnap = await docRef.get();
  1093	  const isAdmin = newMsg.from === 'admin';
  1094	
  1095	  if (!docSnap.exists) {
  1096	    await docRef.set({
  1097	      queueType: 'teachers',
  1098	      campTopic: lesson.campName,
  1099	      project: lesson.projectTitle,
  1100	      projectTitle: lesson.projectTitle,
  1101	      block: lesson.block,
  1102	      teacher: lesson.teacher,
  1103	      lessonKey,
  1104	      season,
  1105	      askedBy: newMsg.name,
  1106	      question: newMsg.message,
  1107	      qaThread: [newMsg],
  1108	      status: 'Open',
  1109	      createdAt: firebase.firestore.FieldValue.serverTimestamp(),
  1110	      lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
  1111	    });
  1112	  } else {
  1113	    await docRef.update({
  1114	      qaThread: firebase.firestore.FieldValue.arrayUnion(newMsg),
  1115	      status: isAdmin ? 'Resolved' : 'Open',
  1116	      lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
  1117	    });
  1118	  }
  1119	}
  1120	
  1121	async function deleteLessonData(semesterKey) {
  1122	  if (!curriculumDb) initCurriculumFirestore();
  1123	  // An own-doc semester's lessons aren't in lessonData (and the rules fence the
  1124	  // key); deleting it is disabled until the follow-up plan routes it.
  1125	  if (isOwnDocSemester(semesterKey)) throw new Error(`"${semesterKey}" can't be deleted while its storage is being changed.`);
  1126	  await curriculumDb.collection('curriculum').doc('lessonData').update({
  1127	    [semesterKey]: firebase.firestore.FieldValue.delete()
  1128	  });
  1129	}
  1130	
  1131	// Forced-server read of one semester's whole lesson map in curriculum/lessonData
  1132	// (null when absent). Bypasses both the in-memory model and the SDK cache —
  1133	// used where the local cache is known to be untrustworthy for this key, e.g.
  1134	// createNewSemester()'s pre-check (deleteSemester() drops a key locally even
  1135	// when its server-side delete failed). Backtracking audit, Phase 11.
  1136	async function readServerSemesterLessonMap(semesterKey) {
  1137	  if (!curriculumDb) initCurriculumFirestore();
  1138	  return await readWeeklySemesterMap(semesterKey, { source: 'server' });
  1139	}
  1140	
  1141	async function backupLessonData(semesterKey) {
  1142	  if (!curriculumDb) initCurriculumFirestore();
  1143	  const existing = currentLessonData?.[semesterKey];
  1144	  if (!existing || Object.keys(existing).length === 0) return 0;
  1145	  const count = Object.keys(existing).length;
  1146	  const user = getAuthUser();
  1147	  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
  1148	    [semesterKey]: existing,
  1149	    backupDate: new Date().toISOString(),
  1150	    backupBy: user?.name || 'Unknown'
  1151	  }, { merge: true });
  1152	  return count;
  1153	}
  1154	
  1155	async function restoreFromBackup(semesterKey) {
  1156	  if (!curriculumDb) initCurriculumFirestore();
  1157	  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
  1158	  if (!backupDoc.exists) return null;
  1159	  const backupData = backupDoc.data();
  1160	  const lessons = backupData?.[semesterKey];
  1161	  if (!lessons || Object.keys(lessons).length === 0) return null;
  1162	  await saveLessonData(semesterKey, lessons);
  1163	  return Object.keys(lessons).length;
  1164	}
  1165	
  1166	// "Which copy of a lesson is newer", by lastEditedAt — the only revision
  1167	// marker the data has (a client wall-clock heuristic: ties and missing values
  1168	// resolve to "not newer"). Shared by the listener merge below and the summer
  1169	// editor's own adoption/re-install logic (Backtracking audit Phase 10).
  1170	function lessonEditedAtMs(lesson) {
  1171	  return Date.parse(lesson?.lastEditedAt || '') || 0;
  1172	}
  1173	
  1174	// The fields a saved summerCamps_lessonData doc contributes to a lesson slot
  1175	// (everything else on the slot — teacher, camp, materials, sharedWith, class
  1176	// size… — is rebuilt from the other collections on every reload and must
  1177	// always come from the fresh read).
  1178	const SUMMER_SAVED_FIELDS = [...CONTENT_FIELDS, 'photoUrl', 'photoPath', 'planComplete', 'lastEditedBy', 'lastEditedAt'];
  1179	// A reload's read can only plausibly predate a save this recent; a stamp
  1180	// older than this — or further than this into the future — is a skewed clock
  1181	// or a doc deleted/restored underneath us, and the fresh read wins.
  1182	const SUMMER_KEEP_MINE_WINDOW_MS = 10 * 60 * 1000;
  1183	// When the merge keeps an in-memory copy, the server copy it displaced is
  1184	// parked here so the summer editor can fall back to it if the in-flight save
  1185	// that made the in-memory copy "newer" then fails (see openLessonModal()).
  1186	// Keyed by SEMESTER and lesson (Phase 1, 1.4): two camp seasons legitimately
  1187	// share a lesson key — same teacher, camp, block and project in 2026 and
  1188	// 2027 — and a single-keyed map would park one season's server copy under
  1189	// the other's, then hand it back to the wrong editor.
  1190	const displacedSummerServerCopies = new Map();
  1191	const displacedKey = (semKey, lessonKey) => `${semKey}|${lessonKey}`;
  1192	
  1193	// Backtracking audit Phase 7, handed over by Phase 10: a reload's collection
  1194	// read can predate a save that has since landed (or is in flight,
  1195	// optimistically installed). The fresh read is authoritative for WHICH
  1196	// lessons exist and for every scaffold-derived field; for the saved-doc
  1197	// fields, keep the in-memory copy when it is strictly newer — recently — than
  1198	// the freshly read one. The in-memory OBJECT is kept (updated in place), so
  1199	// the editor's identity checks on its optimistic entry still hold.
  1200	// protectedKeys (SDOC, Phase 2B): lessons whose fresh copy is a VERIFIED save
  1201	// newer than this reload's query — taken whole, never overridden by the
  1202	// clock-based keepMine below and never parked (a faster clock on an older
  1203	// in-memory copy must not put old text back). Defaults to the set
  1204	// loadDayOffCampData() attached to its result; summer results carry none.
  1205	function mergeSummerReload(semKey, previous, fresh, protectedKeys = fresh?.[DAY_OFF_PROTECTED] || null) {
  1206	  // A lesson the fresh scaffold no longer has is gone — nothing parked for it
  1207	  // may be resurrected by an editor fallback later. Only THIS semester's
  1208	  // parked copies are considered: pruning globally would evict the other
  1209	  // season's on every reload.
  1210	  const prefix = `${semKey}|`;
  1211	  for (const key of displacedSummerServerCopies.keys()) {
  1212	    if (!key.startsWith(prefix)) continue;
  1213	    if (!(key.slice(prefix.length) in fresh)) displacedSummerServerCopies.delete(key);
  1214	  }
  1215	  if (!previous) return fresh;
  1216	  const now = Date.now();
  1217	  for (const key of Object.keys(fresh)) {
  1218	    if (protectedKeys?.has(key)) { displacedSummerServerCopies.delete(displacedKey(semKey, key)); continue; }
  1219	    const mine = previous[key];
  1220	    const mineAt = lessonEditedAtMs(mine);
  1221	    const keepMine = mine && mineAt > lessonEditedAtMs(fresh[key]) && Math.abs(now - mineAt) < SUMMER_KEEP_MINE_WINDOW_MS;
  1222	    if (keepMine) {
  1223	      const saved = {};
  1224	      SUMMER_SAVED_FIELDS.forEach(f => { if (f in mine) saved[f] = mine[f]; });
  1225	      displacedSummerServerCopies.set(displacedKey(semKey, key), fresh[key]);
  1226	      // `mine` becomes exactly "fresh scaffold + my saved fields" — anything
  1227	      // else that was sitting on it (e.g. legacy Q&A mirror fields another
  1228	      // path installed) goes, so the object never carries stale extras.
  1229	      for (const f of Object.keys(mine)) { if (!(f in fresh[key]) && !(f in saved)) delete mine[f]; }
  1230	      Object.assign(mine, fresh[key], saved);
  1231	      fresh[key] = mine;
  1232	    } else {
  1233	      displacedSummerServerCopies.delete(displacedKey(semKey, key));
  1234	    }
  1235	  }
  1236	  return fresh;
  1237	}
  1238	
  1239	// Backtracking audit Phase 7 (R2-10, R3-7, R4-10): every snapshot of the
  1240	// shared curriculum/lessonData doc re-runs the summer collection reload.
  1241	// Its outcome now drives the load-guard and the banner like the initial
  1242	// load does — a failure trips them, a later success resets them — and only
  1243	// the LATEST reload's outcome may do so: callbacks resolve out of order, and
  1244	// unsubscribing a listener does not cancel its in-flight callback, so the
  1245	// generation counter is module-scoped across every setupLessonDataListener()
  1246	// call (and bumped by the call itself, so an old listener's in-flight reload
  1247	// is stale from the moment it is replaced). A tripped guard blocks every
  1248	// writer in the app, so a failed reload is retried a bounded number of times
  1249	// on its own — a wifi blip self-heals, a real outage keeps the banner.
  1250	// Handed over by Phase 10: the summer cache is kept in place for the ~1.5 s
  1251	// the reload takes (it used to vanish, so the summer view rendered nothing
  1252	// and an in-flight save's optimistic entry had no map to live in), and the
  1253	// reload is merged per lesson keeping the newer copy (mergeSummerReload).
  1254	const SUMMER_RELOAD_RETRY_DELAYS_MS = [5000, 15000];
  1255	// The camp seasons currently in memory, by semester key.
  1256	function snapshotCampSeasons() {
  1257	  const out = {};
  1258	  for (const semKey of Object.keys(currentLessonData || {})) {
  1259	    if ((isCampSeason(semKey) || isDayOffYear(semKey)) && currentLessonData[semKey]) out[semKey] = currentLessonData[semKey];
  1260	  }
  1261	  return out;
  1262	}
  1263	
  1264	// Set by setupLessonDataListener() so a season-registry mode change (legacy →
  1265	// filtered, or unknown healing) re-runs the summer load through that
  1266	// listener's own generation-gated path — never a second, competing one
  1267	// (Phase 1, 1.3).
  1268	let summerReloadHook = null;
  1269	async function reloadSummerForModeChange() {
  1270	  if (typeof summerReloadHook !== 'function') return 'no-listener';
  1271	  return await summerReloadHook();
  1272	}
  1273	
  1274	function setupLessonDataListener(callback) {
  1275	  console.log('📚 Setting up lesson data listener...');
  1276	  if (!curriculumDb) initCurriculumFirestore();
  1277	  globalListenerGeneration++; // whatever the previous listener still has in flight is now stale
  1278	  if (lessonDataUnsubscribe) lessonDataUnsubscribe();
  1279	  // The own-doc listeners (Spring 2026 storage move) are torn down together.
  1280	  while (ownDocUnsubscribes.length) { try { ownDocUnsubscribes.pop()(); } catch (e) { /* already gone */ } }
  1281	
  1282	  // One reload attempt for one snapshot generation. Only the latest
  1283	  // generation may touch the guard, the banner, or the summer cache.
  1284	  // Resolves 'ok' | 'failed' | 'stale'. Only 'stale' means this generation's
  1285	  // outcome was discarded (a newer snapshot took over while it ran).
  1286	  const reloadSummer = async (myGeneration, previousSummer, attempt) => {
  1287	    const isCurrent = () => myGeneration === globalListenerGeneration;
  1288	    try {
  1289	      console.log('📚 Attempting to load camp season data...' + (attempt ? ` (retry ${attempt})` : ''));
  1290	      const plans = campSeasonLoadPlan();
  1291	      const fresh = {};
  1292	      for (const plan of plans) fresh[plan.semKey] = await loadOneCampSeason(plan, { isCurrent });
  1293	      const dayOffKeys = dayOffYearKeys();
  1294	      for (const yearKey of dayOffKeys) fresh[yearKey] = await loadDayOffCampData({ yearKey, isCurrent });
  1295	      if (!isCurrent()) { console.log('📚 Camp season reload superseded by a newer snapshot — ignoring its result'); return 'stale'; }
  1296	      for (const yearKey of dayOffKeys) {
  1297	        currentLessonData[yearKey] = mergeSummerReload(yearKey, previousSummer?.[yearKey], fresh[yearKey]);
  1298	        healDayOffYearAfterReload(yearKey, fresh[yearKey]);
  1299	      }
  1300	      for (const plan of plans) {
  1301	        // Each season merges against ITS OWN previous map — mergeSummerReload
  1302	        // prunes parked copies that are absent from `fresh`, so merging one
  1303	        // season against another's would evict the other's on every reload.
  1304	        currentLessonData[plan.semKey] = mergeSummerReload(plan.semKey, previousSummer?.[plan.semKey], fresh[plan.semKey]);
  1305	      }
  1306	      console.log('📚 Camp seasons loaded:', plans.map(p => `${p.semKey}=${Object.keys(fresh[p.semKey]).length}`).join(' '));
  1307	      lessonDataLoadedSuccessfully = true;
  1308	      document.getElementById('lesson-load-error-banner')?.classList.add('hidden');
  1309	      return 'ok';
  1310	    } catch (err) {
  1311	      console.error('❌ Could not load camp season / day-off camp data:', err);
  1312	      if (!isCurrent()) return 'stale';
  1313	      lessonDataLoadedSuccessfully = false;
  1314	      document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
  1315	      const delay = SUMMER_RELOAD_RETRY_DELAYS_MS[attempt];
  1316	      if (delay !== undefined) {
  1317	        setTimeout(() => {
  1318	          if (!isCurrent()) return; // a newer snapshot has taken over
  1319	          reloadSummer(myGeneration, snapshotCampSeasons(), attempt + 1).then(outcome => { if (outcome === 'ok' && callback) callback(currentLessonData); });
  1320	        }, delay);
  1321	      }
  1322	      return 'failed';
  1323	    }
  1324	  };
  1325	
  1326	  // The registry-change entry point: same reload, same generation gate, and it
  1327	  // renders through the same callback when it is still the current generation.
  1328	  summerReloadHook = async () => {
  1329	    const myGeneration = ++globalListenerGeneration;
  1330	    const outcome = await reloadSummer(myGeneration, snapshotCampSeasons(), 0);
  1331	    if (outcome !== 'stale' && callback) callback(currentLessonData);
  1332	    return outcome;
  1333	  };
  1334	
  1335	  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
  1336	    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
  1337	      // Skip cache-only updates
  1338	      if (doc.metadata.fromCache && !doc.metadata.hasPendingWrites) {
  1339	        console.log('📚 Skipping cache-only snapshot, waiting for server data...');
  1340	        return;
  1341	      }
  1342	      console.log('📚 Lesson data snapshot received, from cache:', doc.metadata.fromCache, 'exists:', doc.exists);
  1343	      if (!doc.exists) return;
  1344	
  1345	      const myGeneration = ++globalListenerGeneration;
  1346	      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
  1347	      // in their own collection, so carry their current maps across the swap
  1348	      // and let the reload below refresh each one (Phase 1, 1.4).
  1349	      const previousSummer = snapshotCampSeasons();
  1350	      // Own-doc semesters (Spring 2026 storage move): their lessons aren't in this
  1351	      // document once moved, so carry them across the swap like the camp seasons —
  1352	      // their own listeners below keep them current.
  1353	      const previousOwn = {};
  1354	      for (const semKey of OWN_DOC_SEMESTERS) if (currentLessonData?.[semKey]) previousOwn[semKey] = currentLessonData[semKey];
  1355	      currentLessonData = doc.data();
  1356	      lastLegacyLessonData = doc.data();
  1357	      for (const [semKey, map] of Object.entries(previousSummer)) currentLessonData[semKey] = map;
  1358	      for (const semKey of OWN_DOC_SEMESTERS) {
  1359	        if (ownDocSource[semKey] === 'ownDoc' || ownDocSource[semKey] === 'error') {
  1360	          if (previousOwn[semKey]) currentLessonData[semKey] = previousOwn[semKey];
  1361	        } else if (!(semKey in currentLessonData) && previousOwn[semKey]) {
  1362	          currentLessonData[semKey] = previousOwn[semKey];   // never blank it
  1363	          recheckOwnDocAfterLegacyLoss(semKey, callback);
  1364	        } else if (semKey in currentLessonData) {
  1365	          document.getElementById('storage-notice-banner')?.classList.add('hidden');
  1366	        }
  1367	      }
  1368	      console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
  1369	
  1370	      const outcome = await reloadSummer(myGeneration, previousSummer, 0);
  1371	      // A superseded reload renders nothing — the newer snapshot's own
  1372	      // callback already did (or will), with the same live object. A failed
  1373	      // one still renders: the non-summer semesters in this snapshot are new.
  1374	      if (outcome !== 'stale' && callback) callback(currentLessonData);
  1375	    });
  1376	
  1377	  // Own-doc semesters: one listener per document, plus the migration record.
  1378	  // They never bump globalListenerGeneration and never touch
  1379	  // lessonDataLoadedSuccessfully — an error here is shown on its own and makes
  1380	  // only that semester unwritable.
  1381	  ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc('storageMigrations')
  1382	    .onSnapshot(snap => {
  1383	      if (snap.metadata.fromCache && !snap.metadata.hasPendingWrites) return;
  1384	      storageMigrationState = snap.exists ? (snap.data() || {}) : {};
  1385	    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; }));
  1386	  for (const semKey of OWN_DOC_SEMESTERS) {
  1387	    ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey))
  1388	      .onSnapshot({ includeMetadataChanges: false }, snap => {
  1389	        if (snap.metadata.fromCache && !snap.metadata.hasPendingWrites) return;
  1390	        if (snap.exists) {
  1391	          ownDocSource[semKey] = 'ownDoc';
  1392	          currentLessonData = currentLessonData || {};
  1393	          currentLessonData[semKey] = ownDocLessonMap(snap.data());
  1394	          document.getElementById('storage-notice-banner')?.classList.add('hidden');
  1395	        } else if (ownDocSource[semKey] === 'ownDoc') {
  1396	          // Rolled back: the own document is gone — fall back to lessonData.
  1397	          ownDocSource[semKey] = 'legacy';
  1398	          const legacyMap = lastLegacyLessonData?.[semKey];
  1399	          if (legacyMap) currentLessonData[semKey] = legacyMap;
  1400	          else showStorageNotice(`⚠️ ${semKey} storage changed — please reload the page to see its lessons.`);
  1401	        } else {
  1402	          if (ownDocSource[semKey] !== 'error') ownDocSource[semKey] = 'legacy';
  1403	          return;   // nothing changed for this tab
  1404	        }
  1405	        if (callback) callback(currentLessonData);
  1406	      }, err => {
  1407	        console.error(`❌ ${ownDocIdFor(semKey)} listener error:`, err);
  1408	        ownDocSource[semKey] = 'error';
  1409	        showStorageNotice(`⚠️ ${semKey} lessons couldn't be loaded from their new storage — please reload the page.`);
  1410	      }));
  1411	  }
  1412	}
  1413	
  1414	// ─── Cut Projects (curriculum/cutProjects) ───────────
  1415	
  1416	async function loadCutProjects() {
  1417	  if (!curriculumDb) initCurriculumFirestore();
  1418	  try {
  1419	    const doc = await curriculumDb.collection('curriculum').doc('cutProjects').get();
  1420	    currentCutProjects = doc.exists ? doc.data() : {};
  1421	  } catch (err) {
  1422	    console.error('Error loading cut projects:', err);
  1423	    currentCutProjects = {};
  1424	  }
  1425	  return currentCutProjects;
  1426	}
  1427	
  1428	async function saveCutProjects(semesterKey, projects) {
  1429	  if (!curriculumDb) initCurriculumFirestore();
  1430	  const user = getAuthUser();
  1431	  await curriculumDb.collection('curriculum').doc('cutProjects').set({
  1432	    [semesterKey]: projects,
  1433	    lastUpdated: new Date().toISOString(),
  1434	    lastUpdatedBy: user?.name || 'Unknown'
  1435	  }, { merge: true });
  1580	async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
  1581	  if (lessonDataLoadedSuccessfully === false) {
  1582	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  1583	  }
  1584	  if (!curriculumDb) initCurriculumFirestore();
  1585	  const user = getAuthUser();
  1586	  lessonData.lastEditedBy = user?.name || 'Unknown';
  1587	  lessonData.lastEditedAt = new Date().toISOString();
  1588	
  1589	  // SDOC plans (Phase 2B) branch here — after the stamp, so every SDOC write
  1590	  // (the narrow Plan complete one included) carries lastEditedBy/At — and
  1591	  // BEFORE lessonStoreFor(), which keeps throwing for the type: its other six
  1592	  // callers fall through to curriculum/lessonData on anything that isn't
  1593	  // 'camp', and that throw is what keeps an SDOC key out of it.
  1594	  if (isDayOffYear(semesterKey)) return saveDayOffPlan(semesterKey, lessonKey, lessonData, fieldsToClear, opts.dayOffAuth);
  1595	
  1596	  console.log('💾 Attempting to save lesson:', { semesterKey, lessonKey, user: user?.email });
  1597	
  1598	  const hasContent = lessonHasContent(lessonData);
  1599	  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above.
  1600	  const fieldsToActuallyClear = [...fieldsToClear];
  1601	
  1602	  // Route by type, never by key (Phase 1, 1.1).
  1603	  if (lessonStoreFor(semesterKey) === 'camp') {
  1604	    // A planComplete-only payload, a photo-only payload, or a save that's only
  1605	    // clearing a field, is a legitimate narrow save, not a stale-state wipe
  1606	    // attempt — only block when there's neither real content nor an explicit
  1607	    // planComplete flag nor a photo field nor a field being intentionally
  1608	    // cleared (Data Safety Plan Stage 2C/3; photo fields added by the
  1609	    // backtracking audit's Phase 10, whose summer editor now sends only the
  1610	    // fields it changed — a photo replacement arrives with no text at all).
  1611	    const hasPhotoField = 'photoUrl' in lessonData || 'photoPath' in lessonData;
  1612	    if (!hasContent && !hasPhotoField && !('planComplete' in lessonData) && fieldsToActuallyClear.length === 0) {
  1613	      console.warn('⛔ saveSingleLesson blocked — all content fields empty, refusing to overwrite:', lessonKey);
  1614	      return;
  1615	    }
  1616	    // Strip empty content fields so stale in-memory empty strings never overwrite
  1617	    // real content that a teacher saved previously (mirrors saveSummerCampLessonData).
  1618	    const stripped = { ...lessonData };
  1619	    CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
  1620	    const cleanData = JSON.parse(JSON.stringify(stripped));
  1621	    // Apply clears AFTER the JSON sanitization pass — FieldValue.delete() is a
  1622	    // special sentinel object that a JSON round-trip would corrupt.
  1623	    fieldsToActuallyClear.forEach(f => { cleanData[f] = firebase.firestore.FieldValue.delete(); });
  1624	    // Every summer doc this app writes carries its season (camp seasons Phase
  1625	    // 0). A plain string, so it goes after the round-trip — and after the
  1626	    // clears, so no clear list can ever strip the stamp.
  1627	    cleanData.season = seasonForSemester(semesterKey);
  1628	    console.log('💾 Saving Summer Camp lesson to summerCamps_lessonData:', lessonKey);
  1629	    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semesterKey, lessonKey));
  1630	    await docRef.set(cleanData, { merge: true });
  1631	    console.log('✅ Saved Summer Camp lesson:', lessonKey);
  1632	
  1633	    // Read back the content fields we just wrote, forced to the server — this
  1634	    // is the check that would have caught both original May 2026 wipe
  1635	    // incidents within seconds instead of days (Data Safety Plan Stage 2E).
  1636	    // Intentionally cleared fields are expected to read back missing, so
  1637	    // they're excluded here rather than flagged as a failed write.
  1638	    const writtenContentFields = CONTENT_FIELDS.filter(f => f in cleanData && !fieldsToActuallyClear.includes(f));
  1639	    if (writtenContentFields.length > 0) {
  1640	      await verifySummerLessonWrite(docRef, writtenContentFields);
  1641	    }
  1642	    return;
  1643	  }
  1644	
  1645	  // Regular semester: curriculum/lessonData is one shared doc across every
  1646	  // semester. update() with a whole object assigned to the bare
  1647	  // semesterKey.lessonKey path replaces the ENTIRE lesson there — so write
  1648	  // explicit per-field dotted paths instead, touching only the fields
  1649	  // actually present in lessonData (Data Safety Plan Stage 2D).
  1650	  const { ref: weeklyRef, prefix } = weeklyLessonTarget(semesterKey);   // own-doc semester: its own doc (or "editing is paused")
  1651	  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear, prefix);
  1652	
  1653	  console.log(`💾 Saving to curriculum/${weeklyRef.id} with per-field paths:`, Object.keys(updates));
  1654	  try {
  1655	    await weeklyRef.update(updates);
  1656	    console.log('✅ Successfully saved lesson to Firestore!');
  1657	  } catch (error) {
  1658	    console.error('❌ Error saving lesson:', error);
  1659	    throw error;
  1660	  }
  1661	}
  1662	
  1663	// Backtracking audit, Phase 9: pure helper — computes the dotted-path update
  1664	// object for ONE lesson within the shared curriculum/lessonData document,
  1665	// given an already-finalized lessonData object. Extracted from
  1666	// saveSingleLesson()'s non-summer branch above so it can be reused by
  1667	// saveMultipleLessonFields() below without duplicating the stripping/clearing
  1668	// logic. Strips empty content fields the same way the summer branch does, by
  1669	// omitting their dotted path entirely — never sending an explicit empty
  1670	// string — and applies clears AFTER the JSON sanitization pass, since
  1671	// FieldValue.delete() is a special sentinel a JSON round-trip would corrupt.
  1672	function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = [], prefix = `${semesterKey}.`) {
  1673	  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above saveSingleLesson().
  1674	  const stripped = { ...lessonData };
  1675	  CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
  1676	  const cleanData = JSON.parse(JSON.stringify(stripped));
  1677	  fieldsToClear.forEach(f => { cleanData[f] = firebase.firestore.FieldValue.delete(); });
  1678	  const updates = {};
  1679	  for (const [field, value] of Object.entries(cleanData)) {
  1680	    updates[`${prefix}${lessonKey}.${field}`] = value;
  1681	  }
  1682	  return updates;
  1683	}
  1684	
  1685	// Backtracking audit, Phase 9: combine multiple lesson writes and/or
  1686	// whole-lesson deletes into ONE atomic Firestore .update() call — either
  1687	// every write/delete in the call lands, or none do. Closes the
  1688	// PARTIAL-FAILURE race that move/swap's prior sequential-writes design was
  1689	// vulnerable to (does NOT independently verify the given lessonData reflects
  1690	// current server state — see Phase 9's note in the plan for the deliberately
  1691	// deferred, separately-tracked stale-input race).
  1692	async function saveMultipleLessonFields(semesterKey, writes = [], deletes = []) {
  1693	  if (lessonDataLoadedSuccessfully === false) {
  1694	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  1695	  }
  1696	  if (lessonStoreFor(semesterKey) === 'camp') {
  1697	    // Camp-season lessons live in a separate per-lesson-document collection — no
  1698	    // single-document atomicity is available across lessons there. Not
  1699	    // reachable today (the admin grid's move/swap UI is gated away from
  1700	    // summer semesters), but this guard exists so a future caller can't
  1701	    // silently get a false sense of atomicity if that ever changes.
  1702	    throw new Error('saveMultipleLessonFields() does not support camp seasons — use saveSingleLesson() per lesson instead.');
  1703	  }
  1704	  if (!curriculumDb) initCurriculumFirestore();
  1705	  const { ref: weeklyRef, prefix } = weeklyLessonTarget(semesterKey);
  1706	  const user = getAuthUser();
  1707	  const combined = {};
  1708	  for (const { lessonKey, lessonData, fieldsToClear } of writes) {
  1709	    lessonData.lastEditedBy = user?.name || 'Unknown';
  1710	    lessonData.lastEditedAt = new Date().toISOString();
  1711	    Object.assign(combined, buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear || [], prefix));
  1712	  }
  1713	  for (const lessonKey of deletes) {
  1714	    combined[`${prefix}${lessonKey}`] = firebase.firestore.FieldValue.delete();
  1715	  }
  1716	  combined.lastUpdated = new Date().toISOString();
  1717	  combined.lastUpdatedBy = user?.name || 'Unknown';
  1718	  await weeklyRef.update(combined);
  1719	}
  1720	
  1721	// ─── Photo Upload (Firebase Storage) ─────────────────
  1722	
  1723	function getFirebaseStorage() {
  1724	  // Single init path: initFirebaseApp() (js/firebase-config.js) is the one
  1725	  // place that knows whether this page is in emulator mode, so a bare
  1726	  // initializeApp(FIREBASE_CONFIG) here could point Storage at production
  1727	  // while Firestore sits on the emulator.
  1728	  initFirebaseApp();
  1729	  return firebase.storage();
  1730	}
  1731	
  1732	// Backtracking audit, Phase 5 (R3-5, R3-6, R4-7): every upload gets a path
  1733	// that is unique PER UPLOAD, not per lesson. With a deterministic path the
  1734	// replacement upload overwrote the live object before Firestore confirmed
  1735	// the save (a failed save then pointed at a photo that no longer existed),
  1736	// a swap could put one lesson's replacement on top of the other lesson's
  1737	// still-referenced object, and the summer modal's "delete the old path"
  1738	// step deleted the object it had just uploaded. Callers keep the OLD path,
  1739	// save, then delete it only after a confirmed save (see saveTeacherEdit(),
  1740	// saveAdminEdit(), and the summer modal's saveLesson()). Date.now() alone is
  1741	// millisecond resolution — the random suffix keeps two near-simultaneous
  1742	// uploads for the same lesson apart.
  1743	function uniquePhotoSuffix() {
  1744	  return `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
  1745	}
  1746	
  1747	function getPhotoPath(semesterKey, lessonKey /* filename: ignored — resizeImage() always re-encodes to JPEG */) {
  1748	  // Store at curriculum/{semester}/{lessonKey}/demo-{unique}.jpg
  1749	  return `curriculum/${semesterKey}/${lessonKey}/demo-${uniquePhotoSuffix()}.jpg`;
  1750	}
  1751	
  1752	async function uploadLessonPhoto(semesterKey, lessonKey, file) {
  1753	  if (typeof firebase.storage !== 'function') {
  1754	    throw new Error('Firebase Storage SDK not loaded. Hard refresh and try again.');
  1755	  }
  1756	  const storage = getFirebaseStorage();
  1757	  const path = getPhotoPath(semesterKey, lessonKey, 'demo.jpg');
  1758	  const ref = storage.ref(path);
  1759	
  1760	  // Resize before upload (max 1200px wide, JPEG 80% quality)
  1761	  const resized = await resizeImage(file, 1200, 0.8);
  1762	
  1763	  const snapshot = await ref.put(resized, { contentType: 'image/jpeg' });
  1764	  const url = await snapshot.ref.getDownloadURL();
  1765	  return { url, path };

exec
/bin/zsh -lc "nl -ba js/firebase-data.js | sed -n '850,1215p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
   850	      return { semKey, season };
   851	    });
   852	}
   853	
   854	// One camp season's lessons, or an empty map when legacy mode cannot serve it.
   855	async function loadOneCampSeason(plan, opts = {}) {
   856	  if (plan.unavailable) { currentSummerSessionsBySemester[plan.semKey] = []; return {}; }
   857	  return await loadSummerCampData({ ...opts, season: plan.season, semKey: plan.semKey });
   858	}
   859	
   860	// Initial load for own-doc semesters and the migration record (called by
   861	// loadLessonData, after the legacy document). A failed read of the record is
   862	// treated as "not verified" (edits stay paused); a failed read of a semester's own
   863	// document marks it 'error' — shown from whatever lessonData still holds, never
   864	// writable, with a visible notice.
   865	async function loadOwnDocSemesters() {
   866	  if (!curriculumDb) initCurriculumFirestore();
   867	  try {
   868	    const m = await curriculumDb.collection('curriculum').doc('storageMigrations').get();
   869	    storageMigrationState = m.exists ? (m.data() || {}) : {};
   870	  } catch (err) {
   871	    console.warn('⚠️ Could not read curriculum/storageMigrations — own-doc semesters stay read-only:', err);
   872	    storageMigrationState = {};
   873	  }
   874	  for (const semKey of OWN_DOC_SEMESTERS) {
   875	    try {
   876	      const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get();
   877	      if (own.exists) {
   878	        ownDocSource[semKey] = 'ownDoc';
   879	        currentLessonData[semKey] = ownDocLessonMap(own.data());
   880	      } else {
   881	        ownDocSource[semKey] = 'legacy';
   882	      }
   883	    } catch (err) {
   884	      console.error(`❌ Could not read curriculum/${ownDocIdFor(semKey)}:`, err);
   885	      ownDocSource[semKey] = 'error';
   886	      showStorageNotice(`⚠️ ${semKey} lessons couldn't be loaded from their new storage — please reload the page.`);
   887	    }
   888	  }
   889	}
   890	
   891	// The legacy snapshot no longer holds an own-doc semester this tab was showing
   892	// from lessonData: the move just happened (or the page is stale). Never blank it —
   893	// keep the lessons on screen, look for its own document, and if that isn't there
   894	// either, say so.
   895	async function recheckOwnDocAfterLegacyLoss(semKey, callback) {
   896	  try {
   897	    const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get({ source: 'server' });
   898	    if (own.exists) {
   899	      ownDocSource[semKey] = 'ownDoc';
   900	      currentLessonData[semKey] = ownDocLessonMap(own.data());
   901	      if (callback) callback(currentLessonData);
   902	      return;
   903	    }
   904	  } catch (err) {
   905	    console.warn(`⚠️ Could not check curriculum/${ownDocIdFor(semKey)}:`, err);
   906	  }
   907	  showStorageNotice(`⚠️ ${semKey} moved to new storage — please reload the page to see its latest lessons.`);
   908	}
   909	
   910	async function loadLessonData() {
   911	  if (!curriculumDb) initCurriculumFirestore();
   912	  try {
   913	    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
   914	    currentLessonData = doc.exists ? doc.data() : {};
   915	    lastLegacyLessonData = doc.exists ? doc.data() : {};
   916	    await loadOwnDocSemesters();
   917	
   918	    // Every camp season gets its own map (Phase 1, 1.4) — no literal key.
   919	    try {
   920	      const plans = campSeasonLoadPlan();
   921	      console.log('📚 Loading camp seasons:', plans.map(p => `${p.semKey}${p.season ? ` (${p.season})` : ' (unfiltered)'}`).join(', ') || 'none');
   922	      for (const plan of plans) {
   923	        currentLessonData[plan.semKey] = await loadOneCampSeason(plan);
   924	        console.log(`📚 ${plan.semKey}: ${Object.keys(currentLessonData[plan.semKey]).length} lessons`);
   925	      }
   926	      // School Day Off Camps years: their own three collections. A failure
   927	      // trips the same app-wide guard — loud, never a quiet empty list.
   928	      for (const yearKey of dayOffYearKeys()) {
   929	        currentLessonData[yearKey] = await loadDayOffCampData({ yearKey });
   930	        console.log(`📚 ${yearKey}: ${Object.keys(currentLessonData[yearKey]).length} day-off camp plans`);
   931	      }
   932	      lessonDataLoadedSuccessfully = true;
   933	    } catch (err) {
   934	      // One season failing trips the guard for the whole app: a partially
   935	      // loaded model is not a safe base for any writer, in any semester.
   936	      console.error('❌ Could not load camp season data:', err);
   937	      lessonDataLoadedSuccessfully = false;
   938	    }
   939	  } catch (err) {
   940	    console.error('Error loading lesson data:', err);
   941	    currentLessonData = {};
   942	    lessonDataLoadedSuccessfully = false;
   943	  }
   944	  return currentLessonData;
   945	}
   946	
   947	// Whole-semester bulk writer (restoreFromBackup, createNewSemester,
   948	// createLessonSlotsForRoster). Guarded the same way as
   949	// saveSingleLesson(): after a failed load, `lessons` is built from an empty or
   950	// partial currentLessonData (or, for restoreFromBackup, would land over a
   951	// semester whose current state this client never confirmed), and merge:true
   952	// would still write it over the real semester map. Throws rather than no-ops —
   953	// every caller treats a resolved promise as "the write landed" (backtracking
   954	// audit, Phase 11).
   955	async function saveLessonData(semesterKey, lessons) {
   956	  if (lessonDataLoadedSuccessfully === false) {
   957	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
   958	  }
   959	  if (!curriculumDb) initCurriculumFirestore();
   960	
   961	  // Route by the semester's TYPE, never by its key (Phase 1, 1.1): camp
   962	  // seasons go to the per-lesson collection (also dodging the 1MB doc limit),
   963	  // and any other type is refused rather than misrouted.
   964	  if (lessonStoreFor(semesterKey) === 'camp') {
   965	    return await saveSummerCampLessonData(semesterKey, lessons);
   966	  }
   967	
   968	  // Regular semester: save to curriculum/lessonData — or, for an own-doc
   969	  // semester, to its own document (the whole map at the top level).
   970	  const user = getAuthUser();
   971	  const stamp = { lastUpdated: new Date().toISOString(), lastUpdatedBy: user?.name || 'Unknown' };
   972	  if (isOwnDocSemester(semesterKey)) {
   973	    const { ref } = weeklyLessonTarget(semesterKey);   // throws "editing is paused" until verified
   974	    await ref.set({ ...lessons, ...stamp }, { merge: true });
   975	    return;
   976	  }
   977	  await curriculumDb.collection('curriculum').doc('lessonData').set({
   978	    [semesterKey]: lessons,
   979	    ...stamp
   980	  }, { merge: true });
   981	}
   982	
   983	// Explicitly delete a single lesson key from the nested map.
   984	// More reliable than resaving the full semester when cutting a project,
   985	// because Firestore's merge:true may not remove nested map keys.
   986	async function deleteLessonKey(semesterKey, lessonKey) {
   987	  if (!curriculumDb) initCurriculumFirestore();
   988	  const user = getAuthUser();
   989	  const { ref, prefix } = weeklyLessonTarget(semesterKey);
   990	  await ref.update({
   991	    [`${prefix}${lessonKey}`]: firebase.firestore.FieldValue.delete(),
   992	    lastUpdated: new Date().toISOString(),
   993	    lastUpdatedBy: user?.name || 'Unknown'
   994	  });
   995	}
   996	
   997	async function saveSummerCampLessonData(semKey, lessons) {
   998	  if (!curriculumDb) initCurriculumFirestore();
   999	  // Resolved once, before any batch work — a semester with no valid season
  1000	  // throws here, so nothing is queued.
  1001	  const season = seasonForSemester(semKey);
  1002	  const user = getAuthUser();
  1003	  const batch = curriculumDb.batch();
  1004	
  1005	  console.log('💾 Saving Summer Camp lesson data...', { semKey, season });
  1006	
  1007	  const hasContent = lessonHasContent;
  1008	
  1009	  let writeCount = 0;
  1010	  // Save each lesson as a separate document (lessonKey as doc ID)
  1011	  for (const [lessonKey, lessonData] of Object.entries(lessons)) {
  1012	    // Never overwrite existing docs with empty content — protects against stale in-memory state
  1013	    if (!hasContent(lessonData)) continue;
  1014	    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
  1015	    // Strip empty content fields so stale in-memory empty strings never overwrite
  1016	    // real content that a teacher saved in a different browser session.
  1017	    const stripped = { ...lessonData };
  1018	    CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
  1019	    // JSON round-trip strips undefined values that Firestore rejects with invalid-argument
  1020	    const cleanData = JSON.parse(JSON.stringify({
  1021	      ...stripped,
  1022	      season,
  1023	      lastUpdated: new Date().toISOString(),
  1024	      lastUpdatedBy: user?.name || 'Unknown'
  1025	    }));
  1026	    batch.set(docRef, cleanData, { merge: true });
  1027	    writeCount++;
  1028	  }
  1029	
  1030	  await batch.commit();
  1031	  console.log(`✅ Saved ${writeCount} Summer Camp lesson slots (skipped ${Object.keys(lessons).length - writeCount} empty)`);
  1032	}
  1033	
  1034	// Season-scoped, and it no longer swallows its errors (Phase 1, 1.4): a
  1035	// failure used to return {} — every camp-complete checkbox unchecked — and the
  1036	// next click would write campComplete: false over a true. The caller renders
  1037	// an error state instead. Two equality filters need no composite index.
  1038	async function loadCampCompleteData(semKey, teacher) {
  1039	  if (!curriculumDb) initCurriculumFirestore();
  1040	  const result = {};
  1041	  let query = curriculumDb.collection('summerCamps_campComplete').where('teacher', '==', teacher);
  1042	  if (seasonRegistryMode !== 'legacy') query = query.where('season', '==', seasonForSemester(semKey));
  1043	  const snapshot = await query.get();
  1044	  snapshot.forEach(doc => {
  1045	    const data = doc.data();
  1046	    result[data.campName] = data.campComplete || false;
  1047	  });
  1048	  return result;
  1049	}
  1050	
  1051	// Same load guard as the lesson writers (saveLessonData/saveSingleLesson):
  1052	// after a failed load the camp view was drawn from nothing, so its checkbox
  1053	// state is not something to write back.
  1054	async function saveCampComplete(semKey, teacher, campName, campComplete) {
  1055	  if (lessonDataLoadedSuccessfully === false) {
  1056	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  1057	  }
  1058	  if (!curriculumDb) initCurriculumFirestore();
  1059	  const season = seasonForSemester(semKey);
  1060	  // Merge, not replace: the doc keeps whatever else it carries — today
  1061	  // nothing, after the Summer Camp App's backfill its `season` stamp (which
  1062	  // this write re-asserts). A full set() here would have erased the stamp on
  1063	  // the first toggle after the backfill.
  1064	  await curriculumDb.collection('summerCamps_campComplete').doc(summerDocIdFor(semKey, `${teacher}|||${campName}`)).set({
  1065	    teacher,
  1066	    campName,
  1067	    campComplete,
  1068	    season,
  1069	    updatedAt: new Date().toISOString()
  1070	  }, { merge: true });
  1071	}
  1072	
  1073	async function getSummerLessonQaThread(semKey, lessonKey) {
  1074	  if (!curriculumDb) initCurriculumFirestore();
  1075	  const doc = await curriculumDb.collection('summerCamps_prepHelpQueue').doc(summerDocIdFor(semKey, lessonKey)).get();
  1076	  if (!doc.exists) return [];
  1077	  return doc.data().qaThread || [];
  1078	}
  1079	
  1080	// semKey is the MODAL's semester (captured when it opened), not the header
  1081	// selector's — that can move while the modal is open. Only the create path
  1082	// stamps `season`; a later message never re-stamps or moves a doc between
  1083	// seasons (the Summer Camp App's Season.patch() rule).
  1084	async function sendSummerLessonQaMessage(semKey, lessonKey, lesson, newMsg) {
  1085	  if (lessonDataLoadedSuccessfully === false) {
  1086	    throw new Error('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  1087	  }
  1088	  if (!curriculumDb) initCurriculumFirestore();
  1089	  // Resolved before the read so an invalid semester is refused before anything is touched.
  1090	  const season = seasonForSemester(semKey);
  1091	  const docRef = curriculumDb.collection('summerCamps_prepHelpQueue').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
  1092	  const docSnap = await docRef.get();
  1093	  const isAdmin = newMsg.from === 'admin';
  1094	
  1095	  if (!docSnap.exists) {
  1096	    await docRef.set({
  1097	      queueType: 'teachers',
  1098	      campTopic: lesson.campName,
  1099	      project: lesson.projectTitle,
  1100	      projectTitle: lesson.projectTitle,
  1101	      block: lesson.block,
  1102	      teacher: lesson.teacher,
  1103	      lessonKey,
  1104	      season,
  1105	      askedBy: newMsg.name,
  1106	      question: newMsg.message,
  1107	      qaThread: [newMsg],
  1108	      status: 'Open',
  1109	      createdAt: firebase.firestore.FieldValue.serverTimestamp(),
  1110	      lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
  1111	    });
  1112	  } else {
  1113	    await docRef.update({
  1114	      qaThread: firebase.firestore.FieldValue.arrayUnion(newMsg),
  1115	      status: isAdmin ? 'Resolved' : 'Open',
  1116	      lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
  1117	    });
  1118	  }
  1119	}
  1120	
  1121	async function deleteLessonData(semesterKey) {
  1122	  if (!curriculumDb) initCurriculumFirestore();
  1123	  // An own-doc semester's lessons aren't in lessonData (and the rules fence the
  1124	  // key); deleting it is disabled until the follow-up plan routes it.
  1125	  if (isOwnDocSemester(semesterKey)) throw new Error(`"${semesterKey}" can't be deleted while its storage is being changed.`);
  1126	  await curriculumDb.collection('curriculum').doc('lessonData').update({
  1127	    [semesterKey]: firebase.firestore.FieldValue.delete()
  1128	  });
  1129	}
  1130	
  1131	// Forced-server read of one semester's whole lesson map in curriculum/lessonData
  1132	// (null when absent). Bypasses both the in-memory model and the SDK cache —
  1133	// used where the local cache is known to be untrustworthy for this key, e.g.
  1134	// createNewSemester()'s pre-check (deleteSemester() drops a key locally even
  1135	// when its server-side delete failed). Backtracking audit, Phase 11.
  1136	async function readServerSemesterLessonMap(semesterKey) {
  1137	  if (!curriculumDb) initCurriculumFirestore();
  1138	  return await readWeeklySemesterMap(semesterKey, { source: 'server' });
  1139	}
  1140	
  1141	async function backupLessonData(semesterKey) {
  1142	  if (!curriculumDb) initCurriculumFirestore();
  1143	  const existing = currentLessonData?.[semesterKey];
  1144	  if (!existing || Object.keys(existing).length === 0) return 0;
  1145	  const count = Object.keys(existing).length;
  1146	  const user = getAuthUser();
  1147	  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
  1148	    [semesterKey]: existing,
  1149	    backupDate: new Date().toISOString(),
  1150	    backupBy: user?.name || 'Unknown'
  1151	  }, { merge: true });
  1152	  return count;
  1153	}
  1154	
  1155	async function restoreFromBackup(semesterKey) {
  1156	  if (!curriculumDb) initCurriculumFirestore();
  1157	  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
  1158	  if (!backupDoc.exists) return null;
  1159	  const backupData = backupDoc.data();
  1160	  const lessons = backupData?.[semesterKey];
  1161	  if (!lessons || Object.keys(lessons).length === 0) return null;
  1162	  await saveLessonData(semesterKey, lessons);
  1163	  return Object.keys(lessons).length;
  1164	}
  1165	
  1166	// "Which copy of a lesson is newer", by lastEditedAt — the only revision
  1167	// marker the data has (a client wall-clock heuristic: ties and missing values
  1168	// resolve to "not newer"). Shared by the listener merge below and the summer
  1169	// editor's own adoption/re-install logic (Backtracking audit Phase 10).
  1170	function lessonEditedAtMs(lesson) {
  1171	  return Date.parse(lesson?.lastEditedAt || '') || 0;
  1172	}
  1173	
  1174	// The fields a saved summerCamps_lessonData doc contributes to a lesson slot
  1175	// (everything else on the slot — teacher, camp, materials, sharedWith, class
  1176	// size… — is rebuilt from the other collections on every reload and must
  1177	// always come from the fresh read).
  1178	const SUMMER_SAVED_FIELDS = [...CONTENT_FIELDS, 'photoUrl', 'photoPath', 'planComplete', 'lastEditedBy', 'lastEditedAt'];
  1179	// A reload's read can only plausibly predate a save this recent; a stamp
  1180	// older than this — or further than this into the future — is a skewed clock
  1181	// or a doc deleted/restored underneath us, and the fresh read wins.
  1182	const SUMMER_KEEP_MINE_WINDOW_MS = 10 * 60 * 1000;
  1183	// When the merge keeps an in-memory copy, the server copy it displaced is
  1184	// parked here so the summer editor can fall back to it if the in-flight save
  1185	// that made the in-memory copy "newer" then fails (see openLessonModal()).
  1186	// Keyed by SEMESTER and lesson (Phase 1, 1.4): two camp seasons legitimately
  1187	// share a lesson key — same teacher, camp, block and project in 2026 and
  1188	// 2027 — and a single-keyed map would park one season's server copy under
  1189	// the other's, then hand it back to the wrong editor.
  1190	const displacedSummerServerCopies = new Map();
  1191	const displacedKey = (semKey, lessonKey) => `${semKey}|${lessonKey}`;
  1192	
  1193	// Backtracking audit Phase 7, handed over by Phase 10: a reload's collection
  1194	// read can predate a save that has since landed (or is in flight,
  1195	// optimistically installed). The fresh read is authoritative for WHICH
  1196	// lessons exist and for every scaffold-derived field; for the saved-doc
  1197	// fields, keep the in-memory copy when it is strictly newer — recently — than
  1198	// the freshly read one. The in-memory OBJECT is kept (updated in place), so
  1199	// the editor's identity checks on its optimistic entry still hold.
  1200	// protectedKeys (SDOC, Phase 2B): lessons whose fresh copy is a VERIFIED save
  1201	// newer than this reload's query — taken whole, never overridden by the
  1202	// clock-based keepMine below and never parked (a faster clock on an older
  1203	// in-memory copy must not put old text back). Defaults to the set
  1204	// loadDayOffCampData() attached to its result; summer results carry none.
  1205	function mergeSummerReload(semKey, previous, fresh, protectedKeys = fresh?.[DAY_OFF_PROTECTED] || null) {
  1206	  // A lesson the fresh scaffold no longer has is gone — nothing parked for it
  1207	  // may be resurrected by an editor fallback later. Only THIS semester's
  1208	  // parked copies are considered: pruning globally would evict the other
  1209	  // season's on every reload.
  1210	  const prefix = `${semKey}|`;
  1211	  for (const key of displacedSummerServerCopies.keys()) {
  1212	    if (!key.startsWith(prefix)) continue;
  1213	    if (!(key.slice(prefix.length) in fresh)) displacedSummerServerCopies.delete(key);
  1214	  }
  1215	  if (!previous) return fresh;

exec
/bin/zsh -lc "nl -ba js/firebase-data.js | sed -n '1240,1420p' && rg -n \"lessonData|currentLessonData|saveLessonData|saveSingleLesson|saveMultipleLessonFields|deleteLessonKey|readServerSemesterLessonMap|weeklyLessonTarget|sendTeacherQaMessage|sendHelpResponse|sendQaReply\" js --glob '"'!firebase-data.js'"' --glob '"'!*.min.js'"'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
  1240	// shared curriculum/lessonData doc re-runs the summer collection reload.
  1241	// Its outcome now drives the load-guard and the banner like the initial
  1242	// load does — a failure trips them, a later success resets them — and only
  1243	// the LATEST reload's outcome may do so: callbacks resolve out of order, and
  1244	// unsubscribing a listener does not cancel its in-flight callback, so the
  1245	// generation counter is module-scoped across every setupLessonDataListener()
  1246	// call (and bumped by the call itself, so an old listener's in-flight reload
  1247	// is stale from the moment it is replaced). A tripped guard blocks every
  1248	// writer in the app, so a failed reload is retried a bounded number of times
  1249	// on its own — a wifi blip self-heals, a real outage keeps the banner.
  1250	// Handed over by Phase 10: the summer cache is kept in place for the ~1.5 s
  1251	// the reload takes (it used to vanish, so the summer view rendered nothing
  1252	// and an in-flight save's optimistic entry had no map to live in), and the
  1253	// reload is merged per lesson keeping the newer copy (mergeSummerReload).
  1254	const SUMMER_RELOAD_RETRY_DELAYS_MS = [5000, 15000];
  1255	// The camp seasons currently in memory, by semester key.
  1256	function snapshotCampSeasons() {
  1257	  const out = {};
  1258	  for (const semKey of Object.keys(currentLessonData || {})) {
  1259	    if ((isCampSeason(semKey) || isDayOffYear(semKey)) && currentLessonData[semKey]) out[semKey] = currentLessonData[semKey];
  1260	  }
  1261	  return out;
  1262	}
  1263	
  1264	// Set by setupLessonDataListener() so a season-registry mode change (legacy →
  1265	// filtered, or unknown healing) re-runs the summer load through that
  1266	// listener's own generation-gated path — never a second, competing one
  1267	// (Phase 1, 1.3).
  1268	let summerReloadHook = null;
  1269	async function reloadSummerForModeChange() {
  1270	  if (typeof summerReloadHook !== 'function') return 'no-listener';
  1271	  return await summerReloadHook();
  1272	}
  1273	
  1274	function setupLessonDataListener(callback) {
  1275	  console.log('📚 Setting up lesson data listener...');
  1276	  if (!curriculumDb) initCurriculumFirestore();
  1277	  globalListenerGeneration++; // whatever the previous listener still has in flight is now stale
  1278	  if (lessonDataUnsubscribe) lessonDataUnsubscribe();
  1279	  // The own-doc listeners (Spring 2026 storage move) are torn down together.
  1280	  while (ownDocUnsubscribes.length) { try { ownDocUnsubscribes.pop()(); } catch (e) { /* already gone */ } }
  1281	
  1282	  // One reload attempt for one snapshot generation. Only the latest
  1283	  // generation may touch the guard, the banner, or the summer cache.
  1284	  // Resolves 'ok' | 'failed' | 'stale'. Only 'stale' means this generation's
  1285	  // outcome was discarded (a newer snapshot took over while it ran).
  1286	  const reloadSummer = async (myGeneration, previousSummer, attempt) => {
  1287	    const isCurrent = () => myGeneration === globalListenerGeneration;
  1288	    try {
  1289	      console.log('📚 Attempting to load camp season data...' + (attempt ? ` (retry ${attempt})` : ''));
  1290	      const plans = campSeasonLoadPlan();
  1291	      const fresh = {};
  1292	      for (const plan of plans) fresh[plan.semKey] = await loadOneCampSeason(plan, { isCurrent });
  1293	      const dayOffKeys = dayOffYearKeys();
  1294	      for (const yearKey of dayOffKeys) fresh[yearKey] = await loadDayOffCampData({ yearKey, isCurrent });
  1295	      if (!isCurrent()) { console.log('📚 Camp season reload superseded by a newer snapshot — ignoring its result'); return 'stale'; }
  1296	      for (const yearKey of dayOffKeys) {
  1297	        currentLessonData[yearKey] = mergeSummerReload(yearKey, previousSummer?.[yearKey], fresh[yearKey]);
  1298	        healDayOffYearAfterReload(yearKey, fresh[yearKey]);
  1299	      }
  1300	      for (const plan of plans) {
  1301	        // Each season merges against ITS OWN previous map — mergeSummerReload
  1302	        // prunes parked copies that are absent from `fresh`, so merging one
  1303	        // season against another's would evict the other's on every reload.
  1304	        currentLessonData[plan.semKey] = mergeSummerReload(plan.semKey, previousSummer?.[plan.semKey], fresh[plan.semKey]);
  1305	      }
  1306	      console.log('📚 Camp seasons loaded:', plans.map(p => `${p.semKey}=${Object.keys(fresh[p.semKey]).length}`).join(' '));
  1307	      lessonDataLoadedSuccessfully = true;
  1308	      document.getElementById('lesson-load-error-banner')?.classList.add('hidden');
  1309	      return 'ok';
  1310	    } catch (err) {
  1311	      console.error('❌ Could not load camp season / day-off camp data:', err);
  1312	      if (!isCurrent()) return 'stale';
  1313	      lessonDataLoadedSuccessfully = false;
  1314	      document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
  1315	      const delay = SUMMER_RELOAD_RETRY_DELAYS_MS[attempt];
  1316	      if (delay !== undefined) {
  1317	        setTimeout(() => {
  1318	          if (!isCurrent()) return; // a newer snapshot has taken over
  1319	          reloadSummer(myGeneration, snapshotCampSeasons(), attempt + 1).then(outcome => { if (outcome === 'ok' && callback) callback(currentLessonData); });
  1320	        }, delay);
  1321	      }
  1322	      return 'failed';
  1323	    }
  1324	  };
  1325	
  1326	  // The registry-change entry point: same reload, same generation gate, and it
  1327	  // renders through the same callback when it is still the current generation.
  1328	  summerReloadHook = async () => {
  1329	    const myGeneration = ++globalListenerGeneration;
  1330	    const outcome = await reloadSummer(myGeneration, snapshotCampSeasons(), 0);
  1331	    if (outcome !== 'stale' && callback) callback(currentLessonData);
  1332	    return outcome;
  1333	  };
  1334	
  1335	  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
  1336	    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
  1337	      // Skip cache-only updates
  1338	      if (doc.metadata.fromCache && !doc.metadata.hasPendingWrites) {
  1339	        console.log('📚 Skipping cache-only snapshot, waiting for server data...');
  1340	        return;
  1341	      }
  1342	      console.log('📚 Lesson data snapshot received, from cache:', doc.metadata.fromCache, 'exists:', doc.exists);
  1343	      if (!doc.exists) return;
  1344	
  1345	      const myGeneration = ++globalListenerGeneration;
  1346	      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
  1347	      // in their own collection, so carry their current maps across the swap
  1348	      // and let the reload below refresh each one (Phase 1, 1.4).
  1349	      const previousSummer = snapshotCampSeasons();
  1350	      // Own-doc semesters (Spring 2026 storage move): their lessons aren't in this
  1351	      // document once moved, so carry them across the swap like the camp seasons —
  1352	      // their own listeners below keep them current.
  1353	      const previousOwn = {};
  1354	      for (const semKey of OWN_DOC_SEMESTERS) if (currentLessonData?.[semKey]) previousOwn[semKey] = currentLessonData[semKey];
  1355	      currentLessonData = doc.data();
  1356	      lastLegacyLessonData = doc.data();
  1357	      for (const [semKey, map] of Object.entries(previousSummer)) currentLessonData[semKey] = map;
  1358	      for (const semKey of OWN_DOC_SEMESTERS) {
  1359	        if (ownDocSource[semKey] === 'ownDoc' || ownDocSource[semKey] === 'error') {
  1360	          if (previousOwn[semKey]) currentLessonData[semKey] = previousOwn[semKey];
  1361	        } else if (!(semKey in currentLessonData) && previousOwn[semKey]) {
  1362	          currentLessonData[semKey] = previousOwn[semKey];   // never blank it
  1363	          recheckOwnDocAfterLegacyLoss(semKey, callback);
  1364	        } else if (semKey in currentLessonData) {
  1365	          document.getElementById('storage-notice-banner')?.classList.add('hidden');
  1366	        }
  1367	      }
  1368	      console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
  1369	
  1370	      const outcome = await reloadSummer(myGeneration, previousSummer, 0);
  1371	      // A superseded reload renders nothing — the newer snapshot's own
  1372	      // callback already did (or will), with the same live object. A failed
  1373	      // one still renders: the non-summer semesters in this snapshot are new.
  1374	      if (outcome !== 'stale' && callback) callback(currentLessonData);
  1375	    });
  1376	
  1377	  // Own-doc semesters: one listener per document, plus the migration record.
  1378	  // They never bump globalListenerGeneration and never touch
  1379	  // lessonDataLoadedSuccessfully — an error here is shown on its own and makes
  1380	  // only that semester unwritable.
  1381	  ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc('storageMigrations')
  1382	    .onSnapshot(snap => {
  1383	      if (snap.metadata.fromCache && !snap.metadata.hasPendingWrites) return;
  1384	      storageMigrationState = snap.exists ? (snap.data() || {}) : {};
  1385	    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; }));
  1386	  for (const semKey of OWN_DOC_SEMESTERS) {
  1387	    ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey))
  1388	      .onSnapshot({ includeMetadataChanges: false }, snap => {
  1389	        if (snap.metadata.fromCache && !snap.metadata.hasPendingWrites) return;
  1390	        if (snap.exists) {
  1391	          ownDocSource[semKey] = 'ownDoc';
  1392	          currentLessonData = currentLessonData || {};
  1393	          currentLessonData[semKey] = ownDocLessonMap(snap.data());
  1394	          document.getElementById('storage-notice-banner')?.classList.add('hidden');
  1395	        } else if (ownDocSource[semKey] === 'ownDoc') {
  1396	          // Rolled back: the own document is gone — fall back to lessonData.
  1397	          ownDocSource[semKey] = 'legacy';
  1398	          const legacyMap = lastLegacyLessonData?.[semKey];
  1399	          if (legacyMap) currentLessonData[semKey] = legacyMap;
  1400	          else showStorageNotice(`⚠️ ${semKey} storage changed — please reload the page to see its lessons.`);
  1401	        } else {
  1402	          if (ownDocSource[semKey] !== 'error') ownDocSource[semKey] = 'legacy';
  1403	          return;   // nothing changed for this tab
  1404	        }
  1405	        if (callback) callback(currentLessonData);
  1406	      }, err => {
  1407	        console.error(`❌ ${ownDocIdFor(semKey)} listener error:`, err);
  1408	        ownDocSource[semKey] = 'error';
  1409	        showStorageNotice(`⚠️ ${semKey} lessons couldn't be loaded from their new storage — please reload the page.`);
  1410	      }));
  1411	  }
  1412	}
  1413	
  1414	// ─── Cut Projects (curriculum/cutProjects) ───────────
  1415	
  1416	async function loadCutProjects() {
  1417	  if (!curriculumDb) initCurriculumFirestore();
  1418	  try {
  1419	    const doc = await curriculumDb.collection('curriculum').doc('cutProjects').get();
  1420	    currentCutProjects = doc.exists ? doc.data() : {};
js/app.js:171:  if (lessonDataLoadedSuccessfully === false) {
js/app.js:392:  if (!currentLessonData) await loadLessonData();
js/app.js:393:  const lessons = currentLessonData?.[semKey];
js/app.js:537:  const lessons = currentLessonData?.[semKey];
js/app.js:649:  const lessons = currentLessonData?.[semKey];
js/app.js:665:  if (!currentLessonData) {
js/app.js:673:  if (lessonDataLoadedSuccessfully === false) {
js/app.js:682:    currentLessonData = data;
js/app.js:694:    const lessons = currentLessonData?.[semKey];
js/app.js:713:  const lessons = currentLessonData?.[semKey];
js/app.js:842:      const lessons = currentLessonData?.[semKey];
js/app.js:901:  const lessons = currentLessonData?.[semKey];
js/app.js:1058:  const lessons = currentLessonData?.[semKey];
js/app.js:1244:  const lesson = currentLessonData?.[semKey]?.[key] || null;
js/app.js:1276:  const lessons = currentLessonData?.[semKey];
js/app.js:1413:  const lessons = currentLessonData?.[semKey];
js/app.js:1507:  const lessons = currentLessonData?.[semKey];
js/app.js:1615:  const lessons = currentLessonData?.[semKey];
js/app.js:1735:  if (camps.some(c => [...dayOffCampTitles(c).keys()].some(t => !currentLessonData?.[yearKey]?.[dayOffLessonKey(yearKey, c.id, t)]))) rebuildDayOffSlots(yearKey);
js/app.js:1736:  const slots = currentLessonData?.[yearKey] || {};
js/app.js:1769:          const editable = canEditDayOffPlan(slot) && lessonDataLoadedSuccessfully !== false;
js/app.js:1808:  const slot = currentLessonData?.[yearKey]?.[lessonKey];
js/app.js:1813:    const result = await saveSingleLesson(yearKey, lessonKey, { planComplete: requested }, [], { dayOffAuth: dayOffAuthFor(yearKey) });
js/app.js:1832:  renderSummerCampView(document.getElementById('tv-content'), currentLessonData?.[semKey]);
js/app.js:2298:      const lessons = currentLessonData?.[semKey];
js/app.js:2356:      const liveLesson = () => currentLessonData?.[semKey]?.[lessonKey];
js/app.js:2365:        await saveSingleLesson(semKey, lessonKey, payload);
js/app.js:2366:        // saveSingleLesson() stamps the payload it writes; keep the in-memory
js/app.js:2876:      const lessons = currentLessonData?.[semKey];
js/app.js:2884:        await saveSingleLesson(semKey, lessonKey, { planComplete: cb.checked });
js/app.js:2911:      const lessons = currentLessonData?.[semKey];
js/app.js:3007:  const lessons = currentLessonData?.[semKey];
js/app.js:3111:  const lessons = currentLessonData?.[semKey];
js/app.js:3303:    saveTeacherEdit(lessonKey, currentLessonData?.[getTvSemKey()]?.[lessonKey] || lesson);
js/app.js:3311:      saveTeacherEdit(lessonKey, currentLessonData?.[getTvSemKey()]?.[lessonKey] || lesson);
js/app.js:3318:  document.getElementById('te-qa-send-btn').addEventListener('click', () => sendTeacherQaMessage(lessonKey, semKey));
js/app.js:3322:      sendTeacherQaMessage(lessonKey, semKey);
js/app.js:3549:    // is now empty is an intentional clear — saveSingleLesson needs this list
js/app.js:3559:    // saveSingleLesson's per-field dotted-path write always writes them
js/app.js:3572:    await saveSingleLesson(semKey, lessonKey, writePayload, fieldsToClear);
js/app.js:3573:    // saveSingleLesson() stamps lastEditedBy/At onto the object it is given.
js/app.js:3596:    if (currentLessonData[semKey]) {
js/app.js:3597:      currentLessonData[semKey][lessonKey] = updatedLesson;
js/app.js:3658:// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
js/app.js:3662:// same atomic-append design sendHelpResponse()/sendQaReply() already use —
js/app.js:3663:// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
js/app.js:3667:async function sendTeacherQaMessage(lessonKey, modalSemKey) {
js/app.js:3672:  // Same load-guard saveSingleLesson() enforced on the old path — after a
js/app.js:3675:  if (lessonDataLoadedSuccessfully === false) {
js/app.js:3683:  // under that key into curriculum/lessonData is never right. Routed by TYPE
js/app.js:3701:  // accepted check-to-write residual as sendHelpResponse()/sendQaReply().
js/app.js:3733:    target = weeklyLessonTarget(semKey);   // own-doc semester: its own doc, or "editing is paused"
js/app.js:3763:  if (currentLessonData?.[semKey]?.[lessonKey]) {
js/app.js:3764:    const cached = currentLessonData[semKey][lessonKey];
js/app.js:3767:    currentLessonData[semKey][lessonKey] = {
js/app.js:3832:  const lessons = currentLessonData?.[semKey];
js/app.js:3931:// sendTeacherQaMessage()).
js/app.js:3978:  const lessons = currentLessonData?.[semKey];
js/app.js:4180:  const lesson = currentLessonData?.[semKey]?.[key];
js/app.js:4403:  const lessons = currentLessonData?.[getAdminSemKey()];
js/app.js:4606:  // curriculum/lessonData, and no collection is ever cleared from here.
js/app.js:4640:  if (currentLessonData?.[key]) {
js/app.js:4641:    delete currentLessonData[key];
js/app.js:4644:  // curriculum/lessonData to delete. A camp season's lessons live in the
js/app.js:4676:    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
js/app.js:4752:// curriculum/lessonData write.
js/app.js:4786:    if (currentLessonData) currentLessonData[key] = {};
js/app.js:4879:// roster, no week grid, no lesson slots and no curriculum/lessonData write —
js/app.js:4960:  let lessonDataCommitted = false;
js/app.js:4979:      const existingLessonMap = await readServerSemesterLessonMap(key);
js/app.js:4994:      const sourceLessons = currentLessonData?.[copyFromKey] || {};
js/app.js:5030:        await saveLessonData(key, emptyLessons);
js/app.js:5031:        if (!currentLessonData) currentLessonData = {};
js/app.js:5032:        currentLessonData[key] = emptyLessons;
js/app.js:5033:        lessonDataCommitted = true;
js/app.js:5052:    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
js/app.js:5057:    if (lessonDataCommitted) {
js/app.js:5084:  if (!currentLessonData) await loadLessonData();
js/app.js:5104:    currentLessonData = data;
js/app.js:5115:  const lessons = currentLessonData?.[semKey];
js/app.js:5292:  const lessons = currentLessonData?.[semKey];
js/app.js:5433:// summerCamps_lessonData doc exists yet, so saveAdminEdit() skips the check
js/app.js:5584:  const lesson = currentLessonData?.[semKey]?.[key] || null;
js/app.js:5628:  if (lessonDataLoadedSuccessfully === false) {
js/app.js:5654:  const lessons = { ...(currentLessonData?.[semKey] || {}) };
js/app.js:5678:  // saveSingleLesson must apply with FieldValue.delete() rather than let the
js/app.js:5698:  // summerCamps_lessonData doc exists (a missing doc means "never saved",
js/app.js:5701:  // the doc. Same routing signal as saveSingleLesson() /
js/app.js:5818:    await saveSingleLesson(semKey, key, firestorePayload, fieldsToClear);
js/app.js:5833:    // execution falls through to commit currentLessonData, close the modal,
js/app.js:5851:    lastEditedBy: firestorePayload.lastEditedBy,   // stamped by saveSingleLesson()
js/app.js:5856:  currentLessonData[semKey] = lessons;
js/app.js:5892:// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
js/app.js:5905:// sendHelpResponse()/sendQaReply() (not yet implemented) — forced server
js/app.js:5916:      const snap = await curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key)).get({ source: 'server' });
js/app.js:5934:  if (!currentLessonData[semKey]) currentLessonData[semKey] = {};
js/app.js:5935:  currentLessonData[semKey][sourceKey] = sourceLesson;
js/app.js:5937:    currentLessonData[semKey][destKey] = destLesson;
js/app.js:5939:    delete currentLessonData[semKey][destKey];
js/app.js:5946:  const lessons = { ...currentLessonData[semKey] };
js/app.js:5980:    // cleared — saveSingleLesson omits empty fields from the write rather
js/app.js:5988:    currentLessonData[semKey] = lessons;
js/app.js:6008:      await saveMultipleLessonFields(
js/app.js:6010:        [{ lessonKey: newDestKey, lessonData: movedLesson, fieldsToClear: destFieldsToClear }],
js/app.js:6073:      currentLessonData[semKey] = lessons;
js/app.js:6081:          await saveMultipleLessonFields(semKey, [
js/app.js:6082:            { lessonKey: sourceKeyForSwap, lessonData: swappedSource, fieldsToClear: sourceFieldsToClear },
js/app.js:6083:            { lessonKey: newDestKey, lessonData: swappedDest, fieldsToClear: destFieldsToClearSwap }
js/app.js:6099:      currentLessonData[semKey] = lessons;
js/app.js:6102:          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
js/app.js:6152:  const lessons = currentLessonData?.[semKey];
js/app.js:6198:      <button class="btn-secondary ca-action-btn" onclick="openDetailModal(currentLessonData[${escForOnclick(semKey)}][${escForOnclick(sourceKey)}], ${escForOnclick(sourceKey)}, ${escForOnclick(source.teacher)}, ${escForOnclick(source.className)}, ${source.weekNum})">Back</button>
js/app.js:6210:// cached semester via saveLessonData() — any lesson whose local copy was stale
js/app.js:6214:// had actually been written. Now: one targeted saveSingleLesson() per target
js/app.js:6222:  const liveLessons = currentLessonData?.[semKey];
js/app.js:6257:      // Send ONLY the copied fields (saveSingleLesson writes per-field paths
js/app.js:6263:      await saveSingleLesson(semKey, targetKey, payload, targetFieldsToClear);
js/app.js:6265:      if (currentLessonData[semKey]) currentLessonData[semKey][targetKey] = updatedTarget;
js/app.js:6333:  const lessons = { ...currentLessonData[semKey] };
js/app.js:6349:    if (currentLessonData[semKey]) delete currentLessonData[semKey][key];
js/app.js:6385:    await deleteLessonKey(semKey, key);
js/app.js:6396:    currentLessonData[semKey] = lessons;
js/app.js:6479:// saveLessonData() semester overwrite), removal via FieldValue.arrayRemove()
js/app.js:6508:  const lessons = { ...(currentLessonData?.[destSemKey] || {}) };
js/app.js:6541:    await saveSingleLesson(destSemKey, key, lessons[key], NON_CONTENT_FIELDS_TO_CLEAR);
js/app.js:6559:  currentLessonData[destSemKey] = lessons;
js/app.js:6951:// saveLessonData() write passed the WHOLE {projects:[...]} wrapper into
js/app.js:6956:// targeted saveSingleLesson() write (unrelated lessons in the same semester
js/app.js:6973:  const existingLesson = currentLessonData?.[semKey]?.[key] || {};
js/app.js:7014:    await saveSingleLesson(semKey, key, newLesson, [...fieldsToClear, ...NON_CONTENT_FIELDS_TO_CLEAR]);
js/app.js:7015:    if (currentLessonData[semKey]) currentLessonData[semKey][key] = newLesson;
js/app.js:7093:  const lessons = currentLessonData?.[semKey];
js/app.js:7152:        <button class="btn-primary ca-help-send-btn" onclick="sendHelpResponse(${escForOnclick(key)})">Respond</button>
js/app.js:7179:// Shared by sendHelpResponse() and sendQaReply() below — seeds arrayUnion's
js/app.js:7190:// resave the ENTIRE cached semester via saveLessonData() — a Firestore
js/app.js:7200:async function sendHelpResponse(key) {
js/app.js:7211:  if (lessonDataLoadedSuccessfully === false) {
js/app.js:7225:  const cachedExisting = currentLessonData?.[semKey]?.[key];
js/app.js:7254:    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
js/app.js:7270:    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
js/app.js:7281:  currentLessonData[semKey][key] = {
js/app.js:7289:async function sendQaReply(key) {
js/app.js:7300:  if (lessonDataLoadedSuccessfully === false) {
js/app.js:7314:  const cachedExisting = currentLessonData?.[semKey]?.[key];
js/app.js:7343:    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
js/app.js:7357:    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
js/app.js:7372:  currentLessonData[semKey][key] = updatedLesson;
js/app.js:7588:  const summerSnap = await curriculumDb.collection('summerCamps_lessonData').get();
js/app.js:7591:  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
js/app.js:7592:  const lessonDataDoc = lessonDataSnap.exists ? lessonDataSnap.data() : {};
js/app.js:7602:  for (const [semKey, semesterLessons] of Object.entries(lessonDataDoc)) {
js/app.js:7685:// Lesson storage headroom (Spring 2026 storage move, Phase B): curriculum/lessonData
js/app.js:7731:  if (!currentLessonData) await loadLessonData();
js/app.js:7733:  const lessons = currentLessonData?.[semKey];
js/app.js:8051:  if (!currentLessonData) await loadLessonData();
js/app.js:8052:  const lessons = currentLessonData?.[semKey];
js/app.js:8465:  const lessons = currentLessonData?.[semKey];
js/app.js:8576:    <button class="btn-primary qa-reply-btn" onclick="sendQaReply(${escForOnclick(key)})">Send</button>
js/app.js:10312:  if (!currentLessonData) await loadLessonData();
js/app.js:10315:  const lessons = currentLessonData?.[semKey];
js/app.js:11222:  const lessons = currentLessonData?.[semKey] || {};
js/app.js:11486:  if (!currentLessonData) await loadLessonData();
js/app.js:11489:  // persistence succeeds — previously `currentLessonData[semKey] = {}` was
js/app.js:11492:  const lessons = { ...(currentLessonData[semKey] || {}) };
js/app.js:11534:    await saveLessonData(semKey, lessons);
js/app.js:11535:    currentLessonData[semKey] = lessons; // only commit locally after Firestore confirms
js/app.js:11573:  const lessons = currentLessonData?.[semKey];
js/app.js:11618:  let lesson = currentLessonData?.[semKey]?.[lessonKey];
js/app.js:11943:    // The curriculum/lessonData listener rebuilds the whole summer cache from
js/app.js:11948:    const cachedAtStart = currentLessonData[semKey]?.[lessonKey];
js/app.js:11991:      // that reaches saveSingleLesson telling it to actually delete the field
js/app.js:12036:      // summer branch of saveSingleLesson() is a set-merge, so everything
js/app.js:12064:      previousCachedLesson = currentLessonData[semKey]?.[lessonKey];
js/app.js:12067:      if (currentLessonData[semKey]) currentLessonData[semKey][lessonKey] = savedLesson;
js/app.js:12069:      const result = await saveSingleLesson(semKey, lessonKey, payload, fieldsToClear, sdoc ? { dayOffAuth: dayOffAuthFor(semKey) } : undefined);
js/app.js:12070:      // saveSingleLesson() stamps lastEditedBy/At onto the object it is given;
js/app.js:12081:        lesson = currentLessonData[semKey]?.[lessonKey] || lesson;
js/app.js:12094:        const semCache = currentLessonData[semKey];
js/app.js:12168:        const cachedNow = currentLessonData[semKey]?.[lessonKey];
js/app.js:12172:          if (previousCachedLesson === undefined) delete currentLessonData[semKey][lessonKey];
js/app.js:12173:          else currentLessonData[semKey][lessonKey] = previousCachedLesson;
js/app.js:12189:          const cacheEntry = currentLessonData[semKey]?.[lessonKey];
js/app.js:12190:          if (currentLessonData[semKey] && (cacheEntry === undefined || cacheEntry === previousCachedLesson)) currentLessonData[semKey][lessonKey] = displaced;
js/app.js:12345:  const lessons = currentLessonData?.[semKey];
js/app.js:12385:  const lesson = currentLessonData?.[semKey]?.[key];
js/app.js:12392:  const lessons = currentLessonData?.[semKey];
js/app.js:12626:  const writable = lessonDataLoadedSuccessfully !== false;
js/app.js:13154:  const planner = canPlanDayOffCamps() && lessonDataLoadedSuccessfully !== false;
js/app.js:13288:  const planner = canPlanDayOffCamps() && lessonDataLoadedSuccessfully !== false;
js/app.js:13289:  const ticker = canTickDayOffMaterials() && lessonDataLoadedSuccessfully !== false;
js/app.js:13515:  const ticker = canTickDayOffMaterials() && lessonDataLoadedSuccessfully !== false;

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '630,720p;3260,3790p;4540,5115p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
   630	// By Week / By Class sections start collapsed (except the current week in By
   631	// Week); whatever a teacher opens or closes stays that way across re-renders
   632	// (e.g. ticking Plan Complete) for the rest of the visit.
   633	const tvExpandedSections = new Set();
   634	const tvToggledSections = new Set();
   635	let tvCurrentTeacher = '';
   636	let tvCurrentClassFilter = 'all';
   637	let tvNavStack = [];  // Stack of { teacher, classFilter, scrollY } for back navigation
   638	let campCompleteData = {};
   639	
   640	function getTvSemKey() {
   641	  // Now uses global semester instead of per-tab selection
   642	  return getActiveSemesterKey();
   643	}
   644	
   645	function isCoTeacherForCurrentSemester() {
   646	  const user = getAuthUser();
   647	  if (!user || tvCurrentTeacher) return false;
   648	  const semKey = getTvSemKey();
   649	  const lessons = currentLessonData?.[semKey];
   650	  return !!lessons && Object.values(lessons).some(l =>
   651	    Array.isArray(l.sharedWith) && l.sharedWith.includes(user.uid)
   652	  );
   653	}
   654	
   655	async function initTeacherView() {
   656	  // Already built: the semester may have changed on another tab — refresh for
   657	  // it (renderTeacherView handles SDOC, and leaving SDOC, itself).
   658	  if (tvInitialized) {
   659	    if (isDayOffYear(getTvSemKey()) || tvTeacherListFor) { renderTvSemesterSelector(); renderQaActivityPanel(); renderTeacherView(); }
   660	    return;
   661	  }
   662	  tvInitialized = true;
   663	
   664	  // Load lesson data if not already loaded
   665	  if (!currentLessonData) {
   666	    await loadLessonData();
   667	  }
   668	
   669	  // Show banner and abort if load failed — prevents stale blank data from being saved.
   670	  // Not "initialized": the guard can trip transiently now (a listener reload
   671	  // that fails and self-heals — Backtracking audit Phase 7), and the next
   672	  // visit to this tab must be allowed to build it.
   673	  if (lessonDataLoadedSuccessfully === false) {
   674	    tvInitialized = false;
   675	    document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
   676	    return;
   677	  }
   678	
   679	  // Set up real-time listener FIRST so the retry mechanism fires even if
   680	  // summer camp data isn't ready yet when we reach the early-return below.
   681	  setupLessonDataListener((data) => {
   682	    currentLessonData = data;
   683	    renderProgressDashboard();
   684	    // SDOC (Phase 2B): a camp with only empty blocks has no slots, and there is
   685	    // no sharedWith — so re-render on every reload while the year is showing
   686	    // (the list and the teacher picker are rebuilt from the camps each time).
   687	    if (isDayOffYear(getTvSemKey())) {
   688	      if (document.querySelector('.tab-btn.active')?.dataset.tab === 'teacher-view') renderTeacherView();
   689	      renderTeacherMappingTable();
   690	      return;
   691	    }
   692	    // If teacher view initialized early without data, reset so it re-runs with the now-loaded data
   693	    const semKey = getTvSemKey();
   694	    const lessons = currentLessonData?.[semKey];
   695	    if (lessons && Object.keys(lessons).length > 0 && tvInitialized && isAdminOrManager()) {
   696	      const hasTeachers = document.getElementById('tv-teacher-select')?.options.length > 1;
   697	      if (!hasTeachers) {
   698	        tvInitialized = false;
   699	        initTeacherView();
   700	      }
   701	    }
   702	    // Skip re-render while a camp is expanded — preserves expanded state on live data updates
   703	    const anyExpanded = document.querySelector('.summer-camp-content:not(.hidden)');
   704	    if (!anyExpanded && (tvCurrentTeacher || isCoTeacherForCurrentSemester())) renderTeacherView();
   705	    // Refresh teacher mapping table in Settings if it exists
   706	    renderTeacherMappingTable();
   707	  });
   708	
   709	  // Build semester selector (only show if multiple published semesters)
   710	  renderTvSemesterSelector();
   711	
   712	  const semKey = getTvSemKey();
   713	  const lessons = currentLessonData?.[semKey];
   714	
   715	  // Before the empty-map "Loading…" branch below — an SDOC year with no camps
   716	  // (or only empty blocks) is an empty map and would otherwise say "Loading"
   717	  // forever. Initialized like any other type (Phase 2B): the listener above is
   718	  // subscribed once, and the controls are bound once; renderTeacherView()
   719	  // builds the SDOC teacher list itself.
   720	  if (isDayOffYear(semKey)) {
  3260	  const formSnapshot = getTeEditFormData();
  3261	  teOriginalData = {
  3262	    projectTitle: formSnapshot.projectTitle,
  3263	    shortDetails: formSnapshot.shortDetails,
  3264	    inspoLink: formSnapshot.inspoLink,
  3265	    introPitch: formSnapshot.introPitch,
  3266	    processStep1: formSnapshot.processStep1,
  3267	    processStep2: formSnapshot.processStep2,
  3268	    processStep3: formSnapshot.processStep3,
  3269	    processStep4: formSnapshot.processStep4,
  3270	    closure: formSnapshot.closure,
  3271	    materials: formSnapshot.materials,
  3272	    dayOfMaterials: formSnapshot.dayOfMaterials,
  3273	    materialsList: JSON.stringify(formSnapshot.materialsList || []),
  3274	    planComplete: formSnapshot.planComplete ? 'true' : 'false'
  3275	  };
  3276	
  3277	  let teAutoSaveTimer = null;
  3278	
  3279	  // Close handlers
  3280	  const closeModal = () => {
  3281	    clearTimeout(teAutoSaveTimer);
  3282	    if (isTeEditDirty()) {
  3283	      if (!confirm('You have unsaved changes. Discard them?')) return;
  3284	    }
  3285	    modal.remove();
  3286	    teOriginalData = null;
  3287	    renderTeacherView();
  3288	  };
  3289	
  3290	  document.getElementById('te-close-btn').addEventListener('click', closeModal);
  3291	  document.getElementById('te-cancel-btn').addEventListener('click', closeModal);
  3292	  modal.addEventListener('click', (e) => {
  3293	    if (e.target === modal) closeModal();
  3294	  });
  3295	
  3296	  // Save handler. A manual save cancels any pending autosave — otherwise the
  3297	  // debounce could fire during the manual save and re-run it (and, with a
  3298	  // photo still selected, upload the same file a second time). Backtracking
  3299	  // audit, Phase 5; full in-flight serialization is Phase 10's scope.
  3300	  const manualTeSave = () => {
  3301	    clearTimeout(teAutoSaveTimer);
  3302	    teAutoSaveTimer = null;
  3303	    saveTeacherEdit(lessonKey, currentLessonData?.[getTvSemKey()]?.[lessonKey] || lesson);
  3304	  };
  3305	  document.getElementById('te-save-btn').addEventListener('click', manualTeSave);
  3306	
  3307	  // Auto-save on input (2s debounce)
  3308	  const triggerTeAutoSave = () => {
  3309	    clearTimeout(teAutoSaveTimer);
  3310	    teAutoSaveTimer = setTimeout(() => {
  3311	      saveTeacherEdit(lessonKey, currentLessonData?.[getTvSemKey()]?.[lessonKey] || lesson);
  3312	    }, 2000);
  3313	  };
  3314	  modal.querySelectorAll('textarea').forEach(el => el.addEventListener('input', triggerTeAutoSave));
  3315	  document.getElementById('te-planComplete')?.addEventListener('change', triggerTeAutoSave);
  3316	
  3317	  // Q&A send handler
  3318	  document.getElementById('te-qa-send-btn').addEventListener('click', () => sendTeacherQaMessage(lessonKey, semKey));
  3319	  document.getElementById('te-qa-input').addEventListener('keydown', (e) => {
  3320	    if (e.key === 'Enter' && !e.shiftKey) {
  3321	      e.preventDefault();
  3322	      sendTeacherQaMessage(lessonKey, semKey);
  3323	    }
  3324	  });
  3325	
  3326	  // Cmd+S / Ctrl+S to save
  3327	  modal.addEventListener('keydown', (e) => {
  3328	    if ((e.metaKey || e.ctrlKey) && e.key === 's') {
  3329	      e.preventDefault();
  3330	      manualTeSave();
  3331	    }
  3332	  });
  3333	
  3334	  // Photo upload handler
  3335	  const photoInput = document.getElementById('te-photo-input');
  3336	  if (photoInput) {
  3337	    photoInput.addEventListener('change', (e) => {
  3338	      const file = e.target.files?.[0];
  3339	      if (!file) return;
  3340	      if (file.size > 5 * 1024 * 1024) {
  3341	        alert('Photo must be under 5MB.');
  3342	        photoInput.value = '';
  3343	        return;
  3344	      }
  3345	      // Show preview immediately
  3346	      const reader = new FileReader();
  3347	      reader.onload = (ev) => {
  3348	        const preview = document.getElementById('te-photo-preview');
  3349	        preview.innerHTML = `<img src="${ev.target.result}" alt="Demo photo" class="te-photo-img"><button type="button" class="te-photo-remove-btn" id="te-photo-remove-btn" title="Remove photo">&times; Remove</button>`;
  3350	        preview.style.display = '';
  3351	        document.getElementById('te-photo-remove-btn')?.addEventListener('click', () => {
  3352	          preview.innerHTML = '';
  3353	          preview.style.display = 'none';
  3354	          photoInput.value = '';
  3355	          photoInput.dataset.pendingRemove = 'true';
  3356	          document.querySelector('.te-photo-upload-label').innerHTML = '&#128247; Upload demo photo';
  3357	        });
  3358	        photoInput.dataset.pendingRemove = '';
  3359	        document.querySelector('.te-photo-upload-label').innerHTML = '&#128247; Replace photo';
  3360	      };
  3361	      reader.readAsDataURL(file);
  3362	    });
  3363	  }
  3364	
  3365	  // Remove existing photo handler
  3366	  document.getElementById('te-photo-remove-btn')?.addEventListener('click', () => {
  3367	    const preview = document.getElementById('te-photo-preview');
  3368	    preview.innerHTML = '';
  3369	    preview.style.display = 'none';
  3370	    const photoInput2 = document.getElementById('te-photo-input');
  3371	    if (photoInput2) {
  3372	      photoInput2.value = '';
  3373	      photoInput2.dataset.pendingRemove = 'true';
  3374	    }
  3375	    document.querySelector('.te-photo-upload-label').innerHTML = '&#128247; Upload demo photo';
  3376	  });
  3377	
  3378	}
  3379	
  3380	function populateMaterialsTable(lesson) {
  3381	  const tbody = document.getElementById('te-materials-tbody');
  3382	  if (!tbody) return;
  3383	
  3384	  // Build initial rows from materialsList or parse freetext
  3385	  let items = lesson.materialsList || [];
  3386	  if (items.length === 0 && lesson.materials) {
  3387	    // Parse freetext materials into name-only rows
  3388	    items = lesson.materials.split(/[,;\n]+/).map(m => m.trim()).filter(m => m).map(name => ({
  3389	      name, qty: '', scope: '', size: '', notes: ''
  3390	    }));
  3391	  }
  3392	
  3393	  tbody.innerHTML = '';
  3394	  for (const item of items) {
  3395	    addMaterialRow(tbody, item);
  3396	  }
  3397	
  3398	  // Add button handler
  3399	  document.getElementById('te-add-material-btn')?.addEventListener('click', () => {
  3400	    addMaterialRow(tbody, { name: '', qty: '', scope: '', size: '', notes: '' });
  3401	    // Focus the new name input
  3402	    const rows = tbody.querySelectorAll('tr');
  3403	    const lastRow = rows[rows.length - 1];
  3404	    lastRow?.querySelector('.te-mat-name')?.focus();
  3405	  });
  3406	}
  3407	
  3408	function addMaterialRow(tbody, item) {
  3409	  const tr = document.createElement('tr');
  3410	  tr.className = 'te-mat-row';
  3411	  tr.innerHTML = `
  3412	    <td><input type="text" class="te-mat-name" value="${escAttr(item.name || '')}" placeholder="Material name"></td>
  3413	    <td><input type="text" class="te-mat-qty" value="${escAttr(item.qty || '')}" placeholder="Qty"></td>
  3414	    <td><select class="te-mat-scope">
  3415	      <option value="" ${!item.scope ? 'selected' : ''}>—</option>
  3416	      <option value="per student" ${item.scope === 'per student' ? 'selected' : ''}>per student</option>
  3417	      <option value="per class" ${item.scope === 'per class' ? 'selected' : ''}>per class</option>
  3418	      <option value="per table" ${item.scope === 'per table' ? 'selected' : ''}>per table</option>
  3419	      <option value="total" ${item.scope === 'total' ? 'selected' : ''}>total</option>
  3420	    </select></td>
  3421	    <td><input type="text" class="te-mat-size" value="${escAttr(item.size || '')}" placeholder="Size/cut"></td>
  3422	    <td><input type="text" class="te-mat-notes" value="${escAttr(item.notes || '')}" placeholder="Notes"></td>
  3423	    <td><button type="button" class="te-mat-delete" title="Remove">&times;</button></td>
  3424	  `;
  3425	  tbody.appendChild(tr);
  3426	
  3427	  tr.querySelector('.te-mat-delete').addEventListener('click', () => tr.remove());
  3428	}
  3429	
  3430	function getMaterialsListFromTable() {
  3431	  const rows = document.querySelectorAll('#te-materials-tbody .te-mat-row');
  3432	  const list = [];
  3433	  rows.forEach(row => {
  3434	    const name = row.querySelector('.te-mat-name')?.value?.trim() || '';
  3435	    if (!name) return; // Skip rows with no name
  3436	    list.push({
  3437	      name,
  3438	      qty: row.querySelector('.te-mat-qty')?.value?.trim() || '',
  3439	      scope: row.querySelector('.te-mat-scope')?.value || '',
  3440	      size: row.querySelector('.te-mat-size')?.value?.trim() || '',
  3441	      notes: row.querySelector('.te-mat-notes')?.value?.trim() || ''
  3442	    });
  3443	  });
  3444	  return list;
  3445	}
  3446	
  3447	function getTeEditFormData() {
  3448	  const materialsList = getMaterialsListFromTable();
  3449	  // Synthesize freetext for backward compat
  3450	  const materials = materialsList.map(m => m.name).join(', ');
  3451	  return {
  3452	    projectTitle: document.getElementById('te-projectTitle')?.value?.trim() || '',
  3453	    shortDetails: document.getElementById('te-shortDetails')?.value?.trim() || '',
  3454	    inspoLink: document.getElementById('te-inspoLink')?.value?.trim() || '',
  3455	    introPitch: document.getElementById('te-introPitch')?.value?.trim() || '',
  3456	    processStep1: document.getElementById('te-processStep1')?.value?.trim() || '',
  3457	    processStep2: document.getElementById('te-processStep2')?.value?.trim() || '',
  3458	    processStep3: document.getElementById('te-processStep3')?.value?.trim() || '',
  3459	    processStep4: document.getElementById('te-processStep4')?.value?.trim() || '',
  3460	    closure: document.getElementById('te-closure')?.value?.trim() || '',
  3461	    materials,
  3462	    materialsList,
  3463	    dayOfMaterials: document.getElementById('te-dayOfMaterials')?.value?.trim() || '',
  3464	    planComplete: document.getElementById('te-planComplete')?.checked || false
  3465	  };
  3466	}
  3467	
  3468	// teOriginalData is already stored pre-normalized (see the snapshot built after
  3469	// save, below) — only raw form data read fresh from the DOM needs normalizing.
  3470	function normalizeTeFormValue(key, rawFormData) {
  3471	  return key === 'materialsList' ? JSON.stringify(rawFormData[key] || [])
  3472	       : key === 'planComplete' ? String(!!rawFormData[key])
  3473	       : (rawFormData[key] || '');
  3474	}
  3475	
  3476	function isTeEditDirty() {
  3477	  if (!teOriginalData) return false;
  3478	  const current = getTeEditFormData();
  3479	  return Object.keys(teOriginalData).some(key =>
  3480	    normalizeTeFormValue(key, current) !== (teOriginalData[key] || '')
  3481	  );
  3482	}
  3483	
  3484	function getTeChangedFields() {
  3485	  if (!teOriginalData) return [];
  3486	  const current = getTeEditFormData();
  3487	  return Object.keys(teOriginalData).filter(key =>
  3488	    normalizeTeFormValue(key, current) !== (teOriginalData[key] || '')
  3489	  );
  3490	}
  3491	
  3492	async function saveTeacherEdit(lessonKey, originalLesson) {
  3493	  const saveBtn = document.getElementById('te-save-btn');
  3494	  const autoSaveStatus = document.getElementById('te-autosave-status');
  3495	  const formData = getTeEditFormData();
  3496	  const changedFields = getTeChangedFields();
  3497	  const photoInput = document.getElementById('te-photo-input');
  3498	  const hasNewPhoto = photoInput?.files?.length > 0;
  3499	  const pendingRemove = photoInput?.dataset?.pendingRemove === 'true';
  3500	
  3501	  if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) {
  3502	    // Nothing to save — flash the button briefly
  3503	    if (saveBtn) { saveBtn.textContent = 'Saved!'; saveBtn.disabled = true; }
  3504	    setTimeout(() => { if (saveBtn) { saveBtn.textContent = 'Save'; saveBtn.disabled = false; } }, 1500);
  3505	    return;
  3506	  }
  3507	
  3508	  if (saveBtn) { saveBtn.disabled = true; saveBtn.textContent = 'Saving...'; }
  3509	  if (autoSaveStatus) autoSaveStatus.textContent = 'Saving...';
  3510	
  3511	  try {
  3512	    const semKey = getTvSemKey();
  3513	
  3514	    // Build updated lesson (preserve all original fields, override edited ones)
  3515	    const updatedLesson = { ...originalLesson, ...formData };
  3516	
  3517	    // Backtracking audit, Phase 8 (R4-2): capture the OLD photoPath before any
  3518	    // mutation, so the delete-after-save step below has the right value to
  3519	    // compare against.
  3520	    const oldPhotoPath = originalLesson.photoPath || null;
  3521	    const uploadedFile = hasNewPhoto ? photoInput.files[0] : null;
  3522	
  3523	    // Handle photo upload
  3524	    let photoUrl = null, photoPath = null;
  3525	    if (hasNewPhoto) {
  3526	      if (saveBtn) saveBtn.textContent = 'Uploading photo...';
  3527	      if (autoSaveStatus) autoSaveStatus.textContent = 'Uploading photo...';
  3528	      const result = await uploadLessonPhoto(semKey, lessonKey, photoInput.files[0]);
  3529	      // Backtracking audit, Phase 8 (R4-2): delete moved to AFTER the save
  3530	      // below — no longer here, immediately after upload.
  3531	      photoUrl = result.url;
  3532	      photoPath = result.path;
  3533	      updatedLesson.photoUrl = photoUrl;
  3534	      updatedLesson.photoPath = photoPath;
  3535	      if (!changedFields.includes('photo')) changedFields.push('photo');
  3536	      if (saveBtn) saveBtn.textContent = 'Saving...';
  3537	      if (autoSaveStatus) autoSaveStatus.textContent = 'Saving...';
  3538	    } else if (pendingRemove && originalLesson.photoUrl) {
  3539	      // Backtracking audit, Phase 8 (R4-2): delete moved to AFTER the save
  3540	      // below — no longer here.
  3541	      photoUrl = '';
  3542	      photoPath = '';
  3543	      updatedLesson.photoUrl = '';
  3544	      updatedLesson.photoPath = '';
  3545	      if (!changedFields.includes('photo')) changedFields.push('photo');
  3546	    }
  3547	
  3548	    // A content field that had text when the modal opened (or last saved) and
  3549	    // is now empty is an intentional clear — saveSingleLesson needs this list
  3550	    // explicitly to use FieldValue.delete() instead of silently omitting the
  3551	    // field, which would leave the old content in Firestore untouched
  3552	    // (Data Safety Plan Stage 3).
  3553	    const fieldsToClear = CONTENT_FIELDS.filter(f =>
  3554	      (teOriginalData?.[f] || '').trim() !== '' && !(formData[f] || '').trim()
  3555	    );
  3556	
  3557	    // Save using granular single-lesson write. This already includes
  3558	    // photoUrl/photoPath via updatedLesson (they're not in CONTENT_FIELDS, so
  3559	    // saveSingleLesson's per-field dotted-path write always writes them
  3560	    // through, even empty) — backtracking audit, Phase 8 (R3-8): the separate
  3561	    // photo-fields write that used to follow this call was vestigial, removed
  3562	    // entirely.
  3563	    // Backtracking audit Phase 10: the Q&A fields are written only by the
  3564	    // atomic arrayUnion() senders — this form never edits them, and writing
  3565	    // the cached array back whole would delete any message another client
  3566	    // appended since this cache copy was taken. They stay on updatedLesson
  3567	    // (the cache copy below) and are left out of the WRITE only.
  3568	    const writePayload = { ...updatedLesson };
  3569	    delete writePayload.qaThread;
  3570	    delete writePayload.teacherNotes;
  3571	    delete writePayload.adminResponse;
  3572	    await saveSingleLesson(semKey, lessonKey, writePayload, fieldsToClear);
  3573	    // saveSingleLesson() stamps lastEditedBy/At onto the object it is given.
  3574	    updatedLesson.lastEditedBy = writePayload.lastEditedBy;
  3575	    updatedLesson.lastEditedAt = writePayload.lastEditedAt;
  3576	
  3577	    // Backtracking audit, Phase 8 (R4-2): only delete the OLD photo once
  3578	    // Firestore has confirmed the new reference — and only if it's actually
  3579	    // different from the new one.
  3580	    if (oldPhotoPath && oldPhotoPath !== (updatedLesson.photoPath || null)) {
  3581	      try {
  3582	        await deleteLessonPhoto(oldPhotoPath);
  3583	      } catch (cleanupErr) {
  3584	        console.error('⚠️ Could not clean up old photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
  3585	      }
  3586	    }
  3587	
  3588	    // Backtracking audit, Phase 5: the photo change is persisted — clear the
  3589	    // pending selection so this modal's autosave doesn't re-upload the same
  3590	    // file to another unique path on the next pause in typing. Success path
  3591	    // only, so a failed save keeps the selection for the retry.
  3592	    if (hasNewPhoto && photoInput?.files?.[0] === uploadedFile) photoInput.value = '';
  3593	    if (pendingRemove && photoInput) photoInput.dataset.pendingRemove = '';
  3594	
  3595	    // Update local data immediately (don't wait for Firestore listener)
  3596	    if (currentLessonData[semKey]) {
  3597	      currentLessonData[semKey][lessonKey] = updatedLesson;
  3598	    }
  3599	
  3600	    // Backtracking audit, Phase 8 (R1-17/R2-11): log only after persistence is
  3601	    // confirmed, with its own non-blocking catch — a log-only failure here
  3602	    // must not be reported to the teacher as "Save failed" when the save
  3603	    // itself already succeeded. Before/after char counts per field so a
  3604	    // large-content wipe is flagged automatically (Data Safety Plan Stage 4C).
  3605	    // 'photo' isn't a text field — teOriginalData/formData have no counterpart
  3606	    // for it, so it carries no char counts and is never flagged as a wipe.
  3607	    try {
  3608	      const changedFieldEntries = changedFields.map(field => {
  3609	        if (field === 'photo') return { field, before: null, after: null, potentialWipe: false };
  3610	        const before = (teOriginalData[field] || '').length;
  3611	        const after = normalizeTeFormValue(field, formData).length;
  3612	        return { field, before, after, potentialWipe: after === 0 && before > 50 };
  3613	      });
  3614	      await logTeacherEdit(semKey, lessonKey, originalLesson, changedFieldEntries);
  3615	    } catch (logErr) {
  3616	      console.error('⚠️ Lesson saved, but Change History logging failed:', logErr);
  3617	    }
  3618	
  3619	    // Show success — stay open, reset dirty state
  3620	    if (saveBtn) { saveBtn.textContent = 'Saved!'; }
  3621	    if (autoSaveStatus) {
  3622	      autoSaveStatus.textContent = fieldsToClear.length > 0
  3623	        ? `✓ Saved (${fieldsToClear.join(', ')} cleared)`
  3624	        : '✓ Saved';
  3625	    }
  3626	
  3627	    // Reset dirty baseline so closing won't prompt "unsaved changes"
  3628	    const snapshot = getTeEditFormData();
  3629	    teOriginalData = {
  3630	      projectTitle: snapshot.projectTitle,
  3631	      shortDetails: snapshot.shortDetails,
  3632	      inspoLink: snapshot.inspoLink,
  3633	      introPitch: snapshot.introPitch,
  3634	      processStep1: snapshot.processStep1,
  3635	      processStep2: snapshot.processStep2,
  3636	      processStep3: snapshot.processStep3,
  3637	      processStep4: snapshot.processStep4,
  3638	      closure: snapshot.closure,
  3639	      materials: snapshot.materials,
  3640	      dayOfMaterials: snapshot.dayOfMaterials,
  3641	      materialsList: JSON.stringify(snapshot.materialsList || []),
  3642	      planComplete: snapshot.planComplete ? 'true' : 'false'
  3643	    };
  3644	
  3645	    setTimeout(() => {
  3646	      if (saveBtn) { saveBtn.textContent = 'Save'; saveBtn.disabled = false; }
  3647	      if (autoSaveStatus) autoSaveStatus.textContent = '';
  3648	    }, 1500);
  3649	  } catch (err) {
  3650	    console.error('Error saving lesson:', err);
  3651	    if (saveBtn) { saveBtn.disabled = false; saveBtn.textContent = 'Save'; }
  3652	    if (autoSaveStatus) { autoSaveStatus.textContent = '⚠️ Save failed'; autoSaveStatus.style.color = 'var(--error)'; }
  3653	  }
  3654	}
  3655	
  3656	// Backtracking audit Phase 10 (R3-3, R4-5): this used to rebuild the whole
  3657	// Q&A thread from the modal's lesson object and hand the ENTIRE lesson to
  3658	// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
  3659	// silently dropped any message (or any other field) another client had
  3660	// landed since this modal opened. Now a single targeted .update() touching
  3661	// only this lesson's own Q&A paths, with arrayUnion() for the thread — the
  3662	// same atomic-append design sendHelpResponse()/sendQaReply() already use —
  3663	// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
  3664	// record. `modalSemKey` is the semester the modal was opened under: the
  3665	// global selector can change while the modal stays open, and a dotted-path
  3666	// update under the wrong semester would create a Q&A-only ghost lesson there.
  3667	async function sendTeacherQaMessage(lessonKey, modalSemKey) {
  3668	  const input = document.getElementById('te-qa-input');
  3669	  if (!input) return;
  3670	  const message = input.value.trim();
  3671	  if (!message) return;
  3672	  // Same load-guard saveSingleLesson() enforced on the old path — after a
  3673	  // failed load the cache is empty, so the legacy-thread migration below
  3674	  // would run blind against whatever is really on the server.
  3675	  if (lessonDataLoadedSuccessfully === false) {
  3676	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  3677	    return;
  3678	  }
  3679	
  3680	  const semKey = modalSemKey || getTvSemKey();
  3681	  // This modal never hosts a camp season (the Today View routes those to the
  3682	  // summer editor, whose Q&A lives in summerCamps_prepHelpQueue), so a write
  3683	  // under that key into curriculum/lessonData is never right. Routed by TYPE
  3684	  // now (Phase 1, 1.1) — a third type is refused out loud rather than written
  3685	  // into the shared weekly document.
  3686	  let lessonStore;
  3687	  try {
  3688	    lessonStore = lessonStoreFor(semKey);
  3689	  } catch (err) {
  3690	    alert(err.message);
  3691	    return;
  3692	  }
  3693	  if (lessonStore === 'camp') {
  3694	    alert('Summer camp questions are sent from the camp lesson editor.');
  3695	    return;
  3696	  }
  3697	
  3698	  // Confirm the lesson still exists on the server (an admin may have moved or
  3699	  // deleted it since this modal opened). A dotted-path update would otherwise
  3700	  // recreate the old key as a Q&A-only ghost lesson. Same forced read and
  3701	  // accepted check-to-write residual as sendHelpResponse()/sendQaReply().
  3702	  let check;
  3703	  try {
  3704	    check = await adminLessonStillExistsWithRetry(semKey, lessonKey);
  3705	  } catch (err) {
  3706	    console.warn('⚠️ Existence check retry also failed:', err);
  3707	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  3708	    return;
  3709	  }
  3710	  if (!check.exists) {
  3711	    alert('This lesson was moved or removed elsewhere. Your message was not sent — please close this and check the classbook for its new location.');
  3712	    return;
  3713	  }
  3714	  const existing = check.data;
  3715	
  3716	  const user = getAuthUser();
  3717	  const isAdmin = ['admin', 'manager'].includes(user?.role);
  3718	  const newEntry = {
  3719	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  3720	    from: isAdmin ? 'admin' : 'teacher',
  3721	    name: user?.name || 'Unknown',
  3722	    message,
  3723	    timestamp: new Date().toISOString()
  3724	  };
  3725	  // The fresh server copy decides whether a legacy teacherNotes/adminResponse
  3726	  // thread still needs migrating into qaThread on this lesson's first entry.
  3727	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  3728	  const editedAt = new Date().toISOString();
  3729	  const editedBy = user?.name || 'Unknown';
  3730	
  3731	  let target;
  3732	  try {
  3733	    target = weeklyLessonTarget(semKey);   // own-doc semester: its own doc, or "editing is paused"
  3734	  } catch (err) {
  3735	    alert(err.message);
  3736	    return;
  3737	  }
  3738	  const p = `${target.prefix}${lessonKey}`;
  3739	  const updates = {
  3740	    [`${p}.qaThread`]: firebase.firestore.FieldValue.arrayUnion(...entriesToAdd),
  3741	    [`${p}.lastEditedBy`]: editedBy,
  3742	    [`${p}.lastEditedAt`]: editedAt,
  3743	  };
  3744	  // Legacy mirror fields, kept for compatibility with older readers.
  3745	  const legacyField = isAdmin ? 'adminResponse' : 'teacherNotes';
  3746	  updates[`${p}.${legacyField}`] = message;
  3747	
  3748	  try {
  3749	    await target.ref.update(updates);
  3750	  } catch (err) {
  3751	    console.error('Error sending Q&A message:', err);
  3752	    alert('Error sending message: ' + err.message);
  3753	    return;
  3754	  }
  3755	
  3756	  // Confirmed — make sure the local cache shows the new message before the
  3757	  // live listener catches up. Usually the listener already HAS: a local
  3758	  // write triggers a latency-compensated snapshot (with the arrayUnion
  3759	  // applied) before the server ack resolves the await above, so the entry
  3760	  // is deduplicated by id rather than appended blindly — a duplicate here
  3761	  // would be persisted by the next autosave, which writes the cached
  3762	  // qaThread back as a whole array.
  3763	  if (currentLessonData?.[semKey]?.[lessonKey]) {
  3764	    const cached = currentLessonData[semKey][lessonKey];
  3765	    const baseThread = cached.qaThread && cached.qaThread.length > 0 ? cached.qaThread : getQaThread(cached);
  3766	    const alreadyThere = baseThread.some(m => m.id === newEntry.id);
  3767	    currentLessonData[semKey][lessonKey] = {
  3768	      ...cached,
  3769	      qaThread: alreadyThere ? baseThread : [...baseThread, newEntry],
  3770	      [legacyField]: message,
  3771	      lastEditedBy: editedBy,
  3772	      lastEditedAt: editedAt,
  3773	    };
  3774	  }
  3775	  input.value = '';
  3776	  // Re-open the modal to show the updated thread — only if the Today View is
  3777	  // still on this modal's semester; otherwise it would open a different
  3778	  // semester's lesson under the same key.
  3779	  if (getTvSemKey() === semKey) openTeacherEditModal(lessonKey);
  3780	}
  3781	
  3782	// ─── Q&A Reply Notification Banner ───────────────
  3783	
  3784	// The read-mark carries the semester (Phase 1, 1.4): two camp seasons share
  3785	// lesson keys, so a bare key would mark 2027's reply read because the
  3786	// identically-keyed 2026 one was opened.
  3787	function qaReadMarkKey(lessonKey) { return `qaLastRead_${getTvSemKey()}_${lessonKey}`; }
  3788	// Marks written before Phase 1 had no semester in the key. Reading through
  3789	// this keeps them valid — otherwise every teacher would see unread badges at
  3790	// deploy for replies they had already read, in weekly semesters too.
  4540	  // Only show bar if user is admin/manager
  4541	  const user = getAuthUser();
  4542	  if (!user || !['admin', 'manager'].includes(user.role)) { bar.style.display = 'none'; return; }
  4543	
  4544	  bar.style.display = 'flex';
  4545	  const currentKey = getAdminSemKey();
  4546	
  4547	  // Build dropdown options
  4548	  let optionsHtml = '';
  4549	  for (const key of keys) {
  4550	    const sem = semesters[key];
  4551	    const isActive = key === currentConfig.activeSemester;
  4552	    const isPublished = sem.published !== false;
  4553	    const label = sem.name + (isActive ? ' (active)' : '') + (!isPublished ? ' [draft]' : '');
  4554	    optionsHtml += `<option value="${escAttr(key)}" ${key === currentKey ? 'selected' : ''}>${escHtml(label)}</option>`;
  4555	  }
  4556	  select.innerHTML = optionsHtml;
  4557	  select.onchange = () => setGlobalSemester(select.value);
  4558	
  4559	  // Populate "copy from" dropdown in new semester modal
  4560	  const copyFrom = document.getElementById('new-sem-copy-from');
  4561	  if (copyFrom) {
  4562	    let copyHtml = '<option value="">Start blank (no classes)</option>';
  4563	    for (const key of keys.filter(k => !isDayOffYear(k))) {
  4564	      copyHtml += `<option value="${escAttr(key)}">${escHtml(semesters[key].name)}</option>`;
  4565	    }
  4566	    copyFrom.innerHTML = copyHtml;
  4567	  }
  4568	
  4569	  // Publish toggle for current semester
  4570	  const sem = semesters[currentKey];
  4571	  if (sem) {
  4572	    const isPublished = sem.published !== false;
  4573	    const isActive = currentKey === currentConfig.activeSemester;
  4574	    publishGroup.innerHTML = `
  4575	      ${isActive ? '<span class="ca-sem-active-badge">Active Semester</span>' : ''}
  4576	      ${!isActive ? `<label class="ca-publish-toggle">
  4577	        <input type="checkbox" ${isPublished ? 'checked' : ''} onchange="toggleSemesterPublish(${escForOnclick(currentKey)}, this.checked)">
  4578	        Published (visible to teachers)
  4579	      </label>` : ''}
  4580	      ${!isPublished && !isActive ? '<span class="ca-sem-unpublished-badge">Draft</span>' : ''}
  4581	      ${!isActive ? `<button class="btn-text ca-delete-sem-btn" onclick="deleteSemester(${escForOnclick(currentKey)})" title="Delete this semester">&#128465; Delete</button>` : ''}
  4582	    `;
  4583	  }
  4584	}
  4585	
  4586	async function deleteSemester(key) {
  4587	  const sem = currentConfig?.semesters?.[key];
  4588	  if (!sem) return;
  4589	  // Spring 2026 storage move: deleting an own-doc semester is disabled until the
  4590	  // follow-up plan routes it (its lessons may live in their own document).
  4591	  if (isOwnDocSemester(key)) {
  4592	    alert(`"${sem.name}" can't be deleted while its storage is being changed.`);
  4593	    return;
  4594	  }
  4595	  if (key === currentConfig.activeSemester) {
  4596	    alert('Cannot delete the active semester.');
  4597	    return;
  4598	  }
  4599	  // Removing a CAMP season from the Classbook removes only this app's entry
  4600	  // for it. Its camps, schedule, plans and photos belong to the Summer Camp
  4601	  // App and stay exactly where they are — adding the season back from the
  4602	  // registry restores the whole view (Phase 1, 1.7). This supersedes the
  4603	  // companion plan's summer-delete design, which predates seasons.
  4604	  // An SDOC year: refused while any event exists (a forced-server count);
  4605	  // otherwise only its appData entry goes — it has nothing in
  4606	  // curriculum/lessonData, and no collection is ever cleared from here.
  4607	  if (isDayOffYear(key)) {
  4608	    let events;
  4609	    try { events = await countDayOffEvents(key); }
  4610	    catch (err) { alert(`Could not check "${sem.name}" for events: ${err.message}\n\nNothing was changed.`); return; }
  4611	    if (events > 0) { alert(`"${sem.name}" still has ${events} event${events === 1 ? '' : 's'}. Remove its events first.`); return; }
  4612	  }
  4613	  const isCamp = isCampSeason(key);
  4614	  const isDayOff = isDayOffYear(key);
  4615	  const firstConfirm = isDayOff
  4616	    ? `Delete the school year "${sem.name}"? It has no events, so only the year itself is removed.`
  4617	    : isCamp
  4618	    ? `Remove "${sem.name}" from the Classbook?\n\nThis only removes it here. Every camp, schedule, lesson plan and photo stays in the Summer Camp App, and you can add the season back at any time from + New Semester.`
  4619	    : `Delete semester "${sem.name}"? This will remove all its lesson data, cut bank, and change history. This cannot be undone.`;
  4620	  if (!confirm(firstConfirm)) return;
  4621	  if (!isCamp && !isDayOff && !confirm(`Are you sure? Type OK in your head and click OK to confirm.`)) return;
  4622	
  4623	  // Remove the semester's own entry and nothing else (Phase 1, 1.2). Revert
  4624	  // this tab if the write is refused, or the config would be missing a
  4625	  // semester the server still has — with no alert and no re-render to show it
  4626	  // (Phase 1 review).
  4627	  const removed = currentConfig.semesters[key];
  4628	  delete currentConfig.semesters[key];
  4629	  try {
  4630	    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
  4631	  } catch (err) {
  4632	    currentConfig.semesters[key] = removed;
  4633	    console.error('❌ Could not remove the semester:', err);
  4634	    alert(`Could not remove "${sem.name}": ${err.message}\n\nNothing was changed.`);
  4635	    renderSemesterSelector();
  4636	    return;
  4637	  }
  4638	
  4639	  // Drop this season's in-memory map either way…
  4640	  if (currentLessonData?.[key]) {
  4641	    delete currentLessonData[key];
  4642	  }
  4643	  // …but only a WEEKLY semester has lessons of its own inside
  4644	  // curriculum/lessonData to delete. A camp season's lessons live in the
  4645	  // shared summerCamps_* collections and are never touched from here.
  4646	  if (isDayOff) {
  4647	    delete currentDayOffEvents[key]; delete currentDayOffCamps[key]; delete currentDayOffPlans[key]; delete currentDayOffSignoffs[key];
  4648	  } else if (!isCamp) {
  4649	    try {
  4650	      await deleteLessonData(key);
  4651	    } catch (e) { console.warn('Could not delete lesson data for', key, e); }
  4652	  }
  4653	
  4654	  // Switch to active semester
  4655	  caCurrentSemester = currentConfig.activeSemester;
  4656	  renderSemesterSelector();
  4657	  renderAdminGrid();
  4658	  renderHelpQueue();
  4659	  renderCutBank();
  4660	  renderIdeaBank();
  4661	  renderChangeHistory();
  4662	}
  4663	
  4664	function switchAdminSemester(key) {
  4665	  // Delegates to global semester — CA always stays in sync with the header selector
  4666	  setGlobalSemester(key);
  4667	}
  4668	
  4669	async function toggleSemesterPublish(key, published) {
  4670	  if (!currentConfig?.semesters?.[key]) return;
  4671	  if (!isPublishableType(key)) { alert('This semester type can\'t be published.'); return; }
  4672	  // SDOC (Phase 2B): publishing shows the year to every teacher on a camp —
  4673	  // say so first if some camps have nobody to see them.
  4674	  if (published && isDayOffYear(key)) {
  4675	    // The camp list below must be real to warn from — never publish on a failed load.
  4676	    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
  4677	    const bare = (currentDayOffCamps[key] || []).filter(c => !(c.teachers || []).length).length;
  4678	    if (bare && !confirm(`${bare} camp${bare === 1 ? ' has' : 's have'} no teacher yet — publish anyway?`)) { renderSemesterSelector(); return; }
  4679	  }
  4680	  const hadPublished = 'published' in currentConfig.semesters[key];
  4681	  const previous = currentConfig.semesters[key].published;
  4682	  currentConfig.semesters[key].published = published;
  4683	  try {
  4684	    await updateAppData({ [`semesters.${key}.published`]: published });
  4685	  } catch (err) {
  4686	    // Restore exactly what was there — including "the field was absent".
  4687	    if (currentConfig.semesters[key]) {
  4688	      if (hadPublished) currentConfig.semesters[key].published = previous;
  4689	      else delete currentConfig.semesters[key].published;
  4690	    }
  4691	    console.error('❌ Could not change the publish state:', err);
  4692	    alert(`Could not ${published ? 'publish' : 'unpublish'} that semester: ${err.message}\n\nNothing was changed.`);
  4693	  }
  4694	  renderSemesterSelector();
  4695	}
  4696	
  4697	// Which types may be published to teachers. SDOC years joined in Phase 2B,
  4698	// when teachers got their day-off plans to build.
  4699	const PUBLISHABLE_SEMESTER_TYPES = new Set([SEMESTER_TYPES.weekly, SEMESTER_TYPES.camp, SEMESTER_TYPES.dayOff]);
  4700	function isPublishableType(semKey) { return PUBLISHABLE_SEMESTER_TYPES.has(semesterTypeOf(semKey)); }
  4701	
  4702	function openNewSemesterModal() {
  4703	  document.getElementById('ca-new-semester-modal')?.classList.add('open');
  4704	  // Reset to the default type each time, then load the seasons on offer.
  4705	  const weeklyRadio = document.querySelector('input[name="new-sem-type"][value="weekly"]');
  4706	  if (weeklyRadio) weeklyRadio.checked = true;
  4707	  onNewSemesterTypeChange();
  4708	  populateNewSemesterSeasons();
  4709	  document.getElementById('new-sem-name')?.focus();
  4710	}
  4711	
  4712	function selectedNewSemesterType() {
  4713	  return document.querySelector('input[name="new-sem-type"]:checked')?.value || SEMESTER_TYPES.weekly;
  4714	}
  4715	
  4716	function onNewSemesterTypeChange() {
  4717	  const type = selectedNewSemesterType();
  4718	  const weekly = document.getElementById('new-sem-weekly-fields');
  4719	  const camp = document.getElementById('new-sem-camp-fields');
  4720	  const dayOff = document.getElementById('new-sem-dayoff-fields');
  4721	  if (weekly) weekly.hidden = type !== SEMESTER_TYPES.weekly;
  4722	  if (camp) camp.hidden = type !== SEMESTER_TYPES.camp;
  4723	  if (dayOff) {
  4724	    dayOff.hidden = type !== SEMESTER_TYPES.dayOff;
  4725	    if (type === SEMESTER_TYPES.dayOff) resetDayOffYearFields();
  4726	  }
  4727	}
  4728	
  4729	// Defaults: Aug 1 of this year → May 31 of the next; name follows the dates
  4730	// until the admin types their own.
  4731	function resetDayOffYearFields() {
  4732	  const y = new Date().getFullYear();
  4733	  const start = document.getElementById('new-sem-dayoff-start');
  4734	  const end = document.getElementById('new-sem-dayoff-end');
  4735	  const name = document.getElementById('new-sem-dayoff-name');
  4736	  if (start) start.value = `${y}-08-01`;
  4737	  if (end) end.value = `${y + 1}-05-31`;
  4738	  if (name) delete name.dataset.edited;
  4739	  onDayOffYearDatesChange();
  4740	}
  4741	
  4742	function onDayOffYearDatesChange() {
  4743	  const name = document.getElementById('new-sem-dayoff-name');
  4744	  if (!name || name.dataset.edited) return;
  4745	  const start = document.getElementById('new-sem-dayoff-start')?.value || '';
  4746	  const end = document.getElementById('new-sem-dayoff-end')?.value || '';
  4747	  name.value = start && end ? dayOffYearLabels(start, end).name : '';
  4748	}
  4749	
  4750	// An SDOC school year: one appData entry through the field-path writer, after
  4751	// a forced-server absence check. No roster, no lesson slots, no
  4752	// curriculum/lessonData write.
  4753	async function createDayOffYear() {
  4754	  const startDate = document.getElementById('new-sem-dayoff-start')?.value || '';
  4755	  const endDate = document.getElementById('new-sem-dayoff-end')?.value || '';
  4756	  const name = document.getElementById('new-sem-dayoff-name')?.value.trim() || '';
  4757	  if (!isIsoDate(startDate) || !isIsoDate(endDate)) { alert('Pick the school year\'s start and end dates.'); return; }
  4758	  if (endDate <= startDate) { alert('The school year has to end after it starts.'); return; }
  4759	  if (!name) { alert('Give the school year a name.'); return; }
  4760	  const { key } = dayOffYearLabels(startDate, endDate);
  4761	  if (currentConfig.semesters?.[key]) { alert(`${currentConfig.semesters[key].name} already exists (${key}).`); return; }
  4762	
  4763	  creatingSemester = true;
  4764	  try {
  4765	    const serverConfig = await readAppDataFromServer();
  4766	    if (serverConfig?.semesters?.[key]) {
  4767	      alert(`A school year with key "${key}" was already created (in another tab, or by another admin). Reload to see it.`);
  4768	      creatingSemester = false;
  4769	      return;
  4770	    }
  4771	    const newSem = { name, semesterType: SEMESTER_TYPES.dayOff, startDate, endDate, published: false, teacherNames: [] };
  4772	    await updateAppData({ [`semesters.${key}`]: newSem });
  4773	    currentConfig.semesters[key] = newSem;
  4774	  } catch (err) {
  4775	    console.error('❌ Could not create the school year:', err);
  4776	    alert(`Could not create that school year: ${err.message}`);
  4777	    creatingSemester = false;
  4778	    return;
  4779	  }
  4780	  // The write landed — anything failing from here is display only.
  4781	  try {
  4782	    currentDayOffEvents[key] = [];
  4783	    currentDayOffCamps[key] = [];
  4784	    currentDayOffPlans[key] = {};
  4785	    currentDayOffSignoffs[key] = {};
  4786	    if (currentLessonData) currentLessonData[key] = {};
  4787	    closeNewSemesterModal();
  4788	    renderSemesterSelector();
  4789	    initGlobalSemesterSelector();
  4790	    alert(`${name} created. It stays hidden from teachers. Next: add its teacher names in Settings, then its day-off dates and camps in Curriculum Admin.`);
  4791	  } catch (err) {
  4792	    console.error('School year created, but the page did not refresh:', err);
  4793	    alert(`${name} was created, but the page didn't refresh properly — reload to see it.`);
  4794	  } finally {
  4795	    creatingSemester = false;
  4796	  }
  4797	}
  4798	
  4799	// The Camp season option offers exactly the registry seasons that do not
  4800	// already have a semester here. In legacy mode there is no registry to read,
  4801	// and with nothing left to add there is nothing to choose — either way the
  4802	// option is disabled with the reason shown, never silently empty (1.6).
  4803	async function populateNewSemesterSeasons() {
  4804	  const select = document.getElementById('new-sem-season');
  4805	  const campRadio = document.getElementById('new-sem-type-camp');
  4806	  const note = document.getElementById('new-sem-camp-unavailable');
  4807	  if (!select || !campRadio || !note) return;
  4808	  const disable = (reason) => {
  4809	    campRadio.disabled = true;
  4810	    note.textContent = reason;
  4811	    note.hidden = false;
  4812	    select.innerHTML = '';
  4813	  };
  4814	  const mode = getSeasonRegistryMode();
  4815	  if (mode === 'legacy') return disable('Camp seasons need the Summer Camp App to set up its seasons first — none exist yet.');
  4816	  if (mode !== 'filtered') return disable("Can't read the season registry right now, so a camp season can't be added.");
  4817	  try {
  4818	    const registered = await listRegisteredSeasons();
  4819	    // A season is "taken" by a stored `season` OR by the key it would be
  4820	    // created under. The key check matters before the type migration has run:
  4821	    // summer-2026 carries no `season` field yet, and matching on that alone
  4822	    // would offer 2026 again and create a duplicate semester.
  4823	    const semesters = currentConfig?.semesters || {};
  4824	    const taken = new Set(Object.values(semesters).map(sem => sem?.season).filter(Boolean));
  4825	    const available = registered.filter(r => !taken.has(r.season) && !semesters[`summer-${r.season}`]);
  4826	    if (available.length === 0) {
  4827	      return disable(registered.length === 0
  4828	        ? 'The Summer Camp App has not created any seasons yet.'
  4829	        : 'Every season the Summer Camp App has created is already in the Classbook.');
  4830	    }
  4831	    campRadio.disabled = false;
  4832	    note.hidden = true;
  4833	    select.innerHTML = available.map(r => {
  4834	      const range = r.startDate && r.endDate ? ` (${formatSeasonDate(r.startDate)} – ${formatSeasonDate(r.endDate)})` : '';
  4835	      return `<option value="${escAttr(r.season)}">${escHtml(r.name || `Summer ${r.season}`)}${escHtml(range)}</option>`;
  4836	    }).join('');
  4837	    newSemesterSeasonsByYear = Object.fromEntries(available.map(r => [r.season, r]));
  4838	  } catch (err) {
  4839	    console.error('Could not list the registry seasons:', err);
  4840	    disable("Couldn't read the season registry, so a camp season can't be added right now.");
  4841	  }
  4842	}
  4843	
  4844	let newSemesterSeasonsByYear = {};
  4845	
  4846	function formatSeasonDate(iso) {
  4847	  const d = new Date(`${iso}T00:00:00`);
  4848	  return Number.isNaN(d.getTime()) ? iso : d.toLocaleDateString(undefined, { month: 'short', day: 'numeric', year: 'numeric' });
  4849	}
  4850	
  4851	function closeNewSemesterModal() {
  4852	  document.getElementById('ca-new-semester-modal')?.classList.remove('open');
  4853	}
  4854	
  4855	// In-flight guard: the Create button is a bare onclick with no disabled state,
  4856	// so a double-click ran two overlapping creations. Both passed the
  4857	// "already exists" check (the key is only added to currentConfig after the
  4858	// first await), and a split success/failure would let the failing run's
  4859	// cleanup below delete the succeeding run's server-side slots. Set before the
  4860	// first await, cleared in `finally` — everything between the check and the
  4861	// set is synchronous, so the second click always sees it.
  4862	let creatingSemester = false;
  4863	
  4864	// A lesson slot exactly as createNewSemester() / createLessonSlotsForRoster()
  4865	// generate it: identity + enrollment metadata, every other field at its empty
  4866	// default. Deliberately stricter than lessonHasContent() — projectTitle,
  4867	// materials, photoUrl, qaThread etc. are not CONTENT_FIELDS but are still
  4868	// real data that createNewSemester()'s slot write would merge over.
  4869	function isTemplateEmptyLesson(lesson) {
  4870	  if (!lesson || typeof lesson !== 'object') return false;
  4871	  const IDENTITY = new Set(['teacher', 'className', 'weekNum', 'classSize']);
  4872	  return Object.entries(lesson).every(([k, v]) =>
  4873	    IDENTITY.has(k) || v == null || v === '' || v === 0 || v === false ||
  4874	    (Array.isArray(v) && v.length === 0)
  4875	  );
  4876	}
  4877	
  4878	// A camp season is created from the registry, never typed in (1.6 / D3): no
  4879	// roster, no week grid, no lesson slots and no curriculum/lessonData write —
  4880	// its camps arrive from the Summer Camp App when Christie publishes them.
  4881	async function createCampSeasonSemester() {
  4882	  const season = document.getElementById('new-sem-season')?.value;
  4883	  const registry = newSemesterSeasonsByYear[season];
  4884	  if (!season || !registry) { alert('Pick a season first.'); return; }
  4885	
  4886	  const key = `summer-${season}`;
  4887	  if (currentConfig.semesters?.[key]) { alert(`Summer ${season} is already in the Classbook.`); return; }
  4888	  // The same completeness check Re-sync makes — otherwise a half-set-up season
  4889	  // could be ADDED with numWeeks 0 and no studios, and would then render with
  4890	  // 2026's fallback shape and hours (Phase 1 fix review).
  4891	  const problems = registrySeasonProblems(registry);
  4892	  if (problems.length) {
  4893	    alert(`Summer ${season} isn't ready yet: the Summer Camp App's season still needs ${problems.join(', ')}. Finish setting it up there, then add it here.`);
  4894	    return;
  4895	  }
  4896	
  4897	  creatingSemester = true;
  4898	  try {
  4899	    // The local check above only saw this tab's config.
  4900	    const serverConfig = await readAppDataFromServer();
  4901	    if (serverConfig?.semesters?.[key]) {
  4902	      alert(`Summer ${season} was already added (in another tab, or by another admin). Reload to see it.`);
  4903	      return;
  4904	    }
  4905	    const newSem = semesterFromRegistrySeason(registry);
  4906	    await updateAppData({ [`semesters.${key}`]: newSem });
  4907	    currentConfig.semesters[key] = newSem;
  4908	    closeNewSemesterModal();
  4909	    renderSemesterSelector();
  4910	    initGlobalSemesterSelector();
  4911	    alert(`${newSem.name} added. It stays hidden from teachers until you publish it, and its camps appear here as the Summer Camp App publishes them.`);
  4912	  } catch (err) {
  4913	    console.error('❌ Could not add the camp season:', err);
  4914	    delete currentConfig.semesters[key];
  4915	    alert(`Could not add that season: ${err.message}`);
  4916	  } finally {
  4917	    creatingSemester = false;
  4918	  }
  4919	}
  4920	
  4921	async function createNewSemester() {
  4922	  if (creatingSemester) return;
  4923	  if (selectedNewSemesterType() === SEMESTER_TYPES.camp) return await createCampSeasonSemester();
  4924	  if (selectedNewSemesterType() === SEMESTER_TYPES.dayOff) return await createDayOffYear();
  4925	  const name = document.getElementById('new-sem-name')?.value.trim();
  4926	  if (!name) { alert('Semester name is required.'); return; }
  4927	
  4928	  const key = name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');
  4929	  if (currentConfig.semesters[key]) {
  4930	    alert(`A semester with key "${key}" already exists.`);
  4931	    return;
  4932	  }
  4933	
  4934	  const startDate = document.getElementById('new-sem-start')?.value || '';
  4935	  const numWeeks = parseInt(document.getElementById('new-sem-weeks')?.value) || 16;
  4936	  const breaksRaw = document.getElementById('new-sem-breaks')?.value.trim() || '';
  4937	  const breakWeeks = breaksRaw ? breaksRaw.split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n)) : [];
  4938	  const closuresRaw = document.getElementById('new-sem-closures')?.value.trim() || '';
  4939	  const closureDates = parseClosureDates(closuresRaw);
  4940	  const copyFromKey = document.getElementById('new-sem-copy-from')?.value || '';
  4941	
  4942	  const newSem = {
  4943	    name,
  4944	    semesterType: SEMESTER_TYPES.weekly,   // stored explicitly from now on (Phase 1, 1.1)
  4945	    startDate,
  4946	    numWeeks,
  4947	    breakWeeks,
  4948	    closureDates,
  4949	    published: false,
  4950	    classRoster: {}
  4951	  };
  4952	
  4953	  // Invoked from a bare HTML onclick — nothing above this frame catches, so a
  4954	  // failure anywhere below must be handled here (backtracking audit, Phase 11).
  4955	  // Two Firestore writes happen in sequence (lesson slots, then config); if the
  4956	  // second fails after the first landed, the slots are an orphan on the server
  4957	  // for a semester the admin was told didn't get created, and a retry with the
  4958	  // same name would silently reuse them. Track whether the first write landed
  4959	  // so the catch can compensate.
  4960	  let lessonDataCommitted = false;
  4961	  creatingSemester = true;
  4962	  try {
  4963	    // Copy roster from existing semester if selected
  4964	    if (copyFromKey && currentConfig.semesters[copyFromKey]) {
  4965	      // Pre-check (implementation review, Sep 2026): this branch is the only
  4966	      // path that writes lesson data, and the compensating delete in the catch
  4967	      // below removes the WHOLE `key` map — only safe if nothing lived there
  4968	      // before this call. It can: deleteSemester() drops a key from local
  4969	      // state even when its server-side deleteLessonData() fails (warn-only),
  4970	      // and config has no live listener, so another admin's same-named
  4971	      // semester isn't visible here either. Forced server read — the local
  4972	      // cache is exactly what can't be trusted for this key. Refuse unless
  4973	      // every existing lesson is template-empty (a prior createNewSemester()'s
  4974	      // own leftovers are safe to build on and safe to delete; anything else
  4975	      // would be merged over silently by the slot write, then deleted on
  4976	      // failure). The no-copy path is deliberately NOT gated: it writes no
  4977	      // lesson data, and re-creating a deleted semester there adopts its
  4978	      // surviving lesson data — the remedy this alert points at.
  4979	      const existingLessonMap = await readServerSemesterLessonMap(key);
  4980	      if (existingLessonMap && Object.values(existingLessonMap).some(l => !isTemplateEmptyLesson(l))) {
  4981	        alert(`Lesson content already exists in Firestore under the key "${key}".\n\nIf it was left over from a deleted semester, create this semester again without "Copy from" to adopt that data.\n\nIf another admin may have just created it, reload this page first.\n\nOtherwise choose a different name.`);
  4982	        return;
  4983	      }
  4984	
  4985	      const source = currentConfig.semesters[copyFromKey];
  4986	      newSem.classRoster = JSON.parse(JSON.stringify(source.classRoster || {}));
  4987	      // Without this, classRoster's teacher fields are copied but the dropdown
  4988	      // that lets Settings display/edit them has no options — the roster looks
  4989	      // wiped even though the underlying data isn't, and saving Settings in
  4990	      // that state silently writes blank teachers over the real ones.
  4991	      newSem.teacherNames = JSON.parse(JSON.stringify(source.teacherNames || []));
  4992	
  4993	      // Create empty lesson slots from source semester's teacher/class combos
  4994	      const sourceLessons = currentLessonData?.[copyFromKey] || {};
  4995	      const combos = new Set();
  4996	      for (const lesson of Object.values(sourceLessons)) {
  4997	        combos.add(`${lesson.teacher}|||${lesson.className}`);
  4998	      }
  4999	
  5000	      const emptyLessons = {};
  5001	      for (const combo of combos) {
  5002	        const [teacher, className] = combo.split('|||');
  5003	        for (let w = 1; w <= numWeeks; w++) {
  5004	          const lessonKey = makeLessonKey(teacher, className, w);
  5005	          emptyLessons[lessonKey] = {
  5006	            teacher,
  5007	            className,
  5008	            weekNum: w,
  5009	            weekDate: '',
  5010	            classSize: 0,
  5011	            projectTitle: '',
  5012	            shortDetails: '',
  5013	            inspoLink: '',
  5014	            introPitch: '',
  5015	            processStep1: '',
  5016	            processStep2: '',
  5017	            processStep3: '',
  5018	            processStep4: '',
  5019	            closure: '',
  5020	            materials: '',
  5021	            dayOfMaterials: '',
  5022	            materialsList: [],
  5023	            status: '',
  5024	            publishToPrep: ''
  5025	          };
  5026	        }
  5027	      }
  5028	
  5029	      if (Object.keys(emptyLessons).length > 0) {
  5030	        await saveLessonData(key, emptyLessons);
  5031	        if (!currentLessonData) currentLessonData = {};
  5032	        currentLessonData[key] = emptyLessons;
  5033	        lessonDataCommitted = true;
  5034	      }
  5035	    }
  5036	
  5037	    // Confirm on the SERVER that the key is free — the check at the top of this
  5038	    // function only saw this tab's copy of the config (Phase 1, 1.2). The
  5039	    // remaining read-to-update window is accepted: one admin, same class as the
  5040	    // existing residual on the Q&A path.
  5041	    const serverConfig = await readAppDataFromServer();
  5042	    if (serverConfig?.semesters?.[key]) {
  5043	      throw new Error(`A semester with the key "${key}" already exists (created in another tab or by another admin). Choose a different name.`);
  5044	    }
  5045	    currentConfig.semesters[key] = newSem;
  5046	    await updateAppData({ [`semesters.${key}`]: newSem });
  5047	  } catch (err) {
  5048	    console.error('❌ Could not create new semester:', err);
  5049	    // Revert both local mutations so a retry isn't blocked by a phantom
  5050	    // "already exists" and the grid doesn't render a semester that never saved.
  5051	    delete currentConfig.semesters[key];
  5052	    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
  5053	    // R4-11: the empty lesson slots may already be persisted even though the
  5054	    // config never was — clean up the orphaned server-side write, not just the
  5055	    // local copy. Safe: this data is template-empty by construction (never had
  5056	    // real content), so deleting it loses nothing.
  5057	    if (lessonDataCommitted) {
  5058	      try {
  5059	        await deleteLessonData(key);
  5060	      } catch (cleanupErr) {
  5061	        console.error('⚠️ Could not clean up orphaned lesson data after failed semester creation:', cleanupErr);
  5062	      }
  5063	    }
  5064	    alert('Could not create the new semester. Please try again.');
  5065	    return;
  5066	  } finally {
  5067	    creatingSemester = false;
  5068	  }
  5069	
  5070	  closeNewSemesterModal();
  5071	  caCurrentSemester = key;
  5072	  renderSemesterSelector();
  5073	  renderAdminGrid();
  5074	  renderHelpQueue();
  5075	  renderCutBank();
  5076	  renderIdeaBank();
  5077	  renderChangeHistory();
  5078	}
  5079	
  5080	async function initCurriculumAdmin() {
  5081	  if (caInitialized) return;
  5082	  caInitialized = true;
  5083	
  5084	  if (!currentLessonData) await loadLessonData();
  5085	  if (!currentChangeLog) await loadChangeLog();
  5086	  if (!currentCutProjects) await loadCutProjects();
  5087	  if (!currentFutureProjects) await loadFutureProjects();
  5088	
  5089	  renderSemesterSelector();
  5090	  renderAdminGrid();
  5091	  renderHelpQueue();
  5092	  renderCutBank();
  5093	  renderIdeaBank();
  5094	  renderChangeHistory();
  5095	
  5096	  // Modal close
  5097	  document.getElementById('ca-modal-close')?.addEventListener('click', closeAdminModal);
  5098	  document.getElementById('ca-detail-modal')?.addEventListener('click', (e) => {
  5099	    if (e.target === document.getElementById('ca-detail-modal')) closeAdminModal();
  5100	  });
  5101	
  5102	  // Real-time updates
  5103	  setupLessonDataListener((data) => {
  5104	    currentLessonData = data;
  5105	    renderAdminGrid();
  5106	    renderHelpQueue();
  5107	    // Refresh teacher mapping table in Settings if it exists
  5108	    renderTeacherMappingTable();
  5109	  });
  5110	}
  5111	
  5112	function renderAdminGrid() {
  5113	  const wrapper = document.getElementById('ca-grid-wrapper');
  5114	  const semKey = getAdminSemKey();
  5115	  const lessons = currentLessonData?.[semKey];

exec
/bin/zsh -lc "rg -n \"collection\\(['\\\"]curriculum['\\\"]\\).*doc\\(['\\\"]lessonData['\\\"]\\)|doc\\(['\\\"]lessonData['\\\"]\\)|lessonData_backup|storageMigrations|lessons_spring-2026|weeklyLessonTarget\\(\" --glob '*.js' --glob '"'!e2e/**'"' ." in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
./js/app.js:3733:    target = weeklyLessonTarget(semKey);   // own-doc semester: its own doc, or "editing is paused"
./js/app.js:7254:    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
./js/app.js:7343:    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
./js/app.js:7591:  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
./js/firebase-data.js:15:let ownDocUnsubscribes = [];   // own-doc semester + storageMigrations listeners (Spring 2026 storage move)
./js/firebase-data.js:82:// curriculum/storageMigrations says the move is verified.
./js/firebase-data.js:95:// curriculum/storageMigrations as last read ({} when absent; null = not yet known).
./js/firebase-data.js:117:function weeklyLessonTarget(semKey) {
./js/firebase-data.js:120:    return { ref: curriculumDb.collection('curriculum').doc('lessonData'), prefix: `${semKey}.` };
./js/firebase-data.js:137:  const legacy = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
./js/firebase-data.js:868:    const m = await curriculumDb.collection('curriculum').doc('storageMigrations').get();
./js/firebase-data.js:871:    console.warn('⚠️ Could not read curriculum/storageMigrations — own-doc semesters stay read-only:', err);
./js/firebase-data.js:913:    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
./js/firebase-data.js:973:    const { ref } = weeklyLessonTarget(semesterKey);   // throws "editing is paused" until verified
./js/firebase-data.js:977:  await curriculumDb.collection('curriculum').doc('lessonData').set({
./js/firebase-data.js:989:  const { ref, prefix } = weeklyLessonTarget(semesterKey);
./js/firebase-data.js:1126:  await curriculumDb.collection('curriculum').doc('lessonData').update({
./js/firebase-data.js:1147:  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
./js/firebase-data.js:1157:  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
./js/firebase-data.js:1335:  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
./js/firebase-data.js:1381:  ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc('storageMigrations')
./js/firebase-data.js:1385:    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; }));
./js/firebase-data.js:1650:  const { ref: weeklyRef, prefix } = weeklyLessonTarget(semesterKey);   // own-doc semester: its own doc (or "editing is paused")
./js/firebase-data.js:1705:  const { ref: weeklyRef, prefix } = weeklyLessonTarget(semesterKey);

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '5400,6125p;6180,6420p;6460,6570p;6920,7050p;7160,7390p;7560,7720p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
  5400	    // Empty cell — show edit form directly. `lesson` may be null (no doc at
  5401	    // all) OR a real contentless scaffold doc (teacher/className/weekNum set,
  5402	    // no projectTitle yet) — pass it through as-is so caEditLessonExisted
  5403	    // reflects whether a doc actually exists (Data Safety Plan Phase 9).
  5404	    captureAdminEditSnapshot(lesson);
  5405	    // Rendered from the same object the snapshot came from (a scaffold's
  5406	    // existing text, if any, shows in the form) — otherwise an unseen field
  5407	    // would be classified as an intentional clear on save.
  5408	    html += renderAdminEditForm(lesson, key, teacher, className, weekNum);
  5409	    html += `<hr style="margin:16px 0; border:none; border-top:1px solid #eee">`;
  5410	    html += `<p style="font-size:12px; color:var(--text-light); margin-bottom:8px">Or paste an existing project:</p>`;
  5411	    html += `<div class="ca-actions">
  5412	      <button class="btn-secondary ca-action-btn" onclick="showPasteFromCutBank(${escForOnclick(teacher)}, ${escForOnclick(className)}, ${weekNum})">Paste from Cut Bank</button>
  5413	      <button class="btn-secondary ca-action-btn" style="border-color:var(--tinker-teal);color:var(--tinker-teal)" onclick="showPasteFromIdeaBank(${escForOnclick(teacher)}, ${escForOnclick(className)}, ${weekNum})">Paste from Idea Bank</button>
  5414	    </div>`;
  5415	  }
  5416	
  5417	  body.innerHTML = html;
  5418	  modal.classList.add('open');
  5419	}
  5420	
  5421	// Data Safety Plan Phase 9: the admin edit popup's open-time snapshot — the
  5422	// same role teOriginalData / summerLessonOriginalData play for the two
  5423	// teacher editors, which this modal never had. saveAdminEdit() diffs the form
  5424	// against it so only fields the admin actually changed are sent to Firestore
  5425	// (a stale cached qaThread / photo / content field is never written back over
  5426	// another client's newer copy), and intentional clears become fieldsToClear.
  5427	let caEditOriginalData = null;
  5428	// Did a lesson doc exist at this key when the popup opened? Distinguishes
  5429	// first-time creation (nothing to conflict with) from "existed, might have
  5430	// been moved or deleted elsewhere since" — the existence check runs only for
  5431	// the latter. Meaningful for the non-summer schema only: summer cache entries
  5432	// are scaffolds regenerated from summerCamps_curriculum whether or not a
  5433	// summerCamps_lessonData doc exists yet, so saveAdminEdit() skips the check
  5434	// for summer regardless of this flag.
  5435	let caEditLessonExisted = false;
  5436	// One admin-popup save at a time: the Save button is a bare onclick with no
  5437	// disabled state, and the existence check below adds a server round-trip
  5438	// before anything visible happens — a double-click ran two full saves (two
  5439	// log entries, two photo uploads). Set before the first await, cleared in
  5440	// `finally`.
  5441	let caEditSaveInFlight = false;
  5442	
  5443	// The 11 fields the admin edit form actually lets an admin edit (see
  5444	// renderAdminEditForm) — planComplete/materialsList are shown read-only there.
  5445	const CA_EDIT_FIELDS = ['projectTitle', 'shortDetails', 'inspoLink', 'introPitch', 'processStep1', 'processStep2', 'processStep3', 'processStep4', 'closure', 'materials', 'dayOfMaterials'];
  5446	
  5447	// Called from BOTH places that render the admin edit form — showAdminEdit()
  5448	// and openDetailModal()'s empty-cell branch — so the snapshot is always the
  5449	// popup that's actually open, never left over from a previous one. Values are
  5450	// trimmed on the way in because saveAdminEdit() reads the form via
  5451	// .value.trim(); an untrimmed baseline would misclassify a field with
  5452	// incidental whitespace in Firestore as "changed" and resend it.
  5453	function captureAdminEditSnapshot(lesson) {
  5454	  const l = lesson || {};
  5455	  caEditLessonExisted = !!lesson;
  5456	  caEditOriginalData = {};
  5457	  for (const f of CA_EDIT_FIELDS) caEditOriginalData[f] = (l[f] || '').trim();
  5458	}
  5459	
  5460	// force === true: the in-flight save closing its own popup on success. Any
  5461	// other close (Cancel, the × button, the overlay — the latter two pass a click
  5462	// Event here, hence the strict check) is refused while a save is pending:
  5463	// otherwise the admin could open a second lesson mid-save and have the first
  5464	// save's completion close it and discard the new text.
  5465	function closeAdminModal(force) {
  5466	  if (caEditSaveInFlight && force !== true) return;
  5467	  document.getElementById('ca-detail-modal')?.classList.remove('open');
  5468	  caEditOriginalData = null;
  5469	  caEditLessonExisted = false;
  5470	}
  5471	
  5472	function startMove(sourceKey) {
  5473	  caActionMode = 'move';
  5474	  caSourceKey = sourceKey;
  5475	  closeAdminModal();
  5476	  renderAdminGrid();
  5477	}
  5478	
  5479	function renderAdminEditForm(lesson, key, teacher, className, weekNum) {
  5480	  const l = lesson || {};
  5481	  // Summer lessons are built from the Summer Camp App's curriculum: the title,
  5482	  // short details, inspo link and materials come from there on every load and
  5483	  // are never read back from the lesson doc (see SUMMER_SAVED_FIELDS), so an
  5484	  // edit here could only "save" and vanish — or, for the title, make the doc
  5485	  // look orphaned to the Summer Camp App. Render them read-only (same ids, so
  5486	  // the save-time diff sees them unchanged); saveAdminEditInner() still
  5487	  // refuses them as a backstop.
  5488	  const isSummerSchema = isCampSeason(getAdminSemKey());   // Phase 1, 1.1
  5489	  const ro = isSummerSchema ? ' readonly class="ca-edit-readonly" title="Managed in the Summer Camp App"' : '';
  5490	  const summerNote = isSummerSchema
  5491	    ? `<p class="te-photo-hint" style="margin:0 0 10px">Title, short details, inspo link and materials come from the Summer Camp App — edit them there. Everything below saves here.</p>`
  5492	    : '';
  5493	
  5494	  const hasRef = l.projectDetails || l.projectInspiration || l.projectAdminNotes || (l.materialsList && l.materialsList.length > 0);
  5495	  const refMatHtml = (l.materialsList && l.materialsList.length > 0)
  5496	    ? `<div class="field-group" style="margin-top:10px"><label style="font-size:12px;font-weight:700;color:#636E72;text-transform:uppercase;">Materials to Prep</label>
  5497	        <table class="materials-table" style="width:100%;border-collapse:collapse;font-size:12px;margin-top:4px">
  5498	          <thead><tr style="background:#f0f0f0">
  5499	            <th style="text-align:left;padding:5px 6px;border-bottom:1px solid #ddd">Material</th>
  5500	            <th style="text-align:left;padding:5px 6px;border-bottom:1px solid #ddd">Qty/Camper</th>
  5501	            <th style="text-align:left;padding:5px 6px;border-bottom:1px solid #ddd">Prep Category</th>
  5502	            <th style="text-align:left;padding:5px 6px;border-bottom:1px solid #ddd">How to Prep</th>
  5503	          </tr></thead>
  5504	          <tbody>${l.materialsList.map(m => `<tr>
  5505	            <td style="padding:5px 6px;border-bottom:1px solid #eee;vertical-align:top">${escHtml(m.name || '')}</td>
  5506	            <td style="padding:5px 6px;border-bottom:1px solid #eee;vertical-align:top">${escHtml(m.qtyPerCamper || '')}</td>
  5507	            <td style="padding:5px 6px;border-bottom:1px solid #eee;vertical-align:top">${escHtml(m.prepCategory || '')}</td>
  5508	            <td style="padding:5px 6px;border-bottom:1px solid #eee;vertical-align:top">${escHtml(m.howToPrep || '')}</td>
  5509	          </tr>`).join('')}</tbody>
  5510	        </table></div>` : '';
  5511	
  5512	  const refSection = hasRef ? `
  5513	    <div class="summer-reference-section" style="margin-bottom:16px">
  5514	      <h4 class="collapsible" onclick="this.classList.toggle('collapsed');this.nextElementSibling.classList.toggle('hidden');" style="cursor:pointer;font-size:14px;font-weight:700;color:#636E72;margin:0 0 8px;display:flex;align-items:center;gap:6px;">
  5515	        <span class="collapse-icon">▼</span> Project Reference Materials
  5516	      </h4>
  5517	      <div class="summer-reference-content">
  5518	        ${l.projectDetails ? `<div class="field-group"><label style="font-size:12px;font-weight:700;color:#636E72;text-transform:uppercase;">Project Details</label><div class="field-text" style="background:#fff;border:1px solid #eee;border-radius:6px;padding:8px;font-size:13px;line-height:1.5;margin-top:4px">${escHtml(l.projectDetails)}</div></div>` : ''}
  5519	        ${l.projectInspiration ? `<div class="field-group" style="margin-top:8px"><label style="font-size:12px;font-weight:700;color:#636E72;text-transform:uppercase;">Inspiration Links</label><div class="field-text" style="background:#fff;border:1px solid #eee;border-radius:6px;padding:8px;font-size:13px;margin-top:4px">${linkifyText(l.projectInspiration)}</div></div>` : ''}
  5520	        ${l.projectAdminNotes ? `<div class="field-group" style="margin-top:8px"><label style="font-size:12px;font-weight:700;color:#636E72;text-transform:uppercase;">Admin Notes</label><div class="field-text" style="background:#fff;border:1px solid #eee;border-radius:6px;padding:8px;font-size:13px;margin-top:4px">${escHtml(l.projectAdminNotes)}</div></div>` : ''}
  5521	        ${refMatHtml}
  5522	      </div>
  5523	    </div>` : '';
  5524	
  5525	  return `<div class="ca-edit-form" id="ca-edit-form">
  5526	    ${refSection}
  5527	    ${summerNote}
  5528	    <div class="settings-form-group">
  5529	      <label>Project Title *</label>
  5530	      <input type="text" id="ca-edit-title" value="${escAttr(l.projectTitle || '')}" placeholder="Project title"${ro}>
  5531	    </div>
  5532	    <div class="settings-form-group">
  5533	      <label>Short Details</label>
  5534	      <textarea id="ca-edit-details" rows="2" placeholder="Brief description"${ro}>${escHtml(l.shortDetails || '')}</textarea>
  5535	    </div>
  5536	    <div class="settings-form-group">
  5537	      <label>Inspo Link</label>
  5538	      <input type="url" id="ca-edit-inspo" value="${escAttr(l.inspoLink || '')}" placeholder="URL (optional)"${ro}>
  5539	    </div>
  5540	    <div class="settings-form-group">
  5541	      <label>Intro / Pitch</label>
  5542	      <textarea id="ca-edit-intro" rows="2" placeholder="How will you introduce this project?">${escHtml(l.introPitch || '')}</textarea>
  5543	    </div>
  5544	    <div class="settings-form-group">
  5545	      <label>Process Steps</label>
  5546	      <!-- textareas, not text inputs: an <input type="text"> strips newlines
  5547	           from its value, so a multi-line step written in the teacher or
  5548	           summer editor (both textareas) would be flattened here, read back
  5549	           as "changed", and resent — overwriting a concurrent edit and
  5550	           destroying the line breaks (Data Safety Plan Phase 9 review). -->
  5551	      <textarea id="ca-edit-step1" rows="2" placeholder="Step 1" style="margin-bottom:4px">${escHtml(l.processStep1 || '')}</textarea>
  5552	      <textarea id="ca-edit-step2" rows="2" placeholder="Step 2" style="margin-bottom:4px">${escHtml(l.processStep2 || '')}</textarea>
  5553	      <textarea id="ca-edit-step3" rows="2" placeholder="Step 3" style="margin-bottom:4px">${escHtml(l.processStep3 || '')}</textarea>
  5554	      <textarea id="ca-edit-step4" rows="2" placeholder="Step 4">${escHtml(l.processStep4 || '')}</textarea>
  5555	    </div>
  5556	    <div class="settings-form-group">
  5557	      <label>Closure</label>
  5558	      <textarea id="ca-edit-closure" rows="2" placeholder="How will you wrap up?">${escHtml(l.closure || '')}</textarea>
  5559	    </div>
  5560	    <div class="settings-form-group">
  5561	      <label>Materials to Prep</label>
  5562	      <textarea id="ca-edit-materials" rows="2" placeholder="Materials needed"${ro}>${escHtml(l.materials || '')}</textarea>
  5563	    </div>
  5564	    <div class="settings-form-group">
  5565	      <label>Day-Of Materials</label>
  5566	      <textarea id="ca-edit-dayof" rows="2" placeholder="Materials to set up day-of">${escHtml(l.dayOfMaterials || '')}</textarea>
  5567	    </div>
  5568	    <div class="settings-form-group">
  5569	      <label>Demo Photo</label>
  5570	      ${l.photoUrl ? `<div id="ca-edit-photo-preview" style="margin-bottom:8px">${safeHttpUrl(l.photoUrl) ? `<img src="${escAttr(safeHttpUrl(l.photoUrl))}" style="max-height:150px;border-radius:8px;border:1px solid var(--border-light)"><br>` : ''}<button type="button" class="te-photo-remove-btn" style="position:static;margin-top:4px" onclick="document.getElementById('ca-edit-photo-preview').remove();document.getElementById('ca-edit-photo-input').dataset.pendingRemove='true'">Remove photo</button></div>` : ''}
  5571	      <input type="file" id="ca-edit-photo-input" accept="image/*" capture="environment">
  5572	      <span class="te-photo-hint">Take a photo or choose from library (max 5MB)</span>
  5573	    </div>
  5574	    <div class="ca-actions" style="margin-top:12px">
  5575	      <button class="btn-primary ca-action-btn" onclick="saveAdminEdit(${escForOnclick(key)}, ${escForOnclick(teacher)}, ${escForOnclick(className)}, ${weekNum})">Save</button>
  5576	      <button class="btn-secondary ca-action-btn" onclick="printAdminLesson(${escForOnclick(key)})">&#128438; Print</button>
  5577	      <button class="btn-secondary ca-action-btn" onclick="closeAdminModal()">Cancel</button>
  5578	    </div>
  5579	  </div>`;
  5580	}
  5581	
  5582	function showAdminEdit(key, teacher, className, weekNum) {
  5583	  const semKey = getAdminSemKey();
  5584	  const lesson = currentLessonData?.[semKey]?.[key] || null;
  5585	  captureAdminEditSnapshot(lesson);
  5586	
  5587	  const modal = document.getElementById('ca-detail-modal');
  5588	  const title = document.getElementById('ca-modal-title');
  5589	  const body = document.getElementById('ca-modal-body');
  5590	
  5591	  title.textContent = lesson ? `Edit: ${lesson.projectTitle}` : `New Project — Week ${weekNum}`;
  5592	
  5593	  let html = `<div class="ca-detail-meta">
  5594	    <span><strong>Teacher:</strong> ${escHtml(teacher)}</span>
  5595	    <span><strong>Class:</strong> ${escHtml(className)}</span>
  5596	    <span><strong>Week:</strong> ${weekNum}</span>
  5597	  </div>`;
  5598	  html += renderAdminEditForm(lesson, key, teacher, className, weekNum);
  5599	
  5600	  body.innerHTML = html;
  5601	  modal.classList.add('open');
  5602	  // First editable field — on a summer lesson the title is read-only.
  5603	  document.querySelector('#ca-edit-form input:not([readonly]), #ca-edit-form textarea:not([readonly])')?.focus();
  5604	}
  5605	
  5606	// Data Safety Plan Phase 9 (+ backtracking audit Phase 1): the admin edit
  5607	// popup's save. What goes to Firestore is ONLY what this popup changed — the
  5608	// diff of the form against the open-time snapshot, plus the photo fields if
  5609	// this save touched them, plus identity/scheduling fields (teacher, className,
  5610	// weekNum, weekDate, classSize — no input in this form; resent from the cache
  5611	// exactly as before, an inherited exposure named in the plan, not a Phase 9
  5612	// change). The cached `existing` lesson is never spread into the payload, so
  5613	// a stale qaThread / photo / untouched content field can't overwrite another
  5614	// client's newer copy. Intentional clears travel as fieldsToClear. Before
  5615	// anything is written, a forced-server read confirms the lesson still exists
  5616	// (moved/deleted elsewhere while the popup was open → refuse, don't recreate
  5617	// a ghost). Residual check-to-write TOCTOU gap accepted per the plan.
  5618	async function saveAdminEdit(key, teacher, className, weekNum) {
  5619	  if (caEditSaveInFlight) return;
  5620	  const title = document.getElementById('ca-edit-title')?.value.trim();
  5621	  // (closeAdminModal() refuses non-forced closes while caEditSaveInFlight is
  5622	  // set — Cancel / × / overlay are effectively disabled for the duration.)
  5623	  if (!title) { alert('Project title is required.'); return; }
  5624	
  5625	  // Backtracking audit, Phase 1: check the guard BEFORE any Storage mutation
  5626	  // (and, now, before the existence check) so a known-bad load state never
  5627	  // gets as far as a server read, an upload, or a delete.
  5628	  if (lessonDataLoadedSuccessfully === false) {
  5629	    alert('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  5630	    return;
  5631	  }
  5632	
  5633	  caEditSaveInFlight = true;
  5634	  // Every action button in the modal body — the form's own Save/Print/Cancel
  5635	  // AND the empty-cell popup's two Paste buttons, which openDetailModal()
  5636	  // renders outside #ca-edit-form (round-3 review: they could replace the
  5637	  // modal body mid-save and race a second write onto the same slot).
  5638	  const btns = Array.from(document.querySelectorAll('#ca-modal-body .ca-actions button'));
  5639	  const saveBtn = btns.find(b => /^save/i.test(b.textContent.trim()));
  5640	  btns.forEach(b => { b.disabled = true; });
  5641	  if (saveBtn) saveBtn.textContent = 'Saving...';
  5642	  try {
  5643	    await saveAdminEditInner(key, teacher, className, weekNum, title);
  5644	  } finally {
  5645	    caEditSaveInFlight = false;
  5646	    btns.forEach(b => { b.disabled = false; });
  5647	    if (saveBtn) saveBtn.textContent = 'Save';
  5648	  }
  5649	}
  5650	
  5651	async function saveAdminEditInner(key, teacher, className, weekNum, title) {
  5652	  const semKey = getAdminSemKey();
  5653	
  5654	  const lessons = { ...(currentLessonData?.[semKey] || {}) };
  5655	  let existing = lessons[key] || {};   // rebased on the fresh server copy after the existence check (non-summer)
  5656	
  5657	  // Step 1 — diff the form against the open-time snapshot (pure DOM reads, no
  5658	  // side effects — so a no-op save can bail out below without paying for the
  5659	  // existence check's server read).
  5660	  const raw = {
  5661	    projectTitle: title,
  5662	    shortDetails: document.getElementById('ca-edit-details')?.value.trim() || '',
  5663	    inspoLink: document.getElementById('ca-edit-inspo')?.value.trim() || '',
  5664	    introPitch: document.getElementById('ca-edit-intro')?.value.trim() || '',
  5665	    processStep1: document.getElementById('ca-edit-step1')?.value.trim() || '',
  5666	    processStep2: document.getElementById('ca-edit-step2')?.value.trim() || '',
  5667	    processStep3: document.getElementById('ca-edit-step3')?.value.trim() || '',
  5668	    processStep4: document.getElementById('ca-edit-step4')?.value.trim() || '',
  5669	    closure: document.getElementById('ca-edit-closure')?.value.trim() || '',
  5670	    materials: document.getElementById('ca-edit-materials')?.value.trim() || '',
  5671	    dayOfMaterials: document.getElementById('ca-edit-dayof')?.value.trim() || '',
  5672	  };
  5673	  // No snapshot (shouldn't happen — both render paths capture one) degrades to
  5674	  // "everything non-empty is changed": today's behavior, never a lost edit.
  5675	  const baseline = caEditOriginalData || {};
  5676	  const changedFields = Object.keys(raw).filter(f => raw[f] !== (baseline[f] || ''));
  5677	  // Had text when the popup opened, empty now — an intentional clear, which
  5678	  // saveSingleLesson must apply with FieldValue.delete() rather than let the
  5679	  // stripping pass silently drop (Data Safety Plan Stage 3, never extended to
  5680	  // this third editor until now).
  5681	  const fieldsToClear = changedFields.filter(f => (baseline[f] || '') !== '' && raw[f] === '');
  5682	  const changedData = {};
  5683	  changedFields.forEach(f => { changedData[f] = raw[f]; });
  5684	
  5685	  const photoInput = document.getElementById('ca-edit-photo-input');
  5686	  const hasNewPhoto = photoInput?.files?.length > 0;
  5687	  let pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
  5688	  // Nothing changed — no write, no re-stamped lastEditedBy/At, no "edit" log
  5689	  // entry for an edit that didn't happen (mirrors saveTeacherEdit()).
  5690	  if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) {
  5691	    closeAdminModal(true);
  5692	    return;
  5693	  }
  5694	
  5695	  // Step 2 — forced-server read of this slot, before any side effect (the
  5696	  // photo upload, the write). Non-summer only: a summer cache entry is a
  5697	  // scaffold regenerated from summerCamps_curriculum whether or not its
  5698	  // summerCamps_lessonData doc exists (a missing doc means "never saved",
  5699	  // not "moved") and this app has no move/swap/cut path for summer lessons,
  5700	  // so there is no ghost to prevent — the first save legitimately creates
  5701	  // the doc. Same routing signal as saveSingleLesson() /
  5702	  // adminLessonStillExistsWithRetry() (key prefix; the camp-seasons plan
  5703	  // unifies this on semesterType). Forced read — a cache-permitting get()
  5704	  // could be served from the live listener's local cache in exactly the race
  5705	  // window this check exists to close. It runs for first-time creation too:
  5706	  // an "empty" slot in this tab's cache may have gained a project (a paste, a
  5707	  // move onto it) that the listener hasn't delivered yet.
  5708	  const isSummerSchema = isCampSeason(semKey);   // Phase 1, 1.1
  5709	  if (!isSummerSchema) {
  5710	    let check;
  5711	    try {
  5712	      check = await adminLessonStillExistsWithRetry(semKey, key);
  5713	    } catch (err) {
  5714	      console.warn('⚠️ Existence check retry also failed:', err);
  5715	      alert("Couldn't confirm this lesson still exists — check your connection and try saving again.");
  5716	      return;
  5717	    }
  5718	    if (caEditLessonExisted && !check.exists) {
  5719	      alert('This lesson was moved or removed elsewhere while you had it open. Your changes were not saved — please close this window and check the grid for its new location.');
  5720	      return;
  5721	    }
  5722	    if (check.exists) {
  5723	      // The key holds a doc — but a swap, a move ONTO this slot, or a paste
  5724	      // into a slot this tab still shows as empty leaves it populated with a
  5725	      // DIFFERENT project. The popup's edits were made against the project it
  5726	      // opened on; applying them to whatever is here now needs an explicit
  5727	      // decision, the same way cutProject() re-confirms when the fresh read
  5728	      // shows the slot's identity changed.
  5729	      const freshTitle = (check.data?.projectTitle || '').trim();
  5730	      if (freshTitle !== (baseline.projectTitle || '')) {
  5731	        const opened = baseline.projectTitle || '(empty slot)';
  5732	        if (!confirm(`This slot has changed since you opened it — it now contains "${freshTitle || '(empty)'}" instead of "${opened}". Save your changes onto "${freshTitle || 'this slot'}" anyway?\n\nCancel keeps your text here and saves nothing.`)) return;
  5733	      }
  5734	      // From here on, work from the FRESH copy, not this tab's cache: the
  5735	      // photo to delete after a replacement, the "remove photo" target, the
  5736	      // identity/scheduling fields resent below, the local cache merge and
  5737	      // the logged title all come from `existing`. On the swap-accept path
  5738	      // the cached copy's photoPath is the OTHER lesson's live photo.
  5739	      existing = check.data;
  5740	      pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
  5741	    }
  5742	  } else if (!existing.campName) {
  5743	    // A summer key that is no longer in the cache (the schedule was rebuilt
  5744	    // between open and save — e.g. the project was renamed in the Summer
  5745	    // Camp App) would produce a doc without its identity trio, which neither
  5746	    // app can find again. Refuse rather than write it.
  5747	    alert('This lesson is no longer in the summer schedule — reload and try again. Nothing was saved.');
  5748	    return;
  5749	  }
  5750	
  5751	  // Summer: projectTitle, shortDetails, inspoLink and materials belong to the
  5752	  // camp curriculum, not to the lesson doc — loadSummerCampData() takes them
  5753	  // from the scaffold and reads back only content/photo/completion fields
  5754	  // (SUMMER_SAVED_FIELDS), so an edit here would "save" and then vanish on the
  5755	  // next reload. projectTitle is worse: it is part of the lesson key, and the
  5756	  // Summer Camp App's orphan check treats a doc whose title isn't in the
  5757	  // camp's curriculum as orphaned content. Refuse them honestly rather than
  5758	  // write them into a doc where they can only mislead.
  5759	  const SUMMER_CURRICULUM_OWNED = ['projectTitle', 'shortDetails', 'inspoLink', 'materials'];
  5760	  if (isSummerSchema) {
  5761	    const refused = SUMMER_CURRICULUM_OWNED.filter(f => f in changedData);
  5762	    if (refused.length > 0) {
  5763	      const labels = { projectTitle: 'project title', shortDetails: 'short details', inspoLink: 'inspo link', materials: 'materials' };
  5764	      alert(`Summer camp ${refused.map(f => labels[f]).join(', ')} are managed in the Summer Camp App — that change is not saved here.` + (changedFields.length > refused.length || hasNewPhoto || pendingRemove ? ' Your other edits will still be saved.' : ''));
  5765	      refused.forEach(f => {
  5766	        delete changedData[f];
  5767	        const idx = changedFields.indexOf(f);
  5768	        if (idx !== -1) changedFields.splice(idx, 1);
  5769	        const cidx = fieldsToClear.indexOf(f);
  5770	        if (cidx !== -1) fieldsToClear.splice(cidx, 1);
  5771	      });
  5772	      if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) { closeAdminModal(true); return; }
  5773	    }
  5774	  }
  5775	
  5776	  // Firestore-bound payload — see the function comment for what's in it and why.
  5777	  const firestorePayload = {
  5778	    teacher, className, weekNum,
  5779	    weekDate: existing.weekDate || '',
  5780	    classSize: existing.classSize || 0,
  5781	    // Summer identity trio, key-derived and idempotent — a doc this save
  5782	    // CREATES must carry them (the Summer Camp App queries this collection by
  5783	    // campName + teacher and checks projectTitle; the summer editor sends the
  5784	    // same trio on every save for the same reason).
  5785	    ...(isSummerSchema ? { campName: existing.campName, block: existing.block, projectTitle: existing.projectTitle } : {}),
  5786	    ...changedData,
  5787	    lastImported: new Date().toISOString()
  5788	  };
  5789	
  5790	  // Backtracking audit, Phase 1 (R4-2): capture the OLD photoPath before any
  5791	  // mutation, so the delete-after-save step compares against the right value.
  5792	  const oldPhotoPath = existing.photoPath || null;
  5793	  let photoUrl = null, photoPath = null;   // null = this save didn't touch the photo
  5794	
  5795	  try {
  5796	    // Handle photo upload/removal
  5797	    if (hasNewPhoto) {
  5798	      const file = photoInput.files[0];
  5799	      if (file.size > 5 * 1024 * 1024) { alert('Photo must be under 5MB.'); return; }
  5800	      const { url, path } = await uploadLessonPhoto(semKey, key, file);
  5801	      // Delete of the OLD photo happens AFTER the save below — not here.
  5802	      photoUrl = url;
  5803	      photoPath = path;
  5804	    } else if (pendingRemove) {
  5805	      photoUrl = '';
  5806	      photoPath = '';
  5807	    }
  5808	    if (photoUrl !== null) {
  5809	      firestorePayload.photoUrl = photoUrl;
  5810	      firestorePayload.photoPath = photoPath;
  5811	    }
  5812	
  5813	    // Targeted single-lesson save with a diff-only payload — never the cached
  5814	    // full lesson, never the whole semester. (The summer branch's "no content"
  5815	    // guard can't refuse a legitimate save from here: for summer every
  5816	    // editable non-content field is curriculum-owned and refused above, so
  5817	    // what remains is content, a clear, or a photo — each admitted.)
  5818	    await saveSingleLesson(semKey, key, firestorePayload, fieldsToClear);
  5819	
  5820	    // Backtracking audit, Phase 1 (R4-2): only delete the OLD object once
  5821	    // Firestore has confirmed the new reference — and only when THIS save
  5822	    // actually replaced or removed the photo (photoUrl !== null). A text-only
  5823	    // edit leaves the old path untouched in both Firestore and Storage.
  5824	    if (photoUrl !== null && oldPhotoPath && oldPhotoPath !== (photoPath || null)) {
  5825	      try {
  5826	        await deleteLessonPhoto(oldPhotoPath);
  5827	      } catch (cleanupErr) {
  5828	        console.error('⚠️ Could not clean up old photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
  5829	      }
  5830	    }
  5831	  } catch (err) {
  5832	    // Backtracking audit, Phase 1 (R2-22): MUST return here — otherwise
  5833	    // execution falls through to commit currentLessonData, close the modal,
  5834	    // and log a fake edit even though the save never actually succeeded. The
  5835	    // snapshot is kept so the still-open popup can retry against it.
  5836	    console.error('❌ Admin edit failed to save:', err);
  5837	    alert('This edit could not be saved. Please try again.');
  5838	    return;
  5839	  }
  5840	
  5841	  // Local display/cache only — never sent to Firestore, so keeping the full
  5842	  // merge here is safe (staleness in untouched fields is cosmetic until the
  5843	  // listener's next delivery, same as the teacher editor).
  5844	  lessons[key] = {
  5845	    ...existing,
  5846	    teacher, className, weekNum,
  5847	    weekDate: firestorePayload.weekDate,
  5848	    classSize: firestorePayload.classSize,
  5849	    ...changedData,
  5850	    lastImported: firestorePayload.lastImported,
  5851	    lastEditedBy: firestorePayload.lastEditedBy,   // stamped by saveSingleLesson()
  5852	    lastEditedAt: firestorePayload.lastEditedAt
  5853	  };
  5854	  if (photoUrl !== null) { lessons[key].photoUrl = photoUrl; lessons[key].photoPath = photoPath; }
  5855	  fieldsToClear.forEach(f => { lessons[key][f] = ''; });
  5856	  currentLessonData[semKey] = lessons;
  5857	
  5858	  closeAdminModal(true);   // the save's own close — also resets the snapshot
  5859	  renderAdminGrid();
  5860	  renderChangeHistory();
  5861	
  5862	  try {
  5863	    // Log the title that was actually kept — for summer a refused retitle
  5864	    // must not show up in Change History under the refused name.
  5865	    const keptTitle = firestorePayload.projectTitle || existing.projectTitle || title;
  5866	    await appendChangeLogEntry(semKey, {
  5867	      action: existing.projectTitle ? 'edit' : 'create',
  5868	      details: { projectTitle: keptTitle, teacher, className, weekNum }
  5869	    });
  5870	    renderChangeHistory();
  5871	  } catch (e) { console.warn('Could not write change log entry:', e); }
  5872	}
  5873	
  5874	function startSwap(sourceKey) {
  5875	  caActionMode = 'swap';
  5876	  caSourceKey = sourceKey;
  5877	  closeAdminModal();
  5878	  renderAdminGrid();
  5879	}
  5880	
  5881	function cancelGridAction() {
  5882	  caActionMode = null;
  5883	  caSourceKey = null;
  5884	  renderAdminGrid();
  5885	}
  5886	
  5887	// Data Safety Plan Stage 2A/2B: shared helpers for the admin grid's move/swap
  5888	// abort-and-restore paths (see CLASSBOOK-DATA-SAFETY-PLAN.md).
  5889	// lessonHasContent() now lives in firebase-data.js (CONTENT_FIELDS is the
  5890	// single source of truth, Data Safety Plan Stage 4A) — this file just uses it.
  5891	
  5892	// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
  5893	// model. Backtracking audit, Phase 2 (reinstated round 4): adds an optional
  5894	// opts.source === 'server' param, needed by Phase 8's
  5895	// adminLessonStillExistsWithRetry() existence check below — omitting opts
  5896	// preserves the exact prior (cache-permitting) default for any future caller.
  5897	async function readAdminLessonDoc(semKey, lessonKey, opts = {}) {
  5898	  if (!curriculumDb) initCurriculumFirestore();
  5899	  const getOpts = opts.source === 'server' ? { source: 'server' } : undefined;
  5900	  const map = await readWeeklySemesterMap(semKey, getOpts);   // own-doc semesters read their own document
  5901	  return map?.[lessonKey] || null;
  5902	}
  5903	
  5904	// Backtracking audit, Phase 8: shared by cutProject() below and Phase 11's
  5905	// sendHelpResponse()/sendQaReply() (not yet implemented) — forced server
  5906	// read, retried once on failure, then lets a second failure throw so each
  5907	// caller decides how to surface it. Residual TOCTOU race (check-to-write gap)
  5908	// deliberately accepted, matching the companion plan's own decision for this
  5909	// identical helper — bounded by human click-to-click timing, not a tight
  5910	// machine loop; closing it fully would need a Firestore transaction.
  5911	async function adminLessonStillExistsWithRetry(semKey, key) {
  5912	  if (!curriculumDb) initCurriculumFirestore();
  5913	  const isSummer = lessonStoreFor(semKey) === 'camp';   // Phase 1, 1.1 — by type, and a third type throws
  5914	  const readOnce = async () => {
  5915	    if (isSummer) {
  5916	      const snap = await curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key)).get({ source: 'server' });
  5917	      return { exists: snap.exists, data: snap.exists ? snap.data() : null };
  5918	    }
  5919	    const data = await readAdminLessonDoc(semKey, key, { source: 'server' });
  5920	    return { exists: data !== null, data };
  5921	  };
  5922	  try {
  5923	    return await readOnce();
  5924	  } catch (err) {
  5925	    console.warn('⚠️ Existence check read failed, retrying once:', err);
  5926	    return await readOnce(); // a second failure throws — caller's catch handles it
  5927	  }
  5928	}
  5929	
  5930	// Reverts the admin grid's optimistic in-memory update after a move/swap that
  5931	// failed to save or failed verification — puts both slots back to their
  5932	// pre-action state (deleting the dest slot if it didn't exist before) and re-renders.
  5933	function restoreGridActionState(semKey, sourceKey, sourceLesson, destKey, destLesson) {
  5934	  if (!currentLessonData[semKey]) currentLessonData[semKey] = {};
  5935	  currentLessonData[semKey][sourceKey] = sourceLesson;
  5936	  if (destLesson) {
  5937	    currentLessonData[semKey][destKey] = destLesson;
  5938	  } else {
  5939	    delete currentLessonData[semKey][destKey];
  5940	  }
  5941	  renderAdminGrid();
  5942	}
  5943	
  5944	async function handleGridAction(destTeacher, destClassName, destWeekNum, destKey) {
  5945	  const semKey = getAdminSemKey();
  5946	  const lessons = { ...currentLessonData[semKey] };
  5947	  const sourceLesson = lessons[caSourceKey];
  5948	
  5949	  if (!sourceLesson) {
  5950	    cancelGridAction();
  5951	    return;
  5952	  }
  5953	
  5954	  // Prevent moving to same cell
  5955	  if (caSourceKey === destKey) {
  5956	    cancelGridAction();
  5957	    return;
  5958	  }
  5959	
  5960	  const destLesson = lessons[destKey] || null;
  5961	  const newDestKey = makeLessonKey(destTeacher, destClassName, destWeekNum);
  5962	
  5963	  if (caActionMode === 'move') {
  5964	    if (destLesson) {
  5965	      if (!confirm(`Week ${destWeekNum} already has "${destLesson.projectTitle}". This will overwrite it. Continue?`)) {
  5966	        cancelGridAction();
  5967	        return;
  5968	      }
  5969	    }
  5970	    if (!confirm(`Move "${sourceLesson.projectTitle}" from Week ${sourceLesson.weekNum} to ${destTeacher} / ${destClassName} Week ${destWeekNum}?`)) {
  5971	      cancelGridAction();
  5972	      return;
  5973	    }
  5974	
  5975	    // Move: put source content at destination, clear source
  5976	    const movedLesson = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum };
  5977	    movedLesson.weekDate = destLesson?.weekDate || '';
  5978	    // Backtracking audit, Phase 4: a content field non-empty at the existing
  5979	    // destination but empty in the incoming moved lesson must be explicitly
  5980	    // cleared — saveSingleLesson omits empty fields from the write rather
  5981	    // than clearing them, so without this the destination's old content
  5982	    // would silently survive underneath the moved lesson.
  5983	    const destFieldsToClear = CONTENT_FIELDS.filter(f =>
  5984	      (destLesson?.[f] || '').trim() !== '' && !(movedLesson[f] || '').trim()
  5985	    );
  5986	    lessons[newDestKey] = movedLesson;
  5987	    delete lessons[caSourceKey];
  5988	    currentLessonData[semKey] = lessons;
  5989	
  5990	    const sourceKeyToDelete = caSourceKey;
  5991	    const preMoveSourceLesson = sourceLesson;
  5992	    const preMoveDestLesson = destLesson;
  5993	    caActionMode = null;
  5994	    caSourceKey = null;
  5995	    renderAdminGrid();
  5996	    renderChangeHistory();
  5997	
  5998	    // Backtracking audit, Phase 9: the destination write and the source
  5999	    // delete are ONE atomic Firestore call — closes the "first write landed,
  6000	    // second failed" partial-failure race the prior sequential-write design
  6001	    // was vulnerable to. Does NOT independently verify movedLesson reflects
  6002	    // the CURRENT server state (a separate, deliberately deferred stale-input
  6003	    // race — see classbook-shared-document-concurrency-plan.html's 7th
  6004	    // instance) — no read-back needed or performed, since the write is
  6005	    // all-or-nothing.
  6006	    let moveSucceeded = false;
  6007	    try {
  6008	      await saveMultipleLessonFields(
  6009	        semKey,
  6010	        [{ lessonKey: newDestKey, lessonData: movedLesson, fieldsToClear: destFieldsToClear }],
  6011	        [sourceKeyToDelete]
  6012	      );
  6013	      moveSucceeded = true;
  6014	    } catch (err) {
  6015	      console.error('❌ Move failed:', err);
  6016	      restoreGridActionState(semKey, sourceKeyToDelete, preMoveSourceLesson, newDestKey, preMoveDestLesson);
  6017	      alert(`Move could not be saved — "${preMoveSourceLesson.projectTitle}" has been restored to its original slot. Nothing was changed.`);
  6018	      return;
  6019	    }
  6020	
  6021	    if (moveSucceeded) {
  6022	      try {
  6023	        await appendChangeLogEntry(semKey, {
  6024	          action: 'move',
  6025	          details: {
  6026	            projectTitle: sourceLesson.projectTitle,
  6027	            teacher: sourceLesson.teacher,
  6028	            className: sourceLesson.className,
  6029	            fromWeek: sourceLesson.weekNum,
  6030	            toTeacher: destTeacher,
  6031	            toClassName: destClassName,
  6032	            toWeek: destWeekNum
  6033	          }
  6034	        });
  6035	        renderChangeHistory();
  6036	      } catch (logErr) {
  6037	        console.error('⚠️ Move saved, but Change History logging failed:', logErr);
  6038	      }
  6039	    }
  6040	    return;
  6041	
  6042	  } else if (caActionMode === 'swap') {
  6043	    const destLabel = destLesson ? `"${destLesson.projectTitle}"` : 'empty slot';
  6044	    if (!confirm(`Swap "${sourceLesson.projectTitle}" (Week ${sourceLesson.weekNum}) with ${destLabel} (Week ${destWeekNum})?`)) {
  6045	      cancelGridAction();
  6046	      return;
  6047	    }
  6048	
  6049	    // Swap: exchange content between source and dest
  6050	    const sourceWeekNum = sourceLesson.weekNum;
  6051	    const sourceTeacher = sourceLesson.teacher;
  6052	    const sourceClassName = sourceLesson.className;
  6053	    const sourceWeekDate = sourceLesson.weekDate;
  6054	    const sourceKeyForSwap = caSourceKey;
  6055	
  6056	    let savePromise;
  6057	    let swapSucceeded = false;
  6058	    if (destLesson) {
  6059	      const swappedSource = { ...destLesson, teacher: sourceTeacher, className: sourceClassName, weekNum: sourceWeekNum, weekDate: sourceWeekDate };
  6060	      const swappedDest = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum, weekDate: destLesson.weekDate };
  6061	      // Backtracking audit, Phase 4: each slot's clear list compares its OWN
  6062	      // pre-swap content against what's now being written there — NOT the
  6063	      // other slot's pre-swap content, which would be a no-op since that's
  6064	      // identical-by-construction to the incoming value.
  6065	      const sourceFieldsToClear = CONTENT_FIELDS.filter(f =>
  6066	        (sourceLesson[f] || '').trim() !== '' && !(swappedSource[f] || '').trim()
  6067	      );
  6068	      const destFieldsToClearSwap = CONTENT_FIELDS.filter(f =>
  6069	        (destLesson[f] || '').trim() !== '' && !(swappedDest[f] || '').trim()
  6070	      );
  6071	      lessons[sourceKeyForSwap] = swappedSource;
  6072	      lessons[newDestKey] = swappedDest;
  6073	      currentLessonData[semKey] = lessons;
  6074	
  6075	      // Backtracking audit, Phase 9: both slots' writes are now ONE atomic
  6076	      // Firestore call — closes the "first save landed, second failed"
  6077	      // partial-failure race the prior two-sequential-saves design was
  6078	      // vulnerable to.
  6079	      savePromise = (async () => {
  6080	        try {
  6081	          await saveMultipleLessonFields(semKey, [
  6082	            { lessonKey: sourceKeyForSwap, lessonData: swappedSource, fieldsToClear: sourceFieldsToClear },
  6083	            { lessonKey: newDestKey, lessonData: swappedDest, fieldsToClear: destFieldsToClearSwap }
  6084	          ]);
  6085	          swapSucceeded = true;
  6086	        } catch (err) {
  6087	          console.error('❌ Swap failed:', err);
  6088	          restoreGridActionState(semKey, sourceKeyForSwap, sourceLesson, newDestKey, destLesson);
  6089	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" and "${destLesson.projectTitle}" have been restored to their original slots.`);
  6090	        }
  6091	      })();
  6092	    } else {
  6093	      // Swap with empty: move source to dest, clear source. Backtracking
  6094	      // audit, Phase 9: the destination write and source delete are now ONE
  6095	      // atomic Firestore call, same reasoning as the move branch above.
  6096	      const movedLesson = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum, weekDate: '' };
  6097	      lessons[newDestKey] = movedLesson;
  6098	      delete lessons[sourceKeyForSwap];
  6099	      currentLessonData[semKey] = lessons;
  6100	      savePromise = (async () => {
  6101	        try {
  6102	          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
  6103	          swapSucceeded = true;
  6104	        } catch (err) {
  6105	          console.error('❌ Swap failed:', err);
  6106	          restoreGridActionState(semKey, sourceKeyForSwap, sourceLesson, newDestKey, null);
  6107	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" has been restored to its original slot.`);
  6108	        }
  6109	      })();
  6110	    }
  6111	
  6112	    caActionMode = null;
  6113	    caSourceKey = null;
  6114	    renderAdminGrid();
  6115	    renderChangeHistory();
  6116	
  6117	    await savePromise;
  6118	
  6119	    if (swapSucceeded) {
  6120	      try {
  6121	        await appendChangeLogEntry(semKey, {
  6122	          action: 'swap',
  6123	          details: {
  6124	            projectTitle: sourceLesson.projectTitle,
  6125	            teacher: sourceTeacher,
  6180	      </div>`;
  6181	
  6182	  for (const s of shared) {
  6183	    const hasPlan = hasLessonContent(s);
  6184	    const warnClass = hasPlan ? 'ca-copy-has-plan' : '';
  6185	    const warnLabel = hasPlan ? ' (has existing plan — will overwrite)' : ' (no plan yet)';
  6186	    html += `<div class="ca-copy-target ${warnClass}">
  6187	      <label>
  6188	        <input type="checkbox" class="ca-copy-cb" data-key="${escAttr(s.key)}" ${!hasPlan ? 'checked' : ''}>
  6189	        ${escHtml(s.teacher)} &mdash; ${escHtml(s.className)} (Week ${s.weekNum})
  6190	        <span class="ca-copy-warn">${warnLabel}</span>
  6191	      </label>
  6192	    </div>`;
  6193	  }
  6194	
  6195	  html += `</div>
  6196	    <div class="ca-actions" style="margin-top: 16px;">
  6197	      <button class="btn-primary ca-action-btn ca-copy-btn" onclick="executeCopyPlan(${escForOnclick(sourceKey)})">Copy Plan</button>
  6198	      <button class="btn-secondary ca-action-btn" onclick="openDetailModal(currentLessonData[${escForOnclick(semKey)}][${escForOnclick(sourceKey)}], ${escForOnclick(sourceKey)}, ${escForOnclick(source.teacher)}, ${escForOnclick(source.className)}, ${source.weekNum})">Back</button>
  6199	    </div>
  6200	  </div>`;
  6201	
  6202	  body.innerHTML = html;
  6203	}
  6204	
  6205	function toggleCopyAll(masterCb) {
  6206	  document.querySelectorAll('.ca-copy-cb').forEach(cb => { cb.checked = masterCb.checked; });
  6207	}
  6208	
  6209	// Backtracking audit, Phase 11 (R3-12, R3-13). Previously resaved the ENTIRE
  6210	// cached semester via saveLessonData() — any lesson whose local copy was stale
  6211	// (a teacher's concurrent save in another tab) was silently reverted on the
  6212	// server — mutated the shared cache before any write landed, and logged only
  6213	// after one bulk save, so a part-way failure lost the log for targets that
  6214	// had actually been written. Now: one targeted saveSingleLesson() per target
  6215	// with an explicit fieldsToClear (a source field that is EMPTY must clear the
  6216	// target's stale value — the save strips empty content fields, so without the
  6217	// clear the old text would survive under the new plan), cache committed per
  6218	// target only after its save resolves, logged immediately, honest count on
  6219	// failure.
  6220	async function executeCopyPlan(sourceKey) {
  6221	  const semKey = getAdminSemKey();
  6222	  const liveLessons = currentLessonData?.[semKey];
  6223	  const source = liveLessons?.[sourceKey];
  6224	  if (!source) return;
  6225	
  6226	  const checkboxes = document.querySelectorAll('.ca-copy-cb:checked');
  6227	  const targetKeys = Array.from(checkboxes).map(cb => cb.dataset.key);
  6228	
  6229	  if (targetKeys.length === 0) {
  6230	    alert('No targets selected.');
  6231	    return;
  6232	  }
  6233	
  6234	  // Check if any targets have existing plans
  6235	  const overwriteTargets = targetKeys.filter(k => liveLessons[k] && hasLessonContent(liveLessons[k]));
  6236	  if (overwriteTargets.length > 0) {
  6237	    const names = overwriteTargets.map(k => {
  6238	      const l = liveLessons[k];
  6239	      return `${l.teacher} — ${l.className} (Wk ${l.weekNum})`;
  6240	    }).join('\n');
  6241	    if (!confirm(`${overwriteTargets.length} target(s) already have lesson plans that will be overwritten:\n\n${names}\n\nContinue?`)) return;
  6242	  }
  6243	
  6244	  const fields = getCopyableFields(source); // the 7 CONTENT_FIELDS plus `materials`
  6245	  let savedCount = 0;
  6246	  let failure = null;
  6247	
  6248	  try {
  6249	    for (const targetKey of targetKeys) {
  6250	      if (!liveLessons[targetKey]) continue;
  6251	      // Work on copies — the shared cache object is only replaced below,
  6252	      // after this target's own save has resolved (R3-13).
  6253	      const previousTarget = { ...liveLessons[targetKey] };
  6254	      const targetFieldsToClear = CONTENT_FIELDS.filter(f =>
  6255	        (previousTarget[f] || '').trim() !== '' && !(fields[f] || '').trim()
  6256	      );
  6257	      // Send ONLY the copied fields (saveSingleLesson writes per-field paths
  6258	      // and stamps lastEditedBy/At onto this object). Sending the whole
  6259	      // cached target would re-write every non-content field — qaThread,
  6260	      // photoUrl, planComplete… — from this admin's possibly-stale copy over
  6261	      // a teacher's concurrent change (implementation review, Sep 2026).
  6262	      const payload = { ...fields };
  6263	      await saveSingleLesson(semKey, targetKey, payload, targetFieldsToClear);
  6264	      const updatedTarget = { ...previousTarget, ...payload };
  6265	      if (currentLessonData[semKey]) currentLessonData[semKey][targetKey] = updatedTarget;
  6266	      savedCount++;
  6267	      // Uncheck the saved target so, if a later one fails, "retry the rest"
  6268	      // re-runs only the rest (no duplicate copies or Change History entries).
  6269	      const cb = document.querySelector(`.ca-copy-cb[data-key="${CSS.escape(targetKey)}"]`);
  6270	      if (cb) cb.checked = false;
  6271	
  6272	      // Log this copy now — before the next target — so a later failure
  6273	      // can't lose the record of a write that already landed.
  6274	      const logEntry = {
  6275	        action: 'copy',
  6276	        details: {
  6277	          projectTitle: source.projectTitle,
  6278	          fromTeacher: source.teacher,
  6279	          fromClassName: source.className,
  6280	          fromWeek: source.weekNum,
  6281	          toTeacher: updatedTarget.teacher,
  6282	          toClassName: updatedTarget.className,
  6283	          toWeek: updatedTarget.weekNum
  6284	        }
  6285	      };
  6286	      // Capture the overwritten plan whenever ANY copyable field had text —
  6287	      // the clear above is explicit and intentional, so Change History must
  6288	      // hold the recovery record even when the prior content lived only in
  6289	      // processStep2-4/closure/dayOfMaterials (which the looser
  6290	      // hasLessonContent() used for the confirm prompt doesn't look at).
  6291	      const previousPlan = getCopyableFields(previousTarget);
  6292	      if (Object.values(previousPlan).some(v => String(v).trim())) {
  6293	        logEntry.details.previousPlan = previousPlan;
  6294	      }
  6295	      try {
  6296	        await appendChangeLogEntry(semKey, logEntry);
  6297	      } catch (logErr) {
  6298	        // The copy itself is saved; a Change History miss must not read as
  6299	        // a failed copy (same rule as saveTeacherEdit(), Phase 8).
  6300	        console.error('⚠️ Copy saved, but Change History logging failed for', targetKey, logErr);
  6301	      }
  6302	    }
  6303	  } catch (err) {
  6304	    console.error('❌ Copy Plan failed partway through:', err);
  6305	    failure = err;
  6306	  }
  6307	
  6308	  // UI after the try/catch so a render exception can't be misreported as a
  6309	  // failed save (and can't re-throw from inside the catch).
  6310	  renderAdminGrid();
  6311	  renderChangeHistory();
  6312	  if (failure) {
  6313	    alert(`Copied to ${savedCount} of ${targetKeys.length} class(es) before a save failed. Please check which targets actually received the plan before retrying the rest.\n\n${failure.message}`);
  6314	    return;
  6315	  }
  6316	  closeAdminModal();
  6317	  const skipped = targetKeys.length - savedCount;
  6318	  alert(`Plan copied to ${savedCount} class${savedCount !== 1 ? 'es' : ''}${skipped > 0 ? ` (${skipped} skipped)` : ''}.`);
  6319	}
  6320	
  6321	// Backtracking audit, Phase 8: rebuilt around the companion plan's Phase 17
  6322	// design. Forced-server read before archiving or deleting anything (closes
  6323	// two failure modes: the doc no longer existing at all, and the doc existing
  6324	// but having genuinely different content than this admin's stale local
  6325	// snapshot — a teacher's concurrent edit). Archives the COMPLETE fresh
  6326	// lesson object (not a hand-picked field list) via FieldValue.arrayUnion()
  6327	// against curriculum/cutProjects (not saveCutProjects()'s local-splice-then-
  6328	// full-array-overwrite — two admins cutting concurrently now both survive
  6329	// regardless of write order). Archive-before-delete ordering — a failed
  6330	// archive save leaves the live lesson completely untouched.
  6331	async function cutProject(key) {
  6332	  const semKey = getAdminSemKey();
  6333	  const lessons = { ...currentLessonData[semKey] };
  6334	  const lesson = lessons[key];
  6335	  if (!lesson) return;
  6336	
  6337	  if (!confirm(`Cut "${lesson.projectTitle}" from ${lesson.teacher} / ${lesson.className} Week ${lesson.weekNum}? It will be moved to the Cut Projects bank.`)) return;
  6338	
  6339	  let check;
  6340	  try {
  6341	    check = await adminLessonStillExistsWithRetry(semKey, key);
  6342	  } catch (err) {
  6343	    console.error('Could not confirm current state before cutting', key, err);
  6344	    alert(`Could not confirm "${lesson.projectTitle}" still exists — nothing was cut. Check your connection and try again.`);
  6345	    return;
  6346	  }
  6347	  if (!check.exists) {
  6348	    alert(`"${lesson.projectTitle}" no longer exists — it may have been moved, deleted, or already cut by someone else. Nothing was cut.`);
  6349	    if (currentLessonData[semKey]) delete currentLessonData[semKey][key];
  6350	    renderAdminGrid();
  6351	    return;
  6352	  }
  6353	  const freshLesson = check.data;
  6354	
  6355	  // The first confirm() above authorized cutting THIS project, by name — if
  6356	  // the fresh read shows the slot's identity has materially changed since
  6357	  // then, that authorization doesn't cover it.
  6358	  if (freshLesson.projectTitle !== lesson.projectTitle || freshLesson.teacher !== lesson.teacher || freshLesson.className !== lesson.className) {
  6359	    if (!confirm(`This slot has changed since you opened it — it now contains "${freshLesson.projectTitle}" (${freshLesson.teacher} / ${freshLesson.className}). Cut this instead?`)) return;
  6360	  }
  6361	
  6362	  const user = getAuthUser();
  6363	  const archiveEntry = {
  6364	    ...freshLesson,
  6365	    originalTeacher: freshLesson.teacher,
  6366	    originalClassName: freshLesson.className,
  6367	    originalWeek: freshLesson.weekNum,
  6368	    cutDate: new Date().toISOString(),
  6369	    cutBy: user?.name || 'Unknown'
  6370	  };
  6371	
  6372	  if (!curriculumDb) initCurriculumFirestore();
  6373	  try {
  6374	    await curriculumDb.collection('curriculum').doc('cutProjects').set({
  6375	      [semKey]: firebase.firestore.FieldValue.arrayUnion(archiveEntry)
  6376	    }, { merge: true });
  6377	  } catch (e) {
  6378	    console.error('Could not save Cut Bank entry for', key, e);
  6379	    alert(`Could not cut "${freshLesson.projectTitle}" — the Cut Bank entry could not be saved. Nothing was changed.`);
  6380	    return;
  6381	  }
  6382	
  6383	  let deleteFailed = false;
  6384	  try {
  6385	    await deleteLessonKey(semKey, key);
  6386	  } catch (e) {
  6387	    console.error('Could not delete lesson after archiving', key, e);
  6388	    deleteFailed = true;
  6389	  }
  6390	
  6391	  // Local cache/grid only drops the lesson when the delete actually
  6392	  // succeeded — a failed delete leaves the grid showing the lesson as gone
  6393	  // while Firestore still has it live otherwise.
  6394	  if (!deleteFailed) {
  6395	    delete lessons[key];
  6396	    currentLessonData[semKey] = lessons;
  6397	  }
  6398	  if (!currentCutProjects) currentCutProjects = {};
  6399	  currentCutProjects[semKey] = [...(currentCutProjects[semKey] || []), archiveEntry];
  6400	
  6401	  try {
  6402	    await appendChangeLogEntry(semKey, {
  6403	      action: 'cut',
  6404	      details: { projectTitle: freshLesson.projectTitle, teacher: freshLesson.teacher, className: freshLesson.className, fromWeek: freshLesson.weekNum }
  6405	    });
  6406	    renderChangeHistory();
  6407	  } catch (logErr) {
  6408	    console.error('⚠️ Cut saved, but Change History logging failed:', logErr);
  6409	  }
  6410	
  6411	  closeAdminModal();
  6412	  renderAdminGrid();
  6413	  renderCutBank();
  6414	  renderChangeHistory();
  6415	
  6416	  if (deleteFailed) {
  6417	    alert(`"${freshLesson.projectTitle}" was safely archived to the Cut Bank, but could NOT be removed from the grid. Please reload and check — it may now appear in both places.`);
  6418	  }
  6419	}
  6420	
  6460	  if (otherSemesters.length > 0) {
  6461	    html += `<details style="margin-top:16px"><summary style="font-size:14px;font-weight:600;cursor:pointer;color:var(--tinker-purple)">From previous semesters (${otherSemesters.reduce((s, o) => s + o.projects.length, 0)} projects)</summary>`;
  6462	    for (const other of otherSemesters) {
  6463	      html += `<div style="margin-top:12px"><div style="font-size:12px;font-weight:700;color:var(--text-light);text-transform:uppercase;margin-bottom:6px">${escHtml(other.name)}</div><div class="ca-cut-list">`;
  6464	      other.projects.forEach((proj, idx) => {
  6465	        html += `<div class="ca-cut-item" onclick="pasteFromCutBank(${idx}, ${escForOnclick(teacher)}, ${escForOnclick(className)}, ${weekNum}, ${escForOnclick(other.key)})">
  6466	          <div class="ca-cut-item-title">${escHtml(proj.projectTitle)}</div>
  6467	          <div class="ca-cut-item-meta">Originally: ${escHtml(proj.originalTeacher)} / ${escHtml(proj.originalClassName || '')} Week ${proj.originalWeek} &middot; Cut ${new Date(proj.cutDate).toLocaleDateString()}</div>
  6468	        </div>`;
  6469	      });
  6470	      html += '</div></div>';
  6471	    }
  6472	    html += '</details>';
  6473	  }
  6474	
  6475	  body.innerHTML = html;
  6476	}
  6477	
  6478	// Backtracking audit, Phase 8: targeted single-lesson save (not a bulk
  6479	// saveLessonData() semester overwrite), removal via FieldValue.arrayRemove()
  6480	// (not saveCutProjects()'s local-splice-then-full-array-overwrite — matches
  6481	// cutProject()'s arrayUnion() append-side fix, same document, same reasoning:
  6482	// two admins acting on the Cut Bank concurrently now both survive). The
  6483	// reconstruction below is an EXPLICIT FIELD WHITELIST, not spread-minus-
  6484	// exclude — a whitelist can't leak a future field cutProject()'s
  6485	// complete-spread archive starts including that an exclude-list doesn't yet
  6486	// know to exclude. classSize preserves the destination's own existing
  6487	// scaffold value (round-6 fix) rather than being hardcoded to 0 — nothing
  6488	// downstream recomputes it on paste. teacherNotes/adminResponse/status are
  6489	// excluded alongside qaThread (round-6 fix): getQaThread() reconstructs a
  6490	// Q&A thread from teacherNotes/adminResponse whenever qaThread is absent, so
  6491	// restoring those two fields alone would still leak the original
  6492	// conversation even with qaThread itself correctly omitted.
  6493	async function pasteFromCutBank(cutIndex, teacher, className, weekNum, sourceSemKey) {
  6494	  const destSemKey = getAdminSemKey();
  6495	  const srcSemKey = sourceSemKey || destSemKey;
  6496	  const cutProjects = currentCutProjects?.[srcSemKey] || [];
  6497	  const proj = cutProjects[cutIndex];
  6498	  if (!proj) return;
  6499	
  6500	  const isCrossSemester = srcSemKey !== destSemKey;
  6501	  const srcSemName = currentConfig?.semesters?.[srcSemKey]?.name || srcSemKey;
  6502	  const confirmMsg = isCrossSemester
  6503	    ? `Paste "${proj.projectTitle}" from ${srcSemName} into ${teacher} / ${className} Week ${weekNum}?`
  6504	    : `Paste "${proj.projectTitle}" into ${teacher} / ${className} Week ${weekNum}?`;
  6505	  if (!confirm(confirmMsg)) return;
  6506	
  6507	  const key = makeLessonKey(teacher, className, weekNum);
  6508	  const lessons = { ...(currentLessonData?.[destSemKey] || {}) };
  6509	  const existingDest = lessons[key] || {};
  6510	  const existingDestClassSize = existingDest.classSize || 0;
  6511	  const existingDestPhotoPath = existingDest.photoPath || null;
  6512	
  6513	  lessons[key] = {
  6514	    teacher, className, weekNum, weekDate: '', classSize: existingDestClassSize,
  6515	    projectTitle: proj.projectTitle,
  6516	    shortDetails: proj.shortDetails || '',
  6517	    inspoLink: proj.inspoLink || '',
  6518	    introPitch: proj.introPitch || '',
  6519	    processStep1: proj.processStep1 || '', processStep2: proj.processStep2 || '',
  6520	    processStep3: proj.processStep3 || '', processStep4: proj.processStep4 || '',
  6521	    closure: proj.closure || '',
  6522	    materials: proj.materials || '',
  6523	    materialsList: proj.materialsList || [],
  6524	    dayOfMaterials: proj.dayOfMaterials || '',
  6525	    publishToPrep: proj.publishToPrep || '',
  6526	    lastImported: new Date().toISOString()
  6527	    // Deliberately NOT restored: qaThread, photoUrl/photoPath, planComplete
  6528	    // (tied to the ORIGINAL lesson instance, not reusable project content),
  6529	    // and teacherNotes/adminResponse/status (round-6: getQaThread() would
  6530	    // silently reconstruct the original Q&A conversation from these alone).
  6531	  };
  6532	  // Merely OMITTING those fields above only means "don't touch them" — if the
  6533	  // DESTINATION slot already had its own stale qaThread/photo/planComplete
  6534	  // from whatever occupied it before, that would otherwise survive untouched
  6535	  // and resurrect an unrelated Q&A thread under the newly-pasted content.
  6536	  // Explicitly clear them so a paste genuinely starts fresh.
  6537	  const NON_CONTENT_FIELDS_TO_CLEAR = ['qaThread', 'photoUrl', 'photoPath', 'planComplete', 'teacherNotes', 'adminResponse', 'status'];
  6538	
  6539	  let pasteConfirmed = false;
  6540	  try {
  6541	    await saveSingleLesson(destSemKey, key, lessons[key], NON_CONTENT_FIELDS_TO_CLEAR);
  6542	    pasteConfirmed = true;
  6543	  } catch (err) {
  6544	    console.error('❌ Paste from Cut Bank failed to save the lesson:', err);
  6545	    alert(`Could not paste "${proj.projectTitle}" — please try again.`);
  6546	    return;
  6547	  }
  6548	
  6549	  // Only delete the destination's old photo from Storage after Firestore has
  6550	  // confirmed the clear — same safe ordering as saveAdminEdit()/saveTeacherEdit().
  6551	  if (existingDestPhotoPath) {
  6552	    try {
  6553	      await deleteLessonPhoto(existingDestPhotoPath);
  6554	    } catch (cleanupErr) {
  6555	      console.error('⚠️ Could not clean up destination\'s old photo after paste (Firestore is correct, Storage has an orphan):', cleanupErr);
  6556	    }
  6557	  }
  6558	
  6559	  currentLessonData[destSemKey] = lessons;
  6560	  closeAdminModal();
  6561	  renderAdminGrid();
  6562	
  6563	  if (!curriculumDb) initCurriculumFirestore();
  6564	  try {
  6565	    await curriculumDb.collection('curriculum').doc('cutProjects').set({
  6566	      [srcSemKey]: firebase.firestore.FieldValue.arrayRemove(proj)
  6567	    }, { merge: true });
  6568	    if (currentCutProjects?.[srcSemKey]) {
  6569	      currentCutProjects[srcSemKey] = currentCutProjects[srcSemKey].filter(p => p !== proj);
  6570	    }
  6920	
  6921	function showPasteFromIdeaBank(teacher, className, weekNum) {
  6922	  const projects = (currentFutureProjects?.projects || []).filter(p => !p.archived);
  6923	
  6924	  if (projects.length === 0) {
  6925	    alert('No ideas in the bank. Add some in the Future Projects section first.');
  6926	    return;
  6927	  }
  6928	
  6929	  const body = document.getElementById('ca-modal-body');
  6930	  let html = `<h4 class="ca-paste-title">Paste from Idea Bank</h4>
  6931	    <p class="ca-paste-hint">Select an idea to place in ${escHtml(teacher)} / ${escHtml(className)} Week ${weekNum}:</p>
  6932	    <p class="ca-paste-hint" style="font-style:italic;color:var(--tinker-teal)">Pasting places the idea on the grid — it will be removed from the Idea Bank.</p>
  6933	    <div class="ca-cut-list">`;
  6934	
  6935	  projects.forEach((proj, idx) => {
  6936	    // Find the real index in the full array (including archived)
  6937	    const realIdx = currentFutureProjects.projects.indexOf(proj);
  6938	    html += `<div class="ca-cut-item" onclick="pasteFromIdeaBank(${realIdx}, ${escForOnclick(teacher)}, ${escForOnclick(className)}, ${weekNum})">
  6939	      <div class="ca-cut-item-title">${escHtml(proj.title)}</div>
  6940	      <div class="ca-cut-item-meta">${proj.description ? escHtml(proj.description.substring(0, 100)) + (proj.description.length > 100 ? '...' : '') : 'No description'}</div>
  6941	      ${proj.tags?.length ? `<div class="ca-ideabank-tags" style="margin-top:4px">${proj.tags.map(t => `<span class="ca-tag-pill">${escHtml(t)}</span>`).join('')}</div>` : ''}
  6942	    </div>`;
  6943	  });
  6944	
  6945	  html += '</div>';
  6946	  body.innerHTML = html;
  6947	}
  6948	
  6949	// Backtracking audit Phase 11 (R3-10, R3-11, round-4 fieldsToClear; hardened
  6950	// by this session's implementation review): the original bulk
  6951	// saveLessonData() write passed the WHOLE {projects:[...]} wrapper into
  6952	// saveFutureProjects() (which expects a bare array), double-nesting
  6953	// curriculum/futureProjects and corrupting renderIdeaBank()'s cache — a
  6954	// deterministic, live production bug. Also removed the idea from the bank
  6955	// BEFORE the destination lesson save was confirmed. Rewritten around a
  6956	// targeted saveSingleLesson() write (unrelated lessons in the same semester
  6957	// are no longer touched), explicit fieldsToClear against the destination's
  6958	// own pre-existing stale content — both CONTENT_FIELDS and the
  6959	// instance-specific fields an Idea Bank project never supplies (matching
  6960	// pasteFromCutBank()'s own NON_CONTENT_FIELDS_TO_CLEAR pattern, since simply
  6961	// omitting a field only means "don't touch it," not "clear it") — and
  6962	// lesson-save-then-idea-removal ordering with an honest duplicate-message on
  6963	// a removal failure.
  6964	async function pasteFromIdeaBank(idx, teacher, className, weekNum) {
  6965	  const projects = currentFutureProjects?.projects || [];
  6966	  const proj = projects[idx];
  6967	  if (!proj) return;
  6968	
  6969	  if (!confirm(`Paste "${proj.title}" into ${teacher} / ${className} Week ${weekNum}? The idea will be removed from the bank.`)) return;
  6970	
  6971	  const semKey = getAdminSemKey();
  6972	  const key = makeLessonKey(teacher, className, weekNum);
  6973	  const existingLesson = currentLessonData?.[semKey]?.[key] || {};
  6974	  const existingClassSize = existingLesson.classSize || 0;
  6975	  const existingPhotoPath = existingLesson.photoPath || null;
  6976	  const newLesson = {
  6977	    teacher,
  6978	    className,
  6979	    weekNum,
  6980	    weekDate: '',
  6981	    classSize: existingClassSize,
  6982	    projectTitle: proj.title,
  6983	    shortDetails: proj.description || '',
  6984	    inspoLink: proj.inspoLink || '',
  6985	    introPitch: '',
  6986	    processStep1: '',
  6987	    processStep2: '',
  6988	    processStep3: '',
  6989	    processStep4: '',
  6990	    closure: '',
  6991	    materials: '',
  6992	    dayOfMaterials: '',
  6993	    status: '',
  6994	    publishToPrep: '',
  6995	    teacherNotes: '',
  6996	    adminResponse: '',
  6997	    lastImported: new Date().toISOString()
  6998	  };
  6999	
  7000	  // An idea's blank fields must actually CLEAR stale destination content, not
  7001	  // silently leave it — same pattern used everywhere else in this plan.
  7002	  const fieldsToClear = CONTENT_FIELDS.filter(f =>
  7003	    (existingLesson[f] || '').trim() !== '' && !(newLesson[f] || '').trim()
  7004	  );
  7005	  // Instance-specific fields tied to whatever previously occupied this slot —
  7006	  // an Idea Bank project never supplies these, so newLesson never sets them,
  7007	  // and buildLessonFieldUpdates() only touches fields actually present in the
  7008	  // object it's given. Without an explicit clear, a destination's own stale
  7009	  // Q&A thread, photo, completion flag, or materials list would silently
  7010	  // resurrect under the newly-pasted idea.
  7011	  const NON_CONTENT_FIELDS_TO_CLEAR = ['qaThread', 'photoUrl', 'photoPath', 'planComplete', 'materialsList'];
  7012	
  7013	  try {
  7014	    await saveSingleLesson(semKey, key, newLesson, [...fieldsToClear, ...NON_CONTENT_FIELDS_TO_CLEAR]);
  7015	    if (currentLessonData[semKey]) currentLessonData[semKey][key] = newLesson;
  7016	  } catch (err) {
  7017	    console.error('❌ Paste from Idea Bank failed — lesson could not be saved:', err);
  7018	    alert(`Could not paste "${proj.title}" — please try again. The idea is still in the bank.`);
  7019	    return;
  7020	  }
  7021	
  7022	  // Only delete the destination's old photo from Storage after Firestore has
  7023	  // confirmed the clear — same safe ordering as pasteFromCutBank()/
  7024	  // saveAdminEdit()/saveTeacherEdit().
  7025	  if (existingPhotoPath) {
  7026	    try {
  7027	      await deleteLessonPhoto(existingPhotoPath);
  7028	    } catch (cleanupErr) {
  7029	      console.error('⚠️ Could not clean up destination\'s old photo after paste (Firestore is correct, Storage has an orphan):', cleanupErr);
  7030	    }
  7031	  }
  7032	
  7033	  // NOT closed here: this is still a plain saveFutureProjects() .set(), the
  7034	  // same shared last-write-wins primitive as the Idea Bank's other five
  7035	  // writers (classbook-shared-document-concurrency-plan.html, instance 1) —
  7036	  // a concurrent-paste-where-one-fails edge case can leave the local cache
  7037	  // disagreeing with a successful server-side removal until reload (no
  7038	  // server-side data loss). The real fix is converting removal to an atomic
  7039	  // FieldValue.arrayRemove() across all six writers together, tracked there;
  7040	  // out of scope for this single-function live-bug fix.
  7041	  try {
  7042	    // Re-resolve the idea's current position by identity rather than trusting
  7043	    // the idx captured above — a second paste invoked while this one was
  7044	    // still awaiting the lesson save could have already spliced the array,
  7045	    // shifting indices out from under this call.
  7046	    const currentIdx = projects.indexOf(proj);
  7047	    if (currentIdx === -1) throw new Error('Idea no longer in the bank — already removed by a concurrent paste.');
  7048	    projects.splice(currentIdx, 1);
  7049	    await saveFutureProjects(projects);
  7050	  } catch (err) {
  7160	function toggleHqFilter() {
  7161	  hqFilterNeedsReply = !hqFilterNeedsReply;
  7162	  renderHelpQueue();
  7163	}
  7164	
  7165	function getTimeAgo(timestamp) {
  7166	  const now = Date.now();
  7167	  const then = new Date(timestamp).getTime();
  7168	  const diff = now - then;
  7169	  const mins = Math.floor(diff / 60000);
  7170	  if (mins < 1) return 'just now';
  7171	  if (mins < 60) return `${mins}m ago`;
  7172	  const hours = Math.floor(mins / 60);
  7173	  if (hours < 24) return `${hours}h ago`;
  7174	  const days = Math.floor(hours / 24);
  7175	  if (days === 1) return 'yesterday';
  7176	  return `${days}d ago`;
  7177	}
  7178	
  7179	// Shared by sendHelpResponse() and sendQaReply() below — seeds arrayUnion's
  7180	// argument list with the legacy teacherNotes/adminResponse thread on a
  7181	// lesson's FIRST atomic-append reply, so that legacy content isn't silently
  7182	// lost the moment qaThread gets its first real entry. arrayUnion's deep-
  7183	// equality dedup makes repeating this migration from concurrent senders safe.
  7184	function buildQaThreadUnionArgs(existingLesson, newEntry) {
  7185	  const needsMigration = !existingLesson?.qaThread || existingLesson.qaThread.length === 0;
  7186	  return needsMigration ? [...getQaThread(existingLesson || {}), newEntry] : [newEntry];
  7187	}
  7188	
  7189	// Backtracking audit Phase 11 fix: both admin Q&A reply functions used to
  7190	// resave the ENTIRE cached semester via saveLessonData() — a Firestore
  7191	// set({merge:true}) of every lesson currently sitting in this admin's
  7192	// browser, not just the one being replied to. If a teacher's save landed on
  7193	// the server in the split-second before this admin's live listener caught
  7194	// up, that reply would silently revert the teacher's edit back to this
  7195	// admin's stale cached copy — for ANY lesson in the semester, not just the
  7196	// one in the reply. Now a single targeted Firestore .update() touching only
  7197	// this lesson's own field paths, with arrayUnion() for qaThread (survives a
  7198	// genuinely concurrent sender) and an existence check (a stale, long-open
  7199	// popup can't silently recreate a lesson deleted/moved elsewhere).
  7200	async function sendHelpResponse(key) {
  7201	  const input = document.getElementById(`ca-help-input-${key}`);
  7202	  if (!input) return;
  7203	  const response = input.value.trim();
  7204	  if (!response) return;
  7205	
  7206	  const semKey = getAdminSemKey();
  7207	  // Same load guard as every other lesson writer (Phase 1 review): after a
  7208	  // failed reload the listener deliberately KEEPS the previous summer maps, so
  7209	  // the cached lesson and the existence check both still pass — without this
  7210	  // an admin could write a reply while the banner says saving is disabled.
  7211	  if (lessonDataLoadedSuccessfully === false) {
  7212	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  7213	    return;
  7214	  }
  7215	  // A semester type this writer has no branch for is refused here, before the
  7216	  // existence check below — a throw inside that try would be reported to the
  7217	  // admin as "check your connection", which it isn't (Phase 1, 1.1).
  7218	  let lessonStore;
  7219	  try {
  7220	    lessonStore = lessonStoreFor(semKey);
  7221	  } catch (err) {
  7222	    alert(err.message);
  7223	    return;
  7224	  }
  7225	  const cachedExisting = currentLessonData?.[semKey]?.[key];
  7226	  if (!cachedExisting) return;
  7227	
  7228	  let check;
  7229	  try {
  7230	    check = await adminLessonStillExistsWithRetry(semKey, key);
  7231	  } catch (err) {
  7232	    console.warn('⚠️ Existence check retry also failed:', err);
  7233	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  7234	    return;
  7235	  }
  7236	  if (!check.exists) {
  7237	    alert('This lesson was moved or removed elsewhere. Your response was not sent — please close this and check the grid for its new location.');
  7238	    return;
  7239	  }
  7240	  const existing = check.data || cachedExisting;
  7241	
  7242	  const user = getAuthUser();
  7243	  const newEntry = {
  7244	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  7245	    from: 'admin', name: user?.name || 'Admin', message: response, timestamp: new Date().toISOString()
  7246	  };
  7247	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7248	
  7249	  if (!curriculumDb) initCurriculumFirestore();
  7250	  const isSummer = lessonStore === 'camp';
  7251	  const updates = {};
  7252	  let weekly = null;
  7253	  if (!isSummer) {
  7254	    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
  7255	  }
  7256	  if (isSummer) {
  7257	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7258	    updates.adminResponse = response;
  7259	    updates.status = 'In Progress';
  7260	    updates.lastUpdated = new Date().toISOString();
  7261	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7262	  } else {
  7263	    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7264	    updates[`${weekly.prefix}${key}.adminResponse`] = response;
  7265	    updates[`${weekly.prefix}${key}.status`] = 'In Progress';
  7266	    updates.lastUpdated = new Date().toISOString();
  7267	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7268	  }
  7269	  const docRef = isSummer
  7270	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7271	    : weekly.ref;
  7272	
  7273	  try {
  7274	    await docRef.update(updates);
  7275	  } catch (err) {
  7276	    console.error('Error sending help response:', err);
  7277	    alert('Error sending response: ' + err.message);
  7278	    return;
  7279	  }
  7280	
  7281	  currentLessonData[semKey][key] = {
  7282	    ...existing, adminResponse: response,
  7283	    qaThread: [...(existing.qaThread && existing.qaThread.length > 0 ? existing.qaThread : getQaThread(existing)), newEntry],
  7284	    status: 'In Progress'
  7285	  };
  7286	  renderHelpQueue();
  7287	}
  7288	
  7289	async function sendQaReply(key) {
  7290	  const input = document.getElementById(`qa-reply-${key}`);
  7291	  if (!input) return;
  7292	  const message = input.value.trim();
  7293	  if (!message) return;
  7294	
  7295	  const semKey = getAdminSemKey();
  7296	  // Same load guard as every other lesson writer (Phase 1 review): after a
  7297	  // failed reload the listener deliberately KEEPS the previous summer maps, so
  7298	  // the cached lesson and the existence check both still pass — without this
  7299	  // an admin could write a reply while the banner says saving is disabled.
  7300	  if (lessonDataLoadedSuccessfully === false) {
  7301	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  7302	    return;
  7303	  }
  7304	  // A semester type this writer has no branch for is refused here, before the
  7305	  // existence check below — a throw inside that try would be reported to the
  7306	  // admin as "check your connection", which it isn't (Phase 1, 1.1).
  7307	  let lessonStore;
  7308	  try {
  7309	    lessonStore = lessonStoreFor(semKey);
  7310	  } catch (err) {
  7311	    alert(err.message);
  7312	    return;
  7313	  }
  7314	  const cachedExisting = currentLessonData?.[semKey]?.[key];
  7315	  if (!cachedExisting) return;
  7316	
  7317	  let check;
  7318	  try {
  7319	    check = await adminLessonStillExistsWithRetry(semKey, key);
  7320	  } catch (err) {
  7321	    console.warn('⚠️ Existence check retry also failed:', err);
  7322	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  7323	    return;
  7324	  }
  7325	  if (!check.exists) {
  7326	    alert('This lesson was moved or removed elsewhere. Your reply was not sent — please close this window and check the grid for its new location.');
  7327	    return;
  7328	  }
  7329	  const existing = check.data || cachedExisting;
  7330	
  7331	  const user = getAuthUser();
  7332	  const newEntry = {
  7333	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  7334	    from: 'admin', name: user?.name || 'Admin', message, timestamp: new Date().toISOString()
  7335	  };
  7336	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7337	
  7338	  if (!curriculumDb) initCurriculumFirestore();
  7339	  const isSummer = lessonStore === 'camp';
  7340	  const updates = {};
  7341	  let weekly = null;
  7342	  if (!isSummer) {
  7343	    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
  7344	  }
  7345	  if (isSummer) {
  7346	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7347	    updates.adminResponse = message;
  7348	    updates.lastUpdated = new Date().toISOString();
  7349	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7350	  } else {
  7351	    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7352	    updates[`${weekly.prefix}${key}.adminResponse`] = message;
  7353	    updates.lastUpdated = new Date().toISOString();
  7354	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7355	  }
  7356	  const docRef = isSummer
  7357	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7358	    : weekly.ref;
  7359	
  7360	  try {
  7361	    await docRef.update(updates);
  7362	  } catch (err) {
  7363	    console.error('Error sending Q&A reply:', err);
  7364	    alert('Error sending reply: ' + err.message);
  7365	    return;
  7366	  }
  7367	
  7368	  const updatedLesson = {
  7369	    ...existing, adminResponse: message,
  7370	    qaThread: [...(existing.qaThread && existing.qaThread.length > 0 ? existing.qaThread : getQaThread(existing)), newEntry]
  7371	  };
  7372	  currentLessonData[semKey][key] = updatedLesson;
  7373	  openDetailModal(updatedLesson, key, updatedLesson.teacher, updatedLesson.className, updatedLesson.weekNum);
  7374	}
  7375	
  7376	function toggleHelpQueue() {
  7377	  const content = document.getElementById('ca-help-content');
  7378	  content.style.display = content.style.display === 'none' ? 'block' : 'none';
  7379	}
  7380	
  7381	// ─── Change History ──────────────────────────────────
  7382	
  7383	async function renderChangeHistory() {
  7384	  const semKey = getAdminSemKey();
  7385	  if (!currentChangeLog) await loadChangeLog();
  7386	  const entries = currentChangeLog?.[semKey] || [];
  7387	  const container = document.getElementById('ca-history-content');
  7388	  if (!container) return;
  7389	
  7390	  if (entries.length === 0) {
  7560	  if (wasHidden) renderBackupHealth();
  7561	}
  7562	
  7563	// ─── Content Count by Teacher (Data Safety Plan Stage 4A) ───────────
  7564	
  7565	// Same >10% drop threshold ~/tinker-backups/backup.js already uses for its
  7566	// own Tier-1 collection-level data-loss check — reused here for per-teacher
  7567	// consistency rather than inventing a second, unrelated threshold. A small
  7568	// routine edit (one lesson moved, one field trimmed) won't cross it; a real
  7569	// wipe of most of a teacher's content will.
  7570	const CONTENT_COUNT_DROP_THRESHOLD = 0.10;
  7571	
  7572	async function computeLiveContentCountByTeacher() {
  7573	  if (!curriculumDb) initCurriculumFirestore();
  7574	  const counts = {};
  7575	  const tally = (lesson) => {
  7576	    if (!lesson || !lesson.teacher || !lessonHasContent(lesson)) return;
  7577	    counts[lesson.teacher] = (counts[lesson.teacher] || 0) + 1;
  7578	  };
  7579	
  7580	  // Deliberately cross-season: this panel is the safety net that would notice
  7581	  // content vanishing from ANY season (per-season counting is Phase 4). But it
  7582	  // is still a summer read, so it obeys the same registry precondition as
  7583	  // every other one — no reads at all while the registry is unreadable.
  7584	  const registryMode = getSeasonRegistryMode();
  7585	  if (registryMode === 'error' || registryMode === 'unknown') {
  7586	    throw new Error(`Can't count summer content: the season registry is ${registryMode === 'unknown' ? 'unreachable' : 'unreadable'}.`);
  7587	  }
  7588	  const summerSnap = await curriculumDb.collection('summerCamps_lessonData').get();
  7589	  summerSnap.forEach(doc => tally(doc.data()));
  7590	
  7591	  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
  7592	  const lessonDataDoc = lessonDataSnap.exists ? lessonDataSnap.data() : {};
  7593	  // One source per semester (Spring 2026 storage move): an own-doc semester is
  7594	  // counted from its own document when that exists, and then skipped here.
  7595	  const countedFromOwnDoc = new Set();
  7596	  for (const semKey of OWN_DOC_SEMESTERS) {
  7597	    const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get();
  7598	    if (!own.exists) continue;
  7599	    countedFromOwnDoc.add(semKey);
  7600	    for (const lesson of Object.values(ownDocLessonMap(own.data()))) if (lesson && typeof lesson === 'object') tally(lesson);
  7601	  }
  7602	  for (const [semKey, semesterLessons] of Object.entries(lessonDataDoc)) {
  7603	    if (countedFromOwnDoc.has(semKey)) continue;
  7604	    if (!semesterLessons || typeof semesterLessons !== 'object') continue;
  7605	    for (const lesson of Object.values(semesterLessons)) tally(lesson);
  7606	  }
  7607	
  7608	  return counts;
  7609	}
  7610	
  7611	// Pure render — takes already-computed live and backup-derived per-teacher
  7612	// counts (backupCounts may be null if unavailable/inaccessible), so it's
  7613	// testable without a real Firestore read.
  7614	function renderContentCountData(liveCounts, backupCounts) {
  7615	  const container = document.getElementById('ca-content-count-content');
  7616	  if (!container) return;
  7617	
  7618	  const teachers = Array.from(new Set([
  7619	    ...Object.keys(liveCounts || {}),
  7620	    ...Object.keys(backupCounts || {}),
  7621	  ])).sort();
  7622	
  7623	  if (teachers.length === 0) {
  7624	    container.innerHTML = '<p class="ca-empty-hint">No lesson content recorded yet.</p>';
  7625	    return;
  7626	  }
  7627	
  7628	  let flaggedCount = 0;
  7629	  let rowsHtml = '';
  7630	  for (const teacher of teachers) {
  7631	    const today = liveCounts?.[teacher] || 0;
  7632	    const hasBaseline = !!backupCounts && typeof backupCounts[teacher] === 'number';
  7633	    const backupCount = hasBaseline ? backupCounts[teacher] : null;
  7634	    const isDrop = hasBaseline && backupCount > 0 &&
  7635	      ((backupCount - today) / backupCount) > CONTENT_COUNT_DROP_THRESHOLD;
  7636	    if (isDrop) flaggedCount++;
  7637	
  7638	    rowsHtml += `<tr>
  7639	      <td>${escHtml(teacher)}</td>
  7640	      <td>${today}</td>
  7641	      <td>${hasBaseline ? backupCount : '—'}</td>
  7642	      <td class="${isDrop ? 'ca-backup-flag' : ''}">${isDrop ? `⚠️ Dropped from ${backupCount} to ${today}` : 'OK'}</td>
  7643	    </tr>`;
  7644	  }
  7645	
  7646	  let html = '';
  7647	  if (!backupCounts) {
  7648	    html += '<p class="ca-empty-hint">No backup-derived comparison available yet.</p>';
  7649	  }
  7650	  if (flaggedCount > 0) {
  7651	    html += `<p class="ca-backup-flag">⚠️ ${flaggedCount} teacher${flaggedCount !== 1 ? 's' : ''} show a content-count drop of more than 10% since the last backup.</p>`;
  7652	  }
  7653	  html += `<div style="overflow-x:auto"><table class="ca-content-count-table">
  7654	    <thead><tr><th>Teacher</th><th>Today</th><th>Last Backup</th><th>Status</th></tr></thead>
  7655	    <tbody>${rowsHtml}</tbody>
  7656	  </table></div>`;
  7657	
  7658	  container.innerHTML = html;
  7659	}
  7660	
  7661	async function renderContentCount() {
  7662	  const container = document.getElementById('ca-content-count-content');
  7663	  if (!container) return;
  7664	  container.innerHTML = '<p class="ca-empty-hint">Loading content counts…</p>';
  7665	  try {
  7666	    const liveCounts = await computeLiveContentCountByTeacher();
  7667	    let backupCounts = null;
  7668	    try {
  7669	      if (!curriculumDb) initCurriculumFirestore();
  7670	      const snap = await curriculumDb.collection('backupStatus').doc('latest').get();
  7671	      backupCounts = snap.exists ? (snap.data().classbookContentByTeacher || null) : null;
  7672	    } catch (err) {
  7673	      // backupStatus is manager/admin-only (same boundary as Backup Health) —
  7674	      // degrade to "no comparison available" rather than blocking the live
  7675	      // counts, which this account can read regardless of that boundary.
  7676	      backupCounts = null;
  7677	    }
  7678	    renderContentCountData(liveCounts, backupCounts);
  7679	  } catch (err) {
  7680	    console.error('Error loading content counts:', err);
  7681	    container.innerHTML = '<p class="ca-backup-flag">⚠️ Failed to load content counts.</p>';
  7682	  }
  7683	}
  7684	
  7685	// Lesson storage headroom (Spring 2026 storage move, Phase B): curriculum/lessonData
  7686	// holds every weekly semester in one document under Firestore's 1 MiB cap. The
  7687	// size is an estimate from the last snapshot this page received — no extra read.
  7688	function renderLessonStorage() {
  7689	  const container = document.getElementById('ca-lesson-storage-content');
  7690	  if (!container) return;
  7691	  const kb = approxLessonDataSizeKB();
  7692	  if (kb === null) { container.innerHTML = '<p class="ca-empty-hint">Lesson storage size isn\'t available yet — reload the page.</p>'; return; }
  7693	  const pct = Math.round((kb / 1024) * 100);
  7694	  const warn = pct > 85;
  7695	  container.innerHTML = `<p class="${warn ? 'ca-backup-flag' : 'ca-empty-hint'}">${warn ? '⚠️ ' : ''}Lesson storage: approx. ${kb} KB of 1,024 KB (${pct}%)${warn ? ' — nearly full. When it fills, lesson saves stop working; tell Christie.' : ''}</p>`
  7696	    + `<p class="ca-empty-hint">All Fall/Spring semesters still stored in the shared document. ${OWN_DOC_SEMESTERS.map(k => `${escHtml(k)}: ${ownDocSource[k] === 'ownDoc' ? 'in its own document' : ownDocSource[k] === 'error' ? 'couldn\'t be checked' : 'still in the shared document'}`).join(' · ')}</p>`;
  7697	}
  7698	
  7699	function toggleLessonStorage() {
  7700	  const content = document.getElementById('ca-lesson-storage-content');
  7701	  const wasHidden = content.style.display === 'none';
  7702	  content.style.display = wasHidden ? 'block' : 'none';
  7703	  if (wasHidden) renderLessonStorage();
  7704	}
  7705	
  7706	function toggleContentCount() {
  7707	  const content = document.getElementById('ca-content-count-content');
  7708	  const wasHidden = content.style.display === 'none';
  7709	  content.style.display = wasHidden ? 'block' : 'none';
  7710	  if (wasHidden) renderContentCount();
  7711	}
  7712	
  7713	
  7714	// ═════════════════════════════════════════════════════
  7715	// PREP DASHBOARD — Initialization
  7716	// ═════════════════════════════════════════════════════
  7717	
  7718	function initPrepDashboard() {
  7719	  if (prepInitialized) return;
  7720	  prepInitialized = true;

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '3490,3790p;4560,4705p;4940,5120p;5600,5865p;5880,6120p;6200,6410p;6480,6570p;6960,7040p;7180,7380p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
  3490	}
  3491	
  3492	async function saveTeacherEdit(lessonKey, originalLesson) {
  3493	  const saveBtn = document.getElementById('te-save-btn');
  3494	  const autoSaveStatus = document.getElementById('te-autosave-status');
  3495	  const formData = getTeEditFormData();
  3496	  const changedFields = getTeChangedFields();
  3497	  const photoInput = document.getElementById('te-photo-input');
  3498	  const hasNewPhoto = photoInput?.files?.length > 0;
  3499	  const pendingRemove = photoInput?.dataset?.pendingRemove === 'true';
  3500	
  3501	  if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) {
  3502	    // Nothing to save — flash the button briefly
  3503	    if (saveBtn) { saveBtn.textContent = 'Saved!'; saveBtn.disabled = true; }
  3504	    setTimeout(() => { if (saveBtn) { saveBtn.textContent = 'Save'; saveBtn.disabled = false; } }, 1500);
  3505	    return;
  3506	  }
  3507	
  3508	  if (saveBtn) { saveBtn.disabled = true; saveBtn.textContent = 'Saving...'; }
  3509	  if (autoSaveStatus) autoSaveStatus.textContent = 'Saving...';
  3510	
  3511	  try {
  3512	    const semKey = getTvSemKey();
  3513	
  3514	    // Build updated lesson (preserve all original fields, override edited ones)
  3515	    const updatedLesson = { ...originalLesson, ...formData };
  3516	
  3517	    // Backtracking audit, Phase 8 (R4-2): capture the OLD photoPath before any
  3518	    // mutation, so the delete-after-save step below has the right value to
  3519	    // compare against.
  3520	    const oldPhotoPath = originalLesson.photoPath || null;
  3521	    const uploadedFile = hasNewPhoto ? photoInput.files[0] : null;
  3522	
  3523	    // Handle photo upload
  3524	    let photoUrl = null, photoPath = null;
  3525	    if (hasNewPhoto) {
  3526	      if (saveBtn) saveBtn.textContent = 'Uploading photo...';
  3527	      if (autoSaveStatus) autoSaveStatus.textContent = 'Uploading photo...';
  3528	      const result = await uploadLessonPhoto(semKey, lessonKey, photoInput.files[0]);
  3529	      // Backtracking audit, Phase 8 (R4-2): delete moved to AFTER the save
  3530	      // below — no longer here, immediately after upload.
  3531	      photoUrl = result.url;
  3532	      photoPath = result.path;
  3533	      updatedLesson.photoUrl = photoUrl;
  3534	      updatedLesson.photoPath = photoPath;
  3535	      if (!changedFields.includes('photo')) changedFields.push('photo');
  3536	      if (saveBtn) saveBtn.textContent = 'Saving...';
  3537	      if (autoSaveStatus) autoSaveStatus.textContent = 'Saving...';
  3538	    } else if (pendingRemove && originalLesson.photoUrl) {
  3539	      // Backtracking audit, Phase 8 (R4-2): delete moved to AFTER the save
  3540	      // below — no longer here.
  3541	      photoUrl = '';
  3542	      photoPath = '';
  3543	      updatedLesson.photoUrl = '';
  3544	      updatedLesson.photoPath = '';
  3545	      if (!changedFields.includes('photo')) changedFields.push('photo');
  3546	    }
  3547	
  3548	    // A content field that had text when the modal opened (or last saved) and
  3549	    // is now empty is an intentional clear — saveSingleLesson needs this list
  3550	    // explicitly to use FieldValue.delete() instead of silently omitting the
  3551	    // field, which would leave the old content in Firestore untouched
  3552	    // (Data Safety Plan Stage 3).
  3553	    const fieldsToClear = CONTENT_FIELDS.filter(f =>
  3554	      (teOriginalData?.[f] || '').trim() !== '' && !(formData[f] || '').trim()
  3555	    );
  3556	
  3557	    // Save using granular single-lesson write. This already includes
  3558	    // photoUrl/photoPath via updatedLesson (they're not in CONTENT_FIELDS, so
  3559	    // saveSingleLesson's per-field dotted-path write always writes them
  3560	    // through, even empty) — backtracking audit, Phase 8 (R3-8): the separate
  3561	    // photo-fields write that used to follow this call was vestigial, removed
  3562	    // entirely.
  3563	    // Backtracking audit Phase 10: the Q&A fields are written only by the
  3564	    // atomic arrayUnion() senders — this form never edits them, and writing
  3565	    // the cached array back whole would delete any message another client
  3566	    // appended since this cache copy was taken. They stay on updatedLesson
  3567	    // (the cache copy below) and are left out of the WRITE only.
  3568	    const writePayload = { ...updatedLesson };
  3569	    delete writePayload.qaThread;
  3570	    delete writePayload.teacherNotes;
  3571	    delete writePayload.adminResponse;
  3572	    await saveSingleLesson(semKey, lessonKey, writePayload, fieldsToClear);
  3573	    // saveSingleLesson() stamps lastEditedBy/At onto the object it is given.
  3574	    updatedLesson.lastEditedBy = writePayload.lastEditedBy;
  3575	    updatedLesson.lastEditedAt = writePayload.lastEditedAt;
  3576	
  3577	    // Backtracking audit, Phase 8 (R4-2): only delete the OLD photo once
  3578	    // Firestore has confirmed the new reference — and only if it's actually
  3579	    // different from the new one.
  3580	    if (oldPhotoPath && oldPhotoPath !== (updatedLesson.photoPath || null)) {
  3581	      try {
  3582	        await deleteLessonPhoto(oldPhotoPath);
  3583	      } catch (cleanupErr) {
  3584	        console.error('⚠️ Could not clean up old photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
  3585	      }
  3586	    }
  3587	
  3588	    // Backtracking audit, Phase 5: the photo change is persisted — clear the
  3589	    // pending selection so this modal's autosave doesn't re-upload the same
  3590	    // file to another unique path on the next pause in typing. Success path
  3591	    // only, so a failed save keeps the selection for the retry.
  3592	    if (hasNewPhoto && photoInput?.files?.[0] === uploadedFile) photoInput.value = '';
  3593	    if (pendingRemove && photoInput) photoInput.dataset.pendingRemove = '';
  3594	
  3595	    // Update local data immediately (don't wait for Firestore listener)
  3596	    if (currentLessonData[semKey]) {
  3597	      currentLessonData[semKey][lessonKey] = updatedLesson;
  3598	    }
  3599	
  3600	    // Backtracking audit, Phase 8 (R1-17/R2-11): log only after persistence is
  3601	    // confirmed, with its own non-blocking catch — a log-only failure here
  3602	    // must not be reported to the teacher as "Save failed" when the save
  3603	    // itself already succeeded. Before/after char counts per field so a
  3604	    // large-content wipe is flagged automatically (Data Safety Plan Stage 4C).
  3605	    // 'photo' isn't a text field — teOriginalData/formData have no counterpart
  3606	    // for it, so it carries no char counts and is never flagged as a wipe.
  3607	    try {
  3608	      const changedFieldEntries = changedFields.map(field => {
  3609	        if (field === 'photo') return { field, before: null, after: null, potentialWipe: false };
  3610	        const before = (teOriginalData[field] || '').length;
  3611	        const after = normalizeTeFormValue(field, formData).length;
  3612	        return { field, before, after, potentialWipe: after === 0 && before > 50 };
  3613	      });
  3614	      await logTeacherEdit(semKey, lessonKey, originalLesson, changedFieldEntries);
  3615	    } catch (logErr) {
  3616	      console.error('⚠️ Lesson saved, but Change History logging failed:', logErr);
  3617	    }
  3618	
  3619	    // Show success — stay open, reset dirty state
  3620	    if (saveBtn) { saveBtn.textContent = 'Saved!'; }
  3621	    if (autoSaveStatus) {
  3622	      autoSaveStatus.textContent = fieldsToClear.length > 0
  3623	        ? `✓ Saved (${fieldsToClear.join(', ')} cleared)`
  3624	        : '✓ Saved';
  3625	    }
  3626	
  3627	    // Reset dirty baseline so closing won't prompt "unsaved changes"
  3628	    const snapshot = getTeEditFormData();
  3629	    teOriginalData = {
  3630	      projectTitle: snapshot.projectTitle,
  3631	      shortDetails: snapshot.shortDetails,
  3632	      inspoLink: snapshot.inspoLink,
  3633	      introPitch: snapshot.introPitch,
  3634	      processStep1: snapshot.processStep1,
  3635	      processStep2: snapshot.processStep2,
  3636	      processStep3: snapshot.processStep3,
  3637	      processStep4: snapshot.processStep4,
  3638	      closure: snapshot.closure,
  3639	      materials: snapshot.materials,
  3640	      dayOfMaterials: snapshot.dayOfMaterials,
  3641	      materialsList: JSON.stringify(snapshot.materialsList || []),
  3642	      planComplete: snapshot.planComplete ? 'true' : 'false'
  3643	    };
  3644	
  3645	    setTimeout(() => {
  3646	      if (saveBtn) { saveBtn.textContent = 'Save'; saveBtn.disabled = false; }
  3647	      if (autoSaveStatus) autoSaveStatus.textContent = '';
  3648	    }, 1500);
  3649	  } catch (err) {
  3650	    console.error('Error saving lesson:', err);
  3651	    if (saveBtn) { saveBtn.disabled = false; saveBtn.textContent = 'Save'; }
  3652	    if (autoSaveStatus) { autoSaveStatus.textContent = '⚠️ Save failed'; autoSaveStatus.style.color = 'var(--error)'; }
  3653	  }
  3654	}
  3655	
  3656	// Backtracking audit Phase 10 (R3-3, R4-5): this used to rebuild the whole
  3657	// Q&A thread from the modal's lesson object and hand the ENTIRE lesson to
  3658	// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
  3659	// silently dropped any message (or any other field) another client had
  3660	// landed since this modal opened. Now a single targeted .update() touching
  3661	// only this lesson's own Q&A paths, with arrayUnion() for the thread — the
  3662	// same atomic-append design sendHelpResponse()/sendQaReply() already use —
  3663	// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
  3664	// record. `modalSemKey` is the semester the modal was opened under: the
  3665	// global selector can change while the modal stays open, and a dotted-path
  3666	// update under the wrong semester would create a Q&A-only ghost lesson there.
  3667	async function sendTeacherQaMessage(lessonKey, modalSemKey) {
  3668	  const input = document.getElementById('te-qa-input');
  3669	  if (!input) return;
  3670	  const message = input.value.trim();
  3671	  if (!message) return;
  3672	  // Same load-guard saveSingleLesson() enforced on the old path — after a
  3673	  // failed load the cache is empty, so the legacy-thread migration below
  3674	  // would run blind against whatever is really on the server.
  3675	  if (lessonDataLoadedSuccessfully === false) {
  3676	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  3677	    return;
  3678	  }
  3679	
  3680	  const semKey = modalSemKey || getTvSemKey();
  3681	  // This modal never hosts a camp season (the Today View routes those to the
  3682	  // summer editor, whose Q&A lives in summerCamps_prepHelpQueue), so a write
  3683	  // under that key into curriculum/lessonData is never right. Routed by TYPE
  3684	  // now (Phase 1, 1.1) — a third type is refused out loud rather than written
  3685	  // into the shared weekly document.
  3686	  let lessonStore;
  3687	  try {
  3688	    lessonStore = lessonStoreFor(semKey);
  3689	  } catch (err) {
  3690	    alert(err.message);
  3691	    return;
  3692	  }
  3693	  if (lessonStore === 'camp') {
  3694	    alert('Summer camp questions are sent from the camp lesson editor.');
  3695	    return;
  3696	  }
  3697	
  3698	  // Confirm the lesson still exists on the server (an admin may have moved or
  3699	  // deleted it since this modal opened). A dotted-path update would otherwise
  3700	  // recreate the old key as a Q&A-only ghost lesson. Same forced read and
  3701	  // accepted check-to-write residual as sendHelpResponse()/sendQaReply().
  3702	  let check;
  3703	  try {
  3704	    check = await adminLessonStillExistsWithRetry(semKey, lessonKey);
  3705	  } catch (err) {
  3706	    console.warn('⚠️ Existence check retry also failed:', err);
  3707	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  3708	    return;
  3709	  }
  3710	  if (!check.exists) {
  3711	    alert('This lesson was moved or removed elsewhere. Your message was not sent — please close this and check the classbook for its new location.');
  3712	    return;
  3713	  }
  3714	  const existing = check.data;
  3715	
  3716	  const user = getAuthUser();
  3717	  const isAdmin = ['admin', 'manager'].includes(user?.role);
  3718	  const newEntry = {
  3719	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  3720	    from: isAdmin ? 'admin' : 'teacher',
  3721	    name: user?.name || 'Unknown',
  3722	    message,
  3723	    timestamp: new Date().toISOString()
  3724	  };
  3725	  // The fresh server copy decides whether a legacy teacherNotes/adminResponse
  3726	  // thread still needs migrating into qaThread on this lesson's first entry.
  3727	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  3728	  const editedAt = new Date().toISOString();
  3729	  const editedBy = user?.name || 'Unknown';
  3730	
  3731	  let target;
  3732	  try {
  3733	    target = weeklyLessonTarget(semKey);   // own-doc semester: its own doc, or "editing is paused"
  3734	  } catch (err) {
  3735	    alert(err.message);
  3736	    return;
  3737	  }
  3738	  const p = `${target.prefix}${lessonKey}`;
  3739	  const updates = {
  3740	    [`${p}.qaThread`]: firebase.firestore.FieldValue.arrayUnion(...entriesToAdd),
  3741	    [`${p}.lastEditedBy`]: editedBy,
  3742	    [`${p}.lastEditedAt`]: editedAt,
  3743	  };
  3744	  // Legacy mirror fields, kept for compatibility with older readers.
  3745	  const legacyField = isAdmin ? 'adminResponse' : 'teacherNotes';
  3746	  updates[`${p}.${legacyField}`] = message;
  3747	
  3748	  try {
  3749	    await target.ref.update(updates);
  3750	  } catch (err) {
  3751	    console.error('Error sending Q&A message:', err);
  3752	    alert('Error sending message: ' + err.message);
  3753	    return;
  3754	  }
  3755	
  3756	  // Confirmed — make sure the local cache shows the new message before the
  3757	  // live listener catches up. Usually the listener already HAS: a local
  3758	  // write triggers a latency-compensated snapshot (with the arrayUnion
  3759	  // applied) before the server ack resolves the await above, so the entry
  3760	  // is deduplicated by id rather than appended blindly — a duplicate here
  3761	  // would be persisted by the next autosave, which writes the cached
  3762	  // qaThread back as a whole array.
  3763	  if (currentLessonData?.[semKey]?.[lessonKey]) {
  3764	    const cached = currentLessonData[semKey][lessonKey];
  3765	    const baseThread = cached.qaThread && cached.qaThread.length > 0 ? cached.qaThread : getQaThread(cached);
  3766	    const alreadyThere = baseThread.some(m => m.id === newEntry.id);
  3767	    currentLessonData[semKey][lessonKey] = {
  3768	      ...cached,
  3769	      qaThread: alreadyThere ? baseThread : [...baseThread, newEntry],
  3770	      [legacyField]: message,
  3771	      lastEditedBy: editedBy,
  3772	      lastEditedAt: editedAt,
  3773	    };
  3774	  }
  3775	  input.value = '';
  3776	  // Re-open the modal to show the updated thread — only if the Today View is
  3777	  // still on this modal's semester; otherwise it would open a different
  3778	  // semester's lesson under the same key.
  3779	  if (getTvSemKey() === semKey) openTeacherEditModal(lessonKey);
  3780	}
  3781	
  3782	// ─── Q&A Reply Notification Banner ───────────────
  3783	
  3784	// The read-mark carries the semester (Phase 1, 1.4): two camp seasons share
  3785	// lesson keys, so a bare key would mark 2027's reply read because the
  3786	// identically-keyed 2026 one was opened.
  3787	function qaReadMarkKey(lessonKey) { return `qaLastRead_${getTvSemKey()}_${lessonKey}`; }
  3788	// Marks written before Phase 1 had no semester in the key. Reading through
  3789	// this keeps them valid — otherwise every teacher would see unread badges at
  3790	// deploy for replies they had already read, in weekly semesters too.
  4560	  const copyFrom = document.getElementById('new-sem-copy-from');
  4561	  if (copyFrom) {
  4562	    let copyHtml = '<option value="">Start blank (no classes)</option>';
  4563	    for (const key of keys.filter(k => !isDayOffYear(k))) {
  4564	      copyHtml += `<option value="${escAttr(key)}">${escHtml(semesters[key].name)}</option>`;
  4565	    }
  4566	    copyFrom.innerHTML = copyHtml;
  4567	  }
  4568	
  4569	  // Publish toggle for current semester
  4570	  const sem = semesters[currentKey];
  4571	  if (sem) {
  4572	    const isPublished = sem.published !== false;
  4573	    const isActive = currentKey === currentConfig.activeSemester;
  4574	    publishGroup.innerHTML = `
  4575	      ${isActive ? '<span class="ca-sem-active-badge">Active Semester</span>' : ''}
  4576	      ${!isActive ? `<label class="ca-publish-toggle">
  4577	        <input type="checkbox" ${isPublished ? 'checked' : ''} onchange="toggleSemesterPublish(${escForOnclick(currentKey)}, this.checked)">
  4578	        Published (visible to teachers)
  4579	      </label>` : ''}
  4580	      ${!isPublished && !isActive ? '<span class="ca-sem-unpublished-badge">Draft</span>' : ''}
  4581	      ${!isActive ? `<button class="btn-text ca-delete-sem-btn" onclick="deleteSemester(${escForOnclick(currentKey)})" title="Delete this semester">&#128465; Delete</button>` : ''}
  4582	    `;
  4583	  }
  4584	}
  4585	
  4586	async function deleteSemester(key) {
  4587	  const sem = currentConfig?.semesters?.[key];
  4588	  if (!sem) return;
  4589	  // Spring 2026 storage move: deleting an own-doc semester is disabled until the
  4590	  // follow-up plan routes it (its lessons may live in their own document).
  4591	  if (isOwnDocSemester(key)) {
  4592	    alert(`"${sem.name}" can't be deleted while its storage is being changed.`);
  4593	    return;
  4594	  }
  4595	  if (key === currentConfig.activeSemester) {
  4596	    alert('Cannot delete the active semester.');
  4597	    return;
  4598	  }
  4599	  // Removing a CAMP season from the Classbook removes only this app's entry
  4600	  // for it. Its camps, schedule, plans and photos belong to the Summer Camp
  4601	  // App and stay exactly where they are — adding the season back from the
  4602	  // registry restores the whole view (Phase 1, 1.7). This supersedes the
  4603	  // companion plan's summer-delete design, which predates seasons.
  4604	  // An SDOC year: refused while any event exists (a forced-server count);
  4605	  // otherwise only its appData entry goes — it has nothing in
  4606	  // curriculum/lessonData, and no collection is ever cleared from here.
  4607	  if (isDayOffYear(key)) {
  4608	    let events;
  4609	    try { events = await countDayOffEvents(key); }
  4610	    catch (err) { alert(`Could not check "${sem.name}" for events: ${err.message}\n\nNothing was changed.`); return; }
  4611	    if (events > 0) { alert(`"${sem.name}" still has ${events} event${events === 1 ? '' : 's'}. Remove its events first.`); return; }
  4612	  }
  4613	  const isCamp = isCampSeason(key);
  4614	  const isDayOff = isDayOffYear(key);
  4615	  const firstConfirm = isDayOff
  4616	    ? `Delete the school year "${sem.name}"? It has no events, so only the year itself is removed.`
  4617	    : isCamp
  4618	    ? `Remove "${sem.name}" from the Classbook?\n\nThis only removes it here. Every camp, schedule, lesson plan and photo stays in the Summer Camp App, and you can add the season back at any time from + New Semester.`
  4619	    : `Delete semester "${sem.name}"? This will remove all its lesson data, cut bank, and change history. This cannot be undone.`;
  4620	  if (!confirm(firstConfirm)) return;
  4621	  if (!isCamp && !isDayOff && !confirm(`Are you sure? Type OK in your head and click OK to confirm.`)) return;
  4622	
  4623	  // Remove the semester's own entry and nothing else (Phase 1, 1.2). Revert
  4624	  // this tab if the write is refused, or the config would be missing a
  4625	  // semester the server still has — with no alert and no re-render to show it
  4626	  // (Phase 1 review).
  4627	  const removed = currentConfig.semesters[key];
  4628	  delete currentConfig.semesters[key];
  4629	  try {
  4630	    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
  4631	  } catch (err) {
  4632	    currentConfig.semesters[key] = removed;
  4633	    console.error('❌ Could not remove the semester:', err);
  4634	    alert(`Could not remove "${sem.name}": ${err.message}\n\nNothing was changed.`);
  4635	    renderSemesterSelector();
  4636	    return;
  4637	  }
  4638	
  4639	  // Drop this season's in-memory map either way…
  4640	  if (currentLessonData?.[key]) {
  4641	    delete currentLessonData[key];
  4642	  }
  4643	  // …but only a WEEKLY semester has lessons of its own inside
  4644	  // curriculum/lessonData to delete. A camp season's lessons live in the
  4645	  // shared summerCamps_* collections and are never touched from here.
  4646	  if (isDayOff) {
  4647	    delete currentDayOffEvents[key]; delete currentDayOffCamps[key]; delete currentDayOffPlans[key]; delete currentDayOffSignoffs[key];
  4648	  } else if (!isCamp) {
  4649	    try {
  4650	      await deleteLessonData(key);
  4651	    } catch (e) { console.warn('Could not delete lesson data for', key, e); }
  4652	  }
  4653	
  4654	  // Switch to active semester
  4655	  caCurrentSemester = currentConfig.activeSemester;
  4656	  renderSemesterSelector();
  4657	  renderAdminGrid();
  4658	  renderHelpQueue();
  4659	  renderCutBank();
  4660	  renderIdeaBank();
  4661	  renderChangeHistory();
  4662	}
  4663	
  4664	function switchAdminSemester(key) {
  4665	  // Delegates to global semester — CA always stays in sync with the header selector
  4666	  setGlobalSemester(key);
  4667	}
  4668	
  4669	async function toggleSemesterPublish(key, published) {
  4670	  if (!currentConfig?.semesters?.[key]) return;
  4671	  if (!isPublishableType(key)) { alert('This semester type can\'t be published.'); return; }
  4672	  // SDOC (Phase 2B): publishing shows the year to every teacher on a camp —
  4673	  // say so first if some camps have nobody to see them.
  4674	  if (published && isDayOffYear(key)) {
  4675	    // The camp list below must be real to warn from — never publish on a failed load.
  4676	    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
  4677	    const bare = (currentDayOffCamps[key] || []).filter(c => !(c.teachers || []).length).length;
  4678	    if (bare && !confirm(`${bare} camp${bare === 1 ? ' has' : 's have'} no teacher yet — publish anyway?`)) { renderSemesterSelector(); return; }
  4679	  }
  4680	  const hadPublished = 'published' in currentConfig.semesters[key];
  4681	  const previous = currentConfig.semesters[key].published;
  4682	  currentConfig.semesters[key].published = published;
  4683	  try {
  4684	    await updateAppData({ [`semesters.${key}.published`]: published });
  4685	  } catch (err) {
  4686	    // Restore exactly what was there — including "the field was absent".
  4687	    if (currentConfig.semesters[key]) {
  4688	      if (hadPublished) currentConfig.semesters[key].published = previous;
  4689	      else delete currentConfig.semesters[key].published;
  4690	    }
  4691	    console.error('❌ Could not change the publish state:', err);
  4692	    alert(`Could not ${published ? 'publish' : 'unpublish'} that semester: ${err.message}\n\nNothing was changed.`);
  4693	  }
  4694	  renderSemesterSelector();
  4695	}
  4696	
  4697	// Which types may be published to teachers. SDOC years joined in Phase 2B,
  4698	// when teachers got their day-off plans to build.
  4699	const PUBLISHABLE_SEMESTER_TYPES = new Set([SEMESTER_TYPES.weekly, SEMESTER_TYPES.camp, SEMESTER_TYPES.dayOff]);
  4700	function isPublishableType(semKey) { return PUBLISHABLE_SEMESTER_TYPES.has(semesterTypeOf(semKey)); }
  4701	
  4702	function openNewSemesterModal() {
  4703	  document.getElementById('ca-new-semester-modal')?.classList.add('open');
  4704	  // Reset to the default type each time, then load the seasons on offer.
  4705	  const weeklyRadio = document.querySelector('input[name="new-sem-type"][value="weekly"]');
  4940	  const copyFromKey = document.getElementById('new-sem-copy-from')?.value || '';
  4941	
  4942	  const newSem = {
  4943	    name,
  4944	    semesterType: SEMESTER_TYPES.weekly,   // stored explicitly from now on (Phase 1, 1.1)
  4945	    startDate,
  4946	    numWeeks,
  4947	    breakWeeks,
  4948	    closureDates,
  4949	    published: false,
  4950	    classRoster: {}
  4951	  };
  4952	
  4953	  // Invoked from a bare HTML onclick — nothing above this frame catches, so a
  4954	  // failure anywhere below must be handled here (backtracking audit, Phase 11).
  4955	  // Two Firestore writes happen in sequence (lesson slots, then config); if the
  4956	  // second fails after the first landed, the slots are an orphan on the server
  4957	  // for a semester the admin was told didn't get created, and a retry with the
  4958	  // same name would silently reuse them. Track whether the first write landed
  4959	  // so the catch can compensate.
  4960	  let lessonDataCommitted = false;
  4961	  creatingSemester = true;
  4962	  try {
  4963	    // Copy roster from existing semester if selected
  4964	    if (copyFromKey && currentConfig.semesters[copyFromKey]) {
  4965	      // Pre-check (implementation review, Sep 2026): this branch is the only
  4966	      // path that writes lesson data, and the compensating delete in the catch
  4967	      // below removes the WHOLE `key` map — only safe if nothing lived there
  4968	      // before this call. It can: deleteSemester() drops a key from local
  4969	      // state even when its server-side deleteLessonData() fails (warn-only),
  4970	      // and config has no live listener, so another admin's same-named
  4971	      // semester isn't visible here either. Forced server read — the local
  4972	      // cache is exactly what can't be trusted for this key. Refuse unless
  4973	      // every existing lesson is template-empty (a prior createNewSemester()'s
  4974	      // own leftovers are safe to build on and safe to delete; anything else
  4975	      // would be merged over silently by the slot write, then deleted on
  4976	      // failure). The no-copy path is deliberately NOT gated: it writes no
  4977	      // lesson data, and re-creating a deleted semester there adopts its
  4978	      // surviving lesson data — the remedy this alert points at.
  4979	      const existingLessonMap = await readServerSemesterLessonMap(key);
  4980	      if (existingLessonMap && Object.values(existingLessonMap).some(l => !isTemplateEmptyLesson(l))) {
  4981	        alert(`Lesson content already exists in Firestore under the key "${key}".\n\nIf it was left over from a deleted semester, create this semester again without "Copy from" to adopt that data.\n\nIf another admin may have just created it, reload this page first.\n\nOtherwise choose a different name.`);
  4982	        return;
  4983	      }
  4984	
  4985	      const source = currentConfig.semesters[copyFromKey];
  4986	      newSem.classRoster = JSON.parse(JSON.stringify(source.classRoster || {}));
  4987	      // Without this, classRoster's teacher fields are copied but the dropdown
  4988	      // that lets Settings display/edit them has no options — the roster looks
  4989	      // wiped even though the underlying data isn't, and saving Settings in
  4990	      // that state silently writes blank teachers over the real ones.
  4991	      newSem.teacherNames = JSON.parse(JSON.stringify(source.teacherNames || []));
  4992	
  4993	      // Create empty lesson slots from source semester's teacher/class combos
  4994	      const sourceLessons = currentLessonData?.[copyFromKey] || {};
  4995	      const combos = new Set();
  4996	      for (const lesson of Object.values(sourceLessons)) {
  4997	        combos.add(`${lesson.teacher}|||${lesson.className}`);
  4998	      }
  4999	
  5000	      const emptyLessons = {};
  5001	      for (const combo of combos) {
  5002	        const [teacher, className] = combo.split('|||');
  5003	        for (let w = 1; w <= numWeeks; w++) {
  5004	          const lessonKey = makeLessonKey(teacher, className, w);
  5005	          emptyLessons[lessonKey] = {
  5006	            teacher,
  5007	            className,
  5008	            weekNum: w,
  5009	            weekDate: '',
  5010	            classSize: 0,
  5011	            projectTitle: '',
  5012	            shortDetails: '',
  5013	            inspoLink: '',
  5014	            introPitch: '',
  5015	            processStep1: '',
  5016	            processStep2: '',
  5017	            processStep3: '',
  5018	            processStep4: '',
  5019	            closure: '',
  5020	            materials: '',
  5021	            dayOfMaterials: '',
  5022	            materialsList: [],
  5023	            status: '',
  5024	            publishToPrep: ''
  5025	          };
  5026	        }
  5027	      }
  5028	
  5029	      if (Object.keys(emptyLessons).length > 0) {
  5030	        await saveLessonData(key, emptyLessons);
  5031	        if (!currentLessonData) currentLessonData = {};
  5032	        currentLessonData[key] = emptyLessons;
  5033	        lessonDataCommitted = true;
  5034	      }
  5035	    }
  5036	
  5037	    // Confirm on the SERVER that the key is free — the check at the top of this
  5038	    // function only saw this tab's copy of the config (Phase 1, 1.2). The
  5039	    // remaining read-to-update window is accepted: one admin, same class as the
  5040	    // existing residual on the Q&A path.
  5041	    const serverConfig = await readAppDataFromServer();
  5042	    if (serverConfig?.semesters?.[key]) {
  5043	      throw new Error(`A semester with the key "${key}" already exists (created in another tab or by another admin). Choose a different name.`);
  5044	    }
  5045	    currentConfig.semesters[key] = newSem;
  5046	    await updateAppData({ [`semesters.${key}`]: newSem });
  5047	  } catch (err) {
  5048	    console.error('❌ Could not create new semester:', err);
  5049	    // Revert both local mutations so a retry isn't blocked by a phantom
  5050	    // "already exists" and the grid doesn't render a semester that never saved.
  5051	    delete currentConfig.semesters[key];
  5052	    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
  5053	    // R4-11: the empty lesson slots may already be persisted even though the
  5054	    // config never was — clean up the orphaned server-side write, not just the
  5055	    // local copy. Safe: this data is template-empty by construction (never had
  5056	    // real content), so deleting it loses nothing.
  5057	    if (lessonDataCommitted) {
  5058	      try {
  5059	        await deleteLessonData(key);
  5060	      } catch (cleanupErr) {
  5061	        console.error('⚠️ Could not clean up orphaned lesson data after failed semester creation:', cleanupErr);
  5062	      }
  5063	    }
  5064	    alert('Could not create the new semester. Please try again.');
  5065	    return;
  5066	  } finally {
  5067	    creatingSemester = false;
  5068	  }
  5069	
  5070	  closeNewSemesterModal();
  5071	  caCurrentSemester = key;
  5072	  renderSemesterSelector();
  5073	  renderAdminGrid();
  5074	  renderHelpQueue();
  5075	  renderCutBank();
  5076	  renderIdeaBank();
  5077	  renderChangeHistory();
  5078	}
  5079	
  5080	async function initCurriculumAdmin() {
  5081	  if (caInitialized) return;
  5082	  caInitialized = true;
  5083	
  5084	  if (!currentLessonData) await loadLessonData();
  5085	  if (!currentChangeLog) await loadChangeLog();
  5086	  if (!currentCutProjects) await loadCutProjects();
  5087	  if (!currentFutureProjects) await loadFutureProjects();
  5088	
  5089	  renderSemesterSelector();
  5090	  renderAdminGrid();
  5091	  renderHelpQueue();
  5092	  renderCutBank();
  5093	  renderIdeaBank();
  5094	  renderChangeHistory();
  5095	
  5096	  // Modal close
  5097	  document.getElementById('ca-modal-close')?.addEventListener('click', closeAdminModal);
  5098	  document.getElementById('ca-detail-modal')?.addEventListener('click', (e) => {
  5099	    if (e.target === document.getElementById('ca-detail-modal')) closeAdminModal();
  5100	  });
  5101	
  5102	  // Real-time updates
  5103	  setupLessonDataListener((data) => {
  5104	    currentLessonData = data;
  5105	    renderAdminGrid();
  5106	    renderHelpQueue();
  5107	    // Refresh teacher mapping table in Settings if it exists
  5108	    renderTeacherMappingTable();
  5109	  });
  5110	}
  5111	
  5112	function renderAdminGrid() {
  5113	  const wrapper = document.getElementById('ca-grid-wrapper');
  5114	  const semKey = getAdminSemKey();
  5115	  const lessons = currentLessonData?.[semKey];
  5116	
  5117	  // School Day Off Camps years: the event/camp planning list (Phase 1).
  5118	  if (isDayOffYear(semKey)) {
  5119	    document.querySelector('.ca-grid-hint')?.style.setProperty('display', 'none');
  5120	    renderDayOffAdmin(semKey);
  5600	  body.innerHTML = html;
  5601	  modal.classList.add('open');
  5602	  // First editable field — on a summer lesson the title is read-only.
  5603	  document.querySelector('#ca-edit-form input:not([readonly]), #ca-edit-form textarea:not([readonly])')?.focus();
  5604	}
  5605	
  5606	// Data Safety Plan Phase 9 (+ backtracking audit Phase 1): the admin edit
  5607	// popup's save. What goes to Firestore is ONLY what this popup changed — the
  5608	// diff of the form against the open-time snapshot, plus the photo fields if
  5609	// this save touched them, plus identity/scheduling fields (teacher, className,
  5610	// weekNum, weekDate, classSize — no input in this form; resent from the cache
  5611	// exactly as before, an inherited exposure named in the plan, not a Phase 9
  5612	// change). The cached `existing` lesson is never spread into the payload, so
  5613	// a stale qaThread / photo / untouched content field can't overwrite another
  5614	// client's newer copy. Intentional clears travel as fieldsToClear. Before
  5615	// anything is written, a forced-server read confirms the lesson still exists
  5616	// (moved/deleted elsewhere while the popup was open → refuse, don't recreate
  5617	// a ghost). Residual check-to-write TOCTOU gap accepted per the plan.
  5618	async function saveAdminEdit(key, teacher, className, weekNum) {
  5619	  if (caEditSaveInFlight) return;
  5620	  const title = document.getElementById('ca-edit-title')?.value.trim();
  5621	  // (closeAdminModal() refuses non-forced closes while caEditSaveInFlight is
  5622	  // set — Cancel / × / overlay are effectively disabled for the duration.)
  5623	  if (!title) { alert('Project title is required.'); return; }
  5624	
  5625	  // Backtracking audit, Phase 1: check the guard BEFORE any Storage mutation
  5626	  // (and, now, before the existence check) so a known-bad load state never
  5627	  // gets as far as a server read, an upload, or a delete.
  5628	  if (lessonDataLoadedSuccessfully === false) {
  5629	    alert('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  5630	    return;
  5631	  }
  5632	
  5633	  caEditSaveInFlight = true;
  5634	  // Every action button in the modal body — the form's own Save/Print/Cancel
  5635	  // AND the empty-cell popup's two Paste buttons, which openDetailModal()
  5636	  // renders outside #ca-edit-form (round-3 review: they could replace the
  5637	  // modal body mid-save and race a second write onto the same slot).
  5638	  const btns = Array.from(document.querySelectorAll('#ca-modal-body .ca-actions button'));
  5639	  const saveBtn = btns.find(b => /^save/i.test(b.textContent.trim()));
  5640	  btns.forEach(b => { b.disabled = true; });
  5641	  if (saveBtn) saveBtn.textContent = 'Saving...';
  5642	  try {
  5643	    await saveAdminEditInner(key, teacher, className, weekNum, title);
  5644	  } finally {
  5645	    caEditSaveInFlight = false;
  5646	    btns.forEach(b => { b.disabled = false; });
  5647	    if (saveBtn) saveBtn.textContent = 'Save';
  5648	  }
  5649	}
  5650	
  5651	async function saveAdminEditInner(key, teacher, className, weekNum, title) {
  5652	  const semKey = getAdminSemKey();
  5653	
  5654	  const lessons = { ...(currentLessonData?.[semKey] || {}) };
  5655	  let existing = lessons[key] || {};   // rebased on the fresh server copy after the existence check (non-summer)
  5656	
  5657	  // Step 1 — diff the form against the open-time snapshot (pure DOM reads, no
  5658	  // side effects — so a no-op save can bail out below without paying for the
  5659	  // existence check's server read).
  5660	  const raw = {
  5661	    projectTitle: title,
  5662	    shortDetails: document.getElementById('ca-edit-details')?.value.trim() || '',
  5663	    inspoLink: document.getElementById('ca-edit-inspo')?.value.trim() || '',
  5664	    introPitch: document.getElementById('ca-edit-intro')?.value.trim() || '',
  5665	    processStep1: document.getElementById('ca-edit-step1')?.value.trim() || '',
  5666	    processStep2: document.getElementById('ca-edit-step2')?.value.trim() || '',
  5667	    processStep3: document.getElementById('ca-edit-step3')?.value.trim() || '',
  5668	    processStep4: document.getElementById('ca-edit-step4')?.value.trim() || '',
  5669	    closure: document.getElementById('ca-edit-closure')?.value.trim() || '',
  5670	    materials: document.getElementById('ca-edit-materials')?.value.trim() || '',
  5671	    dayOfMaterials: document.getElementById('ca-edit-dayof')?.value.trim() || '',
  5672	  };
  5673	  // No snapshot (shouldn't happen — both render paths capture one) degrades to
  5674	  // "everything non-empty is changed": today's behavior, never a lost edit.
  5675	  const baseline = caEditOriginalData || {};
  5676	  const changedFields = Object.keys(raw).filter(f => raw[f] !== (baseline[f] || ''));
  5677	  // Had text when the popup opened, empty now — an intentional clear, which
  5678	  // saveSingleLesson must apply with FieldValue.delete() rather than let the
  5679	  // stripping pass silently drop (Data Safety Plan Stage 3, never extended to
  5680	  // this third editor until now).
  5681	  const fieldsToClear = changedFields.filter(f => (baseline[f] || '') !== '' && raw[f] === '');
  5682	  const changedData = {};
  5683	  changedFields.forEach(f => { changedData[f] = raw[f]; });
  5684	
  5685	  const photoInput = document.getElementById('ca-edit-photo-input');
  5686	  const hasNewPhoto = photoInput?.files?.length > 0;
  5687	  let pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
  5688	  // Nothing changed — no write, no re-stamped lastEditedBy/At, no "edit" log
  5689	  // entry for an edit that didn't happen (mirrors saveTeacherEdit()).
  5690	  if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) {
  5691	    closeAdminModal(true);
  5692	    return;
  5693	  }
  5694	
  5695	  // Step 2 — forced-server read of this slot, before any side effect (the
  5696	  // photo upload, the write). Non-summer only: a summer cache entry is a
  5697	  // scaffold regenerated from summerCamps_curriculum whether or not its
  5698	  // summerCamps_lessonData doc exists (a missing doc means "never saved",
  5699	  // not "moved") and this app has no move/swap/cut path for summer lessons,
  5700	  // so there is no ghost to prevent — the first save legitimately creates
  5701	  // the doc. Same routing signal as saveSingleLesson() /
  5702	  // adminLessonStillExistsWithRetry() (key prefix; the camp-seasons plan
  5703	  // unifies this on semesterType). Forced read — a cache-permitting get()
  5704	  // could be served from the live listener's local cache in exactly the race
  5705	  // window this check exists to close. It runs for first-time creation too:
  5706	  // an "empty" slot in this tab's cache may have gained a project (a paste, a
  5707	  // move onto it) that the listener hasn't delivered yet.
  5708	  const isSummerSchema = isCampSeason(semKey);   // Phase 1, 1.1
  5709	  if (!isSummerSchema) {
  5710	    let check;
  5711	    try {
  5712	      check = await adminLessonStillExistsWithRetry(semKey, key);
  5713	    } catch (err) {
  5714	      console.warn('⚠️ Existence check retry also failed:', err);
  5715	      alert("Couldn't confirm this lesson still exists — check your connection and try saving again.");
  5716	      return;
  5717	    }
  5718	    if (caEditLessonExisted && !check.exists) {
  5719	      alert('This lesson was moved or removed elsewhere while you had it open. Your changes were not saved — please close this window and check the grid for its new location.');
  5720	      return;
  5721	    }
  5722	    if (check.exists) {
  5723	      // The key holds a doc — but a swap, a move ONTO this slot, or a paste
  5724	      // into a slot this tab still shows as empty leaves it populated with a
  5725	      // DIFFERENT project. The popup's edits were made against the project it
  5726	      // opened on; applying them to whatever is here now needs an explicit
  5727	      // decision, the same way cutProject() re-confirms when the fresh read
  5728	      // shows the slot's identity changed.
  5729	      const freshTitle = (check.data?.projectTitle || '').trim();
  5730	      if (freshTitle !== (baseline.projectTitle || '')) {
  5731	        const opened = baseline.projectTitle || '(empty slot)';
  5732	        if (!confirm(`This slot has changed since you opened it — it now contains "${freshTitle || '(empty)'}" instead of "${opened}". Save your changes onto "${freshTitle || 'this slot'}" anyway?\n\nCancel keeps your text here and saves nothing.`)) return;
  5733	      }
  5734	      // From here on, work from the FRESH copy, not this tab's cache: the
  5735	      // photo to delete after a replacement, the "remove photo" target, the
  5736	      // identity/scheduling fields resent below, the local cache merge and
  5737	      // the logged title all come from `existing`. On the swap-accept path
  5738	      // the cached copy's photoPath is the OTHER lesson's live photo.
  5739	      existing = check.data;
  5740	      pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
  5741	    }
  5742	  } else if (!existing.campName) {
  5743	    // A summer key that is no longer in the cache (the schedule was rebuilt
  5744	    // between open and save — e.g. the project was renamed in the Summer
  5745	    // Camp App) would produce a doc without its identity trio, which neither
  5746	    // app can find again. Refuse rather than write it.
  5747	    alert('This lesson is no longer in the summer schedule — reload and try again. Nothing was saved.');
  5748	    return;
  5749	  }
  5750	
  5751	  // Summer: projectTitle, shortDetails, inspoLink and materials belong to the
  5752	  // camp curriculum, not to the lesson doc — loadSummerCampData() takes them
  5753	  // from the scaffold and reads back only content/photo/completion fields
  5754	  // (SUMMER_SAVED_FIELDS), so an edit here would "save" and then vanish on the
  5755	  // next reload. projectTitle is worse: it is part of the lesson key, and the
  5756	  // Summer Camp App's orphan check treats a doc whose title isn't in the
  5757	  // camp's curriculum as orphaned content. Refuse them honestly rather than
  5758	  // write them into a doc where they can only mislead.
  5759	  const SUMMER_CURRICULUM_OWNED = ['projectTitle', 'shortDetails', 'inspoLink', 'materials'];
  5760	  if (isSummerSchema) {
  5761	    const refused = SUMMER_CURRICULUM_OWNED.filter(f => f in changedData);
  5762	    if (refused.length > 0) {
  5763	      const labels = { projectTitle: 'project title', shortDetails: 'short details', inspoLink: 'inspo link', materials: 'materials' };
  5764	      alert(`Summer camp ${refused.map(f => labels[f]).join(', ')} are managed in the Summer Camp App — that change is not saved here.` + (changedFields.length > refused.length || hasNewPhoto || pendingRemove ? ' Your other edits will still be saved.' : ''));
  5765	      refused.forEach(f => {
  5766	        delete changedData[f];
  5767	        const idx = changedFields.indexOf(f);
  5768	        if (idx !== -1) changedFields.splice(idx, 1);
  5769	        const cidx = fieldsToClear.indexOf(f);
  5770	        if (cidx !== -1) fieldsToClear.splice(cidx, 1);
  5771	      });
  5772	      if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) { closeAdminModal(true); return; }
  5773	    }
  5774	  }
  5775	
  5776	  // Firestore-bound payload — see the function comment for what's in it and why.
  5777	  const firestorePayload = {
  5778	    teacher, className, weekNum,
  5779	    weekDate: existing.weekDate || '',
  5780	    classSize: existing.classSize || 0,
  5781	    // Summer identity trio, key-derived and idempotent — a doc this save
  5782	    // CREATES must carry them (the Summer Camp App queries this collection by
  5783	    // campName + teacher and checks projectTitle; the summer editor sends the
  5784	    // same trio on every save for the same reason).
  5785	    ...(isSummerSchema ? { campName: existing.campName, block: existing.block, projectTitle: existing.projectTitle } : {}),
  5786	    ...changedData,
  5787	    lastImported: new Date().toISOString()
  5788	  };
  5789	
  5790	  // Backtracking audit, Phase 1 (R4-2): capture the OLD photoPath before any
  5791	  // mutation, so the delete-after-save step compares against the right value.
  5792	  const oldPhotoPath = existing.photoPath || null;
  5793	  let photoUrl = null, photoPath = null;   // null = this save didn't touch the photo
  5794	
  5795	  try {
  5796	    // Handle photo upload/removal
  5797	    if (hasNewPhoto) {
  5798	      const file = photoInput.files[0];
  5799	      if (file.size > 5 * 1024 * 1024) { alert('Photo must be under 5MB.'); return; }
  5800	      const { url, path } = await uploadLessonPhoto(semKey, key, file);
  5801	      // Delete of the OLD photo happens AFTER the save below — not here.
  5802	      photoUrl = url;
  5803	      photoPath = path;
  5804	    } else if (pendingRemove) {
  5805	      photoUrl = '';
  5806	      photoPath = '';
  5807	    }
  5808	    if (photoUrl !== null) {
  5809	      firestorePayload.photoUrl = photoUrl;
  5810	      firestorePayload.photoPath = photoPath;
  5811	    }
  5812	
  5813	    // Targeted single-lesson save with a diff-only payload — never the cached
  5814	    // full lesson, never the whole semester. (The summer branch's "no content"
  5815	    // guard can't refuse a legitimate save from here: for summer every
  5816	    // editable non-content field is curriculum-owned and refused above, so
  5817	    // what remains is content, a clear, or a photo — each admitted.)
  5818	    await saveSingleLesson(semKey, key, firestorePayload, fieldsToClear);
  5819	
  5820	    // Backtracking audit, Phase 1 (R4-2): only delete the OLD object once
  5821	    // Firestore has confirmed the new reference — and only when THIS save
  5822	    // actually replaced or removed the photo (photoUrl !== null). A text-only
  5823	    // edit leaves the old path untouched in both Firestore and Storage.
  5824	    if (photoUrl !== null && oldPhotoPath && oldPhotoPath !== (photoPath || null)) {
  5825	      try {
  5826	        await deleteLessonPhoto(oldPhotoPath);
  5827	      } catch (cleanupErr) {
  5828	        console.error('⚠️ Could not clean up old photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
  5829	      }
  5830	    }
  5831	  } catch (err) {
  5832	    // Backtracking audit, Phase 1 (R2-22): MUST return here — otherwise
  5833	    // execution falls through to commit currentLessonData, close the modal,
  5834	    // and log a fake edit even though the save never actually succeeded. The
  5835	    // snapshot is kept so the still-open popup can retry against it.
  5836	    console.error('❌ Admin edit failed to save:', err);
  5837	    alert('This edit could not be saved. Please try again.');
  5838	    return;
  5839	  }
  5840	
  5841	  // Local display/cache only — never sent to Firestore, so keeping the full
  5842	  // merge here is safe (staleness in untouched fields is cosmetic until the
  5843	  // listener's next delivery, same as the teacher editor).
  5844	  lessons[key] = {
  5845	    ...existing,
  5846	    teacher, className, weekNum,
  5847	    weekDate: firestorePayload.weekDate,
  5848	    classSize: firestorePayload.classSize,
  5849	    ...changedData,
  5850	    lastImported: firestorePayload.lastImported,
  5851	    lastEditedBy: firestorePayload.lastEditedBy,   // stamped by saveSingleLesson()
  5852	    lastEditedAt: firestorePayload.lastEditedAt
  5853	  };
  5854	  if (photoUrl !== null) { lessons[key].photoUrl = photoUrl; lessons[key].photoPath = photoPath; }
  5855	  fieldsToClear.forEach(f => { lessons[key][f] = ''; });
  5856	  currentLessonData[semKey] = lessons;
  5857	
  5858	  closeAdminModal(true);   // the save's own close — also resets the snapshot
  5859	  renderAdminGrid();
  5860	  renderChangeHistory();
  5861	
  5862	  try {
  5863	    // Log the title that was actually kept — for summer a refused retitle
  5864	    // must not show up in Change History under the refused name.
  5865	    const keptTitle = firestorePayload.projectTitle || existing.projectTitle || title;
  5880	
  5881	function cancelGridAction() {
  5882	  caActionMode = null;
  5883	  caSourceKey = null;
  5884	  renderAdminGrid();
  5885	}
  5886	
  5887	// Data Safety Plan Stage 2A/2B: shared helpers for the admin grid's move/swap
  5888	// abort-and-restore paths (see CLASSBOOK-DATA-SAFETY-PLAN.md).
  5889	// lessonHasContent() now lives in firebase-data.js (CONTENT_FIELDS is the
  5890	// single source of truth, Data Safety Plan Stage 4A) — this file just uses it.
  5891	
  5892	// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
  5893	// model. Backtracking audit, Phase 2 (reinstated round 4): adds an optional
  5894	// opts.source === 'server' param, needed by Phase 8's
  5895	// adminLessonStillExistsWithRetry() existence check below — omitting opts
  5896	// preserves the exact prior (cache-permitting) default for any future caller.
  5897	async function readAdminLessonDoc(semKey, lessonKey, opts = {}) {
  5898	  if (!curriculumDb) initCurriculumFirestore();
  5899	  const getOpts = opts.source === 'server' ? { source: 'server' } : undefined;
  5900	  const map = await readWeeklySemesterMap(semKey, getOpts);   // own-doc semesters read their own document
  5901	  return map?.[lessonKey] || null;
  5902	}
  5903	
  5904	// Backtracking audit, Phase 8: shared by cutProject() below and Phase 11's
  5905	// sendHelpResponse()/sendQaReply() (not yet implemented) — forced server
  5906	// read, retried once on failure, then lets a second failure throw so each
  5907	// caller decides how to surface it. Residual TOCTOU race (check-to-write gap)
  5908	// deliberately accepted, matching the companion plan's own decision for this
  5909	// identical helper — bounded by human click-to-click timing, not a tight
  5910	// machine loop; closing it fully would need a Firestore transaction.
  5911	async function adminLessonStillExistsWithRetry(semKey, key) {
  5912	  if (!curriculumDb) initCurriculumFirestore();
  5913	  const isSummer = lessonStoreFor(semKey) === 'camp';   // Phase 1, 1.1 — by type, and a third type throws
  5914	  const readOnce = async () => {
  5915	    if (isSummer) {
  5916	      const snap = await curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key)).get({ source: 'server' });
  5917	      return { exists: snap.exists, data: snap.exists ? snap.data() : null };
  5918	    }
  5919	    const data = await readAdminLessonDoc(semKey, key, { source: 'server' });
  5920	    return { exists: data !== null, data };
  5921	  };
  5922	  try {
  5923	    return await readOnce();
  5924	  } catch (err) {
  5925	    console.warn('⚠️ Existence check read failed, retrying once:', err);
  5926	    return await readOnce(); // a second failure throws — caller's catch handles it
  5927	  }
  5928	}
  5929	
  5930	// Reverts the admin grid's optimistic in-memory update after a move/swap that
  5931	// failed to save or failed verification — puts both slots back to their
  5932	// pre-action state (deleting the dest slot if it didn't exist before) and re-renders.
  5933	function restoreGridActionState(semKey, sourceKey, sourceLesson, destKey, destLesson) {
  5934	  if (!currentLessonData[semKey]) currentLessonData[semKey] = {};
  5935	  currentLessonData[semKey][sourceKey] = sourceLesson;
  5936	  if (destLesson) {
  5937	    currentLessonData[semKey][destKey] = destLesson;
  5938	  } else {
  5939	    delete currentLessonData[semKey][destKey];
  5940	  }
  5941	  renderAdminGrid();
  5942	}
  5943	
  5944	async function handleGridAction(destTeacher, destClassName, destWeekNum, destKey) {
  5945	  const semKey = getAdminSemKey();
  5946	  const lessons = { ...currentLessonData[semKey] };
  5947	  const sourceLesson = lessons[caSourceKey];
  5948	
  5949	  if (!sourceLesson) {
  5950	    cancelGridAction();
  5951	    return;
  5952	  }
  5953	
  5954	  // Prevent moving to same cell
  5955	  if (caSourceKey === destKey) {
  5956	    cancelGridAction();
  5957	    return;
  5958	  }
  5959	
  5960	  const destLesson = lessons[destKey] || null;
  5961	  const newDestKey = makeLessonKey(destTeacher, destClassName, destWeekNum);
  5962	
  5963	  if (caActionMode === 'move') {
  5964	    if (destLesson) {
  5965	      if (!confirm(`Week ${destWeekNum} already has "${destLesson.projectTitle}". This will overwrite it. Continue?`)) {
  5966	        cancelGridAction();
  5967	        return;
  5968	      }
  5969	    }
  5970	    if (!confirm(`Move "${sourceLesson.projectTitle}" from Week ${sourceLesson.weekNum} to ${destTeacher} / ${destClassName} Week ${destWeekNum}?`)) {
  5971	      cancelGridAction();
  5972	      return;
  5973	    }
  5974	
  5975	    // Move: put source content at destination, clear source
  5976	    const movedLesson = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum };
  5977	    movedLesson.weekDate = destLesson?.weekDate || '';
  5978	    // Backtracking audit, Phase 4: a content field non-empty at the existing
  5979	    // destination but empty in the incoming moved lesson must be explicitly
  5980	    // cleared — saveSingleLesson omits empty fields from the write rather
  5981	    // than clearing them, so without this the destination's old content
  5982	    // would silently survive underneath the moved lesson.
  5983	    const destFieldsToClear = CONTENT_FIELDS.filter(f =>
  5984	      (destLesson?.[f] || '').trim() !== '' && !(movedLesson[f] || '').trim()
  5985	    );
  5986	    lessons[newDestKey] = movedLesson;
  5987	    delete lessons[caSourceKey];
  5988	    currentLessonData[semKey] = lessons;
  5989	
  5990	    const sourceKeyToDelete = caSourceKey;
  5991	    const preMoveSourceLesson = sourceLesson;
  5992	    const preMoveDestLesson = destLesson;
  5993	    caActionMode = null;
  5994	    caSourceKey = null;
  5995	    renderAdminGrid();
  5996	    renderChangeHistory();
  5997	
  5998	    // Backtracking audit, Phase 9: the destination write and the source
  5999	    // delete are ONE atomic Firestore call — closes the "first write landed,
  6000	    // second failed" partial-failure race the prior sequential-write design
  6001	    // was vulnerable to. Does NOT independently verify movedLesson reflects
  6002	    // the CURRENT server state (a separate, deliberately deferred stale-input
  6003	    // race — see classbook-shared-document-concurrency-plan.html's 7th
  6004	    // instance) — no read-back needed or performed, since the write is
  6005	    // all-or-nothing.
  6006	    let moveSucceeded = false;
  6007	    try {
  6008	      await saveMultipleLessonFields(
  6009	        semKey,
  6010	        [{ lessonKey: newDestKey, lessonData: movedLesson, fieldsToClear: destFieldsToClear }],
  6011	        [sourceKeyToDelete]
  6012	      );
  6013	      moveSucceeded = true;
  6014	    } catch (err) {
  6015	      console.error('❌ Move failed:', err);
  6016	      restoreGridActionState(semKey, sourceKeyToDelete, preMoveSourceLesson, newDestKey, preMoveDestLesson);
  6017	      alert(`Move could not be saved — "${preMoveSourceLesson.projectTitle}" has been restored to its original slot. Nothing was changed.`);
  6018	      return;
  6019	    }
  6020	
  6021	    if (moveSucceeded) {
  6022	      try {
  6023	        await appendChangeLogEntry(semKey, {
  6024	          action: 'move',
  6025	          details: {
  6026	            projectTitle: sourceLesson.projectTitle,
  6027	            teacher: sourceLesson.teacher,
  6028	            className: sourceLesson.className,
  6029	            fromWeek: sourceLesson.weekNum,
  6030	            toTeacher: destTeacher,
  6031	            toClassName: destClassName,
  6032	            toWeek: destWeekNum
  6033	          }
  6034	        });
  6035	        renderChangeHistory();
  6036	      } catch (logErr) {
  6037	        console.error('⚠️ Move saved, but Change History logging failed:', logErr);
  6038	      }
  6039	    }
  6040	    return;
  6041	
  6042	  } else if (caActionMode === 'swap') {
  6043	    const destLabel = destLesson ? `"${destLesson.projectTitle}"` : 'empty slot';
  6044	    if (!confirm(`Swap "${sourceLesson.projectTitle}" (Week ${sourceLesson.weekNum}) with ${destLabel} (Week ${destWeekNum})?`)) {
  6045	      cancelGridAction();
  6046	      return;
  6047	    }
  6048	
  6049	    // Swap: exchange content between source and dest
  6050	    const sourceWeekNum = sourceLesson.weekNum;
  6051	    const sourceTeacher = sourceLesson.teacher;
  6052	    const sourceClassName = sourceLesson.className;
  6053	    const sourceWeekDate = sourceLesson.weekDate;
  6054	    const sourceKeyForSwap = caSourceKey;
  6055	
  6056	    let savePromise;
  6057	    let swapSucceeded = false;
  6058	    if (destLesson) {
  6059	      const swappedSource = { ...destLesson, teacher: sourceTeacher, className: sourceClassName, weekNum: sourceWeekNum, weekDate: sourceWeekDate };
  6060	      const swappedDest = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum, weekDate: destLesson.weekDate };
  6061	      // Backtracking audit, Phase 4: each slot's clear list compares its OWN
  6062	      // pre-swap content against what's now being written there — NOT the
  6063	      // other slot's pre-swap content, which would be a no-op since that's
  6064	      // identical-by-construction to the incoming value.
  6065	      const sourceFieldsToClear = CONTENT_FIELDS.filter(f =>
  6066	        (sourceLesson[f] || '').trim() !== '' && !(swappedSource[f] || '').trim()
  6067	      );
  6068	      const destFieldsToClearSwap = CONTENT_FIELDS.filter(f =>
  6069	        (destLesson[f] || '').trim() !== '' && !(swappedDest[f] || '').trim()
  6070	      );
  6071	      lessons[sourceKeyForSwap] = swappedSource;
  6072	      lessons[newDestKey] = swappedDest;
  6073	      currentLessonData[semKey] = lessons;
  6074	
  6075	      // Backtracking audit, Phase 9: both slots' writes are now ONE atomic
  6076	      // Firestore call — closes the "first save landed, second failed"
  6077	      // partial-failure race the prior two-sequential-saves design was
  6078	      // vulnerable to.
  6079	      savePromise = (async () => {
  6080	        try {
  6081	          await saveMultipleLessonFields(semKey, [
  6082	            { lessonKey: sourceKeyForSwap, lessonData: swappedSource, fieldsToClear: sourceFieldsToClear },
  6083	            { lessonKey: newDestKey, lessonData: swappedDest, fieldsToClear: destFieldsToClearSwap }
  6084	          ]);
  6085	          swapSucceeded = true;
  6086	        } catch (err) {
  6087	          console.error('❌ Swap failed:', err);
  6088	          restoreGridActionState(semKey, sourceKeyForSwap, sourceLesson, newDestKey, destLesson);
  6089	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" and "${destLesson.projectTitle}" have been restored to their original slots.`);
  6090	        }
  6091	      })();
  6092	    } else {
  6093	      // Swap with empty: move source to dest, clear source. Backtracking
  6094	      // audit, Phase 9: the destination write and source delete are now ONE
  6095	      // atomic Firestore call, same reasoning as the move branch above.
  6096	      const movedLesson = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum, weekDate: '' };
  6097	      lessons[newDestKey] = movedLesson;
  6098	      delete lessons[sourceKeyForSwap];
  6099	      currentLessonData[semKey] = lessons;
  6100	      savePromise = (async () => {
  6101	        try {
  6102	          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
  6103	          swapSucceeded = true;
  6104	        } catch (err) {
  6105	          console.error('❌ Swap failed:', err);
  6106	          restoreGridActionState(semKey, sourceKeyForSwap, sourceLesson, newDestKey, null);
  6107	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" has been restored to its original slot.`);
  6108	        }
  6109	      })();
  6110	    }
  6111	
  6112	    caActionMode = null;
  6113	    caSourceKey = null;
  6114	    renderAdminGrid();
  6115	    renderChangeHistory();
  6116	
  6117	    await savePromise;
  6118	
  6119	    if (swapSucceeded) {
  6120	      try {
  6200	  </div>`;
  6201	
  6202	  body.innerHTML = html;
  6203	}
  6204	
  6205	function toggleCopyAll(masterCb) {
  6206	  document.querySelectorAll('.ca-copy-cb').forEach(cb => { cb.checked = masterCb.checked; });
  6207	}
  6208	
  6209	// Backtracking audit, Phase 11 (R3-12, R3-13). Previously resaved the ENTIRE
  6210	// cached semester via saveLessonData() — any lesson whose local copy was stale
  6211	// (a teacher's concurrent save in another tab) was silently reverted on the
  6212	// server — mutated the shared cache before any write landed, and logged only
  6213	// after one bulk save, so a part-way failure lost the log for targets that
  6214	// had actually been written. Now: one targeted saveSingleLesson() per target
  6215	// with an explicit fieldsToClear (a source field that is EMPTY must clear the
  6216	// target's stale value — the save strips empty content fields, so without the
  6217	// clear the old text would survive under the new plan), cache committed per
  6218	// target only after its save resolves, logged immediately, honest count on
  6219	// failure.
  6220	async function executeCopyPlan(sourceKey) {
  6221	  const semKey = getAdminSemKey();
  6222	  const liveLessons = currentLessonData?.[semKey];
  6223	  const source = liveLessons?.[sourceKey];
  6224	  if (!source) return;
  6225	
  6226	  const checkboxes = document.querySelectorAll('.ca-copy-cb:checked');
  6227	  const targetKeys = Array.from(checkboxes).map(cb => cb.dataset.key);
  6228	
  6229	  if (targetKeys.length === 0) {
  6230	    alert('No targets selected.');
  6231	    return;
  6232	  }
  6233	
  6234	  // Check if any targets have existing plans
  6235	  const overwriteTargets = targetKeys.filter(k => liveLessons[k] && hasLessonContent(liveLessons[k]));
  6236	  if (overwriteTargets.length > 0) {
  6237	    const names = overwriteTargets.map(k => {
  6238	      const l = liveLessons[k];
  6239	      return `${l.teacher} — ${l.className} (Wk ${l.weekNum})`;
  6240	    }).join('\n');
  6241	    if (!confirm(`${overwriteTargets.length} target(s) already have lesson plans that will be overwritten:\n\n${names}\n\nContinue?`)) return;
  6242	  }
  6243	
  6244	  const fields = getCopyableFields(source); // the 7 CONTENT_FIELDS plus `materials`
  6245	  let savedCount = 0;
  6246	  let failure = null;
  6247	
  6248	  try {
  6249	    for (const targetKey of targetKeys) {
  6250	      if (!liveLessons[targetKey]) continue;
  6251	      // Work on copies — the shared cache object is only replaced below,
  6252	      // after this target's own save has resolved (R3-13).
  6253	      const previousTarget = { ...liveLessons[targetKey] };
  6254	      const targetFieldsToClear = CONTENT_FIELDS.filter(f =>
  6255	        (previousTarget[f] || '').trim() !== '' && !(fields[f] || '').trim()
  6256	      );
  6257	      // Send ONLY the copied fields (saveSingleLesson writes per-field paths
  6258	      // and stamps lastEditedBy/At onto this object). Sending the whole
  6259	      // cached target would re-write every non-content field — qaThread,
  6260	      // photoUrl, planComplete… — from this admin's possibly-stale copy over
  6261	      // a teacher's concurrent change (implementation review, Sep 2026).
  6262	      const payload = { ...fields };
  6263	      await saveSingleLesson(semKey, targetKey, payload, targetFieldsToClear);
  6264	      const updatedTarget = { ...previousTarget, ...payload };
  6265	      if (currentLessonData[semKey]) currentLessonData[semKey][targetKey] = updatedTarget;
  6266	      savedCount++;
  6267	      // Uncheck the saved target so, if a later one fails, "retry the rest"
  6268	      // re-runs only the rest (no duplicate copies or Change History entries).
  6269	      const cb = document.querySelector(`.ca-copy-cb[data-key="${CSS.escape(targetKey)}"]`);
  6270	      if (cb) cb.checked = false;
  6271	
  6272	      // Log this copy now — before the next target — so a later failure
  6273	      // can't lose the record of a write that already landed.
  6274	      const logEntry = {
  6275	        action: 'copy',
  6276	        details: {
  6277	          projectTitle: source.projectTitle,
  6278	          fromTeacher: source.teacher,
  6279	          fromClassName: source.className,
  6280	          fromWeek: source.weekNum,
  6281	          toTeacher: updatedTarget.teacher,
  6282	          toClassName: updatedTarget.className,
  6283	          toWeek: updatedTarget.weekNum
  6284	        }
  6285	      };
  6286	      // Capture the overwritten plan whenever ANY copyable field had text —
  6287	      // the clear above is explicit and intentional, so Change History must
  6288	      // hold the recovery record even when the prior content lived only in
  6289	      // processStep2-4/closure/dayOfMaterials (which the looser
  6290	      // hasLessonContent() used for the confirm prompt doesn't look at).
  6291	      const previousPlan = getCopyableFields(previousTarget);
  6292	      if (Object.values(previousPlan).some(v => String(v).trim())) {
  6293	        logEntry.details.previousPlan = previousPlan;
  6294	      }
  6295	      try {
  6296	        await appendChangeLogEntry(semKey, logEntry);
  6297	      } catch (logErr) {
  6298	        // The copy itself is saved; a Change History miss must not read as
  6299	        // a failed copy (same rule as saveTeacherEdit(), Phase 8).
  6300	        console.error('⚠️ Copy saved, but Change History logging failed for', targetKey, logErr);
  6301	      }
  6302	    }
  6303	  } catch (err) {
  6304	    console.error('❌ Copy Plan failed partway through:', err);
  6305	    failure = err;
  6306	  }
  6307	
  6308	  // UI after the try/catch so a render exception can't be misreported as a
  6309	  // failed save (and can't re-throw from inside the catch).
  6310	  renderAdminGrid();
  6311	  renderChangeHistory();
  6312	  if (failure) {
  6313	    alert(`Copied to ${savedCount} of ${targetKeys.length} class(es) before a save failed. Please check which targets actually received the plan before retrying the rest.\n\n${failure.message}`);
  6314	    return;
  6315	  }
  6316	  closeAdminModal();
  6317	  const skipped = targetKeys.length - savedCount;
  6318	  alert(`Plan copied to ${savedCount} class${savedCount !== 1 ? 'es' : ''}${skipped > 0 ? ` (${skipped} skipped)` : ''}.`);
  6319	}
  6320	
  6321	// Backtracking audit, Phase 8: rebuilt around the companion plan's Phase 17
  6322	// design. Forced-server read before archiving or deleting anything (closes
  6323	// two failure modes: the doc no longer existing at all, and the doc existing
  6324	// but having genuinely different content than this admin's stale local
  6325	// snapshot — a teacher's concurrent edit). Archives the COMPLETE fresh
  6326	// lesson object (not a hand-picked field list) via FieldValue.arrayUnion()
  6327	// against curriculum/cutProjects (not saveCutProjects()'s local-splice-then-
  6328	// full-array-overwrite — two admins cutting concurrently now both survive
  6329	// regardless of write order). Archive-before-delete ordering — a failed
  6330	// archive save leaves the live lesson completely untouched.
  6331	async function cutProject(key) {
  6332	  const semKey = getAdminSemKey();
  6333	  const lessons = { ...currentLessonData[semKey] };
  6334	  const lesson = lessons[key];
  6335	  if (!lesson) return;
  6336	
  6337	  if (!confirm(`Cut "${lesson.projectTitle}" from ${lesson.teacher} / ${lesson.className} Week ${lesson.weekNum}? It will be moved to the Cut Projects bank.`)) return;
  6338	
  6339	  let check;
  6340	  try {
  6341	    check = await adminLessonStillExistsWithRetry(semKey, key);
  6342	  } catch (err) {
  6343	    console.error('Could not confirm current state before cutting', key, err);
  6344	    alert(`Could not confirm "${lesson.projectTitle}" still exists — nothing was cut. Check your connection and try again.`);
  6345	    return;
  6346	  }
  6347	  if (!check.exists) {
  6348	    alert(`"${lesson.projectTitle}" no longer exists — it may have been moved, deleted, or already cut by someone else. Nothing was cut.`);
  6349	    if (currentLessonData[semKey]) delete currentLessonData[semKey][key];
  6350	    renderAdminGrid();
  6351	    return;
  6352	  }
  6353	  const freshLesson = check.data;
  6354	
  6355	  // The first confirm() above authorized cutting THIS project, by name — if
  6356	  // the fresh read shows the slot's identity has materially changed since
  6357	  // then, that authorization doesn't cover it.
  6358	  if (freshLesson.projectTitle !== lesson.projectTitle || freshLesson.teacher !== lesson.teacher || freshLesson.className !== lesson.className) {
  6359	    if (!confirm(`This slot has changed since you opened it — it now contains "${freshLesson.projectTitle}" (${freshLesson.teacher} / ${freshLesson.className}). Cut this instead?`)) return;
  6360	  }
  6361	
  6362	  const user = getAuthUser();
  6363	  const archiveEntry = {
  6364	    ...freshLesson,
  6365	    originalTeacher: freshLesson.teacher,
  6366	    originalClassName: freshLesson.className,
  6367	    originalWeek: freshLesson.weekNum,
  6368	    cutDate: new Date().toISOString(),
  6369	    cutBy: user?.name || 'Unknown'
  6370	  };
  6371	
  6372	  if (!curriculumDb) initCurriculumFirestore();
  6373	  try {
  6374	    await curriculumDb.collection('curriculum').doc('cutProjects').set({
  6375	      [semKey]: firebase.firestore.FieldValue.arrayUnion(archiveEntry)
  6376	    }, { merge: true });
  6377	  } catch (e) {
  6378	    console.error('Could not save Cut Bank entry for', key, e);
  6379	    alert(`Could not cut "${freshLesson.projectTitle}" — the Cut Bank entry could not be saved. Nothing was changed.`);
  6380	    return;
  6381	  }
  6382	
  6383	  let deleteFailed = false;
  6384	  try {
  6385	    await deleteLessonKey(semKey, key);
  6386	  } catch (e) {
  6387	    console.error('Could not delete lesson after archiving', key, e);
  6388	    deleteFailed = true;
  6389	  }
  6390	
  6391	  // Local cache/grid only drops the lesson when the delete actually
  6392	  // succeeded — a failed delete leaves the grid showing the lesson as gone
  6393	  // while Firestore still has it live otherwise.
  6394	  if (!deleteFailed) {
  6395	    delete lessons[key];
  6396	    currentLessonData[semKey] = lessons;
  6397	  }
  6398	  if (!currentCutProjects) currentCutProjects = {};
  6399	  currentCutProjects[semKey] = [...(currentCutProjects[semKey] || []), archiveEntry];
  6400	
  6401	  try {
  6402	    await appendChangeLogEntry(semKey, {
  6403	      action: 'cut',
  6404	      details: { projectTitle: freshLesson.projectTitle, teacher: freshLesson.teacher, className: freshLesson.className, fromWeek: freshLesson.weekNum }
  6405	    });
  6406	    renderChangeHistory();
  6407	  } catch (logErr) {
  6408	    console.error('⚠️ Cut saved, but Change History logging failed:', logErr);
  6409	  }
  6410	
  6480	// (not saveCutProjects()'s local-splice-then-full-array-overwrite — matches
  6481	// cutProject()'s arrayUnion() append-side fix, same document, same reasoning:
  6482	// two admins acting on the Cut Bank concurrently now both survive). The
  6483	// reconstruction below is an EXPLICIT FIELD WHITELIST, not spread-minus-
  6484	// exclude — a whitelist can't leak a future field cutProject()'s
  6485	// complete-spread archive starts including that an exclude-list doesn't yet
  6486	// know to exclude. classSize preserves the destination's own existing
  6487	// scaffold value (round-6 fix) rather than being hardcoded to 0 — nothing
  6488	// downstream recomputes it on paste. teacherNotes/adminResponse/status are
  6489	// excluded alongside qaThread (round-6 fix): getQaThread() reconstructs a
  6490	// Q&A thread from teacherNotes/adminResponse whenever qaThread is absent, so
  6491	// restoring those two fields alone would still leak the original
  6492	// conversation even with qaThread itself correctly omitted.
  6493	async function pasteFromCutBank(cutIndex, teacher, className, weekNum, sourceSemKey) {
  6494	  const destSemKey = getAdminSemKey();
  6495	  const srcSemKey = sourceSemKey || destSemKey;
  6496	  const cutProjects = currentCutProjects?.[srcSemKey] || [];
  6497	  const proj = cutProjects[cutIndex];
  6498	  if (!proj) return;
  6499	
  6500	  const isCrossSemester = srcSemKey !== destSemKey;
  6501	  const srcSemName = currentConfig?.semesters?.[srcSemKey]?.name || srcSemKey;
  6502	  const confirmMsg = isCrossSemester
  6503	    ? `Paste "${proj.projectTitle}" from ${srcSemName} into ${teacher} / ${className} Week ${weekNum}?`
  6504	    : `Paste "${proj.projectTitle}" into ${teacher} / ${className} Week ${weekNum}?`;
  6505	  if (!confirm(confirmMsg)) return;
  6506	
  6507	  const key = makeLessonKey(teacher, className, weekNum);
  6508	  const lessons = { ...(currentLessonData?.[destSemKey] || {}) };
  6509	  const existingDest = lessons[key] || {};
  6510	  const existingDestClassSize = existingDest.classSize || 0;
  6511	  const existingDestPhotoPath = existingDest.photoPath || null;
  6512	
  6513	  lessons[key] = {
  6514	    teacher, className, weekNum, weekDate: '', classSize: existingDestClassSize,
  6515	    projectTitle: proj.projectTitle,
  6516	    shortDetails: proj.shortDetails || '',
  6517	    inspoLink: proj.inspoLink || '',
  6518	    introPitch: proj.introPitch || '',
  6519	    processStep1: proj.processStep1 || '', processStep2: proj.processStep2 || '',
  6520	    processStep3: proj.processStep3 || '', processStep4: proj.processStep4 || '',
  6521	    closure: proj.closure || '',
  6522	    materials: proj.materials || '',
  6523	    materialsList: proj.materialsList || [],
  6524	    dayOfMaterials: proj.dayOfMaterials || '',
  6525	    publishToPrep: proj.publishToPrep || '',
  6526	    lastImported: new Date().toISOString()
  6527	    // Deliberately NOT restored: qaThread, photoUrl/photoPath, planComplete
  6528	    // (tied to the ORIGINAL lesson instance, not reusable project content),
  6529	    // and teacherNotes/adminResponse/status (round-6: getQaThread() would
  6530	    // silently reconstruct the original Q&A conversation from these alone).
  6531	  };
  6532	  // Merely OMITTING those fields above only means "don't touch them" — if the
  6533	  // DESTINATION slot already had its own stale qaThread/photo/planComplete
  6534	  // from whatever occupied it before, that would otherwise survive untouched
  6535	  // and resurrect an unrelated Q&A thread under the newly-pasted content.
  6536	  // Explicitly clear them so a paste genuinely starts fresh.
  6537	  const NON_CONTENT_FIELDS_TO_CLEAR = ['qaThread', 'photoUrl', 'photoPath', 'planComplete', 'teacherNotes', 'adminResponse', 'status'];
  6538	
  6539	  let pasteConfirmed = false;
  6540	  try {
  6541	    await saveSingleLesson(destSemKey, key, lessons[key], NON_CONTENT_FIELDS_TO_CLEAR);
  6542	    pasteConfirmed = true;
  6543	  } catch (err) {
  6544	    console.error('❌ Paste from Cut Bank failed to save the lesson:', err);
  6545	    alert(`Could not paste "${proj.projectTitle}" — please try again.`);
  6546	    return;
  6547	  }
  6548	
  6549	  // Only delete the destination's old photo from Storage after Firestore has
  6550	  // confirmed the clear — same safe ordering as saveAdminEdit()/saveTeacherEdit().
  6551	  if (existingDestPhotoPath) {
  6552	    try {
  6553	      await deleteLessonPhoto(existingDestPhotoPath);
  6554	    } catch (cleanupErr) {
  6555	      console.error('⚠️ Could not clean up destination\'s old photo after paste (Firestore is correct, Storage has an orphan):', cleanupErr);
  6556	    }
  6557	  }
  6558	
  6559	  currentLessonData[destSemKey] = lessons;
  6560	  closeAdminModal();
  6561	  renderAdminGrid();
  6562	
  6563	  if (!curriculumDb) initCurriculumFirestore();
  6564	  try {
  6565	    await curriculumDb.collection('curriculum').doc('cutProjects').set({
  6566	      [srcSemKey]: firebase.firestore.FieldValue.arrayRemove(proj)
  6567	    }, { merge: true });
  6568	    if (currentCutProjects?.[srcSemKey]) {
  6569	      currentCutProjects[srcSemKey] = currentCutProjects[srcSemKey].filter(p => p !== proj);
  6570	    }
  6960	// pasteFromCutBank()'s own NON_CONTENT_FIELDS_TO_CLEAR pattern, since simply
  6961	// omitting a field only means "don't touch it," not "clear it") — and
  6962	// lesson-save-then-idea-removal ordering with an honest duplicate-message on
  6963	// a removal failure.
  6964	async function pasteFromIdeaBank(idx, teacher, className, weekNum) {
  6965	  const projects = currentFutureProjects?.projects || [];
  6966	  const proj = projects[idx];
  6967	  if (!proj) return;
  6968	
  6969	  if (!confirm(`Paste "${proj.title}" into ${teacher} / ${className} Week ${weekNum}? The idea will be removed from the bank.`)) return;
  6970	
  6971	  const semKey = getAdminSemKey();
  6972	  const key = makeLessonKey(teacher, className, weekNum);
  6973	  const existingLesson = currentLessonData?.[semKey]?.[key] || {};
  6974	  const existingClassSize = existingLesson.classSize || 0;
  6975	  const existingPhotoPath = existingLesson.photoPath || null;
  6976	  const newLesson = {
  6977	    teacher,
  6978	    className,
  6979	    weekNum,
  6980	    weekDate: '',
  6981	    classSize: existingClassSize,
  6982	    projectTitle: proj.title,
  6983	    shortDetails: proj.description || '',
  6984	    inspoLink: proj.inspoLink || '',
  6985	    introPitch: '',
  6986	    processStep1: '',
  6987	    processStep2: '',
  6988	    processStep3: '',
  6989	    processStep4: '',
  6990	    closure: '',
  6991	    materials: '',
  6992	    dayOfMaterials: '',
  6993	    status: '',
  6994	    publishToPrep: '',
  6995	    teacherNotes: '',
  6996	    adminResponse: '',
  6997	    lastImported: new Date().toISOString()
  6998	  };
  6999	
  7000	  // An idea's blank fields must actually CLEAR stale destination content, not
  7001	  // silently leave it — same pattern used everywhere else in this plan.
  7002	  const fieldsToClear = CONTENT_FIELDS.filter(f =>
  7003	    (existingLesson[f] || '').trim() !== '' && !(newLesson[f] || '').trim()
  7004	  );
  7005	  // Instance-specific fields tied to whatever previously occupied this slot —
  7006	  // an Idea Bank project never supplies these, so newLesson never sets them,
  7007	  // and buildLessonFieldUpdates() only touches fields actually present in the
  7008	  // object it's given. Without an explicit clear, a destination's own stale
  7009	  // Q&A thread, photo, completion flag, or materials list would silently
  7010	  // resurrect under the newly-pasted idea.
  7011	  const NON_CONTENT_FIELDS_TO_CLEAR = ['qaThread', 'photoUrl', 'photoPath', 'planComplete', 'materialsList'];
  7012	
  7013	  try {
  7014	    await saveSingleLesson(semKey, key, newLesson, [...fieldsToClear, ...NON_CONTENT_FIELDS_TO_CLEAR]);
  7015	    if (currentLessonData[semKey]) currentLessonData[semKey][key] = newLesson;
  7016	  } catch (err) {
  7017	    console.error('❌ Paste from Idea Bank failed — lesson could not be saved:', err);
  7018	    alert(`Could not paste "${proj.title}" — please try again. The idea is still in the bank.`);
  7019	    return;
  7020	  }
  7021	
  7022	  // Only delete the destination's old photo from Storage after Firestore has
  7023	  // confirmed the clear — same safe ordering as pasteFromCutBank()/
  7024	  // saveAdminEdit()/saveTeacherEdit().
  7025	  if (existingPhotoPath) {
  7026	    try {
  7027	      await deleteLessonPhoto(existingPhotoPath);
  7028	    } catch (cleanupErr) {
  7029	      console.error('⚠️ Could not clean up destination\'s old photo after paste (Firestore is correct, Storage has an orphan):', cleanupErr);
  7030	    }
  7031	  }
  7032	
  7033	  // NOT closed here: this is still a plain saveFutureProjects() .set(), the
  7034	  // same shared last-write-wins primitive as the Idea Bank's other five
  7035	  // writers (classbook-shared-document-concurrency-plan.html, instance 1) —
  7036	  // a concurrent-paste-where-one-fails edge case can leave the local cache
  7037	  // disagreeing with a successful server-side removal until reload (no
  7038	  // server-side data loss). The real fix is converting removal to an atomic
  7039	  // FieldValue.arrayRemove() across all six writers together, tracked there;
  7040	  // out of scope for this single-function live-bug fix.
  7180	// argument list with the legacy teacherNotes/adminResponse thread on a
  7181	// lesson's FIRST atomic-append reply, so that legacy content isn't silently
  7182	// lost the moment qaThread gets its first real entry. arrayUnion's deep-
  7183	// equality dedup makes repeating this migration from concurrent senders safe.
  7184	function buildQaThreadUnionArgs(existingLesson, newEntry) {
  7185	  const needsMigration = !existingLesson?.qaThread || existingLesson.qaThread.length === 0;
  7186	  return needsMigration ? [...getQaThread(existingLesson || {}), newEntry] : [newEntry];
  7187	}
  7188	
  7189	// Backtracking audit Phase 11 fix: both admin Q&A reply functions used to
  7190	// resave the ENTIRE cached semester via saveLessonData() — a Firestore
  7191	// set({merge:true}) of every lesson currently sitting in this admin's
  7192	// browser, not just the one being replied to. If a teacher's save landed on
  7193	// the server in the split-second before this admin's live listener caught
  7194	// up, that reply would silently revert the teacher's edit back to this
  7195	// admin's stale cached copy — for ANY lesson in the semester, not just the
  7196	// one in the reply. Now a single targeted Firestore .update() touching only
  7197	// this lesson's own field paths, with arrayUnion() for qaThread (survives a
  7198	// genuinely concurrent sender) and an existence check (a stale, long-open
  7199	// popup can't silently recreate a lesson deleted/moved elsewhere).
  7200	async function sendHelpResponse(key) {
  7201	  const input = document.getElementById(`ca-help-input-${key}`);
  7202	  if (!input) return;
  7203	  const response = input.value.trim();
  7204	  if (!response) return;
  7205	
  7206	  const semKey = getAdminSemKey();
  7207	  // Same load guard as every other lesson writer (Phase 1 review): after a
  7208	  // failed reload the listener deliberately KEEPS the previous summer maps, so
  7209	  // the cached lesson and the existence check both still pass — without this
  7210	  // an admin could write a reply while the banner says saving is disabled.
  7211	  if (lessonDataLoadedSuccessfully === false) {
  7212	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  7213	    return;
  7214	  }
  7215	  // A semester type this writer has no branch for is refused here, before the
  7216	  // existence check below — a throw inside that try would be reported to the
  7217	  // admin as "check your connection", which it isn't (Phase 1, 1.1).
  7218	  let lessonStore;
  7219	  try {
  7220	    lessonStore = lessonStoreFor(semKey);
  7221	  } catch (err) {
  7222	    alert(err.message);
  7223	    return;
  7224	  }
  7225	  const cachedExisting = currentLessonData?.[semKey]?.[key];
  7226	  if (!cachedExisting) return;
  7227	
  7228	  let check;
  7229	  try {
  7230	    check = await adminLessonStillExistsWithRetry(semKey, key);
  7231	  } catch (err) {
  7232	    console.warn('⚠️ Existence check retry also failed:', err);
  7233	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  7234	    return;
  7235	  }
  7236	  if (!check.exists) {
  7237	    alert('This lesson was moved or removed elsewhere. Your response was not sent — please close this and check the grid for its new location.');
  7238	    return;
  7239	  }
  7240	  const existing = check.data || cachedExisting;
  7241	
  7242	  const user = getAuthUser();
  7243	  const newEntry = {
  7244	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  7245	    from: 'admin', name: user?.name || 'Admin', message: response, timestamp: new Date().toISOString()
  7246	  };
  7247	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7248	
  7249	  if (!curriculumDb) initCurriculumFirestore();
  7250	  const isSummer = lessonStore === 'camp';
  7251	  const updates = {};
  7252	  let weekly = null;
  7253	  if (!isSummer) {
  7254	    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
  7255	  }
  7256	  if (isSummer) {
  7257	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7258	    updates.adminResponse = response;
  7259	    updates.status = 'In Progress';
  7260	    updates.lastUpdated = new Date().toISOString();
  7261	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7262	  } else {
  7263	    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7264	    updates[`${weekly.prefix}${key}.adminResponse`] = response;
  7265	    updates[`${weekly.prefix}${key}.status`] = 'In Progress';
  7266	    updates.lastUpdated = new Date().toISOString();
  7267	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7268	  }
  7269	  const docRef = isSummer
  7270	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7271	    : weekly.ref;
  7272	
  7273	  try {
  7274	    await docRef.update(updates);
  7275	  } catch (err) {
  7276	    console.error('Error sending help response:', err);
  7277	    alert('Error sending response: ' + err.message);
  7278	    return;
  7279	  }
  7280	
  7281	  currentLessonData[semKey][key] = {
  7282	    ...existing, adminResponse: response,
  7283	    qaThread: [...(existing.qaThread && existing.qaThread.length > 0 ? existing.qaThread : getQaThread(existing)), newEntry],
  7284	    status: 'In Progress'
  7285	  };
  7286	  renderHelpQueue();
  7287	}
  7288	
  7289	async function sendQaReply(key) {
  7290	  const input = document.getElementById(`qa-reply-${key}`);
  7291	  if (!input) return;
  7292	  const message = input.value.trim();
  7293	  if (!message) return;
  7294	
  7295	  const semKey = getAdminSemKey();
  7296	  // Same load guard as every other lesson writer (Phase 1 review): after a
  7297	  // failed reload the listener deliberately KEEPS the previous summer maps, so
  7298	  // the cached lesson and the existence check both still pass — without this
  7299	  // an admin could write a reply while the banner says saving is disabled.
  7300	  if (lessonDataLoadedSuccessfully === false) {
  7301	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  7302	    return;
  7303	  }
  7304	  // A semester type this writer has no branch for is refused here, before the
  7305	  // existence check below — a throw inside that try would be reported to the
  7306	  // admin as "check your connection", which it isn't (Phase 1, 1.1).
  7307	  let lessonStore;
  7308	  try {
  7309	    lessonStore = lessonStoreFor(semKey);
  7310	  } catch (err) {
  7311	    alert(err.message);
  7312	    return;
  7313	  }
  7314	  const cachedExisting = currentLessonData?.[semKey]?.[key];
  7315	  if (!cachedExisting) return;
  7316	
  7317	  let check;
  7318	  try {
  7319	    check = await adminLessonStillExistsWithRetry(semKey, key);
  7320	  } catch (err) {
  7321	    console.warn('⚠️ Existence check retry also failed:', err);
  7322	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  7323	    return;
  7324	  }
  7325	  if (!check.exists) {
  7326	    alert('This lesson was moved or removed elsewhere. Your reply was not sent — please close this window and check the grid for its new location.');
  7327	    return;
  7328	  }
  7329	  const existing = check.data || cachedExisting;
  7330	
  7331	  const user = getAuthUser();
  7332	  const newEntry = {
  7333	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  7334	    from: 'admin', name: user?.name || 'Admin', message, timestamp: new Date().toISOString()
  7335	  };
  7336	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7337	
  7338	  if (!curriculumDb) initCurriculumFirestore();
  7339	  const isSummer = lessonStore === 'camp';
  7340	  const updates = {};
  7341	  let weekly = null;
  7342	  if (!isSummer) {
  7343	    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
  7344	  }
  7345	  if (isSummer) {
  7346	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7347	    updates.adminResponse = message;
  7348	    updates.lastUpdated = new Date().toISOString();
  7349	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7350	  } else {
  7351	    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7352	    updates[`${weekly.prefix}${key}.adminResponse`] = message;
  7353	    updates.lastUpdated = new Date().toISOString();
  7354	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7355	  }
  7356	  const docRef = isSummer
  7357	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7358	    : weekly.ref;
  7359	
  7360	  try {
  7361	    await docRef.update(updates);
  7362	  } catch (err) {
  7363	    console.error('Error sending Q&A reply:', err);
  7364	    alert('Error sending reply: ' + err.message);
  7365	    return;
  7366	  }
  7367	
  7368	  const updatedLesson = {
  7369	    ...existing, adminResponse: message,
  7370	    qaThread: [...(existing.qaThread && existing.qaThread.length > 0 ? existing.qaThread : getQaThread(existing)), newEntry]
  7371	  };
  7372	  currentLessonData[semKey][key] = updatedLesson;
  7373	  openDetailModal(updatedLesson, key, updatedLesson.teacher, updatedLesson.className, updatedLesson.weekNum);
  7374	}
  7375	
  7376	function toggleHelpQueue() {
  7377	  const content = document.getElementById('ca-help-content');
  7378	  content.style.display = content.style.display === 'none' ? 'block' : 'none';
  7379	}
  7380	

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '4620,4695p;4960,5075p;5560,5865p;5880,6120p;6200,6405p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
  4620	  if (!confirm(firstConfirm)) return;
  4621	  if (!isCamp && !isDayOff && !confirm(`Are you sure? Type OK in your head and click OK to confirm.`)) return;
  4622	
  4623	  // Remove the semester's own entry and nothing else (Phase 1, 1.2). Revert
  4624	  // this tab if the write is refused, or the config would be missing a
  4625	  // semester the server still has — with no alert and no re-render to show it
  4626	  // (Phase 1 review).
  4627	  const removed = currentConfig.semesters[key];
  4628	  delete currentConfig.semesters[key];
  4629	  try {
  4630	    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
  4631	  } catch (err) {
  4632	    currentConfig.semesters[key] = removed;
  4633	    console.error('❌ Could not remove the semester:', err);
  4634	    alert(`Could not remove "${sem.name}": ${err.message}\n\nNothing was changed.`);
  4635	    renderSemesterSelector();
  4636	    return;
  4637	  }
  4638	
  4639	  // Drop this season's in-memory map either way…
  4640	  if (currentLessonData?.[key]) {
  4641	    delete currentLessonData[key];
  4642	  }
  4643	  // …but only a WEEKLY semester has lessons of its own inside
  4644	  // curriculum/lessonData to delete. A camp season's lessons live in the
  4645	  // shared summerCamps_* collections and are never touched from here.
  4646	  if (isDayOff) {
  4647	    delete currentDayOffEvents[key]; delete currentDayOffCamps[key]; delete currentDayOffPlans[key]; delete currentDayOffSignoffs[key];
  4648	  } else if (!isCamp) {
  4649	    try {
  4650	      await deleteLessonData(key);
  4651	    } catch (e) { console.warn('Could not delete lesson data for', key, e); }
  4652	  }
  4653	
  4654	  // Switch to active semester
  4655	  caCurrentSemester = currentConfig.activeSemester;
  4656	  renderSemesterSelector();
  4657	  renderAdminGrid();
  4658	  renderHelpQueue();
  4659	  renderCutBank();
  4660	  renderIdeaBank();
  4661	  renderChangeHistory();
  4662	}
  4663	
  4664	function switchAdminSemester(key) {
  4665	  // Delegates to global semester — CA always stays in sync with the header selector
  4666	  setGlobalSemester(key);
  4667	}
  4668	
  4669	async function toggleSemesterPublish(key, published) {
  4670	  if (!currentConfig?.semesters?.[key]) return;
  4671	  if (!isPublishableType(key)) { alert('This semester type can\'t be published.'); return; }
  4672	  // SDOC (Phase 2B): publishing shows the year to every teacher on a camp —
  4673	  // say so first if some camps have nobody to see them.
  4674	  if (published && isDayOffYear(key)) {
  4675	    // The camp list below must be real to warn from — never publish on a failed load.
  4676	    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
  4677	    const bare = (currentDayOffCamps[key] || []).filter(c => !(c.teachers || []).length).length;
  4678	    if (bare && !confirm(`${bare} camp${bare === 1 ? ' has' : 's have'} no teacher yet — publish anyway?`)) { renderSemesterSelector(); return; }
  4679	  }
  4680	  const hadPublished = 'published' in currentConfig.semesters[key];
  4681	  const previous = currentConfig.semesters[key].published;
  4682	  currentConfig.semesters[key].published = published;
  4683	  try {
  4684	    await updateAppData({ [`semesters.${key}.published`]: published });
  4685	  } catch (err) {
  4686	    // Restore exactly what was there — including "the field was absent".
  4687	    if (currentConfig.semesters[key]) {
  4688	      if (hadPublished) currentConfig.semesters[key].published = previous;
  4689	      else delete currentConfig.semesters[key].published;
  4690	    }
  4691	    console.error('❌ Could not change the publish state:', err);
  4692	    alert(`Could not ${published ? 'publish' : 'unpublish'} that semester: ${err.message}\n\nNothing was changed.`);
  4693	  }
  4694	  renderSemesterSelector();
  4695	}
  4960	  let lessonDataCommitted = false;
  4961	  creatingSemester = true;
  4962	  try {
  4963	    // Copy roster from existing semester if selected
  4964	    if (copyFromKey && currentConfig.semesters[copyFromKey]) {
  4965	      // Pre-check (implementation review, Sep 2026): this branch is the only
  4966	      // path that writes lesson data, and the compensating delete in the catch
  4967	      // below removes the WHOLE `key` map — only safe if nothing lived there
  4968	      // before this call. It can: deleteSemester() drops a key from local
  4969	      // state even when its server-side deleteLessonData() fails (warn-only),
  4970	      // and config has no live listener, so another admin's same-named
  4971	      // semester isn't visible here either. Forced server read — the local
  4972	      // cache is exactly what can't be trusted for this key. Refuse unless
  4973	      // every existing lesson is template-empty (a prior createNewSemester()'s
  4974	      // own leftovers are safe to build on and safe to delete; anything else
  4975	      // would be merged over silently by the slot write, then deleted on
  4976	      // failure). The no-copy path is deliberately NOT gated: it writes no
  4977	      // lesson data, and re-creating a deleted semester there adopts its
  4978	      // surviving lesson data — the remedy this alert points at.
  4979	      const existingLessonMap = await readServerSemesterLessonMap(key);
  4980	      if (existingLessonMap && Object.values(existingLessonMap).some(l => !isTemplateEmptyLesson(l))) {
  4981	        alert(`Lesson content already exists in Firestore under the key "${key}".\n\nIf it was left over from a deleted semester, create this semester again without "Copy from" to adopt that data.\n\nIf another admin may have just created it, reload this page first.\n\nOtherwise choose a different name.`);
  4982	        return;
  4983	      }
  4984	
  4985	      const source = currentConfig.semesters[copyFromKey];
  4986	      newSem.classRoster = JSON.parse(JSON.stringify(source.classRoster || {}));
  4987	      // Without this, classRoster's teacher fields are copied but the dropdown
  4988	      // that lets Settings display/edit them has no options — the roster looks
  4989	      // wiped even though the underlying data isn't, and saving Settings in
  4990	      // that state silently writes blank teachers over the real ones.
  4991	      newSem.teacherNames = JSON.parse(JSON.stringify(source.teacherNames || []));
  4992	
  4993	      // Create empty lesson slots from source semester's teacher/class combos
  4994	      const sourceLessons = currentLessonData?.[copyFromKey] || {};
  4995	      const combos = new Set();
  4996	      for (const lesson of Object.values(sourceLessons)) {
  4997	        combos.add(`${lesson.teacher}|||${lesson.className}`);
  4998	      }
  4999	
  5000	      const emptyLessons = {};
  5001	      for (const combo of combos) {
  5002	        const [teacher, className] = combo.split('|||');
  5003	        for (let w = 1; w <= numWeeks; w++) {
  5004	          const lessonKey = makeLessonKey(teacher, className, w);
  5005	          emptyLessons[lessonKey] = {
  5006	            teacher,
  5007	            className,
  5008	            weekNum: w,
  5009	            weekDate: '',
  5010	            classSize: 0,
  5011	            projectTitle: '',
  5012	            shortDetails: '',
  5013	            inspoLink: '',
  5014	            introPitch: '',
  5015	            processStep1: '',
  5016	            processStep2: '',
  5017	            processStep3: '',
  5018	            processStep4: '',
  5019	            closure: '',
  5020	            materials: '',
  5021	            dayOfMaterials: '',
  5022	            materialsList: [],
  5023	            status: '',
  5024	            publishToPrep: ''
  5025	          };
  5026	        }
  5027	      }
  5028	
  5029	      if (Object.keys(emptyLessons).length > 0) {
  5030	        await saveLessonData(key, emptyLessons);
  5031	        if (!currentLessonData) currentLessonData = {};
  5032	        currentLessonData[key] = emptyLessons;
  5033	        lessonDataCommitted = true;
  5034	      }
  5035	    }
  5036	
  5037	    // Confirm on the SERVER that the key is free — the check at the top of this
  5038	    // function only saw this tab's copy of the config (Phase 1, 1.2). The
  5039	    // remaining read-to-update window is accepted: one admin, same class as the
  5040	    // existing residual on the Q&A path.
  5041	    const serverConfig = await readAppDataFromServer();
  5042	    if (serverConfig?.semesters?.[key]) {
  5043	      throw new Error(`A semester with the key "${key}" already exists (created in another tab or by another admin). Choose a different name.`);
  5044	    }
  5045	    currentConfig.semesters[key] = newSem;
  5046	    await updateAppData({ [`semesters.${key}`]: newSem });
  5047	  } catch (err) {
  5048	    console.error('❌ Could not create new semester:', err);
  5049	    // Revert both local mutations so a retry isn't blocked by a phantom
  5050	    // "already exists" and the grid doesn't render a semester that never saved.
  5051	    delete currentConfig.semesters[key];
  5052	    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
  5053	    // R4-11: the empty lesson slots may already be persisted even though the
  5054	    // config never was — clean up the orphaned server-side write, not just the
  5055	    // local copy. Safe: this data is template-empty by construction (never had
  5056	    // real content), so deleting it loses nothing.
  5057	    if (lessonDataCommitted) {
  5058	      try {
  5059	        await deleteLessonData(key);
  5060	      } catch (cleanupErr) {
  5061	        console.error('⚠️ Could not clean up orphaned lesson data after failed semester creation:', cleanupErr);
  5062	      }
  5063	    }
  5064	    alert('Could not create the new semester. Please try again.');
  5065	    return;
  5066	  } finally {
  5067	    creatingSemester = false;
  5068	  }
  5069	
  5070	  closeNewSemesterModal();
  5071	  caCurrentSemester = key;
  5072	  renderSemesterSelector();
  5073	  renderAdminGrid();
  5074	  renderHelpQueue();
  5075	  renderCutBank();
  5560	    <div class="settings-form-group">
  5561	      <label>Materials to Prep</label>
  5562	      <textarea id="ca-edit-materials" rows="2" placeholder="Materials needed"${ro}>${escHtml(l.materials || '')}</textarea>
  5563	    </div>
  5564	    <div class="settings-form-group">
  5565	      <label>Day-Of Materials</label>
  5566	      <textarea id="ca-edit-dayof" rows="2" placeholder="Materials to set up day-of">${escHtml(l.dayOfMaterials || '')}</textarea>
  5567	    </div>
  5568	    <div class="settings-form-group">
  5569	      <label>Demo Photo</label>
  5570	      ${l.photoUrl ? `<div id="ca-edit-photo-preview" style="margin-bottom:8px">${safeHttpUrl(l.photoUrl) ? `<img src="${escAttr(safeHttpUrl(l.photoUrl))}" style="max-height:150px;border-radius:8px;border:1px solid var(--border-light)"><br>` : ''}<button type="button" class="te-photo-remove-btn" style="position:static;margin-top:4px" onclick="document.getElementById('ca-edit-photo-preview').remove();document.getElementById('ca-edit-photo-input').dataset.pendingRemove='true'">Remove photo</button></div>` : ''}
  5571	      <input type="file" id="ca-edit-photo-input" accept="image/*" capture="environment">
  5572	      <span class="te-photo-hint">Take a photo or choose from library (max 5MB)</span>
  5573	    </div>
  5574	    <div class="ca-actions" style="margin-top:12px">
  5575	      <button class="btn-primary ca-action-btn" onclick="saveAdminEdit(${escForOnclick(key)}, ${escForOnclick(teacher)}, ${escForOnclick(className)}, ${weekNum})">Save</button>
  5576	      <button class="btn-secondary ca-action-btn" onclick="printAdminLesson(${escForOnclick(key)})">&#128438; Print</button>
  5577	      <button class="btn-secondary ca-action-btn" onclick="closeAdminModal()">Cancel</button>
  5578	    </div>
  5579	  </div>`;
  5580	}
  5581	
  5582	function showAdminEdit(key, teacher, className, weekNum) {
  5583	  const semKey = getAdminSemKey();
  5584	  const lesson = currentLessonData?.[semKey]?.[key] || null;
  5585	  captureAdminEditSnapshot(lesson);
  5586	
  5587	  const modal = document.getElementById('ca-detail-modal');
  5588	  const title = document.getElementById('ca-modal-title');
  5589	  const body = document.getElementById('ca-modal-body');
  5590	
  5591	  title.textContent = lesson ? `Edit: ${lesson.projectTitle}` : `New Project — Week ${weekNum}`;
  5592	
  5593	  let html = `<div class="ca-detail-meta">
  5594	    <span><strong>Teacher:</strong> ${escHtml(teacher)}</span>
  5595	    <span><strong>Class:</strong> ${escHtml(className)}</span>
  5596	    <span><strong>Week:</strong> ${weekNum}</span>
  5597	  </div>`;
  5598	  html += renderAdminEditForm(lesson, key, teacher, className, weekNum);
  5599	
  5600	  body.innerHTML = html;
  5601	  modal.classList.add('open');
  5602	  // First editable field — on a summer lesson the title is read-only.
  5603	  document.querySelector('#ca-edit-form input:not([readonly]), #ca-edit-form textarea:not([readonly])')?.focus();
  5604	}
  5605	
  5606	// Data Safety Plan Phase 9 (+ backtracking audit Phase 1): the admin edit
  5607	// popup's save. What goes to Firestore is ONLY what this popup changed — the
  5608	// diff of the form against the open-time snapshot, plus the photo fields if
  5609	// this save touched them, plus identity/scheduling fields (teacher, className,
  5610	// weekNum, weekDate, classSize — no input in this form; resent from the cache
  5611	// exactly as before, an inherited exposure named in the plan, not a Phase 9
  5612	// change). The cached `existing` lesson is never spread into the payload, so
  5613	// a stale qaThread / photo / untouched content field can't overwrite another
  5614	// client's newer copy. Intentional clears travel as fieldsToClear. Before
  5615	// anything is written, a forced-server read confirms the lesson still exists
  5616	// (moved/deleted elsewhere while the popup was open → refuse, don't recreate
  5617	// a ghost). Residual check-to-write TOCTOU gap accepted per the plan.
  5618	async function saveAdminEdit(key, teacher, className, weekNum) {
  5619	  if (caEditSaveInFlight) return;
  5620	  const title = document.getElementById('ca-edit-title')?.value.trim();
  5621	  // (closeAdminModal() refuses non-forced closes while caEditSaveInFlight is
  5622	  // set — Cancel / × / overlay are effectively disabled for the duration.)
  5623	  if (!title) { alert('Project title is required.'); return; }
  5624	
  5625	  // Backtracking audit, Phase 1: check the guard BEFORE any Storage mutation
  5626	  // (and, now, before the existence check) so a known-bad load state never
  5627	  // gets as far as a server read, an upload, or a delete.
  5628	  if (lessonDataLoadedSuccessfully === false) {
  5629	    alert('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  5630	    return;
  5631	  }
  5632	
  5633	  caEditSaveInFlight = true;
  5634	  // Every action button in the modal body — the form's own Save/Print/Cancel
  5635	  // AND the empty-cell popup's two Paste buttons, which openDetailModal()
  5636	  // renders outside #ca-edit-form (round-3 review: they could replace the
  5637	  // modal body mid-save and race a second write onto the same slot).
  5638	  const btns = Array.from(document.querySelectorAll('#ca-modal-body .ca-actions button'));
  5639	  const saveBtn = btns.find(b => /^save/i.test(b.textContent.trim()));
  5640	  btns.forEach(b => { b.disabled = true; });
  5641	  if (saveBtn) saveBtn.textContent = 'Saving...';
  5642	  try {
  5643	    await saveAdminEditInner(key, teacher, className, weekNum, title);
  5644	  } finally {
  5645	    caEditSaveInFlight = false;
  5646	    btns.forEach(b => { b.disabled = false; });
  5647	    if (saveBtn) saveBtn.textContent = 'Save';
  5648	  }
  5649	}
  5650	
  5651	async function saveAdminEditInner(key, teacher, className, weekNum, title) {
  5652	  const semKey = getAdminSemKey();
  5653	
  5654	  const lessons = { ...(currentLessonData?.[semKey] || {}) };
  5655	  let existing = lessons[key] || {};   // rebased on the fresh server copy after the existence check (non-summer)
  5656	
  5657	  // Step 1 — diff the form against the open-time snapshot (pure DOM reads, no
  5658	  // side effects — so a no-op save can bail out below without paying for the
  5659	  // existence check's server read).
  5660	  const raw = {
  5661	    projectTitle: title,
  5662	    shortDetails: document.getElementById('ca-edit-details')?.value.trim() || '',
  5663	    inspoLink: document.getElementById('ca-edit-inspo')?.value.trim() || '',
  5664	    introPitch: document.getElementById('ca-edit-intro')?.value.trim() || '',
  5665	    processStep1: document.getElementById('ca-edit-step1')?.value.trim() || '',
  5666	    processStep2: document.getElementById('ca-edit-step2')?.value.trim() || '',
  5667	    processStep3: document.getElementById('ca-edit-step3')?.value.trim() || '',
  5668	    processStep4: document.getElementById('ca-edit-step4')?.value.trim() || '',
  5669	    closure: document.getElementById('ca-edit-closure')?.value.trim() || '',
  5670	    materials: document.getElementById('ca-edit-materials')?.value.trim() || '',
  5671	    dayOfMaterials: document.getElementById('ca-edit-dayof')?.value.trim() || '',
  5672	  };
  5673	  // No snapshot (shouldn't happen — both render paths capture one) degrades to
  5674	  // "everything non-empty is changed": today's behavior, never a lost edit.
  5675	  const baseline = caEditOriginalData || {};
  5676	  const changedFields = Object.keys(raw).filter(f => raw[f] !== (baseline[f] || ''));
  5677	  // Had text when the popup opened, empty now — an intentional clear, which
  5678	  // saveSingleLesson must apply with FieldValue.delete() rather than let the
  5679	  // stripping pass silently drop (Data Safety Plan Stage 3, never extended to
  5680	  // this third editor until now).
  5681	  const fieldsToClear = changedFields.filter(f => (baseline[f] || '') !== '' && raw[f] === '');
  5682	  const changedData = {};
  5683	  changedFields.forEach(f => { changedData[f] = raw[f]; });
  5684	
  5685	  const photoInput = document.getElementById('ca-edit-photo-input');
  5686	  const hasNewPhoto = photoInput?.files?.length > 0;
  5687	  let pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
  5688	  // Nothing changed — no write, no re-stamped lastEditedBy/At, no "edit" log
  5689	  // entry for an edit that didn't happen (mirrors saveTeacherEdit()).
  5690	  if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) {
  5691	    closeAdminModal(true);
  5692	    return;
  5693	  }
  5694	
  5695	  // Step 2 — forced-server read of this slot, before any side effect (the
  5696	  // photo upload, the write). Non-summer only: a summer cache entry is a
  5697	  // scaffold regenerated from summerCamps_curriculum whether or not its
  5698	  // summerCamps_lessonData doc exists (a missing doc means "never saved",
  5699	  // not "moved") and this app has no move/swap/cut path for summer lessons,
  5700	  // so there is no ghost to prevent — the first save legitimately creates
  5701	  // the doc. Same routing signal as saveSingleLesson() /
  5702	  // adminLessonStillExistsWithRetry() (key prefix; the camp-seasons plan
  5703	  // unifies this on semesterType). Forced read — a cache-permitting get()
  5704	  // could be served from the live listener's local cache in exactly the race
  5705	  // window this check exists to close. It runs for first-time creation too:
  5706	  // an "empty" slot in this tab's cache may have gained a project (a paste, a
  5707	  // move onto it) that the listener hasn't delivered yet.
  5708	  const isSummerSchema = isCampSeason(semKey);   // Phase 1, 1.1
  5709	  if (!isSummerSchema) {
  5710	    let check;
  5711	    try {
  5712	      check = await adminLessonStillExistsWithRetry(semKey, key);
  5713	    } catch (err) {
  5714	      console.warn('⚠️ Existence check retry also failed:', err);
  5715	      alert("Couldn't confirm this lesson still exists — check your connection and try saving again.");
  5716	      return;
  5717	    }
  5718	    if (caEditLessonExisted && !check.exists) {
  5719	      alert('This lesson was moved or removed elsewhere while you had it open. Your changes were not saved — please close this window and check the grid for its new location.');
  5720	      return;
  5721	    }
  5722	    if (check.exists) {
  5723	      // The key holds a doc — but a swap, a move ONTO this slot, or a paste
  5724	      // into a slot this tab still shows as empty leaves it populated with a
  5725	      // DIFFERENT project. The popup's edits were made against the project it
  5726	      // opened on; applying them to whatever is here now needs an explicit
  5727	      // decision, the same way cutProject() re-confirms when the fresh read
  5728	      // shows the slot's identity changed.
  5729	      const freshTitle = (check.data?.projectTitle || '').trim();
  5730	      if (freshTitle !== (baseline.projectTitle || '')) {
  5731	        const opened = baseline.projectTitle || '(empty slot)';
  5732	        if (!confirm(`This slot has changed since you opened it — it now contains "${freshTitle || '(empty)'}" instead of "${opened}". Save your changes onto "${freshTitle || 'this slot'}" anyway?\n\nCancel keeps your text here and saves nothing.`)) return;
  5733	      }
  5734	      // From here on, work from the FRESH copy, not this tab's cache: the
  5735	      // photo to delete after a replacement, the "remove photo" target, the
  5736	      // identity/scheduling fields resent below, the local cache merge and
  5737	      // the logged title all come from `existing`. On the swap-accept path
  5738	      // the cached copy's photoPath is the OTHER lesson's live photo.
  5739	      existing = check.data;
  5740	      pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
  5741	    }
  5742	  } else if (!existing.campName) {
  5743	    // A summer key that is no longer in the cache (the schedule was rebuilt
  5744	    // between open and save — e.g. the project was renamed in the Summer
  5745	    // Camp App) would produce a doc without its identity trio, which neither
  5746	    // app can find again. Refuse rather than write it.
  5747	    alert('This lesson is no longer in the summer schedule — reload and try again. Nothing was saved.');
  5748	    return;
  5749	  }
  5750	
  5751	  // Summer: projectTitle, shortDetails, inspoLink and materials belong to the
  5752	  // camp curriculum, not to the lesson doc — loadSummerCampData() takes them
  5753	  // from the scaffold and reads back only content/photo/completion fields
  5754	  // (SUMMER_SAVED_FIELDS), so an edit here would "save" and then vanish on the
  5755	  // next reload. projectTitle is worse: it is part of the lesson key, and the
  5756	  // Summer Camp App's orphan check treats a doc whose title isn't in the
  5757	  // camp's curriculum as orphaned content. Refuse them honestly rather than
  5758	  // write them into a doc where they can only mislead.
  5759	  const SUMMER_CURRICULUM_OWNED = ['projectTitle', 'shortDetails', 'inspoLink', 'materials'];
  5760	  if (isSummerSchema) {
  5761	    const refused = SUMMER_CURRICULUM_OWNED.filter(f => f in changedData);
  5762	    if (refused.length > 0) {
  5763	      const labels = { projectTitle: 'project title', shortDetails: 'short details', inspoLink: 'inspo link', materials: 'materials' };
  5764	      alert(`Summer camp ${refused.map(f => labels[f]).join(', ')} are managed in the Summer Camp App — that change is not saved here.` + (changedFields.length > refused.length || hasNewPhoto || pendingRemove ? ' Your other edits will still be saved.' : ''));
  5765	      refused.forEach(f => {
  5766	        delete changedData[f];
  5767	        const idx = changedFields.indexOf(f);
  5768	        if (idx !== -1) changedFields.splice(idx, 1);
  5769	        const cidx = fieldsToClear.indexOf(f);
  5770	        if (cidx !== -1) fieldsToClear.splice(cidx, 1);
  5771	      });
  5772	      if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) { closeAdminModal(true); return; }
  5773	    }
  5774	  }
  5775	
  5776	  // Firestore-bound payload — see the function comment for what's in it and why.
  5777	  const firestorePayload = {
  5778	    teacher, className, weekNum,
  5779	    weekDate: existing.weekDate || '',
  5780	    classSize: existing.classSize || 0,
  5781	    // Summer identity trio, key-derived and idempotent — a doc this save
  5782	    // CREATES must carry them (the Summer Camp App queries this collection by
  5783	    // campName + teacher and checks projectTitle; the summer editor sends the
  5784	    // same trio on every save for the same reason).
  5785	    ...(isSummerSchema ? { campName: existing.campName, block: existing.block, projectTitle: existing.projectTitle } : {}),
  5786	    ...changedData,
  5787	    lastImported: new Date().toISOString()
  5788	  };
  5789	
  5790	  // Backtracking audit, Phase 1 (R4-2): capture the OLD photoPath before any
  5791	  // mutation, so the delete-after-save step compares against the right value.
  5792	  const oldPhotoPath = existing.photoPath || null;
  5793	  let photoUrl = null, photoPath = null;   // null = this save didn't touch the photo
  5794	
  5795	  try {
  5796	    // Handle photo upload/removal
  5797	    if (hasNewPhoto) {
  5798	      const file = photoInput.files[0];
  5799	      if (file.size > 5 * 1024 * 1024) { alert('Photo must be under 5MB.'); return; }
  5800	      const { url, path } = await uploadLessonPhoto(semKey, key, file);
  5801	      // Delete of the OLD photo happens AFTER the save below — not here.
  5802	      photoUrl = url;
  5803	      photoPath = path;
  5804	    } else if (pendingRemove) {
  5805	      photoUrl = '';
  5806	      photoPath = '';
  5807	    }
  5808	    if (photoUrl !== null) {
  5809	      firestorePayload.photoUrl = photoUrl;
  5810	      firestorePayload.photoPath = photoPath;
  5811	    }
  5812	
  5813	    // Targeted single-lesson save with a diff-only payload — never the cached
  5814	    // full lesson, never the whole semester. (The summer branch's "no content"
  5815	    // guard can't refuse a legitimate save from here: for summer every
  5816	    // editable non-content field is curriculum-owned and refused above, so
  5817	    // what remains is content, a clear, or a photo — each admitted.)
  5818	    await saveSingleLesson(semKey, key, firestorePayload, fieldsToClear);
  5819	
  5820	    // Backtracking audit, Phase 1 (R4-2): only delete the OLD object once
  5821	    // Firestore has confirmed the new reference — and only when THIS save
  5822	    // actually replaced or removed the photo (photoUrl !== null). A text-only
  5823	    // edit leaves the old path untouched in both Firestore and Storage.
  5824	    if (photoUrl !== null && oldPhotoPath && oldPhotoPath !== (photoPath || null)) {
  5825	      try {
  5826	        await deleteLessonPhoto(oldPhotoPath);
  5827	      } catch (cleanupErr) {
  5828	        console.error('⚠️ Could not clean up old photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
  5829	      }
  5830	    }
  5831	  } catch (err) {
  5832	    // Backtracking audit, Phase 1 (R2-22): MUST return here — otherwise
  5833	    // execution falls through to commit currentLessonData, close the modal,
  5834	    // and log a fake edit even though the save never actually succeeded. The
  5835	    // snapshot is kept so the still-open popup can retry against it.
  5836	    console.error('❌ Admin edit failed to save:', err);
  5837	    alert('This edit could not be saved. Please try again.');
  5838	    return;
  5839	  }
  5840	
  5841	  // Local display/cache only — never sent to Firestore, so keeping the full
  5842	  // merge here is safe (staleness in untouched fields is cosmetic until the
  5843	  // listener's next delivery, same as the teacher editor).
  5844	  lessons[key] = {
  5845	    ...existing,
  5846	    teacher, className, weekNum,
  5847	    weekDate: firestorePayload.weekDate,
  5848	    classSize: firestorePayload.classSize,
  5849	    ...changedData,
  5850	    lastImported: firestorePayload.lastImported,
  5851	    lastEditedBy: firestorePayload.lastEditedBy,   // stamped by saveSingleLesson()
  5852	    lastEditedAt: firestorePayload.lastEditedAt
  5853	  };
  5854	  if (photoUrl !== null) { lessons[key].photoUrl = photoUrl; lessons[key].photoPath = photoPath; }
  5855	  fieldsToClear.forEach(f => { lessons[key][f] = ''; });
  5856	  currentLessonData[semKey] = lessons;
  5857	
  5858	  closeAdminModal(true);   // the save's own close — also resets the snapshot
  5859	  renderAdminGrid();
  5860	  renderChangeHistory();
  5861	
  5862	  try {
  5863	    // Log the title that was actually kept — for summer a refused retitle
  5864	    // must not show up in Change History under the refused name.
  5865	    const keptTitle = firestorePayload.projectTitle || existing.projectTitle || title;
  5880	
  5881	function cancelGridAction() {
  5882	  caActionMode = null;
  5883	  caSourceKey = null;
  5884	  renderAdminGrid();
  5885	}
  5886	
  5887	// Data Safety Plan Stage 2A/2B: shared helpers for the admin grid's move/swap
  5888	// abort-and-restore paths (see CLASSBOOK-DATA-SAFETY-PLAN.md).
  5889	// lessonHasContent() now lives in firebase-data.js (CONTENT_FIELDS is the
  5890	// single source of truth, Data Safety Plan Stage 4A) — this file just uses it.
  5891	
  5892	// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
  5893	// model. Backtracking audit, Phase 2 (reinstated round 4): adds an optional
  5894	// opts.source === 'server' param, needed by Phase 8's
  5895	// adminLessonStillExistsWithRetry() existence check below — omitting opts
  5896	// preserves the exact prior (cache-permitting) default for any future caller.
  5897	async function readAdminLessonDoc(semKey, lessonKey, opts = {}) {
  5898	  if (!curriculumDb) initCurriculumFirestore();
  5899	  const getOpts = opts.source === 'server' ? { source: 'server' } : undefined;
  5900	  const map = await readWeeklySemesterMap(semKey, getOpts);   // own-doc semesters read their own document
  5901	  return map?.[lessonKey] || null;
  5902	}
  5903	
  5904	// Backtracking audit, Phase 8: shared by cutProject() below and Phase 11's
  5905	// sendHelpResponse()/sendQaReply() (not yet implemented) — forced server
  5906	// read, retried once on failure, then lets a second failure throw so each
  5907	// caller decides how to surface it. Residual TOCTOU race (check-to-write gap)
  5908	// deliberately accepted, matching the companion plan's own decision for this
  5909	// identical helper — bounded by human click-to-click timing, not a tight
  5910	// machine loop; closing it fully would need a Firestore transaction.
  5911	async function adminLessonStillExistsWithRetry(semKey, key) {
  5912	  if (!curriculumDb) initCurriculumFirestore();
  5913	  const isSummer = lessonStoreFor(semKey) === 'camp';   // Phase 1, 1.1 — by type, and a third type throws
  5914	  const readOnce = async () => {
  5915	    if (isSummer) {
  5916	      const snap = await curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key)).get({ source: 'server' });
  5917	      return { exists: snap.exists, data: snap.exists ? snap.data() : null };
  5918	    }
  5919	    const data = await readAdminLessonDoc(semKey, key, { source: 'server' });
  5920	    return { exists: data !== null, data };
  5921	  };
  5922	  try {
  5923	    return await readOnce();
  5924	  } catch (err) {
  5925	    console.warn('⚠️ Existence check read failed, retrying once:', err);
  5926	    return await readOnce(); // a second failure throws — caller's catch handles it
  5927	  }
  5928	}
  5929	
  5930	// Reverts the admin grid's optimistic in-memory update after a move/swap that
  5931	// failed to save or failed verification — puts both slots back to their
  5932	// pre-action state (deleting the dest slot if it didn't exist before) and re-renders.
  5933	function restoreGridActionState(semKey, sourceKey, sourceLesson, destKey, destLesson) {
  5934	  if (!currentLessonData[semKey]) currentLessonData[semKey] = {};
  5935	  currentLessonData[semKey][sourceKey] = sourceLesson;
  5936	  if (destLesson) {
  5937	    currentLessonData[semKey][destKey] = destLesson;
  5938	  } else {
  5939	    delete currentLessonData[semKey][destKey];
  5940	  }
  5941	  renderAdminGrid();
  5942	}
  5943	
  5944	async function handleGridAction(destTeacher, destClassName, destWeekNum, destKey) {
  5945	  const semKey = getAdminSemKey();
  5946	  const lessons = { ...currentLessonData[semKey] };
  5947	  const sourceLesson = lessons[caSourceKey];
  5948	
  5949	  if (!sourceLesson) {
  5950	    cancelGridAction();
  5951	    return;
  5952	  }
  5953	
  5954	  // Prevent moving to same cell
  5955	  if (caSourceKey === destKey) {
  5956	    cancelGridAction();
  5957	    return;
  5958	  }
  5959	
  5960	  const destLesson = lessons[destKey] || null;
  5961	  const newDestKey = makeLessonKey(destTeacher, destClassName, destWeekNum);
  5962	
  5963	  if (caActionMode === 'move') {
  5964	    if (destLesson) {
  5965	      if (!confirm(`Week ${destWeekNum} already has "${destLesson.projectTitle}". This will overwrite it. Continue?`)) {
  5966	        cancelGridAction();
  5967	        return;
  5968	      }
  5969	    }
  5970	    if (!confirm(`Move "${sourceLesson.projectTitle}" from Week ${sourceLesson.weekNum} to ${destTeacher} / ${destClassName} Week ${destWeekNum}?`)) {
  5971	      cancelGridAction();
  5972	      return;
  5973	    }
  5974	
  5975	    // Move: put source content at destination, clear source
  5976	    const movedLesson = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum };
  5977	    movedLesson.weekDate = destLesson?.weekDate || '';
  5978	    // Backtracking audit, Phase 4: a content field non-empty at the existing
  5979	    // destination but empty in the incoming moved lesson must be explicitly
  5980	    // cleared — saveSingleLesson omits empty fields from the write rather
  5981	    // than clearing them, so without this the destination's old content
  5982	    // would silently survive underneath the moved lesson.
  5983	    const destFieldsToClear = CONTENT_FIELDS.filter(f =>
  5984	      (destLesson?.[f] || '').trim() !== '' && !(movedLesson[f] || '').trim()
  5985	    );
  5986	    lessons[newDestKey] = movedLesson;
  5987	    delete lessons[caSourceKey];
  5988	    currentLessonData[semKey] = lessons;
  5989	
  5990	    const sourceKeyToDelete = caSourceKey;
  5991	    const preMoveSourceLesson = sourceLesson;
  5992	    const preMoveDestLesson = destLesson;
  5993	    caActionMode = null;
  5994	    caSourceKey = null;
  5995	    renderAdminGrid();
  5996	    renderChangeHistory();
  5997	
  5998	    // Backtracking audit, Phase 9: the destination write and the source
  5999	    // delete are ONE atomic Firestore call — closes the "first write landed,
  6000	    // second failed" partial-failure race the prior sequential-write design
  6001	    // was vulnerable to. Does NOT independently verify movedLesson reflects
  6002	    // the CURRENT server state (a separate, deliberately deferred stale-input
  6003	    // race — see classbook-shared-document-concurrency-plan.html's 7th
  6004	    // instance) — no read-back needed or performed, since the write is
  6005	    // all-or-nothing.
  6006	    let moveSucceeded = false;
  6007	    try {
  6008	      await saveMultipleLessonFields(
  6009	        semKey,
  6010	        [{ lessonKey: newDestKey, lessonData: movedLesson, fieldsToClear: destFieldsToClear }],
  6011	        [sourceKeyToDelete]
  6012	      );
  6013	      moveSucceeded = true;
  6014	    } catch (err) {
  6015	      console.error('❌ Move failed:', err);
  6016	      restoreGridActionState(semKey, sourceKeyToDelete, preMoveSourceLesson, newDestKey, preMoveDestLesson);
  6017	      alert(`Move could not be saved — "${preMoveSourceLesson.projectTitle}" has been restored to its original slot. Nothing was changed.`);
  6018	      return;
  6019	    }
  6020	
  6021	    if (moveSucceeded) {
  6022	      try {
  6023	        await appendChangeLogEntry(semKey, {
  6024	          action: 'move',
  6025	          details: {
  6026	            projectTitle: sourceLesson.projectTitle,
  6027	            teacher: sourceLesson.teacher,
  6028	            className: sourceLesson.className,
  6029	            fromWeek: sourceLesson.weekNum,
  6030	            toTeacher: destTeacher,
  6031	            toClassName: destClassName,
  6032	            toWeek: destWeekNum
  6033	          }
  6034	        });
  6035	        renderChangeHistory();
  6036	      } catch (logErr) {
  6037	        console.error('⚠️ Move saved, but Change History logging failed:', logErr);
  6038	      }
  6039	    }
  6040	    return;
  6041	
  6042	  } else if (caActionMode === 'swap') {
  6043	    const destLabel = destLesson ? `"${destLesson.projectTitle}"` : 'empty slot';
  6044	    if (!confirm(`Swap "${sourceLesson.projectTitle}" (Week ${sourceLesson.weekNum}) with ${destLabel} (Week ${destWeekNum})?`)) {
  6045	      cancelGridAction();
  6046	      return;
  6047	    }
  6048	
  6049	    // Swap: exchange content between source and dest
  6050	    const sourceWeekNum = sourceLesson.weekNum;
  6051	    const sourceTeacher = sourceLesson.teacher;
  6052	    const sourceClassName = sourceLesson.className;
  6053	    const sourceWeekDate = sourceLesson.weekDate;
  6054	    const sourceKeyForSwap = caSourceKey;
  6055	
  6056	    let savePromise;
  6057	    let swapSucceeded = false;
  6058	    if (destLesson) {
  6059	      const swappedSource = { ...destLesson, teacher: sourceTeacher, className: sourceClassName, weekNum: sourceWeekNum, weekDate: sourceWeekDate };
  6060	      const swappedDest = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum, weekDate: destLesson.weekDate };
  6061	      // Backtracking audit, Phase 4: each slot's clear list compares its OWN
  6062	      // pre-swap content against what's now being written there — NOT the
  6063	      // other slot's pre-swap content, which would be a no-op since that's
  6064	      // identical-by-construction to the incoming value.
  6065	      const sourceFieldsToClear = CONTENT_FIELDS.filter(f =>
  6066	        (sourceLesson[f] || '').trim() !== '' && !(swappedSource[f] || '').trim()
  6067	      );
  6068	      const destFieldsToClearSwap = CONTENT_FIELDS.filter(f =>
  6069	        (destLesson[f] || '').trim() !== '' && !(swappedDest[f] || '').trim()
  6070	      );
  6071	      lessons[sourceKeyForSwap] = swappedSource;
  6072	      lessons[newDestKey] = swappedDest;
  6073	      currentLessonData[semKey] = lessons;
  6074	
  6075	      // Backtracking audit, Phase 9: both slots' writes are now ONE atomic
  6076	      // Firestore call — closes the "first save landed, second failed"
  6077	      // partial-failure race the prior two-sequential-saves design was
  6078	      // vulnerable to.
  6079	      savePromise = (async () => {
  6080	        try {
  6081	          await saveMultipleLessonFields(semKey, [
  6082	            { lessonKey: sourceKeyForSwap, lessonData: swappedSource, fieldsToClear: sourceFieldsToClear },
  6083	            { lessonKey: newDestKey, lessonData: swappedDest, fieldsToClear: destFieldsToClearSwap }
  6084	          ]);
  6085	          swapSucceeded = true;
  6086	        } catch (err) {
  6087	          console.error('❌ Swap failed:', err);
  6088	          restoreGridActionState(semKey, sourceKeyForSwap, sourceLesson, newDestKey, destLesson);
  6089	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" and "${destLesson.projectTitle}" have been restored to their original slots.`);
  6090	        }
  6091	      })();
  6092	    } else {
  6093	      // Swap with empty: move source to dest, clear source. Backtracking
  6094	      // audit, Phase 9: the destination write and source delete are now ONE
  6095	      // atomic Firestore call, same reasoning as the move branch above.
  6096	      const movedLesson = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum, weekDate: '' };
  6097	      lessons[newDestKey] = movedLesson;
  6098	      delete lessons[sourceKeyForSwap];
  6099	      currentLessonData[semKey] = lessons;
  6100	      savePromise = (async () => {
  6101	        try {
  6102	          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
  6103	          swapSucceeded = true;
  6104	        } catch (err) {
  6105	          console.error('❌ Swap failed:', err);
  6106	          restoreGridActionState(semKey, sourceKeyForSwap, sourceLesson, newDestKey, null);
  6107	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" has been restored to its original slot.`);
  6108	        }
  6109	      })();
  6110	    }
  6111	
  6112	    caActionMode = null;
  6113	    caSourceKey = null;
  6114	    renderAdminGrid();
  6115	    renderChangeHistory();
  6116	
  6117	    await savePromise;
  6118	
  6119	    if (swapSucceeded) {
  6120	      try {
  6200	  </div>`;
  6201	
  6202	  body.innerHTML = html;
  6203	}
  6204	
  6205	function toggleCopyAll(masterCb) {
  6206	  document.querySelectorAll('.ca-copy-cb').forEach(cb => { cb.checked = masterCb.checked; });
  6207	}
  6208	
  6209	// Backtracking audit, Phase 11 (R3-12, R3-13). Previously resaved the ENTIRE
  6210	// cached semester via saveLessonData() — any lesson whose local copy was stale
  6211	// (a teacher's concurrent save in another tab) was silently reverted on the
  6212	// server — mutated the shared cache before any write landed, and logged only
  6213	// after one bulk save, so a part-way failure lost the log for targets that
  6214	// had actually been written. Now: one targeted saveSingleLesson() per target
  6215	// with an explicit fieldsToClear (a source field that is EMPTY must clear the
  6216	// target's stale value — the save strips empty content fields, so without the
  6217	// clear the old text would survive under the new plan), cache committed per
  6218	// target only after its save resolves, logged immediately, honest count on
  6219	// failure.
  6220	async function executeCopyPlan(sourceKey) {
  6221	  const semKey = getAdminSemKey();
  6222	  const liveLessons = currentLessonData?.[semKey];
  6223	  const source = liveLessons?.[sourceKey];
  6224	  if (!source) return;
  6225	
  6226	  const checkboxes = document.querySelectorAll('.ca-copy-cb:checked');
  6227	  const targetKeys = Array.from(checkboxes).map(cb => cb.dataset.key);
  6228	
  6229	  if (targetKeys.length === 0) {
  6230	    alert('No targets selected.');
  6231	    return;
  6232	  }
  6233	
  6234	  // Check if any targets have existing plans
  6235	  const overwriteTargets = targetKeys.filter(k => liveLessons[k] && hasLessonContent(liveLessons[k]));
  6236	  if (overwriteTargets.length > 0) {
  6237	    const names = overwriteTargets.map(k => {
  6238	      const l = liveLessons[k];
  6239	      return `${l.teacher} — ${l.className} (Wk ${l.weekNum})`;
  6240	    }).join('\n');
  6241	    if (!confirm(`${overwriteTargets.length} target(s) already have lesson plans that will be overwritten:\n\n${names}\n\nContinue?`)) return;
  6242	  }
  6243	
  6244	  const fields = getCopyableFields(source); // the 7 CONTENT_FIELDS plus `materials`
  6245	  let savedCount = 0;
  6246	  let failure = null;
  6247	
  6248	  try {
  6249	    for (const targetKey of targetKeys) {
  6250	      if (!liveLessons[targetKey]) continue;
  6251	      // Work on copies — the shared cache object is only replaced below,
  6252	      // after this target's own save has resolved (R3-13).
  6253	      const previousTarget = { ...liveLessons[targetKey] };
  6254	      const targetFieldsToClear = CONTENT_FIELDS.filter(f =>
  6255	        (previousTarget[f] || '').trim() !== '' && !(fields[f] || '').trim()
  6256	      );
  6257	      // Send ONLY the copied fields (saveSingleLesson writes per-field paths
  6258	      // and stamps lastEditedBy/At onto this object). Sending the whole
  6259	      // cached target would re-write every non-content field — qaThread,
  6260	      // photoUrl, planComplete… — from this admin's possibly-stale copy over
  6261	      // a teacher's concurrent change (implementation review, Sep 2026).
  6262	      const payload = { ...fields };
  6263	      await saveSingleLesson(semKey, targetKey, payload, targetFieldsToClear);
  6264	      const updatedTarget = { ...previousTarget, ...payload };
  6265	      if (currentLessonData[semKey]) currentLessonData[semKey][targetKey] = updatedTarget;
  6266	      savedCount++;
  6267	      // Uncheck the saved target so, if a later one fails, "retry the rest"
  6268	      // re-runs only the rest (no duplicate copies or Change History entries).
  6269	      const cb = document.querySelector(`.ca-copy-cb[data-key="${CSS.escape(targetKey)}"]`);
  6270	      if (cb) cb.checked = false;
  6271	
  6272	      // Log this copy now — before the next target — so a later failure
  6273	      // can't lose the record of a write that already landed.
  6274	      const logEntry = {
  6275	        action: 'copy',
  6276	        details: {
  6277	          projectTitle: source.projectTitle,
  6278	          fromTeacher: source.teacher,
  6279	          fromClassName: source.className,
  6280	          fromWeek: source.weekNum,
  6281	          toTeacher: updatedTarget.teacher,
  6282	          toClassName: updatedTarget.className,
  6283	          toWeek: updatedTarget.weekNum
  6284	        }
  6285	      };
  6286	      // Capture the overwritten plan whenever ANY copyable field had text —
  6287	      // the clear above is explicit and intentional, so Change History must
  6288	      // hold the recovery record even when the prior content lived only in
  6289	      // processStep2-4/closure/dayOfMaterials (which the looser
  6290	      // hasLessonContent() used for the confirm prompt doesn't look at).
  6291	      const previousPlan = getCopyableFields(previousTarget);
  6292	      if (Object.values(previousPlan).some(v => String(v).trim())) {
  6293	        logEntry.details.previousPlan = previousPlan;
  6294	      }
  6295	      try {
  6296	        await appendChangeLogEntry(semKey, logEntry);
  6297	      } catch (logErr) {
  6298	        // The copy itself is saved; a Change History miss must not read as
  6299	        // a failed copy (same rule as saveTeacherEdit(), Phase 8).
  6300	        console.error('⚠️ Copy saved, but Change History logging failed for', targetKey, logErr);
  6301	      }
  6302	    }
  6303	  } catch (err) {
  6304	    console.error('❌ Copy Plan failed partway through:', err);
  6305	    failure = err;
  6306	  }
  6307	
  6308	  // UI after the try/catch so a render exception can't be misreported as a
  6309	  // failed save (and can't re-throw from inside the catch).
  6310	  renderAdminGrid();
  6311	  renderChangeHistory();
  6312	  if (failure) {
  6313	    alert(`Copied to ${savedCount} of ${targetKeys.length} class(es) before a save failed. Please check which targets actually received the plan before retrying the rest.\n\n${failure.message}`);
  6314	    return;
  6315	  }
  6316	  closeAdminModal();
  6317	  const skipped = targetKeys.length - savedCount;
  6318	  alert(`Plan copied to ${savedCount} class${savedCount !== 1 ? 'es' : ''}${skipped > 0 ? ` (${skipped} skipped)` : ''}.`);
  6319	}
  6320	
  6321	// Backtracking audit, Phase 8: rebuilt around the companion plan's Phase 17
  6322	// design. Forced-server read before archiving or deleting anything (closes
  6323	// two failure modes: the doc no longer existing at all, and the doc existing
  6324	// but having genuinely different content than this admin's stale local
  6325	// snapshot — a teacher's concurrent edit). Archives the COMPLETE fresh
  6326	// lesson object (not a hand-picked field list) via FieldValue.arrayUnion()
  6327	// against curriculum/cutProjects (not saveCutProjects()'s local-splice-then-
  6328	// full-array-overwrite — two admins cutting concurrently now both survive
  6329	// regardless of write order). Archive-before-delete ordering — a failed
  6330	// archive save leaves the live lesson completely untouched.
  6331	async function cutProject(key) {
  6332	  const semKey = getAdminSemKey();
  6333	  const lessons = { ...currentLessonData[semKey] };
  6334	  const lesson = lessons[key];
  6335	  if (!lesson) return;
  6336	
  6337	  if (!confirm(`Cut "${lesson.projectTitle}" from ${lesson.teacher} / ${lesson.className} Week ${lesson.weekNum}? It will be moved to the Cut Projects bank.`)) return;
  6338	
  6339	  let check;
  6340	  try {
  6341	    check = await adminLessonStillExistsWithRetry(semKey, key);
  6342	  } catch (err) {
  6343	    console.error('Could not confirm current state before cutting', key, err);
  6344	    alert(`Could not confirm "${lesson.projectTitle}" still exists — nothing was cut. Check your connection and try again.`);
  6345	    return;
  6346	  }
  6347	  if (!check.exists) {
  6348	    alert(`"${lesson.projectTitle}" no longer exists — it may have been moved, deleted, or already cut by someone else. Nothing was cut.`);
  6349	    if (currentLessonData[semKey]) delete currentLessonData[semKey][key];
  6350	    renderAdminGrid();
  6351	    return;
  6352	  }
  6353	  const freshLesson = check.data;
  6354	
  6355	  // The first confirm() above authorized cutting THIS project, by name — if
  6356	  // the fresh read shows the slot's identity has materially changed since
  6357	  // then, that authorization doesn't cover it.
  6358	  if (freshLesson.projectTitle !== lesson.projectTitle || freshLesson.teacher !== lesson.teacher || freshLesson.className !== lesson.className) {
  6359	    if (!confirm(`This slot has changed since you opened it — it now contains "${freshLesson.projectTitle}" (${freshLesson.teacher} / ${freshLesson.className}). Cut this instead?`)) return;
  6360	  }
  6361	
  6362	  const user = getAuthUser();
  6363	  const archiveEntry = {
  6364	    ...freshLesson,
  6365	    originalTeacher: freshLesson.teacher,
  6366	    originalClassName: freshLesson.className,
  6367	    originalWeek: freshLesson.weekNum,
  6368	    cutDate: new Date().toISOString(),
  6369	    cutBy: user?.name || 'Unknown'
  6370	  };
  6371	
  6372	  if (!curriculumDb) initCurriculumFirestore();
  6373	  try {
  6374	    await curriculumDb.collection('curriculum').doc('cutProjects').set({
  6375	      [semKey]: firebase.firestore.FieldValue.arrayUnion(archiveEntry)
  6376	    }, { merge: true });
  6377	  } catch (e) {
  6378	    console.error('Could not save Cut Bank entry for', key, e);
  6379	    alert(`Could not cut "${freshLesson.projectTitle}" — the Cut Bank entry could not be saved. Nothing was changed.`);
  6380	    return;
  6381	  }
  6382	
  6383	  let deleteFailed = false;
  6384	  try {
  6385	    await deleteLessonKey(semKey, key);
  6386	  } catch (e) {
  6387	    console.error('Could not delete lesson after archiving', key, e);
  6388	    deleteFailed = true;
  6389	  }
  6390	
  6391	  // Local cache/grid only drops the lesson when the delete actually
  6392	  // succeeded — a failed delete leaves the grid showing the lesson as gone
  6393	  // while Firestore still has it live otherwise.
  6394	  if (!deleteFailed) {
  6395	    delete lessons[key];
  6396	    currentLessonData[semKey] = lessons;
  6397	  }
  6398	  if (!currentCutProjects) currentCutProjects = {};
  6399	  currentCutProjects[semKey] = [...(currentCutProjects[semKey] || []), archiveEntry];
  6400	
  6401	  try {
  6402	    await appendChangeLogEntry(semKey, {
  6403	      action: 'cut',
  6404	      details: { projectTitle: freshLesson.projectTitle, teacher: freshLesson.teacher, className: freshLesson.className, fromWeek: freshLesson.weekNum }
  6405	    });

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '5700,5865p;5880,5945p;6370,6445p;6500,6595p;6960,7060p;11460,11555p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
  5700	  // so there is no ghost to prevent — the first save legitimately creates
  5701	  // the doc. Same routing signal as saveSingleLesson() /
  5702	  // adminLessonStillExistsWithRetry() (key prefix; the camp-seasons plan
  5703	  // unifies this on semesterType). Forced read — a cache-permitting get()
  5704	  // could be served from the live listener's local cache in exactly the race
  5705	  // window this check exists to close. It runs for first-time creation too:
  5706	  // an "empty" slot in this tab's cache may have gained a project (a paste, a
  5707	  // move onto it) that the listener hasn't delivered yet.
  5708	  const isSummerSchema = isCampSeason(semKey);   // Phase 1, 1.1
  5709	  if (!isSummerSchema) {
  5710	    let check;
  5711	    try {
  5712	      check = await adminLessonStillExistsWithRetry(semKey, key);
  5713	    } catch (err) {
  5714	      console.warn('⚠️ Existence check retry also failed:', err);
  5715	      alert("Couldn't confirm this lesson still exists — check your connection and try saving again.");
  5716	      return;
  5717	    }
  5718	    if (caEditLessonExisted && !check.exists) {
  5719	      alert('This lesson was moved or removed elsewhere while you had it open. Your changes were not saved — please close this window and check the grid for its new location.');
  5720	      return;
  5721	    }
  5722	    if (check.exists) {
  5723	      // The key holds a doc — but a swap, a move ONTO this slot, or a paste
  5724	      // into a slot this tab still shows as empty leaves it populated with a
  5725	      // DIFFERENT project. The popup's edits were made against the project it
  5726	      // opened on; applying them to whatever is here now needs an explicit
  5727	      // decision, the same way cutProject() re-confirms when the fresh read
  5728	      // shows the slot's identity changed.
  5729	      const freshTitle = (check.data?.projectTitle || '').trim();
  5730	      if (freshTitle !== (baseline.projectTitle || '')) {
  5731	        const opened = baseline.projectTitle || '(empty slot)';
  5732	        if (!confirm(`This slot has changed since you opened it — it now contains "${freshTitle || '(empty)'}" instead of "${opened}". Save your changes onto "${freshTitle || 'this slot'}" anyway?\n\nCancel keeps your text here and saves nothing.`)) return;
  5733	      }
  5734	      // From here on, work from the FRESH copy, not this tab's cache: the
  5735	      // photo to delete after a replacement, the "remove photo" target, the
  5736	      // identity/scheduling fields resent below, the local cache merge and
  5737	      // the logged title all come from `existing`. On the swap-accept path
  5738	      // the cached copy's photoPath is the OTHER lesson's live photo.
  5739	      existing = check.data;
  5740	      pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
  5741	    }
  5742	  } else if (!existing.campName) {
  5743	    // A summer key that is no longer in the cache (the schedule was rebuilt
  5744	    // between open and save — e.g. the project was renamed in the Summer
  5745	    // Camp App) would produce a doc without its identity trio, which neither
  5746	    // app can find again. Refuse rather than write it.
  5747	    alert('This lesson is no longer in the summer schedule — reload and try again. Nothing was saved.');
  5748	    return;
  5749	  }
  5750	
  5751	  // Summer: projectTitle, shortDetails, inspoLink and materials belong to the
  5752	  // camp curriculum, not to the lesson doc — loadSummerCampData() takes them
  5753	  // from the scaffold and reads back only content/photo/completion fields
  5754	  // (SUMMER_SAVED_FIELDS), so an edit here would "save" and then vanish on the
  5755	  // next reload. projectTitle is worse: it is part of the lesson key, and the
  5756	  // Summer Camp App's orphan check treats a doc whose title isn't in the
  5757	  // camp's curriculum as orphaned content. Refuse them honestly rather than
  5758	  // write them into a doc where they can only mislead.
  5759	  const SUMMER_CURRICULUM_OWNED = ['projectTitle', 'shortDetails', 'inspoLink', 'materials'];
  5760	  if (isSummerSchema) {
  5761	    const refused = SUMMER_CURRICULUM_OWNED.filter(f => f in changedData);
  5762	    if (refused.length > 0) {
  5763	      const labels = { projectTitle: 'project title', shortDetails: 'short details', inspoLink: 'inspo link', materials: 'materials' };
  5764	      alert(`Summer camp ${refused.map(f => labels[f]).join(', ')} are managed in the Summer Camp App — that change is not saved here.` + (changedFields.length > refused.length || hasNewPhoto || pendingRemove ? ' Your other edits will still be saved.' : ''));
  5765	      refused.forEach(f => {
  5766	        delete changedData[f];
  5767	        const idx = changedFields.indexOf(f);
  5768	        if (idx !== -1) changedFields.splice(idx, 1);
  5769	        const cidx = fieldsToClear.indexOf(f);
  5770	        if (cidx !== -1) fieldsToClear.splice(cidx, 1);
  5771	      });
  5772	      if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) { closeAdminModal(true); return; }
  5773	    }
  5774	  }
  5775	
  5776	  // Firestore-bound payload — see the function comment for what's in it and why.
  5777	  const firestorePayload = {
  5778	    teacher, className, weekNum,
  5779	    weekDate: existing.weekDate || '',
  5780	    classSize: existing.classSize || 0,
  5781	    // Summer identity trio, key-derived and idempotent — a doc this save
  5782	    // CREATES must carry them (the Summer Camp App queries this collection by
  5783	    // campName + teacher and checks projectTitle; the summer editor sends the
  5784	    // same trio on every save for the same reason).
  5785	    ...(isSummerSchema ? { campName: existing.campName, block: existing.block, projectTitle: existing.projectTitle } : {}),
  5786	    ...changedData,
  5787	    lastImported: new Date().toISOString()
  5788	  };
  5789	
  5790	  // Backtracking audit, Phase 1 (R4-2): capture the OLD photoPath before any
  5791	  // mutation, so the delete-after-save step compares against the right value.
  5792	  const oldPhotoPath = existing.photoPath || null;
  5793	  let photoUrl = null, photoPath = null;   // null = this save didn't touch the photo
  5794	
  5795	  try {
  5796	    // Handle photo upload/removal
  5797	    if (hasNewPhoto) {
  5798	      const file = photoInput.files[0];
  5799	      if (file.size > 5 * 1024 * 1024) { alert('Photo must be under 5MB.'); return; }
  5800	      const { url, path } = await uploadLessonPhoto(semKey, key, file);
  5801	      // Delete of the OLD photo happens AFTER the save below — not here.
  5802	      photoUrl = url;
  5803	      photoPath = path;
  5804	    } else if (pendingRemove) {
  5805	      photoUrl = '';
  5806	      photoPath = '';
  5807	    }
  5808	    if (photoUrl !== null) {
  5809	      firestorePayload.photoUrl = photoUrl;
  5810	      firestorePayload.photoPath = photoPath;
  5811	    }
  5812	
  5813	    // Targeted single-lesson save with a diff-only payload — never the cached
  5814	    // full lesson, never the whole semester. (The summer branch's "no content"
  5815	    // guard can't refuse a legitimate save from here: for summer every
  5816	    // editable non-content field is curriculum-owned and refused above, so
  5817	    // what remains is content, a clear, or a photo — each admitted.)
  5818	    await saveSingleLesson(semKey, key, firestorePayload, fieldsToClear);
  5819	
  5820	    // Backtracking audit, Phase 1 (R4-2): only delete the OLD object once
  5821	    // Firestore has confirmed the new reference — and only when THIS save
  5822	    // actually replaced or removed the photo (photoUrl !== null). A text-only
  5823	    // edit leaves the old path untouched in both Firestore and Storage.
  5824	    if (photoUrl !== null && oldPhotoPath && oldPhotoPath !== (photoPath || null)) {
  5825	      try {
  5826	        await deleteLessonPhoto(oldPhotoPath);
  5827	      } catch (cleanupErr) {
  5828	        console.error('⚠️ Could not clean up old photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
  5829	      }
  5830	    }
  5831	  } catch (err) {
  5832	    // Backtracking audit, Phase 1 (R2-22): MUST return here — otherwise
  5833	    // execution falls through to commit currentLessonData, close the modal,
  5834	    // and log a fake edit even though the save never actually succeeded. The
  5835	    // snapshot is kept so the still-open popup can retry against it.
  5836	    console.error('❌ Admin edit failed to save:', err);
  5837	    alert('This edit could not be saved. Please try again.');
  5838	    return;
  5839	  }
  5840	
  5841	  // Local display/cache only — never sent to Firestore, so keeping the full
  5842	  // merge here is safe (staleness in untouched fields is cosmetic until the
  5843	  // listener's next delivery, same as the teacher editor).
  5844	  lessons[key] = {
  5845	    ...existing,
  5846	    teacher, className, weekNum,
  5847	    weekDate: firestorePayload.weekDate,
  5848	    classSize: firestorePayload.classSize,
  5849	    ...changedData,
  5850	    lastImported: firestorePayload.lastImported,
  5851	    lastEditedBy: firestorePayload.lastEditedBy,   // stamped by saveSingleLesson()
  5852	    lastEditedAt: firestorePayload.lastEditedAt
  5853	  };
  5854	  if (photoUrl !== null) { lessons[key].photoUrl = photoUrl; lessons[key].photoPath = photoPath; }
  5855	  fieldsToClear.forEach(f => { lessons[key][f] = ''; });
  5856	  currentLessonData[semKey] = lessons;
  5857	
  5858	  closeAdminModal(true);   // the save's own close — also resets the snapshot
  5859	  renderAdminGrid();
  5860	  renderChangeHistory();
  5861	
  5862	  try {
  5863	    // Log the title that was actually kept — for summer a refused retitle
  5864	    // must not show up in Change History under the refused name.
  5865	    const keptTitle = firestorePayload.projectTitle || existing.projectTitle || title;
  5880	
  5881	function cancelGridAction() {
  5882	  caActionMode = null;
  5883	  caSourceKey = null;
  5884	  renderAdminGrid();
  5885	}
  5886	
  5887	// Data Safety Plan Stage 2A/2B: shared helpers for the admin grid's move/swap
  5888	// abort-and-restore paths (see CLASSBOOK-DATA-SAFETY-PLAN.md).
  5889	// lessonHasContent() now lives in firebase-data.js (CONTENT_FIELDS is the
  5890	// single source of truth, Data Safety Plan Stage 4A) — this file just uses it.
  5891	
  5892	// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
  5893	// model. Backtracking audit, Phase 2 (reinstated round 4): adds an optional
  5894	// opts.source === 'server' param, needed by Phase 8's
  5895	// adminLessonStillExistsWithRetry() existence check below — omitting opts
  5896	// preserves the exact prior (cache-permitting) default for any future caller.
  5897	async function readAdminLessonDoc(semKey, lessonKey, opts = {}) {
  5898	  if (!curriculumDb) initCurriculumFirestore();
  5899	  const getOpts = opts.source === 'server' ? { source: 'server' } : undefined;
  5900	  const map = await readWeeklySemesterMap(semKey, getOpts);   // own-doc semesters read their own document
  5901	  return map?.[lessonKey] || null;
  5902	}
  5903	
  5904	// Backtracking audit, Phase 8: shared by cutProject() below and Phase 11's
  5905	// sendHelpResponse()/sendQaReply() (not yet implemented) — forced server
  5906	// read, retried once on failure, then lets a second failure throw so each
  5907	// caller decides how to surface it. Residual TOCTOU race (check-to-write gap)
  5908	// deliberately accepted, matching the companion plan's own decision for this
  5909	// identical helper — bounded by human click-to-click timing, not a tight
  5910	// machine loop; closing it fully would need a Firestore transaction.
  5911	async function adminLessonStillExistsWithRetry(semKey, key) {
  5912	  if (!curriculumDb) initCurriculumFirestore();
  5913	  const isSummer = lessonStoreFor(semKey) === 'camp';   // Phase 1, 1.1 — by type, and a third type throws
  5914	  const readOnce = async () => {
  5915	    if (isSummer) {
  5916	      const snap = await curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key)).get({ source: 'server' });
  5917	      return { exists: snap.exists, data: snap.exists ? snap.data() : null };
  5918	    }
  5919	    const data = await readAdminLessonDoc(semKey, key, { source: 'server' });
  5920	    return { exists: data !== null, data };
  5921	  };
  5922	  try {
  5923	    return await readOnce();
  5924	  } catch (err) {
  5925	    console.warn('⚠️ Existence check read failed, retrying once:', err);
  5926	    return await readOnce(); // a second failure throws — caller's catch handles it
  5927	  }
  5928	}
  5929	
  5930	// Reverts the admin grid's optimistic in-memory update after a move/swap that
  5931	// failed to save or failed verification — puts both slots back to their
  5932	// pre-action state (deleting the dest slot if it didn't exist before) and re-renders.
  5933	function restoreGridActionState(semKey, sourceKey, sourceLesson, destKey, destLesson) {
  5934	  if (!currentLessonData[semKey]) currentLessonData[semKey] = {};
  5935	  currentLessonData[semKey][sourceKey] = sourceLesson;
  5936	  if (destLesson) {
  5937	    currentLessonData[semKey][destKey] = destLesson;
  5938	  } else {
  5939	    delete currentLessonData[semKey][destKey];
  5940	  }
  5941	  renderAdminGrid();
  5942	}
  5943	
  5944	async function handleGridAction(destTeacher, destClassName, destWeekNum, destKey) {
  5945	  const semKey = getAdminSemKey();
  6370	  };
  6371	
  6372	  if (!curriculumDb) initCurriculumFirestore();
  6373	  try {
  6374	    await curriculumDb.collection('curriculum').doc('cutProjects').set({
  6375	      [semKey]: firebase.firestore.FieldValue.arrayUnion(archiveEntry)
  6376	    }, { merge: true });
  6377	  } catch (e) {
  6378	    console.error('Could not save Cut Bank entry for', key, e);
  6379	    alert(`Could not cut "${freshLesson.projectTitle}" — the Cut Bank entry could not be saved. Nothing was changed.`);
  6380	    return;
  6381	  }
  6382	
  6383	  let deleteFailed = false;
  6384	  try {
  6385	    await deleteLessonKey(semKey, key);
  6386	  } catch (e) {
  6387	    console.error('Could not delete lesson after archiving', key, e);
  6388	    deleteFailed = true;
  6389	  }
  6390	
  6391	  // Local cache/grid only drops the lesson when the delete actually
  6392	  // succeeded — a failed delete leaves the grid showing the lesson as gone
  6393	  // while Firestore still has it live otherwise.
  6394	  if (!deleteFailed) {
  6395	    delete lessons[key];
  6396	    currentLessonData[semKey] = lessons;
  6397	  }
  6398	  if (!currentCutProjects) currentCutProjects = {};
  6399	  currentCutProjects[semKey] = [...(currentCutProjects[semKey] || []), archiveEntry];
  6400	
  6401	  try {
  6402	    await appendChangeLogEntry(semKey, {
  6403	      action: 'cut',
  6404	      details: { projectTitle: freshLesson.projectTitle, teacher: freshLesson.teacher, className: freshLesson.className, fromWeek: freshLesson.weekNum }
  6405	    });
  6406	    renderChangeHistory();
  6407	  } catch (logErr) {
  6408	    console.error('⚠️ Cut saved, but Change History logging failed:', logErr);
  6409	  }
  6410	
  6411	  closeAdminModal();
  6412	  renderAdminGrid();
  6413	  renderCutBank();
  6414	  renderChangeHistory();
  6415	
  6416	  if (deleteFailed) {
  6417	    alert(`"${freshLesson.projectTitle}" was safely archived to the Cut Bank, but could NOT be removed from the grid. Please reload and check — it may now appear in both places.`);
  6418	  }
  6419	}
  6420	
  6421	async function showPasteFromCutBank(teacher, className, weekNum) {
  6422	  const semKey = getAdminSemKey();
  6423	  const cutProjects = currentCutProjects?.[semKey] || [];
  6424	
  6425	  // Gather cut projects from other semesters
  6426	  const otherSemesters = [];
  6427	  for (const [key, projects] of Object.entries(currentCutProjects || {})) {
  6428	    if (key === semKey || key === 'lastUpdated' || key === 'lastUpdatedBy') continue;
  6429	    if (projects && Array.isArray(projects) && projects.length > 0) {
  6430	      const semName = currentConfig?.semesters?.[key]?.name || key;
  6431	      otherSemesters.push({ key, name: semName, projects });
  6432	    }
  6433	  }
  6434	
  6435	  const totalCuts = cutProjects.length + otherSemesters.reduce((sum, s) => sum + s.projects.length, 0);
  6436	  if (totalCuts === 0) {
  6437	    alert('No cut projects available in any semester. Cut a project first.');
  6438	    return;
  6439	  }
  6440	
  6441	  const body = document.getElementById('ca-modal-body');
  6442	  let html = `<h4 class="ca-paste-title">Paste from Cut Bank</h4>
  6443	    <p class="ca-paste-hint">Select a project to place in ${escHtml(teacher)} / ${escHtml(className)} Week ${weekNum}:</p>`;
  6444	
  6445	  // Current semester's cut projects
  6500	  const isCrossSemester = srcSemKey !== destSemKey;
  6501	  const srcSemName = currentConfig?.semesters?.[srcSemKey]?.name || srcSemKey;
  6502	  const confirmMsg = isCrossSemester
  6503	    ? `Paste "${proj.projectTitle}" from ${srcSemName} into ${teacher} / ${className} Week ${weekNum}?`
  6504	    : `Paste "${proj.projectTitle}" into ${teacher} / ${className} Week ${weekNum}?`;
  6505	  if (!confirm(confirmMsg)) return;
  6506	
  6507	  const key = makeLessonKey(teacher, className, weekNum);
  6508	  const lessons = { ...(currentLessonData?.[destSemKey] || {}) };
  6509	  const existingDest = lessons[key] || {};
  6510	  const existingDestClassSize = existingDest.classSize || 0;
  6511	  const existingDestPhotoPath = existingDest.photoPath || null;
  6512	
  6513	  lessons[key] = {
  6514	    teacher, className, weekNum, weekDate: '', classSize: existingDestClassSize,
  6515	    projectTitle: proj.projectTitle,
  6516	    shortDetails: proj.shortDetails || '',
  6517	    inspoLink: proj.inspoLink || '',
  6518	    introPitch: proj.introPitch || '',
  6519	    processStep1: proj.processStep1 || '', processStep2: proj.processStep2 || '',
  6520	    processStep3: proj.processStep3 || '', processStep4: proj.processStep4 || '',
  6521	    closure: proj.closure || '',
  6522	    materials: proj.materials || '',
  6523	    materialsList: proj.materialsList || [],
  6524	    dayOfMaterials: proj.dayOfMaterials || '',
  6525	    publishToPrep: proj.publishToPrep || '',
  6526	    lastImported: new Date().toISOString()
  6527	    // Deliberately NOT restored: qaThread, photoUrl/photoPath, planComplete
  6528	    // (tied to the ORIGINAL lesson instance, not reusable project content),
  6529	    // and teacherNotes/adminResponse/status (round-6: getQaThread() would
  6530	    // silently reconstruct the original Q&A conversation from these alone).
  6531	  };
  6532	  // Merely OMITTING those fields above only means "don't touch them" — if the
  6533	  // DESTINATION slot already had its own stale qaThread/photo/planComplete
  6534	  // from whatever occupied it before, that would otherwise survive untouched
  6535	  // and resurrect an unrelated Q&A thread under the newly-pasted content.
  6536	  // Explicitly clear them so a paste genuinely starts fresh.
  6537	  const NON_CONTENT_FIELDS_TO_CLEAR = ['qaThread', 'photoUrl', 'photoPath', 'planComplete', 'teacherNotes', 'adminResponse', 'status'];
  6538	
  6539	  let pasteConfirmed = false;
  6540	  try {
  6541	    await saveSingleLesson(destSemKey, key, lessons[key], NON_CONTENT_FIELDS_TO_CLEAR);
  6542	    pasteConfirmed = true;
  6543	  } catch (err) {
  6544	    console.error('❌ Paste from Cut Bank failed to save the lesson:', err);
  6545	    alert(`Could not paste "${proj.projectTitle}" — please try again.`);
  6546	    return;
  6547	  }
  6548	
  6549	  // Only delete the destination's old photo from Storage after Firestore has
  6550	  // confirmed the clear — same safe ordering as saveAdminEdit()/saveTeacherEdit().
  6551	  if (existingDestPhotoPath) {
  6552	    try {
  6553	      await deleteLessonPhoto(existingDestPhotoPath);
  6554	    } catch (cleanupErr) {
  6555	      console.error('⚠️ Could not clean up destination\'s old photo after paste (Firestore is correct, Storage has an orphan):', cleanupErr);
  6556	    }
  6557	  }
  6558	
  6559	  currentLessonData[destSemKey] = lessons;
  6560	  closeAdminModal();
  6561	  renderAdminGrid();
  6562	
  6563	  if (!curriculumDb) initCurriculumFirestore();
  6564	  try {
  6565	    await curriculumDb.collection('curriculum').doc('cutProjects').set({
  6566	      [srcSemKey]: firebase.firestore.FieldValue.arrayRemove(proj)
  6567	    }, { merge: true });
  6568	    if (currentCutProjects?.[srcSemKey]) {
  6569	      currentCutProjects[srcSemKey] = currentCutProjects[srcSemKey].filter(p => p !== proj);
  6570	    }
  6571	    renderCutBank();
  6572	  } catch (err) {
  6573	    console.error('❌ Lesson saved, but failed to persist Cut Bank removal:', err);
  6574	    alert('The lesson saved successfully, but this project could not be removed from the Cut Bank — it may still appear there. Reload to check.');
  6575	  }
  6576	
  6577	  try {
  6578	    await appendChangeLogEntry(destSemKey, {
  6579	      action: 'paste',
  6580	      details: {
  6581	        projectTitle: proj.projectTitle, teacher, className, toWeek: weekNum, fromCutBank: true,
  6582	        crossSemester: isCrossSemester || undefined,
  6583	        sourceSemester: isCrossSemester ? srcSemName : undefined,
  6584	        originalTeacher: proj.originalTeacher, originalWeek: proj.originalWeek
  6585	      }
  6586	    });
  6587	    renderChangeHistory();
  6588	  } catch (logErr) {
  6589	    console.error('⚠️ Paste saved, but Change History logging failed:', logErr);
  6590	  }
  6591	}
  6592	
  6593	// ─── Cut Projects Bank ───────────────────────────────
  6594	
  6595	function renderCutBank() {
  6960	// pasteFromCutBank()'s own NON_CONTENT_FIELDS_TO_CLEAR pattern, since simply
  6961	// omitting a field only means "don't touch it," not "clear it") — and
  6962	// lesson-save-then-idea-removal ordering with an honest duplicate-message on
  6963	// a removal failure.
  6964	async function pasteFromIdeaBank(idx, teacher, className, weekNum) {
  6965	  const projects = currentFutureProjects?.projects || [];
  6966	  const proj = projects[idx];
  6967	  if (!proj) return;
  6968	
  6969	  if (!confirm(`Paste "${proj.title}" into ${teacher} / ${className} Week ${weekNum}? The idea will be removed from the bank.`)) return;
  6970	
  6971	  const semKey = getAdminSemKey();
  6972	  const key = makeLessonKey(teacher, className, weekNum);
  6973	  const existingLesson = currentLessonData?.[semKey]?.[key] || {};
  6974	  const existingClassSize = existingLesson.classSize || 0;
  6975	  const existingPhotoPath = existingLesson.photoPath || null;
  6976	  const newLesson = {
  6977	    teacher,
  6978	    className,
  6979	    weekNum,
  6980	    weekDate: '',
  6981	    classSize: existingClassSize,
  6982	    projectTitle: proj.title,
  6983	    shortDetails: proj.description || '',
  6984	    inspoLink: proj.inspoLink || '',
  6985	    introPitch: '',
  6986	    processStep1: '',
  6987	    processStep2: '',
  6988	    processStep3: '',
  6989	    processStep4: '',
  6990	    closure: '',
  6991	    materials: '',
  6992	    dayOfMaterials: '',
  6993	    status: '',
  6994	    publishToPrep: '',
  6995	    teacherNotes: '',
  6996	    adminResponse: '',
  6997	    lastImported: new Date().toISOString()
  6998	  };
  6999	
  7000	  // An idea's blank fields must actually CLEAR stale destination content, not
  7001	  // silently leave it — same pattern used everywhere else in this plan.
  7002	  const fieldsToClear = CONTENT_FIELDS.filter(f =>
  7003	    (existingLesson[f] || '').trim() !== '' && !(newLesson[f] || '').trim()
  7004	  );
  7005	  // Instance-specific fields tied to whatever previously occupied this slot —
  7006	  // an Idea Bank project never supplies these, so newLesson never sets them,
  7007	  // and buildLessonFieldUpdates() only touches fields actually present in the
  7008	  // object it's given. Without an explicit clear, a destination's own stale
  7009	  // Q&A thread, photo, completion flag, or materials list would silently
  7010	  // resurrect under the newly-pasted idea.
  7011	  const NON_CONTENT_FIELDS_TO_CLEAR = ['qaThread', 'photoUrl', 'photoPath', 'planComplete', 'materialsList'];
  7012	
  7013	  try {
  7014	    await saveSingleLesson(semKey, key, newLesson, [...fieldsToClear, ...NON_CONTENT_FIELDS_TO_CLEAR]);
  7015	    if (currentLessonData[semKey]) currentLessonData[semKey][key] = newLesson;
  7016	  } catch (err) {
  7017	    console.error('❌ Paste from Idea Bank failed — lesson could not be saved:', err);
  7018	    alert(`Could not paste "${proj.title}" — please try again. The idea is still in the bank.`);
  7019	    return;
  7020	  }
  7021	
  7022	  // Only delete the destination's old photo from Storage after Firestore has
  7023	  // confirmed the clear — same safe ordering as pasteFromCutBank()/
  7024	  // saveAdminEdit()/saveTeacherEdit().
  7025	  if (existingPhotoPath) {
  7026	    try {
  7027	      await deleteLessonPhoto(existingPhotoPath);
  7028	    } catch (cleanupErr) {
  7029	      console.error('⚠️ Could not clean up destination\'s old photo after paste (Firestore is correct, Storage has an orphan):', cleanupErr);
  7030	    }
  7031	  }
  7032	
  7033	  // NOT closed here: this is still a plain saveFutureProjects() .set(), the
  7034	  // same shared last-write-wins primitive as the Idea Bank's other five
  7035	  // writers (classbook-shared-document-concurrency-plan.html, instance 1) —
  7036	  // a concurrent-paste-where-one-fails edge case can leave the local cache
  7037	  // disagreeing with a successful server-side removal until reload (no
  7038	  // server-side data loss). The real fix is converting removal to an atomic
  7039	  // FieldValue.arrayRemove() across all six writers together, tracked there;
  7040	  // out of scope for this single-function live-bug fix.
  7041	  try {
  7042	    // Re-resolve the idea's current position by identity rather than trusting
  7043	    // the idx captured above — a second paste invoked while this one was
  7044	    // still awaiting the lesson save could have already spliced the array,
  7045	    // shifting indices out from under this call.
  7046	    const currentIdx = projects.indexOf(proj);
  7047	    if (currentIdx === -1) throw new Error('Idea no longer in the bank — already removed by a concurrent paste.');
  7048	    projects.splice(currentIdx, 1);
  7049	    await saveFutureProjects(projects);
  7050	  } catch (err) {
  7051	    if (!projects.includes(proj)) projects.push(proj);
  7052	    console.error('❌ Paste from Idea Bank — lesson saved but idea removal failed:', err);
  7053	    alert(`"${proj.title}" was placed on the grid, but could NOT be removed from the Idea Bank — it may now appear in both places. Please reload and check.`);
  7054	    closeAdminModal();
  7055	    renderAdminGrid();
  7056	    renderIdeaBank();
  7057	    renderChangeHistory();
  7058	    return;
  7059	  }
  7060	
 11460	    alert('Error saving settings: ' + err.message);
 11461	  }
 11462	}
 11463	
 11464	// Backtracking audit, Phase 11 (R4-9, R4-12). Called unconditionally by
 11465	// saveSettings() after every Settings save. No try/catch here on purpose —
 11466	// the caller's own catch already reports "Error saving settings" correctly;
 11467	// a catch here produced a false "Settings saved!" (round-3 finding).
 11468	async function createLessonSlotsForRoster(semKey, roster, numWeeks) {
 11469	  // Skip if no roster or no weeks configured
 11470	  if (!roster || !numWeeks || Object.keys(roster).length === 0) {
 11471	    return;
 11472	  }
 11473	
 11474	  // R4-9: the correct signal is semesterType, not a key-prefix guess — an
 11475	  // ordinary roster semester named "Summer Enrichment 2027" is not a camp,
 11476	  // and the real summer-2026 camp semester MUST be skipped: its lesson
 11477	  // content is keyed teacher|||campTopic|||blockName|||projectTitle and
 11478	  // regenerated by loadSummerCampData() from the camp source collections,
 11479	  // entirely unrelated to classRoster. Without this gate, a Settings save
 11480	  // while viewing summer-2026 built garbage teacher-className-weekNum slots
 11481	  // into the live summer cache and then re-saved EVERY real summer lesson
 11482	  // (~600) from this admin's in-memory copy — re-stamping them all and
 11483	  // risking Firestore's 500-op batch limit. Nothing safe to do here for a camp.
 11484	  if (!isWeeklySemester(semKey)) return;   // Phase 1, 1.1 — only weekly semesters have a class roster; a third type is skipped by construction
 11485	
 11486	  if (!currentLessonData) await loadLessonData();
 11487	
 11488	  // R4-12: work on a copy and commit it to the live cache only after
 11489	  // persistence succeeds — previously `currentLessonData[semKey] = {}` was
 11490	  // assigned up front, so a failed save left a phantom empty semester key
 11491	  // in the cache even though nothing had been written.
 11492	  const lessons = { ...(currentLessonData[semKey] || {}) };
 11493	  let createdCount = 0;
 11494	
 11495	  // For each class in roster that has a teacher assigned
 11496	  for (const [className, data] of Object.entries(roster)) {
 11497	    if (!data.teacher || !className) continue;  // Skip if no teacher or no class name
 11498	
 11499	    const teacher = data.teacher;
 11500	
 11501	    // Check if lesson slots exist for this teacher-class combination
 11502	    for (let weekNum = 1; weekNum <= numWeeks; weekNum++) {
 11503	      const lessonKey = makeLessonKey(teacher, className, weekNum);
 11504	
 11505	      // If lesson doesn't exist, create it
 11506	      if (!lessons[lessonKey]) {
 11507	        lessons[lessonKey] = {
 11508	          teacher: teacher,
 11509	          className: className,
 11510	          weekNum: weekNum,
 11511	          weekDate: '',
 11512	          projectTitle: '',
 11513	          introPitch: '',
 11514	          processStep1: '',
 11515	          processStep2: '',
 11516	          processStep3: '',
 11517	          processStep4: '',
 11518	          closure: '',
 11519	          materials: '',
 11520	          materialsList: [],
 11521	          dayOfMaterials: '',
 11522	          qaThread: [],
 11523	          planComplete: false,
 11524	          classSize: String(data.enrollment || 0),
 11525	          lastEditedBy: '',
 11526	          lastEditedAt: ''
 11527	        };
 11528	        createdCount++;
 11529	      }
 11530	    }
 11531	  }
 11532	
 11533	  if (createdCount > 0) {
 11534	    await saveLessonData(semKey, lessons);
 11535	    currentLessonData[semKey] = lessons; // only commit locally after Firestore confirms
 11536	    console.log(`✅ Created ${createdCount} lesson slots for roster classes`);
 11537	  }
 11538	}
 11539	
 11540	function makeLessonKey(teacher, className, weekNum) {
 11541	  const t = (teacher || '').toLowerCase().replace(/[^a-z0-9]/g, '');
 11542	  const c = (className || '').toLowerCase().replace(/[^a-z0-9]/g, '');
 11543	  const w = String(weekNum).trim();
 11544	  return `${t}-${c}-${w}`;
 11545	}
 11546	
 11547	// Rename a teacher across all lessons in a semester (re-keys affected lessons)
 11548	
 11549	// ─── Summer Camp Import ──────────────────────────────
 11550	
 11551	
 11552	
 11553	// ═══════════════════════════════════════════════════════
 11554	// SUMMER CAMP - MODAL AND PRINT FUNCTIONS
 11555	// ═══════════════════════════════════════════════════════

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '11280,11470p' && nl -ba index.html | sed -n '330,380p' && nl -ba e2e/spring-own-doc.spec.js | sed -n '1,260p' && nl -ba e2e/helpers/storage-move.js | sed -n '1,120p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
 11280	    const selects = document.querySelectorAll('.teacher-mapping-select');
 11281	    selects.forEach(select => {
 11282	      const teacherName = select.dataset.teacher;
 11283	      const currentMapping = Object.entries(currentConfig?.teacherMappings || {}).find(([, n]) => n === teacherName)?.[0] || '';
 11284	      for (const u of users.filter(x => x.canUse || x.uid === currentMapping)) {
 11285	        const opt = document.createElement('option');
 11286	        opt.value = u.uid;
 11287	        opt.textContent = `${u.name} (${u.email})${u.note}`;
 11288	        if (u.uid === currentMapping) opt.selected = true;
 11289	        select.appendChild(opt);
 11290	      }
 11291	      if (currentMapping && !users.some(u => u.uid === currentMapping)) {   // mapped to an account that no longer exists
 11292	        const opt = document.createElement('option');
 11293	        opt.value = currentMapping;
 11294	        opt.textContent = 'Unknown account (removed)';
 11295	        opt.selected = true;
 11296	        select.appendChild(opt);
 11297	      }
 11298	    });
 11299	  } catch (err) {
 11300	    console.error('Error loading users for mapping:', err);
 11301	  }
 11302	}
 11303	
 11304	function getUserLabelByUid(uid) {
 11305	  // Best effort — will be populated by dropdown
 11306	  return uid.substring(0, 8) + '...';
 11307	}
 11308	
 11309	function clearTeacherMapping(teacherName) {
 11310	  const mappings = { ...(currentConfig?.teacherMappings || {}) };
 11311	  // Find and remove UID mapped to this teacher
 11312	  for (const [uid, name] of Object.entries(mappings)) {
 11313	    if (name === teacherName) delete mappings[uid];
 11314	  }
 11315	  currentConfig.teacherMappings = mappings;
 11316	  renderTeacherMappingTable();
 11317	}
 11318	
 11319	function getTeacherMappingsFromForm() {
 11320	  const mappings = {};
 11321	  const selects = document.querySelectorAll('.teacher-mapping-select');
 11322	  selects.forEach(select => {
 11323	    const uid = select.value;
 11324	    const teacherName = select.dataset.teacher;
 11325	    if (uid && teacherName) {
 11326	      mappings[uid] = teacherName;
 11327	    }
 11328	  });
 11329	  return mappings;
 11330	}
 11331	
 11332	async function saveSettings() {
 11333	  const el = (id) => document.getElementById(id)?.value?.trim() || '';
 11334	  // Last line of defence: never write a form drawn for one semester onto another.
 11335	  if (settingsFormSemKey !== getSettingsSemKey()) {
 11336	    loadSettingsForm();
 11337	    alert('This form was showing a different semester from the one selected at the top, so nothing was saved. It now shows the selected semester — check it and save again.');
 11338	    return;
 11339	  }
 11340	
 11341	  const breakWeeksStr = el('settings-break-weeks');
 11342	  const breakWeeks = breakWeeksStr.split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n));
 11343	  const closureDates = parseClosureDates(el('settings-closure-dates'));
 11344	
 11345	  const semKey = getSettingsSemKey();
 11346	  const classRoster = getClassRosterFromForm();
 11347	  const teacherNames = getTeacherNamesFromForm();
 11348	
 11349	  const teacherMappings = getTeacherMappingsFromForm();
 11350	
 11351	  // Merge into existing config to preserve other semesters
 11352	  const config = JSON.parse(JSON.stringify(currentConfig || {}));
 11353	  config.activeSemester = config.activeSemester || semKey;
 11354	
 11355	  // Safety guard: if the form returned no mappings but existing mappings exist,
 11356	  // the user dropdowns likely hadn't finished loading when Save was clicked.
 11357	  // Preserve existing mappings to prevent accidental wipeout.
 11358	  const existingMappings = currentConfig?.teacherMappings || {};
 11359	  config.teacherMappings = Object.keys(teacherMappings).length > 0
 11360	    ? teacherMappings
 11361	    : existingMappings;
 11362	  if (!config.semesters) config.semesters = {};
 11363	  // Only the fields this semester's TYPE owns (Phase 1, 1.2). Spreading the
 11364	  // whole form is what could put numWeeks: 16, an empty breakWeeks and the
 11365	  // hidden default class roster onto a camp season.
 11366	  // An SDOC year: its own date fields, and two guards before anything is
 11367	  // written — a name a camp still uses can't leave the pool, and the year
 11368	  // can't shrink past an existing event's date (forced-server reads).
 11369	  const isDayOff = isDayOffYear(semKey);
 11370	  if (isDayOff) {
 11371	    const start = el('settings-dayoff-start');
 11372	    const end = el('settings-end-date');
 11373	    if (!isIsoDate(start) || !isIsoDate(end) || end <= start) { alert('The school year needs a start date and an end date after it.'); return; }
 11374	    if (!el('settings-semester-name')) { alert('The school year needs a name.'); return; }
 11375	    try {
 11376	      // The SERVER's pool, not this tab's: the × button edits
 11377	      // currentConfig's list before Save runs, and another tab may have added
 11378	      // a name (and put it on a camp) since this form loaded (review HIGH).
 11379	      const serverPool = (await readAppDataFromServer())?.semesters?.[semKey]?.teacherNames || [];
 11380	      const loadedPool = settingsTeacherPoolAtLoad.semKey === semKey ? settingsTeacherPoolAtLoad.names : [];
 11381	      const removed = [...new Set([...serverPool, ...loadedPool])].filter(n => !teacherNames.includes(n));
 11382	      const inUse = await dayOffTeachersInUse(semKey, removed);
 11383	      if (inUse.length) {
 11384	        // Put just those names back in this tab's list (other unsaved edits in
 11385	        // the form stay as they are).
 11386	        currentConfig.semesters[semKey].teacherNames = [...teacherNames, ...inUse.map(u => u.name).filter(n => !teacherNames.includes(n))];
 11387	        renderTeacherNamesList();
 11388	        alert(`Can't remove ${inUse.map(u => `${u.name} (on ${u.camps.join(', ')})`).join('; ')} — take them off those camps first.\n\nNothing was saved.`);
 11389	        return;
 11390	      }
 11391	      const outside = await dayOffDatesOutside(semKey, start, end);
 11392	      if (outside.length) {
 11393	        alert(`These day-off dates would fall outside the school year: ${outside.map(o => `${o.label} ${o.date}`).join(', ')}. Edit those events first.\n\nNothing was saved.`);
 11394	        return;
 11395	      }
 11396	    } catch (err) {
 11397	      alert(`Could not check the school year's camps and events: ${err.message}\n\nNothing was saved.`);
 11398	      return;
 11399	    }
 11400	  }
 11401	  const settingsPaths = settingsFieldPathsFor(semKey, {
 11402	    endDate: isDayOff ? el('settings-end-date') : undefined,
 11403	    name: el('settings-semester-name'),
 11404	    startDate: isDayOff ? el('settings-dayoff-start') : el('settings-start-date'),
 11405	    numWeeks: parseInt(el('settings-num-weeks')) || 16,
 11406	    breakWeeks,
 11407	    closureDates,
 11408	    teacherNames,
 11409	    classRoster,
 11410	  });
 11411	  // Keep this tab's copy in step with exactly what is being written.
 11412	  config.semesters[semKey] = { ...(config.semesters[semKey] || {}) };
 11413	  for (const [path, value] of Object.entries(settingsPaths)) {
 11414	    config.semesters[semKey][path.split('.').pop()] = value;
 11415	  }
 11416	
 11417	  // The two NON-semester fields this form also owns (Phase 1, 1.2). Dropping
 11418	  // them was a real regression: teacher mappings are collected by this form
 11419	  // and would have been silently lost on every Save.
 11420	  const extraPaths = {};
 11421	  // teacherMappings keeps its preserve-on-empty guard — an empty form must not
 11422	  // wipe existing mappings.
 11423	  if (Object.keys(teacherMappings).length > 0) extraPaths.teacherMappings = teacherMappings;
 11424	  // activeSemester is only ever SET when missing, never re-pointed from here.
 11425	  if (!currentConfig?.activeSemester) extraPaths.activeSemester = semKey;
 11426	
 11427	  try {
 11428	    await updateAppData({ ...settingsPaths, ...extraPaths });
 11429	    // Keep this tab's config in step with exactly what was written. Before
 11430	    // Phase 1 saveConfig() ended with `currentConfig = config`; dropping that
 11431	    // left the clone's semester edits stranded, so loadSettingsForm() redrew
 11432	    // pre-save values and the NEXT Save wrote them back over the server —
 11433	    // silently, with "Settings saved!" both times. currentConfig has no live
 11434	    // listener (setupConfigListener() is never called), so nothing else would
 11435	    // have corrected it.
 11436	    currentConfig.semesters = currentConfig.semesters || {};
 11437	    currentConfig.semesters[semKey] = currentConfig.semesters[semKey] || {};
 11438	    for (const [path, value] of Object.entries(settingsPaths)) {
 11439	      currentConfig.semesters[semKey][path.split('.').pop()] = value;
 11440	    }
 11441	    if (extraPaths.teacherMappings) currentConfig.teacherMappings = extraPaths.teacherMappings;
 11442	    if (extraPaths.activeSemester) currentConfig.activeSemester = extraPaths.activeSemester;
 11443	
 11444	    // Create lesson slots for classes assigned to teachers
 11445	    await createLessonSlotsForRoster(semKey, classRoster, config.semesters[semKey].numWeeks);
 11446	
 11447	    alert('Settings saved!');
 11448	
 11449	    // Reload Settings form to show updated teacher names in dropdowns
 11450	    loadSettingsForm();
 11451	
 11452	    // Reload other tabs if active
 11453	    const activeTab = document.querySelector('.tab-btn.active')?.dataset.tab;
 11454	    if (activeTab === 'prep-dashboard') {
 11455	      const weekNum = document.getElementById('week-select')?.value || 1;
 11456	      loadWeekData(parseInt(weekNum));
 11457	    }
 11458	  } catch (err) {
 11459	    console.error('Error saving settings:', err);
 11460	    alert('Error saving settings: ' + err.message);
 11461	  }
 11462	}
 11463	
 11464	// Backtracking audit, Phase 11 (R4-9, R4-12). Called unconditionally by
 11465	// saveSettings() after every Settings save. No try/catch here on purpose —
 11466	// the caller's own catch already reports "Error saving settings" correctly;
 11467	// a catch here produced a false "Settings saved!" (round-3 finding).
 11468	async function createLessonSlotsForRoster(semKey, roster, numWeeks) {
 11469	  // Skip if no roster or no weeks configured
 11470	  if (!roster || !numWeeks || Object.keys(roster).length === 0) {
   330	          <span class="ca-badge ca-ideabank-badge" id="ca-ideabank-badge" style="display:none">0</span>
   331	          <span class="ca-toggle-arrow">&#9660;</span>
   332	        </button>
   333	        <div class="ca-section-content" id="ca-ideabank-content" style="display:none"></div>
   334	      </section>
   335	
   336	      <!-- Change History -->
   337	      <section class="ca-section ca-history-section">
   338	        <button class="ca-section-toggle" id="ca-history-toggle" onclick="toggleChangeHistory()">
   339	          <span>Change History</span>
   340	          <span class="ca-toggle-arrow">&#9660;</span>
   341	        </button>
   342	        <div class="ca-section-content" id="ca-history-content" style="display:none"></div>
   343	      </section>
   344	
   345	      <!-- Content Count by Teacher (Data Safety Plan Stage 4A) -->
   346	      <section class="ca-section ca-content-count-section">
   347	        <button class="ca-section-toggle" id="ca-content-count-toggle" onclick="toggleContentCount()">
   348	          <span>Content Count by Teacher</span>
   349	          <span class="ca-toggle-arrow">&#9660;</span>
   350	        </button>
   351	        <div class="ca-section-content" id="ca-content-count-content" style="display:none"></div>
   352	      </section>
   353	
   354	      <!-- Lesson storage headroom (Spring 2026 storage move, Phase B) -->
   355	      <section class="ca-section ca-lesson-storage-section">
   356	        <button class="ca-section-toggle" id="ca-lesson-storage-toggle" onclick="toggleLessonStorage()">
   357	          <span>Lesson Storage</span>
   358	          <span class="ca-toggle-arrow">&#9660;</span>
   359	        </button>
   360	        <div class="ca-section-content" id="ca-lesson-storage-content" style="display:none"></div>
   361	      </section>
   362	
   363	      <!-- Backup Health (Data Safety Plan Stage 4B) -->
   364	      <section class="ca-section ca-backup-health-section">
   365	        <button class="ca-section-toggle" id="ca-backup-health-toggle" onclick="toggleBackupHealth()">
   366	          <span>Backup Health</span>
   367	          <span class="ca-toggle-arrow">&#9660;</span>
   368	        </button>
   369	        <div class="ca-section-content" id="ca-backup-health-content" style="display:none"></div>
   370	      </section>
   371	    </main>
   372	  </div>
   373	
   374	  <!-- Curriculum Admin Detail Modal -->
   375	  <div id="ca-detail-modal" class="simple-modal-overlay">
   376	    <div class="simple-modal simple-modal-lg">
   377	      <div class="simple-modal-header">
   378	        <h3 id="ca-modal-title">Lesson Details</h3>
   379	        <button class="simple-modal-close" id="ca-modal-close">&times;</button>
   380	      </div>
     1	/**
     2	 * Spring 2026 storage move — Phase B: the Classbook reads and writes Spring from
     3	 * curriculum/lessons_spring-2026 once it exists, and never blanks it in between.
     4	 * Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase B).
     5	 *
     6	 * EMULATOR ONLY, against the deployed Phase A rules (studio-hub 0caf415): Spring's
     7	 * key in lessonData is fenced, the own doc is editable only once
     8	 * storageMigrations.spring-2026.verified is true. States are staged with the
     9	 * emulator-only admin helper (e2e/helpers/storage-move.js) because a verified move
    10	 * can't be undone from a client, and every test starts from — and the file ends
    11	 * at — the seeded state.
    12	 */
    13	const fs = require('fs');
    14	const path = require('path');
    15	const { test, expect } = require('@playwright/test');
    16	const { login } = require('./helpers/login');
    17	const SM = require('./helpers/storage-move');
    18	
    19	const LESSON = 'fixtureteacher-fixtureclass-1';
    20	const PAUSED = /editing it is paused/;
    21	
    22	test.describe.configure({ mode: 'serial' });
    23	test.beforeEach(async () => { await SM.resetStorageMove(); });
    24	test.afterAll(async () => { await SM.resetStorageMove(); });
    25	
    26	async function openApp(page) {
    27	  await login(page);
    28	  await page.waitForFunction(() => lessonDataLoadedSuccessfully === true
    29	    && currentLessonData && currentLessonData['spring-2026']
    30	    && Object.keys(currentLessonData['spring-2026']).length > 0, null, { timeout: 25_000 });
    31	}
    32	const springKeys = (page) => page.evaluate(() => Object.keys(currentLessonData?.['spring-2026'] || {}).filter(k => !k.startsWith('last')).sort());
    33	const source = (page) => page.evaluate(() => ownDocSource['spring-2026']);
    34	const call = (page, fnSrc, arg) => page.evaluate(async ({ fnSrc, arg }) => {
    35	  try { await (0, eval)(`(${fnSrc})`)(arg); return 'ok'; } catch (e) { return e.message; }
    36	}, { fnSrc: fnSrc.toString(), arg });
    37	// Records the smallest Spring lesson count seen, every 25 ms, from now on.
    38	const watchMinSpring = (page) => page.evaluate(() => {
    39	  window.__minSpring = Infinity;
    40	  window.__springWatch = setInterval(() => {
    41	    const n = Object.keys(currentLessonData?.['spring-2026'] || {}).length;
    42	    if (n < window.__minSpring) window.__minSpring = n;
    43	  }, 25);
    44	});
    45	const minSpring = (page) => page.evaluate(() => { clearInterval(window.__springWatch); return window.__minSpring; });
    46	
    47	const fixtureKeys = () => Object.keys(SM.springFixture()).sort();
    48	
    49	test.describe('Spring 2026 storage move — Phase B', () => {
    50	
    51	  test('before the move: Spring is viewable, every Spring write is paused, other semesters save', async ({ page }) => {
    52	    await openApp(page);
    53	    expect(await source(page)).toBe('legacy');
    54	    expect(await springKeys(page)).toEqual(fixtureKeys());
    55	
    56	    expect(await call(page, ({ LESSON }) => saveSingleLesson('spring-2026', LESSON, { shortDetails: 'E2E' }), { LESSON })).toMatch(PAUSED);
    57	    expect(await call(page, ({ LESSON }) => saveMultipleLessonFields('spring-2026', [{ lessonKey: LESSON, lessonData: { shortDetails: 'E2E' } }]), { LESSON })).toMatch(PAUSED);
    58	    expect(await call(page, ({ LESSON }) => deleteLessonKey('spring-2026', LESSON), { LESSON })).toMatch(PAUSED);
    59	    expect(await call(page, () => saveLessonData('spring-2026', {}))).toMatch(PAUSED);
    60	
    61	    const ld = await SM.readCurriculumDoc('lessonData');
    62	    expect(ld['spring-2026']).toEqual(SM.springFixture());
    63	
    64	    // Another weekly semester still saves to lessonData, exactly as before.
    65	    expect(await call(page, () => saveSingleLesson('e2e-other-semester', 'e2e-lesson', { shortDetails: 'Other' }))).toBe('ok');
    66	    expect((await SM.readCurriculumDoc('lessonData'))['e2e-other-semester']['e2e-lesson'].shortDetails).toBe('Other');
    67	  });
    68	
    69	  test('moved but not yet verified: Spring shows from its own doc; edits are still paused', async ({ page }) => {
    70	    await SM.stageMoved({ verified: false });
    71	    await openApp(page);
    72	    expect(await source(page)).toBe('ownDoc');
    73	    expect(await springKeys(page)).toEqual(fixtureKeys());
    74	    expect(await call(page, ({ LESSON }) => saveSingleLesson('spring-2026', LESSON, { shortDetails: 'E2E' }), { LESSON })).toMatch(PAUSED);
    75	    expect((await SM.readCurriculumDoc(SM.SPRING_DOC))[LESSON]).toEqual(SM.springFixture()[LESSON]);
    76	  });
    77	
    78	  test('moved and verified: every Spring write lands in its own doc at lessonKey paths; lessonData untouched', async ({ page }) => {
    79	    await SM.stageMoved({ verified: true });
    80	    await openApp(page);
    81	    await page.waitForFunction(() => storageMigrationState?.['spring-2026']?.verified === true);
    82	    const before = await SM.readCurriculumDoc('lessonData');
    83	
    84	    expect(await call(page, ({ LESSON }) => saveSingleLesson('spring-2026', LESSON, { shortDetails: 'Saved to own doc' }), { LESSON })).toBe('ok');
    85	    expect(await call(page, ({ LESSON }) => saveMultipleLessonFields('spring-2026', [{ lessonKey: LESSON, lessonData: { processStep1: 'Step' } }]), { LESSON })).toBe('ok');
    86	    const own = await SM.readCurriculumDoc(SM.SPRING_DOC);
    87	    expect(own[LESSON].shortDetails).toBe('Saved to own doc');
    88	    expect(own[LESSON].processStep1).toBe('Step');
    89	    expect(own[LESSON].teacher).toBe(SM.springFixture()[LESSON].teacher);   // a per-field write, not a replace
    90	
    91	    const readBack = await page.evaluate(({ LESSON }) => readAdminLessonDoc('spring-2026', LESSON, { source: 'server' }), { LESSON });
    92	    expect(readBack.shortDetails).toBe('Saved to own doc');
    93	
    94	    const other = fixtureKeys().find(k => k !== LESSON);
    95	    expect(await call(page, ({ other }) => deleteLessonKey('spring-2026', other), { other })).toBe('ok');
    96	    expect((await SM.readCurriculumDoc(SM.SPRING_DOC))[other]).toBeUndefined();
    97	
    98	    const after = await SM.readCurriculumDoc('lessonData');
    99	    expect(after['spring-2026']).toBeUndefined();
   100	    expect(after).toEqual(before);
   101	  });
   102	
   103	  test('the move happening while a tab is open: Spring switches to its own doc and is never blank', async ({ page }) => {
   104	    await openApp(page);
   105	    expect(await source(page)).toBe('legacy');
   106	    await watchMinSpring(page);
   107	    await SM.stageMoved({ verified: true });
   108	    await page.waitForFunction(() => ownDocSource['spring-2026'] === 'ownDoc', null, { timeout: 15_000 });
   109	    await page.waitForTimeout(500);
   110	    expect(await minSpring(page)).toBe(fixtureKeys().length);
   111	    expect(await springKeys(page)).toEqual(fixtureKeys());
   112	    expect(await page.locator('#storage-notice-banner:not(.hidden)').count()).toBe(0);
   113	  });
   114	
   115	  test('a later lessonData snapshot (another semester saved) does not blank Spring', async ({ page }) => {
   116	    await SM.stageMoved({ verified: true });
   117	    await openApp(page);
   118	    await watchMinSpring(page);
   119	    await SM.writeCurriculumDoc('lessonData', { 'e2e-bump': { x: { teacher: 'T' } } }, { merge: true });
   120	    await page.waitForFunction(() => !!currentLessonData?.['e2e-bump'], null, { timeout: 15_000 });
   121	    await page.waitForTimeout(300);
   122	    expect(await minSpring(page)).toBe(fixtureKeys().length);
   123	    expect(await springKeys(page)).toEqual(fixtureKeys());
   124	  });
   125	
   126	  test('a rollback (own doc removed, Spring back in lessonData) falls back without blanking', async ({ page }) => {
   127	    await SM.stageMoved({ verified: false });
   128	    await openApp(page);
   129	    expect(await source(page)).toBe('ownDoc');
   130	    await watchMinSpring(page);
   131	    await SM.writeCurriculumDoc('lessonData', { 'spring-2026': SM.springFixture() }, { merge: true });
   132	    await SM.deleteCurriculumDoc(SM.SPRING_DOC);
   133	    await page.waitForFunction(() => ownDocSource['spring-2026'] === 'legacy', null, { timeout: 15_000 });
   134	    await page.waitForTimeout(500);
   135	    expect(await minSpring(page)).toBe(fixtureKeys().length);
   136	    expect(await springKeys(page)).toEqual(fixtureKeys());
   137	  });
   138	
   139	  test('deleting Spring 2026 is refused while its storage is changing', async ({ page }) => {
   140	    await openApp(page);
   141	    const alerts = [];
   142	    page.on('dialog', d => { alerts.push(d.message()); d.dismiss(); });
   143	    const before = await SM.readCurriculumDoc('appData');
   144	    await page.evaluate(() => deleteSemester('spring-2026'));
   145	    expect(alerts.join('\n')).toMatch(/can't be deleted while its storage is being changed/);
   146	    expect((await SM.readCurriculumDoc('appData')).semesters['spring-2026']).toEqual(before.semesters['spring-2026']);
   147	  });
   148	
   149	  test('content counts: one source per semester — the same before and after the move', async ({ page }) => {
   150	    await openApp(page);
   151	    const legacyCounts = await page.evaluate(() => computeLiveContentCountByTeacher());
   152	    await SM.stageMoved({ verified: true });
   153	    const movedCounts = await page.evaluate(() => computeLiveContentCountByTeacher());
   154	    expect(movedCounts).toEqual(legacyCounts);
   155	  });
   156	
   157	  test('Lesson Storage readout shows an approximate size of 1,024 KB', async ({ page }) => {
   158	    await openApp(page);
   159	    await page.evaluate(() => { document.getElementById('ca-lesson-storage-content').style.display = 'none'; toggleLessonStorage(); });
   160	    await expect(page.locator('#ca-lesson-storage-content')).toContainText(/approx\. \d+ KB of 1,024 KB \(\d+%\)/);
   161	    await expect(page.locator('#ca-lesson-storage-content')).toContainText('spring-2026: still in the shared document');
   162	    const kb = await page.evaluate(() => approxLessonDataSizeKB());
   163	    expect(kb).toBeGreaterThan(0);
   164	    expect(kb).toBeLessThan(1024);
   165	  });
   166	
   167	  test('ratchet: every curriculum/lessonData access is in an allowed function; every weekly writer routes through weeklyLessonTarget', () => {
   168	    const html = fs.readFileSync(path.join(__dirname, '..', 'index.html'), 'utf8');
   169	    const scripts = [...html.matchAll(/<script[^>]+src="(js\/[^"]+)"/g)].map(m => m[1]);
   170	    const ALLOWED = new Set([
   171	      'weeklyLessonTarget',          // the routing helper itself (legacy branch)
   172	      'readWeeklySemesterMap',       // reads, routed
   173	      'loadLessonData',              // the legacy load
   174	      'saveLessonData',              // legacy branch; own-doc semesters route above it
   175	      'deleteLessonData',            // refuses own-doc semesters first
   176	      'setupLessonDataListener',     // the legacy listener
   177	      'computeLiveContentCountByTeacher', // counts, one source per semester
   178	    ]);
   179	    const offenders = [];
   180	    const bodies = {};
   181	    for (const file of scripts) {
   182	      const lines = fs.readFileSync(path.join(__dirname, '..', file), 'utf8').split('\n');
   183	      let current = null;
   184	      lines.forEach((line, i) => {
   185	        const m = line.match(/^(?:async\s+)?function\s+([A-Za-z0-9_$]+)\s*\(/);
   186	        if (m) current = m[1];
   187	        if (current) bodies[current] = (bodies[current] || '') + line + '\n';
   188	        if (/doc\(\s*['"]lessonData['"]\s*\)/.test(line) && !ALLOWED.has(current)) offenders.push(`${file}:${i + 1} in ${current}`);
   189	      });
   190	    }
   191	    expect(offenders, `curriculum/lessonData touched outside the allowed functions:\n${offenders.join('\n')}`).toEqual([]);
   192	    for (const fn of ['saveSingleLesson', 'saveMultipleLessonFields', 'deleteLessonKey', 'sendTeacherQaMessage', 'sendHelpResponse', 'sendQaReply']) {
   193	      expect(bodies[fn], `${fn} not found`).toBeTruthy();
   194	      expect(bodies[fn], `${fn} must route through weeklyLessonTarget`).toMatch(/weeklyLessonTarget\(/);
   195	    }
   196	    expect(bodies.saveLessonData).toMatch(/isOwnDocSemester\(semesterKey\)[\s\S]*weeklyLessonTarget\(/);
   197	    expect(bodies.deleteLessonData).toMatch(/isOwnDocSemester\(semesterKey\)/);
   198	  });
   199	});
     1	/**
     2	 * EMULATOR-ONLY state staging for the Spring 2026 storage move specs.
     3	 *
     4	 * The Phase A rules deliberately make a verified move impossible to undo from any
     5	 * client (no delete of lessons_spring-2026, verified is one-way), so these specs
     6	 * reset curriculum/lessonData, curriculum/lessons_spring-2026 and
     7	 * curriculum/storageMigrations with firebase-admin — exactly as
     8	 * e2e/emulators/seed.js does: it refuses to initialise unless the emulator env
     9	 * vars point at loopback, the project is a demo- id, and it never reads a
    10	 * credential file.
    11	 */
    12	const { PROJECT_ID, requireEmulatorEnv } = require('../emulators/config');
    13	const { loadFixtures } = require('../emulators/seed');
    14	
    15	const SPRING = 'spring-2026';
    16	const SPRING_DOC = 'lessons_spring-2026';
    17	
    18	let db = null;
    19	function adminDb() {
    20	  if (db) return db;
    21	  requireEmulatorEnv('storage-move helper');
    22	  if (!PROJECT_ID.startsWith('demo-')) throw new Error(`[storage-move] PROJECT_ID must be a demo- project (got ${PROJECT_ID})`);
    23	  const admin = require('firebase-admin');
    24	  const app = admin.apps.find(a => a && a.name === 'storage-move') || admin.initializeApp({ projectId: PROJECT_ID }, 'storage-move');
    25	  db = app.firestore();
    26	  return db;
    27	}
    28	
    29	const fixtureLessonData = () => JSON.parse(JSON.stringify(loadFixtures().curriculum.lessonData));
    30	const springFixture = () => fixtureLessonData()[SPRING];
    31	
    32	// Back to the seeded state: Spring inside lessonData, no own doc, no record.
    33	async function resetStorageMove() {
    34	  const d = adminDb();
    35	  await d.collection('curriculum').doc('lessonData').set(fixtureLessonData());
    36	  await d.collection('curriculum').doc(SPRING_DOC).delete();
    37	  await d.collection('curriculum').doc('storageMigrations').delete();
    38	}
    39	
    40	// As if the Phase C transaction ran: Spring in its own doc, gone from lessonData.
    41	async function stageMoved({ verified }) {
    42	  const d = adminDb();
    43	  const lessonData = fixtureLessonData();
    44	  const spring = lessonData[SPRING];
    45	  delete lessonData[SPRING];
    46	  await d.collection('curriculum').doc('lessonData').set(lessonData);
    47	  await d.collection('curriculum').doc(SPRING_DOC).set({ ...spring, lastUpdated: 'staged', lastUpdatedBy: 'e2e' });
    48	  await d.collection('curriculum').doc('storageMigrations').set({ [SPRING]: { verified, lessonCount: Object.keys(spring).length, sha256: 'staged' } });
    49	}
    50	
    51	async function readCurriculumDoc(docId) {
    52	  const snap = await adminDb().collection('curriculum').doc(docId).get();
    53	  return snap.exists ? snap.data() : null;
    54	}
    55	async function writeCurriculumDoc(docId, data, { merge = false } = {}) {
    56	  await adminDb().collection('curriculum').doc(docId).set(data, { merge });
    57	}
    58	async function deleteCurriculumDoc(docId) {
    59	  await adminDb().collection('curriculum').doc(docId).delete();
    60	}
    61	
    62	module.exports = { SPRING, SPRING_DOC, springFixture, resetStorageMove, stageMoved, readCurriculumDoc, writeCurriculumDoc, deleteCurriculumDoc };

exec
/bin/zsh -lc "sed -n '1,360p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-studiohub.diff" in /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc
 succeeded in 0ms:
diff --git a/classbook-qa-alerts.test.js b/classbook-qa-alerts.test.js
new file mode 100644
index 0000000..85413a1
--- /dev/null
+++ b/classbook-qa-alerts.test.js
@@ -0,0 +1,57 @@
+/**
+ * Pure-function tests for js/classbook-qa-alerts.js — no Firestore, no DOM.
+ * Run: npm test
+ */
+const { buildClassbookQaAlerts } = require('./js/classbook-qa-alerts.js');
+
+const NOW = Date.parse('2026-09-30T12:00:00Z');
+const asked = (hoursAgo, extra = {}) => ({
+  teacher: 'Mariah', className: 'Clay', weekNum: 3,
+  qaThread: [{ from: 'teacher', message: 'Glaze?', timestamp: new Date(NOW - hoursAgo * 3600e3).toISOString() }],
+  ...extra,
+});
+const answered = () => ({ teacher: 'Kathy', qaThread: [{ from: 'teacher', message: 'Q' }, { from: 'admin', message: 'A' }] });
+
+describe('buildClassbookQaAlerts', () => {
+  test('one alert per unanswered question, id qualified by semester, legacy id kept', () => {
+    const out = buildClassbookQaAlerts({ lessonData: { 'fall-2026': { 'mariah-tue-1': asked(2), 'kathy-mon-1': answered() }, lastUpdated: 'x' }, ownDocs: {} }, NOW);
+    expect(out.map(a => a.id)).toEqual(['classbook-qa-fall-2026-mariah-tue-1']);
+    expect(out[0].legacyId).toBe('classbook-qa-mariah-tue-1');
+    expect(out[0].metadata).toEqual({ lessonKey: 'mariah-tue-1', semKey: 'fall-2026' });
+    expect(out[0].priority).toBe('info');
+  });
+
+  test('the same lesson key in two semesters gives two alerts (no collision)', () => {
+    const out = buildClassbookQaAlerts({
+      lessonData: { 'fall-2026': { 'k-1': asked(1) } },
+      ownDocs: { 'spring-2026': { 'k-1': asked(30), lastUpdated: 'x' } },
+    }, NOW);
+    expect(out.map(a => a.id).sort()).toEqual(['classbook-qa-fall-2026-k-1', 'classbook-qa-spring-2026-k-1']);
+    expect(out.find(a => a.metadata.semKey === 'spring-2026').priority).toBe('warning');
+  });
+
+  test('a semester with its own document is taken from there, never also from lessonData', () => {
+    const out = buildClassbookQaAlerts({
+      lessonData: { 'spring-2026': { 'stale-1': asked(1) }, 'fall-2026': {} },
+      ownDocs: { 'spring-2026': { 'fresh-1': asked(60), lastUpdatedBy: 'x' } },
+    }, NOW);
+    expect(out.map(a => a.id)).toEqual(['classbook-qa-spring-2026-fresh-1']);
+    expect(out[0].priority).toBe('urgent');
+  });
+
+  test('before the move (own doc absent) Spring comes from lessonData', () => {
+    const out = buildClassbookQaAlerts({ lessonData: { 'spring-2026': { 's-1': asked(1) } }, ownDocs: { 'spring-2026': null } }, NOW);
+    expect(out.map(a => a.id)).toEqual(['classbook-qa-spring-2026-s-1']);
+  });
+
+  test('either source missing yields the other alone; malformed entries are skipped', () => {
+    expect(buildClassbookQaAlerts({ lessonData: null, ownDocs: { 'spring-2026': { a: asked(1) } } }, NOW)).toHaveLength(1);
+    expect(buildClassbookQaAlerts({ lessonData: { x: 'not a map', y: { bad: null, empty: { qaThread: [] } } }, ownDocs: {} }, NOW)).toEqual([]);
+  });
+
+  test('unknown timestamp → warning', () => {
+    const out = buildClassbookQaAlerts({ lessonData: { f: { k: { qaThread: [{ from: 'teacher', message: 'Q' }] } } }, ownDocs: {} }, NOW);
+    expect(out[0].priority).toBe('warning');
+    expect(out[0].subtitle).toMatch(/Unknown time/);
+  });
+});
diff --git a/index.html b/index.html
index 567518f..71bcccb 100644
--- a/index.html
+++ b/index.html
@@ -221,6 +221,7 @@
 
   <!-- Scripts -->
   <script src="js/config.js"></script>
+  <script src="js/classbook-qa-alerts.js"></script>
   <script src="js/alerts.js"></script>
   <script src="js/archive-helpers.js"></script>
   <script src="js/app.js"></script>
diff --git a/js/alerts.js b/js/alerts.js
index 74f5b36..f133be3 100644
--- a/js/alerts.js
+++ b/js/alerts.js
@@ -558,93 +558,73 @@ const AlertEngine = (() => {
   // =====================================================
 
   function listenToClassbook(db) {
-    // Teacher questions - ALL unanswered questions (immediate alerts)
-    const classbookListener = db.collection('curriculum')
-      .doc('lessonData')
-      .onSnapshot(doc => {
-        if (!doc.exists) return;
-
-        const data = doc.data();
-        const now = Date.now();
-        let unansweredQuestions = [];
-        const currentClassbookAlertIds = [];
-
-        // Iterate through all semesters
-        for (const [semKey, lessons] of Object.entries(data)) {
-          // Skip metadata fields
-          if (semKey === 'lastUpdated' || semKey === 'lastUpdatedBy') continue;
-          if (!lessons || typeof lessons !== 'object') continue;
-
-          // Iterate through all lessons in this semester
-          for (const [lessonKey, lesson] of Object.entries(lessons)) {
-            if (!lesson.qaThread || !Array.isArray(lesson.qaThread)) continue;
-
-            // Check if last message is from teacher (unanswered)
-            const thread = lesson.qaThread;
-            if (thread.length === 0) continue;
-
-            const lastMsg = thread[thread.length - 1];
-            if (lastMsg.from === 'teacher') {
-              // This is an unanswered question
-              const questionDate = lastMsg.timestamp?.toMillis ? lastMsg.timestamp.toMillis() :
-                                  lastMsg.timestamp ? new Date(lastMsg.timestamp).getTime() : 0;
-
-              const alertId = `classbook-qa-${lessonKey}`;
-              currentClassbookAlertIds.push(alertId);
-
-              // Calculate priority based on age (or use warning if no timestamp)
-              let priority = 'warning';
-              let timeText = 'Unknown time';
-
-              if (questionDate > 0) {
-                const hoursElapsed = Math.floor((now - questionDate) / (1000 * 60 * 60));
-                timeText = `${hoursElapsed}h ago`;
-
-                // Priority based on age: info (0-24h), warning (25-48h), urgent (49h+)
-                if (hoursElapsed >= 49) {
-                  priority = 'urgent';
-                } else if (hoursElapsed >= 25) {
-                  priority = 'warning';
-                } else {
-                  priority = 'info';
-                }
-              }
-
-              const questionText = lastMsg.message || lastMsg.question || 'Question';
-              const teacherName = lesson.teacher || lastMsg.name || 'Teacher';
+    // Teacher questions — ALL unanswered questions (immediate alerts).
+    // Weekly lessons live in curriculum/lessonData AND, for semesters moved to their
+    // own document (Classbook storage move, Sep 2026), in curriculum/lessons_<semKey>.
+    // Each document has its own listener; alerts are rebuilt from the UNION of the
+    // latest snapshot of each (buildClassbookQaAlerts, js/classbook-qa-alerts.js), so
+    // one listener's snapshot never removes the other's alerts.
+    const sources = { lessonData: null, ownDocs: {} };
+    const received = new Set();   // which documents have delivered at least one snapshot
+    const expected = ['lessonData', ...CLASSBOOK_OWN_DOC_SEMESTERS.map(k => `lessons_${k}`)];
+
+    const rebuild = () => {
+      // Don't build (or prune) until every watched document has reported once, so a
+      // semester never flickers out of the alert list while its source is loading.
+      if (!expected.every(id => received.has(id))) return;
+      const unansweredQuestions = buildClassbookQaAlerts(sources, Date.now());
+      const currentClassbookAlertIds = unansweredQuestions.map(a => a.id);
+
+      // A dismissal saved under the pre-Sep-2026 id (classbook-qa-<lessonKey>) still applies.
+      let migratedDismissals = false;
+      unansweredQuestions.forEach(alert => {
+        if (dismissedAlertIds.has(alert.legacyId) && !dismissedAlertIds.has(alert.id)) {
+          dismissedAlertIds.add(alert.id);
+          migratedDismissals = true;
+        }
+      });
+      if (migratedDismissals) saveDismissedAlerts();
 
-              const alert = {
-                id: alertId,
-                type: 'curriculum',
-                priority: priority,
-                title: `${teacherName}: ${questionText.substring(0, 50)}${questionText.length > 50 ? '...' : ''}`,
-                subtitle: `${lesson.className || 'Class'} - Week ${lesson.weekNum || '?'} - ${timeText}`,
-                timestamp: questionDate > 0 ? new Date(questionDate).toISOString() : new Date().toISOString(),
-                actionLabel: 'View Classbook',
-                actionUrl: 'https://tinker-classbook.netlify.app#curriculum-admin',
-                metadata: { lessonKey, semKey }
-              };
-              unansweredQuestions.push(alert);
-            }
-          }
+      // Remove old Classbook alerts that are no longer unanswered
+      alerts.forEach(alert => {
+        if (alert.type === 'curriculum' && !currentClassbookAlertIds.includes(alert.id)) {
+          removeAlert(alert.id);
         }
+      });
 
-        // Remove old Classbook alerts that are no longer unanswered
-        alerts.forEach(alert => {
-          if (alert.type === 'curriculum' && !currentClassbookAlertIds.includes(alert.id)) {
-            removeAlert(alert.id);
-          }
-        });
+      // Update all Q&A alerts
+      unansweredQuestions.forEach(alert => addOrUpdateAlert(alert));
 
-        // Update all Q&A alerts
-        unansweredQuestions.forEach(alert => addOrUpdateAlert(alert));
+      updateUI();
+    };
 
-        updateUI();
+    const classbookListener = db.collection('curriculum')
+      .doc('lessonData')
+      .onSnapshot(doc => {
+        sources.lessonData = doc.exists ? doc.data() : null;
+        received.add('lessonData');
+        rebuild();
       }, error => {
         console.error('Classbook listener error:', error);
       });
-
     listeners.push(classbookListener);
+
+    CLASSBOOK_OWN_DOC_SEMESTERS.forEach(semKey => {
+      const ownDocListener = db.collection('curriculum')
+        .doc(`lessons_${semKey}`)
+        .onSnapshot(doc => {
+          sources.ownDocs[semKey] = doc.exists ? doc.data() : null;
+          received.add(`lessons_${semKey}`);
+          rebuild();
+        }, error => {
+          // Treat an unreadable own document as absent so the rest still alerts.
+          console.error(`Classbook ${semKey} listener error:`, error);
+          sources.ownDocs[semKey] = null;
+          received.add(`lessons_${semKey}`);
+          rebuild();
+        });
+      listeners.push(ownDocListener);
+    });
   }
 
   // =====================================================
diff --git a/js/classbook-qa-alerts.js b/js/classbook-qa-alerts.js
new file mode 100644
index 0000000..586ad18
--- /dev/null
+++ b/js/classbook-qa-alerts.js
@@ -0,0 +1,78 @@
+// Classbook unanswered-question alerts — pure builder (no Firestore, no DOM).
+//
+// Classbook weekly lessons live in two shapes (Sep 2026, Classbook storage move —
+// tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html):
+//   curriculum/lessonData            { <semKey>: { <lessonKey>: lesson }, lastUpdated, … }
+//   curriculum/lessons_<semKey>      { <lessonKey>: lesson, lastUpdated, lastUpdatedBy }
+// Each is watched by its own listener, so the alert set is rebuilt from the union
+// of both — a snapshot from one must never remove the other's alerts. A semester
+// that has its own document is taken from there (its lessonData copy, if any, is
+// ignored). Alert ids carry the semester (the same lesson key exists in every
+// semester); `legacyId` is the pre-Sep-2026 id, so a dismissal saved under it
+// still applies.
+
+const CLASSBOOK_OWN_DOC_SEMESTERS = ['spring-2026'];
+
+function classbookQaAlertsForSemester(semKey, lessons, now) {
+  const out = [];
+  if (!lessons || typeof lessons !== 'object') return out;
+  for (const [lessonKey, lesson] of Object.entries(lessons)) {
+    if (!lesson || typeof lesson !== 'object') continue;
+    const thread = lesson.qaThread;
+    if (!Array.isArray(thread) || thread.length === 0) continue;
+    const lastMsg = thread[thread.length - 1];
+    if (!lastMsg || lastMsg.from !== 'teacher') continue;
+
+    const questionDate = lastMsg.timestamp?.toMillis ? lastMsg.timestamp.toMillis()
+      : lastMsg.timestamp ? new Date(lastMsg.timestamp).getTime() : 0;
+
+    // Priority by age: info (0-24h), warning (25-48h), urgent (49h+); warning if unknown.
+    let priority = 'warning';
+    let timeText = 'Unknown time';
+    if (questionDate > 0) {
+      const hoursElapsed = Math.floor((now - questionDate) / (1000 * 60 * 60));
+      timeText = `${hoursElapsed}h ago`;
+      priority = hoursElapsed >= 49 ? 'urgent' : hoursElapsed >= 25 ? 'warning' : 'info';
+    }
+
+    const questionText = lastMsg.message || lastMsg.question || 'Question';
+    const teacherName = lesson.teacher || lastMsg.name || 'Teacher';
+    out.push({
+      id: `classbook-qa-${semKey}-${lessonKey}`,
+      legacyId: `classbook-qa-${lessonKey}`,
+      type: 'curriculum',
+      priority,
+      title: `${teacherName}: ${questionText.substring(0, 50)}${questionText.length > 50 ? '...' : ''}`,
+      subtitle: `${lesson.className || 'Class'} - Week ${lesson.weekNum || '?'} - ${timeText}`,
+      timestamp: questionDate > 0 ? new Date(questionDate).toISOString() : new Date(now).toISOString(),
+      actionLabel: 'View Classbook',
+      actionUrl: 'https://tinker-classbook.netlify.app#curriculum-admin',
+      metadata: { lessonKey, semKey },
+    });
+  }
+  return out;
+}
+
+// sources: { lessonData: <data | null>, ownDocs: { <semKey>: <data | null> } }
+// (null = that document doesn't exist, or hasn't been received yet).
+function buildClassbookQaAlerts(sources, now) {
+  const ownDocs = sources?.ownDocs || {};
+  const fromOwnDoc = new Set(Object.keys(ownDocs).filter(k => ownDocs[k]));
+  const alerts = [];
+  for (const [semKey, lessons] of Object.entries(sources?.lessonData || {})) {
+    if (semKey === 'lastUpdated' || semKey === 'lastUpdatedBy') continue;
+    if (fromOwnDoc.has(semKey)) continue;
+    alerts.push(...classbookQaAlertsForSemester(semKey, lessons, now));
+  }
+  for (const semKey of fromOwnDoc) {
+    const lessons = { ...ownDocs[semKey] };
+    delete lessons.lastUpdated;
+    delete lessons.lastUpdatedBy;
+    alerts.push(...classbookQaAlertsForSemester(semKey, lessons, now));
+  }
+  return alerts;
+}
+
+if (typeof module !== 'undefined' && module.exports) {
+  module.exports = { CLASSBOOK_OWN_DOC_SEMESTERS, buildClassbookQaAlerts, classbookQaAlertsForSemester };
+}
diff --git a/package.json b/package.json
index 45f1582..b24c72c 100644
--- a/package.json
+++ b/package.json
@@ -1,7 +1,7 @@
 {
   "scripts": {
     "test": "npm run test:rules && npm run test:guard",
-    "test:rules": "firebase emulators:exec --only firestore \"node --experimental-vm-modules node_modules/.bin/jest rules.test.js archive-helpers.test.js archive-transaction.test.js\"",
+    "test:rules": "firebase emulators:exec --only firestore \"node --experimental-vm-modules node_modules/.bin/jest rules.test.js archive-helpers.test.js archive-transaction.test.js classbook-qa-alerts.test.js\"",
     "test:guard": "bash scripts/deploy-rules.test.sh",
     "deploy:rules": "bash scripts/deploy-rules.sh"
   },

exec
/bin/zsh -lc "rg -n \"workers|fullyParallel|testDir|spring-own-doc|resetStorageMove|stageMoved\" playwright.config.* package.json e2e -g '*.js' -g '*.json'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
playwright.config.js:18:  testDir: './e2e',
playwright.config.js:22:  workers: 1,
e2e/helpers/firestore.js:228:// sets workers: 1) — none of them namespace or lock by semesterKey, so raising
e2e/helpers/firestore.js:229:// workers later would introduce a real race for tests sharing the same test semester.
e2e/helpers/storage-move.js:33:async function resetStorageMove() {
e2e/helpers/storage-move.js:41:async function stageMoved({ verified }) {
e2e/helpers/storage-move.js:62:module.exports = { SPRING, SPRING_DOC, springFixture, resetStorageMove, stageMoved, readCurriculumDoc, writeCurriculumDoc, deleteCurriculumDoc };
e2e/spring-own-doc.spec.js:23:test.beforeEach(async () => { await SM.resetStorageMove(); });
e2e/spring-own-doc.spec.js:24:test.afterAll(async () => { await SM.resetStorageMove(); });
e2e/spring-own-doc.spec.js:70:    await SM.stageMoved({ verified: false });
e2e/spring-own-doc.spec.js:79:    await SM.stageMoved({ verified: true });
e2e/spring-own-doc.spec.js:107:    await SM.stageMoved({ verified: true });
e2e/spring-own-doc.spec.js:116:    await SM.stageMoved({ verified: true });
e2e/spring-own-doc.spec.js:127:    await SM.stageMoved({ verified: false });
e2e/spring-own-doc.spec.js:152:    await SM.stageMoved({ verified: true });

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '100,210p;5000,5140p' && rg -n \"setupLessonDataListener\\(\" js/app.js js/*.js" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
   100	  localStorage.setItem('globalSemesterKey', key);
   101	
   102	  // Hide/show Prep Dashboard tab based on semester type
   103	  const semester = currentConfig.semesters[key];
   104	  const prepDashboardTab = document.querySelector('.tab-btn[data-tab="prep-dashboard"]');
   105	  if (prepDashboardTab) {
   106	    if (!isWeeklySemester(key)) {   // camp seasons and SDOC years have no prep dashboard
   107	      prepDashboardTab.style.display = 'none';
   108	      // If currently on Prep Dashboard, switch to Teacher View
   109	      if (document.querySelector('.tab-btn.active')?.dataset.tab === 'prep-dashboard') {
   110	        switchTab('teacher-view');
   111	        return; // Exit early since switchTab will handle the rest
   112	      }
   113	    } else {
   114	      prepDashboardTab.style.display = '';
   115	    }
   116	  }
   117	
   118	  // Hide/show Curriculum Admin tab for non-manager users on summer semesters
   119	  updateCurriculumAdminTab();
   120	
   121	  // Refresh all tabs to use new semester
   122	  const activeTab = document.querySelector('.tab-btn.active')?.dataset.tab;
   123	
   124	  if (activeTab === 'teacher-view') {
   125	    renderTvSemesterSelector();
   126	    renderProgressDashboard();
   127	    renderQaActivityPanel();
   128	    updateClassFilter(); // Update class dropdown for new semester
   129	    renderTeacherView();
   130	  } else if (activeTab === 'prep-dashboard') {
   131	    const weekNum = document.getElementById('week-select')?.value || 1;
   132	    loadWeekData(parseInt(weekNum));
   133	  } else if (activeTab === 'curriculum-admin') {
   134	    renderSemesterSelector();
   135	    renderAdminGrid();
   136	    renderHelpQueue();
   137	    renderCutBank();
   138	    renderIdeaBank();
   139	    renderChangeHistory();
   140	  } else if (activeTab === 'settings') {
   141	    loadSettingsForm();
   142	  }
   143	}
   144	
   145	// ─── Initialization ─────────────────────────────────
   146	
   147	document.addEventListener('DOMContentLoaded', async () => {
   148	  const user = await requireAuth();
   149	  if (!user) return;
   150	
   151	  initCurriculumFirestore();
   152	  await loadConfig();
   153	  // A failed config read is fatal to the whole app by design (Phase 1, 1.2) —
   154	  // nothing below can be trusted, and loadLessonData() must not run.
   155	  if (configLoadFailed) return;
   156	  await loadPrepData();
   157	
   158	  initGlobalSemesterSelector();
   159	
   160	  // Decide how the shared summer collections may be read BEFORE anything reads
   161	  // them (Phase 1, 1.3): a forced-server read of the registry's switch, then a
   162	  // listener — never awaited — so this tab follows the Summer Camp App
   163	  // switching seasons on, and heals if it started offline.
   164	  await loadSeasonRegistryMode();
   165	  watchSeasonRegistry({
   166	    onModeChange: () => { reloadSummerForModeChange(); },
   167	  });
   168	
   169	  // Pre-load lesson data on startup so any load failure is detected immediately
   170	  await loadLessonData();
   171	  if (lessonDataLoadedSuccessfully === false) {
   172	    document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
   173	  }
   174	
   175	  // Hide Prep Dashboard tab for summer camp semesters (prep is done in Summer Camp App)
   176	  const currentSemester = currentConfig?.semesters?.[globalSemesterKey];
   177	  const prepDashboardTab = document.querySelector('.tab-btn[data-tab="prep-dashboard"]');
   178	  if (prepDashboardTab && currentSemester && !isWeeklySemester(globalSemesterKey)) {
   179	    prepDashboardTab.style.display = 'none';
   180	  }
   181	
   182	  setupTabs();
   183	  setupRoleAccess();
   184	  setupFooter();
   185	  loadSettingsForm();
   186	
   187	  // Initialize Curriculum Admin (default tab)
   188	  await initCurriculumAdmin();
   189	
   190	  // Real-time sync for prep data
   191	  setupPrepDataListener(onPrepDataChange);
   192	});
   193	
   194	// ─── Tab Navigation ─────────────────────────────────
   195	
   196	let lastDiagFingerprint = null;  // Track which diagnostic item we navigated from
   197	
   198	function switchTab(tabId) {
   199	  const btn = document.querySelector(`.tab-btn[data-tab="${tabId}"]`);
   200	  if (btn) btn.click();
   201	}
   202	
   203	function setupTabs() {
   204	  document.querySelectorAll('.tab-btn').forEach(btn => {
   205	    btn.addEventListener('click', () => {
   206	      const tabId = btn.dataset.tab;
   207	
   208	      document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
   209	      btn.classList.add('active');
   210	
  5000	      const emptyLessons = {};
  5001	      for (const combo of combos) {
  5002	        const [teacher, className] = combo.split('|||');
  5003	        for (let w = 1; w <= numWeeks; w++) {
  5004	          const lessonKey = makeLessonKey(teacher, className, w);
  5005	          emptyLessons[lessonKey] = {
  5006	            teacher,
  5007	            className,
  5008	            weekNum: w,
  5009	            weekDate: '',
  5010	            classSize: 0,
  5011	            projectTitle: '',
  5012	            shortDetails: '',
  5013	            inspoLink: '',
  5014	            introPitch: '',
  5015	            processStep1: '',
  5016	            processStep2: '',
  5017	            processStep3: '',
  5018	            processStep4: '',
  5019	            closure: '',
  5020	            materials: '',
  5021	            dayOfMaterials: '',
  5022	            materialsList: [],
  5023	            status: '',
  5024	            publishToPrep: ''
  5025	          };
  5026	        }
  5027	      }
  5028	
  5029	      if (Object.keys(emptyLessons).length > 0) {
  5030	        await saveLessonData(key, emptyLessons);
  5031	        if (!currentLessonData) currentLessonData = {};
  5032	        currentLessonData[key] = emptyLessons;
  5033	        lessonDataCommitted = true;
  5034	      }
  5035	    }
  5036	
  5037	    // Confirm on the SERVER that the key is free — the check at the top of this
  5038	    // function only saw this tab's copy of the config (Phase 1, 1.2). The
  5039	    // remaining read-to-update window is accepted: one admin, same class as the
  5040	    // existing residual on the Q&A path.
  5041	    const serverConfig = await readAppDataFromServer();
  5042	    if (serverConfig?.semesters?.[key]) {
  5043	      throw new Error(`A semester with the key "${key}" already exists (created in another tab or by another admin). Choose a different name.`);
  5044	    }
  5045	    currentConfig.semesters[key] = newSem;
  5046	    await updateAppData({ [`semesters.${key}`]: newSem });
  5047	  } catch (err) {
  5048	    console.error('❌ Could not create new semester:', err);
  5049	    // Revert both local mutations so a retry isn't blocked by a phantom
  5050	    // "already exists" and the grid doesn't render a semester that never saved.
  5051	    delete currentConfig.semesters[key];
  5052	    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
  5053	    // R4-11: the empty lesson slots may already be persisted even though the
  5054	    // config never was — clean up the orphaned server-side write, not just the
  5055	    // local copy. Safe: this data is template-empty by construction (never had
  5056	    // real content), so deleting it loses nothing.
  5057	    if (lessonDataCommitted) {
  5058	      try {
  5059	        await deleteLessonData(key);
  5060	      } catch (cleanupErr) {
  5061	        console.error('⚠️ Could not clean up orphaned lesson data after failed semester creation:', cleanupErr);
  5062	      }
  5063	    }
  5064	    alert('Could not create the new semester. Please try again.');
  5065	    return;
  5066	  } finally {
  5067	    creatingSemester = false;
  5068	  }
  5069	
  5070	  closeNewSemesterModal();
  5071	  caCurrentSemester = key;
  5072	  renderSemesterSelector();
  5073	  renderAdminGrid();
  5074	  renderHelpQueue();
  5075	  renderCutBank();
  5076	  renderIdeaBank();
  5077	  renderChangeHistory();
  5078	}
  5079	
  5080	async function initCurriculumAdmin() {
  5081	  if (caInitialized) return;
  5082	  caInitialized = true;
  5083	
  5084	  if (!currentLessonData) await loadLessonData();
  5085	  if (!currentChangeLog) await loadChangeLog();
  5086	  if (!currentCutProjects) await loadCutProjects();
  5087	  if (!currentFutureProjects) await loadFutureProjects();
  5088	
  5089	  renderSemesterSelector();
  5090	  renderAdminGrid();
  5091	  renderHelpQueue();
  5092	  renderCutBank();
  5093	  renderIdeaBank();
  5094	  renderChangeHistory();
  5095	
  5096	  // Modal close
  5097	  document.getElementById('ca-modal-close')?.addEventListener('click', closeAdminModal);
  5098	  document.getElementById('ca-detail-modal')?.addEventListener('click', (e) => {
  5099	    if (e.target === document.getElementById('ca-detail-modal')) closeAdminModal();
  5100	  });
  5101	
  5102	  // Real-time updates
  5103	  setupLessonDataListener((data) => {
  5104	    currentLessonData = data;
  5105	    renderAdminGrid();
  5106	    renderHelpQueue();
  5107	    // Refresh teacher mapping table in Settings if it exists
  5108	    renderTeacherMappingTable();
  5109	  });
  5110	}
  5111	
  5112	function renderAdminGrid() {
  5113	  const wrapper = document.getElementById('ca-grid-wrapper');
  5114	  const semKey = getAdminSemKey();
  5115	  const lessons = currentLessonData?.[semKey];
  5116	
  5117	  // School Day Off Camps years: the event/camp planning list (Phase 1).
  5118	  if (isDayOffYear(semKey)) {
  5119	    document.querySelector('.ca-grid-hint')?.style.setProperty('display', 'none');
  5120	    renderDayOffAdmin(semKey);
  5121	    return;
  5122	  }
  5123	  // Camp seasons get their own view instead of the weekly curriculum grid
  5124	  if (isCampSeason(semKey)) {
  5125	    document.querySelector('.ca-grid-hint')?.style.setProperty('display', 'none');
  5126	    renderSummerCA(lessons);
  5127	    return;
  5128	  }
  5129	  document.querySelector('.ca-grid-hint')?.style.removeProperty('display');
  5130	
  5131	  const semester = currentConfig?.semesters?.[semKey] || getActiveSemester();
  5132	  const numWeeks = semester?.numWeeks || 16;
  5133	  const breakWeeks = semester?.breakWeeks || [];
  5134	  const currentWeek = semKey === getActiveSemesterKey() ? getCurrentWeekNum() : null;
  5135	
  5136	  if (!lessons || Object.keys(lessons).length === 0) {
  5137	    wrapper.innerHTML = `<div class="tv-placeholder">${semKey === getActiveSemesterKey()
  5138	      ? 'No lesson data. Set up the class roster in Settings to create lesson slots.'
  5139	      : 'No lesson data for this semester yet. Import lessons or paste from Cut/Idea Bank.'}</div>`;
  5140	    return;
js/firebase-data.js:1245:// generation counter is module-scoped across every setupLessonDataListener()
js/firebase-data.js:1264:// Set by setupLessonDataListener() so a season-registry mode change (legacy →
js/firebase-data.js:1274:function setupLessonDataListener(callback) {
js/app.js:681:  setupLessonDataListener((data) => {
js/app.js:5103:  setupLessonDataListener((data) => {
js/app.js:681:  setupLessonDataListener((data) => {
js/app.js:5103:  setupLessonDataListener((data) => {

exec
/bin/zsh -lc "nl -ba js/alerts.js | sed -n '1,130p;500,680p;680,780p' && nl -ba js/classbook-qa-alerts.js | sed -n '1,140p' && nl -ba classbook-qa-alerts.test.js | sed -n '1,120p'" in /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc
 succeeded in 0ms:
     1	// Studio Hub - Alert Aggregation Engine
     2	// Real-time Firestore listeners for Mission Control dashboard
     3	
     4	const AlertEngine = (() => {
     5	  let alerts = []; // In-memory alert storage
     6	  let dismissedAlerts = []; // Dismissed alerts (with full alert objects)
     7	  let dismissedAlertIds = new Set(); // Persistent dismissed IDs (loaded from Firestore)
     8	  let listeners = []; // Track active listeners for cleanup
     9	  let currentUser = null;
    10	  let dbRef = null; // Firestore reference for persistence
    11	  let currentFilter = 'all'; // Filter state: 'all', 'pending', 'overdue', 'urgent'
    12	  let showDismissed = false; // Toggle for showing dismissed alerts
    13	
    14	  // Alert priorities (for sorting)
    15	  const PRIORITY = {
    16	    urgent: 3,
    17	    warning: 2,
    18	    info: 1
    19	  };
    20	
    21	  // =====================================================
    22	  // Initialization
    23	  // =====================================================
    24	
    25	  async function init(user, db) {
    26	    currentUser = user;
    27	    dbRef = db;
    28	    cleanup(); // Clear any existing listeners
    29	    alerts = [];
    30	    dismissedAlerts = [];
    31	    dismissedAlertIds = new Set();
    32	
    33	    // Load persisted dismissals first, then start listeners so dismissed alerts never flash in
    34	    await loadDismissedAlerts(db);
    35	
    36	    listenToTimeclock(db);
    37	    listenToPrivateEvents(db);
    38	    listenToClayMembership(db);
    39	    listenToRecap(db);
    40	    listenToClassbook(db);
    41	  }
    42	
    43	  function cleanup() {
    44	    // Unsubscribe all listeners
    45	    listeners.forEach(unsubscribe => unsubscribe());
    46	    listeners = [];
    47	  }
    48	
    49	  // =====================================================
    50	  // Persistent Dismissal Storage
    51	  // =====================================================
    52	
    53	  async function loadDismissedAlerts(db) {
    54	    // Load from localStorage first (fast, same-browser)
    55	    try {
    56	      const local = localStorage.getItem('studioHub_dismissedAlerts');
    57	      if (local) dismissedAlertIds = new Set(JSON.parse(local));
    58	    } catch (e) {}
    59	
    60	    // Then load from Firestore (cross-browser, overrides local)
    61	    if (!currentUser) return;
    62	    try {
    63	      const doc = await db.collection('users').doc(currentUser.uid).get();
    64	      if (doc.exists) {
    65	        const ids = doc.data().dismissedAlertIds || [];
    66	        if (ids.length > 0) {
    67	          dismissedAlertIds = new Set(ids);
    68	          localStorage.setItem('studioHub_dismissedAlerts', JSON.stringify(ids));
    69	        }
    70	      }
    71	    } catch (err) {
    72	      console.error('Failed to load dismissed alerts from Firestore:', err);
    73	    }
    74	  }
    75	
    76	  async function saveDismissedAlerts() {
    77	    const ids = Array.from(dismissedAlertIds);
    78	
    79	    // Save to localStorage immediately (always works)
    80	    localStorage.setItem('studioHub_dismissedAlerts', JSON.stringify(ids));
    81	
    82	    // Save to Firestore for cross-browser persistence
    83	    if (!dbRef || !currentUser) return;
    84	    try {
    85	      await dbRef.collection('users').doc(currentUser.uid).update({
    86	        dismissedAlertIds: ids
    87	      });
    88	    } catch (err) {
    89	      console.error('Failed to save dismissed alerts to Firestore:', err);
    90	    }
    91	  }
    92	
    93	  // =====================================================
    94	  // Timeclock Alerts
    95	  // =====================================================
    96	
    97	  function listenToTimeclock(db) {
    98	    // Late clock-outs (clocked in > 4 hours ago, still open)
    99	    const entriesListener = db.collection('timeclock_entries')
   100	      .where('clockOut', '==', null)
   101	      .onSnapshot(snapshot => {
   102	        const now = Date.now();
   103	        const fourHoursAgo = now - (4 * 60 * 60 * 1000);
   104	
   105	        snapshot.docChanges().forEach(change => {
   106	          const entry = change.doc.data();
   107	          const clockInTime = entry.clockIn?.toMillis ? entry.clockIn.toMillis() : new Date(entry.clockIn).getTime();
   108	
   109	          if (clockInTime < fourHoursAgo) {
   110	            const hoursElapsed = ((now - clockInTime) / (1000 * 60 * 60)).toFixed(1);
   111	            const alertId = `timeclock-late-${change.doc.id}`;
   112	
   113	            if (change.type === 'added' || change.type === 'modified') {
   114	              addOrUpdateAlert({
   115	                id: alertId,
   116	                type: 'timeclock',
   117	                priority: hoursElapsed > 8 ? 'urgent' : 'warning',
   118	                title: `${entry.employeeName || 'Employee'} clocked in ${hoursElapsed}h ago`,
   119	                subtitle: 'Still no clock-out recorded',
   120	                timestamp: new Date(clockInTime).toISOString(),
   121	                actionLabel: 'View Timeclock',
   122	                actionUrl: 'https://tinker-timeclock.netlify.app#today',
   123	                metadata: { entryId: change.doc.id, employeeName: entry.employeeName }
   124	              });
   125	            } else if (change.type === 'removed') {
   126	              removeAlert(alertId);
   127	            }
   128	          } else {
   129	            // Entry is recent, remove alert if exists
   130	            removeAlert(`timeclock-late-${change.doc.id}`);
   500	    const recapListener = db.collection('meetings')
   501	      .where('business', 'in', ['tinker', 'clay'])
   502	      .onSnapshot(snapshot => {
   503	        const meetingAlerts = [];
   504	
   505	        snapshot.forEach(doc => {
   506	          const meeting = doc.data();
   507	          if (meeting.actionItems && Array.isArray(meeting.actionItems)) {
   508	            // Count unresolved action items for this meeting
   509	            const unresolvedCount = meeting.actionItems.filter(item => !item.completed).length;
   510	
   511	            if (unresolvedCount > 0) {
   512	              const meetingDate = meeting.meetingDate?.toMillis ? meeting.meetingDate.toMillis() :
   513	                                 meeting.meetingDate ? new Date(meeting.meetingDate).getTime() : Date.now();
   514	              const threeDaysAgo = Date.now() - (3 * 24 * 60 * 60 * 1000);
   515	
   516	              // Only show alert if meeting is older than 3 days
   517	              if (meetingDate < threeDaysAgo) {
   518	                const daysElapsed = Math.floor((Date.now() - meetingDate) / (1000 * 60 * 60 * 24));
   519	                const alertId = `recap-meeting-${doc.id}`;
   520	
   521	                meetingAlerts.push({
   522	                  id: alertId,
   523	                  type: 'recap',
   524	                  priority: daysElapsed > 7 ? 'warning' : 'info',
   525	                  title: `${meeting.meetingType || 'Meeting'}: ${unresolvedCount} action item${unresolvedCount === 1 ? '' : 's'} pending`,
   526	                  subtitle: `From ${daysElapsed} day${daysElapsed === 1 ? '' : 's'} ago`,
   527	                  timestamp: new Date(meetingDate).toISOString(),
   528	                  actionLabel: 'View Meeting',
   529	                  actionUrl: 'http://localhost:8091',
   530	                  metadata: { meetingId: doc.id, actionItemCount: unresolvedCount }
   531	                });
   532	              }
   533	            }
   534	          }
   535	        });
   536	
   537	        // Remove old Recap alerts that are no longer valid
   538	        const currentRecapAlertIds = meetingAlerts.map(a => a.id);
   539	        alerts.forEach(alert => {
   540	          if (alert.type === 'recap' && !currentRecapAlertIds.includes(alert.id)) {
   541	            removeAlert(alert.id);
   542	          }
   543	        });
   544	
   545	        // Update all meeting alerts
   546	        meetingAlerts.forEach(alert => addOrUpdateAlert(alert));
   547	
   548	        updateUI();
   549	      }, error => {
   550	        console.error('Recap meetings listener error:', error);
   551	      });
   552	
   553	    listeners.push(recapListener);
   554	  }
   555	
   556	  // =====================================================
   557	  // Classbook (Curriculum) Alerts
   558	  // =====================================================
   559	
   560	  function listenToClassbook(db) {
   561	    // Teacher questions — ALL unanswered questions (immediate alerts).
   562	    // Weekly lessons live in curriculum/lessonData AND, for semesters moved to their
   563	    // own document (Classbook storage move, Sep 2026), in curriculum/lessons_<semKey>.
   564	    // Each document has its own listener; alerts are rebuilt from the UNION of the
   565	    // latest snapshot of each (buildClassbookQaAlerts, js/classbook-qa-alerts.js), so
   566	    // one listener's snapshot never removes the other's alerts.
   567	    const sources = { lessonData: null, ownDocs: {} };
   568	    const received = new Set();   // which documents have delivered at least one snapshot
   569	    const expected = ['lessonData', ...CLASSBOOK_OWN_DOC_SEMESTERS.map(k => `lessons_${k}`)];
   570	
   571	    const rebuild = () => {
   572	      // Don't build (or prune) until every watched document has reported once, so a
   573	      // semester never flickers out of the alert list while its source is loading.
   574	      if (!expected.every(id => received.has(id))) return;
   575	      const unansweredQuestions = buildClassbookQaAlerts(sources, Date.now());
   576	      const currentClassbookAlertIds = unansweredQuestions.map(a => a.id);
   577	
   578	      // A dismissal saved under the pre-Sep-2026 id (classbook-qa-<lessonKey>) still applies.
   579	      let migratedDismissals = false;
   580	      unansweredQuestions.forEach(alert => {
   581	        if (dismissedAlertIds.has(alert.legacyId) && !dismissedAlertIds.has(alert.id)) {
   582	          dismissedAlertIds.add(alert.id);
   583	          migratedDismissals = true;
   584	        }
   585	      });
   586	      if (migratedDismissals) saveDismissedAlerts();
   587	
   588	      // Remove old Classbook alerts that are no longer unanswered
   589	      alerts.forEach(alert => {
   590	        if (alert.type === 'curriculum' && !currentClassbookAlertIds.includes(alert.id)) {
   591	          removeAlert(alert.id);
   592	        }
   593	      });
   594	
   595	      // Update all Q&A alerts
   596	      unansweredQuestions.forEach(alert => addOrUpdateAlert(alert));
   597	
   598	      updateUI();
   599	    };
   600	
   601	    const classbookListener = db.collection('curriculum')
   602	      .doc('lessonData')
   603	      .onSnapshot(doc => {
   604	        sources.lessonData = doc.exists ? doc.data() : null;
   605	        received.add('lessonData');
   606	        rebuild();
   607	      }, error => {
   608	        console.error('Classbook listener error:', error);
   609	      });
   610	    listeners.push(classbookListener);
   611	
   612	    CLASSBOOK_OWN_DOC_SEMESTERS.forEach(semKey => {
   613	      const ownDocListener = db.collection('curriculum')
   614	        .doc(`lessons_${semKey}`)
   615	        .onSnapshot(doc => {
   616	          sources.ownDocs[semKey] = doc.exists ? doc.data() : null;
   617	          received.add(`lessons_${semKey}`);
   618	          rebuild();
   619	        }, error => {
   620	          // Treat an unreadable own document as absent so the rest still alerts.
   621	          console.error(`Classbook ${semKey} listener error:`, error);
   622	          sources.ownDocs[semKey] = null;
   623	          received.add(`lessons_${semKey}`);
   624	          rebuild();
   625	        });
   626	      listeners.push(ownDocListener);
   627	    });
   628	  }
   629	
   630	  // =====================================================
   631	  // Alert Management
   632	  // =====================================================
   633	
   634	  function addOrUpdateAlert(alert) {
   635	    if (dismissedAlertIds.has(alert.id)) {
   636	      // Route to dismissed list — alert is still tracked but not shown as active
   637	      alert.dismissed = true;
   638	      const existingIndex = dismissedAlerts.findIndex(a => a.id === alert.id);
   639	      if (existingIndex >= 0) {
   640	        dismissedAlerts[existingIndex] = alert;
   641	      } else {
   642	        dismissedAlerts.push(alert);
   643	      }
   644	      return;
   645	    }
   646	
   647	    const existingIndex = alerts.findIndex(a => a.id === alert.id);
   648	    if (existingIndex >= 0) {
   649	      alerts[existingIndex] = alert;
   650	    } else {
   651	      alerts.push(alert);
   652	    }
   653	  }
   654	
   655	  function removeAlert(alertId) {
   656	    alerts = alerts.filter(a => a.id !== alertId);
   657	    // If the underlying data resolved, auto-clean the dismissal too
   658	    if (dismissedAlertIds.has(alertId)) {
   659	      dismissedAlertIds.delete(alertId);
   660	      dismissedAlerts = dismissedAlerts.filter(a => a.id !== alertId);
   661	      saveDismissedAlerts();
   662	    }
   663	  }
   664	
   665	  function dismissAlert(alertId) {
   666	    const alert = alerts.find(a => a.id === alertId);
   667	    if (alert) {
   668	      alert.dismissed = true;
   669	      alert.dismissedAt = new Date().toISOString();
   670	      dismissedAlerts.push(alert);
   671	      alerts = alerts.filter(a => a.id !== alertId);
   672	      dismissedAlertIds.add(alertId);
   673	      saveDismissedAlerts();
   674	      updateUI();
   675	    }
   676	  }
   677	
   678	  function restoreAlert(alertId) {
   679	    const alert = dismissedAlerts.find(a => a.id === alertId);
   680	    if (alert) {
   680	    if (alert) {
   681	      delete alert.dismissed;
   682	      delete alert.dismissedAt;
   683	      alerts.push(alert);
   684	      dismissedAlerts = dismissedAlerts.filter(a => a.id !== alertId);
   685	      dismissedAlertIds.delete(alertId);
   686	      saveDismissedAlerts();
   687	      updateUI();
   688	    }
   689	  }
   690	
   691	  function toggleDismissed() {
   692	    showDismissed = !showDismissed;
   693	
   694	    // Update toggle button state
   695	    const toggleBtn = document.getElementById('toggle-dismissed');
   696	    if (toggleBtn) {
   697	      if (showDismissed) {
   698	        toggleBtn.classList.add('active');
   699	        toggleBtn.innerHTML = '<span class="toggle-icon">📋</span> Hide Dismissed';
   700	      } else {
   701	        toggleBtn.classList.remove('active');
   702	        const count = dismissedAlerts.length;
   703	        toggleBtn.innerHTML = `<span class="toggle-icon">📋</span> Show Dismissed (<span id="dismissed-count">${count}</span>)`;
   704	      }
   705	    }
   706	
   707	    renderAlertFeed();
   708	  }
   709	
   710	  // =====================================================
   711	  // UI Updates
   712	  // =====================================================
   713	
   714	  function updateUI() {
   715	    updateStatCards();
   716	    renderAlertFeed();
   717	    updateDismissedCount();
   718	  }
   719	
   720	  function updateDismissedCount() {
   721	    const countEl = document.getElementById('dismissed-count');
   722	    if (countEl) {
   723	      countEl.textContent = dismissedAlerts.length;
   724	    }
   725	  }
   726	
   727	  function updateStatCards() {
   728	    // Count alerts by priority (matches category badges)
   729	    const pending = alerts.filter(a => a.priority === 'info').length;
   730	    const overdue = alerts.filter(a => a.priority === 'warning').length;
   731	    const urgent = alerts.filter(a => a.priority === 'urgent').length;
   732	
   733	    // Update stat card values
   734	    const pendingStat = document.getElementById('stat-pending');
   735	    const overdueStat = document.getElementById('stat-overdue');
   736	    const urgentStat = document.getElementById('stat-urgent');
   737	
   738	    if (pendingStat) pendingStat.textContent = pending;
   739	    if (overdueStat) overdueStat.textContent = overdue;
   740	    if (urgentStat) urgentStat.textContent = urgent;
   741	  }
   742	
   743	  function renderAlertFeed() {
   744	    const feedContent = document.getElementById('alert-feed-content');
   745	    if (!feedContent) return;
   746	
   747	    // Combine active and dismissed alerts if showing dismissed
   748	    let allAlerts = showDismissed ? [...alerts, ...dismissedAlerts] : [...alerts];
   749	
   750	    // Apply filter (by priority to match category badges)
   751	    let filteredAlerts = allAlerts;
   752	    if (currentFilter === 'pending') {
   753	      filteredAlerts = allAlerts.filter(a => a.priority === 'info');
   754	    } else if (currentFilter === 'overdue') {
   755	      filteredAlerts = allAlerts.filter(a => a.priority === 'warning');
   756	    } else if (currentFilter === 'urgent') {
   757	      filteredAlerts = allAlerts.filter(a => a.priority === 'urgent');
   758	    }
   759	
   760	    // Sort alerts by priority (urgent → warning → info), then by timestamp (newest first)
   761	    const sortedAlerts = filteredAlerts.sort((a, b) => {
   762	      const priorityDiff = PRIORITY[b.priority] - PRIORITY[a.priority];
   763	      if (priorityDiff !== 0) return priorityDiff;
   764	
   765	      return new Date(b.timestamp).getTime() - new Date(a.timestamp).getTime();
   766	    });
   767	
   768	    // Update filter buttons
   769	    updateFilterButtons();
   770	
   771	    if (sortedAlerts.length === 0 && !showDismissed) {
   772	      const emptyMessage = currentFilter === 'all'
   773	        ? 'All caught up! No pending alerts.'
   774	        : `No ${currentFilter} alerts.`;
   775	
   776	      feedContent.innerHTML = `
   777	        <div class="alert-empty">
   778	          <div class="alert-empty-icon">✨</div>
   779	          <p style="font-weight: 700; color: var(--teal); font-size: 16px;">${emptyMessage}</p>
   780	          <p style="margin-top: 8px; font-size: 13px; color: var(--text-medium);">Alerts from Timeclock, Private Events, and other apps will appear here.</p>
     1	// Classbook unanswered-question alerts — pure builder (no Firestore, no DOM).
     2	//
     3	// Classbook weekly lessons live in two shapes (Sep 2026, Classbook storage move —
     4	// tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html):
     5	//   curriculum/lessonData            { <semKey>: { <lessonKey>: lesson }, lastUpdated, … }
     6	//   curriculum/lessons_<semKey>      { <lessonKey>: lesson, lastUpdated, lastUpdatedBy }
     7	// Each is watched by its own listener, so the alert set is rebuilt from the union
     8	// of both — a snapshot from one must never remove the other's alerts. A semester
     9	// that has its own document is taken from there (its lessonData copy, if any, is
    10	// ignored). Alert ids carry the semester (the same lesson key exists in every
    11	// semester); `legacyId` is the pre-Sep-2026 id, so a dismissal saved under it
    12	// still applies.
    13	
    14	const CLASSBOOK_OWN_DOC_SEMESTERS = ['spring-2026'];
    15	
    16	function classbookQaAlertsForSemester(semKey, lessons, now) {
    17	  const out = [];
    18	  if (!lessons || typeof lessons !== 'object') return out;
    19	  for (const [lessonKey, lesson] of Object.entries(lessons)) {
    20	    if (!lesson || typeof lesson !== 'object') continue;
    21	    const thread = lesson.qaThread;
    22	    if (!Array.isArray(thread) || thread.length === 0) continue;
    23	    const lastMsg = thread[thread.length - 1];
    24	    if (!lastMsg || lastMsg.from !== 'teacher') continue;
    25	
    26	    const questionDate = lastMsg.timestamp?.toMillis ? lastMsg.timestamp.toMillis()
    27	      : lastMsg.timestamp ? new Date(lastMsg.timestamp).getTime() : 0;
    28	
    29	    // Priority by age: info (0-24h), warning (25-48h), urgent (49h+); warning if unknown.
    30	    let priority = 'warning';
    31	    let timeText = 'Unknown time';
    32	    if (questionDate > 0) {
    33	      const hoursElapsed = Math.floor((now - questionDate) / (1000 * 60 * 60));
    34	      timeText = `${hoursElapsed}h ago`;
    35	      priority = hoursElapsed >= 49 ? 'urgent' : hoursElapsed >= 25 ? 'warning' : 'info';
    36	    }
    37	
    38	    const questionText = lastMsg.message || lastMsg.question || 'Question';
    39	    const teacherName = lesson.teacher || lastMsg.name || 'Teacher';
    40	    out.push({
    41	      id: `classbook-qa-${semKey}-${lessonKey}`,
    42	      legacyId: `classbook-qa-${lessonKey}`,
    43	      type: 'curriculum',
    44	      priority,
    45	      title: `${teacherName}: ${questionText.substring(0, 50)}${questionText.length > 50 ? '...' : ''}`,
    46	      subtitle: `${lesson.className || 'Class'} - Week ${lesson.weekNum || '?'} - ${timeText}`,
    47	      timestamp: questionDate > 0 ? new Date(questionDate).toISOString() : new Date(now).toISOString(),
    48	      actionLabel: 'View Classbook',
    49	      actionUrl: 'https://tinker-classbook.netlify.app#curriculum-admin',
    50	      metadata: { lessonKey, semKey },
    51	    });
    52	  }
    53	  return out;
    54	}
    55	
    56	// sources: { lessonData: <data | null>, ownDocs: { <semKey>: <data | null> } }
    57	// (null = that document doesn't exist, or hasn't been received yet).
    58	function buildClassbookQaAlerts(sources, now) {
    59	  const ownDocs = sources?.ownDocs || {};
    60	  const fromOwnDoc = new Set(Object.keys(ownDocs).filter(k => ownDocs[k]));
    61	  const alerts = [];
    62	  for (const [semKey, lessons] of Object.entries(sources?.lessonData || {})) {
    63	    if (semKey === 'lastUpdated' || semKey === 'lastUpdatedBy') continue;
    64	    if (fromOwnDoc.has(semKey)) continue;
    65	    alerts.push(...classbookQaAlertsForSemester(semKey, lessons, now));
    66	  }
    67	  for (const semKey of fromOwnDoc) {
    68	    const lessons = { ...ownDocs[semKey] };
    69	    delete lessons.lastUpdated;
    70	    delete lessons.lastUpdatedBy;
    71	    alerts.push(...classbookQaAlertsForSemester(semKey, lessons, now));
    72	  }
    73	  return alerts;
    74	}
    75	
    76	if (typeof module !== 'undefined' && module.exports) {
    77	  module.exports = { CLASSBOOK_OWN_DOC_SEMESTERS, buildClassbookQaAlerts, classbookQaAlertsForSemester };
    78	}
     1	/**
     2	 * Pure-function tests for js/classbook-qa-alerts.js — no Firestore, no DOM.
     3	 * Run: npm test
     4	 */
     5	const { buildClassbookQaAlerts } = require('./js/classbook-qa-alerts.js');
     6	
     7	const NOW = Date.parse('2026-09-30T12:00:00Z');
     8	const asked = (hoursAgo, extra = {}) => ({
     9	  teacher: 'Mariah', className: 'Clay', weekNum: 3,
    10	  qaThread: [{ from: 'teacher', message: 'Glaze?', timestamp: new Date(NOW - hoursAgo * 3600e3).toISOString() }],
    11	  ...extra,
    12	});
    13	const answered = () => ({ teacher: 'Kathy', qaThread: [{ from: 'teacher', message: 'Q' }, { from: 'admin', message: 'A' }] });
    14	
    15	describe('buildClassbookQaAlerts', () => {
    16	  test('one alert per unanswered question, id qualified by semester, legacy id kept', () => {
    17	    const out = buildClassbookQaAlerts({ lessonData: { 'fall-2026': { 'mariah-tue-1': asked(2), 'kathy-mon-1': answered() }, lastUpdated: 'x' }, ownDocs: {} }, NOW);
    18	    expect(out.map(a => a.id)).toEqual(['classbook-qa-fall-2026-mariah-tue-1']);
    19	    expect(out[0].legacyId).toBe('classbook-qa-mariah-tue-1');
    20	    expect(out[0].metadata).toEqual({ lessonKey: 'mariah-tue-1', semKey: 'fall-2026' });
    21	    expect(out[0].priority).toBe('info');
    22	  });
    23	
    24	  test('the same lesson key in two semesters gives two alerts (no collision)', () => {
    25	    const out = buildClassbookQaAlerts({
    26	      lessonData: { 'fall-2026': { 'k-1': asked(1) } },
    27	      ownDocs: { 'spring-2026': { 'k-1': asked(30), lastUpdated: 'x' } },
    28	    }, NOW);
    29	    expect(out.map(a => a.id).sort()).toEqual(['classbook-qa-fall-2026-k-1', 'classbook-qa-spring-2026-k-1']);
    30	    expect(out.find(a => a.metadata.semKey === 'spring-2026').priority).toBe('warning');
    31	  });
    32	
    33	  test('a semester with its own document is taken from there, never also from lessonData', () => {
    34	    const out = buildClassbookQaAlerts({
    35	      lessonData: { 'spring-2026': { 'stale-1': asked(1) }, 'fall-2026': {} },
    36	      ownDocs: { 'spring-2026': { 'fresh-1': asked(60), lastUpdatedBy: 'x' } },
    37	    }, NOW);
    38	    expect(out.map(a => a.id)).toEqual(['classbook-qa-spring-2026-fresh-1']);
    39	    expect(out[0].priority).toBe('urgent');
    40	  });
    41	
    42	  test('before the move (own doc absent) Spring comes from lessonData', () => {
    43	    const out = buildClassbookQaAlerts({ lessonData: { 'spring-2026': { 's-1': asked(1) } }, ownDocs: { 'spring-2026': null } }, NOW);
    44	    expect(out.map(a => a.id)).toEqual(['classbook-qa-spring-2026-s-1']);
    45	  });
    46	
    47	  test('either source missing yields the other alone; malformed entries are skipped', () => {
    48	    expect(buildClassbookQaAlerts({ lessonData: null, ownDocs: { 'spring-2026': { a: asked(1) } } }, NOW)).toHaveLength(1);
    49	    expect(buildClassbookQaAlerts({ lessonData: { x: 'not a map', y: { bad: null, empty: { qaThread: [] } } }, ownDocs: {} }, NOW)).toEqual([]);
    50	  });
    51	
    52	  test('unknown timestamp → warning', () => {
    53	    const out = buildClassbookQaAlerts({ lessonData: { f: { k: { qaThread: [{ from: 'teacher', message: 'Q' }] } } }, ownDocs: {} }, NOW);
    54	    expect(out[0].priority).toBe('warning');
    55	    expect(out[0].subtitle).toMatch(/Unknown time/);
    56	  });
    57	});

exec
/bin/zsh -lc "rg -n \"saveSingleLesson\\(|saveMultipleLessonFields\\(|deleteLessonKey\\(|saveLessonData\\(\" js/app.js js/*.js --glob '"'!firebase-data.js'"'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
exec
/bin/zsh -lc "rg -n \"OWN_DOC_PAUSED_MESSAGE|editing it is paused|storage-notice-banner|isOwnDocSemester\" index.html js e2e --glob '"'!e2e/spring-own-doc.spec.js'"'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
js/firebase-data.js:949:// saveSingleLesson(): after a failed load, `lessons` is built from an empty or
js/firebase-data.js:955:async function saveLessonData(semesterKey, lessons) {
js/firebase-data.js:986:async function deleteLessonKey(semesterKey, lessonKey) {
js/firebase-data.js:1162:  await saveLessonData(semesterKey, lessons);
js/firebase-data.js:1580:async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
js/firebase-data.js:1666:// saveSingleLesson()'s non-summer branch above so it can be reused by
js/firebase-data.js:1667:// saveMultipleLessonFields() below without duplicating the stripping/clearing
js/firebase-data.js:1673:  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above saveSingleLesson().
js/firebase-data.js:1692:async function saveMultipleLessonFields(semesterKey, writes = [], deletes = []) {
js/firebase-data.js:1702:    throw new Error('saveMultipleLessonFields() does not support camp seasons — use saveSingleLesson() per lesson instead.');
js/firebase-data.js:2856:// saveSingleLesson()'s SDOC branch. Returns { status, doc, by, own }:
js/app.js:1813:    const result = await saveSingleLesson(yearKey, lessonKey, { planComplete: requested }, [], { dayOffAuth: dayOffAuthFor(yearKey) });
js/app.js:2365:        await saveSingleLesson(semKey, lessonKey, payload);
js/app.js:2366:        // saveSingleLesson() stamps the payload it writes; keep the in-memory
js/app.js:2884:        await saveSingleLesson(semKey, lessonKey, { planComplete: cb.checked });
js/app.js:3572:    await saveSingleLesson(semKey, lessonKey, writePayload, fieldsToClear);
js/app.js:3573:    // saveSingleLesson() stamps lastEditedBy/At onto the object it is given.
js/app.js:3658:// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
js/app.js:3663:// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
js/app.js:3672:  // Same load-guard saveSingleLesson() enforced on the old path — after a
js/app.js:5030:        await saveLessonData(key, emptyLessons);
js/app.js:5701:  // the doc. Same routing signal as saveSingleLesson() /
js/app.js:5818:    await saveSingleLesson(semKey, key, firestorePayload, fieldsToClear);
js/app.js:5851:    lastEditedBy: firestorePayload.lastEditedBy,   // stamped by saveSingleLesson()
js/app.js:6008:      await saveMultipleLessonFields(
js/app.js:6081:          await saveMultipleLessonFields(semKey, [
js/app.js:6102:          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
js/app.js:6210:// cached semester via saveLessonData() — any lesson whose local copy was stale
js/app.js:6214:// had actually been written. Now: one targeted saveSingleLesson() per target
js/app.js:6263:      await saveSingleLesson(semKey, targetKey, payload, targetFieldsToClear);
js/app.js:6385:    await deleteLessonKey(semKey, key);
js/app.js:6479:// saveLessonData() semester overwrite), removal via FieldValue.arrayRemove()
js/app.js:6541:    await saveSingleLesson(destSemKey, key, lessons[key], NON_CONTENT_FIELDS_TO_CLEAR);
js/app.js:6951:// saveLessonData() write passed the WHOLE {projects:[...]} wrapper into
js/app.js:6956:// targeted saveSingleLesson() write (unrelated lessons in the same semester
js/app.js:7014:    await saveSingleLesson(semKey, key, newLesson, [...fieldsToClear, ...NON_CONTENT_FIELDS_TO_CLEAR]);
js/app.js:7190:// resave the ENTIRE cached semester via saveLessonData() — a Firestore
js/app.js:11534:    await saveLessonData(semKey, lessons);
js/app.js:12036:      // summer branch of saveSingleLesson() is a set-merge, so everything
js/app.js:12069:      const result = await saveSingleLesson(semKey, lessonKey, payload, fieldsToClear, sdoc ? { dayOffAuth: dayOffAuthFor(semKey) } : undefined);
js/app.js:12070:      // saveSingleLesson() stamps lastEditedBy/At onto the object it is given;
js/app.js:1813:    const result = await saveSingleLesson(yearKey, lessonKey, { planComplete: requested }, [], { dayOffAuth: dayOffAuthFor(yearKey) });
js/app.js:2365:        await saveSingleLesson(semKey, lessonKey, payload);
js/app.js:2366:        // saveSingleLesson() stamps the payload it writes; keep the in-memory
js/app.js:2884:        await saveSingleLesson(semKey, lessonKey, { planComplete: cb.checked });
js/app.js:3572:    await saveSingleLesson(semKey, lessonKey, writePayload, fieldsToClear);
js/app.js:3573:    // saveSingleLesson() stamps lastEditedBy/At onto the object it is given.
js/app.js:3658:// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
js/app.js:3663:// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
js/app.js:3672:  // Same load-guard saveSingleLesson() enforced on the old path — after a
js/app.js:5030:        await saveLessonData(key, emptyLessons);
js/app.js:5701:  // the doc. Same routing signal as saveSingleLesson() /
js/app.js:5818:    await saveSingleLesson(semKey, key, firestorePayload, fieldsToClear);
js/app.js:5851:    lastEditedBy: firestorePayload.lastEditedBy,   // stamped by saveSingleLesson()
js/app.js:6008:      await saveMultipleLessonFields(
js/app.js:6081:          await saveMultipleLessonFields(semKey, [
js/app.js:6102:          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
js/app.js:6210:// cached semester via saveLessonData() — any lesson whose local copy was stale
js/app.js:6214:// had actually been written. Now: one targeted saveSingleLesson() per target
js/app.js:6263:      await saveSingleLesson(semKey, targetKey, payload, targetFieldsToClear);
js/app.js:6385:    await deleteLessonKey(semKey, key);
js/app.js:6479:// saveLessonData() semester overwrite), removal via FieldValue.arrayRemove()
js/app.js:6541:    await saveSingleLesson(destSemKey, key, lessons[key], NON_CONTENT_FIELDS_TO_CLEAR);
js/app.js:6951:// saveLessonData() write passed the WHOLE {projects:[...]} wrapper into
js/app.js:6956:// targeted saveSingleLesson() write (unrelated lessons in the same semester
js/app.js:7014:    await saveSingleLesson(semKey, key, newLesson, [...fieldsToClear, ...NON_CONTENT_FIELDS_TO_CLEAR]);
js/app.js:7190:// resave the ENTIRE cached semester via saveLessonData() — a Firestore
js/app.js:11534:    await saveLessonData(semKey, lessons);
js/app.js:12036:      // summer branch of saveSingleLesson() is a set-merge, so everything
js/app.js:12069:      const result = await saveSingleLesson(semKey, lessonKey, payload, fieldsToClear, sdoc ? { dayOffAuth: dayOffAuthFor(semKey) } : undefined);
js/app.js:12070:      // saveSingleLesson() stamps lastEditedBy/At onto the object it is given;

 succeeded in 0ms:
js/app.js:4591:  if (isOwnDocSemester(key)) {
js/firebase-data.js:86:const OWN_DOC_PAUSED_MESSAGE = 'Spring 2026 is being moved to new storage — editing it is paused for a few days. Viewing works as normal.';
js/firebase-data.js:88:function isOwnDocSemester(semKey) { return OWN_DOC_SEMESTERS.includes(semKey); }
js/firebase-data.js:119:  if (!isOwnDocSemester(semKey)) {
js/firebase-data.js:123:    throw new Error(OWN_DOC_PAUSED_MESSAGE);
js/firebase-data.js:133:  if (isOwnDocSemester(semKey)) {
js/firebase-data.js:162:  let el = document.getElementById('storage-notice-banner');
js/firebase-data.js:165:    el.id = 'storage-notice-banner';
js/firebase-data.js:972:  if (isOwnDocSemester(semesterKey)) {
js/firebase-data.js:1125:  if (isOwnDocSemester(semesterKey)) throw new Error(`"${semesterKey}" can't be deleted while its storage is being changed.`);
js/firebase-data.js:1365:          document.getElementById('storage-notice-banner')?.classList.add('hidden');
js/firebase-data.js:1394:          document.getElementById('storage-notice-banner')?.classList.add('hidden');

exec
/bin/zsh -lc "rg -n \"curriculum|classbook-qa-|dismissedAlertIds|removeAlert\\(\" test*.js *.test.js js --glob '"'!node_modules/**'"'" in /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc
 succeeded in 0ms:
rules.test.js:49:const CURRICULUM_ADMIN_ONLY_UID = 'curriculum-admin-only-uid';   // legacy key, no 'classbook'
rules.test.js:102:    await setDoc(doc(db, 'users', CURRICULUM_ADMIN_ONLY_UID), { role: 'staff', studios: ['tinker'], appAccess: ['curriculum-admin'] });
rules.test.js:174:    // Summer Camp fixtures (shared curriculum + kid notes)
rules.test.js:175:    await setDoc(doc(db, 'summerCamps_curriculum', 'week-1'), { title: 'Week 1' });
rules.test.js:263:    // Seed a curriculum doc and the protected appData doc
rules.test.js:264:    await setDoc(doc(db, 'curriculum', 'spring-2026'), { title: 'Spring Curriculum' });
rules.test.js:265:    await setDoc(doc(db, 'curriculum', 'appData'),     { settings: true });
rules.test.js:728:  test('staff with classbook access can read curriculum doc', async () => {
rules.test.js:730:    await assertSucceeds(getDoc(doc(db, 'curriculum', 'spring-2026')));
rules.test.js:733:  test('staff with classbook access can update curriculum doc', async () => {
rules.test.js:735:    await assertSucceeds(updateDoc(doc(db, 'curriculum', 'spring-2026'), { updated: true }));
rules.test.js:740:    await assertFails(updateDoc(doc(db, 'curriculum', 'appData'), { settings: false }));
rules.test.js:745:    await assertSucceeds(updateDoc(doc(db, 'curriculum', 'appData'), { settings: false }));
rules.test.js:752:// could delete ANY curriculum doc outright — including another teacher's
rules.test.js:755:// is an update), so restricting delete to classbook-admin/curriculum-admin
rules.test.js:758:describe('Classbook — curriculum delete restricted to classbook-admin', () => {
rules.test.js:761:      await setDoc(doc(ctx.firestore(), 'curriculum', 'delete-target'), { title: 'Section to delete' });
rules.test.js:765:  test('plain classbook (teacher) access CANNOT delete a curriculum doc', async () => {
rules.test.js:767:    await assertFails(deleteDoc(doc(db, 'curriculum', 'delete-target')));
rules.test.js:770:  test('classbook-admin access CAN delete a curriculum doc', async () => {
rules.test.js:772:    await assertSucceeds(deleteDoc(doc(db, 'curriculum', 'delete-target')));
rules.test.js:775:  test('manager can delete a curriculum doc', async () => {
rules.test.js:777:    await assertSucceeds(deleteDoc(doc(db, 'curriculum', 'delete-target')));
rules.test.js:782:// Documented, accepted tradeoff (see the comment above the curriculum match
rules.test.js:786:// curriculum data into per-teacher documents, which is a product/data-model
rules.test.js:790:  test('staff with classbook access can update a curriculum doc regardless of which teacher "owns" it', async () => {
rules.test.js:795:    await assertSucceeds(updateDoc(doc(db, 'curriculum', 'spring-2026'), { touchedBy: 'someone-elses-teacher' }));
rules.test.js:1284:  test('staff with summer-camp access cannot delete shared curriculum (Classbook-shared data)', async () => {
rules.test.js:1286:    await assertFails(deleteDoc(doc(db, 'summerCamps_curriculum', 'week-1')));
rules.test.js:1289:  test('staff with classbook access cannot delete summer-camp curriculum either', async () => {
rules.test.js:1291:    await assertFails(deleteDoc(doc(db, 'summerCamps_curriculum', 'week-1')));
rules.test.js:1294:  test('manager can delete shared curriculum', async () => {
rules.test.js:1296:    await assertSucceeds(deleteDoc(doc(db, 'summerCamps_curriculum', 'week-1')));
rules.test.js:1312:  test('staff without summer-camp or classbook access cannot read summer camp curriculum', async () => {
rules.test.js:1314:    await assertFails(getDoc(doc(db, 'summerCamps_curriculum', 'week-1')));
rules.test.js:1482:  'summerCamps_curriculum', 'summerCamps_schedule', 'summerCamps_lessonData',
rules.test.js:1548:    await assertFails(updateDoc(doc(db, 'summerCamps_curriculum', 'migration-fixture'), { season: '2026' }));
rules.test.js:2187:// delete. The legacy 'curriculum-admin' key is deliberately NOT granted on these new collections.
rules.test.js:2195:  ['curriculum-admin only (legacy key)', CURRICULUM_ADMIN_ONLY_UID],
rules.test.js:2592:// curriculum/lessonData (every Fall/Spring semester in ONE document) was at 95% of Firestore's
rules.test.js:2593:// 1 MiB cap on Sep 29 2026. Spring 2026 moves to curriculum/lessons_spring-2026 in one
rules.test.js:2598:// manager during a rollback. Every other /curriculum doc behaves exactly as before.
rules.test.js:2606:  ['curriculum-admin (legacy key)', CURRICULUM_ADMIN_ONLY_UID],
rules.test.js:2619:    await setDoc(doc(db, 'curriculum', 'lessonData'), lessonData);
rules.test.js:2620:    if (target) await setDoc(doc(db, 'curriculum', SPRING_DOC), target); else await deleteDoc(doc(db, 'curriculum', SPRING_DOC));
rules.test.js:2621:    if (migrations) await setDoc(doc(db, 'curriculum', MIGRATIONS), migrations); else await deleteDoc(doc(db, 'curriculum', MIGRATIONS));
rules.test.js:2628:    const ld = await tx.get(doc(db, 'curriculum', 'lessonData'));
rules.test.js:2629:    const target = await tx.get(doc(db, 'curriculum', SPRING_DOC));
rules.test.js:2630:    await tx.get(doc(db, 'curriculum', MIGRATIONS));
rules.test.js:2633:    tx.set(doc(db, 'curriculum', SPRING_DOC), { ...map, lastUpdated: 'now', lastUpdatedBy: 'test' });
rules.test.js:2634:    tx.update(doc(db, 'curriculum', 'lessonData'), { [SPRING]: deleteField() });
rules.test.js:2635:    tx.set(doc(db, 'curriculum', MIGRATIONS), { [SPRING]: { lessonCount: Object.keys(map).length, sha256: 'h', verified: false } }, { merge: true });
rules.test.js:2641:    await tx.get(doc(db, 'curriculum', 'lessonData'));
rules.test.js:2642:    await tx.get(doc(db, 'curriculum', SPRING_DOC));
rules.test.js:2643:    tx.update(doc(db, 'curriculum', 'lessonData'), { [SPRING]: springMap() });
rules.test.js:2644:    if (deleteTarget) tx.delete(doc(db, 'curriculum', SPRING_DOC));
rules.test.js:2652:    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026.allie-wednesday-1.shortDetails': 'Updated' }));
rules.test.js:2655:    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.mariah-tuesday-1.shortDetails': 'Changed' }));
rules.test.js:2658:    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.new-lesson': { teacher: 'X' } }));
rules.test.js:2661:    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField() }));
rules.test.js:2664:    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField() }));
rules.test.js:2667:    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField(), 'fall-2026.allie-wednesday-1.shortDetails': 'x' }));
rules.test.js:2670:    await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', 'lessonData')));
rules.test.js:2673:    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': {}, [SPRING]: { stale: true } }));
rules.test.js:2676:    await assertSucceeds(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': { 'new-slot': { teacher: 'Allie' } } }, { merge: true }));
rules.test.js:2683:    await testEnv.withSecurityRulesDisabled(async (ctx) => { await deleteDoc(doc(ctx.firestore(), 'curriculum', 'lessonData')); });
rules.test.js:2686:    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
rules.test.js:2689:    await assertSucceeds(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': {} }));
rules.test.js:2702:    await assertFails(setDoc(doc(getDb(uid), 'curriculum', SPRING_DOC), springMap()));
rules.test.js:2705:    await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: { verified: true } }, { merge: true }));
rules.test.js:2708:    await testEnv.withSecurityRulesDisabled(async (ctx) => { await setDoc(doc(ctx.firestore(), 'curriculum', MIGRATIONS), { [SPRING]: { verified: false } }); });
rules.test.js:2709:    await assertSucceeds(getDoc(doc(getDb(uid), 'curriculum', MIGRATIONS)));
rules.test.js:2717:    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', SPRING_DOC), { 'mariah-tuesday-1.shortDetails': 'Changed' }));
rules.test.js:2720:    await assertSucceeds(getDoc(doc(getDb(uid), 'curriculum', SPRING_DOC)));
rules.test.js:2732:    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
rules.test.js:2735:    await assertSucceeds(deleteDoc(doc(getDb(uid), 'curriculum', SPRING_DOC)));
rules.test.js:2738:    await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', SPRING_DOC)));
rules.test.js:2741:    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
rules.test.js:2744:    await assertFails(setDoc(doc(getDb(uid), 'curriculum', SPRING_DOC), { replaced: true }));
rules.test.js:2752:    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', SPRING_DOC), { 'mariah-tuesday-1.shortDetails': 'Changed' }));
rules.test.js:2755:    await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', SPRING_DOC)));
rules.test.js:2761:    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.stale': { teacher: 'X' } }));
rules.test.js:2764:    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026.allie-wednesday-1.shortDetails': 'Updated' }));
rules.test.js:2768:describe('Classbook storage move — every other /curriculum doc exactly as before', () => {
rules.test.js:2772:      await setDoc(doc(db, 'curriculum', 'cutProjects'), { 'fall-2026': [] });
rules.test.js:2773:      await setDoc(doc(db, 'curriculum', 'prepCycleConfig'), { a: 1 });
rules.test.js:2774:      await setDoc(doc(db, 'curriculum', 'ordinary-delete-target'), { a: 1 });
rules.test.js:2778:    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'cutProjects'), { 'fall-2026': ['x'] }));
rules.test.js:2780:  test.each(MANAGER_ROLES)('%s can still delete an ordinary curriculum doc', async (_l, uid) => {
rules.test.js:2781:    await assertSucceeds(deleteDoc(doc(getDb(uid), 'curriculum', 'ordinary-delete-target')));
rules.test.js:2784:    await assertSucceeds(updateDoc(doc(getDb(CLASSBOOK_ADMIN_UID), 'curriculum', 'prepCycleConfig'), { a: 2 }));
rules.test.js:2785:    await assertFails(updateDoc(doc(getDb(CLASSBOOK_UID), 'curriculum', 'prepCycleConfig'), { a: 3 }));
rules.test.js:2788:    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'appData'), { settings: true }));
rules.test.js:2789:    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'prepCycleConfig'), { a: 4 }));
rules.test.js:2791:  test('staff without classbook access still cannot read or write curriculum', async () => {
rules.test.js:2792:    await assertFails(getDoc(doc(getDb(STAFF_NOACCESS_UID), 'curriculum', 'cutProjects')));
rules.test.js:2793:    await assertFails(updateDoc(doc(getDb(STAFF_NOACCESS_UID), 'curriculum', 'lessonData'), { 'fall-2026.x': {} }));
rules.test.js:2819:      await setDoc(doc(ctx.firestore(), 'curriculum', 'lessonData'), big);
rules.test.js:2820:      await deleteDoc(doc(ctx.firestore(), 'curriculum', SPRING_DOC));
rules.test.js:2821:      await deleteDoc(doc(ctx.firestore(), 'curriculum', MIGRATIONS));
rules.test.js:2830:    await assertSucceeds(updateDoc(doc(getDb(CLASSBOOK_UID), 'curriculum', 'lessonData'), { 'fall-2026.teacher-class-1.shortDetails': 'Updated' }));
rules.test.js:2831:    await assertFails(updateDoc(doc(getDb(CLASSBOOK_UID), 'curriculum', 'lessonData'), { 'spring-2026.teacher-class-1.shortDetails': 'Changed' }));
rules.test.js:2843:    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
rules.test.js:2847:    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: { 'mariah-tuesday-1': { shortDetails: 'x' } } }, { merge: true }));
rules.test.js:2853:      await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: false }));
rules.test.js:2856:      await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: deleteField() }));
rules.test.js:2859:      await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: deleteField() }));
rules.test.js:2862:      await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { other: true }));
rules.test.js:2865:      await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', MIGRATIONS)));
rules.test.js:2868:      await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.note`]: 'spot-checked' }));
rules.test.js:2874:    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
rules.test.js:2878:    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
rules.test.js:2882:    await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: { verified: true } }));
rules.test.js:2893:    b.update(doc(db, 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true });
rules.test.js:2894:    b.delete(doc(db, 'curriculum', SPRING_DOC));
rules.test.js:2900:      await tx.get(doc(db, 'curriculum', 'lessonData'));
rules.test.js:2901:      await tx.get(doc(db, 'curriculum', SPRING_DOC));
rules.test.js:2902:      tx.update(doc(db, 'curriculum', 'lessonData'), { [SPRING]: springMap() });
rules.test.js:2903:      tx.delete(doc(db, 'curriculum', SPRING_DOC));
rules.test.js:2904:      tx.update(doc(db, 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true });
rules.test.js:2908:    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
classbook-qa-alerts.test.js:2: * Pure-function tests for js/classbook-qa-alerts.js — no Firestore, no DOM.
classbook-qa-alerts.test.js:5:const { buildClassbookQaAlerts } = require('./js/classbook-qa-alerts.js');
classbook-qa-alerts.test.js:18:    expect(out.map(a => a.id)).toEqual(['classbook-qa-fall-2026-mariah-tue-1']);
classbook-qa-alerts.test.js:19:    expect(out[0].legacyId).toBe('classbook-qa-mariah-tue-1');
classbook-qa-alerts.test.js:29:    expect(out.map(a => a.id).sort()).toEqual(['classbook-qa-fall-2026-k-1', 'classbook-qa-spring-2026-k-1']);
classbook-qa-alerts.test.js:38:    expect(out.map(a => a.id)).toEqual(['classbook-qa-spring-2026-fresh-1']);
classbook-qa-alerts.test.js:44:    expect(out.map(a => a.id)).toEqual(['classbook-qa-spring-2026-s-1']);
test-alerts.js:97:  // Get current curriculum data
test-alerts.js:98:  const curriculumRef = db.collection('curriculum').doc('lessonData');
test-alerts.js:99:  const doc = await curriculumRef.get();
test-alerts.js:117:  await curriculumRef.set({ qaData }, { merge: true });
test-alerts.js:120:  return 'curriculum/lessonData';
test-alerts.js:143:  const curriculumRef = db.collection('curriculum').doc('lessonData');
test-alerts.js:144:  const doc = await curriculumRef.get();
test-alerts.js:150:    await curriculumRef.update({ qaData });
js/app.js:420:      ${(canAccessApp(CONFIG.apps.find(a => a.id === 'curriculum-admin')) || (currentUser && (currentUser.appAccess || []).includes('classbook'))) ? `
js/app.js:441:  const quickAccessIds = ['curriculum-admin', 'materials-locator', 'supply-low-list', 'training'];
js/app.js:570:  'curriculum-admin',
js/app.js:731:  { id: 'curriculum-admin', name: 'The Classbook (admin)' },
js/classbook-qa-alerts.js:5://   curriculum/lessonData            { <semKey>: { <lessonKey>: lesson }, lastUpdated, … }
js/classbook-qa-alerts.js:6://   curriculum/lessons_<semKey>      { <lessonKey>: lesson, lastUpdated, lastUpdatedBy }
js/classbook-qa-alerts.js:41:      id: `classbook-qa-${semKey}-${lessonKey}`,
js/classbook-qa-alerts.js:42:      legacyId: `classbook-qa-${lessonKey}`,
js/classbook-qa-alerts.js:43:      type: 'curriculum',
js/classbook-qa-alerts.js:49:      actionUrl: 'https://tinker-classbook.netlify.app#curriculum-admin',
js/config.js:16:      id: "curriculum",
js/config.js:181:      description: "Camp curriculum planning hub",
js/config.js:183:      department: "curriculum",
js/config.js:192:      id: "curriculum-admin",
js/config.js:196:      department: "curriculum",
js/config.js:249:      department: "curriculum",
js/config.js:277:      department: "curriculum",
js/config.js:291:      department: "curriculum",
js/alerts.js:7:  let dismissedAlertIds = new Set(); // Persistent dismissed IDs (loaded from Firestore)
js/alerts.js:31:    dismissedAlertIds = new Set();
js/alerts.js:57:      if (local) dismissedAlertIds = new Set(JSON.parse(local));
js/alerts.js:65:        const ids = doc.data().dismissedAlertIds || [];
js/alerts.js:67:          dismissedAlertIds = new Set(ids);
js/alerts.js:77:    const ids = Array.from(dismissedAlertIds);
js/alerts.js:86:        dismissedAlertIds: ids
js/alerts.js:126:              removeAlert(alertId);
js/alerts.js:130:            removeAlert(`timeclock-late-${change.doc.id}`);
js/alerts.js:161:            removeAlert(alertId);
js/alerts.js:199:            removeAlert(alertId);
js/alerts.js:238:            removeAlert(alertId);
js/alerts.js:295:          removeAlert(alertId);
js/alerts.js:314:            removeAlert(alertId);
js/alerts.js:337:            removeAlert(alertId);
js/alerts.js:377:              removeAlert(alertId);
js/alerts.js:380:            removeAlert(alertId);
js/alerts.js:434:        staleIds.forEach(id => removeAlert(id));
js/alerts.js:452:            removeAlert(alertId);
js/alerts.js:478:              removeAlert(alertId);
js/alerts.js:481:            removeAlert(alertId);
js/alerts.js:541:            removeAlert(alert.id);
js/alerts.js:562:    // Weekly lessons live in curriculum/lessonData AND, for semesters moved to their
js/alerts.js:563:    // own document (Classbook storage move, Sep 2026), in curriculum/lessons_<semKey>.
js/alerts.js:565:    // latest snapshot of each (buildClassbookQaAlerts, js/classbook-qa-alerts.js), so
js/alerts.js:578:      // A dismissal saved under the pre-Sep-2026 id (classbook-qa-<lessonKey>) still applies.
js/alerts.js:581:        if (dismissedAlertIds.has(alert.legacyId) && !dismissedAlertIds.has(alert.id)) {
js/alerts.js:582:          dismissedAlertIds.add(alert.id);
js/alerts.js:590:        if (alert.type === 'curriculum' && !currentClassbookAlertIds.includes(alert.id)) {
js/alerts.js:591:          removeAlert(alert.id);
js/alerts.js:601:    const classbookListener = db.collection('curriculum')
js/alerts.js:613:      const ownDocListener = db.collection('curriculum')
js/alerts.js:635:    if (dismissedAlertIds.has(alert.id)) {
js/alerts.js:655:  function removeAlert(alertId) {
js/alerts.js:658:    if (dismissedAlertIds.has(alertId)) {
js/alerts.js:659:      dismissedAlertIds.delete(alertId);
js/alerts.js:672:      dismissedAlertIds.add(alertId);
js/alerts.js:685:      dismissedAlertIds.delete(alertId);
js/alerts.js:848:      'curriculum': '📚'

codex
Two deploy blockers are now confirmed. First, the pause is enforced only at the low-level target helper, so several UI workflows hide the pause reason or perform side effects before that helper is reached (notably photo upload and Cut Bank archival). Second, Studio Hub’s legacy-dismissal migration never removes the old dismissal when the underlying question resolves, so future questions on that lesson key can remain dismissed indefinitely. I’m finishing the transition-race and test-isolation pass before giving the minimum list.
exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '2840,2905p;2325,2385p;1785,1830p;11920,12110p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
  1785	  container.innerHTML = `<div class="sdoc-tv">${html}</div>`;
  1786	}
  1787	
  1788	function openDayOffPlanFromList(lessonKey) {
  1789	  const yearKey = getTvSemKey();
  1790	  return openPlanEditor(yearKey, lessonKey, {
  1791	    onClosed: () => setTimeout(() => {
  1792	      document.querySelector(`.sdoc-tv-open-btn[data-lesson-key="${CSS.escape(lessonKey)}"]`)?.scrollIntoView({ block: 'center' });
  1793	    }, 50),
  1794	  });
  1795	}
  1796	
  1797	// Plan complete from the list: one narrow { planComplete } write through the
  1798	// same save path, identified by its plan key (a title on two days is one plan,
  1799	// so every checkbox with that key moves together, and rolls back together).
  1800	const dayOffPlanCompleteInFlight = new Set();
  1801	async function toggleDayOffPlanComplete(box) {
  1802	  const yearKey = getTvSemKey();
  1803	  const lessonKey = box.dataset.lessonKey;
  1804	  const requested = box.checked;
  1805	  const flight = `${yearKey}|${lessonKey}`;
  1806	  const boxes = () => [...document.querySelectorAll('.sdoc-tv-pc-cb')].filter(b => b.dataset.lessonKey === lessonKey);
  1807	  if (dayOffPlanCompleteInFlight.has(flight)) { box.checked = !requested; return; }
  1808	  const slot = currentLessonData?.[yearKey]?.[lessonKey];
  1809	  if (!slot || !canEditDayOffPlan(slot)) { box.checked = !requested; return; }
  1810	  dayOffPlanCompleteInFlight.add(flight);
  1811	  boxes().forEach(b => { b.checked = requested; b.disabled = true; });
  1812	  try {
  1813	    const result = await saveSingleLesson(yearKey, lessonKey, { planComplete: requested }, [], { dayOffAuth: dayOffAuthFor(yearKey) });
  1814	    if (result?.status === 'savedSince') alert(`Saved — ${result.by} has edited this plan since.`);
  1815	  } catch (err) {
  1816	    console.error('Plan complete failed:', err);
  1817	    boxes().forEach(b => { b.checked = !requested; });
  1818	    alert(`Couldn't ${requested ? 'mark' : 'unmark'} the plan complete: ${err.message}`);
  1819	  } finally {
  1820	    dayOffPlanCompleteInFlight.delete(flight);
  1821	  }
  1822	  renderTeacherView();
  1823	}
  1824	
  1825	// ═══════════════════════════════════════════════════════
  1826	// SUMMER CAMP VIEW (Project-based, not week-based)
  1827	// ═══════════════════════════════════════════════════════
  1828	
  1829	function setSummerTeacherView(view) {
  1830	  summerTeacherView = view;
  2325	        return;
  2326	      }
  2327	
  2328	      // One save at a time per LESSON: a second change while the first is in
  2329	      // flight would capture the optimistic value as its "previous" and the
  2330	      // two rollbacks could then land in either order. Keyed by lesson, not by
  2331	      // element — a re-render replaces the element mid-save.
  2332	      if (summerPlanCompleteSavesInFlight.has(inFlightKey(semKey, lessonKey))) { cb.checked = !requested; return; }
  2333	      summerPlanCompleteSavesInFlight.add(inFlightKey(semKey, lessonKey));
  2334	
  2335	      const lesson = lessons[lessonKey];
  2336	      console.log('Found lesson, current planComplete:', lesson.planComplete);
  2337	      // Backtracking audit Phase 6: optimistic in-memory update, put back in
  2338	      // full if the save fails (R3-20 — the catch used to revert only the
  2339	      // checkbox). Stamped NOW, not after the write: a reload landing while
  2340	      // the save is in flight merges per lesson by lastEditedAt (Phase 7),
  2341	      // and an unstamped copy would lose to the reload's pre-write read.
  2342	      const previous = { planComplete: lesson.planComplete, lastEditedBy: lesson.lastEditedBy, lastEditedAt: lesson.lastEditedAt };
  2343	      const myStamp = new Date().toISOString();
  2344	      lesson.planComplete = requested;
  2345	      lesson.lastEditedBy = getAuthUser()?.name || 'Unknown';
  2346	      lesson.lastEditedAt = myStamp;
  2347	      console.log('Updated to:', lesson.planComplete);
  2348	      cb.disabled = true;
  2349	
  2350	      // The checkbox/badge may have been re-rendered while the save was in
  2351	      // flight — address them by identity, not by the element that was clicked.
  2352	      const liveCheckbox = () => document.querySelector(`.summer-plan-complete-cb[data-lesson-key="${CSS.escape(lessonKey)}"]`) || cb;
  2353	      // The cache entry as it is NOW. A reload whose fresh copy won has
  2354	      // REPLACED the entry (this `lesson` is then detached and must not be
  2355	      // touched); one that kept ours updated it in place, stamp intact.
  2356	      const liveLesson = () => currentLessonData?.[semKey]?.[lessonKey];
  2357	      const owned = () => liveLesson() === lesson && lesson.lastEditedAt === myStamp;
  2358	
  2359	      try {
  2360	        console.log('Saving lesson with key:', lessonKey);
  2361	        // Narrow payload — only planComplete, not the full (possibly stale)
  2362	        // lesson object, so a stale local photoUrl/content field can never be
  2363	        // written over real Firestore content (Data Safety Plan Stage 2C).
  2364	        const payload = { planComplete: requested };
  2365	        await saveSingleLesson(semKey, lessonKey, payload);
  2366	        // saveSingleLesson() stamps the payload it writes; keep the in-memory
  2367	        // copy identical to the doc — only if this save still owns the entry.
  2368	        if (owned()) {
  2369	          lesson.lastEditedBy = payload.lastEditedBy;
  2370	          lesson.lastEditedAt = payload.lastEditedAt;
  2371	        }
  2372	        displacedSummerServerCopies.delete(displacedKey(semKey, lessonKey)); // this save is the confirmed state now
  2373	        console.log('Saved successfully! Lesson:', lessonKey, 'planComplete:', lesson.planComplete);
  2374	
  2375	        // Update the checkbox/status badge without re-rendering the view —
  2376	        // from the entry the cache holds NOW (a newer copy may have replaced
  2377	        // ours while the save was in flight).
  2378	        const shown = !!(liveLesson() ?? lesson).planComplete;
  2379	        liveCheckbox().checked = shown;
  2380	        const weekSection = liveCheckbox().closest('.tv-week-section');
  2381	        if (weekSection) {
  2382	          const statusBadge = weekSection.querySelector('.tv-status');
  2383	          if (statusBadge) {
  2384	            console.log('Updating status badge to:', shown ? 'Complete' : 'empty');
  2385	            if (shown) {
  2840	    header.addEventListener('keydown', (e) => {
  2841	      if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); toggle(); }
  2842	    });
  2843	  });
  2844	
  2845	  container.querySelectorAll('.tv-expand-btn').forEach(btn => {
  2846	    btn.addEventListener('click', () => {
  2847	      const content = btn.nextElementSibling;
  2848	      const expanded = btn.dataset.expanded === 'true';
  2849	      btn.dataset.expanded = expanded ? 'false' : 'true';
  2850	      btn.textContent = expanded ? 'Show details' : 'Hide details';
  2851	      content.style.display = expanded ? 'none' : 'block';
  2852	    });
  2853	  });
  2854	
  2855	  // Edit button click
  2856	  container.querySelectorAll('.tv-edit-btn').forEach(btn => {
  2857	    btn.addEventListener('click', (e) => {
  2858	      e.stopPropagation();
  2859	      openTeacherEditModal(btn.dataset.editKey);
  2860	    });
  2861	  });
  2862	
  2863	  // Print lesson button click
  2864	  container.querySelectorAll('.tv-card-print-btn').forEach(btn => {
  2865	    btn.addEventListener('click', (e) => {
  2866	      e.stopPropagation();
  2867	      printLesson(btn.dataset.lessonKey);
  2868	    });
  2869	  });
  2870	
  2871	  // Plan Complete checkbox — instant save
  2872	  container.querySelectorAll('.tv-plan-complete-cb').forEach(cb => {
  2873	    cb.addEventListener('change', async (e) => {
  2874	      const lessonKey = cb.dataset.lessonKey;
  2875	      const semKey = getTvSemKey();
  2876	      const lessons = currentLessonData?.[semKey];
  2877	      if (!lessons || !lessons[lessonKey]) return;
  2878	
  2879	      const lesson = lessons[lessonKey];
  2880	      lesson.planComplete = cb.checked;
  2881	
  2882	      try {
  2883	        // Narrow payload — see the Stage 2C note on the summer handler above.
  2884	        await saveSingleLesson(semKey, lessonKey, { planComplete: cb.checked });
  2885	        // Re-render to update progress badge
  2886	        renderTeacherView();
  2887	      } catch (err) {
  2888	        console.error('Error saving plan complete:', err);
  2889	        cb.checked = !cb.checked; // revert
  2890	        lesson.planComplete = cb.checked;
  2891	      }
  2892	    });
  2893	  });
  2894	
  2895	  // Lesson title click: open read-only detail view
  2896	  container.querySelectorAll('.tv-clickable-title').forEach(title => {
  2897	    title.addEventListener('click', () => {
  2898	      openLessonDetailModal(title.dataset.viewKey);
  2899	    });
  2900	  });
  2901	
  2902	  // Shared project links: click to view shared lesson
  2903	  container.querySelectorAll('.tv-shared-link').forEach(link => {
  2904	    link.addEventListener('click', () => {
  2905	      const teacher = link.dataset.teacher;
 11920	      introPitch: modal.querySelector('#summer-intro-pitch'),
 11921	      processStep1: modal.querySelector('#summer-step1'),
 11922	      processStep2: modal.querySelector('#summer-step2'),
 11923	      processStep3: modal.querySelector('#summer-step3'),
 11924	      processStep4: modal.querySelector('#summer-step4'),
 11925	      closure: modal.querySelector('#summer-closure'),
 11926	      dayOfMaterials: modal.querySelector('#summer-day-of'),
 11927	      photoInput: modal.querySelector('#summer-photo-input'),
 11928	    };
 11929	    const previous = summerLessonSaveChains.get(chainKey) || Promise.resolve();
 11930	    const run = previous.then(() => performSave(showStatus, myInvocation, form))
 11931	      .finally(() => { pendingSaves--; });
 11932	    // performSave() never rejects (it reports failures through the status
 11933	    // line and resolves false), but never let a surprise leave the chain
 11934	    // permanently rejected. The chain resolves to the LAST save's outcome.
 11935	    const chained = run.catch(() => false);
 11936	    summerLessonSaveChains.set(chainKey, chained);
 11937	    chained.then(() => { if (summerLessonSaveChains.get(chainKey) === chained) summerLessonSaveChains.delete(chainKey); });
 11938	    return run;
 11939	  };
 11940	
 11941	  const performSave = async (showStatus, myInvocation, form) => {
 11942	    if (showStatus && !closing) { autoSaveStatus.textContent = 'Saving...'; autoSaveStatus.style.color = ''; }
 11943	    // The curriculum/lessonData listener rebuilds the whole summer cache from
 11944	    // a fresh collection read on every snapshot (any other user's save). If
 11945	    // that brought in a newer confirmed copy of this lesson, build on it
 11946	    // rather than on the copy this modal last confirmed — but never on an
 11947	    // OLDER one (a read taken before a save that has since landed).
 11948	    const cachedAtStart = currentLessonData[semKey]?.[lessonKey];
 11949	    if (cachedAtStart && cachedAtStart !== lesson && editedAtOf(cachedAtStart) > editedAtOf(lesson)) {
 11950	      lesson = cachedAtStart;
 11951	    }
 11952	    // For the failure path: what the shared cache and the modal's `lesson`
 11953	    // held before THIS save's optimistic mutation, and the object it put
 11954	    // there — the revert below only restores state it still owns.
 11955	    let previousCachedLesson;
 11956	    let previousLessonRef;
 11957	    let optimisticLesson = null;
 11958	
 11959	    try {
 11960	      // Gather form data — only include content fields that have actual text.
 11961	      // Empty strings are omitted so stale-memory opens can't silently wipe
 11962	      // fields that were already saved to Firestore by a previous session.
 11963	      const rawContentFields = {
 11964	        introPitch: form.introPitch.value.trim(),
 11965	        processStep1: form.processStep1.value.trim(),
 11966	        processStep2: form.processStep2.value.trim(),
 11967	        processStep3: form.processStep3.value.trim(),
 11968	        processStep4: form.processStep4.value.trim(),
 11969	        closure: form.closure.value.trim(),
 11970	        dayOfMaterials: form.dayOfMaterials.value.trim(),
 11971	      };
 11972	      // Only fields this modal actually changed since its last confirmed
 11973	      // save are overlaid. An untouched field keeps whatever `lesson` holds —
 11974	      // which, if a newer copy was adopted above, is another client's edit
 11975	      // that would otherwise be overwritten by the older text still sitting
 11976	      // in this form.
 11977	      const isDirty = (f) => rawContentFields[f] !== (summerLessonOriginalData[f] || '').trim();
 11978	      const contentUpdates = Object.fromEntries(
 11979	        Object.entries(rawContentFields).filter(([f, v]) => v !== '' && isDirty(f))
 11980	      );
 11981	      const updatedLesson = {
 11982	        ...lesson,
 11983	        ...contentUpdates,
 11984	        lastEditedBy: getAuthUser()?.name || 'Unknown',
 11985	        lastEditedAt: new Date().toISOString()
 11986	      };
 11987	
 11988	      // A field that had text when the modal opened (or last saved) and is
 11989	      // now empty is an intentional clear, not a stale-state omission —
 11990	      // contentUpdates above already drops it, so this is the only signal
 11991	      // that reaches saveSingleLesson telling it to actually delete the field
 11992	      // instead of leaving the old value untouched (Data Safety Plan Stage 3).
 11993	      const fieldsToClear = Object.keys(summerLessonOriginalData).filter(f =>
 11994	        summerLessonOriginalData[f].trim() !== '' && rawContentFields[f] === ''
 11995	      );
 11996	
 11997	      // Handle photo upload — Backtracking audit, Phase 5 (R4-2). Capture the
 11998	      // OLD path before anything is reassigned (`lesson` is replaced below);
 11999	      // the new photo goes to its own unique path; the old object is deleted
 12000	      // only AFTER Firestore confirms the save, and only if it's actually a
 12001	      // different object. Previously the delete ran right after the upload —
 12002	      // and because both used the same fixed path, it deleted the photo it
 12003	      // had just uploaded, leaving every replacement as a broken image.
 12004	      const oldPhotoPath = lesson.photoPath || null;
 12005	      const photoInput = form.photoInput;
 12006	      const hasNewPhoto = photoInput?.files?.length > 0;
 12007	      const pendingRemove = photoInput?.dataset?.pendingRemove === 'true';
 12008	      // Remember exactly which file THIS save is uploading, so the input is
 12009	      // cleared afterwards only if the user hasn't picked a different one
 12010	      // in the meantime.
 12011	      const uploadedFile = hasNewPhoto ? photoInput.files[0] : null;
 12012	
 12013	      if (hasNewPhoto) {
 12014	        if (showStatus && !closing) autoSaveStatus.textContent = 'Uploading photo...';
 12015	        const result = sdoc
 12016	          ? await uploadDayOffPlanPhoto(semKey, lesson.campId, lesson.projectTitle, photoInput.files[0])
 12017	          : await uploadSummerCampPhoto(semKey, lessonKey, photoInput.files[0]);
 12018	        updatedLesson.photoUrl = result.url;
 12019	        updatedLesson.photoPath = result.path;
 12020	        if (showStatus && !closing) autoSaveStatus.textContent = 'Saving...';
 12021	      } else if (pendingRemove && lesson.photoUrl) {
 12022	        // Remove photo — the Storage object is deleted after the save below.
 12023	        updatedLesson.photoUrl = '';
 12024	        updatedLesson.photoPath = '';
 12025	      }
 12026	
 12027	      // Save only this lesson — never bulk-overwrite all lessons, which would wipe
 12028	      // other teachers' content if memory state was stale
 12029	      const savedLesson = { ...lesson, ...updatedLesson };
 12030	      // fieldsToClear wins over updatedLesson's stale (pre-clear) value, so the
 12031	      // local cache matches what Firestore now actually holds.
 12032	      fieldsToClear.forEach(f => { savedLesson[f] = ''; });
 12033	      // What actually goes to Firestore is only what THIS save changed: the
 12034	      // dirty text fields, the photo fields if this save touched them, and
 12035	      // the edit metadata (clears travel separately as fieldsToClear). The
 12036	      // summer branch of saveSingleLesson() is a set-merge, so everything
 12037	      // omitted is left exactly as the server has it — an admin's Help Queue
 12038	      // reply in qaThread, a photo another client replaced, a planComplete
 12039	      // ticked from the camp view — instead of being overwritten with this
 12040	      // modal's copy of it. (The full savedLesson object above is for the
 12041	      // cache and this modal's own state, not for the write.)
 12042	      const photoChanged = hasNewPhoto || (pendingRemove && lesson.photoUrl);
 12043	      const payload = {
 12044	        // Identity fields always travel: they are derived from the lesson key
 12045	        // (idempotent), and a doc this save CREATES must carry them — the
 12046	        // Summer Camp App's orphan check queries this collection by
 12047	        // campName/teacher, and the wipe monitor tallies docs by teacher.
 12048	        // SDOC sends none: the save stamps identity from the camp, and
 12049	        // anything outside its allow-list is refused.
 12050	        ...(sdoc ? {} : {
 12051	          teacher: lesson.teacher,
 12052	          campName: lesson.campName,
 12053	          block: lesson.block,
 12054	          projectTitle: lesson.projectTitle,
 12055	          className: lesson.className,
 12056	        }),
 12057	        ...contentUpdates,
 12058	        lastEditedBy: updatedLesson.lastEditedBy,
 12059	        lastEditedAt: updatedLesson.lastEditedAt,
 12060	      };
 12061	      if (photoChanged) { payload.photoUrl = updatedLesson.photoUrl; payload.photoPath = updatedLesson.photoPath; }
 12062	      // Optimistic: the cache and the modal's lesson take the new content now
 12063	      // and are put back (below) if the write fails.
 12064	      previousCachedLesson = currentLessonData[semKey]?.[lessonKey];
 12065	      previousLessonRef = lesson;
 12066	      optimisticLesson = savedLesson;
 12067	      if (currentLessonData[semKey]) currentLessonData[semKey][lessonKey] = savedLesson;
 12068	      lesson = savedLesson;
 12069	      const result = await saveSingleLesson(semKey, lessonKey, payload, fieldsToClear, sdoc ? { dayOffAuth: dayOffAuthFor(semKey) } : undefined);
 12070	      // saveSingleLesson() stamps lastEditedBy/At onto the object it is given;
 12071	      // keep the cache copy identical to what was written.
 12072	      savedLesson.lastEditedBy = payload.lastEditedBy;
 12073	      savedLesson.lastEditedAt = payload.lastEditedAt;
 12074	
 12075	      let sdocNote = '';
 12076	      if (sdoc) {
 12077	        // The SDOC save installed the server's own copy (read back and
 12078	        // verified) — no clock-based re-install here: it could put my copy
 12079	        // back over a co-teacher's newer text, or re-create a renamed-away
 12080	        // slot (plan, round 4).
 12081	        lesson = currentLessonData[semKey]?.[lessonKey] || lesson;
 12082	        if (result?.status === 'savedSince') {
 12083	          sdocNote = result.own
 12084	            ? '✓ Saved — this plan was saved again just after, from another window or the Plan complete box; reopen to see the latest.'
 12085	            : `✓ Saved — ${result.by} has edited this plan since; reopen to see their changes.`;
 12086	        } else if (result?.status === 'renamed') {
 12087	          sdocNote = '✓ Saved — but this project was just renamed by the planner; reopen the camp.';
 12088	        }
 12089	      } else {
 12090	        // Save confirmed. If the listener swapped the summer cache out from
 12091	        // under this save with a read taken BEFORE the write landed, the cache
 12092	        // now shows pre-save content — put the confirmed copy back, unless
 12093	        // what's there is at least as new.
 12094	        const semCache = currentLessonData[semKey];
 12095	        if (semCache && semCache[lessonKey] !== savedLesson && editedAtOf(semCache[lessonKey]) < editedAtOf(savedLesson)) {
 12096	          semCache[lessonKey] = savedLesson;
 12097	        }
 12098	      }
 12099	      displacedSummerServerCopies.delete(displacedKey(semKey, lessonKey)); // this save is now the confirmed state; nothing parked applies
 12100	
 12101	      // Now, and only now, remove the superseded photo. A
 12102	      // cleanup failure leaves an orphan object in Storage, never a broken
 12103	      // reference in Firestore, so it is logged rather than surfaced as a
 12104	      // failed save.
 12105	      if (oldPhotoPath && oldPhotoPath !== (savedLesson.photoPath || null)) {
 12106	        try {
 12107	          await deleteLessonPhoto(oldPhotoPath);
 12108	        } catch (cleanupErr) {
 12109	          console.error('⚠️ Could not clean up old summer photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
 12110	        }

codex
Verdict: **NOT SAFE TO DEPLOY.**

The `lessonStoreFor() === 'weekly'` approach itself is viable: the identified weekly readers and writers route through `weeklyLessonTarget()`/`readWeeklySemesterMap()`, and Fall still resolves to `curriculum/lessonData` with the original dotted prefix. However, the following must be fixed before deploy.

1. Spring’s paused state is neither consistently visible nor side-effect-free.

   - The normal pre-move state shows no persistent “editing is paused” banner. The message exists only as an exception from [firebase-data.js:117](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:117).
   - Teacher saves convert it to the generic “Save failed” status at [app.js:3649](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3649).
   - Plan Complete silently rolls back with no user message at [app.js:2882](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:2882).
   - Admin edits report only “could not be saved” at [app.js:5831](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5831).
   - Teacher/admin photo saves upload to Storage before discovering that the Firestore write is paused: [app.js:3523](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3523) and [app.js:5795](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5795). This leaves orphaned uploads.
   - Cutting a Spring lesson writes the Cut Bank entry first, then the paused delete fails, producing a deliberate duplicate at [app.js:6372](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6372).
   - Saving Spring settings writes `appData` before lesson-slot creation hits the pause at [app.js:11427](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:11427). The UI reports an error even though the configuration already changed.

   Minimum fix: expose a common Spring-writability preflight and call it before every workflow’s first mutation, including Storage, Cut Bank, settings/config, optimistic UI, and multi-target operations. Render the paused state proactively and preserve the specific pause message in every catch path.

2. `recheckOwnDocAfterLegacyLoss()` can install stale state after a fast move/rollback.

   The asynchronous server read at [firebase-data.js:895](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:895) is launched without awaiting or generation/state validation at [firebase-data.js:1361](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1361). If rollback listeners restore legacy state while that read is in flight, its late result can set `ownDocSource = 'ownDoc'` and replace Spring with the now-deleted copy. There may be no later snapshot to correct it.

   Minimum fix: give own-document checks/listeners a generation or transition token and apply results only if the triggering legacy-loss state is still current. Cover both move→rollback orderings.

3. Studio Hub dismissal cleanup is incorrect after ID migration.

   Migration adds the semester-qualified dismissal at [alerts.js:578](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:578), but resolution removes only the new ID at [alerts.js:655](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:655). The legacy `classbook-qa-<lessonKey>` dismissal remains forever. A later question for that lesson—potentially in any semester—is immediately re-dismissed.

   Minimum fix: when no outstanding Classbook alert still uses a legacy ID, remove that legacy dismissal too. Preserve it while another same-key semester alert remains active.

4. Studio Hub drops Spring alerts on an own-document listener error.

   The error handler replaces the last good own-doc snapshot with `null` and rebuilds at [alerts.js:619](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:619). After the move, legacy contains no Spring, so the rebuild prunes every Spring alert. A transient/read-permission failure therefore looks like “all Spring questions resolved.”

   Minimum fix: retain the last good source on listener error and avoid destructive pruning for the failed source. Initial-error behavior also needs an explicit degraded-state policy.

5. Tests do not exercise the risky behavior above or the Phase B end-to-end acceptance.

   The Classbook spec directly invokes low-level writers at [spring-own-doc.spec.js:51](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/spring-own-doc.spec.js:51), but does not exercise teacher/admin UI saves, Q&A send/reply, photos, Cut Bank, settings, copy, move/swap pause behavior, listener errors, or the late `recheckOwnDocAfterLegacyLoss()` race. Its “other semester” check uses a fabricated key rather than Fall. Studio Hub tests cover only the pure union builder, not listener rebuilds, migration cleanup, or errors.

   The admin reset helper is emulator-guarded and the suite currently uses one worker, which prevents ordinary cross-test concurrency. However, it full-overwrites shared `lessonData` and relies on `afterAll` cleanup at [storage-move.js:33](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/helpers/storage-move.js:33); this should be documented as suite-global or changed to snapshot/restore the exact pre-test documents in `afterEach`.

No files were edited and no tests were run, as requested.
tokens used
142,769
Verdict: **NOT SAFE TO DEPLOY.**

The `lessonStoreFor() === 'weekly'` approach itself is viable: the identified weekly readers and writers route through `weeklyLessonTarget()`/`readWeeklySemesterMap()`, and Fall still resolves to `curriculum/lessonData` with the original dotted prefix. However, the following must be fixed before deploy.

1. Spring’s paused state is neither consistently visible nor side-effect-free.

   - The normal pre-move state shows no persistent “editing is paused” banner. The message exists only as an exception from [firebase-data.js:117](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:117).
   - Teacher saves convert it to the generic “Save failed” status at [app.js:3649](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3649).
   - Plan Complete silently rolls back with no user message at [app.js:2882](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:2882).
   - Admin edits report only “could not be saved” at [app.js:5831](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5831).
   - Teacher/admin photo saves upload to Storage before discovering that the Firestore write is paused: [app.js:3523](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3523) and [app.js:5795](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5795). This leaves orphaned uploads.
   - Cutting a Spring lesson writes the Cut Bank entry first, then the paused delete fails, producing a deliberate duplicate at [app.js:6372](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6372).
   - Saving Spring settings writes `appData` before lesson-slot creation hits the pause at [app.js:11427](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:11427). The UI reports an error even though the configuration already changed.

   Minimum fix: expose a common Spring-writability preflight and call it before every workflow’s first mutation, including Storage, Cut Bank, settings/config, optimistic UI, and multi-target operations. Render the paused state proactively and preserve the specific pause message in every catch path.

2. `recheckOwnDocAfterLegacyLoss()` can install stale state after a fast move/rollback.

   The asynchronous server read at [firebase-data.js:895](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:895) is launched without awaiting or generation/state validation at [firebase-data.js:1361](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1361). If rollback listeners restore legacy state while that read is in flight, its late result can set `ownDocSource = 'ownDoc'` and replace Spring with the now-deleted copy. There may be no later snapshot to correct it.

   Minimum fix: give own-document checks/listeners a generation or transition token and apply results only if the triggering legacy-loss state is still current. Cover both move→rollback orderings.

3. Studio Hub dismissal cleanup is incorrect after ID migration.

   Migration adds the semester-qualified dismissal at [alerts.js:578](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:578), but resolution removes only the new ID at [alerts.js:655](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:655). The legacy `classbook-qa-<lessonKey>` dismissal remains forever. A later question for that lesson—potentially in any semester—is immediately re-dismissed.

   Minimum fix: when no outstanding Classbook alert still uses a legacy ID, remove that legacy dismissal too. Preserve it while another same-key semester alert remains active.

4. Studio Hub drops Spring alerts on an own-document listener error.

   The error handler replaces the last good own-doc snapshot with `null` and rebuilds at [alerts.js:619](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:619). After the move, legacy contains no Spring, so the rebuild prunes every Spring alert. A transient/read-permission failure therefore looks like “all Spring questions resolved.”

   Minimum fix: retain the last good source on listener error and avoid destructive pruning for the failed source. Initial-error behavior also needs an explicit degraded-state policy.

5. Tests do not exercise the risky behavior above or the Phase B end-to-end acceptance.

   The Classbook spec directly invokes low-level writers at [spring-own-doc.spec.js:51](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/spring-own-doc.spec.js:51), but does not exercise teacher/admin UI saves, Q&A send/reply, photos, Cut Bank, settings, copy, move/swap pause behavior, listener errors, or the late `recheckOwnDocAfterLegacyLoss()` race. Its “other semester” check uses a fabricated key rather than Fall. Studio Hub tests cover only the pure union builder, not listener rebuilds, migration cleanup, or errors.

   The admin reset helper is emulator-guarded and the suite currently uses one worker, which prevents ordinary cross-test concurrency. However, it full-overwrites shared `lessonData` and relies on `afterAll` cleanup at [storage-move.js:33](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/helpers/storage-move.js:33); this should be documented as suite-global or changed to snapshot/restore the exact pre-test documents in `afterEach`.

No files were edited and no tests were run, as requested.
