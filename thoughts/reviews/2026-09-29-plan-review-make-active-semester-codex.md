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
session id: 01a0ee4d-2063-73f2-a7a0-f0cde8db4ea7
--------
user
## Independent review — plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 3, marked execution-ready after three Claude review rounds; those reviews are in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-r{1,2,3}-claude.md — read them so you don't repeat settled points, but do not trust them).
Repo (read-only; main at 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Firestore rules: /Users/christiehubley/studio-hub/firestore.rules .

You are the independent second model. Be adversarial and verify against the code, citing file:line and concrete failing inputs:
1. Anything in Phase 1 or Phase 2 that is unsafe for production data (curriculum/appData, curriculum/lessonData) or would lose/hide data?
2. Anything the three Claude rounds missed: other readers of activeSemester / globalSemesterKey / localStorage keys; interactions with the Summer camp season as active; the "switch everyone" once-per-browser logic; the weekly-delete modal; the Settings access gating.
3. Is the e2e plan workable with the harness in e2e/ and safe for the other specs (shared emulator state, restore)?
4. Verdict: EXECUTION-READY or NOT, with the minimum list of changes.
Do not edit files. Do not run tests.
codex
I’ll review the revision-3 plan, all three prior reviews, and the actual reader/write paths in the repo and Firestore rules. I’ll keep this strictly read-only and won’t run tests.
exec
/bin/zsh -lc "pwd && sed -n '1,260p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html && for f in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-r{1,2,3}-claude.md; do echo \"FILE:"'$f"; sed -n '"'1,260p' \""'$f"; done' in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
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
  <strong>Status:</strong> <span class="status-tag ready">execution-ready: true</span>. Christie answered Q1/Q2. Reviewed in three rounds; round 3 verdict: EXECUTION-READY. Waiting for Christie's go-ahead to build.
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
<h3>Phase 1: "Make active" in Settings, plus the two things it depends on <span class="status-tag ready">execution-ready: true</span></h3>
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
  <li><strong>Deleting a weekly semester gets a real guard:</strong> the confirmation states how many lessons it holds, read fresh from the server, and says truthfully what goes. That's its lessons; its cut bank and change history stay, which the current text wrongly says are removed. You must type the semester's name to proceed (trimmed, case-insensitive). If the server read fails, nothing is deleted. Camp seasons and SDOC years keep their current (non-destructive) flows.</li>
  <li>If the write fails for any reason (rules, a failed config load, or the season registry being unknown or in error), nothing changes on screen and an alert names the reason and says "Nothing was changed."</li>
  <li>Nobody below manager sees the control: it's rendered only for <code>admin</code>/<code>manager</code> roles, <code>makeSemesterActive</code> refuses otherwise, and the rules refuse the write regardless.</li>
</ul>
<p><strong>Shape:</strong></p>
<ul>
  <li><code>index.html:411</code>: a new <code>onSettingsSemesterChange(value)</code> that does what Teacher View's selector does (<code>app.js:826-830</code>): set <code>#global-semester-select</code>'s value <em>first</em>, then <code>setGlobalSemester(value)</code>. Without the header sync, the header would keep showing the old semester and re-picking it would fire no change event (round 2, finding 1). Settings' options are filtered by <code>canSeeSemester</code>, like the header's.</li>
  <li><code>setupRoleAccess</code> (<code>app.js:318-336</code>): hide <code>#settings-link</code> and its dot (<code>.footer-dot.write-control</code>; other <code>.footer-dot</code>s stay) for non-managers too. <code>switchTab('settings')</code> and the footer handler refuse for non-managers.</li>
  <li>New <code>makeSemesterActive(key)</code> beside <code>toggleSemesterPublish</code>. Eligibility is by type (<code>isWeeklySemester(key) || isCampSeason(key)</code>), never by key prefix (there's a ratchet against prefix routing). It refuses if the user isn't admin/manager, or the key is missing or already active. It checks <code>isPublishableType(key)</code> before any auto-publish, so the two gates can't drift. The old semester's name falls back to its key if the name is missing. Then it confirms through <code>confirmModal</code> (built in this phase, so Phase 2 only adds the checkbox and the activation tests aren't rewritten), then writes <code>updateAppData({ activeSemester: key, ['semesters.'+key+'.published']: true /* only if it was false */, …Phase 2 fields })</code>. It changes <code>currentConfig</code> optimistically and restores it exactly on failure, including "field was absent".</li>
  <li>Re-render set after success or failure: header options, Teacher View selector, <code>renderSemesterSelector()</code>, <code>loadSettingsForm()</code>. The header's <code>change</code> listener gets the attach-once guard Teacher View already uses (<code>dataset.listenerAttached</code>), so re-rendering doesn't stack handlers.</li>
  <li><code>deleteSemester</code>, weekly branch only: the count comes from <code>readServerSemesterLessonMap(key)</code> (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
  <li>Left alone on purpose: <code>app.js:5069-5074</code> and the <code>caCurrentSemester</code> assignment at <code>:4590</code> are dead code (round 2 confirmed that nothing reads them). This plan doesn't touch them.</li>
  <li>The Curriculum Admin bar stays read-only for "active" (it's the same audience, but one place to change it is enough).</li>
</ul>

<div class="bdd">Scenario: the Settings dropdown switches semester (fix)
  Given a manager on Settings with the header on Spring 2026
  When they pick Fall 2026 in "Editing Semester"
  Then the header shows Fall 2026 and the Settings form shows Fall's name/start date

Scenario: manager makes Fall active (happy path) — real write, manager session
  Given a manager on Settings for Fall 2026 (published, weekly), active = Spring 2026
  When they click "Make this the active semester" and confirm
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

Scenario: the lesson count can't be read (failure)
  Given readServerSemesterLessonMap rejects
  When the manager clicks Delete
  Then an alert says nothing was deleted, and nothing was

Scenario: re-render does not stack handlers (regression)
  After makeSemesterActive runs twice, one header change calls setGlobalSemester exactly once</div>
</div>

<div class="phase" id="phase-2">
<h3>Phase 2: "Switch everyone to it" <span class="status-tag ready">execution-ready: true</span></h3>
<p><strong>Acceptance (user outcomes):</strong></p>
<ul>
  <li>The Phase 1 confirmation has a checkbox, <strong>"Also switch everyone to Fall 2026 the next time they open the Classbook"</strong>, ticked by default (Q2). Because a plain <code>confirm()</code> can't hold a checkbox, the confirmation becomes a small in-app modal, reusing the existing <code>simple-modal</code> styling.</li>
  <li>With it ticked, every user who can see that semester lands on it the next time they load the Classbook, once. That includes the manager who made the switch, on their next load. After that, any semester they pick sticks as usual.</li>
  <li>The switch is tied to <strong>that</strong> semester. If someone later makes a different semester active without ticking the box, browsers that haven't loaded yet are not moved anywhere.</li>
  <li>A user who can't see the semester yet (unpublished; rare, since activation publishes) isn't moved, and isn't marked done either. If it becomes visible while the switch still stands, they move then.</li>
  <li>With it unticked, nobody's remembered semester moves.</li>
  <li>Tabs already open move on their next reload, not live.</li>
</ul>
<p><strong>Shape:</strong> when ticked, the same single <code>update()</code> writes <code>activeSemesterSwitch: { to: key, at: new Date().toISOString() }</code>. It must be a <strong>client ISO string</strong>, the way <code>lastUpdated</code> is: a <code>serverTimestamp()</code> reads back as a Timestamp, would never equal the stored string, and would re-switch on every load. Compare <code>String(sw.at)</code>. <strong>Placement is load-bearing:</strong> the check runs <em>once</em> in the <code>DOMContentLoaded</code> sequence, after <code>requireAuth</code> and <code>loadConfig()</code> (<code>app.js:148-152</code>) and before <code>initGlobalSemesterSelector()</code> (<code>:158</code>). Never inside <code>initGlobalSemesterSelector</code>, which is re-called after creating a semester and after <code>makeSemesterActive</code>, and would consume the manager's own switch in the same page load. It's one map field, so it replaces the previous switch whole. On load, before the existing pick at <code>app.js:65</code>, with <code>sw = currentConfig.activeSemesterSwitch</code> and <code>seen = localStorage.activeSemesterSwitchSeen</code>:</p>
<ul>
  <li>If <code>sw</code> is missing, or <code>sw.at === seen</code>: do nothing.</li>
  <li>If <code>sw.to !== currentConfig.activeSemester</code>: the switch is stale, so mark it seen and do nothing.</li>
  <li>If <code>canSeeSemester(sw.to)</code>: set <code>globalSemesterKey = sw.to</code> and <strong>write <code>localStorage.globalSemesterKey</code> here</strong> (the <code>setItem</code> at :69 sits in the fallback branch, which this makes false), then mark it seen.</li>
  <li>Otherwise (can't see it yet): don't move and don't mark it seen.</li>
</ul>
<p><strong>Decided asymmetry:</strong> a browser that marked a switch seen through the stale branch isn't moved if that same target becomes active again later without a new tick, while a browser that never loaded would be. That's acceptable: a later switch is a new <code>at</code> and moves everyone.</p>
<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
<div class="note">A new <strong>field</strong> on existing <code>curriculum/appData</code>. It's not a new collection, so no rules change. Nothing reads it until the first switch, so deploying Phase 2 moves nobody.</div>

<div class="bdd">Scenario: teachers are moved once (happy path)
  Given a teacher's browser remembers "spring-2026" (fresh context, teacher signed in via the form)
   And appData.activeSemester = "fall-2026", activeSemesterSwitch = { to: "fall-2026", at: T1 }
  When the teacher loads the Classbook
  Then they land on Fall 2026, localStorage.globalSemesterKey = "fall-2026", activeSemesterSwitchSeen = T1
  When they pick Spring 2026 and reload
  Then they stay on Spring 2026

Scenario: the manager who switched is moved too (edge)
  Given the manager made Fall active with the box ticked, then picked Spring
  When they reload
  Then they land on Fall 2026 once

Scenario: unticked moves nobody (edge)
  Given the box was unticked (no activeSemesterSwitch written; payload keys asserted)
  When a teacher who remembers Spring loads
  Then they stay on Spring; the header shows "Fall 2026 (active)"

Scenario: a stale switch does not move anyone (edge, finding 5)
  Given activeSemesterSwitch.to = "fall-2026" but activeSemester was since set to "summer-2026" (unticked)
  When a not-yet-loaded browser loads
  Then it is not moved, and the switch is marked seen

Scenario: invisible target waits (edge, finding 6)
  Given activeSemesterSwitch.to is unpublished and the user is a teacher
  When they load
  Then not moved, not marked seen; after it is published and they reload, they are moved

Scenario: a second switch later in the year (edge)
  Given a browser has seen switch A
  When switch B is written (different at)
  Then that browser is moved on its next load

Scenario: open tabs are unaffected until reload (edge)
  Given a second tab already open on Spring
  When the switch is written
  Then that tab stays on Spring until it reloads

Scenario: deploy alone moves nobody (safety)
  Given appData has no activeSemesterSwitch
  When any user loads the new build
  Then their remembered semester is unchanged</div>
</div>

<h2 id="safety">Firebase safety checklist</h2>
<div class="safe">
  <ul>
    <li><strong>Rules:</strong> none needed. <code>curriculum/appData</code>: read for classbook users, write for manager+ only (<code>firestore.rules:652-669</code>). No new collection. Phase 1's e2e includes the non-manager refusal against the real rules.</li>
    <li><strong>The Delete exposure (finding 3):</strong> making a weekly semester non-active makes it deletable, which is already true of Spring 2026 in production. Phase 1 adds the lesson count and the typed name to that delete, and the activation confirm says so. Until Phase 1 ships: <strong>don't click Delete on Spring 2026</strong>.</li>
    <li><strong>Partial update:</strong> <code>updateAppData</code> (<code>update()</code> of named dotted paths; its <code>set(merge)</code> fallback fires only if appData doesn't exist, which isn't the case here). Only <code>activeSemester</code>, optionally <code>semesters.&lt;key&gt;.published</code> and <code>activeSemesterSwitch</code>, plus the existing <code>lastUpdated</code>/<code>lastUpdatedBy</code>.</li>
    <li><strong>No undefined or empty values:</strong> every path is a known string or <code>true</code>. The key is validated against <code>currentConfig.semesters</code> before writing.</li>
    <li><strong>Awaited:</strong> the one write is awaited, and on failure the in-memory state is restored exactly (the <code>toggleSemesterPublish</code> pattern, including "field was absent").</li>
    <li><strong>No bulk op, no delete:</strong> no snapshot needed. The previous value is shown in the confirmation. To roll back, make the old semester active again with the same button (or the console line).</li>
    <li><strong>Refuses on a bad load:</strong> inherited from <code>updateAppData</code> (config load failed, season registry unknown or error).</li>
    <li><strong>Production spot-check</strong> after deploy: Christie uses the button once for real (or the console line has already done it), then checks <code>curriculum/appData.activeSemester</code> in the Firebase Console.</li>
  </ul>
</div>

<h2 id="tests">Tests</h2>
<ul>
FILE:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-r1-claude.md
I read the plan in full and verified every "what exists today" claim against the worktree at `2ef2e62`. Most of the research is accurate. Three findings would stop or mislead execution, and there are several smaller ones.

## Claims I confirmed

- `activeSemester` set-only-when-missing — `js/app.js:11318-11319`, `:11247` ✓
- What it controls — `app.js:68, 76, 818, 4492-4496, 4514-4522, 4530, 4590, 10687, 10702-10705` ✓
- It does *not* move returning users — `app.js:13, 65-70, 96-100` ✓
- `getActiveSemesterKey()` returns the *selection* first — `js/firebase-data.js:3117-3123`; `getCurrentWeekNum()` follows it via `getActiveSemester()` — `app.js:1243-1244` ✓. `getTvSemKey()` (`app.js:635-638`) and `getSettingsSemKey()` (`app.js:10659-10661`) are both aliases of it.
- "Active" ≠ visible — `canSeeSemester()` `app.js:277-284` ✓
- `updateAppData` one `update()` of named paths, refuses on failed load / bad registry — `firebase-data.js:212-239` ✓
- `toggleSemesterPublish` is the right template — `app.js:4604-4630` ✓
- No live config listener — only reference to `setupConfigListener` outside its own definition is the comment at `app.js:11328` ✓
- **No other Tinker app reads `activeSemester`** ✓ — and I checked wider than the plan's list. The only cross-app reader of the `curriculum` collection is `studio-hub/js/alerts.js:562`, which reads `curriculum/lessonData` and iterates *all* semesters (`:573`), plus `summer-camp-app/scripts/backup-firestore.js:39` which just backs the collection up. Neither depends on the active flag. `summer-camp-app`'s `'curriculum'` (`js/app.js:85`, `js/config.js:63`) is its own tab/field name, not this collection.
- No rules change needed ✓ — `studio-hub/firestore.rules:652-669` is document-level; a new **field** on `curriculum/appData` needs nothing. And `settingsFieldPathsFor` + `extraPaths` (`app.js:11295-11319`) only ever write `semesters.<key>.*`, `teacherMappings`, `activeSemester`, so a Settings save can't clobber `activeSemesterSwitchAt`.

## High — these block or mislead

**1. The e2e setup can't write `appData`. `e2e/helpers/firestore.js` signs in as a non-manager.**
`getDb()` signs in as `TEST_ACCOUNT` (`helpers/firestore.js:57`) = `e2e-admin-uid`, `role: staff`, `appAccess: ['classbook','curriculum-admin']` (`e2e/emulators/config.js:42-49`, `e2e/fixtures/seed/users.json`). The rules deny exactly that: `allow create, update: if (…) && docId != 'appData'` (`firestore.rules:666-669`). There is no appData helper in that file. So "adds a test-only weekly semester to `appData` in `beforeEach` through the emulator helper" fails on the first hook.

Worth knowing *why* this has never bitten: **no spec has ever written `appData` for real.** Every existing appData test stubs `window.updateAppData` and asserts the payload (`data-safety.spec.js:3947-3949, 7596-7610, 7774, 7789`). Your spec would be the first to mutate shared emulator config. I'd follow the house pattern — stub-and-assert-payload for the shape scenarios, plus one real manager write for the round-trip and one real non-manager write for the rules refusal — rather than inventing a manager-authenticated helper and a restore protocol.

**2. Phase 1's UI premise is wrong: the Settings "Editing Semester" dropdown can't select anything.**
`index.html:411` is `onchange="loadSettingsForm()"` — nothing else binds it. `getSettingsSemKey()` returns the *header's* `globalSemesterKey`, and `loadSettingsForm()` rebuilds the options with `selected` on that key (`app.js:10681-10689`). So picking Fall 2026 there redraws the form for the current semester and snaps the dropdown back. Today the only way to get Settings onto a non-active semester is the header dropdown — which changes the whole app's semester.

Every Phase 1 acceptance bullet and BDD line reads "Editing Semester = Fall 2026" as though that control works. Either fix it in Phase 1 (`onchange="setGlobalSemester(this.value)"`) or reword to the header semester. Please confirm by hand in the running app before deciding — this is a behaviour I read off the source, not off a browser.

**3. Making Fall active silently arms the Delete button on Spring 2026.**
`deleteSemester` refuses only `key === currentConfig.activeSemester` (`app.js:4530-4533`), and `renderSemesterSelector` renders the 🗑 Delete button only for non-active semesters (`app.js:4522`). The moment Fall becomes active, Spring 2026 gains a Delete button in Curriculum Admin — and for a weekly semester that path runs `deleteLessonData(key)` (`firebase-data.js:961-966`), a `FieldValue.delete()` of the entire semester's lesson map. That is the most destructive button in the app, newly exposed on the semester holding a year of real lessons, at exactly the moment everyone's attention is on the new term. The plan doesn't mention it anywhere. At minimum it belongs in the safety section and the confirmation text; I'd also add a lesson-count second confirm for a weekly delete, and a BDD scenario.

## Medium

**4. The "old semester is a draft" warning is false, and contradicts the plan's own research.** Phase 1 proposes "Spring 2026 is a draft, so teachers will stop seeing it." Teachers never saw it: `canSeeSemester` returns false for any `published === false` semester regardless of active (`app.js:282`) — which your own row at plan line 53 says. Drop that line. The real inconsistency is in the other direction: `app.js:10705` renders "Active Semester — always visible to teachers" while `10704` hides the publish toggle, so an unpublished active semester is invisible *and* unpublishable from the UI. Phase 1's auto-publish makes that badge honest going forward — say so as an intended fix.

**5. Phase 2 stores a time, not a target.** `activeSemesterSwitchAt` says "someone asked for a switch at T"; the browser then lands on whatever `activeSemester` is at load time. Sequence: Fall made active, ticked (T1) → before all browsers have loaded, someone makes Summer active, unticked → those browsers jump to Summer, which nobody asked to switch everyone to. Store `activeSemesterSwitchTo` alongside and apply only if it still equals `activeSemester`, or state the "go to whatever's active" semantics deliberately.

**6. Marking a switch "seen" for someone who wasn't moved consumes it permanently.** Your invisible-active-semester scenario asserts exactly this. If the semester is published later, that browser is never moved. Narrow window given auto-publish, but make it a decision rather than a side effect.

**7. Re-rendering the header selector double-binds its change handler.** `initGlobalSemesterSelector` attaches `select.addEventListener('change', …)` at `app.js:86` with no attach-once guard — unlike `renderTvSemesterSelector`, which guards on `select.dataset.listenerAttached` (`app.js:825`). It's already called again at `4724` and `4845` after creating a semester, so the bug pre-exists; `makeSemesterActive` adds another. It matters because `setGlobalSemester` can `switchTab('teacher-view')` and re-run renders (`app.js:102-142`). Add the same guard, or re-render options without re-binding.

**8. Missed consumer: Teacher View's own selector.** `renderTvSemesterSelector` labels the active semester "(current)" (`app.js:818-819`), and `initTeacherView`'s already-built branch only redraws it conditionally (`app.js:653-655`). Your acceptance lists Settings, header and Curriculum Admin. Add it to the re-render set.

## Low

- **`updateAppData` isn't purely one `update()`** — on `not-found` it falls back to `set(nestFieldPaths(payload), {merge:true})` (`firebase-data.js:233-238`). Irrelevant for a document that exists, but the atomicity claim should say so.
- **Rules phrasing.** `classbook`/`classbook-admin`/`curriculum-admin` *can read* `appData` (`firestore.rules:665`); they're denied only create/update. That read is precisely what makes Phase 2 work for teachers — state it positively.
- **Two stale `'spring-2026'` literals** become quietly wrong after the switch: `firebase-data.js:3122` (`|| 'spring-2026'`) and `getDefaultConfig()` `:504`. Both only fire when `currentConfig` is null/absent (a banner state), so no live bug. There's a static ratchet for `summer-2026` (`static-checks.spec.js:45`) but none for this.
- **Phase 2 must write `localStorage.globalSemesterKey` itself** — the `setItem` at `app.js:69` is inside the fallback branch, which your pre-check will make false. The BDD asserts it; the Shape paragraph should too.
- **No saved teacher session exists.** `global-setup.js:63-70` writes only the admin and manager states. `login(page,'teacher')` on the default storageState returns the signed-in *admin* (`helpers/login.js:100-104`). Phase 2's teacher browser needs a blank storageState + `signInViaForm(page,'teacher')`; the creds exist (`login.js:45`, `users.json`). Also note `MANAGER_STATE_PATH` is currently used by no spec — yours would be the first.
- **Leak blast radius.** `workers: 1` (`playwright.config.js:22`) and alphabetical ordering put `active-semester.spec.js` **first**. A leaked `activeSemesterSwitchAt` or semester key would poison `day-off-camps.spec.js:398-411` ("SDOC R6", which drives `initGlobalSemesterSelector` directly) and `day-off-teacher.spec.js:661` ("T20", which reads `currentConfig.activeSemester` to find "the weekly semester"). Restore in `afterEach` **and** `afterAll`, with read-back. `lastUpdated`/`lastUpdatedBy` can't be restored to fixture values — nothing asserts them today, and `app.js:10918` already models ignoring exactly those two in a whole-document diff; copy that for your "only `activeSemester` changed" assertion.
- **Eligibility must use `semesterTypeOf()`/`isWeeklySemester()`** (`firebase-data.js:45-53`), never a key prefix — there's a ratchet against prefix routing (`static-checks.spec.js:108`). Note the seed's `spring-2026` carries no `semesterType` field, so give your test semester an explicit `semesterType: 'weekly'`.
- **Test count**: `^\s*test(` across `e2e/*.spec.js` is **323**, not 327. Re-count at execution time rather than trusting the number.

## BDD gaps (a partial implementation could still pass)

Missing: (a) a payload-keys assertion for the auto-publish case, in the house style `expect(Object.keys(payload).sort()).toEqual([...])` (`data-safety.spec.js:7610`); (b) "a second tab already open is unaffected until reload" — Phase 2 asserts this in prose, nothing tests it; (c) the manager who performs the switch is themselves subject to it on their next load; (d) a UI-level check that the button is absent for a non-manager (cheap — `setupRoleAccess` hides Settings at `app.js:328-329`); (e) `updateAppData` refusing because `seasonRegistryMode` is `error`/`unknown` (`firebase-data.js:221-223`) — a live failure mode of this exact button, and the one most likely to hit Christie mid-term-change.

## On your other questions, plainly

- **Safety invariants**: the write shape is right — named dotted paths, awaited, exact restore including "field was absent", no new collection, no rules change. My objections are about the two *consequences* the plan doesn't name (finding 3) and the e2e mechanics (finding 1), not the write itself.
- **Multiple tabs / shared devices / clock skew**: the design holds. Tabs are consistent because `globalSemesterKey` is shared localStorage; a shared studio device consumes the switch once and every subsequent user on it lands on the new semester anyway, which is what you want; the not-equal comparison does neutralise skew as claimed. Ordering relative to `app.js:65-70` is correct — pre-setting a visible key makes the condition at `:65` false, so it won't override you, and nothing reads `globalSemesterKey` between `app.js:13` and the call at `:158`. First load after deploy moves nobody (verified: nothing reads the field until it exists).
- **The plan's Q1/Q2 recommendations** both look right to me; Q1 in particular is forced by `getCurrentWeekNum` only meaning anything for weekly semesters.
FILE:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-r2-claude.md
I read the plan (revision 2), the round-1 review, and verified every claim against the worktree at `2ef2e62`. Revision 2 is a real improvement — the research rows it added are accurate. Four things would fail on execution, and one acceptance criterion is factually wrong.

## 1. Did revision 2 resolve round 1?

**(2) Settings dropdown — the fix as written doesn't deliver its own acceptance.** Plan line 89 proposes `onchange="setGlobalSemester(this.value)"`. But `setGlobalSemester` (`js/app.js:96-143`) never touches `#global-semester-select` — it sets the variable, toggles the Prep tab, and re-renders the active tab. Teacher View's selector knows this: `js/app.js:829-830` explicitly does `header.value = select.value` *before* calling it, with a comment marking it as an implementation-review fix, and `e2e/day-off-teacher.spec.js:680` asserts it. Curriculum Admin's selector (`js/app.js:4498`) lacks that line and leaves the header stale — the bug you'd be copying. So plan line 99 ("Then the header shows Fall 2026") fails as specified. Worse than cosmetic: with the header displaying Spring while `globalSemesterKey` is `fall-2026`, selecting "Spring 2026" in the header fires no `change` event, so the user can't get back without a detour. Add the `header.value =` sync (or call `initGlobalSemesterSelector()`).

Side effects are otherwise benign: unsaved Settings edits are already discarded by today's `onchange="loadSettingsForm()"`, so that's not a regression; `settingsFormSemKey` (`app.js:10669`) and the save-time mismatch guard (`app.js:11229-11233`) keep Save honest; `updateCurriculumAdminTab()` early-returns for managers (`app.js:301`).

**(3) Weekly-delete guard — adopted, three consequences missed.**
- **It breaks three existing tests**, and the plan's Tests section doesn't say so. `e2e/data-safety.spec.js:8537` asserts `expect(r.confirms).toBe(2)` plus `lessonDeletes`; `:7778-7790` asserts the delete payload shape; `:9099`-ish ("a refused delete or publish toggle reverts this tab") asserts the `Could not remove` alert. All three stub `window.confirm` but not `window.prompt`, and the page-level `page.on('dialog', d => d.accept())` accepts a prompt with `''` — so the delete would abort and all three fail. They must be updated in the same commit.
- **Count source.** `currentLessonData[key]` does work (`loadLessonData` reads the whole `curriculum/lessonData` document — `js/firebase-data.js:762-763`), but `readServerSemesterLessonMap()` already exists for exactly this case (`js/firebase-data.js:973-977`, "the local cache is known to be untrustworthy for this key", used by `createNewSemester`'s pre-check). For a number shown in an irreversible confirm, read the server; the "not loaded, refuse" branch then becomes "read failed, refuse", which is cleaner than inferring from `lessonDataLoadedSuccessfully`.
- **The confirm text you're rewriting is currently false.** `app.js:4554` says "remove all its lesson data, cut bank, and change history", but the code only deletes the appData entry and calls `deleteLessonData(key)` (`app.js:4565, 4585`) — `curriculum/cutProjects[key]` and `curriculum/changeLog[key]` are orphaned, not deleted. Also `deleteLessonData` (`firebase-data.js:961-966`) has no `lessonDataLoadedSuccessfully` guard (unlike `saveLessonData` at `:803`), and it runs *after* the appData entry is gone inside a `catch` that only `console.warn`s (`app.js:4584-4586`).

**(5)(6) Phase 2 `{to, at}` — two gaps.**
- **Placement is load-bearing and unspecified.** "before the existing pick at `app.js:65`" reads as *inside* `initGlobalSemesterSelector`. That function is re-called at `app.js:4724, 4845`, and your own re-render set (plan line 91) adds another call after `makeSemesterActive`. If consumption lives inside it, the manager consumes the switch in the same page load and plan lines 187-190 ("the manager who switched is moved too") fails. It has to be a one-shot in the `DOMContentLoaded` sequence between `loadConfig()` (`:152`) and `initGlobalSemesterSelector()` (`:158`) — after `requireAuth` (`:148`), since `canSeeSemester` needs `getAuthUser()`.
- **`at` must be a client ISO string.** `updateAppData` stamps `lastUpdated: new Date().toISOString()` (`firebase-data.js:227`) — follow that. A `serverTimestamp()` sentinel inside the map reads back as a `Timestamp`, `sw.at === seen` never matches, and every load re-switches forever. Say it explicitly and compare `String(sw.at)`.

"Not marked seen when invisible" is sound, and ordering stale-before-visible is right. One residual asymmetry worth a line: a browser that marked a switch seen via the *stale* branch is never moved if that target becomes active again, while a browser that never loaded would be. Harmless, but make it a decision.

**(1)(4)(7)(8)** are genuinely resolved. (7)'s guard is right — `select.innerHTML = html` (`app.js:83`) replaces options, not the element, so `dataset.listenerAttached` survives.

## 2. Camp season active — what actually changes

I checked every direct reader of `currentConfig.activeSemester`: `app.js:68, 76, 818, 4492, 4514, 4530, 4590, 10687, 10702, 11247, 11319, 11336` and `firebase-data.js:3122`. Everything else routes through `getActiveSemesterKey()` (`firebase-data.js:3117-3123`), which returns the **selection**. So making a camp season active changes only the labels, the delete/publish guards, and the default landing semester. Nothing you listed is broken:

- **`app.js:5069/5072` is a non-issue.** `semKey` there is `getAdminSemKey()` (`app.js:5049` → `4141-4143`), which *is* `getActiveSemesterKey()` — so `semKey === getActiveSemesterKey()` is tautologically true and the second placeholder branch at `:5074` is unreachable dead code. Don't let anyone "fix" it inside this plan.
- **CA reset at `app.js:4590`** is dead too: `caCurrentSemester` is assigned at `:4590` and `:5006` and read nowhere (`e2e/data-safety.spec.js:4030-4032` documents it as an implicit global). CA actually recovers through `getActiveSemesterKey()`'s fallback (`firebase-data.js:3119`), because the deleted key disappears from `currentConfig.semesters`. Works for a camp season.
- **Week numbers / prep dashboard / cut bank / change history**: `getCurrentWeekNum()` (`app.js:1243-1257`) would use the camp's `startDate`/`numWeeks`, but that is already true whenever Summer is merely selected; its main consumer, the Prep Dashboard, is hidden for non-weekly at `app.js:106-107` and `:176-180`, and `renderMaterialForecast` bails at `app.js:7634-7637`. No new breakage.

Two consequences the plan's camp BDD (lines 115-119) should name:
- **New default for staff**: a `curriculum-admin`/`prep` user with nothing remembered now lands with the Curriculum Admin tab *hidden* (`app.js:299-317`, called from `setupRoleAccess:330`). Correct, but visible and new.
- **An active camp season can't be removed or unpublished** (`app.js:4530-4533`, `4514-4522`), and removing a camp season is the documented way to take it out of the Classbook (`app.js:4553`). Christie would have to make something else active first.

The whitelist shape `isWeeklySemester(key) || isCampSeason(key)` is right — it refuses a future fourth type instead of defaulting it to weekly, matching `lessonStoreFor`'s stance (`firebase-data.js:64-72`). Add an `isPublishableType(key)` check (`app.js:4634-4635`) before the auto-publish so the two gates can't drift.

## 3. The e2e plan

Workable, with four mechanics to pin down.

- **There is no appData helper in `e2e/helpers/firestore.js`** (see its exports, `:304-312`). Reads are fine — the staff account *can* read appData (`studio-hub/firestore.rules:665`) — but **the restore can't be done from Node**: only create/update is manager-gated (`:666-669`). So `afterAll` needs a manager browser context (`browser.newContext({ storageState: MANAGER_STATE_PATH })`) calling the page's own `updateAppData`, with `readAppDataFromServer()` (`firebase-data.js:243-247`) for the read-back. Say that; "restore in afterEach and afterAll" hides a real piece of work.
- **The camp scenario leaks `summer-2026.published`.** The seed has `published: false` (`e2e/fixtures/seed/curriculum.json`), and Phase 1's auto-publish flips it. Your restore list (plan line 242) covers only `activeSemester` and `activeSemesterSwitch`. A leaked `published: true` makes summer-2026 pass `canSeeSemester` (`app.js:282`) for staff and appear in the option lists that `e2e/day-off-materials.spec.js:396-412` (M10) and `e2e/day-off-camps.spec.js:88` enumerate. Either restore it too, or run that scenario stubbed.
- **The leak blast radius is understated.** A leaked `activeSemesterSwitch` doesn't just break T20 and SDOC R6. Every later spec gets a fresh context from a `storageState` file with no `activeSemesterSwitchSeen`, so *every* subsequent test would be silently moved to `sw.to` on load. That's the worst leak in the plan and deserves top billing.
- **The payload assertion mixes two house patterns.** `data-safety.spec.js:7596-7610` is `withAppDataSpy` — a Firestore-level spy whose payloads always include `lastUpdated`/`lastUpdatedBy` (`:7610`). `:3947` is the `window.updateAppData` stub, whose payload has only the caller's keys (its own comment at `:3956-3958`). Plan line 113's expected array matches the second while citing the first. Also `withAppDataSpy` is a file-local `const` at `:7566` — a new spec can't import it.
- Minor: in the fresh teacher context, the app writes `localStorage.globalSemesterKey` itself on first load (`app.js:69`). Set the remembered key *after* that first load and reload, or the test passes vacuously. `signInViaForm(page,'teacher')` works — creds at `login.js:45`, fixture at `users.json`, and it waits for `#auth-guard`, which only appears on a blank state.
- The staff-refusal scenario is safe: the seed's `summerCamps_seasons._current` exists, so `seasonRegistryMode` won't be `error`/`unknown` and `updateAppData` won't throw the registry error first (`firebase-data.js:221-223`). Assert `permission-denied` specifically, not just "it threw".

Test count today is **323** (data-safety 217, day-off-materials 38, day-off-camps 33, day-off-teacher 23, linkify-xss 6, static-checks 5, teacher-mapping 1) — your "re-count at execution time" is the right instruction.

## 4. Still unsafe or missing

**One acceptance criterion is false.** Plan lines 85 and 134-136: "Nobody below manager sees the control … the Settings tab is hidden (setupRoleAccess), so there is no button."

- `loadSettingsForm()` runs unconditionally for every user at `app.js:185`, so the button markup lands in `#settings-semester-publish-group` for teachers too. It's inside an inactive panel, but `toHaveCount(0)` would fail — assert not-*visible*.
- A `classbook-admin` / `curriculum-admin` / `prep` user can actually **open** Settings. `setupRoleAccess` hides only the tab button inline (`app.js:328-329`); the footer "Settings" link (`index.html:514`) carries `write-control`, which `css/styles.css:243` hides only under `.read-only` — a body class those roles never get (`app.js:336` is the plain-teacher branch). `switchTab('settings')` → `btn.click()` (`app.js:198-201`) fires on a `display:none` button. So they reach the panel and would see the new button; the rules stop the write, but the stated acceptance isn't true.
- Fix: gate the button on `['admin','manager'].includes(user.role)` inside `loadSettingsForm`, the way `renderSemesterSelector` gates its whole bar (`app.js:4483`), and have `makeSemesterActive` refuse for a non-manager. Add a BDD line for the classbook-admin-via-footer path. (The existing Publish toggle at `app.js:10707-10711` has the same exposure today — pre-existing, but you're adding a more consequential control beside it.)
- Related: Settings' options are built from **all** of `Object.keys(config.semesters)` (`app.js:10683`), unfiltered by `canSeeSemester` — unlike the header (`app.js:60`). Once that dropdown actually navigates, a non-manager who reaches the panel could put `localStorage.globalSemesterKey` on a draft they can't see. The `:65` guard heals it next load, but not within the session.

Smaller, real:
- `currentConfig.semesters[currentConfig.activeSemester]?.name` can be `undefined` in the confirm ("… undefined stops being active"). Cheap guard.
- Two confirmation idioms land in one change: a typed-name `prompt()` in Phase 1 (the app's only `prompt()` today is `app.js:3929`) and a `simple-modal` in Phase 2. Consider one modal for both, or state why not. Decide trim and case-sensitivity for the typed name.

Nothing in the write shape itself is unsafe — one awaited `update()` of named dotted paths, exact restore including "field was absent", no new collection, no rules change. My objections are the header sync, the Phase 2 placement, the non-manager claim, and the e2e restore surface. Fix those five and this is execution-ready.
FILE:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md
Read the plan (rev 3), the round-2 review, and verified every claim against the worktree at `2ef2e62`.

## Round-2 blockers

| | Status | Where |
|---|---|---|
| **(a)** header sync on the Settings dropdown | **RESOLVED** | plan:91 — "set `#global-semester-select`'s value *first*, then `setGlobalSemester(value)`", which is exactly `app.js:826-830`. Regression BDD at plan:144-147. |
| **(b)** Phase 2 placement + client ISO `at` | **RESOLVED** | plan:190. Citations are exact: `requireAuth` `app.js:148`, `loadConfig()` `:152`, `initGlobalSemesterSelector()` `:158`; "never inside `initGlobalSemesterSelector`" stated. `String(sw.at)` comparison at plan:190. |
| **(c)** non-managers can reach Settings via the footer | **RESOLVED** | plan:76, 92 (hide `#settings-link` + dot, gate `switchTab`, render for admin/manager only, `makeSemesterActive` refuses), BDD plan:138-142 with "assert not visible, not count 0". |
| **(d)** e2e restore surface | **RESOLVED** | plan:264-267 — manager browser context + `readAppDataFromServer()` read-back, camp scenario stubbed so `summer-2026.published` can't leak, `activeSemesterSwitch` leak given top billing. |
| **(e)** weekly-delete guard | **RESOLVED** | plan:95 + BDD plan:164-173 — `readServerSemesterLessonMap`, corrected text, one modal, three named tests. |

## "Also taken" items
`isPublishableType` before auto-publish — RESOLVED (plan:93). Name fallback in the confirm — RESOLVED (plan:93). Settings options filtered by `canSeeSemester` — RESOLVED (plan:91; today unfiltered at `app.js:10683-10688`, confirmed). Camp-active consequences in the confirm and BDD — RESOLVED (plan:82, 149-151). Stale-seen asymmetry as a decision — RESOLVED (plan:197). Round-2 §3 mechanics (stub-vs-spy payload, `permission-denied` specifically, teacher fresh-context ordering, re-count tests) — RESOLVED (plan:268, 269, 270, 273).

One round-2 aside is **NOT NAMED**: "a `curriculum-admin`/`prep` user with nothing remembered now lands with the Curriculum Admin tab hidden" is only implicit in plan:123 ("render as they do when Summer is merely selected"). Cosmetic.

## New in revision 3 — checked

- **`switchTab('settings')` gating is safe.** The only in-app caller is the footer handler (`app.js:360-363`); every other `switchTab` call is `'teacher-view'` (`:110, :312, :340, :7855`). `e2e/day-off-camps.spec.js:499` clicks `#settings-link` but in the admin context. One implementation detail: the dot has no id and `.footer-dot` matches three spans (`index.html:513, 515, 520`) — hide `.footer-dot.write-control`, which is only `:515`.
- **`confirmModal` in `deleteSemester` — the three tests are the right three.** Weekly path: `data-safety.spec.js:7782`, `:8535`, `:9114`. Camp (`:8493`) and SDOC (`day-off-camps.spec.js:680`) keep `confirm()`, correctly. Not visible in the plan's one line: all three `await deleteSemester(...)` *inside* a single `page.evaluate` that installs and restores its own stubs — a modal that resolves on a click means each must be split (start the evaluate, drive the modal from Playwright, then await). Real work, but mechanical.
- **`readServerSemesterLessonMap` (`firebase-data.js:973-977`)** does a forced-server `get()` of the whole `curriculum/lessonData` doc and returns `null` when the doc *or* the key is absent; it throws only on a read failure. So `null` = 0 lessons and the delete must proceed. The BDD (plan:170) says "rejects", which is right, but plan:95's "a failed read refuses" should say null ≠ failure so a legitimately empty semester isn't blocked.
- **Phase ordering nit:** Phase 1 builds `confirmModal` for delete, yet the activation confirmation stays a plain `confirm()` until Phase 2 adds the checkbox (plan:78 vs plan:183) — so Phase 1's new activation tests get rewritten in Phase 2. Cheaper to use `confirmModal` for the activation in Phase 1 too.
- Citation spot-check (~12): `app.js:148-152/158`, `826-830`, `10918`, `10683-10712`, `index.html:411`, `firebase-data.js:973-977`, `data-safety.spec.js:7778-7790/8537` all exact. (`deleteLessonData` cited as `961-966`, actually `961-965`.)

## Verdict

**EXECUTION-READY.** The four clarifications above are one-liners for the executor, not another review round.

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html | sed -n '70,330p'
rg -n \"activeSemester|globalSemesterKey|activeSemesterSwitch|SemesterSwitchSeen|settings-link|switchTab\\(|deleteSemester|loadSettingsForm|confirmModal|getActiveSemesterKey|readServerSemesterLessonMap|updateAppData|setGlobalSemester|initGlobalSemesterSelector|setupRoleAccess\" js index.html e2e --glob '"'!e2e/test-results/**'"' --glob '"'!e2e/playwright-report/**'"'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
    70	
    71	<div class="phase" id="phase-1">
    72	<h3>Phase 1: "Make active" in Settings, plus the two things it depends on <span class="status-tag ready">execution-ready: true</span></h3>
    73	<p><strong>Acceptance (user outcomes):</strong></p>
    74	<ul>
    75	  <li><strong>Settings' "Editing Semester" dropdown works.</strong> Picking a semester there switches the app to it, the same as the header and Teacher View dropdowns already do. The header dropdown shows the new semester too, and the Settings form shows that semester. It lists only semesters the user can see.</li>
    76	  <li><strong>Settings is reachable only by managers and admins.</strong> Today curriculum-admin and prep users can open it through the footer "Settings" link, because only the tab button is hidden. That link and its dot get hidden for them as well, and <code>switchTab('settings')</code> refuses for them.</li>
    77	  <li>When Settings is on a non-active Fall/Spring class semester or Summer camp season (Q1; never an SDOC year), a manager sees <strong>"Make this the active semester"</strong> in the publish group.</li>
    78	  <li>Clicking it asks one confirmation that names both semesters, "Make Fall 2026 the active semester? Spring 2026 stops being active.", and adds, when true:
    79	    <ul>
    80	      <li>New semester is a draft: "It's a draft — it will be published so teachers can see it." Activation publishes it in the same single write. That makes the existing "Active Semester — always visible to teachers" badge true, which it isn't today for an unpublished active semester.</li>
    81	      <li>Old semester is a weekly class semester: "Spring 2026 can then be deleted from Curriculum Admin — its lessons stay unless someone deletes it."</li>
    82	      <li>New semester is a camp season: "While Summer 2026 is active it can't be removed or unpublished — make another semester active first."</li>
    83	    </ul></li>
    84	  <li>After confirming, every place that labels the active semester updates without a reload: the header, Teacher View ("(current)"), Settings' badge/toggle, and Curriculum Admin's badge/toggle/Delete.</li>
    85	  <li><strong>Deleting a weekly semester gets a real guard:</strong> the confirmation states how many lessons it holds, read fresh from the server, and says truthfully what goes. That's its lessons; its cut bank and change history stay, which the current text wrongly says are removed. You must type the semester's name to proceed (trimmed, case-insensitive). If the server read fails, nothing is deleted. Camp seasons and SDOC years keep their current (non-destructive) flows.</li>
    86	  <li>If the write fails for any reason (rules, a failed config load, or the season registry being unknown or in error), nothing changes on screen and an alert names the reason and says "Nothing was changed."</li>
    87	  <li>Nobody below manager sees the control: it's rendered only for <code>admin</code>/<code>manager</code> roles, <code>makeSemesterActive</code> refuses otherwise, and the rules refuse the write regardless.</li>
    88	</ul>
    89	<p><strong>Shape:</strong></p>
    90	<ul>
    91	  <li><code>index.html:411</code>: a new <code>onSettingsSemesterChange(value)</code> that does what Teacher View's selector does (<code>app.js:826-830</code>): set <code>#global-semester-select</code>'s value <em>first</em>, then <code>setGlobalSemester(value)</code>. Without the header sync, the header would keep showing the old semester and re-picking it would fire no change event (round 2, finding 1). Settings' options are filtered by <code>canSeeSemester</code>, like the header's.</li>
    92	  <li><code>setupRoleAccess</code> (<code>app.js:318-336</code>): hide <code>#settings-link</code> and its dot (<code>.footer-dot.write-control</code>; other <code>.footer-dot</code>s stay) for non-managers too. <code>switchTab('settings')</code> and the footer handler refuse for non-managers.</li>
    93	  <li>New <code>makeSemesterActive(key)</code> beside <code>toggleSemesterPublish</code>. Eligibility is by type (<code>isWeeklySemester(key) || isCampSeason(key)</code>), never by key prefix (there's a ratchet against prefix routing). It refuses if the user isn't admin/manager, or the key is missing or already active. It checks <code>isPublishableType(key)</code> before any auto-publish, so the two gates can't drift. The old semester's name falls back to its key if the name is missing. Then it confirms through <code>confirmModal</code> (built in this phase, so Phase 2 only adds the checkbox and the activation tests aren't rewritten), then writes <code>updateAppData({ activeSemester: key, ['semesters.'+key+'.published']: true /* only if it was false */, …Phase 2 fields })</code>. It changes <code>currentConfig</code> optimistically and restores it exactly on failure, including "field was absent".</li>
    94	  <li>Re-render set after success or failure: header options, Teacher View selector, <code>renderSemesterSelector()</code>, <code>loadSettingsForm()</code>. The header's <code>change</code> listener gets the attach-once guard Teacher View already uses (<code>dataset.listenerAttached</code>), so re-rendering doesn't stack handlers.</li>
    95	  <li><code>deleteSemester</code>, weekly branch only: the count comes from <code>readServerSemesterLessonMap(key)</code> (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
    96	  <li>Left alone on purpose: <code>app.js:5069-5074</code> and the <code>caCurrentSemester</code> assignment at <code>:4590</code> are dead code (round 2 confirmed that nothing reads them). This plan doesn't touch them.</li>
    97	  <li>The Curriculum Admin bar stays read-only for "active" (it's the same audience, but one place to change it is enough).</li>
    98	</ul>
    99	
   100	<div class="bdd">Scenario: the Settings dropdown switches semester (fix)
   101	  Given a manager on Settings with the header on Spring 2026
   102	  When they pick Fall 2026 in "Editing Semester"
   103	  Then the header shows Fall 2026 and the Settings form shows Fall's name/start date
   104	
   105	Scenario: manager makes Fall active (happy path) — real write, manager session
   106	  Given a manager on Settings for Fall 2026 (published, weekly), active = Spring 2026
   107	  When they click "Make this the active semester" and confirm
   108	  Then curriculum/appData.activeSemester reads back from the emulator as "fall-2026"
   109	   And a whole-document diff of appData, ignoring lastUpdated/lastUpdatedBy (as app.js:10918 does), shows only activeSemester changed
   110	   And header "Fall 2026 (active)", Teacher View "Fall 2026 (current)", Settings badge on Fall,
   111	       Curriculum Admin shows Spring with Publish toggle and Delete
   112	
   113	Scenario: making a draft semester active publishes it (edge) — stubbed updateAppData
   114	  Given Fall 2026 is published:false
   115	  When the manager makes it active and confirms (dialog mentions publishing)
   116	  Then exactly one updateAppData call, and
   117	       Object.keys(payload).sort() equals ["activeSemester", "semesters.fall-2026.published", …Phase 2 keys]
   118	
   119	Scenario: a Summer camp season can be made active (Q1)
   120	  Given Settings on Summer 2026 (camp season)
   121	  When the manager makes it active
   122	  Then activeSemester = "summer-2026"; with nothing remembered a user lands on Summer 2026;
   123	       Prep Dashboard hidden (as for any camp selection); Teacher View and Curriculum Admin render as they do when Summer is merely selected (so a curriculum-admin/prep user with nothing remembered lands with the Curriculum Admin tab hidden, as today for Summer)
   124	
   125	Scenario: back from Summer to a class semester (edge)
   126	  Given Summer 2026 is active
   127	  When the manager makes Fall 2026 active
   128	  Then the Prep Dashboard tab reappears for Fall
   129	
   130	Scenario: cancel changes nothing (edge)
   131	  When the manager cancels the confirmation
   132	  Then updateAppData is not called and nothing on screen changes
   133	
   134	Scenario: ineligible or already active: no button (edge)
   135	  Given Settings on an SDOC year, or on the active semester
   136	  Then no "Make this the active semester" button
   137	
   138	Scenario: non-manager never sees it (UI)
   139	  Given a curriculum-admin (staff) user
   140	  Then the Settings tab button AND the footer "Settings" link are hidden
   141	   And calling switchTab('settings') leaves them where they were
   142	   And the button is not visible even though loadSettingsForm ran (assert not visible, not count 0)
   143	
   144	Scenario: the Settings dropdown keeps the header in step (regression, round 2)
   145	  Given the header shows Spring 2026
   146	  When Settings' dropdown picks Fall 2026, then the header picks Spring 2026
   147	  Then the app is back on Spring 2026 (the header change fired)
   148	
   149	Scenario: a camp season active can't be removed (edge)
   150	  Given Summer 2026 is active
   151	  Then Curriculum Admin shows no Delete and no Publish toggle for it, and the activation confirm said so
   152	
   153	Scenario: write refused by the rules (failure) — real write, staff session
   154	  Given the staff test account
   155	  When updateAppData({ activeSemester: "spring-2026" }) is called
   156	  Then it rejects with permission-denied and appData is unchanged
   157	
   158	Scenario: write refused by the app's own guard (failure)
   159	  Given seasonRegistryMode = "error" (or configLoadFailed)
   160	  When the manager confirms
   161	  Then the alert names the reason, says "Nothing was changed", and the labels, activeSemester and published flag are exactly as before
   162	
   163	Scenario: deleting a weekly semester needs its name typed (safety)
   164	  Given Spring 2026 is not active and the server holds N lessons for it
   165	  When the manager clicks Delete
   166	  Then the modal states N lessons, says the cut bank and change history stay, and requires "Spring 2026"
   167	       (trimmed, case-insensitive); a wrong or empty answer deletes nothing
   168	       (updateAppData and deleteLessonData not called)
   169	
   170	Scenario: the lesson count can't be read (failure)
   171	  Given readServerSemesterLessonMap rejects
   172	  When the manager clicks Delete
   173	  Then an alert says nothing was deleted, and nothing was
   174	
   175	Scenario: re-render does not stack handlers (regression)
   176	  After makeSemesterActive runs twice, one header change calls setGlobalSemester exactly once</div>
   177	</div>
   178	
   179	<div class="phase" id="phase-2">
   180	<h3>Phase 2: "Switch everyone to it" <span class="status-tag ready">execution-ready: true</span></h3>
   181	<p><strong>Acceptance (user outcomes):</strong></p>
   182	<ul>
   183	  <li>The Phase 1 confirmation has a checkbox, <strong>"Also switch everyone to Fall 2026 the next time they open the Classbook"</strong>, ticked by default (Q2). Because a plain <code>confirm()</code> can't hold a checkbox, the confirmation becomes a small in-app modal, reusing the existing <code>simple-modal</code> styling.</li>
   184	  <li>With it ticked, every user who can see that semester lands on it the next time they load the Classbook, once. That includes the manager who made the switch, on their next load. After that, any semester they pick sticks as usual.</li>
   185	  <li>The switch is tied to <strong>that</strong> semester. If someone later makes a different semester active without ticking the box, browsers that haven't loaded yet are not moved anywhere.</li>
   186	  <li>A user who can't see the semester yet (unpublished; rare, since activation publishes) isn't moved, and isn't marked done either. If it becomes visible while the switch still stands, they move then.</li>
   187	  <li>With it unticked, nobody's remembered semester moves.</li>
   188	  <li>Tabs already open move on their next reload, not live.</li>
   189	</ul>
   190	<p><strong>Shape:</strong> when ticked, the same single <code>update()</code> writes <code>activeSemesterSwitch: { to: key, at: new Date().toISOString() }</code>. It must be a <strong>client ISO string</strong>, the way <code>lastUpdated</code> is: a <code>serverTimestamp()</code> reads back as a Timestamp, would never equal the stored string, and would re-switch on every load. Compare <code>String(sw.at)</code>. <strong>Placement is load-bearing:</strong> the check runs <em>once</em> in the <code>DOMContentLoaded</code> sequence, after <code>requireAuth</code> and <code>loadConfig()</code> (<code>app.js:148-152</code>) and before <code>initGlobalSemesterSelector()</code> (<code>:158</code>). Never inside <code>initGlobalSemesterSelector</code>, which is re-called after creating a semester and after <code>makeSemesterActive</code>, and would consume the manager's own switch in the same page load. It's one map field, so it replaces the previous switch whole. On load, before the existing pick at <code>app.js:65</code>, with <code>sw = currentConfig.activeSemesterSwitch</code> and <code>seen = localStorage.activeSemesterSwitchSeen</code>:</p>
   191	<ul>
   192	  <li>If <code>sw</code> is missing, or <code>sw.at === seen</code>: do nothing.</li>
   193	  <li>If <code>sw.to !== currentConfig.activeSemester</code>: the switch is stale, so mark it seen and do nothing.</li>
   194	  <li>If <code>canSeeSemester(sw.to)</code>: set <code>globalSemesterKey = sw.to</code> and <strong>write <code>localStorage.globalSemesterKey</code> here</strong> (the <code>setItem</code> at :69 sits in the fallback branch, which this makes false), then mark it seen.</li>
   195	  <li>Otherwise (can't see it yet): don't move and don't mark it seen.</li>
   196	</ul>
   197	<p><strong>Decided asymmetry:</strong> a browser that marked a switch seen through the stale branch isn't moved if that same target becomes active again later without a new tick, while a browser that never loaded would be. That's acceptable: a later switch is a new <code>at</code> and moves everyone.</p>
   198	<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
   199	<div class="note">A new <strong>field</strong> on existing <code>curriculum/appData</code>. It's not a new collection, so no rules change. Nothing reads it until the first switch, so deploying Phase 2 moves nobody.</div>
   200	
   201	<div class="bdd">Scenario: teachers are moved once (happy path)
   202	  Given a teacher's browser remembers "spring-2026" (fresh context, teacher signed in via the form)
   203	   And appData.activeSemester = "fall-2026", activeSemesterSwitch = { to: "fall-2026", at: T1 }
   204	  When the teacher loads the Classbook
   205	  Then they land on Fall 2026, localStorage.globalSemesterKey = "fall-2026", activeSemesterSwitchSeen = T1
   206	  When they pick Spring 2026 and reload
   207	  Then they stay on Spring 2026
   208	
   209	Scenario: the manager who switched is moved too (edge)
   210	  Given the manager made Fall active with the box ticked, then picked Spring
   211	  When they reload
   212	  Then they land on Fall 2026 once
   213	
   214	Scenario: unticked moves nobody (edge)
   215	  Given the box was unticked (no activeSemesterSwitch written; payload keys asserted)
   216	  When a teacher who remembers Spring loads
   217	  Then they stay on Spring; the header shows "Fall 2026 (active)"
   218	
   219	Scenario: a stale switch does not move anyone (edge, finding 5)
   220	  Given activeSemesterSwitch.to = "fall-2026" but activeSemester was since set to "summer-2026" (unticked)
   221	  When a not-yet-loaded browser loads
   222	  Then it is not moved, and the switch is marked seen
   223	
   224	Scenario: invisible target waits (edge, finding 6)
   225	  Given activeSemesterSwitch.to is unpublished and the user is a teacher
   226	  When they load
   227	  Then not moved, not marked seen; after it is published and they reload, they are moved
   228	
   229	Scenario: a second switch later in the year (edge)
   230	  Given a browser has seen switch A
   231	  When switch B is written (different at)
   232	  Then that browser is moved on its next load
   233	
   234	Scenario: open tabs are unaffected until reload (edge)
   235	  Given a second tab already open on Spring
   236	  When the switch is written
   237	  Then that tab stays on Spring until it reloads
   238	
   239	Scenario: deploy alone moves nobody (safety)
   240	  Given appData has no activeSemesterSwitch
   241	  When any user loads the new build
   242	  Then their remembered semester is unchanged</div>
   243	</div>
   244	
   245	<h2 id="safety">Firebase safety checklist</h2>
   246	<div class="safe">
   247	  <ul>
   248	    <li><strong>Rules:</strong> none needed. <code>curriculum/appData</code>: read for classbook users, write for manager+ only (<code>firestore.rules:652-669</code>). No new collection. Phase 1's e2e includes the non-manager refusal against the real rules.</li>
   249	    <li><strong>The Delete exposure (finding 3):</strong> making a weekly semester non-active makes it deletable, which is already true of Spring 2026 in production. Phase 1 adds the lesson count and the typed name to that delete, and the activation confirm says so. Until Phase 1 ships: <strong>don't click Delete on Spring 2026</strong>.</li>
   250	    <li><strong>Partial update:</strong> <code>updateAppData</code> (<code>update()</code> of named dotted paths; its <code>set(merge)</code> fallback fires only if appData doesn't exist, which isn't the case here). Only <code>activeSemester</code>, optionally <code>semesters.&lt;key&gt;.published</code> and <code>activeSemesterSwitch</code>, plus the existing <code>lastUpdated</code>/<code>lastUpdatedBy</code>.</li>
   251	    <li><strong>No undefined or empty values:</strong> every path is a known string or <code>true</code>. The key is validated against <code>currentConfig.semesters</code> before writing.</li>
   252	    <li><strong>Awaited:</strong> the one write is awaited, and on failure the in-memory state is restored exactly (the <code>toggleSemesterPublish</code> pattern, including "field was absent").</li>
   253	    <li><strong>No bulk op, no delete:</strong> no snapshot needed. The previous value is shown in the confirmation. To roll back, make the old semester active again with the same button (or the console line).</li>
   254	    <li><strong>Refuses on a bad load:</strong> inherited from <code>updateAppData</code> (config load failed, season registry unknown or error).</li>
   255	    <li><strong>Production spot-check</strong> after deploy: Christie uses the button once for real (or the console line has already done it), then checks <code>curriculum/appData.activeSemester</code> in the Firebase Console.</li>
   256	  </ul>
   257	</div>
   258	
   259	<h2 id="tests">Tests</h2>
   260	<ul>
   261	  <li>New <code>e2e/active-semester.spec.js</code> (emulator only), following the house pattern (finding 1):
   262	    <ul>
   263	      <li><strong>Payload/shape scenarios</strong> stub <code>window.updateAppData</code> and assert <code>Object.keys(payload).sort()</code> (as <code>data-safety.spec.js:7596-7610</code> does). The in-memory test semester is added to <code>currentConfig</code> in the page only, with an explicit <code>semesterType: 'weekly'</code>.</li>
   264	      <li><strong>Top leak risk:</strong> a leaked <code>activeSemesterSwitch</code> would silently move <em>every</em> later test (their contexts carry no <code>activeSemesterSwitchSeen</code>) to <code>sw.to</code>. The restore below is mandatory and read back, and a final assertion in this spec checks appData has no <code>activeSemesterSwitch</code>.</li>
   265	      <li><strong>One real round-trip</strong> runs in a manager context (<code>MANAGER_STATE_PATH</code>, first spec to use it). The test semester is created and removed through the app's own <code>updateAppData</code> in that page, and <code>activeSemester</code> is restored to <code>spring-2026</code> and <code>activeSemesterSwitch</code> deleted in <code>afterEach</code> <strong>and</strong> <code>afterAll</code>, each read back. Reason: with <code>workers: 1</code> this file runs <strong>first</strong> alphabetically, and a leak would break <code>day-off-camps.spec.js</code> "SDOC R6" and <code>day-off-teacher.spec.js</code> "T20", which read the active semester.</li>
   266	      <li><strong>The restore can't run from Node</strong> (the helper is staff, and appData writes are manager-only). <code>afterEach</code>/<code>afterAll</code> open a manager browser context and call the page's own <code>updateAppData</code> (<code>activeSemester: 'spring-2026'</code>, <code>activeSemesterSwitch: FieldValue.delete()</code>, <code>semesters.&lt;test&gt;: FieldValue.delete()</code>), then read back with <code>readAppDataFromServer()</code> (<code>firebase-data.js:243-247</code>).</li>
   267	      <li>The <strong>camp-season scenario runs stubbed</strong>. Its auto-publish would otherwise flip the seed's <code>summer-2026.published: false</code>, which <code>day-off-materials</code> M10 and <code>day-off-camps</code> enumerate.</li>
   268	      <li>Payloads: use the <code>window.updateAppData</code> stub pattern (<code>data-safety.spec.js:3947-3958</code>), whose payload holds only the caller's keys. <code>withAppDataSpy</code> is file-local and adds <code>lastUpdated</code>.</li>
   269	      <li><strong>One real rules refusal</strong> uses the staff account and asserts <code>permission-denied</code> specifically (the seeded season registry is valid, so <code>updateAppData</code>'s own guard won't fire first).</li>
   270	      <li><strong>Phase 2's teacher</strong> is a fresh context (blank storageState) signed in with <code>signInViaForm(page, 'teacher')</code>, because <code>login(page,'teacher')</code> on the default state returns the admin. The remembered <code>globalSemesterKey</code> is set <em>after</em> that first load, followed by a reload, because the app writes it itself on first load and the test would otherwise pass vacuously.</li>
   271	    </ul></li>
   272	  <li>Assertions that must use types, not key prefixes: <code>isWeeklySemester</code> / <code>isCampSeason</code> (the ratchet at <code>static-checks.spec.js:108</code>).</li>
   273	  <li>The full suite stays green. Re-count at execution time; don't trust a number in this plan.</li>
   274	</ul>
   275	
   276	<h2 id="completeness">Completeness: what if this is interrupted?</h2>
   277	<ul>
   278	  <li><strong>Mid-code, before deploy:</strong> nothing is live. Resume from the branch.</li>
   279	  <li><strong>The write itself is atomic:</strong> one <code>update()</code>, so the active flag and the auto-publish can't half-happen.</li>
   280	  <li><strong>Phase 1 shipped without Phase 2:</strong> still coherent. The button works and moves nobody. (The plan still deploys both together.)</li>
   281	  <li><strong>After a switch:</strong> browsers pick it up on their next load, whenever that is. There's no deadline and nothing to finish.</li>
   282	</ul>
   283	
   284	<h2 id="resume">Resume instructions</h2>
   285	<ol>
   286	  <li>Read this plan. Check the Decisions Log for Christie's answers to Q1/Q2 and any review findings.</li>
   287	  <li>Work in a worktree on branch <code>claude/make-active-semester</code> off <code>origin/main</code>.</li>
   288	  <li>Check line numbers against current main. They were recorded at <code>2ef2e62</code>.</li>
   289	  <li>e2e: <code>npm test -- --grep "active semester"</code>. The emulator ports are fixed, so if another session's suite holds 8180, wait or shift ports locally without committing (see the memory note on classbook worktree deploys).</li>
   290	  <li>Per phase: commit, run the full suite, then a second-model implementation review. Deploy once after both, only after Christie says yes, via <code>NETLIFY_SITE_ID=… npm run deploy</code> from a clean, pushed main.</li>
   291	</ol>
   292	
   293	<h2 id="decisions">Decisions Log (append-only)</h2>
   294	<div class="decision">
   295	  <strong>Sep 29, 2026: round 3 (confirmation) — EXECUTION-READY</strong> (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md</code>). All round-2 blockers were confirmed resolved. Its four clarifications are folded in: hide only <code>.footer-dot.write-control</code>; <code>readServerSemesterLessonMap</code> returning <code>null</code> means 0 lessons, not a failure; the three delete tests must split their <code>page.evaluate</code> to drive the modal; the activation uses <code>confirmModal</code> from Phase 1. Also named: a curriculum-admin/prep user with nothing remembered lands with Curriculum Admin hidden when Summer is active. All phases are marked execution-ready. Execution waits for Christie's go-ahead. Codex didn't review this plan (out of credits); all three rounds were Claude.
   296	</div>
   297	<div class="decision">
   298	  <strong>Sep 29, 2026: revision 3, after round-2 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r2-claude.md</code>).</strong> Round 2 found the write shape safe and listed five blockers, all verified and taken:
   299	  <ul>
   300	    <li>(a) The Settings dropdown fix syncs the header first, as Teacher View does.</li>
   301	    <li>(b) Phase 2's check is a one-shot in <code>DOMContentLoaded</code>, never in <code>initGlobalSemesterSelector</code>, and <code>at</code> is a client ISO string.</li>
   302	    <li>(c) "Nobody below manager sees it" was false: curriculum-admin and prep can open Settings through the footer link. Phase 1 hides that link, gates <code>switchTab</code>, and renders the button only for admin/manager.</li>
   303	    <li>(d) The e2e restore runs through a manager browser context, not Node. The camp scenario is stubbed so <code>summer-2026.published</code> can't leak. The <code>activeSemesterSwitch</code> leak is flagged as the top risk.</li>
   304	    <li>(e) The weekly-delete guard counts from the server (<code>readServerSemesterLessonMap</code>), corrects the false "cut bank and change history" text, and uses the same modal as Phase 2 (no <code>prompt()</code>). Three existing <code>data-safety</code> tests change in the same commit.</li>
   305	  </ul>
   306	  Also taken: an <code>isPublishableType</code> check before auto-publish, the name fallback in the confirm, filtering Settings' options by <code>canSeeSemester</code>, the camp-active consequences named in the confirm and BDD, and the stale-seen asymmetry recorded as a decision.<br>
   307	  <strong>Not taken (out of scope, noted):</strong> the dead code at <code>app.js:5069-5074</code> and <code>:4590</code>. <code>deleteLessonData</code> lacks a <code>lessonDataLoadedSuccessfully</code> guard and runs after the appData entry is gone inside a warn-only catch (pre-existing, and the server-read count now gates the whole delete). Cut bank and change history are orphaned by a weekly delete (pre-existing, and the text is now honest about it).
   308	</div>
   309	<div class="decision">
   310	  <strong>Sep 29, 2026: revision 2, after round-1 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r1-claude.md</code>).</strong> Verified against the code and taken:
   311	  <ul>
   312	    <li>(1) e2e can't write appData with the Node helper, so the house pattern is used: stub-and-payload, one manager round-trip with restore in afterEach+afterAll, one staff refusal.</li>
   313	    <li>(2) The Settings dropdown was broken, so it's fixed in Phase 1.</li>
   314	    <li>(3) Making a semester non-active arms its Delete, which is already live for Spring. Weekly delete now shows the lesson count and needs the name typed, and the confirm mentions it.</li>
   315	    <li>(4) Dropped the false "teachers will stop seeing it" warning (drafts were never visible). Noted that auto-publish makes the badge honest.</li>
   316	    <li>(5) Phase 2 stores <code>{to, at}</code> and ignores a switch whose target is no longer active.</li>
   317	    <li>(6) An invisible target isn't marked seen.</li>
   318	    <li>(7) Attach-once guard on the header listener.</li>
   319	    <li>(8) Teacher View's "(current)" is in the re-render set.</li>
   320	  </ul>
   321	  Low items taken: the set(merge) fallback noted, teacher read access stated, Phase 2 writes <code>localStorage.globalSemesterKey</code> itself, fresh teacher sign-in, restore with read-back plus the lastUpdated-ignoring diff, type-based eligibility. BDD gaps a–e added.<br>
   322	  <strong>Deliberately left alone:</strong> the two stale <code>'spring-2026'</code> fallback literals (<code>firebase-data.js:504, 3122</code>). They only fire with no config (the banner state), so they're out of scope and noted here.<br>
   323	  <strong>New UI consequence:</strong> Phase 2's checkbox needs a small modal instead of <code>confirm()</code>.
   324	</div>
   325	<div class="note" style="opacity:.7">
   326	  <strong>(Superseded — Christie stayed; round 1 addressed below.) PAUSED Sep 29, 2026.</strong> Round-1 plan review (Claude only; Codex is out of credits) finished but has <strong>not been addressed yet</strong>. It reports three findings that would stop or mislead execution, plus smaller ones. It ran on the plan <em>before</em> Christie's Q1 answer added Summer camp seasons, so re-check its points against that too. Files: <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r1-claude.md</code> (and <code>-r1-input.md</code>). Next: verify each finding against the code, revise this plan, append the outcome here, run a round-2 review, then ask Christie for the go-ahead. No code has been written, and nothing about this feature is on a branch yet.
   327	</div>
   328	<div class="decision">
   329	  <strong>Sep 29, 2026: production switched by console.</strong> Christie ran <code>await updateAppData({ activeSemester: 'fall-2026' })</code> on the live app. Fall 2026 is now active. Semesters at that point: summer-2026 (published), fall-2026 (published), sdoc-2026-27 (published:false), spring-2026 (published field absent, so visible). Returning browsers still remember Spring until they pick Fall. Phase 2's "switch everyone" is what fixes that next time.
   330	</div>
index.html:411:          <select id="settings-semester-select" onchange="loadSettingsForm()" style="max-width:300px"></select>
index.html:514:      <a href="#" id="settings-link" class="footer-link write-control">Settings</a>
e2e/static-checks.spec.js:123:    // seen. Every appData write goes through updateAppData()'s field paths.
js/firebase-data.js:160://                                   memory, writes allowed (updateAppData()
js/firebase-data.js:212:async function updateAppData(updates) {
js/firebase-data.js:504:    activeSemester: 'spring-2026',
js/firebase-data.js:971:// createNewSemester()'s pre-check (deleteSemester() drops a key locally even
js/firebase-data.js:973:async function readServerSemesterLessonMap(semesterKey) {
js/firebase-data.js:3113:  const key = getActiveSemesterKey();
js/firebase-data.js:3117:function getActiveSemesterKey() {
js/firebase-data.js:3119:  if (globalSemesterKey && currentConfig?.semesters?.[globalSemesterKey]) {
js/firebase-data.js:3120:    return globalSemesterKey;
js/firebase-data.js:3122:  return currentConfig?.activeSemester || 'spring-2026';
e2e/linkify-xss.spec.js:107:    await page.evaluate(() => { setGlobalSemester('summer-2026'); });
e2e/linkify-xss.spec.js:200:    await page.evaluate(({ key }) => { window.__xss = 0; setGlobalSemester('spring-2026'); }, { key: SPRING_KEY });
e2e/linkify-xss.spec.js:237:    await page.evaluate(() => { window.__xss = 0; setGlobalSemester('spring-2026'); });
js/app.js:13:let globalSemesterKey = localStorage.getItem('globalSemesterKey') || null;  // Universal semester selection
js/app.js:47:function initGlobalSemesterSelector() {
js/app.js:65:  if (!globalSemesterKey || !semesters[globalSemesterKey] || !visibleKeys.includes(globalSemesterKey)) {
js/app.js:68:    globalSemesterKey = visibleKeys.includes(currentConfig.activeSemester) ? currentConfig.activeSemester : visibleKeys[0];
js/app.js:69:    localStorage.setItem('globalSemesterKey', globalSemesterKey);
js/app.js:76:    const isActive = key === currentConfig.activeSemester;
js/app.js:81:    html += `<option value="${escAttr(key)}" ${key === globalSemesterKey ? 'selected' : ''}>${escHtml(String(label ?? ''))}</option>`;
js/app.js:87:    setGlobalSemester(select.value);
js/app.js:96:function setGlobalSemester(key) {
js/app.js:99:  globalSemesterKey = key;
js/app.js:100:  localStorage.setItem('globalSemesterKey', key);
js/app.js:110:        switchTab('teacher-view');
js/app.js:141:    loadSettingsForm();
js/app.js:158:  initGlobalSemesterSelector();
js/app.js:176:  const currentSemester = currentConfig?.semesters?.[globalSemesterKey];
js/app.js:178:  if (prepDashboardTab && currentSemester && !isWeeklySemester(globalSemesterKey)) {
js/app.js:183:  setupRoleAccess();
js/app.js:185:  loadSettingsForm();
js/app.js:198:function switchTab(tabId) {
js/app.js:304:  const semKey = getActiveSemesterKey();
js/app.js:312:      switchTab('teacher-view');
js/app.js:319:function setupRoleAccess() {
js/app.js:340:  switchTab('teacher-view');
js/app.js:360:  document.getElementById('settings-link')?.addEventListener('click', (e) => {
js/app.js:362:    switchTab('settings');
js/app.js:391:  const semKey = getActiveSemesterKey();
js/app.js:536:  const semKey = getActiveSemesterKey();
js/app.js:637:  return getActiveSemesterKey();
js/app.js:818:    const isActive = key === currentConfig.activeSemester;
js/app.js:831:      setGlobalSemester(select.value);
js/app.js:4142:  return getActiveSemesterKey();
js/app.js:4492:    const isActive = key === currentConfig.activeSemester;
js/app.js:4498:  select.onchange = () => setGlobalSemester(select.value);
js/app.js:4514:    const isActive = currentKey === currentConfig.activeSemester;
js/app.js:4522:      ${!isActive ? `<button class="btn-text ca-delete-sem-btn" onclick="deleteSemester('${escAttr(currentKey)}')" title="Delete this semester">&#128465; Delete</button>` : ''}
js/app.js:4527:async function deleteSemester(key) {
js/app.js:4530:  if (key === currentConfig.activeSemester) {
js/app.js:4565:    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
js/app.js:4590:  caCurrentSemester = currentConfig.activeSemester;
js/app.js:4601:  setGlobalSemester(key);
js/app.js:4619:    await updateAppData({ [`semesters.${key}.published`]: published });
js/app.js:4707:    await updateAppData({ [`semesters.${key}`]: newSem });
js/app.js:4724:    initGlobalSemesterSelector();
js/app.js:4841:    await updateAppData({ [`semesters.${key}`]: newSem });
js/app.js:4845:    initGlobalSemesterSelector();
js/app.js:4903:      // before this call. It can: deleteSemester() drops a key from local
js/app.js:4914:      const existingLessonMap = await readServerSemesterLessonMap(key);
js/app.js:4981:    await updateAppData({ [`semesters.${key}`]: newSem });
js/app.js:5069:  const currentWeek = semKey === getActiveSemesterKey() ? getCurrentWeekNum() : null;
js/app.js:5072:    wrapper.innerHTML = `<div class="tv-placeholder">${semKey === getActiveSemesterKey()
js/app.js:7628:  const semKey = getActiveSemesterKey();
js/app.js:7855:      switchTab('teacher-view');
js/app.js:7944:  const semKey = getActiveSemesterKey();
js/app.js:8868:  const semKey = getActiveSemesterKey();
js/app.js:8925:  const semKey = getActiveSemesterKey();
js/app.js:9700:  const currentSemester = currentConfig.semesters?.[globalSemesterKey];
js/app.js:10209:  const semKey = getActiveSemesterKey();
js/app.js:10661:  return getActiveSemesterKey();
js/app.js:10674:  if (settingsFormSemKey !== getSettingsSemKey()) loadSettingsForm();
js/app.js:10677:function loadSettingsForm() {
js/app.js:10687:      const label = s.name + (k === config.activeSemester ? ' (active)' : '');
js/app.js:10702:    const isActive = semKey === config.activeSemester;
js/app.js:10811:      await updateAppData(paths);
js/app.js:10817:    loadSettingsForm();
js/app.js:10905:    await updateAppData(stamps);
js/app.js:10947:    loadSettingsForm();
js/app.js:11115:  const semKey = getActiveSemesterKey();
js/app.js:11230:    loadSettingsForm();
js/app.js:11247:  config.activeSemester = config.activeSemester || semKey;
js/app.js:11318:  // activeSemester is only ever SET when missing, never re-pointed from here.
js/app.js:11319:  if (!currentConfig?.activeSemester) extraPaths.activeSemester = semKey;
js/app.js:11322:    await updateAppData({ ...settingsPaths, ...extraPaths });
js/app.js:11325:    // left the clone's semester edits stranded, so loadSettingsForm() redrew
js/app.js:11336:    if (extraPaths.activeSemester) currentConfig.activeSemester = extraPaths.activeSemester;
js/app.js:11344:    loadSettingsForm();
e2e/day-off-materials.spec.js:230:    await prep.evaluate(() => initGlobalSemesterSelector());
e2e/day-off-materials.spec.js:261:    await planner.evaluate((Y) => setGlobalSemester(Y), Y);
e2e/day-off-materials.spec.js:348:    await prep.evaluate(() => initGlobalSemesterSelector());
e2e/day-off-materials.spec.js:370:    await planner.evaluate((Y) => setGlobalSemester(Y), Y);
e2e/day-off-materials.spec.js:397:        initGlobalSemesterSelector();
e2e/day-off-materials.spec.js:434:    await page.evaluate(() => initGlobalSemesterSelector());
e2e/day-off-materials.spec.js:449:    await prep.evaluate(() => initGlobalSemesterSelector());
e2e/day-off-materials.spec.js:640:    await prep.evaluate(() => initGlobalSemesterSelector());
e2e/day-off-materials.spec.js:662:    await prep.evaluate(() => initGlobalSemesterSelector());
e2e/day-off-materials.spec.js:720:    await prep.evaluate(() => initGlobalSemesterSelector());
e2e/day-off-materials.spec.js:765:    await page.evaluate(() => initGlobalSemesterSelector());
e2e/day-off-materials.spec.js:1031:    await prep.evaluate(() => initGlobalSemesterSelector());
e2e/day-off-teacher.spec.js:104:  await page.evaluate(() => initGlobalSemesterSelector());
e2e/day-off-teacher.spec.js:490:      const out = []; const real = window.updateAppData;
e2e/day-off-teacher.spec.js:491:      window.updateAppData = async (u) => { out.push(u); };
e2e/day-off-teacher.spec.js:492:      try { await toggleSemesterPublish(Y, true); } finally { window.updateAppData = real; }
e2e/day-off-teacher.spec.js:660:    await prep.evaluate(() => initGlobalSemesterSelector());
e2e/day-off-teacher.spec.js:661:    const weekly = await prep.evaluate(() => currentConfig.activeSemester);
e2e/day-off-camps.spec.js:36:      const sld = window.saveLessonData, rsm = window.readServerSemesterLessonMap;
e2e/day-off-camps.spec.js:38:      window.readServerSemesterLessonMap = async (...a) => { window.__serverMapReads++; return rsm(...a); };
e2e/day-off-camps.spec.js:65:      await page.evaluate((k) => setGlobalSemester(k), KEY);
e2e/day-off-camps.spec.js:102:    await page.evaluate(() => { window.__appDataWrites = 0; const u = window.updateAppData; window.updateAppData = async (...a) => { window.__appDataWrites++; return u(...a); }; });
e2e/day-off-camps.spec.js:335:    await page.evaluate((Y) => setGlobalSemester(Y), Y);
e2e/day-off-camps.spec.js:342:    await page.evaluate(() => { window.__captured = []; window.__origUpdate = window.updateAppData; window.updateAppData = async (u) => { window.__captured.push(u); }; });
e2e/day-off-camps.spec.js:345:      await page.evaluate(() => loadSettingsForm());
e2e/day-off-camps.spec.js:354:        window.updateAppData = window.__origUpdate;
e2e/day-off-camps.spec.js:366:        globalSemesterKey = Y;   // e.g. a manager picked the draft year on this device
e2e/day-off-camps.spec.js:367:        initGlobalSemesterSelector();
e2e/day-off-camps.spec.js:368:        const teacherKey = globalSemesterKey;
e2e/day-off-camps.spec.js:371:        initGlobalSemesterSelector();
e2e/day-off-camps.spec.js:383:    await page.evaluate((Y) => setGlobalSemester(Y), Y);
e2e/day-off-camps.spec.js:401:      const realActive = currentConfig.activeSemester;
e2e/day-off-camps.spec.js:404:        currentConfig.activeSemester = Y;   // unpublished
e2e/day-off-camps.spec.js:405:        globalSemesterKey = Y;
e2e/day-off-camps.spec.js:406:        initGlobalSemesterSelector();
e2e/day-off-camps.spec.js:407:        return { key: globalSemesterKey, published: currentConfig.semesters[globalSemesterKey]?.published };
e2e/day-off-camps.spec.js:408:      } finally { window.getAuthUser = realUser; currentConfig.activeSemester = realActive; }
e2e/day-off-camps.spec.js:418:    await page.evaluate((Y) => { currentConfig.semesters[Y].teacherNames = ['TESTteacher2']; setGlobalSemester(Y); }, Y);
e2e/day-off-camps.spec.js:432:    await page.evaluate((Y) => setGlobalSemester(Y), Y);
e2e/day-off-camps.spec.js:448:    await page.evaluate((Y) => setGlobalSemester(Y), Y);
e2e/day-off-camps.spec.js:451:    await page.evaluate(() => { window.__origUpdate = window.updateAppData; window.updateAppData = async () => { throw new Error('should not write'); }; });
e2e/day-off-camps.spec.js:454:      await page.evaluate(() => loadSettingsForm());
e2e/day-off-camps.spec.js:462:    } finally { await page.evaluate(() => { window.updateAppData = window.__origUpdate; }); }
e2e/day-off-camps.spec.js:475:    await page.evaluate(() => initGlobalSemesterSelector());   // the injected TEST year joins the header list
e2e/day-off-camps.spec.js:499:    await page.evaluate(() => document.getElementById('settings-link').click());
e2e/day-off-camps.spec.js:507:    await page.evaluate(() => { window.__writes = 0; window.__origUpdate = window.updateAppData; window.updateAppData = async () => { window.__writes++; }; });
e2e/day-off-camps.spec.js:509:      await page.evaluate(() => { globalSemesterKey = 'summer-2026'; });   // header moved, form not redrawn
e2e/day-off-camps.spec.js:514:    } finally { await page.evaluate(() => { window.updateAppData = window.__origUpdate; }); }
e2e/day-off-camps.spec.js:520:    await page.evaluate((Y) => setGlobalSemester(Y), Y);
e2e/day-off-camps.spec.js:569:    await page.evaluate((Y) => setGlobalSemester(Y), Y);
e2e/day-off-camps.spec.js:591:    await page.evaluate((Y) => setGlobalSemester(Y), Y);
e2e/day-off-camps.spec.js:615:    await page.evaluate((Y) => setGlobalSemester(Y), Y);
e2e/day-off-camps.spec.js:634:    await page.evaluate((Y) => setGlobalSemester(Y), Y);
e2e/day-off-camps.spec.js:635:    await page.evaluate(() => { window.__captured = []; window.__origUpdate = window.updateAppData; window.updateAppData = async (u) => { window.__captured.push(JSON.parse(JSON.stringify(u))); }; });
e2e/day-off-camps.spec.js:640:      await page.evaluate(() => loadSettingsForm());
e2e/day-off-camps.spec.js:653:      await page.evaluate(() => loadSettingsForm());
e2e/day-off-camps.spec.js:660:      await page.evaluate(() => loadSettingsForm());
e2e/day-off-camps.spec.js:671:      await page.evaluate(() => { window.updateAppData = window.__origUpdate; });
e2e/day-off-camps.spec.js:679:    await page.evaluate(() => { window.__appDataWrites = 0; const u = window.updateAppData; window.updateAppData = async (...a) => { window.__appDataWrites++; return u(...a); }; });
e2e/day-off-camps.spec.js:680:    await page.evaluate((Y) => deleteSemester(Y), Y);
e2e/day-off-camps.spec.js:689:    await page.evaluate((Y) => setGlobalSemester(Y), Y);
e2e/fixtures/seed/curriculum.json:3:    "activeSemester": "spring-2026",
e2e/data-safety.spec.js:49:  // Set semester so getTvSemKey() (→ getActiveSemesterKey() → globalSemesterKey)
e2e/data-safety.spec.js:50:  // looks in summer-2026. setGlobalSemester() is the real UI entry point —
e2e/data-safety.spec.js:52:  await page.evaluate(() => { setGlobalSemester('summer-2026'); });
e2e/data-safety.spec.js:499:// applied to the non-summer path. getActiveSemesterKey is a function
e2e/data-safety.spec.js:519:    window.getActiveSemesterKey = () => semKey;
e2e/data-safety.spec.js:1194:    // initAdminContext just points getActiveSemesterKey (and, transitively,
e2e/data-safety.spec.js:2963:        window.getActiveSemesterKey = () => semKey;
e2e/data-safety.spec.js:3118:        window.getActiveSemesterKey = () => semKey;
e2e/data-safety.spec.js:3943:      // Phase 1 (1.2): the config writer is updateAppData(), which is handed
e2e/data-safety.spec.js:3947:        const original = window.updateAppData;
e2e/data-safety.spec.js:3948:        window.updateAppData = async (updates) => { captured = JSON.parse(JSON.stringify(updates)); };
e2e/data-safety.spec.js:3949:        try { await createNewSemester(); } finally { window.updateAppData = original; }
e2e/data-safety.spec.js:3956:      // (the stub stands in for updateAppData itself, so the lastUpdated/
e2e/data-safety.spec.js:4035:        const originalSaveConfig = window.updateAppData;
e2e/data-safety.spec.js:4040:        window.updateAppData = async () => {
e2e/data-safety.spec.js:4045:          slotsOnServerAtSaveConfig = (await readServerSemesterLessonMap(newKey)) !== null;
e2e/data-safety.spec.js:4055:          window.updateAppData = originalSaveConfig;
e2e/data-safety.spec.js:4101:  // deleteSemester() drops the key from local state but only console.warns if
e2e/data-safety.spec.js:4141:        const originalSaveConfig = window.updateAppData;
e2e/data-safety.spec.js:4143:        window.updateAppData = async () => { saveConfigCalls++; };
e2e/data-safety.spec.js:4151:          window.updateAppData = originalSaveConfig;
e2e/data-safety.spec.js:4214:        const originalSaveConfig = window.updateAppData;
e2e/data-safety.spec.js:4216:        window.updateAppData = async () => { saveConfigCalls++; };
e2e/data-safety.spec.js:4221:          window.updateAppData = originalSaveConfig;
e2e/data-safety.spec.js:4274:        const originalSaveConfig = window.updateAppData;
e2e/data-safety.spec.js:4276:        window.updateAppData = async () => { throw new Error('TEST simulated appData write failure'); };
e2e/data-safety.spec.js:4284:          window.updateAppData = originalSaveConfig;
e2e/data-safety.spec.js:4331:        const originalRead = window.readServerSemesterLessonMap;
e2e/data-safety.spec.js:4332:        const originalSaveConfig = window.updateAppData;
e2e/data-safety.spec.js:4341:        window.readServerSemesterLessonMap = async (k) => { preCheckCalls++; await gate; return originalRead(k); };
e2e/data-safety.spec.js:4342:        window.updateAppData = async () => { saveConfigCalls++; };
e2e/data-safety.spec.js:4363:          window.readServerSemesterLessonMap = originalRead;
e2e/data-safety.spec.js:4364:          window.updateAppData = originalSaveConfig;
e2e/data-safety.spec.js:4514:      await page.evaluate((semKey) => { window.getActiveSemesterKey = () => semKey; }, TEST_SEM);
e2e/data-safety.spec.js:4612:      await page.evaluate((other) => { window.getActiveSemesterKey = () => other; }, OTHER_SEM);
e2e/data-safety.spec.js:6153:      await page.evaluate((semKey) => { window.getActiveSemesterKey = () => semKey; if (!currentLessonData[semKey]) currentLessonData[semKey] = {}; }, TEST_SEM);
e2e/data-safety.spec.js:7512:        window.getActiveSemesterKey = () => semKey;
e2e/data-safety.spec.js:7552:// through updateAppData(), so a writer can only ever touch the paths it names.
e2e/data-safety.spec.js:7596:  test('RED (1.2): updateAppData() writes ONE update() of exactly the paths it was given, plus the two stamps — never a whole document', async ({ browser }) => {
e2e/data-safety.spec.js:7603:        await updateAppData({ 'semesters.test-x.published': true });
e2e/data-safety.spec.js:7617:  test('RED (1.2): on not-found (no appData document yet) updateAppData() falls back to a NESTED merge-set, never a bare set', async ({ browser }) => {
e2e/data-safety.spec.js:7637:          await updateAppData({ 'semesters.test-x.name': 'TEST X', 'activeSemester': 'test-x' });
e2e/data-safety.spec.js:7646:      expect(r.set[0].payload.activeSemester).toBe('test-x');
e2e/data-safety.spec.js:7742:            get: async () => ({ exists: true, data: () => ({ activeSemester: 'fall-2026', semesters: { 'fall-2026': { name: 'Fall 2026', semesterType: 'weekly' } } }) }),
e2e/data-safety.spec.js:7782:        try { await deleteSemester('test-del'); }
e2e/data-safety.spec.js:8358:        const realUpdate = window.updateAppData;
e2e/data-safety.spec.js:8361:        window.updateAppData = async (u) => { appDataWrites.push(JSON.parse(JSON.stringify(u))); };
e2e/data-safety.spec.js:8371:          window.updateAppData = realUpdate; window.saveLessonData = realSaveLessons; window.readAppDataFromServer = realRead;
e2e/data-safety.spec.js:8436:        const realUpdate = window.updateAppData;
e2e/data-safety.spec.js:8438:        window.updateAppData = async (u) => { writes.push(JSON.parse(JSON.stringify(u))); };
e2e/data-safety.spec.js:8448:          window.updateAppData = realUpdate; window.readAppDataFromServer = realRead;
e2e/data-safety.spec.js:8487:        const realUpdate = window.updateAppData;
e2e/data-safety.spec.js:8490:        window.updateAppData = async (u) => { appDataWrites.push(Object.keys(u)); delete currentConfig.semesters[sem]; };
e2e/data-safety.spec.js:8493:          await deleteSemester(sem);
e2e/data-safety.spec.js:8497:          window.updateAppData = realUpdate; window.deleteLessonData = realDeleteLessons;
e2e/data-safety.spec.js:8531:        const realUpdate = window.updateAppData; const realDelete = window.deleteLessonData;
e2e/data-safety.spec.js:8533:        window.updateAppData = async () => { delete currentConfig.semesters[sem]; };
e2e/data-safety.spec.js:8535:        try { await deleteSemester(sem); return { confirms: confirms.length, lessonDeletes }; }
e2e/data-safety.spec.js:8536:        finally { window.confirm = realConfirm; window.updateAppData = realUpdate; window.deleteLessonData = realDelete; delete currentConfig.semesters[sem]; }
e2e/data-safety.spec.js:8553:        const realUpdate = window.updateAppData;
e2e/data-safety.spec.js:8555:        window.updateAppData = async (u) => { writes.push(u); };
e2e/data-safety.spec.js:8571:        } finally { window.readAppDataFromServer = realRead; window.updateAppData = realUpdate; pendingSemesterTypeStamps = null; }
e2e/data-safety.spec.js:8592:        const realUpdate = window.updateAppData;
e2e/data-safety.spec.js:8601:          window.updateAppData = async () => {};
e2e/data-safety.spec.js:8608:          window.updateAppData = async (u) => {
e2e/data-safety.spec.js:8621:        } finally { window.readAppDataFromServer = realRead; window.updateAppData = realUpdate; pendingSemesterTypeStamps = null; }
e2e/data-safety.spec.js:8645:        const realUpdate = window.updateAppData;
e2e/data-safety.spec.js:8657:          window.updateAppData = async (u) => {
e2e/data-safety.spec.js:8669:        } finally { window.readAppDataFromServer = realRead; window.updateAppData = realUpdate; pendingSemesterTypeStamps = null; }
e2e/data-safety.spec.js:8693:        const realUpdate = window.updateAppData;
e2e/data-safety.spec.js:8694:        window.updateAppData = async (u) => { writes.push(JSON.parse(JSON.stringify(u))); };
e2e/data-safety.spec.js:8715:          window.updateAppData = realUpdate;
e2e/data-safety.spec.js:8792:            update: await attempt(() => updateAppData({ 'semesters.test-x.published': true })),
e2e/data-safety.spec.js:8838:        const realUpdate = window.updateAppData;
e2e/data-safety.spec.js:8845:          let stored = { activeSemester: 'fall-2026', teacherMappings: { A: 'x' }, semesters: { 'fall-2026': { name: 'Fall 2026' } } };
e2e/data-safety.spec.js:8847:          window.updateAppData = async (u) => {
e2e/data-safety.spec.js:8860:          stored = { activeSemester: 'fall-2026', teacherMappings: { A: 'x' }, semesters: { 'fall-2026': { name: 'Fall 2026' } } };
e2e/data-safety.spec.js:8861:          window.updateAppData = async (u) => {
e2e/data-safety.spec.js:8873:        } finally { window.readAppDataFromServer = realRead; window.updateAppData = realUpdate; pendingSemesterTypeStamps = null; }
e2e/data-safety.spec.js:8938:          window.getActiveSemesterKey = () => 'summer-2026';
e2e/data-safety.spec.js:8951:          window.getActiveSemesterKey = () => 'summer-2031';
e2e/data-safety.spec.js:9027:        window.getActiveSemesterKey = () => sem;
e2e/data-safety.spec.js:9066:        window.getActiveSemesterKey = () => sem;
e2e/data-safety.spec.js:9068:        const realList = window.listRegisteredSeasons; const realUpdate = window.updateAppData;
e2e/data-safety.spec.js:9077:          window.updateAppData = async () => { throw new Error('TEST simulated write failure'); };
e2e/data-safety.spec.js:9082:          window.alert = realAlert; window.listRegisteredSeasons = realList; window.updateAppData = realUpdate;
e2e/data-safety.spec.js:9111:        const realUpdate = window.updateAppData;
e2e/data-safety.spec.js:9112:        window.updateAppData = async () => { throw new Error('TEST simulated write failure'); };
e2e/data-safety.spec.js:9114:          await deleteSemester(sem);
e2e/data-safety.spec.js:9120:          window.alert = realAlert; window.confirm = realConfirm; window.updateAppData = realUpdate;

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html | sed -n '245,340p'
nl -ba js/app.js | sed -n '1,220p;270,380p;790,845p;4460,4650p;10640,10735p;11210,11370p'
nl -ba js/firebase-data.js | sed -n '1,90p;190,260p;740,825p;940,990p;3100,3135p'
nl -ba /Users/christiehubley/studio-hub/firestore.rules | sed -n '640,680p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
   245	<h2 id="safety">Firebase safety checklist</h2>
   246	<div class="safe">
   247	  <ul>
   248	    <li><strong>Rules:</strong> none needed. <code>curriculum/appData</code>: read for classbook users, write for manager+ only (<code>firestore.rules:652-669</code>). No new collection. Phase 1's e2e includes the non-manager refusal against the real rules.</li>
   249	    <li><strong>The Delete exposure (finding 3):</strong> making a weekly semester non-active makes it deletable, which is already true of Spring 2026 in production. Phase 1 adds the lesson count and the typed name to that delete, and the activation confirm says so. Until Phase 1 ships: <strong>don't click Delete on Spring 2026</strong>.</li>
   250	    <li><strong>Partial update:</strong> <code>updateAppData</code> (<code>update()</code> of named dotted paths; its <code>set(merge)</code> fallback fires only if appData doesn't exist, which isn't the case here). Only <code>activeSemester</code>, optionally <code>semesters.&lt;key&gt;.published</code> and <code>activeSemesterSwitch</code>, plus the existing <code>lastUpdated</code>/<code>lastUpdatedBy</code>.</li>
   251	    <li><strong>No undefined or empty values:</strong> every path is a known string or <code>true</code>. The key is validated against <code>currentConfig.semesters</code> before writing.</li>
   252	    <li><strong>Awaited:</strong> the one write is awaited, and on failure the in-memory state is restored exactly (the <code>toggleSemesterPublish</code> pattern, including "field was absent").</li>
   253	    <li><strong>No bulk op, no delete:</strong> no snapshot needed. The previous value is shown in the confirmation. To roll back, make the old semester active again with the same button (or the console line).</li>
   254	    <li><strong>Refuses on a bad load:</strong> inherited from <code>updateAppData</code> (config load failed, season registry unknown or error).</li>
   255	    <li><strong>Production spot-check</strong> after deploy: Christie uses the button once for real (or the console line has already done it), then checks <code>curriculum/appData.activeSemester</code> in the Firebase Console.</li>
   256	  </ul>
   257	</div>
   258	
   259	<h2 id="tests">Tests</h2>
   260	<ul>
   261	  <li>New <code>e2e/active-semester.spec.js</code> (emulator only), following the house pattern (finding 1):
   262	    <ul>
   263	      <li><strong>Payload/shape scenarios</strong> stub <code>window.updateAppData</code> and assert <code>Object.keys(payload).sort()</code> (as <code>data-safety.spec.js:7596-7610</code> does). The in-memory test semester is added to <code>currentConfig</code> in the page only, with an explicit <code>semesterType: 'weekly'</code>.</li>
   264	      <li><strong>Top leak risk:</strong> a leaked <code>activeSemesterSwitch</code> would silently move <em>every</em> later test (their contexts carry no <code>activeSemesterSwitchSeen</code>) to <code>sw.to</code>. The restore below is mandatory and read back, and a final assertion in this spec checks appData has no <code>activeSemesterSwitch</code>.</li>
   265	      <li><strong>One real round-trip</strong> runs in a manager context (<code>MANAGER_STATE_PATH</code>, first spec to use it). The test semester is created and removed through the app's own <code>updateAppData</code> in that page, and <code>activeSemester</code> is restored to <code>spring-2026</code> and <code>activeSemesterSwitch</code> deleted in <code>afterEach</code> <strong>and</strong> <code>afterAll</code>, each read back. Reason: with <code>workers: 1</code> this file runs <strong>first</strong> alphabetically, and a leak would break <code>day-off-camps.spec.js</code> "SDOC R6" and <code>day-off-teacher.spec.js</code> "T20", which read the active semester.</li>
   266	      <li><strong>The restore can't run from Node</strong> (the helper is staff, and appData writes are manager-only). <code>afterEach</code>/<code>afterAll</code> open a manager browser context and call the page's own <code>updateAppData</code> (<code>activeSemester: 'spring-2026'</code>, <code>activeSemesterSwitch: FieldValue.delete()</code>, <code>semesters.&lt;test&gt;: FieldValue.delete()</code>), then read back with <code>readAppDataFromServer()</code> (<code>firebase-data.js:243-247</code>).</li>
   267	      <li>The <strong>camp-season scenario runs stubbed</strong>. Its auto-publish would otherwise flip the seed's <code>summer-2026.published: false</code>, which <code>day-off-materials</code> M10 and <code>day-off-camps</code> enumerate.</li>
   268	      <li>Payloads: use the <code>window.updateAppData</code> stub pattern (<code>data-safety.spec.js:3947-3958</code>), whose payload holds only the caller's keys. <code>withAppDataSpy</code> is file-local and adds <code>lastUpdated</code>.</li>
   269	      <li><strong>One real rules refusal</strong> uses the staff account and asserts <code>permission-denied</code> specifically (the seeded season registry is valid, so <code>updateAppData</code>'s own guard won't fire first).</li>
   270	      <li><strong>Phase 2's teacher</strong> is a fresh context (blank storageState) signed in with <code>signInViaForm(page, 'teacher')</code>, because <code>login(page,'teacher')</code> on the default state returns the admin. The remembered <code>globalSemesterKey</code> is set <em>after</em> that first load, followed by a reload, because the app writes it itself on first load and the test would otherwise pass vacuously.</li>
   271	    </ul></li>
   272	  <li>Assertions that must use types, not key prefixes: <code>isWeeklySemester</code> / <code>isCampSeason</code> (the ratchet at <code>static-checks.spec.js:108</code>).</li>
   273	  <li>The full suite stays green. Re-count at execution time; don't trust a number in this plan.</li>
   274	</ul>
   275	
   276	<h2 id="completeness">Completeness: what if this is interrupted?</h2>
   277	<ul>
   278	  <li><strong>Mid-code, before deploy:</strong> nothing is live. Resume from the branch.</li>
   279	  <li><strong>The write itself is atomic:</strong> one <code>update()</code>, so the active flag and the auto-publish can't half-happen.</li>
   280	  <li><strong>Phase 1 shipped without Phase 2:</strong> still coherent. The button works and moves nobody. (The plan still deploys both together.)</li>
   281	  <li><strong>After a switch:</strong> browsers pick it up on their next load, whenever that is. There's no deadline and nothing to finish.</li>
   282	</ul>
   283	
   284	<h2 id="resume">Resume instructions</h2>
   285	<ol>
   286	  <li>Read this plan. Check the Decisions Log for Christie's answers to Q1/Q2 and any review findings.</li>
   287	  <li>Work in a worktree on branch <code>claude/make-active-semester</code> off <code>origin/main</code>.</li>
   288	  <li>Check line numbers against current main. They were recorded at <code>2ef2e62</code>.</li>
   289	  <li>e2e: <code>npm test -- --grep "active semester"</code>. The emulator ports are fixed, so if another session's suite holds 8180, wait or shift ports locally without committing (see the memory note on classbook worktree deploys).</li>
   290	  <li>Per phase: commit, run the full suite, then a second-model implementation review. Deploy once after both, only after Christie says yes, via <code>NETLIFY_SITE_ID=… npm run deploy</code> from a clean, pushed main.</li>
   291	</ol>
   292	
   293	<h2 id="decisions">Decisions Log (append-only)</h2>
   294	<div class="decision">
   295	  <strong>Sep 29, 2026: round 3 (confirmation) — EXECUTION-READY</strong> (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md</code>). All round-2 blockers were confirmed resolved. Its four clarifications are folded in: hide only <code>.footer-dot.write-control</code>; <code>readServerSemesterLessonMap</code> returning <code>null</code> means 0 lessons, not a failure; the three delete tests must split their <code>page.evaluate</code> to drive the modal; the activation uses <code>confirmModal</code> from Phase 1. Also named: a curriculum-admin/prep user with nothing remembered lands with Curriculum Admin hidden when Summer is active. All phases are marked execution-ready. Execution waits for Christie's go-ahead. Codex didn't review this plan (out of credits); all three rounds were Claude.
   296	</div>
   297	<div class="decision">
   298	  <strong>Sep 29, 2026: revision 3, after round-2 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r2-claude.md</code>).</strong> Round 2 found the write shape safe and listed five blockers, all verified and taken:
   299	  <ul>
   300	    <li>(a) The Settings dropdown fix syncs the header first, as Teacher View does.</li>
   301	    <li>(b) Phase 2's check is a one-shot in <code>DOMContentLoaded</code>, never in <code>initGlobalSemesterSelector</code>, and <code>at</code> is a client ISO string.</li>
   302	    <li>(c) "Nobody below manager sees it" was false: curriculum-admin and prep can open Settings through the footer link. Phase 1 hides that link, gates <code>switchTab</code>, and renders the button only for admin/manager.</li>
   303	    <li>(d) The e2e restore runs through a manager browser context, not Node. The camp scenario is stubbed so <code>summer-2026.published</code> can't leak. The <code>activeSemesterSwitch</code> leak is flagged as the top risk.</li>
   304	    <li>(e) The weekly-delete guard counts from the server (<code>readServerSemesterLessonMap</code>), corrects the false "cut bank and change history" text, and uses the same modal as Phase 2 (no <code>prompt()</code>). Three existing <code>data-safety</code> tests change in the same commit.</li>
   305	  </ul>
   306	  Also taken: an <code>isPublishableType</code> check before auto-publish, the name fallback in the confirm, filtering Settings' options by <code>canSeeSemester</code>, the camp-active consequences named in the confirm and BDD, and the stale-seen asymmetry recorded as a decision.<br>
   307	  <strong>Not taken (out of scope, noted):</strong> the dead code at <code>app.js:5069-5074</code> and <code>:4590</code>. <code>deleteLessonData</code> lacks a <code>lessonDataLoadedSuccessfully</code> guard and runs after the appData entry is gone inside a warn-only catch (pre-existing, and the server-read count now gates the whole delete). Cut bank and change history are orphaned by a weekly delete (pre-existing, and the text is now honest about it).
   308	</div>
   309	<div class="decision">
   310	  <strong>Sep 29, 2026: revision 2, after round-1 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r1-claude.md</code>).</strong> Verified against the code and taken:
   311	  <ul>
   312	    <li>(1) e2e can't write appData with the Node helper, so the house pattern is used: stub-and-payload, one manager round-trip with restore in afterEach+afterAll, one staff refusal.</li>
   313	    <li>(2) The Settings dropdown was broken, so it's fixed in Phase 1.</li>
   314	    <li>(3) Making a semester non-active arms its Delete, which is already live for Spring. Weekly delete now shows the lesson count and needs the name typed, and the confirm mentions it.</li>
   315	    <li>(4) Dropped the false "teachers will stop seeing it" warning (drafts were never visible). Noted that auto-publish makes the badge honest.</li>
   316	    <li>(5) Phase 2 stores <code>{to, at}</code> and ignores a switch whose target is no longer active.</li>
   317	    <li>(6) An invisible target isn't marked seen.</li>
   318	    <li>(7) Attach-once guard on the header listener.</li>
   319	    <li>(8) Teacher View's "(current)" is in the re-render set.</li>
   320	  </ul>
   321	  Low items taken: the set(merge) fallback noted, teacher read access stated, Phase 2 writes <code>localStorage.globalSemesterKey</code> itself, fresh teacher sign-in, restore with read-back plus the lastUpdated-ignoring diff, type-based eligibility. BDD gaps a–e added.<br>
   322	  <strong>Deliberately left alone:</strong> the two stale <code>'spring-2026'</code> fallback literals (<code>firebase-data.js:504, 3122</code>). They only fire with no config (the banner state), so they're out of scope and noted here.<br>
   323	  <strong>New UI consequence:</strong> Phase 2's checkbox needs a small modal instead of <code>confirm()</code>.
   324	</div>
   325	<div class="note" style="opacity:.7">
   326	  <strong>(Superseded — Christie stayed; round 1 addressed below.) PAUSED Sep 29, 2026.</strong> Round-1 plan review (Claude only; Codex is out of credits) finished but has <strong>not been addressed yet</strong>. It reports three findings that would stop or mislead execution, plus smaller ones. It ran on the plan <em>before</em> Christie's Q1 answer added Summer camp seasons, so re-check its points against that too. Files: <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r1-claude.md</code> (and <code>-r1-input.md</code>). Next: verify each finding against the code, revise this plan, append the outcome here, run a round-2 review, then ask Christie for the go-ahead. No code has been written, and nothing about this feature is on a branch yet.
   327	</div>
   328	<div class="decision">
   329	  <strong>Sep 29, 2026: production switched by console.</strong> Christie ran <code>await updateAppData({ activeSemester: 'fall-2026' })</code> on the live app. Fall 2026 is now active. Semesters at that point: summer-2026 (published), fall-2026 (published), sdoc-2026-27 (published:false), spring-2026 (published field absent, so visible). Returning browsers still remember Spring until they pick Fall. Phase 2's "switch everyone" is what fixes that next time.
   330	</div>
   331	<div class="decision">
   332	  <strong>Sep 29, 2026: Christie's answers.</strong> Q1 = class semesters AND Summer camp seasons (SDOC years excluded). Q2 = "switch everyone" ticked by default.
   333	</div>
   334	<div class="decision">
   335	  <strong>Sep 29, 2026: plan created.</strong> From Christie's question about switching active to Fall 2026. Found no UI exists, and that "active" doesn't move returning users (localStorage). Christie: "yes we should do this." Scope: Settings-only control (manager+), auto-publish a draft on activation, optional one-time "switch everyone" through a new appData field. Deliberately <em>not</em> in scope: renaming the misleading <code>getActiveSemesterKey()</code>, a live config listener, and the Curriculum Admin bar (non-managers use it).
   336	</div>
   337	
   338	</body>
   339	</html>
     1	// Curriculum Manager - Main JavaScript
     2	
     3	// ─── State ──────────────────────────────────────────
     4	
     5	let currentSheetItems = [];  // Raw from TSV (no manual items)
     6	let currentWeekItems = [];   // Sheet + manual items merged
     7	let currentWeekPrepData = {};
     8	let currentProjectGroups = null;
     9	let currentView = localStorage.getItem('curriculumView') || 'day';
    10	let debounceTimer = null;
    11	let prepInitialized = false;
    12	let activeFilters = { search: '', day: 'all', hideCompleted: false };
    13	let globalSemesterKey = localStorage.getItem('globalSemesterKey') || null;  // Universal semester selection
    14	
    15	// ─── Default Class Roster ───────────────────────────
    16	
    17	const DEFAULT_CLASS_ROSTER = {
    18	  'Mon Mini Makers':       { day: 'Monday',    time: '3:30pm', enrollment: 0 },
    19	  'Mon Pet Party!':        { day: 'Monday',    time: '3:30pm', enrollment: 0 },
    20	  'Mon Pet Party! 5pm':    { day: 'Monday',    time: '5:00pm', enrollment: 0 },
    21	  'Tue Homeschool 6-8':    { day: 'Tuesday',   time: '12:00pm', enrollment: 0 },
    22	  'Tue Mini Makers':       { day: 'Tuesday',   time: '3:30pm', enrollment: 0 },
    23	  'Tue Jewelry':           { day: 'Tuesday',   time: '3:30pm', enrollment: 0 },
    24	  'Tue Myth & Magic':      { day: 'Tuesday',   time: '3:30pm', enrollment: 0 },
    25	  'Tue Myth & Magic 5pm':  { day: 'Tuesday',   time: '5:00pm', enrollment: 0 },
    26	  'Tue Art Club':          { day: 'Tuesday',   time: '5:00pm', enrollment: 0 },
    27	  'Tue Continuing Sewing': { day: 'Tuesday',   time: '5:00pm', enrollment: 0 },
    28	  'Wed Art Lab!':          { day: 'Wednesday', time: '3:30pm', enrollment: 0 },
    29	  'Wed Art Lab! 5pm':      { day: 'Wednesday', time: '5:00pm', enrollment: 0 },
    30	  'Wed Digital Art':       { day: 'Wednesday', time: '3:30pm', enrollment: 0 },
    31	  'Wed Digital Art 5pm':   { day: 'Wednesday', time: '5:00pm', enrollment: 0 },
    32	  'Wed Let\'s Sew!':       { day: 'Wednesday', time: '3:30pm', enrollment: 0 },
    33	  'Wed Let\'s Sew! 5pm':   { day: 'Wednesday', time: '5:00pm', enrollment: 0 },
    34	  'Wed Teen Paint & Draw': { day: 'Wednesday', time: '5:00pm', enrollment: 0 },
    35	  'Thu Homeschool 6-8':    { day: 'Thursday',  time: '9:30am', enrollment: 0 },
    36	  'Thu Draw & Paint':      { day: 'Thursday',  time: '3:30pm', enrollment: 0 },
    37	  'Thu Draw & Paint 5pm':  { day: 'Thursday',  time: '5:00pm', enrollment: 0 },
    38	  'Thu Realistic Drawing': { day: 'Thursday',  time: '5:00pm', enrollment: 0 },
    39	  'Fri Homeschool 6-8':    { day: 'Friday',    time: '9:30am', enrollment: 0 },
    40	  'Fri Ceramics':          { day: 'Friday',    time: '3:30pm', enrollment: 0 },
    41	  'Fri Clay Class':        { day: 'Friday',    time: '5:00pm', enrollment: 0 },
    42	  'Teen Digital Art':      { day: 'Saturday',  time: 'TBD',    enrollment: 0 }
    43	};
    44	
    45	// ─── Global Semester Management ─────────────────────
    46	
    47	function initGlobalSemesterSelector() {
    48	  const select = document.getElementById('global-semester-select');
    49	  const userSpan = document.getElementById('header-user');
    50	
    51	  if (!select || !currentConfig?.semesters) return;
    52	
    53	  const user = getAuthUser();
    54	  const isAdmin = user && ['admin', 'manager'].includes(user.role);
    55	  const semesters = currentConfig.semesters;
    56	  const keys = Object.keys(semesters);
    57	
    58	  // Filter semesters: canSeeSemester() — manager+ all; others published, plus
    59	  // an unpublished SDOC year for the prep team (Phase 2A).
    60	  const visibleKeys = keys.filter(canSeeSemester);
    61	
    62	  // Set initial global semester if not set — or if the remembered one is not
    63	  // visible to THIS user (a shared device where a manager last picked a draft
    64	  // semester must not leave a teacher inside it — review).
    65	  if (!globalSemesterKey || !semesters[globalSemesterKey] || !visibleKeys.includes(globalSemesterKey)) {
    66	    // …and the fallback must be visible too (review: an unpublished active
    67	    // semester would otherwise put the teacher straight back inside it).
    68	    globalSemesterKey = visibleKeys.includes(currentConfig.activeSemester) ? currentConfig.activeSemester : visibleKeys[0];
    69	    localStorage.setItem('globalSemesterKey', globalSemesterKey);
    70	  }
    71	
    72	  // Populate dropdown
    73	  let html = '';
    74	  for (const key of visibleKeys) {
    75	    const sem = semesters[key];
    76	    const isActive = key === currentConfig.activeSemester;
    77	    const isDraft = sem.published === false;
    78	    let label = sem.name;
    79	    if (isActive) label += ' (active)';
    80	    if (isDraft && isAdmin) label += ' [draft]';
    81	    html += `<option value="${escAttr(key)}" ${key === globalSemesterKey ? 'selected' : ''}>${escHtml(String(label ?? ''))}</option>`;
    82	  }
    83	  select.innerHTML = html;
    84	
    85	  // Handle changes
    86	  select.addEventListener('change', () => {
    87	    setGlobalSemester(select.value);
    88	  });
    89	
    90	  // Show user name
    91	  if (userSpan && user) {
    92	    userSpan.textContent = user.name || user.email;
    93	  }
    94	}
    95	
    96	function setGlobalSemester(key) {
    97	  if (!currentConfig?.semesters?.[key]) return;
    98	
    99	  globalSemesterKey = key;
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
   211	      document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
   212	      document.getElementById(tabId)?.classList.add('active');
   213	
   214	      if (tabId === 'teacher-view') {
   215	        initTeacherView();
   216	      } else if (tabId === 'prep-dashboard') {
   217	        initPrepDashboard();
   218	      } else if (tabId === 'curriculum-admin') {
   219	        initCurriculumAdmin();
   220	      } else if (tabId === 'settings') {
   270	  if (!user) return false;
   271	  return canPlanDayOffCamps() || (hasPrepAccess() && !!user.appAccess?.includes('classbook'));
   272	}
   273	// Which semesters this user may select, in the header AND Teacher View:
   274	// manager+ see all; everyone else sees published ones, plus an unpublished
   275	// School Day Off Camps year if they are on the prep team (Christie, Sep 24:
   276	// drafts hidden from prep staff in Teacher View too).
   277	function canSeeSemester(key) {
   278	  const user = getAuthUser();
   279	  const sem = currentConfig?.semesters?.[key];
   280	  if (!user || !sem) return false;
   281	  if (user.role === 'admin' || user.role === 'manager') return true;
   282	  if (sem.published !== false) return true;
   283	  return isDayOffYear(key) && canTickDayOffMaterials();
   284	}
   285	
   286	// Alias for backward compatibility with existing code
   287	function isAdminOrManager() {
   288	  return hasCurriculumAdminAccess();
   289	}
   290	
   291	function hasPrepAccess() {
   292	  const user = getAuthUser();
   293	  if (!user) return false;
   294	  return user.role === 'prep' || hasCurriculumAdminAccess();
   295	}
   296	
   297	// Hide/show Curriculum Admin tab based on semester type for non-manager users.
   298	// Called on initial load and on semester change.
   299	function updateCurriculumAdminTab() {
   300	  const user = getAuthUser();
   301	  if (!user || user.role === 'admin' || user.role === 'manager') return; // manager+ always see it
   302	  if (!hasCurriculumAdminAccess()) return; // plain classbook teachers never had it
   303	
   304	  const semKey = getActiveSemesterKey();
   305	  const semester = currentConfig?.semesters?.[semKey];
   306	  const caTab = document.querySelector('.tab-btn[data-tab="curriculum-admin"]');
   307	  if (!caTab) return;
   308	
   309	  if (semester?.semesterType === 'summer-camp') {
   310	    caTab.style.display = 'none';
   311	    if (document.querySelector('.tab-btn.active')?.dataset.tab === 'curriculum-admin') {
   312	      switchTab('teacher-view');
   313	    }
   314	  } else {
   315	    caTab.style.display = '';
   316	  }
   317	}
   318	
   319	function setupRoleAccess() {
   320	  const user = getAuthUser();
   321	  if (!user) return;
   322	
   323	  // Manager+: full access to all tabs including Settings
   324	  if (user.role === 'admin' || user.role === 'manager') return;
   325	
   326	  // classbook-admin / curriculum-admin / prep role: all tabs EXCEPT Settings
   327	  // Settings is manager+ only — classbook admins can't change semester config
   328	  if (hasCurriculumAdminAccess() || hasPrepAccess()) {
   329	    document.querySelector('.tab-btn[data-tab="settings"]')?.style.setProperty('display', 'none');
   330	    updateCurriculumAdminTab(); // Hide Curriculum Admin on summer semesters
   331	    return;
   332	  }
   333	
   334	  // Otherwise: Teacher View only (read-only mode)
   335	  // Hide admin tabs (Curriculum Admin, Settings) and Prep Dashboard
   336	  document.body.classList.add('read-only');
   337	  document.body.classList.add('teacher-view-only');
   338	
   339	  // Switch active tab to Teacher View since Curriculum Admin is hidden for teachers
   340	  switchTab('teacher-view');
   341	
   342	  // Hide Back to HQ link for non-admin users
   343	  const hqLink = document.getElementById('back-to-hq-link');
   344	  if (hqLink) hqLink.style.display = 'none';
   345	}
   346	
   347	// ─── Footer ─────────────────────────────────────────
   348	
   349	function setupFooter() {
   350	  document.getElementById('help-link')?.addEventListener('click', (e) => {
   351	    e.preventDefault();
   352	    document.getElementById('help-modal').classList.add('open');
   353	  });
   354	  document.getElementById('help-close')?.addEventListener('click', () => {
   355	    document.getElementById('help-modal').classList.remove('open');
   356	  });
   357	
   358	  // Settings link switches to Settings tab — through the tab button, so it gets
   359	  // the same form refresh as clicking the tab (review: it used to bypass it).
   360	  document.getElementById('settings-link')?.addEventListener('click', (e) => {
   361	    e.preventDefault();
   362	    switchTab('settings');
   363	  });
   364	
   365	  document.getElementById('footer-sign-out')?.addEventListener('click', (e) => {
   366	    e.preventDefault();
   367	    if (confirm('Sign out?')) authSignOut();
   368	  });
   369	
   370	  document.querySelectorAll('.simple-modal-overlay').forEach(overlay => {
   371	    overlay.addEventListener('click', (e) => {
   372	      // Editors with a lot of typing opt out: a stray click beside the box
   373	      // must not throw the work away (Christie, Sep 24).
   374	      if (e.target === overlay && !overlay.hasAttribute('data-sticky')) overlay.classList.remove('open');
   375	    });
   376	  });
   377	}
   378	
   379	
   380	// ═════════════════════════════════════════════════════
   790	  document.getElementById('tv-this-week-btn').addEventListener('click', scrollToThisWeek);
   791	}
   792	
   793	function renderTvSemesterSelector() {
   794	  const group = document.getElementById('tv-semester-group');
   795	  const select = document.getElementById('tv-semester-select');
   796	  if (!group || !select || !currentConfig?.semesters) return;
   797	
   798	  // Get published semesters (or all for admin/manager)
   799	  const user = getAuthUser();
   800	  const semesters = currentConfig.semesters;
   801	  // The same rule as the header (Christie, Sep 24): drafts are no longer
   802	  // listed to curriculum-admin staff here — only manager+ see them.
   803	  const keys = Object.keys(semesters).filter(canSeeSemester);
   804	
   805	  // Only show if more than one semester available
   806	  if (keys.length <= 1) {
   807	    group.style.display = 'none';
   808	    tvCurrentSemester = null;
   809	    return;
   810	  }
   811	
   812	  group.style.display = '';
   813	  const currentKey = getTvSemKey();
   814	
   815	  let html = '';
   816	  for (const key of keys) {
   817	    const sem = semesters[key];
   818	    const isActive = key === currentConfig.activeSemester;
   819	    const label = sem.name + (isActive ? ' (current)' : '') + (sem.published === false ? ' [draft]' : '');
   820	    html += `<option value="${escAttr(key)}" ${key === currentKey ? 'selected' : ''}>${escHtml(label)}</option>`;
   821	  }
   822	  select.innerHTML = html;
   823	
   824	  // Only attach listener once
   825	  if (!select.dataset.listenerAttached) {
   826	    select.addEventListener('change', () => {
   827	      // It switches the app's semester (it used to set a variable nothing read,
   828	      // so it only ever re-listed the header's semester — impl review, 2B).
   829	      const header = document.getElementById('global-semester-select');
   830	      if (header) header.value = select.value;
   831	      setGlobalSemester(select.value);
   832	      if (isDayOffYear(select.value)) return;   // renderTeacherView() built the SDOC list
   833	      tvCurrentTeacher = '';
   834	      tvCurrentClassFilter = 'all';
   835	      tvNavStack = [];
   836	      const semKey = getTvSemKey();
   837	      const lessons = currentLessonData?.[semKey];
   838	      if (lessons) {
   839	        populateTvTeacherList(lessons);
   840	        // Re-auto-select teacher for staff users after semester switch
   841	        const matchedTeacher = getTeacherNameForCurrentUser();
   842	        const allTeachers = [...new Set(Object.values(lessons).map(l => l.teacher).filter(Boolean))];
   843	        if (matchedTeacher && allTeachers.includes(matchedTeacher)) {
   844	          document.getElementById('tv-teacher-select').value = matchedTeacher;
   845	          tvCurrentTeacher = matchedTeacher;
  4460	        <span style="font-size:0.8rem;color:${color};font-weight:600;">${escHtml(sess.teacher)}</span>
  4461	        <span style="font-size:0.78rem;color:var(--gray-500);">${escHtml(sess.studio)} · ${escHtml(sess.timeSlot || '')}</span>
  4462	      </div>
  4463	      <table style="border-collapse:collapse;width:100%;">${rows}</table>
  4464	    </div>`;
  4465	  });
  4466	
  4467	  return html || `<div class="tv-placeholder">No lesson data found for Week ${weekNum}.</div>`;
  4468	}
  4469	
  4470	// ─── End Summer CA Views ──────────────────────────────────────────────────────
  4471	
  4472	function renderSemesterSelector() {
  4473	  const bar = document.getElementById('ca-semester-bar');
  4474	  const select = document.getElementById('ca-semester-select');
  4475	  const publishGroup = document.getElementById('ca-semester-publish-group');
  4476	  if (!bar || !select || !currentConfig?.semesters) return;
  4477	
  4478	  const semesters = currentConfig.semesters;
  4479	  const keys = Object.keys(semesters);
  4480	
  4481	  // Only show bar if user is admin/manager
  4482	  const user = getAuthUser();
  4483	  if (!user || !['admin', 'manager'].includes(user.role)) { bar.style.display = 'none'; return; }
  4484	
  4485	  bar.style.display = 'flex';
  4486	  const currentKey = getAdminSemKey();
  4487	
  4488	  // Build dropdown options
  4489	  let optionsHtml = '';
  4490	  for (const key of keys) {
  4491	    const sem = semesters[key];
  4492	    const isActive = key === currentConfig.activeSemester;
  4493	    const isPublished = sem.published !== false;
  4494	    const label = sem.name + (isActive ? ' (active)' : '') + (!isPublished ? ' [draft]' : '');
  4495	    optionsHtml += `<option value="${escAttr(key)}" ${key === currentKey ? 'selected' : ''}>${escHtml(label)}</option>`;
  4496	  }
  4497	  select.innerHTML = optionsHtml;
  4498	  select.onchange = () => setGlobalSemester(select.value);
  4499	
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
 10640	
 10641	  // Save note buttons
 10642	  resultsDiv.querySelectorAll('.diag-note-save').forEach(btn => {
 10643	    btn.addEventListener('click', () => {
 10644	      const fp = btn.dataset.fp;
 10645	      const item = btn.closest('.diag-item');
 10646	      const textarea = item.querySelector(`.diag-note-input[data-fp="${fp}"]`);
 10647	      if (textarea) {
 10648	        // Trigger the blur handler which does the actual save
 10649	        textarea.blur();
 10650	      }
 10651	    });
 10652	  });
 10653	}
 10654	
 10655	// ═════════════════════════════════════════════════════
 10656	// SETTINGS
 10657	// ═════════════════════════════════════════════════════
 10658	
 10659	function getSettingsSemKey() {
 10660	  // Now uses global semester instead of per-tab selection
 10661	  return getActiveSemesterKey();
 10662	}
 10663	
 10664	let settingsTeacherPoolAtLoad = { semKey: null, names: [] };
 10665	// Which semester the Settings form was last drawn for. Save writes to the
 10666	// HEADER's semester, so the two must match: the form used to redraw only on a
 10667	// semester change made while on Settings, and after switching semesters
 10668	// elsewhere a Save wrote one semester's values onto another (Sep 24).
 10669	let settingsFormSemKey = null;
 10670	
 10671	// Redraw only when the header's semester differs from the form's — returning
 10672	// to the tab for the same semester keeps any unsaved edits.
 10673	function ensureSettingsFormMatchesHeader() {
 10674	  if (settingsFormSemKey !== getSettingsSemKey()) loadSettingsForm();
 10675	}
 10676	
 10677	function loadSettingsForm() {
 10678	  const config = currentConfig || getDefaultConfig();
 10679	
 10680	  // Build semester selector
 10681	  const selectEl = document.getElementById('settings-semester-select');
 10682	  if (selectEl) {
 10683	    const keys = Object.keys(config.semesters || {});
 10684	    const currentKey = getSettingsSemKey();
 10685	    selectEl.innerHTML = keys.map(k => {
 10686	      const s = config.semesters[k];
 10687	      const label = s.name + (k === config.activeSemester ? ' (active)' : '');
 10688	      return `<option value="${escAttr(k)}" ${k === currentKey ? 'selected' : ''}>${escHtml(label)}</option>`;
 10689	    }).join('');
 10690	  }
 10691	
 10692	  const semKey = getSettingsSemKey();
 10693	  const semester = config.semesters?.[semKey] || {};
 10694	  // The pool as this form found it — the × button edits currentConfig's list
 10695	  // in place, so saveSettings() cannot use that to see what was removed.
 10696	  settingsTeacherPoolAtLoad = { semKey, names: [...(semester.teacherNames || [])] };
 10697	  settingsFormSemKey = semKey;
 10698	
 10699	  // Publish toggle
 10700	  const publishGroup = document.getElementById('settings-semester-publish-group');
 10701	  if (publishGroup) {
 10702	    const isActive = semKey === config.activeSemester;
 10703	    const isPublished = semester.published !== false;
 10704	    if (isActive) {
 10705	      publishGroup.innerHTML = '<span class="ca-sem-active-badge">Active Semester — always visible to teachers</span>';
 10706	    } else {
 10707	      publishGroup.innerHTML = `
 10708	        <label class="ca-publish-toggle">
 10709	          <input type="checkbox" ${isPublished ? 'checked' : ''} onchange="toggleSemesterPublish('${escAttr(semKey)}', this.checked)">
 10710	          Published (visible to teachers)
 10711	        </label>
 10712	        ${!isPublished ? '<span class="ca-sem-unpublished-badge" style="margin-left:8px">Draft</span>' : ''}
 10713	      `;
 10714	    }
 10715	  }
 10716	
 10717	  const el = (id) => document.getElementById(id);
 10718	  if (el('settings-semester-name')) el('settings-semester-name').value = semester.name || '';
 10719	  if (el('settings-start-date')) el('settings-start-date').value = semester.startDate || '';
 10720	  if (el('settings-num-weeks')) el('settings-num-weeks').value = semester.numWeeks || 16;
 10721	  if (el('settings-break-weeks')) el('settings-break-weeks').value = (semester.breakWeeks || []).join(', ');
 10722	  if (el('settings-closure-dates')) el('settings-closure-dates').value = formatClosureDates(semester.closureDates || []);
 10723	
 10724	  // Class Roster — auto-populate from defaults if empty
 10725	  let roster = semester.classRoster;
 10726	  if (!roster || Object.keys(roster).length === 0) {
 10727	    roster = JSON.parse(JSON.stringify(DEFAULT_CLASS_ROSTER));
 10728	  }
 10729	  renderClassRosterTable(roster);
 10730	
 10731	  // Teacher Names List
 10732	  renderTeacherNamesList();
 10733	
 10734	  // Teacher Name Mapping
 10735	  renderTeacherMappingTable();
 11210	  renderTeacherMappingTable();
 11211	}
 11212	
 11213	function getTeacherMappingsFromForm() {
 11214	  const mappings = {};
 11215	  const selects = document.querySelectorAll('.teacher-mapping-select');
 11216	  selects.forEach(select => {
 11217	    const uid = select.value;
 11218	    const teacherName = select.dataset.teacher;
 11219	    if (uid && teacherName) {
 11220	      mappings[uid] = teacherName;
 11221	    }
 11222	  });
 11223	  return mappings;
 11224	}
 11225	
 11226	async function saveSettings() {
 11227	  const el = (id) => document.getElementById(id)?.value?.trim() || '';
 11228	  // Last line of defence: never write a form drawn for one semester onto another.
 11229	  if (settingsFormSemKey !== getSettingsSemKey()) {
 11230	    loadSettingsForm();
 11231	    alert('This form was showing a different semester from the one selected at the top, so nothing was saved. It now shows the selected semester — check it and save again.');
 11232	    return;
 11233	  }
 11234	
 11235	  const breakWeeksStr = el('settings-break-weeks');
 11236	  const breakWeeks = breakWeeksStr.split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n));
 11237	  const closureDates = parseClosureDates(el('settings-closure-dates'));
 11238	
 11239	  const semKey = getSettingsSemKey();
 11240	  const classRoster = getClassRosterFromForm();
 11241	  const teacherNames = getTeacherNamesFromForm();
 11242	
 11243	  const teacherMappings = getTeacherMappingsFromForm();
 11244	
 11245	  // Merge into existing config to preserve other semesters
 11246	  const config = JSON.parse(JSON.stringify(currentConfig || {}));
 11247	  config.activeSemester = config.activeSemester || semKey;
 11248	
 11249	  // Safety guard: if the form returned no mappings but existing mappings exist,
 11250	  // the user dropdowns likely hadn't finished loading when Save was clicked.
 11251	  // Preserve existing mappings to prevent accidental wipeout.
 11252	  const existingMappings = currentConfig?.teacherMappings || {};
 11253	  config.teacherMappings = Object.keys(teacherMappings).length > 0
 11254	    ? teacherMappings
 11255	    : existingMappings;
 11256	  if (!config.semesters) config.semesters = {};
 11257	  // Only the fields this semester's TYPE owns (Phase 1, 1.2). Spreading the
 11258	  // whole form is what could put numWeeks: 16, an empty breakWeeks and the
 11259	  // hidden default class roster onto a camp season.
 11260	  // An SDOC year: its own date fields, and two guards before anything is
 11261	  // written — a name a camp still uses can't leave the pool, and the year
 11262	  // can't shrink past an existing event's date (forced-server reads).
 11263	  const isDayOff = isDayOffYear(semKey);
 11264	  if (isDayOff) {
 11265	    const start = el('settings-dayoff-start');
 11266	    const end = el('settings-end-date');
 11267	    if (!isIsoDate(start) || !isIsoDate(end) || end <= start) { alert('The school year needs a start date and an end date after it.'); return; }
 11268	    if (!el('settings-semester-name')) { alert('The school year needs a name.'); return; }
 11269	    try {
 11270	      // The SERVER's pool, not this tab's: the × button edits
 11271	      // currentConfig's list before Save runs, and another tab may have added
 11272	      // a name (and put it on a camp) since this form loaded (review HIGH).
 11273	      const serverPool = (await readAppDataFromServer())?.semesters?.[semKey]?.teacherNames || [];
 11274	      const loadedPool = settingsTeacherPoolAtLoad.semKey === semKey ? settingsTeacherPoolAtLoad.names : [];
 11275	      const removed = [...new Set([...serverPool, ...loadedPool])].filter(n => !teacherNames.includes(n));
 11276	      const inUse = await dayOffTeachersInUse(semKey, removed);
 11277	      if (inUse.length) {
 11278	        // Put just those names back in this tab's list (other unsaved edits in
 11279	        // the form stay as they are).
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
   190	    : "Can't read the app configuration — check your connection. Nothing was changed, and saving is disabled until this is fixed.";
   191	  const target = banner.querySelector('[data-role="message"]') || banner;
   192	  target.textContent = msg;
   193	  banner.classList.remove('hidden');
   194	}
   195	
   196	// ─── appData writes — one update(), only the paths named (Phase 1, 1.2) ──────
   197	// `updates` is a flat map of dotted field paths → values (FieldValue.delete()
   198	// allowed). Semester keys are slugified [a-z0-9-], so a dotted path never
   199	// needs quoting. Dotted STRINGS, not FieldPath objects: the compat SDK's
   200	// FieldPath form needs the varargs overload, an easy mistake.
   201	function nestFieldPaths(flat) {
   202	  const nested = {};
   203	  for (const [path, value] of Object.entries(flat)) {
   204	    const parts = path.split('.');
   205	    let node = nested;
   206	    while (parts.length > 1) { const k = parts.shift(); node = node[k] = node[k] || {}; }
   207	    node[parts[0]] = value;
   208	  }
   209	  return nested;
   210	}
   211	
   212	async function updateAppData(updates) {
   213	  if (!curriculumDb) initCurriculumFirestore();
   214	  if (configLoadFailed) {
   215	    throw new Error('The app configuration could not be read — refusing to write to it. Reload once the problem is fixed.');
   216	  }
   217	  // "Every writer refuses" includes these ones (Phase 1, 1.3). Publish,
   218	  // delete, create, Settings and the migration all write through here; without
   219	  // this an admin could still change the configuration while the app is behind
   220	  // the banner telling them saving is disabled.
   221	  if (seasonRegistryMode === 'error' || seasonRegistryMode === 'unknown') {
   222	    throw new Error(`Refusing to change the app configuration: the season registry is ${seasonRegistryMode === 'unknown' ? 'unreachable' : 'unreadable or malformed'}. Nothing was changed.`);
   223	  }
   224	  const user = getAuthUser();
   225	  const payload = {
   226	    ...updates,
   227	    lastUpdated: new Date().toISOString(),
   228	    lastUpdatedBy: user?.name || 'Unknown',
   229	  };
   230	  const ref = curriculumDb.collection('curriculum').doc('appData');
   231	  try {
   232	    await ref.update(payload);
   233	  } catch (err) {
   234	    if (err?.code !== 'not-found') throw err;
   235	    // Initialisation only: no appData document exists yet. update() cannot
   236	    // create one, so merge-set the same paths as real nesting.
   237	    await ref.set(nestFieldPaths(payload), { merge: true });
   238	  }
   239	}
   240	
   241	// Forced-server read of curriculum/appData — bypasses the SDK cache. Used
   242	// before creating a semester, and by the type migration's dry run/read-back.
   243	async function readAppDataFromServer() {
   244	  if (!curriculumDb) initCurriculumFirestore();
   245	  const doc = await curriculumDb.collection('curriculum').doc('appData').get({ source: 'server' });
   246	  return doc.exists ? doc.data() : null;
   247	}
   248	
   249	// Which appData paths a Settings save may write, by the semester's TYPE. A
   250	// camp season's name, dates, weeks, breaks, time slots and studios come from
   251	// the Summer Camp App's registry and are re-synced, never typed here — before
   252	// Phase 1 a Settings save spread the whole form over the semester and could
   253	// put numWeeks: 16, an empty breakWeeks and the hidden default class roster
   254	// onto Summer 2026.
   255	function settingsFieldPathsFor(semKey, values, semesters) {
   256	  const type = (semesters || currentConfig?.semesters)?.[semKey]?.semesterType
   257	    || (semKey === LEGACY_CAMP_SEMESTER_KEY ? SEMESTER_TYPES.camp : SEMESTER_TYPES.weekly);
   258	  const p = (f) => `semesters.${semKey}.${f}`;
   259	  if (type === SEMESTER_TYPES.camp) {
   260	    return { [p('teacherNames')]: values.teacherNames };
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
  3100	  const out = [];
  3101	  for (const e of events) for (const d of e.dates || []) { if (d < startDate || d > endDate) out.push({ label: e.label, date: d }); }
  3102	  return out;
  3103	}
  3104	
  3105	async function countDayOffEvents(yearKey) {
  3106	  return (await dayOffServerDocs('events', 'yearKey', yearKey)).length;
  3107	}
  3108	
  3109	// ─── Helpers ─────────────────────────────────────────
  3110	
  3111	function getActiveSemester() {
  3112	  if (!currentConfig) return null;
  3113	  const key = getActiveSemesterKey();
  3114	  return currentConfig.semesters?.[key] || null;
  3115	}
  3116	
  3117	function getActiveSemesterKey() {
  3118	  // Use global semester if set, otherwise fall back to active semester
  3119	  if (globalSemesterKey && currentConfig?.semesters?.[globalSemesterKey]) {
  3120	    return globalSemesterKey;
  3121	  }
  3122	  return currentConfig?.activeSemester || 'spring-2026';
  3123	}
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

codex
A new blocker has emerged in Phase 2: leaving the prior switch record untouched when the checkbox is unticked can later reactivate an old “switch everyone” instruction. I’m tracing that alongside the destructive weekly-delete sequence and the test restore mechanics before giving the verdict.
exec
/bin/zsh -lc "rg -n --hidden --glob '"'!node_modules/**'"' --glob '"'!e2e/test-results/**'"' --glob '"'!e2e/playwright-report/**'"' \"activeSemester|globalSemesterKey|activeSemesterSwitch|activeSemesterSwitchSeen|curriculumView\" .
rg -n \"fullyParallel|workers|testDir|globalSetup|storageState|dependencies|projects\" playwright.config.* e2e package.json
nl -ba playwright.config.js | sed -n '1,240p'
nl -ba e2e/global-setup.js | sed -n '1,180p'
nl -ba e2e/helpers/firestore.js | sed -n '1,120p;280,330p'
nl -ba e2e/helpers/login.js | sed -n '1,120p'
nl -ba e2e/fixtures/seed/curriculum.json | sed -n '1,160p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
./js/app.js:9:let currentView = localStorage.getItem('curriculumView') || 'day';
./js/app.js:13:let globalSemesterKey = localStorage.getItem('globalSemesterKey') || null;  // Universal semester selection
./js/app.js:65:  if (!globalSemesterKey || !semesters[globalSemesterKey] || !visibleKeys.includes(globalSemesterKey)) {
./js/app.js:68:    globalSemesterKey = visibleKeys.includes(currentConfig.activeSemester) ? currentConfig.activeSemester : visibleKeys[0];
./js/app.js:69:    localStorage.setItem('globalSemesterKey', globalSemesterKey);
./js/app.js:76:    const isActive = key === currentConfig.activeSemester;
./js/app.js:81:    html += `<option value="${escAttr(key)}" ${key === globalSemesterKey ? 'selected' : ''}>${escHtml(String(label ?? ''))}</option>`;
./js/app.js:99:  globalSemesterKey = key;
./js/app.js:100:  localStorage.setItem('globalSemesterKey', key);
./js/app.js:176:  const currentSemester = currentConfig?.semesters?.[globalSemesterKey];
./js/app.js:178:  if (prepDashboardTab && currentSemester && !isWeeklySemester(globalSemesterKey)) {
./js/app.js:818:    const isActive = key === currentConfig.activeSemester;
./js/app.js:4492:    const isActive = key === currentConfig.activeSemester;
./js/app.js:4514:    const isActive = currentKey === currentConfig.activeSemester;
./js/app.js:4530:  if (key === currentConfig.activeSemester) {
./js/app.js:4590:  caCurrentSemester = currentConfig.activeSemester;
./js/app.js:9207:      localStorage.setItem('curriculumView', currentView);
./js/app.js:9366:      localStorage.setItem('curriculumView', currentView);
./js/app.js:9700:  const currentSemester = currentConfig.semesters?.[globalSemesterKey];
./js/app.js:10687:      const label = s.name + (k === config.activeSemester ? ' (active)' : '');
./js/app.js:10702:    const isActive = semKey === config.activeSemester;
./js/app.js:11247:  config.activeSemester = config.activeSemester || semKey;
./js/app.js:11318:  // activeSemester is only ever SET when missing, never re-pointed from here.
./js/app.js:11319:  if (!currentConfig?.activeSemester) extraPaths.activeSemester = semKey;
./js/app.js:11336:    if (extraPaths.activeSemester) currentConfig.activeSemester = extraPaths.activeSemester;
./js/firebase-data.js:504:    activeSemester: 'spring-2026',
./js/firebase-data.js:3119:  if (globalSemesterKey && currentConfig?.semesters?.[globalSemesterKey]) {
./js/firebase-data.js:3120:    return globalSemesterKey;
./js/firebase-data.js:3122:  return currentConfig?.activeSemester || 'spring-2026';
./e2e/day-off-teacher.spec.js:661:    const weekly = await prep.evaluate(() => currentConfig.activeSemester);
./e2e/fixtures/seed/curriculum.json:3:    "activeSemester": "spring-2026",
./e2e/day-off-camps.spec.js:366:        globalSemesterKey = Y;   // e.g. a manager picked the draft year on this device
./e2e/day-off-camps.spec.js:368:        const teacherKey = globalSemesterKey;
./e2e/day-off-camps.spec.js:401:      const realActive = currentConfig.activeSemester;
./e2e/day-off-camps.spec.js:404:        currentConfig.activeSemester = Y;   // unpublished
./e2e/day-off-camps.spec.js:405:        globalSemesterKey = Y;
./e2e/day-off-camps.spec.js:407:        return { key: globalSemesterKey, published: currentConfig.semesters[globalSemesterKey]?.published };
./e2e/day-off-camps.spec.js:408:      } finally { window.getAuthUser = realUser; currentConfig.activeSemester = realActive; }
./e2e/day-off-camps.spec.js:509:      await page.evaluate(() => { globalSemesterKey = 'summer-2026'; });   // header moved, form not redrawn
./e2e/data-safety.spec.js:49:  // Set semester so getTvSemKey() (→ getActiveSemesterKey() → globalSemesterKey)
./e2e/data-safety.spec.js:7637:          await updateAppData({ 'semesters.test-x.name': 'TEST X', 'activeSemester': 'test-x' });
./e2e/data-safety.spec.js:7646:      expect(r.set[0].payload.activeSemester).toBe('test-x');
./e2e/data-safety.spec.js:7742:            get: async () => ({ exists: true, data: () => ({ activeSemester: 'fall-2026', semesters: { 'fall-2026': { name: 'Fall 2026', semesterType: 'weekly' } } }) }),
./e2e/data-safety.spec.js:8845:          let stored = { activeSemester: 'fall-2026', teacherMappings: { A: 'x' }, semesters: { 'fall-2026': { name: 'Fall 2026' } } };
./e2e/data-safety.spec.js:8860:          stored = { activeSemester: 'fall-2026', teacherMappings: { A: 'x' }, semesters: { 'fall-2026': { name: 'Fall 2026' } } };
package.json:30:  "dependencies": {
playwright.config.js:18:  testDir: './e2e',
playwright.config.js:21:  globalSetup: require.resolve('./e2e/global-setup.js'),
playwright.config.js:22:  workers: 1,
playwright.config.js:29:    storageState: 'e2e/.auth/state.json',
playwright.config.js:49:  projects: [
e2e/teacher-mapping.spec.js:14:test.use({ storageState: MANAGER_STATE_PATH });
e2e/helpers/sdoc.js:22:  projects: {
e2e/helpers/firestore.js:228:// sets workers: 1) — none of them namespace or lock by semesterKey, so raising
e2e/helpers/firestore.js:229:// workers later would introduce a real race for tests sharing the same test semester.
e2e/helpers/login.js:31:// admin writes) use it with test.use({ storageState: MANAGER_STATE_PATH }).
e2e/fixtures/seed/curriculum.json:172:    "projects": [
e2e/day-off-camps.spec.js:22:test.use({ storageState: MANAGER_STATE_PATH });
e2e/day-off-camps.spec.js:84:      const ctx = await browser.newContext({ storageState: { cookies: [], origins: [] } });
e2e/day-off-camps.spec.js:177:    const camp = await makeCamp(page, ev.id, { dates: ['2026-11-23', '2026-11-24'], projects: { '2026-11-23': ['Clay Creatures'], '2026-11-24': ['Glaze Day'] } });
e2e/day-off-camps.spec.js:183:    // Drop Tuesday from the camp: the projects map is written whole.
e2e/day-off-camps.spec.js:184:    r = await attempt(page, ({ Y, camp }) => saveDayOffCamp(Y, { ...camp, dates: ['2026-11-23'], projects: { '2026-11-23': ['Clay Creatures'] } }, camp), { Y, camp });
e2e/day-off-camps.spec.js:188:    expect(Object.keys(server.projects)).toEqual(['2026-11-23']);
e2e/day-off-camps.spec.js:208:      [{ dates: ['2026-11-23', '2026-11-30'], projects: { '2026-11-23': ['A'], '2026-11-30': ['B'] } }, 'not a day of'],
e2e/day-off-camps.spec.js:209:      [{ dates: ['2026-11-23'], projects: { '2026-11-23': ['A'], '2026-11-24': ['B'] } }, "which the camp doesn't run"],
e2e/day-off-camps.spec.js:210:      [{ dates: ['2026-11-23'], projects: { '2026-11-23': ['A', 'A'] } }, 'same project twice'],
e2e/day-off-camps.spec.js:234:    const renamed = { ...camp, projects: { ...camp.projects, '2026-11-23': ['Clay Critters', 'Open Studio'], '2026-11-25': ['Clay Critters'] } };
e2e/day-off-camps.spec.js:244:    const removed = { ...current, id: camp.id, projects: { '2026-11-23': { openStudio: 'Open Studio' }, '2026-11-24': current.projects['2026-11-24'], '2026-11-25': {} } };
e2e/day-off-camps.spec.js:253:  test('SDOC 10b: a camp edit that changes only its notes writes only notes — unchanged placements/projects are not rewritten, whatever order the server returns their keys in', async ({ page }) => {
e2e/day-off-camps.spec.js:310:    await makeCamp(page, ev.id, { title: 'TEST Wed camp', dates: ['2026-11-25'], projects: { '2026-11-25': ['Paint'] } });
e2e/day-off-camps.spec.js:318:  test('SDOC R2: a stale camp editor is refused instead of replacing a projects map another tab changed', async ({ page }) => {
e2e/day-off-camps.spec.js:320:    const camp = await makeCamp(page, ev.id, { dates: ['2026-11-23', '2026-11-24'], projects: { '2026-11-23': ['Clay Creatures'], '2026-11-24': ['Open Studio'] } });
e2e/day-off-camps.spec.js:323:    await page.evaluate(({ id }) => curriculumDb.collection('dayOffCamps_camps').doc(id).update({ projects: { '2026-11-23': { block1: 'Clay Creatures' }, '2026-11-24': { block1: 'Glaze Day' } } }), { id: camp.id });
e2e/day-off-camps.spec.js:324:    // This tab edits Monday's projects from its stale copy.
e2e/day-off-camps.spec.js:325:    const edited = { ...stale, projects: { '2026-11-23': ['Clay Critters'], '2026-11-24': ['Open Studio'] } };
e2e/day-off-camps.spec.js:329:    expect((await page.evaluate(({ id }) => __sdocT.read('camps', id), { id: camp.id })).projects['2026-11-24']).toEqual({ block1: 'Glaze Day' });
e2e/day-off-camps.spec.js:547:    const cell = (d, b) => page.locator(`#sdoc-camp-projects textarea[data-date="${d}"][data-block="${b}"]`);
e2e/day-off-camps.spec.js:548:    await expect(page.locator('#sdoc-camp-projects th')).toHaveText(['Block', 'Mon, Nov 23', 'Tue, Nov 24', 'Wed, Nov 25']);
e2e/day-off-camps.spec.js:580:    const camp = await makeCamp(page, ev.id, { projects: {} });
e2e/day-off-camps.spec.js:582:    expect(server.projects).toEqual({ '2026-11-23': {}, '2026-11-24': {}, '2026-11-25': {} });
e2e/day-off-camps.spec.js:586:    const r = await attempt(page, ({ Y, camp }) => saveDayOffCamp(Y, { ...camp, projects: { '2026-11-23': { block1: 'Clay Creatures', block2: '—', openStudio: 'Open Studio' } } }, camp), { Y, camp });
e2e/day-off-camps.spec.js:597:    await page.evaluate(({ Y, evId }) => __sdocT.write('camps', 'TEST_old_shape_camp', { yearKey: Y, eventId: evId, title: 'TEST Old', timeSlot: 'AM', timeLabel: '9–12', location: 'Tinker', placements: [{ studio: 'AG', ageRange: '5–7', capacity: 10 }], teachers: [], dates: ['2026-11-23'], projects: { '2026-11-23': ['Clay Creatures', 'Open Studio'] } }), { Y, evId: ev.id });
e2e/data-safety.spec.js:2428:// {projects:[...]} wrapper into saveFutureProjects() instead of the bare
e2e/data-safety.spec.js:2452:                // Snapshot data.projects by value, not by reference — it's the
e2e/data-safety.spec.js:2457:                window.__futureProjectsWrites.push({ ...data, projects: [...data.projects] });
e2e/data-safety.spec.js:2469:  test('the real curriculum/futureProjects write is a bare array, not the whole {projects:[...]} wrapper (R3-10)', async ({ browser }) => {
e2e/data-safety.spec.js:2479:      await page.evaluate((idea) => { currentFutureProjects = { projects: [idea] }; }, idea);
e2e/data-safety.spec.js:2489:      expect(Array.isArray(writes[0].projects)).toBe(true); // not a nested {projects:{projects:[...]}} wrapper
e2e/data-safety.spec.js:2490:      expect(writes[0].projects.length).toBe(0); // the pasted idea was removed
e2e/data-safety.spec.js:2492:      const cacheIsArray = await page.evaluate(() => Array.isArray(currentFutureProjects?.projects));
e2e/data-safety.spec.js:2514:      await page.evaluate((idea) => { currentFutureProjects = { projects: [idea] }; }, idea);
e2e/data-safety.spec.js:2528:      const ideaCount = await page.evaluate(() => currentFutureProjects.projects.length);
e2e/data-safety.spec.js:2549:      await page.evaluate((idea) => { currentFutureProjects = { projects: [idea] }; }, idea);
e2e/data-safety.spec.js:2560:      const ideaCount = await page.evaluate(() => currentFutureProjects.projects.length);
e2e/data-safety.spec.js:2592:        currentFutureProjects = { projects: [idea] };
e2e/data-safety.spec.js:2627:        currentFutureProjects = { projects: [idea] };
e2e/data-safety.spec.js:2660:        currentFutureProjects = { projects: [idea] };
e2e/data-safety.spec.js:2705:        currentFutureProjects = { projects: [idea] };
e2e/data-safety.spec.js:2740:        currentFutureProjects = { projects: [ideaA, ideaB] };
e2e/data-safety.spec.js:2745:      // (proving B's synchronous prefix, including its projects[1] → ideaB
e2e/data-safety.spec.js:2792:      const remainingTitles = await page.evaluate(() => currentFutureProjects.projects.map(p => p.title));
e2e/data-safety.spec.js:2802:      expect(writes[0].projects.map(p => p.title)).toEqual(['TEST Idea Race B']); // A's own write leaves B behind
e2e/data-safety.spec.js:2803:      expect(writes[1].projects.length).toBe(0); // B's own write, running after A's, ends the bank empty
e2e/data-safety.spec.js:5727:    // The summer view lists only projects with details written; the TEST
e2e/data-safety.spec.js:6653:        currentFutureProjects = { projects: [{ title: 'TEST idea', description: 'x' }] };
e2e/day-off-teacher.spec.js:23:  plannerCtx = await browser.newContext({ storageState: MANAGER_STATE_PATH });
e2e/day-off-teacher.spec.js:54:    projects: {
e2e/day-off-teacher.spec.js:64:    teachers: ['TESTteacher3'], dates: ['2026-11-23'], projects: { '2026-11-23': { block1: 'Canvas' } }, notes: '',
e2e/day-off-teacher.spec.js:82:  const ctx = await browser.newContext({ storageState: { cookies: [], origins: [] } });
e2e/day-off-teacher.spec.js:351:    const renamed = { ...camp, projects: { ...camp.projects, '2026-11-23': { block1: 'Clay Art', openStudio: 'Open Studio' }, '2026-11-25': { block1: 'Clay Art' } } };
e2e/day-off-teacher.spec.js:483:      placements: [{ studio: 'AG', ageRange: '5–7', capacity: 8 }], teachers: [], dates: ['2026-12-21'], projects: {}, notes: '',
e2e/day-off-teacher.spec.js:590:      projects: { '2026-11-23': { block1: `TEST ${evil}` } }, notes: '',
e2e/day-off-teacher.spec.js:740:      projects: { '2026-11-23': { block1: 'Canvas', block2: 'N/A', openStudio: 'none' }, '2026-11-24': { block1: '-' } }, notes: '',
e2e/emulators/test-server.js:16: * Started by Playwright's webServer (playwright.config.js). No dependencies.
e2e/emulators/seed.js:31:    [`http://${firestore.host}:${firestore.port}/emulator/v1/projects/${PROJECT_ID}/databases/(default)/documents`, 'Firestore'],
e2e/emulators/seed.js:32:    [`http://${auth.host}:${auth.port}/emulator/v1/projects/${PROJECT_ID}/accounts`, 'Auth'],
e2e/day-off-materials.spec.js:21:  plannerCtx = await browser.newContext({ storageState: MANAGER_STATE_PATH });
e2e/day-off-materials.spec.js:33:// A camp with two plannable projects (Clay Creatures, Glaze Day), headcount 24.
e2e/day-off-materials.spec.js:159:    const projects = { ...current.projects, '2026-11-25': { block1: 'Clay Creatures', block2: 'TEST Beads' } };
e2e/day-off-materials.spec.js:160:    r = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur), { Y, cur: current, projects });
e2e/day-off-materials.spec.js:173:    const projects = {
e2e/day-off-materials.spec.js:179:    let r = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur, { confirmOrphans: async () => { window.__asked = true; return true; } }), { Y, cur: current, projects });
e2e/day-off-materials.spec.js:195:    const clash = { ...current.projects, '2026-11-23': { block1: 'TEST Taken', block2: 'Open Studio' }, '2026-11-25': { block1: 'TEST Taken' } };
e2e/day-off-materials.spec.js:196:    r = await attempt(planner, ({ Y, cur, clash }) => saveDayOffCamp(Y, { ...cur, projects: clash }, cur), { Y, cur: current, clash });
e2e/day-off-materials.spec.js:210:    const projects = { ...current.projects, '2026-11-24': { openStudio: 'Open Studio' } };
e2e/day-off-materials.spec.js:211:    r = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur, { confirmOrphans: async () => true }), { Y, cur: current, projects });
e2e/day-off-materials.spec.js:289:      await curriculumDb.collection('dayOffCamps_camps').doc(id).update({ 'projects.2026-11-25': { block1: 'Clay Creatures', block2: 'TEST Late' } });
e2e/day-off-materials.spec.js:310:    const projects = { '2026-11-23': { block1: 'Clay Critters', block2: 'Open Studio' }, '2026-11-24': { block1: 'Glaze Day', block2: 'Open Studio' }, '2026-11-25': { block1: 'Clay Critters' } };
e2e/day-off-materials.spec.js:311:    const r = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur), { Y, cur: current, projects });
e2e/day-off-materials.spec.js:331:    const projects = { ...current.projects, '2026-11-24': { openStudio: 'Open Studio' } };
e2e/day-off-materials.spec.js:332:    r = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur, { confirmOrphans: async () => true }), { Y, cur: current, projects });
e2e/day-off-materials.spec.js:360:    // A sign-off bound to titles the user saw aborts when the camp's projects differ.
e2e/day-off-materials.spec.js:428:      dates: ['2026-11-23'], projects: { '2026-11-23': ['Canvas', 'Open Studio'] },
e2e/day-off-materials.spec.js:465:      // Camps in card order (AM before PM), projects in camp order.
e2e/day-off-materials.spec.js:597:    const camp = await makeCamp(planner, ev.id, { title: `TEST ${evil}`, projects: { '2026-11-23': [`TEST ${evil}`], '2026-11-24': ['Glaze Day'], '2026-11-25': ['Glaze Day'] } });
e2e/day-off-materials.spec.js:675:  test('M23: two projects whose lists share an item id — quick ticks on both land (the pending guard is per project record)', async () => {
e2e/day-off-materials.spec.js:934:  test('D7: switching projects never carries typed details over — including a failed read and a superseded read (success or failure)', async () => {
e2e/day-off-materials.spec.js:983:    const projects = { ...cur.projects, '2026-11-24': ['Glaze Art', 'Open Studio'] };
e2e/day-off-materials.spec.js:984:    const rr = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur), { Y, cur, projects });
e2e/day-off-materials.spec.js:1027:    const camp = await makeCamp(planner, ev.id, { projects: { '2026-11-23': { block1: 'Clay Creatures', block2: 'N/A', openStudio: 'n/a' }, '2026-11-24': { block1: 'none', block2: '-' }, '2026-11-25': { block1: 'Clay Creatures' } } });
e2e/day-off-materials.spec.js:1042:    const projects = { ...cur.projects, '2026-11-24': ['n/a', 'Open Studio'] };
e2e/day-off-materials.spec.js:1045:    const r = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur, { confirmOrphans: async (t) => { await window.__askedOrphans(JSON.stringify(t)); return false; } }), { Y, cur, projects });
e2e/day-off-materials.spec.js:1052:    const c2 = await makeCamp(planner, ev2.id, { dates: ['2026-12-21'], projects: { '2026-12-21': { block1: 'Clay Creatures', block2: 'n/a' } } });
e2e/day-off-materials.spec.js:1055:    const r2 = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur), { Y, cur: cur2, projects: { '2026-12-21': { block1: 'Clay Creatures', block2: 'Glaze Art' } } });
e2e/global-setup.js:16: *    `use.storageState` in playwright.config.js).
e2e/global-setup.js:56:module.exports = async function globalSetup(config) {
e2e/global-setup.js:57:  const baseURL = config.projects[0].use.baseURL;
e2e/global-setup.js:64:    await page.context().storageState({ path: AUTH_STATE_PATH, indexedDB: true });
e2e/global-setup.js:69:    await managerPage.context().storageState({ path: MANAGER_STATE_PATH, indexedDB: true });
     1	/**
     2	 * Classbook e2e — EMULATOR ONLY.
     3	 *
     4	 * Run with `npm test` (e2e/emulators/run.js), which starts the Auth,
     5	 * Firestore and Storage emulators with the studio-hub rules, seeds them, and
     6	 * exports FIRESTORE_EMULATOR_HOST / FIREBASE_AUTH_EMULATOR_HOST /
     7	 * FIREBASE_STORAGE_EMULATOR_HOST before Playwright starts. Nothing in this
     8	 * config defaults those: without them the test server refuses to start, the
     9	 * helpers throw, and global-setup aborts — a bare `npx playwright test`
    10	 * fails closed instead of reaching production.
    11	 */
    12	const { defineConfig, devices } = require('@playwright/test');
    13	const { HOST, TEST_SERVER_PORT } = require('./e2e/emulators/config');
    14	
    15	const baseURL = `http://${HOST}:${TEST_SERVER_PORT}`;
    16	
    17	module.exports = defineConfig({
    18	  testDir: './e2e',
    19	  // Preflight (emulators + emulator-mode page) and one sign-in per run — see
    20	  // e2e/global-setup.js. Every test's context then starts already signed in.
    21	  globalSetup: require.resolve('./e2e/global-setup.js'),
    22	  workers: 1,
    23	  timeout: 40_000,
    24	  retries: 0,
    25	  reporter: [['list'], ['html', { open: 'never' }]],
    26	
    27	  use: {
    28	    baseURL,
    29	    storageState: 'e2e/.auth/state.json',
    30	    headless: true,
    31	    screenshot: 'only-on-failure',
    32	    video: 'off',
    33	  },
    34	
    35	  webServer: {
    36	    // The ONLY server the suite loads the app from: it injects
    37	    // window.__USE_EMULATORS__ into every HTML response. reuseExistingServer
    38	    // stays false so a dev server that happens to be listening on this port
    39	    // (which would serve the PRODUCTION-connected app) is never picked up —
    40	    // Playwright reports the port as taken and stops.
    41	    command: 'node e2e/emulators/test-server.js',
    42	    url: baseURL,
    43	    reuseExistingServer: false,
    44	    timeout: 10_000,
    45	    stdout: 'pipe',
    46	    stderr: 'pipe',
    47	  },
    48	
    49	  projects: [
    50	    {
    51	      name: 'chromium',
    52	      use: { ...devices['Desktop Chrome'] },
    53	    },
    54	  ],
    55	});
     1	/**
     2	 * Runs once per Playwright run, after the webServer (the flag-injecting test
     3	 * server) is up and before any test.
     4	 *
     5	 * 1. Preflight — refuse to run unless everything points at the emulators:
     6	 *    the emulator env vars are set (requireEmulatorEnv), the Firestore and
     7	 *    Auth emulators answer on those addresses, and the page the test server
     8	 *    hands out actually carries window.__USE_EMULATORS__ for the demo
     9	 *    project. Any of these failing aborts the run before a single test
    10	 *    starts — there is no production fallback anywhere in this suite.
    11	 *
    12	 * 2. Signs in ONCE and snapshots the browser's authenticated session
    13	 *    (cookies + localStorage + IndexedDB — Firebase Auth keeps its session in
    14	 *    IndexedDB, which is why `indexedDB: true` is required). Every test's
    15	 *    browser context then starts from this snapshot already signed in (see
    16	 *    `use.storageState` in playwright.config.js).
    17	 *
    18	 *    Why: each test used to sign in through the app's login form — ~80
    19	 *    password sign-ins per full run from one machine — which tripped
    20	 *    Firebase's password-verification abuse throttle (auth/quota-exceeded)
    21	 *    part-way through a run against production. The Auth emulator has no
    22	 *    such throttle, but one sign-in per run is still faster and keeps the
    23	 *    tests' login() path identical to what they had. The snapshot file holds
    24	 *    emulator-only tokens for the seeded account — it is gitignored anyway.
    25	 */
    26	const { chromium } = require('@playwright/test');
    27	const { signInViaForm, AUTH_STATE_PATH, MANAGER_STATE_PATH } = require('./helpers/login');
    28	const { PROJECT_ID, requireEmulatorEnv, emulatorHostsFromEnv } = require('./emulators/config');
    29	
    30	async function preflight(baseURL) {
    31	  requireEmulatorEnv('global-setup');
    32	  const { firestore, auth } = emulatorHostsFromEnv();
    33	
    34	  const fsRes = await fetch(`http://${firestore.host}:${firestore.port}/`).catch(() => null);
    35	  if (!fsRes || (await fsRes.text()).trim() !== 'Ok') {
    36	    throw new Error(`[global-setup] Firestore emulator is not answering at ${firestore.host}:${firestore.port}. Run the suite with \`npm test\`.`);
    37	  }
    38	  const authRes = await fetch(`http://${auth.host}:${auth.port}/`).catch(() => null);
    39	  const authBody = authRes ? await authRes.json().catch(() => null) : null;
    40	  if (!authBody?.authEmulator?.ready) {
    41	    throw new Error(`[global-setup] Auth emulator is not answering at ${auth.host}:${auth.port}. Run the suite with \`npm test\`.`);
    42	  }
    43	
    44	  const pageRes = await fetch(`${baseURL}/`).catch(() => null);
    45	  const html = pageRes ? await pageRes.text() : '';
    46	  const marker = `window.__USE_EMULATORS__ = {"projectId":"${PROJECT_ID}"`;
    47	  if (!html.includes(marker)) {
    48	    throw new Error(
    49	      `[global-setup] the page served at ${baseURL} does not carry the emulator flag for ${PROJECT_ID}. ` +
    50	      `Something other than e2e/emulators/test-server.js is answering on that port — refusing to run.`
    51	    );
    52	  }
    53	  console.log(`[global-setup] preflight ok — emulators answering, app served in emulator mode (${PROJECT_ID})`);
    54	}
    55	
    56	module.exports = async function globalSetup(config) {
    57	  const baseURL = config.projects[0].use.baseURL;
    58	  await preflight(baseURL);
    59	
    60	  const browser = await chromium.launch();
    61	  const page = await browser.newPage({ baseURL });
    62	  try {
    63	    await signInViaForm(page);
    64	    await page.context().storageState({ path: AUTH_STATE_PATH, indexedDB: true });
    65	    console.log(`[global-setup] signed in once; session saved to ${AUTH_STATE_PATH}`);
    66	    // The seeded manager, in its own context, for manager-only specs.
    67	    const managerPage = await browser.newPage({ baseURL });
    68	    await signInViaForm(managerPage, 'manager');
    69	    await managerPage.context().storageState({ path: MANAGER_STATE_PATH, indexedDB: true });
    70	    console.log(`[global-setup] manager session saved to ${MANAGER_STATE_PATH}`);
    71	  } finally {
    72	    await browser.close();
    73	  }
    74	};
     1	/**
     2	 * Read/write helpers for test doc setup and verification.
     3	 *
     4	 * EMULATOR ONLY. This module connects the Firebase client SDK to the local
     5	 * Auth / Firestore / Storage emulators named by FIRESTORE_EMULATOR_HOST,
     6	 * FIREBASE_AUTH_EMULATOR_HOST and FIREBASE_STORAGE_EMULATOR_HOST (exported by
     7	 * `firebase emulators:exec`, see e2e/emulators/run.js) and refuses to do
     8	 * anything if they are missing. The app it talks to is the `demo-` project
     9	 * from e2e/emulators/config.js — a project id Firebase guarantees has no
    10	 * real backend — so there is no production configuration in this file to
    11	 * fall back to, by design.
    12	 *
    13	 * It signs in as the account e2e/emulators/seed.js created in the Auth
    14	 * emulator (the same one e2e/helpers/login.js uses in the browser), so every
    15	 * read/write here goes through the real studio-hub Firestore rules exactly
    16	 * as a signed-in user's would — this does NOT bypass rules.
    17	 *
    18	 * History: until Sep 2026 this file signed into PRODUCTION (tinker-hq-apps)
    19	 * with credentials from .env.test and wrote TEST_-prefixed docs into live
    20	 * collections; before Aug 2026 it minted a production token from the local
    21	 * Firebase CLI login. Neither path exists any more — do not reintroduce a
    22	 * production config or an env-supplied credential here.
    23	 */
    24	
    25	const { initializeApp, getApps } = require('firebase/app');
    26	const { getAuth, connectAuthEmulator, signInWithEmailAndPassword } = require('firebase/auth');
    27	const { getFirestore, connectFirestoreEmulator, doc, getDocFromServer, setDoc, updateDoc, deleteDoc, deleteField, arrayUnion } = require('firebase/firestore');
    28	const { getStorage, connectStorageEmulator, ref: storageRef, deleteObject } = require('firebase/storage');
    29	const { PROJECT_ID, TEST_ACCOUNT, requireEmulatorEnv, emulatorHostsFromEnv } = require('../emulators/config');
    30	
    31	// The Storage REST API path is identical on the emulator and in production
    32	// (`…/v0/b/<bucket>/o…`), so this one glob lets the spec intercept uploads
    33	// and deletes without naming a host. Exported for page.route() in the spec.
    34	const STORAGE_API_GLOB = '**/v0/b/**';
    35	
    36	let dbPromise;
    37	
    38	// Connect to the emulators and sign in once per test run; reuse the
    39	// authenticated Firestore instance after that.
    40	function getDb() {
    41	  if (!dbPromise) {
    42	    dbPromise = (async () => {
    43	      requireEmulatorEnv('e2e/helpers/firestore.js');
    44	      const { firestore, auth: authHost, storage } = emulatorHostsFromEnv();
    45	      const app = initializeApp({
    46	        apiKey: 'demo-api-key',
    47	        authDomain: `${PROJECT_ID}.firebaseapp.com`,
    48	        projectId: PROJECT_ID,
    49	        storageBucket: `${PROJECT_ID}.appspot.com`,
    50	        appId: 'demo-app-id',
    51	      });
    52	      const auth = getAuth(app);
    53	      connectAuthEmulator(auth, `http://${authHost.host}:${authHost.port}`, { disableWarnings: true });
    54	      const db = getFirestore(app);
    55	      connectFirestoreEmulator(db, firestore.host, firestore.port);
    56	      connectStorageEmulator(getStorage(app), storage.host, storage.port);
    57	      await signInWithEmailAndPassword(auth, TEST_ACCOUNT.email, TEST_ACCOUNT.password);
    58	      return db;
    59	    })();
    60	  }
    61	  return dbPromise;
    62	}
    63	
    64	// ─── TEST-namespace guard for every summer-collection helper ───
    65	//
    66	// The TEST account has appAccess('classbook') under Firestore rules (role
    67	// staff), which is enough to write ANY document in the summer collections —
    68	// a typo in a helper call would
    69	// overwrite or delete a real teacher's doc with no undo. Every summer helper
    70	// (existing and new) refuses an ID outside the TEST namespace instead of
    71	// trusting the caller, mirroring TEST_SEMESTER_KEY below (camp seasons
    72	// Phase 0, plan-review round 1). The legacy ID must start with one of the two
    73	// fixture teacher segments — exactly `TEST|||…` or `TEST_OTHER|||…`, an
    74	// allowlist, not a pattern — after an optional `season-YYYY|||` prefix (the
    75	// cross-app doc-ID contract for non-2026 seasons, which the Phase 1
    76	// two-season canaries will use). Add a segment here deliberately if a test
    77	// ever needs a third fixture teacher.
    78	const TEST_SUMMER_DOC_ID = /^(?:season-\d{4}\|\|\|)?TEST(?:_OTHER)?\|\|\|/;
    79	function assertTestSummerDocId(helperName, docId) {
    80	  if (typeof docId !== 'string' || !TEST_SUMMER_DOC_ID.test(docId)) {
    81	    throw new Error(`${helperName} refused non-TEST summer doc ID: "${docId}"`);
    82	  }
    83	}
    84	
    85	// ─── Summer shape: summerCamps_lessonData/{lessonKey} (one document per lesson) ───
    86	
    87	// Every summer document in production carries its season, and camp-seasons
    88	// Phase 1 filters every read by it — an unstamped fixture is invisible to the
    89	// app, exactly as it would be in production. The season is derived from the
    90	// document ID by the same rule the app uses (a `season-YYYY|||` prefix, else
    91	// 2026), so a fixture and the app can never disagree. An explicit `season` in
    92	// `fields` still wins, for tests that deliberately write a mismatch.
    93	function seasonOfTestDocId(docId) {
    94	  const m = /^season-(\d{4})\|\|\|/.exec(docId);
    95	  return m ? m[1] : '2026';
    96	}
    97	
    98	async function writeTestDoc(docId, fields) {
    99	  assertTestSummerDocId('writeTestDoc', docId);
   100	  const db = await getDb();
   101	  await setDoc(doc(db, 'summerCamps_lessonData', docId), { season: seasonOfTestDocId(docId), ...fields }, { merge: true });
   102	}
   103	
   104	async function readTestDoc(docId) {
   105	  assertTestSummerDocId('readTestDoc', docId);
   106	  const db = await getDb();
   107	  // Forced server read: a default getDoc() can resolve from local cache, which
   108	  // would report a write as "confirmed" even if it never reached the server —
   109	  // the same footgun flagged for the app's own Phase 3 read-back verification.
   110	  const snap = await getDocFromServer(doc(db, 'summerCamps_lessonData', docId));
   111	  return snap.exists() ? snap.data() : {};
   112	}
   113	
   114	async function deleteTestDoc(docId) {
   115	  assertTestSummerDocId('deleteTestDoc', docId);
   116	  const db = await getDb();
   117	  await deleteDoc(doc(db, 'summerCamps_lessonData', docId));
   118	}
   119	
   120	// ─── summerCamps_campComplete/{teacher|||campName} and
   280	async function deleteTestCutProjectsField(semesterKey) {
   281	  const db = await getDb();
   282	  await updateDoc(CUT_PROJECTS_DOC(db), { [semesterKey]: deleteField() });
   283	}
   284	
   285	// ─── Storage: remove the TEST-path objects a test uploaded to the emulator ───
   286	// Deletes are rules-enforced (Storage rules allow a signed-in delete since
   287	// Sep 20, 2026); only paths under the TEST prefixes are ever passed here.
   288	async function deleteTestStorageObjects(paths) {
   289	  if (!paths || paths.length === 0) return;
   290	  await getDb(); // signs in
   291	  const storage = getStorage(getApps()[0]);
   292	  for (const p of paths) {
   293	    // The same TEST namespace as the Firestore helpers, after an optional
   294	    // `season-YYYY|||` prefix — a non-2026 season's photos live in their own
   295	    // folder (camp seasons Phase 1, 1.5).
   296	    if (!/^(summerCamps\/(season-\d{4}\|\|\|)?TEST(_OTHER)?\|\|\||curriculum\/TEST_DATA_SAFETY_semester\/)/.test(p)) {
   297	      throw new Error('Refusing to delete a non-TEST Storage path: ' + p);
   298	    }
   299	    try { await deleteObject(storageRef(storage, p)); }
   300	    catch (e) { if (e.code !== 'storage/object-not-found') throw e; }
   301	  }
   302	}
   303	
   304	module.exports = {
   305	  STORAGE_API_GLOB,
   306	  deleteTestStorageObjects,
   307	  writeTestDoc, readTestDoc, deleteTestDoc,
   308	  readTestCampComplete, writeTestCampComplete, readTestPrepHelp, writeTestPrepHelp, deleteField,
   309	  writeTestLesson, writeTestLessonFields, readTestLesson, deleteTestLessonFields, deleteTestLesson,
   310	  readTestSemesterLessons, deleteTestSemesterLessons,
   311	  readTestCutProjects, concurrentlyAppendCutProject, deleteTestCutProjectsField,
   312	};
     1	/**
     2	 * Puts the page on the app, signed in as the seeded emulator test account.
     3	 *
     4	 * Normal path (since Sep 2026): the browser context already carries the
     5	 * session captured by e2e/global-setup.js, so loading '/' resolves
     6	 * onAuthStateChanged with the user, the auth guard never appears, and we
     7	 * just wait for the header badge. One password sign-in per run, not one per
     8	 * test — see global-setup.js for why that matters.
     9	 *
    10	 * Fallback: if the guard DOES appear (state file missing, session expired,
    11	 * or a context created without the storage state), sign in through the form
    12	 * exactly as before, and say so on stdout so a run that quietly regressed to
    13	 * per-test sign-ins is visible in the report.
    14	 *
    15	 * Emulator guard (every test goes through here, so this is the per-test
    16	 * choke point): before the page loads, every request to a Firebase
    17	 * production host is aborted at the network layer; after it loads, the page
    18	 * must report that it initialised against the demo project through
    19	 * window.__USE_EMULATORS__ — otherwise login() throws and the test never
    20	 * gets to touch data. Credentials are the fixed emulator-only account from
    21	 * e2e/emulators/config.js; there is no env-supplied password any more.
    22	 *
    23	 * Note: The Classbook uses #header-user (not #user-name like the Playbook).
    24	 */
    25	const path = require('path');
    26	const { PROJECT_ID, TEST_ACCOUNT, FIXTURE_USER_PASSWORD } = require('../emulators/config');
    27	
    28	const AUTH_STATE_PATH = path.join(__dirname, '..', '.auth', 'state.json');
    29	// A second saved session for the seeded MANAGER (e2e-manager-uid). Specs that
    30	// need manager-only behaviour (unpublished semesters, the SDOC collections'
    31	// admin writes) use it with test.use({ storageState: MANAGER_STATE_PATH }).
    32	const MANAGER_STATE_PATH = path.join(__dirname, '..', '.auth', 'manager-state.json');
    33	
    34	// Anything that would carry a Firebase call to Google's real backends.
    35	// Matched against the full request URL so Playwright only intercepts these
    36	// (fonts.googleapis.com and the SDK on www.gstatic.com are untouched).
    37	const PRODUCTION_FIREBASE_URL = /^https?:\/\/([^/]+\.)?((firestore|identitytoolkit|securetoken|firebasestorage|firebaseinstallations|firebaseremoteconfig|firebase)\.googleapis\.com|firebaseio\.com|firebaseapp\.com)(:\d+)?\//i;
    38	
    39	function credsFor(role = 'admin') {
    40	  // One seeded account for now; the role argument is kept so call sites read
    41	  // the same as before and a teacher-role account can be added later.
    42	  const creds = {
    43	    admin: { email: TEST_ACCOUNT.email, password: TEST_ACCOUNT.password },
    44	    manager: { email: 'e2e-manager@classbook.test', password: FIXTURE_USER_PASSWORD },
    45	    teacher: { email: 'e2e-teacher@classbook.test', password: FIXTURE_USER_PASSWORD },
    46	    test:  { email: TEST_ACCOUNT.email, password: TEST_ACCOUNT.password },
    47	  };
    48	  return creds[role] || creds.admin;
    49	}
    50	
    51	const headerPopulated = () => (document.getElementById('header-user')?.textContent || '').trim().length > 0;
    52	
    53	// Network-layer guard: even if the page somehow initialised against the wrong
    54	// project, nothing can reach production from this page.
    55	async function blockProductionFirebase(page) {
    56	  await page.route(PRODUCTION_FIREBASE_URL, route => {
    57	    console.error(`[login] BLOCKED request to production Firebase host: ${route.request().url()}`);
    58	    return route.abort('blockedbyclient');
    59	  });
    60	}
    61	
    62	// Page-level guard: the served HTML must have carried the emulator flag and
    63	// the app must have initialised against the demo project.
    64	async function assertEmulatorMode(page) {
    65	  // requireAuth() initialises Firebase on DOMContentLoaded, so this normally
    66	  // resolves immediately after goto(); the wait only covers a slow first load.
    67	  await page.waitForFunction(() => typeof firebase !== 'undefined' && firebase.apps?.length > 0, { timeout: 10_000 }).catch(() => {});
    68	  const state = await page.evaluate(() => ({
    69	    flag: window.__USE_EMULATORS__?.projectId || null,
    70	    project: (typeof firebase !== 'undefined' && firebase.apps?.length) ? firebase.app().options.projectId : null,
    71	  }));
    72	  if (state.flag !== PROJECT_ID || state.project !== PROJECT_ID) {
    73	    throw new Error(
    74	      `[login] page is NOT in emulator mode (flag=${state.flag}, firebase project=${state.project}, expected ${PROJECT_ID}). ` +
    75	      `Refusing to continue — the suite must never touch production. Run it with \`npm test\`.`
    76	    );
    77	  }
    78	}
    79	
    80	// The real form sign-in. Used by global-setup (once per run) and as login()'s fallback.
    81	async function signInViaForm(page, role = 'admin') {
    82	  const { email, password } = credsFor(role);
    83	  await blockProductionFirebase(page);
    84	  await page.goto('/');
    85	  await assertEmulatorMode(page);
    86	  await page.waitForSelector('#auth-guard', { state: 'visible', timeout: 10_000 });
    87	  await page.fill('#auth-email', email);
    88	  await page.fill('#auth-password', password);
    89	  await page.click('#auth-guard-form button[type="submit"]');
    90	  // Wait until header-user badge is populated (confirms auth + Firestore load)
    91	  await page.waitForFunction(headerPopulated, { timeout: 20_000 });
    92	}
    93	
    94	async function login(page, role = 'admin') {
    95	  await blockProductionFirebase(page);
    96	  await page.goto('/');
    97	  await assertEmulatorMode(page);
    98	  // The guard starts hidden and is shown ONLY when Firebase reports no user,
    99	  // so exactly one of these resolves: header (already signed in) or guard.
   100	  const outcome = await Promise.race([
   101	    page.waitForFunction(headerPopulated, { timeout: 20_000 }).then(() => 'signed-in'),
   102	    page.waitForSelector('#auth-guard', { state: 'visible', timeout: 20_000 }).then(() => 'guard'),
   103	  ]);
   104	  if (outcome === 'signed-in') return;
   105	  console.warn('[login] auth guard appeared — storage state not in effect, falling back to a form sign-in');
   106	  const { email, password } = credsFor(role);
   107	  await page.fill('#auth-email', email);
   108	  await page.fill('#auth-password', password);
   109	  await page.click('#auth-guard-form button[type="submit"]');
   110	  await page.waitForFunction(headerPopulated, { timeout: 20_000 });
   111	}
   112	
   113	module.exports = { login, signInViaForm, AUTH_STATE_PATH, MANAGER_STATE_PATH, PRODUCTION_FIREBASE_URL };
     1	{
     2	  "appData": {
     3	    "activeSemester": "spring-2026",
     4	    "semesters": {
     5	      "spring-2026": {
     6	        "name": "Spring 2026",
     7	        "startDate": "2026-01-12",
     8	        "numWeeks": 16,
     9	        "breakWeeks": [
    10	          10
    11	        ],
    12	        "closureDates": [],
    13	        "published": true,
    14	        "dataSource": "firestore",
    15	        "teacherNames": [
    16	          "Fixture Teacher",
    17	          "Second Fixture"
    18	        ],
    19	        "classRoster": {
    20	          "Fixture Class": {
    21	            "teacher": "Fixture Teacher",
    22	            "day": "Monday",
    23	            "time": "4:00 PM",
    24	            "enrollment": 8,
    25	            "waitlist": 0,
    26	            "sessions": 15
    27	          },
    28	          "Second Class": {
    29	            "teacher": "Second Fixture",
    30	            "day": "Thursday",
    31	            "time": "5:30 PM",
    32	            "enrollment": 6,
    33	            "waitlist": 1,
    34	            "sessions": 15
    35	          }
    36	        }
    37	      },
    38	      "summer-2026": {
    39	        "name": "Summer 2026",
    40	        "semesterType": "summer-camp",
    41	        "startDate": "2026-05-26",
    42	        "numWeeks": 11,
    43	        "breakWeeks": [
    44	          6
    45	        ],
    46	        "published": false,
    47	        "dataSource": "summer-camp-app",
    48	        "teacherNames": [],
    49	        "campRoster": {},
    50	        "classRoster": {}
    51	      }
    52	    },
    53	    "teacherMappings": {
    54	      "e2e-teacher-uid": "Fixture Teacher"
    55	    },
    56	    "lastUpdated": "2026-09-01T12:00:00.000Z",
    57	    "lastUpdatedBy": "E2E Admin"
    58	  },
    59	  "lessonData": {
    60	    "spring-2026": {
    61	      "fixtureteacher-fixtureclass-1": {
    62	        "teacher": "Fixture Teacher",
    63	        "className": "Fixture Class",
    64	        "weekNum": 1,
    65	        "weekDate": "2026-01-12",
    66	        "classSize": 8,
    67	        "projectTitle": "Fixture Watercolor Skies",
    68	        "shortDetails": "Wet-on-wet sky studies",
    69	        "inspoLink": "",
    70	        "introPitch": "Fixture intro pitch for week 1",
    71	        "processStep1": "Fixture step 1",
    72	        "processStep2": "Fixture step 2",
    73	        "processStep3": "",
    74	        "processStep4": "",
    75	        "closure": "Fixture closure",
    76	        "materials": "Watercolor paper\nBrushes",
    77	        "materialsList": [],
    78	        "dayOfMaterials": "",
    79	        "teacherNotes": "",
    80	        "adminResponse": "",
    81	        "qaThread": [],
    82	        "planComplete": false,
    83	        "lastEditedBy": "Fixture Teacher",
    84	        "lastEditedAt": "2026-01-10T18:00:00.000Z"
    85	      },
    86	      "fixtureteacher-fixtureclass-2": {
    87	        "teacher": "Fixture Teacher",
    88	        "className": "Fixture Class",
    89	        "weekNum": 2,
    90	        "weekDate": "2026-01-19",
    91	        "classSize": 8,
    92	        "projectTitle": "",
    93	        "shortDetails": "",
    94	        "inspoLink": "",
    95	        "introPitch": "",
    96	        "processStep1": "",
    97	        "processStep2": "",
    98	        "processStep3": "",
    99	        "processStep4": "",
   100	        "closure": "",
   101	        "materials": "",
   102	        "dayOfMaterials": ""
   103	      },
   104	      "secondfixture-secondclass-1": {
   105	        "teacher": "Second Fixture",
   106	        "className": "Second Class",
   107	        "weekNum": 1,
   108	        "weekDate": "2026-01-15",
   109	        "classSize": 6,
   110	        "projectTitle": "Fixture Clay Creatures",
   111	        "shortDetails": "",
   112	        "inspoLink": "",
   113	        "introPitch": "Fixture intro for the second class",
   114	        "processStep1": "Fixture step 1",
   115	        "processStep2": "",
   116	        "processStep3": "",
   117	        "processStep4": "",
   118	        "closure": "",
   119	        "materials": "Air-dry clay",
   120	        "dayOfMaterials": "",
   121	        "qaThread": [],
   122	        "planComplete": true,
   123	        "lastEditedBy": "Second Fixture",
   124	        "lastEditedAt": "2026-01-14T18:00:00.000Z"
   125	      }
   126	    },
   127	    "lastUpdated": "2026-09-01T12:00:00.000Z",
   128	    "lastUpdatedBy": "E2E Admin"
   129	  },
   130	  "cutProjects": {
   131	    "spring-2026": [
   132	      {
   133	        "projectTitle": "Fixture Cut Project",
   134	        "shortDetails": "Cut from week 4 for time",
   135	        "inspoLink": "",
   136	        "introPitch": "Fixture cut intro",
   137	        "processStep1": "Fixture step 1",
   138	        "processStep2": "",
   139	        "processStep3": "",
   140	        "processStep4": "",
   141	        "closure": "",
   142	        "materials": "",
   143	        "dayOfMaterials": "",
   144	        "teacherNotes": "",
   145	        "adminResponse": "",
   146	        "publishToPrep": false,
   147	        "status": "cut",
   148	        "originalTeacher": "Fixture Teacher",
   149	        "originalClassName": "Fixture Class",
   150	        "originalWeek": 4,
   151	        "cutDate": "2026-02-01T12:00:00.000Z",
   152	        "cutBy": "E2E Admin"
   153	      }
   154	    ],
   155	    "lastUpdated": "2026-09-01T12:00:00.000Z",
   156	    "lastUpdatedBy": "E2E Admin"
   157	  },
   158	  "changeLog": {
   159	    "spring-2026": [
   160	      {

exec
/bin/zsh -lc "nl -ba playwright.config.js | sed -n '17,90p'
nl -ba e2e/global-setup.js | sed -n '50,90p'
nl -ba js/app.js | sed -n '90,215p;290,370p;4470,4640p;10650,10730p'
nl -ba index.html | sed -n '390,425p;500,525p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
    17	module.exports = defineConfig({
    18	  testDir: './e2e',
    19	  // Preflight (emulators + emulator-mode page) and one sign-in per run — see
    20	  // e2e/global-setup.js. Every test's context then starts already signed in.
    21	  globalSetup: require.resolve('./e2e/global-setup.js'),
    22	  workers: 1,
    23	  timeout: 40_000,
    24	  retries: 0,
    25	  reporter: [['list'], ['html', { open: 'never' }]],
    26	
    27	  use: {
    28	    baseURL,
    29	    storageState: 'e2e/.auth/state.json',
    30	    headless: true,
    31	    screenshot: 'only-on-failure',
    32	    video: 'off',
    33	  },
    34	
    35	  webServer: {
    36	    // The ONLY server the suite loads the app from: it injects
    37	    // window.__USE_EMULATORS__ into every HTML response. reuseExistingServer
    38	    // stays false so a dev server that happens to be listening on this port
    39	    // (which would serve the PRODUCTION-connected app) is never picked up —
    40	    // Playwright reports the port as taken and stops.
    41	    command: 'node e2e/emulators/test-server.js',
    42	    url: baseURL,
    43	    reuseExistingServer: false,
    44	    timeout: 10_000,
    45	    stdout: 'pipe',
    46	    stderr: 'pipe',
    47	  },
    48	
    49	  projects: [
    50	    {
    51	      name: 'chromium',
    52	      use: { ...devices['Desktop Chrome'] },
    53	    },
    54	  ],
    55	});
    50	      `Something other than e2e/emulators/test-server.js is answering on that port — refusing to run.`
    51	    );
    52	  }
    53	  console.log(`[global-setup] preflight ok — emulators answering, app served in emulator mode (${PROJECT_ID})`);
    54	}
    55	
    56	module.exports = async function globalSetup(config) {
    57	  const baseURL = config.projects[0].use.baseURL;
    58	  await preflight(baseURL);
    59	
    60	  const browser = await chromium.launch();
    61	  const page = await browser.newPage({ baseURL });
    62	  try {
    63	    await signInViaForm(page);
    64	    await page.context().storageState({ path: AUTH_STATE_PATH, indexedDB: true });
    65	    console.log(`[global-setup] signed in once; session saved to ${AUTH_STATE_PATH}`);
    66	    // The seeded manager, in its own context, for manager-only specs.
    67	    const managerPage = await browser.newPage({ baseURL });
    68	    await signInViaForm(managerPage, 'manager');
    69	    await managerPage.context().storageState({ path: MANAGER_STATE_PATH, indexedDB: true });
    70	    console.log(`[global-setup] manager session saved to ${MANAGER_STATE_PATH}`);
    71	  } finally {
    72	    await browser.close();
    73	  }
    74	};
    90	  // Show user name
    91	  if (userSpan && user) {
    92	    userSpan.textContent = user.name || user.email;
    93	  }
    94	}
    95	
    96	function setGlobalSemester(key) {
    97	  if (!currentConfig?.semesters?.[key]) return;
    98	
    99	  globalSemesterKey = key;
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
   211	      document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
   212	      document.getElementById(tabId)?.classList.add('active');
   213	
   214	      if (tabId === 'teacher-view') {
   215	        initTeacherView();
   290	
   291	function hasPrepAccess() {
   292	  const user = getAuthUser();
   293	  if (!user) return false;
   294	  return user.role === 'prep' || hasCurriculumAdminAccess();
   295	}
   296	
   297	// Hide/show Curriculum Admin tab based on semester type for non-manager users.
   298	// Called on initial load and on semester change.
   299	function updateCurriculumAdminTab() {
   300	  const user = getAuthUser();
   301	  if (!user || user.role === 'admin' || user.role === 'manager') return; // manager+ always see it
   302	  if (!hasCurriculumAdminAccess()) return; // plain classbook teachers never had it
   303	
   304	  const semKey = getActiveSemesterKey();
   305	  const semester = currentConfig?.semesters?.[semKey];
   306	  const caTab = document.querySelector('.tab-btn[data-tab="curriculum-admin"]');
   307	  if (!caTab) return;
   308	
   309	  if (semester?.semesterType === 'summer-camp') {
   310	    caTab.style.display = 'none';
   311	    if (document.querySelector('.tab-btn.active')?.dataset.tab === 'curriculum-admin') {
   312	      switchTab('teacher-view');
   313	    }
   314	  } else {
   315	    caTab.style.display = '';
   316	  }
   317	}
   318	
   319	function setupRoleAccess() {
   320	  const user = getAuthUser();
   321	  if (!user) return;
   322	
   323	  // Manager+: full access to all tabs including Settings
   324	  if (user.role === 'admin' || user.role === 'manager') return;
   325	
   326	  // classbook-admin / curriculum-admin / prep role: all tabs EXCEPT Settings
   327	  // Settings is manager+ only — classbook admins can't change semester config
   328	  if (hasCurriculumAdminAccess() || hasPrepAccess()) {
   329	    document.querySelector('.tab-btn[data-tab="settings"]')?.style.setProperty('display', 'none');
   330	    updateCurriculumAdminTab(); // Hide Curriculum Admin on summer semesters
   331	    return;
   332	  }
   333	
   334	  // Otherwise: Teacher View only (read-only mode)
   335	  // Hide admin tabs (Curriculum Admin, Settings) and Prep Dashboard
   336	  document.body.classList.add('read-only');
   337	  document.body.classList.add('teacher-view-only');
   338	
   339	  // Switch active tab to Teacher View since Curriculum Admin is hidden for teachers
   340	  switchTab('teacher-view');
   341	
   342	  // Hide Back to HQ link for non-admin users
   343	  const hqLink = document.getElementById('back-to-hq-link');
   344	  if (hqLink) hqLink.style.display = 'none';
   345	}
   346	
   347	// ─── Footer ─────────────────────────────────────────
   348	
   349	function setupFooter() {
   350	  document.getElementById('help-link')?.addEventListener('click', (e) => {
   351	    e.preventDefault();
   352	    document.getElementById('help-modal').classList.add('open');
   353	  });
   354	  document.getElementById('help-close')?.addEventListener('click', () => {
   355	    document.getElementById('help-modal').classList.remove('open');
   356	  });
   357	
   358	  // Settings link switches to Settings tab — through the tab button, so it gets
   359	  // the same form refresh as clicking the tab (review: it used to bypass it).
   360	  document.getElementById('settings-link')?.addEventListener('click', (e) => {
   361	    e.preventDefault();
   362	    switchTab('settings');
   363	  });
   364	
   365	  document.getElementById('footer-sign-out')?.addEventListener('click', (e) => {
   366	    e.preventDefault();
   367	    if (confirm('Sign out?')) authSignOut();
   368	  });
   369	
   370	  document.querySelectorAll('.simple-modal-overlay').forEach(overlay => {
  4470	// ─── End Summer CA Views ──────────────────────────────────────────────────────
  4471	
  4472	function renderSemesterSelector() {
  4473	  const bar = document.getElementById('ca-semester-bar');
  4474	  const select = document.getElementById('ca-semester-select');
  4475	  const publishGroup = document.getElementById('ca-semester-publish-group');
  4476	  if (!bar || !select || !currentConfig?.semesters) return;
  4477	
  4478	  const semesters = currentConfig.semesters;
  4479	  const keys = Object.keys(semesters);
  4480	
  4481	  // Only show bar if user is admin/manager
  4482	  const user = getAuthUser();
  4483	  if (!user || !['admin', 'manager'].includes(user.role)) { bar.style.display = 'none'; return; }
  4484	
  4485	  bar.style.display = 'flex';
  4486	  const currentKey = getAdminSemKey();
  4487	
  4488	  // Build dropdown options
  4489	  let optionsHtml = '';
  4490	  for (const key of keys) {
  4491	    const sem = semesters[key];
  4492	    const isActive = key === currentConfig.activeSemester;
  4493	    const isPublished = sem.published !== false;
  4494	    const label = sem.name + (isActive ? ' (active)' : '') + (!isPublished ? ' [draft]' : '');
  4495	    optionsHtml += `<option value="${escAttr(key)}" ${key === currentKey ? 'selected' : ''}>${escHtml(label)}</option>`;
  4496	  }
  4497	  select.innerHTML = optionsHtml;
  4498	  select.onchange = () => setGlobalSemester(select.value);
  4499	
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
 10650	      }
 10651	    });
 10652	  });
 10653	}
 10654	
 10655	// ═════════════════════════════════════════════════════
 10656	// SETTINGS
 10657	// ═════════════════════════════════════════════════════
 10658	
 10659	function getSettingsSemKey() {
 10660	  // Now uses global semester instead of per-tab selection
 10661	  return getActiveSemesterKey();
 10662	}
 10663	
 10664	let settingsTeacherPoolAtLoad = { semKey: null, names: [] };
 10665	// Which semester the Settings form was last drawn for. Save writes to the
 10666	// HEADER's semester, so the two must match: the form used to redraw only on a
 10667	// semester change made while on Settings, and after switching semesters
 10668	// elsewhere a Save wrote one semester's values onto another (Sep 24).
 10669	let settingsFormSemKey = null;
 10670	
 10671	// Redraw only when the header's semester differs from the form's — returning
 10672	// to the tab for the same semester keeps any unsaved edits.
 10673	function ensureSettingsFormMatchesHeader() {
 10674	  if (settingsFormSemKey !== getSettingsSemKey()) loadSettingsForm();
 10675	}
 10676	
 10677	function loadSettingsForm() {
 10678	  const config = currentConfig || getDefaultConfig();
 10679	
 10680	  // Build semester selector
 10681	  const selectEl = document.getElementById('settings-semester-select');
 10682	  if (selectEl) {
 10683	    const keys = Object.keys(config.semesters || {});
 10684	    const currentKey = getSettingsSemKey();
 10685	    selectEl.innerHTML = keys.map(k => {
 10686	      const s = config.semesters[k];
 10687	      const label = s.name + (k === config.activeSemester ? ' (active)' : '');
 10688	      return `<option value="${escAttr(k)}" ${k === currentKey ? 'selected' : ''}>${escHtml(label)}</option>`;
 10689	    }).join('');
 10690	  }
 10691	
 10692	  const semKey = getSettingsSemKey();
 10693	  const semester = config.semesters?.[semKey] || {};
 10694	  // The pool as this form found it — the × button edits currentConfig's list
 10695	  // in place, so saveSettings() cannot use that to see what was removed.
 10696	  settingsTeacherPoolAtLoad = { semKey, names: [...(semester.teacherNames || [])] };
 10697	  settingsFormSemKey = semKey;
 10698	
 10699	  // Publish toggle
 10700	  const publishGroup = document.getElementById('settings-semester-publish-group');
 10701	  if (publishGroup) {
 10702	    const isActive = semKey === config.activeSemester;
 10703	    const isPublished = semester.published !== false;
 10704	    if (isActive) {
 10705	      publishGroup.innerHTML = '<span class="ca-sem-active-badge">Active Semester — always visible to teachers</span>';
 10706	    } else {
 10707	      publishGroup.innerHTML = `
 10708	        <label class="ca-publish-toggle">
 10709	          <input type="checkbox" ${isPublished ? 'checked' : ''} onchange="toggleSemesterPublish('${escAttr(semKey)}', this.checked)">
 10710	          Published (visible to teachers)
 10711	        </label>
 10712	        ${!isPublished ? '<span class="ca-sem-unpublished-badge" style="margin-left:8px">Draft</span>' : ''}
 10713	      `;
 10714	    }
 10715	  }
 10716	
 10717	  const el = (id) => document.getElementById(id);
 10718	  if (el('settings-semester-name')) el('settings-semester-name').value = semester.name || '';
 10719	  if (el('settings-start-date')) el('settings-start-date').value = semester.startDate || '';
 10720	  if (el('settings-num-weeks')) el('settings-num-weeks').value = semester.numWeeks || 16;
 10721	  if (el('settings-break-weeks')) el('settings-break-weeks').value = (semester.breakWeeks || []).join(', ');
 10722	  if (el('settings-closure-dates')) el('settings-closure-dates').value = formatClosureDates(semester.closureDates || []);
 10723	
 10724	  // Class Roster — auto-populate from defaults if empty
 10725	  let roster = semester.classRoster;
 10726	  if (!roster || Object.keys(roster).length === 0) {
 10727	    roster = JSON.parse(JSON.stringify(DEFAULT_CLASS_ROSTER));
 10728	  }
 10729	  renderClassRosterTable(roster);
 10730	
   390	
   391	  <!-- ═══════════════ Settings Panel ═══════════════ -->
   392	  <div class="panel" id="settings">
   393	    <main class="main-content">
   394	      <!-- Data Diagnostic -->
   395	      <section class="settings-panel diag-panel">
   396	        <h2 class="settings-panel-title">Data Diagnostic</h2>
   397	        <p class="settings-panel-desc">Scan imported lesson data for issues: duplicate content in wrong slots, mismatched rows from copy-paste errors, and other red flags. Runs across all teachers.</p>
   398	        <div class="import-controls">
   399	          <button class="btn-secondary" onclick="runDataDiagnostic()">Run Diagnostic</button>
   400	        </div>
   401	        <div id="diag-results" style="display: none;"></div>
   402	      </section>
   403	
   404	      <!-- Semester Configuration -->
   405	      <section class="settings-panel">
   406	        <h2 class="settings-panel-title">Semester Configuration</h2>
   407	        <p class="settings-panel-desc">Configure semester settings, data source URLs, and Week tab GIDs. These settings are shared across all users.</p>
   408	
   409	        <div class="settings-form-group">
   410	          <label for="settings-semester-select">Editing Semester</label>
   411	          <select id="settings-semester-select" onchange="loadSettingsForm()" style="max-width:300px"></select>
   412	          <div id="settings-semester-publish-group" style="margin-top:8px"></div>
   413	        </div>
   414	
   415	        <div class="settings-form-group">
   416	          <label for="settings-semester-name">Semester Name</label>
   417	          <input type="text" id="settings-semester-name" placeholder="e.g. Spring 2026">
   418	          <small class="settings-hint" id="settings-camp-readonly-note" hidden></small>
   419	        </div>
   420	
   421	        <div class="settings-form-row weekly-only-field">
   422	          <div class="settings-form-group">
   423	            <label for="settings-start-date">Semester Start Date</label>
   424	            <input type="date" id="settings-start-date">
   425	          </div>
   500	        </div>
   501	
   502	        <div class="settings-actions">
   503	          <button class="btn-primary" onclick="saveSettings()">Save Settings</button>
   504	        </div>
   505	      </section>
   506	    </main>
   507	  </div>
   508	
   509	  <!-- Footer -->
   510	  <footer class="app-footer">
   511	    <div class="footer-links">
   512	      <a href="#" id="help-link" class="footer-link">How to Use</a>
   513	      <span class="footer-dot">&middot;</span>
   514	      <a href="#" id="settings-link" class="footer-link write-control">Settings</a>
   515	      <span class="footer-dot write-control">&middot;</span>
   516	      <a href="#" id="footer-sign-out" class="footer-link">Sign Out</a>
   517	    </div>
   518	    <div class="footer-branding">
   519	      <span>© 2026 Tinker Art Studio</span>
   520	      <span class="footer-dot">&middot;</span>
   521	      <span>Made with 🎨 for our teaching team</span>
   522	    </div>
   523	  </footer>
   524	
   525	  <!-- How to Use Modal -->

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '250,290p;770,840p'
rg -n \"function canSeeSemester|localStorage\\.(getItem|setItem|removeItem)|localStorage\\[|sessionStorage\" js index.html e2e --glob '"'!e2e/test-results/**'"'
rg -n \"curriculum/appData|doc\\(['\\\"]appData|activeSemester\" /Users/christiehubley/studio-hub /Users/christiehubley --glob '*.js' --glob '*.ts' --glob '*.html' --glob '*.json' --glob '"'!**/node_modules/**'"' --glob '"'!**/.git/**'"' --glob '"'!**/.claude/**'"' --glob '"'!**/Library/**'"' 2>/dev/null | head -400" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 535ms:
m/e2e/data-safety.spec.js:8845:          let stored = { activeSemester: 'fall-2026', teacherMappings: { A: 'x' }, semesters: { 'fall-2026': { name: 'Fall 2026' } } };
/Users/christiehubley/tinker-spring-curriculum/e2e/data-safety.spec.js:8860:          stored = { activeSemester: 'fall-2026', teacherMappings: { A: 'x' }, semesters: { 'fall-2026': { name: 'Fall 2026' } } };
/Users/christiehubley/tinker-spring-curriculum/e2e/day-off-teacher.spec.js:661:    const weekly = await prep.evaluate(() => currentConfig.activeSemester);
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-data-safety-remaining-stages.html:1206:    <strong>🛑 Correction, Aug 15, 2026 (round 10) — the claim above that "two admins acting on either bank... can no longer clobber each other" is TRUE for Cut Bank but was FALSE as originally stated for Idea Bank.</strong> Both round-10 reviewers, independently, found and confirmed <code>curriculum/futureProjects</code> (the Idea Bank's backing document) has FIVE other live, unaudited writers that still use the old local-splice-then-full-array-overwrite pattern via <code>saveFutureProjects()</code>: <code>saveNewIdea()</code>, <code>saveIdeaEdit()</code>, <code>deleteIdeaProject()</code>, <code>archiveIdeaProject()</code>, and <code>unarchiveIdeaProject()</code> (all <code>app.js:5305-5383</code>). <code>pasteFromIdeaBank()</code>'s <code>arrayRemove()</code> only wins the race against itself and against Phase-17-style atomic appends — it loses against any of these five. Concretely: an admin pastes (correctly removes) idea X; a moment later, a different admin archives, edits, deletes, or adds a DIFFERENT idea from a stale snapshot that still contains X — that admin's full-array overwrite silently resurrects X. <strong>Cut Bank has no equivalent gap</strong> — both reviewers confirmed, via exhaustive grep, that <code>cutProject()</code> (Phase 17, <code>arrayUnion</code>), <code>pasteFromCutBank()</code>, and <code>deleteCutProject()</code> (both this phase, <code>arrayRemove</code>) are the ONLY three functions that ever touch <code>currentCutProjects</code> — the Cut Bank race is genuinely, completely closed. <strong>Fixing the Idea Bank's remaining five writers, and a broader pattern of the same "shared document/array last-write-wins" vulnerability class found the same round in unrelated features (<code>curriculum/appData</code>/Settings, Prep Dashboard, Prep Cycle config, diagnostic dismissals), is deliberately OUT OF SCOPE for this plan</strong> — Christie's explicit decision, given this is a distinct vulnerability class from Vulnerability #11 (shared config/array documents, not lesson content) that reaches well beyond anything this plan has otherwise touched. It will be addressed by a separate, dedicated plan, covering the whole app comprehensively rather than the incidentally-discovered subset found here. See "Not in scope" below for the specific pointer.</div>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-data-safety-remaining-stages.html:1823:  if (key === currentConfig.activeSemester) {
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-data-safety-remaining-stages.html:1930:  caCurrentSemester = currentConfig.activeSemester;
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-data-safety-remaining-stages.html:2273:  <div class="danger">🛑 <strong>Residual gap, found Aug 15, 2026 (round 9, Codex): this guard is go-forward only — it has no effect on a "summer-"-prefixed, non-camp-type key that might already exist in <code>currentConfig.semesters</code> before this phase ever ships.</strong> The check only runs inside <code>createNewSemester()</code>, at the moment of creation — it cannot retroactively repair or flag an already-existing ambiguous key, and (as established above) Settings can edit a semester's display name without ever touching its underlying key, so there is no in-app remediation path for one either. <strong>No such semester is known to exist in production today</strong> — <code>semesterType: 'summer-camp'</code> is confirmed set in exactly two places in the codebase (both for <code>summer-2026</code>, see Phase 14/15's danger boxes), and creating an ambiguous key requires a deliberate, unusual admin naming choice that would need to have already happened. Before or during deployment of this phase, a one-time, read-only check of the real <code>curriculum/appData</code> config document is recommended — confirm no key other than <code>summer-2026</code> starts with <code>"summer-"</code> — rather than assuming this from the app's UI-reachability analysis alone. Not a code change; a deployment-time verification step, noted here so it isn't silently skipped.</div>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-data-safety-remaining-stages.html:2345:        <li><strong>Phase 18 (block ambiguous "summer-" semester keys), added Aug 15, 2026 (round 8, Christie's explicit scope decision), corrected same day (round 9):</strong> attempt to create a semester named "Summer Enrichment 2027" via the real UI form, confirm it's rejected with a clear alert and <code>saveConfig()</code> is never called (spy/count) — the test that would have caught the underlying misrouting this blocks. A second test: create a semester named "End of Summer Showcase" (key <code>end-of-summer-showcase</code>, doesn't start with "summer-" after slugification), confirm it succeeds normally. A third test: create an ordinary semester with no relation to "Summer" at all, confirm no change in behavior from today's shipped success path. A round-9 boundary test: create semesters named "Summer2027" and "Summer" alone (slugify to <code>summer2027</code> and <code>summer</code> — neither starts with the literal <code>"summer-"</code> prefix), confirm both are ALLOWED, since neither actually collides with the deep functions' routing check. Not an automated test, but noted here as a one-time manual step before this phase deploys: confirm via the real Firestore console that <code>curriculum/appData</code>'s <code>semesters</code> map contains no pre-existing <code>"summer-"</code>-prefixed key other than <code>summer-2026</code> — this phase's guard is go-forward only and cannot detect or repair one that already exists (round 9, Codex).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-data-safety-remaining-stages.html:2376:  <li><strong>The Idea Bank's five remaining <code>curriculum/futureProjects</code> writers, plus a broader "shared document/array last-write-wins" vulnerability class found in unrelated features — found Aug 15, 2026 (round 10), deliberately NOT fixed here, moved to a dedicated follow-on plan.</strong> <code>saveNewIdea()</code>, <code>saveIdeaEdit()</code>, <code>deleteIdeaProject()</code>, <code>archiveIdeaProject()</code>, and <code>unarchiveIdeaProject()</code> (all <code>app.js:5305-5383</code>) still overwrite the entire <code>futureProjects</code> document via a local read-modify-write, meaning Phase 13's <code>arrayRemove()</code> fix (see its own danger box's round-10 correction) only closes part of the Idea Bank's exposure, not all of it — unlike Cut Bank, which round 10 confirmed is genuinely, completely closed. The same round also found this exact vulnerability class — a shared config/array document trusted from a stale local cache and overwritten wholesale — in <code>curriculum/appData</code> (Settings/semester create-delete-publish, <code>firebase-data.js:79-85</code>, live callers include <code>saveSettings()</code>, <code>createNewSemester()</code>, <code>deleteSemester()</code>), the Prep Dashboard's weekly autosave (<code>savePrepWeekData()</code>, <code>firebase-data.js:145-162</code>, including a <code>classAssociations</code> array), Prep Cycle configuration (<code>savePrepCycleConfig()</code>, <code>firebase-data.js:313-321</code>), and (lower-stakes, self-healing) diagnostic dismissals (<code>saveDiagDismissals()</code>, <code>firebase-data.js:636-648</code>). <strong>This is a genuinely distinct vulnerability class from Vulnerability #11</strong> — shared config/array documents, not lesson content — reaching well beyond this plan's scope (Vulnerability #11 Layer 1 plus the explicitly-approved delete/archive-completeness cluster, Phases 15-18). Christie's explicit decision, discussed directly rather than assumed: address this comprehensively in its own dedicated plan, covering the whole app deliberately rather than the incidentally-discovered subset found here, using the same Codex+Claude review-loop rigor from round one. See <code>classbook-shared-document-concurrency-plan.html</code> (<code>plan_DsqEjQ-LAziY</code>) — created the same session, immediately after this decision, specifically so it has independent existence rather than being only a paragraph here. <strong>That plan is scoping-only as of Aug 15, 2026</strong> — it documents these six known instances and the decision that led to it, but its own comprehensive sweep and phase design have not started. Corrected Aug 15, 2026 (round 11, both reviewers) after this text briefly said the plan "doesn't exist yet," which became stale the moment the file was created later in the same session.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-data-safety-remaining-stages.html:2572:      <li><strong>[Codex, HIGH, genuinely new scope] The identical vulnerability class — a shared config/array document trusted from a stale local cache, then overwritten wholesale — exists in features entirely unrelated to Cut Bank/Idea Bank/lesson data.</strong> Codex traced concrete instances in <code>curriculum/appData</code> (Settings/semester create-delete-publish — an admin's roster edit could be silently erased by a concurrent semester deletion or publish-toggle from another admin), the Prep Dashboard's weekly autosave (including a <code>classAssociations</code> array), and Prep Cycle configuration. Claude's own undirected sweep independently found a fourth, lower-stakes instance (<code>saveDiagDismissals()</code>). None of these were previously named anywhere in this doc.</li>
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-22T17-38-13.json:830:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-kpi/js/firebase-data.js:27:    const doc = await _firestoreDb.collection('kpiData').doc('appData').get();
/Users/christiehubley/tinker-kpi/js/firebase-data.js:44:    await _firestoreDb.collection('kpiData').doc('appData').set(data);
/Users/christiehubley/tinker-kpi/js/firebase-data.js:61:    await _firestoreDb.collection('kpiData').doc('appData').set(data);
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-24T22-22-33.json:828:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-15T21-55-14.json:834:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-16T19-05-09.json:1468:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-22T18-08-30.json:1468:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-24T16-47-43.json:830:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-29T17-31-21.json:835:        "activeSemester": "fall-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-24T20-51-02.json:828:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-14T21-47-26.json:828:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-28T22-00-14.json:835:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-16T16-41-01.json:834:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-28T16-03-27.json:1493:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-21T18-20-58.json:1467:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-24T19-50-00.json:828:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-16T17-41-32.json:1460:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-21T22-29-01.json:1468:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-21T21-28-37.json:1468:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-22T20-09-15.json:1468:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-25T18-55-11.json:830:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-28T17-58-11.json:1499:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-22T21-09-44.json:828:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-21T21-58-49.json:835:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-21T15-49-44.json:835:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-28T18-58-40.json:834:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-21T22-59-13.json:1467:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-22T20-39-30.json:829:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-24T17-48-21.json:829:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-25T16-54-10.json:1493:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-25T17-54-37.json:1499:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-23T22-35-56.json:829:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-23T19-15-35.json:836:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-29T16-30-47.json:841:        "activeSemester": "fall-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-23T22-05-45.json:828:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-24T15-22-53.json:1489:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-28T18-28-25.json:1500:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-materials/js/firebase-data.js:27:    const doc = await _firestoreDb.collection('materials').doc('appData').get();
/Users/christiehubley/tinker-materials/js/firebase-data.js:44:    await _firestoreDb.collection('materials').doc('appData').set(data);
/Users/christiehubley/tinker-materials/js/firebase-data.js:61:    await _firestoreDb.collection('materials').doc('appData').set(data);
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-28T22-30-30.json:1505:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-28T19-28-55.json:1505:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-21T19-57-54.json:1461:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-21T16-50-12.json:828:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-21T20-28-11.json:834:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-28T19-59-12.json:842:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-24T15-57-44.json:1489:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-20T18-47-57.json:1462:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-25T17-24-24.json:1500:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-28T20-59-43.json:840:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-23T20-16-08.json:1462:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-24T21-52-16.json:1498:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-24T17-18-01.json:835:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-16T19-35-24.json:828:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-16T20-05-36.json:1468:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-22T17-07-57.json:1466:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-22T21-40-00.json:828:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-17T22-22-28.json:1467:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-28T16-27-27.json:828:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-24T14-40-28.json:829:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-28T16-57-40.json:829:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-16T16-10-46.json:827:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-25T18-24-53.json:1492:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-21T17-50-45.json:829:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-28T20-29-27.json:1505:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-25T15-05-41.json:830:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-21T16-19-57.json:1462:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-24T22-52-47.json:1492:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-16T17-11-18.json:827:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-21T17-20-27.json:829:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-24T19-19-25.json:1500:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-16T18-34-55.json:1468:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-22T19-39-01.json:828:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-28T03-44-59.json:1500:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-14T22-47-50.json:835:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-16T20-35-49.json:830:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-23T19-45-51.json:834:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-28T21-29-58.json:1506:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-26T22-30-57.json:1500:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-23T21-35-32.json:1468:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-23T19-10-08.json:830:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-15T22-25-36.json:1467:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-15T21-24-58.json:834:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-22T18-38-47.json:1468:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-23T18-45-16.json:1462:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-17T21-52-15.json:828:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-14T21-17-15.json:827:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-22T16-13-50.json:828:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-24T20-20-38.json:1500:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-24T18-49-00.json:1499:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-25T15-35-53.json:1499:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-28T17-27-54.json:830:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-25T03-41-13.json:828:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-24T21-21-29.json:1500:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-20T23-46-54.json:834:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-14T22-17-39.json:1467:        "activeSemester": "spring-2026"
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-25T16-23-56.json:835:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-25T18-32-15.json:829:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-21T20-58-24.json:828:        "activeSemester": "spring-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-29T17-01-03.json:835:        "activeSemester": "fall-2026",
/Users/christiehubley/tinker-backups/tinker-backup-2026-09-24T18-18-42.json:828:        "activeSemester": "spring-2026",

exec
/bin/zsh -lc "rg -n \"function requireAuth|auth-guard|onAuthStateChanged|location.reload|signInWithEmailAndPassword\" js
nl -ba js/auth.js | sed -n '1,260p'
rg -n \"signInViaForm\\(.*teacher|fresh context|storageState: \\{ cookies\" e2e/*.spec.js" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
js/auth-guard.js:13://   <div id="auth-guard" class="auth-guard">
js/auth-guard.js:14://     <div class="auth-guard-content">
js/auth-guard.js:18://       <form id="auth-guard-form" class="auth-guard-form">
js/auth-guard.js:31:function requireAuth() {
js/auth-guard.js:43:    firebase.auth().onAuthStateChanged(async (user) => {
js/auth-guard.js:44:      const guard = document.getElementById('auth-guard');
js/auth-guard.js:48:        window.location.reload();
js/auth-guard.js:115:  const form = document.getElementById('auth-guard-form');
js/auth-guard.js:139:      await firebase.auth().signInWithEmailAndPassword(email, password);
nl: js/auth.js: No such file or directory
e2e/day-off-teacher.spec.js:82:  const ctx = await browser.newContext({ storageState: { cookies: [], origins: [] } });
e2e/day-off-camps.spec.js:84:      const ctx = await browser.newContext({ storageState: { cookies: [], origins: [] } });

exec
/bin/zsh -lc "nl -ba js/auth-guard.js | sed -n '25,165p'
nl -ba e2e/day-off-teacher.spec.js | sed -n '70,115p'
nl -ba e2e/day-off-camps.spec.js | sed -n '75,110p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
    25	//     </div>
    26	//   </div>
    27	
    28	let authCurrentUser = null;
    29	let authResolvedUid = null;  // Track which UID the app initialized with
    30	
    31	function requireAuth() {
    32	  return new Promise((resolve) => {
    33	    if (typeof firebase === 'undefined') {
    34	      console.warn('Firebase SDK not loaded — skipping auth');
    35	      resolve(null);
    36	      return;
    37	    }
    38	
    39	    // Initialize Firebase if needed
    40	    initFirebaseApp();
    41	
    42	    // Listen for auth state
    43	    firebase.auth().onAuthStateChanged(async (user) => {
    44	      const guard = document.getElementById('auth-guard');
    45	
    46	      // If app already initialized with a different user, reload to re-init cleanly
    47	      if (user && authResolvedUid && user.uid !== authResolvedUid) {
    48	        window.location.reload();
    49	        return;
    50	      }
    51	
    52	      if (user) {
    53	        // Fetch user role from Firestore
    54	        try {
    55	          const db = firebase.firestore();
    56	          const userDocRef = db.collection('users').doc(user.uid);
    57	          const userDoc = await userDocRef.get();
    58	
    59	          if (userDoc.exists) {
    60	            // User doc exists - use it
    61	            authCurrentUser = {
    62	              uid: user.uid,
    63	              email: user.email,
    64	              name: user.displayName || user.email.split('@')[0],
    65	              role: 'staff',
    66	              studios: ['tinker', 'clayhub'],
    67	              ...userDoc.data()
    68	            };
    69	          } else {
    70	            // User doc doesn't exist - create it
    71	            const newUserData = {
    72	              uid: user.uid,
    73	              email: user.email,
    74	              name: user.displayName || user.email.split('@')[0],
    75	              role: 'staff',
    76	              studios: ['tinker', 'clayhub'],
    77	              appAccess: [],
    78	              createdAt: firebase.firestore.FieldValue.serverTimestamp(),
    79	              updatedAt: firebase.firestore.FieldValue.serverTimestamp()
    80	            };
    81	
    82	            // Create the doc
    83	            await userDocRef.set(newUserData);
    84	            console.log('✅ Created Firestore user doc for:', user.email);
    85	
    86	            authCurrentUser = newUserData;
    87	          }
    88	        } catch (err) {
    89	          console.error('Error fetching/creating user data:', err);
    90	          authCurrentUser = {
    91	            uid: user.uid,
    92	            email: user.email,
    93	            name: user.displayName || 'User',
    94	            role: 'staff',
    95	            studios: ['tinker', 'clayhub']
    96	          };
    97	        }
    98	
    99	        // Hide guard, show app
   100	        if (guard) guard.style.display = 'none';
   101	        authResolvedUid = user.uid;
   102	        resolve(authCurrentUser);
   103	      } else {
   104	        // Show guard — don't resolve yet, wait for sign-in
   105	        if (guard) {
   106	          guard.style.display = 'flex';
   107	          setupAuthForm();
   108	        }
   109	      }
   110	    });
   111	  });
   112	}
   113	
   114	function setupAuthForm() {
   115	  const form = document.getElementById('auth-guard-form');
   116	  if (!form || form.dataset.initialized) return;
   117	  form.dataset.initialized = 'true';
   118	
   119	  // Password toggle
   120	  const passwordToggle = document.getElementById('auth-password-toggle');
   121	  const passwordInput = document.getElementById('auth-password');
   122	  if (passwordToggle && passwordInput) {
   123	    passwordToggle.addEventListener('click', () => {
   124	      const isPassword = passwordInput.type === 'password';
   125	      passwordInput.type = isPassword ? 'text' : 'password';
   126	      passwordToggle.textContent = isPassword ? '👁️‍🗨️' : '👁️';
   127	      passwordToggle.setAttribute('aria-label', isPassword ? 'Hide password' : 'Show password');
   128	    });
   129	  }
   130	
   131	  form.addEventListener('submit', async (e) => {
   132	    e.preventDefault();
   133	    const email = document.getElementById('auth-email').value;
   134	    const password = document.getElementById('auth-password').value;
   135	    const errorEl = document.getElementById('auth-error');
   136	
   137	    try {
   138	      errorEl.textContent = '';
   139	      await firebase.auth().signInWithEmailAndPassword(email, password);
   140	    } catch (err) {
   141	      const messages = {
   142	        'auth/user-not-found': 'No account found with this email.',
   143	        'auth/wrong-password': 'Incorrect password.',
   144	        'auth/invalid-email': 'Please enter a valid email.',
   145	        'auth/too-many-requests': 'Too many attempts. Try again later.'
   146	      };
   147	      errorEl.textContent = messages[err.code] || 'Sign in failed. Please try again.';
   148	    }
   149	  });
   150	}
   151	
   152	function getAuthUser() {
   153	  return authCurrentUser;
   154	}
   155	
   156	function authSignOut() {
   157	  return firebase.auth().signOut();
   158	}
    70	const readPlan = (page, camp, title) =>
    71	  page.evaluate(({ Y, id, title }) => __sdocT.read('lessonData', dayOffPlanDocId(Y, id, title)), { Y, id: camp.id, title });
    72	const addItem = (camp, title, item) =>
    73	  attempt(planner, ({ Y, id, title, item }) => saveDayOffMaterialItem(Y, id, title, null, item), { Y, id: camp.id, title, item });
    74	
    75	// Load the year into a page's model (another session wrote it).
    76	async function loadYear(page) {
    77	  await page.evaluate(async (Y) => { currentLessonData[Y] = await loadDayOffCampData({ yearKey: Y }); }, Y);
    78	}
    79	
    80	// A signed-in teacher page with the TEST year injected (published unless told otherwise).
    81	async function teacherSession(browser, { published = true } = {}) {
    82	  const ctx = await browser.newContext({ storageState: { cookies: [], origins: [] } });
    83	  extraContexts.push(ctx);
    84	  const p = await ctx.newPage();
    85	  await login(p, 'teacher');
    86	  await p.waitForFunction(() => typeof lessonDataLoadedSuccessfully !== 'undefined' && lessonDataLoadedSuccessfully === true && !!currentLessonData, null, { timeout: 25_000 });
    87	  await p.evaluate(({ Y, POOL, published }) => {
    88	    currentConfig.semesters[Y] = {
    89	      name: 'TEST SDOC 2026-27', semesterType: 'day-off-camps', startDate: '2026-08-01', endDate: '2027-05-31',
    90	      published, teacherNames: POOL,
    91	    };
    92	    window.__sdocT = {
    93	      async read(coll, id) {
    94	        const d = await curriculumDb.collection(`dayOffCamps_${coll}`).doc(id).get({ source: 'server' });
    95	        return d.exists ? d.data() : null;
    96	      },
    97	    };
    98	  }, { Y, POOL, published });
    99	  await loadYear(p);
   100	  return p;
   101	}
   102	
   103	async function openTeacherView(page) {
   104	  await page.evaluate(() => initGlobalSemesterSelector());
   105	  await page.selectOption('#global-semester-select', Y);
   106	  await page.click('.tab-btn[data-tab="teacher-view"]');
   107	  // A teacher lands on her own camps; an admin/prep user on "Select a teacher".
   108	  await expect(page.locator('#tv-content .sdoc-tv, #tv-content .tv-placeholder').first()).toBeVisible();
   109	}
   110	async function pickTeacher(page, name) {
   111	  await page.selectOption('#tv-teacher-select', name);
   112	  await expect(page.locator('#tv-content .sdoc-tv')).toBeVisible();
   113	}
   114	const blockCell = (page, camp, date, block) =>
   115	  page.locator(`.sdoc-tv-camp[data-camp-id="${camp.id}"] .sdoc-tv-day[data-date="${date}"] .sdoc-tv-block[data-block="${block}"]`);
    75	      await page.evaluate(() => openNewSemesterModal());
    76	      await page.check('#new-sem-type-dayoff');
    77	      await page.fill('#new-sem-dayoff-start', '2090-08-01');
    78	      await page.fill('#new-sem-dayoff-end', '2091-05-31');
    79	      await page.click('#ca-new-semester-modal .settings-actions .btn-primary');
    80	      await expect.poll(() => dupAlert.length).toBeGreaterThan(0);
    81	      expect(dupAlert[0]).toContain('already exists');
    82	
    83	      // A teacher signing in sees no SDOC year.
    84	      const ctx = await browser.newContext({ storageState: { cookies: [], origins: [] } });
    85	      const tp = await ctx.newPage();
    86	      try {
    87	        await login(tp, 'teacher');
    88	        const options = await tp.locator('#global-semester-select option').allTextContents();
    89	        expect(options.join('|')).not.toContain('SDOC 2090-91');
    90	      } finally { await ctx.close(); }
    91	    } finally {
    92	      await page.evaluate(async (k) => {
    93	        await curriculumDb.collection('curriculum').doc('appData').update({ [`semesters.${k}`]: firebase.firestore.FieldValue.delete() });
    94	        delete currentConfig.semesters[k];
    95	      }, KEY);
    96	    }
    97	  });
    98	
    99	  test('SDOC 2: the year is refused when it ends before it starts — nothing is written', async ({ page }) => {
   100	    const messages = [];
   101	    page.on('dialog', d => { messages.push(d.message()); d.accept(); });
   102	    await page.evaluate(() => { window.__appDataWrites = 0; const u = window.updateAppData; window.updateAppData = async (...a) => { window.__appDataWrites++; return u(...a); }; });
   103	    await page.evaluate(() => openNewSemesterModal());
   104	    await page.check('#new-sem-type-dayoff');
   105	    await page.fill('#new-sem-dayoff-start', '2091-05-31');
   106	    await page.fill('#new-sem-dayoff-end', '2090-08-01');
   107	    await page.click('#ca-new-semester-modal .settings-actions .btn-primary');
   108	    await expect.poll(() => messages.length).toBeGreaterThan(0);
   109	    expect(messages[0]).toContain('end after it starts');
   110	    expect(await page.evaluate(() => window.__appDataWrites)).toBe(0);

exec
/bin/zsh -lc "nl -ba js/firebase-data.js | sed -n '450,535p'
rg -n \"function loadConfig|setupConfigListener\" js/firebase-data.js js/app.js
nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-shared-document-concurrency-plan.html | sed -n '45,80p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
   450	  const onError = (err) => {
   451	    console.error('❌ Season registry listener failed:', err);
   452	    // Without this a tab whose rule was removed mid-session would sit on
   453	    // "waiting for a connection" when the real cause is the rule.
   454	    // Any other error (typically `unavailable`) leaves the mode as it is. A
   455	    // tab that then can't write has to be reloaded — accepted: reviewed and
   456	    // judged an inconvenience, not worth a retry loop in an error path
   457	    // (Christie's call, Sep 24).
   458	    if (err?.code === 'permission-denied') applySeasonRegistryMode('error', err);
   459	  };
   460	  const sub = subscribe || ((next, error) =>
   461	    currentSeasonDocRef().onSnapshot({ includeMetadataChanges: true }, next, error));
   462	  seasonRegistryUnsubscribe = sub(onSnap, onError) || null;
   463	  return seasonRegistryUnsubscribe;
   464	}
   465	
   466	// ─── The one-time type migration (Phase 1, 1.2) ──────────────────────────────
   467	// Pure: given the server's appData, the dotted paths that would stamp it.
   468	// Never overwrites a stored value; refuses a stored type that contradicts the
   469	// migration rather than "fixing" it. The Summer 2026 season facts are carried
   470	// here because the registry may not exist yet when this runs (legacy mode),
   471	// and these are the same values the Summer Camp App seeds into it.
   472	const SUMMER_2026_TIME_SLOTS = [{ key: 'AM', label: 'AM (9am-12pm)' }, { key: 'PM', label: 'PM (1pm-4pm)' }];
   473	const SUMMER_2026_STUDIOS = ['SoBo', 'AG', 'GR', 'MVW', 'Clay Hub', 'Coal Creek'];
   474	function buildSemesterTypeStamps(serverConfig) {
   475	  const semesters = serverConfig?.semesters;
   476	  if (!semesters || typeof semesters !== 'object') {
   477	    throw new Error('Cannot stamp semester types: the appData document has no semesters map.');
   478	  }
   479	  const stamps = {};
   480	  for (const [key, sem] of Object.entries(semesters)) {
   481	    const expected = key === LEGACY_CAMP_SEMESTER_KEY ? SEMESTER_TYPES.camp : SEMESTER_TYPES.weekly;
   482	    if (sem?.semesterType) {
   483	      if (sem.semesterType !== expected) {
   484	        throw new Error(`Semester "${key}" already carries semesterType "${sem.semesterType}" where this migration expects "${expected}" — refusing to overwrite a stored type. Check it by hand before stamping.`);
   485	      }
   486	    } else {
   487	      stamps[`semesters.${key}.semesterType`] = expected;
   488	    }
   489	    if (key !== LEGACY_CAMP_SEMESTER_KEY) continue;
   490	    // Summer 2026's season facts, seeded only where absent.
   491	    if (!sem?.season) stamps[`semesters.${key}.season`] = '2026';
   492	    // The break is calendar position 6. An empty breakWeeks is why the Teacher
   493	    // View calendar currently draws W6 on the break and W7–W11 a week early —
   494	    // seeding it is an intended visible FIX, not a parity break.
   495	    if (!Array.isArray(sem?.breakWeeks) || sem.breakWeeks.length === 0) stamps[`semesters.${key}.breakWeeks`] = [6];
   496	    if (!Array.isArray(sem?.timeSlots) || sem.timeSlots.length === 0) stamps[`semesters.${key}.timeSlots`] = SUMMER_2026_TIME_SLOTS;
   497	    if (!Array.isArray(sem?.studios) || sem.studios.length === 0) stamps[`semesters.${key}.studios`] = SUMMER_2026_STUDIOS;
   498	  }
   499	  return stamps;
   500	}
   501	
   502	function getDefaultConfig() {
   503	  return {
   504	    activeSemester: 'spring-2026',
   505	    semesters: {
   506	      'spring-2026': {
   507	        name: 'Spring 2026',
   508	        startDate: '2026-01-12',
   509	        numWeeks: 16,
   510	        breakWeeks: [10],
   511	        classRoster: {}
   512	      }
   513	      // No camp season here on purpose (Phase 1, 1.2): camp seasons are created
   514	      // from the Summer Camp App's registry, never invented by a default.
   515	    },
   516	    lastUpdated: null,
   517	    lastUpdatedBy: null
   518	  };
   519	}
   520	
   521	function setupConfigListener(callback) {
   522	  if (!curriculumDb) initCurriculumFirestore();
   523	  if (configUnsubscribe) configUnsubscribe();
   524	  configUnsubscribe = curriculumDb.collection('curriculum').doc('appData')
   525	    .onSnapshot(doc => {
   526	      if (doc.exists) {
   527	        currentConfig = doc.data();
   528	        if (callback) callback(currentConfig);
   529	      }
   530	    });
   531	}
   532	
   533	// ─── Prep Data (curriculum/prepData) ─────────────────
   534	
   535	async function loadPrepData() {
js/firebase-data.js:168:async function loadConfig() {
js/firebase-data.js:521:function setupConfigListener(callback) {
js/app.js:11328:    // listener (setupConfigListener() is never called), so nothing else would
    45	
    46	  <p><strong>Scope boundary — Classbook (<code>tinker-spring-curriculum</code>) only, for now.</strong> This exact anti-pattern (local read-modify-write, then full-document overwrite) is a common enough JS/Firestore habit that it plausibly exists in other Tinker HQ apps too (Roster Manager, Payroll Tool, Tinker Ticker, etc.) — but that has not been checked, and doing so is explicitly out of scope for this document unless Christie asks to expand it. Said honestly here rather than silently assumed either way.</p>
    47	</div>
    48	
    49	<h2 id="known-findings">What's already known — seven instances, found incidentally, not from a sweep</h2>
    50	<div class="phase">
    51	  <p>These are documented here so the eventual comprehensive sweep has a known-correct baseline to check against (and so nothing already found gets rediscovered from scratch) — <strong>none of these have design work, BDD scenarios, or review done yet.</strong> They are almost certainly a subset of what actually exists.</p>
    52	
    53	  <h3>1. Idea Bank's six writers (HIGH — the most directly actionable, since it's the same collection/pattern round 9-10 already partially fixed)</h3>
    54	  <div class="danger">🛑 <strong>Correction, Aug 18, 2026 (backtracking audit plan's Phase 11 execution session).</strong> This entry originally said "five remaining writers," implying <code>pasteFromIdeaBank()</code> itself was already fixed with <code>arrayRemove()</code> the way Cut Bank's paste was. That was wrong — direct code reading confirmed <code>pasteFromIdeaBank()</code> had never been touched by that fix at all; instead it carried a separate, deterministic, live production bug (it passed the whole <code>{projects:[...]}</code> wrapper into <code>saveFutureProjects()</code>, which expects a bare array, double-nesting <code>curriculum/futureProjects</code> on every single use). That bug is now fixed (backtracking audit plan, Phase 11), and the fix was hardened through two rounds of Codex+Claude implementation review. But the underlying write primitive is still the same plain <code>saveFutureProjects()</code> <code>.set()</code> as the other five — <code>pasteFromIdeaBank()</code> was never actually an exception to this instance, it's a sixth writer sharing the identical race, not a already-solved case. See the Decisions Log entry below for the specific narrow sub-case a reviewer found in this session's hardened version.</div>
    55	  <p><strong>File:</strong> <code>js/app.js</code>. <strong>Functions:</strong> <code>saveNewIdea()</code> (~5305-5330, write ~5327), <code>saveIdeaEdit()</code> (~5340-5357, write ~5354), <code>deleteIdeaProject()</code> (~5359-5369, write ~5367), <code>archiveIdeaProject()</code> (~5371-5376, write ~5374), <code>unarchiveIdeaProject()</code> (~5378-5383, write ~5381), and <code>pasteFromIdeaBank()</code> (~5648-5741, write via <code>saveFutureProjects()</code> inside its own try/catch). All call <code>saveFutureProjects(projects)</code> (<code>firebase-data.js:581-589</code>), which does a plain <code>.set({projects, lastUpdated, lastUpdatedBy})</code> on the whole <code>curriculum/futureProjects</code> document — no <code>arrayUnion</code>/<code>arrayRemove</code>, no merge-at-the-element-level. There is no <code>onSnapshot</code> listener on this document (confirmed — the only listeners in <code>firebase-data.js</code> are on <code>curriculum/lessonData</code> and <code>curriculum/appData</code>), so a tab's cached <code>currentFutureProjects</code> can go stale indefinitely with no self-correction.</p>
    56	  <p><strong>Concrete failure:</strong> Admin A pastes idea X from the bank (a plain <code>.set()</code> of the post-removal array, same as every other writer here — NOT an atomic <code>arrayRemove()</code>, see the correction above). Admin B, in a separate tab with a snapshot loaded before A's removal propagated, archives, edits, deletes, or adds a <em>different</em> idea moments later — B's full-array overwrite silently resurrects X. <code>deleteIdeaProject()</code> is the direct sibling of the companion plan's already-fixed <code>deleteCutProject()</code> — same shape, same likely fix (<code>FieldValue.arrayRemove()</code>) — and <code>pasteFromIdeaBank()</code>'s own removal step is now effectively a second instance of that exact same sibling shape. <code>saveNewIdea()</code>/<code>saveIdeaEdit()</code> would need care: an "edit" mutates an existing array element in place, so the fix isn't a simple append/remove — it likely needs the element's stable identity (an id field, if one exists — check <code>app.js:5317</code>'s id-generation convention, already referenced elsewhere in the companion plan) to target a transaction or a keyed sub-collection instead of an in-array edit, since Firestore's array transforms can't update one element by identity — only add or remove whole elements.</p>
    57	  <p><strong>Reachability note (open question, not yet checked):</strong> is Idea Bank reachable for summer semesters, the way Cut Bank/Copy Plan were checked and found NOT reachable in the companion plan? Verify before assuming these five fixes need the same "non-summer only" framing.</p>
    58	
    59	  <h3>2. <code>curriculum/appData</code> — Settings, semester create/delete/publish (HIGH — likely the most consequential, since it's admin-facing config, not a utility bank)</h3>
    60	  <p><strong>File:</strong> <code>js/firebase-data.js</code>, <code>saveConfig(config)</code> (79-85) — an unconditional <code>.set(config)</code> of the ENTIRE config document. <strong>Live callers:</strong> <code>saveSettings()</code> (<code>app.js:9249-9286</code> — deep-copies the whole cached config, replaces one semester's fields including array fields like <code>breakWeeks</code>/<code>closureDates</code>/<code>teacherNames</code>, overwrites the whole document), plus semester creation, deletion, and publish-toggling (all touched by the companion plan's Phases 15/18, which did NOT address this underlying overwrite pattern — those phases fixed different bugs in the same functions). <code>setupConfigListener()</code> exists in the codebase but is never called anywhere — confirmed via grep — so the local config cache has no live-refresh mechanism at all.</p>
    61	  <p><strong>Concrete failure:</strong> Admin A opens Settings and changes one semester's roster or teacher list. Admin B, concurrently, creates a new semester, deletes a different one, or toggles a publish flag. Both save whole locally-derived config objects. Whichever <code>.set(config)</code> lands last silently erases the other admin's change — potentially an entire newly-created semester, vanishing with no error, no trace, and no admin ever told anything went wrong.</p>
    62	  <p><strong>Relationship to companion plan:</strong> Phase 15 (semester delete) and Phase 18 (block ambiguous semester keys) both touch <code>deleteSemester()</code>/<code>createNewSemester()</code>, which both go through this same <code>saveConfig()</code> path — but neither phase addresses THIS race (they fix different, narrower bugs in the same functions). Worth checking during design whether a fix here needs to be coordinated with those phases' pseudocode rather than designed in isolation.</p>
    63	
    64	  <h3>3. Prep Dashboard weekly autosave (MEDIUM)</h3>
    65	  <p><strong>File:</strong> <code>js/app.js</code>, <code>savePrepDataNow()</code> (~7128-7139), passing the whole <code>currentWeekPrepData</code> to <code>savePrepWeekData()</code> (<code>firebase-data.js:145-162</code>), which replaces the complete <code>${semesterKey}.${weekKey}</code> map. Includes a <code>classAssociations[project]</code> array locally mutated via <code>push()</code>/<code>filter()</code> (<code>app.js:8418-8444</code>).</p>
    66	  <p><strong>Concrete failure:</strong> User A adds a class association to a project. User B, from a snapshot that hasn't received A's change, marks a different material complete and autosaves. Each autosave replaces the entire week map — B's later write can silently remove A's association; A's later write can revert B's material update. A live listener on this data narrows the window but doesn't make the read-modify-write atomic.</p>
    67	
    68	  <h3>4. Prep Cycle configuration (MEDIUM)</h3>
    69	  <p><strong>File:</strong> <code>js/app.js</code>, <code>openPrepCycleEditModal()</code> captures <code>config.phases</code> (~7634-7647), builds a complete <code>newPhases</code> array (~7734-7743), then <code>savePrepCycleConfig()</code> (<code>firebase-data.js:313-321</code>) replaces the whole document via <code>.set(toSave)</code>.</p>
    70	  <p><strong>Concrete failure:</strong> two admins with this modal open concurrently, editing different phases or goal/day arrays — the later full-array write discards the earlier admin's edit entirely.</p>
    71	
    72	  <h3>5. Diagnostic dismissals (LOW — self-healing, lowest priority)</h3>
    73	  <p><strong>File:</strong> <code>js/firebase-data.js</code>, <code>saveDiagDismissals()</code> (636-648), called from three sites in <code>app.js</code> (~8799, 8821, 8868). Same pattern: <code>loadDiagDismissals()</code> → mutate a local nested map → <code>saveDiagDismissals(dismissals)</code>, plain <code>.set()</code>. A nested map keyed by semester/fingerprint, not a literal array, so it falls slightly outside the exact "array field" framing of the others. Worst case if two admins dismiss different diagnostics concurrently: one dismissal silently reappears — annoying, not data loss, self-corrects the next time someone dismisses it again.</p>
    74	
    75	  <h3>6. (Already fixed, in the companion plan) Cut Bank — <code>curriculum/cutProjects</code></h3>
    76	  <p>Named here only for completeness of the pattern's known instances. <strong>Genuinely, completely closed</strong> as of the companion plan's Phase 13/17 (round 9, verified round 10) — <code>cutProject()</code> uses <code>arrayUnion()</code>, <code>pasteFromCutBank()</code> and <code>deleteCutProject()</code> use <code>arrayRemove()</code>, and both round-10 reviewers independently confirmed via exhaustive grep that these three are the ONLY functions that ever touch <code>currentCutProjects</code>. No further work needed here — do not re-open.</p>
    77	
    78	  <h3>7. Admin grid move/swap — <code>curriculum/lessonData</code>, stale-cached-input overwrite (HIGH — added Aug 15, 2026, from the Phases 1-6 backtracking audit's round 4 review)</h3>
    79	  <p><strong>File:</strong> <code>js/app.js</code>, <code>handleGridAction()</code>'s move and swap branches, backed by <code>js/firebase-data.js</code>'s <code>saveMultipleLessonFields()</code> (a new helper added by the backtracking audit plan's Phase 9). <strong>A different shape from instances 1-5 above:</strong> those are all about a write that ISN'T atomic — a local read-modify-write racing against another admin's concurrent write to the same document. This instance is about a write that already IS atomic (one Firestore <code>.update()</code> call, guaranteed all-or-nothing by <code>saveMultipleLessonFields()</code>'s single-document design) but whose CONTENT can still be stale — <code>movedLesson</code>/<code>swappedSource</code>/<code>swappedDest</code> are built from a <code>currentLessonData</code> snapshot taken at grid-click time, with no freshness check before the atomic write fires.</p>
    80	  <p><strong>Concrete failure, confirmed by Codex's round-4 review of the backtracking audit plan (not hypothetical):</strong> Admin A opens the grid with a stale cached copy of a lesson (version S1). A teacher, separately, saves fresh content to that same lesson (version S2 lands on the server). Admin A, unaware, moves or swaps lesson S1. The atomic write succeeds exactly as requested — but it writes S1's content to the destination and deletes the source, silently discarding the teacher's S2 edit with no error, no warning, and no trace. The write's atomicity (a real, valuable property this instance's sibling — the backtracking audit plan's Phase 9 — genuinely achieves) says nothing about whether the CONTENT being atomically written is current.</p>

exec
/bin/zsh -lc "nl -ba js/firebase-data.js | sed -n '150,195p'
rg -n \"settings-link|data-tab=\\\"settings\\\"|switchTab\\('settings'\\)|#settings|footer-dot\\.write-control|write-control\" css js index.html e2e --glob '"'!e2e/test-results/**'"'
rg -n \"deleteLessonData\\(\" js e2e --glob '"'!e2e/test-results/**'"'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
   150	// banner and every writer refuses — see loadConfig().
   151	let configLoadFailed = false;
   152	
   153	// appData decides what every semester is. Until Phase 1 a read error here fell
   154	// back to getDefaultConfig() — a plausible-looking Spring-only configuration —
   155	// and the old whole-document saveConfig() would then write those defaults over
   156	// the real thing on the next save. That is the May 2026 failure mode named in
   157	// CLAUDE.md, in the one document that can express it worst. Now:
   158	//   • document present            → use it
   159	//   • document confirmed ABSENT   → the initialisation state: defaults in
   160	//                                   memory, writes allowed (updateAppData()
   161	//                                   creates the document via its merge-set)
   162	//   • read FAILED (any error)     → loud: configLoadFailed, the red banner,
   163	//                                   lesson data is never loaded, and
   164	//                                   lessonDataLoadedSuccessfully = false makes
   165	//                                   every writer in the app refuse.
   166	// Blast radius of that last branch is the whole app for every user, by design:
   167	// loud beats silent when the alternative is writing over real configuration.
   168	async function loadConfig() {
   169	  if (!curriculumDb) initCurriculumFirestore();
   170	  configLoadFailed = false;
   171	  try {
   172	    const doc = await curriculumDb.collection('curriculum').doc('appData').get();
   173	    currentConfig = doc.exists ? doc.data() : getDefaultConfig();
   174	  } catch (err) {
   175	    console.error('❌ Could not read curriculum/appData — refusing to guess at the configuration:', err);
   176	    configLoadFailed = true;
   177	    lessonDataLoadedSuccessfully = false;
   178	    currentConfig = null;
   179	    showConfigLoadErrorBanner(err);
   180	  }
   181	  return currentConfig;
   182	}
   183	
   184	function showConfigLoadErrorBanner(err) {
   185	  const banner = document.getElementById('lesson-load-error-banner');
   186	  if (!banner) return;
   187	  const denied = err?.code === 'permission-denied';
   188	  const msg = denied
   189	    ? "Can't read the app configuration — check Firestore rules. Nothing was changed, and saving is disabled until this is fixed."
   190	    : "Can't read the app configuration — check your connection. Nothing was changed, and saving is disabled until this is fixed.";
   191	  const target = banner.querySelector('[data-role="message"]') || banner;
   192	  target.textContent = msg;
   193	  banner.classList.remove('hidden');
   194	}
   195	
js/app.js:329:    document.querySelector('.tab-btn[data-tab="settings"]')?.style.setProperty('display', 'none');
js/app.js:360:  document.getElementById('settings-link')?.addEventListener('click', (e) => {
js/app.js:362:    switchTab('settings');
js/app.js:10753:        + `<button class="btn-secondary write-control" onclick="resyncCampSeasonFromRegistry()" style="margin-left:6px;">Re-sync from Summer Camp App</button>`;
js/app.js:10864:      <button class="btn-secondary write-control" onclick="dryRunSemesterTypeStamps()">Dry run</button>
js/app.js:10865:      <button class="btn-primary write-control" id="stamp-types-btn" onclick="applySemesterTypeStamps()" disabled>Stamp semester types</button>
js/app.js:12530:      ${planner ? `<button class="btn-primary write-control" onclick="openDayOffEventEditor(null)" ${dis}>+ Add event</button>` : '<span class="settings-hint">View only — events and camps are planned by Christie and Anika.</span>'}
js/app.js:12562:          <button class="btn-text write-control" onclick="openDayOffCampEditor('${sdocEscA(ev.id)}', '${sdocEscA(c.id)}')" ${dis}>Edit</button>
js/app.js:12563:          <button class="btn-text write-control" onclick="removeDayOffCamp('${sdocEscA(c.id)}')" ${dis}>Remove</button>` : ''}
js/app.js:12575:            <button class="btn-secondary write-control" onclick="openDayOffCampEditor('${sdocEscA(ev.id)}', null)" ${dis}>+ Add camp</button>
js/app.js:12576:            <button class="btn-text write-control" onclick="openDayOffEventEditor('${sdocEscA(ev.id)}')" ${dis}>Edit</button>
js/app.js:12577:            <button class="btn-text write-control" onclick="removeDayOffEvent('${sdocEscA(ev.id)}')" ${dis}>Remove</button>` : ''}
index.html:54:    <button class="tab-btn write-control active" data-tab="curriculum-admin">Curriculum Admin</button>
index.html:57:    <button class="tab-btn write-control" data-tab="settings">Settings</button>
index.html:472:          <button class="btn-secondary write-control" onclick="addTeacherName()" style="margin-top: 12px;">+ Add Teacher</button>
index.html:498:        <button class="btn-secondary write-control" onclick="addClassRow()" style="margin-top: 12px;">+ Add Class</button>
index.html:499:        <button class="btn-secondary write-control" onclick="resetClassRoster()" style="margin-top: 12px; margin-left: 8px;">Reset to Defaults</button>
index.html:514:      <a href="#" id="settings-link" class="footer-link write-control">Settings</a>
index.html:515:      <span class="footer-dot write-control">&middot;</span>
e2e/day-off-camps.spec.js:344:      await page.click('.tab-btn[data-tab="settings"]');
e2e/day-off-camps.spec.js:453:      await page.click('.tab-btn[data-tab="settings"]');
e2e/day-off-camps.spec.js:455:      await page.fill('#settings-semester-name', 'TEST renamed but unsaved');
e2e/day-off-camps.spec.js:459:      await expect(page.locator('#settings-semester-name')).toHaveValue('TEST renamed but unsaved');
e2e/day-off-camps.spec.js:473:      await page.click('.tab-btn[data-tab="settings"]');
e2e/day-off-camps.spec.js:477:    await expect(page.locator('#settings-semester-name')).toHaveValue('Summer 2026');
e2e/day-off-camps.spec.js:480:    await expect(page.locator('#settings-semester-name')).toHaveValue('TEST SDOC 2026-27');
e2e/day-off-camps.spec.js:482:    await expect(page.locator('#settings-end-date')).toHaveValue('2027-05-31');
e2e/day-off-camps.spec.js:484:    await expect(page.locator('#settings-semester-name')).toHaveValue('Spring 2026');
e2e/day-off-camps.spec.js:494:    await page.click('.tab-btn[data-tab="settings"]');
e2e/day-off-camps.spec.js:495:    await expect(page.locator('#settings-semester-name')).toHaveValue('Summer 2026');
e2e/day-off-camps.spec.js:499:    await page.evaluate(() => document.getElementById('settings-link').click());
e2e/day-off-camps.spec.js:500:    await expect(page.locator('#settings-semester-name')).toHaveValue('Spring 2026');
e2e/day-off-camps.spec.js:502:    await page.fill('#settings-num-weeks', '17');
e2e/day-off-camps.spec.js:504:    await page.click('.tab-btn[data-tab="settings"]');
e2e/day-off-camps.spec.js:505:    await expect(page.locator('#settings-num-weeks')).toHaveValue('17');
e2e/day-off-camps.spec.js:513:      await expect(page.locator('#settings-semester-name')).toHaveValue('Summer 2026');
e2e/day-off-camps.spec.js:639:      await page.click('.tab-btn[data-tab="settings"]');
e2e/day-off-camps.spec.js:644:      await expect(page.locator('#settings-end-date')).toHaveValue('2027-05-31');
e2e/day-off-camps.spec.js:654:      await page.fill('#settings-end-date', '2026-11-01');
e2e/day-off-camps.spec.js:661:      await page.fill('#settings-end-date', '2027-06-15');
css/styles.css:172:#settings-semester-select {
css/styles.css:243:.read-only .write-control {
css/styles.css:6172:  #overview, #settings {
e2e/helpers/firestore.js:244:// Mirrors js/firebase-data.js's deleteLessonData(). This is a whole-semester
js/app.js:4585:      await deleteLessonData(key);
js/app.js:4904:      // state even when its server-side deleteLessonData() fails (warn-only),
js/app.js:4994:        await deleteLessonData(key);
js/firebase-data.js:961:async function deleteLessonData(semesterKey) {
e2e/data-safety.spec.js:4102:  // its server-side deleteLessonData() fails, and config has no live listener

exec
/bin/zsh -lc "wc -l /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-r{1,2,3}-claude.md
nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-r1-claude.md | sed -n '1,260p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
      62 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-r1-claude.md
      62 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-r2-claude.md
      28 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md
     152 total
     1	I read the plan in full and verified every "what exists today" claim against the worktree at `2ef2e62`. Most of the research is accurate. Three findings would stop or mislead execution, and there are several smaller ones.
     2	
     3	## Claims I confirmed
     4	
     5	- `activeSemester` set-only-when-missing — `js/app.js:11318-11319`, `:11247` ✓
     6	- What it controls — `app.js:68, 76, 818, 4492-4496, 4514-4522, 4530, 4590, 10687, 10702-10705` ✓
     7	- It does *not* move returning users — `app.js:13, 65-70, 96-100` ✓
     8	- `getActiveSemesterKey()` returns the *selection* first — `js/firebase-data.js:3117-3123`; `getCurrentWeekNum()` follows it via `getActiveSemester()` — `app.js:1243-1244` ✓. `getTvSemKey()` (`app.js:635-638`) and `getSettingsSemKey()` (`app.js:10659-10661`) are both aliases of it.
     9	- "Active" ≠ visible — `canSeeSemester()` `app.js:277-284` ✓
    10	- `updateAppData` one `update()` of named paths, refuses on failed load / bad registry — `firebase-data.js:212-239` ✓
    11	- `toggleSemesterPublish` is the right template — `app.js:4604-4630` ✓
    12	- No live config listener — only reference to `setupConfigListener` outside its own definition is the comment at `app.js:11328` ✓
    13	- **No other Tinker app reads `activeSemester`** ✓ — and I checked wider than the plan's list. The only cross-app reader of the `curriculum` collection is `studio-hub/js/alerts.js:562`, which reads `curriculum/lessonData` and iterates *all* semesters (`:573`), plus `summer-camp-app/scripts/backup-firestore.js:39` which just backs the collection up. Neither depends on the active flag. `summer-camp-app`'s `'curriculum'` (`js/app.js:85`, `js/config.js:63`) is its own tab/field name, not this collection.
    14	- No rules change needed ✓ — `studio-hub/firestore.rules:652-669` is document-level; a new **field** on `curriculum/appData` needs nothing. And `settingsFieldPathsFor` + `extraPaths` (`app.js:11295-11319`) only ever write `semesters.<key>.*`, `teacherMappings`, `activeSemester`, so a Settings save can't clobber `activeSemesterSwitchAt`.
    15	
    16	## High — these block or mislead
    17	
    18	**1. The e2e setup can't write `appData`. `e2e/helpers/firestore.js` signs in as a non-manager.**
    19	`getDb()` signs in as `TEST_ACCOUNT` (`helpers/firestore.js:57`) = `e2e-admin-uid`, `role: staff`, `appAccess: ['classbook','curriculum-admin']` (`e2e/emulators/config.js:42-49`, `e2e/fixtures/seed/users.json`). The rules deny exactly that: `allow create, update: if (…) && docId != 'appData'` (`firestore.rules:666-669`). There is no appData helper in that file. So "adds a test-only weekly semester to `appData` in `beforeEach` through the emulator helper" fails on the first hook.
    20	
    21	Worth knowing *why* this has never bitten: **no spec has ever written `appData` for real.** Every existing appData test stubs `window.updateAppData` and asserts the payload (`data-safety.spec.js:3947-3949, 7596-7610, 7774, 7789`). Your spec would be the first to mutate shared emulator config. I'd follow the house pattern — stub-and-assert-payload for the shape scenarios, plus one real manager write for the round-trip and one real non-manager write for the rules refusal — rather than inventing a manager-authenticated helper and a restore protocol.
    22	
    23	**2. Phase 1's UI premise is wrong: the Settings "Editing Semester" dropdown can't select anything.**
    24	`index.html:411` is `onchange="loadSettingsForm()"` — nothing else binds it. `getSettingsSemKey()` returns the *header's* `globalSemesterKey`, and `loadSettingsForm()` rebuilds the options with `selected` on that key (`app.js:10681-10689`). So picking Fall 2026 there redraws the form for the current semester and snaps the dropdown back. Today the only way to get Settings onto a non-active semester is the header dropdown — which changes the whole app's semester.
    25	
    26	Every Phase 1 acceptance bullet and BDD line reads "Editing Semester = Fall 2026" as though that control works. Either fix it in Phase 1 (`onchange="setGlobalSemester(this.value)"`) or reword to the header semester. Please confirm by hand in the running app before deciding — this is a behaviour I read off the source, not off a browser.
    27	
    28	**3. Making Fall active silently arms the Delete button on Spring 2026.**
    29	`deleteSemester` refuses only `key === currentConfig.activeSemester` (`app.js:4530-4533`), and `renderSemesterSelector` renders the 🗑 Delete button only for non-active semesters (`app.js:4522`). The moment Fall becomes active, Spring 2026 gains a Delete button in Curriculum Admin — and for a weekly semester that path runs `deleteLessonData(key)` (`firebase-data.js:961-966`), a `FieldValue.delete()` of the entire semester's lesson map. That is the most destructive button in the app, newly exposed on the semester holding a year of real lessons, at exactly the moment everyone's attention is on the new term. The plan doesn't mention it anywhere. At minimum it belongs in the safety section and the confirmation text; I'd also add a lesson-count second confirm for a weekly delete, and a BDD scenario.
    30	
    31	## Medium
    32	
    33	**4. The "old semester is a draft" warning is false, and contradicts the plan's own research.** Phase 1 proposes "Spring 2026 is a draft, so teachers will stop seeing it." Teachers never saw it: `canSeeSemester` returns false for any `published === false` semester regardless of active (`app.js:282`) — which your own row at plan line 53 says. Drop that line. The real inconsistency is in the other direction: `app.js:10705` renders "Active Semester — always visible to teachers" while `10704` hides the publish toggle, so an unpublished active semester is invisible *and* unpublishable from the UI. Phase 1's auto-publish makes that badge honest going forward — say so as an intended fix.
    34	
    35	**5. Phase 2 stores a time, not a target.** `activeSemesterSwitchAt` says "someone asked for a switch at T"; the browser then lands on whatever `activeSemester` is at load time. Sequence: Fall made active, ticked (T1) → before all browsers have loaded, someone makes Summer active, unticked → those browsers jump to Summer, which nobody asked to switch everyone to. Store `activeSemesterSwitchTo` alongside and apply only if it still equals `activeSemester`, or state the "go to whatever's active" semantics deliberately.
    36	
    37	**6. Marking a switch "seen" for someone who wasn't moved consumes it permanently.** Your invisible-active-semester scenario asserts exactly this. If the semester is published later, that browser is never moved. Narrow window given auto-publish, but make it a decision rather than a side effect.
    38	
    39	**7. Re-rendering the header selector double-binds its change handler.** `initGlobalSemesterSelector` attaches `select.addEventListener('change', …)` at `app.js:86` with no attach-once guard — unlike `renderTvSemesterSelector`, which guards on `select.dataset.listenerAttached` (`app.js:825`). It's already called again at `4724` and `4845` after creating a semester, so the bug pre-exists; `makeSemesterActive` adds another. It matters because `setGlobalSemester` can `switchTab('teacher-view')` and re-run renders (`app.js:102-142`). Add the same guard, or re-render options without re-binding.
    40	
    41	**8. Missed consumer: Teacher View's own selector.** `renderTvSemesterSelector` labels the active semester "(current)" (`app.js:818-819`), and `initTeacherView`'s already-built branch only redraws it conditionally (`app.js:653-655`). Your acceptance lists Settings, header and Curriculum Admin. Add it to the re-render set.
    42	
    43	## Low
    44	
    45	- **`updateAppData` isn't purely one `update()`** — on `not-found` it falls back to `set(nestFieldPaths(payload), {merge:true})` (`firebase-data.js:233-238`). Irrelevant for a document that exists, but the atomicity claim should say so.
    46	- **Rules phrasing.** `classbook`/`classbook-admin`/`curriculum-admin` *can read* `appData` (`firestore.rules:665`); they're denied only create/update. That read is precisely what makes Phase 2 work for teachers — state it positively.
    47	- **Two stale `'spring-2026'` literals** become quietly wrong after the switch: `firebase-data.js:3122` (`|| 'spring-2026'`) and `getDefaultConfig()` `:504`. Both only fire when `currentConfig` is null/absent (a banner state), so no live bug. There's a static ratchet for `summer-2026` (`static-checks.spec.js:45`) but none for this.
    48	- **Phase 2 must write `localStorage.globalSemesterKey` itself** — the `setItem` at `app.js:69` is inside the fallback branch, which your pre-check will make false. The BDD asserts it; the Shape paragraph should too.
    49	- **No saved teacher session exists.** `global-setup.js:63-70` writes only the admin and manager states. `login(page,'teacher')` on the default storageState returns the signed-in *admin* (`helpers/login.js:100-104`). Phase 2's teacher browser needs a blank storageState + `signInViaForm(page,'teacher')`; the creds exist (`login.js:45`, `users.json`). Also note `MANAGER_STATE_PATH` is currently used by no spec — yours would be the first.
    50	- **Leak blast radius.** `workers: 1` (`playwright.config.js:22`) and alphabetical ordering put `active-semester.spec.js` **first**. A leaked `activeSemesterSwitchAt` or semester key would poison `day-off-camps.spec.js:398-411` ("SDOC R6", which drives `initGlobalSemesterSelector` directly) and `day-off-teacher.spec.js:661` ("T20", which reads `currentConfig.activeSemester` to find "the weekly semester"). Restore in `afterEach` **and** `afterAll`, with read-back. `lastUpdated`/`lastUpdatedBy` can't be restored to fixture values — nothing asserts them today, and `app.js:10918` already models ignoring exactly those two in a whole-document diff; copy that for your "only `activeSemester` changed" assertion.
    51	- **Eligibility must use `semesterTypeOf()`/`isWeeklySemester()`** (`firebase-data.js:45-53`), never a key prefix — there's a ratchet against prefix routing (`static-checks.spec.js:108`). Note the seed's `spring-2026` carries no `semesterType` field, so give your test semester an explicit `semesterType: 'weekly'`.
    52	- **Test count**: `^\s*test(` across `e2e/*.spec.js` is **323**, not 327. Re-count at execution time rather than trusting the number.
    53	
    54	## BDD gaps (a partial implementation could still pass)
    55	
    56	Missing: (a) a payload-keys assertion for the auto-publish case, in the house style `expect(Object.keys(payload).sort()).toEqual([...])` (`data-safety.spec.js:7610`); (b) "a second tab already open is unaffected until reload" — Phase 2 asserts this in prose, nothing tests it; (c) the manager who performs the switch is themselves subject to it on their next load; (d) a UI-level check that the button is absent for a non-manager (cheap — `setupRoleAccess` hides Settings at `app.js:328-329`); (e) `updateAppData` refusing because `seasonRegistryMode` is `error`/`unknown` (`firebase-data.js:221-223`) — a live failure mode of this exact button, and the one most likely to hit Christie mid-term-change.
    57	
    58	## On your other questions, plainly
    59	
    60	- **Safety invariants**: the write shape is right — named dotted paths, awaited, exact restore including "field was absent", no new collection, no rules change. My objections are about the two *consequences* the plan doesn't name (finding 3) and the e2e mechanics (finding 1), not the write itself.
    61	- **Multiple tabs / shared devices / clock skew**: the design holds. Tabs are consistent because `globalSemesterKey` is shared localStorage; a shared studio device consumes the switch once and every subsequent user on it lands on the new semester anyway, which is what you want; the not-equal comparison does neutralise skew as claimed. Ordering relative to `app.js:65-70` is correct — pre-setting a visible key makes the condition at `:65` false, so it won't override you, and nothing reads `globalSemesterKey` between `app.js:13` and the call at `:158`. First load after deploy moves nobody (verified: nothing reads the field until it exists).
    62	- **The plan's Q1/Q2 recommendations** both look right to me; Q1 in particular is forced by `getCurrentWeekNum` only meaning anything for weekly semesters.

codex
## Verdict: NOT EXECUTION-READY

Revision 3 resolves the prior reviews’ main findings, but five changes are still required. Two affect production correctness, one affects destructive-data safety, and two make the proposed e2e assertions invalid.

### 1. Unticking “switch everyone” can reactivate an old switch

Phase 2 says an unticked activation writes no `activeSemesterSwitch` ([plan:214](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:214>)). That leaves the previous switch record in Firestore.

Concrete failure:

1. Fall is activated with the box checked: `{to: "fall-2026", at: T1}`.
2. Summer is activated unchecked. The old Fall switch becomes stale.
3. Fall is later activated unchecked.
4. A browser that has never loaded since T1 sees `sw.to === activeSemester` and moves to Fall—even though the latest activation explicitly left the box unchecked.

This violates “with it unticked, nobody’s remembered semester moves” ([plan:187](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:187>)).

Required change: every unchecked activation must atomically delete `activeSemesterSwitch`, not omit the field. Add the three-activation regression above.

### 2. “Once per browser” does not mean “switch every user”

`globalSemesterKey` is browser-wide localStorage ([app.js:13](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:13), [app.js:96](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:96)). The proposed `activeSemesterSwitchSeen` is also browser-wide.

Concrete shared-device failure:

1. Teacher A opens the shared browser, consumes T1, then selects Spring and signs out.
2. Teacher B signs in for the first time.
3. The browser has `seen=T1` and `globalSemesterKey=spring-2026`, so B is not switched.

That contradicts “every user … once” ([plan:184](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:184>)). The prior review’s claim that later users necessarily remain on the target is false once the first user changes the shared selection.

Required change: either explicitly change the promise to “once per browser,” or namespace the seen marker by authenticated UID. The latter matches the UI wording “switch everyone.”

### 3. Weekly deletion remains non-atomic and lacks the required snapshot

The modal is safer, but the destructive operation is not. Current order is:

1. Delete `semesters.<key>` from appData ([app.js:4562-4566](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4562)).
2. Delete `lessonData.<key>` separately ([app.js:4581-4586](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4581)).
3. Swallow failure of step 2 with only `console.warn`.

Concrete failure: the fresh lesson count succeeds, the appData deletion succeeds, then the lesson-data update fails due to a transient network error. The semester disappears from every selector while all its lessons remain orphaned and inaccessible through the app.

The plan also says “No bulk op, no delete: no snapshot needed” ([plan:253](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:253>)), although Phase 1 explicitly deletes an entire semester lesson map. That conflicts with the repository’s snapshot-before-bulk-delete requirement.

The statement that cut bank and history “stay” also needs qualification: they remain in Firestore, but removing the semester registry entry makes them unavailable through normal Classbook navigation.

Required change:

- Snapshot the forced-server lesson map and abort if the snapshot fails.
- Delete the appData entry and lessonData map atomically in one Firestore batch/transaction.
- Add a failure test proving neither document changes if the atomic commit fails.
- Say that cut bank/history remain stored but become inaccessible unless the same semester key is restored.

### 4. Activation trusts stale local config and can create a ghost active semester

The planned validation checks only `currentConfig.semesters`, but config is loaded once ([app.js:151-158](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:151)); the existing listener is unused ([firebase-data.js:521](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:521)).

Concrete failure:

1. Tab A loads Fall.
2. Tab B deletes Fall.
3. Tab A activates Fall.
4. Writing `activeSemester: "fall-2026"` points at a missing semester. If auto-publish is included, the dotted publish update can recreate only `{published:true}`, without its name, dates, type, or roster.

That leaves no legitimate active semester and arms Delete on every complete semester because the active key matches none.

Required change: perform activation in a transaction that verifies the target still exists and the previously confirmed active semester has not changed, then atomically writes active, publish state, and switch creation/deletion. On mismatch, refuse and ask for reload.

### 5. The e2e plan contains two impossible/contradictory scenarios

First, the teacher-switch setup consumes the switch too early. After form sign-in, `requireAuth()` resolves and initialization continues on that same page ([auth-guard.js:31-110](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/auth-guard.js:31)). If appData already contains T1, the teacher’s first load consumes T1 before the test sets remembered Spring. The subsequent reload correctly does nothing, so the proposed happy-path test cannot prove switching.

Stage it as:

1. Sign the teacher in while no switch exists.
2. Set remembered Spring.
3. Write Fall + T1 from a manager context.
4. Reload the teacher page and assert the move.

Second, the Phase 1 happy path says simply “confirm” and expects only `activeSemester` to change ([plan:105-109](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:105>)). In the final Phase 2 build, the checkbox defaults checked ([plan:183](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:183)), so confirming also changes `activeSemesterSwitch`. The test must explicitly untick the box or expect the switch field.

The remaining harness design is workable: emulator-only serving, one worker ([playwright.config.js:17-43](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/playwright.config.js:17)), manager-page cleanup, forced-server read-back, and stubbed Summer activation are appropriate. Do not rely on alphabetical execution for safety; cleanup must remain self-contained.

### Other checks

- I found no additional live readers of `activeSemester` or `globalSemesterKey` beyond the cited Classbook code. The fallback literals in `firebase-data.js` remain non-live/error-state concerns.
- Summer as active does not introduce a hidden lesson-store routing error. It does intentionally hide Prep Dashboard and Curriculum Admin for applicable non-manager roles and makes the active camp non-removable/non-unpublishable.
- The proposed Settings hiding, `switchTab` refusal, role check in `makeSemesterActive`, and Firestore manager-only write rule are sufficient for normal UI access. For a literal “cannot enter the panel” invariant, also reject Settings inside the tab button’s own click handler at [app.js:203](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:203), not only through `switchTab`.
- No files were edited and no tests were run.
tokens used
96,824
## Verdict: NOT EXECUTION-READY

Revision 3 resolves the prior reviews’ main findings, but five changes are still required. Two affect production correctness, one affects destructive-data safety, and two make the proposed e2e assertions invalid.

### 1. Unticking “switch everyone” can reactivate an old switch

Phase 2 says an unticked activation writes no `activeSemesterSwitch` ([plan:214](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:214>)). That leaves the previous switch record in Firestore.

Concrete failure:

1. Fall is activated with the box checked: `{to: "fall-2026", at: T1}`.
2. Summer is activated unchecked. The old Fall switch becomes stale.
3. Fall is later activated unchecked.
4. A browser that has never loaded since T1 sees `sw.to === activeSemester` and moves to Fall—even though the latest activation explicitly left the box unchecked.

This violates “with it unticked, nobody’s remembered semester moves” ([plan:187](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:187>)).

Required change: every unchecked activation must atomically delete `activeSemesterSwitch`, not omit the field. Add the three-activation regression above.

### 2. “Once per browser” does not mean “switch every user”

`globalSemesterKey` is browser-wide localStorage ([app.js:13](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:13), [app.js:96](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:96)). The proposed `activeSemesterSwitchSeen` is also browser-wide.

Concrete shared-device failure:

1. Teacher A opens the shared browser, consumes T1, then selects Spring and signs out.
2. Teacher B signs in for the first time.
3. The browser has `seen=T1` and `globalSemesterKey=spring-2026`, so B is not switched.

That contradicts “every user … once” ([plan:184](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:184>)). The prior review’s claim that later users necessarily remain on the target is false once the first user changes the shared selection.

Required change: either explicitly change the promise to “once per browser,” or namespace the seen marker by authenticated UID. The latter matches the UI wording “switch everyone.”

### 3. Weekly deletion remains non-atomic and lacks the required snapshot

The modal is safer, but the destructive operation is not. Current order is:

1. Delete `semesters.<key>` from appData ([app.js:4562-4566](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4562)).
2. Delete `lessonData.<key>` separately ([app.js:4581-4586](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4581)).
3. Swallow failure of step 2 with only `console.warn`.

Concrete failure: the fresh lesson count succeeds, the appData deletion succeeds, then the lesson-data update fails due to a transient network error. The semester disappears from every selector while all its lessons remain orphaned and inaccessible through the app.

The plan also says “No bulk op, no delete: no snapshot needed” ([plan:253](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:253>)), although Phase 1 explicitly deletes an entire semester lesson map. That conflicts with the repository’s snapshot-before-bulk-delete requirement.

The statement that cut bank and history “stay” also needs qualification: they remain in Firestore, but removing the semester registry entry makes them unavailable through normal Classbook navigation.

Required change:

- Snapshot the forced-server lesson map and abort if the snapshot fails.
- Delete the appData entry and lessonData map atomically in one Firestore batch/transaction.
- Add a failure test proving neither document changes if the atomic commit fails.
- Say that cut bank/history remain stored but become inaccessible unless the same semester key is restored.

### 4. Activation trusts stale local config and can create a ghost active semester

The planned validation checks only `currentConfig.semesters`, but config is loaded once ([app.js:151-158](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:151)); the existing listener is unused ([firebase-data.js:521](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:521)).

Concrete failure:

1. Tab A loads Fall.
2. Tab B deletes Fall.
3. Tab A activates Fall.
4. Writing `activeSemester: "fall-2026"` points at a missing semester. If auto-publish is included, the dotted publish update can recreate only `{published:true}`, without its name, dates, type, or roster.

That leaves no legitimate active semester and arms Delete on every complete semester because the active key matches none.

Required change: perform activation in a transaction that verifies the target still exists and the previously confirmed active semester has not changed, then atomically writes active, publish state, and switch creation/deletion. On mismatch, refuse and ask for reload.

### 5. The e2e plan contains two impossible/contradictory scenarios

First, the teacher-switch setup consumes the switch too early. After form sign-in, `requireAuth()` resolves and initialization continues on that same page ([auth-guard.js:31-110](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/auth-guard.js:31)). If appData already contains T1, the teacher’s first load consumes T1 before the test sets remembered Spring. The subsequent reload correctly does nothing, so the proposed happy-path test cannot prove switching.

Stage it as:

1. Sign the teacher in while no switch exists.
2. Set remembered Spring.
3. Write Fall + T1 from a manager context.
4. Reload the teacher page and assert the move.

Second, the Phase 1 happy path says simply “confirm” and expects only `activeSemester` to change ([plan:105-109](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:105>)). In the final Phase 2 build, the checkbox defaults checked ([plan:183](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:183)), so confirming also changes `activeSemesterSwitch`. The test must explicitly untick the box or expect the switch field.

The remaining harness design is workable: emulator-only serving, one worker ([playwright.config.js:17-43](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/playwright.config.js:17)), manager-page cleanup, forced-server read-back, and stubbed Summer activation are appropriate. Do not rely on alphabetical execution for safety; cleanup must remain self-contained.

### Other checks

- I found no additional live readers of `activeSemester` or `globalSemesterKey` beyond the cited Classbook code. The fallback literals in `firebase-data.js` remain non-live/error-state concerns.
- Summer as active does not introduce a hidden lesson-store routing error. It does intentionally hide Prep Dashboard and Curriculum Admin for applicable non-manager roles and makes the active camp non-removable/non-unpublishable.
- The proposed Settings hiding, `switchTab` refusal, role check in `makeSemesterActive`, and Firestore manager-only write rule are sufficient for normal UI access. For a literal “cannot enter the panel” invariant, also reject Settings inside the tab button’s own click handler at [app.js:203](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:203), not only through `switchTab`.
- No files were edited and no tests were run.
