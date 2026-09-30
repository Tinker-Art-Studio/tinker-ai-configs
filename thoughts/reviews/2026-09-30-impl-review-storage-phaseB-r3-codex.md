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
session id: 01a0f097-986f-7c30-b495-27a065b288e9
--------
user
## Implementation review round 3 (narrow) — Phase B
Your round 2: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md. A Claude round 2 also ran: .../2026-09-30-impl-review-storage-phaseB-r2-claude.md (its verdict: no code blockers; items: commit/test state, a test writing slots into shared emulator data, manager-gating the storage section).
Now committed and pushed:
- Studio Hub full diff: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-studiohub.diff (worktree read-only /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc)
- Classbook changes since your round 2: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-classbook-delta.diff (worktree read-only /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81)
Check only your round-2 minimum list (dismissal pruning of answered questions; no migration marker after an initial source error; notice on migration-listener error; real-UI Spring writers incl. photos and Q&A) and the Claude items: RESOLVED / NOT with file:line, plus anything the fixes introduced (e.g. the prune deleting dismissals it shouldn't — other alert types, other Classbook ids; the marker id in the dismissed set). One-line verdict: SAFE TO DEPLOY or NOT (minimum list). Be brief. Do not edit files or run tests.
codex
I’ll do a read-only diff/source review limited to the named round-2 items and regressions introduced by those fixes. I won’t edit files or run tests.
exec
/bin/zsh -lc "sed -n '1,240p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md
sed -n '1,240p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-claude.md
sed -n '1,260p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-classbook-delta.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
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
I reviewed the code on disk in both worktrees (not only the two diffs — see the note at the end, which matters).

## 1. Round-1 findings

**Finding 1 — Spring's paused state neither visible nor side-effect-free: RESOLVED.**

- Standing notice: `updateOwnDocPausedNotice()` `js/firebase-data.js:177`, called on load (`js/app.js:172`), on every semester change (`js/app.js:101`), and on every state change (`js/firebase-data.js:940, 1427, 1428, 1449, 1455`). Styled `.storage-notice` `css/styles.css:2430`.
- A common preflight, `refuseIfWeeklySemesterPaused()` `js/firebase-data.js:169`, is called before the *first* change in every workflow the finding named: `saveTeacherEdit` `js/app.js:3513` (before the Storage upload at `3535`), `saveAdminEdit` `js/app.js:5641` (before `caEditSaveInFlight` and the upload at `5810`), the Plan Complete checkbox `js/app.js:2881` (before the optimistic `lesson.planComplete` at `2883`), `cutProject` `js/app.js:6348` (before the Cut Bank write at `6390` — no more deliberate duplicate), `saveSettings` `js/app.js:11363` (before `updateAppData` at `11452` and the slot write at `11469`), plus `handleGridAction:5957`, `executeCopyPlan:6235`, `pasteFromCutBank:6512`, `pasteFromIdeaBank:6984`.
- The three Q&A senders resolve their target before any write and surface the exact message: `js/app.js:3739`, `7272`, `7361`.
- The specific message survives the catch paths: `js/app.js:3660` (teacher save), `2894` (Plan Complete), `5847` (admin edit).

**Finding 2 — `recheckOwnDocAfterLegacyLoss()` installing stale state: RESOLVED.** `ownDocTransitionToken` / `bumpOwnDocToken` `js/firebase-data.js:194`, bumped on every legacy snapshot (`1400`) and every own-doc snapshot (`1433`); the recheck applies only if the token still matches *and* the source isn't already `ownDoc` (`936`), and the "moved — reload" notice is likewise token-gated (`947`). Each recheck gets a unique token, so only the newest can apply; a superseding legacy snapshot restarts a fresh recheck, so it self-heals rather than stalling.

**Finding 3 — Studio Hub legacy dismissal kept forever: RESOLVED, and then some.** The one-time migration converts open legacy ids and *retires* the ones it converted, behind a marker (`studio-hub/js/alerts.js:591-602`). On disk it now also prunes any `classbook-qa-*` dismissal that is no longer an open question (`alerts.js:613-625`), so an answered-then-re-asked question alerts again — that block is **not in the diff you gave me**.

**Finding 4 — Spring alerts dropped on an own-doc listener error: RESOLVED.** The error handler keeps the last good snapshot and only marks the document as reported when none ever arrived (`alerts.js:652-662`); a first-snapshot failure is tracked in `failedBeforeFirst` (`alerts.js:572`) and suppresses both migration and pruning while degraded (`alerts.js:590`). Residual, pre-existing and unchanged: a `lessonData` listener error *before its first* snapshot leaves `rebuild()` permanently gated, so no Classbook alerts at all (`alerts.js:639-641`).

**Finding 5 — tests: PARTLY RESOLVED.** New `e2e/spring-own-doc.spec.js` (14 tests), `studio-hub/alerts-classbook.test.js` (the real `AlertEngine` in a vm, incl. migration and both error orderings), `classbook-qa-alerts.test.js`, and two ratchets. The admin helper is properly fenced (`e2e/helpers/storage-move.js:76-84` reuses `requireEmulatorEnv` + a `demo-` project check; no credential file, `firebase-admin` is a real dependency), and it now resets in `beforeEach` **and** `afterEach` with the suite-global caveat documented (`spring-own-doc.spec.js:148-151`). Gaps still open — see §3.

## 2. Adversarial pass on the whole change

**Every caller of the writers, checked for a write-before-refusal.** `saveSingleLesson` has 8 call sites: `js/app.js:1815` (SDOC) and `2367`, `12093` (summer) can't be a weekly semester; the other five are guarded above. `saveMultipleLessonFields` (`6020, 6093, 6114`) is `handleGridAction` only. `deleteLessonKey` (`6401`) is `cutProject` only. `saveLessonData` (`5038` `createNewSemester`, `11558` `createLessonSlotsForRoster`) — the first is unreachable for `spring-2026` (the key-exists checks at `js/app.js:4937` and `5050` refuse it, and `deleteSemester` can no longer remove it), the second sits behind `saveSettings`' guard. `deleteLessonData` refuses own-doc semesters itself (`js/firebase-data.js:1164`) and `deleteSemester` refuses before touching `appData` (`js/app.js:4599`). `uploadLessonPhoto`'s only two callers are both downstream of a guard. `saveCutProjects` has no callers. `restoreFromBackup` has no UI caller. **No Spring workflow writes anything before refusing.**

Deliberately still writable for Spring while paused, all single atomic writes with no half-state: `deleteCutProject` (`js/app.js:6690`), the source-side `arrayRemove` when pasting *out of* Spring's cut bank (`6583`), `toggleSemesterPublish` (`4677`), prep data and change-log. Those documents aren't moving, so that's consistent with the plan's scope — worth Christie knowing the pause means "lesson editing", not "Spring is frozen".

**Fall and other semesters.** `weeklyLessonTarget` returns the identical ref and `${semKey}.` prefix for anything not in `OWN_DOC_SEMESTERS` (`js/firebase-data.js:119`); `buildLessonFieldUpdates` keeps the old default prefix (`1718`); `readWeeklySemesterMap` does exactly one legacy read for Fall (`131`). The listener's new loop only touches `spring-2026`. I found no behavioural change for Fall. Two costs: `computeLiveContentCountByTeacher` now does one extra `get` per own-doc semester even pre-move (`js/app.js:7616`), and the legacy snapshot handler calls `doc.data()` twice (`1396-1397`), decoding a ~1 MB document twice per snapshot. Both acceptable; the second is easy to halve later.

**Token logic / transitions.** Move-then-own-doc and own-doc-then-move both land on `ownDoc` without blanking; `previousOwn` carry-across (`1394-1409`) means Spring is never emptied; `error` is sticky and unwritable by design. One cosmetic rough edge: on a rollback whose *own-doc* snapshot arrives before the legacy one, `lastLegacyLessonData` doesn't yet hold Spring, so a spurious "storage changed — please reload" banner flashes before the legacy snapshot hides it (`1442-1444`, then `1407`). Nothing blanks; the tested ordering is the other one.

**Writability can only be wrong in the safe direction.** `ownDocSource` starts `{}` and `storageMigrationState` starts `null`, so Spring is paused until both are known, and a failed read of either keeps it paused. Writes reach `lessons_spring-2026` only when it exists *and* `verified === true`; `verified` is one-way and delete-after-verified is denied in the live rules, so the client's writable window is a strict subset of what the rules permit. I confirmed against the deployed Phase A rules that classbook teachers can *read* both `lessons_spring-2026` and `storageMigrations` (`studio-hub/firestore.rules:711`) — without that read the pause would never lift for teachers in Phase C.

**Standing notice vs. guards.** The notice reads `globalSemesterKey`; the guards read `getActiveSemesterKey()`, which falls back to `activeSemester` when the global key is unset. `initGlobalSemesterSelector()` (`js/app.js:65-70`) always sets a real key before `loadLessonData()`, so they agree in practice. Only a degenerate "no visible semesters" state diverges, and there it fails safe (actions refuse, notice hidden).

**Studio Hub.** The union rebuild is correct; `CLASSBOOK_OWN_DOC_SEMESTERS` is a top-level `const` in a script loaded before `alerts.js` (`index.html:224`), so the global binding resolves. `type: 'curriculum'` is produced nowhere else, so the prune loop can't evict another feature's alerts. The re-key is the only breaking change and `legacyId` covers it.

## 3. Verdict: **NOT SAFE TO DEPLOY as it stands** — no code blocker remains; the list is procedural plus one test fix.

1. **Both diffs are stale, and the Classbook tree is dirty.** Classbook HEAD is `a7f0d0e` but `git status` shows `js/firebase-data.js` and `e2e/spring-own-doc.spec.js` modified — an extra `updateOwnDocPausedNotice()` in the `storageMigrations` error handler, plus two substantial new tests (a real-UI paused test covering teacher/admin editors with photos, all three Q&A senders and Plan Complete; and a real overlapping move→undo race). Studio Hub's `js/alerts.js` **changed between two reads during this review** (the `failedBeforeFirst` and dismissal-pruning blocks). Commit and push both sides, then re-diff — `npm run deploy` refuses a dirty tree or unpushed HEAD anyway, and neither deploy should ship bytes nobody reviewed.
2. **Run both suites against the committed state.** I did not run them, as instructed, and I can't vouch for the two new Classbook tests or the three new Studio Hub ones. Classbook: `npm test`. Studio Hub: `npm test` (its `test:rules` now also runs `classbook-qa-alerts.test.js` and `alerts-classbook.test.js`).
3. **Fix the test-isolation leak introduced in `e2e/data-safety.spec.js:8702-8710`.** Cloning `spring-2026` into a throwaway `e2e-settings-weekly` and calling the real `saveSettings()` mocks only `updateAppData` — `createLessonSlotsForRoster` (`js/app.js:11469`) still runs and really writes 28 empty slots under `e2e-settings-weekly` into the emulator's shared `curriculum/lessonData` via `saveLessonData` (`js/app.js:11558`). The `finally` at `8719` removes only the in-memory config entry. Harmless to production and to the content-count assertions (the slots carry no content), but it pollutes the shared seed for the rest of the run. Stub `createLessonSlotsForRoster`, give the throwaway an empty `classRoster`, or delete the key from Firestore in the `finally`.

Recommended but not blocking: cover the *verified* state through at least one real UI path (teacher save + admin move/swap) so Phase C's flip is exercised end-to-end rather than only through the low-level writers; test the >85% headroom warning branch; and decide whether the new "Lesson Storage" section should be manager-gated, as the plan specified Diagnostics/managers (`index.html:354`).

No files were edited and no tests were run.
diff --git a/e2e/data-safety.spec.js b/e2e/data-safety.spec.js
index 6037ce7..85e7285 100644
--- a/e2e/data-safety.spec.js
+++ b/e2e/data-safety.spec.js
@@ -8699,7 +8699,9 @@ test.describe('Data Safety — camp seasons Phase 1: implementation-review regre
         // weekly semester: the seeded spring-2026 is view-only while it moves to
         // its own storage (Spring 2026 storage move), and saveSettings refuses it.
         const previousGlobal = globalSemesterKey;
-        currentConfig.semesters['e2e-settings-weekly'] = { ...JSON.parse(JSON.stringify(currentConfig.semesters['spring-2026'])), name: 'E2E Settings Weekly' };
+        // Empty roster: saveSettings' slot creation then writes nothing to the shared
+        // emulator lessonData (the real updateAppData is stubbed below).
+        currentConfig.semesters['e2e-settings-weekly'] = { ...JSON.parse(JSON.stringify(currentConfig.semesters['spring-2026'])), name: 'E2E Settings Weekly', classRoster: {} };
         setGlobalSemester('e2e-settings-weekly');
         loadSettingsForm();
         const semKey = getSettingsSemKey();
diff --git a/e2e/spring-own-doc.spec.js b/e2e/spring-own-doc.spec.js
index 7ca2a71..2220f4b 100644
--- a/e2e/spring-own-doc.spec.js
+++ b/e2e/spring-own-doc.spec.js
@@ -277,4 +277,126 @@ test.describe('Spring 2026 storage move — Phase B', () => {
     expect(cards.indexOf('refuseIfWeeklySemesterPaused(')).toBeGreaterThan(-1);
     expect(cards.indexOf('refuseIfWeeklySemesterPaused(')).toBeLessThan(cards.indexOf('{ planComplete: cb.checked }'));
   });
+
+  test('while paused, the real Spring editors refuse before any upload or write (teacher + admin with photos, Plan Complete, all Q&A)', async ({ page }) => {
+    await openApp(page);
+    await page.evaluate(() => setGlobalSemester('spring-2026'));
+    const alerts = [];
+    page.on('dialog', d => { alerts.push(d.message()); d.accept(); });
+    const before = await SM.readCurriculumDoc('lessonData');
+    await page.evaluate(() => { window.__uploads = 0; window.uploadLessonPhoto = async () => { window.__uploads++; return { url: 'x', path: 'x' }; }; });
+    const photo = path.join(__dirname, 'fixtures', 'test-image.jpg');
+    const expectPaused = async (label) => {
+      await expect.poll(() => alerts.join(' | '), { message: label, timeout: 5_000 }).toMatch(PAUSED);
+      alerts.length = 0;
+    };
+
+    // Teacher editor: a text change + a new photo, then Save.
+    await page.evaluate(({ LESSON }) => openTeacherEditModal(LESSON), { LESSON });
+    await page.locator('#te-shortDetails').fill('Edited while paused');
+    await page.locator('#te-photo-input').setInputFiles(photo);
+    await page.locator('#te-save-btn').click();
+    await expectPaused('teacher save');
+    // Teacher Q&A from the same editor.
+    await page.locator('#te-qa-input').fill('A question while paused');
+    await page.locator('#te-qa-send-btn').click();
+    await expectPaused('teacher Q&A');
+    await page.evaluate(() => document.querySelectorAll('.te-modal-overlay, .te-modal').forEach(e => e.remove()));
+
+    // Admin editor: title + photo, then save.
+    await page.evaluate(({ LESSON }) => showAdminEdit(LESSON, 'Fixture Teacher', 'Fixture Class', 1), { LESSON });
+    await page.locator('#ca-edit-title').fill('Admin edit while paused');
+    await page.locator('#ca-edit-photo-input').setInputFiles(photo);
+    await page.evaluate(({ LESSON }) => saveAdminEdit(LESSON, 'Fixture Teacher', 'Fixture Class', 1), { LESSON });
+    await expectPaused('admin save');
+
+    // Admin help response + Q&A reply (their real input elements).
+    await page.evaluate(({ LESSON }) => {
+      for (const id of [`ca-help-input-${LESSON}`, `qa-reply-${LESSON}`]) {
+        const t = document.createElement('textarea'); t.id = id; t.value = 'Reply while paused'; document.body.appendChild(t);
+      }
+    }, { LESSON });
+    await page.evaluate(({ LESSON }) => sendHelpResponse(LESSON), { LESSON });
+    await expectPaused('help response');
+    await page.evaluate(({ LESSON }) => sendQaReply(LESSON), { LESSON });
+    await expectPaused('Q&A reply');
+
+    // Plan Complete checkbox on a real Teacher View card.
+    await page.evaluate(() => { closeAdminModal?.(true); switchTab('teacher-view'); });
+    await page.locator('#tv-teacher-select').selectOption('Fixture Teacher');
+    await page.locator('.tv-toggle-btn[data-tv-view="by-class"]').click();   // the card layout that carries Plan Complete
+    const cb = page.locator(`#pc-${LESSON}`);
+    await expect(cb).toHaveCount(1);
+    if (!(await cb.isVisible())) await page.locator('.tv-class-section.tv-collapsed .tv-collapse-toggle').first().click();   // open the collapsed class section
+    await expect(cb).toBeVisible();
+    const wasChecked = await cb.isChecked();
+    await cb.click();
+    await expectPaused('plan complete');
+    expect(await cb.isChecked()).toBe(wasChecked);
+
+    expect(await page.evaluate(() => window.__uploads)).toBe(0);
+    expect(await SM.readCurriculumDoc('lessonData')).toEqual(before);
+  });
+
+  test('a real overlapping move → undo while a recheck is in flight leaves Spring on its legacy copy, with no false notice', async ({ page }) => {
+    await openApp(page);   // legacy state
+    // Hold the recheck's server read of the own doc for 2 s, so the undo lands while it's in flight.
+    await page.evaluate(() => {
+      const DR = firebase.firestore.DocumentReference.prototype;
+      const orig = DR.get;
+      DR.get = function (opts) {
+        if (this.path === 'curriculum/lessons_spring-2026' && opts?.source === 'server') {
+          return new Promise(r => setTimeout(r, 2000)).then(() => orig.call(this, opts));
+        }
+        return orig.call(this, opts);
+      };
+    });
+    await watchMinSpring(page);
+    // 1. Spring leaves lessonData (legacy loss → recheck starts, held)…
+    const fixtureLessonData = await SM.readCurriculumDoc('lessonData');
+    const withoutSpring = { ...fixtureLessonData }; delete withoutSpring['spring-2026'];
+    await SM.writeCurriculumDoc('lessonData', withoutSpring);
+    await page.waitForTimeout(300);
+    // 2. …then comes straight back (the undo), before the held read returns.
+    await SM.writeCurriculumDoc('lessonData', fixtureLessonData);
+    await page.waitForTimeout(3000);   // the held read resolves (own doc absent) — must be ignored
+    expect(await source(page)).toBe('legacy');
+    expect(await springKeys(page)).toEqual(fixtureKeys());
+    expect(await minSpring(page)).toBe(fixtureKeys().length);
+    expect(await page.evaluate(() => { const el = document.getElementById('storage-notice-banner'); return !!el && !el.classList.contains('hidden'); })).toBe(false);
+  });
+
+  test('verified: the real teacher editor saves Spring into its own doc', async ({ page }) => {
+    await SM.stageMoved({ verified: true });
+    await openApp(page);
+    await page.waitForFunction(() => ownDocSource['spring-2026'] === 'ownDoc' && storageMigrationState?.['spring-2026']?.verified === true);
+    await page.evaluate(() => setGlobalSemester('spring-2026'));
+    await expect(page.locator('#own-doc-paused-notice')).toHaveCount(0);
+    const alerts = [];
+    page.on('dialog', d => { alerts.push(d.message()); d.accept(); });
+    await page.evaluate(({ LESSON }) => openTeacherEditModal(LESSON), { LESSON });
+    await page.locator('#te-shortDetails').fill('Saved through the real editor');
+    await page.locator('#te-save-btn').click();
+    await expect.poll(async () => (await SM.readCurriculumDoc(SM.SPRING_DOC))?.[LESSON]?.shortDetails, { timeout: 10_000 }).toBe('Saved through the real editor');
+    expect(alerts.join(' | ')).not.toMatch(PAUSED);
+    expect((await SM.readCurriculumDoc('lessonData'))['spring-2026']).toBeUndefined();
+  });
+
+  test('Lesson Storage warns above 85%, and is a manager-only section', async ({ page, browser }) => {
+    await openApp(page);   // the suite's account: staff (curriculum-admin)
+    await expect(page.locator('.ca-lesson-storage-section')).toBeHidden();
+    const text = await page.evaluate(() => {
+      lastLegacyLessonData = { big: 'x'.repeat(900 * 1024) };
+      renderLessonStorage();
+      return document.getElementById('ca-lesson-storage-content').textContent;
+    });
+    expect(text).toMatch(/nearly full/);
+    const { MANAGER_STATE_PATH } = require('./helpers/login');
+    const ctx = await browser.newContext({ storageState: MANAGER_STATE_PATH });
+    const mgr = await ctx.newPage();
+    await login(mgr, 'manager');
+    await mgr.waitForFunction(() => lessonDataLoadedSuccessfully === true, null, { timeout: 25_000 });
+    await expect(mgr.locator('.ca-lesson-storage-section')).toBeVisible();
+    await ctx.close();
+  });
 });
