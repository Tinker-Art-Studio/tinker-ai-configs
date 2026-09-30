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
session id: 01a0f07d-7acc-7871-97ed-db05740210a3
--------
user
## Implementation review round 2 — Phase B (Classbook + Studio Hub alerts)
Round 1 (Codex): /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-codex.md — five findings.
Full diffs now:
- Classbook: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-classbook.diff (worktree read-only: /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81)
- Studio Hub: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-studiohub.diff (worktree read-only: /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc; includes the new alerts-classbook.test.js)
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase B). Phase A rules are live (studio-hub 0caf415).
1. For each round-1 finding: RESOLVED / NOT with file:line.
2. Adversarially check the fixes and the whole change again: any Spring workflow that still writes something before refusing (search every caller of saveSingleLesson / saveMultipleLessonFields / deleteLessonKey / saveLessonData / uploadLessonPhoto / saveCutProjects / updateAppData that can act on a weekly semester); anything that changes behaviour for Fall or other semesters; the token logic; the standing notice; the Studio Hub migration-once marker and error handling; test quality.
Verdict: SAFE TO DEPLOY or NOT (minimum list). Do not edit files or run tests.
codex
I’ll do a read-only review against the Phase B plan, the round-1 findings, both full diffs, and the relevant caller graph. I won’t edit files or execute tests.
exec
/bin/zsh -lc "sed -n '1,240p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-codex.md && sed -n '1,280p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
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

exec
/bin/zsh -lc 'rg -n "''^(#|##|###|[1-5]'"\\. |Verdict|SAFE|NOT)|RESOLVED|Finding|minimum\" /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-codex.md | tail -120" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
14:## Implementation review — Phase B (Classbook + Studio Hub alerts), before deploy
21:1. Can any lesson edit be lost, misrouted, duplicated, or silently refused for any semester (Fall especially — it must behave exactly as before)? Every writer and reader of weekly lessons, incl. paths not in the diff that read/write currentLessonData and then persist.
22:2. Listener logic: initial load vs listener ordering, the legacy carry-across, recheckOwnDocAfterLegacyLoss, the move and rollback transitions, error states, teardown/double registration, interaction with globalListenerGeneration / reloadSummer / lessonDataLoadedSuccessfully, SDOC and camp seasons.
23:3. The "editing is paused" window: every Spring write path refused with a clear message (none throwing obscure errors or half-writing); what the UI shows.
24:4. Studio Hub alerts: union/rebuild correctness, dismissal migration, cleanup, errors.
25:5. Tests: meaningful and non-leaking (the admin reset helper), gaps.
26:Verdict: SAFE TO DEPLOY or NOT (minimum list). Do not edit files or run tests.
40:## claude/spring-own-doc...origin/claude/spring-own-doc
45:## claude/classbook-alerts-own-doc...origin/claude/classbook-alerts-own-doc
279:  <strong>Sep 29, 2026: revision 3, after Codex's independent round 1 (<code>…-codex-r1.md</code>): NOT ready, 8-point minimum list, all verified and taken.</strong>
301:  <strong>Sep 29, 2026: revision 2, after review round 1 (Claude; <code>thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md</code>): NOT ready, 11-point minimum list, all taken.</strong> Re-scoped to <strong>Spring only, hard-coded</strong>, with no appData flags, <code>migratedSemesters</code>, UI buttons or "Move back". The copy and the removal are reviewed console procedures. The rules fence uses a literal key (no <code>get(appData)</code>), splits <code>:654</code>, and ships <strong>first</strong>. Fixed: the listener drops own-doc semesters (A); verify races (B, moot now that the fence freezes the source first); Phase D's precondition compares against the hash of what was written (C); vanished keys are loud (D); <code>not-found</code> on first write (E); <code>createNewSemester</code>/<code>deleteSemester</code> deferred to the follow-up plan, with a deadline (F, delete); the missing readers are added (<code>tinker-backups/backup.js</code>, which is Christie's edit, the in-app content count, <code>test-alerts.js</code>, dead backup helpers, e2e exemptions, seed); the backup citation and "nightly" are corrected; the listener generation is decided (no bump); teardown uses an array; a near-1 MB rules fixture is added; there's a headroom readout; and the emergency lever's order is fixed.<br>
1582:  <strong>Sep 29, 2026: revision 3, after Codex's independent round 1 (<code>…-codex-r1.md</code>): NOT ready, 8-point minimum list, all verified and taken.</strong>
1604:  <strong>Sep 29, 2026: revision 2, after review round 1 (Claude; <code>thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md</code>): NOT ready, 11-point minimum list, all taken.</strong> Re-scoped to <strong>Spring only, hard-coded</strong>, with no appData flags, <code>migratedSemesters</code>, UI buttons or "Move back". The copy and the removal are reviewed console procedures. The rules fence uses a literal key (no <code>get(appData)</code>), splits <code>:654</code>, and ships <strong>first</strong>. Fixed: the listener drops own-doc semesters (A); verify races (B, moot now that the fence freezes the source first); Phase D's precondition compares against the hash of what was written (C); vanished keys are loud (D); <code>not-found</code> on first write (E); <code>createNewSemester</code>/<code>deleteSemester</code> deferred to the follow-up plan, with a deadline (F, delete); the missing readers are added (<code>tinker-backups/backup.js</code>, which is Christie's edit, the in-app content count, <code>test-alerts.js</code>, dead backup helpers, e2e exemptions, seed); the backup citation and "nightly" are corrected; the listener generation is decided (no bump); teardown uses an array; a near-1 MB rules fixture is added; there's a headroom readout; and the emergency lever's order is fixed.<br>
11540:Two deploy blockers are now confirmed. First, the pause is enforced only at the low-level target helper, so several UI workflows hide the pause reason or perform side effects before that helper is reached (notably photo upload and Cut Bank archival). Second, Studio Hub’s legacy-dismissal migration never removes the old dismissal when the underlying question resolves, so future questions on that lesson key can remain dismissed indefinitely. I’m finishing the transition-race and test-isolation pass before giving the minimum list.
11910:Verdict: **NOT SAFE TO DEPLOY.**
11914:1. Spring’s paused state is neither consistently visible nor side-effect-free.
11926:2. `recheckOwnDocAfterLegacyLoss()` can install stale state after a fast move/rollback.
11932:3. Studio Hub dismissal cleanup is incorrect after ID migration.
11938:4. Studio Hub drops Spring alerts on an own-document listener error.
11944:5. Tests do not exercise the risky behavior above or the Phase B end-to-end acceptance.
11953:Verdict: **NOT SAFE TO DEPLOY.**
11957:1. Spring’s paused state is neither consistently visible nor side-effect-free.
11969:2. `recheckOwnDocAfterLegacyLoss()` can install stale state after a fast move/rollback.
11975:3. Studio Hub dismissal cleanup is incorrect after ID migration.
11981:4. Studio Hub drops Spring alerts on an own-document listener error.
11987:5. Tests do not exercise the risky behavior above or the Phase B end-to-end acceptance.

exec
/bin/zsh -lc "sed -n '11890,12010p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-codex.md && wc -l /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-classbook.diff /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-studiohub.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
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
    1133 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-classbook.diff
     468 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-studiohub.diff
    1601 total

codex
I’ve recovered the exact five round-1 blockers. I’m now tracing each fix into the current worktrees, then I’ll independently inventory every named writer and its callers—especially compound workflows where a non-lesson mutation could precede the Spring refusal.
exec
/bin/zsh -lc "sed -n '1,420p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-classbook.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
diff --git a/css/styles.css b/css/styles.css
index 749d3c7..55c11df 100644
--- a/css/styles.css
+++ b/css/styles.css
@@ -2427,6 +2427,15 @@ label[for="ca-semester-select"] {
   font-weight: 500;
 }
 .lesson-load-error-banner.hidden { display: none; }
+/* Spring 2026 storage move notices (own-doc semesters): same place, calmer colours. */
+.storage-notice {
+  background: #eff6ff;
+  border-left: 4px solid #3b82f6;
+  color: #1e3a8a;
+  padding: 14px 24px;
+  font-weight: 500;
+}
+.storage-notice.hidden { display: none; }
 
 .tv-controls {
   display: flex;
diff --git a/e2e/data-safety.spec.js b/e2e/data-safety.spec.js
index 58aaaf9..6037ce7 100644
--- a/e2e/data-safety.spec.js
+++ b/e2e/data-safety.spec.js
@@ -8695,9 +8695,14 @@ test.describe('Data Safety — camp seasons Phase 1: implementation-review regre
         const savedMappings = currentConfig.teacherMappings;
         const realGet = window.getTeacherMappingsFromForm;
         window.getTeacherMappingsFromForm = () => ({ 'TEST Teacher': 'test-uid-123' });
-        // Drive a real semester-field change through the form.
+        // Drive a real semester-field change through the form — on a throwaway
+        // weekly semester: the seeded spring-2026 is view-only while it moves to
+        // its own storage (Spring 2026 storage move), and saveSettings refuses it.
+        const previousGlobal = globalSemesterKey;
+        currentConfig.semesters['e2e-settings-weekly'] = { ...JSON.parse(JSON.stringify(currentConfig.semesters['spring-2026'])), name: 'E2E Settings Weekly' };
+        setGlobalSemester('e2e-settings-weekly');
+        loadSettingsForm();
         const semKey = getSettingsSemKey();
-        const savedSem = JSON.parse(JSON.stringify(currentConfig.semesters[semKey] || {}));
         const weeksEl = document.getElementById('settings-num-weeks');
         const savedWeeks = weeksEl.value;
         weeksEl.value = '14';
@@ -8711,7 +8716,8 @@ test.describe('Data Safety — camp seasons Phase 1: implementation-review regre
           };
         } finally {
           weeksEl.value = savedWeeks;
-          currentConfig.semesters[semKey] = savedSem;
+          delete currentConfig.semesters['e2e-settings-weekly'];
+          setGlobalSemester(previousGlobal);
           window.updateAppData = realUpdate;
           window.getTeacherMappingsFromForm = realGet;
           currentConfig.teacherMappings = savedMappings;
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
index 0000000..7ca2a71
--- /dev/null
+++ b/e2e/spring-own-doc.spec.js
@@ -0,0 +1,280 @@
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
+// Suite-global state: these tests rewrite curriculum/lessonData, lessons_spring-2026
+// and storageMigrations, so every test starts from AND ends at the seeded state.
+test.beforeEach(async () => { await SM.resetStorageMove(); });
+test.afterEach(async () => { await SM.resetStorageMove(); });
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
+    // Fall still saves to lessonData, exactly as before.
+    expect(await call(page, () => saveSingleLesson('fall-2026', 'e2e-lesson', { shortDetails: 'Fall' }))).toBe('ok');
+    expect((await SM.readCurriculumDoc('lessonData'))['fall-2026']['e2e-lesson'].shortDetails).toBe('Fall');
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
+
+  test('while paused, every Spring workflow refuses up front with the pause message and changes nothing', async ({ page }) => {
+    await openApp(page);
+    await page.evaluate(() => setGlobalSemester('spring-2026'));
+    const alerts = [];
+    page.on('dialog', d => { alerts.push(d.message()); d.accept(); });
+    const docs = ['lessonData', 'cutProjects', 'appData', 'futureProjects', 'changeLog'];
+    const before = {};
+    for (const d of docs) before[d] = await SM.readCurriculumDoc(d);
+    const uploads = await page.evaluate(() => { window.__uploads = 0; const orig = window.uploadLessonPhoto; if (orig) window.uploadLessonPhoto = (...a) => { window.__uploads++; return orig(...a); }; return !!orig; });
+
+    const workflows = {
+      cutProject: ({ LESSON }) => cutProject(LESSON),
+      executeCopyPlan: ({ LESSON }) => executeCopyPlan(LESSON),
+      pasteFromCutBank: () => pasteFromCutBank(0, 'Fixture Teacher', 'Fixture Class', 9),
+      pasteFromIdeaBank: () => pasteFromIdeaBank(0, 'Fixture Teacher', 'Fixture Class', 9),
+      handleGridAction: () => handleGridAction('Fixture Teacher', 'Fixture Class', 9, 'x'),
+      saveSettings: () => { loadSettingsForm(); return saveSettings(); },
+    };
+    for (const [name, fn] of Object.entries(workflows)) {
+      alerts.length = 0;
+      expect(await call(page, fn, { LESSON }), name).toBe('ok');
+      expect(alerts.join(' | '), `${name} should say editing is paused`).toMatch(PAUSED);
+    }
+    for (const d of docs) expect(await SM.readCurriculumDoc(d), `${d} must be unchanged`).toEqual(before[d]);
+    if (uploads) expect(await page.evaluate(() => window.__uploads)).toBe(0);
+  });
+
+  test('a standing notice shows while Spring is paused, and goes away elsewhere or once verified', async ({ page }) => {
+    await openApp(page);
+    await page.evaluate(() => setGlobalSemester('spring-2026'));
+    await expect(page.locator('#own-doc-paused-notice')).toBeVisible();
+    await expect(page.locator('#own-doc-paused-notice')).toContainText('editing it is paused');
+    await page.evaluate(() => setGlobalSemester('summer-2026'));
+    await expect(page.locator('#own-doc-paused-notice')).toBeHidden();
+    await page.evaluate(() => setGlobalSemester('spring-2026'));
+    await SM.stageMoved({ verified: true });
+    await page.waitForFunction(() => ownDocSource['spring-2026'] === 'ownDoc' && storageMigrationState?.['spring-2026']?.verified === true, null, { timeout: 15_000 });
+    await expect(page.locator('#own-doc-paused-notice')).toBeHidden();
+  });
+
+  test('a superseded recheck (a newer snapshot arrived meanwhile) applies nothing', async ({ page }) => {
+    await openApp(page);   // legacy state: no own doc
+    const superseded = await page.evaluate(async () => {
+      const t = bumpOwnDocToken('spring-2026');
+      const p = recheckOwnDocAfterLegacyLoss('spring-2026', null, t);
+      bumpOwnDocToken('spring-2026');          // a newer snapshot spoke first
+      await p;
+      const el = document.getElementById('storage-notice-banner');
+      return { shown: !!el && !el.classList.contains('hidden'), source: ownDocSource['spring-2026'] };
+    });
+    expect(superseded).toEqual({ shown: false, source: 'legacy' });
+    const current = await page.evaluate(async () => {
+      const t = bumpOwnDocToken('spring-2026');
+      await recheckOwnDocAfterLegacyLoss('spring-2026', null, t);   // nothing newer: it reports
+      const el = document.getElementById('storage-notice-banner');
+      return !!el && !el.classList.contains('hidden');
+    });
+    expect(current).toBe(true);
+  });
+
+  test('ratchet: each Spring workflow checks the pause before its first change', () => {
+    const src = fs.readFileSync(path.join(__dirname, '..', 'js', 'app.js'), 'utf8');
+    const body = (name) => {
+      const start = src.indexOf(`function ${name}(`);
+      expect(start, `${name} not found`).toBeGreaterThan(-1);
+      return src.slice(start, src.indexOf('\n}\n', start));
+    };
+    for (const name of ['saveAdminEdit', 'executeCopyPlan', 'pasteFromCutBank', 'pasteFromIdeaBank', 'handleGridAction', 'cutProject', 'saveSettings', 'saveTeacherEdit']) {
+      const b = body(name);
+      const guard = b.indexOf('refuseIfWeeklySemesterPaused(');
+      expect(guard, `${name} must call refuseIfWeeklySemesterPaused`).toBeGreaterThan(-1);
+      const firstAwait = b.search(/\bawait\b/);
+      expect(firstAwait === -1 || guard < firstAwait, `${name}: the pause check must come before the first await`).toBe(true);
+    }
+    const cards = body('attachCardListeners');
+    expect(cards.indexOf('refuseIfWeeklySemesterPaused(')).toBeGreaterThan(-1);
+    expect(cards.indexOf('refuseIfWeeklySemesterPaused(')).toBeLessThan(cards.indexOf('{ planComplete: cb.checked }'));
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

exec
/bin/zsh -lc "sed -n '421,850p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-classbook.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
+      </section>
+
       <!-- Backup Health (Data Safety Plan Stage 4B) -->
       <section class="ca-section ca-backup-health-section">
         <button class="ca-section-toggle" id="ca-backup-health-toggle" onclick="toggleBackupHealth()">
diff --git a/js/app.js b/js/app.js
index ca92b37..af3745d 100644
--- a/js/app.js
+++ b/js/app.js
@@ -98,6 +98,7 @@ function setGlobalSemester(key) {
 
   globalSemesterKey = key;
   localStorage.setItem('globalSemesterKey', key);
+  updateOwnDocPausedNotice();   // Spring 2026 storage move: standing "editing is paused" notice
 
   // Hide/show Prep Dashboard tab based on semester type
   const semester = currentConfig.semesters[key];
@@ -168,6 +169,7 @@ document.addEventListener('DOMContentLoaded', async () => {
 
   // Pre-load lesson data on startup so any load failure is detected immediately
   await loadLessonData();
+  updateOwnDocPausedNotice();   // Spring 2026 storage move: standing notice if the selected semester is paused
   if (lessonDataLoadedSuccessfully === false) {
     document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
   }
@@ -2876,6 +2878,7 @@ function attachCardListeners(container) {
       const lessons = currentLessonData?.[semKey];
       if (!lessons || !lessons[lessonKey]) return;
 
+      if (refuseIfWeeklySemesterPaused(semKey)) { cb.checked = !cb.checked; return; }   // Spring storage move: nothing changes
       const lesson = lessons[lessonKey];
       lesson.planComplete = cb.checked;
 
@@ -2888,6 +2891,7 @@ function attachCardListeners(container) {
         console.error('Error saving plan complete:', err);
         cb.checked = !cb.checked; // revert
         lesson.planComplete = cb.checked;
+        if (err?.message === OWN_DOC_PAUSED_MESSAGE) alert(OWN_DOC_PAUSED_MESSAGE);
       }
     });
   });
@@ -3505,6 +3509,9 @@ async function saveTeacherEdit(lessonKey, originalLesson) {
     return;
   }
 
+  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
+  if (refuseIfWeeklySemesterPaused(getTvSemKey())) return;
+
   if (saveBtn) { saveBtn.disabled = true; saveBtn.textContent = 'Saving...'; }
   if (autoSaveStatus) autoSaveStatus.textContent = 'Saving...';
 
@@ -3650,6 +3657,7 @@ async function saveTeacherEdit(lessonKey, originalLesson) {
     console.error('Error saving lesson:', err);
     if (saveBtn) { saveBtn.disabled = false; saveBtn.textContent = 'Save'; }
     if (autoSaveStatus) { autoSaveStatus.textContent = '⚠️ Save failed'; autoSaveStatus.style.color = 'var(--error)'; }
+    if (err?.message === OWN_DOC_PAUSED_MESSAGE) alert(OWN_DOC_PAUSED_MESSAGE);
   }
 }
 
@@ -3728,18 +3736,25 @@ async function sendTeacherQaMessage(lessonKey, modalSemKey) {
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
@@ -4579,6 +4594,12 @@ function renderSemesterSelector() {
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
@@ -5616,6 +5637,8 @@ async function saveAdminEdit(key, teacher, className, weekNum) {
     alert('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
     return;
   }
+  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
+  if (refuseIfWeeklySemesterPaused(getAdminSemKey())) return;
 
   caEditSaveInFlight = true;
   // Every action button in the modal body — the form's own Save/Print/Cancel
@@ -5821,7 +5844,7 @@ async function saveAdminEditInner(key, teacher, className, weekNum, title) {
     // and log a fake edit even though the save never actually succeeded. The
     // snapshot is kept so the still-open popup can retry against it.
     console.error('❌ Admin edit failed to save:', err);
-    alert('This edit could not be saved. Please try again.');
+    alert(err?.message === OWN_DOC_PAUSED_MESSAGE ? OWN_DOC_PAUSED_MESSAGE : 'This edit could not be saved. Please try again.');
     return;
   }
 
@@ -5884,8 +5907,8 @@ function cancelGridAction() {
 async function readAdminLessonDoc(semKey, lessonKey, opts = {}) {
   if (!curriculumDb) initCurriculumFirestore();
   const getOpts = opts.source === 'server' ? { source: 'server' } : undefined;
-  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
-  return snap.exists ? (snap.data()?.[semKey]?.[lessonKey] || null) : null;
+  const map = await readWeeklySemesterMap(semKey, getOpts);   // own-doc semesters read their own document
+  return map?.[lessonKey] || null;
 }
 
 // Backtracking audit, Phase 8: shared by cutProject() below and Phase 11's
@@ -5930,6 +5953,8 @@ function restoreGridActionState(semKey, sourceKey, sourceLesson, destKey, destLe
 
 async function handleGridAction(destTeacher, destClassName, destWeekNum, destKey) {
   const semKey = getAdminSemKey();
+  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
+  if (refuseIfWeeklySemesterPaused(semKey)) { cancelGridAction(); return; }
   const lessons = { ...currentLessonData[semKey] };
   const sourceLesson = lessons[caSourceKey];
 
@@ -6206,6 +6231,8 @@ function toggleCopyAll(masterCb) {
 // failure.
 async function executeCopyPlan(sourceKey) {
   const semKey = getAdminSemKey();
+  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
+  if (refuseIfWeeklySemesterPaused(semKey)) return;
   const liveLessons = currentLessonData?.[semKey];
   const source = liveLessons?.[sourceKey];
   if (!source) return;
@@ -6317,6 +6344,8 @@ async function executeCopyPlan(sourceKey) {
 // archive save leaves the live lesson completely untouched.
 async function cutProject(key) {
   const semKey = getAdminSemKey();
+  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
+  if (refuseIfWeeklySemesterPaused(semKey)) return;
   const lessons = { ...currentLessonData[semKey] };
   const lesson = lessons[key];
   if (!lesson) return;
@@ -6479,6 +6508,8 @@ async function showPasteFromCutBank(teacher, className, weekNum) {
 // conversation even with qaThread itself correctly omitted.
 async function pasteFromCutBank(cutIndex, teacher, className, weekNum, sourceSemKey) {
   const destSemKey = getAdminSemKey();
+  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
+  if (refuseIfWeeklySemesterPaused(destSemKey)) return;
   const srcSemKey = sourceSemKey || destSemKey;
   const cutProjects = currentCutProjects?.[srcSemKey] || [];
   const proj = cutProjects[cutIndex];
@@ -6949,6 +6980,8 @@ function showPasteFromIdeaBank(teacher, className, weekNum) {
 // lesson-save-then-idea-removal ordering with an honest duplicate-message on
 // a removal failure.
 async function pasteFromIdeaBank(idx, teacher, className, weekNum) {
+  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
+  if (refuseIfWeeklySemesterPaused(getAdminSemKey())) return;
   const projects = currentFutureProjects?.projects || [];
   const proj = projects[idx];
   if (!proj) return;
@@ -7236,6 +7269,10 @@ async function sendHelpResponse(key) {
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
@@ -7243,15 +7280,15 @@ async function sendHelpResponse(key) {
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
@@ -7321,20 +7358,24 @@ async function sendQaReply(key) {
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
@@ -7569,7 +7610,17 @@ async function computeLiveContentCountByTeacher() {
 
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
@@ -7651,6 +7702,27 @@ async function renderContentCount() {
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
@@ -11286,6 +11358,10 @@ async function saveSettings() {
     return;
   }
 
+  // Spring 2026 storage move: its settings save also writes lesson slots, so it's
+  // refused whole, before appData is touched.
+  if (refuseIfWeeklySemesterPaused(getSettingsSemKey())) return;
+
   const breakWeeksStr = el('settings-break-weeks');
   const breakWeeks = breakWeeksStr.split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n));
   const closureDates = parseClosureDates(el('settings-closure-dates'));
diff --git a/js/firebase-data.js b/js/firebase-data.js
index c562679..656abef 100644
--- a/js/firebase-data.js
+++ b/js/firebase-data.js
@@ -12,6 +12,7 @@ let curriculumDb = null;
 let configUnsubscribe = null;
 let prepDataUnsubscribe = null;
 let lessonDataUnsubscribe = null;
+let ownDocUnsubscribes = [];   // own-doc semester + storageMigrations listeners (Spring 2026 storage move)
 
 // The content fields a lesson's stripping/hasContent/wipe-detection logic
 // treats as "real plan content" (as opposed to metadata like teacher/weekNum).
@@ -71,6 +72,142 @@ function lessonStoreFor(semKey) {
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
+// Whether a weekly semester's lessons can be written right now. Every workflow
+// that writes lessons calls refuseIfWeeklySemesterPaused() BEFORE its first
+// change of any kind (photo upload, cut bank, config, optimistic UI), so a paused
+// Spring action changes nothing at all instead of half-happening.
+function weeklySemesterPausedMessage(semKey) {
+  if (!isOwnDocSemester(semKey)) return null;
+  return (ownDocSource[semKey] === 'ownDoc' && ownDocMoveVerified(semKey)) ? null : OWN_DOC_PAUSED_MESSAGE;
+}
+function refuseIfWeeklySemesterPaused(semKey) {
+  const message = weeklySemesterPausedMessage(semKey);
+  if (!message) return false;
+  alert(message);
+  return true;
+}
+// A standing notice while the selected semester is paused, so nobody discovers
+// it by losing a save. Called on load, on semester change and on every state change.
+function updateOwnDocPausedNotice() {
+  const semKey = typeof globalSemesterKey !== 'undefined' ? globalSemesterKey : null;
+  const el = document.getElementById('own-doc-paused-notice');
+  const message = semKey ? weeklySemesterPausedMessage(semKey) : null;
+  if (!message) { el?.classList.add('hidden'); return; }
+  if (el) { el.textContent = `ℹ️ ${message}`; el.classList.remove('hidden'); return; }
+  const div = document.createElement('div');
+  div.id = 'own-doc-paused-notice';
+  div.className = 'storage-notice';
+  div.textContent = `ℹ️ ${message}`;
+  const anchorEl = document.getElementById('lesson-load-error-banner');
+  if (anchorEl?.parentNode) anchorEl.parentNode.insertBefore(div, anchorEl.nextSibling);
+  else document.body.prepend(div);
+}
+
+// Bumped on every own-doc or legacy snapshot for a semester, so an in-flight
+// recheck (below) only applies its result if nothing has changed since it began.

exec
/bin/zsh -lc "sed -n '851,1220p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-classbook.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
+const ownDocTransitionToken = {};
+function bumpOwnDocToken(semKey) { ownDocTransitionToken[semKey] = (ownDocTransitionToken[semKey] || 0) + 1; return ownDocTransitionToken[semKey]; }
+
+function showStorageNotice(message) {
+  let el = document.getElementById('storage-notice-banner');
+  if (!el) {
+    el = document.createElement('div');
+    el.id = 'storage-notice-banner';
+    el.className = 'storage-notice';
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
@@ -756,11 +893,68 @@ async function loadOneCampSeason(plan, opts = {}) {
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
+async function recheckOwnDocAfterLegacyLoss(semKey, callback, token) {
+  try {
+    const own = await curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey)).get({ source: 'server' });
+    // A later snapshot (the own-doc listener, or a rollback) has spoken since this
+    // read began — its state is newer than this answer, so drop it.
+    if (ownDocTransitionToken[semKey] !== token || ownDocSource[semKey] === 'ownDoc') return;
+    if (own.exists) {
+      ownDocSource[semKey] = 'ownDoc';
+      currentLessonData[semKey] = ownDocLessonMap(own.data());
+      updateOwnDocPausedNotice();
+      if (callback) callback(currentLessonData);
+      return;
+    }
+  } catch (err) {
+    console.warn(`⚠️ Could not check curriculum/${ownDocIdFor(semKey)}:`, err);
+  }
+  if (ownDocTransitionToken[semKey] !== token) return;
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
@@ -812,12 +1006,18 @@ async function saveLessonData(semesterKey, lessons) {
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
 
@@ -827,8 +1027,9 @@ async function saveLessonData(semesterKey, lessons) {
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
@@ -960,6 +1161,9 @@ async function sendSummerLessonQaMessage(semKey, lessonKey, lesson, newMsg) {
 
 async function deleteLessonData(semesterKey) {
   if (!curriculumDb) initCurriculumFirestore();
+  // An own-doc semester's lessons aren't in lessonData (and the rules fence the
+  // key); deleting it is disabled until the follow-up plan routes it.
+  if (isOwnDocSemester(semesterKey)) throw new Error(`"${semesterKey}" can't be deleted while its storage is being changed.`);
   await curriculumDb.collection('curriculum').doc('lessonData').update({
     [semesterKey]: firebase.firestore.FieldValue.delete()
   });
@@ -972,8 +1176,7 @@ async function deleteLessonData(semesterKey) {
 // when its server-side delete failed). Backtracking audit, Phase 11.
 async function readServerSemesterLessonMap(semesterKey) {
   if (!curriculumDb) initCurriculumFirestore();
-  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
-  return snap.exists ? (snap.data()?.[semesterKey] ?? null) : null;
+  return await readWeeklySemesterMap(semesterKey, { source: 'server' });
 }
 
 async function backupLessonData(semesterKey) {
@@ -1114,6 +1317,8 @@ function setupLessonDataListener(callback) {
   if (!curriculumDb) initCurriculumFirestore();
   globalListenerGeneration++; // whatever the previous listener still has in flight is now stale
   if (lessonDataUnsubscribe) lessonDataUnsubscribe();
+  // The own-doc listeners (Spring 2026 storage move) are torn down together.
+  while (ownDocUnsubscribes.length) { try { ownDocUnsubscribes.pop()(); } catch (e) { /* already gone */ } }
 
   // One reload attempt for one snapshot generation. Only the latest
   // generation may touch the guard, the banner, or the summer cache.
@@ -1183,8 +1388,25 @@ function setupLessonDataListener(callback) {
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
+        const token = bumpOwnDocToken(semKey);
+        if (ownDocSource[semKey] === 'ownDoc' || ownDocSource[semKey] === 'error') {
+          if (previousOwn[semKey]) currentLessonData[semKey] = previousOwn[semKey];
+        } else if (!(semKey in currentLessonData) && previousOwn[semKey]) {
+          currentLessonData[semKey] = previousOwn[semKey];   // never blank it
+          recheckOwnDocAfterLegacyLoss(semKey, callback, token);
+        } else if (semKey in currentLessonData) {
+          document.getElementById('storage-notice-banner')?.classList.add('hidden');
+        }
+      }
       console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
 
       const outcome = await reloadSummer(myGeneration, previousSummer, 0);
@@ -1193,6 +1415,46 @@ function setupLessonDataListener(callback) {
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
+      updateOwnDocPausedNotice();
+    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; }));
+  for (const semKey of OWN_DOC_SEMESTERS) {
+    ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey))
+      .onSnapshot({ includeMetadataChanges: false }, snap => {
+        if (snap.metadata.fromCache && !snap.metadata.hasPendingWrites) return;
+        bumpOwnDocToken(semKey);
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
+        updateOwnDocPausedNotice();
+        if (callback) callback(currentLessonData);
+      }, err => {
+        console.error(`❌ ${ownDocIdFor(semKey)} listener error:`, err);
+        ownDocSource[semKey] = 'error';
+        showStorageNotice(`⚠️ ${semKey} lessons couldn't be loaded from their new storage — please reload the page.`);
+        updateOwnDocPausedNotice();
+      }));
+  }
 }
 
 // ─── Cut Projects (curriculum/cutProjects) ───────────
@@ -1431,11 +1693,12 @@ async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClea
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
@@ -1452,7 +1715,7 @@ async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClea
 // omitting their dotted path entirely — never sending an explicit empty
 // string — and applies clears AFTER the JSON sanitization pass, since
 // FieldValue.delete() is a special sentinel a JSON round-trip would corrupt.
-function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = []) {
+function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = [], prefix = `${semesterKey}.`) {
   // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above saveSingleLesson().
   const stripped = { ...lessonData };
   CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
@@ -1460,7 +1723,7 @@ function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToCle
   fieldsToClear.forEach(f => { cleanData[f] = firebase.firestore.FieldValue.delete(); });
   const updates = {};
   for (const [field, value] of Object.entries(cleanData)) {
-    updates[`${semesterKey}.${lessonKey}.${field}`] = value;
+    updates[`${prefix}${lessonKey}.${field}`] = value;
   }
   return updates;
 }
@@ -1485,19 +1748,20 @@ async function saveMultipleLessonFields(semesterKey, writes = [], deletes = [])
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

exec
/bin/zsh -lc "sed -n '1,560p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-studiohub.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
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
index 74f5b36..e0c34cc 100644
--- a/js/alerts.js
+++ b/js/alerts.js
@@ -557,94 +557,89 @@ const AlertEngine = (() => {
   // Classbook (Curriculum) Alerts
   // =====================================================
 
-  function listenToClassbook(db) {
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
+  // Stored among the dismissed ids once old-format Classbook dismissals are migrated.
+  const CLASSBOOK_QA_DISMISSALS_MIGRATED = 'classbook-qa-dismissals-migrated-v2';
 
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
+  function listenToClassbook(db) {
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
+      // One-time migration of dismissals saved under the pre-Sep-2026 id
+      // (classbook-qa-<lessonKey>): each currently-open question whose old id was
+      // dismissed gets its new id dismissed, then the old ids are retired, so an old
+      // dismissal can never hide a FUTURE question on the same lesson key (in any
+      // semester). A marker records that it ran; it only runs once every watched
+      // document has reported (see rebuild's guard above), so "currently open" is complete.
+      if (!dismissedAlertIds.has(CLASSBOOK_QA_DISMISSALS_MIGRATED)) {
+        const retired = new Set();
+        unansweredQuestions.forEach(alert => {
+          if (dismissedAlertIds.has(alert.legacyId)) {
+            dismissedAlertIds.add(alert.id);
+            retired.add(alert.legacyId);
           }
+        });
+        retired.forEach(id => dismissedAlertIds.delete(id));
+        dismissedAlertIds.add(CLASSBOOK_QA_DISMISSALS_MIGRATED);
+        saveDismissedAlerts();
+      }
+
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
+          // Keep the last good snapshot of this document (a transient error must not
+          // look like "all of this semester's questions were answered"). If it never
+          // arrived, carry on without it so the other semesters still alert.
+          console.error(`Classbook ${semKey} listener error:`, error);
+          if (!received.has(`lessons_${semKey}`)) {
+            received.add(`lessons_${semKey}`);
+            rebuild();
+          }
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
index 45f1582..630f0a4 100644
--- a/package.json
+++ b/package.json
@@ -1,7 +1,7 @@
 {
   "scripts": {
     "test": "npm run test:rules && npm run test:guard",
-    "test:rules": "firebase emulators:exec --only firestore \"node --experimental-vm-modules node_modules/.bin/jest rules.test.js archive-helpers.test.js archive-transaction.test.js\"",
+    "test:rules": "firebase emulators:exec --only firestore \"node --experimental-vm-modules node_modules/.bin/jest rules.test.js archive-helpers.test.js archive-transaction.test.js classbook-qa-alerts.test.js alerts-classbook.test.js\"",
     "test:guard": "bash scripts/deploy-rules.test.sh",
     "deploy:rules": "bash scripts/deploy-rules.sh"
   },
diff --git a/alerts-classbook.test.js b/alerts-classbook.test.js
new file mode 100644
index 0000000..75b2986
--- /dev/null
+++ b/alerts-classbook.test.js
@@ -0,0 +1,118 @@
+/**
+ * Runs the REAL js/alerts.js (AlertEngine) in a vm with a fake Firestore that lets
+ * the test fire each document listener by hand — the Classbook Q&A wiring only
+ * (union of lessonData + lessons_<semKey>, dismissal migration, listener errors).
+ * No emulator, no DOM (a no-op element proxy stands in for the UI).
+ * Run: npm test
+ */
+const vm = require('vm');
+const fs = require('fs');
+
+function loadEngine({ dismissed = [] } = {}) {
+  const el = () => new Proxy(function () {}, {
+    get: (t, k) => (k === 'classList' ? { add() {}, remove() {}, toggle() {}, contains() { return false; } }
+      : k === 'style' ? {} : k === 'children' ? [] : k === 'querySelectorAll' ? () => [] : el()),
+    set: () => true,
+    apply: () => el(),
+  });
+  const handlers = {};
+  const noopQuery = () => ({ onSnapshot: () => () => {}, where: noopQuery, orderBy: noopQuery, limit: noopQuery });
+  const db = {
+    collection: (c) => ({
+      doc: (d) => ({
+        onSnapshot: (next, error) => { handlers[`${c}/${d}`] = { next, error }; return () => {}; },
+        get: async () => ({ exists: false, data: () => ({}) }),
+        set: async () => {},
+        update: async () => {},
+      }),
+      where: noopQuery, orderBy: noopQuery, onSnapshot: () => () => {},
+    }),
+  };
+  const store = { studioHub_dismissedAlerts: JSON.stringify(dismissed) };
+  const ctx = {
+    console: { ...console, error: () => {}, warn: () => {}, log: () => {} },
+    Date, Set, Map, JSON, Math, Promise, setTimeout, clearTimeout, setInterval, clearInterval,
+    document: { getElementById: () => el(), querySelector: () => el(), querySelectorAll: () => [], createElement: () => el(), addEventListener() {} },
+    localStorage: { getItem: (k) => store[k] ?? null, setItem: (k, v) => { store[k] = v; } },
+    window: {},
+    firebase: { firestore: { FieldValue: { serverTimestamp: () => 0, arrayUnion: (...a) => a } } },
+  };
+  vm.createContext(ctx);
+  vm.runInContext(fs.readFileSync('js/classbook-qa-alerts.js', 'utf8'), ctx);
+  vm.runInContext(fs.readFileSync('js/alerts.js', 'utf8') + '\nthis.AlertEngine = AlertEngine;', ctx);
+  const snap = (data) => ({ exists: data !== null, data: () => data });
+  return {
+    engine: ctx.AlertEngine,
+    db,
+    fire: (docPath, data) => handlers[docPath].next(snap(data)),
+    fail: (docPath) => handlers[docPath].error(new Error('permission-denied')),
+    ids: () => ctx.AlertEngine.getAlerts().filter((a) => a.type === 'curriculum').map((a) => a.id).sort(),
+    dismissedIds: () => JSON.parse(store.studioHub_dismissedAlerts || '[]'),
+  };
+}
+
+const q = (message) => ({ teacher: 'T', qaThread: [{ from: 'teacher', message, timestamp: new Date().toISOString() }] });
+const LD = 'curriculum/lessonData';
+const SPRING = 'curriculum/lessons_spring-2026';
+
+describe('AlertEngine — Classbook Q&A across lessonData and own documents', () => {
+  test('nothing until every watched document has reported; then both semesters', async () => {
+    const h = loadEngine();
+    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
+    h.fire(LD, { 'fall-2026': { 'f-1': q('fall') }, lastUpdated: 'x' });
+    expect(h.ids()).toEqual([]);
+    h.fire(SPRING, { 's-1': q('spring'), lastUpdated: 'x' });
+    expect(h.ids()).toEqual(['classbook-qa-fall-2026-f-1', 'classbook-qa-spring-2026-s-1']);
+  });
+
+  test("one document's snapshot never removes the other's alerts", async () => {
+    const h = loadEngine();
+    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
+    h.fire(LD, { 'fall-2026': { 'f-1': q('fall') } });
+    h.fire(SPRING, { 's-1': q('spring') });
+    h.fire(LD, { 'fall-2026': {} });                 // Fall answered
+    expect(h.ids()).toEqual(['classbook-qa-spring-2026-s-1']);
+    h.fire(SPRING, { 's-1': { qaThread: [{ from: 'teacher', message: 'q' }, { from: 'admin', message: 'a' }] } });
+    expect(h.ids()).toEqual([]);
+  });
+
+  test('an own-document listener error keeps its last good alerts', async () => {
+    const h = loadEngine();
+    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
+    h.fire(LD, { 'fall-2026': {} });
+    h.fire(SPRING, { 's-1': q('spring') });
+    h.fail(SPRING);
+    h.fire(LD, { 'fall-2026': { 'f-2': q('new fall') } });
+    expect(h.ids()).toEqual(['classbook-qa-fall-2026-f-2', 'classbook-qa-spring-2026-s-1']);
+  });
+
+  test('an own-document error before its first snapshot still lets the others alert', async () => {
+    const h = loadEngine();
+    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
+    h.fire(LD, { 'fall-2026': { 'f-1': q('fall') } });
+    h.fail(SPRING);
+    expect(h.ids()).toEqual(['classbook-qa-fall-2026-f-1']);
+  });
+
+  test('old-format dismissals migrate once, then are retired (no future question is hidden)', async () => {
+    const h = loadEngine({ dismissed: ['classbook-qa-k-1', 'classbook-qa-k-9'] });
+    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
+    h.fire(LD, { 'fall-2026': { 'k-1': q('fall, dismissed before') } });
+    h.fire(SPRING, { 'k-1': q('spring, same key, dismissed before') });
+    expect(h.ids()).toEqual([]);                       // both still dismissed
+    const d = h.dismissedIds();
+    expect(d).toEqual(expect.arrayContaining(['classbook-qa-fall-2026-k-1', 'classbook-qa-spring-2026-k-1', 'classbook-qa-dismissals-migrated-v2']));
+    expect(d).not.toContain('classbook-qa-k-1');       // retired
+    // A later question on a key whose old dismissal wasn't open at migration time is NOT hidden.
+    h.fire(LD, { 'fall-2026': { 'k-1': q('fall'), 'k-9': q('brand new question') } });
+    expect(h.ids()).toEqual(['classbook-qa-fall-2026-k-9']);
+  });
+
+  test('after migration, an old id added back by an old tab has no effect', async () => {
+    const h = loadEngine({ dismissed: ['classbook-qa-dismissals-migrated-v2', 'classbook-qa-k-1'] });
+    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
+    h.fire(LD, { 'fall-2026': { 'k-1': q('open') } });
+    h.fire(SPRING, null);
+    expect(h.ids()).toEqual(['classbook-qa-fall-2026-k-1']);
+  });
+});

exec
/bin/zsh -lc "rg -n \"\\b(saveSingleLesson|saveMultipleLessonFields|deleteLessonKey|saveLessonData|uploadLessonPhoto|saveCutProjects|updateAppData)\\s*\\(\" js e2e --glob '"'!e2e/spring-own-doc.spec.js'"' --glob '"'!e2e/data-safety.spec.js'"' && rg -n \"function (saveTeacherEdit|saveAdminEdit|saveAdminEditInner|handleGridAction|executeCopyPlan|cutProject|pasteFromCutBank|pasteFromIdeaBank|saveSettings|sendTeacherQaMessage|sendHelpResponse|sendQaReply|attachCardListeners|createNewSemester|deleteSemester)\" js/app.js" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
e2e/day-off-camps.spec.js:700:      await tryIt('saveLessonData', () => saveLessonData(Y, { a: { introPitch: 'x' } }));
e2e/day-off-camps.spec.js:701:      await tryIt('saveSingleLesson', () => saveSingleLesson(Y, `${Y}|||c|||p`, { introPitch: 'x' }));   // SDOC branch: no such project, no dayOffAuth
e2e/helpers/firestore.js:182:// state. Mirrors js/firebase-data.js's saveSingleLesson() whole-object-replace
e2e/helpers/firestore.js:194:// saveSingleLesson()'s whole-object replace — that pattern is the production
e2e/helpers/firestore.js:198:// per-field-path technique as js/firebase-data.js's deleteLessonKey().
e2e/helpers/firestore.js:226:// deleteLessonKey(). Never deletes the shared lessonData document itself.
e2e/static-checks.spec.js:123:    // seen. Every appData write goes through updateAppData()'s field paths.
e2e/day-off-teacher.spec.js:233:    let r = await attempt(t, ({ Y, K, auth }) => saveSingleLesson(Y, K, { introPitch: 'TEST mine', closure: 'TEST closure' }, [], { dayOffAuth: auth }), { Y, K, auth });
e2e/day-off-teacher.spec.js:251:      try { return { ok: true, value: await saveSingleLesson(Y, K, payload, clears, { dayOffAuth: auth }) }; }
e2e/day-off-teacher.spec.js:286:      try { return { ok: true, value: await saveSingleLesson(Y, K, { closure: 'TEST first' }, [], { dayOffAuth: auth }) }; }
e2e/day-off-teacher.spec.js:337:      try { await saveSingleLesson(Y, K, { closure: 'TEST lost' }, [], { dayOffAuth: auth }); return { ok: true }; }
e2e/day-off-teacher.spec.js:390:      const r = await attempt(t, ({ Y, K, payload, clears, auth }) => saveSingleLesson(Y, K, payload, clears, { dayOffAuth: auth }), { Y, K, payload, clears, auth });
e2e/day-off-teacher.spec.js:394:    const noAuth = await attempt(t, ({ Y, K }) => saveSingleLesson(Y, K, { introPitch: 'x' }), { Y, K });
e2e/day-off-teacher.spec.js:397:    let r = await attempt(t, ({ Y, K, auth }) => saveSingleLesson(Y, K, { closure: 'TEST to clear' }, [], { dayOffAuth: auth }), { Y, K, auth });
e2e/day-off-teacher.spec.js:399:    r = await attempt(t, ({ Y, K, auth }) => saveSingleLesson(Y, K, {}, ['closure'], { dayOffAuth: auth }), { Y, K, auth });
e2e/day-off-teacher.spec.js:510:      await tryIt('saveLessonData', () => saveLessonData(Y, { [K]: { introPitch: 'x' } }));
e2e/day-off-teacher.spec.js:511:      await tryIt('saveMultipleLessonFields', () => saveMultipleLessonFields(Y, { [K]: { introPitch: 'x' } }));
e2e/day-off-teacher.spec.js:558:    let r = await attempt(t, ({ Y, K, auth }) => saveSingleLesson(Y, K, { introPitch: 'TEST old' }, [], { dayOffAuth: auth }), { Y, K, auth });
e2e/day-off-teacher.spec.js:570:      const saved = await saveSingleLesson(Y, K, { introPitch: 'TEST new' }, [], { dayOffAuth: auth });
e2e/day-off-teacher.spec.js:644:    r = await attempt(t, ({ Y, K, auth }) => saveSingleLesson(Y, K, { introPitch: 'TEST with tick' }, [], { dayOffAuth: auth }), { Y, K, auth });
js/firebase-data.js:297://                                   memory, writes allowed (updateAppData()
js/firebase-data.js:349:async function updateAppData(updates) {
js/firebase-data.js:990:// saveSingleLesson(): after a failed load, `lessons` is built from an empty or
js/firebase-data.js:996:async function saveLessonData(semesterKey, lessons) {
js/firebase-data.js:1027:async function deleteLessonKey(semesterKey, lessonKey) {
js/firebase-data.js:1203:  await saveLessonData(semesterKey, lessons);
js/firebase-data.js:1474:async function saveCutProjects(semesterKey, projects) {
js/firebase-data.js:1626:async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
js/firebase-data.js:1712:// saveSingleLesson()'s non-summer branch above so it can be reused by
js/firebase-data.js:1713:// saveMultipleLessonFields() below without duplicating the stripping/clearing
js/firebase-data.js:1719:  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above saveSingleLesson().
js/firebase-data.js:1738:async function saveMultipleLessonFields(semesterKey, writes = [], deletes = []) {
js/firebase-data.js:1748:    throw new Error('saveMultipleLessonFields() does not support camp seasons — use saveSingleLesson() per lesson instead.');
js/firebase-data.js:1798:async function uploadLessonPhoto(semesterKey, lessonKey, file) {
js/firebase-data.js:2902:// saveSingleLesson()'s SDOC branch. Returns { status, doc, by, own }:
e2e/day-off-materials.spec.js:990:    const tr = await attempt(prep, ({ Y, c }) => saveSingleLesson(Y, dayOffLessonKey(Y, c, 'Clay Creatures'), { projectDetails: 'hijack' }, [], { dayOffAuth: { canEditAnywhere: true, hasClassbook: true, myTeacherName: null } }), { Y, c: camp.id });
e2e/day-off-materials.spec.js:993:    const tl = await attempt(prep, ({ Y, c }) => saveSingleLesson(Y, dayOffLessonKey(Y, c, 'Clay Creatures'), { projectLinks: ['https://x.test'] }, [], { dayOffAuth: { canEditAnywhere: true, hasClassbook: true, myTeacherName: null } }), { Y, c: camp.id });
js/app.js:1815:    const result = await saveSingleLesson(yearKey, lessonKey, { planComplete: requested }, [], { dayOffAuth: dayOffAuthFor(yearKey) });
js/app.js:2367:        await saveSingleLesson(semKey, lessonKey, payload);
js/app.js:2368:        // saveSingleLesson() stamps the payload it writes; keep the in-memory
js/app.js:2887:        await saveSingleLesson(semKey, lessonKey, { planComplete: cb.checked });
js/app.js:3535:      const result = await uploadLessonPhoto(semKey, lessonKey, photoInput.files[0]);
js/app.js:3579:    await saveSingleLesson(semKey, lessonKey, writePayload, fieldsToClear);
js/app.js:3580:    // saveSingleLesson() stamps lastEditedBy/At onto the object it is given.
js/app.js:3666:// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
js/app.js:3671:// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
js/app.js:3680:  // Same load-guard saveSingleLesson() enforced on the old path — after a
js/app.js:4638:    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
js/app.js:4692:    await updateAppData({ [`semesters.${key}.published`]: published });
js/app.js:4780:    await updateAppData({ [`semesters.${key}`]: newSem });
js/app.js:4914:    await updateAppData({ [`semesters.${key}`]: newSem });
js/app.js:5038:        await saveLessonData(key, emptyLessons);
js/app.js:5054:    await updateAppData({ [`semesters.${key}`]: newSem });
js/app.js:5711:  // the doc. Same routing signal as saveSingleLesson() /
js/app.js:5810:      const { url, path } = await uploadLessonPhoto(semKey, key, file);
js/app.js:5828:    await saveSingleLesson(semKey, key, firestorePayload, fieldsToClear);
js/app.js:5861:    lastEditedBy: firestorePayload.lastEditedBy,   // stamped by saveSingleLesson()
js/app.js:6020:      await saveMultipleLessonFields(
js/app.js:6093:          await saveMultipleLessonFields(semKey, [
js/app.js:6114:          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
js/app.js:6222:// cached semester via saveLessonData() — any lesson whose local copy was stale
js/app.js:6226:// had actually been written. Now: one targeted saveSingleLesson() per target
js/app.js:6277:      await saveSingleLesson(semKey, targetKey, payload, targetFieldsToClear);
js/app.js:6341:// against curriculum/cutProjects (not saveCutProjects()'s local-splice-then-
js/app.js:6401:    await deleteLessonKey(semKey, key);
js/app.js:6495:// saveLessonData() semester overwrite), removal via FieldValue.arrayRemove()
js/app.js:6496:// (not saveCutProjects()'s local-splice-then-full-array-overwrite — matches
js/app.js:6559:    await saveSingleLesson(destSemKey, key, lessons[key], NON_CONTENT_FIELDS_TO_CLEAR);
js/app.js:6969:// saveLessonData() write passed the WHOLE {projects:[...]} wrapper into
js/app.js:6974:// targeted saveSingleLesson() write (unrelated lessons in the same semester
js/app.js:7034:    await saveSingleLesson(semKey, key, newLesson, [...fieldsToClear, ...NON_CONTENT_FIELDS_TO_CLEAR]);
js/app.js:7210:// resave the ENTIRE cached semester via saveLessonData() — a Firestore
js/app.js:10937:      await updateAppData(paths);
js/app.js:11031:    await updateAppData(stamps);
js/app.js:11452:    await updateAppData({ ...settingsPaths, ...extraPaths });
js/app.js:11558:    await saveLessonData(semKey, lessons);
js/app.js:12060:      // summer branch of saveSingleLesson() is a set-merge, so everything
js/app.js:12093:      const result = await saveSingleLesson(semKey, lessonKey, payload, fieldsToClear, sdoc ? { dayOffAuth: dayOffAuthFor(semKey) } : undefined);
js/app.js:12094:      // saveSingleLesson() stamps lastEditedBy/At onto the object it is given;
2835:function attachCardListeners(container) {
3496:async function saveTeacherEdit(lessonKey, originalLesson) {
3675:async function sendTeacherQaMessage(lessonKey, modalSemKey) {
4594:async function deleteSemester(key) {
4929:async function createNewSemester() {
5626:async function saveAdminEdit(key, teacher, className, weekNum) {
5661:async function saveAdminEditInner(key, teacher, className, weekNum, title) {
5954:async function handleGridAction(destTeacher, destClassName, destWeekNum, destKey) {
6232:async function executeCopyPlan(sourceKey) {
6345:async function cutProject(key) {
6509:async function pasteFromCutBank(cutIndex, teacher, className, weekNum, sourceSemKey) {
6982:async function pasteFromIdeaBank(idx, teacher, className, weekNum) {
7220:async function sendHelpResponse(key) {
7309:async function sendQaReply(key) {
11352:async function saveSettings() {

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '1760,1840p;2300,2400p;2830,2910p;3480,3755p;4580,5070p;5600,6420p;6470,6580p;6940,7050p;7180,7385p;10880,11060p;11320,11600p;12020,12120p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
  1760	            return SDOC_PROJECT_BLOCK_KEYS.includes(key)
  1761	              ? `<div class="sdoc-tv-block sdoc-tv-unassigned" data-block="${key}"><span class="sdoc-tv-label">${label}</span> project not assigned yet</div>`
  1762	              : '';
  1763	          }
  1764	          if (isDayOffNoPlanTitle(title)) {
  1765	            return `<div class="sdoc-tv-block sdoc-tv-noplan" data-block="${key}"><span class="sdoc-tv-label">${label}</span> ${sdocEsc(title)}</div>`;
  1766	          }
  1767	          const lessonKey = dayOffLessonKey(yearKey, camp.id, title);
  1768	          const slot = slots[lessonKey];
  1769	          if (!slot) return `<div class="sdoc-tv-block" data-block="${key}"><span class="sdoc-tv-label">${label}</span> ${sdocEsc(title)}</div>`;
  1770	          const progress = calculateLessonProgress(slot);
  1771	          const editable = canEditDayOffPlan(slot) && lessonDataLoadedSuccessfully !== false;
  1772	          const pending = dayOffPlanCompleteInFlight.has(`${yearKey}|${lessonKey}`);
  1773	          return `<div class="sdoc-tv-block" data-block="${key}">
  1774	            <span class="sdoc-tv-label">${label}</span>
  1775	            <span class="sdoc-tv-title">${sdocEsc(title)}</span>
  1776	            <span class="sdoc-tv-status progress-${progress}">${getProgressLabel(progress)}</span>
  1777	            <button class="btn-text sdoc-tv-open-btn" data-lesson-key="${sdocEscA(lessonKey)}" onclick="openDayOffPlanFromList(this.dataset.lessonKey)">Open plan</button>
  1778	            <label class="sdoc-tv-pc"><input type="checkbox" class="sdoc-tv-pc-cb" data-lesson-key="${sdocEscA(lessonKey)}" ${slot.planComplete ? 'checked' : ''} ${editable && !pending ? '' : 'disabled'} onchange="toggleDayOffPlanComplete(this)"> Plan complete</label>
  1779	          </div>`;
  1780	        }).join('');
  1781	        html += `<div class="sdoc-tv-day" data-date="${sdocEscA(date)}"><div class="sdoc-tv-date">${sdocEsc(formatDayOffDate(date))}</div><div class="sdoc-tv-blocks">${cells}</div></div>`;
  1782	      }
  1783	      html += '</div>';
  1784	    }
  1785	    html += '</section>';
  1786	  }
  1787	  container.innerHTML = `<div class="sdoc-tv">${html}</div>`;
  1788	}
  1789	
  1790	function openDayOffPlanFromList(lessonKey) {
  1791	  const yearKey = getTvSemKey();
  1792	  return openPlanEditor(yearKey, lessonKey, {
  1793	    onClosed: () => setTimeout(() => {
  1794	      document.querySelector(`.sdoc-tv-open-btn[data-lesson-key="${CSS.escape(lessonKey)}"]`)?.scrollIntoView({ block: 'center' });
  1795	    }, 50),
  1796	  });
  1797	}
  1798	
  1799	// Plan complete from the list: one narrow { planComplete } write through the
  1800	// same save path, identified by its plan key (a title on two days is one plan,
  1801	// so every checkbox with that key moves together, and rolls back together).
  1802	const dayOffPlanCompleteInFlight = new Set();
  1803	async function toggleDayOffPlanComplete(box) {
  1804	  const yearKey = getTvSemKey();
  1805	  const lessonKey = box.dataset.lessonKey;
  1806	  const requested = box.checked;
  1807	  const flight = `${yearKey}|${lessonKey}`;
  1808	  const boxes = () => [...document.querySelectorAll('.sdoc-tv-pc-cb')].filter(b => b.dataset.lessonKey === lessonKey);
  1809	  if (dayOffPlanCompleteInFlight.has(flight)) { box.checked = !requested; return; }
  1810	  const slot = currentLessonData?.[yearKey]?.[lessonKey];
  1811	  if (!slot || !canEditDayOffPlan(slot)) { box.checked = !requested; return; }
  1812	  dayOffPlanCompleteInFlight.add(flight);
  1813	  boxes().forEach(b => { b.checked = requested; b.disabled = true; });
  1814	  try {
  1815	    const result = await saveSingleLesson(yearKey, lessonKey, { planComplete: requested }, [], { dayOffAuth: dayOffAuthFor(yearKey) });
  1816	    if (result?.status === 'savedSince') alert(`Saved — ${result.by} has edited this plan since.`);
  1817	  } catch (err) {
  1818	    console.error('Plan complete failed:', err);
  1819	    boxes().forEach(b => { b.checked = !requested; });
  1820	    alert(`Couldn't ${requested ? 'mark' : 'unmark'} the plan complete: ${err.message}`);
  1821	  } finally {
  1822	    dayOffPlanCompleteInFlight.delete(flight);
  1823	  }
  1824	  renderTeacherView();
  1825	}
  1826	
  1827	// ═══════════════════════════════════════════════════════
  1828	// SUMMER CAMP VIEW (Project-based, not week-based)
  1829	// ═══════════════════════════════════════════════════════
  1830	
  1831	function setSummerTeacherView(view) {
  1832	  summerTeacherView = view;
  1833	  const semKey = getTvSemKey();
  1834	  renderSummerCampView(document.getElementById('tv-content'), currentLessonData?.[semKey]);
  1835	}
  1836	
  1837	function renderSummerTeacherCalendar(visibleLessons) {
  1838	  const semKey = getTvSemKey();
  1839	  const semester = currentConfig?.semesters?.[semKey];
  1840	  const startDate = semester?.startDate; // e.g. "2026-05-26"
  2300	      const lessons = currentLessonData?.[semKey];
  2301	      if (!lessons) {
  2302	        console.log('No lessons data!');
  2303	        cb.checked = !requested;
  2304	        return;
  2305	      }
  2306	
  2307	      // The checkbox names its lesson exactly (data-lesson-key, set by the
  2308	      // render above). Fallback for a checkbox rendered without one: the slot
  2309	      // belonging to the teacher whose classbook is open — a shared camp
  2310	      // ("A + B") has one slot per teacher with the same
  2311	      // campName/projectTitle/block (Backtracking audit Phase 6 review:
  2312	      // matching on those alone ticked the FIRST teacher's slot and wrote the
  2313	      // other teacher's doc). Same lookup openLessonModal() uses.
  2314	      let lessonKey = cb.dataset.lessonKey && lessons[cb.dataset.lessonKey] ? cb.dataset.lessonKey : null;
  2315	      if (!lessonKey) {
  2316	        for (const [key, l] of Object.entries(lessons)) {
  2317	          if (l.campName === campName && l.projectTitle === projectTitle && l.block === block) {
  2318	            if (l.teacher === tvCurrentTeacher) { lessonKey = key; break; } // exact match for the current teacher
  2319	            if (!lessonKey) lessonKey = key; // fallback (admin viewing another teacher's slot)
  2320	          }
  2321	        }
  2322	      }
  2323	
  2324	      if (!lessonKey || !lessons[lessonKey]) {
  2325	        console.log('Lesson not found! lessonKey:', lessonKey);
  2326	        cb.checked = !requested;
  2327	        return;
  2328	      }
  2329	
  2330	      // One save at a time per LESSON: a second change while the first is in
  2331	      // flight would capture the optimistic value as its "previous" and the
  2332	      // two rollbacks could then land in either order. Keyed by lesson, not by
  2333	      // element — a re-render replaces the element mid-save.
  2334	      if (summerPlanCompleteSavesInFlight.has(inFlightKey(semKey, lessonKey))) { cb.checked = !requested; return; }
  2335	      summerPlanCompleteSavesInFlight.add(inFlightKey(semKey, lessonKey));
  2336	
  2337	      const lesson = lessons[lessonKey];
  2338	      console.log('Found lesson, current planComplete:', lesson.planComplete);
  2339	      // Backtracking audit Phase 6: optimistic in-memory update, put back in
  2340	      // full if the save fails (R3-20 — the catch used to revert only the
  2341	      // checkbox). Stamped NOW, not after the write: a reload landing while
  2342	      // the save is in flight merges per lesson by lastEditedAt (Phase 7),
  2343	      // and an unstamped copy would lose to the reload's pre-write read.
  2344	      const previous = { planComplete: lesson.planComplete, lastEditedBy: lesson.lastEditedBy, lastEditedAt: lesson.lastEditedAt };
  2345	      const myStamp = new Date().toISOString();
  2346	      lesson.planComplete = requested;
  2347	      lesson.lastEditedBy = getAuthUser()?.name || 'Unknown';
  2348	      lesson.lastEditedAt = myStamp;
  2349	      console.log('Updated to:', lesson.planComplete);
  2350	      cb.disabled = true;
  2351	
  2352	      // The checkbox/badge may have been re-rendered while the save was in
  2353	      // flight — address them by identity, not by the element that was clicked.
  2354	      const liveCheckbox = () => document.querySelector(`.summer-plan-complete-cb[data-lesson-key="${CSS.escape(lessonKey)}"]`) || cb;
  2355	      // The cache entry as it is NOW. A reload whose fresh copy won has
  2356	      // REPLACED the entry (this `lesson` is then detached and must not be
  2357	      // touched); one that kept ours updated it in place, stamp intact.
  2358	      const liveLesson = () => currentLessonData?.[semKey]?.[lessonKey];
  2359	      const owned = () => liveLesson() === lesson && lesson.lastEditedAt === myStamp;
  2360	
  2361	      try {
  2362	        console.log('Saving lesson with key:', lessonKey);
  2363	        // Narrow payload — only planComplete, not the full (possibly stale)
  2364	        // lesson object, so a stale local photoUrl/content field can never be
  2365	        // written over real Firestore content (Data Safety Plan Stage 2C).
  2366	        const payload = { planComplete: requested };
  2367	        await saveSingleLesson(semKey, lessonKey, payload);
  2368	        // saveSingleLesson() stamps the payload it writes; keep the in-memory
  2369	        // copy identical to the doc — only if this save still owns the entry.
  2370	        if (owned()) {
  2371	          lesson.lastEditedBy = payload.lastEditedBy;
  2372	          lesson.lastEditedAt = payload.lastEditedAt;
  2373	        }
  2374	        displacedSummerServerCopies.delete(displacedKey(semKey, lessonKey)); // this save is the confirmed state now
  2375	        console.log('Saved successfully! Lesson:', lessonKey, 'planComplete:', lesson.planComplete);
  2376	
  2377	        // Update the checkbox/status badge without re-rendering the view —
  2378	        // from the entry the cache holds NOW (a newer copy may have replaced
  2379	        // ours while the save was in flight).
  2380	        const shown = !!(liveLesson() ?? lesson).planComplete;
  2381	        liveCheckbox().checked = shown;
  2382	        const weekSection = liveCheckbox().closest('.tv-week-section');
  2383	        if (weekSection) {
  2384	          const statusBadge = weekSection.querySelector('.tv-status');
  2385	          if (statusBadge) {
  2386	            console.log('Updating status badge to:', shown ? 'Complete' : 'empty');
  2387	            if (shown) {
  2388	              statusBadge.className = 'tv-status status-complete';
  2389	              statusBadge.textContent = 'Complete';
  2390	            } else {
  2391	              statusBadge.className = 'tv-status status-progress';
  2392	              statusBadge.textContent = '';
  2393	            }
  2394	          } else {
  2395	            console.log('Status badge not found!');
  2396	          }
  2397	        } else {
  2398	          console.log('Week section not found!');
  2399	        }
  2400	      } catch (err) {
  2830	function revealTvCard(el) {
  2831	  const section = el?.closest('.tv-collapsible');
  2832	  if (section?.classList.contains('tv-collapsed')) setTvSectionOpen(section, true);
  2833	}
  2834	
  2835	function attachCardListeners(container) {
  2836	  container.querySelectorAll('.tv-collapse-toggle').forEach(header => {
  2837	    const toggle = () => {
  2838	      const section = header.closest('.tv-collapsible');
  2839	      setTvSectionOpen(section, section.classList.contains('tv-collapsed'));
  2840	    };
  2841	    header.addEventListener('click', toggle);
  2842	    header.addEventListener('keydown', (e) => {
  2843	      if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); toggle(); }
  2844	    });
  2845	  });
  2846	
  2847	  container.querySelectorAll('.tv-expand-btn').forEach(btn => {
  2848	    btn.addEventListener('click', () => {
  2849	      const content = btn.nextElementSibling;
  2850	      const expanded = btn.dataset.expanded === 'true';
  2851	      btn.dataset.expanded = expanded ? 'false' : 'true';
  2852	      btn.textContent = expanded ? 'Show details' : 'Hide details';
  2853	      content.style.display = expanded ? 'none' : 'block';
  2854	    });
  2855	  });
  2856	
  2857	  // Edit button click
  2858	  container.querySelectorAll('.tv-edit-btn').forEach(btn => {
  2859	    btn.addEventListener('click', (e) => {
  2860	      e.stopPropagation();
  2861	      openTeacherEditModal(btn.dataset.editKey);
  2862	    });
  2863	  });
  2864	
  2865	  // Print lesson button click
  2866	  container.querySelectorAll('.tv-card-print-btn').forEach(btn => {
  2867	    btn.addEventListener('click', (e) => {
  2868	      e.stopPropagation();
  2869	      printLesson(btn.dataset.lessonKey);
  2870	    });
  2871	  });
  2872	
  2873	  // Plan Complete checkbox — instant save
  2874	  container.querySelectorAll('.tv-plan-complete-cb').forEach(cb => {
  2875	    cb.addEventListener('change', async (e) => {
  2876	      const lessonKey = cb.dataset.lessonKey;
  2877	      const semKey = getTvSemKey();
  2878	      const lessons = currentLessonData?.[semKey];
  2879	      if (!lessons || !lessons[lessonKey]) return;
  2880	
  2881	      if (refuseIfWeeklySemesterPaused(semKey)) { cb.checked = !cb.checked; return; }   // Spring storage move: nothing changes
  2882	      const lesson = lessons[lessonKey];
  2883	      lesson.planComplete = cb.checked;
  2884	
  2885	      try {
  2886	        // Narrow payload — see the Stage 2C note on the summer handler above.
  2887	        await saveSingleLesson(semKey, lessonKey, { planComplete: cb.checked });
  2888	        // Re-render to update progress badge
  2889	        renderTeacherView();
  2890	      } catch (err) {
  2891	        console.error('Error saving plan complete:', err);
  2892	        cb.checked = !cb.checked; // revert
  2893	        lesson.planComplete = cb.checked;
  2894	        if (err?.message === OWN_DOC_PAUSED_MESSAGE) alert(OWN_DOC_PAUSED_MESSAGE);
  2895	      }
  2896	    });
  2897	  });
  2898	
  2899	  // Lesson title click: open read-only detail view
  2900	  container.querySelectorAll('.tv-clickable-title').forEach(title => {
  2901	    title.addEventListener('click', () => {
  2902	      openLessonDetailModal(title.dataset.viewKey);
  2903	    });
  2904	  });
  2905	
  2906	  // Shared project links: click to view shared lesson
  2907	  container.querySelectorAll('.tv-shared-link').forEach(link => {
  2908	    link.addEventListener('click', () => {
  2909	      const teacher = link.dataset.teacher;
  2910	      const targetClass = link.dataset.class;
  3480	function isTeEditDirty() {
  3481	  if (!teOriginalData) return false;
  3482	  const current = getTeEditFormData();
  3483	  return Object.keys(teOriginalData).some(key =>
  3484	    normalizeTeFormValue(key, current) !== (teOriginalData[key] || '')
  3485	  );
  3486	}
  3487	
  3488	function getTeChangedFields() {
  3489	  if (!teOriginalData) return [];
  3490	  const current = getTeEditFormData();
  3491	  return Object.keys(teOriginalData).filter(key =>
  3492	    normalizeTeFormValue(key, current) !== (teOriginalData[key] || '')
  3493	  );
  3494	}
  3495	
  3496	async function saveTeacherEdit(lessonKey, originalLesson) {
  3497	  const saveBtn = document.getElementById('te-save-btn');
  3498	  const autoSaveStatus = document.getElementById('te-autosave-status');
  3499	  const formData = getTeEditFormData();
  3500	  const changedFields = getTeChangedFields();
  3501	  const photoInput = document.getElementById('te-photo-input');
  3502	  const hasNewPhoto = photoInput?.files?.length > 0;
  3503	  const pendingRemove = photoInput?.dataset?.pendingRemove === 'true';
  3504	
  3505	  if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) {
  3506	    // Nothing to save — flash the button briefly
  3507	    if (saveBtn) { saveBtn.textContent = 'Saved!'; saveBtn.disabled = true; }
  3508	    setTimeout(() => { if (saveBtn) { saveBtn.textContent = 'Save'; saveBtn.disabled = false; } }, 1500);
  3509	    return;
  3510	  }
  3511	
  3512	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  3513	  if (refuseIfWeeklySemesterPaused(getTvSemKey())) return;
  3514	
  3515	  if (saveBtn) { saveBtn.disabled = true; saveBtn.textContent = 'Saving...'; }
  3516	  if (autoSaveStatus) autoSaveStatus.textContent = 'Saving...';
  3517	
  3518	  try {
  3519	    const semKey = getTvSemKey();
  3520	
  3521	    // Build updated lesson (preserve all original fields, override edited ones)
  3522	    const updatedLesson = { ...originalLesson, ...formData };
  3523	
  3524	    // Backtracking audit, Phase 8 (R4-2): capture the OLD photoPath before any
  3525	    // mutation, so the delete-after-save step below has the right value to
  3526	    // compare against.
  3527	    const oldPhotoPath = originalLesson.photoPath || null;
  3528	    const uploadedFile = hasNewPhoto ? photoInput.files[0] : null;
  3529	
  3530	    // Handle photo upload
  3531	    let photoUrl = null, photoPath = null;
  3532	    if (hasNewPhoto) {
  3533	      if (saveBtn) saveBtn.textContent = 'Uploading photo...';
  3534	      if (autoSaveStatus) autoSaveStatus.textContent = 'Uploading photo...';
  3535	      const result = await uploadLessonPhoto(semKey, lessonKey, photoInput.files[0]);
  3536	      // Backtracking audit, Phase 8 (R4-2): delete moved to AFTER the save
  3537	      // below — no longer here, immediately after upload.
  3538	      photoUrl = result.url;
  3539	      photoPath = result.path;
  3540	      updatedLesson.photoUrl = photoUrl;
  3541	      updatedLesson.photoPath = photoPath;
  3542	      if (!changedFields.includes('photo')) changedFields.push('photo');
  3543	      if (saveBtn) saveBtn.textContent = 'Saving...';
  3544	      if (autoSaveStatus) autoSaveStatus.textContent = 'Saving...';
  3545	    } else if (pendingRemove && originalLesson.photoUrl) {
  3546	      // Backtracking audit, Phase 8 (R4-2): delete moved to AFTER the save
  3547	      // below — no longer here.
  3548	      photoUrl = '';
  3549	      photoPath = '';
  3550	      updatedLesson.photoUrl = '';
  3551	      updatedLesson.photoPath = '';
  3552	      if (!changedFields.includes('photo')) changedFields.push('photo');
  3553	    }
  3554	
  3555	    // A content field that had text when the modal opened (or last saved) and
  3556	    // is now empty is an intentional clear — saveSingleLesson needs this list
  3557	    // explicitly to use FieldValue.delete() instead of silently omitting the
  3558	    // field, which would leave the old content in Firestore untouched
  3559	    // (Data Safety Plan Stage 3).
  3560	    const fieldsToClear = CONTENT_FIELDS.filter(f =>
  3561	      (teOriginalData?.[f] || '').trim() !== '' && !(formData[f] || '').trim()
  3562	    );
  3563	
  3564	    // Save using granular single-lesson write. This already includes
  3565	    // photoUrl/photoPath via updatedLesson (they're not in CONTENT_FIELDS, so
  3566	    // saveSingleLesson's per-field dotted-path write always writes them
  3567	    // through, even empty) — backtracking audit, Phase 8 (R3-8): the separate
  3568	    // photo-fields write that used to follow this call was vestigial, removed
  3569	    // entirely.
  3570	    // Backtracking audit Phase 10: the Q&A fields are written only by the
  3571	    // atomic arrayUnion() senders — this form never edits them, and writing
  3572	    // the cached array back whole would delete any message another client
  3573	    // appended since this cache copy was taken. They stay on updatedLesson
  3574	    // (the cache copy below) and are left out of the WRITE only.
  3575	    const writePayload = { ...updatedLesson };
  3576	    delete writePayload.qaThread;
  3577	    delete writePayload.teacherNotes;
  3578	    delete writePayload.adminResponse;
  3579	    await saveSingleLesson(semKey, lessonKey, writePayload, fieldsToClear);
  3580	    // saveSingleLesson() stamps lastEditedBy/At onto the object it is given.
  3581	    updatedLesson.lastEditedBy = writePayload.lastEditedBy;
  3582	    updatedLesson.lastEditedAt = writePayload.lastEditedAt;
  3583	
  3584	    // Backtracking audit, Phase 8 (R4-2): only delete the OLD photo once
  3585	    // Firestore has confirmed the new reference — and only if it's actually
  3586	    // different from the new one.
  3587	    if (oldPhotoPath && oldPhotoPath !== (updatedLesson.photoPath || null)) {
  3588	      try {
  3589	        await deleteLessonPhoto(oldPhotoPath);
  3590	      } catch (cleanupErr) {
  3591	        console.error('⚠️ Could not clean up old photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
  3592	      }
  3593	    }
  3594	
  3595	    // Backtracking audit, Phase 5: the photo change is persisted — clear the
  3596	    // pending selection so this modal's autosave doesn't re-upload the same
  3597	    // file to another unique path on the next pause in typing. Success path
  3598	    // only, so a failed save keeps the selection for the retry.
  3599	    if (hasNewPhoto && photoInput?.files?.[0] === uploadedFile) photoInput.value = '';
  3600	    if (pendingRemove && photoInput) photoInput.dataset.pendingRemove = '';
  3601	
  3602	    // Update local data immediately (don't wait for Firestore listener)
  3603	    if (currentLessonData[semKey]) {
  3604	      currentLessonData[semKey][lessonKey] = updatedLesson;
  3605	    }
  3606	
  3607	    // Backtracking audit, Phase 8 (R1-17/R2-11): log only after persistence is
  3608	    // confirmed, with its own non-blocking catch — a log-only failure here
  3609	    // must not be reported to the teacher as "Save failed" when the save
  3610	    // itself already succeeded. Before/after char counts per field so a
  3611	    // large-content wipe is flagged automatically (Data Safety Plan Stage 4C).
  3612	    // 'photo' isn't a text field — teOriginalData/formData have no counterpart
  3613	    // for it, so it carries no char counts and is never flagged as a wipe.
  3614	    try {
  3615	      const changedFieldEntries = changedFields.map(field => {
  3616	        if (field === 'photo') return { field, before: null, after: null, potentialWipe: false };
  3617	        const before = (teOriginalData[field] || '').length;
  3618	        const after = normalizeTeFormValue(field, formData).length;
  3619	        return { field, before, after, potentialWipe: after === 0 && before > 50 };
  3620	      });
  3621	      await logTeacherEdit(semKey, lessonKey, originalLesson, changedFieldEntries);
  3622	    } catch (logErr) {
  3623	      console.error('⚠️ Lesson saved, but Change History logging failed:', logErr);
  3624	    }
  3625	
  3626	    // Show success — stay open, reset dirty state
  3627	    if (saveBtn) { saveBtn.textContent = 'Saved!'; }
  3628	    if (autoSaveStatus) {
  3629	      autoSaveStatus.textContent = fieldsToClear.length > 0
  3630	        ? `✓ Saved (${fieldsToClear.join(', ')} cleared)`
  3631	        : '✓ Saved';
  3632	    }
  3633	
  3634	    // Reset dirty baseline so closing won't prompt "unsaved changes"
  3635	    const snapshot = getTeEditFormData();
  3636	    teOriginalData = {
  3637	      projectTitle: snapshot.projectTitle,
  3638	      shortDetails: snapshot.shortDetails,
  3639	      inspoLink: snapshot.inspoLink,
  3640	      introPitch: snapshot.introPitch,
  3641	      processStep1: snapshot.processStep1,
  3642	      processStep2: snapshot.processStep2,
  3643	      processStep3: snapshot.processStep3,
  3644	      processStep4: snapshot.processStep4,
  3645	      closure: snapshot.closure,
  3646	      materials: snapshot.materials,
  3647	      dayOfMaterials: snapshot.dayOfMaterials,
  3648	      materialsList: JSON.stringify(snapshot.materialsList || []),
  3649	      planComplete: snapshot.planComplete ? 'true' : 'false'
  3650	    };
  3651	
  3652	    setTimeout(() => {
  3653	      if (saveBtn) { saveBtn.textContent = 'Save'; saveBtn.disabled = false; }
  3654	      if (autoSaveStatus) autoSaveStatus.textContent = '';
  3655	    }, 1500);
  3656	  } catch (err) {
  3657	    console.error('Error saving lesson:', err);
  3658	    if (saveBtn) { saveBtn.disabled = false; saveBtn.textContent = 'Save'; }
  3659	    if (autoSaveStatus) { autoSaveStatus.textContent = '⚠️ Save failed'; autoSaveStatus.style.color = 'var(--error)'; }
  3660	    if (err?.message === OWN_DOC_PAUSED_MESSAGE) alert(OWN_DOC_PAUSED_MESSAGE);
  3661	  }
  3662	}
  3663	
  3664	// Backtracking audit Phase 10 (R3-3, R4-5): this used to rebuild the whole
  3665	// Q&A thread from the modal's lesson object and hand the ENTIRE lesson to
  3666	// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
  3667	// silently dropped any message (or any other field) another client had
  3668	// landed since this modal opened. Now a single targeted .update() touching
  3669	// only this lesson's own Q&A paths, with arrayUnion() for the thread — the
  3670	// same atomic-append design sendHelpResponse()/sendQaReply() already use —
  3671	// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
  3672	// record. `modalSemKey` is the semester the modal was opened under: the
  3673	// global selector can change while the modal stays open, and a dotted-path
  3674	// update under the wrong semester would create a Q&A-only ghost lesson there.
  3675	async function sendTeacherQaMessage(lessonKey, modalSemKey) {
  3676	  const input = document.getElementById('te-qa-input');
  3677	  if (!input) return;
  3678	  const message = input.value.trim();
  3679	  if (!message) return;
  3680	  // Same load-guard saveSingleLesson() enforced on the old path — after a
  3681	  // failed load the cache is empty, so the legacy-thread migration below
  3682	  // would run blind against whatever is really on the server.
  3683	  if (lessonDataLoadedSuccessfully === false) {
  3684	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  3685	    return;
  3686	  }
  3687	
  3688	  const semKey = modalSemKey || getTvSemKey();
  3689	  // This modal never hosts a camp season (the Today View routes those to the
  3690	  // summer editor, whose Q&A lives in summerCamps_prepHelpQueue), so a write
  3691	  // under that key into curriculum/lessonData is never right. Routed by TYPE
  3692	  // now (Phase 1, 1.1) — a third type is refused out loud rather than written
  3693	  // into the shared weekly document.
  3694	  let lessonStore;
  3695	  try {
  3696	    lessonStore = lessonStoreFor(semKey);
  3697	  } catch (err) {
  3698	    alert(err.message);
  3699	    return;
  3700	  }
  3701	  if (lessonStore === 'camp') {
  3702	    alert('Summer camp questions are sent from the camp lesson editor.');
  3703	    return;
  3704	  }
  3705	
  3706	  // Confirm the lesson still exists on the server (an admin may have moved or
  3707	  // deleted it since this modal opened). A dotted-path update would otherwise
  3708	  // recreate the old key as a Q&A-only ghost lesson. Same forced read and
  3709	  // accepted check-to-write residual as sendHelpResponse()/sendQaReply().
  3710	  let check;
  3711	  try {
  3712	    check = await adminLessonStillExistsWithRetry(semKey, lessonKey);
  3713	  } catch (err) {
  3714	    console.warn('⚠️ Existence check retry also failed:', err);
  3715	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  3716	    return;
  3717	  }
  3718	  if (!check.exists) {
  3719	    alert('This lesson was moved or removed elsewhere. Your message was not sent — please close this and check the classbook for its new location.');
  3720	    return;
  3721	  }
  3722	  const existing = check.data;
  3723	
  3724	  const user = getAuthUser();
  3725	  const isAdmin = ['admin', 'manager'].includes(user?.role);
  3726	  const newEntry = {
  3727	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  3728	    from: isAdmin ? 'admin' : 'teacher',
  3729	    name: user?.name || 'Unknown',
  3730	    message,
  3731	    timestamp: new Date().toISOString()
  3732	  };
  3733	  // The fresh server copy decides whether a legacy teacherNotes/adminResponse
  3734	  // thread still needs migrating into qaThread on this lesson's first entry.
  3735	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  3736	  const editedAt = new Date().toISOString();
  3737	  const editedBy = user?.name || 'Unknown';
  3738	
  3739	  let target;
  3740	  try {
  3741	    target = weeklyLessonTarget(semKey);   // own-doc semester: its own doc, or "editing is paused"
  3742	  } catch (err) {
  3743	    alert(err.message);
  3744	    return;
  3745	  }
  3746	  const p = `${target.prefix}${lessonKey}`;
  3747	  const updates = {
  3748	    [`${p}.qaThread`]: firebase.firestore.FieldValue.arrayUnion(...entriesToAdd),
  3749	    [`${p}.lastEditedBy`]: editedBy,
  3750	    [`${p}.lastEditedAt`]: editedAt,
  3751	  };
  3752	  // Legacy mirror fields, kept for compatibility with older readers.
  3753	  const legacyField = isAdmin ? 'adminResponse' : 'teacherNotes';
  3754	  updates[`${p}.${legacyField}`] = message;
  3755	
  4580	    const isPublished = sem.published !== false;
  4581	    const isActive = currentKey === currentConfig.activeSemester;
  4582	    publishGroup.innerHTML = `
  4583	      ${isActive ? '<span class="ca-sem-active-badge">Active Semester</span>' : ''}
  4584	      ${!isActive ? `<label class="ca-publish-toggle">
  4585	        <input type="checkbox" ${isPublished ? 'checked' : ''} onchange="toggleSemesterPublish(${escForOnclick(currentKey)}, this.checked)">
  4586	        Published (visible to teachers)
  4587	      </label>` : ''}
  4588	      ${!isPublished && !isActive ? '<span class="ca-sem-unpublished-badge">Draft</span>' : ''}
  4589	      ${!isActive ? `<button class="btn-text ca-delete-sem-btn" onclick="deleteSemester(${escForOnclick(currentKey)})" title="Delete this semester">&#128465; Delete</button>` : ''}
  4590	    `;
  4591	  }
  4592	}
  4593	
  4594	async function deleteSemester(key) {
  4595	  const sem = currentConfig?.semesters?.[key];
  4596	  if (!sem) return;
  4597	  // Spring 2026 storage move: deleting an own-doc semester is disabled until the
  4598	  // follow-up plan routes it (its lessons may live in their own document).
  4599	  if (isOwnDocSemester(key)) {
  4600	    alert(`"${sem.name}" can't be deleted while its storage is being changed.`);
  4601	    return;
  4602	  }
  4603	  if (key === currentConfig.activeSemester) {
  4604	    alert('Cannot delete the active semester.');
  4605	    return;
  4606	  }
  4607	  // Removing a CAMP season from the Classbook removes only this app's entry
  4608	  // for it. Its camps, schedule, plans and photos belong to the Summer Camp
  4609	  // App and stay exactly where they are — adding the season back from the
  4610	  // registry restores the whole view (Phase 1, 1.7). This supersedes the
  4611	  // companion plan's summer-delete design, which predates seasons.
  4612	  // An SDOC year: refused while any event exists (a forced-server count);
  4613	  // otherwise only its appData entry goes — it has nothing in
  4614	  // curriculum/lessonData, and no collection is ever cleared from here.
  4615	  if (isDayOffYear(key)) {
  4616	    let events;
  4617	    try { events = await countDayOffEvents(key); }
  4618	    catch (err) { alert(`Could not check "${sem.name}" for events: ${err.message}\n\nNothing was changed.`); return; }
  4619	    if (events > 0) { alert(`"${sem.name}" still has ${events} event${events === 1 ? '' : 's'}. Remove its events first.`); return; }
  4620	  }
  4621	  const isCamp = isCampSeason(key);
  4622	  const isDayOff = isDayOffYear(key);
  4623	  const firstConfirm = isDayOff
  4624	    ? `Delete the school year "${sem.name}"? It has no events, so only the year itself is removed.`
  4625	    : isCamp
  4626	    ? `Remove "${sem.name}" from the Classbook?\n\nThis only removes it here. Every camp, schedule, lesson plan and photo stays in the Summer Camp App, and you can add the season back at any time from + New Semester.`
  4627	    : `Delete semester "${sem.name}"? This will remove all its lesson data, cut bank, and change history. This cannot be undone.`;
  4628	  if (!confirm(firstConfirm)) return;
  4629	  if (!isCamp && !isDayOff && !confirm(`Are you sure? Type OK in your head and click OK to confirm.`)) return;
  4630	
  4631	  // Remove the semester's own entry and nothing else (Phase 1, 1.2). Revert
  4632	  // this tab if the write is refused, or the config would be missing a
  4633	  // semester the server still has — with no alert and no re-render to show it
  4634	  // (Phase 1 review).
  4635	  const removed = currentConfig.semesters[key];
  4636	  delete currentConfig.semesters[key];
  4637	  try {
  4638	    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
  4639	  } catch (err) {
  4640	    currentConfig.semesters[key] = removed;
  4641	    console.error('❌ Could not remove the semester:', err);
  4642	    alert(`Could not remove "${sem.name}": ${err.message}\n\nNothing was changed.`);
  4643	    renderSemesterSelector();
  4644	    return;
  4645	  }
  4646	
  4647	  // Drop this season's in-memory map either way…
  4648	  if (currentLessonData?.[key]) {
  4649	    delete currentLessonData[key];
  4650	  }
  4651	  // …but only a WEEKLY semester has lessons of its own inside
  4652	  // curriculum/lessonData to delete. A camp season's lessons live in the
  4653	  // shared summerCamps_* collections and are never touched from here.
  4654	  if (isDayOff) {
  4655	    delete currentDayOffEvents[key]; delete currentDayOffCamps[key]; delete currentDayOffPlans[key]; delete currentDayOffSignoffs[key];
  4656	  } else if (!isCamp) {
  4657	    try {
  4658	      await deleteLessonData(key);
  4659	    } catch (e) { console.warn('Could not delete lesson data for', key, e); }
  4660	  }
  4661	
  4662	  // Switch to active semester
  4663	  caCurrentSemester = currentConfig.activeSemester;
  4664	  renderSemesterSelector();
  4665	  renderAdminGrid();
  4666	  renderHelpQueue();
  4667	  renderCutBank();
  4668	  renderIdeaBank();
  4669	  renderChangeHistory();
  4670	}
  4671	
  4672	function switchAdminSemester(key) {
  4673	  // Delegates to global semester — CA always stays in sync with the header selector
  4674	  setGlobalSemester(key);
  4675	}
  4676	
  4677	async function toggleSemesterPublish(key, published) {
  4678	  if (!currentConfig?.semesters?.[key]) return;
  4679	  if (!isPublishableType(key)) { alert('This semester type can\'t be published.'); return; }
  4680	  // SDOC (Phase 2B): publishing shows the year to every teacher on a camp —
  4681	  // say so first if some camps have nobody to see them.
  4682	  if (published && isDayOffYear(key)) {
  4683	    // The camp list below must be real to warn from — never publish on a failed load.
  4684	    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
  4685	    const bare = (currentDayOffCamps[key] || []).filter(c => !(c.teachers || []).length).length;
  4686	    if (bare && !confirm(`${bare} camp${bare === 1 ? ' has' : 's have'} no teacher yet — publish anyway?`)) { renderSemesterSelector(); return; }
  4687	  }
  4688	  const hadPublished = 'published' in currentConfig.semesters[key];
  4689	  const previous = currentConfig.semesters[key].published;
  4690	  currentConfig.semesters[key].published = published;
  4691	  try {
  4692	    await updateAppData({ [`semesters.${key}.published`]: published });
  4693	  } catch (err) {
  4694	    // Restore exactly what was there — including "the field was absent".
  4695	    if (currentConfig.semesters[key]) {
  4696	      if (hadPublished) currentConfig.semesters[key].published = previous;
  4697	      else delete currentConfig.semesters[key].published;
  4698	    }
  4699	    console.error('❌ Could not change the publish state:', err);
  4700	    alert(`Could not ${published ? 'publish' : 'unpublish'} that semester: ${err.message}\n\nNothing was changed.`);
  4701	  }
  4702	  renderSemesterSelector();
  4703	}
  4704	
  4705	// Which types may be published to teachers. SDOC years joined in Phase 2B,
  4706	// when teachers got their day-off plans to build.
  4707	const PUBLISHABLE_SEMESTER_TYPES = new Set([SEMESTER_TYPES.weekly, SEMESTER_TYPES.camp, SEMESTER_TYPES.dayOff]);
  4708	function isPublishableType(semKey) { return PUBLISHABLE_SEMESTER_TYPES.has(semesterTypeOf(semKey)); }
  4709	
  4710	function openNewSemesterModal() {
  4711	  document.getElementById('ca-new-semester-modal')?.classList.add('open');
  4712	  // Reset to the default type each time, then load the seasons on offer.
  4713	  const weeklyRadio = document.querySelector('input[name="new-sem-type"][value="weekly"]');
  4714	  if (weeklyRadio) weeklyRadio.checked = true;
  4715	  onNewSemesterTypeChange();
  4716	  populateNewSemesterSeasons();
  4717	  document.getElementById('new-sem-name')?.focus();
  4718	}
  4719	
  4720	function selectedNewSemesterType() {
  4721	  return document.querySelector('input[name="new-sem-type"]:checked')?.value || SEMESTER_TYPES.weekly;
  4722	}
  4723	
  4724	function onNewSemesterTypeChange() {
  4725	  const type = selectedNewSemesterType();
  4726	  const weekly = document.getElementById('new-sem-weekly-fields');
  4727	  const camp = document.getElementById('new-sem-camp-fields');
  4728	  const dayOff = document.getElementById('new-sem-dayoff-fields');
  4729	  if (weekly) weekly.hidden = type !== SEMESTER_TYPES.weekly;
  4730	  if (camp) camp.hidden = type !== SEMESTER_TYPES.camp;
  4731	  if (dayOff) {
  4732	    dayOff.hidden = type !== SEMESTER_TYPES.dayOff;
  4733	    if (type === SEMESTER_TYPES.dayOff) resetDayOffYearFields();
  4734	  }
  4735	}
  4736	
  4737	// Defaults: Aug 1 of this year → May 31 of the next; name follows the dates
  4738	// until the admin types their own.
  4739	function resetDayOffYearFields() {
  4740	  const y = new Date().getFullYear();
  4741	  const start = document.getElementById('new-sem-dayoff-start');
  4742	  const end = document.getElementById('new-sem-dayoff-end');
  4743	  const name = document.getElementById('new-sem-dayoff-name');
  4744	  if (start) start.value = `${y}-08-01`;
  4745	  if (end) end.value = `${y + 1}-05-31`;
  4746	  if (name) delete name.dataset.edited;
  4747	  onDayOffYearDatesChange();
  4748	}
  4749	
  4750	function onDayOffYearDatesChange() {
  4751	  const name = document.getElementById('new-sem-dayoff-name');
  4752	  if (!name || name.dataset.edited) return;
  4753	  const start = document.getElementById('new-sem-dayoff-start')?.value || '';
  4754	  const end = document.getElementById('new-sem-dayoff-end')?.value || '';
  4755	  name.value = start && end ? dayOffYearLabels(start, end).name : '';
  4756	}
  4757	
  4758	// An SDOC school year: one appData entry through the field-path writer, after
  4759	// a forced-server absence check. No roster, no lesson slots, no
  4760	// curriculum/lessonData write.
  4761	async function createDayOffYear() {
  4762	  const startDate = document.getElementById('new-sem-dayoff-start')?.value || '';
  4763	  const endDate = document.getElementById('new-sem-dayoff-end')?.value || '';
  4764	  const name = document.getElementById('new-sem-dayoff-name')?.value.trim() || '';
  4765	  if (!isIsoDate(startDate) || !isIsoDate(endDate)) { alert('Pick the school year\'s start and end dates.'); return; }
  4766	  if (endDate <= startDate) { alert('The school year has to end after it starts.'); return; }
  4767	  if (!name) { alert('Give the school year a name.'); return; }
  4768	  const { key } = dayOffYearLabels(startDate, endDate);
  4769	  if (currentConfig.semesters?.[key]) { alert(`${currentConfig.semesters[key].name} already exists (${key}).`); return; }
  4770	
  4771	  creatingSemester = true;
  4772	  try {
  4773	    const serverConfig = await readAppDataFromServer();
  4774	    if (serverConfig?.semesters?.[key]) {
  4775	      alert(`A school year with key "${key}" was already created (in another tab, or by another admin). Reload to see it.`);
  4776	      creatingSemester = false;
  4777	      return;
  4778	    }
  4779	    const newSem = { name, semesterType: SEMESTER_TYPES.dayOff, startDate, endDate, published: false, teacherNames: [] };
  4780	    await updateAppData({ [`semesters.${key}`]: newSem });
  4781	    currentConfig.semesters[key] = newSem;
  4782	  } catch (err) {
  4783	    console.error('❌ Could not create the school year:', err);
  4784	    alert(`Could not create that school year: ${err.message}`);
  4785	    creatingSemester = false;
  4786	    return;
  4787	  }
  4788	  // The write landed — anything failing from here is display only.
  4789	  try {
  4790	    currentDayOffEvents[key] = [];
  4791	    currentDayOffCamps[key] = [];
  4792	    currentDayOffPlans[key] = {};
  4793	    currentDayOffSignoffs[key] = {};
  4794	    if (currentLessonData) currentLessonData[key] = {};
  4795	    closeNewSemesterModal();
  4796	    renderSemesterSelector();
  4797	    initGlobalSemesterSelector();
  4798	    alert(`${name} created. It stays hidden from teachers. Next: add its teacher names in Settings, then its day-off dates and camps in Curriculum Admin.`);
  4799	  } catch (err) {
  4800	    console.error('School year created, but the page did not refresh:', err);
  4801	    alert(`${name} was created, but the page didn't refresh properly — reload to see it.`);
  4802	  } finally {
  4803	    creatingSemester = false;
  4804	  }
  4805	}
  4806	
  4807	// The Camp season option offers exactly the registry seasons that do not
  4808	// already have a semester here. In legacy mode there is no registry to read,
  4809	// and with nothing left to add there is nothing to choose — either way the
  4810	// option is disabled with the reason shown, never silently empty (1.6).
  4811	async function populateNewSemesterSeasons() {
  4812	  const select = document.getElementById('new-sem-season');
  4813	  const campRadio = document.getElementById('new-sem-type-camp');
  4814	  const note = document.getElementById('new-sem-camp-unavailable');
  4815	  if (!select || !campRadio || !note) return;
  4816	  const disable = (reason) => {
  4817	    campRadio.disabled = true;
  4818	    note.textContent = reason;
  4819	    note.hidden = false;
  4820	    select.innerHTML = '';
  4821	  };
  4822	  const mode = getSeasonRegistryMode();
  4823	  if (mode === 'legacy') return disable('Camp seasons need the Summer Camp App to set up its seasons first — none exist yet.');
  4824	  if (mode !== 'filtered') return disable("Can't read the season registry right now, so a camp season can't be added.");
  4825	  try {
  4826	    const registered = await listRegisteredSeasons();
  4827	    // A season is "taken" by a stored `season` OR by the key it would be
  4828	    // created under. The key check matters before the type migration has run:
  4829	    // summer-2026 carries no `season` field yet, and matching on that alone
  4830	    // would offer 2026 again and create a duplicate semester.
  4831	    const semesters = currentConfig?.semesters || {};
  4832	    const taken = new Set(Object.values(semesters).map(sem => sem?.season).filter(Boolean));
  4833	    const available = registered.filter(r => !taken.has(r.season) && !semesters[`summer-${r.season}`]);
  4834	    if (available.length === 0) {
  4835	      return disable(registered.length === 0
  4836	        ? 'The Summer Camp App has not created any seasons yet.'
  4837	        : 'Every season the Summer Camp App has created is already in the Classbook.');
  4838	    }
  4839	    campRadio.disabled = false;
  4840	    note.hidden = true;
  4841	    select.innerHTML = available.map(r => {
  4842	      const range = r.startDate && r.endDate ? ` (${formatSeasonDate(r.startDate)} – ${formatSeasonDate(r.endDate)})` : '';
  4843	      return `<option value="${escAttr(r.season)}">${escHtml(r.name || `Summer ${r.season}`)}${escHtml(range)}</option>`;
  4844	    }).join('');
  4845	    newSemesterSeasonsByYear = Object.fromEntries(available.map(r => [r.season, r]));
  4846	  } catch (err) {
  4847	    console.error('Could not list the registry seasons:', err);
  4848	    disable("Couldn't read the season registry, so a camp season can't be added right now.");
  4849	  }
  4850	}
  4851	
  4852	let newSemesterSeasonsByYear = {};
  4853	
  4854	function formatSeasonDate(iso) {
  4855	  const d = new Date(`${iso}T00:00:00`);
  4856	  return Number.isNaN(d.getTime()) ? iso : d.toLocaleDateString(undefined, { month: 'short', day: 'numeric', year: 'numeric' });
  4857	}
  4858	
  4859	function closeNewSemesterModal() {
  4860	  document.getElementById('ca-new-semester-modal')?.classList.remove('open');
  4861	}
  4862	
  4863	// In-flight guard: the Create button is a bare onclick with no disabled state,
  4864	// so a double-click ran two overlapping creations. Both passed the
  4865	// "already exists" check (the key is only added to currentConfig after the
  4866	// first await), and a split success/failure would let the failing run's
  4867	// cleanup below delete the succeeding run's server-side slots. Set before the
  4868	// first await, cleared in `finally` — everything between the check and the
  4869	// set is synchronous, so the second click always sees it.
  4870	let creatingSemester = false;
  4871	
  4872	// A lesson slot exactly as createNewSemester() / createLessonSlotsForRoster()
  4873	// generate it: identity + enrollment metadata, every other field at its empty
  4874	// default. Deliberately stricter than lessonHasContent() — projectTitle,
  4875	// materials, photoUrl, qaThread etc. are not CONTENT_FIELDS but are still
  4876	// real data that createNewSemester()'s slot write would merge over.
  4877	function isTemplateEmptyLesson(lesson) {
  4878	  if (!lesson || typeof lesson !== 'object') return false;
  4879	  const IDENTITY = new Set(['teacher', 'className', 'weekNum', 'classSize']);
  4880	  return Object.entries(lesson).every(([k, v]) =>
  4881	    IDENTITY.has(k) || v == null || v === '' || v === 0 || v === false ||
  4882	    (Array.isArray(v) && v.length === 0)
  4883	  );
  4884	}
  4885	
  4886	// A camp season is created from the registry, never typed in (1.6 / D3): no
  4887	// roster, no week grid, no lesson slots and no curriculum/lessonData write —
  4888	// its camps arrive from the Summer Camp App when Christie publishes them.
  4889	async function createCampSeasonSemester() {
  4890	  const season = document.getElementById('new-sem-season')?.value;
  4891	  const registry = newSemesterSeasonsByYear[season];
  4892	  if (!season || !registry) { alert('Pick a season first.'); return; }
  4893	
  4894	  const key = `summer-${season}`;
  4895	  if (currentConfig.semesters?.[key]) { alert(`Summer ${season} is already in the Classbook.`); return; }
  4896	  // The same completeness check Re-sync makes — otherwise a half-set-up season
  4897	  // could be ADDED with numWeeks 0 and no studios, and would then render with
  4898	  // 2026's fallback shape and hours (Phase 1 fix review).
  4899	  const problems = registrySeasonProblems(registry);
  4900	  if (problems.length) {
  4901	    alert(`Summer ${season} isn't ready yet: the Summer Camp App's season still needs ${problems.join(', ')}. Finish setting it up there, then add it here.`);
  4902	    return;
  4903	  }
  4904	
  4905	  creatingSemester = true;
  4906	  try {
  4907	    // The local check above only saw this tab's config.
  4908	    const serverConfig = await readAppDataFromServer();
  4909	    if (serverConfig?.semesters?.[key]) {
  4910	      alert(`Summer ${season} was already added (in another tab, or by another admin). Reload to see it.`);
  4911	      return;
  4912	    }
  4913	    const newSem = semesterFromRegistrySeason(registry);
  4914	    await updateAppData({ [`semesters.${key}`]: newSem });
  4915	    currentConfig.semesters[key] = newSem;
  4916	    closeNewSemesterModal();
  4917	    renderSemesterSelector();
  4918	    initGlobalSemesterSelector();
  4919	    alert(`${newSem.name} added. It stays hidden from teachers until you publish it, and its camps appear here as the Summer Camp App publishes them.`);
  4920	  } catch (err) {
  4921	    console.error('❌ Could not add the camp season:', err);
  4922	    delete currentConfig.semesters[key];
  4923	    alert(`Could not add that season: ${err.message}`);
  4924	  } finally {
  4925	    creatingSemester = false;
  4926	  }
  4927	}
  4928	
  4929	async function createNewSemester() {
  4930	  if (creatingSemester) return;
  4931	  if (selectedNewSemesterType() === SEMESTER_TYPES.camp) return await createCampSeasonSemester();
  4932	  if (selectedNewSemesterType() === SEMESTER_TYPES.dayOff) return await createDayOffYear();
  4933	  const name = document.getElementById('new-sem-name')?.value.trim();
  4934	  if (!name) { alert('Semester name is required.'); return; }
  4935	
  4936	  const key = name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');
  4937	  if (currentConfig.semesters[key]) {
  4938	    alert(`A semester with key "${key}" already exists.`);
  4939	    return;
  4940	  }
  4941	
  4942	  const startDate = document.getElementById('new-sem-start')?.value || '';
  4943	  const numWeeks = parseInt(document.getElementById('new-sem-weeks')?.value) || 16;
  4944	  const breaksRaw = document.getElementById('new-sem-breaks')?.value.trim() || '';
  4945	  const breakWeeks = breaksRaw ? breaksRaw.split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n)) : [];
  4946	  const closuresRaw = document.getElementById('new-sem-closures')?.value.trim() || '';
  4947	  const closureDates = parseClosureDates(closuresRaw);
  4948	  const copyFromKey = document.getElementById('new-sem-copy-from')?.value || '';
  4949	
  4950	  const newSem = {
  4951	    name,
  4952	    semesterType: SEMESTER_TYPES.weekly,   // stored explicitly from now on (Phase 1, 1.1)
  4953	    startDate,
  4954	    numWeeks,
  4955	    breakWeeks,
  4956	    closureDates,
  4957	    published: false,
  4958	    classRoster: {}
  4959	  };
  4960	
  4961	  // Invoked from a bare HTML onclick — nothing above this frame catches, so a
  4962	  // failure anywhere below must be handled here (backtracking audit, Phase 11).
  4963	  // Two Firestore writes happen in sequence (lesson slots, then config); if the
  4964	  // second fails after the first landed, the slots are an orphan on the server
  4965	  // for a semester the admin was told didn't get created, and a retry with the
  4966	  // same name would silently reuse them. Track whether the first write landed
  4967	  // so the catch can compensate.
  4968	  let lessonDataCommitted = false;
  4969	  creatingSemester = true;
  4970	  try {
  4971	    // Copy roster from existing semester if selected
  4972	    if (copyFromKey && currentConfig.semesters[copyFromKey]) {
  4973	      // Pre-check (implementation review, Sep 2026): this branch is the only
  4974	      // path that writes lesson data, and the compensating delete in the catch
  4975	      // below removes the WHOLE `key` map — only safe if nothing lived there
  4976	      // before this call. It can: deleteSemester() drops a key from local
  4977	      // state even when its server-side deleteLessonData() fails (warn-only),
  4978	      // and config has no live listener, so another admin's same-named
  4979	      // semester isn't visible here either. Forced server read — the local
  4980	      // cache is exactly what can't be trusted for this key. Refuse unless
  4981	      // every existing lesson is template-empty (a prior createNewSemester()'s
  4982	      // own leftovers are safe to build on and safe to delete; anything else
  4983	      // would be merged over silently by the slot write, then deleted on
  4984	      // failure). The no-copy path is deliberately NOT gated: it writes no
  4985	      // lesson data, and re-creating a deleted semester there adopts its
  4986	      // surviving lesson data — the remedy this alert points at.
  4987	      const existingLessonMap = await readServerSemesterLessonMap(key);
  4988	      if (existingLessonMap && Object.values(existingLessonMap).some(l => !isTemplateEmptyLesson(l))) {
  4989	        alert(`Lesson content already exists in Firestore under the key "${key}".\n\nIf it was left over from a deleted semester, create this semester again without "Copy from" to adopt that data.\n\nIf another admin may have just created it, reload this page first.\n\nOtherwise choose a different name.`);
  4990	        return;
  4991	      }
  4992	
  4993	      const source = currentConfig.semesters[copyFromKey];
  4994	      newSem.classRoster = JSON.parse(JSON.stringify(source.classRoster || {}));
  4995	      // Without this, classRoster's teacher fields are copied but the dropdown
  4996	      // that lets Settings display/edit them has no options — the roster looks
  4997	      // wiped even though the underlying data isn't, and saving Settings in
  4998	      // that state silently writes blank teachers over the real ones.
  4999	      newSem.teacherNames = JSON.parse(JSON.stringify(source.teacherNames || []));
  5000	
  5001	      // Create empty lesson slots from source semester's teacher/class combos
  5002	      const sourceLessons = currentLessonData?.[copyFromKey] || {};
  5003	      const combos = new Set();
  5004	      for (const lesson of Object.values(sourceLessons)) {
  5005	        combos.add(`${lesson.teacher}|||${lesson.className}`);
  5006	      }
  5007	
  5008	      const emptyLessons = {};
  5009	      for (const combo of combos) {
  5010	        const [teacher, className] = combo.split('|||');
  5011	        for (let w = 1; w <= numWeeks; w++) {
  5012	          const lessonKey = makeLessonKey(teacher, className, w);
  5013	          emptyLessons[lessonKey] = {
  5014	            teacher,
  5015	            className,
  5016	            weekNum: w,
  5017	            weekDate: '',
  5018	            classSize: 0,
  5019	            projectTitle: '',
  5020	            shortDetails: '',
  5021	            inspoLink: '',
  5022	            introPitch: '',
  5023	            processStep1: '',
  5024	            processStep2: '',
  5025	            processStep3: '',
  5026	            processStep4: '',
  5027	            closure: '',
  5028	            materials: '',
  5029	            dayOfMaterials: '',
  5030	            materialsList: [],
  5031	            status: '',
  5032	            publishToPrep: ''
  5033	          };
  5034	        }
  5035	      }
  5036	
  5037	      if (Object.keys(emptyLessons).length > 0) {
  5038	        await saveLessonData(key, emptyLessons);
  5039	        if (!currentLessonData) currentLessonData = {};
  5040	        currentLessonData[key] = emptyLessons;
  5041	        lessonDataCommitted = true;
  5042	      }
  5043	    }
  5044	
  5045	    // Confirm on the SERVER that the key is free — the check at the top of this
  5046	    // function only saw this tab's copy of the config (Phase 1, 1.2). The
  5047	    // remaining read-to-update window is accepted: one admin, same class as the
  5048	    // existing residual on the Q&A path.
  5049	    const serverConfig = await readAppDataFromServer();
  5050	    if (serverConfig?.semesters?.[key]) {
  5051	      throw new Error(`A semester with the key "${key}" already exists (created in another tab or by another admin). Choose a different name.`);
  5052	    }
  5053	    currentConfig.semesters[key] = newSem;
  5054	    await updateAppData({ [`semesters.${key}`]: newSem });
  5055	  } catch (err) {
  5056	    console.error('❌ Could not create new semester:', err);
  5057	    // Revert both local mutations so a retry isn't blocked by a phantom
  5058	    // "already exists" and the grid doesn't render a semester that never saved.
  5059	    delete currentConfig.semesters[key];
  5060	    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
  5061	    // R4-11: the empty lesson slots may already be persisted even though the
  5062	    // config never was — clean up the orphaned server-side write, not just the
  5063	    // local copy. Safe: this data is template-empty by construction (never had
  5064	    // real content), so deleting it loses nothing.
  5065	    if (lessonDataCommitted) {
  5066	      try {
  5067	        await deleteLessonData(key);
  5068	      } catch (cleanupErr) {
  5069	        console.error('⚠️ Could not clean up orphaned lesson data after failed semester creation:', cleanupErr);
  5070	      }
  5600	
  5601	  let html = `<div class="ca-detail-meta">
  5602	    <span><strong>Teacher:</strong> ${escHtml(teacher)}</span>
  5603	    <span><strong>Class:</strong> ${escHtml(className)}</span>
  5604	    <span><strong>Week:</strong> ${weekNum}</span>
  5605	  </div>`;
  5606	  html += renderAdminEditForm(lesson, key, teacher, className, weekNum);
  5607	
  5608	  body.innerHTML = html;
  5609	  modal.classList.add('open');
  5610	  // First editable field — on a summer lesson the title is read-only.
  5611	  document.querySelector('#ca-edit-form input:not([readonly]), #ca-edit-form textarea:not([readonly])')?.focus();
  5612	}
  5613	
  5614	// Data Safety Plan Phase 9 (+ backtracking audit Phase 1): the admin edit
  5615	// popup's save. What goes to Firestore is ONLY what this popup changed — the
  5616	// diff of the form against the open-time snapshot, plus the photo fields if
  5617	// this save touched them, plus identity/scheduling fields (teacher, className,
  5618	// weekNum, weekDate, classSize — no input in this form; resent from the cache
  5619	// exactly as before, an inherited exposure named in the plan, not a Phase 9
  5620	// change). The cached `existing` lesson is never spread into the payload, so
  5621	// a stale qaThread / photo / untouched content field can't overwrite another
  5622	// client's newer copy. Intentional clears travel as fieldsToClear. Before
  5623	// anything is written, a forced-server read confirms the lesson still exists
  5624	// (moved/deleted elsewhere while the popup was open → refuse, don't recreate
  5625	// a ghost). Residual check-to-write TOCTOU gap accepted per the plan.
  5626	async function saveAdminEdit(key, teacher, className, weekNum) {
  5627	  if (caEditSaveInFlight) return;
  5628	  const title = document.getElementById('ca-edit-title')?.value.trim();
  5629	  // (closeAdminModal() refuses non-forced closes while caEditSaveInFlight is
  5630	  // set — Cancel / × / overlay are effectively disabled for the duration.)
  5631	  if (!title) { alert('Project title is required.'); return; }
  5632	
  5633	  // Backtracking audit, Phase 1: check the guard BEFORE any Storage mutation
  5634	  // (and, now, before the existence check) so a known-bad load state never
  5635	  // gets as far as a server read, an upload, or a delete.
  5636	  if (lessonDataLoadedSuccessfully === false) {
  5637	    alert('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  5638	    return;
  5639	  }
  5640	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  5641	  if (refuseIfWeeklySemesterPaused(getAdminSemKey())) return;
  5642	
  5643	  caEditSaveInFlight = true;
  5644	  // Every action button in the modal body — the form's own Save/Print/Cancel
  5645	  // AND the empty-cell popup's two Paste buttons, which openDetailModal()
  5646	  // renders outside #ca-edit-form (round-3 review: they could replace the
  5647	  // modal body mid-save and race a second write onto the same slot).
  5648	  const btns = Array.from(document.querySelectorAll('#ca-modal-body .ca-actions button'));
  5649	  const saveBtn = btns.find(b => /^save/i.test(b.textContent.trim()));
  5650	  btns.forEach(b => { b.disabled = true; });
  5651	  if (saveBtn) saveBtn.textContent = 'Saving...';
  5652	  try {
  5653	    await saveAdminEditInner(key, teacher, className, weekNum, title);
  5654	  } finally {
  5655	    caEditSaveInFlight = false;
  5656	    btns.forEach(b => { b.disabled = false; });
  5657	    if (saveBtn) saveBtn.textContent = 'Save';
  5658	  }
  5659	}
  5660	
  5661	async function saveAdminEditInner(key, teacher, className, weekNum, title) {
  5662	  const semKey = getAdminSemKey();
  5663	
  5664	  const lessons = { ...(currentLessonData?.[semKey] || {}) };
  5665	  let existing = lessons[key] || {};   // rebased on the fresh server copy after the existence check (non-summer)
  5666	
  5667	  // Step 1 — diff the form against the open-time snapshot (pure DOM reads, no
  5668	  // side effects — so a no-op save can bail out below without paying for the
  5669	  // existence check's server read).
  5670	  const raw = {
  5671	    projectTitle: title,
  5672	    shortDetails: document.getElementById('ca-edit-details')?.value.trim() || '',
  5673	    inspoLink: document.getElementById('ca-edit-inspo')?.value.trim() || '',
  5674	    introPitch: document.getElementById('ca-edit-intro')?.value.trim() || '',
  5675	    processStep1: document.getElementById('ca-edit-step1')?.value.trim() || '',
  5676	    processStep2: document.getElementById('ca-edit-step2')?.value.trim() || '',
  5677	    processStep3: document.getElementById('ca-edit-step3')?.value.trim() || '',
  5678	    processStep4: document.getElementById('ca-edit-step4')?.value.trim() || '',
  5679	    closure: document.getElementById('ca-edit-closure')?.value.trim() || '',
  5680	    materials: document.getElementById('ca-edit-materials')?.value.trim() || '',
  5681	    dayOfMaterials: document.getElementById('ca-edit-dayof')?.value.trim() || '',
  5682	  };
  5683	  // No snapshot (shouldn't happen — both render paths capture one) degrades to
  5684	  // "everything non-empty is changed": today's behavior, never a lost edit.
  5685	  const baseline = caEditOriginalData || {};
  5686	  const changedFields = Object.keys(raw).filter(f => raw[f] !== (baseline[f] || ''));
  5687	  // Had text when the popup opened, empty now — an intentional clear, which
  5688	  // saveSingleLesson must apply with FieldValue.delete() rather than let the
  5689	  // stripping pass silently drop (Data Safety Plan Stage 3, never extended to
  5690	  // this third editor until now).
  5691	  const fieldsToClear = changedFields.filter(f => (baseline[f] || '') !== '' && raw[f] === '');
  5692	  const changedData = {};
  5693	  changedFields.forEach(f => { changedData[f] = raw[f]; });
  5694	
  5695	  const photoInput = document.getElementById('ca-edit-photo-input');
  5696	  const hasNewPhoto = photoInput?.files?.length > 0;
  5697	  let pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
  5698	  // Nothing changed — no write, no re-stamped lastEditedBy/At, no "edit" log
  5699	  // entry for an edit that didn't happen (mirrors saveTeacherEdit()).
  5700	  if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) {
  5701	    closeAdminModal(true);
  5702	    return;
  5703	  }
  5704	
  5705	  // Step 2 — forced-server read of this slot, before any side effect (the
  5706	  // photo upload, the write). Non-summer only: a summer cache entry is a
  5707	  // scaffold regenerated from summerCamps_curriculum whether or not its
  5708	  // summerCamps_lessonData doc exists (a missing doc means "never saved",
  5709	  // not "moved") and this app has no move/swap/cut path for summer lessons,
  5710	  // so there is no ghost to prevent — the first save legitimately creates
  5711	  // the doc. Same routing signal as saveSingleLesson() /
  5712	  // adminLessonStillExistsWithRetry() (key prefix; the camp-seasons plan
  5713	  // unifies this on semesterType). Forced read — a cache-permitting get()
  5714	  // could be served from the live listener's local cache in exactly the race
  5715	  // window this check exists to close. It runs for first-time creation too:
  5716	  // an "empty" slot in this tab's cache may have gained a project (a paste, a
  5717	  // move onto it) that the listener hasn't delivered yet.
  5718	  const isSummerSchema = isCampSeason(semKey);   // Phase 1, 1.1
  5719	  if (!isSummerSchema) {
  5720	    let check;
  5721	    try {
  5722	      check = await adminLessonStillExistsWithRetry(semKey, key);
  5723	    } catch (err) {
  5724	      console.warn('⚠️ Existence check retry also failed:', err);
  5725	      alert("Couldn't confirm this lesson still exists — check your connection and try saving again.");
  5726	      return;
  5727	    }
  5728	    if (caEditLessonExisted && !check.exists) {
  5729	      alert('This lesson was moved or removed elsewhere while you had it open. Your changes were not saved — please close this window and check the grid for its new location.');
  5730	      return;
  5731	    }
  5732	    if (check.exists) {
  5733	      // The key holds a doc — but a swap, a move ONTO this slot, or a paste
  5734	      // into a slot this tab still shows as empty leaves it populated with a
  5735	      // DIFFERENT project. The popup's edits were made against the project it
  5736	      // opened on; applying them to whatever is here now needs an explicit
  5737	      // decision, the same way cutProject() re-confirms when the fresh read
  5738	      // shows the slot's identity changed.
  5739	      const freshTitle = (check.data?.projectTitle || '').trim();
  5740	      if (freshTitle !== (baseline.projectTitle || '')) {
  5741	        const opened = baseline.projectTitle || '(empty slot)';
  5742	        if (!confirm(`This slot has changed since you opened it — it now contains "${freshTitle || '(empty)'}" instead of "${opened}". Save your changes onto "${freshTitle || 'this slot'}" anyway?\n\nCancel keeps your text here and saves nothing.`)) return;
  5743	      }
  5744	      // From here on, work from the FRESH copy, not this tab's cache: the
  5745	      // photo to delete after a replacement, the "remove photo" target, the
  5746	      // identity/scheduling fields resent below, the local cache merge and
  5747	      // the logged title all come from `existing`. On the swap-accept path
  5748	      // the cached copy's photoPath is the OTHER lesson's live photo.
  5749	      existing = check.data;
  5750	      pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
  5751	    }
  5752	  } else if (!existing.campName) {
  5753	    // A summer key that is no longer in the cache (the schedule was rebuilt
  5754	    // between open and save — e.g. the project was renamed in the Summer
  5755	    // Camp App) would produce a doc without its identity trio, which neither
  5756	    // app can find again. Refuse rather than write it.
  5757	    alert('This lesson is no longer in the summer schedule — reload and try again. Nothing was saved.');
  5758	    return;
  5759	  }
  5760	
  5761	  // Summer: projectTitle, shortDetails, inspoLink and materials belong to the
  5762	  // camp curriculum, not to the lesson doc — loadSummerCampData() takes them
  5763	  // from the scaffold and reads back only content/photo/completion fields
  5764	  // (SUMMER_SAVED_FIELDS), so an edit here would "save" and then vanish on the
  5765	  // next reload. projectTitle is worse: it is part of the lesson key, and the
  5766	  // Summer Camp App's orphan check treats a doc whose title isn't in the
  5767	  // camp's curriculum as orphaned content. Refuse them honestly rather than
  5768	  // write them into a doc where they can only mislead.
  5769	  const SUMMER_CURRICULUM_OWNED = ['projectTitle', 'shortDetails', 'inspoLink', 'materials'];
  5770	  if (isSummerSchema) {
  5771	    const refused = SUMMER_CURRICULUM_OWNED.filter(f => f in changedData);
  5772	    if (refused.length > 0) {
  5773	      const labels = { projectTitle: 'project title', shortDetails: 'short details', inspoLink: 'inspo link', materials: 'materials' };
  5774	      alert(`Summer camp ${refused.map(f => labels[f]).join(', ')} are managed in the Summer Camp App — that change is not saved here.` + (changedFields.length > refused.length || hasNewPhoto || pendingRemove ? ' Your other edits will still be saved.' : ''));
  5775	      refused.forEach(f => {
  5776	        delete changedData[f];
  5777	        const idx = changedFields.indexOf(f);
  5778	        if (idx !== -1) changedFields.splice(idx, 1);
  5779	        const cidx = fieldsToClear.indexOf(f);
  5780	        if (cidx !== -1) fieldsToClear.splice(cidx, 1);
  5781	      });
  5782	      if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) { closeAdminModal(true); return; }
  5783	    }
  5784	  }
  5785	
  5786	  // Firestore-bound payload — see the function comment for what's in it and why.
  5787	  const firestorePayload = {
  5788	    teacher, className, weekNum,
  5789	    weekDate: existing.weekDate || '',
  5790	    classSize: existing.classSize || 0,
  5791	    // Summer identity trio, key-derived and idempotent — a doc this save
  5792	    // CREATES must carry them (the Summer Camp App queries this collection by
  5793	    // campName + teacher and checks projectTitle; the summer editor sends the
  5794	    // same trio on every save for the same reason).
  5795	    ...(isSummerSchema ? { campName: existing.campName, block: existing.block, projectTitle: existing.projectTitle } : {}),
  5796	    ...changedData,
  5797	    lastImported: new Date().toISOString()
  5798	  };
  5799	
  5800	  // Backtracking audit, Phase 1 (R4-2): capture the OLD photoPath before any
  5801	  // mutation, so the delete-after-save step compares against the right value.
  5802	  const oldPhotoPath = existing.photoPath || null;
  5803	  let photoUrl = null, photoPath = null;   // null = this save didn't touch the photo
  5804	
  5805	  try {
  5806	    // Handle photo upload/removal
  5807	    if (hasNewPhoto) {
  5808	      const file = photoInput.files[0];
  5809	      if (file.size > 5 * 1024 * 1024) { alert('Photo must be under 5MB.'); return; }
  5810	      const { url, path } = await uploadLessonPhoto(semKey, key, file);
  5811	      // Delete of the OLD photo happens AFTER the save below — not here.
  5812	      photoUrl = url;
  5813	      photoPath = path;
  5814	    } else if (pendingRemove) {
  5815	      photoUrl = '';
  5816	      photoPath = '';
  5817	    }
  5818	    if (photoUrl !== null) {
  5819	      firestorePayload.photoUrl = photoUrl;
  5820	      firestorePayload.photoPath = photoPath;
  5821	    }
  5822	
  5823	    // Targeted single-lesson save with a diff-only payload — never the cached
  5824	    // full lesson, never the whole semester. (The summer branch's "no content"
  5825	    // guard can't refuse a legitimate save from here: for summer every
  5826	    // editable non-content field is curriculum-owned and refused above, so
  5827	    // what remains is content, a clear, or a photo — each admitted.)
  5828	    await saveSingleLesson(semKey, key, firestorePayload, fieldsToClear);
  5829	
  5830	    // Backtracking audit, Phase 1 (R4-2): only delete the OLD object once
  5831	    // Firestore has confirmed the new reference — and only when THIS save
  5832	    // actually replaced or removed the photo (photoUrl !== null). A text-only
  5833	    // edit leaves the old path untouched in both Firestore and Storage.
  5834	    if (photoUrl !== null && oldPhotoPath && oldPhotoPath !== (photoPath || null)) {
  5835	      try {
  5836	        await deleteLessonPhoto(oldPhotoPath);
  5837	      } catch (cleanupErr) {
  5838	        console.error('⚠️ Could not clean up old photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
  5839	      }
  5840	    }
  5841	  } catch (err) {
  5842	    // Backtracking audit, Phase 1 (R2-22): MUST return here — otherwise
  5843	    // execution falls through to commit currentLessonData, close the modal,
  5844	    // and log a fake edit even though the save never actually succeeded. The
  5845	    // snapshot is kept so the still-open popup can retry against it.
  5846	    console.error('❌ Admin edit failed to save:', err);
  5847	    alert(err?.message === OWN_DOC_PAUSED_MESSAGE ? OWN_DOC_PAUSED_MESSAGE : 'This edit could not be saved. Please try again.');
  5848	    return;
  5849	  }
  5850	
  5851	  // Local display/cache only — never sent to Firestore, so keeping the full
  5852	  // merge here is safe (staleness in untouched fields is cosmetic until the
  5853	  // listener's next delivery, same as the teacher editor).
  5854	  lessons[key] = {
  5855	    ...existing,
  5856	    teacher, className, weekNum,
  5857	    weekDate: firestorePayload.weekDate,
  5858	    classSize: firestorePayload.classSize,
  5859	    ...changedData,
  5860	    lastImported: firestorePayload.lastImported,
  5861	    lastEditedBy: firestorePayload.lastEditedBy,   // stamped by saveSingleLesson()
  5862	    lastEditedAt: firestorePayload.lastEditedAt
  5863	  };
  5864	  if (photoUrl !== null) { lessons[key].photoUrl = photoUrl; lessons[key].photoPath = photoPath; }
  5865	  fieldsToClear.forEach(f => { lessons[key][f] = ''; });
  5866	  currentLessonData[semKey] = lessons;
  5867	
  5868	  closeAdminModal(true);   // the save's own close — also resets the snapshot
  5869	  renderAdminGrid();
  5870	  renderChangeHistory();
  5871	
  5872	  try {
  5873	    // Log the title that was actually kept — for summer a refused retitle
  5874	    // must not show up in Change History under the refused name.
  5875	    const keptTitle = firestorePayload.projectTitle || existing.projectTitle || title;
  5876	    await appendChangeLogEntry(semKey, {
  5877	      action: existing.projectTitle ? 'edit' : 'create',
  5878	      details: { projectTitle: keptTitle, teacher, className, weekNum }
  5879	    });
  5880	    renderChangeHistory();
  5881	  } catch (e) { console.warn('Could not write change log entry:', e); }
  5882	}
  5883	
  5884	function startSwap(sourceKey) {
  5885	  caActionMode = 'swap';
  5886	  caSourceKey = sourceKey;
  5887	  closeAdminModal();
  5888	  renderAdminGrid();
  5889	}
  5890	
  5891	function cancelGridAction() {
  5892	  caActionMode = null;
  5893	  caSourceKey = null;
  5894	  renderAdminGrid();
  5895	}
  5896	
  5897	// Data Safety Plan Stage 2A/2B: shared helpers for the admin grid's move/swap
  5898	// abort-and-restore paths (see CLASSBOOK-DATA-SAFETY-PLAN.md).
  5899	// lessonHasContent() now lives in firebase-data.js (CONTENT_FIELDS is the
  5900	// single source of truth, Data Safety Plan Stage 4A) — this file just uses it.
  5901	
  5902	// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
  5903	// model. Backtracking audit, Phase 2 (reinstated round 4): adds an optional
  5904	// opts.source === 'server' param, needed by Phase 8's
  5905	// adminLessonStillExistsWithRetry() existence check below — omitting opts
  5906	// preserves the exact prior (cache-permitting) default for any future caller.
  5907	async function readAdminLessonDoc(semKey, lessonKey, opts = {}) {
  5908	  if (!curriculumDb) initCurriculumFirestore();
  5909	  const getOpts = opts.source === 'server' ? { source: 'server' } : undefined;
  5910	  const map = await readWeeklySemesterMap(semKey, getOpts);   // own-doc semesters read their own document
  5911	  return map?.[lessonKey] || null;
  5912	}
  5913	
  5914	// Backtracking audit, Phase 8: shared by cutProject() below and Phase 11's
  5915	// sendHelpResponse()/sendQaReply() (not yet implemented) — forced server
  5916	// read, retried once on failure, then lets a second failure throw so each
  5917	// caller decides how to surface it. Residual TOCTOU race (check-to-write gap)
  5918	// deliberately accepted, matching the companion plan's own decision for this
  5919	// identical helper — bounded by human click-to-click timing, not a tight
  5920	// machine loop; closing it fully would need a Firestore transaction.
  5921	async function adminLessonStillExistsWithRetry(semKey, key) {
  5922	  if (!curriculumDb) initCurriculumFirestore();
  5923	  const isSummer = lessonStoreFor(semKey) === 'camp';   // Phase 1, 1.1 — by type, and a third type throws
  5924	  const readOnce = async () => {
  5925	    if (isSummer) {
  5926	      const snap = await curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key)).get({ source: 'server' });
  5927	      return { exists: snap.exists, data: snap.exists ? snap.data() : null };
  5928	    }
  5929	    const data = await readAdminLessonDoc(semKey, key, { source: 'server' });
  5930	    return { exists: data !== null, data };
  5931	  };
  5932	  try {
  5933	    return await readOnce();
  5934	  } catch (err) {
  5935	    console.warn('⚠️ Existence check read failed, retrying once:', err);
  5936	    return await readOnce(); // a second failure throws — caller's catch handles it
  5937	  }
  5938	}
  5939	
  5940	// Reverts the admin grid's optimistic in-memory update after a move/swap that
  5941	// failed to save or failed verification — puts both slots back to their
  5942	// pre-action state (deleting the dest slot if it didn't exist before) and re-renders.
  5943	function restoreGridActionState(semKey, sourceKey, sourceLesson, destKey, destLesson) {
  5944	  if (!currentLessonData[semKey]) currentLessonData[semKey] = {};
  5945	  currentLessonData[semKey][sourceKey] = sourceLesson;
  5946	  if (destLesson) {
  5947	    currentLessonData[semKey][destKey] = destLesson;
  5948	  } else {
  5949	    delete currentLessonData[semKey][destKey];
  5950	  }
  5951	  renderAdminGrid();
  5952	}
  5953	
  5954	async function handleGridAction(destTeacher, destClassName, destWeekNum, destKey) {
  5955	  const semKey = getAdminSemKey();
  5956	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  5957	  if (refuseIfWeeklySemesterPaused(semKey)) { cancelGridAction(); return; }
  5958	  const lessons = { ...currentLessonData[semKey] };
  5959	  const sourceLesson = lessons[caSourceKey];
  5960	
  5961	  if (!sourceLesson) {
  5962	    cancelGridAction();
  5963	    return;
  5964	  }
  5965	
  5966	  // Prevent moving to same cell
  5967	  if (caSourceKey === destKey) {
  5968	    cancelGridAction();
  5969	    return;
  5970	  }
  5971	
  5972	  const destLesson = lessons[destKey] || null;
  5973	  const newDestKey = makeLessonKey(destTeacher, destClassName, destWeekNum);
  5974	
  5975	  if (caActionMode === 'move') {
  5976	    if (destLesson) {
  5977	      if (!confirm(`Week ${destWeekNum} already has "${destLesson.projectTitle}". This will overwrite it. Continue?`)) {
  5978	        cancelGridAction();
  5979	        return;
  5980	      }
  5981	    }
  5982	    if (!confirm(`Move "${sourceLesson.projectTitle}" from Week ${sourceLesson.weekNum} to ${destTeacher} / ${destClassName} Week ${destWeekNum}?`)) {
  5983	      cancelGridAction();
  5984	      return;
  5985	    }
  5986	
  5987	    // Move: put source content at destination, clear source
  5988	    const movedLesson = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum };
  5989	    movedLesson.weekDate = destLesson?.weekDate || '';
  5990	    // Backtracking audit, Phase 4: a content field non-empty at the existing
  5991	    // destination but empty in the incoming moved lesson must be explicitly
  5992	    // cleared — saveSingleLesson omits empty fields from the write rather
  5993	    // than clearing them, so without this the destination's old content
  5994	    // would silently survive underneath the moved lesson.
  5995	    const destFieldsToClear = CONTENT_FIELDS.filter(f =>
  5996	      (destLesson?.[f] || '').trim() !== '' && !(movedLesson[f] || '').trim()
  5997	    );
  5998	    lessons[newDestKey] = movedLesson;
  5999	    delete lessons[caSourceKey];
  6000	    currentLessonData[semKey] = lessons;
  6001	
  6002	    const sourceKeyToDelete = caSourceKey;
  6003	    const preMoveSourceLesson = sourceLesson;
  6004	    const preMoveDestLesson = destLesson;
  6005	    caActionMode = null;
  6006	    caSourceKey = null;
  6007	    renderAdminGrid();
  6008	    renderChangeHistory();
  6009	
  6010	    // Backtracking audit, Phase 9: the destination write and the source
  6011	    // delete are ONE atomic Firestore call — closes the "first write landed,
  6012	    // second failed" partial-failure race the prior sequential-write design
  6013	    // was vulnerable to. Does NOT independently verify movedLesson reflects
  6014	    // the CURRENT server state (a separate, deliberately deferred stale-input
  6015	    // race — see classbook-shared-document-concurrency-plan.html's 7th
  6016	    // instance) — no read-back needed or performed, since the write is
  6017	    // all-or-nothing.
  6018	    let moveSucceeded = false;
  6019	    try {
  6020	      await saveMultipleLessonFields(
  6021	        semKey,
  6022	        [{ lessonKey: newDestKey, lessonData: movedLesson, fieldsToClear: destFieldsToClear }],
  6023	        [sourceKeyToDelete]
  6024	      );
  6025	      moveSucceeded = true;
  6026	    } catch (err) {
  6027	      console.error('❌ Move failed:', err);
  6028	      restoreGridActionState(semKey, sourceKeyToDelete, preMoveSourceLesson, newDestKey, preMoveDestLesson);
  6029	      alert(`Move could not be saved — "${preMoveSourceLesson.projectTitle}" has been restored to its original slot. Nothing was changed.`);
  6030	      return;
  6031	    }
  6032	
  6033	    if (moveSucceeded) {
  6034	      try {
  6035	        await appendChangeLogEntry(semKey, {
  6036	          action: 'move',
  6037	          details: {
  6038	            projectTitle: sourceLesson.projectTitle,
  6039	            teacher: sourceLesson.teacher,
  6040	            className: sourceLesson.className,
  6041	            fromWeek: sourceLesson.weekNum,
  6042	            toTeacher: destTeacher,
  6043	            toClassName: destClassName,
  6044	            toWeek: destWeekNum
  6045	          }
  6046	        });
  6047	        renderChangeHistory();
  6048	      } catch (logErr) {
  6049	        console.error('⚠️ Move saved, but Change History logging failed:', logErr);
  6050	      }
  6051	    }
  6052	    return;
  6053	
  6054	  } else if (caActionMode === 'swap') {
  6055	    const destLabel = destLesson ? `"${destLesson.projectTitle}"` : 'empty slot';
  6056	    if (!confirm(`Swap "${sourceLesson.projectTitle}" (Week ${sourceLesson.weekNum}) with ${destLabel} (Week ${destWeekNum})?`)) {
  6057	      cancelGridAction();
  6058	      return;
  6059	    }
  6060	
  6061	    // Swap: exchange content between source and dest
  6062	    const sourceWeekNum = sourceLesson.weekNum;
  6063	    const sourceTeacher = sourceLesson.teacher;
  6064	    const sourceClassName = sourceLesson.className;
  6065	    const sourceWeekDate = sourceLesson.weekDate;
  6066	    const sourceKeyForSwap = caSourceKey;
  6067	
  6068	    let savePromise;
  6069	    let swapSucceeded = false;
  6070	    if (destLesson) {
  6071	      const swappedSource = { ...destLesson, teacher: sourceTeacher, className: sourceClassName, weekNum: sourceWeekNum, weekDate: sourceWeekDate };
  6072	      const swappedDest = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum, weekDate: destLesson.weekDate };
  6073	      // Backtracking audit, Phase 4: each slot's clear list compares its OWN
  6074	      // pre-swap content against what's now being written there — NOT the
  6075	      // other slot's pre-swap content, which would be a no-op since that's
  6076	      // identical-by-construction to the incoming value.
  6077	      const sourceFieldsToClear = CONTENT_FIELDS.filter(f =>
  6078	        (sourceLesson[f] || '').trim() !== '' && !(swappedSource[f] || '').trim()
  6079	      );
  6080	      const destFieldsToClearSwap = CONTENT_FIELDS.filter(f =>
  6081	        (destLesson[f] || '').trim() !== '' && !(swappedDest[f] || '').trim()
  6082	      );
  6083	      lessons[sourceKeyForSwap] = swappedSource;
  6084	      lessons[newDestKey] = swappedDest;
  6085	      currentLessonData[semKey] = lessons;
  6086	
  6087	      // Backtracking audit, Phase 9: both slots' writes are now ONE atomic
  6088	      // Firestore call — closes the "first save landed, second failed"
  6089	      // partial-failure race the prior two-sequential-saves design was
  6090	      // vulnerable to.
  6091	      savePromise = (async () => {
  6092	        try {
  6093	          await saveMultipleLessonFields(semKey, [
  6094	            { lessonKey: sourceKeyForSwap, lessonData: swappedSource, fieldsToClear: sourceFieldsToClear },
  6095	            { lessonKey: newDestKey, lessonData: swappedDest, fieldsToClear: destFieldsToClearSwap }
  6096	          ]);
  6097	          swapSucceeded = true;
  6098	        } catch (err) {
  6099	          console.error('❌ Swap failed:', err);
  6100	          restoreGridActionState(semKey, sourceKeyForSwap, sourceLesson, newDestKey, destLesson);
  6101	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" and "${destLesson.projectTitle}" have been restored to their original slots.`);
  6102	        }
  6103	      })();
  6104	    } else {
  6105	      // Swap with empty: move source to dest, clear source. Backtracking
  6106	      // audit, Phase 9: the destination write and source delete are now ONE
  6107	      // atomic Firestore call, same reasoning as the move branch above.
  6108	      const movedLesson = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum, weekDate: '' };
  6109	      lessons[newDestKey] = movedLesson;
  6110	      delete lessons[sourceKeyForSwap];
  6111	      currentLessonData[semKey] = lessons;
  6112	      savePromise = (async () => {
  6113	        try {
  6114	          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
  6115	          swapSucceeded = true;
  6116	        } catch (err) {
  6117	          console.error('❌ Swap failed:', err);
  6118	          restoreGridActionState(semKey, sourceKeyForSwap, sourceLesson, newDestKey, null);
  6119	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" has been restored to its original slot.`);
  6120	        }
  6121	      })();
  6122	    }
  6123	
  6124	    caActionMode = null;
  6125	    caSourceKey = null;
  6126	    renderAdminGrid();
  6127	    renderChangeHistory();
  6128	
  6129	    await savePromise;
  6130	
  6131	    if (swapSucceeded) {
  6132	      try {
  6133	        await appendChangeLogEntry(semKey, {
  6134	          action: 'swap',
  6135	          details: {
  6136	            projectTitle: sourceLesson.projectTitle,
  6137	            teacher: sourceTeacher,
  6138	            className: sourceClassName,
  6139	            fromWeek: sourceWeekNum,
  6140	            swappedWith: destLesson?.projectTitle || '(empty)',
  6141	            toTeacher: destTeacher,
  6142	            toClassName: destClassName,
  6143	            toWeek: destWeekNum
  6144	          }
  6145	        });
  6146	        renderChangeHistory();
  6147	      } catch (logErr) {
  6148	        console.error('⚠️ Swap saved, but Change History logging failed:', logErr);
  6149	      }
  6150	    }
  6151	    return;
  6152	  }
  6153	
  6154	  caActionMode = null;
  6155	  caSourceKey = null;
  6156	  renderAdminGrid();
  6157	  renderChangeHistory();
  6158	}
  6159	
  6160	// ─── Copy Plan Workflow ─────────────────────────────
  6161	
  6162	function openCopyPlanUI(sourceKey) {
  6163	  const semKey = getAdminSemKey();
  6164	  const lessons = currentLessonData?.[semKey];
  6165	  if (!lessons) return;
  6166	
  6167	  const source = lessons[sourceKey];
  6168	  if (!source) return;
  6169	
  6170	  const shared = findSharedProjects(source.projectTitle, sourceKey, getAdminSemKey());
  6171	  if (shared.length === 0) return;
  6172	
  6173	  const body = document.getElementById('ca-modal-body');
  6174	  const title = document.getElementById('ca-modal-title');
  6175	  title.textContent = `Copy Plan: ${source.projectTitle}`;
  6176	
  6177	  let html = `<div class="ca-copy-section">
  6178	    <p class="ca-copy-intro">Copy lesson plan from <strong>${escHtml(source.teacher)} — ${escHtml(source.className)} (Week ${source.weekNum})</strong> to other classes teaching this project.</p>
  6179	    <div class="ca-copy-preview">
  6180	      <label>Plan being copied:</label>
  6181	      <div class="ca-copy-preview-content">`;
  6182	
  6183	  if (source.introPitch) html += `<div><strong>Intro:</strong> ${escHtml(source.introPitch.substring(0, 100))}${source.introPitch.length > 100 ? '...' : ''}</div>`;
  6184	  if (source.processStep1) html += `<div><strong>Step 1:</strong> ${escHtml(source.processStep1.substring(0, 80))}${source.processStep1.length > 80 ? '...' : ''}</div>`;
  6185	  if (source.materials) html += `<div><strong>Materials:</strong> ${escHtml(source.materials.substring(0, 100))}${source.materials.length > 100 ? '...' : ''}</div>`;
  6186	
  6187	  html += `</div></div>
  6188	    <div class="ca-copy-targets">
  6189	      <label>Copy to:</label>
  6190	      <div class="ca-copy-select-all">
  6191	        <label><input type="checkbox" id="ca-copy-select-all" checked onchange="toggleCopyAll(this)"> Select All</label>
  6192	      </div>`;
  6193	
  6194	  for (const s of shared) {
  6195	    const hasPlan = hasLessonContent(s);
  6196	    const warnClass = hasPlan ? 'ca-copy-has-plan' : '';
  6197	    const warnLabel = hasPlan ? ' (has existing plan — will overwrite)' : ' (no plan yet)';
  6198	    html += `<div class="ca-copy-target ${warnClass}">
  6199	      <label>
  6200	        <input type="checkbox" class="ca-copy-cb" data-key="${escAttr(s.key)}" ${!hasPlan ? 'checked' : ''}>
  6201	        ${escHtml(s.teacher)} &mdash; ${escHtml(s.className)} (Week ${s.weekNum})
  6202	        <span class="ca-copy-warn">${warnLabel}</span>
  6203	      </label>
  6204	    </div>`;
  6205	  }
  6206	
  6207	  html += `</div>
  6208	    <div class="ca-actions" style="margin-top: 16px;">
  6209	      <button class="btn-primary ca-action-btn ca-copy-btn" onclick="executeCopyPlan(${escForOnclick(sourceKey)})">Copy Plan</button>
  6210	      <button class="btn-secondary ca-action-btn" onclick="openDetailModal(currentLessonData[${escForOnclick(semKey)}][${escForOnclick(sourceKey)}], ${escForOnclick(sourceKey)}, ${escForOnclick(source.teacher)}, ${escForOnclick(source.className)}, ${source.weekNum})">Back</button>
  6211	    </div>
  6212	  </div>`;
  6213	
  6214	  body.innerHTML = html;
  6215	}
  6216	
  6217	function toggleCopyAll(masterCb) {
  6218	  document.querySelectorAll('.ca-copy-cb').forEach(cb => { cb.checked = masterCb.checked; });
  6219	}
  6220	
  6221	// Backtracking audit, Phase 11 (R3-12, R3-13). Previously resaved the ENTIRE
  6222	// cached semester via saveLessonData() — any lesson whose local copy was stale
  6223	// (a teacher's concurrent save in another tab) was silently reverted on the
  6224	// server — mutated the shared cache before any write landed, and logged only
  6225	// after one bulk save, so a part-way failure lost the log for targets that
  6226	// had actually been written. Now: one targeted saveSingleLesson() per target
  6227	// with an explicit fieldsToClear (a source field that is EMPTY must clear the
  6228	// target's stale value — the save strips empty content fields, so without the
  6229	// clear the old text would survive under the new plan), cache committed per
  6230	// target only after its save resolves, logged immediately, honest count on
  6231	// failure.
  6232	async function executeCopyPlan(sourceKey) {
  6233	  const semKey = getAdminSemKey();
  6234	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  6235	  if (refuseIfWeeklySemesterPaused(semKey)) return;
  6236	  const liveLessons = currentLessonData?.[semKey];
  6237	  const source = liveLessons?.[sourceKey];
  6238	  if (!source) return;
  6239	
  6240	  const checkboxes = document.querySelectorAll('.ca-copy-cb:checked');
  6241	  const targetKeys = Array.from(checkboxes).map(cb => cb.dataset.key);
  6242	
  6243	  if (targetKeys.length === 0) {
  6244	    alert('No targets selected.');
  6245	    return;
  6246	  }
  6247	
  6248	  // Check if any targets have existing plans
  6249	  const overwriteTargets = targetKeys.filter(k => liveLessons[k] && hasLessonContent(liveLessons[k]));
  6250	  if (overwriteTargets.length > 0) {
  6251	    const names = overwriteTargets.map(k => {
  6252	      const l = liveLessons[k];
  6253	      return `${l.teacher} — ${l.className} (Wk ${l.weekNum})`;
  6254	    }).join('\n');
  6255	    if (!confirm(`${overwriteTargets.length} target(s) already have lesson plans that will be overwritten:\n\n${names}\n\nContinue?`)) return;
  6256	  }
  6257	
  6258	  const fields = getCopyableFields(source); // the 7 CONTENT_FIELDS plus `materials`
  6259	  let savedCount = 0;
  6260	  let failure = null;
  6261	
  6262	  try {
  6263	    for (const targetKey of targetKeys) {
  6264	      if (!liveLessons[targetKey]) continue;
  6265	      // Work on copies — the shared cache object is only replaced below,
  6266	      // after this target's own save has resolved (R3-13).
  6267	      const previousTarget = { ...liveLessons[targetKey] };
  6268	      const targetFieldsToClear = CONTENT_FIELDS.filter(f =>
  6269	        (previousTarget[f] || '').trim() !== '' && !(fields[f] || '').trim()
  6270	      );
  6271	      // Send ONLY the copied fields (saveSingleLesson writes per-field paths
  6272	      // and stamps lastEditedBy/At onto this object). Sending the whole
  6273	      // cached target would re-write every non-content field — qaThread,
  6274	      // photoUrl, planComplete… — from this admin's possibly-stale copy over
  6275	      // a teacher's concurrent change (implementation review, Sep 2026).
  6276	      const payload = { ...fields };
  6277	      await saveSingleLesson(semKey, targetKey, payload, targetFieldsToClear);
  6278	      const updatedTarget = { ...previousTarget, ...payload };
  6279	      if (currentLessonData[semKey]) currentLessonData[semKey][targetKey] = updatedTarget;
  6280	      savedCount++;
  6281	      // Uncheck the saved target so, if a later one fails, "retry the rest"
  6282	      // re-runs only the rest (no duplicate copies or Change History entries).
  6283	      const cb = document.querySelector(`.ca-copy-cb[data-key="${CSS.escape(targetKey)}"]`);
  6284	      if (cb) cb.checked = false;
  6285	
  6286	      // Log this copy now — before the next target — so a later failure
  6287	      // can't lose the record of a write that already landed.
  6288	      const logEntry = {
  6289	        action: 'copy',
  6290	        details: {
  6291	          projectTitle: source.projectTitle,
  6292	          fromTeacher: source.teacher,
  6293	          fromClassName: source.className,
  6294	          fromWeek: source.weekNum,
  6295	          toTeacher: updatedTarget.teacher,
  6296	          toClassName: updatedTarget.className,
  6297	          toWeek: updatedTarget.weekNum
  6298	        }
  6299	      };
  6300	      // Capture the overwritten plan whenever ANY copyable field had text —
  6301	      // the clear above is explicit and intentional, so Change History must
  6302	      // hold the recovery record even when the prior content lived only in
  6303	      // processStep2-4/closure/dayOfMaterials (which the looser
  6304	      // hasLessonContent() used for the confirm prompt doesn't look at).
  6305	      const previousPlan = getCopyableFields(previousTarget);
  6306	      if (Object.values(previousPlan).some(v => String(v).trim())) {
  6307	        logEntry.details.previousPlan = previousPlan;
  6308	      }
  6309	      try {
  6310	        await appendChangeLogEntry(semKey, logEntry);
  6311	      } catch (logErr) {
  6312	        // The copy itself is saved; a Change History miss must not read as
  6313	        // a failed copy (same rule as saveTeacherEdit(), Phase 8).
  6314	        console.error('⚠️ Copy saved, but Change History logging failed for', targetKey, logErr);
  6315	      }
  6316	    }
  6317	  } catch (err) {
  6318	    console.error('❌ Copy Plan failed partway through:', err);
  6319	    failure = err;
  6320	  }
  6321	
  6322	  // UI after the try/catch so a render exception can't be misreported as a
  6323	  // failed save (and can't re-throw from inside the catch).
  6324	  renderAdminGrid();
  6325	  renderChangeHistory();
  6326	  if (failure) {
  6327	    alert(`Copied to ${savedCount} of ${targetKeys.length} class(es) before a save failed. Please check which targets actually received the plan before retrying the rest.\n\n${failure.message}`);
  6328	    return;
  6329	  }
  6330	  closeAdminModal();
  6331	  const skipped = targetKeys.length - savedCount;
  6332	  alert(`Plan copied to ${savedCount} class${savedCount !== 1 ? 'es' : ''}${skipped > 0 ? ` (${skipped} skipped)` : ''}.`);
  6333	}
  6334	
  6335	// Backtracking audit, Phase 8: rebuilt around the companion plan's Phase 17
  6336	// design. Forced-server read before archiving or deleting anything (closes
  6337	// two failure modes: the doc no longer existing at all, and the doc existing
  6338	// but having genuinely different content than this admin's stale local
  6339	// snapshot — a teacher's concurrent edit). Archives the COMPLETE fresh
  6340	// lesson object (not a hand-picked field list) via FieldValue.arrayUnion()
  6341	// against curriculum/cutProjects (not saveCutProjects()'s local-splice-then-
  6342	// full-array-overwrite — two admins cutting concurrently now both survive
  6343	// regardless of write order). Archive-before-delete ordering — a failed
  6344	// archive save leaves the live lesson completely untouched.
  6345	async function cutProject(key) {
  6346	  const semKey = getAdminSemKey();
  6347	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  6348	  if (refuseIfWeeklySemesterPaused(semKey)) return;
  6349	  const lessons = { ...currentLessonData[semKey] };
  6350	  const lesson = lessons[key];
  6351	  if (!lesson) return;
  6352	
  6353	  if (!confirm(`Cut "${lesson.projectTitle}" from ${lesson.teacher} / ${lesson.className} Week ${lesson.weekNum}? It will be moved to the Cut Projects bank.`)) return;
  6354	
  6355	  let check;
  6356	  try {
  6357	    check = await adminLessonStillExistsWithRetry(semKey, key);
  6358	  } catch (err) {
  6359	    console.error('Could not confirm current state before cutting', key, err);
  6360	    alert(`Could not confirm "${lesson.projectTitle}" still exists — nothing was cut. Check your connection and try again.`);
  6361	    return;
  6362	  }
  6363	  if (!check.exists) {
  6364	    alert(`"${lesson.projectTitle}" no longer exists — it may have been moved, deleted, or already cut by someone else. Nothing was cut.`);
  6365	    if (currentLessonData[semKey]) delete currentLessonData[semKey][key];
  6366	    renderAdminGrid();
  6367	    return;
  6368	  }
  6369	  const freshLesson = check.data;
  6370	
  6371	  // The first confirm() above authorized cutting THIS project, by name — if
  6372	  // the fresh read shows the slot's identity has materially changed since
  6373	  // then, that authorization doesn't cover it.
  6374	  if (freshLesson.projectTitle !== lesson.projectTitle || freshLesson.teacher !== lesson.teacher || freshLesson.className !== lesson.className) {
  6375	    if (!confirm(`This slot has changed since you opened it — it now contains "${freshLesson.projectTitle}" (${freshLesson.teacher} / ${freshLesson.className}). Cut this instead?`)) return;
  6376	  }
  6377	
  6378	  const user = getAuthUser();
  6379	  const archiveEntry = {
  6380	    ...freshLesson,
  6381	    originalTeacher: freshLesson.teacher,
  6382	    originalClassName: freshLesson.className,
  6383	    originalWeek: freshLesson.weekNum,
  6384	    cutDate: new Date().toISOString(),
  6385	    cutBy: user?.name || 'Unknown'
  6386	  };
  6387	
  6388	  if (!curriculumDb) initCurriculumFirestore();
  6389	  try {
  6390	    await curriculumDb.collection('curriculum').doc('cutProjects').set({
  6391	      [semKey]: firebase.firestore.FieldValue.arrayUnion(archiveEntry)
  6392	    }, { merge: true });
  6393	  } catch (e) {
  6394	    console.error('Could not save Cut Bank entry for', key, e);
  6395	    alert(`Could not cut "${freshLesson.projectTitle}" — the Cut Bank entry could not be saved. Nothing was changed.`);
  6396	    return;
  6397	  }
  6398	
  6399	  let deleteFailed = false;
  6400	  try {
  6401	    await deleteLessonKey(semKey, key);
  6402	  } catch (e) {
  6403	    console.error('Could not delete lesson after archiving', key, e);
  6404	    deleteFailed = true;
  6405	  }
  6406	
  6407	  // Local cache/grid only drops the lesson when the delete actually
  6408	  // succeeded — a failed delete leaves the grid showing the lesson as gone
  6409	  // while Firestore still has it live otherwise.
  6410	  if (!deleteFailed) {
  6411	    delete lessons[key];
  6412	    currentLessonData[semKey] = lessons;
  6413	  }
  6414	  if (!currentCutProjects) currentCutProjects = {};
  6415	  currentCutProjects[semKey] = [...(currentCutProjects[semKey] || []), archiveEntry];
  6416	
  6417	  try {
  6418	    await appendChangeLogEntry(semKey, {
  6419	      action: 'cut',
  6420	      details: { projectTitle: freshLesson.projectTitle, teacher: freshLesson.teacher, className: freshLesson.className, fromWeek: freshLesson.weekNum }
  6470	    html += '</div>';
  6471	  } else {
  6472	    html += '<p class="ca-empty-hint" style="margin-bottom:12px">No cut projects in this semester.</p>';
  6473	  }
  6474	
  6475	  // Other semesters
  6476	  if (otherSemesters.length > 0) {
  6477	    html += `<details style="margin-top:16px"><summary style="font-size:14px;font-weight:600;cursor:pointer;color:var(--tinker-purple)">From previous semesters (${otherSemesters.reduce((s, o) => s + o.projects.length, 0)} projects)</summary>`;
  6478	    for (const other of otherSemesters) {
  6479	      html += `<div style="margin-top:12px"><div style="font-size:12px;font-weight:700;color:var(--text-light);text-transform:uppercase;margin-bottom:6px">${escHtml(other.name)}</div><div class="ca-cut-list">`;
  6480	      other.projects.forEach((proj, idx) => {
  6481	        html += `<div class="ca-cut-item" onclick="pasteFromCutBank(${idx}, ${escForOnclick(teacher)}, ${escForOnclick(className)}, ${weekNum}, ${escForOnclick(other.key)})">
  6482	          <div class="ca-cut-item-title">${escHtml(proj.projectTitle)}</div>
  6483	          <div class="ca-cut-item-meta">Originally: ${escHtml(proj.originalTeacher)} / ${escHtml(proj.originalClassName || '')} Week ${proj.originalWeek} &middot; Cut ${new Date(proj.cutDate).toLocaleDateString()}</div>
  6484	        </div>`;
  6485	      });
  6486	      html += '</div></div>';
  6487	    }
  6488	    html += '</details>';
  6489	  }
  6490	
  6491	  body.innerHTML = html;
  6492	}
  6493	
  6494	// Backtracking audit, Phase 8: targeted single-lesson save (not a bulk
  6495	// saveLessonData() semester overwrite), removal via FieldValue.arrayRemove()
  6496	// (not saveCutProjects()'s local-splice-then-full-array-overwrite — matches
  6497	// cutProject()'s arrayUnion() append-side fix, same document, same reasoning:
  6498	// two admins acting on the Cut Bank concurrently now both survive). The
  6499	// reconstruction below is an EXPLICIT FIELD WHITELIST, not spread-minus-
  6500	// exclude — a whitelist can't leak a future field cutProject()'s
  6501	// complete-spread archive starts including that an exclude-list doesn't yet
  6502	// know to exclude. classSize preserves the destination's own existing
  6503	// scaffold value (round-6 fix) rather than being hardcoded to 0 — nothing
  6504	// downstream recomputes it on paste. teacherNotes/adminResponse/status are
  6505	// excluded alongside qaThread (round-6 fix): getQaThread() reconstructs a
  6506	// Q&A thread from teacherNotes/adminResponse whenever qaThread is absent, so
  6507	// restoring those two fields alone would still leak the original
  6508	// conversation even with qaThread itself correctly omitted.
  6509	async function pasteFromCutBank(cutIndex, teacher, className, weekNum, sourceSemKey) {
  6510	  const destSemKey = getAdminSemKey();
  6511	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  6512	  if (refuseIfWeeklySemesterPaused(destSemKey)) return;
  6513	  const srcSemKey = sourceSemKey || destSemKey;
  6514	  const cutProjects = currentCutProjects?.[srcSemKey] || [];
  6515	  const proj = cutProjects[cutIndex];
  6516	  if (!proj) return;
  6517	
  6518	  const isCrossSemester = srcSemKey !== destSemKey;
  6519	  const srcSemName = currentConfig?.semesters?.[srcSemKey]?.name || srcSemKey;
  6520	  const confirmMsg = isCrossSemester
  6521	    ? `Paste "${proj.projectTitle}" from ${srcSemName} into ${teacher} / ${className} Week ${weekNum}?`
  6522	    : `Paste "${proj.projectTitle}" into ${teacher} / ${className} Week ${weekNum}?`;
  6523	  if (!confirm(confirmMsg)) return;
  6524	
  6525	  const key = makeLessonKey(teacher, className, weekNum);
  6526	  const lessons = { ...(currentLessonData?.[destSemKey] || {}) };
  6527	  const existingDest = lessons[key] || {};
  6528	  const existingDestClassSize = existingDest.classSize || 0;
  6529	  const existingDestPhotoPath = existingDest.photoPath || null;
  6530	
  6531	  lessons[key] = {
  6532	    teacher, className, weekNum, weekDate: '', classSize: existingDestClassSize,
  6533	    projectTitle: proj.projectTitle,
  6534	    shortDetails: proj.shortDetails || '',
  6535	    inspoLink: proj.inspoLink || '',
  6536	    introPitch: proj.introPitch || '',
  6537	    processStep1: proj.processStep1 || '', processStep2: proj.processStep2 || '',
  6538	    processStep3: proj.processStep3 || '', processStep4: proj.processStep4 || '',
  6539	    closure: proj.closure || '',
  6540	    materials: proj.materials || '',
  6541	    materialsList: proj.materialsList || [],
  6542	    dayOfMaterials: proj.dayOfMaterials || '',
  6543	    publishToPrep: proj.publishToPrep || '',
  6544	    lastImported: new Date().toISOString()
  6545	    // Deliberately NOT restored: qaThread, photoUrl/photoPath, planComplete
  6546	    // (tied to the ORIGINAL lesson instance, not reusable project content),
  6547	    // and teacherNotes/adminResponse/status (round-6: getQaThread() would
  6548	    // silently reconstruct the original Q&A conversation from these alone).
  6549	  };
  6550	  // Merely OMITTING those fields above only means "don't touch them" — if the
  6551	  // DESTINATION slot already had its own stale qaThread/photo/planComplete
  6552	  // from whatever occupied it before, that would otherwise survive untouched
  6553	  // and resurrect an unrelated Q&A thread under the newly-pasted content.
  6554	  // Explicitly clear them so a paste genuinely starts fresh.
  6555	  const NON_CONTENT_FIELDS_TO_CLEAR = ['qaThread', 'photoUrl', 'photoPath', 'planComplete', 'teacherNotes', 'adminResponse', 'status'];
  6556	
  6557	  let pasteConfirmed = false;
  6558	  try {
  6559	    await saveSingleLesson(destSemKey, key, lessons[key], NON_CONTENT_FIELDS_TO_CLEAR);
  6560	    pasteConfirmed = true;
  6561	  } catch (err) {
  6562	    console.error('❌ Paste from Cut Bank failed to save the lesson:', err);
  6563	    alert(`Could not paste "${proj.projectTitle}" — please try again.`);
  6564	    return;
  6565	  }
  6566	
  6567	  // Only delete the destination's old photo from Storage after Firestore has
  6568	  // confirmed the clear — same safe ordering as saveAdminEdit()/saveTeacherEdit().
  6569	  if (existingDestPhotoPath) {
  6570	    try {
  6571	      await deleteLessonPhoto(existingDestPhotoPath);
  6572	    } catch (cleanupErr) {
  6573	      console.error('⚠️ Could not clean up destination\'s old photo after paste (Firestore is correct, Storage has an orphan):', cleanupErr);
  6574	    }
  6575	  }
  6576	
  6577	  currentLessonData[destSemKey] = lessons;
  6578	  closeAdminModal();
  6579	  renderAdminGrid();
  6580	
  6940	  const projects = (currentFutureProjects?.projects || []).filter(p => !p.archived);
  6941	
  6942	  if (projects.length === 0) {
  6943	    alert('No ideas in the bank. Add some in the Future Projects section first.');
  6944	    return;
  6945	  }
  6946	
  6947	  const body = document.getElementById('ca-modal-body');
  6948	  let html = `<h4 class="ca-paste-title">Paste from Idea Bank</h4>
  6949	    <p class="ca-paste-hint">Select an idea to place in ${escHtml(teacher)} / ${escHtml(className)} Week ${weekNum}:</p>
  6950	    <p class="ca-paste-hint" style="font-style:italic;color:var(--tinker-teal)">Pasting places the idea on the grid — it will be removed from the Idea Bank.</p>
  6951	    <div class="ca-cut-list">`;
  6952	
  6953	  projects.forEach((proj, idx) => {
  6954	    // Find the real index in the full array (including archived)
  6955	    const realIdx = currentFutureProjects.projects.indexOf(proj);
  6956	    html += `<div class="ca-cut-item" onclick="pasteFromIdeaBank(${realIdx}, ${escForOnclick(teacher)}, ${escForOnclick(className)}, ${weekNum})">
  6957	      <div class="ca-cut-item-title">${escHtml(proj.title)}</div>
  6958	      <div class="ca-cut-item-meta">${proj.description ? escHtml(proj.description.substring(0, 100)) + (proj.description.length > 100 ? '...' : '') : 'No description'}</div>
  6959	      ${proj.tags?.length ? `<div class="ca-ideabank-tags" style="margin-top:4px">${proj.tags.map(t => `<span class="ca-tag-pill">${escHtml(t)}</span>`).join('')}</div>` : ''}
  6960	    </div>`;
  6961	  });
  6962	
  6963	  html += '</div>';
  6964	  body.innerHTML = html;
  6965	}
  6966	
  6967	// Backtracking audit Phase 11 (R3-10, R3-11, round-4 fieldsToClear; hardened
  6968	// by this session's implementation review): the original bulk
  6969	// saveLessonData() write passed the WHOLE {projects:[...]} wrapper into
  6970	// saveFutureProjects() (which expects a bare array), double-nesting
  6971	// curriculum/futureProjects and corrupting renderIdeaBank()'s cache — a
  6972	// deterministic, live production bug. Also removed the idea from the bank
  6973	// BEFORE the destination lesson save was confirmed. Rewritten around a
  6974	// targeted saveSingleLesson() write (unrelated lessons in the same semester
  6975	// are no longer touched), explicit fieldsToClear against the destination's
  6976	// own pre-existing stale content — both CONTENT_FIELDS and the
  6977	// instance-specific fields an Idea Bank project never supplies (matching
  6978	// pasteFromCutBank()'s own NON_CONTENT_FIELDS_TO_CLEAR pattern, since simply
  6979	// omitting a field only means "don't touch it," not "clear it") — and
  6980	// lesson-save-then-idea-removal ordering with an honest duplicate-message on
  6981	// a removal failure.
  6982	async function pasteFromIdeaBank(idx, teacher, className, weekNum) {
  6983	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  6984	  if (refuseIfWeeklySemesterPaused(getAdminSemKey())) return;
  6985	  const projects = currentFutureProjects?.projects || [];
  6986	  const proj = projects[idx];
  6987	  if (!proj) return;
  6988	
  6989	  if (!confirm(`Paste "${proj.title}" into ${teacher} / ${className} Week ${weekNum}? The idea will be removed from the bank.`)) return;
  6990	
  6991	  const semKey = getAdminSemKey();
  6992	  const key = makeLessonKey(teacher, className, weekNum);
  6993	  const existingLesson = currentLessonData?.[semKey]?.[key] || {};
  6994	  const existingClassSize = existingLesson.classSize || 0;
  6995	  const existingPhotoPath = existingLesson.photoPath || null;
  6996	  const newLesson = {
  6997	    teacher,
  6998	    className,
  6999	    weekNum,
  7000	    weekDate: '',
  7001	    classSize: existingClassSize,
  7002	    projectTitle: proj.title,
  7003	    shortDetails: proj.description || '',
  7004	    inspoLink: proj.inspoLink || '',
  7005	    introPitch: '',
  7006	    processStep1: '',
  7007	    processStep2: '',
  7008	    processStep3: '',
  7009	    processStep4: '',
  7010	    closure: '',
  7011	    materials: '',
  7012	    dayOfMaterials: '',
  7013	    status: '',
  7014	    publishToPrep: '',
  7015	    teacherNotes: '',
  7016	    adminResponse: '',
  7017	    lastImported: new Date().toISOString()
  7018	  };
  7019	
  7020	  // An idea's blank fields must actually CLEAR stale destination content, not
  7021	  // silently leave it — same pattern used everywhere else in this plan.
  7022	  const fieldsToClear = CONTENT_FIELDS.filter(f =>
  7023	    (existingLesson[f] || '').trim() !== '' && !(newLesson[f] || '').trim()
  7024	  );
  7025	  // Instance-specific fields tied to whatever previously occupied this slot —
  7026	  // an Idea Bank project never supplies these, so newLesson never sets them,
  7027	  // and buildLessonFieldUpdates() only touches fields actually present in the
  7028	  // object it's given. Without an explicit clear, a destination's own stale
  7029	  // Q&A thread, photo, completion flag, or materials list would silently
  7030	  // resurrect under the newly-pasted idea.
  7031	  const NON_CONTENT_FIELDS_TO_CLEAR = ['qaThread', 'photoUrl', 'photoPath', 'planComplete', 'materialsList'];
  7032	
  7033	  try {
  7034	    await saveSingleLesson(semKey, key, newLesson, [...fieldsToClear, ...NON_CONTENT_FIELDS_TO_CLEAR]);
  7035	    if (currentLessonData[semKey]) currentLessonData[semKey][key] = newLesson;
  7036	  } catch (err) {
  7037	    console.error('❌ Paste from Idea Bank failed — lesson could not be saved:', err);
  7038	    alert(`Could not paste "${proj.title}" — please try again. The idea is still in the bank.`);
  7039	    return;
  7040	  }
  7041	
  7042	  // Only delete the destination's old photo from Storage after Firestore has
  7043	  // confirmed the clear — same safe ordering as pasteFromCutBank()/
  7044	  // saveAdminEdit()/saveTeacherEdit().
  7045	  if (existingPhotoPath) {
  7046	    try {
  7047	      await deleteLessonPhoto(existingPhotoPath);
  7048	    } catch (cleanupErr) {
  7049	      console.error('⚠️ Could not clean up destination\'s old photo after paste (Firestore is correct, Storage has an orphan):', cleanupErr);
  7050	    }
  7180	function toggleHqFilter() {
  7181	  hqFilterNeedsReply = !hqFilterNeedsReply;
  7182	  renderHelpQueue();
  7183	}
  7184	
  7185	function getTimeAgo(timestamp) {
  7186	  const now = Date.now();
  7187	  const then = new Date(timestamp).getTime();
  7188	  const diff = now - then;
  7189	  const mins = Math.floor(diff / 60000);
  7190	  if (mins < 1) return 'just now';
  7191	  if (mins < 60) return `${mins}m ago`;
  7192	  const hours = Math.floor(mins / 60);
  7193	  if (hours < 24) return `${hours}h ago`;
  7194	  const days = Math.floor(hours / 24);
  7195	  if (days === 1) return 'yesterday';
  7196	  return `${days}d ago`;
  7197	}
  7198	
  7199	// Shared by sendHelpResponse() and sendQaReply() below — seeds arrayUnion's
  7200	// argument list with the legacy teacherNotes/adminResponse thread on a
  7201	// lesson's FIRST atomic-append reply, so that legacy content isn't silently
  7202	// lost the moment qaThread gets its first real entry. arrayUnion's deep-
  7203	// equality dedup makes repeating this migration from concurrent senders safe.
  7204	function buildQaThreadUnionArgs(existingLesson, newEntry) {
  7205	  const needsMigration = !existingLesson?.qaThread || existingLesson.qaThread.length === 0;
  7206	  return needsMigration ? [...getQaThread(existingLesson || {}), newEntry] : [newEntry];
  7207	}
  7208	
  7209	// Backtracking audit Phase 11 fix: both admin Q&A reply functions used to
  7210	// resave the ENTIRE cached semester via saveLessonData() — a Firestore
  7211	// set({merge:true}) of every lesson currently sitting in this admin's
  7212	// browser, not just the one being replied to. If a teacher's save landed on
  7213	// the server in the split-second before this admin's live listener caught
  7214	// up, that reply would silently revert the teacher's edit back to this
  7215	// admin's stale cached copy — for ANY lesson in the semester, not just the
  7216	// one in the reply. Now a single targeted Firestore .update() touching only
  7217	// this lesson's own field paths, with arrayUnion() for qaThread (survives a
  7218	// genuinely concurrent sender) and an existence check (a stale, long-open
  7219	// popup can't silently recreate a lesson deleted/moved elsewhere).
  7220	async function sendHelpResponse(key) {
  7221	  const input = document.getElementById(`ca-help-input-${key}`);
  7222	  if (!input) return;
  7223	  const response = input.value.trim();
  7224	  if (!response) return;
  7225	
  7226	  const semKey = getAdminSemKey();
  7227	  // Same load guard as every other lesson writer (Phase 1 review): after a
  7228	  // failed reload the listener deliberately KEEPS the previous summer maps, so
  7229	  // the cached lesson and the existence check both still pass — without this
  7230	  // an admin could write a reply while the banner says saving is disabled.
  7231	  if (lessonDataLoadedSuccessfully === false) {
  7232	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  7233	    return;
  7234	  }
  7235	  // A semester type this writer has no branch for is refused here, before the
  7236	  // existence check below — a throw inside that try would be reported to the
  7237	  // admin as "check your connection", which it isn't (Phase 1, 1.1).
  7238	  let lessonStore;
  7239	  try {
  7240	    lessonStore = lessonStoreFor(semKey);
  7241	  } catch (err) {
  7242	    alert(err.message);
  7243	    return;
  7244	  }
  7245	  const cachedExisting = currentLessonData?.[semKey]?.[key];
  7246	  if (!cachedExisting) return;
  7247	
  7248	  let check;
  7249	  try {
  7250	    check = await adminLessonStillExistsWithRetry(semKey, key);
  7251	  } catch (err) {
  7252	    console.warn('⚠️ Existence check retry also failed:', err);
  7253	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  7254	    return;
  7255	  }
  7256	  if (!check.exists) {
  7257	    alert('This lesson was moved or removed elsewhere. Your response was not sent — please close this and check the grid for its new location.');
  7258	    return;
  7259	  }
  7260	  const existing = check.data || cachedExisting;
  7261	
  7262	  const user = getAuthUser();
  7263	  const newEntry = {
  7264	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  7265	    from: 'admin', name: user?.name || 'Admin', message: response, timestamp: new Date().toISOString()
  7266	  };
  7267	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7268	
  7269	  if (!curriculumDb) initCurriculumFirestore();
  7270	  const isSummer = lessonStore === 'camp';
  7271	  const updates = {};
  7272	  let weekly = null;
  7273	  if (!isSummer) {
  7274	    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
  7275	  }
  7276	  if (isSummer) {
  7277	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7278	    updates.adminResponse = response;
  7279	    updates.status = 'In Progress';
  7280	    updates.lastUpdated = new Date().toISOString();
  7281	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7282	  } else {
  7283	    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7284	    updates[`${weekly.prefix}${key}.adminResponse`] = response;
  7285	    updates[`${weekly.prefix}${key}.status`] = 'In Progress';
  7286	    updates.lastUpdated = new Date().toISOString();
  7287	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7288	  }
  7289	  const docRef = isSummer
  7290	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7291	    : weekly.ref;
  7292	
  7293	  try {
  7294	    await docRef.update(updates);
  7295	  } catch (err) {
  7296	    console.error('Error sending help response:', err);
  7297	    alert('Error sending response: ' + err.message);
  7298	    return;
  7299	  }
  7300	
  7301	  currentLessonData[semKey][key] = {
  7302	    ...existing, adminResponse: response,
  7303	    qaThread: [...(existing.qaThread && existing.qaThread.length > 0 ? existing.qaThread : getQaThread(existing)), newEntry],
  7304	    status: 'In Progress'
  7305	  };
  7306	  renderHelpQueue();
  7307	}
  7308	
  7309	async function sendQaReply(key) {
  7310	  const input = document.getElementById(`qa-reply-${key}`);
  7311	  if (!input) return;
  7312	  const message = input.value.trim();
  7313	  if (!message) return;
  7314	
  7315	  const semKey = getAdminSemKey();
  7316	  // Same load guard as every other lesson writer (Phase 1 review): after a
  7317	  // failed reload the listener deliberately KEEPS the previous summer maps, so
  7318	  // the cached lesson and the existence check both still pass — without this
  7319	  // an admin could write a reply while the banner says saving is disabled.
  7320	  if (lessonDataLoadedSuccessfully === false) {
  7321	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  7322	    return;
  7323	  }
  7324	  // A semester type this writer has no branch for is refused here, before the
  7325	  // existence check below — a throw inside that try would be reported to the
  7326	  // admin as "check your connection", which it isn't (Phase 1, 1.1).
  7327	  let lessonStore;
  7328	  try {
  7329	    lessonStore = lessonStoreFor(semKey);
  7330	  } catch (err) {
  7331	    alert(err.message);
  7332	    return;
  7333	  }
  7334	  const cachedExisting = currentLessonData?.[semKey]?.[key];
  7335	  if (!cachedExisting) return;
  7336	
  7337	  let check;
  7338	  try {
  7339	    check = await adminLessonStillExistsWithRetry(semKey, key);
  7340	  } catch (err) {
  7341	    console.warn('⚠️ Existence check retry also failed:', err);
  7342	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  7343	    return;
  7344	  }
  7345	  if (!check.exists) {
  7346	    alert('This lesson was moved or removed elsewhere. Your reply was not sent — please close this window and check the grid for its new location.');
  7347	    return;
  7348	  }
  7349	  const existing = check.data || cachedExisting;
  7350	
  7351	  const user = getAuthUser();
  7352	  const newEntry = {
  7353	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  7354	    from: 'admin', name: user?.name || 'Admin', message, timestamp: new Date().toISOString()
  7355	  };
  7356	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7357	
  7358	  if (!curriculumDb) initCurriculumFirestore();
  7359	  const isSummer = lessonStore === 'camp';
  7360	  const updates = {};
  7361	  let weekly = null;
  7362	  if (!isSummer) {
  7363	    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
  7364	  }
  7365	  if (isSummer) {
  7366	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7367	    updates.adminResponse = message;
  7368	    updates.lastUpdated = new Date().toISOString();
  7369	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7370	  } else {
  7371	    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7372	    updates[`${weekly.prefix}${key}.adminResponse`] = message;
  7373	    updates.lastUpdated = new Date().toISOString();
  7374	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7375	  }
  7376	  const docRef = isSummer
  7377	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7378	    : weekly.ref;
  7379	
  7380	  try {
  7381	    await docRef.update(updates);
  7382	  } catch (err) {
  7383	    console.error('Error sending Q&A reply:', err);
  7384	    alert('Error sending reply: ' + err.message);
  7385	    return;
 10880	    }
 10881	  }
 10882	
 10883	  // Hide weekly-only sections for camp seasons
 10884	  document.querySelectorAll('.spring-fall-only').forEach(el => {
 10885	    el.style.display = isSummer ? 'none' : 'block';
 10886	  });
 10887	
 10888	  // An SDOC year owns name, start, end and its teacher-name pool — no weeks,
 10889	  // breaks, closures or class roster (plan 1.5).
 10890	  const isDayOff = isDayOffYear(semKey);
 10891	  document.querySelectorAll('.weekly-only-field').forEach(row => { row.style.display = isDayOff ? 'none' : ''; });
 10892	  document.querySelectorAll('.dayoff-only-field').forEach(row => { row.hidden = !isDayOff; });
 10893	  const namesDesc = document.getElementById('teacher-names-desc');
 10894	  if (namesDesc) {
 10895	    namesDesc.textContent = isDayOff
 10896	      ? 'The teachers who may run this year\'s day-off camps. They appear as the teacher checkboxes in each camp.'
 10897	      : 'Define teacher names for this semester. These appear in the Class Roster teacher dropdown and Curriculum Admin grid.';
 10898	  }
 10899	  if (isDayOff) {
 10900	    document.querySelectorAll('.weekly-roster-section').forEach(sec => { sec.style.display = 'none'; });
 10901	    if (el('settings-dayoff-start')) el('settings-dayoff-start').value = semester.startDate || '';
 10902	    if (el('settings-end-date')) el('settings-end-date').value = semester.endDate || '';
 10903	  }
 10904	
 10905	  renderSeasonsCard();
 10906	  renderSemesterTypeMigrationCard();
 10907	}
 10908	
 10909	// Pull this camp season's six registry-sourced fields again — the one way to
 10910	// change them here, and it copies rather than types (Phase 1, 1.6/1.7).
 10911	async function resyncCampSeasonFromRegistry() {
 10912	  const semKey = getSettingsSemKey();
 10913	  const sem = currentConfig?.semesters?.[semKey];
 10914	  if (!sem || !isCampSeason(semKey)) return;
 10915	  try {
 10916	    const registered = await listRegisteredSeasons();
 10917	    const reg = registered.find(r => r.season === seasonForSemester(semKey));
 10918	    if (!reg) { alert(`The Summer Camp App has no season ${seasonForSemester(semKey)} to sync from.`); return; }
 10919	    // Validate the RAW registry document: semesterFromRegistrySeason() coerces
 10920	    // anything absent to ''/0/[], so checking its OUTPUT could never see a
 10921	    // missing name, and let a negative week count or an empty-string studio
 10922	    // through (Phase 1 fix review).
 10923	    const problems = registrySeasonProblems(reg);
 10924	    if (problems.length) {
 10925	      alert(`Can't re-sync ${seasonForSemester(semKey)}: the Summer Camp App's season still needs ${problems.join(', ')}. Finish setting it up there first — nothing was changed here.`);
 10926	      return;
 10927	    }
 10928	    const fresh = semesterFromRegistrySeason(reg);
 10929	    const paths = {};
 10930	    const previous = {};
 10931	    for (const f of ['name', 'startDate', 'numWeeks', 'breakWeeks', 'timeSlots', 'studios']) {
 10932	      paths[`semesters.${semKey}.${f}`] = fresh[f];
 10933	      previous[f] = sem[f];
 10934	      sem[f] = fresh[f];
 10935	    }
 10936	    try {
 10937	      await updateAppData(paths);
 10938	    } catch (err) {
 10939	      // Put this tab back the way it was — the server never changed.
 10940	      for (const [f, v] of Object.entries(previous)) { if (v === undefined) delete sem[f]; else sem[f] = v; }
 10941	      throw err;
 10942	    }
 10943	    loadSettingsForm();
 10944	    renderAdminGrid();
 10945	    alert(`${fresh.name} re-synced from the Summer Camp App.`);
 10946	  } catch (err) {
 10947	    console.error('Could not re-sync the season:', err);
 10948	    alert(`Could not re-sync: ${err.message}`);
 10949	  }
 10950	}
 10951	
 10952	// Read-only: what the registry holds, which seasons are in the Classbook, and
 10953	// which mode this tab is in.
 10954	function renderSeasonsCard() {
 10955	  const card = document.getElementById('settings-seasons-card');
 10956	  if (!card) return;
 10957	  const mode = getSeasonRegistryMode();
 10958	  const modeText = {
 10959	    filtered: 'Season filtering is on — each camp season shows only its own camps.',
 10960	    legacy: 'The Summer Camp App has not switched seasons on yet, so Summer 2026 reads everything (there is only one season).',
 10961	    error: "Can't read the season registry — check Firestore rules. Camp data is not being shown.",
 10962	    unknown: "Can't reach the season registry — waiting for a connection.",
 10963	  }[mode] || mode;
 10964	  const campSemesters = Object.keys(currentConfig?.semesters || {}).filter(isCampSeason);
 10965	  card.innerHTML = `
 10966	    <h3 class="settings-subsection-title">Camp Seasons</h3>
 10967	    <p class="settings-panel-desc">${escHtml(modeText)}</p>
 10968	    <p class="settings-panel-desc">In the Classbook: ${campSemesters.length
 10969	      ? campSemesters.map(k => `${escHtml(currentConfig.semesters[k].name)} (${escHtml(seasonForSemesterSafe(k))})`).join(', ')
 10970	      : 'none yet'}. Seasons are created in the Summer Camp App, then added here with + New Semester.</p>`;
 10971	}
 10972	
 10973	// ─── "Stamp semester types" — the one-time migration (Phase 1, 1.2) ──────────
 10974	// Dry run first, always: it reads the SERVER's appData (not this tab's copy),
 10975	// lists every change, and refuses if a semester already carries a type that
 10976	// contradicts the migration. The write is one update() of field paths, and it
 10977	// is verified by a forced-server read-back that diffs field by field.
 10978	let pendingSemesterTypeStamps = null;
 10979	
 10980	function renderSemesterTypeMigrationCard() {
 10981	  const card = document.getElementById('settings-type-migration-card');
 10982	  if (!card) return;
 10983	  const user = getAuthUser();
 10984	  if (!user || user.role !== 'admin') { card.hidden = true; return; }   // admin-only
 10985	  card.hidden = false;
 10986	  card.innerHTML = `
 10987	    <h3 class="settings-subsection-title">Stamp semester types</h3>
 10988	    <p class="settings-panel-desc">A one-time step: records on every semester whether it is weekly classes or a camp season, and fills in Summer 2026's season details. Run the dry run first — it changes nothing.</p>
 10989	    <div class="settings-actions" style="justify-content:flex-start;gap:0.5rem;">
 10990	      <button class="btn-secondary write-control" onclick="dryRunSemesterTypeStamps()">Dry run</button>
 10991	      <button class="btn-primary write-control" id="stamp-types-btn" onclick="applySemesterTypeStamps()" disabled>Stamp semester types</button>
 10992	    </div>
 10993	    <pre id="stamp-types-output" class="settings-hint" style="white-space:pre-wrap;margin-top:0.5rem;"></pre>`;
 10994	}
 10995	
 10996	function stampOutput(text) {
 10997	  const out = document.getElementById('stamp-types-output');
 10998	  if (out) out.textContent = text;
 10999	}
 11000	
 11001	async function dryRunSemesterTypeStamps() {
 11002	  pendingSemesterTypeStamps = null;
 11003	  const btn = document.getElementById('stamp-types-btn');
 11004	  if (btn) btn.disabled = true;
 11005	  try {
 11006	    const serverConfig = await readAppDataFromServer();
 11007	    if (!serverConfig) { stampOutput('There is no app configuration document on the server yet — nothing to stamp.'); return; }
 11008	    const stamps = buildSemesterTypeStamps(serverConfig);
 11009	    // The snapshot goes to the console before anything is written, so a copy
 11010	    // of the pre-migration document exists outside Firestore.
 11011	    console.log('📋 appData snapshot before stamping semester types:', JSON.stringify(serverConfig, null, 2));
 11012	    const keys = Object.keys(stamps);
 11013	    if (keys.length === 0) { stampOutput('Nothing to stamp — every semester already carries its type.'); return; }
 11014	    pendingSemesterTypeStamps = { stamps, serverConfig };
 11015	    if (btn) btn.disabled = false;
 11016	    stampOutput(`${keys.length} change(s) ready. A full snapshot of the current configuration is in the browser console.\n\n`
 11017	      + keys.map(k => `  ${k} = ${JSON.stringify(stamps[k])}`).join('\n')
 11018	      + `\n\nRun a backup (backup.js --force) before pressing Stamp.`);
 11019	  } catch (err) {
 11020	    console.error('Dry run failed:', err);
 11021	    stampOutput(`Dry run failed: ${err.message}`);
 11022	  }
 11023	}
 11024	
 11025	async function applySemesterTypeStamps() {
 11026	  if (!pendingSemesterTypeStamps) { stampOutput('Run the dry run first.'); return; }
 11027	  const { stamps, serverConfig } = pendingSemesterTypeStamps;
 11028	  const btn = document.getElementById('stamp-types-btn');
 11029	  if (btn) btn.disabled = true;
 11030	  try {
 11031	    await updateAppData(stamps);
 11032	    // Read back from the SERVER and check field by field: every stamped path
 11033	    // has its new value, and nothing else moved. lastUpdated/lastUpdatedBy are
 11034	    // the two the helper always sets, so they are excluded from the diff.
 11035	    const after = await readAppDataFromServer();
 11036	    const problems = [];
 11037	    for (const [path, expected] of Object.entries(stamps)) {
 11038	      const actual = path.split('.').reduce((node, part) => (node == null ? node : node[part]), after);
 11039	      if (stableJson(actual) !== stableJson(expected)) problems.push(`${path}: expected ${JSON.stringify(expected)}, found ${JSON.stringify(actual)}`);
 11040	    }
 11041	    // Compare the WHOLE document, both directions, so an unexpected change or
 11042	    // loss anywhere is caught — not only in the semesters that happened to
 11043	    // exist when the dry run read the server.
 11044	    const IGNORE_TOP = new Set(['lastUpdated', 'lastUpdatedBy']);   // the helper always sets these
 11045	    for (const field of new Set([...Object.keys(serverConfig || {}), ...Object.keys(after || {})])) {
 11046	      if (IGNORE_TOP.has(field) || field === 'semesters') continue;
 11047	      if (stableJson(after?.[field]) !== stableJson(serverConfig?.[field])) problems.push(`${field} changed unexpectedly`);
 11048	    }
 11049	    const beforeSems = serverConfig.semesters || {};
 11050	    const afterSems = after?.semesters || {};
 11051	    for (const key of new Set([...Object.keys(beforeSems), ...Object.keys(afterSems)])) {
 11052	      const before = beforeSems[key];
 11053	      const now = afterSems[key];
 11054	      if (!now) { problems.push(`semesters.${key} disappeared`); continue; }
 11055	      if (!before) {
 11056	        // Added between the dry run and now (another tab). It was never
 11057	        // stamped, so say so rather than reporting a clean sweep.
 11058	        problems.push(`semesters.${key} appeared after the dry run and was NOT stamped — re-run the dry run and stamp again`);
 11059	        continue;
 11060	      }
 11320	    console.error('Error loading users for mapping:', err);
 11321	  }
 11322	}
 11323	
 11324	function getUserLabelByUid(uid) {
 11325	  // Best effort — will be populated by dropdown
 11326	  return uid.substring(0, 8) + '...';
 11327	}
 11328	
 11329	function clearTeacherMapping(teacherName) {
 11330	  const mappings = { ...(currentConfig?.teacherMappings || {}) };
 11331	  // Find and remove UID mapped to this teacher
 11332	  for (const [uid, name] of Object.entries(mappings)) {
 11333	    if (name === teacherName) delete mappings[uid];
 11334	  }
 11335	  currentConfig.teacherMappings = mappings;
 11336	  renderTeacherMappingTable();
 11337	}
 11338	
 11339	function getTeacherMappingsFromForm() {
 11340	  const mappings = {};
 11341	  const selects = document.querySelectorAll('.teacher-mapping-select');
 11342	  selects.forEach(select => {
 11343	    const uid = select.value;
 11344	    const teacherName = select.dataset.teacher;
 11345	    if (uid && teacherName) {
 11346	      mappings[uid] = teacherName;
 11347	    }
 11348	  });
 11349	  return mappings;
 11350	}
 11351	
 11352	async function saveSettings() {
 11353	  const el = (id) => document.getElementById(id)?.value?.trim() || '';
 11354	  // Last line of defence: never write a form drawn for one semester onto another.
 11355	  if (settingsFormSemKey !== getSettingsSemKey()) {
 11356	    loadSettingsForm();
 11357	    alert('This form was showing a different semester from the one selected at the top, so nothing was saved. It now shows the selected semester — check it and save again.');
 11358	    return;
 11359	  }
 11360	
 11361	  // Spring 2026 storage move: its settings save also writes lesson slots, so it's
 11362	  // refused whole, before appData is touched.
 11363	  if (refuseIfWeeklySemesterPaused(getSettingsSemKey())) return;
 11364	
 11365	  const breakWeeksStr = el('settings-break-weeks');
 11366	  const breakWeeks = breakWeeksStr.split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n));
 11367	  const closureDates = parseClosureDates(el('settings-closure-dates'));
 11368	
 11369	  const semKey = getSettingsSemKey();
 11370	  const classRoster = getClassRosterFromForm();
 11371	  const teacherNames = getTeacherNamesFromForm();
 11372	
 11373	  const teacherMappings = getTeacherMappingsFromForm();
 11374	
 11375	  // Merge into existing config to preserve other semesters
 11376	  const config = JSON.parse(JSON.stringify(currentConfig || {}));
 11377	  config.activeSemester = config.activeSemester || semKey;
 11378	
 11379	  // Safety guard: if the form returned no mappings but existing mappings exist,
 11380	  // the user dropdowns likely hadn't finished loading when Save was clicked.
 11381	  // Preserve existing mappings to prevent accidental wipeout.
 11382	  const existingMappings = currentConfig?.teacherMappings || {};
 11383	  config.teacherMappings = Object.keys(teacherMappings).length > 0
 11384	    ? teacherMappings
 11385	    : existingMappings;
 11386	  if (!config.semesters) config.semesters = {};
 11387	  // Only the fields this semester's TYPE owns (Phase 1, 1.2). Spreading the
 11388	  // whole form is what could put numWeeks: 16, an empty breakWeeks and the
 11389	  // hidden default class roster onto a camp season.
 11390	  // An SDOC year: its own date fields, and two guards before anything is
 11391	  // written — a name a camp still uses can't leave the pool, and the year
 11392	  // can't shrink past an existing event's date (forced-server reads).
 11393	  const isDayOff = isDayOffYear(semKey);
 11394	  if (isDayOff) {
 11395	    const start = el('settings-dayoff-start');
 11396	    const end = el('settings-end-date');
 11397	    if (!isIsoDate(start) || !isIsoDate(end) || end <= start) { alert('The school year needs a start date and an end date after it.'); return; }
 11398	    if (!el('settings-semester-name')) { alert('The school year needs a name.'); return; }
 11399	    try {
 11400	      // The SERVER's pool, not this tab's: the × button edits
 11401	      // currentConfig's list before Save runs, and another tab may have added
 11402	      // a name (and put it on a camp) since this form loaded (review HIGH).
 11403	      const serverPool = (await readAppDataFromServer())?.semesters?.[semKey]?.teacherNames || [];
 11404	      const loadedPool = settingsTeacherPoolAtLoad.semKey === semKey ? settingsTeacherPoolAtLoad.names : [];
 11405	      const removed = [...new Set([...serverPool, ...loadedPool])].filter(n => !teacherNames.includes(n));
 11406	      const inUse = await dayOffTeachersInUse(semKey, removed);
 11407	      if (inUse.length) {
 11408	        // Put just those names back in this tab's list (other unsaved edits in
 11409	        // the form stay as they are).
 11410	        currentConfig.semesters[semKey].teacherNames = [...teacherNames, ...inUse.map(u => u.name).filter(n => !teacherNames.includes(n))];
 11411	        renderTeacherNamesList();
 11412	        alert(`Can't remove ${inUse.map(u => `${u.name} (on ${u.camps.join(', ')})`).join('; ')} — take them off those camps first.\n\nNothing was saved.`);
 11413	        return;
 11414	      }
 11415	      const outside = await dayOffDatesOutside(semKey, start, end);
 11416	      if (outside.length) {
 11417	        alert(`These day-off dates would fall outside the school year: ${outside.map(o => `${o.label} ${o.date}`).join(', ')}. Edit those events first.\n\nNothing was saved.`);
 11418	        return;
 11419	      }
 11420	    } catch (err) {
 11421	      alert(`Could not check the school year's camps and events: ${err.message}\n\nNothing was saved.`);
 11422	      return;
 11423	    }
 11424	  }
 11425	  const settingsPaths = settingsFieldPathsFor(semKey, {
 11426	    endDate: isDayOff ? el('settings-end-date') : undefined,
 11427	    name: el('settings-semester-name'),
 11428	    startDate: isDayOff ? el('settings-dayoff-start') : el('settings-start-date'),
 11429	    numWeeks: parseInt(el('settings-num-weeks')) || 16,
 11430	    breakWeeks,
 11431	    closureDates,
 11432	    teacherNames,
 11433	    classRoster,
 11434	  });
 11435	  // Keep this tab's copy in step with exactly what is being written.
 11436	  config.semesters[semKey] = { ...(config.semesters[semKey] || {}) };
 11437	  for (const [path, value] of Object.entries(settingsPaths)) {
 11438	    config.semesters[semKey][path.split('.').pop()] = value;
 11439	  }
 11440	
 11441	  // The two NON-semester fields this form also owns (Phase 1, 1.2). Dropping
 11442	  // them was a real regression: teacher mappings are collected by this form
 11443	  // and would have been silently lost on every Save.
 11444	  const extraPaths = {};
 11445	  // teacherMappings keeps its preserve-on-empty guard — an empty form must not
 11446	  // wipe existing mappings.
 11447	  if (Object.keys(teacherMappings).length > 0) extraPaths.teacherMappings = teacherMappings;
 11448	  // activeSemester is only ever SET when missing, never re-pointed from here.
 11449	  if (!currentConfig?.activeSemester) extraPaths.activeSemester = semKey;
 11450	
 11451	  try {
 11452	    await updateAppData({ ...settingsPaths, ...extraPaths });
 11453	    // Keep this tab's config in step with exactly what was written. Before
 11454	    // Phase 1 saveConfig() ended with `currentConfig = config`; dropping that
 11455	    // left the clone's semester edits stranded, so loadSettingsForm() redrew
 11456	    // pre-save values and the NEXT Save wrote them back over the server —
 11457	    // silently, with "Settings saved!" both times. currentConfig has no live
 11458	    // listener (setupConfigListener() is never called), so nothing else would
 11459	    // have corrected it.
 11460	    currentConfig.semesters = currentConfig.semesters || {};
 11461	    currentConfig.semesters[semKey] = currentConfig.semesters[semKey] || {};
 11462	    for (const [path, value] of Object.entries(settingsPaths)) {
 11463	      currentConfig.semesters[semKey][path.split('.').pop()] = value;
 11464	    }
 11465	    if (extraPaths.teacherMappings) currentConfig.teacherMappings = extraPaths.teacherMappings;
 11466	    if (extraPaths.activeSemester) currentConfig.activeSemester = extraPaths.activeSemester;
 11467	
 11468	    // Create lesson slots for classes assigned to teachers
 11469	    await createLessonSlotsForRoster(semKey, classRoster, config.semesters[semKey].numWeeks);
 11470	
 11471	    alert('Settings saved!');
 11472	
 11473	    // Reload Settings form to show updated teacher names in dropdowns
 11474	    loadSettingsForm();
 11475	
 11476	    // Reload other tabs if active
 11477	    const activeTab = document.querySelector('.tab-btn.active')?.dataset.tab;
 11478	    if (activeTab === 'prep-dashboard') {
 11479	      const weekNum = document.getElementById('week-select')?.value || 1;
 11480	      loadWeekData(parseInt(weekNum));
 11481	    }
 11482	  } catch (err) {
 11483	    console.error('Error saving settings:', err);
 11484	    alert('Error saving settings: ' + err.message);
 11485	  }
 11486	}
 11487	
 11488	// Backtracking audit, Phase 11 (R4-9, R4-12). Called unconditionally by
 11489	// saveSettings() after every Settings save. No try/catch here on purpose —
 11490	// the caller's own catch already reports "Error saving settings" correctly;
 11491	// a catch here produced a false "Settings saved!" (round-3 finding).
 11492	async function createLessonSlotsForRoster(semKey, roster, numWeeks) {
 11493	  // Skip if no roster or no weeks configured
 11494	  if (!roster || !numWeeks || Object.keys(roster).length === 0) {
 11495	    return;
 11496	  }
 11497	
 11498	  // R4-9: the correct signal is semesterType, not a key-prefix guess — an
 11499	  // ordinary roster semester named "Summer Enrichment 2027" is not a camp,
 11500	  // and the real summer-2026 camp semester MUST be skipped: its lesson
 11501	  // content is keyed teacher|||campTopic|||blockName|||projectTitle and
 11502	  // regenerated by loadSummerCampData() from the camp source collections,
 11503	  // entirely unrelated to classRoster. Without this gate, a Settings save
 11504	  // while viewing summer-2026 built garbage teacher-className-weekNum slots
 11505	  // into the live summer cache and then re-saved EVERY real summer lesson
 11506	  // (~600) from this admin's in-memory copy — re-stamping them all and
 11507	  // risking Firestore's 500-op batch limit. Nothing safe to do here for a camp.
 11508	  if (!isWeeklySemester(semKey)) return;   // Phase 1, 1.1 — only weekly semesters have a class roster; a third type is skipped by construction
 11509	
 11510	  if (!currentLessonData) await loadLessonData();
 11511	
 11512	  // R4-12: work on a copy and commit it to the live cache only after
 11513	  // persistence succeeds — previously `currentLessonData[semKey] = {}` was
 11514	  // assigned up front, so a failed save left a phantom empty semester key
 11515	  // in the cache even though nothing had been written.
 11516	  const lessons = { ...(currentLessonData[semKey] || {}) };
 11517	  let createdCount = 0;
 11518	
 11519	  // For each class in roster that has a teacher assigned
 11520	  for (const [className, data] of Object.entries(roster)) {
 11521	    if (!data.teacher || !className) continue;  // Skip if no teacher or no class name
 11522	
 11523	    const teacher = data.teacher;
 11524	
 11525	    // Check if lesson slots exist for this teacher-class combination
 11526	    for (let weekNum = 1; weekNum <= numWeeks; weekNum++) {
 11527	      const lessonKey = makeLessonKey(teacher, className, weekNum);
 11528	
 11529	      // If lesson doesn't exist, create it
 11530	      if (!lessons[lessonKey]) {
 11531	        lessons[lessonKey] = {
 11532	          teacher: teacher,
 11533	          className: className,
 11534	          weekNum: weekNum,
 11535	          weekDate: '',
 11536	          projectTitle: '',
 11537	          introPitch: '',
 11538	          processStep1: '',
 11539	          processStep2: '',
 11540	          processStep3: '',
 11541	          processStep4: '',
 11542	          closure: '',
 11543	          materials: '',
 11544	          materialsList: [],
 11545	          dayOfMaterials: '',
 11546	          qaThread: [],
 11547	          planComplete: false,
 11548	          classSize: String(data.enrollment || 0),
 11549	          lastEditedBy: '',
 11550	          lastEditedAt: ''
 11551	        };
 11552	        createdCount++;
 11553	      }
 11554	    }
 11555	  }
 11556	
 11557	  if (createdCount > 0) {
 11558	    await saveLessonData(semKey, lessons);
 11559	    currentLessonData[semKey] = lessons; // only commit locally after Firestore confirms
 11560	    console.log(`✅ Created ${createdCount} lesson slots for roster classes`);
 11561	  }
 11562	}
 11563	
 11564	function makeLessonKey(teacher, className, weekNum) {
 11565	  const t = (teacher || '').toLowerCase().replace(/[^a-z0-9]/g, '');
 11566	  const c = (className || '').toLowerCase().replace(/[^a-z0-9]/g, '');
 11567	  const w = String(weekNum).trim();
 11568	  return `${t}-${c}-${w}`;
 11569	}
 11570	
 11571	// Rename a teacher across all lessons in a semester (re-keys affected lessons)
 11572	
 11573	// ─── Summer Camp Import ──────────────────────────────
 11574	
 11575	
 11576	
 11577	// ═══════════════════════════════════════════════════════
 11578	// SUMMER CAMP - MODAL AND PRINT FUNCTIONS
 11579	// ═══════════════════════════════════════════════════════
 11580	
 11581	// Backtracking audit Phase 6: summer Plan Complete saves in flight, keyed by
 11582	// lesson — the lock has to outlive the checkbox element, which any re-render
 11583	// replaces (a fresh element would otherwise arrive enabled mid-save).
 11584	const summerPlanCompleteSavesInFlight = new Set();
 11585	const inFlightKey = (semKey, lessonKey) => `${semKey}|${lessonKey}`;
 11586	
 11587	// Backtracking audit Phase 10: one save queue per summer lesson, shared by
 11588	// every editor opened on it. Lives outside openLessonModal() on purpose — if a
 11589	// modal is closed and the lesson reopened while a save is still queued, the
 11590	// new modal's saves must line up behind the old one's, not run alongside it.
 11591	const summerLessonSaveChains = new Map();
 11592	// How long Close waits for a pending save before offering to leave without it.
 11593	let SUMMER_CLOSE_WAIT_CAP_MS = 15000;
 11594	
 11595	function openLessonModal(campName, projectTitle, block) {
 11596	  const semKey = getTvSemKey();
 11597	  const lessons = currentLessonData?.[semKey];
 11598	  if (!lessons) return;
 11599	
 11600	  // Find lesson for the current teacher first — shared camps (teacher = "A + B") generate
 12020	
 12021	      // Handle photo upload — Backtracking audit, Phase 5 (R4-2). Capture the
 12022	      // OLD path before anything is reassigned (`lesson` is replaced below);
 12023	      // the new photo goes to its own unique path; the old object is deleted
 12024	      // only AFTER Firestore confirms the save, and only if it's actually a
 12025	      // different object. Previously the delete ran right after the upload —
 12026	      // and because both used the same fixed path, it deleted the photo it
 12027	      // had just uploaded, leaving every replacement as a broken image.
 12028	      const oldPhotoPath = lesson.photoPath || null;
 12029	      const photoInput = form.photoInput;
 12030	      const hasNewPhoto = photoInput?.files?.length > 0;
 12031	      const pendingRemove = photoInput?.dataset?.pendingRemove === 'true';
 12032	      // Remember exactly which file THIS save is uploading, so the input is
 12033	      // cleared afterwards only if the user hasn't picked a different one
 12034	      // in the meantime.
 12035	      const uploadedFile = hasNewPhoto ? photoInput.files[0] : null;
 12036	
 12037	      if (hasNewPhoto) {
 12038	        if (showStatus && !closing) autoSaveStatus.textContent = 'Uploading photo...';
 12039	        const result = sdoc
 12040	          ? await uploadDayOffPlanPhoto(semKey, lesson.campId, lesson.projectTitle, photoInput.files[0])
 12041	          : await uploadSummerCampPhoto(semKey, lessonKey, photoInput.files[0]);
 12042	        updatedLesson.photoUrl = result.url;
 12043	        updatedLesson.photoPath = result.path;
 12044	        if (showStatus && !closing) autoSaveStatus.textContent = 'Saving...';
 12045	      } else if (pendingRemove && lesson.photoUrl) {
 12046	        // Remove photo — the Storage object is deleted after the save below.
 12047	        updatedLesson.photoUrl = '';
 12048	        updatedLesson.photoPath = '';
 12049	      }
 12050	
 12051	      // Save only this lesson — never bulk-overwrite all lessons, which would wipe
 12052	      // other teachers' content if memory state was stale
 12053	      const savedLesson = { ...lesson, ...updatedLesson };
 12054	      // fieldsToClear wins over updatedLesson's stale (pre-clear) value, so the
 12055	      // local cache matches what Firestore now actually holds.
 12056	      fieldsToClear.forEach(f => { savedLesson[f] = ''; });
 12057	      // What actually goes to Firestore is only what THIS save changed: the
 12058	      // dirty text fields, the photo fields if this save touched them, and
 12059	      // the edit metadata (clears travel separately as fieldsToClear). The
 12060	      // summer branch of saveSingleLesson() is a set-merge, so everything
 12061	      // omitted is left exactly as the server has it — an admin's Help Queue
 12062	      // reply in qaThread, a photo another client replaced, a planComplete
 12063	      // ticked from the camp view — instead of being overwritten with this
 12064	      // modal's copy of it. (The full savedLesson object above is for the
 12065	      // cache and this modal's own state, not for the write.)
 12066	      const photoChanged = hasNewPhoto || (pendingRemove && lesson.photoUrl);
 12067	      const payload = {
 12068	        // Identity fields always travel: they are derived from the lesson key
 12069	        // (idempotent), and a doc this save CREATES must carry them — the
 12070	        // Summer Camp App's orphan check queries this collection by
 12071	        // campName/teacher, and the wipe monitor tallies docs by teacher.
 12072	        // SDOC sends none: the save stamps identity from the camp, and
 12073	        // anything outside its allow-list is refused.
 12074	        ...(sdoc ? {} : {
 12075	          teacher: lesson.teacher,
 12076	          campName: lesson.campName,
 12077	          block: lesson.block,
 12078	          projectTitle: lesson.projectTitle,
 12079	          className: lesson.className,
 12080	        }),
 12081	        ...contentUpdates,
 12082	        lastEditedBy: updatedLesson.lastEditedBy,
 12083	        lastEditedAt: updatedLesson.lastEditedAt,
 12084	      };
 12085	      if (photoChanged) { payload.photoUrl = updatedLesson.photoUrl; payload.photoPath = updatedLesson.photoPath; }
 12086	      // Optimistic: the cache and the modal's lesson take the new content now
 12087	      // and are put back (below) if the write fails.
 12088	      previousCachedLesson = currentLessonData[semKey]?.[lessonKey];
 12089	      previousLessonRef = lesson;
 12090	      optimisticLesson = savedLesson;
 12091	      if (currentLessonData[semKey]) currentLessonData[semKey][lessonKey] = savedLesson;
 12092	      lesson = savedLesson;
 12093	      const result = await saveSingleLesson(semKey, lessonKey, payload, fieldsToClear, sdoc ? { dayOffAuth: dayOffAuthFor(semKey) } : undefined);
 12094	      // saveSingleLesson() stamps lastEditedBy/At onto the object it is given;
 12095	      // keep the cache copy identical to what was written.
 12096	      savedLesson.lastEditedBy = payload.lastEditedBy;
 12097	      savedLesson.lastEditedAt = payload.lastEditedAt;
 12098	
 12099	      let sdocNote = '';
 12100	      if (sdoc) {
 12101	        // The SDOC save installed the server's own copy (read back and
 12102	        // verified) — no clock-based re-install here: it could put my copy
 12103	        // back over a co-teacher's newer text, or re-create a renamed-away
 12104	        // slot (plan, round 4).
 12105	        lesson = currentLessonData[semKey]?.[lessonKey] || lesson;
 12106	        if (result?.status === 'savedSince') {
 12107	          sdocNote = result.own
 12108	            ? '✓ Saved — this plan was saved again just after, from another window or the Plan complete box; reopen to see the latest.'
 12109	            : `✓ Saved — ${result.by} has edited this plan since; reopen to see their changes.`;
 12110	        } else if (result?.status === 'renamed') {
 12111	          sdocNote = '✓ Saved — but this project was just renamed by the planner; reopen the camp.';
 12112	        }
 12113	      } else {
 12114	        // Save confirmed. If the listener swapped the summer cache out from
 12115	        // under this save with a read taken BEFORE the write landed, the cache
 12116	        // now shows pre-save content — put the confirmed copy back, unless
 12117	        // what's there is at least as new.
 12118	        const semCache = currentLessonData[semKey];
 12119	        if (semCache && semCache[lessonKey] !== savedLesson && editedAtOf(semCache[lessonKey]) < editedAtOf(savedLesson)) {
 12120	          semCache[lessonKey] = savedLesson;

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '4900,5070p;5935,6135p;6210,6425p;6480,6580p;6960,7050p;7185,7380p' && nl -ba js/firebase-data.js | sed -n '330,380p;980,1045p;1180,1215p;1450,1500p;1610,1815p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
  4900	  if (problems.length) {
  4901	    alert(`Summer ${season} isn't ready yet: the Summer Camp App's season still needs ${problems.join(', ')}. Finish setting it up there, then add it here.`);
  4902	    return;
  4903	  }
  4904	
  4905	  creatingSemester = true;
  4906	  try {
  4907	    // The local check above only saw this tab's config.
  4908	    const serverConfig = await readAppDataFromServer();
  4909	    if (serverConfig?.semesters?.[key]) {
  4910	      alert(`Summer ${season} was already added (in another tab, or by another admin). Reload to see it.`);
  4911	      return;
  4912	    }
  4913	    const newSem = semesterFromRegistrySeason(registry);
  4914	    await updateAppData({ [`semesters.${key}`]: newSem });
  4915	    currentConfig.semesters[key] = newSem;
  4916	    closeNewSemesterModal();
  4917	    renderSemesterSelector();
  4918	    initGlobalSemesterSelector();
  4919	    alert(`${newSem.name} added. It stays hidden from teachers until you publish it, and its camps appear here as the Summer Camp App publishes them.`);
  4920	  } catch (err) {
  4921	    console.error('❌ Could not add the camp season:', err);
  4922	    delete currentConfig.semesters[key];
  4923	    alert(`Could not add that season: ${err.message}`);
  4924	  } finally {
  4925	    creatingSemester = false;
  4926	  }
  4927	}
  4928	
  4929	async function createNewSemester() {
  4930	  if (creatingSemester) return;
  4931	  if (selectedNewSemesterType() === SEMESTER_TYPES.camp) return await createCampSeasonSemester();
  4932	  if (selectedNewSemesterType() === SEMESTER_TYPES.dayOff) return await createDayOffYear();
  4933	  const name = document.getElementById('new-sem-name')?.value.trim();
  4934	  if (!name) { alert('Semester name is required.'); return; }
  4935	
  4936	  const key = name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');
  4937	  if (currentConfig.semesters[key]) {
  4938	    alert(`A semester with key "${key}" already exists.`);
  4939	    return;
  4940	  }
  4941	
  4942	  const startDate = document.getElementById('new-sem-start')?.value || '';
  4943	  const numWeeks = parseInt(document.getElementById('new-sem-weeks')?.value) || 16;
  4944	  const breaksRaw = document.getElementById('new-sem-breaks')?.value.trim() || '';
  4945	  const breakWeeks = breaksRaw ? breaksRaw.split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n)) : [];
  4946	  const closuresRaw = document.getElementById('new-sem-closures')?.value.trim() || '';
  4947	  const closureDates = parseClosureDates(closuresRaw);
  4948	  const copyFromKey = document.getElementById('new-sem-copy-from')?.value || '';
  4949	
  4950	  const newSem = {
  4951	    name,
  4952	    semesterType: SEMESTER_TYPES.weekly,   // stored explicitly from now on (Phase 1, 1.1)
  4953	    startDate,
  4954	    numWeeks,
  4955	    breakWeeks,
  4956	    closureDates,
  4957	    published: false,
  4958	    classRoster: {}
  4959	  };
  4960	
  4961	  // Invoked from a bare HTML onclick — nothing above this frame catches, so a
  4962	  // failure anywhere below must be handled here (backtracking audit, Phase 11).
  4963	  // Two Firestore writes happen in sequence (lesson slots, then config); if the
  4964	  // second fails after the first landed, the slots are an orphan on the server
  4965	  // for a semester the admin was told didn't get created, and a retry with the
  4966	  // same name would silently reuse them. Track whether the first write landed
  4967	  // so the catch can compensate.
  4968	  let lessonDataCommitted = false;
  4969	  creatingSemester = true;
  4970	  try {
  4971	    // Copy roster from existing semester if selected
  4972	    if (copyFromKey && currentConfig.semesters[copyFromKey]) {
  4973	      // Pre-check (implementation review, Sep 2026): this branch is the only
  4974	      // path that writes lesson data, and the compensating delete in the catch
  4975	      // below removes the WHOLE `key` map — only safe if nothing lived there
  4976	      // before this call. It can: deleteSemester() drops a key from local
  4977	      // state even when its server-side deleteLessonData() fails (warn-only),
  4978	      // and config has no live listener, so another admin's same-named
  4979	      // semester isn't visible here either. Forced server read — the local
  4980	      // cache is exactly what can't be trusted for this key. Refuse unless
  4981	      // every existing lesson is template-empty (a prior createNewSemester()'s
  4982	      // own leftovers are safe to build on and safe to delete; anything else
  4983	      // would be merged over silently by the slot write, then deleted on
  4984	      // failure). The no-copy path is deliberately NOT gated: it writes no
  4985	      // lesson data, and re-creating a deleted semester there adopts its
  4986	      // surviving lesson data — the remedy this alert points at.
  4987	      const existingLessonMap = await readServerSemesterLessonMap(key);
  4988	      if (existingLessonMap && Object.values(existingLessonMap).some(l => !isTemplateEmptyLesson(l))) {
  4989	        alert(`Lesson content already exists in Firestore under the key "${key}".\n\nIf it was left over from a deleted semester, create this semester again without "Copy from" to adopt that data.\n\nIf another admin may have just created it, reload this page first.\n\nOtherwise choose a different name.`);
  4990	        return;
  4991	      }
  4992	
  4993	      const source = currentConfig.semesters[copyFromKey];
  4994	      newSem.classRoster = JSON.parse(JSON.stringify(source.classRoster || {}));
  4995	      // Without this, classRoster's teacher fields are copied but the dropdown
  4996	      // that lets Settings display/edit them has no options — the roster looks
  4997	      // wiped even though the underlying data isn't, and saving Settings in
  4998	      // that state silently writes blank teachers over the real ones.
  4999	      newSem.teacherNames = JSON.parse(JSON.stringify(source.teacherNames || []));
  5000	
  5001	      // Create empty lesson slots from source semester's teacher/class combos
  5002	      const sourceLessons = currentLessonData?.[copyFromKey] || {};
  5003	      const combos = new Set();
  5004	      for (const lesson of Object.values(sourceLessons)) {
  5005	        combos.add(`${lesson.teacher}|||${lesson.className}`);
  5006	      }
  5007	
  5008	      const emptyLessons = {};
  5009	      for (const combo of combos) {
  5010	        const [teacher, className] = combo.split('|||');
  5011	        for (let w = 1; w <= numWeeks; w++) {
  5012	          const lessonKey = makeLessonKey(teacher, className, w);
  5013	          emptyLessons[lessonKey] = {
  5014	            teacher,
  5015	            className,
  5016	            weekNum: w,
  5017	            weekDate: '',
  5018	            classSize: 0,
  5019	            projectTitle: '',
  5020	            shortDetails: '',
  5021	            inspoLink: '',
  5022	            introPitch: '',
  5023	            processStep1: '',
  5024	            processStep2: '',
  5025	            processStep3: '',
  5026	            processStep4: '',
  5027	            closure: '',
  5028	            materials: '',
  5029	            dayOfMaterials: '',
  5030	            materialsList: [],
  5031	            status: '',
  5032	            publishToPrep: ''
  5033	          };
  5034	        }
  5035	      }
  5036	
  5037	      if (Object.keys(emptyLessons).length > 0) {
  5038	        await saveLessonData(key, emptyLessons);
  5039	        if (!currentLessonData) currentLessonData = {};
  5040	        currentLessonData[key] = emptyLessons;
  5041	        lessonDataCommitted = true;
  5042	      }
  5043	    }
  5044	
  5045	    // Confirm on the SERVER that the key is free — the check at the top of this
  5046	    // function only saw this tab's copy of the config (Phase 1, 1.2). The
  5047	    // remaining read-to-update window is accepted: one admin, same class as the
  5048	    // existing residual on the Q&A path.
  5049	    const serverConfig = await readAppDataFromServer();
  5050	    if (serverConfig?.semesters?.[key]) {
  5051	      throw new Error(`A semester with the key "${key}" already exists (created in another tab or by another admin). Choose a different name.`);
  5052	    }
  5053	    currentConfig.semesters[key] = newSem;
  5054	    await updateAppData({ [`semesters.${key}`]: newSem });
  5055	  } catch (err) {
  5056	    console.error('❌ Could not create new semester:', err);
  5057	    // Revert both local mutations so a retry isn't blocked by a phantom
  5058	    // "already exists" and the grid doesn't render a semester that never saved.
  5059	    delete currentConfig.semesters[key];
  5060	    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
  5061	    // R4-11: the empty lesson slots may already be persisted even though the
  5062	    // config never was — clean up the orphaned server-side write, not just the
  5063	    // local copy. Safe: this data is template-empty by construction (never had
  5064	    // real content), so deleting it loses nothing.
  5065	    if (lessonDataCommitted) {
  5066	      try {
  5067	        await deleteLessonData(key);
  5068	      } catch (cleanupErr) {
  5069	        console.error('⚠️ Could not clean up orphaned lesson data after failed semester creation:', cleanupErr);
  5070	      }
  5935	    console.warn('⚠️ Existence check read failed, retrying once:', err);
  5936	    return await readOnce(); // a second failure throws — caller's catch handles it
  5937	  }
  5938	}
  5939	
  5940	// Reverts the admin grid's optimistic in-memory update after a move/swap that
  5941	// failed to save or failed verification — puts both slots back to their
  5942	// pre-action state (deleting the dest slot if it didn't exist before) and re-renders.
  5943	function restoreGridActionState(semKey, sourceKey, sourceLesson, destKey, destLesson) {
  5944	  if (!currentLessonData[semKey]) currentLessonData[semKey] = {};
  5945	  currentLessonData[semKey][sourceKey] = sourceLesson;
  5946	  if (destLesson) {
  5947	    currentLessonData[semKey][destKey] = destLesson;
  5948	  } else {
  5949	    delete currentLessonData[semKey][destKey];
  5950	  }
  5951	  renderAdminGrid();
  5952	}
  5953	
  5954	async function handleGridAction(destTeacher, destClassName, destWeekNum, destKey) {
  5955	  const semKey = getAdminSemKey();
  5956	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  5957	  if (refuseIfWeeklySemesterPaused(semKey)) { cancelGridAction(); return; }
  5958	  const lessons = { ...currentLessonData[semKey] };
  5959	  const sourceLesson = lessons[caSourceKey];
  5960	
  5961	  if (!sourceLesson) {
  5962	    cancelGridAction();
  5963	    return;
  5964	  }
  5965	
  5966	  // Prevent moving to same cell
  5967	  if (caSourceKey === destKey) {
  5968	    cancelGridAction();
  5969	    return;
  5970	  }
  5971	
  5972	  const destLesson = lessons[destKey] || null;
  5973	  const newDestKey = makeLessonKey(destTeacher, destClassName, destWeekNum);
  5974	
  5975	  if (caActionMode === 'move') {
  5976	    if (destLesson) {
  5977	      if (!confirm(`Week ${destWeekNum} already has "${destLesson.projectTitle}". This will overwrite it. Continue?`)) {
  5978	        cancelGridAction();
  5979	        return;
  5980	      }
  5981	    }
  5982	    if (!confirm(`Move "${sourceLesson.projectTitle}" from Week ${sourceLesson.weekNum} to ${destTeacher} / ${destClassName} Week ${destWeekNum}?`)) {
  5983	      cancelGridAction();
  5984	      return;
  5985	    }
  5986	
  5987	    // Move: put source content at destination, clear source
  5988	    const movedLesson = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum };
  5989	    movedLesson.weekDate = destLesson?.weekDate || '';
  5990	    // Backtracking audit, Phase 4: a content field non-empty at the existing
  5991	    // destination but empty in the incoming moved lesson must be explicitly
  5992	    // cleared — saveSingleLesson omits empty fields from the write rather
  5993	    // than clearing them, so without this the destination's old content
  5994	    // would silently survive underneath the moved lesson.
  5995	    const destFieldsToClear = CONTENT_FIELDS.filter(f =>
  5996	      (destLesson?.[f] || '').trim() !== '' && !(movedLesson[f] || '').trim()
  5997	    );
  5998	    lessons[newDestKey] = movedLesson;
  5999	    delete lessons[caSourceKey];
  6000	    currentLessonData[semKey] = lessons;
  6001	
  6002	    const sourceKeyToDelete = caSourceKey;
  6003	    const preMoveSourceLesson = sourceLesson;
  6004	    const preMoveDestLesson = destLesson;
  6005	    caActionMode = null;
  6006	    caSourceKey = null;
  6007	    renderAdminGrid();
  6008	    renderChangeHistory();
  6009	
  6010	    // Backtracking audit, Phase 9: the destination write and the source
  6011	    // delete are ONE atomic Firestore call — closes the "first write landed,
  6012	    // second failed" partial-failure race the prior sequential-write design
  6013	    // was vulnerable to. Does NOT independently verify movedLesson reflects
  6014	    // the CURRENT server state (a separate, deliberately deferred stale-input
  6015	    // race — see classbook-shared-document-concurrency-plan.html's 7th
  6016	    // instance) — no read-back needed or performed, since the write is
  6017	    // all-or-nothing.
  6018	    let moveSucceeded = false;
  6019	    try {
  6020	      await saveMultipleLessonFields(
  6021	        semKey,
  6022	        [{ lessonKey: newDestKey, lessonData: movedLesson, fieldsToClear: destFieldsToClear }],
  6023	        [sourceKeyToDelete]
  6024	      );
  6025	      moveSucceeded = true;
  6026	    } catch (err) {
  6027	      console.error('❌ Move failed:', err);
  6028	      restoreGridActionState(semKey, sourceKeyToDelete, preMoveSourceLesson, newDestKey, preMoveDestLesson);
  6029	      alert(`Move could not be saved — "${preMoveSourceLesson.projectTitle}" has been restored to its original slot. Nothing was changed.`);
  6030	      return;
  6031	    }
  6032	
  6033	    if (moveSucceeded) {
  6034	      try {
  6035	        await appendChangeLogEntry(semKey, {
  6036	          action: 'move',
  6037	          details: {
  6038	            projectTitle: sourceLesson.projectTitle,
  6039	            teacher: sourceLesson.teacher,
  6040	            className: sourceLesson.className,
  6041	            fromWeek: sourceLesson.weekNum,
  6042	            toTeacher: destTeacher,
  6043	            toClassName: destClassName,
  6044	            toWeek: destWeekNum
  6045	          }
  6046	        });
  6047	        renderChangeHistory();
  6048	      } catch (logErr) {
  6049	        console.error('⚠️ Move saved, but Change History logging failed:', logErr);
  6050	      }
  6051	    }
  6052	    return;
  6053	
  6054	  } else if (caActionMode === 'swap') {
  6055	    const destLabel = destLesson ? `"${destLesson.projectTitle}"` : 'empty slot';
  6056	    if (!confirm(`Swap "${sourceLesson.projectTitle}" (Week ${sourceLesson.weekNum}) with ${destLabel} (Week ${destWeekNum})?`)) {
  6057	      cancelGridAction();
  6058	      return;
  6059	    }
  6060	
  6061	    // Swap: exchange content between source and dest
  6062	    const sourceWeekNum = sourceLesson.weekNum;
  6063	    const sourceTeacher = sourceLesson.teacher;
  6064	    const sourceClassName = sourceLesson.className;
  6065	    const sourceWeekDate = sourceLesson.weekDate;
  6066	    const sourceKeyForSwap = caSourceKey;
  6067	
  6068	    let savePromise;
  6069	    let swapSucceeded = false;
  6070	    if (destLesson) {
  6071	      const swappedSource = { ...destLesson, teacher: sourceTeacher, className: sourceClassName, weekNum: sourceWeekNum, weekDate: sourceWeekDate };
  6072	      const swappedDest = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum, weekDate: destLesson.weekDate };
  6073	      // Backtracking audit, Phase 4: each slot's clear list compares its OWN
  6074	      // pre-swap content against what's now being written there — NOT the
  6075	      // other slot's pre-swap content, which would be a no-op since that's
  6076	      // identical-by-construction to the incoming value.
  6077	      const sourceFieldsToClear = CONTENT_FIELDS.filter(f =>
  6078	        (sourceLesson[f] || '').trim() !== '' && !(swappedSource[f] || '').trim()
  6079	      );
  6080	      const destFieldsToClearSwap = CONTENT_FIELDS.filter(f =>
  6081	        (destLesson[f] || '').trim() !== '' && !(swappedDest[f] || '').trim()
  6082	      );
  6083	      lessons[sourceKeyForSwap] = swappedSource;
  6084	      lessons[newDestKey] = swappedDest;
  6085	      currentLessonData[semKey] = lessons;
  6086	
  6087	      // Backtracking audit, Phase 9: both slots' writes are now ONE atomic
  6088	      // Firestore call — closes the "first save landed, second failed"
  6089	      // partial-failure race the prior two-sequential-saves design was
  6090	      // vulnerable to.
  6091	      savePromise = (async () => {
  6092	        try {
  6093	          await saveMultipleLessonFields(semKey, [
  6094	            { lessonKey: sourceKeyForSwap, lessonData: swappedSource, fieldsToClear: sourceFieldsToClear },
  6095	            { lessonKey: newDestKey, lessonData: swappedDest, fieldsToClear: destFieldsToClearSwap }
  6096	          ]);
  6097	          swapSucceeded = true;
  6098	        } catch (err) {
  6099	          console.error('❌ Swap failed:', err);
  6100	          restoreGridActionState(semKey, sourceKeyForSwap, sourceLesson, newDestKey, destLesson);
  6101	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" and "${destLesson.projectTitle}" have been restored to their original slots.`);
  6102	        }
  6103	      })();
  6104	    } else {
  6105	      // Swap with empty: move source to dest, clear source. Backtracking
  6106	      // audit, Phase 9: the destination write and source delete are now ONE
  6107	      // atomic Firestore call, same reasoning as the move branch above.
  6108	      const movedLesson = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum, weekDate: '' };
  6109	      lessons[newDestKey] = movedLesson;
  6110	      delete lessons[sourceKeyForSwap];
  6111	      currentLessonData[semKey] = lessons;
  6112	      savePromise = (async () => {
  6113	        try {
  6114	          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
  6115	          swapSucceeded = true;
  6116	        } catch (err) {
  6117	          console.error('❌ Swap failed:', err);
  6118	          restoreGridActionState(semKey, sourceKeyForSwap, sourceLesson, newDestKey, null);
  6119	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" has been restored to its original slot.`);
  6120	        }
  6121	      })();
  6122	    }
  6123	
  6124	    caActionMode = null;
  6125	    caSourceKey = null;
  6126	    renderAdminGrid();
  6127	    renderChangeHistory();
  6128	
  6129	    await savePromise;
  6130	
  6131	    if (swapSucceeded) {
  6132	      try {
  6133	        await appendChangeLogEntry(semKey, {
  6134	          action: 'swap',
  6135	          details: {
  6210	      <button class="btn-secondary ca-action-btn" onclick="openDetailModal(currentLessonData[${escForOnclick(semKey)}][${escForOnclick(sourceKey)}], ${escForOnclick(sourceKey)}, ${escForOnclick(source.teacher)}, ${escForOnclick(source.className)}, ${source.weekNum})">Back</button>
  6211	    </div>
  6212	  </div>`;
  6213	
  6214	  body.innerHTML = html;
  6215	}
  6216	
  6217	function toggleCopyAll(masterCb) {
  6218	  document.querySelectorAll('.ca-copy-cb').forEach(cb => { cb.checked = masterCb.checked; });
  6219	}
  6220	
  6221	// Backtracking audit, Phase 11 (R3-12, R3-13). Previously resaved the ENTIRE
  6222	// cached semester via saveLessonData() — any lesson whose local copy was stale
  6223	// (a teacher's concurrent save in another tab) was silently reverted on the
  6224	// server — mutated the shared cache before any write landed, and logged only
  6225	// after one bulk save, so a part-way failure lost the log for targets that
  6226	// had actually been written. Now: one targeted saveSingleLesson() per target
  6227	// with an explicit fieldsToClear (a source field that is EMPTY must clear the
  6228	// target's stale value — the save strips empty content fields, so without the
  6229	// clear the old text would survive under the new plan), cache committed per
  6230	// target only after its save resolves, logged immediately, honest count on
  6231	// failure.
  6232	async function executeCopyPlan(sourceKey) {
  6233	  const semKey = getAdminSemKey();
  6234	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  6235	  if (refuseIfWeeklySemesterPaused(semKey)) return;
  6236	  const liveLessons = currentLessonData?.[semKey];
  6237	  const source = liveLessons?.[sourceKey];
  6238	  if (!source) return;
  6239	
  6240	  const checkboxes = document.querySelectorAll('.ca-copy-cb:checked');
  6241	  const targetKeys = Array.from(checkboxes).map(cb => cb.dataset.key);
  6242	
  6243	  if (targetKeys.length === 0) {
  6244	    alert('No targets selected.');
  6245	    return;
  6246	  }
  6247	
  6248	  // Check if any targets have existing plans
  6249	  const overwriteTargets = targetKeys.filter(k => liveLessons[k] && hasLessonContent(liveLessons[k]));
  6250	  if (overwriteTargets.length > 0) {
  6251	    const names = overwriteTargets.map(k => {
  6252	      const l = liveLessons[k];
  6253	      return `${l.teacher} — ${l.className} (Wk ${l.weekNum})`;
  6254	    }).join('\n');
  6255	    if (!confirm(`${overwriteTargets.length} target(s) already have lesson plans that will be overwritten:\n\n${names}\n\nContinue?`)) return;
  6256	  }
  6257	
  6258	  const fields = getCopyableFields(source); // the 7 CONTENT_FIELDS plus `materials`
  6259	  let savedCount = 0;
  6260	  let failure = null;
  6261	
  6262	  try {
  6263	    for (const targetKey of targetKeys) {
  6264	      if (!liveLessons[targetKey]) continue;
  6265	      // Work on copies — the shared cache object is only replaced below,
  6266	      // after this target's own save has resolved (R3-13).
  6267	      const previousTarget = { ...liveLessons[targetKey] };
  6268	      const targetFieldsToClear = CONTENT_FIELDS.filter(f =>
  6269	        (previousTarget[f] || '').trim() !== '' && !(fields[f] || '').trim()
  6270	      );
  6271	      // Send ONLY the copied fields (saveSingleLesson writes per-field paths
  6272	      // and stamps lastEditedBy/At onto this object). Sending the whole
  6273	      // cached target would re-write every non-content field — qaThread,
  6274	      // photoUrl, planComplete… — from this admin's possibly-stale copy over
  6275	      // a teacher's concurrent change (implementation review, Sep 2026).
  6276	      const payload = { ...fields };
  6277	      await saveSingleLesson(semKey, targetKey, payload, targetFieldsToClear);
  6278	      const updatedTarget = { ...previousTarget, ...payload };
  6279	      if (currentLessonData[semKey]) currentLessonData[semKey][targetKey] = updatedTarget;
  6280	      savedCount++;
  6281	      // Uncheck the saved target so, if a later one fails, "retry the rest"
  6282	      // re-runs only the rest (no duplicate copies or Change History entries).
  6283	      const cb = document.querySelector(`.ca-copy-cb[data-key="${CSS.escape(targetKey)}"]`);
  6284	      if (cb) cb.checked = false;
  6285	
  6286	      // Log this copy now — before the next target — so a later failure
  6287	      // can't lose the record of a write that already landed.
  6288	      const logEntry = {
  6289	        action: 'copy',
  6290	        details: {
  6291	          projectTitle: source.projectTitle,
  6292	          fromTeacher: source.teacher,
  6293	          fromClassName: source.className,
  6294	          fromWeek: source.weekNum,
  6295	          toTeacher: updatedTarget.teacher,
  6296	          toClassName: updatedTarget.className,
  6297	          toWeek: updatedTarget.weekNum
  6298	        }
  6299	      };
  6300	      // Capture the overwritten plan whenever ANY copyable field had text —
  6301	      // the clear above is explicit and intentional, so Change History must
  6302	      // hold the recovery record even when the prior content lived only in
  6303	      // processStep2-4/closure/dayOfMaterials (which the looser
  6304	      // hasLessonContent() used for the confirm prompt doesn't look at).
  6305	      const previousPlan = getCopyableFields(previousTarget);
  6306	      if (Object.values(previousPlan).some(v => String(v).trim())) {
  6307	        logEntry.details.previousPlan = previousPlan;
  6308	      }
  6309	      try {
  6310	        await appendChangeLogEntry(semKey, logEntry);
  6311	      } catch (logErr) {
  6312	        // The copy itself is saved; a Change History miss must not read as
  6313	        // a failed copy (same rule as saveTeacherEdit(), Phase 8).
  6314	        console.error('⚠️ Copy saved, but Change History logging failed for', targetKey, logErr);
  6315	      }
  6316	    }
  6317	  } catch (err) {
  6318	    console.error('❌ Copy Plan failed partway through:', err);
  6319	    failure = err;
  6320	  }
  6321	
  6322	  // UI after the try/catch so a render exception can't be misreported as a
  6323	  // failed save (and can't re-throw from inside the catch).
  6324	  renderAdminGrid();
  6325	  renderChangeHistory();
  6326	  if (failure) {
  6327	    alert(`Copied to ${savedCount} of ${targetKeys.length} class(es) before a save failed. Please check which targets actually received the plan before retrying the rest.\n\n${failure.message}`);
  6328	    return;
  6329	  }
  6330	  closeAdminModal();
  6331	  const skipped = targetKeys.length - savedCount;
  6332	  alert(`Plan copied to ${savedCount} class${savedCount !== 1 ? 'es' : ''}${skipped > 0 ? ` (${skipped} skipped)` : ''}.`);
  6333	}
  6334	
  6335	// Backtracking audit, Phase 8: rebuilt around the companion plan's Phase 17
  6336	// design. Forced-server read before archiving or deleting anything (closes
  6337	// two failure modes: the doc no longer existing at all, and the doc existing
  6338	// but having genuinely different content than this admin's stale local
  6339	// snapshot — a teacher's concurrent edit). Archives the COMPLETE fresh
  6340	// lesson object (not a hand-picked field list) via FieldValue.arrayUnion()
  6341	// against curriculum/cutProjects (not saveCutProjects()'s local-splice-then-
  6342	// full-array-overwrite — two admins cutting concurrently now both survive
  6343	// regardless of write order). Archive-before-delete ordering — a failed
  6344	// archive save leaves the live lesson completely untouched.
  6345	async function cutProject(key) {
  6346	  const semKey = getAdminSemKey();
  6347	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  6348	  if (refuseIfWeeklySemesterPaused(semKey)) return;
  6349	  const lessons = { ...currentLessonData[semKey] };
  6350	  const lesson = lessons[key];
  6351	  if (!lesson) return;
  6352	
  6353	  if (!confirm(`Cut "${lesson.projectTitle}" from ${lesson.teacher} / ${lesson.className} Week ${lesson.weekNum}? It will be moved to the Cut Projects bank.`)) return;
  6354	
  6355	  let check;
  6356	  try {
  6357	    check = await adminLessonStillExistsWithRetry(semKey, key);
  6358	  } catch (err) {
  6359	    console.error('Could not confirm current state before cutting', key, err);
  6360	    alert(`Could not confirm "${lesson.projectTitle}" still exists — nothing was cut. Check your connection and try again.`);
  6361	    return;
  6362	  }
  6363	  if (!check.exists) {
  6364	    alert(`"${lesson.projectTitle}" no longer exists — it may have been moved, deleted, or already cut by someone else. Nothing was cut.`);
  6365	    if (currentLessonData[semKey]) delete currentLessonData[semKey][key];
  6366	    renderAdminGrid();
  6367	    return;
  6368	  }
  6369	  const freshLesson = check.data;
  6370	
  6371	  // The first confirm() above authorized cutting THIS project, by name — if
  6372	  // the fresh read shows the slot's identity has materially changed since
  6373	  // then, that authorization doesn't cover it.
  6374	  if (freshLesson.projectTitle !== lesson.projectTitle || freshLesson.teacher !== lesson.teacher || freshLesson.className !== lesson.className) {
  6375	    if (!confirm(`This slot has changed since you opened it — it now contains "${freshLesson.projectTitle}" (${freshLesson.teacher} / ${freshLesson.className}). Cut this instead?`)) return;
  6376	  }
  6377	
  6378	  const user = getAuthUser();
  6379	  const archiveEntry = {
  6380	    ...freshLesson,
  6381	    originalTeacher: freshLesson.teacher,
  6382	    originalClassName: freshLesson.className,
  6383	    originalWeek: freshLesson.weekNum,
  6384	    cutDate: new Date().toISOString(),
  6385	    cutBy: user?.name || 'Unknown'
  6386	  };
  6387	
  6388	  if (!curriculumDb) initCurriculumFirestore();
  6389	  try {
  6390	    await curriculumDb.collection('curriculum').doc('cutProjects').set({
  6391	      [semKey]: firebase.firestore.FieldValue.arrayUnion(archiveEntry)
  6392	    }, { merge: true });
  6393	  } catch (e) {
  6394	    console.error('Could not save Cut Bank entry for', key, e);
  6395	    alert(`Could not cut "${freshLesson.projectTitle}" — the Cut Bank entry could not be saved. Nothing was changed.`);
  6396	    return;
  6397	  }
  6398	
  6399	  let deleteFailed = false;
  6400	  try {
  6401	    await deleteLessonKey(semKey, key);
  6402	  } catch (e) {
  6403	    console.error('Could not delete lesson after archiving', key, e);
  6404	    deleteFailed = true;
  6405	  }
  6406	
  6407	  // Local cache/grid only drops the lesson when the delete actually
  6408	  // succeeded — a failed delete leaves the grid showing the lesson as gone
  6409	  // while Firestore still has it live otherwise.
  6410	  if (!deleteFailed) {
  6411	    delete lessons[key];
  6412	    currentLessonData[semKey] = lessons;
  6413	  }
  6414	  if (!currentCutProjects) currentCutProjects = {};
  6415	  currentCutProjects[semKey] = [...(currentCutProjects[semKey] || []), archiveEntry];
  6416	
  6417	  try {
  6418	    await appendChangeLogEntry(semKey, {
  6419	      action: 'cut',
  6420	      details: { projectTitle: freshLesson.projectTitle, teacher: freshLesson.teacher, className: freshLesson.className, fromWeek: freshLesson.weekNum }
  6421	    });
  6422	    renderChangeHistory();
  6423	  } catch (logErr) {
  6424	    console.error('⚠️ Cut saved, but Change History logging failed:', logErr);
  6425	  }
  6480	      other.projects.forEach((proj, idx) => {
  6481	        html += `<div class="ca-cut-item" onclick="pasteFromCutBank(${idx}, ${escForOnclick(teacher)}, ${escForOnclick(className)}, ${weekNum}, ${escForOnclick(other.key)})">
  6482	          <div class="ca-cut-item-title">${escHtml(proj.projectTitle)}</div>
  6483	          <div class="ca-cut-item-meta">Originally: ${escHtml(proj.originalTeacher)} / ${escHtml(proj.originalClassName || '')} Week ${proj.originalWeek} &middot; Cut ${new Date(proj.cutDate).toLocaleDateString()}</div>
  6484	        </div>`;
  6485	      });
  6486	      html += '</div></div>';
  6487	    }
  6488	    html += '</details>';
  6489	  }
  6490	
  6491	  body.innerHTML = html;
  6492	}
  6493	
  6494	// Backtracking audit, Phase 8: targeted single-lesson save (not a bulk
  6495	// saveLessonData() semester overwrite), removal via FieldValue.arrayRemove()
  6496	// (not saveCutProjects()'s local-splice-then-full-array-overwrite — matches
  6497	// cutProject()'s arrayUnion() append-side fix, same document, same reasoning:
  6498	// two admins acting on the Cut Bank concurrently now both survive). The
  6499	// reconstruction below is an EXPLICIT FIELD WHITELIST, not spread-minus-
  6500	// exclude — a whitelist can't leak a future field cutProject()'s
  6501	// complete-spread archive starts including that an exclude-list doesn't yet
  6502	// know to exclude. classSize preserves the destination's own existing
  6503	// scaffold value (round-6 fix) rather than being hardcoded to 0 — nothing
  6504	// downstream recomputes it on paste. teacherNotes/adminResponse/status are
  6505	// excluded alongside qaThread (round-6 fix): getQaThread() reconstructs a
  6506	// Q&A thread from teacherNotes/adminResponse whenever qaThread is absent, so
  6507	// restoring those two fields alone would still leak the original
  6508	// conversation even with qaThread itself correctly omitted.
  6509	async function pasteFromCutBank(cutIndex, teacher, className, weekNum, sourceSemKey) {
  6510	  const destSemKey = getAdminSemKey();
  6511	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  6512	  if (refuseIfWeeklySemesterPaused(destSemKey)) return;
  6513	  const srcSemKey = sourceSemKey || destSemKey;
  6514	  const cutProjects = currentCutProjects?.[srcSemKey] || [];
  6515	  const proj = cutProjects[cutIndex];
  6516	  if (!proj) return;
  6517	
  6518	  const isCrossSemester = srcSemKey !== destSemKey;
  6519	  const srcSemName = currentConfig?.semesters?.[srcSemKey]?.name || srcSemKey;
  6520	  const confirmMsg = isCrossSemester
  6521	    ? `Paste "${proj.projectTitle}" from ${srcSemName} into ${teacher} / ${className} Week ${weekNum}?`
  6522	    : `Paste "${proj.projectTitle}" into ${teacher} / ${className} Week ${weekNum}?`;
  6523	  if (!confirm(confirmMsg)) return;
  6524	
  6525	  const key = makeLessonKey(teacher, className, weekNum);
  6526	  const lessons = { ...(currentLessonData?.[destSemKey] || {}) };
  6527	  const existingDest = lessons[key] || {};
  6528	  const existingDestClassSize = existingDest.classSize || 0;
  6529	  const existingDestPhotoPath = existingDest.photoPath || null;
  6530	
  6531	  lessons[key] = {
  6532	    teacher, className, weekNum, weekDate: '', classSize: existingDestClassSize,
  6533	    projectTitle: proj.projectTitle,
  6534	    shortDetails: proj.shortDetails || '',
  6535	    inspoLink: proj.inspoLink || '',
  6536	    introPitch: proj.introPitch || '',
  6537	    processStep1: proj.processStep1 || '', processStep2: proj.processStep2 || '',
  6538	    processStep3: proj.processStep3 || '', processStep4: proj.processStep4 || '',
  6539	    closure: proj.closure || '',
  6540	    materials: proj.materials || '',
  6541	    materialsList: proj.materialsList || [],
  6542	    dayOfMaterials: proj.dayOfMaterials || '',
  6543	    publishToPrep: proj.publishToPrep || '',
  6544	    lastImported: new Date().toISOString()
  6545	    // Deliberately NOT restored: qaThread, photoUrl/photoPath, planComplete
  6546	    // (tied to the ORIGINAL lesson instance, not reusable project content),
  6547	    // and teacherNotes/adminResponse/status (round-6: getQaThread() would
  6548	    // silently reconstruct the original Q&A conversation from these alone).
  6549	  };
  6550	  // Merely OMITTING those fields above only means "don't touch them" — if the
  6551	  // DESTINATION slot already had its own stale qaThread/photo/planComplete
  6552	  // from whatever occupied it before, that would otherwise survive untouched
  6553	  // and resurrect an unrelated Q&A thread under the newly-pasted content.
  6554	  // Explicitly clear them so a paste genuinely starts fresh.
  6555	  const NON_CONTENT_FIELDS_TO_CLEAR = ['qaThread', 'photoUrl', 'photoPath', 'planComplete', 'teacherNotes', 'adminResponse', 'status'];
  6556	
  6557	  let pasteConfirmed = false;
  6558	  try {
  6559	    await saveSingleLesson(destSemKey, key, lessons[key], NON_CONTENT_FIELDS_TO_CLEAR);
  6560	    pasteConfirmed = true;
  6561	  } catch (err) {
  6562	    console.error('❌ Paste from Cut Bank failed to save the lesson:', err);
  6563	    alert(`Could not paste "${proj.projectTitle}" — please try again.`);
  6564	    return;
  6565	  }
  6566	
  6567	  // Only delete the destination's old photo from Storage after Firestore has
  6568	  // confirmed the clear — same safe ordering as saveAdminEdit()/saveTeacherEdit().
  6569	  if (existingDestPhotoPath) {
  6570	    try {
  6571	      await deleteLessonPhoto(existingDestPhotoPath);
  6572	    } catch (cleanupErr) {
  6573	      console.error('⚠️ Could not clean up destination\'s old photo after paste (Firestore is correct, Storage has an orphan):', cleanupErr);
  6574	    }
  6575	  }
  6576	
  6577	  currentLessonData[destSemKey] = lessons;
  6578	  closeAdminModal();
  6579	  renderAdminGrid();
  6580	
  6960	    </div>`;
  6961	  });
  6962	
  6963	  html += '</div>';
  6964	  body.innerHTML = html;
  6965	}
  6966	
  6967	// Backtracking audit Phase 11 (R3-10, R3-11, round-4 fieldsToClear; hardened
  6968	// by this session's implementation review): the original bulk
  6969	// saveLessonData() write passed the WHOLE {projects:[...]} wrapper into
  6970	// saveFutureProjects() (which expects a bare array), double-nesting
  6971	// curriculum/futureProjects and corrupting renderIdeaBank()'s cache — a
  6972	// deterministic, live production bug. Also removed the idea from the bank
  6973	// BEFORE the destination lesson save was confirmed. Rewritten around a
  6974	// targeted saveSingleLesson() write (unrelated lessons in the same semester
  6975	// are no longer touched), explicit fieldsToClear against the destination's
  6976	// own pre-existing stale content — both CONTENT_FIELDS and the
  6977	// instance-specific fields an Idea Bank project never supplies (matching
  6978	// pasteFromCutBank()'s own NON_CONTENT_FIELDS_TO_CLEAR pattern, since simply
  6979	// omitting a field only means "don't touch it," not "clear it") — and
  6980	// lesson-save-then-idea-removal ordering with an honest duplicate-message on
  6981	// a removal failure.
  6982	async function pasteFromIdeaBank(idx, teacher, className, weekNum) {
  6983	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  6984	  if (refuseIfWeeklySemesterPaused(getAdminSemKey())) return;
  6985	  const projects = currentFutureProjects?.projects || [];
  6986	  const proj = projects[idx];
  6987	  if (!proj) return;
  6988	
  6989	  if (!confirm(`Paste "${proj.title}" into ${teacher} / ${className} Week ${weekNum}? The idea will be removed from the bank.`)) return;
  6990	
  6991	  const semKey = getAdminSemKey();
  6992	  const key = makeLessonKey(teacher, className, weekNum);
  6993	  const existingLesson = currentLessonData?.[semKey]?.[key] || {};
  6994	  const existingClassSize = existingLesson.classSize || 0;
  6995	  const existingPhotoPath = existingLesson.photoPath || null;
  6996	  const newLesson = {
  6997	    teacher,
  6998	    className,
  6999	    weekNum,
  7000	    weekDate: '',
  7001	    classSize: existingClassSize,
  7002	    projectTitle: proj.title,
  7003	    shortDetails: proj.description || '',
  7004	    inspoLink: proj.inspoLink || '',
  7005	    introPitch: '',
  7006	    processStep1: '',
  7007	    processStep2: '',
  7008	    processStep3: '',
  7009	    processStep4: '',
  7010	    closure: '',
  7011	    materials: '',
  7012	    dayOfMaterials: '',
  7013	    status: '',
  7014	    publishToPrep: '',
  7015	    teacherNotes: '',
  7016	    adminResponse: '',
  7017	    lastImported: new Date().toISOString()
  7018	  };
  7019	
  7020	  // An idea's blank fields must actually CLEAR stale destination content, not
  7021	  // silently leave it — same pattern used everywhere else in this plan.
  7022	  const fieldsToClear = CONTENT_FIELDS.filter(f =>
  7023	    (existingLesson[f] || '').trim() !== '' && !(newLesson[f] || '').trim()
  7024	  );
  7025	  // Instance-specific fields tied to whatever previously occupied this slot —
  7026	  // an Idea Bank project never supplies these, so newLesson never sets them,
  7027	  // and buildLessonFieldUpdates() only touches fields actually present in the
  7028	  // object it's given. Without an explicit clear, a destination's own stale
  7029	  // Q&A thread, photo, completion flag, or materials list would silently
  7030	  // resurrect under the newly-pasted idea.
  7031	  const NON_CONTENT_FIELDS_TO_CLEAR = ['qaThread', 'photoUrl', 'photoPath', 'planComplete', 'materialsList'];
  7032	
  7033	  try {
  7034	    await saveSingleLesson(semKey, key, newLesson, [...fieldsToClear, ...NON_CONTENT_FIELDS_TO_CLEAR]);
  7035	    if (currentLessonData[semKey]) currentLessonData[semKey][key] = newLesson;
  7036	  } catch (err) {
  7037	    console.error('❌ Paste from Idea Bank failed — lesson could not be saved:', err);
  7038	    alert(`Could not paste "${proj.title}" — please try again. The idea is still in the bank.`);
  7039	    return;
  7040	  }
  7041	
  7042	  // Only delete the destination's old photo from Storage after Firestore has
  7043	  // confirmed the clear — same safe ordering as pasteFromCutBank()/
  7044	  // saveAdminEdit()/saveTeacherEdit().
  7045	  if (existingPhotoPath) {
  7046	    try {
  7047	      await deleteLessonPhoto(existingPhotoPath);
  7048	    } catch (cleanupErr) {
  7049	      console.error('⚠️ Could not clean up destination\'s old photo after paste (Firestore is correct, Storage has an orphan):', cleanupErr);
  7050	    }
  7185	function getTimeAgo(timestamp) {
  7186	  const now = Date.now();
  7187	  const then = new Date(timestamp).getTime();
  7188	  const diff = now - then;
  7189	  const mins = Math.floor(diff / 60000);
  7190	  if (mins < 1) return 'just now';
  7191	  if (mins < 60) return `${mins}m ago`;
  7192	  const hours = Math.floor(mins / 60);
  7193	  if (hours < 24) return `${hours}h ago`;
  7194	  const days = Math.floor(hours / 24);
  7195	  if (days === 1) return 'yesterday';
  7196	  return `${days}d ago`;
  7197	}
  7198	
  7199	// Shared by sendHelpResponse() and sendQaReply() below — seeds arrayUnion's
  7200	// argument list with the legacy teacherNotes/adminResponse thread on a
  7201	// lesson's FIRST atomic-append reply, so that legacy content isn't silently
  7202	// lost the moment qaThread gets its first real entry. arrayUnion's deep-
  7203	// equality dedup makes repeating this migration from concurrent senders safe.
  7204	function buildQaThreadUnionArgs(existingLesson, newEntry) {
  7205	  const needsMigration = !existingLesson?.qaThread || existingLesson.qaThread.length === 0;
  7206	  return needsMigration ? [...getQaThread(existingLesson || {}), newEntry] : [newEntry];
  7207	}
  7208	
  7209	// Backtracking audit Phase 11 fix: both admin Q&A reply functions used to
  7210	// resave the ENTIRE cached semester via saveLessonData() — a Firestore
  7211	// set({merge:true}) of every lesson currently sitting in this admin's
  7212	// browser, not just the one being replied to. If a teacher's save landed on
  7213	// the server in the split-second before this admin's live listener caught
  7214	// up, that reply would silently revert the teacher's edit back to this
  7215	// admin's stale cached copy — for ANY lesson in the semester, not just the
  7216	// one in the reply. Now a single targeted Firestore .update() touching only
  7217	// this lesson's own field paths, with arrayUnion() for qaThread (survives a
  7218	// genuinely concurrent sender) and an existence check (a stale, long-open
  7219	// popup can't silently recreate a lesson deleted/moved elsewhere).
  7220	async function sendHelpResponse(key) {
  7221	  const input = document.getElementById(`ca-help-input-${key}`);
  7222	  if (!input) return;
  7223	  const response = input.value.trim();
  7224	  if (!response) return;
  7225	
  7226	  const semKey = getAdminSemKey();
  7227	  // Same load guard as every other lesson writer (Phase 1 review): after a
  7228	  // failed reload the listener deliberately KEEPS the previous summer maps, so
  7229	  // the cached lesson and the existence check both still pass — without this
  7230	  // an admin could write a reply while the banner says saving is disabled.
  7231	  if (lessonDataLoadedSuccessfully === false) {
  7232	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  7233	    return;
  7234	  }
  7235	  // A semester type this writer has no branch for is refused here, before the
  7236	  // existence check below — a throw inside that try would be reported to the
  7237	  // admin as "check your connection", which it isn't (Phase 1, 1.1).
  7238	  let lessonStore;
  7239	  try {
  7240	    lessonStore = lessonStoreFor(semKey);
  7241	  } catch (err) {
  7242	    alert(err.message);
  7243	    return;
  7244	  }
  7245	  const cachedExisting = currentLessonData?.[semKey]?.[key];
  7246	  if (!cachedExisting) return;
  7247	
  7248	  let check;
  7249	  try {
  7250	    check = await adminLessonStillExistsWithRetry(semKey, key);
  7251	  } catch (err) {
  7252	    console.warn('⚠️ Existence check retry also failed:', err);
  7253	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  7254	    return;
  7255	  }
  7256	  if (!check.exists) {
  7257	    alert('This lesson was moved or removed elsewhere. Your response was not sent — please close this and check the grid for its new location.');
  7258	    return;
  7259	  }
  7260	  const existing = check.data || cachedExisting;
  7261	
  7262	  const user = getAuthUser();
  7263	  const newEntry = {
  7264	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  7265	    from: 'admin', name: user?.name || 'Admin', message: response, timestamp: new Date().toISOString()
  7266	  };
  7267	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7268	
  7269	  if (!curriculumDb) initCurriculumFirestore();
  7270	  const isSummer = lessonStore === 'camp';
  7271	  const updates = {};
  7272	  let weekly = null;
  7273	  if (!isSummer) {
  7274	    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
  7275	  }
  7276	  if (isSummer) {
  7277	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7278	    updates.adminResponse = response;
  7279	    updates.status = 'In Progress';
  7280	    updates.lastUpdated = new Date().toISOString();
  7281	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7282	  } else {
  7283	    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7284	    updates[`${weekly.prefix}${key}.adminResponse`] = response;
  7285	    updates[`${weekly.prefix}${key}.status`] = 'In Progress';
  7286	    updates.lastUpdated = new Date().toISOString();
  7287	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7288	  }
  7289	  const docRef = isSummer
  7290	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7291	    : weekly.ref;
  7292	
  7293	  try {
  7294	    await docRef.update(updates);
  7295	  } catch (err) {
  7296	    console.error('Error sending help response:', err);
  7297	    alert('Error sending response: ' + err.message);
  7298	    return;
  7299	  }
  7300	
  7301	  currentLessonData[semKey][key] = {
  7302	    ...existing, adminResponse: response,
  7303	    qaThread: [...(existing.qaThread && existing.qaThread.length > 0 ? existing.qaThread : getQaThread(existing)), newEntry],
  7304	    status: 'In Progress'
  7305	  };
  7306	  renderHelpQueue();
  7307	}
  7308	
  7309	async function sendQaReply(key) {
  7310	  const input = document.getElementById(`qa-reply-${key}`);
  7311	  if (!input) return;
  7312	  const message = input.value.trim();
  7313	  if (!message) return;
  7314	
  7315	  const semKey = getAdminSemKey();
  7316	  // Same load guard as every other lesson writer (Phase 1 review): after a
  7317	  // failed reload the listener deliberately KEEPS the previous summer maps, so
  7318	  // the cached lesson and the existence check both still pass — without this
  7319	  // an admin could write a reply while the banner says saving is disabled.
  7320	  if (lessonDataLoadedSuccessfully === false) {
  7321	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  7322	    return;
  7323	  }
  7324	  // A semester type this writer has no branch for is refused here, before the
  7325	  // existence check below — a throw inside that try would be reported to the
  7326	  // admin as "check your connection", which it isn't (Phase 1, 1.1).
  7327	  let lessonStore;
  7328	  try {
  7329	    lessonStore = lessonStoreFor(semKey);
  7330	  } catch (err) {
  7331	    alert(err.message);
  7332	    return;
  7333	  }
  7334	  const cachedExisting = currentLessonData?.[semKey]?.[key];
  7335	  if (!cachedExisting) return;
  7336	
  7337	  let check;
  7338	  try {
  7339	    check = await adminLessonStillExistsWithRetry(semKey, key);
  7340	  } catch (err) {
  7341	    console.warn('⚠️ Existence check retry also failed:', err);
  7342	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  7343	    return;
  7344	  }
  7345	  if (!check.exists) {
  7346	    alert('This lesson was moved or removed elsewhere. Your reply was not sent — please close this window and check the grid for its new location.');
  7347	    return;
  7348	  }
  7349	  const existing = check.data || cachedExisting;
  7350	
  7351	  const user = getAuthUser();
  7352	  const newEntry = {
  7353	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  7354	    from: 'admin', name: user?.name || 'Admin', message, timestamp: new Date().toISOString()
  7355	  };
  7356	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7357	
  7358	  if (!curriculumDb) initCurriculumFirestore();
  7359	  const isSummer = lessonStore === 'camp';
  7360	  const updates = {};
  7361	  let weekly = null;
  7362	  if (!isSummer) {
  7363	    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
  7364	  }
  7365	  if (isSummer) {
  7366	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7367	    updates.adminResponse = message;
  7368	    updates.lastUpdated = new Date().toISOString();
  7369	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7370	  } else {
  7371	    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7372	    updates[`${weekly.prefix}${key}.adminResponse`] = message;
  7373	    updates.lastUpdated = new Date().toISOString();
  7374	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7375	  }
  7376	  const docRef = isSummer
  7377	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7378	    : weekly.ref;
  7379	
  7380	  try {
   330	  banner.classList.remove('hidden');
   331	}
   332	
   333	// ─── appData writes — one update(), only the paths named (Phase 1, 1.2) ──────
   334	// `updates` is a flat map of dotted field paths → values (FieldValue.delete()
   335	// allowed). Semester keys are slugified [a-z0-9-], so a dotted path never
   336	// needs quoting. Dotted STRINGS, not FieldPath objects: the compat SDK's
   337	// FieldPath form needs the varargs overload, an easy mistake.
   338	function nestFieldPaths(flat) {
   339	  const nested = {};
   340	  for (const [path, value] of Object.entries(flat)) {
   341	    const parts = path.split('.');
   342	    let node = nested;
   343	    while (parts.length > 1) { const k = parts.shift(); node = node[k] = node[k] || {}; }
   344	    node[parts[0]] = value;
   345	  }
   346	  return nested;
   347	}
   348	
   349	async function updateAppData(updates) {
   350	  if (!curriculumDb) initCurriculumFirestore();
   351	  if (configLoadFailed) {
   352	    throw new Error('The app configuration could not be read — refusing to write to it. Reload once the problem is fixed.');
   353	  }
   354	  // "Every writer refuses" includes these ones (Phase 1, 1.3). Publish,
   355	  // delete, create, Settings and the migration all write through here; without
   356	  // this an admin could still change the configuration while the app is behind
   357	  // the banner telling them saving is disabled.
   358	  if (seasonRegistryMode === 'error' || seasonRegistryMode === 'unknown') {
   359	    throw new Error(`Refusing to change the app configuration: the season registry is ${seasonRegistryMode === 'unknown' ? 'unreachable' : 'unreadable or malformed'}. Nothing was changed.`);
   360	  }
   361	  const user = getAuthUser();
   362	  const payload = {
   363	    ...updates,
   364	    lastUpdated: new Date().toISOString(),
   365	    lastUpdatedBy: user?.name || 'Unknown',
   366	  };
   367	  const ref = curriculumDb.collection('curriculum').doc('appData');
   368	  try {
   369	    await ref.update(payload);
   370	  } catch (err) {
   371	    if (err?.code !== 'not-found') throw err;
   372	    // Initialisation only: no appData document exists yet. update() cannot
   373	    // create one, so merge-set the same paths as real nesting.
   374	    await ref.set(nestFieldPaths(payload), { merge: true });
   375	  }
   376	}
   377	
   378	// Forced-server read of curriculum/appData — bypasses the SDK cache. Used
   379	// before creating a semester, and by the type migration's dry run/read-back.
   380	async function readAppDataFromServer() {
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
  1180	}
  1181	
  1182	async function backupLessonData(semesterKey) {
  1183	  if (!curriculumDb) initCurriculumFirestore();
  1184	  const existing = currentLessonData?.[semesterKey];
  1185	  if (!existing || Object.keys(existing).length === 0) return 0;
  1186	  const count = Object.keys(existing).length;
  1187	  const user = getAuthUser();
  1188	  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
  1189	    [semesterKey]: existing,
  1190	    backupDate: new Date().toISOString(),
  1191	    backupBy: user?.name || 'Unknown'
  1192	  }, { merge: true });
  1193	  return count;
  1194	}
  1195	
  1196	async function restoreFromBackup(semesterKey) {
  1197	  if (!curriculumDb) initCurriculumFirestore();
  1198	  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
  1199	  if (!backupDoc.exists) return null;
  1200	  const backupData = backupDoc.data();
  1201	  const lessons = backupData?.[semesterKey];
  1202	  if (!lessons || Object.keys(lessons).length === 0) return null;
  1203	  await saveLessonData(semesterKey, lessons);
  1204	  return Object.keys(lessons).length;
  1205	}
  1206	
  1207	// "Which copy of a lesson is newer", by lastEditedAt — the only revision
  1208	// marker the data has (a client wall-clock heuristic: ties and missing values
  1209	// resolve to "not newer"). Shared by the listener merge below and the summer
  1210	// editor's own adoption/re-install logic (Backtracking audit Phase 10).
  1211	function lessonEditedAtMs(lesson) {
  1212	  return Date.parse(lesson?.lastEditedAt || '') || 0;
  1213	}
  1214	
  1215	// The fields a saved summerCamps_lessonData doc contributes to a lesson slot
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
  1610	
  1611	// fieldsToClear: field names the caller has determined should be explicitly
  1612	// removed rather than silently omitted — most commonly content fields
  1613	// INTENTIONALLY emptied (had text when the modal opened, empty now; see the
  1614	// two edit modals' open-state snapshots, teOriginalData/summerLessonOriginalData),
  1615	// but not restricted to CONTENT_FIELDS — any field name works (e.g.
  1616	// pasteFromCutBank()'s non-content qaThread/photoUrl/photoPath/planComplete/
  1617	// teacherNotes/adminResponse/status, which must be explicitly cleared on the
  1618	// DESTINATION rather than just omitted from the new lesson object, or a
  1619	// pre-existing stale value there would survive the paste untouched — omission
  1620	// only means "don't touch this field," never "clear it"). These get
  1621	// Firestore's FieldValue.delete() instead of silent omission, so a genuine
  1622	// clear actually persists (Data Safety Plan Stage 3). This list is
  1623	// authoritative: it overrides whatever (possibly stale) value lessonData
  1624	// happens to carry for that key, since callers may still send the pre-edit
  1625	// value alongside a separate clear signal (see saveLesson()'s contentUpdates).
  1626	async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
  1627	  if (lessonDataLoadedSuccessfully === false) {
  1628	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  1629	  }
  1630	  if (!curriculumDb) initCurriculumFirestore();
  1631	  const user = getAuthUser();
  1632	  lessonData.lastEditedBy = user?.name || 'Unknown';
  1633	  lessonData.lastEditedAt = new Date().toISOString();
  1634	
  1635	  // SDOC plans (Phase 2B) branch here — after the stamp, so every SDOC write
  1636	  // (the narrow Plan complete one included) carries lastEditedBy/At — and
  1637	  // BEFORE lessonStoreFor(), which keeps throwing for the type: its other six
  1638	  // callers fall through to curriculum/lessonData on anything that isn't
  1639	  // 'camp', and that throw is what keeps an SDOC key out of it.
  1640	  if (isDayOffYear(semesterKey)) return saveDayOffPlan(semesterKey, lessonKey, lessonData, fieldsToClear, opts.dayOffAuth);
  1641	
  1642	  console.log('💾 Attempting to save lesson:', { semesterKey, lessonKey, user: user?.email });
  1643	
  1644	  const hasContent = lessonHasContent(lessonData);
  1645	  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above.
  1646	  const fieldsToActuallyClear = [...fieldsToClear];
  1647	
  1648	  // Route by type, never by key (Phase 1, 1.1).
  1649	  if (lessonStoreFor(semesterKey) === 'camp') {
  1650	    // A planComplete-only payload, a photo-only payload, or a save that's only
  1651	    // clearing a field, is a legitimate narrow save, not a stale-state wipe
  1652	    // attempt — only block when there's neither real content nor an explicit
  1653	    // planComplete flag nor a photo field nor a field being intentionally
  1654	    // cleared (Data Safety Plan Stage 2C/3; photo fields added by the
  1655	    // backtracking audit's Phase 10, whose summer editor now sends only the
  1656	    // fields it changed — a photo replacement arrives with no text at all).
  1657	    const hasPhotoField = 'photoUrl' in lessonData || 'photoPath' in lessonData;
  1658	    if (!hasContent && !hasPhotoField && !('planComplete' in lessonData) && fieldsToActuallyClear.length === 0) {
  1659	      console.warn('⛔ saveSingleLesson blocked — all content fields empty, refusing to overwrite:', lessonKey);
  1660	      return;
  1661	    }
  1662	    // Strip empty content fields so stale in-memory empty strings never overwrite
  1663	    // real content that a teacher saved previously (mirrors saveSummerCampLessonData).
  1664	    const stripped = { ...lessonData };
  1665	    CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
  1666	    const cleanData = JSON.parse(JSON.stringify(stripped));
  1667	    // Apply clears AFTER the JSON sanitization pass — FieldValue.delete() is a
  1668	    // special sentinel object that a JSON round-trip would corrupt.
  1669	    fieldsToActuallyClear.forEach(f => { cleanData[f] = firebase.firestore.FieldValue.delete(); });
  1670	    // Every summer doc this app writes carries its season (camp seasons Phase
  1671	    // 0). A plain string, so it goes after the round-trip — and after the
  1672	    // clears, so no clear list can ever strip the stamp.
  1673	    cleanData.season = seasonForSemester(semesterKey);
  1674	    console.log('💾 Saving Summer Camp lesson to summerCamps_lessonData:', lessonKey);
  1675	    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semesterKey, lessonKey));
  1676	    await docRef.set(cleanData, { merge: true });
  1677	    console.log('✅ Saved Summer Camp lesson:', lessonKey);
  1678	
  1679	    // Read back the content fields we just wrote, forced to the server — this
  1680	    // is the check that would have caught both original May 2026 wipe
  1681	    // incidents within seconds instead of days (Data Safety Plan Stage 2E).
  1682	    // Intentionally cleared fields are expected to read back missing, so
  1683	    // they're excluded here rather than flagged as a failed write.
  1684	    const writtenContentFields = CONTENT_FIELDS.filter(f => f in cleanData && !fieldsToActuallyClear.includes(f));
  1685	    if (writtenContentFields.length > 0) {
  1686	      await verifySummerLessonWrite(docRef, writtenContentFields);
  1687	    }
  1688	    return;
  1689	  }
  1690	
  1691	  // Regular semester: curriculum/lessonData is one shared doc across every
  1692	  // semester. update() with a whole object assigned to the bare
  1693	  // semesterKey.lessonKey path replaces the ENTIRE lesson there — so write
  1694	  // explicit per-field dotted paths instead, touching only the fields
  1695	  // actually present in lessonData (Data Safety Plan Stage 2D).
  1696	  const { ref: weeklyRef, prefix } = weeklyLessonTarget(semesterKey);   // own-doc semester: its own doc (or "editing is paused")
  1697	  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear, prefix);
  1698	
  1699	  console.log(`💾 Saving to curriculum/${weeklyRef.id} with per-field paths:`, Object.keys(updates));
  1700	  try {
  1701	    await weeklyRef.update(updates);
  1702	    console.log('✅ Successfully saved lesson to Firestore!');
  1703	  } catch (error) {
  1704	    console.error('❌ Error saving lesson:', error);
  1705	    throw error;
  1706	  }
  1707	}
  1708	
  1709	// Backtracking audit, Phase 9: pure helper — computes the dotted-path update
  1710	// object for ONE lesson within the shared curriculum/lessonData document,
  1711	// given an already-finalized lessonData object. Extracted from
  1712	// saveSingleLesson()'s non-summer branch above so it can be reused by
  1713	// saveMultipleLessonFields() below without duplicating the stripping/clearing
  1714	// logic. Strips empty content fields the same way the summer branch does, by
  1715	// omitting their dotted path entirely — never sending an explicit empty
  1716	// string — and applies clears AFTER the JSON sanitization pass, since
  1717	// FieldValue.delete() is a special sentinel a JSON round-trip would corrupt.
  1718	function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = [], prefix = `${semesterKey}.`) {
  1719	  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above saveSingleLesson().
  1720	  const stripped = { ...lessonData };
  1721	  CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
  1722	  const cleanData = JSON.parse(JSON.stringify(stripped));
  1723	  fieldsToClear.forEach(f => { cleanData[f] = firebase.firestore.FieldValue.delete(); });
  1724	  const updates = {};
  1725	  for (const [field, value] of Object.entries(cleanData)) {
  1726	    updates[`${prefix}${lessonKey}.${field}`] = value;
  1727	  }
  1728	  return updates;
  1729	}
  1730	
  1731	// Backtracking audit, Phase 9: combine multiple lesson writes and/or
  1732	// whole-lesson deletes into ONE atomic Firestore .update() call — either
  1733	// every write/delete in the call lands, or none do. Closes the
  1734	// PARTIAL-FAILURE race that move/swap's prior sequential-writes design was
  1735	// vulnerable to (does NOT independently verify the given lessonData reflects
  1736	// current server state — see Phase 9's note in the plan for the deliberately
  1737	// deferred, separately-tracked stale-input race).
  1738	async function saveMultipleLessonFields(semesterKey, writes = [], deletes = []) {
  1739	  if (lessonDataLoadedSuccessfully === false) {
  1740	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  1741	  }
  1742	  if (lessonStoreFor(semesterKey) === 'camp') {
  1743	    // Camp-season lessons live in a separate per-lesson-document collection — no
  1744	    // single-document atomicity is available across lessons there. Not
  1745	    // reachable today (the admin grid's move/swap UI is gated away from
  1746	    // summer semesters), but this guard exists so a future caller can't
  1747	    // silently get a false sense of atomicity if that ever changes.
  1748	    throw new Error('saveMultipleLessonFields() does not support camp seasons — use saveSingleLesson() per lesson instead.');
  1749	  }
  1750	  if (!curriculumDb) initCurriculumFirestore();
  1751	  const { ref: weeklyRef, prefix } = weeklyLessonTarget(semesterKey);
  1752	  const user = getAuthUser();
  1753	  const combined = {};
  1754	  for (const { lessonKey, lessonData, fieldsToClear } of writes) {
  1755	    lessonData.lastEditedBy = user?.name || 'Unknown';
  1756	    lessonData.lastEditedAt = new Date().toISOString();
  1757	    Object.assign(combined, buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear || [], prefix));
  1758	  }
  1759	  for (const lessonKey of deletes) {
  1760	    combined[`${prefix}${lessonKey}`] = firebase.firestore.FieldValue.delete();
  1761	  }
  1762	  combined.lastUpdated = new Date().toISOString();
  1763	  combined.lastUpdatedBy = user?.name || 'Unknown';
  1764	  await weeklyRef.update(combined);
  1765	}
  1766	
  1767	// ─── Photo Upload (Firebase Storage) ─────────────────
  1768	
  1769	function getFirebaseStorage() {
  1770	  // Single init path: initFirebaseApp() (js/firebase-config.js) is the one
  1771	  // place that knows whether this page is in emulator mode, so a bare
  1772	  // initializeApp(FIREBASE_CONFIG) here could point Storage at production
  1773	  // while Firestore sits on the emulator.
  1774	  initFirebaseApp();
  1775	  return firebase.storage();
  1776	}
  1777	
  1778	// Backtracking audit, Phase 5 (R3-5, R3-6, R4-7): every upload gets a path
  1779	// that is unique PER UPLOAD, not per lesson. With a deterministic path the
  1780	// replacement upload overwrote the live object before Firestore confirmed
  1781	// the save (a failed save then pointed at a photo that no longer existed),
  1782	// a swap could put one lesson's replacement on top of the other lesson's
  1783	// still-referenced object, and the summer modal's "delete the old path"
  1784	// step deleted the object it had just uploaded. Callers keep the OLD path,
  1785	// save, then delete it only after a confirmed save (see saveTeacherEdit(),
  1786	// saveAdminEdit(), and the summer modal's saveLesson()). Date.now() alone is
  1787	// millisecond resolution — the random suffix keeps two near-simultaneous
  1788	// uploads for the same lesson apart.
  1789	function uniquePhotoSuffix() {
  1790	  return `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
  1791	}
  1792	
  1793	function getPhotoPath(semesterKey, lessonKey /* filename: ignored — resizeImage() always re-encodes to JPEG */) {
  1794	  // Store at curriculum/{semester}/{lessonKey}/demo-{unique}.jpg
  1795	  return `curriculum/${semesterKey}/${lessonKey}/demo-${uniquePhotoSuffix()}.jpg`;
  1796	}
  1797	
  1798	async function uploadLessonPhoto(semesterKey, lessonKey, file) {
  1799	  if (typeof firebase.storage !== 'function') {
  1800	    throw new Error('Firebase Storage SDK not loaded. Hard refresh and try again.');
  1801	  }
  1802	  const storage = getFirebaseStorage();
  1803	  const path = getPhotoPath(semesterKey, lessonKey, 'demo.jpg');
  1804	  const ref = storage.ref(path);
  1805	
  1806	  // Resize before upload (max 1200px wide, JPEG 80% quality)
  1807	  const resized = await resizeImage(file, 1200, 0.8);
  1808	
  1809	  const snapshot = await ref.put(resized, { contentType: 'image/jpeg' });
  1810	  const url = await snapshot.ref.getDownloadURL();
  1811	  return { url, path };
  1812	}
  1813	
  1814	async function uploadSummerCampPhoto(semKey, lessonKey, file) {
  1815	  // Same load guard as the summer lesson save this upload precedes — refuse

exec
/bin/zsh -lc "rg -n \"function get(Settings|Admin|Tv)SemKey|settingsSem|caSemester|globalSemesterKey\" js/app.js | head -100 && rg -n \"saveCutProjects\\(|uploadLessonPhoto\\(|updateAppData\\(\" js/app.js js/firebase-data.js --glob '*.js'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
13:let globalSemesterKey = localStorage.getItem('globalSemesterKey') || null;  // Universal semester selection
65:  if (!globalSemesterKey || !semesters[globalSemesterKey] || !visibleKeys.includes(globalSemesterKey)) {
68:    globalSemesterKey = visibleKeys.includes(currentConfig.activeSemester) ? currentConfig.activeSemester : visibleKeys[0];
69:    localStorage.setItem('globalSemesterKey', globalSemesterKey);
81:    html += `<option value="${escAttr(key)}" ${key === globalSemesterKey ? 'selected' : ''}>${escHtml(String(label ?? ''))}</option>`;
99:  globalSemesterKey = key;
100:  localStorage.setItem('globalSemesterKey', key);
178:  const currentSemester = currentConfig?.semesters?.[globalSemesterKey];
180:  if (prepDashboardTab && currentSemester && !isWeeklySemester(globalSemesterKey)) {
642:function getTvSemKey() {
4208:function getAdminSemKey() {
9825:  const currentSemester = currentConfig.semesters?.[globalSemesterKey];
10785:function getSettingsSemKey() {
js/firebase-data.js:297://                                   memory, writes allowed (updateAppData()
js/firebase-data.js:349:async function updateAppData(updates) {
js/firebase-data.js:1474:async function saveCutProjects(semesterKey, projects) {
js/firebase-data.js:1798:async function uploadLessonPhoto(semesterKey, lessonKey, file) {
js/app.js:3535:      const result = await uploadLessonPhoto(semKey, lessonKey, photoInput.files[0]);
js/app.js:4638:    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
js/app.js:4692:    await updateAppData({ [`semesters.${key}.published`]: published });
js/app.js:4780:    await updateAppData({ [`semesters.${key}`]: newSem });
js/app.js:4914:    await updateAppData({ [`semesters.${key}`]: newSem });
js/app.js:5054:    await updateAppData({ [`semesters.${key}`]: newSem });
js/app.js:5810:      const { url, path } = await uploadLessonPhoto(semKey, key, file);
js/app.js:6341:// against curriculum/cutProjects (not saveCutProjects()'s local-splice-then-
js/app.js:6496:// (not saveCutProjects()'s local-splice-then-full-array-overwrite — matches
js/app.js:10937:      await updateAppData(paths);
js/app.js:11031:    await updateAppData(stamps);
js/app.js:11452:    await updateAppData({ ...settingsPaths, ...extraPaths });

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '620,655p;4185,4230p;4570,4800p;10760,10798p;10890,11045p' && rg -n \"saveCutProjects\" . --glob '"'!*.diff'"' --glob '"'!node_modules/**'"' --glob '"'!e2e/**'"'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
   620	  const a = dayOffAuthFor(slot?.yearKey || getTvSemKey());
   621	  return a.canEditAnywhere || (a.hasClassbook && !!a.myTeacherName && (slot?.teachers || []).includes(a.myTeacherName));
   622	}
   623	
   624	// The dates of the camp on which this plan's title runs.
   625	function dayOffTitleDates(yearKey, slot) {
   626	  const camp = (currentDayOffCamps[yearKey] || []).find(c => c.id === slot?.campId);
   627	  return (camp?.dates || []).filter(d => Object.values(normaliseDayOffDayBlocks(camp.projects?.[d])).includes(slot.projectTitle));
   628	}
   629	
   630	let tvInitialized = false;
   631	let tvCurrentView = 'my-schedule';
   632	// By Week / By Class sections start collapsed (except the current week in By
   633	// Week); whatever a teacher opens or closes stays that way across re-renders
   634	// (e.g. ticking Plan Complete) for the rest of the visit.
   635	const tvExpandedSections = new Set();
   636	const tvToggledSections = new Set();
   637	let tvCurrentTeacher = '';
   638	let tvCurrentClassFilter = 'all';
   639	let tvNavStack = [];  // Stack of { teacher, classFilter, scrollY } for back navigation
   640	let campCompleteData = {};
   641	
   642	function getTvSemKey() {
   643	  // Now uses global semester instead of per-tab selection
   644	  return getActiveSemesterKey();
   645	}
   646	
   647	function isCoTeacherForCurrentSemester() {
   648	  const user = getAuthUser();
   649	  if (!user || tvCurrentTeacher) return false;
   650	  const semKey = getTvSemKey();
   651	  const lessons = currentLessonData?.[semKey];
   652	  return !!lessons && Object.values(lessons).some(l =>
   653	    Array.isArray(l.sharedWith) && l.sharedWith.includes(user.uid)
   654	  );
   655	}
  4185	
  4186	function printSingleLesson(key) {
  4187	  const semKey = getAdminSemKey();
  4188	  const lesson = currentLessonData?.[semKey]?.[key];
  4189	  if (!lesson || !lesson.projectTitle) {
  4190	    alert('No lesson data to print.');
  4191	    return;
  4192	  }
  4193	  generatePrintOutput(lesson.weekNum, [lesson]);
  4194	}
  4195	
  4196	// ═════════════════════════════════════════════════════
  4197	// CURRICULUM ADMIN — Grid + Move/Swap/Cut
  4198	// ═════════════════════════════════════════════════════
  4199	
  4200	let caInitialized = false;
  4201	let caActionMode = null;   // null, 'move', 'swap'
  4202	let caSourceKey = null;     // key of source cell for move/swap
  4203	let hqFilterNeedsReply = false;
  4204	let summerCAView = 'schedule'; // 'schedule' or 'byweek'
  4205	let summerTeacherView = 'plans'; // 'plans' or 'calendar'
  4206	let summerByWeekNum = 1;
  4207	
  4208	function getAdminSemKey() {
  4209	  return getActiveSemesterKey();
  4210	}
  4211	
  4212	// ─── Summer CA Views ──────────────────────────────────────────────────────────
  4213	
  4214	// Titles that have no lesson plan — show as plain text, not clickable
  4215	function isSummerNoPlanTitle(title) {
  4216	  if (!title) return true;
  4217	  const t = title.trim().toLowerCase();
  4218	  return t === 'open studio' || t === 'wrap up + art show' || t === '—' || t === '';
  4219	}
  4220	
  4221	function getSummerTeacherColor(teacher) {
  4222	  const colors = {
  4223	    'Allie': '#F97316', 'Kathy': '#8B5CF6', 'Mariah': '#14B8A6',
  4224	    'Jane': '#EC4899', 'Julia': '#10B981', 'Kaitlyn': '#3B82F6',
  4225	    'Lisa': '#F59E0B', 'Ryan': '#84CC16', 'Cate': '#C026D3',
  4226	    'Track C': '#06B6D4', 'Track D': '#EF4444',
  4227	  };
  4228	  return colors[teacher] || '#6B7280';
  4229	}
  4230	
  4570	    let copyHtml = '<option value="">Start blank (no classes)</option>';
  4571	    for (const key of keys.filter(k => !isDayOffYear(k))) {
  4572	      copyHtml += `<option value="${escAttr(key)}">${escHtml(semesters[key].name)}</option>`;
  4573	    }
  4574	    copyFrom.innerHTML = copyHtml;
  4575	  }
  4576	
  4577	  // Publish toggle for current semester
  4578	  const sem = semesters[currentKey];
  4579	  if (sem) {
  4580	    const isPublished = sem.published !== false;
  4581	    const isActive = currentKey === currentConfig.activeSemester;
  4582	    publishGroup.innerHTML = `
  4583	      ${isActive ? '<span class="ca-sem-active-badge">Active Semester</span>' : ''}
  4584	      ${!isActive ? `<label class="ca-publish-toggle">
  4585	        <input type="checkbox" ${isPublished ? 'checked' : ''} onchange="toggleSemesterPublish(${escForOnclick(currentKey)}, this.checked)">
  4586	        Published (visible to teachers)
  4587	      </label>` : ''}
  4588	      ${!isPublished && !isActive ? '<span class="ca-sem-unpublished-badge">Draft</span>' : ''}
  4589	      ${!isActive ? `<button class="btn-text ca-delete-sem-btn" onclick="deleteSemester(${escForOnclick(currentKey)})" title="Delete this semester">&#128465; Delete</button>` : ''}
  4590	    `;
  4591	  }
  4592	}
  4593	
  4594	async function deleteSemester(key) {
  4595	  const sem = currentConfig?.semesters?.[key];
  4596	  if (!sem) return;
  4597	  // Spring 2026 storage move: deleting an own-doc semester is disabled until the
  4598	  // follow-up plan routes it (its lessons may live in their own document).
  4599	  if (isOwnDocSemester(key)) {
  4600	    alert(`"${sem.name}" can't be deleted while its storage is being changed.`);
  4601	    return;
  4602	  }
  4603	  if (key === currentConfig.activeSemester) {
  4604	    alert('Cannot delete the active semester.');
  4605	    return;
  4606	  }
  4607	  // Removing a CAMP season from the Classbook removes only this app's entry
  4608	  // for it. Its camps, schedule, plans and photos belong to the Summer Camp
  4609	  // App and stay exactly where they are — adding the season back from the
  4610	  // registry restores the whole view (Phase 1, 1.7). This supersedes the
  4611	  // companion plan's summer-delete design, which predates seasons.
  4612	  // An SDOC year: refused while any event exists (a forced-server count);
  4613	  // otherwise only its appData entry goes — it has nothing in
  4614	  // curriculum/lessonData, and no collection is ever cleared from here.
  4615	  if (isDayOffYear(key)) {
  4616	    let events;
  4617	    try { events = await countDayOffEvents(key); }
  4618	    catch (err) { alert(`Could not check "${sem.name}" for events: ${err.message}\n\nNothing was changed.`); return; }
  4619	    if (events > 0) { alert(`"${sem.name}" still has ${events} event${events === 1 ? '' : 's'}. Remove its events first.`); return; }
  4620	  }
  4621	  const isCamp = isCampSeason(key);
  4622	  const isDayOff = isDayOffYear(key);
  4623	  const firstConfirm = isDayOff
  4624	    ? `Delete the school year "${sem.name}"? It has no events, so only the year itself is removed.`
  4625	    : isCamp
  4626	    ? `Remove "${sem.name}" from the Classbook?\n\nThis only removes it here. Every camp, schedule, lesson plan and photo stays in the Summer Camp App, and you can add the season back at any time from + New Semester.`
  4627	    : `Delete semester "${sem.name}"? This will remove all its lesson data, cut bank, and change history. This cannot be undone.`;
  4628	  if (!confirm(firstConfirm)) return;
  4629	  if (!isCamp && !isDayOff && !confirm(`Are you sure? Type OK in your head and click OK to confirm.`)) return;
  4630	
  4631	  // Remove the semester's own entry and nothing else (Phase 1, 1.2). Revert
  4632	  // this tab if the write is refused, or the config would be missing a
  4633	  // semester the server still has — with no alert and no re-render to show it
  4634	  // (Phase 1 review).
  4635	  const removed = currentConfig.semesters[key];
  4636	  delete currentConfig.semesters[key];
  4637	  try {
  4638	    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
  4639	  } catch (err) {
  4640	    currentConfig.semesters[key] = removed;
  4641	    console.error('❌ Could not remove the semester:', err);
  4642	    alert(`Could not remove "${sem.name}": ${err.message}\n\nNothing was changed.`);
  4643	    renderSemesterSelector();
  4644	    return;
  4645	  }
  4646	
  4647	  // Drop this season's in-memory map either way…
  4648	  if (currentLessonData?.[key]) {
  4649	    delete currentLessonData[key];
  4650	  }
  4651	  // …but only a WEEKLY semester has lessons of its own inside
  4652	  // curriculum/lessonData to delete. A camp season's lessons live in the
  4653	  // shared summerCamps_* collections and are never touched from here.
  4654	  if (isDayOff) {
  4655	    delete currentDayOffEvents[key]; delete currentDayOffCamps[key]; delete currentDayOffPlans[key]; delete currentDayOffSignoffs[key];
  4656	  } else if (!isCamp) {
  4657	    try {
  4658	      await deleteLessonData(key);
  4659	    } catch (e) { console.warn('Could not delete lesson data for', key, e); }
  4660	  }
  4661	
  4662	  // Switch to active semester
  4663	  caCurrentSemester = currentConfig.activeSemester;
  4664	  renderSemesterSelector();
  4665	  renderAdminGrid();
  4666	  renderHelpQueue();
  4667	  renderCutBank();
  4668	  renderIdeaBank();
  4669	  renderChangeHistory();
  4670	}
  4671	
  4672	function switchAdminSemester(key) {
  4673	  // Delegates to global semester — CA always stays in sync with the header selector
  4674	  setGlobalSemester(key);
  4675	}
  4676	
  4677	async function toggleSemesterPublish(key, published) {
  4678	  if (!currentConfig?.semesters?.[key]) return;
  4679	  if (!isPublishableType(key)) { alert('This semester type can\'t be published.'); return; }
  4680	  // SDOC (Phase 2B): publishing shows the year to every teacher on a camp —
  4681	  // say so first if some camps have nobody to see them.
  4682	  if (published && isDayOffYear(key)) {
  4683	    // The camp list below must be real to warn from — never publish on a failed load.
  4684	    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
  4685	    const bare = (currentDayOffCamps[key] || []).filter(c => !(c.teachers || []).length).length;
  4686	    if (bare && !confirm(`${bare} camp${bare === 1 ? ' has' : 's have'} no teacher yet — publish anyway?`)) { renderSemesterSelector(); return; }
  4687	  }
  4688	  const hadPublished = 'published' in currentConfig.semesters[key];
  4689	  const previous = currentConfig.semesters[key].published;
  4690	  currentConfig.semesters[key].published = published;
  4691	  try {
  4692	    await updateAppData({ [`semesters.${key}.published`]: published });
  4693	  } catch (err) {
  4694	    // Restore exactly what was there — including "the field was absent".
  4695	    if (currentConfig.semesters[key]) {
  4696	      if (hadPublished) currentConfig.semesters[key].published = previous;
  4697	      else delete currentConfig.semesters[key].published;
  4698	    }
  4699	    console.error('❌ Could not change the publish state:', err);
  4700	    alert(`Could not ${published ? 'publish' : 'unpublish'} that semester: ${err.message}\n\nNothing was changed.`);
  4701	  }
  4702	  renderSemesterSelector();
  4703	}
  4704	
  4705	// Which types may be published to teachers. SDOC years joined in Phase 2B,
  4706	// when teachers got their day-off plans to build.
  4707	const PUBLISHABLE_SEMESTER_TYPES = new Set([SEMESTER_TYPES.weekly, SEMESTER_TYPES.camp, SEMESTER_TYPES.dayOff]);
  4708	function isPublishableType(semKey) { return PUBLISHABLE_SEMESTER_TYPES.has(semesterTypeOf(semKey)); }
  4709	
  4710	function openNewSemesterModal() {
  4711	  document.getElementById('ca-new-semester-modal')?.classList.add('open');
  4712	  // Reset to the default type each time, then load the seasons on offer.
  4713	  const weeklyRadio = document.querySelector('input[name="new-sem-type"][value="weekly"]');
  4714	  if (weeklyRadio) weeklyRadio.checked = true;
  4715	  onNewSemesterTypeChange();
  4716	  populateNewSemesterSeasons();
  4717	  document.getElementById('new-sem-name')?.focus();
  4718	}
  4719	
  4720	function selectedNewSemesterType() {
  4721	  return document.querySelector('input[name="new-sem-type"]:checked')?.value || SEMESTER_TYPES.weekly;
  4722	}
  4723	
  4724	function onNewSemesterTypeChange() {
  4725	  const type = selectedNewSemesterType();
  4726	  const weekly = document.getElementById('new-sem-weekly-fields');
  4727	  const camp = document.getElementById('new-sem-camp-fields');
  4728	  const dayOff = document.getElementById('new-sem-dayoff-fields');
  4729	  if (weekly) weekly.hidden = type !== SEMESTER_TYPES.weekly;
  4730	  if (camp) camp.hidden = type !== SEMESTER_TYPES.camp;
  4731	  if (dayOff) {
  4732	    dayOff.hidden = type !== SEMESTER_TYPES.dayOff;
  4733	    if (type === SEMESTER_TYPES.dayOff) resetDayOffYearFields();
  4734	  }
  4735	}
  4736	
  4737	// Defaults: Aug 1 of this year → May 31 of the next; name follows the dates
  4738	// until the admin types their own.
  4739	function resetDayOffYearFields() {
  4740	  const y = new Date().getFullYear();
  4741	  const start = document.getElementById('new-sem-dayoff-start');
  4742	  const end = document.getElementById('new-sem-dayoff-end');
  4743	  const name = document.getElementById('new-sem-dayoff-name');
  4744	  if (start) start.value = `${y}-08-01`;
  4745	  if (end) end.value = `${y + 1}-05-31`;
  4746	  if (name) delete name.dataset.edited;
  4747	  onDayOffYearDatesChange();
  4748	}
  4749	
  4750	function onDayOffYearDatesChange() {
  4751	  const name = document.getElementById('new-sem-dayoff-name');
  4752	  if (!name || name.dataset.edited) return;
  4753	  const start = document.getElementById('new-sem-dayoff-start')?.value || '';
  4754	  const end = document.getElementById('new-sem-dayoff-end')?.value || '';
  4755	  name.value = start && end ? dayOffYearLabels(start, end).name : '';
  4756	}
  4757	
  4758	// An SDOC school year: one appData entry through the field-path writer, after
  4759	// a forced-server absence check. No roster, no lesson slots, no
  4760	// curriculum/lessonData write.
  4761	async function createDayOffYear() {
  4762	  const startDate = document.getElementById('new-sem-dayoff-start')?.value || '';
  4763	  const endDate = document.getElementById('new-sem-dayoff-end')?.value || '';
  4764	  const name = document.getElementById('new-sem-dayoff-name')?.value.trim() || '';
  4765	  if (!isIsoDate(startDate) || !isIsoDate(endDate)) { alert('Pick the school year\'s start and end dates.'); return; }
  4766	  if (endDate <= startDate) { alert('The school year has to end after it starts.'); return; }
  4767	  if (!name) { alert('Give the school year a name.'); return; }
  4768	  const { key } = dayOffYearLabels(startDate, endDate);
  4769	  if (currentConfig.semesters?.[key]) { alert(`${currentConfig.semesters[key].name} already exists (${key}).`); return; }
  4770	
  4771	  creatingSemester = true;
  4772	  try {
  4773	    const serverConfig = await readAppDataFromServer();
  4774	    if (serverConfig?.semesters?.[key]) {
  4775	      alert(`A school year with key "${key}" was already created (in another tab, or by another admin). Reload to see it.`);
  4776	      creatingSemester = false;
  4777	      return;
  4778	    }
  4779	    const newSem = { name, semesterType: SEMESTER_TYPES.dayOff, startDate, endDate, published: false, teacherNames: [] };
  4780	    await updateAppData({ [`semesters.${key}`]: newSem });
  4781	    currentConfig.semesters[key] = newSem;
  4782	  } catch (err) {
  4783	    console.error('❌ Could not create the school year:', err);
  4784	    alert(`Could not create that school year: ${err.message}`);
  4785	    creatingSemester = false;
  4786	    return;
  4787	  }
  4788	  // The write landed — anything failing from here is display only.
  4789	  try {
  4790	    currentDayOffEvents[key] = [];
  4791	    currentDayOffCamps[key] = [];
  4792	    currentDayOffPlans[key] = {};
  4793	    currentDayOffSignoffs[key] = {};
  4794	    if (currentLessonData) currentLessonData[key] = {};
  4795	    closeNewSemesterModal();
  4796	    renderSemesterSelector();
  4797	    initGlobalSemesterSelector();
  4798	    alert(`${name} created. It stays hidden from teachers. Next: add its teacher names in Settings, then its day-off dates and camps in Curriculum Admin.`);
  4799	  } catch (err) {
  4800	    console.error('School year created, but the page did not refresh:', err);
 10760	      if (noteRow) {
 10761	        noteRow.style.display = 'flex';
 10762	        noteRow.querySelector('.diag-note-input')?.focus();
 10763	      }
 10764	    });
 10765	  });
 10766	
 10767	  // Save note buttons
 10768	  resultsDiv.querySelectorAll('.diag-note-save').forEach(btn => {
 10769	    btn.addEventListener('click', () => {
 10770	      const fp = btn.dataset.fp;
 10771	      const item = btn.closest('.diag-item');
 10772	      const textarea = item.querySelector(`.diag-note-input[data-fp="${fp}"]`);
 10773	      if (textarea) {
 10774	        // Trigger the blur handler which does the actual save
 10775	        textarea.blur();
 10776	      }
 10777	    });
 10778	  });
 10779	}
 10780	
 10781	// ═════════════════════════════════════════════════════
 10782	// SETTINGS
 10783	// ═════════════════════════════════════════════════════
 10784	
 10785	function getSettingsSemKey() {
 10786	  // Now uses global semester instead of per-tab selection
 10787	  return getActiveSemesterKey();
 10788	}
 10789	
 10790	let settingsTeacherPoolAtLoad = { semKey: null, names: [] };
 10791	// Which semester the Settings form was last drawn for. Save writes to the
 10792	// HEADER's semester, so the two must match: the form used to redraw only on a
 10793	// semester change made while on Settings, and after switching semesters
 10794	// elsewhere a Save wrote one semester's values onto another (Sep 24).
 10795	let settingsFormSemKey = null;
 10796	
 10797	// Redraw only when the header's semester differs from the form's — returning
 10798	// to the tab for the same semester keeps any unsaved edits.
 10890	  const isDayOff = isDayOffYear(semKey);
 10891	  document.querySelectorAll('.weekly-only-field').forEach(row => { row.style.display = isDayOff ? 'none' : ''; });
 10892	  document.querySelectorAll('.dayoff-only-field').forEach(row => { row.hidden = !isDayOff; });
 10893	  const namesDesc = document.getElementById('teacher-names-desc');
 10894	  if (namesDesc) {
 10895	    namesDesc.textContent = isDayOff
 10896	      ? 'The teachers who may run this year\'s day-off camps. They appear as the teacher checkboxes in each camp.'
 10897	      : 'Define teacher names for this semester. These appear in the Class Roster teacher dropdown and Curriculum Admin grid.';
 10898	  }
 10899	  if (isDayOff) {
 10900	    document.querySelectorAll('.weekly-roster-section').forEach(sec => { sec.style.display = 'none'; });
 10901	    if (el('settings-dayoff-start')) el('settings-dayoff-start').value = semester.startDate || '';
 10902	    if (el('settings-end-date')) el('settings-end-date').value = semester.endDate || '';
 10903	  }
 10904	
 10905	  renderSeasonsCard();
 10906	  renderSemesterTypeMigrationCard();
 10907	}
 10908	
 10909	// Pull this camp season's six registry-sourced fields again — the one way to
 10910	// change them here, and it copies rather than types (Phase 1, 1.6/1.7).
 10911	async function resyncCampSeasonFromRegistry() {
 10912	  const semKey = getSettingsSemKey();
 10913	  const sem = currentConfig?.semesters?.[semKey];
 10914	  if (!sem || !isCampSeason(semKey)) return;
 10915	  try {
 10916	    const registered = await listRegisteredSeasons();
 10917	    const reg = registered.find(r => r.season === seasonForSemester(semKey));
 10918	    if (!reg) { alert(`The Summer Camp App has no season ${seasonForSemester(semKey)} to sync from.`); return; }
 10919	    // Validate the RAW registry document: semesterFromRegistrySeason() coerces
 10920	    // anything absent to ''/0/[], so checking its OUTPUT could never see a
 10921	    // missing name, and let a negative week count or an empty-string studio
 10922	    // through (Phase 1 fix review).
 10923	    const problems = registrySeasonProblems(reg);
 10924	    if (problems.length) {
 10925	      alert(`Can't re-sync ${seasonForSemester(semKey)}: the Summer Camp App's season still needs ${problems.join(', ')}. Finish setting it up there first — nothing was changed here.`);
 10926	      return;
 10927	    }
 10928	    const fresh = semesterFromRegistrySeason(reg);
 10929	    const paths = {};
 10930	    const previous = {};
 10931	    for (const f of ['name', 'startDate', 'numWeeks', 'breakWeeks', 'timeSlots', 'studios']) {
 10932	      paths[`semesters.${semKey}.${f}`] = fresh[f];
 10933	      previous[f] = sem[f];
 10934	      sem[f] = fresh[f];
 10935	    }
 10936	    try {
 10937	      await updateAppData(paths);
 10938	    } catch (err) {
 10939	      // Put this tab back the way it was — the server never changed.
 10940	      for (const [f, v] of Object.entries(previous)) { if (v === undefined) delete sem[f]; else sem[f] = v; }
 10941	      throw err;
 10942	    }
 10943	    loadSettingsForm();
 10944	    renderAdminGrid();
 10945	    alert(`${fresh.name} re-synced from the Summer Camp App.`);
 10946	  } catch (err) {
 10947	    console.error('Could not re-sync the season:', err);
 10948	    alert(`Could not re-sync: ${err.message}`);
 10949	  }
 10950	}
 10951	
 10952	// Read-only: what the registry holds, which seasons are in the Classbook, and
 10953	// which mode this tab is in.
 10954	function renderSeasonsCard() {
 10955	  const card = document.getElementById('settings-seasons-card');
 10956	  if (!card) return;
 10957	  const mode = getSeasonRegistryMode();
 10958	  const modeText = {
 10959	    filtered: 'Season filtering is on — each camp season shows only its own camps.',
 10960	    legacy: 'The Summer Camp App has not switched seasons on yet, so Summer 2026 reads everything (there is only one season).',
 10961	    error: "Can't read the season registry — check Firestore rules. Camp data is not being shown.",
 10962	    unknown: "Can't reach the season registry — waiting for a connection.",
 10963	  }[mode] || mode;
 10964	  const campSemesters = Object.keys(currentConfig?.semesters || {}).filter(isCampSeason);
 10965	  card.innerHTML = `
 10966	    <h3 class="settings-subsection-title">Camp Seasons</h3>
 10967	    <p class="settings-panel-desc">${escHtml(modeText)}</p>
 10968	    <p class="settings-panel-desc">In the Classbook: ${campSemesters.length
 10969	      ? campSemesters.map(k => `${escHtml(currentConfig.semesters[k].name)} (${escHtml(seasonForSemesterSafe(k))})`).join(', ')
 10970	      : 'none yet'}. Seasons are created in the Summer Camp App, then added here with + New Semester.</p>`;
 10971	}
 10972	
 10973	// ─── "Stamp semester types" — the one-time migration (Phase 1, 1.2) ──────────
 10974	// Dry run first, always: it reads the SERVER's appData (not this tab's copy),
 10975	// lists every change, and refuses if a semester already carries a type that
 10976	// contradicts the migration. The write is one update() of field paths, and it
 10977	// is verified by a forced-server read-back that diffs field by field.
 10978	let pendingSemesterTypeStamps = null;
 10979	
 10980	function renderSemesterTypeMigrationCard() {
 10981	  const card = document.getElementById('settings-type-migration-card');
 10982	  if (!card) return;
 10983	  const user = getAuthUser();
 10984	  if (!user || user.role !== 'admin') { card.hidden = true; return; }   // admin-only
 10985	  card.hidden = false;
 10986	  card.innerHTML = `
 10987	    <h3 class="settings-subsection-title">Stamp semester types</h3>
 10988	    <p class="settings-panel-desc">A one-time step: records on every semester whether it is weekly classes or a camp season, and fills in Summer 2026's season details. Run the dry run first — it changes nothing.</p>
 10989	    <div class="settings-actions" style="justify-content:flex-start;gap:0.5rem;">
 10990	      <button class="btn-secondary write-control" onclick="dryRunSemesterTypeStamps()">Dry run</button>
 10991	      <button class="btn-primary write-control" id="stamp-types-btn" onclick="applySemesterTypeStamps()" disabled>Stamp semester types</button>
 10992	    </div>
 10993	    <pre id="stamp-types-output" class="settings-hint" style="white-space:pre-wrap;margin-top:0.5rem;"></pre>`;
 10994	}
 10995	
 10996	function stampOutput(text) {
 10997	  const out = document.getElementById('stamp-types-output');
 10998	  if (out) out.textContent = text;
 10999	}
 11000	
 11001	async function dryRunSemesterTypeStamps() {
 11002	  pendingSemesterTypeStamps = null;
 11003	  const btn = document.getElementById('stamp-types-btn');
 11004	  if (btn) btn.disabled = true;
 11005	  try {
 11006	    const serverConfig = await readAppDataFromServer();
 11007	    if (!serverConfig) { stampOutput('There is no app configuration document on the server yet — nothing to stamp.'); return; }
 11008	    const stamps = buildSemesterTypeStamps(serverConfig);
 11009	    // The snapshot goes to the console before anything is written, so a copy
 11010	    // of the pre-migration document exists outside Firestore.
 11011	    console.log('📋 appData snapshot before stamping semester types:', JSON.stringify(serverConfig, null, 2));
 11012	    const keys = Object.keys(stamps);
 11013	    if (keys.length === 0) { stampOutput('Nothing to stamp — every semester already carries its type.'); return; }
 11014	    pendingSemesterTypeStamps = { stamps, serverConfig };
 11015	    if (btn) btn.disabled = false;
 11016	    stampOutput(`${keys.length} change(s) ready. A full snapshot of the current configuration is in the browser console.\n\n`
 11017	      + keys.map(k => `  ${k} = ${JSON.stringify(stamps[k])}`).join('\n')
 11018	      + `\n\nRun a backup (backup.js --force) before pressing Stamp.`);
 11019	  } catch (err) {
 11020	    console.error('Dry run failed:', err);
 11021	    stampOutput(`Dry run failed: ${err.message}`);
 11022	  }
 11023	}
 11024	
 11025	async function applySemesterTypeStamps() {
 11026	  if (!pendingSemesterTypeStamps) { stampOutput('Run the dry run first.'); return; }
 11027	  const { stamps, serverConfig } = pendingSemesterTypeStamps;
 11028	  const btn = document.getElementById('stamp-types-btn');
 11029	  if (btn) btn.disabled = true;
 11030	  try {
 11031	    await updateAppData(stamps);
 11032	    // Read back from the SERVER and check field by field: every stamped path
 11033	    // has its new value, and nothing else moved. lastUpdated/lastUpdatedBy are
 11034	    // the two the helper always sets, so they are excluded from the diff.
 11035	    const after = await readAppDataFromServer();
 11036	    const problems = [];
 11037	    for (const [path, expected] of Object.entries(stamps)) {
 11038	      const actual = path.split('.').reduce((node, part) => (node == null ? node : node[part]), after);
 11039	      if (stableJson(actual) !== stableJson(expected)) problems.push(`${path}: expected ${JSON.stringify(expected)}, found ${JSON.stringify(actual)}`);
 11040	    }
 11041	    // Compare the WHOLE document, both directions, so an unexpected change or
 11042	    // loss anywhere is caught — not only in the semesters that happened to
 11043	    // exist when the dry run read the server.
 11044	    const IGNORE_TOP = new Set(['lastUpdated', 'lastUpdatedBy']);   // the helper always sets these
 11045	    for (const field of new Set([...Object.keys(serverConfig || {}), ...Object.keys(after || {})])) {
./js/app.js:6341:// against curriculum/cutProjects (not saveCutProjects()'s local-splice-then-
./js/app.js:6496:// (not saveCutProjects()'s local-splice-then-full-array-overwrite — matches
./js/firebase-data.js:1474:async function saveCutProjects(semesterKey, projects) {

codex
The caller inventory now shows the obvious compound Spring workflows were guarded before their first external mutation. I’m checking less obvious failure paths next: listener-error state transitions, whether the Studio Hub “migration completed” marker can be written from incomplete source data, and whether the new tests genuinely model those races rather than only direct helpers.
exec
/bin/zsh -lc "nl -ba /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js | sed -n '1,120p;500,690p;840,930p' && nl -ba js/firebase-data.js | sed -n '70,230p;885,970p;1300,1460p' && nl -ba js/app.js | sed -n '6200,6420p;6485,6580p;6970,7050p;7200,7380p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
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
   560	  // Stored among the dismissed ids once old-format Classbook dismissals are migrated.
   561	  const CLASSBOOK_QA_DISMISSALS_MIGRATED = 'classbook-qa-dismissals-migrated-v2';
   562	
   563	  function listenToClassbook(db) {
   564	    // Teacher questions — ALL unanswered questions (immediate alerts).
   565	    // Weekly lessons live in curriculum/lessonData AND, for semesters moved to their
   566	    // own document (Classbook storage move, Sep 2026), in curriculum/lessons_<semKey>.
   567	    // Each document has its own listener; alerts are rebuilt from the UNION of the
   568	    // latest snapshot of each (buildClassbookQaAlerts, js/classbook-qa-alerts.js), so
   569	    // one listener's snapshot never removes the other's alerts.
   570	    const sources = { lessonData: null, ownDocs: {} };
   571	    const received = new Set();   // which documents have delivered at least one snapshot
   572	    const expected = ['lessonData', ...CLASSBOOK_OWN_DOC_SEMESTERS.map(k => `lessons_${k}`)];
   573	
   574	    const rebuild = () => {
   575	      // Don't build (or prune) until every watched document has reported once, so a
   576	      // semester never flickers out of the alert list while its source is loading.
   577	      if (!expected.every(id => received.has(id))) return;
   578	      const unansweredQuestions = buildClassbookQaAlerts(sources, Date.now());
   579	      const currentClassbookAlertIds = unansweredQuestions.map(a => a.id);
   580	
   581	      // One-time migration of dismissals saved under the pre-Sep-2026 id
   582	      // (classbook-qa-<lessonKey>): each currently-open question whose old id was
   583	      // dismissed gets its new id dismissed, then the old ids are retired, so an old
   584	      // dismissal can never hide a FUTURE question on the same lesson key (in any
   585	      // semester). A marker records that it ran; it only runs once every watched
   586	      // document has reported (see rebuild's guard above), so "currently open" is complete.
   587	      if (!dismissedAlertIds.has(CLASSBOOK_QA_DISMISSALS_MIGRATED)) {
   588	        const retired = new Set();
   589	        unansweredQuestions.forEach(alert => {
   590	          if (dismissedAlertIds.has(alert.legacyId)) {
   591	            dismissedAlertIds.add(alert.id);
   592	            retired.add(alert.legacyId);
   593	          }
   594	        });
   595	        retired.forEach(id => dismissedAlertIds.delete(id));
   596	        dismissedAlertIds.add(CLASSBOOK_QA_DISMISSALS_MIGRATED);
   597	        saveDismissedAlerts();
   598	      }
   599	
   600	      // Remove old Classbook alerts that are no longer unanswered
   601	      alerts.forEach(alert => {
   602	        if (alert.type === 'curriculum' && !currentClassbookAlertIds.includes(alert.id)) {
   603	          removeAlert(alert.id);
   604	        }
   605	      });
   606	
   607	      // Update all Q&A alerts
   608	      unansweredQuestions.forEach(alert => addOrUpdateAlert(alert));
   609	
   610	      updateUI();
   611	    };
   612	
   613	    const classbookListener = db.collection('curriculum')
   614	      .doc('lessonData')
   615	      .onSnapshot(doc => {
   616	        sources.lessonData = doc.exists ? doc.data() : null;
   617	        received.add('lessonData');
   618	        rebuild();
   619	      }, error => {
   620	        console.error('Classbook listener error:', error);
   621	      });
   622	    listeners.push(classbookListener);
   623	
   624	    CLASSBOOK_OWN_DOC_SEMESTERS.forEach(semKey => {
   625	      const ownDocListener = db.collection('curriculum')
   626	        .doc(`lessons_${semKey}`)
   627	        .onSnapshot(doc => {
   628	          sources.ownDocs[semKey] = doc.exists ? doc.data() : null;
   629	          received.add(`lessons_${semKey}`);
   630	          rebuild();
   631	        }, error => {
   632	          // Keep the last good snapshot of this document (a transient error must not
   633	          // look like "all of this semester's questions were answered"). If it never
   634	          // arrived, carry on without it so the other semesters still alert.
   635	          console.error(`Classbook ${semKey} listener error:`, error);
   636	          if (!received.has(`lessons_${semKey}`)) {
   637	            received.add(`lessons_${semKey}`);
   638	            rebuild();
   639	          }
   640	        });
   641	      listeners.push(ownDocListener);
   642	    });
   643	  }
   644	
   645	  // =====================================================
   646	  // Alert Management
   647	  // =====================================================
   648	
   649	  function addOrUpdateAlert(alert) {
   650	    if (dismissedAlertIds.has(alert.id)) {
   651	      // Route to dismissed list — alert is still tracked but not shown as active
   652	      alert.dismissed = true;
   653	      const existingIndex = dismissedAlerts.findIndex(a => a.id === alert.id);
   654	      if (existingIndex >= 0) {
   655	        dismissedAlerts[existingIndex] = alert;
   656	      } else {
   657	        dismissedAlerts.push(alert);
   658	      }
   659	      return;
   660	    }
   661	
   662	    const existingIndex = alerts.findIndex(a => a.id === alert.id);
   663	    if (existingIndex >= 0) {
   664	      alerts[existingIndex] = alert;
   665	    } else {
   666	      alerts.push(alert);
   667	    }
   668	  }
   669	
   670	  function removeAlert(alertId) {
   671	    alerts = alerts.filter(a => a.id !== alertId);
   672	    // If the underlying data resolved, auto-clean the dismissal too
   673	    if (dismissedAlertIds.has(alertId)) {
   674	      dismissedAlertIds.delete(alertId);
   675	      dismissedAlerts = dismissedAlerts.filter(a => a.id !== alertId);
   676	      saveDismissedAlerts();
   677	    }
   678	  }
   679	
   680	  function dismissAlert(alertId) {
   681	    const alert = alerts.find(a => a.id === alertId);
   682	    if (alert) {
   683	      alert.dismissed = true;
   684	      alert.dismissedAt = new Date().toISOString();
   685	      dismissedAlerts.push(alert);
   686	      alerts = alerts.filter(a => a.id !== alertId);
   687	      dismissedAlertIds.add(alertId);
   688	      saveDismissedAlerts();
   689	      updateUI();
   690	    }
   840	    ['all', 'pending', 'overdue', 'urgent'].forEach(filter => {
   841	      const btn = document.getElementById(`filter-${filter}`);
   842	      if (btn) {
   843	        btn.classList.toggle('active', currentFilter === filter);
   844	      }
   845	    });
   846	  }
   847	
   848	  function setFilter(filter) {
   849	    currentFilter = filter;
   850	    renderAlertFeed();
   851	  }
   852	
   853	  // =====================================================
   854	  // Helpers
   855	  // =====================================================
   856	
   857	  function getAlertIcon(type) {
   858	    const icons = {
   859	      'timeclock': '⏰',
   860	      'private-events': '🎉',
   861	      'clay-membership': '🏺',
   862	      'recap': '📝',
   863	      'curriculum': '📚'
   864	    };
   865	    return icons[type] || '📌';
   866	  }
   867	
   868	  function getAlertCategory(alert) {
   869	    if (alert.priority === 'urgent') return 'Urgent';
   870	    if (alert.priority === 'warning') return 'Overdue';
   871	    return 'Pending';
   872	  }
   873	
   874	  function formatTimeAgo(timestamp) {
   875	    const now = Date.now();
   876	    const time = new Date(timestamp).getTime();
   877	    const diff = now - time;
   878	
   879	    const minutes = Math.floor(diff / (1000 * 60));
   880	    const hours = Math.floor(diff / (1000 * 60 * 60));
   881	    const days = Math.floor(diff / (1000 * 60 * 60 * 24));
   882	
   883	    if (minutes < 60) return `${minutes}m ago`;
   884	    if (hours < 24) return `${hours}h ago`;
   885	    return `${days}d ago`;
   886	  }
   887	
   888	  function formatDate(dateString) {
   889	    if (!dateString) return 'Unknown date';
   890	    const date = new Date(dateString);
   891	    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
   892	  }
   893	
   894	  function formatDateRange(startDate, endDate) {
   895	    if (!startDate) return 'Unknown dates';
   896	    const start = formatDate(startDate);
   897	    if (!endDate || startDate === endDate) return start;
   898	    const end = formatDate(endDate);
   899	    return `${start} - ${end}`;
   900	  }
   901	
   902	  // =====================================================
   903	  // Public API
   904	  // =====================================================
   905	
   906	  return {
   907	    init,
   908	    cleanup,
   909	    setFilter,
   910	    dismissAlert,
   911	    restoreAlert,
   912	    toggleDismissed,
   913	    getAlerts: () => alerts,
   914	    getAlertCount: () => alerts.length,
   915	    getDismissedCount: () => dismissedAlerts.length,
   916	    isShowingDismissed: () => showDismissed
   917	  };
   918	})();
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
   161	// Whether a weekly semester's lessons can be written right now. Every workflow
   162	// that writes lessons calls refuseIfWeeklySemesterPaused() BEFORE its first
   163	// change of any kind (photo upload, cut bank, config, optimistic UI), so a paused
   164	// Spring action changes nothing at all instead of half-happening.
   165	function weeklySemesterPausedMessage(semKey) {
   166	  if (!isOwnDocSemester(semKey)) return null;
   167	  return (ownDocSource[semKey] === 'ownDoc' && ownDocMoveVerified(semKey)) ? null : OWN_DOC_PAUSED_MESSAGE;
   168	}
   169	function refuseIfWeeklySemesterPaused(semKey) {
   170	  const message = weeklySemesterPausedMessage(semKey);
   171	  if (!message) return false;
   172	  alert(message);
   173	  return true;
   174	}
   175	// A standing notice while the selected semester is paused, so nobody discovers
   176	// it by losing a save. Called on load, on semester change and on every state change.
   177	function updateOwnDocPausedNotice() {
   178	  const semKey = typeof globalSemesterKey !== 'undefined' ? globalSemesterKey : null;
   179	  const el = document.getElementById('own-doc-paused-notice');
   180	  const message = semKey ? weeklySemesterPausedMessage(semKey) : null;
   181	  if (!message) { el?.classList.add('hidden'); return; }
   182	  if (el) { el.textContent = `ℹ️ ${message}`; el.classList.remove('hidden'); return; }
   183	  const div = document.createElement('div');
   184	  div.id = 'own-doc-paused-notice';
   185	  div.className = 'storage-notice';
   186	  div.textContent = `ℹ️ ${message}`;
   187	  const anchorEl = document.getElementById('lesson-load-error-banner');
   188	  if (anchorEl?.parentNode) anchorEl.parentNode.insertBefore(div, anchorEl.nextSibling);
   189	  else document.body.prepend(div);
   190	}
   191	
   192	// Bumped on every own-doc or legacy snapshot for a semester, so an in-flight
   193	// recheck (below) only applies its result if nothing has changed since it began.
   194	const ownDocTransitionToken = {};
   195	function bumpOwnDocToken(semKey) { ownDocTransitionToken[semKey] = (ownDocTransitionToken[semKey] || 0) + 1; return ownDocTransitionToken[semKey]; }
   196	
   197	function showStorageNotice(message) {
   198	  let el = document.getElementById('storage-notice-banner');
   199	  if (!el) {
   200	    el = document.createElement('div');
   201	    el.id = 'storage-notice-banner';
   202	    el.className = 'storage-notice';
   203	    const anchorEl = document.getElementById('lesson-load-error-banner');
   204	    if (anchorEl?.parentNode) anchorEl.parentNode.insertBefore(el, anchorEl.nextSibling);
   205	    else document.body.prepend(el);
   206	  }
   207	  el.textContent = message;
   208	  el.classList.remove('hidden');
   209	}
   210	
   211	// ─── Summer document IDs (camp seasons Phase 1, 1.5) ─────────────────────────
   212	// The cross-app contract, shared with the Summer Camp App: 2026 documents keep
   213	// every existing ID unchanged; any other season prefixes the ENTIRE legacy ID
   214	// with the reserved token `season-{year}|||`, applied after the legacy ID is
   215	// fully formed (i.e. after encodeFirestoreKey()). `season-` cannot collide
   216	// with a teacher or camp name, and a bare `{year}|||` prefix would have been
   217	// ambiguous against a legacy ID whose first segment happens to be a year.
   218	// parseSummerDocId() is the exact inverse; anything unprefixed is 2026.
   219	const LEGACY_SEASON = '2026';
   220	const SEASON_DOC_ID_PREFIX = /^season-(\d{4})\|\|\|/;
   221	function summerDocId(legacyId, season) {
   222	  return season === LEGACY_SEASON ? legacyId : `season-${season}|||${legacyId}`;
   223	}
   224	// (semKey, legacy key) → the document ID in that semester's season. Every
   225	// summer writer and by-ID reader goes through this; a static test forbids a
   226	// bare .doc() on a summerCamps_* collection anywhere else.
   227	function summerDocIdFor(semKey, legacyKey) {
   228	  return summerDocId(encodeFirestoreKey(legacyKey), seasonForSemester(semKey));
   229	}
   230	
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
   961	      const plans = campSeasonLoadPlan();
   962	      console.log('📚 Loading camp seasons:', plans.map(p => `${p.semKey}${p.season ? ` (${p.season})` : ' (unfiltered)'}`).join(', ') || 'none');
   963	      for (const plan of plans) {
   964	        currentLessonData[plan.semKey] = await loadOneCampSeason(plan);
   965	        console.log(`📚 ${plan.semKey}: ${Object.keys(currentLessonData[plan.semKey]).length} lessons`);
   966	      }
   967	      // School Day Off Camps years: their own three collections. A failure
   968	      // trips the same app-wide guard — loud, never a quiet empty list.
   969	      for (const yearKey of dayOffYearKeys()) {
   970	        currentLessonData[yearKey] = await loadDayOffCampData({ yearKey });
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
  1428	    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; }));
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
  6200	        <input type="checkbox" class="ca-copy-cb" data-key="${escAttr(s.key)}" ${!hasPlan ? 'checked' : ''}>
  6201	        ${escHtml(s.teacher)} &mdash; ${escHtml(s.className)} (Week ${s.weekNum})
  6202	        <span class="ca-copy-warn">${warnLabel}</span>
  6203	      </label>
  6204	    </div>`;
  6205	  }
  6206	
  6207	  html += `</div>
  6208	    <div class="ca-actions" style="margin-top: 16px;">
  6209	      <button class="btn-primary ca-action-btn ca-copy-btn" onclick="executeCopyPlan(${escForOnclick(sourceKey)})">Copy Plan</button>
  6210	      <button class="btn-secondary ca-action-btn" onclick="openDetailModal(currentLessonData[${escForOnclick(semKey)}][${escForOnclick(sourceKey)}], ${escForOnclick(sourceKey)}, ${escForOnclick(source.teacher)}, ${escForOnclick(source.className)}, ${source.weekNum})">Back</button>
  6211	    </div>
  6212	  </div>`;
  6213	
  6214	  body.innerHTML = html;
  6215	}
  6216	
  6217	function toggleCopyAll(masterCb) {
  6218	  document.querySelectorAll('.ca-copy-cb').forEach(cb => { cb.checked = masterCb.checked; });
  6219	}
  6220	
  6221	// Backtracking audit, Phase 11 (R3-12, R3-13). Previously resaved the ENTIRE
  6222	// cached semester via saveLessonData() — any lesson whose local copy was stale
  6223	// (a teacher's concurrent save in another tab) was silently reverted on the
  6224	// server — mutated the shared cache before any write landed, and logged only
  6225	// after one bulk save, so a part-way failure lost the log for targets that
  6226	// had actually been written. Now: one targeted saveSingleLesson() per target
  6227	// with an explicit fieldsToClear (a source field that is EMPTY must clear the
  6228	// target's stale value — the save strips empty content fields, so without the
  6229	// clear the old text would survive under the new plan), cache committed per
  6230	// target only after its save resolves, logged immediately, honest count on
  6231	// failure.
  6232	async function executeCopyPlan(sourceKey) {
  6233	  const semKey = getAdminSemKey();
  6234	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  6235	  if (refuseIfWeeklySemesterPaused(semKey)) return;
  6236	  const liveLessons = currentLessonData?.[semKey];
  6237	  const source = liveLessons?.[sourceKey];
  6238	  if (!source) return;
  6239	
  6240	  const checkboxes = document.querySelectorAll('.ca-copy-cb:checked');
  6241	  const targetKeys = Array.from(checkboxes).map(cb => cb.dataset.key);
  6242	
  6243	  if (targetKeys.length === 0) {
  6244	    alert('No targets selected.');
  6245	    return;
  6246	  }
  6247	
  6248	  // Check if any targets have existing plans
  6249	  const overwriteTargets = targetKeys.filter(k => liveLessons[k] && hasLessonContent(liveLessons[k]));
  6250	  if (overwriteTargets.length > 0) {
  6251	    const names = overwriteTargets.map(k => {
  6252	      const l = liveLessons[k];
  6253	      return `${l.teacher} — ${l.className} (Wk ${l.weekNum})`;
  6254	    }).join('\n');
  6255	    if (!confirm(`${overwriteTargets.length} target(s) already have lesson plans that will be overwritten:\n\n${names}\n\nContinue?`)) return;
  6256	  }
  6257	
  6258	  const fields = getCopyableFields(source); // the 7 CONTENT_FIELDS plus `materials`
  6259	  let savedCount = 0;
  6260	  let failure = null;
  6261	
  6262	  try {
  6263	    for (const targetKey of targetKeys) {
  6264	      if (!liveLessons[targetKey]) continue;
  6265	      // Work on copies — the shared cache object is only replaced below,
  6266	      // after this target's own save has resolved (R3-13).
  6267	      const previousTarget = { ...liveLessons[targetKey] };
  6268	      const targetFieldsToClear = CONTENT_FIELDS.filter(f =>
  6269	        (previousTarget[f] || '').trim() !== '' && !(fields[f] || '').trim()
  6270	      );
  6271	      // Send ONLY the copied fields (saveSingleLesson writes per-field paths
  6272	      // and stamps lastEditedBy/At onto this object). Sending the whole
  6273	      // cached target would re-write every non-content field — qaThread,
  6274	      // photoUrl, planComplete… — from this admin's possibly-stale copy over
  6275	      // a teacher's concurrent change (implementation review, Sep 2026).
  6276	      const payload = { ...fields };
  6277	      await saveSingleLesson(semKey, targetKey, payload, targetFieldsToClear);
  6278	      const updatedTarget = { ...previousTarget, ...payload };
  6279	      if (currentLessonData[semKey]) currentLessonData[semKey][targetKey] = updatedTarget;
  6280	      savedCount++;
  6281	      // Uncheck the saved target so, if a later one fails, "retry the rest"
  6282	      // re-runs only the rest (no duplicate copies or Change History entries).
  6283	      const cb = document.querySelector(`.ca-copy-cb[data-key="${CSS.escape(targetKey)}"]`);
  6284	      if (cb) cb.checked = false;
  6285	
  6286	      // Log this copy now — before the next target — so a later failure
  6287	      // can't lose the record of a write that already landed.
  6288	      const logEntry = {
  6289	        action: 'copy',
  6290	        details: {
  6291	          projectTitle: source.projectTitle,
  6292	          fromTeacher: source.teacher,
  6293	          fromClassName: source.className,
  6294	          fromWeek: source.weekNum,
  6295	          toTeacher: updatedTarget.teacher,
  6296	          toClassName: updatedTarget.className,
  6297	          toWeek: updatedTarget.weekNum
  6298	        }
  6299	      };
  6300	      // Capture the overwritten plan whenever ANY copyable field had text —
  6301	      // the clear above is explicit and intentional, so Change History must
  6302	      // hold the recovery record even when the prior content lived only in
  6303	      // processStep2-4/closure/dayOfMaterials (which the looser
  6304	      // hasLessonContent() used for the confirm prompt doesn't look at).
  6305	      const previousPlan = getCopyableFields(previousTarget);
  6306	      if (Object.values(previousPlan).some(v => String(v).trim())) {
  6307	        logEntry.details.previousPlan = previousPlan;
  6308	      }
  6309	      try {
  6310	        await appendChangeLogEntry(semKey, logEntry);
  6311	      } catch (logErr) {
  6312	        // The copy itself is saved; a Change History miss must not read as
  6313	        // a failed copy (same rule as saveTeacherEdit(), Phase 8).
  6314	        console.error('⚠️ Copy saved, but Change History logging failed for', targetKey, logErr);
  6315	      }
  6316	    }
  6317	  } catch (err) {
  6318	    console.error('❌ Copy Plan failed partway through:', err);
  6319	    failure = err;
  6320	  }
  6321	
  6322	  // UI after the try/catch so a render exception can't be misreported as a
  6323	  // failed save (and can't re-throw from inside the catch).
  6324	  renderAdminGrid();
  6325	  renderChangeHistory();
  6326	  if (failure) {
  6327	    alert(`Copied to ${savedCount} of ${targetKeys.length} class(es) before a save failed. Please check which targets actually received the plan before retrying the rest.\n\n${failure.message}`);
  6328	    return;
  6329	  }
  6330	  closeAdminModal();
  6331	  const skipped = targetKeys.length - savedCount;
  6332	  alert(`Plan copied to ${savedCount} class${savedCount !== 1 ? 'es' : ''}${skipped > 0 ? ` (${skipped} skipped)` : ''}.`);
  6333	}
  6334	
  6335	// Backtracking audit, Phase 8: rebuilt around the companion plan's Phase 17
  6336	// design. Forced-server read before archiving or deleting anything (closes
  6337	// two failure modes: the doc no longer existing at all, and the doc existing
  6338	// but having genuinely different content than this admin's stale local
  6339	// snapshot — a teacher's concurrent edit). Archives the COMPLETE fresh
  6340	// lesson object (not a hand-picked field list) via FieldValue.arrayUnion()
  6341	// against curriculum/cutProjects (not saveCutProjects()'s local-splice-then-
  6342	// full-array-overwrite — two admins cutting concurrently now both survive
  6343	// regardless of write order). Archive-before-delete ordering — a failed
  6344	// archive save leaves the live lesson completely untouched.
  6345	async function cutProject(key) {
  6346	  const semKey = getAdminSemKey();
  6347	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  6348	  if (refuseIfWeeklySemesterPaused(semKey)) return;
  6349	  const lessons = { ...currentLessonData[semKey] };
  6350	  const lesson = lessons[key];
  6351	  if (!lesson) return;
  6352	
  6353	  if (!confirm(`Cut "${lesson.projectTitle}" from ${lesson.teacher} / ${lesson.className} Week ${lesson.weekNum}? It will be moved to the Cut Projects bank.`)) return;
  6354	
  6355	  let check;
  6356	  try {
  6357	    check = await adminLessonStillExistsWithRetry(semKey, key);
  6358	  } catch (err) {
  6359	    console.error('Could not confirm current state before cutting', key, err);
  6360	    alert(`Could not confirm "${lesson.projectTitle}" still exists — nothing was cut. Check your connection and try again.`);
  6361	    return;
  6362	  }
  6363	  if (!check.exists) {
  6364	    alert(`"${lesson.projectTitle}" no longer exists — it may have been moved, deleted, or already cut by someone else. Nothing was cut.`);
  6365	    if (currentLessonData[semKey]) delete currentLessonData[semKey][key];
  6366	    renderAdminGrid();
  6367	    return;
  6368	  }
  6369	  const freshLesson = check.data;
  6370	
  6371	  // The first confirm() above authorized cutting THIS project, by name — if
  6372	  // the fresh read shows the slot's identity has materially changed since
  6373	  // then, that authorization doesn't cover it.
  6374	  if (freshLesson.projectTitle !== lesson.projectTitle || freshLesson.teacher !== lesson.teacher || freshLesson.className !== lesson.className) {
  6375	    if (!confirm(`This slot has changed since you opened it — it now contains "${freshLesson.projectTitle}" (${freshLesson.teacher} / ${freshLesson.className}). Cut this instead?`)) return;
  6376	  }
  6377	
  6378	  const user = getAuthUser();
  6379	  const archiveEntry = {
  6380	    ...freshLesson,
  6381	    originalTeacher: freshLesson.teacher,
  6382	    originalClassName: freshLesson.className,
  6383	    originalWeek: freshLesson.weekNum,
  6384	    cutDate: new Date().toISOString(),
  6385	    cutBy: user?.name || 'Unknown'
  6386	  };
  6387	
  6388	  if (!curriculumDb) initCurriculumFirestore();
  6389	  try {
  6390	    await curriculumDb.collection('curriculum').doc('cutProjects').set({
  6391	      [semKey]: firebase.firestore.FieldValue.arrayUnion(archiveEntry)
  6392	    }, { merge: true });
  6393	  } catch (e) {
  6394	    console.error('Could not save Cut Bank entry for', key, e);
  6395	    alert(`Could not cut "${freshLesson.projectTitle}" — the Cut Bank entry could not be saved. Nothing was changed.`);
  6396	    return;
  6397	  }
  6398	
  6399	  let deleteFailed = false;
  6400	  try {
  6401	    await deleteLessonKey(semKey, key);
  6402	  } catch (e) {
  6403	    console.error('Could not delete lesson after archiving', key, e);
  6404	    deleteFailed = true;
  6405	  }
  6406	
  6407	  // Local cache/grid only drops the lesson when the delete actually
  6408	  // succeeded — a failed delete leaves the grid showing the lesson as gone
  6409	  // while Firestore still has it live otherwise.
  6410	  if (!deleteFailed) {
  6411	    delete lessons[key];
  6412	    currentLessonData[semKey] = lessons;
  6413	  }
  6414	  if (!currentCutProjects) currentCutProjects = {};
  6415	  currentCutProjects[semKey] = [...(currentCutProjects[semKey] || []), archiveEntry];
  6416	
  6417	  try {
  6418	    await appendChangeLogEntry(semKey, {
  6419	      action: 'cut',
  6420	      details: { projectTitle: freshLesson.projectTitle, teacher: freshLesson.teacher, className: freshLesson.className, fromWeek: freshLesson.weekNum }
  6485	      });
  6486	      html += '</div></div>';
  6487	    }
  6488	    html += '</details>';
  6489	  }
  6490	
  6491	  body.innerHTML = html;
  6492	}
  6493	
  6494	// Backtracking audit, Phase 8: targeted single-lesson save (not a bulk
  6495	// saveLessonData() semester overwrite), removal via FieldValue.arrayRemove()
  6496	// (not saveCutProjects()'s local-splice-then-full-array-overwrite — matches
  6497	// cutProject()'s arrayUnion() append-side fix, same document, same reasoning:
  6498	// two admins acting on the Cut Bank concurrently now both survive). The
  6499	// reconstruction below is an EXPLICIT FIELD WHITELIST, not spread-minus-
  6500	// exclude — a whitelist can't leak a future field cutProject()'s
  6501	// complete-spread archive starts including that an exclude-list doesn't yet
  6502	// know to exclude. classSize preserves the destination's own existing
  6503	// scaffold value (round-6 fix) rather than being hardcoded to 0 — nothing
  6504	// downstream recomputes it on paste. teacherNotes/adminResponse/status are
  6505	// excluded alongside qaThread (round-6 fix): getQaThread() reconstructs a
  6506	// Q&A thread from teacherNotes/adminResponse whenever qaThread is absent, so
  6507	// restoring those two fields alone would still leak the original
  6508	// conversation even with qaThread itself correctly omitted.
  6509	async function pasteFromCutBank(cutIndex, teacher, className, weekNum, sourceSemKey) {
  6510	  const destSemKey = getAdminSemKey();
  6511	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  6512	  if (refuseIfWeeklySemesterPaused(destSemKey)) return;
  6513	  const srcSemKey = sourceSemKey || destSemKey;
  6514	  const cutProjects = currentCutProjects?.[srcSemKey] || [];
  6515	  const proj = cutProjects[cutIndex];
  6516	  if (!proj) return;
  6517	
  6518	  const isCrossSemester = srcSemKey !== destSemKey;
  6519	  const srcSemName = currentConfig?.semesters?.[srcSemKey]?.name || srcSemKey;
  6520	  const confirmMsg = isCrossSemester
  6521	    ? `Paste "${proj.projectTitle}" from ${srcSemName} into ${teacher} / ${className} Week ${weekNum}?`
  6522	    : `Paste "${proj.projectTitle}" into ${teacher} / ${className} Week ${weekNum}?`;
  6523	  if (!confirm(confirmMsg)) return;
  6524	
  6525	  const key = makeLessonKey(teacher, className, weekNum);
  6526	  const lessons = { ...(currentLessonData?.[destSemKey] || {}) };
  6527	  const existingDest = lessons[key] || {};
  6528	  const existingDestClassSize = existingDest.classSize || 0;
  6529	  const existingDestPhotoPath = existingDest.photoPath || null;
  6530	
  6531	  lessons[key] = {
  6532	    teacher, className, weekNum, weekDate: '', classSize: existingDestClassSize,
  6533	    projectTitle: proj.projectTitle,
  6534	    shortDetails: proj.shortDetails || '',
  6535	    inspoLink: proj.inspoLink || '',
  6536	    introPitch: proj.introPitch || '',
  6537	    processStep1: proj.processStep1 || '', processStep2: proj.processStep2 || '',
  6538	    processStep3: proj.processStep3 || '', processStep4: proj.processStep4 || '',
  6539	    closure: proj.closure || '',
  6540	    materials: proj.materials || '',
  6541	    materialsList: proj.materialsList || [],
  6542	    dayOfMaterials: proj.dayOfMaterials || '',
  6543	    publishToPrep: proj.publishToPrep || '',
  6544	    lastImported: new Date().toISOString()
  6545	    // Deliberately NOT restored: qaThread, photoUrl/photoPath, planComplete
  6546	    // (tied to the ORIGINAL lesson instance, not reusable project content),
  6547	    // and teacherNotes/adminResponse/status (round-6: getQaThread() would
  6548	    // silently reconstruct the original Q&A conversation from these alone).
  6549	  };
  6550	  // Merely OMITTING those fields above only means "don't touch them" — if the
  6551	  // DESTINATION slot already had its own stale qaThread/photo/planComplete
  6552	  // from whatever occupied it before, that would otherwise survive untouched
  6553	  // and resurrect an unrelated Q&A thread under the newly-pasted content.
  6554	  // Explicitly clear them so a paste genuinely starts fresh.
  6555	  const NON_CONTENT_FIELDS_TO_CLEAR = ['qaThread', 'photoUrl', 'photoPath', 'planComplete', 'teacherNotes', 'adminResponse', 'status'];
  6556	
  6557	  let pasteConfirmed = false;
  6558	  try {
  6559	    await saveSingleLesson(destSemKey, key, lessons[key], NON_CONTENT_FIELDS_TO_CLEAR);
  6560	    pasteConfirmed = true;
  6561	  } catch (err) {
  6562	    console.error('❌ Paste from Cut Bank failed to save the lesson:', err);
  6563	    alert(`Could not paste "${proj.projectTitle}" — please try again.`);
  6564	    return;
  6565	  }
  6566	
  6567	  // Only delete the destination's old photo from Storage after Firestore has
  6568	  // confirmed the clear — same safe ordering as saveAdminEdit()/saveTeacherEdit().
  6569	  if (existingDestPhotoPath) {
  6570	    try {
  6571	      await deleteLessonPhoto(existingDestPhotoPath);
  6572	    } catch (cleanupErr) {
  6573	      console.error('⚠️ Could not clean up destination\'s old photo after paste (Firestore is correct, Storage has an orphan):', cleanupErr);
  6574	    }
  6575	  }
  6576	
  6577	  currentLessonData[destSemKey] = lessons;
  6578	  closeAdminModal();
  6579	  renderAdminGrid();
  6580	
  6970	// saveFutureProjects() (which expects a bare array), double-nesting
  6971	// curriculum/futureProjects and corrupting renderIdeaBank()'s cache — a
  6972	// deterministic, live production bug. Also removed the idea from the bank
  6973	// BEFORE the destination lesson save was confirmed. Rewritten around a
  6974	// targeted saveSingleLesson() write (unrelated lessons in the same semester
  6975	// are no longer touched), explicit fieldsToClear against the destination's
  6976	// own pre-existing stale content — both CONTENT_FIELDS and the
  6977	// instance-specific fields an Idea Bank project never supplies (matching
  6978	// pasteFromCutBank()'s own NON_CONTENT_FIELDS_TO_CLEAR pattern, since simply
  6979	// omitting a field only means "don't touch it," not "clear it") — and
  6980	// lesson-save-then-idea-removal ordering with an honest duplicate-message on
  6981	// a removal failure.
  6982	async function pasteFromIdeaBank(idx, teacher, className, weekNum) {
  6983	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  6984	  if (refuseIfWeeklySemesterPaused(getAdminSemKey())) return;
  6985	  const projects = currentFutureProjects?.projects || [];
  6986	  const proj = projects[idx];
  6987	  if (!proj) return;
  6988	
  6989	  if (!confirm(`Paste "${proj.title}" into ${teacher} / ${className} Week ${weekNum}? The idea will be removed from the bank.`)) return;
  6990	
  6991	  const semKey = getAdminSemKey();
  6992	  const key = makeLessonKey(teacher, className, weekNum);
  6993	  const existingLesson = currentLessonData?.[semKey]?.[key] || {};
  6994	  const existingClassSize = existingLesson.classSize || 0;
  6995	  const existingPhotoPath = existingLesson.photoPath || null;
  6996	  const newLesson = {
  6997	    teacher,
  6998	    className,
  6999	    weekNum,
  7000	    weekDate: '',
  7001	    classSize: existingClassSize,
  7002	    projectTitle: proj.title,
  7003	    shortDetails: proj.description || '',
  7004	    inspoLink: proj.inspoLink || '',
  7005	    introPitch: '',
  7006	    processStep1: '',
  7007	    processStep2: '',
  7008	    processStep3: '',
  7009	    processStep4: '',
  7010	    closure: '',
  7011	    materials: '',
  7012	    dayOfMaterials: '',
  7013	    status: '',
  7014	    publishToPrep: '',
  7015	    teacherNotes: '',
  7016	    adminResponse: '',
  7017	    lastImported: new Date().toISOString()
  7018	  };
  7019	
  7020	  // An idea's blank fields must actually CLEAR stale destination content, not
  7021	  // silently leave it — same pattern used everywhere else in this plan.
  7022	  const fieldsToClear = CONTENT_FIELDS.filter(f =>
  7023	    (existingLesson[f] || '').trim() !== '' && !(newLesson[f] || '').trim()
  7024	  );
  7025	  // Instance-specific fields tied to whatever previously occupied this slot —
  7026	  // an Idea Bank project never supplies these, so newLesson never sets them,
  7027	  // and buildLessonFieldUpdates() only touches fields actually present in the
  7028	  // object it's given. Without an explicit clear, a destination's own stale
  7029	  // Q&A thread, photo, completion flag, or materials list would silently
  7030	  // resurrect under the newly-pasted idea.
  7031	  const NON_CONTENT_FIELDS_TO_CLEAR = ['qaThread', 'photoUrl', 'photoPath', 'planComplete', 'materialsList'];
  7032	
  7033	  try {
  7034	    await saveSingleLesson(semKey, key, newLesson, [...fieldsToClear, ...NON_CONTENT_FIELDS_TO_CLEAR]);
  7035	    if (currentLessonData[semKey]) currentLessonData[semKey][key] = newLesson;
  7036	  } catch (err) {
  7037	    console.error('❌ Paste from Idea Bank failed — lesson could not be saved:', err);
  7038	    alert(`Could not paste "${proj.title}" — please try again. The idea is still in the bank.`);
  7039	    return;
  7040	  }
  7041	
  7042	  // Only delete the destination's old photo from Storage after Firestore has
  7043	  // confirmed the clear — same safe ordering as pasteFromCutBank()/
  7044	  // saveAdminEdit()/saveTeacherEdit().
  7045	  if (existingPhotoPath) {
  7046	    try {
  7047	      await deleteLessonPhoto(existingPhotoPath);
  7048	    } catch (cleanupErr) {
  7049	      console.error('⚠️ Could not clean up destination\'s old photo after paste (Firestore is correct, Storage has an orphan):', cleanupErr);
  7050	    }
  7200	// argument list with the legacy teacherNotes/adminResponse thread on a
  7201	// lesson's FIRST atomic-append reply, so that legacy content isn't silently
  7202	// lost the moment qaThread gets its first real entry. arrayUnion's deep-
  7203	// equality dedup makes repeating this migration from concurrent senders safe.
  7204	function buildQaThreadUnionArgs(existingLesson, newEntry) {
  7205	  const needsMigration = !existingLesson?.qaThread || existingLesson.qaThread.length === 0;
  7206	  return needsMigration ? [...getQaThread(existingLesson || {}), newEntry] : [newEntry];
  7207	}
  7208	
  7209	// Backtracking audit Phase 11 fix: both admin Q&A reply functions used to
  7210	// resave the ENTIRE cached semester via saveLessonData() — a Firestore
  7211	// set({merge:true}) of every lesson currently sitting in this admin's
  7212	// browser, not just the one being replied to. If a teacher's save landed on
  7213	// the server in the split-second before this admin's live listener caught
  7214	// up, that reply would silently revert the teacher's edit back to this
  7215	// admin's stale cached copy — for ANY lesson in the semester, not just the
  7216	// one in the reply. Now a single targeted Firestore .update() touching only
  7217	// this lesson's own field paths, with arrayUnion() for qaThread (survives a
  7218	// genuinely concurrent sender) and an existence check (a stale, long-open
  7219	// popup can't silently recreate a lesson deleted/moved elsewhere).
  7220	async function sendHelpResponse(key) {
  7221	  const input = document.getElementById(`ca-help-input-${key}`);
  7222	  if (!input) return;
  7223	  const response = input.value.trim();
  7224	  if (!response) return;
  7225	
  7226	  const semKey = getAdminSemKey();
  7227	  // Same load guard as every other lesson writer (Phase 1 review): after a
  7228	  // failed reload the listener deliberately KEEPS the previous summer maps, so
  7229	  // the cached lesson and the existence check both still pass — without this
  7230	  // an admin could write a reply while the banner says saving is disabled.
  7231	  if (lessonDataLoadedSuccessfully === false) {
  7232	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  7233	    return;
  7234	  }
  7235	  // A semester type this writer has no branch for is refused here, before the
  7236	  // existence check below — a throw inside that try would be reported to the
  7237	  // admin as "check your connection", which it isn't (Phase 1, 1.1).
  7238	  let lessonStore;
  7239	  try {
  7240	    lessonStore = lessonStoreFor(semKey);
  7241	  } catch (err) {
  7242	    alert(err.message);
  7243	    return;
  7244	  }
  7245	  const cachedExisting = currentLessonData?.[semKey]?.[key];
  7246	  if (!cachedExisting) return;
  7247	
  7248	  let check;
  7249	  try {
  7250	    check = await adminLessonStillExistsWithRetry(semKey, key);
  7251	  } catch (err) {
  7252	    console.warn('⚠️ Existence check retry also failed:', err);
  7253	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  7254	    return;
  7255	  }
  7256	  if (!check.exists) {
  7257	    alert('This lesson was moved or removed elsewhere. Your response was not sent — please close this and check the grid for its new location.');
  7258	    return;
  7259	  }
  7260	  const existing = check.data || cachedExisting;
  7261	
  7262	  const user = getAuthUser();
  7263	  const newEntry = {
  7264	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  7265	    from: 'admin', name: user?.name || 'Admin', message: response, timestamp: new Date().toISOString()
  7266	  };
  7267	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7268	
  7269	  if (!curriculumDb) initCurriculumFirestore();
  7270	  const isSummer = lessonStore === 'camp';
  7271	  const updates = {};
  7272	  let weekly = null;
  7273	  if (!isSummer) {
  7274	    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
  7275	  }
  7276	  if (isSummer) {
  7277	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7278	    updates.adminResponse = response;
  7279	    updates.status = 'In Progress';
  7280	    updates.lastUpdated = new Date().toISOString();
  7281	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7282	  } else {
  7283	    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7284	    updates[`${weekly.prefix}${key}.adminResponse`] = response;
  7285	    updates[`${weekly.prefix}${key}.status`] = 'In Progress';
  7286	    updates.lastUpdated = new Date().toISOString();
  7287	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7288	  }
  7289	  const docRef = isSummer
  7290	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7291	    : weekly.ref;
  7292	
  7293	  try {
  7294	    await docRef.update(updates);
  7295	  } catch (err) {
  7296	    console.error('Error sending help response:', err);
  7297	    alert('Error sending response: ' + err.message);
  7298	    return;
  7299	  }
  7300	
  7301	  currentLessonData[semKey][key] = {
  7302	    ...existing, adminResponse: response,
  7303	    qaThread: [...(existing.qaThread && existing.qaThread.length > 0 ? existing.qaThread : getQaThread(existing)), newEntry],
  7304	    status: 'In Progress'
  7305	  };
  7306	  renderHelpQueue();
  7307	}
  7308	
  7309	async function sendQaReply(key) {
  7310	  const input = document.getElementById(`qa-reply-${key}`);
  7311	  if (!input) return;
  7312	  const message = input.value.trim();
  7313	  if (!message) return;
  7314	
  7315	  const semKey = getAdminSemKey();
  7316	  // Same load guard as every other lesson writer (Phase 1 review): after a
  7317	  // failed reload the listener deliberately KEEPS the previous summer maps, so
  7318	  // the cached lesson and the existence check both still pass — without this
  7319	  // an admin could write a reply while the banner says saving is disabled.
  7320	  if (lessonDataLoadedSuccessfully === false) {
  7321	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  7322	    return;
  7323	  }
  7324	  // A semester type this writer has no branch for is refused here, before the
  7325	  // existence check below — a throw inside that try would be reported to the
  7326	  // admin as "check your connection", which it isn't (Phase 1, 1.1).
  7327	  let lessonStore;
  7328	  try {
  7329	    lessonStore = lessonStoreFor(semKey);
  7330	  } catch (err) {
  7331	    alert(err.message);
  7332	    return;
  7333	  }
  7334	  const cachedExisting = currentLessonData?.[semKey]?.[key];
  7335	  if (!cachedExisting) return;
  7336	
  7337	  let check;
  7338	  try {
  7339	    check = await adminLessonStillExistsWithRetry(semKey, key);
  7340	  } catch (err) {
  7341	    console.warn('⚠️ Existence check retry also failed:', err);
  7342	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  7343	    return;
  7344	  }
  7345	  if (!check.exists) {
  7346	    alert('This lesson was moved or removed elsewhere. Your reply was not sent — please close this window and check the grid for its new location.');
  7347	    return;
  7348	  }
  7349	  const existing = check.data || cachedExisting;
  7350	
  7351	  const user = getAuthUser();
  7352	  const newEntry = {
  7353	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  7354	    from: 'admin', name: user?.name || 'Admin', message, timestamp: new Date().toISOString()
  7355	  };
  7356	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7357	
  7358	  if (!curriculumDb) initCurriculumFirestore();
  7359	  const isSummer = lessonStore === 'camp';
  7360	  const updates = {};
  7361	  let weekly = null;
  7362	  if (!isSummer) {
  7363	    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
  7364	  }
  7365	  if (isSummer) {
  7366	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7367	    updates.adminResponse = message;
  7368	    updates.lastUpdated = new Date().toISOString();
  7369	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7370	  } else {
  7371	    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7372	    updates[`${weekly.prefix}${key}.adminResponse`] = message;
  7373	    updates.lastUpdated = new Date().toISOString();
  7374	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7375	  }
  7376	  const docRef = isSummer
  7377	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7378	    : weekly.ref;
  7379	
  7380	  try {

exec
/bin/zsh -lc "rg -n \"workers|fullyParallel\" playwright.config.* && nl -ba e2e/spring-own-doc.spec.js | sed -n '1,310p' && nl -ba /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js | sed -n '1,150p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
22:  workers: 1,
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
    23	// Suite-global state: these tests rewrite curriculum/lessonData, lessons_spring-2026
    24	// and storageMigrations, so every test starts from AND ends at the seeded state.
    25	test.beforeEach(async () => { await SM.resetStorageMove(); });
    26	test.afterEach(async () => { await SM.resetStorageMove(); });
    27	
    28	async function openApp(page) {
    29	  await login(page);
    30	  await page.waitForFunction(() => lessonDataLoadedSuccessfully === true
    31	    && currentLessonData && currentLessonData['spring-2026']
    32	    && Object.keys(currentLessonData['spring-2026']).length > 0, null, { timeout: 25_000 });
    33	}
    34	const springKeys = (page) => page.evaluate(() => Object.keys(currentLessonData?.['spring-2026'] || {}).filter(k => !k.startsWith('last')).sort());
    35	const source = (page) => page.evaluate(() => ownDocSource['spring-2026']);
    36	const call = (page, fnSrc, arg) => page.evaluate(async ({ fnSrc, arg }) => {
    37	  try { await (0, eval)(`(${fnSrc})`)(arg); return 'ok'; } catch (e) { return e.message; }
    38	}, { fnSrc: fnSrc.toString(), arg });
    39	// Records the smallest Spring lesson count seen, every 25 ms, from now on.
    40	const watchMinSpring = (page) => page.evaluate(() => {
    41	  window.__minSpring = Infinity;
    42	  window.__springWatch = setInterval(() => {
    43	    const n = Object.keys(currentLessonData?.['spring-2026'] || {}).length;
    44	    if (n < window.__minSpring) window.__minSpring = n;
    45	  }, 25);
    46	});
    47	const minSpring = (page) => page.evaluate(() => { clearInterval(window.__springWatch); return window.__minSpring; });
    48	
    49	const fixtureKeys = () => Object.keys(SM.springFixture()).sort();
    50	
    51	test.describe('Spring 2026 storage move — Phase B', () => {
    52	
    53	  test('before the move: Spring is viewable, every Spring write is paused, other semesters save', async ({ page }) => {
    54	    await openApp(page);
    55	    expect(await source(page)).toBe('legacy');
    56	    expect(await springKeys(page)).toEqual(fixtureKeys());
    57	
    58	    expect(await call(page, ({ LESSON }) => saveSingleLesson('spring-2026', LESSON, { shortDetails: 'E2E' }), { LESSON })).toMatch(PAUSED);
    59	    expect(await call(page, ({ LESSON }) => saveMultipleLessonFields('spring-2026', [{ lessonKey: LESSON, lessonData: { shortDetails: 'E2E' } }]), { LESSON })).toMatch(PAUSED);
    60	    expect(await call(page, ({ LESSON }) => deleteLessonKey('spring-2026', LESSON), { LESSON })).toMatch(PAUSED);
    61	    expect(await call(page, () => saveLessonData('spring-2026', {}))).toMatch(PAUSED);
    62	
    63	    const ld = await SM.readCurriculumDoc('lessonData');
    64	    expect(ld['spring-2026']).toEqual(SM.springFixture());
    65	
    66	    // Fall still saves to lessonData, exactly as before.
    67	    expect(await call(page, () => saveSingleLesson('fall-2026', 'e2e-lesson', { shortDetails: 'Fall' }))).toBe('ok');
    68	    expect((await SM.readCurriculumDoc('lessonData'))['fall-2026']['e2e-lesson'].shortDetails).toBe('Fall');
    69	  });
    70	
    71	  test('moved but not yet verified: Spring shows from its own doc; edits are still paused', async ({ page }) => {
    72	    await SM.stageMoved({ verified: false });
    73	    await openApp(page);
    74	    expect(await source(page)).toBe('ownDoc');
    75	    expect(await springKeys(page)).toEqual(fixtureKeys());
    76	    expect(await call(page, ({ LESSON }) => saveSingleLesson('spring-2026', LESSON, { shortDetails: 'E2E' }), { LESSON })).toMatch(PAUSED);
    77	    expect((await SM.readCurriculumDoc(SM.SPRING_DOC))[LESSON]).toEqual(SM.springFixture()[LESSON]);
    78	  });
    79	
    80	  test('moved and verified: every Spring write lands in its own doc at lessonKey paths; lessonData untouched', async ({ page }) => {
    81	    await SM.stageMoved({ verified: true });
    82	    await openApp(page);
    83	    await page.waitForFunction(() => storageMigrationState?.['spring-2026']?.verified === true);
    84	    const before = await SM.readCurriculumDoc('lessonData');
    85	
    86	    expect(await call(page, ({ LESSON }) => saveSingleLesson('spring-2026', LESSON, { shortDetails: 'Saved to own doc' }), { LESSON })).toBe('ok');
    87	    expect(await call(page, ({ LESSON }) => saveMultipleLessonFields('spring-2026', [{ lessonKey: LESSON, lessonData: { processStep1: 'Step' } }]), { LESSON })).toBe('ok');
    88	    const own = await SM.readCurriculumDoc(SM.SPRING_DOC);
    89	    expect(own[LESSON].shortDetails).toBe('Saved to own doc');
    90	    expect(own[LESSON].processStep1).toBe('Step');
    91	    expect(own[LESSON].teacher).toBe(SM.springFixture()[LESSON].teacher);   // a per-field write, not a replace
    92	
    93	    const readBack = await page.evaluate(({ LESSON }) => readAdminLessonDoc('spring-2026', LESSON, { source: 'server' }), { LESSON });
    94	    expect(readBack.shortDetails).toBe('Saved to own doc');
    95	
    96	    const other = fixtureKeys().find(k => k !== LESSON);
    97	    expect(await call(page, ({ other }) => deleteLessonKey('spring-2026', other), { other })).toBe('ok');
    98	    expect((await SM.readCurriculumDoc(SM.SPRING_DOC))[other]).toBeUndefined();
    99	
   100	    const after = await SM.readCurriculumDoc('lessonData');
   101	    expect(after['spring-2026']).toBeUndefined();
   102	    expect(after).toEqual(before);
   103	  });
   104	
   105	  test('the move happening while a tab is open: Spring switches to its own doc and is never blank', async ({ page }) => {
   106	    await openApp(page);
   107	    expect(await source(page)).toBe('legacy');
   108	    await watchMinSpring(page);
   109	    await SM.stageMoved({ verified: true });
   110	    await page.waitForFunction(() => ownDocSource['spring-2026'] === 'ownDoc', null, { timeout: 15_000 });
   111	    await page.waitForTimeout(500);
   112	    expect(await minSpring(page)).toBe(fixtureKeys().length);
   113	    expect(await springKeys(page)).toEqual(fixtureKeys());
   114	    expect(await page.locator('#storage-notice-banner:not(.hidden)').count()).toBe(0);
   115	  });
   116	
   117	  test('a later lessonData snapshot (another semester saved) does not blank Spring', async ({ page }) => {
   118	    await SM.stageMoved({ verified: true });
   119	    await openApp(page);
   120	    await watchMinSpring(page);
   121	    await SM.writeCurriculumDoc('lessonData', { 'e2e-bump': { x: { teacher: 'T' } } }, { merge: true });
   122	    await page.waitForFunction(() => !!currentLessonData?.['e2e-bump'], null, { timeout: 15_000 });
   123	    await page.waitForTimeout(300);
   124	    expect(await minSpring(page)).toBe(fixtureKeys().length);
   125	    expect(await springKeys(page)).toEqual(fixtureKeys());
   126	  });
   127	
   128	  test('a rollback (own doc removed, Spring back in lessonData) falls back without blanking', async ({ page }) => {
   129	    await SM.stageMoved({ verified: false });
   130	    await openApp(page);
   131	    expect(await source(page)).toBe('ownDoc');
   132	    await watchMinSpring(page);
   133	    await SM.writeCurriculumDoc('lessonData', { 'spring-2026': SM.springFixture() }, { merge: true });
   134	    await SM.deleteCurriculumDoc(SM.SPRING_DOC);
   135	    await page.waitForFunction(() => ownDocSource['spring-2026'] === 'legacy', null, { timeout: 15_000 });
   136	    await page.waitForTimeout(500);
   137	    expect(await minSpring(page)).toBe(fixtureKeys().length);
   138	    expect(await springKeys(page)).toEqual(fixtureKeys());
   139	  });
   140	
   141	  test('deleting Spring 2026 is refused while its storage is changing', async ({ page }) => {
   142	    await openApp(page);
   143	    const alerts = [];
   144	    page.on('dialog', d => { alerts.push(d.message()); d.dismiss(); });
   145	    const before = await SM.readCurriculumDoc('appData');
   146	    await page.evaluate(() => deleteSemester('spring-2026'));
   147	    expect(alerts.join('\n')).toMatch(/can't be deleted while its storage is being changed/);
   148	    expect((await SM.readCurriculumDoc('appData')).semesters['spring-2026']).toEqual(before.semesters['spring-2026']);
   149	  });
   150	
   151	  test('content counts: one source per semester — the same before and after the move', async ({ page }) => {
   152	    await openApp(page);
   153	    const legacyCounts = await page.evaluate(() => computeLiveContentCountByTeacher());
   154	    await SM.stageMoved({ verified: true });
   155	    const movedCounts = await page.evaluate(() => computeLiveContentCountByTeacher());
   156	    expect(movedCounts).toEqual(legacyCounts);
   157	  });
   158	
   159	  test('Lesson Storage readout shows an approximate size of 1,024 KB', async ({ page }) => {
   160	    await openApp(page);
   161	    await page.evaluate(() => { document.getElementById('ca-lesson-storage-content').style.display = 'none'; toggleLessonStorage(); });
   162	    await expect(page.locator('#ca-lesson-storage-content')).toContainText(/approx\. \d+ KB of 1,024 KB \(\d+%\)/);
   163	    await expect(page.locator('#ca-lesson-storage-content')).toContainText('spring-2026: still in the shared document');
   164	    const kb = await page.evaluate(() => approxLessonDataSizeKB());
   165	    expect(kb).toBeGreaterThan(0);
   166	    expect(kb).toBeLessThan(1024);
   167	  });
   168	
   169	  test('ratchet: every curriculum/lessonData access is in an allowed function; every weekly writer routes through weeklyLessonTarget', () => {
   170	    const html = fs.readFileSync(path.join(__dirname, '..', 'index.html'), 'utf8');
   171	    const scripts = [...html.matchAll(/<script[^>]+src="(js\/[^"]+)"/g)].map(m => m[1]);
   172	    const ALLOWED = new Set([
   173	      'weeklyLessonTarget',          // the routing helper itself (legacy branch)
   174	      'readWeeklySemesterMap',       // reads, routed
   175	      'loadLessonData',              // the legacy load
   176	      'saveLessonData',              // legacy branch; own-doc semesters route above it
   177	      'deleteLessonData',            // refuses own-doc semesters first
   178	      'setupLessonDataListener',     // the legacy listener
   179	      'computeLiveContentCountByTeacher', // counts, one source per semester
   180	    ]);
   181	    const offenders = [];
   182	    const bodies = {};
   183	    for (const file of scripts) {
   184	      const lines = fs.readFileSync(path.join(__dirname, '..', file), 'utf8').split('\n');
   185	      let current = null;
   186	      lines.forEach((line, i) => {
   187	        const m = line.match(/^(?:async\s+)?function\s+([A-Za-z0-9_$]+)\s*\(/);
   188	        if (m) current = m[1];
   189	        if (current) bodies[current] = (bodies[current] || '') + line + '\n';
   190	        if (/doc\(\s*['"]lessonData['"]\s*\)/.test(line) && !ALLOWED.has(current)) offenders.push(`${file}:${i + 1} in ${current}`);
   191	      });
   192	    }
   193	    expect(offenders, `curriculum/lessonData touched outside the allowed functions:\n${offenders.join('\n')}`).toEqual([]);
   194	    for (const fn of ['saveSingleLesson', 'saveMultipleLessonFields', 'deleteLessonKey', 'sendTeacherQaMessage', 'sendHelpResponse', 'sendQaReply']) {
   195	      expect(bodies[fn], `${fn} not found`).toBeTruthy();
   196	      expect(bodies[fn], `${fn} must route through weeklyLessonTarget`).toMatch(/weeklyLessonTarget\(/);
   197	    }
   198	    expect(bodies.saveLessonData).toMatch(/isOwnDocSemester\(semesterKey\)[\s\S]*weeklyLessonTarget\(/);
   199	    expect(bodies.deleteLessonData).toMatch(/isOwnDocSemester\(semesterKey\)/);
   200	  });
   201	
   202	  test('while paused, every Spring workflow refuses up front with the pause message and changes nothing', async ({ page }) => {
   203	    await openApp(page);
   204	    await page.evaluate(() => setGlobalSemester('spring-2026'));
   205	    const alerts = [];
   206	    page.on('dialog', d => { alerts.push(d.message()); d.accept(); });
   207	    const docs = ['lessonData', 'cutProjects', 'appData', 'futureProjects', 'changeLog'];
   208	    const before = {};
   209	    for (const d of docs) before[d] = await SM.readCurriculumDoc(d);
   210	    const uploads = await page.evaluate(() => { window.__uploads = 0; const orig = window.uploadLessonPhoto; if (orig) window.uploadLessonPhoto = (...a) => { window.__uploads++; return orig(...a); }; return !!orig; });
   211	
   212	    const workflows = {
   213	      cutProject: ({ LESSON }) => cutProject(LESSON),
   214	      executeCopyPlan: ({ LESSON }) => executeCopyPlan(LESSON),
   215	      pasteFromCutBank: () => pasteFromCutBank(0, 'Fixture Teacher', 'Fixture Class', 9),
   216	      pasteFromIdeaBank: () => pasteFromIdeaBank(0, 'Fixture Teacher', 'Fixture Class', 9),
   217	      handleGridAction: () => handleGridAction('Fixture Teacher', 'Fixture Class', 9, 'x'),
   218	      saveSettings: () => { loadSettingsForm(); return saveSettings(); },
   219	    };
   220	    for (const [name, fn] of Object.entries(workflows)) {
   221	      alerts.length = 0;
   222	      expect(await call(page, fn, { LESSON }), name).toBe('ok');
   223	      expect(alerts.join(' | '), `${name} should say editing is paused`).toMatch(PAUSED);
   224	    }
   225	    for (const d of docs) expect(await SM.readCurriculumDoc(d), `${d} must be unchanged`).toEqual(before[d]);
   226	    if (uploads) expect(await page.evaluate(() => window.__uploads)).toBe(0);
   227	  });
   228	
   229	  test('a standing notice shows while Spring is paused, and goes away elsewhere or once verified', async ({ page }) => {
   230	    await openApp(page);
   231	    await page.evaluate(() => setGlobalSemester('spring-2026'));
   232	    await expect(page.locator('#own-doc-paused-notice')).toBeVisible();
   233	    await expect(page.locator('#own-doc-paused-notice')).toContainText('editing it is paused');
   234	    await page.evaluate(() => setGlobalSemester('summer-2026'));
   235	    await expect(page.locator('#own-doc-paused-notice')).toBeHidden();
   236	    await page.evaluate(() => setGlobalSemester('spring-2026'));
   237	    await SM.stageMoved({ verified: true });
   238	    await page.waitForFunction(() => ownDocSource['spring-2026'] === 'ownDoc' && storageMigrationState?.['spring-2026']?.verified === true, null, { timeout: 15_000 });
   239	    await expect(page.locator('#own-doc-paused-notice')).toBeHidden();
   240	  });
   241	
   242	  test('a superseded recheck (a newer snapshot arrived meanwhile) applies nothing', async ({ page }) => {
   243	    await openApp(page);   // legacy state: no own doc
   244	    const superseded = await page.evaluate(async () => {
   245	      const t = bumpOwnDocToken('spring-2026');
   246	      const p = recheckOwnDocAfterLegacyLoss('spring-2026', null, t);
   247	      bumpOwnDocToken('spring-2026');          // a newer snapshot spoke first
   248	      await p;
   249	      const el = document.getElementById('storage-notice-banner');
   250	      return { shown: !!el && !el.classList.contains('hidden'), source: ownDocSource['spring-2026'] };
   251	    });
   252	    expect(superseded).toEqual({ shown: false, source: 'legacy' });
   253	    const current = await page.evaluate(async () => {
   254	      const t = bumpOwnDocToken('spring-2026');
   255	      await recheckOwnDocAfterLegacyLoss('spring-2026', null, t);   // nothing newer: it reports
   256	      const el = document.getElementById('storage-notice-banner');
   257	      return !!el && !el.classList.contains('hidden');
   258	    });
   259	    expect(current).toBe(true);
   260	  });
   261	
   262	  test('ratchet: each Spring workflow checks the pause before its first change', () => {
   263	    const src = fs.readFileSync(path.join(__dirname, '..', 'js', 'app.js'), 'utf8');
   264	    const body = (name) => {
   265	      const start = src.indexOf(`function ${name}(`);
   266	      expect(start, `${name} not found`).toBeGreaterThan(-1);
   267	      return src.slice(start, src.indexOf('\n}\n', start));
   268	    };
   269	    for (const name of ['saveAdminEdit', 'executeCopyPlan', 'pasteFromCutBank', 'pasteFromIdeaBank', 'handleGridAction', 'cutProject', 'saveSettings', 'saveTeacherEdit']) {
   270	      const b = body(name);
   271	      const guard = b.indexOf('refuseIfWeeklySemesterPaused(');
   272	      expect(guard, `${name} must call refuseIfWeeklySemesterPaused`).toBeGreaterThan(-1);
   273	      const firstAwait = b.search(/\bawait\b/);
   274	      expect(firstAwait === -1 || guard < firstAwait, `${name}: the pause check must come before the first await`).toBe(true);
   275	    }
   276	    const cards = body('attachCardListeners');
   277	    expect(cards.indexOf('refuseIfWeeklySemesterPaused(')).toBeGreaterThan(-1);
   278	    expect(cards.indexOf('refuseIfWeeklySemesterPaused(')).toBeLessThan(cards.indexOf('{ planComplete: cb.checked }'));
   279	  });
   280	});
     1	/**
     2	 * Runs the REAL js/alerts.js (AlertEngine) in a vm with a fake Firestore that lets
     3	 * the test fire each document listener by hand — the Classbook Q&A wiring only
     4	 * (union of lessonData + lessons_<semKey>, dismissal migration, listener errors).
     5	 * No emulator, no DOM (a no-op element proxy stands in for the UI).
     6	 * Run: npm test
     7	 */
     8	const vm = require('vm');
     9	const fs = require('fs');
    10	
    11	function loadEngine({ dismissed = [] } = {}) {
    12	  const el = () => new Proxy(function () {}, {
    13	    get: (t, k) => (k === 'classList' ? { add() {}, remove() {}, toggle() {}, contains() { return false; } }
    14	      : k === 'style' ? {} : k === 'children' ? [] : k === 'querySelectorAll' ? () => [] : el()),
    15	    set: () => true,
    16	    apply: () => el(),
    17	  });
    18	  const handlers = {};
    19	  const noopQuery = () => ({ onSnapshot: () => () => {}, where: noopQuery, orderBy: noopQuery, limit: noopQuery });
    20	  const db = {
    21	    collection: (c) => ({
    22	      doc: (d) => ({
    23	        onSnapshot: (next, error) => { handlers[`${c}/${d}`] = { next, error }; return () => {}; },
    24	        get: async () => ({ exists: false, data: () => ({}) }),
    25	        set: async () => {},
    26	        update: async () => {},
    27	      }),
    28	      where: noopQuery, orderBy: noopQuery, onSnapshot: () => () => {},
    29	    }),
    30	  };
    31	  const store = { studioHub_dismissedAlerts: JSON.stringify(dismissed) };
    32	  const ctx = {
    33	    console: { ...console, error: () => {}, warn: () => {}, log: () => {} },
    34	    Date, Set, Map, JSON, Math, Promise, setTimeout, clearTimeout, setInterval, clearInterval,
    35	    document: { getElementById: () => el(), querySelector: () => el(), querySelectorAll: () => [], createElement: () => el(), addEventListener() {} },
    36	    localStorage: { getItem: (k) => store[k] ?? null, setItem: (k, v) => { store[k] = v; } },
    37	    window: {},
    38	    firebase: { firestore: { FieldValue: { serverTimestamp: () => 0, arrayUnion: (...a) => a } } },
    39	  };
    40	  vm.createContext(ctx);
    41	  vm.runInContext(fs.readFileSync('js/classbook-qa-alerts.js', 'utf8'), ctx);
    42	  vm.runInContext(fs.readFileSync('js/alerts.js', 'utf8') + '\nthis.AlertEngine = AlertEngine;', ctx);
    43	  const snap = (data) => ({ exists: data !== null, data: () => data });
    44	  return {
    45	    engine: ctx.AlertEngine,
    46	    db,
    47	    fire: (docPath, data) => handlers[docPath].next(snap(data)),
    48	    fail: (docPath) => handlers[docPath].error(new Error('permission-denied')),
    49	    ids: () => ctx.AlertEngine.getAlerts().filter((a) => a.type === 'curriculum').map((a) => a.id).sort(),
    50	    dismissedIds: () => JSON.parse(store.studioHub_dismissedAlerts || '[]'),
    51	  };
    52	}
    53	
    54	const q = (message) => ({ teacher: 'T', qaThread: [{ from: 'teacher', message, timestamp: new Date().toISOString() }] });
    55	const LD = 'curriculum/lessonData';
    56	const SPRING = 'curriculum/lessons_spring-2026';
    57	
    58	describe('AlertEngine — Classbook Q&A across lessonData and own documents', () => {
    59	  test('nothing until every watched document has reported; then both semesters', async () => {
    60	    const h = loadEngine();
    61	    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
    62	    h.fire(LD, { 'fall-2026': { 'f-1': q('fall') }, lastUpdated: 'x' });
    63	    expect(h.ids()).toEqual([]);
    64	    h.fire(SPRING, { 's-1': q('spring'), lastUpdated: 'x' });
    65	    expect(h.ids()).toEqual(['classbook-qa-fall-2026-f-1', 'classbook-qa-spring-2026-s-1']);
    66	  });
    67	
    68	  test("one document's snapshot never removes the other's alerts", async () => {
    69	    const h = loadEngine();
    70	    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
    71	    h.fire(LD, { 'fall-2026': { 'f-1': q('fall') } });
    72	    h.fire(SPRING, { 's-1': q('spring') });
    73	    h.fire(LD, { 'fall-2026': {} });                 // Fall answered
    74	    expect(h.ids()).toEqual(['classbook-qa-spring-2026-s-1']);
    75	    h.fire(SPRING, { 's-1': { qaThread: [{ from: 'teacher', message: 'q' }, { from: 'admin', message: 'a' }] } });
    76	    expect(h.ids()).toEqual([]);
    77	  });
    78	
    79	  test('an own-document listener error keeps its last good alerts', async () => {
    80	    const h = loadEngine();
    81	    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
    82	    h.fire(LD, { 'fall-2026': {} });
    83	    h.fire(SPRING, { 's-1': q('spring') });
    84	    h.fail(SPRING);
    85	    h.fire(LD, { 'fall-2026': { 'f-2': q('new fall') } });
    86	    expect(h.ids()).toEqual(['classbook-qa-fall-2026-f-2', 'classbook-qa-spring-2026-s-1']);
    87	  });
    88	
    89	  test('an own-document error before its first snapshot still lets the others alert', async () => {
    90	    const h = loadEngine();
    91	    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
    92	    h.fire(LD, { 'fall-2026': { 'f-1': q('fall') } });
    93	    h.fail(SPRING);
    94	    expect(h.ids()).toEqual(['classbook-qa-fall-2026-f-1']);
    95	  });
    96	
    97	  test('old-format dismissals migrate once, then are retired (no future question is hidden)', async () => {
    98	    const h = loadEngine({ dismissed: ['classbook-qa-k-1', 'classbook-qa-k-9'] });
    99	    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
   100	    h.fire(LD, { 'fall-2026': { 'k-1': q('fall, dismissed before') } });
   101	    h.fire(SPRING, { 'k-1': q('spring, same key, dismissed before') });
   102	    expect(h.ids()).toEqual([]);                       // both still dismissed
   103	    const d = h.dismissedIds();
   104	    expect(d).toEqual(expect.arrayContaining(['classbook-qa-fall-2026-k-1', 'classbook-qa-spring-2026-k-1', 'classbook-qa-dismissals-migrated-v2']));
   105	    expect(d).not.toContain('classbook-qa-k-1');       // retired
   106	    // A later question on a key whose old dismissal wasn't open at migration time is NOT hidden.
   107	    h.fire(LD, { 'fall-2026': { 'k-1': q('fall'), 'k-9': q('brand new question') } });
   108	    expect(h.ids()).toEqual(['classbook-qa-fall-2026-k-9']);
   109	  });
   110	
   111	  test('after migration, an old id added back by an old tab has no effect', async () => {
   112	    const h = loadEngine({ dismissed: ['classbook-qa-dismissals-migrated-v2', 'classbook-qa-k-1'] });
   113	    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
   114	    h.fire(LD, { 'fall-2026': { 'k-1': q('open') } });
   115	    h.fire(SPRING, null);
   116	    expect(h.ids()).toEqual(['classbook-qa-fall-2026-k-1']);
   117	  });
   118	});

exec
/bin/zsh -lc "nl -ba js/firebase-data.js | sed -n '880,990p;1310,1460p' && nl -ba js/app.js | sed -n '3660,3765p;5620,5865p;6220,6425p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
   880	    .filter(isCampSeason)
   881	    .map(semKey => {
   882	      const season = seasonForSemester(semKey);
   883	      if (seasonRegistryMode === 'legacy') {
   884	        return season === LEGACY_SEASON ? { semKey, season: null } : { semKey, season, unavailable: true };
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
   961	      const plans = campSeasonLoadPlan();
   962	      console.log('📚 Loading camp seasons:', plans.map(p => `${p.semKey}${p.season ? ` (${p.season})` : ' (unfiltered)'}`).join(', ') || 'none');
   963	      for (const plan of plans) {
   964	        currentLessonData[plan.semKey] = await loadOneCampSeason(plan);
   965	        console.log(`📚 ${plan.semKey}: ${Object.keys(currentLessonData[plan.semKey]).length} lessons`);
   966	      }
   967	      // School Day Off Camps years: their own three collections. A failure
   968	      // trips the same app-wide guard — loud, never a quiet empty list.
   969	      for (const yearKey of dayOffYearKeys()) {
   970	        currentLessonData[yearKey] = await loadDayOffCampData({ yearKey });
   971	        console.log(`📚 ${yearKey}: ${Object.keys(currentLessonData[yearKey]).length} day-off camp plans`);
   972	      }
   973	      lessonDataLoadedSuccessfully = true;
   974	    } catch (err) {
   975	      // One season failing trips the guard for the whole app: a partially
   976	      // loaded model is not a safe base for any writer, in any semester.
   977	      console.error('❌ Could not load camp season data:', err);
   978	      lessonDataLoadedSuccessfully = false;
   979	    }
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
  1428	    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; }));
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
  3660	    if (err?.message === OWN_DOC_PAUSED_MESSAGE) alert(OWN_DOC_PAUSED_MESSAGE);
  3661	  }
  3662	}
  3663	
  3664	// Backtracking audit Phase 10 (R3-3, R4-5): this used to rebuild the whole
  3665	// Q&A thread from the modal's lesson object and hand the ENTIRE lesson to
  3666	// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
  3667	// silently dropped any message (or any other field) another client had
  3668	// landed since this modal opened. Now a single targeted .update() touching
  3669	// only this lesson's own Q&A paths, with arrayUnion() for the thread — the
  3670	// same atomic-append design sendHelpResponse()/sendQaReply() already use —
  3671	// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
  3672	// record. `modalSemKey` is the semester the modal was opened under: the
  3673	// global selector can change while the modal stays open, and a dotted-path
  3674	// update under the wrong semester would create a Q&A-only ghost lesson there.
  3675	async function sendTeacherQaMessage(lessonKey, modalSemKey) {
  3676	  const input = document.getElementById('te-qa-input');
  3677	  if (!input) return;
  3678	  const message = input.value.trim();
  3679	  if (!message) return;
  3680	  // Same load-guard saveSingleLesson() enforced on the old path — after a
  3681	  // failed load the cache is empty, so the legacy-thread migration below
  3682	  // would run blind against whatever is really on the server.
  3683	  if (lessonDataLoadedSuccessfully === false) {
  3684	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  3685	    return;
  3686	  }
  3687	
  3688	  const semKey = modalSemKey || getTvSemKey();
  3689	  // This modal never hosts a camp season (the Today View routes those to the
  3690	  // summer editor, whose Q&A lives in summerCamps_prepHelpQueue), so a write
  3691	  // under that key into curriculum/lessonData is never right. Routed by TYPE
  3692	  // now (Phase 1, 1.1) — a third type is refused out loud rather than written
  3693	  // into the shared weekly document.
  3694	  let lessonStore;
  3695	  try {
  3696	    lessonStore = lessonStoreFor(semKey);
  3697	  } catch (err) {
  3698	    alert(err.message);
  3699	    return;
  3700	  }
  3701	  if (lessonStore === 'camp') {
  3702	    alert('Summer camp questions are sent from the camp lesson editor.');
  3703	    return;
  3704	  }
  3705	
  3706	  // Confirm the lesson still exists on the server (an admin may have moved or
  3707	  // deleted it since this modal opened). A dotted-path update would otherwise
  3708	  // recreate the old key as a Q&A-only ghost lesson. Same forced read and
  3709	  // accepted check-to-write residual as sendHelpResponse()/sendQaReply().
  3710	  let check;
  3711	  try {
  3712	    check = await adminLessonStillExistsWithRetry(semKey, lessonKey);
  3713	  } catch (err) {
  3714	    console.warn('⚠️ Existence check retry also failed:', err);
  3715	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  3716	    return;
  3717	  }
  3718	  if (!check.exists) {
  3719	    alert('This lesson was moved or removed elsewhere. Your message was not sent — please close this and check the classbook for its new location.');
  3720	    return;
  3721	  }
  3722	  const existing = check.data;
  3723	
  3724	  const user = getAuthUser();
  3725	  const isAdmin = ['admin', 'manager'].includes(user?.role);
  3726	  const newEntry = {
  3727	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  3728	    from: isAdmin ? 'admin' : 'teacher',
  3729	    name: user?.name || 'Unknown',
  3730	    message,
  3731	    timestamp: new Date().toISOString()
  3732	  };
  3733	  // The fresh server copy decides whether a legacy teacherNotes/adminResponse
  3734	  // thread still needs migrating into qaThread on this lesson's first entry.
  3735	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  3736	  const editedAt = new Date().toISOString();
  3737	  const editedBy = user?.name || 'Unknown';
  3738	
  3739	  let target;
  3740	  try {
  3741	    target = weeklyLessonTarget(semKey);   // own-doc semester: its own doc, or "editing is paused"
  3742	  } catch (err) {
  3743	    alert(err.message);
  3744	    return;
  3745	  }
  3746	  const p = `${target.prefix}${lessonKey}`;
  3747	  const updates = {
  3748	    [`${p}.qaThread`]: firebase.firestore.FieldValue.arrayUnion(...entriesToAdd),
  3749	    [`${p}.lastEditedBy`]: editedBy,
  3750	    [`${p}.lastEditedAt`]: editedAt,
  3751	  };
  3752	  // Legacy mirror fields, kept for compatibility with older readers.
  3753	  const legacyField = isAdmin ? 'adminResponse' : 'teacherNotes';
  3754	  updates[`${p}.${legacyField}`] = message;
  3755	
  3756	  try {
  3757	    await target.ref.update(updates);
  3758	  } catch (err) {
  3759	    console.error('Error sending Q&A message:', err);
  3760	    alert('Error sending message: ' + err.message);
  3761	    return;
  3762	  }
  3763	
  3764	  // Confirmed — make sure the local cache shows the new message before the
  3765	  // live listener catches up. Usually the listener already HAS: a local
  5620	// change). The cached `existing` lesson is never spread into the payload, so
  5621	// a stale qaThread / photo / untouched content field can't overwrite another
  5622	// client's newer copy. Intentional clears travel as fieldsToClear. Before
  5623	// anything is written, a forced-server read confirms the lesson still exists
  5624	// (moved/deleted elsewhere while the popup was open → refuse, don't recreate
  5625	// a ghost). Residual check-to-write TOCTOU gap accepted per the plan.
  5626	async function saveAdminEdit(key, teacher, className, weekNum) {
  5627	  if (caEditSaveInFlight) return;
  5628	  const title = document.getElementById('ca-edit-title')?.value.trim();
  5629	  // (closeAdminModal() refuses non-forced closes while caEditSaveInFlight is
  5630	  // set — Cancel / × / overlay are effectively disabled for the duration.)
  5631	  if (!title) { alert('Project title is required.'); return; }
  5632	
  5633	  // Backtracking audit, Phase 1: check the guard BEFORE any Storage mutation
  5634	  // (and, now, before the existence check) so a known-bad load state never
  5635	  // gets as far as a server read, an upload, or a delete.
  5636	  if (lessonDataLoadedSuccessfully === false) {
  5637	    alert('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  5638	    return;
  5639	  }
  5640	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  5641	  if (refuseIfWeeklySemesterPaused(getAdminSemKey())) return;
  5642	
  5643	  caEditSaveInFlight = true;
  5644	  // Every action button in the modal body — the form's own Save/Print/Cancel
  5645	  // AND the empty-cell popup's two Paste buttons, which openDetailModal()
  5646	  // renders outside #ca-edit-form (round-3 review: they could replace the
  5647	  // modal body mid-save and race a second write onto the same slot).
  5648	  const btns = Array.from(document.querySelectorAll('#ca-modal-body .ca-actions button'));
  5649	  const saveBtn = btns.find(b => /^save/i.test(b.textContent.trim()));
  5650	  btns.forEach(b => { b.disabled = true; });
  5651	  if (saveBtn) saveBtn.textContent = 'Saving...';
  5652	  try {
  5653	    await saveAdminEditInner(key, teacher, className, weekNum, title);
  5654	  } finally {
  5655	    caEditSaveInFlight = false;
  5656	    btns.forEach(b => { b.disabled = false; });
  5657	    if (saveBtn) saveBtn.textContent = 'Save';
  5658	  }
  5659	}
  5660	
  5661	async function saveAdminEditInner(key, teacher, className, weekNum, title) {
  5662	  const semKey = getAdminSemKey();
  5663	
  5664	  const lessons = { ...(currentLessonData?.[semKey] || {}) };
  5665	  let existing = lessons[key] || {};   // rebased on the fresh server copy after the existence check (non-summer)
  5666	
  5667	  // Step 1 — diff the form against the open-time snapshot (pure DOM reads, no
  5668	  // side effects — so a no-op save can bail out below without paying for the
  5669	  // existence check's server read).
  5670	  const raw = {
  5671	    projectTitle: title,
  5672	    shortDetails: document.getElementById('ca-edit-details')?.value.trim() || '',
  5673	    inspoLink: document.getElementById('ca-edit-inspo')?.value.trim() || '',
  5674	    introPitch: document.getElementById('ca-edit-intro')?.value.trim() || '',
  5675	    processStep1: document.getElementById('ca-edit-step1')?.value.trim() || '',
  5676	    processStep2: document.getElementById('ca-edit-step2')?.value.trim() || '',
  5677	    processStep3: document.getElementById('ca-edit-step3')?.value.trim() || '',
  5678	    processStep4: document.getElementById('ca-edit-step4')?.value.trim() || '',
  5679	    closure: document.getElementById('ca-edit-closure')?.value.trim() || '',
  5680	    materials: document.getElementById('ca-edit-materials')?.value.trim() || '',
  5681	    dayOfMaterials: document.getElementById('ca-edit-dayof')?.value.trim() || '',
  5682	  };
  5683	  // No snapshot (shouldn't happen — both render paths capture one) degrades to
  5684	  // "everything non-empty is changed": today's behavior, never a lost edit.
  5685	  const baseline = caEditOriginalData || {};
  5686	  const changedFields = Object.keys(raw).filter(f => raw[f] !== (baseline[f] || ''));
  5687	  // Had text when the popup opened, empty now — an intentional clear, which
  5688	  // saveSingleLesson must apply with FieldValue.delete() rather than let the
  5689	  // stripping pass silently drop (Data Safety Plan Stage 3, never extended to
  5690	  // this third editor until now).
  5691	  const fieldsToClear = changedFields.filter(f => (baseline[f] || '') !== '' && raw[f] === '');
  5692	  const changedData = {};
  5693	  changedFields.forEach(f => { changedData[f] = raw[f]; });
  5694	
  5695	  const photoInput = document.getElementById('ca-edit-photo-input');
  5696	  const hasNewPhoto = photoInput?.files?.length > 0;
  5697	  let pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
  5698	  // Nothing changed — no write, no re-stamped lastEditedBy/At, no "edit" log
  5699	  // entry for an edit that didn't happen (mirrors saveTeacherEdit()).
  5700	  if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) {
  5701	    closeAdminModal(true);
  5702	    return;
  5703	  }
  5704	
  5705	  // Step 2 — forced-server read of this slot, before any side effect (the
  5706	  // photo upload, the write). Non-summer only: a summer cache entry is a
  5707	  // scaffold regenerated from summerCamps_curriculum whether or not its
  5708	  // summerCamps_lessonData doc exists (a missing doc means "never saved",
  5709	  // not "moved") and this app has no move/swap/cut path for summer lessons,
  5710	  // so there is no ghost to prevent — the first save legitimately creates
  5711	  // the doc. Same routing signal as saveSingleLesson() /
  5712	  // adminLessonStillExistsWithRetry() (key prefix; the camp-seasons plan
  5713	  // unifies this on semesterType). Forced read — a cache-permitting get()
  5714	  // could be served from the live listener's local cache in exactly the race
  5715	  // window this check exists to close. It runs for first-time creation too:
  5716	  // an "empty" slot in this tab's cache may have gained a project (a paste, a
  5717	  // move onto it) that the listener hasn't delivered yet.
  5718	  const isSummerSchema = isCampSeason(semKey);   // Phase 1, 1.1
  5719	  if (!isSummerSchema) {
  5720	    let check;
  5721	    try {
  5722	      check = await adminLessonStillExistsWithRetry(semKey, key);
  5723	    } catch (err) {
  5724	      console.warn('⚠️ Existence check retry also failed:', err);
  5725	      alert("Couldn't confirm this lesson still exists — check your connection and try saving again.");
  5726	      return;
  5727	    }
  5728	    if (caEditLessonExisted && !check.exists) {
  5729	      alert('This lesson was moved or removed elsewhere while you had it open. Your changes were not saved — please close this window and check the grid for its new location.');
  5730	      return;
  5731	    }
  5732	    if (check.exists) {
  5733	      // The key holds a doc — but a swap, a move ONTO this slot, or a paste
  5734	      // into a slot this tab still shows as empty leaves it populated with a
  5735	      // DIFFERENT project. The popup's edits were made against the project it
  5736	      // opened on; applying them to whatever is here now needs an explicit
  5737	      // decision, the same way cutProject() re-confirms when the fresh read
  5738	      // shows the slot's identity changed.
  5739	      const freshTitle = (check.data?.projectTitle || '').trim();
  5740	      if (freshTitle !== (baseline.projectTitle || '')) {
  5741	        const opened = baseline.projectTitle || '(empty slot)';
  5742	        if (!confirm(`This slot has changed since you opened it — it now contains "${freshTitle || '(empty)'}" instead of "${opened}". Save your changes onto "${freshTitle || 'this slot'}" anyway?\n\nCancel keeps your text here and saves nothing.`)) return;
  5743	      }
  5744	      // From here on, work from the FRESH copy, not this tab's cache: the
  5745	      // photo to delete after a replacement, the "remove photo" target, the
  5746	      // identity/scheduling fields resent below, the local cache merge and
  5747	      // the logged title all come from `existing`. On the swap-accept path
  5748	      // the cached copy's photoPath is the OTHER lesson's live photo.
  5749	      existing = check.data;
  5750	      pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
  5751	    }
  5752	  } else if (!existing.campName) {
  5753	    // A summer key that is no longer in the cache (the schedule was rebuilt
  5754	    // between open and save — e.g. the project was renamed in the Summer
  5755	    // Camp App) would produce a doc without its identity trio, which neither
  5756	    // app can find again. Refuse rather than write it.
  5757	    alert('This lesson is no longer in the summer schedule — reload and try again. Nothing was saved.');
  5758	    return;
  5759	  }
  5760	
  5761	  // Summer: projectTitle, shortDetails, inspoLink and materials belong to the
  5762	  // camp curriculum, not to the lesson doc — loadSummerCampData() takes them
  5763	  // from the scaffold and reads back only content/photo/completion fields
  5764	  // (SUMMER_SAVED_FIELDS), so an edit here would "save" and then vanish on the
  5765	  // next reload. projectTitle is worse: it is part of the lesson key, and the
  5766	  // Summer Camp App's orphan check treats a doc whose title isn't in the
  5767	  // camp's curriculum as orphaned content. Refuse them honestly rather than
  5768	  // write them into a doc where they can only mislead.
  5769	  const SUMMER_CURRICULUM_OWNED = ['projectTitle', 'shortDetails', 'inspoLink', 'materials'];
  5770	  if (isSummerSchema) {
  5771	    const refused = SUMMER_CURRICULUM_OWNED.filter(f => f in changedData);
  5772	    if (refused.length > 0) {
  5773	      const labels = { projectTitle: 'project title', shortDetails: 'short details', inspoLink: 'inspo link', materials: 'materials' };
  5774	      alert(`Summer camp ${refused.map(f => labels[f]).join(', ')} are managed in the Summer Camp App — that change is not saved here.` + (changedFields.length > refused.length || hasNewPhoto || pendingRemove ? ' Your other edits will still be saved.' : ''));
  5775	      refused.forEach(f => {
  5776	        delete changedData[f];
  5777	        const idx = changedFields.indexOf(f);
  5778	        if (idx !== -1) changedFields.splice(idx, 1);
  5779	        const cidx = fieldsToClear.indexOf(f);
  5780	        if (cidx !== -1) fieldsToClear.splice(cidx, 1);
  5781	      });
  5782	      if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) { closeAdminModal(true); return; }
  5783	    }
  5784	  }
  5785	
  5786	  // Firestore-bound payload — see the function comment for what's in it and why.
  5787	  const firestorePayload = {
  5788	    teacher, className, weekNum,
  5789	    weekDate: existing.weekDate || '',
  5790	    classSize: existing.classSize || 0,
  5791	    // Summer identity trio, key-derived and idempotent — a doc this save
  5792	    // CREATES must carry them (the Summer Camp App queries this collection by
  5793	    // campName + teacher and checks projectTitle; the summer editor sends the
  5794	    // same trio on every save for the same reason).
  5795	    ...(isSummerSchema ? { campName: existing.campName, block: existing.block, projectTitle: existing.projectTitle } : {}),
  5796	    ...changedData,
  5797	    lastImported: new Date().toISOString()
  5798	  };
  5799	
  5800	  // Backtracking audit, Phase 1 (R4-2): capture the OLD photoPath before any
  5801	  // mutation, so the delete-after-save step compares against the right value.
  5802	  const oldPhotoPath = existing.photoPath || null;
  5803	  let photoUrl = null, photoPath = null;   // null = this save didn't touch the photo
  5804	
  5805	  try {
  5806	    // Handle photo upload/removal
  5807	    if (hasNewPhoto) {
  5808	      const file = photoInput.files[0];
  5809	      if (file.size > 5 * 1024 * 1024) { alert('Photo must be under 5MB.'); return; }
  5810	      const { url, path } = await uploadLessonPhoto(semKey, key, file);
  5811	      // Delete of the OLD photo happens AFTER the save below — not here.
  5812	      photoUrl = url;
  5813	      photoPath = path;
  5814	    } else if (pendingRemove) {
  5815	      photoUrl = '';
  5816	      photoPath = '';
  5817	    }
  5818	    if (photoUrl !== null) {
  5819	      firestorePayload.photoUrl = photoUrl;
  5820	      firestorePayload.photoPath = photoPath;
  5821	    }
  5822	
  5823	    // Targeted single-lesson save with a diff-only payload — never the cached
  5824	    // full lesson, never the whole semester. (The summer branch's "no content"
  5825	    // guard can't refuse a legitimate save from here: for summer every
  5826	    // editable non-content field is curriculum-owned and refused above, so
  5827	    // what remains is content, a clear, or a photo — each admitted.)
  5828	    await saveSingleLesson(semKey, key, firestorePayload, fieldsToClear);
  5829	
  5830	    // Backtracking audit, Phase 1 (R4-2): only delete the OLD object once
  5831	    // Firestore has confirmed the new reference — and only when THIS save
  5832	    // actually replaced or removed the photo (photoUrl !== null). A text-only
  5833	    // edit leaves the old path untouched in both Firestore and Storage.
  5834	    if (photoUrl !== null && oldPhotoPath && oldPhotoPath !== (photoPath || null)) {
  5835	      try {
  5836	        await deleteLessonPhoto(oldPhotoPath);
  5837	      } catch (cleanupErr) {
  5838	        console.error('⚠️ Could not clean up old photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
  5839	      }
  5840	    }
  5841	  } catch (err) {
  5842	    // Backtracking audit, Phase 1 (R2-22): MUST return here — otherwise
  5843	    // execution falls through to commit currentLessonData, close the modal,
  5844	    // and log a fake edit even though the save never actually succeeded. The
  5845	    // snapshot is kept so the still-open popup can retry against it.
  5846	    console.error('❌ Admin edit failed to save:', err);
  5847	    alert(err?.message === OWN_DOC_PAUSED_MESSAGE ? OWN_DOC_PAUSED_MESSAGE : 'This edit could not be saved. Please try again.');
  5848	    return;
  5849	  }
  5850	
  5851	  // Local display/cache only — never sent to Firestore, so keeping the full
  5852	  // merge here is safe (staleness in untouched fields is cosmetic until the
  5853	  // listener's next delivery, same as the teacher editor).
  5854	  lessons[key] = {
  5855	    ...existing,
  5856	    teacher, className, weekNum,
  5857	    weekDate: firestorePayload.weekDate,
  5858	    classSize: firestorePayload.classSize,
  5859	    ...changedData,
  5860	    lastImported: firestorePayload.lastImported,
  5861	    lastEditedBy: firestorePayload.lastEditedBy,   // stamped by saveSingleLesson()
  5862	    lastEditedAt: firestorePayload.lastEditedAt
  5863	  };
  5864	  if (photoUrl !== null) { lessons[key].photoUrl = photoUrl; lessons[key].photoPath = photoPath; }
  5865	  fieldsToClear.forEach(f => { lessons[key][f] = ''; });
  6220	
  6221	// Backtracking audit, Phase 11 (R3-12, R3-13). Previously resaved the ENTIRE
  6222	// cached semester via saveLessonData() — any lesson whose local copy was stale
  6223	// (a teacher's concurrent save in another tab) was silently reverted on the
  6224	// server — mutated the shared cache before any write landed, and logged only
  6225	// after one bulk save, so a part-way failure lost the log for targets that
  6226	// had actually been written. Now: one targeted saveSingleLesson() per target
  6227	// with an explicit fieldsToClear (a source field that is EMPTY must clear the
  6228	// target's stale value — the save strips empty content fields, so without the
  6229	// clear the old text would survive under the new plan), cache committed per
  6230	// target only after its save resolves, logged immediately, honest count on
  6231	// failure.
  6232	async function executeCopyPlan(sourceKey) {
  6233	  const semKey = getAdminSemKey();
  6234	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  6235	  if (refuseIfWeeklySemesterPaused(semKey)) return;
  6236	  const liveLessons = currentLessonData?.[semKey];
  6237	  const source = liveLessons?.[sourceKey];
  6238	  if (!source) return;
  6239	
  6240	  const checkboxes = document.querySelectorAll('.ca-copy-cb:checked');
  6241	  const targetKeys = Array.from(checkboxes).map(cb => cb.dataset.key);
  6242	
  6243	  if (targetKeys.length === 0) {
  6244	    alert('No targets selected.');
  6245	    return;
  6246	  }
  6247	
  6248	  // Check if any targets have existing plans
  6249	  const overwriteTargets = targetKeys.filter(k => liveLessons[k] && hasLessonContent(liveLessons[k]));
  6250	  if (overwriteTargets.length > 0) {
  6251	    const names = overwriteTargets.map(k => {
  6252	      const l = liveLessons[k];
  6253	      return `${l.teacher} — ${l.className} (Wk ${l.weekNum})`;
  6254	    }).join('\n');
  6255	    if (!confirm(`${overwriteTargets.length} target(s) already have lesson plans that will be overwritten:\n\n${names}\n\nContinue?`)) return;
  6256	  }
  6257	
  6258	  const fields = getCopyableFields(source); // the 7 CONTENT_FIELDS plus `materials`
  6259	  let savedCount = 0;
  6260	  let failure = null;
  6261	
  6262	  try {
  6263	    for (const targetKey of targetKeys) {
  6264	      if (!liveLessons[targetKey]) continue;
  6265	      // Work on copies — the shared cache object is only replaced below,
  6266	      // after this target's own save has resolved (R3-13).
  6267	      const previousTarget = { ...liveLessons[targetKey] };
  6268	      const targetFieldsToClear = CONTENT_FIELDS.filter(f =>
  6269	        (previousTarget[f] || '').trim() !== '' && !(fields[f] || '').trim()
  6270	      );
  6271	      // Send ONLY the copied fields (saveSingleLesson writes per-field paths
  6272	      // and stamps lastEditedBy/At onto this object). Sending the whole
  6273	      // cached target would re-write every non-content field — qaThread,
  6274	      // photoUrl, planComplete… — from this admin's possibly-stale copy over
  6275	      // a teacher's concurrent change (implementation review, Sep 2026).
  6276	      const payload = { ...fields };
  6277	      await saveSingleLesson(semKey, targetKey, payload, targetFieldsToClear);
  6278	      const updatedTarget = { ...previousTarget, ...payload };
  6279	      if (currentLessonData[semKey]) currentLessonData[semKey][targetKey] = updatedTarget;
  6280	      savedCount++;
  6281	      // Uncheck the saved target so, if a later one fails, "retry the rest"
  6282	      // re-runs only the rest (no duplicate copies or Change History entries).
  6283	      const cb = document.querySelector(`.ca-copy-cb[data-key="${CSS.escape(targetKey)}"]`);
  6284	      if (cb) cb.checked = false;
  6285	
  6286	      // Log this copy now — before the next target — so a later failure
  6287	      // can't lose the record of a write that already landed.
  6288	      const logEntry = {
  6289	        action: 'copy',
  6290	        details: {
  6291	          projectTitle: source.projectTitle,
  6292	          fromTeacher: source.teacher,
  6293	          fromClassName: source.className,
  6294	          fromWeek: source.weekNum,
  6295	          toTeacher: updatedTarget.teacher,
  6296	          toClassName: updatedTarget.className,
  6297	          toWeek: updatedTarget.weekNum
  6298	        }
  6299	      };
  6300	      // Capture the overwritten plan whenever ANY copyable field had text —
  6301	      // the clear above is explicit and intentional, so Change History must
  6302	      // hold the recovery record even when the prior content lived only in
  6303	      // processStep2-4/closure/dayOfMaterials (which the looser
  6304	      // hasLessonContent() used for the confirm prompt doesn't look at).
  6305	      const previousPlan = getCopyableFields(previousTarget);
  6306	      if (Object.values(previousPlan).some(v => String(v).trim())) {
  6307	        logEntry.details.previousPlan = previousPlan;
  6308	      }
  6309	      try {
  6310	        await appendChangeLogEntry(semKey, logEntry);
  6311	      } catch (logErr) {
  6312	        // The copy itself is saved; a Change History miss must not read as
  6313	        // a failed copy (same rule as saveTeacherEdit(), Phase 8).
  6314	        console.error('⚠️ Copy saved, but Change History logging failed for', targetKey, logErr);
  6315	      }
  6316	    }
  6317	  } catch (err) {
  6318	    console.error('❌ Copy Plan failed partway through:', err);
  6319	    failure = err;
  6320	  }
  6321	
  6322	  // UI after the try/catch so a render exception can't be misreported as a
  6323	  // failed save (and can't re-throw from inside the catch).
  6324	  renderAdminGrid();
  6325	  renderChangeHistory();
  6326	  if (failure) {
  6327	    alert(`Copied to ${savedCount} of ${targetKeys.length} class(es) before a save failed. Please check which targets actually received the plan before retrying the rest.\n\n${failure.message}`);
  6328	    return;
  6329	  }
  6330	  closeAdminModal();
  6331	  const skipped = targetKeys.length - savedCount;
  6332	  alert(`Plan copied to ${savedCount} class${savedCount !== 1 ? 'es' : ''}${skipped > 0 ? ` (${skipped} skipped)` : ''}.`);
  6333	}
  6334	
  6335	// Backtracking audit, Phase 8: rebuilt around the companion plan's Phase 17
  6336	// design. Forced-server read before archiving or deleting anything (closes
  6337	// two failure modes: the doc no longer existing at all, and the doc existing
  6338	// but having genuinely different content than this admin's stale local
  6339	// snapshot — a teacher's concurrent edit). Archives the COMPLETE fresh
  6340	// lesson object (not a hand-picked field list) via FieldValue.arrayUnion()
  6341	// against curriculum/cutProjects (not saveCutProjects()'s local-splice-then-
  6342	// full-array-overwrite — two admins cutting concurrently now both survive
  6343	// regardless of write order). Archive-before-delete ordering — a failed
  6344	// archive save leaves the live lesson completely untouched.
  6345	async function cutProject(key) {
  6346	  const semKey = getAdminSemKey();
  6347	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  6348	  if (refuseIfWeeklySemesterPaused(semKey)) return;
  6349	  const lessons = { ...currentLessonData[semKey] };
  6350	  const lesson = lessons[key];
  6351	  if (!lesson) return;
  6352	
  6353	  if (!confirm(`Cut "${lesson.projectTitle}" from ${lesson.teacher} / ${lesson.className} Week ${lesson.weekNum}? It will be moved to the Cut Projects bank.`)) return;
  6354	
  6355	  let check;
  6356	  try {
  6357	    check = await adminLessonStillExistsWithRetry(semKey, key);
  6358	  } catch (err) {
  6359	    console.error('Could not confirm current state before cutting', key, err);
  6360	    alert(`Could not confirm "${lesson.projectTitle}" still exists — nothing was cut. Check your connection and try again.`);
  6361	    return;
  6362	  }
  6363	  if (!check.exists) {
  6364	    alert(`"${lesson.projectTitle}" no longer exists — it may have been moved, deleted, or already cut by someone else. Nothing was cut.`);
  6365	    if (currentLessonData[semKey]) delete currentLessonData[semKey][key];
  6366	    renderAdminGrid();
  6367	    return;
  6368	  }
  6369	  const freshLesson = check.data;
  6370	
  6371	  // The first confirm() above authorized cutting THIS project, by name — if
  6372	  // the fresh read shows the slot's identity has materially changed since
  6373	  // then, that authorization doesn't cover it.
  6374	  if (freshLesson.projectTitle !== lesson.projectTitle || freshLesson.teacher !== lesson.teacher || freshLesson.className !== lesson.className) {
  6375	    if (!confirm(`This slot has changed since you opened it — it now contains "${freshLesson.projectTitle}" (${freshLesson.teacher} / ${freshLesson.className}). Cut this instead?`)) return;
  6376	  }
  6377	
  6378	  const user = getAuthUser();
  6379	  const archiveEntry = {
  6380	    ...freshLesson,
  6381	    originalTeacher: freshLesson.teacher,
  6382	    originalClassName: freshLesson.className,
  6383	    originalWeek: freshLesson.weekNum,
  6384	    cutDate: new Date().toISOString(),
  6385	    cutBy: user?.name || 'Unknown'
  6386	  };
  6387	
  6388	  if (!curriculumDb) initCurriculumFirestore();
  6389	  try {
  6390	    await curriculumDb.collection('curriculum').doc('cutProjects').set({
  6391	      [semKey]: firebase.firestore.FieldValue.arrayUnion(archiveEntry)
  6392	    }, { merge: true });
  6393	  } catch (e) {
  6394	    console.error('Could not save Cut Bank entry for', key, e);
  6395	    alert(`Could not cut "${freshLesson.projectTitle}" — the Cut Bank entry could not be saved. Nothing was changed.`);
  6396	    return;
  6397	  }
  6398	
  6399	  let deleteFailed = false;
  6400	  try {
  6401	    await deleteLessonKey(semKey, key);
  6402	  } catch (e) {
  6403	    console.error('Could not delete lesson after archiving', key, e);
  6404	    deleteFailed = true;
  6405	  }
  6406	
  6407	  // Local cache/grid only drops the lesson when the delete actually
  6408	  // succeeded — a failed delete leaves the grid showing the lesson as gone
  6409	  // while Firestore still has it live otherwise.
  6410	  if (!deleteFailed) {
  6411	    delete lessons[key];
  6412	    currentLessonData[semKey] = lessons;
  6413	  }
  6414	  if (!currentCutProjects) currentCutProjects = {};
  6415	  currentCutProjects[semKey] = [...(currentCutProjects[semKey] || []), archiveEntry];
  6416	
  6417	  try {
  6418	    await appendChangeLogEntry(semKey, {
  6419	      action: 'cut',
  6420	      details: { projectTitle: freshLesson.projectTitle, teacher: freshLesson.teacher, className: freshLesson.className, fromWeek: freshLesson.weekNum }
  6421	    });
  6422	    renderChangeHistory();
  6423	  } catch (logErr) {
  6424	    console.error('⚠️ Cut saved, but Change History logging failed:', logErr);
  6425	  }

exec
/bin/zsh -lc "rg -n \"openLessonModal\\(\" js/app.js | head -30 && rg -n \"saveTeacherEdit\\(|saveAdminEdit\\(|sendTeacherQaMessage\\(|sendHelpResponse\\(|sendQaReply\\(|createLessonSlotsForRoster\\(\" js/app.js index.html" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
2097:          return `<td class="camp-overview-cell"><button class="camp-overview-project" onclick="openLessonModal(${escForOnclick(campName)}, ${escForOnclick(title)}, ${escForOnclick(block)})">${escHtml(title)}</button></td>`;
2161:            <button class="tv-edit-btn" onclick="event.stopPropagation(); openLessonModal(${escForOnclick(campName)}, ${escForOnclick(project.projectTitle)}, ${escForOnclick(project.block)})">✎ Edit</button>
2313:      // other teacher's doc). Same lookup openLessonModal() uses.
3913:        openFn: `openLessonModal(${escForOnclick(data.campTopic)}, ${escForOnclick(data.projectTitle)}, ${escForOnclick(data.block)})`
3936:// semKey is the modal's semester, captured by openLessonModal() when it
11588:// every editor opened on it. Lives outside openLessonModal() on purpose — if a
11595:function openLessonModal(campName, projectTitle, block) {
js/app.js:3307:    saveTeacherEdit(lessonKey, currentLessonData?.[getTvSemKey()]?.[lessonKey] || lesson);
js/app.js:3315:      saveTeacherEdit(lessonKey, currentLessonData?.[getTvSemKey()]?.[lessonKey] || lesson);
js/app.js:3322:  document.getElementById('te-qa-send-btn').addEventListener('click', () => sendTeacherQaMessage(lessonKey, semKey));
js/app.js:3326:      sendTeacherQaMessage(lessonKey, semKey);
js/app.js:3496:async function saveTeacherEdit(lessonKey, originalLesson) {
js/app.js:3670:// same atomic-append design sendHelpResponse()/sendQaReply() already use —
js/app.js:3675:async function sendTeacherQaMessage(lessonKey, modalSemKey) {
js/app.js:3709:  // accepted check-to-write residual as sendHelpResponse()/sendQaReply().
js/app.js:3939:// sendTeacherQaMessage()).
js/app.js:4872:// A lesson slot exactly as createNewSemester() / createLessonSlotsForRoster()
js/app.js:5431:// teacher editors, which this modal never had. saveAdminEdit() diffs the form
js/app.js:5441:// summerCamps_lessonData doc exists yet, so saveAdminEdit() skips the check
js/app.js:5458:// trimmed on the way in because saveAdminEdit() reads the form via
js/app.js:5583:      <button class="btn-primary ca-action-btn" onclick="saveAdminEdit(${escForOnclick(key)}, ${escForOnclick(teacher)}, ${escForOnclick(className)}, ${weekNum})">Save</button>
js/app.js:5626:async function saveAdminEdit(key, teacher, className, weekNum) {
js/app.js:5699:  // entry for an edit that didn't happen (mirrors saveTeacherEdit()).
js/app.js:5915:// sendHelpResponse()/sendQaReply() (not yet implemented) — forced server
js/app.js:6313:        // a failed copy (same rule as saveTeacherEdit(), Phase 8).
js/app.js:6568:  // confirmed the clear — same safe ordering as saveAdminEdit()/saveTeacherEdit().
js/app.js:7044:  // saveAdminEdit()/saveTeacherEdit().
js/app.js:7172:        <button class="btn-primary ca-help-send-btn" onclick="sendHelpResponse(${escForOnclick(key)})">Respond</button>
js/app.js:7199:// Shared by sendHelpResponse() and sendQaReply() below — seeds arrayUnion's
js/app.js:7220:async function sendHelpResponse(key) {
js/app.js:7309:async function sendQaReply(key) {
js/app.js:8596:    <button class="btn-primary qa-reply-btn" onclick="sendQaReply(${escForOnclick(key)})">Send</button>
js/app.js:11469:    await createLessonSlotsForRoster(semKey, classRoster, config.semesters[semKey].numWeeks);
js/app.js:11492:async function createLessonSlotsForRoster(semKey, roster, numWeeks) {

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '5618,5685p;3490,3538p;2868,2898p;11290,11375p' && nl -ba /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js | sed -n '574,680p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
  2868	      e.stopPropagation();
  2869	      printLesson(btn.dataset.lessonKey);
  2870	    });
  2871	  });
  2872	
  2873	  // Plan Complete checkbox — instant save
  2874	  container.querySelectorAll('.tv-plan-complete-cb').forEach(cb => {
  2875	    cb.addEventListener('change', async (e) => {
  2876	      const lessonKey = cb.dataset.lessonKey;
  2877	      const semKey = getTvSemKey();
  2878	      const lessons = currentLessonData?.[semKey];
  2879	      if (!lessons || !lessons[lessonKey]) return;
  2880	
  2881	      if (refuseIfWeeklySemesterPaused(semKey)) { cb.checked = !cb.checked; return; }   // Spring storage move: nothing changes
  2882	      const lesson = lessons[lessonKey];
  2883	      lesson.planComplete = cb.checked;
  2884	
  2885	      try {
  2886	        // Narrow payload — see the Stage 2C note on the summer handler above.
  2887	        await saveSingleLesson(semKey, lessonKey, { planComplete: cb.checked });
  2888	        // Re-render to update progress badge
  2889	        renderTeacherView();
  2890	      } catch (err) {
  2891	        console.error('Error saving plan complete:', err);
  2892	        cb.checked = !cb.checked; // revert
  2893	        lesson.planComplete = cb.checked;
  2894	        if (err?.message === OWN_DOC_PAUSED_MESSAGE) alert(OWN_DOC_PAUSED_MESSAGE);
  2895	      }
  2896	    });
  2897	  });
  2898	
  3490	  const current = getTeEditFormData();
  3491	  return Object.keys(teOriginalData).filter(key =>
  3492	    normalizeTeFormValue(key, current) !== (teOriginalData[key] || '')
  3493	  );
  3494	}
  3495	
  3496	async function saveTeacherEdit(lessonKey, originalLesson) {
  3497	  const saveBtn = document.getElementById('te-save-btn');
  3498	  const autoSaveStatus = document.getElementById('te-autosave-status');
  3499	  const formData = getTeEditFormData();
  3500	  const changedFields = getTeChangedFields();
  3501	  const photoInput = document.getElementById('te-photo-input');
  3502	  const hasNewPhoto = photoInput?.files?.length > 0;
  3503	  const pendingRemove = photoInput?.dataset?.pendingRemove === 'true';
  3504	
  3505	  if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) {
  3506	    // Nothing to save — flash the button briefly
  3507	    if (saveBtn) { saveBtn.textContent = 'Saved!'; saveBtn.disabled = true; }
  3508	    setTimeout(() => { if (saveBtn) { saveBtn.textContent = 'Save'; saveBtn.disabled = false; } }, 1500);
  3509	    return;
  3510	  }
  3511	
  3512	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  3513	  if (refuseIfWeeklySemesterPaused(getTvSemKey())) return;
  3514	
  3515	  if (saveBtn) { saveBtn.disabled = true; saveBtn.textContent = 'Saving...'; }
  3516	  if (autoSaveStatus) autoSaveStatus.textContent = 'Saving...';
  3517	
  3518	  try {
  3519	    const semKey = getTvSemKey();
  3520	
  3521	    // Build updated lesson (preserve all original fields, override edited ones)
  3522	    const updatedLesson = { ...originalLesson, ...formData };
  3523	
  3524	    // Backtracking audit, Phase 8 (R4-2): capture the OLD photoPath before any
  3525	    // mutation, so the delete-after-save step below has the right value to
  3526	    // compare against.
  3527	    const oldPhotoPath = originalLesson.photoPath || null;
  3528	    const uploadedFile = hasNewPhoto ? photoInput.files[0] : null;
  3529	
  3530	    // Handle photo upload
  3531	    let photoUrl = null, photoPath = null;
  3532	    if (hasNewPhoto) {
  3533	      if (saveBtn) saveBtn.textContent = 'Uploading photo...';
  3534	      if (autoSaveStatus) autoSaveStatus.textContent = 'Uploading photo...';
  3535	      const result = await uploadLessonPhoto(semKey, lessonKey, photoInput.files[0]);
  3536	      // Backtracking audit, Phase 8 (R4-2): delete moved to AFTER the save
  3537	      // below — no longer here, immediately after upload.
  3538	      photoUrl = result.url;
  5618	// weekNum, weekDate, classSize — no input in this form; resent from the cache
  5619	// exactly as before, an inherited exposure named in the plan, not a Phase 9
  5620	// change). The cached `existing` lesson is never spread into the payload, so
  5621	// a stale qaThread / photo / untouched content field can't overwrite another
  5622	// client's newer copy. Intentional clears travel as fieldsToClear. Before
  5623	// anything is written, a forced-server read confirms the lesson still exists
  5624	// (moved/deleted elsewhere while the popup was open → refuse, don't recreate
  5625	// a ghost). Residual check-to-write TOCTOU gap accepted per the plan.
  5626	async function saveAdminEdit(key, teacher, className, weekNum) {
  5627	  if (caEditSaveInFlight) return;
  5628	  const title = document.getElementById('ca-edit-title')?.value.trim();
  5629	  // (closeAdminModal() refuses non-forced closes while caEditSaveInFlight is
  5630	  // set — Cancel / × / overlay are effectively disabled for the duration.)
  5631	  if (!title) { alert('Project title is required.'); return; }
  5632	
  5633	  // Backtracking audit, Phase 1: check the guard BEFORE any Storage mutation
  5634	  // (and, now, before the existence check) so a known-bad load state never
  5635	  // gets as far as a server read, an upload, or a delete.
  5636	  if (lessonDataLoadedSuccessfully === false) {
  5637	    alert('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  5638	    return;
  5639	  }
  5640	  // Spring 2026 storage move: refuse BEFORE any change (see refuseIfWeeklySemesterPaused).
  5641	  if (refuseIfWeeklySemesterPaused(getAdminSemKey())) return;
  5642	
  5643	  caEditSaveInFlight = true;
  5644	  // Every action button in the modal body — the form's own Save/Print/Cancel
  5645	  // AND the empty-cell popup's two Paste buttons, which openDetailModal()
  5646	  // renders outside #ca-edit-form (round-3 review: they could replace the
  5647	  // modal body mid-save and race a second write onto the same slot).
  5648	  const btns = Array.from(document.querySelectorAll('#ca-modal-body .ca-actions button'));
  5649	  const saveBtn = btns.find(b => /^save/i.test(b.textContent.trim()));
  5650	  btns.forEach(b => { b.disabled = true; });
  5651	  if (saveBtn) saveBtn.textContent = 'Saving...';
  5652	  try {
  5653	    await saveAdminEditInner(key, teacher, className, weekNum, title);
  5654	  } finally {
  5655	    caEditSaveInFlight = false;
  5656	    btns.forEach(b => { b.disabled = false; });
  5657	    if (saveBtn) saveBtn.textContent = 'Save';
  5658	  }
  5659	}
  5660	
  5661	async function saveAdminEditInner(key, teacher, className, weekNum, title) {
  5662	  const semKey = getAdminSemKey();
  5663	
  5664	  const lessons = { ...(currentLessonData?.[semKey] || {}) };
  5665	  let existing = lessons[key] || {};   // rebased on the fresh server copy after the existence check (non-summer)
  5666	
  5667	  // Step 1 — diff the form against the open-time snapshot (pure DOM reads, no
  5668	  // side effects — so a no-op save can bail out below without paying for the
  5669	  // existence check's server read).
  5670	  const raw = {
  5671	    projectTitle: title,
  5672	    shortDetails: document.getElementById('ca-edit-details')?.value.trim() || '',
  5673	    inspoLink: document.getElementById('ca-edit-inspo')?.value.trim() || '',
  5674	    introPitch: document.getElementById('ca-edit-intro')?.value.trim() || '',
  5675	    processStep1: document.getElementById('ca-edit-step1')?.value.trim() || '',
  5676	    processStep2: document.getElementById('ca-edit-step2')?.value.trim() || '',
  5677	    processStep3: document.getElementById('ca-edit-step3')?.value.trim() || '',
  5678	    processStep4: document.getElementById('ca-edit-step4')?.value.trim() || '',
  5679	    closure: document.getElementById('ca-edit-closure')?.value.trim() || '',
  5680	    materials: document.getElementById('ca-edit-materials')?.value.trim() || '',
  5681	    dayOfMaterials: document.getElementById('ca-edit-dayof')?.value.trim() || '',
  5682	  };
  5683	  // No snapshot (shouldn't happen — both render paths capture one) degrades to
  5684	  // "everything non-empty is changed": today's behavior, never a lost edit.
  5685	  const baseline = caEditOriginalData || {};
 11290	    const users = [];
 11291	    snapshot.forEach(doc => {
 11292	      const d = doc.data();
 11293	      const canUse = d.active !== false
 11294	        && ((Array.isArray(d.appAccess) && d.appAccess.includes('classbook')) || d.role === 'admin' || d.role === 'manager');
 11295	      const note = d.active === false ? ' — archived' : (!canUse ? ' — no Classbook access' : '');
 11296	      users.push({ uid: doc.id, name: d.name || d.email || doc.id, email: d.email || '', canUse, note });
 11297	    });
 11298	    users.sort((a, b) => a.name.localeCompare(b.name));
 11299	
 11300	    const selects = document.querySelectorAll('.teacher-mapping-select');
 11301	    selects.forEach(select => {
 11302	      const teacherName = select.dataset.teacher;
 11303	      const currentMapping = Object.entries(currentConfig?.teacherMappings || {}).find(([, n]) => n === teacherName)?.[0] || '';
 11304	      for (const u of users.filter(x => x.canUse || x.uid === currentMapping)) {
 11305	        const opt = document.createElement('option');
 11306	        opt.value = u.uid;
 11307	        opt.textContent = `${u.name} (${u.email})${u.note}`;
 11308	        if (u.uid === currentMapping) opt.selected = true;
 11309	        select.appendChild(opt);
 11310	      }
 11311	      if (currentMapping && !users.some(u => u.uid === currentMapping)) {   // mapped to an account that no longer exists
 11312	        const opt = document.createElement('option');
 11313	        opt.value = currentMapping;
 11314	        opt.textContent = 'Unknown account (removed)';
 11315	        opt.selected = true;
 11316	        select.appendChild(opt);
 11317	      }
 11318	    });
 11319	  } catch (err) {
 11320	    console.error('Error loading users for mapping:', err);
 11321	  }
 11322	}
 11323	
 11324	function getUserLabelByUid(uid) {
 11325	  // Best effort — will be populated by dropdown
 11326	  return uid.substring(0, 8) + '...';
 11327	}
 11328	
 11329	function clearTeacherMapping(teacherName) {
 11330	  const mappings = { ...(currentConfig?.teacherMappings || {}) };
 11331	  // Find and remove UID mapped to this teacher
 11332	  for (const [uid, name] of Object.entries(mappings)) {
 11333	    if (name === teacherName) delete mappings[uid];
 11334	  }
 11335	  currentConfig.teacherMappings = mappings;
 11336	  renderTeacherMappingTable();
 11337	}
 11338	
 11339	function getTeacherMappingsFromForm() {
 11340	  const mappings = {};
 11341	  const selects = document.querySelectorAll('.teacher-mapping-select');
 11342	  selects.forEach(select => {
 11343	    const uid = select.value;
 11344	    const teacherName = select.dataset.teacher;
 11345	    if (uid && teacherName) {
 11346	      mappings[uid] = teacherName;
 11347	    }
 11348	  });
 11349	  return mappings;
 11350	}
 11351	
 11352	async function saveSettings() {
 11353	  const el = (id) => document.getElementById(id)?.value?.trim() || '';
 11354	  // Last line of defence: never write a form drawn for one semester onto another.
 11355	  if (settingsFormSemKey !== getSettingsSemKey()) {
 11356	    loadSettingsForm();
 11357	    alert('This form was showing a different semester from the one selected at the top, so nothing was saved. It now shows the selected semester — check it and save again.');
 11358	    return;
 11359	  }
 11360	
 11361	  // Spring 2026 storage move: its settings save also writes lesson slots, so it's
 11362	  // refused whole, before appData is touched.
 11363	  if (refuseIfWeeklySemesterPaused(getSettingsSemKey())) return;
 11364	
 11365	  const breakWeeksStr = el('settings-break-weeks');
 11366	  const breakWeeks = breakWeeksStr.split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n));
 11367	  const closureDates = parseClosureDates(el('settings-closure-dates'));
 11368	
 11369	  const semKey = getSettingsSemKey();
 11370	  const classRoster = getClassRosterFromForm();
 11371	  const teacherNames = getTeacherNamesFromForm();
 11372	
 11373	  const teacherMappings = getTeacherMappingsFromForm();
 11374	
 11375	  // Merge into existing config to preserve other semesters
   574	    const rebuild = () => {
   575	      // Don't build (or prune) until every watched document has reported once, so a
   576	      // semester never flickers out of the alert list while its source is loading.
   577	      if (!expected.every(id => received.has(id))) return;
   578	      const unansweredQuestions = buildClassbookQaAlerts(sources, Date.now());
   579	      const currentClassbookAlertIds = unansweredQuestions.map(a => a.id);
   580	
   581	      // One-time migration of dismissals saved under the pre-Sep-2026 id
   582	      // (classbook-qa-<lessonKey>): each currently-open question whose old id was
   583	      // dismissed gets its new id dismissed, then the old ids are retired, so an old
   584	      // dismissal can never hide a FUTURE question on the same lesson key (in any
   585	      // semester). A marker records that it ran; it only runs once every watched
   586	      // document has reported (see rebuild's guard above), so "currently open" is complete.
   587	      if (!dismissedAlertIds.has(CLASSBOOK_QA_DISMISSALS_MIGRATED)) {
   588	        const retired = new Set();
   589	        unansweredQuestions.forEach(alert => {
   590	          if (dismissedAlertIds.has(alert.legacyId)) {
   591	            dismissedAlertIds.add(alert.id);
   592	            retired.add(alert.legacyId);
   593	          }
   594	        });
   595	        retired.forEach(id => dismissedAlertIds.delete(id));
   596	        dismissedAlertIds.add(CLASSBOOK_QA_DISMISSALS_MIGRATED);
   597	        saveDismissedAlerts();
   598	      }
   599	
   600	      // Remove old Classbook alerts that are no longer unanswered
   601	      alerts.forEach(alert => {
   602	        if (alert.type === 'curriculum' && !currentClassbookAlertIds.includes(alert.id)) {
   603	          removeAlert(alert.id);
   604	        }
   605	      });
   606	
   607	      // Update all Q&A alerts
   608	      unansweredQuestions.forEach(alert => addOrUpdateAlert(alert));
   609	
   610	      updateUI();
   611	    };
   612	
   613	    const classbookListener = db.collection('curriculum')
   614	      .doc('lessonData')
   615	      .onSnapshot(doc => {
   616	        sources.lessonData = doc.exists ? doc.data() : null;
   617	        received.add('lessonData');
   618	        rebuild();
   619	      }, error => {
   620	        console.error('Classbook listener error:', error);
   621	      });
   622	    listeners.push(classbookListener);
   623	
   624	    CLASSBOOK_OWN_DOC_SEMESTERS.forEach(semKey => {
   625	      const ownDocListener = db.collection('curriculum')
   626	        .doc(`lessons_${semKey}`)
   627	        .onSnapshot(doc => {
   628	          sources.ownDocs[semKey] = doc.exists ? doc.data() : null;
   629	          received.add(`lessons_${semKey}`);
   630	          rebuild();
   631	        }, error => {
   632	          // Keep the last good snapshot of this document (a transient error must not
   633	          // look like "all of this semester's questions were answered"). If it never
   634	          // arrived, carry on without it so the other semesters still alert.
   635	          console.error(`Classbook ${semKey} listener error:`, error);
   636	          if (!received.has(`lessons_${semKey}`)) {
   637	            received.add(`lessons_${semKey}`);
   638	            rebuild();
   639	          }
   640	        });
   641	      listeners.push(ownDocListener);
   642	    });
   643	  }
   644	
   645	  // =====================================================
   646	  // Alert Management
   647	  // =====================================================
   648	
   649	  function addOrUpdateAlert(alert) {
   650	    if (dismissedAlertIds.has(alert.id)) {
   651	      // Route to dismissed list — alert is still tracked but not shown as active
   652	      alert.dismissed = true;
   653	      const existingIndex = dismissedAlerts.findIndex(a => a.id === alert.id);
   654	      if (existingIndex >= 0) {
   655	        dismissedAlerts[existingIndex] = alert;
   656	      } else {
   657	        dismissedAlerts.push(alert);
   658	      }
   659	      return;
   660	    }
   661	
   662	    const existingIndex = alerts.findIndex(a => a.id === alert.id);
   663	    if (existingIndex >= 0) {
   664	      alerts[existingIndex] = alert;
   665	    } else {
   666	      alerts.push(alert);
   667	    }
   668	  }
   669	
   670	  function removeAlert(alertId) {
   671	    alerts = alerts.filter(a => a.id !== alertId);
   672	    // If the underlying data resolved, auto-clean the dismissal too
   673	    if (dismissedAlertIds.has(alertId)) {
   674	      dismissedAlertIds.delete(alertId);
   675	      dismissedAlerts = dismissedAlerts.filter(a => a.id !== alertId);
   676	      saveDismissedAlerts();
   677	    }
   678	  }
   679	
   680	  function dismissAlert(alertId) {

exec
/bin/zsh -lc "nl -ba js/firebase-data.js | sed -n '101,170p;1790,1815p' && nl -ba js/app.js | sed -n '3736,3765p;7265,7298p;7355,7385p' && nl -ba e2e/helpers/storage-move.js | sed -n '1,85p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
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
   161	// Whether a weekly semester's lessons can be written right now. Every workflow
   162	// that writes lessons calls refuseIfWeeklySemesterPaused() BEFORE its first
   163	// change of any kind (photo upload, cut bank, config, optimistic UI), so a paused
   164	// Spring action changes nothing at all instead of half-happening.
   165	function weeklySemesterPausedMessage(semKey) {
   166	  if (!isOwnDocSemester(semKey)) return null;
   167	  return (ownDocSource[semKey] === 'ownDoc' && ownDocMoveVerified(semKey)) ? null : OWN_DOC_PAUSED_MESSAGE;
   168	}
   169	function refuseIfWeeklySemesterPaused(semKey) {
   170	  const message = weeklySemesterPausedMessage(semKey);
  1790	  return `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
  1791	}
  1792	
  1793	function getPhotoPath(semesterKey, lessonKey /* filename: ignored — resizeImage() always re-encodes to JPEG */) {
  1794	  // Store at curriculum/{semester}/{lessonKey}/demo-{unique}.jpg
  1795	  return `curriculum/${semesterKey}/${lessonKey}/demo-${uniquePhotoSuffix()}.jpg`;
  1796	}
  1797	
  1798	async function uploadLessonPhoto(semesterKey, lessonKey, file) {
  1799	  if (typeof firebase.storage !== 'function') {
  1800	    throw new Error('Firebase Storage SDK not loaded. Hard refresh and try again.');
  1801	  }
  1802	  const storage = getFirebaseStorage();
  1803	  const path = getPhotoPath(semesterKey, lessonKey, 'demo.jpg');
  1804	  const ref = storage.ref(path);
  1805	
  1806	  // Resize before upload (max 1200px wide, JPEG 80% quality)
  1807	  const resized = await resizeImage(file, 1200, 0.8);
  1808	
  1809	  const snapshot = await ref.put(resized, { contentType: 'image/jpeg' });
  1810	  const url = await snapshot.ref.getDownloadURL();
  1811	  return { url, path };
  1812	}
  1813	
  1814	async function uploadSummerCampPhoto(semKey, lessonKey, file) {
  1815	  // Same load guard as the summer lesson save this upload precedes — refuse
  3736	  const editedAt = new Date().toISOString();
  3737	  const editedBy = user?.name || 'Unknown';
  3738	
  3739	  let target;
  3740	  try {
  3741	    target = weeklyLessonTarget(semKey);   // own-doc semester: its own doc, or "editing is paused"
  3742	  } catch (err) {
  3743	    alert(err.message);
  3744	    return;
  3745	  }
  3746	  const p = `${target.prefix}${lessonKey}`;
  3747	  const updates = {
  3748	    [`${p}.qaThread`]: firebase.firestore.FieldValue.arrayUnion(...entriesToAdd),
  3749	    [`${p}.lastEditedBy`]: editedBy,
  3750	    [`${p}.lastEditedAt`]: editedAt,
  3751	  };
  3752	  // Legacy mirror fields, kept for compatibility with older readers.
  3753	  const legacyField = isAdmin ? 'adminResponse' : 'teacherNotes';
  3754	  updates[`${p}.${legacyField}`] = message;
  3755	
  3756	  try {
  3757	    await target.ref.update(updates);
  3758	  } catch (err) {
  3759	    console.error('Error sending Q&A message:', err);
  3760	    alert('Error sending message: ' + err.message);
  3761	    return;
  3762	  }
  3763	
  3764	  // Confirmed — make sure the local cache shows the new message before the
  3765	  // live listener catches up. Usually the listener already HAS: a local
  7265	    from: 'admin', name: user?.name || 'Admin', message: response, timestamp: new Date().toISOString()
  7266	  };
  7267	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7268	
  7269	  if (!curriculumDb) initCurriculumFirestore();
  7270	  const isSummer = lessonStore === 'camp';
  7271	  const updates = {};
  7272	  let weekly = null;
  7273	  if (!isSummer) {
  7274	    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
  7275	  }
  7276	  if (isSummer) {
  7277	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7278	    updates.adminResponse = response;
  7279	    updates.status = 'In Progress';
  7280	    updates.lastUpdated = new Date().toISOString();
  7281	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7282	  } else {
  7283	    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7284	    updates[`${weekly.prefix}${key}.adminResponse`] = response;
  7285	    updates[`${weekly.prefix}${key}.status`] = 'In Progress';
  7286	    updates.lastUpdated = new Date().toISOString();
  7287	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7288	  }
  7289	  const docRef = isSummer
  7290	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7291	    : weekly.ref;
  7292	
  7293	  try {
  7294	    await docRef.update(updates);
  7295	  } catch (err) {
  7296	    console.error('Error sending help response:', err);
  7297	    alert('Error sending response: ' + err.message);
  7298	    return;
  7355	  };
  7356	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7357	
  7358	  if (!curriculumDb) initCurriculumFirestore();
  7359	  const isSummer = lessonStore === 'camp';
  7360	  const updates = {};
  7361	  let weekly = null;
  7362	  if (!isSummer) {
  7363	    try { weekly = weeklyLessonTarget(semKey); } catch (err) { alert(err.message); return; }
  7364	  }
  7365	  if (isSummer) {
  7366	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7367	    updates.adminResponse = message;
  7368	    updates.lastUpdated = new Date().toISOString();
  7369	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7370	  } else {
  7371	    updates[`${weekly.prefix}${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7372	    updates[`${weekly.prefix}${key}.adminResponse`] = message;
  7373	    updates.lastUpdated = new Date().toISOString();
  7374	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7375	  }
  7376	  const docRef = isSummer
  7377	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7378	    : weekly.ref;
  7379	
  7380	  try {
  7381	    await docRef.update(updates);
  7382	  } catch (err) {
  7383	    console.error('Error sending Q&A reply:', err);
  7384	    alert('Error sending reply: ' + err.message);
  7385	    return;
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

codex
Verdict: **NOT SAFE TO DEPLOY.**

Two Studio Hub dismissal defects remain, plus the standing-notice error path and incomplete regression coverage.

## Round-1 findings

1. **RESOLVED — Spring refusal is now early, visible, and side-effect-free.**

   - Standing notice: [firebase-data.js:161](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:161), [app.js:98](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:98).
   - Plan Complete refuses before the optimistic mutation: [app.js:2881](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:2881).
   - Teacher/admin saves refuse before photo upload or UI mutation: [app.js:3512](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3512), [app.js:5640](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5640).
   - Move/swap, copy, cut, Cut Bank paste and Idea Bank paste refuse before mutation: [app.js:5954](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5954), [app.js:6232](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6232), [app.js:6345](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6345), [app.js:6509](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6509), [app.js:6982](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6982).
   - Settings refuses before `updateAppData`: [app.js:11352](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:11352).
   - Q&A writers resolve the weekly target before writing: [app.js:3739](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3739), [app.js:7272](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7272), [app.js:7361](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7361).

   I found no Spring workflow among the named writer callers that performs an external write before refusing. `saveCutProjects` currently has no production callers.

2. **RESOLVED — stale `recheckOwnDocAfterLegacyLoss()` results are token-gated.**

   The transition token is bumped by legacy and own-document snapshots; the recheck validates it before applying either success or failure: [firebase-data.js:931](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:931), [firebase-data.js:1400](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1400), [firebase-data.js:1433](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1433).

3. **NOT RESOLVED — migrated dismissals can still suppress future questions permanently.**

   Migration copies a legacy dismissal to the new semester-qualified IDs at [alerts.js:587](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:587). Those alerts are then held only in `dismissedAlerts`, not `alerts`, at [alerts.js:649](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:649).

   Resolution pruning iterates only `alerts` at [alerts.js:600](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:600). Consequently, `removeAlert()` is never called for an already-dismissed alert, and its new qualified ID is not removed from `dismissedAlertIds`. A later question in the same semester/lesson gets dismissed again.

4. **RESOLVED for last-good data — listener errors no longer erase Spring alerts.**

   The error handler retains the last source snapshot and does not rebuild destructively after a post-snapshot error: [alerts.js:624](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:624).

   There is, however, a new initial-error/migration problem listed below.

5. **NOT RESOLVED — coverage improved substantially but still misses the risky acceptance paths.**

   The new Classbook tests cover routing, transitions, standing notice, several compound workflows and helper isolation. The helper now resets in `afterEach`, is emulator-guarded, and is documented as suite-global: [spring-own-doc.spec.js:22](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/spring-own-doc.spec.js:22), [storage-move.js:18](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/helpers/storage-move.js:18).

   But the paused-workflow test at [spring-own-doc.spec.js:202](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/spring-own-doc.spec.js:202) still does not invoke teacher save, admin save, either photo flow, Plan Complete, or the three Q&A send/reply flows. The upload assertion therefore remains zero without exercising either upload-capable workflow. The token test manually increments the token rather than driving a real overlapping move/rollback.

## Additional blockers

1. **The migration-once marker can be committed from incomplete source data.**

   An initial own-document listener error is treated as though that document reported successfully at [alerts.js:631](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:631). That permits `rebuild()` to write the migration marker at [alerts.js:596](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:596) without seeing Spring’s current alerts.

   If Spring contains a question dismissed under its legacy ID, that dismissal is not migrated. On a later successful load or reload, the permanent marker prevents another attempt and the dismissed question resurfaces. The initial-error test at [alerts-classbook.test.js:89](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:89) does not combine the error with a legacy dismissal and later recovery.

2. **The standing notice is not refreshed when the migration listener fails.**

   The error callback changes `storageMigrationState` to `{}`, making Spring unwritable, but does not call `updateOwnDocPausedNotice()`: [firebase-data.js:1423](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1423). If Spring was previously verified, the standing notice can remain hidden even though every subsequent action is paused. Individual action guards still prevent writes and show the pause alert, so this is a visibility defect rather than a partial-write defect.

## Fall and other semesters

I found no new routing change for Fall or other non-own-document weekly semesters. `weeklyLessonTarget()` still returns `curriculum/lessonData` with the original `<semester>.` prefix for every semester except literal `spring-2026`: [firebase-data.js:117](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:117).

The minimum before deployment is:

- Prune resolved Classbook dismissals from both active and dismissed alert state, with a migrated-dismissal → resolved → future-question regression test.
- Do not commit the migration-once marker after an initial source error; add error-before-first-snapshot plus legacy-dismissal coverage.
- Refresh the standing notice when the migration listener enters its read-only error state.
- Exercise the remaining real Spring UI writers, especially both photo workflows and Q&A.

No files were edited and no tests were run.
tokens used
136,773
Verdict: **NOT SAFE TO DEPLOY.**

Two Studio Hub dismissal defects remain, plus the standing-notice error path and incomplete regression coverage.

## Round-1 findings

1. **RESOLVED — Spring refusal is now early, visible, and side-effect-free.**

   - Standing notice: [firebase-data.js:161](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:161), [app.js:98](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:98).
   - Plan Complete refuses before the optimistic mutation: [app.js:2881](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:2881).
   - Teacher/admin saves refuse before photo upload or UI mutation: [app.js:3512](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3512), [app.js:5640](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5640).
   - Move/swap, copy, cut, Cut Bank paste and Idea Bank paste refuse before mutation: [app.js:5954](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5954), [app.js:6232](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6232), [app.js:6345](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6345), [app.js:6509](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6509), [app.js:6982](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6982).
   - Settings refuses before `updateAppData`: [app.js:11352](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:11352).
   - Q&A writers resolve the weekly target before writing: [app.js:3739](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3739), [app.js:7272](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7272), [app.js:7361](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7361).

   I found no Spring workflow among the named writer callers that performs an external write before refusing. `saveCutProjects` currently has no production callers.

2. **RESOLVED — stale `recheckOwnDocAfterLegacyLoss()` results are token-gated.**

   The transition token is bumped by legacy and own-document snapshots; the recheck validates it before applying either success or failure: [firebase-data.js:931](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:931), [firebase-data.js:1400](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1400), [firebase-data.js:1433](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1433).

3. **NOT RESOLVED — migrated dismissals can still suppress future questions permanently.**

   Migration copies a legacy dismissal to the new semester-qualified IDs at [alerts.js:587](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:587). Those alerts are then held only in `dismissedAlerts`, not `alerts`, at [alerts.js:649](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:649).

   Resolution pruning iterates only `alerts` at [alerts.js:600](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:600). Consequently, `removeAlert()` is never called for an already-dismissed alert, and its new qualified ID is not removed from `dismissedAlertIds`. A later question in the same semester/lesson gets dismissed again.

4. **RESOLVED for last-good data — listener errors no longer erase Spring alerts.**

   The error handler retains the last source snapshot and does not rebuild destructively after a post-snapshot error: [alerts.js:624](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:624).

   There is, however, a new initial-error/migration problem listed below.

5. **NOT RESOLVED — coverage improved substantially but still misses the risky acceptance paths.**

   The new Classbook tests cover routing, transitions, standing notice, several compound workflows and helper isolation. The helper now resets in `afterEach`, is emulator-guarded, and is documented as suite-global: [spring-own-doc.spec.js:22](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/spring-own-doc.spec.js:22), [storage-move.js:18](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/helpers/storage-move.js:18).

   But the paused-workflow test at [spring-own-doc.spec.js:202](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/spring-own-doc.spec.js:202) still does not invoke teacher save, admin save, either photo flow, Plan Complete, or the three Q&A send/reply flows. The upload assertion therefore remains zero without exercising either upload-capable workflow. The token test manually increments the token rather than driving a real overlapping move/rollback.

## Additional blockers

1. **The migration-once marker can be committed from incomplete source data.**

   An initial own-document listener error is treated as though that document reported successfully at [alerts.js:631](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:631). That permits `rebuild()` to write the migration marker at [alerts.js:596](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:596) without seeing Spring’s current alerts.

   If Spring contains a question dismissed under its legacy ID, that dismissal is not migrated. On a later successful load or reload, the permanent marker prevents another attempt and the dismissed question resurfaces. The initial-error test at [alerts-classbook.test.js:89](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:89) does not combine the error with a legacy dismissal and later recovery.

2. **The standing notice is not refreshed when the migration listener fails.**

   The error callback changes `storageMigrationState` to `{}`, making Spring unwritable, but does not call `updateOwnDocPausedNotice()`: [firebase-data.js:1423](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1423). If Spring was previously verified, the standing notice can remain hidden even though every subsequent action is paused. Individual action guards still prevent writes and show the pause alert, so this is a visibility defect rather than a partial-write defect.

## Fall and other semesters

I found no new routing change for Fall or other non-own-document weekly semesters. `weeklyLessonTarget()` still returns `curriculum/lessonData` with the original `<semester>.` prefix for every semester except literal `spring-2026`: [firebase-data.js:117](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:117).

The minimum before deployment is:

- Prune resolved Classbook dismissals from both active and dismissed alert state, with a migrated-dismissal → resolved → future-question regression test.
- Do not commit the migration-once marker after an initial source error; add error-before-first-snapshot plus legacy-dismissal coverage.
- Refresh the standing notice when the migration listener enters its read-only error state.
- Exercise the remaining real Spring UI writers, especially both photo workflows and Q&A.

No files were edited and no tests were run.
