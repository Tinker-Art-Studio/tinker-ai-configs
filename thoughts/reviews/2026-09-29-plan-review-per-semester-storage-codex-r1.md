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
session id: 01a0ef03-102c-7fc0-84a2-3ee8115315ad
--------
user
## Independent review — plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (revision 2; read the whole Decisions Log). Context: production curriculum/lessonData (one Firestore doc holding every Fall/Spring semester's lessons) is at 972 KB of the 1 MiB cap; this plan moves the finished Spring 2026 semester into its own document. A Claude round-1 review is at /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md — read it so you don't repeat settled points, but don't trust it.
Repo (read-only, main 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Rules + rules tests: /Users/christiehubley/studio-hub/firestore.rules, /Users/christiehubley/studio-hub/rules.test.js . Other readers: /Users/christiehubley/studio-hub/js/alerts.js, /Users/christiehubley/tinker-backups/backup.js (read only; an agent must never edit or run it).
Be adversarial and verify against the code, citing file:line and concrete failing inputs:
1. Can any phase lose, hide, duplicate, or misroute a lesson edit? Consider tabs on old code (pre-Phase-B), tabs loaded between phases, in-flight saves, the listener/generation logic, the "editing is paused" window, the copy transaction and hash verification, and the delete.
2. Phase A rules: is splitting line 654 and the affectedKeys fence correct for every role and every other /curriculum doc and every other app touching /curriculum? Is the near-1 MB test fixture approach sound? Is Q3 (manager whole-doc delete) handled right?
3. Completeness of the reader/writer list and of Phase B's changes.
4. Is anything simpler and equally safe being missed, given ~52 KB headroom?
Verdict: EXECUTION-READY or NOT (minimum list). Do not edit files or run tests.
codex
I’ll do a read-only, adversarial review of the full revision-2 plan and Decisions Log, then cross-check every referenced reader, writer, rule, and test. I’ll cite exact lines and use concrete failure scenarios; I won’t edit files or run tests.
exec
/bin/zsh -lc "wc -l /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md && sed -n '1,260p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html && sed -n '1,260p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
     209 /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html
     101 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md
     310 total
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
  <strong>Line numbers</strong> at <code>2ef2e62</code>. <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Revision 2, after review round 1.
</div>

<div class="danger">
  <strong>Emergency lever (corrected order).</strong> Only after Phase B's read-side code is live, never before, and only with Christie's explicit go-ahead: run Phases C and D back-to-back instead of days apart. Deleting Spring from <code>lessonData</code> before the app can read <code>lessons_spring-2026</code> would make Spring look empty, which is the May 2026 incident on purpose. Phase B adds a headroom readout, so nobody has to remember to paste a snippet.
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

<h2 id="design">Design</h2>
<ul>
  <li><strong>One constant, <code>OWN_DOC_SEMESTERS = ['spring-2026']</code></strong>, in <code>firebase-data.js</code>. It's changed only by a code deploy, just as the rules fence is changed only by a rules deploy. No appData flag and no <code>get()</code> in rules.</li>
  <li><strong>Where Spring lives:</strong> <code>curriculum/lessons_spring-2026</code> = <code>{ &lt;lessonKey&gt;: lesson, lastUpdated, lastUpdatedBy }</code>. <code>lessonStoreFor</code> returns <code>'ownDoc'</code> for keys in the constant. Every weekly site listed above goes through two helpers: <code>weeklyLessonRef(semKey)</code> and <code>weeklyLessonPath(semKey, lessonKey, field?)</code>. The paths are rooted at <code>lessonKey</code> for <code>'ownDoc'</code> and at <code>semKey.lessonKey</code> for legacy.</li>
  <li><strong>Transitional read rule (so Phase B can ship before the copy):</strong> for an <code>'ownDoc'</code> semester, <em>if <code>lessons_K</code> exists</em>, read it. Otherwise read <code>lessonData[K]</code> as today. So the code can deploy before the copy, and Spring keeps working at every step.</li>
  <li><strong>Writes to Spring</strong> go to <code>lessons_K</code>. If it doesn't exist yet (before Phase C), <code>update()</code> would throw <code>not-found</code>, and the rules fence (Phase A) already refuses Spring writes to <code>lessonData</code>. <strong>So from Phase A until Phase C, Spring is read-only</strong> and saves show "Spring 2026 is being moved to new storage — editing is paused." Spring is finished, so Christie confirms this is acceptable (Decisions Log). After Phase C, writes work normally.</li>
</ul>

<h2 id="phases">Phases</h2>

<div class="phase" id="phase-a">
<h3>Phase A: rules fence for <code>spring-2026</code> in <code>lessonData</code> <span class="status-tag not-ready">execution-ready: false</span></h3>
<p><strong>Acceptance:</strong> nobody, managers included, can change the <code>spring-2026</code> key of <code>curriculum/lessonData</code>, except a manager update that <em>only deletes</em> that key (Phase D). Everything else about <code>/curriculum</code> behaves exactly as today for every role. It deploys through <code>deploy-rules.sh --approved &lt;sha&gt;</code> after Christie says the phrase. It ships first because it's small, breaks nothing (Spring is dormant), and stops Spring's copy changing while the rest lands.</p>
<p><strong>Shape:</strong> split <code>:654</code> into <code>allow read</code>, <code>allow create</code>, <code>allow update</code> and <code>allow delete</code> for manager+. Both update allowances (manager's, and the classbook roles' at <code>:666</code>) add, for <code>docId == 'lessonData'</code>: <code>!request.resource.data.diff(resource.data).affectedKeys().hasAny(['spring-2026'])</code>, OR (manager only) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; !('spring-2026' in request.resource.data)</code>, which means deleting it and nothing else. <code>diff().affectedKeys()</code> reports top-level keys, so a dotted write to <code>spring-2026.x.qaThread</code> and a stale tab re-creating the key after Phase D both surface as <code>spring-2026</code>.</p>
<div class="bdd">Rules tests (studio-hub/rules.test.js), new lessonData fixture incl. a NEAR-1 MB one (~950 KB, two semesters):
  teacher / classbook-admin / manager: update fall-2026.x.field            → allowed (as today)
  teacher / classbook-admin / manager: update spring-2026.x.field          → denied
  manager: update { spring-2026: delete } only                              → allowed
  manager: update { spring-2026: delete, fall-2026.x: … }                   → denied
  classbook-admin: update { spring-2026: delete }                           → denied
  any role: re-create spring-2026 after it was deleted                      → denied
  manager/classbook roles: every other /curriculum doc (appData, prepData, cutProjects, changeLog, lessons_spring-2026, …) → exactly as today
  the near-1 MB fixture: the allowed and denied cases above evaluate correctly (proves affectedKeys on a full-size doc)
  whole existing studio-hub suite passes</div>
<div class="note">The Classbook side, before Phase B: a Spring edit fails with the app's normal save-error alert. Spring is dormant, so this should be rare. Studio Hub's alerts only read.</div>
</div>

<div class="phase" id="phase-b">
<h3>Phase B: the Classbook reads and writes Spring from its own document (no data moves yet) <span class="status-tag not-ready">execution-ready: false</span></h3>
<p><strong>Acceptance:</strong>
<ul>
  <li>With <code>lessons_spring-2026</code> absent (the production state after this deploy), the app behaves as today, except Spring edits show "editing is paused" (see Design).</li>
  <li>In the emulator, with it present, Spring works end to end from it. Fall and every other semester are untouched.</li>
  <li>A <strong>headroom readout</strong> appears in Curriculum Admin → Diagnostics (managers): "Lesson storage: N KB of 1,024 KB", with a warning above 90%.</li>
  <li>Studio Hub alerts include <code>lessons_spring-2026</code>.</li>
  <li>This is one Classbook deploy (one Netlify credit) plus one Studio Hub deploy.</li>
</ul></p>
<p><strong>Shape (each fixes a round-1 finding):</strong></p>
<ul>
  <li><strong>(A) The listener must not drop Spring.</strong> The carry-across at <code>:1184-1187</code> keeps own-doc semesters too: <code>snapshotCampSeasons</code> becomes <code>snapshotNonLegacySemesters</code> and includes keys in <code>OWN_DOC_SEMESTERS</code> whenever <code>lessons_K</code> is the source. A separate <code>lessons_K</code> listener updates <code>currentLessonData[K]</code> only. It does <strong>not</strong> bump <code>globalListenerGeneration</code> and never touches <code>lessonDataLoadedSuccessfully</code>. Its own error goes to a visible banner ("Spring 2026 lessons couldn't be loaded — reload") and marks Spring unwritable. Test: a Fall save's legacy snapshot leaves Spring's lessons on screen.</li>
  <li><strong>(D) A vanished key is loud, not blank.</strong> If a legacy snapshot lacks a key the tab is rendering from <code>lessonData</code> (a pre-Phase-C tab after Phase D), the app shows "This semester moved to new storage — reload the page" instead of an empty grid.</li>
  <li><strong>Teardown:</strong> <code>setupLessonDataListener</code> keeps an array of unsubscribes and tears them all down, which fixes the double registration from <code>app.js:676</code>/<code>:5038</code> for the new listener.</li>
  <li><strong>(E) First write to a missing doc:</strong> the own-doc write helpers catch <code>not-found</code>. Before Phase C, they refuse with "editing is paused". After Phase C, the doc exists, so this can't happen for Spring.</li>
  <li><strong>Readers:</strong> <code>readServerSemesterLessonMap</code>, <code>readAdminLessonDoc</code> and <code>computeLiveContentCountByTeacher</code> route through the helpers. The live count sums <code>lessonData</code> plus <code>lessons_spring-2026</code>, so the content-loss comparison stays whole.</li>
  <li><strong>Ratchet:</strong> no <code>doc('lessonData')</code> in the app's loaded scripts outside <code>weeklyLessonRef</code>, the legacy load/listener, and the dead backup helpers (left alone). <code>e2e/</code> is exempt.</li>
  <li><strong>Studio Hub alerts:</strong> add a second listener on <code>curriculum/lessons_spring-2026</code>, iterating its lessons the same way. A missing doc is fine.</li>
  <li><strong>Seed:</strong> a <code>lessons_spring-2026</code> fixture for the emulator scenarios. The default seed keeps Spring in <code>lessonData</code>, so the existing suites are unchanged.</li>
</ul>
<div class="bdd">Scenario: production state after deploy (lessons_spring-2026 absent) — regression
  Then every existing e2e test passes; Fall saves go to lessonData as today; Spring reads from lessonData
   and a Spring edit shows "editing is paused" (the rules fence refuses it)

Scenario: Spring in its own doc works end to end (emulator)
  Given lessons_spring-2026 exists and lessonData has no spring-2026
  When a teacher views/saves a Spring lesson, sends Q&A; an admin replies, edits, moves/swaps
  Then every write lands in lessons_spring-2026 at lessonKey.field paths; lessonData is untouched

Scenario: a Fall save doesn't blank Spring (round-1 finding A)
  Given Spring served from its own doc
  When a Fall lesson is saved (legacy snapshot fires)
  Then Spring's lessons are still on screen and currentLessonData['spring-2026'] is unchanged

Scenario: own-doc listener error is loud and isolated
  Given reading lessons_spring-2026 fails
  Then a banner says so, Spring is unwritable, and Fall keeps working (lessonDataLoadedSuccessfully unaffected)

Scenario: headroom readout
  Then Diagnostics shows lessonData size of 1,024 KB, warning above 90%

Scenario: content counts stay whole
  Then computeLiveContentCountByTeacher counts Spring from its own doc</div>
</div>

<div class="phase" id="phase-c">
<h3>Phase C: copy Spring into its own document (production, one-off, manager) <span class="status-tag not-ready">execution-ready: false</span></h3>
<p><strong>Acceptance:</strong> <code>curriculum/lessons_spring-2026</code> holds exactly what <code>lessonData['spring-2026']</code> holds, the app now serves Spring from it (per the transitional read rule), and Spring is editable again. The old copy stays, frozen by the Phase A fence. It needs Christie's go-ahead, and she runs it at a quiet time.</p>
<p><strong>How:</strong> a console procedure that Christie pastes while signed in as manager, written into this plan before execution and reviewed:</p>
<ol>
  <li>A forced-server read of <code>lessonData</code>, then download of <code>classbook-spring-2026-lessons-&lt;ISO&gt;.json</code>. It refuses if the read fails.</li>
  <li>One transaction: read <code>lessonData</code> and <code>lessons_spring-2026</code> (which must not exist), then <code>tx.set(lessons_spring-2026, { ...lessonData['spring-2026'], lastUpdated, lastUpdatedBy })</code>, using the map read <em>inside</em> the transaction. It also writes a small record <code>curriculum/storageMigrations</code> → <code>{ 'spring-2026': { copiedAt, copiedBy, lessonCount, sha256 } }</code>, the SHA-256 of a canonical (sorted-key) JSON of the copied map.</li>
  <li>Verify from a forced-server read: every lesson key present, and the hash of <code>lessons_spring-2026</code> minus its <code>lastUpdated*</code> fields equals the recorded hash. Because the Phase A fence means <strong>nothing can change the source</strong>, a deep-equal is valid, which answers round-1 finding B. A mismatch is loud. To undo, a manager deletes the new doc (whole-doc delete; see Q3) and the app falls back to <code>lessonData</code>, which is intact.</li>
</ol>
<div class="bdd">Scenario: copy (emulator, same procedure as a test)
  Then lessons_spring-2026 deep-equals lessonData['spring-2026'] (+ lastUpdated*), storageMigrations records count + hash, the app serves Spring from the new doc and edits work
Scenario: target already exists → refuses, nothing written
Scenario: after the copy, a stale pre-Phase-B tab edits Spring → the Phase A fence refuses it (loud save error)</div>
</div>

<div class="phase" id="phase-d">
<h3>Phase D: remove Spring's old copy and free the space (production, one-off, manager) <span class="status-tag not-ready">execution-ready: false</span></h3>
<p><strong>Acceptance:</strong> <code>lessonData['spring-2026']</code> is gone, and <code>lessonData</code> drops to about 420 KB (41%). Spring works from its own doc. It needs Christie's separate go-ahead after Phase C has run for a few days, or immediately under the emergency lever.</p>
<p><strong>How (console procedure):</strong> a forced-server read of <code>lessonData</code>. It refuses unless the SHA-256 of <code>lessonData['spring-2026']</code> equals the Phase C recorded hash. The fence kept it frozen, so it must equal what the transaction <em>wrote</em>, not the pre-transaction download (round-1 finding C). Then it downloads that copy again as JSON and runs one manager <code>update({ 'spring-2026': FieldValue.delete() })</code>, the one write the fence allows. <strong>This is the plan's only deletion, and it removes a verified, frozen duplicate.</strong></p>
<div class="bdd">Scenario: remove (emulator)
  Then lessonData has no spring-2026, lessons_spring-2026 unchanged, Spring fully visible, Fall unaffected
Scenario: hash mismatch → refuses, nothing deleted
Scenario: an open tab whose Spring came from lessonData (loaded before Phase C) → shows "moved — reload", not an empty grid</div>
<div class="note"><strong>Christie's edit to <code>tinker-backups/backup.js</code></strong> must land <em>before</em> Phase D. An agent may not touch that file. After Phase D, <code>computeClassbookContentByTeacher</code> (<code>:370-389</code>) would stop seeing Spring and trip the 10% content-loss alarm for every Spring teacher. The change is to also tally lessons from <code>collections.curriculum['lessons_spring-2026']</code>, and the exact lines will be written out for her in this plan before Phase D.</div>
</div>

<h2 id="followup">Follow-up plan (required before the next semester is created)</h2>
<div class="note">After Phase D, <code>lessonData</code> holds Fall (420 KB and growing). <strong>Before Spring 2027 is created</strong> (or before <code>lessonData</code> passes about 70%, whichever comes first), a follow-up plan must: move Fall the same way at the end of its term; make <code>createNewSemester</code> create new semesters in their own document, setting config <em>before</em> <code>saveLessonData</code> (round-1 finding F, <code>app.js:4965</code> vs <code>:4980</code>) and handling <code>not-found</code> on the first write (finding E); make <code>deleteSemester</code>/Archive handle own-doc semesters (finding "deleteSemester breaks"); and generalise the constant. The make-active-semester plan resumes after that.</div>

<h2 id="safety">Firebase safety checklist</h2>
<div class="safe"><ul>
  <li><strong>Rules:</strong> Phase A is a shared-rules change: rules tests including a near-1 MB fixture, the whole suite green, then <code>deploy-rules.sh --approved &lt;sha&gt;</code> after the phrase. New <code>lessons_*</code> and <code>storageMigrations</code> docs are covered by <code>curriculum/{docId}</code>, so no new rule is needed. The executor re-checks <code>storageMigrations</code> is writable by manager and readable by classbook roles.</li>
  <li><strong>Snapshots:</strong> JSON downloads before Phase C and before Phase D, plus <code>tinker-backups/backup.js</code>'s automated backup of the <code>curriculum</code> collection (Tier 1).</li>
  <li><strong>Atomic:</strong> the copy is one transaction. The removal is one update that the rules restrict to deleting exactly that key.</li>
  <li><strong>Verified:</strong> a hash recorded at copy time is checked after the copy and before the removal, all from forced-server reads.</li>
  <li><strong>Reversible:</strong> until Phase D, the original is untouched. After Phase D, the downloads and backups can restore it.</li>
  <li><strong>Partial updates:</strong> per-field dotted paths as today. <code>saveLessonData</code> is a whole-semester merge-set today and becomes a whole-document merge-set for an own-doc semester; it's reached from <code>createLessonSlotsForRoster</code> on Settings save, and it keeps <code>merge: true</code>. (The round-1 correction to "no whole-lesson <code>set()</code>".)</li>
  <li><strong>Spot checks:</strong> one Spring lesson in the Firebase Console after Phase C and after Phase D.</li>
</ul></div>

<h2 id="completeness">If interrupted</h2>
<ul>
  <li><strong>After A:</strong> Spring is read-only, and nothing else changes.</li>
  <li><strong>After B:</strong> same as A for users, plus the readout.</li>
  <li><strong>Mid-C:</strong> the transaction either committed or didn't. If it committed but verify fails, the original is intact, and deleting the new doc restores the old behaviour.</li>
  <li><strong>Between C and D:</strong> two copies exist. The app serves the new one, and the fence freezes the old one. No space is freed yet.</li>
</ul>

<h2 id="resume">Resume instructions</h2>
<ol>
  <li>Read this plan and its Decisions Log. Re-measure lessonData first (Phase B's readout, or the Sep 29 snippet).</li>
  <li>A worktree off <code>origin/main</code>, with line numbers re-checked. Phase A work is in <code>studio-hub</code> (committed to main there, then the guard).</li>
  <li>Phase by phase: commit, run the full suite, then a second-model implementation review. Each deploy and each production step (C, D) needs Christie's own yes. Phase A needs the sha phrase.</li>
</ol>

<h2 id="decisions">Decisions Log (append-only)</h2>
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
I read the plan in full and verified its claims against the code. Here's what holds and what doesn't.

## Verdict: **NOT execution-ready**

The research is unusually careful — every `lessonStoreFor` citation is exact (`firebase-data.js:64-72`; callers `:811, :1387, :1479`, `app.js:3636, 5848, 7155, 7240`), and the 13 `doc('lessonData')` sites in the reader/writer table match the grep exactly. But there are four defects that lose or hide lesson data, one internal contradiction that blocks the only phase that frees space, and a materially wrong safety citation.

---

## 1. Data safety of Phases 3–4

**A. The listener will blank Spring in every open tab, every few minutes.** `firebase-data.js:1186` does `currentLessonData = doc.data()` — it *replaces* the whole model with the legacy document's contents. The only maps carried across are camp seasons, via `snapshotCampSeasons()` at `:1094-1100`, which filters on `isCampSeason(k) || isDayOffYear(k)`. A migrated **weekly** semester matches neither predicate, so it is dropped on every legacy snapshot.

Failing input: Spring migrated, Fall still legacy. A Fall teacher saves a lesson → legacy snapshot fires → `currentLessonData['spring-2026']` becomes `undefined` in every tab until the `lessons_spring-2026` listener happens to re-fire (it won't; nothing changed there). Spring renders empty. This is the May 2026 incident reproduced on a schedule. The plan's "the live listener follows the same split" doesn't cover it.

**B. Phase 3's verification produces false mismatches that discard real edits.** Step 3 requires `lessons_K` to deep-equal the transaction's source map. But the moment the transaction commits, the fence is live and *all* legitimate saves go to `lessons_K`. Manager clicks Move at 4:00:00; a teacher's save lands in `lessons_K` at 4:00:01; verify reads at 4:00:02 → not equal → loud alert → manager clicks "Move back" → the app reads `lessonData[K]` again and that 4:00:01 edit is orphaned in a document nothing reads. The verify needs to be "every source key present and equal-or-newer by `lastEditedAt`", not deep-equal.

**C. Phase 4's precondition contradicts Phase 3 and will refuse forever.** Phase 4 refuses unless `lessonData[K]` deep-equals *the Phase 3 snapshot*. Phase 3's own BDD says: "a lesson is saved between the snapshot and the transaction → the transaction copies the newer data; the snapshot is older." So one autosave in that window makes the two permanently unequal, and the only phase that actually frees space can never run. Phase 4 must compare against **what the transaction wrote**, persisted at move time — not the pre-transaction download.

**D. Phase 4 silently empties Spring for every tab open at the time.** `setupConfigListener()` is **never called** (`app.js:11328` says so explicitly, and the grep confirms zero callers). So an open tab's `currentConfig` is frozen at load. Post-move it keeps `lessonStoreFor(K) === 'weekly'`, keeps reading `lessonData[K]`, and has no `lessons_K` listener. That's fine for writes (the fence catches them — this is the design working), but on Phase 4's delete the legacy snapshot arrives with `K` gone → Spring goes blank with no error. The plan's claim that teachers see nothing beyond "one reload error on save" is wrong for Phase 4, and understated for Phase 3 (reads silently stop tracking other people's edits from the instant of the move).

**E. A new-style semester's first save throws `not-found`.** `update()` on a non-existent document fails. `saveSingleLesson` (`:1438`), `saveMultipleLessonFields` (`:1500`), `deleteLessonKey` (`:830`) have no `not-found` fallback, unlike `savePrepWeekData` (`:562-572`) and `updateAppData` (`:233-238`). Today this is unreachable because `lessonData` always exists. Failing input: admin creates "Spring 2027" *without* Copy-from (writes no slots), a teacher types a plan → `lessons_spring-2027.update(...)` → `FirebaseError: NOT_FOUND` → "Error saving lesson".

**F. `createNewSemester` writes the copied slots to the wrong document.** `saveLessonData(key, emptyLessons)` runs at `app.js:4965`; `currentConfig.semesters[key] = newSem` (carrying `lessonStore:'doc'`) is not assigned until `:4980`. `semesterTypeOf`/`lessonStoreFor` read `currentConfig.semesters[semKey]`, so at write time the new key is still `'weekly'` → the slots land in `curriculum/lessonData`, the new semester reads an empty `lessons_key` and shows zero lessons, and the shared document you're shrinking gains dead weight. The compensating `deleteLessonData(key)` at `:4994` has the same problem in reverse.

---

## 2. Reader/writer completeness — **no**

The 13 in-app `doc('lessonData')` sites are complete and correct. Everything else in the app (prep dashboard, diagnostics, material forecasts, change history) reads `currentLessonData` in memory, which is why finding A is the load-bearing risk. Missing from the plan:

| Missing | Where | Why it matters |
|---|---|---|
| `computeClassbookContentByTeacher` | `tinker-backups/backup.js:370-389`, → `backupStatus/latest` at `:471` | The automated per-teacher content-loss detector reads **only** `curriculum/lessonData` (`:382`). After Phase 4 it goes permanently blind to Spring, and on the first run after the delete every teacher trips the 10% drop alarm. `curriculum` is also Tier-1 (`:38`). Per your `backup-js-uses-cli-token` memory an agent must not touch this file — so it's your edit, and the plan has to say so. |
| `renderContentCount()` | `app.js:7578-7600` | Same blindness in-app: `computeLiveContentCountByTeacher` (`:7518`) vs `backupStatus/latest.classbookContentByTeacher` (`:7588`). Both sides go blind; there's a window where live has dropped and the baseline hasn't. |
| `studio-hub/test-alerts.js:98, 143` | Admin SDK writer of `curriculum/lessonData` (the `qaData` key in the plan's doc shape) | Bypasses rules entirely, so "enforced on the server for every role" isn't literally true. |
| `backupLessonData` / `restoreFromBackup` | `firebase-data.js:979-1002` | No callers anywhere (dead), but in the ratchet's path. Also: `lessonData_backup` shares the same 1 MiB cap — Spring (551 KB) + Fall (420 KB) would fill it too. |
| e2e direct writers | `data-safety.spec.js:3079, 3203, 4434, 4546`; `day-off-teacher.spec.js:530`; `day-off-camps.spec.js:58, 706` | The Phase-1 ratchet ("no `doc('lessonData')` outside the helper") must exempt `e2e/`, or the suite won't build. |
| `e2e/fixtures/seed/curriculum.json` | 5,269 bytes | Needs a `lessons_K` fixture for Phase 1's BDD. |

**Wrong citation with safety consequences:** the plan says "The nightly backup copies the whole `curriculum` collection", citing `summer-camp-app/scripts/backup-firestore.js:39`. That file's own header (lines 9–16) says: paste into a browser console on localhost, *"RECOMMENDED: Run once a week."* It is neither nightly nor automated. The conclusion is still true — `tinker-backups/backup.js` does back up `curriculum` (`:38`, `:56`) — but Phase 4's "Reversible: the snapshot plus the nightly backup" is resting on the wrong artifact.

**Also missed — `deleteSemester` breaks for migrated semesters.** `app.js:4585` calls `deleteLessonData(key)` = `update({K: delete})` on `lessonData`. Under Phase 2's stated exception ("a **manager** update that only deletes exactly that key"), a `classbook-admin` deleting a migrated semester is denied — a capability they have today (`firestore.rules:675-678`). And `curriculum/lessons_K` is left orphaned either way.

---

## 3. Phase 2 rules design

**The mechanism is sound.** `request.resource.data` on an `update` is the post-write merged document, `diff().affectedKeys()` reports added/removed/changed **top-level** keys, so a dotted write to `spring-2026.x.qaThread` surfaces as `spring-2026`, and a stale tab re-*creating* the key after Phase 4 also surfaces as `spring-2026`. That part works.

**Three problems:**

- **"Narrowing the manager catch-all" is not a narrowing.** `firestore.rules:654` is `allow read, write: if isManagerOrAbove();` and `:666` is a separate `allow create, update`. Rules OR across statements, so you cannot add a condition — you have to split `:654` into separate `read` / `create` / `update` / `delete` statements. The blast radius is contained (only the Classbook and Studio Hub's read-only alerts touch `/curriculum`), but it's a bigger edit than the plan implies, in the file that governs every staff app.

- **Drop the `get(appData)`.** It costs `exists()` + `get()` = two extra billed document reads and a round trip on *every* teacher lesson save; `get()` on a missing doc returns null and `.data` on null denies, so the "behaves as an empty list" BDD needs explicit `exists()` guarding; and — worst — it makes the fence depend on a document managers can write, so "Move back" or a stray appData edit silently disarms it. There are exactly two semesters to migrate. Put the literal in the rule: `!...affectedKeys().hasAny(['spring-2026'])`. One extra rules deploy for Fall, which Phase 5 already plans for. The fence then can only be changed through the guard + sha phrase, which matches your posture everywhere else.

- **Rules test coverage is zero and the fixtures prove nothing about the real document.** `studio-hub/rules.test.js` has no `curriculum/lessonData` fixture at all — it uses `curriculum/spring-2026` seeded as `{ title: 'Spring Curriculum' }` (`:264`), and the Classbook seed is 5.2 KB. Every Phase 2 test would be new, and a green suite says nothing about `diff()`/`affectedKeys()` materializing a 972 KB document on every save. That has to be proven against a near-cap fixture in the emulator before deploy, not assumed.

---

## 4. Loading and listeners

Beyond finding A:

- **`setupLessonDataListener` is called twice** — `app.js:676` (Today View) and `app.js:5038` (Curriculum Admin). Teardown is a single `lessonDataUnsubscribe` (`firebase-data.js:1116`). Per-semester listeners need an array and an all-unsubscribe, or the Today View's callback keeps firing alongside the Admin one.
- **The generation counter is a trap.** `globalListenerGeneration` (`:303`) is bumped by every legacy snapshot (`:1181`) and gates the summer reload; a superseded reload returns `'stale'` and never sets `lessonDataLoadedSuccessfully = true` (`:1131, :1143-1145`). On first load you'd subscribe legacy + Spring + Fall and get three near-simultaneous first snapshots. If the per-semester listeners bump the generation, the legacy listener's in-flight summer reload goes stale → the flag never flips → the red banner stays up and **every writer in the app refuses**. If they don't bump it, a per-semester permission error is silent. The plan doesn't decide this, and it's the most likely way to ship an app-wide outage.
- **Cost is a genuine win.** Today one listener re-sends ~972 KB on every change anywhere; after the split, a Fall save re-sends 420 KB and Spring's tab-load cost drops. `readAdminLessonDoc` (`app.js:5835`) does a forced-server full-document read per existence check — that gets cheaper too, once both semesters are out.

---

## 5. Ordering, and a faster path

**The ordering is right but the relief is last, and there's no headroom instrumentation.** Nothing is freed until Phase 4, which sits behind: a large Phase 1 refactor + one Netlify deploy + one Studio Hub deploy → a shared rules change + sha approval + deploy → new manager UI with a transaction → a production run → "a few days" → Phase 4. Realistically one to three weeks against 52 KB of headroom, while Fall is actively being written into the same document. Meanwhile the only headroom monitor is "run a console snippet every few days" — a human polling loop.

**The emergency lever as written is the May 2026 incident, on purpose.** "Spring would show as empty in the app until Phase 1's code is live" — on the studio's largest semester, with no code that can read the new location, at the exact moment everyone is already stressed. It should never be pulled in that order.

What I'd recommend instead, and it's mostly a scoping change rather than a redesign:

1. **Narrow the first pass to Spring, hard-coded.** Spring 2026 ran Jan–May; it is finished and nobody edits it. Drop `migratedSemesters`, the `lessonStore` config flag, the appData `get()` in rules, "Move back", and both manager buttons. Phase 3 becomes a one-off snapshot + copy + verify (the same manual, console-driven shape you already use for migrations), not a new transaction-plus-two-buttons UI surface that is itself new code capable of losing data. Generalize for Fall in Phase 5, where the second semester justifies the abstraction.
2. **Ship the rules fence for `spring-2026` first, before any code.** It's ~6 lines plus tests, one sha approval, and it breaks nothing — Spring is dormant. It also stops Spring growing while the rest lands.
3. **Add a headroom readout to the admin Diagnostics panel in Phase 1** (client-side, read-only), so 52 KB isn't tracked by a human remembering to paste a snippet.
4. **Fix the emergency lever's order**: read-side code first, *then* copy, *then* delete. Never delete before the app can read the new location.

---

## Minimum list to reach execution-ready

1. Listener: migrated weekly semesters must survive `currentLessonData = doc.data()` (`firebase-data.js:1186`) — extend or replace `snapshotCampSeasons()` (`:1094-1100`), and decide explicitly whether per-semester listeners bump `globalListenerGeneration` and whether they may touch `lessonDataLoadedSuccessfully`.
2. Per-semester listener teardown: array + unsubscribe-all, for the two `setupLessonDataListener` call sites (`app.js:676`, `:5038`).
3. Phase 3 verification: equal-or-newer by `lastEditedAt`, not deep-equal, and persist the transaction's source map (or hash) as the record.
4. Phase 4 precondition: compare against what the transaction wrote, not the pre-transaction snapshot. As written it can never run.
5. Phase 4 read-side: an open tab must not silently blank. Either poll/verify `appData` before trusting a missing key, or make the legacy listener treat "a semester I was rendering just vanished" as a loud reload prompt.
6. `not-found` fallback on the first write to a non-existent `lessons_K` (`saveSingleLesson`, `saveMultipleLessonFields`, `deleteLessonKey`), matching `savePrepWeekData:562-572`.
7. `createNewSemester`: set the new semester's config *before* `saveLessonData` (`app.js:4965` vs `:4980`), and route `deleteLessonData` / `readServerSemesterLessonMap` by store.
8. `deleteSemester` for a migrated semester: delete the `lessons_K` document, keep `classbook-admin` able to do it, and clean up the migration record.
9. Rules: replace the `get(appData)` design with a literal semester key; state that `:654` must be split into per-operation statements; add the Phase 2 cases to `studio-hub/rules.test.js` (which has no `lessonData` fixture today) **including one near-1 MB fixture**.
10. Add the missing readers/writers to the plan and say who fixes `tinker-backups/backup.js:370-389` — and correct the backup citation and the word "nightly".
11. Re-scope to one hard-coded semester for the first pass; add a headroom readout; fix the emergency lever's ordering.

Two smaller ones worth folding in: the ratchet must exempt `e2e/`, and the safety checklist's "No whole-lesson `set()`" is inaccurate — `saveLessonData` (`:817`) is a whole-*semester* merge-set and becomes a whole-*document* merge-set, reached from `createLessonSlotsForRoster` on every Settings save.

I haven't changed any files. Want me to write this up as a review artifact you can link alongside the plan?

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html | sed -n '1,240p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
     1	<!DOCTYPE html>
     2	<html lang="en">
     3	<head>
     4	<meta charset="UTF-8">
     5	<title>Plan: Classbook — move Spring 2026's lessons into their own document (lessonData is at 95% of Firestore's 1 MB cap)</title>
     6	<style>
     7	  body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; max-width: 860px; margin: 2rem auto; padding: 0 1.5rem; color: #1a1a1a; line-height: 1.5; }
     8	  h1 { font-size: 1.6rem; border-bottom: 2px solid #8B30BC; padding-bottom: .5rem; }
     9	  h2 { font-size: 1.15rem; margin-top: 2rem; color: #6052C8; }
    10	  h3 { font-size: 1rem; margin-top: 1.2rem; }
    11	  .meta { background: #f5f0ff; border-left: 4px solid #8B30BC; padding: .75rem 1rem; border-radius: 4px; margin: 1rem 0; font-size: .9rem; }
    12	  .phase { border: 1px solid #e5e7eb; border-radius: 6px; padding: 1rem 1.25rem; margin: 1rem 0; }
    13	  .phase h3 { margin-top: 0; }
    14	  .bdd { background: #fafafa; border: 1px solid #e5e7eb; border-radius: 4px; padding: .5rem .75rem; margin: .5rem 0; font-size: .88rem; font-family: monospace; white-space: pre-wrap; }
    15	  .safe { background: #f0fdf4; border-left: 4px solid #16a34a; padding: .6rem 1rem; border-radius: 4px; font-size: .9rem; margin: .5rem 0; }
    16	  .note { background: #fffbeb; border-left: 4px solid #f59e0b; padding: .6rem 1rem; border-radius: 4px; font-size: .9rem; margin: .5rem 0; }
    17	  .danger { background: #fef2f2; border-left: 4px solid #dc2626; padding: .6rem 1rem; border-radius: 4px; font-size: .9rem; margin: .5rem 0; }
    18	  .decision { background: #eff6ff; border-left: 4px solid #2563eb; padding: .6rem 1rem; border-radius: 4px; font-size: .9rem; margin: .5rem 0; }
    19	  code { background: #f3f4f6; padding: .1rem .35rem; border-radius: 3px; font-size: .88rem; }
    20	  table { border-collapse: collapse; width: 100%; margin: .75rem 0; }
    21	  th, td { border: 1px solid #e5e7eb; padding: .4rem .75rem; font-size: .88rem; text-align: left; vertical-align: top; }
    22	  th { background: #f9fafb; }
    23	  .status-tag { display: inline-block; font-size: .75rem; font-weight: 700; padding: .15rem .5rem; border-radius: 999px; }
    24	  .not-ready { background: #fef3c7; color: #92400e; }
    25	  .ready { background: #dcfce7; color: #166534; }
    26	</style>
    27	</head>
    28	<body>
    29	
    30	<h1 id="plan-title">Plan: Classbook — move Spring 2026's lessons into their own document</h1>
    31	
    32	<div class="meta" id="plan-meta">
    33	  <strong>Goal:</strong> Teachers never hit a wall where lesson saves stop working. Spring 2026, a finished semester, moves out of the almost-full shared document into its own, with no lesson lost or changed, and Spring stays viewable exactly as today.<br>
    34	  <strong>Why now:</strong> On Sep 29, 2026 Christie measured <code>curriculum/lessonData</code> at <strong>972 KB of 1,024 KB (95%)</strong> from a forced server read: <code>spring-2026</code> 551 KB, <code>fall-2026</code> 420 KB. It's real content spread over hundreds of lessons (the largest field is 2.5 KB), so there's nothing to trim. At the cap, <strong>every weekly lesson save fails for everyone</strong>. Fall is being written into it right now.<br>
    35	  <strong>Scope (revision 2):</strong> <strong>Spring 2026 only, with its key written literally into the code and the rules.</strong> Spring ran Jan–May and is dormant, so the move needs no new UI and no config flags. Moving Fall, making every new semester get its own document, and the <code>createNewSemester</code>/<code>deleteSemester</code> changes that requires are a <strong>follow-up plan</strong>. That plan must land before the next semester is created (see "Follow-up").<br>
    36	  <strong>Touches:</strong> the Classbook (<code>js/firebase-data.js</code>, <code>js/app.js</code>), <code>studio-hub/firestore.rules</code> + <code>studio-hub/rules.test.js</code> (sha phrase + guard), <code>studio-hub/js/alerts.js</code> (Studio Hub deploy), and <code>tinker-backups/backup.js</code>, <strong>which only Christie edits</strong> (memory: <code>backup-js-uses-cli-token</code>).<br>
    37	  <strong>Line numbers</strong> at <code>2ef2e62</code>. <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Revision 2, after review round 1.
    38	</div>
    39	
    40	<div class="danger">
    41	  <strong>Emergency lever (corrected order).</strong> Only after Phase B's read-side code is live, never before, and only with Christie's explicit go-ahead: run Phases C and D back-to-back instead of days apart. Deleting Spring from <code>lessonData</code> before the app can read <code>lessons_spring-2026</code> would make Spring look empty, which is the May 2026 incident on purpose. Phase B adds a headroom readout, so nobody has to remember to paste a snippet.
    42	</div>
    43	
    44	<h2 id="today">What exists today (research, verified in review round 1)</h2>
    45	<table>
    46	  <tr><th>Fact</th><th>Where</th></tr>
    47	  <tr><td><code>curriculum/lessonData</code> = <code>{ &lt;semKey&gt;: { &lt;lessonKey&gt;: lesson }, lastUpdated, lastUpdatedBy, qaData? }</code>. Firestore caps a document at 1 MiB.</td><td>measured Sep 29</td></tr>
    48	  <tr><td>Storage is routed by <code>lessonStoreFor(semKey)</code> (<code>'camp'</code> / <code>'weekly'</code>; throws otherwise). Callers: <code>firebase-data.js:811, 1387, 1479</code>; <code>app.js:3636, 5848, 7155, 7240</code>.</td><td><code>firebase-data.js:55-72</code></td></tr>
    49	  <tr><td>The 13 in-app <code>doc('lessonData')</code> sites. Reads: <code>:762</code> load, <code>:975</code> <code>readServerSemesterLessonMap</code>, <code>:1171</code> listener, <code>app.js:5835</code> <code>readAdminLessonDoc</code>, <code>app.js:7518</code> <code>computeLiveContentCountByTeacher</code>. Writes: <code>:817</code> <code>saveLessonData</code> (whole-semester merge-set), <code>:830</code> <code>deleteLessonKey</code>, <code>:963</code> <code>deleteLessonData</code>, <code>:1438</code> <code>saveSingleLesson</code>, <code>:1500</code> <code>saveMultipleLessonFields</code>, <code>app.js:3690</code> <code>sendTeacherQaMessage</code>, <code>:7202</code> <code>sendHelpResponse</code>, <code>:7285</code> <code>sendQaReply</code>. Dead code: <code>backupLessonData</code>/<code>restoreFromBackup</code> (<code>:979-1002</code>, no callers).</td><td>as cited</td></tr>
    50	  <tr><td><strong>The live listener replaces the whole model</strong>: <code>currentLessonData = doc.data()</code> (<code>:1186</code>), carrying across only camp/SDOC maps through <code>snapshotCampSeasons()</code> (<code>:1094-1100</code>). It bumps <code>globalListenerGeneration</code> (<code>:1181</code>), which gates the summer reload, and a superseded reload never sets <code>lessonDataLoadedSuccessfully</code> (<code>:1131, 1143-1145</code>). It's registered from two places (<code>app.js:676</code>, <code>:5038</code>) with one unsubscribe handle (<code>:1116</code>).</td><td>as cited</td></tr>
    51	  <tr><td><code>setupConfigListener()</code> is never called, so an open tab's <code>currentConfig</code> is frozen at load.</td><td><code>app.js:11328</code></td></tr>
    52	  <tr><td>Rules: <code>:654</code> is <code>allow read, write: if isManagerOrAbove()</code>, and <code>:666</code> is a separate create/update for classbook roles (not appData/prepCycleConfig). Rules OR across statements, so fencing a key for managers too means <strong>splitting <code>:654</code></strong> into per-operation statements. Whole-doc delete is limited to classbook-admin/curriculum-admin (<code>:675-678</code>). <code>studio-hub/rules.test.js</code> has no <code>curriculum/lessonData</code> fixture today.</td><td><code>studio-hub/firestore.rules:652-678</code></td></tr>
    53	  <tr><td>Outside the Classbook, readers of <code>curriculum/lessonData</code>:
    54	    <ul>
    55	      <li>Studio Hub's Q&amp;A alerts (<code>studio-hub/js/alerts.js:559-580</code>, iterating every top-level key).</li>
    56	      <li><strong><code>tinker-backups/backup.js</code></strong>: it backs up the <code>curriculum</code> collection as Tier 1 (<code>:38, :56</code>; new <code>lessons_*</code> docs are included automatically), and <code>computeClassbookContentByTeacher</code> (<code>:370-389</code>) counts per-teacher content from <code>curriculum/lessonData</code> only, writing <code>backupStatus/latest</code> (<code>:471</code>) with a 10% drop alarm. The Classbook's <code>renderContentCount()</code> (<code>app.js:7578-7600</code>) compares live counts to that baseline.</li>
    57	      <li><code>studio-hub/test-alerts.js:98, 143</code>: an Admin SDK test script that writes <code>lessonData.qaData</code>. It bypasses rules and isn't part of the app.</li>
    58	      <li>The <code>summer-camp-app/scripts/backup-firestore.js</code> console script is manual and weekly, not the nightly backup (a round-1 correction).</li>
    59	    </ul></td><td>as cited</td></tr>
    60	</table>
    61	
    62	<h2 id="design">Design</h2>
    63	<ul>
    64	  <li><strong>One constant, <code>OWN_DOC_SEMESTERS = ['spring-2026']</code></strong>, in <code>firebase-data.js</code>. It's changed only by a code deploy, just as the rules fence is changed only by a rules deploy. No appData flag and no <code>get()</code> in rules.</li>
    65	  <li><strong>Where Spring lives:</strong> <code>curriculum/lessons_spring-2026</code> = <code>{ &lt;lessonKey&gt;: lesson, lastUpdated, lastUpdatedBy }</code>. <code>lessonStoreFor</code> returns <code>'ownDoc'</code> for keys in the constant. Every weekly site listed above goes through two helpers: <code>weeklyLessonRef(semKey)</code> and <code>weeklyLessonPath(semKey, lessonKey, field?)</code>. The paths are rooted at <code>lessonKey</code> for <code>'ownDoc'</code> and at <code>semKey.lessonKey</code> for legacy.</li>
    66	  <li><strong>Transitional read rule (so Phase B can ship before the copy):</strong> for an <code>'ownDoc'</code> semester, <em>if <code>lessons_K</code> exists</em>, read it. Otherwise read <code>lessonData[K]</code> as today. So the code can deploy before the copy, and Spring keeps working at every step.</li>
    67	  <li><strong>Writes to Spring</strong> go to <code>lessons_K</code>. If it doesn't exist yet (before Phase C), <code>update()</code> would throw <code>not-found</code>, and the rules fence (Phase A) already refuses Spring writes to <code>lessonData</code>. <strong>So from Phase A until Phase C, Spring is read-only</strong> and saves show "Spring 2026 is being moved to new storage — editing is paused." Spring is finished, so Christie confirms this is acceptable (Decisions Log). After Phase C, writes work normally.</li>
    68	</ul>
    69	
    70	<h2 id="phases">Phases</h2>
    71	
    72	<div class="phase" id="phase-a">
    73	<h3>Phase A: rules fence for <code>spring-2026</code> in <code>lessonData</code> <span class="status-tag not-ready">execution-ready: false</span></h3>
    74	<p><strong>Acceptance:</strong> nobody, managers included, can change the <code>spring-2026</code> key of <code>curriculum/lessonData</code>, except a manager update that <em>only deletes</em> that key (Phase D). Everything else about <code>/curriculum</code> behaves exactly as today for every role. It deploys through <code>deploy-rules.sh --approved &lt;sha&gt;</code> after Christie says the phrase. It ships first because it's small, breaks nothing (Spring is dormant), and stops Spring's copy changing while the rest lands.</p>
    75	<p><strong>Shape:</strong> split <code>:654</code> into <code>allow read</code>, <code>allow create</code>, <code>allow update</code> and <code>allow delete</code> for manager+. Both update allowances (manager's, and the classbook roles' at <code>:666</code>) add, for <code>docId == 'lessonData'</code>: <code>!request.resource.data.diff(resource.data).affectedKeys().hasAny(['spring-2026'])</code>, OR (manager only) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; !('spring-2026' in request.resource.data)</code>, which means deleting it and nothing else. <code>diff().affectedKeys()</code> reports top-level keys, so a dotted write to <code>spring-2026.x.qaThread</code> and a stale tab re-creating the key after Phase D both surface as <code>spring-2026</code>.</p>
    76	<div class="bdd">Rules tests (studio-hub/rules.test.js), new lessonData fixture incl. a NEAR-1 MB one (~950 KB, two semesters):
    77	  teacher / classbook-admin / manager: update fall-2026.x.field            → allowed (as today)
    78	  teacher / classbook-admin / manager: update spring-2026.x.field          → denied
    79	  manager: update { spring-2026: delete } only                              → allowed
    80	  manager: update { spring-2026: delete, fall-2026.x: … }                   → denied
    81	  classbook-admin: update { spring-2026: delete }                           → denied
    82	  any role: re-create spring-2026 after it was deleted                      → denied
    83	  manager/classbook roles: every other /curriculum doc (appData, prepData, cutProjects, changeLog, lessons_spring-2026, …) → exactly as today
    84	  the near-1 MB fixture: the allowed and denied cases above evaluate correctly (proves affectedKeys on a full-size doc)
    85	  whole existing studio-hub suite passes</div>
    86	<div class="note">The Classbook side, before Phase B: a Spring edit fails with the app's normal save-error alert. Spring is dormant, so this should be rare. Studio Hub's alerts only read.</div>
    87	</div>
    88	
    89	<div class="phase" id="phase-b">
    90	<h3>Phase B: the Classbook reads and writes Spring from its own document (no data moves yet) <span class="status-tag not-ready">execution-ready: false</span></h3>
    91	<p><strong>Acceptance:</strong>
    92	<ul>
    93	  <li>With <code>lessons_spring-2026</code> absent (the production state after this deploy), the app behaves as today, except Spring edits show "editing is paused" (see Design).</li>
    94	  <li>In the emulator, with it present, Spring works end to end from it. Fall and every other semester are untouched.</li>
    95	  <li>A <strong>headroom readout</strong> appears in Curriculum Admin → Diagnostics (managers): "Lesson storage: N KB of 1,024 KB", with a warning above 90%.</li>
    96	  <li>Studio Hub alerts include <code>lessons_spring-2026</code>.</li>
    97	  <li>This is one Classbook deploy (one Netlify credit) plus one Studio Hub deploy.</li>
    98	</ul></p>
    99	<p><strong>Shape (each fixes a round-1 finding):</strong></p>
   100	<ul>
   101	  <li><strong>(A) The listener must not drop Spring.</strong> The carry-across at <code>:1184-1187</code> keeps own-doc semesters too: <code>snapshotCampSeasons</code> becomes <code>snapshotNonLegacySemesters</code> and includes keys in <code>OWN_DOC_SEMESTERS</code> whenever <code>lessons_K</code> is the source. A separate <code>lessons_K</code> listener updates <code>currentLessonData[K]</code> only. It does <strong>not</strong> bump <code>globalListenerGeneration</code> and never touches <code>lessonDataLoadedSuccessfully</code>. Its own error goes to a visible banner ("Spring 2026 lessons couldn't be loaded — reload") and marks Spring unwritable. Test: a Fall save's legacy snapshot leaves Spring's lessons on screen.</li>
   102	  <li><strong>(D) A vanished key is loud, not blank.</strong> If a legacy snapshot lacks a key the tab is rendering from <code>lessonData</code> (a pre-Phase-C tab after Phase D), the app shows "This semester moved to new storage — reload the page" instead of an empty grid.</li>
   103	  <li><strong>Teardown:</strong> <code>setupLessonDataListener</code> keeps an array of unsubscribes and tears them all down, which fixes the double registration from <code>app.js:676</code>/<code>:5038</code> for the new listener.</li>
   104	  <li><strong>(E) First write to a missing doc:</strong> the own-doc write helpers catch <code>not-found</code>. Before Phase C, they refuse with "editing is paused". After Phase C, the doc exists, so this can't happen for Spring.</li>
   105	  <li><strong>Readers:</strong> <code>readServerSemesterLessonMap</code>, <code>readAdminLessonDoc</code> and <code>computeLiveContentCountByTeacher</code> route through the helpers. The live count sums <code>lessonData</code> plus <code>lessons_spring-2026</code>, so the content-loss comparison stays whole.</li>
   106	  <li><strong>Ratchet:</strong> no <code>doc('lessonData')</code> in the app's loaded scripts outside <code>weeklyLessonRef</code>, the legacy load/listener, and the dead backup helpers (left alone). <code>e2e/</code> is exempt.</li>
   107	  <li><strong>Studio Hub alerts:</strong> add a second listener on <code>curriculum/lessons_spring-2026</code>, iterating its lessons the same way. A missing doc is fine.</li>
   108	  <li><strong>Seed:</strong> a <code>lessons_spring-2026</code> fixture for the emulator scenarios. The default seed keeps Spring in <code>lessonData</code>, so the existing suites are unchanged.</li>
   109	</ul>
   110	<div class="bdd">Scenario: production state after deploy (lessons_spring-2026 absent) — regression
   111	  Then every existing e2e test passes; Fall saves go to lessonData as today; Spring reads from lessonData
   112	   and a Spring edit shows "editing is paused" (the rules fence refuses it)
   113	
   114	Scenario: Spring in its own doc works end to end (emulator)
   115	  Given lessons_spring-2026 exists and lessonData has no spring-2026
   116	  When a teacher views/saves a Spring lesson, sends Q&A; an admin replies, edits, moves/swaps
   117	  Then every write lands in lessons_spring-2026 at lessonKey.field paths; lessonData is untouched
   118	
   119	Scenario: a Fall save doesn't blank Spring (round-1 finding A)
   120	  Given Spring served from its own doc
   121	  When a Fall lesson is saved (legacy snapshot fires)
   122	  Then Spring's lessons are still on screen and currentLessonData['spring-2026'] is unchanged
   123	
   124	Scenario: own-doc listener error is loud and isolated
   125	  Given reading lessons_spring-2026 fails
   126	  Then a banner says so, Spring is unwritable, and Fall keeps working (lessonDataLoadedSuccessfully unaffected)
   127	
   128	Scenario: headroom readout
   129	  Then Diagnostics shows lessonData size of 1,024 KB, warning above 90%
   130	
   131	Scenario: content counts stay whole
   132	  Then computeLiveContentCountByTeacher counts Spring from its own doc</div>
   133	</div>
   134	
   135	<div class="phase" id="phase-c">
   136	<h3>Phase C: copy Spring into its own document (production, one-off, manager) <span class="status-tag not-ready">execution-ready: false</span></h3>
   137	<p><strong>Acceptance:</strong> <code>curriculum/lessons_spring-2026</code> holds exactly what <code>lessonData['spring-2026']</code> holds, the app now serves Spring from it (per the transitional read rule), and Spring is editable again. The old copy stays, frozen by the Phase A fence. It needs Christie's go-ahead, and she runs it at a quiet time.</p>
   138	<p><strong>How:</strong> a console procedure that Christie pastes while signed in as manager, written into this plan before execution and reviewed:</p>
   139	<ol>
   140	  <li>A forced-server read of <code>lessonData</code>, then download of <code>classbook-spring-2026-lessons-&lt;ISO&gt;.json</code>. It refuses if the read fails.</li>
   141	  <li>One transaction: read <code>lessonData</code> and <code>lessons_spring-2026</code> (which must not exist), then <code>tx.set(lessons_spring-2026, { ...lessonData['spring-2026'], lastUpdated, lastUpdatedBy })</code>, using the map read <em>inside</em> the transaction. It also writes a small record <code>curriculum/storageMigrations</code> → <code>{ 'spring-2026': { copiedAt, copiedBy, lessonCount, sha256 } }</code>, the SHA-256 of a canonical (sorted-key) JSON of the copied map.</li>
   142	  <li>Verify from a forced-server read: every lesson key present, and the hash of <code>lessons_spring-2026</code> minus its <code>lastUpdated*</code> fields equals the recorded hash. Because the Phase A fence means <strong>nothing can change the source</strong>, a deep-equal is valid, which answers round-1 finding B. A mismatch is loud. To undo, a manager deletes the new doc (whole-doc delete; see Q3) and the app falls back to <code>lessonData</code>, which is intact.</li>
   143	</ol>
   144	<div class="bdd">Scenario: copy (emulator, same procedure as a test)
   145	  Then lessons_spring-2026 deep-equals lessonData['spring-2026'] (+ lastUpdated*), storageMigrations records count + hash, the app serves Spring from the new doc and edits work
   146	Scenario: target already exists → refuses, nothing written
   147	Scenario: after the copy, a stale pre-Phase-B tab edits Spring → the Phase A fence refuses it (loud save error)</div>
   148	</div>
   149	
   150	<div class="phase" id="phase-d">
   151	<h3>Phase D: remove Spring's old copy and free the space (production, one-off, manager) <span class="status-tag not-ready">execution-ready: false</span></h3>
   152	<p><strong>Acceptance:</strong> <code>lessonData['spring-2026']</code> is gone, and <code>lessonData</code> drops to about 420 KB (41%). Spring works from its own doc. It needs Christie's separate go-ahead after Phase C has run for a few days, or immediately under the emergency lever.</p>
   153	<p><strong>How (console procedure):</strong> a forced-server read of <code>lessonData</code>. It refuses unless the SHA-256 of <code>lessonData['spring-2026']</code> equals the Phase C recorded hash. The fence kept it frozen, so it must equal what the transaction <em>wrote</em>, not the pre-transaction download (round-1 finding C). Then it downloads that copy again as JSON and runs one manager <code>update({ 'spring-2026': FieldValue.delete() })</code>, the one write the fence allows. <strong>This is the plan's only deletion, and it removes a verified, frozen duplicate.</strong></p>
   154	<div class="bdd">Scenario: remove (emulator)
   155	  Then lessonData has no spring-2026, lessons_spring-2026 unchanged, Spring fully visible, Fall unaffected
   156	Scenario: hash mismatch → refuses, nothing deleted
   157	Scenario: an open tab whose Spring came from lessonData (loaded before Phase C) → shows "moved — reload", not an empty grid</div>
   158	<div class="note"><strong>Christie's edit to <code>tinker-backups/backup.js</code></strong> must land <em>before</em> Phase D. An agent may not touch that file. After Phase D, <code>computeClassbookContentByTeacher</code> (<code>:370-389</code>) would stop seeing Spring and trip the 10% content-loss alarm for every Spring teacher. The change is to also tally lessons from <code>collections.curriculum['lessons_spring-2026']</code>, and the exact lines will be written out for her in this plan before Phase D.</div>
   159	</div>
   160	
   161	<h2 id="followup">Follow-up plan (required before the next semester is created)</h2>
   162	<div class="note">After Phase D, <code>lessonData</code> holds Fall (420 KB and growing). <strong>Before Spring 2027 is created</strong> (or before <code>lessonData</code> passes about 70%, whichever comes first), a follow-up plan must: move Fall the same way at the end of its term; make <code>createNewSemester</code> create new semesters in their own document, setting config <em>before</em> <code>saveLessonData</code> (round-1 finding F, <code>app.js:4965</code> vs <code>:4980</code>) and handling <code>not-found</code> on the first write (finding E); make <code>deleteSemester</code>/Archive handle own-doc semesters (finding "deleteSemester breaks"); and generalise the constant. The make-active-semester plan resumes after that.</div>
   163	
   164	<h2 id="safety">Firebase safety checklist</h2>
   165	<div class="safe"><ul>
   166	  <li><strong>Rules:</strong> Phase A is a shared-rules change: rules tests including a near-1 MB fixture, the whole suite green, then <code>deploy-rules.sh --approved &lt;sha&gt;</code> after the phrase. New <code>lessons_*</code> and <code>storageMigrations</code> docs are covered by <code>curriculum/{docId}</code>, so no new rule is needed. The executor re-checks <code>storageMigrations</code> is writable by manager and readable by classbook roles.</li>
   167	  <li><strong>Snapshots:</strong> JSON downloads before Phase C and before Phase D, plus <code>tinker-backups/backup.js</code>'s automated backup of the <code>curriculum</code> collection (Tier 1).</li>
   168	  <li><strong>Atomic:</strong> the copy is one transaction. The removal is one update that the rules restrict to deleting exactly that key.</li>
   169	  <li><strong>Verified:</strong> a hash recorded at copy time is checked after the copy and before the removal, all from forced-server reads.</li>
   170	  <li><strong>Reversible:</strong> until Phase D, the original is untouched. After Phase D, the downloads and backups can restore it.</li>
   171	  <li><strong>Partial updates:</strong> per-field dotted paths as today. <code>saveLessonData</code> is a whole-semester merge-set today and becomes a whole-document merge-set for an own-doc semester; it's reached from <code>createLessonSlotsForRoster</code> on Settings save, and it keeps <code>merge: true</code>. (The round-1 correction to "no whole-lesson <code>set()</code>".)</li>
   172	  <li><strong>Spot checks:</strong> one Spring lesson in the Firebase Console after Phase C and after Phase D.</li>
   173	</ul></div>
   174	
   175	<h2 id="completeness">If interrupted</h2>
   176	<ul>
   177	  <li><strong>After A:</strong> Spring is read-only, and nothing else changes.</li>
   178	  <li><strong>After B:</strong> same as A for users, plus the readout.</li>
   179	  <li><strong>Mid-C:</strong> the transaction either committed or didn't. If it committed but verify fails, the original is intact, and deleting the new doc restores the old behaviour.</li>
   180	  <li><strong>Between C and D:</strong> two copies exist. The app serves the new one, and the fence freezes the old one. No space is freed yet.</li>
   181	</ul>
   182	
   183	<h2 id="resume">Resume instructions</h2>
   184	<ol>
   185	  <li>Read this plan and its Decisions Log. Re-measure lessonData first (Phase B's readout, or the Sep 29 snippet).</li>
   186	  <li>A worktree off <code>origin/main</code>, with line numbers re-checked. Phase A work is in <code>studio-hub</code> (committed to main there, then the guard).</li>
   187	  <li>Phase by phase: commit, run the full suite, then a second-model implementation review. Each deploy and each production step (C, D) needs Christie's own yes. Phase A needs the sha phrase.</li>
   188	</ol>
   189	
   190	<h2 id="decisions">Decisions Log (append-only)</h2>
   191	<div class="decision">
   192	  <strong>Sep 29, 2026: Christie's answers.</strong> (Q1) Spring 2026 being view-only from Phase A until Phase C is fine. (Q2) Christie will paste the <code>backup.js</code> change herself (option a) before Phase D. The exact lines, for <code>tinker-backups/backup.js</code> inside <code>computeClassbookContentByTeacher</code>, just before <code>return counts;</code>:
   193	<pre style="font-size:.85rem">  // Own-document semesters: curriculum/lessons_&lt;semKey&gt; = { lessonKey: lesson, lastUpdated, … }.
   194	  for (const [docId, doc] of Object.entries(collections['curriculum'] || {})) {
   195	    if (!docId.startsWith('lessons_') || !doc || typeof doc !== 'object') continue;
   196	    for (const lesson of Object.values(doc)) if (lesson &amp;&amp; typeof lesson === 'object') tally(lesson);
   197	  }</pre>
   198	  It's generic over <code>lessons_*</code>, so Fall's later move needs no second edit. <code>tally</code> ignores non-lesson values (<code>lastUpdated</code> strings have no <code>.teacher</code>). Also: Christie asked whether Spring stays reachable after the move. Yes: it stays in every semester list and is fully viewable, and it's editable again after Phase C.
   199	</div>
   200	<div class="decision">
   201	  <strong>Sep 29, 2026: revision 2, after review round 1 (Claude; <code>thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md</code>): NOT ready, 11-point minimum list, all taken.</strong> Re-scoped to <strong>Spring only, hard-coded</strong>, with no appData flags, <code>migratedSemesters</code>, UI buttons or "Move back". The copy and the removal are reviewed console procedures. The rules fence uses a literal key (no <code>get(appData)</code>), splits <code>:654</code>, and ships <strong>first</strong>. Fixed: the listener drops own-doc semesters (A); verify races (B, moot now that the fence freezes the source first); Phase D's precondition compares against the hash of what was written (C); vanished keys are loud (D); <code>not-found</code> on first write (E); <code>createNewSemester</code>/<code>deleteSemester</code> deferred to the follow-up plan, with a deadline (F, delete); the missing readers are added (<code>tinker-backups/backup.js</code>, which is Christie's edit, the in-app content count, <code>test-alerts.js</code>, dead backup helpers, e2e exemptions, seed); the backup citation and "nightly" are corrected; the listener generation is decided (no bump); teardown uses an array; a near-1 MB rules fixture is added; there's a headroom readout; and the emergency lever's order is fixed.<br>
   202	  <strong>Open questions for Christie:</strong> (Q1) Is it OK that Spring 2026 is read-only ("editing is paused") from Phase A until Phase C, probably a few days? (Q2) Will you make the small <code>backup.js</code> edit before Phase D, or accept one expected content-loss alarm for Spring teachers? (Q3, for the reviewer) Undoing a bad Phase C copy needs a whole-doc delete of <code>lessons_spring-2026</code>; today only classbook-admin/curriculum-admin may whole-doc delete (<code>:675-678</code>). Should Phase A's split give managers delete as well (they have it today through <code>:654</code>'s <code>write</code>)? The plan assumes yes: the split keeps manager delete.
   203	</div>
   204	<div class="decision">
   205	  <strong>Sep 29, 2026: plan created (draft 1).</strong> Found while reviewing the make-active plan's Archive design (now paused behind this plan). Christie measured 972 KB / 1,024 KB.
   206	</div>
   207	
   208	</body>
   209	</html>

codex
I’ve finished the plan and prior review. Revision 2 does resolve several round-1 defects, but I’m now checking the exact transition behavior rather than accepting its helper/listener claims—especially whether “fallback read” and “own-doc listener” can disagree in the Phase-B-to-C window, and whether the proposed rules preserve every existing role’s access.
exec
/bin/zsh -lc "git rev-parse --short HEAD && git status --short && rg -n --hidden --glob '"'!node_modules/**'"' \"lessonData|lessons_spring|storageMigrations|setupLessonDataListener|lessonStoreFor|currentLessonData\" js e2e *.html 2>/dev/null" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-7OhsLcm0' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-DdcAdScm' (errno=Operation not permitted)
2ef2e62
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-UU58F7eY' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-jDAv4lVW' (errno=Operation not permitted)
e2e/helpers/sdoc.js:34:    return el && el.children.length > 0 && !el.children[0].textContent.includes('Loading') && lessonDataLoadedSuccessfully === true;
e2e/helpers/sdoc.js:48:    const COLLS = ['dayOffCamps_events', 'dayOffCamps_camps', 'dayOffCamps_lessonData'];
e2e/day-off-materials.spec.js:42:  page.evaluate(async ({ Y, id, title }) => __sdocT.read('lessonData', dayOffPlanDocId(Y, id, title)), { Y, id: camp.id, title });
e2e/day-off-materials.spec.js:44:  page.evaluate(async ({ Y, id }) => __sdocT.read('lessonData', dayOffSignoffDocId(Y, id)), { Y, id: camp.id });
e2e/day-off-materials.spec.js:64:      const writes = (await planner.evaluate(() => window.__spy.calls)).filter(c => c.via === 'tx.update' && c.path.startsWith('dayOffCamps_lessonData/'));
e2e/day-off-materials.spec.js:171:    await planner.evaluate(({ Y, c }) => __sdocT.write('lessonData', dayOffPlanDocId(Y, c, 'Glaze Party'), { yearKey: Y, campId: c, projectTitle: 'Glaze Party' }), { Y, c: camp.id });
e2e/day-off-materials.spec.js:193:    await planner.evaluate(({ Y, c }) => __sdocT.write('lessonData', dayOffPlanDocId(Y, c, 'TEST Taken'), { yearKey: Y, campId: c, projectTitle: 'TEST Taken', introPitch: 'TEST' }), { Y, c: camp.id });
e2e/day-off-materials.spec.js:218:    await planner.evaluate(({ Y, c }) => __sdocT.write('lessonData', dayOffSignoffDocId(Y, c), { yearKey: Y, campId: c, kind: 'campSignoff', projectTitle: '#signoff', complete: false }), { Y, c: camp.id });
e2e/day-off-materials.spec.js:290:      await curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'TEST Late')).set({ yearKey: Y, campId: id, projectTitle: 'TEST Late', materialItems: { mlate: { name: 'TEST late', qty: 1, scope: 'class set', order: 0 } } });
e2e/day-off-materials.spec.js:307:      await curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, window.__renameCamp, 'Clay Creatures')).update({ [`materialChecks.${window.__tickItem}`]: { by: 'TEST other tab', at: new Date().toISOString() } });
e2e/day-off-materials.spec.js:345:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'Clay Creatures'))
e2e/day-off-materials.spec.js:556:      const signoffPath = await prep.evaluate(({ Y, c }) => `dayOffCamps_lessonData/${dayOffSignoffDocId(Y, c)}`, { Y, c: clay.id });
e2e/day-off-materials.spec.js:681:      await planner.evaluate(({ Y, c, t, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, t))
e2e/day-off-materials.spec.js:885:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'Clay Creatures')).update({ projectLinks: ['https://example.test/theirs'] }), { Y, c: camp.id });
e2e/day-off-materials.spec.js:904:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'Clay Creatures')).set({
e2e/day-off-materials.spec.js:1000:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'Clay Creatures')).set({
e2e/day-off-materials.spec.js:1053:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'n/a')).set({ yearKey: Y, campId: c, projectTitle: 'n/a', materialItems: { mstray0000001: { name: 'TEST stray', qty: 1, scope: 'class set', order: 0 } } }), { Y, c: c2.id });
e2e/linkify-xss.spec.js:111:      const lesson = currentLessonData[getTvSemKey()][key];
e2e/linkify-xss.spec.js:201:    expect(await page.evaluate((key) => !!currentLessonData[getTvSemKey()]?.[key], SPRING_KEY), `${SPRING_KEY} is loaded`).toBe(true);
e2e/linkify-xss.spec.js:208:        Object.assign(currentLessonData[getTvSemKey()][key], { inspoLink, photoUrl, shortDetails: 'TEST short details' });
e2e/linkify-xss.spec.js:221:        const l = { ...currentLessonData[getTvSemKey()][key], inspoLink, photoUrl, shortDetails: 'TEST short details' };
e2e/linkify-xss.spec.js:238:    expect(await page.evaluate((key) => !!currentLessonData[getTvSemKey()]?.[key], SPRING_KEY), `${SPRING_KEY} is loaded`).toBe(true);
e2e/linkify-xss.spec.js:245:      Object.assign(currentLessonData[getTvSemKey()][key], { inspoLink: H.inspoLink[1], photoUrl: H.photoUrl[0] });
e2e/helpers/firestore.js:85:// ─── Summer shape: summerCamps_lessonData/{lessonKey} (one document per lesson) ───
e2e/helpers/firestore.js:101:  await setDoc(doc(db, 'summerCamps_lessonData', docId), { season: seasonOfTestDocId(docId), ...fields }, { merge: true });
e2e/helpers/firestore.js:110:  const snap = await getDocFromServer(doc(db, 'summerCamps_lessonData', docId));
e2e/helpers/firestore.js:117:  await deleteDoc(doc(db, 'summerCamps_lessonData', docId));
e2e/helpers/firestore.js:164:// ─── Non-summer shape: curriculum/lessonData, one shared doc nested as
e2e/helpers/firestore.js:179:const LESSON_DOC = (db) => doc(db, 'curriculum', 'lessonData');
e2e/helpers/firestore.js:226:// deleteLessonKey(). Never deletes the shared lessonData document itself.
e2e/helpers/firestore.js:243:// Cleanup — removes an entire TEST semester key from curriculum/lessonData.
e2e/day-off-teacher.spec.js:71:  page.evaluate(({ Y, id, title }) => __sdocT.read('lessonData', dayOffPlanDocId(Y, id, title)), { Y, id: camp.id, title });
e2e/day-off-teacher.spec.js:77:  await page.evaluate(async (Y) => { currentLessonData[Y] = await loadDayOffCampData({ yearKey: Y }); }, Y);
e2e/day-off-teacher.spec.js:86:  await p.waitForFunction(() => typeof lessonDataLoadedSuccessfully !== 'undefined' && lessonDataLoadedSuccessfully === true && !!currentLessonData, null, { timeout: 25_000 });
e2e/day-off-teacher.spec.js:185:    await planner.evaluate(({ Y, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'Clay Creatures'))
e2e/day-off-teacher.spec.js:210:        const slot = Object.values(currentLessonData[Y]).find(s => s.projectTitle === 'Clay Creatures');
e2e/day-off-teacher.spec.js:237:    await planner.evaluate(({ Y, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'Clay Creatures'))
e2e/day-off-teacher.spec.js:248:        await curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, campId, title)).update(coWrite);
e2e/day-off-teacher.spec.js:281:        const ref = curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, campId, title));
e2e/day-off-teacher.spec.js:294:    await planner.evaluate(({ Y, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'Clay Creatures'))
e2e/day-off-teacher.spec.js:296:    await t.evaluate(async (Y) => { currentLessonData[Y] = await loadDayOffCampData({ yearKey: Y }); }, Y);
e2e/day-off-teacher.spec.js:311:        await curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId('TEST_DATA_SAFETY_sdoc', id, 'Clay Creatures'))
e2e/day-off-teacher.spec.js:359:    await expect.poll(() => t.evaluate(({ Y, id }) => Object.values(currentLessonData[Y] || {}).filter(s => s.campId === id).map(s => s.projectTitle).sort(), { Y, id: clay.id }), { timeout: 10_000 })
e2e/day-off-teacher.spec.js:503:  test('T14: the six other lesson writers still refuse an SDOC key, and curriculum/lessonData never gets one', async ({ browser }) => {
e2e/day-off-teacher.spec.js:509:      await tryIt('lessonStoreFor', () => lessonStoreFor(Y));
e2e/day-off-teacher.spec.js:528:      const plan = await __sdocT.read('lessonData', dayOffPlanDocId(Y, campId, title));
e2e/day-off-teacher.spec.js:530:      const d = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
e2e/day-off-teacher.spec.js:534:    expect(out).toMatchObject({ lessonStoreFor: 'refused', saveLessonData: 'refused', saveMultipleLessonFields: 'refused', adminLessonStillExistsWithRetry: 'refused', noKey: true, noQaThread: true });
e2e/day-off-teacher.spec.js:562:      currentLessonData[Y][K].lastEditedAt = new Date(Date.now() + 60_000).toISOString();
e2e/day-off-teacher.spec.js:573:      return { status: saved.status, slot: currentLessonData[Y][K].introPitch, plan: currentDayOffPlans[Y][K].introPitch, id: currentLessonData[Y][K].lastEditId, serverId: saved.doc.lastEditId };
e2e/day-off-teacher.spec.js:581:    expect(await t.evaluate(({ Y, K }) => currentLessonData[Y][K].introPitch, { Y, K })).toBe('TEST new');
e2e/day-off-teacher.spec.js:637:    const signoffBefore = await planner.evaluate(({ Y, c }) => __sdocT.read('lessonData', dayOffSignoffDocId(Y, c)), { Y, c: clay.id });
e2e/day-off-teacher.spec.js:646:    expect(await t.evaluate(({ Y, K, item }) => ({ text: currentLessonData[Y][K].introPitch, tick: !!currentLessonData[Y][K].materialChecks?.[item] }), { Y, K, item })).toEqual({ text: 'TEST with tick', tick: true });
e2e/day-off-teacher.spec.js:654:    expect(await planner.evaluate(({ Y, c }) => __sdocT.read('lessonData', dayOffSignoffDocId(Y, c)), { Y, c: clay.id })).toEqual(signoffBefore);
e2e/day-off-teacher.spec.js:697:    await planner.evaluate(({ Y, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'Clay Creatures'))
e2e/day-off-teacher.spec.js:727:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'Glaze Day')).set({ yearKey: Y, campId: c, projectTitle: 'Glaze Day', projectLinks: 'https://not-an-array.test', projectDetails: { oops: 1 } }), { Y, c: clay.id });
js/app.js:171:  if (lessonDataLoadedSuccessfully === false) {
js/app.js:392:  if (!currentLessonData) await loadLessonData();
js/app.js:393:  const lessons = currentLessonData?.[semKey];
js/app.js:537:  const lessons = currentLessonData?.[semKey];
js/app.js:644:  const lessons = currentLessonData?.[semKey];
js/app.js:660:  if (!currentLessonData) {
js/app.js:668:  if (lessonDataLoadedSuccessfully === false) {
js/app.js:676:  setupLessonDataListener((data) => {
js/app.js:677:    currentLessonData = data;
js/app.js:689:    const lessons = currentLessonData?.[semKey];
js/app.js:708:  const lessons = currentLessonData?.[semKey];
js/app.js:837:      const lessons = currentLessonData?.[semKey];
js/app.js:896:  const lessons = currentLessonData?.[semKey];
js/app.js:1053:  const lessons = currentLessonData?.[semKey];
js/app.js:1239:  const lesson = currentLessonData?.[semKey]?.[key] || null;
js/app.js:1271:  const lessons = currentLessonData?.[semKey];
js/app.js:1407:  const lessons = currentLessonData?.[semKey];
js/app.js:1501:  const lessons = currentLessonData?.[semKey];
js/app.js:1609:  const lessons = currentLessonData?.[semKey];
js/app.js:1729:  if (camps.some(c => [...dayOffCampTitles(c).keys()].some(t => !currentLessonData?.[yearKey]?.[dayOffLessonKey(yearKey, c.id, t)]))) rebuildDayOffSlots(yearKey);
js/app.js:1730:  const slots = currentLessonData?.[yearKey] || {};
js/app.js:1763:          const editable = canEditDayOffPlan(slot) && lessonDataLoadedSuccessfully !== false;
js/app.js:1802:  const slot = currentLessonData?.[yearKey]?.[lessonKey];
js/app.js:1826:  renderSummerCampView(document.getElementById('tv-content'), currentLessonData?.[semKey]);
js/app.js:2292:      const lessons = currentLessonData?.[semKey];
js/app.js:2350:      const liveLesson = () => currentLessonData?.[semKey]?.[lessonKey];
js/app.js:2835:      const lessons = currentLessonData?.[semKey];
js/app.js:2870:      const lessons = currentLessonData?.[semKey];
js/app.js:2964:  const lessons = currentLessonData?.[semKey];
js/app.js:3059:  const lessons = currentLessonData?.[semKey];
js/app.js:3251:    saveTeacherEdit(lessonKey, currentLessonData?.[getTvSemKey()]?.[lessonKey] || lesson);
js/app.js:3259:      saveTeacherEdit(lessonKey, currentLessonData?.[getTvSemKey()]?.[lessonKey] || lesson);
js/app.js:3544:    if (currentLessonData[semKey]) {
js/app.js:3545:      currentLessonData[semKey][lessonKey] = updatedLesson;
js/app.js:3623:  if (lessonDataLoadedSuccessfully === false) {
js/app.js:3631:  // under that key into curriculum/lessonData is never right. Routed by TYPE
js/app.js:3636:    lessonStore = lessonStoreFor(semKey);
js/app.js:3690:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
js/app.js:3704:  if (currentLessonData?.[semKey]?.[lessonKey]) {
js/app.js:3705:    const cached = currentLessonData[semKey][lessonKey];
js/app.js:3708:    currentLessonData[semKey][lessonKey] = {
js/app.js:3773:  const lessons = currentLessonData?.[semKey];
js/app.js:3919:  const lessons = currentLessonData?.[semKey];
js/app.js:4121:  const lesson = currentLessonData?.[semKey]?.[key];
js/app.js:4344:  const lessons = currentLessonData?.[getAdminSemKey()];
js/app.js:4541:  // curriculum/lessonData, and no collection is ever cleared from here.
js/app.js:4575:  if (currentLessonData?.[key]) {
js/app.js:4576:    delete currentLessonData[key];
js/app.js:4579:  // curriculum/lessonData to delete. A camp season's lessons live in the
js/app.js:4611:    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
js/app.js:4687:// curriculum/lessonData write.
js/app.js:4721:    if (currentLessonData) currentLessonData[key] = {};
js/app.js:4814:// roster, no week grid, no lesson slots and no curriculum/lessonData write —
js/app.js:4895:  let lessonDataCommitted = false;
js/app.js:4929:      const sourceLessons = currentLessonData?.[copyFromKey] || {};
js/app.js:4966:        if (!currentLessonData) currentLessonData = {};
js/app.js:4967:        currentLessonData[key] = emptyLessons;
js/app.js:4968:        lessonDataCommitted = true;
js/app.js:4987:    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
js/app.js:4992:    if (lessonDataCommitted) {
js/app.js:5019:  if (!currentLessonData) await loadLessonData();
js/app.js:5038:  setupLessonDataListener((data) => {
js/app.js:5039:    currentLessonData = data;
js/app.js:5050:  const lessons = currentLessonData?.[semKey];
js/app.js:5227:  const lessons = currentLessonData?.[semKey];
js/app.js:5368:// summerCamps_lessonData doc exists yet, so saveAdminEdit() skips the check
js/app.js:5519:  const lesson = currentLessonData?.[semKey]?.[key] || null;
js/app.js:5563:  if (lessonDataLoadedSuccessfully === false) {
js/app.js:5589:  const lessons = { ...(currentLessonData?.[semKey] || {}) };
js/app.js:5633:  // summerCamps_lessonData doc exists (a missing doc means "never saved",
js/app.js:5768:    // execution falls through to commit currentLessonData, close the modal,
js/app.js:5791:  currentLessonData[semKey] = lessons;
js/app.js:5827:// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
js/app.js:5835:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
js/app.js:5848:  const isSummer = lessonStoreFor(semKey) === 'camp';   // Phase 1, 1.1 — by type, and a third type throws
js/app.js:5851:      const snap = await curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key)).get({ source: 'server' });
js/app.js:5869:  if (!currentLessonData[semKey]) currentLessonData[semKey] = {};
js/app.js:5870:  currentLessonData[semKey][sourceKey] = sourceLesson;
js/app.js:5872:    currentLessonData[semKey][destKey] = destLesson;
js/app.js:5874:    delete currentLessonData[semKey][destKey];
js/app.js:5881:  const lessons = { ...currentLessonData[semKey] };
js/app.js:5923:    currentLessonData[semKey] = lessons;
js/app.js:5945:        [{ lessonKey: newDestKey, lessonData: movedLesson, fieldsToClear: destFieldsToClear }],
js/app.js:6008:      currentLessonData[semKey] = lessons;
js/app.js:6017:            { lessonKey: sourceKeyForSwap, lessonData: swappedSource, fieldsToClear: sourceFieldsToClear },
js/app.js:6018:            { lessonKey: newDestKey, lessonData: swappedDest, fieldsToClear: destFieldsToClearSwap }
js/app.js:6034:      currentLessonData[semKey] = lessons;
js/app.js:6037:          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
js/app.js:6087:  const lessons = currentLessonData?.[semKey];
js/app.js:6133:      <button class="btn-secondary ca-action-btn" onclick="openDetailModal(currentLessonData['${escAttr(semKey)}']['${escAttr(sourceKey)}'], '${escAttr(sourceKey)}', '${escAttr(source.teacher)}', '${escAttr(source.className)}', ${source.weekNum})">Back</button>
js/app.js:6157:  const liveLessons = currentLessonData?.[semKey];
js/app.js:6200:      if (currentLessonData[semKey]) currentLessonData[semKey][targetKey] = updatedTarget;
js/app.js:6268:  const lessons = { ...currentLessonData[semKey] };
js/app.js:6284:    if (currentLessonData[semKey]) delete currentLessonData[semKey][key];
js/app.js:6331:    currentLessonData[semKey] = lessons;
js/app.js:6443:  const lessons = { ...(currentLessonData?.[destSemKey] || {}) };
js/app.js:6494:  currentLessonData[destSemKey] = lessons;
js/app.js:6908:  const existingLesson = currentLessonData?.[semKey]?.[key] || {};
js/app.js:6950:    if (currentLessonData[semKey]) currentLessonData[semKey][key] = newLesson;
js/app.js:7028:  const lessons = currentLessonData?.[semKey];
js/app.js:7146:  if (lessonDataLoadedSuccessfully === false) {
js/app.js:7155:    lessonStore = lessonStoreFor(semKey);
js/app.js:7160:  const cachedExisting = currentLessonData?.[semKey]?.[key];
js/app.js:7201:    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
js/app.js:7202:    : curriculumDb.collection('curriculum').doc('lessonData');
js/app.js:7212:  currentLessonData[semKey][key] = {
js/app.js:7231:  if (lessonDataLoadedSuccessfully === false) {
js/app.js:7240:    lessonStore = lessonStoreFor(semKey);
js/app.js:7245:  const cachedExisting = currentLessonData?.[semKey]?.[key];
js/app.js:7284:    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
js/app.js:7285:    : curriculumDb.collection('curriculum').doc('lessonData');
js/app.js:7299:  currentLessonData[semKey][key] = updatedLesson;
js/app.js:7515:  const summerSnap = await curriculumDb.collection('summerCamps_lessonData').get();
js/app.js:7518:  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
js/app.js:7519:  const lessonDataDoc = lessonDataSnap.exists ? lessonDataSnap.data() : {};
js/app.js:7520:  for (const semesterLessons of Object.values(lessonDataDoc)) {
js/app.js:7627:  if (!currentLessonData) await loadLessonData();
js/app.js:7629:  const lessons = currentLessonData?.[semKey];
js/app.js:7946:  if (!currentLessonData) await loadLessonData();
js/app.js:7947:  const lessons = currentLessonData?.[semKey];
js/app.js:8360:  const lessons = currentLessonData?.[semKey];
js/app.js:10207:  if (!currentLessonData) await loadLessonData();
js/app.js:10210:  const lessons = currentLessonData?.[semKey];
js/app.js:11116:  const lessons = currentLessonData?.[semKey] || {};
js/app.js:11380:  if (!currentLessonData) await loadLessonData();
js/app.js:11383:  // persistence succeeds — previously `currentLessonData[semKey] = {}` was
js/app.js:11386:  const lessons = { ...(currentLessonData[semKey] || {}) };
js/app.js:11429:    currentLessonData[semKey] = lessons; // only commit locally after Firestore confirms
js/app.js:11467:  const lessons = currentLessonData?.[semKey];
js/app.js:11512:  let lesson = currentLessonData?.[semKey]?.[lessonKey];
js/app.js:11837:    // The curriculum/lessonData listener rebuilds the whole summer cache from
js/app.js:11842:    const cachedAtStart = currentLessonData[semKey]?.[lessonKey];
js/app.js:11958:      previousCachedLesson = currentLessonData[semKey]?.[lessonKey];
js/app.js:11961:      if (currentLessonData[semKey]) currentLessonData[semKey][lessonKey] = savedLesson;
js/app.js:11975:        lesson = currentLessonData[semKey]?.[lessonKey] || lesson;
js/app.js:11988:        const semCache = currentLessonData[semKey];
js/app.js:12062:        const cachedNow = currentLessonData[semKey]?.[lessonKey];
js/app.js:12066:          if (previousCachedLesson === undefined) delete currentLessonData[semKey][lessonKey];
js/app.js:12067:          else currentLessonData[semKey][lessonKey] = previousCachedLesson;
js/app.js:12083:          const cacheEntry = currentLessonData[semKey]?.[lessonKey];
js/app.js:12084:          if (currentLessonData[semKey] && (cacheEntry === undefined || cacheEntry === previousCachedLesson)) currentLessonData[semKey][lessonKey] = displaced;
js/app.js:12239:  const lessons = currentLessonData?.[semKey];
js/app.js:12279:  const lesson = currentLessonData?.[semKey]?.[key];
js/app.js:12286:  const lessons = currentLessonData?.[semKey];
js/app.js:12520:  const writable = lessonDataLoadedSuccessfully !== false;
js/app.js:13048:  const planner = canPlanDayOffCamps() && lessonDataLoadedSuccessfully !== false;
js/app.js:13182:  const planner = canPlanDayOffCamps() && lessonDataLoadedSuccessfully !== false;
js/app.js:13183:  const ticker = canTickDayOffMaterials() && lessonDataLoadedSuccessfully !== false;
js/app.js:13409:  const ticker = canTickDayOffMaterials() && lessonDataLoadedSuccessfully !== false;
e2e/fixtures/seed/curriculum.json:59:  "lessonData": {
js/firebase-data.js:7://   curriculum/lessonData  — all lesson content by semester (imported from classbooks)
js/firebase-data.js:14:let lessonDataUnsubscribe = null;
js/firebase-data.js:56:// lesson in summerCamps_lessonData) or 'weekly' (one nested map inside the
js/firebase-data.js:57:// shared curriculum/lessonData document). The seven sites that choose between
js/firebase-data.js:64:function lessonStoreFor(semKey) {
js/firebase-data.js:127:let currentLessonData = null;
js/firebase-data.js:128:let lessonDataLoadedSuccessfully = null; // null = not yet loaded, true = ok, false = failed
js/firebase-data.js:164://                                   lessonDataLoadedSuccessfully = false makes
js/firebase-data.js:177:    lessonDataLoadedSuccessfully = false;
js/firebase-data.js:339:  // lessonDataLoadedSuccessfully = true and re-hide the banner this mode just
js/firebase-data.js:345:    lessonDataLoadedSuccessfully = false;
js/firebase-data.js:730:// ─── Lesson Data (curriculum/lessonData) ─────────────
js/firebase-data.js:762:    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
js/firebase-data.js:763:    currentLessonData = doc.exists ? doc.data() : {};
js/firebase-data.js:770:        currentLessonData[plan.semKey] = await loadOneCampSeason(plan);
js/firebase-data.js:771:        console.log(`📚 ${plan.semKey}: ${Object.keys(currentLessonData[plan.semKey]).length} lessons`);
js/firebase-data.js:776:        currentLessonData[yearKey] = await loadDayOffCampData({ yearKey });
js/firebase-data.js:777:        console.log(`📚 ${yearKey}: ${Object.keys(currentLessonData[yearKey]).length} day-off camp plans`);
js/firebase-data.js:779:      lessonDataLoadedSuccessfully = true;
js/firebase-data.js:784:      lessonDataLoadedSuccessfully = false;
js/firebase-data.js:788:    currentLessonData = {};
js/firebase-data.js:789:    lessonDataLoadedSuccessfully = false;
js/firebase-data.js:791:  return currentLessonData;
js/firebase-data.js:797:// partial currentLessonData (or, for restoreFromBackup, would land over a
js/firebase-data.js:803:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js:811:  if (lessonStoreFor(semesterKey) === 'camp') {
js/firebase-data.js:815:  // Regular semester: save to curriculum/lessonData
js/firebase-data.js:817:  await curriculumDb.collection('curriculum').doc('lessonData').set({
js/firebase-data.js:830:  await curriculumDb.collection('curriculum').doc('lessonData').update({
js/firebase-data.js:851:  for (const [lessonKey, lessonData] of Object.entries(lessons)) {
js/firebase-data.js:853:    if (!hasContent(lessonData)) continue;
js/firebase-data.js:854:    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
js/firebase-data.js:857:    const stripped = { ...lessonData };
js/firebase-data.js:895:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js:925:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js:963:  await curriculumDb.collection('curriculum').doc('lessonData').update({
js/firebase-data.js:968:// Forced-server read of one semester's whole lesson map in curriculum/lessonData
js/firebase-data.js:975:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
js/firebase-data.js:981:  const existing = currentLessonData?.[semesterKey];
js/firebase-data.js:985:  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
js/firebase-data.js:995:  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
js/firebase-data.js:1012:// The fields a saved summerCamps_lessonData doc contributes to a lesson slot
js/firebase-data.js:1078:// shared curriculum/lessonData doc re-runs the summer collection reload.
js/firebase-data.js:1083:// generation counter is module-scoped across every setupLessonDataListener()
js/firebase-data.js:1096:  for (const semKey of Object.keys(currentLessonData || {})) {
js/firebase-data.js:1097:    if ((isCampSeason(semKey) || isDayOffYear(semKey)) && currentLessonData[semKey]) out[semKey] = currentLessonData[semKey];
js/firebase-data.js:1102:// Set by setupLessonDataListener() so a season-registry mode change (legacy →
js/firebase-data.js:1112:function setupLessonDataListener(callback) {
js/firebase-data.js:1116:  if (lessonDataUnsubscribe) lessonDataUnsubscribe();
js/firebase-data.js:1133:        currentLessonData[yearKey] = mergeSummerReload(yearKey, previousSummer?.[yearKey], fresh[yearKey]);
js/firebase-data.js:1140:        currentLessonData[plan.semKey] = mergeSummerReload(plan.semKey, previousSummer?.[plan.semKey], fresh[plan.semKey]);
js/firebase-data.js:1143:      lessonDataLoadedSuccessfully = true;
js/firebase-data.js:1149:      lessonDataLoadedSuccessfully = false;
js/firebase-data.js:1155:          reloadSummer(myGeneration, snapshotCampSeasons(), attempt + 1).then(outcome => { if (outcome === 'ok' && callback) callback(currentLessonData); });
js/firebase-data.js:1167:    if (outcome !== 'stale' && callback) callback(currentLessonData);
js/firebase-data.js:1171:  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
js/firebase-data.js:1182:      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
js/firebase-data.js:1186:      currentLessonData = doc.data();
js/firebase-data.js:1187:      for (const [semKey, map] of Object.entries(previousSummer)) currentLessonData[semKey] = map;
js/firebase-data.js:1188:      console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
js/firebase-data.js:1194:      if (outcome !== 'stale' && callback) callback(currentLessonData);
js/firebase-data.js:1323:// distinction setupLessonDataListener already makes for snapshots, above).
js/firebase-data.js:1361:// authoritative: it overrides whatever (possibly stale) value lessonData
js/firebase-data.js:1364:async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
js/firebase-data.js:1365:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js:1370:  lessonData.lastEditedBy = user?.name || 'Unknown';
js/firebase-data.js:1371:  lessonData.lastEditedAt = new Date().toISOString();
js/firebase-data.js:1375:  // BEFORE lessonStoreFor(), which keeps throwing for the type: its other six
js/firebase-data.js:1376:  // callers fall through to curriculum/lessonData on anything that isn't
js/firebase-data.js:1378:  if (isDayOffYear(semesterKey)) return saveDayOffPlan(semesterKey, lessonKey, lessonData, fieldsToClear, opts.dayOffAuth);
js/firebase-data.js:1382:  const hasContent = lessonHasContent(lessonData);
js/firebase-data.js:1387:  if (lessonStoreFor(semesterKey) === 'camp') {
js/firebase-data.js:1395:    const hasPhotoField = 'photoUrl' in lessonData || 'photoPath' in lessonData;
js/firebase-data.js:1396:    if (!hasContent && !hasPhotoField && !('planComplete' in lessonData) && fieldsToActuallyClear.length === 0) {
js/firebase-data.js:1402:    const stripped = { ...lessonData };
js/firebase-data.js:1412:    console.log('💾 Saving Summer Camp lesson to summerCamps_lessonData:', lessonKey);
js/firebase-data.js:1413:    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semesterKey, lessonKey));
js/firebase-data.js:1429:  // Regular semester: curriculum/lessonData is one shared doc across every
js/firebase-data.js:1433:  // actually present in lessonData (Data Safety Plan Stage 2D).
js/firebase-data.js:1434:  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear);
js/firebase-data.js:1436:  console.log('💾 Saving to curriculum/lessonData with per-field paths:', Object.keys(updates));
js/firebase-data.js:1438:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
js/firebase-data.js:1447:// object for ONE lesson within the shared curriculum/lessonData document,
js/firebase-data.js:1448:// given an already-finalized lessonData object. Extracted from
js/firebase-data.js:1455:function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = []) {
js/firebase-data.js:1457:  const stripped = { ...lessonData };
js/firebase-data.js:1472:// vulnerable to (does NOT independently verify the given lessonData reflects
js/firebase-data.js:1476:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js:1479:  if (lessonStoreFor(semesterKey) === 'camp') {
js/firebase-data.js:1490:  for (const { lessonKey, lessonData, fieldsToClear } of writes) {
js/firebase-data.js:1491:    lessonData.lastEditedBy = user?.name || 'Unknown';
js/firebase-data.js:1492:    lessonData.lastEditedAt = new Date().toISOString();
js/firebase-data.js:1493:    Object.assign(combined, buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear || []));
js/firebase-data.js:1500:  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
js/firebase-data.js:1554:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js:1577:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js:1651:  // Every successful summer load sets lessonDataLoadedSuccessfully = true and
js/firebase-data.js:1814:    // 6. Load saved lesson plans from summerCamps_lessonData
js/firebase-data.js:1817:      const savedLessonsSnap = await scoped('summerCamps_lessonData').get();
js/firebase-data.js:1854:      if (skippedForeignSeason > 0) console.warn(`⚠️ Skipped ${skippedForeignSeason} summerCamps_lessonData document(s) stamped for another season.`);
js/firebase-data.js:1876:// every one carrying `yearKey`. Nothing here touches curriculum/lessonData or
js/firebase-data.js:1878:const DAY_OFF_COLLECTIONS = { events: 'dayOffCamps_events', camps: 'dayOffCamps_camps', plans: 'dayOffCamps_lessonData' };
js/firebase-data.js:1930:// Materials live on the project's plan record (dayOffCamps_lessonData) as
js/firebase-data.js:1986:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js:2157:  if (!currentLessonData) currentLessonData = {};
js/firebase-data.js:2158:  currentLessonData[yearKey] = buildDayOffSlots(yearKey, currentDayOffEvents[yearKey], currentDayOffCamps[yearKey], currentDayOffPlans[yearKey]);
js/firebase-data.js:2573:// A teacher's plan is the camp-project's record in dayOffCamps_lessonData (the
js/firebase-data.js:2615:// slot map (a reload can briefly swap currentLessonData out from under a save).
js/firebase-data.js:2633:  return currentLessonData[yearKey]?.[lessonKey] || null;
js/firebase-data.js:2646:async function saveDayOffPlan(yearKey, lessonKey, lessonData, fieldsToClear = [], auth) {
js/firebase-data.js:2655:  const extra = Object.keys(lessonData).filter(k => !DAY_OFF_PLAN_WRITABLE.includes(k));
js/firebase-data.js:2659:  if (!lessonData.lastEditedBy || !lessonData.lastEditedAt) throw new Error('An SDOC plan save must carry its edit stamp — refused.');
js/firebase-data.js:2661:  const payload = { ...lessonData };
js/firebase-data.js:2720:  return { status: 'savedSince', doc: server, by: server.lastEditedBy || 'someone', own: server.lastEditedBy === lessonData.lastEditedBy };
e2e/day-off-camps.spec.js:58:        const d = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
e2e/day-off-camps.spec.js:196:    const slots = await page.evaluate((Y) => currentLessonData[Y], Y);
e2e/day-off-camps.spec.js:232:    await page.evaluate(({ Y, id, planId }) => __sdocT.write('lessonData', planId, { yearKey: Y, campId: id, projectTitle: 'Clay Creatures', introPitch: 'TEST pitch' }), { Y, id: camp.id, planId });
e2e/day-off-camps.spec.js:239:    expect(await page.evaluate(({ planId }) => __sdocT.read('lessonData', planId), { planId })).toBeNull();
e2e/day-off-camps.spec.js:240:    expect(await page.evaluate(({ newId }) => __sdocT.read('lessonData', newId), { newId })).toMatchObject({ introPitch: 'TEST pitch', projectTitle: 'Clay Critters' });
e2e/day-off-camps.spec.js:250:    expect(await page.evaluate(({ newId }) => __sdocT.read('lessonData', newId), { newId })).toMatchObject({ introPitch: 'TEST pitch' });
e2e/day-off-camps.spec.js:282:      await page.evaluate(({ Y, id, planId, fields }) => __sdocT.write('lessonData', planId, { yearKey: Y, campId: id, projectTitle: 'Glaze Day', ...fields }), { Y, id: camp.id, planId, fields });
e2e/day-off-camps.spec.js:287:      expect(await page.evaluate(({ planId }) => __sdocT.read('lessonData', planId), { planId })).not.toBeNull();
e2e/day-off-camps.spec.js:295:    await page.evaluate(({ Y, id, planId }) => __sdocT.write('lessonData', planId, { yearKey: Y, campId: id, projectTitle: 'Glaze Day', introPitch: '  ', planComplete: false, materialsList: [], qaThread: [] }), { Y, id: camp.id, planId });
e2e/day-off-camps.spec.js:299:    expect(await page.evaluate(({ planId }) => __sdocT.read('lessonData', planId), { planId })).toBeNull();
e2e/day-off-camps.spec.js:300:    expect(await page.evaluate((Y) => Object.keys(currentLessonData[Y]).length, Y)).toBe(0);
e2e/day-off-camps.spec.js:583:    expect(await page.evaluate((Y) => Object.keys(currentLessonData[Y]).length, Y)).toBe(0);
e2e/day-off-camps.spec.js:590:    expect(Object.values(await page.evaluate((Y) => currentLessonData[Y], Y)).map(s => [s.projectTitle, s.block])).toEqual([['Clay Creatures', 'Block 1']]);
e2e/day-off-camps.spec.js:669:      expect(await page.evaluate((Y) => Object.keys(currentLessonData[Y] || {}).every(k => k.startsWith(`${Y}|||`)), Y)).toBe(true);
e2e/day-off-camps.spec.js:699:      await tryIt('lessonStoreFor', () => lessonStoreFor(Y));
e2e/day-off-camps.spec.js:702:      const beforeSlots = JSON.stringify(currentLessonData[Y]);
e2e/day-off-camps.spec.js:704:      out.slotsUnchanged = JSON.stringify(currentLessonData[Y]) === beforeSlots;
e2e/day-off-camps.spec.js:706:      const lessonDoc = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
e2e/day-off-camps.spec.js:710:    expect(results.lessonStoreFor).toContain('refuses to read or write');
e2e/day-off-camps.spec.js:731:        const guard = lessonDataLoadedSuccessfully;
e2e/day-off-camps.spec.js:742:    expect(await page.evaluate(() => lessonDataLoadedSuccessfully)).toBe(true);
e2e/data-safety.spec.js:136:// Instead, we test the mechanism directly: set lessonDataLoadedSuccessfully=false
e2e/data-safety.spec.js:157:// mechanism setupLessonDataListener uses when it replaces a listener.
e2e/data-safety.spec.js:161:    lessonDataLoadedSuccessfully = false;
e2e/data-safety.spec.js:165:// Stops the curriculum/lessonData listener so it cannot overwrite injected
e2e/data-safety.spec.js:167:// alone does not cancel that reload (see setupLessonDataListener); when it
e2e/data-safety.spec.js:168:// lands it replaces currentLessonData['summer-2026'] with a fresh object,
e2e/data-safety.spec.js:171:// lessonDataUnsubscribe / globalListenerGeneration are `let`s in
e2e/data-safety.spec.js:175:    if (typeof lessonDataUnsubscribe === 'function') lessonDataUnsubscribe();
e2e/data-safety.spec.js:245:// at modal-open time. If currentLessonData was updated after the modal opened
e2e/data-safety.spec.js:249:// Fix (line 2888): Cmd+S now reads currentLessonData?.[getTvSemKey()]?.[lessonKey]
e2e/data-safety.spec.js:253://   1. Inject a lesson into currentLessonData (so the modal can open without
e2e/data-safety.spec.js:256://   3. Simulate a background update: set currentLessonData[...].closure to a
e2e/data-safety.spec.js:263:  test('Test 7: Cmd+S uses currentLessonData as base, not stale modal-open snapshot', async ({ browser }) => {
e2e/data-safety.spec.js:283:    // so the boot's own `currentLessonData = …` landed on top of the
e2e/data-safety.spec.js:289:    // currentLessonData and lessonDataLoadedSuccessfully are `let` variables in firebase-data.js.
e2e/data-safety.spec.js:308:      if (!currentLessonData) currentLessonData = {};
e2e/data-safety.spec.js:309:      if (!currentLessonData['summer-2026']) currentLessonData['summer-2026'] = {};
e2e/data-safety.spec.js:310:      currentLessonData['summer-2026'][key] = {
e2e/data-safety.spec.js:327:    await page.evaluate(() => { lessonDataLoadedSuccessfully = true; });
e2e/data-safety.spec.js:337:    // Simulate a background update to currentLessonData after the modal is open.
e2e/data-safety.spec.js:342:      currentLessonData['summer-2026'][key].hasDetails = true;
e2e/data-safety.spec.js:358:    // With the FIX: Cmd+S reads currentLessonData as originalLesson base →
e2e/data-safety.spec.js:471:// All three operate on the non-summer curriculum/lessonData shared doc — the
e2e/data-safety.spec.js:513:  // flip lessonDataLoadedSuccessfully back to true under a test that has just
e2e/data-safety.spec.js:518:    lessonDataLoadedSuccessfully = true;
e2e/data-safety.spec.js:520:    if (!currentLessonData) currentLessonData = {};
e2e/data-safety.spec.js:521:    currentLessonData[semKey] = {};
e2e/data-safety.spec.js:538:      currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:569:      currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:601:        currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:622:        ({ semKey, key }) => currentLessonData[semKey][key],
e2e/data-safety.spec.js:647:        const sem = currentLessonData[semKey];
e2e/data-safety.spec.js:691:      const sem = currentLessonData[semKey];
e2e/data-safety.spec.js:731:      const sem = currentLessonData[semKey];
e2e/data-safety.spec.js:750:      ({ semKey, key }) => currentLessonData[semKey][key],
e2e/data-safety.spec.js:755:      ({ semKey, key }) => currentLessonData[semKey][key],
e2e/data-safety.spec.js:792:        const sem = currentLessonData[semKey];
e2e/data-safety.spec.js:803:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; });
e2e/data-safety.spec.js:844:        const sem = currentLessonData[semKey];
e2e/data-safety.spec.js:888:        currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:905:        ({ semKey, key }) => currentLessonData[semKey][key],
e2e/data-safety.spec.js:938:      currentLessonData[semKey][canaryKey] = canaryStale;
e2e/data-safety.spec.js:998:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; });
e2e/data-safety.spec.js:1040:      // currentLessonData, never Firestore directly) so `existing` reflects the
e2e/data-safety.spec.js:1044:        currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:1082:        ({ semKey, key }) => currentLessonData[semKey]?.[key],
e2e/data-safety.spec.js:1139:        currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:1207:      currentLessonData[semKey][key] = { ...lesson, photoUrl: '', photoPath: '' };
e2e/data-safety.spec.js:1305:      const docRef = curriculumDb.collection('summerCamps_lessonData').doc(encodeFirestoreKey(key));
e2e/data-safety.spec.js:1426:      currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:1501:      currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:1656:        errorCollections: ['summerCamps_lessonData'],
e2e/data-safety.spec.js:1662:    expect(text).toContain('Errors backing up: summerCamps_lessonData');
e2e/data-safety.spec.js:1862:        currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:1913:        currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:1956:        currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:1989:        currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:1993:      // curriculum/lessonData first (the existence check), which must keep
e2e/data-safety.spec.js:2041:        currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:2081:        currentLessonData[semKey][keyA] = lessonA;
e2e/data-safety.spec.js:2116:        currentLessonData[semKey][canaryKey] = canary;
e2e/data-safety.spec.js:2232:        currentLessonData[semKey][destKey] = scaffold;
e2e/data-safety.spec.js:2277:        currentLessonData[semKey][destKey] = staleDest;
e2e/data-safety.spec.js:2591:        currentLessonData[semKey][canaryKey] = staleCanaryForCache;
e2e/data-safety.spec.js:2626:        currentLessonData[semKey][destKey] = stale;
e2e/data-safety.spec.js:2659:        currentLessonData[semKey][destKey] = scaffold;
e2e/data-safety.spec.js:2704:        currentLessonData[semKey][destKey] = stale;
e2e/data-safety.spec.js:2880:        currentLessonData[semKey][targetKey] = target;
e2e/data-safety.spec.js:2881:        currentLessonData[semKey][otherKey] = other;
e2e/data-safety.spec.js:2888:      await page.evaluate((key) => openDetailModal(currentLessonData[getAdminSemKey()][key], key, 'TESTteacher', 'TESTclass', 1), targetKey);
e2e/data-safety.spec.js:2925:        currentLessonData[semKey][targetKey] = target;
e2e/data-safety.spec.js:2926:        currentLessonData[semKey][otherKey] = other;
e2e/data-safety.spec.js:2949:  test('sendQaReply() routes a summer-semester reply to summerCamps_lessonData, not curriculum/lessonData', async ({ browser }) => {
e2e/data-safety.spec.js:2964:        if (!currentLessonData[semKey]) currentLessonData[semKey] = {};
e2e/data-safety.spec.js:2965:        currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:2978:      expect(nonSummerDoc).toBeNull(); // must NOT have landed in curriculum/lessonData under a 'summer-2026' key
e2e/data-safety.spec.js:2997:        currentLessonData[semKey][key] = lesson; // in cache, but never written to the server
e2e/data-safety.spec.js:3000:      await page.evaluate((key) => openDetailModal(currentLessonData[getAdminSemKey()][key], key, 'TESTteacher', 'TESTclass', 1), targetKey);
e2e/data-safety.spec.js:3027:        currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:3030:      await page.evaluate((key) => openDetailModal(currentLessonData[getAdminSemKey()][key], key, 'TESTteacher', 'TESTclass', 1), targetKey);
e2e/data-safety.spec.js:3060:        currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:3063:      await page.evaluate((key) => openDetailModal(currentLessonData[getAdminSemKey()][key], key, 'TESTteacher', 'TESTclass', 1), targetKey);
e2e/data-safety.spec.js:3079:          await curriculumDb.collection('curriculum').doc('lessonData').update({
e2e/data-safety.spec.js:3100:  test('sendHelpResponse() routes a summer-semester reply to summerCamps_lessonData, not curriculum/lessonData', async ({ browser }) => {
e2e/data-safety.spec.js:3119:        if (!currentLessonData[semKey]) currentLessonData[semKey] = {};
e2e/data-safety.spec.js:3120:        currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:3134:      expect(nonSummerDoc).toBeNull(); // must NOT have landed in curriculum/lessonData under a 'summer-2026' key
e2e/data-safety.spec.js:3156:        currentLessonData[semKey][key] = lesson; // in cache, but never written to the server
e2e/data-safety.spec.js:3189:        currentLessonData[semKey][key] = lesson;
e2e/data-safety.spec.js:3203:          await curriculumDb.collection('curriculum').doc('lessonData').update({
e2e/data-safety.spec.js:3416:      await page.evaluate(({ semKey, key, lesson }) => { currentLessonData[semKey][key] = lesson; }, { semKey: TEST_SEM, key: editKey, lesson: original });
e2e/data-safety.spec.js:3454:// currentLessonData) BEFORE any write landed, and logged every copy only
e2e/data-safety.spec.js:3518:        Object.assign(currentLessonData[semKey], fixtures);
e2e/data-safety.spec.js:3539:        return { alerts, logged, cacheTarget: JSON.parse(JSON.stringify(currentLessonData[semKey][targetKey])) };
e2e/data-safety.spec.js:3595:        Object.assign(currentLessonData[semKey], fixtures);
e2e/data-safety.spec.js:3625:        const cache = currentLessonData[semKey];
e2e/data-safety.spec.js:3668:// not a camp). (R4-12) `currentLessonData[semKey] = {}` was assigned BEFORE
e2e/data-safety.spec.js:3689:      const hadKeyBefore = Object.prototype.hasOwnProperty.call(currentLessonData, semKey);
e2e/data-safety.spec.js:3690:      const before = JSON.parse(JSON.stringify(currentLessonData[semKey] ?? null));
e2e/data-safety.spec.js:3701:        hasKeyAfter: Object.prototype.hasOwnProperty.call(currentLessonData, semKey),
e2e/data-safety.spec.js:3702:        unchanged: JSON.stringify(currentLessonData[semKey] ?? null) === JSON.stringify(before),
e2e/data-safety.spec.js:3703:        after: JSON.parse(JSON.stringify(currentLessonData[semKey] ?? null)),
e2e/data-safety.spec.js:3775:      await page.evaluate(({ semKey, key, lesson }) => { currentLessonData[semKey][key] = lesson; }, { semKey: TEST_SEM, key: SLOT_1, lesson: existing });
e2e/data-safety.spec.js:3779:        return { cacheKeys: Object.keys(currentLessonData[semKey]).sort() };
e2e/data-safety.spec.js:3807:// failed load, currentLessonData is {} (or partial), so any of those callers
e2e/data-safety.spec.js:3832:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; });
e2e/data-safety.spec.js:3968:  // semester's empty lesson slots to curriculum/lessonData FIRST, then writes
e2e/data-safety.spec.js:3995:      currentLessonData[sourceKey] = {
e2e/data-safety.spec.js:4065:          lessonDataHasKey: !!currentLessonData && Object.prototype.hasOwnProperty.call(currentLessonData, newKey),
e2e/data-safety.spec.js:4083:      expect(result.lessonDataHasKey).toBe(false);
e2e/data-safety.spec.js:4110:  // the key — a pre-check that consulted currentLessonData instead of the
e2e/data-safety.spec.js:4137:        const localBefore = currentLessonData?.[newKey] ?? null;
e2e/data-safety.spec.js:4156:          localAfter: currentLessonData?.[newKey] ?? null,
e2e/data-safety.spec.js:4243:  // Round-3 review (mutation gap): the `if (lessonDataCommitted)` gate on the
e2e/data-safety.spec.js:4405:    await page.evaluate(({ semKey, key, lesson }) => { currentLessonData[semKey][key] = lesson; }, { semKey: TEST_SEM, key: lessonKey, lesson });
e2e/data-safety.spec.js:4434:      await page.evaluate(({ semKey, key, entry }) => curriculumDb.collection('curriculum').doc('lessonData').update({
e2e/data-safety.spec.js:4512:      // leave the real curriculum/lessonData listener subscribed, so the
e2e/data-safety.spec.js:4515:      await page.waitForFunction((args) => !!currentLessonData?.[args.semKey]?.[args.key], { semKey: TEST_SEM, key: lessonKey }, { timeout: 15_000 });
e2e/data-safety.spec.js:4521:      const cacheCount = await page.evaluate((args) => (currentLessonData[args.semKey][args.key].qaThread || []).filter(m => m.message === 'ONLY ONCE PLEASE').length, { semKey: TEST_SEM, key: lessonKey });
e2e/data-safety.spec.js:4546:      await page.evaluate(({ semKey, key, entry }) => curriculumDb.collection('curriculum').doc('lessonData').update({
e2e/data-safety.spec.js:4565:      const cachedThread = await page.evaluate((args) => (currentLessonData[args.semKey][args.key].qaThread || []).map(m => m.message), { semKey: TEST_SEM, key: lessonKey });
e2e/data-safety.spec.js:4587:      await page.evaluate(({ semKey, key, lesson }) => { currentLessonData[semKey][key] = lesson; }, { semKey: TEST_SEM, key: lessonKey, lesson: original });
e2e/data-safety.spec.js:4624:  test('guard (review): a summer-camp semester key is refused — nothing is written into curriculum/lessonData under it', async ({ browser }) => {
e2e/data-safety.spec.js:4655:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; });
e2e/data-safety.spec.js:4709:  const cachedIntro = (page) => page.evaluate((key) => currentLessonData[getTvSemKey()]?.[key]?.introPitch, ALPHA_KEY);
e2e/data-safety.spec.js:4711:  // The curriculum/lessonData listener (re-subscribed by initSummerContext's
e2e/data-safety.spec.js:4719:      if (typeof lessonDataUnsubscribe === 'function') lessonDataUnsubscribe();
e2e/data-safety.spec.js:4720:      window.setupLessonDataListener = () => {}; // nothing re-subscribes behind our back
e2e/data-safety.spec.js:4723:    // cache undefined until its ~1.5 s read lands (curriculum/lessonData has
e2e/data-safety.spec.js:4727:      const cur = currentLessonData?.['summer-2026'];
e2e/data-safety.spec.js:4971:        currentLessonData[semKey][key] = { ...currentLessonData[semKey][key], introPitch: 'B — changed by another client', lastEditedAt: freshAt, lastEditedBy: 'Other Client' };
e2e/data-safety.spec.js:5169:          currentLessonData[semKey][key] = { ...currentLessonData[semKey][key], photoUrl: 'https://example.com/fresh.jpg', photoPath: FRESH_PATH, lastEditedAt: freshAt, lastEditedBy: 'Other Client' };
e2e/data-safety.spec.js:5186:      expect(await page.evaluate((key) => currentLessonData[getTvSemKey()][key].photoPath, ALPHA_KEY)).toBe(FRESH_PATH);
e2e/data-safety.spec.js:5202:      // Simulate setupLessonDataListener()'s summer reload: the whole semester
e2e/data-safety.spec.js:5208:          const preWriteCopy = { ...currentLessonData[semKey][key], introPitch: 'Original content', lastEditedAt: '2026-01-01T00:00:00.000Z' };
e2e/data-safety.spec.js:5210:          currentLessonData[semKey] = { ...currentLessonData[semKey], [key]: preWriteCopy };
e2e/data-safety.spec.js:5266:        delete currentLessonData[getTvSemKey()][key];            // a reload dropped it (deleted elsewhere)
e2e/data-safety.spec.js:5273:      expect(await page.evaluate((key) => Object.prototype.hasOwnProperty.call(currentLessonData[getTvSemKey()], key), ALPHA_KEY)).toBe(false);
e2e/data-safety.spec.js:5294:          currentLessonData[semKey][key] = { ...currentLessonData[semKey][key], introPitch: 'FRESH from a reload', lastEditedAt: new Date().toISOString() };
e2e/data-safety.spec.js:5312:// ─── Backtracking audit Phase 7: the curriculum/lessonData listener ──────────
e2e/data-safety.spec.js:5326:test.describe('Data Safety — lessonData listener: summer reload outcomes (Backtracking audit Phase 7)', () => {
e2e/data-safety.spec.js:5327:  // These tests wait on real snapshots of the shared curriculum/lessonData doc,
e2e/data-safety.spec.js:5332:  // Land a write on curriculum/lessonData so every subscribed listener gets a snapshot.
e2e/data-safety.spec.js:5352:        window.__summerAtLoadStart = currentLessonData?.['summer-2026']; // the map that must stay in place while this reload runs
e2e/data-safety.spec.js:5364:    flag: lessonDataLoadedSuccessfully,
e2e/data-safety.spec.js:5414:      await page.waitForFunction(() => lessonDataLoadedSuccessfully === false, null, { timeout: 5_000 });
e2e/data-safety.spec.js:5438:      await page.evaluate(() => setupLessonDataListener(() => {}));                        // replace it — its first snapshot runs call 2 (fast failure)
e2e/data-safety.spec.js:5440:      await page.waitForFunction(() => lessonDataLoadedSuccessfully === false, null, { timeout: 5_000 });
e2e/data-safety.spec.js:5461:      await page.evaluate(() => { window.__summerGaps = 0; window.__summerSwaps = 0; window.__summerPolls = 0; window.__gapPoll = setInterval(() => { const inFlight = window.__summerLoads.length >= 1 && window.__summerLoads[0].end === null; if (!inFlight) return; window.__summerPolls++; const s = currentLessonData?.['summer-2026']; if (!s || Object.keys(s).length === 0) window.__summerGaps++; else if (s !== window.__summerAtLoadStart) window.__summerSwaps++; }, 25); });
e2e/data-safety.spec.js:5499:      await page.evaluate(({ A, nowIso }) => { const s = currentLessonData['summer-2026']; s[A] = { ...s[A], introPitch: 'Alpha confirmed here', lastEditedAt: nowIso }; }, { A: ALPHA_KEY, nowIso });
e2e/data-safety.spec.js:5504:      const after = await page.evaluate(({ A, B }) => ({ a: currentLessonData['summer-2026'][A].introPitch, b: currentLessonData['summer-2026'][B].introPitch }), { A: ALPHA_KEY, B: BETA_KEY });
e2e/data-safety.spec.js:5537:  test('RED (review): calling setupLessonDataListener() makes the previous listener\'s in-flight reload stale immediately — even before the new listener\'s first snapshot', async ({ browser }) => {
e2e/data-safety.spec.js:5548:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; document.getElementById('lesson-load-error-banner').classList.remove('hidden'); });
e2e/data-safety.spec.js:5550:      await page.evaluate(() => setupLessonDataListener(() => {}));
e2e/data-safety.spec.js:5621:      await page.evaluate(({ A, nowIso }) => { const s = currentLessonData['summer-2026']; s[A] = { ...s[A], introPitch: 'Alpha confirmed here', materials: 'stale materials in memory', adminResponse: 'legacy mirror field from another path', lastEditedAt: nowIso }; window.__mine = s[A]; }, { A: ALPHA_KEY, nowIso });
e2e/data-safety.spec.js:5626:      const r = await page.evaluate(({ A }) => { const l = currentLessonData['summer-2026'][A]; return { intro: l.introPitch, materials: l.materials, sameObject: l === window.__mine, lingering: 'adminResponse' in l, parked: displacedSummerServerCopies.has(displacedKey('summer-2026', A)) }; }, { A: ALPHA_KEY });
e2e/data-safety.spec.js:5634:      const pruned = await page.evaluate(({ A }) => { const cur = currentLessonData['summer-2026']; const fresh = { ...cur }; delete fresh[A]; mergeSummerReload('summer-2026', cur, fresh); return !displacedSummerServerCopies.has(displacedKey('summer-2026', A)); }, { A: ALPHA_KEY });
e2e/data-safety.spec.js:5655:      await page.evaluate(({ A, farFuture }) => { const s = currentLessonData['summer-2026']; s[A] = { ...s[A], introPitch: 'Pinned by a skewed clock', lastEditedAt: farFuture }; }, { A: ALPHA_KEY, farFuture });
e2e/data-safety.spec.js:5660:      expect(await page.evaluate(({ A }) => currentLessonData['summer-2026'][A].introPitch, { A: ALPHA_KEY })).toBe('Alpha on server');
e2e/data-safety.spec.js:5676:      await page.evaluate(() => { if (typeof lessonDataUnsubscribe === 'function') lessonDataUnsubscribe(); window.setupLessonDataListener = () => {}; });
e2e/data-safety.spec.js:5677:      await page.waitForFunction(() => currentLessonData?.['summer-2026'] !== undefined, null, { timeout: 20_000 });
e2e/data-safety.spec.js:5686:          const fresh = { ...currentLessonData[semKey] };
e2e/data-safety.spec.js:5687:          fresh[key] = { ...currentLessonData[semKey][key], introPitch: 'F — another client, mid-flight', lastEditedAt: otherAt, lastEditedBy: 'Other Client' };
e2e/data-safety.spec.js:5688:          currentLessonData[semKey] = mergeSummerReload(semKey, currentLessonData[semKey], fresh);
e2e/data-safety.spec.js:5696:      expect(await page.evaluate((key) => currentLessonData[getTvSemKey()][key].introPitch, ALPHA_KEY)).toBe('F — another client, mid-flight');   // not L0
e2e/data-safety.spec.js:5724:    await page.evaluate(() => { if (typeof lessonDataUnsubscribe === 'function') lessonDataUnsubscribe(); window.setupLessonDataListener = () => {}; });
e2e/data-safety.spec.js:5725:    await page.waitForFunction(() => currentLessonData?.['summer-2026'] !== undefined, null, { timeout: 20_000 });
e2e/data-safety.spec.js:5729:    await page.evaluate((key) => { currentLessonData[getTvSemKey()][key].hasDetails = true; tvCurrentTeacher = 'TEST'; renderTeacherView(); }, ALPHA_KEY);
e2e/data-safety.spec.js:5737:  const cached = (page) => page.evaluate((key) => { const l = currentLessonData[getTvSemKey()][key]; return { planComplete: l.planComplete, lastEditedAt: l.lastEditedAt || '', lastEditedBy: l.lastEditedBy || '' }; }, ALPHA_KEY);
e2e/data-safety.spec.js:5784:        const cur = currentLessonData[getTvSemKey()];
e2e/data-safety.spec.js:5811:        const cur = currentLessonData[semKey];
e2e/data-safety.spec.js:5814:        currentLessonData[semKey] = { ...cur, [O]: other };   // mine first, OTHER last
e2e/data-safety.spec.js:5826:      const both = await page.evaluate(({ A, O }) => { const s = currentLessonData[getTvSemKey()]; return { mine: s[A].planComplete, theirs: s[O].planComplete }; }, { A: ALPHA_KEY, O: OTHER_KEY });
e2e/data-safety.spec.js:5849:          const cur = currentLessonData[semKey];
e2e/data-safety.spec.js:5851:          currentLessonData[semKey] = mergeSummerReload(semKey, cur, fresh);
e2e/data-safety.spec.js:5859:      const c = await page.evaluate((key) => { const l = currentLessonData[getTvSemKey()][key]; return { intro: l.introPitch, planComplete: l.planComplete, by: l.lastEditedBy }; }, ALPHA_KEY);
e2e/data-safety.spec.js:5908:      await page.evaluate((key) => { currentLessonData[getTvSemKey()][key].hasDetails = true; renderTeacherView(); }, ALPHA_KEY);   // the view re-renders mid-flight
e2e/data-safety.spec.js:5938:          const cur = currentLessonData[semKey];
e2e/data-safety.spec.js:5941:          currentLessonData[semKey] = mergeSummerReload(semKey, cur, fresh);            // fresh wins → entry replaced
e2e/data-safety.spec.js:5949:      const r = await page.evaluate((key) => { const l = currentLessonData[getTvSemKey()][key]; return { isFresh: l === window.__freshObj, intro: l.introPitch, planComplete: l.planComplete, by: l.lastEditedBy }; }, ALPHA_KEY);
e2e/data-safety.spec.js:5986:      await page.evaluate(({ semKey, key, lesson }) => { currentLessonData[semKey][key] = lesson; }, { semKey: TEST_SEM, key, lesson });
e2e/data-safety.spec.js:6067:      await page.evaluate(({ key, fields }) => { const l = currentLessonData['summer-2026'][key]; Object.assign(l, fields); }, { key: ALPHA_KEY, fields: { projectTitle: 'TEST Project Alpha', introPitch: 'Summer intro', processStep3: 'Old step 3' } });
e2e/data-safety.spec.js:6153:      await page.evaluate((semKey) => { window.getActiveSemesterKey = () => semKey; if (!currentLessonData[semKey]) currentLessonData[semKey] = {}; }, TEST_SEM);
e2e/data-safety.spec.js:6235:  test('RED (summer first save): a generated, never-saved summer lesson — present in the cache, NO doc in summerCamps_lessonData — saves on the first try; the existence check is skipped for the summer schema', async ({ browser }) => {
e2e/data-safety.spec.js:6244:      expect(await page.evaluate((key) => !!currentLessonData['summer-2026']?.[key], ALPHA_KEY)).toBe(true);   // scaffold IS in the cache
e2e/data-safety.spec.js:6277:      await page.evaluate(({ semKey, key, lesson }) => { currentLessonData[semKey][key] = lesson; }, { semKey: TEST_SEM, key, lesson: scaffold });
e2e/data-safety.spec.js:6278:      await page.evaluate(({ key, teacher, className }) => openDetailModal(currentLessonData[getAdminSemKey()][key], key, teacher, className, 25), { key, ...ADMIN });
e2e/data-safety.spec.js:6341:      await page.evaluate(({ semKey, key, lesson }) => { currentLessonData[semKey][key] = lesson; }, { semKey: TEST_SEM, key, lesson: original });
e2e/data-safety.spec.js:6464:      await page.evaluate((key) => { delete currentLessonData['summer-2026'][key]; }, ALPHA_KEY);   // schedule rebuilt without this project
e2e/data-safety.spec.js:6545:      await page.evaluate(({ semKey, key, lesson }) => { currentLessonData[semKey][key] = lesson; }, { semKey: TEST_SEM, key, lesson: scaffold });
e2e/data-safety.spec.js:6546:      await page.evaluate(({ key, teacher, className }) => openDetailModal(currentLessonData[getAdminSemKey()][key], key, teacher, className, 33), { key, ...ADMIN });
e2e/data-safety.spec.js:6709:    await page.evaluate(() => { window.setupLessonDataListener = () => {}; });
e2e/data-safety.spec.js:6710:    await page.waitForFunction(() => currentLessonData?.['summer-2026'] !== undefined, null, { timeout: 20_000 });
e2e/data-safety.spec.js:6712:    await page.evaluate((key) => { currentLessonData[getTvSemKey()][key].hasDetails = true; tvCurrentTeacher = 'TEST'; renderTeacherView(); }, ALPHA_KEY);
e2e/data-safety.spec.js:7368:// created a nested map for it inside the shared curriculum/lessonData
e2e/data-safety.spec.js:7386:      if (!currentLessonData) currentLessonData = {};
e2e/data-safety.spec.js:7387:      currentLessonData[weekly] = currentLessonData[weekly] || {};
e2e/data-safety.spec.js:7388:      currentLessonData[camp] = currentLessonData[camp] || {};
e2e/data-safety.spec.js:7389:      currentLessonData[sdoc] = currentLessonData[sdoc] || {};
e2e/data-safety.spec.js:7393:  test('RED (1.1): a WEEKLY semester whose key starts with summer- saves to curriculum/lessonData, not the camp collection', async ({ browser }) => {
e2e/data-safety.spec.js:7401:      // Pre-Phase-1 this routed on the key: it went to summerCamps_lessonData
e2e/data-safety.spec.js:7476:          saveMultipleLessonFields: await attempt(() => saveMultipleLessonFields(semKey, [{ lessonKey: key, lessonData: lesson, fieldsToClear: [] }])),
e2e/data-safety.spec.js:7479:          lessonStoreFor:          await attempt(() => lessonStoreFor(semKey)),
e2e/data-safety.spec.js:7515:        currentLessonData[semKey][key] = { teacher: 'TESTteacher', className: 'TESTclass', projectTitle: 'TEST SDOC', qaThread: [] };
e2e/data-safety.spec.js:7663:        const savedConfig = currentConfig, savedFlag = lessonDataLoadedSuccessfully;
e2e/data-safety.spec.js:7676:            flag: lessonDataLoadedSuccessfully,
e2e/data-safety.spec.js:7685:          currentConfig = savedConfig; lessonDataLoadedSuccessfully = savedFlag;
e2e/data-safety.spec.js:7698:        const savedConfig = currentConfig, savedFlag = lessonDataLoadedSuccessfully;
e2e/data-safety.spec.js:7708:            flag: lessonDataLoadedSuccessfully,
e2e/data-safety.spec.js:7715:          currentConfig = savedConfig; lessonDataLoadedSuccessfully = savedFlag;
e2e/data-safety.spec.js:7886:// successful load would otherwise set lessonDataLoadedSuccessfully = true and
e2e/data-safety.spec.js:7898:      const saved = { mode: getSeasonRegistryMode(), flag: lessonDataLoadedSuccessfully };
e2e/data-safety.spec.js:7905:        lessonDataLoadedSuccessfully = saved.flag;
e2e/data-safety.spec.js:7925:        const deniedFlag = lessonDataLoadedSuccessfully;
e2e/data-safety.spec.js:7928:        const offlineFlag = lessonDataLoadedSuccessfully;
e2e/data-safety.spec.js:7961:        out.flagAfter = lessonDataLoadedSuccessfully;
e2e/data-safety.spec.js:8060:          flag: lessonDataLoadedSuccessfully,
e2e/data-safety.spec.js:8111:      if (!currentLessonData) currentLessonData = {};
e2e/data-safety.spec.js:8115:      currentLessonData['summer-2026'] = { ...(currentLessonData['summer-2026'] || {}), ...scaffold() };
e2e/data-safety.spec.js:8116:      currentLessonData[sem] = scaffold();
e2e/data-safety.spec.js:8269:        const freshFor2099 = { ...currentLessonData[sem] };
e2e/data-safety.spec.js:8271:        mergeSummerReload(sem, currentLessonData[sem], freshFor2099);
e2e/data-safety.spec.js:8483:        currentLessonData[sem] = { [key]: { teacher: 'TEST' } };
e2e/data-safety.spec.js:8494:          return { confirms, appDataWrites, lessonDeletes, stillInMemory: !!currentLessonData[sem] };
e2e/data-safety.spec.js:8498:          delete currentConfig.semesters[sem]; delete currentLessonData[sem];
e2e/data-safety.spec.js:8506:      // Only the appData entry is written, and curriculum/lessonData is never
e2e/data-safety.spec.js:8755:          const duringFlag = lessonDataLoadedSuccessfully;
e2e/data-safety.spec.js:8760:            afterFlag: lessonDataLoadedSuccessfully,
e2e/data-safety.spec.js:8942:          const migrated = buildSummerScheduleGridHtml(currentLessonData['summer-2026'] || {});
e2e/data-safety.spec.js:9028:        currentLessonData[sem] = currentLessonData[sem] || {};
e2e/data-safety.spec.js:9029:        currentLessonData[sem][key] = { teacher: 'TESTteacher', qaThread: [] };
e2e/data-safety.spec.js:9032:        const savedFlag = lessonDataLoadedSuccessfully;
e2e/data-safety.spec.js:9034:        lessonDataLoadedSuccessfully = false;
e2e/data-safety.spec.js:9041:          lessonDataLoadedSuccessfully = savedFlag;
e2e/data-safety.spec.js:9044:          delete currentLessonData[sem][key];

exec
/bin/zsh -lc "nl -ba js/firebase-data.js | sed -n '1,115p;730,1030p;1060,1215p;1340,1535p'
nl -ba js/app.js | sed -n '3400,3740p;4500,5060p;5480,6100p;6860,7325p;7470,7620p;11280,11430p'
nl -ba /Users/christiehubley/studio-hub/firestore.rules | sed -n '600,710p'
nl -ba /Users/christiehubley/studio-hub/js/alerts.js | sed -n '500,620p'
nl -ba /Users/christiehubley/tinker-backups/backup.js | sed -n '1,90p;340,500p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
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
    15	
    16	// The content fields a lesson's stripping/hasContent/wipe-detection logic
    17	// treats as "real plan content" (as opposed to metadata like teacher/weekNum).
    18	// Single source of truth — previously duplicated across four call sites.
    19	const CONTENT_FIELDS = ['introPitch', 'processStep1', 'processStep2', 'processStep3', 'processStep4', 'closure', 'dayOfMaterials'];
    20	function lessonHasContent(lesson) {
    21	  return !!lesson && CONTENT_FIELDS.some(f => lesson[f] && String(lesson[f]).trim());
    22	}
    23	
    24	// Firestore doc IDs cannot contain '/'. Encode lesson keys for storage.
    25	function encodeFirestoreKey(key) { return key.replace(/\//g, '__SLASH__'); }
    26	function decodeFirestoreKey(key) { return key.replace(/__SLASH__/g, '/'); }
    27	
    28	// ─── Semester types (camp seasons Phase 1, 1.1) ──────────────────────────────
    29	// Every semester stores its kind explicitly. Nothing in the app may infer a
    30	// kind from a key: "does this key start with summer-?" was how a weekly
    31	// semester named "Summer Enrichment" could be routed into the summer
    32	// collections (R5-3), and how Summer 2026 was the only camp season that could
    33	// ever exist.
    34	const SEMESTER_TYPES = { weekly: 'weekly', camp: 'summer-camp', dayOff: 'day-off-camps' };
    35	
    36	// The stored type, or 'weekly' when absent — with ONE quarantined exception:
    37	// an absent type on the literal key `summer-2026` is a camp season. That
    38	// covers two real windows: the minutes between this deploy and Christie
    39	// pressing "Stamp semester types", and a stale pre-Phase-1 tab whose
    40	// whole-document saveConfig() could strip the field. It is the only place
    41	// that literal may appear — a static test fails the build on any other
    42	// functional occurrence. In practice it almost never fires: the May 2026
    43	// auto-add already stored semesterType on the server's summer-2026.
    44	const LEGACY_CAMP_SEMESTER_KEY = 'summer-2026';
    45	function semesterTypeOf(semKey) {
    46	  const stored = currentConfig?.semesters?.[semKey]?.semesterType;
    47	  if (stored) return stored;
    48	  if (semKey === LEGACY_CAMP_SEMESTER_KEY) return SEMESTER_TYPES.camp;
    49	  return SEMESTER_TYPES.weekly;
    50	}
    51	// Read the type only through these — never re-derive it from a key.
    52	function isCampSeason(semKey) { return semesterTypeOf(semKey) === SEMESTER_TYPES.camp; }
    53	function isWeeklySemester(semKey) { return semesterTypeOf(semKey) === SEMESTER_TYPES.weekly; }
    54	
    55	// Which lesson store a semester's lessons live in: 'camp' (one document per
    56	// lesson in summerCamps_lessonData) or 'weekly' (one nested map inside the
    57	// shared curriculum/lessonData document). The seven sites that choose between
    58	// those two stores — the four lesson writers, the two admin reply writers and
    59	// the existence check — all route through this, so a THIRD type is refused
    60	// rather than treated as weekly: the reply writers' weekly branch update()s
    61	// dotted `{semKey}.{key}.qaThread` paths, which for an SDOC key would quietly
    62	// create a nested map inside the shared weekly document (camp seasons
    63	// Phase 1, 1.1; cross-plan with classbook-school-day-off-camps).
    64	function lessonStoreFor(semKey) {
    65	  const type = semesterTypeOf(semKey);
    66	  switch (type) {
    67	    case SEMESTER_TYPES.camp:   return 'camp';
    68	    case SEMESTER_TYPES.weekly: return 'weekly';
    69	    default:
    70	      throw new Error(`Semester "${semKey}" is a "${type}" semester — this app has no lesson store for that type yet, so it refuses to read or write its lessons.`);
    71	  }
    72	}
    73	
    74	// ─── Summer document IDs (camp seasons Phase 1, 1.5) ─────────────────────────
    75	// The cross-app contract, shared with the Summer Camp App: 2026 documents keep
    76	// every existing ID unchanged; any other season prefixes the ENTIRE legacy ID
    77	// with the reserved token `season-{year}|||`, applied after the legacy ID is
    78	// fully formed (i.e. after encodeFirestoreKey()). `season-` cannot collide
    79	// with a teacher or camp name, and a bare `{year}|||` prefix would have been
    80	// ambiguous against a legacy ID whose first segment happens to be a year.
    81	// parseSummerDocId() is the exact inverse; anything unprefixed is 2026.
    82	const LEGACY_SEASON = '2026';
    83	const SEASON_DOC_ID_PREFIX = /^season-(\d{4})\|\|\|/;
    84	function summerDocId(legacyId, season) {
    85	  return season === LEGACY_SEASON ? legacyId : `season-${season}|||${legacyId}`;
    86	}
    87	// (semKey, legacy key) → the document ID in that semester's season. Every
    88	// summer writer and by-ID reader goes through this; a static test forbids a
    89	// bare .doc() on a summerCamps_* collection anywhere else.
    90	function summerDocIdFor(semKey, legacyKey) {
    91	  return summerDocId(encodeFirestoreKey(legacyKey), seasonForSemester(semKey));
    92	}
    93	
    94	function parseSummerDocId(docId) {
    95	  const m = SEASON_DOC_ID_PREFIX.exec(docId);
    96	  return m ? { season: m[1], legacyId: docId.slice(m[0].length) }
    97	           : { season: LEGACY_SEASON, legacyId: docId };
    98	}
    99	
   100	// The `season` stamp every summer document this app writes carries (camp
   101	// seasons Phase 0) — the Summer Camp App filters the shared summerCamps_*
   102	// collections by it, so an unstamped doc is invisible there. Taken from the
   103	// semester's stored `season` when it has one (Phase 1 stamps it), else the
   104	// year in the key (`summer-2026` → '2026'). Never from summerCamps_seasons/
   105	// _current: that says which season the Summer Camp App is ON, not which one
   106	// THIS write belongs to — the moment it moves to 2027, a teacher editing
   107	// Summer 2026 here would re-stamp a 2026 doc as 2027. Throws on anything
   108	// that isn't a 4-digit year rather than write a stamp the Summer Camp App's
   109	// verify scan would reject (which would block its season switch-on) — so a
   110	// weekly semester whose key happens to start with `summer-` fails its save
   111	// loudly here instead of being misrouted silently (R5-3, until Phase 1
   112	// routes by semesterType).
   113	function seasonForSemester(semKey) {
   114	  const stored = currentConfig?.semesters?.[semKey]?.season;
   115	  // A stored season, once present, is authoritative — even a malformed one
   730	// ─── Lesson Data (curriculum/lessonData) ─────────────
   731	
   732	// Every camp-season semester in the config, with the season each one reads.
   733	// In legacy mode the 2026 season reads unfiltered (it is the only season that
   734	// exists by definition) and any other camp season loads nothing at all —
   735	// there is nothing stamped for it yet (Phase 1, 1.3/1.4).
   736	function dayOffYearKeys() {
   737	  return Object.keys(currentConfig?.semesters || {}).filter(isDayOffYear);
   738	}
   739	
   740	function campSeasonLoadPlan() {
   741	  const semesters = currentConfig?.semesters || {};
   742	  return Object.keys(semesters)
   743	    .filter(isCampSeason)
   744	    .map(semKey => {
   745	      const season = seasonForSemester(semKey);
   746	      if (seasonRegistryMode === 'legacy') {
   747	        return season === LEGACY_SEASON ? { semKey, season: null } : { semKey, season, unavailable: true };
   748	      }
   749	      return { semKey, season };
   750	    });
   751	}
   752	
   753	// One camp season's lessons, or an empty map when legacy mode cannot serve it.
   754	async function loadOneCampSeason(plan, opts = {}) {
   755	  if (plan.unavailable) { currentSummerSessionsBySemester[plan.semKey] = []; return {}; }
   756	  return await loadSummerCampData({ ...opts, season: plan.season, semKey: plan.semKey });
   757	}
   758	
   759	async function loadLessonData() {
   760	  if (!curriculumDb) initCurriculumFirestore();
   761	  try {
   762	    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
   763	    currentLessonData = doc.exists ? doc.data() : {};
   764	
   765	    // Every camp season gets its own map (Phase 1, 1.4) — no literal key.
   766	    try {
   767	      const plans = campSeasonLoadPlan();
   768	      console.log('📚 Loading camp seasons:', plans.map(p => `${p.semKey}${p.season ? ` (${p.season})` : ' (unfiltered)'}`).join(', ') || 'none');
   769	      for (const plan of plans) {
   770	        currentLessonData[plan.semKey] = await loadOneCampSeason(plan);
   771	        console.log(`📚 ${plan.semKey}: ${Object.keys(currentLessonData[plan.semKey]).length} lessons`);
   772	      }
   773	      // School Day Off Camps years: their own three collections. A failure
   774	      // trips the same app-wide guard — loud, never a quiet empty list.
   775	      for (const yearKey of dayOffYearKeys()) {
   776	        currentLessonData[yearKey] = await loadDayOffCampData({ yearKey });
   777	        console.log(`📚 ${yearKey}: ${Object.keys(currentLessonData[yearKey]).length} day-off camp plans`);
   778	      }
   779	      lessonDataLoadedSuccessfully = true;
   780	    } catch (err) {
   781	      // One season failing trips the guard for the whole app: a partially
   782	      // loaded model is not a safe base for any writer, in any semester.
   783	      console.error('❌ Could not load camp season data:', err);
   784	      lessonDataLoadedSuccessfully = false;
   785	    }
   786	  } catch (err) {
   787	    console.error('Error loading lesson data:', err);
   788	    currentLessonData = {};
   789	    lessonDataLoadedSuccessfully = false;
   790	  }
   791	  return currentLessonData;
   792	}
   793	
   794	// Whole-semester bulk writer (restoreFromBackup, createNewSemester,
   795	// createLessonSlotsForRoster). Guarded the same way as
   796	// saveSingleLesson(): after a failed load, `lessons` is built from an empty or
   797	// partial currentLessonData (or, for restoreFromBackup, would land over a
   798	// semester whose current state this client never confirmed), and merge:true
   799	// would still write it over the real semester map. Throws rather than no-ops —
   800	// every caller treats a resolved promise as "the write landed" (backtracking
   801	// audit, Phase 11).
   802	async function saveLessonData(semesterKey, lessons) {
   803	  if (lessonDataLoadedSuccessfully === false) {
   804	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
   805	  }
   806	  if (!curriculumDb) initCurriculumFirestore();
   807	
   808	  // Route by the semester's TYPE, never by its key (Phase 1, 1.1): camp
   809	  // seasons go to the per-lesson collection (also dodging the 1MB doc limit),
   810	  // and any other type is refused rather than misrouted.
   811	  if (lessonStoreFor(semesterKey) === 'camp') {
   812	    return await saveSummerCampLessonData(semesterKey, lessons);
   813	  }
   814	
   815	  // Regular semester: save to curriculum/lessonData
   816	  const user = getAuthUser();
   817	  await curriculumDb.collection('curriculum').doc('lessonData').set({
   818	    [semesterKey]: lessons,
   819	    lastUpdated: new Date().toISOString(),
   820	    lastUpdatedBy: user?.name || 'Unknown'
   821	  }, { merge: true });
   822	}
   823	
   824	// Explicitly delete a single lesson key from the nested map.
   825	// More reliable than resaving the full semester when cutting a project,
   826	// because Firestore's merge:true may not remove nested map keys.
   827	async function deleteLessonKey(semesterKey, lessonKey) {
   828	  if (!curriculumDb) initCurriculumFirestore();
   829	  const user = getAuthUser();
   830	  await curriculumDb.collection('curriculum').doc('lessonData').update({
   831	    [`${semesterKey}.${lessonKey}`]: firebase.firestore.FieldValue.delete(),
   832	    lastUpdated: new Date().toISOString(),
   833	    lastUpdatedBy: user?.name || 'Unknown'
   834	  });
   835	}
   836	
   837	async function saveSummerCampLessonData(semKey, lessons) {
   838	  if (!curriculumDb) initCurriculumFirestore();
   839	  // Resolved once, before any batch work — a semester with no valid season
   840	  // throws here, so nothing is queued.
   841	  const season = seasonForSemester(semKey);
   842	  const user = getAuthUser();
   843	  const batch = curriculumDb.batch();
   844	
   845	  console.log('💾 Saving Summer Camp lesson data...', { semKey, season });
   846	
   847	  const hasContent = lessonHasContent;
   848	
   849	  let writeCount = 0;
   850	  // Save each lesson as a separate document (lessonKey as doc ID)
   851	  for (const [lessonKey, lessonData] of Object.entries(lessons)) {
   852	    // Never overwrite existing docs with empty content — protects against stale in-memory state
   853	    if (!hasContent(lessonData)) continue;
   854	    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
   855	    // Strip empty content fields so stale in-memory empty strings never overwrite
   856	    // real content that a teacher saved in a different browser session.
   857	    const stripped = { ...lessonData };
   858	    CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
   859	    // JSON round-trip strips undefined values that Firestore rejects with invalid-argument
   860	    const cleanData = JSON.parse(JSON.stringify({
   861	      ...stripped,
   862	      season,
   863	      lastUpdated: new Date().toISOString(),
   864	      lastUpdatedBy: user?.name || 'Unknown'
   865	    }));
   866	    batch.set(docRef, cleanData, { merge: true });
   867	    writeCount++;
   868	  }
   869	
   870	  await batch.commit();
   871	  console.log(`✅ Saved ${writeCount} Summer Camp lesson slots (skipped ${Object.keys(lessons).length - writeCount} empty)`);
   872	}
   873	
   874	// Season-scoped, and it no longer swallows its errors (Phase 1, 1.4): a
   875	// failure used to return {} — every camp-complete checkbox unchecked — and the
   876	// next click would write campComplete: false over a true. The caller renders
   877	// an error state instead. Two equality filters need no composite index.
   878	async function loadCampCompleteData(semKey, teacher) {
   879	  if (!curriculumDb) initCurriculumFirestore();
   880	  const result = {};
   881	  let query = curriculumDb.collection('summerCamps_campComplete').where('teacher', '==', teacher);
   882	  if (seasonRegistryMode !== 'legacy') query = query.where('season', '==', seasonForSemester(semKey));
   883	  const snapshot = await query.get();
   884	  snapshot.forEach(doc => {
   885	    const data = doc.data();
   886	    result[data.campName] = data.campComplete || false;
   887	  });
   888	  return result;
   889	}
   890	
   891	// Same load guard as the lesson writers (saveLessonData/saveSingleLesson):
   892	// after a failed load the camp view was drawn from nothing, so its checkbox
   893	// state is not something to write back.
   894	async function saveCampComplete(semKey, teacher, campName, campComplete) {
   895	  if (lessonDataLoadedSuccessfully === false) {
   896	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
   897	  }
   898	  if (!curriculumDb) initCurriculumFirestore();
   899	  const season = seasonForSemester(semKey);
   900	  // Merge, not replace: the doc keeps whatever else it carries — today
   901	  // nothing, after the Summer Camp App's backfill its `season` stamp (which
   902	  // this write re-asserts). A full set() here would have erased the stamp on
   903	  // the first toggle after the backfill.
   904	  await curriculumDb.collection('summerCamps_campComplete').doc(summerDocIdFor(semKey, `${teacher}|||${campName}`)).set({
   905	    teacher,
   906	    campName,
   907	    campComplete,
   908	    season,
   909	    updatedAt: new Date().toISOString()
   910	  }, { merge: true });
   911	}
   912	
   913	async function getSummerLessonQaThread(semKey, lessonKey) {
   914	  if (!curriculumDb) initCurriculumFirestore();
   915	  const doc = await curriculumDb.collection('summerCamps_prepHelpQueue').doc(summerDocIdFor(semKey, lessonKey)).get();
   916	  if (!doc.exists) return [];
   917	  return doc.data().qaThread || [];
   918	}
   919	
   920	// semKey is the MODAL's semester (captured when it opened), not the header
   921	// selector's — that can move while the modal is open. Only the create path
   922	// stamps `season`; a later message never re-stamps or moves a doc between
   923	// seasons (the Summer Camp App's Season.patch() rule).
   924	async function sendSummerLessonQaMessage(semKey, lessonKey, lesson, newMsg) {
   925	  if (lessonDataLoadedSuccessfully === false) {
   926	    throw new Error('Lesson data failed to load — refusing to send until it has. Reload and try again.');
   927	  }
   928	  if (!curriculumDb) initCurriculumFirestore();
   929	  // Resolved before the read so an invalid semester is refused before anything is touched.
   930	  const season = seasonForSemester(semKey);
   931	  const docRef = curriculumDb.collection('summerCamps_prepHelpQueue').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
   932	  const docSnap = await docRef.get();
   933	  const isAdmin = newMsg.from === 'admin';
   934	
   935	  if (!docSnap.exists) {
   936	    await docRef.set({
   937	      queueType: 'teachers',
   938	      campTopic: lesson.campName,
   939	      project: lesson.projectTitle,
   940	      projectTitle: lesson.projectTitle,
   941	      block: lesson.block,
   942	      teacher: lesson.teacher,
   943	      lessonKey,
   944	      season,
   945	      askedBy: newMsg.name,
   946	      question: newMsg.message,
   947	      qaThread: [newMsg],
   948	      status: 'Open',
   949	      createdAt: firebase.firestore.FieldValue.serverTimestamp(),
   950	      lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
   951	    });
   952	  } else {
   953	    await docRef.update({
   954	      qaThread: firebase.firestore.FieldValue.arrayUnion(newMsg),
   955	      status: isAdmin ? 'Resolved' : 'Open',
   956	      lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
   957	    });
   958	  }
   959	}
   960	
   961	async function deleteLessonData(semesterKey) {
   962	  if (!curriculumDb) initCurriculumFirestore();
   963	  await curriculumDb.collection('curriculum').doc('lessonData').update({
   964	    [semesterKey]: firebase.firestore.FieldValue.delete()
   965	  });
   966	}
   967	
   968	// Forced-server read of one semester's whole lesson map in curriculum/lessonData
   969	// (null when absent). Bypasses both the in-memory model and the SDK cache —
   970	// used where the local cache is known to be untrustworthy for this key, e.g.
   971	// createNewSemester()'s pre-check (deleteSemester() drops a key locally even
   972	// when its server-side delete failed). Backtracking audit, Phase 11.
   973	async function readServerSemesterLessonMap(semesterKey) {
   974	  if (!curriculumDb) initCurriculumFirestore();
   975	  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
   976	  return snap.exists ? (snap.data()?.[semesterKey] ?? null) : null;
   977	}
   978	
   979	async function backupLessonData(semesterKey) {
   980	  if (!curriculumDb) initCurriculumFirestore();
   981	  const existing = currentLessonData?.[semesterKey];
   982	  if (!existing || Object.keys(existing).length === 0) return 0;
   983	  const count = Object.keys(existing).length;
   984	  const user = getAuthUser();
   985	  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
   986	    [semesterKey]: existing,
   987	    backupDate: new Date().toISOString(),
   988	    backupBy: user?.name || 'Unknown'
   989	  }, { merge: true });
   990	  return count;
   991	}
   992	
   993	async function restoreFromBackup(semesterKey) {
   994	  if (!curriculumDb) initCurriculumFirestore();
   995	  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
   996	  if (!backupDoc.exists) return null;
   997	  const backupData = backupDoc.data();
   998	  const lessons = backupData?.[semesterKey];
   999	  if (!lessons || Object.keys(lessons).length === 0) return null;
  1000	  await saveLessonData(semesterKey, lessons);
  1001	  return Object.keys(lessons).length;
  1002	}
  1003	
  1004	// "Which copy of a lesson is newer", by lastEditedAt — the only revision
  1005	// marker the data has (a client wall-clock heuristic: ties and missing values
  1006	// resolve to "not newer"). Shared by the listener merge below and the summer
  1007	// editor's own adoption/re-install logic (Backtracking audit Phase 10).
  1008	function lessonEditedAtMs(lesson) {
  1009	  return Date.parse(lesson?.lastEditedAt || '') || 0;
  1010	}
  1011	
  1012	// The fields a saved summerCamps_lessonData doc contributes to a lesson slot
  1013	// (everything else on the slot — teacher, camp, materials, sharedWith, class
  1014	// size… — is rebuilt from the other collections on every reload and must
  1015	// always come from the fresh read).
  1016	const SUMMER_SAVED_FIELDS = [...CONTENT_FIELDS, 'photoUrl', 'photoPath', 'planComplete', 'lastEditedBy', 'lastEditedAt'];
  1017	// A reload's read can only plausibly predate a save this recent; a stamp
  1018	// older than this — or further than this into the future — is a skewed clock
  1019	// or a doc deleted/restored underneath us, and the fresh read wins.
  1020	const SUMMER_KEEP_MINE_WINDOW_MS = 10 * 60 * 1000;
  1021	// When the merge keeps an in-memory copy, the server copy it displaced is
  1022	// parked here so the summer editor can fall back to it if the in-flight save
  1023	// that made the in-memory copy "newer" then fails (see openLessonModal()).
  1024	// Keyed by SEMESTER and lesson (Phase 1, 1.4): two camp seasons legitimately
  1025	// share a lesson key — same teacher, camp, block and project in 2026 and
  1026	// 2027 — and a single-keyed map would park one season's server copy under
  1027	// the other's, then hand it back to the wrong editor.
  1028	const displacedSummerServerCopies = new Map();
  1029	const displacedKey = (semKey, lessonKey) => `${semKey}|${lessonKey}`;
  1030	
  1060	    if (keepMine) {
  1061	      const saved = {};
  1062	      SUMMER_SAVED_FIELDS.forEach(f => { if (f in mine) saved[f] = mine[f]; });
  1063	      displacedSummerServerCopies.set(displacedKey(semKey, key), fresh[key]);
  1064	      // `mine` becomes exactly "fresh scaffold + my saved fields" — anything
  1065	      // else that was sitting on it (e.g. legacy Q&A mirror fields another
  1066	      // path installed) goes, so the object never carries stale extras.
  1067	      for (const f of Object.keys(mine)) { if (!(f in fresh[key]) && !(f in saved)) delete mine[f]; }
  1068	      Object.assign(mine, fresh[key], saved);
  1069	      fresh[key] = mine;
  1070	    } else {
  1071	      displacedSummerServerCopies.delete(displacedKey(semKey, key));
  1072	    }
  1073	  }
  1074	  return fresh;
  1075	}
  1076	
  1077	// Backtracking audit Phase 7 (R2-10, R3-7, R4-10): every snapshot of the
  1078	// shared curriculum/lessonData doc re-runs the summer collection reload.
  1079	// Its outcome now drives the load-guard and the banner like the initial
  1080	// load does — a failure trips them, a later success resets them — and only
  1081	// the LATEST reload's outcome may do so: callbacks resolve out of order, and
  1082	// unsubscribing a listener does not cancel its in-flight callback, so the
  1083	// generation counter is module-scoped across every setupLessonDataListener()
  1084	// call (and bumped by the call itself, so an old listener's in-flight reload
  1085	// is stale from the moment it is replaced). A tripped guard blocks every
  1086	// writer in the app, so a failed reload is retried a bounded number of times
  1087	// on its own — a wifi blip self-heals, a real outage keeps the banner.
  1088	// Handed over by Phase 10: the summer cache is kept in place for the ~1.5 s
  1089	// the reload takes (it used to vanish, so the summer view rendered nothing
  1090	// and an in-flight save's optimistic entry had no map to live in), and the
  1091	// reload is merged per lesson keeping the newer copy (mergeSummerReload).
  1092	const SUMMER_RELOAD_RETRY_DELAYS_MS = [5000, 15000];
  1093	// The camp seasons currently in memory, by semester key.
  1094	function snapshotCampSeasons() {
  1095	  const out = {};
  1096	  for (const semKey of Object.keys(currentLessonData || {})) {
  1097	    if ((isCampSeason(semKey) || isDayOffYear(semKey)) && currentLessonData[semKey]) out[semKey] = currentLessonData[semKey];
  1098	  }
  1099	  return out;
  1100	}
  1101	
  1102	// Set by setupLessonDataListener() so a season-registry mode change (legacy →
  1103	// filtered, or unknown healing) re-runs the summer load through that
  1104	// listener's own generation-gated path — never a second, competing one
  1105	// (Phase 1, 1.3).
  1106	let summerReloadHook = null;
  1107	async function reloadSummerForModeChange() {
  1108	  if (typeof summerReloadHook !== 'function') return 'no-listener';
  1109	  return await summerReloadHook();
  1110	}
  1111	
  1112	function setupLessonDataListener(callback) {
  1113	  console.log('📚 Setting up lesson data listener...');
  1114	  if (!curriculumDb) initCurriculumFirestore();
  1115	  globalListenerGeneration++; // whatever the previous listener still has in flight is now stale
  1116	  if (lessonDataUnsubscribe) lessonDataUnsubscribe();
  1117	
  1118	  // One reload attempt for one snapshot generation. Only the latest
  1119	  // generation may touch the guard, the banner, or the summer cache.
  1120	  // Resolves 'ok' | 'failed' | 'stale'. Only 'stale' means this generation's
  1121	  // outcome was discarded (a newer snapshot took over while it ran).
  1122	  const reloadSummer = async (myGeneration, previousSummer, attempt) => {
  1123	    const isCurrent = () => myGeneration === globalListenerGeneration;
  1124	    try {
  1125	      console.log('📚 Attempting to load camp season data...' + (attempt ? ` (retry ${attempt})` : ''));
  1126	      const plans = campSeasonLoadPlan();
  1127	      const fresh = {};
  1128	      for (const plan of plans) fresh[plan.semKey] = await loadOneCampSeason(plan, { isCurrent });
  1129	      const dayOffKeys = dayOffYearKeys();
  1130	      for (const yearKey of dayOffKeys) fresh[yearKey] = await loadDayOffCampData({ yearKey, isCurrent });
  1131	      if (!isCurrent()) { console.log('📚 Camp season reload superseded by a newer snapshot — ignoring its result'); return 'stale'; }
  1132	      for (const yearKey of dayOffKeys) {
  1133	        currentLessonData[yearKey] = mergeSummerReload(yearKey, previousSummer?.[yearKey], fresh[yearKey]);
  1134	        healDayOffYearAfterReload(yearKey, fresh[yearKey]);
  1135	      }
  1136	      for (const plan of plans) {
  1137	        // Each season merges against ITS OWN previous map — mergeSummerReload
  1138	        // prunes parked copies that are absent from `fresh`, so merging one
  1139	        // season against another's would evict the other's on every reload.
  1140	        currentLessonData[plan.semKey] = mergeSummerReload(plan.semKey, previousSummer?.[plan.semKey], fresh[plan.semKey]);
  1141	      }
  1142	      console.log('📚 Camp seasons loaded:', plans.map(p => `${p.semKey}=${Object.keys(fresh[p.semKey]).length}`).join(' '));
  1143	      lessonDataLoadedSuccessfully = true;
  1144	      document.getElementById('lesson-load-error-banner')?.classList.add('hidden');
  1145	      return 'ok';
  1146	    } catch (err) {
  1147	      console.error('❌ Could not load camp season / day-off camp data:', err);
  1148	      if (!isCurrent()) return 'stale';
  1149	      lessonDataLoadedSuccessfully = false;
  1150	      document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
  1151	      const delay = SUMMER_RELOAD_RETRY_DELAYS_MS[attempt];
  1152	      if (delay !== undefined) {
  1153	        setTimeout(() => {
  1154	          if (!isCurrent()) return; // a newer snapshot has taken over
  1155	          reloadSummer(myGeneration, snapshotCampSeasons(), attempt + 1).then(outcome => { if (outcome === 'ok' && callback) callback(currentLessonData); });
  1156	        }, delay);
  1157	      }
  1158	      return 'failed';
  1159	    }
  1160	  };
  1161	
  1162	  // The registry-change entry point: same reload, same generation gate, and it
  1163	  // renders through the same callback when it is still the current generation.
  1164	  summerReloadHook = async () => {
  1165	    const myGeneration = ++globalListenerGeneration;
  1166	    const outcome = await reloadSummer(myGeneration, snapshotCampSeasons(), 0);
  1167	    if (outcome !== 'stale' && callback) callback(currentLessonData);
  1168	    return outcome;
  1169	  };
  1170	
  1171	  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
  1172	    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
  1173	      // Skip cache-only updates
  1174	      if (doc.metadata.fromCache && !doc.metadata.hasPendingWrites) {
  1175	        console.log('📚 Skipping cache-only snapshot, waiting for server data...');
  1176	        return;
  1177	      }
  1178	      console.log('📚 Lesson data snapshot received, from cache:', doc.metadata.fromCache, 'exists:', doc.exists);
  1179	      if (!doc.exists) return;
  1180	
  1181	      const myGeneration = ++globalListenerGeneration;
  1182	      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
  1183	      // in their own collection, so carry their current maps across the swap
  1184	      // and let the reload below refresh each one (Phase 1, 1.4).
  1185	      const previousSummer = snapshotCampSeasons();
  1186	      currentLessonData = doc.data();
  1187	      for (const [semKey, map] of Object.entries(previousSummer)) currentLessonData[semKey] = map;
  1188	      console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
  1189	
  1190	      const outcome = await reloadSummer(myGeneration, previousSummer, 0);
  1191	      // A superseded reload renders nothing — the newer snapshot's own
  1192	      // callback already did (or will), with the same live object. A failed
  1193	      // one still renders: the non-summer semesters in this snapshot are new.
  1194	      if (outcome !== 'stale' && callback) callback(currentLessonData);
  1195	    });
  1196	}
  1197	
  1198	// ─── Cut Projects (curriculum/cutProjects) ───────────
  1199	
  1200	async function loadCutProjects() {
  1201	  if (!curriculumDb) initCurriculumFirestore();
  1202	  try {
  1203	    const doc = await curriculumDb.collection('curriculum').doc('cutProjects').get();
  1204	    currentCutProjects = doc.exists ? doc.data() : {};
  1205	  } catch (err) {
  1206	    console.error('Error loading cut projects:', err);
  1207	    currentCutProjects = {};
  1208	  }
  1209	  return currentCutProjects;
  1210	}
  1211	
  1212	async function saveCutProjects(semesterKey, projects) {
  1213	  if (!curriculumDb) initCurriculumFirestore();
  1214	  const user = getAuthUser();
  1215	  await curriculumDb.collection('curriculum').doc('cutProjects').set({
  1340	  const saved = snap.exists ? snap.data() : {};
  1341	  const failedFields = writtenContentFields.filter(f => !saved[f] || !String(saved[f]).trim());
  1342	  if (failedFields.length > 0) {
  1343	    console.error('⚠️ Save verification failed — these fields did not land:', failedFields);
  1344	    throw new Error(`Save may not have completed — please reload and check: ${failedFields.join(', ')}`);
  1345	  }
  1346	  console.log('✅ Save verified on server:', writtenContentFields);
  1347	}
  1348	
  1349	// fieldsToClear: field names the caller has determined should be explicitly
  1350	// removed rather than silently omitted — most commonly content fields
  1351	// INTENTIONALLY emptied (had text when the modal opened, empty now; see the
  1352	// two edit modals' open-state snapshots, teOriginalData/summerLessonOriginalData),
  1353	// but not restricted to CONTENT_FIELDS — any field name works (e.g.
  1354	// pasteFromCutBank()'s non-content qaThread/photoUrl/photoPath/planComplete/
  1355	// teacherNotes/adminResponse/status, which must be explicitly cleared on the
  1356	// DESTINATION rather than just omitted from the new lesson object, or a
  1357	// pre-existing stale value there would survive the paste untouched — omission
  1358	// only means "don't touch this field," never "clear it"). These get
  1359	// Firestore's FieldValue.delete() instead of silent omission, so a genuine
  1360	// clear actually persists (Data Safety Plan Stage 3). This list is
  1361	// authoritative: it overrides whatever (possibly stale) value lessonData
  1362	// happens to carry for that key, since callers may still send the pre-edit
  1363	// value alongside a separate clear signal (see saveLesson()'s contentUpdates).
  1364	async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
  1365	  if (lessonDataLoadedSuccessfully === false) {
  1366	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  1367	  }
  1368	  if (!curriculumDb) initCurriculumFirestore();
  1369	  const user = getAuthUser();
  1370	  lessonData.lastEditedBy = user?.name || 'Unknown';
  1371	  lessonData.lastEditedAt = new Date().toISOString();
  1372	
  1373	  // SDOC plans (Phase 2B) branch here — after the stamp, so every SDOC write
  1374	  // (the narrow Plan complete one included) carries lastEditedBy/At — and
  1375	  // BEFORE lessonStoreFor(), which keeps throwing for the type: its other six
  1376	  // callers fall through to curriculum/lessonData on anything that isn't
  1377	  // 'camp', and that throw is what keeps an SDOC key out of it.
  1378	  if (isDayOffYear(semesterKey)) return saveDayOffPlan(semesterKey, lessonKey, lessonData, fieldsToClear, opts.dayOffAuth);
  1379	
  1380	  console.log('💾 Attempting to save lesson:', { semesterKey, lessonKey, user: user?.email });
  1381	
  1382	  const hasContent = lessonHasContent(lessonData);
  1383	  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above.
  1384	  const fieldsToActuallyClear = [...fieldsToClear];
  1385	
  1386	  // Route by type, never by key (Phase 1, 1.1).
  1387	  if (lessonStoreFor(semesterKey) === 'camp') {
  1388	    // A planComplete-only payload, a photo-only payload, or a save that's only
  1389	    // clearing a field, is a legitimate narrow save, not a stale-state wipe
  1390	    // attempt — only block when there's neither real content nor an explicit
  1391	    // planComplete flag nor a photo field nor a field being intentionally
  1392	    // cleared (Data Safety Plan Stage 2C/3; photo fields added by the
  1393	    // backtracking audit's Phase 10, whose summer editor now sends only the
  1394	    // fields it changed — a photo replacement arrives with no text at all).
  1395	    const hasPhotoField = 'photoUrl' in lessonData || 'photoPath' in lessonData;
  1396	    if (!hasContent && !hasPhotoField && !('planComplete' in lessonData) && fieldsToActuallyClear.length === 0) {
  1397	      console.warn('⛔ saveSingleLesson blocked — all content fields empty, refusing to overwrite:', lessonKey);
  1398	      return;
  1399	    }
  1400	    // Strip empty content fields so stale in-memory empty strings never overwrite
  1401	    // real content that a teacher saved previously (mirrors saveSummerCampLessonData).
  1402	    const stripped = { ...lessonData };
  1403	    CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
  1404	    const cleanData = JSON.parse(JSON.stringify(stripped));
  1405	    // Apply clears AFTER the JSON sanitization pass — FieldValue.delete() is a
  1406	    // special sentinel object that a JSON round-trip would corrupt.
  1407	    fieldsToActuallyClear.forEach(f => { cleanData[f] = firebase.firestore.FieldValue.delete(); });
  1408	    // Every summer doc this app writes carries its season (camp seasons Phase
  1409	    // 0). A plain string, so it goes after the round-trip — and after the
  1410	    // clears, so no clear list can ever strip the stamp.
  1411	    cleanData.season = seasonForSemester(semesterKey);
  1412	    console.log('💾 Saving Summer Camp lesson to summerCamps_lessonData:', lessonKey);
  1413	    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semesterKey, lessonKey));
  1414	    await docRef.set(cleanData, { merge: true });
  1415	    console.log('✅ Saved Summer Camp lesson:', lessonKey);
  1416	
  1417	    // Read back the content fields we just wrote, forced to the server — this
  1418	    // is the check that would have caught both original May 2026 wipe
  1419	    // incidents within seconds instead of days (Data Safety Plan Stage 2E).
  1420	    // Intentionally cleared fields are expected to read back missing, so
  1421	    // they're excluded here rather than flagged as a failed write.
  1422	    const writtenContentFields = CONTENT_FIELDS.filter(f => f in cleanData && !fieldsToActuallyClear.includes(f));
  1423	    if (writtenContentFields.length > 0) {
  1424	      await verifySummerLessonWrite(docRef, writtenContentFields);
  1425	    }
  1426	    return;
  1427	  }
  1428	
  1429	  // Regular semester: curriculum/lessonData is one shared doc across every
  1430	  // semester. update() with a whole object assigned to the bare
  1431	  // semesterKey.lessonKey path replaces the ENTIRE lesson there — so write
  1432	  // explicit per-field dotted paths instead, touching only the fields
  1433	  // actually present in lessonData (Data Safety Plan Stage 2D).
  1434	  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear);
  1435	
  1436	  console.log('💾 Saving to curriculum/lessonData with per-field paths:', Object.keys(updates));
  1437	  try {
  1438	    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
  1439	    console.log('✅ Successfully saved lesson to Firestore!');
  1440	  } catch (error) {
  1441	    console.error('❌ Error saving lesson:', error);
  1442	    throw error;
  1443	  }
  1444	}
  1445	
  1446	// Backtracking audit, Phase 9: pure helper — computes the dotted-path update
  1447	// object for ONE lesson within the shared curriculum/lessonData document,
  1448	// given an already-finalized lessonData object. Extracted from
  1449	// saveSingleLesson()'s non-summer branch above so it can be reused by
  1450	// saveMultipleLessonFields() below without duplicating the stripping/clearing
  1451	// logic. Strips empty content fields the same way the summer branch does, by
  1452	// omitting their dotted path entirely — never sending an explicit empty
  1453	// string — and applies clears AFTER the JSON sanitization pass, since
  1454	// FieldValue.delete() is a special sentinel a JSON round-trip would corrupt.
  1455	function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = []) {
  1456	  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above saveSingleLesson().
  1457	  const stripped = { ...lessonData };
  1458	  CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
  1459	  const cleanData = JSON.parse(JSON.stringify(stripped));
  1460	  fieldsToClear.forEach(f => { cleanData[f] = firebase.firestore.FieldValue.delete(); });
  1461	  const updates = {};
  1462	  for (const [field, value] of Object.entries(cleanData)) {
  1463	    updates[`${semesterKey}.${lessonKey}.${field}`] = value;
  1464	  }
  1465	  return updates;
  1466	}
  1467	
  1468	// Backtracking audit, Phase 9: combine multiple lesson writes and/or
  1469	// whole-lesson deletes into ONE atomic Firestore .update() call — either
  1470	// every write/delete in the call lands, or none do. Closes the
  1471	// PARTIAL-FAILURE race that move/swap's prior sequential-writes design was
  1472	// vulnerable to (does NOT independently verify the given lessonData reflects
  1473	// current server state — see Phase 9's note in the plan for the deliberately
  1474	// deferred, separately-tracked stale-input race).
  1475	async function saveMultipleLessonFields(semesterKey, writes = [], deletes = []) {
  1476	  if (lessonDataLoadedSuccessfully === false) {
  1477	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  1478	  }
  1479	  if (lessonStoreFor(semesterKey) === 'camp') {
  1480	    // Camp-season lessons live in a separate per-lesson-document collection — no
  1481	    // single-document atomicity is available across lessons there. Not
  1482	    // reachable today (the admin grid's move/swap UI is gated away from
  1483	    // summer semesters), but this guard exists so a future caller can't
  1484	    // silently get a false sense of atomicity if that ever changes.
  1485	    throw new Error('saveMultipleLessonFields() does not support camp seasons — use saveSingleLesson() per lesson instead.');
  1486	  }
  1487	  if (!curriculumDb) initCurriculumFirestore();
  1488	  const user = getAuthUser();
  1489	  const combined = {};
  1490	  for (const { lessonKey, lessonData, fieldsToClear } of writes) {
  1491	    lessonData.lastEditedBy = user?.name || 'Unknown';
  1492	    lessonData.lastEditedAt = new Date().toISOString();
  1493	    Object.assign(combined, buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear || []));
  1494	  }
  1495	  for (const lessonKey of deletes) {
  1496	    combined[`${semesterKey}.${lessonKey}`] = firebase.firestore.FieldValue.delete();
  1497	  }
  1498	  combined.lastUpdated = new Date().toISOString();
  1499	  combined.lastUpdatedBy = user?.name || 'Unknown';
  1500	  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
  1501	}
  1502	
  1503	// ─── Photo Upload (Firebase Storage) ─────────────────
  1504	
  1505	function getFirebaseStorage() {
  1506	  // Single init path: initFirebaseApp() (js/firebase-config.js) is the one
  1507	  // place that knows whether this page is in emulator mode, so a bare
  1508	  // initializeApp(FIREBASE_CONFIG) here could point Storage at production
  1509	  // while Firestore sits on the emulator.
  1510	  initFirebaseApp();
  1511	  return firebase.storage();
  1512	}
  1513	
  1514	// Backtracking audit, Phase 5 (R3-5, R3-6, R4-7): every upload gets a path
  1515	// that is unique PER UPLOAD, not per lesson. With a deterministic path the
  1516	// replacement upload overwrote the live object before Firestore confirmed
  1517	// the save (a failed save then pointed at a photo that no longer existed),
  1518	// a swap could put one lesson's replacement on top of the other lesson's
  1519	// still-referenced object, and the summer modal's "delete the old path"
  1520	// step deleted the object it had just uploaded. Callers keep the OLD path,
  1521	// save, then delete it only after a confirmed save (see saveTeacherEdit(),
  1522	// saveAdminEdit(), and the summer modal's saveLesson()). Date.now() alone is
  1523	// millisecond resolution — the random suffix keeps two near-simultaneous
  1524	// uploads for the same lesson apart.
  1525	function uniquePhotoSuffix() {
  1526	  return `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
  1527	}
  1528	
  1529	function getPhotoPath(semesterKey, lessonKey /* filename: ignored — resizeImage() always re-encodes to JPEG */) {
  1530	  // Store at curriculum/{semester}/{lessonKey}/demo-{unique}.jpg
  1531	  return `curriculum/${semesterKey}/${lessonKey}/demo-${uniquePhotoSuffix()}.jpg`;
  1532	}
  1533	
  1534	async function uploadLessonPhoto(semesterKey, lessonKey, file) {
  1535	  if (typeof firebase.storage !== 'function') {
  3400	    projectTitle: document.getElementById('te-projectTitle')?.value?.trim() || '',
  3401	    shortDetails: document.getElementById('te-shortDetails')?.value?.trim() || '',
  3402	    inspoLink: document.getElementById('te-inspoLink')?.value?.trim() || '',
  3403	    introPitch: document.getElementById('te-introPitch')?.value?.trim() || '',
  3404	    processStep1: document.getElementById('te-processStep1')?.value?.trim() || '',
  3405	    processStep2: document.getElementById('te-processStep2')?.value?.trim() || '',
  3406	    processStep3: document.getElementById('te-processStep3')?.value?.trim() || '',
  3407	    processStep4: document.getElementById('te-processStep4')?.value?.trim() || '',
  3408	    closure: document.getElementById('te-closure')?.value?.trim() || '',
  3409	    materials,
  3410	    materialsList,
  3411	    dayOfMaterials: document.getElementById('te-dayOfMaterials')?.value?.trim() || '',
  3412	    planComplete: document.getElementById('te-planComplete')?.checked || false
  3413	  };
  3414	}
  3415	
  3416	// teOriginalData is already stored pre-normalized (see the snapshot built after
  3417	// save, below) — only raw form data read fresh from the DOM needs normalizing.
  3418	function normalizeTeFormValue(key, rawFormData) {
  3419	  return key === 'materialsList' ? JSON.stringify(rawFormData[key] || [])
  3420	       : key === 'planComplete' ? String(!!rawFormData[key])
  3421	       : (rawFormData[key] || '');
  3422	}
  3423	
  3424	function isTeEditDirty() {
  3425	  if (!teOriginalData) return false;
  3426	  const current = getTeEditFormData();
  3427	  return Object.keys(teOriginalData).some(key =>
  3428	    normalizeTeFormValue(key, current) !== (teOriginalData[key] || '')
  3429	  );
  3430	}
  3431	
  3432	function getTeChangedFields() {
  3433	  if (!teOriginalData) return [];
  3434	  const current = getTeEditFormData();
  3435	  return Object.keys(teOriginalData).filter(key =>
  3436	    normalizeTeFormValue(key, current) !== (teOriginalData[key] || '')
  3437	  );
  3438	}
  3439	
  3440	async function saveTeacherEdit(lessonKey, originalLesson) {
  3441	  const saveBtn = document.getElementById('te-save-btn');
  3442	  const autoSaveStatus = document.getElementById('te-autosave-status');
  3443	  const formData = getTeEditFormData();
  3444	  const changedFields = getTeChangedFields();
  3445	  const photoInput = document.getElementById('te-photo-input');
  3446	  const hasNewPhoto = photoInput?.files?.length > 0;
  3447	  const pendingRemove = photoInput?.dataset?.pendingRemove === 'true';
  3448	
  3449	  if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) {
  3450	    // Nothing to save — flash the button briefly
  3451	    if (saveBtn) { saveBtn.textContent = 'Saved!'; saveBtn.disabled = true; }
  3452	    setTimeout(() => { if (saveBtn) { saveBtn.textContent = 'Save'; saveBtn.disabled = false; } }, 1500);
  3453	    return;
  3454	  }
  3455	
  3456	  if (saveBtn) { saveBtn.disabled = true; saveBtn.textContent = 'Saving...'; }
  3457	  if (autoSaveStatus) autoSaveStatus.textContent = 'Saving...';
  3458	
  3459	  try {
  3460	    const semKey = getTvSemKey();
  3461	
  3462	    // Build updated lesson (preserve all original fields, override edited ones)
  3463	    const updatedLesson = { ...originalLesson, ...formData };
  3464	
  3465	    // Backtracking audit, Phase 8 (R4-2): capture the OLD photoPath before any
  3466	    // mutation, so the delete-after-save step below has the right value to
  3467	    // compare against.
  3468	    const oldPhotoPath = originalLesson.photoPath || null;
  3469	    const uploadedFile = hasNewPhoto ? photoInput.files[0] : null;
  3470	
  3471	    // Handle photo upload
  3472	    let photoUrl = null, photoPath = null;
  3473	    if (hasNewPhoto) {
  3474	      if (saveBtn) saveBtn.textContent = 'Uploading photo...';
  3475	      if (autoSaveStatus) autoSaveStatus.textContent = 'Uploading photo...';
  3476	      const result = await uploadLessonPhoto(semKey, lessonKey, photoInput.files[0]);
  3477	      // Backtracking audit, Phase 8 (R4-2): delete moved to AFTER the save
  3478	      // below — no longer here, immediately after upload.
  3479	      photoUrl = result.url;
  3480	      photoPath = result.path;
  3481	      updatedLesson.photoUrl = photoUrl;
  3482	      updatedLesson.photoPath = photoPath;
  3483	      if (!changedFields.includes('photo')) changedFields.push('photo');
  3484	      if (saveBtn) saveBtn.textContent = 'Saving...';
  3485	      if (autoSaveStatus) autoSaveStatus.textContent = 'Saving...';
  3486	    } else if (pendingRemove && originalLesson.photoUrl) {
  3487	      // Backtracking audit, Phase 8 (R4-2): delete moved to AFTER the save
  3488	      // below — no longer here.
  3489	      photoUrl = '';
  3490	      photoPath = '';
  3491	      updatedLesson.photoUrl = '';
  3492	      updatedLesson.photoPath = '';
  3493	      if (!changedFields.includes('photo')) changedFields.push('photo');
  3494	    }
  3495	
  3496	    // A content field that had text when the modal opened (or last saved) and
  3497	    // is now empty is an intentional clear — saveSingleLesson needs this list
  3498	    // explicitly to use FieldValue.delete() instead of silently omitting the
  3499	    // field, which would leave the old content in Firestore untouched
  3500	    // (Data Safety Plan Stage 3).
  3501	    const fieldsToClear = CONTENT_FIELDS.filter(f =>
  3502	      (teOriginalData?.[f] || '').trim() !== '' && !(formData[f] || '').trim()
  3503	    );
  3504	
  3505	    // Save using granular single-lesson write. This already includes
  3506	    // photoUrl/photoPath via updatedLesson (they're not in CONTENT_FIELDS, so
  3507	    // saveSingleLesson's per-field dotted-path write always writes them
  3508	    // through, even empty) — backtracking audit, Phase 8 (R3-8): the separate
  3509	    // photo-fields write that used to follow this call was vestigial, removed
  3510	    // entirely.
  3511	    // Backtracking audit Phase 10: the Q&A fields are written only by the
  3512	    // atomic arrayUnion() senders — this form never edits them, and writing
  3513	    // the cached array back whole would delete any message another client
  3514	    // appended since this cache copy was taken. They stay on updatedLesson
  3515	    // (the cache copy below) and are left out of the WRITE only.
  3516	    const writePayload = { ...updatedLesson };
  3517	    delete writePayload.qaThread;
  3518	    delete writePayload.teacherNotes;
  3519	    delete writePayload.adminResponse;
  3520	    await saveSingleLesson(semKey, lessonKey, writePayload, fieldsToClear);
  3521	    // saveSingleLesson() stamps lastEditedBy/At onto the object it is given.
  3522	    updatedLesson.lastEditedBy = writePayload.lastEditedBy;
  3523	    updatedLesson.lastEditedAt = writePayload.lastEditedAt;
  3524	
  3525	    // Backtracking audit, Phase 8 (R4-2): only delete the OLD photo once
  3526	    // Firestore has confirmed the new reference — and only if it's actually
  3527	    // different from the new one.
  3528	    if (oldPhotoPath && oldPhotoPath !== (updatedLesson.photoPath || null)) {
  3529	      try {
  3530	        await deleteLessonPhoto(oldPhotoPath);
  3531	      } catch (cleanupErr) {
  3532	        console.error('⚠️ Could not clean up old photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
  3533	      }
  3534	    }
  3535	
  3536	    // Backtracking audit, Phase 5: the photo change is persisted — clear the
  3537	    // pending selection so this modal's autosave doesn't re-upload the same
  3538	    // file to another unique path on the next pause in typing. Success path
  3539	    // only, so a failed save keeps the selection for the retry.
  3540	    if (hasNewPhoto && photoInput?.files?.[0] === uploadedFile) photoInput.value = '';
  3541	    if (pendingRemove && photoInput) photoInput.dataset.pendingRemove = '';
  3542	
  3543	    // Update local data immediately (don't wait for Firestore listener)
  3544	    if (currentLessonData[semKey]) {
  3545	      currentLessonData[semKey][lessonKey] = updatedLesson;
  3546	    }
  3547	
  3548	    // Backtracking audit, Phase 8 (R1-17/R2-11): log only after persistence is
  3549	    // confirmed, with its own non-blocking catch — a log-only failure here
  3550	    // must not be reported to the teacher as "Save failed" when the save
  3551	    // itself already succeeded. Before/after char counts per field so a
  3552	    // large-content wipe is flagged automatically (Data Safety Plan Stage 4C).
  3553	    // 'photo' isn't a text field — teOriginalData/formData have no counterpart
  3554	    // for it, so it carries no char counts and is never flagged as a wipe.
  3555	    try {
  3556	      const changedFieldEntries = changedFields.map(field => {
  3557	        if (field === 'photo') return { field, before: null, after: null, potentialWipe: false };
  3558	        const before = (teOriginalData[field] || '').length;
  3559	        const after = normalizeTeFormValue(field, formData).length;
  3560	        return { field, before, after, potentialWipe: after === 0 && before > 50 };
  3561	      });
  3562	      await logTeacherEdit(semKey, lessonKey, originalLesson, changedFieldEntries);
  3563	    } catch (logErr) {
  3564	      console.error('⚠️ Lesson saved, but Change History logging failed:', logErr);
  3565	    }
  3566	
  3567	    // Show success — stay open, reset dirty state
  3568	    if (saveBtn) { saveBtn.textContent = 'Saved!'; }
  3569	    if (autoSaveStatus) {
  3570	      autoSaveStatus.textContent = fieldsToClear.length > 0
  3571	        ? `✓ Saved (${fieldsToClear.join(', ')} cleared)`
  3572	        : '✓ Saved';
  3573	    }
  3574	
  3575	    // Reset dirty baseline so closing won't prompt "unsaved changes"
  3576	    const snapshot = getTeEditFormData();
  3577	    teOriginalData = {
  3578	      projectTitle: snapshot.projectTitle,
  3579	      shortDetails: snapshot.shortDetails,
  3580	      inspoLink: snapshot.inspoLink,
  3581	      introPitch: snapshot.introPitch,
  3582	      processStep1: snapshot.processStep1,
  3583	      processStep2: snapshot.processStep2,
  3584	      processStep3: snapshot.processStep3,
  3585	      processStep4: snapshot.processStep4,
  3586	      closure: snapshot.closure,
  3587	      materials: snapshot.materials,
  3588	      dayOfMaterials: snapshot.dayOfMaterials,
  3589	      materialsList: JSON.stringify(snapshot.materialsList || []),
  3590	      planComplete: snapshot.planComplete ? 'true' : 'false'
  3591	    };
  3592	
  3593	    setTimeout(() => {
  3594	      if (saveBtn) { saveBtn.textContent = 'Save'; saveBtn.disabled = false; }
  3595	      if (autoSaveStatus) autoSaveStatus.textContent = '';
  3596	    }, 1500);
  3597	  } catch (err) {
  3598	    console.error('Error saving lesson:', err);
  3599	    if (saveBtn) { saveBtn.disabled = false; saveBtn.textContent = 'Save'; }
  3600	    if (autoSaveStatus) { autoSaveStatus.textContent = '⚠️ Save failed'; autoSaveStatus.style.color = 'var(--error)'; }
  3601	  }
  3602	}
  3603	
  3604	// Backtracking audit Phase 10 (R3-3, R4-5): this used to rebuild the whole
  3605	// Q&A thread from the modal's lesson object and hand the ENTIRE lesson to
  3606	// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
  3607	// silently dropped any message (or any other field) another client had
  3608	// landed since this modal opened. Now a single targeted .update() touching
  3609	// only this lesson's own Q&A paths, with arrayUnion() for the thread — the
  3610	// same atomic-append design sendHelpResponse()/sendQaReply() already use —
  3611	// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
  3612	// record. `modalSemKey` is the semester the modal was opened under: the
  3613	// global selector can change while the modal stays open, and a dotted-path
  3614	// update under the wrong semester would create a Q&A-only ghost lesson there.
  3615	async function sendTeacherQaMessage(lessonKey, modalSemKey) {
  3616	  const input = document.getElementById('te-qa-input');
  3617	  if (!input) return;
  3618	  const message = input.value.trim();
  3619	  if (!message) return;
  3620	  // Same load-guard saveSingleLesson() enforced on the old path — after a
  3621	  // failed load the cache is empty, so the legacy-thread migration below
  3622	  // would run blind against whatever is really on the server.
  3623	  if (lessonDataLoadedSuccessfully === false) {
  3624	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  3625	    return;
  3626	  }
  3627	
  3628	  const semKey = modalSemKey || getTvSemKey();
  3629	  // This modal never hosts a camp season (the Today View routes those to the
  3630	  // summer editor, whose Q&A lives in summerCamps_prepHelpQueue), so a write
  3631	  // under that key into curriculum/lessonData is never right. Routed by TYPE
  3632	  // now (Phase 1, 1.1) — a third type is refused out loud rather than written
  3633	  // into the shared weekly document.
  3634	  let lessonStore;
  3635	  try {
  3636	    lessonStore = lessonStoreFor(semKey);
  3637	  } catch (err) {
  3638	    alert(err.message);
  3639	    return;
  3640	  }
  3641	  if (lessonStore === 'camp') {
  3642	    alert('Summer camp questions are sent from the camp lesson editor.');
  3643	    return;
  3644	  }
  3645	
  3646	  // Confirm the lesson still exists on the server (an admin may have moved or
  3647	  // deleted it since this modal opened). A dotted-path update would otherwise
  3648	  // recreate the old key as a Q&A-only ghost lesson. Same forced read and
  3649	  // accepted check-to-write residual as sendHelpResponse()/sendQaReply().
  3650	  let check;
  3651	  try {
  3652	    check = await adminLessonStillExistsWithRetry(semKey, lessonKey);
  3653	  } catch (err) {
  3654	    console.warn('⚠️ Existence check retry also failed:', err);
  3655	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  3656	    return;
  3657	  }
  3658	  if (!check.exists) {
  3659	    alert('This lesson was moved or removed elsewhere. Your message was not sent — please close this and check the classbook for its new location.');
  3660	    return;
  3661	  }
  3662	  const existing = check.data;
  3663	
  3664	  const user = getAuthUser();
  3665	  const isAdmin = ['admin', 'manager'].includes(user?.role);
  3666	  const newEntry = {
  3667	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  3668	    from: isAdmin ? 'admin' : 'teacher',
  3669	    name: user?.name || 'Unknown',
  3670	    message,
  3671	    timestamp: new Date().toISOString()
  3672	  };
  3673	  // The fresh server copy decides whether a legacy teacherNotes/adminResponse
  3674	  // thread still needs migrating into qaThread on this lesson's first entry.
  3675	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  3676	  const editedAt = new Date().toISOString();
  3677	  const editedBy = user?.name || 'Unknown';
  3678	
  3679	  const updates = {
  3680	    [`${semKey}.${lessonKey}.qaThread`]: firebase.firestore.FieldValue.arrayUnion(...entriesToAdd),
  3681	    [`${semKey}.${lessonKey}.lastEditedBy`]: editedBy,
  3682	    [`${semKey}.${lessonKey}.lastEditedAt`]: editedAt,
  3683	  };
  3684	  // Legacy mirror fields, kept for compatibility with older readers.
  3685	  const legacyField = isAdmin ? 'adminResponse' : 'teacherNotes';
  3686	  updates[`${semKey}.${lessonKey}.${legacyField}`] = message;
  3687	
  3688	  try {
  3689	    if (!curriculumDb) initCurriculumFirestore();
  3690	    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
  3691	  } catch (err) {
  3692	    console.error('Error sending Q&A message:', err);
  3693	    alert('Error sending message: ' + err.message);
  3694	    return;
  3695	  }
  3696	
  3697	  // Confirmed — make sure the local cache shows the new message before the
  3698	  // live listener catches up. Usually the listener already HAS: a local
  3699	  // write triggers a latency-compensated snapshot (with the arrayUnion
  3700	  // applied) before the server ack resolves the await above, so the entry
  3701	  // is deduplicated by id rather than appended blindly — a duplicate here
  3702	  // would be persisted by the next autosave, which writes the cached
  3703	  // qaThread back as a whole array.
  3704	  if (currentLessonData?.[semKey]?.[lessonKey]) {
  3705	    const cached = currentLessonData[semKey][lessonKey];
  3706	    const baseThread = cached.qaThread && cached.qaThread.length > 0 ? cached.qaThread : getQaThread(cached);
  3707	    const alreadyThere = baseThread.some(m => m.id === newEntry.id);
  3708	    currentLessonData[semKey][lessonKey] = {
  3709	      ...cached,
  3710	      qaThread: alreadyThere ? baseThread : [...baseThread, newEntry],
  3711	      [legacyField]: message,
  3712	      lastEditedBy: editedBy,
  3713	      lastEditedAt: editedAt,
  3714	    };
  3715	  }
  3716	  input.value = '';
  3717	  // Re-open the modal to show the updated thread — only if the Today View is
  3718	  // still on this modal's semester; otherwise it would open a different
  3719	  // semester's lesson under the same key.
  3720	  if (getTvSemKey() === semKey) openTeacherEditModal(lessonKey);
  3721	}
  3722	
  3723	// ─── Q&A Reply Notification Banner ───────────────
  3724	
  3725	// The read-mark carries the semester (Phase 1, 1.4): two camp seasons share
  3726	// lesson keys, so a bare key would mark 2027's reply read because the
  3727	// identically-keyed 2026 one was opened.
  3728	function qaReadMarkKey(lessonKey) { return `qaLastRead_${getTvSemKey()}_${lessonKey}`; }
  3729	// Marks written before Phase 1 had no semester in the key. Reading through
  3730	// this keeps them valid — otherwise every teacher would see unread badges at
  3731	// deploy for replies they had already read, in weekly semesters too.
  3732	function readQaReadMark(lessonKey) {
  3733	  const own = localStorage.getItem(qaReadMarkKey(lessonKey));
  3734	  if (own !== null) return own;
  3735	  // Fall back to a pre-Phase-1 bare mark only where one could legitimately
  3736	  // belong: any weekly semester, or Summer 2026 — the only camp season that
  3737	  // existed before this phase. Honouring it for a LATER camp season would
  3738	  // reopen exactly the cross-season collision the semester prefix closes,
  3739	  // because a repeated camp has an identical lesson key in both years.
  3740	  const semKey = getTvSemKey();
  4500	  // Populate "copy from" dropdown in new semester modal
  4501	  const copyFrom = document.getElementById('new-sem-copy-from');
  4502	  if (copyFrom) {
  4503	    let copyHtml = '<option value="">Start blank (no classes)</option>';
  4504	    for (const key of keys.filter(k => !isDayOffYear(k))) {
  4505	      copyHtml += `<option value="${escAttr(key)}">${escHtml(semesters[key].name)}</option>`;
  4506	    }
  4507	    copyFrom.innerHTML = copyHtml;
  4508	  }
  4509	
  4510	  // Publish toggle for current semester
  4511	  const sem = semesters[currentKey];
  4512	  if (sem) {
  4513	    const isPublished = sem.published !== false;
  4514	    const isActive = currentKey === currentConfig.activeSemester;
  4515	    publishGroup.innerHTML = `
  4516	      ${isActive ? '<span class="ca-sem-active-badge">Active Semester</span>' : ''}
  4517	      ${!isActive ? `<label class="ca-publish-toggle">
  4518	        <input type="checkbox" ${isPublished ? 'checked' : ''} onchange="toggleSemesterPublish('${escAttr(currentKey)}', this.checked)">
  4519	        Published (visible to teachers)
  4520	      </label>` : ''}
  4521	      ${!isPublished && !isActive ? '<span class="ca-sem-unpublished-badge">Draft</span>' : ''}
  4522	      ${!isActive ? `<button class="btn-text ca-delete-sem-btn" onclick="deleteSemester('${escAttr(currentKey)}')" title="Delete this semester">&#128465; Delete</button>` : ''}
  4523	    `;
  4524	  }
  4525	}
  4526	
  4527	async function deleteSemester(key) {
  4528	  const sem = currentConfig?.semesters?.[key];
  4529	  if (!sem) return;
  4530	  if (key === currentConfig.activeSemester) {
  4531	    alert('Cannot delete the active semester.');
  4532	    return;
  4533	  }
  4534	  // Removing a CAMP season from the Classbook removes only this app's entry
  4535	  // for it. Its camps, schedule, plans and photos belong to the Summer Camp
  4536	  // App and stay exactly where they are — adding the season back from the
  4537	  // registry restores the whole view (Phase 1, 1.7). This supersedes the
  4538	  // companion plan's summer-delete design, which predates seasons.
  4539	  // An SDOC year: refused while any event exists (a forced-server count);
  4540	  // otherwise only its appData entry goes — it has nothing in
  4541	  // curriculum/lessonData, and no collection is ever cleared from here.
  4542	  if (isDayOffYear(key)) {
  4543	    let events;
  4544	    try { events = await countDayOffEvents(key); }
  4545	    catch (err) { alert(`Could not check "${sem.name}" for events: ${err.message}\n\nNothing was changed.`); return; }
  4546	    if (events > 0) { alert(`"${sem.name}" still has ${events} event${events === 1 ? '' : 's'}. Remove its events first.`); return; }
  4547	  }
  4548	  const isCamp = isCampSeason(key);
  4549	  const isDayOff = isDayOffYear(key);
  4550	  const firstConfirm = isDayOff
  4551	    ? `Delete the school year "${sem.name}"? It has no events, so only the year itself is removed.`
  4552	    : isCamp
  4553	    ? `Remove "${sem.name}" from the Classbook?\n\nThis only removes it here. Every camp, schedule, lesson plan and photo stays in the Summer Camp App, and you can add the season back at any time from + New Semester.`
  4554	    : `Delete semester "${sem.name}"? This will remove all its lesson data, cut bank, and change history. This cannot be undone.`;
  4555	  if (!confirm(firstConfirm)) return;
  4556	  if (!isCamp && !isDayOff && !confirm(`Are you sure? Type OK in your head and click OK to confirm.`)) return;
  4557	
  4558	  // Remove the semester's own entry and nothing else (Phase 1, 1.2). Revert
  4559	  // this tab if the write is refused, or the config would be missing a
  4560	  // semester the server still has — with no alert and no re-render to show it
  4561	  // (Phase 1 review).
  4562	  const removed = currentConfig.semesters[key];
  4563	  delete currentConfig.semesters[key];
  4564	  try {
  4565	    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
  4566	  } catch (err) {
  4567	    currentConfig.semesters[key] = removed;
  4568	    console.error('❌ Could not remove the semester:', err);
  4569	    alert(`Could not remove "${sem.name}": ${err.message}\n\nNothing was changed.`);
  4570	    renderSemesterSelector();
  4571	    return;
  4572	  }
  4573	
  4574	  // Drop this season's in-memory map either way…
  4575	  if (currentLessonData?.[key]) {
  4576	    delete currentLessonData[key];
  4577	  }
  4578	  // …but only a WEEKLY semester has lessons of its own inside
  4579	  // curriculum/lessonData to delete. A camp season's lessons live in the
  4580	  // shared summerCamps_* collections and are never touched from here.
  4581	  if (isDayOff) {
  4582	    delete currentDayOffEvents[key]; delete currentDayOffCamps[key]; delete currentDayOffPlans[key]; delete currentDayOffSignoffs[key];
  4583	  } else if (!isCamp) {
  4584	    try {
  4585	      await deleteLessonData(key);
  4586	    } catch (e) { console.warn('Could not delete lesson data for', key, e); }
  4587	  }
  4588	
  4589	  // Switch to active semester
  4590	  caCurrentSemester = currentConfig.activeSemester;
  4591	  renderSemesterSelector();
  4592	  renderAdminGrid();
  4593	  renderHelpQueue();
  4594	  renderCutBank();
  4595	  renderIdeaBank();
  4596	  renderChangeHistory();
  4597	}
  4598	
  4599	function switchAdminSemester(key) {
  4600	  // Delegates to global semester — CA always stays in sync with the header selector
  4601	  setGlobalSemester(key);
  4602	}
  4603	
  4604	async function toggleSemesterPublish(key, published) {
  4605	  if (!currentConfig?.semesters?.[key]) return;
  4606	  if (!isPublishableType(key)) { alert('This semester type can\'t be published.'); return; }
  4607	  // SDOC (Phase 2B): publishing shows the year to every teacher on a camp —
  4608	  // say so first if some camps have nobody to see them.
  4609	  if (published && isDayOffYear(key)) {
  4610	    // The camp list below must be real to warn from — never publish on a failed load.
  4611	    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
  4612	    const bare = (currentDayOffCamps[key] || []).filter(c => !(c.teachers || []).length).length;
  4613	    if (bare && !confirm(`${bare} camp${bare === 1 ? ' has' : 's have'} no teacher yet — publish anyway?`)) { renderSemesterSelector(); return; }
  4614	  }
  4615	  const hadPublished = 'published' in currentConfig.semesters[key];
  4616	  const previous = currentConfig.semesters[key].published;
  4617	  currentConfig.semesters[key].published = published;
  4618	  try {
  4619	    await updateAppData({ [`semesters.${key}.published`]: published });
  4620	  } catch (err) {
  4621	    // Restore exactly what was there — including "the field was absent".
  4622	    if (currentConfig.semesters[key]) {
  4623	      if (hadPublished) currentConfig.semesters[key].published = previous;
  4624	      else delete currentConfig.semesters[key].published;
  4625	    }
  4626	    console.error('❌ Could not change the publish state:', err);
  4627	    alert(`Could not ${published ? 'publish' : 'unpublish'} that semester: ${err.message}\n\nNothing was changed.`);
  4628	  }
  4629	  renderSemesterSelector();
  4630	}
  4631	
  4632	// Which types may be published to teachers. SDOC years joined in Phase 2B,
  4633	// when teachers got their day-off plans to build.
  4634	const PUBLISHABLE_SEMESTER_TYPES = new Set([SEMESTER_TYPES.weekly, SEMESTER_TYPES.camp, SEMESTER_TYPES.dayOff]);
  4635	function isPublishableType(semKey) { return PUBLISHABLE_SEMESTER_TYPES.has(semesterTypeOf(semKey)); }
  4636	
  4637	function openNewSemesterModal() {
  4638	  document.getElementById('ca-new-semester-modal')?.classList.add('open');
  4639	  // Reset to the default type each time, then load the seasons on offer.
  4640	  const weeklyRadio = document.querySelector('input[name="new-sem-type"][value="weekly"]');
  4641	  if (weeklyRadio) weeklyRadio.checked = true;
  4642	  onNewSemesterTypeChange();
  4643	  populateNewSemesterSeasons();
  4644	  document.getElementById('new-sem-name')?.focus();
  4645	}
  4646	
  4647	function selectedNewSemesterType() {
  4648	  return document.querySelector('input[name="new-sem-type"]:checked')?.value || SEMESTER_TYPES.weekly;
  4649	}
  4650	
  4651	function onNewSemesterTypeChange() {
  4652	  const type = selectedNewSemesterType();
  4653	  const weekly = document.getElementById('new-sem-weekly-fields');
  4654	  const camp = document.getElementById('new-sem-camp-fields');
  4655	  const dayOff = document.getElementById('new-sem-dayoff-fields');
  4656	  if (weekly) weekly.hidden = type !== SEMESTER_TYPES.weekly;
  4657	  if (camp) camp.hidden = type !== SEMESTER_TYPES.camp;
  4658	  if (dayOff) {
  4659	    dayOff.hidden = type !== SEMESTER_TYPES.dayOff;
  4660	    if (type === SEMESTER_TYPES.dayOff) resetDayOffYearFields();
  4661	  }
  4662	}
  4663	
  4664	// Defaults: Aug 1 of this year → May 31 of the next; name follows the dates
  4665	// until the admin types their own.
  4666	function resetDayOffYearFields() {
  4667	  const y = new Date().getFullYear();
  4668	  const start = document.getElementById('new-sem-dayoff-start');
  4669	  const end = document.getElementById('new-sem-dayoff-end');
  4670	  const name = document.getElementById('new-sem-dayoff-name');
  4671	  if (start) start.value = `${y}-08-01`;
  4672	  if (end) end.value = `${y + 1}-05-31`;
  4673	  if (name) delete name.dataset.edited;
  4674	  onDayOffYearDatesChange();
  4675	}
  4676	
  4677	function onDayOffYearDatesChange() {
  4678	  const name = document.getElementById('new-sem-dayoff-name');
  4679	  if (!name || name.dataset.edited) return;
  4680	  const start = document.getElementById('new-sem-dayoff-start')?.value || '';
  4681	  const end = document.getElementById('new-sem-dayoff-end')?.value || '';
  4682	  name.value = start && end ? dayOffYearLabels(start, end).name : '';
  4683	}
  4684	
  4685	// An SDOC school year: one appData entry through the field-path writer, after
  4686	// a forced-server absence check. No roster, no lesson slots, no
  4687	// curriculum/lessonData write.
  4688	async function createDayOffYear() {
  4689	  const startDate = document.getElementById('new-sem-dayoff-start')?.value || '';
  4690	  const endDate = document.getElementById('new-sem-dayoff-end')?.value || '';
  4691	  const name = document.getElementById('new-sem-dayoff-name')?.value.trim() || '';
  4692	  if (!isIsoDate(startDate) || !isIsoDate(endDate)) { alert('Pick the school year\'s start and end dates.'); return; }
  4693	  if (endDate <= startDate) { alert('The school year has to end after it starts.'); return; }
  4694	  if (!name) { alert('Give the school year a name.'); return; }
  4695	  const { key } = dayOffYearLabels(startDate, endDate);
  4696	  if (currentConfig.semesters?.[key]) { alert(`${currentConfig.semesters[key].name} already exists (${key}).`); return; }
  4697	
  4698	  creatingSemester = true;
  4699	  try {
  4700	    const serverConfig = await readAppDataFromServer();
  4701	    if (serverConfig?.semesters?.[key]) {
  4702	      alert(`A school year with key "${key}" was already created (in another tab, or by another admin). Reload to see it.`);
  4703	      creatingSemester = false;
  4704	      return;
  4705	    }
  4706	    const newSem = { name, semesterType: SEMESTER_TYPES.dayOff, startDate, endDate, published: false, teacherNames: [] };
  4707	    await updateAppData({ [`semesters.${key}`]: newSem });
  4708	    currentConfig.semesters[key] = newSem;
  4709	  } catch (err) {
  4710	    console.error('❌ Could not create the school year:', err);
  4711	    alert(`Could not create that school year: ${err.message}`);
  4712	    creatingSemester = false;
  4713	    return;
  4714	  }
  4715	  // The write landed — anything failing from here is display only.
  4716	  try {
  4717	    currentDayOffEvents[key] = [];
  4718	    currentDayOffCamps[key] = [];
  4719	    currentDayOffPlans[key] = {};
  4720	    currentDayOffSignoffs[key] = {};
  4721	    if (currentLessonData) currentLessonData[key] = {};
  4722	    closeNewSemesterModal();
  4723	    renderSemesterSelector();
  4724	    initGlobalSemesterSelector();
  4725	    alert(`${name} created. It stays hidden from teachers. Next: add its teacher names in Settings, then its day-off dates and camps in Curriculum Admin.`);
  4726	  } catch (err) {
  4727	    console.error('School year created, but the page did not refresh:', err);
  4728	    alert(`${name} was created, but the page didn't refresh properly — reload to see it.`);
  4729	  } finally {
  4730	    creatingSemester = false;
  4731	  }
  4732	}
  4733	
  4734	// The Camp season option offers exactly the registry seasons that do not
  4735	// already have a semester here. In legacy mode there is no registry to read,
  4736	// and with nothing left to add there is nothing to choose — either way the
  4737	// option is disabled with the reason shown, never silently empty (1.6).
  4738	async function populateNewSemesterSeasons() {
  4739	  const select = document.getElementById('new-sem-season');
  4740	  const campRadio = document.getElementById('new-sem-type-camp');
  4741	  const note = document.getElementById('new-sem-camp-unavailable');
  4742	  if (!select || !campRadio || !note) return;
  4743	  const disable = (reason) => {
  4744	    campRadio.disabled = true;
  4745	    note.textContent = reason;
  4746	    note.hidden = false;
  4747	    select.innerHTML = '';
  4748	  };
  4749	  const mode = getSeasonRegistryMode();
  4750	  if (mode === 'legacy') return disable('Camp seasons need the Summer Camp App to set up its seasons first — none exist yet.');
  4751	  if (mode !== 'filtered') return disable("Can't read the season registry right now, so a camp season can't be added.");
  4752	  try {
  4753	    const registered = await listRegisteredSeasons();
  4754	    // A season is "taken" by a stored `season` OR by the key it would be
  4755	    // created under. The key check matters before the type migration has run:
  4756	    // summer-2026 carries no `season` field yet, and matching on that alone
  4757	    // would offer 2026 again and create a duplicate semester.
  4758	    const semesters = currentConfig?.semesters || {};
  4759	    const taken = new Set(Object.values(semesters).map(sem => sem?.season).filter(Boolean));
  4760	    const available = registered.filter(r => !taken.has(r.season) && !semesters[`summer-${r.season}`]);
  4761	    if (available.length === 0) {
  4762	      return disable(registered.length === 0
  4763	        ? 'The Summer Camp App has not created any seasons yet.'
  4764	        : 'Every season the Summer Camp App has created is already in the Classbook.');
  4765	    }
  4766	    campRadio.disabled = false;
  4767	    note.hidden = true;
  4768	    select.innerHTML = available.map(r => {
  4769	      const range = r.startDate && r.endDate ? ` (${formatSeasonDate(r.startDate)} – ${formatSeasonDate(r.endDate)})` : '';
  4770	      return `<option value="${escAttr(r.season)}">${escHtml(r.name || `Summer ${r.season}`)}${escHtml(range)}</option>`;
  4771	    }).join('');
  4772	    newSemesterSeasonsByYear = Object.fromEntries(available.map(r => [r.season, r]));
  4773	  } catch (err) {
  4774	    console.error('Could not list the registry seasons:', err);
  4775	    disable("Couldn't read the season registry, so a camp season can't be added right now.");
  4776	  }
  4777	}
  4778	
  4779	let newSemesterSeasonsByYear = {};
  4780	
  4781	function formatSeasonDate(iso) {
  4782	  const d = new Date(`${iso}T00:00:00`);
  4783	  return Number.isNaN(d.getTime()) ? iso : d.toLocaleDateString(undefined, { month: 'short', day: 'numeric', year: 'numeric' });
  4784	}
  4785	
  4786	function closeNewSemesterModal() {
  4787	  document.getElementById('ca-new-semester-modal')?.classList.remove('open');
  4788	}
  4789	
  4790	// In-flight guard: the Create button is a bare onclick with no disabled state,
  4791	// so a double-click ran two overlapping creations. Both passed the
  4792	// "already exists" check (the key is only added to currentConfig after the
  4793	// first await), and a split success/failure would let the failing run's
  4794	// cleanup below delete the succeeding run's server-side slots. Set before the
  4795	// first await, cleared in `finally` — everything between the check and the
  4796	// set is synchronous, so the second click always sees it.
  4797	let creatingSemester = false;
  4798	
  4799	// A lesson slot exactly as createNewSemester() / createLessonSlotsForRoster()
  4800	// generate it: identity + enrollment metadata, every other field at its empty
  4801	// default. Deliberately stricter than lessonHasContent() — projectTitle,
  4802	// materials, photoUrl, qaThread etc. are not CONTENT_FIELDS but are still
  4803	// real data that createNewSemester()'s slot write would merge over.
  4804	function isTemplateEmptyLesson(lesson) {
  4805	  if (!lesson || typeof lesson !== 'object') return false;
  4806	  const IDENTITY = new Set(['teacher', 'className', 'weekNum', 'classSize']);
  4807	  return Object.entries(lesson).every(([k, v]) =>
  4808	    IDENTITY.has(k) || v == null || v === '' || v === 0 || v === false ||
  4809	    (Array.isArray(v) && v.length === 0)
  4810	  );
  4811	}
  4812	
  4813	// A camp season is created from the registry, never typed in (1.6 / D3): no
  4814	// roster, no week grid, no lesson slots and no curriculum/lessonData write —
  4815	// its camps arrive from the Summer Camp App when Christie publishes them.
  4816	async function createCampSeasonSemester() {
  4817	  const season = document.getElementById('new-sem-season')?.value;
  4818	  const registry = newSemesterSeasonsByYear[season];
  4819	  if (!season || !registry) { alert('Pick a season first.'); return; }
  4820	
  4821	  const key = `summer-${season}`;
  4822	  if (currentConfig.semesters?.[key]) { alert(`Summer ${season} is already in the Classbook.`); return; }
  4823	  // The same completeness check Re-sync makes — otherwise a half-set-up season
  4824	  // could be ADDED with numWeeks 0 and no studios, and would then render with
  4825	  // 2026's fallback shape and hours (Phase 1 fix review).
  4826	  const problems = registrySeasonProblems(registry);
  4827	  if (problems.length) {
  4828	    alert(`Summer ${season} isn't ready yet: the Summer Camp App's season still needs ${problems.join(', ')}. Finish setting it up there, then add it here.`);
  4829	    return;
  4830	  }
  4831	
  4832	  creatingSemester = true;
  4833	  try {
  4834	    // The local check above only saw this tab's config.
  4835	    const serverConfig = await readAppDataFromServer();
  4836	    if (serverConfig?.semesters?.[key]) {
  4837	      alert(`Summer ${season} was already added (in another tab, or by another admin). Reload to see it.`);
  4838	      return;
  4839	    }
  4840	    const newSem = semesterFromRegistrySeason(registry);
  4841	    await updateAppData({ [`semesters.${key}`]: newSem });
  4842	    currentConfig.semesters[key] = newSem;
  4843	    closeNewSemesterModal();
  4844	    renderSemesterSelector();
  4845	    initGlobalSemesterSelector();
  4846	    alert(`${newSem.name} added. It stays hidden from teachers until you publish it, and its camps appear here as the Summer Camp App publishes them.`);
  4847	  } catch (err) {
  4848	    console.error('❌ Could not add the camp season:', err);
  4849	    delete currentConfig.semesters[key];
  4850	    alert(`Could not add that season: ${err.message}`);
  4851	  } finally {
  4852	    creatingSemester = false;
  4853	  }
  4854	}
  4855	
  4856	async function createNewSemester() {
  4857	  if (creatingSemester) return;
  4858	  if (selectedNewSemesterType() === SEMESTER_TYPES.camp) return await createCampSeasonSemester();
  4859	  if (selectedNewSemesterType() === SEMESTER_TYPES.dayOff) return await createDayOffYear();
  4860	  const name = document.getElementById('new-sem-name')?.value.trim();
  4861	  if (!name) { alert('Semester name is required.'); return; }
  4862	
  4863	  const key = name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');
  4864	  if (currentConfig.semesters[key]) {
  4865	    alert(`A semester with key "${key}" already exists.`);
  4866	    return;
  4867	  }
  4868	
  4869	  const startDate = document.getElementById('new-sem-start')?.value || '';
  4870	  const numWeeks = parseInt(document.getElementById('new-sem-weeks')?.value) || 16;
  4871	  const breaksRaw = document.getElementById('new-sem-breaks')?.value.trim() || '';
  4872	  const breakWeeks = breaksRaw ? breaksRaw.split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n)) : [];
  4873	  const closuresRaw = document.getElementById('new-sem-closures')?.value.trim() || '';
  4874	  const closureDates = parseClosureDates(closuresRaw);
  4875	  const copyFromKey = document.getElementById('new-sem-copy-from')?.value || '';
  4876	
  4877	  const newSem = {
  4878	    name,
  4879	    semesterType: SEMESTER_TYPES.weekly,   // stored explicitly from now on (Phase 1, 1.1)
  4880	    startDate,
  4881	    numWeeks,
  4882	    breakWeeks,
  4883	    closureDates,
  4884	    published: false,
  4885	    classRoster: {}
  4886	  };
  4887	
  4888	  // Invoked from a bare HTML onclick — nothing above this frame catches, so a
  4889	  // failure anywhere below must be handled here (backtracking audit, Phase 11).
  4890	  // Two Firestore writes happen in sequence (lesson slots, then config); if the
  4891	  // second fails after the first landed, the slots are an orphan on the server
  4892	  // for a semester the admin was told didn't get created, and a retry with the
  4893	  // same name would silently reuse them. Track whether the first write landed
  4894	  // so the catch can compensate.
  4895	  let lessonDataCommitted = false;
  4896	  creatingSemester = true;
  4897	  try {
  4898	    // Copy roster from existing semester if selected
  4899	    if (copyFromKey && currentConfig.semesters[copyFromKey]) {
  4900	      // Pre-check (implementation review, Sep 2026): this branch is the only
  4901	      // path that writes lesson data, and the compensating delete in the catch
  4902	      // below removes the WHOLE `key` map — only safe if nothing lived there
  4903	      // before this call. It can: deleteSemester() drops a key from local
  4904	      // state even when its server-side deleteLessonData() fails (warn-only),
  4905	      // and config has no live listener, so another admin's same-named
  4906	      // semester isn't visible here either. Forced server read — the local
  4907	      // cache is exactly what can't be trusted for this key. Refuse unless
  4908	      // every existing lesson is template-empty (a prior createNewSemester()'s
  4909	      // own leftovers are safe to build on and safe to delete; anything else
  4910	      // would be merged over silently by the slot write, then deleted on
  4911	      // failure). The no-copy path is deliberately NOT gated: it writes no
  4912	      // lesson data, and re-creating a deleted semester there adopts its
  4913	      // surviving lesson data — the remedy this alert points at.
  4914	      const existingLessonMap = await readServerSemesterLessonMap(key);
  4915	      if (existingLessonMap && Object.values(existingLessonMap).some(l => !isTemplateEmptyLesson(l))) {
  4916	        alert(`Lesson content already exists in Firestore under the key "${key}".\n\nIf it was left over from a deleted semester, create this semester again without "Copy from" to adopt that data.\n\nIf another admin may have just created it, reload this page first.\n\nOtherwise choose a different name.`);
  4917	        return;
  4918	      }
  4919	
  4920	      const source = currentConfig.semesters[copyFromKey];
  4921	      newSem.classRoster = JSON.parse(JSON.stringify(source.classRoster || {}));
  4922	      // Without this, classRoster's teacher fields are copied but the dropdown
  4923	      // that lets Settings display/edit them has no options — the roster looks
  4924	      // wiped even though the underlying data isn't, and saving Settings in
  4925	      // that state silently writes blank teachers over the real ones.
  4926	      newSem.teacherNames = JSON.parse(JSON.stringify(source.teacherNames || []));
  4927	
  4928	      // Create empty lesson slots from source semester's teacher/class combos
  4929	      const sourceLessons = currentLessonData?.[copyFromKey] || {};
  4930	      const combos = new Set();
  4931	      for (const lesson of Object.values(sourceLessons)) {
  4932	        combos.add(`${lesson.teacher}|||${lesson.className}`);
  4933	      }
  4934	
  4935	      const emptyLessons = {};
  4936	      for (const combo of combos) {
  4937	        const [teacher, className] = combo.split('|||');
  4938	        for (let w = 1; w <= numWeeks; w++) {
  4939	          const lessonKey = makeLessonKey(teacher, className, w);
  4940	          emptyLessons[lessonKey] = {
  4941	            teacher,
  4942	            className,
  4943	            weekNum: w,
  4944	            weekDate: '',
  4945	            classSize: 0,
  4946	            projectTitle: '',
  4947	            shortDetails: '',
  4948	            inspoLink: '',
  4949	            introPitch: '',
  4950	            processStep1: '',
  4951	            processStep2: '',
  4952	            processStep3: '',
  4953	            processStep4: '',
  4954	            closure: '',
  4955	            materials: '',
  4956	            dayOfMaterials: '',
  4957	            materialsList: [],
  4958	            status: '',
  4959	            publishToPrep: ''
  4960	          };
  4961	        }
  4962	      }
  4963	
  4964	      if (Object.keys(emptyLessons).length > 0) {
  4965	        await saveLessonData(key, emptyLessons);
  4966	        if (!currentLessonData) currentLessonData = {};
  4967	        currentLessonData[key] = emptyLessons;
  4968	        lessonDataCommitted = true;
  4969	      }
  4970	    }
  4971	
  4972	    // Confirm on the SERVER that the key is free — the check at the top of this
  4973	    // function only saw this tab's copy of the config (Phase 1, 1.2). The
  4974	    // remaining read-to-update window is accepted: one admin, same class as the
  4975	    // existing residual on the Q&A path.
  4976	    const serverConfig = await readAppDataFromServer();
  4977	    if (serverConfig?.semesters?.[key]) {
  4978	      throw new Error(`A semester with the key "${key}" already exists (created in another tab or by another admin). Choose a different name.`);
  4979	    }
  4980	    currentConfig.semesters[key] = newSem;
  4981	    await updateAppData({ [`semesters.${key}`]: newSem });
  4982	  } catch (err) {
  4983	    console.error('❌ Could not create new semester:', err);
  4984	    // Revert both local mutations so a retry isn't blocked by a phantom
  4985	    // "already exists" and the grid doesn't render a semester that never saved.
  4986	    delete currentConfig.semesters[key];
  4987	    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
  4988	    // R4-11: the empty lesson slots may already be persisted even though the
  4989	    // config never was — clean up the orphaned server-side write, not just the
  4990	    // local copy. Safe: this data is template-empty by construction (never had
  4991	    // real content), so deleting it loses nothing.
  4992	    if (lessonDataCommitted) {
  4993	      try {
  4994	        await deleteLessonData(key);
  4995	      } catch (cleanupErr) {
  4996	        console.error('⚠️ Could not clean up orphaned lesson data after failed semester creation:', cleanupErr);
  4997	      }
  4998	    }
  4999	    alert('Could not create the new semester. Please try again.');
  5000	    return;
  5001	  } finally {
  5002	    creatingSemester = false;
  5003	  }
  5004	
  5005	  closeNewSemesterModal();
  5006	  caCurrentSemester = key;
  5007	  renderSemesterSelector();
  5008	  renderAdminGrid();
  5009	  renderHelpQueue();
  5010	  renderCutBank();
  5011	  renderIdeaBank();
  5012	  renderChangeHistory();
  5013	}
  5014	
  5015	async function initCurriculumAdmin() {
  5016	  if (caInitialized) return;
  5017	  caInitialized = true;
  5018	
  5019	  if (!currentLessonData) await loadLessonData();
  5020	  if (!currentChangeLog) await loadChangeLog();
  5021	  if (!currentCutProjects) await loadCutProjects();
  5022	  if (!currentFutureProjects) await loadFutureProjects();
  5023	
  5024	  renderSemesterSelector();
  5025	  renderAdminGrid();
  5026	  renderHelpQueue();
  5027	  renderCutBank();
  5028	  renderIdeaBank();
  5029	  renderChangeHistory();
  5030	
  5031	  // Modal close
  5032	  document.getElementById('ca-modal-close')?.addEventListener('click', closeAdminModal);
  5033	  document.getElementById('ca-detail-modal')?.addEventListener('click', (e) => {
  5034	    if (e.target === document.getElementById('ca-detail-modal')) closeAdminModal();
  5035	  });
  5036	
  5037	  // Real-time updates
  5038	  setupLessonDataListener((data) => {
  5039	    currentLessonData = data;
  5040	    renderAdminGrid();
  5041	    renderHelpQueue();
  5042	    // Refresh teacher mapping table in Settings if it exists
  5043	    renderTeacherMappingTable();
  5044	  });
  5045	}
  5046	
  5047	function renderAdminGrid() {
  5048	  const wrapper = document.getElementById('ca-grid-wrapper');
  5049	  const semKey = getAdminSemKey();
  5050	  const lessons = currentLessonData?.[semKey];
  5051	
  5052	  // School Day Off Camps years: the event/camp planning list (Phase 1).
  5053	  if (isDayOffYear(semKey)) {
  5054	    document.querySelector('.ca-grid-hint')?.style.setProperty('display', 'none');
  5055	    renderDayOffAdmin(semKey);
  5056	    return;
  5057	  }
  5058	  // Camp seasons get their own view instead of the weekly curriculum grid
  5059	  if (isCampSeason(semKey)) {
  5060	    document.querySelector('.ca-grid-hint')?.style.setProperty('display', 'none');
  5480	      <label>Process Steps</label>
  5481	      <!-- textareas, not text inputs: an <input type="text"> strips newlines
  5482	           from its value, so a multi-line step written in the teacher or
  5483	           summer editor (both textareas) would be flattened here, read back
  5484	           as "changed", and resent — overwriting a concurrent edit and
  5485	           destroying the line breaks (Data Safety Plan Phase 9 review). -->
  5486	      <textarea id="ca-edit-step1" rows="2" placeholder="Step 1" style="margin-bottom:4px">${escHtml(l.processStep1 || '')}</textarea>
  5487	      <textarea id="ca-edit-step2" rows="2" placeholder="Step 2" style="margin-bottom:4px">${escHtml(l.processStep2 || '')}</textarea>
  5488	      <textarea id="ca-edit-step3" rows="2" placeholder="Step 3" style="margin-bottom:4px">${escHtml(l.processStep3 || '')}</textarea>
  5489	      <textarea id="ca-edit-step4" rows="2" placeholder="Step 4">${escHtml(l.processStep4 || '')}</textarea>
  5490	    </div>
  5491	    <div class="settings-form-group">
  5492	      <label>Closure</label>
  5493	      <textarea id="ca-edit-closure" rows="2" placeholder="How will you wrap up?">${escHtml(l.closure || '')}</textarea>
  5494	    </div>
  5495	    <div class="settings-form-group">
  5496	      <label>Materials to Prep</label>
  5497	      <textarea id="ca-edit-materials" rows="2" placeholder="Materials needed"${ro}>${escHtml(l.materials || '')}</textarea>
  5498	    </div>
  5499	    <div class="settings-form-group">
  5500	      <label>Day-Of Materials</label>
  5501	      <textarea id="ca-edit-dayof" rows="2" placeholder="Materials to set up day-of">${escHtml(l.dayOfMaterials || '')}</textarea>
  5502	    </div>
  5503	    <div class="settings-form-group">
  5504	      <label>Demo Photo</label>
  5505	      ${l.photoUrl ? `<div id="ca-edit-photo-preview" style="margin-bottom:8px">${safeHttpUrl(l.photoUrl) ? `<img src="${escAttr(safeHttpUrl(l.photoUrl))}" style="max-height:150px;border-radius:8px;border:1px solid var(--border-light)"><br>` : ''}<button type="button" class="te-photo-remove-btn" style="position:static;margin-top:4px" onclick="document.getElementById('ca-edit-photo-preview').remove();document.getElementById('ca-edit-photo-input').dataset.pendingRemove='true'">Remove photo</button></div>` : ''}
  5506	      <input type="file" id="ca-edit-photo-input" accept="image/*" capture="environment">
  5507	      <span class="te-photo-hint">Take a photo or choose from library (max 5MB)</span>
  5508	    </div>
  5509	    <div class="ca-actions" style="margin-top:12px">
  5510	      <button class="btn-primary ca-action-btn" onclick="saveAdminEdit('${escAttr(key)}', '${escAttr(teacher)}', '${escAttr(className)}', ${weekNum})">Save</button>
  5511	      <button class="btn-secondary ca-action-btn" onclick="printAdminLesson('${escAttr(key)}')">&#128438; Print</button>
  5512	      <button class="btn-secondary ca-action-btn" onclick="closeAdminModal()">Cancel</button>
  5513	    </div>
  5514	  </div>`;
  5515	}
  5516	
  5517	function showAdminEdit(key, teacher, className, weekNum) {
  5518	  const semKey = getAdminSemKey();
  5519	  const lesson = currentLessonData?.[semKey]?.[key] || null;
  5520	  captureAdminEditSnapshot(lesson);
  5521	
  5522	  const modal = document.getElementById('ca-detail-modal');
  5523	  const title = document.getElementById('ca-modal-title');
  5524	  const body = document.getElementById('ca-modal-body');
  5525	
  5526	  title.textContent = lesson ? `Edit: ${lesson.projectTitle}` : `New Project — Week ${weekNum}`;
  5527	
  5528	  let html = `<div class="ca-detail-meta">
  5529	    <span><strong>Teacher:</strong> ${escHtml(teacher)}</span>
  5530	    <span><strong>Class:</strong> ${escHtml(className)}</span>
  5531	    <span><strong>Week:</strong> ${weekNum}</span>
  5532	  </div>`;
  5533	  html += renderAdminEditForm(lesson, key, teacher, className, weekNum);
  5534	
  5535	  body.innerHTML = html;
  5536	  modal.classList.add('open');
  5537	  // First editable field — on a summer lesson the title is read-only.
  5538	  document.querySelector('#ca-edit-form input:not([readonly]), #ca-edit-form textarea:not([readonly])')?.focus();
  5539	}
  5540	
  5541	// Data Safety Plan Phase 9 (+ backtracking audit Phase 1): the admin edit
  5542	// popup's save. What goes to Firestore is ONLY what this popup changed — the
  5543	// diff of the form against the open-time snapshot, plus the photo fields if
  5544	// this save touched them, plus identity/scheduling fields (teacher, className,
  5545	// weekNum, weekDate, classSize — no input in this form; resent from the cache
  5546	// exactly as before, an inherited exposure named in the plan, not a Phase 9
  5547	// change). The cached `existing` lesson is never spread into the payload, so
  5548	// a stale qaThread / photo / untouched content field can't overwrite another
  5549	// client's newer copy. Intentional clears travel as fieldsToClear. Before
  5550	// anything is written, a forced-server read confirms the lesson still exists
  5551	// (moved/deleted elsewhere while the popup was open → refuse, don't recreate
  5552	// a ghost). Residual check-to-write TOCTOU gap accepted per the plan.
  5553	async function saveAdminEdit(key, teacher, className, weekNum) {
  5554	  if (caEditSaveInFlight) return;
  5555	  const title = document.getElementById('ca-edit-title')?.value.trim();
  5556	  // (closeAdminModal() refuses non-forced closes while caEditSaveInFlight is
  5557	  // set — Cancel / × / overlay are effectively disabled for the duration.)
  5558	  if (!title) { alert('Project title is required.'); return; }
  5559	
  5560	  // Backtracking audit, Phase 1: check the guard BEFORE any Storage mutation
  5561	  // (and, now, before the existence check) so a known-bad load state never
  5562	  // gets as far as a server read, an upload, or a delete.
  5563	  if (lessonDataLoadedSuccessfully === false) {
  5564	    alert('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  5565	    return;
  5566	  }
  5567	
  5568	  caEditSaveInFlight = true;
  5569	  // Every action button in the modal body — the form's own Save/Print/Cancel
  5570	  // AND the empty-cell popup's two Paste buttons, which openDetailModal()
  5571	  // renders outside #ca-edit-form (round-3 review: they could replace the
  5572	  // modal body mid-save and race a second write onto the same slot).
  5573	  const btns = Array.from(document.querySelectorAll('#ca-modal-body .ca-actions button'));
  5574	  const saveBtn = btns.find(b => /^save/i.test(b.textContent.trim()));
  5575	  btns.forEach(b => { b.disabled = true; });
  5576	  if (saveBtn) saveBtn.textContent = 'Saving...';
  5577	  try {
  5578	    await saveAdminEditInner(key, teacher, className, weekNum, title);
  5579	  } finally {
  5580	    caEditSaveInFlight = false;
  5581	    btns.forEach(b => { b.disabled = false; });
  5582	    if (saveBtn) saveBtn.textContent = 'Save';
  5583	  }
  5584	}
  5585	
  5586	async function saveAdminEditInner(key, teacher, className, weekNum, title) {
  5587	  const semKey = getAdminSemKey();
  5588	
  5589	  const lessons = { ...(currentLessonData?.[semKey] || {}) };
  5590	  let existing = lessons[key] || {};   // rebased on the fresh server copy after the existence check (non-summer)
  5591	
  5592	  // Step 1 — diff the form against the open-time snapshot (pure DOM reads, no
  5593	  // side effects — so a no-op save can bail out below without paying for the
  5594	  // existence check's server read).
  5595	  const raw = {
  5596	    projectTitle: title,
  5597	    shortDetails: document.getElementById('ca-edit-details')?.value.trim() || '',
  5598	    inspoLink: document.getElementById('ca-edit-inspo')?.value.trim() || '',
  5599	    introPitch: document.getElementById('ca-edit-intro')?.value.trim() || '',
  5600	    processStep1: document.getElementById('ca-edit-step1')?.value.trim() || '',
  5601	    processStep2: document.getElementById('ca-edit-step2')?.value.trim() || '',
  5602	    processStep3: document.getElementById('ca-edit-step3')?.value.trim() || '',
  5603	    processStep4: document.getElementById('ca-edit-step4')?.value.trim() || '',
  5604	    closure: document.getElementById('ca-edit-closure')?.value.trim() || '',
  5605	    materials: document.getElementById('ca-edit-materials')?.value.trim() || '',
  5606	    dayOfMaterials: document.getElementById('ca-edit-dayof')?.value.trim() || '',
  5607	  };
  5608	  // No snapshot (shouldn't happen — both render paths capture one) degrades to
  5609	  // "everything non-empty is changed": today's behavior, never a lost edit.
  5610	  const baseline = caEditOriginalData || {};
  5611	  const changedFields = Object.keys(raw).filter(f => raw[f] !== (baseline[f] || ''));
  5612	  // Had text when the popup opened, empty now — an intentional clear, which
  5613	  // saveSingleLesson must apply with FieldValue.delete() rather than let the
  5614	  // stripping pass silently drop (Data Safety Plan Stage 3, never extended to
  5615	  // this third editor until now).
  5616	  const fieldsToClear = changedFields.filter(f => (baseline[f] || '') !== '' && raw[f] === '');
  5617	  const changedData = {};
  5618	  changedFields.forEach(f => { changedData[f] = raw[f]; });
  5619	
  5620	  const photoInput = document.getElementById('ca-edit-photo-input');
  5621	  const hasNewPhoto = photoInput?.files?.length > 0;
  5622	  let pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
  5623	  // Nothing changed — no write, no re-stamped lastEditedBy/At, no "edit" log
  5624	  // entry for an edit that didn't happen (mirrors saveTeacherEdit()).
  5625	  if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) {
  5626	    closeAdminModal(true);
  5627	    return;
  5628	  }
  5629	
  5630	  // Step 2 — forced-server read of this slot, before any side effect (the
  5631	  // photo upload, the write). Non-summer only: a summer cache entry is a
  5632	  // scaffold regenerated from summerCamps_curriculum whether or not its
  5633	  // summerCamps_lessonData doc exists (a missing doc means "never saved",
  5634	  // not "moved") and this app has no move/swap/cut path for summer lessons,
  5635	  // so there is no ghost to prevent — the first save legitimately creates
  5636	  // the doc. Same routing signal as saveSingleLesson() /
  5637	  // adminLessonStillExistsWithRetry() (key prefix; the camp-seasons plan
  5638	  // unifies this on semesterType). Forced read — a cache-permitting get()
  5639	  // could be served from the live listener's local cache in exactly the race
  5640	  // window this check exists to close. It runs for first-time creation too:
  5641	  // an "empty" slot in this tab's cache may have gained a project (a paste, a
  5642	  // move onto it) that the listener hasn't delivered yet.
  5643	  const isSummerSchema = isCampSeason(semKey);   // Phase 1, 1.1
  5644	  if (!isSummerSchema) {
  5645	    let check;
  5646	    try {
  5647	      check = await adminLessonStillExistsWithRetry(semKey, key);
  5648	    } catch (err) {
  5649	      console.warn('⚠️ Existence check retry also failed:', err);
  5650	      alert("Couldn't confirm this lesson still exists — check your connection and try saving again.");
  5651	      return;
  5652	    }
  5653	    if (caEditLessonExisted && !check.exists) {
  5654	      alert('This lesson was moved or removed elsewhere while you had it open. Your changes were not saved — please close this window and check the grid for its new location.');
  5655	      return;
  5656	    }
  5657	    if (check.exists) {
  5658	      // The key holds a doc — but a swap, a move ONTO this slot, or a paste
  5659	      // into a slot this tab still shows as empty leaves it populated with a
  5660	      // DIFFERENT project. The popup's edits were made against the project it
  5661	      // opened on; applying them to whatever is here now needs an explicit
  5662	      // decision, the same way cutProject() re-confirms when the fresh read
  5663	      // shows the slot's identity changed.
  5664	      const freshTitle = (check.data?.projectTitle || '').trim();
  5665	      if (freshTitle !== (baseline.projectTitle || '')) {
  5666	        const opened = baseline.projectTitle || '(empty slot)';
  5667	        if (!confirm(`This slot has changed since you opened it — it now contains "${freshTitle || '(empty)'}" instead of "${opened}". Save your changes onto "${freshTitle || 'this slot'}" anyway?\n\nCancel keeps your text here and saves nothing.`)) return;
  5668	      }
  5669	      // From here on, work from the FRESH copy, not this tab's cache: the
  5670	      // photo to delete after a replacement, the "remove photo" target, the
  5671	      // identity/scheduling fields resent below, the local cache merge and
  5672	      // the logged title all come from `existing`. On the swap-accept path
  5673	      // the cached copy's photoPath is the OTHER lesson's live photo.
  5674	      existing = check.data;
  5675	      pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
  5676	    }
  5677	  } else if (!existing.campName) {
  5678	    // A summer key that is no longer in the cache (the schedule was rebuilt
  5679	    // between open and save — e.g. the project was renamed in the Summer
  5680	    // Camp App) would produce a doc without its identity trio, which neither
  5681	    // app can find again. Refuse rather than write it.
  5682	    alert('This lesson is no longer in the summer schedule — reload and try again. Nothing was saved.');
  5683	    return;
  5684	  }
  5685	
  5686	  // Summer: projectTitle, shortDetails, inspoLink and materials belong to the
  5687	  // camp curriculum, not to the lesson doc — loadSummerCampData() takes them
  5688	  // from the scaffold and reads back only content/photo/completion fields
  5689	  // (SUMMER_SAVED_FIELDS), so an edit here would "save" and then vanish on the
  5690	  // next reload. projectTitle is worse: it is part of the lesson key, and the
  5691	  // Summer Camp App's orphan check treats a doc whose title isn't in the
  5692	  // camp's curriculum as orphaned content. Refuse them honestly rather than
  5693	  // write them into a doc where they can only mislead.
  5694	  const SUMMER_CURRICULUM_OWNED = ['projectTitle', 'shortDetails', 'inspoLink', 'materials'];
  5695	  if (isSummerSchema) {
  5696	    const refused = SUMMER_CURRICULUM_OWNED.filter(f => f in changedData);
  5697	    if (refused.length > 0) {
  5698	      const labels = { projectTitle: 'project title', shortDetails: 'short details', inspoLink: 'inspo link', materials: 'materials' };
  5699	      alert(`Summer camp ${refused.map(f => labels[f]).join(', ')} are managed in the Summer Camp App — that change is not saved here.` + (changedFields.length > refused.length || hasNewPhoto || pendingRemove ? ' Your other edits will still be saved.' : ''));
  5700	      refused.forEach(f => {
  5701	        delete changedData[f];
  5702	        const idx = changedFields.indexOf(f);
  5703	        if (idx !== -1) changedFields.splice(idx, 1);
  5704	        const cidx = fieldsToClear.indexOf(f);
  5705	        if (cidx !== -1) fieldsToClear.splice(cidx, 1);
  5706	      });
  5707	      if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) { closeAdminModal(true); return; }
  5708	    }
  5709	  }
  5710	
  5711	  // Firestore-bound payload — see the function comment for what's in it and why.
  5712	  const firestorePayload = {
  5713	    teacher, className, weekNum,
  5714	    weekDate: existing.weekDate || '',
  5715	    classSize: existing.classSize || 0,
  5716	    // Summer identity trio, key-derived and idempotent — a doc this save
  5717	    // CREATES must carry them (the Summer Camp App queries this collection by
  5718	    // campName + teacher and checks projectTitle; the summer editor sends the
  5719	    // same trio on every save for the same reason).
  5720	    ...(isSummerSchema ? { campName: existing.campName, block: existing.block, projectTitle: existing.projectTitle } : {}),
  5721	    ...changedData,
  5722	    lastImported: new Date().toISOString()
  5723	  };
  5724	
  5725	  // Backtracking audit, Phase 1 (R4-2): capture the OLD photoPath before any
  5726	  // mutation, so the delete-after-save step compares against the right value.
  5727	  const oldPhotoPath = existing.photoPath || null;
  5728	  let photoUrl = null, photoPath = null;   // null = this save didn't touch the photo
  5729	
  5730	  try {
  5731	    // Handle photo upload/removal
  5732	    if (hasNewPhoto) {
  5733	      const file = photoInput.files[0];
  5734	      if (file.size > 5 * 1024 * 1024) { alert('Photo must be under 5MB.'); return; }
  5735	      const { url, path } = await uploadLessonPhoto(semKey, key, file);
  5736	      // Delete of the OLD photo happens AFTER the save below — not here.
  5737	      photoUrl = url;
  5738	      photoPath = path;
  5739	    } else if (pendingRemove) {
  5740	      photoUrl = '';
  5741	      photoPath = '';
  5742	    }
  5743	    if (photoUrl !== null) {
  5744	      firestorePayload.photoUrl = photoUrl;
  5745	      firestorePayload.photoPath = photoPath;
  5746	    }
  5747	
  5748	    // Targeted single-lesson save with a diff-only payload — never the cached
  5749	    // full lesson, never the whole semester. (The summer branch's "no content"
  5750	    // guard can't refuse a legitimate save from here: for summer every
  5751	    // editable non-content field is curriculum-owned and refused above, so
  5752	    // what remains is content, a clear, or a photo — each admitted.)
  5753	    await saveSingleLesson(semKey, key, firestorePayload, fieldsToClear);
  5754	
  5755	    // Backtracking audit, Phase 1 (R4-2): only delete the OLD object once
  5756	    // Firestore has confirmed the new reference — and only when THIS save
  5757	    // actually replaced or removed the photo (photoUrl !== null). A text-only
  5758	    // edit leaves the old path untouched in both Firestore and Storage.
  5759	    if (photoUrl !== null && oldPhotoPath && oldPhotoPath !== (photoPath || null)) {
  5760	      try {
  5761	        await deleteLessonPhoto(oldPhotoPath);
  5762	      } catch (cleanupErr) {
  5763	        console.error('⚠️ Could not clean up old photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
  5764	      }
  5765	    }
  5766	  } catch (err) {
  5767	    // Backtracking audit, Phase 1 (R2-22): MUST return here — otherwise
  5768	    // execution falls through to commit currentLessonData, close the modal,
  5769	    // and log a fake edit even though the save never actually succeeded. The
  5770	    // snapshot is kept so the still-open popup can retry against it.
  5771	    console.error('❌ Admin edit failed to save:', err);
  5772	    alert('This edit could not be saved. Please try again.');
  5773	    return;
  5774	  }
  5775	
  5776	  // Local display/cache only — never sent to Firestore, so keeping the full
  5777	  // merge here is safe (staleness in untouched fields is cosmetic until the
  5778	  // listener's next delivery, same as the teacher editor).
  5779	  lessons[key] = {
  5780	    ...existing,
  5781	    teacher, className, weekNum,
  5782	    weekDate: firestorePayload.weekDate,
  5783	    classSize: firestorePayload.classSize,
  5784	    ...changedData,
  5785	    lastImported: firestorePayload.lastImported,
  5786	    lastEditedBy: firestorePayload.lastEditedBy,   // stamped by saveSingleLesson()
  5787	    lastEditedAt: firestorePayload.lastEditedAt
  5788	  };
  5789	  if (photoUrl !== null) { lessons[key].photoUrl = photoUrl; lessons[key].photoPath = photoPath; }
  5790	  fieldsToClear.forEach(f => { lessons[key][f] = ''; });
  5791	  currentLessonData[semKey] = lessons;
  5792	
  5793	  closeAdminModal(true);   // the save's own close — also resets the snapshot
  5794	  renderAdminGrid();
  5795	  renderChangeHistory();
  5796	
  5797	  try {
  5798	    // Log the title that was actually kept — for summer a refused retitle
  5799	    // must not show up in Change History under the refused name.
  5800	    const keptTitle = firestorePayload.projectTitle || existing.projectTitle || title;
  5801	    await appendChangeLogEntry(semKey, {
  5802	      action: existing.projectTitle ? 'edit' : 'create',
  5803	      details: { projectTitle: keptTitle, teacher, className, weekNum }
  5804	    });
  5805	    renderChangeHistory();
  5806	  } catch (e) { console.warn('Could not write change log entry:', e); }
  5807	}
  5808	
  5809	function startSwap(sourceKey) {
  5810	  caActionMode = 'swap';
  5811	  caSourceKey = sourceKey;
  5812	  closeAdminModal();
  5813	  renderAdminGrid();
  5814	}
  5815	
  5816	function cancelGridAction() {
  5817	  caActionMode = null;
  5818	  caSourceKey = null;
  5819	  renderAdminGrid();
  5820	}
  5821	
  5822	// Data Safety Plan Stage 2A/2B: shared helpers for the admin grid's move/swap
  5823	// abort-and-restore paths (see CLASSBOOK-DATA-SAFETY-PLAN.md).
  5824	// lessonHasContent() now lives in firebase-data.js (CONTENT_FIELDS is the
  5825	// single source of truth, Data Safety Plan Stage 4A) — this file just uses it.
  5826	
  5827	// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
  5828	// model. Backtracking audit, Phase 2 (reinstated round 4): adds an optional
  5829	// opts.source === 'server' param, needed by Phase 8's
  5830	// adminLessonStillExistsWithRetry() existence check below — omitting opts
  5831	// preserves the exact prior (cache-permitting) default for any future caller.
  5832	async function readAdminLessonDoc(semKey, lessonKey, opts = {}) {
  5833	  if (!curriculumDb) initCurriculumFirestore();
  5834	  const getOpts = opts.source === 'server' ? { source: 'server' } : undefined;
  5835	  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
  5836	  return snap.exists ? (snap.data()?.[semKey]?.[lessonKey] || null) : null;
  5837	}
  5838	
  5839	// Backtracking audit, Phase 8: shared by cutProject() below and Phase 11's
  5840	// sendHelpResponse()/sendQaReply() (not yet implemented) — forced server
  5841	// read, retried once on failure, then lets a second failure throw so each
  5842	// caller decides how to surface it. Residual TOCTOU race (check-to-write gap)
  5843	// deliberately accepted, matching the companion plan's own decision for this
  5844	// identical helper — bounded by human click-to-click timing, not a tight
  5845	// machine loop; closing it fully would need a Firestore transaction.
  5846	async function adminLessonStillExistsWithRetry(semKey, key) {
  5847	  if (!curriculumDb) initCurriculumFirestore();
  5848	  const isSummer = lessonStoreFor(semKey) === 'camp';   // Phase 1, 1.1 — by type, and a third type throws
  5849	  const readOnce = async () => {
  5850	    if (isSummer) {
  5851	      const snap = await curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key)).get({ source: 'server' });
  5852	      return { exists: snap.exists, data: snap.exists ? snap.data() : null };
  5853	    }
  5854	    const data = await readAdminLessonDoc(semKey, key, { source: 'server' });
  5855	    return { exists: data !== null, data };
  5856	  };
  5857	  try {
  5858	    return await readOnce();
  5859	  } catch (err) {
  5860	    console.warn('⚠️ Existence check read failed, retrying once:', err);
  5861	    return await readOnce(); // a second failure throws — caller's catch handles it
  5862	  }
  5863	}
  5864	
  5865	// Reverts the admin grid's optimistic in-memory update after a move/swap that
  5866	// failed to save or failed verification — puts both slots back to their
  5867	// pre-action state (deleting the dest slot if it didn't exist before) and re-renders.
  5868	function restoreGridActionState(semKey, sourceKey, sourceLesson, destKey, destLesson) {
  5869	  if (!currentLessonData[semKey]) currentLessonData[semKey] = {};
  5870	  currentLessonData[semKey][sourceKey] = sourceLesson;
  5871	  if (destLesson) {
  5872	    currentLessonData[semKey][destKey] = destLesson;
  5873	  } else {
  5874	    delete currentLessonData[semKey][destKey];
  5875	  }
  5876	  renderAdminGrid();
  5877	}
  5878	
  5879	async function handleGridAction(destTeacher, destClassName, destWeekNum, destKey) {
  5880	  const semKey = getAdminSemKey();
  5881	  const lessons = { ...currentLessonData[semKey] };
  5882	  const sourceLesson = lessons[caSourceKey];
  5883	
  5884	  if (!sourceLesson) {
  5885	    cancelGridAction();
  5886	    return;
  5887	  }
  5888	
  5889	  // Prevent moving to same cell
  5890	  if (caSourceKey === destKey) {
  5891	    cancelGridAction();
  5892	    return;
  5893	  }
  5894	
  5895	  const destLesson = lessons[destKey] || null;
  5896	  const newDestKey = makeLessonKey(destTeacher, destClassName, destWeekNum);
  5897	
  5898	  if (caActionMode === 'move') {
  5899	    if (destLesson) {
  5900	      if (!confirm(`Week ${destWeekNum} already has "${destLesson.projectTitle}". This will overwrite it. Continue?`)) {
  5901	        cancelGridAction();
  5902	        return;
  5903	      }
  5904	    }
  5905	    if (!confirm(`Move "${sourceLesson.projectTitle}" from Week ${sourceLesson.weekNum} to ${destTeacher} / ${destClassName} Week ${destWeekNum}?`)) {
  5906	      cancelGridAction();
  5907	      return;
  5908	    }
  5909	
  5910	    // Move: put source content at destination, clear source
  5911	    const movedLesson = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum };
  5912	    movedLesson.weekDate = destLesson?.weekDate || '';
  5913	    // Backtracking audit, Phase 4: a content field non-empty at the existing
  5914	    // destination but empty in the incoming moved lesson must be explicitly
  5915	    // cleared — saveSingleLesson omits empty fields from the write rather
  5916	    // than clearing them, so without this the destination's old content
  5917	    // would silently survive underneath the moved lesson.
  5918	    const destFieldsToClear = CONTENT_FIELDS.filter(f =>
  5919	      (destLesson?.[f] || '').trim() !== '' && !(movedLesson[f] || '').trim()
  5920	    );
  5921	    lessons[newDestKey] = movedLesson;
  5922	    delete lessons[caSourceKey];
  5923	    currentLessonData[semKey] = lessons;
  5924	
  5925	    const sourceKeyToDelete = caSourceKey;
  5926	    const preMoveSourceLesson = sourceLesson;
  5927	    const preMoveDestLesson = destLesson;
  5928	    caActionMode = null;
  5929	    caSourceKey = null;
  5930	    renderAdminGrid();
  5931	    renderChangeHistory();
  5932	
  5933	    // Backtracking audit, Phase 9: the destination write and the source
  5934	    // delete are ONE atomic Firestore call — closes the "first write landed,
  5935	    // second failed" partial-failure race the prior sequential-write design
  5936	    // was vulnerable to. Does NOT independently verify movedLesson reflects
  5937	    // the CURRENT server state (a separate, deliberately deferred stale-input
  5938	    // race — see classbook-shared-document-concurrency-plan.html's 7th
  5939	    // instance) — no read-back needed or performed, since the write is
  5940	    // all-or-nothing.
  5941	    let moveSucceeded = false;
  5942	    try {
  5943	      await saveMultipleLessonFields(
  5944	        semKey,
  5945	        [{ lessonKey: newDestKey, lessonData: movedLesson, fieldsToClear: destFieldsToClear }],
  5946	        [sourceKeyToDelete]
  5947	      );
  5948	      moveSucceeded = true;
  5949	    } catch (err) {
  5950	      console.error('❌ Move failed:', err);
  5951	      restoreGridActionState(semKey, sourceKeyToDelete, preMoveSourceLesson, newDestKey, preMoveDestLesson);
  5952	      alert(`Move could not be saved — "${preMoveSourceLesson.projectTitle}" has been restored to its original slot. Nothing was changed.`);
  5953	      return;
  5954	    }
  5955	
  5956	    if (moveSucceeded) {
  5957	      try {
  5958	        await appendChangeLogEntry(semKey, {
  5959	          action: 'move',
  5960	          details: {
  5961	            projectTitle: sourceLesson.projectTitle,
  5962	            teacher: sourceLesson.teacher,
  5963	            className: sourceLesson.className,
  5964	            fromWeek: sourceLesson.weekNum,
  5965	            toTeacher: destTeacher,
  5966	            toClassName: destClassName,
  5967	            toWeek: destWeekNum
  5968	          }
  5969	        });
  5970	        renderChangeHistory();
  5971	      } catch (logErr) {
  5972	        console.error('⚠️ Move saved, but Change History logging failed:', logErr);
  5973	      }
  5974	    }
  5975	    return;
  5976	
  5977	  } else if (caActionMode === 'swap') {
  5978	    const destLabel = destLesson ? `"${destLesson.projectTitle}"` : 'empty slot';
  5979	    if (!confirm(`Swap "${sourceLesson.projectTitle}" (Week ${sourceLesson.weekNum}) with ${destLabel} (Week ${destWeekNum})?`)) {
  5980	      cancelGridAction();
  5981	      return;
  5982	    }
  5983	
  5984	    // Swap: exchange content between source and dest
  5985	    const sourceWeekNum = sourceLesson.weekNum;
  5986	    const sourceTeacher = sourceLesson.teacher;
  5987	    const sourceClassName = sourceLesson.className;
  5988	    const sourceWeekDate = sourceLesson.weekDate;
  5989	    const sourceKeyForSwap = caSourceKey;
  5990	
  5991	    let savePromise;
  5992	    let swapSucceeded = false;
  5993	    if (destLesson) {
  5994	      const swappedSource = { ...destLesson, teacher: sourceTeacher, className: sourceClassName, weekNum: sourceWeekNum, weekDate: sourceWeekDate };
  5995	      const swappedDest = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum, weekDate: destLesson.weekDate };
  5996	      // Backtracking audit, Phase 4: each slot's clear list compares its OWN
  5997	      // pre-swap content against what's now being written there — NOT the
  5998	      // other slot's pre-swap content, which would be a no-op since that's
  5999	      // identical-by-construction to the incoming value.
  6000	      const sourceFieldsToClear = CONTENT_FIELDS.filter(f =>
  6001	        (sourceLesson[f] || '').trim() !== '' && !(swappedSource[f] || '').trim()
  6002	      );
  6003	      const destFieldsToClearSwap = CONTENT_FIELDS.filter(f =>
  6004	        (destLesson[f] || '').trim() !== '' && !(swappedDest[f] || '').trim()
  6005	      );
  6006	      lessons[sourceKeyForSwap] = swappedSource;
  6007	      lessons[newDestKey] = swappedDest;
  6008	      currentLessonData[semKey] = lessons;
  6009	
  6010	      // Backtracking audit, Phase 9: both slots' writes are now ONE atomic
  6011	      // Firestore call — closes the "first save landed, second failed"
  6012	      // partial-failure race the prior two-sequential-saves design was
  6013	      // vulnerable to.
  6014	      savePromise = (async () => {
  6015	        try {
  6016	          await saveMultipleLessonFields(semKey, [
  6017	            { lessonKey: sourceKeyForSwap, lessonData: swappedSource, fieldsToClear: sourceFieldsToClear },
  6018	            { lessonKey: newDestKey, lessonData: swappedDest, fieldsToClear: destFieldsToClearSwap }
  6019	          ]);
  6020	          swapSucceeded = true;
  6021	        } catch (err) {
  6022	          console.error('❌ Swap failed:', err);
  6023	          restoreGridActionState(semKey, sourceKeyForSwap, sourceLesson, newDestKey, destLesson);
  6024	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" and "${destLesson.projectTitle}" have been restored to their original slots.`);
  6025	        }
  6026	      })();
  6027	    } else {
  6028	      // Swap with empty: move source to dest, clear source. Backtracking
  6029	      // audit, Phase 9: the destination write and source delete are now ONE
  6030	      // atomic Firestore call, same reasoning as the move branch above.
  6031	      const movedLesson = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum, weekDate: '' };
  6032	      lessons[newDestKey] = movedLesson;
  6033	      delete lessons[sourceKeyForSwap];
  6034	      currentLessonData[semKey] = lessons;
  6035	      savePromise = (async () => {
  6036	        try {
  6037	          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
  6038	          swapSucceeded = true;
  6039	        } catch (err) {
  6040	          console.error('❌ Swap failed:', err);
  6041	          restoreGridActionState(semKey, sourceKeyForSwap, sourceLesson, newDestKey, null);
  6042	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" has been restored to its original slot.`);
  6043	        }
  6044	      })();
  6045	    }
  6046	
  6047	    caActionMode = null;
  6048	    caSourceKey = null;
  6049	    renderAdminGrid();
  6050	    renderChangeHistory();
  6051	
  6052	    await savePromise;
  6053	
  6054	    if (swapSucceeded) {
  6055	      try {
  6056	        await appendChangeLogEntry(semKey, {
  6057	          action: 'swap',
  6058	          details: {
  6059	            projectTitle: sourceLesson.projectTitle,
  6060	            teacher: sourceTeacher,
  6061	            className: sourceClassName,
  6062	            fromWeek: sourceWeekNum,
  6063	            swappedWith: destLesson?.projectTitle || '(empty)',
  6064	            toTeacher: destTeacher,
  6065	            toClassName: destClassName,
  6066	            toWeek: destWeekNum
  6067	          }
  6068	        });
  6069	        renderChangeHistory();
  6070	      } catch (logErr) {
  6071	        console.error('⚠️ Swap saved, but Change History logging failed:', logErr);
  6072	      }
  6073	    }
  6074	    return;
  6075	  }
  6076	
  6077	  caActionMode = null;
  6078	  caSourceKey = null;
  6079	  renderAdminGrid();
  6080	  renderChangeHistory();
  6081	}
  6082	
  6083	// ─── Copy Plan Workflow ─────────────────────────────
  6084	
  6085	function openCopyPlanUI(sourceKey) {
  6086	  const semKey = getAdminSemKey();
  6087	  const lessons = currentLessonData?.[semKey];
  6088	  if (!lessons) return;
  6089	
  6090	  const source = lessons[sourceKey];
  6091	  if (!source) return;
  6092	
  6093	  const shared = findSharedProjects(source.projectTitle, sourceKey, getAdminSemKey());
  6094	  if (shared.length === 0) return;
  6095	
  6096	  const body = document.getElementById('ca-modal-body');
  6097	  const title = document.getElementById('ca-modal-title');
  6098	  title.textContent = `Copy Plan: ${source.projectTitle}`;
  6099	
  6100	  let html = `<div class="ca-copy-section">
  6860	    alert('No ideas in the bank. Add some in the Future Projects section first.');
  6861	    return;
  6862	  }
  6863	
  6864	  const body = document.getElementById('ca-modal-body');
  6865	  let html = `<h4 class="ca-paste-title">Paste from Idea Bank</h4>
  6866	    <p class="ca-paste-hint">Select an idea to place in ${escHtml(teacher)} / ${escHtml(className)} Week ${weekNum}:</p>
  6867	    <p class="ca-paste-hint" style="font-style:italic;color:var(--tinker-teal)">Pasting places the idea on the grid — it will be removed from the Idea Bank.</p>
  6868	    <div class="ca-cut-list">`;
  6869	
  6870	  projects.forEach((proj, idx) => {
  6871	    // Find the real index in the full array (including archived)
  6872	    const realIdx = currentFutureProjects.projects.indexOf(proj);
  6873	    html += `<div class="ca-cut-item" onclick="pasteFromIdeaBank(${realIdx}, '${escAttr(teacher)}', '${escAttr(className)}', ${weekNum})">
  6874	      <div class="ca-cut-item-title">${escHtml(proj.title)}</div>
  6875	      <div class="ca-cut-item-meta">${proj.description ? escHtml(proj.description.substring(0, 100)) + (proj.description.length > 100 ? '...' : '') : 'No description'}</div>
  6876	      ${proj.tags?.length ? `<div class="ca-ideabank-tags" style="margin-top:4px">${proj.tags.map(t => `<span class="ca-tag-pill">${escHtml(t)}</span>`).join('')}</div>` : ''}
  6877	    </div>`;
  6878	  });
  6879	
  6880	  html += '</div>';
  6881	  body.innerHTML = html;
  6882	}
  6883	
  6884	// Backtracking audit Phase 11 (R3-10, R3-11, round-4 fieldsToClear; hardened
  6885	// by this session's implementation review): the original bulk
  6886	// saveLessonData() write passed the WHOLE {projects:[...]} wrapper into
  6887	// saveFutureProjects() (which expects a bare array), double-nesting
  6888	// curriculum/futureProjects and corrupting renderIdeaBank()'s cache — a
  6889	// deterministic, live production bug. Also removed the idea from the bank
  6890	// BEFORE the destination lesson save was confirmed. Rewritten around a
  6891	// targeted saveSingleLesson() write (unrelated lessons in the same semester
  6892	// are no longer touched), explicit fieldsToClear against the destination's
  6893	// own pre-existing stale content — both CONTENT_FIELDS and the
  6894	// instance-specific fields an Idea Bank project never supplies (matching
  6895	// pasteFromCutBank()'s own NON_CONTENT_FIELDS_TO_CLEAR pattern, since simply
  6896	// omitting a field only means "don't touch it," not "clear it") — and
  6897	// lesson-save-then-idea-removal ordering with an honest duplicate-message on
  6898	// a removal failure.
  6899	async function pasteFromIdeaBank(idx, teacher, className, weekNum) {
  6900	  const projects = currentFutureProjects?.projects || [];
  6901	  const proj = projects[idx];
  6902	  if (!proj) return;
  6903	
  6904	  if (!confirm(`Paste "${proj.title}" into ${teacher} / ${className} Week ${weekNum}? The idea will be removed from the bank.`)) return;
  6905	
  6906	  const semKey = getAdminSemKey();
  6907	  const key = makeLessonKey(teacher, className, weekNum);
  6908	  const existingLesson = currentLessonData?.[semKey]?.[key] || {};
  6909	  const existingClassSize = existingLesson.classSize || 0;
  6910	  const existingPhotoPath = existingLesson.photoPath || null;
  6911	  const newLesson = {
  6912	    teacher,
  6913	    className,
  6914	    weekNum,
  6915	    weekDate: '',
  6916	    classSize: existingClassSize,
  6917	    projectTitle: proj.title,
  6918	    shortDetails: proj.description || '',
  6919	    inspoLink: proj.inspoLink || '',
  6920	    introPitch: '',
  6921	    processStep1: '',
  6922	    processStep2: '',
  6923	    processStep3: '',
  6924	    processStep4: '',
  6925	    closure: '',
  6926	    materials: '',
  6927	    dayOfMaterials: '',
  6928	    status: '',
  6929	    publishToPrep: '',
  6930	    teacherNotes: '',
  6931	    adminResponse: '',
  6932	    lastImported: new Date().toISOString()
  6933	  };
  6934	
  6935	  // An idea's blank fields must actually CLEAR stale destination content, not
  6936	  // silently leave it — same pattern used everywhere else in this plan.
  6937	  const fieldsToClear = CONTENT_FIELDS.filter(f =>
  6938	    (existingLesson[f] || '').trim() !== '' && !(newLesson[f] || '').trim()
  6939	  );
  6940	  // Instance-specific fields tied to whatever previously occupied this slot —
  6941	  // an Idea Bank project never supplies these, so newLesson never sets them,
  6942	  // and buildLessonFieldUpdates() only touches fields actually present in the
  6943	  // object it's given. Without an explicit clear, a destination's own stale
  6944	  // Q&A thread, photo, completion flag, or materials list would silently
  6945	  // resurrect under the newly-pasted idea.
  6946	  const NON_CONTENT_FIELDS_TO_CLEAR = ['qaThread', 'photoUrl', 'photoPath', 'planComplete', 'materialsList'];
  6947	
  6948	  try {
  6949	    await saveSingleLesson(semKey, key, newLesson, [...fieldsToClear, ...NON_CONTENT_FIELDS_TO_CLEAR]);
  6950	    if (currentLessonData[semKey]) currentLessonData[semKey][key] = newLesson;
  6951	  } catch (err) {
  6952	    console.error('❌ Paste from Idea Bank failed — lesson could not be saved:', err);
  6953	    alert(`Could not paste "${proj.title}" — please try again. The idea is still in the bank.`);
  6954	    return;
  6955	  }
  6956	
  6957	  // Only delete the destination's old photo from Storage after Firestore has
  6958	  // confirmed the clear — same safe ordering as pasteFromCutBank()/
  6959	  // saveAdminEdit()/saveTeacherEdit().
  6960	  if (existingPhotoPath) {
  6961	    try {
  6962	      await deleteLessonPhoto(existingPhotoPath);
  6963	    } catch (cleanupErr) {
  6964	      console.error('⚠️ Could not clean up destination\'s old photo after paste (Firestore is correct, Storage has an orphan):', cleanupErr);
  6965	    }
  6966	  }
  6967	
  6968	  // NOT closed here: this is still a plain saveFutureProjects() .set(), the
  6969	  // same shared last-write-wins primitive as the Idea Bank's other five
  6970	  // writers (classbook-shared-document-concurrency-plan.html, instance 1) —
  6971	  // a concurrent-paste-where-one-fails edge case can leave the local cache
  6972	  // disagreeing with a successful server-side removal until reload (no
  6973	  // server-side data loss). The real fix is converting removal to an atomic
  6974	  // FieldValue.arrayRemove() across all six writers together, tracked there;
  6975	  // out of scope for this single-function live-bug fix.
  6976	  try {
  6977	    // Re-resolve the idea's current position by identity rather than trusting
  6978	    // the idx captured above — a second paste invoked while this one was
  6979	    // still awaiting the lesson save could have already spliced the array,
  6980	    // shifting indices out from under this call.
  6981	    const currentIdx = projects.indexOf(proj);
  6982	    if (currentIdx === -1) throw new Error('Idea no longer in the bank — already removed by a concurrent paste.');
  6983	    projects.splice(currentIdx, 1);
  6984	    await saveFutureProjects(projects);
  6985	  } catch (err) {
  6986	    if (!projects.includes(proj)) projects.push(proj);
  6987	    console.error('❌ Paste from Idea Bank — lesson saved but idea removal failed:', err);
  6988	    alert(`"${proj.title}" was placed on the grid, but could NOT be removed from the Idea Bank — it may now appear in both places. Please reload and check.`);
  6989	    closeAdminModal();
  6990	    renderAdminGrid();
  6991	    renderIdeaBank();
  6992	    renderChangeHistory();
  6993	    return;
  6994	  }
  6995	
  6996	  try {
  6997	    await appendChangeLogEntry(semKey, {
  6998	      action: 'paste',
  6999	      details: {
  7000	        projectTitle: proj.title,
  7001	        teacher,
  7002	        className,
  7003	        toWeek: weekNum,
  7004	        fromIdeaBank: true
  7005	      }
  7006	    });
  7007	  } catch (logErr) {
  7008	    console.error('⚠️ Idea pasted, but Change History logging failed:', logErr);
  7009	  }
  7010	
  7011	  closeAdminModal();
  7012	  renderAdminGrid();
  7013	  renderIdeaBank();
  7014	  renderChangeHistory();
  7015	}
  7016	
  7017	// ─── Help Queue ──────────────────────────────────────
  7018	
  7019	function getLatestMessageTimestamp(lesson) {
  7020	  const thread = getQaThread(lesson);
  7021	  if (thread.length === 0) return 0;
  7022	  const last = thread[thread.length - 1];
  7023	  return last.timestamp ? new Date(last.timestamp).getTime() : 0;
  7024	}
  7025	
  7026	function renderHelpQueue() {
  7027	  const semKey = getAdminSemKey();
  7028	  const lessons = currentLessonData?.[semKey];
  7029	  const container = document.getElementById('ca-help-content');
  7030	  const badge = document.getElementById('ca-help-badge');
  7031	  if (!container) return;
  7032	
  7033	  if (!lessons) {
  7034	    container.innerHTML = '<p class="ca-empty-hint">No lesson data loaded.</p>';
  7035	    badge.style.display = 'none';
  7036	    return;
  7037	  }
  7038	
  7039	  // Show lessons with active Q&A threads (has messages from teachers)
  7040	  const helpItems = Object.entries(lessons)
  7041	    .filter(([, l]) => {
  7042	      const qa = l.qaThread || [];
  7043	      return qa.length > 0 && qa.some(msg => msg.from === 'teacher');
  7044	    })
  7045	    .sort((a, b) => getLatestMessageTimestamp(b[1]) - getLatestMessageTimestamp(a[1]));
  7046	
  7047	  // Count items needing admin response (last message is from teacher)
  7048	  const needsResponse = helpItems.filter(([, l]) => hasUnansweredQuestion(l));
  7049	
  7050	  if (helpItems.length === 0) {
  7051	    container.innerHTML = '<p class="ca-empty-hint">No teachers need help right now.</p>';
  7052	    badge.style.display = 'none';
  7053	    return;
  7054	  }
  7055	
  7056	  badge.textContent = needsResponse.length || helpItems.length;
  7057	  badge.style.display = 'inline-block';
  7058	
  7059	  let html = '';
  7060	  if (needsResponse.length > 0) {
  7061	    html += `<div class="ca-help-summary" style="display:flex;align-items:center;gap:0.75rem;">
  7062	      <span>${needsResponse.length} awaiting your response</span>
  7063	      <div style="display:flex;border:2px solid var(--purple);border-radius:999px;overflow:hidden;font-size:0.8rem;font-weight:600;">
  7064	        <button onclick="if(hqFilterNeedsReply){toggleHqFilter()}" style="padding:0.25rem 0.75rem;border:none;background:${!hqFilterNeedsReply ? 'var(--purple)' : 'transparent'};color:${!hqFilterNeedsReply ? 'white' : 'var(--purple)'};cursor:pointer;">All</button>
  7065	        <button onclick="if(!hqFilterNeedsReply){toggleHqFilter()}" style="padding:0.25rem 0.75rem;border:none;background:${hqFilterNeedsReply ? 'var(--purple)' : 'transparent'};color:${hqFilterNeedsReply ? 'white' : 'var(--purple)'};cursor:pointer;">Needs Reply</button>
  7066	      </div>
  7067	    </div>`;
  7068	  }
  7069	
  7070	  const displayItems = hqFilterNeedsReply ? needsResponse : helpItems;
  7071	  for (const [key, lesson] of displayItems) {
  7072	    const thread = getQaThread(lesson);
  7073	    const unanswered = hasUnansweredQuestion(lesson);
  7074	    const lastMsg = thread[thread.length - 1];
  7075	    const timeAgo = lastMsg?.timestamp ? getTimeAgo(lastMsg.timestamp) : '';
  7076	
  7077	    html += `<div class="ca-help-item ${unanswered ? 'ca-help-unanswered' : 'ca-help-answered'}">
  7078	      <div class="ca-help-item-header">
  7079	        ${unanswered ? '<span class="ca-help-new-badge">Needs Reply</span>' : '<span class="ca-help-replied-badge">Replied</span>'}
  7080	        <strong>${escHtml(lesson.teacher)}</strong> &mdash; ${escHtml(lesson.className)} &middot; Week ${lesson.weekNum}
  7081	        ${timeAgo ? `<span class="ca-help-time">${timeAgo}</span>` : ''}
  7082	      </div>
  7083	      <div class="ca-help-item-project">${escHtml(lesson.projectTitle)}</div>
  7084	      ${thread.length > 0 ? renderQaThread(thread) : ''}
  7085	      <div class="ca-help-respond">
  7086	        <input type="text" class="ca-help-input" placeholder="Type a response..." id="ca-help-input-${escAttr(key)}">
  7087	        <button class="btn-primary ca-help-send-btn" onclick="sendHelpResponse('${escAttr(key)}')">Respond</button>
  7088	      </div>
  7089	    </div>`;
  7090	  }
  7091	
  7092	  container.innerHTML = html;
  7093	}
  7094	
  7095	function toggleHqFilter() {
  7096	  hqFilterNeedsReply = !hqFilterNeedsReply;
  7097	  renderHelpQueue();
  7098	}
  7099	
  7100	function getTimeAgo(timestamp) {
  7101	  const now = Date.now();
  7102	  const then = new Date(timestamp).getTime();
  7103	  const diff = now - then;
  7104	  const mins = Math.floor(diff / 60000);
  7105	  if (mins < 1) return 'just now';
  7106	  if (mins < 60) return `${mins}m ago`;
  7107	  const hours = Math.floor(mins / 60);
  7108	  if (hours < 24) return `${hours}h ago`;
  7109	  const days = Math.floor(hours / 24);
  7110	  if (days === 1) return 'yesterday';
  7111	  return `${days}d ago`;
  7112	}
  7113	
  7114	// Shared by sendHelpResponse() and sendQaReply() below — seeds arrayUnion's
  7115	// argument list with the legacy teacherNotes/adminResponse thread on a
  7116	// lesson's FIRST atomic-append reply, so that legacy content isn't silently
  7117	// lost the moment qaThread gets its first real entry. arrayUnion's deep-
  7118	// equality dedup makes repeating this migration from concurrent senders safe.
  7119	function buildQaThreadUnionArgs(existingLesson, newEntry) {
  7120	  const needsMigration = !existingLesson?.qaThread || existingLesson.qaThread.length === 0;
  7121	  return needsMigration ? [...getQaThread(existingLesson || {}), newEntry] : [newEntry];
  7122	}
  7123	
  7124	// Backtracking audit Phase 11 fix: both admin Q&A reply functions used to
  7125	// resave the ENTIRE cached semester via saveLessonData() — a Firestore
  7126	// set({merge:true}) of every lesson currently sitting in this admin's
  7127	// browser, not just the one being replied to. If a teacher's save landed on
  7128	// the server in the split-second before this admin's live listener caught
  7129	// up, that reply would silently revert the teacher's edit back to this
  7130	// admin's stale cached copy — for ANY lesson in the semester, not just the
  7131	// one in the reply. Now a single targeted Firestore .update() touching only
  7132	// this lesson's own field paths, with arrayUnion() for qaThread (survives a
  7133	// genuinely concurrent sender) and an existence check (a stale, long-open
  7134	// popup can't silently recreate a lesson deleted/moved elsewhere).
  7135	async function sendHelpResponse(key) {
  7136	  const input = document.getElementById(`ca-help-input-${key}`);
  7137	  if (!input) return;
  7138	  const response = input.value.trim();
  7139	  if (!response) return;
  7140	
  7141	  const semKey = getAdminSemKey();
  7142	  // Same load guard as every other lesson writer (Phase 1 review): after a
  7143	  // failed reload the listener deliberately KEEPS the previous summer maps, so
  7144	  // the cached lesson and the existence check both still pass — without this
  7145	  // an admin could write a reply while the banner says saving is disabled.
  7146	  if (lessonDataLoadedSuccessfully === false) {
  7147	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  7148	    return;
  7149	  }
  7150	  // A semester type this writer has no branch for is refused here, before the
  7151	  // existence check below — a throw inside that try would be reported to the
  7152	  // admin as "check your connection", which it isn't (Phase 1, 1.1).
  7153	  let lessonStore;
  7154	  try {
  7155	    lessonStore = lessonStoreFor(semKey);
  7156	  } catch (err) {
  7157	    alert(err.message);
  7158	    return;
  7159	  }
  7160	  const cachedExisting = currentLessonData?.[semKey]?.[key];
  7161	  if (!cachedExisting) return;
  7162	
  7163	  let check;
  7164	  try {
  7165	    check = await adminLessonStillExistsWithRetry(semKey, key);
  7166	  } catch (err) {
  7167	    console.warn('⚠️ Existence check retry also failed:', err);
  7168	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  7169	    return;
  7170	  }
  7171	  if (!check.exists) {
  7172	    alert('This lesson was moved or removed elsewhere. Your response was not sent — please close this and check the grid for its new location.');
  7173	    return;
  7174	  }
  7175	  const existing = check.data || cachedExisting;
  7176	
  7177	  const user = getAuthUser();
  7178	  const newEntry = {
  7179	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  7180	    from: 'admin', name: user?.name || 'Admin', message: response, timestamp: new Date().toISOString()
  7181	  };
  7182	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7183	
  7184	  if (!curriculumDb) initCurriculumFirestore();
  7185	  const isSummer = lessonStore === 'camp';
  7186	  const updates = {};
  7187	  if (isSummer) {
  7188	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7189	    updates.adminResponse = response;
  7190	    updates.status = 'In Progress';
  7191	    updates.lastUpdated = new Date().toISOString();
  7192	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7193	  } else {
  7194	    updates[`${semKey}.${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7195	    updates[`${semKey}.${key}.adminResponse`] = response;
  7196	    updates[`${semKey}.${key}.status`] = 'In Progress';
  7197	    updates.lastUpdated = new Date().toISOString();
  7198	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7199	  }
  7200	  const docRef = isSummer
  7201	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7202	    : curriculumDb.collection('curriculum').doc('lessonData');
  7203	
  7204	  try {
  7205	    await docRef.update(updates);
  7206	  } catch (err) {
  7207	    console.error('Error sending help response:', err);
  7208	    alert('Error sending response: ' + err.message);
  7209	    return;
  7210	  }
  7211	
  7212	  currentLessonData[semKey][key] = {
  7213	    ...existing, adminResponse: response,
  7214	    qaThread: [...(existing.qaThread && existing.qaThread.length > 0 ? existing.qaThread : getQaThread(existing)), newEntry],
  7215	    status: 'In Progress'
  7216	  };
  7217	  renderHelpQueue();
  7218	}
  7219	
  7220	async function sendQaReply(key) {
  7221	  const input = document.getElementById(`qa-reply-${key}`);
  7222	  if (!input) return;
  7223	  const message = input.value.trim();
  7224	  if (!message) return;
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
  7257	    alert('This lesson was moved or removed elsewhere. Your reply was not sent — please close this window and check the grid for its new location.');
  7258	    return;
  7259	  }
  7260	  const existing = check.data || cachedExisting;
  7261	
  7262	  const user = getAuthUser();
  7263	  const newEntry = {
  7264	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  7265	    from: 'admin', name: user?.name || 'Admin', message, timestamp: new Date().toISOString()
  7266	  };
  7267	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7268	
  7269	  if (!curriculumDb) initCurriculumFirestore();
  7270	  const isSummer = lessonStore === 'camp';
  7271	  const updates = {};
  7272	  if (isSummer) {
  7273	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7274	    updates.adminResponse = message;
  7275	    updates.lastUpdated = new Date().toISOString();
  7276	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7277	  } else {
  7278	    updates[`${semKey}.${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7279	    updates[`${semKey}.${key}.adminResponse`] = message;
  7280	    updates.lastUpdated = new Date().toISOString();
  7281	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7282	  }
  7283	  const docRef = isSummer
  7284	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7285	    : curriculumDb.collection('curriculum').doc('lessonData');
  7286	
  7287	  try {
  7288	    await docRef.update(updates);
  7289	  } catch (err) {
  7290	    console.error('Error sending Q&A reply:', err);
  7291	    alert('Error sending reply: ' + err.message);
  7292	    return;
  7293	  }
  7294	
  7295	  const updatedLesson = {
  7296	    ...existing, adminResponse: message,
  7297	    qaThread: [...(existing.qaThread && existing.qaThread.length > 0 ? existing.qaThread : getQaThread(existing)), newEntry]
  7298	  };
  7299	  currentLessonData[semKey][key] = updatedLesson;
  7300	  openDetailModal(updatedLesson, key, updatedLesson.teacher, updatedLesson.className, updatedLesson.weekNum);
  7301	}
  7302	
  7303	function toggleHelpQueue() {
  7304	  const content = document.getElementById('ca-help-content');
  7305	  content.style.display = content.style.display === 'none' ? 'block' : 'none';
  7306	}
  7307	
  7308	// ─── Change History ──────────────────────────────────
  7309	
  7310	async function renderChangeHistory() {
  7311	  const semKey = getAdminSemKey();
  7312	  if (!currentChangeLog) await loadChangeLog();
  7313	  const entries = currentChangeLog?.[semKey] || [];
  7314	  const container = document.getElementById('ca-history-content');
  7315	  if (!container) return;
  7316	
  7317	  if (entries.length === 0) {
  7318	    container.innerHTML = '<p class="ca-empty-hint">No changes recorded yet.</p>';
  7319	    return;
  7320	  }
  7321	
  7322	  // Stats
  7323	  const stats = { move: 0, swap: 0, cut: 0, paste: 0, copy: 0, edit: 0 };
  7324	  for (const entry of entries) {
  7325	    stats[entry.action] = (stats[entry.action] || 0) + 1;
  7470	    // a curriculum-admin appAccess staff member can see this Curriculum Admin
  7471	    // panel without being a manager, and would hit this on every load. That's
  7472	    // an access boundary, not a fault, so it gets a neutral note instead of
  7473	    // the "something's wrong" alarm below.
  7474	    if (err.code === 'permission-denied') {
  7475	      container.innerHTML = '<p class="ca-empty-hint">Backup status is visible to admins and managers only.</p>';
  7476	      return;
  7477	    }
  7478	    console.error('Error loading backup health:', err);
  7479	    container.innerHTML = '<p class="ca-backup-flag">⚠️ Failed to load backup status.</p>';
  7480	  }
  7481	}
  7482	
  7483	function toggleBackupHealth() {
  7484	  const content = document.getElementById('ca-backup-health-content');
  7485	  const wasHidden = content.style.display === 'none';
  7486	  content.style.display = wasHidden ? 'block' : 'none';
  7487	  if (wasHidden) renderBackupHealth();
  7488	}
  7489	
  7490	// ─── Content Count by Teacher (Data Safety Plan Stage 4A) ───────────
  7491	
  7492	// Same >10% drop threshold ~/tinker-backups/backup.js already uses for its
  7493	// own Tier-1 collection-level data-loss check — reused here for per-teacher
  7494	// consistency rather than inventing a second, unrelated threshold. A small
  7495	// routine edit (one lesson moved, one field trimmed) won't cross it; a real
  7496	// wipe of most of a teacher's content will.
  7497	const CONTENT_COUNT_DROP_THRESHOLD = 0.10;
  7498	
  7499	async function computeLiveContentCountByTeacher() {
  7500	  if (!curriculumDb) initCurriculumFirestore();
  7501	  const counts = {};
  7502	  const tally = (lesson) => {
  7503	    if (!lesson || !lesson.teacher || !lessonHasContent(lesson)) return;
  7504	    counts[lesson.teacher] = (counts[lesson.teacher] || 0) + 1;
  7505	  };
  7506	
  7507	  // Deliberately cross-season: this panel is the safety net that would notice
  7508	  // content vanishing from ANY season (per-season counting is Phase 4). But it
  7509	  // is still a summer read, so it obeys the same registry precondition as
  7510	  // every other one — no reads at all while the registry is unreadable.
  7511	  const registryMode = getSeasonRegistryMode();
  7512	  if (registryMode === 'error' || registryMode === 'unknown') {
  7513	    throw new Error(`Can't count summer content: the season registry is ${registryMode === 'unknown' ? 'unreachable' : 'unreadable'}.`);
  7514	  }
  7515	  const summerSnap = await curriculumDb.collection('summerCamps_lessonData').get();
  7516	  summerSnap.forEach(doc => tally(doc.data()));
  7517	
  7518	  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
  7519	  const lessonDataDoc = lessonDataSnap.exists ? lessonDataSnap.data() : {};
  7520	  for (const semesterLessons of Object.values(lessonDataDoc)) {
  7521	    if (!semesterLessons || typeof semesterLessons !== 'object') continue;
  7522	    for (const lesson of Object.values(semesterLessons)) tally(lesson);
  7523	  }
  7524	
  7525	  return counts;
  7526	}
  7527	
  7528	// Pure render — takes already-computed live and backup-derived per-teacher
  7529	// counts (backupCounts may be null if unavailable/inaccessible), so it's
  7530	// testable without a real Firestore read.
  7531	function renderContentCountData(liveCounts, backupCounts) {
  7532	  const container = document.getElementById('ca-content-count-content');
  7533	  if (!container) return;
  7534	
  7535	  const teachers = Array.from(new Set([
  7536	    ...Object.keys(liveCounts || {}),
  7537	    ...Object.keys(backupCounts || {}),
  7538	  ])).sort();
  7539	
  7540	  if (teachers.length === 0) {
  7541	    container.innerHTML = '<p class="ca-empty-hint">No lesson content recorded yet.</p>';
  7542	    return;
  7543	  }
  7544	
  7545	  let flaggedCount = 0;
  7546	  let rowsHtml = '';
  7547	  for (const teacher of teachers) {
  7548	    const today = liveCounts?.[teacher] || 0;
  7549	    const hasBaseline = !!backupCounts && typeof backupCounts[teacher] === 'number';
  7550	    const backupCount = hasBaseline ? backupCounts[teacher] : null;
  7551	    const isDrop = hasBaseline && backupCount > 0 &&
  7552	      ((backupCount - today) / backupCount) > CONTENT_COUNT_DROP_THRESHOLD;
  7553	    if (isDrop) flaggedCount++;
  7554	
  7555	    rowsHtml += `<tr>
  7556	      <td>${escHtml(teacher)}</td>
  7557	      <td>${today}</td>
  7558	      <td>${hasBaseline ? backupCount : '—'}</td>
  7559	      <td class="${isDrop ? 'ca-backup-flag' : ''}">${isDrop ? `⚠️ Dropped from ${backupCount} to ${today}` : 'OK'}</td>
  7560	    </tr>`;
  7561	  }
  7562	
  7563	  let html = '';
  7564	  if (!backupCounts) {
  7565	    html += '<p class="ca-empty-hint">No backup-derived comparison available yet.</p>';
  7566	  }
  7567	  if (flaggedCount > 0) {
  7568	    html += `<p class="ca-backup-flag">⚠️ ${flaggedCount} teacher${flaggedCount !== 1 ? 's' : ''} show a content-count drop of more than 10% since the last backup.</p>`;
  7569	  }
  7570	  html += `<div style="overflow-x:auto"><table class="ca-content-count-table">
  7571	    <thead><tr><th>Teacher</th><th>Today</th><th>Last Backup</th><th>Status</th></tr></thead>
  7572	    <tbody>${rowsHtml}</tbody>
  7573	  </table></div>`;
  7574	
  7575	  container.innerHTML = html;
  7576	}
  7577	
  7578	async function renderContentCount() {
  7579	  const container = document.getElementById('ca-content-count-content');
  7580	  if (!container) return;
  7581	  container.innerHTML = '<p class="ca-empty-hint">Loading content counts…</p>';
  7582	  try {
  7583	    const liveCounts = await computeLiveContentCountByTeacher();
  7584	    let backupCounts = null;
  7585	    try {
  7586	      if (!curriculumDb) initCurriculumFirestore();
  7587	      const snap = await curriculumDb.collection('backupStatus').doc('latest').get();
  7588	      backupCounts = snap.exists ? (snap.data().classbookContentByTeacher || null) : null;
  7589	    } catch (err) {
  7590	      // backupStatus is manager/admin-only (same boundary as Backup Health) —
  7591	      // degrade to "no comparison available" rather than blocking the live
  7592	      // counts, which this account can read regardless of that boundary.
  7593	      backupCounts = null;
  7594	    }
  7595	    renderContentCountData(liveCounts, backupCounts);
  7596	  } catch (err) {
  7597	    console.error('Error loading content counts:', err);
  7598	    container.innerHTML = '<p class="ca-backup-flag">⚠️ Failed to load content counts.</p>';
  7599	  }
  7600	}
  7601	
  7602	function toggleContentCount() {
  7603	  const content = document.getElementById('ca-content-count-content');
  7604	  const wasHidden = content.style.display === 'none';
  7605	  content.style.display = wasHidden ? 'block' : 'none';
  7606	  if (wasHidden) renderContentCount();
  7607	}
  7608	
  7609	
  7610	// ═════════════════════════════════════════════════════
  7611	// PREP DASHBOARD — Initialization
  7612	// ═════════════════════════════════════════════════════
  7613	
  7614	function initPrepDashboard() {
  7615	  if (prepInitialized) return;
  7616	  prepInitialized = true;
  7617	  setupWeekSelector();
  7618	  setupFilters();
  7619	  setupViewToggle();
  7620	  renderMaterialForecast();
 11280	        currentConfig.semesters[semKey].teacherNames = [...teacherNames, ...inUse.map(u => u.name).filter(n => !teacherNames.includes(n))];
 11281	        renderTeacherNamesList();
 11282	        alert(`Can't remove ${inUse.map(u => `${u.name} (on ${u.camps.join(', ')})`).join('; ')} — take them off those camps first.\n\nNothing was saved.`);
 11283	        return;
 11284	      }
 11285	      const outside = await dayOffDatesOutside(semKey, start, end);
 11286	      if (outside.length) {
 11287	        alert(`These day-off dates would fall outside the school year: ${outside.map(o => `${o.label} ${o.date}`).join(', ')}. Edit those events first.\n\nNothing was saved.`);
 11288	        return;
 11289	      }
 11290	    } catch (err) {
 11291	      alert(`Could not check the school year's camps and events: ${err.message}\n\nNothing was saved.`);
 11292	      return;
 11293	    }
 11294	  }
 11295	  const settingsPaths = settingsFieldPathsFor(semKey, {
 11296	    endDate: isDayOff ? el('settings-end-date') : undefined,
 11297	    name: el('settings-semester-name'),
 11298	    startDate: isDayOff ? el('settings-dayoff-start') : el('settings-start-date'),
 11299	    numWeeks: parseInt(el('settings-num-weeks')) || 16,
 11300	    breakWeeks,
 11301	    closureDates,
 11302	    teacherNames,
 11303	    classRoster,
 11304	  });
 11305	  // Keep this tab's copy in step with exactly what is being written.
 11306	  config.semesters[semKey] = { ...(config.semesters[semKey] || {}) };
 11307	  for (const [path, value] of Object.entries(settingsPaths)) {
 11308	    config.semesters[semKey][path.split('.').pop()] = value;
 11309	  }
 11310	
 11311	  // The two NON-semester fields this form also owns (Phase 1, 1.2). Dropping
 11312	  // them was a real regression: teacher mappings are collected by this form
 11313	  // and would have been silently lost on every Save.
 11314	  const extraPaths = {};
 11315	  // teacherMappings keeps its preserve-on-empty guard — an empty form must not
 11316	  // wipe existing mappings.
 11317	  if (Object.keys(teacherMappings).length > 0) extraPaths.teacherMappings = teacherMappings;
 11318	  // activeSemester is only ever SET when missing, never re-pointed from here.
 11319	  if (!currentConfig?.activeSemester) extraPaths.activeSemester = semKey;
 11320	
 11321	  try {
 11322	    await updateAppData({ ...settingsPaths, ...extraPaths });
 11323	    // Keep this tab's config in step with exactly what was written. Before
 11324	    // Phase 1 saveConfig() ended with `currentConfig = config`; dropping that
 11325	    // left the clone's semester edits stranded, so loadSettingsForm() redrew
 11326	    // pre-save values and the NEXT Save wrote them back over the server —
 11327	    // silently, with "Settings saved!" both times. currentConfig has no live
 11328	    // listener (setupConfigListener() is never called), so nothing else would
 11329	    // have corrected it.
 11330	    currentConfig.semesters = currentConfig.semesters || {};
 11331	    currentConfig.semesters[semKey] = currentConfig.semesters[semKey] || {};
 11332	    for (const [path, value] of Object.entries(settingsPaths)) {
 11333	      currentConfig.semesters[semKey][path.split('.').pop()] = value;
 11334	    }
 11335	    if (extraPaths.teacherMappings) currentConfig.teacherMappings = extraPaths.teacherMappings;
 11336	    if (extraPaths.activeSemester) currentConfig.activeSemester = extraPaths.activeSemester;
 11337	
 11338	    // Create lesson slots for classes assigned to teachers
 11339	    await createLessonSlotsForRoster(semKey, classRoster, config.semesters[semKey].numWeeks);
 11340	
 11341	    alert('Settings saved!');
 11342	
 11343	    // Reload Settings form to show updated teacher names in dropdowns
 11344	    loadSettingsForm();
 11345	
 11346	    // Reload other tabs if active
 11347	    const activeTab = document.querySelector('.tab-btn.active')?.dataset.tab;
 11348	    if (activeTab === 'prep-dashboard') {
 11349	      const weekNum = document.getElementById('week-select')?.value || 1;
 11350	      loadWeekData(parseInt(weekNum));
 11351	    }
 11352	  } catch (err) {
 11353	    console.error('Error saving settings:', err);
 11354	    alert('Error saving settings: ' + err.message);
 11355	  }
 11356	}
 11357	
 11358	// Backtracking audit, Phase 11 (R4-9, R4-12). Called unconditionally by
 11359	// saveSettings() after every Settings save. No try/catch here on purpose —
 11360	// the caller's own catch already reports "Error saving settings" correctly;
 11361	// a catch here produced a false "Settings saved!" (round-3 finding).
 11362	async function createLessonSlotsForRoster(semKey, roster, numWeeks) {
 11363	  // Skip if no roster or no weeks configured
 11364	  if (!roster || !numWeeks || Object.keys(roster).length === 0) {
 11365	    return;
 11366	  }
 11367	
 11368	  // R4-9: the correct signal is semesterType, not a key-prefix guess — an
 11369	  // ordinary roster semester named "Summer Enrichment 2027" is not a camp,
 11370	  // and the real summer-2026 camp semester MUST be skipped: its lesson
 11371	  // content is keyed teacher|||campTopic|||blockName|||projectTitle and
 11372	  // regenerated by loadSummerCampData() from the camp source collections,
 11373	  // entirely unrelated to classRoster. Without this gate, a Settings save
 11374	  // while viewing summer-2026 built garbage teacher-className-weekNum slots
 11375	  // into the live summer cache and then re-saved EVERY real summer lesson
 11376	  // (~600) from this admin's in-memory copy — re-stamping them all and
 11377	  // risking Firestore's 500-op batch limit. Nothing safe to do here for a camp.
 11378	  if (!isWeeklySemester(semKey)) return;   // Phase 1, 1.1 — only weekly semesters have a class roster; a third type is skipped by construction
 11379	
 11380	  if (!currentLessonData) await loadLessonData();
 11381	
 11382	  // R4-12: work on a copy and commit it to the live cache only after
 11383	  // persistence succeeds — previously `currentLessonData[semKey] = {}` was
 11384	  // assigned up front, so a failed save left a phantom empty semester key
 11385	  // in the cache even though nothing had been written.
 11386	  const lessons = { ...(currentLessonData[semKey] || {}) };
 11387	  let createdCount = 0;
 11388	
 11389	  // For each class in roster that has a teacher assigned
 11390	  for (const [className, data] of Object.entries(roster)) {
 11391	    if (!data.teacher || !className) continue;  // Skip if no teacher or no class name
 11392	
 11393	    const teacher = data.teacher;
 11394	
 11395	    // Check if lesson slots exist for this teacher-class combination
 11396	    for (let weekNum = 1; weekNum <= numWeeks; weekNum++) {
 11397	      const lessonKey = makeLessonKey(teacher, className, weekNum);
 11398	
 11399	      // If lesson doesn't exist, create it
 11400	      if (!lessons[lessonKey]) {
 11401	        lessons[lessonKey] = {
 11402	          teacher: teacher,
 11403	          className: className,
 11404	          weekNum: weekNum,
 11405	          weekDate: '',
 11406	          projectTitle: '',
 11407	          introPitch: '',
 11408	          processStep1: '',
 11409	          processStep2: '',
 11410	          processStep3: '',
 11411	          processStep4: '',
 11412	          closure: '',
 11413	          materials: '',
 11414	          materialsList: [],
 11415	          dayOfMaterials: '',
 11416	          qaThread: [],
 11417	          planComplete: false,
 11418	          classSize: String(data.enrollment || 0),
 11419	          lastEditedBy: '',
 11420	          lastEditedAt: ''
 11421	        };
 11422	        createdCount++;
 11423	      }
 11424	    }
 11425	  }
 11426	
 11427	  if (createdCount > 0) {
 11428	    await saveLessonData(semKey, lessons);
 11429	    currentLessonData[semKey] = lessons; // only commit locally after Firestore confirms
 11430	    console.log(`✅ Created ${createdCount} lesson slots for roster classes`);
   600	          (resource.data.createdBy == request.auth.uid
   601	            && (isManagerOrAbove()
   602	                || resource.data.get('sharedWith', []) == request.resource.data.get('sharedWith', [])))
   603	          // Manager/admin — any non-personal meeting, any field.
   604	          || (resource.data.business != 'personal' && isManagerOrAbove())
   605	          // Shared, non-manager user — tick action items and nothing else.
   606	          || (resource.data.business != 'personal'
   607	              // `in` also matches a MAP's keys — require a list so a
   608	              // malformed map-shaped sharedWith cannot grant this branch.
   609	              && resource.data.get('sharedWith', []) is list
   610	              && request.auth.uid in resource.data.get('sharedWith', [])
   611	              && onlyActionItemsChanged())
   612	        );
   613	
   614	      allow delete: if (isManagerOrAbove() || hasAppAccess('recap'))
   615	        && (
   616	          resource.data.createdBy == request.auth.uid
   617	          || (resource.data.business != 'personal' && isManagerOrAbove())
   618	        );
   619	    }
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
   653	      // Manager+: full access to everything including appData
   654	      allow read, write: if isManagerOrAbove();
   655	
   656	      // classbook-admin, curriculum-admin (legacy key), and classbook: full read/write except appData and prepCycleConfig
   657	      // appData (Settings) is manager+ only, always
   658	      // prepCycleConfig (Prep Cycle workflow config) is classbook-admin only
   659	      // NOTE: 'classbook' (plain teacher) access is intentionally NOT
   660	      // isolated per-teacher here — each semester's lessons live in one
   661	      // shared doc, and per-field isolation is enforced by the UI, not
   662	      // by these rules. This is a known, accepted gap (see
   663	      // firebase-agent-defense-hardening.md) pending a possible future
   664	      // data-model change, not something this rule can close on its own.
   665	      allow read: if hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook');
   666	      allow create, update: if
   667	        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook'))
   668	        && docId != 'appData'
   669	        && docId != 'prepCycleConfig';
   670	      // Whole-document delete is classbook-admin/curriculum-admin only.
   671	      // Plain 'classbook' (teacher) access never calls a full-document
   672	      // delete in the app (only FieldValue.delete() on specific lesson
   673	      // fields, which is an update, not a delete) — so this closes an
   674	      // unused, high-blast-radius capability with no functional change.
   675	      allow delete: if
   676	        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin'))
   677	        && docId != 'appData'
   678	        && docId != 'prepCycleConfig';
   679	      // prepCycleConfig: classbook-admin and curriculum-admin write only
   680	      allow create, update, delete: if
   681	        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin'))
   682	        && docId == 'prepCycleConfig';
   683	    }
   684	
   685	    // ═══════════════════════════════════════════════════════════════
   686	    // CLASSBOOK — SCHOOL DAY OFF CAMPS (SDOCs)
   687	    // Plan: tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html (Phase 1, §1.1)
   688	    //   dayOffCamps_events / dayOffCamps_camps: the admin's planning list for a school year.
   689	    //     classbook-admin (+ manager+) write, plain classbook teachers read.
   690	    //   dayOffCamps_lessonData: one shared plan per camp-project. Teachers create/update like
   691	    //     summerCamps_lessonData (per-teacher isolation is UI-enforced — the same accepted gap as
   692	    //     summer); whole-document delete is admin-only, like /curriculum's delete clause.
   693	    //   The legacy 'curriculum-admin' key is deliberately NOT extended to these new collections.
   694	    //   Visibility of an unpublished year is UI gating only: every classbook teacher can read these.
   695	    // ═══════════════════════════════════════════════════════════════
   696	
   697	    match /dayOffCamps_events/{docId} {
   698	      allow read: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
   699	      allow create, update, delete: if isManagerOrAbove() || hasAppAccess('classbook-admin');
   700	    }
   701	
   702	    match /dayOffCamps_camps/{docId} {
   703	      allow read: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
   704	      allow create, update, delete: if isManagerOrAbove() || hasAppAccess('classbook-admin');
   705	    }
   706	
   707	    match /dayOffCamps_lessonData/{docId} {
   708	      allow read: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
   709	      allow create, update: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
   710	      allow delete: if isManagerOrAbove() || hasAppAccess('classbook-admin');
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
   561	    // Teacher questions - ALL unanswered questions (immediate alerts)
   562	    const classbookListener = db.collection('curriculum')
   563	      .doc('lessonData')
   564	      .onSnapshot(doc => {
   565	        if (!doc.exists) return;
   566	
   567	        const data = doc.data();
   568	        const now = Date.now();
   569	        let unansweredQuestions = [];
   570	        const currentClassbookAlertIds = [];
   571	
   572	        // Iterate through all semesters
   573	        for (const [semKey, lessons] of Object.entries(data)) {
   574	          // Skip metadata fields
   575	          if (semKey === 'lastUpdated' || semKey === 'lastUpdatedBy') continue;
   576	          if (!lessons || typeof lessons !== 'object') continue;
   577	
   578	          // Iterate through all lessons in this semester
   579	          for (const [lessonKey, lesson] of Object.entries(lessons)) {
   580	            if (!lesson.qaThread || !Array.isArray(lesson.qaThread)) continue;
   581	
   582	            // Check if last message is from teacher (unanswered)
   583	            const thread = lesson.qaThread;
   584	            if (thread.length === 0) continue;
   585	
   586	            const lastMsg = thread[thread.length - 1];
   587	            if (lastMsg.from === 'teacher') {
   588	              // This is an unanswered question
   589	              const questionDate = lastMsg.timestamp?.toMillis ? lastMsg.timestamp.toMillis() :
   590	                                  lastMsg.timestamp ? new Date(lastMsg.timestamp).getTime() : 0;
   591	
   592	              const alertId = `classbook-qa-${lessonKey}`;
   593	              currentClassbookAlertIds.push(alertId);
   594	
   595	              // Calculate priority based on age (or use warning if no timestamp)
   596	              let priority = 'warning';
   597	              let timeText = 'Unknown time';
   598	
   599	              if (questionDate > 0) {
   600	                const hoursElapsed = Math.floor((now - questionDate) / (1000 * 60 * 60));
   601	                timeText = `${hoursElapsed}h ago`;
   602	
   603	                // Priority based on age: info (0-24h), warning (25-48h), urgent (49h+)
   604	                if (hoursElapsed >= 49) {
   605	                  priority = 'urgent';
   606	                } else if (hoursElapsed >= 25) {
   607	                  priority = 'warning';
   608	                } else {
   609	                  priority = 'info';
   610	                }
   611	              }
   612	
   613	              const questionText = lastMsg.message || lastMsg.question || 'Question';
   614	              const teacherName = lesson.teacher || lastMsg.name || 'Teacher';
   615	
   616	              const alert = {
   617	                id: alertId,
   618	                type: 'curriculum',
   619	                priority: priority,
   620	                title: `${teacherName}: ${questionText.substring(0, 50)}${questionText.length > 50 ? '...' : ''}`,
     1	#!/usr/bin/env node
     2	/**
     3	 * Automated Firestore backup for Tinker HQ
     4	 * Reads OAuth tokens from Firebase CLI config — no service account needed.
     5	 * Run via launchd every 30 min M-F 9:30am–5pm.
     6	 */
     7	
     8	const fs = require('fs');
     9	const path = require('path');
    10	const os = require('os');
    11	const { execFileSync } = require('child_process');
    12	
    13	const BACKUP_DIR = path.join(os.homedir(), 'tinker-backups');
    14	const LOG_FILE = path.join(BACKUP_DIR, 'logs', 'backup.log');
    15	const PROJECT_ID = 'tinker-hq-apps';
    16	const MAX_BACKUPS = 96; // keep last 96 = 2 days of 30-min backups
    17	
    18	// Off-project independent copy — see firebase-managed-backup-baseline.md Section 3.
    19	// firebase-adminsdk-fbsvc / tinker-ticker-notification hold no IAM in this project,
    20	// so nothing app/deploy-side can ever reach or delete what lands here.
    21	const VAULT_PROJECT = 'tinker-hq-vault';
    22	const VAULT_BUCKET = 'tinker-hq-vault-backups';
    23	const VAULT_MARKER = path.join(BACKUP_DIR, '.last-vault-upload');
    24	const VAULT_UPLOAD_INTERVAL_MS = 6 * 24 * 60 * 60 * 1000; // weekly
    25	
    26	// Tier 1 collections — see firebase-managed-backup-baseline.md Section 1.
    27	// A count drop here bigger than DATA_LOSS_THRESHOLD between two runs (with no
    28	// explicit bulk-delete flag) is treated as possible data loss, not just a crash.
    29	const DATA_LOSS_THRESHOLD = 0.10;
    30	const TIER1_COLLECTIONS = [
    31	  'timeclock_entries', 'timeclock_schedules', 'timeclock_timeoff', 'timeclock_overrides',
    32	  'timeclock_hfwa', 'timeclock_streaks', 'timeclock_settings', 'payroll',
    33	  'summerCamps_lessonData', 'summerCamps_curriculum', 'summerCamps_projectDetails',
    34	  'summerCamps_materialsHub', 'summerCamps_schedule', 'summerCamps_projectLibrary',
    35	  'summerCamps_stockItems', 'summerCamps_needToOrder', 'summerCamps_prepHelpQueue',
    36	  'summerCamps_weeklyPrep', 'summerCamps_settings', 'summerCamps_daysOff',
    37	  'summerCamps_team', 'summerCamps_openStudio', 'summerCamps_campComplete',
    38	  'summerCamps_kidNotes', 'summerCamps_notesNextYear', 'curriculum',
    39	  // The season registry: two docs, but they decide whether BOTH summer apps run filtered or in
    40	  // legacy mode, so a count drop here is worth waking up for. Empty until the Phase 1 migration
    41	  // runs, which is fine — checkForDataLoss() skips a collection whose previous count was 0.
    42	  'summerCamps_seasons',
    43	  // Classbook School Day Off Camps: events + camps are hand-entered planning data, not caches.
    44	  'dayOffCamps_events', 'dayOffCamps_camps', 'dayOffCamps_lessonData',
    45	  // Membership Manager's members (the source for My Clay Hub) and staff accounts. Added 2026-09-27.
    46	  'clayHub_members', 'users',
    47	];
    48	
    49	// Collections to back up — every top-level collection with a rule in
    50	// studio-hub/firestore.rules as of 2026-08-03. Cheap to cover everything since
    51	// it's the same script; only Tier 1 (above) gets count-drop verification.
    52	const COLLECTIONS = [
    53	  // Shared / Auth
    54	  'users', 'staffDirectory',
    55	  // Classbook / Summer Camp App (shared collections)
    56	  'curriculum', 'summerCamps_curriculum', 'summerCamps_projectDetails',
    57	  'summerCamps_projectLibrary', 'summerCamps_materialsHub', 'summerCamps_stockItems',
    58	  'summerCamps_needToOrder', 'summerCamps_prepHelpQueue', 'summerCamps_weeklyPrep',
    59	  'summerCamps_schedule', 'summerCamps_settings', 'summerCamps_notesNextYear',
    60	  'summerCamps_daysOff', 'summerCamps_team', 'summerCamps_openStudio',
    61	  'summerCamps_campComplete', 'summerCamps_lessonData', 'summerCamps_kidNotes',
    62	  'summerCamps_seasons',
    63	  'dayOffCamps_events', 'dayOffCamps_camps', 'dayOffCamps_lessonData',
    64	  // Clay Hub (Membership Manager + Inventory). Clay Hub Booking was retired 2026-09-27;
    65	  // its five collections were exported (21 docs) and deleted.
    66	  'clayHub_members', 'clayHub_waitlist', 'clayHub_appData', 'clayInventory',
    67	  // Tinker Ticker (timeclock)
    68	  'timeclock_entries', 'timeclock_timeoff', 'timeclock_hfwa', 'timeclock_overrides',
    69	  'timeclock_schedules', 'timeclock_settings', 'timeclock_streaks', 'payroll',
    70	  // Hiring Pipeline
    71	  'hiring',
    72	  // KPI Dashboard
    73	  'kpiData',
    74	  // Private Events + Schedule Viewer
    75	  'privateEvents', 'privateEventsSettings', 'scheduleData',
    76	  // Supply Low List
    77	  'supplyList',
    78	  // Materials Locator
    79	  'materials',
    80	  // Roster Manager
    81	  'rosterManager',
    82	  // Tinker Playbook
    83	  'playbooks',
    84	  // Tinker Notes
    85	  'quickNotes', 'quickNotes_settings',
    86	  // Recap (Meeting Transcription)
    87	  'meetings', 'threads', 'series', 'recapData',
    88	  // Training Hub
    89	  'trainingModules', 'trainingPrograms', 'trainingAssignments', 'trainingEmailLogs',
    90	  'trainingObservations', 'trainingObservationSchedule',
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
   416	        backup.collections[col] = docs;
   417	        const count = Object.keys(docs).length;
   418	        totalDocs += count;
   419	        log(`  ${col}: ${count} docs`);
   420	      } catch (err) {
   421	        log(`  WARNING: Failed to back up ${col}: ${err.message}`);
   422	        errorCollections.push(col);
   423	      }
   424	    }
   425	
   426	    const ts = new Date().toISOString().replace(/:/g, '-').replace(/\..+/, '');
   427	    const filename = `tinker-backup-${ts}.json`;
   428	    const outPath = path.join(BACKUP_DIR, filename);
   429	    fs.writeFileSync(outPath, JSON.stringify(backup, null, 2));
   430	
   431	    const elapsed = ((Date.now() - startMs) / 1000).toFixed(1);
   432	    log(`✅ Backup complete: ${filename} (${totalDocs} docs, ${elapsed}s)`);
   433	
   434	    // Count-drop verification — catches "rules regression → app silently writes
   435	    // fewer docs" the same day, not just an outright script crash.
   436	    const currentCounts = {};
   437	    for (const [col, docs] of Object.entries(backup.collections)) {
   438	      currentCounts[col] = Object.keys(docs).length;
   439	    }
   440	    const dataLossWarnings = checkForDataLoss(previousCounts, currentCounts);
   441	    if (dataLossWarnings.length > 0) {
   442	      const summary = dataLossWarnings
   443	        .map(w => `${w.collection}: ${w.previous} → ${w.current} (-${Math.round(w.dropPct * 100)}%)`)
   444	        .join('; ');
   445	      log(`⚠️ POSSIBLE DATA LOSS: ${summary}`);
   446	      notify('⚠️ Tinker Backup — possible data loss', summary.slice(0, 200));
   447	      await sendEmailAlert('⚠️ TINKER BACKUP FAILED — possible data loss', `Collections with a >${Math.round(DATA_LOSS_THRESHOLD * 100)}% document-count drop since the last successful backup:\n\n${summary}\n\nIf this was an intentional bulk delete, create an empty file at ~/tinker-backups/.bulk-delete-approved to silence this check until you remove it again.`);
   448	    }
   449	
   450	    // Weekly off-project copy — see firebase-managed-backup-baseline.md Section 3.
   451	    // No-ops with a warning until the tinker-hq-vault bucket exists.
   452	    if (shouldRunWeeklyVaultUpload()) {
   453	      try {
   454	        await uploadToVault(token, filename, outPath);
   455	        fs.writeFileSync(VAULT_MARKER, new Date().toISOString());
   456	        log('✅ Weekly vault upload complete');
   457	      } catch (err) {
   458	        log(`WARNING: Weekly vault upload failed (expected until the vault bucket exists): ${err.message}`);
   459	      }
   460	    }
   461	
   462	    // Status doc — single place to check backup health without opening a JSON file.
   463	    const statusData = {
   464	      lastSuccessAt: new Date().toISOString(),
   465	      docCount: totalDocs,
   466	      collectionsBackedUp: COLLECTIONS.length,
   467	      errorCollections,
   468	      dataLossWarningCollections: dataLossWarnings.map(w => w.collection),
   469	    };
   470	    try {
   471	      statusData.classbookContentByTeacher = computeClassbookContentByTeacher(backup.collections);
   472	    } catch (err) {
   473	      log(`WARNING: Classbook content-by-teacher tally failed (isolated, does not affect the backup itself): ${err.message}`);
   474	    }
   475	    try {
   476	      await writeBackupStatus(token, statusData);
   477	    } catch (err) {
   478	      log(`WARNING: backupStatus write failed: ${err.message}`);
   479	    }
   480	
   481	    pruneOldBackups();
   482	  } catch (err) {
   483	    log(`❌ Backup FAILED: ${err.message}`);
   484	    notify('⚠️ Tinker Backup Failed', err.message);
   485	    await sendEmailAlert('⚠️ TINKER BACKUP FAILED', `Backup script failed: ${err.message}`);
   486	    process.exit(1);
   487	  }
   488	}
   489	
   490	main();

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/studio-hub/firestore.rules | sed -n '620,690p'
nl -ba /Users/christiehubley/studio-hub/rules.test.js | sed -n '1,340p'
rg -n \"curriculum|lessonData|classbook|curriculum-admin|manager\" /Users/christiehubley/studio-hub/rules.test.js" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
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
   653	      // Manager+: full access to everything including appData
   654	      allow read, write: if isManagerOrAbove();
   655	
   656	      // classbook-admin, curriculum-admin (legacy key), and classbook: full read/write except appData and prepCycleConfig
   657	      // appData (Settings) is manager+ only, always
   658	      // prepCycleConfig (Prep Cycle workflow config) is classbook-admin only
   659	      // NOTE: 'classbook' (plain teacher) access is intentionally NOT
   660	      // isolated per-teacher here — each semester's lessons live in one
   661	      // shared doc, and per-field isolation is enforced by the UI, not
   662	      // by these rules. This is a known, accepted gap (see
   663	      // firebase-agent-defense-hardening.md) pending a possible future
   664	      // data-model change, not something this rule can close on its own.
   665	      allow read: if hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook');
   666	      allow create, update: if
   667	        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook'))
   668	        && docId != 'appData'
   669	        && docId != 'prepCycleConfig';
   670	      // Whole-document delete is classbook-admin/curriculum-admin only.
   671	      // Plain 'classbook' (teacher) access never calls a full-document
   672	      // delete in the app (only FieldValue.delete() on specific lesson
   673	      // fields, which is an update, not a delete) — so this closes an
   674	      // unused, high-blast-radius capability with no functional change.
   675	      allow delete: if
   676	        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin'))
   677	        && docId != 'appData'
   678	        && docId != 'prepCycleConfig';
   679	      // prepCycleConfig: classbook-admin and curriculum-admin write only
   680	      allow create, update, delete: if
   681	        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin'))
   682	        && docId == 'prepCycleConfig';
   683	    }
   684	
   685	    // ═══════════════════════════════════════════════════════════════
   686	    // CLASSBOOK — SCHOOL DAY OFF CAMPS (SDOCs)
   687	    // Plan: tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html (Phase 1, §1.1)
   688	    //   dayOffCamps_events / dayOffCamps_camps: the admin's planning list for a school year.
   689	    //     classbook-admin (+ manager+) write, plain classbook teachers read.
   690	    //   dayOffCamps_lessonData: one shared plan per camp-project. Teachers create/update like
     1	/**
     2	 * Firestore Security Rules Test Suite
     3	 * Run: npm test
     4	 *
     5	 * Each test simulates a specific user type + action + collection
     6	 * and asserts whether it should be allowed or denied.
     7	 *
     8	 * Users:
     9	 *   adminUser    — role: 'admin'
    10	 *   managerUser  — role: 'manager'
    11	 *   staffWithKpi — role: 'staff', appAccess: ['kpi']
    12	 *   staffNoAccess — role: 'staff', appAccess: []
    13	 *   kioskUser    — special kiosk UID
    14	 *   otherUser    — role: 'staff', appAccess: ['timeclock']  (used for ownership tests)
    15	 *   classbookAdminUser — role: 'staff', appAccess: ['classbook-admin']
    16	 *   trainingUser, otherTrainingUser — role: 'staff', appAccess: ['training']
    17	 *   summerCampUser — role: 'staff', appAccess: ['summer-camp']
    18	 *   archivedAdminUser — role: 'admin', active: false
    19	 *   archivedManagerUser — role: 'manager', active: false
    20	 *   archivedStaffUser — role: 'staff', active: false, appAccess: ['kpi','timeclock','clay-membership'], studios: ['tinker','clayhub']
    21	 */
    22	
    23	const { initializeTestEnvironment, assertFails, assertSucceeds } = require('@firebase/rules-unit-testing');
    24	const { doc, getDoc, setDoc, updateDoc, deleteDoc, deleteField, increment, collection, addDoc, query, where, getDocs, runTransaction, serverTimestamp, orderBy, limit, documentId } = require('firebase/firestore');
    25	const fs = require('fs');
    26	
    27	const PROJECT_ID = 'tinker-hq-test';
    28	const KIOSK_UID = '06ooFxutK5YTaJvu5SkywY9gZqh2';
    29	// Tinker Ticker's 48-hour shift-reminder job (reminders@tinkerartstudio.com) — pinned by uid in isReminderBot()
    30	const REMINDER_BOT_UID = 'JO8U8EYw2tgVBbsUXvbqNrbCPlh1';
    31	
    32	// UIDs
    33	const ADMIN_UID = 'admin-uid';
    34	const MANAGER_UID = 'manager-uid';
    35	const STAFF_KPI_UID = 'staff-kpi-uid';
    36	const STAFF_NOACCESS_UID = 'staff-noaccess-uid';
    37	const STAFF_TIMECLOCK_UID = 'staff-timeclock-uid';
    38	const OTHER_TIMECLOCK_UID = 'other-timeclock-uid';
    39	const CLASSBOOK_UID = 'classbook-uid';
    40	const RECAP_UID = 'recap-uid';
    41	const OTHER_RECAP_UID = 'other-recap-uid';
    42	const CLASSBOOK_ADMIN_UID = 'classbook-admin-uid';
    43	const TRAINING_UID = 'training-uid';
    44	const OTHER_TRAINING_UID = 'other-training-uid';
    45	// A third training-enabled staff user, used to prove the sharedWith MEMBERSHIP condition:
    46	// denying someone who also lacks Training Hub access would only prove the appAccess clause.
    47	const THIRD_TRAINING_UID = 'third-training-uid';
    48	const SUMMER_CAMP_UID = 'summer-camp-uid';
    49	const CURRICULUM_ADMIN_ONLY_UID = 'curriculum-admin-only-uid';   // legacy key, no 'classbook'
    50	const ARCHIVED_CLASSBOOK_UID = 'archived-classbook-uid';
    51	// Season-registry audience: the two users the Summer Camp App admits who are NOT
    52	// summer-camp-access staff — a prep-role user and someone whose only grant is `team`.
    53	const SUMMER_PREP_UID = 'summer-prep-uid';
    54	const TEAM_ONLY_UID = 'team-only-uid';
    55	const STAFF_ENROLLMENT_UID = 'staff-enrollment-uid';
    56	const ARCHIVED_ADMIN_UID = 'archived-admin-uid';
    57	const ARCHIVED_MANAGER_UID = 'archived-manager-uid';
    58	const ARCHIVED_STAFF_UID = 'archived-staff-uid';
    59	// Dedicated, single-use fixtures for tests whose assertSucceeds() call performs
    60	// a REAL, persisted write against the emulator — never reused by a later test
    61	// that expects the original state, to avoid order-dependent test pollution
    62	// (same reasoning as this file's existing brand-new-uid/-2/-3/-4 fixtures).
    63	const DISPOSABLE_ADMIN_FOR_ARCHIVE_UID = 'disposable-admin-for-archive-uid';
    64	const DISPOSABLE_ARCHIVED_ADMIN_FOR_REACTIVATE_UID = 'disposable-archived-admin-for-reactivate-uid';
    65	const DISPOSABLE_STAFF_FOR_ARCHIVE_UID = 'disposable-staff-for-archive-uid';
    66	const DISPOSABLE_ARCHIVED_MANAGER_FOR_REACTIVATE_UID = 'disposable-archived-manager-for-reactivate-uid';
    67	
    68	let testEnv;
    69	
    70	beforeAll(async () => {
    71	  testEnv = await initializeTestEnvironment({
    72	    projectId: PROJECT_ID,
    73	    firestore: {
    74	      rules: fs.readFileSync('firestore.rules', 'utf8'),
    75	      host: 'localhost',
    76	      port: 8080,
    77	    },
    78	  });
    79	
    80	  // Seed user docs so helper functions (isAdmin, isManager, hasAppAccess) work
    81	  await testEnv.withSecurityRulesDisabled(async (ctx) => {
    82	    const db = ctx.firestore();
    83	    await setDoc(doc(db, 'users', ADMIN_UID),         { role: 'admin',   studios: ['tinker', 'clayhub'], appAccess: [] });
    84	    await setDoc(doc(db, 'users', MANAGER_UID),        { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [] });
    85	    await setDoc(doc(db, 'users', STAFF_KPI_UID),      { role: 'staff',   studios: ['tinker'],            appAccess: ['kpi'] });
    86	    await setDoc(doc(db, 'users', STAFF_NOACCESS_UID), { role: 'staff',   studios: ['tinker'],            appAccess: [] });
    87	    await setDoc(doc(db, 'users', STAFF_TIMECLOCK_UID),{ role: 'staff',   studios: ['tinker'],            appAccess: ['timeclock'] });
    88	    await setDoc(doc(db, 'users', OTHER_TIMECLOCK_UID),{ role: 'staff',   studios: ['tinker'],            appAccess: ['timeclock'] });
    89	    await setDoc(doc(db, 'users', CLASSBOOK_UID),      { role: 'staff',   studios: ['tinker'],            appAccess: ['classbook'] });
    90	    await setDoc(doc(db, 'users', RECAP_UID),          { role: 'staff',   studios: ['tinker'],            appAccess: ['recap'] });
    91	    await setDoc(doc(db, 'users', OTHER_RECAP_UID),    { role: 'staff',   studios: ['tinker'],            appAccess: ['recap'] });
    92	    await setDoc(doc(db, 'users', CLASSBOOK_ADMIN_UID),{ role: 'staff',   studios: ['tinker'],            appAccess: ['classbook-admin'] });
    93	    await setDoc(doc(db, 'users', TRAINING_UID),       { role: 'staff',   studios: ['tinker'],            appAccess: ['training'] });
    94	    await setDoc(doc(db, 'users', OTHER_TRAINING_UID), { role: 'staff',   studios: ['tinker'],            appAccess: ['training'] });
    95	    await setDoc(doc(db, 'users', THIRD_TRAINING_UID), { role: 'staff',   studios: ['tinker'],            appAccess: ['training'] });
    96	    await setDoc(doc(db, 'users', SUMMER_CAMP_UID),    { role: 'staff',   studios: ['tinker'],            appAccess: ['summer-camp'] });
    97	    await setDoc(doc(db, 'users', SUMMER_PREP_UID),    { role: 'prep',    studios: ['tinker'],            appAccess: ['summer-camp'] });
    98	    await setDoc(doc(db, 'users', TEAM_ONLY_UID),      { role: 'staff',   studios: ['tinker'],            appAccess: ['team'] });
    99	    await setDoc(doc(db, 'users', STAFF_ENROLLMENT_UID),{ role: 'staff',  studios: ['tinker', 'clayhub'], appAccess: ['enrollment-board'] });
   100	    await setDoc(doc(db, 'users', ARCHIVED_ADMIN_UID),   { role: 'admin',   studios: ['tinker', 'clayhub'], appAccess: [], active: false });
   101	    await setDoc(doc(db, 'users', ARCHIVED_MANAGER_UID), { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [], active: false });
   102	    await setDoc(doc(db, 'users', CURRICULUM_ADMIN_ONLY_UID), { role: 'staff', studios: ['tinker'], appAccess: ['curriculum-admin'] });
   103	    await setDoc(doc(db, 'users', ARCHIVED_CLASSBOOK_UID),    { role: 'staff', studios: ['tinker'], appAccess: ['classbook', 'classbook-admin'], active: false });
   104	    await setDoc(doc(db, 'users', ARCHIVED_STAFF_UID),   { role: 'staff',   studios: ['tinker', 'clayhub'], appAccess: ['kpi', 'timeclock', 'clay-membership'], active: false });
   105	    await setDoc(doc(db, 'users', DISPOSABLE_ADMIN_FOR_ARCHIVE_UID),             { role: 'admin',   studios: ['tinker', 'clayhub'], appAccess: [] });
   106	    await setDoc(doc(db, 'users', DISPOSABLE_ARCHIVED_ADMIN_FOR_REACTIVATE_UID), { role: 'admin',   studios: ['tinker', 'clayhub'], appAccess: [], active: false });
   107	    await setDoc(doc(db, 'users', DISPOSABLE_STAFF_FOR_ARCHIVE_UID),             { role: 'staff',   studios: ['tinker'],            appAccess: [] });
   108	    await setDoc(doc(db, 'users', DISPOSABLE_ARCHIVED_MANAGER_FOR_REACTIVATE_UID), { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [], active: false });
   109	
   110	    // Seed a schedule for the reminder-bot tests (read shape + the log's exists() check). Never written
   111	    // by any test that expects it afterwards.
   112	    await setDoc(doc(db, 'timeclock_schedules', 'reminder-sched-uid'), { name: 'Grey', recurring: {}, overrides: { '2026-10-17': { start: '10:00', end: '14:00', studio: 'tinker', remind: true, remindUid: 'reminder-sched-uid' } } });
   113	    await setDoc(doc(db, 'timeclock_settings', 'employees'), { roster: [{ id: 'emp_1', name: 'Grey', pin: '1234', active: true }] });
   114	    // Seed a RESOLVED claim so the "cannot touch a resolved claim" tests do not depend on order.
   115	    await setDoc(doc(db, 'timeclock_reminder_log', 'reminder-sched-uid_2026-10-01'), { uid: 'reminder-sched-uid', date: '2026-10-01', to: 'grey@example.com', shift: { start: '10:00', end: '14:00', studio: 'tinker', note: '' }, claimedAt: new Date(), sentAt: new Date(), attempts: 1 });
   116	    // Seed a timeclock entry owned by STAFF_TIMECLOCK_UID
   117	    await setDoc(doc(db, 'timeclock_entries', 'my-entry'),    { uid: STAFF_TIMECLOCK_UID, type: 'clockIn' });
   118	    // Seed a timeclock entry owned by OTHER_TIMECLOCK_UID
   119	    await setDoc(doc(db, 'timeclock_entries', 'other-entry'), { uid: OTHER_TIMECLOCK_UID, type: 'clockIn' });
   120	    // Seed a timeclock entry owned by ARCHIVED_STAFF_UID, so the archive-feature
   121	    // read-denial test below isolates the hasAppAccess() isActiveUser gate —
   122	    // without this, reading someone else's entry would be denied by the
   123	    // resource.data.uid == request.auth.uid ownership check instead, proving
   124	    // nothing about the archive feature.
   125	    await setDoc(doc(db, 'timeclock_entries', 'archived-staff-entry'), { uid: ARCHIVED_STAFF_UID, type: 'clockIn' });
   126	    // Seed a timeclock entry inside a period that is marked locked below
   127	    await setDoc(doc(db, 'timeclock_entries', 'locked-period-entry'), {
   128	      uid: STAFF_TIMECLOCK_UID, type: 'clockIn', date: '2026-01-05',
   129	    });
   130	    // Mark a pay period locked (mirrors the shape written by lockPayPeriod()
   131	    // in tinker-timeclock/js/firebase-data.js)
   132	    await setDoc(doc(db, 'timeclock_settings', 'lockedPeriods'), {
   133	      '2026-01-01_2026-01-14': { lockedAt: '2026-01-15T00:00:00.000Z', lockedBy: 'manager', employeeTotals: {} },
   134	    });
   135	
   136	    // Training Hub fixtures
   137	    await setDoc(doc(db, 'trainingModules', 'module-1'), { title: 'Kiln Safety' });
   138	    await setDoc(doc(db, 'trainingAssignments', 'assign-1'), { memberId: TRAINING_UID, moduleId: 'module-1' });
   139	    await setDoc(doc(db, 'trainingObservations', 'obs-1'), { memberId: TRAINING_UID, notes: 'Great session', status: 'published' });
   140	    // A manager's in-progress draft about the same staff member. Drafts are unfinished,
   141	    // unreviewed notes — the staff member must not be able to read one, even their own.
   142	    await setDoc(doc(db, 'trainingObservations', 'obs-draft'), { memberId: TRAINING_UID, notes: 'Unfinished growth notes', status: 'draft' });
   143	    // A legacy record with no status field at all, modelling a document written before
   144	    // status was enforced. Staff must fail CLOSED on it; the manager must NOT be locked out.
   145	    await setDoc(doc(db, 'trainingObservations', 'obs-nostatus'), { memberId: TRAINING_UID, notes: 'Legacy note, no status' });
   146	    // Another member's draft, so the cross-member case is covered for drafts too.
   147	    await setDoc(doc(db, 'trainingObservations', 'obs-other-draft'), { memberId: OTHER_TRAINING_UID, notes: 'About someone else', status: 'draft' });
   148	    // Shared with a non-manager coordinator (TRAINING_UID) -- a record about someone else.
   149	    await setDoc(doc(db, 'trainingObservations', 'obs-shared'), {
   150	      memberId: OTHER_TRAINING_UID, notes: 'Clay Hub teacher observation', status: 'published',
   151	      sharedWith: [TRAINING_UID]
   152	    });
   153	    // A DRAFT carrying a sharedWith list: must stay unreadable even by the named person.
   154	    await setDoc(doc(db, 'trainingObservations', 'obs-shared-draft'), {
   155	      memberId: OTHER_TRAINING_UID, notes: 'Unfinished', status: 'draft',
   156	      sharedWith: [TRAINING_UID]
   157	    });
   158	    // sharedWith written as a MAP. `in` tests map keys in rules, so without an `is list`
   159	    // guard this would grant THIRD_TRAINING_UID a read of someone else's observation.
   160	    await setDoc(doc(db, 'trainingObservations', 'obs-shared-map'), {
   161	      memberId: OTHER_TRAINING_UID, notes: 'Malformed share list', status: 'published',
   162	      sharedWith: { [THIRD_TRAINING_UID]: true }
   163	    });
   164	    // sharedWith as a bare string — another non-list shape that must fail closed.
   165	    await setDoc(doc(db, 'trainingObservations', 'obs-shared-string'), {
   166	      memberId: OTHER_TRAINING_UID, notes: 'Malformed share list', status: 'published',
   167	      sharedWith: THIRD_TRAINING_UID
   168	    });
   169	    await setDoc(doc(db, 'onboardingChecklists', 'checklist-1'), {
   170	      personId: 'person-1', backgroundCheckSent: true, campSafeSent: false,
   171	    });
   172	    await setDoc(doc(db, 'onboardingPeople', 'person-1'), { name: 'New Hire' });
   173	
   174	    // Summer Camp fixtures (shared curriculum + kid notes)
   175	    await setDoc(doc(db, 'summerCamps_curriculum', 'week-1'), { title: 'Week 1' });
   176	    await setDoc(doc(db, 'summerCamps_kidNotes', 'kid-1'), { name: 'Kid One', notes: [] });
   177	    await setDoc(doc(db, 'summerCamps_prepHelpQueue', 'queue-1'), { item: 'Glaze' });
   178	    // Season registry (summer-camp-app-seasons Phase 1 §1.1): one doc per summer, plus the
   179	    // single fixed _current doc. Read at startup by every active user, whatever their access.
   180	    await setDoc(doc(db, 'summerCamps_seasons', '2026'), {
   181	      season: '2026', name: 'Summer 2026',
   182	      startDate: '2026-05-26', endDate: '2026-08-11', numWeeks: 11,
   183	    });
   184	    await setDoc(doc(db, 'summerCamps_seasons', '_current'), { season: '2026' });
   185	    // Only ever deleted by the manager delete test — nothing else may depend on it.
   186	    await setDoc(doc(db, 'summerCamps_seasons', 'disposable-for-delete'), { season: '1999' });
   187	
   188	    // Seed a personal recap meeting owned by RECAP_UID
   189	    await setDoc(doc(db, 'meetings', 'personal-meeting'), {
   190	      createdBy: RECAP_UID,
   191	      business: 'personal',
   192	      title: 'Private note',
   193	    });
   194	    // Seed a non-personal recap meeting (no sharedWith field at all — also covers
   195	    // the "missing sharedWith doesn't error" case and the "unshared, not readable
   196	    // by a non-manager staff member" case)
   197	    await setDoc(doc(db, 'meetings', 'team-meeting'), {
   198	      createdBy: RECAP_UID,
   199	      business: 'tinker',
   200	      title: 'Team standup',
   201	    });
   202	    // Seed a non-personal recap meeting shared with OTHER_RECAP_UID
   203	    await setDoc(doc(db, 'meetings', 'shared-meeting'), {
   204	      createdBy: RECAP_UID,
   205	      business: 'tinker',
   206	      title: 'Shared standup',
   207	      sharedWith: [OTHER_RECAP_UID],
   208	    });
   209	    // Seed a non-personal recap meeting owned by OTHER_RECAP_UID, for update-rule
   210	    // bypass tests (a manager attempting to flip someone else's meeting to personal)
   211	    await setDoc(doc(db, 'meetings', 'other-recap-meeting'), {
   212	      createdBy: OTHER_RECAP_UID,
   213	      business: 'tinker',
   214	      title: 'Owned by other recap user',
   215	      sharedWith: [],
   216	    });
   217	    // Seed a legacy personal meeting created by a NON-admin (the exact pre-existing
   218	    // gap this rule closes for create, but must not regress for update/read/delete)
   219	    await setDoc(doc(db, 'meetings', 'legacy-personal-meeting'), {
   220	      createdBy: RECAP_UID,
   221	      business: 'personal',
   222	      title: 'Legacy personal note, non-admin creator',
   223	      sharedWith: [],
   224	    });
   225	
   226	    // ── Phase 3 fixtures (shared users can tick off action items) ──
   227	    // A shared, non-personal meeting WITH a summary, so the shared-user update
   228	    // branch's nested diff has something to compare against. Only ever used for
   229	    // writes that must be DENIED — a successful write would mutate it for later
   230	    // tests, so those seed a disposable document instead.
   231	    await setDoc(doc(db, 'meetings', 'shared-meeting-with-tasks'), {
   232	      createdBy: RECAP_UID,
   233	      business: 'tinker',
   234	      title: 'Shared ops sync',
   235	      sharedWith: [OTHER_RECAP_UID],
   236	      summary: {
   237	        beforeNextMeeting: [{ assignee: 'Maryssa', items: [{ text: 'Draft the doc', done: false }] }],
   238	        keyDiscussion: ['unrelated'],
   239	        decisionsLog: ['decided'],
   240	      },
   241	    });
   242	    // A personal meeting that, however it happened (malformed write, legacy
   243	    // document), carries a populated sharedWith. The read rule already hides it
   244	    // from the share target; the shared-write branch must deny on its own terms,
   245	    // because Firestore evaluates a write without first checking a read.
   246	    await setDoc(doc(db, 'meetings', 'personal-meeting-shared-by-mistake'), {
   247	      createdBy: RECAP_UID,
   248	      business: 'personal',
   249	      title: 'Never writable by the share target',
   250	      sharedWith: [OTHER_RECAP_UID],
   251	      summary: { beforeNextMeeting: [{ assignee: 'Maryssa', items: ['Draft the doc'] }] },
   252	    });
   253	    // A shared meeting with no summary field at all (still processing, or a
   254	    // legacy document). Nothing to tick, so the shared branch has nothing to
   255	    // allow — and must fail closed rather than error into anything else.
   256	    await setDoc(doc(db, 'meetings', 'shared-meeting-no-summary'), {
   257	      createdBy: RECAP_UID,
   258	      business: 'tinker',
   259	      title: 'Shared, still processing',
   260	      sharedWith: [OTHER_RECAP_UID],
   261	    });
   262	
   263	    // Seed a curriculum doc and the protected appData doc
   264	    await setDoc(doc(db, 'curriculum', 'spring-2026'), { title: 'Spring Curriculum' });
   265	    await setDoc(doc(db, 'curriculum', 'appData'),     { settings: true });
   266	  });
   267	});
   268	
   269	afterAll(async () => {
   270	  await testEnv.cleanup();
   271	});
   272	
   273	// Helper: get an authenticated Firestore context
   274	function getDb(uid, email) {
   275	  return testEnv.authenticatedContext(uid, email ? { email } : {}).firestore();
   276	}
   277	function getUnauthDb() {
   278	  return testEnv.unauthenticatedContext().firestore();
   279	}
   280	
   281	
   282	// ─── FINANCE — HARD LOCKED ───────────────────────────────────────────────────
   283	
   284	describe('Finance — payroll + bookkeeping', () => {
   285	  test('manager can read payroll', async () => {
   286	    const db = getDb(MANAGER_UID);
   287	    await assertSucceeds(getDoc(doc(db, 'payroll', 'some-doc')));
   288	  });
   289	
   290	  test('admin can read payroll', async () => {
   291	    const db = getDb(ADMIN_UID);
   292	    await assertSucceeds(getDoc(doc(db, 'payroll', 'some-doc')));
   293	  });
   294	
   295	  test('staff WITH kpi access cannot read payroll', async () => {
   296	    const db = getDb(STAFF_KPI_UID);
   297	    await assertFails(getDoc(doc(db, 'payroll', 'some-doc')));
   298	  });
   299	
   300	  test('staff with NO access cannot read payroll', async () => {
   301	    const db = getDb(STAFF_NOACCESS_UID);
   302	    await assertFails(getDoc(doc(db, 'payroll', 'some-doc')));
   303	  });
   304	
   305	  test('unauthenticated user cannot read payroll', async () => {
   306	    const db = getUnauthDb();
   307	    await assertFails(getDoc(doc(db, 'payroll', 'some-doc')));
   308	  });
   309	
   310	  test('staff cannot read bookkeeping', async () => {
   311	    const db = getDb(STAFF_NOACCESS_UID);
   312	    await assertFails(getDoc(doc(db, 'bookkeeping', 'some-doc')));
   313	  });
   314	
   315	  test('manager can write payroll', async () => {
   316	    const db = getDb(MANAGER_UID);
   317	    await assertSucceeds(setDoc(doc(db, 'payroll', 'test-write'), { amount: 100 }));
   318	  });
   319	
   320	  test('staff cannot write payroll', async () => {
   321	    const db = getDb(STAFF_NOACCESS_UID);
   322	    await assertFails(setDoc(doc(db, 'payroll', 'test-write'), { amount: 100 }));
   323	  });
   324	});
   325	
   326	
   327	// ─── FINANCE — PAYROLL SETTINGS HISTORY (append-only, transaction-tied) ──────
   328	// payroll/appData/settingsHistory/{histId}: a recovery log for the Payroll
   329	// Tool's settings. Manager+ may read and create; nobody may update or delete.
   330	// Every entry must be created inside the same transaction that writes the
   331	// parent's new settingsRev (getAfter tie), carry the caller's own email and a
   332	// server timestamp, and have exactly the declared shape.
   333	// Plan: ~/tinker-ai-configs/thoughts/plans/payroll-settings-safety-and-seasons.html (Phase 1)
   334	
   335	const MANAGER_EMAIL = 'manager@tinkerartstudio.com';
   336	const ADMIN_EMAIL = 'admin@tinkerartstudio.com';
   337	const STAFF_PAYROLL_APPACCESS_UID = 'staff-payroll-appaccess-uid';
   338	const SETTINGS_HISTORY_PARENT = ['payroll', 'appData'];
   339	const SETTINGS_HISTORY_COLL = ['payroll', 'appData', 'settingsHistory'];
   340	const SEEDED_HISTORY_ID = 'seeded-history-entry';
10: *   managerUser  — role: 'manager'
15: *   classbookAdminUser — role: 'staff', appAccess: ['classbook-admin']
19: *   archivedManagerUser — role: 'manager', active: false
34:const MANAGER_UID = 'manager-uid';
39:const CLASSBOOK_UID = 'classbook-uid';
42:const CLASSBOOK_ADMIN_UID = 'classbook-admin-uid';
49:const CURRICULUM_ADMIN_ONLY_UID = 'curriculum-admin-only-uid';   // legacy key, no 'classbook'
50:const ARCHIVED_CLASSBOOK_UID = 'archived-classbook-uid';
57:const ARCHIVED_MANAGER_UID = 'archived-manager-uid';
66:const DISPOSABLE_ARCHIVED_MANAGER_FOR_REACTIVATE_UID = 'disposable-archived-manager-for-reactivate-uid';
84:    await setDoc(doc(db, 'users', MANAGER_UID),        { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [] });
89:    await setDoc(doc(db, 'users', CLASSBOOK_UID),      { role: 'staff',   studios: ['tinker'],            appAccess: ['classbook'] });
92:    await setDoc(doc(db, 'users', CLASSBOOK_ADMIN_UID),{ role: 'staff',   studios: ['tinker'],            appAccess: ['classbook-admin'] });
101:    await setDoc(doc(db, 'users', ARCHIVED_MANAGER_UID), { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [], active: false });
102:    await setDoc(doc(db, 'users', CURRICULUM_ADMIN_ONLY_UID), { role: 'staff', studios: ['tinker'], appAccess: ['curriculum-admin'] });
103:    await setDoc(doc(db, 'users', ARCHIVED_CLASSBOOK_UID),    { role: 'staff', studios: ['tinker'], appAccess: ['classbook', 'classbook-admin'], active: false });
108:    await setDoc(doc(db, 'users', DISPOSABLE_ARCHIVED_MANAGER_FOR_REACTIVATE_UID), { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [], active: false });
133:      '2026-01-01_2026-01-14': { lockedAt: '2026-01-15T00:00:00.000Z', lockedBy: 'manager', employeeTotals: {} },
140:    // A manager's in-progress draft about the same staff member. Drafts are unfinished,
144:    // status was enforced. Staff must fail CLOSED on it; the manager must NOT be locked out.
148:    // Shared with a non-manager coordinator (TRAINING_UID) -- a record about someone else.
174:    // Summer Camp fixtures (shared curriculum + kid notes)
175:    await setDoc(doc(db, 'summerCamps_curriculum', 'week-1'), { title: 'Week 1' });
185:    // Only ever deleted by the manager delete test — nothing else may depend on it.
196:    // by a non-manager staff member" case)
210:    // bypass tests (a manager attempting to flip someone else's meeting to personal)
263:    // Seed a curriculum doc and the protected appData doc
264:    await setDoc(doc(db, 'curriculum', 'spring-2026'), { title: 'Spring Curriculum' });
265:    await setDoc(doc(db, 'curriculum', 'appData'),     { settings: true });
285:  test('manager can read payroll', async () => {
315:  test('manager can write payroll', async () => {
335:const MANAGER_EMAIL = 'manager@tinkerartstudio.com';
400:  test('manager can get a history entry', async () => {
405:  test('manager can list/query history', async () => {
425:  test('archived manager cannot read history', async () => {
431:  test('manager can create an entry inside the transaction that bumps the parent rev (real serverTimestamp)', async () => {
466:  test('archived manager cannot create history', async () => {
521:  test('manager cannot update a history entry', async () => {
526:  test('manager cannot delete a history entry', async () => {
551:  test('manager can read kpiData without appAccess', async () => {
559:// enrollment numbers (fill rates, teacher first names) behind the same manager+/appAccess
569:  test('manager can read enrollmentBoard/current without appAccess', async () => {
636:  test('manager can read any entry', async () => {
728:  test('staff with classbook access can read curriculum doc', async () => {
730:    await assertSucceeds(getDoc(doc(db, 'curriculum', 'spring-2026')));
733:  test('staff with classbook access can update curriculum doc', async () => {
735:    await assertSucceeds(updateDoc(doc(db, 'curriculum', 'spring-2026'), { updated: true }));
738:  test('staff with classbook access CANNOT update appData', async () => {
740:    await assertFails(updateDoc(doc(db, 'curriculum', 'appData'), { settings: false }));
743:  test('manager can update appData', async () => {
745:    await assertSucceeds(updateDoc(doc(db, 'curriculum', 'appData'), { settings: false }));
751:// Fix applied in this pass: plain 'classbook' (teacher) access previously
752:// could delete ANY curriculum doc outright — including another teacher's
755:// is an update), so restricting delete to classbook-admin/curriculum-admin
758:describe('Classbook — curriculum delete restricted to classbook-admin', () => {
761:      await setDoc(doc(ctx.firestore(), 'curriculum', 'delete-target'), { title: 'Section to delete' });
765:  test('plain classbook (teacher) access CANNOT delete a curriculum doc', async () => {
767:    await assertFails(deleteDoc(doc(db, 'curriculum', 'delete-target')));
770:  test('classbook-admin access CAN delete a curriculum doc', async () => {
772:    await assertSucceeds(deleteDoc(doc(db, 'curriculum', 'delete-target')));
775:  test('manager can delete a curriculum doc', async () => {
777:    await assertSucceeds(deleteDoc(doc(db, 'curriculum', 'delete-target')));
782:// Documented, accepted tradeoff (see the comment above the curriculum match
786:// curriculum data into per-teacher documents, which is a product/data-model
789:describe('Classbook — KNOWN GAP: any classbook-access teacher can write any other teacher\'s doc', () => {
790:  test('staff with classbook access can update a curriculum doc regardless of which teacher "owns" it', async () => {
795:    await assertSucceeds(updateDoc(doc(db, 'curriculum', 'spring-2026'), { touchedBy: 'someone-elses-teacher' }));
814:      appAccess: ['classbook-admin', 'payroll', 'training'],
837:      appAccess: ['classbook-admin'],
879:  // no request.auth.uid != userId guard, so a manager writing to THEIR OWN
883:  // clayInventory) doesn't accept isManagerOrAbove(), so a manager scoped to
885:  test('manager CANNOT self-grant studios via the manager-update rule (regression)', async () => {
892:  test('manager CANNOT self-grant appAccess via the manager-update rule (regression)', async () => {
899:  test('manager CAN still grant appAccess/studios to ANOTHER user (legitimate team management, unaffected by the fix)', async () => {
947:  test('manager CANNOT archive an admin (write active:false to an active admin doc)', async () => {
954:  test('manager CANNOT reactivate an admin (write active:true to an archived admin doc)', async () => {
961:  test('manager CAN archive another staff member (unchanged from existing appAccess/studios capability)', async () => {
968:  test('manager CAN reactivate another manager (unchanged from existing appAccess/studios capability)', async () => {
979:  // recovery path — same bug shape as the manager self-grant regression
1010:  test('archived manager cannot read payroll (previously isManagerOrAbove()-gated)', async () => {
1032:  test('manager can delete a training module', async () => {
1047:  test('manager can delete a training assignment', async () => {
1052:  test('staff cannot create/write an observation record about themselves (manager-authored only)', async () => {
1063:  // is a manager's unfinished, unreviewed assessment; the Training Hub only hides drafts
1072:  test('manager can read a draft observation record', async () => {
1119:  // ─── Sharing a single observation with a named non-manager ───
1148:  test('a manager can still read a malformed-sharedWith record', async () => {
1152:  // The whole point of the design: sharing is manager-written. Staff have no write on this
1210:  // ...but the manager branch never touches resource.data, so it must not be caught by the
1211:  // missing-field evaluation error. This is the lockout guard: managers keep full access.
1212:  test('manager can still read a status-less legacy observation', async () => {
1227:  // Guards the manager branch against a future edit adding a resource.data condition to it,
1228:  // which would break the manager's own observation list with nothing else noticing.
1229:  test('manager can run an unfiltered query including drafts', async () => {
1258:// appAccess('training') override for these collections: only manager+ can
1262:describe('Training Hub — onboarding/compliance collections are manager-only', () => {
1273:  test('manager can read and delete onboarding checklists', async () => {
1284:  test('staff with summer-camp access cannot delete shared curriculum (Classbook-shared data)', async () => {
1286:    await assertFails(deleteDoc(doc(db, 'summerCamps_curriculum', 'week-1')));
1289:  test('staff with classbook access cannot delete summer-camp curriculum either', async () => {
1291:    await assertFails(deleteDoc(doc(db, 'summerCamps_curriculum', 'week-1')));
1294:  test('manager can delete shared curriculum', async () => {
1296:    await assertSucceeds(deleteDoc(doc(db, 'summerCamps_curriculum', 'week-1')));
1312:  test('staff without summer-camp or classbook access cannot read summer camp curriculum', async () => {
1314:    await assertFails(getDoc(doc(db, 'summerCamps_curriculum', 'week-1')));
1329:    ['manager', () => MANAGER_UID],
1336:    ['staff with classbook access', () => CLASSBOOK_UID],
1337:    ['staff with classbook-admin access', () => CLASSBOOK_ADMIN_UID],
1365:    ['an archived manager', () => ARCHIVED_MANAGER_UID],
1378:describe('Summer Camp — only manager+ may write the season registry', () => {
1379:  test('a manager can create, update and delete a season doc', async () => {
1395:    ['staff with classbook access', () => CLASSBOOK_UID],
1396:    ['staff with classbook-admin access', () => CLASSBOOK_ADMIN_UID],
1398:    ['an archived manager', () => ARCHIVED_MANAGER_UID],
1406:  test('nobody below manager can move _current — the switch-on is a manager act', async () => {
1421:// left to the app, because a manager (or a migration resumed by hand) getting either one wrong
1482:  'summerCamps_curriculum', 'summerCamps_schedule', 'summerCamps_lessonData',
1539:      season: '2031', setAt: new Date().toISOString(), setBy: 'manager'
1545:    ['staff with classbook access', () => CLASSBOOK_UID]
1546:  ])('%s cannot run the migration — stamping is a manager+ write', async (_label, uid) => {
1548:    await assertFails(updateDoc(doc(db, 'summerCamps_curriculum', 'migration-fixture'), { season: '2026' }));
1562:  test('manager CANNOT read another user\'s personal meeting', async () => {
1567:  test('manager can read a non-personal meeting', async () => {
1577:  test('non-creator, non-manager, non-shared staff CANNOT read a non-personal meeting', async () => {
1580:    // doesn't throw on a missing field for a requester who fails the manager branch too.
1608:  test('manager cannot create a business:personal meeting', async () => {
1610:    await assertFails(setDoc(doc(db, 'meetings', 'disposable-manager-personal-create'), {
1629:  test('a manager cannot flip someone else\'s non-personal meeting to business:personal', async () => {
1662:// cannot be made a manager) and must tick off tasks on meetings Christie shares
1665:// non-manager user to change that and only that: no other top-level field in the
1742:  test('a user NOT in sharedWith (and not creator or manager) is still denied the same write', async () => {
1848:describe('Recap — Phase 3: the creator and manager branches are unchanged', () => {
1849:  test('a manager can still edit any field on a non-personal meeting they did not create', async () => {
1850:    await seedDisposableSharedMeeting('disposable-phase3-manager-edit');
1852:    await assertSucceeds(updateDoc(doc(db, 'meetings', 'disposable-phase3-manager-edit'), {
1853:      title: 'Renamed by manager',
1854:      'summary.keyDiscussion': ['rewritten by manager'],
1869:// ─── RECAP — sharedWith is pinned for non-manager creators ──────────────────
1871:// Sharing is a manager/admin call (UI-level since Sep 5, 2026). This closes the
1890:    // manager shares it. Second-review finding: no test covered absence.
1913:  test('a manager can still share someone else\'s non-personal meeting (the Share modal write)', async () => {
1914:    await seedDisposableSharedMeeting('disposable-phase3-manager-share', { sharedWith: [] });
1916:    await assertSucceeds(updateDoc(doc(db, 'meetings', 'disposable-phase3-manager-share'), {
1939:  test('a manager can create a meeting that is already shared', async () => {
1941:    await assertSucceeds(setDoc(doc(db, 'meetings', 'disposable-manager-create-shared'), {
1942:      createdBy: MANAGER_UID, business: 'tinker', title: 'Pre-shared by manager', sharedWith: [OTHER_RECAP_UID],
1946:  test('a manager can still share their OWN meeting', async () => {
1947:    await seedDisposableSharedMeeting('disposable-phase3-manager-own-share', { createdBy: MANAGER_UID, sharedWith: [] });
1949:    await assertSucceeds(updateDoc(doc(db, 'meetings', 'disposable-phase3-manager-own-share'), {
2010:    await assertFails(setDoc(doc(admin, 'users', REMINDER_BOT_UID), { role: 'manager', studios: ['tinker'], appAccess: [] }));
2013:    // so a manager-role doc still opens nothing, and the bot cannot patch it either.
2024:      await assertFails(updateDoc(doc(admin, 'users', REMINDER_BOT_UID), { role: 'manager' }));   // admin update of it: denied
2047:describe('Tinker Ticker — timeclock_reminder_log: the bot claims, resolves, and can do nothing else; managers read; staff never', () => {
2166:  test('managers and admins read the log (get + list); nobody else can, and nobody but the bot can write it', async () => {
2185:// Three collections: events + camps are classbook-admin planning data (teachers read);
2186:// plans (dayOffCamps_lessonData) are teacher create/update like summerCamps_lessonData, admin-only
2187:// delete. The legacy 'curriculum-admin' key is deliberately NOT granted on these new collections.
2188:// Plan: tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html (Phase 1, §1.1)
2189:const SDOC_COLLECTIONS = ['dayOffCamps_events', 'dayOffCamps_camps', 'dayOffCamps_lessonData'];
2190:const SDOC_ADMIN_WRITERS = [['admin', ADMIN_UID], ['manager', MANAGER_UID], ['classbook-admin', CLASSBOOK_ADMIN_UID]];
2193:  ['archived admin', ARCHIVED_ADMIN_UID], ['archived manager', ARCHIVED_MANAGER_UID], ['archived staff', ARCHIVED_STAFF_UID],
2195:  ['curriculum-admin only (legacy key)', CURRICULUM_ADMIN_ONLY_UID],
2196:  // Holds both classbook keys: only the active:false gate can deny it.
2197:  ['archived classbook + classbook-admin', ARCHIVED_CLASSBOOK_UID],
2219:    test('a plain classbook teacher can read and query by year', async () => {
2226:    test('a plain classbook teacher cannot delete', async () => {
2249:  test.each(['dayOffCamps_events', 'dayOffCamps_camps'])('a plain classbook teacher cannot create or update %s', async (coll) => {
2255:  // Plans are the teacher's to write (Phase 2), exactly as summerCamps_lessonData — per-teacher
2257:  test('a plain classbook teacher can create and update a plan', async () => {
2259:    await assertSucceeds(setDoc(doc(db, 'dayOffCamps_lessonData', 'teacher-new'), { yearKey: 'sdoc-2026-27', introPitch: 'hi' }));
2260:    await assertSucceeds(updateDoc(doc(db, 'dayOffCamps_lessonData', SDOC_SEED_ID), { introPitch: 'edited' }));
2323:// Reassign is manager-only in the UI; a staff creator reassigns by dragging in
2329:  test('a manager can reassign AND share in one write (beforeNextMeeting + sharedWith + share metadata)', async () => {
2485:  test.each([['Clay Hub staff', CLAY_MEMBERSHIP_STAFF_UID], ['a manager', MANAGER_UID], ['an admin', ADMIN_UID]])(
2495:  test.each([['Clay Hub staff', CLAY_MEMBERSHIP_STAFF_UID], ['a manager', MANAGER_UID], ['an admin', ADMIN_UID]])(
2538:  test('delete is unchanged: manager yes, Clay Hub staff no', async () => {
2558:  test('managers keep full access to waitlist and appData (shared helper refactor)', async () => {

exec
/bin/zsh -lc "nl -ba js/firebase-data.js | sed -n '950,1030p;1070,1210p;1360,1530p'
nl -ba js/app.js | sed -n '3600,3725p;4560,5010p;5560,6060p;7125,7310p;7490,7610p'
nl -ba /Users/christiehubley/studio-hub/js/alerts.js | sed -n '556,670p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
   950	      lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
   951	    });
   952	  } else {
   953	    await docRef.update({
   954	      qaThread: firebase.firestore.FieldValue.arrayUnion(newMsg),
   955	      status: isAdmin ? 'Resolved' : 'Open',
   956	      lastUpdated: firebase.firestore.FieldValue.serverTimestamp()
   957	    });
   958	  }
   959	}
   960	
   961	async function deleteLessonData(semesterKey) {
   962	  if (!curriculumDb) initCurriculumFirestore();
   963	  await curriculumDb.collection('curriculum').doc('lessonData').update({
   964	    [semesterKey]: firebase.firestore.FieldValue.delete()
   965	  });
   966	}
   967	
   968	// Forced-server read of one semester's whole lesson map in curriculum/lessonData
   969	// (null when absent). Bypasses both the in-memory model and the SDK cache —
   970	// used where the local cache is known to be untrustworthy for this key, e.g.
   971	// createNewSemester()'s pre-check (deleteSemester() drops a key locally even
   972	// when its server-side delete failed). Backtracking audit, Phase 11.
   973	async function readServerSemesterLessonMap(semesterKey) {
   974	  if (!curriculumDb) initCurriculumFirestore();
   975	  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
   976	  return snap.exists ? (snap.data()?.[semesterKey] ?? null) : null;
   977	}
   978	
   979	async function backupLessonData(semesterKey) {
   980	  if (!curriculumDb) initCurriculumFirestore();
   981	  const existing = currentLessonData?.[semesterKey];
   982	  if (!existing || Object.keys(existing).length === 0) return 0;
   983	  const count = Object.keys(existing).length;
   984	  const user = getAuthUser();
   985	  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
   986	    [semesterKey]: existing,
   987	    backupDate: new Date().toISOString(),
   988	    backupBy: user?.name || 'Unknown'
   989	  }, { merge: true });
   990	  return count;
   991	}
   992	
   993	async function restoreFromBackup(semesterKey) {
   994	  if (!curriculumDb) initCurriculumFirestore();
   995	  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
   996	  if (!backupDoc.exists) return null;
   997	  const backupData = backupDoc.data();
   998	  const lessons = backupData?.[semesterKey];
   999	  if (!lessons || Object.keys(lessons).length === 0) return null;
  1000	  await saveLessonData(semesterKey, lessons);
  1001	  return Object.keys(lessons).length;
  1002	}
  1003	
  1004	// "Which copy of a lesson is newer", by lastEditedAt — the only revision
  1005	// marker the data has (a client wall-clock heuristic: ties and missing values
  1006	// resolve to "not newer"). Shared by the listener merge below and the summer
  1007	// editor's own adoption/re-install logic (Backtracking audit Phase 10).
  1008	function lessonEditedAtMs(lesson) {
  1009	  return Date.parse(lesson?.lastEditedAt || '') || 0;
  1010	}
  1011	
  1012	// The fields a saved summerCamps_lessonData doc contributes to a lesson slot
  1013	// (everything else on the slot — teacher, camp, materials, sharedWith, class
  1014	// size… — is rebuilt from the other collections on every reload and must
  1015	// always come from the fresh read).
  1016	const SUMMER_SAVED_FIELDS = [...CONTENT_FIELDS, 'photoUrl', 'photoPath', 'planComplete', 'lastEditedBy', 'lastEditedAt'];
  1017	// A reload's read can only plausibly predate a save this recent; a stamp
  1018	// older than this — or further than this into the future — is a skewed clock
  1019	// or a doc deleted/restored underneath us, and the fresh read wins.
  1020	const SUMMER_KEEP_MINE_WINDOW_MS = 10 * 60 * 1000;
  1021	// When the merge keeps an in-memory copy, the server copy it displaced is
  1022	// parked here so the summer editor can fall back to it if the in-flight save
  1023	// that made the in-memory copy "newer" then fails (see openLessonModal()).
  1024	// Keyed by SEMESTER and lesson (Phase 1, 1.4): two camp seasons legitimately
  1025	// share a lesson key — same teacher, camp, block and project in 2026 and
  1026	// 2027 — and a single-keyed map would park one season's server copy under
  1027	// the other's, then hand it back to the wrong editor.
  1028	const displacedSummerServerCopies = new Map();
  1029	const displacedKey = (semKey, lessonKey) => `${semKey}|${lessonKey}`;
  1030	
  1070	    } else {
  1071	      displacedSummerServerCopies.delete(displacedKey(semKey, key));
  1072	    }
  1073	  }
  1074	  return fresh;
  1075	}
  1076	
  1077	// Backtracking audit Phase 7 (R2-10, R3-7, R4-10): every snapshot of the
  1078	// shared curriculum/lessonData doc re-runs the summer collection reload.
  1079	// Its outcome now drives the load-guard and the banner like the initial
  1080	// load does — a failure trips them, a later success resets them — and only
  1081	// the LATEST reload's outcome may do so: callbacks resolve out of order, and
  1082	// unsubscribing a listener does not cancel its in-flight callback, so the
  1083	// generation counter is module-scoped across every setupLessonDataListener()
  1084	// call (and bumped by the call itself, so an old listener's in-flight reload
  1085	// is stale from the moment it is replaced). A tripped guard blocks every
  1086	// writer in the app, so a failed reload is retried a bounded number of times
  1087	// on its own — a wifi blip self-heals, a real outage keeps the banner.
  1088	// Handed over by Phase 10: the summer cache is kept in place for the ~1.5 s
  1089	// the reload takes (it used to vanish, so the summer view rendered nothing
  1090	// and an in-flight save's optimistic entry had no map to live in), and the
  1091	// reload is merged per lesson keeping the newer copy (mergeSummerReload).
  1092	const SUMMER_RELOAD_RETRY_DELAYS_MS = [5000, 15000];
  1093	// The camp seasons currently in memory, by semester key.
  1094	function snapshotCampSeasons() {
  1095	  const out = {};
  1096	  for (const semKey of Object.keys(currentLessonData || {})) {
  1097	    if ((isCampSeason(semKey) || isDayOffYear(semKey)) && currentLessonData[semKey]) out[semKey] = currentLessonData[semKey];
  1098	  }
  1099	  return out;
  1100	}
  1101	
  1102	// Set by setupLessonDataListener() so a season-registry mode change (legacy →
  1103	// filtered, or unknown healing) re-runs the summer load through that
  1104	// listener's own generation-gated path — never a second, competing one
  1105	// (Phase 1, 1.3).
  1106	let summerReloadHook = null;
  1107	async function reloadSummerForModeChange() {
  1108	  if (typeof summerReloadHook !== 'function') return 'no-listener';
  1109	  return await summerReloadHook();
  1110	}
  1111	
  1112	function setupLessonDataListener(callback) {
  1113	  console.log('📚 Setting up lesson data listener...');
  1114	  if (!curriculumDb) initCurriculumFirestore();
  1115	  globalListenerGeneration++; // whatever the previous listener still has in flight is now stale
  1116	  if (lessonDataUnsubscribe) lessonDataUnsubscribe();
  1117	
  1118	  // One reload attempt for one snapshot generation. Only the latest
  1119	  // generation may touch the guard, the banner, or the summer cache.
  1120	  // Resolves 'ok' | 'failed' | 'stale'. Only 'stale' means this generation's
  1121	  // outcome was discarded (a newer snapshot took over while it ran).
  1122	  const reloadSummer = async (myGeneration, previousSummer, attempt) => {
  1123	    const isCurrent = () => myGeneration === globalListenerGeneration;
  1124	    try {
  1125	      console.log('📚 Attempting to load camp season data...' + (attempt ? ` (retry ${attempt})` : ''));
  1126	      const plans = campSeasonLoadPlan();
  1127	      const fresh = {};
  1128	      for (const plan of plans) fresh[plan.semKey] = await loadOneCampSeason(plan, { isCurrent });
  1129	      const dayOffKeys = dayOffYearKeys();
  1130	      for (const yearKey of dayOffKeys) fresh[yearKey] = await loadDayOffCampData({ yearKey, isCurrent });
  1131	      if (!isCurrent()) { console.log('📚 Camp season reload superseded by a newer snapshot — ignoring its result'); return 'stale'; }
  1132	      for (const yearKey of dayOffKeys) {
  1133	        currentLessonData[yearKey] = mergeSummerReload(yearKey, previousSummer?.[yearKey], fresh[yearKey]);
  1134	        healDayOffYearAfterReload(yearKey, fresh[yearKey]);
  1135	      }
  1136	      for (const plan of plans) {
  1137	        // Each season merges against ITS OWN previous map — mergeSummerReload
  1138	        // prunes parked copies that are absent from `fresh`, so merging one
  1139	        // season against another's would evict the other's on every reload.
  1140	        currentLessonData[plan.semKey] = mergeSummerReload(plan.semKey, previousSummer?.[plan.semKey], fresh[plan.semKey]);
  1141	      }
  1142	      console.log('📚 Camp seasons loaded:', plans.map(p => `${p.semKey}=${Object.keys(fresh[p.semKey]).length}`).join(' '));
  1143	      lessonDataLoadedSuccessfully = true;
  1144	      document.getElementById('lesson-load-error-banner')?.classList.add('hidden');
  1145	      return 'ok';
  1146	    } catch (err) {
  1147	      console.error('❌ Could not load camp season / day-off camp data:', err);
  1148	      if (!isCurrent()) return 'stale';
  1149	      lessonDataLoadedSuccessfully = false;
  1150	      document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
  1151	      const delay = SUMMER_RELOAD_RETRY_DELAYS_MS[attempt];
  1152	      if (delay !== undefined) {
  1153	        setTimeout(() => {
  1154	          if (!isCurrent()) return; // a newer snapshot has taken over
  1155	          reloadSummer(myGeneration, snapshotCampSeasons(), attempt + 1).then(outcome => { if (outcome === 'ok' && callback) callback(currentLessonData); });
  1156	        }, delay);
  1157	      }
  1158	      return 'failed';
  1159	    }
  1160	  };
  1161	
  1162	  // The registry-change entry point: same reload, same generation gate, and it
  1163	  // renders through the same callback when it is still the current generation.
  1164	  summerReloadHook = async () => {
  1165	    const myGeneration = ++globalListenerGeneration;
  1166	    const outcome = await reloadSummer(myGeneration, snapshotCampSeasons(), 0);
  1167	    if (outcome !== 'stale' && callback) callback(currentLessonData);
  1168	    return outcome;
  1169	  };
  1170	
  1171	  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
  1172	    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
  1173	      // Skip cache-only updates
  1174	      if (doc.metadata.fromCache && !doc.metadata.hasPendingWrites) {
  1175	        console.log('📚 Skipping cache-only snapshot, waiting for server data...');
  1176	        return;
  1177	      }
  1178	      console.log('📚 Lesson data snapshot received, from cache:', doc.metadata.fromCache, 'exists:', doc.exists);
  1179	      if (!doc.exists) return;
  1180	
  1181	      const myGeneration = ++globalListenerGeneration;
  1182	      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
  1183	      // in their own collection, so carry their current maps across the swap
  1184	      // and let the reload below refresh each one (Phase 1, 1.4).
  1185	      const previousSummer = snapshotCampSeasons();
  1186	      currentLessonData = doc.data();
  1187	      for (const [semKey, map] of Object.entries(previousSummer)) currentLessonData[semKey] = map;
  1188	      console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
  1189	
  1190	      const outcome = await reloadSummer(myGeneration, previousSummer, 0);
  1191	      // A superseded reload renders nothing — the newer snapshot's own
  1192	      // callback already did (or will), with the same live object. A failed
  1193	      // one still renders: the non-summer semesters in this snapshot are new.
  1194	      if (outcome !== 'stale' && callback) callback(currentLessonData);
  1195	    });
  1196	}
  1197	
  1198	// ─── Cut Projects (curriculum/cutProjects) ───────────
  1199	
  1200	async function loadCutProjects() {
  1201	  if (!curriculumDb) initCurriculumFirestore();
  1202	  try {
  1203	    const doc = await curriculumDb.collection('curriculum').doc('cutProjects').get();
  1204	    currentCutProjects = doc.exists ? doc.data() : {};
  1205	  } catch (err) {
  1206	    console.error('Error loading cut projects:', err);
  1207	    currentCutProjects = {};
  1208	  }
  1209	  return currentCutProjects;
  1210	}
  1360	// clear actually persists (Data Safety Plan Stage 3). This list is
  1361	// authoritative: it overrides whatever (possibly stale) value lessonData
  1362	// happens to carry for that key, since callers may still send the pre-edit
  1363	// value alongside a separate clear signal (see saveLesson()'s contentUpdates).
  1364	async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
  1365	  if (lessonDataLoadedSuccessfully === false) {
  1366	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  1367	  }
  1368	  if (!curriculumDb) initCurriculumFirestore();
  1369	  const user = getAuthUser();
  1370	  lessonData.lastEditedBy = user?.name || 'Unknown';
  1371	  lessonData.lastEditedAt = new Date().toISOString();
  1372	
  1373	  // SDOC plans (Phase 2B) branch here — after the stamp, so every SDOC write
  1374	  // (the narrow Plan complete one included) carries lastEditedBy/At — and
  1375	  // BEFORE lessonStoreFor(), which keeps throwing for the type: its other six
  1376	  // callers fall through to curriculum/lessonData on anything that isn't
  1377	  // 'camp', and that throw is what keeps an SDOC key out of it.
  1378	  if (isDayOffYear(semesterKey)) return saveDayOffPlan(semesterKey, lessonKey, lessonData, fieldsToClear, opts.dayOffAuth);
  1379	
  1380	  console.log('💾 Attempting to save lesson:', { semesterKey, lessonKey, user: user?.email });
  1381	
  1382	  const hasContent = lessonHasContent(lessonData);
  1383	  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above.
  1384	  const fieldsToActuallyClear = [...fieldsToClear];
  1385	
  1386	  // Route by type, never by key (Phase 1, 1.1).
  1387	  if (lessonStoreFor(semesterKey) === 'camp') {
  1388	    // A planComplete-only payload, a photo-only payload, or a save that's only
  1389	    // clearing a field, is a legitimate narrow save, not a stale-state wipe
  1390	    // attempt — only block when there's neither real content nor an explicit
  1391	    // planComplete flag nor a photo field nor a field being intentionally
  1392	    // cleared (Data Safety Plan Stage 2C/3; photo fields added by the
  1393	    // backtracking audit's Phase 10, whose summer editor now sends only the
  1394	    // fields it changed — a photo replacement arrives with no text at all).
  1395	    const hasPhotoField = 'photoUrl' in lessonData || 'photoPath' in lessonData;
  1396	    if (!hasContent && !hasPhotoField && !('planComplete' in lessonData) && fieldsToActuallyClear.length === 0) {
  1397	      console.warn('⛔ saveSingleLesson blocked — all content fields empty, refusing to overwrite:', lessonKey);
  1398	      return;
  1399	    }
  1400	    // Strip empty content fields so stale in-memory empty strings never overwrite
  1401	    // real content that a teacher saved previously (mirrors saveSummerCampLessonData).
  1402	    const stripped = { ...lessonData };
  1403	    CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
  1404	    const cleanData = JSON.parse(JSON.stringify(stripped));
  1405	    // Apply clears AFTER the JSON sanitization pass — FieldValue.delete() is a
  1406	    // special sentinel object that a JSON round-trip would corrupt.
  1407	    fieldsToActuallyClear.forEach(f => { cleanData[f] = firebase.firestore.FieldValue.delete(); });
  1408	    // Every summer doc this app writes carries its season (camp seasons Phase
  1409	    // 0). A plain string, so it goes after the round-trip — and after the
  1410	    // clears, so no clear list can ever strip the stamp.
  1411	    cleanData.season = seasonForSemester(semesterKey);
  1412	    console.log('💾 Saving Summer Camp lesson to summerCamps_lessonData:', lessonKey);
  1413	    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semesterKey, lessonKey));
  1414	    await docRef.set(cleanData, { merge: true });
  1415	    console.log('✅ Saved Summer Camp lesson:', lessonKey);
  1416	
  1417	    // Read back the content fields we just wrote, forced to the server — this
  1418	    // is the check that would have caught both original May 2026 wipe
  1419	    // incidents within seconds instead of days (Data Safety Plan Stage 2E).
  1420	    // Intentionally cleared fields are expected to read back missing, so
  1421	    // they're excluded here rather than flagged as a failed write.
  1422	    const writtenContentFields = CONTENT_FIELDS.filter(f => f in cleanData && !fieldsToActuallyClear.includes(f));
  1423	    if (writtenContentFields.length > 0) {
  1424	      await verifySummerLessonWrite(docRef, writtenContentFields);
  1425	    }
  1426	    return;
  1427	  }
  1428	
  1429	  // Regular semester: curriculum/lessonData is one shared doc across every
  1430	  // semester. update() with a whole object assigned to the bare
  1431	  // semesterKey.lessonKey path replaces the ENTIRE lesson there — so write
  1432	  // explicit per-field dotted paths instead, touching only the fields
  1433	  // actually present in lessonData (Data Safety Plan Stage 2D).
  1434	  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear);
  1435	
  1436	  console.log('💾 Saving to curriculum/lessonData with per-field paths:', Object.keys(updates));
  1437	  try {
  1438	    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
  1439	    console.log('✅ Successfully saved lesson to Firestore!');
  1440	  } catch (error) {
  1441	    console.error('❌ Error saving lesson:', error);
  1442	    throw error;
  1443	  }
  1444	}
  1445	
  1446	// Backtracking audit, Phase 9: pure helper — computes the dotted-path update
  1447	// object for ONE lesson within the shared curriculum/lessonData document,
  1448	// given an already-finalized lessonData object. Extracted from
  1449	// saveSingleLesson()'s non-summer branch above so it can be reused by
  1450	// saveMultipleLessonFields() below without duplicating the stripping/clearing
  1451	// logic. Strips empty content fields the same way the summer branch does, by
  1452	// omitting their dotted path entirely — never sending an explicit empty
  1453	// string — and applies clears AFTER the JSON sanitization pass, since
  1454	// FieldValue.delete() is a special sentinel a JSON round-trip would corrupt.
  1455	function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = []) {
  1456	  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above saveSingleLesson().
  1457	  const stripped = { ...lessonData };
  1458	  CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
  1459	  const cleanData = JSON.parse(JSON.stringify(stripped));
  1460	  fieldsToClear.forEach(f => { cleanData[f] = firebase.firestore.FieldValue.delete(); });
  1461	  const updates = {};
  1462	  for (const [field, value] of Object.entries(cleanData)) {
  1463	    updates[`${semesterKey}.${lessonKey}.${field}`] = value;
  1464	  }
  1465	  return updates;
  1466	}
  1467	
  1468	// Backtracking audit, Phase 9: combine multiple lesson writes and/or
  1469	// whole-lesson deletes into ONE atomic Firestore .update() call — either
  1470	// every write/delete in the call lands, or none do. Closes the
  1471	// PARTIAL-FAILURE race that move/swap's prior sequential-writes design was
  1472	// vulnerable to (does NOT independently verify the given lessonData reflects
  1473	// current server state — see Phase 9's note in the plan for the deliberately
  1474	// deferred, separately-tracked stale-input race).
  1475	async function saveMultipleLessonFields(semesterKey, writes = [], deletes = []) {
  1476	  if (lessonDataLoadedSuccessfully === false) {
  1477	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  1478	  }
  1479	  if (lessonStoreFor(semesterKey) === 'camp') {
  1480	    // Camp-season lessons live in a separate per-lesson-document collection — no
  1481	    // single-document atomicity is available across lessons there. Not
  1482	    // reachable today (the admin grid's move/swap UI is gated away from
  1483	    // summer semesters), but this guard exists so a future caller can't
  1484	    // silently get a false sense of atomicity if that ever changes.
  1485	    throw new Error('saveMultipleLessonFields() does not support camp seasons — use saveSingleLesson() per lesson instead.');
  1486	  }
  1487	  if (!curriculumDb) initCurriculumFirestore();
  1488	  const user = getAuthUser();
  1489	  const combined = {};
  1490	  for (const { lessonKey, lessonData, fieldsToClear } of writes) {
  1491	    lessonData.lastEditedBy = user?.name || 'Unknown';
  1492	    lessonData.lastEditedAt = new Date().toISOString();
  1493	    Object.assign(combined, buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear || []));
  1494	  }
  1495	  for (const lessonKey of deletes) {
  1496	    combined[`${semesterKey}.${lessonKey}`] = firebase.firestore.FieldValue.delete();
  1497	  }
  1498	  combined.lastUpdated = new Date().toISOString();
  1499	  combined.lastUpdatedBy = user?.name || 'Unknown';
  1500	  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
  1501	}
  1502	
  1503	// ─── Photo Upload (Firebase Storage) ─────────────────
  1504	
  1505	function getFirebaseStorage() {
  1506	  // Single init path: initFirebaseApp() (js/firebase-config.js) is the one
  1507	  // place that knows whether this page is in emulator mode, so a bare
  1508	  // initializeApp(FIREBASE_CONFIG) here could point Storage at production
  1509	  // while Firestore sits on the emulator.
  1510	  initFirebaseApp();
  1511	  return firebase.storage();
  1512	}
  1513	
  1514	// Backtracking audit, Phase 5 (R3-5, R3-6, R4-7): every upload gets a path
  1515	// that is unique PER UPLOAD, not per lesson. With a deterministic path the
  1516	// replacement upload overwrote the live object before Firestore confirmed
  1517	// the save (a failed save then pointed at a photo that no longer existed),
  1518	// a swap could put one lesson's replacement on top of the other lesson's
  1519	// still-referenced object, and the summer modal's "delete the old path"
  1520	// step deleted the object it had just uploaded. Callers keep the OLD path,
  1521	// save, then delete it only after a confirmed save (see saveTeacherEdit(),
  1522	// saveAdminEdit(), and the summer modal's saveLesson()). Date.now() alone is
  1523	// millisecond resolution — the random suffix keeps two near-simultaneous
  1524	// uploads for the same lesson apart.
  1525	function uniquePhotoSuffix() {
  1526	  return `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
  1527	}
  1528	
  1529	function getPhotoPath(semesterKey, lessonKey /* filename: ignored — resizeImage() always re-encodes to JPEG */) {
  1530	  // Store at curriculum/{semester}/{lessonKey}/demo-{unique}.jpg
  3600	    if (autoSaveStatus) { autoSaveStatus.textContent = '⚠️ Save failed'; autoSaveStatus.style.color = 'var(--error)'; }
  3601	  }
  3602	}
  3603	
  3604	// Backtracking audit Phase 10 (R3-3, R4-5): this used to rebuild the whole
  3605	// Q&A thread from the modal's lesson object and hand the ENTIRE lesson to
  3606	// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
  3607	// silently dropped any message (or any other field) another client had
  3608	// landed since this modal opened. Now a single targeted .update() touching
  3609	// only this lesson's own Q&A paths, with arrayUnion() for the thread — the
  3610	// same atomic-append design sendHelpResponse()/sendQaReply() already use —
  3611	// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
  3612	// record. `modalSemKey` is the semester the modal was opened under: the
  3613	// global selector can change while the modal stays open, and a dotted-path
  3614	// update under the wrong semester would create a Q&A-only ghost lesson there.
  3615	async function sendTeacherQaMessage(lessonKey, modalSemKey) {
  3616	  const input = document.getElementById('te-qa-input');
  3617	  if (!input) return;
  3618	  const message = input.value.trim();
  3619	  if (!message) return;
  3620	  // Same load-guard saveSingleLesson() enforced on the old path — after a
  3621	  // failed load the cache is empty, so the legacy-thread migration below
  3622	  // would run blind against whatever is really on the server.
  3623	  if (lessonDataLoadedSuccessfully === false) {
  3624	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  3625	    return;
  3626	  }
  3627	
  3628	  const semKey = modalSemKey || getTvSemKey();
  3629	  // This modal never hosts a camp season (the Today View routes those to the
  3630	  // summer editor, whose Q&A lives in summerCamps_prepHelpQueue), so a write
  3631	  // under that key into curriculum/lessonData is never right. Routed by TYPE
  3632	  // now (Phase 1, 1.1) — a third type is refused out loud rather than written
  3633	  // into the shared weekly document.
  3634	  let lessonStore;
  3635	  try {
  3636	    lessonStore = lessonStoreFor(semKey);
  3637	  } catch (err) {
  3638	    alert(err.message);
  3639	    return;
  3640	  }
  3641	  if (lessonStore === 'camp') {
  3642	    alert('Summer camp questions are sent from the camp lesson editor.');
  3643	    return;
  3644	  }
  3645	
  3646	  // Confirm the lesson still exists on the server (an admin may have moved or
  3647	  // deleted it since this modal opened). A dotted-path update would otherwise
  3648	  // recreate the old key as a Q&A-only ghost lesson. Same forced read and
  3649	  // accepted check-to-write residual as sendHelpResponse()/sendQaReply().
  3650	  let check;
  3651	  try {
  3652	    check = await adminLessonStillExistsWithRetry(semKey, lessonKey);
  3653	  } catch (err) {
  3654	    console.warn('⚠️ Existence check retry also failed:', err);
  3655	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  3656	    return;
  3657	  }
  3658	  if (!check.exists) {
  3659	    alert('This lesson was moved or removed elsewhere. Your message was not sent — please close this and check the classbook for its new location.');
  3660	    return;
  3661	  }
  3662	  const existing = check.data;
  3663	
  3664	  const user = getAuthUser();
  3665	  const isAdmin = ['admin', 'manager'].includes(user?.role);
  3666	  const newEntry = {
  3667	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  3668	    from: isAdmin ? 'admin' : 'teacher',
  3669	    name: user?.name || 'Unknown',
  3670	    message,
  3671	    timestamp: new Date().toISOString()
  3672	  };
  3673	  // The fresh server copy decides whether a legacy teacherNotes/adminResponse
  3674	  // thread still needs migrating into qaThread on this lesson's first entry.
  3675	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  3676	  const editedAt = new Date().toISOString();
  3677	  const editedBy = user?.name || 'Unknown';
  3678	
  3679	  const updates = {
  3680	    [`${semKey}.${lessonKey}.qaThread`]: firebase.firestore.FieldValue.arrayUnion(...entriesToAdd),
  3681	    [`${semKey}.${lessonKey}.lastEditedBy`]: editedBy,
  3682	    [`${semKey}.${lessonKey}.lastEditedAt`]: editedAt,
  3683	  };
  3684	  // Legacy mirror fields, kept for compatibility with older readers.
  3685	  const legacyField = isAdmin ? 'adminResponse' : 'teacherNotes';
  3686	  updates[`${semKey}.${lessonKey}.${legacyField}`] = message;
  3687	
  3688	  try {
  3689	    if (!curriculumDb) initCurriculumFirestore();
  3690	    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
  3691	  } catch (err) {
  3692	    console.error('Error sending Q&A message:', err);
  3693	    alert('Error sending message: ' + err.message);
  3694	    return;
  3695	  }
  3696	
  3697	  // Confirmed — make sure the local cache shows the new message before the
  3698	  // live listener catches up. Usually the listener already HAS: a local
  3699	  // write triggers a latency-compensated snapshot (with the arrayUnion
  3700	  // applied) before the server ack resolves the await above, so the entry
  3701	  // is deduplicated by id rather than appended blindly — a duplicate here
  3702	  // would be persisted by the next autosave, which writes the cached
  3703	  // qaThread back as a whole array.
  3704	  if (currentLessonData?.[semKey]?.[lessonKey]) {
  3705	    const cached = currentLessonData[semKey][lessonKey];
  3706	    const baseThread = cached.qaThread && cached.qaThread.length > 0 ? cached.qaThread : getQaThread(cached);
  3707	    const alreadyThere = baseThread.some(m => m.id === newEntry.id);
  3708	    currentLessonData[semKey][lessonKey] = {
  3709	      ...cached,
  3710	      qaThread: alreadyThere ? baseThread : [...baseThread, newEntry],
  3711	      [legacyField]: message,
  3712	      lastEditedBy: editedBy,
  3713	      lastEditedAt: editedAt,
  3714	    };
  3715	  }
  3716	  input.value = '';
  3717	  // Re-open the modal to show the updated thread — only if the Today View is
  3718	  // still on this modal's semester; otherwise it would open a different
  3719	  // semester's lesson under the same key.
  3720	  if (getTvSemKey() === semKey) openTeacherEditModal(lessonKey);
  3721	}
  3722	
  3723	// ─── Q&A Reply Notification Banner ───────────────
  3724	
  3725	// The read-mark carries the semester (Phase 1, 1.4): two camp seasons share
  4560	  // semester the server still has — with no alert and no re-render to show it
  4561	  // (Phase 1 review).
  4562	  const removed = currentConfig.semesters[key];
  4563	  delete currentConfig.semesters[key];
  4564	  try {
  4565	    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
  4566	  } catch (err) {
  4567	    currentConfig.semesters[key] = removed;
  4568	    console.error('❌ Could not remove the semester:', err);
  4569	    alert(`Could not remove "${sem.name}": ${err.message}\n\nNothing was changed.`);
  4570	    renderSemesterSelector();
  4571	    return;
  4572	  }
  4573	
  4574	  // Drop this season's in-memory map either way…
  4575	  if (currentLessonData?.[key]) {
  4576	    delete currentLessonData[key];
  4577	  }
  4578	  // …but only a WEEKLY semester has lessons of its own inside
  4579	  // curriculum/lessonData to delete. A camp season's lessons live in the
  4580	  // shared summerCamps_* collections and are never touched from here.
  4581	  if (isDayOff) {
  4582	    delete currentDayOffEvents[key]; delete currentDayOffCamps[key]; delete currentDayOffPlans[key]; delete currentDayOffSignoffs[key];
  4583	  } else if (!isCamp) {
  4584	    try {
  4585	      await deleteLessonData(key);
  4586	    } catch (e) { console.warn('Could not delete lesson data for', key, e); }
  4587	  }
  4588	
  4589	  // Switch to active semester
  4590	  caCurrentSemester = currentConfig.activeSemester;
  4591	  renderSemesterSelector();
  4592	  renderAdminGrid();
  4593	  renderHelpQueue();
  4594	  renderCutBank();
  4595	  renderIdeaBank();
  4596	  renderChangeHistory();
  4597	}
  4598	
  4599	function switchAdminSemester(key) {
  4600	  // Delegates to global semester — CA always stays in sync with the header selector
  4601	  setGlobalSemester(key);
  4602	}
  4603	
  4604	async function toggleSemesterPublish(key, published) {
  4605	  if (!currentConfig?.semesters?.[key]) return;
  4606	  if (!isPublishableType(key)) { alert('This semester type can\'t be published.'); return; }
  4607	  // SDOC (Phase 2B): publishing shows the year to every teacher on a camp —
  4608	  // say so first if some camps have nobody to see them.
  4609	  if (published && isDayOffYear(key)) {
  4610	    // The camp list below must be real to warn from — never publish on a failed load.
  4611	    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
  4612	    const bare = (currentDayOffCamps[key] || []).filter(c => !(c.teachers || []).length).length;
  4613	    if (bare && !confirm(`${bare} camp${bare === 1 ? ' has' : 's have'} no teacher yet — publish anyway?`)) { renderSemesterSelector(); return; }
  4614	  }
  4615	  const hadPublished = 'published' in currentConfig.semesters[key];
  4616	  const previous = currentConfig.semesters[key].published;
  4617	  currentConfig.semesters[key].published = published;
  4618	  try {
  4619	    await updateAppData({ [`semesters.${key}.published`]: published });
  4620	  } catch (err) {
  4621	    // Restore exactly what was there — including "the field was absent".
  4622	    if (currentConfig.semesters[key]) {
  4623	      if (hadPublished) currentConfig.semesters[key].published = previous;
  4624	      else delete currentConfig.semesters[key].published;
  4625	    }
  4626	    console.error('❌ Could not change the publish state:', err);
  4627	    alert(`Could not ${published ? 'publish' : 'unpublish'} that semester: ${err.message}\n\nNothing was changed.`);
  4628	  }
  4629	  renderSemesterSelector();
  4630	}
  4631	
  4632	// Which types may be published to teachers. SDOC years joined in Phase 2B,
  4633	// when teachers got their day-off plans to build.
  4634	const PUBLISHABLE_SEMESTER_TYPES = new Set([SEMESTER_TYPES.weekly, SEMESTER_TYPES.camp, SEMESTER_TYPES.dayOff]);
  4635	function isPublishableType(semKey) { return PUBLISHABLE_SEMESTER_TYPES.has(semesterTypeOf(semKey)); }
  4636	
  4637	function openNewSemesterModal() {
  4638	  document.getElementById('ca-new-semester-modal')?.classList.add('open');
  4639	  // Reset to the default type each time, then load the seasons on offer.
  4640	  const weeklyRadio = document.querySelector('input[name="new-sem-type"][value="weekly"]');
  4641	  if (weeklyRadio) weeklyRadio.checked = true;
  4642	  onNewSemesterTypeChange();
  4643	  populateNewSemesterSeasons();
  4644	  document.getElementById('new-sem-name')?.focus();
  4645	}
  4646	
  4647	function selectedNewSemesterType() {
  4648	  return document.querySelector('input[name="new-sem-type"]:checked')?.value || SEMESTER_TYPES.weekly;
  4649	}
  4650	
  4651	function onNewSemesterTypeChange() {
  4652	  const type = selectedNewSemesterType();
  4653	  const weekly = document.getElementById('new-sem-weekly-fields');
  4654	  const camp = document.getElementById('new-sem-camp-fields');
  4655	  const dayOff = document.getElementById('new-sem-dayoff-fields');
  4656	  if (weekly) weekly.hidden = type !== SEMESTER_TYPES.weekly;
  4657	  if (camp) camp.hidden = type !== SEMESTER_TYPES.camp;
  4658	  if (dayOff) {
  4659	    dayOff.hidden = type !== SEMESTER_TYPES.dayOff;
  4660	    if (type === SEMESTER_TYPES.dayOff) resetDayOffYearFields();
  4661	  }
  4662	}
  4663	
  4664	// Defaults: Aug 1 of this year → May 31 of the next; name follows the dates
  4665	// until the admin types their own.
  4666	function resetDayOffYearFields() {
  4667	  const y = new Date().getFullYear();
  4668	  const start = document.getElementById('new-sem-dayoff-start');
  4669	  const end = document.getElementById('new-sem-dayoff-end');
  4670	  const name = document.getElementById('new-sem-dayoff-name');
  4671	  if (start) start.value = `${y}-08-01`;
  4672	  if (end) end.value = `${y + 1}-05-31`;
  4673	  if (name) delete name.dataset.edited;
  4674	  onDayOffYearDatesChange();
  4675	}
  4676	
  4677	function onDayOffYearDatesChange() {
  4678	  const name = document.getElementById('new-sem-dayoff-name');
  4679	  if (!name || name.dataset.edited) return;
  4680	  const start = document.getElementById('new-sem-dayoff-start')?.value || '';
  4681	  const end = document.getElementById('new-sem-dayoff-end')?.value || '';
  4682	  name.value = start && end ? dayOffYearLabels(start, end).name : '';
  4683	}
  4684	
  4685	// An SDOC school year: one appData entry through the field-path writer, after
  4686	// a forced-server absence check. No roster, no lesson slots, no
  4687	// curriculum/lessonData write.
  4688	async function createDayOffYear() {
  4689	  const startDate = document.getElementById('new-sem-dayoff-start')?.value || '';
  4690	  const endDate = document.getElementById('new-sem-dayoff-end')?.value || '';
  4691	  const name = document.getElementById('new-sem-dayoff-name')?.value.trim() || '';
  4692	  if (!isIsoDate(startDate) || !isIsoDate(endDate)) { alert('Pick the school year\'s start and end dates.'); return; }
  4693	  if (endDate <= startDate) { alert('The school year has to end after it starts.'); return; }
  4694	  if (!name) { alert('Give the school year a name.'); return; }
  4695	  const { key } = dayOffYearLabels(startDate, endDate);
  4696	  if (currentConfig.semesters?.[key]) { alert(`${currentConfig.semesters[key].name} already exists (${key}).`); return; }
  4697	
  4698	  creatingSemester = true;
  4699	  try {
  4700	    const serverConfig = await readAppDataFromServer();
  4701	    if (serverConfig?.semesters?.[key]) {
  4702	      alert(`A school year with key "${key}" was already created (in another tab, or by another admin). Reload to see it.`);
  4703	      creatingSemester = false;
  4704	      return;
  4705	    }
  4706	    const newSem = { name, semesterType: SEMESTER_TYPES.dayOff, startDate, endDate, published: false, teacherNames: [] };
  4707	    await updateAppData({ [`semesters.${key}`]: newSem });
  4708	    currentConfig.semesters[key] = newSem;
  4709	  } catch (err) {
  4710	    console.error('❌ Could not create the school year:', err);
  4711	    alert(`Could not create that school year: ${err.message}`);
  4712	    creatingSemester = false;
  4713	    return;
  4714	  }
  4715	  // The write landed — anything failing from here is display only.
  4716	  try {
  4717	    currentDayOffEvents[key] = [];
  4718	    currentDayOffCamps[key] = [];
  4719	    currentDayOffPlans[key] = {};
  4720	    currentDayOffSignoffs[key] = {};
  4721	    if (currentLessonData) currentLessonData[key] = {};
  4722	    closeNewSemesterModal();
  4723	    renderSemesterSelector();
  4724	    initGlobalSemesterSelector();
  4725	    alert(`${name} created. It stays hidden from teachers. Next: add its teacher names in Settings, then its day-off dates and camps in Curriculum Admin.`);
  4726	  } catch (err) {
  4727	    console.error('School year created, but the page did not refresh:', err);
  4728	    alert(`${name} was created, but the page didn't refresh properly — reload to see it.`);
  4729	  } finally {
  4730	    creatingSemester = false;
  4731	  }
  4732	}
  4733	
  4734	// The Camp season option offers exactly the registry seasons that do not
  4735	// already have a semester here. In legacy mode there is no registry to read,
  4736	// and with nothing left to add there is nothing to choose — either way the
  4737	// option is disabled with the reason shown, never silently empty (1.6).
  4738	async function populateNewSemesterSeasons() {
  4739	  const select = document.getElementById('new-sem-season');
  4740	  const campRadio = document.getElementById('new-sem-type-camp');
  4741	  const note = document.getElementById('new-sem-camp-unavailable');
  4742	  if (!select || !campRadio || !note) return;
  4743	  const disable = (reason) => {
  4744	    campRadio.disabled = true;
  4745	    note.textContent = reason;
  4746	    note.hidden = false;
  4747	    select.innerHTML = '';
  4748	  };
  4749	  const mode = getSeasonRegistryMode();
  4750	  if (mode === 'legacy') return disable('Camp seasons need the Summer Camp App to set up its seasons first — none exist yet.');
  4751	  if (mode !== 'filtered') return disable("Can't read the season registry right now, so a camp season can't be added.");
  4752	  try {
  4753	    const registered = await listRegisteredSeasons();
  4754	    // A season is "taken" by a stored `season` OR by the key it would be
  4755	    // created under. The key check matters before the type migration has run:
  4756	    // summer-2026 carries no `season` field yet, and matching on that alone
  4757	    // would offer 2026 again and create a duplicate semester.
  4758	    const semesters = currentConfig?.semesters || {};
  4759	    const taken = new Set(Object.values(semesters).map(sem => sem?.season).filter(Boolean));
  4760	    const available = registered.filter(r => !taken.has(r.season) && !semesters[`summer-${r.season}`]);
  4761	    if (available.length === 0) {
  4762	      return disable(registered.length === 0
  4763	        ? 'The Summer Camp App has not created any seasons yet.'
  4764	        : 'Every season the Summer Camp App has created is already in the Classbook.');
  4765	    }
  4766	    campRadio.disabled = false;
  4767	    note.hidden = true;
  4768	    select.innerHTML = available.map(r => {
  4769	      const range = r.startDate && r.endDate ? ` (${formatSeasonDate(r.startDate)} – ${formatSeasonDate(r.endDate)})` : '';
  4770	      return `<option value="${escAttr(r.season)}">${escHtml(r.name || `Summer ${r.season}`)}${escHtml(range)}</option>`;
  4771	    }).join('');
  4772	    newSemesterSeasonsByYear = Object.fromEntries(available.map(r => [r.season, r]));
  4773	  } catch (err) {
  4774	    console.error('Could not list the registry seasons:', err);
  4775	    disable("Couldn't read the season registry, so a camp season can't be added right now.");
  4776	  }
  4777	}
  4778	
  4779	let newSemesterSeasonsByYear = {};
  4780	
  4781	function formatSeasonDate(iso) {
  4782	  const d = new Date(`${iso}T00:00:00`);
  4783	  return Number.isNaN(d.getTime()) ? iso : d.toLocaleDateString(undefined, { month: 'short', day: 'numeric', year: 'numeric' });
  4784	}
  4785	
  4786	function closeNewSemesterModal() {
  4787	  document.getElementById('ca-new-semester-modal')?.classList.remove('open');
  4788	}
  4789	
  4790	// In-flight guard: the Create button is a bare onclick with no disabled state,
  4791	// so a double-click ran two overlapping creations. Both passed the
  4792	// "already exists" check (the key is only added to currentConfig after the
  4793	// first await), and a split success/failure would let the failing run's
  4794	// cleanup below delete the succeeding run's server-side slots. Set before the
  4795	// first await, cleared in `finally` — everything between the check and the
  4796	// set is synchronous, so the second click always sees it.
  4797	let creatingSemester = false;
  4798	
  4799	// A lesson slot exactly as createNewSemester() / createLessonSlotsForRoster()
  4800	// generate it: identity + enrollment metadata, every other field at its empty
  4801	// default. Deliberately stricter than lessonHasContent() — projectTitle,
  4802	// materials, photoUrl, qaThread etc. are not CONTENT_FIELDS but are still
  4803	// real data that createNewSemester()'s slot write would merge over.
  4804	function isTemplateEmptyLesson(lesson) {
  4805	  if (!lesson || typeof lesson !== 'object') return false;
  4806	  const IDENTITY = new Set(['teacher', 'className', 'weekNum', 'classSize']);
  4807	  return Object.entries(lesson).every(([k, v]) =>
  4808	    IDENTITY.has(k) || v == null || v === '' || v === 0 || v === false ||
  4809	    (Array.isArray(v) && v.length === 0)
  4810	  );
  4811	}
  4812	
  4813	// A camp season is created from the registry, never typed in (1.6 / D3): no
  4814	// roster, no week grid, no lesson slots and no curriculum/lessonData write —
  4815	// its camps arrive from the Summer Camp App when Christie publishes them.
  4816	async function createCampSeasonSemester() {
  4817	  const season = document.getElementById('new-sem-season')?.value;
  4818	  const registry = newSemesterSeasonsByYear[season];
  4819	  if (!season || !registry) { alert('Pick a season first.'); return; }
  4820	
  4821	  const key = `summer-${season}`;
  4822	  if (currentConfig.semesters?.[key]) { alert(`Summer ${season} is already in the Classbook.`); return; }
  4823	  // The same completeness check Re-sync makes — otherwise a half-set-up season
  4824	  // could be ADDED with numWeeks 0 and no studios, and would then render with
  4825	  // 2026's fallback shape and hours (Phase 1 fix review).
  4826	  const problems = registrySeasonProblems(registry);
  4827	  if (problems.length) {
  4828	    alert(`Summer ${season} isn't ready yet: the Summer Camp App's season still needs ${problems.join(', ')}. Finish setting it up there, then add it here.`);
  4829	    return;
  4830	  }
  4831	
  4832	  creatingSemester = true;
  4833	  try {
  4834	    // The local check above only saw this tab's config.
  4835	    const serverConfig = await readAppDataFromServer();
  4836	    if (serverConfig?.semesters?.[key]) {
  4837	      alert(`Summer ${season} was already added (in another tab, or by another admin). Reload to see it.`);
  4838	      return;
  4839	    }
  4840	    const newSem = semesterFromRegistrySeason(registry);
  4841	    await updateAppData({ [`semesters.${key}`]: newSem });
  4842	    currentConfig.semesters[key] = newSem;
  4843	    closeNewSemesterModal();
  4844	    renderSemesterSelector();
  4845	    initGlobalSemesterSelector();
  4846	    alert(`${newSem.name} added. It stays hidden from teachers until you publish it, and its camps appear here as the Summer Camp App publishes them.`);
  4847	  } catch (err) {
  4848	    console.error('❌ Could not add the camp season:', err);
  4849	    delete currentConfig.semesters[key];
  4850	    alert(`Could not add that season: ${err.message}`);
  4851	  } finally {
  4852	    creatingSemester = false;
  4853	  }
  4854	}
  4855	
  4856	async function createNewSemester() {
  4857	  if (creatingSemester) return;
  4858	  if (selectedNewSemesterType() === SEMESTER_TYPES.camp) return await createCampSeasonSemester();
  4859	  if (selectedNewSemesterType() === SEMESTER_TYPES.dayOff) return await createDayOffYear();
  4860	  const name = document.getElementById('new-sem-name')?.value.trim();
  4861	  if (!name) { alert('Semester name is required.'); return; }
  4862	
  4863	  const key = name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');
  4864	  if (currentConfig.semesters[key]) {
  4865	    alert(`A semester with key "${key}" already exists.`);
  4866	    return;
  4867	  }
  4868	
  4869	  const startDate = document.getElementById('new-sem-start')?.value || '';
  4870	  const numWeeks = parseInt(document.getElementById('new-sem-weeks')?.value) || 16;
  4871	  const breaksRaw = document.getElementById('new-sem-breaks')?.value.trim() || '';
  4872	  const breakWeeks = breaksRaw ? breaksRaw.split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n)) : [];
  4873	  const closuresRaw = document.getElementById('new-sem-closures')?.value.trim() || '';
  4874	  const closureDates = parseClosureDates(closuresRaw);
  4875	  const copyFromKey = document.getElementById('new-sem-copy-from')?.value || '';
  4876	
  4877	  const newSem = {
  4878	    name,
  4879	    semesterType: SEMESTER_TYPES.weekly,   // stored explicitly from now on (Phase 1, 1.1)
  4880	    startDate,
  4881	    numWeeks,
  4882	    breakWeeks,
  4883	    closureDates,
  4884	    published: false,
  4885	    classRoster: {}
  4886	  };
  4887	
  4888	  // Invoked from a bare HTML onclick — nothing above this frame catches, so a
  4889	  // failure anywhere below must be handled here (backtracking audit, Phase 11).
  4890	  // Two Firestore writes happen in sequence (lesson slots, then config); if the
  4891	  // second fails after the first landed, the slots are an orphan on the server
  4892	  // for a semester the admin was told didn't get created, and a retry with the
  4893	  // same name would silently reuse them. Track whether the first write landed
  4894	  // so the catch can compensate.
  4895	  let lessonDataCommitted = false;
  4896	  creatingSemester = true;
  4897	  try {
  4898	    // Copy roster from existing semester if selected
  4899	    if (copyFromKey && currentConfig.semesters[copyFromKey]) {
  4900	      // Pre-check (implementation review, Sep 2026): this branch is the only
  4901	      // path that writes lesson data, and the compensating delete in the catch
  4902	      // below removes the WHOLE `key` map — only safe if nothing lived there
  4903	      // before this call. It can: deleteSemester() drops a key from local
  4904	      // state even when its server-side deleteLessonData() fails (warn-only),
  4905	      // and config has no live listener, so another admin's same-named
  4906	      // semester isn't visible here either. Forced server read — the local
  4907	      // cache is exactly what can't be trusted for this key. Refuse unless
  4908	      // every existing lesson is template-empty (a prior createNewSemester()'s
  4909	      // own leftovers are safe to build on and safe to delete; anything else
  4910	      // would be merged over silently by the slot write, then deleted on
  4911	      // failure). The no-copy path is deliberately NOT gated: it writes no
  4912	      // lesson data, and re-creating a deleted semester there adopts its
  4913	      // surviving lesson data — the remedy this alert points at.
  4914	      const existingLessonMap = await readServerSemesterLessonMap(key);
  4915	      if (existingLessonMap && Object.values(existingLessonMap).some(l => !isTemplateEmptyLesson(l))) {
  4916	        alert(`Lesson content already exists in Firestore under the key "${key}".\n\nIf it was left over from a deleted semester, create this semester again without "Copy from" to adopt that data.\n\nIf another admin may have just created it, reload this page first.\n\nOtherwise choose a different name.`);
  4917	        return;
  4918	      }
  4919	
  4920	      const source = currentConfig.semesters[copyFromKey];
  4921	      newSem.classRoster = JSON.parse(JSON.stringify(source.classRoster || {}));
  4922	      // Without this, classRoster's teacher fields are copied but the dropdown
  4923	      // that lets Settings display/edit them has no options — the roster looks
  4924	      // wiped even though the underlying data isn't, and saving Settings in
  4925	      // that state silently writes blank teachers over the real ones.
  4926	      newSem.teacherNames = JSON.parse(JSON.stringify(source.teacherNames || []));
  4927	
  4928	      // Create empty lesson slots from source semester's teacher/class combos
  4929	      const sourceLessons = currentLessonData?.[copyFromKey] || {};
  4930	      const combos = new Set();
  4931	      for (const lesson of Object.values(sourceLessons)) {
  4932	        combos.add(`${lesson.teacher}|||${lesson.className}`);
  4933	      }
  4934	
  4935	      const emptyLessons = {};
  4936	      for (const combo of combos) {
  4937	        const [teacher, className] = combo.split('|||');
  4938	        for (let w = 1; w <= numWeeks; w++) {
  4939	          const lessonKey = makeLessonKey(teacher, className, w);
  4940	          emptyLessons[lessonKey] = {
  4941	            teacher,
  4942	            className,
  4943	            weekNum: w,
  4944	            weekDate: '',
  4945	            classSize: 0,
  4946	            projectTitle: '',
  4947	            shortDetails: '',
  4948	            inspoLink: '',
  4949	            introPitch: '',
  4950	            processStep1: '',
  4951	            processStep2: '',
  4952	            processStep3: '',
  4953	            processStep4: '',
  4954	            closure: '',
  4955	            materials: '',
  4956	            dayOfMaterials: '',
  4957	            materialsList: [],
  4958	            status: '',
  4959	            publishToPrep: ''
  4960	          };
  4961	        }
  4962	      }
  4963	
  4964	      if (Object.keys(emptyLessons).length > 0) {
  4965	        await saveLessonData(key, emptyLessons);
  4966	        if (!currentLessonData) currentLessonData = {};
  4967	        currentLessonData[key] = emptyLessons;
  4968	        lessonDataCommitted = true;
  4969	      }
  4970	    }
  4971	
  4972	    // Confirm on the SERVER that the key is free — the check at the top of this
  4973	    // function only saw this tab's copy of the config (Phase 1, 1.2). The
  4974	    // remaining read-to-update window is accepted: one admin, same class as the
  4975	    // existing residual on the Q&A path.
  4976	    const serverConfig = await readAppDataFromServer();
  4977	    if (serverConfig?.semesters?.[key]) {
  4978	      throw new Error(`A semester with the key "${key}" already exists (created in another tab or by another admin). Choose a different name.`);
  4979	    }
  4980	    currentConfig.semesters[key] = newSem;
  4981	    await updateAppData({ [`semesters.${key}`]: newSem });
  4982	  } catch (err) {
  4983	    console.error('❌ Could not create new semester:', err);
  4984	    // Revert both local mutations so a retry isn't blocked by a phantom
  4985	    // "already exists" and the grid doesn't render a semester that never saved.
  4986	    delete currentConfig.semesters[key];
  4987	    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
  4988	    // R4-11: the empty lesson slots may already be persisted even though the
  4989	    // config never was — clean up the orphaned server-side write, not just the
  4990	    // local copy. Safe: this data is template-empty by construction (never had
  4991	    // real content), so deleting it loses nothing.
  4992	    if (lessonDataCommitted) {
  4993	      try {
  4994	        await deleteLessonData(key);
  4995	      } catch (cleanupErr) {
  4996	        console.error('⚠️ Could not clean up orphaned lesson data after failed semester creation:', cleanupErr);
  4997	      }
  4998	    }
  4999	    alert('Could not create the new semester. Please try again.');
  5000	    return;
  5001	  } finally {
  5002	    creatingSemester = false;
  5003	  }
  5004	
  5005	  closeNewSemesterModal();
  5006	  caCurrentSemester = key;
  5007	  renderSemesterSelector();
  5008	  renderAdminGrid();
  5009	  renderHelpQueue();
  5010	  renderCutBank();
  5560	  // Backtracking audit, Phase 1: check the guard BEFORE any Storage mutation
  5561	  // (and, now, before the existence check) so a known-bad load state never
  5562	  // gets as far as a server read, an upload, or a delete.
  5563	  if (lessonDataLoadedSuccessfully === false) {
  5564	    alert('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  5565	    return;
  5566	  }
  5567	
  5568	  caEditSaveInFlight = true;
  5569	  // Every action button in the modal body — the form's own Save/Print/Cancel
  5570	  // AND the empty-cell popup's two Paste buttons, which openDetailModal()
  5571	  // renders outside #ca-edit-form (round-3 review: they could replace the
  5572	  // modal body mid-save and race a second write onto the same slot).
  5573	  const btns = Array.from(document.querySelectorAll('#ca-modal-body .ca-actions button'));
  5574	  const saveBtn = btns.find(b => /^save/i.test(b.textContent.trim()));
  5575	  btns.forEach(b => { b.disabled = true; });
  5576	  if (saveBtn) saveBtn.textContent = 'Saving...';
  5577	  try {
  5578	    await saveAdminEditInner(key, teacher, className, weekNum, title);
  5579	  } finally {
  5580	    caEditSaveInFlight = false;
  5581	    btns.forEach(b => { b.disabled = false; });
  5582	    if (saveBtn) saveBtn.textContent = 'Save';
  5583	  }
  5584	}
  5585	
  5586	async function saveAdminEditInner(key, teacher, className, weekNum, title) {
  5587	  const semKey = getAdminSemKey();
  5588	
  5589	  const lessons = { ...(currentLessonData?.[semKey] || {}) };
  5590	  let existing = lessons[key] || {};   // rebased on the fresh server copy after the existence check (non-summer)
  5591	
  5592	  // Step 1 — diff the form against the open-time snapshot (pure DOM reads, no
  5593	  // side effects — so a no-op save can bail out below without paying for the
  5594	  // existence check's server read).
  5595	  const raw = {
  5596	    projectTitle: title,
  5597	    shortDetails: document.getElementById('ca-edit-details')?.value.trim() || '',
  5598	    inspoLink: document.getElementById('ca-edit-inspo')?.value.trim() || '',
  5599	    introPitch: document.getElementById('ca-edit-intro')?.value.trim() || '',
  5600	    processStep1: document.getElementById('ca-edit-step1')?.value.trim() || '',
  5601	    processStep2: document.getElementById('ca-edit-step2')?.value.trim() || '',
  5602	    processStep3: document.getElementById('ca-edit-step3')?.value.trim() || '',
  5603	    processStep4: document.getElementById('ca-edit-step4')?.value.trim() || '',
  5604	    closure: document.getElementById('ca-edit-closure')?.value.trim() || '',
  5605	    materials: document.getElementById('ca-edit-materials')?.value.trim() || '',
  5606	    dayOfMaterials: document.getElementById('ca-edit-dayof')?.value.trim() || '',
  5607	  };
  5608	  // No snapshot (shouldn't happen — both render paths capture one) degrades to
  5609	  // "everything non-empty is changed": today's behavior, never a lost edit.
  5610	  const baseline = caEditOriginalData || {};
  5611	  const changedFields = Object.keys(raw).filter(f => raw[f] !== (baseline[f] || ''));
  5612	  // Had text when the popup opened, empty now — an intentional clear, which
  5613	  // saveSingleLesson must apply with FieldValue.delete() rather than let the
  5614	  // stripping pass silently drop (Data Safety Plan Stage 3, never extended to
  5615	  // this third editor until now).
  5616	  const fieldsToClear = changedFields.filter(f => (baseline[f] || '') !== '' && raw[f] === '');
  5617	  const changedData = {};
  5618	  changedFields.forEach(f => { changedData[f] = raw[f]; });
  5619	
  5620	  const photoInput = document.getElementById('ca-edit-photo-input');
  5621	  const hasNewPhoto = photoInput?.files?.length > 0;
  5622	  let pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
  5623	  // Nothing changed — no write, no re-stamped lastEditedBy/At, no "edit" log
  5624	  // entry for an edit that didn't happen (mirrors saveTeacherEdit()).
  5625	  if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) {
  5626	    closeAdminModal(true);
  5627	    return;
  5628	  }
  5629	
  5630	  // Step 2 — forced-server read of this slot, before any side effect (the
  5631	  // photo upload, the write). Non-summer only: a summer cache entry is a
  5632	  // scaffold regenerated from summerCamps_curriculum whether or not its
  5633	  // summerCamps_lessonData doc exists (a missing doc means "never saved",
  5634	  // not "moved") and this app has no move/swap/cut path for summer lessons,
  5635	  // so there is no ghost to prevent — the first save legitimately creates
  5636	  // the doc. Same routing signal as saveSingleLesson() /
  5637	  // adminLessonStillExistsWithRetry() (key prefix; the camp-seasons plan
  5638	  // unifies this on semesterType). Forced read — a cache-permitting get()
  5639	  // could be served from the live listener's local cache in exactly the race
  5640	  // window this check exists to close. It runs for first-time creation too:
  5641	  // an "empty" slot in this tab's cache may have gained a project (a paste, a
  5642	  // move onto it) that the listener hasn't delivered yet.
  5643	  const isSummerSchema = isCampSeason(semKey);   // Phase 1, 1.1
  5644	  if (!isSummerSchema) {
  5645	    let check;
  5646	    try {
  5647	      check = await adminLessonStillExistsWithRetry(semKey, key);
  5648	    } catch (err) {
  5649	      console.warn('⚠️ Existence check retry also failed:', err);
  5650	      alert("Couldn't confirm this lesson still exists — check your connection and try saving again.");
  5651	      return;
  5652	    }
  5653	    if (caEditLessonExisted && !check.exists) {
  5654	      alert('This lesson was moved or removed elsewhere while you had it open. Your changes were not saved — please close this window and check the grid for its new location.');
  5655	      return;
  5656	    }
  5657	    if (check.exists) {
  5658	      // The key holds a doc — but a swap, a move ONTO this slot, or a paste
  5659	      // into a slot this tab still shows as empty leaves it populated with a
  5660	      // DIFFERENT project. The popup's edits were made against the project it
  5661	      // opened on; applying them to whatever is here now needs an explicit
  5662	      // decision, the same way cutProject() re-confirms when the fresh read
  5663	      // shows the slot's identity changed.
  5664	      const freshTitle = (check.data?.projectTitle || '').trim();
  5665	      if (freshTitle !== (baseline.projectTitle || '')) {
  5666	        const opened = baseline.projectTitle || '(empty slot)';
  5667	        if (!confirm(`This slot has changed since you opened it — it now contains "${freshTitle || '(empty)'}" instead of "${opened}". Save your changes onto "${freshTitle || 'this slot'}" anyway?\n\nCancel keeps your text here and saves nothing.`)) return;
  5668	      }
  5669	      // From here on, work from the FRESH copy, not this tab's cache: the
  5670	      // photo to delete after a replacement, the "remove photo" target, the
  5671	      // identity/scheduling fields resent below, the local cache merge and
  5672	      // the logged title all come from `existing`. On the swap-accept path
  5673	      // the cached copy's photoPath is the OTHER lesson's live photo.
  5674	      existing = check.data;
  5675	      pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
  5676	    }
  5677	  } else if (!existing.campName) {
  5678	    // A summer key that is no longer in the cache (the schedule was rebuilt
  5679	    // between open and save — e.g. the project was renamed in the Summer
  5680	    // Camp App) would produce a doc without its identity trio, which neither
  5681	    // app can find again. Refuse rather than write it.
  5682	    alert('This lesson is no longer in the summer schedule — reload and try again. Nothing was saved.');
  5683	    return;
  5684	  }
  5685	
  5686	  // Summer: projectTitle, shortDetails, inspoLink and materials belong to the
  5687	  // camp curriculum, not to the lesson doc — loadSummerCampData() takes them
  5688	  // from the scaffold and reads back only content/photo/completion fields
  5689	  // (SUMMER_SAVED_FIELDS), so an edit here would "save" and then vanish on the
  5690	  // next reload. projectTitle is worse: it is part of the lesson key, and the
  5691	  // Summer Camp App's orphan check treats a doc whose title isn't in the
  5692	  // camp's curriculum as orphaned content. Refuse them honestly rather than
  5693	  // write them into a doc where they can only mislead.
  5694	  const SUMMER_CURRICULUM_OWNED = ['projectTitle', 'shortDetails', 'inspoLink', 'materials'];
  5695	  if (isSummerSchema) {
  5696	    const refused = SUMMER_CURRICULUM_OWNED.filter(f => f in changedData);
  5697	    if (refused.length > 0) {
  5698	      const labels = { projectTitle: 'project title', shortDetails: 'short details', inspoLink: 'inspo link', materials: 'materials' };
  5699	      alert(`Summer camp ${refused.map(f => labels[f]).join(', ')} are managed in the Summer Camp App — that change is not saved here.` + (changedFields.length > refused.length || hasNewPhoto || pendingRemove ? ' Your other edits will still be saved.' : ''));
  5700	      refused.forEach(f => {
  5701	        delete changedData[f];
  5702	        const idx = changedFields.indexOf(f);
  5703	        if (idx !== -1) changedFields.splice(idx, 1);
  5704	        const cidx = fieldsToClear.indexOf(f);
  5705	        if (cidx !== -1) fieldsToClear.splice(cidx, 1);
  5706	      });
  5707	      if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) { closeAdminModal(true); return; }
  5708	    }
  5709	  }
  5710	
  5711	  // Firestore-bound payload — see the function comment for what's in it and why.
  5712	  const firestorePayload = {
  5713	    teacher, className, weekNum,
  5714	    weekDate: existing.weekDate || '',
  5715	    classSize: existing.classSize || 0,
  5716	    // Summer identity trio, key-derived and idempotent — a doc this save
  5717	    // CREATES must carry them (the Summer Camp App queries this collection by
  5718	    // campName + teacher and checks projectTitle; the summer editor sends the
  5719	    // same trio on every save for the same reason).
  5720	    ...(isSummerSchema ? { campName: existing.campName, block: existing.block, projectTitle: existing.projectTitle } : {}),
  5721	    ...changedData,
  5722	    lastImported: new Date().toISOString()
  5723	  };
  5724	
  5725	  // Backtracking audit, Phase 1 (R4-2): capture the OLD photoPath before any
  5726	  // mutation, so the delete-after-save step compares against the right value.
  5727	  const oldPhotoPath = existing.photoPath || null;
  5728	  let photoUrl = null, photoPath = null;   // null = this save didn't touch the photo
  5729	
  5730	  try {
  5731	    // Handle photo upload/removal
  5732	    if (hasNewPhoto) {
  5733	      const file = photoInput.files[0];
  5734	      if (file.size > 5 * 1024 * 1024) { alert('Photo must be under 5MB.'); return; }
  5735	      const { url, path } = await uploadLessonPhoto(semKey, key, file);
  5736	      // Delete of the OLD photo happens AFTER the save below — not here.
  5737	      photoUrl = url;
  5738	      photoPath = path;
  5739	    } else if (pendingRemove) {
  5740	      photoUrl = '';
  5741	      photoPath = '';
  5742	    }
  5743	    if (photoUrl !== null) {
  5744	      firestorePayload.photoUrl = photoUrl;
  5745	      firestorePayload.photoPath = photoPath;
  5746	    }
  5747	
  5748	    // Targeted single-lesson save with a diff-only payload — never the cached
  5749	    // full lesson, never the whole semester. (The summer branch's "no content"
  5750	    // guard can't refuse a legitimate save from here: for summer every
  5751	    // editable non-content field is curriculum-owned and refused above, so
  5752	    // what remains is content, a clear, or a photo — each admitted.)
  5753	    await saveSingleLesson(semKey, key, firestorePayload, fieldsToClear);
  5754	
  5755	    // Backtracking audit, Phase 1 (R4-2): only delete the OLD object once
  5756	    // Firestore has confirmed the new reference — and only when THIS save
  5757	    // actually replaced or removed the photo (photoUrl !== null). A text-only
  5758	    // edit leaves the old path untouched in both Firestore and Storage.
  5759	    if (photoUrl !== null && oldPhotoPath && oldPhotoPath !== (photoPath || null)) {
  5760	      try {
  5761	        await deleteLessonPhoto(oldPhotoPath);
  5762	      } catch (cleanupErr) {
  5763	        console.error('⚠️ Could not clean up old photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
  5764	      }
  5765	    }
  5766	  } catch (err) {
  5767	    // Backtracking audit, Phase 1 (R2-22): MUST return here — otherwise
  5768	    // execution falls through to commit currentLessonData, close the modal,
  5769	    // and log a fake edit even though the save never actually succeeded. The
  5770	    // snapshot is kept so the still-open popup can retry against it.
  5771	    console.error('❌ Admin edit failed to save:', err);
  5772	    alert('This edit could not be saved. Please try again.');
  5773	    return;
  5774	  }
  5775	
  5776	  // Local display/cache only — never sent to Firestore, so keeping the full
  5777	  // merge here is safe (staleness in untouched fields is cosmetic until the
  5778	  // listener's next delivery, same as the teacher editor).
  5779	  lessons[key] = {
  5780	    ...existing,
  5781	    teacher, className, weekNum,
  5782	    weekDate: firestorePayload.weekDate,
  5783	    classSize: firestorePayload.classSize,
  5784	    ...changedData,
  5785	    lastImported: firestorePayload.lastImported,
  5786	    lastEditedBy: firestorePayload.lastEditedBy,   // stamped by saveSingleLesson()
  5787	    lastEditedAt: firestorePayload.lastEditedAt
  5788	  };
  5789	  if (photoUrl !== null) { lessons[key].photoUrl = photoUrl; lessons[key].photoPath = photoPath; }
  5790	  fieldsToClear.forEach(f => { lessons[key][f] = ''; });
  5791	  currentLessonData[semKey] = lessons;
  5792	
  5793	  closeAdminModal(true);   // the save's own close — also resets the snapshot
  5794	  renderAdminGrid();
  5795	  renderChangeHistory();
  5796	
  5797	  try {
  5798	    // Log the title that was actually kept — for summer a refused retitle
  5799	    // must not show up in Change History under the refused name.
  5800	    const keptTitle = firestorePayload.projectTitle || existing.projectTitle || title;
  5801	    await appendChangeLogEntry(semKey, {
  5802	      action: existing.projectTitle ? 'edit' : 'create',
  5803	      details: { projectTitle: keptTitle, teacher, className, weekNum }
  5804	    });
  5805	    renderChangeHistory();
  5806	  } catch (e) { console.warn('Could not write change log entry:', e); }
  5807	}
  5808	
  5809	function startSwap(sourceKey) {
  5810	  caActionMode = 'swap';
  5811	  caSourceKey = sourceKey;
  5812	  closeAdminModal();
  5813	  renderAdminGrid();
  5814	}
  5815	
  5816	function cancelGridAction() {
  5817	  caActionMode = null;
  5818	  caSourceKey = null;
  5819	  renderAdminGrid();
  5820	}
  5821	
  5822	// Data Safety Plan Stage 2A/2B: shared helpers for the admin grid's move/swap
  5823	// abort-and-restore paths (see CLASSBOOK-DATA-SAFETY-PLAN.md).
  5824	// lessonHasContent() now lives in firebase-data.js (CONTENT_FIELDS is the
  5825	// single source of truth, Data Safety Plan Stage 4A) — this file just uses it.
  5826	
  5827	// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
  5828	// model. Backtracking audit, Phase 2 (reinstated round 4): adds an optional
  5829	// opts.source === 'server' param, needed by Phase 8's
  5830	// adminLessonStillExistsWithRetry() existence check below — omitting opts
  5831	// preserves the exact prior (cache-permitting) default for any future caller.
  5832	async function readAdminLessonDoc(semKey, lessonKey, opts = {}) {
  5833	  if (!curriculumDb) initCurriculumFirestore();
  5834	  const getOpts = opts.source === 'server' ? { source: 'server' } : undefined;
  5835	  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
  5836	  return snap.exists ? (snap.data()?.[semKey]?.[lessonKey] || null) : null;
  5837	}
  5838	
  5839	// Backtracking audit, Phase 8: shared by cutProject() below and Phase 11's
  5840	// sendHelpResponse()/sendQaReply() (not yet implemented) — forced server
  5841	// read, retried once on failure, then lets a second failure throw so each
  5842	// caller decides how to surface it. Residual TOCTOU race (check-to-write gap)
  5843	// deliberately accepted, matching the companion plan's own decision for this
  5844	// identical helper — bounded by human click-to-click timing, not a tight
  5845	// machine loop; closing it fully would need a Firestore transaction.
  5846	async function adminLessonStillExistsWithRetry(semKey, key) {
  5847	  if (!curriculumDb) initCurriculumFirestore();
  5848	  const isSummer = lessonStoreFor(semKey) === 'camp';   // Phase 1, 1.1 — by type, and a third type throws
  5849	  const readOnce = async () => {
  5850	    if (isSummer) {
  5851	      const snap = await curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key)).get({ source: 'server' });
  5852	      return { exists: snap.exists, data: snap.exists ? snap.data() : null };
  5853	    }
  5854	    const data = await readAdminLessonDoc(semKey, key, { source: 'server' });
  5855	    return { exists: data !== null, data };
  5856	  };
  5857	  try {
  5858	    return await readOnce();
  5859	  } catch (err) {
  5860	    console.warn('⚠️ Existence check read failed, retrying once:', err);
  5861	    return await readOnce(); // a second failure throws — caller's catch handles it
  5862	  }
  5863	}
  5864	
  5865	// Reverts the admin grid's optimistic in-memory update after a move/swap that
  5866	// failed to save or failed verification — puts both slots back to their
  5867	// pre-action state (deleting the dest slot if it didn't exist before) and re-renders.
  5868	function restoreGridActionState(semKey, sourceKey, sourceLesson, destKey, destLesson) {
  5869	  if (!currentLessonData[semKey]) currentLessonData[semKey] = {};
  5870	  currentLessonData[semKey][sourceKey] = sourceLesson;
  5871	  if (destLesson) {
  5872	    currentLessonData[semKey][destKey] = destLesson;
  5873	  } else {
  5874	    delete currentLessonData[semKey][destKey];
  5875	  }
  5876	  renderAdminGrid();
  5877	}
  5878	
  5879	async function handleGridAction(destTeacher, destClassName, destWeekNum, destKey) {
  5880	  const semKey = getAdminSemKey();
  5881	  const lessons = { ...currentLessonData[semKey] };
  5882	  const sourceLesson = lessons[caSourceKey];
  5883	
  5884	  if (!sourceLesson) {
  5885	    cancelGridAction();
  5886	    return;
  5887	  }
  5888	
  5889	  // Prevent moving to same cell
  5890	  if (caSourceKey === destKey) {
  5891	    cancelGridAction();
  5892	    return;
  5893	  }
  5894	
  5895	  const destLesson = lessons[destKey] || null;
  5896	  const newDestKey = makeLessonKey(destTeacher, destClassName, destWeekNum);
  5897	
  5898	  if (caActionMode === 'move') {
  5899	    if (destLesson) {
  5900	      if (!confirm(`Week ${destWeekNum} already has "${destLesson.projectTitle}". This will overwrite it. Continue?`)) {
  5901	        cancelGridAction();
  5902	        return;
  5903	      }
  5904	    }
  5905	    if (!confirm(`Move "${sourceLesson.projectTitle}" from Week ${sourceLesson.weekNum} to ${destTeacher} / ${destClassName} Week ${destWeekNum}?`)) {
  5906	      cancelGridAction();
  5907	      return;
  5908	    }
  5909	
  5910	    // Move: put source content at destination, clear source
  5911	    const movedLesson = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum };
  5912	    movedLesson.weekDate = destLesson?.weekDate || '';
  5913	    // Backtracking audit, Phase 4: a content field non-empty at the existing
  5914	    // destination but empty in the incoming moved lesson must be explicitly
  5915	    // cleared — saveSingleLesson omits empty fields from the write rather
  5916	    // than clearing them, so without this the destination's old content
  5917	    // would silently survive underneath the moved lesson.
  5918	    const destFieldsToClear = CONTENT_FIELDS.filter(f =>
  5919	      (destLesson?.[f] || '').trim() !== '' && !(movedLesson[f] || '').trim()
  5920	    );
  5921	    lessons[newDestKey] = movedLesson;
  5922	    delete lessons[caSourceKey];
  5923	    currentLessonData[semKey] = lessons;
  5924	
  5925	    const sourceKeyToDelete = caSourceKey;
  5926	    const preMoveSourceLesson = sourceLesson;
  5927	    const preMoveDestLesson = destLesson;
  5928	    caActionMode = null;
  5929	    caSourceKey = null;
  5930	    renderAdminGrid();
  5931	    renderChangeHistory();
  5932	
  5933	    // Backtracking audit, Phase 9: the destination write and the source
  5934	    // delete are ONE atomic Firestore call — closes the "first write landed,
  5935	    // second failed" partial-failure race the prior sequential-write design
  5936	    // was vulnerable to. Does NOT independently verify movedLesson reflects
  5937	    // the CURRENT server state (a separate, deliberately deferred stale-input
  5938	    // race — see classbook-shared-document-concurrency-plan.html's 7th
  5939	    // instance) — no read-back needed or performed, since the write is
  5940	    // all-or-nothing.
  5941	    let moveSucceeded = false;
  5942	    try {
  5943	      await saveMultipleLessonFields(
  5944	        semKey,
  5945	        [{ lessonKey: newDestKey, lessonData: movedLesson, fieldsToClear: destFieldsToClear }],
  5946	        [sourceKeyToDelete]
  5947	      );
  5948	      moveSucceeded = true;
  5949	    } catch (err) {
  5950	      console.error('❌ Move failed:', err);
  5951	      restoreGridActionState(semKey, sourceKeyToDelete, preMoveSourceLesson, newDestKey, preMoveDestLesson);
  5952	      alert(`Move could not be saved — "${preMoveSourceLesson.projectTitle}" has been restored to its original slot. Nothing was changed.`);
  5953	      return;
  5954	    }
  5955	
  5956	    if (moveSucceeded) {
  5957	      try {
  5958	        await appendChangeLogEntry(semKey, {
  5959	          action: 'move',
  5960	          details: {
  5961	            projectTitle: sourceLesson.projectTitle,
  5962	            teacher: sourceLesson.teacher,
  5963	            className: sourceLesson.className,
  5964	            fromWeek: sourceLesson.weekNum,
  5965	            toTeacher: destTeacher,
  5966	            toClassName: destClassName,
  5967	            toWeek: destWeekNum
  5968	          }
  5969	        });
  5970	        renderChangeHistory();
  5971	      } catch (logErr) {
  5972	        console.error('⚠️ Move saved, but Change History logging failed:', logErr);
  5973	      }
  5974	    }
  5975	    return;
  5976	
  5977	  } else if (caActionMode === 'swap') {
  5978	    const destLabel = destLesson ? `"${destLesson.projectTitle}"` : 'empty slot';
  5979	    if (!confirm(`Swap "${sourceLesson.projectTitle}" (Week ${sourceLesson.weekNum}) with ${destLabel} (Week ${destWeekNum})?`)) {
  5980	      cancelGridAction();
  5981	      return;
  5982	    }
  5983	
  5984	    // Swap: exchange content between source and dest
  5985	    const sourceWeekNum = sourceLesson.weekNum;
  5986	    const sourceTeacher = sourceLesson.teacher;
  5987	    const sourceClassName = sourceLesson.className;
  5988	    const sourceWeekDate = sourceLesson.weekDate;
  5989	    const sourceKeyForSwap = caSourceKey;
  5990	
  5991	    let savePromise;
  5992	    let swapSucceeded = false;
  5993	    if (destLesson) {
  5994	      const swappedSource = { ...destLesson, teacher: sourceTeacher, className: sourceClassName, weekNum: sourceWeekNum, weekDate: sourceWeekDate };
  5995	      const swappedDest = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum, weekDate: destLesson.weekDate };
  5996	      // Backtracking audit, Phase 4: each slot's clear list compares its OWN
  5997	      // pre-swap content against what's now being written there — NOT the
  5998	      // other slot's pre-swap content, which would be a no-op since that's
  5999	      // identical-by-construction to the incoming value.
  6000	      const sourceFieldsToClear = CONTENT_FIELDS.filter(f =>
  6001	        (sourceLesson[f] || '').trim() !== '' && !(swappedSource[f] || '').trim()
  6002	      );
  6003	      const destFieldsToClearSwap = CONTENT_FIELDS.filter(f =>
  6004	        (destLesson[f] || '').trim() !== '' && !(swappedDest[f] || '').trim()
  6005	      );
  6006	      lessons[sourceKeyForSwap] = swappedSource;
  6007	      lessons[newDestKey] = swappedDest;
  6008	      currentLessonData[semKey] = lessons;
  6009	
  6010	      // Backtracking audit, Phase 9: both slots' writes are now ONE atomic
  6011	      // Firestore call — closes the "first save landed, second failed"
  6012	      // partial-failure race the prior two-sequential-saves design was
  6013	      // vulnerable to.
  6014	      savePromise = (async () => {
  6015	        try {
  6016	          await saveMultipleLessonFields(semKey, [
  6017	            { lessonKey: sourceKeyForSwap, lessonData: swappedSource, fieldsToClear: sourceFieldsToClear },
  6018	            { lessonKey: newDestKey, lessonData: swappedDest, fieldsToClear: destFieldsToClearSwap }
  6019	          ]);
  6020	          swapSucceeded = true;
  6021	        } catch (err) {
  6022	          console.error('❌ Swap failed:', err);
  6023	          restoreGridActionState(semKey, sourceKeyForSwap, sourceLesson, newDestKey, destLesson);
  6024	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" and "${destLesson.projectTitle}" have been restored to their original slots.`);
  6025	        }
  6026	      })();
  6027	    } else {
  6028	      // Swap with empty: move source to dest, clear source. Backtracking
  6029	      // audit, Phase 9: the destination write and source delete are now ONE
  6030	      // atomic Firestore call, same reasoning as the move branch above.
  6031	      const movedLesson = { ...sourceLesson, teacher: destTeacher, className: destClassName, weekNum: destWeekNum, weekDate: '' };
  6032	      lessons[newDestKey] = movedLesson;
  6033	      delete lessons[sourceKeyForSwap];
  6034	      currentLessonData[semKey] = lessons;
  6035	      savePromise = (async () => {
  6036	        try {
  6037	          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
  6038	          swapSucceeded = true;
  6039	        } catch (err) {
  6040	          console.error('❌ Swap failed:', err);
  6041	          restoreGridActionState(semKey, sourceKeyForSwap, sourceLesson, newDestKey, null);
  6042	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" has been restored to its original slot.`);
  6043	        }
  6044	      })();
  6045	    }
  6046	
  6047	    caActionMode = null;
  6048	    caSourceKey = null;
  6049	    renderAdminGrid();
  6050	    renderChangeHistory();
  6051	
  6052	    await savePromise;
  6053	
  6054	    if (swapSucceeded) {
  6055	      try {
  6056	        await appendChangeLogEntry(semKey, {
  6057	          action: 'swap',
  6058	          details: {
  6059	            projectTitle: sourceLesson.projectTitle,
  6060	            teacher: sourceTeacher,
  7125	// resave the ENTIRE cached semester via saveLessonData() — a Firestore
  7126	// set({merge:true}) of every lesson currently sitting in this admin's
  7127	// browser, not just the one being replied to. If a teacher's save landed on
  7128	// the server in the split-second before this admin's live listener caught
  7129	// up, that reply would silently revert the teacher's edit back to this
  7130	// admin's stale cached copy — for ANY lesson in the semester, not just the
  7131	// one in the reply. Now a single targeted Firestore .update() touching only
  7132	// this lesson's own field paths, with arrayUnion() for qaThread (survives a
  7133	// genuinely concurrent sender) and an existence check (a stale, long-open
  7134	// popup can't silently recreate a lesson deleted/moved elsewhere).
  7135	async function sendHelpResponse(key) {
  7136	  const input = document.getElementById(`ca-help-input-${key}`);
  7137	  if (!input) return;
  7138	  const response = input.value.trim();
  7139	  if (!response) return;
  7140	
  7141	  const semKey = getAdminSemKey();
  7142	  // Same load guard as every other lesson writer (Phase 1 review): after a
  7143	  // failed reload the listener deliberately KEEPS the previous summer maps, so
  7144	  // the cached lesson and the existence check both still pass — without this
  7145	  // an admin could write a reply while the banner says saving is disabled.
  7146	  if (lessonDataLoadedSuccessfully === false) {
  7147	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  7148	    return;
  7149	  }
  7150	  // A semester type this writer has no branch for is refused here, before the
  7151	  // existence check below — a throw inside that try would be reported to the
  7152	  // admin as "check your connection", which it isn't (Phase 1, 1.1).
  7153	  let lessonStore;
  7154	  try {
  7155	    lessonStore = lessonStoreFor(semKey);
  7156	  } catch (err) {
  7157	    alert(err.message);
  7158	    return;
  7159	  }
  7160	  const cachedExisting = currentLessonData?.[semKey]?.[key];
  7161	  if (!cachedExisting) return;
  7162	
  7163	  let check;
  7164	  try {
  7165	    check = await adminLessonStillExistsWithRetry(semKey, key);
  7166	  } catch (err) {
  7167	    console.warn('⚠️ Existence check retry also failed:', err);
  7168	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  7169	    return;
  7170	  }
  7171	  if (!check.exists) {
  7172	    alert('This lesson was moved or removed elsewhere. Your response was not sent — please close this and check the grid for its new location.');
  7173	    return;
  7174	  }
  7175	  const existing = check.data || cachedExisting;
  7176	
  7177	  const user = getAuthUser();
  7178	  const newEntry = {
  7179	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  7180	    from: 'admin', name: user?.name || 'Admin', message: response, timestamp: new Date().toISOString()
  7181	  };
  7182	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7183	
  7184	  if (!curriculumDb) initCurriculumFirestore();
  7185	  const isSummer = lessonStore === 'camp';
  7186	  const updates = {};
  7187	  if (isSummer) {
  7188	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7189	    updates.adminResponse = response;
  7190	    updates.status = 'In Progress';
  7191	    updates.lastUpdated = new Date().toISOString();
  7192	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7193	  } else {
  7194	    updates[`${semKey}.${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7195	    updates[`${semKey}.${key}.adminResponse`] = response;
  7196	    updates[`${semKey}.${key}.status`] = 'In Progress';
  7197	    updates.lastUpdated = new Date().toISOString();
  7198	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7199	  }
  7200	  const docRef = isSummer
  7201	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7202	    : curriculumDb.collection('curriculum').doc('lessonData');
  7203	
  7204	  try {
  7205	    await docRef.update(updates);
  7206	  } catch (err) {
  7207	    console.error('Error sending help response:', err);
  7208	    alert('Error sending response: ' + err.message);
  7209	    return;
  7210	  }
  7211	
  7212	  currentLessonData[semKey][key] = {
  7213	    ...existing, adminResponse: response,
  7214	    qaThread: [...(existing.qaThread && existing.qaThread.length > 0 ? existing.qaThread : getQaThread(existing)), newEntry],
  7215	    status: 'In Progress'
  7216	  };
  7217	  renderHelpQueue();
  7218	}
  7219	
  7220	async function sendQaReply(key) {
  7221	  const input = document.getElementById(`qa-reply-${key}`);
  7222	  if (!input) return;
  7223	  const message = input.value.trim();
  7224	  if (!message) return;
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
  7257	    alert('This lesson was moved or removed elsewhere. Your reply was not sent — please close this window and check the grid for its new location.');
  7258	    return;
  7259	  }
  7260	  const existing = check.data || cachedExisting;
  7261	
  7262	  const user = getAuthUser();
  7263	  const newEntry = {
  7264	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  7265	    from: 'admin', name: user?.name || 'Admin', message, timestamp: new Date().toISOString()
  7266	  };
  7267	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  7268	
  7269	  if (!curriculumDb) initCurriculumFirestore();
  7270	  const isSummer = lessonStore === 'camp';
  7271	  const updates = {};
  7272	  if (isSummer) {
  7273	    updates.qaThread = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7274	    updates.adminResponse = message;
  7275	    updates.lastUpdated = new Date().toISOString();
  7276	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7277	  } else {
  7278	    updates[`${semKey}.${key}.qaThread`] = firebase.firestore.FieldValue.arrayUnion(...entriesToAdd);
  7279	    updates[`${semKey}.${key}.adminResponse`] = message;
  7280	    updates.lastUpdated = new Date().toISOString();
  7281	    updates.lastUpdatedBy = user?.name || 'Unknown';
  7282	  }
  7283	  const docRef = isSummer
  7284	    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
  7285	    : curriculumDb.collection('curriculum').doc('lessonData');
  7286	
  7287	  try {
  7288	    await docRef.update(updates);
  7289	  } catch (err) {
  7290	    console.error('Error sending Q&A reply:', err);
  7291	    alert('Error sending reply: ' + err.message);
  7292	    return;
  7293	  }
  7294	
  7295	  const updatedLesson = {
  7296	    ...existing, adminResponse: message,
  7297	    qaThread: [...(existing.qaThread && existing.qaThread.length > 0 ? existing.qaThread : getQaThread(existing)), newEntry]
  7298	  };
  7299	  currentLessonData[semKey][key] = updatedLesson;
  7300	  openDetailModal(updatedLesson, key, updatedLesson.teacher, updatedLesson.className, updatedLesson.weekNum);
  7301	}
  7302	
  7303	function toggleHelpQueue() {
  7304	  const content = document.getElementById('ca-help-content');
  7305	  content.style.display = content.style.display === 'none' ? 'block' : 'none';
  7306	}
  7307	
  7308	// ─── Change History ──────────────────────────────────
  7309	
  7310	async function renderChangeHistory() {
  7490	// ─── Content Count by Teacher (Data Safety Plan Stage 4A) ───────────
  7491	
  7492	// Same >10% drop threshold ~/tinker-backups/backup.js already uses for its
  7493	// own Tier-1 collection-level data-loss check — reused here for per-teacher
  7494	// consistency rather than inventing a second, unrelated threshold. A small
  7495	// routine edit (one lesson moved, one field trimmed) won't cross it; a real
  7496	// wipe of most of a teacher's content will.
  7497	const CONTENT_COUNT_DROP_THRESHOLD = 0.10;
  7498	
  7499	async function computeLiveContentCountByTeacher() {
  7500	  if (!curriculumDb) initCurriculumFirestore();
  7501	  const counts = {};
  7502	  const tally = (lesson) => {
  7503	    if (!lesson || !lesson.teacher || !lessonHasContent(lesson)) return;
  7504	    counts[lesson.teacher] = (counts[lesson.teacher] || 0) + 1;
  7505	  };
  7506	
  7507	  // Deliberately cross-season: this panel is the safety net that would notice
  7508	  // content vanishing from ANY season (per-season counting is Phase 4). But it
  7509	  // is still a summer read, so it obeys the same registry precondition as
  7510	  // every other one — no reads at all while the registry is unreadable.
  7511	  const registryMode = getSeasonRegistryMode();
  7512	  if (registryMode === 'error' || registryMode === 'unknown') {
  7513	    throw new Error(`Can't count summer content: the season registry is ${registryMode === 'unknown' ? 'unreachable' : 'unreadable'}.`);
  7514	  }
  7515	  const summerSnap = await curriculumDb.collection('summerCamps_lessonData').get();
  7516	  summerSnap.forEach(doc => tally(doc.data()));
  7517	
  7518	  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
  7519	  const lessonDataDoc = lessonDataSnap.exists ? lessonDataSnap.data() : {};
  7520	  for (const semesterLessons of Object.values(lessonDataDoc)) {
  7521	    if (!semesterLessons || typeof semesterLessons !== 'object') continue;
  7522	    for (const lesson of Object.values(semesterLessons)) tally(lesson);
  7523	  }
  7524	
  7525	  return counts;
  7526	}
  7527	
  7528	// Pure render — takes already-computed live and backup-derived per-teacher
  7529	// counts (backupCounts may be null if unavailable/inaccessible), so it's
  7530	// testable without a real Firestore read.
  7531	function renderContentCountData(liveCounts, backupCounts) {
  7532	  const container = document.getElementById('ca-content-count-content');
  7533	  if (!container) return;
  7534	
  7535	  const teachers = Array.from(new Set([
  7536	    ...Object.keys(liveCounts || {}),
  7537	    ...Object.keys(backupCounts || {}),
  7538	  ])).sort();
  7539	
  7540	  if (teachers.length === 0) {
  7541	    container.innerHTML = '<p class="ca-empty-hint">No lesson content recorded yet.</p>';
  7542	    return;
  7543	  }
  7544	
  7545	  let flaggedCount = 0;
  7546	  let rowsHtml = '';
  7547	  for (const teacher of teachers) {
  7548	    const today = liveCounts?.[teacher] || 0;
  7549	    const hasBaseline = !!backupCounts && typeof backupCounts[teacher] === 'number';
  7550	    const backupCount = hasBaseline ? backupCounts[teacher] : null;
  7551	    const isDrop = hasBaseline && backupCount > 0 &&
  7552	      ((backupCount - today) / backupCount) > CONTENT_COUNT_DROP_THRESHOLD;
  7553	    if (isDrop) flaggedCount++;
  7554	
  7555	    rowsHtml += `<tr>
  7556	      <td>${escHtml(teacher)}</td>
  7557	      <td>${today}</td>
  7558	      <td>${hasBaseline ? backupCount : '—'}</td>
  7559	      <td class="${isDrop ? 'ca-backup-flag' : ''}">${isDrop ? `⚠️ Dropped from ${backupCount} to ${today}` : 'OK'}</td>
  7560	    </tr>`;
  7561	  }
  7562	
  7563	  let html = '';
  7564	  if (!backupCounts) {
  7565	    html += '<p class="ca-empty-hint">No backup-derived comparison available yet.</p>';
  7566	  }
  7567	  if (flaggedCount > 0) {
  7568	    html += `<p class="ca-backup-flag">⚠️ ${flaggedCount} teacher${flaggedCount !== 1 ? 's' : ''} show a content-count drop of more than 10% since the last backup.</p>`;
  7569	  }
  7570	  html += `<div style="overflow-x:auto"><table class="ca-content-count-table">
  7571	    <thead><tr><th>Teacher</th><th>Today</th><th>Last Backup</th><th>Status</th></tr></thead>
  7572	    <tbody>${rowsHtml}</tbody>
  7573	  </table></div>`;
  7574	
  7575	  container.innerHTML = html;
  7576	}
  7577	
  7578	async function renderContentCount() {
  7579	  const container = document.getElementById('ca-content-count-content');
  7580	  if (!container) return;
  7581	  container.innerHTML = '<p class="ca-empty-hint">Loading content counts…</p>';
  7582	  try {
  7583	    const liveCounts = await computeLiveContentCountByTeacher();
  7584	    let backupCounts = null;
  7585	    try {
  7586	      if (!curriculumDb) initCurriculumFirestore();
  7587	      const snap = await curriculumDb.collection('backupStatus').doc('latest').get();
  7588	      backupCounts = snap.exists ? (snap.data().classbookContentByTeacher || null) : null;
  7589	    } catch (err) {
  7590	      // backupStatus is manager/admin-only (same boundary as Backup Health) —
  7591	      // degrade to "no comparison available" rather than blocking the live
  7592	      // counts, which this account can read regardless of that boundary.
  7593	      backupCounts = null;
  7594	    }
  7595	    renderContentCountData(liveCounts, backupCounts);
  7596	  } catch (err) {
  7597	    console.error('Error loading content counts:', err);
  7598	    container.innerHTML = '<p class="ca-backup-flag">⚠️ Failed to load content counts.</p>';
  7599	  }
  7600	}
  7601	
  7602	function toggleContentCount() {
  7603	  const content = document.getElementById('ca-content-count-content');
  7604	  const wasHidden = content.style.display === 'none';
  7605	  content.style.display = wasHidden ? 'block' : 'none';
  7606	  if (wasHidden) renderContentCount();
  7607	}
  7608	
  7609	
  7610	// ═════════════════════════════════════════════════════
   556	  // =====================================================
   557	  // Classbook (Curriculum) Alerts
   558	  // =====================================================
   559	
   560	  function listenToClassbook(db) {
   561	    // Teacher questions - ALL unanswered questions (immediate alerts)
   562	    const classbookListener = db.collection('curriculum')
   563	      .doc('lessonData')
   564	      .onSnapshot(doc => {
   565	        if (!doc.exists) return;
   566	
   567	        const data = doc.data();
   568	        const now = Date.now();
   569	        let unansweredQuestions = [];
   570	        const currentClassbookAlertIds = [];
   571	
   572	        // Iterate through all semesters
   573	        for (const [semKey, lessons] of Object.entries(data)) {
   574	          // Skip metadata fields
   575	          if (semKey === 'lastUpdated' || semKey === 'lastUpdatedBy') continue;
   576	          if (!lessons || typeof lessons !== 'object') continue;
   577	
   578	          // Iterate through all lessons in this semester
   579	          for (const [lessonKey, lesson] of Object.entries(lessons)) {
   580	            if (!lesson.qaThread || !Array.isArray(lesson.qaThread)) continue;
   581	
   582	            // Check if last message is from teacher (unanswered)
   583	            const thread = lesson.qaThread;
   584	            if (thread.length === 0) continue;
   585	
   586	            const lastMsg = thread[thread.length - 1];
   587	            if (lastMsg.from === 'teacher') {
   588	              // This is an unanswered question
   589	              const questionDate = lastMsg.timestamp?.toMillis ? lastMsg.timestamp.toMillis() :
   590	                                  lastMsg.timestamp ? new Date(lastMsg.timestamp).getTime() : 0;
   591	
   592	              const alertId = `classbook-qa-${lessonKey}`;
   593	              currentClassbookAlertIds.push(alertId);
   594	
   595	              // Calculate priority based on age (or use warning if no timestamp)
   596	              let priority = 'warning';
   597	              let timeText = 'Unknown time';
   598	
   599	              if (questionDate > 0) {
   600	                const hoursElapsed = Math.floor((now - questionDate) / (1000 * 60 * 60));
   601	                timeText = `${hoursElapsed}h ago`;
   602	
   603	                // Priority based on age: info (0-24h), warning (25-48h), urgent (49h+)
   604	                if (hoursElapsed >= 49) {
   605	                  priority = 'urgent';
   606	                } else if (hoursElapsed >= 25) {
   607	                  priority = 'warning';
   608	                } else {
   609	                  priority = 'info';
   610	                }
   611	              }
   612	
   613	              const questionText = lastMsg.message || lastMsg.question || 'Question';
   614	              const teacherName = lesson.teacher || lastMsg.name || 'Teacher';
   615	
   616	              const alert = {
   617	                id: alertId,
   618	                type: 'curriculum',
   619	                priority: priority,
   620	                title: `${teacherName}: ${questionText.substring(0, 50)}${questionText.length > 50 ? '...' : ''}`,
   621	                subtitle: `${lesson.className || 'Class'} - Week ${lesson.weekNum || '?'} - ${timeText}`,
   622	                timestamp: questionDate > 0 ? new Date(questionDate).toISOString() : new Date().toISOString(),
   623	                actionLabel: 'View Classbook',
   624	                actionUrl: 'https://tinker-classbook.netlify.app#curriculum-admin',
   625	                metadata: { lessonKey, semKey }
   626	              };
   627	              unansweredQuestions.push(alert);
   628	            }
   629	          }
   630	        }
   631	
   632	        // Remove old Classbook alerts that are no longer unanswered
   633	        alerts.forEach(alert => {
   634	          if (alert.type === 'curriculum' && !currentClassbookAlertIds.includes(alert.id)) {
   635	            removeAlert(alert.id);
   636	          }
   637	        });
   638	
   639	        // Update all Q&A alerts
   640	        unansweredQuestions.forEach(alert => addOrUpdateAlert(alert));
   641	
   642	        updateUI();
   643	      }, error => {
   644	        console.error('Classbook listener error:', error);
   645	      });
   646	
   647	    listeners.push(classbookListener);
   648	  }
   649	
   650	  // =====================================================
   651	  // Alert Management
   652	  // =====================================================
   653	
   654	  function addOrUpdateAlert(alert) {
   655	    if (dismissedAlertIds.has(alert.id)) {
   656	      // Route to dismissed list — alert is still tracked but not shown as active
   657	      alert.dismissed = true;
   658	      const existingIndex = dismissedAlerts.findIndex(a => a.id === alert.id);
   659	      if (existingIndex >= 0) {
   660	        dismissedAlerts[existingIndex] = alert;
   661	      } else {
   662	        dismissedAlerts.push(alert);
   663	      }
   664	      return;
   665	    }
   666	
   667	    const existingIndex = alerts.findIndex(a => a.id === alert.id);
   668	    if (existingIndex >= 0) {
   669	      alerts[existingIndex] = alert;
   670	    } else {

codex
One unresolved transition race is now concrete: Phase A freezes only the old source, not the new target. The instant Phase C creates `lessons_spring-2026`, a Phase-B tab’s listener can enable a Spring save before the plan’s forced-read verification. That legitimate save changes the target hash; the prescribed “verify fails → delete target” recovery would discard the edit. I’m tracing the same concurrency issue through Phase D and the Studio Hub alert aggregation now.
exec
/bin/zsh -lc "rg -n --hidden --glob '"'!node_modules/**'"' --glob '"'!Library/**'"' --glob '"'!Downloads/**'"' --glob '"'!*.log'"' \"curriculum.{0,120}lessonData|lessonData.{0,120}curriculum|doc\\(['\\\"]lessonData['\\\"]\\)|doc\\(['\\\"]curriculum['\\\"],\\s*['\\\"]lessonData['\\\"]\" /Users/christiehubley/tinker-spring-curriculum /Users/christiehubley/studio-hub /Users/christiehubley/tinker-backups /Users/christiehubley/summer-camp-app 2>/dev/null
rg -n \"firebase-data\\.js|app\\.js|<script\" index.html | tail -80
nl -ba js/app.js | sed -n '3560,3720p;5800,5890p;6400,6520p'
nl -ba js/firebase-data.js | sed -n '1450,1525p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 472ms:
/Users/christiehubley/tinker-backups/backup.js:33:  'summerCamps_lessonData', 'summerCamps_curriculum', 'summerCamps_projectDetails',
/Users/christiehubley/tinker-backups/backup.js:381:  // Non-summer path: curriculum/lessonData doc, nested { semesterKey: { lessonKey: {...} } }.
/Users/christiehubley/tinker-backups/backup.js:382:  const lessonDataDoc = (collections['curriculum'] || {})['lessonData'] || {};
/Users/christiehubley/tinker-backups/backup.js.bak-2026-09-27-before-booking-retire:33:  'summerCamps_lessonData', 'summerCamps_curriculum', 'summerCamps_projectDetails',
/Users/christiehubley/tinker-backups/backup.js.bak-2026-09-27-before-booking-retire:379:  // Non-summer path: curriculum/lessonData doc, nested { semesterKey: { lessonKey: {...} } }.
/Users/christiehubley/tinker-backups/backup.js.bak-2026-09-27-before-booking-retire:380:  const lessonDataDoc = (collections['curriculum'] || {})['lessonData'] || {};
/Users/christiehubley/tinker-backups/manual-snapshots/lessonData-junk-root-keys-2026-09-20T23-47-15-470Z.json:3:  "doc": "curriculum/lessonData",
/Users/christiehubley/studio-hub/firebase-agent-defense-hardening.md:177:  that reads, filters, and rewrites the *entire* shared `curriculum/lessonData`
/Users/christiehubley/studio-hub/firebase-agent-defense-hardening.md:194:  target (`curriculum/lessonData_backup`) is a single doc overwritten each
/Users/christiehubley/studio-hub/rules.test.js:1482:  'summerCamps_curriculum', 'summerCamps_schedule', 'summerCamps_lessonData',
/Users/christiehubley/studio-hub/test-alerts-browser.html:227:        const curriculumRef = db.collection('curriculum').doc('lessonData');
/Users/christiehubley/studio-hub/test-alerts-browser.html:278:        const curriculumRef = db.collection('curriculum').doc('lessonData');
/Users/christiehubley/studio-hub/firestore.rules:746:    // curriculum, lessonData, projectDetails, projectLibrary, schedule:
/Users/christiehubley/studio-hub/js/alerts.js:563:      .doc('lessonData')
/Users/christiehubley/tinker-spring-curriculum/js/app.js:3683:  // under that key into curriculum/lessonData is never right. Routed by TYPE
/Users/christiehubley/tinker-spring-curriculum/js/app.js:3742:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
/Users/christiehubley/tinker-spring-curriculum/js/app.js:4593:  // curriculum/lessonData, and no collection is ever cleared from here.
/Users/christiehubley/tinker-spring-curriculum/js/app.js:4631:  // curriculum/lessonData to delete. A camp season's lessons live in the
/Users/christiehubley/tinker-spring-curriculum/js/app.js:4739:// curriculum/lessonData write.
/Users/christiehubley/tinker-spring-curriculum/js/app.js:4866:// roster, no week grid, no lesson slots and no curriculum/lessonData write —
/Users/christiehubley/tinker-spring-curriculum/js/app.js:5879:// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
/Users/christiehubley/tinker-spring-curriculum/js/app.js:5887:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
/Users/christiehubley/tinker-spring-curriculum/js/app.js:5903:      const snap = await curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key)).get({ source: 'server' });
/Users/christiehubley/tinker-spring-curriculum/js/app.js:7253:    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
/Users/christiehubley/tinker-spring-curriculum/js/app.js:7254:    : curriculumDb.collection('curriculum').doc('lessonData');
/Users/christiehubley/tinker-spring-curriculum/js/app.js:7336:    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
/Users/christiehubley/tinker-spring-curriculum/js/app.js:7337:    : curriculumDb.collection('curriculum').doc('lessonData');
/Users/christiehubley/tinker-spring-curriculum/js/app.js:7567:  const summerSnap = await curriculumDb.collection('summerCamps_lessonData').get();
/Users/christiehubley/tinker-spring-curriculum/js/app.js:7570:  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
/Users/christiehubley/tinker-spring-curriculum/js/app.js:11891:    // The curriculum/lessonData listener rebuilds the whole summer cache from
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:7://   curriculum/lessonData  — all lesson content by semester (imported from classbooks)
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:57:// shared curriculum/lessonData document). The seven sites that choose between
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:730:// ─── Lesson Data (curriculum/lessonData) ─────────────
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:762:    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:815:  // Regular semester: save to curriculum/lessonData
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:817:  await curriculumDb.collection('curriculum').doc('lessonData').set({
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:830:  await curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:854:    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:963:  await curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:968:// Forced-server read of one semester's whole lesson map in curriculum/lessonData
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:975:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:985:  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:995:  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1078:// shared curriculum/lessonData doc re-runs the summer collection reload.
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1171:  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1182:      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1376:  // callers fall through to curriculum/lessonData on anything that isn't
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1413:    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semesterKey, lessonKey));
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1429:  // Regular semester: curriculum/lessonData is one shared doc across every
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1436:  console.log('💾 Saving to curriculum/lessonData with per-field paths:', Object.keys(updates));
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1438:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1447:// object for ONE lesson within the shared curriculum/lessonData document,
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1500:  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
/Users/christiehubley/tinker-spring-curriculum/js/firebase-data.js:1876:// every one carrying `yearKey`. Nothing here touches curriculum/lessonData or
/Users/christiehubley/tinker-spring-curriculum/CLASSBOOK-DATA-SAFETY-PLAN.md:41:  - **4A — Content Count by Teacher**: new admin panel (Curriculum Admin, below Change History) computing today's live per-teacher lesson-content count from `summerCamps_lessonData` + `curriculum/lessonData` and comparing it to a backup-derived baseline (see 4B). Only a >10% drop is red-flagged (same threshold `~/tinker-backups/backup.js` already uses for its own collection-level check) — a teacher with no recorded baseline, or a small routine edit, is never falsely flagged. `CONTENT_FIELDS`/`lessonHasContent()` — previously duplicated across 4 call sites in `app.js`/`firebase-data.js` — consolidated into one shared constant in `firebase-data.js` as part of this work.
/Users/christiehubley/tinker-spring-curriculum/CLASSBOOK-DATA-SAFETY-PLAN.md:45:- ✅ Stage 5 — Expand test coverage (Aug 13, 2026). Checked all 7 items on this stage's original checklist against tests already added while shipping Phases 1–5: 6 of 7 were already covered as a side effect (admin move abort/restore, admin swap targeted-saves + canary, Plan Complete checkbox / Test 5, non-summer stripping, read-back verification error, intentional field clear). Only "content-count dashboard shows correct numbers for a seeded test teacher" was genuinely open — added one test seeding known content across both `summerCamps_lessonData` and `curriculum/lessonData` for a dedicated test teacher, asserting `computeLiveContentCountByTeacher()` returns exactly the expected count and excludes a deliberately contentless lesson. Validated the test's own worth by temporarily breaking the `hasContent` filter, confirming the test failed (4 instead of 3), then restoring and confirming green — same discipline as every prior phase's red/green cycle, applied here to prove a coverage test actually exercises what it claims. Test-only change, no app code touched. **This closes the Classbook Data Safety Plan — all 5 remaining-stages phases (and the earlier Stages 0/1A/1B/1C) are shipped, tested, committed, and deployed to production.**
/Users/christiehubley/tinker-spring-curriculum/CLASSBOOK-DATA-SAFETY-PLAN.md:633:const destDoc = await curriculumDb.collection('summerCamps_lessonData').doc(encodeFirestoreKey(newDestKey)).get();
/Users/christiehubley/tinker-spring-curriculum/CLASSBOOK-DATA-SAFETY-PLAN.md:705:await curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-spring-curriculum/CLASSBOOK-DATA-SAFETY-PLAN.md:720:await curriculumDb.collection('summerCamps_lessonData').doc(encodeFirestoreKey(lessonKey)).set(cleanData, { merge: true });
/Users/christiehubley/tinker-spring-curriculum/CLASSBOOK-DATA-SAFETY-PLAN.md:723:const verification = await curriculumDb.collection('summerCamps_lessonData').doc(encodeFirestoreKey(lessonKey)).get();
250:      <!-- School Day Off Camps editors (Phase 1) — bodies are rendered by js/app.js -->
571:  <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-app-compat.js"></script>
572:  <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-auth-compat.js"></script>
573:  <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-firestore-compat.js"></script>
574:  <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-storage-compat.js"></script>
576:  <script src="js/firebase-config.js"></script>
577:  <script src="js/auth-guard.js"></script>
578:  <script src="js/firebase-data.js"></script>
579:  <script src="js/app.js"></script>
  3560	        return { field, before, after, potentialWipe: after === 0 && before > 50 };
  3561	      });
  3562	      await logTeacherEdit(semKey, lessonKey, originalLesson, changedFieldEntries);
  3563	    } catch (logErr) {
  3564	      console.error('⚠️ Lesson saved, but Change History logging failed:', logErr);
  3565	    }
  3566	
  3567	    // Show success — stay open, reset dirty state
  3568	    if (saveBtn) { saveBtn.textContent = 'Saved!'; }
  3569	    if (autoSaveStatus) {
  3570	      autoSaveStatus.textContent = fieldsToClear.length > 0
  3571	        ? `✓ Saved (${fieldsToClear.join(', ')} cleared)`
  3572	        : '✓ Saved';
  3573	    }
  3574	
  3575	    // Reset dirty baseline so closing won't prompt "unsaved changes"
  3576	    const snapshot = getTeEditFormData();
  3577	    teOriginalData = {
  3578	      projectTitle: snapshot.projectTitle,
  3579	      shortDetails: snapshot.shortDetails,
  3580	      inspoLink: snapshot.inspoLink,
  3581	      introPitch: snapshot.introPitch,
  3582	      processStep1: snapshot.processStep1,
  3583	      processStep2: snapshot.processStep2,
  3584	      processStep3: snapshot.processStep3,
  3585	      processStep4: snapshot.processStep4,
  3586	      closure: snapshot.closure,
  3587	      materials: snapshot.materials,
  3588	      dayOfMaterials: snapshot.dayOfMaterials,
  3589	      materialsList: JSON.stringify(snapshot.materialsList || []),
  3590	      planComplete: snapshot.planComplete ? 'true' : 'false'
  3591	    };
  3592	
  3593	    setTimeout(() => {
  3594	      if (saveBtn) { saveBtn.textContent = 'Save'; saveBtn.disabled = false; }
  3595	      if (autoSaveStatus) autoSaveStatus.textContent = '';
  3596	    }, 1500);
  3597	  } catch (err) {
  3598	    console.error('Error saving lesson:', err);
  3599	    if (saveBtn) { saveBtn.disabled = false; saveBtn.textContent = 'Save'; }
  3600	    if (autoSaveStatus) { autoSaveStatus.textContent = '⚠️ Save failed'; autoSaveStatus.style.color = 'var(--error)'; }
  3601	  }
  3602	}
  3603	
  3604	// Backtracking audit Phase 10 (R3-3, R4-5): this used to rebuild the whole
  3605	// Q&A thread from the modal's lesson object and hand the ENTIRE lesson to
  3606	// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
  3607	// silently dropped any message (or any other field) another client had
  3608	// landed since this modal opened. Now a single targeted .update() touching
  3609	// only this lesson's own Q&A paths, with arrayUnion() for the thread — the
  3610	// same atomic-append design sendHelpResponse()/sendQaReply() already use —
  3611	// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
  3612	// record. `modalSemKey` is the semester the modal was opened under: the
  3613	// global selector can change while the modal stays open, and a dotted-path
  3614	// update under the wrong semester would create a Q&A-only ghost lesson there.
  3615	async function sendTeacherQaMessage(lessonKey, modalSemKey) {
  3616	  const input = document.getElementById('te-qa-input');
  3617	  if (!input) return;
  3618	  const message = input.value.trim();
  3619	  if (!message) return;
  3620	  // Same load-guard saveSingleLesson() enforced on the old path — after a
  3621	  // failed load the cache is empty, so the legacy-thread migration below
  3622	  // would run blind against whatever is really on the server.
  3623	  if (lessonDataLoadedSuccessfully === false) {
  3624	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  3625	    return;
  3626	  }
  3627	
  3628	  const semKey = modalSemKey || getTvSemKey();
  3629	  // This modal never hosts a camp season (the Today View routes those to the
  3630	  // summer editor, whose Q&A lives in summerCamps_prepHelpQueue), so a write
  3631	  // under that key into curriculum/lessonData is never right. Routed by TYPE
  3632	  // now (Phase 1, 1.1) — a third type is refused out loud rather than written
  3633	  // into the shared weekly document.
  3634	  let lessonStore;
  3635	  try {
  3636	    lessonStore = lessonStoreFor(semKey);
  3637	  } catch (err) {
  3638	    alert(err.message);
  3639	    return;
  3640	  }
  3641	  if (lessonStore === 'camp') {
  3642	    alert('Summer camp questions are sent from the camp lesson editor.');
  3643	    return;
  3644	  }
  3645	
  3646	  // Confirm the lesson still exists on the server (an admin may have moved or
  3647	  // deleted it since this modal opened). A dotted-path update would otherwise
  3648	  // recreate the old key as a Q&A-only ghost lesson. Same forced read and
  3649	  // accepted check-to-write residual as sendHelpResponse()/sendQaReply().
  3650	  let check;
  3651	  try {
  3652	    check = await adminLessonStillExistsWithRetry(semKey, lessonKey);
  3653	  } catch (err) {
  3654	    console.warn('⚠️ Existence check retry also failed:', err);
  3655	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  3656	    return;
  3657	  }
  3658	  if (!check.exists) {
  3659	    alert('This lesson was moved or removed elsewhere. Your message was not sent — please close this and check the classbook for its new location.');
  3660	    return;
  3661	  }
  3662	  const existing = check.data;
  3663	
  3664	  const user = getAuthUser();
  3665	  const isAdmin = ['admin', 'manager'].includes(user?.role);
  3666	  const newEntry = {
  3667	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  3668	    from: isAdmin ? 'admin' : 'teacher',
  3669	    name: user?.name || 'Unknown',
  3670	    message,
  3671	    timestamp: new Date().toISOString()
  3672	  };
  3673	  // The fresh server copy decides whether a legacy teacherNotes/adminResponse
  3674	  // thread still needs migrating into qaThread on this lesson's first entry.
  3675	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  3676	  const editedAt = new Date().toISOString();
  3677	  const editedBy = user?.name || 'Unknown';
  3678	
  3679	  const updates = {
  3680	    [`${semKey}.${lessonKey}.qaThread`]: firebase.firestore.FieldValue.arrayUnion(...entriesToAdd),
  3681	    [`${semKey}.${lessonKey}.lastEditedBy`]: editedBy,
  3682	    [`${semKey}.${lessonKey}.lastEditedAt`]: editedAt,
  3683	  };
  3684	  // Legacy mirror fields, kept for compatibility with older readers.
  3685	  const legacyField = isAdmin ? 'adminResponse' : 'teacherNotes';
  3686	  updates[`${semKey}.${lessonKey}.${legacyField}`] = message;
  3687	
  3688	  try {
  3689	    if (!curriculumDb) initCurriculumFirestore();
  3690	    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
  3691	  } catch (err) {
  3692	    console.error('Error sending Q&A message:', err);
  3693	    alert('Error sending message: ' + err.message);
  3694	    return;
  3695	  }
  3696	
  3697	  // Confirmed — make sure the local cache shows the new message before the
  3698	  // live listener catches up. Usually the listener already HAS: a local
  3699	  // write triggers a latency-compensated snapshot (with the arrayUnion
  3700	  // applied) before the server ack resolves the await above, so the entry
  3701	  // is deduplicated by id rather than appended blindly — a duplicate here
  3702	  // would be persisted by the next autosave, which writes the cached
  3703	  // qaThread back as a whole array.
  3704	  if (currentLessonData?.[semKey]?.[lessonKey]) {
  3705	    const cached = currentLessonData[semKey][lessonKey];
  3706	    const baseThread = cached.qaThread && cached.qaThread.length > 0 ? cached.qaThread : getQaThread(cached);
  3707	    const alreadyThere = baseThread.some(m => m.id === newEntry.id);
  3708	    currentLessonData[semKey][lessonKey] = {
  3709	      ...cached,
  3710	      qaThread: alreadyThere ? baseThread : [...baseThread, newEntry],
  3711	      [legacyField]: message,
  3712	      lastEditedBy: editedBy,
  3713	      lastEditedAt: editedAt,
  3714	    };
  3715	  }
  3716	  input.value = '';
  3717	  // Re-open the modal to show the updated thread — only if the Today View is
  3718	  // still on this modal's semester; otherwise it would open a different
  3719	  // semester's lesson under the same key.
  3720	  if (getTvSemKey() === semKey) openTeacherEditModal(lessonKey);
  5800	    const keptTitle = firestorePayload.projectTitle || existing.projectTitle || title;
  5801	    await appendChangeLogEntry(semKey, {
  5802	      action: existing.projectTitle ? 'edit' : 'create',
  5803	      details: { projectTitle: keptTitle, teacher, className, weekNum }
  5804	    });
  5805	    renderChangeHistory();
  5806	  } catch (e) { console.warn('Could not write change log entry:', e); }
  5807	}
  5808	
  5809	function startSwap(sourceKey) {
  5810	  caActionMode = 'swap';
  5811	  caSourceKey = sourceKey;
  5812	  closeAdminModal();
  5813	  renderAdminGrid();
  5814	}
  5815	
  5816	function cancelGridAction() {
  5817	  caActionMode = null;
  5818	  caSourceKey = null;
  5819	  renderAdminGrid();
  5820	}
  5821	
  5822	// Data Safety Plan Stage 2A/2B: shared helpers for the admin grid's move/swap
  5823	// abort-and-restore paths (see CLASSBOOK-DATA-SAFETY-PLAN.md).
  5824	// lessonHasContent() now lives in firebase-data.js (CONTENT_FIELDS is the
  5825	// single source of truth, Data Safety Plan Stage 4A) — this file just uses it.
  5826	
  5827	// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
  5828	// model. Backtracking audit, Phase 2 (reinstated round 4): adds an optional
  5829	// opts.source === 'server' param, needed by Phase 8's
  5830	// adminLessonStillExistsWithRetry() existence check below — omitting opts
  5831	// preserves the exact prior (cache-permitting) default for any future caller.
  5832	async function readAdminLessonDoc(semKey, lessonKey, opts = {}) {
  5833	  if (!curriculumDb) initCurriculumFirestore();
  5834	  const getOpts = opts.source === 'server' ? { source: 'server' } : undefined;
  5835	  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
  5836	  return snap.exists ? (snap.data()?.[semKey]?.[lessonKey] || null) : null;
  5837	}
  5838	
  5839	// Backtracking audit, Phase 8: shared by cutProject() below and Phase 11's
  5840	// sendHelpResponse()/sendQaReply() (not yet implemented) — forced server
  5841	// read, retried once on failure, then lets a second failure throw so each
  5842	// caller decides how to surface it. Residual TOCTOU race (check-to-write gap)
  5843	// deliberately accepted, matching the companion plan's own decision for this
  5844	// identical helper — bounded by human click-to-click timing, not a tight
  5845	// machine loop; closing it fully would need a Firestore transaction.
  5846	async function adminLessonStillExistsWithRetry(semKey, key) {
  5847	  if (!curriculumDb) initCurriculumFirestore();
  5848	  const isSummer = lessonStoreFor(semKey) === 'camp';   // Phase 1, 1.1 — by type, and a third type throws
  5849	  const readOnce = async () => {
  5850	    if (isSummer) {
  5851	      const snap = await curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key)).get({ source: 'server' });
  5852	      return { exists: snap.exists, data: snap.exists ? snap.data() : null };
  5853	    }
  5854	    const data = await readAdminLessonDoc(semKey, key, { source: 'server' });
  5855	    return { exists: data !== null, data };
  5856	  };
  5857	  try {
  5858	    return await readOnce();
  5859	  } catch (err) {
  5860	    console.warn('⚠️ Existence check read failed, retrying once:', err);
  5861	    return await readOnce(); // a second failure throws — caller's catch handles it
  5862	  }
  5863	}
  5864	
  5865	// Reverts the admin grid's optimistic in-memory update after a move/swap that
  5866	// failed to save or failed verification — puts both slots back to their
  5867	// pre-action state (deleting the dest slot if it didn't exist before) and re-renders.
  5868	function restoreGridActionState(semKey, sourceKey, sourceLesson, destKey, destLesson) {
  5869	  if (!currentLessonData[semKey]) currentLessonData[semKey] = {};
  5870	  currentLessonData[semKey][sourceKey] = sourceLesson;
  5871	  if (destLesson) {
  5872	    currentLessonData[semKey][destKey] = destLesson;
  5873	  } else {
  5874	    delete currentLessonData[semKey][destKey];
  5875	  }
  5876	  renderAdminGrid();
  5877	}
  5878	
  5879	async function handleGridAction(destTeacher, destClassName, destWeekNum, destKey) {
  5880	  const semKey = getAdminSemKey();
  5881	  const lessons = { ...currentLessonData[semKey] };
  5882	  const sourceLesson = lessons[caSourceKey];
  5883	
  5884	  if (!sourceLesson) {
  5885	    cancelGridAction();
  5886	    return;
  5887	  }
  5888	
  5889	  // Prevent moving to same cell
  5890	  if (caSourceKey === destKey) {
  6400	        html += `<div class="ca-cut-item" onclick="pasteFromCutBank(${idx}, '${escAttr(teacher)}', '${escAttr(className)}', ${weekNum}, '${escAttr(other.key)}')">
  6401	          <div class="ca-cut-item-title">${escHtml(proj.projectTitle)}</div>
  6402	          <div class="ca-cut-item-meta">Originally: ${escHtml(proj.originalTeacher)} / ${escHtml(proj.originalClassName || '')} Week ${proj.originalWeek} &middot; Cut ${new Date(proj.cutDate).toLocaleDateString()}</div>
  6403	        </div>`;
  6404	      });
  6405	      html += '</div></div>';
  6406	    }
  6407	    html += '</details>';
  6408	  }
  6409	
  6410	  body.innerHTML = html;
  6411	}
  6412	
  6413	// Backtracking audit, Phase 8: targeted single-lesson save (not a bulk
  6414	// saveLessonData() semester overwrite), removal via FieldValue.arrayRemove()
  6415	// (not saveCutProjects()'s local-splice-then-full-array-overwrite — matches
  6416	// cutProject()'s arrayUnion() append-side fix, same document, same reasoning:
  6417	// two admins acting on the Cut Bank concurrently now both survive). The
  6418	// reconstruction below is an EXPLICIT FIELD WHITELIST, not spread-minus-
  6419	// exclude — a whitelist can't leak a future field cutProject()'s
  6420	// complete-spread archive starts including that an exclude-list doesn't yet
  6421	// know to exclude. classSize preserves the destination's own existing
  6422	// scaffold value (round-6 fix) rather than being hardcoded to 0 — nothing
  6423	// downstream recomputes it on paste. teacherNotes/adminResponse/status are
  6424	// excluded alongside qaThread (round-6 fix): getQaThread() reconstructs a
  6425	// Q&A thread from teacherNotes/adminResponse whenever qaThread is absent, so
  6426	// restoring those two fields alone would still leak the original
  6427	// conversation even with qaThread itself correctly omitted.
  6428	async function pasteFromCutBank(cutIndex, teacher, className, weekNum, sourceSemKey) {
  6429	  const destSemKey = getAdminSemKey();
  6430	  const srcSemKey = sourceSemKey || destSemKey;
  6431	  const cutProjects = currentCutProjects?.[srcSemKey] || [];
  6432	  const proj = cutProjects[cutIndex];
  6433	  if (!proj) return;
  6434	
  6435	  const isCrossSemester = srcSemKey !== destSemKey;
  6436	  const srcSemName = currentConfig?.semesters?.[srcSemKey]?.name || srcSemKey;
  6437	  const confirmMsg = isCrossSemester
  6438	    ? `Paste "${proj.projectTitle}" from ${srcSemName} into ${teacher} / ${className} Week ${weekNum}?`
  6439	    : `Paste "${proj.projectTitle}" into ${teacher} / ${className} Week ${weekNum}?`;
  6440	  if (!confirm(confirmMsg)) return;
  6441	
  6442	  const key = makeLessonKey(teacher, className, weekNum);
  6443	  const lessons = { ...(currentLessonData?.[destSemKey] || {}) };
  6444	  const existingDest = lessons[key] || {};
  6445	  const existingDestClassSize = existingDest.classSize || 0;
  6446	  const existingDestPhotoPath = existingDest.photoPath || null;
  6447	
  6448	  lessons[key] = {
  6449	    teacher, className, weekNum, weekDate: '', classSize: existingDestClassSize,
  6450	    projectTitle: proj.projectTitle,
  6451	    shortDetails: proj.shortDetails || '',
  6452	    inspoLink: proj.inspoLink || '',
  6453	    introPitch: proj.introPitch || '',
  6454	    processStep1: proj.processStep1 || '', processStep2: proj.processStep2 || '',
  6455	    processStep3: proj.processStep3 || '', processStep4: proj.processStep4 || '',
  6456	    closure: proj.closure || '',
  6457	    materials: proj.materials || '',
  6458	    materialsList: proj.materialsList || [],
  6459	    dayOfMaterials: proj.dayOfMaterials || '',
  6460	    publishToPrep: proj.publishToPrep || '',
  6461	    lastImported: new Date().toISOString()
  6462	    // Deliberately NOT restored: qaThread, photoUrl/photoPath, planComplete
  6463	    // (tied to the ORIGINAL lesson instance, not reusable project content),
  6464	    // and teacherNotes/adminResponse/status (round-6: getQaThread() would
  6465	    // silently reconstruct the original Q&A conversation from these alone).
  6466	  };
  6467	  // Merely OMITTING those fields above only means "don't touch them" — if the
  6468	  // DESTINATION slot already had its own stale qaThread/photo/planComplete
  6469	  // from whatever occupied it before, that would otherwise survive untouched
  6470	  // and resurrect an unrelated Q&A thread under the newly-pasted content.
  6471	  // Explicitly clear them so a paste genuinely starts fresh.
  6472	  const NON_CONTENT_FIELDS_TO_CLEAR = ['qaThread', 'photoUrl', 'photoPath', 'planComplete', 'teacherNotes', 'adminResponse', 'status'];
  6473	
  6474	  let pasteConfirmed = false;
  6475	  try {
  6476	    await saveSingleLesson(destSemKey, key, lessons[key], NON_CONTENT_FIELDS_TO_CLEAR);
  6477	    pasteConfirmed = true;
  6478	  } catch (err) {
  6479	    console.error('❌ Paste from Cut Bank failed to save the lesson:', err);
  6480	    alert(`Could not paste "${proj.projectTitle}" — please try again.`);
  6481	    return;
  6482	  }
  6483	
  6484	  // Only delete the destination's old photo from Storage after Firestore has
  6485	  // confirmed the clear — same safe ordering as saveAdminEdit()/saveTeacherEdit().
  6486	  if (existingDestPhotoPath) {
  6487	    try {
  6488	      await deleteLessonPhoto(existingDestPhotoPath);
  6489	    } catch (cleanupErr) {
  6490	      console.error('⚠️ Could not clean up destination\'s old photo after paste (Firestore is correct, Storage has an orphan):', cleanupErr);
  6491	    }
  6492	  }
  6493	
  6494	  currentLessonData[destSemKey] = lessons;
  6495	  closeAdminModal();
  6496	  renderAdminGrid();
  6497	
  6498	  if (!curriculumDb) initCurriculumFirestore();
  6499	  try {
  6500	    await curriculumDb.collection('curriculum').doc('cutProjects').set({
  6501	      [srcSemKey]: firebase.firestore.FieldValue.arrayRemove(proj)
  6502	    }, { merge: true });
  6503	    if (currentCutProjects?.[srcSemKey]) {
  6504	      currentCutProjects[srcSemKey] = currentCutProjects[srcSemKey].filter(p => p !== proj);
  6505	    }
  6506	    renderCutBank();
  6507	  } catch (err) {
  6508	    console.error('❌ Lesson saved, but failed to persist Cut Bank removal:', err);
  6509	    alert('The lesson saved successfully, but this project could not be removed from the Cut Bank — it may still appear there. Reload to check.');
  6510	  }
  6511	
  6512	  try {
  6513	    await appendChangeLogEntry(destSemKey, {
  6514	      action: 'paste',
  6515	      details: {
  6516	        projectTitle: proj.projectTitle, teacher, className, toWeek: weekNum, fromCutBank: true,
  6517	        crossSemester: isCrossSemester || undefined,
  6518	        sourceSemester: isCrossSemester ? srcSemName : undefined,
  6519	        originalTeacher: proj.originalTeacher, originalWeek: proj.originalWeek
  6520	      }
  1450	// saveMultipleLessonFields() below without duplicating the stripping/clearing
  1451	// logic. Strips empty content fields the same way the summer branch does, by
  1452	// omitting their dotted path entirely — never sending an explicit empty
  1453	// string — and applies clears AFTER the JSON sanitization pass, since
  1454	// FieldValue.delete() is a special sentinel a JSON round-trip would corrupt.
  1455	function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = []) {
  1456	  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above saveSingleLesson().
  1457	  const stripped = { ...lessonData };
  1458	  CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
  1459	  const cleanData = JSON.parse(JSON.stringify(stripped));
  1460	  fieldsToClear.forEach(f => { cleanData[f] = firebase.firestore.FieldValue.delete(); });
  1461	  const updates = {};
  1462	  for (const [field, value] of Object.entries(cleanData)) {
  1463	    updates[`${semesterKey}.${lessonKey}.${field}`] = value;
  1464	  }
  1465	  return updates;
  1466	}
  1467	
  1468	// Backtracking audit, Phase 9: combine multiple lesson writes and/or
  1469	// whole-lesson deletes into ONE atomic Firestore .update() call — either
  1470	// every write/delete in the call lands, or none do. Closes the
  1471	// PARTIAL-FAILURE race that move/swap's prior sequential-writes design was
  1472	// vulnerable to (does NOT independently verify the given lessonData reflects
  1473	// current server state — see Phase 9's note in the plan for the deliberately
  1474	// deferred, separately-tracked stale-input race).
  1475	async function saveMultipleLessonFields(semesterKey, writes = [], deletes = []) {
  1476	  if (lessonDataLoadedSuccessfully === false) {
  1477	    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  1478	  }
  1479	  if (lessonStoreFor(semesterKey) === 'camp') {
  1480	    // Camp-season lessons live in a separate per-lesson-document collection — no
  1481	    // single-document atomicity is available across lessons there. Not
  1482	    // reachable today (the admin grid's move/swap UI is gated away from
  1483	    // summer semesters), but this guard exists so a future caller can't
  1484	    // silently get a false sense of atomicity if that ever changes.
  1485	    throw new Error('saveMultipleLessonFields() does not support camp seasons — use saveSingleLesson() per lesson instead.');
  1486	  }
  1487	  if (!curriculumDb) initCurriculumFirestore();
  1488	  const user = getAuthUser();
  1489	  const combined = {};
  1490	  for (const { lessonKey, lessonData, fieldsToClear } of writes) {
  1491	    lessonData.lastEditedBy = user?.name || 'Unknown';
  1492	    lessonData.lastEditedAt = new Date().toISOString();
  1493	    Object.assign(combined, buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear || []));
  1494	  }
  1495	  for (const lessonKey of deletes) {
  1496	    combined[`${semesterKey}.${lessonKey}`] = firebase.firestore.FieldValue.delete();
  1497	  }
  1498	  combined.lastUpdated = new Date().toISOString();
  1499	  combined.lastUpdatedBy = user?.name || 'Unknown';
  1500	  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
  1501	}
  1502	
  1503	// ─── Photo Upload (Firebase Storage) ─────────────────
  1504	
  1505	function getFirebaseStorage() {
  1506	  // Single init path: initFirebaseApp() (js/firebase-config.js) is the one
  1507	  // place that knows whether this page is in emulator mode, so a bare
  1508	  // initializeApp(FIREBASE_CONFIG) here could point Storage at production
  1509	  // while Firestore sits on the emulator.
  1510	  initFirebaseApp();
  1511	  return firebase.storage();
  1512	}
  1513	
  1514	// Backtracking audit, Phase 5 (R3-5, R3-6, R4-7): every upload gets a path
  1515	// that is unique PER UPLOAD, not per lesson. With a deterministic path the
  1516	// replacement upload overwrote the live object before Firestore confirmed
  1517	// the save (a failed save then pointed at a photo that no longer existed),
  1518	// a swap could put one lesson's replacement on top of the other lesson's
  1519	// still-referenced object, and the summer modal's "delete the old path"
  1520	// step deleted the object it had just uploaded. Callers keep the OLD path,
  1521	// save, then delete it only after a confirmed save (see saveTeacherEdit(),
  1522	// saveAdminEdit(), and the summer modal's saveLesson()). Date.now() alone is
  1523	// millisecond resolution — the random suffix keeps two near-simultaneous
  1524	// uploads for the same lesson apart.
  1525	function uniquePhotoSuffix() {

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/studio-hub/test-alerts.js | sed -n '70,165p'
nl -ba /Users/christiehubley/studio-hub/test-alerts-browser.html | sed -n '200,300p'
nl -ba /Users/christiehubley/studio-hub/TESTING-GUIDE.md | sed -n '90,190p'
nl -ba /Users/christiehubley/summer-camp-app/PROJECT-SUMMARY.md | sed -n '115,145p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
    70	    meetingType: 'Staff Meeting',
    71	    meetingDate: admin.firestore.Timestamp.fromDate(fiveDaysAgo),
    72	    attendees: ['Test User'],
    73	    actionItems: [
    74	      {
    75	        text: 'Follow up with test customer about event details',
    76	        assignedTo: 'Test User',
    77	        completed: false,
    78	        createdAt: fiveDaysAgo.toISOString()
    79	      }
    80	    ],
    81	    notes: 'TEST DATA - Added by alert testing script'
    82	  };
    83	
    84	  const docRef = await db.collection('meetings').add(testMeeting);
    85	  console.log(`✅ Added meeting with action item: ${docRef.id}`);
    86	  console.log('Expected alert: "Action item: Follow up with test customer..." (priority: info)');
    87	  return docRef.id;
    88	}
    89	
    90	async function addClassbookQuestion() {
    91	  console.log('📚 Adding unanswered Classbook question...');
    92	
    93	  // Question from 3 days ago (72 hours)
    94	  const threeDaysAgo = new Date();
    95	  threeDaysAgo.setDate(threeDaysAgo.getDate() - 3);
    96	
    97	  // Get current curriculum data
    98	  const curriculumRef = db.collection('curriculum').doc('lessonData');
    99	  const doc = await curriculumRef.get();
   100	
   101	  let qaData = [];
   102	  if (doc.exists && doc.data().qaData) {
   103	    qaData = doc.data().qaData;
   104	  }
   105	
   106	  // Add unanswered question
   107	  qaData.push({
   108	    question: 'How should I handle students who finish early?',
   109	    teacherName: 'Test Teacher',
   110	    teacherEmail: 'test@example.com',
   111	    lessonId: 'test-lesson',
   112	    timestamp: admin.firestore.Timestamp.fromDate(threeDaysAgo),
   113	    answer: '', // Empty answer = unanswered
   114	    notes: 'TEST DATA - Added by alert testing script'
   115	  });
   116	
   117	  await curriculumRef.set({ qaData }, { merge: true });
   118	  console.log(`✅ Added unanswered question (72h old)`);
   119	  console.log('Expected alert: "Teacher question: How should I handle students..." (priority: warning)');
   120	  return 'curriculum/lessonData';
   121	}
   122	
   123	async function cleanup() {
   124	  console.log('🧹 Cleaning up test data...');
   125	
   126	  // Find and delete test documents
   127	  const collections = [
   128	    { name: 'clayHub_members', query: ['notes', '==', 'TEST DATA - Added by alert testing script'] },
   129	    { name: 'privateEvents', query: ['notes', '==', 'TEST DATA - Added by alert testing script'] },
   130	    { name: 'meetings', query: ['notes', '==', 'TEST DATA - Added by alert testing script'] }
   131	  ];
   132	
   133	  for (const col of collections) {
   134	    const snapshot = await db.collection(col.name).where(...col.query).get();
   135	    console.log(`  Deleting ${snapshot.size} documents from ${col.name}...`);
   136	
   137	    const batch = db.batch();
   138	    snapshot.docs.forEach(doc => batch.delete(doc.ref));
   139	    await batch.commit();
   140	  }
   141	
   142	  // Clean up Classbook Q&A
   143	  const curriculumRef = db.collection('curriculum').doc('lessonData');
   144	  const doc = await curriculumRef.get();
   145	
   146	  if (doc.exists && doc.data().qaData) {
   147	    const qaData = doc.data().qaData.filter(qa =>
   148	      qa.notes !== 'TEST DATA - Added by alert testing script'
   149	    );
   150	    await curriculumRef.update({ qaData });
   151	    console.log(`  Cleaned Classbook Q&A data`);
   152	  }
   153	
   154	  console.log('✅ Cleanup complete!');
   155	}
   156	
   157	// Main
   158	const alertType = process.argv[2];
   159	
   160	(async () => {
   161	  try {
   162	    switch(alertType) {
   163	      case 'clay-waitlist':
   164	        await addClayWaitlist();
   165	        break;
   200	            {
   201	              text: 'Follow up with test customer about event details',
   202	              assignedTo: 'Test User',
   203	              completed: false,
   204	              createdAt: fiveDaysAgo.toISOString()
   205	            }
   206	          ],
   207	          notes: 'TEST DATA - Added by alert testing script'
   208	        };
   209	
   210	        const docRef = await db.collection('meetings').add(testMeeting);
   211	        showStatus('recap-status', `✅ Added meeting with action item: ${docRef.id}`);
   212	        console.log('Recap meeting added:', docRef.id);
   213	      } catch (error) {
   214	        showStatus('recap-status', `❌ Error: ${error.message}`, true);
   215	        console.error('Error adding recap meeting:', error);
   216	      }
   217	    }
   218	
   219	    // 4. Classbook - Unanswered Question
   220	    async function addClassbookQuestion() {
   221	      try {
   222	        // Question from 3 days ago (72 hours)
   223	        const threeDaysAgo = new Date();
   224	        threeDaysAgo.setDate(threeDaysAgo.getDate() - 3);
   225	
   226	        // Get current curriculum data
   227	        const curriculumRef = db.collection('curriculum').doc('lessonData');
   228	        const doc = await curriculumRef.get();
   229	
   230	        let qaData = [];
   231	        if (doc.exists && doc.data().qaData) {
   232	          qaData = doc.data().qaData;
   233	        }
   234	
   235	        // Add unanswered question
   236	        qaData.push({
   237	          question: 'How should I handle students who finish early?',
   238	          teacherName: 'Test Teacher',
   239	          teacherEmail: 'test@example.com',
   240	          lessonId: 'test-lesson',
   241	          timestamp: firebase.firestore.Timestamp.fromDate(threeDaysAgo),
   242	          answer: '', // Empty answer = unanswered
   243	          notes: 'TEST DATA - Added by alert testing script'
   244	        });
   245	
   246	        await curriculumRef.set({ qaData }, { merge: true });
   247	        showStatus('classbook-status', `✅ Added unanswered question (72h old)`);
   248	        console.log('Classbook question added');
   249	      } catch (error) {
   250	        showStatus('classbook-status', `❌ Error: ${error.message}`, true);
   251	        console.error('Error adding classbook question:', error);
   252	      }
   253	    }
   254	
   255	    // Cleanup All Test Data
   256	    async function cleanupTestData() {
   257	      try {
   258	        let deletedCount = 0;
   259	
   260	        // Clean up collections with batch delete
   261	        const collections = ['clayHub_members', 'privateEvents', 'meetings'];
   262	
   263	        for (const collectionName of collections) {
   264	          const snapshot = await db.collection(collectionName)
   265	            .where('notes', '==', 'TEST DATA - Added by alert testing script')
   266	            .get();
   267	
   268	          const batch = db.batch();
   269	          snapshot.docs.forEach(doc => {
   270	            batch.delete(doc.ref);
   271	            deletedCount++;
   272	          });
   273	
   274	          await batch.commit();
   275	        }
   276	
   277	        // Clean up Classbook Q&A
   278	        const curriculumRef = db.collection('curriculum').doc('lessonData');
   279	        const doc = await curriculumRef.get();
   280	
   281	        if (doc.exists && doc.data().qaData) {
   282	          const originalLength = doc.data().qaData.length;
   283	          const qaData = doc.data().qaData.filter(qa =>
   284	            qa.notes !== 'TEST DATA - Added by alert testing script'
   285	          );
   286	
   287	          if (qaData.length < originalLength) {
   288	            await curriculumRef.update({ qaData });
   289	            deletedCount += (originalLength - qaData.length);
   290	          }
   291	        }
   292	
   293	        showStatus('cleanup-status', `✅ Cleanup complete! Removed ${deletedCount} test items.`);
   294	        console.log('Cleanup complete:', deletedCount, 'items removed');
   295	      } catch (error) {
   296	        showStatus('cleanup-status', `❌ Error: ${error.message}`, true);
   297	        console.error('Error during cleanup:', error);
   298	      }
   299	    }
   300	
    90	    ],
    91	    notes: 'TEST DATA - Alert testing'
    92	  };
    93	
    94	  const docRef = await db.collection('meetings').add(testMeeting);
    95	  console.log('✅ Added meeting with action item:', docRef.id);
    96	  console.log('Expected alert: "Action item: Follow up with test customer..." (info)');
    97	})();
    98	```
    99	
   100	**Expected Alert:**
   101	- 📝 "Action item: Follow up with test customer..." (blue info icon)
   102	- Subtitle: "From Staff Meeting - 5 days ago"
   103	- Action: "View Meeting"
   104	
   105	---
   106	
   107	### ✅ Test 4: Classbook - Unanswered Question
   108	
   109	```javascript
   110	// Add unanswered question (3 days old = 72h = warning)
   111	(async () => {
   112	  const threeDaysAgo = new Date();
   113	  threeDaysAgo.setDate(threeDaysAgo.getDate() - 3);
   114	
   115	  const curriculumRef = db.collection('curriculum').doc('lessonData');
   116	  const doc = await curriculumRef.get();
   117	
   118	  let qaData = [];
   119	  if (doc.exists && doc.data().qaData) {
   120	    qaData = doc.data().qaData;
   121	  }
   122	
   123	  qaData.push({
   124	    question: 'How should I handle students who finish early?',
   125	    teacherName: 'Test Teacher',
   126	    teacherEmail: 'test@example.com',
   127	    lessonId: 'test-lesson',
   128	    timestamp: firebase.firestore.Timestamp.fromDate(threeDaysAgo),
   129	    answer: '', // Empty = unanswered
   130	    notes: 'TEST DATA - Alert testing'
   131	  });
   132	
   133	  await curriculumRef.set({ qaData }, { merge: true });
   134	  console.log('✅ Added unanswered question (72h old)');
   135	  console.log('Expected alert: "Teacher question: How should I handle students..." (warning)');
   136	})();
   137	```
   138	
   139	**Expected Alert:**
   140	- 📚 "Teacher question: How should I handle students..." (yellow warning - 72h)
   141	- Subtitle: "Test Teacher - 72h ago"
   142	- Action: "View Classbook"
   143	
   144	---
   145	
   146	### 🧹 Cleanup (Run When Done Testing)
   147	
   148	```javascript
   149	// Remove all test data
   150	(async () => {
   151	  console.log('🧹 Cleaning up test data...');
   152	  let deletedCount = 0;
   153	
   154	  // Clean up collections
   155	  const collections = ['clayHub_members', 'privateEvents', 'meetings'];
   156	
   157	  for (const collectionName of collections) {
   158	    const snapshot = await db.collection(collectionName)
   159	      .where('notes', '==', 'TEST DATA - Alert testing')
   160	      .get();
   161	
   162	    const batch = db.batch();
   163	    snapshot.docs.forEach(doc => {
   164	      batch.delete(doc.ref);
   165	      deletedCount++;
   166	    });
   167	
   168	    await batch.commit();
   169	  }
   170	
   171	  // Clean up Classbook Q&A
   172	  const curriculumRef = db.collection('curriculum').doc('lessonData');
   173	  const doc = await curriculumRef.get();
   174	
   175	  if (doc.exists && doc.data().qaData) {
   176	    const originalLength = doc.data().qaData.length;
   177	    const qaData = doc.data().qaData.filter(qa =>
   178	      qa.notes !== 'TEST DATA - Alert testing'
   179	    );
   180	
   181	    if (qaData.length < originalLength) {
   182	      await curriculumRef.update({ qaData });
   183	      deletedCount += (originalLength - qaData.length);
   184	    }
   185	  }
   186	
   187	  console.log(`✅ Cleanup complete! Removed ${deletedCount} test items.`);
   188	  console.log('Alerts should disappear from Mission Control now.');
   189	})();
   190	```
   115	Christie liked these views from the old app - incorporate them (but better):
   116	
   117	1. **Schedule Grid** - Visual grid of studios × time slots × weeks
   118	   - Pull from `summerCamps_schedule` collection (not TSV)
   119	   - Show camp topics, teachers, enrollment
   120	   - Color-coded by teacher/track
   121	   - Click cells to view camp details
   122	
   123	2. **Prep Status Dashboard** - Overall prep progress tracking
   124	   - Pull from `summerCamps_weeklyPrep` + `summerCamps_materialsHub`
   125	   - Overview cards (% complete, items flagged, help queue alerts)
   126	   - By teacher progress bars
   127	   - All camps list with status filters (Not Started / In Prep / Complete)
   128	   - Click camps to drill into weekly prep details
   129	
   130	3. **Lesson Plans Dashboard** - Teacher lesson plan completion
   131	   - Pull from `curriculum/lessonData`
   132	   - Overview cards (% complete, needs help, overdue)
   133	   - By teacher progress bars
   134	   - All camps list with filters (Not Started / In Progress / Needs Help / Done)
   135	   - Click camps to view lesson plan details
   136	
   137	These will be **actual functional dashboards** pulling live data from Firestore (not static read-only TSV views like the old app).
   138	
   139	## Running Locally
   140	
   141	```bash
   142	cd /Users/christiehubley/summer-camp-app
   143	python3 -m http.server 8088
   144	# Open http://localhost:8088
   145	```

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '4520,4660p;4870,5025p'
nl -ba js/app.js | sed -n '3500,3710p'
rg -n \"readServerSemesterLessonMap|backupLessonData|restoreFromBackup|deleteLessonData\\(|saveLessonData\\(|deleteLessonKey\\(|saveSingleLesson\\(|saveMultipleLessonFields\\(\" js --glob '*.js'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
  4520	      </label>` : ''}
  4521	      ${!isPublished && !isActive ? '<span class="ca-sem-unpublished-badge">Draft</span>' : ''}
  4522	      ${!isActive ? `<button class="btn-text ca-delete-sem-btn" onclick="deleteSemester('${escAttr(currentKey)}')" title="Delete this semester">&#128465; Delete</button>` : ''}
  4523	    `;
  4524	  }
  4525	}
  4526	
  4527	async function deleteSemester(key) {
  4528	  const sem = currentConfig?.semesters?.[key];
  4529	  if (!sem) return;
  4530	  if (key === currentConfig.activeSemester) {
  4531	    alert('Cannot delete the active semester.');
  4532	    return;
  4533	  }
  4534	  // Removing a CAMP season from the Classbook removes only this app's entry
  4535	  // for it. Its camps, schedule, plans and photos belong to the Summer Camp
  4536	  // App and stay exactly where they are — adding the season back from the
  4537	  // registry restores the whole view (Phase 1, 1.7). This supersedes the
  4538	  // companion plan's summer-delete design, which predates seasons.
  4539	  // An SDOC year: refused while any event exists (a forced-server count);
  4540	  // otherwise only its appData entry goes — it has nothing in
  4541	  // curriculum/lessonData, and no collection is ever cleared from here.
  4542	  if (isDayOffYear(key)) {
  4543	    let events;
  4544	    try { events = await countDayOffEvents(key); }
  4545	    catch (err) { alert(`Could not check "${sem.name}" for events: ${err.message}\n\nNothing was changed.`); return; }
  4546	    if (events > 0) { alert(`"${sem.name}" still has ${events} event${events === 1 ? '' : 's'}. Remove its events first.`); return; }
  4547	  }
  4548	  const isCamp = isCampSeason(key);
  4549	  const isDayOff = isDayOffYear(key);
  4550	  const firstConfirm = isDayOff
  4551	    ? `Delete the school year "${sem.name}"? It has no events, so only the year itself is removed.`
  4552	    : isCamp
  4553	    ? `Remove "${sem.name}" from the Classbook?\n\nThis only removes it here. Every camp, schedule, lesson plan and photo stays in the Summer Camp App, and you can add the season back at any time from + New Semester.`
  4554	    : `Delete semester "${sem.name}"? This will remove all its lesson data, cut bank, and change history. This cannot be undone.`;
  4555	  if (!confirm(firstConfirm)) return;
  4556	  if (!isCamp && !isDayOff && !confirm(`Are you sure? Type OK in your head and click OK to confirm.`)) return;
  4557	
  4558	  // Remove the semester's own entry and nothing else (Phase 1, 1.2). Revert
  4559	  // this tab if the write is refused, or the config would be missing a
  4560	  // semester the server still has — with no alert and no re-render to show it
  4561	  // (Phase 1 review).
  4562	  const removed = currentConfig.semesters[key];
  4563	  delete currentConfig.semesters[key];
  4564	  try {
  4565	    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
  4566	  } catch (err) {
  4567	    currentConfig.semesters[key] = removed;
  4568	    console.error('❌ Could not remove the semester:', err);
  4569	    alert(`Could not remove "${sem.name}": ${err.message}\n\nNothing was changed.`);
  4570	    renderSemesterSelector();
  4571	    return;
  4572	  }
  4573	
  4574	  // Drop this season's in-memory map either way…
  4575	  if (currentLessonData?.[key]) {
  4576	    delete currentLessonData[key];
  4577	  }
  4578	  // …but only a WEEKLY semester has lessons of its own inside
  4579	  // curriculum/lessonData to delete. A camp season's lessons live in the
  4580	  // shared summerCamps_* collections and are never touched from here.
  4581	  if (isDayOff) {
  4582	    delete currentDayOffEvents[key]; delete currentDayOffCamps[key]; delete currentDayOffPlans[key]; delete currentDayOffSignoffs[key];
  4583	  } else if (!isCamp) {
  4584	    try {
  4585	      await deleteLessonData(key);
  4586	    } catch (e) { console.warn('Could not delete lesson data for', key, e); }
  4587	  }
  4588	
  4589	  // Switch to active semester
  4590	  caCurrentSemester = currentConfig.activeSemester;
  4591	  renderSemesterSelector();
  4592	  renderAdminGrid();
  4593	  renderHelpQueue();
  4594	  renderCutBank();
  4595	  renderIdeaBank();
  4596	  renderChangeHistory();
  4597	}
  4598	
  4599	function switchAdminSemester(key) {
  4600	  // Delegates to global semester — CA always stays in sync with the header selector
  4601	  setGlobalSemester(key);
  4602	}
  4603	
  4604	async function toggleSemesterPublish(key, published) {
  4605	  if (!currentConfig?.semesters?.[key]) return;
  4606	  if (!isPublishableType(key)) { alert('This semester type can\'t be published.'); return; }
  4607	  // SDOC (Phase 2B): publishing shows the year to every teacher on a camp —
  4608	  // say so first if some camps have nobody to see them.
  4609	  if (published && isDayOffYear(key)) {
  4610	    // The camp list below must be real to warn from — never publish on a failed load.
  4611	    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
  4612	    const bare = (currentDayOffCamps[key] || []).filter(c => !(c.teachers || []).length).length;
  4613	    if (bare && !confirm(`${bare} camp${bare === 1 ? ' has' : 's have'} no teacher yet — publish anyway?`)) { renderSemesterSelector(); return; }
  4614	  }
  4615	  const hadPublished = 'published' in currentConfig.semesters[key];
  4616	  const previous = currentConfig.semesters[key].published;
  4617	  currentConfig.semesters[key].published = published;
  4618	  try {
  4619	    await updateAppData({ [`semesters.${key}.published`]: published });
  4620	  } catch (err) {
  4621	    // Restore exactly what was there — including "the field was absent".
  4622	    if (currentConfig.semesters[key]) {
  4623	      if (hadPublished) currentConfig.semesters[key].published = previous;
  4624	      else delete currentConfig.semesters[key].published;
  4625	    }
  4626	    console.error('❌ Could not change the publish state:', err);
  4627	    alert(`Could not ${published ? 'publish' : 'unpublish'} that semester: ${err.message}\n\nNothing was changed.`);
  4628	  }
  4629	  renderSemesterSelector();
  4630	}
  4631	
  4632	// Which types may be published to teachers. SDOC years joined in Phase 2B,
  4633	// when teachers got their day-off plans to build.
  4634	const PUBLISHABLE_SEMESTER_TYPES = new Set([SEMESTER_TYPES.weekly, SEMESTER_TYPES.camp, SEMESTER_TYPES.dayOff]);
  4635	function isPublishableType(semKey) { return PUBLISHABLE_SEMESTER_TYPES.has(semesterTypeOf(semKey)); }
  4636	
  4637	function openNewSemesterModal() {
  4638	  document.getElementById('ca-new-semester-modal')?.classList.add('open');
  4639	  // Reset to the default type each time, then load the seasons on offer.
  4640	  const weeklyRadio = document.querySelector('input[name="new-sem-type"][value="weekly"]');
  4641	  if (weeklyRadio) weeklyRadio.checked = true;
  4642	  onNewSemesterTypeChange();
  4643	  populateNewSemesterSeasons();
  4644	  document.getElementById('new-sem-name')?.focus();
  4645	}
  4646	
  4647	function selectedNewSemesterType() {
  4648	  return document.querySelector('input[name="new-sem-type"]:checked')?.value || SEMESTER_TYPES.weekly;
  4649	}
  4650	
  4651	function onNewSemesterTypeChange() {
  4652	  const type = selectedNewSemesterType();
  4653	  const weekly = document.getElementById('new-sem-weekly-fields');
  4654	  const camp = document.getElementById('new-sem-camp-fields');
  4655	  const dayOff = document.getElementById('new-sem-dayoff-fields');
  4656	  if (weekly) weekly.hidden = type !== SEMESTER_TYPES.weekly;
  4657	  if (camp) camp.hidden = type !== SEMESTER_TYPES.camp;
  4658	  if (dayOff) {
  4659	    dayOff.hidden = type !== SEMESTER_TYPES.dayOff;
  4660	    if (type === SEMESTER_TYPES.dayOff) resetDayOffYearFields();
  4870	  const numWeeks = parseInt(document.getElementById('new-sem-weeks')?.value) || 16;
  4871	  const breaksRaw = document.getElementById('new-sem-breaks')?.value.trim() || '';
  4872	  const breakWeeks = breaksRaw ? breaksRaw.split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n)) : [];
  4873	  const closuresRaw = document.getElementById('new-sem-closures')?.value.trim() || '';
  4874	  const closureDates = parseClosureDates(closuresRaw);
  4875	  const copyFromKey = document.getElementById('new-sem-copy-from')?.value || '';
  4876	
  4877	  const newSem = {
  4878	    name,
  4879	    semesterType: SEMESTER_TYPES.weekly,   // stored explicitly from now on (Phase 1, 1.1)
  4880	    startDate,
  4881	    numWeeks,
  4882	    breakWeeks,
  4883	    closureDates,
  4884	    published: false,
  4885	    classRoster: {}
  4886	  };
  4887	
  4888	  // Invoked from a bare HTML onclick — nothing above this frame catches, so a
  4889	  // failure anywhere below must be handled here (backtracking audit, Phase 11).
  4890	  // Two Firestore writes happen in sequence (lesson slots, then config); if the
  4891	  // second fails after the first landed, the slots are an orphan on the server
  4892	  // for a semester the admin was told didn't get created, and a retry with the
  4893	  // same name would silently reuse them. Track whether the first write landed
  4894	  // so the catch can compensate.
  4895	  let lessonDataCommitted = false;
  4896	  creatingSemester = true;
  4897	  try {
  4898	    // Copy roster from existing semester if selected
  4899	    if (copyFromKey && currentConfig.semesters[copyFromKey]) {
  4900	      // Pre-check (implementation review, Sep 2026): this branch is the only
  4901	      // path that writes lesson data, and the compensating delete in the catch
  4902	      // below removes the WHOLE `key` map — only safe if nothing lived there
  4903	      // before this call. It can: deleteSemester() drops a key from local
  4904	      // state even when its server-side deleteLessonData() fails (warn-only),
  4905	      // and config has no live listener, so another admin's same-named
  4906	      // semester isn't visible here either. Forced server read — the local
  4907	      // cache is exactly what can't be trusted for this key. Refuse unless
  4908	      // every existing lesson is template-empty (a prior createNewSemester()'s
  4909	      // own leftovers are safe to build on and safe to delete; anything else
  4910	      // would be merged over silently by the slot write, then deleted on
  4911	      // failure). The no-copy path is deliberately NOT gated: it writes no
  4912	      // lesson data, and re-creating a deleted semester there adopts its
  4913	      // surviving lesson data — the remedy this alert points at.
  4914	      const existingLessonMap = await readServerSemesterLessonMap(key);
  4915	      if (existingLessonMap && Object.values(existingLessonMap).some(l => !isTemplateEmptyLesson(l))) {
  4916	        alert(`Lesson content already exists in Firestore under the key "${key}".\n\nIf it was left over from a deleted semester, create this semester again without "Copy from" to adopt that data.\n\nIf another admin may have just created it, reload this page first.\n\nOtherwise choose a different name.`);
  4917	        return;
  4918	      }
  4919	
  4920	      const source = currentConfig.semesters[copyFromKey];
  4921	      newSem.classRoster = JSON.parse(JSON.stringify(source.classRoster || {}));
  4922	      // Without this, classRoster's teacher fields are copied but the dropdown
  4923	      // that lets Settings display/edit them has no options — the roster looks
  4924	      // wiped even though the underlying data isn't, and saving Settings in
  4925	      // that state silently writes blank teachers over the real ones.
  4926	      newSem.teacherNames = JSON.parse(JSON.stringify(source.teacherNames || []));
  4927	
  4928	      // Create empty lesson slots from source semester's teacher/class combos
  4929	      const sourceLessons = currentLessonData?.[copyFromKey] || {};
  4930	      const combos = new Set();
  4931	      for (const lesson of Object.values(sourceLessons)) {
  4932	        combos.add(`${lesson.teacher}|||${lesson.className}`);
  4933	      }
  4934	
  4935	      const emptyLessons = {};
  4936	      for (const combo of combos) {
  4937	        const [teacher, className] = combo.split('|||');
  4938	        for (let w = 1; w <= numWeeks; w++) {
  4939	          const lessonKey = makeLessonKey(teacher, className, w);
  4940	          emptyLessons[lessonKey] = {
  4941	            teacher,
  4942	            className,
  4943	            weekNum: w,
  4944	            weekDate: '',
  4945	            classSize: 0,
  4946	            projectTitle: '',
  4947	            shortDetails: '',
  4948	            inspoLink: '',
  4949	            introPitch: '',
  4950	            processStep1: '',
  4951	            processStep2: '',
  4952	            processStep3: '',
  4953	            processStep4: '',
  4954	            closure: '',
  4955	            materials: '',
  4956	            dayOfMaterials: '',
  4957	            materialsList: [],
  4958	            status: '',
  4959	            publishToPrep: ''
  4960	          };
  4961	        }
  4962	      }
  4963	
  4964	      if (Object.keys(emptyLessons).length > 0) {
  4965	        await saveLessonData(key, emptyLessons);
  4966	        if (!currentLessonData) currentLessonData = {};
  4967	        currentLessonData[key] = emptyLessons;
  4968	        lessonDataCommitted = true;
  4969	      }
  4970	    }
  4971	
  4972	    // Confirm on the SERVER that the key is free — the check at the top of this
  4973	    // function only saw this tab's copy of the config (Phase 1, 1.2). The
  4974	    // remaining read-to-update window is accepted: one admin, same class as the
  4975	    // existing residual on the Q&A path.
  4976	    const serverConfig = await readAppDataFromServer();
  4977	    if (serverConfig?.semesters?.[key]) {
  4978	      throw new Error(`A semester with the key "${key}" already exists (created in another tab or by another admin). Choose a different name.`);
  4979	    }
  4980	    currentConfig.semesters[key] = newSem;
  4981	    await updateAppData({ [`semesters.${key}`]: newSem });
  4982	  } catch (err) {
  4983	    console.error('❌ Could not create new semester:', err);
  4984	    // Revert both local mutations so a retry isn't blocked by a phantom
  4985	    // "already exists" and the grid doesn't render a semester that never saved.
  4986	    delete currentConfig.semesters[key];
  4987	    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
  4988	    // R4-11: the empty lesson slots may already be persisted even though the
  4989	    // config never was — clean up the orphaned server-side write, not just the
  4990	    // local copy. Safe: this data is template-empty by construction (never had
  4991	    // real content), so deleting it loses nothing.
  4992	    if (lessonDataCommitted) {
  4993	      try {
  4994	        await deleteLessonData(key);
  4995	      } catch (cleanupErr) {
  4996	        console.error('⚠️ Could not clean up orphaned lesson data after failed semester creation:', cleanupErr);
  4997	      }
  4998	    }
  4999	    alert('Could not create the new semester. Please try again.');
  5000	    return;
  5001	  } finally {
  5002	    creatingSemester = false;
  5003	  }
  5004	
  5005	  closeNewSemesterModal();
  5006	  caCurrentSemester = key;
  5007	  renderSemesterSelector();
  5008	  renderAdminGrid();
  5009	  renderHelpQueue();
  5010	  renderCutBank();
  5011	  renderIdeaBank();
  5012	  renderChangeHistory();
  5013	}
  5014	
  5015	async function initCurriculumAdmin() {
  5016	  if (caInitialized) return;
  5017	  caInitialized = true;
  5018	
  5019	  if (!currentLessonData) await loadLessonData();
  5020	  if (!currentChangeLog) await loadChangeLog();
  5021	  if (!currentCutProjects) await loadCutProjects();
  5022	  if (!currentFutureProjects) await loadFutureProjects();
  5023	
  5024	  renderSemesterSelector();
  5025	  renderAdminGrid();
  3500	    // (Data Safety Plan Stage 3).
  3501	    const fieldsToClear = CONTENT_FIELDS.filter(f =>
  3502	      (teOriginalData?.[f] || '').trim() !== '' && !(formData[f] || '').trim()
  3503	    );
  3504	
  3505	    // Save using granular single-lesson write. This already includes
  3506	    // photoUrl/photoPath via updatedLesson (they're not in CONTENT_FIELDS, so
  3507	    // saveSingleLesson's per-field dotted-path write always writes them
  3508	    // through, even empty) — backtracking audit, Phase 8 (R3-8): the separate
  3509	    // photo-fields write that used to follow this call was vestigial, removed
  3510	    // entirely.
  3511	    // Backtracking audit Phase 10: the Q&A fields are written only by the
  3512	    // atomic arrayUnion() senders — this form never edits them, and writing
  3513	    // the cached array back whole would delete any message another client
  3514	    // appended since this cache copy was taken. They stay on updatedLesson
  3515	    // (the cache copy below) and are left out of the WRITE only.
  3516	    const writePayload = { ...updatedLesson };
  3517	    delete writePayload.qaThread;
  3518	    delete writePayload.teacherNotes;
  3519	    delete writePayload.adminResponse;
  3520	    await saveSingleLesson(semKey, lessonKey, writePayload, fieldsToClear);
  3521	    // saveSingleLesson() stamps lastEditedBy/At onto the object it is given.
  3522	    updatedLesson.lastEditedBy = writePayload.lastEditedBy;
  3523	    updatedLesson.lastEditedAt = writePayload.lastEditedAt;
  3524	
  3525	    // Backtracking audit, Phase 8 (R4-2): only delete the OLD photo once
  3526	    // Firestore has confirmed the new reference — and only if it's actually
  3527	    // different from the new one.
  3528	    if (oldPhotoPath && oldPhotoPath !== (updatedLesson.photoPath || null)) {
  3529	      try {
  3530	        await deleteLessonPhoto(oldPhotoPath);
  3531	      } catch (cleanupErr) {
  3532	        console.error('⚠️ Could not clean up old photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
  3533	      }
  3534	    }
  3535	
  3536	    // Backtracking audit, Phase 5: the photo change is persisted — clear the
  3537	    // pending selection so this modal's autosave doesn't re-upload the same
  3538	    // file to another unique path on the next pause in typing. Success path
  3539	    // only, so a failed save keeps the selection for the retry.
  3540	    if (hasNewPhoto && photoInput?.files?.[0] === uploadedFile) photoInput.value = '';
  3541	    if (pendingRemove && photoInput) photoInput.dataset.pendingRemove = '';
  3542	
  3543	    // Update local data immediately (don't wait for Firestore listener)
  3544	    if (currentLessonData[semKey]) {
  3545	      currentLessonData[semKey][lessonKey] = updatedLesson;
  3546	    }
  3547	
  3548	    // Backtracking audit, Phase 8 (R1-17/R2-11): log only after persistence is
  3549	    // confirmed, with its own non-blocking catch — a log-only failure here
  3550	    // must not be reported to the teacher as "Save failed" when the save
  3551	    // itself already succeeded. Before/after char counts per field so a
  3552	    // large-content wipe is flagged automatically (Data Safety Plan Stage 4C).
  3553	    // 'photo' isn't a text field — teOriginalData/formData have no counterpart
  3554	    // for it, so it carries no char counts and is never flagged as a wipe.
  3555	    try {
  3556	      const changedFieldEntries = changedFields.map(field => {
  3557	        if (field === 'photo') return { field, before: null, after: null, potentialWipe: false };
  3558	        const before = (teOriginalData[field] || '').length;
  3559	        const after = normalizeTeFormValue(field, formData).length;
  3560	        return { field, before, after, potentialWipe: after === 0 && before > 50 };
  3561	      });
  3562	      await logTeacherEdit(semKey, lessonKey, originalLesson, changedFieldEntries);
  3563	    } catch (logErr) {
  3564	      console.error('⚠️ Lesson saved, but Change History logging failed:', logErr);
  3565	    }
  3566	
  3567	    // Show success — stay open, reset dirty state
  3568	    if (saveBtn) { saveBtn.textContent = 'Saved!'; }
  3569	    if (autoSaveStatus) {
  3570	      autoSaveStatus.textContent = fieldsToClear.length > 0
  3571	        ? `✓ Saved (${fieldsToClear.join(', ')} cleared)`
  3572	        : '✓ Saved';
  3573	    }
  3574	
  3575	    // Reset dirty baseline so closing won't prompt "unsaved changes"
  3576	    const snapshot = getTeEditFormData();
  3577	    teOriginalData = {
  3578	      projectTitle: snapshot.projectTitle,
  3579	      shortDetails: snapshot.shortDetails,
  3580	      inspoLink: snapshot.inspoLink,
  3581	      introPitch: snapshot.introPitch,
  3582	      processStep1: snapshot.processStep1,
  3583	      processStep2: snapshot.processStep2,
  3584	      processStep3: snapshot.processStep3,
  3585	      processStep4: snapshot.processStep4,
  3586	      closure: snapshot.closure,
  3587	      materials: snapshot.materials,
  3588	      dayOfMaterials: snapshot.dayOfMaterials,
  3589	      materialsList: JSON.stringify(snapshot.materialsList || []),
  3590	      planComplete: snapshot.planComplete ? 'true' : 'false'
  3591	    };
  3592	
  3593	    setTimeout(() => {
  3594	      if (saveBtn) { saveBtn.textContent = 'Save'; saveBtn.disabled = false; }
  3595	      if (autoSaveStatus) autoSaveStatus.textContent = '';
  3596	    }, 1500);
  3597	  } catch (err) {
  3598	    console.error('Error saving lesson:', err);
  3599	    if (saveBtn) { saveBtn.disabled = false; saveBtn.textContent = 'Save'; }
  3600	    if (autoSaveStatus) { autoSaveStatus.textContent = '⚠️ Save failed'; autoSaveStatus.style.color = 'var(--error)'; }
  3601	  }
  3602	}
  3603	
  3604	// Backtracking audit Phase 10 (R3-3, R4-5): this used to rebuild the whole
  3605	// Q&A thread from the modal's lesson object and hand the ENTIRE lesson to
  3606	// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
  3607	// silently dropped any message (or any other field) another client had
  3608	// landed since this modal opened. Now a single targeted .update() touching
  3609	// only this lesson's own Q&A paths, with arrayUnion() for the thread — the
  3610	// same atomic-append design sendHelpResponse()/sendQaReply() already use —
  3611	// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
  3612	// record. `modalSemKey` is the semester the modal was opened under: the
  3613	// global selector can change while the modal stays open, and a dotted-path
  3614	// update under the wrong semester would create a Q&A-only ghost lesson there.
  3615	async function sendTeacherQaMessage(lessonKey, modalSemKey) {
  3616	  const input = document.getElementById('te-qa-input');
  3617	  if (!input) return;
  3618	  const message = input.value.trim();
  3619	  if (!message) return;
  3620	  // Same load-guard saveSingleLesson() enforced on the old path — after a
  3621	  // failed load the cache is empty, so the legacy-thread migration below
  3622	  // would run blind against whatever is really on the server.
  3623	  if (lessonDataLoadedSuccessfully === false) {
  3624	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
  3625	    return;
  3626	  }
  3627	
  3628	  const semKey = modalSemKey || getTvSemKey();
  3629	  // This modal never hosts a camp season (the Today View routes those to the
  3630	  // summer editor, whose Q&A lives in summerCamps_prepHelpQueue), so a write
  3631	  // under that key into curriculum/lessonData is never right. Routed by TYPE
  3632	  // now (Phase 1, 1.1) — a third type is refused out loud rather than written
  3633	  // into the shared weekly document.
  3634	  let lessonStore;
  3635	  try {
  3636	    lessonStore = lessonStoreFor(semKey);
  3637	  } catch (err) {
  3638	    alert(err.message);
  3639	    return;
  3640	  }
  3641	  if (lessonStore === 'camp') {
  3642	    alert('Summer camp questions are sent from the camp lesson editor.');
  3643	    return;
  3644	  }
  3645	
  3646	  // Confirm the lesson still exists on the server (an admin may have moved or
  3647	  // deleted it since this modal opened). A dotted-path update would otherwise
  3648	  // recreate the old key as a Q&A-only ghost lesson. Same forced read and
  3649	  // accepted check-to-write residual as sendHelpResponse()/sendQaReply().
  3650	  let check;
  3651	  try {
  3652	    check = await adminLessonStillExistsWithRetry(semKey, lessonKey);
  3653	  } catch (err) {
  3654	    console.warn('⚠️ Existence check retry also failed:', err);
  3655	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
  3656	    return;
  3657	  }
  3658	  if (!check.exists) {
  3659	    alert('This lesson was moved or removed elsewhere. Your message was not sent — please close this and check the classbook for its new location.');
  3660	    return;
  3661	  }
  3662	  const existing = check.data;
  3663	
  3664	  const user = getAuthUser();
  3665	  const isAdmin = ['admin', 'manager'].includes(user?.role);
  3666	  const newEntry = {
  3667	    id: Date.now().toString(36) + Math.random().toString(36).substr(2, 5),
  3668	    from: isAdmin ? 'admin' : 'teacher',
  3669	    name: user?.name || 'Unknown',
  3670	    message,
  3671	    timestamp: new Date().toISOString()
  3672	  };
  3673	  // The fresh server copy decides whether a legacy teacherNotes/adminResponse
  3674	  // thread still needs migrating into qaThread on this lesson's first entry.
  3675	  const entriesToAdd = buildQaThreadUnionArgs(existing, newEntry);
  3676	  const editedAt = new Date().toISOString();
  3677	  const editedBy = user?.name || 'Unknown';
  3678	
  3679	  const updates = {
  3680	    [`${semKey}.${lessonKey}.qaThread`]: firebase.firestore.FieldValue.arrayUnion(...entriesToAdd),
  3681	    [`${semKey}.${lessonKey}.lastEditedBy`]: editedBy,
  3682	    [`${semKey}.${lessonKey}.lastEditedAt`]: editedAt,
  3683	  };
  3684	  // Legacy mirror fields, kept for compatibility with older readers.
  3685	  const legacyField = isAdmin ? 'adminResponse' : 'teacherNotes';
  3686	  updates[`${semKey}.${lessonKey}.${legacyField}`] = message;
  3687	
  3688	  try {
  3689	    if (!curriculumDb) initCurriculumFirestore();
  3690	    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
  3691	  } catch (err) {
  3692	    console.error('Error sending Q&A message:', err);
  3693	    alert('Error sending message: ' + err.message);
  3694	    return;
  3695	  }
  3696	
  3697	  // Confirmed — make sure the local cache shows the new message before the
  3698	  // live listener catches up. Usually the listener already HAS: a local
  3699	  // write triggers a latency-compensated snapshot (with the arrayUnion
  3700	  // applied) before the server ack resolves the await above, so the entry
  3701	  // is deduplicated by id rather than appended blindly — a duplicate here
  3702	  // would be persisted by the next autosave, which writes the cached
  3703	  // qaThread back as a whole array.
  3704	  if (currentLessonData?.[semKey]?.[lessonKey]) {
  3705	    const cached = currentLessonData[semKey][lessonKey];
  3706	    const baseThread = cached.qaThread && cached.qaThread.length > 0 ? cached.qaThread : getQaThread(cached);
  3707	    const alreadyThere = baseThread.some(m => m.id === newEntry.id);
  3708	    currentLessonData[semKey][lessonKey] = {
  3709	      ...cached,
  3710	      qaThread: alreadyThere ? baseThread : [...baseThread, newEntry],
js/app.js:1807:    const result = await saveSingleLesson(yearKey, lessonKey, { planComplete: requested }, [], { dayOffAuth: dayOffAuthFor(yearKey) });
js/app.js:2359:        await saveSingleLesson(semKey, lessonKey, payload);
js/app.js:2360:        // saveSingleLesson() stamps the payload it writes; keep the in-memory
js/app.js:2843:        await saveSingleLesson(semKey, lessonKey, { planComplete: cb.checked });
js/app.js:3520:    await saveSingleLesson(semKey, lessonKey, writePayload, fieldsToClear);
js/app.js:3521:    // saveSingleLesson() stamps lastEditedBy/At onto the object it is given.
js/app.js:3606:// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
js/app.js:3611:// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
js/app.js:3620:  // Same load-guard saveSingleLesson() enforced on the old path — after a
js/app.js:4585:      await deleteLessonData(key);
js/app.js:4904:      // state even when its server-side deleteLessonData() fails (warn-only),
js/app.js:4914:      const existingLessonMap = await readServerSemesterLessonMap(key);
js/app.js:4965:        await saveLessonData(key, emptyLessons);
js/app.js:4994:        await deleteLessonData(key);
js/app.js:5636:  // the doc. Same routing signal as saveSingleLesson() /
js/app.js:5753:    await saveSingleLesson(semKey, key, firestorePayload, fieldsToClear);
js/app.js:5786:    lastEditedBy: firestorePayload.lastEditedBy,   // stamped by saveSingleLesson()
js/app.js:5943:      await saveMultipleLessonFields(
js/app.js:6016:          await saveMultipleLessonFields(semKey, [
js/app.js:6037:          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
js/app.js:6145:// cached semester via saveLessonData() — any lesson whose local copy was stale
js/app.js:6149:// had actually been written. Now: one targeted saveSingleLesson() per target
js/app.js:6198:      await saveSingleLesson(semKey, targetKey, payload, targetFieldsToClear);
js/app.js:6320:    await deleteLessonKey(semKey, key);
js/app.js:6414:// saveLessonData() semester overwrite), removal via FieldValue.arrayRemove()
js/app.js:6476:    await saveSingleLesson(destSemKey, key, lessons[key], NON_CONTENT_FIELDS_TO_CLEAR);
js/app.js:6886:// saveLessonData() write passed the WHOLE {projects:[...]} wrapper into
js/app.js:6891:// targeted saveSingleLesson() write (unrelated lessons in the same semester
js/app.js:6949:    await saveSingleLesson(semKey, key, newLesson, [...fieldsToClear, ...NON_CONTENT_FIELDS_TO_CLEAR]);
js/app.js:7125:// resave the ENTIRE cached semester via saveLessonData() — a Firestore
js/app.js:11428:    await saveLessonData(semKey, lessons);
js/app.js:11930:      // summer branch of saveSingleLesson() is a set-merge, so everything
js/app.js:11963:      const result = await saveSingleLesson(semKey, lessonKey, payload, fieldsToClear, sdoc ? { dayOffAuth: dayOffAuthFor(semKey) } : undefined);
js/app.js:11964:      // saveSingleLesson() stamps lastEditedBy/At onto the object it is given;
js/firebase-data.js:794:// Whole-semester bulk writer (restoreFromBackup, createNewSemester,
js/firebase-data.js:796:// saveSingleLesson(): after a failed load, `lessons` is built from an empty or
js/firebase-data.js:797:// partial currentLessonData (or, for restoreFromBackup, would land over a
js/firebase-data.js:802:async function saveLessonData(semesterKey, lessons) {
js/firebase-data.js:827:async function deleteLessonKey(semesterKey, lessonKey) {
js/firebase-data.js:961:async function deleteLessonData(semesterKey) {
js/firebase-data.js:973:async function readServerSemesterLessonMap(semesterKey) {
js/firebase-data.js:979:async function backupLessonData(semesterKey) {
js/firebase-data.js:993:async function restoreFromBackup(semesterKey) {
js/firebase-data.js:1000:  await saveLessonData(semesterKey, lessons);
js/firebase-data.js:1364:async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
js/firebase-data.js:1449:// saveSingleLesson()'s non-summer branch above so it can be reused by
js/firebase-data.js:1450:// saveMultipleLessonFields() below without duplicating the stripping/clearing
js/firebase-data.js:1456:  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above saveSingleLesson().
js/firebase-data.js:1475:async function saveMultipleLessonFields(semesterKey, writes = [], deletes = []) {
js/firebase-data.js:1485:    throw new Error('saveMultipleLessonFields() does not support camp seasons — use saveSingleLesson() per lesson instead.');
js/firebase-data.js:2638:// saveSingleLesson()'s SDOC branch. Returns { status, doc, by, own }:

codex
# Verdict: NOT EXECUTION-READY

Revision 2 fixes much of round 1, but four remaining defects can lose or hide edits. The rules fence also has two bypasses. I reviewed main `2ef2e62`, made no edits, and ran no tests.

## Blocking findings

1. Phase C still has the verification race that revision 2 claims is gone.

The fence freezes only `lessonData['spring-2026']`; it does not freeze the newly created target. As soon as the transaction creates `lessons_spring-2026`, a Phase-B listener can enable editing and the existing writers can update it ([firebase-data.js:1364](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1364), [app.js:3615](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3615), [app.js:7135](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7135)).

Concrete failure:

1. Phase C transaction copies hash `H`.
2. A teacher’s already-open Phase-B tab receives the target snapshot and saves an edit.
3. Forced verification reads hash `H2`.
4. The plan calls that a mismatch and recommends deleting the target ([plan:142](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:142), [plan:179](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:179)).
5. Deleting it discards the legitimate edit.

The source being frozen does not make target deep-equality stable. Keep Spring unwritable through verification, or treat a changed target as potentially legitimate and never prescribe deletion without reconciling it. Rollback also needs a write pause because an update racing a whole-document delete can acknowledge and then disappear.

2. Phase D does not verify the document it is relying on.

Phase D checks only the frozen source against the recorded hash, then deletes the source ([plan:153](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:153)). It does not require a forced-server read proving that `lessons_spring-2026` exists and is usable.

Concrete failure:

- A classbook admin can currently delete any non-protected curriculum document ([firestore.rules:675](/Users/christiehubley/studio-hub/firestore.rules:675)).
- They accidentally delete `lessons_spring-2026` between C and D.
- The source still matches the Phase-C hash.
- Phase D deletes the source.
- Spring now exists only in downloads/backups.

At minimum, Phase D must refuse unless a forced-server target read succeeds. For a rigorous hash comparison, target writes must remain paused; otherwise legitimate edits make equality impossible. The migration record should also be written with merge semantics so `storageMigrations` is not accidentally overwritten.

3. Phase A’s fence is bypassable by document create and whole-document delete.

The proposed fence applies only to updates ([plan:75](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:75)). Existing rules separately allow create and delete ([firestore.rules:654](/Users/christiehubley/studio-hub/firestore.rules:654), [firestore.rules:666](/Users/christiehubley/studio-hub/firestore.rules:666), [firestore.rules:675](/Users/christiehubley/studio-hub/firestore.rules:675)).

Concrete bypass:

1. A classbook-admin deletes all of `curriculum/lessonData`.
2. The same user recreates it with `setDoc({ 'spring-2026': staleCopy })`.
3. Both operations are allowed; `affectedKeys()` on update never runs.

A manager/admin can likewise delete the whole source document, contrary to “only deletes that key.”

Required rules behavior:

- Deny creation of `lessonData` when it contains `spring-2026`.
- Deny whole-document deletion of `lessonData`.
- Preserve manager whole-document delete for other curriculum docs, including rollback deletion of `lessons_spring-2026`.

Q3: yes, splitting line 654 should preserve manager delete for ordinary curriculum documents and the new target. It should not preserve whole-document deletion of `lessonData` while that document is the protected source.

The test matrix also needs explicit `admin` and legacy `curriculum-admin`, not only teacher/classbook-admin/manager. The existing suite has fixtures for both ([rules.test.js:33](/Users/christiehubley/studio-hub/rules.test.js:33), [rules.test.js:49](/Users/christiehubley/studio-hub/rules.test.js:49)).

4. Pre-Phase-B tabs still silently lose the Spring view at Phase D.

The proposed “moved — reload” behavior can protect only tabs running Phase-B code. A genuinely old tab still executes:

```js
currentLessonData = doc.data();
```

at [firebase-data.js:1186](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1186). When Phase D removes Spring, that tab blanks it. Its saves are denied by Phase A, but the read-side disappearance is silent.

Waiting “a few days” reduces likelihood but does not prove no old tab remains. Phase D needs an operational stale-client cutoff: forced version reload, confirmed maximum session lifetime, or an explicit requirement that all Classbook tabs be closed/reloaded before deletion.

The B implementation also needs a tested transition when the target changes from present to missing. Deleting the target for rollback does not itself trigger the unchanged legacy listener, so an own-doc listener must explicitly reload the legacy source or show a mandatory reload—not leave the last target map in memory.

5. Content-count logic double-counts Spring between C and D.

Phase B says the live count will sum `lessonData` and `lessons_spring-2026` ([plan:105](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:105)). Christie’s backup snippet likewise tallies both ([plan:192](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:192)). Existing counting walks every semester in the shared document ([app.js:7518](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7518), [backup.js:381](/Users/christiehubley/tinker-backups/backup.js:381)).

Concrete input:

- Teacher has 10 Spring lessons and 5 Fall lessons.
- Between C and D, both counters report 25 instead of 15.
- The automated backup runs every 30 minutes ([backup.js:3](/Users/christiehubley/tinker-backups/backup.js:3)) and records 25.
- Phase D removes the duplicate; live count becomes 15 against a baseline of 25.
- The dashboard reports a 40% loss.

Both implementations must choose one source per semester: use `lessons_spring-2026` when present and skip `lessonData['spring-2026']`; otherwise use the legacy map.

6. Adding a second Studio Hub listener “the same way” makes alerts erase each other.

The existing listener removes every curriculum alert not present in its own snapshot’s ID list ([alerts.js:632](/Users/christiehubley/studio-hub/js/alerts.js:632)). With independent legacy and Spring listeners:

- Fall snapshot produces alert `F` and removes Spring alert `S`.
- Spring snapshot produces `S` and removes `F`.
- Whichever listener fires last wins.

Alert IDs also omit the semester, using only `lessonKey` ([alerts.js:592](/Users/christiehubley/studio-hub/js/alerts.js:592)); identical teacher/class/week keys across Fall and Spring collide.

Phase B must maintain per-source snapshot state and reconcile their union, prefer the target over the frozen legacy Spring copy during C–D, and key alerts by semester plus lesson key.

7. Deferring `deleteSemester` hides migrated Spring data today.

The delete UI remains available for any inactive semester ([app.js:4522](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4522)). It removes config first, then performs lesson deletion as a warn-only cleanup ([app.js:4562](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4562), [app.js:4583](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4583)).

After migration, deleting Spring can remove its config entry while leaving `lessons_spring-2026` orphaned and invisible. Deferring this until “before the next semester is created” ([plan:161](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:161)) is insufficient. Phase B must either route deletion correctly and make it failure-atomic, or disable Spring deletion with a clear message until the follow-up lands.

## Other completeness and test findings

The 13 runtime `lessonData` references listed in the plan are accurate for this commit. Additional manual writers were missed:

- [test-alerts-browser.html:227](/Users/christiehubley/studio-hub/test-alerts-browser.html:227)
- [TESTING-GUIDE.md:115](/Users/christiehubley/studio-hub/TESTING-GUIDE.md:115)

They operate on root `qaData`, not Spring lessons, so they do not block the move, but the reader/writer inventory should identify them.

The near-1 MiB emulator fixture is worthwhile and sound as a rules-semantics regression test. It does not prove production latency or exact remaining document headroom. Build it from multiple subfields, assert its actual encoded/estimated size, and isolate/reset it per mutating test. The diagnostics plan also needs to define how `N KB` is computed; `JSON.stringify(doc.data()).length` is not the Firestore document’s encoded size. Label it approximate and retain a conservative buffer unless an actual Firestore-size estimator is used.

## Simpler safe option

Given only ~52 KB of headroom, the safer simplification is:

1. Deploy Phase B and establish a stale-client cutoff.
2. Keep Spring writes paused.
3. In one manager transaction, require the target absent, copy Spring, record the merged migration entry, and delete the old Spring field atomically.
4. Forced-server verify target hash and source absence.
5. Unpause target writes only after verification.

That removes the multi-day duplicate interval, the double-counting window, and the C-to-D target-loss exposure. It does require an explicit write-unpause step, but Spring’s temporary read-only state has already been approved.

## Minimum list

1. Close the Phase-C target-write/verification/rollback race.
2. Make Phase D verify the target and migration record from the server before deletion.
3. Fence `lessonData` create and whole-document delete, and add admin/curriculum-admin tests.
4. Add a defensible stale-pre-Phase-B-tab cutoff.
5. Deduplicate live and backup content counts during the dual-copy interval.
6. Aggregate Studio Hub alert sources instead of letting listeners remove each other’s alerts.
7. Handle or disable `deleteSemester('spring-2026')` in Phase B.
8. Specify merged `storageMigrations` writes, target-disappearance behavior, and a conservative headroom measurement.

Until those are in the plan, execution can hide Spring, discard a legitimate edit during rollback, or delete the last live copy.
tokens used
128,225
# Verdict: NOT EXECUTION-READY

Revision 2 fixes much of round 1, but four remaining defects can lose or hide edits. The rules fence also has two bypasses. I reviewed main `2ef2e62`, made no edits, and ran no tests.

## Blocking findings

1. Phase C still has the verification race that revision 2 claims is gone.

The fence freezes only `lessonData['spring-2026']`; it does not freeze the newly created target. As soon as the transaction creates `lessons_spring-2026`, a Phase-B listener can enable editing and the existing writers can update it ([firebase-data.js:1364](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1364), [app.js:3615](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3615), [app.js:7135](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7135)).

Concrete failure:

1. Phase C transaction copies hash `H`.
2. A teacher’s already-open Phase-B tab receives the target snapshot and saves an edit.
3. Forced verification reads hash `H2`.
4. The plan calls that a mismatch and recommends deleting the target ([plan:142](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:142), [plan:179](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:179)).
5. Deleting it discards the legitimate edit.

The source being frozen does not make target deep-equality stable. Keep Spring unwritable through verification, or treat a changed target as potentially legitimate and never prescribe deletion without reconciling it. Rollback also needs a write pause because an update racing a whole-document delete can acknowledge and then disappear.

2. Phase D does not verify the document it is relying on.

Phase D checks only the frozen source against the recorded hash, then deletes the source ([plan:153](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:153)). It does not require a forced-server read proving that `lessons_spring-2026` exists and is usable.

Concrete failure:

- A classbook admin can currently delete any non-protected curriculum document ([firestore.rules:675](/Users/christiehubley/studio-hub/firestore.rules:675)).
- They accidentally delete `lessons_spring-2026` between C and D.
- The source still matches the Phase-C hash.
- Phase D deletes the source.
- Spring now exists only in downloads/backups.

At minimum, Phase D must refuse unless a forced-server target read succeeds. For a rigorous hash comparison, target writes must remain paused; otherwise legitimate edits make equality impossible. The migration record should also be written with merge semantics so `storageMigrations` is not accidentally overwritten.

3. Phase A’s fence is bypassable by document create and whole-document delete.

The proposed fence applies only to updates ([plan:75](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:75)). Existing rules separately allow create and delete ([firestore.rules:654](/Users/christiehubley/studio-hub/firestore.rules:654), [firestore.rules:666](/Users/christiehubley/studio-hub/firestore.rules:666), [firestore.rules:675](/Users/christiehubley/studio-hub/firestore.rules:675)).

Concrete bypass:

1. A classbook-admin deletes all of `curriculum/lessonData`.
2. The same user recreates it with `setDoc({ 'spring-2026': staleCopy })`.
3. Both operations are allowed; `affectedKeys()` on update never runs.

A manager/admin can likewise delete the whole source document, contrary to “only deletes that key.”

Required rules behavior:

- Deny creation of `lessonData` when it contains `spring-2026`.
- Deny whole-document deletion of `lessonData`.
- Preserve manager whole-document delete for other curriculum docs, including rollback deletion of `lessons_spring-2026`.

Q3: yes, splitting line 654 should preserve manager delete for ordinary curriculum documents and the new target. It should not preserve whole-document deletion of `lessonData` while that document is the protected source.

The test matrix also needs explicit `admin` and legacy `curriculum-admin`, not only teacher/classbook-admin/manager. The existing suite has fixtures for both ([rules.test.js:33](/Users/christiehubley/studio-hub/rules.test.js:33), [rules.test.js:49](/Users/christiehubley/studio-hub/rules.test.js:49)).

4. Pre-Phase-B tabs still silently lose the Spring view at Phase D.

The proposed “moved — reload” behavior can protect only tabs running Phase-B code. A genuinely old tab still executes:

```js
currentLessonData = doc.data();
```

at [firebase-data.js:1186](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1186). When Phase D removes Spring, that tab blanks it. Its saves are denied by Phase A, but the read-side disappearance is silent.

Waiting “a few days” reduces likelihood but does not prove no old tab remains. Phase D needs an operational stale-client cutoff: forced version reload, confirmed maximum session lifetime, or an explicit requirement that all Classbook tabs be closed/reloaded before deletion.

The B implementation also needs a tested transition when the target changes from present to missing. Deleting the target for rollback does not itself trigger the unchanged legacy listener, so an own-doc listener must explicitly reload the legacy source or show a mandatory reload—not leave the last target map in memory.

5. Content-count logic double-counts Spring between C and D.

Phase B says the live count will sum `lessonData` and `lessons_spring-2026` ([plan:105](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:105)). Christie’s backup snippet likewise tallies both ([plan:192](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:192)). Existing counting walks every semester in the shared document ([app.js:7518](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7518), [backup.js:381](/Users/christiehubley/tinker-backups/backup.js:381)).

Concrete input:

- Teacher has 10 Spring lessons and 5 Fall lessons.
- Between C and D, both counters report 25 instead of 15.
- The automated backup runs every 30 minutes ([backup.js:3](/Users/christiehubley/tinker-backups/backup.js:3)) and records 25.
- Phase D removes the duplicate; live count becomes 15 against a baseline of 25.
- The dashboard reports a 40% loss.

Both implementations must choose one source per semester: use `lessons_spring-2026` when present and skip `lessonData['spring-2026']`; otherwise use the legacy map.

6. Adding a second Studio Hub listener “the same way” makes alerts erase each other.

The existing listener removes every curriculum alert not present in its own snapshot’s ID list ([alerts.js:632](/Users/christiehubley/studio-hub/js/alerts.js:632)). With independent legacy and Spring listeners:

- Fall snapshot produces alert `F` and removes Spring alert `S`.
- Spring snapshot produces `S` and removes `F`.
- Whichever listener fires last wins.

Alert IDs also omit the semester, using only `lessonKey` ([alerts.js:592](/Users/christiehubley/studio-hub/js/alerts.js:592)); identical teacher/class/week keys across Fall and Spring collide.

Phase B must maintain per-source snapshot state and reconcile their union, prefer the target over the frozen legacy Spring copy during C–D, and key alerts by semester plus lesson key.

7. Deferring `deleteSemester` hides migrated Spring data today.

The delete UI remains available for any inactive semester ([app.js:4522](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4522)). It removes config first, then performs lesson deletion as a warn-only cleanup ([app.js:4562](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4562), [app.js:4583](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4583)).

After migration, deleting Spring can remove its config entry while leaving `lessons_spring-2026` orphaned and invisible. Deferring this until “before the next semester is created” ([plan:161](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:161)) is insufficient. Phase B must either route deletion correctly and make it failure-atomic, or disable Spring deletion with a clear message until the follow-up lands.

## Other completeness and test findings

The 13 runtime `lessonData` references listed in the plan are accurate for this commit. Additional manual writers were missed:

- [test-alerts-browser.html:227](/Users/christiehubley/studio-hub/test-alerts-browser.html:227)
- [TESTING-GUIDE.md:115](/Users/christiehubley/studio-hub/TESTING-GUIDE.md:115)

They operate on root `qaData`, not Spring lessons, so they do not block the move, but the reader/writer inventory should identify them.

The near-1 MiB emulator fixture is worthwhile and sound as a rules-semantics regression test. It does not prove production latency or exact remaining document headroom. Build it from multiple subfields, assert its actual encoded/estimated size, and isolate/reset it per mutating test. The diagnostics plan also needs to define how `N KB` is computed; `JSON.stringify(doc.data()).length` is not the Firestore document’s encoded size. Label it approximate and retain a conservative buffer unless an actual Firestore-size estimator is used.

## Simpler safe option

Given only ~52 KB of headroom, the safer simplification is:

1. Deploy Phase B and establish a stale-client cutoff.
2. Keep Spring writes paused.
3. In one manager transaction, require the target absent, copy Spring, record the merged migration entry, and delete the old Spring field atomically.
4. Forced-server verify target hash and source absence.
5. Unpause target writes only after verification.

That removes the multi-day duplicate interval, the double-counting window, and the C-to-D target-loss exposure. It does require an explicit write-unpause step, but Spring’s temporary read-only state has already been approved.

## Minimum list

1. Close the Phase-C target-write/verification/rollback race.
2. Make Phase D verify the target and migration record from the server before deletion.
3. Fence `lessonData` create and whole-document delete, and add admin/curriculum-admin tests.
4. Add a defensible stale-pre-Phase-B-tab cutoff.
5. Deduplicate live and backup content counts during the dual-copy interval.
6. Aggregate Studio Hub alert sources instead of letting listeners remove each other’s alerts.
7. Handle or disable `deleteSemester('spring-2026')` in Phase B.
8. Specify merged `storageMigrations` writes, target-disappearance behavior, and a conservative headroom measurement.

Until those are in the plan, execution can hide Spring, discard a legitimate edit during rollback, or delete the last live copy.
