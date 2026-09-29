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
session id: 01a0ee55-50e1-7a72-8a52-ecb60e1ac701
--------
user
## Codex confirmation round 4 — narrow
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 6). Your round 3: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md. Read the Decisions Log entry "revision 6". Repo (read-only, main 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 .
Check only: (1) your round-3 minimum (stale post-delete saves prevented; copy and no-copy key reuse specified/tested; acceptance snapshot list) — RESOLVED / NOT with plan-line citations; (2) whether the new appData listener + assertSemesterStillExists design is sound against the code: every doc('lessonData') writer covered? any risk the listener changes existing behaviour (currentConfig untouched)? first-snapshot timing (a save before the first snapshot arrives)? offline/cache snapshots? (3) One-line verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
codex
I’ll inspect revision 6, the round-3 review, and the relevant read-only code paths, then report only the requested checks.
exec
/bin/zsh -lc "sed -n '1,260p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html && sed -n '1,220p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md && rg -n \"lessonData|loadConfig|currentConfig|onSnapshot|save|setDoc|updateDoc\" . --glob '"'!node_modules/**'"'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Plan: Classbook — "Make this the active semester" in Settings</title>
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

<h1 id="plan-title">Plan: Classbook — "Make this the active semester" in Settings</h1>

<div class="meta" id="plan-meta">
  <strong>Goal:</strong> At each term change, Christie can make the new semester the Classbook's active one from Settings in one step, and choose to put everyone (teachers included) onto it the next time they open the app. No console commands needed.<br>
  <strong>App:</strong> tinker-spring-curriculum (The Classbook): <code>js/app.js</code>, <code>js/firebase-data.js</code>, one new e2e spec. <strong>No</strong> Firestore rules change, no new collection.<br>
  <strong>Context:</strong> Created Sep 29, 2026. Christie asked how to move "active" from Spring 2026 to Fall 2026 and found there is no UI for it. She is doing a one-time console switch meanwhile (<code>await updateAppData({ activeSemester: 'fall-2026' })</code>). Her answer to "want me to plan it?": <em>"yes we should do this."</em><br>
  <strong>Line numbers</strong> are at <code>2ef2e62</code> (main, live on Netlify).<br>
  <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Christie answered Q1/Q2. Three Claude rounds, then Codex's independent review: NOT ready (5 findings). Revisions 4–6 address them; Codex confirmation round 4 is next.
</div>

<h2 id="open-questions">Christie's decisions (Sep 29)</h2>
<div class="decision">
  <strong>Q1: Which semesters can be made active? Answer: class semesters (Fall/Spring) and Summer camp seasons.</strong> SDOC years are excluded: they're a whole school year running alongside the class semesters, so they're never "the" current term. Making a camp season active has to be checked everywhere "active" is read (see the Phase 1 camp-season scenarios).<br><br>
  <strong>Q2: "Switch everyone to it" ticked by default? Answer: yes, ticked.</strong>
</div>

<h2 id="today">What exists today (research)</h2>
<table>
  <tr><th>Fact</th><th>Where</th></tr>
  <tr><td><code>curriculum/appData.activeSemester</code> is set only when missing (first semester created) and never re-pointed. There is no UI to change it.</td><td><code>js/app.js:11318-11319</code> (comment "only ever SET when missing"), <code>:11247</code></td></tr>
  <tr><td>What "active" controls: the "(active)"/"(current)" labels; the fallback semester for a browser with nothing remembered; Curriculum Admin's semester after a delete; the active semester can't be deleted and its Publish toggle is hidden (the badge says "always visible to teachers").</td><td><code>app.js:68, 76, 818, 4492-4530, 4590, 10687-10712</code></td></tr>
  <tr><td>What it does <strong>not</strong> control: what a returning user sees. Each browser remembers <code>globalSemesterKey</code> in localStorage and keeps it while it exists and is visible.</td><td><code>app.js:13, 65-70, 96-100</code></td></tr>
  <tr><td><code>getActiveSemesterKey()</code> despite its name returns the <em>selected</em> semester first, and <code>activeSemester</code> only as a fallback. So <code>getCurrentWeekNum()</code> follows the selection, not the flag.</td><td><code>firebase-data.js:3117-3123</code>, <code>app.js:1243</code></td></tr>
  <tr><td>"Active" does <strong>not</strong> imply visible: <code>canSeeSemester()</code> ignores it, so an unpublished active semester is hidden from teachers (the fallback at :68 already guards for that).</td><td><code>app.js:277-284</code></td></tr>
  <tr><td>Rules: <code>curriculum/{docId}</code> is read/write for manager+, and appData is manager+ only. Settings is hidden for everyone below manager.</td><td><code>studio-hub/firestore.rules:652-657</code>; <code>app.js:318-329</code></td></tr>
  <tr><td>All appData writes go through <code>updateAppData(flatPaths)</code>: one <code>update()</code> of only the named paths, refused after a failed config load or a bad season registry.</td><td><code>firebase-data.js:212-240</code></td></tr>
  <tr><td>The template to follow is <code>toggleSemesterPublish()</code>: optimistic in-memory change, <code>updateAppData</code>, exact restore plus an alert on failure, then re-render.</td><td><code>app.js:4604-4630</code></td></tr>
  <tr><td>Config is read once per page load. There is no live listener (<code>setupConfigListener</code> is never called), so open tabs see a change on their next reload.</td><td><code>firebase-data.js:521</code>, <code>app.js:11328</code></td></tr>
  <tr><td>No other Tinker app reads <code>activeSemester</code> (grep of studio-hub, summer-camp-app, roster-manager, schedule-viewer, playbook, materials, enrollment-board).</td><td>—</td></tr>
  <tr><td><strong>Settings' "Editing Semester" dropdown doesn't work.</strong> <code>onchange="loadSettingsForm()"</code> redraws the form for <code>getSettingsSemKey()</code> = the header's <code>globalSemesterKey</code>, so the pick snaps back. Today the only way to point Settings at another semester is the header dropdown. (Round-1 review, finding 2; confirmed.)</td><td><code>index.html:411</code>; <code>app.js:10659-10661, 10681-10689</code></td></tr>
  <tr><td><strong>Making a weekly semester non-active arms its Delete.</strong> Curriculum Admin's bar (manager/admin only) shows Delete for every non-active semester. For a weekly one, <code>deleteSemester</code> removes the appData entry (manager-only), then <code>deleteLessonData(key)</code> removes that semester's whole lesson map, behind two generic confirms. Since the Sep 29 console switch this is already true of Spring 2026 in production. (Finding 3; confirmed.)</td><td><code>app.js:4481-4483, 4522, 4527-4590</code>; <code>firebase-data.js:961-966</code></td></tr>
  <tr><td>The header selector's <code>change</code> listener is attached on every <code>initGlobalSemesterSelector()</code> call, with no attach-once guard (the Teacher View selector has one). It's already re-called after creating a semester. (Finding 7; confirmed.)</td><td><code>app.js:86</code>, <code>:825</code>, <code>:4724, 4845</code></td></tr>
  <tr><td>Teacher View's own selector labels the active semester "(current)".</td><td><code>app.js:818-819</code>, <code>:653-655</code></td></tr>
  <tr><td>Teachers can <em>read</em> appData (<code>classbook</code> / <code>classbook-admin</code> / <code>curriculum-admin</code>). Only create/update is manager+. That read is what lets Phase 2 work for teachers.</td><td><code>firestore.rules:665-669</code></td></tr>
  <tr><td>e2e: no spec has ever written appData for real. They stub <code>window.updateAppData</code> and assert the payload. The Node helper signs in as the staff account, which the rules refuse on appData. There is a saved <em>manager</em> session but no saved teacher session.</td><td><code>data-safety.spec.js:3947, 7596-7610</code>; <code>helpers/firestore.js:57</code>; <code>global-setup.js:63-70</code></td></tr>
  <tr><td>e2e seed: <code>activeSemester: spring-2026</code>; semesters spring-2026 (weekly, published) and summer-2026 (camp, unpublished). Specs that touch activeSemester or publishing: day-off-camps, day-off-teacher, data-safety.</td><td><code>e2e/fixtures/seed/curriculum.json</code></td></tr>
</table>

<h2 id="phases">Phases</h2>
<p>Two phases, committed separately and <strong>deployed once</strong> (one Netlify credit) after both are reviewed.</p>

<div class="phase" id="phase-1">
<h3>Phase 1: "Make active" in Settings, plus the two things it depends on <span class="status-tag not-ready">execution-ready: false</span></h3>
<p><strong>Acceptance (user outcomes):</strong></p>
<ul>
  <li><strong>Settings' "Editing Semester" dropdown works.</strong> Picking a semester there switches the app to it, the same as the header and Teacher View dropdowns already do. The header dropdown shows the new semester too, and the Settings form shows that semester. It lists only semesters the user can see.</li>
  <li><strong>Settings is reachable only by managers and admins.</strong> Today curriculum-admin and prep users can open it through the footer "Settings" link, because only the tab button is hidden. That link and its dot get hidden for them as well, and <code>switchTab('settings')</code> refuses for them.</li>
  <li>When Settings is on a non-active Fall/Spring class semester or Summer camp season (Q1; never an SDOC year), a manager sees <strong>"Make this the active semester"</strong> in the publish group.</li>
  <li>Clicking it asks one confirmation that names both semesters, "Make Fall 2026 the active semester? Spring 2026 stops being active.", and adds, when true:
    <ul>
      <li>New semester is a draft: "It's a draft — it will be published so teachers can see it." Activation publishes it in the same single write. That makes the existing "Active Semester — always visible to teachers" badge true, which it isn't today for an unpublished active semester.</li>
      <li>Old semester is a weekly class semester: "Spring 2026 can then be deleted from Curriculum Admin — its lessons stay unless someone deletes it."</li>
      <li>New semester is a camp season: "While Summer 2026 is active it can't be removed or unpublished — make another semester active first."</li>
    </ul></li>
  <li>After confirming, every place that labels the active semester updates without a reload: the header, Teacher View ("(current)"), Settings' badge/toggle, and Curriculum Admin's badge/toggle/Delete.</li>
  <li><strong>Deleting a weekly semester gets a real guard, and becomes all-or-nothing:</strong>
    <ul>
      <li>The confirmation states how many lessons it holds, read fresh from the server, and says truthfully what happens. Its lessons are deleted. Its cut bank and change history stay stored but are no longer reachable in the Classbook unless a semester with the same key is recreated. (The current text wrongly says they're removed.)</li>
      <li>You must type the semester's name to proceed (trimmed, case-insensitive).</li>
      <li>Before anything is deleted, the Classbook <strong>downloads a JSON snapshot</strong> of that semester: its appData entry, lessons, cut bank, change history, prep data, lesson backup and diagnostic dismissals, all read fresh from the server. If a read fails, nothing is deleted.</li>
      <li>Any tab still open on that semester refuses further lesson saves ("This semester was deleted — reload").</li>
      <li>The semester's entry and its lessons are removed <strong>in one Firestore transaction</strong>: either both go or neither does. Today they're two separate writes, and a failure of the second is only logged to the console, which can leave lessons orphaned and unreachable (Codex finding 3).</li>
    </ul>
    Camp seasons and SDOC years keep their current (non-destructive) flows.</li>
  <li>If the write fails for any reason (rules, a failed config load, or the season registry being unknown or in error), nothing changes on screen and an alert names the reason and says "Nothing was changed."</li>
  <li>Nobody below manager sees the control: it's rendered only for <code>admin</code>/<code>manager</code> roles, <code>makeSemesterActive</code> refuses otherwise, and the rules refuse the write regardless.</li>
</ul>
<p><strong>Shape:</strong></p>
<ul>
  <li><code>index.html:411</code>: a new <code>onSettingsSemesterChange(value)</code> that does what Teacher View's selector does (<code>app.js:826-830</code>): set <code>#global-semester-select</code>'s value <em>first</em>, then <code>setGlobalSemester(value)</code>. Without the header sync, the header would keep showing the old semester and re-picking it would fire no change event (round 2, finding 1). Settings' options are filtered by <code>canSeeSemester</code>, like the header's.</li>
  <li><code>setupRoleAccess</code> (<code>app.js:318-336</code>): hide <code>#settings-link</code> and its dot (<code>.footer-dot.write-control</code>; other <code>.footer-dot</code>s stay) for non-managers too. <code>switchTab('settings')</code>, the footer handler, <strong>and the tab button's own click handler</strong> (<code>app.js:203</code>) refuse for non-managers.</li>
  <li>New <code>makeSemesterActive(key)</code> beside <code>toggleSemesterPublish</code>. Eligibility is by type (<code>isWeeklySemester(key) || isCampSeason(key)</code>), never by key prefix (there's a ratchet against prefix routing). It refuses if the user isn't admin/manager, or the key is missing or already active. It checks <code>isPublishableType(key)</code> before any auto-publish, so the two gates can't drift. The old semester's name falls back to its key if the name is missing. Then it confirms through <code>confirmModal</code> (built in this phase, so Phase 2 only adds the checkbox and the activation tests aren't rewritten), then writes through a new <code>activateSemesterTx(key, expectedActive, { publish, switchEveryone })</code> in <code>firebase-data.js</code> (Codex finding 4). It's one <code>runTransaction</code> that re-reads appData from the server and refuses, with "reload and try again", unless <code>semesters[key]</code> still exists with a name and an eligible type, and <code>activeSemester === expectedActive</code> (what the confirmation showed). Only then does it <code>tx.update</code> <code>activeSemester</code>, the publish flag if needed, the Phase 2 switch field, and <code>lastUpdated</code>/<code>lastUpdatedBy</code>. This way a stale tab can't point "active" at a semester another tab deleted, or recreate a half-semester through the dotted publish path. It honours the same guards as <code>updateAppData</code>. <code>currentConfig</code> changes only after the commit succeeds; on failure nothing local changes.</li>
  <li>Re-render set after success or failure: header options, Teacher View selector, <code>renderSemesterSelector()</code>, <code>loadSettingsForm()</code>. The header's <code>change</code> listener gets the attach-once guard Teacher View already uses (<code>dataset.listenerAttached</code>), so re-rendering doesn't stack handlers.</li>
  <li><code>deleteSemester</code>, weekly branch only, in this order:
    <ol>
      <li>Forced-server reads of everything keyed by the semester: <code>readServerSemesterLessonMap(key)</code>, <code>cutProjects[key]</code>, <code>changeLog[key]</code>, <code>prepData[key]</code>, <code>lessonData_backup[key]</code>, <code>diagnosticDismissals[key]</code> (<code>firebase-data.js:551, 979-995, 1212, 1267, 1286-1308</code>). Any rejection refuses. <code>null</code> means none and proceeds.</li>
      <li>The modal (count, truthful text, typed name).</li>
      <li>A JSON snapshot download: <code>classbook-&lt;key&gt;-snapshot-&lt;ISO&gt;.json</code> through a Blob link, containing <code>{ appDataEntry, lessons, cutProjects, changeLog, prepData, lessonDataBackup, diagnosticDismissals, takenAt, takenBy }</code>.</li>
      <li>New <code>deleteWeeklySemesterTx(key)</code> in <code>firebase-data.js</code>: one <code>runTransaction</code> (the house pattern, e.g. <code>firebase-data.js:2452</code>) that re-reads <strong>both</strong> appData and lessonData, and verifies that <code>semesters[key]</code> still exists, <code>activeSemester !== key</code>, and <code>lessonData[key]</code> is deep-equal to the snapshot just downloaded. If anyone saved a lesson in that semester since, it refuses ("lessons changed while you were deleting — reload and try again"), so the snapshot always matches exactly what was deleted. Saves to <em>other</em> semesters touch the same document, so Firestore may retry the transaction. Its built-in retries are fine for a rare manual delete, and if they run out, nothing is deleted and the alert says so. It then <code>tx.update</code>s appData (<code>semesters.&lt;key&gt;</code> delete, plus <code>lastUpdated</code>/<code>lastUpdatedBy</code>) and lessonData (<code>&lt;key&gt;</code> delete). It honours <code>updateAppData</code>'s guards (<code>configLoadFailed</code>, season registry).</li>
    </ol>
    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs are prevented, not accepted</strong> (Codex round 3). A new, narrow <code>onSnapshot</code> on <code>curriculum/appData</code> keeps only a set <code>serverSemesterKeys</code>, and deliberately does <em>not</em> replace <code>currentConfig</code>, so no other behaviour changes. Every writer to <code>curriculum/lessonData</code> for a weekly semester calls <code>assertSemesterStillExists(semKey)</code> first: <code>saveLessonData</code>, <code>saveSingleLesson</code>, the move/swap batch writers (today <code>firebase-data.js:802, 830, 1364-1438, 1500</code>; the executor re-greps for every <code>doc('lessonData')</code> writer). It refuses with "This semester was deleted — reload" once the listener reports the key gone. The listener costs one read at load plus one per appData change. The remaining window, a save already in flight at the instant of deletion, is milliseconds wide. If it ever happens, the orphan fragment has no appData entry, so it's invisible. Key reuse is then covered both ways: with "Copy from", the existing server pre-check (<code>app.js:4913-4916</code>) refuses. Without it, re-creating deliberately <em>adopts</em> any leftover (<code>app.js:4910-4912</code>, by design, so a deleted semester can be restored), and Phase 1 adds a server read of that key to the no-copy path that shows "N leftover lessons will be adopted — continue?" when any exist. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
  <li>Left alone on purpose: <code>app.js:5069-5074</code> and the <code>caCurrentSemester</code> assignment at <code>:4590</code> are dead code (round 2 confirmed that nothing reads them). This plan doesn't touch them.</li>
  <li>The Curriculum Admin bar stays read-only for "active" (it's the same audience, but one place to change it is enough).</li>
</ul>

<div class="bdd">Scenario: the Settings dropdown switches semester (fix)
  Given a manager on Settings with the header on Spring 2026
  When they pick Fall 2026 in "Editing Semester"
  Then the header shows Fall 2026 and the Settings form shows Fall's name/start date

Scenario: manager makes Fall active (happy path) — real write, manager session
  Given a manager on Settings for Fall 2026 (published, weekly), active = Spring 2026
  When they click "Make this the active semester", UNTICK "switch everyone" (Phase 2), and confirm
  Then curriculum/appData.activeSemester reads back from the emulator as "fall-2026"
   And a whole-document diff of appData, ignoring lastUpdated/lastUpdatedBy (as app.js:10918 does), shows only activeSemester changed
   And header "Fall 2026 (active)", Teacher View "Fall 2026 (current)", Settings badge on Fall,
       Curriculum Admin shows Spring with Publish toggle and Delete

Scenario: making a draft semester active publishes it (edge) — stubbed updateAppData
  Given Fall 2026 is published:false
  When the manager makes it active and confirms (dialog mentions publishing)
  Then exactly one updateAppData call, and
       Object.keys(payload).sort() equals ["activeSemester", "semesters.fall-2026.published", …Phase 2 keys]

Scenario: a Summer camp season can be made active (Q1)
  Given Settings on Summer 2026 (camp season)
  When the manager makes it active
  Then activeSemester = "summer-2026"; with nothing remembered a user lands on Summer 2026;
       Prep Dashboard hidden (as for any camp selection); Teacher View and Curriculum Admin render as they do when Summer is merely selected (so a curriculum-admin/prep user with nothing remembered lands with the Curriculum Admin tab hidden, as today for Summer)

Scenario: back from Summer to a class semester (edge)
  Given Summer 2026 is active
  When the manager makes Fall 2026 active
  Then the Prep Dashboard tab reappears for Fall

Scenario: cancel changes nothing (edge)
  When the manager cancels the confirmation
  Then updateAppData is not called and nothing on screen changes

Scenario: ineligible or already active: no button (edge)
  Given Settings on an SDOC year, or on the active semester
  Then no "Make this the active semester" button

Scenario: non-manager never sees it (UI)
  Given a curriculum-admin (staff) user
  Then the Settings tab button AND the footer "Settings" link are hidden
   And calling switchTab('settings') leaves them where they were
   And the button is not visible even though loadSettingsForm ran (assert not visible, not count 0)

Scenario: the Settings dropdown keeps the header in step (regression, round 2)
  Given the header shows Spring 2026
  When Settings' dropdown picks Fall 2026, then the header picks Spring 2026
  Then the app is back on Spring 2026 (the header change fired)

Scenario: a camp season active can't be removed (edge)
  Given Summer 2026 is active
  Then Curriculum Admin shows no Delete and no Publish toggle for it, and the activation confirm said so

Scenario: write refused by the rules (failure) — real write, staff session
  Given the staff test account
  When updateAppData({ activeSemester: "spring-2026" }) is called
  Then it rejects with permission-denied and appData is unchanged

Scenario: write refused by the app's own guard (failure)
  Given seasonRegistryMode = "error" (or configLoadFailed)
  When the manager confirms
  Then the alert names the reason, says "Nothing was changed", and the labels, activeSemester and published flag are exactly as before

Scenario: deleting a weekly semester needs its name typed (safety)
  Given Spring 2026 is not active and the server holds N lessons for it
  When the manager clicks Delete
  Then the modal states N lessons, says the cut bank and change history stay, and requires "Spring 2026"
       (trimmed, case-insensitive); a wrong or empty answer deletes nothing
       (updateAppData and deleteLessonData not called)

Scenario: the delete is all-or-nothing (failure) — real transaction, manager session
  Given a test weekly semester with lessons in the emulator
  When the transaction is made to fail (e.g. the appData entry is removed by a second writer between the read and the commit, or a stubbed commit rejects)
  Then both curriculum/appData.semesters.<key> and curriculum/lessonData.<key> read back unchanged

Scenario: lessons edited during the delete (failure, Codex round 2)
  Given the snapshot was downloaded, then a lesson in that semester is saved by another tab before the commit
  When the transaction runs
  Then it refuses, nothing is deleted, and the alert asks for a reload

Scenario: a stale tab can't save into a deleted semester (safety, Codex round 3)
  Given tab B is open on the weekly semester's lessons
  When tab A deletes that semester
  Then tab B's next lesson save refuses with "This semester was deleted — reload"
   And lessonData has no key for that semester afterwards

Scenario: reusing a deleted key without "Copy from" says what it adopts (edge)
  Given lessonData holds leftover lessons under a key with no appData entry
  When a manager creates a semester with that key and no "Copy from"
  Then a confirm states "N leftover lessons will be adopted"; cancel creates nothing

Scenario: reusing it with "Copy from" (edge, existing)
  Then the existing "Lesson content already exists" alert refuses, as today

Scenario: a snapshot is taken first (safety)
  When the manager confirms a weekly delete
  Then a download named classbook-<key>-snapshot-*.json happens before the transaction
   And it contains the appData entry, lessons, cutProjects, changeLog, prepData, lessonData_backup and diagnosticDismissals for that key

Scenario: a stale tab can't activate a deleted semester (failure, Codex finding 4)
  Given tab A loaded Fall; the Fall entry is then deleted on the server
  When tab A makes Fall active
  Then the transaction refuses, asks for a reload, and appData.activeSemester and semesters are unchanged
   (no semesters.fall-2026 = {published:true} ghost)

Scenario: someone changed "active" meanwhile (failure)
  Given tab A's confirmation showed Spring as active, but the server now says Summer
  When tab A confirms
  Then it refuses and asks for a reload

Scenario: the lesson count can't be read (failure)
  Given readServerSemesterLessonMap rejects
  When the manager clicks Delete
  Then an alert says nothing was deleted, and nothing was

Scenario: re-render does not stack handlers (regression)
  After makeSemesterActive runs twice, one header change calls setGlobalSemester exactly once</div>
</div>

<div class="phase" id="phase-2">
<h3>Phase 2: "Switch everyone to it" <span class="status-tag not-ready">execution-ready: false</span></h3>
<p><strong>Acceptance (user outcomes):</strong></p>
<ul>
  <li>The Phase 1 confirmation has a checkbox, <strong>"Also switch everyone to Fall 2026 the next time they open the Classbook"</strong>, ticked by default (Q2). Because a plain <code>confirm()</code> can't hold a checkbox, the confirmation becomes a small in-app modal, reusing the existing <code>simple-modal</code> styling.</li>
  <li>With it ticked, every <strong>person</strong> who can see that semester lands on it the next time they load the Classbook, once per person, not once per browser. On a shared studio computer, each teacher who signs in is moved once (Codex finding 2). That includes the manager who made the switch, on their next load. After that, any semester they pick sticks as usual.</li>
  <li>The switch is tied to <strong>that</strong> semester. If someone later makes a different semester active without ticking the box, browsers that haven't loaded yet are not moved anywhere.</li>
  <li>A user who can't see the semester yet (unpublished; rare, since activation publishes) isn't moved, and isn't marked done either. If it becomes visible while the switch still stands, they move then.</li>
  <li>With it unticked, nobody's remembered semester moves. An unticked activation <strong>deletes</strong> any earlier switch record in the same transaction, so an old switch can never come back to life (Codex finding 1).</li>
  <li>Tabs already open move on their next reload, not live.</li>
</ul>
<p><strong>Shape:</strong> the "seen" marker is per signed-in user: <code>localStorage['activeSemesterSwitchSeen:' + uid]</code>. <code>globalSemesterKey</code> stays browser-wide as today. When unticked, the transaction writes <code>activeSemesterSwitch: FieldValue.delete()</code>. When ticked, the same transaction writes <code>activeSemesterSwitch: { to: key, at: new Date().toISOString() }</code>. It must be a <strong>client ISO string</strong>, the way <code>lastUpdated</code> is: a <code>serverTimestamp()</code> reads back as a Timestamp, would never equal the stored string, and would re-switch on every load. Compare <code>String(sw.at)</code>. <strong>Placement is load-bearing:</strong> the check runs <em>once</em> in the <code>DOMContentLoaded</code> sequence, after <code>requireAuth</code> and <code>loadConfig()</code> (<code>app.js:148-152</code>) and before <code>initGlobalSemesterSelector()</code> (<code>:158</code>). Never inside <code>initGlobalSemesterSelector</code>, which is re-called after creating a semester and after <code>makeSemesterActive</code>, and would consume the manager's own switch in the same page load. It's one map field, so it replaces the previous switch whole. On load, before the existing pick at <code>app.js:65</code>, with <code>sw = currentConfig.activeSemesterSwitch</code> and <code>seen = localStorage['activeSemesterSwitchSeen:' + getAuthUser().uid]</code>:</p>
<ul>
  <li>If <code>sw</code> is missing, or <code>sw.at === seen</code>: do nothing.</li>
  <li>If <code>sw.to !== currentConfig.activeSemester</code>: the switch is stale, so mark it seen and do nothing.</li>
  <li>If <code>canSeeSemester(sw.to)</code>: set <code>globalSemesterKey = sw.to</code> and <strong>write <code>localStorage.globalSemesterKey</code> here</strong> (the <code>setItem</code> at :69 sits in the fallback branch, which this makes false), then mark it seen.</li>
  <li>Otherwise (can't see it yet): don't move and don't mark it seen.</li>
</ul>
<p><strong>Decided asymmetry:</strong> a browser that marked a switch seen through the stale branch isn't moved if that same target becomes active again later without a new tick, while a browser that never loaded would be. That's acceptable: a later switch is a new <code>at</code> and moves everyone.</p>
<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
<div class="note">A new <strong>field</strong> on existing <code>curriculum/appData</code>. It's not a new collection, so no rules change. Nothing reads it until the first switch, so deploying Phase 2 moves nobody.</div>

<div class="bdd">Scenario: teachers are moved once (happy path) — staged so the first sign-in can't consume it (Codex finding 5)
  Given a teacher signed in via the form in a fresh context while NO switch exists
   And their browser then remembers "spring-2026"
   And a manager context then makes Fall active with the box ticked (T1)
  When the teacher reloads the Classbook
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
session id: 01a0ee53-f5e4-7a40-b0d9-9398bd5e84b7
--------
user
## Codex confirmation round 3 — narrow
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 5). Your round 2: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md. Read the Decisions Log entry "revision 5". Repo (read-only, main 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 .
Check only your two round-2 minimum changes (snapshot contents; delete coordinating with lessonData incl. stale-tab behaviour) against the code: RESOLVED / NOT RESOLVED with plan-line citations, and whether revision 5 introduced anything wrong. One-line verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
codex
I’ll compare revision 5’s decisions and relevant plan lines against the current read-only implementation, limited to the two round-2 issues.
exec
/bin/zsh -lc "sed -n '1,260p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html && sed -n '1,220p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Plan: Classbook — "Make this the active semester" in Settings</title>
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

<h1 id="plan-title">Plan: Classbook — "Make this the active semester" in Settings</h1>

<div class="meta" id="plan-meta">
  <strong>Goal:</strong> At each term change, Christie can make the new semester the Classbook's active one from Settings in one step, and choose to put everyone (teachers included) onto it the next time they open the app. No console commands needed.<br>
  <strong>App:</strong> tinker-spring-curriculum (The Classbook): <code>js/app.js</code>, <code>js/firebase-data.js</code>, one new e2e spec. <strong>No</strong> Firestore rules change, no new collection.<br>
  <strong>Context:</strong> Created Sep 29, 2026. Christie asked how to move "active" from Spring 2026 to Fall 2026 and found there is no UI for it. She is doing a one-time console switch meanwhile (<code>await updateAppData({ activeSemester: 'fall-2026' })</code>). Her answer to "want me to plan it?": <em>"yes we should do this."</em><br>
  <strong>Line numbers</strong> are at <code>2ef2e62</code> (main, live on Netlify).<br>
  <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Christie answered Q1/Q2. Three Claude rounds, then Codex's independent review: NOT ready (5 findings). Revisions 4–5 address them; Codex confirmation round 3 is next.
</div>

<h2 id="open-questions">Christie's decisions (Sep 29)</h2>
<div class="decision">
  <strong>Q1: Which semesters can be made active? Answer: class semesters (Fall/Spring) and Summer camp seasons.</strong> SDOC years are excluded: they're a whole school year running alongside the class semesters, so they're never "the" current term. Making a camp season active has to be checked everywhere "active" is read (see the Phase 1 camp-season scenarios).<br><br>
  <strong>Q2: "Switch everyone to it" ticked by default? Answer: yes, ticked.</strong>
</div>

<h2 id="today">What exists today (research)</h2>
<table>
  <tr><th>Fact</th><th>Where</th></tr>
  <tr><td><code>curriculum/appData.activeSemester</code> is set only when missing (first semester created) and never re-pointed. There is no UI to change it.</td><td><code>js/app.js:11318-11319</code> (comment "only ever SET when missing"), <code>:11247</code></td></tr>
  <tr><td>What "active" controls: the "(active)"/"(current)" labels; the fallback semester for a browser with nothing remembered; Curriculum Admin's semester after a delete; the active semester can't be deleted and its Publish toggle is hidden (the badge says "always visible to teachers").</td><td><code>app.js:68, 76, 818, 4492-4530, 4590, 10687-10712</code></td></tr>
  <tr><td>What it does <strong>not</strong> control: what a returning user sees. Each browser remembers <code>globalSemesterKey</code> in localStorage and keeps it while it exists and is visible.</td><td><code>app.js:13, 65-70, 96-100</code></td></tr>
  <tr><td><code>getActiveSemesterKey()</code> despite its name returns the <em>selected</em> semester first, and <code>activeSemester</code> only as a fallback. So <code>getCurrentWeekNum()</code> follows the selection, not the flag.</td><td><code>firebase-data.js:3117-3123</code>, <code>app.js:1243</code></td></tr>
  <tr><td>"Active" does <strong>not</strong> imply visible: <code>canSeeSemester()</code> ignores it, so an unpublished active semester is hidden from teachers (the fallback at :68 already guards for that).</td><td><code>app.js:277-284</code></td></tr>
  <tr><td>Rules: <code>curriculum/{docId}</code> is read/write for manager+, and appData is manager+ only. Settings is hidden for everyone below manager.</td><td><code>studio-hub/firestore.rules:652-657</code>; <code>app.js:318-329</code></td></tr>
  <tr><td>All appData writes go through <code>updateAppData(flatPaths)</code>: one <code>update()</code> of only the named paths, refused after a failed config load or a bad season registry.</td><td><code>firebase-data.js:212-240</code></td></tr>
  <tr><td>The template to follow is <code>toggleSemesterPublish()</code>: optimistic in-memory change, <code>updateAppData</code>, exact restore plus an alert on failure, then re-render.</td><td><code>app.js:4604-4630</code></td></tr>
  <tr><td>Config is read once per page load. There is no live listener (<code>setupConfigListener</code> is never called), so open tabs see a change on their next reload.</td><td><code>firebase-data.js:521</code>, <code>app.js:11328</code></td></tr>
  <tr><td>No other Tinker app reads <code>activeSemester</code> (grep of studio-hub, summer-camp-app, roster-manager, schedule-viewer, playbook, materials, enrollment-board).</td><td>—</td></tr>
  <tr><td><strong>Settings' "Editing Semester" dropdown doesn't work.</strong> <code>onchange="loadSettingsForm()"</code> redraws the form for <code>getSettingsSemKey()</code> = the header's <code>globalSemesterKey</code>, so the pick snaps back. Today the only way to point Settings at another semester is the header dropdown. (Round-1 review, finding 2; confirmed.)</td><td><code>index.html:411</code>; <code>app.js:10659-10661, 10681-10689</code></td></tr>
  <tr><td><strong>Making a weekly semester non-active arms its Delete.</strong> Curriculum Admin's bar (manager/admin only) shows Delete for every non-active semester. For a weekly one, <code>deleteSemester</code> removes the appData entry (manager-only), then <code>deleteLessonData(key)</code> removes that semester's whole lesson map, behind two generic confirms. Since the Sep 29 console switch this is already true of Spring 2026 in production. (Finding 3; confirmed.)</td><td><code>app.js:4481-4483, 4522, 4527-4590</code>; <code>firebase-data.js:961-966</code></td></tr>
  <tr><td>The header selector's <code>change</code> listener is attached on every <code>initGlobalSemesterSelector()</code> call, with no attach-once guard (the Teacher View selector has one). It's already re-called after creating a semester. (Finding 7; confirmed.)</td><td><code>app.js:86</code>, <code>:825</code>, <code>:4724, 4845</code></td></tr>
  <tr><td>Teacher View's own selector labels the active semester "(current)".</td><td><code>app.js:818-819</code>, <code>:653-655</code></td></tr>
  <tr><td>Teachers can <em>read</em> appData (<code>classbook</code> / <code>classbook-admin</code> / <code>curriculum-admin</code>). Only create/update is manager+. That read is what lets Phase 2 work for teachers.</td><td><code>firestore.rules:665-669</code></td></tr>
  <tr><td>e2e: no spec has ever written appData for real. They stub <code>window.updateAppData</code> and assert the payload. The Node helper signs in as the staff account, which the rules refuse on appData. There is a saved <em>manager</em> session but no saved teacher session.</td><td><code>data-safety.spec.js:3947, 7596-7610</code>; <code>helpers/firestore.js:57</code>; <code>global-setup.js:63-70</code></td></tr>
  <tr><td>e2e seed: <code>activeSemester: spring-2026</code>; semesters spring-2026 (weekly, published) and summer-2026 (camp, unpublished). Specs that touch activeSemester or publishing: day-off-camps, day-off-teacher, data-safety.</td><td><code>e2e/fixtures/seed/curriculum.json</code></td></tr>
</table>

<h2 id="phases">Phases</h2>
<p>Two phases, committed separately and <strong>deployed once</strong> (one Netlify credit) after both are reviewed.</p>

<div class="phase" id="phase-1">
<h3>Phase 1: "Make active" in Settings, plus the two things it depends on <span class="status-tag not-ready">execution-ready: false</span></h3>
<p><strong>Acceptance (user outcomes):</strong></p>
<ul>
  <li><strong>Settings' "Editing Semester" dropdown works.</strong> Picking a semester there switches the app to it, the same as the header and Teacher View dropdowns already do. The header dropdown shows the new semester too, and the Settings form shows that semester. It lists only semesters the user can see.</li>
  <li><strong>Settings is reachable only by managers and admins.</strong> Today curriculum-admin and prep users can open it through the footer "Settings" link, because only the tab button is hidden. That link and its dot get hidden for them as well, and <code>switchTab('settings')</code> refuses for them.</li>
  <li>When Settings is on a non-active Fall/Spring class semester or Summer camp season (Q1; never an SDOC year), a manager sees <strong>"Make this the active semester"</strong> in the publish group.</li>
  <li>Clicking it asks one confirmation that names both semesters, "Make Fall 2026 the active semester? Spring 2026 stops being active.", and adds, when true:
    <ul>
      <li>New semester is a draft: "It's a draft — it will be published so teachers can see it." Activation publishes it in the same single write. That makes the existing "Active Semester — always visible to teachers" badge true, which it isn't today for an unpublished active semester.</li>
      <li>Old semester is a weekly class semester: "Spring 2026 can then be deleted from Curriculum Admin — its lessons stay unless someone deletes it."</li>
      <li>New semester is a camp season: "While Summer 2026 is active it can't be removed or unpublished — make another semester active first."</li>
    </ul></li>
  <li>After confirming, every place that labels the active semester updates without a reload: the header, Teacher View ("(current)"), Settings' badge/toggle, and Curriculum Admin's badge/toggle/Delete.</li>
  <li><strong>Deleting a weekly semester gets a real guard, and becomes all-or-nothing:</strong>
    <ul>
      <li>The confirmation states how many lessons it holds, read fresh from the server, and says truthfully what happens. Its lessons are deleted. Its cut bank and change history stay stored but are no longer reachable in the Classbook unless a semester with the same key is recreated. (The current text wrongly says they're removed.)</li>
      <li>You must type the semester's name to proceed (trimmed, case-insensitive).</li>
      <li>Before anything is deleted, the Classbook <strong>downloads a JSON snapshot</strong> of that semester: its appData entry, lesson map, cut bank and change history, all read fresh from the server. If a read fails, nothing is deleted.</li>
      <li>The semester's entry and its lessons are removed <strong>in one Firestore transaction</strong>: either both go or neither does. Today they're two separate writes, and a failure of the second is only logged to the console, which can leave lessons orphaned and unreachable (Codex finding 3).</li>
    </ul>
    Camp seasons and SDOC years keep their current (non-destructive) flows.</li>
  <li>If the write fails for any reason (rules, a failed config load, or the season registry being unknown or in error), nothing changes on screen and an alert names the reason and says "Nothing was changed."</li>
  <li>Nobody below manager sees the control: it's rendered only for <code>admin</code>/<code>manager</code> roles, <code>makeSemesterActive</code> refuses otherwise, and the rules refuse the write regardless.</li>
</ul>
<p><strong>Shape:</strong></p>
<ul>
  <li><code>index.html:411</code>: a new <code>onSettingsSemesterChange(value)</code> that does what Teacher View's selector does (<code>app.js:826-830</code>): set <code>#global-semester-select</code>'s value <em>first</em>, then <code>setGlobalSemester(value)</code>. Without the header sync, the header would keep showing the old semester and re-picking it would fire no change event (round 2, finding 1). Settings' options are filtered by <code>canSeeSemester</code>, like the header's.</li>
  <li><code>setupRoleAccess</code> (<code>app.js:318-336</code>): hide <code>#settings-link</code> and its dot (<code>.footer-dot.write-control</code>; other <code>.footer-dot</code>s stay) for non-managers too. <code>switchTab('settings')</code>, the footer handler, <strong>and the tab button's own click handler</strong> (<code>app.js:203</code>) refuse for non-managers.</li>
  <li>New <code>makeSemesterActive(key)</code> beside <code>toggleSemesterPublish</code>. Eligibility is by type (<code>isWeeklySemester(key) || isCampSeason(key)</code>), never by key prefix (there's a ratchet against prefix routing). It refuses if the user isn't admin/manager, or the key is missing or already active. It checks <code>isPublishableType(key)</code> before any auto-publish, so the two gates can't drift. The old semester's name falls back to its key if the name is missing. Then it confirms through <code>confirmModal</code> (built in this phase, so Phase 2 only adds the checkbox and the activation tests aren't rewritten), then writes through a new <code>activateSemesterTx(key, expectedActive, { publish, switchEveryone })</code> in <code>firebase-data.js</code> (Codex finding 4). It's one <code>runTransaction</code> that re-reads appData from the server and refuses, with "reload and try again", unless <code>semesters[key]</code> still exists with a name and an eligible type, and <code>activeSemester === expectedActive</code> (what the confirmation showed). Only then does it <code>tx.update</code> <code>activeSemester</code>, the publish flag if needed, the Phase 2 switch field, and <code>lastUpdated</code>/<code>lastUpdatedBy</code>. This way a stale tab can't point "active" at a semester another tab deleted, or recreate a half-semester through the dotted publish path. It honours the same guards as <code>updateAppData</code>. <code>currentConfig</code> changes only after the commit succeeds; on failure nothing local changes.</li>
  <li>Re-render set after success or failure: header options, Teacher View selector, <code>renderSemesterSelector()</code>, <code>loadSettingsForm()</code>. The header's <code>change</code> listener gets the attach-once guard Teacher View already uses (<code>dataset.listenerAttached</code>), so re-rendering doesn't stack handlers.</li>
  <li><code>deleteSemester</code>, weekly branch only, in this order:
    <ol>
      <li>Forced-server reads of everything keyed by the semester: <code>readServerSemesterLessonMap(key)</code>, <code>cutProjects[key]</code>, <code>changeLog[key]</code>, <code>prepData[key]</code>, <code>lessonData_backup[key]</code>, <code>diagnosticDismissals[key]</code> (<code>firebase-data.js:551, 979-995, 1212, 1267, 1286-1308</code>). Any rejection refuses. <code>null</code> means none and proceeds.</li>
      <li>The modal (count, truthful text, typed name).</li>
      <li>A JSON snapshot download: <code>classbook-&lt;key&gt;-snapshot-&lt;ISO&gt;.json</code> through a Blob link, containing <code>{ appDataEntry, lessons, cutProjects, changeLog, prepData, lessonDataBackup, diagnosticDismissals, takenAt, takenBy }</code>.</li>
      <li>New <code>deleteWeeklySemesterTx(key)</code> in <code>firebase-data.js</code>: one <code>runTransaction</code> (the house pattern, e.g. <code>firebase-data.js:2452</code>) that re-reads <strong>both</strong> appData and lessonData, and verifies that <code>semesters[key]</code> still exists, <code>activeSemester !== key</code>, and <code>lessonData[key]</code> is deep-equal to the snapshot just downloaded. If anyone saved a lesson in that semester since, it refuses ("lessons changed while you were deleting — reload and try again"), so the snapshot always matches exactly what was deleted. Saves to <em>other</em> semesters touch the same document, so Firestore may retry the transaction. Its built-in retries are fine for a rare manual delete, and if they run out, nothing is deleted and the alert says so. It then <code>tx.update</code>s appData (<code>semesters.&lt;key&gt;</code> delete, plus <code>lastUpdated</code>/<code>lastUpdatedBy</code>) and lessonData (<code>&lt;key&gt;</code> delete). It honours <code>updateAppData</code>'s guards (<code>configLoadFailed</code>, season registry).</li>
    </ol>
    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs (accepted, defined):</strong> a lesson editor left open on the deleted semester can still save per-field paths into <code>lessonData.&lt;key&gt;</code> afterwards (<code>firebase-data.js:1429-1437</code>). That recreates an orphan fragment with no appData entry, so it's invisible in the app and loses nothing. If the key is ever reused, <code>createNewSemester</code>'s existing server pre-check (<code>app.js:4913-4916</code>) detects the leftover content and says so. Blocking it outright would mean a server read before every lesson save, which this plan doesn't take on. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
  <li>Left alone on purpose: <code>app.js:5069-5074</code> and the <code>caCurrentSemester</code> assignment at <code>:4590</code> are dead code (round 2 confirmed that nothing reads them). This plan doesn't touch them.</li>
  <li>The Curriculum Admin bar stays read-only for "active" (it's the same audience, but one place to change it is enough).</li>
</ul>

<div class="bdd">Scenario: the Settings dropdown switches semester (fix)
  Given a manager on Settings with the header on Spring 2026
  When they pick Fall 2026 in "Editing Semester"
  Then the header shows Fall 2026 and the Settings form shows Fall's name/start date

Scenario: manager makes Fall active (happy path) — real write, manager session
  Given a manager on Settings for Fall 2026 (published, weekly), active = Spring 2026
  When they click "Make this the active semester", UNTICK "switch everyone" (Phase 2), and confirm
  Then curriculum/appData.activeSemester reads back from the emulator as "fall-2026"
   And a whole-document diff of appData, ignoring lastUpdated/lastUpdatedBy (as app.js:10918 does), shows only activeSemester changed
   And header "Fall 2026 (active)", Teacher View "Fall 2026 (current)", Settings badge on Fall,
       Curriculum Admin shows Spring with Publish toggle and Delete

Scenario: making a draft semester active publishes it (edge) — stubbed updateAppData
  Given Fall 2026 is published:false
  When the manager makes it active and confirms (dialog mentions publishing)
  Then exactly one updateAppData call, and
       Object.keys(payload).sort() equals ["activeSemester", "semesters.fall-2026.published", …Phase 2 keys]

Scenario: a Summer camp season can be made active (Q1)
  Given Settings on Summer 2026 (camp season)
  When the manager makes it active
  Then activeSemester = "summer-2026"; with nothing remembered a user lands on Summer 2026;
       Prep Dashboard hidden (as for any camp selection); Teacher View and Curriculum Admin render as they do when Summer is merely selected (so a curriculum-admin/prep user with nothing remembered lands with the Curriculum Admin tab hidden, as today for Summer)

Scenario: back from Summer to a class semester (edge)
  Given Summer 2026 is active
  When the manager makes Fall 2026 active
  Then the Prep Dashboard tab reappears for Fall

Scenario: cancel changes nothing (edge)
  When the manager cancels the confirmation
  Then updateAppData is not called and nothing on screen changes

Scenario: ineligible or already active: no button (edge)
  Given Settings on an SDOC year, or on the active semester
  Then no "Make this the active semester" button

Scenario: non-manager never sees it (UI)
  Given a curriculum-admin (staff) user
  Then the Settings tab button AND the footer "Settings" link are hidden
   And calling switchTab('settings') leaves them where they were
   And the button is not visible even though loadSettingsForm ran (assert not visible, not count 0)

Scenario: the Settings dropdown keeps the header in step (regression, round 2)
  Given the header shows Spring 2026
  When Settings' dropdown picks Fall 2026, then the header picks Spring 2026
  Then the app is back on Spring 2026 (the header change fired)

Scenario: a camp season active can't be removed (edge)
  Given Summer 2026 is active
  Then Curriculum Admin shows no Delete and no Publish toggle for it, and the activation confirm said so

Scenario: write refused by the rules (failure) — real write, staff session
  Given the staff test account
  When updateAppData({ activeSemester: "spring-2026" }) is called
  Then it rejects with permission-denied and appData is unchanged

Scenario: write refused by the app's own guard (failure)
  Given seasonRegistryMode = "error" (or configLoadFailed)
  When the manager confirms
  Then the alert names the reason, says "Nothing was changed", and the labels, activeSemester and published flag are exactly as before

Scenario: deleting a weekly semester needs its name typed (safety)
  Given Spring 2026 is not active and the server holds N lessons for it
  When the manager clicks Delete
  Then the modal states N lessons, says the cut bank and change history stay, and requires "Spring 2026"
       (trimmed, case-insensitive); a wrong or empty answer deletes nothing
       (updateAppData and deleteLessonData not called)

Scenario: the delete is all-or-nothing (failure) — real transaction, manager session
  Given a test weekly semester with lessons in the emulator
  When the transaction is made to fail (e.g. the appData entry is removed by a second writer between the read and the commit, or a stubbed commit rejects)
  Then both curriculum/appData.semesters.<key> and curriculum/lessonData.<key> read back unchanged

Scenario: lessons edited during the delete (failure, Codex round 2)
  Given the snapshot was downloaded, then a lesson in that semester is saved by another tab before the commit
  When the transaction runs
  Then it refuses, nothing is deleted, and the alert asks for a reload

Scenario: a stale tab saves into a deleted semester (accepted, defined)
  Given the weekly semester was deleted
  When a stale tab saves a lesson field under its key
  Then an orphan fragment exists in lessonData but no appData entry, so the semester does not reappear in any selector;
   and creating a semester with that key shows the existing "Lesson content already exists" alert

./CLAUDE.md:24:- `summerCamps_lessonData` — lesson-level detail records (shared with Summer Camp App)
./CLAUDE.md:33:- Use `updateDoc` for partial edits — never `setDoc` for a partial update
./CLAUDE.md:44:This app's `loadConfig()` function **silently falls back to defaults on Firestore permission errors**. In May 2026, a rules regression made all data appear wiped when it was actually still in Firestore. Before assuming any data was lost:
./js/app.js:51:  if (!select || !currentConfig?.semesters) return;
./js/app.js:55:  const semesters = currentConfig.semesters;
./js/app.js:68:    globalSemesterKey = visibleKeys.includes(currentConfig.activeSemester) ? currentConfig.activeSemester : visibleKeys[0];
./js/app.js:76:    const isActive = key === currentConfig.activeSemester;
./js/app.js:97:  if (!currentConfig?.semesters?.[key]) return;
./js/app.js:103:  const semester = currentConfig.semesters[key];
./js/app.js:152:  await loadConfig();
./js/app.js:171:  if (lessonDataLoadedSuccessfully === false) {
./js/app.js:176:  const currentSemester = currentConfig?.semesters?.[globalSemesterKey];
./js/app.js:279:  const sem = currentConfig?.semesters?.[key];
./js/app.js:305:  const semester = currentConfig?.semesters?.[semKey];
./js/app.js:532:  const mappings = currentConfig?.teacherMappings;
./js/app.js:580:  const pool = new Set(currentConfig?.semesters?.[yearKey]?.teacherNames || []);
./js/app.js:593:  const mapped = currentConfig?.teacherMappings?.[user.uid];
./js/app.js:607:// What an SDOC plan save is authorized by — computed at save time and re-checked
./js/app.js:608:// against the fresh camp inside the save's transaction. The classbook key is
./js/app.js:664:  // Show banner and abort if load failed — prevents stale blank data from being saved.
./js/app.js:668:  if (lessonDataLoadedSuccessfully === false) {
./js/app.js:796:  if (!group || !select || !currentConfig?.semesters) return;
./js/app.js:800:  const semesters = currentConfig.semesters;
./js/app.js:818:    const isActive = key === currentConfig.activeSemester;
./js/app.js:1315:  // Check saved state, or default to expanded if there are admin replies
./js/app.js:1316:  const savedState = panel.dataset.expanded;
./js/app.js:1317:  const expanded = savedState !== undefined ? savedState !== 'false' : adminReplies.length > 0;
./js/app.js:1610:  const semester = currentConfig?.semesters?.[semKey];
./js/app.js:1763:          const editable = canEditDayOffPlan(slot) && lessonDataLoadedSuccessfully !== false;
./js/app.js:1792:// same save path, identified by its plan key (a title on two days is one plan,
./js/app.js:1807:    const result = await saveSingleLesson(yearKey, lessonKey, { planComplete: requested }, [], { dayOffAuth: dayOffAuthFor(yearKey) });
./js/app.js:1808:    if (result?.status === 'savedSince') alert(`Saved — ${result.by} has edited this plan since.`);
./js/app.js:1831:  const semester = currentConfig?.semesters?.[semKey];
./js/app.js:2006:  // checkbox saves to), never whichever happened to come last. Each slot's
./js/app.js:2322:      // One save at a time per LESSON: a second change while the first is in
./js/app.js:2325:      // element — a re-render replaces the element mid-save.
./js/app.js:2332:      // full if the save fails (R3-20 — the catch used to revert only the
./js/app.js:2334:      // the save is in flight merges per lesson by lastEditedAt (Phase 7),
./js/app.js:2344:      // The checkbox/badge may have been re-rendered while the save was in
./js/app.js:2359:        await saveSingleLesson(semKey, lessonKey, payload);
./js/app.js:2360:        // saveSingleLesson() stamps the payload it writes; keep the in-memory
./js/app.js:2361:        // copy identical to the doc — only if this save still owns the entry.
./js/app.js:2366:        displacedSummerServerCopies.delete(displacedKey(semKey, lessonKey)); // this save is the confirmed state now
./js/app.js:2371:        // ours while the save was in flight).
./js/app.js:2395:        // nothing downstream (the merge, the badge, a later save) sees an
./js/app.js:2396:        // edit that never landed. Only if this save still owns the entry.
./js/app.js:2403:          // the save has failed, that copy is the newest confirmed state —
./js/app.js:2404:          // take its saved-doc fields, in place, so identity holds.
./js/app.js:2412:        alert('Failed to save. Please try again.');
./js/app.js:2431:        await saveCampComplete(semKey, tvCurrentTeacher, campName, cb.checked);
./js/app.js:2438:        alert('Failed to save. Please try again.');
./js/app.js:2451:  const semester = currentConfig?.semesters?.[semKey] || getActiveSemester();
./js/app.js:2830:  // Plan Complete checkbox — instant save
./js/app.js:2843:        await saveSingleLesson(semKey, lessonKey, { planComplete: cb.checked });
./js/app.js:3030:        ${editable ? `<button class="te-save-btn" id="te-detail-edit-btn">&#9998; Edit</button>` : ''}
./js/app.js:3031:        <button class="te-save-btn" id="te-detail-print-btn">🖨️ Print</button>
./js/app.js:3193:        <div class="auto-save-status" id="te-autosave-status"></div>
./js/app.js:3196:          <button class="te-save-btn" id="te-save-btn">Save</button>
./js/app.js:3231:      if (!confirm('You have unsaved changes. Discard them?')) return;
./js/app.js:3244:  // Save handler. A manual save cancels any pending autosave — otherwise the
./js/app.js:3245:  // debounce could fire during the manual save and re-run it (and, with a
./js/app.js:3251:    saveTeacherEdit(lessonKey, currentLessonData?.[getTvSemKey()]?.[lessonKey] || lesson);
./js/app.js:3253:  document.getElementById('te-save-btn').addEventListener('click', manualTeSave);
./js/app.js:3255:  // Auto-save on input (2s debounce)
./js/app.js:3259:      saveTeacherEdit(lessonKey, currentLessonData?.[getTvSemKey()]?.[lessonKey] || lesson);
./js/app.js:3274:  // Cmd+S / Ctrl+S to save
./js/app.js:3417:// save, below) — only raw form data read fresh from the DOM needs normalizing.
./js/app.js:3440:async function saveTeacherEdit(lessonKey, originalLesson) {
./js/app.js:3441:  const saveBtn = document.getElementById('te-save-btn');
./js/app.js:3442:  const autoSaveStatus = document.getElementById('te-autosave-status');
./js/app.js:3450:    // Nothing to save — flash the button briefly
./js/app.js:3451:    if (saveBtn) { saveBtn.textContent = 'Saved!'; saveBtn.disabled = true; }
./js/app.js:3452:    setTimeout(() => { if (saveBtn) { saveBtn.textContent = 'Save'; saveBtn.disabled = false; } }, 1500);
./js/app.js:3456:  if (saveBtn) { saveBtn.disabled = true; saveBtn.textContent = 'Saving...'; }
./js/app.js:3466:    // mutation, so the delete-after-save step below has the right value to
./js/app.js:3474:      if (saveBtn) saveBtn.textContent = 'Uploading photo...';
./js/app.js:3477:      // Backtracking audit, Phase 8 (R4-2): delete moved to AFTER the save
./js/app.js:3484:      if (saveBtn) saveBtn.textContent = 'Saving...';
./js/app.js:3487:      // Backtracking audit, Phase 8 (R4-2): delete moved to AFTER the save
./js/app.js:3496:    // A content field that had text when the modal opened (or last saved) and
./js/app.js:3497:    // is now empty is an intentional clear — saveSingleLesson needs this list
./js/app.js:3507:    // saveSingleLesson's per-field dotted-path write always writes them
./js/app.js:3520:    await saveSingleLesson(semKey, lessonKey, writePayload, fieldsToClear);
./js/app.js:3521:    // saveSingleLesson() stamps lastEditedBy/At onto the object it is given.
./js/app.js:3532:        console.error('⚠️ Could not clean up old photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
./js/app.js:3537:    // pending selection so this modal's autosave doesn't re-upload the same
./js/app.js:3539:    // only, so a failed save keeps the selection for the retry.
./js/app.js:3550:    // must not be reported to the teacher as "Save failed" when the save
./js/app.js:3564:      console.error('⚠️ Lesson saved, but Change History logging failed:', logErr);
./js/app.js:3568:    if (saveBtn) { saveBtn.textContent = 'Saved!'; }
./js/app.js:3575:    // Reset dirty baseline so closing won't prompt "unsaved changes"
./js/app.js:3594:      if (saveBtn) { saveBtn.textContent = 'Save'; saveBtn.disabled = false; }
./js/app.js:3599:    if (saveBtn) { saveBtn.disabled = false; saveBtn.textContent = 'Save'; }
./js/app.js:3606:// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
./js/app.js:3611:// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
./js/app.js:3620:  // Same load-guard saveSingleLesson() enforced on the old path — after a
./js/app.js:3623:  if (lessonDataLoadedSuccessfully === false) {
./js/app.js:3631:  // under that key into curriculum/lessonData is never right. Routed by TYPE
./js/app.js:3690:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
./js/app.js:3702:  // would be persisted by the next autosave, which writes the cached
./js/app.js:4175:  const sem = currentConfig?.semesters?.[semKey] || {};
./js/app.js:4476:  if (!bar || !select || !currentConfig?.semesters) return;
./js/app.js:4478:  const semesters = currentConfig.semesters;
./js/app.js:4492:    const isActive = key === currentConfig.activeSemester;
./js/app.js:4514:    const isActive = currentKey === currentConfig.activeSemester;
./js/app.js:4528:  const sem = currentConfig?.semesters?.[key];
./js/app.js:4530:  if (key === currentConfig.activeSemester) {
./js/app.js:4541:  // curriculum/lessonData, and no collection is ever cleared from here.
./js/app.js:4562:  const removed = currentConfig.semesters[key];
./js/app.js:4563:  delete currentConfig.semesters[key];
./js/app.js:4567:    currentConfig.semesters[key] = removed;
./js/app.js:4579:  // curriculum/lessonData to delete. A camp season's lessons live in the
./js/app.js:4590:  caCurrentSemester = currentConfig.activeSemester;
./js/app.js:4605:  if (!currentConfig?.semesters?.[key]) return;
./js/app.js:4611:    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
./js/app.js:4615:  const hadPublished = 'published' in currentConfig.semesters[key];
./js/app.js:4616:  const previous = currentConfig.semesters[key].published;
./js/app.js:4617:  currentConfig.semesters[key].published = published;
./js/app.js:4622:    if (currentConfig.semesters[key]) {
./js/app.js:4623:      if (hadPublished) currentConfig.semesters[key].published = previous;
./js/app.js:4624:      else delete currentConfig.semesters[key].published;
./js/app.js:4687:// curriculum/lessonData write.
./js/app.js:4696:  if (currentConfig.semesters?.[key]) { alert(`${currentConfig.semesters[key].name} already exists (${key}).`); return; }
./js/app.js:4708:    currentConfig.semesters[key] = newSem;
./js/app.js:4758:    const semesters = currentConfig?.semesters || {};
./js/app.js:4792:// "already exists" check (the key is only added to currentConfig after the
./js/app.js:4814:// roster, no week grid, no lesson slots and no curriculum/lessonData write —
./js/app.js:4822:  if (currentConfig.semesters?.[key]) { alert(`Summer ${season} is already in the Classbook.`); return; }
./js/app.js:4842:    currentConfig.semesters[key] = newSem;
./js/app.js:4849:    delete currentConfig.semesters[key];
./js/app.js:4864:  if (currentConfig.semesters[key]) {
./js/app.js:4895:  let lessonDataCommitted = false;
./js/app.js:4899:    if (copyFromKey && currentConfig.semesters[copyFromKey]) {
./js/app.js:4920:      const source = currentConfig.semesters[copyFromKey];
./js/app.js:4965:        await saveLessonData(key, emptyLessons);
./js/app.js:4968:        lessonDataCommitted = true;
./js/app.js:4980:    currentConfig.semesters[key] = newSem;
./js/app.js:4985:    // "already exists" and the grid doesn't render a semester that never saved.
./js/app.js:4986:    delete currentConfig.semesters[key];
./js/app.js:4987:    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
./js/app.js:4992:    if (lessonDataCommitted) {
./js/app.js:5066:  const semester = currentConfig?.semesters?.[semKey] || getActiveSemester();
./js/app.js:5342:    // would be classified as an intentional clear on save.
./js/app.js:5358:// teacher editors, which this modal never had. saveAdminEdit() diffs the form
./js/app.js:5368:// summerCamps_lessonData doc exists yet, so saveAdminEdit() skips the check
./js/app.js:5371:// One admin-popup save at a time: the Save button is a bare onclick with no
./js/app.js:5373:// before anything visible happens — a double-click ran two full saves (two
./js/app.js:5385:// trimmed on the way in because saveAdminEdit() reads the form via
./js/app.js:5395:// force === true: the in-flight save closing its own popup on success. Any
./js/app.js:5397:// Event here, hence the strict check) is refused while a save is pending:
./js/app.js:5398:// otherwise the admin could open a second lesson mid-save and have the first
./js/app.js:5399:// save's completion close it and discard the new text.
./js/app.js:5419:  // edit here could only "save" and vanish — or, for the title, make the doc
./js/app.js:5421:  // the save-time diff sees them unchanged); saveAdminEditInner() still
./js/app.js:5426:    ? `<p class="te-photo-hint" style="margin:0 0 10px">Title, short details, inspo link and materials come from the Summer Camp App — edit them there. Everything below saves here.</p>`
./js/app.js:5510:      <button class="btn-primary ca-action-btn" onclick="saveAdminEdit('${escAttr(key)}', '${escAttr(teacher)}', '${escAttr(className)}', ${weekNum})">Save</button>
./js/app.js:5542:// popup's save. What goes to Firestore is ONLY what this popup changed — the
./js/app.js:5544:// this save touched them, plus identity/scheduling fields (teacher, className,
./js/app.js:5553:async function saveAdminEdit(key, teacher, className, weekNum) {
./js/app.js:5563:  if (lessonDataLoadedSuccessfully === false) {
./js/app.js:5564:    alert('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
./js/app.js:5572:  // modal body mid-save and race a second write onto the same slot).
./js/app.js:5574:  const saveBtn = btns.find(b => /^save/i.test(b.textContent.trim()));
./js/app.js:5576:  if (saveBtn) saveBtn.textContent = 'Saving...';
./js/app.js:5578:    await saveAdminEditInner(key, teacher, className, weekNum, title);
./js/app.js:5582:    if (saveBtn) saveBtn.textContent = 'Save';
./js/app.js:5586:async function saveAdminEditInner(key, teacher, className, weekNum, title) {
./js/app.js:5593:  // side effects — so a no-op save can bail out below without paying for the
./js/app.js:5613:  // saveSingleLesson must apply with FieldValue.delete() rather than let the
./js/app.js:5624:  // entry for an edit that didn't happen (mirrors saveTeacherEdit()).
./js/app.js:5633:  // summerCamps_lessonData doc exists (a missing doc means "never saved",
./js/app.js:5635:  // so there is no ghost to prevent — the first save legitimately creates
./js/app.js:5636:  // the doc. Same routing signal as saveSingleLesson() /
./js/app.js:5654:      alert('This lesson was moved or removed elsewhere while you had it open. Your changes were not saved — please close this window and check the grid for its new location.');
./js/app.js:5667:        if (!confirm(`This slot has changed since you opened it — it now contains "${freshTitle || '(empty)'}" instead of "${opened}". Save your changes onto "${freshTitle || 'this slot'}" anyway?\n\nCancel keeps your text here and saves nothing.`)) return;
./js/app.js:5679:    // between open and save — e.g. the project was renamed in the Summer
./js/app.js:5682:    alert('This lesson is no longer in the summer schedule — reload and try again. Nothing was saved.');
./js/app.js:5689:  // (SUMMER_SAVED_FIELDS), so an edit here would "save" and then vanish on the
./js/app.js:5699:      alert(`Summer camp ${refused.map(f => labels[f]).join(', ')} are managed in the Summer Camp App — that change is not saved here.` + (changedFields.length > refused.length || hasNewPhoto || pendingRemove ? ' Your other edits will still be saved.' : ''));
./js/app.js:5716:    // Summer identity trio, key-derived and idempotent — a doc this save
./js/app.js:5719:    // same trio on every save for the same reason).
./js/app.js:5726:  // mutation, so the delete-after-save step compares against the right value.
./js/app.js:5728:  let photoUrl = null, photoPath = null;   // null = this save didn't touch the photo
./js/app.js:5736:      // Delete of the OLD photo happens AFTER the save below — not here.
./js/app.js:5748:    // Targeted single-lesson save with a diff-only payload — never the cached
./js/app.js:5750:    // guard can't refuse a legitimate save from here: for summer every
./js/app.js:5753:    await saveSingleLesson(semKey, key, firestorePayload, fieldsToClear);
./js/app.js:5756:    // Firestore has confirmed the new reference — and only when THIS save
./js/app.js:5763:        console.error('⚠️ Could not clean up old photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
./js/app.js:5769:    // and log a fake edit even though the save never actually succeeded. The
./js/app.js:5771:    console.error('❌ Admin edit failed to save:', err);
./js/app.js:5772:    alert('This edit could not be saved. Please try again.');
./js/app.js:5786:    lastEditedBy: firestorePayload.lastEditedBy,   // stamped by saveSingleLesson()
./js/app.js:5793:  closeAdminModal(true);   // the save's own close — also resets the snapshot
./js/app.js:5827:// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
./js/app.js:5835:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
./js/app.js:5851:      const snap = await curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key)).get({ source: 'server' });
./js/app.js:5866:// failed to save or failed verification — puts both slots back to their
./js/app.js:5915:    // cleared — saveSingleLesson omits empty fields from the write rather
./js/app.js:5943:      await saveMultipleLessonFields(
./js/app.js:5945:        [{ lessonKey: newDestKey, lessonData: movedLesson, fieldsToClear: destFieldsToClear }],
./js/app.js:5952:      alert(`Move could not be saved — "${preMoveSourceLesson.projectTitle}" has been restored to its original slot. Nothing was changed.`);
./js/app.js:5972:        console.error('⚠️ Move saved, but Change History logging failed:', logErr);
./js/app.js:5991:    let savePromise;
./js/app.js:6011:      // Firestore call — closes the "first save landed, second failed"
./js/app.js:6012:      // partial-failure race the prior two-sequential-saves design was
./js/app.js:6014:      savePromise = (async () => {
./js/app.js:6016:          await saveMultipleLessonFields(semKey, [
./js/app.js:6017:            { lessonKey: sourceKeyForSwap, lessonData: swappedSource, fieldsToClear: sourceFieldsToClear },
./js/app.js:6018:            { lessonKey: newDestKey, lessonData: swappedDest, fieldsToClear: destFieldsToClearSwap }
./js/app.js:6035:      savePromise = (async () => {
./js/app.js:6037:          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
./js/app.js:6052:    await savePromise;
./js/app.js:6071:        console.error('⚠️ Swap saved, but Change History logging failed:', logErr);
./js/app.js:6144:// Backtracking audit, Phase 11 (R3-12, R3-13). Previously resaved the ENTIRE
./js/app.js:6145:// cached semester via saveLessonData() — any lesson whose local copy was stale
./js/app.js:6146:// (a teacher's concurrent save in another tab) was silently reverted on the
./js/app.js:6148:// after one bulk save, so a part-way failure lost the log for targets that
./js/app.js:6149:// had actually been written. Now: one targeted saveSingleLesson() per target
./js/app.js:6151:// target's stale value — the save strips empty content fields, so without the
./js/app.js:6153:// target only after its save resolves, logged immediately, honest count on
./js/app.js:6180:  let savedCount = 0;
./js/app.js:6187:      // after this target's own save has resolved (R3-13).
./js/app.js:6192:      // Send ONLY the copied fields (saveSingleLesson writes per-field paths
./js/app.js:6198:      await saveSingleLesson(semKey, targetKey, payload, targetFieldsToClear);
./js/app.js:6201:      savedCount++;
./js/app.js:6202:      // Uncheck the saved target so, if a later one fails, "retry the rest"
./js/app.js:6233:        // The copy itself is saved; a Change History miss must not read as
./js/app.js:6234:        // a failed copy (same rule as saveTeacherEdit(), Phase 8).
./js/app.js:6235:        console.error('⚠️ Copy saved, but Change History logging failed for', targetKey, logErr);
./js/app.js:6244:  // failed save (and can't re-throw from inside the catch).
./js/app.js:6248:    alert(`Copied to ${savedCount} of ${targetKeys.length} class(es) before a save failed. Please check which targets actually received the plan before retrying the rest.\n\n${failure.message}`);
./js/app.js:6252:  const skipped = targetKeys.length - savedCount;
./js/app.js:6253:  alert(`Plan copied to ${savedCount} class${savedCount !== 1 ? 'es' : ''}${skipped > 0 ? ` (${skipped} skipped)` : ''}.`);
./js/app.js:6262:// against curriculum/cutProjects (not saveCutProjects()'s local-splice-then-
./js/app.js:6265:// archive save leaves the live lesson completely untouched.
./js/app.js:6313:    console.error('Could not save Cut Bank entry for', key, e);
./js/app.js:6314:    alert(`Could not cut "${freshLesson.projectTitle}" — the Cut Bank entry could not be saved. Nothing was changed.`);
./js/app.js:6343:    console.error('⚠️ Cut saved, but Change History logging failed:', logErr);
./js/app.js:6365:      const semName = currentConfig?.semesters?.[key]?.name || key;
./js/app.js:6413:// Backtracking audit, Phase 8: targeted single-lesson save (not a bulk
./js/app.js:6414:// saveLessonData() semester overwrite), removal via FieldValue.arrayRemove()
./js/app.js:6415:// (not saveCutProjects()'s local-splice-then-full-array-overwrite — matches
./js/app.js:6436:  const srcSemName = currentConfig?.semesters?.[srcSemKey]?.name || srcSemKey;
./js/app.js:6476:    await saveSingleLesson(destSemKey, key, lessons[key], NON_CONTENT_FIELDS_TO_CLEAR);
./js/app.js:6479:    console.error('❌ Paste from Cut Bank failed to save the lesson:', err);
./js/app.js:6485:  // confirmed the clear — same safe ordering as saveAdminEdit()/saveTeacherEdit().
./js/app.js:6508:    console.error('❌ Lesson saved, but failed to persist Cut Bank removal:', err);
./js/app.js:6509:    alert('The lesson saved successfully, but this project could not be removed from the Cut Bank — it may still appear there. Reload to check.');
./js/app.js:6524:    console.error('⚠️ Paste saved, but Change History logging failed:', logErr);
./js/app.js:6763:      <button class="btn-primary" onclick="${isEdit ? `saveIdeaEdit(${editIndex})` : 'saveNewIdea()'}">${isEdit ? 'Save Changes' : 'Add Idea'}</button>
./js/app.js:6776:async function saveNewIdea() {
./js/app.js:6798:  await saveFutureProjects(projects);
./js/app.js:6811:async function saveIdeaEdit(idx) {
./js/app.js:6825:  await saveFutureProjects(projects);
./js/app.js:6838:  await saveFutureProjects(updated);
./js/app.js:6845:  await saveFutureProjects(projects);
./js/app.js:6852:  await saveFutureProjects(projects);
./js/app.js:6886:// saveLessonData() write passed the WHOLE {projects:[...]} wrapper into
./js/app.js:6887:// saveFutureProjects() (which expects a bare array), double-nesting
./js/app.js:6890:// BEFORE the destination lesson save was confirmed. Rewritten around a
./js/app.js:6891:// targeted saveSingleLesson() write (unrelated lessons in the same semester
./js/app.js:6897:// lesson-save-then-idea-removal ordering with an honest duplicate-message on
./js/app.js:6949:    await saveSingleLesson(semKey, key, newLesson, [...fieldsToClear, ...NON_CONTENT_FIELDS_TO_CLEAR]);
./js/app.js:6952:    console.error('❌ Paste from Idea Bank failed — lesson could not be saved:', err);
./js/app.js:6959:  // saveAdminEdit()/saveTeacherEdit().
./js/app.js:6968:  // NOT closed here: this is still a plain saveFutureProjects() .set(), the
./js/app.js:6979:    // still awaiting the lesson save could have already spliced the array,
./js/app.js:6984:    await saveFutureProjects(projects);
./js/app.js:6987:    console.error('❌ Paste from Idea Bank — lesson saved but idea removal failed:', err);
./js/app.js:7125:// resave the ENTIRE cached semester via saveLessonData() — a Firestore
./js/app.js:7127:// browser, not just the one being replied to. If a teacher's save landed on
./js/app.js:7146:  if (lessonDataLoadedSuccessfully === false) {
./js/app.js:7201:    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
./js/app.js:7202:    : curriculumDb.collection('curriculum').doc('lessonData');
./js/app.js:7231:  if (lessonDataLoadedSuccessfully === false) {
./js/app.js:7284:    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
./js/app.js:7285:    : curriculumDb.collection('curriculum').doc('lessonData');
./js/app.js:7515:  const summerSnap = await curriculumDb.collection('summerCamps_lessonData').get();
./js/app.js:7518:  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
./js/app.js:7519:  const lessonDataDoc = lessonDataSnap.exists ? lessonDataSnap.data() : {};
./js/app.js:7520:  for (const semesterLessons of Object.values(lessonDataDoc)) {
./js/app.js:7841:        await saveForecastDismissals(semKey, { ...localDismissed });
./js/app.js:7955:  const currentSemester = currentConfig?.semesters?.[semKey];
./js/app.js:8706:    savePrepDataNow();
./js/app.js:8723:  if (e.target.classList.contains('save-new-mat-btn')) {
./js/app.js:8864:  debounceTimer = setTimeout(() => savePrepDataNow(), 500);
./js/app.js:8867:async function savePrepDataNow() {
./js/app.js:8874:    await savePrepWeekData(semKey, weekKey, currentWeekPrepData);
./js/app.js:8882:  let indicator = document.getElementById('saved-indicator');
./js/app.js:8885:    indicator.id = 'saved-indicator';
./js/app.js:8886:    indicator.className = 'saved-indicator';
./js/app.js:9201:  // Restore saved view preference
./js/app.js:9434:        <button class="btn-primary" id="prep-cycle-save">Save</button>
./js/app.js:9468:  document.getElementById('prep-cycle-save').addEventListener('click', async () => {
./js/app.js:9469:    const saveBtn = document.getElementById('prep-cycle-save');
./js/app.js:9470:    saveBtn.disabled = true;
./js/app.js:9471:    saveBtn.textContent = 'Saving…';
./js/app.js:9485:      await savePrepCycleConfig({ phases: newPhases });
./js/app.js:9492:      saveBtn.disabled = false;
./js/app.js:9493:      saveBtn.textContent = 'Save';
./js/app.js:9700:  const currentSemester = currentConfig.semesters?.[globalSemesterKey];
./js/app.js:10003:      <button class="save-new-mat-btn" data-class="${escAttr(className)}" data-project="${escAttr(projectTitle)}" data-teacher="${escAttr(teacher)}">Save</button>
./js/app.js:10014:      formRow.querySelector('.save-new-mat-btn').click();
./js/app.js:10478:       <div class="diag-note-row" style="display:none;"><textarea class="diag-note-input" data-fp="${fp}" placeholder="e.g. Ask Mariah about this next Tuesday...">${escHtml(existingNote)}</textarea><button class="diag-note-save" data-fp="${fp}">Save Note</button></div>`
./js/app.js:10479:    : `<div class="diag-note-row"><textarea class="diag-note-input" data-fp="${fp}" placeholder="Add a note (e.g. Ask Mariah about this...)"></textarea><button class="diag-note-save" data-fp="${fp}">Save Note</button></div>`;
./js/app.js:10538:        await saveDiagDismissals(dismissals);
./js/app.js:10560:          await saveDiagDismissals(dismissals);
./js/app.js:10582:  // Note inputs — save on blur
./js/app.js:10590:      // Skip save if nothing changed
./js/app.js:10607:        await saveDiagDismissals(dismissals);
./js/app.js:10617:    // Also save on Enter (but allow Shift+Enter for multi-line)
./js/app.js:10642:  resultsDiv.querySelectorAll('.diag-note-save').forEach(btn => {
./js/app.js:10648:        // Trigger the blur handler which does the actual save
./js/app.js:10672:// to the tab for the same semester keeps any unsaved edits.
./js/app.js:10678:  const config = currentConfig || getDefaultConfig();
./js/app.js:10694:  // The pool as this form found it — the × button edits currentConfig's list
./js/app.js:10695:  // in place, so saveSettings() cannot use that to see what was removed.
./js/app.js:10787:  const sem = currentConfig?.semesters?.[semKey];
./js/app.js:10838:  const campSemesters = Object.keys(currentConfig?.semesters || {}).filter(isCampSeason);
./js/app.js:10843:      ? campSemesters.map(k => `${escHtml(currentConfig.semesters[k].name)} (${escHtml(seasonForSemesterSafe(k))})`).join(', ')
./js/app.js:10944:    currentConfig = after;
./js/app.js:10964:  const semester = currentConfig?.semesters?.[semKey] || {};
./js/app.js:10978:  // First, save current values from the form
./js/app.js:10980:  currentConfig.semesters[semKey].teacherNames = currentNames;
./js/app.js:10983:  currentConfig.semesters[semKey].teacherNames.push('');
./js/app.js:10994:  // First, save current values from the form
./js/app.js:10996:  currentConfig.semesters[semKey].teacherNames = currentNames;
./js/app.js:10999:  currentConfig.semesters[semKey].teacherNames.splice(idx, 1);
./js/app.js:11020:  const semester = currentConfig?.semesters?.[semKey] || {};
./js/app.js:11082:  const semester = currentConfig?.semesters?.[semKey] || {};
./js/app.js:11117:  const mappings = currentConfig?.teacherMappings || {};
./js/app.js:11177:      const currentMapping = Object.entries(currentConfig?.teacherMappings || {}).find(([, n]) => n === teacherName)?.[0] || '';
./js/app.js:11204:  const mappings = { ...(currentConfig?.teacherMappings || {}) };
./js/app.js:11209:  currentConfig.teacherMappings = mappings;
./js/app.js:11226:async function saveSettings() {
./js/app.js:11231:    alert('This form was showing a different semester from the one selected at the top, so nothing was saved. It now shows the selected semester — check it and save again.');
./js/app.js:11246:  const config = JSON.parse(JSON.stringify(currentConfig || {}));
./js/app.js:11252:  const existingMappings = currentConfig?.teacherMappings || {};
./js/app.js:11271:      // currentConfig's list before Save runs, and another tab may have added
./js/app.js:11278:        // Put just those names back in this tab's list (other unsaved edits in
./js/app.js:11280:        currentConfig.semesters[semKey].teacherNames = [...teacherNames, ...inUse.map(u => u.name).filter(n => !teacherNames.includes(n))];
./js/app.js:11282:        alert(`Can't remove ${inUse.map(u => `${u.name} (on ${u.camps.join(', ')})`).join('; ')} — take them off those camps first.\n\nNothing was saved.`);
./js/app.js:11287:        alert(`These day-off dates would fall outside the school year: ${outside.map(o => `${o.label} ${o.date}`).join(', ')}. Edit those events first.\n\nNothing was saved.`);
./js/app.js:11291:      alert(`Could not check the school year's camps and events: ${err.message}\n\nNothing was saved.`);
./js/app.js:11319:  if (!currentConfig?.activeSemester) extraPaths.activeSemester = semKey;
./js/app.js:11324:    // Phase 1 saveConfig() ended with `currentConfig = config`; dropping that
./js/app.js:11326:    // pre-save values and the NEXT Save wrote them back over the server —
./js/app.js:11327:    // silently, with "Settings saved!" both times. currentConfig has no live
./js/app.js:11330:    currentConfig.semesters = currentConfig.semesters || {};
./js/app.js:11331:    currentConfig.semesters[semKey] = currentConfig.semesters[semKey] || {};
./js/app.js:11333:      currentConfig.semesters[semKey][path.split('.').pop()] = value;
./js/app.js:11335:    if (extraPaths.teacherMappings) currentConfig.teacherMappings = extraPaths.teacherMappings;
./js/app.js:11336:    if (extraPaths.activeSemester) currentConfig.activeSemester = extraPaths.activeSemester;
./js/app.js:11341:    alert('Settings saved!');
./js/app.js:11359:// saveSettings() after every Settings save. No try/catch here on purpose —
./js/app.js:11361:// a catch here produced a false "Settings saved!" (round-3 finding).
./js/app.js:11373:  // entirely unrelated to classRoster. Without this gate, a Settings save
./js/app.js:11375:  // into the live summer cache and then re-saved EVERY real summer lesson
./js/app.js:11384:  // assigned up front, so a failed save left a phantom empty semester key
./js/app.js:11428:    await saveLessonData(semKey, lessons);
./js/app.js:11451:// Backtracking audit Phase 6: summer Plan Complete saves in flight, keyed by
./js/app.js:11453:// replaces (a fresh element would otherwise arrive enabled mid-save).
./js/app.js:11457:// Backtracking audit Phase 10: one save queue per summer lesson, shared by
./js/app.js:11459:// modal is closed and the lesson reopened while a save is still queued, the
./js/app.js:11460:// new modal's saves must line up behind the old one's, not run alongside it.
./js/app.js:11462:// How long Close waits for a pending save before offering to leave without it.
./js/app.js:11472:  // find the slot belonging to tvCurrentTeacher to save to the right doc ID.
./js/app.js:11501:// server first (a co-teacher may have saved since this page loaded), and a
./js/app.js:11504:// people who can see but not edit. The save chain, dirty-diff, close-wait
./js/app.js:11515:  const canEdit = sdoc ? canEditDayOffPlan(lesson) : true;   // summer: canEditLesson() gates each save, as before
./js/app.js:11667:        <div class="auto-save-status" id="summer-autosave-status"></div>
./js/app.js:11669:          <button class="te-save-btn" id="summer-lesson-save">Save</button>
./js/app.js:11670:          ${sdoc ? '' : '<button class="te-save-btn" id="summer-lesson-print">&#128438; Print</button>'}
./js/app.js:11683:    modal.querySelector('#summer-lesson-save').style.display = 'none';
./js/app.js:11686:    modal.querySelector('#summer-autosave-status').textContent = 'View only';
./js/app.js:11690:  // that's non-empty here but empty at save time is an intentional clear, not
./js/app.js:11691:  // an accidental stale-empty save. Reset after each successful save so a
./js/app.js:11692:  // later autosave round compares against the last-saved state, not the
./js/app.js:11693:  // original open state (mirrors teOriginalData's reset in saveTeacherEdit).
./js/app.js:11768:  // Auto-save functionality with debouncing
./js/app.js:11770:  const autoSaveStatus = document.getElementById('summer-autosave-status');
./js/app.js:11772:  // Backtracking audit Phase 10 — saves of this lesson are SERIALIZED.
./js/app.js:11773:  // Every saveLesson() call is chained behind the one before it (on the
./js/app.js:11774:  // lesson's shared queue, see summerLessonSaveChains), so a manual save (the
./js/app.js:11775:  // button, or a fast double-click) requested while an autosave is still
./js/app.js:11778:  // twice and their cache mutations raced. A queued save reads the form when
./js/app.js:11780:  // counter tells a save whether a newer one is already waiting behind it —
./js/app.js:11781:  // that one will redo the "Saved!" flash, so the superseded save leaves the
./js/app.js:11784:  let saveInvocationCounter = 0;
./js/app.js:11786:  let successResetTimer = null; // the 2 s "Saved!" → "Save" reset, cancelled by any newer save or a close
./js/app.js:11791:  // after — never what it writes: the write below carries only this save's
./js/app.js:11794:  const saveBtn = () => modal.querySelector('#summer-lesson-save');
./js/app.js:11796:  const saveLesson = (showStatus = true) => {
./js/app.js:11801:    // A save is starting — a pending autosave would only redo this work
./js/app.js:11808:    const myInvocation = ++saveInvocationCounter;
./js/app.js:11810:    // Grab the form's ELEMENTS now, read their values when the save actually
./js/app.js:11811:    // runs: a queued save carries the newest text, and if the modal is closed
./js/app.js:11828:    // permanently rejected. The chain resolves to the LAST save's outcome.
./js/app.js:11837:    // The curriculum/lessonData listener rebuilds the whole summer cache from
./js/app.js:11838:    // a fresh collection read on every snapshot (any other user's save). If
./js/app.js:11841:    // OLDER one (a read taken before a save that has since landed).
./js/app.js:11847:    // held before THIS save's optimistic mutation, and the object it put
./js/app.js:11856:      // fields that were already saved to Firestore by a previous session.
./js/app.js:11867:      // save are overlaid. An untouched field keeps whatever `lesson` holds —
./js/app.js:11882:      // A field that had text when the modal opened (or last saved) and is
./js/app.js:11885:      // that reaches saveSingleLesson telling it to actually delete the field
./js/app.js:11894:      // only AFTER Firestore confirms the save, and only if it's actually a
./js/app.js:11902:      // Remember exactly which file THIS save is uploading, so the input is
./js/app.js:11916:        // Remove photo — the Storage object is deleted after the save below.
./js/app.js:11923:      const savedLesson = { ...lesson, ...updatedLesson };
./js/app.js:11926:      fieldsToClear.forEach(f => { savedLesson[f] = ''; });
./js/app.js:11927:      // What actually goes to Firestore is only what THIS save changed: the
./js/app.js:11928:      // dirty text fields, the photo fields if this save touched them, and
./js/app.js:11930:      // summer branch of saveSingleLesson() is a set-merge, so everything
./js/app.js:11934:      // modal's copy of it. (The full savedLesson object above is for the
./js/app.js:11939:        // (idempotent), and a doc this save CREATES must carry them — the
./js/app.js:11942:        // SDOC sends none: the save stamps identity from the camp, and
./js/app.js:11960:      optimisticLesson = savedLesson;
./js/app.js:11961:      if (currentLessonData[semKey]) currentLessonData[semKey][lessonKey] = savedLesson;
./js/app.js:11962:      lesson = savedLesson;
./js/app.js:11963:      const result = await saveSingleLesson(semKey, lessonKey, payload, fieldsToClear, sdoc ? { dayOffAuth: dayOffAuthFor(semKey) } : undefined);
./js/app.js:11964:      // saveSingleLesson() stamps lastEditedBy/At onto the object it is given;
./js/app.js:11966:      savedLesson.lastEditedBy = payload.lastEditedBy;
./js/app.js:11967:      savedLesson.lastEditedAt = payload.lastEditedAt;
./js/app.js:11971:        // The SDOC save installed the server's own copy (read back and
./js/app.js:11976:        if (result?.status === 'savedSince') {
./js/app.js:11978:            ? '✓ Saved — this plan was saved again just after, from another window or the Plan complete box; reopen to see the latest.'
./js/app.js:11985:        // under this save with a read taken BEFORE the write landed, the cache
./js/app.js:11986:        // now shows pre-save content — put the confirmed copy back, unless
./js/app.js:11989:        if (semCache && semCache[lessonKey] !== savedLesson && editedAtOf(semCache[lessonKey]) < editedAtOf(savedLesson)) {
./js/app.js:11990:          semCache[lessonKey] = savedLesson;
./js/app.js:11993:      displacedSummerServerCopies.delete(displacedKey(semKey, lessonKey)); // this save is now the confirmed state; nothing parked applies
./js/app.js:11998:      // failed save.
./js/app.js:11999:      if (oldPhotoPath && oldPhotoPath !== (savedLesson.photoPath || null)) {
./js/app.js:12003:          console.error('⚠️ Could not clean up old summer photo after save (Firestore is correct, Storage has an orphan):', cleanupErr);
./js/app.js:12008:      // next autosave (2 s after any typing) doesn't upload the same file
./js/app.js:12009:      // again to yet another path. Only on success: a failed save must keep
./js/app.js:12015:      // New baseline for the next autosave round — compare against what was
./js/app.js:12016:      // just saved, not the state from when the modal first opened.
./js/app.js:12021:      // A newer save is already queued behind this one: it will redo the
./js/app.js:12022:      // status line and the button flash for the state it saves, so leave
./js/app.js:12024:      // to be re-saved.
./js/app.js:12025:      if (myInvocation !== saveInvocationCounter) return true;
./js/app.js:12028:        const btn = saveBtn(); // this modal's button, never a newer modal's
./js/app.js:12045:          // The status line belongs to whichever save is newest. An SDOC
./js/app.js:12046:          // "edited since" note stays until the next save replaces it.
./js/app.js:12047:          if (myInvocation === saveInvocationCounter && !sdocNote) autoSaveStatus.textContent = '';
./js/app.js:12053:      // Put back only what this save changed and still owns (R1-19). The
./js/app.js:12057:      // merge window), that object stays; and after a failed photo save,
./js/app.js:12071:          // while this save was in flight, the retry should build on that,
./js/app.js:12076:        // A reload that landed mid-flight kept THIS save's optimistic entry
./js/app.js:12078:        // that this save has failed, that server copy is the newest
./js/app.js:12079:        // confirmed state — adopt it rather than the pre-save snapshot.
./js/app.js:12091:        // A "Saved!" flash from an earlier save must not leave the button
./js/app.js:12093:        const btn = saveBtn();
./js/app.js:12103:    autoSaveTimer = setTimeout(() => saveLesson(true), 2000); // Auto-save 2 seconds after typing stops
./js/app.js:12106:  // Add auto-save listeners to all textareas
./js/app.js:12120:    // Typing that hasn't autosaved yet (the 2 s debounce is still armed) is
./js/app.js:12121:    // unsaved work — save it now rather than drop it on the floor.
./js/app.js:12125:      saveLesson(true);
./js/app.js:12128:    const chain = summerLessonSaveChains.get(chainKey).then(ok => (ok === false ? 'failed' : 'saved'));
./js/app.js:12130:      if (!explicit) return; // a backdrop click is not a decision to leave without the save
./js/app.js:12132:      // without waiting. Re-render when the save finally settles, and say
./js/app.js:12138:        if (outcome === 'failed') alert('The last save of that lesson plan failed after you closed it — please reopen it and check your work.');
./js/app.js:12142:    // A save still queued or in flight: keep the modal up — frozen, with the
./js/app.js:12144:    // shows what was actually saved and the lesson can't be reopened from a
./js/app.js:12145:    // stale cache in the meantime. If the LAST save fails, stay open with the
./js/app.js:12157:      if (outcome === 'saved') { finishClose(); return; }
./js/app.js:12161:        const btn = saveBtn();
./js/app.js:12173:        const btn = saveBtn();
./js/app.js:12175:        if (late === 'saved') { autoSaveStatus.textContent = '✓ Saved'; autoSaveStatus.style.color = ''; }
./js/app.js:12186:  // Save button - trigger manual save
./js/app.js:12187:  document.getElementById('summer-lesson-save').addEventListener('click', async () => {
./js/app.js:12188:    await saveLesson(true);
./js/app.js:12517:  const year = currentConfig?.semesters?.[yearKey] || {};
./js/app.js:12520:  const writable = lessonDataLoadedSuccessfully !== false;
./js/app.js:12521:  // Planner buttons only for users the rules let save them (Phase 2A);
./js/app.js:12662:      <button class="btn-primary" type="button" id="sdoc-ev-save" onclick="saveDayOffEventFromEditor()">Save event</button>
./js/app.js:12707:async function saveDayOffEventFromEditor() {
./js/app.js:12717:  const btn = document.getElementById('sdoc-ev-save');
./js/app.js:12720:    await saveDayOffEvent(yearKey, input, original);
./js/app.js:12724:    console.error('Could not save the event:', err);
./js/app.js:12759:  const pool = [...new Set([...(currentConfig?.semesters?.[yearKey]?.teacherNames || []), ...(camp.teachers || [])])];
./js/app.js:12794:        : '<span class="settings-hint">This year has no teacher names yet — add them in Settings (you can save the camp without teachers).</span>'}</div>
./js/app.js:12803:      <div class="settings-hint">Fill in what you know — you can save now and add the rest later. Type <strong>—</strong> in a block you won't use.</div>
./js/app.js:12814:      <button class="btn-primary" type="button" id="sdoc-camp-save" onclick="saveDayOffCampFromEditor()">Save camp</button>
./js/app.js:12926:async function saveDayOffCampFromEditor() {
./js/app.js:12931:  const btn = document.getElementById('sdoc-camp-save');
./js/app.js:12934:    const result = await saveDayOffCamp(yearKey, input, original, {
./js/app.js:12937:        + `OK: save the camp — the lists stay saved under the old title (nothing is deleted; adding the title back re-attaches them, or clean them up from this editor).\n`
./js/app.js:12938:        + `Cancel: nothing is saved.\n\n(Renaming a project in the same cells moves its list automatically — this only asks about projects that are going away.)`),
./js/app.js:12940:    if (result?.cancelled) { showDayOffErrors('sdoc-camp-errors', new Error('Not saved — the old title was kept.')); return; }
./js/app.js:12944:    console.error('Could not save the camp:', err);
./js/app.js:13023:// Rendered once per open (and after its own save) into its own container, so
./js/app.js:13048:  const planner = canPlanDayOffCamps() && lessonDataLoadedSuccessfully !== false;
./js/app.js:13069:        <button class="btn-primary" id="sdoc-details-save" onclick="saveDayOffDetailsFromPopup()">Save details</button>
./js/app.js:13100:async function saveDayOffDetailsFromPopup() {
./js/app.js:13108:  // Lock the inputs for the round-trip: a successful save redraws the section
./js/app.js:13115:    const result = await saveDayOffProjectDetails(v.yearKey, v.campId, v.title, {
./js/app.js:13119:    const saved = currentDayOffPlans[v.yearKey]?.[dayOffLessonKey(v.yearKey, v.campId, v.title)] || null;
./js/app.js:13120:    const status = result.status === 'savedSince' ? 'Saved — but someone else changed these details just after; showing their version.'
./js/app.js:13122:      : result.status === 'noop' ? 'Nothing to save.' : 'Saved.';
./js/app.js:13124:    v.plan = saved;
./js/app.js:13125:    renderDayOffDetailsSection(saved, { status });
./js/app.js:13127:    console.error('Details save failed:', err);
./js/app.js:13182:  const planner = canPlanDayOffCamps() && lessonDataLoadedSuccessfully !== false;
./js/app.js:13183:  const ticker = canTickDayOffMaterials() && lessonDataLoadedSuccessfully !== false;
./js/app.js:13198:      <td class="sdoc-actions"><button class="btn-primary" onclick="saveDayOffMaterialRow(this)">${it ? 'Save' : 'Add'}</button>${it ? '<button class="btn-text" onclick="cancelDayOffMaterialEdit(this)">Cancel</button>' : ''}</td>
./js/app.js:13245:function saveDayOffMaterialRow(btn) {
./js/app.js:13256:    await saveDayOffMaterialItem(v.yearKey, v.campId, v.title, id, input);
./js/app.js:13273:// Ticks save independently — a second tick while the first is saving must
./js/app.js:13409:  const ticker = canTickDayOffMaterials() && lessonDataLoadedSuccessfully !== false;
./e2e/teacher-mapping.spec.js:33:    const savedMappings = currentConfig.teacherMappings;
./e2e/teacher-mapping.spec.js:37:    currentConfig.teacherMappings = { 'u-archived-mapped': 'Teacher A', 'u-deleted': 'Teacher B' };
./e2e/teacher-mapping.spec.js:49:      currentConfig.teacherMappings = savedMappings;
./user-admin.html:274:        <form id="editForm" onsubmit="saveUser(event)">
./user-admin.html:554:    async function saveUser(event) {
./index.html:503:          <button class="btn-primary" onclick="saveSettings()">Save Settings</button>
./index.html:546:          <p>Click the <strong>Edit</strong> button on any lesson card to update your lesson plan. Changes save automatically to the cloud.</p>
./index.html:556:          <p style="margin-top: 8px;"><strong>Tip:</strong> Use <strong>Cmd+S</strong> (Mac) or <strong>Ctrl+S</strong> (Windows) to save quickly.</p>
./e2e/helpers/sdoc.js:34:    return el && el.children.length > 0 && !el.children[0].textContent.includes('Loading') && lessonDataLoadedSuccessfully === true;
./e2e/helpers/sdoc.js:43:    currentConfig.semesters[Y] = {
./e2e/helpers/sdoc.js:48:    const COLLS = ['dayOffCamps_events', 'dayOffCamps_camps', 'dayOffCamps_lessonData'];
./e2e/helpers/sdoc.js:86:        // Transaction writes too (Phase 2A: camp saves and material writes run in transactions).
./e2e/helpers/sdoc.js:117:  const r = await attempt(page, ({ Y, input }) => saveDayOffEvent(Y, { label: 'TEST Thanksgiving Break', dates: ['2026-11-23', '2026-11-24', '2026-11-25'], district: 'BVSD', notes: '', ...input }), { Y, input });
./e2e/helpers/sdoc.js:124:  const r = await attempt(page, ({ Y, camp }) => saveDayOffCamp(Y, camp, null), { Y, camp });
./e2e/README.md:53:   context starts from that saved session.
./e2e/README.md:108:  .auth/                   (gitignored) saved browser session
./css/styles.css:909:.saved-indicator {
./css/styles.css:928:.saved-indicator.show {
./css/styles.css:4463:.save-new-mat-btn,
./css/styles.css:4475:.save-new-mat-btn {
./css/styles.css:4480:.save-new-mat-btn:hover {
./css/styles.css:4827:.diag-note-save {
./css/styles.css:4839:.diag-note-save:hover {
./css/styles.css:5083:.auto-save-status {
./css/styles.css:5094:.te-save-btn {
./css/styles.css:5107:.te-save-btn:hover { background: #5E2D5E; }
./css/styles.css:5108:.te-save-btn:disabled { opacity: 0.5; cursor: not-allowed; }
./css/styles.css:5125:.te-saved-msg {
./css/styles.css:6147:  .saved-indicator,
./js/firebase-data.js:7://   curriculum/lessonData  — all lesson content by semester (imported from classbooks)
./js/firebase-data.js:8://   curriculum/cutProjects — projects removed from schedule, saved for reuse
./js/firebase-data.js:14:let lessonDataUnsubscribe = null;
./js/firebase-data.js:40:// whole-document saveConfig() could strip the field. It is the only place
./js/firebase-data.js:46:  const stored = currentConfig?.semesters?.[semKey]?.semesterType;
./js/firebase-data.js:56:// lesson in summerCamps_lessonData) or 'weekly' (one nested map inside the
./js/firebase-data.js:57:// shared curriculum/lessonData document). The seven sites that choose between
./js/firebase-data.js:110:// weekly semester whose key happens to start with `summer-` fails its save
./js/firebase-data.js:114:  const stored = currentConfig?.semesters?.[semKey]?.season;
./js/firebase-data.js:125:let currentConfig = null;
./js/firebase-data.js:128:let lessonDataLoadedSuccessfully = null; // null = not yet loaded, true = ok, false = failed
./js/firebase-data.js:150:// banner and every writer refuses — see loadConfig().
./js/firebase-data.js:155:// and the old whole-document saveConfig() would then write those defaults over
./js/firebase-data.js:156:// the real thing on the next save. That is the May 2026 failure mode named in
./js/firebase-data.js:164://                                   lessonDataLoadedSuccessfully = false makes
./js/firebase-data.js:168:async function loadConfig() {
./js/firebase-data.js:173:    currentConfig = doc.exists ? doc.data() : getDefaultConfig();
./js/firebase-data.js:177:    lessonDataLoadedSuccessfully = false;
./js/firebase-data.js:178:    currentConfig = null;
./js/firebase-data.js:181:  return currentConfig;
./js/firebase-data.js:249:// Which appData paths a Settings save may write, by the semester's TYPE. A
./js/firebase-data.js:252:// Phase 1 a Settings save spread the whole form over the semester and could
./js/firebase-data.js:256:  const type = (semesters || currentConfig?.semesters)?.[semKey]?.semesterType
./js/firebase-data.js:339:  // lessonDataLoadedSuccessfully = true and re-hide the banner this mode just
./js/firebase-data.js:345:    lessonDataLoadedSuccessfully = false;
./js/firebase-data.js:352:// onSnapshot never errors when offline and, with cache-only snapshots skipped,
./js/firebase-data.js:461:    currentSeasonDocRef().onSnapshot({ includeMetadataChanges: true }, next, error));
./js/firebase-data.js:525:    .onSnapshot(doc => {
./js/firebase-data.js:527:        currentConfig = doc.data();
./js/firebase-data.js:528:        if (callback) callback(currentConfig);
./js/firebase-data.js:551:async function savePrepWeekData(semesterKey, weekKey, weekData) {
./js/firebase-data.js:575:async function saveForecastDismissals(semesterKey, dismissals) {
./js/firebase-data.js:601:    .onSnapshot(doc => {
./js/firebase-data.js:719:async function savePrepCycleConfig(config) {
./js/firebase-data.js:730:// ─── Lesson Data (curriculum/lessonData) ─────────────
./js/firebase-data.js:737:  return Object.keys(currentConfig?.semesters || {}).filter(isDayOffYear);
./js/firebase-data.js:741:  const semesters = currentConfig?.semesters || {};
./js/firebase-data.js:762:    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
./js/firebase-data.js:779:      lessonDataLoadedSuccessfully = true;
./js/firebase-data.js:784:      lessonDataLoadedSuccessfully = false;
./js/firebase-data.js:789:    lessonDataLoadedSuccessfully = false;
./js/firebase-data.js:796:// saveSingleLesson(): after a failed load, `lessons` is built from an empty or
./js/firebase-data.js:802:async function saveLessonData(semesterKey, lessons) {
./js/firebase-data.js:803:  if (lessonDataLoadedSuccessfully === false) {
./js/firebase-data.js:804:    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
./js/firebase-data.js:812:    return await saveSummerCampLessonData(semesterKey, lessons);
./js/firebase-data.js:815:  // Regular semester: save to curriculum/lessonData
./js/firebase-data.js:817:  await curriculumDb.collection('curriculum').doc('lessonData').set({
./js/firebase-data.js:830:  await curriculumDb.collection('curriculum').doc('lessonData').update({
./js/firebase-data.js:837:async function saveSummerCampLessonData(semKey, lessons) {
./js/firebase-data.js:851:  for (const [lessonKey, lessonData] of Object.entries(lessons)) {
./js/firebase-data.js:853:    if (!hasContent(lessonData)) continue;
./js/firebase-data.js:854:    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
./js/firebase-data.js:856:    // real content that a teacher saved in a different browser session.
./js/firebase-data.js:857:    const stripped = { ...lessonData };
./js/firebase-data.js:891:// Same load guard as the lesson writers (saveLessonData/saveSingleLesson):
./js/firebase-data.js:894:async function saveCampComplete(semKey, teacher, campName, campComplete) {
./js/firebase-data.js:895:  if (lessonDataLoadedSuccessfully === false) {
./js/firebase-data.js:896:    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
./js/firebase-data.js:925:  if (lessonDataLoadedSuccessfully === false) {
./js/firebase-data.js:963:  await curriculumDb.collection('curriculum').doc('lessonData').update({
./js/firebase-data.js:968:// Forced-server read of one semester's whole lesson map in curriculum/lessonData
./js/firebase-data.js:975:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
./js/firebase-data.js:985:  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
./js/firebase-data.js:995:  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
./js/firebase-data.js:1000:  await saveLessonData(semesterKey, lessons);
./js/firebase-data.js:1012:// The fields a saved summerCamps_lessonData doc contributes to a lesson slot
./js/firebase-data.js:1017:// A reload's read can only plausibly predate a save this recent; a stamp
./js/firebase-data.js:1022:// parked here so the summer editor can fall back to it if the in-flight save
./js/firebase-data.js:1032:// read can predate a save that has since landed (or is in flight,
./js/firebase-data.js:1034:// lessons exist and for every scaffold-derived field; for the saved-doc
./js/firebase-data.js:1038:// protectedKeys (SDOC, Phase 2B): lessons whose fresh copy is a VERIFIED save
./js/firebase-data.js:1061:      const saved = {};
./js/firebase-data.js:1062:      SUMMER_SAVED_FIELDS.forEach(f => { if (f in mine) saved[f] = mine[f]; });
./js/firebase-data.js:1064:      // `mine` becomes exactly "fresh scaffold + my saved fields" — anything
./js/firebase-data.js:1067:      for (const f of Object.keys(mine)) { if (!(f in fresh[key]) && !(f in saved)) delete mine[f]; }
./js/firebase-data.js:1068:      Object.assign(mine, fresh[key], saved);
./js/firebase-data.js:1078:// shared curriculum/lessonData doc re-runs the summer collection reload.
./js/firebase-data.js:1090:// and an in-flight save's optimistic entry had no map to live in), and the
./js/firebase-data.js:1116:  if (lessonDataUnsubscribe) lessonDataUnsubscribe();
./js/firebase-data.js:1143:      lessonDataLoadedSuccessfully = true;
./js/firebase-data.js:1149:      lessonDataLoadedSuccessfully = false;
./js/firebase-data.js:1171:  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
./js/firebase-data.js:1172:    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
./js/firebase-data.js:1182:      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
./js/firebase-data.js:1212:async function saveCutProjects(semesterKey, projects) {
./js/firebase-data.js:1236:async function saveFutureProjects(projects) {
./js/firebase-data.js:1302:async function saveDiagDismissals(dismissals) {
./js/firebase-data.js:1310:    // saved OK
./js/firebase-data.js:1312:    console.error('FAILED to save diagnostic dismissals:', err);
./js/firebase-data.js:1319:// Data Safety Plan Stage 2E: confirms a summer save's content fields actually
./js/firebase-data.js:1335:      console.warn('⚠️ Save verification retry also failed — could not confirm save:', err2);
./js/firebase-data.js:1336:      throw new Error("Couldn't confirm your save — check your connection and reload to verify your work saved.");
./js/firebase-data.js:1340:  const saved = snap.exists ? snap.data() : {};
./js/firebase-data.js:1341:  const failedFields = writtenContentFields.filter(f => !saved[f] || !String(saved[f]).trim());
./js/firebase-data.js:1361:// authoritative: it overrides whatever (possibly stale) value lessonData
./js/firebase-data.js:1363:// value alongside a separate clear signal (see saveLesson()'s contentUpdates).
./js/firebase-data.js:1364:async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
./js/firebase-data.js:1365:  if (lessonDataLoadedSuccessfully === false) {
./js/firebase-data.js:1366:    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
./js/firebase-data.js:1370:  lessonData.lastEditedBy = user?.name || 'Unknown';
./js/firebase-data.js:1371:  lessonData.lastEditedAt = new Date().toISOString();
./js/firebase-data.js:1376:  // callers fall through to curriculum/lessonData on anything that isn't
./js/firebase-data.js:1378:  if (isDayOffYear(semesterKey)) return saveDayOffPlan(semesterKey, lessonKey, lessonData, fieldsToClear, opts.dayOffAuth);
./js/firebase-data.js:1380:  console.log('💾 Attempting to save lesson:', { semesterKey, lessonKey, user: user?.email });
./js/firebase-data.js:1382:  const hasContent = lessonHasContent(lessonData);
./js/firebase-data.js:1388:    // A planComplete-only payload, a photo-only payload, or a save that's only
./js/firebase-data.js:1389:    // clearing a field, is a legitimate narrow save, not a stale-state wipe
./js/firebase-data.js:1395:    const hasPhotoField = 'photoUrl' in lessonData || 'photoPath' in lessonData;
./js/firebase-data.js:1396:    if (!hasContent && !hasPhotoField && !('planComplete' in lessonData) && fieldsToActuallyClear.length === 0) {
./js/firebase-data.js:1397:      console.warn('⛔ saveSingleLesson blocked — all content fields empty, refusing to overwrite:', lessonKey);
./js/firebase-data.js:1401:    // real content that a teacher saved previously (mirrors saveSummerCampLessonData).
./js/firebase-data.js:1402:    const stripped = { ...lessonData };
./js/firebase-data.js:1412:    console.log('💾 Saving Summer Camp lesson to summerCamps_lessonData:', lessonKey);
./js/firebase-data.js:1413:    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semesterKey, lessonKey));
./js/firebase-data.js:1429:  // Regular semester: curriculum/lessonData is one shared doc across every
./js/firebase-data.js:1433:  // actually present in lessonData (Data Safety Plan Stage 2D).
./js/firebase-data.js:1434:  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear);
./js/firebase-data.js:1436:  console.log('💾 Saving to curriculum/lessonData with per-field paths:', Object.keys(updates));
./js/firebase-data.js:1438:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
./js/firebase-data.js:1439:    console.log('✅ Successfully saved lesson to Firestore!');
./js/firebase-data.js:1447:// object for ONE lesson within the shared curriculum/lessonData document,
./js/firebase-data.js:1448:// given an already-finalized lessonData object. Extracted from
./js/firebase-data.js:1449:// saveSingleLesson()'s non-summer branch above so it can be reused by
./js/firebase-data.js:1450:// saveMultipleLessonFields() below without duplicating the stripping/clearing
./js/firebase-data.js:1455:function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = []) {
./js/firebase-data.js:1456:  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above saveSingleLesson().
./js/firebase-data.js:1457:  const stripped = { ...lessonData };
./js/firebase-data.js:1472:// vulnerable to (does NOT independently verify the given lessonData reflects
./js/firebase-data.js:1475:async function saveMultipleLessonFields(semesterKey, writes = [], deletes = []) {
./js/firebase-data.js:1476:  if (lessonDataLoadedSuccessfully === false) {
./js/firebase-data.js:1477:    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
./js/firebase-data.js:1485:    throw new Error('saveMultipleLessonFields() does not support camp seasons — use saveSingleLesson() per lesson instead.');
./js/firebase-data.js:1490:  for (const { lessonKey, lessonData, fieldsToClear } of writes) {
./js/firebase-data.js:1491:    lessonData.lastEditedBy = user?.name || 'Unknown';
./js/firebase-data.js:1492:    lessonData.lastEditedAt = new Date().toISOString();
./js/firebase-data.js:1493:    Object.assign(combined, buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear || []));
./js/firebase-data.js:1500:  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
./js/firebase-data.js:1517:// the save (a failed save then pointed at a photo that no longer existed),
./js/firebase-data.js:1521:// save, then delete it only after a confirmed save (see saveTeacherEdit(),
./js/firebase-data.js:1522:// saveAdminEdit(), and the summer modal's saveLesson()). Date.now() alone is
./js/firebase-data.js:1551:  // Same load guard as the summer lesson save this upload precedes — refuse
./js/firebase-data.js:1552:  // before an object lands in Storage that the (refused) save would then
./js/firebase-data.js:1554:  if (lessonDataLoadedSuccessfully === false) {
./js/firebase-data.js:1555:    throw new Error('Lesson data failed to load — refusing to upload a photo for a save that would be refused. Reload and try again.');
./js/firebase-data.js:1577:  if (lessonDataLoadedSuccessfully === false) {
./js/firebase-data.js:1578:    throw new Error('Lesson data failed to load — refusing to upload a photo for a save that would be refused. Reload and try again.');
./js/firebase-data.js:1651:  // Every successful summer load sets lessonDataLoadedSuccessfully = true and
./js/firebase-data.js:1814:    // 6. Load saved lesson plans from summerCamps_lessonData
./js/firebase-data.js:1816:      console.log('📖 Loading saved Summer Camp lesson plans...');
./js/firebase-data.js:1817:      const savedLessonsSnap = await scoped('summerCamps_lessonData').get();
./js/firebase-data.js:1821:      savedLessonsSnap.forEach(doc => {
./js/firebase-data.js:1828:        const savedData = doc.data();
./js/firebase-data.js:1832:          // Merge saved lesson plan fields (introPitch, processSteps, closure, dayOfMaterials, photo)
./js/firebase-data.js:1835:            introPitch: savedData.introPitch || lessons[lessonKey].introPitch,
./js/firebase-data.js:1836:            processStep1: savedData.processStep1 || lessons[lessonKey].processStep1,
./js/firebase-data.js:1837:            processStep2: savedData.processStep2 || lessons[lessonKey].processStep2,
./js/firebase-data.js:1838:            processStep3: savedData.processStep3 || lessons[lessonKey].processStep3,
./js/firebase-data.js:1839:            processStep4: savedData.processStep4 || lessons[lessonKey].processStep4,
./js/firebase-data.js:1840:            closure: savedData.closure || lessons[lessonKey].closure,
./js/firebase-data.js:1841:            dayOfMaterials: savedData.dayOfMaterials || lessons[lessonKey].dayOfMaterials,
./js/firebase-data.js:1842:            photoUrl: savedData.photoUrl || lessons[lessonKey].photoUrl || '',
./js/firebase-data.js:1843:            photoPath: savedData.photoPath || lessons[lessonKey].photoPath || '',
./js/firebase-data.js:1844:            planComplete: savedData.planComplete === true,
./js/firebase-data.js:1845:            lastEditedBy: savedData.lastEditedBy || '',
./js/firebase-data.js:1846:            lastEditedAt: savedData.lastEditedAt || ''
./js/firebase-data.js:1852:      console.log(`✅ Merged ${mergedCount} saved lesson plans`);
./js/firebase-data.js:1854:      if (skippedForeignSeason > 0) console.warn(`⚠️ Skipped ${skippedForeignSeason} summerCamps_lessonData document(s) stamped for another season.`);
./js/firebase-data.js:1856:      console.warn('⚠️  Could not load saved Summer Camp lesson plans:', err);
./js/firebase-data.js:1857:      // Rethrow — lesson content would be blank, saves would wipe real teacher data
./js/firebase-data.js:1876:// every one carrying `yearKey`. Nothing here touches curriculum/lessonData or
./js/firebase-data.js:1878:const DAY_OFF_COLLECTIONS = { events: 'dayOffCamps_events', camps: 'dayOffCamps_camps', plans: 'dayOffCamps_lessonData' };
./js/firebase-data.js:1899:// too, so a camp saved before the grid landed still reads correctly.
./js/firebase-data.js:1930:// Materials live on the project's plan record (dayOffCamps_lessonData) as
./js/firebase-data.js:1986:  if (lessonDataLoadedSuccessfully === false) {
./js/firebase-data.js:1987:    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
./js/firebase-data.js:2072:// from the event + camp, saved fields from the plan doc (Phase 2 writes them).
./js/firebase-data.js:2123:  // what they return (Phase 2B — a reload must not undo a verified save).
./js/firebase-data.js:2303:  const year = currentConfig?.semesters?.[yearKey];
./js/firebase-data.js:2318:// ({ id, ...doc }) for an edit, null for a create. Returns the saved event.
./js/firebase-data.js:2319:async function saveDayOffEvent(yearKey, input, original = null) {
./js/firebase-data.js:2338:    const saved = { id: ref.id, ...back.data() };
./js/firebase-data.js:2339:    currentDayOffEvents[yearKey] = sortDayOffEvents([...(currentDayOffEvents[yearKey] || []), saved]);
./js/firebase-data.js:2341:    return saved;
./js/firebase-data.js:2361:  const saved = { id: original.id, ...back.data() };
./js/firebase-data.js:2362:  currentDayOffEvents[yearKey] = sortDayOffEvents((currentDayOffEvents[yearKey] || []).map(e => e.id === saved.id ? saved : e));
./js/firebase-data.js:2364:  return saved;
./js/firebase-data.js:2391:async function saveDayOffCamp(yearKey, input, original = null, { confirmOrphans = async () => false } = {}) {
./js/firebase-data.js:2400:  // list can lack a name another admin added (or carry an unsaved × edit).
./js/firebase-data.js:2418:    const saved = { id: ref.id, ...back.data() };
./js/firebase-data.js:2419:    currentDayOffCamps[yearKey] = [...(currentDayOffCamps[yearKey] || []), saved];
./js/firebase-data.js:2421:    return saved;
./js/firebase-data.js:2459:    // Stale-editor guard: a whole field this save replaces must still be what
./js/firebase-data.js:2490:  const saved = { id: original.id, ...back.data() };
./js/firebase-data.js:2491:  currentDayOffCamps[yearKey] = (currentDayOffCamps[yearKey] || []).map(c => c.id === saved.id ? saved : c);
./js/firebase-data.js:2501:  return saved;
./js/firebase-data.js:2573:// A teacher's plan is the camp-project's record in dayOffCamps_lessonData (the
./js/firebase-data.js:2575:// write any field there, so these allow-lists are what keep a plan save off
./js/firebase-data.js:2603:// A server copy of a plan this tab has verified (opened fresh, or saved and
./js/firebase-data.js:2605:// rebuilt — no reload scheduled (a teacher's autosaves must not each cost
./js/firebase-data.js:2615:// slot map (a reload can briefly swap currentLessonData out from under a save).
./js/firebase-data.js:2626:// a co-teacher may have saved since this page loaded).
./js/firebase-data.js:2638:// saveSingleLesson()'s SDOC branch. Returns { status, doc, by, own }:
./js/firebase-data.js:2639://   'saved'      — my write is what the server holds;
./js/firebase-data.js:2640://   'savedSince' — my write landed, then someone saved over it (last write
./js/firebase-data.js:2646:async function saveDayOffPlan(yearKey, lessonKey, lessonData, fieldsToClear = [], auth) {
./js/firebase-data.js:2648:  if (!auth || typeof auth !== 'object') throw new Error('An SDOC plan save needs dayOffAuth — refusing to save without the permission check.');
./js/firebase-data.js:2652:  if (lessonKey !== dayOffLessonKey(yearKey, campId, projectTitle)) throw new Error('This plan key does not match its camp and project — refusing to save.');
./js/firebase-data.js:2653:  if (isDayOffNoPlanTitle(projectTitle) || projectTitle === DAY_OFF_SIGNOFF_TITLE) throw new Error(`"${projectTitle}" has no plan — refusing to save.`);
./js/firebase-data.js:2655:  const extra = Object.keys(lessonData).filter(k => !DAY_OFF_PLAN_WRITABLE.includes(k));
./js/firebase-data.js:2656:  if (extra.length) throw new Error(`An SDOC plan save may not write ${extra.join(', ')} — refused.`);
./js/firebase-data.js:2658:  if (badClears.length) throw new Error(`An SDOC plan save may not clear ${badClears.join(', ')} — refused.`);
./js/firebase-data.js:2659:  if (!lessonData.lastEditedBy || !lessonData.lastEditedAt) throw new Error('An SDOC plan save must carry its edit stamp — refused.');
./js/firebase-data.js:2661:  const payload = { ...lessonData };
./js/firebase-data.js:2719:  if (server.lastEditId === editId) return { status: 'saved', doc: server };
./js/firebase-data.js:2720:  return { status: 'savedSince', doc: server, by: server.lastEditedBy || 'someone', own: server.lastEditedBy === lessonData.lastEditedBy };
./js/firebase-data.js:2724:// still carries MY save id, every written value and every clear must be as I
./js/firebase-data.js:2726:// saved after me, and any difference is their save winning. Returns the
./js/firebase-data.js:2735:      throw new Error("Couldn't confirm your save — check your connection and reload to verify your work saved.");
./js/firebase-data.js:2739:  const saved = snap.data();
./js/firebase-data.js:2740:  const wrongIdentity = Object.entries(identity || {}).filter(([f, v]) => saved[f] !== v).map(([f]) => f);
./js/firebase-data.js:2742:  if (saved[idField] !== editId) return saved;
./js/firebase-data.js:2744:    ...Object.entries(written).filter(([f, v]) => JSON.stringify(saved[f]) !== JSON.stringify(v)).map(([f]) => f),
./js/firebase-data.js:2745:    ...cleared.filter(f => f in saved),
./js/firebase-data.js:2751:  console.log('✅ SDOC plan save verified on server:', Object.keys(written));
./js/firebase-data.js:2752:  return saved;
./js/firebase-data.js:2789:// Planner: save a project's details. `expected` is the popup's baseline (its
./js/firebase-data.js:2790:// open read, or its own last verified save) — the save refuses if the record
./js/firebase-data.js:2792:// 'saved' | 'savedSince' (another planner saved just after) | 'renamed' | 'noop'.
./js/firebase-data.js:2793:async function saveDayOffProjectDetails(yearKey, campId, title, { details, links, expected, auth } = {}) {
./js/firebase-data.js:2796:  if (!expected || typeof expected.details !== 'string' || !Array.isArray(expected.links)) throw new Error('Project details save needs the values it started from — refused.');
./js/firebase-data.js:2844:  return { status: server.detailsEditId === editId ? 'saved' : 'savedSince', doc: server };
./js/firebase-data.js:2897:async function saveDayOffMaterialItem(yearKey, campId, title, itemId, input) {
./js/firebase-data.js:3059:  const saved = await refreshDayOffSignoff(yearKey, campId);
./js/firebase-data.js:3061:  return saved;
./js/firebase-data.js:3112:  if (!currentConfig) return null;
./js/firebase-data.js:3114:  return currentConfig.semesters?.[key] || null;
./js/firebase-data.js:3119:  if (globalSemesterKey && currentConfig?.semesters?.[globalSemesterKey]) {
./js/firebase-data.js:3122:  return currentConfig?.activeSemester || 'spring-2026';
./AGENTS.md:4:- `updateDoc` for partial updates; `setDoc` only for intentional full overwrites
./AGENTS.md:12:`loadConfig()` silently returns defaults when a Firestore permission error occurs. Before diagnosing any "missing data" bug, verify rules are intact. A data-loss incident in May 2026 was caused by this exact pattern. See CLASSBOOK-DATA-SAFETY-PLAN.md.
./e2e/helpers/firestore.js:27:const { getFirestore, connectFirestoreEmulator, doc, getDocFromServer, setDoc, updateDoc, deleteDoc, deleteField, arrayUnion } = require('firebase/firestore');
./e2e/helpers/firestore.js:85:// ─── Summer shape: summerCamps_lessonData/{lessonKey} (one document per lesson) ───
./e2e/helpers/firestore.js:101:  await setDoc(doc(db, 'summerCamps_lessonData', docId), { season: seasonOfTestDocId(docId), ...fields }, { merge: true });
./e2e/helpers/firestore.js:110:  const snap = await getDocFromServer(doc(db, 'summerCamps_lessonData', docId));
./e2e/helpers/firestore.js:117:  await deleteDoc(doc(db, 'summerCamps_lessonData', docId));
./e2e/helpers/firestore.js:145:  await setDoc(doc(db, 'summerCamps_campComplete', docId), { season: seasonOfTestDocId(docId), ...fields }, { merge: true });
./e2e/helpers/firestore.js:161:  await setDoc(doc(db, 'summerCamps_prepHelpQueue', docId), { season: seasonOfTestDocId(docId), ...fields }, { merge: true });
./e2e/helpers/firestore.js:164:// ─── Non-summer shape: curriculum/lessonData, one shared doc nested as
./e2e/helpers/firestore.js:168:// never setDoc()/deleteDoc() it wholesale. Every helper below touches only
./e2e/helpers/firestore.js:179:const LESSON_DOC = (db) => doc(db, 'curriculum', 'lessonData');
./e2e/helpers/firestore.js:182:// state. Mirrors js/firebase-data.js's saveSingleLesson() whole-object-replace
./e2e/helpers/firestore.js:189:  await updateDoc(LESSON_DOC(db), { [`${semesterKey}.${lessonKey}`]: fields });
./e2e/helpers/firestore.js:194:// saveSingleLesson()'s whole-object replace — that pattern is the production
./e2e/helpers/firestore.js:205:  await updateDoc(LESSON_DOC(db), updates);
./e2e/helpers/firestore.js:222:  await updateDoc(LESSON_DOC(db), updates);
./e2e/helpers/firestore.js:226:// deleteLessonKey(). Never deletes the shared lessonData document itself.
./e2e/helpers/firestore.js:232:  await updateDoc(LESSON_DOC(db), { [`${semesterKey}.${lessonKey}`]: deleteField() });
./e2e/helpers/firestore.js:243:// Cleanup — removes an entire TEST semester key from curriculum/lessonData.
./e2e/helpers/firestore.js:254:  await updateDoc(LESSON_DOC(db), { [semesterKey]: deleteField() });
./e2e/helpers/firestore.js:260:// setDoc()/deleteDoc() this wholesale; it's shared across every semester.
./e2e/helpers/firestore.js:276:  await setDoc(CUT_PROJECTS_DOC(db), { [semesterKey]: arrayUnion(entry) }, { merge: true });
./e2e/helpers/firestore.js:282:  await updateDoc(CUT_PROJECTS_DOC(db), { [semesterKey]: deleteField() });
./e2e/helpers/login.js:29:// A second saved session for the seeded MANAGER (e2e-manager-uid). Specs that
./e2e/global-setup.js:65:    console.log(`[global-setup] signed in once; session saved to ${AUTH_STATE_PATH}`);
./e2e/global-setup.js:70:    console.log(`[global-setup] manager session saved to ${MANAGER_STATE_PATH}`);
./e2e/linkify-xss.spec.js:119:    await page.waitForSelector('#summer-lesson-save', { state: 'visible', timeout: 8_000 });
./e2e/linkify-xss.spec.js:191:    // SDOC Phase 2C's save validator / renderer gate is the same gate, plus
./e2e/static-checks.spec.js:122:    // saveConfig() was the one that could strip fields a stale tab had never
./e2e/static-checks.spec.js:130:        if (/\bsaveConfig\s*\(/.test(code)) offenders.push(`${rel}:${i + 1}: ${line.trim()}`);
./e2e/day-off-teacher.spec.js:11: * The TEST year lives only in each page's currentConfig (never in appData);
./e2e/day-off-teacher.spec.js:26:  await planner.evaluate(({ Y, POOL }) => { currentConfig.semesters[Y].teacherNames = POOL; }, { Y, POOL });
./e2e/day-off-teacher.spec.js:29:  await prep.evaluate(({ Y, POOL }) => { currentConfig.semesters[Y].teacherNames = POOL; currentConfig.semesters[Y].published = true; }, { Y, POOL });
./e2e/day-off-teacher.spec.js:45:  const save = async (camp) => {
./e2e/day-off-teacher.spec.js:46:    const r = await attempt(planner, ({ Y, camp }) => saveDayOffCamp(Y, camp, null), { Y, camp });
./e2e/day-off-teacher.spec.js:50:  const clay = await save({
./e2e/day-off-teacher.spec.js:61:  const paint = await save({
./e2e/day-off-teacher.spec.js:71:  page.evaluate(({ Y, id, title }) => __sdocT.read('lessonData', dayOffPlanDocId(Y, id, title)), { Y, id: camp.id, title });
./e2e/day-off-teacher.spec.js:73:  attempt(planner, ({ Y, id, title, item }) => saveDayOffMaterialItem(Y, id, title, null, item), { Y, id: camp.id, title, item });
./e2e/day-off-teacher.spec.js:86:  await p.waitForFunction(() => typeof lessonDataLoadedSuccessfully !== 'undefined' && lessonDataLoadedSuccessfully === true && !!currentLessonData, null, { timeout: 25_000 });
./e2e/day-off-teacher.spec.js:88:    currentConfig.semesters[Y] = {
./e2e/day-off-teacher.spec.js:123:  await page.click('#summer-lesson-save');
./e2e/day-off-teacher.spec.js:124:  await expect(page.locator('#summer-autosave-status')).toContainText(/Saved/);
./e2e/day-off-teacher.spec.js:156:  test('T2: the teacher saves through the real editor — her text + identity + a save id land; materials and the other camp\'s plan are untouched', async ({ browser }) => {
./e2e/day-off-teacher.spec.js:180:  test('T3: the editor opens from a fresh server read — a co-teacher\'s save made after the page loaded is there; prep (Kathy/Allie) can open and edit too', async ({ browser }) => {
./e2e/day-off-teacher.spec.js:184:    // "TESTteacher2" saves after Fixture Teacher's page loaded (direct write = another client).
./e2e/day-off-teacher.spec.js:185:    await planner.evaluate(({ Y, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'Clay Creatures'))
./e2e/day-off-teacher.spec.js:186:      .set({ yearKey: Y, campId: id, projectTitle: 'Clay Creatures', closure: 'TEST closure by co-teacher', lastEditedBy: 'TESTteacher2', lastEditedAt: new Date().toISOString(), lastEditId: 'eothersave00001' }, { merge: true }), { Y, id: clay.id });
./e2e/day-off-teacher.spec.js:206:        delete (currentConfig.teacherMappings || {})[real().uid];
./e2e/day-off-teacher.spec.js:212:        currentConfig.semesters[Y].teacherNames = ['Alex Smith', 'Alex Jones', ...currentConfig.semesters[Y].teacherNames];
./e2e/day-off-teacher.spec.js:216:        currentConfig.teacherMappings = { ...(currentConfig.teacherMappings || {}), [real().uid]: 'Somebody Gone' };
./e2e/day-off-teacher.spec.js:220:      } finally { window.getAuthUser = real; delete currentConfig.teacherMappings[real().uid]; }
./e2e/day-off-teacher.spec.js:228:  test('T5: co-teachers editing different fields both survive; a later save over mine reads "edited since", never a failure — for a written field and for a clear', async ({ browser }) => {
./e2e/day-off-teacher.spec.js:233:    let r = await attempt(t, ({ Y, K, auth }) => saveSingleLesson(Y, K, { introPitch: 'TEST mine', closure: 'TEST closure' }, [], { dayOffAuth: auth }), { Y, K, auth });
./e2e/day-off-teacher.spec.js:235:    expect(r.value.status).toBe('saved');
./e2e/day-off-teacher.spec.js:236:    // Another teacher saves a different field — both present.
./e2e/day-off-teacher.spec.js:237:    await planner.evaluate(({ Y, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'Clay Creatures'))
./e2e/day-off-teacher.spec.js:238:      .update({ processStep1: 'TEST step by co-teacher', lastEditedBy: 'TESTteacher2', lastEditedAt: new Date().toISOString(), lastEditId: 'eothersave00002' }), { Y, id: clay.id });
./e2e/day-off-teacher.spec.js:241:    // Inject "TESTteacher2 saves right after my commit, before my read-back".
./e2e/day-off-teacher.spec.js:248:        await curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, campId, title)).update(coWrite);
./e2e/day-off-teacher.spec.js:251:      try { return { ok: true, value: await saveSingleLesson(Y, K, payload, clears, { dayOffAuth: auth }) }; }
./e2e/day-off-teacher.spec.js:255:    const co = (fields) => ({ ...fields, lastEditedBy: 'TESTteacher2', lastEditedAt: new Date().toISOString(), lastEditId: 'eothersave00003' });
./e2e/day-off-teacher.spec.js:259:    expect(r.value.status).toBe('savedSince');
./e2e/day-off-teacher.spec.js:265:    expect(r.value.status).toBe('savedSince');
./e2e/day-off-teacher.spec.js:270:    r = await racedSave({ closure: 'TEST x' }, [], { closure: 'TEST y', lastEditedBy: me, lastEditedAt: new Date().toISOString(), lastEditId: 'eothersave00004' });
./e2e/day-off-teacher.spec.js:271:    expect(r.value.status).toBe('savedSince');
./e2e/day-off-teacher.spec.js:274:    // Same user, same millisecond (identical lastEditedBy AND lastEditedAt) — still told apart by the save id.
./e2e/day-off-teacher.spec.js:281:        const ref = curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, campId, title));
./e2e/day-off-teacher.spec.js:283:        await ref.update({ closure: 'TEST same-ms other save', lastEditedBy: mine.lastEditedBy, lastEditedAt: mine.lastEditedAt, lastEditId: 'eothersave00009' });
./e2e/day-off-teacher.spec.js:286:      try { return { ok: true, value: await saveSingleLesson(Y, K, { closure: 'TEST first' }, [], { dayOffAuth: auth }) }; }
./e2e/day-off-teacher.spec.js:291:    expect(r.value.status).toBe('savedSince');
./e2e/day-off-teacher.spec.js:293:    // Photo removal racing a co-teacher's replacement: the later save wins, reported as such.
./e2e/day-off-teacher.spec.js:294:    await planner.evaluate(({ Y, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'Clay Creatures'))
./e2e/day-off-teacher.spec.js:299:    expect(r.value.status).toBe('savedSince');
./e2e/day-off-teacher.spec.js:311:        await curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId('TEST_DATA_SAFETY_sdoc', id, 'Clay Creatures'))
./e2e/day-off-teacher.spec.js:312:          .update({ processStep2: 'TEST co-teacher step 2', lastEditedBy: 'TESTteacher2', lastEditedAt: new Date().toISOString(), lastEditId: 'eothersave00005' });
./e2e/day-off-teacher.spec.js:316:    await t.click('#summer-lesson-save');
./e2e/day-off-teacher.spec.js:317:    await expect(t.locator('#summer-autosave-status')).toContainText('TESTteacher2 has edited this plan since');
./e2e/day-off-teacher.spec.js:320:  test('T6: a real failure is still caught — the read-back carries my own save id but a field did not land', async ({ browser }) => {
./e2e/day-off-teacher.spec.js:328:        // Wrap tx.set so the write lands WITHOUT the closure but with this save's id.
./e2e/day-off-teacher.spec.js:337:      try { await saveSingleLesson(Y, K, { closure: 'TEST lost' }, [], { dayOffAuth: auth }); return { ok: true }; }
./e2e/day-off-teacher.spec.js:345:  test('T7: rename while the editor is open — the save is refused, the text stays, no old-title doc, and the camp shows the new title after the reload', async ({ browser }) => {
./e2e/day-off-teacher.spec.js:352:    const r = await attempt(planner, ({ Y, c, orig }) => saveDayOffCamp(Y, c, orig), { Y, c: renamed, orig: camp });
./e2e/day-off-teacher.spec.js:355:    await t.click('#summer-lesson-save');
./e2e/day-off-teacher.spec.js:356:    await expect(t.locator('#summer-autosave-status')).toContainText('renamed or removed');
./e2e/day-off-teacher.spec.js:369:    const r = await attempt(planner, ({ Y, c, orig }) => saveDayOffCamp(Y, c, orig), { Y, c: { ...camp, teachers: ['TESTteacher2'] }, orig: camp });
./e2e/day-off-teacher.spec.js:372:    await t.click('#summer-lesson-save');
./e2e/day-off-teacher.spec.js:373:    await expect(t.locator('#summer-autosave-status')).toContainText('no longer on this camp');
./e2e/day-off-teacher.spec.js:390:      const r = await attempt(t, ({ Y, K, payload, clears, auth }) => saveSingleLesson(Y, K, payload, clears, { dayOffAuth: auth }), { Y, K, payload, clears, auth });
./e2e/day-off-teacher.spec.js:394:    const noAuth = await attempt(t, ({ Y, K }) => saveSingleLesson(Y, K, { introPitch: 'x' }), { Y, K });
./e2e/day-off-teacher.spec.js:397:    let r = await attempt(t, ({ Y, K, auth }) => saveSingleLesson(Y, K, { closure: 'TEST to clear' }, [], { dayOffAuth: auth }), { Y, K, auth });
./e2e/day-off-teacher.spec.js:399:    r = await attempt(t, ({ Y, K, auth }) => saveSingleLesson(Y, K, {}, ['closure'], { dayOffAuth: auth }), { Y, K, auth });
./e2e/day-off-teacher.spec.js:406:  test('T10: photo — uploads to curriculum/{year}/…, removal deletes both fields (not empty strings), the old object goes only after the verified save', async ({ browser }) => {
./e2e/day-off-teacher.spec.js:413:    await t.click('#summer-lesson-save');
./e2e/day-off-teacher.spec.js:414:    await expect(t.locator('#summer-autosave-status')).toContainText('Saved');
./e2e/day-off-teacher.spec.js:419:    await t.click('#summer-lesson-save');
./e2e/day-off-teacher.spec.js:420:    await expect(t.locator('#summer-autosave-status')).toContainText('Saved');
./e2e/day-off-teacher.spec.js:459:    await expect(t.locator('#summer-lesson-save')).toBeHidden();
./e2e/day-off-teacher.spec.js:461:    await expect(t.locator('#summer-autosave-status')).toContainText('View only');
./e2e/day-off-teacher.spec.js:468:        ta.dispatchEvent(new Event('input', { bubbles: true }));   // what typing fires — arms autosave if anything would
./e2e/day-off-teacher.spec.js:469:        document.getElementById('summer-lesson-save')?.click();      // hidden, but a scripted click must still do nothing
./e2e/day-off-teacher.spec.js:481:    const r = await attempt(planner, ({ Y, eventId }) => saveDayOffCamp(Y, {
./e2e/day-off-teacher.spec.js:500:    expect(await t.evaluate(() => Object.keys(currentConfig.semesters).filter(canSeeSemester))).not.toContain(Y);
./e2e/day-off-teacher.spec.js:503:  test('T14: the six other lesson writers still refuse an SDOC key, and curriculum/lessonData never gets one', async ({ browser }) => {
./e2e/day-off-teacher.spec.js:510:      await tryIt('saveLessonData', () => saveLessonData(Y, { [K]: { introPitch: 'x' } }));
./e2e/day-off-teacher.spec.js:511:      await tryIt('saveMultipleLessonFields', () => saveMultipleLessonFields(Y, { [K]: { introPitch: 'x' } }));
./e2e/day-off-teacher.spec.js:528:      const plan = await __sdocT.read('lessonData', dayOffPlanDocId(Y, campId, title));
./e2e/day-off-teacher.spec.js:530:      const d = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
./e2e/day-off-teacher.spec.js:534:    expect(out).toMatchObject({ lessonStoreFor: 'refused', saveLessonData: 'refused', saveMultipleLessonFields: 'refused', adminLessonStillExistsWithRetry: 'refused', noKey: true, noQaThread: true });
./e2e/day-off-teacher.spec.js:538:  test('T15: Save with nothing typed on a never-planned project — "✓ Saved", no write, no reload; typing autosaves never schedule the SDOC reload', async ({ browser }) => {
./e2e/day-off-teacher.spec.js:544:    await t.click('#summer-lesson-save');
./e2e/day-off-teacher.spec.js:545:    await expect(t.locator('#summer-autosave-status')).toContainText('✓ Saved');
./e2e/day-off-teacher.spec.js:553:  test('T16: a reload whose query predates a verified save cannot put the old text back — even when the old copy carries a later (skewed) clock', async ({ browser }) => {
./e2e/day-off-teacher.spec.js:558:    let r = await attempt(t, ({ Y, K, auth }) => saveSingleLesson(Y, K, { introPitch: 'TEST old' }, [], { dayOffAuth: auth }), { Y, K, auth });
./e2e/day-off-teacher.spec.js:563:      // Hold the reload's query RESULTS (taken now, before the save) until released.
./e2e/day-off-teacher.spec.js:570:      const saved = await saveSingleLesson(Y, K, { introPitch: 'TEST new' }, [], { dayOffAuth: auth });
./e2e/day-off-teacher.spec.js:573:      return { status: saved.status, slot: currentLessonData[Y][K].introPitch, plan: currentDayOffPlans[Y][K].introPitch, id: currentLessonData[Y][K].lastEditId, serverId: saved.doc.lastEditId };
./e2e/day-off-teacher.spec.js:575:    expect(res.status).toBe('saved');
./e2e/day-off-teacher.spec.js:587:    const r = await attempt(planner, ({ Y, eventId, evil }) => saveDayOffCamp(Y, {
./e2e/day-off-teacher.spec.js:602:  test('T18: a save that fails after a new photo uploaded keeps the old photo in Storage and in the plan; the new upload is an orphan at its own path', async ({ browser }) => {
./e2e/day-off-teacher.spec.js:609:    await t.click('#summer-lesson-save');
./e2e/day-off-teacher.spec.js:610:    await expect(t.locator('#summer-autosave-status')).toContainText('Saved');
./e2e/day-off-teacher.spec.js:612:    // The next save's transaction fails (after the upload).
./e2e/day-off-teacher.spec.js:618:    await t.click('#summer-lesson-save');
./e2e/day-off-teacher.spec.js:619:    await expect(t.locator('#summer-autosave-status')).toContainText('Save failed');
./e2e/day-off-teacher.spec.js:624:    // A retry saves the new photo and only THEN deletes the original.
./e2e/day-off-teacher.spec.js:625:    await t.click('#summer-lesson-save');
./e2e/day-off-teacher.spec.js:626:    await expect(t.locator('#summer-autosave-status')).toContainText('Saved');
./e2e/day-off-teacher.spec.js:632:  test('T19: a teacher save leaves the camp\'s sign-off doc byte-identical, and a prep tick racing it survives on both sides', async ({ browser }) => {
./e2e/day-off-teacher.spec.js:637:    const signoffBefore = await planner.evaluate(({ Y, c }) => __sdocT.read('lessonData', dayOffSignoffDocId(Y, c)), { Y, c: clay.id });
./e2e/day-off-teacher.spec.js:641:    // Tick lands first, then the teacher's save: her read-back carries the tick.
./e2e/day-off-teacher.spec.js:644:    r = await attempt(t, ({ Y, K, auth }) => saveSingleLesson(Y, K, { introPitch: 'TEST with tick' }, [], { dayOffAuth: auth }), { Y, K, auth });
./e2e/day-off-teacher.spec.js:647:    // Untick after the save: both stay on the server.
./e2e/day-off-teacher.spec.js:654:    expect(await planner.evaluate(({ Y, c }) => __sdocT.read('lessonData', dayOffSignoffDocId(Y, c)), { Y, c: clay.id })).toEqual(signoffBefore);
./e2e/day-off-teacher.spec.js:661:    const weekly = await prep.evaluate(() => currentConfig.activeSemester);
./e2e/day-off-teacher.spec.js:697:    await planner.evaluate(({ Y, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'Clay Creatures'))
./e2e/day-off-teacher.spec.js:707:    const r = await attempt(planner, ({ Y, c }) => saveDayOffProjectDetails(Y, c, 'Clay Creatures', {
./e2e/day-off-teacher.spec.js:718:    // An ordinary teacher save leaves the planner's details intact.
./e2e/day-off-teacher.spec.js:727:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'Glaze Day')).set({ yearKey: Y, campId: c, projectTitle: 'Glaze Day', projectLinks: 'https://not-an-array.test', projectDetails: { oops: 1 } }), { Y, c: clay.id });
./e2e/day-off-teacher.spec.js:737:    const r = await attempt(planner, ({ Y, eventId }) => saveDayOffCamp(Y, {
./CLASSBOOK-DATA-SAFETY-PLAN.md:10:Two separate wipe events destroyed teacher lesson plan content (introPitch, processStep1–4, closure, dayOfMaterials) in the `summerCamps_lessonData` Firestore collection.
./CLASSBOOK-DATA-SAFETY-PLAN.md:12:**Root cause in both cases**: Firestore's `set(data, { merge: true })` does NOT skip fields that are present with empty string values. `{ introPitch: '' }` written with `merge: true` sets `introPitch` to `''` in Firestore, destroying whatever was there. Both save functions were passing empty content fields through to Firestore.
./CLASSBOOK-DATA-SAFETY-PLAN.md:14:**Wipe 1 (before May 14)**: `saveSummerCampLessonData()` — bulk batch write — looped over all lesson slots and wrote every one, including those with empty content fields. Fixed last week: added `hasContent` guard + per-field stripping.
./CLASSBOOK-DATA-SAFETY-PLAN.md:16:**Wipe 2 (May 15, 3:51 PM MDT)**: `saveSingleLesson()` — per-lesson save — had the same vulnerability but was not fixed last week. When a teacher's in-memory lesson state had empty content fields (from a silent load failure or stale merge), saving any field caused all the empty ones to overwrite real Firestore content. Fixed May 18: added identical stripping logic.
./CLASSBOOK-DATA-SAFETY-PLAN.md:24:- ✅ `saveSummerCampLessonData()` — fixed, stripped, hasContent guard
./CLASSBOOK-DATA-SAFETY-PLAN.md:25:- ✅ `saveSingleLesson()` summer path — fixed, stripped (line 547 in firebase-data.js)
./CLASSBOOK-DATA-SAFETY-PLAN.md:31:- ✅ Stage 1A — Load failure banner + save guard deployed (May 18)
./CLASSBOOK-DATA-SAFETY-PLAN.md:33:- ✅ Stage 1C — Photo upload order fixed committed (Aug 11, 2026, commit 73e3495), deployed Aug 13, 2026. Fixed in `saveTeacherEdit()`, the summer modal's `saveLesson()`, **and `saveAdminEdit()`** (a third site with the identical bug, found during implementation, not in the original vulnerability table below — see row 5). Test 6 was rewritten: its `openModal()` helper was calling the wrong function (a read-only modal) so it never actually exercised the bug, and its assertion checked a Firestore field that can't reveal a deleted Storage object regardless of code order. It now asserts directly on whether a Storage DELETE request fires.
./CLASSBOOK-DATA-SAFETY-PLAN.md:35:- ✅ Stage 2B — Admin grid swap: two targeted `saveSingleLesson` calls instead of a full-semester bulk `saveLessonData` overwrite, with rollback on partial failure; **plus `saveAdminEdit()`**, found during Phase 1 execution to have the identical bulk-overwrite risk (not in the original vulnerability table below — copies the entire local semester through a recursive merge, silently reverting any stale sibling lesson). Both fixed Aug 12, 2026, same session as 2A.
./CLASSBOOK-DATA-SAFETY-PLAN.md:36:- ✅ Stage 2C — Plan Complete checkbox now writes only `{ planComplete }` at both call sites (summer + non-summer), not the full possibly-stale lesson object; `saveSingleLesson`'s summer-branch `hasContent` guard got an explicit bypass for a `planComplete`-only payload (Aug 12, 2026, same session as 2A/2B).
./CLASSBOOK-DATA-SAFETY-PLAN.md:37:- ✅ Stage 2D — Non-summer `saveSingleLesson` redesigned around explicit per-field dotted-path `update()` calls (never a whole-object assignment to the bare `semesterKey.lessonKey` path, which would replace the entire lesson) plus the same content-field stripping the summer path already had (Aug 12, 2026).
./CLASSBOOK-DATA-SAFETY-PLAN.md:38:- ✅ Stage 2E — Post-save read-back verification for summer saves: new `verifySummerLessonWrite()` reads content fields back with `get({source:'server'})` (never cache), retries once on a read failure, throws a soft "couldn't confirm — check your connection" message if the retry also fails, or a hard "please reload and check: [fields]" message if the fields genuinely read back missing. Wired into `saveSingleLesson`'s summer branch after every write that includes content fields. This is the exact check that would have caught both original May 2026 wipe incidents within seconds (Aug 12, 2026).
./CLASSBOOK-DATA-SAFETY-PLAN.md:39:- ✅ Stage 3 — Intentional field clear support: `saveSingleLesson()` takes an optional `fieldsToClear` param — those content fields get Firestore's `FieldValue.delete()` instead of silent omission, so genuinely clearing a field's text now actually persists instead of reappearing on reload. Both edit modals now snapshot content fields at open time (the summer modal didn't have this before; the non-summer modal's existing `teOriginalData` already did) and compute which fields were intentionally emptied vs. never filled in. A "✓ Saved (fieldName cleared)" confirmation appears when a clear happens. Phase 3's read-back verification excludes intentionally-cleared fields so it doesn't falsely flag them as a failed write (Aug 12, 2026).
./CLASSBOOK-DATA-SAFETY-PLAN.md:41:  - **4A — Content Count by Teacher**: new admin panel (Curriculum Admin, below Change History) computing today's live per-teacher lesson-content count from `summerCamps_lessonData` + `curriculum/lessonData` and comparing it to a backup-derived baseline (see 4B). Only a >10% drop is red-flagged (same threshold `~/tinker-backups/backup.js` already uses for its own collection-level check) — a teacher with no recorded baseline, or a small routine edit, is never falsely flagged. `CONTENT_FIELDS`/`lessonHasContent()` — previously duplicated across 4 call sites in `app.js`/`firebase-data.js` — consolidated into one shared constant in `firebase-data.js` as part of this work.
./CLASSBOOK-DATA-SAFETY-PLAN.md:44:  - **4C — Audit trail wipe flag**: `logTeacherEdit`'s `changedFields` (previously a bare array of field-name strings) now carries `{field, before, after, potentialWipe}` per changed field for the non-summer editor (`saveTeacherEdit`/`getTeChangedFields` — the summer modal doesn't call `logTeacherEdit` at all, so this is scoped exactly where the plan's own danger callout described it). `potentialWipe` is `after === 0 && before > 50`, visible directly in the Change History timeline (`⚠️ possible wipe` appended to the field name), not a separate hidden log. Old pre-Stage-4C log entries are permanent (`arrayUnion`, never rewritten) and stay plain string arrays forever — Change History's renderer permanently supports both shapes via a `typeof` check, not a one-time migration. The `'photo'` pseudo-field (pushed into `changedFields` on a photo upload/removal, not a text field) carries `before: null, after: null, potentialWipe: false` since it has no char-count counterpart.
./CLASSBOOK-DATA-SAFETY-PLAN.md:45:- ✅ Stage 5 — Expand test coverage (Aug 13, 2026). Checked all 7 items on this stage's original checklist against tests already added while shipping Phases 1–5: 6 of 7 were already covered as a side effect (admin move abort/restore, admin swap targeted-saves + canary, Plan Complete checkbox / Test 5, non-summer stripping, read-back verification error, intentional field clear). Only "content-count dashboard shows correct numbers for a seeded test teacher" was genuinely open — added one test seeding known content across both `summerCamps_lessonData` and `curriculum/lessonData` for a dedicated test teacher, asserting `computeLiveContentCountByTeacher()` returns exactly the expected count and excludes a deliberately contentless lesson. Validated the test's own worth by temporarily breaking the `hasContent` filter, confirming the test failed (4 instead of 3), then restoring and confirming green — same discipline as every prior phase's red/green cycle, applied here to prove a coverage test actually exercises what it claims. Test-only change, no app code touched. **This closes the Classbook Data Safety Plan — all 5 remaining-stages phases (and the earlier Stages 0/1A/1B/1C) are shipped, tested, committed, and deployed to production.**
./CLASSBOOK-DATA-SAFETY-PLAN.md:51:| Test 1 | Stripping — one field save doesn't wipe others | ✅ PASS |
./CLASSBOOK-DATA-SAFETY-PLAN.md:52:| Test 2 | All-empty save blocked by hasContent guard | ✅ PASS |
./CLASSBOOK-DATA-SAFETY-PLAN.md:54:| Test 4 | Load failure blocks saves | ✅ PASS (Stage 1A) |
./CLASSBOOK-DATA-SAFETY-PLAN.md:59:Plus 7 new Phase 1 tests added Aug 12, 2026 (Stage 2A/2B, unnumbered — see `e2e/data-safety.spec.js`'s "Admin grid safety (Phase 1: ...)" describe blocks for the full BDD): move read-back confirms + deletes, move aborts + restores on failed read-back, move of an empty scaffold still deletes, move never deletes on a throwing write, swap targeted-saves with canary untouched, swap partial-failure rollback, `saveAdminEdit` targeted-save with canary untouched. All 7 ✅ PASS.
./CLASSBOOK-DATA-SAFETY-PLAN.md:61:Plus 2 new Phase 2 tests added Aug 12, 2026 (Stage 2C/2D, unnumbered — see the "Phase 2: ..." describe blocks): non-summer Plan Complete checkbox via the real `attachCardListeners` production listener (proves photoUrl survives a stale local copy), non-summer `saveSingleLesson` stripping regression (mirrors Test 1/2, plus proves sibling non-content fields and the rest of the lesson survive a per-field write). Both ✅ PASS.
./CLASSBOOK-DATA-SAFETY-PLAN.md:63:Plus 3 new Phase 3 tests added Aug 12, 2026 (Stage 2E, unnumbered — see the "Read-back verification (Phase 3: 2E)" describe block): `verifySummerLessonWrite` names the missing field against a real Firestore doc that's missing it, retries once then gives a soft message against a fake docRef that always throws (isolates the retry logic from real network conditions), and a normal successful save still resolves without throwing. All 3 ✅ PASS.
./CLASSBOOK-DATA-SAFETY-PLAN.md:68:- **4C (2 tests)**: a save wiping a large field (260→0 chars) is flagged `potentialWipe: true` and visibly shows "⚠️ possible wipe" in the rendered Change History, while a normal edit on a sibling field in the same save is not flagged; Change History renders a hand-injected pre-Stage-4C string-array `changedFields` entry without crashing and without ever showing a wipe flag on a bare string.
./CLASSBOOK-DATA-SAFETY-PLAN.md:71:- 9 of these 12 touch no Firestore at all — `renderBackupHealthData`/`renderContentCountData` are pure functions tested directly with synthetic data, since `backupStatus/latest` is a shared singleton written by the real 30-min backup script and isn't safe to overwrite with test fixtures. The 4C wipe-flag test exercises a real save through existing Firestore infra (same pattern as every other save-path test in this file). The 4B and 4A "real end-to-end" tests are genuine read-only smoke tests against real production Firestore. 34/34 tests green.
./CLASSBOOK-DATA-SAFETY-PLAN.md:87:| 3 | Admin grid swap: calls `saveLessonData` (full bulk write) | app.js:4603 | **HIGH** | 2 |
./CLASSBOOK-DATA-SAFETY-PLAN.md:92:| 8 | Non-summer `saveSingleLesson` has no field stripping | firebase-data.js:558–569 | Medium | 2 |
./CLASSBOOK-DATA-SAFETY-PLAN.md:93:| 9 | No post-save read-back verification | all save paths | Medium | 2 |
./CLASSBOOK-DATA-SAFETY-PLAN.md:95:| 11 | Concurrent sessions — last write wins | all save paths | Low | 4 |
./CLASSBOOK-DATA-SAFETY-PLAN.md:109:**Goal**: Write the 6 behavioral tests that lock in correct save behavior. Tests for already-fixed behaviors (stripping) pass immediately. Tests for Stage 1 behaviors (load failure block, photo order) fail until Stage 1 is implemented — that's proof Stage 1 works.
./CLASSBOOK-DATA-SAFETY-PLAN.md:148:Install: `cd /Users/christiehubley/tinker-spring-curriculum && npm install --save-dev @playwright/test && npx playwright install chromium`
./CLASSBOOK-DATA-SAFETY-PLAN.md:158:**Test data strategy**: Tests write to real `summerCamps_lessonData` in `tinker-hq-apps`. To avoid polluting real teacher data, all test docs use a dedicated teacher name `"TEST"` and a camp name `"TEST_DATA_SAFETY"`. These will never appear in the real teacher views because no curriculum camp is assigned to teacher "TEST". Clean up after each test run.
./CLASSBOOK-DATA-SAFETY-PLAN.md:160:In the Classbook's Firestore rules, teacher "TEST" must have write access to `summerCamps_lessonData`. Check `studio-hub/firestore.rules` — if the rule grants write to any authenticated user with `appAccess: ['classbook']`, the test account already qualifies.
./CLASSBOOK-DATA-SAFETY-PLAN.md:181:**Test 1: Stripping regression — existing content survives a save that doesn't touch it**
./CLASSBOOK-DATA-SAFETY-PLAN.md:195:  // Action: open the lesson modal, type only in processStep2, wait for autosave
./CLASSBOOK-DATA-SAFETY-PLAN.md:201:  await page.waitForTimeout(2500); // autosave fires at 2000ms
./CLASSBOOK-DATA-SAFETY-PLAN.md:204:  const saved = await readTestDoc(docId);
./CLASSBOOK-DATA-SAFETY-PLAN.md:205:  expect(saved.introPitch).toBe('ORIGINAL intro pitch content that must survive');
./CLASSBOOK-DATA-SAFETY-PLAN.md:206:  expect(saved.processStep1).toBe('ORIGINAL step 1 content that must survive');
./CLASSBOOK-DATA-SAFETY-PLAN.md:207:  expect(saved.processStep2).toBe('New step 2 content typed by teacher');
./CLASSBOOK-DATA-SAFETY-PLAN.md:211:**Test 2: All-empty save is blocked — stripping prevents writing a blank doc**
./CLASSBOOK-DATA-SAFETY-PLAN.md:222:  // Trigger save without typing anything — click save button directly
./CLASSBOOK-DATA-SAFETY-PLAN.md:223:  await page.click('#summer-lesson-save');
./CLASSBOOK-DATA-SAFETY-PLAN.md:226:  const saved = await readTestDoc(docId);
./CLASSBOOK-DATA-SAFETY-PLAN.md:227:  expect(saved.introPitch).toBe('Content that must not be wiped');
./CLASSBOOK-DATA-SAFETY-PLAN.md:231:**Test 3: Load failure — error banner appears and saves are blocked**
./CLASSBOOK-DATA-SAFETY-PLAN.md:238:  // Block the summerCamps_lessonData Firestore fetch
./CLASSBOOK-DATA-SAFETY-PLAN.md:239:  await page.route('**/summerCamps_lessonData**', route => route.abort());
./CLASSBOOK-DATA-SAFETY-PLAN.md:245:  const saveBtn = page.locator('#summer-lesson-save');
./CLASSBOOK-DATA-SAFETY-PLAN.md:246:  await expect(saveBtn).toBeDisabled();
./CLASSBOOK-DATA-SAFETY-PLAN.md:250:**Test 4: Load failure — save call does not write to Firestore**
./CLASSBOOK-DATA-SAFETY-PLAN.md:253:test('when load failed, attempting to save does not write to Firestore', async ({ browser }) => {
./CLASSBOOK-DATA-SAFETY-PLAN.md:258:  await page.route('**/summerCamps_lessonData**', route => route.abort());
./CLASSBOOK-DATA-SAFETY-PLAN.md:269:  // Try to save (if save button is accessible at all — it shouldn't be)
./CLASSBOOK-DATA-SAFETY-PLAN.md:276:  const saved = await readTestDoc(docId);
./CLASSBOOK-DATA-SAFETY-PLAN.md:277:  expect(saved.introPitch).toBe('Must not be touched during failed load');
./CLASSBOOK-DATA-SAFETY-PLAN.md:299:  await page.waitForTimeout(1000); // save fires on checkbox change
./CLASSBOOK-DATA-SAFETY-PLAN.md:301:  const saved = await readTestDoc(docId);
./CLASSBOOK-DATA-SAFETY-PLAN.md:302:  expect(saved.photoUrl).toBe('https://example.com/test-photo.jpg');
./CLASSBOOK-DATA-SAFETY-PLAN.md:303:  expect(saved.planComplete).toBe(true);
./CLASSBOOK-DATA-SAFETY-PLAN.md:336:  const saved = await readTestDoc(docId);
./CLASSBOOK-DATA-SAFETY-PLAN.md:337:  expect(saved.photoUrl).toMatch(/firebasestorage/);
./CLASSBOOK-DATA-SAFETY-PLAN.md:350: * Uses the same REST API pattern as restore-lesson-data.js and check-recent-saves.js.
./CLASSBOOK-DATA-SAFETY-PLAN.md:397:  const url = new URL(`https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/summerCamps_lessonData/${encodedId}`);
./CLASSBOOK-DATA-SAFETY-PLAN.md:413:    `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/summerCamps_lessonData/${encodeURIComponent(docId)}`,
./CLASSBOOK-DATA-SAFETY-PLAN.md:426:    `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/summerCamps_lessonData/${encodeURIComponent(docId)}`,
./CLASSBOOK-DATA-SAFETY-PLAN.md:445:- Test 2 (all-empty save blocked) → ✅ PASS (fix already deployed)
./CLASSBOOK-DATA-SAFETY-PLAN.md:447:- Test 4 (load failure blocks save) → ❌ FAIL — expected, guard not yet implemented
./CLASSBOOK-DATA-SAFETY-PLAN.md:482:- [ ] Playwright installed in Classbook project (`npm install --save-dev @playwright/test`)
./CLASSBOOK-DATA-SAFETY-PLAN.md:501:#### 1A. Silent load failure — surface the error and block saves
./CLASSBOOK-DATA-SAFETY-PLAN.md:504:**What to change**: Add a module-level flag `lessonDataLoadedSuccessfully`. Set it `false` before the fetch, `true` after successful merge, leave `false` if catch fires.
./CLASSBOOK-DATA-SAFETY-PLAN.md:507:**What to change**: After `loadSummerCampData()` returns, if `lessonDataLoadedSuccessfully` is false, render a blocking error banner instead of the normal view:
./CLASSBOOK-DATA-SAFETY-PLAN.md:511:Do NOT type or save anything. Reload the page to try again.
./CLASSBOOK-DATA-SAFETY-PLAN.md:515:Also: add a guard at the top of `saveSingleLesson()` for summer path:
./CLASSBOOK-DATA-SAFETY-PLAN.md:517:if (!lessonDataLoadedSuccessfully) {
./CLASSBOOK-DATA-SAFETY-PLAN.md:518:  throw new Error('Cannot save — lesson data did not load successfully. Reload the page.');
./CLASSBOOK-DATA-SAFETY-PLAN.md:522:**Why**: If the Firestore read for `summerCamps_lessonData` fails (network error, rules regression, quota exceeded), teachers currently see blank lesson plans with no warning. With the stripping fix in place, saves won't wipe content — but teachers don't know their content is missing and may re-enter work or be confused. The banner makes the failure visible and the save guard prevents any writes until data is confirmed loaded.
./CLASSBOOK-DATA-SAFETY-PLAN.md:524:**Verify**: In browser devtools, block the `summerCamps_lessonData` network request. Confirm banner appears and Save button is disabled.
./CLASSBOOK-DATA-SAFETY-PLAN.md:535:saveTeacherEdit(lessonKey, lesson);
./CLASSBOOK-DATA-SAFETY-PLAN.md:540:saveTeacherEdit(lessonKey, currentLessonData?.[getTvSemKey()]?.[lessonKey] || lesson);
./CLASSBOOK-DATA-SAFETY-PLAN.md:543:**Why**: The Cmd+S keyboard handler captures `lesson` from the closure at modal-open time. The Save button and autosave both use `currentLessonData` (the live reference updated after each successful save). If a teacher uploads a photo (autosave fires, `currentLessonData` updated with new `photoUrl`), then presses Cmd+S, the stale `lesson` has `photoUrl: ''` and `merge: true` writes it, erasing the photo URL. This only affects the non-summer editor (`te-modal`), not the summer lesson modal.
./CLASSBOOK-DATA-SAFETY-PLAN.md:551:**File**: `js/app.js`, `saveTeacherEdit()` function, around line 3069
./CLASSBOOK-DATA-SAFETY-PLAN.md:570:Also apply the same reorder in `saveLesson()` in the summer modal (around line 9540–9544):
./CLASSBOOK-DATA-SAFETY-PLAN.md:604:- [ ] Test 1A: block the network request and confirm error banner appears, saves disabled
./CLASSBOOK-DATA-SAFETY-PLAN.md:627:**What to change**: After `saveSingleLesson(semKey, newDestKey, movedLesson)` succeeds, read back the destination doc and confirm it has at least one non-empty content field before calling `deleteLessonKey`. If the read-back shows no content (meaning the lesson being moved had no content and only metadata was written), still delete the source — but if the read-back shows content fields, verify they match what was written.
./CLASSBOOK-DATA-SAFETY-PLAN.md:630:await saveSingleLesson(semKey, newDestKey, movedLesson);
./CLASSBOOK-DATA-SAFETY-PLAN.md:633:const destDoc = await curriculumDb.collection('summerCamps_lessonData').doc(encodeFirestoreKey(newDestKey)).get();
./CLASSBOOK-DATA-SAFETY-PLAN.md:647:**Why**: The delete is irreversible. If `movedLesson` was built from stale in-memory data (failed load), the save writes nothing meaningful to the destination (stripping removes empty fields), then the delete destroys the real content at the source. Data is permanently lost.
./CLASSBOOK-DATA-SAFETY-PLAN.md:651:#### 2B. Admin grid swap — use targeted saves, not bulk write
./CLASSBOOK-DATA-SAFETY-PLAN.md:654:**What to change**: Replace `saveLessonData(semKey, lessons)` with two `saveSingleLesson` calls:
./CLASSBOOK-DATA-SAFETY-PLAN.md:658:savePromise = saveLessonData(semKey, lessons);
./CLASSBOOK-DATA-SAFETY-PLAN.md:663:savePromise = Promise.all([
./CLASSBOOK-DATA-SAFETY-PLAN.md:664:  saveSingleLesson(semKey, caSourceKey, swappedSource),
./CLASSBOOK-DATA-SAFETY-PLAN.md:665:  saveSingleLesson(semKey, newDestKey, swappedDest)
./CLASSBOOK-DATA-SAFETY-PLAN.md:669:**Why**: `saveLessonData` may be equivalent to `saveSummerCampLessonData` — a full bulk write of all lesson slots. Even with the hasContent guard, a bulk write during a stale state could cause unexpected writes. Two targeted saves are predictable and bounded.
./CLASSBOOK-DATA-SAFETY-PLAN.md:676:**What to change**: Instead of `saveSingleLesson(semKey, lessonKey, lesson)` (full object), pass only the fields that the checkbox should update:
./CLASSBOOK-DATA-SAFETY-PLAN.md:685:await saveSingleLesson(semKey, lessonKey, planCompleteUpdate);
./CLASSBOOK-DATA-SAFETY-PLAN.md:690:Note: `saveSingleLesson` will need a guard update — the `hasContent` check currently blocks saves where all content fields are empty. A planComplete-only update has no content fields, so it would be blocked. Add a bypass: if the payload contains `planComplete` explicitly (regardless of content fields), allow the write.
./CLASSBOOK-DATA-SAFETY-PLAN.md:694:#### 2D. Non-summer `saveSingleLesson` field stripping
./CLASSBOOK-DATA-SAFETY-PLAN.md:696:**File**: `js/firebase-data.js`, lines 558–569 (the non-summer branch of `saveSingleLesson`)
./CLASSBOOK-DATA-SAFETY-PLAN.md:702:const stripped = { ...lessonData };
./CLASSBOOK-DATA-SAFETY-PLAN.md:705:await curriculumDb.collection('curriculum').doc('lessonData').update({
./CLASSBOOK-DATA-SAFETY-PLAN.md:714:#### 2E. Post-save read-back verification
./CLASSBOOK-DATA-SAFETY-PLAN.md:716:**File**: `js/firebase-data.js`, `saveSingleLesson()` summer path (after line 551)
./CLASSBOOK-DATA-SAFETY-PLAN.md:720:await curriculumDb.collection('summerCamps_lessonData').doc(encodeFirestoreKey(lessonKey)).set(cleanData, { merge: true });
./CLASSBOOK-DATA-SAFETY-PLAN.md:723:const verification = await curriculumDb.collection('summerCamps_lessonData').doc(encodeFirestoreKey(lessonKey)).get();
./CLASSBOOK-DATA-SAFETY-PLAN.md:724:const saved = verification.exists ? verification.data() : {};
./CLASSBOOK-DATA-SAFETY-PLAN.md:726:const failedFields = writtenFields.filter(f => !saved[f] || !String(saved[f]).trim());
./CLASSBOOK-DATA-SAFETY-PLAN.md:734:**Why**: This would have caught both wipe events within 2 seconds of the first affected save. The teacher would have seen an error immediately instead of discovering missing content days later. Doubles Firestore reads on every save (cost is trivial at this scale — ~100 saves/day).
./CLASSBOOK-DATA-SAFETY-PLAN.md:743:- [ ] Test 2A (error path): simulate a failed save; verify source is NOT deleted
./CLASSBOOK-DATA-SAFETY-PLAN.md:746:- [ ] Test 2E: confirm "✓ Saved" indicator appears after a successful autosave
./CLASSBOOK-DATA-SAFETY-PLAN.md:756:**Background**: The stripping fix (Stage 1 result) protects against accidental overwrites but also prevents intentional clears. If a teacher deletes all text from `processStep2` and saves, the stripping removes the empty field from the payload. Firestore keeps the old value. When the teacher reloads, the "deleted" content reappears. There is no error message.
./CLASSBOOK-DATA-SAFETY-PLAN.md:760:In `saveLesson()` (summer modal) and `saveTeacherEdit()` (non-summer modal), compare each content field against its value when the modal was opened (`teOriginalData` already tracks this for the non-summer path; the summer modal needs the same tracking):
./CLASSBOOK-DATA-SAFETY-PLAN.md:769:// At save time: for each field that was non-empty when opened but is now empty,
./CLASSBOOK-DATA-SAFETY-PLAN.md:778:**UX addition**: When a teacher saves with one or more fields intentionally cleared, show a brief confirmation: "processStep2 cleared." This makes the behavior explicit rather than silent.
./CLASSBOOK-DATA-SAFETY-PLAN.md:795:Data source: read `summerCamps_lessonData` and group by teacher. Compare to latest backup file.
./CLASSBOOK-DATA-SAFETY-PLAN.md:802:#### 4C. Per-save field-level audit trail
./CLASSBOOK-DATA-SAFETY-PLAN.md:814:Stage 0 covers the 6 core save-path tests. Once Stages 1–4 are complete, add tests for:
./CLASSBOOK-DATA-SAFETY-PLAN.md:817:- Post-save read-back verification catches a silent write failure
./CLASSBOOK-DATA-SAFETY-PLAN.md:847:| `js/firebase-data.js` | All Firestore read/write functions. `saveSingleLesson` line 529, `saveSummerCampLessonData` line 256, `loadSummerCampData` line 657 |
./CLASSBOOK-DATA-SAFETY-PLAN.md:848:| `js/app.js` | All UI and save triggers. Plan Complete checkbox lines 2003 + 2449, Cmd+S line 2876, photo handler lines 3069–3074, admin grid move line 4578 |
./CLASSBOOK-DATA-SAFETY-PLAN.md:849:| `~/tinker-backups/` | Backup JSON files. Structure: `{ exportedAt, collections: { summerCamps_lessonData: { docId: { fields } } } }` |
./CLASSBOOK-DATA-SAFETY-PLAN.md:851:| `~/tinker-backups/check-recent-saves.js` | Read-only spot check — shows most recent saves and their content status |
./CLASSBOOK-DATA-SAFETY-PLAN.md:873:- A failed load **cannot** be silently saved over (blocked by flag)
./e2e/day-off-materials.spec.js:40:  attempt(page, ({ Y, id, title, item, itemId }) => saveDayOffMaterialItem(Y, id, title, itemId, item), { Y, id: camp.id, title, item, itemId });
./e2e/day-off-materials.spec.js:42:  page.evaluate(async ({ Y, id, title }) => __sdocT.read('lessonData', dayOffPlanDocId(Y, id, title)), { Y, id: camp.id, title });
./e2e/day-off-materials.spec.js:44:  page.evaluate(async ({ Y, id }) => __sdocT.read('lessonData', dayOffSignoffDocId(Y, id)), { Y, id: camp.id });
./e2e/day-off-materials.spec.js:64:      const writes = (await planner.evaluate(() => window.__spy.calls)).filter(c => c.via === 'tx.update' && c.path.startsWith('dayOffCamps_lessonData/'));
./e2e/day-off-materials.spec.js:153:    let r = await attempt(planner, ({ Y, cur }) => saveDayOffCamp(Y, { ...cur, placements: [{ studio: 'AG', ageRange: '5–7', capacity: 14 }] }, cur), { Y, cur: current });
./e2e/day-off-materials.spec.js:160:    r = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur), { Y, cur: current, projects });
./e2e/day-off-materials.spec.js:165:  test('M6: renames carry lists and ticks — two in one save; onto a title with data is refused; onto an empty leftover replaces it', async () => {
./e2e/day-off-materials.spec.js:171:    await planner.evaluate(({ Y, c }) => __sdocT.write('lessonData', dayOffPlanDocId(Y, c, 'Glaze Party'), { yearKey: Y, campId: c, projectTitle: 'Glaze Party' }), { Y, c: camp.id });
./e2e/day-off-materials.spec.js:179:    let r = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur, { confirmOrphans: async () => { window.__asked = true; return true; } }), { Y, cur: current, projects });
./e2e/day-off-materials.spec.js:193:    await planner.evaluate(({ Y, c }) => __sdocT.write('lessonData', dayOffPlanDocId(Y, c, 'TEST Taken'), { yearKey: Y, campId: c, projectTitle: 'TEST Taken', introPitch: 'TEST' }), { Y, c: camp.id });
./e2e/day-off-materials.spec.js:196:    r = await attempt(planner, ({ Y, cur, clash }) => saveDayOffCamp(Y, { ...cur, projects: clash }, cur), { Y, cur: current, clash });
./e2e/day-off-materials.spec.js:211:    r = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur, { confirmOrphans: async () => true }), { Y, cur: current, projects });
./e2e/day-off-materials.spec.js:218:    await planner.evaluate(({ Y, c }) => __sdocT.write('lessonData', dayOffSignoffDocId(Y, c), { yearKey: Y, campId: c, kind: 'campSignoff', projectTitle: '#signoff', complete: false }), { Y, c: camp.id });
./e2e/day-off-materials.spec.js:290:      await curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'TEST Late')).set({ yearKey: Y, campId: id, projectTitle: 'TEST Late', materialItems: { mlate: { name: 'TEST late', qty: 1, scope: 'class set', order: 0 } } });
./e2e/day-off-materials.spec.js:307:      await curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, window.__renameCamp, 'Clay Creatures')).update({ [`materialChecks.${window.__tickItem}`]: { by: 'TEST other tab', at: new Date().toISOString() } });
./e2e/day-off-materials.spec.js:311:    const r = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur), { Y, cur: current, projects });
./e2e/day-off-materials.spec.js:332:    r = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur, { confirmOrphans: async () => true }), { Y, cur: current, projects });
./e2e/day-off-materials.spec.js:340:  test('M14: ticking two items quickly saves both; a hand-made item key never reaches the page', async () => {
./e2e/day-off-materials.spec.js:345:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'Clay Creatures'))
./e2e/day-off-materials.spec.js:388:    await expect(row().locator('.sdoc-mi-name')).toHaveValue('');   // the draft cleared once saved
./e2e/day-off-materials.spec.js:395:      currentConfig.semesters.TEST_DATA_SAFETY_draft = { name: 'TEST Weekly Draft', semesterType: 'weekly', published: false, numWeeks: 2, classRoster: {} };
./e2e/day-off-materials.spec.js:403:        const teacherSees = Object.keys(currentConfig.semesters).filter(canSeeSemester);
./e2e/day-off-materials.spec.js:406:      } finally { delete currentConfig.semesters.TEST_DATA_SAFETY_draft; }
./e2e/day-off-materials.spec.js:556:      const signoffPath = await prep.evaluate(({ Y, c }) => `dayOffCamps_lessonData/${dayOffSignoffDocId(Y, c)}`, { Y, c: clay.id });
./e2e/day-off-materials.spec.js:681:      await planner.evaluate(({ Y, c, t, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, t))
./e2e/day-off-materials.spec.js:776:  const save = (page, camp, title, details, links, expected = { details: '', links: [] }) =>
./e2e/day-off-materials.spec.js:777:    attempt(page, ({ Y, c, t, details, links, expected }) => saveDayOffProjectDetails(Y, c, t, { details, links, expected, auth: { canPlan: canPlanDayOffCamps() } }), { Y, c: camp.id, t: title, details, links, expected });
./e2e/day-off-materials.spec.js:779:  test('D1: a planner saves a vision + two links from the popup — only the details fields (and identity/id) are written; materials, ticks and the sign-off are untouched', async () => {
./e2e/day-off-materials.spec.js:793:      await planner.click('#sdoc-details-save');
./e2e/day-off-materials.spec.js:810:  test('D2: typed details survive redraws, keep focus and caret, and survive a refused save; closing with only a link changed asks first', async () => {
./e2e/day-off-materials.spec.js:822:    // A refused save (bad link) keeps everything typed.
./e2e/day-off-materials.spec.js:824:    await planner.click('#sdoc-details-save');
./e2e/day-off-materials.spec.js:832:    // Only a link changed (vision back to saved = empty) still asks.
./e2e/day-off-materials.spec.js:842:  test('D3: validation before any write — bad schemes, too long, too many; duplicates dropped; a record-less links-only save creates only identity + links; both empty on a record-less project writes nothing', async () => {
./e2e/day-off-materials.spec.js:848:      const r = await save(planner, camp, 'Clay Creatures', details, links);
./e2e/day-off-materials.spec.js:855:      const r0 = await save(planner, camp, 'Glaze Day', '  ', ['  ']);
./e2e/day-off-materials.spec.js:860:    const r = await save(planner, camp, 'Clay Creatures', '', ['https://example.test/a', ' https://example.test/a ', 'https://example.test/b']);
./e2e/day-off-materials.spec.js:866:    const noAuth = await attempt(planner, ({ Y, c }) => saveDayOffProjectDetails(Y, c, 'Clay Creatures', { details: 'x', links: [], expected: { details: '', links: [] } }), { Y, c: camp.id });
./e2e/day-off-materials.spec.js:868:    const noExpected = await attempt(planner, ({ Y, c }) => saveDayOffProjectDetails(Y, c, 'Clay Creatures', { details: 'x', links: [], auth: { canPlan: true } }), { Y, c: camp.id });
./e2e/day-off-materials.spec.js:872:  test('D4: clearing everything removes both fields; a second save without reopening lands; another planner\'s change since open is refused and kept', async () => {
./e2e/day-off-materials.spec.js:876:    await planner.click('#sdoc-details-save');
./e2e/day-off-materials.spec.js:879:    await planner.click('#sdoc-details-save');
./e2e/day-off-materials.spec.js:885:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'Clay Creatures')).update({ projectLinks: ['https://example.test/theirs'] }), { Y, c: camp.id });
./e2e/day-off-materials.spec.js:888:    await planner.click('#sdoc-details-save');
./e2e/day-off-materials.spec.js:897:    await planner.click('#sdoc-details-save');
./e2e/day-off-materials.spec.js:904:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'Clay Creatures')).set({
./e2e/day-off-materials.spec.js:922:    expect((await save(planner, camp, 'Clay Creatures', 'TEST vision', ['https://example.test/a'])).ok).toBe(true);
./e2e/day-off-materials.spec.js:927:    await expect(prep.locator('#sdoc-details-save')).toHaveCount(0);
./e2e/day-off-materials.spec.js:976:    expect((await save(planner, camp, 'Glaze Day', '', ['https://example.test/only'])).ok).toBe(true);
./e2e/day-off-materials.spec.js:984:    const rr = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur), { Y, cur, projects });
./e2e/day-off-materials.spec.js:988:    // A plan save (2B's teacher path) may not carry details — refused by the allow-list before anything else.
./e2e/day-off-materials.spec.js:990:    const tr = await attempt(prep, ({ Y, c }) => saveSingleLesson(Y, dayOffLessonKey(Y, c, 'Clay Creatures'), { projectDetails: 'hijack' }, [], { dayOffAuth: { canEditAnywhere: true, hasClassbook: true, myTeacherName: null } }), { Y, c: camp.id });
./e2e/day-off-materials.spec.js:993:    const tl = await attempt(prep, ({ Y, c }) => saveSingleLesson(Y, dayOffLessonKey(Y, c, 'Clay Creatures'), { projectLinks: ['https://x.test'] }, [], { dayOffAuth: { canEditAnywhere: true, hasClassbook: true, myTeacherName: null } }), { Y, c: camp.id });
./e2e/day-off-materials.spec.js:1000:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'Clay Creatures')).set({
./e2e/day-off-materials.spec.js:1009:    const r = await attempt(planner, ({ Y, c }) => saveDayOffProjectDetails(Y, c, 'Clay Creatures', { details: 'x', links: [], expected: { details: '', links: [] }, auth: { canPlan: true } }), { Y, c: camp.id });
./e2e/day-off-materials.spec.js:1045:    const r = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur, { confirmOrphans: async (t) => { await window.__askedOrphans(JSON.stringify(t)); return false; } }), { Y, cur, projects });
./e2e/day-off-materials.spec.js:1053:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'n/a')).set({ yearKey: Y, campId: c, projectTitle: 'n/a', materialItems: { mstray0000001: { name: 'TEST stray', qty: 1, scope: 'class set', order: 0 } } }), { Y, c: c2.id });
./e2e/day-off-materials.spec.js:1055:    const r2 = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur), { Y, cur: cur2, projects: { '2026-12-21': { block1: 'Clay Creatures', block2: 'Glaze Art' } } });
./e2e/day-off-camps.spec.js:36:      const sld = window.saveLessonData, rsm = window.readServerSemesterLessonMap;
./e2e/day-off-camps.spec.js:37:      window.saveLessonData = async (...a) => { window.__lessonWrites++; return sld(...a); };
./e2e/day-off-camps.spec.js:53:      await page.waitForFunction((k) => !!currentConfig.semesters[k], KEY);
./e2e/day-off-camps.spec.js:58:        const d = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
./e2e/day-off-camps.spec.js:94:        delete currentConfig.semesters[k];
./e2e/day-off-camps.spec.js:115:  test('SDOC 3: an event is created, read back from the server, and a second client’s event survives this tab’s next save', async ({ page }) => {
./e2e/day-off-camps.spec.js:116:    const saved = await makeEvent(page);
./e2e/day-off-camps.spec.js:117:    const server = await page.evaluate(({ id }) => __sdocT.read('events', id), { id: saved.id });
./e2e/day-off-camps.spec.js:137:      const r = await attempt(page, ({ Y, input }) => saveDayOffEvent(Y, input, null), { Y, input: c.input });
./e2e/day-off-camps.spec.js:145:    const saved = await makeEvent(page, { notes: 'TEST keep me' });
./e2e/day-off-camps.spec.js:148:      const r = await attempt(page, ({ Y, saved }) => saveDayOffEvent(Y, { label: 'TEST Thanksgiving (renamed)', dates: saved.dates, district: '', notes: saved.notes }, saved), { Y, saved });
./e2e/day-off-camps.spec.js:155:    const server = await page.evaluate(({ id }) => __sdocT.read('events', id), { id: saved.id });
./e2e/day-off-camps.spec.js:178:    let r = await attempt(page, ({ Y, ev }) => saveDayOffEvent(Y, { ...ev, dates: ['2026-11-23', '2026-11-25'] }, ev), { Y, ev });
./e2e/day-off-camps.spec.js:181:    r = await attempt(page, ({ Y, ev }) => saveDayOffEvent(Y, { ...ev, dates: ['2026-11-23', '2026-11-24'] }, ev), { Y, ev });
./e2e/day-off-camps.spec.js:184:    r = await attempt(page, ({ Y, camp }) => saveDayOffCamp(Y, { ...camp, dates: ['2026-11-23'], projects: { '2026-11-23': ['Clay Creatures'] } }, camp), { Y, camp });
./e2e/day-off-camps.spec.js:221:      const r = await attempt(page, ({ Y, camp }) => saveDayOffCamp(Y, camp, null), { Y, camp });
./e2e/day-off-camps.spec.js:232:    await page.evaluate(({ Y, id, planId }) => __sdocT.write('lessonData', planId, { yearKey: Y, campId: id, projectTitle: 'Clay Creatures', introPitch: 'TEST pitch' }), { Y, id: camp.id, planId });
./e2e/day-off-camps.spec.js:235:    let r = await attempt(page, ({ Y, renamed, camp }) => saveDayOffCamp(Y, renamed, camp, { confirmOrphans: async () => { window.__asked = true; return false; } }), { Y, renamed, camp });
./e2e/day-off-camps.spec.js:239:    expect(await page.evaluate(({ planId }) => __sdocT.read('lessonData', planId), { planId })).toBeNull();
./e2e/day-off-camps.spec.js:240:    expect(await page.evaluate(({ newId }) => __sdocT.read('lessonData', newId), { newId })).toMatchObject({ introPitch: 'TEST pitch', projectTitle: 'Clay Critters' });
./e2e/day-off-camps.spec.js:245:    r = await attempt(page, ({ Y, removed, orig }) => saveDayOffCamp(Y, removed, orig, { confirmOrphans: async (plans) => { window.__asked = plans.map(p => p.projectTitle); return false; } }), { Y, removed, orig: { id: camp.id, ...current } });
./e2e/day-off-camps.spec.js:248:    r = await attempt(page, ({ Y, removed, orig }) => saveDayOffCamp(Y, removed, orig, { confirmOrphans: async () => true }), { Y, removed, orig: { id: camp.id, ...current } });
./e2e/day-off-camps.spec.js:250:    expect(await page.evaluate(({ newId }) => __sdocT.read('lessonData', newId), { newId })).toMatchObject({ introPitch: 'TEST pitch' });
./e2e/day-off-camps.spec.js:263:      const r = await attempt(page, ({ Y, shuffled, camp }) => saveDayOffCamp(Y, { ...camp, notes: 'TEST bring aprons' }, shuffled), { Y, shuffled, camp });
./e2e/day-off-camps.spec.js:282:      await page.evaluate(({ Y, id, planId, fields }) => __sdocT.write('lessonData', planId, { yearKey: Y, campId: id, projectTitle: 'Glaze Day', ...fields }), { Y, id: camp.id, planId, fields });
./e2e/day-off-camps.spec.js:287:      expect(await page.evaluate(({ planId }) => __sdocT.read('lessonData', planId), { planId })).not.toBeNull();
./e2e/day-off-camps.spec.js:295:    await page.evaluate(({ Y, id, planId }) => __sdocT.write('lessonData', planId, { yearKey: Y, campId: id, projectTitle: 'Glaze Day', introPitch: '  ', planComplete: false, materialsList: [], qaThread: [] }), { Y, id: camp.id, planId });
./e2e/day-off-camps.spec.js:299:    expect(await page.evaluate(({ planId }) => __sdocT.read('lessonData', planId), { planId })).toBeNull();
./e2e/day-off-camps.spec.js:312:    const r = await attempt(page, ({ Y, snap }) => saveDayOffEvent(Y, { ...snap, dates: ['2026-11-23', '2026-11-24', '2026-11-26'] }, snap), { Y, snap: staleSnapshot });
./e2e/day-off-camps.spec.js:326:    const r = await attempt(page, ({ Y, edited, stale }) => saveDayOffCamp(Y, edited, stale, { confirmOrphans: async () => true }), { Y, edited, stale });
./e2e/day-off-camps.spec.js:338:      await curriculumDb.collection('curriculum').doc('appData').update({ [`semesters.${Y}`]: currentConfig.semesters[Y] });
./e2e/day-off-camps.spec.js:348:      await page.evaluate(() => saveSettings());
./e2e/day-off-camps.spec.js:351:      expect(await page.evaluate((Y) => currentConfig.semesters[Y].teacherNames, Y)).toContain('TESTteacher1');
./e2e/day-off-camps.spec.js:363:      const realName = currentConfig.semesters[Y].name;
./e2e/day-off-camps.spec.js:370:        currentConfig.semesters[Y].name = 'TEST <img src=x onerror="window.__xss=1">';
./e2e/day-off-camps.spec.js:374:      } finally { window.getAuthUser = realUser; currentConfig.semesters[Y].name = realName; }
./e2e/day-off-camps.spec.js:401:      const realActive = currentConfig.activeSemester;
./e2e/day-off-camps.spec.js:404:        currentConfig.activeSemester = Y;   // unpublished
./e2e/day-off-camps.spec.js:407:        return { key: globalSemesterKey, published: currentConfig.semesters[globalSemesterKey]?.published };
./e2e/day-off-camps.spec.js:408:      } finally { window.getAuthUser = realUser; currentConfig.activeSemester = realActive; }
./e2e/day-off-camps.spec.js:414:  test('SDOC R7: the camp editor keeps a teacher this tab\'s list lacks, and the server\'s pool validates the save', async ({ page }) => {
./e2e/day-off-camps.spec.js:417:    // This tab loses TESTteacher1 from its list (an unsaved × in Settings, or a stale tab).
./e2e/day-off-camps.spec.js:418:    await page.evaluate((Y) => { currentConfig.semesters[Y].teacherNames = ['TESTteacher2']; setGlobalSemester(Y); }, Y);
./e2e/day-off-camps.spec.js:422:    await page.click('#sdoc-camp-save');
./e2e/day-off-camps.spec.js:423:    // The TEST year is not in server appData, so the in-tab pool is the fallback: the save is REFUSED
./e2e/day-off-camps.spec.js:445:  test('SDOC R9: a refused teacher removal restores only that name and keeps the rest of the unsaved form', async ({ page }) => {
./e2e/day-off-camps.spec.js:455:      await page.fill('#settings-semester-name', 'TEST renamed but unsaved');
./e2e/day-off-camps.spec.js:457:      await page.evaluate(() => saveSettings());
./e2e/day-off-camps.spec.js:459:      await expect(page.locator('#settings-semester-name')).toHaveValue('TEST renamed but unsaved');
./e2e/day-off-camps.spec.js:489:  test('SDOC S2: the footer Settings link refreshes the form too; returning for the SAME semester keeps unsaved edits; Save refuses a mismatched form', async ({ page }) => {
./e2e/day-off-camps.spec.js:501:    // Unsaved edit, away and back on the same semester → kept.
./e2e/day-off-camps.spec.js:510:      await page.evaluate(() => saveSettings());
./e2e/day-off-camps.spec.js:511:      expect(dialogs.pop()).toContain('nothing was saved');
./e2e/day-off-camps.spec.js:529:    await page.click('#sdoc-ev-save');
./e2e/day-off-camps.spec.js:556:    await page.click('#sdoc-camp-save');
./e2e/day-off-camps.spec.js:571:    await page.click('#sdoc-camp-save');
./e2e/day-off-camps.spec.js:578:  test('SDOC G1: a camp saves with its project blocks still empty; the list counts what is left; "—" marks a block unused', async ({ page }) => {
./e2e/day-off-camps.spec.js:586:    const r = await attempt(page, ({ Y, camp }) => saveDayOffCamp(Y, { ...camp, projects: { '2026-11-23': { block1: 'Clay Creatures', block2: '—', openStudio: 'Open Studio' } } }, camp), { Y, camp });
./e2e/day-off-camps.spec.js:595:  test('SDOC G2: a camp saved in the first-deploy shape (a list of titles per day) still reads, counts and edits correctly', async ({ page }) => {
./e2e/day-off-camps.spec.js:606:      const r = await attempt(page, ({ Y, original }) => saveDayOffCamp(Y, { ...original, notes: 'TEST note' }, original), { Y, original });
./e2e/day-off-camps.spec.js:613:  test('SDOC G3: clicking beside the camp editor keeps it open; × with unsaved changes asks before discarding', async ({ page }) => {
./e2e/day-off-camps.spec.js:648:      await page.evaluate(() => saveSettings());
./e2e/day-off-camps.spec.js:655:      await page.evaluate(() => saveSettings());
./e2e/day-off-camps.spec.js:662:      await page.evaluate(() => saveSettings());
./e2e/day-off-camps.spec.js:663:      expect(dialogs.pop()).toContain('Settings saved');
./e2e/day-off-camps.spec.js:683:    expect(await page.evaluate((Y) => currentConfig.semesters[Y].published, Y)).toBe(false);
./e2e/day-off-camps.spec.js:700:      await tryIt('saveLessonData', () => saveLessonData(Y, { a: { introPitch: 'x' } }));
./e2e/day-off-camps.spec.js:701:      await tryIt('saveSingleLesson', () => saveSingleLesson(Y, `${Y}|||c|||p`, { introPitch: 'x' }));   // SDOC branch: no such project, no dayOffAuth
./e2e/day-off-camps.spec.js:706:      const lessonDoc = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
./e2e/day-off-camps.spec.js:711:    expect(results.saveLessonData).toContain('refuses to read or write');
./e2e/day-off-camps.spec.js:712:    expect(results.saveSingleLesson).not.toBe('ok');
./e2e/day-off-camps.spec.js:731:        const guard = lessonDataLoadedSuccessfully;
./e2e/day-off-camps.spec.js:733:        try { await saveDayOffEvent(Y, { label: 'TEST x', dates: ['2026-10-12'] }); writer = 'ok'; } catch (e) { writer = e.message; }
./e2e/day-off-camps.spec.js:742:    expect(await page.evaluate(() => lessonDataLoadedSuccessfully)).toBe(true);
./e2e/fixtures/seed/curriculum.json:59:  "lessonData": {
./e2e/data-safety.spec.js:14: *   Test 4 → PASS  (Stage 1A: save guard deployed)
./e2e/data-safety.spec.js:37:// saveSingleLesson and openLessonDetailModal are `async function` / `function` declarations
./e2e/data-safety.spec.js:55:// Open the summer lesson EDIT modal (the one with #summer-lesson-save and the
./e2e/data-safety.spec.js:62:  await page.waitForSelector('#summer-lesson-save', { state: 'visible', timeout: 8_000 });
./e2e/data-safety.spec.js:80:    // Simulate a save that only includes processStep2 (other content fields empty —
./e2e/data-safety.spec.js:83:      await saveSingleLesson('summer-2026', key, {
./e2e/data-safety.spec.js:94:    const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:95:    expect(saved.introPitch).toBe('ORIGINAL intro pitch — must survive');
./e2e/data-safety.spec.js:96:    expect(saved.processStep1).toBe('ORIGINAL step 1 — must survive');
./e2e/data-safety.spec.js:97:    expect(saved.processStep2).toBe('New step 2 typed by teacher');
./e2e/data-safety.spec.js:110:    // All content fields empty → hasContent guard blocks the save entirely
./e2e/data-safety.spec.js:112:      await saveSingleLesson('summer-2026', key, {
./e2e/data-safety.spec.js:123:    const saved = await readTestDoc(BETA_KEY);
./e2e/data-safety.spec.js:124:    expect(saved.introPitch).toBe('Content that must not be wiped');
./e2e/data-safety.spec.js:136:// Instead, we test the mechanism directly: set lessonDataLoadedSuccessfully=false
./e2e/data-safety.spec.js:138:// and verify the banner shows and saves are blocked.
./e2e/data-safety.spec.js:161:    lessonDataLoadedSuccessfully = false;
./e2e/data-safety.spec.js:165:// Stops the curriculum/lessonData listener so it cannot overwrite injected
./e2e/data-safety.spec.js:171:// lessonDataUnsubscribe / globalListenerGeneration are `let`s in
./e2e/data-safety.spec.js:175:    if (typeof lessonDataUnsubscribe === 'function') lessonDataUnsubscribe();
./e2e/data-safety.spec.js:198:  test('Test 4: when load failed, saveSingleLesson is blocked — existing content survives', async ({ browser }) => {
./e2e/data-safety.spec.js:209:      // Attempt a save — the flag guard must block it by THROWING, not silently
./e2e/data-safety.spec.js:212:      // callers proceed as if the save succeeded — this is the assertion that
./e2e/data-safety.spec.js:218:          await saveSingleLesson('summer-2026', key, {
./e2e/data-safety.spec.js:230:      const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:231:      expect(saved.introPitch).toBe('Must not be touched during failed load');
./e2e/data-safety.spec.js:246:// (e.g. by auto-save, a Firestore listener, or another tab's save), pressing
./e2e/data-safety.spec.js:250:// as its base — same as the save button and auto-save already did.
./e2e/data-safety.spec.js:257://      sentinel value (mimics what auto-save or another tab would do).
./e2e/data-safety.spec.js:285:    // that after the save; the emulator's ~300 ms boot does not.
./e2e/data-safety.spec.js:289:    // currentLessonData and lessonDataLoadedSuccessfully are `let` variables in firebase-data.js.
./e2e/data-safety.spec.js:302:    // Ensures openTeacherEditModal and saveSingleLesson both use 'summer-2026'.
./e2e/data-safety.spec.js:325:    // Set save guard flag (let binding — no window. prefix).
./e2e/data-safety.spec.js:326:    // saveSingleLesson only blocks when === false; null and true both allow saves.
./e2e/data-safety.spec.js:327:    await page.evaluate(() => { lessonDataLoadedSuccessfully = true; });
./e2e/data-safety.spec.js:338:    // Mimics what a Firestore listener or another tab's save would do.
./e2e/data-safety.spec.js:340:    // entirely from originalLesson in saveTeacherEdit. Stale base → old value survives.
./e2e/data-safety.spec.js:345:    // Type into a content field so changedFields is non-empty and the save isn't skipped.
./e2e/data-safety.spec.js:346:    // (saveTeacherEdit returns early if nothing changed in the form.)
./e2e/data-safety.spec.js:356:    const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:359:    //   hasDetails:true (background update) survives in the saved doc
./e2e/data-safety.spec.js:362:    expect(saved.hasDetails).toBe(true);
./e2e/data-safety.spec.js:363:    expect(saved.introPitch).toBe('Typed by teacher');
./e2e/data-safety.spec.js:387:    // { planComplete } to saveSingleLesson — never the full (possibly stale)
./e2e/data-safety.spec.js:390:      await saveSingleLesson('summer-2026', key, { planComplete: true });
./e2e/data-safety.spec.js:393:    const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:396:    // it blocks the write entirely instead of letting a narrow save through.
./e2e/data-safety.spec.js:397:    expect(saved.planComplete).toBe(true);
./e2e/data-safety.spec.js:400:    expect(saved.photoUrl).toBe('https://example.com/test-photo.jpg');
./e2e/data-safety.spec.js:413:    // NOTE: this does NOT check Firestore's photoUrl field — saveLesson()'s
./e2e/data-safety.spec.js:443:    await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:451:    // (true today only because the save's catch-block skips the write on error —
./e2e/data-safety.spec.js:453:    const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:454:    expect(saved.photoUrl).toBe('https://example.com/original-photo.jpg');
./e2e/data-safety.spec.js:466:// 2B: swap — two targeted saveSingleLesson calls instead of one full-semester
./e2e/data-safety.spec.js:467://     saveLessonData bulk overwrite; roll back on partial failure.
./e2e/data-safety.spec.js:468:// saveAdminEdit — same bulk-overwrite risk as swap (copies the ENTIRE local
./e2e/data-safety.spec.js:469://     semester through saveLessonData's recursive merge); targeted save instead.
./e2e/data-safety.spec.js:471:// All three operate on the non-summer curriculum/lessonData shared doc — the
./e2e/data-safety.spec.js:473:// handleGridAction/saveAdminEdit for that semester (see renderAdminGrid()).
./e2e/data-safety.spec.js:513:  // flip lessonDataLoadedSuccessfully back to true under a test that has just
./e2e/data-safety.spec.js:518:    lessonDataLoadedSuccessfully = true;
./e2e/data-safety.spec.js:605:      // saveMultipleLessonFields — overriding it (a function declaration on
./e2e/data-safety.spec.js:609:        window.saveMultipleLessonFields = async () => { throw new Error('Simulated network failure'); };
./e2e/data-safety.spec.js:671:  test('Swap with both slots occupied uses two targeted saves — an unrelated stale canary is untouched', async ({ browser }) => {
./e2e/data-safety.spec.js:737:    // saveMultipleLessonFields — there is no longer a "first succeeds, second
./e2e/data-safety.spec.js:740:      window.saveMultipleLessonFields = async () => { throw new Error('Simulated atomic write failure'); };
./e2e/data-safety.spec.js:766:  // stubs out saveMultipleLessonFields() entirely, so it only proves the JS
./e2e/data-safety.spec.js:771:  // same load guard saveMultipleLessonFields() itself checks — not a stub),
./e2e/data-safety.spec.js:799:      // Trip the REAL guard saveMultipleLessonFields() itself checks — a
./e2e/data-safety.spec.js:803:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; });
./e2e/data-safety.spec.js:892:        window.saveMultipleLessonFields = async () => { throw new Error('Simulated atomic write failure'); };
./e2e/data-safety.spec.js:923:test.describe('Data Safety — Admin grid safety (Phase 1: saveAdminEdit)', () => {
./e2e/data-safety.spec.js:925:  test('saveAdminEdit writes a single targeted lesson — a stale canary elsewhere in the semester survives', async ({ browser }) => {
./e2e/data-safety.spec.js:949:      ({ key, teacher, className, weekNum }) => saveAdminEdit(key, teacher, className, weekNum),
./e2e/data-safety.spec.js:964:  test('saveAdminEdit(): when load failed, the guard fires before any photo Storage mutation — existing content survives', async ({ browser }) => {
./e2e/data-safety.spec.js:998:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; });
./e2e/data-safety.spec.js:1001:        ({ key, teacher, className, weekNum }) => saveAdminEdit(key, teacher, className, weekNum),
./e2e/data-safety.spec.js:1020:  // above only exercises the EARLY guard path (tripped before saveAdminEdit()
./e2e/data-safety.spec.js:1023:  // mid-operation failure (a save that throws for a real reason, after work has
./e2e/data-safety.spec.js:1025:  test('saveAdminEdit(): a genuine save failure (not a guard trip) does not commit local state, close the modal, or log a fake edit', async ({ browser }) => {
./e2e/data-safety.spec.js:1039:      // Seed local state too (showAdminEdit()/saveAdminEdit() both read
./e2e/data-safety.spec.js:1059:      // Force a genuine (non-guard) failure — saveSingleLesson() is called
./e2e/data-safety.spec.js:1060:      // unqualified inside saveAdminEdit(), so it resolves through window
./e2e/data-safety.spec.js:1062:      // tests already use for saveMultipleLessonFields).
./e2e/data-safety.spec.js:1064:        window.saveSingleLesson = async () => { throw new Error('Simulated genuine save failure — not a guard trip'); };
./e2e/data-safety.spec.js:1068:        ({ key, teacher, className, weekNum }) => saveAdminEdit(key, teacher, className, weekNum),
./e2e/data-safety.spec.js:1073:      expect(alerts.some(m => /could not be saved/i.test(m))).toBe(true);
./e2e/data-safety.spec.js:1076:      // Firestore was never touched (saveSingleLesson threw before any write)...
./e2e/data-safety.spec.js:1094:      // actually saved.
./e2e/data-safety.spec.js:1107:  // checklist requirement, never actually written): the delete-after-save
./e2e/data-safety.spec.js:1110:  // the Firestore save then fails. Without this, a regression that moved the
./e2e/data-safety.spec.js:1113:  test('saveAdminEdit(): a real photo upload followed by a genuine save failure never deletes the old photo', async ({ browser }) => {
./e2e/data-safety.spec.js:1156:        window.saveSingleLesson = async () => { throw new Error('Simulated genuine save failure after a real upload'); };
./e2e/data-safety.spec.js:1160:        ({ key, teacher, className, weekNum }) => saveAdminEdit(key, teacher, className, weekNum),
./e2e/data-safety.spec.js:1165:      // The old photo must never be deleted — the delete step in saveAdminEdit()
./e2e/data-safety.spec.js:1166:      // only runs after a CONFIRMED save, which never happened here.
./e2e/data-safety.spec.js:1183://     local photoUrl/content field is never touched, on both save paths.
./e2e/data-safety.spec.js:1184:// 2D: non-summer saveSingleLesson gets the same content-field stripping the
./e2e/data-safety.spec.js:1223:    await page.waitForTimeout(2000); // the change listener's save is async/fire-and-forget from dispatchEvent's perspective
./e2e/data-safety.spec.js:1225:    const saved = await readTestLesson(TEST_SEM, key);
./e2e/data-safety.spec.js:1226:    expect(saved?.planComplete).toBe(true);
./e2e/data-safety.spec.js:1227:    expect(saved?.photoUrl).toBe('https://example.com/must-survive.jpg');
./e2e/data-safety.spec.js:1235:test.describe('Data Safety — Non-summer save stripping (Phase 2: 2D)', () => {
./e2e/data-safety.spec.js:1237:  test('Non-summer saveSingleLesson strips empty content fields via per-field paths — siblings and the rest of the lesson survive', async ({ browser }) => {
./e2e/data-safety.spec.js:1255:      return saveSingleLesson(semKey, key, {
./e2e/data-safety.spec.js:1266:    const saved = await readTestLesson(TEST_SEM, key);
./e2e/data-safety.spec.js:1267:    expect(saved?.introPitch).toBe('ORIGINAL intro — must survive');
./e2e/data-safety.spec.js:1268:    expect(saved?.processStep1).toBe('ORIGINAL step1 — must survive');
./e2e/data-safety.spec.js:1269:    expect(saved?.processStep2).toBe('New step 2 typed by teacher');
./e2e/data-safety.spec.js:1273:    expect(saved?.photoUrl).toBe('https://example.com/must-survive.jpg');
./e2e/data-safety.spec.js:1274:    expect(saved?.projectTitle).toBe('TEST Stripping Non-Summer');
./e2e/data-safety.spec.js:1282:// ─── Phase 3 (Classbook Data Safety — remaining stages plan): Post-save read-back
./e2e/data-safety.spec.js:1285:// After every summer-path saveSingleLesson write, read the content fields
./e2e/data-safety.spec.js:1305:      const docRef = curriculumDb.collection('summerCamps_lessonData').doc(encodeFirestoreKey(key));
./e2e/data-safety.spec.js:1351:  test('A normal successful save with real content passes verification without throwing', async ({ browser }) => {
./e2e/data-safety.spec.js:1357:      await saveSingleLesson('summer-2026', key, { introPitch: 'Real content', processStep1: 'Real step 1' });
./e2e/data-safety.spec.js:1360:    const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:1361:    expect(saved.introPitch).toBe('Real content');
./e2e/data-safety.spec.js:1362:    expect(saved.processStep1).toBe('Real step 1');
./e2e/data-safety.spec.js:1394:    await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:1398:    await expect(page.locator('#summer-autosave-status')).toContainText('cleared', { timeout: 8_000 });
./e2e/data-safety.spec.js:1399:    const statusText = await page.locator('#summer-autosave-status').textContent();
./e2e/data-safety.spec.js:1402:    const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:1403:    expect(saved.introPitch).toBeUndefined(); // genuinely deleted, not an empty string
./e2e/data-safety.spec.js:1404:    expect(saved.processStep1).toBe('UNTOUCHED — must survive');
./e2e/data-safety.spec.js:1405:    expect(saved.processStep3).toBeUndefined(); // never touched — still absent, not created as ''
./e2e/data-safety.spec.js:1434:    await page.click('#te-save-btn');
./e2e/data-safety.spec.js:1438:    await expect(page.locator('#te-autosave-status')).toContainText('cleared', { timeout: 8_000 });
./e2e/data-safety.spec.js:1439:    const statusText = await page.locator('#te-autosave-status').textContent();
./e2e/data-safety.spec.js:1442:    const saved = await readTestLesson(TEST_SEM, key);
./e2e/data-safety.spec.js:1443:    expect(saved?.introPitch).toBeUndefined(); // genuinely deleted, not an empty string
./e2e/data-safety.spec.js:1444:    expect(saved?.processStep1).toBe('UNTOUCHED — must survive');
./e2e/data-safety.spec.js:1445:    expect(saved?.processStep3).toBeUndefined(); // never touched — still absent, not created as ''
./e2e/data-safety.spec.js:1465:      await saveSingleLesson('summer-2026', key, {
./e2e/data-safety.spec.js:1467:        processStep2: 'New content typed this save',
./e2e/data-safety.spec.js:1471:    const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:1472:    expect(saved.introPitch).toBeUndefined();
./e2e/data-safety.spec.js:1473:    expect(saved.processStep1).toBe('Real content that stays');
./e2e/data-safety.spec.js:1474:    expect(saved.processStep2).toBe('New content typed this save');
./e2e/data-safety.spec.js:1486:  test('a save that wipes a large field is flagged as a potential wipe, and a normal edit on another field is not', async ({ browser }) => {
./e2e/data-safety.spec.js:1510:    await page.click('#te-save-btn');
./e2e/data-safety.spec.js:1511:    await expect(page.locator('#te-autosave-status')).toContainText('cleared', { timeout: 8_000 });
./e2e/data-safety.spec.js:1656:        errorCollections: ['summerCamps_lessonData'],
./e2e/data-safety.spec.js:1662:    expect(text).toContain('Errors backing up: summerCamps_lessonData');
./e2e/data-safety.spec.js:1845:// ─── Backtracking audit Phase 8: saveTeacherEdit() log-after-save,
./e2e/data-safety.spec.js:1849:test.describe('Data Safety — saveTeacherEdit() log ordering (Backtracking audit Phase 8)', () => {
./e2e/data-safety.spec.js:1851:  test('a log-only failure after a successful save does not report "Save failed"', async ({ browser }) => {
./e2e/data-safety.spec.js:1866:      // teOriginalData and the #te-* DOM fields saveTeacherEdit() reads.
./e2e/data-safety.spec.js:1872:      // function saveSingleLesson() does NOT call, so overriding it cannot
./e2e/data-safety.spec.js:1873:      // mask a save failure; this exercises the real save path in full and
./e2e/data-safety.spec.js:1879:      await page.locator('#te-save-btn').click();
./e2e/data-safety.spec.js:1883:        () => document.getElementById('te-autosave-status')?.textContent || ''
./e2e/data-safety.spec.js:1885:      expect(statusText).not.toMatch(/save failed/i);
./e2e/data-safety.spec.js:1887:      // The save itself must have genuinely landed despite the log failure.
./e2e/data-safety.spec.js:1888:      const saved = await readTestLesson(TEST_SEM, lessonKey);
./e2e/data-safety.spec.js:1889:      expect(saved?.projectTitle).toBe('TEST Teacher Edit Log Ordering (edited)');
./e2e/data-safety.spec.js:1993:      // curriculum/lessonData first (the existence check), which must keep
./e2e/data-safety.spec.js:2016:      expect(alerts.some(m => /could not be saved/i.test(m))).toBe(true);
./e2e/data-safety.spec.js:2102:  test('pasteFromCutBank(): a targeted single-lesson save — an unrelated canary lesson elsewhere in the semester survives', async ({ browser }) => {
./e2e/data-safety.spec.js:2339:  test('deleteCutProject(): removes via arrayRemove(), not saveCutProjects() — and survives a concurrent cutProject() append', async ({ browser }) => {
./e2e/data-safety.spec.js:2428:// {projects:[...]} wrapper into saveFutureProjects() instead of the bare
./e2e/data-safety.spec.js:2431:// from the bank BEFORE the destination lesson save is even confirmed.
./e2e/data-safety.spec.js:2453:                // SAME live array saveFutureProjects() was called with, which
./e2e/data-safety.spec.js:2503:  test('a lesson-save failure leaves the idea untouched in the bank — removal never happens before the paste is confirmed (R3-11)', async ({ browser }) => {
./e2e/data-safety.spec.js:2516:        window.saveSingleLesson = async () => { throw new Error('Simulated lesson save failure'); };
./e2e/data-safety.spec.js:2527:      expect(writes.length).toBe(0); // idea removal never attempted — lesson save must succeed first
./e2e/data-safety.spec.js:2538:  test('an idea-removal failure after a successful lesson save gives an honest "may now appear in both places" message, not a false success (R3-11)', async ({ browser }) => {
./e2e/data-safety.spec.js:2559:      expect(pasted?.projectTitle).toBe('TEST Idea Removal Fails'); // lesson save genuinely succeeded
./e2e/data-safety.spec.js:2568:  test('a targeted single-lesson save — a FRESH server-side canary survives even though the local cache holds a STALE copy', async ({ browser }) => {
./e2e/data-safety.spec.js:2572:      // Server and cache deliberately DIVERGE: a bulk saveLessonData()-style
./e2e/data-safety.spec.js:2712:      await page.waitForTimeout(1500); // photo delete is a separate awaited call after the Firestore save
./e2e/data-safety.spec.js:2727:  test('two ideas pasted while the first is still awaiting its lesson save both end up removed from the bank exactly once (implementation-review finding: index race)', async ({ browser }) => {
./e2e/data-safety.spec.js:2744:      // inside saveSingleLesson() until B has entered its OWN wrapped call
./e2e/data-safety.spec.js:2748:      // saveFutureProjects() call (A's removal step, the LOWER index) has
./e2e/data-safety.spec.js:2761:        const realSaveSingleLesson = window.saveSingleLesson;
./e2e/data-safety.spec.js:2762:        window.saveSingleLesson = async (...args) => {
./e2e/data-safety.spec.js:2768:        const realSaveFutureProjects = window.saveFutureProjects;
./e2e/data-safety.spec.js:2769:        window.saveFutureProjects = async (...args) => {
./e2e/data-safety.spec.js:2849:// Today's real bug: sendHelpResponse()/sendQaReply() resave the admin's ENTIRE
./e2e/data-safety.spec.js:2850:// cached semester via saveLessonData() (a Firestore set({merge:true}) of every
./e2e/data-safety.spec.js:2852:// replied to. A live onSnapshot listener normally keeps that cache fresh, but
./e2e/data-safety.spec.js:2854:// exactly what a real, narrow production race looks like: a teacher's save
./e2e/data-safety.spec.js:2862:  test('sendQaReply() does not revert a concurrently-saved OTHER lesson in the same semester', async ({ browser }) => {
./e2e/data-safety.spec.js:2884:      // Simulate a concurrent teacher save landing on the SERVER for the
./e2e/data-safety.spec.js:2906:  test('sendHelpResponse() does not revert a concurrently-saved OTHER lesson in the same semester', async ({ browser }) => {
./e2e/data-safety.spec.js:2949:  test('sendQaReply() routes a summer-semester reply to summerCamps_lessonData, not curriculum/lessonData', async ({ browser }) => {
./e2e/data-safety.spec.js:2978:      expect(nonSummerDoc).toBeNull(); // must NOT have landed in curriculum/lessonData under a 'summer-2026' key
./e2e/data-safety.spec.js:3079:          await curriculumDb.collection('curriculum').doc('lessonData').update({
./e2e/data-safety.spec.js:3100:  test('sendHelpResponse() routes a summer-semester reply to summerCamps_lessonData, not curriculum/lessonData', async ({ browser }) => {
./e2e/data-safety.spec.js:3134:      expect(nonSummerDoc).toBeNull(); // must NOT have landed in curriculum/lessonData under a 'summer-2026' key
./e2e/data-safety.spec.js:3203:          await curriculumDb.collection('curriculum').doc('lessonData').update({
./e2e/data-safety.spec.js:3231:// save (so a failed save left Firestore pointing at a photo that no longer
./e2e/data-safety.spec.js:3235:// suffix), and every call site captures the OLD path first, saves, then
./e2e/data-safety.spec.js:3236:// deletes the old path only after the confirmed save and only if different.
./e2e/data-safety.spec.js:3251:// which would stall the save instead of letting the test observe it).
./e2e/data-safety.spec.js:3269:test.describe('Data Safety — photo upload paths and delete-after-save (Backtracking audit Phase 5)', () => {
./e2e/data-safety.spec.js:3304:  test('summer modal: replacing a photo uploads to a NEW path, saves, then deletes the OLD path — never the one it just uploaded', async ({ browser }) => {
./e2e/data-safety.spec.js:3317:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:3318:      // Wait for the save to conclude either way, then assert it succeeded —
./e2e/data-safety.spec.js:3320:      await page.waitForFunction(() => /Saved!/.test(document.getElementById('summer-lesson-save')?.textContent || '') || /Save failed/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 20_000 });
./e2e/data-safety.spec.js:3321:      const status = await page.evaluate(() => document.getElementById('summer-autosave-status')?.textContent || '');
./e2e/data-safety.spec.js:3324:      const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:3326:      expect(saved.photoPath).toMatch(new RegExp('^summerCamps/' + ALPHA_KEY.replace(/[.*+?^${}()|[\]\\]/g, '\\$&') + '/demo-[^/]+\\.jpg$'));
./e2e/data-safety.spec.js:3327:      expect(saved.photoPath).not.toBe(OLD_PATH);
./e2e/data-safety.spec.js:3329:      expect(traffic.uploads.map(u => u.path)).toEqual([saved.photoPath]);
./e2e/data-safety.spec.js:3338:  test('summer modal: when the Firestore save fails after a successful upload, the old photo is NOT deleted and Firestore still points at it', async ({ browser }) => {
./e2e/data-safety.spec.js:3352:      await page.evaluate(() => { window.saveSingleLesson = async () => { throw new Error('TEST simulated save failure after a real upload'); }; });
./e2e/data-safety.spec.js:3353:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:3354:      await page.waitForFunction(() => /Save failed/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 20_000 });
./e2e/data-safety.spec.js:3359:      const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:3360:      expect(saved.photoPath).toBe(OLD_PATH);           // Firestore still points at the old, still-existing photo
./e2e/data-safety.spec.js:3361:      expect(saved.photoUrl).toBe('https://example.com/old.jpg');
./e2e/data-safety.spec.js:3368:  test('summer modal: after a photo is saved, a later autosave (typing) does NOT re-upload it — the pending selection is cleared on success', async ({ browser }) => {
./e2e/data-safety.spec.js:3380:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:3381:      await page.waitForFunction(() => /Saved!/.test(document.getElementById('summer-lesson-save')?.textContent || ''), { timeout: 20_000 });
./e2e/data-safety.spec.js:3385:      // Now type — the modal autosaves 2 s after typing stops. Wait for THAT
./e2e/data-safety.spec.js:3386:      // save to land on the server (poll, not a fixed sleep — a slow Firestore
./e2e/data-safety.spec.js:3388:      await page.locator('#summer-intro-pitch').fill('Typed after the photo save');
./e2e/data-safety.spec.js:3390:        .toBe('Typed after the photo save');
./e2e/data-safety.spec.js:3391:      await page.waitForTimeout(500); // let any (wrong) photo work started by that autosave surface
./e2e/data-safety.spec.js:3403:  test('saveAdminEdit(): a successful replacement deletes the OLD path after the save; Firestore records the new unique path', async ({ browser }) => {
./e2e/data-safety.spec.js:3421:      // Stamp the moment the REAL save resolves, so "delete after save" is
./e2e/data-safety.spec.js:3424:        const real = window.saveSingleLesson;
./e2e/data-safety.spec.js:3425:        window.__saveResolvedAt = null;
./e2e/data-safety.spec.js:3426:        window.saveSingleLesson = async (...args) => { const r = await real(...args); window.__saveResolvedAt = Date.now(); return r; };
./e2e/data-safety.spec.js:3428:      await page.evaluate(({ key, teacher, className, weekNum }) => saveAdminEdit(key, teacher, className, weekNum), { key: editKey, teacher: 'TESTteacher', className: 'TESTclass', weekNum: 8 });
./e2e/data-safety.spec.js:3430:      const saveResolvedAt = await page.evaluate(() => window.__saveResolvedAt);
./e2e/data-safety.spec.js:3432:      const saved = await readTestLesson(TEST_SEM, editKey);
./e2e/data-safety.spec.js:3433:      expect(saved?.photoPath).toMatch(new RegExp(`^curriculum/${TEST_SEM}/${editKey}/demo-[^/]+\\.jpg$`));
./e2e/data-safety.spec.js:3434:      expect(saved?.photoPath).not.toBe(OLD_PATH);
./e2e/data-safety.spec.js:3435:      expect(traffic.uploads.map(u => u.path)).toEqual([saved.photoPath]);
./e2e/data-safety.spec.js:3437:      // The old object was deleted only AFTER the Firestore save resolved.
./e2e/data-safety.spec.js:3438:      expect(saveResolvedAt).not.toBeNull();
./e2e/data-safety.spec.js:3439:      expect(traffic.deletes[0].at).toBeGreaterThanOrEqual(saveResolvedAt);
./e2e/data-safety.spec.js:3450:// Copy Plan resaved the ENTIRE cached semester via saveLessonData() — any
./e2e/data-safety.spec.js:3451:// lesson whose local copy was stale (a teacher's concurrent save in another
./e2e/data-safety.spec.js:3455:// after a single bulk save, so a failure part-way lost the log for targets
./e2e/data-safety.spec.js:3456:// that had actually been written. Fix: per-target saveSingleLesson() with an
./e2e/data-safety.spec.js:3459:// after its own save resolves, log each target immediately, and report an
./e2e/data-safety.spec.js:3492:  test('R3-12: per-target, fields-only saves — a FRESH server canary survives a STALE local copy (across lessons AND within the target), a source-empty field clears the target\'s stale value, and the cleared text is preserved in Change History even when a log write fails', async ({ browser }) => {
./e2e/data-safety.spec.js:3506:      const canaryFresh = testLesson({ weekNum: 15, projectTitle: 'TEST Copy Canary', introPitch: 'FRESH canary — saved by a teacher in another tab' });
./e2e/data-safety.spec.js:3542:      // Both copies count as saved despite A's log failure.
./e2e/data-safety.spec.js:3551:      const saved = await readTestLesson(TEST_SEM, TARGET_A);
./e2e/data-safety.spec.js:3552:      expect(saved?.introPitch).toBe('SRC intro');
./e2e/data-safety.spec.js:3553:      expect(saved?.materials).toBe('SRC materials');
./e2e/data-safety.spec.js:3555:      // cleared (absent or empty), not left behind by the strip-empties save.
./e2e/data-safety.spec.js:3556:      expect(saved?.processStep1 || '').toBe('');
./e2e/data-safety.spec.js:3559:      expect(saved?.photoUrl).toBe('https://example.com/FRESH-from-teacher.jpg');
./e2e/data-safety.spec.js:3560:      expect(saved?.projectTitle).toBe('TEST Copy Target');
./e2e/data-safety.spec.js:3563:      const savedB = await readTestLesson(TEST_SEM, TARGET_B);
./e2e/data-safety.spec.js:3564:      expect(savedB?.introPitch).toBe('SRC intro');
./e2e/data-safety.spec.js:3565:      expect(savedB?.processStep2 || '').toBe('');
./e2e/data-safety.spec.js:3568:      expect(canaryAfter?.introPitch).toBe('FRESH canary — saved by a teacher in another tab');
./e2e/data-safety.spec.js:3569:      // Cache committed for the target after its save.
./e2e/data-safety.spec.js:3576:  // The plan's BDD scenario verbatim: 5 targets, the 3rd save fails.
./e2e/data-safety.spec.js:3577:  test('R3-13: 5 targets, the 3rd save fails — targets 1-2 are saved AND logged (each before the next save), 3-5 are untouched in cache and on the server, saved targets are unchecked, and the admin gets an honest count', async ({ browser }) => {
./e2e/data-safety.spec.js:3601:        const events = []; // ONE ordered stream — proves log(A) happens before save(B)
./e2e/data-safety.spec.js:3604:        const originalSingle = window.saveSingleLesson, originalBulk = window.saveLessonData;
./e2e/data-safety.spec.js:3608:        // Real targeted save for every key except the designated failure.
./e2e/data-safety.spec.js:3609:        window.saveSingleLesson = async (sem, key, data, clear) => {
./e2e/data-safety.spec.js:3610:          events.push(`save:${key}`);
./e2e/data-safety.spec.js:3611:          if (key === failKey) throw new Error('TEST simulated save failure');
./e2e/data-safety.spec.js:3615:        window.saveLessonData = async () => { events.push('BULK'); throw new Error('TEST bulk save must not be called'); };
./e2e/data-safety.spec.js:3623:          window.saveSingleLesson = originalSingle; window.saveLessonData = originalBulk;
./e2e/data-safety.spec.js:3636:      expect(result.alerts.some(a => /Copied to 2 of 5/.test(a) && /TEST simulated save failure/.test(a))).toBe(true);
./e2e/data-safety.spec.js:3639:      expect(result.events).toEqual([`save:${TARGET_A}`, 'log:12', `save:${TARGET_B}`, 'log:13', `save:${TARGET_C}`]);
./e2e/data-safety.spec.js:3640:      // R3-13: no target's shared cache object was mutated ahead of its save.
./e2e/data-safety.spec.js:3662:// saveSettings() calls this unconditionally after every Settings save. Two
./e2e/data-safety.spec.js:3663:// real bugs: (R4-9) no summer gate at all — a Settings save while viewing the
./e2e/data-safety.spec.js:3669:// anything persisted, so a failed save left a phantom empty semester in the
./e2e/data-safety.spec.js:3679:  // Runs createLessonSlotsForRoster() with saveLessonData() replaced by a
./e2e/data-safety.spec.js:3683:      const saves = [];
./e2e/data-safety.spec.js:3684:      const originalSave = window.saveLessonData;
./e2e/data-safety.spec.js:3685:      window.saveLessonData = async (k, lessons) => {
./e2e/data-safety.spec.js:3686:        saves.push({ semKey: k, keys: Object.keys(lessons).sort() });
./e2e/data-safety.spec.js:3687:        if (throwOnSave) throw new Error('TEST simulated saveLessonData failure');
./e2e/data-safety.spec.js:3697:        window.saveLessonData = originalSave;
./e2e/data-safety.spec.js:3700:        saves, threw, hadKeyBefore,
./e2e/data-safety.spec.js:3714:      const semType = await page.evaluate(() => currentConfig?.semesters?.['summer-2026']?.semesterType);
./e2e/data-safety.spec.js:3719:      expect(r.saves).toEqual([]);
./e2e/data-safety.spec.js:3734:        currentConfig.semesters[semKey] = { name: 'Summer Enrichment 2027', numWeeks: 2, classRoster: {} }; // no semesterType
./e2e/data-safety.spec.js:3739:      expect(r.saves).toEqual([{ semKey, keys: [SLOT_1, SLOT_2] }]);
./e2e/data-safety.spec.js:3746:  test('R4-12: when the save fails for a semester with no cached lesson data, the error propagates (no internal catch) and NO phantom empty semester key is left in the cache', async ({ browser }) => {
./e2e/data-safety.spec.js:3756:      // Not swallowed — saveSettings()'s own catch is what reports it.
./e2e/data-safety.spec.js:3757:      expect(r.threw).toMatch(/simulated saveLessonData failure/);
./e2e/data-safety.spec.js:3758:      expect(r.saves).toHaveLength(1);
./e2e/data-safety.spec.js:3801:// ─── Backtracking audit Phase 11: saveLessonData() load-guard ────────────────
./e2e/data-safety.spec.js:3803:// Phase 1 put a load-guard on saveSingleLesson(); saveLessonData() — the
./e2e/data-safety.spec.js:3814:test.describe('Data Safety — saveLessonData() load-guard (Backtracking audit Phase 11)', () => {
./e2e/data-safety.spec.js:3816:  test('non-summer path: when load failed, saveLessonData() throws and the existing semester content survives', async ({ browser }) => {
./e2e/data-safety.spec.js:3821:      introPitch: 'ORIGINAL — must survive a blocked bulk save',
./e2e/data-safety.spec.js:3832:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; });
./e2e/data-safety.spec.js:3836:          await saveLessonData(semKey, {
./e2e/data-safety.spec.js:3848:      const saved = await readTestLesson(TEST_SEM, key);
./e2e/data-safety.spec.js:3849:      expect(saved?.projectTitle).toBe('TEST Guard Non-Summer');
./e2e/data-safety.spec.js:3850:      expect(saved?.introPitch).toBe('ORIGINAL — must survive a blocked bulk save');
./e2e/data-safety.spec.js:3857:  test('summer path: when load failed, saveLessonData() throws before routing to saveSummerCampLessonData()', async ({ browser }) => {
./e2e/data-safety.spec.js:3860:      await writeTestDoc(ALPHA_KEY, { introPitch: 'Must not be touched by a blocked summer bulk save' });
./e2e/data-safety.spec.js:3870:          await saveLessonData('summer-2026', {
./e2e/data-safety.spec.js:3882:      const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:3883:      expect(saved.introPitch).toBe('Must not be touched by a blocked summer bulk save');
./e2e/data-safety.spec.js:3900:// is not), so saveConfig() is stubbed here rather than hitting real
./e2e/data-safety.spec.js:3902:// used elsewhere in this suite (e.g. saveMultipleLessonFields) for functions
./e2e/data-safety.spec.js:3920:        if (!currentConfig.semesters) currentConfig.semesters = {};
./e2e/data-safety.spec.js:3921:        currentConfig.semesters[sourceKey] = {
./e2e/data-safety.spec.js:3968:  // semester's empty lesson slots to curriculum/lessonData FIRST, then writes
./e2e/data-safety.spec.js:3971:  // created, and (because the config guard keys off currentConfig) a retry with
./e2e/data-safety.spec.js:3976:  // The slot write here is REAL — only saveConfig() is stubbed (the TEST_
./e2e/data-safety.spec.js:3986:  // saveLessonData() write runs), and the New Semester modal filled in.
./e2e/data-safety.spec.js:3989:      if (!currentConfig.semesters) currentConfig.semesters = {};
./e2e/data-safety.spec.js:3990:      currentConfig.semesters[sourceKey] = {
./e2e/data-safety.spec.js:4013:  test('R4-11: when saveConfig() fails after the lesson-slot write landed, local state is reverted AND the orphaned server-side slots are deleted', async ({ browser }) => {
./e2e/data-safety.spec.js:4043:          // this, every assertion below also passes if saveLessonData()
./e2e/data-safety.spec.js:4064:          configHasKey: Object.prototype.hasOwnProperty.call(currentConfig.semesters, newKey),
./e2e/data-safety.spec.js:4065:          lessonDataHasKey: !!currentLessonData && Object.prototype.hasOwnProperty.call(currentLessonData, newKey),
./e2e/data-safety.spec.js:4072:      // when saveConfig() failed.
./e2e/data-safety.spec.js:4083:      expect(result.lessonDataHasKey).toBe(false);
./e2e/data-safety.spec.js:4139:        let saveConfigCalls = 0;
./e2e/data-safety.spec.js:4143:        window.updateAppData = async () => { saveConfigCalls++; };
./e2e/data-safety.spec.js:4154:          threw, alerts, saveConfigCalls,
./e2e/data-safety.spec.js:4157:          configHasKey: Object.prototype.hasOwnProperty.call(currentConfig.semesters, newKey),
./e2e/data-safety.spec.js:4166:      expect(result.saveConfigCalls).toBe(0);
./e2e/data-safety.spec.js:4212:        let saveConfigCalls = 0;
./e2e/data-safety.spec.js:4216:        window.updateAppData = async () => { saveConfigCalls++; };
./e2e/data-safety.spec.js:4224:          alerts, saveConfigCalls,
./e2e/data-safety.spec.js:4225:          configHasKey: Object.prototype.hasOwnProperty.call(currentConfig.semesters, newKey),
./e2e/data-safety.spec.js:4231:      expect(result.saveConfigCalls).toBe(1);
./e2e/data-safety.spec.js:4243:  // Round-3 review (mutation gap): the `if (lessonDataCommitted)` gate on the
./e2e/data-safety.spec.js:4248:  test('no-copy-from creation that FAILS at saveConfig() over existing server-side lesson data leaves that data untouched — the compensating delete is gated on this call having written slots', async ({ browser }) => {
./e2e/data-safety.spec.js:4288:          configHasKey: Object.prototype.hasOwnProperty.call(currentConfig.semesters, newKey),
./e2e/data-safety.spec.js:4311:  // only added to currentConfig after the first await); a split success/failure
./e2e/data-safety.spec.js:4316:  test('in-flight guard: a second createNewSemester() call while the first is awaiting is a no-op — one pre-check, one write, one saveConfig()', async ({ browser }) => {
./e2e/data-safety.spec.js:4335:        let saveConfigCalls = 0;
./e2e/data-safety.spec.js:4342:        window.updateAppData = async () => { saveConfigCalls++; };
./e2e/data-safety.spec.js:4358:            saveConfigCalls,
./e2e/data-safety.spec.js:4359:            configHasKey: Object.prototype.hasOwnProperty.call(currentConfig.semesters, newKey),
./e2e/data-safety.spec.js:4373:      expect(result.saveConfigCalls).toBe(1);
./e2e/data-safety.spec.js:4391:// saveSingleLesson(), which writes every field it holds back to Firestore —
./e2e/data-safety.spec.js:4395:// thread, plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson()
./e2e/data-safety.spec.js:4434:      await page.evaluate(({ semKey, key, entry }) => curriculumDb.collection('curriculum').doc('lessonData').update({
./e2e/data-safety.spec.js:4468:      // R4-5: the lesson-level audit metadata saveSingleLesson() used to set.
./e2e/data-safety.spec.js:4512:      // leave the real curriculum/lessonData listener subscribed, so the
./e2e/data-safety.spec.js:4533:  test('RED (review r2): the teacher modal\'s next autosave does not write the cached qaThread back whole — a message that landed elsewhere survives it', async ({ browser }) => {
./e2e/data-safety.spec.js:4538:        weekNum: 18, projectTitle: 'TEST Teacher QA Autosave',
./e2e/data-safety.spec.js:4546:      await page.evaluate(({ semKey, key, entry }) => curriculumDb.collection('curriculum').doc('lessonData').update({
./e2e/data-safety.spec.js:4552:      // saveTeacherEdit() path the 2 s autosave uses.
./e2e/data-safety.spec.js:4554:      await page.locator('#te-projectTitle').fill('TEST Teacher QA Autosave (edited)');
./e2e/data-safety.spec.js:4555:      await page.locator('#te-save-btn').click();
./e2e/data-safety.spec.js:4557:        .toBe('TEST Teacher QA Autosave (edited)');
./e2e/data-safety.spec.js:4562:      expect(thread.some(m => m.id === 'q2')).toBe(true);           // not deleted by the teacher-edit save
./e2e/data-safety.spec.js:4624:  test('guard (review): a summer-camp semester key is refused — nothing is written into curriculum/lessonData under it', async ({ browser }) => {
./e2e/data-safety.spec.js:4655:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; });
./e2e/data-safety.spec.js:4670:// ─── Backtracking audit Phase 10: summer modal saveLesson() ──────────────────
./e2e/data-safety.spec.js:4673:// reviewers as belonging here: (1) saveLesson() mutates the shared cache and
./e2e/data-safety.spec.js:4675:// failure (R1-19), so a failed save leaves unconfirmed content as the base of
./e2e/data-safety.spec.js:4676:// every later save — including the photoPath it would later "clean up";
./e2e/data-safety.spec.js:4678:// a manual save while an autosave is in flight), and each re-reads the DOM —
./e2e/data-safety.spec.js:4681:test.describe('Data Safety — summer modal saveLesson() serialization and revert (Backtracking audit Phase 10)', () => {
./e2e/data-safety.spec.js:4683:  // Wrap the real saveSingleLesson so each call is slowed by `delayMs`, records
./e2e/data-safety.spec.js:4685:  // arrange a second save while the first is genuinely in flight.
./e2e/data-safety.spec.js:4688:      const real = window.saveSingleLesson;
./e2e/data-safety.spec.js:4689:      window.__saveCalls = [];
./e2e/data-safety.spec.js:4690:      window.saveSingleLesson = async (...args) => {
./e2e/data-safety.spec.js:4691:        const rec = { n: window.__saveCalls.length + 1, start: performance.now(), end: null, failed: false, error: null };
./e2e/data-safety.spec.js:4692:        window.__saveCalls.push(rec);
./e2e/data-safety.spec.js:4695:          if (failOn.includes(rec.n)) { rec.failed = true; throw new Error(`TEST simulated failure of save #${rec.n}`); }
./e2e/data-safety.spec.js:4704:    await page.waitForFunction((n) => window.__saveCalls.length === n && window.__saveCalls.every(c => c.end !== null), n, { timeout: 25_000 });
./e2e/data-safety.spec.js:4705:    await page.waitForTimeout(300); // let the post-save bookkeeping after the write settle
./e2e/data-safety.spec.js:4706:    return page.evaluate(() => window.__saveCalls);
./e2e/data-safety.spec.js:4711:  // The curriculum/lessonData listener (re-subscribed by initSummerContext's
./e2e/data-safety.spec.js:4719:      if (typeof lessonDataUnsubscribe === 'function') lessonDataUnsubscribe();
./e2e/data-safety.spec.js:4723:    // cache undefined until its ~1.5 s read lands (curriculum/lessonData has
./e2e/data-safety.spec.js:4734:  test('RED (R1-19): a failed save reverts the in-memory cache to the last confirmed state — the typed text stays in the form, the server is untouched', async ({ browser }) => {
./e2e/data-safety.spec.js:4743:      await page.evaluate(() => { window.saveSingleLesson = async () => { throw new Error('TEST simulated save failure'); }; });
./e2e/data-safety.spec.js:4746:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:4747:      await page.waitForFunction(() => /Save failed/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 15_000 });
./e2e/data-safety.spec.js:4758:  test('RED (R1-19): after a failed photo save, a successful retry still deletes the ORIGINAL photo — the modal\'s lesson reverts too, not just the cache', async ({ browser }) => {
./e2e/data-safety.spec.js:4771:      // Attempt 1: the upload is real, the Firestore save fails.
./e2e/data-safety.spec.js:4772:      await page.evaluate(() => { window.__realSave = window.saveSingleLesson; window.saveSingleLesson = async () => { throw new Error('TEST simulated save failure after a real upload'); }; });
./e2e/data-safety.spec.js:4773:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:4774:      await page.waitForFunction(() => /Save failed/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 20_000 });
./e2e/data-safety.spec.js:4779:      // Attempt 2: real save. The selection survived the failure, so this
./e2e/data-safety.spec.js:4783:      await page.evaluate(() => { window.saveSingleLesson = window.__realSave; });
./e2e/data-safety.spec.js:4784:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:4785:      await page.waitForFunction(() => /Saved!/.test(document.getElementById('summer-lesson-save')?.textContent || '') || /Save failed/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 20_000 });
./e2e/data-safety.spec.js:4786:      expect(await page.evaluate(() => document.getElementById('summer-autosave-status')?.textContent || '')).not.toMatch(/Save failed/);
./e2e/data-safety.spec.js:4789:      const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:4790:      expect(saved.photoPath).toBe(traffic.uploads[1].path);
./e2e/data-safety.spec.js:4798:  test('RED: saves are serialized — a second save requested mid-flight waits for the first, and a still-selected photo is uploaded exactly once (fast double-click)', async ({ browser }) => {
./e2e/data-safety.spec.js:4812:      // save's upload/write is still in flight.
./e2e/data-safety.spec.js:4813:      await page.evaluate(() => { const b = document.getElementById('summer-lesson-save'); b.click(); b.click(); });
./e2e/data-safety.spec.js:4819:      const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:4820:      expect(saved.photoPath).toBe(traffic.uploads[0].path);
./e2e/data-safety.spec.js:4822:      expect(await page.evaluate(() => document.getElementById('summer-autosave-status')?.textContent || '')).not.toMatch(/Save failed/);
./e2e/data-safety.spec.js:4829:  test('RED: back-to-back saves run in order — the earlier one failing (and reverting) never clobbers the later one, which lands', async ({ browser }) => {
./e2e/data-safety.spec.js:4840:      await page.locator('#summer-intro-pitch').fill('v1 — first save');
./e2e/data-safety.spec.js:4841:      await page.evaluate(() => document.getElementById('summer-lesson-save').click());
./e2e/data-safety.spec.js:4842:      await page.locator('#summer-intro-pitch').fill('v2 — second save');
./e2e/data-safety.spec.js:4843:      await page.evaluate(() => document.getElementById('summer-lesson-save').click());
./e2e/data-safety.spec.js:4847:      expect(calls[1].error).toBeNull();                               // the second (real) save itself succeeded
./e2e/data-safety.spec.js:4848:      expect(calls[1].start).toBeGreaterThanOrEqual(calls[0].end);   // the second save started only after the first had finished (failing)
./e2e/data-safety.spec.js:4849:      expect(await cachedIntro(page)).toBe('v2 — second save');
./e2e/data-safety.spec.js:4850:      expect((await readTestDoc(ALPHA_KEY)).introPitch).toBe('v2 — second save');
./e2e/data-safety.spec.js:4851:      expect(await page.evaluate(() => document.getElementById('summer-autosave-status')?.textContent || '')).not.toMatch(/Save failed/);
./e2e/data-safety.spec.js:4858:  test('guard: a queued save carries the text typed AFTER it was requested; Close waits for it, then the modal goes away and the view is re-rendered from the saved state', async ({ browser }) => {
./e2e/data-safety.spec.js:4870:      await page.locator('#summer-intro-pitch').fill('v1 — first save');
./e2e/data-safety.spec.js:4871:      await page.evaluate(() => document.getElementById('summer-lesson-save').click());
./e2e/data-safety.spec.js:4872:      await page.locator('#summer-intro-pitch').fill('v2 — second save requested');
./e2e/data-safety.spec.js:4873:      await page.evaluate(() => document.getElementById('summer-lesson-save').click());
./e2e/data-safety.spec.js:4874:      // Keep typing after the second save was queued (arming the autosave
./e2e/data-safety.spec.js:4876:      // behind it. Close flushes the armed debounce into a third save.
./e2e/data-safety.spec.js:4879:      // The modal stays up (frozen) until the queued saves land...
./e2e/data-safety.spec.js:4880:      expect(await page.locator('#summer-lesson-save').count()).toBe(1);
./e2e/data-safety.spec.js:4883:      // ...then closes, and the view is rendered from the saved state.
./e2e/data-safety.spec.js:4884:      await page.waitForSelector('#summer-lesson-save', { state: 'detached', timeout: 5_000 });
./e2e/data-safety.spec.js:4898:  test('RED (review r2): Close while the pending save FAILS keeps the modal open with the text intact and the failure showing; a second Close is then honoured', async ({ browser }) => {
./e2e/data-safety.spec.js:4909:      await page.locator('#summer-intro-pitch').fill('Will fail to save');
./e2e/data-safety.spec.js:4910:      await page.evaluate(() => document.getElementById('summer-lesson-save').click());
./e2e/data-safety.spec.js:4914:      expect(await page.locator('#summer-lesson-save').count()).toBe(1);                       // still open
./e2e/data-safety.spec.js:4915:      expect(await page.inputValue('#summer-intro-pitch')).toBe('Will fail to save');          // text intact
./e2e/data-safety.spec.js:4917:      expect(await page.evaluate(() => document.getElementById('summer-autosave-status').textContent)).toMatch(/Save failed/);
./e2e/data-safety.spec.js:4918:      expect(await page.evaluate(() => ({ t: document.getElementById('summer-lesson-save').textContent, d: document.getElementById('summer-lesson-save').disabled }))).toEqual({ t: 'Save', d: false });
./e2e/data-safety.spec.js:4922:      await page.waitForSelector('#summer-lesson-save', { state: 'detached', timeout: 5_000 });
./e2e/data-safety.spec.js:4929:  test('RED (review r2): typing after an in-flight save read the form, then Close before the autosave debounce fires — the last text is saved, not dropped', async ({ browser }) => {
./e2e/data-safety.spec.js:4941:      await page.evaluate(() => document.getElementById('summer-lesson-save').click());
./e2e/data-safety.spec.js:4942:      await page.locator('#summer-intro-pitch').fill('v2 — typed after, never manually saved');
./e2e/data-safety.spec.js:4945:      await page.waitForSelector('#summer-lesson-save', { state: 'detached', timeout: 5_000 });
./e2e/data-safety.spec.js:4948:      expect((await readTestDoc(ALPHA_KEY)).introPitch).toBe('v2 — typed after, never manually saved');
./e2e/data-safety.spec.js:4975:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:4976:      await page.waitForFunction(() => /Saved!/.test(document.getElementById('summer-lesson-save')?.textContent || '') || /Save failed/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 20_000 });
./e2e/data-safety.spec.js:4978:      const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:4979:      expect(saved.closure).toBe('my new closure');
./e2e/data-safety.spec.js:4980:      expect(saved.introPitch).toBe('B — changed by another client');
./e2e/data-safety.spec.js:4988:  test('RED (review r2): the summer save writes only its own changes — an admin\'s Help Queue reply in the doc\'s qaThread survives a text edit', async ({ browser }) => {
./e2e/data-safety.spec.js:4999:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:5000:      await page.waitForFunction(() => /Saved!/.test(document.getElementById('summer-lesson-save')?.textContent || '') || /Save failed/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 20_000 });
./e2e/data-safety.spec.js:5002:      const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:5003:      expect(saved.introPitch).toBe('Edited content');
./e2e/data-safety.spec.js:5004:      expect((saved.qaThread || []).map(m => m.id)).toEqual(['a1']);   // was: overwritten with the scaffold's []
./e2e/data-safety.spec.js:5005:      expect(saved.status).toBe('In Progress');
./e2e/data-safety.spec.js:5012:  test('RED (review r2): a photo another client replaced on the server is not overwritten by this modal\'s stale photo fields when it saves text', async ({ browser }) => {
./e2e/data-safety.spec.js:5028:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:5029:      await page.waitForFunction(() => /Saved!/.test(document.getElementById('summer-lesson-save')?.textContent || '') || /Save failed/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 20_000 });
./e2e/data-safety.spec.js:5031:      const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:5032:      expect(saved.closure).toBe('closure edited here');
./e2e/data-safety.spec.js:5033:      expect(saved.photoPath).toBe(OTHER_PATH);                       // was: OLD_PATH written back → broken image
./e2e/data-safety.spec.js:5041:  test('RED (review r3): an earlier save\'s 2 s "Saved!" reset cannot clear a later save\'s failure message or leave the button stuck', async ({ browser }) => {
./e2e/data-safety.spec.js:5050:      // Save #1 is real; save #2 fails instantly.
./e2e/data-safety.spec.js:5053:      // Manual save #1 now; more typing right after arms the 2 s autosave
./e2e/data-safety.spec.js:5055:      await page.locator('#summer-intro-pitch').fill('First save, succeeds');
./e2e/data-safety.spec.js:5056:      await page.evaluate(() => document.getElementById('summer-lesson-save').click());
./e2e/data-safety.spec.js:5059:        ta.value = 'Second save, fails'; ta.dispatchEvent(new Event('input', { bubbles: true }));
./e2e/data-safety.spec.js:5065:      expect(await page.evaluate(() => document.getElementById('summer-autosave-status').textContent)).toMatch(/Save failed/);
./e2e/data-safety.spec.js:5066:      expect(await page.evaluate(() => ({ t: document.getElementById('summer-lesson-save').textContent, d: document.getElementById('summer-lesson-save').disabled }))).toEqual({ t: 'Save', d: false });
./e2e/data-safety.spec.js:5087:      await page.locator('#summer-intro-pitch').fill('Stuck save');
./e2e/data-safety.spec.js:5088:      await page.evaluate(() => document.getElementById('summer-lesson-save').click());
./e2e/data-safety.spec.js:5091:      await page.waitForFunction(() => /Still saving/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 5_000 });
./e2e/data-safety.spec.js:5092:      expect(await page.locator('#summer-lesson-save').count()).toBe(1);
./e2e/data-safety.spec.js:5096:      await page.waitForSelector('#summer-lesson-save', { state: 'detached', timeout: 2_000 });
./e2e/data-safety.spec.js:5097:      // The save then fails — the teacher is told.
./e2e/data-safety.spec.js:5110:      await deleteTestDoc(ALPHA_KEY);                                  // no doc yet — the save creates it
./e2e/data-safety.spec.js:5117:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:5118:      await page.waitForFunction(() => /Saved!/.test(document.getElementById('summer-lesson-save')?.textContent || '') || /Save failed/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 20_000 });
./e2e/data-safety.spec.js:5120:      const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:5121:      expect(saved.introPitch).toBe('First ever content');
./e2e/data-safety.spec.js:5123:      expect(saved).toEqual(expect.objectContaining({ teacher, campName, block, projectTitle, className: `${campName} - ${block}` }));
./e2e/data-safety.spec.js:5124:      expect(saved.qaThread).toBeUndefined();                          // and nothing the modal doesn't own
./e2e/data-safety.spec.js:5141:      await page.waitForSelector('#summer-lesson-save', { state: 'detached', timeout: 2_000 });
./e2e/data-safety.spec.js:5148:  test('RED (review): after a failed save, a retry builds on a NEWER copy a reload brought in — its photoPath survives, and the stale one is not written back', async ({ browser }) => {
./e2e/data-safety.spec.js:5166:        window.__realSave = window.saveSingleLesson;
./e2e/data-safety.spec.js:5167:        window.saveSingleLesson = async () => {
./e2e/data-safety.spec.js:5170:          throw new Error('TEST simulated save failure');
./e2e/data-safety.spec.js:5174:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:5175:      await page.waitForFunction(() => /Save failed/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 15_000 });
./e2e/data-safety.spec.js:5178:      await page.evaluate(() => { window.saveSingleLesson = window.__realSave; });
./e2e/data-safety.spec.js:5179:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:5180:      await page.waitForFunction(() => /Saved!/.test(document.getElementById('summer-lesson-save')?.textContent || '') || /Save failed/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 20_000 });
./e2e/data-safety.spec.js:5182:      const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:5183:      expect(saved.introPitch).toBe('Edit that fails first');
./e2e/data-safety.spec.js:5184:      expect(saved.photoPath).toBe(FRESH_PATH);                 // not clobbered by the modal's stale copy
./e2e/data-safety.spec.js:5193:  test('RED (review): a listener rebuild that lands mid-save with a PRE-write read does not leave the cache showing pre-save content', async ({ browser }) => {
./e2e/data-safety.spec.js:5203:      // object is replaced with copies read BEFORE this save's write landed.
./e2e/data-safety.spec.js:5205:        const real = window.saveSingleLesson;
./e2e/data-safety.spec.js:5206:        window.saveSingleLesson = async (...args) => {
./e2e/data-safety.spec.js:5215:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:5216:      await page.waitForFunction(() => /Saved!/.test(document.getElementById('summer-lesson-save')?.textContent || '') || /Save failed/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 20_000 });
./e2e/data-safety.spec.js:5226:  // The summer branch of saveSingleLesson() skips a save with no text, no
./e2e/data-safety.spec.js:5228:  // this save changed, so a photo-only replacement arrives with no text at
./e2e/data-safety.spec.js:5231:  test('guard (review): replacing the photo on a lesson with no text yet really saves — the new path lands in Firestore before the old object is deleted', async ({ browser }) => {
./e2e/data-safety.spec.js:5243:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:5244:      await page.waitForFunction(() => /Saved!/.test(document.getElementById('summer-lesson-save')?.textContent || '') || /Save failed/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 20_000 });
./e2e/data-safety.spec.js:5246:      const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:5248:      expect(saved.photoPath).toBe(traffic.uploads[0].path);     // was: still OLD_PATH — the save was silently skipped
./e2e/data-safety.spec.js:5256:  test('guard (review): a failed save on a lesson that was absent from the cache leaves no undefined-valued key behind', async ({ browser }) => {
./e2e/data-safety.spec.js:5267:        window.saveSingleLesson = async () => { throw new Error('TEST simulated save failure'); };
./e2e/data-safety.spec.js:5270:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:5271:      await page.waitForFunction(() => /Save failed/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 15_000 });
./e2e/data-safety.spec.js:5280:  test('guard: a failed save does not revert a cache entry that fresher data has since replaced (identity-guarded revert)', async ({ browser }) => {
./e2e/data-safety.spec.js:5289:      // While the save is in flight, a reload replaces this lesson's cache
./e2e/data-safety.spec.js:5290:      // entry with fresher server data — then the save fails.
./e2e/data-safety.spec.js:5292:        window.saveSingleLesson = async () => {
./e2e/data-safety.spec.js:5295:          throw new Error('TEST simulated save failure');
./e2e/data-safety.spec.js:5300:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:5301:      await page.waitForFunction(() => /Save failed/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 15_000 });
./e2e/data-safety.spec.js:5312:// ─── Backtracking audit Phase 7: the curriculum/lessonData listener ──────────
./e2e/data-safety.spec.js:5314:// Every snapshot of the shared non-summer doc (any other user's save, or this
./e2e/data-safety.spec.js:5317:// as they were, so saves keep going against a cache that may be blank
./e2e/data-safety.spec.js:5322:// the duration of every reload, and (5) the reload's read can predate a save
./e2e/data-safety.spec.js:5323:// that has since landed, replacing the newer in-memory copy with pre-save
./e2e/data-safety.spec.js:5326:test.describe('Data Safety — lessonData listener: summer reload outcomes (Backtracking audit Phase 7)', () => {
./e2e/data-safety.spec.js:5327:  // These tests wait on real snapshots of the shared curriculum/lessonData doc,
./e2e/data-safety.spec.js:5332:  // Land a write on curriculum/lessonData so every subscribed listener gets a snapshot.
./e2e/data-safety.spec.js:5364:    flag: lessonDataLoadedSuccessfully,
./e2e/data-safety.spec.js:5414:      await page.waitForFunction(() => lessonDataLoadedSuccessfully === false, null, { timeout: 5_000 });
./e2e/data-safety.spec.js:5440:      await page.waitForFunction(() => lessonDataLoadedSuccessfully === false, null, { timeout: 5_000 });
./e2e/data-safety.spec.js:5476:  test('RED (Phase 10 hand-off): a reload whose read predates a confirmed save keeps the NEWER in-memory copy; a genuinely newer server copy still replaces the cache', async ({ browser }) => {
./e2e/data-safety.spec.js:5485:      // The reload's read: ALPHA still shows the pre-save copy (it read before
./e2e/data-safety.spec.js:5486:      // this client's save landed); BETA carries another client's NEWER save.
./e2e/data-safety.spec.js:5498:      // This client's confirmed save of ALPHA, sitting in memory with its fresh stamp.
./e2e/data-safety.spec.js:5548:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; document.getElementById('lesson-load-error-banner').classList.remove('hidden'); });
./e2e/data-safety.spec.js:5604:  test('RED (review): the merge keeps only the saved-doc fields of a newer in-memory copy — scaffold fields (e.g. materials) come from the fresh read', async ({ browser }) => {
./e2e/data-safety.spec.js:5627:      expect(r.intro).toBe('Alpha confirmed here');                 // saved field: mine
./e2e/data-safety.spec.js:5630:      expect(r.lingering).toBe(false);                               // a field in neither fresh nor the saved set is dropped
./e2e/data-safety.spec.js:5668:  test('RED (review): when a mid-flight reload kept this save\'s optimistic entry and the save then FAILS, the editor falls back to the newer server copy the merge had displaced', async ({ browser }) => {
./e2e/data-safety.spec.js:5676:      await page.evaluate(() => { if (typeof lessonDataUnsubscribe === 'function') lessonDataUnsubscribe(); window.setupLessonDataListener = () => {}; });
./e2e/data-safety.spec.js:5679:      // During the save (optimistic entry installed, stamped now), a reload
./e2e/data-safety.spec.js:5684:        window.saveSingleLesson = async () => {
./e2e/data-safety.spec.js:5689:          throw new Error('TEST simulated save failure');
./e2e/data-safety.spec.js:5693:      await page.click('#summer-lesson-save');
./e2e/data-safety.spec.js:5694:      await page.waitForFunction(() => /Save failed/.test(document.getElementById('summer-autosave-status')?.textContent || ''), { timeout: 15_000 });
./e2e/data-safety.spec.js:5708:// .summer-plan-complete-cb) mutates lesson.planComplete BEFORE the save and,
./e2e/data-safety.spec.js:5710:// unsaved value (R3-20; the plan's earlier rounds had "fixed" the wrong,
./e2e/data-safety.spec.js:5724:    await page.evaluate(() => { if (typeof lessonDataUnsubscribe === 'function') lessonDataUnsubscribe(); window.setupLessonDataListener = () => {}; });
./e2e/data-safety.spec.js:5739:  test('RED (R3-20): when the Plan Complete save fails, BOTH the checkbox and the in-memory lesson revert', async ({ browser }) => {
./e2e/data-safety.spec.js:5747:      await page.evaluate(() => { window.saveSingleLesson = async () => { throw new Error('TEST simulated save failure'); }; });
./e2e/data-safety.spec.js:5807:      // slot must be the one shown and saved.
./e2e/data-safety.spec.js:5835:  test('RED (review): when a mid-flight reload parked a NEWER server copy and the save then fails, the lesson adopts that copy instead of going back to the pre-toggle state', async ({ browser }) => {
./e2e/data-safety.spec.js:5844:        window.saveSingleLesson = async () => {
./e2e/data-safety.spec.js:5845:          // While the save is in flight, a reload lands carrying another
./e2e/data-safety.spec.js:5852:          throw new Error('TEST simulated save failure');
./e2e/data-safety.spec.js:5868:  test('RED (review): a second toggle while the first save is in flight is refused (checkbox snaps back) — the rollback of the first cannot be mis-ordered', async ({ browser }) => {
./e2e/data-safety.spec.js:5875:      await page.evaluate(() => { window.__saves = 0; window.saveSingleLesson = async () => { window.__saves++; await new Promise(r => setTimeout(r, 1500)); throw new Error('TEST simulated save failure'); }; });
./e2e/data-safety.spec.js:5877:      await toggle(page, true);                         // save #1 in flight (will fail)
./e2e/data-safety.spec.js:5883:      await page.waitForTimeout(2000);                  // save #1 fails
./e2e/data-safety.spec.js:5885:      expect(await page.evaluate(() => window.__saves)).toBe(1);
./e2e/data-safety.spec.js:5896:  test('RED (review r2): the in-flight lock survives a re-render — the replacement checkbox is rendered disabled and refuses a change until the save settles', async ({ browser }) => {
./e2e/data-safety.spec.js:5903:      await page.evaluate(() => { window.__saves = 0; window.saveSingleLesson = async () => { window.__saves++; await new Promise(r => setTimeout(r, 1500)); throw new Error('TEST simulated save failure'); }; });
./e2e/data-safety.spec.js:5906:      await toggle(page, true);                                                     // save #1 in flight
./e2e/data-safety.spec.js:5915:      await page.waitForTimeout(2000);                                              // save #1 fails
./e2e/data-safety.spec.js:5917:      expect(await page.evaluate(() => window.__saves)).toBe(1);
./e2e/data-safety.spec.js:5927:  test('RED (review r2): when a mid-flight reload\'s fresh copy is NEWER than this toggle (fresh wins, entry replaced) and the save fails, the cache keeps the fresh copy and the checkbox shows it', async ({ browser }) => {
./e2e/data-safety.spec.js:5936:        window.saveSingleLesson = async () => {
./e2e/data-safety.spec.js:5942:          throw new Error('TEST simulated save failure');
./e2e/data-safety.spec.js:5961:// ─── Data Safety Plan (remaining stages) Phase 9 — saveAdminEdit(): open-time
./e2e/data-safety.spec.js:5966:// into a full-object write: every admin save resent whatever this browser's
./e2e/data-safety.spec.js:5971:// this brings saveAdminEdit() in line.
./e2e/data-safety.spec.js:5973:test.describe('Data Safety — saveAdminEdit() diff-only payload + existence check (Data Safety Plan Phase 9)', () => {
./e2e/data-safety.spec.js:5992:  async function saveAdmin(page, key, weekNum) {
./e2e/data-safety.spec.js:5993:    await page.evaluate(({ key, teacher, className, weekNum }) => saveAdminEdit(key, teacher, className, weekNum), { key, ...ADMIN, weekNum });
./e2e/data-safety.spec.js:6022:      await saveAdmin(page, key, 21);
./e2e/data-safety.spec.js:6047:      await saveAdmin(page, key, 22);
./e2e/data-safety.spec.js:6074:      await page.evaluate((key) => saveAdminEdit(key, 'TEST', 'TEST_DATA_SAFETY - Block 1', 1), ALPHA_KEY);
./e2e/data-safety.spec.js:6076:      const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:6077:      expect(saved.processStep1).toBe('Step 1 typed by the admin');
./e2e/data-safety.spec.js:6078:      expect(saved.processStep3).toBe('New step 3 from another client');        // the stale cached copy is never sent
./e2e/data-safety.spec.js:6079:      expect(saved.introPitch).toBe('Summer intro');
./e2e/data-safety.spec.js:6080:      expect(saved.projectTitle).toBe('TEST Project Alpha');
./e2e/data-safety.spec.js:6087:  test('RED (summer identity): a summer retitle through the popup is refused with an explanation — the key-derived title stays, other edits in the same save still land', async ({ browser }) => {
./e2e/data-safety.spec.js:6105:      // above), so set them via JS — the save-time refusal is the backstop for
./e2e/data-safety.spec.js:6113:      await page.evaluate((key) => saveAdminEdit(key, 'TEST', 'TEST_DATA_SAFETY - Block 1', 1), ALPHA_KEY);
./e2e/data-safety.spec.js:6115:      expect(alerts.some(m => /project title, short details, materials are managed in the Summer Camp App/i.test(m) && /other edits will still be saved/i.test(m))).toBe(true);
./e2e/data-safety.spec.js:6116:      const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:6117:      expect(saved.projectTitle).toBe('TEST Project Alpha');                     // never 'RENAMED' — the Summer Camp App's orphan check keys on this
./e2e/data-safety.spec.js:6118:      expect('shortDetails' in saved).toBe(false);                               // curriculum-owned, never read back — not written
./e2e/data-safety.spec.js:6119:      expect('materials' in saved).toBe(false);
./e2e/data-safety.spec.js:6120:      expect(saved.processStep2).toBe('Step 2 typed alongside the retitle');
./e2e/data-safety.spec.js:6121:      expect(saved.campName).toBe('TEST_DATA_SAFETY');                          // identity trio always travels for summer
./e2e/data-safety.spec.js:6122:      expect(saved.block).toBe('Block 1');
./e2e/data-safety.spec.js:6176:      await page.evaluate((key) => saveAdminEdit(key, 'TEST', 'TEST_DATA_SAFETY - Block 1', 1), ALPHA_KEY);
./e2e/data-safety.spec.js:6179:      const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:6180:      expect(saved).toEqual({ projectTitle: 'TEST Project Alpha', introPitch: 'Must survive', lastEditedBy: 'Someone Else', season: '2026' });   // byte-for-byte untouched (the fixture's own season stamp included): no stamp, no identity write
./e2e/data-safety.spec.js:6198:      await saveAdmin(page, key, 23);
./e2e/data-safety.spec.js:6211:  test('RED (moved/deleted elsewhere): a lesson deleted on the server after the popup opened is NOT recreated as a ghost — the save is refused with an explanation', async ({ browser }) => {
./e2e/data-safety.spec.js:6223:      await saveAdmin(page, key, 24);
./e2e/data-safety.spec.js:6235:  test('RED (summer first save): a generated, never-saved summer lesson — present in the cache, NO doc in summerCamps_lessonData — saves on the first try; the existence check is skipped for the summer schema', async ({ browser }) => {
./e2e/data-safety.spec.js:6248:      await page.locator('#ca-edit-step1').fill('First ever save of this summer lesson');
./e2e/data-safety.spec.js:6249:      await page.evaluate((key) => saveAdminEdit(key, 'TEST', 'TEST_DATA_SAFETY - Block 1', 1), ALPHA_KEY);
./e2e/data-safety.spec.js:6252:      const saved = await readTestDoc(ALPHA_KEY);
./e2e/data-safety.spec.js:6253:      expect(saved.processStep1).toBe('First ever save of this summer lesson');
./e2e/data-safety.spec.js:6254:      expect(saved.teacher).toBe('TEST');
./e2e/data-safety.spec.js:6255:      expect(saved.campName).toBe('TEST_DATA_SAFETY');      // the Summer Camp App's orphan check queries by campName + teacher …
./e2e/data-safety.spec.js:6256:      expect(saved.block).toBe('Block 1');
./e2e/data-safety.spec.js:6257:      expect(saved.projectTitle).toBe('TEST Project Alpha');  // … and validates projectTitle against the curriculum
./e2e/data-safety.spec.js:6258:      expect('qaThread' in saved).toBe(false);              // narrow payload — nothing the admin didn't touch
./e2e/data-safety.spec.js:6259:      expect('photoUrl' in saved).toBe(false);
./e2e/data-safety.spec.js:6284:      await saveAdmin(page, key, 25);
./e2e/data-safety.spec.js:6312:      await saveAdmin(page, newKey, 27);
./e2e/data-safety.spec.js:6326:  test('RED (swapped elsewhere): the key still exists but now holds a DIFFERENT project — the admin is asked before their edit is applied to it; Cancel saves nothing', async ({ browser }) => {
./e2e/data-safety.spec.js:6350:      await saveAdmin(page, key, 31);
./e2e/data-safety.spec.js:6358:      // Same save — now with a replacement photo too — and the admin explicitly
./e2e/data-safety.spec.js:6362:      await saveAdmin(page, key, 31);
./e2e/data-safety.spec.js:6377:  test('RED (cancel mid-save): Cancel / × / overlay are refused while a save is in flight, so the save\'s completion can only ever close its OWN popup', async ({ browser }) => {
./e2e/data-safety.spec.js:6391:      const savePromise = page.evaluate(({ key, teacher, className, weekNum }) => saveAdminEdit(key, teacher, className, weekNum), { key, ...ADMIN, weekNum: 34 });
./e2e/data-safety.spec.js:6402:      await savePromise;
./e2e/data-safety.spec.js:6403:      expect(await page.evaluate(() => document.getElementById('ca-detail-modal')?.classList.contains('open'))).toBe(false);   // the save's own close still works
./e2e/data-safety.spec.js:6415:  test('RED (creation onto a slot that gained a project): an "empty" slot in this tab that another admin pasted into is NOT silently overwritten — confirm first; Cancel saves nothing, Accept applies only the typed fields', async ({ browser }) => {
./e2e/data-safety.spec.js:6433:      await saveAdmin(page, key, 35);
./e2e/data-safety.spec.js:6441:      await saveAdmin(page, key, 35);
./e2e/data-safety.spec.js:6453:  test('guard (summer key gone from the cache): a summer save whose scaffold vanished between open and save is refused — no identity-less doc is written', async ({ browser }) => {
./e2e/data-safety.spec.js:6467:      await page.evaluate((key) => saveAdminEdit(key, 'TEST', 'TEST_DATA_SAFETY - Block 1', 1), ALPHA_KEY);
./e2e/data-safety.spec.js:6477:  test('RED (empty-cell popup mid-save): the Paste from Cut Bank / Idea Bank buttons — rendered outside the edit form — are disabled while a save is in flight, and re-enabled after', async ({ browser }) => {
./e2e/data-safety.spec.js:6495:      const savePromise = page.evaluate(({ key, teacher, className, weekNum }) => saveAdminEdit(key, teacher, className, weekNum), { key, ...ADMIN, weekNum: 36 });
./e2e/data-safety.spec.js:6497:      expect((await pasteButtons()).every(b => b.disabled)).toBe(true);     // locked mid-save
./e2e/data-safety.spec.js:6499:      await savePromise;
./e2e/data-safety.spec.js:6508:  test('RED (double-click): two overlapping saveAdminEdit() calls run ONE save — one write, one Change History entry', async ({ browser }) => {
./e2e/data-safety.spec.js:6521:      await page.locator('#ca-edit-title').fill('TEST Double Click — saved once');
./e2e/data-safety.spec.js:6523:        saveAdminEdit(key, teacher, className, weekNum),
./e2e/data-safety.spec.js:6524:        saveAdminEdit(key, teacher, className, weekNum),
./e2e/data-safety.spec.js:6528:      expect((await readTestLesson(TEST_SEM, key))?.projectTitle).toBe('TEST Double Click — saved once');
./e2e/data-safety.spec.js:6551:      await saveAdmin(page, key, 33);
./e2e/data-safety.spec.js:6562:  test('RED (existence check fails closed): when the forced server read fails twice, the save is refused with a connection message and nothing is written', async ({ browser }) => {
./e2e/data-safety.spec.js:6576:      await saveAdmin(page, key, 28);
./e2e/data-safety.spec.js:6587:  test('guard (retry once): a single transient read failure is retried and the save then proceeds normally', async ({ browser }) => {
./e2e/data-safety.spec.js:6602:      await saveAdmin(page, key, 29);
./e2e/data-safety.spec.js:6626:      await saveAdmin(page, key, 30);
./e2e/data-safety.spec.js:6652:        const saved = currentFutureProjects;
./e2e/data-safety.spec.js:6657:        } finally { currentFutureProjects = saved; }
./e2e/data-safety.spec.js:6675:// Two things here would undo that: saveCampComplete() was a full-document
./e2e/data-safety.spec.js:6678:// (saveSingleLesson / saveSummerCampLessonData), a camp-complete flag, a
./e2e/data-safety.spec.js:6742:  // The writers' OLD signatures shift the arguments (`saveCampComplete('summer-2026', 'TEST', …)`
./e2e/data-safety.spec.js:6759:        // currentConfig object (saveConfig() writes it wholesale).
./e2e/data-safety.spec.js:6766:        const sems = currentConfig.semesters;
./e2e/data-safety.spec.js:6792:  test('RED: saveCampComplete(semKey, …) is a merge — a seeded season stamp and a canary field survive, campComplete flips, updatedAt moves', async ({ browser }) => {
./e2e/data-safety.spec.js:6800:        const expectArity = (fn, n) => { if (typeof fn !== 'function' || fn.length !== n) throw new Error((fn && fn.name) + ' does not take a leading semKey yet (arity ' + (fn && fn.length) + ', expected ' + n + ')'); }; expectArity(saveCampComplete, 4);
./e2e/data-safety.spec.js:6801:        await saveCampComplete('summer-2026', 'TEST', 'TEST_DATA_SAFETY', true);
./e2e/data-safety.spec.js:6816:  test('RED: saveCampComplete() re-asserts the stamp on a doc that lost it', async ({ browser }) => {
./e2e/data-safety.spec.js:6825:        const expectArity = (fn, n) => { if (typeof fn !== 'function' || fn.length !== n) throw new Error((fn && fn.name) + ' does not take a leading semKey yet (arity ' + (fn && fn.length) + ', expected ' + n + ')'); }; expectArity(saveCampComplete, 4);
./e2e/data-safety.spec.js:6826:        await saveCampComplete('summer-2026', 'TEST', 'TEST_DATA_SAFETY', false);
./e2e/data-safety.spec.js:6847:      // checkbox must save under the semester it was RENDERED for; a handler
./e2e/data-safety.spec.js:6852:        // saveCampComplete() fed the new 4-arg call would write
./e2e/data-safety.spec.js:6854:        const expectArity = (fn, n) => { if (typeof fn !== 'function' || fn.length !== n) throw new Error((fn && fn.name) + ' does not take a leading semKey yet (arity ' + (fn && fn.length) + ', expected ' + n + ')'); }; expectArity(saveCampComplete, 4);
./e2e/data-safety.spec.js:6863:      // The row reflects the confirmed save, no alert/revert.
./e2e/data-safety.spec.js:6871:  test('RED: the summer saveSingleLesson() path stamps a new plan doc with season \'2026\'', async ({ browser }) => {
./e2e/data-safety.spec.js:6879:        await saveSingleLesson('summer-2026', key, { ...{ teacher: 'TEST', campName: 'TEST_DATA_SAFETY', block: 'Block 1', projectTitle: 'TEST Project Alpha' }, introPitch: 'A plan saved after Phase 0' });
./e2e/data-safety.spec.js:6882:      expect(d.introPitch).toBe('A plan saved after Phase 0');
./e2e/data-safety.spec.js:6884:      // A follow-up narrow save (planComplete only) is still a merge and keeps the stamp.
./e2e/data-safety.spec.js:6885:      await page.evaluate(async (key) => { await saveSingleLesson('summer-2026', key, { planComplete: true }); }, ALPHA_KEY);
./e2e/data-safety.spec.js:6889:      expect(d2.introPitch).toBe('A plan saved after Phase 0');
./e2e/data-safety.spec.js:6891:      await page.evaluate(async (key) => { await saveSingleLesson('summer-2026', key, { processStep1: 'kept' }, ['introPitch']); }, ALPHA_KEY);
./e2e/data-safety.spec.js:6903:  test('RED: saveSummerCampLessonData(semKey, lessons) stamps every doc it writes with season \'2026\'', async ({ browser }) => {
./e2e/data-safety.spec.js:6912:        const expectArity = (fn, n) => { if (typeof fn !== 'function' || fn.length !== n) throw new Error((fn && fn.name) + ' does not take a leading semKey yet (arity ' + (fn && fn.length) + ', expected ' + n + ')'); }; expectArity(saveSummerCampLessonData, 2);
./e2e/data-safety.spec.js:6913:        await saveSummerCampLessonData('summer-2026', {
./e2e/data-safety.spec.js:6941:        const expectArity = (fn, n) => { if (typeof fn !== 'function' || fn.length !== n) throw new Error((fn && fn.name) + ' does not take a leading semKey yet (arity ' + (fn && fn.length) + ', expected ' + n + ')'); }; expectArity(saveCampComplete, 4); expectArity(sendSummerLessonQaMessage, 4); expectArity(saveSummerCampLessonData, 2);
./e2e/data-safety.spec.js:6946:        currentConfig.semesters['summer-badseason'] = { name: 'TEST Bad Season', semesterType: 'summer-camp', season: 'not-a-year' };
./e2e/data-safety.spec.js:6949:          campComplete: await attempt(() => saveCampComplete('TEST_DATA_SAFETY_semester', 'TEST', 'TEST_DATA_SAFETY', true)),
./e2e/data-safety.spec.js:6951:          bulk:         await attempt(() => saveSummerCampLessonData('TEST_DATA_SAFETY_semester', { [key]: { introPitch: 'never written' } })),
./e2e/data-safety.spec.js:6957:          single:       await attempt(() => saveSingleLesson('summer-badseason', key, { introPitch: 'never written' })),
./e2e/data-safety.spec.js:6959:        } finally { delete currentConfig.semesters['summer-badseason']; }
./e2e/data-safety.spec.js:7087:  test('RED: when lesson data failed to load, saveCampComplete() and sendSummerLessonQaMessage() refuse and nothing is written', async ({ browser }) => {
./e2e/data-safety.spec.js:7097:        const expectArity = (fn, n) => { if (typeof fn !== 'function' || fn.length !== n) throw new Error((fn && fn.name) + ' does not take a leading semKey yet (arity ' + (fn && fn.length) + ', expected ' + n + ')'); }; expectArity(saveCampComplete, 4); expectArity(sendSummerLessonQaMessage, 4);
./e2e/data-safety.spec.js:7100:          campComplete: await attempt(() => saveCampComplete('summer-2026', 'TEST', 'TEST_DATA_SAFETY', true)),
./e2e/data-safety.spec.js:7153:// whole-document saveConfig() could strip the field. A static test (added with
./e2e/data-safety.spec.js:7173:        // block only — never swap currentConfig itself (appData is written from it).
./e2e/data-safety.spec.js:7182:        const sems = currentConfig.semesters;
./e2e/data-safety.spec.js:7233:        const sem = currentConfig.semesters['summer-2026'];
./e2e/data-safety.spec.js:7325:        const sems = currentConfig.semesters;
./e2e/data-safety.spec.js:7329:        const saved2026 = { ...(sems['summer-2026'] || {}) };
./e2e/data-safety.spec.js:7333:          sems['summer-2026'] = { ...saved2026, semesterType: 'summer-camp', season: '2026', startDate: '2026-05-26', numWeeks: 11, breakWeeks: [6] };
./e2e/data-safety.spec.js:7341:          sems['summer-2026'] = saved2026;
./e2e/data-safety.spec.js:7368:// created a nested map for it inside the shared curriculum/lessonData
./e2e/data-safety.spec.js:7383:      currentConfig.semesters[weekly] = { name: 'TEST Summer Enrichment 2027', semesterType: 'weekly', numWeeks: 8, published: false };
./e2e/data-safety.spec.js:7384:      currentConfig.semesters[camp]   = { name: 'TEST Summer 2031', semesterType: 'summer-camp', season: '2031', published: false };
./e2e/data-safety.spec.js:7385:      currentConfig.semesters[sdoc]   = { name: 'TEST SDOC 2026-27', semesterType: 'day-off-camps', published: false };
./e2e/data-safety.spec.js:7393:  test('RED (1.1): a WEEKLY semester whose key starts with summer- saves to curriculum/lessonData, not the camp collection', async ({ browser }) => {
./e2e/data-safety.spec.js:7401:      // Pre-Phase-1 this routed on the key: it went to summerCamps_lessonData
./e2e/data-safety.spec.js:7405:          await saveSingleLesson(semKey, key, {
./e2e/data-safety.spec.js:7438:          await saveSingleLesson(semKey, key, {
./e2e/data-safety.spec.js:7449:      const saved = await readTestDoc(docId);
./e2e/data-safety.spec.js:7450:      expect(saved.introPitch).toBe('routed as camp');
./e2e/data-safety.spec.js:7451:      expect(saved.season).toBe('2031');
./e2e/data-safety.spec.js:7474:          saveSingleLesson:        await attempt(() => saveSingleLesson(semKey, key, lesson)),
./e2e/data-safety.spec.js:7475:          saveLessonData:          await attempt(() => saveLessonData(semKey, { [key]: lesson })),
./e2e/data-safety.spec.js:7476:          saveMultipleLessonFields: await attempt(() => saveMultipleLessonFields(semKey, [{ lessonKey: key, lessonData: lesson, fieldsToClear: [] }])),
./e2e/data-safety.spec.js:7485:        // SDOC Phase 2B: saveSingleLesson now routes an SDOC key to its own
./e2e/data-safety.spec.js:7488:        expect(r[site].message, site).toMatch(site === 'saveSingleLesson' ? /dayOffAuth|may not write|renamed or removed/i : /day-off-camps|no lesson store/i);
./e2e/data-safety.spec.js:7542:// saveConfig() was a whole-document set() without merge, used for four PARTIAL
./e2e/data-safety.spec.js:7546:// semester another admin had created, and — after a failed loadConfig() —
./e2e/data-safety.spec.js:7553:// loadConfig() no longer falls back to defaults on a read error either: a
./e2e/data-safety.spec.js:7562:test.describe('Data Safety — camp seasons Phase 1: appData writes are field paths, and loadConfig() goes loud', () => {
./e2e/data-safety.spec.js:7663:        const savedConfig = currentConfig, savedFlag = lessonDataLoadedSuccessfully;
./e2e/data-safety.spec.js:7673:          await loadConfig();
./e2e/data-safety.spec.js:7676:            flag: lessonDataLoadedSuccessfully,
./e2e/data-safety.spec.js:7679:            adoptedDefaults: !!currentConfig?.semesters?.['spring-2026'] && Object.keys(currentConfig?.semesters || {}).length <= 2,
./e2e/data-safety.spec.js:7685:          currentConfig = savedConfig; lessonDataLoadedSuccessfully = savedFlag;
./e2e/data-safety.spec.js:7698:        const savedConfig = currentConfig, savedFlag = lessonDataLoadedSuccessfully;
./e2e/data-safety.spec.js:7705:          await loadConfig();
./e2e/data-safety.spec.js:7708:            flag: lessonDataLoadedSuccessfully,
./e2e/data-safety.spec.js:7709:            hasDefaults: !!currentConfig?.semesters,
./e2e/data-safety.spec.js:7711:            hasSummer2026: !!currentConfig?.semesters?.['summer-2026'],
./e2e/data-safety.spec.js:7715:          currentConfig = savedConfig; lessonDataLoadedSuccessfully = savedFlag;
./e2e/data-safety.spec.js:7728:  test('RED (1.2): loadConfig() no longer auto-adds summer-2026 — it would resurrect a deleted season with a whole-document write', async ({ browser }) => {
./e2e/data-safety.spec.js:7736:        const savedConfig = currentConfig;
./e2e/data-safety.spec.js:7748:          await loadConfig();
./e2e/data-safety.spec.js:7749:          return { keys: Object.keys(currentConfig.semesters), writes: writes.length };
./e2e/data-safety.spec.js:7750:        } finally { curriculumDb.collection = realCollection; currentConfig = savedConfig; }
./e2e/data-safety.spec.js:7768:        currentConfig.semesters['test-pub'] = { name: 'TEST Pub', semesterType: 'weekly', published: false };
./e2e/data-safety.spec.js:7769:        try { await toggleSemesterPublish('test-pub', true); } finally { delete currentConfig.semesters['test-pub']; }
./e2e/data-safety.spec.js:7779:        currentConfig.semesters['test-del'] = { name: 'TEST Del', semesterType: 'weekly' };
./e2e/data-safety.spec.js:7783:        finally { window.confirm = realConfirm; window.alert = realAlert; delete currentConfig.semesters['test-del']; }
./e2e/data-safety.spec.js:7795:  test('RED (1.2): a Settings save writes only the fields the semester TYPE owns — a camp season never gets numWeeks, breakWeeks or a class roster', async ({ browser }) => {
./e2e/data-safety.spec.js:7884:// the listener (an onSnapshot never errors offline and would hang the app),
./e2e/data-safety.spec.js:7886:// successful load would otherwise set lessonDataLoadedSuccessfully = true and
./e2e/data-safety.spec.js:7898:      const saved = { mode: getSeasonRegistryMode(), flag: lessonDataLoadedSuccessfully };
./e2e/data-safety.spec.js:7904:        if (saved.mode === 'legacy') await loadSeasonRegistryMode({ read: async () => ({ exists: false, metadata: { fromCache: false } }) });
./e2e/data-safety.spec.js:7905:        lessonDataLoadedSuccessfully = saved.flag;
./e2e/data-safety.spec.js:7925:        const deniedFlag = lessonDataLoadedSuccessfully;
./e2e/data-safety.spec.js:7928:        const offlineFlag = lessonDataLoadedSuccessfully;
./e2e/data-safety.spec.js:7961:        out.flagAfter = lessonDataLoadedSuccessfully;
./e2e/data-safety.spec.js:7982:        // A hand-driven emitter stands in for onSnapshot.
./e2e/data-safety.spec.js:8053:        let saveThrew = false;
./e2e/data-safety.spec.js:8055:          await saveSingleLesson('summer-2026', 'TEST|||TEST_DATA_SAFETY|||Block 1|||TEST Project Alpha', { introPitch: 'must be refused' });
./e2e/data-safety.spec.js:8056:        } catch { saveThrew = true; }
./e2e/data-safety.spec.js:8058:          loadThrew, saveThrew,
./e2e/data-safety.spec.js:8060:          flag: lessonDataLoadedSuccessfully,
./e2e/data-safety.spec.js:8065:      expect(r.saveThrew).toBe(true);
./e2e/data-safety.spec.js:8107:      currentConfig.semesters[sem] = {
./e2e/data-safety.spec.js:8125:  test('RED: a plan saved in 2099 lands in its own document and leaves 2026\'s byte-for-byte identical', async ({ browser }) => {
./e2e/data-safety.spec.js:8137:        await saveSingleLesson(sem, key, {
./e2e/data-safety.spec.js:8149:      // …and the reverse direction: a 2026 save leaves the 2099 doc alone.
./e2e/data-safety.spec.js:8151:        await saveSingleLesson('summer-2026', key, { introPitch: '2026 plan — edited later' });
./e2e/data-safety.spec.js:8172:        await saveCampComplete(sem, 'TEST', 'TEST_DATA_SAFETY', false);
./e2e/data-safety.spec.js:8359:        const realSaveLessons = window.saveLessonData;
./e2e/data-safety.spec.js:8362:        window.saveLessonData = async (...a) => { lessonWrites.push(a[0]); };
./e2e/data-safety.spec.js:8369:          return { appDataWrites, lessonWrites, created: JSON.parse(JSON.stringify(currentConfig.semesters[`summer-${reg.season}`] || null)) };
./e2e/data-safety.spec.js:8371:          window.updateAppData = realUpdate; window.saveLessonData = realSaveLessons; window.readAppDataFromServer = realRead;
./e2e/data-safety.spec.js:8372:          delete currentConfig.semesters[`summer-${reg.season}`];
./e2e/data-safety.spec.js:8449:          delete currentConfig.semesters['test-autumn-2031'];
./e2e/data-safety.spec.js:8482:        currentConfig.semesters[sem] = { name: 'TEST Summer 2031', semesterType: 'summer-camp', season: '2031', published: false };
./e2e/data-safety.spec.js:8490:        window.updateAppData = async (u) => { appDataWrites.push(Object.keys(u)); delete currentConfig.semesters[sem]; };
./e2e/data-safety.spec.js:8498:          delete currentConfig.semesters[sem]; delete currentLessonData[sem];
./e2e/data-safety.spec.js:8506:      // Only the appData entry is written, and curriculum/lessonData is never
./e2e/data-safety.spec.js:8528:        currentConfig.semesters[sem] = { name: 'TEST Weekly', semesterType: 'weekly' };
./e2e/data-safety.spec.js:8533:        window.updateAppData = async () => { delete currentConfig.semesters[sem]; };
./e2e/data-safety.spec.js:8536:        finally { window.confirm = realConfirm; window.updateAppData = realUpdate; window.deleteLessonData = realDelete; delete currentConfig.semesters[sem]; }
./e2e/data-safety.spec.js:8684:  test('RED (review HIGH): a Settings save still writes teacherMappings, and keeps this tab in step', async ({ browser }) => {
./e2e/data-safety.spec.js:8695:        const savedMappings = currentConfig.teacherMappings;
./e2e/data-safety.spec.js:8700:        const savedSem = JSON.parse(JSON.stringify(currentConfig.semesters[semKey] || {}));
./e2e/data-safety.spec.js:8702:        const savedWeeks = weeksEl.value;
./e2e/data-safety.spec.js:8705:          await saveSettings();
./e2e/data-safety.spec.js:8708:            inMemory: currentConfig.teacherMappings,
./e2e/data-safety.spec.js:8710:            inMemoryWeeks: currentConfig.semesters[semKey]?.numWeeks,
./e2e/data-safety.spec.js:8713:          weeksEl.value = savedWeeks;
./e2e/data-safety.spec.js:8714:          currentConfig.semesters[semKey] = savedSem;
./e2e/data-safety.spec.js:8717:          currentConfig.teacherMappings = savedMappings;
./e2e/data-safety.spec.js:8722:      // …and this tab's copy must match, or the re-render shows pre-save values
./e2e/data-safety.spec.js:8741:        const savedMode = getSeasonRegistryMode();
./e2e/data-safety.spec.js:8755:          const duringFlag = lessonDataLoadedSuccessfully;
./e2e/data-safety.spec.js:8760:            afterFlag: lessonDataLoadedSuccessfully,
./e2e/data-safety.spec.js:8766:          await loadSeasonRegistryMode({ read: async () => ({ exists: savedMode === 'legacy' ? false : true, data: () => ({ season: '2026' }), metadata: { fromCache: false } }) });
./e2e/data-safety.spec.js:8787:        const savedMode = getSeasonRegistryMode();
./e2e/data-safety.spec.js:8795:          await loadSeasonRegistryMode({ read: async () => ({ exists: savedMode === 'legacy' ? false : true, data: () => ({ season: '2026' }), metadata: { fromCache: false } }) });
./e2e/data-safety.spec.js:8813:        const savedMode = getSeasonRegistryMode();
./e2e/data-safety.spec.js:8819:          await loadSeasonRegistryMode({ read: async () => ({ exists: savedMode === 'legacy' ? false : true, data: () => ({ season: '2026' }), metadata: { fromCache: false } }) });
./e2e/data-safety.spec.js:8892:        const sem = currentConfig.semesters['summer-2026'];
./e2e/data-safety.spec.js:8929:        const sems = currentConfig.semesters;
./e2e/data-safety.spec.js:8930:        const saved = { ...sems['summer-2026'] };
./e2e/data-safety.spec.js:8964:          sems['summer-2026'] = saved;
./e2e/data-safety.spec.js:9032:        const savedFlag = lessonDataLoadedSuccessfully;
./e2e/data-safety.spec.js:9034:        lessonDataLoadedSuccessfully = false;
./e2e/data-safety.spec.js:9041:          lessonDataLoadedSuccessfully = savedFlag;
./e2e/data-safety.spec.js:9065:        currentConfig.semesters[sem] = { name: 'TEST 2031', semesterType: 'summer-camp', season: '2031', numWeeks: 4, startDate: '2031-06-01', timeSlots: [{ key: 'AM', label: 'AM' }], studios: ['SoBo'] };
./e2e/data-safety.spec.js:9073:          const afterRefusal = JSON.parse(JSON.stringify(currentConfig.semesters[sem]));
./e2e/data-safety.spec.js:9079:          const afterFailure = JSON.parse(JSON.stringify(currentConfig.semesters[sem]));
./e2e/data-safety.spec.js:9083:          delete currentConfig.semesters[sem];
./e2e/data-safety.spec.js:9108:        currentConfig.semesters[sem] = { name: 'TEST Revert', semesterType: 'weekly', published: true };
./e2e/data-safety.spec.js:9115:          const afterDelete = !!currentConfig.semesters[sem];
./e2e/data-safety.spec.js:9117:          const afterToggle = currentConfig.semesters[sem]?.published;
./e2e/data-safety.spec.js:9121:          delete currentConfig.semesters[sem];

exec
/bin/zsh -lc "rg -n -C 4 \"revision 6|Stale open tabs|Key reuse|Copy from|no-copy|Acceptance snapshot|snapshot list|serverSemesterKeys|assertSemesterStillExists|first snapshot|fromCache|doc\\('lessonData'\\)|doc\\(\\\"lessonData\\\"\\)\" /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html js/firebase-data.js js/app.js /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
js/firebase-data.js-431-function watchSeasonRegistry({ subscribe, onModeChange } = {}) {
js/firebase-data.js-432-  if (seasonRegistryUnsubscribe) { seasonRegistryUnsubscribe(); seasonRegistryUnsubscribe = null; }
js/firebase-data.js-433-  const onSnap = (snap) => {
js/firebase-data.js-434-    // Cache-only snapshots say nothing about the server's state.
js/firebase-data.js:435:    if (snap?.metadata?.fromCache) return;
js/firebase-data.js-436-    const previous = seasonRegistryMode;
js/firebase-data.js-437-    // A rules problem needs a reload to clear, by design — a later snapshot
js/firebase-data.js-438-    // must not quietly re-enable reads that were refused.
js/firebase-data.js-439-    if (previous === 'error') return;
--
js/firebase-data.js-758-
js/firebase-data.js-759-async function loadLessonData() {
js/firebase-data.js-760-  if (!curriculumDb) initCurriculumFirestore();
js/firebase-data.js-761-  try {
js/firebase-data.js:762:    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
js/firebase-data.js-763-    currentLessonData = doc.exists ? doc.data() : {};
js/firebase-data.js-764-
js/firebase-data.js-765-    // Every camp season gets its own map (Phase 1, 1.4) — no literal key.
js/firebase-data.js-766-    try {
--
js/firebase-data.js-813-  }
js/firebase-data.js-814-
js/firebase-data.js-815-  // Regular semester: save to curriculum/lessonData
js/firebase-data.js-816-  const user = getAuthUser();
js/firebase-data.js:817:  await curriculumDb.collection('curriculum').doc('lessonData').set({
js/firebase-data.js-818-    [semesterKey]: lessons,
js/firebase-data.js-819-    lastUpdated: new Date().toISOString(),
js/firebase-data.js-820-    lastUpdatedBy: user?.name || 'Unknown'
js/firebase-data.js-821-  }, { merge: true });
--
js/firebase-data.js-826-// because Firestore's merge:true may not remove nested map keys.
js/firebase-data.js-827-async function deleteLessonKey(semesterKey, lessonKey) {
js/firebase-data.js-828-  if (!curriculumDb) initCurriculumFirestore();
js/firebase-data.js-829-  const user = getAuthUser();
js/firebase-data.js:830:  await curriculumDb.collection('curriculum').doc('lessonData').update({
js/firebase-data.js-831-    [`${semesterKey}.${lessonKey}`]: firebase.firestore.FieldValue.delete(),
js/firebase-data.js-832-    lastUpdated: new Date().toISOString(),
js/firebase-data.js-833-    lastUpdatedBy: user?.name || 'Unknown'
js/firebase-data.js-834-  });
--
js/firebase-data.js-959-}
js/firebase-data.js-960-
js/firebase-data.js-961-async function deleteLessonData(semesterKey) {
js/firebase-data.js-962-  if (!curriculumDb) initCurriculumFirestore();
js/firebase-data.js:963:  await curriculumDb.collection('curriculum').doc('lessonData').update({
js/firebase-data.js-964-    [semesterKey]: firebase.firestore.FieldValue.delete()
js/firebase-data.js-965-  });
js/firebase-data.js-966-}
js/firebase-data.js-967-
--
js/firebase-data.js-971-// createNewSemester()'s pre-check (deleteSemester() drops a key locally even
js/firebase-data.js-972-// when its server-side delete failed). Backtracking audit, Phase 11.
js/firebase-data.js-973-async function readServerSemesterLessonMap(semesterKey) {
js/firebase-data.js-974-  if (!curriculumDb) initCurriculumFirestore();
js/firebase-data.js:975:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
js/firebase-data.js-976-  return snap.exists ? (snap.data()?.[semesterKey] ?? null) : null;
js/firebase-data.js-977-}
js/firebase-data.js-978-
js/firebase-data.js-979-async function backupLessonData(semesterKey) {
--
js/firebase-data.js-1167-    if (outcome !== 'stale' && callback) callback(currentLessonData);
js/firebase-data.js-1168-    return outcome;
js/firebase-data.js-1169-  };
js/firebase-data.js-1170-
js/firebase-data.js:1171:  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
js/firebase-data.js-1172-    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
js/firebase-data.js-1173-      // Skip cache-only updates
js/firebase-data.js:1174:      if (doc.metadata.fromCache && !doc.metadata.hasPendingWrites) {
js/firebase-data.js-1175-        console.log('📚 Skipping cache-only snapshot, waiting for server data...');
js/firebase-data.js-1176-        return;
js/firebase-data.js-1177-      }
js/firebase-data.js:1178:      console.log('📚 Lesson data snapshot received, from cache:', doc.metadata.fromCache, 'exists:', doc.exists);
js/firebase-data.js-1179-      if (!doc.exists) return;
js/firebase-data.js-1180-
js/firebase-data.js-1181-      const myGeneration = ++globalListenerGeneration;
js/firebase-data.js-1182-      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
--
js/firebase-data.js-1434-  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear);
js/firebase-data.js-1435-
js/firebase-data.js-1436-  console.log('💾 Saving to curriculum/lessonData with per-field paths:', Object.keys(updates));
js/firebase-data.js-1437-  try {
js/firebase-data.js:1438:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
js/firebase-data.js-1439-    console.log('✅ Successfully saved lesson to Firestore!');
js/firebase-data.js-1440-  } catch (error) {
js/firebase-data.js-1441-    console.error('❌ Error saving lesson:', error);
js/firebase-data.js-1442-    throw error;
--
js/firebase-data.js-1496-    combined[`${semesterKey}.${lessonKey}`] = firebase.firestore.FieldValue.delete();
js/firebase-data.js-1497-  }
js/firebase-data.js-1498-  combined.lastUpdated = new Date().toISOString();
js/firebase-data.js-1499-  combined.lastUpdatedBy = user?.name || 'Unknown';
js/firebase-data.js:1500:  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
js/firebase-data.js-1501-}
js/firebase-data.js-1502-
js/firebase-data.js-1503-// ─── Photo Upload (Firebase Storage) ─────────────────
js/firebase-data.js-1504-
--
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-106-      <li>The modal (count, truthful text, typed name).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-107-      <li>A JSON snapshot download: <code>classbook-&lt;key&gt;-snapshot-&lt;ISO&gt;.json</code> through a Blob link, containing <code>{ appDataEntry, lessons, cutProjects, changeLog, prepData, lessonDataBackup, diagnosticDismissals, takenAt, takenBy }</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-108-      <li>New <code>deleteWeeklySemesterTx(key)</code> in <code>firebase-data.js</code>: one <code>runTransaction</code> (the house pattern, e.g. <code>firebase-data.js:2452</code>) that re-reads <strong>both</strong> appData and lessonData, and verifies that <code>semesters[key]</code> still exists, <code>activeSemester !== key</code>, and <code>lessonData[key]</code> is deep-equal to the snapshot just downloaded. If anyone saved a lesson in that semester since, it refuses ("lessons changed while you were deleting — reload and try again"), so the snapshot always matches exactly what was deleted. Saves to <em>other</em> semesters touch the same document, so Firestore may retry the transaction. Its built-in retries are fine for a rare manual delete, and if they run out, nothing is deleted and the alert says so. It then <code>tx.update</code>s appData (<code>semesters.&lt;key&gt;</code> delete, plus <code>lastUpdated</code>/<code>lastUpdatedBy</code>) and lessonData (<code>&lt;key&gt;</code> delete). It honours <code>updateAppData</code>'s guards (<code>configLoadFailed</code>, season registry).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-109-    </ol>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:110:    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs are prevented, not accepted</strong> (Codex round 3). A new, narrow <code>onSnapshot</code> on <code>curriculum/appData</code> keeps only a set <code>serverSemesterKeys</code>, and deliberately does <em>not</em> replace <code>currentConfig</code>, so no other behaviour changes. Every writer to <code>curriculum/lessonData</code> for a weekly semester calls <code>assertSemesterStillExists(semKey)</code> first: <code>saveLessonData</code>, <code>saveSingleLesson</code>, the move/swap batch writers (today <code>firebase-data.js:802, 830, 1364-1438, 1500</code>; the executor re-greps for every <code>doc('lessonData')</code> writer). It refuses with "This semester was deleted — reload" once the listener reports the key gone. The listener costs one read at load plus one per appData change. The remaining window, a save already in flight at the instant of deletion, is milliseconds wide. If it ever happens, the orphan fragment has no appData entry, so it's invisible. Key reuse is then covered both ways: with "Copy from", the existing server pre-check (<code>app.js:4913-4916</code>) refuses. Without it, re-creating deliberately <em>adopts</em> any leftover (<code>app.js:4910-4912</code>, by design, so a deleted semester can be restored), and Phase 1 adds a server read of that key to the no-copy path that shows "N leftover lessons will be adopted — continue?" when any exist. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-111-  <li>Left alone on purpose: <code>app.js:5069-5074</code> and the <code>caCurrentSemester</code> assignment at <code>:4590</code> are dead code (round 2 confirmed that nothing reads them). This plan doesn't touch them.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-112-  <li>The Curriculum Admin bar stays read-only for "active" (it's the same audience, but one place to change it is enough).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-113-</ul>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-114-
--
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-197-  When tab A deletes that semester
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-198-  Then tab B's next lesson save refuses with "This semester was deleted — reload"
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-199-   And lessonData has no key for that semester afterwards
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-200-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:201:Scenario: reusing a deleted key without "Copy from" says what it adopts (edge)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-202-  Given lessonData holds leftover lessons under a key with no appData entry
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:203:  When a manager creates a semester with that key and no "Copy from"
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-204-  Then a confirm states "N leftover lessons will be adopted"; cancel creates nothing
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-205-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:206:Scenario: reusing it with "Copy from" (edge, existing)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-207-  Then the existing "Lesson content already exists" alert refuses, as today
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-208-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-209-Scenario: a snapshot is taken first (safety)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-210-  When the manager confirms a weekly delete
--
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-358-</ol>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-359-
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-360-<h2 id="decisions">Decisions Log (append-only)</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-361-<div class="decision">
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:362:  <strong>Sep 29, 2026: revision 6, after Codex round 3 (<code>…-codex-r3.md</code>).</strong> Snapshot contents are confirmed resolved, and the acceptance list now matches. Revision 5's "accept stale-tab orphans; the create pre-check catches them" was wrong: that pre-check runs only with "Copy from", and no-copy creation adopts leftovers by design. Replaced with prevention: a narrow appData listener tracks only the server's semester keys (it never replaces <code>currentConfig</code>), and every weekly lessonData writer checks the key still exists. The no-copy create path now tells the manager how many leftover lessons it will adopt.
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-363-</div>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-364-<div class="decision">
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-365-  <strong>Sep 29, 2026: revision 5, after Codex confirmation round 2 (<code>…-codex-r2.md</code>).</strong> Findings 1, 2, 4, 5 and the tab-handler item are confirmed resolved. Finding 3 had two gaps, both taken. (a) The snapshot also includes <code>prepData</code>, <code>lessonData_backup</code> and <code>diagnosticDismissals</code> for the key. (b) The delete transaction re-reads lessonData and refuses unless the semester's lessons deep-equal the downloaded snapshot. Retries from other semesters' saves are accepted. Stale-tab re-saves after a delete are defined as an accepted, invisible orphan that the existing <code>createNewSemester</code> pre-check catches, with a test.
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-366-</div>
--
js/app.js-3686-  updates[`${semKey}.${lessonKey}.${legacyField}`] = message;
js/app.js-3687-
js/app.js-3688-  try {
js/app.js-3689-    if (!curriculumDb) initCurriculumFirestore();
js/app.js:3690:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
js/app.js-3691-  } catch (err) {
js/app.js-3692-    console.error('Error sending Q&A message:', err);
js/app.js-3693-    alert('Error sending message: ' + err.message);
js/app.js-3694-    return;
--
js/app.js-4907-      // cache is exactly what can't be trusted for this key. Refuse unless
js/app.js-4908-      // every existing lesson is template-empty (a prior createNewSemester()'s
js/app.js-4909-      // own leftovers are safe to build on and safe to delete; anything else
js/app.js-4910-      // would be merged over silently by the slot write, then deleted on
js/app.js:4911:      // failure). The no-copy path is deliberately NOT gated: it writes no
js/app.js-4912-      // lesson data, and re-creating a deleted semester there adopts its
js/app.js-4913-      // surviving lesson data — the remedy this alert points at.
js/app.js-4914-      const existingLessonMap = await readServerSemesterLessonMap(key);
js/app.js-4915-      if (existingLessonMap && Object.values(existingLessonMap).some(l => !isTemplateEmptyLesson(l))) {
js/app.js:4916:        alert(`Lesson content already exists in Firestore under the key "${key}".\n\nIf it was left over from a deleted semester, create this semester again without "Copy from" to adopt that data.\n\nIf another admin may have just created it, reload this page first.\n\nOtherwise choose a different name.`);
js/app.js-4917-        return;
js/app.js-4918-      }
js/app.js-4919-
js/app.js-4920-      const source = currentConfig.semesters[copyFromKey];
--
js/app.js-5831-// preserves the exact prior (cache-permitting) default for any future caller.
js/app.js-5832-async function readAdminLessonDoc(semKey, lessonKey, opts = {}) {
js/app.js-5833-  if (!curriculumDb) initCurriculumFirestore();
js/app.js-5834-  const getOpts = opts.source === 'server' ? { source: 'server' } : undefined;
js/app.js:5835:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
js/app.js-5836-  return snap.exists ? (snap.data()?.[semKey]?.[lessonKey] || null) : null;
js/app.js-5837-}
js/app.js-5838-
js/app.js-5839-// Backtracking audit, Phase 8: shared by cutProject() below and Phase 11's
--
js/app.js-7198-    updates.lastUpdatedBy = user?.name || 'Unknown';
js/app.js-7199-  }
js/app.js-7200-  const docRef = isSummer
js/app.js-7201-    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
js/app.js:7202:    : curriculumDb.collection('curriculum').doc('lessonData');
js/app.js-7203-
js/app.js-7204-  try {
js/app.js-7205-    await docRef.update(updates);
js/app.js-7206-  } catch (err) {
--
js/app.js-7281-    updates.lastUpdatedBy = user?.name || 'Unknown';
js/app.js-7282-  }
js/app.js-7283-  const docRef = isSummer
js/app.js-7284-    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
js/app.js:7285:    : curriculumDb.collection('curriculum').doc('lessonData');
js/app.js-7286-
js/app.js-7287-  try {
js/app.js-7288-    await docRef.update(updates);
js/app.js-7289-  } catch (err) {
--
js/app.js-7514-  }
js/app.js-7515-  const summerSnap = await curriculumDb.collection('summerCamps_lessonData').get();
js/app.js-7516-  summerSnap.forEach(doc => tally(doc.data()));
js/app.js-7517-
js/app.js:7518:  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
js/app.js-7519-  const lessonDataDoc = lessonDataSnap.exists ? lessonDataSnap.data() : {};
js/app.js-7520-  for (const semesterLessons of Object.values(lessonDataDoc)) {
js/app.js-7521-    if (!semesterLessons || typeof semesterLessons !== 'object') continue;
js/app.js-7522-    for (const lesson of Object.values(semesterLessons)) tally(lesson);
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-126-      <li>The modal (count, truthful text, typed name).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-127-      <li>A JSON snapshot download: <code>classbook-&lt;key&gt;-snapshot-&lt;ISO&gt;.json</code> through a Blob link, containing <code>{ appDataEntry, lessons, cutProjects, changeLog, prepData, lessonDataBackup, diagnosticDismissals, takenAt, takenBy }</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-128-      <li>New <code>deleteWeeklySemesterTx(key)</code> in <code>firebase-data.js</code>: one <code>runTransaction</code> (the house pattern, e.g. <code>firebase-data.js:2452</code>) that re-reads <strong>both</strong> appData and lessonData, and verifies that <code>semesters[key]</code> still exists, <code>activeSemester !== key</code>, and <code>lessonData[key]</code> is deep-equal to the snapshot just downloaded. If anyone saved a lesson in that semester since, it refuses ("lessons changed while you were deleting — reload and try again"), so the snapshot always matches exactly what was deleted. Saves to <em>other</em> semesters touch the same document, so Firestore may retry the transaction. Its built-in retries are fine for a rare manual delete, and if they run out, nothing is deleted and the alert says so. It then <code>tx.update</code>s appData (<code>semesters.&lt;key&gt;</code> delete, plus <code>lastUpdated</code>/<code>lastUpdatedBy</code>) and lessonData (<code>&lt;key&gt;</code> delete). It honours <code>updateAppData</code>'s guards (<code>configLoadFailed</code>, season registry).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-129-    </ol>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:130:    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs (accepted, defined):</strong> a lesson editor left open on the deleted semester can still save per-field paths into <code>lessonData.&lt;key&gt;</code> afterwards (<code>firebase-data.js:1429-1437</code>). That recreates an orphan fragment with no appData entry, so it's invisible in the app and loses nothing. If the key is ever reused, <code>createNewSemester</code>'s existing server pre-check (<code>app.js:4913-4916</code>) detects the leftover content and says so. Blocking it outright would mean a server read before every lesson save, which this plan doesn't take on. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-131-  <li>Left alone on purpose: <code>app.js:5069-5074</code> and the <code>caCurrentSemester</code> assignment at <code>:4590</code> are dead code (round 2 confirmed that nothing reads them). This plan doesn't touch them.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-132-  <li>The Curriculum Admin bar stays read-only for "active" (it's the same audience, but one place to change it is enough).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-133-</ul>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-134-
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-530-/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-105-      <li>The modal (count, truthful text, typed name).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-531-/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:106:      <li>A JSON snapshot download: <code>classbook-&lt;key&gt;-snapshot-&lt;ISO&gt;.json</code> through a Blob link, containing <code>{ appDataEntry, lessons, cutProjects, changeLog, prepData, lessonDataBackup, diagnosticDismissals, takenAt, takenBy }</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-532-/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:107:      <li>New <code>deleteWeeklySemesterTx(key)</code> in <code>firebase-data.js</code>: one <code>runTransaction</code> (the house pattern, e.g. <code>firebase-data.js:2452</code>) that re-reads <strong>both</strong> appData and lessonData, and verifies that <code>semesters[key]</code> still exists, <code>activeSemester !== key</code>, and <code>lessonData[key]</code> is deep-equal to the snapshot just downloaded. If anyone saved a lesson in that semester since, it refuses ("lessons changed while you were deleting — reload and try again"), so the snapshot always matches exactly what was deleted. Saves to <em>other</em> semesters touch the same document, so Firestore may retry the transaction. Its built-in retries are fine for a rare manual delete, and if they run out, nothing is deleted and the alert says so. It then <code>tx.update</code>s appData (<code>semesters.&lt;key&gt;</code> delete, plus <code>lastUpdated</code>/<code>lastUpdatedBy</code>) and lessonData (<code>&lt;key&gt;</code> delete). It honours <code>updateAppData</code>'s guards (<code>configLoadFailed</code>, season registry).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-533-/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-108-    </ol>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:534:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:109:    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs (accepted, defined):</strong> a lesson editor left open on the deleted semester can still save per-field paths into <code>lessonData.&lt;key&gt;</code> afterwards (<code>firebase-data.js:1429-1437</code>). That recreates an orphan fragment with no appData entry, so it's invisible in the app and loses nothing. If the key is ever reused, <code>createNewSemester</code>'s existing server pre-check (<code>app.js:4913-4916</code>) detects the leftover content and says so. Blocking it outright would mean a server read before every lesson save, which this plan doesn't take on. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-535-/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-110-  <li>Left alone on purpose: <code>app.js:5069-5074</code> and the <code>caCurrentSemester</code> assignment at <code>:4590</code> are dead code (round 2 confirmed that nothing reads them). This plan doesn't touch them.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-536-/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-111-  <li>The Curriculum Admin bar stays read-only for "active" (it's the same audience, but one place to change it is enough).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-537-/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-112-</ul>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-538-/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-113-
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-905-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-457-./e2e/day-off-teacher.spec.js:491:      window.updateAppData = async (u) => { out.push(u); };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-906-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-458-./e2e/day-off-teacher.spec.js:492:      try { await toggleSemesterPublish(Y, true); } finally { window.updateAppData = real; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-907-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:459:./e2e/day-off-teacher.spec.js:503:  test('T14: the six other lesson writers still refuse an SDOC key, and curriculum/lessonData never gets one', async ({ browser }) => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-908-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:460:./e2e/day-off-teacher.spec.js:528:      const plan = await __sdocT.read('lessonData', dayOffPlanDocId(Y, campId, title));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:909:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:461:./e2e/day-off-teacher.spec.js:530:      const d = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-910-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:462:./e2e/day-off-teacher.spec.js:637:    const signoffBefore = await planner.evaluate(({ Y, c }) => __sdocT.read('lessonData', dayOffSignoffDocId(Y, c)), { Y, c: clay.id });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-911-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:463:./e2e/day-off-teacher.spec.js:654:    expect(await planner.evaluate(({ Y, c }) => __sdocT.read('lessonData', dayOffSignoffDocId(Y, c)), { Y, c: clay.id })).toEqual(signoffBefore);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-912-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:464:./e2e/day-off-teacher.spec.js:697:    await planner.evaluate(({ Y, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'Clay Creatures'))
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-913-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:465:./e2e/day-off-teacher.spec.js:727:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'Glaze Day')).set({ yearKey: Y, campId: c, projectTitle: 'Glaze Day', projectLinks: 'https://not-an-array.test', projectDetails: { oops: 1 } }), { Y, c: clay.id });
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-956-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-508-./e2e/fixtures/seed/curriculum.json:130:  "cutProjects": {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-957-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-509-./e2e/fixtures/seed/curriculum.json:158:  "changeLog": {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-958-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-510-./e2e/fixtures/seed/curriculum.json:168:  "prepData": {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-959-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-511-./e2e/day-off-camps.spec.js:11: * this tab's config — it is never written to appData — except in the one
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:960:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:512:./e2e/day-off-camps.spec.js:58:        const d = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-961-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-513-./e2e/day-off-camps.spec.js:93:        await curriculumDb.collection('curriculum').doc('appData').update({ [`semesters.${k}`]: firebase.firestore.FieldValue.delete() });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-962-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-514-./e2e/day-off-camps.spec.js:102:    await page.evaluate(() => { window.__appDataWrites = 0; const u = window.updateAppData; window.updateAppData = async (...a) => { window.__appDataWrites++; return u(...a); }; });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-963-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-515-./e2e/day-off-camps.spec.js:110:    expect(await page.evaluate(() => window.__appDataWrites)).toBe(0);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-964-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:516:./e2e/day-off-camps.spec.js:232:    await page.evaluate(({ Y, id, planId }) => __sdocT.write('lessonData', planId, { yearKey: Y, campId: id, projectTitle: 'Clay Creatures', introPitch: 'TEST pitch' }), { Y, id: camp.id, planId });
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-985-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-540-./e2e/day-off-camps.spec.js:635:    await page.evaluate(() => { window.__captured = []; window.__origUpdate = window.updateAppData; window.updateAppData = async (u) => { window.__captured.push(JSON.parse(JSON.stringify(u))); }; });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-986-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-541-./e2e/day-off-camps.spec.js:671:      await page.evaluate(() => { window.updateAppData = window.__origUpdate; });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-987-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-542-./e2e/day-off-camps.spec.js:679:    await page.evaluate(() => { window.__appDataWrites = 0; const u = window.updateAppData; window.updateAppData = async (...a) => { window.__appDataWrites++; return u(...a); }; });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-988-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-543-./e2e/day-off-camps.spec.js:682:    expect(await page.evaluate(() => window.__appDataWrites)).toBe(0);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:989:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:544:./e2e/day-off-camps.spec.js:706:      const lessonDoc = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-990-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:545:./e2e/day-off-camps.spec.js:731:        const guard = lessonDataLoadedSuccessfully;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-991-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:546:./e2e/day-off-camps.spec.js:742:    expect(await page.evaluate(() => lessonDataLoadedSuccessfully)).toBe(true);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-992-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-547-./e2e/README.md:68:behave the same way; one spec test depends on it (`backupStatus` is
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-993-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-548-./e2e/README.md:72:Fixture shapes follow the Sep 2026 production backup. **Every name, email,
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1043-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-598-./e2e/data-safety.spec.js:2433:// (unlike the per-semester cutProjects doc), so every test below intercepts
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1044-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-599-./e2e/data-safety.spec.js:2827:          return { doc: () => ({ set: async () => { throw new Error('Simulated changeLog write failure'); } }) };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1045-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:600:./e2e/data-safety.spec.js:2949:  test('sendQaReply() routes a summer-semester reply to summerCamps_lessonData, not curriculum/lessonData', async ({ browser }) => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1046-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:601:./e2e/data-safety.spec.js:2978:      expect(nonSummerDoc).toBeNull(); // must NOT have landed in curriculum/lessonData under a 'summer-2026' key
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1047:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:602:./e2e/data-safety.spec.js:3079:          await curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1048-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:603:./e2e/data-safety.spec.js:3100:  test('sendHelpResponse() routes a summer-semester reply to summerCamps_lessonData, not curriculum/lessonData', async ({ browser }) => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1049-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:604:./e2e/data-safety.spec.js:3134:      expect(nonSummerDoc).toBeNull(); // must NOT have landed in curriculum/lessonData under a 'summer-2026' key
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1050:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:605:./e2e/data-safety.spec.js:3203:          await curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1051-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:606:./e2e/data-safety.spec.js:3832:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1052-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-607-./e2e/data-safety.spec.js:3899:// appData is Manager+-only under Firestore rules (this repo's TEST_ account
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1053-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-608-./e2e/data-safety.spec.js:3943:      // Phase 1 (1.2): the config writer is updateAppData(), which is handed
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1054-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-609-./e2e/data-safety.spec.js:3947:        const original = window.updateAppData;
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1075-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-630-./e2e/data-safety.spec.js:4284:          window.updateAppData = originalSaveConfig;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1076-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-631-./e2e/data-safety.spec.js:4332:        const originalSaveConfig = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1077-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-632-./e2e/data-safety.spec.js:4342:        window.updateAppData = async () => { saveConfigCalls++; };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1078-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-633-./e2e/data-safety.spec.js:4364:          window.updateAppData = originalSaveConfig;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1079:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:634:./e2e/data-safety.spec.js:4434:      await page.evaluate(({ semKey, key, entry }) => curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1080-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-635-./e2e/data-safety.spec.js:4462:      const role = await page.evaluate(() => getAuthUser()?.role);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1081-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-636-./e2e/data-safety.spec.js:4463:      const me = await page.evaluate(() => getAuthUser()?.name);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1082-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:637:./e2e/data-safety.spec.js:4512:      // leave the real curriculum/lessonData listener subscribed, so the
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1083:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:638:./e2e/data-safety.spec.js:4546:      await page.evaluate(({ semKey, key, entry }) => curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1084-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:639:./e2e/data-safety.spec.js:4624:  test('guard (review): a summer-camp semester key is refused — nothing is written into curriculum/lessonData under it', async ({ browser }) => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1085-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:640:./e2e/data-safety.spec.js:4655:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1086-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:641:./e2e/data-safety.spec.js:4711:  // The curriculum/lessonData listener (re-subscribed by initSummerContext's
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1087-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:642:./e2e/data-safety.spec.js:4719:      if (typeof lessonDataUnsubscribe === 'function') lessonDataUnsubscribe();
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1212-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-768-./CLASSBOOK-DATA-SAFETY-PLAN.md:596:**Verify**: `cat ~/tinker-backups/logs/backup.log | tail -5` — confirm backups are running. Should see a ✅ entry within the last 30 minutes.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1213-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:769:./CLASSBOOK-DATA-SAFETY-PLAN.md:633:const destDoc = await curriculumDb.collection('summerCamps_lessonData').doc(encodeFirestoreKey(newDestKey)).get();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1214-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-770-./CLASSBOOK-DATA-SAFETY-PLAN.md:682:  lastEditedBy: getAuthUser()?.name || 'Unknown',
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1215-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:771:./CLASSBOOK-DATA-SAFETY-PLAN.md:702:const stripped = { ...lessonData };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1216:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:772:./CLASSBOOK-DATA-SAFETY-PLAN.md:705:await curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1217-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:773:./CLASSBOOK-DATA-SAFETY-PLAN.md:720:await curriculumDb.collection('summerCamps_lessonData').doc(encodeFirestoreKey(lessonKey)).set(cleanData, { merge: true });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1218-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:774:./CLASSBOOK-DATA-SAFETY-PLAN.md:723:const verification = await curriculumDb.collection('summerCamps_lessonData').doc(encodeFirestoreKey(lessonKey)).get();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1219-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-775-./CLASSBOOK-DATA-SAFETY-PLAN.md:792:- Comparison to yesterday's backup count
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1220-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:776:./CLASSBOOK-DATA-SAFETY-PLAN.md:795:Data source: read `summerCamps_lessonData` and group by teacher. Compare to latest backup file.
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1267-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-823-./js/firebase-data.js:599:  if (prepDataUnsubscribe) prepDataUnsubscribe();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1268-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-824-./js/firebase-data.js:600:  prepDataUnsubscribe = curriculumDb.collection('curriculum').doc('prepData')
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1269-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-825-./js/firebase-data.js:721:  const user = getAuthUser();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1270-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:826:./js/firebase-data.js:730:// ─── Lesson Data (curriculum/lessonData) ─────────────
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1271:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:827:./js/firebase-data.js:762:    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1272-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:828:./js/firebase-data.js:779:      lessonDataLoadedSuccessfully = true;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1273-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:829:./js/firebase-data.js:784:      lessonDataLoadedSuccessfully = false;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1274-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:830:./js/firebase-data.js:789:    lessonDataLoadedSuccessfully = false;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1275-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:831:./js/firebase-data.js:803:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1276-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:832:./js/firebase-data.js:815:  // Regular semester: save to curriculum/lessonData
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1277-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-833-./js/firebase-data.js:816:  const user = getAuthUser();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1278:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:834:./js/firebase-data.js:817:  await curriculumDb.collection('curriculum').doc('lessonData').set({
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1279-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-835-./js/firebase-data.js:829:  const user = getAuthUser();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1280:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:836:./js/firebase-data.js:830:  await curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1281-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-837-./js/firebase-data.js:842:  const user = getAuthUser();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1282-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:838:./js/firebase-data.js:851:  for (const [lessonKey, lessonData] of Object.entries(lessons)) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1283-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:839:./js/firebase-data.js:853:    if (!hasContent(lessonData)) continue;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1284-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:840:./js/firebase-data.js:854:    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1285-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:841:./js/firebase-data.js:857:    const stripped = { ...lessonData };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1286-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:842:./js/firebase-data.js:895:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1287-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:843:./js/firebase-data.js:925:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1288:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:844:./js/firebase-data.js:963:  await curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1289-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:845:./js/firebase-data.js:968:// Forced-server read of one semester's whole lesson map in curriculum/lessonData
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1290:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:846:./js/firebase-data.js:975:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1291-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-847-./js/firebase-data.js:979:async function backupLessonData(semesterKey) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1292-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-848-./js/firebase-data.js:984:  const user = getAuthUser();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1293-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:849:./js/firebase-data.js:985:  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1294-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-850-./js/firebase-data.js:987:    backupDate: new Date().toISOString(),
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1301-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:857:./js/firebase-data.js:1078:// shared curriculum/lessonData doc re-runs the summer collection reload.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1302-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:858:./js/firebase-data.js:1116:  if (lessonDataUnsubscribe) lessonDataUnsubscribe();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1303-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:859:./js/firebase-data.js:1143:      lessonDataLoadedSuccessfully = true;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1304-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:860:./js/firebase-data.js:1149:      lessonDataLoadedSuccessfully = false;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1305:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:861:./js/firebase-data.js:1171:  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1306-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:862:./js/firebase-data.js:1182:      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1307-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-863-./js/firebase-data.js:1198:// ─── Cut Projects (curriculum/cutProjects) ───────────
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1308-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-864-./js/firebase-data.js:1203:    const doc = await curriculumDb.collection('curriculum').doc('cutProjects').get();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1309-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-865-./js/firebase-data.js:1214:  const user = getAuthUser();
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1331-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:887:./js/firebase-data.js:1429:  // Regular semester: curriculum/lessonData is one shared doc across every
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1332-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:888:./js/firebase-data.js:1433:  // actually present in lessonData (Data Safety Plan Stage 2D).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1333-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:889:./js/firebase-data.js:1434:  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1334-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:890:./js/firebase-data.js:1436:  console.log('💾 Saving to curriculum/lessonData with per-field paths:', Object.keys(updates));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1335:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:891:./js/firebase-data.js:1438:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1336-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:892:./js/firebase-data.js:1447:// object for ONE lesson within the shared curriculum/lessonData document,
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1337-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:893:./js/firebase-data.js:1448:// given an already-finalized lessonData object. Extracted from
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1338-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:894:./js/firebase-data.js:1455:function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = []) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1339-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:895:./js/firebase-data.js:1457:  const stripped = { ...lessonData };
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1343-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:899:./js/firebase-data.js:1490:  for (const { lessonKey, lessonData, fieldsToClear } of writes) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1344-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:900:./js/firebase-data.js:1491:    lessonData.lastEditedBy = user?.name || 'Unknown';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1345-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:901:./js/firebase-data.js:1492:    lessonData.lastEditedAt = new Date().toISOString();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1346-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:902:./js/firebase-data.js:1493:    Object.assign(combined, buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear || []));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1347:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:903:./js/firebase-data.js:1500:  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1348-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:904:./js/firebase-data.js:1554:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1349-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:905:./js/firebase-data.js:1577:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1350-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:906:./js/firebase-data.js:1651:  // Every successful summer load sets lessonDataLoadedSuccessfully = true and
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1351-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:907:./js/firebase-data.js:1814:    // 6. Load saved lesson plans from summerCamps_lessonData
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1414-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-977-./js/app.js:3375:  tr.querySelector('.te-mat-delete').addEventListener('click', () => tr.remove());
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1415-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:978:./js/app.js:3623:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1416-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:979:./js/app.js:3631:  // under that key into curriculum/lessonData is never right. Routed by TYPE
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1417-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-980-./js/app.js:3664:  const user = getAuthUser();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1418:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:981:./js/app.js:3690:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1419-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-982-./js/app.js:3771:  const user = getAuthUser();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1420-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-983-./js/app.js:3800:  const user = getAuthUser();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1421-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-984-./js/app.js:3829:  const user = getAuthUser();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1422-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-985-./js/app.js:3879:  const user = getAuthUser();
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1445-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1008:./js/app.js:5368:// summerCamps_lessonData doc exists yet, so saveAdminEdit() skips the check
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1446-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1009:./js/app.js:5563:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1447-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1010:./js/app.js:5633:  // summerCamps_lessonData doc exists (a missing doc means "never saved",
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1448-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1011:./js/app.js:5827:// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1449:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1012:./js/app.js:5835:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1450-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1013:./js/app.js:5851:      const snap = await curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key)).get({ source: 'server' });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1451-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1014:./js/app.js:5945:        [{ lessonKey: newDestKey, lessonData: movedLesson, fieldsToClear: destFieldsToClear }],
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1452-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1015:./js/app.js:6017:            { lessonKey: sourceKeyForSwap, lessonData: swappedSource, fieldsToClear: sourceFieldsToClear },
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1453-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1016:./js/app.js:6018:            { lessonKey: newDestKey, lessonData: swappedDest, fieldsToClear: destFieldsToClearSwap }
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1471-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1041-./js/app.js:6784:  const user = getAuthUser();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1472-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1042:./js/app.js:7146:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1473-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1043-./js/app.js:7177:  const user = getAuthUser();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1474-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1044:./js/app.js:7201:    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1475:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1045:./js/app.js:7202:    : curriculumDb.collection('curriculum').doc('lessonData');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1476-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1046:./js/app.js:7231:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1477-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1047-./js/app.js:7262:  const user = getAuthUser();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1478-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1048:./js/app.js:7284:    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1479:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1049:./js/app.js:7285:    : curriculumDb.collection('curriculum').doc('lessonData');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1480-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1050-./js/app.js:7411:// ~/tinker-backups/backup.js runs every 30 min, 8am-6pm Mountain Time,
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1481-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1051-./js/app.js:7421:// Pure render — takes already-fetched backupStatus/latest data (or null) and
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1482-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1052-./js/app.js:7425:  const container = document.getElementById('ca-backup-health-content');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1483-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1053-./js/app.js:7429:    container.innerHTML = '<p class="ca-empty-hint">No backup status recorded yet.</p>';
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1494-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1065-./js/app.js:7479:    container.innerHTML = '<p class="ca-backup-flag">⚠️ Failed to load backup status.</p>';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1495-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1066-./js/app.js:7484:  const content = document.getElementById('ca-backup-health-content');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1496-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1067-./js/app.js:7492:// Same >10% drop threshold ~/tinker-backups/backup.js already uses for its
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1497-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1068:./js/app.js:7515:  const summerSnap = await curriculumDb.collection('summerCamps_lessonData').get();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1498:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1069:./js/app.js:7518:  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1499-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1070:./js/app.js:7519:  const lessonDataDoc = lessonDataSnap.exists ? lessonDataSnap.data() : {};
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1500-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1071:./js/app.js:7520:  for (const semesterLessons of Object.values(lessonDataDoc)) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1501-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1072-./js/app.js:7528:// Pure render — takes already-computed live and backup-derived per-teacher
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1502-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1073-./js/app.js:7529:// counts (backupCounts may be null if unavailable/inaccessible), so it's
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1806-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2008-   959	}
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1807-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2009-   960	
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1808-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2010-   961	async function deleteLessonData(semesterKey) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1809-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2011-   962	  if (!curriculumDb) initCurriculumFirestore();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1810:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2012:   963	  await curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1811-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2013-   964	    [semesterKey]: firebase.firestore.FieldValue.delete()
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1812-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2014-   965	  });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1813-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2015-   966	}
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1814-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2016-   967	
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1818-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2020-   971	// createNewSemester()'s pre-check (deleteSemester() drops a key locally even
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1819-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2021-   972	// when its server-side delete failed). Backtracking audit, Phase 11.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1820-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2022-   973	async function readServerSemesterLessonMap(semesterKey) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1821-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2023-   974	  if (!curriculumDb) initCurriculumFirestore();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1822:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2024:   975	  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1823-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2025-   976	  return snap.exists ? (snap.data()?.[semesterKey] ?? null) : null;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1824-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2026-   977	}
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1825-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2027-   978	
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1826-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2028-   979	async function backupLessonData(semesterKey) {
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1873-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2458-js/firebase-data.js:461:    currentSeasonDocRef().onSnapshot({ includeMetadataChanges: true }, next, error));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1874-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2459-js/firebase-data.js:525:    .onSnapshot(doc => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1875-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2460-js/firebase-data.js:601:    .onSnapshot(doc => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1876-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2461-js/firebase-data.js:802:async function saveLessonData(semesterKey, lessons) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1877:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2462:js/firebase-data.js:830:  await curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1878-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2463-js/firebase-data.js:837:async function saveSummerCampLessonData(semKey, lessons) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1879:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2464:js/firebase-data.js:963:  await curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1880-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2465-js/firebase-data.js:1083:// generation counter is module-scoped across every setupLessonDataListener()
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1881-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2466-js/firebase-data.js:1102:// Set by setupLessonDataListener() so a season-registry mode change (legacy →
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1882-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2467-js/firebase-data.js:1112:function setupLessonDataListener(callback) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1883-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2468-js/firebase-data.js:1172:    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1884-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2469:js/firebase-data.js:1323:// distinction setupLessonDataListener already makes for snapshots, above).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1885-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2470:js/firebase-data.js:1364:async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1886-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2471:js/firebase-data.js:1436:  console.log('💾 Saving to curriculum/lessonData with per-field paths:', Object.keys(updates));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1887:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2472:js/firebase-data.js:1438:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1888-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2473-js/firebase-data.js:1475:async function saveMultipleLessonFields(semesterKey, writes = [], deletes = []) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1889:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2474:js/firebase-data.js:1500:  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1890-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2475-js/app.js:676:  setupLessonDataListener((data) => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1891-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2476-js/app.js:3440:async function saveTeacherEdit(lessonKey, originalLesson) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1892:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2477:js/app.js:3690:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1893-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2478-js/app.js:5038:  setupLessonDataListener((data) => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1894-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2479-js/firebase-data.js:6://   curriculum/prepData    — prep team data by semester/week
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1895-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2480-js/firebase-data.js:8://   curriculum/cutProjects — projects removed from schedule, saved for reuse
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1896-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2481-js/firebase-data.js:9://   curriculum/changeLog   — audit trail of moves/swaps/cuts
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1938-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2730-   813	  }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1939-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2731-   814	
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1940-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2732:   815	  // Regular semester: save to curriculum/lessonData
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1941-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2733-   816	  const user = getAuthUser();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1942:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2734:   817	  await curriculumDb.collection('curriculum').doc('lessonData').set({
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1943-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2735-   818	    [semesterKey]: lessons,
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1944-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2736-   819	    lastUpdated: new Date().toISOString(),
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1945-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2737-   820	    lastUpdatedBy: user?.name || 'Unknown'
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1946-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2738-   821	  }, { merge: true });
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1951-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2743-   826	// because Firestore's merge:true may not remove nested map keys.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1952-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2744-   827	async function deleteLessonKey(semesterKey, lessonKey) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1953-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2745-   828	  if (!curriculumDb) initCurriculumFirestore();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1954-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2746-   829	  const user = getAuthUser();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:1955:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2747:   830	  await curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1956-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2748-   831	    [`${semesterKey}.${lessonKey}`]: firebase.firestore.FieldValue.delete(),
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1957-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2749-   832	    lastUpdated: new Date().toISOString(),
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1958-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2750-   833	    lastUpdatedBy: user?.name || 'Unknown'
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1959-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2751-   834	  });
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2024-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2835-  1167	    if (outcome !== 'stale' && callback) callback(currentLessonData);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2025-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2836-  1168	    return outcome;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2026-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2837-  1169	  };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2027-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2838-  1170	
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2028:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2839:  1171	  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2029-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2840-  1172	    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2030-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2841-  1173	      // Skip cache-only updates
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2031:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2842-  1174	      if (doc.metadata.fromCache && !doc.metadata.hasPendingWrites) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2032-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2843:  1175	        console.log('📚 Skipping cache-only snapshot, waiting for server data...');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2033-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2844-  1176	        return;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2034-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2845-  1177	      }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2035:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2846:  1178	      console.log('📚 Lesson data snapshot received, from cache:', doc.metadata.fromCache, 'exists:', doc.exists);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2036-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2847-  1179	      if (!doc.exists) return;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2037-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2848-  1180	
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2038-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2849-  1181	      const myGeneration = ++globalListenerGeneration;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2039-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:2850:  1182	      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2150-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:3053:  1434	  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2151-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3054-  1435	
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2152-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:3055:  1436	  console.log('💾 Saving to curriculum/lessonData with per-field paths:', Object.keys(updates));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2153-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3056-  1437	  try {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2154:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:3057:  1438	    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2155-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3058-  1439	    console.log('✅ Successfully saved lesson to Firestore!');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2156-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3059-  1440	  } catch (error) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2157-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3060-  1441	    console.error('❌ Error saving lesson:', error);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2158-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3061-  1442	    throw error;
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2212-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3115-  1496	    combined[`${semesterKey}.${lessonKey}`] = firebase.firestore.FieldValue.delete();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2213-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3116-  1497	  }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2214-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3117-  1498	  combined.lastUpdated = new Date().toISOString();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2215-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3118-  1499	  combined.lastUpdatedBy = user?.name || 'Unknown';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2216:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:3119:  1500	  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2217-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3120-  1501	}
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2218-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3121-  1502	
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2219-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3122-  1503	// ─── Photo Upload (Firebase Storage) ─────────────────
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2220-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3123-  1504	
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2617-   959	}
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2618-   960	
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2619-   961	async function deleteLessonData(semesterKey) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2620-   962	  if (!curriculumDb) initCurriculumFirestore();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2621:   963	  await curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2622-   964	    [semesterKey]: firebase.firestore.FieldValue.delete()
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2623-   965	  });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2624-   966	}
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2625-   967	
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2629-   971	// createNewSemester()'s pre-check (deleteSemester() drops a key locally even
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2630-   972	// when its server-side delete failed). Backtracking audit, Phase 11.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2631-   973	async function readServerSemesterLessonMap(semesterKey) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2632-   974	  if (!curriculumDb) initCurriculumFirestore();
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2633:   975	  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2634-   976	  return snap.exists ? (snap.data()?.[semesterKey] ?? null) : null;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2635-   977	}
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2636-   978	
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2637-   979	async function backupLessonData(semesterKey) {
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2817-  1434	  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2818-  1435	
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2819-  1436	  console.log('💾 Saving to curriculum/lessonData with per-field paths:', Object.keys(updates));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2820-  1437	  try {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2821:  1438	    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2822-  1439	    console.log('✅ Successfully saved lesson to Firestore!');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2823-  1440	  } catch (error) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2824-  1441	    console.error('❌ Error saving lesson:', error);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2825-  1442	    throw error;
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2861-  4907	      // cache is exactly what can't be trusted for this key. Refuse unless
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2862-  4908	      // every existing lesson is template-empty (a prior createNewSemester()'s
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2863-  4909	      // own leftovers are safe to build on and safe to delete; anything else
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2864-  4910	      // would be merged over silently by the slot write, then deleted on
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2865:  4911	      // failure). The no-copy path is deliberately NOT gated: it writes no
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2866-  4912	      // lesson data, and re-creating a deleted semester there adopts its
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2867-  4913	      // surviving lesson data — the remedy this alert points at.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2868-  4914	      const existingLessonMap = await readServerSemesterLessonMap(key);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2869-  4915	      if (existingLessonMap && Object.values(existingLessonMap).some(l => !isTemplateEmptyLesson(l))) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2870:  4916	        alert(`Lesson content already exists in Firestore under the key "${key}".\n\nIf it was left over from a deleted semester, create this semester again without "Copy from" to adopt that data.\n\nIf another admin may have just created it, reload this page first.\n\nOtherwise choose a different name.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2871-  4917	        return;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2872-  4918	      }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2873-  4919	
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2874-  4920	      const source = currentConfig.semesters[copyFromKey];
--
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2926-
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2927-codex
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2928-- **Snapshot contents — RESOLVED.** Forced-server reads and all three previously omitted datasets are specified at plan lines [104–106](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:104), with test coverage at [200–203](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:200). Minor inconsistency: acceptance line [89](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:89) still lists only the original four datasets.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2929-
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2930:- **Deletion coordination/stale tabs — NOT RESOLVED.** The transaction now reads and validates `lessonData` correctly ([107](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:107), [189–192](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:189)), but revision 5 explicitly accepts stale tabs recreating orphan data instead of preventing it ([109](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:109), [194–198](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:194)). It also wrongly says the existing creation pre-check always catches that fragment: the code deliberately performs that check only when “Copy from” is selected; no-copy creation adopts the orphan ([app.js:4911](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4911)).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2931-
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2932:**NOT EXECUTION-READY — minimum:** prevent stale post-delete lesson saves, or explicitly change the round-2 safety requirement and accurately specify/test both copy and no-copy key reuse; update line 89’s snapshot list.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2933-tokens used
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2934-37,271
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2935-- **Snapshot contents — RESOLVED.** Forced-server reads and all three previously omitted datasets are specified at plan lines [104–106](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:104), with test coverage at [200–203](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:200). Minor inconsistency: acceptance line [89](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:89) still lists only the original four datasets.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2936-
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2937:- **Deletion coordination/stale tabs — NOT RESOLVED.** The transaction now reads and validates `lessonData` correctly ([107](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:107), [189–192](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:189)), but revision 5 explicitly accepts stale tabs recreating orphan data instead of preventing it ([109](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:109), [194–198](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:194)). It also wrongly says the existing creation pre-check always catches that fragment: the code deliberately performs that check only when “Copy from” is selected; no-copy creation adopts the orphan ([app.js:4911](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4911)).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-2938-
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2939:**NOT EXECUTION-READY — minimum:** prevent stale post-delete lesson saves, or explicitly change the round-2 safety requirement and accurately specify/test both copy and no-copy key reuse; update line 89’s snapshot list.

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html | sed -n '78,225p;300,375p'
nl -ba js/firebase-data.js | sed -n '780,850p;1340,1510p'
nl -ba js/app.js | sed -n '3650,3710p;7160,7310p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
    78	  <li>Clicking it asks one confirmation that names both semesters, "Make Fall 2026 the active semester? Spring 2026 stops being active.", and adds, when true:
    79	    <ul>
    80	      <li>New semester is a draft: "It's a draft — it will be published so teachers can see it." Activation publishes it in the same single write. That makes the existing "Active Semester — always visible to teachers" badge true, which it isn't today for an unpublished active semester.</li>
    81	      <li>Old semester is a weekly class semester: "Spring 2026 can then be deleted from Curriculum Admin — its lessons stay unless someone deletes it."</li>
    82	      <li>New semester is a camp season: "While Summer 2026 is active it can't be removed or unpublished — make another semester active first."</li>
    83	    </ul></li>
    84	  <li>After confirming, every place that labels the active semester updates without a reload: the header, Teacher View ("(current)"), Settings' badge/toggle, and Curriculum Admin's badge/toggle/Delete.</li>
    85	  <li><strong>Deleting a weekly semester gets a real guard, and becomes all-or-nothing:</strong>
    86	    <ul>
    87	      <li>The confirmation states how many lessons it holds, read fresh from the server, and says truthfully what happens. Its lessons are deleted. Its cut bank and change history stay stored but are no longer reachable in the Classbook unless a semester with the same key is recreated. (The current text wrongly says they're removed.)</li>
    88	      <li>You must type the semester's name to proceed (trimmed, case-insensitive).</li>
    89	      <li>Before anything is deleted, the Classbook <strong>downloads a JSON snapshot</strong> of that semester: its appData entry, lessons, cut bank, change history, prep data, lesson backup and diagnostic dismissals, all read fresh from the server. If a read fails, nothing is deleted.</li>
    90	      <li>Any tab still open on that semester refuses further lesson saves ("This semester was deleted — reload").</li>
    91	      <li>The semester's entry and its lessons are removed <strong>in one Firestore transaction</strong>: either both go or neither does. Today they're two separate writes, and a failure of the second is only logged to the console, which can leave lessons orphaned and unreachable (Codex finding 3).</li>
    92	    </ul>
    93	    Camp seasons and SDOC years keep their current (non-destructive) flows.</li>
    94	  <li>If the write fails for any reason (rules, a failed config load, or the season registry being unknown or in error), nothing changes on screen and an alert names the reason and says "Nothing was changed."</li>
    95	  <li>Nobody below manager sees the control: it's rendered only for <code>admin</code>/<code>manager</code> roles, <code>makeSemesterActive</code> refuses otherwise, and the rules refuse the write regardless.</li>
    96	</ul>
    97	<p><strong>Shape:</strong></p>
    98	<ul>
    99	  <li><code>index.html:411</code>: a new <code>onSettingsSemesterChange(value)</code> that does what Teacher View's selector does (<code>app.js:826-830</code>): set <code>#global-semester-select</code>'s value <em>first</em>, then <code>setGlobalSemester(value)</code>. Without the header sync, the header would keep showing the old semester and re-picking it would fire no change event (round 2, finding 1). Settings' options are filtered by <code>canSeeSemester</code>, like the header's.</li>
   100	  <li><code>setupRoleAccess</code> (<code>app.js:318-336</code>): hide <code>#settings-link</code> and its dot (<code>.footer-dot.write-control</code>; other <code>.footer-dot</code>s stay) for non-managers too. <code>switchTab('settings')</code>, the footer handler, <strong>and the tab button's own click handler</strong> (<code>app.js:203</code>) refuse for non-managers.</li>
   101	  <li>New <code>makeSemesterActive(key)</code> beside <code>toggleSemesterPublish</code>. Eligibility is by type (<code>isWeeklySemester(key) || isCampSeason(key)</code>), never by key prefix (there's a ratchet against prefix routing). It refuses if the user isn't admin/manager, or the key is missing or already active. It checks <code>isPublishableType(key)</code> before any auto-publish, so the two gates can't drift. The old semester's name falls back to its key if the name is missing. Then it confirms through <code>confirmModal</code> (built in this phase, so Phase 2 only adds the checkbox and the activation tests aren't rewritten), then writes through a new <code>activateSemesterTx(key, expectedActive, { publish, switchEveryone })</code> in <code>firebase-data.js</code> (Codex finding 4). It's one <code>runTransaction</code> that re-reads appData from the server and refuses, with "reload and try again", unless <code>semesters[key]</code> still exists with a name and an eligible type, and <code>activeSemester === expectedActive</code> (what the confirmation showed). Only then does it <code>tx.update</code> <code>activeSemester</code>, the publish flag if needed, the Phase 2 switch field, and <code>lastUpdated</code>/<code>lastUpdatedBy</code>. This way a stale tab can't point "active" at a semester another tab deleted, or recreate a half-semester through the dotted publish path. It honours the same guards as <code>updateAppData</code>. <code>currentConfig</code> changes only after the commit succeeds; on failure nothing local changes.</li>
   102	  <li>Re-render set after success or failure: header options, Teacher View selector, <code>renderSemesterSelector()</code>, <code>loadSettingsForm()</code>. The header's <code>change</code> listener gets the attach-once guard Teacher View already uses (<code>dataset.listenerAttached</code>), so re-rendering doesn't stack handlers.</li>
   103	  <li><code>deleteSemester</code>, weekly branch only, in this order:
   104	    <ol>
   105	      <li>Forced-server reads of everything keyed by the semester: <code>readServerSemesterLessonMap(key)</code>, <code>cutProjects[key]</code>, <code>changeLog[key]</code>, <code>prepData[key]</code>, <code>lessonData_backup[key]</code>, <code>diagnosticDismissals[key]</code> (<code>firebase-data.js:551, 979-995, 1212, 1267, 1286-1308</code>). Any rejection refuses. <code>null</code> means none and proceeds.</li>
   106	      <li>The modal (count, truthful text, typed name).</li>
   107	      <li>A JSON snapshot download: <code>classbook-&lt;key&gt;-snapshot-&lt;ISO&gt;.json</code> through a Blob link, containing <code>{ appDataEntry, lessons, cutProjects, changeLog, prepData, lessonDataBackup, diagnosticDismissals, takenAt, takenBy }</code>.</li>
   108	      <li>New <code>deleteWeeklySemesterTx(key)</code> in <code>firebase-data.js</code>: one <code>runTransaction</code> (the house pattern, e.g. <code>firebase-data.js:2452</code>) that re-reads <strong>both</strong> appData and lessonData, and verifies that <code>semesters[key]</code> still exists, <code>activeSemester !== key</code>, and <code>lessonData[key]</code> is deep-equal to the snapshot just downloaded. If anyone saved a lesson in that semester since, it refuses ("lessons changed while you were deleting — reload and try again"), so the snapshot always matches exactly what was deleted. Saves to <em>other</em> semesters touch the same document, so Firestore may retry the transaction. Its built-in retries are fine for a rare manual delete, and if they run out, nothing is deleted and the alert says so. It then <code>tx.update</code>s appData (<code>semesters.&lt;key&gt;</code> delete, plus <code>lastUpdated</code>/<code>lastUpdatedBy</code>) and lessonData (<code>&lt;key&gt;</code> delete). It honours <code>updateAppData</code>'s guards (<code>configLoadFailed</code>, season registry).</li>
   109	    </ol>
   110	    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs are prevented, not accepted</strong> (Codex round 3). A new, narrow <code>onSnapshot</code> on <code>curriculum/appData</code> keeps only a set <code>serverSemesterKeys</code>, and deliberately does <em>not</em> replace <code>currentConfig</code>, so no other behaviour changes. Every writer to <code>curriculum/lessonData</code> for a weekly semester calls <code>assertSemesterStillExists(semKey)</code> first: <code>saveLessonData</code>, <code>saveSingleLesson</code>, the move/swap batch writers (today <code>firebase-data.js:802, 830, 1364-1438, 1500</code>; the executor re-greps for every <code>doc('lessonData')</code> writer). It refuses with "This semester was deleted — reload" once the listener reports the key gone. The listener costs one read at load plus one per appData change. The remaining window, a save already in flight at the instant of deletion, is milliseconds wide. If it ever happens, the orphan fragment has no appData entry, so it's invisible. Key reuse is then covered both ways: with "Copy from", the existing server pre-check (<code>app.js:4913-4916</code>) refuses. Without it, re-creating deliberately <em>adopts</em> any leftover (<code>app.js:4910-4912</code>, by design, so a deleted semester can be restored), and Phase 1 adds a server read of that key to the no-copy path that shows "N leftover lessons will be adopted — continue?" when any exist. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
   111	  <li>Left alone on purpose: <code>app.js:5069-5074</code> and the <code>caCurrentSemester</code> assignment at <code>:4590</code> are dead code (round 2 confirmed that nothing reads them). This plan doesn't touch them.</li>
   112	  <li>The Curriculum Admin bar stays read-only for "active" (it's the same audience, but one place to change it is enough).</li>
   113	</ul>
   114	
   115	<div class="bdd">Scenario: the Settings dropdown switches semester (fix)
   116	  Given a manager on Settings with the header on Spring 2026
   117	  When they pick Fall 2026 in "Editing Semester"
   118	  Then the header shows Fall 2026 and the Settings form shows Fall's name/start date
   119	
   120	Scenario: manager makes Fall active (happy path) — real write, manager session
   121	  Given a manager on Settings for Fall 2026 (published, weekly), active = Spring 2026
   122	  When they click "Make this the active semester", UNTICK "switch everyone" (Phase 2), and confirm
   123	  Then curriculum/appData.activeSemester reads back from the emulator as "fall-2026"
   124	   And a whole-document diff of appData, ignoring lastUpdated/lastUpdatedBy (as app.js:10918 does), shows only activeSemester changed
   125	   And header "Fall 2026 (active)", Teacher View "Fall 2026 (current)", Settings badge on Fall,
   126	       Curriculum Admin shows Spring with Publish toggle and Delete
   127	
   128	Scenario: making a draft semester active publishes it (edge) — stubbed updateAppData
   129	  Given Fall 2026 is published:false
   130	  When the manager makes it active and confirms (dialog mentions publishing)
   131	  Then exactly one updateAppData call, and
   132	       Object.keys(payload).sort() equals ["activeSemester", "semesters.fall-2026.published", …Phase 2 keys]
   133	
   134	Scenario: a Summer camp season can be made active (Q1)
   135	  Given Settings on Summer 2026 (camp season)
   136	  When the manager makes it active
   137	  Then activeSemester = "summer-2026"; with nothing remembered a user lands on Summer 2026;
   138	       Prep Dashboard hidden (as for any camp selection); Teacher View and Curriculum Admin render as they do when Summer is merely selected (so a curriculum-admin/prep user with nothing remembered lands with the Curriculum Admin tab hidden, as today for Summer)
   139	
   140	Scenario: back from Summer to a class semester (edge)
   141	  Given Summer 2026 is active
   142	  When the manager makes Fall 2026 active
   143	  Then the Prep Dashboard tab reappears for Fall
   144	
   145	Scenario: cancel changes nothing (edge)
   146	  When the manager cancels the confirmation
   147	  Then updateAppData is not called and nothing on screen changes
   148	
   149	Scenario: ineligible or already active: no button (edge)
   150	  Given Settings on an SDOC year, or on the active semester
   151	  Then no "Make this the active semester" button
   152	
   153	Scenario: non-manager never sees it (UI)
   154	  Given a curriculum-admin (staff) user
   155	  Then the Settings tab button AND the footer "Settings" link are hidden
   156	   And calling switchTab('settings') leaves them where they were
   157	   And the button is not visible even though loadSettingsForm ran (assert not visible, not count 0)
   158	
   159	Scenario: the Settings dropdown keeps the header in step (regression, round 2)
   160	  Given the header shows Spring 2026
   161	  When Settings' dropdown picks Fall 2026, then the header picks Spring 2026
   162	  Then the app is back on Spring 2026 (the header change fired)
   163	
   164	Scenario: a camp season active can't be removed (edge)
   165	  Given Summer 2026 is active
   166	  Then Curriculum Admin shows no Delete and no Publish toggle for it, and the activation confirm said so
   167	
   168	Scenario: write refused by the rules (failure) — real write, staff session
   169	  Given the staff test account
   170	  When updateAppData({ activeSemester: "spring-2026" }) is called
   171	  Then it rejects with permission-denied and appData is unchanged
   172	
   173	Scenario: write refused by the app's own guard (failure)
   174	  Given seasonRegistryMode = "error" (or configLoadFailed)
   175	  When the manager confirms
   176	  Then the alert names the reason, says "Nothing was changed", and the labels, activeSemester and published flag are exactly as before
   177	
   178	Scenario: deleting a weekly semester needs its name typed (safety)
   179	  Given Spring 2026 is not active and the server holds N lessons for it
   180	  When the manager clicks Delete
   181	  Then the modal states N lessons, says the cut bank and change history stay, and requires "Spring 2026"
   182	       (trimmed, case-insensitive); a wrong or empty answer deletes nothing
   183	       (updateAppData and deleteLessonData not called)
   184	
   185	Scenario: the delete is all-or-nothing (failure) — real transaction, manager session
   186	  Given a test weekly semester with lessons in the emulator
   187	  When the transaction is made to fail (e.g. the appData entry is removed by a second writer between the read and the commit, or a stubbed commit rejects)
   188	  Then both curriculum/appData.semesters.<key> and curriculum/lessonData.<key> read back unchanged
   189	
   190	Scenario: lessons edited during the delete (failure, Codex round 2)
   191	  Given the snapshot was downloaded, then a lesson in that semester is saved by another tab before the commit
   192	  When the transaction runs
   193	  Then it refuses, nothing is deleted, and the alert asks for a reload
   194	
   195	Scenario: a stale tab can't save into a deleted semester (safety, Codex round 3)
   196	  Given tab B is open on the weekly semester's lessons
   197	  When tab A deletes that semester
   198	  Then tab B's next lesson save refuses with "This semester was deleted — reload"
   199	   And lessonData has no key for that semester afterwards
   200	
   201	Scenario: reusing a deleted key without "Copy from" says what it adopts (edge)
   202	  Given lessonData holds leftover lessons under a key with no appData entry
   203	  When a manager creates a semester with that key and no "Copy from"
   204	  Then a confirm states "N leftover lessons will be adopted"; cancel creates nothing
   205	
   206	Scenario: reusing it with "Copy from" (edge, existing)
   207	  Then the existing "Lesson content already exists" alert refuses, as today
   208	
   209	Scenario: a snapshot is taken first (safety)
   210	  When the manager confirms a weekly delete
   211	  Then a download named classbook-<key>-snapshot-*.json happens before the transaction
   212	   And it contains the appData entry, lessons, cutProjects, changeLog, prepData, lessonData_backup and diagnosticDismissals for that key
   213	
   214	Scenario: a stale tab can't activate a deleted semester (failure, Codex finding 4)
   215	  Given tab A loaded Fall; the Fall entry is then deleted on the server
   216	  When tab A makes Fall active
   217	  Then the transaction refuses, asks for a reload, and appData.activeSemester and semesters are unchanged
   218	   (no semesters.fall-2026 = {published:true} ghost)
   219	
   220	Scenario: someone changed "active" meanwhile (failure)
   221	  Given tab A's confirmation showed Spring as active, but the server now says Summer
   222	  When tab A confirms
   223	  Then it refuses and asks for a reload
   224	
   225	Scenario: the lesson count can't be read (failure)
   300	Scenario: open tabs are unaffected until reload (edge)
   301	  Given a second tab already open on Spring
   302	  When the switch is written
   303	  Then that tab stays on Spring until it reloads
   304	
   305	Scenario: deploy alone moves nobody (safety)
   306	  Given appData has no activeSemesterSwitch
   307	  When any user loads the new build
   308	  Then their remembered semester is unchanged</div>
   309	</div>
   310	
   311	<h2 id="safety">Firebase safety checklist</h2>
   312	<div class="safe">
   313	  <ul>
   314	    <li><strong>Rules:</strong> none needed. <code>curriculum/appData</code>: read for classbook users, write for manager+ only (<code>firestore.rules:652-669</code>). No new collection. Phase 1's e2e includes the non-manager refusal against the real rules.</li>
   315	    <li><strong>The Delete exposure (finding 3):</strong> making a weekly semester non-active makes it deletable, which is already true of Spring 2026 in production. Phase 1 adds the lesson count and the typed name to that delete, and the activation confirm says so. Until Phase 1 ships: <strong>don't click Delete on Spring 2026</strong>.</li>
   316	    <li><strong>Partial update:</strong> <code>updateAppData</code> (<code>update()</code> of named dotted paths; its <code>set(merge)</code> fallback fires only if appData doesn't exist, which isn't the case here). Only <code>activeSemester</code>, optionally <code>semesters.&lt;key&gt;.published</code> and <code>activeSemesterSwitch</code>, plus the existing <code>lastUpdated</code>/<code>lastUpdatedBy</code>.</li>
   317	    <li><strong>No undefined or empty values:</strong> every path is a known string or <code>true</code>. The key is validated against <code>currentConfig.semesters</code> before writing.</li>
   318	    <li><strong>Awaited:</strong> the one write is awaited, and on failure the in-memory state is restored exactly (the <code>toggleSemesterPublish</code> pattern, including "field was absent").</li>
   319	    <li><strong>Activation</strong> deletes nothing. The previous value is shown in the confirmation. To roll back, make the old semester active again.</li>
   320	    <li><strong>Weekly-semester delete is a bulk delete</strong>, so it gets the repo's snapshot rule (JSON download of everything it makes unreachable, taken from forced-server reads, aborting if a read fails) and one transaction across <code>appData</code> and <code>lessonData</code>, with a failure test proving neither document changes.</li>
   321	    <li><strong>Refuses on a bad load:</strong> inherited from <code>updateAppData</code> (config load failed, season registry unknown or error).</li>
   322	    <li><strong>Production spot-check</strong> after deploy: Christie uses the button once for real (or the console line has already done it), then checks <code>curriculum/appData.activeSemester</code> in the Firebase Console.</li>
   323	  </ul>
   324	</div>
   325	
   326	<h2 id="tests">Tests</h2>
   327	<ul>
   328	  <li>New <code>e2e/active-semester.spec.js</code> (emulator only), following the house pattern (finding 1):
   329	    <ul>
   330	      <li><strong>Payload/shape scenarios</strong> stub <code>window.updateAppData</code> and assert <code>Object.keys(payload).sort()</code> (as <code>data-safety.spec.js:7596-7610</code> does). The in-memory test semester is added to <code>currentConfig</code> in the page only, with an explicit <code>semesterType: 'weekly'</code>.</li>
   331	      <li><strong>Top leak risk:</strong> a leaked <code>activeSemesterSwitch</code> would silently move <em>every</em> later test (their contexts carry no <code>activeSemesterSwitchSeen</code>) to <code>sw.to</code>. The restore below is mandatory and read back, and a final assertion in this spec checks appData has no <code>activeSemesterSwitch</code>.</li>
   332	      <li><strong>One real round-trip</strong> runs in a manager context (<code>MANAGER_STATE_PATH</code>, first spec to use it). The test semester is created and removed through the app's own <code>updateAppData</code> in that page, and <code>activeSemester</code> is restored to <code>spring-2026</code> and <code>activeSemesterSwitch</code> deleted in <code>afterEach</code> <strong>and</strong> <code>afterAll</code>, each read back. Cleanup is self-contained and doesn't rely on file order. With <code>workers: 1</code> this file happens to run first alphabetically, and a leak would break <code>day-off-camps.spec.js</code> "SDOC R6" and <code>day-off-teacher.spec.js</code> "T20", which read the active semester.</li>
   333	      <li><strong>The restore can't run from Node</strong> (the helper is staff, and appData writes are manager-only). <code>afterEach</code>/<code>afterAll</code> open a manager browser context and call the page's own <code>updateAppData</code> (<code>activeSemester: 'spring-2026'</code>, <code>activeSemesterSwitch: FieldValue.delete()</code>, <code>semesters.&lt;test&gt;: FieldValue.delete()</code>), then read back with <code>readAppDataFromServer()</code> (<code>firebase-data.js:243-247</code>).</li>
   334	      <li>The <strong>camp-season scenario runs stubbed</strong>. Its auto-publish would otherwise flip the seed's <code>summer-2026.published: false</code>, which <code>day-off-materials</code> M10 and <code>day-off-camps</code> enumerate.</li>
   335	      <li>Payloads: use the <code>window.updateAppData</code> stub pattern (<code>data-safety.spec.js:3947-3958</code>), whose payload holds only the caller's keys. <code>withAppDataSpy</code> is file-local and adds <code>lastUpdated</code>.</li>
   336	      <li><strong>One real rules refusal</strong> uses the staff account and asserts <code>permission-denied</code> specifically (the seeded season registry is valid, so <code>updateAppData</code>'s own guard won't fire first).</li>
   337	      <li><strong>Phase 2's teacher</strong> is a fresh context (blank storageState) signed in with <code>signInViaForm(page, 'teacher')</code>, because <code>login(page,'teacher')</code> on the default state returns the admin. The remembered <code>globalSemesterKey</code> is set <em>after</em> that first load, followed by a reload, because the app writes it itself on first load and the test would otherwise pass vacuously.</li>
   338	    </ul></li>
   339	  <li>Assertions that must use types, not key prefixes: <code>isWeeklySemester</code> / <code>isCampSeason</code> (the ratchet at <code>static-checks.spec.js:108</code>).</li>
   340	  <li>The full suite stays green. Re-count at execution time; don't trust a number in this plan.</li>
   341	</ul>
   342	
   343	<h2 id="completeness">Completeness: what if this is interrupted?</h2>
   344	<ul>
   345	  <li><strong>Mid-code, before deploy:</strong> nothing is live. Resume from the branch.</li>
   346	  <li><strong>The write itself is atomic:</strong> one <code>update()</code>, so the active flag and the auto-publish can't half-happen.</li>
   347	  <li><strong>Phase 1 shipped without Phase 2:</strong> still coherent. The button works and moves nobody. (The plan still deploys both together.)</li>
   348	  <li><strong>After a switch:</strong> browsers pick it up on their next load, whenever that is. There's no deadline and nothing to finish.</li>
   349	</ul>
   350	
   351	<h2 id="resume">Resume instructions</h2>
   352	<ol>
   353	  <li>Read this plan. Check the Decisions Log for Christie's answers to Q1/Q2 and any review findings.</li>
   354	  <li>Work in a worktree on branch <code>claude/make-active-semester</code> off <code>origin/main</code>.</li>
   355	  <li>Check line numbers against current main. They were recorded at <code>2ef2e62</code>.</li>
   356	  <li>e2e: <code>npm test -- --grep "active semester"</code>. The emulator ports are fixed, so if another session's suite holds 8180, wait or shift ports locally without committing (see the memory note on classbook worktree deploys).</li>
   357	  <li>Per phase: commit, run the full suite, then a second-model implementation review. Deploy once after both, only after Christie says yes, via <code>NETLIFY_SITE_ID=… npm run deploy</code> from a clean, pushed main.</li>
   358	</ol>
   359	
   360	<h2 id="decisions">Decisions Log (append-only)</h2>
   361	<div class="decision">
   362	  <strong>Sep 29, 2026: revision 6, after Codex round 3 (<code>…-codex-r3.md</code>).</strong> Snapshot contents are confirmed resolved, and the acceptance list now matches. Revision 5's "accept stale-tab orphans; the create pre-check catches them" was wrong: that pre-check runs only with "Copy from", and no-copy creation adopts leftovers by design. Replaced with prevention: a narrow appData listener tracks only the server's semester keys (it never replaces <code>currentConfig</code>), and every weekly lessonData writer checks the key still exists. The no-copy create path now tells the manager how many leftover lessons it will adopt.
   363	</div>
   364	<div class="decision">
   365	  <strong>Sep 29, 2026: revision 5, after Codex confirmation round 2 (<code>…-codex-r2.md</code>).</strong> Findings 1, 2, 4, 5 and the tab-handler item are confirmed resolved. Finding 3 had two gaps, both taken. (a) The snapshot also includes <code>prepData</code>, <code>lessonData_backup</code> and <code>diagnosticDismissals</code> for the key. (b) The delete transaction re-reads lessonData and refuses unless the semester's lessons deep-equal the downloaded snapshot. Retries from other semesters' saves are accepted. Stale-tab re-saves after a delete are defined as an accepted, invisible orphan that the existing <code>createNewSemester</code> pre-check catches, with a test.
   366	</div>
   367	<div class="decision">
   368	  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
   369	  <ul>
   370	    <li>(1) An unticked activation now deletes any old <code>activeSemesterSwitch</code>, with a three-activation regression test.</li>
   371	    <li>(2) The "seen" marker is per user (<code>activeSemesterSwitchSeen:&lt;uid&gt;</code>), so on a shared computer every person moves once. That matches the promise "switch everyone".</li>
   372	    <li>(3) Weekly delete takes a JSON snapshot download (forced-server reads) first and removes the appData entry and lesson map in one transaction, with a failure test. The text now says the cut bank and change history stay stored but become unreachable.</li>
   373	    <li>(4) Activation runs in a transaction that verifies the target still exists and "active" hasn't changed since the confirmation, so no ghost semester can be created.</li>
   374	    <li>(5) The teacher test is staged so the first sign-in can't consume the switch, and the Phase 1 happy path unticks the box.</li>
   375	  </ul>
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

exec
/bin/zsh -lc "rg -n \"collection\\(['\\\"]curriculum['\\\"]\\).*doc\\(['\\\"]lessonData['\\\"]\\)|doc\\(['\\\"]lessonData['\\\"]\\)\" js --glob '*.js'
rg -n \"saveLessonData\\(|deleteLessonKey\\(|saveSingleLesson\\(|saveMultipleLessonFields\\(\" js/app.js js/firebase-data.js | head -120
nl -ba js/firebase-data.js | sed -n '790,840p'
nl -ba js/app.js | sed -n '3620,3700p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
js/app.js:3690:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
js/app.js:5835:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
js/app.js:7202:    : curriculumDb.collection('curriculum').doc('lessonData');
js/app.js:7285:    : curriculumDb.collection('curriculum').doc('lessonData');
js/app.js:7518:  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
js/firebase-data.js:762:    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
js/firebase-data.js:817:  await curriculumDb.collection('curriculum').doc('lessonData').set({
js/firebase-data.js:830:  await curriculumDb.collection('curriculum').doc('lessonData').update({
js/firebase-data.js:963:  await curriculumDb.collection('curriculum').doc('lessonData').update({
js/firebase-data.js:975:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
js/firebase-data.js:1171:  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
js/firebase-data.js:1438:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
js/firebase-data.js:1500:  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
js/firebase-data.js:796:// saveSingleLesson(): after a failed load, `lessons` is built from an empty or
js/firebase-data.js:802:async function saveLessonData(semesterKey, lessons) {
js/firebase-data.js:827:async function deleteLessonKey(semesterKey, lessonKey) {
js/firebase-data.js:1000:  await saveLessonData(semesterKey, lessons);
js/firebase-data.js:1364:async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
js/firebase-data.js:1449:// saveSingleLesson()'s non-summer branch above so it can be reused by
js/firebase-data.js:1450:// saveMultipleLessonFields() below without duplicating the stripping/clearing
js/firebase-data.js:1456:  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above saveSingleLesson().
js/firebase-data.js:1475:async function saveMultipleLessonFields(semesterKey, writes = [], deletes = []) {
js/firebase-data.js:1485:    throw new Error('saveMultipleLessonFields() does not support camp seasons — use saveSingleLesson() per lesson instead.');
js/firebase-data.js:2638:// saveSingleLesson()'s SDOC branch. Returns { status, doc, by, own }:
js/app.js:1807:    const result = await saveSingleLesson(yearKey, lessonKey, { planComplete: requested }, [], { dayOffAuth: dayOffAuthFor(yearKey) });
js/app.js:2359:        await saveSingleLesson(semKey, lessonKey, payload);
js/app.js:2360:        // saveSingleLesson() stamps the payload it writes; keep the in-memory
js/app.js:2843:        await saveSingleLesson(semKey, lessonKey, { planComplete: cb.checked });
js/app.js:3520:    await saveSingleLesson(semKey, lessonKey, writePayload, fieldsToClear);
js/app.js:3521:    // saveSingleLesson() stamps lastEditedBy/At onto the object it is given.
js/app.js:3606:// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
js/app.js:3611:// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
js/app.js:3620:  // Same load-guard saveSingleLesson() enforced on the old path — after a
js/app.js:4965:        await saveLessonData(key, emptyLessons);
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

codex
1. Round-3 minimum

- **Stale post-delete saves: RESOLVED in intent, but implementation design remains incomplete.** Acceptance requires refusal at [plan:90](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:90), design adds the listener/assertion at [plan:110](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:110), and the two-tab test is at [plan:195](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:195).
- **Copy/no-copy key reuse: RESOLVED.** Both behaviors are specified at [plan:110](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:110) and separately tested at [plan:201](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:201) and [plan:206](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:206).
- **Acceptance snapshot list: RESOLVED.** The full seven datasets appear in acceptance at [plan:89](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:89), implementation at [plan:104](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:104), and test at [plan:209](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:209).

2. Listener/assertion soundness

- Keeping `currentConfig` untouched is sound and preserves existing config behavior.
- Writer coverage is not explicit enough. Besides the four `firebase-data.js` sites named at plan line 110, direct weekly writers exist at [app.js:3690](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3690), [app.js:7202](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7202), and [app.js:7285](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7285). `deleteLessonKey` at [firebase-data.js:827](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:827) also needs the guard. “Executor re-greps” should be replaced by an explicit list and coverage.
- First-snapshot and cache/offline behavior are unspecified. `assertSemesterStillExists` must fail closed until a non-cache first snapshot arrives, ignore cache-only snapshots, and fail closed after listener error/offline loss of authoritative state. Otherwise an early save or stale cached key can pass. Tests should cover these states, not only deletion after a healthy initial snapshot.

**NOT EXECUTION-READY — minimum:** explicitly cover every weekly `lessonData` writer, and specify/test fail-closed initialization plus cache/offline/error semantics for `serverSemesterKeys`.
tokens used
44,507
1. Round-3 minimum

- **Stale post-delete saves: RESOLVED in intent, but implementation design remains incomplete.** Acceptance requires refusal at [plan:90](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:90), design adds the listener/assertion at [plan:110](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:110), and the two-tab test is at [plan:195](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:195).
- **Copy/no-copy key reuse: RESOLVED.** Both behaviors are specified at [plan:110](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:110) and separately tested at [plan:201](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:201) and [plan:206](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:206).
- **Acceptance snapshot list: RESOLVED.** The full seven datasets appear in acceptance at [plan:89](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:89), implementation at [plan:104](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:104), and test at [plan:209](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:209).

2. Listener/assertion soundness

- Keeping `currentConfig` untouched is sound and preserves existing config behavior.
- Writer coverage is not explicit enough. Besides the four `firebase-data.js` sites named at plan line 110, direct weekly writers exist at [app.js:3690](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3690), [app.js:7202](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7202), and [app.js:7285](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7285). `deleteLessonKey` at [firebase-data.js:827](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:827) also needs the guard. “Executor re-greps” should be replaced by an explicit list and coverage.
- First-snapshot and cache/offline behavior are unspecified. `assertSemesterStillExists` must fail closed until a non-cache first snapshot arrives, ignore cache-only snapshots, and fail closed after listener error/offline loss of authoritative state. Otherwise an early save or stale cached key can pass. Tests should cover these states, not only deletion after a healthy initial snapshot.

**NOT EXECUTION-READY — minimum:** explicitly cover every weekly `lessonData` writer, and specify/test fail-closed initialization plus cache/offline/error semantics for `serverSemesterKeys`.
