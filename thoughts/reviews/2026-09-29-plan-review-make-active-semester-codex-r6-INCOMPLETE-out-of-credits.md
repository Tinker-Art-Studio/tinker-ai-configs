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
session id: 01a0ee60-0566-7f72-a598-8821fa2047cd
--------
user
## Codex round 6 — revision 8 (design change)
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 8). Your rounds 1–5 are in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex*.md. Read the Decisions Log entry "revision 8": Christie chose to ARCHIVE old class semesters (a semesters.<key>.archived flag; nothing deleted) instead of hardening a hard delete; the listener/fail-closed/save-guard design is removed.
Repo (read-only, main 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Rules: /Users/christiehubley/studio-hub/firestore.rules .
Review the plan as it now stands, adversarially, against the code:
1. Archive design: is every place that lists or iterates semesters covered (all loaded scripts — selectors, copy-from, diagnostics, prep dashboard, material forecasts, backups, change history, anything using Object.keys(currentConfig.semesters) or similar)? Does an archived semester leak anywhere, or break anything (e.g. getActiveSemesterKey fallback, canSeeSemester for managers, createNewSemester, the season registry / camp code, SDOC code)? Is the "can't reuse an archived key" check placed correctly relative to createNewSemester's existing checks?
2. Anything from your rounds 1–5 that the removal reopened (activation transaction, per-user switch, unticked clears switch, Settings gating, header sync)?
3. Tests: workable and non-leaking?
Verdict: EXECUTION-READY or NOT (minimum list). Be concise. Do not edit files or run tests.
codex
I’ll cross-check revision 8 against the current scripts and rules, then compare the prior review findings. I’ll keep this read-only and won’t run tests.
exec
/bin/zsh -lc "sed -n '1,260p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html && rg -n \"revision 8|Revision 8|Decisions Log\" /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html && for f in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex*.md; do echo \"FILE:"'$f"; sed -n '"'1,240p' \""'$f"; done' in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
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
  <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Christie answered Q1/Q2. Three Claude rounds, then Codex's independent review: NOT ready (5 findings). Revisions 4–8 address them (revision 8: archive instead of delete, per Christie). Codex confirmation round 6 is next.
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
      <li>Old semester is a weekly class semester: "Spring 2026 stays available. You can archive it from Curriculum Admin to hide it; nothing is deleted."</li>
      <li>New semester is a camp season: "While Summer 2026 is active it can't be removed or unpublished — make another semester active first."</li>
    </ul></li>
  <li>After confirming, every place that labels the active semester updates without a reload: the header, Teacher View ("(current)"), Settings' badge/toggle, and Curriculum Admin's badge/toggle/Archive.</li>
  <li><strong>Old class semesters are archived, not deleted</strong> (Christie, Sep 29). For a non-active Fall/Spring semester, Curriculum Admin's 🗑 <strong>Delete</strong> becomes <strong>Archive</strong>. Archiving hides the semester from every semester list (header, Teacher View, Curriculum Admin, Settings, the "Copy from" list) and <strong>deletes nothing</strong>: its lessons, cut bank, change history, prep data, backups and dismissals all stay exactly where they are. A manager can bring it back from a new <strong>"Archived semesters"</strong> list in Settings (Unarchive). The confirmation says so in plain words, with no typed name needed because nothing is lost. The active semester can't be archived, and an archived semester can't be made active (unarchive it first). There's no longer any way to hard-delete a class semester from the app. That could come back later as its own reviewed plan.</li>
  <li>Camp seasons and SDOC years keep their current Delete flows. Those already delete no lessons: a camp removes only its Classbook entry, and an SDOC year refuses while it has events.</li>
  <li>If the write fails for any reason (rules, a failed config load, or the season registry being unknown or in error), nothing changes on screen and an alert names the reason and says "Nothing was changed."</li>
  <li>Nobody below manager sees the control: it's rendered only for <code>admin</code>/<code>manager</code> roles, <code>makeSemesterActive</code> refuses otherwise, and the rules refuse the write regardless.</li>
</ul>
<p><strong>Shape:</strong></p>
<ul>
  <li><code>index.html:411</code>: a new <code>onSettingsSemesterChange(value)</code> that does what Teacher View's selector does (<code>app.js:826-830</code>): set <code>#global-semester-select</code>'s value <em>first</em>, then <code>setGlobalSemester(value)</code>. Without the header sync, the header would keep showing the old semester and re-picking it would fire no change event (round 2, finding 1). Settings' options are filtered by <code>canSeeSemester</code>, like the header's.</li>
  <li><code>setupRoleAccess</code> (<code>app.js:318-336</code>): hide <code>#settings-link</code> and its dot (<code>.footer-dot.write-control</code>; other <code>.footer-dot</code>s stay) for non-managers too. <code>switchTab('settings')</code>, the footer handler, <strong>and the tab button's own click handler</strong> (<code>app.js:203</code>) refuse for non-managers.</li>
  <li>New <code>makeSemesterActive(key)</code> beside <code>toggleSemesterPublish</code>. Eligibility is by type (<code>isWeeklySemester(key) || isCampSeason(key)</code>), never by key prefix (there's a ratchet against prefix routing). It refuses if the user isn't admin/manager, or the key is missing or already active. It checks <code>isPublishableType(key)</code> before any auto-publish, so the two gates can't drift. The old semester's name falls back to its key if the name is missing. Then it confirms through <code>confirmModal</code> (built in this phase, so Phase 2 only adds the checkbox and the activation tests aren't rewritten), then writes through a new <code>activateSemesterTx(key, expectedActive, { publish, switchEveryone })</code> in <code>firebase-data.js</code> (Codex finding 4). It's one <code>runTransaction</code> that re-reads appData from the server and refuses, with "reload and try again", unless <code>semesters[key]</code> still exists with a name and an eligible type, and <code>activeSemester === expectedActive</code> (what the confirmation showed). Only then does it <code>tx.update</code> <code>activeSemester</code>, the publish flag if needed, the Phase 2 switch field, and <code>lastUpdated</code>/<code>lastUpdatedBy</code>. This way a stale tab can't point "active" at a semester another tab deleted, or recreate a half-semester through the dotted publish path. It honours the same guards as <code>updateAppData</code>. <code>currentConfig</code> changes only after the commit succeeds; on failure nothing local changes.</li>
  <li>Re-render set after success or failure: header options, Teacher View selector, <code>renderSemesterSelector()</code>, <code>loadSettingsForm()</code>. The header's <code>change</code> listener gets the attach-once guard Teacher View already uses (<code>dataset.listenerAttached</code>), so re-rendering doesn't stack handlers.</li>
  <li><strong>Archive (replaces the weekly branch of <code>deleteSemester</code>):</strong> new <code>archiveSemester(key)</code> and <code>unarchiveSemester(key)</code> write only <code>semesters.&lt;key&gt;.archived</code> (<code>true</code> / <code>FieldValue.delete()</code>) through a small transaction. It re-reads appData, refuses if the key is missing or is the active semester, then <code>tx.update</code>s that one path plus <code>lastUpdated</code>/<code>lastUpdatedBy</code>, with <code>updateAppData</code>'s guards. The weekly branch's <code>updateAppData(semesters.&lt;key&gt; delete)</code> + <code>deleteLessonData(key)</code> path is removed. <code>deleteLessonData</code> stays for its other caller, the failed-create cleanup (<code>app.js:4994</code>), which is unchanged. The camp and SDOC branches are unchanged. The confirmation uses the shared <code>confirmModal</code>.</li>
  <li><strong>One helper decides what's listed:</strong> <code>isArchivedSemester(key)</code> (reads <code>semesters[key].archived === true</code>). Every semester list filters it out: header (<code>app.js:56-60</code>, via <code>canSeeSemester</code>), Teacher View (<code>:803</code>), Curriculum Admin bar (<code>:4479</code>), Settings (<code>:10683</code>), and the "Copy from" list (<code>:4499-4506</code>). The executor re-checks with <code>grep -n "semesters)" js/*.js</code>. <code>canSeeSemester()</code> returns false for an archived semester for everyone, so the existing guard at <code>app.js:65</code> moves a browser that remembered it to the active semester on its next load. Reading a lesson doc directly isn't affected.</li>
  <li><strong>Settings → "Archived semesters"</strong> (managers only): lists archived keys by name, each with Unarchive. It's empty and hidden when there are none.</li>
  <li><strong>Creating a semester whose key belongs to an archived one</strong> (<code>createNewSemester</code>) refuses: "An archived semester already uses this name — unarchive it in Settings instead." The existing checks are unchanged otherwise.</li>
  <li><strong>Stale tabs are a non-issue by design:</strong> nothing is deleted, so a tab still open on an archived semester saves into lessons that still exist. They reappear on unarchive. No listener and no save-path changes are needed. The three existing weekly-delete tests in <code>data-safety.spec.js</code> (around 7778-7790, 8537, and "a refused delete or publish toggle reverts this tab") are rewritten for archive semantics in the same commit. Camp and SDOC delete tests are untouched.</li>
  <li>Unchanged and fine: Studio Hub's unanswered-question alerts (<code>studio-hub/js/alerts.js:559-580</code>) iterate every semester in <code>lessonData</code>, so an archived semester's open questions still alert, exactly as a non-deleted Spring does today.</li>
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

Scenario: archiving an old class semester hides it and deletes nothing (safety)
  Given Spring 2026 is not active and has lessons, cut bank and change history (manager session, real write)
  When the manager clicks Archive on it and confirms
  Then appData.semesters.spring-2026.archived = true and nothing else in appData changed (ignoring lastUpdated/By)
   And curriculum/lessonData, cutProjects, changeLog, prepData for spring-2026 read back byte-identical
   And Spring 2026 is absent from the header, Teacher View, Curriculum Admin, Settings and "Copy from" lists

Scenario: unarchive brings it back (happy path)
  When the manager clicks Unarchive in Settings → Archived semesters
  Then the archived field is removed and Spring 2026 is listed everywhere again with all its lessons

Scenario: a browser that remembered an archived semester (edge)
  Given a teacher's browser remembers spring-2026, which is then archived
  When they load the Classbook
  Then they land on the active semester

Scenario: the active semester can't be archived; an archived one can't be made active (edge)
  Then the active semester shows no Archive, and an archived semester is not listed where "Make active" lives

Scenario: a stale tab keeps saving into an archived semester (edge, harmless)
  Given tab B is open on Spring 2026's lessons when tab A archives it
  When tab B saves a lesson
  Then the save succeeds into existing data, and after Unarchive the change is there

Scenario: a new semester can't reuse an archived key (edge)
  When a manager creates a semester whose key matches an archived one
  Then it refuses and points to Unarchive; nothing is written

Scenario: camp and SDOC deletes are unchanged (regression)
  Then the existing camp-removal and SDOC-year delete tests pass unmodified

Scenario: a stale tab can't activate a deleted semester (failure, Codex finding 4)
  Given tab A loaded Fall; the Fall entry is then deleted on the server
  When tab A makes Fall active
  Then the transaction refuses, asks for a reload, and appData.activeSemester and semesters are unchanged
   (no semesters.fall-2026 = {published:true} ghost)

Scenario: someone changed "active" meanwhile (failure)
  Given tab A's confirmation showed Spring as active, but the server now says Summer
  When tab A confirms
  Then it refuses and asks for a reload

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
  Then they land on Fall 2026, localStorage.globalSemesterKey = "fall-2026", activeSemesterSwitchSeen = T1
  When they pick Spring 2026 and reload
  Then they stay on Spring 2026

Scenario: the manager who switched is moved too (edge)
  Given the manager made Fall active with the box ticked, then picked Spring
  When they reload
  Then they land on Fall 2026 once

Scenario: an unticked activation clears an old switch (regression, Codex finding 1)
  Given Fall activated ticked (T1), then Summer activated unticked, then Fall activated unticked
  When a browser that never loaded since T1 loads
  Then it is not moved, and appData has no activeSemesterSwitch

Scenario: a shared computer moves each person once (Codex finding 2)
  Given teacher A on a shared browser consumed T1, then picked Spring and signed out
  When teacher B signs in on that browser for the first time since T1
  Then B is moved to Fall; A, signing in again, is not

37:  <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Christie answered Q1/Q2. Three Claude rounds, then Codex's independent review: NOT ready (5 findings). Revisions 4–8 address them (revision 8: archive instead of delete, per Christie). Codex confirmation round 6 is next.
334:  <li>Read this plan. Check the Decisions Log for Christie's answers to Q1/Q2 and any review findings.</li>
341:<h2 id="decisions">Decisions Log (append-only)</h2>
343:  <strong>Sep 29, 2026: revision 8. Christie chose Archive over hard delete.</strong> Codex round 5 (<code>…-codex-r5.md</code>) was still finding gaps in the hardened hard-delete: <code>saveLessonData</code> runs before a new semester's appData entry exists, so an existence guard would break "Copy from"; and offline detection lags, so stale saves could still resurrect a deleted key. Its minimum was a transaction on every lesson save. Rather than change the app's hottest path for a rare admin action, Christie chose (options: Archive / split out / keep hardening) to <strong>archive old class semesters instead of deleting them</strong>. Removed from the plan: the snapshot download, <code>deleteWeeklySemesterTx</code>, the <code>serverSemesterKeys</code> listener, <code>assertSemesterStillExists</code> and its fail-closed states (so the offline-save behaviour change is gone, and saves are untouched), the lessonData-writer ratchet, and the no-copy "adopt leftovers" confirm. Kept from rounds 1–5: activation by transaction, per-user "switch everyone", clearing the switch when unticked, Settings gating, and the header sync. Permanent deletion of a class semester is no longer offered in the app.
FILE:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-input.md
## Independent review — plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 3, marked execution-ready after three Claude review rounds; those reviews are in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-r{1,2,3}-claude.md — read them so you don't repeat settled points, but do not trust them).
Repo (read-only; main at 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Firestore rules: /Users/christiehubley/studio-hub/firestore.rules .

You are the independent second model. Be adversarial and verify against the code, citing file:line and concrete failing inputs:
1. Anything in Phase 1 or Phase 2 that is unsafe for production data (curriculum/appData, curriculum/lessonData) or would lose/hide data?
2. Anything the three Claude rounds missed: other readers of activeSemester / globalSemesterKey / localStorage keys; interactions with the Summer camp season as active; the "switch everyone" once-per-browser logic; the weekly-delete modal; the Settings access gating.
3. Is the e2e plan workable with the harness in e2e/ and safe for the other specs (shared emulator state, restore)?
4. Verdict: EXECUTION-READY or NOT, with the minimum list of changes.
Do not edit files. Do not run tests.
FILE:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2-input.md
## Codex confirmation round — plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 4). Your previous review: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md. Read the Decisions Log entry "revision 4".
Repo (read-only; main at 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Rules: /Users/christiehubley/studio-hub/firestore.rules .

For each of your five findings and the tab-click-handler item: RESOLVED / NOT RESOLVED, citing plan lines. Then check what revision 4 newly introduced, against the code:
- activateSemesterTx / deleteWeeklySemesterTx: transaction reads/writes across curriculum/appData and curriculum/lessonData — do the rules allow a manager to do both in one transaction? Does anything else write these docs concurrently in a way the transaction mishandles (lesson saves to lessonData are frequent — contention/retries on a large doc)? Do they correctly preserve updateAppData's guards?
- The JSON snapshot download: are cutProjects and changeLog actually keyed by semester in curriculum/cutProjects and curriculum/changeLog? Anything else keyed by the semester that becomes unreachable (prepData? backup)?
- Per-uid seen marker: is getAuthUser().uid available at that point in DOMContentLoaded?
Verdict: EXECUTION-READY or NOT, minimum list. Be brief. Do not edit files or run tests.
FILE:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md
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
session id: 01a0ee51-3e80-7bb2-91dd-d94dc0031bc5
--------
user
## Codex confirmation round — plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 4). Your previous review: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md. Read the Decisions Log entry "revision 4".
Repo (read-only; main at 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Rules: /Users/christiehubley/studio-hub/firestore.rules .

For each of your five findings and the tab-click-handler item: RESOLVED / NOT RESOLVED, citing plan lines. Then check what revision 4 newly introduced, against the code:
- activateSemesterTx / deleteWeeklySemesterTx: transaction reads/writes across curriculum/appData and curriculum/lessonData — do the rules allow a manager to do both in one transaction? Does anything else write these docs concurrently in a way the transaction mishandles (lesson saves to lessonData are frequent — contention/retries on a large doc)? Do they correctly preserve updateAppData's guards?
- The JSON snapshot download: are cutProjects and changeLog actually keyed by semester in curriculum/cutProjects and curriculum/changeLog? Anything else keyed by the semester that becomes unreachable (prepData? backup)?
- Per-uid seen marker: is getAuthUser().uid available at that point in DOMContentLoaded?
Verdict: EXECUTION-READY or NOT, minimum list. Be brief. Do not edit files or run tests.
codex
I’ll compare revision 4 and the prior review directly against the current code and Firestore rules, then give a line-cited readiness verdict. I’ll keep this read-only and won’t run tests.
exec
/bin/zsh -lc "rg -n \"revision 4|Decisions Log|activateSemesterTx|deleteWeeklySemesterTx|snapshot|cutProjects|changeLog|seen|tab|updateAppData\" /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md && rg -n \"match /curriculum|appData|lessonData|cutProjects|changeLog|prepData|backup|updateAppData|getAuthUser|DOMContentLoaded|addEventListener\\(['\\\"]click|activateSemester|deleteWeekly\" /Users/christiehubley/studio-hub/firestore.rules . --glob '"'!node_modules/**'"'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:20:  table { border-collapse: collapse; width: 100%; margin: .75rem 0; }
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:35:  <strong>Context:</strong> Created Sep 29, 2026. Christie asked how to move "active" from Spring 2026 to Fall 2026 and found there is no UI for it. She is doing a one-time console switch meanwhile (<code>await updateAppData({ activeSemester: 'fall-2026' })</code>). Her answer to "want me to plan it?": <em>"yes we should do this."</em><br>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:47:<table>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:55:  <tr><td>All appData writes go through <code>updateAppData(flatPaths)</code>: one <code>update()</code> of only the named paths, refused after a failed config load or a bad season registry.</td><td><code>firebase-data.js:212-240</code></td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:56:  <tr><td>The template to follow is <code>toggleSemesterPublish()</code>: optimistic in-memory change, <code>updateAppData</code>, exact restore plus an alert on failure, then re-render.</td><td><code>app.js:4604-4630</code></td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:57:  <tr><td>Config is read once per page load. There is no live listener (<code>setupConfigListener</code> is never called), so open tabs see a change on their next reload.</td><td><code>firebase-data.js:521</code>, <code>app.js:11328</code></td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:64:  <tr><td>e2e: no spec has ever written appData for real. They stub <code>window.updateAppData</code> and assert the payload. The Node helper signs in as the staff account, which the rules refuse on appData. There is a saved <em>manager</em> session but no saved teacher session.</td><td><code>data-safety.spec.js:3947, 7596-7610</code>; <code>helpers/firestore.js:57</code>; <code>global-setup.js:63-70</code></td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:66:</table>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:76:  <li><strong>Settings is reachable only by managers and admins.</strong> Today curriculum-admin and prep users can open it through the footer "Settings" link, because only the tab button is hidden. That link and its dot get hidden for them as well, and <code>switchTab('settings')</code> refuses for them.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:89:      <li>Before anything is deleted, the Classbook <strong>downloads a JSON snapshot</strong> of that semester: its appData entry, lesson map, cut bank and change history, all read fresh from the server. If a read fails, nothing is deleted.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:99:  <li><code>setupRoleAccess</code> (<code>app.js:318-336</code>): hide <code>#settings-link</code> and its dot (<code>.footer-dot.write-control</code>; other <code>.footer-dot</code>s stay) for non-managers too. <code>switchTab('settings')</code>, the footer handler, <strong>and the tab button's own click handler</strong> (<code>app.js:203</code>) refuse for non-managers.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:100:  <li>New <code>makeSemesterActive(key)</code> beside <code>toggleSemesterPublish</code>. Eligibility is by type (<code>isWeeklySemester(key) || isCampSeason(key)</code>), never by key prefix (there's a ratchet against prefix routing). It refuses if the user isn't admin/manager, or the key is missing or already active. It checks <code>isPublishableType(key)</code> before any auto-publish, so the two gates can't drift. The old semester's name falls back to its key if the name is missing. Then it confirms through <code>confirmModal</code> (built in this phase, so Phase 2 only adds the checkbox and the activation tests aren't rewritten), then writes through a new <code>activateSemesterTx(key, expectedActive, { publish, switchEveryone })</code> in <code>firebase-data.js</code> (Codex finding 4). It's one <code>runTransaction</code> that re-reads appData from the server and refuses, with "reload and try again", unless <code>semesters[key]</code> still exists with a name and an eligible type, and <code>activeSemester === expectedActive</code> (what the confirmation showed). Only then does it <code>tx.update</code> <code>activeSemester</code>, the publish flag if needed, the Phase 2 switch field, and <code>lastUpdated</code>/<code>lastUpdatedBy</code>. This way a stale tab can't point "active" at a semester another tab deleted, or recreate a half-semester through the dotted publish path. It honours the same guards as <code>updateAppData</code>. <code>currentConfig</code> changes only after the commit succeeds; on failure nothing local changes.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:104:      <li>Forced-server reads: <code>readServerSemesterLessonMap(key)</code> plus the semester's <code>cutProjects[key]</code> and <code>changeLog[key]</code>. Any rejection refuses. <code>null</code> means 0 lessons and proceeds.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:106:      <li>A JSON snapshot download: <code>classbook-&lt;key&gt;-snapshot-&lt;ISO&gt;.json</code> through a Blob link, containing <code>{ appDataEntry, lessons, cutProjects, changeLog, takenAt, takenBy }</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:107:      <li>New <code>deleteWeeklySemesterTx(key)</code> in <code>firebase-data.js</code>: one <code>runTransaction</code> (the house pattern, e.g. <code>firebase-data.js:2452</code>) that re-reads appData and verifies <code>semesters[key]</code> still exists and <code>activeSemester !== key</code>. It then <code>tx.update</code>s appData (<code>semesters.&lt;key&gt;</code> delete, plus <code>lastUpdated</code>/<code>lastUpdatedBy</code>) and lessonData (<code>&lt;key&gt;</code> delete). It honours <code>updateAppData</code>'s guards (<code>configLoadFailed</code>, season registry).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:109:    The old two-write path and its warn-only catch are removed for weekly semesters. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:127:Scenario: making a draft semester active publishes it (edge) — stubbed updateAppData
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:130:  Then exactly one updateAppData call, and
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:137:       Prep Dashboard hidden (as for any camp selection); Teacher View and Curriculum Admin render as they do when Summer is merely selected (so a curriculum-admin/prep user with nothing remembered lands with the Curriculum Admin tab hidden, as today for Summer)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:142:  Then the Prep Dashboard tab reappears for Fall
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:146:  Then updateAppData is not called and nothing on screen changes
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:154:  Then the Settings tab button AND the footer "Settings" link are hidden
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:169:  When updateAppData({ activeSemester: "spring-2026" }) is called
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:182:       (updateAppData and deleteLessonData not called)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:189:Scenario: a snapshot is taken first (safety)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:191:  Then a download named classbook-<key>-snapshot-*.json happens before the transaction
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:192:   And it contains the appData entry, the lessons, cutProjects and changeLog for that key
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:194:Scenario: a stale tab can't activate a deleted semester (failure, Codex finding 4)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:195:  Given tab A loaded Fall; the Fall entry is then deleted on the server
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:196:  When tab A makes Fall active
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:201:  Given tab A's confirmation showed Spring as active, but the server now says Summer
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:202:  When tab A confirms
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:225:<p><strong>Shape:</strong> the "seen" marker is per signed-in user: <code>localStorage['activeSemesterSwitchSeen:' + uid]</code>. <code>globalSemesterKey</code> stays browser-wide as today. When unticked, the transaction writes <code>activeSemesterSwitch: FieldValue.delete()</code>. When ticked, the same transaction writes <code>activeSemesterSwitch: { to: key, at: new Date().toISOString() }</code>. It must be a <strong>client ISO string</strong>, the way <code>lastUpdated</code> is: a <code>serverTimestamp()</code> reads back as a Timestamp, would never equal the stored string, and would re-switch on every load. Compare <code>String(sw.at)</code>. <strong>Placement is load-bearing:</strong> the check runs <em>once</em> in the <code>DOMContentLoaded</code> sequence, after <code>requireAuth</code> and <code>loadConfig()</code> (<code>app.js:148-152</code>) and before <code>initGlobalSemesterSelector()</code> (<code>:158</code>). Never inside <code>initGlobalSemesterSelector</code>, which is re-called after creating a semester and after <code>makeSemesterActive</code>, and would consume the manager's own switch in the same page load. It's one map field, so it replaces the previous switch whole. On load, before the existing pick at <code>app.js:65</code>, with <code>sw = currentConfig.activeSemesterSwitch</code> and <code>seen = localStorage['activeSemesterSwitchSeen:' + getAuthUser().uid]</code>:</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:227:  <li>If <code>sw</code> is missing, or <code>sw.at === seen</code>: do nothing.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:228:  <li>If <code>sw.to !== currentConfig.activeSemester</code>: the switch is stale, so mark it seen and do nothing.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:229:  <li>If <code>canSeeSemester(sw.to)</code>: set <code>globalSemesterKey = sw.to</code> and <strong>write <code>localStorage.globalSemesterKey</code> here</strong> (the <code>setItem</code> at :69 sits in the fallback branch, which this makes false), then mark it seen.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:230:  <li>Otherwise (can't see it yet): don't move and don't mark it seen.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:232:<p><strong>Decided asymmetry:</strong> a browser that marked a switch seen through the stale branch isn't moved if that same target becomes active again later without a new tick, while a browser that never loaded would be. That's acceptable: a later switch is a new <code>at</code> and moves everyone.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:268:  Then it is not moved, and the switch is marked seen
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:273:  Then not moved, not marked seen; after it is published and they reload, they are moved
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:276:  Given a browser has seen switch A
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:280:Scenario: open tabs are unaffected until reload (edge)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:281:  Given a second tab already open on Spring
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:283:  Then that tab stays on Spring until it reloads
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:295:    <li><strong>The Delete exposure (finding 3):</strong> making a weekly semester non-active makes it deletable, which is already true of Spring 2026 in production. Phase 1 adds the lesson count and the typed name to that delete, and the activation confirm says so. Until Phase 1 ships: <strong>don't click Delete on Spring 2026</strong>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:296:    <li><strong>Partial update:</strong> <code>updateAppData</code> (<code>update()</code> of named dotted paths; its <code>set(merge)</code> fallback fires only if appData doesn't exist, which isn't the case here). Only <code>activeSemester</code>, optionally <code>semesters.&lt;key&gt;.published</code> and <code>activeSemesterSwitch</code>, plus the existing <code>lastUpdated</code>/<code>lastUpdatedBy</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:300:    <li><strong>Weekly-semester delete is a bulk delete</strong>, so it gets the repo's snapshot rule (JSON download of everything it makes unreachable, taken from forced-server reads, aborting if a read fails) and one transaction across <code>appData</code> and <code>lessonData</code>, with a failure test proving neither document changes.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:301:    <li><strong>Refuses on a bad load:</strong> inherited from <code>updateAppData</code> (config load failed, season registry unknown or error).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:310:      <li><strong>Payload/shape scenarios</strong> stub <code>window.updateAppData</code> and assert <code>Object.keys(payload).sort()</code> (as <code>data-safety.spec.js:7596-7610</code> does). The in-memory test semester is added to <code>currentConfig</code> in the page only, with an explicit <code>semesterType: 'weekly'</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:312:      <li><strong>One real round-trip</strong> runs in a manager context (<code>MANAGER_STATE_PATH</code>, first spec to use it). The test semester is created and removed through the app's own <code>updateAppData</code> in that page, and <code>activeSemester</code> is restored to <code>spring-2026</code> and <code>activeSemesterSwitch</code> deleted in <code>afterEach</code> <strong>and</strong> <code>afterAll</code>, each read back. Cleanup is self-contained and doesn't rely on file order. With <code>workers: 1</code> this file happens to run first alphabetically, and a leak would break <code>day-off-camps.spec.js</code> "SDOC R6" and <code>day-off-teacher.spec.js</code> "T20", which read the active semester.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:313:      <li><strong>The restore can't run from Node</strong> (the helper is staff, and appData writes are manager-only). <code>afterEach</code>/<code>afterAll</code> open a manager browser context and call the page's own <code>updateAppData</code> (<code>activeSemester: 'spring-2026'</code>, <code>activeSemesterSwitch: FieldValue.delete()</code>, <code>semesters.&lt;test&gt;: FieldValue.delete()</code>), then read back with <code>readAppDataFromServer()</code> (<code>firebase-data.js:243-247</code>).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:315:      <li>Payloads: use the <code>window.updateAppData</code> stub pattern (<code>data-safety.spec.js:3947-3958</code>), whose payload holds only the caller's keys. <code>withAppDataSpy</code> is file-local and adds <code>lastUpdated</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:316:      <li><strong>One real rules refusal</strong> uses the staff account and asserts <code>permission-denied</code> specifically (the seeded season registry is valid, so <code>updateAppData</code>'s own guard won't fire first).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:333:  <li>Read this plan. Check the Decisions Log for Christie's answers to Q1/Q2 and any review findings.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:340:<h2 id="decisions">Decisions Log (append-only)</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:342:  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:345:    <li>(2) The "seen" marker is per user (<code>activeSemesterSwitchSeen:&lt;uid&gt;</code>), so on a shared computer every person moves once. That matches the promise "switch everyone".</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:346:    <li>(3) Weekly delete takes a JSON snapshot download (forced-server reads) first and removes the appData entry and lesson map in one transaction, with a failure test. The text now says the cut bank and change history stay stored but become unreachable.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:350:  Also taken: the tab button's own click handler refuses Settings for non-managers.<br>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:351:  <strong>Scope note for Christie:</strong> finding 3 grows Phase 1 (a snapshot download plus a transaction for delete). It's needed because this feature is what exposes Delete on the old semester.<br>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:366:  Also taken: an <code>isPublishableType</code> check before auto-publish, the name fallback in the confirm, filtering Settings' options by <code>canSeeSemester</code>, the camp-active consequences named in the confirm and BDD, and the stale-seen asymmetry recorded as a decision.<br>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:377:    <li>(6) An invisible target isn't marked seen.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:389:  <strong>Sep 29, 2026: production switched by console.</strong> Christie ran <code>await updateAppData({ activeSemester: 'fall-2026' })</code> on the live app. Fall 2026 is now active. Semesters at that point: summer-2026 (published), fall-2026 (published), sdoc-2026-27 (published:false), spring-2026 (published field absent, so visible). Returning browsers still remember Spring until they pick Fall. Phase 2's "switch everyone" is what fixes that next time.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:49:  table { border-collapse: collapse; width: 100%; margin: .75rem 0; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:64:  <strong>Context:</strong> Created Sep 29, 2026. Christie asked how to move "active" from Spring 2026 to Fall 2026 and found there is no UI for it. She is doing a one-time console switch meanwhile (<code>await updateAppData({ activeSemester: 'fall-2026' })</code>). Her answer to "want me to plan it?": <em>"yes we should do this."</em><br>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:76:<table>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:84:  <tr><td>All appData writes go through <code>updateAppData(flatPaths)</code>: one <code>update()</code> of only the named paths, refused after a failed config load or a bad season registry.</td><td><code>firebase-data.js:212-240</code></td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:85:  <tr><td>The template to follow is <code>toggleSemesterPublish()</code>: optimistic in-memory change, <code>updateAppData</code>, exact restore plus an alert on failure, then re-render.</td><td><code>app.js:4604-4630</code></td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:86:  <tr><td>Config is read once per page load. There is no live listener (<code>setupConfigListener</code> is never called), so open tabs see a change on their next reload.</td><td><code>firebase-data.js:521</code>, <code>app.js:11328</code></td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:93:  <tr><td>e2e: no spec has ever written appData for real. They stub <code>window.updateAppData</code> and assert the payload. The Node helper signs in as the staff account, which the rules refuse on appData. There is a saved <em>manager</em> session but no saved teacher session.</td><td><code>data-safety.spec.js:3947, 7596-7610</code>; <code>helpers/firestore.js:57</code>; <code>global-setup.js:63-70</code></td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:95:</table>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:105:  <li><strong>Settings is reachable only by managers and admins.</strong> Today curriculum-admin and prep users can open it through the footer "Settings" link, because only the tab button is hidden. That link and its dot get hidden for them as well, and <code>switchTab('settings')</code> refuses for them.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:122:  <li>New <code>makeSemesterActive(key)</code> beside <code>toggleSemesterPublish</code>. Eligibility is by type (<code>isWeeklySemester(key) || isCampSeason(key)</code>), never by key prefix (there's a ratchet against prefix routing). It refuses if the user isn't admin/manager, or the key is missing or already active. It checks <code>isPublishableType(key)</code> before any auto-publish, so the two gates can't drift. The old semester's name falls back to its key if the name is missing. Then it confirms through <code>confirmModal</code> (built in this phase, so Phase 2 only adds the checkbox and the activation tests aren't rewritten), then writes <code>updateAppData({ activeSemester: key, ['semesters.'+key+'.published']: true /* only if it was false */, …Phase 2 fields })</code>. It changes <code>currentConfig</code> optimistically and restores it exactly on failure, including "field was absent".</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:124:  <li><code>deleteSemester</code>, weekly branch only: the count comes from <code>readServerSemesterLessonMap(key)</code> (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:142:Scenario: making a draft semester active publishes it (edge) — stubbed updateAppData
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:145:  Then exactly one updateAppData call, and
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:152:       Prep Dashboard hidden (as for any camp selection); Teacher View and Curriculum Admin render as they do when Summer is merely selected (so a curriculum-admin/prep user with nothing remembered lands with the Curriculum Admin tab hidden, as today for Summer)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:157:  Then the Prep Dashboard tab reappears for Fall
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:161:  Then updateAppData is not called and nothing on screen changes
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:169:  Then the Settings tab button AND the footer "Settings" link are hidden
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:184:  When updateAppData({ activeSemester: "spring-2026" }) is called
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:197:       (updateAppData and deleteLessonData not called)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:219:<p><strong>Shape:</strong> when ticked, the same single <code>update()</code> writes <code>activeSemesterSwitch: { to: key, at: new Date().toISOString() }</code>. It must be a <strong>client ISO string</strong>, the way <code>lastUpdated</code> is: a <code>serverTimestamp()</code> reads back as a Timestamp, would never equal the stored string, and would re-switch on every load. Compare <code>String(sw.at)</code>. <strong>Placement is load-bearing:</strong> the check runs <em>once</em> in the <code>DOMContentLoaded</code> sequence, after <code>requireAuth</code> and <code>loadConfig()</code> (<code>app.js:148-152</code>) and before <code>initGlobalSemesterSelector()</code> (<code>:158</code>). Never inside <code>initGlobalSemesterSelector</code>, which is re-called after creating a semester and after <code>makeSemesterActive</code>, and would consume the manager's own switch in the same page load. It's one map field, so it replaces the previous switch whole. On load, before the existing pick at <code>app.js:65</code>, with <code>sw = currentConfig.activeSemesterSwitch</code> and <code>seen = localStorage.activeSemesterSwitchSeen</code>:</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:221:  <li>If <code>sw</code> is missing, or <code>sw.at === seen</code>: do nothing.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:222:  <li>If <code>sw.to !== currentConfig.activeSemester</code>: the switch is stale, so mark it seen and do nothing.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:223:  <li>If <code>canSeeSemester(sw.to)</code>: set <code>globalSemesterKey = sw.to</code> and <strong>write <code>localStorage.globalSemesterKey</code> here</strong> (the <code>setItem</code> at :69 sits in the fallback branch, which this makes false), then mark it seen.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:224:  <li>Otherwise (can't see it yet): don't move and don't mark it seen.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:226:<p><strong>Decided asymmetry:</strong> a browser that marked a switch seen through the stale branch isn't moved if that same target becomes active again later without a new tick, while a browser that never loaded would be. That's acceptable: a later switch is a new <code>at</code> and moves everyone.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:251:  Then it is not moved, and the switch is marked seen
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:256:  Then not moved, not marked seen; after it is published and they reload, they are moved
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:259:  Given a browser has seen switch A
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:263:Scenario: open tabs are unaffected until reload (edge)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:264:  Given a second tab already open on Spring
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:266:  Then that tab stays on Spring until it reloads
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:278:    <li><strong>The Delete exposure (finding 3):</strong> making a weekly semester non-active makes it deletable, which is already true of Spring 2026 in production. Phase 1 adds the lesson count and the typed name to that delete, and the activation confirm says so. Until Phase 1 ships: <strong>don't click Delete on Spring 2026</strong>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:279:    <li><strong>Partial update:</strong> <code>updateAppData</code> (<code>update()</code> of named dotted paths; its <code>set(merge)</code> fallback fires only if appData doesn't exist, which isn't the case here). Only <code>activeSemester</code>, optionally <code>semesters.&lt;key&gt;.published</code> and <code>activeSemesterSwitch</code>, plus the existing <code>lastUpdated</code>/<code>lastUpdatedBy</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:282:    <li><strong>No bulk op, no delete:</strong> no snapshot needed. The previous value is shown in the confirmation. To roll back, make the old semester active again with the same button (or the console line).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:283:    <li><strong>Refuses on a bad load:</strong> inherited from <code>updateAppData</code> (config load failed, season registry unknown or error).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:300:- `updateAppData` one `update()` of named paths, refuses on failed load / bad registry — `firebase-data.js:212-239` ✓
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:303:- **No other Tinker app reads `activeSemester`** ✓ — and I checked wider than the plan's list. The only cross-app reader of the `curriculum` collection is `studio-hub/js/alerts.js:562`, which reads `curriculum/lessonData` and iterates *all* semesters (`:573`), plus `summer-camp-app/scripts/backup-firestore.js:39` which just backs the collection up. Neither depends on the active flag. `summer-camp-app`'s `'curriculum'` (`js/app.js:85`, `js/config.js:63`) is its own tab/field name, not this collection.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:311:Worth knowing *why* this has never bitten: **no spec has ever written `appData` for real.** Every existing appData test stubs `window.updateAppData` and asserts the payload (`data-safety.spec.js:3947-3949, 7596-7610, 7774, 7789`). Your spec would be the first to mutate shared emulator config. I'd follow the house pattern — stub-and-assert-payload for the shape scenarios, plus one real manager write for the round-trip and one real non-manager write for the rules refusal — rather than inventing a manager-authenticated helper and a restore protocol.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:327:**6. Marking a switch "seen" for someone who wasn't moved consumes it permanently.** Your invisible-active-semester scenario asserts exactly this. If the semester is published later, that browser is never moved. Narrow window given auto-publish, but make it a decision rather than a side effect.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:335:- **`updateAppData` isn't purely one `update()`** — on `not-found` it falls back to `set(nestFieldPaths(payload), {merge:true})` (`firebase-data.js:233-238`). Irrelevant for a document that exists, but the atomicity claim should say so.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:346:Missing: (a) a payload-keys assertion for the auto-publish case, in the house style `expect(Object.keys(payload).sort()).toEqual([...])` (`data-safety.spec.js:7610`); (b) "a second tab already open is unaffected until reload" — Phase 2 asserts this in prose, nothing tests it; (c) the manager who performs the switch is themselves subject to it on their next load; (d) a UI-level check that the button is absent for a non-manager (cheap — `setupRoleAccess` hides Settings at `app.js:328-329`); (e) `updateAppData` refusing because `seasonRegistryMode` is `error`/`unknown` (`firebase-data.js:221-223`) — a live failure mode of this exact button, and the one most likely to hit Christie mid-term-change.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:351:- **Multiple tabs / shared devices / clock skew**: the design holds. Tabs are consistent because `globalSemesterKey` is shared localStorage; a shared studio device consumes the switch once and every subsequent user on it lands on the new semester anyway, which is what you want; the not-equal comparison does neutralise skew as claimed. Ordering relative to `app.js:65-70` is correct — pre-setting a visible key makes the condition at `:65` false, so it won't override you, and nothing reads `globalSemesterKey` between `app.js:13` and the call at `:158`. First load after deploy moves nobody (verified: nothing reads the field until it exists).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:358:**(2) Settings dropdown — the fix as written doesn't deliver its own acceptance.** Plan line 89 proposes `onchange="setGlobalSemester(this.value)"`. But `setGlobalSemester` (`js/app.js:96-143`) never touches `#global-semester-select` — it sets the variable, toggles the Prep tab, and re-renders the active tab. Teacher View's selector knows this: `js/app.js:829-830` explicitly does `header.value = select.value` *before* calling it, with a comment marking it as an implementation-review fix, and `e2e/day-off-teacher.spec.js:680` asserts it. Curriculum Admin's selector (`js/app.js:4498`) lacks that line and leaves the header stale — the bug you'd be copying. So plan line 99 ("Then the header shows Fall 2026") fails as specified. Worse than cosmetic: with the header displaying Spring while `globalSemesterKey` is `fall-2026`, selecting "Spring 2026" in the header fires no `change` event, so the user can't get back without a detour. Add the `header.value =` sync (or call `initGlobalSemesterSelector()`).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:363:- **It breaks three existing tests**, and the plan's Tests section doesn't say so. `e2e/data-safety.spec.js:8537` asserts `expect(r.confirms).toBe(2)` plus `lessonDeletes`; `:7778-7790` asserts the delete payload shape; `:9099`-ish ("a refused delete or publish toggle reverts this tab") asserts the `Could not remove` alert. All three stub `window.confirm` but not `window.prompt`, and the page-level `page.on('dialog', d => d.accept())` accepts a prompt with `''` — so the delete would abort and all three fail. They must be updated in the same commit.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:365:- **The confirm text you're rewriting is currently false.** `app.js:4554` says "remove all its lesson data, cut bank, and change history", but the code only deletes the appData entry and calls `deleteLessonData(key)` (`app.js:4565, 4585`) — `curriculum/cutProjects[key]` and `curriculum/changeLog[key]` are orphaned, not deleted. Also `deleteLessonData` (`firebase-data.js:961-966`) has no `lessonDataLoadedSuccessfully` guard (unlike `saveLessonData` at `:803`), and it runs *after* the appData entry is gone inside a `catch` that only `console.warn`s (`app.js:4584-4586`).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:369:- **`at` must be a client ISO string.** `updateAppData` stamps `lastUpdated: new Date().toISOString()` (`firebase-data.js:227`) — follow that. A `serverTimestamp()` sentinel inside the map reads back as a `Timestamp`, `sw.at === seen` never matches, and every load re-switches forever. Say it explicitly and compare `String(sw.at)`.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:371:"Not marked seen when invisible" is sound, and ordering stale-before-visible is right. One residual asymmetry worth a line: a browser that marked a switch seen via the *stale* branch is never moved if that target becomes active again, while a browser that never loaded would be. Harmless, but make it a decision.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:384:- **New default for staff**: a `curriculum-admin`/`prep` user with nothing remembered now lands with the Curriculum Admin tab *hidden* (`app.js:299-317`, called from `setupRoleAccess:330`). Correct, but visible and new.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:393:- **There is no appData helper in `e2e/helpers/firestore.js`** (see its exports, `:304-312`). Reads are fine — the staff account *can* read appData (`studio-hub/firestore.rules:665`) — but **the restore can't be done from Node**: only create/update is manager-gated (`:666-669`). So `afterAll` needs a manager browser context (`browser.newContext({ storageState: MANAGER_STATE_PATH })`) calling the page's own `updateAppData`, with `readAppDataFromServer()` (`firebase-data.js:243-247`) for the read-back. Say that; "restore in afterEach and afterAll" hides a real piece of work.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:396:- **The payload assertion mixes two house patterns.** `data-safety.spec.js:7596-7610` is `withAppDataSpy` — a Firestore-level spy whose payloads always include `lastUpdated`/`lastUpdatedBy` (`:7610`). `:3947` is the `window.updateAppData` stub, whose payload has only the caller's keys (its own comment at `:3956-3958`). Plan line 113's expected array matches the second while citing the first. Also `withAppDataSpy` is a file-local `const` at `:7566` — a new spec can't import it.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:398:- The staff-refusal scenario is safe: the seed's `summerCamps_seasons._current` exists, so `seasonRegistryMode` won't be `error`/`unknown` and `updateAppData` won't throw the registry error first (`firebase-data.js:221-223`). Assert `permission-denied` specifically, not just "it threw".
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:404:**One acceptance criterion is false.** Plan lines 85 and 134-136: "Nobody below manager sees the control … the Settings tab is hidden (setupRoleAccess), so there is no button."
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:407:- A `classbook-admin` / `curriculum-admin` / `prep` user can actually **open** Settings. `setupRoleAccess` hides only the tab button inline (`app.js:328-329`); the footer "Settings" link (`index.html:514`) carries `write-control`, which `css/styles.css:243` hides only under `.read-only` — a body class those roles never get (`app.js:336` is the plain-teacher branch). `switchTab('settings')` → `btn.click()` (`app.js:198-201`) fires on a `display:none` button. So they reach the panel and would see the new button; the rules stop the write, but the stated acceptance isn't true.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:430:`isPublishableType` before auto-publish — RESOLVED (plan:93). Name fallback in the confirm — RESOLVED (plan:93). Settings options filtered by `canSeeSemester` — RESOLVED (plan:91; today unfiltered at `app.js:10683-10688`, confirmed). Camp-active consequences in the confirm and BDD — RESOLVED (plan:82, 149-151). Stale-seen asymmetry as a decision — RESOLVED (plan:197). Round-2 §3 mechanics (stub-vs-spy payload, `permission-denied` specifically, teacher fresh-context ordering, re-count tests) — RESOLVED (plan:268, 269, 270, 273).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:432:One round-2 aside is **NOT NAMED**: "a `curriculum-admin`/`prep` user with nothing remembered now lands with the Curriculum Admin tab hidden" is only implicit in plan:123 ("render as they do when Summer is merely selected"). Cosmetic.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:448:rg -n \"activeSemester|globalSemesterKey|activeSemesterSwitch|SemesterSwitchSeen|settings-link|switchTab\\(|deleteSemester|loadSettingsForm|confirmModal|getActiveSemesterKey|readServerSemesterLessonMap|updateAppData|setGlobalSemester|initGlobalSemesterSelector|setupRoleAccess\" js index.html e2e --glob '"'!e2e/test-results/**'"' --glob '"'!e2e/playwright-report/**'"'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:456:    76	  <li><strong>Settings is reachable only by managers and admins.</strong> Today curriculum-admin and prep users can open it through the footer "Settings" link, because only the tab button is hidden. That link and its dot get hidden for them as well, and <code>switchTab('settings')</code> refuses for them.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:473:    93	  <li>New <code>makeSemesterActive(key)</code> beside <code>toggleSemesterPublish</code>. Eligibility is by type (<code>isWeeklySemester(key) || isCampSeason(key)</code>), never by key prefix (there's a ratchet against prefix routing). It refuses if the user isn't admin/manager, or the key is missing or already active. It checks <code>isPublishableType(key)</code> before any auto-publish, so the two gates can't drift. The old semester's name falls back to its key if the name is missing. Then it confirms through <code>confirmModal</code> (built in this phase, so Phase 2 only adds the checkbox and the activation tests aren't rewritten), then writes <code>updateAppData({ activeSemester: key, ['semesters.'+key+'.published']: true /* only if it was false */, …Phase 2 fields })</code>. It changes <code>currentConfig</code> optimistically and restores it exactly on failure, including "field was absent".</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:475:    95	  <li><code>deleteSemester</code>, weekly branch only: the count comes from <code>readServerSemesterLessonMap(key)</code> (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:493:   113	Scenario: making a draft semester active publishes it (edge) — stubbed updateAppData
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:496:   116	  Then exactly one updateAppData call, and
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:503:   123	       Prep Dashboard hidden (as for any camp selection); Teacher View and Curriculum Admin render as they do when Summer is merely selected (so a curriculum-admin/prep user with nothing remembered lands with the Curriculum Admin tab hidden, as today for Summer)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:508:   128	  Then the Prep Dashboard tab reappears for Fall
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:512:   132	  Then updateAppData is not called and nothing on screen changes
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:520:   140	  Then the Settings tab button AND the footer "Settings" link are hidden
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:535:   155	  When updateAppData({ activeSemester: "spring-2026" }) is called
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:548:   168	       (updateAppData and deleteLessonData not called)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:570:   190	<p><strong>Shape:</strong> when ticked, the same single <code>update()</code> writes <code>activeSemesterSwitch: { to: key, at: new Date().toISOString() }</code>. It must be a <strong>client ISO string</strong>, the way <code>lastUpdated</code> is: a <code>serverTimestamp()</code> reads back as a Timestamp, would never equal the stored string, and would re-switch on every load. Compare <code>String(sw.at)</code>. <strong>Placement is load-bearing:</strong> the check runs <em>once</em> in the <code>DOMContentLoaded</code> sequence, after <code>requireAuth</code> and <code>loadConfig()</code> (<code>app.js:148-152</code>) and before <code>initGlobalSemesterSelector()</code> (<code>:158</code>). Never inside <code>initGlobalSemesterSelector</code>, which is re-called after creating a semester and after <code>makeSemesterActive</code>, and would consume the manager's own switch in the same page load. It's one map field, so it replaces the previous switch whole. On load, before the existing pick at <code>app.js:65</code>, with <code>sw = currentConfig.activeSemesterSwitch</code> and <code>seen = localStorage.activeSemesterSwitchSeen</code>:</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:572:   192	  <li>If <code>sw</code> is missing, or <code>sw.at === seen</code>: do nothing.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:573:   193	  <li>If <code>sw.to !== currentConfig.activeSemester</code>: the switch is stale, so mark it seen and do nothing.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:574:   194	  <li>If <code>canSeeSemester(sw.to)</code>: set <code>globalSemesterKey = sw.to</code> and <strong>write <code>localStorage.globalSemesterKey</code> here</strong> (the <code>setItem</code> at :69 sits in the fallback branch, which this makes false), then mark it seen.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:575:   195	  <li>Otherwise (can't see it yet): don't move and don't mark it seen.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:577:   197	<p><strong>Decided asymmetry:</strong> a browser that marked a switch seen through the stale branch isn't moved if that same target becomes active again later without a new tick, while a browser that never loaded would be. That's acceptable: a later switch is a new <code>at</code> and moves everyone.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:602:   222	  Then it is not moved, and the switch is marked seen
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:607:   227	  Then not moved, not marked seen; after it is published and they reload, they are moved
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:610:   230	  Given a browser has seen switch A
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:614:   234	Scenario: open tabs are unaffected until reload (edge)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:615:   235	  Given a second tab already open on Spring
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:617:   237	  Then that tab stays on Spring until it reloads
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:629:   249	    <li><strong>The Delete exposure (finding 3):</strong> making a weekly semester non-active makes it deletable, which is already true of Spring 2026 in production. Phase 1 adds the lesson count and the typed name to that delete, and the activation confirm says so. Until Phase 1 ships: <strong>don't click Delete on Spring 2026</strong>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:630:   250	    <li><strong>Partial update:</strong> <code>updateAppData</code> (<code>update()</code> of named dotted paths; its <code>set(merge)</code> fallback fires only if appData doesn't exist, which isn't the case here). Only <code>activeSemester</code>, optionally <code>semesters.&lt;key&gt;.published</code> and <code>activeSemesterSwitch</code>, plus the existing <code>lastUpdated</code>/<code>lastUpdatedBy</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:633:   253	    <li><strong>No bulk op, no delete:</strong> no snapshot needed. The previous value is shown in the confirmation. To roll back, make the old semester active again with the same button (or the console line).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:634:   254	    <li><strong>Refuses on a bad load:</strong> inherited from <code>updateAppData</code> (config load failed, season registry unknown or error).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:643:   263	      <li><strong>Payload/shape scenarios</strong> stub <code>window.updateAppData</code> and assert <code>Object.keys(payload).sort()</code> (as <code>data-safety.spec.js:7596-7610</code> does). The in-memory test semester is added to <code>currentConfig</code> in the page only, with an explicit <code>semesterType: 'weekly'</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:645:   265	      <li><strong>One real round-trip</strong> runs in a manager context (<code>MANAGER_STATE_PATH</code>, first spec to use it). The test semester is created and removed through the app's own <code>updateAppData</code> in that page, and <code>activeSemester</code> is restored to <code>spring-2026</code> and <code>activeSemesterSwitch</code> deleted in <code>afterEach</code> <strong>and</strong> <code>afterAll</code>, each read back. Reason: with <code>workers: 1</code> this file runs <strong>first</strong> alphabetically, and a leak would break <code>day-off-camps.spec.js</code> "SDOC R6" and <code>day-off-teacher.spec.js</code> "T20", which read the active semester.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:646:   266	      <li><strong>The restore can't run from Node</strong> (the helper is staff, and appData writes are manager-only). <code>afterEach</code>/<code>afterAll</code> open a manager browser context and call the page's own <code>updateAppData</code> (<code>activeSemester: 'spring-2026'</code>, <code>activeSemesterSwitch: FieldValue.delete()</code>, <code>semesters.&lt;test&gt;: FieldValue.delete()</code>), then read back with <code>readAppDataFromServer()</code> (<code>firebase-data.js:243-247</code>).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:648:   268	      <li>Payloads: use the <code>window.updateAppData</code> stub pattern (<code>data-safety.spec.js:3947-3958</code>), whose payload holds only the caller's keys. <code>withAppDataSpy</code> is file-local and adds <code>lastUpdated</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:649:   269	      <li><strong>One real rules refusal</strong> uses the staff account and asserts <code>permission-denied</code> specifically (the seeded season registry is valid, so <code>updateAppData</code>'s own guard won't fire first).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:666:   286	  <li>Read this plan. Check the Decisions Log for Christie's answers to Q1/Q2 and any review findings.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:673:   293	<h2 id="decisions">Decisions Log (append-only)</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:686:   306	  Also taken: an <code>isPublishableType</code> check before auto-publish, the name fallback in the confirm, filtering Settings' options by <code>canSeeSemester</code>, the camp-active consequences named in the confirm and BDD, and the stale-seen asymmetry recorded as a decision.<br>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:697:   317	    <li>(6) An invisible target isn't marked seen.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:709:   329	  <strong>Sep 29, 2026: production switched by console.</strong> Christie ran <code>await updateAppData({ activeSemester: 'fall-2026' })</code> on the live app. Fall 2026 is now active. Semesters at that point: summer-2026 (published), fall-2026 (published), sdoc-2026-27 (published:false), spring-2026 (published field absent, so visible). Returning browsers still remember Spring until they pick Fall. Phase 2's "switch everyone" is what fixes that next time.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:713:e2e/static-checks.spec.js:123:    // seen. Every appData write goes through updateAppData()'s field paths.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:714:js/firebase-data.js:160://                                   memory, writes allowed (updateAppData()
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:715:js/firebase-data.js:212:async function updateAppData(updates) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:745:js/app.js:198:function switchTab(tabId) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:764:js/app.js:4565:    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:767:js/app.js:4619:    await updateAppData({ [`semesters.${key}.published`]: published });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:768:js/app.js:4707:    await updateAppData({ [`semesters.${key}`]: newSem });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:770:js/app.js:4841:    await updateAppData({ [`semesters.${key}`]: newSem });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:774:js/app.js:4981:    await updateAppData({ [`semesters.${key}`]: newSem });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:789:js/app.js:10811:      await updateAppData(paths);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:791:js/app.js:10905:    await updateAppData(stamps);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:798:js/app.js:11322:    await updateAppData({ ...settingsPaths, ...extraPaths });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:815:e2e/day-off-teacher.spec.js:490:      const out = []; const real = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:816:e2e/day-off-teacher.spec.js:491:      window.updateAppData = async (u) => { out.push(u); };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:817:e2e/day-off-teacher.spec.js:492:      try { await toggleSemesterPublish(Y, true); } finally { window.updateAppData = real; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:823:e2e/day-off-camps.spec.js:102:    await page.evaluate(() => { window.__appDataWrites = 0; const u = window.updateAppData; window.updateAppData = async (...a) => { window.__appDataWrites++; return u(...a); }; });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:825:e2e/day-off-camps.spec.js:342:    await page.evaluate(() => { window.__captured = []; window.__origUpdate = window.updateAppData; window.updateAppData = async (u) => { window.__captured.push(u); }; });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:827:e2e/day-off-camps.spec.js:354:        window.updateAppData = window.__origUpdate;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:842:e2e/day-off-camps.spec.js:451:    await page.evaluate(() => { window.__origUpdate = window.updateAppData; window.updateAppData = async () => { throw new Error('should not write'); }; });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:844:e2e/day-off-camps.spec.js:462:    } finally { await page.evaluate(() => { window.updateAppData = window.__origUpdate; }); }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:847:e2e/day-off-camps.spec.js:507:    await page.evaluate(() => { window.__writes = 0; window.__origUpdate = window.updateAppData; window.updateAppData = async () => { window.__writes++; }; });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:849:e2e/day-off-camps.spec.js:514:    } finally { await page.evaluate(() => { window.updateAppData = window.__origUpdate; }); }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:855:e2e/day-off-camps.spec.js:635:    await page.evaluate(() => { window.__captured = []; window.__origUpdate = window.updateAppData; window.updateAppData = async (u) => { window.__captured.push(JSON.parse(JSON.stringify(u))); }; });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:859:e2e/day-off-camps.spec.js:671:      await page.evaluate(() => { window.updateAppData = window.__origUpdate; });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:860:e2e/day-off-camps.spec.js:679:    await page.evaluate(() => { window.__appDataWrites = 0; const u = window.updateAppData; window.updateAppData = async (...a) => { window.__appDataWrites++; return u(...a); }; });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:872:e2e/data-safety.spec.js:3943:      // Phase 1 (1.2): the config writer is updateAppData(), which is handed
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:873:e2e/data-safety.spec.js:3947:        const original = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:874:e2e/data-safety.spec.js:3948:        window.updateAppData = async (updates) => { captured = JSON.parse(JSON.stringify(updates)); };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:875:e2e/data-safety.spec.js:3949:        try { await createNewSemester(); } finally { window.updateAppData = original; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:876:e2e/data-safety.spec.js:3956:      // (the stub stands in for updateAppData itself, so the lastUpdated/
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:877:e2e/data-safety.spec.js:4035:        const originalSaveConfig = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:878:e2e/data-safety.spec.js:4040:        window.updateAppData = async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:880:e2e/data-safety.spec.js:4055:          window.updateAppData = originalSaveConfig;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:882:e2e/data-safety.spec.js:4141:        const originalSaveConfig = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:883:e2e/data-safety.spec.js:4143:        window.updateAppData = async () => { saveConfigCalls++; };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:884:e2e/data-safety.spec.js:4151:          window.updateAppData = originalSaveConfig;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:885:e2e/data-safety.spec.js:4214:        const originalSaveConfig = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:886:e2e/data-safety.spec.js:4216:        window.updateAppData = async () => { saveConfigCalls++; };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:887:e2e/data-safety.spec.js:4221:          window.updateAppData = originalSaveConfig;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:888:e2e/data-safety.spec.js:4274:        const originalSaveConfig = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:889:e2e/data-safety.spec.js:4276:        window.updateAppData = async () => { throw new Error('TEST simulated appData write failure'); };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:890:e2e/data-safety.spec.js:4284:          window.updateAppData = originalSaveConfig;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:892:e2e/data-safety.spec.js:4332:        const originalSaveConfig = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:894:e2e/data-safety.spec.js:4342:        window.updateAppData = async () => { saveConfigCalls++; };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:896:e2e/data-safety.spec.js:4364:          window.updateAppData = originalSaveConfig;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:901:e2e/data-safety.spec.js:7552:// through updateAppData(), so a writer can only ever touch the paths it names.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:902:e2e/data-safety.spec.js:7596:  test('RED (1.2): updateAppData() writes ONE update() of exactly the paths it was given, plus the two stamps — never a whole document', async ({ browser }) => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:903:e2e/data-safety.spec.js:7603:        await updateAppData({ 'semesters.test-x.published': true });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:904:e2e/data-safety.spec.js:7617:  test('RED (1.2): on not-found (no appData document yet) updateAppData() falls back to a NESTED merge-set, never a bare set', async ({ browser }) => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:905:e2e/data-safety.spec.js:7637:          await updateAppData({ 'semesters.test-x.name': 'TEST X', 'activeSemester': 'test-x' });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:909:e2e/data-safety.spec.js:8358:        const realUpdate = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:910:e2e/data-safety.spec.js:8361:        window.updateAppData = async (u) => { appDataWrites.push(JSON.parse(JSON.stringify(u))); };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:911:e2e/data-safety.spec.js:8371:          window.updateAppData = realUpdate; window.saveLessonData = realSaveLessons; window.readAppDataFromServer = realRead;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:912:e2e/data-safety.spec.js:8436:        const realUpdate = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:913:e2e/data-safety.spec.js:8438:        window.updateAppData = async (u) => { writes.push(JSON.parse(JSON.stringify(u))); };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:914:e2e/data-safety.spec.js:8448:          window.updateAppData = realUpdate; window.readAppDataFromServer = realRead;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:915:e2e/data-safety.spec.js:8487:        const realUpdate = window.updateAppData;
FILE:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3-input.md
## Codex confirmation round 3 — narrow
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 5). Your round 2: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md. Read the Decisions Log entry "revision 5". Repo (read-only, main 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 .
Check only your two round-2 minimum changes (snapshot contents; delete coordinating with lessonData incl. stale-tab behaviour) against the code: RESOLVED / NOT RESOLVED with plan-line citations, and whether revision 5 introduced anything wrong. One-line verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
FILE:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md
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
FILE:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r4-input.md
## Codex confirmation round 4 — narrow
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 6). Your round 3: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md. Read the Decisions Log entry "revision 6". Repo (read-only, main 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 .
Check only: (1) your round-3 minimum (stale post-delete saves prevented; copy and no-copy key reuse specified/tested; acceptance snapshot list) — RESOLVED / NOT with plan-line citations; (2) whether the new appData listener + assertSemesterStillExists design is sound against the code: every doc('lessonData') writer covered? any risk the listener changes existing behaviour (currentConfig untouched)? first-snapshot timing (a save before the first snapshot arrives)? offline/cache snapshots? (3) One-line verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
FILE:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r4.md
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

FILE:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r5-input.md
## Codex confirmation round 5 — narrow
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 7). Your round 4: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r4.md. Read the Decisions Log entry "revision 7". Repo (read-only, main 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 .
Check only your round-4 minimum: (1) is the lessonData writer list complete against the code (all loaded scripts; include writes via refs/variables, batches, transactions)? (2) are the fail-closed states sound (e.g. does a fromCache:true metadata snapshot really arrive on going offline with includeMetadataChanges; could 'unconfirmed' wrongly block normal online saves, e.g. a local-write latency-compensated snapshot)? Verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
FILE:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r5.md
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
session id: 01a0ee57-15a9-7cb1-a120-831a2a41b9b5
--------
user
## Codex confirmation round 5 — narrow
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 7). Your round 4: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r4.md. Read the Decisions Log entry "revision 7". Repo (read-only, main 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 .
Check only your round-4 minimum: (1) is the lessonData writer list complete against the code (all loaded scripts; include writes via refs/variables, batches, transactions)? (2) are the fail-closed states sound (e.g. does a fromCache:true metadata snapshot really arrive on going offline with includeMetadataChanges; could 'unconfirmed' wrongly block normal online saves, e.g. a local-write latency-compensated snapshot)? Verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
codex
I’ll inspect revision 7, the prior round-4 review, and the repository’s loaded scripts/writers only. I’ll keep this read-only and won’t run tests.
exec
/bin/zsh -lc "sed -n '/revision 7/,"'$p'"' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html | head -n 260 && sed -n '1,240p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r4.md" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
  <strong>Sep 29, 2026: revision 7, after Codex round 4 (<code>…-codex-r4.md</code>).</strong> Codex confirmed the listener approach (<code>currentConfig</code> untouched) and resolved key reuse and the snapshot list. Taken: (1) an explicit list of all seven lessonData writers, including three in <code>app.js</code> (Q&amp;A and help replies) and <code>deleteLessonKey</code>, plus an acorn ratchet so a new writer can't skip the guard; (2) fail-closed <code>pending</code>/<code>unconfirmed</code>/<code>error</code> states with tests. <strong>Behaviour change for Christie:</strong> lesson saves while offline are refused with a clear message instead of hanging and queueing.
</div>
<div class="decision">
  <strong>Sep 29, 2026: revision 6, after Codex round 3 (<code>…-codex-r3.md</code>).</strong> Snapshot contents are confirmed resolved, and the acceptance list now matches. Revision 5's "accept stale-tab orphans; the create pre-check catches them" was wrong: that pre-check runs only with "Copy from", and no-copy creation adopts leftovers by design. Replaced with prevention: a narrow appData listener tracks only the server's semester keys (it never replaces <code>currentConfig</code>), and every weekly lessonData writer checks the key still exists. The no-copy create path now tells the manager how many leftover lessons it will adopt.
</div>
<div class="decision">
  <strong>Sep 29, 2026: revision 5, after Codex confirmation round 2 (<code>…-codex-r2.md</code>).</strong> Findings 1, 2, 4, 5 and the tab-handler item are confirmed resolved. Finding 3 had two gaps, both taken. (a) The snapshot also includes <code>prepData</code>, <code>lessonData_backup</code> and <code>diagnosticDismissals</code> for the key. (b) The delete transaction re-reads lessonData and refuses unless the semester's lessons deep-equal the downloaded snapshot. Retries from other semesters' saves are accepted. Stale-tab re-saves after a delete are defined as an accepted, invisible orphan that the existing <code>createNewSemester</code> pre-check catches, with a test.
</div>
<div class="decision">
  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
  <ul>
    <li>(1) An unticked activation now deletes any old <code>activeSemesterSwitch</code>, with a three-activation regression test.</li>
    <li>(2) The "seen" marker is per user (<code>activeSemesterSwitchSeen:&lt;uid&gt;</code>), so on a shared computer every person moves once. That matches the promise "switch everyone".</li>
    <li>(3) Weekly delete takes a JSON snapshot download (forced-server reads) first and removes the appData entry and lesson map in one transaction, with a failure test. The text now says the cut bank and change history stay stored but become unreachable.</li>
    <li>(4) Activation runs in a transaction that verifies the target still exists and "active" hasn't changed since the confirmation, so no ghost semester can be created.</li>
    <li>(5) The teacher test is staged so the first sign-in can't consume the switch, and the Phase 1 happy path unticks the box.</li>
  </ul>
  Also taken: the tab button's own click handler refuses Settings for non-managers.<br>
  <strong>Scope note for Christie:</strong> finding 3 grows Phase 1 (a snapshot download plus a transaction for delete). It's needed because this feature is what exposes Delete on the old semester.<br>
  <strong>Execution-ready reverted to false</strong> until a Codex confirmation round.
</div>
<div class="decision">
  <strong>Sep 29, 2026: round 3 (confirmation) — EXECUTION-READY</strong> (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md</code>). All round-2 blockers were confirmed resolved. Its four clarifications are folded in: hide only <code>.footer-dot.write-control</code>; <code>readServerSemesterLessonMap</code> returning <code>null</code> means 0 lessons, not a failure; the three delete tests must split their <code>page.evaluate</code> to drive the modal; the activation uses <code>confirmModal</code> from Phase 1. Also named: a curriculum-admin/prep user with nothing remembered lands with Curriculum Admin hidden when Summer is active. All phases are marked execution-ready. Execution waits for Christie's go-ahead. Codex didn't review this plan (out of credits); all three rounds were Claude.
</div>
<div class="decision">
  <strong>Sep 29, 2026: revision 3, after round-2 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r2-claude.md</code>).</strong> Round 2 found the write shape safe and listed five blockers, all verified and taken:
  <ul>
    <li>(a) The Settings dropdown fix syncs the header first, as Teacher View does.</li>
    <li>(b) Phase 2's check is a one-shot in <code>DOMContentLoaded</code>, never in <code>initGlobalSemesterSelector</code>, and <code>at</code> is a client ISO string.</li>
    <li>(c) "Nobody below manager sees it" was false: curriculum-admin and prep can open Settings through the footer link. Phase 1 hides that link, gates <code>switchTab</code>, and renders the button only for admin/manager.</li>
    <li>(d) The e2e restore runs through a manager browser context, not Node. The camp scenario is stubbed so <code>summer-2026.published</code> can't leak. The <code>activeSemesterSwitch</code> leak is flagged as the top risk.</li>
    <li>(e) The weekly-delete guard counts from the server (<code>readServerSemesterLessonMap</code>), corrects the false "cut bank and change history" text, and uses the same modal as Phase 2 (no <code>prompt()</code>). Three existing <code>data-safety</code> tests change in the same commit.</li>
  </ul>
  Also taken: an <code>isPublishableType</code> check before auto-publish, the name fallback in the confirm, filtering Settings' options by <code>canSeeSemester</code>, the camp-active consequences named in the confirm and BDD, and the stale-seen asymmetry recorded as a decision.<br>
  <strong>Not taken (out of scope, noted):</strong> the dead code at <code>app.js:5069-5074</code> and <code>:4590</code>. <code>deleteLessonData</code> lacks a <code>lessonDataLoadedSuccessfully</code> guard and runs after the appData entry is gone inside a warn-only catch (pre-existing, and the server-read count now gates the whole delete). Cut bank and change history are orphaned by a weekly delete (pre-existing, and the text is now honest about it).
</div>
<div class="decision">
  <strong>Sep 29, 2026: revision 2, after round-1 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r1-claude.md</code>).</strong> Verified against the code and taken:
  <ul>
    <li>(1) e2e can't write appData with the Node helper, so the house pattern is used: stub-and-payload, one manager round-trip with restore in afterEach+afterAll, one staff refusal.</li>
    <li>(2) The Settings dropdown was broken, so it's fixed in Phase 1.</li>
    <li>(3) Making a semester non-active arms its Delete, which is already live for Spring. Weekly delete now shows the lesson count and needs the name typed, and the confirm mentions it.</li>
    <li>(4) Dropped the false "teachers will stop seeing it" warning (drafts were never visible). Noted that auto-publish makes the badge honest.</li>
    <li>(5) Phase 2 stores <code>{to, at}</code> and ignores a switch whose target is no longer active.</li>
    <li>(6) An invisible target isn't marked seen.</li>
    <li>(7) Attach-once guard on the header listener.</li>
    <li>(8) Teacher View's "(current)" is in the re-render set.</li>
  </ul>
  Low items taken: the set(merge) fallback noted, teacher read access stated, Phase 2 writes <code>localStorage.globalSemesterKey</code> itself, fresh teacher sign-in, restore with read-back plus the lastUpdated-ignoring diff, type-based eligibility. BDD gaps a–e added.<br>
  <strong>Deliberately left alone:</strong> the two stale <code>'spring-2026'</code> fallback literals (<code>firebase-data.js:504, 3122</code>). They only fire with no config (the banner state), so they're out of scope and noted here.<br>
  <strong>New UI consequence:</strong> Phase 2's checkbox needs a small modal instead of <code>confirm()</code>.
</div>
<div class="note" style="opacity:.7">
  <strong>(Superseded — Christie stayed; round 1 addressed below.) PAUSED Sep 29, 2026.</strong> Round-1 plan review (Claude only; Codex is out of credits) finished but has <strong>not been addressed yet</strong>. It reports three findings that would stop or mislead execution, plus smaller ones. It ran on the plan <em>before</em> Christie's Q1 answer added Summer camp seasons, so re-check its points against that too. Files: <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r1-claude.md</code> (and <code>-r1-input.md</code>). Next: verify each finding against the code, revise this plan, append the outcome here, run a round-2 review, then ask Christie for the go-ahead. No code has been written, and nothing about this feature is on a branch yet.
</div>
<div class="decision">
  <strong>Sep 29, 2026: production switched by console.</strong> Christie ran <code>await updateAppData({ activeSemester: 'fall-2026' })</code> on the live app. Fall 2026 is now active. Semesters at that point: summer-2026 (published), fall-2026 (published), sdoc-2026-27 (published:false), spring-2026 (published field absent, so visible). Returning browsers still remember Spring until they pick Fall. Phase 2's "switch everyone" is what fixes that next time.
</div>
<div class="decision">
  <strong>Sep 29, 2026: Christie's answers.</strong> Q1 = class semesters AND Summer camp seasons (SDOC years excluded). Q2 = "switch everyone" ticked by default.
</div>
<div class="decision">
  <strong>Sep 29, 2026: plan created.</strong> From Christie's question about switching active to Fall 2026. Found no UI exists, and that "active" doesn't move returning users (localStorage). Christie: "yes we should do this." Scope: Settings-only control (manager+), auto-publish a draft on activation, optional one-time "switch everyone" through a new appData field. Deliberately <em>not</em> in scope: renaming the misleading <code>getActiveSemesterKey()</code>, a live config listener, and the Curriculum Admin bar (non-managers use it).
</div>

</body>
</html>
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
FILE:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r6-input.md
## Codex round 6 — revision 8 (design change)
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 8). Your rounds 1–5 are in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex*.md. Read the Decisions Log entry "revision 8": Christie chose to ARCHIVE old class semesters (a semesters.<key>.archived flag; nothing deleted) instead of hardening a hard delete; the listener/fail-closed/save-guard design is removed.
Repo (read-only, main 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Rules: /Users/christiehubley/studio-hub/firestore.rules .
Review the plan as it now stands, adversarially, against the code:
1. Archive design: is every place that lists or iterates semesters covered (all loaded scripts — selectors, copy-from, diagnostics, prep dashboard, material forecasts, backups, change history, anything using Object.keys(currentConfig.semesters) or similar)? Does an archived semester leak anywhere, or break anything (e.g. getActiveSemesterKey fallback, canSeeSemester for managers, createNewSemester, the season registry / camp code, SDOC code)? Is the "can't reuse an archived key" check placed correctly relative to createNewSemester's existing checks?
2. Anything from your rounds 1–5 that the removal reopened (activation transaction, per-user switch, unticked clears switch, Settings gating, header sync)?
3. Tests: workable and non-leaking?
Verdict: EXECUTION-READY or NOT (minimum list). Be concise. Do not edit files or run tests.
FILE:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r6.md
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
session id: 01a0ee60-0566-7f72-a598-8821fa2047cd
--------
user
## Codex round 6 — revision 8 (design change)
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 8). Your rounds 1–5 are in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex*.md. Read the Decisions Log entry "revision 8": Christie chose to ARCHIVE old class semesters (a semesters.<key>.archived flag; nothing deleted) instead of hardening a hard delete; the listener/fail-closed/save-guard design is removed.
Repo (read-only, main 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Rules: /Users/christiehubley/studio-hub/firestore.rules .
Review the plan as it now stands, adversarially, against the code:
1. Archive design: is every place that lists or iterates semesters covered (all loaded scripts — selectors, copy-from, diagnostics, prep dashboard, material forecasts, backups, change history, anything using Object.keys(currentConfig.semesters) or similar)? Does an archived semester leak anywhere, or break anything (e.g. getActiveSemesterKey fallback, canSeeSemester for managers, createNewSemester, the season registry / camp code, SDOC code)? Is the "can't reuse an archived key" check placed correctly relative to createNewSemester's existing checks?
2. Anything from your rounds 1–5 that the removal reopened (activation transaction, per-user switch, unticked clears switch, Settings gating, header sync)?
3. Tests: workable and non-leaking?
Verdict: EXECUTION-READY or NOT (minimum list). Be concise. Do not edit files or run tests.
codex
I’ll cross-check revision 8 against the current scripts and rules, then compare the prior review findings. I’ll keep this read-only and won’t run tests.
FILE:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md
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

exec
/bin/zsh -lc "rg -n -C 4 \"revision 8|Revision 8|Archived|archive|createNewSemester|Object\\.keys\\(currentConfig\\.semesters|activeSemesterSwitch|untick|Settings|header\" /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html | tail -n 420" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
1-<!DOCTYPE html>
2-<html lang="en">
3-<head>
4-<meta charset="UTF-8">
5:<title>Plan: Classbook — "Make this the active semester" in Settings</title>
6-<style>
7-  body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; max-width: 860px; margin: 2rem auto; padding: 0 1.5rem; color: #1a1a1a; line-height: 1.5; }
8-  h1 { font-size: 1.6rem; border-bottom: 2px solid #8B30BC; padding-bottom: .5rem; }
9-  h2 { font-size: 1.15rem; margin-top: 2rem; color: #6052C8; }
--
26-</style>
27-</head>
28-<body>
29-
30:<h1 id="plan-title">Plan: Classbook — "Make this the active semester" in Settings</h1>
31-
32-<div class="meta" id="plan-meta">
33:  <strong>Goal:</strong> At each term change, Christie can make the new semester the Classbook's active one from Settings in one step, and choose to put everyone (teachers included) onto it the next time they open the app. No console commands needed.<br>
34-  <strong>App:</strong> tinker-spring-curriculum (The Classbook): <code>js/app.js</code>, <code>js/firebase-data.js</code>, one new e2e spec. <strong>No</strong> Firestore rules change, no new collection.<br>
35-  <strong>Context:</strong> Created Sep 29, 2026. Christie asked how to move "active" from Spring 2026 to Fall 2026 and found there is no UI for it. She is doing a one-time console switch meanwhile (<code>await updateAppData({ activeSemester: 'fall-2026' })</code>). Her answer to "want me to plan it?": <em>"yes we should do this."</em><br>
36-  <strong>Line numbers</strong> are at <code>2ef2e62</code> (main, live on Netlify).<br>
37:  <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Christie answered Q1/Q2. Three Claude rounds, then Codex's independent review: NOT ready (5 findings). Revisions 4–8 address them (revision 8: archive instead of delete, per Christie). Codex confirmation round 6 is next.
38-</div>
39-
40-<h2 id="open-questions">Christie's decisions (Sep 29)</h2>
41-<div class="decision">
--
50-  <tr><td>What "active" controls: the "(active)"/"(current)" labels; the fallback semester for a browser with nothing remembered; Curriculum Admin's semester after a delete; the active semester can't be deleted and its Publish toggle is hidden (the badge says "always visible to teachers").</td><td><code>app.js:68, 76, 818, 4492-4530, 4590, 10687-10712</code></td></tr>
51-  <tr><td>What it does <strong>not</strong> control: what a returning user sees. Each browser remembers <code>globalSemesterKey</code> in localStorage and keeps it while it exists and is visible.</td><td><code>app.js:13, 65-70, 96-100</code></td></tr>
52-  <tr><td><code>getActiveSemesterKey()</code> despite its name returns the <em>selected</em> semester first, and <code>activeSemester</code> only as a fallback. So <code>getCurrentWeekNum()</code> follows the selection, not the flag.</td><td><code>firebase-data.js:3117-3123</code>, <code>app.js:1243</code></td></tr>
53-  <tr><td>"Active" does <strong>not</strong> imply visible: <code>canSeeSemester()</code> ignores it, so an unpublished active semester is hidden from teachers (the fallback at :68 already guards for that).</td><td><code>app.js:277-284</code></td></tr>
54:  <tr><td>Rules: <code>curriculum/{docId}</code> is read/write for manager+, and appData is manager+ only. Settings is hidden for everyone below manager.</td><td><code>studio-hub/firestore.rules:652-657</code>; <code>app.js:318-329</code></td></tr>
55-  <tr><td>All appData writes go through <code>updateAppData(flatPaths)</code>: one <code>update()</code> of only the named paths, refused after a failed config load or a bad season registry.</td><td><code>firebase-data.js:212-240</code></td></tr>
56-  <tr><td>The template to follow is <code>toggleSemesterPublish()</code>: optimistic in-memory change, <code>updateAppData</code>, exact restore plus an alert on failure, then re-render.</td><td><code>app.js:4604-4630</code></td></tr>
57-  <tr><td>Config is read once per page load. There is no live listener (<code>setupConfigListener</code> is never called), so open tabs see a change on their next reload.</td><td><code>firebase-data.js:521</code>, <code>app.js:11328</code></td></tr>
58-  <tr><td>No other Tinker app reads <code>activeSemester</code> (grep of studio-hub, summer-camp-app, roster-manager, schedule-viewer, playbook, materials, enrollment-board).</td><td>—</td></tr>
59:  <tr><td><strong>Settings' "Editing Semester" dropdown doesn't work.</strong> <code>onchange="loadSettingsForm()"</code> redraws the form for <code>getSettingsSemKey()</code> = the header's <code>globalSemesterKey</code>, so the pick snaps back. Today the only way to point Settings at another semester is the header dropdown. (Round-1 review, finding 2; confirmed.)</td><td><code>index.html:411</code>; <code>app.js:10659-10661, 10681-10689</code></td></tr>
60-  <tr><td><strong>Making a weekly semester non-active arms its Delete.</strong> Curriculum Admin's bar (manager/admin only) shows Delete for every non-active semester. For a weekly one, <code>deleteSemester</code> removes the appData entry (manager-only), then <code>deleteLessonData(key)</code> removes that semester's whole lesson map, behind two generic confirms. Since the Sep 29 console switch this is already true of Spring 2026 in production. (Finding 3; confirmed.)</td><td><code>app.js:4481-4483, 4522, 4527-4590</code>; <code>firebase-data.js:961-966</code></td></tr>
61:  <tr><td>The header selector's <code>change</code> listener is attached on every <code>initGlobalSemesterSelector()</code> call, with no attach-once guard (the Teacher View selector has one). It's already re-called after creating a semester. (Finding 7; confirmed.)</td><td><code>app.js:86</code>, <code>:825</code>, <code>:4724, 4845</code></td></tr>
62-  <tr><td>Teacher View's own selector labels the active semester "(current)".</td><td><code>app.js:818-819</code>, <code>:653-655</code></td></tr>
63-  <tr><td>Teachers can <em>read</em> appData (<code>classbook</code> / <code>classbook-admin</code> / <code>curriculum-admin</code>). Only create/update is manager+. That read is what lets Phase 2 work for teachers.</td><td><code>firestore.rules:665-669</code></td></tr>
64-  <tr><td>e2e: no spec has ever written appData for real. They stub <code>window.updateAppData</code> and assert the payload. The Node helper signs in as the staff account, which the rules refuse on appData. There is a saved <em>manager</em> session but no saved teacher session.</td><td><code>data-safety.spec.js:3947, 7596-7610</code>; <code>helpers/firestore.js:57</code>; <code>global-setup.js:63-70</code></td></tr>
65-  <tr><td>e2e seed: <code>activeSemester: spring-2026</code>; semesters spring-2026 (weekly, published) and summer-2026 (camp, unpublished). Specs that touch activeSemester or publishing: day-off-camps, day-off-teacher, data-safety.</td><td><code>e2e/fixtures/seed/curriculum.json</code></td></tr>
--
68-<h2 id="phases">Phases</h2>
69-<p>Two phases, committed separately and <strong>deployed once</strong> (one Netlify credit) after both are reviewed.</p>
70-
71-<div class="phase" id="phase-1">
72:<h3>Phase 1: "Make active" in Settings, plus the two things it depends on <span class="status-tag not-ready">execution-ready: false</span></h3>
73-<p><strong>Acceptance (user outcomes):</strong></p>
74-<ul>
75:  <li><strong>Settings' "Editing Semester" dropdown works.</strong> Picking a semester there switches the app to it, the same as the header and Teacher View dropdowns already do. The header dropdown shows the new semester too, and the Settings form shows that semester. It lists only semesters the user can see.</li>
76:  <li><strong>Settings is reachable only by managers and admins.</strong> Today curriculum-admin and prep users can open it through the footer "Settings" link, because only the tab button is hidden. That link and its dot get hidden for them as well, and <code>switchTab('settings')</code> refuses for them.</li>
77:  <li>When Settings is on a non-active Fall/Spring class semester or Summer camp season (Q1; never an SDOC year), a manager sees <strong>"Make this the active semester"</strong> in the publish group.</li>
78-  <li>Clicking it asks one confirmation that names both semesters, "Make Fall 2026 the active semester? Spring 2026 stops being active.", and adds, when true:
79-    <ul>
80-      <li>New semester is a draft: "It's a draft — it will be published so teachers can see it." Activation publishes it in the same single write. That makes the existing "Active Semester — always visible to teachers" badge true, which it isn't today for an unpublished active semester.</li>
81:      <li>Old semester is a weekly class semester: "Spring 2026 stays available. You can archive it from Curriculum Admin to hide it; nothing is deleted."</li>
82-      <li>New semester is a camp season: "While Summer 2026 is active it can't be removed or unpublished — make another semester active first."</li>
83-    </ul></li>
84:  <li>After confirming, every place that labels the active semester updates without a reload: the header, Teacher View ("(current)"), Settings' badge/toggle, and Curriculum Admin's badge/toggle/Archive.</li>
85:  <li><strong>Old class semesters are archived, not deleted</strong> (Christie, Sep 29). For a non-active Fall/Spring semester, Curriculum Admin's 🗑 <strong>Delete</strong> becomes <strong>Archive</strong>. Archiving hides the semester from every semester list (header, Teacher View, Curriculum Admin, Settings, the "Copy from" list) and <strong>deletes nothing</strong>: its lessons, cut bank, change history, prep data, backups and dismissals all stay exactly where they are. A manager can bring it back from a new <strong>"Archived semesters"</strong> list in Settings (Unarchive). The confirmation says so in plain words, with no typed name needed because nothing is lost. The active semester can't be archived, and an archived semester can't be made active (unarchive it first). There's no longer any way to hard-delete a class semester from the app. That could come back later as its own reviewed plan.</li>
86-  <li>Camp seasons and SDOC years keep their current Delete flows. Those already delete no lessons: a camp removes only its Classbook entry, and an SDOC year refuses while it has events.</li>
87-  <li>If the write fails for any reason (rules, a failed config load, or the season registry being unknown or in error), nothing changes on screen and an alert names the reason and says "Nothing was changed."</li>
88-  <li>Nobody below manager sees the control: it's rendered only for <code>admin</code>/<code>manager</code> roles, <code>makeSemesterActive</code> refuses otherwise, and the rules refuse the write regardless.</li>
89-</ul>
90-<p><strong>Shape:</strong></p>
91-<ul>
92:  <li><code>index.html:411</code>: a new <code>onSettingsSemesterChange(value)</code> that does what Teacher View's selector does (<code>app.js:826-830</code>): set <code>#global-semester-select</code>'s value <em>first</em>, then <code>setGlobalSemester(value)</code>. Without the header sync, the header would keep showing the old semester and re-picking it would fire no change event (round 2, finding 1). Settings' options are filtered by <code>canSeeSemester</code>, like the header's.</li>
93-  <li><code>setupRoleAccess</code> (<code>app.js:318-336</code>): hide <code>#settings-link</code> and its dot (<code>.footer-dot.write-control</code>; other <code>.footer-dot</code>s stay) for non-managers too. <code>switchTab('settings')</code>, the footer handler, <strong>and the tab button's own click handler</strong> (<code>app.js:203</code>) refuse for non-managers.</li>
94-  <li>New <code>makeSemesterActive(key)</code> beside <code>toggleSemesterPublish</code>. Eligibility is by type (<code>isWeeklySemester(key) || isCampSeason(key)</code>), never by key prefix (there's a ratchet against prefix routing). It refuses if the user isn't admin/manager, or the key is missing or already active. It checks <code>isPublishableType(key)</code> before any auto-publish, so the two gates can't drift. The old semester's name falls back to its key if the name is missing. Then it confirms through <code>confirmModal</code> (built in this phase, so Phase 2 only adds the checkbox and the activation tests aren't rewritten), then writes through a new <code>activateSemesterTx(key, expectedActive, { publish, switchEveryone })</code> in <code>firebase-data.js</code> (Codex finding 4). It's one <code>runTransaction</code> that re-reads appData from the server and refuses, with "reload and try again", unless <code>semesters[key]</code> still exists with a name and an eligible type, and <code>activeSemester === expectedActive</code> (what the confirmation showed). Only then does it <code>tx.update</code> <code>activeSemester</code>, the publish flag if needed, the Phase 2 switch field, and <code>lastUpdated</code>/<code>lastUpdatedBy</code>. This way a stale tab can't point "active" at a semester another tab deleted, or recreate a half-semester through the dotted publish path. It honours the same guards as <code>updateAppData</code>. <code>currentConfig</code> changes only after the commit succeeds; on failure nothing local changes.</li>
95:  <li>Re-render set after success or failure: header options, Teacher View selector, <code>renderSemesterSelector()</code>, <code>loadSettingsForm()</code>. The header's <code>change</code> listener gets the attach-once guard Teacher View already uses (<code>dataset.listenerAttached</code>), so re-rendering doesn't stack handlers.</li>
96:  <li><strong>Archive (replaces the weekly branch of <code>deleteSemester</code>):</strong> new <code>archiveSemester(key)</code> and <code>unarchiveSemester(key)</code> write only <code>semesters.&lt;key&gt;.archived</code> (<code>true</code> / <code>FieldValue.delete()</code>) through a small transaction. It re-reads appData, refuses if the key is missing or is the active semester, then <code>tx.update</code>s that one path plus <code>lastUpdated</code>/<code>lastUpdatedBy</code>, with <code>updateAppData</code>'s guards. The weekly branch's <code>updateAppData(semesters.&lt;key&gt; delete)</code> + <code>deleteLessonData(key)</code> path is removed. <code>deleteLessonData</code> stays for its other caller, the failed-create cleanup (<code>app.js:4994</code>), which is unchanged. The camp and SDOC branches are unchanged. The confirmation uses the shared <code>confirmModal</code>.</li>
97:  <li><strong>One helper decides what's listed:</strong> <code>isArchivedSemester(key)</code> (reads <code>semesters[key].archived === true</code>). Every semester list filters it out: header (<code>app.js:56-60</code>, via <code>canSeeSemester</code>), Teacher View (<code>:803</code>), Curriculum Admin bar (<code>:4479</code>), Settings (<code>:10683</code>), and the "Copy from" list (<code>:4499-4506</code>). The executor re-checks with <code>grep -n "semesters)" js/*.js</code>. <code>canSeeSemester()</code> returns false for an archived semester for everyone, so the existing guard at <code>app.js:65</code> moves a browser that remembered it to the active semester on its next load. Reading a lesson doc directly isn't affected.</li>
98:  <li><strong>Settings → "Archived semesters"</strong> (managers only): lists archived keys by name, each with Unarchive. It's empty and hidden when there are none.</li>
99:  <li><strong>Creating a semester whose key belongs to an archived one</strong> (<code>createNewSemester</code>) refuses: "An archived semester already uses this name — unarchive it in Settings instead." The existing checks are unchanged otherwise.</li>
100:  <li><strong>Stale tabs are a non-issue by design:</strong> nothing is deleted, so a tab still open on an archived semester saves into lessons that still exist. They reappear on unarchive. No listener and no save-path changes are needed. The three existing weekly-delete tests in <code>data-safety.spec.js</code> (around 7778-7790, 8537, and "a refused delete or publish toggle reverts this tab") are rewritten for archive semantics in the same commit. Camp and SDOC delete tests are untouched.</li>
101:  <li>Unchanged and fine: Studio Hub's unanswered-question alerts (<code>studio-hub/js/alerts.js:559-580</code>) iterate every semester in <code>lessonData</code>, so an archived semester's open questions still alert, exactly as a non-deleted Spring does today.</li>
102-  <li>Left alone on purpose: <code>app.js:5069-5074</code> and the <code>caCurrentSemester</code> assignment at <code>:4590</code> are dead code (round 2 confirmed that nothing reads them). This plan doesn't touch them.</li>
103-  <li>The Curriculum Admin bar stays read-only for "active" (it's the same audience, but one place to change it is enough).</li>
104-</ul>
105-
106:<div class="bdd">Scenario: the Settings dropdown switches semester (fix)
107:  Given a manager on Settings with the header on Spring 2026
108-  When they pick Fall 2026 in "Editing Semester"
109:  Then the header shows Fall 2026 and the Settings form shows Fall's name/start date
110-
111-Scenario: manager makes Fall active (happy path) — real write, manager session
112:  Given a manager on Settings for Fall 2026 (published, weekly), active = Spring 2026
113-  When they click "Make this the active semester", UNTICK "switch everyone" (Phase 2), and confirm
114-  Then curriculum/appData.activeSemester reads back from the emulator as "fall-2026"
115-   And a whole-document diff of appData, ignoring lastUpdated/lastUpdatedBy (as app.js:10918 does), shows only activeSemester changed
116:   And header "Fall 2026 (active)", Teacher View "Fall 2026 (current)", Settings badge on Fall,
117-       Curriculum Admin shows Spring with Publish toggle and Delete
118-
119-Scenario: making a draft semester active publishes it (edge) — stubbed updateAppData
120-  Given Fall 2026 is published:false
--
122-  Then exactly one updateAppData call, and
123-       Object.keys(payload).sort() equals ["activeSemester", "semesters.fall-2026.published", …Phase 2 keys]
124-
125-Scenario: a Summer camp season can be made active (Q1)
126:  Given Settings on Summer 2026 (camp season)
127-  When the manager makes it active
128-  Then activeSemester = "summer-2026"; with nothing remembered a user lands on Summer 2026;
129-       Prep Dashboard hidden (as for any camp selection); Teacher View and Curriculum Admin render as they do when Summer is merely selected (so a curriculum-admin/prep user with nothing remembered lands with the Curriculum Admin tab hidden, as today for Summer)
130-
--
137-  When the manager cancels the confirmation
138-  Then updateAppData is not called and nothing on screen changes
139-
140-Scenario: ineligible or already active: no button (edge)
141:  Given Settings on an SDOC year, or on the active semester
142-  Then no "Make this the active semester" button
143-
144-Scenario: non-manager never sees it (UI)
145-  Given a curriculum-admin (staff) user
146:  Then the Settings tab button AND the footer "Settings" link are hidden
147-   And calling switchTab('settings') leaves them where they were
148:   And the button is not visible even though loadSettingsForm ran (assert not visible, not count 0)
149-
150:Scenario: the Settings dropdown keeps the header in step (regression, round 2)
151:  Given the header shows Spring 2026
152:  When Settings' dropdown picks Fall 2026, then the header picks Spring 2026
153:  Then the app is back on Spring 2026 (the header change fired)
154-
155-Scenario: a camp season active can't be removed (edge)
156-  Given Summer 2026 is active
157-  Then Curriculum Admin shows no Delete and no Publish toggle for it, and the activation confirm said so
--
168-
169-Scenario: archiving an old class semester hides it and deletes nothing (safety)
170-  Given Spring 2026 is not active and has lessons, cut bank and change history (manager session, real write)
171-  When the manager clicks Archive on it and confirms
172:  Then appData.semesters.spring-2026.archived = true and nothing else in appData changed (ignoring lastUpdated/By)
173-   And curriculum/lessonData, cutProjects, changeLog, prepData for spring-2026 read back byte-identical
174:   And Spring 2026 is absent from the header, Teacher View, Curriculum Admin, Settings and "Copy from" lists
175-
176:Scenario: unarchive brings it back (happy path)
177:  When the manager clicks Unarchive in Settings → Archived semesters
178:  Then the archived field is removed and Spring 2026 is listed everywhere again with all its lessons
179-
180:Scenario: a browser that remembered an archived semester (edge)
181:  Given a teacher's browser remembers spring-2026, which is then archived
182-  When they load the Classbook
183-  Then they land on the active semester
184-
185:Scenario: the active semester can't be archived; an archived one can't be made active (edge)
186:  Then the active semester shows no Archive, and an archived semester is not listed where "Make active" lives
187-
188:Scenario: a stale tab keeps saving into an archived semester (edge, harmless)
189:  Given tab B is open on Spring 2026's lessons when tab A archives it
190-  When tab B saves a lesson
191:  Then the save succeeds into existing data, and after Unarchive the change is there
192-
193:Scenario: a new semester can't reuse an archived key (edge)
194:  When a manager creates a semester whose key matches an archived one
195:  Then it refuses and points to Unarchive; nothing is written
196-
197-Scenario: camp and SDOC deletes are unchanged (regression)
198-  Then the existing camp-removal and SDOC-year delete tests pass unmodified
199-
--
208-  When tab A confirms
209-  Then it refuses and asks for a reload
210-
211-Scenario: re-render does not stack handlers (regression)
212:  After makeSemesterActive runs twice, one header change calls setGlobalSemester exactly once</div>
213-</div>
214-
215-<div class="phase" id="phase-2">
216-<h3>Phase 2: "Switch everyone to it" <span class="status-tag not-ready">execution-ready: false</span></h3>
--
219-  <li>The Phase 1 confirmation has a checkbox, <strong>"Also switch everyone to Fall 2026 the next time they open the Classbook"</strong>, ticked by default (Q2). Because a plain <code>confirm()</code> can't hold a checkbox, the confirmation becomes a small in-app modal, reusing the existing <code>simple-modal</code> styling.</li>
220-  <li>With it ticked, every <strong>person</strong> who can see that semester lands on it the next time they load the Classbook, once per person, not once per browser. On a shared studio computer, each teacher who signs in is moved once (Codex finding 2). That includes the manager who made the switch, on their next load. After that, any semester they pick sticks as usual.</li>
221-  <li>The switch is tied to <strong>that</strong> semester. If someone later makes a different semester active without ticking the box, browsers that haven't loaded yet are not moved anywhere.</li>
222-  <li>A user who can't see the semester yet (unpublished; rare, since activation publishes) isn't moved, and isn't marked done either. If it becomes visible while the switch still stands, they move then.</li>
223:  <li>With it unticked, nobody's remembered semester moves. An unticked activation <strong>deletes</strong> any earlier switch record in the same transaction, so an old switch can never come back to life (Codex finding 1).</li>
224-  <li>Tabs already open move on their next reload, not live.</li>
225-</ul>
226:<p><strong>Shape:</strong> the "seen" marker is per signed-in user: <code>localStorage['activeSemesterSwitchSeen:' + uid]</code>. <code>globalSemesterKey</code> stays browser-wide as today. When unticked, the transaction writes <code>activeSemesterSwitch: FieldValue.delete()</code>. When ticked, the same transaction writes <code>activeSemesterSwitch: { to: key, at: new Date().toISOString() }</code>. It must be a <strong>client ISO string</strong>, the way <code>lastUpdated</code> is: a <code>serverTimestamp()</code> reads back as a Timestamp, would never equal the stored string, and would re-switch on every load. Compare <code>String(sw.at)</code>. <strong>Placement is load-bearing:</strong> the check runs <em>once</em> in the <code>DOMContentLoaded</code> sequence, after <code>requireAuth</code> and <code>loadConfig()</code> (<code>app.js:148-152</code>) and before <code>initGlobalSemesterSelector()</code> (<code>:158</code>). Never inside <code>initGlobalSemesterSelector</code>, which is re-called after creating a semester and after <code>makeSemesterActive</code>, and would consume the manager's own switch in the same page load. It's one map field, so it replaces the previous switch whole. On load, before the existing pick at <code>app.js:65</code>, with <code>sw = currentConfig.activeSemesterSwitch</code> and <code>seen = localStorage['activeSemesterSwitchSeen:' + getAuthUser().uid]</code>:</p>
227-<ul>
228-  <li>If <code>sw</code> is missing, or <code>sw.at === seen</code>: do nothing.</li>
229-  <li>If <code>sw.to !== currentConfig.activeSemester</code>: the switch is stale, so mark it seen and do nothing.</li>
230-  <li>If <code>canSeeSemester(sw.to)</code>: set <code>globalSemesterKey = sw.to</code> and <strong>write <code>localStorage.globalSemesterKey</code> here</strong> (the <code>setItem</code> at :69 sits in the fallback branch, which this makes false), then mark it seen.</li>
231-  <li>Otherwise (can't see it yet): don't move and don't mark it seen.</li>
232-</ul>
233-<p><strong>Decided asymmetry:</strong> a browser that marked a switch seen through the stale branch isn't moved if that same target becomes active again later without a new tick, while a browser that never loaded would be. That's acceptable: a later switch is a new <code>at</code> and moves everyone.</p>
234:<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
235-<div class="note">A new <strong>field</strong> on existing <code>curriculum/appData</code>. It's not a new collection, so no rules change. Nothing reads it until the first switch, so deploying Phase 2 moves nobody.</div>
236-
237-<div class="bdd">Scenario: teachers are moved once (happy path) — staged so the first sign-in can't consume it (Codex finding 5)
238-  Given a teacher signed in via the form in a fresh context while NO switch exists
239-   And their browser then remembers "spring-2026"
240-   And a manager context then makes Fall active with the box ticked (T1)
241-  When the teacher reloads the Classbook
242:  Then they land on Fall 2026, localStorage.globalSemesterKey = "fall-2026", activeSemesterSwitchSeen = T1
243-  When they pick Spring 2026 and reload
244-  Then they stay on Spring 2026
245-
246-Scenario: the manager who switched is moved too (edge)
247-  Given the manager made Fall active with the box ticked, then picked Spring
248-  When they reload
249-  Then they land on Fall 2026 once
250-
251:Scenario: an unticked activation clears an old switch (regression, Codex finding 1)
252:  Given Fall activated ticked (T1), then Summer activated unticked, then Fall activated unticked
253-  When a browser that never loaded since T1 loads
254:  Then it is not moved, and appData has no activeSemesterSwitch
255-
256-Scenario: a shared computer moves each person once (Codex finding 2)
257-  Given teacher A on a shared browser consumed T1, then picked Spring and signed out
258-  When teacher B signs in on that browser for the first time since T1
259-  Then B is moved to Fall; A, signing in again, is not
260-
261:Scenario: unticked moves nobody (edge)
262:  Given the box was unticked (no activeSemesterSwitch written; payload keys asserted)
263-  When a teacher who remembers Spring loads
264:  Then they stay on Spring; the header shows "Fall 2026 (active)"
265-
266-Scenario: a stale switch does not move anyone (edge, finding 5)
267:  Given activeSemesterSwitch.to = "fall-2026" but activeSemester was since set to "summer-2026" (unticked)
268-  When a not-yet-loaded browser loads
269-  Then it is not moved, and the switch is marked seen
270-
271-Scenario: invisible target waits (edge, finding 6)
272:  Given activeSemesterSwitch.to is unpublished and the user is a teacher
273-  When they load
274-  Then not moved, not marked seen; after it is published and they reload, they are moved
275-
276-Scenario: a second switch later in the year (edge)
--
283-  When the switch is written
284-  Then that tab stays on Spring until it reloads
285-
286-Scenario: deploy alone moves nobody (safety)
287:  Given appData has no activeSemesterSwitch
288-  When any user loads the new build
289-  Then their remembered semester is unchanged</div>
290-</div>
291-
--
293-<div class="safe">
294-  <ul>
295-    <li><strong>Rules:</strong> none needed. <code>curriculum/appData</code>: read for classbook users, write for manager+ only (<code>firestore.rules:652-669</code>). No new collection. Phase 1's e2e includes the non-manager refusal against the real rules.</li>
296-    <li><strong>The Delete exposure (finding 3), removed:</strong> making a weekly semester non-active used to arm a hard delete of its whole lesson map. That's already true of Spring 2026 in production. Phase 1 replaces it with Archive, which deletes nothing. Until Phase 1 ships: <strong>don't click Delete on Spring 2026</strong>.</li>
297:    <li><strong>Partial update:</strong> <code>updateAppData</code> (<code>update()</code> of named dotted paths; its <code>set(merge)</code> fallback fires only if appData doesn't exist, which isn't the case here). Only <code>activeSemester</code>, optionally <code>semesters.&lt;key&gt;.published</code> and <code>activeSemesterSwitch</code>, plus the existing <code>lastUpdated</code>/<code>lastUpdatedBy</code>.</li>
298-    <li><strong>No undefined or empty values:</strong> every path is a known string or <code>true</code>. The key is validated against <code>currentConfig.semesters</code> before writing.</li>
299-    <li><strong>Awaited:</strong> the one write is awaited, and on failure the in-memory state is restored exactly (the <code>toggleSemesterPublish</code> pattern, including "field was absent").</li>
300-    <li><strong>Activation</strong> deletes nothing. The previous value is shown in the confirmation. To roll back, make the old semester active again.</li>
301:    <li><strong>No bulk delete remains in this plan:</strong> archive and unarchive each write one field on <code>curriculum/appData</code>. No snapshot is needed because nothing is removed. The removed hard-delete path was the only bulk delete.</li>
302-    <li><strong>Refuses on a bad load:</strong> inherited from <code>updateAppData</code> (config load failed, season registry unknown or error).</li>
303-    <li><strong>Production spot-check</strong> after deploy: Christie uses the button once for real (or the console line has already done it), then checks <code>curriculum/appData.activeSemester</code> in the Firebase Console.</li>
304-  </ul>
305-</div>
--
308-<ul>
309-  <li>New <code>e2e/active-semester.spec.js</code> (emulator only), following the house pattern (finding 1):
310-    <ul>
311-      <li><strong>Payload/shape scenarios</strong> stub <code>window.updateAppData</code> and assert <code>Object.keys(payload).sort()</code> (as <code>data-safety.spec.js:7596-7610</code> does). The in-memory test semester is added to <code>currentConfig</code> in the page only, with an explicit <code>semesterType: 'weekly'</code>.</li>
312:      <li><strong>Top leak risk:</strong> a leaked <code>activeSemesterSwitch</code> would silently move <em>every</em> later test (their contexts carry no <code>activeSemesterSwitchSeen</code>) to <code>sw.to</code>. The restore below is mandatory and read back, and a final assertion in this spec checks appData has no <code>activeSemesterSwitch</code>.</li>
313:      <li><strong>One real round-trip</strong> runs in a manager context (<code>MANAGER_STATE_PATH</code>, first spec to use it). The test semester is created and removed through the app's own <code>updateAppData</code> in that page, and <code>activeSemester</code> is restored to <code>spring-2026</code> and <code>activeSemesterSwitch</code> deleted in <code>afterEach</code> <strong>and</strong> <code>afterAll</code>, each read back. Cleanup is self-contained and doesn't rely on file order. With <code>workers: 1</code> this file happens to run first alphabetically, and a leak would break <code>day-off-camps.spec.js</code> "SDOC R6" and <code>day-off-teacher.spec.js</code> "T20", which read the active semester.</li>
314:      <li><strong>The restore can't run from Node</strong> (the helper is staff, and appData writes are manager-only). <code>afterEach</code>/<code>afterAll</code> open a manager browser context and call the page's own <code>updateAppData</code> (<code>activeSemester: 'spring-2026'</code>, <code>activeSemesterSwitch: FieldValue.delete()</code>, <code>semesters.&lt;test&gt;: FieldValue.delete()</code>), then read back with <code>readAppDataFromServer()</code> (<code>firebase-data.js:243-247</code>).</li>
315-      <li>The <strong>camp-season scenario runs stubbed</strong>. Its auto-publish would otherwise flip the seed's <code>summer-2026.published: false</code>, which <code>day-off-materials</code> M10 and <code>day-off-camps</code> enumerate.</li>
316-      <li>Payloads: use the <code>window.updateAppData</code> stub pattern (<code>data-safety.spec.js:3947-3958</code>), whose payload holds only the caller's keys. <code>withAppDataSpy</code> is file-local and adds <code>lastUpdated</code>.</li>
317-      <li><strong>One real rules refusal</strong> uses the staff account and asserts <code>permission-denied</code> specifically (the seeded season registry is valid, so <code>updateAppData</code>'s own guard won't fire first).</li>
318-      <li><strong>Phase 2's teacher</strong> is a fresh context (blank storageState) signed in with <code>signInViaForm(page, 'teacher')</code>, because <code>login(page,'teacher')</code> on the default state returns the admin. The remembered <code>globalSemesterKey</code> is set <em>after</em> that first load, followed by a reload, because the app writes it itself on first load and the test would otherwise pass vacuously.</li>
--
339-</ol>
340-
341-<h2 id="decisions">Decisions Log (append-only)</h2>
342-<div class="decision">
343:  <strong>Sep 29, 2026: revision 8. Christie chose Archive over hard delete.</strong> Codex round 5 (<code>…-codex-r5.md</code>) was still finding gaps in the hardened hard-delete: <code>saveLessonData</code> runs before a new semester's appData entry exists, so an existence guard would break "Copy from"; and offline detection lags, so stale saves could still resurrect a deleted key. Its minimum was a transaction on every lesson save. Rather than change the app's hottest path for a rare admin action, Christie chose (options: Archive / split out / keep hardening) to <strong>archive old class semesters instead of deleting them</strong>. Removed from the plan: the snapshot download, <code>deleteWeeklySemesterTx</code>, the <code>serverSemesterKeys</code> listener, <code>assertSemesterStillExists</code> and its fail-closed states (so the offline-save behaviour change is gone, and saves are untouched), the lessonData-writer ratchet, and the no-copy "adopt leftovers" confirm. Kept from rounds 1–5: activation by transaction, per-user "switch everyone", clearing the switch when unticked, Settings gating, and the header sync. Permanent deletion of a class semester is no longer offered in the app.
344-</div>
345-<div class="decision">
346-  <strong>Sep 29, 2026: revision 7, after Codex round 4 (<code>…-codex-r4.md</code>).</strong> Codex confirmed the listener approach (<code>currentConfig</code> untouched) and resolved key reuse and the snapshot list. Taken: (1) an explicit list of all seven lessonData writers, including three in <code>app.js</code> (Q&amp;A and help replies) and <code>deleteLessonKey</code>, plus an acorn ratchet so a new writer can't skip the guard; (2) fail-closed <code>pending</code>/<code>unconfirmed</code>/<code>error</code> states with tests. <strong>Behaviour change for Christie:</strong> lesson saves while offline are refused with a clear message instead of hanging and queueing.
347-</div>
348-<div class="decision">
349-  <strong>Sep 29, 2026: revision 6, after Codex round 3 (<code>…-codex-r3.md</code>).</strong> Snapshot contents are confirmed resolved, and the acceptance list now matches. Revision 5's "accept stale-tab orphans; the create pre-check catches them" was wrong: that pre-check runs only with "Copy from", and no-copy creation adopts leftovers by design. Replaced with prevention: a narrow appData listener tracks only the server's semester keys (it never replaces <code>currentConfig</code>), and every weekly lessonData writer checks the key still exists. The no-copy create path now tells the manager how many leftover lessons it will adopt.
350-</div>
351-<div class="decision">
352:  <strong>Sep 29, 2026: revision 5, after Codex confirmation round 2 (<code>…-codex-r2.md</code>).</strong> Findings 1, 2, 4, 5 and the tab-handler item are confirmed resolved. Finding 3 had two gaps, both taken. (a) The snapshot also includes <code>prepData</code>, <code>lessonData_backup</code> and <code>diagnosticDismissals</code> for the key. (b) The delete transaction re-reads lessonData and refuses unless the semester's lessons deep-equal the downloaded snapshot. Retries from other semesters' saves are accepted. Stale-tab re-saves after a delete are defined as an accepted, invisible orphan that the existing <code>createNewSemester</code> pre-check catches, with a test.
353-</div>
354-<div class="decision">
355-  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
356-  <ul>
357:    <li>(1) An unticked activation now deletes any old <code>activeSemesterSwitch</code>, with a three-activation regression test.</li>
358:    <li>(2) The "seen" marker is per user (<code>activeSemesterSwitchSeen:&lt;uid&gt;</code>), so on a shared computer every person moves once. That matches the promise "switch everyone".</li>
359-    <li>(3) Weekly delete takes a JSON snapshot download (forced-server reads) first and removes the appData entry and lesson map in one transaction, with a failure test. The text now says the cut bank and change history stay stored but become unreachable.</li>
360-    <li>(4) Activation runs in a transaction that verifies the target still exists and "active" hasn't changed since the confirmation, so no ghost semester can be created.</li>
361:    <li>(5) The teacher test is staged so the first sign-in can't consume the switch, and the Phase 1 happy path unticks the box.</li>
362-  </ul>
363:  Also taken: the tab button's own click handler refuses Settings for non-managers.<br>
364-  <strong>Scope note for Christie:</strong> finding 3 grows Phase 1 (a snapshot download plus a transaction for delete). It's needed because this feature is what exposes Delete on the old semester.<br>
365-  <strong>Execution-ready reverted to false</strong> until a Codex confirmation round.
366-</div>
367-<div class="decision">
--
369-</div>
370-<div class="decision">
371-  <strong>Sep 29, 2026: revision 3, after round-2 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r2-claude.md</code>).</strong> Round 2 found the write shape safe and listed five blockers, all verified and taken:
372-  <ul>
373:    <li>(a) The Settings dropdown fix syncs the header first, as Teacher View does.</li>
374-    <li>(b) Phase 2's check is a one-shot in <code>DOMContentLoaded</code>, never in <code>initGlobalSemesterSelector</code>, and <code>at</code> is a client ISO string.</li>
375:    <li>(c) "Nobody below manager sees it" was false: curriculum-admin and prep can open Settings through the footer link. Phase 1 hides that link, gates <code>switchTab</code>, and renders the button only for admin/manager.</li>
376:    <li>(d) The e2e restore runs through a manager browser context, not Node. The camp scenario is stubbed so <code>summer-2026.published</code> can't leak. The <code>activeSemesterSwitch</code> leak is flagged as the top risk.</li>
377-    <li>(e) The weekly-delete guard counts from the server (<code>readServerSemesterLessonMap</code>), corrects the false "cut bank and change history" text, and uses the same modal as Phase 2 (no <code>prompt()</code>). Three existing <code>data-safety</code> tests change in the same commit.</li>
378-  </ul>
379:  Also taken: an <code>isPublishableType</code> check before auto-publish, the name fallback in the confirm, filtering Settings' options by <code>canSeeSemester</code>, the camp-active consequences named in the confirm and BDD, and the stale-seen asymmetry recorded as a decision.<br>
380-  <strong>Not taken (out of scope, noted):</strong> the dead code at <code>app.js:5069-5074</code> and <code>:4590</code>. <code>deleteLessonData</code> lacks a <code>lessonDataLoadedSuccessfully</code> guard and runs after the appData entry is gone inside a warn-only catch (pre-existing, and the server-read count now gates the whole delete). Cut bank and change history are orphaned by a weekly delete (pre-existing, and the text is now honest about it).
381-</div>
382-<div class="decision">
383-  <strong>Sep 29, 2026: revision 2, after round-1 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r1-claude.md</code>).</strong> Verified against the code and taken:
384-  <ul>
385-    <li>(1) e2e can't write appData with the Node helper, so the house pattern is used: stub-and-payload, one manager round-trip with restore in afterEach+afterAll, one staff refusal.</li>
386:    <li>(2) The Settings dropdown was broken, so it's fixed in Phase 1.</li>
387-    <li>(3) Making a semester non-active arms its Delete, which is already live for Spring. Weekly delete now shows the lesson count and needs the name typed, and the confirm mentions it.</li>
388-    <li>(4) Dropped the false "teachers will stop seeing it" warning (drafts were never visible). Noted that auto-publish makes the badge honest.</li>
389-    <li>(5) Phase 2 stores <code>{to, at}</code> and ignores a switch whose target is no longer active.</li>
390-    <li>(6) An invisible target isn't marked seen.</li>
391:    <li>(7) Attach-once guard on the header listener.</li>
392-    <li>(8) Teacher View's "(current)" is in the re-render set.</li>
393-  </ul>
394-  Low items taken: the set(merge) fallback noted, teacher read access stated, Phase 2 writes <code>localStorage.globalSemesterKey</code> itself, fresh teacher sign-in, restore with read-back plus the lastUpdated-ignoring diff, type-based eligibility. BDD gaps a–e added.<br>
395-  <strong>Deliberately left alone:</strong> the two stale <code>'spring-2026'</code> fallback literals (<code>firebase-data.js:504, 3122</code>). They only fire with no config (the banner state), so they're out of scope and noted here.<br>
--
404-<div class="decision">
405-  <strong>Sep 29, 2026: Christie's answers.</strong> Q1 = class semesters AND Summer camp seasons (SDOC years excluded). Q2 = "switch everyone" ticked by default.
406-</div>
407-<div class="decision">
408:  <strong>Sep 29, 2026: plan created.</strong> From Christie's question about switching active to Fall 2026. Found no UI exists, and that "active" doesn't move returning users (localStorage). Christie: "yes we should do this." Scope: Settings-only control (manager+), auto-publish a draft on activation, optional one-time "switch everyone" through a new appData field. Deliberately <em>not</em> in scope: renaming the misleading <code>getActiveSemesterKey()</code>, a live config listener, and the Curriculum Admin bar (non-managers use it).
409-</div>
410-
411-</body>
412-</html>

codex
Revision 8 names the five obvious UI lists, but I’m widening the scan to every semester-map consumer and every dependent data surface; that’s where archive flags most often leak into reports or fallback logic.
exec
/bin/zsh -lc "rg -n --glob '*.js' --glob '*.html' \"currentConfig\\.semesters|config\\.semesters|Object\\.keys\\(["'^'"\\n]*semesters|Object\\.entries\\(["'^'"\\n]*semesters|Object\\.values\\(["'^'"\\n]*semesters|semesterKeys|activeSemester|canSeeSemester|getActiveSemesterKey|createNewSemester\" ." in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
./e2e/helpers/sdoc.js:43:    currentConfig.semesters[Y] = {
./index.html:244:              <button class="btn-primary" onclick="createNewSemester()">Create Semester</button>
./e2e/day-off-materials.spec.js:395:      currentConfig.semesters.TEST_DATA_SAFETY_draft = { name: 'TEST Weekly Draft', semesterType: 'weekly', published: false, numWeeks: 2, classRoster: {} };
./e2e/day-off-materials.spec.js:403:        const teacherSees = Object.keys(currentConfig.semesters).filter(canSeeSemester);
./e2e/day-off-materials.spec.js:406:      } finally { delete currentConfig.semesters.TEST_DATA_SAFETY_draft; }
./e2e/day-off-teacher.spec.js:26:  await planner.evaluate(({ Y, POOL }) => { currentConfig.semesters[Y].teacherNames = POOL; }, { Y, POOL });
./e2e/day-off-teacher.spec.js:29:  await prep.evaluate(({ Y, POOL }) => { currentConfig.semesters[Y].teacherNames = POOL; currentConfig.semesters[Y].published = true; }, { Y, POOL });
./e2e/day-off-teacher.spec.js:88:    currentConfig.semesters[Y] = {
./e2e/day-off-teacher.spec.js:212:        currentConfig.semesters[Y].teacherNames = ['Alex Smith', 'Alex Jones', ...currentConfig.semesters[Y].teacherNames];
./e2e/day-off-teacher.spec.js:500:    expect(await t.evaluate(() => Object.keys(currentConfig.semesters).filter(canSeeSemester))).not.toContain(Y);
./e2e/day-off-teacher.spec.js:661:    const weekly = await prep.evaluate(() => currentConfig.activeSemester);
./e2e/day-off-camps.spec.js:53:      await page.waitForFunction((k) => !!currentConfig.semesters[k], KEY);
./e2e/day-off-camps.spec.js:94:        delete currentConfig.semesters[k];
./e2e/day-off-camps.spec.js:338:      await curriculumDb.collection('curriculum').doc('appData').update({ [`semesters.${Y}`]: currentConfig.semesters[Y] });
./e2e/day-off-camps.spec.js:351:      expect(await page.evaluate((Y) => currentConfig.semesters[Y].teacherNames, Y)).toContain('TESTteacher1');
./e2e/day-off-camps.spec.js:363:      const realName = currentConfig.semesters[Y].name;
./e2e/day-off-camps.spec.js:370:        currentConfig.semesters[Y].name = 'TEST <img src=x onerror="window.__xss=1">';
./e2e/day-off-camps.spec.js:374:      } finally { window.getAuthUser = realUser; currentConfig.semesters[Y].name = realName; }
./e2e/day-off-camps.spec.js:401:      const realActive = currentConfig.activeSemester;
./e2e/day-off-camps.spec.js:404:        currentConfig.activeSemester = Y;   // unpublished
./e2e/day-off-camps.spec.js:407:        return { key: globalSemesterKey, published: currentConfig.semesters[globalSemesterKey]?.published };
./e2e/day-off-camps.spec.js:408:      } finally { window.getAuthUser = realUser; currentConfig.activeSemester = realActive; }
./e2e/day-off-camps.spec.js:418:    await page.evaluate((Y) => { currentConfig.semesters[Y].teacherNames = ['TESTteacher2']; setGlobalSemester(Y); }, Y);
./e2e/day-off-camps.spec.js:665:      const own = Object.keys(paths).filter(k => k.startsWith('semesters.'));
./e2e/day-off-camps.spec.js:683:    expect(await page.evaluate((Y) => currentConfig.semesters[Y].published, Y)).toBe(false);
./js/firebase-data.js:480:  for (const [key, sem] of Object.entries(semesters)) {
./js/firebase-data.js:504:    activeSemester: 'spring-2026',
./js/firebase-data.js:737:  return Object.keys(currentConfig?.semesters || {}).filter(isDayOffYear);
./js/firebase-data.js:742:  return Object.keys(semesters)
./js/firebase-data.js:794:// Whole-semester bulk writer (restoreFromBackup, createNewSemester,
./js/firebase-data.js:971:// createNewSemester()'s pre-check (deleteSemester() drops a key locally even
./js/firebase-data.js:3113:  const key = getActiveSemesterKey();
./js/firebase-data.js:3114:  return currentConfig.semesters?.[key] || null;
./js/firebase-data.js:3117:function getActiveSemesterKey() {
./js/firebase-data.js:3122:  return currentConfig?.activeSemester || 'spring-2026';
./js/app.js:55:  const semesters = currentConfig.semesters;
./js/app.js:56:  const keys = Object.keys(semesters);
./js/app.js:58:  // Filter semesters: canSeeSemester() — manager+ all; others published, plus
./js/app.js:60:  const visibleKeys = keys.filter(canSeeSemester);
./js/app.js:68:    globalSemesterKey = visibleKeys.includes(currentConfig.activeSemester) ? currentConfig.activeSemester : visibleKeys[0];
./js/app.js:76:    const isActive = key === currentConfig.activeSemester;
./js/app.js:103:  const semester = currentConfig.semesters[key];
./js/app.js:277:function canSeeSemester(key) {
./js/app.js:304:  const semKey = getActiveSemesterKey();
./js/app.js:391:  const semKey = getActiveSemesterKey();
./js/app.js:536:  const semKey = getActiveSemesterKey();
./js/app.js:637:  return getActiveSemesterKey();
./js/app.js:800:  const semesters = currentConfig.semesters;
./js/app.js:803:  const keys = Object.keys(semesters).filter(canSeeSemester);
./js/app.js:818:    const isActive = key === currentConfig.activeSemester;
./js/app.js:4142:  return getActiveSemesterKey();
./js/app.js:4478:  const semesters = currentConfig.semesters;
./js/app.js:4479:  const keys = Object.keys(semesters);
./js/app.js:4492:    const isActive = key === currentConfig.activeSemester;
./js/app.js:4514:    const isActive = currentKey === currentConfig.activeSemester;
./js/app.js:4530:  if (key === currentConfig.activeSemester) {
./js/app.js:4562:  const removed = currentConfig.semesters[key];
./js/app.js:4563:  delete currentConfig.semesters[key];
./js/app.js:4567:    currentConfig.semesters[key] = removed;
./js/app.js:4590:  caCurrentSemester = currentConfig.activeSemester;
./js/app.js:4615:  const hadPublished = 'published' in currentConfig.semesters[key];
./js/app.js:4616:  const previous = currentConfig.semesters[key].published;
./js/app.js:4617:  currentConfig.semesters[key].published = published;
./js/app.js:4622:    if (currentConfig.semesters[key]) {
./js/app.js:4623:      if (hadPublished) currentConfig.semesters[key].published = previous;
./js/app.js:4624:      else delete currentConfig.semesters[key].published;
./js/app.js:4696:  if (currentConfig.semesters?.[key]) { alert(`${currentConfig.semesters[key].name} already exists (${key}).`); return; }
./js/app.js:4708:    currentConfig.semesters[key] = newSem;
./js/app.js:4759:    const taken = new Set(Object.values(semesters).map(sem => sem?.season).filter(Boolean));
./js/app.js:4799:// A lesson slot exactly as createNewSemester() / createLessonSlotsForRoster()
./js/app.js:4803:// real data that createNewSemester()'s slot write would merge over.
./js/app.js:4822:  if (currentConfig.semesters?.[key]) { alert(`Summer ${season} is already in the Classbook.`); return; }
./js/app.js:4842:    currentConfig.semesters[key] = newSem;
./js/app.js:4849:    delete currentConfig.semesters[key];
./js/app.js:4856:async function createNewSemester() {
./js/app.js:4864:  if (currentConfig.semesters[key]) {
./js/app.js:4899:    if (copyFromKey && currentConfig.semesters[copyFromKey]) {
./js/app.js:4908:      // every existing lesson is template-empty (a prior createNewSemester()'s
./js/app.js:4920:      const source = currentConfig.semesters[copyFromKey];
./js/app.js:4980:    currentConfig.semesters[key] = newSem;
./js/app.js:4986:    delete currentConfig.semesters[key];
./js/app.js:5069:  const currentWeek = semKey === getActiveSemesterKey() ? getCurrentWeekNum() : null;
./js/app.js:5072:    wrapper.innerHTML = `<div class="tv-placeholder">${semKey === getActiveSemesterKey()
./js/app.js:7628:  const semKey = getActiveSemesterKey();
./js/app.js:7944:  const semKey = getActiveSemesterKey();
./js/app.js:8868:  const semKey = getActiveSemesterKey();
./js/app.js:8925:  const semKey = getActiveSemesterKey();
./js/app.js:9700:  const currentSemester = currentConfig.semesters?.[globalSemesterKey];
./js/app.js:10209:  const semKey = getActiveSemesterKey();
./js/app.js:10661:  return getActiveSemesterKey();
./js/app.js:10683:    const keys = Object.keys(config.semesters || {});
./js/app.js:10686:      const s = config.semesters[k];
./js/app.js:10687:      const label = s.name + (k === config.activeSemester ? ' (active)' : '');
./js/app.js:10693:  const semester = config.semesters?.[semKey] || {};
./js/app.js:10702:    const isActive = semKey === config.activeSemester;
./js/app.js:10838:  const campSemesters = Object.keys(currentConfig?.semesters || {}).filter(isCampSeason);
./js/app.js:10843:      ? campSemesters.map(k => `${escHtml(currentConfig.semesters[k].name)} (${escHtml(seasonForSemesterSafe(k))})`).join(', ')
./js/app.js:10980:  currentConfig.semesters[semKey].teacherNames = currentNames;
./js/app.js:10983:  currentConfig.semesters[semKey].teacherNames.push('');
./js/app.js:10996:  currentConfig.semesters[semKey].teacherNames = currentNames;
./js/app.js:10999:  currentConfig.semesters[semKey].teacherNames.splice(idx, 1);
./js/app.js:11115:  const semKey = getActiveSemesterKey();
./js/app.js:11247:  config.activeSemester = config.activeSemester || semKey;
./js/app.js:11256:  if (!config.semesters) config.semesters = {};
./js/app.js:11280:        currentConfig.semesters[semKey].teacherNames = [...teacherNames, ...inUse.map(u => u.name).filter(n => !teacherNames.includes(n))];
./js/app.js:11306:  config.semesters[semKey] = { ...(config.semesters[semKey] || {}) };
./js/app.js:11308:    config.semesters[semKey][path.split('.').pop()] = value;
./js/app.js:11318:  // activeSemester is only ever SET when missing, never re-pointed from here.
./js/app.js:11319:  if (!currentConfig?.activeSemester) extraPaths.activeSemester = semKey;
./js/app.js:11330:    currentConfig.semesters = currentConfig.semesters || {};
./js/app.js:11331:    currentConfig.semesters[semKey] = currentConfig.semesters[semKey] || {};
./js/app.js:11333:      currentConfig.semesters[semKey][path.split('.').pop()] = value;
./js/app.js:11336:    if (extraPaths.activeSemester) currentConfig.activeSemester = extraPaths.activeSemester;
./js/app.js:11339:    await createLessonSlotsForRoster(semKey, classRoster, config.semesters[semKey].numWeeks);
./e2e/data-safety.spec.js:49:  // Set semester so getTvSemKey() (→ getActiveSemesterKey() → globalSemesterKey)
./e2e/data-safety.spec.js:499:// applied to the non-summer path. getActiveSemesterKey is a function
./e2e/data-safety.spec.js:519:    window.getActiveSemesterKey = () => semKey;
./e2e/data-safety.spec.js:1194:    // initAdminContext just points getActiveSemesterKey (and, transitively,
./e2e/data-safety.spec.js:2963:        window.getActiveSemesterKey = () => semKey;
./e2e/data-safety.spec.js:3118:        window.getActiveSemesterKey = () => semKey;
./e2e/data-safety.spec.js:3734:        currentConfig.semesters[semKey] = { name: 'Summer Enrichment 2027', numWeeks: 2, classRoster: {} }; // no semesterType
./e2e/data-safety.spec.js:3804:// whole-semester bulk writer behind restoreFromBackup(), createNewSemester()
./e2e/data-safety.spec.js:3892:// Real bug found during the Aug 17 2026 live-deployment review: createNewSemester()'s
./e2e/data-safety.spec.js:3904:test.describe('Data Safety — createNewSemester() copies teacherNames along with classRoster', () => {
./e2e/data-safety.spec.js:3920:        if (!currentConfig.semesters) currentConfig.semesters = {};
./e2e/data-safety.spec.js:3921:        currentConfig.semesters[sourceKey] = {
./e2e/data-safety.spec.js:3949:        try { await createNewSemester(); } finally { window.updateAppData = original; }
./e2e/data-safety.spec.js:3958:      expect(Object.keys(result || {})).toEqual([`semesters.${key}`]);
./e2e/data-safety.spec.js:3967:  // Backtracking audit Phase 11, R4-11: createNewSemester() writes the new
./e2e/data-safety.spec.js:3989:      if (!currentConfig.semesters) currentConfig.semesters = {};
./e2e/data-safety.spec.js:3990:      currentConfig.semesters[sourceKey] = {
./e2e/data-safety.spec.js:4050:          await createNewSemester();
./e2e/data-safety.spec.js:4064:          configHasKey: Object.prototype.hasOwnProperty.call(currentConfig.semesters, newKey),
./e2e/data-safety.spec.js:4146:          await createNewSemester();
./e2e/data-safety.spec.js:4157:          configHasKey: Object.prototype.hasOwnProperty.call(currentConfig.semesters, newKey),
./e2e/data-safety.spec.js:4218:          await createNewSemester();
./e2e/data-safety.spec.js:4225:          configHasKey: Object.prototype.hasOwnProperty.call(currentConfig.semesters, newKey),
./e2e/data-safety.spec.js:4279:          await createNewSemester();
./e2e/data-safety.spec.js:4288:          configHasKey: Object.prototype.hasOwnProperty.call(currentConfig.semesters, newKey),
./e2e/data-safety.spec.js:4316:  test('in-flight guard: a second createNewSemester() call while the first is awaiting is a no-op — one pre-check, one write, one saveConfig()', async ({ browser }) => {
./e2e/data-safety.spec.js:4339:        // first await inside createNewSemester(), so call #1 parks here with
./e2e/data-safety.spec.js:4345:          const first = createNewSemester();
./e2e/data-safety.spec.js:4346:          const second = createNewSemester(); // double-click
./e2e/data-safety.spec.js:4359:            configHasKey: Object.prototype.hasOwnProperty.call(currentConfig.semesters, newKey),
./e2e/data-safety.spec.js:4514:      await page.evaluate((semKey) => { window.getActiveSemesterKey = () => semKey; }, TEST_SEM);
./e2e/data-safety.spec.js:4612:      await page.evaluate((other) => { window.getActiveSemesterKey = () => other; }, OTHER_SEM);
./e2e/data-safety.spec.js:6153:      await page.evaluate((semKey) => { window.getActiveSemesterKey = () => semKey; if (!currentLessonData[semKey]) currentLessonData[semKey] = {}; }, TEST_SEM);
./e2e/data-safety.spec.js:6766:        const sems = currentConfig.semesters;
./e2e/data-safety.spec.js:6946:        currentConfig.semesters['summer-badseason'] = { name: 'TEST Bad Season', semesterType: 'summer-camp', season: 'not-a-year' };
./e2e/data-safety.spec.js:6959:        } finally { delete currentConfig.semesters['summer-badseason']; }
./e2e/data-safety.spec.js:7182:        const sems = currentConfig.semesters;
./e2e/data-safety.spec.js:7233:        const sem = currentConfig.semesters['summer-2026'];
./e2e/data-safety.spec.js:7325:        const sems = currentConfig.semesters;
./e2e/data-safety.spec.js:7383:      currentConfig.semesters[weekly] = { name: 'TEST Summer Enrichment 2027', semesterType: 'weekly', numWeeks: 8, published: false };
./e2e/data-safety.spec.js:7384:      currentConfig.semesters[camp]   = { name: 'TEST Summer 2031', semesterType: 'summer-camp', season: '2031', published: false };
./e2e/data-safety.spec.js:7385:      currentConfig.semesters[sdoc]   = { name: 'TEST SDOC 2026-27', semesterType: 'day-off-camps', published: false };
./e2e/data-safety.spec.js:7512:        window.getActiveSemesterKey = () => semKey;
./e2e/data-safety.spec.js:7610:      expect(Object.keys(payload).sort()).toEqual(['lastUpdated', 'lastUpdatedBy', 'semesters.test-x.published']);
./e2e/data-safety.spec.js:7637:          await updateAppData({ 'semesters.test-x.name': 'TEST X', 'activeSemester': 'test-x' });
./e2e/data-safety.spec.js:7646:      expect(r.set[0].payload.activeSemester).toBe('test-x');
./e2e/data-safety.spec.js:7679:            adoptedDefaults: !!currentConfig?.semesters?.['spring-2026'] && Object.keys(currentConfig?.semesters || {}).length <= 2,
./e2e/data-safety.spec.js:7742:            get: async () => ({ exists: true, data: () => ({ activeSemester: 'fall-2026', semesters: { 'fall-2026': { name: 'Fall 2026', semesterType: 'weekly' } } }) }),
./e2e/data-safety.spec.js:7749:          return { keys: Object.keys(currentConfig.semesters), writes: writes.length };
./e2e/data-safety.spec.js:7768:        currentConfig.semesters['test-pub'] = { name: 'TEST Pub', semesterType: 'weekly', published: false };
./e2e/data-safety.spec.js:7769:        try { await toggleSemesterPublish('test-pub', true); } finally { delete currentConfig.semesters['test-pub']; }
./e2e/data-safety.spec.js:7774:      expect(Object.keys(pub.update[0]).sort()).toEqual(['lastUpdated', 'lastUpdatedBy', 'semesters.test-pub.published']);
./e2e/data-safety.spec.js:7779:        currentConfig.semesters['test-del'] = { name: 'TEST Del', semesterType: 'weekly' };
./e2e/data-safety.spec.js:7783:        finally { window.confirm = realConfirm; window.alert = realAlert; delete currentConfig.semesters['test-del']; }
./e2e/data-safety.spec.js:7789:      expect(Object.keys(del.update[0]).sort()).toEqual(['lastUpdated', 'lastUpdatedBy', 'semesters.test-del']);
./e2e/data-safety.spec.js:8107:      currentConfig.semesters[sem] = {
./e2e/data-safety.spec.js:8368:          await createNewSemester();
./e2e/data-safety.spec.js:8369:          return { appDataWrites, lessonWrites, created: JSON.parse(JSON.stringify(currentConfig.semesters[`summer-${reg.season}`] || null)) };
./e2e/data-safety.spec.js:8372:          delete currentConfig.semesters[`summer-${reg.season}`];
./e2e/data-safety.spec.js:8378:      expect(Object.keys(r.appDataWrites[0])).toEqual(['semesters.summer-2031']);
./e2e/data-safety.spec.js:8445:          await createNewSemester();
./e2e/data-safety.spec.js:8449:          delete currentConfig.semesters['test-autumn-2031'];
./e2e/data-safety.spec.js:8482:        currentConfig.semesters[sem] = { name: 'TEST Summer 2031', semesterType: 'summer-camp', season: '2031', published: false };
./e2e/data-safety.spec.js:8490:        window.updateAppData = async (u) => { appDataWrites.push(Object.keys(u)); delete currentConfig.semesters[sem]; };
./e2e/data-safety.spec.js:8498:          delete currentConfig.semesters[sem]; delete currentLessonData[sem];
./e2e/data-safety.spec.js:8528:        currentConfig.semesters[sem] = { name: 'TEST Weekly', semesterType: 'weekly' };
./e2e/data-safety.spec.js:8533:        window.updateAppData = async () => { delete currentConfig.semesters[sem]; };
./e2e/data-safety.spec.js:8536:        finally { window.confirm = realConfirm; window.updateAppData = realUpdate; window.deleteLessonData = realDelete; delete currentConfig.semesters[sem]; }
./e2e/data-safety.spec.js:8700:        const savedSem = JSON.parse(JSON.stringify(currentConfig.semesters[semKey] || {}));
./e2e/data-safety.spec.js:8710:            inMemoryWeeks: currentConfig.semesters[semKey]?.numWeeks,
./e2e/data-safety.spec.js:8714:          currentConfig.semesters[semKey] = savedSem;
./e2e/data-safety.spec.js:8845:          let stored = { activeSemester: 'fall-2026', teacherMappings: { A: 'x' }, semesters: { 'fall-2026': { name: 'Fall 2026' } } };
./e2e/data-safety.spec.js:8860:          stored = { activeSemester: 'fall-2026', teacherMappings: { A: 'x' }, semesters: { 'fall-2026': { name: 'Fall 2026' } } };
./e2e/data-safety.spec.js:8892:        const sem = currentConfig.semesters['summer-2026'];
./e2e/data-safety.spec.js:8929:        const sems = currentConfig.semesters;
./e2e/data-safety.spec.js:8938:          window.getActiveSemesterKey = () => 'summer-2026';
./e2e/data-safety.spec.js:8951:          window.getActiveSemesterKey = () => 'summer-2031';
./e2e/data-safety.spec.js:9027:        window.getActiveSemesterKey = () => sem;
./e2e/data-safety.spec.js:9065:        currentConfig.semesters[sem] = { name: 'TEST 2031', semesterType: 'summer-camp', season: '2031', numWeeks: 4, startDate: '2031-06-01', timeSlots: [{ key: 'AM', label: 'AM' }], studios: ['SoBo'] };
./e2e/data-safety.spec.js:9066:        window.getActiveSemesterKey = () => sem;
./e2e/data-safety.spec.js:9073:          const afterRefusal = JSON.parse(JSON.stringify(currentConfig.semesters[sem]));
./e2e/data-safety.spec.js:9079:          const afterFailure = JSON.parse(JSON.stringify(currentConfig.semesters[sem]));
./e2e/data-safety.spec.js:9083:          delete currentConfig.semesters[sem];
./e2e/data-safety.spec.js:9108:        currentConfig.semesters[sem] = { name: 'TEST Revert', semesterType: 'weekly', published: true };
./e2e/data-safety.spec.js:9115:          const afterDelete = !!currentConfig.semesters[sem];
./e2e/data-safety.spec.js:9117:          const afterToggle = currentConfig.semesters[sem]?.published;
./e2e/data-safety.spec.js:9121:          delete currentConfig.semesters[sem];

exec
/bin/zsh -lc "sed -n '35,120p' js/app.js; sed -n '260,420p' js/app.js; sed -n '620,845p' js/app.js; sed -n '4440,5020p' js/app.js; sed -n '10640,10910p' js/app.js; sed -n '11220,11355p' js/app.js; sed -n '450,825p' js/firebase-data.js; sed -n '3090,3135p' js/firebase-data.js" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
  'Thu Homeschool 6-8':    { day: 'Thursday',  time: '9:30am', enrollment: 0 },
  'Thu Draw & Paint':      { day: 'Thursday',  time: '3:30pm', enrollment: 0 },
  'Thu Draw & Paint 5pm':  { day: 'Thursday',  time: '5:00pm', enrollment: 0 },
  'Thu Realistic Drawing': { day: 'Thursday',  time: '5:00pm', enrollment: 0 },
  'Fri Homeschool 6-8':    { day: 'Friday',    time: '9:30am', enrollment: 0 },
  'Fri Ceramics':          { day: 'Friday',    time: '3:30pm', enrollment: 0 },
  'Fri Clay Class':        { day: 'Friday',    time: '5:00pm', enrollment: 0 },
  'Teen Digital Art':      { day: 'Saturday',  time: 'TBD',    enrollment: 0 }
};

// ─── Global Semester Management ─────────────────────

function initGlobalSemesterSelector() {
  const select = document.getElementById('global-semester-select');
  const userSpan = document.getElementById('header-user');

  if (!select || !currentConfig?.semesters) return;

  const user = getAuthUser();
  const isAdmin = user && ['admin', 'manager'].includes(user.role);
  const semesters = currentConfig.semesters;
  const keys = Object.keys(semesters);

  // Filter semesters: canSeeSemester() — manager+ all; others published, plus
  // an unpublished SDOC year for the prep team (Phase 2A).
  const visibleKeys = keys.filter(canSeeSemester);

  // Set initial global semester if not set — or if the remembered one is not
  // visible to THIS user (a shared device where a manager last picked a draft
  // semester must not leave a teacher inside it — review).
  if (!globalSemesterKey || !semesters[globalSemesterKey] || !visibleKeys.includes(globalSemesterKey)) {
    // …and the fallback must be visible too (review: an unpublished active
    // semester would otherwise put the teacher straight back inside it).
    globalSemesterKey = visibleKeys.includes(currentConfig.activeSemester) ? currentConfig.activeSemester : visibleKeys[0];
    localStorage.setItem('globalSemesterKey', globalSemesterKey);
  }

  // Populate dropdown
  let html = '';
  for (const key of visibleKeys) {
    const sem = semesters[key];
    const isActive = key === currentConfig.activeSemester;
    const isDraft = sem.published === false;
    let label = sem.name;
    if (isActive) label += ' (active)';
    if (isDraft && isAdmin) label += ' [draft]';
    html += `<option value="${escAttr(key)}" ${key === globalSemesterKey ? 'selected' : ''}>${escHtml(String(label ?? ''))}</option>`;
  }
  select.innerHTML = html;

  // Handle changes
  select.addEventListener('change', () => {
    setGlobalSemester(select.value);
  });

  // Show user name
  if (userSpan && user) {
    userSpan.textContent = user.name || user.email;
  }
}

function setGlobalSemester(key) {
  if (!currentConfig?.semesters?.[key]) return;

  globalSemesterKey = key;
  localStorage.setItem('globalSemesterKey', key);

  // Hide/show Prep Dashboard tab based on semester type
  const semester = currentConfig.semesters[key];
  const prepDashboardTab = document.querySelector('.tab-btn[data-tab="prep-dashboard"]');
  if (prepDashboardTab) {
    if (!isWeeklySemester(key)) {   // camp seasons and SDOC years have no prep dashboard
      prepDashboardTab.style.display = 'none';
      // If currently on Prep Dashboard, switch to Teacher View
      if (document.querySelector('.tab-btn.active')?.dataset.tab === 'prep-dashboard') {
        switchTab('teacher-view');
        return; // Exit early since switchTab will handle the rest
      }
    } else {
      prepDashboardTab.style.display = '';
    }
  }

  // Hide/show Curriculum Admin tab for non-manager users on summer semesters
  updateCurriculumAdminTab();

// which the SDOC rules deliberately deny.
function canPlanDayOffCamps() {
  const user = getAuthUser();
  if (!user) return false;
  return user.role === 'admin' || user.role === 'manager' || !!user.appAccess?.includes('classbook-admin');
}
// Ticking users (the prep team): planners, or prep-access staff who also hold
// 'classbook' — without it the rules deny every SDOC collection.
function canTickDayOffMaterials() {
  const user = getAuthUser();
  if (!user) return false;
  return canPlanDayOffCamps() || (hasPrepAccess() && !!user.appAccess?.includes('classbook'));
}
// Which semesters this user may select, in the header AND Teacher View:
// manager+ see all; everyone else sees published ones, plus an unpublished
// School Day Off Camps year if they are on the prep team (Christie, Sep 24:
// drafts hidden from prep staff in Teacher View too).
function canSeeSemester(key) {
  const user = getAuthUser();
  const sem = currentConfig?.semesters?.[key];
  if (!user || !sem) return false;
  if (user.role === 'admin' || user.role === 'manager') return true;
  if (sem.published !== false) return true;
  return isDayOffYear(key) && canTickDayOffMaterials();
}

// Alias for backward compatibility with existing code
function isAdminOrManager() {
  return hasCurriculumAdminAccess();
}

function hasPrepAccess() {
  const user = getAuthUser();
  if (!user) return false;
  return user.role === 'prep' || hasCurriculumAdminAccess();
}

// Hide/show Curriculum Admin tab based on semester type for non-manager users.
// Called on initial load and on semester change.
function updateCurriculumAdminTab() {
  const user = getAuthUser();
  if (!user || user.role === 'admin' || user.role === 'manager') return; // manager+ always see it
  if (!hasCurriculumAdminAccess()) return; // plain classbook teachers never had it

  const semKey = getActiveSemesterKey();
  const semester = currentConfig?.semesters?.[semKey];
  const caTab = document.querySelector('.tab-btn[data-tab="curriculum-admin"]');
  if (!caTab) return;

  if (semester?.semesterType === 'summer-camp') {
    caTab.style.display = 'none';
    if (document.querySelector('.tab-btn.active')?.dataset.tab === 'curriculum-admin') {
      switchTab('teacher-view');
    }
  } else {
    caTab.style.display = '';
  }
}

function setupRoleAccess() {
  const user = getAuthUser();
  if (!user) return;

  // Manager+: full access to all tabs including Settings
  if (user.role === 'admin' || user.role === 'manager') return;

  // classbook-admin / curriculum-admin / prep role: all tabs EXCEPT Settings
  // Settings is manager+ only — classbook admins can't change semester config
  if (hasCurriculumAdminAccess() || hasPrepAccess()) {
    document.querySelector('.tab-btn[data-tab="settings"]')?.style.setProperty('display', 'none');
    updateCurriculumAdminTab(); // Hide Curriculum Admin on summer semesters
    return;
  }

  // Otherwise: Teacher View only (read-only mode)
  // Hide admin tabs (Curriculum Admin, Settings) and Prep Dashboard
  document.body.classList.add('read-only');
  document.body.classList.add('teacher-view-only');

  // Switch active tab to Teacher View since Curriculum Admin is hidden for teachers
  switchTab('teacher-view');

  // Hide Back to HQ link for non-admin users
  const hqLink = document.getElementById('back-to-hq-link');
  if (hqLink) hqLink.style.display = 'none';
}

// ─── Footer ─────────────────────────────────────────

function setupFooter() {
  document.getElementById('help-link')?.addEventListener('click', (e) => {
    e.preventDefault();
    document.getElementById('help-modal').classList.add('open');
  });
  document.getElementById('help-close')?.addEventListener('click', () => {
    document.getElementById('help-modal').classList.remove('open');
  });

  // Settings link switches to Settings tab — through the tab button, so it gets
  // the same form refresh as clicking the tab (review: it used to bypass it).
  document.getElementById('settings-link')?.addEventListener('click', (e) => {
    e.preventDefault();
    switchTab('settings');
  });

  document.getElementById('footer-sign-out')?.addEventListener('click', (e) => {
    e.preventDefault();
    if (confirm('Sign out?')) authSignOut();
  });

  document.querySelectorAll('.simple-modal-overlay').forEach(overlay => {
    overlay.addEventListener('click', (e) => {
      // Editors with a lot of typing opt out: a stray click beside the box
      // must not throw the work away (Christie, Sep 24).
      if (e.target === overlay && !overlay.hasAttribute('data-sticky')) overlay.classList.remove('open');
    });
  });
}


// ═════════════════════════════════════════════════════
// Teacher View — Lesson Publish Status Checker
// ═════════════════════════════════════════════════════

async function checkPublishStatus() {
  const dashboard = document.getElementById('status-dashboard');
  const btn = document.getElementById('check-status-btn');

  btn.disabled = true;
  btn.textContent = 'Checking...';

  const semKey = getActiveSemesterKey();
  if (!currentLessonData) await loadLessonData();
  const lessons = currentLessonData?.[semKey];

  if (!lessons || Object.keys(lessons).length === 0) {
    dashboard.innerHTML = '<div class="prep-error">No lesson data yet. Set up the class roster in Settings to create lesson slots.</div>';
    btn.disabled = false;
    btn.textContent = 'Check Progress';
    return;
  }

  // Build results from Firestore data using auto-calculated progress
  const teacherMap = {};
  for (const lesson of Object.values(lessons)) {
    if (!lesson.teacher) continue;
    if (!teacherMap[lesson.teacher]) teacherMap[lesson.teacher] = { name: lesson.teacher, lessons: [] };
    teacherMap[lesson.teacher].lessons.push(lesson);
  }

  const results = Object.values(teacherMap);
  renderStatusDashboard(results);
  btn.disabled = false;
  btn.textContent = 'Check Progress';
}

function renderStatusDashboard(results) {
  const dashboard = document.getElementById('status-dashboard');

  let totalLessons = 0, totalComplete = 0, totalIncomplete = 0;
  const teacherCount = results.length;
}

// The dates of the camp on which this plan's title runs.
function dayOffTitleDates(yearKey, slot) {
  const camp = (currentDayOffCamps[yearKey] || []).find(c => c.id === slot?.campId);
  return (camp?.dates || []).filter(d => Object.values(normaliseDayOffDayBlocks(camp.projects?.[d])).includes(slot.projectTitle));
}

let tvInitialized = false;
let tvCurrentView = 'my-schedule';
let tvCurrentTeacher = '';
let tvCurrentClassFilter = 'all';
let tvNavStack = [];  // Stack of { teacher, classFilter, scrollY } for back navigation
let campCompleteData = {};

function getTvSemKey() {
  // Now uses global semester instead of per-tab selection
  return getActiveSemesterKey();
}

function isCoTeacherForCurrentSemester() {
  const user = getAuthUser();
  if (!user || tvCurrentTeacher) return false;
  const semKey = getTvSemKey();
  const lessons = currentLessonData?.[semKey];
  return !!lessons && Object.values(lessons).some(l =>
    Array.isArray(l.sharedWith) && l.sharedWith.includes(user.uid)
  );
}

async function initTeacherView() {
  // Already built: the semester may have changed on another tab — refresh for
  // it (renderTeacherView handles SDOC, and leaving SDOC, itself).
  if (tvInitialized) {
    if (isDayOffYear(getTvSemKey()) || tvTeacherListFor) { renderTvSemesterSelector(); renderQaActivityPanel(); renderTeacherView(); }
    return;
  }
  tvInitialized = true;

  // Load lesson data if not already loaded
  if (!currentLessonData) {
    await loadLessonData();
  }

  // Show banner and abort if load failed — prevents stale blank data from being saved.
  // Not "initialized": the guard can trip transiently now (a listener reload
  // that fails and self-heals — Backtracking audit Phase 7), and the next
  // visit to this tab must be allowed to build it.
  if (lessonDataLoadedSuccessfully === false) {
    tvInitialized = false;
    document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
    return;
  }

  // Set up real-time listener FIRST so the retry mechanism fires even if
  // summer camp data isn't ready yet when we reach the early-return below.
  setupLessonDataListener((data) => {
    currentLessonData = data;
    renderProgressDashboard();
    // SDOC (Phase 2B): a camp with only empty blocks has no slots, and there is
    // no sharedWith — so re-render on every reload while the year is showing
    // (the list and the teacher picker are rebuilt from the camps each time).
    if (isDayOffYear(getTvSemKey())) {
      if (document.querySelector('.tab-btn.active')?.dataset.tab === 'teacher-view') renderTeacherView();
      renderTeacherMappingTable();
      return;
    }
    // If teacher view initialized early without data, reset so it re-runs with the now-loaded data
    const semKey = getTvSemKey();
    const lessons = currentLessonData?.[semKey];
    if (lessons && Object.keys(lessons).length > 0 && tvInitialized && isAdminOrManager()) {
      const hasTeachers = document.getElementById('tv-teacher-select')?.options.length > 1;
      if (!hasTeachers) {
        tvInitialized = false;
        initTeacherView();
      }
    }
    // Skip re-render while a camp is expanded — preserves expanded state on live data updates
    const anyExpanded = document.querySelector('.summer-camp-content:not(.hidden)');
    if (!anyExpanded && (tvCurrentTeacher || isCoTeacherForCurrentSemester())) renderTeacherView();
    // Refresh teacher mapping table in Settings if it exists
    renderTeacherMappingTable();
  });

  // Build semester selector (only show if multiple published semesters)
  renderTvSemesterSelector();

  const semKey = getTvSemKey();
  const lessons = currentLessonData?.[semKey];

  // Before the empty-map "Loading…" branch below — an SDOC year with no camps
  // (or only empty blocks) is an empty map and would otherwise say "Loading"
  // forever. Initialized like any other type (Phase 2B): the listener above is
  // subscribed once, and the controls are bound once; renderTeacherView()
  // builds the SDOC teacher list itself.
  if (isDayOffYear(semKey)) {
    bindTeacherViewControlsOnce();
    renderTeacherView();
    return;
  }

  if (!lessons || Object.keys(lessons).length === 0) {
    document.getElementById('tv-content').innerHTML =
      '<div class="tv-placeholder">Loading teacher data…</div>';
    return;
  }

  // Build teacher list from lesson data
  populateTvTeacherList(lessons);

  // Auto-select teacher for staff users who have a matched teacher name
  const teacherSelect = document.getElementById('tv-teacher-select');
  const matchedTeacher = getTeacherNameForCurrentUser();
  const teachers = [...new Set(Object.values(lessons).map(l => l.teacher).filter(Boolean))].sort();

  let selectedTeacher = null;
  if (matchedTeacher && teachers.includes(matchedTeacher)) {
    selectedTeacher = matchedTeacher;
  }

  if (selectedTeacher) {
    teacherSelect.value = selectedTeacher;
    tvCurrentTeacher = selectedTeacher;
    updateClassFilter();
    renderTeacherView();
  } else if (!tvCurrentTeacher) {
    if (isCoTeacherForCurrentSemester()) {
      renderTeacherView();
    } else {
      document.getElementById('tv-content').innerHTML =
        '<div class="tv-placeholder">Select a teacher to view their classbook.</div>';
    }
  }

  bindTeacherViewControlsOnce();
}

// The Teacher View's controls, bound exactly once however the view was first
// initialized (a weekly/camp semester or an SDOC year).
function bindTeacherViewControlsOnce() {
  const teacherSelect = document.getElementById('tv-teacher-select');
  if (!teacherSelect || teacherSelect.dataset.listenerAttached) return;
  teacherSelect.dataset.listenerAttached = 'true';

  // Teacher select handler
  teacherSelect.addEventListener('change', () => {
    tvCurrentTeacher = teacherSelect.value;
    tvNavStack = [];  // Clear back history on manual teacher change
    updateClassFilter();
    renderTeacherView();
    updateBackButton();
  });

  // Class filter handler
  document.getElementById('tv-class-filter').addEventListener('change', (e) => {
    tvCurrentClassFilter = e.target.value;
    renderTeacherView();
  });

  // View toggle handlers
  document.querySelectorAll('.tv-toggle-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      document.querySelectorAll('.tv-toggle-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');
      tvCurrentView = btn.dataset.tvView;
      renderTeacherView();
    });
  });

  // This Week button
  document.getElementById('tv-this-week-btn').addEventListener('click', scrollToThisWeek);
}

function renderTvSemesterSelector() {
  const group = document.getElementById('tv-semester-group');
  const select = document.getElementById('tv-semester-select');
  if (!group || !select || !currentConfig?.semesters) return;

  // Get published semesters (or all for admin/manager)
  const user = getAuthUser();
  const semesters = currentConfig.semesters;
  // The same rule as the header (Christie, Sep 24): drafts are no longer
  // listed to curriculum-admin staff here — only manager+ see them.
  const keys = Object.keys(semesters).filter(canSeeSemester);

  // Only show if more than one semester available
  if (keys.length <= 1) {
    group.style.display = 'none';
    tvCurrentSemester = null;
    return;
  }

  group.style.display = '';
  const currentKey = getTvSemKey();

  let html = '';
  for (const key of keys) {
    const sem = semesters[key];
    const isActive = key === currentConfig.activeSemester;
    const label = sem.name + (isActive ? ' (current)' : '') + (sem.published === false ? ' [draft]' : '');
    html += `<option value="${escAttr(key)}" ${key === currentKey ? 'selected' : ''}>${escHtml(label)}</option>`;
  }
  select.innerHTML = html;

  // Only attach listener once
  if (!select.dataset.listenerAttached) {
    select.addEventListener('change', () => {
      // It switches the app's semester (it used to set a variable nothing read,
      // so it only ever re-listed the header's semester — impl review, 2B).
      const header = document.getElementById('global-semester-select');
      if (header) header.value = select.value;
      setGlobalSemester(select.value);
      if (isDayOffYear(select.value)) return;   // renderTeacherView() built the SDOC list
      tvCurrentTeacher = '';
      tvCurrentClassFilter = 'all';
      tvNavStack = [];
      const semKey = getTvSemKey();
      const lessons = currentLessonData?.[semKey];
      if (lessons) {
        populateTvTeacherList(lessons);
        // Re-auto-select teacher for staff users after semester switch
        const matchedTeacher = getTeacherNameForCurrentUser();
        const allTeachers = [...new Set(Object.values(lessons).map(l => l.teacher).filter(Boolean))];
        if (matchedTeacher && allTeachers.includes(matchedTeacher)) {
          document.getElementById('tv-teacher-select').value = matchedTeacher;
          tvCurrentTeacher = matchedTeacher;
      const lesson = lessons[lessonKey];
      if (!lesson) return '';
      const title = lesson.projectTitle;
      const planDot = lesson.planComplete
        ? `<span style="color:#10B981;" title="Plan complete">●</span>`
        : `<span style="color:var(--gray-300);" title="No plan yet">●</span>`;
      const titleHtml = title && !isSummerNoPlanTitle(title)
        ? `<button onclick="showAdminEdit('${escAttr(lessonKey)}', '${escAttr(sess.teacher)}', '${escAttr(campTopic + ' - ' + block)}', ${weekNum})" style="background:none;border:none;color:var(--purple);font-size:0.85rem;cursor:pointer;padding:0;text-align:left;font-weight:500;text-decoration:underline;">${escHtml(title)}</button>`
        : `<span style="color:var(--gray-400);font-size:0.85rem;">${title ? escHtml(title) : '—'}</span>`;
      return `<tr>
        <td style="padding:0.4rem 0.75rem;font-size:0.82rem;font-weight:600;color:var(--gray-600);background:var(--gray-50);border:1px solid var(--gray-200);white-space:nowrap;">${escHtml(block)}</td>
        <td style="padding:0.4rem 0.75rem;border:1px solid var(--gray-200);">${planDot} ${titleHtml}</td>
      </tr>`;
    }).filter(Boolean).join('');

    if (!rows) return;

    html += `<div style="margin-bottom:1.25rem;border-radius:var(--radius);overflow:hidden;border:1px solid var(--gray-200);">
      <div style="padding:0.6rem 0.75rem;background:${color}18;border-left:4px solid ${color};display:flex;align-items:center;gap:0.75rem;">
        <span style="font-weight:700;font-size:0.95rem;">${escHtml(campTopic)}</span>
        <span style="font-size:0.8rem;color:${color};font-weight:600;">${escHtml(sess.teacher)}</span>
        <span style="font-size:0.78rem;color:var(--gray-500);">${escHtml(sess.studio)} · ${escHtml(sess.timeSlot || '')}</span>
      </div>
      <table style="border-collapse:collapse;width:100%;">${rows}</table>
    </div>`;
  });

  return html || `<div class="tv-placeholder">No lesson data found for Week ${weekNum}.</div>`;
}

// ─── End Summer CA Views ──────────────────────────────────────────────────────

function renderSemesterSelector() {
  const bar = document.getElementById('ca-semester-bar');
  const select = document.getElementById('ca-semester-select');
  const publishGroup = document.getElementById('ca-semester-publish-group');
  if (!bar || !select || !currentConfig?.semesters) return;

  const semesters = currentConfig.semesters;
  const keys = Object.keys(semesters);

  // Only show bar if user is admin/manager
  const user = getAuthUser();
  if (!user || !['admin', 'manager'].includes(user.role)) { bar.style.display = 'none'; return; }

  bar.style.display = 'flex';
  const currentKey = getAdminSemKey();

  // Build dropdown options
  let optionsHtml = '';
  for (const key of keys) {
    const sem = semesters[key];
    const isActive = key === currentConfig.activeSemester;
    const isPublished = sem.published !== false;
    const label = sem.name + (isActive ? ' (active)' : '') + (!isPublished ? ' [draft]' : '');
    optionsHtml += `<option value="${escAttr(key)}" ${key === currentKey ? 'selected' : ''}>${escHtml(label)}</option>`;
  }
  select.innerHTML = optionsHtml;
  select.onchange = () => setGlobalSemester(select.value);

  // Populate "copy from" dropdown in new semester modal
  const copyFrom = document.getElementById('new-sem-copy-from');
  if (copyFrom) {
    let copyHtml = '<option value="">Start blank (no classes)</option>';
    for (const key of keys.filter(k => !isDayOffYear(k))) {
      copyHtml += `<option value="${escAttr(key)}">${escHtml(semesters[key].name)}</option>`;
    }
    copyFrom.innerHTML = copyHtml;
  }

  // Publish toggle for current semester
  const sem = semesters[currentKey];
  if (sem) {
    const isPublished = sem.published !== false;
    const isActive = currentKey === currentConfig.activeSemester;
    publishGroup.innerHTML = `
      ${isActive ? '<span class="ca-sem-active-badge">Active Semester</span>' : ''}
      ${!isActive ? `<label class="ca-publish-toggle">
        <input type="checkbox" ${isPublished ? 'checked' : ''} onchange="toggleSemesterPublish('${escAttr(currentKey)}', this.checked)">
        Published (visible to teachers)
      </label>` : ''}
      ${!isPublished && !isActive ? '<span class="ca-sem-unpublished-badge">Draft</span>' : ''}
      ${!isActive ? `<button class="btn-text ca-delete-sem-btn" onclick="deleteSemester('${escAttr(currentKey)}')" title="Delete this semester">&#128465; Delete</button>` : ''}
    `;
  }
}

async function deleteSemester(key) {
  const sem = currentConfig?.semesters?.[key];
  if (!sem) return;
  if (key === currentConfig.activeSemester) {
    alert('Cannot delete the active semester.');
    return;
  }
  // Removing a CAMP season from the Classbook removes only this app's entry
  // for it. Its camps, schedule, plans and photos belong to the Summer Camp
  // App and stay exactly where they are — adding the season back from the
  // registry restores the whole view (Phase 1, 1.7). This supersedes the
  // companion plan's summer-delete design, which predates seasons.
  // An SDOC year: refused while any event exists (a forced-server count);
  // otherwise only its appData entry goes — it has nothing in
  // curriculum/lessonData, and no collection is ever cleared from here.
  if (isDayOffYear(key)) {
    let events;
    try { events = await countDayOffEvents(key); }
    catch (err) { alert(`Could not check "${sem.name}" for events: ${err.message}\n\nNothing was changed.`); return; }
    if (events > 0) { alert(`"${sem.name}" still has ${events} event${events === 1 ? '' : 's'}. Remove its events first.`); return; }
  }
  const isCamp = isCampSeason(key);
  const isDayOff = isDayOffYear(key);
  const firstConfirm = isDayOff
    ? `Delete the school year "${sem.name}"? It has no events, so only the year itself is removed.`
    : isCamp
    ? `Remove "${sem.name}" from the Classbook?\n\nThis only removes it here. Every camp, schedule, lesson plan and photo stays in the Summer Camp App, and you can add the season back at any time from + New Semester.`
    : `Delete semester "${sem.name}"? This will remove all its lesson data, cut bank, and change history. This cannot be undone.`;
  if (!confirm(firstConfirm)) return;
  if (!isCamp && !isDayOff && !confirm(`Are you sure? Type OK in your head and click OK to confirm.`)) return;

  // Remove the semester's own entry and nothing else (Phase 1, 1.2). Revert
  // this tab if the write is refused, or the config would be missing a
  // semester the server still has — with no alert and no re-render to show it
  // (Phase 1 review).
  const removed = currentConfig.semesters[key];
  delete currentConfig.semesters[key];
  try {
    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
  } catch (err) {
    currentConfig.semesters[key] = removed;
    console.error('❌ Could not remove the semester:', err);
    alert(`Could not remove "${sem.name}": ${err.message}\n\nNothing was changed.`);
    renderSemesterSelector();
    return;
  }

  // Drop this season's in-memory map either way…
  if (currentLessonData?.[key]) {
    delete currentLessonData[key];
  }
  // …but only a WEEKLY semester has lessons of its own inside
  // curriculum/lessonData to delete. A camp season's lessons live in the
  // shared summerCamps_* collections and are never touched from here.
  if (isDayOff) {
    delete currentDayOffEvents[key]; delete currentDayOffCamps[key]; delete currentDayOffPlans[key]; delete currentDayOffSignoffs[key];
  } else if (!isCamp) {
    try {
      await deleteLessonData(key);
    } catch (e) { console.warn('Could not delete lesson data for', key, e); }
  }

  // Switch to active semester
  caCurrentSemester = currentConfig.activeSemester;
  renderSemesterSelector();
  renderAdminGrid();
  renderHelpQueue();
  renderCutBank();
  renderIdeaBank();
  renderChangeHistory();
}

function switchAdminSemester(key) {
  // Delegates to global semester — CA always stays in sync with the header selector
  setGlobalSemester(key);
}

async function toggleSemesterPublish(key, published) {
  if (!currentConfig?.semesters?.[key]) return;
  if (!isPublishableType(key)) { alert('This semester type can\'t be published.'); return; }
  // SDOC (Phase 2B): publishing shows the year to every teacher on a camp —
  // say so first if some camps have nobody to see them.
  if (published && isDayOffYear(key)) {
    // The camp list below must be real to warn from — never publish on a failed load.
    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
    const bare = (currentDayOffCamps[key] || []).filter(c => !(c.teachers || []).length).length;
    if (bare && !confirm(`${bare} camp${bare === 1 ? ' has' : 's have'} no teacher yet — publish anyway?`)) { renderSemesterSelector(); return; }
  }
  const hadPublished = 'published' in currentConfig.semesters[key];
  const previous = currentConfig.semesters[key].published;
  currentConfig.semesters[key].published = published;
  try {
    await updateAppData({ [`semesters.${key}.published`]: published });
  } catch (err) {
    // Restore exactly what was there — including "the field was absent".
    if (currentConfig.semesters[key]) {
      if (hadPublished) currentConfig.semesters[key].published = previous;
      else delete currentConfig.semesters[key].published;
    }
    console.error('❌ Could not change the publish state:', err);
    alert(`Could not ${published ? 'publish' : 'unpublish'} that semester: ${err.message}\n\nNothing was changed.`);
  }
  renderSemesterSelector();
}

// Which types may be published to teachers. SDOC years joined in Phase 2B,
// when teachers got their day-off plans to build.
const PUBLISHABLE_SEMESTER_TYPES = new Set([SEMESTER_TYPES.weekly, SEMESTER_TYPES.camp, SEMESTER_TYPES.dayOff]);
function isPublishableType(semKey) { return PUBLISHABLE_SEMESTER_TYPES.has(semesterTypeOf(semKey)); }

function openNewSemesterModal() {
  document.getElementById('ca-new-semester-modal')?.classList.add('open');
  // Reset to the default type each time, then load the seasons on offer.
  const weeklyRadio = document.querySelector('input[name="new-sem-type"][value="weekly"]');
  if (weeklyRadio) weeklyRadio.checked = true;
  onNewSemesterTypeChange();
  populateNewSemesterSeasons();
  document.getElementById('new-sem-name')?.focus();
}

function selectedNewSemesterType() {
  return document.querySelector('input[name="new-sem-type"]:checked')?.value || SEMESTER_TYPES.weekly;
}

function onNewSemesterTypeChange() {
  const type = selectedNewSemesterType();
  const weekly = document.getElementById('new-sem-weekly-fields');
  const camp = document.getElementById('new-sem-camp-fields');
  const dayOff = document.getElementById('new-sem-dayoff-fields');
  if (weekly) weekly.hidden = type !== SEMESTER_TYPES.weekly;
  if (camp) camp.hidden = type !== SEMESTER_TYPES.camp;
  if (dayOff) {
    dayOff.hidden = type !== SEMESTER_TYPES.dayOff;
    if (type === SEMESTER_TYPES.dayOff) resetDayOffYearFields();
  }
}

// Defaults: Aug 1 of this year → May 31 of the next; name follows the dates
// until the admin types their own.
function resetDayOffYearFields() {
  const y = new Date().getFullYear();
  const start = document.getElementById('new-sem-dayoff-start');
  const end = document.getElementById('new-sem-dayoff-end');
  const name = document.getElementById('new-sem-dayoff-name');
  if (start) start.value = `${y}-08-01`;
  if (end) end.value = `${y + 1}-05-31`;
  if (name) delete name.dataset.edited;
  onDayOffYearDatesChange();
}

function onDayOffYearDatesChange() {
  const name = document.getElementById('new-sem-dayoff-name');
  if (!name || name.dataset.edited) return;
  const start = document.getElementById('new-sem-dayoff-start')?.value || '';
  const end = document.getElementById('new-sem-dayoff-end')?.value || '';
  name.value = start && end ? dayOffYearLabels(start, end).name : '';
}

// An SDOC school year: one appData entry through the field-path writer, after
// a forced-server absence check. No roster, no lesson slots, no
// curriculum/lessonData write.
async function createDayOffYear() {
  const startDate = document.getElementById('new-sem-dayoff-start')?.value || '';
  const endDate = document.getElementById('new-sem-dayoff-end')?.value || '';
  const name = document.getElementById('new-sem-dayoff-name')?.value.trim() || '';
  if (!isIsoDate(startDate) || !isIsoDate(endDate)) { alert('Pick the school year\'s start and end dates.'); return; }
  if (endDate <= startDate) { alert('The school year has to end after it starts.'); return; }
  if (!name) { alert('Give the school year a name.'); return; }
  const { key } = dayOffYearLabels(startDate, endDate);
  if (currentConfig.semesters?.[key]) { alert(`${currentConfig.semesters[key].name} already exists (${key}).`); return; }

  creatingSemester = true;
  try {
    const serverConfig = await readAppDataFromServer();
    if (serverConfig?.semesters?.[key]) {
      alert(`A school year with key "${key}" was already created (in another tab, or by another admin). Reload to see it.`);
      creatingSemester = false;
      return;
    }
    const newSem = { name, semesterType: SEMESTER_TYPES.dayOff, startDate, endDate, published: false, teacherNames: [] };
    await updateAppData({ [`semesters.${key}`]: newSem });
    currentConfig.semesters[key] = newSem;
  } catch (err) {
    console.error('❌ Could not create the school year:', err);
    alert(`Could not create that school year: ${err.message}`);
    creatingSemester = false;
    return;
  }
  // The write landed — anything failing from here is display only.
  try {
    currentDayOffEvents[key] = [];
    currentDayOffCamps[key] = [];
    currentDayOffPlans[key] = {};
    currentDayOffSignoffs[key] = {};
    if (currentLessonData) currentLessonData[key] = {};
    closeNewSemesterModal();
    renderSemesterSelector();
    initGlobalSemesterSelector();
    alert(`${name} created. It stays hidden from teachers. Next: add its teacher names in Settings, then its day-off dates and camps in Curriculum Admin.`);
  } catch (err) {
    console.error('School year created, but the page did not refresh:', err);
    alert(`${name} was created, but the page didn't refresh properly — reload to see it.`);
  } finally {
    creatingSemester = false;
  }
}

// The Camp season option offers exactly the registry seasons that do not
// already have a semester here. In legacy mode there is no registry to read,
// and with nothing left to add there is nothing to choose — either way the
// option is disabled with the reason shown, never silently empty (1.6).
async function populateNewSemesterSeasons() {
  const select = document.getElementById('new-sem-season');
  const campRadio = document.getElementById('new-sem-type-camp');
  const note = document.getElementById('new-sem-camp-unavailable');
  if (!select || !campRadio || !note) return;
  const disable = (reason) => {
    campRadio.disabled = true;
    note.textContent = reason;
    note.hidden = false;
    select.innerHTML = '';
  };
  const mode = getSeasonRegistryMode();
  if (mode === 'legacy') return disable('Camp seasons need the Summer Camp App to set up its seasons first — none exist yet.');
  if (mode !== 'filtered') return disable("Can't read the season registry right now, so a camp season can't be added.");
  try {
    const registered = await listRegisteredSeasons();
    // A season is "taken" by a stored `season` OR by the key it would be
    // created under. The key check matters before the type migration has run:
    // summer-2026 carries no `season` field yet, and matching on that alone
    // would offer 2026 again and create a duplicate semester.
    const semesters = currentConfig?.semesters || {};
    const taken = new Set(Object.values(semesters).map(sem => sem?.season).filter(Boolean));
    const available = registered.filter(r => !taken.has(r.season) && !semesters[`summer-${r.season}`]);
    if (available.length === 0) {
      return disable(registered.length === 0
        ? 'The Summer Camp App has not created any seasons yet.'
        : 'Every season the Summer Camp App has created is already in the Classbook.');
    }
    campRadio.disabled = false;
    note.hidden = true;
    select.innerHTML = available.map(r => {
      const range = r.startDate && r.endDate ? ` (${formatSeasonDate(r.startDate)} – ${formatSeasonDate(r.endDate)})` : '';
      return `<option value="${escAttr(r.season)}">${escHtml(r.name || `Summer ${r.season}`)}${escHtml(range)}</option>`;
    }).join('');
    newSemesterSeasonsByYear = Object.fromEntries(available.map(r => [r.season, r]));
  } catch (err) {
    console.error('Could not list the registry seasons:', err);
    disable("Couldn't read the season registry, so a camp season can't be added right now.");
  }
}

let newSemesterSeasonsByYear = {};

function formatSeasonDate(iso) {
  const d = new Date(`${iso}T00:00:00`);
  return Number.isNaN(d.getTime()) ? iso : d.toLocaleDateString(undefined, { month: 'short', day: 'numeric', year: 'numeric' });
}

function closeNewSemesterModal() {
  document.getElementById('ca-new-semester-modal')?.classList.remove('open');
}

// In-flight guard: the Create button is a bare onclick with no disabled state,
// so a double-click ran two overlapping creations. Both passed the
// "already exists" check (the key is only added to currentConfig after the
// first await), and a split success/failure would let the failing run's
// cleanup below delete the succeeding run's server-side slots. Set before the
// first await, cleared in `finally` — everything between the check and the
// set is synchronous, so the second click always sees it.
let creatingSemester = false;

// A lesson slot exactly as createNewSemester() / createLessonSlotsForRoster()
// generate it: identity + enrollment metadata, every other field at its empty
// default. Deliberately stricter than lessonHasContent() — projectTitle,
// materials, photoUrl, qaThread etc. are not CONTENT_FIELDS but are still
// real data that createNewSemester()'s slot write would merge over.
function isTemplateEmptyLesson(lesson) {
  if (!lesson || typeof lesson !== 'object') return false;
  const IDENTITY = new Set(['teacher', 'className', 'weekNum', 'classSize']);
  return Object.entries(lesson).every(([k, v]) =>
    IDENTITY.has(k) || v == null || v === '' || v === 0 || v === false ||
    (Array.isArray(v) && v.length === 0)
  );
}

// A camp season is created from the registry, never typed in (1.6 / D3): no
// roster, no week grid, no lesson slots and no curriculum/lessonData write —
// its camps arrive from the Summer Camp App when Christie publishes them.
async function createCampSeasonSemester() {
  const season = document.getElementById('new-sem-season')?.value;
  const registry = newSemesterSeasonsByYear[season];
  if (!season || !registry) { alert('Pick a season first.'); return; }

  const key = `summer-${season}`;
  if (currentConfig.semesters?.[key]) { alert(`Summer ${season} is already in the Classbook.`); return; }
  // The same completeness check Re-sync makes — otherwise a half-set-up season
  // could be ADDED with numWeeks 0 and no studios, and would then render with
  // 2026's fallback shape and hours (Phase 1 fix review).
  const problems = registrySeasonProblems(registry);
  if (problems.length) {
    alert(`Summer ${season} isn't ready yet: the Summer Camp App's season still needs ${problems.join(', ')}. Finish setting it up there, then add it here.`);
    return;
  }

  creatingSemester = true;
  try {
    // The local check above only saw this tab's config.
    const serverConfig = await readAppDataFromServer();
    if (serverConfig?.semesters?.[key]) {
      alert(`Summer ${season} was already added (in another tab, or by another admin). Reload to see it.`);
      return;
    }
    const newSem = semesterFromRegistrySeason(registry);
    await updateAppData({ [`semesters.${key}`]: newSem });
    currentConfig.semesters[key] = newSem;
    closeNewSemesterModal();
    renderSemesterSelector();
    initGlobalSemesterSelector();
    alert(`${newSem.name} added. It stays hidden from teachers until you publish it, and its camps appear here as the Summer Camp App publishes them.`);
  } catch (err) {
    console.error('❌ Could not add the camp season:', err);
    delete currentConfig.semesters[key];
    alert(`Could not add that season: ${err.message}`);
  } finally {
    creatingSemester = false;
  }
}

async function createNewSemester() {
  if (creatingSemester) return;
  if (selectedNewSemesterType() === SEMESTER_TYPES.camp) return await createCampSeasonSemester();
  if (selectedNewSemesterType() === SEMESTER_TYPES.dayOff) return await createDayOffYear();
  const name = document.getElementById('new-sem-name')?.value.trim();
  if (!name) { alert('Semester name is required.'); return; }

  const key = name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');
  if (currentConfig.semesters[key]) {
    alert(`A semester with key "${key}" already exists.`);
    return;
  }

  const startDate = document.getElementById('new-sem-start')?.value || '';
  const numWeeks = parseInt(document.getElementById('new-sem-weeks')?.value) || 16;
  const breaksRaw = document.getElementById('new-sem-breaks')?.value.trim() || '';
  const breakWeeks = breaksRaw ? breaksRaw.split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n)) : [];
  const closuresRaw = document.getElementById('new-sem-closures')?.value.trim() || '';
  const closureDates = parseClosureDates(closuresRaw);
  const copyFromKey = document.getElementById('new-sem-copy-from')?.value || '';

  const newSem = {
    name,
    semesterType: SEMESTER_TYPES.weekly,   // stored explicitly from now on (Phase 1, 1.1)
    startDate,
    numWeeks,
    breakWeeks,
    closureDates,
    published: false,
    classRoster: {}
  };

  // Invoked from a bare HTML onclick — nothing above this frame catches, so a
  // failure anywhere below must be handled here (backtracking audit, Phase 11).
  // Two Firestore writes happen in sequence (lesson slots, then config); if the
  // second fails after the first landed, the slots are an orphan on the server
  // for a semester the admin was told didn't get created, and a retry with the
  // same name would silently reuse them. Track whether the first write landed
  // so the catch can compensate.
  let lessonDataCommitted = false;
  creatingSemester = true;
  try {
    // Copy roster from existing semester if selected
    if (copyFromKey && currentConfig.semesters[copyFromKey]) {
      // Pre-check (implementation review, Sep 2026): this branch is the only
      // path that writes lesson data, and the compensating delete in the catch
      // below removes the WHOLE `key` map — only safe if nothing lived there
      // before this call. It can: deleteSemester() drops a key from local
      // state even when its server-side deleteLessonData() fails (warn-only),
      // and config has no live listener, so another admin's same-named
      // semester isn't visible here either. Forced server read — the local
      // cache is exactly what can't be trusted for this key. Refuse unless
      // every existing lesson is template-empty (a prior createNewSemester()'s
      // own leftovers are safe to build on and safe to delete; anything else
      // would be merged over silently by the slot write, then deleted on
      // failure). The no-copy path is deliberately NOT gated: it writes no
      // lesson data, and re-creating a deleted semester there adopts its
      // surviving lesson data — the remedy this alert points at.
      const existingLessonMap = await readServerSemesterLessonMap(key);
      if (existingLessonMap && Object.values(existingLessonMap).some(l => !isTemplateEmptyLesson(l))) {
        alert(`Lesson content already exists in Firestore under the key "${key}".\n\nIf it was left over from a deleted semester, create this semester again without "Copy from" to adopt that data.\n\nIf another admin may have just created it, reload this page first.\n\nOtherwise choose a different name.`);
        return;
      }

      const source = currentConfig.semesters[copyFromKey];
      newSem.classRoster = JSON.parse(JSON.stringify(source.classRoster || {}));
      // Without this, classRoster's teacher fields are copied but the dropdown
      // that lets Settings display/edit them has no options — the roster looks
      // wiped even though the underlying data isn't, and saving Settings in
      // that state silently writes blank teachers over the real ones.
      newSem.teacherNames = JSON.parse(JSON.stringify(source.teacherNames || []));

      // Create empty lesson slots from source semester's teacher/class combos
      const sourceLessons = currentLessonData?.[copyFromKey] || {};
      const combos = new Set();
      for (const lesson of Object.values(sourceLessons)) {
        combos.add(`${lesson.teacher}|||${lesson.className}`);
      }

      const emptyLessons = {};
      for (const combo of combos) {
        const [teacher, className] = combo.split('|||');
        for (let w = 1; w <= numWeeks; w++) {
          const lessonKey = makeLessonKey(teacher, className, w);
          emptyLessons[lessonKey] = {
            teacher,
            className,
            weekNum: w,
            weekDate: '',
            classSize: 0,
            projectTitle: '',
            shortDetails: '',
            inspoLink: '',
            introPitch: '',
            processStep1: '',
            processStep2: '',
            processStep3: '',
            processStep4: '',
            closure: '',
            materials: '',
            dayOfMaterials: '',
            materialsList: [],
            status: '',
            publishToPrep: ''
          };
        }
      }

      if (Object.keys(emptyLessons).length > 0) {
        await saveLessonData(key, emptyLessons);
        if (!currentLessonData) currentLessonData = {};
        currentLessonData[key] = emptyLessons;
        lessonDataCommitted = true;
      }
    }

    // Confirm on the SERVER that the key is free — the check at the top of this
    // function only saw this tab's copy of the config (Phase 1, 1.2). The
    // remaining read-to-update window is accepted: one admin, same class as the
    // existing residual on the Q&A path.
    const serverConfig = await readAppDataFromServer();
    if (serverConfig?.semesters?.[key]) {
      throw new Error(`A semester with the key "${key}" already exists (created in another tab or by another admin). Choose a different name.`);
    }
    currentConfig.semesters[key] = newSem;
    await updateAppData({ [`semesters.${key}`]: newSem });
  } catch (err) {
    console.error('❌ Could not create new semester:', err);
    // Revert both local mutations so a retry isn't blocked by a phantom
    // "already exists" and the grid doesn't render a semester that never saved.
    delete currentConfig.semesters[key];
    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
    // R4-11: the empty lesson slots may already be persisted even though the
    // config never was — clean up the orphaned server-side write, not just the
    // local copy. Safe: this data is template-empty by construction (never had
    // real content), so deleting it loses nothing.
    if (lessonDataCommitted) {
      try {
        await deleteLessonData(key);
      } catch (cleanupErr) {
        console.error('⚠️ Could not clean up orphaned lesson data after failed semester creation:', cleanupErr);
      }
    }
    alert('Could not create the new semester. Please try again.');
    return;
  } finally {
    creatingSemester = false;
  }

  closeNewSemesterModal();
  caCurrentSemester = key;
  renderSemesterSelector();
  renderAdminGrid();
  renderHelpQueue();
  renderCutBank();
  renderIdeaBank();
  renderChangeHistory();
}

async function initCurriculumAdmin() {
  if (caInitialized) return;
  caInitialized = true;

  if (!currentLessonData) await loadLessonData();
  if (!currentChangeLog) await loadChangeLog();

  // Save note buttons
  resultsDiv.querySelectorAll('.diag-note-save').forEach(btn => {
    btn.addEventListener('click', () => {
      const fp = btn.dataset.fp;
      const item = btn.closest('.diag-item');
      const textarea = item.querySelector(`.diag-note-input[data-fp="${fp}"]`);
      if (textarea) {
        // Trigger the blur handler which does the actual save
        textarea.blur();
      }
    });
  });
}

// ═════════════════════════════════════════════════════
// SETTINGS
// ═════════════════════════════════════════════════════

function getSettingsSemKey() {
  // Now uses global semester instead of per-tab selection
  return getActiveSemesterKey();
}

let settingsTeacherPoolAtLoad = { semKey: null, names: [] };
// Which semester the Settings form was last drawn for. Save writes to the
// HEADER's semester, so the two must match: the form used to redraw only on a
// semester change made while on Settings, and after switching semesters
// elsewhere a Save wrote one semester's values onto another (Sep 24).
let settingsFormSemKey = null;

// Redraw only when the header's semester differs from the form's — returning
// to the tab for the same semester keeps any unsaved edits.
function ensureSettingsFormMatchesHeader() {
  if (settingsFormSemKey !== getSettingsSemKey()) loadSettingsForm();
}

function loadSettingsForm() {
  const config = currentConfig || getDefaultConfig();

  // Build semester selector
  const selectEl = document.getElementById('settings-semester-select');
  if (selectEl) {
    const keys = Object.keys(config.semesters || {});
    const currentKey = getSettingsSemKey();
    selectEl.innerHTML = keys.map(k => {
      const s = config.semesters[k];
      const label = s.name + (k === config.activeSemester ? ' (active)' : '');
      return `<option value="${escAttr(k)}" ${k === currentKey ? 'selected' : ''}>${escHtml(label)}</option>`;
    }).join('');
  }

  const semKey = getSettingsSemKey();
  const semester = config.semesters?.[semKey] || {};
  // The pool as this form found it — the × button edits currentConfig's list
  // in place, so saveSettings() cannot use that to see what was removed.
  settingsTeacherPoolAtLoad = { semKey, names: [...(semester.teacherNames || [])] };
  settingsFormSemKey = semKey;

  // Publish toggle
  const publishGroup = document.getElementById('settings-semester-publish-group');
  if (publishGroup) {
    const isActive = semKey === config.activeSemester;
    const isPublished = semester.published !== false;
    if (isActive) {
      publishGroup.innerHTML = '<span class="ca-sem-active-badge">Active Semester — always visible to teachers</span>';
    } else {
      publishGroup.innerHTML = `
        <label class="ca-publish-toggle">
          <input type="checkbox" ${isPublished ? 'checked' : ''} onchange="toggleSemesterPublish('${escAttr(semKey)}', this.checked)">
          Published (visible to teachers)
        </label>
        ${!isPublished ? '<span class="ca-sem-unpublished-badge" style="margin-left:8px">Draft</span>' : ''}
      `;
    }
  }

  const el = (id) => document.getElementById(id);
  if (el('settings-semester-name')) el('settings-semester-name').value = semester.name || '';
  if (el('settings-start-date')) el('settings-start-date').value = semester.startDate || '';
  if (el('settings-num-weeks')) el('settings-num-weeks').value = semester.numWeeks || 16;
  if (el('settings-break-weeks')) el('settings-break-weeks').value = (semester.breakWeeks || []).join(', ');
  if (el('settings-closure-dates')) el('settings-closure-dates').value = formatClosureDates(semester.closureDates || []);

  // Class Roster — auto-populate from defaults if empty
  let roster = semester.classRoster;
  if (!roster || Object.keys(roster).length === 0) {
    roster = JSON.parse(JSON.stringify(DEFAULT_CLASS_ROSTER));
  }
  renderClassRosterTable(roster);

  // Teacher Names List
  renderTeacherNamesList();

  // Teacher Name Mapping
  renderTeacherMappingTable();

  // Show/hide sections by semester TYPE, not by key (Phase 1, 1.1/1.7).
  const isSummer = isCampSeason(semKey);

  // A camp season's shape is the Summer Camp App's to define: name, dates,
  // weeks, breaks, time slots and studios are shown read-only with a re-sync,
  // and Save writes only the fields this type owns (settingsFieldPathsFor()).
  document.querySelectorAll('.weekly-only-field').forEach(el => {
    el.querySelectorAll('input, select, textarea').forEach(f => { f.disabled = isSummer; });
  });
  const nameField = document.getElementById('settings-semester-name');
  if (nameField) nameField.disabled = isSummer;
  const readOnlyNote = document.getElementById('settings-camp-readonly-note');
  if (readOnlyNote) {
    readOnlyNote.hidden = !isSummer;
    if (isSummer) {
      readOnlyNote.innerHTML = `This season's name, dates, weeks, break, time slots and studios come from the Summer Camp App and can't be edited here. `
        + `<button class="btn-secondary write-control" onclick="resyncCampSeasonFromRegistry()" style="margin-left:6px;">Re-sync from Summer Camp App</button>`;
    }
  }

  // Hide weekly-only sections for camp seasons
  document.querySelectorAll('.spring-fall-only').forEach(el => {
    el.style.display = isSummer ? 'none' : 'block';
  });

  // An SDOC year owns name, start, end and its teacher-name pool — no weeks,
  // breaks, closures or class roster (plan 1.5).
  const isDayOff = isDayOffYear(semKey);
  document.querySelectorAll('.weekly-only-field').forEach(row => { row.style.display = isDayOff ? 'none' : ''; });
  document.querySelectorAll('.dayoff-only-field').forEach(row => { row.hidden = !isDayOff; });
  const namesDesc = document.getElementById('teacher-names-desc');
  if (namesDesc) {
    namesDesc.textContent = isDayOff
      ? 'The teachers who may run this year\'s day-off camps. They appear as the teacher checkboxes in each camp.'
      : 'Define teacher names for this semester. These appear in the Class Roster teacher dropdown and Curriculum Admin grid.';
  }
  if (isDayOff) {
    document.querySelectorAll('.weekly-roster-section').forEach(sec => { sec.style.display = 'none'; });
    if (el('settings-dayoff-start')) el('settings-dayoff-start').value = semester.startDate || '';
    if (el('settings-end-date')) el('settings-end-date').value = semester.endDate || '';
  }

  renderSeasonsCard();
  renderSemesterTypeMigrationCard();
}

// Pull this camp season's six registry-sourced fields again — the one way to
// change them here, and it copies rather than types (Phase 1, 1.6/1.7).
async function resyncCampSeasonFromRegistry() {
  const semKey = getSettingsSemKey();
  const sem = currentConfig?.semesters?.[semKey];
  if (!sem || !isCampSeason(semKey)) return;
  try {
    const registered = await listRegisteredSeasons();
    const reg = registered.find(r => r.season === seasonForSemester(semKey));
    if (!reg) { alert(`The Summer Camp App has no season ${seasonForSemester(semKey)} to sync from.`); return; }
    // Validate the RAW registry document: semesterFromRegistrySeason() coerces
    // anything absent to ''/0/[], so checking its OUTPUT could never see a
    // missing name, and let a negative week count or an empty-string studio
    // through (Phase 1 fix review).
    const problems = registrySeasonProblems(reg);
    if (problems.length) {
      alert(`Can't re-sync ${seasonForSemester(semKey)}: the Summer Camp App's season still needs ${problems.join(', ')}. Finish setting it up there first — nothing was changed here.`);
      return;
    }
    const fresh = semesterFromRegistrySeason(reg);
    const paths = {};
    const previous = {};
    for (const f of ['name', 'startDate', 'numWeeks', 'breakWeeks', 'timeSlots', 'studios']) {
      paths[`semesters.${semKey}.${f}`] = fresh[f];
      previous[f] = sem[f];
      sem[f] = fresh[f];
    }
    try {
      await updateAppData(paths);
    } catch (err) {
      // Put this tab back the way it was — the server never changed.
      for (const [f, v] of Object.entries(previous)) { if (v === undefined) delete sem[f]; else sem[f] = v; }
      throw err;
    }
    loadSettingsForm();
    renderAdminGrid();
    alert(`${fresh.name} re-synced from the Summer Camp App.`);
  } catch (err) {
    console.error('Could not re-sync the season:', err);
    alert(`Could not re-sync: ${err.message}`);
  }
}

// Read-only: what the registry holds, which seasons are in the Classbook, and
// which mode this tab is in.
function renderSeasonsCard() {
  const card = document.getElementById('settings-seasons-card');
  if (!card) return;
  const mode = getSeasonRegistryMode();
  const modeText = {
    filtered: 'Season filtering is on — each camp season shows only its own camps.',
    legacy: 'The Summer Camp App has not switched seasons on yet, so Summer 2026 reads everything (there is only one season).',
    error: "Can't read the season registry — check Firestore rules. Camp data is not being shown.",
    unknown: "Can't reach the season registry — waiting for a connection.",
  }[mode] || mode;
  const campSemesters = Object.keys(currentConfig?.semesters || {}).filter(isCampSeason);
  card.innerHTML = `
    <h3 class="settings-subsection-title">Camp Seasons</h3>
    <p class="settings-panel-desc">${escHtml(modeText)}</p>
    <p class="settings-panel-desc">In the Classbook: ${campSemesters.length
      ? campSemesters.map(k => `${escHtml(currentConfig.semesters[k].name)} (${escHtml(seasonForSemesterSafe(k))})`).join(', ')
      : 'none yet'}. Seasons are created in the Summer Camp App, then added here with + New Semester.</p>`;
}

// ─── "Stamp semester types" — the one-time migration (Phase 1, 1.2) ──────────
// Dry run first, always: it reads the SERVER's appData (not this tab's copy),
// lists every change, and refuses if a semester already carries a type that
// contradicts the migration. The write is one update() of field paths, and it
// is verified by a forced-server read-back that diffs field by field.
let pendingSemesterTypeStamps = null;

function renderSemesterTypeMigrationCard() {
  const card = document.getElementById('settings-type-migration-card');
  if (!card) return;
  const user = getAuthUser();
  if (!user || user.role !== 'admin') { card.hidden = true; return; }   // admin-only
  card.hidden = false;
  card.innerHTML = `
    <h3 class="settings-subsection-title">Stamp semester types</h3>
    <p class="settings-panel-desc">A one-time step: records on every semester whether it is weekly classes or a camp season, and fills in Summer 2026's season details. Run the dry run first — it changes nothing.</p>
    <div class="settings-actions" style="justify-content:flex-start;gap:0.5rem;">
      <button class="btn-secondary write-control" onclick="dryRunSemesterTypeStamps()">Dry run</button>
      <button class="btn-primary write-control" id="stamp-types-btn" onclick="applySemesterTypeStamps()" disabled>Stamp semester types</button>
    </div>
    <pre id="stamp-types-output" class="settings-hint" style="white-space:pre-wrap;margin-top:0.5rem;"></pre>`;
}

function stampOutput(text) {
  const out = document.getElementById('stamp-types-output');
  if (out) out.textContent = text;
}

async function dryRunSemesterTypeStamps() {
  pendingSemesterTypeStamps = null;
  const btn = document.getElementById('stamp-types-btn');
  if (btn) btn.disabled = true;
  try {
    const serverConfig = await readAppDataFromServer();
    if (!serverConfig) { stampOutput('There is no app configuration document on the server yet — nothing to stamp.'); return; }
    const stamps = buildSemesterTypeStamps(serverConfig);
    // The snapshot goes to the console before anything is written, so a copy
    // of the pre-migration document exists outside Firestore.
    console.log('📋 appData snapshot before stamping semester types:', JSON.stringify(serverConfig, null, 2));
    const keys = Object.keys(stamps);
    if (keys.length === 0) { stampOutput('Nothing to stamp — every semester already carries its type.'); return; }
    pendingSemesterTypeStamps = { stamps, serverConfig };
    if (btn) btn.disabled = false;
    stampOutput(`${keys.length} change(s) ready. A full snapshot of the current configuration is in the browser console.\n\n`
      + keys.map(k => `  ${k} = ${JSON.stringify(stamps[k])}`).join('\n')
      + `\n\nRun a backup (backup.js --force) before pressing Stamp.`);
  } catch (err) {
    console.error('Dry run failed:', err);
    stampOutput(`Dry run failed: ${err.message}`);
  }
}

async function applySemesterTypeStamps() {
  if (!pendingSemesterTypeStamps) { stampOutput('Run the dry run first.'); return; }
  const { stamps, serverConfig } = pendingSemesterTypeStamps;
  const btn = document.getElementById('stamp-types-btn');
  if (btn) btn.disabled = true;
  try {
    await updateAppData(stamps);
    // Read back from the SERVER and check field by field: every stamped path
    // has its new value, and nothing else moved. lastUpdated/lastUpdatedBy are
    // the two the helper always sets, so they are excluded from the diff.
    const after = await readAppDataFromServer();
    const problems = [];
      mappings[uid] = teacherName;
    }
  });
  return mappings;
}

async function saveSettings() {
  const el = (id) => document.getElementById(id)?.value?.trim() || '';
  // Last line of defence: never write a form drawn for one semester onto another.
  if (settingsFormSemKey !== getSettingsSemKey()) {
    loadSettingsForm();
    alert('This form was showing a different semester from the one selected at the top, so nothing was saved. It now shows the selected semester — check it and save again.');
    return;
  }

  const breakWeeksStr = el('settings-break-weeks');
  const breakWeeks = breakWeeksStr.split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n));
  const closureDates = parseClosureDates(el('settings-closure-dates'));

  const semKey = getSettingsSemKey();
  const classRoster = getClassRosterFromForm();
  const teacherNames = getTeacherNamesFromForm();

  const teacherMappings = getTeacherMappingsFromForm();

  // Merge into existing config to preserve other semesters
  const config = JSON.parse(JSON.stringify(currentConfig || {}));
  config.activeSemester = config.activeSemester || semKey;

  // Safety guard: if the form returned no mappings but existing mappings exist,
  // the user dropdowns likely hadn't finished loading when Save was clicked.
  // Preserve existing mappings to prevent accidental wipeout.
  const existingMappings = currentConfig?.teacherMappings || {};
  config.teacherMappings = Object.keys(teacherMappings).length > 0
    ? teacherMappings
    : existingMappings;
  if (!config.semesters) config.semesters = {};
  // Only the fields this semester's TYPE owns (Phase 1, 1.2). Spreading the
  // whole form is what could put numWeeks: 16, an empty breakWeeks and the
  // hidden default class roster onto a camp season.
  // An SDOC year: its own date fields, and two guards before anything is
  // written — a name a camp still uses can't leave the pool, and the year
  // can't shrink past an existing event's date (forced-server reads).
  const isDayOff = isDayOffYear(semKey);
  if (isDayOff) {
    const start = el('settings-dayoff-start');
    const end = el('settings-end-date');
    if (!isIsoDate(start) || !isIsoDate(end) || end <= start) { alert('The school year needs a start date and an end date after it.'); return; }
    if (!el('settings-semester-name')) { alert('The school year needs a name.'); return; }
    try {
      // The SERVER's pool, not this tab's: the × button edits
      // currentConfig's list before Save runs, and another tab may have added
      // a name (and put it on a camp) since this form loaded (review HIGH).
      const serverPool = (await readAppDataFromServer())?.semesters?.[semKey]?.teacherNames || [];
      const loadedPool = settingsTeacherPoolAtLoad.semKey === semKey ? settingsTeacherPoolAtLoad.names : [];
      const removed = [...new Set([...serverPool, ...loadedPool])].filter(n => !teacherNames.includes(n));
      const inUse = await dayOffTeachersInUse(semKey, removed);
      if (inUse.length) {
        // Put just those names back in this tab's list (other unsaved edits in
        // the form stay as they are).
        currentConfig.semesters[semKey].teacherNames = [...teacherNames, ...inUse.map(u => u.name).filter(n => !teacherNames.includes(n))];
        renderTeacherNamesList();
        alert(`Can't remove ${inUse.map(u => `${u.name} (on ${u.camps.join(', ')})`).join('; ')} — take them off those camps first.\n\nNothing was saved.`);
        return;
      }
      const outside = await dayOffDatesOutside(semKey, start, end);
      if (outside.length) {
        alert(`These day-off dates would fall outside the school year: ${outside.map(o => `${o.label} ${o.date}`).join(', ')}. Edit those events first.\n\nNothing was saved.`);
        return;
      }
    } catch (err) {
      alert(`Could not check the school year's camps and events: ${err.message}\n\nNothing was saved.`);
      return;
    }
  }
  const settingsPaths = settingsFieldPathsFor(semKey, {
    endDate: isDayOff ? el('settings-end-date') : undefined,
    name: el('settings-semester-name'),
    startDate: isDayOff ? el('settings-dayoff-start') : el('settings-start-date'),
    numWeeks: parseInt(el('settings-num-weeks')) || 16,
    breakWeeks,
    closureDates,
    teacherNames,
    classRoster,
  });
  // Keep this tab's copy in step with exactly what is being written.
  config.semesters[semKey] = { ...(config.semesters[semKey] || {}) };
  for (const [path, value] of Object.entries(settingsPaths)) {
    config.semesters[semKey][path.split('.').pop()] = value;
  }

  // The two NON-semester fields this form also owns (Phase 1, 1.2). Dropping
  // them was a real regression: teacher mappings are collected by this form
  // and would have been silently lost on every Save.
  const extraPaths = {};
  // teacherMappings keeps its preserve-on-empty guard — an empty form must not
  // wipe existing mappings.
  if (Object.keys(teacherMappings).length > 0) extraPaths.teacherMappings = teacherMappings;
  // activeSemester is only ever SET when missing, never re-pointed from here.
  if (!currentConfig?.activeSemester) extraPaths.activeSemester = semKey;

  try {
    await updateAppData({ ...settingsPaths, ...extraPaths });
    // Keep this tab's config in step with exactly what was written. Before
    // Phase 1 saveConfig() ended with `currentConfig = config`; dropping that
    // left the clone's semester edits stranded, so loadSettingsForm() redrew
    // pre-save values and the NEXT Save wrote them back over the server —
    // silently, with "Settings saved!" both times. currentConfig has no live
    // listener (setupConfigListener() is never called), so nothing else would
    // have corrected it.
    currentConfig.semesters = currentConfig.semesters || {};
    currentConfig.semesters[semKey] = currentConfig.semesters[semKey] || {};
    for (const [path, value] of Object.entries(settingsPaths)) {
      currentConfig.semesters[semKey][path.split('.').pop()] = value;
    }
    if (extraPaths.teacherMappings) currentConfig.teacherMappings = extraPaths.teacherMappings;
    if (extraPaths.activeSemester) currentConfig.activeSemester = extraPaths.activeSemester;

    // Create lesson slots for classes assigned to teachers
    await createLessonSlotsForRoster(semKey, classRoster, config.semesters[semKey].numWeeks);

    alert('Settings saved!');

    // Reload Settings form to show updated teacher names in dropdowns
    loadSettingsForm();

    // Reload other tabs if active
    const activeTab = document.querySelector('.tab-btn.active')?.dataset.tab;
    if (activeTab === 'prep-dashboard') {
      const weekNum = document.getElementById('week-select')?.value || 1;
      loadWeekData(parseInt(weekNum));
    }
  } catch (err) {
    console.error('Error saving settings:', err);
    alert('Error saving settings: ' + err.message);
  }
  const onError = (err) => {
    console.error('❌ Season registry listener failed:', err);
    // Without this a tab whose rule was removed mid-session would sit on
    // "waiting for a connection" when the real cause is the rule.
    // Any other error (typically `unavailable`) leaves the mode as it is. A
    // tab that then can't write has to be reloaded — accepted: reviewed and
    // judged an inconvenience, not worth a retry loop in an error path
    // (Christie's call, Sep 24).
    if (err?.code === 'permission-denied') applySeasonRegistryMode('error', err);
  };
  const sub = subscribe || ((next, error) =>
    currentSeasonDocRef().onSnapshot({ includeMetadataChanges: true }, next, error));
  seasonRegistryUnsubscribe = sub(onSnap, onError) || null;
  return seasonRegistryUnsubscribe;
}

// ─── The one-time type migration (Phase 1, 1.2) ──────────────────────────────
// Pure: given the server's appData, the dotted paths that would stamp it.
// Never overwrites a stored value; refuses a stored type that contradicts the
// migration rather than "fixing" it. The Summer 2026 season facts are carried
// here because the registry may not exist yet when this runs (legacy mode),
// and these are the same values the Summer Camp App seeds into it.
const SUMMER_2026_TIME_SLOTS = [{ key: 'AM', label: 'AM (9am-12pm)' }, { key: 'PM', label: 'PM (1pm-4pm)' }];
const SUMMER_2026_STUDIOS = ['SoBo', 'AG', 'GR', 'MVW', 'Clay Hub', 'Coal Creek'];
function buildSemesterTypeStamps(serverConfig) {
  const semesters = serverConfig?.semesters;
  if (!semesters || typeof semesters !== 'object') {
    throw new Error('Cannot stamp semester types: the appData document has no semesters map.');
  }
  const stamps = {};
  for (const [key, sem] of Object.entries(semesters)) {
    const expected = key === LEGACY_CAMP_SEMESTER_KEY ? SEMESTER_TYPES.camp : SEMESTER_TYPES.weekly;
    if (sem?.semesterType) {
      if (sem.semesterType !== expected) {
        throw new Error(`Semester "${key}" already carries semesterType "${sem.semesterType}" where this migration expects "${expected}" — refusing to overwrite a stored type. Check it by hand before stamping.`);
      }
    } else {
      stamps[`semesters.${key}.semesterType`] = expected;
    }
    if (key !== LEGACY_CAMP_SEMESTER_KEY) continue;
    // Summer 2026's season facts, seeded only where absent.
    if (!sem?.season) stamps[`semesters.${key}.season`] = '2026';
    // The break is calendar position 6. An empty breakWeeks is why the Teacher
    // View calendar currently draws W6 on the break and W7–W11 a week early —
    // seeding it is an intended visible FIX, not a parity break.
    if (!Array.isArray(sem?.breakWeeks) || sem.breakWeeks.length === 0) stamps[`semesters.${key}.breakWeeks`] = [6];
    if (!Array.isArray(sem?.timeSlots) || sem.timeSlots.length === 0) stamps[`semesters.${key}.timeSlots`] = SUMMER_2026_TIME_SLOTS;
    if (!Array.isArray(sem?.studios) || sem.studios.length === 0) stamps[`semesters.${key}.studios`] = SUMMER_2026_STUDIOS;
  }
  return stamps;
}

function getDefaultConfig() {
  return {
    activeSemester: 'spring-2026',
    semesters: {
      'spring-2026': {
        name: 'Spring 2026',
        startDate: '2026-01-12',
        numWeeks: 16,
        breakWeeks: [10],
        classRoster: {}
      }
      // No camp season here on purpose (Phase 1, 1.2): camp seasons are created
      // from the Summer Camp App's registry, never invented by a default.
    },
    lastUpdated: null,
    lastUpdatedBy: null
  };
}

function setupConfigListener(callback) {
  if (!curriculumDb) initCurriculumFirestore();
  if (configUnsubscribe) configUnsubscribe();
  configUnsubscribe = curriculumDb.collection('curriculum').doc('appData')
    .onSnapshot(doc => {
      if (doc.exists) {
        currentConfig = doc.data();
        if (callback) callback(currentConfig);
      }
    });
}

// ─── Prep Data (curriculum/prepData) ─────────────────

async function loadPrepData() {
  if (!curriculumDb) initCurriculumFirestore();
  try {
    const doc = await curriculumDb.collection('curriculum').doc('prepData').get();
    if (doc.exists) {
      currentPrepData = doc.data();
    } else {
      currentPrepData = {};
    }
  } catch (err) {
    console.error('Error loading prep data:', err);
    currentPrepData = {};
  }
  return currentPrepData;
}

async function savePrepWeekData(semesterKey, weekKey, weekData) {
  if (!curriculumDb) initCurriculumFirestore();
  const user = getAuthUser();
  weekData.lastUpdated = new Date().toISOString();
  weekData.lastUpdatedBy = user?.name || 'Unknown';

  const updateObj = {};
  updateObj[`${semesterKey}.${weekKey}`] = weekData;

  const docRef = curriculumDb.collection('curriculum').doc('prepData');
  try {
    await docRef.update(updateObj);
  } catch (err) {
    if (err.code === 'not-found') {
      const nested = {};
      nested[semesterKey] = {};
      nested[semesterKey][weekKey] = weekData;
      await docRef.set(nested);
    } else {
      throw err;
    }
  }
}

async function saveForecastDismissals(semesterKey, dismissals) {
  if (!curriculumDb) initCurriculumFirestore();
  const updateObj = {};
  updateObj[`${semesterKey}.forecastDismissed`] = dismissals;
  const docRef = curriculumDb.collection('curriculum').doc('prepData');
  try {
    await docRef.update(updateObj);
  } catch (err) {
    if (err.code === 'not-found') {
      const nested = {};
      nested[semesterKey] = { forecastDismissed: dismissals };
      await docRef.set(nested);
    } else {
      throw err;
    }
  }
}

function getForecastDismissals(semesterKey) {
  return currentPrepData?.[semesterKey]?.forecastDismissed || {};
}

function setupPrepDataListener(callback) {
  if (!curriculumDb) initCurriculumFirestore();
  if (prepDataUnsubscribe) prepDataUnsubscribe();
  prepDataUnsubscribe = curriculumDb.collection('curriculum').doc('prepData')
    .onSnapshot(doc => {
      if (doc.exists) {
        currentPrepData = doc.data();
        if (callback) callback(currentPrepData);
      }
    });
}

// ─── Prep Cycle Config (curriculum/prepCycleConfig) ──

const DEFAULT_PREP_CYCLE_CONFIG = {
  phases: [
    {
      id: 'monitor-plan',
      name: 'Monitor & Plan',
      emoji: '📋',
      days: ['Monday', 'Thursday'],
      description: 'Check on Thurs for Friday and Monday; make action plan on Mon for Tues.',
      goals: [
        'Prioritized prep task list ready for Tuesday morning',
        'List ready of items needed from storage',
        'Items returning to storage staged on shelving and ready',
        'Prep any day-of items needed for Friday or Monday',
        'Generate trials and process sheets for shared projects — 3 weeks in advance of project',
        'Use Weekly Curriculum meeting to clarify projects and materials'
      ]
    },
    {
      id: 'return-gather',
      name: 'Return & Gather',
      emoji: '📦',
      days: ['Tuesday'],
      description: "Return staged materials to storage and gather what's needed for this week.",
      goals: [
        'Return staged materials to storage (aim for ~2 trips/week)',
        'Delegated prep tasks completed for the day',
        'Prep task list for Wednesday is ready',
        'Keep up on reset materials (threaded needles, model magic, canvas unwrap, etc.)',
        'Use Weekly Curriculum meeting to clarify projects and materials',
        'Cross reference Teacher Process Sheet with Curriculum Map if prep is missing from Prep Dashboard'
      ]
    },
    {
      id: 'prep',
      name: 'Prep',
      emoji: '🎨',
      days: ['Tuesday', 'Wednesday'],
      description: 'Work blocks — prepare items as requested. Prep work should be 2 weeks ahead of project.',
      goals: [
        'Prep work is 2 weeks ahead of project',
        'Keep on top of low supplies — flag via Supply Low List or to manager',
        'Keep list of Friday/Monday reset tasks and daily resets',
        'Keep in communication with SDOC prep lead — trials, process sheets, materials (several weeks ahead)',
        'Cross reference Teacher Process Sheet with Curriculum Map if prep is missing from Prep Dashboard',
        'Cross reference materials needed with list of reset tasks — include day-of materials'
      ]
    },
    {
      id: 'distribute',
      name: 'Distribute',
      emoji: '📤',
      days: ['Tuesday', 'Wednesday'],
      description: 'Prepped items go to teacher tubs or common project shelving.',
      goals: [
        'Prepped materials labeled for teacher: class code, week #, size, quantity',
        'Delegated prep tasks completed for the day',
        'Labeled prepped items distributed to teacher tubs',
        'Keep up on materials needing reset for current week',
        'Cross reference class totals and totals for multiple class projects',
        'Cross reference materials needed with list of reset tasks — include day-of materials'
      ]
    },
    {
      id: 'stage',
      name: 'Stage',
      emoji: '🗂️',
      days: ['Wednesday'],
      description: 'Stage prepped multi-class projects & items to and from storage.',
      goals: [
        'Multi-class project materials staged on shelf in workroom, labeled with example and process sheet',
        'Materials teachers may need later placed on wait shelf',
        'Workroom reset — weekly clear surfaces, keep labeled and accessible',
        'Storage organized — monthly quick reset; keep Materials Locater updated',
        'Cross reference class totals and totals for multiple class projects',
        'Delegate tasks in prep log — each entry labeled with Week #, Class name, total students, Material, quantity, size'
      ]
    },
    {
      id: 'breakdown',
      name: 'Breakdown',
      emoji: '🔄',
      days: ['Wednesday', 'Thursday'],
      description: 'Breakdown returned & unused materials. Stage items on Return shelf.',
      goals: [
        'Materials no longer needed put away; items going to storage staged on return shelf',
        'Look ahead for materials finished with one project but needed for an upcoming project — redistribute',
        'Thursday: review curriculum for Friday & Monday needs; prep as needed; prep Open Studio for Monday',
        'Keep up on materials needing reset for current week',
        'Delegate tasks in prep log — each entry labeled with Week #, Class name, total students, Material, quantity, size',
        'Generate trials and process sheets for shared projects — 3 weeks in advance of project'
      ]
    }
  ]
};

async function getPrepCycleConfig() {
  if (!curriculumDb) initCurriculumFirestore();
  try {
    const doc = await curriculumDb.collection('curriculum').doc('prepCycleConfig').get();
    if (doc.exists && doc.data().phases?.length) {
      return doc.data();
    }
  } catch (err) {
    console.warn('Could not load prep cycle config, using defaults:', err);
  }
  return DEFAULT_PREP_CYCLE_CONFIG;
}

async function savePrepCycleConfig(config) {
  if (!curriculumDb) initCurriculumFirestore();
  const user = getAuthUser();
  const toSave = {
    ...config,
    lastUpdated: new Date().toISOString(),
    lastUpdatedBy: user?.name || 'Unknown'
  };
  await curriculumDb.collection('curriculum').doc('prepCycleConfig').set(toSave);
}

// ─── Lesson Data (curriculum/lessonData) ─────────────

// Every camp-season semester in the config, with the season each one reads.
// In legacy mode the 2026 season reads unfiltered (it is the only season that
// exists by definition) and any other camp season loads nothing at all —
// there is nothing stamped for it yet (Phase 1, 1.3/1.4).
function dayOffYearKeys() {
  return Object.keys(currentConfig?.semesters || {}).filter(isDayOffYear);
}

function campSeasonLoadPlan() {
  const semesters = currentConfig?.semesters || {};
  return Object.keys(semesters)
    .filter(isCampSeason)
    .map(semKey => {
      const season = seasonForSemester(semKey);
      if (seasonRegistryMode === 'legacy') {
        return season === LEGACY_SEASON ? { semKey, season: null } : { semKey, season, unavailable: true };
      }
      return { semKey, season };
    });
}

// One camp season's lessons, or an empty map when legacy mode cannot serve it.
async function loadOneCampSeason(plan, opts = {}) {
  if (plan.unavailable) { currentSummerSessionsBySemester[plan.semKey] = []; return {}; }
  return await loadSummerCampData({ ...opts, season: plan.season, semKey: plan.semKey });
}

async function loadLessonData() {
  if (!curriculumDb) initCurriculumFirestore();
  try {
    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
    currentLessonData = doc.exists ? doc.data() : {};

    // Every camp season gets its own map (Phase 1, 1.4) — no literal key.
    try {
      const plans = campSeasonLoadPlan();
      console.log('📚 Loading camp seasons:', plans.map(p => `${p.semKey}${p.season ? ` (${p.season})` : ' (unfiltered)'}`).join(', ') || 'none');
      for (const plan of plans) {
        currentLessonData[plan.semKey] = await loadOneCampSeason(plan);
        console.log(`📚 ${plan.semKey}: ${Object.keys(currentLessonData[plan.semKey]).length} lessons`);
      }
      // School Day Off Camps years: their own three collections. A failure
      // trips the same app-wide guard — loud, never a quiet empty list.
      for (const yearKey of dayOffYearKeys()) {
        currentLessonData[yearKey] = await loadDayOffCampData({ yearKey });
        console.log(`📚 ${yearKey}: ${Object.keys(currentLessonData[yearKey]).length} day-off camp plans`);
      }
      lessonDataLoadedSuccessfully = true;
    } catch (err) {
      // One season failing trips the guard for the whole app: a partially
      // loaded model is not a safe base for any writer, in any semester.
      console.error('❌ Could not load camp season data:', err);
      lessonDataLoadedSuccessfully = false;
    }
  } catch (err) {
    console.error('Error loading lesson data:', err);
    currentLessonData = {};
    lessonDataLoadedSuccessfully = false;
  }
  return currentLessonData;
}

// Whole-semester bulk writer (restoreFromBackup, createNewSemester,
// createLessonSlotsForRoster). Guarded the same way as
// saveSingleLesson(): after a failed load, `lessons` is built from an empty or
// partial currentLessonData (or, for restoreFromBackup, would land over a
// semester whose current state this client never confirmed), and merge:true
// would still write it over the real semester map. Throws rather than no-ops —
// every caller treats a resolved promise as "the write landed" (backtracking
// audit, Phase 11).
async function saveLessonData(semesterKey, lessons) {
  if (lessonDataLoadedSuccessfully === false) {
    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
  }
  if (!curriculumDb) initCurriculumFirestore();

  // Route by the semester's TYPE, never by its key (Phase 1, 1.1): camp
  // seasons go to the per-lesson collection (also dodging the 1MB doc limit),
  // and any other type is refused rather than misrouted.
  if (lessonStoreFor(semesterKey) === 'camp') {
    return await saveSummerCampLessonData(semesterKey, lessons);
  }

  // Regular semester: save to curriculum/lessonData
  const user = getAuthUser();
  await curriculumDb.collection('curriculum').doc('lessonData').set({
    [semesterKey]: lessons,
    lastUpdated: new Date().toISOString(),
    lastUpdatedBy: user?.name || 'Unknown'
  }, { merge: true });
}

// Explicitly delete a single lesson key from the nested map.
// More reliable than resaving the full semester when cutting a project,
async function dayOffTeachersInUse(yearKey, names) {
  if (!names.length) return [];
  const camps = await dayOffServerDocs('camps', 'yearKey', yearKey);
  return names.filter(n => camps.some(c => (c.teachers || []).includes(n)))
    .map(n => ({ name: n, camps: camps.filter(c => (c.teachers || []).includes(n)).map(c => c.title) }));
}

// Event dates the proposed school-year bounds would exclude.
async function dayOffDatesOutside(yearKey, startDate, endDate) {
  const events = await dayOffServerDocs('events', 'yearKey', yearKey);
  const out = [];
  for (const e of events) for (const d of e.dates || []) { if (d < startDate || d > endDate) out.push({ label: e.label, date: d }); }
  return out;
}

async function countDayOffEvents(yearKey) {
  return (await dayOffServerDocs('events', 'yearKey', yearKey)).length;
}

// ─── Helpers ─────────────────────────────────────────

function getActiveSemester() {
  if (!currentConfig) return null;
  const key = getActiveSemesterKey();
  return currentConfig.semesters?.[key] || null;
}

function getActiveSemesterKey() {
  // Use global semester if set, otherwise fall back to active semester
  if (globalSemesterKey && currentConfig?.semesters?.[globalSemesterKey]) {
    return globalSemesterKey;
  }
  return currentConfig?.activeSemester || 'spring-2026';
}

exec
/bin/zsh -lc "rg -n --glob '"'!e2e/**'"' --glob '"'!node_modules/**'"' \"semesters\" ." in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
./js/app.js:51:  if (!select || !currentConfig?.semesters) return;
./js/app.js:55:  const semesters = currentConfig.semesters;
./js/app.js:56:  const keys = Object.keys(semesters);
./js/app.js:58:  // Filter semesters: canSeeSemester() — manager+ all; others published, plus
./js/app.js:65:  if (!globalSemesterKey || !semesters[globalSemesterKey] || !visibleKeys.includes(globalSemesterKey)) {
./js/app.js:75:    const sem = semesters[key];
./js/app.js:97:  if (!currentConfig?.semesters?.[key]) return;
./js/app.js:103:  const semester = currentConfig.semesters[key];
./js/app.js:118:  // Hide/show Curriculum Admin tab for non-manager users on summer semesters
./js/app.js:175:  // Hide Prep Dashboard tab for summer camp semesters (prep is done in Summer Camp App)
./js/app.js:176:  const currentSemester = currentConfig?.semesters?.[globalSemesterKey];
./js/app.js:273:// Which semesters this user may select, in the header AND Teacher View:
./js/app.js:279:  const sem = currentConfig?.semesters?.[key];
./js/app.js:305:  const semester = currentConfig?.semesters?.[semKey];
./js/app.js:330:    updateCurriculumAdminTab(); // Hide Curriculum Admin on summer semesters
./js/app.js:580:  const pool = new Set(currentConfig?.semesters?.[yearKey]?.teacherNames || []);
./js/app.js:704:  // Build semester selector (only show if multiple published semesters)
./js/app.js:796:  if (!group || !select || !currentConfig?.semesters) return;
./js/app.js:798:  // Get published semesters (or all for admin/manager)
./js/app.js:800:  const semesters = currentConfig.semesters;
./js/app.js:803:  const keys = Object.keys(semesters).filter(canSeeSemester);
./js/app.js:817:    const sem = semesters[key];
./js/app.js:1063:  // Summer camp semesters: group by camp name instead of week number
./js/app.js:1610:  const semester = currentConfig?.semesters?.[semKey];
./js/app.js:1831:  const semester = currentConfig?.semesters?.[semKey];
./js/app.js:2451:  const semester = currentConfig?.semesters?.[semKey] || getActiveSemester();
./js/app.js:3731:// deploy for replies they had already read, in weekly semesters too.
./js/app.js:4175:  const sem = currentConfig?.semesters?.[semKey] || {};
./js/app.js:4476:  if (!bar || !select || !currentConfig?.semesters) return;
./js/app.js:4478:  const semesters = currentConfig.semesters;
./js/app.js:4479:  const keys = Object.keys(semesters);
./js/app.js:4491:    const sem = semesters[key];
./js/app.js:4505:      copyHtml += `<option value="${escAttr(key)}">${escHtml(semesters[key].name)}</option>`;
./js/app.js:4511:  const sem = semesters[currentKey];
./js/app.js:4528:  const sem = currentConfig?.semesters?.[key];
./js/app.js:4562:  const removed = currentConfig.semesters[key];
./js/app.js:4563:  delete currentConfig.semesters[key];
./js/app.js:4565:    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
./js/app.js:4567:    currentConfig.semesters[key] = removed;
./js/app.js:4605:  if (!currentConfig?.semesters?.[key]) return;
./js/app.js:4615:  const hadPublished = 'published' in currentConfig.semesters[key];
./js/app.js:4616:  const previous = currentConfig.semesters[key].published;
./js/app.js:4617:  currentConfig.semesters[key].published = published;
./js/app.js:4619:    await updateAppData({ [`semesters.${key}.published`]: published });
./js/app.js:4622:    if (currentConfig.semesters[key]) {
./js/app.js:4623:      if (hadPublished) currentConfig.semesters[key].published = previous;
./js/app.js:4624:      else delete currentConfig.semesters[key].published;
./js/app.js:4696:  if (currentConfig.semesters?.[key]) { alert(`${currentConfig.semesters[key].name} already exists (${key}).`); return; }
./js/app.js:4701:    if (serverConfig?.semesters?.[key]) {
./js/app.js:4707:    await updateAppData({ [`semesters.${key}`]: newSem });
./js/app.js:4708:    currentConfig.semesters[key] = newSem;
./js/app.js:4758:    const semesters = currentConfig?.semesters || {};
./js/app.js:4759:    const taken = new Set(Object.values(semesters).map(sem => sem?.season).filter(Boolean));
./js/app.js:4760:    const available = registered.filter(r => !taken.has(r.season) && !semesters[`summer-${r.season}`]);
./js/app.js:4822:  if (currentConfig.semesters?.[key]) { alert(`Summer ${season} is already in the Classbook.`); return; }
./js/app.js:4836:    if (serverConfig?.semesters?.[key]) {
./js/app.js:4841:    await updateAppData({ [`semesters.${key}`]: newSem });
./js/app.js:4842:    currentConfig.semesters[key] = newSem;
./js/app.js:4849:    delete currentConfig.semesters[key];
./js/app.js:4864:  if (currentConfig.semesters[key]) {
./js/app.js:4899:    if (copyFromKey && currentConfig.semesters[copyFromKey]) {
./js/app.js:4920:      const source = currentConfig.semesters[copyFromKey];
./js/app.js:4977:    if (serverConfig?.semesters?.[key]) {
./js/app.js:4980:    currentConfig.semesters[key] = newSem;
./js/app.js:4981:    await updateAppData({ [`semesters.${key}`]: newSem });
./js/app.js:4986:    delete currentConfig.semesters[key];
./js/app.js:5066:  const semester = currentConfig?.semesters?.[semKey] || getActiveSemester();
./js/app.js:6360:  // Gather cut projects from other semesters
./js/app.js:6365:      const semName = currentConfig?.semesters?.[key]?.name || key;
./js/app.js:6394:  // Other semesters
./js/app.js:6396:    html += `<details style="margin-top:16px"><summary style="font-size:14px;font-weight:600;cursor:pointer;color:var(--tinker-purple)">From previous semesters (${otherSemesters.reduce((s, o) => s + o.projects.length, 0)} projects)</summary>`;
./js/app.js:6436:  const srcSemName = currentConfig?.semesters?.[srcSemKey]?.name || srcSemKey;
./js/app.js:6677:    <p class="ca-ideabank-empty">No project ideas yet. Add ideas anytime — they persist across semesters.</p>`;
./js/app.js:7955:  const currentSemester = currentConfig?.semesters?.[semKey];
./js/app.js:9700:  const currentSemester = currentConfig.semesters?.[globalSemesterKey];
./js/app.js:10667:// semester change made while on Settings, and after switching semesters
./js/app.js:10683:    const keys = Object.keys(config.semesters || {});
./js/app.js:10686:      const s = config.semesters[k];
./js/app.js:10693:  const semester = config.semesters?.[semKey] || {};
./js/app.js:10787:  const sem = currentConfig?.semesters?.[semKey];
./js/app.js:10806:      paths[`semesters.${semKey}.${f}`] = fresh[f];
./js/app.js:10838:  const campSemesters = Object.keys(currentConfig?.semesters || {}).filter(isCampSeason);
./js/app.js:10843:      ? campSemesters.map(k => `${escHtml(currentConfig.semesters[k].name)} (${escHtml(seasonForSemesterSafe(k))})`).join(', ')
./js/app.js:10916:    // loss anywhere is caught — not only in the semesters that happened to
./js/app.js:10920:      if (IGNORE_TOP.has(field) || field === 'semesters') continue;
./js/app.js:10923:    const beforeSems = serverConfig.semesters || {};
./js/app.js:10924:    const afterSems = after?.semesters || {};
./js/app.js:10928:      if (!now) { problems.push(`semesters.${key} disappeared`); continue; }
./js/app.js:10932:        problems.push(`semesters.${key} appeared after the dry run and was NOT stamped — re-run the dry run and stamp again`);
./js/app.js:10936:        if (`semesters.${key}.${field}` in stamps) continue;
./js/app.js:10937:        if (stableJson(now[field]) !== stableJson(before[field])) problems.push(`semesters.${key}.${field} changed unexpectedly`);
./js/app.js:10964:  const semester = currentConfig?.semesters?.[semKey] || {};
./js/app.js:10980:  currentConfig.semesters[semKey].teacherNames = currentNames;
./js/app.js:10983:  currentConfig.semesters[semKey].teacherNames.push('');
./js/app.js:10996:  currentConfig.semesters[semKey].teacherNames = currentNames;
./js/app.js:10999:  currentConfig.semesters[semKey].teacherNames.splice(idx, 1);
./js/app.js:11020:  const semester = currentConfig?.semesters?.[semKey] || {};
./js/app.js:11082:  const semester = currentConfig?.semesters?.[semKey] || {};
./js/app.js:11245:  // Merge into existing config to preserve other semesters
./js/app.js:11256:  if (!config.semesters) config.semesters = {};
./js/app.js:11273:      const serverPool = (await readAppDataFromServer())?.semesters?.[semKey]?.teacherNames || [];
./js/app.js:11280:        currentConfig.semesters[semKey].teacherNames = [...teacherNames, ...inUse.map(u => u.name).filter(n => !teacherNames.includes(n))];
./js/app.js:11306:  config.semesters[semKey] = { ...(config.semesters[semKey] || {}) };
./js/app.js:11308:    config.semesters[semKey][path.split('.').pop()] = value;
./js/app.js:11330:    currentConfig.semesters = currentConfig.semesters || {};
./js/app.js:11331:    currentConfig.semesters[semKey] = currentConfig.semesters[semKey] || {};
./js/app.js:11333:      currentConfig.semesters[semKey][path.split('.').pop()] = value;
./js/app.js:11339:    await createLessonSlotsForRoster(semKey, classRoster, config.semesters[semKey].numWeeks);
./js/app.js:11378:  if (!isWeeklySemester(semKey)) return;   // Phase 1, 1.1 — only weekly semesters have a class roster; a third type is skipped by construction
./js/app.js:12517:  const year = currentConfig?.semesters?.[yearKey] || {};
./js/app.js:12759:  const pool = [...new Set([...(currentConfig?.semesters?.[yearKey]?.teacherNames || []), ...(camp.teachers || [])])];
./js/firebase-data.js:46:  const stored = currentConfig?.semesters?.[semKey]?.semesterType;
./js/firebase-data.js:114:  const stored = currentConfig?.semesters?.[semKey]?.season;
./js/firebase-data.js:255:function settingsFieldPathsFor(semKey, values, semesters) {
./js/firebase-data.js:256:  const type = (semesters || currentConfig?.semesters)?.[semKey]?.semesterType
./js/firebase-data.js:258:  const p = (f) => `semesters.${semKey}.${f}`;
./js/firebase-data.js:475:  const semesters = serverConfig?.semesters;
./js/firebase-data.js:476:  if (!semesters || typeof semesters !== 'object') {
./js/firebase-data.js:477:    throw new Error('Cannot stamp semester types: the appData document has no semesters map.');
./js/firebase-data.js:480:  for (const [key, sem] of Object.entries(semesters)) {
./js/firebase-data.js:487:      stamps[`semesters.${key}.semesterType`] = expected;
./js/firebase-data.js:491:    if (!sem?.season) stamps[`semesters.${key}.season`] = '2026';
./js/firebase-data.js:495:    if (!Array.isArray(sem?.breakWeeks) || sem.breakWeeks.length === 0) stamps[`semesters.${key}.breakWeeks`] = [6];
./js/firebase-data.js:496:    if (!Array.isArray(sem?.timeSlots) || sem.timeSlots.length === 0) stamps[`semesters.${key}.timeSlots`] = SUMMER_2026_TIME_SLOTS;
./js/firebase-data.js:497:    if (!Array.isArray(sem?.studios) || sem.studios.length === 0) stamps[`semesters.${key}.studios`] = SUMMER_2026_STUDIOS;
./js/firebase-data.js:505:    semesters: {
./js/firebase-data.js:737:  return Object.keys(currentConfig?.semesters || {}).filter(isDayOffYear);
./js/firebase-data.js:741:  const semesters = currentConfig?.semesters || {};
./js/firebase-data.js:742:  return Object.keys(semesters)
./js/firebase-data.js:1182:      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
./js/firebase-data.js:1188:      console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
./js/firebase-data.js:1193:      // one still renders: the non-summer semesters in this snapshot are new.
./js/firebase-data.js:1483:    // summer semesters), but this guard exists so a future caller can't
./js/firebase-data.js:2303:  const year = currentConfig?.semesters?.[yearKey];
./js/firebase-data.js:2401:  const serverYear = (await readAppDataFromServer())?.semesters?.[yearKey];
./js/firebase-data.js:3114:  return currentConfig.semesters?.[key] || null;
./js/firebase-data.js:3119:  if (globalSemesterKey && currentConfig?.semesters?.[globalSemesterKey]) {
./index.html:469:        <p class="settings-hint">First name only, spelled exactly as in other semesters (e.g. Kathy, Mariah) — the name is how a teacher is matched to their account in Teacher Name Mapping.</p>

exec
/bin/zsh -lc "sed -n '6320,6460p' js/app.js; rg -n --glob '"'!e2e/**'"' \"Object\\.(keys|entries|values)\\((currentLessonData|currentPrepData|currentCutBank|change|.*backup)|for \\(const .* of Object\\.(keys|entries)\" js/app.js js/firebase-data.js; rg -n --glob '"'!e2e/**'"' \"backup|change history|changeHistory|diagnostic|forecast|material|semester\" js/app.js js/firebase-data.js | sed -n '1,700p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
    await deleteLessonKey(semKey, key);
  } catch (e) {
    console.error('Could not delete lesson after archiving', key, e);
    deleteFailed = true;
  }

  // Local cache/grid only drops the lesson when the delete actually
  // succeeded — a failed delete leaves the grid showing the lesson as gone
  // while Firestore still has it live otherwise.
  if (!deleteFailed) {
    delete lessons[key];
    currentLessonData[semKey] = lessons;
  }
  if (!currentCutProjects) currentCutProjects = {};
  currentCutProjects[semKey] = [...(currentCutProjects[semKey] || []), archiveEntry];

  try {
    await appendChangeLogEntry(semKey, {
      action: 'cut',
      details: { projectTitle: freshLesson.projectTitle, teacher: freshLesson.teacher, className: freshLesson.className, fromWeek: freshLesson.weekNum }
    });
    renderChangeHistory();
  } catch (logErr) {
    console.error('⚠️ Cut saved, but Change History logging failed:', logErr);
  }

  closeAdminModal();
  renderAdminGrid();
  renderCutBank();
  renderChangeHistory();

  if (deleteFailed) {
    alert(`"${freshLesson.projectTitle}" was safely archived to the Cut Bank, but could NOT be removed from the grid. Please reload and check — it may now appear in both places.`);
  }
}

async function showPasteFromCutBank(teacher, className, weekNum) {
  const semKey = getAdminSemKey();
  const cutProjects = currentCutProjects?.[semKey] || [];

  // Gather cut projects from other semesters
  const otherSemesters = [];
  for (const [key, projects] of Object.entries(currentCutProjects || {})) {
    if (key === semKey || key === 'lastUpdated' || key === 'lastUpdatedBy') continue;
    if (projects && Array.isArray(projects) && projects.length > 0) {
      const semName = currentConfig?.semesters?.[key]?.name || key;
      otherSemesters.push({ key, name: semName, projects });
    }
  }

  const totalCuts = cutProjects.length + otherSemesters.reduce((sum, s) => sum + s.projects.length, 0);
  if (totalCuts === 0) {
    alert('No cut projects available in any semester. Cut a project first.');
    return;
  }

  const body = document.getElementById('ca-modal-body');
  let html = `<h4 class="ca-paste-title">Paste from Cut Bank</h4>
    <p class="ca-paste-hint">Select a project to place in ${escHtml(teacher)} / ${escHtml(className)} Week ${weekNum}:</p>`;

  // Current semester's cut projects
  if (cutProjects.length > 0) {
    html += '<div class="ca-cut-list">';
    cutProjects.forEach((proj, idx) => {
      html += `<div class="ca-cut-item" onclick="pasteFromCutBank(${idx}, '${escAttr(teacher)}', '${escAttr(className)}', ${weekNum}, '${escAttr(semKey)}')">
        <div class="ca-cut-item-title">${escHtml(proj.projectTitle)}</div>
        <div class="ca-cut-item-meta">Originally: ${escHtml(proj.originalTeacher)} / ${escHtml(proj.originalClassName || '')} Week ${proj.originalWeek} &middot; Cut ${new Date(proj.cutDate).toLocaleDateString()}</div>
      </div>`;
    });
    html += '</div>';
  } else {
    html += '<p class="ca-empty-hint" style="margin-bottom:12px">No cut projects in this semester.</p>';
  }

  // Other semesters
  if (otherSemesters.length > 0) {
    html += `<details style="margin-top:16px"><summary style="font-size:14px;font-weight:600;cursor:pointer;color:var(--tinker-purple)">From previous semesters (${otherSemesters.reduce((s, o) => s + o.projects.length, 0)} projects)</summary>`;
    for (const other of otherSemesters) {
      html += `<div style="margin-top:12px"><div style="font-size:12px;font-weight:700;color:var(--text-light);text-transform:uppercase;margin-bottom:6px">${escHtml(other.name)}</div><div class="ca-cut-list">`;
      other.projects.forEach((proj, idx) => {
        html += `<div class="ca-cut-item" onclick="pasteFromCutBank(${idx}, '${escAttr(teacher)}', '${escAttr(className)}', ${weekNum}, '${escAttr(other.key)}')">
          <div class="ca-cut-item-title">${escHtml(proj.projectTitle)}</div>
          <div class="ca-cut-item-meta">Originally: ${escHtml(proj.originalTeacher)} / ${escHtml(proj.originalClassName || '')} Week ${proj.originalWeek} &middot; Cut ${new Date(proj.cutDate).toLocaleDateString()}</div>
        </div>`;
      });
      html += '</div></div>';
    }
    html += '</details>';
  }

  body.innerHTML = html;
}

// Backtracking audit, Phase 8: targeted single-lesson save (not a bulk
// saveLessonData() semester overwrite), removal via FieldValue.arrayRemove()
// (not saveCutProjects()'s local-splice-then-full-array-overwrite — matches
// cutProject()'s arrayUnion() append-side fix, same document, same reasoning:
// two admins acting on the Cut Bank concurrently now both survive). The
// reconstruction below is an EXPLICIT FIELD WHITELIST, not spread-minus-
// exclude — a whitelist can't leak a future field cutProject()'s
// complete-spread archive starts including that an exclude-list doesn't yet
// know to exclude. classSize preserves the destination's own existing
// scaffold value (round-6 fix) rather than being hardcoded to 0 — nothing
// downstream recomputes it on paste. teacherNotes/adminResponse/status are
// excluded alongside qaThread (round-6 fix): getQaThread() reconstructs a
// Q&A thread from teacherNotes/adminResponse whenever qaThread is absent, so
// restoring those two fields alone would still leak the original
// conversation even with qaThread itself correctly omitted.
async function pasteFromCutBank(cutIndex, teacher, className, weekNum, sourceSemKey) {
  const destSemKey = getAdminSemKey();
  const srcSemKey = sourceSemKey || destSemKey;
  const cutProjects = currentCutProjects?.[srcSemKey] || [];
  const proj = cutProjects[cutIndex];
  if (!proj) return;

  const isCrossSemester = srcSemKey !== destSemKey;
  const srcSemName = currentConfig?.semesters?.[srcSemKey]?.name || srcSemKey;
  const confirmMsg = isCrossSemester
    ? `Paste "${proj.projectTitle}" from ${srcSemName} into ${teacher} / ${className} Week ${weekNum}?`
    : `Paste "${proj.projectTitle}" into ${teacher} / ${className} Week ${weekNum}?`;
  if (!confirm(confirmMsg)) return;

  const key = makeLessonKey(teacher, className, weekNum);
  const lessons = { ...(currentLessonData?.[destSemKey] || {}) };
  const existingDest = lessons[key] || {};
  const existingDestClassSize = existingDest.classSize || 0;
  const existingDestPhotoPath = existingDest.photoPath || null;

  lessons[key] = {
    teacher, className, weekNum, weekDate: '', classSize: existingDestClassSize,
    projectTitle: proj.projectTitle,
    shortDetails: proj.shortDetails || '',
    inspoLink: proj.inspoLink || '',
    introPitch: proj.introPitch || '',
    processStep1: proj.processStep1 || '', processStep2: proj.processStep2 || '',
    processStep3: proj.processStep3 || '', processStep4: proj.processStep4 || '',
    closure: proj.closure || '',
    materials: proj.materials || '',
    materialsList: proj.materialsList || [],
    dayOfMaterials: proj.dayOfMaterials || '',
    publishToPrep: proj.publishToPrep || '',
js/firebase-data.js:203:  for (const [path, value] of Object.entries(flat)) {
js/firebase-data.js:480:  for (const [key, sem] of Object.entries(semesters)) {
js/firebase-data.js:771:        console.log(`📚 ${plan.semKey}: ${Object.keys(currentLessonData[plan.semKey]).length} lessons`);
js/firebase-data.js:777:        console.log(`📚 ${yearKey}: ${Object.keys(currentLessonData[yearKey]).length} day-off camp plans`);
js/firebase-data.js:851:  for (const [lessonKey, lessonData] of Object.entries(lessons)) {
js/firebase-data.js:1055:  for (const key of Object.keys(fresh)) {
js/firebase-data.js:1067:      for (const f of Object.keys(mine)) { if (!(f in fresh[key]) && !(f in saved)) delete mine[f]; }
js/firebase-data.js:1096:  for (const semKey of Object.keys(currentLessonData || {})) {
js/firebase-data.js:1187:      for (const [semKey, map] of Object.entries(previousSummer)) currentLessonData[semKey] = map;
js/firebase-data.js:1188:      console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
js/firebase-data.js:1462:  for (const [field, value] of Object.entries(cleanData)) {
js/firebase-data.js:1765:          for (const [projectTitle, days] of Object.entries(projectDays)) {
js/firebase-data.js:2140:  for (const [key, seq] of Object.entries(dayOffVerifiedAt[yearKey] || {})) {
js/firebase-data.js:2195:  for (const [date, day] of Object.entries(input.projects || {})) {
js/firebase-data.js:2230:  for (const [date, day] of Object.entries(camp.projects)) {
js/firebase-data.js:2268:  for (const [k, v] of Object.entries(clean)) { if (v === '') delete clean[k]; }
js/firebase-data.js:2566:  for (const k of Object.keys(planMap)) { if (planMap[k]?.campId === campId) delete planMap[k]; }
js/app.js:965:    for (const camp of Object.keys(teacherMap[teacher] || {})) {
js/app.js:1281:  for (const [key, lesson] of Object.entries(lessons)) {
js/app.js:2050:  for (const [campName, projects] of Object.entries(campGroups)) {
js/app.js:2308:        for (const [key, l] of Object.entries(lessons)) {
js/app.js:3777:  for (const [lessonKey, lesson] of Object.entries(lessons)) {
js/app.js:5080:  for (const [key, lesson] of Object.entries(lessons)) {
js/app.js:6362:  for (const [key, projects] of Object.entries(currentCutProjects || {})) {
js/app.js:7537:    ...Object.keys(backupCounts || {}),
js/app.js:7649:  for (const [key, lesson] of Object.entries(lessons)) {
js/app.js:8366:  for (const [key, lesson] of Object.entries(lessons)) {
js/app.js:9585:    for (const [normTitle, group] of Object.entries(groups)) {
js/app.js:9643:  for (const [key, val] of Object.entries(roster)) {
js/app.js:9656:  for (const [key, val] of Object.entries(roster)) {
js/app.js:10110:  for (const name of Object.keys(roster)) {
js/app.js:10245:  for (const [content, locations] of Object.entries(contentMap)) {
js/app.js:10323:  for (const [slot, items] of Object.entries(slotMap)) {
js/app.js:10814:      for (const [f, v] of Object.entries(previous)) { if (v === undefined) delete sem[f]; else sem[f] = v; }
js/app.js:10911:    for (const [path, expected] of Object.entries(stamps)) {
js/app.js:11132:  for (const [uid, name] of Object.entries(mappings)) {
js/app.js:11206:  for (const [uid, name] of Object.entries(mappings)) {
js/app.js:11307:  for (const [path, value] of Object.entries(settingsPaths)) {
js/app.js:11332:    for (const [path, value] of Object.entries(settingsPaths)) {
js/app.js:11390:  for (const [className, data] of Object.entries(roster)) {
js/app.js:11475:  for (const [key, l] of Object.entries(lessons)) {
js/firebase-data.js:5://   curriculum/appData     — semester config (URLs, GIDs, settings)
js/firebase-data.js:6://   curriculum/prepData    — prep team data by semester/week
js/firebase-data.js:7://   curriculum/lessonData  — all lesson content by semester (imported from classbooks)
js/firebase-data.js:29:// Every semester stores its kind explicitly. Nothing in the app may infer a
js/firebase-data.js:31:// semester named "Summer Enrichment" could be routed into the summer
js/firebase-data.js:39:// pressing "Stamp semester types", and a stale pre-Phase-1 tab whose
js/firebase-data.js:43:// auto-add already stored semesterType on the server's summer-2026.
js/firebase-data.js:45:function semesterTypeOf(semKey) {
js/firebase-data.js:46:  const stored = currentConfig?.semesters?.[semKey]?.semesterType;
js/firebase-data.js:52:function isCampSeason(semKey) { return semesterTypeOf(semKey) === SEMESTER_TYPES.camp; }
js/firebase-data.js:53:function isWeeklySemester(semKey) { return semesterTypeOf(semKey) === SEMESTER_TYPES.weekly; }
js/firebase-data.js:55:// Which lesson store a semester's lessons live in: 'camp' (one document per
js/firebase-data.js:65:  const type = semesterTypeOf(semKey);
js/firebase-data.js:70:      throw new Error(`Semester "${semKey}" is a "${type}" semester — this app has no lesson store for that type yet, so it refuses to read or write its lessons.`);
js/firebase-data.js:87:// (semKey, legacy key) → the document ID in that semester's season. Every
js/firebase-data.js:103:// semester's stored `season` when it has one (Phase 1 stamps it), else the
js/firebase-data.js:110:// weekly semester whose key happens to start with `summer-` fails its save
js/firebase-data.js:112:// routes by semesterType).
js/firebase-data.js:114:  const stored = currentConfig?.semesters?.[semKey]?.season;
js/firebase-data.js:120:    throw new Error(`Cannot determine the camp season for semester "${semKey}" — refusing to write a summer document without a valid season stamp.`);
js/firebase-data.js:153:// appData decides what every semester is. Until Phase 1 a read error here fell
js/firebase-data.js:242:// before creating a semester, and by the type migration's dry run/read-back.
js/firebase-data.js:249:// Which appData paths a Settings save may write, by the semester's TYPE. A
js/firebase-data.js:252:// Phase 1 a Settings save spread the whole form over the semester and could
js/firebase-data.js:255:function settingsFieldPathsFor(semKey, values, semesters) {
js/firebase-data.js:256:  const type = (semesters || currentConfig?.semesters)?.[semKey]?.semesterType
js/firebase-data.js:258:  const p = (f) => `semesters.${semKey}.${f}`;
js/firebase-data.js:281:  throw new Error(`Settings does not know which fields a "${type}" semester owns.`);
js/firebase-data.js:288:// are safe to read season-filtered. Which season a USER sees is the semester
js/firebase-data.js:384:// semester from it. Checked on the RAW document, never on the normalised one.
js/firebase-data.js:398:// The semester a camp season becomes in this app, built ENTIRELY from the
js/firebase-data.js:401:function semesterFromRegistrySeason(reg) {
js/firebase-data.js:404:    semesterType: SEMESTER_TYPES.camp,
js/firebase-data.js:475:  const semesters = serverConfig?.semesters;
js/firebase-data.js:476:  if (!semesters || typeof semesters !== 'object') {
js/firebase-data.js:477:    throw new Error('Cannot stamp semester types: the appData document has no semesters map.');
js/firebase-data.js:480:  for (const [key, sem] of Object.entries(semesters)) {
js/firebase-data.js:482:    if (sem?.semesterType) {
js/firebase-data.js:483:      if (sem.semesterType !== expected) {
js/firebase-data.js:484:        throw new Error(`Semester "${key}" already carries semesterType "${sem.semesterType}" where this migration expects "${expected}" — refusing to overwrite a stored type. Check it by hand before stamping.`);
js/firebase-data.js:487:      stamps[`semesters.${key}.semesterType`] = expected;
js/firebase-data.js:491:    if (!sem?.season) stamps[`semesters.${key}.season`] = '2026';
js/firebase-data.js:495:    if (!Array.isArray(sem?.breakWeeks) || sem.breakWeeks.length === 0) stamps[`semesters.${key}.breakWeeks`] = [6];
js/firebase-data.js:496:    if (!Array.isArray(sem?.timeSlots) || sem.timeSlots.length === 0) stamps[`semesters.${key}.timeSlots`] = SUMMER_2026_TIME_SLOTS;
js/firebase-data.js:497:    if (!Array.isArray(sem?.studios) || sem.studios.length === 0) stamps[`semesters.${key}.studios`] = SUMMER_2026_STUDIOS;
js/firebase-data.js:505:    semesters: {
js/firebase-data.js:551:async function savePrepWeekData(semesterKey, weekKey, weekData) {
js/firebase-data.js:558:  updateObj[`${semesterKey}.${weekKey}`] = weekData;
js/firebase-data.js:566:      nested[semesterKey] = {};
js/firebase-data.js:567:      nested[semesterKey][weekKey] = weekData;
js/firebase-data.js:575:async function saveForecastDismissals(semesterKey, dismissals) {
js/firebase-data.js:578:  updateObj[`${semesterKey}.forecastDismissed`] = dismissals;
js/firebase-data.js:585:      nested[semesterKey] = { forecastDismissed: dismissals };
js/firebase-data.js:593:function getForecastDismissals(semesterKey) {
js/firebase-data.js:594:  return currentPrepData?.[semesterKey]?.forecastDismissed || {};
js/firebase-data.js:625:        'Use Weekly Curriculum meeting to clarify projects and materials'
js/firebase-data.js:633:      description: "Return staged materials to storage and gather what's needed for this week.",
js/firebase-data.js:635:        'Return staged materials to storage (aim for ~2 trips/week)',
js/firebase-data.js:638:        'Keep up on reset materials (threaded needles, model magic, canvas unwrap, etc.)',
js/firebase-data.js:639:        'Use Weekly Curriculum meeting to clarify projects and materials',
js/firebase-data.js:653:        'Keep in communication with SDOC prep lead — trials, process sheets, materials (several weeks ahead)',
js/firebase-data.js:655:        'Cross reference materials needed with list of reset tasks — include day-of materials'
js/firebase-data.js:665:        'Prepped materials labeled for teacher: class code, week #, size, quantity',
js/firebase-data.js:668:        'Keep up on materials needing reset for current week',
js/firebase-data.js:670:        'Cross reference materials needed with list of reset tasks — include day-of materials'
js/firebase-data.js:680:        'Multi-class project materials staged on shelf in workroom, labeled with example and process sheet',
js/firebase-data.js:693:      description: 'Breakdown returned & unused materials. Stage items on Return shelf.',
js/firebase-data.js:696:        'Look ahead for materials finished with one project but needed for an upcoming project — redistribute',
js/firebase-data.js:698:        'Keep up on materials needing reset for current week',
js/firebase-data.js:732:// Every camp-season semester in the config, with the season each one reads.
js/firebase-data.js:737:  return Object.keys(currentConfig?.semesters || {}).filter(isDayOffYear);
js/firebase-data.js:741:  const semesters = currentConfig?.semesters || {};
js/firebase-data.js:742:  return Object.keys(semesters)
js/firebase-data.js:782:      // loaded model is not a safe base for any writer, in any semester.
js/firebase-data.js:794:// Whole-semester bulk writer (restoreFromBackup, createNewSemester,
js/firebase-data.js:798:// semester whose current state this client never confirmed), and merge:true
js/firebase-data.js:799:// would still write it over the real semester map. Throws rather than no-ops —
js/firebase-data.js:802:async function saveLessonData(semesterKey, lessons) {
js/firebase-data.js:808:  // Route by the semester's TYPE, never by its key (Phase 1, 1.1): camp
js/firebase-data.js:811:  if (lessonStoreFor(semesterKey) === 'camp') {
js/firebase-data.js:812:    return await saveSummerCampLessonData(semesterKey, lessons);
js/firebase-data.js:815:  // Regular semester: save to curriculum/lessonData
js/firebase-data.js:818:    [semesterKey]: lessons,
js/firebase-data.js:825:// More reliable than resaving the full semester when cutting a project,
js/firebase-data.js:827:async function deleteLessonKey(semesterKey, lessonKey) {
js/firebase-data.js:831:    [`${semesterKey}.${lessonKey}`]: firebase.firestore.FieldValue.delete(),
js/firebase-data.js:839:  // Resolved once, before any batch work — a semester with no valid season
js/firebase-data.js:920:// semKey is the MODAL's semester (captured when it opened), not the header
js/firebase-data.js:929:  // Resolved before the read so an invalid semester is refused before anything is touched.
js/firebase-data.js:961:async function deleteLessonData(semesterKey) {
js/firebase-data.js:964:    [semesterKey]: firebase.firestore.FieldValue.delete()
js/firebase-data.js:968:// Forced-server read of one semester's whole lesson map in curriculum/lessonData
js/firebase-data.js:973:async function readServerSemesterLessonMap(semesterKey) {
js/firebase-data.js:976:  return snap.exists ? (snap.data()?.[semesterKey] ?? null) : null;
js/firebase-data.js:979:async function backupLessonData(semesterKey) {
js/firebase-data.js:981:  const existing = currentLessonData?.[semesterKey];
js/firebase-data.js:985:  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
js/firebase-data.js:986:    [semesterKey]: existing,
js/firebase-data.js:987:    backupDate: new Date().toISOString(),
js/firebase-data.js:988:    backupBy: user?.name || 'Unknown'
js/firebase-data.js:993:async function restoreFromBackup(semesterKey) {
js/firebase-data.js:995:  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
js/firebase-data.js:996:  if (!backupDoc.exists) return null;
js/firebase-data.js:997:  const backupData = backupDoc.data();
js/firebase-data.js:998:  const lessons = backupData?.[semesterKey];
js/firebase-data.js:1000:  await saveLessonData(semesterKey, lessons);
js/firebase-data.js:1013:// (everything else on the slot — teacher, camp, materials, sharedWith, class
js/firebase-data.js:1045:  // may be resurrected by an editor fallback later. Only THIS semester's
js/firebase-data.js:1093:// The camp seasons currently in memory, by semester key.
js/firebase-data.js:1182:      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
js/firebase-data.js:1188:      console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
js/firebase-data.js:1193:      // one still renders: the non-summer semesters in this snapshot are new.
js/firebase-data.js:1212:async function saveCutProjects(semesterKey, projects) {
js/firebase-data.js:1216:    [semesterKey]: projects,
js/firebase-data.js:1267:async function appendChangeLogEntry(semesterKey, entry) {
js/firebase-data.js:1274:  if (!currentChangeLog[semesterKey]) currentChangeLog[semesterKey] = [];
js/firebase-data.js:1275:  currentChangeLog[semesterKey] = [...currentChangeLog[semesterKey], entry];
js/firebase-data.js:1278:      [semesterKey]: firebase.firestore.FieldValue.arrayUnion(entry)
js/firebase-data.js:1281:    currentChangeLog[semesterKey] = currentChangeLog[semesterKey].filter(e => e !== entry);
js/firebase-data.js:1286:// ─── Diagnostic Dismissals (curriculum/diagnosticDismissals) ──
js/firebase-data.js:1293:    const doc = await curriculumDb.collection('curriculum').doc('diagnosticDismissals').get();
js/firebase-data.js:1296:    console.error('Error loading diagnostic dismissals:', err);
js/firebase-data.js:1308:    await curriculumDb.collection('curriculum').doc('diagnosticDismissals').set(dismissals);
js/firebase-data.js:1312:    console.error('FAILED to save diagnostic dismissals:', err);
js/firebase-data.js:1313:    alert('Error saving diagnostic data: ' + err.message);
js/firebase-data.js:1364:async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
js/firebase-data.js:1378:  if (isDayOffYear(semesterKey)) return saveDayOffPlan(semesterKey, lessonKey, lessonData, fieldsToClear, opts.dayOffAuth);
js/firebase-data.js:1380:  console.log('💾 Attempting to save lesson:', { semesterKey, lessonKey, user: user?.email });
js/firebase-data.js:1387:  if (lessonStoreFor(semesterKey) === 'camp') {
js/firebase-data.js:1411:    cleanData.season = seasonForSemester(semesterKey);
js/firebase-data.js:1413:    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semesterKey, lessonKey));
js/firebase-data.js:1429:  // Regular semester: curriculum/lessonData is one shared doc across every
js/firebase-data.js:1430:  // semester. update() with a whole object assigned to the bare
js/firebase-data.js:1431:  // semesterKey.lessonKey path replaces the ENTIRE lesson there — so write
js/firebase-data.js:1434:  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear);
js/firebase-data.js:1455:function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = []) {
js/firebase-data.js:1463:    updates[`${semesterKey}.${lessonKey}.${field}`] = value;
js/firebase-data.js:1475:async function saveMultipleLessonFields(semesterKey, writes = [], deletes = []) {
js/firebase-data.js:1479:  if (lessonStoreFor(semesterKey) === 'camp') {
js/firebase-data.js:1483:    // summer semesters), but this guard exists so a future caller can't
js/firebase-data.js:1493:    Object.assign(combined, buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear || []));
js/firebase-data.js:1496:    combined[`${semesterKey}.${lessonKey}`] = firebase.firestore.FieldValue.delete();
js/firebase-data.js:1529:function getPhotoPath(semesterKey, lessonKey /* filename: ignored — resizeImage() always re-encodes to JPEG */) {
js/firebase-data.js:1530:  // Store at curriculum/{semester}/{lessonKey}/demo-{unique}.jpg
js/firebase-data.js:1531:  return `curriculum/${semesterKey}/${lessonKey}/demo-${uniquePhotoSuffix()}.jpg`;
js/firebase-data.js:1534:async function uploadLessonPhoto(semesterKey, lessonKey, file) {
js/firebase-data.js:1539:  const path = getPhotoPath(semesterKey, lessonKey, 'demo.jpg');
js/firebase-data.js:1672:    const sessions = []; // becomes this semester's entry in currentSummerSessionsBySemester, only if this load is still current
js/firebase-data.js:1687:    // 3. Fetch all materials for lookup
js/firebase-data.js:1688:    const materialsSnap = await scoped('summerCamps_materialsHub').get();
js/firebase-data.js:1689:    const materialsByProject = {};
js/firebase-data.js:1690:    materialsSnap.forEach(doc => {
js/firebase-data.js:1693:      if (!materialsByProject[key]) materialsByProject[key] = [];
js/firebase-data.js:1694:      materialsByProject[key].push({
js/firebase-data.js:1766:            // Get materials and project details for this project
js/firebase-data.js:1768:            const materialsArray = materialsByProject[matKey] || [];
js/firebase-data.js:1798:              materials: materialsArray.map(m => m.name).filter(n => n).join('\n'),
js/firebase-data.js:1799:              materialsList: materialsArray,
js/firebase-data.js:1874:// A school year is a semester of type 'day-off-camps' in appData. Its events,
js/firebase-data.js:1929:// ─── Phase 2A: materials (planner-built) + prep check-off ────────────────────
js/firebase-data.js:1931:// materialItems { [id]: { name, qty, scope, size, notes, order } } with prep
js/firebase-data.js:1932:// ticks in materialChecks { [id]: { by, at } } — written by field path so a
js/firebase-data.js:1933:// planner's edit and a prep tick never collide. NOT `materials`: that name is a
js/firebase-data.js:1955:function dayOffValidItemIds(plan) { return Object.keys(plan?.materialItems || {}).filter(id => DAY_OFF_ITEM_ID.test(id)); }
js/firebase-data.js:1957:  return Object.entries(plan?.materialItems || {}).filter(([id]) => DAY_OFF_ITEM_ID.test(id)).map(([id, it]) => ({ id, ...it }))
js/firebase-data.js:1968:  return Object.keys(plan?.materialChecks || {}).filter(id => items.has(id));
js/firebase-data.js:1981:function isDayOffYear(semKey) { return semesterTypeOf(semKey) === SEMESTER_TYPES.dayOff; }
js/firebase-data.js:2027:// field counts — text, photo, Q&A, Plan Complete, materials — so a photo-only
js/firebase-data.js:2032:  if (typeof plan.materials === 'string' && plan.materials.trim()) return true;   // free-text materials (review HIGH)
js/firebase-data.js:2036:  if (Array.isArray(plan.materialsList) && plan.materialsList.length > 0) return true;
js/firebase-data.js:2099:        materialsList: plans[lessonKey]?.materialsList || [],
js/firebase-data.js:2303:  const year = currentConfig?.semesters?.[yearKey];
js/firebase-data.js:2401:  const serverYear = (await readAppDataFromServer())?.semesters?.[yearKey];
js/firebase-data.js:2559:      throw new DayOffValidationError([`It has projects with a plan or materials list: ${[...new Set(withData)].join(', ')}. Nothing was removed.`]);
js/firebase-data.js:2574:// same doc 2A's materials live on). The deployed rules let any classbook user
js/firebase-data.js:2576:// materialItems / materialChecks / identity (plan, round 1).
js/firebase-data.js:2758:// any classbook user write this collection (the 2A materialItems gap), so the
js/firebase-data.js:2847:// ─── Phase 2A writers: materials, ticks, sign-off ────────────────────────────
js/firebase-data.js:2861:  if (!trimOrEmpty(item.name)) problems.push('Give the material a name.');
js/firebase-data.js:2894:// Planner: add (itemId null) or edit one item. Only materialItems.<id> is
js/firebase-data.js:2911:    const existing = planSnap.exists ? (planSnap.data().materialItems || {}) : {};
js/firebase-data.js:2912:    if (itemId && !existing[itemId]) throw new DayOffValidationError(['That material was removed in another tab — reload the list.']);
js/firebase-data.js:2917:      tx.update(planRef, { [`materialItems.${id}`]: item });
js/firebase-data.js:2919:      tx.set(planRef, { yearKey, eventId: camp.eventId, campId, projectTitle: title, materialItems: { [id]: item } });
js/firebase-data.js:2945:    if (!planSnap.exists || !(planSnap.data().materialItems || {})[itemId]) return;   // already gone
js/firebase-data.js:2947:    tx.update(planRef, { [`materialItems.${itemId}`]: del, [`materialChecks.${itemId}`]: del });
js/firebase-data.js:2973:    next.forEach(({ id, order }) => { if ((snap.data().materialItems[id].order ?? 0) !== order) updates[`materialItems.${id}.order`] = order; });
js/firebase-data.js:2979:// Ticking users: tick/untick one item — only materialChecks.<id>, via
js/firebase-data.js:2992:    if (!snap.exists || !(snap.data().materialItems || {})[itemId]) {
js/firebase-data.js:2993:      throw new DayOffValidationError(['That material was removed or moved — reload the list.']);
js/firebase-data.js:2995:    tx.update(planRef, { [`materialChecks.${itemId}`]: checked ? mark : firebase.firestore.FieldValue.delete() });
js/firebase-data.js:3003:    plan.materialChecks = { ...(plan.materialChecks || {}) };
js/firebase-data.js:3004:    if (checked) plan.materialChecks[itemId] = mark; else delete plan.materialChecks[itemId];
js/firebase-data.js:3048:    if (complete && items === 0) throw new DayOffValidationError(['This camp has no materials listed yet — nothing to mark complete.']);
js/firebase-data.js:3051:      throw new DayOffValidationError([`The materials list changed since you looked (now ${ticked} of ${items} ticked) — check it and press Materials complete again.`]);
js/firebase-data.js:3114:  return currentConfig.semesters?.[key] || null;
js/firebase-data.js:3118:  // Use global semester if set, otherwise fall back to active semester
js/firebase-data.js:3119:  if (globalSemesterKey && currentConfig?.semesters?.[globalSemesterKey]) {
js/app.js:13:let globalSemesterKey = localStorage.getItem('globalSemesterKey') || null;  // Universal semester selection
js/app.js:48:  const select = document.getElementById('global-semester-select');
js/app.js:51:  if (!select || !currentConfig?.semesters) return;
js/app.js:55:  const semesters = currentConfig.semesters;
js/app.js:56:  const keys = Object.keys(semesters);
js/app.js:58:  // Filter semesters: canSeeSemester() — manager+ all; others published, plus
js/app.js:62:  // Set initial global semester if not set — or if the remembered one is not
js/app.js:64:  // semester must not leave a teacher inside it — review).
js/app.js:65:  if (!globalSemesterKey || !semesters[globalSemesterKey] || !visibleKeys.includes(globalSemesterKey)) {
js/app.js:67:    // semester would otherwise put the teacher straight back inside it).
js/app.js:75:    const sem = semesters[key];
js/app.js:97:  if (!currentConfig?.semesters?.[key]) return;
js/app.js:102:  // Hide/show Prep Dashboard tab based on semester type
js/app.js:103:  const semester = currentConfig.semesters[key];
js/app.js:118:  // Hide/show Curriculum Admin tab for non-manager users on summer semesters
js/app.js:121:  // Refresh all tabs to use new semester
js/app.js:128:    updateClassFilter(); // Update class dropdown for new semester
js/app.js:175:  // Hide Prep Dashboard tab for summer camp semesters (prep is done in Summer Camp App)
js/app.js:176:  const currentSemester = currentConfig?.semesters?.[globalSemesterKey];
js/app.js:196:let lastDiagFingerprint = null;  // Track which diagnostic item we navigated from
js/app.js:224:        // Scroll back to the diagnostic item we came from
js/app.js:235:  // Find the diagnostic item by its fingerprint (stored on dismiss/undismiss/note buttons)
js/app.js:273:// Which semesters this user may select, in the header AND Teacher View:
js/app.js:279:  const sem = currentConfig?.semesters?.[key];
js/app.js:297:// Hide/show Curriculum Admin tab based on semester type for non-manager users.
js/app.js:298:// Called on initial load and on semester change.
js/app.js:305:  const semester = currentConfig?.semesters?.[semKey];
js/app.js:309:  if (semester?.semesterType === 'summer-camp') {
js/app.js:327:  // Settings is manager+ only — classbook admins can't change semester config
js/app.js:330:    updateCurriculumAdminTab(); // Hide Curriculum Admin on summer semesters
js/app.js:580:  const pool = new Set(currentConfig?.semesters?.[yearKey]?.teacherNames || []);
js/app.js:636:  // Now uses global semester instead of per-tab selection
js/app.js:651:  // Already built: the semester may have changed on another tab — refresh for
js/app.js:704:  // Build semester selector (only show if multiple published semesters)
js/app.js:758:// initialized (a weekly/camp semester or an SDOC year).
js/app.js:794:  const group = document.getElementById('tv-semester-group');
js/app.js:795:  const select = document.getElementById('tv-semester-select');
js/app.js:796:  if (!group || !select || !currentConfig?.semesters) return;
js/app.js:798:  // Get published semesters (or all for admin/manager)
js/app.js:800:  const semesters = currentConfig.semesters;
js/app.js:803:  const keys = Object.keys(semesters).filter(canSeeSemester);
js/app.js:805:  // Only show if more than one semester available
js/app.js:817:    const sem = semesters[key];
js/app.js:827:      // It switches the app's semester (it used to set a variable nothing read,
js/app.js:828:      // so it only ever re-listed the header's semester — impl review, 2B).
js/app.js:829:      const header = document.getElementById('global-semester-select');
js/app.js:840:        // Re-auto-select teacher for staff users after semester switch
js/app.js:920:  // Summer camp lessons have materials pre-loaded from the Materials Hub (not teacher input),
js/app.js:924:    : (lesson.materialsList && lesson.materialsList.length > 0) || !!(lesson.materials || '').trim();
js/app.js:1061:  const semester = getActiveSemester();
js/app.js:1063:  // Summer camp semesters: group by camp name instead of week number
js/app.js:1064:  if (semester?.semesterType === 'summer-camp') {
js/app.js:1069:  const numWeeks = semester?.numWeeks || 16;
js/app.js:1244:  const semester = getActiveSemester();
js/app.js:1245:  if (!semester?.startDate) return 1;
js/app.js:1246:  const start = new Date(semester.startDate + 'T00:00:00');
js/app.js:1252:  const breaks = (semester.breakWeeks || []).sort((a, b) => a - b);
js/app.js:1257:  return Math.max(1, Math.min(teachingWeek, semester.numWeeks || 16));
js/app.js:1459:  if (lesson.materialsList && lesson.materialsList.length > 0) {
js/app.js:1460:    html += `<div class="tv-detail-section"><h5>Materials to Prep</h5><ul class="tv-materials-list">`;
js/app.js:1461:    for (const m of lesson.materialsList) {
js/app.js:1472:  } else if (lesson.materials) {
js/app.js:1473:    html += `<div class="tv-detail-section"><h5>Materials to Prep</h5><p>${escHtml(lesson.materials)}</p></div>`;
js/app.js:1508:  // Build materials HTML (using table format like existing print)
js/app.js:1509:  let materialsHtml = '';
js/app.js:1510:  if (lesson.materialsList && lesson.materialsList.length > 0) {
js/app.js:1511:    materialsHtml = `<div class="sheet-section"><h3>Materials to Prep</h3><table style="width:100%;border-collapse:collapse;font-size:13px;"><thead><tr style="border-bottom:1px solid #ddd;"><th style="text-align:left;padding:4px;">Material</th><th style="text-align:left;padding:4px;">Qty</th><th style="text-align:left;padding:4px;">Scope</th><th style="text-align:left;padding:4px;">Size/Cut</th><th style="text-align:left;padding:4px;">Notes</th></tr></thead><tbody>`;
js/app.js:1512:    for (const m of lesson.materialsList) {
js/app.js:1513:      materialsHtml += `<tr style="border-bottom:1px solid #eee;"><td style="padding:4px;">${esc(m.name)}</td><td style="padding:4px;">${esc(m.qty || '')}</td><td style="padding:4px;">${esc(m.scope || '')}</td><td style="padding:4px;">${esc(m.size || '')}</td><td style="padding:4px;">${esc(m.notes || '')}</td></tr>`;
js/app.js:1515:    materialsHtml += `</tbody></table></div>`;
js/app.js:1516:  } else if (lesson.materials) {
js/app.js:1517:    materialsHtml = `<div class="sheet-section"><h3>Materials to Prep</h3><p>${esc(lesson.materials)}</p></div>`;
js/app.js:1583:  ${materialsHtml}
js/app.js:1610:  const semester = currentConfig?.semesters?.[semKey];
js/app.js:1612:  // this semester the way initTeacherView() does.
js/app.js:1631:  const isSummer = semester?.semesterType === 'summer-camp';
js/app.js:1831:  const semester = currentConfig?.semesters?.[semKey];
js/app.js:1832:  const startDate = semester?.startDate; // e.g. "2026-05-26"
js/app.js:1896:  const breakWeeksSet = new Set(semester?.breakWeeks || []);
js/app.js:1936:  // The semester these lessons belong to, captured now: the reads below are
js/app.js:2192:          ${project.materialsList && project.materialsList.length > 0 ? `
js/app.js:2193:          <div class="project-section materials-section">
js/app.js:2195:            <table class="materials-table">
js/app.js:2207:                ${project.materialsList.map(mat => `
js/app.js:2427:        // semKey is the semester this view was rendered for — not
js/app.js:2451:  const semester = currentConfig?.semesters?.[semKey] || getActiveSemester();
js/app.js:2452:  const numWeeks = semester?.numWeeks || 16;
js/app.js:2453:  const breakWeeks = semester?.breakWeeks || [];
js/app.js:2485:      const weekDate = getWeekStartLabel(semester, col.weekNum);
js/app.js:2511:      const closureDate = getClosureForWeek(semester, w, className);
js/app.js:2554:  const semester = getActiveSemester();
js/app.js:2555:  const breakPos = getBreakPositions(semester?.breakWeeks);
js/app.js:2582:      const closureDate = getClosureForWeek(semester, lesson.weekNum, className);
js/app.js:2613:  const semester = getActiveSemester();
js/app.js:2614:  const breakPos = getBreakPositions(semester?.breakWeeks);
js/app.js:2640:      const closureDate = getClosureForWeek(semester, weekNum, lesson.className);
js/app.js:2677:  const hasMaterials = (lesson.materialsList && lesson.materialsList.length > 0) || lesson.materials || lesson.dayOfMaterials;
js/app.js:2762:    if (lesson.materialsList && lesson.materialsList.length > 0) {
js/app.js:2763:      html += `<div class="tv-detail-section"><h5>Materials to Prep</h5><ul class="tv-materials-list">`;
js/app.js:2764:      for (const m of lesson.materialsList) {
js/app.js:2775:    } else if (lesson.materials) {
js/app.js:2776:      html += `<div class="tv-detail-section"><h5>Materials to Prep</h5><p>${escHtml(lesson.materials)}</p></div>`;
js/app.js:2980:  let materialsHtml = '';
js/app.js:2981:  if (lesson.materialsList && lesson.materialsList.length > 0) {
js/app.js:2982:    materialsHtml = '<ul class="tv-materials-list">';
js/app.js:2983:    for (const m of lesson.materialsList) {
js/app.js:2991:      materialsHtml += `<li>${label}</li>`;
js/app.js:2993:    materialsHtml += '</ul>';
js/app.js:2994:  } else if (lesson.materials) {
js/app.js:2995:    materialsHtml = `<p>${escHtml(lesson.materials)}</p>`;
js/app.js:3024:        ${materialsHtml ? `<div class="tv-detail-section"><h5>Materials to Prep</h5>${materialsHtml}</div>` : ''}
js/app.js:3137:        <div class="te-materials-table-wrap" id="te-materials-table-wrap">
js/app.js:3138:          <table class="te-materials-table">
js/app.js:3149:            <tbody id="te-materials-tbody"></tbody>
js/app.js:3151:          <button type="button" class="te-add-material-btn" id="te-add-material-btn">+ Add Material</button>
js/app.js:3204:  // Populate materials table rows
js/app.js:3207:  // Snapshot for dirty checking — AFTER table population so parsed materials match
js/app.js:3219:    materials: formSnapshot.materials,
js/app.js:3221:    materialsList: JSON.stringify(formSnapshot.materialsList || []),
js/app.js:3329:  const tbody = document.getElementById('te-materials-tbody');
js/app.js:3332:  // Build initial rows from materialsList or parse freetext
js/app.js:3333:  let items = lesson.materialsList || [];
js/app.js:3334:  if (items.length === 0 && lesson.materials) {
js/app.js:3335:    // Parse freetext materials into name-only rows
js/app.js:3336:    items = lesson.materials.split(/[,;\n]+/).map(m => m.trim()).filter(m => m).map(name => ({
js/app.js:3347:  document.getElementById('te-add-material-btn')?.addEventListener('click', () => {
js/app.js:3379:  const rows = document.querySelectorAll('#te-materials-tbody .te-mat-row');
js/app.js:3396:  const materialsList = getMaterialsListFromTable();
js/app.js:3398:  const materials = materialsList.map(m => m.name).join(', ');
js/app.js:3409:    materials,
js/app.js:3410:    materialsList,
js/app.js:3419:  return key === 'materialsList' ? JSON.stringify(rawFormData[key] || [])
js/app.js:3587:      materials: snapshot.materials,
js/app.js:3589:      materialsList: JSON.stringify(snapshot.materialsList || []),
js/app.js:3612:// record. `modalSemKey` is the semester the modal was opened under: the
js/app.js:3614:// update under the wrong semester would create a Q&A-only ghost lesson there.
js/app.js:3718:  // still on this modal's semester; otherwise it would open a different
js/app.js:3719:  // semester's lesson under the same key.
js/app.js:3725:// The read-mark carries the semester (Phase 1, 1.4): two camp seasons share
js/app.js:3729:// Marks written before Phase 1 had no semester in the key. Reading through
js/app.js:3731:// deploy for replies they had already read, in weekly semesters too.
js/app.js:3736:  // belong: any weekly semester, or Summer 2026 — the only camp season that
js/app.js:3738:  // reopen exactly the cross-season collision the semester prefix closes,
js/app.js:3869:// semKey is the modal's semester, captured by openLessonModal() when it
js/app.js:3920:  const semester = getActiveSemester();
js/app.js:3929:  const weekInput = prompt(`Print process sheets for which week? (1-${semester?.numWeeks || 16})`, currentWeek);
js/app.js:3932:  if (isNaN(weekNum) || weekNum < 1 || weekNum > (semester?.numWeeks || 16)) {
js/app.js:4044:  .sheet-materials { display: flex; gap: 24px; }
js/app.js:4045:  .sheet-materials > div { flex: 1; }
js/app.js:4046:  .sheet-materials h3 { color: #00A693; }
js/app.js:4086:    if ((lesson.materialsList && lesson.materialsList.length > 0) || lesson.materials || lesson.dayOfMaterials) {
js/app.js:4087:      printHtml += `<div class="sheet-materials">`;
js/app.js:4088:      if (lesson.materialsList && lesson.materialsList.length > 0) {
js/app.js:4090:        for (const m of lesson.materialsList) {
js/app.js:4094:      } else if (lesson.materials) {
js/app.js:4095:        printHtml += `<div class="sheet-section"><h3>Materials to Prep</h3><p>${esc(lesson.materials)}</p></div>`;
js/app.js:4166:// per-season data: they live on the semester (seeded for 2026 by the type
js/app.js:4175:  const sem = currentConfig?.semesters?.[semKey] || {};
js/app.js:4343:  // semester the grid was rendered for.
js/app.js:4473:  const bar = document.getElementById('ca-semester-bar');
js/app.js:4474:  const select = document.getElementById('ca-semester-select');
js/app.js:4475:  const publishGroup = document.getElementById('ca-semester-publish-group');
js/app.js:4476:  if (!bar || !select || !currentConfig?.semesters) return;
js/app.js:4478:  const semesters = currentConfig.semesters;
js/app.js:4479:  const keys = Object.keys(semesters);
js/app.js:4491:    const sem = semesters[key];
js/app.js:4500:  // Populate "copy from" dropdown in new semester modal
js/app.js:4505:      copyHtml += `<option value="${escAttr(key)}">${escHtml(semesters[key].name)}</option>`;
js/app.js:4510:  // Publish toggle for current semester
js/app.js:4511:  const sem = semesters[currentKey];
js/app.js:4522:      ${!isActive ? `<button class="btn-text ca-delete-sem-btn" onclick="deleteSemester('${escAttr(currentKey)}')" title="Delete this semester">&#128465; Delete</button>` : ''}
js/app.js:4528:  const sem = currentConfig?.semesters?.[key];
js/app.js:4531:    alert('Cannot delete the active semester.');
js/app.js:4554:    : `Delete semester "${sem.name}"? This will remove all its lesson data, cut bank, and change history. This cannot be undone.`;
js/app.js:4558:  // Remove the semester's own entry and nothing else (Phase 1, 1.2). Revert
js/app.js:4560:  // semester the server still has — with no alert and no re-render to show it
js/app.js:4562:  const removed = currentConfig.semesters[key];
js/app.js:4563:  delete currentConfig.semesters[key];
js/app.js:4565:    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
js/app.js:4567:    currentConfig.semesters[key] = removed;
js/app.js:4568:    console.error('❌ Could not remove the semester:', err);
js/app.js:4578:  // …but only a WEEKLY semester has lessons of its own inside
js/app.js:4589:  // Switch to active semester
js/app.js:4600:  // Delegates to global semester — CA always stays in sync with the header selector
js/app.js:4605:  if (!currentConfig?.semesters?.[key]) return;
js/app.js:4606:  if (!isPublishableType(key)) { alert('This semester type can\'t be published.'); return; }
js/app.js:4615:  const hadPublished = 'published' in currentConfig.semesters[key];
js/app.js:4616:  const previous = currentConfig.semesters[key].published;
js/app.js:4617:  currentConfig.semesters[key].published = published;
js/app.js:4619:    await updateAppData({ [`semesters.${key}.published`]: published });
js/app.js:4622:    if (currentConfig.semesters[key]) {
js/app.js:4623:      if (hadPublished) currentConfig.semesters[key].published = previous;
js/app.js:4624:      else delete currentConfig.semesters[key].published;
js/app.js:4627:    alert(`Could not ${published ? 'publish' : 'unpublish'} that semester: ${err.message}\n\nNothing was changed.`);
js/app.js:4635:function isPublishableType(semKey) { return PUBLISHABLE_SEMESTER_TYPES.has(semesterTypeOf(semKey)); }
js/app.js:4638:  document.getElementById('ca-new-semester-modal')?.classList.add('open');
js/app.js:4696:  if (currentConfig.semesters?.[key]) { alert(`${currentConfig.semesters[key].name} already exists (${key}).`); return; }
js/app.js:4701:    if (serverConfig?.semesters?.[key]) {
js/app.js:4706:    const newSem = { name, semesterType: SEMESTER_TYPES.dayOff, startDate, endDate, published: false, teacherNames: [] };
js/app.js:4707:    await updateAppData({ [`semesters.${key}`]: newSem });
js/app.js:4708:    currentConfig.semesters[key] = newSem;
js/app.js:4735:// already have a semester here. In legacy mode there is no registry to read,
js/app.js:4757:    // would offer 2026 again and create a duplicate semester.
js/app.js:4758:    const semesters = currentConfig?.semesters || {};
js/app.js:4759:    const taken = new Set(Object.values(semesters).map(sem => sem?.season).filter(Boolean));
js/app.js:4760:    const available = registered.filter(r => !taken.has(r.season) && !semesters[`summer-${r.season}`]);
js/app.js:4787:  document.getElementById('ca-new-semester-modal')?.classList.remove('open');
js/app.js:4802:// materials, photoUrl, qaThread etc. are not CONTENT_FIELDS but are still
js/app.js:4822:  if (currentConfig.semesters?.[key]) { alert(`Summer ${season} is already in the Classbook.`); return; }
js/app.js:4836:    if (serverConfig?.semesters?.[key]) {
js/app.js:4840:    const newSem = semesterFromRegistrySeason(registry);
js/app.js:4841:    await updateAppData({ [`semesters.${key}`]: newSem });
js/app.js:4842:    currentConfig.semesters[key] = newSem;
js/app.js:4849:    delete currentConfig.semesters[key];
js/app.js:4864:  if (currentConfig.semesters[key]) {
js/app.js:4865:    alert(`A semester with key "${key}" already exists.`);
js/app.js:4879:    semesterType: SEMESTER_TYPES.weekly,   // stored explicitly from now on (Phase 1, 1.1)
js/app.js:4892:  // for a semester the admin was told didn't get created, and a retry with the
js/app.js:4898:    // Copy roster from existing semester if selected
js/app.js:4899:    if (copyFromKey && currentConfig.semesters[copyFromKey]) {
js/app.js:4906:      // semester isn't visible here either. Forced server read — the local
js/app.js:4912:      // lesson data, and re-creating a deleted semester there adopts its
js/app.js:4916:        alert(`Lesson content already exists in Firestore under the key "${key}".\n\nIf it was left over from a deleted semester, create this semester again without "Copy from" to adopt that data.\n\nIf another admin may have just created it, reload this page first.\n\nOtherwise choose a different name.`);
js/app.js:4920:      const source = currentConfig.semesters[copyFromKey];
js/app.js:4928:      // Create empty lesson slots from source semester's teacher/class combos
js/app.js:4955:            materials: '',
js/app.js:4957:            materialsList: [],
js/app.js:4977:    if (serverConfig?.semesters?.[key]) {
js/app.js:4978:      throw new Error(`A semester with the key "${key}" already exists (created in another tab or by another admin). Choose a different name.`);
js/app.js:4980:    currentConfig.semesters[key] = newSem;
js/app.js:4981:    await updateAppData({ [`semesters.${key}`]: newSem });
js/app.js:4983:    console.error('❌ Could not create new semester:', err);
js/app.js:4985:    // "already exists" and the grid doesn't render a semester that never saved.
js/app.js:4986:    delete currentConfig.semesters[key];
js/app.js:4996:        console.error('⚠️ Could not clean up orphaned lesson data after failed semester creation:', cleanupErr);
js/app.js:4999:    alert('Could not create the new semester. Please try again.');
js/app.js:5066:  const semester = currentConfig?.semesters?.[semKey] || getActiveSemester();
js/app.js:5067:  const numWeeks = semester?.numWeeks || 16;
js/app.js:5068:  const breakWeeks = semester?.breakWeeks || [];
js/app.js:5074:      : 'No lesson data for this semester yet. Import lessons or paste from Cut/Idea Bank.'}</div>`;
js/app.js:5117:      const weekDateLabel = getWeekStartLabel(semester, col.weekNum);
js/app.js:5141:      const closureDate = getClosureForWeek(semester, w, combo.className);
js/app.js:5157:        const matCount = (lesson.materialsList?.length || 0) || (lesson.materials ? 1 : 0);
js/app.js:5178:          tooltipHtml += `<div class="ca-tooltip-detail">${matCount} material${matCount > 1 ? 's' : ''} listed</div>`;
js/app.js:5288:    if (lesson.materialsList && lesson.materialsList.length > 0) {
js/app.js:5289:      html += `<div class="tv-detail-section"><h5>Materials to Prep</h5><ul class="tv-materials-list">`;
js/app.js:5290:      for (const m of lesson.materialsList) {
js/app.js:5301:    } else if (lesson.materials) {
js/app.js:5302:      html += `<div class="tv-detail-section"><h5>Materials to Prep</h5><p>${escHtml(lesson.materials)}</p></div>`;
js/app.js:5379:// renderAdminEditForm) — planComplete/materialsList are shown read-only there.
js/app.js:5380:const CA_EDIT_FIELDS = ['projectTitle', 'shortDetails', 'inspoLink', 'introPitch', 'processStep1', 'processStep2', 'processStep3', 'processStep4', 'closure', 'materials', 'dayOfMaterials'];
js/app.js:5417:  // short details, inspo link and materials come from there on every load and
js/app.js:5426:    ? `<p class="te-photo-hint" style="margin:0 0 10px">Title, short details, inspo link and materials come from the Summer Camp App — edit them there. Everything below saves here.</p>`
js/app.js:5429:  const hasRef = l.projectDetails || l.projectInspiration || l.projectAdminNotes || (l.materialsList && l.materialsList.length > 0);
js/app.js:5430:  const refMatHtml = (l.materialsList && l.materialsList.length > 0)
js/app.js:5432:        <table class="materials-table" style="width:100%;border-collapse:collapse;font-size:12px;margin-top:4px">
js/app.js:5439:          <tbody>${l.materialsList.map(m => `<tr>
js/app.js:5497:      <textarea id="ca-edit-materials" rows="2" placeholder="Materials needed"${ro}>${escHtml(l.materials || '')}</textarea>
js/app.js:5605:    materials: document.getElementById('ca-edit-materials')?.value.trim() || '',
js/app.js:5638:  // unifies this on semesterType). Forced read — a cache-permitting get()
js/app.js:5686:  // Summer: projectTitle, shortDetails, inspoLink and materials belong to the
js/app.js:5694:  const SUMMER_CURRICULUM_OWNED = ['projectTitle', 'shortDetails', 'inspoLink', 'materials'];
js/app.js:5698:      const labels = { projectTitle: 'project title', shortDetails: 'short details', inspoLink: 'inspo link', materials: 'materials' };
js/app.js:5749:    // full lesson, never the whole semester. (The summer branch's "no content"
js/app.js:6108:  if (source.materials) html += `<div><strong>Materials:</strong> ${escHtml(source.materials.substring(0, 100))}${source.materials.length > 100 ? '...' : ''}</div>`;
js/app.js:6145:// cached semester via saveLessonData() — any lesson whose local copy was stale
js/app.js:6179:  const fields = getCopyableFields(source); // the 7 CONTENT_FIELDS plus `materials`
js/app.js:6291:  // the fresh read shows the slot's identity has materially changed since
js/app.js:6360:  // Gather cut projects from other semesters
js/app.js:6365:      const semName = currentConfig?.semesters?.[key]?.name || key;
js/app.js:6372:    alert('No cut projects available in any semester. Cut a project first.');
js/app.js:6380:  // Current semester's cut projects
js/app.js:6391:    html += '<p class="ca-empty-hint" style="margin-bottom:12px">No cut projects in this semester.</p>';
js/app.js:6394:  // Other semesters
js/app.js:6396:    html += `<details style="margin-top:16px"><summary style="font-size:14px;font-weight:600;cursor:pointer;color:var(--tinker-purple)">From previous semesters (${otherSemesters.reduce((s, o) => s + o.projects.length, 0)} projects)</summary>`;
js/app.js:6414:// saveLessonData() semester overwrite), removal via FieldValue.arrayRemove()
js/app.js:6436:  const srcSemName = currentConfig?.semesters?.[srcSemKey]?.name || srcSemKey;
js/app.js:6457:    materials: proj.materials || '',
js/app.js:6458:    materialsList: proj.materialsList || [],
js/app.js:6548:    const hasDetails = proj.introPitch || proj.processStep1 || proj.materials;
js/app.js:6581:      if (proj.materials) html += `<div class="ca-detail-field"><label>Materials</label><p>${escHtml(proj.materials)}</p></div>`;
js/app.js:6647:    if (proj.materials) text += `Materials: ${proj.materials}\n`;
js/app.js:6677:    <p class="ca-ideabank-empty">No project ideas yet. Add ideas anytime — they persist across semesters.</p>`;
js/app.js:6760:    <input type="text" id="idea-tags" placeholder="e.g. painting, sculpture, recycled materials" value="${escAttr((proj.tags || []).join(', '))}">
js/app.js:6891:// targeted saveSingleLesson() write (unrelated lessons in the same semester
js/app.js:6926:    materials: '',
js/app.js:6944:  // Q&A thread, photo, completion flag, or materials list would silently
js/app.js:6946:  const NON_CONTENT_FIELDS_TO_CLEAR = ['qaThread', 'photoUrl', 'photoPath', 'planComplete', 'materialsList'];
js/app.js:7125:// resave the ENTIRE cached semester via saveLessonData() — a Firestore
js/app.js:7130:// admin's stale cached copy — for ANY lesson in the semester, not just the
js/app.js:7150:  // A semester type this writer has no branch for is refused here, before the
js/app.js:7235:  // A semester type this writer has no branch for is refused here, before the
js/app.js:7387:      if (p.materials) prevHtml += `<div><strong>Materials:</strong> ${escHtml(p.materials)}</div>`;
js/app.js:7411:// ~/tinker-backups/backup.js runs every 30 min, 8am-6pm Mountain Time,
js/app.js:7421:// Pure render — takes already-fetched backupStatus/latest data (or null) and
js/app.js:7425:  const container = document.getElementById('ca-backup-health-content');
js/app.js:7429:    container.innerHTML = '<p class="ca-empty-hint">No backup status recorded yet.</p>';
js/app.js:7440:  let html = `<p class="ca-empty-hint">Last successful backup: ${escHtml(lastSuccessAt ? lastSuccessAt.toLocaleString() : 'never recorded')}</p>`;
js/app.js:7444:    html += `<p class="ca-backup-flag">⚠️ Last successful backup is over 2 hours old during business hours. If unexpected, check Firebase CLI auth on the machine running the backup script (a common cause is an expired "invalid_rapt" session).</p>`;
js/app.js:7447:    html += `<p class="ca-backup-flag">⚠️ Errors backing up: ${escHtml(errorCollections.join(', '))}</p>`;
js/app.js:7450:    html += `<p class="ca-backup-flag">⚠️ Possible data loss detected in: ${escHtml(dataLossWarningCollections.join(', '))}</p>`;
js/app.js:7453:    html += `<p class="ca-backup-ok">&#10003; Backup system healthy.</p>`;
js/app.js:7455:  html += `<p class="ca-backup-caveat">This reflects the local backup script's health, not the native Google-managed Firestore backups (which run independently).</p>`;
js/app.js:7461:  const container = document.getElementById('ca-backup-health-content');
js/app.js:7463:  container.innerHTML = '<p class="ca-empty-hint">Loading backup status…</p>';
js/app.js:7466:    const snap = await curriculumDb.collection('backupStatus').doc('latest').get();
js/app.js:7469:    // backupStatus is manager/admin-only (shared across every Tinker HQ app) —
js/app.js:7478:    console.error('Error loading backup health:', err);
js/app.js:7479:    container.innerHTML = '<p class="ca-backup-flag">⚠️ Failed to load backup status.</p>';
js/app.js:7484:  const content = document.getElementById('ca-backup-health-content');
js/app.js:7492:// Same >10% drop threshold ~/tinker-backups/backup.js already uses for its
js/app.js:7520:  for (const semesterLessons of Object.values(lessonDataDoc)) {
js/app.js:7521:    if (!semesterLessons || typeof semesterLessons !== 'object') continue;
js/app.js:7522:    for (const lesson of Object.values(semesterLessons)) tally(lesson);
js/app.js:7528:// Pure render — takes already-computed live and backup-derived per-teacher
js/app.js:7529:// counts (backupCounts may be null if unavailable/inaccessible), so it's
js/app.js:7531:function renderContentCountData(liveCounts, backupCounts) {
js/app.js:7537:    ...Object.keys(backupCounts || {}),
js/app.js:7549:    const hasBaseline = !!backupCounts && typeof backupCounts[teacher] === 'number';
js/app.js:7550:    const backupCount = hasBaseline ? backupCounts[teacher] : null;
js/app.js:7551:    const isDrop = hasBaseline && backupCount > 0 &&
js/app.js:7552:      ((backupCount - today) / backupCount) > CONTENT_COUNT_DROP_THRESHOLD;
js/app.js:7558:      <td>${hasBaseline ? backupCount : '—'}</td>
js/app.js:7559:      <td class="${isDrop ? 'ca-backup-flag' : ''}">${isDrop ? `⚠️ Dropped from ${backupCount} to ${today}` : 'OK'}</td>
js/app.js:7564:  if (!backupCounts) {
js/app.js:7565:    html += '<p class="ca-empty-hint">No backup-derived comparison available yet.</p>';
js/app.js:7568:    html += `<p class="ca-backup-flag">⚠️ ${flaggedCount} teacher${flaggedCount !== 1 ? 's' : ''} show a content-count drop of more than 10% since the last backup.</p>`;
js/app.js:7584:    let backupCounts = null;
js/app.js:7587:      const snap = await curriculumDb.collection('backupStatus').doc('latest').get();
js/app.js:7588:      backupCounts = snap.exists ? (snap.data().classbookContentByTeacher || null) : null;
js/app.js:7590:      // backupStatus is manager/admin-only (same boundary as Backup Health) —
js/app.js:7593:      backupCounts = null;
js/app.js:7595:    renderContentCountData(liveCounts, backupCounts);
js/app.js:7598:    container.innerHTML = '<p class="ca-backup-flag">⚠️ Failed to load content counts.</p>';
js/app.js:7624:  const container = document.getElementById('material-forecast');
js/app.js:7631:  // Hide forecast for Summer camps (weeks work differently, this feature is Spring-only)
js/app.js:7647:  const projectMap = {}; // normalizedTitle → { title, classes: [...], weeks: Set, totalStudents, materials: Set, dayOfMaterials: Set }
js/app.js:7663:        materials: new Set(),
js/app.js:7677:      materials: lesson.materials || '',
js/app.js:7688:    // Collect unique material lines (full text, not split fragments)
js/app.js:7689:    if (lesson.materials) {
js/app.js:7690:      const lines = lesson.materials.split(/\n+/).map(l => l.trim()).filter(l => l);
js/app.js:7691:      for (const l of lines) projectMap[normTitle].materials.add(l);
js/app.js:7713:  let html = `<div class="forecast-header" id="forecast-toggle">
js/app.js:7714:    <span class="forecast-collapse-icon">${wasCollapsed ? '&#9654;' : '&#9660;'}</span>
js/app.js:7715:    <h3 class="forecast-title">Upcoming Prep — What's Coming</h3>
js/app.js:7716:    <span class="forecast-hint">Projects in 3+ classes, Weeks ${lookAhead[0]}–${lookAhead[2]}</span>
js/app.js:7717:    <span class="forecast-count"><span class="forecast-count-active">${activeCount} active</span>${dismissedCount > 0 ? ` <span class="forecast-count-handled">${dismissedCount} handled</span>` : ''}</span>
js/app.js:7718:  </div><div class="forecast-items" style="${wasCollapsed ? 'display:none' : ''}">`;
js/app.js:7722:    const matList = [...proj.materials];
js/app.js:7740:    html += `<div class="forecast-project ${isDismissed ? 'forecast-dismissed' : ''}" data-expanded="false" data-norm-key="${escAttr(normKey)}">
js/app.js:7741:      <div class="forecast-project-header">
js/app.js:7742:        <span class="forecast-expand-icon">&#9654;</span>
js/app.js:7743:        <button class="forecast-dismiss-btn ${isDismissed ? 'dismissed' : ''}" data-norm-key="${escAttr(normKey)}" title="${isDismissed ? 'Mark as active' : 'Mark as handled'}">${isDismissed ? '&#9745;' : '&#9744;'}</button>
js/app.js:7744:        <span class="forecast-project-title">${escHtml(proj.title)}</span>
js/app.js:7745:        <span class="forecast-classes">${uniqueClassCount} classes</span>
js/app.js:7746:        <span class="forecast-students">${totalStudents} students</span>
js/app.js:7747:        <span class="forecast-weeks">${weekList}</span>
js/app.js:7748:        ${allReady ? '<span class="forecast-status-badge ready">All Ready</span>' :
js/app.js:7749:          noneReady ? '<span class="forecast-status-badge not-ready">None Ready</span>' :
js/app.js:7750:          `<span class="forecast-status-badge partial">${readyClasses.size}/${uniqueClassCount} Ready</span>`}
js/app.js:7752:      <div class="forecast-project-details">`;
js/app.js:7756:      html += '<div class="forecast-materials-section">';
js/app.js:7758:        html += '<div class="forecast-mat-label">Materials to Prep:</div><ul class="forecast-mat-list">';
js/app.js:7763:        html += '<div class="forecast-mat-label">Day-Of Materials:</div><ul class="forecast-mat-list">';
js/app.js:7769:      html += '<div class="forecast-no-mats">No materials listed yet</div>';
js/app.js:7773:    html += '<div class="forecast-class-breakdown"><div class="forecast-mat-label">Classes:</div>';
js/app.js:7778:      html += `<div class="forecast-class-row">
js/app.js:7779:        <span class="forecast-class-status">${statusIcon}</span>
js/app.js:7780:        <span class="forecast-class-name forecast-go-link" data-teacher="${escHtml(c.teacher)}" data-class="${escHtml(c.className)}" data-week="${c.weekNum}">${escHtml(c.teacher)} — ${escHtml(c.className)}</span>
js/app.js:7781:        <span class="forecast-class-info">${c.students} students · Wk${c.weekNum}</span>
js/app.js:7793:  document.getElementById('forecast-toggle')?.addEventListener('click', () => {
js/app.js:7794:    const items = container.querySelector('.forecast-items');
js/app.js:7795:    const icon = container.querySelector('.forecast-collapse-icon');
js/app.js:7802:  container.querySelectorAll('.forecast-project-header').forEach(header => {
js/app.js:7804:      const proj = header.closest('.forecast-project');
js/app.js:7812:  container.querySelectorAll('.forecast-dismiss-btn').forEach(btn => {
js/app.js:7826:      const proj = btn.closest('.forecast-project');
js/app.js:7827:      proj.classList.toggle('forecast-dismissed', nowDismissed);
js/app.js:7833:      const allProjects = container.querySelectorAll('.forecast-project');
js/app.js:7834:      const dCount = container.querySelectorAll('.forecast-dismissed').length;
js/app.js:7836:      const countEl = container.querySelector('.forecast-count');
js/app.js:7837:      if (countEl) countEl.innerHTML = `<span class="forecast-count-active">${aCount} active</span>${dCount > 0 ? ` <span class="forecast-count-handled">${dCount} handled</span>` : ''}`;
js/app.js:7843:        console.error('Error saving forecast dismissal:', err);
js/app.js:7848:  container.querySelectorAll('.forecast-go-link').forEach(link => {
js/app.js:7881:  const semester = getActiveSemester();
js/app.js:7883:  if (!semester || !select) return;
js/app.js:7886:  for (let i = 1; i <= semester.numWeeks; i++) {
js/app.js:7894:  const currentWeek = getCurrentWeek(semester);
js/app.js:7901:function getCurrentWeek(semester) {
js/app.js:7902:  const start = new Date(semester.startDate + 'T00:00:00');
js/app.js:7908:  const breaks = (semester.breakWeeks || []).sort((a, b) => a - b);
js/app.js:7914:  if (teachingWeek > semester.numWeeks) teachingWeek = semester.numWeeks;
js/app.js:7925:  const semester = getActiveSemester();
js/app.js:7927:  if (!semester) {
js/app.js:7928:    container.innerHTML = '<div class="prep-error">No semester config found. Go to Settings to configure.</div>';
js/app.js:7932:  container.innerHTML = '<div class="prep-loading"><div class="status-spinner"></div><p>Loading Week ' + weekNum + ' materials...</p></div>';
js/app.js:7954:  // Check if this is a summer camp semester
js/app.js:7955:  const currentSemester = currentConfig?.semesters?.[semKey];
js/app.js:7956:  const isSummerCamp = currentSemester?.semesterType === 'summer-camp';
js/app.js:7966:  // Convert lesson data into material items compatible with existing rendering
js/app.js:7976:    // Use structured materialsList when available
js/app.js:7977:    if (lesson.materialsList && lesson.materialsList.length > 0) {
js/app.js:7978:      for (let idx = 0; idx < lesson.materialsList.length; idx++) {
js/app.js:7979:        const m = lesson.materialsList[idx];
js/app.js:7989:          material: m.name,
js/app.js:8004:      // Fallback: parse freetext materials
js/app.js:8005:      const materialsText = lesson.materials || '';
js/app.js:8006:      const materialNames = materialsText
js/app.js:8011:      for (const mat of materialNames) {
js/app.js:8021:          material: mat,
js/app.js:8029:          dayOfMaterials: materialNames.indexOf(mat) === 0 ? dayOfMaterials : '',
js/app.js:8034:      if (materialNames.length > 0) addedDayOf = true;
js/app.js:8037:    // If no materials at all, still create a placeholder item
js/app.js:8039:      const key = makeItemKey(lesson.teacher, lesson.className, String(lesson.weekNum), lesson.weekDate, lesson.projectTitle, '(no-materials)');
js/app.js:8048:        material: '',
js/app.js:8049:        sheetNotes: dayOfMaterials ? '' : 'No materials listed — check with teacher',
js/app.js:8084:function makeItemKey(teacher, className, week, weekDate, project, material) {
js/app.js:8085:  return [norm(teacher), norm(className), norm(week), norm(weekDate), norm(project), norm(material)].join('||');
js/app.js:8133:        materials: [],
js/app.js:8138:    if (item.material) {
js/app.js:8139:      groups[dayKey].projects[projKey].materials.push(item);
js/app.js:8294:function getClosureForWeek(semester, teachingWeekNum, className) {
js/app.js:8295:  if (!semester?.startDate || !semester?.closureDates?.length) return null;
js/app.js:8297:  const start = new Date(semester.startDate + 'T00:00:00');
js/app.js:8298:  const breakWeeks = (semester.breakWeeks || []).sort((a, b) => a - b);
js/app.js:8319:  return semester.closureDates.includes(classDateISO) ? classDateISO : null;
js/app.js:8330:function getWeekStartLabel(semester, teachingWeekNum) {
js/app.js:8331:  if (!semester?.startDate) return '';
js/app.js:8332:  const start = new Date(semester.startDate + 'T00:00:00');
js/app.js:8333:  const breakWeeks = (semester.breakWeeks || []).sort((a, b) => a - b);
js/app.js:8384:  return lesson && (lesson.introPitch || lesson.processStep1 || lesson.materials);
js/app.js:8396:    materials: lesson.materials || '',
js/app.js:8482:    container.innerHTML = '<div class="prep-error">No materials found for this week. The Week sheet may be empty or not yet built.</div>';
js/app.js:8491:    if (!item.material) continue;
js/app.js:8510:      <div class="prep-summary-text"><strong>${completedMaterials}/${totalMaterials}</strong> materials complete for Week ${weekNum}</div>
js/app.js:8599:            <span>Same project as <strong>${escHtml(primaryLabel)}</strong> &mdash; materials listed there</span>
js/app.js:8605:      if (proj.materials.length > 0 && !isSeeRef) {
js/app.js:8607:          <table class="prep-materials-table">
js/app.js:8610:              <th class="col-material">Material</th>
js/app.js:8622:        for (const mat of proj.materials) {
js/app.js:8631:            <tr class="prep-material-row ${isComplete ? 'row-complete' : ''} ${isManual ? 'manual-row' : ''}"
js/app.js:8637:              <td class="col-material">
js/app.js:8638:                ${escHtml(mat.material)}${isManual ? '<span class="manual-badge">manual</span>' : ''}
js/app.js:8662:        html += `<button class="add-material-btn" data-class="${escAttr(proj.className)}" data-project="${escAttr(proj.projectTitle)}" data-teacher="${escAttr(proj.teacher)}">+ Add Material</button>`;
js/app.js:8665:      // Day-Of materials callout
js/app.js:8719:  if (e.target.classList.contains('add-material-btn')) {
js/app.js:8728:    e.target.closest('.add-material-form-row')?.remove();
js/app.js:8764:  const row = checkbox.closest('.prep-material-row');
js/app.js:8846:  const row = document.querySelector(`.prep-material-row[data-key="${CSS.escape(key)}"]`);
js/app.js:8902:    if (!item.material) continue;
js/app.js:8910:  if (text) text.innerHTML = `<strong>${completed}/${total}</strong> materials complete for Week ${weekNum}`;
js/app.js:8953:  document.querySelectorAll('.prep-material-row').forEach(row => {
js/app.js:9186:  document.querySelectorAll('.prep-material-row').forEach(row => {
js/app.js:9271:          <p class="today-no-phases-sub">Check teacher tubs for any day-of materials needed for Friday or Monday classes.</p>
js/app.js:9292:    const materialsLink = phase.id === 'prep'
js/app.js:9293:      ? `<div class="today-phase-footer"><button class="today-day-view-link" data-day="${escAttr(todayName)}">→ View ${todayName}'s materials in Day View</button></div>`
js/app.js:9305:        ${materialsLink}
js/app.js:9315:          <p class="reset-ref-note">When these items appear in prep requests or day-of materials, do a reset: refill, organize, clean up.</p>
js/app.js:9348:            <li><strong>Clay Hub Storage</strong> — Go through each shelving unit with stickers, marker, computer — confirm and document. Sweep, clean, clear surfaces for a good once-a-semester clean-out.</li>
js/app.js:9350:            <li><strong>Fall — Beginning of Semester</strong> — Repeat same process to reset after intensive summer camp materials use.</li>
js/app.js:9517:        materials: [],
js/app.js:9523:    if (item.material) classProjects[cpKey].materials.push(item);
js/app.js:9528:  const groups = {}; // normalizedTitle → { primaryClasses: [], refClasses: [], materials: [], ... }
js/app.js:9549:          materials: [],
js/app.js:9554:      groups[normalizedTitle].materials.push(...cp.materials);
js/app.js:9612:          materials: [],
js/app.js:9625:function getMaterialBaseKey(materialName) {
js/app.js:9626:  let key = materialName.trim().toLowerCase();
js/app.js:9695:    container.innerHTML = '<div class="prep-error">No materials found for this week.</div>';
js/app.js:9699:  // Check if current semester is a summer camp (hide "Combined total" for summer)
js/app.js:9700:  const currentSemester = currentConfig.semesters?.[globalSemesterKey];
js/app.js:9701:  const isSummerCamp = currentSemester?.semesterType === 'summer-camp';
js/app.js:9708:    if (!item.material) continue;
js/app.js:9726:      <div class="prep-summary-text"><strong>${completedMaterials}/${totalMaterials}</strong> materials complete for Week ${weekNum}</div>
js/app.js:9780:    // Deduplicate materials: filter out label rows, merge duplicates, sum Class+1
js/app.js:9781:    const filteredMats = group.materials.filter(mat => {
js/app.js:9782:      const m = mat.material.trim().toLowerCase();
js/app.js:9789:    // Smart merge: group materials by base name (strip teacher notes after "/" or " with ")
js/app.js:9796:      const baseKey = getMaterialBaseKey(mat.material);
js/app.js:9815:        if (mat.material.length > found.displayName.length) {
js/app.js:9816:          found.displayName = mat.material;
js/app.js:9825:          displayName: mat.material,
js/app.js:9847:        <table class="prep-materials-table">
js/app.js:9850:            <th class="col-material">Material</th>
js/app.js:9873:        // Use the most descriptive material name
js/app.js:9874:        const displayName = merged.displayName || mat.material;
js/app.js:9877:          <tr class="prep-material-row ${isComplete ? 'row-complete' : ''} ${isManual ? 'manual-row' : ''}"
js/app.js:9884:            <td class="col-material">
js/app.js:9910:      html += `<button class="add-material-btn" data-class="${escAttr(firstClass.className || '')}" data-project="${escAttr(group.projectTitle)}" data-teacher="${escAttr(firstClass.teacher || '')}">+ Add Material</button>`;
js/app.js:9913:    // Day-Of materials
js/app.js:9941:    material: mi.material || '',
js/app.js:9960:  document.querySelectorAll('.add-material-form-row').forEach(r => r.remove());
js/app.js:9966:  // Find the nearest materials table
js/app.js:9968:  let tbody = card?.querySelector('.prep-materials-table tbody');
js/app.js:9973:    table.className = 'prep-materials-table';
js/app.js:9977:        <th class="col-material">Material</th>
js/app.js:9993:  formRow.className = 'add-material-form-row';
js/app.js:10023:  const row = btn.closest('.add-material-form-row');
js/app.js:10024:  const material = row.querySelector('.new-mat-name').value.trim();
js/app.js:10025:  if (!material) {
js/app.js:10044:    id, key, className, projectTitle, teacher, material, qty, scope, size,

exec
/bin/zsh -lc "sed -n '7400,7610p' js/app.js; rg -n \"renderChangeHistory|loadChange|currentChange|changeLog|history\" js/app.js js/firebase-data.js | sed -n '1,240p'; sed -n '4850,5005p' js/app.js; sed -n '4660,4725p' js/app.js; sed -n '4465,4610p' js/app.js" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:

  container.innerHTML = html;
}

function toggleChangeHistory() {
  const content = document.getElementById('ca-history-content');
  content.style.display = content.style.display === 'none' ? 'block' : 'none';
}

// ─── Backup Health (Data Safety Plan Stage 4B) ──────────────────────

// ~/tinker-backups/backup.js runs every 30 min, 8am-6pm Mountain Time,
// Mon-Fri (CLASSBOOK-DATA-SAFETY-PLAN.md Stage 1D). Outside that window a
// stale lastSuccessAt is expected, not a fault — only flag staleness during
// the hours a run should actually have happened.
function isClassbookBackupBusinessHours(now = new Date()) {
  const day = now.getDay(); // 0=Sun..6=Sat
  const hour = now.getHours();
  return day >= 1 && day <= 5 && hour >= 8 && hour < 18;
}

// Pure render — takes already-fetched backupStatus/latest data (or null) and
// an explicit isBusinessHours flag, so it's testable without a real Firestore
// read or a dependency on wall-clock time during a test run.
function renderBackupHealthData(data, isBusinessHours) {
  const container = document.getElementById('ca-backup-health-content');
  if (!container) return;

  if (!data) {
    container.innerHTML = '<p class="ca-empty-hint">No backup status recorded yet.</p>';
    return;
  }

  const lastSuccessAt = data.lastSuccessAt ? new Date(data.lastSuccessAt) : null;
  const hoursSinceSuccess = lastSuccessAt ? (Date.now() - lastSuccessAt.getTime()) / 3600000 : null;
  const isStale = isBusinessHours && (hoursSinceSuccess === null || hoursSinceSuccess > 2);
  const errorCollections = data.errorCollections || [];
  const dataLossWarningCollections = data.dataLossWarningCollections || [];
  const hasProblem = isStale || errorCollections.length > 0 || dataLossWarningCollections.length > 0;

  let html = `<p class="ca-empty-hint">Last successful backup: ${escHtml(lastSuccessAt ? lastSuccessAt.toLocaleString() : 'never recorded')}</p>`;
  html += `<p class="ca-empty-hint">Docs backed up: ${typeof data.docCount === 'number' ? data.docCount : '—'} across ${typeof data.collectionsBackedUp === 'number' ? data.collectionsBackedUp : '—'} collections</p>`;

  if (isStale) {
    html += `<p class="ca-backup-flag">⚠️ Last successful backup is over 2 hours old during business hours. If unexpected, check Firebase CLI auth on the machine running the backup script (a common cause is an expired "invalid_rapt" session).</p>`;
  }
  if (errorCollections.length > 0) {
    html += `<p class="ca-backup-flag">⚠️ Errors backing up: ${escHtml(errorCollections.join(', '))}</p>`;
  }
  if (dataLossWarningCollections.length > 0) {
    html += `<p class="ca-backup-flag">⚠️ Possible data loss detected in: ${escHtml(dataLossWarningCollections.join(', '))}</p>`;
  }
  if (!hasProblem) {
    html += `<p class="ca-backup-ok">&#10003; Backup system healthy.</p>`;
  }
  html += `<p class="ca-backup-caveat">This reflects the local backup script's health, not the native Google-managed Firestore backups (which run independently).</p>`;

  container.innerHTML = html;
}

async function renderBackupHealth() {
  const container = document.getElementById('ca-backup-health-content');
  if (!container) return;
  container.innerHTML = '<p class="ca-empty-hint">Loading backup status…</p>';
  try {
    if (!curriculumDb) initCurriculumFirestore();
    const snap = await curriculumDb.collection('backupStatus').doc('latest').get();
    renderBackupHealthData(snap.exists ? snap.data() : null, isClassbookBackupBusinessHours());
  } catch (err) {
    // backupStatus is manager/admin-only (shared across every Tinker HQ app) —
    // a curriculum-admin appAccess staff member can see this Curriculum Admin
    // panel without being a manager, and would hit this on every load. That's
    // an access boundary, not a fault, so it gets a neutral note instead of
    // the "something's wrong" alarm below.
    if (err.code === 'permission-denied') {
      container.innerHTML = '<p class="ca-empty-hint">Backup status is visible to admins and managers only.</p>';
      return;
    }
    console.error('Error loading backup health:', err);
    container.innerHTML = '<p class="ca-backup-flag">⚠️ Failed to load backup status.</p>';
  }
}

function toggleBackupHealth() {
  const content = document.getElementById('ca-backup-health-content');
  const wasHidden = content.style.display === 'none';
  content.style.display = wasHidden ? 'block' : 'none';
  if (wasHidden) renderBackupHealth();
}

// ─── Content Count by Teacher (Data Safety Plan Stage 4A) ───────────

// Same >10% drop threshold ~/tinker-backups/backup.js already uses for its
// own Tier-1 collection-level data-loss check — reused here for per-teacher
// consistency rather than inventing a second, unrelated threshold. A small
// routine edit (one lesson moved, one field trimmed) won't cross it; a real
// wipe of most of a teacher's content will.
const CONTENT_COUNT_DROP_THRESHOLD = 0.10;

async function computeLiveContentCountByTeacher() {
  if (!curriculumDb) initCurriculumFirestore();
  const counts = {};
  const tally = (lesson) => {
    if (!lesson || !lesson.teacher || !lessonHasContent(lesson)) return;
    counts[lesson.teacher] = (counts[lesson.teacher] || 0) + 1;
  };

  // Deliberately cross-season: this panel is the safety net that would notice
  // content vanishing from ANY season (per-season counting is Phase 4). But it
  // is still a summer read, so it obeys the same registry precondition as
  // every other one — no reads at all while the registry is unreadable.
  const registryMode = getSeasonRegistryMode();
  if (registryMode === 'error' || registryMode === 'unknown') {
    throw new Error(`Can't count summer content: the season registry is ${registryMode === 'unknown' ? 'unreachable' : 'unreadable'}.`);
  }
  const summerSnap = await curriculumDb.collection('summerCamps_lessonData').get();
  summerSnap.forEach(doc => tally(doc.data()));

  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
  const lessonDataDoc = lessonDataSnap.exists ? lessonDataSnap.data() : {};
  for (const semesterLessons of Object.values(lessonDataDoc)) {
    if (!semesterLessons || typeof semesterLessons !== 'object') continue;
    for (const lesson of Object.values(semesterLessons)) tally(lesson);
  }

  return counts;
}

// Pure render — takes already-computed live and backup-derived per-teacher
// counts (backupCounts may be null if unavailable/inaccessible), so it's
// testable without a real Firestore read.
function renderContentCountData(liveCounts, backupCounts) {
  const container = document.getElementById('ca-content-count-content');
  if (!container) return;

  const teachers = Array.from(new Set([
    ...Object.keys(liveCounts || {}),
    ...Object.keys(backupCounts || {}),
  ])).sort();

  if (teachers.length === 0) {
    container.innerHTML = '<p class="ca-empty-hint">No lesson content recorded yet.</p>';
    return;
  }

  let flaggedCount = 0;
  let rowsHtml = '';
  for (const teacher of teachers) {
    const today = liveCounts?.[teacher] || 0;
    const hasBaseline = !!backupCounts && typeof backupCounts[teacher] === 'number';
    const backupCount = hasBaseline ? backupCounts[teacher] : null;
    const isDrop = hasBaseline && backupCount > 0 &&
      ((backupCount - today) / backupCount) > CONTENT_COUNT_DROP_THRESHOLD;
    if (isDrop) flaggedCount++;

    rowsHtml += `<tr>
      <td>${escHtml(teacher)}</td>
      <td>${today}</td>
      <td>${hasBaseline ? backupCount : '—'}</td>
      <td class="${isDrop ? 'ca-backup-flag' : ''}">${isDrop ? `⚠️ Dropped from ${backupCount} to ${today}` : 'OK'}</td>
    </tr>`;
  }

  let html = '';
  if (!backupCounts) {
    html += '<p class="ca-empty-hint">No backup-derived comparison available yet.</p>';
  }
  if (flaggedCount > 0) {
    html += `<p class="ca-backup-flag">⚠️ ${flaggedCount} teacher${flaggedCount !== 1 ? 's' : ''} show a content-count drop of more than 10% since the last backup.</p>`;
  }
  html += `<div style="overflow-x:auto"><table class="ca-content-count-table">
    <thead><tr><th>Teacher</th><th>Today</th><th>Last Backup</th><th>Status</th></tr></thead>
    <tbody>${rowsHtml}</tbody>
  </table></div>`;

  container.innerHTML = html;
}

async function renderContentCount() {
  const container = document.getElementById('ca-content-count-content');
  if (!container) return;
  container.innerHTML = '<p class="ca-empty-hint">Loading content counts…</p>';
  try {
    const liveCounts = await computeLiveContentCountByTeacher();
    let backupCounts = null;
    try {
      if (!curriculumDb) initCurriculumFirestore();
      const snap = await curriculumDb.collection('backupStatus').doc('latest').get();
      backupCounts = snap.exists ? (snap.data().classbookContentByTeacher || null) : null;
    } catch (err) {
      // backupStatus is manager/admin-only (same boundary as Backup Health) —
      // degrade to "no comparison available" rather than blocking the live
      // counts, which this account can read regardless of that boundary.
      backupCounts = null;
    }
    renderContentCountData(liveCounts, backupCounts);
  } catch (err) {
    console.error('Error loading content counts:', err);
    container.innerHTML = '<p class="ca-backup-flag">⚠️ Failed to load content counts.</p>';
  }
}

function toggleContentCount() {
  const content = document.getElementById('ca-content-count-content');
  const wasHidden = content.style.display === 'none';
  content.style.display = wasHidden ? 'block' : 'none';
  if (wasHidden) renderContentCount();
}


// ═════════════════════════════════════════════════════
js/firebase-data.js:9://   curriculum/changeLog   — audit trail of moves/swaps/cuts
js/firebase-data.js:130:let currentChangeLog = null;
js/firebase-data.js:1247:// ─── Change Log (curriculum/changeLog) ───────────────
js/firebase-data.js:1249:async function loadChangeLog() {
js/firebase-data.js:1252:    const doc = await curriculumDb.collection('curriculum').doc('changeLog').get();
js/firebase-data.js:1253:    currentChangeLog = doc.exists ? doc.data() : {};
js/firebase-data.js:1256:    currentChangeLog = {};
js/firebase-data.js:1258:  return currentChangeLog;
js/firebase-data.js:1262:// call site benefits. This function mutates the local currentChangeLog array
js/firebase-data.js:1264:// renderChangeHistory() sees the new entry) — R2-13 already added a re-render
js/firebase-data.js:1272:  // Update local cache immediately so renderChangeHistory reflects the change
js/firebase-data.js:1273:  if (!currentChangeLog) currentChangeLog = {};
js/firebase-data.js:1274:  if (!currentChangeLog[semesterKey]) currentChangeLog[semesterKey] = [];
js/firebase-data.js:1275:  currentChangeLog[semesterKey] = [...currentChangeLog[semesterKey], entry];
js/firebase-data.js:1277:    await curriculumDb.collection('curriculum').doc('changeLog').set({
js/firebase-data.js:1281:    currentChangeLog[semesterKey] = currentChangeLog[semesterKey].filter(e => e !== entry);
js/app.js:139:    renderChangeHistory();
js/app.js:767:    tvNavStack = [];  // Clear back history on manual teacher change
js/app.js:4554:    : `Delete semester "${sem.name}"? This will remove all its lesson data, cut bank, and change history. This cannot be undone.`;
js/app.js:4596:  renderChangeHistory();
js/app.js:5012:  renderChangeHistory();
js/app.js:5020:  if (!currentChangeLog) await loadChangeLog();
js/app.js:5029:  renderChangeHistory();
js/app.js:5795:  renderChangeHistory();
js/app.js:5805:    renderChangeHistory();
js/app.js:5931:    renderChangeHistory();
js/app.js:5970:        renderChangeHistory();
js/app.js:6050:    renderChangeHistory();
js/app.js:6069:        renderChangeHistory();
js/app.js:6080:  renderChangeHistory();
js/app.js:6246:  renderChangeHistory();
js/app.js:6341:    renderChangeHistory();
js/app.js:6349:  renderChangeHistory();
js/app.js:6522:    renderChangeHistory();
js/app.js:6992:    renderChangeHistory();
js/app.js:7014:  renderChangeHistory();
js/app.js:7310:async function renderChangeHistory() {
js/app.js:7312:  if (!currentChangeLog) await loadChangeLog();
js/app.js:7313:  const entries = currentChangeLog?.[semKey] || [];
js/app.js:7314:  const container = document.getElementById('ca-history-content');
js/app.js:7328:  let html = `<div class="ca-history-stats">
js/app.js:7337:  html += '<div class="ca-history-timeline">';
js/app.js:7392:    html += `<div class="ca-history-entry">
js/app.js:7393:      <span class="ca-history-action ca-action-${entry.action}">${entry.action}</span>
js/app.js:7394:      <span class="ca-history-desc">${escHtml(desc)}</span>
js/app.js:7395:      <span class="ca-history-meta">${escHtml(entry.by || '')} &middot; ${time}</span>
js/app.js:7405:  const content = document.getElementById('ca-history-content');
    alert(`Could not add that season: ${err.message}`);
  } finally {
    creatingSemester = false;
  }
}

async function createNewSemester() {
  if (creatingSemester) return;
  if (selectedNewSemesterType() === SEMESTER_TYPES.camp) return await createCampSeasonSemester();
  if (selectedNewSemesterType() === SEMESTER_TYPES.dayOff) return await createDayOffYear();
  const name = document.getElementById('new-sem-name')?.value.trim();
  if (!name) { alert('Semester name is required.'); return; }

  const key = name.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/(^-|-$)/g, '');
  if (currentConfig.semesters[key]) {
    alert(`A semester with key "${key}" already exists.`);
    return;
  }

  const startDate = document.getElementById('new-sem-start')?.value || '';
  const numWeeks = parseInt(document.getElementById('new-sem-weeks')?.value) || 16;
  const breaksRaw = document.getElementById('new-sem-breaks')?.value.trim() || '';
  const breakWeeks = breaksRaw ? breaksRaw.split(',').map(s => parseInt(s.trim())).filter(n => !isNaN(n)) : [];
  const closuresRaw = document.getElementById('new-sem-closures')?.value.trim() || '';
  const closureDates = parseClosureDates(closuresRaw);
  const copyFromKey = document.getElementById('new-sem-copy-from')?.value || '';

  const newSem = {
    name,
    semesterType: SEMESTER_TYPES.weekly,   // stored explicitly from now on (Phase 1, 1.1)
    startDate,
    numWeeks,
    breakWeeks,
    closureDates,
    published: false,
    classRoster: {}
  };

  // Invoked from a bare HTML onclick — nothing above this frame catches, so a
  // failure anywhere below must be handled here (backtracking audit, Phase 11).
  // Two Firestore writes happen in sequence (lesson slots, then config); if the
  // second fails after the first landed, the slots are an orphan on the server
  // for a semester the admin was told didn't get created, and a retry with the
  // same name would silently reuse them. Track whether the first write landed
  // so the catch can compensate.
  let lessonDataCommitted = false;
  creatingSemester = true;
  try {
    // Copy roster from existing semester if selected
    if (copyFromKey && currentConfig.semesters[copyFromKey]) {
      // Pre-check (implementation review, Sep 2026): this branch is the only
      // path that writes lesson data, and the compensating delete in the catch
      // below removes the WHOLE `key` map — only safe if nothing lived there
      // before this call. It can: deleteSemester() drops a key from local
      // state even when its server-side deleteLessonData() fails (warn-only),
      // and config has no live listener, so another admin's same-named
      // semester isn't visible here either. Forced server read — the local
      // cache is exactly what can't be trusted for this key. Refuse unless
      // every existing lesson is template-empty (a prior createNewSemester()'s
      // own leftovers are safe to build on and safe to delete; anything else
      // would be merged over silently by the slot write, then deleted on
      // failure). The no-copy path is deliberately NOT gated: it writes no
      // lesson data, and re-creating a deleted semester there adopts its
      // surviving lesson data — the remedy this alert points at.
      const existingLessonMap = await readServerSemesterLessonMap(key);
      if (existingLessonMap && Object.values(existingLessonMap).some(l => !isTemplateEmptyLesson(l))) {
        alert(`Lesson content already exists in Firestore under the key "${key}".\n\nIf it was left over from a deleted semester, create this semester again without "Copy from" to adopt that data.\n\nIf another admin may have just created it, reload this page first.\n\nOtherwise choose a different name.`);
        return;
      }

      const source = currentConfig.semesters[copyFromKey];
      newSem.classRoster = JSON.parse(JSON.stringify(source.classRoster || {}));
      // Without this, classRoster's teacher fields are copied but the dropdown
      // that lets Settings display/edit them has no options — the roster looks
      // wiped even though the underlying data isn't, and saving Settings in
      // that state silently writes blank teachers over the real ones.
      newSem.teacherNames = JSON.parse(JSON.stringify(source.teacherNames || []));

      // Create empty lesson slots from source semester's teacher/class combos
      const sourceLessons = currentLessonData?.[copyFromKey] || {};
      const combos = new Set();
      for (const lesson of Object.values(sourceLessons)) {
        combos.add(`${lesson.teacher}|||${lesson.className}`);
      }

      const emptyLessons = {};
      for (const combo of combos) {
        const [teacher, className] = combo.split('|||');
        for (let w = 1; w <= numWeeks; w++) {
          const lessonKey = makeLessonKey(teacher, className, w);
          emptyLessons[lessonKey] = {
            teacher,
            className,
            weekNum: w,
            weekDate: '',
            classSize: 0,
            projectTitle: '',
            shortDetails: '',
            inspoLink: '',
            introPitch: '',
            processStep1: '',
            processStep2: '',
            processStep3: '',
            processStep4: '',
            closure: '',
            materials: '',
            dayOfMaterials: '',
            materialsList: [],
            status: '',
            publishToPrep: ''
          };
        }
      }

      if (Object.keys(emptyLessons).length > 0) {
        await saveLessonData(key, emptyLessons);
        if (!currentLessonData) currentLessonData = {};
        currentLessonData[key] = emptyLessons;
        lessonDataCommitted = true;
      }
    }

    // Confirm on the SERVER that the key is free — the check at the top of this
    // function only saw this tab's copy of the config (Phase 1, 1.2). The
    // remaining read-to-update window is accepted: one admin, same class as the
    // existing residual on the Q&A path.
    const serverConfig = await readAppDataFromServer();
    if (serverConfig?.semesters?.[key]) {
      throw new Error(`A semester with the key "${key}" already exists (created in another tab or by another admin). Choose a different name.`);
    }
    currentConfig.semesters[key] = newSem;
    await updateAppData({ [`semesters.${key}`]: newSem });
  } catch (err) {
    console.error('❌ Could not create new semester:', err);
    // Revert both local mutations so a retry isn't blocked by a phantom
    // "already exists" and the grid doesn't render a semester that never saved.
    delete currentConfig.semesters[key];
    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
    // R4-11: the empty lesson slots may already be persisted even though the
    // config never was — clean up the orphaned server-side write, not just the
    // local copy. Safe: this data is template-empty by construction (never had
    // real content), so deleting it loses nothing.
    if (lessonDataCommitted) {
      try {
        await deleteLessonData(key);
      } catch (cleanupErr) {
        console.error('⚠️ Could not clean up orphaned lesson data after failed semester creation:', cleanupErr);
      }
    }
    alert('Could not create the new semester. Please try again.');
    return;
  } finally {
    creatingSemester = false;
  }

  closeNewSemesterModal();
    if (type === SEMESTER_TYPES.dayOff) resetDayOffYearFields();
  }
}

// Defaults: Aug 1 of this year → May 31 of the next; name follows the dates
// until the admin types their own.
function resetDayOffYearFields() {
  const y = new Date().getFullYear();
  const start = document.getElementById('new-sem-dayoff-start');
  const end = document.getElementById('new-sem-dayoff-end');
  const name = document.getElementById('new-sem-dayoff-name');
  if (start) start.value = `${y}-08-01`;
  if (end) end.value = `${y + 1}-05-31`;
  if (name) delete name.dataset.edited;
  onDayOffYearDatesChange();
}

function onDayOffYearDatesChange() {
  const name = document.getElementById('new-sem-dayoff-name');
  if (!name || name.dataset.edited) return;
  const start = document.getElementById('new-sem-dayoff-start')?.value || '';
  const end = document.getElementById('new-sem-dayoff-end')?.value || '';
  name.value = start && end ? dayOffYearLabels(start, end).name : '';
}

// An SDOC school year: one appData entry through the field-path writer, after
// a forced-server absence check. No roster, no lesson slots, no
// curriculum/lessonData write.
async function createDayOffYear() {
  const startDate = document.getElementById('new-sem-dayoff-start')?.value || '';
  const endDate = document.getElementById('new-sem-dayoff-end')?.value || '';
  const name = document.getElementById('new-sem-dayoff-name')?.value.trim() || '';
  if (!isIsoDate(startDate) || !isIsoDate(endDate)) { alert('Pick the school year\'s start and end dates.'); return; }
  if (endDate <= startDate) { alert('The school year has to end after it starts.'); return; }
  if (!name) { alert('Give the school year a name.'); return; }
  const { key } = dayOffYearLabels(startDate, endDate);
  if (currentConfig.semesters?.[key]) { alert(`${currentConfig.semesters[key].name} already exists (${key}).`); return; }

  creatingSemester = true;
  try {
    const serverConfig = await readAppDataFromServer();
    if (serverConfig?.semesters?.[key]) {
      alert(`A school year with key "${key}" was already created (in another tab, or by another admin). Reload to see it.`);
      creatingSemester = false;
      return;
    }
    const newSem = { name, semesterType: SEMESTER_TYPES.dayOff, startDate, endDate, published: false, teacherNames: [] };
    await updateAppData({ [`semesters.${key}`]: newSem });
    currentConfig.semesters[key] = newSem;
  } catch (err) {
    console.error('❌ Could not create the school year:', err);
    alert(`Could not create that school year: ${err.message}`);
    creatingSemester = false;
    return;
  }
  // The write landed — anything failing from here is display only.
  try {
    currentDayOffEvents[key] = [];
    currentDayOffCamps[key] = [];
    currentDayOffPlans[key] = {};
    currentDayOffSignoffs[key] = {};
    if (currentLessonData) currentLessonData[key] = {};
    closeNewSemesterModal();
    renderSemesterSelector();
    initGlobalSemesterSelector();
    alert(`${name} created. It stays hidden from teachers. Next: add its teacher names in Settings, then its day-off dates and camps in Curriculum Admin.`);
  });

  return html || `<div class="tv-placeholder">No lesson data found for Week ${weekNum}.</div>`;
}

// ─── End Summer CA Views ──────────────────────────────────────────────────────

function renderSemesterSelector() {
  const bar = document.getElementById('ca-semester-bar');
  const select = document.getElementById('ca-semester-select');
  const publishGroup = document.getElementById('ca-semester-publish-group');
  if (!bar || !select || !currentConfig?.semesters) return;

  const semesters = currentConfig.semesters;
  const keys = Object.keys(semesters);

  // Only show bar if user is admin/manager
  const user = getAuthUser();
  if (!user || !['admin', 'manager'].includes(user.role)) { bar.style.display = 'none'; return; }

  bar.style.display = 'flex';
  const currentKey = getAdminSemKey();

  // Build dropdown options
  let optionsHtml = '';
  for (const key of keys) {
    const sem = semesters[key];
    const isActive = key === currentConfig.activeSemester;
    const isPublished = sem.published !== false;
    const label = sem.name + (isActive ? ' (active)' : '') + (!isPublished ? ' [draft]' : '');
    optionsHtml += `<option value="${escAttr(key)}" ${key === currentKey ? 'selected' : ''}>${escHtml(label)}</option>`;
  }
  select.innerHTML = optionsHtml;
  select.onchange = () => setGlobalSemester(select.value);

  // Populate "copy from" dropdown in new semester modal
  const copyFrom = document.getElementById('new-sem-copy-from');
  if (copyFrom) {
    let copyHtml = '<option value="">Start blank (no classes)</option>';
    for (const key of keys.filter(k => !isDayOffYear(k))) {
      copyHtml += `<option value="${escAttr(key)}">${escHtml(semesters[key].name)}</option>`;
    }
    copyFrom.innerHTML = copyHtml;
  }

  // Publish toggle for current semester
  const sem = semesters[currentKey];
  if (sem) {
    const isPublished = sem.published !== false;
    const isActive = currentKey === currentConfig.activeSemester;
    publishGroup.innerHTML = `
      ${isActive ? '<span class="ca-sem-active-badge">Active Semester</span>' : ''}
      ${!isActive ? `<label class="ca-publish-toggle">
        <input type="checkbox" ${isPublished ? 'checked' : ''} onchange="toggleSemesterPublish('${escAttr(currentKey)}', this.checked)">
        Published (visible to teachers)
      </label>` : ''}
      ${!isPublished && !isActive ? '<span class="ca-sem-unpublished-badge">Draft</span>' : ''}
      ${!isActive ? `<button class="btn-text ca-delete-sem-btn" onclick="deleteSemester('${escAttr(currentKey)}')" title="Delete this semester">&#128465; Delete</button>` : ''}
    `;
  }
}

async function deleteSemester(key) {
  const sem = currentConfig?.semesters?.[key];
  if (!sem) return;
  if (key === currentConfig.activeSemester) {
    alert('Cannot delete the active semester.');
    return;
  }
  // Removing a CAMP season from the Classbook removes only this app's entry
  // for it. Its camps, schedule, plans and photos belong to the Summer Camp
  // App and stay exactly where they are — adding the season back from the
  // registry restores the whole view (Phase 1, 1.7). This supersedes the
  // companion plan's summer-delete design, which predates seasons.
  // An SDOC year: refused while any event exists (a forced-server count);
  // otherwise only its appData entry goes — it has nothing in
  // curriculum/lessonData, and no collection is ever cleared from here.
  if (isDayOffYear(key)) {
    let events;
    try { events = await countDayOffEvents(key); }
    catch (err) { alert(`Could not check "${sem.name}" for events: ${err.message}\n\nNothing was changed.`); return; }
    if (events > 0) { alert(`"${sem.name}" still has ${events} event${events === 1 ? '' : 's'}. Remove its events first.`); return; }
  }
  const isCamp = isCampSeason(key);
  const isDayOff = isDayOffYear(key);
  const firstConfirm = isDayOff
    ? `Delete the school year "${sem.name}"? It has no events, so only the year itself is removed.`
    : isCamp
    ? `Remove "${sem.name}" from the Classbook?\n\nThis only removes it here. Every camp, schedule, lesson plan and photo stays in the Summer Camp App, and you can add the season back at any time from + New Semester.`
    : `Delete semester "${sem.name}"? This will remove all its lesson data, cut bank, and change history. This cannot be undone.`;
  if (!confirm(firstConfirm)) return;
  if (!isCamp && !isDayOff && !confirm(`Are you sure? Type OK in your head and click OK to confirm.`)) return;

  // Remove the semester's own entry and nothing else (Phase 1, 1.2). Revert
  // this tab if the write is refused, or the config would be missing a
  // semester the server still has — with no alert and no re-render to show it
  // (Phase 1 review).
  const removed = currentConfig.semesters[key];
  delete currentConfig.semesters[key];
  try {
    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
  } catch (err) {
    currentConfig.semesters[key] = removed;
    console.error('❌ Could not remove the semester:', err);
    alert(`Could not remove "${sem.name}": ${err.message}\n\nNothing was changed.`);
    renderSemesterSelector();
    return;
  }

  // Drop this season's in-memory map either way…
  if (currentLessonData?.[key]) {
    delete currentLessonData[key];
  }
  // …but only a WEEKLY semester has lessons of its own inside
  // curriculum/lessonData to delete. A camp season's lessons live in the
  // shared summerCamps_* collections and are never touched from here.
  if (isDayOff) {
    delete currentDayOffEvents[key]; delete currentDayOffCamps[key]; delete currentDayOffPlans[key]; delete currentDayOffSignoffs[key];
  } else if (!isCamp) {
    try {
      await deleteLessonData(key);
    } catch (e) { console.warn('Could not delete lesson data for', key, e); }
  }

  // Switch to active semester
  caCurrentSemester = currentConfig.activeSemester;
  renderSemesterSelector();
  renderAdminGrid();
  renderHelpQueue();
  renderCutBank();
  renderIdeaBank();
  renderChangeHistory();
}

function switchAdminSemester(key) {
  // Delegates to global semester — CA always stays in sync with the header selector
  setGlobalSemester(key);
}

async function toggleSemesterPublish(key, published) {
  if (!currentConfig?.semesters?.[key]) return;
  if (!isPublishableType(key)) { alert('This semester type can\'t be published.'); return; }
  // SDOC (Phase 2B): publishing shows the year to every teacher on a camp —
  // say so first if some camps have nobody to see them.
  if (published && isDayOffYear(key)) {
    // The camp list below must be real to warn from — never publish on a failed load.

exec
/bin/zsh -lc "sed -n '125,220p' js/app.js; sed -n '200,285p' js/firebase-data.js; sed -n '200,290p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html; sed -n '305,340p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
    renderTvSemesterSelector();
    renderProgressDashboard();
    renderQaActivityPanel();
    updateClassFilter(); // Update class dropdown for new semester
    renderTeacherView();
  } else if (activeTab === 'prep-dashboard') {
    const weekNum = document.getElementById('week-select')?.value || 1;
    loadWeekData(parseInt(weekNum));
  } else if (activeTab === 'curriculum-admin') {
    renderSemesterSelector();
    renderAdminGrid();
    renderHelpQueue();
    renderCutBank();
    renderIdeaBank();
    renderChangeHistory();
  } else if (activeTab === 'settings') {
    loadSettingsForm();
  }
}

// ─── Initialization ─────────────────────────────────

document.addEventListener('DOMContentLoaded', async () => {
  const user = await requireAuth();
  if (!user) return;

  initCurriculumFirestore();
  await loadConfig();
  // A failed config read is fatal to the whole app by design (Phase 1, 1.2) —
  // nothing below can be trusted, and loadLessonData() must not run.
  if (configLoadFailed) return;
  await loadPrepData();

  initGlobalSemesterSelector();

  // Decide how the shared summer collections may be read BEFORE anything reads
  // them (Phase 1, 1.3): a forced-server read of the registry's switch, then a
  // listener — never awaited — so this tab follows the Summer Camp App
  // switching seasons on, and heals if it started offline.
  await loadSeasonRegistryMode();
  watchSeasonRegistry({
    onModeChange: () => { reloadSummerForModeChange(); },
  });

  // Pre-load lesson data on startup so any load failure is detected immediately
  await loadLessonData();
  if (lessonDataLoadedSuccessfully === false) {
    document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
  }

  // Hide Prep Dashboard tab for summer camp semesters (prep is done in Summer Camp App)
  const currentSemester = currentConfig?.semesters?.[globalSemesterKey];
  const prepDashboardTab = document.querySelector('.tab-btn[data-tab="prep-dashboard"]');
  if (prepDashboardTab && currentSemester && !isWeeklySemester(globalSemesterKey)) {
    prepDashboardTab.style.display = 'none';
  }

  setupTabs();
  setupRoleAccess();
  setupFooter();
  loadSettingsForm();

  // Initialize Curriculum Admin (default tab)
  await initCurriculumAdmin();

  // Real-time sync for prep data
  setupPrepDataListener(onPrepDataChange);
});

// ─── Tab Navigation ─────────────────────────────────

let lastDiagFingerprint = null;  // Track which diagnostic item we navigated from

function switchTab(tabId) {
  const btn = document.querySelector(`.tab-btn[data-tab="${tabId}"]`);
  if (btn) btn.click();
}

function setupTabs() {
  document.querySelectorAll('.tab-btn').forEach(btn => {
    btn.addEventListener('click', () => {
      const tabId = btn.dataset.tab;

      document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
      btn.classList.add('active');

      document.querySelectorAll('.panel').forEach(p => p.classList.remove('active'));
      document.getElementById(tabId)?.classList.add('active');

      if (tabId === 'teacher-view') {
        initTeacherView();
      } else if (tabId === 'prep-dashboard') {
        initPrepDashboard();
      } else if (tabId === 'curriculum-admin') {
        initCurriculumAdmin();
      } else if (tabId === 'settings') {
// FieldPath form needs the varargs overload, an easy mistake.
function nestFieldPaths(flat) {
  const nested = {};
  for (const [path, value] of Object.entries(flat)) {
    const parts = path.split('.');
    let node = nested;
    while (parts.length > 1) { const k = parts.shift(); node = node[k] = node[k] || {}; }
    node[parts[0]] = value;
  }
  return nested;
}

async function updateAppData(updates) {
  if (!curriculumDb) initCurriculumFirestore();
  if (configLoadFailed) {
    throw new Error('The app configuration could not be read — refusing to write to it. Reload once the problem is fixed.');
  }
  // "Every writer refuses" includes these ones (Phase 1, 1.3). Publish,
  // delete, create, Settings and the migration all write through here; without
  // this an admin could still change the configuration while the app is behind
  // the banner telling them saving is disabled.
  if (seasonRegistryMode === 'error' || seasonRegistryMode === 'unknown') {
    throw new Error(`Refusing to change the app configuration: the season registry is ${seasonRegistryMode === 'unknown' ? 'unreachable' : 'unreadable or malformed'}. Nothing was changed.`);
  }
  const user = getAuthUser();
  const payload = {
    ...updates,
    lastUpdated: new Date().toISOString(),
    lastUpdatedBy: user?.name || 'Unknown',
  };
  const ref = curriculumDb.collection('curriculum').doc('appData');
  try {
    await ref.update(payload);
  } catch (err) {
    if (err?.code !== 'not-found') throw err;
    // Initialisation only: no appData document exists yet. update() cannot
    // create one, so merge-set the same paths as real nesting.
    await ref.set(nestFieldPaths(payload), { merge: true });
  }
}

// Forced-server read of curriculum/appData — bypasses the SDK cache. Used
// before creating a semester, and by the type migration's dry run/read-back.
async function readAppDataFromServer() {
  if (!curriculumDb) initCurriculumFirestore();
  const doc = await curriculumDb.collection('curriculum').doc('appData').get({ source: 'server' });
  return doc.exists ? doc.data() : null;
}

// Which appData paths a Settings save may write, by the semester's TYPE. A
// camp season's name, dates, weeks, breaks, time slots and studios come from
// the Summer Camp App's registry and are re-synced, never typed here — before
// Phase 1 a Settings save spread the whole form over the semester and could
// put numWeeks: 16, an empty breakWeeks and the hidden default class roster
// onto Summer 2026.
function settingsFieldPathsFor(semKey, values, semesters) {
  const type = (semesters || currentConfig?.semesters)?.[semKey]?.semesterType
    || (semKey === LEGACY_CAMP_SEMESTER_KEY ? SEMESTER_TYPES.camp : SEMESTER_TYPES.weekly);
  const p = (f) => `semesters.${semKey}.${f}`;
  if (type === SEMESTER_TYPES.camp) {
    return { [p('teacherNames')]: values.teacherNames };
  }
  if (type === SEMESTER_TYPES.weekly) {
    return {
      [p('name')]: values.name,
      [p('startDate')]: values.startDate,
      [p('numWeeks')]: values.numWeeks,
      [p('breakWeeks')]: values.breakWeeks,
      [p('closureDates')]: values.closureDates,
      [p('teacherNames')]: values.teacherNames,
      [p('classRoster')]: values.classRoster,
    };
  }
  if (type === SEMESTER_TYPES.dayOff) {
    return {
      [p('name')]: values.name,
      [p('startDate')]: values.startDate,
      [p('endDate')]: values.endDate,
      [p('teacherNames')]: values.teacherNames,
    };
  }
  throw new Error(`Settings does not know which fields a "${type}" semester owns.`);
}

// ─── The season registry decides how summer data is read (Phase 1, 1.3) ─────
// summerCamps_seasons/_current is the Summer Camp App's switch: written LAST
Scenario: a stale tab can't activate a deleted semester (failure, Codex finding 4)
  Given tab A loaded Fall; the Fall entry is then deleted on the server
  When tab A makes Fall active
  Then the transaction refuses, asks for a reload, and appData.activeSemester and semesters are unchanged
   (no semesters.fall-2026 = {published:true} ghost)

Scenario: someone changed "active" meanwhile (failure)
  Given tab A's confirmation showed Spring as active, but the server now says Summer
  When tab A confirms
  Then it refuses and asks for a reload

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
  Then they land on Fall 2026, localStorage.globalSemesterKey = "fall-2026", activeSemesterSwitchSeen = T1
  When they pick Spring 2026 and reload
  Then they stay on Spring 2026

Scenario: the manager who switched is moved too (edge)
  Given the manager made Fall active with the box ticked, then picked Spring
  When they reload
  Then they land on Fall 2026 once

Scenario: an unticked activation clears an old switch (regression, Codex finding 1)
  Given Fall activated ticked (T1), then Summer activated unticked, then Fall activated unticked
  When a browser that never loaded since T1 loads
  Then it is not moved, and appData has no activeSemesterSwitch

Scenario: a shared computer moves each person once (Codex finding 2)
  Given teacher A on a shared browser consumed T1, then picked Spring and signed out
  When teacher B signs in on that browser for the first time since T1
  Then B is moved to Fall; A, signing in again, is not

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
</div>

<h2 id="tests">Tests</h2>
<ul>
  <li>New <code>e2e/active-semester.spec.js</code> (emulator only), following the house pattern (finding 1):
    <ul>
      <li><strong>Payload/shape scenarios</strong> stub <code>window.updateAppData</code> and assert <code>Object.keys(payload).sort()</code> (as <code>data-safety.spec.js:7596-7610</code> does). The in-memory test semester is added to <code>currentConfig</code> in the page only, with an explicit <code>semesterType: 'weekly'</code>.</li>
      <li><strong>Top leak risk:</strong> a leaked <code>activeSemesterSwitch</code> would silently move <em>every</em> later test (their contexts carry no <code>activeSemesterSwitchSeen</code>) to <code>sw.to</code>. The restore below is mandatory and read back, and a final assertion in this spec checks appData has no <code>activeSemesterSwitch</code>.</li>
      <li><strong>One real round-trip</strong> runs in a manager context (<code>MANAGER_STATE_PATH</code>, first spec to use it). The test semester is created and removed through the app's own <code>updateAppData</code> in that page, and <code>activeSemester</code> is restored to <code>spring-2026</code> and <code>activeSemesterSwitch</code> deleted in <code>afterEach</code> <strong>and</strong> <code>afterAll</code>, each read back. Cleanup is self-contained and doesn't rely on file order. With <code>workers: 1</code> this file happens to run first alphabetically, and a leak would break <code>day-off-camps.spec.js</code> "SDOC R6" and <code>day-off-teacher.spec.js</code> "T20", which read the active semester.</li>
      <li><strong>The restore can't run from Node</strong> (the helper is staff, and appData writes are manager-only). <code>afterEach</code>/<code>afterAll</code> open a manager browser context and call the page's own <code>updateAppData</code> (<code>activeSemester: 'spring-2026'</code>, <code>activeSemesterSwitch: FieldValue.delete()</code>, <code>semesters.&lt;test&gt;: FieldValue.delete()</code>), then read back with <code>readAppDataFromServer()</code> (<code>firebase-data.js:243-247</code>).</li>
      <li>The <strong>camp-season scenario runs stubbed</strong>. Its auto-publish would otherwise flip the seed's <code>summer-2026.published: false</code>, which <code>day-off-materials</code> M10 and <code>day-off-camps</code> enumerate.</li>
      <li>Payloads: use the <code>window.updateAppData</code> stub pattern (<code>data-safety.spec.js:3947-3958</code>), whose payload holds only the caller's keys. <code>withAppDataSpy</code> is file-local and adds <code>lastUpdated</code>.</li>
      <li><strong>One real rules refusal</strong> uses the staff account and asserts <code>permission-denied</code> specifically (the seeded season registry is valid, so <code>updateAppData</code>'s own guard won't fire first).</li>
      <li><strong>Phase 2's teacher</strong> is a fresh context (blank storageState) signed in with <code>signInViaForm(page, 'teacher')</code>, because <code>login(page,'teacher')</code> on the default state returns the admin. The remembered <code>globalSemesterKey</code> is set <em>after</em> that first load, followed by a reload, because the app writes it itself on first load and the test would otherwise pass vacuously.</li>
    </ul></li>
  <li>Assertions that must use types, not key prefixes: <code>isWeeklySemester</code> / <code>isCampSeason</code> (the ratchet at <code>static-checks.spec.js:108</code>).</li>
  <li>The full suite stays green. Re-count at execution time; don't trust a number in this plan.</li>
</ul>

<h2 id="completeness">Completeness: what if this is interrupted?</h2>
<ul>
  <li><strong>Mid-code, before deploy:</strong> nothing is live. Resume from the branch.</li>
  <li><strong>The write itself is atomic:</strong> one <code>update()</code>, so the active flag and the auto-publish can't half-happen.</li>
  <li><strong>Phase 1 shipped without Phase 2:</strong> still coherent. The button works and moves nobody. (The plan still deploys both together.)</li>
  <li><strong>After a switch:</strong> browsers pick it up on their next load, whenever that is. There's no deadline and nothing to finish.</li>
</ul>

<h2 id="resume">Resume instructions</h2>
<ol>
  <li>Read this plan. Check the Decisions Log for Christie's answers to Q1/Q2 and any review findings.</li>
  <li>Work in a worktree on branch <code>claude/make-active-semester</code> off <code>origin/main</code>.</li>
  <li>Check line numbers against current main. They were recorded at <code>2ef2e62</code>.</li>
  <li>e2e: <code>npm test -- --grep "active semester"</code>. The emulator ports are fixed, so if another session's suite holds 8180, wait or shift ports locally without committing (see the memory note on classbook worktree deploys).</li>
  <li>Per phase: commit, run the full suite, then a second-model implementation review. Deploy once after both, only after Christie says yes, via <code>NETLIFY_SITE_ID=… npm run deploy</code> from a clean, pushed main.</li>
</ol>


exec
/bin/zsh -lc "sed -n '105,210p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html; sed -n '308,325p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html; rg -n \"MANAGER_STATE_PATH|storageState|signInViaForm|afterEach|afterAll|workers\" e2e/global-setup.js e2e/helpers/*.js playwright.config.* package.json | sed -n '1,300p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:

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

Scenario: archiving an old class semester hides it and deletes nothing (safety)
  Given Spring 2026 is not active and has lessons, cut bank and change history (manager session, real write)
  When the manager clicks Archive on it and confirms
  Then appData.semesters.spring-2026.archived = true and nothing else in appData changed (ignoring lastUpdated/By)
   And curriculum/lessonData, cutProjects, changeLog, prepData for spring-2026 read back byte-identical
   And Spring 2026 is absent from the header, Teacher View, Curriculum Admin, Settings and "Copy from" lists

Scenario: unarchive brings it back (happy path)
  When the manager clicks Unarchive in Settings → Archived semesters
  Then the archived field is removed and Spring 2026 is listed everywhere again with all its lessons

Scenario: a browser that remembered an archived semester (edge)
  Given a teacher's browser remembers spring-2026, which is then archived
  When they load the Classbook
  Then they land on the active semester

Scenario: the active semester can't be archived; an archived one can't be made active (edge)
  Then the active semester shows no Archive, and an archived semester is not listed where "Make active" lives

Scenario: a stale tab keeps saving into an archived semester (edge, harmless)
  Given tab B is open on Spring 2026's lessons when tab A archives it
  When tab B saves a lesson
  Then the save succeeds into existing data, and after Unarchive the change is there

Scenario: a new semester can't reuse an archived key (edge)
  When a manager creates a semester whose key matches an archived one
  Then it refuses and points to Unarchive; nothing is written

Scenario: camp and SDOC deletes are unchanged (regression)
  Then the existing camp-removal and SDOC-year delete tests pass unmodified

Scenario: a stale tab can't activate a deleted semester (failure, Codex finding 4)
  Given tab A loaded Fall; the Fall entry is then deleted on the server
  When tab A makes Fall active
  Then the transaction refuses, asks for a reload, and appData.activeSemester and semesters are unchanged
   (no semesters.fall-2026 = {published:true} ghost)

Scenario: someone changed "active" meanwhile (failure)
  Given tab A's confirmation showed Spring as active, but the server now says Summer
  When tab A confirms
  Then it refuses and asks for a reload

<ul>
  <li>New <code>e2e/active-semester.spec.js</code> (emulator only), following the house pattern (finding 1):
    <ul>
      <li><strong>Payload/shape scenarios</strong> stub <code>window.updateAppData</code> and assert <code>Object.keys(payload).sort()</code> (as <code>data-safety.spec.js:7596-7610</code> does). The in-memory test semester is added to <code>currentConfig</code> in the page only, with an explicit <code>semesterType: 'weekly'</code>.</li>
      <li><strong>Top leak risk:</strong> a leaked <code>activeSemesterSwitch</code> would silently move <em>every</em> later test (their contexts carry no <code>activeSemesterSwitchSeen</code>) to <code>sw.to</code>. The restore below is mandatory and read back, and a final assertion in this spec checks appData has no <code>activeSemesterSwitch</code>.</li>
      <li><strong>One real round-trip</strong> runs in a manager context (<code>MANAGER_STATE_PATH</code>, first spec to use it). The test semester is created and removed through the app's own <code>updateAppData</code> in that page, and <code>activeSemester</code> is restored to <code>spring-2026</code> and <code>activeSemesterSwitch</code> deleted in <code>afterEach</code> <strong>and</strong> <code>afterAll</code>, each read back. Cleanup is self-contained and doesn't rely on file order. With <code>workers: 1</code> this file happens to run first alphabetically, and a leak would break <code>day-off-camps.spec.js</code> "SDOC R6" and <code>day-off-teacher.spec.js</code> "T20", which read the active semester.</li>
      <li><strong>The restore can't run from Node</strong> (the helper is staff, and appData writes are manager-only). <code>afterEach</code>/<code>afterAll</code> open a manager browser context and call the page's own <code>updateAppData</code> (<code>activeSemester: 'spring-2026'</code>, <code>activeSemesterSwitch: FieldValue.delete()</code>, <code>semesters.&lt;test&gt;: FieldValue.delete()</code>), then read back with <code>readAppDataFromServer()</code> (<code>firebase-data.js:243-247</code>).</li>
      <li>The <strong>camp-season scenario runs stubbed</strong>. Its auto-publish would otherwise flip the seed's <code>summer-2026.published: false</code>, which <code>day-off-materials</code> M10 and <code>day-off-camps</code> enumerate.</li>
      <li>Payloads: use the <code>window.updateAppData</code> stub pattern (<code>data-safety.spec.js:3947-3958</code>), whose payload holds only the caller's keys. <code>withAppDataSpy</code> is file-local and adds <code>lastUpdated</code>.</li>
      <li><strong>One real rules refusal</strong> uses the staff account and asserts <code>permission-denied</code> specifically (the seeded season registry is valid, so <code>updateAppData</code>'s own guard won't fire first).</li>
      <li><strong>Phase 2's teacher</strong> is a fresh context (blank storageState) signed in with <code>signInViaForm(page, 'teacher')</code>, because <code>login(page,'teacher')</code> on the default state returns the admin. The remembered <code>globalSemesterKey</code> is set <em>after</em> that first load, followed by a reload, because the app writes it itself on first load and the test would otherwise pass vacuously.</li>
    </ul></li>
  <li>Assertions that must use types, not key prefixes: <code>isWeeklySemester</code> / <code>isCampSeason</code> (the ratchet at <code>static-checks.spec.js:108</code>).</li>
  <li>The full suite stays green. Re-count at execution time; don't trust a number in this plan.</li>
</ul>

<h2 id="completeness">Completeness: what if this is interrupted?</h2>
<ul>
e2e/global-setup.js:16: *    `use.storageState` in playwright.config.js).
e2e/global-setup.js:27:const { signInViaForm, AUTH_STATE_PATH, MANAGER_STATE_PATH } = require('./helpers/login');
e2e/global-setup.js:63:    await signInViaForm(page);
e2e/global-setup.js:64:    await page.context().storageState({ path: AUTH_STATE_PATH, indexedDB: true });
e2e/global-setup.js:68:    await signInViaForm(managerPage, 'manager');
e2e/global-setup.js:69:    await managerPage.context().storageState({ path: MANAGER_STATE_PATH, indexedDB: true });
e2e/global-setup.js:70:    console.log(`[global-setup] manager session saved to ${MANAGER_STATE_PATH}`);
e2e/helpers/firestore.js:228:// sets workers: 1) — none of them namespace or lock by semesterKey, so raising
e2e/helpers/firestore.js:229:// workers later would introduce a real race for tests sharing the same test semester.
e2e/helpers/login.js:31:// admin writes) use it with test.use({ storageState: MANAGER_STATE_PATH }).
e2e/helpers/login.js:32:const MANAGER_STATE_PATH = path.join(__dirname, '..', '.auth', 'manager-state.json');
e2e/helpers/login.js:81:async function signInViaForm(page, role = 'admin') {
e2e/helpers/login.js:113:module.exports = { login, signInViaForm, AUTH_STATE_PATH, MANAGER_STATE_PATH, PRODUCTION_FIREBASE_URL };
playwright.config.js:22:  workers: 1,
playwright.config.js:29:    storageState: 'e2e/.auth/state.json',

exec
/bin/zsh -lc "rg -n \"function getAuthUser|getAuthUser\\s*=|uid:\" js e2e/helpers/login.js | sed -n '1,180p'; sed -n '1,150p' js/auth.js 2>/dev/null || true; sed -n '1,150p' js/firebase-config.js" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
js/app.js:11170:      users.push({ uid: doc.id, name: d.name || d.email || doc.id, email: d.email || '', canUse, note });
js/auth-guard.js:62:              uid: user.uid,
js/auth-guard.js:72:              uid: user.uid,
js/auth-guard.js:91:            uid: user.uid,
js/auth-guard.js:152:function getAuthUser() {
// =====================================================
// Shared Firebase Config — Tinker HQ Apps
// =====================================================
// Copy this file into any app that needs Firebase.
// Load AFTER the Firebase SDK scripts in your HTML.

const FIREBASE_CONFIG = {
  apiKey: "AIzaSyByDujAwE7SkKwML52MBIf5kwQfVbX_86s",
  authDomain: "tinker-hq-apps.firebaseapp.com",
  projectId: "tinker-hq-apps",
  storageBucket: "tinker-hq-apps.firebasestorage.app",
  messagingSenderId: "929945075847",
  appId: "1:929945075847:web:cdcfee87ad9ce402fcb822"
};

// ─── Emulator mode (e2e tests only) ──────────────────
// The Playwright harness serves the app through e2e/emulators/test-server.js,
// which injects `window.__USE_EMULATORS__` ahead of this script:
//   { projectId: 'demo-…', auth: 'http://127.0.0.1:9190',
//     firestore: { host, port }, storage: { host, port } }
// Nothing in the app ever sets it, and the deployed site has no way to —
// so with the flag absent this file behaves exactly as it always has.
// With it present, initFirebaseApp() initialises a `demo-` project (which
// Firebase guarantees has no real backend) and points Auth, Firestore and
// Storage at the local emulators before any other Firebase call is made.
function getEmulatorSettings() {
  const emu = typeof window !== 'undefined' ? window.__USE_EMULATORS__ : null;
  if (!emu) return null;
  if (typeof emu.projectId !== 'string' || !emu.projectId.startsWith('demo-')) {
    // A non-demo project ID here would be the one way emulator mode could
    // touch a real project — refuse rather than fall back to production.
    throw new Error('__USE_EMULATORS__.projectId must start with "demo-" (got "' + emu.projectId + '")');
  }
  return emu;
}

function emulatorFirebaseConfig(emu) {
  return {
    apiKey: 'demo-api-key',
    authDomain: emu.projectId + '.firebaseapp.com',
    projectId: emu.projectId,
    storageBucket: emu.projectId + '.appspot.com',
    appId: 'demo-app-id'
  };
}

function connectFirebaseEmulators(emu) {
  // Auth: disableWarnings also suppresses the SDK's fixed-position banner,
  // which would otherwise sit over the page during click-driven tests.
  firebase.auth().useEmulator(emu.auth, { disableWarnings: true });
  firebase.firestore().useEmulator(emu.firestore.host, emu.firestore.port);
  // Storage compat SDK is only loaded by pages that upload photos.
  if (typeof firebase.storage === 'function') {
    firebase.storage().useEmulator(emu.storage.host, emu.storage.port);
  }
  console.info('🧪 Firebase emulator mode —', emu.projectId);
}

function initFirebaseApp() {
  if (typeof firebase === 'undefined') {
    console.warn('Firebase SDK not loaded');
    return null;
  }
  if (!firebase.apps.length) {
    const emu = getEmulatorSettings();
    firebase.initializeApp(emu ? emulatorFirebaseConfig(emu) : FIREBASE_CONFIG);
    if (emu) connectFirebaseEmulators(emu);
  }
  return firebase.firestore();
}

exec
/bin/zsh -lc "sed -n '45,110p' js/auth-guard.js; sed -n '145,165p' js/auth-guard.js; git status --short; git rev-parse HEAD; sed -n '630,680p' /Users/christiehubley/studio-hub/firestore.rules" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:

      // If app already initialized with a different user, reload to re-init cleanly
      if (user && authResolvedUid && user.uid !== authResolvedUid) {
        window.location.reload();
        return;
      }

      if (user) {
        // Fetch user role from Firestore
        try {
          const db = firebase.firestore();
          const userDocRef = db.collection('users').doc(user.uid);
          const userDoc = await userDocRef.get();

          if (userDoc.exists) {
            // User doc exists - use it
            authCurrentUser = {
              uid: user.uid,
              email: user.email,
              name: user.displayName || user.email.split('@')[0],
              role: 'staff',
              studios: ['tinker', 'clayhub'],
              ...userDoc.data()
            };
          } else {
            // User doc doesn't exist - create it
            const newUserData = {
              uid: user.uid,
              email: user.email,
              name: user.displayName || user.email.split('@')[0],
              role: 'staff',
              studios: ['tinker', 'clayhub'],
              appAccess: [],
              createdAt: firebase.firestore.FieldValue.serverTimestamp(),
              updatedAt: firebase.firestore.FieldValue.serverTimestamp()
            };

            // Create the doc
            await userDocRef.set(newUserData);
            console.log('✅ Created Firestore user doc for:', user.email);

            authCurrentUser = newUserData;
          }
        } catch (err) {
          console.error('Error fetching/creating user data:', err);
          authCurrentUser = {
            uid: user.uid,
            email: user.email,
            name: user.displayName || 'User',
            role: 'staff',
            studios: ['tinker', 'clayhub']
          };
        }

        // Hide guard, show app
        if (guard) guard.style.display = 'none';
        authResolvedUid = user.uid;
        resolve(authCurrentUser);
      } else {
        // Show guard — don't resolve yet, wait for sign-in
        if (guard) {
          guard.style.display = 'flex';
          setupAuthForm();
        }
      }
    });
        'auth/too-many-requests': 'Too many attempts. Try again later.'
      };
      errorEl.textContent = messages[err.code] || 'Sign in failed. Please try again.';
    }
  });
}

function getAuthUser() {
  return authCurrentUser;
}

function authSignOut() {
  return firebase.auth().signOut();
}
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-Vhdfz0Bn' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-llVsIc4Q' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-UX1HPlkG' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-7AJjc4XH' (errno=Operation not permitted)
2ef2e629cac2d6e8e7ae8ff702a3de3a67e755ca
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
      // Manager+: full access to everything including appData
      allow read, write: if isManagerOrAbove();

      // classbook-admin, curriculum-admin (legacy key), and classbook: full read/write except appData and prepCycleConfig
      // appData (Settings) is manager+ only, always
      // prepCycleConfig (Prep Cycle workflow config) is classbook-admin only
      // NOTE: 'classbook' (plain teacher) access is intentionally NOT
      // isolated per-teacher here — each semester's lessons live in one
      // shared doc, and per-field isolation is enforced by the UI, not
      // by these rules. This is a known, accepted gap (see
      // firebase-agent-defense-hardening.md) pending a possible future
      // data-model change, not something this rule can close on its own.
      allow read: if hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook');
      allow create, update: if
        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook'))
        && docId != 'appData'
        && docId != 'prepCycleConfig';
      // Whole-document delete is classbook-admin/curriculum-admin only.
      // Plain 'classbook' (teacher) access never calls a full-document
      // delete in the app (only FieldValue.delete() on specific lesson
      // fields, which is an update, not a delete) — so this closes an
      // unused, high-blast-radius capability with no functional change.
      allow delete: if
        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin'))
        && docId != 'appData'
        && docId != 'prepCycleConfig';
      // prepCycleConfig: classbook-admin and curriculum-admin write only
      allow create, update, delete: if

exec
/bin/zsh -lc 'for f in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex*.md; do echo "=== $(basename "$f") ==="; rg -n "''^#|Verdict|NOT|EXECUTION|Minimum|Finding|Resolved|reopened|block" "$f"; done' in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
=== 2026-09-29-plan-review-make-active-semester-codex-input.md ===
1:## Independent review — plan under review
9:4. Verdict: EXECUTION-READY or NOT, with the minimum list of changes.
=== 2026-09-29-plan-review-make-active-semester-codex-r2-input.md ===
1:## Codex confirmation round — plan under review
5:For each of your five findings and the tab-click-handler item: RESOLVED / NOT RESOLVED, citing plan lines. Then check what revision 4 newly introduced, against the code:
9:Verdict: EXECUTION-READY or NOT, minimum list. Be brief. Do not edit files or run tests.
=== 2026-09-29-plan-review-make-active-semester-codex-r2.md ===
14:## Codex confirmation round — plan under review
18:For each of your five findings and the tab-click-handler item: RESOLVED / NOT RESOLVED, citing plan lines. Then check what revision 4 newly introduced, against the code:
22:Verdict: EXECUTION-READY or NOT, minimum list. Be brief. Do not edit files or run tests.
43:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:109:    The old two-write path and its warn-only catch are removed for weekly semesters. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
83:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:342:  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
101:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:124:  <li><code>deleteSemester</code>, weekly branch only: the count comes from <code>readServerSemesterLessonMap(key)</code> (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
145:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:432:One round-2 aside is **NOT NAMED**: "a `curriculum-admin`/`prep` user with nothing remembered now lands with the Curriculum Admin tab hidden" is only implicit in plan:123 ("render as they do when Summer is merely selected"). Cosmetic.
149:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:475:    95	  <li><code>deleteSemester</code>, weekly branch only: the count comes from <code>readServerSemesterLessonMap(key)</code> (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
382:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4026:    56	  <p><strong>Concrete failure:</strong> Admin A pastes idea X from the bank (a plain <code>.set()</code> of the post-removal array, same as every other writer here — NOT an atomic <code>arrayRemove()</code>, see the correction above). Admin B, in a separate tab with a snapshot loaded before A's removal propagated, archives, edits, deletes, or adds a <em>different</em> idea moments later — B's full-array overwrite silently resurrects X. <code>deleteIdeaProject()</code> is the direct sibling of the companion plan's already-fixed <code>deleteCutProject()</code> — same shape, same likely fix (<code>FieldValue.arrayRemove()</code>) — and <code>pasteFromIdeaBank()</code>'s own removal step is now effectively a second instance of that exact same sibling shape. <code>saveNewIdea()</code>/<code>saveIdeaEdit()</code> would need care: an "edit" mutates an existing array element in place, so the fix isn't a simple append/remove — it likely needs the element's stable identity (an id field, if one exists — check <code>app.js:5317</code>'s id-generation convention, already referenced elsewhere in the companion plan) to target a transaction or a keyed sub-collection instead of an in-array edit, since Firestore's array transforms can't update one element by identity — only add or remove whole elements.</p>
585:./e2e/data-safety.spec.js:1708:// real backupStatus/latest doc (see the Phase 5: 4B block above for why).
601:./e2e/data-safety.spec.js:2978:      expect(nonSummerDoc).toBeNull(); // must NOT have landed in curriculum/lessonData under a 'summer-2026' key
604:./e2e/data-safety.spec.js:3134:      expect(nonSummerDoc).toBeNull(); // must NOT have landed in curriculum/lessonData under a 'summer-2026' key
656:./e2e/data-safety.spec.js:7173:        // block only — never swap currentConfig itself (appData is written from it).
666:./e2e/data-safety.spec.js:7564:  // Replaces curriculum/appData's document ref with a spy for one block.
762:./CLASSBOOK-DATA-SAFETY-PLAN.md:507:**What to change**: After `loadSummerCampData()` returns, if `lessonDataLoadedSuccessfully` is false, render a blocking error banner instead of the normal view:
765:./CLASSBOOK-DATA-SAFETY-PLAN.md:524:**Verify**: In browser devtools, block the `summerCamps_lessonData` network request. Confirm banner appears and Save button is disabled.
782:./CLASSBOOK-DATA-SAFETY-PLAN.md:852:| `~/Library/LaunchAgents/com.tinkerhq.classbook-backup.plist` | Backup cron config. `StartInterval: 1800` = every 30 min. Do NOT change to 86400 until summer camp ends |
896:./js/firebase-data.js:1472:// vulnerable to (does NOT independently verify the given lessonData reflects
1190:    22	4. Verdict: EXECUTION-READY or NOT, with the minimum list of changes.
1220:    52	  .status-tag { display: inline-block; font-size: .75rem; font-weight: 700; padding: .15rem .5rem; border-radius: 999px; }
1234:    66	  <strong>Status:</strong> <span class="status-tag ready">execution-ready: true</span>. Christie answered Q1/Q2. Reviewed in three rounds; round 3 verdict: EXECUTION-READY. Waiting for Christie's go-ahead to build.
1257:    89	  <tr><td><strong>Making a weekly semester non-active arms its Delete.</strong> Curriculum Admin's bar (manager/admin only) shows Delete for every non-active semester. For a weekly one, <code>deleteSemester</code> removes the appData entry (manager-only), then <code>deleteLessonData(key)</code> removes that semester's whole lesson map, behind two generic confirms. Since the Sep 29 console switch this is already true of Spring 2026 in production. (Finding 3; confirmed.)</td><td><code>app.js:4481-4483, 4522, 4527-4590</code>; <code>firebase-data.js:961-966</code></td></tr>
1258:    90	  <tr><td>The header selector's <code>change</code> listener is attached on every <code>initGlobalSemesterSelector()</code> call, with no attach-once guard (the Teacher View selector has one). It's already re-called after creating a semester. (Finding 7; confirmed.)</td><td><code>app.js:86</code>, <code>:825</code>, <code>:4724, 4845</code></td></tr>
1292:   124	  <li><code>deleteSemester</code>, weekly branch only: the count comes from <code>readServerSemesterLessonMap(key)</code> (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
1395:   227	<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
1448:   109	    The old two-write path and its warn-only catch are removed for weekly semesters. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
1473:   233	<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
1535:   342	  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
1548:   355	  <strong>Sep 29, 2026: round 3 (confirmation) — EXECUTION-READY</strong> (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md</code>). All round-2 blockers were confirmed resolved. Its four clarifications are folded in: hide only <code>.footer-dot.write-control</code>; <code>readServerSemesterLessonMap</code> returning <code>null</code> means 0 lessons, not a failure; the three delete tests must split their <code>page.evaluate</code> to drive the modal; the activation uses <code>confirmModal</code> from Phase 1. Also named: a curriculum-admin/prep user with nothing remembered lands with Curriculum Admin hidden when Summer is active. All phases are marked execution-ready. Execution waits for Christie's go-ahead. Codex didn't review this plan (out of credits); all three rounds were Claude.
1551:/bin/zsh -lc 'rg -n "''^##|''^###|Finding|EXECUTION|NOT RESOLVED|Minimum|unticked|per-browser|snapshot|ghost|teacher test|tab" /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md | tail -n 100; tail -n 180 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md' in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
1568:2256:A new blocker has emerged in Phase 2: leaving the prior switch record untouched when the checkbox is unticked can later reactivate an old “switch everyone” instruction. I’m tracing that alongside the destructive weekly-delete sequence and the test restore mechanics before giving the verdict.
1612:4026:    56	  <p><strong>Concrete failure:</strong> Admin A pastes idea X from the bank (a plain <code>.set()</code> of the post-removal array, same as every other writer here — NOT an atomic <code>arrayRemove()</code>, see the correction above). Admin B, in a separate tab with a snapshot loaded before A's removal propagated, archives, edits, deletes, or adds a <em>different</em> idea moments later — B's full-array overwrite silently resurrects X. <code>deleteIdeaProject()</code> is the direct sibling of the companion plan's already-fixed <code>deleteCutProject()</code> — same shape, same likely fix (<code>FieldValue.arrayRemove()</code>) — and <code>pasteFromIdeaBank()</code>'s own removal step is now effectively a second instance of that exact same sibling shape. <code>saveNewIdea()</code>/<code>saveIdeaEdit()</code> would need care: an "edit" mutates an existing array element in place, so the fix isn't a simple append/remove — it likely needs the element's stable identity (an id field, if one exists — check <code>app.js:5317</code>'s id-generation convention, already referenced elsewhere in the companion plan) to target a transaction or a keyed sub-collection instead of an in-array edit, since Firestore's array transforms can't update one element by identity — only add or remove whole elements.</p>
1629:4225:## Verdict: NOT EXECUTION-READY
1641:4317:## Verdict: NOT EXECUTION-READY
1655:### 1. Unticking “switch everyone” can reactivate an old switch
1670:### 2. “Once per browser” does not mean “switch every user”
1684:### 3. Weekly deletion remains non-atomic and lacks the required snapshot
1705:### 4. Activation trusts stale local config and can create a ghost active semester
1720:### 5. The e2e plan contains two impossible/contradictory scenarios
1735:### Other checks
1743:## Verdict: NOT EXECUTION-READY
1747:### 1. Unticking “switch everyone” can reactivate an old switch
1762:### 2. “Once per browser” does not mean “switch every user”
1776:### 3. Weekly deletion remains non-atomic and lacks the required snapshot
1797:### 4. Activation trusts stale local config and can create a ghost active semester
1812:### 5. The e2e plan contains two impossible/contradictory scenarios
1827:### Other checks
1876:   659	      // NOTE: 'classbook' (plain teacher) access is intentionally NOT
1990:   941	      block: lesson.block,
2004:   955	      status: isAdmin ? 'Resolved' : 'Open',
2042:  2427	  // "changed" just because the editor now speaks blocks.
2048:  2433	  // that occupies exactly the same day/block cells. Unpaired leaving titles
2354:    29	let authResolvedUid = null;  // Track which UID the app initialized with
2372:    47	      if (user && authResolvedUid && user.uid !== authResolvedUid) {
2426:   101	        authResolvedUid = user.uid;
2756:   839	  // Resolved once, before any batch work — a semester with no valid season
3009:  1390	    // attempt — only block when there's neither real content nor an explicit
3016:  1397	      console.warn('⛔ saveSingleLesson blocked — all content fields empty, refusing to overwrite:', lessonKey);
3091:  1472	// vulnerable to (does NOT independently verify the given lessonData reflects
3144:   679	    // SDOC (Phase 2B): a camp with only empty blocks has no slots, and there is
3801:   109	    The old two-write path and its warn-only catch are removed for weekly semesters. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
3950:   342	  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
3963:   355	  <strong>Sep 29, 2026: round 3 (confirmation) — EXECUTION-READY</strong> (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md</code>). All round-2 blockers were confirmed resolved. Its four clarifications are folded in: hide only <code>.footer-dot.write-control</code>; <code>readServerSemesterLessonMap</code> returning <code>null</code> means 0 lessons, not a failure; the three delete tests must split their <code>page.evaluate</code> to drive the modal; the activation uses <code>confirmModal</code> from Phase 1. Also named: a curriculum-admin/prep user with nothing remembered lands with Curriculum Admin hidden when Summer is active. All phases are marked execution-ready. Execution waits for Christie's go-ahead. Codex didn't review this plan (out of credits); all three rounds were Claude.
3966:   358	  <strong>Sep 29, 2026: revision 3, after round-2 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r2-claude.md</code>).</strong> Round 2 found the write shape safe and listed five blockers, all verified and taken:
4047:   233	<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
4077:Verdict: **NOT EXECUTION-READY**
4079:### Prior findings
4085:3. **NOT RESOLVED** — atomicity is proposed, but the snapshot and concurrency design remain incomplete: lines [102–109](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:102>) and [184–192](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:184>).
4093:### Revision 4 checks
4101:Minimum changes:
4109:Verdict: **NOT EXECUTION-READY**
4111:### Prior findings
4117:3. **NOT RESOLVED** — atomicity is proposed, but the snapshot and concurrency design remain incomplete: lines [102–109](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:102>) and [184–192](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:184>).
4125:### Revision 4 checks
4133:Minimum changes:
=== 2026-09-29-plan-review-make-active-semester-codex-r3-input.md ===
1:## Codex confirmation round 3 — narrow
3:Check only your two round-2 minimum changes (snapshot contents; delete coordinating with lessonData incl. stale-tab behaviour) against the code: RESOLVED / NOT RESOLVED with plan-line citations, and whether revision 5 introduced anything wrong. One-line verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
=== 2026-09-29-plan-review-make-active-semester-codex-r3.md ===
14:## Codex confirmation round 3 — narrow
16:Check only your two round-2 minimum changes (snapshot contents; delete coordinating with lessonData incl. stale-tab behaviour) against the code: RESOLVED / NOT RESOLVED with plan-line citations, and whether revision 5 introduced anything wrong. One-line verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
44:  .status-tag { display: inline-block; font-size: .75rem; font-weight: 700; padding: .15rem .5rem; border-radius: 999px; }
58:  <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Christie answered Q1/Q2. Three Claude rounds, then Codex's independent review: NOT ready (5 findings). Revisions 4–5 address them; Codex confirmation round 3 is next.
81:  <tr><td><strong>Making a weekly semester non-active arms its Delete.</strong> Curriculum Admin's bar (manager/admin only) shows Delete for every non-active semester. For a weekly one, <code>deleteSemester</code> removes the appData entry (manager-only), then <code>deleteLessonData(key)</code> removes that semester's whole lesson map, behind two generic confirms. Since the Sep 29 console switch this is already true of Spring 2026 in production. (Finding 3; confirmed.)</td><td><code>app.js:4481-4483, 4522, 4527-4590</code>; <code>firebase-data.js:961-966</code></td></tr>
82:  <tr><td>The header selector's <code>change</code> listener is attached on every <code>initGlobalSemesterSelector()</code> call, with no attach-once guard (the Teacher View selector has one). It's already re-called after creating a semester. (Finding 7; confirmed.)</td><td><code>app.js:86</code>, <code>:825</code>, <code>:4724, 4845</code></td></tr>
130:    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs (accepted, defined):</strong> a lesson editor left open on the deleted semester can still save per-field paths into <code>lessonData.&lt;key&gt;</code> afterwards (<code>firebase-data.js:1429-1437</code>). That recreates an orphan fragment with no appData entry, so it's invisible in the app and loses nothing. If the key is ever reused, <code>createNewSemester</code>'s existing server pre-check (<code>app.js:4913-4916</code>) detects the leftover content and says so. Blocking it outright would mean a server read before every lesson save, which this plan doesn't take on. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
265:<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
295:## Codex confirmation round — plan under review
299:For each of your five findings and the tab-click-handler item: RESOLVED / NOT RESOLVED, citing plan lines. Then check what revision 4 newly introduced, against the code:
303:Verdict: EXECUTION-READY or NOT, minimum list. Be brief. Do not edit files or run tests.
324:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:109:    The old two-write path and its warn-only catch are removed for weekly semesters. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
364:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:342:  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
382:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:124:  <li><code>deleteSemester</code>, weekly branch only: the count comes from <code>readServerSemesterLessonMap(key)</code> (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
426:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:432:One round-2 aside is **NOT NAMED**: "a `curriculum-admin`/`prep` user with nothing remembered now lands with the Curriculum Admin tab hidden" is only implicit in plan:123 ("render as they do when Summer is merely selected"). Cosmetic.
430:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:475:    95	  <li><code>deleteSemester</code>, weekly branch only: the count comes from <code>readServerSemesterLessonMap(key)</code> (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
534:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:109:    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs (accepted, defined):</strong> a lesson editor left open on the deleted semester can still save per-field paths into <code>lessonData.&lt;key&gt;</code> afterwards (<code>firebase-data.js:1429-1437</code>). That recreates an orphan fragment with no appData entry, so it's invisible in the app and loses nothing. If the key is ever reused, <code>createNewSemester</code>'s existing server pre-check (<code>app.js:4913-4916</code>) detects the leftover content and says so. Blocking it outright would mean a server read before every lesson save, which this plan doesn't take on. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
606:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:353:  <strong>Sep 29, 2026: revision 5, after Codex confirmation round 2 (<code>…-codex-r2.md</code>).</strong> Findings 1, 2, 4, 5 and the tab-handler item are confirmed resolved. Finding 3 had two gaps, both taken. (a) The snapshot also includes <code>prepData</code>, <code>lessonData_backup</code> and <code>diagnosticDismissals</code> for the key. (b) The delete transaction re-reads lessonData and refuses unless the semester's lessons deep-equal the downloaded snapshot. Retries from other semesters' saves are accepted. Stale-tab re-saves after a delete are defined as an accepted, invisible orphan that the existing <code>createNewSemester</code> pre-check catches, with a test.
609:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-356-  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
622:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-369-  <strong>Sep 29, 2026: round 3 (confirmation) — EXECUTION-READY</strong> (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md</code>). All round-2 blockers were confirmed resolved. Its four clarifications are folded in: hide only <code>.footer-dot.write-control</code>; <code>readServerSemesterLessonMap</code> returning <code>null</code> means 0 lessons, not a failure; the three delete tests must split their <code>page.evaluate</code> to drive the modal; the activation uses <code>confirmModal</code> from Phase 1. Also named: a curriculum-admin/prep user with nothing remembered lands with Curriculum Admin hidden when Summer is active. All phases are marked execution-ready. Execution waits for Christie's go-ahead. Codex didn't review this plan (out of credits); all three rounds were Claude.
625:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-372-  <strong>Sep 29, 2026: revision 3, after round-2 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r2-claude.md</code>).</strong> Round 2 found the write shape safe and listed five blockers, all verified and taken:
651:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-18-For each of your five findings and the tab-click-handler item: RESOLVED / NOT RESOLVED, citing plan lines. Then check what revision 4 newly introduced, against the code:
655:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:22:Verdict: EXECUTION-READY or NOT, minimum list. Be brief. Do not edit files or run tests.
676:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-43-/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:109:    The old two-write path and its warn-only catch are removed for weekly semesters. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
715:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-83-/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:342:  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
830:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:382:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4026:    56	  <p><strong>Concrete failure:</strong> Admin A pastes idea X from the bank (a plain <code>.set()</code> of the post-removal array, same as every other writer here — NOT an atomic <code>arrayRemove()</code>, see the correction above). Admin B, in a separate tab with a snapshot loaded before A's removal propagated, archives, edits, deletes, or adds a <em>different</em> idea moments later — B's full-array overwrite silently resurrects X. <code>deleteIdeaProject()</code> is the direct sibling of the companion plan's already-fixed <code>deleteCutProject()</code> — same shape, same likely fix (<code>FieldValue.arrayRemove()</code>) — and <code>pasteFromIdeaBank()</code>'s own removal step is now effectively a second instance of that exact same sibling shape. <code>saveNewIdea()</code>/<code>saveIdeaEdit()</code> would need care: an "edit" mutates an existing array element in place, so the fix isn't a simple append/remove — it likely needs the element's stable identity (an id field, if one exists — check <code>app.js:5317</code>'s id-generation convention, already referenced elsewhere in the companion plan) to target a transaction or a keyed sub-collection instead of an in-array edit, since Firestore's array transforms can't update one element by identity — only add or remove whole elements.</p>
1030:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-585-./e2e/data-safety.spec.js:1708:// real backupStatus/latest doc (see the Phase 5: 4B block above for why).
1046:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:601:./e2e/data-safety.spec.js:2978:      expect(nonSummerDoc).toBeNull(); // must NOT have landed in curriculum/lessonData under a 'summer-2026' key
1049:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:604:./e2e/data-safety.spec.js:3134:      expect(nonSummerDoc).toBeNull(); // must NOT have landed in curriculum/lessonData under a 'summer-2026' key
1101:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-656-./e2e/data-safety.spec.js:7173:        // block only — never swap currentConfig itself (appData is written from it).
1111:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-666-./e2e/data-safety.spec.js:7564:  // Replaces curriculum/appData's document ref with a spy for one block.
1206:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:762:./CLASSBOOK-DATA-SAFETY-PLAN.md:507:**What to change**: After `loadSummerCampData()` returns, if `lessonDataLoadedSuccessfully` is false, render a blocking error banner instead of the normal view:
1209:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:765:./CLASSBOOK-DATA-SAFETY-PLAN.md:524:**Verify**: In browser devtools, block the `summerCamps_lessonData` network request. Confirm banner appears and Save button is disabled.
1226:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-782-./CLASSBOOK-DATA-SAFETY-PLAN.md:852:| `~/Library/LaunchAgents/com.tinkerhq.classbook-backup.plist` | Backup cron config. `StartInterval: 1800` = every 30 min. Do NOT change to 86400 until summer camp ends |
1340:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:896:./js/firebase-data.js:1472:// vulnerable to (does NOT independently verify the given lessonData reflects
1558:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1190:    22	4. Verdict: EXECUTION-READY or NOT, with the minimum list of changes.
1596:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1448-   109	    The old two-write path and its warn-only catch are removed for weekly semesters. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
1626:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1535-   342	  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
1639:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1548-   355	  <strong>Sep 29, 2026: round 3 (confirmation) — EXECUTION-READY</strong> (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md</code>). All round-2 blockers were confirmed resolved. Its four clarifications are folded in: hide only <code>.footer-dot.write-control</code>; <code>readServerSemesterLessonMap</code> returning <code>null</code> means 0 lessons, not a failure; the three delete tests must split their <code>page.evaluate</code> to drive the modal; the activation uses <code>confirmModal</code> from Phase 1. Also named: a curriculum-admin/prep user with nothing remembered lands with Curriculum Admin hidden when Summer is active. All phases are marked execution-ready. Execution waits for Christie's go-ahead. Codex didn't review this plan (out of credits); all three rounds were Claude.
1642:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1551:/bin/zsh -lc 'rg -n "''^##|''^###|Finding|EXECUTION|NOT RESOLVED|Minimum|unticked|per-browser|snapshot|ghost|teacher test|tab" /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md | tail -n 100; tail -n 180 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md' in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
1656:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1568-2256:A new blocker has emerged in Phase 2: leaving the prior switch record untouched when the checkbox is unticked can later reactivate an old “switch everyone” instruction. I’m tracing that alongside the destructive weekly-delete sequence and the test restore mechanics before giving the verdict.
1686:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:1612:4026:    56	  <p><strong>Concrete failure:</strong> Admin A pastes idea X from the bank (a plain <code>.set()</code> of the post-removal array, same as every other writer here — NOT an atomic <code>arrayRemove()</code>, see the correction above). Admin B, in a separate tab with a snapshot loaded before A's removal propagated, archives, edits, deletes, or adds a <em>different</em> idea moments later — B's full-array overwrite silently resurrects X. <code>deleteIdeaProject()</code> is the direct sibling of the companion plan's already-fixed <code>deleteCutProject()</code> — same shape, same likely fix (<code>FieldValue.arrayRemove()</code>) — and <code>pasteFromIdeaBank()</code>'s own removal step is now effectively a second instance of that exact same sibling shape. <code>saveNewIdea()</code>/<code>saveIdeaEdit()</code> would need care: an "edit" mutates an existing array element in place, so the fix isn't a simple append/remove — it likely needs the element's stable identity (an id field, if one exists — check <code>app.js:5317</code>'s id-generation convention, already referenced elsewhere in the companion plan) to target a transaction or a keyed sub-collection instead of an in-array edit, since Firestore's array transforms can't update one element by identity — only add or remove whole elements.</p>
1703:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1629-4225:## Verdict: NOT EXECUTION-READY
1715:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-1641-4317:## Verdict: NOT EXECUTION-READY
1802:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2004-   955	      status: isAdmin ? 'Resolved' : 'Open',
1840:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-2042-  2427	  // "changed" just because the editor now speaks blocks.
2106:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3009-  1390	    // attempt — only block when there's neither real content nor an explicit
2113:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3016-  1397	      console.warn('⛔ saveSingleLesson blocked — all content fields empty, refusing to overwrite:', lessonKey);
2188:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:3091:  1472	// vulnerable to (does NOT independently verify the given lessonData reflects
2348:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3801-   109	    The old two-write path and its warn-only catch are removed for weekly semesters. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
2385:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3950-   342	  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
2398:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3963-   355	  <strong>Sep 29, 2026: round 3 (confirmation) — EXECUTION-READY</strong> (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md</code>). All round-2 blockers were confirmed resolved. Its four clarifications are folded in: hide only <code>.footer-dot.write-control</code>; <code>readServerSemesterLessonMap</code> returning <code>null</code> means 0 lessons, not a failure; the three delete tests must split their <code>page.evaluate</code> to drive the modal; the activation uses <code>confirmModal</code> from Phase 1. Also named: a curriculum-admin/prep user with nothing remembered lands with Curriculum Admin hidden when Summer is active. All phases are marked execution-ready. Execution waits for Christie's go-ahead. Codex didn't review this plan (out of credits); all three rounds were Claude.
2401:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-3966-   358	  <strong>Sep 29, 2026: revision 3, after round-2 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r2-claude.md</code>).</strong> Round 2 found the write shape safe and listed five blockers, all verified and taken:
2420:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-4077-Verdict: **NOT EXECUTION-READY**
2428:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:4085:3. **NOT RESOLVED** — atomicity is proposed, but the snapshot and concurrency design remain incomplete: lines [102–109](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:102>) and [184–192](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:184>).
2444:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-4101-Minimum changes:
2452:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-4109-Verdict: **NOT EXECUTION-READY**
2460:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:4117:3. **NOT RESOLVED** — atomicity is proposed, but the snapshot and concurrency design remain incomplete: lines [102–109](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:102>) and [184–192](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:184>).
2476:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md-4133-Minimum changes:
2504:   353	  <strong>Sep 29, 2026: revision 5, after Codex confirmation round 2 (<code>…-codex-r2.md</code>).</strong> Findings 1, 2, 4, 5 and the tab-handler item are confirmed resolved. Finding 3 had two gaps, both taken. (a) The snapshot also includes <code>prepData</code>, <code>lessonData_backup</code> and <code>diagnosticDismissals</code> for the key. (b) The delete transaction re-reads lessonData and refuses unless the semester's lessons deep-equal the downloaded snapshot. Retries from other semesters' saves are accepted. Stale-tab re-saves after a delete are defined as an accepted, invisible orphan that the existing <code>createNewSemester</code> pre-check catches, with a test.
2507:   356	  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
2520:   369	  <strong>Sep 29, 2026: round 3 (confirmation) — EXECUTION-READY</strong> (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md</code>). All round-2 blockers were confirmed resolved. Its four clarifications are folded in: hide only <code>.footer-dot.write-control</code>; <code>readServerSemesterLessonMap</code> returning <code>null</code> means 0 lessons, not a failure; the three delete tests must split their <code>page.evaluate</code> to drive the modal; the activation uses <code>confirmModal</code> from Phase 1. Also named: a curriculum-admin/prep user with nothing remembered lands with Curriculum Admin hidden when Summer is active. All phases are marked execution-ready. Execution waits for Christie's go-ahead. Codex didn't review this plan (out of credits); all three rounds were Claude.
2523:   372	  <strong>Sep 29, 2026: revision 3, after round-2 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r2-claude.md</code>).</strong> Round 2 found the write shape safe and listed five blockers, all verified and taken:
2613:   955	      status: isAdmin ? 'Resolved' : 'Open',
2865:  4911	      // failure). The no-copy path is deliberately NOT gated: it writes no
2930:- **Deletion coordination/stale tabs — NOT RESOLVED.** The transaction now reads and validates `lessonData` correctly ([107](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:107), [189–192](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:189)), but revision 5 explicitly accepts stale tabs recreating orphan data instead of preventing it ([109](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:109), [194–198](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:194)). It also wrongly says the existing creation pre-check always catches that fragment: the code deliberately performs that check only when “Copy from” is selected; no-copy creation adopts the orphan ([app.js:4911](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4911)).
2932:**NOT EXECUTION-READY — minimum:** prevent stale post-delete lesson saves, or explicitly change the round-2 safety requirement and accurately specify/test both copy and no-copy key reuse; update line 89’s snapshot list.
2937:- **Deletion coordination/stale tabs — NOT RESOLVED.** The transaction now reads and validates `lessonData` correctly ([107](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:107), [189–192](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:189)), but revision 5 explicitly accepts stale tabs recreating orphan data instead of preventing it ([109](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:109), [194–198](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:194)). It also wrongly says the existing creation pre-check always catches that fragment: the code deliberately performs that check only when “Copy from” is selected; no-copy creation adopts the orphan ([app.js:4911](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4911)).
2939:**NOT EXECUTION-READY — minimum:** prevent stale post-delete lesson saves, or explicitly change the round-2 safety requirement and accurately specify/test both copy and no-copy key reuse; update line 89’s snapshot list.
=== 2026-09-29-plan-review-make-active-semester-codex-r4-input.md ===
1:## Codex confirmation round 4 — narrow
3:Check only: (1) your round-3 minimum (stale post-delete saves prevented; copy and no-copy key reuse specified/tested; acceptance snapshot list) — RESOLVED / NOT with plan-line citations; (2) whether the new appData listener + assertSemesterStillExists design is sound against the code: every doc('lessonData') writer covered? any risk the listener changes existing behaviour (currentConfig untouched)? first-snapshot timing (a save before the first snapshot arrives)? offline/cache snapshots? (3) One-line verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
=== 2026-09-29-plan-review-make-active-semester-codex-r4.md ===
14:## Codex confirmation round 4 — narrow
16:Check only: (1) your round-3 minimum (stale post-delete saves prevented; copy and no-copy key reuse specified/tested; acceptance snapshot list) — RESOLVED / NOT with plan-line citations; (2) whether the new appData listener + assertSemesterStillExists design is sound against the code: every doc('lessonData') writer covered? any risk the listener changes existing behaviour (currentConfig untouched)? first-snapshot timing (a save before the first snapshot arrives)? offline/cache snapshots? (3) One-line verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
44:  .status-tag { display: inline-block; font-size: .75rem; font-weight: 700; padding: .15rem .5rem; border-radius: 999px; }
58:  <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Christie answered Q1/Q2. Three Claude rounds, then Codex's independent review: NOT ready (5 findings). Revisions 4–6 address them; Codex confirmation round 4 is next.
81:  <tr><td><strong>Making a weekly semester non-active arms its Delete.</strong> Curriculum Admin's bar (manager/admin only) shows Delete for every non-active semester. For a weekly one, <code>deleteSemester</code> removes the appData entry (manager-only), then <code>deleteLessonData(key)</code> removes that semester's whole lesson map, behind two generic confirms. Since the Sep 29 console switch this is already true of Spring 2026 in production. (Finding 3; confirmed.)</td><td><code>app.js:4481-4483, 4522, 4527-4590</code>; <code>firebase-data.js:961-966</code></td></tr>
82:  <tr><td>The header selector's <code>change</code> listener is attached on every <code>initGlobalSemesterSelector()</code> call, with no attach-once guard (the Teacher View selector has one). It's already re-called after creating a semester. (Finding 7; confirmed.)</td><td><code>app.js:86</code>, <code>:825</code>, <code>:4724, 4845</code></td></tr>
131:    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs are prevented, not accepted</strong> (Codex round 3). A new, narrow <code>onSnapshot</code> on <code>curriculum/appData</code> keeps only a set <code>serverSemesterKeys</code>, and deliberately does <em>not</em> replace <code>currentConfig</code>, so no other behaviour changes. Every writer to <code>curriculum/lessonData</code> for a weekly semester calls <code>assertSemesterStillExists(semKey)</code> first: <code>saveLessonData</code>, <code>saveSingleLesson</code>, the move/swap batch writers (today <code>firebase-data.js:802, 830, 1364-1438, 1500</code>; the executor re-greps for every <code>doc('lessonData')</code> writer). It refuses with "This semester was deleted — reload" once the listener reports the key gone. The listener costs one read at load plus one per appData change. The remaining window, a save already in flight at the instant of deletion, is milliseconds wide. If it ever happens, the orphan fragment has no appData entry, so it's invisible. Key reuse is then covered both ways: with "Copy from", the existing server pre-check (<code>app.js:4913-4916</code>) refuses. Without it, re-creating deliberately <em>adopts</em> any leftover (<code>app.js:4910-4912</code>, by design, so a deleted semester can be restored), and Phase 1 adds a server read of that key to the no-copy path that shows "N leftover lessons will be adopted — continue?" when any exist. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
274:<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
295:## Codex confirmation round 3 — narrow
297:Check only your two round-2 minimum changes (snapshot contents; delete coordinating with lessonData incl. stale-tab behaviour) against the code: RESOLVED / NOT RESOLVED with plan-line citations, and whether revision 5 introduced anything wrong. One-line verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
325:  .status-tag { display: inline-block; font-size: .75rem; font-weight: 700; padding: .15rem .5rem; border-radius: 999px; }
339:  <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Christie answered Q1/Q2. Three Claude rounds, then Codex's independent review: NOT ready (5 findings). Revisions 4–5 address them; Codex confirmation round 3 is next.
362:  <tr><td><strong>Making a weekly semester non-active arms its Delete.</strong> Curriculum Admin's bar (manager/admin only) shows Delete for every non-active semester. For a weekly one, <code>deleteSemester</code> removes the appData entry (manager-only), then <code>deleteLessonData(key)</code> removes that semester's whole lesson map, behind two generic confirms. Since the Sep 29 console switch this is already true of Spring 2026 in production. (Finding 3; confirmed.)</td><td><code>app.js:4481-4483, 4522, 4527-4590</code>; <code>firebase-data.js:961-966</code></td></tr>
363:  <tr><td>The header selector's <code>change</code> listener is attached on every <code>initGlobalSemesterSelector()</code> call, with no attach-once guard (the Teacher View selector has one). It's already re-called after creating a semester. (Finding 7; confirmed.)</td><td><code>app.js:86</code>, <code>:825</code>, <code>:4724, 4845</code></td></tr>
411:    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs (accepted, defined):</strong> a lesson editor left open on the deleted semester can still save per-field paths into <code>lessonData.&lt;key&gt;</code> afterwards (<code>firebase-data.js:1429-1437</code>). That recreates an orphan fragment with no appData entry, so it's invisible in the app and loses nothing. If the key is ever reused, <code>createNewSemester</code>'s existing server pre-check (<code>app.js:4913-4916</code>) detects the leftover content and says so. Blocking it outright would mean a server read before every lesson save, which this plan doesn't take on. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
768:./js/app.js:6968:  // NOT closed here: this is still a plain saveFutureProjects() .set(), the
866:./js/app.js:11459:// modal is closed and the lesson reopened while a save is still queued, the
968:./js/app.js:12144:    // shows what was actually saved and the lesson can't be reopened from a
987:./js/app.js:12803:      <div class="settings-hint">Fill in what you know — you can save now and add the rest later. Type <strong>—</strong> in a block you won't use.</div>
1154:./js/firebase-data.js:1397:      console.warn('⛔ saveSingleLesson blocked — all content fields empty, refusing to overwrite:', lessonKey);
1172:./js/firebase-data.js:1472:// vulnerable to (does NOT independently verify the given lessonData reflects
1425:./CLASSBOOK-DATA-SAFETY-PLAN.md:12:**Root cause in both cases**: Firestore's `set(data, { merge: true })` does NOT skip fields that are present with empty string values. `{ introPitch: '' }` written with `merge: true` sets `introPitch` to `''` in Firestore, destroying whatever was there. Both save functions were passing empty content fields through to Firestore.
1441:./CLASSBOOK-DATA-SAFETY-PLAN.md:52:| Test 2 | All-empty save blocked by hasContent guard | ✅ PASS |
1442:./CLASSBOOK-DATA-SAFETY-PLAN.md:54:| Test 4 | Load failure blocks saves | ✅ PASS (Stage 1A) |
1443:./CLASSBOOK-DATA-SAFETY-PLAN.md:59:Plus 7 new Phase 1 tests added Aug 12, 2026 (Stage 2A/2B, unnumbered — see `e2e/data-safety.spec.js`'s "Admin grid safety (Phase 1: ...)" describe blocks for the full BDD): move read-back confirms + deletes, move aborts + restores on failed read-back, move of an empty scaffold still deletes, move never deletes on a throwing write, swap targeted-saves with canary untouched, swap partial-failure rollback, `saveAdminEdit` targeted-save with canary untouched. All 7 ✅ PASS.
1444:./CLASSBOOK-DATA-SAFETY-PLAN.md:61:Plus 2 new Phase 2 tests added Aug 12, 2026 (Stage 2C/2D, unnumbered — see the "Phase 2: ..." describe blocks): non-summer Plan Complete checkbox via the real `attachCardListeners` production listener (proves photoUrl survives a stale local copy), non-summer `saveSingleLesson` stripping regression (mirrors Test 1/2, plus proves sibling non-content fields and the rest of the lesson survive a per-field write). Both ✅ PASS.
1445:./CLASSBOOK-DATA-SAFETY-PLAN.md:63:Plus 3 new Phase 3 tests added Aug 12, 2026 (Stage 2E, unnumbered — see the "Read-back verification (Phase 3: 2E)" describe block): `verifySummerLessonWrite` names the missing field against a real Firestore doc that's missing it, retries once then gives a soft message against a fake docRef that always throws (isolates the retry logic from real network conditions), and a normal successful save still resolves without throwing. All 3 ✅ PASS.
1452:./CLASSBOOK-DATA-SAFETY-PLAN.md:109:**Goal**: Write the 6 behavioral tests that lock in correct save behavior. Tests for already-fixed behaviors (stripping) pass immediately. Tests for Stage 1 behaviors (load failure block, photo order) fail until Stage 1 is implemented — that's proof Stage 1 works.
1463:./CLASSBOOK-DATA-SAFETY-PLAN.md:211:**Test 2: All-empty save is blocked — stripping prevents writing a blank doc**
1468:./CLASSBOOK-DATA-SAFETY-PLAN.md:231:**Test 3: Load failure — error banner appears and saves are blocked**
1489:./CLASSBOOK-DATA-SAFETY-PLAN.md:445:- Test 2 (all-empty save blocked) → ✅ PASS (fix already deployed)
1490:./CLASSBOOK-DATA-SAFETY-PLAN.md:447:- Test 4 (load failure blocks save) → ❌ FAIL — expected, guard not yet implemented
1492:./CLASSBOOK-DATA-SAFETY-PLAN.md:501:#### 1A. Silent load failure — surface the error and block saves
1494:./CLASSBOOK-DATA-SAFETY-PLAN.md:507:**What to change**: After `loadSummerCampData()` returns, if `lessonDataLoadedSuccessfully` is false, render a blocking error banner instead of the normal view:
1495:./CLASSBOOK-DATA-SAFETY-PLAN.md:511:Do NOT type or save anything. Reload the page to try again.
1500:./CLASSBOOK-DATA-SAFETY-PLAN.md:524:**Verify**: In browser devtools, block the `summerCamps_lessonData` network request. Confirm banner appears and Save button is disabled.
1506:./CLASSBOOK-DATA-SAFETY-PLAN.md:604:- [ ] Test 1A: block the network request and confirm error banner appears, saves disabled
1520:./CLASSBOOK-DATA-SAFETY-PLAN.md:690:Note: `saveSingleLesson` will need a guard update — the `hasContent` check currently blocks saves where all content fields are empty. A planComplete-only update has no content fields, so it would be blocked. Add a bypass: if the payload contains `planComplete` explicitly (regardless of content fields), allow the write.
1532:./CLASSBOOK-DATA-SAFETY-PLAN.md:743:- [ ] Test 2A (error path): simulate a failed save; verify source is NOT deleted
1546:./CLASSBOOK-DATA-SAFETY-PLAN.md:873:- A failed load **cannot** be silently saved over (blocked by flag)
1604:./e2e/day-off-materials.spec.js:1055:    const r2 = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur), { Y, cur: cur2, projects: { '2026-12-21': { block1: 'Clay Creatures', block2: 'Glaze Art' } } });
1661:./e2e/day-off-camps.spec.js:578:  test('SDOC G1: a camp saves with its project blocks still empty; the list counts what is left; "—" marks a block unused', async ({ page }) => {
1662:./e2e/day-off-camps.spec.js:586:    const r = await attempt(page, ({ Y, camp }) => saveDayOffCamp(Y, { ...camp, projects: { '2026-11-23': { block1: 'Clay Creatures', block2: '—', openStudio: 'Open Studio' } } }, camp), { Y, camp });
1690:./e2e/data-safety.spec.js:110:    // All content fields empty → hasContent guard blocks the save entirely
1695:./e2e/data-safety.spec.js:138:// and verify the banner shows and saves are blocked.
1700:./e2e/data-safety.spec.js:198:  test('Test 4: when load failed, saveSingleLesson is blocked — existing content survives', async ({ browser }) => {
1701:./e2e/data-safety.spec.js:209:      // Attempt a save — the flag guard must block it by THROWING, not silently
1713:./e2e/data-safety.spec.js:326:    // saveSingleLesson only blocks when === false; null and true both allow saves.
1726:./e2e/data-safety.spec.js:396:    // it blocks the write entirely instead of letting a narrow save through.
1729:./e2e/data-safety.spec.js:413:    // NOTE: this does NOT check Firestore's photoUrl field — saveLesson()'s
1731:./e2e/data-safety.spec.js:451:    // (true today only because the save's catch-block skips the write on error —
1829:./e2e/data-safety.spec.js:1872:      // function saveSingleLesson() does NOT call, so overriding it cannot
1867:./e2e/data-safety.spec.js:2978:      expect(nonSummerDoc).toBeNull(); // must NOT have landed in curriculum/lessonData under a 'summer-2026' key
1870:./e2e/data-safety.spec.js:3134:      expect(nonSummerDoc).toBeNull(); // must NOT have landed in curriculum/lessonData under a 'summer-2026' key
1886:./e2e/data-safety.spec.js:3338:  test('summer modal: when the Firestore save fails after a successful upload, the old photo is NOT deleted and Firestore still points at it', async ({ browser }) => {
1893:./e2e/data-safety.spec.js:3368:  test('summer modal: after a photo is saved, a later autosave (typing) does NOT re-upload it — the pending selection is cleared on success', async ({ browser }) => {
1904:./e2e/data-safety.spec.js:3425:        window.__saveResolvedAt = null;
1905:./e2e/data-safety.spec.js:3426:        window.saveSingleLesson = async (...args) => { const r = await real(...args); window.__saveResolvedAt = Date.now(); return r; };
1907:./e2e/data-safety.spec.js:3430:      const saveResolvedAt = await page.evaluate(() => window.__saveResolvedAt);
1913:./e2e/data-safety.spec.js:3438:      expect(saveResolvedAt).not.toBeNull();
1914:./e2e/data-safety.spec.js:3439:      expect(traffic.deletes[0].at).toBeGreaterThanOrEqual(saveResolvedAt);
1971:./e2e/data-safety.spec.js:3821:      introPitch: 'ORIGINAL — must survive a blocked bulk save',
1976:./e2e/data-safety.spec.js:3850:      expect(saved?.introPitch).toBe('ORIGINAL — must survive a blocked bulk save');
1978:./e2e/data-safety.spec.js:3860:      await writeTestDoc(ALPHA_KEY, { introPitch: 'Must not be touched by a blocked summer bulk save' });
1981:./e2e/data-safety.spec.js:3883:      expect(saved.introPitch).toBe('Must not be touched by a blocked summer bulk save');
2146:./e2e/data-safety.spec.js:5123:      expect(saved).toEqual(expect.objectContaining({ teacher, campName, block, projectTitle, className: `${campName} - ${block}` }));
2258:./e2e/data-safety.spec.js:6122:      expect(saved.block).toBe('Block 1');
2263:./e2e/data-safety.spec.js:6211:  test('RED (moved/deleted elsewhere): a lesson deleted on the server after the popup opened is NOT recreated as a ghost — the save is refused with an explanation', async ({ browser }) => {
2272:./e2e/data-safety.spec.js:6256:      expect(saved.block).toBe('Block 1');
2286:./e2e/data-safety.spec.js:6415:  test('RED (creation onto a slot that gained a project): an "empty" slot in this tab that another admin pasted into is NOT silently overwritten — confirm first; Cancel saves nothing, Accept applies only the typed fields', async ({ browser }) => {
2324:./e2e/data-safety.spec.js:6879:        await saveSingleLesson('summer-2026', key, { ...{ teacher: 'TEST', campName: 'TEST_DATA_SAFETY', block: 'Block 1', projectTitle: 'TEST Project Alpha' }, introPitch: 'A plan saved after Phase 0' });
2343:./e2e/data-safety.spec.js:7173:        // block only — never swap currentConfig itself (appData is written from it).
2564:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:110:    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs are prevented, not accepted</strong> (Codex round 3). A new, narrow <code>onSnapshot</code> on <code>curriculum/appData</code> keeps only a set <code>serverSemesterKeys</code>, and deliberately does <em>not</em> replace <code>currentConfig</code>, so no other behaviour changes. Every writer to <code>curriculum/lessonData</code> for a weekly semester calls <code>assertSemesterStillExists(semKey)</code> first: <code>saveLessonData</code>, <code>saveSingleLesson</code>, the move/swap batch writers (today <code>firebase-data.js:802, 830, 1364-1438, 1500</code>; the executor re-greps for every <code>doc('lessonData')</code> writer). It refuses with "This semester was deleted — reload" once the listener reports the key gone. The listener costs one read at load plus one per appData change. The remaining window, a save already in flight at the instant of deletion, is milliseconds wide. If it ever happens, the orphan fragment has no appData entry, so it's invisible. Key reuse is then covered both ways: with "Copy from", the existing server pre-check (<code>app.js:4913-4916</code>) refuses. Without it, re-creating deliberately <em>adopts</em> any leftover (<code>app.js:4910-4912</code>, by design, so a deleted semester can be restored), and Phase 1 adds a server read of that key to the no-copy path that shows "N leftover lessons will be adopted — continue?" when any exist. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
2592:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html-365-  <strong>Sep 29, 2026: revision 5, after Codex confirmation round 2 (<code>…-codex-r2.md</code>).</strong> Findings 1, 2, 4, 5 and the tab-handler item are confirmed resolved. Finding 3 had two gaps, both taken. (a) The snapshot also includes <code>prepData</code>, <code>lessonData_backup</code> and <code>diagnosticDismissals</code> for the key. (b) The delete transaction re-reads lessonData and refuses unless the semester's lessons deep-equal the downloaded snapshot. Retries from other semesters' saves are accepted. Stale-tab re-saves after a delete are defined as an accepted, invisible orphan that the existing <code>createNewSemester</code> pre-check catches, with a test.
2609:js/app.js:4911:      // failure). The no-copy path is deliberately NOT gated: it writes no
2664:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:130:    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs (accepted, defined):</strong> a lesson editor left open on the deleted semester can still save per-field paths into <code>lessonData.&lt;key&gt;</code> afterwards (<code>firebase-data.js:1429-1437</code>). That recreates an orphan fragment with no appData entry, so it's invisible in the app and loses nothing. If the key is ever reused, <code>createNewSemester</code>'s existing server pre-check (<code>app.js:4913-4916</code>) detects the leftover content and says so. Blocking it outright would mean a server read before every lesson save, which this plan doesn't take on. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
2674:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:534:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:109:    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs (accepted, defined):</strong> a lesson editor left open on the deleted semester can still save per-field paths into <code>lessonData.&lt;key&gt;</code> afterwards (<code>firebase-data.js:1429-1437</code>). That recreates an orphan fragment with no appData entry, so it's invisible in the app and loses nothing. If the key is ever reused, <code>createNewSemester</code>'s existing server pre-check (<code>app.js:4913-4916</code>) detects the leftover content and says so. Blocking it outright would mean a server read before every lesson save, which this plan doesn't take on. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
2713:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1046-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:601:./e2e/data-safety.spec.js:2978:      expect(nonSummerDoc).toBeNull(); // must NOT have landed in curriculum/lessonData under a 'summer-2026' key
2716:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md-1049-/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r2.md:604:./e2e/data-safety.spec.js:3134:      expect(nonSummerDoc).toBeNull(); // must NOT have landed in curriculum/lessonData under a 'summer-2026' key
2986:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2865:  4911	      // failure). The no-copy path is deliberately NOT gated: it writes no
3001:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2930:- **Deletion coordination/stale tabs — NOT RESOLVED.** The transaction now reads and validates `lessonData` correctly ([107](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:107), [189–192](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:189)), but revision 5 explicitly accepts stale tabs recreating orphan data instead of preventing it ([109](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:109), [194–198](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:194)). It also wrongly says the existing creation pre-check always catches that fragment: the code deliberately performs that check only when “Copy from” is selected; no-copy creation adopts the orphan ([app.js:4911](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4911)).
3003:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2932:**NOT EXECUTION-READY — minimum:** prevent stale post-delete lesson saves, or explicitly change the round-2 safety requirement and accurately specify/test both copy and no-copy key reuse; update line 89’s snapshot list.
3008:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2937:- **Deletion coordination/stale tabs — NOT RESOLVED.** The transaction now reads and validates `lessonData` correctly ([107](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:107), [189–192](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:189)), but revision 5 explicitly accepts stale tabs recreating orphan data instead of preventing it ([109](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:109), [194–198](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:194)). It also wrongly says the existing creation pre-check always catches that fragment: the code deliberately performs that check only when “Copy from” is selected; no-copy creation adopts the orphan ([app.js:4911](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4911)).
3010:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex-r3.md:2939:**NOT EXECUTION-READY — minimum:** prevent stale post-delete lesson saves, or explicitly change the round-2 safety requirement and accurately specify/test both copy and no-copy key reuse; update line 89’s snapshot list.
3049:   110	    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs are prevented, not accepted</strong> (Codex round 3). A new, narrow <code>onSnapshot</code> on <code>curriculum/appData</code> keeps only a set <code>serverSemesterKeys</code>, and deliberately does <em>not</em> replace <code>currentConfig</code>, so no other behaviour changes. Every writer to <code>curriculum/lessonData</code> for a weekly semester calls <code>assertSemesterStillExists(semKey)</code> first: <code>saveLessonData</code>, <code>saveSingleLesson</code>, the move/swap batch writers (today <code>firebase-data.js:802, 830, 1364-1438, 1500</code>; the executor re-greps for every <code>doc('lessonData')</code> writer). It refuses with "This semester was deleted — reload" once the listener reports the key gone. The listener costs one read at load plus one per appData change. The remaining window, a save already in flight at the instant of deletion, is milliseconds wide. If it ever happens, the orphan fragment has no appData entry, so it's invisible. Key reuse is then covered both ways: with "Copy from", the existing server pre-check (<code>app.js:4913-4916</code>) refuses. Without it, re-creating deliberately <em>adopts</em> any leftover (<code>app.js:4910-4912</code>, by design, so a deleted semester can be restored), and Phase 1 adds a server read of that key to the no-copy path that shows "N leftover lessons will be adopted — continue?" when any exist. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
3230:   365	  <strong>Sep 29, 2026: revision 5, after Codex confirmation round 2 (<code>…-codex-r2.md</code>).</strong> Findings 1, 2, 4, 5 and the tab-handler item are confirmed resolved. Finding 3 had two gaps, both taken. (a) The snapshot also includes <code>prepData</code>, <code>lessonData_backup</code> and <code>diagnosticDismissals</code> for the key. (b) The delete transaction re-reads lessonData and refuses unless the semester's lessons deep-equal the downloaded snapshot. Retries from other semesters' saves are accepted. Stale-tab re-saves after a delete are defined as an accepted, invisible orphan that the existing <code>createNewSemester</code> pre-check catches, with a test.
3233:   368	  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
3300:   839	  // Resolved once, before any batch work — a semester with no valid season
3362:  1390	    // attempt — only block when there's neither real content nor an explicit
3369:  1397	      console.warn('⛔ saveSingleLesson blocked — all content fields empty, refusing to overwrite:', lessonKey);
3444:  1472	// vulnerable to (does NOT independently verify the given lessonData reflects
3689:  7305	  content.style.display = content.style.display === 'none' ? 'block' : 'none';
3805:   839	  // Resolved once, before any batch work — a semester with no valid season
3902:**NOT EXECUTION-READY — minimum:** explicitly cover every weekly `lessonData` writer, and specify/test fail-closed initialization plus cache/offline/error semantics for `serverSemesterKeys`.
3917:**NOT EXECUTION-READY — minimum:** explicitly cover every weekly `lessonData` writer, and specify/test fail-closed initialization plus cache/offline/error semantics for `serverSemesterKeys`.
=== 2026-09-29-plan-review-make-active-semester-codex-r5-input.md ===
1:## Codex confirmation round 5 — narrow
3:Check only your round-4 minimum: (1) is the lessonData writer list complete against the code (all loaded scripts; include writes via refs/variables, batches, transactions)? (2) are the fail-closed states sound (e.g. does a fromCache:true metadata snapshot really arrive on going offline with includeMetadataChanges; could 'unconfirmed' wrongly block normal online saves, e.g. a local-write latency-compensated snapshot)? Verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
=== 2026-09-29-plan-review-make-active-semester-codex-r5.md ===
14:## Codex confirmation round 5 — narrow
16:Check only your round-4 minimum: (1) is the lessonData writer list complete against the code (all loaded scripts; include writes via refs/variables, batches, transactions)? (2) are the fail-closed states sound (e.g. does a fromCache:true metadata snapshot really arrive on going offline with includeMetadataChanges; could 'unconfirmed' wrongly block normal online saves, e.g. a local-write latency-compensated snapshot)? Verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
28:  <strong>Sep 29, 2026: revision 5, after Codex confirmation round 2 (<code>…-codex-r2.md</code>).</strong> Findings 1, 2, 4, 5 and the tab-handler item are confirmed resolved. Finding 3 had two gaps, both taken. (a) The snapshot also includes <code>prepData</code>, <code>lessonData_backup</code> and <code>diagnosticDismissals</code> for the key. (b) The delete transaction re-reads lessonData and refuses unless the semester's lessons deep-equal the downloaded snapshot. Retries from other semesters' saves are accepted. Stale-tab re-saves after a delete are defined as an accepted, invisible orphan that the existing <code>createNewSemester</code> pre-check catches, with a test.
31:  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
44:  <strong>Sep 29, 2026: round 3 (confirmation) — EXECUTION-READY</strong> (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md</code>). All round-2 blockers were confirmed resolved. Its four clarifications are folded in: hide only <code>.footer-dot.write-control</code>; <code>readServerSemesterLessonMap</code> returning <code>null</code> means 0 lessons, not a failure; the three delete tests must split their <code>page.evaluate</code> to drive the modal; the activation uses <code>confirmModal</code> from Phase 1. Also named: a curriculum-admin/prep user with nothing remembered lands with Curriculum Admin hidden when Summer is active. All phases are marked execution-ready. Execution waits for Christie's go-ahead. Codex didn't review this plan (out of credits); all three rounds were Claude.
47:  <strong>Sep 29, 2026: revision 3, after round-2 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r2-claude.md</code>).</strong> Round 2 found the write shape safe and listed five blockers, all verified and taken:
102:## Codex confirmation round 4 — narrow
104:Check only: (1) your round-3 minimum (stale post-delete saves prevented; copy and no-copy key reuse specified/tested; acceptance snapshot list) — RESOLVED / NOT with plan-line citations; (2) whether the new appData listener + assertSemesterStillExists design is sound against the code: every doc('lessonData') writer covered? any risk the listener changes existing behaviour (currentConfig untouched)? first-snapshot timing (a save before the first snapshot arrives)? offline/cache snapshots? (3) One-line verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
132:  .status-tag { display: inline-block; font-size: .75rem; font-weight: 700; padding: .15rem .5rem; border-radius: 999px; }
146:  <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Christie answered Q1/Q2. Three Claude rounds, then Codex's independent review: NOT ready (5 findings). Revisions 4–6 address them; Codex confirmation round 4 is next.
169:  <tr><td><strong>Making a weekly semester non-active arms its Delete.</strong> Curriculum Admin's bar (manager/admin only) shows Delete for every non-active semester. For a weekly one, <code>deleteSemester</code> removes the appData entry (manager-only), then <code>deleteLessonData(key)</code> removes that semester's whole lesson map, behind two generic confirms. Since the Sep 29 console switch this is already true of Spring 2026 in production. (Finding 3; confirmed.)</td><td><code>app.js:4481-4483, 4522, 4527-4590</code>; <code>firebase-data.js:961-966</code></td></tr>
170:  <tr><td>The header selector's <code>change</code> listener is attached on every <code>initGlobalSemesterSelector()</code> call, with no attach-once guard (the Teacher View selector has one). It's already re-called after creating a semester. (Finding 7; confirmed.)</td><td><code>app.js:86</code>, <code>:825</code>, <code>:4724, 4845</code></td></tr>
219:    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs are prevented, not accepted</strong> (Codex round 3). A new, narrow <code>onSnapshot</code> on <code>curriculum/appData</code> keeps only a set <code>serverSemesterKeys</code>, and deliberately does <em>not</em> replace <code>currentConfig</code>, so no other behaviour changes. Every writer to <code>curriculum/lessonData</code> for a weekly semester calls <code>assertSemesterStillExists(semKey)</code> first: <code>saveLessonData</code>, <code>saveSingleLesson</code>, the move/swap batch writers (today <code>firebase-data.js:802, 830, 1364-1438, 1500</code>; the executor re-greps for every <code>doc('lessonData')</code> writer). It refuses with "This semester was deleted — reload" once the listener reports the key gone. The listener costs one read at load plus one per appData change. The remaining window, a save already in flight at the instant of deletion, is milliseconds wide. If it ever happens, the orphan fragment has no appData entry, so it's invisible. Key reuse is then covered both ways: with "Copy from", the existing server pre-check (<code>app.js:4913-4916</code>) refuses. Without it, re-creating deliberately <em>adopts</em> any leftover (<code>app.js:4910-4912</code>, by design, so a deleted semester can be restored), and Phase 1 adds a server read of that key to the no-copy path that shows "N leftover lessons will be adopted — continue?" when any exist. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
360:js/app.js:3816:      projects.set(`${data.campTopic}|||${data.projectTitle}|||${data.block}`, lessonKey);
375:js/app.js:6968:  // NOT closed here: this is still a plain saveFutureProjects() .set(), the
538:   121	It refuses once the listener reports the key gone. The listener costs one read at load plus one per appData change. The remaining window, a save already in flight at the instant of deletion, is milliseconds wide. If it ever happens, the orphan fragment has no appData entry, so it's invisible. Key reuse is then covered both ways: with "Copy from", the existing server pre-check (<code>app.js:4913-4916</code>) refuses. Without it, re-creating deliberately <em>adopts</em> any leftover (<code>app.js:4910-4912</code>, by design, so a deleted semester can be restored), and Phase 1 adds a server read of that key to the no-copy path that shows "N leftover lessons will be adopted — continue?" when any exist. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
660:   839	  // Resolved once, before any batch work — a semester with no valid season
707:  1390	    // attempt — only block when there's neither real content nor an explicit
714:  1397	      console.warn('⛔ saveSingleLesson blocked — all content fields empty, refusing to overwrite:', lessonKey);
789:  1472	// vulnerable to (does NOT independently verify the given lessonData reflects
1313:js/firebase-data.js-1397-      console.warn('⛔ saveSingleLesson blocked — all content fields empty, refusing to overwrite:', lessonKey);
1370:js/firebase-data.js:1472:// vulnerable to (does NOT independently verify the given lessonData reflects
1456:js/firebase-data.js-1933-// planner's edit and a prep tick never collide. NOT `materials`: that name is a
1521:js/app.js-1761-          if (!slot) return `<div class="sdoc-tv-block" data-block="${key}"><span class="sdoc-tv-label">${label}</span> ${sdocEsc(title)}</div>`;
1525:js/app.js-1765-          return `<div class="sdoc-tv-block" data-block="${key}">
1608:js/app.js-4984-    // Revert both local mutations so a retry isn't blocked by a phantom
1887:  4911	      // failure). The no-copy path is deliberately NOT gated: it writes no
1960:  4984	    // Revert both local mutations so a retry isn't blocked by a phantom
2025:**NOT EXECUTION-READY**
2031:Minimum: specify create/cleanup handling, and make semester existence atomic with each weekly lessonData write (transaction or equivalent), using the listener only for early UX refusal.
2034:**NOT EXECUTION-READY**
2040:Minimum: specify create/cleanup handling, and make semester existence atomic with each weekly lessonData write (transaction or equivalent), using the listener only for early UX refusal.
=== 2026-09-29-plan-review-make-active-semester-codex-r6-input.md ===
1:## Codex round 6 — revision 8 (design change)
6:2. Anything from your rounds 1–5 that the removal reopened (activation transaction, per-user switch, unticked clears switch, Settings gating, header sync)?
8:Verdict: EXECUTION-READY or NOT (minimum list). Be concise. Do not edit files or run tests.
=== 2026-09-29-plan-review-make-active-semester-codex-r6.md ===
14:## Codex round 6 — revision 8 (design change)
19:2. Anything from your rounds 1–5 that the removal reopened (activation transaction, per-user switch, unticked clears switch, Settings gating, header sync)?
21:Verdict: EXECUTION-READY or NOT (minimum list). Be concise. Do not edit files or run tests.
49:  .status-tag { display: inline-block; font-size: .75rem; font-weight: 700; padding: .15rem .5rem; border-radius: 999px; }
63:  <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Christie answered Q1/Q2. Three Claude rounds, then Codex's independent review: NOT ready (5 findings). Revisions 4–8 address them (revision 8: archive instead of delete, per Christie). Codex confirmation round 6 is next.
86:  <tr><td><strong>Making a weekly semester non-active arms its Delete.</strong> Curriculum Admin's bar (manager/admin only) shows Delete for every non-active semester. For a weekly one, <code>deleteSemester</code> removes the appData entry (manager-only), then <code>deleteLessonData(key)</code> removes that semester's whole lesson map, behind two generic confirms. Since the Sep 29 console switch this is already true of Spring 2026 in production. (Finding 3; confirmed.)</td><td><code>app.js:4481-4483, 4522, 4527-4590</code>; <code>firebase-data.js:961-966</code></td></tr>
87:  <tr><td>The header selector's <code>change</code> listener is attached on every <code>initGlobalSemesterSelector()</code> call, with no attach-once guard (the Teacher View selector has one). It's already re-called after creating a semester. (Finding 7; confirmed.)</td><td><code>app.js:86</code>, <code>:825</code>, <code>:4724, 4845</code></td></tr>
260:<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
287:37:  <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Christie answered Q1/Q2. Three Claude rounds, then Codex's independent review: NOT ready (5 findings). Revisions 4–8 address them (revision 8: archive instead of delete, per Christie). Codex confirmation round 6 is next.
292:## Independent review — plan under review
300:4. Verdict: EXECUTION-READY or NOT, with the minimum list of changes.
303:## Codex confirmation round — plan under review
307:For each of your five findings and the tab-click-handler item: RESOLVED / NOT RESOLVED, citing plan lines. Then check what revision 4 newly introduced, against the code:
311:Verdict: EXECUTION-READY or NOT, minimum list. Be brief. Do not edit files or run tests.
326:## Codex confirmation round — plan under review
330:For each of your five findings and the tab-click-handler item: RESOLVED / NOT RESOLVED, citing plan lines. Then check what revision 4 newly introduced, against the code:
334:Verdict: EXECUTION-READY or NOT, minimum list. Be brief. Do not edit files or run tests.
355:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:109:    The old two-write path and its warn-only catch are removed for weekly semesters. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
395:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:342:  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
413:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:124:  <li><code>deleteSemester</code>, weekly branch only: the count comes from <code>readServerSemesterLessonMap(key)</code> (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
457:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:432:One round-2 aside is **NOT NAMED**: "a `curriculum-admin`/`prep` user with nothing remembered now lands with the Curriculum Admin tab hidden" is only implicit in plan:123 ("render as they do when Summer is merely selected"). Cosmetic.
461:/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:475:    95	  <li><code>deleteSemester</code>, weekly branch only: the count comes from <code>readServerSemesterLessonMap(key)</code> (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
554:## Codex confirmation round 3 — narrow
556:Check only your two round-2 minimum changes (snapshot contents; delete coordinating with lessonData incl. stale-tab behaviour) against the code: RESOLVED / NOT RESOLVED with plan-line citations, and whether revision 5 introduced anything wrong. One-line verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
571:## Codex confirmation round 3 — narrow
573:Check only your two round-2 minimum changes (snapshot contents; delete coordinating with lessonData incl. stale-tab behaviour) against the code: RESOLVED / NOT RESOLVED with plan-line citations, and whether revision 5 introduced anything wrong. One-line verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
601:  .status-tag { display: inline-block; font-size: .75rem; font-weight: 700; padding: .15rem .5rem; border-radius: 999px; }
615:  <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Christie answered Q1/Q2. Three Claude rounds, then Codex's independent review: NOT ready (5 findings). Revisions 4–5 address them; Codex confirmation round 3 is next.
638:  <tr><td><strong>Making a weekly semester non-active arms its Delete.</strong> Curriculum Admin's bar (manager/admin only) shows Delete for every non-active semester. For a weekly one, <code>deleteSemester</code> removes the appData entry (manager-only), then <code>deleteLessonData(key)</code> removes that semester's whole lesson map, behind two generic confirms. Since the Sep 29 console switch this is already true of Spring 2026 in production. (Finding 3; confirmed.)</td><td><code>app.js:4481-4483, 4522, 4527-4590</code>; <code>firebase-data.js:961-966</code></td></tr>
639:  <tr><td>The header selector's <code>change</code> listener is attached on every <code>initGlobalSemesterSelector()</code> call, with no attach-once guard (the Teacher View selector has one). It's already re-called after creating a semester. (Finding 7; confirmed.)</td><td><code>app.js:86</code>, <code>:825</code>, <code>:4724, 4845</code></td></tr>
687:    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs (accepted, defined):</strong> a lesson editor left open on the deleted semester can still save per-field paths into <code>lessonData.&lt;key&gt;</code> afterwards (<code>firebase-data.js:1429-1437</code>). That recreates an orphan fragment with no appData entry, so it's invisible in the app and loses nothing. If the key is ever reused, <code>createNewSemester</code>'s existing server pre-check (<code>app.js:4913-4916</code>) detects the leftover content and says so. Blocking it outright would mean a server read before every lesson save, which this plan doesn't take on. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
799:## Codex confirmation round 4 — narrow
801:Check only: (1) your round-3 minimum (stale post-delete saves prevented; copy and no-copy key reuse specified/tested; acceptance snapshot list) — RESOLVED / NOT with plan-line citations; (2) whether the new appData listener + assertSemesterStillExists design is sound against the code: every doc('lessonData') writer covered? any risk the listener changes existing behaviour (currentConfig untouched)? first-snapshot timing (a save before the first snapshot arrives)? offline/cache snapshots? (3) One-line verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
816:## Codex confirmation round 4 — narrow
818:Check only: (1) your round-3 minimum (stale post-delete saves prevented; copy and no-copy key reuse specified/tested; acceptance snapshot list) — RESOLVED / NOT with plan-line citations; (2) whether the new appData listener + assertSemesterStillExists design is sound against the code: every doc('lessonData') writer covered? any risk the listener changes existing behaviour (currentConfig untouched)? first-snapshot timing (a save before the first snapshot arrives)? offline/cache snapshots? (3) One-line verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
846:  .status-tag { display: inline-block; font-size: .75rem; font-weight: 700; padding: .15rem .5rem; border-radius: 999px; }
860:  <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Christie answered Q1/Q2. Three Claude rounds, then Codex's independent review: NOT ready (5 findings). Revisions 4–6 address them; Codex confirmation round 4 is next.
883:  <tr><td><strong>Making a weekly semester non-active arms its Delete.</strong> Curriculum Admin's bar (manager/admin only) shows Delete for every non-active semester. For a weekly one, <code>deleteSemester</code> removes the appData entry (manager-only), then <code>deleteLessonData(key)</code> removes that semester's whole lesson map, behind two generic confirms. Since the Sep 29 console switch this is already true of Spring 2026 in production. (Finding 3; confirmed.)</td><td><code>app.js:4481-4483, 4522, 4527-4590</code>; <code>firebase-data.js:961-966</code></td></tr>
884:  <tr><td>The header selector's <code>change</code> listener is attached on every <code>initGlobalSemesterSelector()</code> call, with no attach-once guard (the Teacher View selector has one). It's already re-called after creating a semester. (Finding 7; confirmed.)</td><td><code>app.js:86</code>, <code>:825</code>, <code>:4724, 4845</code></td></tr>
933:    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs are prevented, not accepted</strong> (Codex round 3). A new, narrow <code>onSnapshot</code> on <code>curriculum/appData</code> keeps only a set <code>serverSemesterKeys</code>, and deliberately does <em>not</em> replace <code>currentConfig</code>, so no other behaviour changes. Every writer to <code>curriculum/lessonData</code> for a weekly semester calls <code>assertSemesterStillExists(semKey)</code> first: <code>saveLessonData</code>, <code>saveSingleLesson</code>, the move/swap batch writers (today <code>firebase-data.js:802, 830, 1364-1438, 1500</code>; the executor re-greps for every <code>doc('lessonData')</code> writer). It refuses with "This semester was deleted — reload" once the listener reports the key gone. The listener costs one read at load plus one per appData change. The remaining window, a save already in flight at the instant of deletion, is milliseconds wide. If it ever happens, the orphan fragment has no appData entry, so it's invisible. Key reuse is then covered both ways: with "Copy from", the existing server pre-check (<code>app.js:4913-4916</code>) refuses. Without it, re-creating deliberately <em>adopts</em> any leftover (<code>app.js:4910-4912</code>, by design, so a deleted semester can be restored), and Phase 1 adds a server read of that key to the no-copy path that shows "N leftover lessons will be adopted — continue?" when any exist. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
1044:## Codex confirmation round 5 — narrow
1046:Check only your round-4 minimum: (1) is the lessonData writer list complete against the code (all loaded scripts; include writes via refs/variables, batches, transactions)? (2) are the fail-closed states sound (e.g. does a fromCache:true metadata snapshot really arrive on going offline with includeMetadataChanges; could 'unconfirmed' wrongly block normal online saves, e.g. a local-write latency-compensated snapshot)? Verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
1061:## Codex confirmation round 5 — narrow
1063:Check only your round-4 minimum: (1) is the lessonData writer list complete against the code (all loaded scripts; include writes via refs/variables, batches, transactions)? (2) are the fail-closed states sound (e.g. does a fromCache:true metadata snapshot really arrive on going offline with includeMetadataChanges; could 'unconfirmed' wrongly block normal online saves, e.g. a local-write latency-compensated snapshot)? Verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
1075:  <strong>Sep 29, 2026: revision 5, after Codex confirmation round 2 (<code>…-codex-r2.md</code>).</strong> Findings 1, 2, 4, 5 and the tab-handler item are confirmed resolved. Finding 3 had two gaps, both taken. (a) The snapshot also includes <code>prepData</code>, <code>lessonData_backup</code> and <code>diagnosticDismissals</code> for the key. (b) The delete transaction re-reads lessonData and refuses unless the semester's lessons deep-equal the downloaded snapshot. Retries from other semesters' saves are accepted. Stale-tab re-saves after a delete are defined as an accepted, invisible orphan that the existing <code>createNewSemester</code> pre-check catches, with a test.
1078:  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
1091:  <strong>Sep 29, 2026: round 3 (confirmation) — EXECUTION-READY</strong> (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md</code>). All round-2 blockers were confirmed resolved. Its four clarifications are folded in: hide only <code>.footer-dot.write-control</code>; <code>readServerSemesterLessonMap</code> returning <code>null</code> means 0 lessons, not a failure; the three delete tests must split their <code>page.evaluate</code> to drive the modal; the activation uses <code>confirmModal</code> from Phase 1. Also named: a curriculum-admin/prep user with nothing remembered lands with Curriculum Admin hidden when Summer is active. All phases are marked execution-ready. Execution waits for Christie's go-ahead. Codex didn't review this plan (out of credits); all three rounds were Claude.
1094:  <strong>Sep 29, 2026: revision 3, after round-2 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r2-claude.md</code>).</strong> Round 2 found the write shape safe and listed five blockers, all verified and taken:
1149:## Codex confirmation round 4 — narrow
1151:Check only: (1) your round-3 minimum (stale post-delete saves prevented; copy and no-copy key reuse specified/tested; acceptance snapshot list) — RESOLVED / NOT with plan-line citations; (2) whether the new appData listener + assertSemesterStillExists design is sound against the code: every doc('lessonData') writer covered? any risk the listener changes existing behaviour (currentConfig untouched)? first-snapshot timing (a save before the first snapshot arrives)? offline/cache snapshots? (3) One-line verdict: EXECUTION-READY or NOT (minimum list). Be brief. Do not edit files or run tests.
1179:  .status-tag { display: inline-block; font-size: .75rem; font-weight: 700; padding: .15rem .5rem; border-radius: 999px; }
1193:  <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Christie answered Q1/Q2. Three Claude rounds, then Codex's independent review: NOT ready (5 findings). Revisions 4–6 address them; Codex confirmation round 4 is next.
1216:  <tr><td><strong>Making a weekly semester non-active arms its Delete.</strong> Curriculum Admin's bar (manager/admin only) shows Delete for every non-active semester. For a weekly one, <code>deleteSemester</code> removes the appData entry (manager-only), then <code>deleteLessonData(key)</code> removes that semester's whole lesson map, behind two generic confirms. Since the Sep 29 console switch this is already true of Spring 2026 in production. (Finding 3; confirmed.)</td><td><code>app.js:4481-4483, 4522, 4527-4590</code>; <code>firebase-data.js:961-966</code></td></tr>
1217:  <tr><td>The header selector's <code>change</code> listener is attached on every <code>initGlobalSemesterSelector()</code> call, with no attach-once guard (the Teacher View selector has one). It's already re-called after creating a semester. (Finding 7; confirmed.)</td><td><code>app.js:86</code>, <code>:825</code>, <code>:4724, 4845</code></td></tr>
1266:    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs are prevented, not accepted</strong> (Codex round 3). A new, narrow <code>onSnapshot</code> on <code>curriculum/appData</code> keeps only a set <code>serverSemesterKeys</code>, and deliberately does <em>not</em> replace <code>currentConfig</code>, so no other behaviour changes. Every writer to <code>curriculum/lessonData</code> for a weekly semester calls <code>assertSemesterStillExists(semKey)</code> first: <code>saveLessonData</code>, <code>saveSingleLesson</code>, the move/swap batch writers (today <code>firebase-data.js:802, 830, 1364-1438, 1500</code>; the executor re-greps for every <code>doc('lessonData')</code> writer). It refuses with "This semester was deleted — reload" once the listener reports the key gone. The listener costs one read at load plus one per appData change. The remaining window, a save already in flight at the instant of deletion, is milliseconds wide. If it ever happens, the orphan fragment has no appData entry, so it's invisible. Key reuse is then covered both ways: with "Copy from", the existing server pre-check (<code>app.js:4913-4916</code>) refuses. Without it, re-creating deliberately <em>adopts</em> any leftover (<code>app.js:4910-4912</code>, by design, so a deleted semester can be restored), and Phase 1 adds a server read of that key to the no-copy path that shows "N leftover lessons will be adopted — continue?" when any exist. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
1289:## Codex round 6 — revision 8 (design change)
1294:2. Anything from your rounds 1–5 that the removal reopened (activation transaction, per-user switch, unticked clears switch, Settings gating, header sync)?
1296:Verdict: EXECUTION-READY or NOT (minimum list). Be concise. Do not edit files or run tests.
1311:## Codex round 6 — revision 8 (design change)
1316:2. Anything from your rounds 1–5 that the removal reopened (activation transaction, per-user switch, unticked clears switch, Settings gating, header sync)?
1318:Verdict: EXECUTION-READY or NOT (minimum list). Be concise. Do not edit files or run tests.
1335:## Independent review — plan under review
1343:4. Verdict: EXECUTION-READY or NOT, with the minimum list of changes.
1373:  .status-tag { display: inline-block; font-size: .75rem; font-weight: 700; padding: .15rem .5rem; border-radius: 999px; }
1387:  <strong>Status:</strong> <span class="status-tag ready">execution-ready: true</span>. Christie answered Q1/Q2. Reviewed in three rounds; round 3 verdict: EXECUTION-READY. Waiting for Christie's go-ahead to build.
1410:  <tr><td><strong>Making a weekly semester non-active arms its Delete.</strong> Curriculum Admin's bar (manager/admin only) shows Delete for every non-active semester. For a weekly one, <code>deleteSemester</code> removes the appData entry (manager-only), then <code>deleteLessonData(key)</code> removes that semester's whole lesson map, behind two generic confirms. Since the Sep 29 console switch this is already true of Spring 2026 in production. (Finding 3; confirmed.)</td><td><code>app.js:4481-4483, 4522, 4527-4590</code>; <code>firebase-data.js:961-966</code></td></tr>
1411:  <tr><td>The header selector's <code>change</code> listener is attached on every <code>initGlobalSemesterSelector()</code> call, with no attach-once guard (the Teacher View selector has one). It's already re-called after creating a semester. (Finding 7; confirmed.)</td><td><code>app.js:86</code>, <code>:825</code>, <code>:4724, 4845</code></td></tr>
1445:  <li><code>deleteSemester</code>, weekly branch only: the count comes from <code>readServerSemesterLessonMap(key)</code> (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
1548:<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
1587:37:  <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Christie answered Q1/Q2. Three Claude rounds, then Codex's independent review: NOT ready (5 findings). Revisions 4–8 address them (revision 8: archive instead of delete, per Christie). Codex confirmation round 6 is next.
1603:60-  <tr><td><strong>Making a weekly semester non-active arms its Delete.</strong> Curriculum Admin's bar (manager/admin only) shows Delete for every non-active semester. For a weekly one, <code>deleteSemester</code> removes the appData entry (manager-only), then <code>deleteLessonData(key)</code> removes that semester's whole lesson map, behind two generic confirms. Since the Sep 29 console switch this is already true of Spring 2026 in production. (Finding 3; confirmed.)</td><td><code>app.js:4481-4483, 4522, 4527-4590</code>; <code>firebase-data.js:961-966</code></td></tr>
1604:61:  <tr><td>The header selector's <code>change</code> listener is attached on every <code>initGlobalSemesterSelector()</code> call, with no attach-once guard (the Teacher View selector has one). It's already re-called after creating a semester. (Finding 7; confirmed.)</td><td><code>app.js:86</code>, <code>:825</code>, <code>:4724, 4845</code></td></tr>
1754:234:<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
1847:352:  <strong>Sep 29, 2026: revision 5, after Codex confirmation round 2 (<code>…-codex-r2.md</code>).</strong> Findings 1, 2, 4, 5 and the tab-handler item are confirmed resolved. Finding 3 had two gaps, both taken. (a) The snapshot also includes <code>prepData</code>, <code>lessonData_backup</code> and <code>diagnosticDismissals</code> for the key. (b) The delete transaction re-reads lessonData and refuses unless the semester's lessons deep-equal the downloaded snapshot. Retries from other semesters' saves are accepted. Stale-tab re-saves after a delete are defined as an accepted, invisible orphan that the existing <code>createNewSemester</code> pre-check catches, with a test.
1850:355-  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
1866:371-  <strong>Sep 29, 2026: revision 3, after round-2 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r2-claude.md</code>).</strong> Round 2 found the write shape safe and listed five blockers, all verified and taken:
2418:    // SDOC (Phase 2B): a camp with only empty blocks has no slots, and there is
2450:  // (or only empty blocks) is an empty map and would otherwise say "Loading"
2592:        ? `<button onclick="showAdminEdit('${escAttr(lessonKey)}', '${escAttr(sess.teacher)}', '${escAttr(campTopic + ' - ' + block)}', ${weekNum})" style="background:none;border:none;color:var(--purple);font-size:0.85rem;cursor:pointer;padding:0;text-align:left;font-weight:500;text-decoration:underline;">${escHtml(title)}</button>`
2595:        <td style="padding:0.4rem 0.75rem;font-size:0.82rem;font-weight:600;color:var(--gray-600);background:var(--gray-50);border:1px solid var(--gray-200);white-space:nowrap;">${escHtml(block)}</td>
3056:      // failure). The no-copy path is deliberately NOT gated: it writes no
3129:    // Revert both local mutations so a retry isn't blocked by a phantom
3285:    el.style.display = isSummer ? 'none' : 'block';
3771:      description: 'Work blocks — prepare items as requested. Prep work should be 2 weeks ahead of project.',
4075:./js/app.js:10932:        problems.push(`semesters.${key} appeared after the dry run and was NOT stamped — re-run the dry run and stamp again`);
4161:    alert(`"${freshLesson.projectTitle}" was safely archived to the Cut Bank, but could NOT be removed from the grid. Please reload and check — it may now appear in both places.`);
4397:js/firebase-data.js:839:  // Resolved once, before any batch work — a semester with no valid season
4399:js/firebase-data.js:929:  // Resolved before the read so an invalid semester is refused before anything is touched.
4473:js/firebase-data.js:1933:// planner's edit and a prep tick never collide. NOT `materials`: that name is a
5021:  content.style.display = content.style.display === 'none' ? 'block' : 'none';
5101:  content.style.display = wasHidden ? 'block' : 'none';
5206:      // degrade to "no comparison available" rather than blocking the live
5220:  content.style.display = wasHidden ? 'block' : 'none';
5334:      // failure). The no-copy path is deliberately NOT gated: it writes no
5407:    // Revert both local mutations so a retry isn't blocked by a phantom
5861:<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
6182:      if (user && authResolvedUid && user.uid !== authResolvedUid) {
6236:        authResolvedUid = user.uid;
6298:      // NOTE: 'classbook' (plain teacher) access is intentionally NOT
=== 2026-09-29-plan-review-make-active-semester-codex.md ===
14:## Independent review — plan under review
22:4. Verdict: EXECUTION-READY or NOT, with the minimum list of changes.
52:  .status-tag { display: inline-block; font-size: .75rem; font-weight: 700; padding: .15rem .5rem; border-radius: 999px; }
66:  <strong>Status:</strong> <span class="status-tag ready">execution-ready: true</span>. Christie answered Q1/Q2. Reviewed in three rounds; round 3 verdict: EXECUTION-READY. Waiting for Christie's go-ahead to build.
89:  <tr><td><strong>Making a weekly semester non-active arms its Delete.</strong> Curriculum Admin's bar (manager/admin only) shows Delete for every non-active semester. For a weekly one, <code>deleteSemester</code> removes the appData entry (manager-only), then <code>deleteLessonData(key)</code> removes that semester's whole lesson map, behind two generic confirms. Since the Sep 29 console switch this is already true of Spring 2026 in production. (Finding 3; confirmed.)</td><td><code>app.js:4481-4483, 4522, 4527-4590</code>; <code>firebase-data.js:961-966</code></td></tr>
90:  <tr><td>The header selector's <code>change</code> listener is attached on every <code>initGlobalSemesterSelector()</code> call, with no attach-once guard (the Teacher View selector has one). It's already re-called after creating a semester. (Finding 7; confirmed.)</td><td><code>app.js:86</code>, <code>:825</code>, <code>:4724, 4845</code></td></tr>
124:  <li><code>deleteSemester</code>, weekly branch only: the count comes from <code>readServerSemesterLessonMap(key)</code> (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
227:<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
293:## Claims I confirmed
306:## High — these block or mislead
321:## Medium
333:## Low
344:## BDD gaps (a partial implementation could still pass)
348:## On your other questions, plainly
356:## 1. Did revision 2 resolve round 1?
375:## 2. Camp season active — what actually changes
389:## 3. The e2e plan
402:## 4. Still unsafe or missing
419:## Round-2 blockers
429:## "Also taken" items
432:One round-2 aside is **NOT NAMED**: "a `curriculum-admin`/`prep` user with nothing remembered now lands with the Curriculum Admin tab hidden" is only implicit in plan:123 ("render as they do when Summer is merely selected"). Cosmetic.
434:## New in revision 3 — checked
438:- **`readServerSemesterLessonMap` (`firebase-data.js:973-977`)** does a forced-server `get()` of the whole `curriculum/lessonData` doc and returns `null` when the doc *or* the key is absent; it throws only on a read failure. So `null` = 0 lessons and the delete must proceed. The BDD (plan:170) says "rejects", which is right, but plan:95's "a failed read refuses" should say null ≠ failure so a legitimately empty semester isn't blocked.
442:## Verdict
444:**EXECUTION-READY.** The four clarifications above are one-liners for the executor, not another review round.
475:    95	  <li><code>deleteSemester</code>, weekly branch only: the count comes from <code>readServerSemesterLessonMap(key)</code> (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
578:   198	<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
675:   295	  <strong>Sep 29, 2026: round 3 (confirmation) — EXECUTION-READY</strong> (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md</code>). All round-2 blockers were confirmed resolved. Its four clarifications are folded in: hide only <code>.footer-dot.write-control</code>; <code>readServerSemesterLessonMap</code> returning <code>null</code> means 0 lessons, not a failure; the three delete tests must split their <code>page.evaluate</code> to drive the modal; the activation uses <code>confirmModal</code> from Phase 1. Also named: a curriculum-admin/prep user with nothing remembered lands with Curriculum Admin hidden when Summer is active. All phases are marked execution-ready. Execution waits for Christie's go-ahead. Codex didn't review this plan (out of credits); all three rounds were Claude.
678:   298	  <strong>Sep 29, 2026: revision 3, after round-2 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r2-claude.md</code>).</strong> Round 2 found the write shape safe and listed five blockers, all verified and taken:
1011:   295	  <strong>Sep 29, 2026: round 3 (confirmation) — EXECUTION-READY</strong> (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md</code>). All round-2 blockers were confirmed resolved. Its four clarifications are folded in: hide only <code>.footer-dot.write-control</code>; <code>readServerSemesterLessonMap</code> returning <code>null</code> means 0 lessons, not a failure; the three delete tests must split their <code>page.evaluate</code> to drive the modal; the activation uses <code>confirmModal</code> from Phase 1. Also named: a curriculum-admin/prep user with nothing remembered lands with Curriculum Admin hidden when Summer is active. All phases are marked execution-ready. Execution waits for Christie's go-ahead. Codex didn't review this plan (out of credits); all three rounds were Claude.
1014:   298	  <strong>Sep 29, 2026: revision 3, after round-2 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r2-claude.md</code>).</strong> Round 2 found the write shape safe and listed five blockers, all verified and taken:
2139:   941	      block: lesson.block,
2153:   955	      status: isAdmin ? 'Resolved' : 'Open',
2232:   659	      // NOTE: 'classbook' (plain teacher) access is intentionally NOT
2256:A new blocker has emerged in Phase 2: leaving the prior switch record untouched when the checkbox is unticked can later reactivate an old “switch everyone” instruction. I’m tracing that alongside the destructive weekly-delete sequence and the test restore mechanics before giving the verdict.
2338:e2e/day-off-camps.spec.js:323:    await page.evaluate(({ id }) => curriculumDb.collection('dayOffCamps_camps').doc(id).update({ projects: { '2026-11-23': { block1: 'Clay Creatures' }, '2026-11-24': { block1: 'Glaze Day' } } }), { id: camp.id });
2341:e2e/day-off-camps.spec.js:329:    expect((await page.evaluate(({ id }) => __sdocT.read('camps', id), { id: camp.id })).projects['2026-11-24']).toEqual({ block1: 'Glaze Day' });
2342:e2e/day-off-camps.spec.js:547:    const cell = (d, b) => page.locator(`#sdoc-camp-projects textarea[data-date="${d}"][data-block="${b}"]`);
2346:e2e/day-off-camps.spec.js:586:    const r = await attempt(page, ({ Y, camp }) => saveDayOffCamp(Y, { ...camp, projects: { '2026-11-23': { block1: 'Clay Creatures', block2: '—', openStudio: 'Open Studio' } } }, camp), { Y, camp });
2373:e2e/day-off-teacher.spec.js:64:    teachers: ['TESTteacher3'], dates: ['2026-11-23'], projects: { '2026-11-23': { block1: 'Canvas' } }, notes: '',
2375:e2e/day-off-teacher.spec.js:351:    const renamed = { ...camp, projects: { ...camp.projects, '2026-11-23': { block1: 'Clay Art', openStudio: 'Open Studio' }, '2026-11-25': { block1: 'Clay Art' } } };
2377:e2e/day-off-teacher.spec.js:590:      projects: { '2026-11-23': { block1: `TEST ${evil}` } }, notes: '',
2378:e2e/day-off-teacher.spec.js:740:      projects: { '2026-11-23': { block1: 'Canvas', block2: 'N/A', openStudio: 'none' }, '2026-11-24': { block1: '-' } }, notes: '',
2384:e2e/day-off-materials.spec.js:159:    const projects = { ...current.projects, '2026-11-25': { block1: 'Clay Creatures', block2: 'TEST Beads' } };
2388:e2e/day-off-materials.spec.js:195:    const clash = { ...current.projects, '2026-11-23': { block1: 'TEST Taken', block2: 'Open Studio' }, '2026-11-25': { block1: 'TEST Taken' } };
2392:e2e/day-off-materials.spec.js:289:      await curriculumDb.collection('dayOffCamps_camps').doc(id).update({ 'projects.2026-11-25': { block1: 'Clay Creatures', block2: 'TEST Late' } });
2393:e2e/day-off-materials.spec.js:310:    const projects = { '2026-11-23': { block1: 'Clay Critters', block2: 'Open Studio' }, '2026-11-24': { block1: 'Glaze Day', block2: 'Open Studio' }, '2026-11-25': { block1: 'Clay Critters' } };
2405:e2e/day-off-materials.spec.js:1027:    const camp = await makeCamp(planner, ev.id, { projects: { '2026-11-23': { block1: 'Clay Creatures', block2: 'N/A', openStudio: 'n/a' }, '2026-11-24': { block1: 'none', block2: '-' }, '2026-11-25': { block1: 'Clay Creatures' } } });
2408:e2e/day-off-materials.spec.js:1052:    const c2 = await makeCamp(planner, ev2.id, { dates: ['2026-12-21'], projects: { '2026-12-21': { block1: 'Clay Creatures', block2: 'n/a' } } });
2409:e2e/day-off-materials.spec.js:1055:    const r2 = await attempt(planner, ({ Y, cur, projects }) => saveDayOffCamp(Y, { ...cur, projects }, cur), { Y, cur: cur2, projects: { '2026-12-21': { block1: 'Clay Creatures', block2: 'Glaze Art' } } });
2559:    16	 * as a signed-in user's would — this does NOT bypass rules.
2751:    55	async function blockProductionFirebase(page) {
2754:    58	    return route.abort('blockedbyclient');
2770:    74	      `[login] page is NOT in emulator mode (flag=${state.flag}, firebase project=${state.project}, expected ${PROJECT_ID}). ` +
2779:    83	  await blockProductionFirebase(page);
2791:    95	  await blockProductionFirebase(page);
3575:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-data-safety-remaining-stages.html:2345:        <li><strong>Phase 18 (block ambiguous "summer-" semester keys), added Aug 15, 2026 (round 8, Christie's explicit scope decision), corrected same day (round 9):</strong> attempt to create a semester named "Summer Enrichment 2027" via the real UI form, confirm it's rejected with a clear alert and <code>saveConfig()</code> is never called (spy/count) — the test that would have caught the underlying misrouting this blocks. A second test: create a semester named "End of Summer Showcase" (key <code>end-of-summer-showcase</code>, doesn't start with "summer-" after slugification), confirm it succeeds normally. A third test: create an ordinary semester with no relation to "Summer" at all, confirm no change in behavior from today's shipped success path. A round-9 boundary test: create semesters named "Summer2027" and "Summer" alone (slugify to <code>summer2027</code> and <code>summer</code> — neither starts with the literal <code>"summer-"</code> prefix), confirm both are ALLOWED, since neither actually collides with the deep functions' routing check. Not an automated test, but noted here as a one-time manual step before this phase deploys: confirm via the real Firestore console that <code>curriculum/appData</code>'s <code>semesters</code> map contains no pre-existing <code>"summer-"</code>-prefixed key other than <code>summer-2026</code> — this phase's guard is go-forward only and cannot detect or repair one that already exists (round 9, Codex).</li>
3576:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-data-safety-remaining-stages.html:2376:  <li><strong>The Idea Bank's five remaining <code>curriculum/futureProjects</code> writers, plus a broader "shared document/array last-write-wins" vulnerability class found in unrelated features — found Aug 15, 2026 (round 10), deliberately NOT fixed here, moved to a dedicated follow-on plan.</strong> <code>saveNewIdea()</code>, <code>saveIdeaEdit()</code>, <code>deleteIdeaProject()</code>, <code>archiveIdeaProject()</code>, and <code>unarchiveIdeaProject()</code> (all <code>app.js:5305-5383</code>) still overwrite the entire <code>futureProjects</code> document via a local read-modify-write, meaning Phase 13's <code>arrayRemove()</code> fix (see its own danger box's round-10 correction) only closes part of the Idea Bank's exposure, not all of it — unlike Cut Bank, which round 10 confirmed is genuinely, completely closed. The same round also found this exact vulnerability class — a shared config/array document trusted from a stale local cache and overwritten wholesale — in <code>curriculum/appData</code> (Settings/semester create-delete-publish, <code>firebase-data.js:79-85</code>, live callers include <code>saveSettings()</code>, <code>createNewSemester()</code>, <code>deleteSemester()</code>), the Prep Dashboard's weekly autosave (<code>savePrepWeekData()</code>, <code>firebase-data.js:145-162</code>, including a <code>classAssociations</code> array), Prep Cycle configuration (<code>savePrepCycleConfig()</code>, <code>firebase-data.js:313-321</code>), and (lower-stakes, self-healing) diagnostic dismissals (<code>saveDiagDismissals()</code>, <code>firebase-data.js:636-648</code>). <strong>This is a genuinely distinct vulnerability class from Vulnerability #11</strong> — shared config/array documents, not lesson content — reaching well beyond this plan's scope (Vulnerability #11 Layer 1 plus the explicitly-approved delete/archive-completeness cluster, Phases 15-18). Christie's explicit decision, discussed directly rather than assumed: address this comprehensively in its own dedicated plan, covering the whole app deliberately rather than the incidentally-discovered subset found here, using the same Codex+Claude review-loop rigor from round one. See <code>classbook-shared-document-concurrency-plan.html</code> (<code>plan_DsqEjQ-LAziY</code>) — created the same session, immediately after this decision, specifically so it has independent existence rather than being only a paragraph here. <strong>That plan is scoping-only as of Aug 15, 2026</strong> — it documents these six known instances and the decision that led to it, but its own comprehensive sweep and phase design have not started. Corrected Aug 15, 2026 (round 11, both reviewers) after this text briefly said the plan "doesn't exist yet," which became stale the moment the file was created later in the same session.</li>
3708:    29	let authResolvedUid = null;  // Track which UID the app initialized with
3726:    47	      if (user && authResolvedUid && user.uid !== authResolvedUid) {
3780:   101	        authResolvedUid = user.uid;
3882:   114	const blockCell = (page, camp, date, block) =>
3883:   115	  page.locator(`.sdoc-tv-camp[data-camp-id="${camp.id}"] .sdoc-tv-day[data-date="${date}"] .sdoc-tv-block[data-block="${block}"]`);
4026:    56	  <p><strong>Concrete failure:</strong> Admin A pastes idea X from the bank (a plain <code>.set()</code> of the post-removal array, same as every other writer here — NOT an atomic <code>arrayRemove()</code>, see the correction above). Admin B, in a separate tab with a snapshot loaded before A's removal propagated, archives, edits, deletes, or adds a <em>different</em> idea moments later — B's full-array overwrite silently resurrects X. <code>deleteIdeaProject()</code> is the direct sibling of the companion plan's already-fixed <code>deleteCutProject()</code> — same shape, same likely fix (<code>FieldValue.arrayRemove()</code>) — and <code>pasteFromIdeaBank()</code>'s own removal step is now effectively a second instance of that exact same sibling shape. <code>saveNewIdea()</code>/<code>saveIdeaEdit()</code> would need care: an "edit" mutates an existing array element in place, so the fix isn't a simple append/remove — it likely needs the element's stable identity (an id field, if one exists — check <code>app.js:5317</code>'s id-generation convention, already referenced elsewhere in the companion plan) to target a transaction or a keyed sub-collection instead of an in-array edit, since Firestore's array transforms can't update one element by identity — only add or remove whole elements.</p>
4027:    57	  <p><strong>Reachability note (open question, not yet checked):</strong> is Idea Bank reachable for summer semesters, the way Cut Bank/Copy Plan were checked and found NOT reachable in the companion plan? Verify before assuming these five fixes need the same "non-summer only" framing.</p>
4030:    60	  <p><strong>File:</strong> <code>js/firebase-data.js</code>, <code>saveConfig(config)</code> (79-85) — an unconditional <code>.set(config)</code> of the ENTIRE config document. <strong>Live callers:</strong> <code>saveSettings()</code> (<code>app.js:9249-9286</code> — deep-copies the whole cached config, replaces one semester's fields including array fields like <code>breakWeeks</code>/<code>closureDates</code>/<code>teacherNames</code>, overwrites the whole document), plus semester creation, deletion, and publish-toggling (all touched by the companion plan's Phases 15/18, which did NOT address this underlying overwrite pattern — those phases fixed different bugs in the same functions). <code>setupConfigListener()</code> exists in the codebase but is never called anywhere — confirmed via grep — so the local config cache has no live-refresh mechanism at all.</p>
4032:    62	  <p><strong>Relationship to companion plan:</strong> Phase 15 (semester delete) and Phase 18 (block ambiguous semester keys) both touch <code>deleteSemester()</code>/<code>createNewSemester()</code>, which both go through this same <code>saveConfig()</code> path — but neither phase addresses THIS race (they fix different, narrower bugs in the same functions). Worth checking during design whether a fix here needs to be coordinated with those phases' pseudocode rather than designed in isolation.</p>
4176:    16	## High — these block or mislead
4225:## Verdict: NOT EXECUTION-READY
4229:### 1. Unticking “switch everyone” can reactivate an old switch
4244:### 2. “Once per browser” does not mean “switch every user”
4258:### 3. Weekly deletion remains non-atomic and lacks the required snapshot
4279:### 4. Activation trusts stale local config and can create a ghost active semester
4294:### 5. The e2e plan contains two impossible/contradictory scenarios
4309:### Other checks
4317:## Verdict: NOT EXECUTION-READY
4321:### 1. Unticking “switch everyone” can reactivate an old switch
4336:### 2. “Once per browser” does not mean “switch every user”
4350:### 3. Weekly deletion remains non-atomic and lacks the required snapshot
4371:### 4. Activation trusts stale local config and can create a ghost active semester
4386:### 5. The e2e plan contains two impossible/contradictory scenarios
4401:### Other checks

ERROR: Your workspace is out of credits. Add credits to continue.
ERROR: Your workspace is out of credits. Add credits to continue.
tokens used
114,454