diff --git a/js/app.js b/js/app.js
index af3745d..f5dce8c 100644
--- a/js/app.js
+++ b/js/app.js
@@ -325,6 +325,9 @@ function setupRoleAccess() {
   // Manager+: full access to all tabs including Settings
   if (user.role === 'admin' || user.role === 'manager') return;
 
+  // Lesson Storage headroom (Spring 2026 storage move) is a manager readout.
+  document.querySelector('.ca-lesson-storage-section')?.style.setProperty('display', 'none');
+
   // classbook-admin / curriculum-admin / prep role: all tabs EXCEPT Settings
   // Settings is manager+ only — classbook admins can't change semester config
   if (hasCurriculumAdminAccess() || hasPrepAccess()) {
diff --git a/js/firebase-data.js b/js/firebase-data.js
index 656abef..3138c56 100644
--- a/js/firebase-data.js
+++ b/js/firebase-data.js
@@ -1425,7 +1425,7 @@ function setupLessonDataListener(callback) {
       if (snap.metadata.fromCache && !snap.metadata.hasPendingWrites) return;
       storageMigrationState = snap.exists ? (snap.data() || {}) : {};
       updateOwnDocPausedNotice();
-    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; }));
+    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; updateOwnDocPausedNotice(); }));
   for (const semKey of OWN_DOC_SEMESTERS) {
     ownDocUnsubscribes.push(curriculumDb.collection('curriculum').doc(ownDocIdFor(semKey))
       .onSnapshot({ includeMetadataChanges: false }, snap => {

exec
/bin/zsh -lc "rg -n \"Finding|Verdict|NOT SAFE|SAFE TO|migration|dismiss|listener|real-UI|real UI|manager|slot|shared emulator\" /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-claude.md
sed -n '1,320p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-studiohub.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-claude.md:5:**Finding 1 — Spring's paused state neither visible nor side-effect-free: RESOLVED.**
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-claude.md:8:- A common preflight, `refuseIfWeeklySemesterPaused()` `js/firebase-data.js:169`, is called before the *first* change in every workflow the finding named: `saveTeacherEdit` `js/app.js:3513` (before the Storage upload at `3535`), `saveAdminEdit` `js/app.js:5641` (before `caEditSaveInFlight` and the upload at `5810`), the Plan Complete checkbox `js/app.js:2881` (before the optimistic `lesson.planComplete` at `2883`), `cutProject` `js/app.js:6348` (before the Cut Bank write at `6390` — no more deliberate duplicate), `saveSettings` `js/app.js:11363` (before `updateAppData` at `11452` and the slot write at `11469`), plus `handleGridAction:5957`, `executeCopyPlan:6235`, `pasteFromCutBank:6512`, `pasteFromIdeaBank:6984`.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-claude.md:12:**Finding 2 — `recheckOwnDocAfterLegacyLoss()` installing stale state: RESOLVED.** `ownDocTransitionToken` / `bumpOwnDocToken` `js/firebase-data.js:194`, bumped on every legacy snapshot (`1400`) and every own-doc snapshot (`1433`); the recheck applies only if the token still matches *and* the source isn't already `ownDoc` (`936`), and the "moved — reload" notice is likewise token-gated (`947`). Each recheck gets a unique token, so only the newest can apply; a superseding legacy snapshot restarts a fresh recheck, so it self-heals rather than stalling.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-claude.md:14:**Finding 3 — Studio Hub legacy dismissal kept forever: RESOLVED, and then some.** The one-time migration converts open legacy ids and *retires* the ones it converted, behind a marker (`studio-hub/js/alerts.js:591-602`). On disk it now also prunes any `classbook-qa-*` dismissal that is no longer an open question (`alerts.js:613-625`), so an answered-then-re-asked question alerts again — that block is **not in the diff you gave me**.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-claude.md:16:**Finding 4 — Spring alerts dropped on an own-doc listener error: RESOLVED.** The error handler keeps the last good snapshot and only marks the document as reported when none ever arrived (`alerts.js:652-662`); a first-snapshot failure is tracked in `failedBeforeFirst` (`alerts.js:572`) and suppresses both migration and pruning while degraded (`alerts.js:590`). Residual, pre-existing and unchanged: a `lessonData` listener error *before its first* snapshot leaves `rebuild()` permanently gated, so no Classbook alerts at all (`alerts.js:639-641`).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-claude.md:18:**Finding 5 — tests: PARTLY RESOLVED.** New `e2e/spring-own-doc.spec.js` (14 tests), `studio-hub/alerts-classbook.test.js` (the real `AlertEngine` in a vm, incl. migration and both error orderings), `classbook-qa-alerts.test.js`, and two ratchets. The admin helper is properly fenced (`e2e/helpers/storage-move.js:76-84` reuses `requireEmulatorEnv` + a `demo-` project check; no credential file, `firebase-admin` is a real dependency), and it now resets in `beforeEach` **and** `afterEach` with the suite-global caveat documented (`spring-own-doc.spec.js:148-151`). Gaps still open — see §3.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-claude.md:26:**Fall and other semesters.** `weeklyLessonTarget` returns the identical ref and `${semKey}.` prefix for anything not in `OWN_DOC_SEMESTERS` (`js/firebase-data.js:119`); `buildLessonFieldUpdates` keeps the old default prefix (`1718`); `readWeeklySemesterMap` does exactly one legacy read for Fall (`131`). The listener's new loop only touches `spring-2026`. I found no behavioural change for Fall. Two costs: `computeLiveContentCountByTeacher` now does one extra `get` per own-doc semester even pre-move (`js/app.js:7616`), and the legacy snapshot handler calls `doc.data()` twice (`1396-1397`), decoding a ~1 MB document twice per snapshot. Both acceptable; the second is easy to halve later.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-claude.md:36:## 3. Verdict: **NOT SAFE TO DEPLOY as it stands** — no code blocker remains; the list is procedural plus one test fix.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-claude.md:38:1. **Both diffs are stale, and the Classbook tree is dirty.** Classbook HEAD is `a7f0d0e` but `git status` shows `js/firebase-data.js` and `e2e/spring-own-doc.spec.js` modified — an extra `updateOwnDocPausedNotice()` in the `storageMigrations` error handler, plus two substantial new tests (a real-UI paused test covering teacher/admin editors with photos, all three Q&A senders and Plan Complete; and a real overlapping move→undo race). Studio Hub's `js/alerts.js` **changed between two reads during this review** (the `failedBeforeFirst` and dismissal-pruning blocks). Commit and push both sides, then re-diff — `npm run deploy` refuses a dirty tree or unpushed HEAD anyway, and neither deploy should ship bytes nobody reviewed.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-claude.md:40:3. **Fix the test-isolation leak introduced in `e2e/data-safety.spec.js:8702-8710`.** Cloning `spring-2026` into a throwaway `e2e-settings-weekly` and calling the real `saveSettings()` mocks only `updateAppData` — `createLessonSlotsForRoster` (`js/app.js:11469`) still runs and really writes 28 empty slots under `e2e-settings-weekly` into the emulator's shared `curriculum/lessonData` via `saveLessonData` (`js/app.js:11558`). The `finally` at `8719` removes only the in-memory config entry. Harmless to production and to the content-count assertions (the slots carry no content), but it pollutes the shared seed for the rest of the run. Stub `createLessonSlotsForRoster`, give the throwaway an empty `classRoster`, or delete the key from Firestore in the `finally`.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-claude.md:42:Recommended but not blocking: cover the *verified* state through at least one real UI path (teacher save + admin move/swap) so Phase C's flip is exercised end-to-end rather than only through the low-level writers; test the >85% headroom warning branch; and decide whether the new "Lesson Storage" section should be manager-gated, as the plan specified Diagnostics/managers (`index.html:354`).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:21:2. Adversarially check the fixes and the whole change again: any Spring workflow that still writes something before refusing (search every caller of saveSingleLesson / saveMultipleLessonFields / deleteLessonKey / saveLessonData / uploadLessonPhoto / saveCutProjects / updateAppData that can act on a weekly semester); anything that changes behaviour for Fall or other semesters; the token logic; the standing notice; the Studio Hub migration-once marker and error handling; test quality.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:22:Verdict: SAFE TO DEPLOY or NOT (minimum list). Do not edit files or run tests.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:49:2. Listener logic: initial load vs listener ordering, the legacy carry-across, recheckOwnDocAfterLegacyLoss, the move and rollback transitions, error states, teardown/double registration, interaction with globalListenerGeneration / reloadSummer / lessonDataLoadedSuccessfully, SDOC and camp seasons.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:51:4. Studio Hub alerts: union/rebuild correctness, dismissal migration, cleanup, errors.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:53:Verdict: SAFE TO DEPLOY or NOT (minimum list). Do not edit files or run tests.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:55:I’ll review the plan, both supplied diffs, and the surrounding reader/writer/listener code in each worktree. I’ll keep this strictly read-only and won’t run tests; the final verdict will separate deploy blockers from lower-risk gaps.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:126:  <tr><td>The 13 in-app <code>doc('lessonData')</code> sites. Reads: <code>:762</code> load, <code>:975</code> <code>readServerSemesterLessonMap</code>, <code>:1171</code> listener, <code>app.js:5835</code> <code>readAdminLessonDoc</code>, <code>app.js:7518</code> <code>computeLiveContentCountByTeacher</code>. Writes: <code>:817</code> <code>saveLessonData</code> (whole-semester merge-set), <code>:830</code> <code>deleteLessonKey</code>, <code>:963</code> <code>deleteLessonData</code>, <code>:1438</code> <code>saveSingleLesson</code>, <code>:1500</code> <code>saveMultipleLessonFields</code>, <code>app.js:3690</code> <code>sendTeacherQaMessage</code>, <code>:7202</code> <code>sendHelpResponse</code>, <code>:7285</code> <code>sendQaReply</code>. Dead code: <code>backupLessonData</code>/<code>restoreFromBackup</code> (<code>:979-1002</code>, no callers).</td><td>as cited</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:127:  <tr><td><strong>The live listener replaces the whole model</strong>: <code>currentLessonData = doc.data()</code> (<code>:1186</code>), carrying across only camp/SDOC maps through <code>snapshotCampSeasons()</code> (<code>:1094-1100</code>). It bumps <code>globalListenerGeneration</code> (<code>:1181</code>), which gates the summer reload, and a superseded reload never sets <code>lessonDataLoadedSuccessfully</code> (<code>:1131, 1143-1145</code>). It's registered from two places (<code>app.js:676</code>, <code>:5038</code>) with one unsubscribe handle (<code>:1116</code>).</td><td>as cited</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:129:  <tr><td>Rules: <code>:654</code> is <code>allow read, write: if isManagerOrAbove()</code>, and <code>:666</code> is a separate create/update for classbook roles (not appData/prepCycleConfig). Rules OR across statements, so fencing a key for managers too means <strong>splitting <code>:654</code></strong> into per-operation statements. Whole-doc delete is limited to classbook-admin/curriculum-admin (<code>:675-678</code>). <code>studio-hub/rules.test.js</code> has no <code>curriculum/lessonData</code> fixture today.</td><td><code>studio-hub/firestore.rules:652-678</code></td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:154:  <li>No role can create, add to, or change the <code>spring-2026</code> key, with exactly two manager/admin exceptions. (1) An update that <em>only deletes</em> it, for the Phase C transaction. (2) The <strong>rollback</strong>: an update that <em>only re-adds</em> it, allowed only while <code>storageMigrations.spring-2026.verified != true</code> and only if <code>getAfter(lessons_spring-2026)</code> shows that document deleted in the same transaction (Codex round 2, fix 1).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:158:<p>For <code>curriculum/lessons_spring-2026</code>: create by a manager only, and only if it doesn't exist. Updates only when <code>storageMigrations.spring-2026.verified == true</code>, for the roles that can update lessons today. Whole-doc delete by <strong>manager/admin only, and only while not yet verified</strong> (the rollback). classbook-admin and curriculum-admin may never delete it, and <strong>nobody</strong> may delete it after verification, until the follow-up plan adds a routed delete/archive (Codex round 2, fix 2).</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:159:<p>For <code>curriculum/storageMigrations</code>: manager write, and read for the classbook roles.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:161:<p><strong>Shape:</strong> split <code>:654</code> (<code>allow read, write: if isManagerOrAbove()</code>) into <code>read</code> / <code>create</code> / <code>update</code> / <code>delete</code> statements, because rules OR across statements. Manager <code>delete</code> is kept for every curriculum doc except <code>lessonData</code>. The classbook-role statements at <code>:666</code> and <code>:675-678</code> get the same <code>lessonData</code>/<code>lessons_spring-2026</code> conditions. The <code>lessonData</code> update condition is <code>!affectedKeys().hasAny(['spring-2026'])</code>, OR (manager/admin, removal) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; !('spring-2026' in request.resource.data)</code>, OR (manager/admin, <strong>rollback re-add</strong>) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; ('spring-2026' in request.resource.data) &amp;&amp; !('spring-2026' in resource.data) &amp;&amp; !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026) &amp;&amp; get(/databases/$(database)/documents/curriculum/storageMigrations).data.get('spring-2026', {}).get('verified', false) != true</code>. Every split statement is constrained this way, because <code>allow</code> statements OR together.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:162:<div class="bdd">Rules tests (studio-hub/rules.test.js), roles: teacher (classbook), classbook-admin, curriculum-admin, manager, admin.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:165:  lessonData update { spring-2026: delete } only                    → manager/admin allowed; others denied
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:170:  rollback: manager/admin re-adds only spring-2026 AND deletes lessons_spring-2026 in one transaction, while unverified → allowed
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:173:  lessons_spring-2026 create when absent                            → manager/admin allowed; others denied
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:175:  lessons_spring-2026 delete before verified                        → manager/admin allowed (rollback); teacher/classbook-admin/curriculum-admin denied
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:177:  storageMigrations write                                           → manager/admin only; read → classbook roles
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:187:  <li><strong>The listener doesn't drop Spring</strong> (round 1 A). The legacy snapshot's swap carries own-doc semesters across, the way it already carries camp seasons. The <code>lessons_K</code> listener updates only <code>currentLessonData[K]</code>, doesn't bump <code>globalListenerGeneration</code>, and never touches <code>lessonDataLoadedSuccessfully</code>. Its errors go to a visible banner and make Spring unwritable.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:194:    The whole teardown uses one unsubscribe array (the listener is registered from <code>app.js:676</code> and <code>:5038</code>).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:195:  <li><strong>Writes to Spring:</strong> they go to <code>lessons_K</code> only when <code>storageMigrations.spring-2026.verified</code> is true, read by a small <code>storageMigrations</code> listener. Otherwise the app shows the "editing is paused" message; the rules refuse those writes anyway. <code>not-found</code> is handled the same way.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:198:  <li><strong>Headroom readout</strong> in Curriculum Admin → Diagnostics (managers): an approximate Firestore-size estimate of <code>lessonData</code>, using the same field-size method as the Sep 29 snippet (not <code>JSON.stringify</code> length). It's labelled "approx.", and it warns above 85%, a conservative buffer.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:199:  <li><strong>Studio Hub alerts</strong> (Codex 6). The listener keeps per-source state: legacy <code>lessonData</code>, plus <code>lessons_spring-2026</code>. It reconciles the <em>union</em>, so each source's snapshot no longer removes the other's alerts. It prefers the own-doc copy for Spring. Alert IDs become <code>classbook-qa-&lt;semKey&gt;-&lt;lessonKey&gt;</code>, fixing today's cross-semester collisions. Studio Hub stores dismissals <em>by ID</em> (<code>alerts.js:6-7, 54-68, 654</code>), so an alert also counts as dismissed if its <strong>old</strong> ID <code>classbook-qa-&lt;lessonKey&gt;</code> is in the dismissed set. This is a one-line compatibility check in <code>addOrUpdateAlert</code>, so nothing already dismissed comes back (Codex round 2, fix 3). An old dismissal applies to that lesson key in every semester, which matches today's behaviour, since today the two collide into one alert.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:200:  <li><strong>Ratchet:</strong> no <code>doc('lessonData')</code> in the loaded scripts outside the helpers, the legacy load/listener and the dead backup helpers. <code>e2e/</code> is exempt. The seed gains a <code>lessons_spring-2026</code> + <code>storageMigrations</code> fixture set for the own-doc scenarios, and the default seed is unchanged.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:216:Scenario: own-doc listener error → banner, Spring unwritable, Fall unaffected
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:220:Scenario: Studio Hub: an alert dismissed under its old ID stays dismissed after the re-key
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:225:<h3>Phase C: move Spring in one step (production, one-off, manager) <span class="status-tag ready">execution-ready: true</span></h3>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:232:<p><strong>How:</strong> a console procedure that Christie pastes while signed in as manager. The procedure is written into this plan and reviewed before execution, and rehearsed in the emulator by an e2e test that runs the same code.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:244:  <li><strong>If it fails:</strong> nothing has been edited since the copy, so the reverse transaction is safe: it puts <code>map</code> back into <code>lessonData</code>, which Phase A's rollback allowance permits (a manager/admin, only this key, only while unverified, and only together with deleting <code>lessons_spring-2026</code>), deletes <code>lessons_spring-2026</code>, and records the failure. The download from step 1 remains the last resort.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:316:  <tr><td>The 13 in-app <code>doc('lessonData')</code> sites. Reads: <code>:762</code> load, <code>:975</code> <code>readServerSemesterLessonMap</code>, <code>:1171</code> listener, <code>app.js:5835</code> <code>readAdminLessonDoc</code>, <code>app.js:7518</code> <code>computeLiveContentCountByTeacher</code>. Writes: <code>:817</code> <code>saveLessonData</code> (whole-semester merge-set), <code>:830</code> <code>deleteLessonKey</code>, <code>:963</code> <code>deleteLessonData</code>, <code>:1438</code> <code>saveSingleLesson</code>, <code>:1500</code> <code>saveMultipleLessonFields</code>, <code>app.js:3690</code> <code>sendTeacherQaMessage</code>, <code>:7202</code> <code>sendHelpResponse</code>, <code>:7285</code> <code>sendQaReply</code>. Dead code: <code>backupLessonData</code>/<code>restoreFromBackup</code> (<code>:979-1002</code>, no callers).</td><td>as cited</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:317:  <tr><td><strong>The live listener replaces the whole model</strong>: <code>currentLessonData = doc.data()</code> (<code>:1186</code>), carrying across only camp/SDOC maps through <code>snapshotCampSeasons()</code> (<code>:1094-1100</code>). It bumps <code>globalListenerGeneration</code> (<code>:1181</code>), which gates the summer reload, and a superseded reload never sets <code>lessonDataLoadedSuccessfully</code> (<code>:1131, 1143-1145</code>). It's registered from two places (<code>app.js:676</code>, <code>:5038</code>) with one unsubscribe handle (<code>:1116</code>).</td><td>as cited</td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:319:  <tr><td>Rules: <code>:654</code> is <code>allow read, write: if isManagerOrAbove()</code>, and <code>:666</code> is a separate create/update for classbook roles (not appData/prepCycleConfig). Rules OR across statements, so fencing a key for managers too means <strong>splitting <code>:654</code></strong> into per-operation statements. Whole-doc delete is limited to classbook-admin/curriculum-admin (<code>:675-678</code>). <code>studio-hub/rules.test.js</code> has no <code>curriculum/lessonData</code> fixture today.</td><td><code>studio-hub/firestore.rules:652-678</code></td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:344:  <li>No role can create, add to, or change the <code>spring-2026</code> key, with exactly two manager/admin exceptions. (1) An update that <em>only deletes</em> it, for the Phase C transaction. (2) The <strong>rollback</strong>: an update that <em>only re-adds</em> it, allowed only while <code>storageMigrations.spring-2026.verified != true</code> and only if <code>getAfter(lessons_spring-2026)</code> shows that document deleted in the same transaction (Codex round 2, fix 1).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:348:<p>For <code>curriculum/lessons_spring-2026</code>: create by a manager only, and only if it doesn't exist. Updates only when <code>storageMigrations.spring-2026.verified == true</code>, for the roles that can update lessons today. Whole-doc delete by <strong>manager/admin only, and only while not yet verified</strong> (the rollback). classbook-admin and curriculum-admin may never delete it, and <strong>nobody</strong> may delete it after verification, until the follow-up plan adds a routed delete/archive (Codex round 2, fix 2).</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:349:<p>For <code>curriculum/storageMigrations</code>: manager write, and read for the classbook roles.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:351:<p><strong>Shape:</strong> split <code>:654</code> (<code>allow read, write: if isManagerOrAbove()</code>) into <code>read</code> / <code>create</code> / <code>update</code> / <code>delete</code> statements, because rules OR across statements. Manager <code>delete</code> is kept for every curriculum doc except <code>lessonData</code>. The classbook-role statements at <code>:666</code> and <code>:675-678</code> get the same <code>lessonData</code>/<code>lessons_spring-2026</code> conditions. The <code>lessonData</code> update condition is <code>!affectedKeys().hasAny(['spring-2026'])</code>, OR (manager/admin, removal) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; !('spring-2026' in request.resource.data)</code>, OR (manager/admin, <strong>rollback re-add</strong>) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; ('spring-2026' in request.resource.data) &amp;&amp; !('spring-2026' in resource.data) &amp;&amp; !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026) &amp;&amp; get(/databases/$(database)/documents/curriculum/storageMigrations).data.get('spring-2026', {}).get('verified', false) != true</code>. Every split statement is constrained this way, because <code>allow</code> statements OR together.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:352:<div class="bdd">Rules tests (studio-hub/rules.test.js), roles: teacher (classbook), classbook-admin, curriculum-admin, manager, admin.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:355:  lessonData update { spring-2026: delete } only                    → manager/admin allowed; others denied
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:360:  rollback: manager/admin re-adds only spring-2026 AND deletes lessons_spring-2026 in one transaction, while unverified → allowed
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:363:  lessons_spring-2026 create when absent                            → manager/admin allowed; others denied
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:365:  lessons_spring-2026 delete before verified                        → manager/admin allowed (rollback); teacher/classbook-admin/curriculum-admin denied
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:367:  storageMigrations write                                           → manager/admin only; read → classbook roles
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:377:  <li><strong>The listener doesn't drop Spring</strong> (round 1 A). The legacy snapshot's swap carries own-doc semesters across, the way it already carries camp seasons. The <code>lessons_K</code> listener updates only <code>currentLessonData[K]</code>, doesn't bump <code>globalListenerGeneration</code>, and never touches <code>lessonDataLoadedSuccessfully</code>. Its errors go to a visible banner and make Spring unwritable.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:384:    The whole teardown uses one unsubscribe array (the listener is registered from <code>app.js:676</code> and <code>:5038</code>).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:385:  <li><strong>Writes to Spring:</strong> they go to <code>lessons_K</code> only when <code>storageMigrations.spring-2026.verified</code> is true, read by a small <code>storageMigrations</code> listener. Otherwise the app shows the "editing is paused" message; the rules refuse those writes anyway. <code>not-found</code> is handled the same way.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:388:  <li><strong>Headroom readout</strong> in Curriculum Admin → Diagnostics (managers): an approximate Firestore-size estimate of <code>lessonData</code>, using the same field-size method as the Sep 29 snippet (not <code>JSON.stringify</code> length). It's labelled "approx.", and it warns above 85%, a conservative buffer.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:389:  <li><strong>Studio Hub alerts</strong> (Codex 6). The listener keeps per-source state: legacy <code>lessonData</code>, plus <code>lessons_spring-2026</code>. It reconciles the <em>union</em>, so each source's snapshot no longer removes the other's alerts. It prefers the own-doc copy for Spring. Alert IDs become <code>classbook-qa-&lt;semKey&gt;-&lt;lessonKey&gt;</code>, fixing today's cross-semester collisions. Studio Hub stores dismissals <em>by ID</em> (<code>alerts.js:6-7, 54-68, 654</code>), so an alert also counts as dismissed if its <strong>old</strong> ID <code>classbook-qa-&lt;lessonKey&gt;</code> is in the dismissed set. This is a one-line compatibility check in <code>addOrUpdateAlert</code>, so nothing already dismissed comes back (Codex round 2, fix 3). An old dismissal applies to that lesson key in every semester, which matches today's behaviour, since today the two collide into one alert.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:390:  <li><strong>Ratchet:</strong> no <code>doc('lessonData')</code> in the loaded scripts outside the helpers, the legacy load/listener and the dead backup helpers. <code>e2e/</code> is exempt. The seed gains a <code>lessons_spring-2026</code> + <code>storageMigrations</code> fixture set for the own-doc scenarios, and the default seed is unchanged.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:406:Scenario: own-doc listener error → banner, Spring unwritable, Fall unaffected
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:410:Scenario: Studio Hub: an alert dismissed under its old ID stays dismissed after the re-key
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:415:<h3>Phase C: move Spring in one step (production, one-off, manager) <span class="status-tag ready">execution-ready: true</span></h3>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:422:<p><strong>How:</strong> a console procedure that Christie pastes while signed in as manager. The procedure is written into this plan and reviewed before execution, and rehearsed in the emulator by an e2e test that runs the same code.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:434:  <li><strong>If it fails:</strong> nothing has been edited since the copy, so the reverse transaction is safe: it puts <code>map</code> back into <code>lessonData</code>, which Phase A's rollback allowance permits (a manager/admin, only this key, only while unverified, and only together with deleting <code>lessons_spring-2026</code>), deletes <code>lessons_spring-2026</code>, and records the failure. The download from step 1 remains the last resort.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:459:  <li><strong>Atomic:</strong> the copy, the old-copy removal and the migration record are one transaction.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:490:    <li>The rollback re-add is explicitly allowed for manager/admin, only while unverified and only with <code>lessons_spring-2026</code> deleted in the same transaction (<code>getAfter</code>). This replaces the test that contradicted it.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:491:    <li>Deleting the new document is manager/admin-only and only while unverified. Other roles are always denied, and everyone is denied after verification until the follow-up plan.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:492:    <li>Studio Hub dismissals are ID-based, so an alert counts as dismissed under its old ID too, and nothing dismissed resurfaces.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:499:    <li>(3) The rules also fence <code>lessonData</code> create and whole-doc delete, keep manager delete for other docs, and the tests cover admin and curriculum-admin. Q3 is resolved: manager delete is kept, except for <code>lessonData</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:518:  <strong>Sep 29, 2026: revision 2, after review round 1 (Claude; <code>thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md</code>): NOT ready, 11-point minimum list, all taken.</strong> Re-scoped to <strong>Spring only, hard-coded</strong>, with no appData flags, <code>migratedSemesters</code>, UI buttons or "Move back". The copy and the removal are reviewed console procedures. The rules fence uses a literal key (no <code>get(appData)</code>), splits <code>:654</code>, and ships <strong>first</strong>. Fixed: the listener drops own-doc semesters (A); verify races (B, moot now that the fence freezes the source first); Phase D's precondition compares against the hash of what was written (C); vanished keys are loud (D); <code>not-found</code> on first write (E); <code>createNewSemester</code>/<code>deleteSemester</code> deferred to the follow-up plan, with a deadline (F, delete); the missing readers are added (<code>tinker-backups/backup.js</code>, which is Christie's edit, the in-app content count, <code>test-alerts.js</code>, dead backup helpers, e2e exemptions, seed); the backup citation and "nightly" are corrected; the listener generation is decided (no bump); teardown uses an array; a near-1 MB rules fixture is added; there's a headroom readout; and the emergency lever's order is fixed.<br>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:519:  <strong>Open questions for Christie:</strong> (Q1) Is it OK that Spring 2026 is read-only ("editing is paused") from Phase A until Phase C, probably a few days? (Q2) Will you make the small <code>backup.js</code> edit before Phase D, or accept one expected content-loss alarm for Spring teachers? (Q3, for the reviewer) Undoing a bad Phase C copy needs a whole-doc delete of <code>lessons_spring-2026</code>; today only classbook-admin/curriculum-admin may whole-doc delete (<code>:675-678</code>). Should Phase A's split give managers delete as well (they have it today through <code>:654</code>'s <code>write</code>)? The plan assumes yes: the split keeps manager delete.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:529:/bin/zsh -lc 'rg -n "''^(#|##|###|[1-5]'"\\. |Verdict|SAFE|NOT)|RESOLVED|Finding|minimum\" /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-codex.md | tail -120" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:533:22:2. Listener logic: initial load vs listener ordering, the legacy carry-across, recheckOwnDocAfterLegacyLoss, the move and rollback transitions, error states, teardown/double registration, interaction with globalListenerGeneration / reloadSummer / lessonDataLoadedSuccessfully, SDOC and camp seasons.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:535:24:4. Studio Hub alerts: union/rebuild correctness, dismissal migration, cleanup, errors.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:537:26:Verdict: SAFE TO DEPLOY or NOT (minimum list). Do not edit files or run tests.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:541:301:  <strong>Sep 29, 2026: revision 2, after review round 1 (Claude; <code>thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md</code>): NOT ready, 11-point minimum list, all taken.</strong> Re-scoped to <strong>Spring only, hard-coded</strong>, with no appData flags, <code>migratedSemesters</code>, UI buttons or "Move back". The copy and the removal are reviewed console procedures. The rules fence uses a literal key (no <code>get(appData)</code>), splits <code>:654</code>, and ships <strong>first</strong>. Fixed: the listener drops own-doc semesters (A); verify races (B, moot now that the fence freezes the source first); Phase D's precondition compares against the hash of what was written (C); vanished keys are loud (D); <code>not-found</code> on first write (E); <code>createNewSemester</code>/<code>deleteSemester</code> deferred to the follow-up plan, with a deadline (F, delete); the missing readers are added (<code>tinker-backups/backup.js</code>, which is Christie's edit, the in-app content count, <code>test-alerts.js</code>, dead backup helpers, e2e exemptions, seed); the backup citation and "nightly" are corrected; the listener generation is decided (no bump); teardown uses an array; a near-1 MB rules fixture is added; there's a headroom readout; and the emergency lever's order is fixed.<br>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:543:1604:  <strong>Sep 29, 2026: revision 2, after review round 1 (Claude; <code>thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md</code>): NOT ready, 11-point minimum list, all taken.</strong> Re-scoped to <strong>Spring only, hard-coded</strong>, with no appData flags, <code>migratedSemesters</code>, UI buttons or "Move back". The copy and the removal are reviewed console procedures. The rules fence uses a literal key (no <code>get(appData)</code>), splits <code>:654</code>, and ships <strong>first</strong>. Fixed: the listener drops own-doc semesters (A); verify races (B, moot now that the fence freezes the source first); Phase D's precondition compares against the hash of what was written (C); vanished keys are loud (D); <code>not-found</code> on first write (E); <code>createNewSemester</code>/<code>deleteSemester</code> deferred to the follow-up plan, with a deadline (F, delete); the missing readers are added (<code>tinker-backups/backup.js</code>, which is Christie's edit, the in-app content count, <code>test-alerts.js</code>, dead backup helpers, e2e exemptions, seed); the backup citation and "nightly" are corrected; the listener generation is decided (no bump); teardown uses an array; a near-1 MB rules fixture is added; there's a headroom readout; and the emergency lever's order is fixed.<br>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:544:11540:Two deploy blockers are now confirmed. First, the pause is enforced only at the low-level target helper, so several UI workflows hide the pause reason or perform side effects before that helper is reached (notably photo upload and Cut Bank archival). Second, Studio Hub’s legacy-dismissal migration never removes the old dismissal when the underlying question resolves, so future questions on that lesson key can remain dismissed indefinitely. I’m finishing the transition-race and test-isolation pass before giving the minimum list.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:545:11910:Verdict: **NOT SAFE TO DEPLOY.**
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:548:11932:3. Studio Hub dismissal cleanup is incorrect after ID migration.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:549:11938:4. Studio Hub drops Spring alerts on an own-document listener error.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:551:11953:Verdict: **NOT SAFE TO DEPLOY.**
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:554:11975:3. Studio Hub dismissal cleanup is incorrect after ID migration.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:555:11981:4. Studio Hub drops Spring alerts on an own-document listener error.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:581:Verdict: **NOT SAFE TO DEPLOY.**
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:593:   - Saving Spring settings writes `appData` before lesson-slot creation hits the pause at [app.js:11427](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:11427). The UI reports an error even though the configuration already changed.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:599:   The asynchronous server read at [firebase-data.js:895](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:895) is launched without awaiting or generation/state validation at [firebase-data.js:1361](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1361). If rollback listeners restore legacy state while that read is in flight, its late result can set `ownDocSource = 'ownDoc'` and replace Spring with the now-deleted copy. There may be no later snapshot to correct it.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:601:   Minimum fix: give own-document checks/listeners a generation or transition token and apply results only if the triggering legacy-loss state is still current. Cover both move→rollback orderings.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:603:3. Studio Hub dismissal cleanup is incorrect after ID migration.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:605:   Migration adds the semester-qualified dismissal at [alerts.js:578](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:578), but resolution removes only the new ID at [alerts.js:655](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:655). The legacy `classbook-qa-<lessonKey>` dismissal remains forever. A later question for that lesson—potentially in any semester—is immediately re-dismissed.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:607:   Minimum fix: when no outstanding Classbook alert still uses a legacy ID, remove that legacy dismissal too. Preserve it while another same-key semester alert remains active.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:609:4. Studio Hub drops Spring alerts on an own-document listener error.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:613:   Minimum fix: retain the last good source on listener error and avoid destructive pruning for the failed source. Initial-error behavior also needs an explicit degraded-state policy.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:617:   The Classbook spec directly invokes low-level writers at [spring-own-doc.spec.js:51](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/spring-own-doc.spec.js:51), but does not exercise teacher/admin UI saves, Q&A send/reply, photos, Cut Bank, settings, copy, move/swap pause behavior, listener errors, or the late `recheckOwnDocAfterLegacyLoss()` race. Its “other semester” check uses a fabricated key rather than Fall. Studio Hub tests cover only the pure union builder, not listener rebuilds, migration cleanup, or errors.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:624:Verdict: **NOT SAFE TO DEPLOY.**
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:636:   - Saving Spring settings writes `appData` before lesson-slot creation hits the pause at [app.js:11427](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:11427). The UI reports an error even though the configuration already changed.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:642:   The asynchronous server read at [firebase-data.js:895](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:895) is launched without awaiting or generation/state validation at [firebase-data.js:1361](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1361). If rollback listeners restore legacy state while that read is in flight, its late result can set `ownDocSource = 'ownDoc'` and replace Spring with the now-deleted copy. There may be no later snapshot to correct it.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:644:   Minimum fix: give own-document checks/listeners a generation or transition token and apply results only if the triggering legacy-loss state is still current. Cover both move→rollback orderings.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:646:3. Studio Hub dismissal cleanup is incorrect after ID migration.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:648:   Migration adds the semester-qualified dismissal at [alerts.js:578](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:578), but resolution removes only the new ID at [alerts.js:655](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:655). The legacy `classbook-qa-<lessonKey>` dismissal remains forever. A later question for that lesson—potentially in any semester—is immediately re-dismissed.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:650:   Minimum fix: when no outstanding Classbook alert still uses a legacy ID, remove that legacy dismissal too. Preserve it while another same-key semester alert remains active.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:652:4. Studio Hub drops Spring alerts on an own-document listener error.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:656:   Minimum fix: retain the last good source on listener error and avoid destructive pruning for the failed source. Initial-error behavior also needs an explicit degraded-state policy.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:660:   The Classbook spec directly invokes low-level writers at [spring-own-doc.spec.js:51](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/spring-own-doc.spec.js:51), but does not exercise teacher/admin UI saves, Q&A send/reply, photos, Cut Bank, settings, copy, move/swap pause behavior, listener errors, or the late `recheckOwnDocAfterLegacyLoss()` race. Its “other semester” check uses a fabricated key rather than Fall. Studio Hub tests cover only the pure union builder, not listener rebuilds, migration cleanup, or errors.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:942:+    page.on('dialog', d => { alerts.push(d.message()); d.dismiss(); });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:976:+      'setupLessonDataListener',     // the legacy listener
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1386:+  // Spring 2026 storage move: its settings save also writes lesson slots, so it's
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1401:+let ownDocUnsubscribes = [];   // own-doc semester + storageMigrations listeners (Spring 2026 storage move)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1412:+// semester moves to its own document, curriculum/lessons_<semKey>, in one manager
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1556:+// Initial load for own-doc semesters and the migration record (called by
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1594:+    // A later snapshot (the own-doc listener, or a rollback) has spoken since this
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1677:   globalListenerGeneration++; // whatever the previous listener still has in flight is now stale
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1679:+  // The own-doc listeners (Spring 2026 storage move) are torn down together.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1690:+      // their own listeners below keep them current.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1715:+  // Own-doc semesters: one listener per document, plus the migration record.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1724:+    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; }));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1748:+        console.error(`❌ ${ownDocIdFor(semKey)} listener error:`, err);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1957:+  // Stored among the dismissed ids once old-format Classbook dismissals are migrated.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1958:+  const CLASSBOOK_QA_DISMISSALS_MIGRATED = 'classbook-qa-dismissals-migrated-v2';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1977:+    // Each document has its own listener; alerts are rebuilt from the UNION of the
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1979:+    // one listener's snapshot never removes the other's alerts.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1991:+      // One-time migration of dismissals saved under the pre-Sep-2026 id
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1993:+      // dismissed gets its new id dismissed, then the old ids are retired, so an old
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1994:+      // dismissal can never hide a FUTURE question on the same lesson key (in any
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:1997:+      if (!dismissedAlertIds.has(CLASSBOOK_QA_DISMISSALS_MIGRATED)) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2000:+          if (dismissedAlertIds.has(alert.legacyId)) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2001:+            dismissedAlertIds.add(alert.id);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2005:+        retired.forEach(id => dismissedAlertIds.delete(id));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2006:+        dismissedAlertIds.add(CLASSBOOK_QA_DISMISSALS_MIGRATED);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2039:         console.error('Classbook listener error:', error);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2042:     listeners.push(classbookListener);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2055:+          console.error(`Classbook ${semKey} listener error:`, error);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2061:+      listeners.push(ownDocListener);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2078:+// Each is watched by its own listener, so the alert set is rebuilt from the union
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2082:+// semester); `legacyId` is the pre-Sep-2026 id, so a dismissal saved under it
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2171:+ * the test fire each document listener by hand — the Classbook Q&A wiring only
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2172:+ * (union of lessonData + lessons_<semKey>, dismissal migration, listener errors).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2179:+function loadEngine({ dismissed = [] } = {}) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2199:+  const store = { studioHub_dismissedAlerts: JSON.stringify(dismissed) };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2218:+    dismissedIds: () => JSON.parse(store.studioHub_dismissedAlerts || '[]'),
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2247:+  test('an own-document listener error keeps its last good alerts', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2265:+  test('old-format dismissals migrate once, then are retired (no future question is hidden)', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2266:+    const h = loadEngine({ dismissed: ['classbook-qa-k-1', 'classbook-qa-k-9'] });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2268:+    h.fire(LD, { 'fall-2026': { 'k-1': q('fall, dismissed before') } });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2269:+    h.fire(SPRING, { 'k-1': q('spring, same key, dismissed before') });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2270:+    expect(h.ids()).toEqual([]);                       // both still dismissed
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2271:+    const d = h.dismissedIds();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2272:+    expect(d).toEqual(expect.arrayContaining(['classbook-qa-fall-2026-k-1', 'classbook-qa-spring-2026-k-1', 'classbook-qa-dismissals-migrated-v2']));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2274:+    // A later question on a key whose old dismissal wasn't open at migration time is NOT hidden.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2279:+  test('after migration, an old id added back by an old tab has no effect', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2280:+    const h = loadEngine({ dismissed: ['classbook-qa-dismissals-migrated-v2', 'classbook-qa-k-1'] });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2397:  1768	          const slot = slots[lessonKey];
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2398:  1769	          if (!slot) return `<div class="sdoc-tv-block" data-block="${key}"><span class="sdoc-tv-label">${label}</span> ${sdocEsc(title)}</div>`;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2399:  1770	          const progress = calculateLessonProgress(slot);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2400:  1771	          const editable = canEditDayOffPlan(slot) && lessonDataLoadedSuccessfully !== false;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2407:  1778	            <label class="sdoc-tv-pc"><input type="checkbox" class="sdoc-tv-pc-cb" data-lesson-key="${sdocEscA(lessonKey)}" ${slot.planComplete ? 'checked' : ''} ${editable && !pending ? '' : 'disabled'} onchange="toggleDayOffPlanComplete(this)"> Plan complete</label>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2439:  1810	  const slot = currentLessonData?.[yearKey]?.[lessonKey];
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2440:  1811	  if (!slot || !canEditDayOffPlan(slot)) { box.checked = !requested; return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2478:  2308	      // render above). Fallback for a checkbox rendered without one: the slot
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2480:  2310	      // ("A + B") has one slot per teacher with the same
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2482:  2312	      // matching on those alone ticked the FIRST teacher's slot and wrote the
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2489:  2319	            if (!lessonKey) lessonKey = key; // fallback (admin viewing another teacher's slot)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2774:  3602	    // Update local data immediately (don't wait for Firestore listener)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2853:  3681	  // failed load the cache is empty, so the legacy-thread migration below
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:2897:  3725	  const isAdmin = ['admin', 'manager'].includes(user?.role);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3107:  4759	// a forced-server absence check. No roster, no lesson slots, no
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3176:  4828	    // created under. The key check matters before the type migration has run:
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3215:  4867	// cleanup below delete the succeeding run's server-side slots. Set before the
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3220:  4872	// A lesson slot exactly as createNewSemester() / createLessonSlotsForRoster()
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3224:  4876	// real data that createNewSemester()'s slot write would merge over.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3235:  4887	// roster, no week grid, no lesson slots and no curriculum/lessonData write —
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3311:  4963	  // Two Firestore writes happen in sequence (lesson slots, then config); if the
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3312:  4964	  // second fails after the first landed, the slots are an orphan on the server
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3326:  4978	      // and config has no live listener, so another admin's same-named
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3331:  4983	      // would be merged over silently by the slot write, then deleted on
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3349:  5001	      // Create empty lesson slots from source semester's teacher/class combos
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3409:  5061	    // R4-11: the empty lesson slots may already be persisted even though the
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3466:  5647	  // modal body mid-save and race a second write onto the same slot).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3524:  5705	  // Step 2 — forced-server read of this slot, before any side effect (the
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3533:  5714	  // could be served from the live listener's local cache in exactly the race
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3535:  5716	  // an "empty" slot in this tab's cache may have gained a project (a paste, a
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3536:  5717	  // move onto it) that the listener hasn't delivered yet.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3552:  5733	      // The key holds a doc — but a swap, a move ONTO this slot, or a paste
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3553:  5734	      // into a slot this tab still shows as empty leaves it populated with a
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3557:  5738	      // shows the slot's identity changed.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3560:  5741	        const opened = baseline.projectTitle || '(empty slot)';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3561:  5742	        if (!confirm(`This slot has changed since you opened it — it now contains "${freshTitle || '(empty)'}" instead of "${opened}". Save your changes onto "${freshTitle || 'this slot'}" anyway?\n\nCancel keeps your text here and saves nothing.`)) return;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3672:  5853	  // listener's next delivery, same as the teacher editor).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3760:  5941	// failed to save or failed verification — puts both slots back to their
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3761:  5942	// pre-action state (deleting the dest slot if it didn't exist before) and re-renders.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3848:  6029	      alert(`Move could not be saved — "${preMoveSourceLesson.projectTitle}" has been restored to its original slot. Nothing was changed.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3874:  6055	    const destLabel = destLesson ? `"${destLesson.projectTitle}"` : 'empty slot';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3892:  6073	      // Backtracking audit, Phase 4: each slot's clear list compares its OWN
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3894:  6075	      // other slot's pre-swap content, which would be a no-op since that's
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3906:  6087	      // Backtracking audit, Phase 9: both slots' writes are now ONE atomic
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3920:  6101	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" and "${destLesson.projectTitle}" have been restored to their original slots.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:3938:  6119	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" has been restored to its original slot.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:4191:  6372	  // the fresh read shows the slot's identity has materially changed since
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:4194:  6375	    if (!confirm(`This slot has changed since you opened it — it now contains "${freshLesson.projectTitle}" (${freshLesson.teacher} / ${freshLesson.className}). Cut this instead?`)) return;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:4321:  6551	  // DESTINATION slot already had its own stale qaThread/photo/planComplete
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:4436:  7025	  // Instance-specific fields tied to whatever previously occupied this slot —
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:4485:  7203	// equality dedup makes repeating this migration from concurrent senders safe.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:4495:  7213	// the server in the split-second before this admin's live listener caught
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:4510:  7228	  // failed reload the listener deliberately KEEPS the previous summer maps, so
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:4599:  7317	  // failed reload the listener deliberately KEEPS the previous summer maps, so
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:4761: 10973	// ─── "Stamp semester types" — the one-time migration (Phase 1, 1.2) ──────────
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:4764: 10976	// contradicts the migration. The write is one update() of field paths, and it
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:4769: 10981	  const card = document.getElementById('settings-type-migration-card');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:4798: 11010	    // of the pre-migration document exists outside Firestore.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:4890: 11361	  // Spring 2026 storage move: its settings save also writes lesson slots, so it's
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:4987: 11458	    // listener (setupConfigListener() is never called), so nothing else would
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:4997: 11468	    // Create lesson slots for classes assigned to teachers
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5033: 11504	  // while viewing summer-2026 built garbage teacher-className-weekNum slots
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5054: 11525	    // Check if lesson slots exist for this teacher-class combination
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5089: 11560	    console.log(`✅ Created ${createdCount} lesson slots for roster classes`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5214: 12104	        // slot (plan, round 4).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5224: 12114	        // Save confirmed. If the listener swapped the summer cache out from
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5298:  4963	  // Two Firestore writes happen in sequence (lesson slots, then config); if the
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5299:  4964	  // second fails after the first landed, the slots are an orphan on the server
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5313:  4978	      // and config has no live listener, so another admin's same-named
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5318:  4983	      // would be merged over silently by the slot write, then deleted on
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5336:  5001	      // Create empty lesson slots from source semester's teacher/class combos
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5396:  5061	    // R4-11: the empty lesson slots may already be persisted even though the
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5412:  5941	// failed to save or failed verification — puts both slots back to their
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5413:  5942	// pre-action state (deleting the dest slot if it didn't exist before) and re-renders.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5500:  6029	      alert(`Move could not be saved — "${preMoveSourceLesson.projectTitle}" has been restored to its original slot. Nothing was changed.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5526:  6055	    const destLabel = destLesson ? `"${destLesson.projectTitle}"` : 'empty slot';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5544:  6073	      // Backtracking audit, Phase 4: each slot's clear list compares its OWN
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5546:  6075	      // other slot's pre-swap content, which would be a no-op since that's
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5558:  6087	      // Backtracking audit, Phase 9: both slots' writes are now ONE atomic
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5572:  6101	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" and "${destLesson.projectTitle}" have been restored to their original slots.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5590:  6119	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" has been restored to its original slot.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5769:  6372	  // the fresh read shows the slot's identity has materially changed since
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5772:  6375	    if (!confirm(`This slot has changed since you opened it — it now contains "${freshLesson.projectTitle}" (${freshLesson.teacher} / ${freshLesson.className}). Cut this instead?`)) return;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5894:  6551	  // DESTINATION slot already had its own stale qaThread/photo/planComplete
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:5989:  7025	  // Instance-specific fields tied to whatever previously occupied this slot —
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:6033:  7203	// equality dedup makes repeating this migration from concurrent senders safe.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:6043:  7213	// the server in the split-second before this admin's live listener caught
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:6058:  7228	  // failed reload the listener deliberately KEEPS the previous summer maps, so
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:6147:  7317	  // failed reload the listener deliberately KEEPS the previous summer maps, so
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:6236:   355	  // delete, create, Settings and the migration all write through here; without
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:6260:   379	// before creating a semester, and by the type migration's dry run/read-back.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:6357:  1209	// resolve to "not newer"). Shared by the listener merge below and the summer
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:6363:  1215	// The fields a saved summerCamps_lessonData doc contributes to a lesson slot
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:6366:  1452	        console.error(`❌ ${ownDocIdFor(semKey)} listener error:`, err);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:6658:   620	  const a = dayOffAuthFor(slot?.yearKey || getTvSemKey());
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:6659:   621	  return a.canEditAnywhere || (a.hasClassbook && !!a.myTeacherName && (slot?.teachers || []).includes(a.myTeacherName));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:6663:   625	function dayOffTitleDates(yearKey, slot) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:6664:   626	  const camp = (currentDayOffCamps[yearKey] || []).find(c => c.id === slot?.campId);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:6665:   627	  return (camp?.dates || []).filter(d => Object.values(normaliseDayOffDayBlocks(camp.projects?.[d])).includes(slot.projectTitle));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:6929:  4759	// a forced-server absence check. No roster, no lesson slots, no
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7093: 10973	// ─── "Stamp semester types" — the one-time migration (Phase 1, 1.2) ──────────
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7096: 10976	// contradicts the migration. The write is one update() of field paths, and it
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7101: 10981	  const card = document.getElementById('settings-type-migration-card');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7130: 11010	    // of the pre-migration document exists outside Firestore.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7171:The caller inventory now shows the obvious compound Spring workflows were guarded before their first external mutation. I’m checking less obvious failure paths next: listener-error state transitions, whether the Studio Hub “migration completed” marker can be written from incomplete source data, and whether the new tests genuinely model those races rather than only direct helpers.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7176:     2	// Real-time Firestore listeners for Mission Control dashboard
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7180:     6	  let dismissedAlerts = []; // Dismissed alerts (with full alert objects)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7181:     7	  let dismissedAlertIds = new Set(); // Persistent dismissed IDs (loaded from Firestore)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7182:     8	  let listeners = []; // Track active listeners for cleanup
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7186:    12	  let showDismissed = false; // Toggle for showing dismissed alerts
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7202:    28	    cleanup(); // Clear any existing listeners
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7204:    30	    dismissedAlerts = [];
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7205:    31	    dismissedAlertIds = new Set();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7207:    33	    // Load persisted dismissals first, then start listeners so dismissed alerts never flash in
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7218:    44	    // Unsubscribe all listeners
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7219:    45	    listeners.forEach(unsubscribe => unsubscribe());
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7220:    46	    listeners = [];
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7230:    56	      const local = localStorage.getItem('studioHub_dismissedAlerts');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7231:    57	      if (local) dismissedAlertIds = new Set(JSON.parse(local));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7239:    65	        const ids = doc.data().dismissedAlertIds || [];
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7241:    67	          dismissedAlertIds = new Set(ids);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7242:    68	          localStorage.setItem('studioHub_dismissedAlerts', JSON.stringify(ids));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7246:    72	      console.error('Failed to load dismissed alerts from Firestore:', err);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7251:    77	    const ids = Array.from(dismissedAlertIds);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7254:    80	    localStorage.setItem('studioHub_dismissedAlerts', JSON.stringify(ids));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7260:    86	        dismissedAlertIds: ids
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7263:    89	      console.error('Failed to save dismissed alerts to Firestore:', err);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7345:   550	        console.error('Recap meetings listener error:', error);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7348:   553	    listeners.push(recapListener);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7355:   560	  // Stored among the dismissed ids once old-format Classbook dismissals are migrated.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7356:   561	  const CLASSBOOK_QA_DISMISSALS_MIGRATED = 'classbook-qa-dismissals-migrated-v2';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7362:   567	    // Each document has its own listener; alerts are rebuilt from the UNION of the
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7364:   569	    // one listener's snapshot never removes the other's alerts.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7376:   581	      // One-time migration of dismissals saved under the pre-Sep-2026 id
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7378:   583	      // dismissed gets its new id dismissed, then the old ids are retired, so an old
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7379:   584	      // dismissal can never hide a FUTURE question on the same lesson key (in any
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7382:   587	      if (!dismissedAlertIds.has(CLASSBOOK_QA_DISMISSALS_MIGRATED)) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7385:   590	          if (dismissedAlertIds.has(alert.legacyId)) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7386:   591	            dismissedAlertIds.add(alert.id);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7390:   595	        retired.forEach(id => dismissedAlertIds.delete(id));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7391:   596	        dismissedAlertIds.add(CLASSBOOK_QA_DISMISSALS_MIGRATED);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7415:   620	        console.error('Classbook listener error:', error);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7417:   622	    listeners.push(classbookListener);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7430:   635	          console.error(`Classbook ${semKey} listener error:`, error);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7436:   641	      listeners.push(ownDocListener);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7445:   650	    if (dismissedAlertIds.has(alert.id)) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7446:   651	      // Route to dismissed list — alert is still tracked but not shown as active
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7447:   652	      alert.dismissed = true;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7448:   653	      const existingIndex = dismissedAlerts.findIndex(a => a.id === alert.id);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7450:   655	        dismissedAlerts[existingIndex] = alert;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7452:   657	        dismissedAlerts.push(alert);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7467:   672	    // If the underlying data resolved, auto-clean the dismissal too
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7468:   673	    if (dismissedAlertIds.has(alertId)) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7469:   674	      dismissedAlertIds.delete(alertId);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7470:   675	      dismissedAlerts = dismissedAlerts.filter(a => a.id !== alertId);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7475:   680	  function dismissAlert(alertId) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7478:   683	      alert.dismissed = true;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7479:   684	      alert.dismissedAt = new Date().toISOString();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7480:   685	      dismissedAlerts.push(alert);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7482:   687	      dismissedAlertIds.add(alertId);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7556:   910	    dismissAlert,
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7561:   915	    getDismissedCount: () => dismissedAlerts.length,
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7573:    78	// semester moves to its own document, curriculum/lessons_<semKey>, in one manager
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7737:   896	// Initial load for own-doc semesters and the migration record (called by
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7775:   934	    // A later snapshot (the own-doc listener, or a rollback) has spoken since this
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7819:  1307	// listener's own generation-gated path — never a second, competing one
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7823:  1311	  if (typeof summerReloadHook !== 'function') return 'no-listener';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7828:  1316	  console.log('📚 Setting up lesson data listener...');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7830:  1318	  globalListenerGeneration++; // whatever the previous listener still has in flight is now stale
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7832:  1320	  // The own-doc listeners (Spring 2026 storage move) are torn down together.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7905:  1393	      // their own listeners below keep them current.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7931:  1419	  // Own-doc semesters: one listener per document, plus the migration record.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7940:  1428	    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; }));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:7964:  1452	        console.error(`❌ ${ownDocIdFor(semKey)} listener error:`, err);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8145:  6372	  // the fresh read shows the slot's identity has materially changed since
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8148:  6375	    if (!confirm(`This slot has changed since you opened it — it now contains "${freshLesson.projectTitle}" (${freshLesson.teacher} / ${freshLesson.className}). Cut this instead?`)) return;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8260:  6551	  // DESTINATION slot already had its own stale qaThread/photo/planComplete
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8345:  7025	  // Instance-specific fields tied to whatever previously occupied this slot —
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8374:  7203	// equality dedup makes repeating this migration from concurrent senders safe.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8384:  7213	// the server in the split-second before this admin's live listener caught
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8399:  7228	  // failed reload the listener deliberately KEEPS the previous summer maps, so
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8488:  7317	  // failed reload the listener deliberately KEEPS the previous summer maps, so
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8700:   144	    page.on('dialog', d => { alerts.push(d.message()); d.dismiss(); });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8734:   178	      'setupLessonDataListener',     // the legacy listener
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8839:     3	 * the test fire each document listener by hand — the Classbook Q&A wiring only
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8840:     4	 * (union of lessonData + lessons_<semKey>, dismissal migration, listener errors).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8847:    11	function loadEngine({ dismissed = [] } = {}) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8867:    31	  const store = { studioHub_dismissedAlerts: JSON.stringify(dismissed) };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8886:    50	    dismissedIds: () => JSON.parse(store.studioHub_dismissedAlerts || '[]'),
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8915:    79	  test('an own-document listener error keeps its last good alerts', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8933:    97	  test('old-format dismissals migrate once, then are retired (no future question is hidden)', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8934:    98	    const h = loadEngine({ dismissed: ['classbook-qa-k-1', 'classbook-qa-k-9'] });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8936:   100	    h.fire(LD, { 'fall-2026': { 'k-1': q('fall, dismissed before') } });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8937:   101	    h.fire(SPRING, { 'k-1': q('spring, same key, dismissed before') });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8938:   102	    expect(h.ids()).toEqual([]);                       // both still dismissed
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8939:   103	    const d = h.dismissedIds();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8940:   104	    expect(d).toEqual(expect.arrayContaining(['classbook-qa-fall-2026-k-1', 'classbook-qa-spring-2026-k-1', 'classbook-qa-dismissals-migrated-v2']));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8942:   106	    // A later question on a key whose old dismissal wasn't open at migration time is NOT hidden.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8947:   111	  test('after migration, an old id added back by an old tab has no effect', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8948:   112	    const h = loadEngine({ dismissed: ['classbook-qa-dismissals-migrated-v2', 'classbook-qa-k-1'] });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:8975:   896	// Initial load for own-doc semesters and the migration record (called by
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9013:   934	    // A later snapshot (the own-doc listener, or a rollback) has spoken since this
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9071:  1311	  if (typeof summerReloadHook !== 'function') return 'no-listener';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9076:  1316	  console.log('📚 Setting up lesson data listener...');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9078:  1318	  globalListenerGeneration++; // whatever the previous listener still has in flight is now stale
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9080:  1320	  // The own-doc listeners (Spring 2026 storage move) are torn down together.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9153:  1393	      // their own listeners below keep them current.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9179:  1419	  // Own-doc semesters: one listener per document, plus the migration record.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9188:  1428	    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; }));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9212:  1452	        console.error(`❌ ${ownDocIdFor(semKey)} listener error:`, err);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9242:  3681	  // failed load the cache is empty, so the legacy-thread migration below
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9286:  3725	  const isAdmin = ['admin', 'manager'].includes(user?.role);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9326:  3765	  // live listener catches up. Usually the listener already HAS: a local
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9354:  5647	  // modal body mid-save and race a second write onto the same slot).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9412:  5705	  // Step 2 — forced-server read of this slot, before any side effect (the
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9421:  5714	  // could be served from the live listener's local cache in exactly the race
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9423:  5716	  // an "empty" slot in this tab's cache may have gained a project (a paste, a
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9424:  5717	  // move onto it) that the listener hasn't delivered yet.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9440:  5733	      // The key holds a doc — but a swap, a move ONTO this slot, or a paste
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9441:  5734	      // into a slot this tab still shows as empty leaves it populated with a
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9445:  5738	      // shows the slot's identity changed.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9448:  5741	        const opened = baseline.projectTitle || '(empty slot)';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9449:  5742	        if (!confirm(`This slot has changed since you opened it — it now contains "${freshTitle || '(empty)'}" instead of "${opened}". Save your changes onto "${freshTitle || 'this slot'}" anyway?\n\nCancel keeps your text here and saves nothing.`)) return;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9560:  5853	  // listener's next delivery, same as the teacher editor).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9725:  6372	  // the fresh read shows the slot's identity has materially changed since
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9728:  6375	    if (!confirm(`This slot has changed since you opened it — it now contains "${freshLesson.projectTitle}" (${freshLesson.teacher} / ${freshLesson.className}). Cut this instead?`)) return;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9799:js/app.js:4872:// A lesson slot exactly as createNewSemester() / createLessonSlotsForRoster()
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9930:  5647	  // modal body mid-save and race a second write onto the same slot).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:9973: 11294	        && ((Array.isArray(d.appAccess) && d.appAccess.includes('classbook')) || d.role === 'admin' || d.role === 'manager');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10040: 11361	  // Spring 2026 storage move: its settings save also writes lesson slots, so it's
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10062:   581	      // One-time migration of dismissals saved under the pre-Sep-2026 id
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10064:   583	      // dismissed gets its new id dismissed, then the old ids are retired, so an old
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10065:   584	      // dismissal can never hide a FUTURE question on the same lesson key (in any
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10068:   587	      if (!dismissedAlertIds.has(CLASSBOOK_QA_DISMISSALS_MIGRATED)) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10071:   590	          if (dismissedAlertIds.has(alert.legacyId)) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10072:   591	            dismissedAlertIds.add(alert.id);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10076:   595	        retired.forEach(id => dismissedAlertIds.delete(id));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10077:   596	        dismissedAlertIds.add(CLASSBOOK_QA_DISMISSALS_MIGRATED);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10101:   620	        console.error('Classbook listener error:', error);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10103:   622	    listeners.push(classbookListener);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10116:   635	          console.error(`Classbook ${semKey} listener error:`, error);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10122:   641	      listeners.push(ownDocListener);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10131:   650	    if (dismissedAlertIds.has(alert.id)) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10132:   651	      // Route to dismissed list — alert is still tracked but not shown as active
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10133:   652	      alert.dismissed = true;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10134:   653	      const existingIndex = dismissedAlerts.findIndex(a => a.id === alert.id);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10136:   655	        dismissedAlerts[existingIndex] = alert;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10138:   657	        dismissedAlerts.push(alert);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10153:   672	    // If the underlying data resolved, auto-clean the dismissal too
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10154:   673	    if (dismissedAlertIds.has(alertId)) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10155:   674	      dismissedAlertIds.delete(alertId);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10156:   675	      dismissedAlerts = dismissedAlerts.filter(a => a.id !== alertId);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10161:   680	  function dismissAlert(alertId) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10291:  3765	  // live listener catches up. Usually the listener already HAS: a local
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10421:Verdict: **NOT SAFE TO DEPLOY.**
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10423:Two Studio Hub dismissal defects remain, plus the standing-notice error path and incomplete regression coverage.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10442:3. **NOT RESOLVED — migrated dismissals can still suppress future questions permanently.**
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10444:   Migration copies a legacy dismissal to the new semester-qualified IDs at [alerts.js:587](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:587). Those alerts are then held only in `dismissedAlerts`, not `alerts`, at [alerts.js:649](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:649).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10446:   Resolution pruning iterates only `alerts` at [alerts.js:600](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:600). Consequently, `removeAlert()` is never called for an already-dismissed alert, and its new qualified ID is not removed from `dismissedAlertIds`. A later question in the same semester/lesson gets dismissed again.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10448:4. **RESOLVED for last-good data — listener errors no longer erase Spring alerts.**
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10452:   There is, however, a new initial-error/migration problem listed below.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10462:1. **The migration-once marker can be committed from incomplete source data.**
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10464:   An initial own-document listener error is treated as though that document reported successfully at [alerts.js:631](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:631). That permits `rebuild()` to write the migration marker at [alerts.js:596](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:596) without seeing Spring’s current alerts.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10466:   If Spring contains a question dismissed under its legacy ID, that dismissal is not migrated. On a later successful load or reload, the permanent marker prevents another attempt and the dismissed question resurfaces. The initial-error test at [alerts-classbook.test.js:89](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:89) does not combine the error with a legacy dismissal and later recovery.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10468:2. **The standing notice is not refreshed when the migration listener fails.**
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10478:- Prune resolved Classbook dismissals from both active and dismissed alert state, with a migrated-dismissal → resolved → future-question regression test.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10479:- Do not commit the migration-once marker after an initial source error; add error-before-first-snapshot plus legacy-dismissal coverage.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10480:- Refresh the standing notice when the migration listener enters its read-only error state.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10486:Verdict: **NOT SAFE TO DEPLOY.**
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10488:Two Studio Hub dismissal defects remain, plus the standing-notice error path and incomplete regression coverage.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10507:3. **NOT RESOLVED — migrated dismissals can still suppress future questions permanently.**
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10509:   Migration copies a legacy dismissal to the new semester-qualified IDs at [alerts.js:587](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:587). Those alerts are then held only in `dismissedAlerts`, not `alerts`, at [alerts.js:649](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:649).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10511:   Resolution pruning iterates only `alerts` at [alerts.js:600](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:600). Consequently, `removeAlert()` is never called for an already-dismissed alert, and its new qualified ID is not removed from `dismissedAlertIds`. A later question in the same semester/lesson gets dismissed again.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10513:4. **RESOLVED for last-good data — listener errors no longer erase Spring alerts.**
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10517:   There is, however, a new initial-error/migration problem listed below.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10527:1. **The migration-once marker can be committed from incomplete source data.**
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10529:   An initial own-document listener error is treated as though that document reported successfully at [alerts.js:631](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:631). That permits `rebuild()` to write the migration marker at [alerts.js:596](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:596) without seeing Spring’s current alerts.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10531:   If Spring contains a question dismissed under its legacy ID, that dismissal is not migrated. On a later successful load or reload, the permanent marker prevents another attempt and the dismissed question resurfaces. The initial-error test at [alerts-classbook.test.js:89](/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:89) does not combine the error with a legacy dismissal and later recovery.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10533:2. **The standing notice is not refreshed when the migration listener fails.**
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10543:- Prune resolved Classbook dismissals from both active and dismissed alert state, with a migrated-dismissal → resolved → future-question regression test.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10544:- Do not commit the migration-once marker after an initial source error; add error-before-first-snapshot plus legacy-dismissal coverage.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md:10545:- Refresh the standing notice when the migration listener enters its read-only error state.
diff --git a/alerts-classbook.test.js b/alerts-classbook.test.js
new file mode 100644
index 0000000..d76717f
--- /dev/null
+++ b/alerts-classbook.test.js
@@ -0,0 +1,151 @@
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
+
+describe('AlertEngine — Classbook dismissal lifecycle (review round 2)', () => {
+  test('a migrated dismissal is forgotten once answered; a new question then alerts', async () => {
+    const h = loadEngine({ dismissed: ['classbook-qa-k-1'] });
+    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
+    h.fire(LD, { 'fall-2026': { 'k-1': q('dismissed before') } });
+    h.fire(SPRING, null);
+    expect(h.ids()).toEqual([]);                                  // still dismissed (migrated)
+    h.fire(LD, { 'fall-2026': { 'k-1': { qaThread: [{ from: 'teacher', message: 'q' }, { from: 'admin', message: 'a' }] } } });
+    expect(h.dismissedIds()).not.toContain('classbook-qa-fall-2026-k-1');   // answered → dismissal forgotten
+    h.fire(LD, { 'fall-2026': { 'k-1': q('a NEW question on the same lesson') } });
+    expect(h.ids()).toEqual(['classbook-qa-fall-2026-k-1']);
+  });
+
+  test('an own-doc error before its first snapshot: no migration marker; a later successful load migrates', async () => {
+    const h = loadEngine({ dismissed: ['classbook-qa-s-1'] });
+    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
+    h.fire(LD, { 'fall-2026': {} });
+    h.fail(SPRING);
+    expect(h.dismissedIds()).not.toContain('classbook-qa-dismissals-migrated-v2');
+    h.fire(SPRING, { 's-1': q('spring question dismissed before') });   // recovers
+    expect(h.ids()).toEqual([]);                                         // migrated, still dismissed
+    expect(h.dismissedIds()).toEqual(expect.arrayContaining(['classbook-qa-spring-2026-s-1', 'classbook-qa-dismissals-migrated-v2']));
+  });
+
+  test('while a source is degraded, dismissals are not pruned', async () => {
+    const h = loadEngine({ dismissed: ['classbook-qa-dismissals-migrated-v2', 'classbook-qa-spring-2026-s-1'] });
+    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
+    h.fire(LD, { 'fall-2026': {} });
+    h.fail(SPRING);
+    expect(h.dismissedIds()).toContain('classbook-qa-spring-2026-s-1');
+  });
+});
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
index 74f5b36..e19a047 100644
--- a/js/alerts.js
+++ b/js/alerts.js
@@ -557,94 +557,111 @@ const AlertEngine = (() => {
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

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js | sed -n '550,705p'
nl -ba js/firebase-data.js | sed -n '1405,1445p'
nl -ba js/app.js | sed -n '305,340p'
nl -ba e2e/data-safety.spec.js | sed -n '8690,8730p'
nl -ba e2e/spring-own-doc.spec.js | sed -n '270,430p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
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
   572	    const failedBeforeFirst = new Set();   // errored before ever delivering one (degraded)
   573	    const expected = ['lessonData', ...CLASSBOOK_OWN_DOC_SEMESTERS.map(k => `lessons_${k}`)];
   574	
   575	    const rebuild = () => {
   576	      // Don't build (or prune) until every watched document has reported once, so a
   577	      // semester never flickers out of the alert list while its source is loading.
   578	      if (!expected.every(id => received.has(id))) return;
   579	      const unansweredQuestions = buildClassbookQaAlerts(sources, Date.now());
   580	      const currentClassbookAlertIds = unansweredQuestions.map(a => a.id);
   581	
   582	      // One-time migration of dismissals saved under the pre-Sep-2026 id
   583	      // (classbook-qa-<lessonKey>): each currently-open question whose old id was
   584	      // dismissed gets its new id dismissed, then the old ids are retired, so an old
   585	      // dismissal can never hide a FUTURE question on the same lesson key (in any
   586	      // semester). A marker records that it ran; it only runs once every watched
   587	      // document has reported (see rebuild's guard above), so "currently open" is complete.
   588	      // Both steps below decide from the complete set of open questions, so they
   589	      // are skipped while any watched document failed before its first snapshot.
   590	      const complete = failedBeforeFirst.size === 0;
   591	      if (complete && !dismissedAlertIds.has(CLASSBOOK_QA_DISMISSALS_MIGRATED)) {
   592	        const retired = new Set();
   593	        unansweredQuestions.forEach(alert => {
   594	          if (dismissedAlertIds.has(alert.legacyId)) {
   595	            dismissedAlertIds.add(alert.id);
   596	            retired.add(alert.legacyId);
   597	          }
   598	        });
   599	        retired.forEach(id => dismissedAlertIds.delete(id));
   600	        dismissedAlertIds.add(CLASSBOOK_QA_DISMISSALS_MIGRATED);
   601	        saveDismissedAlerts();
   602	      }
   603	
   604	      // Remove old Classbook alerts that are no longer unanswered
   605	      alerts.forEach(alert => {
   606	        if (alert.type === 'curriculum' && !currentClassbookAlertIds.includes(alert.id)) {
   607	          removeAlert(alert.id);
   608	        }
   609	      });
   610	      // …and forget dismissals of questions that have since been answered, so a NEW
   611	      // question on the same lesson alerts again (dismissed alerts aren't in
   612	      // `alerts`, so the loop above never reached them).
   613	      if (complete) {
   614	        let prunedDismissals = false;
   615	        [...dismissedAlertIds].forEach(id => {
   616	          if (id.startsWith('classbook-qa-') && id !== CLASSBOOK_QA_DISMISSALS_MIGRATED
   617	              && dismissedAlertIds.has(CLASSBOOK_QA_DISMISSALS_MIGRATED)
   618	              && !currentClassbookAlertIds.includes(id)) {
   619	            dismissedAlertIds.delete(id);
   620	            dismissedAlerts = dismissedAlerts.filter(a => a.id !== id);
   621	            prunedDismissals = true;
   622	          }
   623	        });
   624	        if (prunedDismissals) saveDismissedAlerts();
   625	      }
   626	
   627	      // Update all Q&A alerts
   628	      unansweredQuestions.forEach(alert => addOrUpdateAlert(alert));
   629	
   630	      updateUI();
   631	    };
   632	
   633	    const classbookListener = db.collection('curriculum')
   634	      .doc('lessonData')
   635	      .onSnapshot(doc => {
   636	        sources.lessonData = doc.exists ? doc.data() : null;
   637	        received.add('lessonData');
   638	        rebuild();
   639	      }, error => {
   640	        console.error('Classbook listener error:', error);
   641	      });
   642	    listeners.push(classbookListener);
   643	
   644	    CLASSBOOK_OWN_DOC_SEMESTERS.forEach(semKey => {
   645	      const ownDocListener = db.collection('curriculum')
   646	        .doc(`lessons_${semKey}`)
   647	        .onSnapshot(doc => {
   648	          sources.ownDocs[semKey] = doc.exists ? doc.data() : null;
   649	          received.add(`lessons_${semKey}`);
   650	          failedBeforeFirst.delete(`lessons_${semKey}`);
   651	          rebuild();
   652	        }, error => {
   653	          // Keep the last good snapshot of this document (a transient error must not
   654	          // look like "all of this semester's questions were answered"). If it never
   655	          // arrived, carry on without it so the other semesters still alert.
   656	          console.error(`Classbook ${semKey} listener error:`, error);
   657	          if (!received.has(`lessons_${semKey}`)) {
   658	            failedBeforeFirst.add(`lessons_${semKey}`);
   659	            received.add(`lessons_${semKey}`);
   660	            rebuild();
   661	          }
   662	        });
   663	      listeners.push(ownDocListener);
   664	    });
   665	  }
   666	
   667	  // =====================================================
   668	  // Alert Management
   669	  // =====================================================
   670	
   671	  function addOrUpdateAlert(alert) {
   672	    if (dismissedAlertIds.has(alert.id)) {
   673	      // Route to dismissed list — alert is still tracked but not shown as active
   674	      alert.dismissed = true;
   675	      const existingIndex = dismissedAlerts.findIndex(a => a.id === alert.id);
   676	      if (existingIndex >= 0) {
   677	        dismissedAlerts[existingIndex] = alert;
   678	      } else {
   679	        dismissedAlerts.push(alert);
   680	      }
   681	      return;
   682	    }
   683	
   684	    const existingIndex = alerts.findIndex(a => a.id === alert.id);
   685	    if (existingIndex >= 0) {
   686	      alerts[existingIndex] = alert;
   687	    } else {
   688	      alerts.push(alert);
   689	    }
   690	  }
   691	
   692	  function removeAlert(alertId) {
   693	    alerts = alerts.filter(a => a.id !== alertId);
   694	    // If the underlying data resolved, auto-clean the dismissal too
   695	    if (dismissedAlertIds.has(alertId)) {
   696	      dismissedAlertIds.delete(alertId);
   697	      dismissedAlerts = dismissedAlerts.filter(a => a.id !== alertId);
   698	      saveDismissedAlerts();
   699	    }
   700	  }
   701	
   702	  function dismissAlert(alertId) {
   703	    const alert = alerts.find(a => a.id === alertId);
   704	    if (alert) {
   705	      alert.dismissed = true;
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
   305	
   306	  const semKey = getActiveSemesterKey();
   307	  const semester = currentConfig?.semesters?.[semKey];
   308	  const caTab = document.querySelector('.tab-btn[data-tab="curriculum-admin"]');
   309	  if (!caTab) return;
   310	
   311	  if (semester?.semesterType === 'summer-camp') {
   312	    caTab.style.display = 'none';
   313	    if (document.querySelector('.tab-btn.active')?.dataset.tab === 'curriculum-admin') {
   314	      switchTab('teacher-view');
   315	    }
   316	  } else {
   317	    caTab.style.display = '';
   318	  }
   319	}
   320	
   321	function setupRoleAccess() {
   322	  const user = getAuthUser();
   323	  if (!user) return;
   324	
   325	  // Manager+: full access to all tabs including Settings
   326	  if (user.role === 'admin' || user.role === 'manager') return;
   327	
   328	  // Lesson Storage headroom (Spring 2026 storage move) is a manager readout.
   329	  document.querySelector('.ca-lesson-storage-section')?.style.setProperty('display', 'none');
   330	
   331	  // classbook-admin / curriculum-admin / prep role: all tabs EXCEPT Settings
   332	  // Settings is manager+ only — classbook admins can't change semester config
   333	  if (hasCurriculumAdminAccess() || hasPrepAccess()) {
   334	    document.querySelector('.tab-btn[data-tab="settings"]')?.style.setProperty('display', 'none');
   335	    updateCurriculumAdminTab(); // Hide Curriculum Admin on summer semesters
   336	    return;
   337	  }
   338	
   339	  // Otherwise: Teacher View only (read-only mode)
   340	  // Hide admin tabs (Curriculum Admin, Settings) and Prep Dashboard
  8690	      await waitForAppInit(page);
  8691	      const r = await page.evaluate(async () => {
  8692	        const writes = [];
  8693	        const realUpdate = window.updateAppData;
  8694	        window.updateAppData = async (u) => { writes.push(JSON.parse(JSON.stringify(u))); };
  8695	        const savedMappings = currentConfig.teacherMappings;
  8696	        const realGet = window.getTeacherMappingsFromForm;
  8697	        window.getTeacherMappingsFromForm = () => ({ 'TEST Teacher': 'test-uid-123' });
  8698	        // Drive a real semester-field change through the form — on a throwaway
  8699	        // weekly semester: the seeded spring-2026 is view-only while it moves to
  8700	        // its own storage (Spring 2026 storage move), and saveSettings refuses it.
  8701	        const previousGlobal = globalSemesterKey;
  8702	        // Empty roster: saveSettings' slot creation then writes nothing to the shared
  8703	        // emulator lessonData (the real updateAppData is stubbed below).
  8704	        currentConfig.semesters['e2e-settings-weekly'] = { ...JSON.parse(JSON.stringify(currentConfig.semesters['spring-2026'])), name: 'E2E Settings Weekly', classRoster: {} };
  8705	        setGlobalSemester('e2e-settings-weekly');
  8706	        loadSettingsForm();
  8707	        const semKey = getSettingsSemKey();
  8708	        const weeksEl = document.getElementById('settings-num-weeks');
  8709	        const savedWeeks = weeksEl.value;
  8710	        weeksEl.value = '14';
  8711	        try {
  8712	          await saveSettings();
  8713	          return {
  8714	            write: writes[0] || null,
  8715	            inMemory: currentConfig.teacherMappings,
  8716	            writtenWeeks: writes[0]?.[`semesters.${semKey}.numWeeks`],
  8717	            inMemoryWeeks: currentConfig.semesters[semKey]?.numWeeks,
  8718	          };
  8719	        } finally {
  8720	          weeksEl.value = savedWeeks;
  8721	          delete currentConfig.semesters['e2e-settings-weekly'];
  8722	          setGlobalSemester(previousGlobal);
  8723	          window.updateAppData = realUpdate;
  8724	          window.getTeacherMappingsFromForm = realGet;
  8725	          currentConfig.teacherMappings = savedMappings;
  8726	        }
  8727	      });
  8728	      // The mapping the form collected must actually reach Firestore…
  8729	      expect(r.write?.teacherMappings).toEqual({ 'TEST Teacher': 'test-uid-123' });
  8730	      // …and this tab's copy must match, or the re-render shows pre-save values
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
   280	
   281	  test('while paused, the real Spring editors refuse before any upload or write (teacher + admin with photos, Plan Complete, all Q&A)', async ({ page }) => {
   282	    await openApp(page);
   283	    await page.evaluate(() => setGlobalSemester('spring-2026'));
   284	    const alerts = [];
   285	    page.on('dialog', d => { alerts.push(d.message()); d.accept(); });
   286	    const before = await SM.readCurriculumDoc('lessonData');
   287	    await page.evaluate(() => { window.__uploads = 0; window.uploadLessonPhoto = async () => { window.__uploads++; return { url: 'x', path: 'x' }; }; });
   288	    const photo = path.join(__dirname, 'fixtures', 'test-image.jpg');
   289	    const expectPaused = async (label) => {
   290	      await expect.poll(() => alerts.join(' | '), { message: label, timeout: 5_000 }).toMatch(PAUSED);
   291	      alerts.length = 0;
   292	    };
   293	
   294	    // Teacher editor: a text change + a new photo, then Save.
   295	    await page.evaluate(({ LESSON }) => openTeacherEditModal(LESSON), { LESSON });
   296	    await page.locator('#te-shortDetails').fill('Edited while paused');
   297	    await page.locator('#te-photo-input').setInputFiles(photo);
   298	    await page.locator('#te-save-btn').click();
   299	    await expectPaused('teacher save');
   300	    // Teacher Q&A from the same editor.
   301	    await page.locator('#te-qa-input').fill('A question while paused');
   302	    await page.locator('#te-qa-send-btn').click();
   303	    await expectPaused('teacher Q&A');
   304	    await page.evaluate(() => document.querySelectorAll('.te-modal-overlay, .te-modal').forEach(e => e.remove()));
   305	
   306	    // Admin editor: title + photo, then save.
   307	    await page.evaluate(({ LESSON }) => showAdminEdit(LESSON, 'Fixture Teacher', 'Fixture Class', 1), { LESSON });
   308	    await page.locator('#ca-edit-title').fill('Admin edit while paused');
   309	    await page.locator('#ca-edit-photo-input').setInputFiles(photo);
   310	    await page.evaluate(({ LESSON }) => saveAdminEdit(LESSON, 'Fixture Teacher', 'Fixture Class', 1), { LESSON });
   311	    await expectPaused('admin save');
   312	
   313	    // Admin help response + Q&A reply (their real input elements).
   314	    await page.evaluate(({ LESSON }) => {
   315	      for (const id of [`ca-help-input-${LESSON}`, `qa-reply-${LESSON}`]) {
   316	        const t = document.createElement('textarea'); t.id = id; t.value = 'Reply while paused'; document.body.appendChild(t);
   317	      }
   318	    }, { LESSON });
   319	    await page.evaluate(({ LESSON }) => sendHelpResponse(LESSON), { LESSON });
   320	    await expectPaused('help response');
   321	    await page.evaluate(({ LESSON }) => sendQaReply(LESSON), { LESSON });
   322	    await expectPaused('Q&A reply');
   323	
   324	    // Plan Complete checkbox on a real Teacher View card.
   325	    await page.evaluate(() => { closeAdminModal?.(true); switchTab('teacher-view'); });
   326	    await page.locator('#tv-teacher-select').selectOption('Fixture Teacher');
   327	    await page.locator('.tv-toggle-btn[data-tv-view="by-class"]').click();   // the card layout that carries Plan Complete
   328	    const cb = page.locator(`#pc-${LESSON}`);
   329	    await expect(cb).toHaveCount(1);
   330	    if (!(await cb.isVisible())) await page.locator('.tv-class-section.tv-collapsed .tv-collapse-toggle').first().click();   // open the collapsed class section
   331	    await expect(cb).toBeVisible();
   332	    const wasChecked = await cb.isChecked();
   333	    await cb.click();
   334	    await expectPaused('plan complete');
   335	    expect(await cb.isChecked()).toBe(wasChecked);
   336	
   337	    expect(await page.evaluate(() => window.__uploads)).toBe(0);
   338	    expect(await SM.readCurriculumDoc('lessonData')).toEqual(before);
   339	  });
   340	
   341	  test('a real overlapping move → undo while a recheck is in flight leaves Spring on its legacy copy, with no false notice', async ({ page }) => {
   342	    await openApp(page);   // legacy state
   343	    // Hold the recheck's server read of the own doc for 2 s, so the undo lands while it's in flight.
   344	    await page.evaluate(() => {
   345	      const DR = firebase.firestore.DocumentReference.prototype;
   346	      const orig = DR.get;
   347	      DR.get = function (opts) {
   348	        if (this.path === 'curriculum/lessons_spring-2026' && opts?.source === 'server') {
   349	          return new Promise(r => setTimeout(r, 2000)).then(() => orig.call(this, opts));
   350	        }
   351	        return orig.call(this, opts);
   352	      };
   353	    });
   354	    await watchMinSpring(page);
   355	    // 1. Spring leaves lessonData (legacy loss → recheck starts, held)…
   356	    const fixtureLessonData = await SM.readCurriculumDoc('lessonData');
   357	    const withoutSpring = { ...fixtureLessonData }; delete withoutSpring['spring-2026'];
   358	    await SM.writeCurriculumDoc('lessonData', withoutSpring);
   359	    await page.waitForTimeout(300);
   360	    // 2. …then comes straight back (the undo), before the held read returns.
   361	    await SM.writeCurriculumDoc('lessonData', fixtureLessonData);
   362	    await page.waitForTimeout(3000);   // the held read resolves (own doc absent) — must be ignored
   363	    expect(await source(page)).toBe('legacy');
   364	    expect(await springKeys(page)).toEqual(fixtureKeys());
   365	    expect(await minSpring(page)).toBe(fixtureKeys().length);
   366	    expect(await page.evaluate(() => { const el = document.getElementById('storage-notice-banner'); return !!el && !el.classList.contains('hidden'); })).toBe(false);
   367	  });
   368	
   369	  test('verified: the real teacher editor saves Spring into its own doc', async ({ page }) => {
   370	    await SM.stageMoved({ verified: true });
   371	    await openApp(page);
   372	    await page.waitForFunction(() => ownDocSource['spring-2026'] === 'ownDoc' && storageMigrationState?.['spring-2026']?.verified === true);
   373	    await page.evaluate(() => setGlobalSemester('spring-2026'));
   374	    await expect(page.locator('#own-doc-paused-notice')).toHaveCount(0);
   375	    const alerts = [];
   376	    page.on('dialog', d => { alerts.push(d.message()); d.accept(); });
   377	    await page.evaluate(({ LESSON }) => openTeacherEditModal(LESSON), { LESSON });
   378	    await page.locator('#te-shortDetails').fill('Saved through the real editor');
   379	    await page.locator('#te-save-btn').click();
   380	    await expect.poll(async () => (await SM.readCurriculumDoc(SM.SPRING_DOC))?.[LESSON]?.shortDetails, { timeout: 10_000 }).toBe('Saved through the real editor');
   381	    expect(alerts.join(' | ')).not.toMatch(PAUSED);
   382	    expect((await SM.readCurriculumDoc('lessonData'))['spring-2026']).toBeUndefined();
   383	  });
   384	
   385	  test('Lesson Storage warns above 85%, and is a manager-only section', async ({ page, browser }) => {
   386	    await openApp(page);   // the suite's account: staff (curriculum-admin)
   387	    await expect(page.locator('.ca-lesson-storage-section')).toBeHidden();
   388	    const text = await page.evaluate(() => {
   389	      lastLegacyLessonData = { big: 'x'.repeat(900 * 1024) };
   390	      renderLessonStorage();
   391	      return document.getElementById('ca-lesson-storage-content').textContent;
   392	    });
   393	    expect(text).toMatch(/nearly full/);
   394	    const { MANAGER_STATE_PATH } = require('./helpers/login');
   395	    const ctx = await browser.newContext({ storageState: MANAGER_STATE_PATH });
   396	    const mgr = await ctx.newPage();
   397	    await login(mgr, 'manager');
   398	    await mgr.waitForFunction(() => lessonDataLoadedSuccessfully === true, null, { timeout: 25_000 });
   399	    await expect(mgr.locator('.ca-lesson-storage-section')).toBeVisible();
   400	    await ctx.close();
   401	  });
   402	});

codex
The three code fixes are present. I’m now checking the dismissal namespace against every alert ID producer, because that pruning loop is the main place a “fixed” lifecycle could accidentally delete unrelated dismissals or its own migration marker.
exec
/bin/zsh -lc "rg -n \"classbook-qa-|type:\\s*['\\\"]curriculum|id:\\s*"'`classbook|id:'"\\s*['\\\"]classbook\" /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc --glob '"'!node_modules/**'"' --glob '"'!*.diff'"'
rg -n \"dismissedAlertIds|dismissedAlerts|saveDismissedAlerts|removeAlert\\(\" /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js | sed -n '1,240p'
rg -n \"while paused|real Spring editors|verified:|Lesson Storage|classRoster: \\{\\}|storageMigrations listener error|updateOwnDocPausedNotice\" /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-classbook-delta.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 exited 1 in 0ms:
zsh:3: unmatched "

exec
/bin/zsh -lc "rg -n 'classbook-qa-|type: .curriculum' /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc --glob '"'!node_modules/**'"' --glob '"'!*.diff'"'
rg -n 'dismissedAlertIds|dismissedAlerts|saveDismissedAlerts|removeAlert\\(' /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js
rg -n 'while paused|real Spring editors|verified:|Lesson Storage|classRoster: \\{\\}|storageMigrations listener error|updateOwnDocPausedNotice' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-classbook-delta.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/package.json:4:    "test:rules": "firebase emulators:exec --only firestore \"node --experimental-vm-modules node_modules/.bin/jest rules.test.js archive-helpers.test.js archive-transaction.test.js classbook-qa-alerts.test.js alerts-classbook.test.js\"",
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/classbook-qa-alerts.test.js:2: * Pure-function tests for js/classbook-qa-alerts.js — no Firestore, no DOM.
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/classbook-qa-alerts.test.js:5:const { buildClassbookQaAlerts } = require('./js/classbook-qa-alerts.js');
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/classbook-qa-alerts.test.js:18:    expect(out.map(a => a.id)).toEqual(['classbook-qa-fall-2026-mariah-tue-1']);
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/classbook-qa-alerts.test.js:19:    expect(out[0].legacyId).toBe('classbook-qa-mariah-tue-1');
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/classbook-qa-alerts.test.js:29:    expect(out.map(a => a.id).sort()).toEqual(['classbook-qa-fall-2026-k-1', 'classbook-qa-spring-2026-k-1']);
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/classbook-qa-alerts.test.js:38:    expect(out.map(a => a.id)).toEqual(['classbook-qa-spring-2026-fresh-1']);
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/classbook-qa-alerts.test.js:44:    expect(out.map(a => a.id)).toEqual(['classbook-qa-spring-2026-s-1']);
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:41:  vm.runInContext(fs.readFileSync('js/classbook-qa-alerts.js', 'utf8'), ctx);
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:65:    expect(h.ids()).toEqual(['classbook-qa-fall-2026-f-1', 'classbook-qa-spring-2026-s-1']);
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:74:    expect(h.ids()).toEqual(['classbook-qa-spring-2026-s-1']);
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:86:    expect(h.ids()).toEqual(['classbook-qa-fall-2026-f-2', 'classbook-qa-spring-2026-s-1']);
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:94:    expect(h.ids()).toEqual(['classbook-qa-fall-2026-f-1']);
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:98:    const h = loadEngine({ dismissed: ['classbook-qa-k-1', 'classbook-qa-k-9'] });
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:104:    expect(d).toEqual(expect.arrayContaining(['classbook-qa-fall-2026-k-1', 'classbook-qa-spring-2026-k-1', 'classbook-qa-dismissals-migrated-v2']));
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:105:    expect(d).not.toContain('classbook-qa-k-1');       // retired
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:108:    expect(h.ids()).toEqual(['classbook-qa-fall-2026-k-9']);
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:112:    const h = loadEngine({ dismissed: ['classbook-qa-dismissals-migrated-v2', 'classbook-qa-k-1'] });
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:116:    expect(h.ids()).toEqual(['classbook-qa-fall-2026-k-1']);
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:122:    const h = loadEngine({ dismissed: ['classbook-qa-k-1'] });
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:128:    expect(h.dismissedIds()).not.toContain('classbook-qa-fall-2026-k-1');   // answered → dismissal forgotten
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:130:    expect(h.ids()).toEqual(['classbook-qa-fall-2026-k-1']);
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:134:    const h = loadEngine({ dismissed: ['classbook-qa-s-1'] });
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:138:    expect(h.dismissedIds()).not.toContain('classbook-qa-dismissals-migrated-v2');
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:141:    expect(h.dismissedIds()).toEqual(expect.arrayContaining(['classbook-qa-spring-2026-s-1', 'classbook-qa-dismissals-migrated-v2']));
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:145:    const h = loadEngine({ dismissed: ['classbook-qa-dismissals-migrated-v2', 'classbook-qa-spring-2026-s-1'] });
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:149:    expect(h.dismissedIds()).toContain('classbook-qa-spring-2026-s-1');
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/classbook-qa-alerts.js:41:      id: `classbook-qa-${semKey}-${lessonKey}`,
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/classbook-qa-alerts.js:42:      legacyId: `classbook-qa-${lessonKey}`,
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/classbook-qa-alerts.js:43:      type: 'curriculum',
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:561:  const CLASSBOOK_QA_DISMISSALS_MIGRATED = 'classbook-qa-dismissals-migrated-v2';
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:568:    // latest snapshot of each (buildClassbookQaAlerts, js/classbook-qa-alerts.js), so
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:583:      // (classbook-qa-<lessonKey>): each currently-open question whose old id was
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:616:          if (id.startsWith('classbook-qa-') && id !== CLASSBOOK_QA_DISMISSALS_MIGRATED
/Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/index.html:224:  <script src="js/classbook-qa-alerts.js"></script>
6:  let dismissedAlerts = []; // Dismissed alerts (with full alert objects)
7:  let dismissedAlertIds = new Set(); // Persistent dismissed IDs (loaded from Firestore)
30:    dismissedAlerts = [];
31:    dismissedAlertIds = new Set();
56:      const local = localStorage.getItem('studioHub_dismissedAlerts');
57:      if (local) dismissedAlertIds = new Set(JSON.parse(local));
65:        const ids = doc.data().dismissedAlertIds || [];
67:          dismissedAlertIds = new Set(ids);
68:          localStorage.setItem('studioHub_dismissedAlerts', JSON.stringify(ids));
76:  async function saveDismissedAlerts() {
77:    const ids = Array.from(dismissedAlertIds);
80:    localStorage.setItem('studioHub_dismissedAlerts', JSON.stringify(ids));
86:        dismissedAlertIds: ids
126:              removeAlert(alertId);
130:            removeAlert(`timeclock-late-${change.doc.id}`);
161:            removeAlert(alertId);
199:            removeAlert(alertId);
238:            removeAlert(alertId);
295:          removeAlert(alertId);
314:            removeAlert(alertId);
337:            removeAlert(alertId);
377:              removeAlert(alertId);
380:            removeAlert(alertId);
434:        staleIds.forEach(id => removeAlert(id));
452:            removeAlert(alertId);
478:              removeAlert(alertId);
481:            removeAlert(alertId);
541:            removeAlert(alert.id);
591:      if (complete && !dismissedAlertIds.has(CLASSBOOK_QA_DISMISSALS_MIGRATED)) {
594:          if (dismissedAlertIds.has(alert.legacyId)) {
595:            dismissedAlertIds.add(alert.id);
599:        retired.forEach(id => dismissedAlertIds.delete(id));
600:        dismissedAlertIds.add(CLASSBOOK_QA_DISMISSALS_MIGRATED);
601:        saveDismissedAlerts();
607:          removeAlert(alert.id);
615:        [...dismissedAlertIds].forEach(id => {
617:              && dismissedAlertIds.has(CLASSBOOK_QA_DISMISSALS_MIGRATED)
619:            dismissedAlertIds.delete(id);
620:            dismissedAlerts = dismissedAlerts.filter(a => a.id !== id);
624:        if (prunedDismissals) saveDismissedAlerts();
672:    if (dismissedAlertIds.has(alert.id)) {
675:      const existingIndex = dismissedAlerts.findIndex(a => a.id === alert.id);
677:        dismissedAlerts[existingIndex] = alert;
679:        dismissedAlerts.push(alert);
692:  function removeAlert(alertId) {
695:    if (dismissedAlertIds.has(alertId)) {
696:      dismissedAlertIds.delete(alertId);
697:      dismissedAlerts = dismissedAlerts.filter(a => a.id !== alertId);
698:      saveDismissedAlerts();
707:      dismissedAlerts.push(alert);
709:      dismissedAlertIds.add(alertId);
710:      saveDismissedAlerts();
716:    const alert = dismissedAlerts.find(a => a.id === alertId);
721:      dismissedAlerts = dismissedAlerts.filter(a => a.id !== alertId);
722:      dismissedAlertIds.delete(alertId);
723:      saveDismissedAlerts();
739:        const count = dismissedAlerts.length;
760:      countEl.textContent = dismissedAlerts.length;
785:    let allAlerts = showDismissed ? [...alerts, ...dismissedAlerts] : [...alerts];
937:    getDismissedCount: () => dismissedAlerts.length,
12:+        currentConfig.semesters['e2e-settings-weekly'] = { ...JSON.parse(JSON.stringify(currentConfig.semesters['spring-2026'])), name: 'E2E Settings Weekly', classRoster: {} };
25:+  test('while paused, the real Spring editors refuse before any upload or write (teacher + admin with photos, Plan Complete, all Q&A)', async ({ page }) => {
40:+    await page.locator('#te-shortDetails').fill('Edited while paused');
45:+    await page.locator('#te-qa-input').fill('A question while paused');
52:+    await page.locator('#ca-edit-title').fill('Admin edit while paused');
60:+        const t = document.createElement('textarea'); t.id = id; t.value = 'Reply while paused'; document.body.appendChild(t);
113:+  test('verified: the real teacher editor saves Spring into its own doc', async ({ page }) => {
114:+    await SM.stageMoved({ verified: true });
129:+  test('Lesson Storage warns above 85%, and is a manager-only section', async ({ page, browser }) => {
155:+  // Lesson Storage headroom (Spring 2026 storage move) is a manager readout.
168:       updateOwnDocPausedNotice();
169:-    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; }));
170:+    }, err => { console.warn('⚠️ storageMigrations listener error — own-doc semesters stay read-only:', err); storageMigrationState = {}; updateOwnDocPausedNotice(); }));

exec
/bin/zsh -lc "sed -n '10480,10555p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-codex.md
sed -n '1,70p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r2-claude.md
nl -ba /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js | sed -n '90,160p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
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
I reviewed the code on disk in both worktrees (not only the two diffs — see the note at the end, which matters).

## 1. Round-1 findings

**Finding 1 — Spring's paused state neither visible nor side-effect-free: RESOLVED.**

- Standing notice: `updateOwnDocPausedNotice()` `js/firebase-data.js:177`, called on load (`js/app.js:172`), on every semester change (`js/app.js:101`), and on every state change (`js/firebase-data.js:940, 1427, 1428, 1449, 1455`). Styled `.storage-notice` `css/styles.css:2430`.
- A common preflight, `refuseIfWeeklySemesterPaused()` `js/firebase-data.js:169`, is called before the *first* change in every workflow the finding named: `saveTeacherEdit` `js/app.js:3513` (before the Storage upload at `3535`), `saveAdminEdit` `js/app.js:5641` (before `caEditSaveInFlight` and the upload at `5810`), the Plan Complete checkbox `js/app.js:2881` (before the optimistic `lesson.planComplete` at `2883`), `cutProject` `js/app.js:6348` (before the Cut Bank write at `6390` — no more deliberate duplicate), `saveSettings` `js/app.js:11363` (before `updateAppData` at `11452` and the slot write at `11469`), plus `handleGridAction:5957`, `executeCopyPlan:6235`, `pasteFromCutBank:6512`, `pasteFromIdeaBank:6984`.
- The three Q&A senders resolve their target before any write and surface the exact message: `js/app.js:3739`, `7272`, `7361`.
- The specific message survives the catch paths: `js/app.js:3660` (teacher save), `2894` (Plan Complete), `5847` (admin edit).

**Finding 2 — `recheckOwnDocAfterLegacyLoss()` installing stale state: RESOLVED.** `ownDocTransitionToken` / `bumpOwnDocToken` `js/firebase-data.js:194`, bumped on every legacy snapshot (`1400`) and every own-doc snapshot (`1433`); the recheck applies only if the token still matches *and* the source isn't already `ownDoc` (`936`), and the "moved — reload" notice is likewise token-gated (`947`). Each recheck gets a unique token, so only the newest can apply; a superseding legacy snapshot restarts a fresh recheck, so it self-heals rather than stalling.

**Finding 3 — Studio Hub legacy dismissal kept forever: RESOLVED, and then some.** The one-time migration converts open legacy ids and *retires* the ones it converted, behind a marker (`studio-hub/js/alerts.js:591-602`). On disk it now also prunes any `classbook-qa-*` dismissal that is no longer an open question (`alerts.js:613-625`), so an answered-then-re-asked question alerts again — that block is **not in the diff you gave me**.

**Finding 4 — Spring alerts dropped on an own-doc listener error: RESOLVED.** The error handler keeps the last good snapshot and only marks the document as reported when none ever arrived (`alerts.js:652-662`); a first-snapshot failure is tracked in `failedBeforeFirst` (`alerts.js:572`) and suppresses both migration and pruning while degraded (`alerts.js:590`). Residual, pre-existing and unchanged: a `lessonData` listener error *before its first* snapshot leaves `rebuild()` permanently gated, so no Classbook alerts at all (`alerts.js:639-641`).

**Finding 5 — tests: PARTLY RESOLVED.** New `e2e/spring-own-doc.spec.js` (14 tests), `studio-hub/alerts-classbook.test.js` (the real `AlertEngine` in a vm, incl. migration and both error orderings), `classbook-qa-alerts.test.js`, and two ratchets. The admin helper is properly fenced (`e2e/helpers/storage-move.js:76-84` reuses `requireEmulatorEnv` + a `demo-` project check; no credential file, `firebase-admin` is a real dependency), and it now resets in `beforeEach` **and** `afterEach` with the suite-global caveat documented (`spring-own-doc.spec.js:148-151`). Gaps still open — see §3.

## 2. Adversarial pass on the whole change

**Every caller of the writers, checked for a write-before-refusal.** `saveSingleLesson` has 8 call sites: `js/app.js:1815` (SDOC) and `2367`, `12093` (summer) can't be a weekly semester; the other five are guarded above. `saveMultipleLessonFields` (`6020, 6093, 6114`) is `handleGridAction` only. `deleteLessonKey` (`6401`) is `cutProject` only. `saveLessonData` (`5038` `createNewSemester`, `11558` `createLessonSlotsForRoster`) — the first is unreachable for `spring-2026` (the key-exists checks at `js/app.js:4937` and `5050` refuse it, and `deleteSemester` can no longer remove it), the second sits behind `saveSettings`' guard. `deleteLessonData` refuses own-doc semesters itself (`js/firebase-data.js:1164`) and `deleteSemester` refuses before touching `appData` (`js/app.js:4599`). `uploadLessonPhoto`'s only two callers are both downstream of a guard. `saveCutProjects` has no callers. `restoreFromBackup` has no UI caller. **No Spring workflow writes anything before refusing.**

Deliberately still writable for Spring while paused, all single atomic writes with no half-state: `deleteCutProject` (`js/app.js:6690`), the source-side `arrayRemove` when pasting *out of* Spring's cut bank (`6583`), `toggleSemesterPublish` (`4677`), prep data and change-log. Those documents aren't moving, so that's consistent with the plan's scope — worth Christie knowing the pause means "lesson editing", not "Spring is frozen".

**Fall and other semesters.** `weeklyLessonTarget` returns the identical ref and `${semKey}.` prefix for anything not in `OWN_DOC_SEMESTERS` (`js/firebase-data.js:119`); `buildLessonFieldUpdates` keeps the old default prefix (`1718`); `readWeeklySemesterMap` does exactly one legacy read for Fall (`131`). The listener's new loop only touches `spring-2026`. I found no behavioural change for Fall. Two costs: `computeLiveContentCountByTeacher` now does one extra `get` per own-doc semester even pre-move (`js/app.js:7616`), and the legacy snapshot handler calls `doc.data()` twice (`1396-1397`), decoding a ~1 MB document twice per snapshot. Both acceptable; the second is easy to halve later.

**Token logic / transitions.** Move-then-own-doc and own-doc-then-move both land on `ownDoc` without blanking; `previousOwn` carry-across (`1394-1409`) means Spring is never emptied; `error` is sticky and unwritable by design. One cosmetic rough edge: on a rollback whose *own-doc* snapshot arrives before the legacy one, `lastLegacyLessonData` doesn't yet hold Spring, so a spurious "storage changed — please reload" banner flashes before the legacy snapshot hides it (`1442-1444`, then `1407`). Nothing blanks; the tested ordering is the other one.

**Writability can only be wrong in the safe direction.** `ownDocSource` starts `{}` and `storageMigrationState` starts `null`, so Spring is paused until both are known, and a failed read of either keeps it paused. Writes reach `lessons_spring-2026` only when it exists *and* `verified === true`; `verified` is one-way and delete-after-verified is denied in the live rules, so the client's writable window is a strict subset of what the rules permit. I confirmed against the deployed Phase A rules that classbook teachers can *read* both `lessons_spring-2026` and `storageMigrations` (`studio-hub/firestore.rules:711`) — without that read the pause would never lift for teachers in Phase C.

**Standing notice vs. guards.** The notice reads `globalSemesterKey`; the guards read `getActiveSemesterKey()`, which falls back to `activeSemester` when the global key is unset. `initGlobalSemesterSelector()` (`js/app.js:65-70`) always sets a real key before `loadLessonData()`, so they agree in practice. Only a degenerate "no visible semesters" state diverges, and there it fails safe (actions refuse, notice hidden).

**Studio Hub.** The union rebuild is correct; `CLASSBOOK_OWN_DOC_SEMESTERS` is a top-level `const` in a script loaded before `alerts.js` (`index.html:224`), so the global binding resolves. `type: 'curriculum'` is produced nowhere else, so the prune loop can't evict another feature's alerts. The re-key is the only breaking change and `legacyId` covers it.

## 3. Verdict: **NOT SAFE TO DEPLOY as it stands** — no code blocker remains; the list is procedural plus one test fix.

1. **Both diffs are stale, and the Classbook tree is dirty.** Classbook HEAD is `a7f0d0e` but `git status` shows `js/firebase-data.js` and `e2e/spring-own-doc.spec.js` modified — an extra `updateOwnDocPausedNotice()` in the `storageMigrations` error handler, plus two substantial new tests (a real-UI paused test covering teacher/admin editors with photos, all three Q&A senders and Plan Complete; and a real overlapping move→undo race). Studio Hub's `js/alerts.js` **changed between two reads during this review** (the `failedBeforeFirst` and dismissal-pruning blocks). Commit and push both sides, then re-diff — `npm run deploy` refuses a dirty tree or unpushed HEAD anyway, and neither deploy should ship bytes nobody reviewed.
2. **Run both suites against the committed state.** I did not run them, as instructed, and I can't vouch for the two new Classbook tests or the three new Studio Hub ones. Classbook: `npm test`. Studio Hub: `npm test` (its `test:rules` now also runs `classbook-qa-alerts.test.js` and `alerts-classbook.test.js`).
3. **Fix the test-isolation leak introduced in `e2e/data-safety.spec.js:8702-8710`.** Cloning `spring-2026` into a throwaway `e2e-settings-weekly` and calling the real `saveSettings()` mocks only `updateAppData` — `createLessonSlotsForRoster` (`js/app.js:11469`) still runs and really writes 28 empty slots under `e2e-settings-weekly` into the emulator's shared `curriculum/lessonData` via `saveLessonData` (`js/app.js:11558`). The `finally` at `8719` removes only the in-memory config entry. Harmless to production and to the content-count assertions (the slots carry no content), but it pollutes the shared seed for the rest of the run. Stub `createLessonSlotsForRoster`, give the throwaway an empty `classRoster`, or delete the key from Firestore in the `finally`.

Recommended but not blocking: cover the *verified* state through at least one real UI path (teacher save + admin move/swap) so Phase C's flip is exercised end-to-end rather than only through the low-level writers; test the >85% headroom warning branch; and decide whether the new "Lesson Storage" section should be manager-gated, as the plan specified Diagnostics/managers (`index.html:354`).

No files were edited and no tests were run.
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
   119	
   120	describe('AlertEngine — Classbook dismissal lifecycle (review round 2)', () => {
   121	  test('a migrated dismissal is forgotten once answered; a new question then alerts', async () => {
   122	    const h = loadEngine({ dismissed: ['classbook-qa-k-1'] });
   123	    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
   124	    h.fire(LD, { 'fall-2026': { 'k-1': q('dismissed before') } });
   125	    h.fire(SPRING, null);
   126	    expect(h.ids()).toEqual([]);                                  // still dismissed (migrated)
   127	    h.fire(LD, { 'fall-2026': { 'k-1': { qaThread: [{ from: 'teacher', message: 'q' }, { from: 'admin', message: 'a' }] } } });
   128	    expect(h.dismissedIds()).not.toContain('classbook-qa-fall-2026-k-1');   // answered → dismissal forgotten
   129	    h.fire(LD, { 'fall-2026': { 'k-1': q('a NEW question on the same lesson') } });
   130	    expect(h.ids()).toEqual(['classbook-qa-fall-2026-k-1']);
   131	  });
   132	
   133	  test('an own-doc error before its first snapshot: no migration marker; a later successful load migrates', async () => {
   134	    const h = loadEngine({ dismissed: ['classbook-qa-s-1'] });
   135	    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
   136	    h.fire(LD, { 'fall-2026': {} });
   137	    h.fail(SPRING);
   138	    expect(h.dismissedIds()).not.toContain('classbook-qa-dismissals-migrated-v2');
   139	    h.fire(SPRING, { 's-1': q('spring question dismissed before') });   // recovers
   140	    expect(h.ids()).toEqual([]);                                         // migrated, still dismissed
   141	    expect(h.dismissedIds()).toEqual(expect.arrayContaining(['classbook-qa-spring-2026-s-1', 'classbook-qa-dismissals-migrated-v2']));
   142	  });
   143	
   144	  test('while a source is degraded, dismissals are not pruned', async () => {
   145	    const h = loadEngine({ dismissed: ['classbook-qa-dismissals-migrated-v2', 'classbook-qa-spring-2026-s-1'] });
   146	    await h.engine.init({ uid: 'u', role: 'admin' }, h.db);
   147	    h.fire(LD, { 'fall-2026': {} });
   148	    h.fail(SPRING);
   149	    expect(h.dismissedIds()).toContain('classbook-qa-spring-2026-s-1');
   150	  });
   151	});

exec
/bin/zsh -lc "git status --short --branch
git log -1 --oneline --decorate
git -C /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc status --short --branch
git -C /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc log -1 --oneline --decorate
rg -n '"'^diff --git|''^index '"' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-classbook-delta.diff /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-studiohub.diff" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-ExVv3Ngf' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-63qkMfW9' (errno=Operation not permitted)
## claude/spring-own-doc...origin/claude/spring-own-doc
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-CiGiZeoL' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-Kd6kCqPG' (errno=Operation not permitted)
9e551c2 (HEAD -> claude/spring-own-doc, origin/claude/spring-own-doc) Phase B review round 2 (Claude): manager-only storage readout; no stray test writes; verified-path UI test
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-fiAvOlWr' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-XrHqbxm0' (errno=Operation not permitted)
## claude/classbook-alerts-own-doc...origin/claude/classbook-alerts-own-doc
?? node_modules
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-GEsjSi9x' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-WnzWw6J2' (errno=Operation not permitted)
85a488c (HEAD -> claude/classbook-alerts-own-doc, origin/claude/classbook-alerts-own-doc) alerts: review fixes — dismissal lifecycle, degraded sources, real-engine tests
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-studiohub.diff:1:diff --git a/alerts-classbook.test.js b/alerts-classbook.test.js
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-studiohub.diff:3:index 0000000..d76717f
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-studiohub.diff:158:diff --git a/classbook-qa-alerts.test.js b/classbook-qa-alerts.test.js
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-studiohub.diff:160:index 0000000..85413a1
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-studiohub.diff:221:diff --git a/index.html b/index.html
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-studiohub.diff:222:index 567518f..71bcccb 100644
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-studiohub.diff:233:diff --git a/js/alerts.js b/js/alerts.js
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-studiohub.diff:234:index 74f5b36..e19a047 100644
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-studiohub.diff:426:diff --git a/js/classbook-qa-alerts.js b/js/classbook-qa-alerts.js
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-studiohub.diff:428:index 0000000..586ad18
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-studiohub.diff:510:diff --git a/package.json b/package.json
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-studiohub.diff:511:index 45f1582..630f0a4 100644
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-classbook-delta.diff:1:diff --git a/e2e/data-safety.spec.js b/e2e/data-safety.spec.js
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-classbook-delta.diff:2:index 6037ce7..85e7285 100644
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-classbook-delta.diff:16:diff --git a/e2e/spring-own-doc.spec.js b/e2e/spring-own-doc.spec.js
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-classbook-delta.diff:17:index 7ca2a71..2220f4b 100644
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-classbook-delta.diff:147:diff --git a/js/app.js b/js/app.js
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-classbook-delta.diff:148:index af3745d..f5dce8c 100644
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-classbook-delta.diff:161:diff --git a/js/firebase-data.js b/js/firebase-data.js
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-30-impl-review-storage-phaseB-r3-classbook-delta.diff:162:index 656abef..3138c56 100644

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js | sed -n '45,92p'
nl -ba /Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/classbook-qa-alerts.js | sed -n '1,70p'
nl -ba e2e/spring-own-doc.spec.js | sed -n '281,405p'
ls -l e2e/fixtures/test-image.jpg" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
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
   281	  test('while paused, the real Spring editors refuse before any upload or write (teacher + admin with photos, Plan Complete, all Q&A)', async ({ page }) => {
   282	    await openApp(page);
   283	    await page.evaluate(() => setGlobalSemester('spring-2026'));
   284	    const alerts = [];
   285	    page.on('dialog', d => { alerts.push(d.message()); d.accept(); });
   286	    const before = await SM.readCurriculumDoc('lessonData');
   287	    await page.evaluate(() => { window.__uploads = 0; window.uploadLessonPhoto = async () => { window.__uploads++; return { url: 'x', path: 'x' }; }; });
   288	    const photo = path.join(__dirname, 'fixtures', 'test-image.jpg');
   289	    const expectPaused = async (label) => {
   290	      await expect.poll(() => alerts.join(' | '), { message: label, timeout: 5_000 }).toMatch(PAUSED);
   291	      alerts.length = 0;
   292	    };
   293	
   294	    // Teacher editor: a text change + a new photo, then Save.
   295	    await page.evaluate(({ LESSON }) => openTeacherEditModal(LESSON), { LESSON });
   296	    await page.locator('#te-shortDetails').fill('Edited while paused');
   297	    await page.locator('#te-photo-input').setInputFiles(photo);
   298	    await page.locator('#te-save-btn').click();
   299	    await expectPaused('teacher save');
   300	    // Teacher Q&A from the same editor.
   301	    await page.locator('#te-qa-input').fill('A question while paused');
   302	    await page.locator('#te-qa-send-btn').click();
   303	    await expectPaused('teacher Q&A');
   304	    await page.evaluate(() => document.querySelectorAll('.te-modal-overlay, .te-modal').forEach(e => e.remove()));
   305	
   306	    // Admin editor: title + photo, then save.
   307	    await page.evaluate(({ LESSON }) => showAdminEdit(LESSON, 'Fixture Teacher', 'Fixture Class', 1), { LESSON });
   308	    await page.locator('#ca-edit-title').fill('Admin edit while paused');
   309	    await page.locator('#ca-edit-photo-input').setInputFiles(photo);
   310	    await page.evaluate(({ LESSON }) => saveAdminEdit(LESSON, 'Fixture Teacher', 'Fixture Class', 1), { LESSON });
   311	    await expectPaused('admin save');
   312	
   313	    // Admin help response + Q&A reply (their real input elements).
   314	    await page.evaluate(({ LESSON }) => {
   315	      for (const id of [`ca-help-input-${LESSON}`, `qa-reply-${LESSON}`]) {
   316	        const t = document.createElement('textarea'); t.id = id; t.value = 'Reply while paused'; document.body.appendChild(t);
   317	      }
   318	    }, { LESSON });
   319	    await page.evaluate(({ LESSON }) => sendHelpResponse(LESSON), { LESSON });
   320	    await expectPaused('help response');
   321	    await page.evaluate(({ LESSON }) => sendQaReply(LESSON), { LESSON });
   322	    await expectPaused('Q&A reply');
   323	
   324	    // Plan Complete checkbox on a real Teacher View card.
   325	    await page.evaluate(() => { closeAdminModal?.(true); switchTab('teacher-view'); });
   326	    await page.locator('#tv-teacher-select').selectOption('Fixture Teacher');
   327	    await page.locator('.tv-toggle-btn[data-tv-view="by-class"]').click();   // the card layout that carries Plan Complete
   328	    const cb = page.locator(`#pc-${LESSON}`);
   329	    await expect(cb).toHaveCount(1);
   330	    if (!(await cb.isVisible())) await page.locator('.tv-class-section.tv-collapsed .tv-collapse-toggle').first().click();   // open the collapsed class section
   331	    await expect(cb).toBeVisible();
   332	    const wasChecked = await cb.isChecked();
   333	    await cb.click();
   334	    await expectPaused('plan complete');
   335	    expect(await cb.isChecked()).toBe(wasChecked);
   336	
   337	    expect(await page.evaluate(() => window.__uploads)).toBe(0);
   338	    expect(await SM.readCurriculumDoc('lessonData')).toEqual(before);
   339	  });
   340	
   341	  test('a real overlapping move → undo while a recheck is in flight leaves Spring on its legacy copy, with no false notice', async ({ page }) => {
   342	    await openApp(page);   // legacy state
   343	    // Hold the recheck's server read of the own doc for 2 s, so the undo lands while it's in flight.
   344	    await page.evaluate(() => {
   345	      const DR = firebase.firestore.DocumentReference.prototype;
   346	      const orig = DR.get;
   347	      DR.get = function (opts) {
   348	        if (this.path === 'curriculum/lessons_spring-2026' && opts?.source === 'server') {
   349	          return new Promise(r => setTimeout(r, 2000)).then(() => orig.call(this, opts));
   350	        }
   351	        return orig.call(this, opts);
   352	      };
   353	    });
   354	    await watchMinSpring(page);
   355	    // 1. Spring leaves lessonData (legacy loss → recheck starts, held)…
   356	    const fixtureLessonData = await SM.readCurriculumDoc('lessonData');
   357	    const withoutSpring = { ...fixtureLessonData }; delete withoutSpring['spring-2026'];
   358	    await SM.writeCurriculumDoc('lessonData', withoutSpring);
   359	    await page.waitForTimeout(300);
   360	    // 2. …then comes straight back (the undo), before the held read returns.
   361	    await SM.writeCurriculumDoc('lessonData', fixtureLessonData);
   362	    await page.waitForTimeout(3000);   // the held read resolves (own doc absent) — must be ignored
   363	    expect(await source(page)).toBe('legacy');
   364	    expect(await springKeys(page)).toEqual(fixtureKeys());
   365	    expect(await minSpring(page)).toBe(fixtureKeys().length);
   366	    expect(await page.evaluate(() => { const el = document.getElementById('storage-notice-banner'); return !!el && !el.classList.contains('hidden'); })).toBe(false);
   367	  });
   368	
   369	  test('verified: the real teacher editor saves Spring into its own doc', async ({ page }) => {
   370	    await SM.stageMoved({ verified: true });
   371	    await openApp(page);
   372	    await page.waitForFunction(() => ownDocSource['spring-2026'] === 'ownDoc' && storageMigrationState?.['spring-2026']?.verified === true);
   373	    await page.evaluate(() => setGlobalSemester('spring-2026'));
   374	    await expect(page.locator('#own-doc-paused-notice')).toHaveCount(0);
   375	    const alerts = [];
   376	    page.on('dialog', d => { alerts.push(d.message()); d.accept(); });
   377	    await page.evaluate(({ LESSON }) => openTeacherEditModal(LESSON), { LESSON });
   378	    await page.locator('#te-shortDetails').fill('Saved through the real editor');
   379	    await page.locator('#te-save-btn').click();
   380	    await expect.poll(async () => (await SM.readCurriculumDoc(SM.SPRING_DOC))?.[LESSON]?.shortDetails, { timeout: 10_000 }).toBe('Saved through the real editor');
   381	    expect(alerts.join(' | ')).not.toMatch(PAUSED);
   382	    expect((await SM.readCurriculumDoc('lessonData'))['spring-2026']).toBeUndefined();
   383	  });
   384	
   385	  test('Lesson Storage warns above 85%, and is a manager-only section', async ({ page, browser }) => {
   386	    await openApp(page);   // the suite's account: staff (curriculum-admin)
   387	    await expect(page.locator('.ca-lesson-storage-section')).toBeHidden();
   388	    const text = await page.evaluate(() => {
   389	      lastLegacyLessonData = { big: 'x'.repeat(900 * 1024) };
   390	      renderLessonStorage();
   391	      return document.getElementById('ca-lesson-storage-content').textContent;
   392	    });
   393	    expect(text).toMatch(/nearly full/);
   394	    const { MANAGER_STATE_PATH } = require('./helpers/login');
   395	    const ctx = await browser.newContext({ storageState: MANAGER_STATE_PATH });
   396	    const mgr = await ctx.newPage();
   397	    await login(mgr, 'manager');
   398	    await mgr.waitForFunction(() => lessonDataLoadedSuccessfully === true, null, { timeout: 25_000 });
   399	    await expect(mgr.locator('.ca-lesson-storage-section')).toBeVisible();
   400	    await ctx.close();
   401	  });
   402	});
-rw-r--r--@ 1 christiehubley  staff  149 Sep 21 16:26 e2e/fixtures/test-image.jpg

codex
**SAFE TO DEPLOY — minimum code list resolved.**

- **RESOLVED — dismissal lifecycle.** Answered questions remove qualified dismissals at [alerts.js:613](</Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:613>); regression coverage is at [alerts-classbook.test.js:121](</Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:121>).
- **RESOLVED — no migration marker after an initial source error.** Degraded sources prevent migration/pruning at [alerts.js:572](</Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:572>) and [alerts.js:590](</Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:590>), covered at [alerts-classbook.test.js:133](</Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:133>).
- **RESOLVED — migration-listener error notice.** The error callback now refreshes the standing notice at [firebase-data.js:1428](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1428).
- **RESOLVED — real Spring UI coverage.** Teacher/admin saves with photos, Plan Complete, and all three Q&A flows are exercised at [spring-own-doc.spec.js:281](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/spring-own-doc.spec.js:281).
- **RESOLVED — shared-emulator slot leak.** The throwaway semester now has an empty roster at [data-safety.spec.js:8702](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/data-safety.spec.js:8702).
- **RESOLVED — manager gating.** The storage section is hidden below manager at [app.js:321](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:321), covered at [spring-own-doc.spec.js:385](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/spring-own-doc.spec.js:385).
- **RESOLVED — commit/push state.** Both branches equal their origins (`9e551c2`, `85a488c`); Studio Hub has only untracked `node_modules`.

No pruning regression found: the loop is limited to `classbook-qa-*`, that namespace has no other alert producer, incomplete sources disable pruning, and the migration marker is explicitly exempted at [alerts.js:616](</Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:616>). Test execution was not independently verified, per instruction not to run tests.
tokens used
57,819
**SAFE TO DEPLOY — minimum code list resolved.**

- **RESOLVED — dismissal lifecycle.** Answered questions remove qualified dismissals at [alerts.js:613](</Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:613>); regression coverage is at [alerts-classbook.test.js:121](</Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:121>).
- **RESOLVED — no migration marker after an initial source error.** Degraded sources prevent migration/pruning at [alerts.js:572](</Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:572>) and [alerts.js:590](</Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:590>), covered at [alerts-classbook.test.js:133](</Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/alerts-classbook.test.js:133>).
- **RESOLVED — migration-listener error notice.** The error callback now refreshes the standing notice at [firebase-data.js:1428](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1428).
- **RESOLVED — real Spring UI coverage.** Teacher/admin saves with photos, Plan Complete, and all three Q&A flows are exercised at [spring-own-doc.spec.js:281](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/spring-own-doc.spec.js:281).
- **RESOLVED — shared-emulator slot leak.** The throwaway semester now has an empty roster at [data-safety.spec.js:8702](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/data-safety.spec.js:8702).
- **RESOLVED — manager gating.** The storage section is hidden below manager at [app.js:321](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:321), covered at [spring-own-doc.spec.js:385](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/e2e/spring-own-doc.spec.js:385).
- **RESOLVED — commit/push state.** Both branches equal their origins (`9e551c2`, `85a488c`); Studio Hub has only untracked `node_modules`.

No pruning regression found: the loop is limited to `classbook-qa-*`, that namespace has no other alert producer, incomplete sources disable pruning, and the migration marker is explicitly exempted at [alerts.js:616](</Users/christiehubley/studio-hub/.claude/worktrees/classbook-alerts-own-doc/js/alerts.js:616>). Test execution was not independently verified, per instruction not to run tests.
