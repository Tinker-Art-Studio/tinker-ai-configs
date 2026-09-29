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


exec
/bin/zsh -lc "rg -n \"serverSemesterKeys|assertSemesterStillExists|pending|unconfirmed|fromCache|includeMetadataChanges|lessonData writer|seven|acorn|doc\\(['\\\"]lessonData|collection\\(['\\\"]curriculum['\\\"]\\).*lessonData|lessonDataRef|batch\\.|transaction\\.|tx\\.|\\.set\\(|\\.update\\(\" /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html js index.html --glob '"'!node_modules/**'"' && rg -n \"<script["'^>]+src=" index.html' in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:101:  <li>New <code>makeSemesterActive(key)</code> beside <code>toggleSemesterPublish</code>. Eligibility is by type (<code>isWeeklySemester(key) || isCampSeason(key)</code>), never by key prefix (there's a ratchet against prefix routing). It refuses if the user isn't admin/manager, or the key is missing or already active. It checks <code>isPublishableType(key)</code> before any auto-publish, so the two gates can't drift. The old semester's name falls back to its key if the name is missing. Then it confirms through <code>confirmModal</code> (built in this phase, so Phase 2 only adds the checkbox and the activation tests aren't rewritten), then writes through a new <code>activateSemesterTx(key, expectedActive, { publish, switchEveryone })</code> in <code>firebase-data.js</code> (Codex finding 4). It's one <code>runTransaction</code> that re-reads appData from the server and refuses, with "reload and try again", unless <code>semesters[key]</code> still exists with a name and an eligible type, and <code>activeSemester === expectedActive</code> (what the confirmation showed). Only then does it <code>tx.update</code> <code>activeSemester</code>, the publish flag if needed, the Phase 2 switch field, and <code>lastUpdated</code>/<code>lastUpdatedBy</code>. This way a stale tab can't point "active" at a semester another tab deleted, or recreate a half-semester through the dotted publish path. It honours the same guards as <code>updateAppData</code>. <code>currentConfig</code> changes only after the commit succeeds; on failure nothing local changes.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:108:      <li>New <code>deleteWeeklySemesterTx(key)</code> in <code>firebase-data.js</code>: one <code>runTransaction</code> (the house pattern, e.g. <code>firebase-data.js:2452</code>) that re-reads <strong>both</strong> appData and lessonData, and verifies that <code>semesters[key]</code> still exists, <code>activeSemester !== key</code>, and <code>lessonData[key]</code> is deep-equal to the snapshot just downloaded. If anyone saved a lesson in that semester since, it refuses ("lessons changed while you were deleting — reload and try again"), so the snapshot always matches exactly what was deleted. Saves to <em>other</em> semesters touch the same document, so Firestore may retry the transaction. Its built-in retries are fine for a rare manual delete, and if they run out, nothing is deleted and the alert says so. It then <code>tx.update</code>s appData (<code>semesters.&lt;key&gt;</code> delete, plus <code>lastUpdated</code>/<code>lastUpdatedBy</code>) and lessonData (<code>&lt;key&gt;</code> delete). It honours <code>updateAppData</code>'s guards (<code>configLoadFailed</code>, season registry).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:110:    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs are prevented, not accepted</strong> (Codex round 3). A new, narrow <code>onSnapshot</code> on <code>curriculum/appData</code> keeps only a set <code>serverSemesterKeys</code>, and deliberately does <em>not</em> replace <code>currentConfig</code>, so no other behaviour changes. Every writer to <code>curriculum/lessonData</code> calls <code>assertSemesterStillExists(semKey)</code> before writing. The complete list at <code>2ef2e62</code>:
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:113:(<code>deleteLessonData</code> :963 is replaced for weekly deletes by <code>deleteWeeklySemesterTx</code>. Everything else that touches <code>doc('lessonData')</code> only reads: :762, :975, :1171, <code>app.js</code>:5835, :7518.) A <strong>static ratchet</strong> in the new spec (acorn, like <code>static-checks.spec.js</code>) fails if any function in a loaded script that writes through <code>doc('lessonData')</code> (<code>update</code>/<code>set</code>/<code>batch</code>/<code>tx</code>) isn't in that list, or doesn't call the assertion.
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:114:<br><strong>Fail-closed states</strong> for <code>serverSemesterKeys</code>. The listener uses <code>includeMetadataChanges: true</code>, and <code>assertSemesterStillExists</code> reads this state:
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:116:  <li><code>pending</code> (no server-confirmed snapshot yet): refuse with "Still connecting — try again in a moment." In practice saves come well after load.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:117:  <li><code>confirmed</code> (latest snapshot <code>fromCache === false</code>): allow if the key is present. If it's absent: "This semester was deleted — reload."</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:118:  <li><code>unconfirmed</code> (latest snapshot <code>fromCache === true</code>, i.e. offline): refuse with "You appear to be offline — nothing was saved. Reconnect and try again." <strong>This is a behaviour change:</strong> today an offline save's <code>await</code> just hangs until reconnection while Firestore queues it, and that queued write could land in a since-deleted semester. Refusing clearly is safer.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:216:  Given the latest snapshot is fromCache (offline, simulated via the stubbed listener)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:223:Scenario: every lessonData writer is guarded (ratchet)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:225:  Then every function that writes doc('lessonData') is in the guarded list and calls assertSemesterStillExists
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:388:  <strong>Sep 29, 2026: revision 7, after Codex round 4 (<code>…-codex-r4.md</code>).</strong> Codex confirmed the listener approach (<code>currentConfig</code> untouched) and resolved key reuse and the snapshot list. Taken: (1) an explicit list of all seven lessonData writers, including three in <code>app.js</code> (Q&amp;A and help replies) and <code>deleteLessonKey</code>, plus an acorn ratchet so a new writer can't skip the guard; (2) fail-closed <code>pending</code>/<code>unconfirmed</code>/<code>error</code> states with tests. <strong>Behaviour change for Christie:</strong> lesson saves while offline are refused with a clear message instead of hanging and queueing.
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:391:  <strong>Sep 29, 2026: revision 6, after Codex round 3 (<code>…-codex-r3.md</code>).</strong> Snapshot contents are confirmed resolved, and the acceptance list now matches. Revision 5's "accept stale-tab orphans; the create pre-check catches them" was wrong: that pre-check runs only with "Copy from", and no-copy creation adopts leftovers by design. Replaced with prevention: a narrow appData listener tracks only the server's semester keys (it never replaces <code>currentConfig</code>), and every weekly lessonData writer checks the key still exists. The no-copy create path now tells the manager how many leftover lessons it will adopt.
js/app.js:608:// against the fresh camp inside the save's transaction. The classbook key is
js/app.js:1764:          const pending = dayOffPlanCompleteInFlight.has(`${yearKey}|${lessonKey}`);
js/app.js:1770:            <label class="sdoc-tv-pc"><input type="checkbox" class="sdoc-tv-pc-cb" data-lesson-key="${sdocEscA(lessonKey)}" ${slot.planComplete ? 'checked' : ''} ${editable && !pending ? '' : 'disabled'} onchange="toggleDayOffPlanComplete(this)"> Plan complete</label>
js/app.js:3244:  // Save handler. A manual save cancels any pending autosave — otherwise the
js/app.js:3303:          photoInput.dataset.pendingRemove = 'true';
js/app.js:3306:        photoInput.dataset.pendingRemove = '';
js/app.js:3321:      photoInput2.dataset.pendingRemove = 'true';
js/app.js:3447:  const pendingRemove = photoInput?.dataset?.pendingRemove === 'true';
js/app.js:3449:  if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) {
js/app.js:3486:    } else if (pendingRemove && originalLesson.photoUrl) {
js/app.js:3537:    // pending selection so this modal's autosave doesn't re-upload the same
js/app.js:3541:    if (pendingRemove && photoInput) photoInput.dataset.pendingRemove = '';
js/app.js:3608:// landed since this modal opened. Now a single targeted .update() touching
js/app.js:3690:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
js/app.js:3816:      projects.set(`${data.campTopic}|||${data.projectTitle}|||${data.block}`, lessonKey);
js/app.js:5397:// Event here, hence the strict check) is refused while a save is pending:
js/app.js:5505:      ${l.photoUrl ? `<div id="ca-edit-photo-preview" style="margin-bottom:8px">${safeHttpUrl(l.photoUrl) ? `<img src="${escAttr(safeHttpUrl(l.photoUrl))}" style="max-height:150px;border-radius:8px;border:1px solid var(--border-light)"><br>` : ''}<button type="button" class="te-photo-remove-btn" style="position:static;margin-top:4px" onclick="document.getElementById('ca-edit-photo-preview').remove();document.getElementById('ca-edit-photo-input').dataset.pendingRemove='true'">Remove photo</button></div>` : ''}
js/app.js:5564:    alert('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
js/app.js:5622:  let pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
js/app.js:5625:  if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) {
js/app.js:5675:      pendingRemove = photoInput?.dataset?.pendingRemove === 'true' && !!existing.photoUrl;
js/app.js:5699:      alert(`Summer camp ${refused.map(f => labels[f]).join(', ')} are managed in the Summer Camp App — that change is not saved here.` + (changedFields.length > refused.length || hasNewPhoto || pendingRemove ? ' Your other edits will still be saved.' : ''));
js/app.js:5707:      if (changedFields.length === 0 && !hasNewPhoto && !pendingRemove) { closeAdminModal(true); return; }
js/app.js:5739:    } else if (pendingRemove) {
js/app.js:5835:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
js/app.js:5845:// machine loop; closing it fully would need a Firestore transaction.
js/app.js:6309:    await curriculumDb.collection('curriculum').doc('cutProjects').set({
js/app.js:6500:    await curriculumDb.collection('curriculum').doc('cutProjects').set({
js/app.js:6622:    await curriculumDb.collection('curriculum').doc('cutProjects').set({
js/app.js:6968:  // NOT closed here: this is still a plain saveFutureProjects() .set(), the
js/app.js:7131:// one in the reply. Now a single targeted Firestore .update() touching only
js/app.js:7202:    : curriculumDb.collection('curriculum').doc('lessonData');
js/app.js:7205:    await docRef.update(updates);
js/app.js:7285:    : curriculumDb.collection('curriculum').doc('lessonData');
js/app.js:7288:    await docRef.update(updates);
js/app.js:7518:  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
js/app.js:7685:      projectMap[normTitle].uniqueClasses.set(classKey, students);
js/app.js:10852:let pendingSemesterTypeStamps = null;
js/app.js:10876:  pendingSemesterTypeStamps = null;
js/app.js:10888:    pendingSemesterTypeStamps = { stamps, serverConfig };
js/app.js:10900:  if (!pendingSemesterTypeStamps) { stampOutput('Run the dry run first.'); return; }
js/app.js:10901:  const { stamps, serverConfig } = pendingSemesterTypeStamps;
js/app.js:10945:    pendingSemesterTypeStamps = null;
js/app.js:11462:// How long Close waits for a pending save before offering to leave without it.
js/app.js:11745:          photoInput.dataset.pendingRemove = 'true';
js/app.js:11748:        photoInput.dataset.pendingRemove = '';
js/app.js:11763:      photoInput2.dataset.pendingRemove = 'true';
js/app.js:11785:  let pendingSaves = 0;
js/app.js:11801:    // A save is starting — a pending autosave would only redo this work
js/app.js:11809:    pendingSaves++;
js/app.js:11825:      .finally(() => { pendingSaves--; });
js/app.js:11830:    summerLessonSaveChains.set(chainKey, chained);
js/app.js:11901:      const pendingRemove = photoInput?.dataset?.pendingRemove === 'true';
js/app.js:11915:      } else if (pendingRemove && lesson.photoUrl) {
js/app.js:11936:      const photoChanged = hasNewPhoto || (pendingRemove && lesson.photoUrl);
js/app.js:12007:      // The photo change is persisted — clear the pending selection so the
js/app.js:12013:      if (pendingRemove && photoInput) photoInput.dataset.pendingRemove = '';
js/app.js:12127:    if (pendingSaves === 0) { closing = true; finishClose(); return; }
js/app.js:12259:      projectsMap.set(key, lesson);
js/app.js:13205:      <td>${ticker ? `<input type="checkbox" ${tick ? 'checked' : ''} ${pendingDayOffTicks.has(`${dayOffLessonKey(v.yearKey, v.campId, v.title)}|${it.id}`) ? 'disabled' : ''} title="${tick ? sdocEscA(`Ticked by ${tick.by}`) : 'Tick when prepped'}" onchange="tickDayOffMaterial(this.closest('tr').dataset.id, this.checked, this)">` : (tick ? '✓' : '')}</td>
js/app.js:13276:const pendingDayOffTicks = new Set();
js/app.js:13279:  const pending = v && `${dayOffLessonKey(v.yearKey, v.campId, v.title)}|${id}`;
js/app.js:13280:  if (!v || pendingDayOffTicks.has(pending)) return;
js/app.js:13281:  pendingDayOffTicks.add(pending);
js/app.js:13290:    pendingDayOffTicks.delete(pending);
js/app.js:13383:      jobs.push(refreshDayOffSignoff(yearKey, camp.id).catch(err => { view.signoffErrors.set(camp.id, err.message); }));
js/app.js:13386:        jobs.push(readDayOffPlan(yearKey, camp.id, title).catch(err => { view.readErrors.set(key, err.message); }));
js/app.js:13430:          <td><input type="checkbox" ${tick ? 'checked' : ''} ${dis} ${pendingDayOffTicks.has(`${key}|${it.id}`) ? 'disabled' : ''} title="${tick ? sdocEscA(`Ticked by ${tick.by}`) : 'Tick when prepped'}" onchange="tickDayOffEventMaterial(this)"></td>
js/app.js:13484:  const pending = `${key}|${itemId}`;
js/app.js:13485:  if (pendingDayOffTicks.has(pending)) return;
js/app.js:13486:  pendingDayOffTicks.add(pending);
js/app.js:13497:    pendingDayOffTicks.delete(pending);
js/app.js:13500:  if (error) v.tickErrors.set(campId, error); else v.tickErrors.delete(campId);
js/auth-guard.js:83:            await userDocRef.set(newUserData);
js/firebase-data.js:57:// shared curriculum/lessonData document). The seven sites that choose between
js/firebase-data.js:232:    await ref.update(payload);
js/firebase-data.js:237:    await ref.set(nestFieldPaths(payload), { merge: true });
js/firebase-data.js:435:    if (snap?.metadata?.fromCache) return;
js/firebase-data.js:461:    currentSeasonDocRef().onSnapshot({ includeMetadataChanges: true }, next, error));
js/firebase-data.js:562:    await docRef.update(updateObj);
js/firebase-data.js:568:      await docRef.set(nested);
js/firebase-data.js:581:    await docRef.update(updateObj);
js/firebase-data.js:586:      await docRef.set(nested);
js/firebase-data.js:727:  await curriculumDb.collection('curriculum').doc('prepCycleConfig').set(toSave);
js/firebase-data.js:762:    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
js/firebase-data.js:804:    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
js/firebase-data.js:817:  await curriculumDb.collection('curriculum').doc('lessonData').set({
js/firebase-data.js:830:  await curriculumDb.collection('curriculum').doc('lessonData').update({
js/firebase-data.js:866:    batch.set(docRef, cleanData, { merge: true });
js/firebase-data.js:870:  await batch.commit();
js/firebase-data.js:896:    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
js/firebase-data.js:904:  await curriculumDb.collection('summerCamps_campComplete').doc(summerDocIdFor(semKey, `${teacher}|||${campName}`)).set({
js/firebase-data.js:936:    await docRef.set({
js/firebase-data.js:953:    await docRef.update({
js/firebase-data.js:963:  await curriculumDb.collection('curriculum').doc('lessonData').update({
js/firebase-data.js:975:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
js/firebase-data.js:985:  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
js/firebase-data.js:995:  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
js/firebase-data.js:1063:      displacedSummerServerCopies.set(displacedKey(semKey, key), fresh[key]);
js/firebase-data.js:1171:  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
js/firebase-data.js:1172:    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
js/firebase-data.js:1174:      if (doc.metadata.fromCache && !doc.metadata.hasPendingWrites) {
js/firebase-data.js:1178:      console.log('📚 Lesson data snapshot received, from cache:', doc.metadata.fromCache, 'exists:', doc.exists);
js/firebase-data.js:1215:  await curriculumDb.collection('curriculum').doc('cutProjects').set({
js/firebase-data.js:1239:  await curriculumDb.collection('curriculum').doc('futureProjects').set({
js/firebase-data.js:1277:    await curriculumDb.collection('curriculum').doc('changeLog').set({
js/firebase-data.js:1308:    await curriculumDb.collection('curriculum').doc('diagnosticDismissals').set(dismissals);
js/firebase-data.js:1321:// resolve from local cache, which reflects a pending write optimistically
js/firebase-data.js:1366:    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
js/firebase-data.js:1414:    await docRef.set(cleanData, { merge: true });
js/firebase-data.js:1438:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
js/firebase-data.js:1469:// whole-lesson deletes into ONE atomic Firestore .update() call — either
js/firebase-data.js:1477:    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
js/firebase-data.js:1500:  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
js/firebase-data.js:1614:        ctx.drawImage(img, 0, 0, w, h);
js/firebase-data.js:1987:    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
js/firebase-data.js:2065:      seen.set(title, label);
js/firebase-data.js:2335:    await ref.set(payload);
js/firebase-data.js:2359:  await coll.doc(original.id).update({ ...updates, ...dayOffStamp('updated') });
js/firebase-data.js:2415:    await ref.set(payload);
js/firebase-data.js:2454:    const campSnap = await tx.get(campRef);
js/firebase-data.js:2456:    for (const m of moveRefs) moveSnaps.push([await tx.get(m.fromRef), await tx.get(m.toRef)]);
js/firebase-data.js:2457:    const signoffSnap = clearsSignoff ? await tx.get(signoffRef) : null;
js/firebase-data.js:2474:    tx.update(campRef, { ...updates, ...dayOffStamp('updated') });
js/firebase-data.js:2479:        tx.set(m.toRef, data);
js/firebase-data.js:2480:        tx.delete(m.fromRef);
js/firebase-data.js:2483:        tx.delete(m.toRef);   // an empty leftover under the new title — replaced by nothing
js/firebase-data.js:2486:    if (signoffSnap?.exists) tx.delete(signoffRef);   // planner-only path: a changed camp is no longer signed off
js/firebase-data.js:2547:    const campTx = await tx.get(campRef);
js/firebase-data.js:2549:    for (const r of refs) snaps.push(await tx.get(r));
js/firebase-data.js:2561:    tx.delete(campRef);
js/firebase-data.js:2562:    snaps.forEach(sn => { if (sn.exists) tx.delete(sn.ref); });
js/firebase-data.js:2690:      const campSnap = await tx.get(campRef);
js/firebase-data.js:2691:      await tx.get(planRef);
js/firebase-data.js:2700:      tx.set(planRef, data, { merge: true });
js/firebase-data.js:2806:    const campSnap = await tx.get(campRef);
js/firebase-data.js:2807:    const planSnap = await tx.get(planRef);
js/firebase-data.js:2823:    tx.set(planRef, {
js/firebase-data.js:2907:    const campSnap = await tx.get(campRef);
js/firebase-data.js:2908:    const planSnap = await tx.get(planRef);
js/firebase-data.js:2909:    const signoffSnap = await tx.get(signoffRef);
js/firebase-data.js:2917:      tx.update(planRef, { [`materialItems.${id}`]: item });
js/firebase-data.js:2919:      tx.set(planRef, { yearKey, eventId: camp.eventId, campId, projectTitle: title, materialItems: { [id]: item } });
js/firebase-data.js:2922:    if (listChanged && signoffSnap.exists) tx.delete(signoffRef);
js/firebase-data.js:2939:    const campSnap = await tx.get(campRef);
js/firebase-data.js:2940:    const planSnap = await tx.get(planRef);
js/firebase-data.js:2941:    const signoffSnap = await tx.get(signoffRef);
js/firebase-data.js:2947:    tx.update(planRef, { [`materialItems.${itemId}`]: del, [`materialChecks.${itemId}`]: del });
js/firebase-data.js:2948:    if (signoffSnap.exists) tx.delete(signoffRef);
js/firebase-data.js:2961:    const campSnap = await tx.get(campRef);
js/firebase-data.js:2962:    const snap = await tx.get(planRef);
js/firebase-data.js:2974:    if (Object.keys(updates).length) tx.update(planRef, updates);
js/firebase-data.js:2980:// transaction.update (never a set-merge, so a stale tick can't resurrect a
js/firebase-data.js:2989:    const campSnap = await tx.get(campRef);
js/firebase-data.js:2990:    const snap = await tx.get(planRef);
js/firebase-data.js:2995:    tx.update(planRef, { [`materialChecks.${itemId}`]: checked ? mark : firebase.firestore.FieldValue.delete() });
js/firebase-data.js:3038:    const campSnap = await tx.get(campRef);
js/firebase-data.js:3040:    for (const r of planRefs) snaps.push(await tx.get(r));
js/firebase-data.js:3041:    await tx.get(signoffRef);
js/firebase-data.js:3055:    tx.set(signoffRef, complete
js/firebase-data.js:3071:    const campSnap = await tx.get(campRef);
js/firebase-data.js:3072:    const planSnap = await tx.get(planRef);
js/firebase-data.js:3074:    if (planSnap.exists) tx.delete(planRef);
571:  <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-app-compat.js"></script>
572:  <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-auth-compat.js"></script>
573:  <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-firestore-compat.js"></script>
574:  <script src="https://www.gstatic.com/firebasejs/10.8.0/firebase-storage-compat.js"></script>
576:  <script src="js/firebase-config.js"></script>
577:  <script src="js/auth-guard.js"></script>
578:  <script src="js/firebase-data.js"></script>
579:  <script src="js/app.js"></script>

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html | sed -n '104,125p;204,230p' && nl -ba js/firebase-data.js | sed -n '35,75p;790,840p;1345,1510p' && nl -ba js/app.js | sed -n '3660,3710p;7110,7220p;7260,7300p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
   104	    <ol>
   105	      <li>Forced-server reads of everything keyed by the semester: <code>readServerSemesterLessonMap(key)</code>, <code>cutProjects[key]</code>, <code>changeLog[key]</code>, <code>prepData[key]</code>, <code>lessonData_backup[key]</code>, <code>diagnosticDismissals[key]</code> (<code>firebase-data.js:551, 979-995, 1212, 1267, 1286-1308</code>). Any rejection refuses. <code>null</code> means none and proceeds.</li>
   106	      <li>The modal (count, truthful text, typed name).</li>
   107	      <li>A JSON snapshot download: <code>classbook-&lt;key&gt;-snapshot-&lt;ISO&gt;.json</code> through a Blob link, containing <code>{ appDataEntry, lessons, cutProjects, changeLog, prepData, lessonDataBackup, diagnosticDismissals, takenAt, takenBy }</code>.</li>
   108	      <li>New <code>deleteWeeklySemesterTx(key)</code> in <code>firebase-data.js</code>: one <code>runTransaction</code> (the house pattern, e.g. <code>firebase-data.js:2452</code>) that re-reads <strong>both</strong> appData and lessonData, and verifies that <code>semesters[key]</code> still exists, <code>activeSemester !== key</code>, and <code>lessonData[key]</code> is deep-equal to the snapshot just downloaded. If anyone saved a lesson in that semester since, it refuses ("lessons changed while you were deleting — reload and try again"), so the snapshot always matches exactly what was deleted. Saves to <em>other</em> semesters touch the same document, so Firestore may retry the transaction. Its built-in retries are fine for a rare manual delete, and if they run out, nothing is deleted and the alert says so. It then <code>tx.update</code>s appData (<code>semesters.&lt;key&gt;</code> delete, plus <code>lastUpdated</code>/<code>lastUpdatedBy</code>) and lessonData (<code>&lt;key&gt;</code> delete). It honours <code>updateAppData</code>'s guards (<code>configLoadFailed</code>, season registry).</li>
   109	    </ol>
   110	    The old two-write path and its warn-only catch are removed for weekly semesters. <strong>Stale open tabs are prevented, not accepted</strong> (Codex round 3). A new, narrow <code>onSnapshot</code> on <code>curriculum/appData</code> keeps only a set <code>serverSemesterKeys</code>, and deliberately does <em>not</em> replace <code>currentConfig</code>, so no other behaviour changes. Every writer to <code>curriculum/lessonData</code> calls <code>assertSemesterStillExists(semKey)</code> before writing. The complete list at <code>2ef2e62</code>:
   111	<code>firebase-data.js</code>: <code>saveLessonData</code> (:802/817), <code>deleteLessonKey</code> (:827/830), <code>saveSingleLesson</code> weekly branch (:1364/1438), <code>saveMultipleLessonFields</code> (:1495/1500).
   112	<code>app.js</code>: <code>sendTeacherQaMessage</code> (:3690), <code>sendHelpResponse</code> (:7202), <code>sendQaReply</code> (:7285).
   113	(<code>deleteLessonData</code> :963 is replaced for weekly deletes by <code>deleteWeeklySemesterTx</code>. Everything else that touches <code>doc('lessonData')</code> only reads: :762, :975, :1171, <code>app.js</code>:5835, :7518.) A <strong>static ratchet</strong> in the new spec (acorn, like <code>static-checks.spec.js</code>) fails if any function in a loaded script that writes through <code>doc('lessonData')</code> (<code>update</code>/<code>set</code>/<code>batch</code>/<code>tx</code>) isn't in that list, or doesn't call the assertion.
   114	<br><strong>Fail-closed states</strong> for <code>serverSemesterKeys</code>. The listener uses <code>includeMetadataChanges: true</code>, and <code>assertSemesterStillExists</code> reads this state:
   115	<ul>
   116	  <li><code>pending</code> (no server-confirmed snapshot yet): refuse with "Still connecting — try again in a moment." In practice saves come well after load.</li>
   117	  <li><code>confirmed</code> (latest snapshot <code>fromCache === false</code>): allow if the key is present. If it's absent: "This semester was deleted — reload."</li>
   118	  <li><code>unconfirmed</code> (latest snapshot <code>fromCache === true</code>, i.e. offline): refuse with "You appear to be offline — nothing was saved. Reconnect and try again." <strong>This is a behaviour change:</strong> today an offline save's <code>await</code> just hangs until reconnection while Firestore queues it, and that queued write could land in a since-deleted semester. Refusing clearly is safer.</li>
   119	  <li><code>error</code> (listener error): refuse with "Couldn't confirm this semester — reload the page."</li>
   120	</ul>
   121	It refuses once the listener reports the key gone. The listener costs one read at load plus one per appData change. The remaining window, a save already in flight at the instant of deletion, is milliseconds wide. If it ever happens, the orphan fragment has no appData entry, so it's invisible. Key reuse is then covered both ways: with "Copy from", the existing server pre-check (<code>app.js:4913-4916</code>) refuses. Without it, re-creating deliberately <em>adopts</em> any leftover (<code>app.js:4910-4912</code>, by design, so a deleted semester can be restored), and Phase 1 adds a server read of that key to the no-copy path that shows "N leftover lessons will be adopted — continue?" when any exist. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
   122	  <li>Left alone on purpose: <code>app.js:5069-5074</code> and the <code>caCurrentSemester</code> assignment at <code>:4590</code> are dead code (round 2 confirmed that nothing reads them). This plan doesn't touch them.</li>
   123	  <li>The Curriculum Admin bar stays read-only for "active" (it's the same audience, but one place to change it is enough).</li>
   124	</ul>
   125	
   204	  Then it refuses, nothing is deleted, and the alert asks for a reload
   205	
   206	Scenario: a stale tab can't save into a deleted semester (safety, Codex round 3)
   207	  Given tab B is open on the weekly semester's lessons
   208	  When tab A deletes that semester
   209	  Then tab B's next lesson save refuses with "This semester was deleted — reload"
   210	   And lessonData has no key for that semester afterwards
   211	
   212	Scenario: fail-closed states (safety, Codex round 4)
   213	  Given the semester-keys listener has not delivered a server snapshot yet (stubbed)
   214	  When a lesson save runs
   215	  Then it refuses with "Still connecting", and no lessonData write is attempted
   216	  Given the latest snapshot is fromCache (offline, simulated via the stubbed listener)
   217	  Then a save refuses with the offline message
   218	  Given the listener errored
   219	  Then a save refuses with "reload the page"
   220	  Given a healthy confirmed snapshot containing the key
   221	  Then saves work exactly as today (existing suites stay green)
   222	
   223	Scenario: every lessonData writer is guarded (ratchet)
   224	  Given the loaded scripts
   225	  Then every function that writes doc('lessonData') is in the guarded list and calls assertSemesterStillExists
   226	
   227	Scenario: reusing a deleted key without "Copy from" says what it adopts (edge)
   228	  Given lessonData holds leftover lessons under a key with no appData entry
   229	  When a manager creates a semester with that key and no "Copy from"
   230	  Then a confirm states "N leftover lessons will be adopted"; cancel creates nothing
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

codex
The seven named application writers match the obvious direct calls. I’m checking indirect aliases and the metadata-state edge cases now, especially whether appData’s own latency-compensated events can be mistaken for offline state.
exec
/bin/zsh -lc "rg -n -C 3 \"lessonData\" js/firebase-config.js js/auth-guard.js js/firebase-data.js js/app.js | sed -n '1,1200p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
js/firebase-data.js-4-// Document pattern:
js/firebase-data.js-5-//   curriculum/appData     — semester config (URLs, GIDs, settings)
js/firebase-data.js-6-//   curriculum/prepData    — prep team data by semester/week
js/firebase-data.js:7://   curriculum/lessonData  — all lesson content by semester (imported from classbooks)
js/firebase-data.js-8-//   curriculum/cutProjects — projects removed from schedule, saved for reuse
js/firebase-data.js-9-//   curriculum/changeLog   — audit trail of moves/swaps/cuts
js/firebase-data.js-10-
js/firebase-data.js-11-let curriculumDb = null;
js/firebase-data.js-12-let configUnsubscribe = null;
js/firebase-data.js-13-let prepDataUnsubscribe = null;
js/firebase-data.js:14:let lessonDataUnsubscribe = null;
js/firebase-data.js-15-
js/firebase-data.js-16-// The content fields a lesson's stripping/hasContent/wipe-detection logic
js/firebase-data.js-17-// treats as "real plan content" (as opposed to metadata like teacher/weekNum).
--
js/firebase-data.js-53-function isWeeklySemester(semKey) { return semesterTypeOf(semKey) === SEMESTER_TYPES.weekly; }
js/firebase-data.js-54-
js/firebase-data.js-55-// Which lesson store a semester's lessons live in: 'camp' (one document per
js/firebase-data.js:56:// lesson in summerCamps_lessonData) or 'weekly' (one nested map inside the
js/firebase-data.js:57:// shared curriculum/lessonData document). The seven sites that choose between
js/firebase-data.js-58-// those two stores — the four lesson writers, the two admin reply writers and
js/firebase-data.js-59-// the existence check — all route through this, so a THIRD type is refused
js/firebase-data.js-60-// rather than treated as weekly: the reply writers' weekly branch update()s
--
js/firebase-data.js-125-let currentConfig = null;
js/firebase-data.js-126-let currentPrepData = null;
js/firebase-data.js-127-let currentLessonData = null;
js/firebase-data.js:128:let lessonDataLoadedSuccessfully = null; // null = not yet loaded, true = ok, false = failed
js/firebase-data.js-129-let currentCutProjects = null;
js/firebase-data.js-130-let currentChangeLog = null;
js/firebase-data.js-131-let currentFutureProjects = null;
--
js/firebase-data.js-161-//                                   creates the document via its merge-set)
js/firebase-data.js-162-//   • read FAILED (any error)     → loud: configLoadFailed, the red banner,
js/firebase-data.js-163-//                                   lesson data is never loaded, and
js/firebase-data.js:164://                                   lessonDataLoadedSuccessfully = false makes
js/firebase-data.js-165-//                                   every writer in the app refuse.
js/firebase-data.js-166-// Blast radius of that last branch is the whole app for every user, by design:
js/firebase-data.js-167-// loud beats silent when the alternative is writing over real configuration.
--
js/firebase-data.js-174-  } catch (err) {
js/firebase-data.js-175-    console.error('❌ Could not read curriculum/appData — refusing to guess at the configuration:', err);
js/firebase-data.js-176-    configLoadFailed = true;
js/firebase-data.js:177:    lessonDataLoadedSuccessfully = false;
js/firebase-data.js-178-    currentConfig = null;
js/firebase-data.js-179-    showConfigLoadErrorBanner(err);
js/firebase-data.js-180-  }
--
js/firebase-data.js-336-  // Any summer reload already in flight decided its filtering — and checked
js/firebase-data.js-337-  // this mode — before now. Bumping the generation makes those reloads stale,
js/firebase-data.js-338-  // so a load that started under the old mode cannot land its result, set
js/firebase-data.js:339:  // lessonDataLoadedSuccessfully = true and re-hide the banner this mode just
js/firebase-data.js-340-  // raised. (Found by the Phase 1 implementation review.)
js/firebase-data.js-341-  if (changed) globalListenerGeneration++;
js/firebase-data.js-342-  if (mode === 'error' || mode === 'unknown') {
js/firebase-data.js-343-    // A precondition, not a hint: loadSummerCampData() re-checks this, so a
js/firebase-data.js-344-    // later successful lesson-data load cannot quietly clear the banner.
js/firebase-data.js:345:    lessonDataLoadedSuccessfully = false;
js/firebase-data.js-346-    showSeasonRegistryBanner(mode, err);
js/firebase-data.js-347-  }
js/firebase-data.js-348-  return mode;
--
js/firebase-data.js-727-  await curriculumDb.collection('curriculum').doc('prepCycleConfig').set(toSave);
js/firebase-data.js-728-}
js/firebase-data.js-729-
js/firebase-data.js:730:// ─── Lesson Data (curriculum/lessonData) ─────────────
js/firebase-data.js-731-
js/firebase-data.js-732-// Every camp-season semester in the config, with the season each one reads.
js/firebase-data.js-733-// In legacy mode the 2026 season reads unfiltered (it is the only season that
--
js/firebase-data.js-759-async function loadLessonData() {
js/firebase-data.js-760-  if (!curriculumDb) initCurriculumFirestore();
js/firebase-data.js-761-  try {
js/firebase-data.js:762:    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
js/firebase-data.js-763-    currentLessonData = doc.exists ? doc.data() : {};
js/firebase-data.js-764-
js/firebase-data.js-765-    // Every camp season gets its own map (Phase 1, 1.4) — no literal key.
--
js/firebase-data.js-776-        currentLessonData[yearKey] = await loadDayOffCampData({ yearKey });
js/firebase-data.js-777-        console.log(`📚 ${yearKey}: ${Object.keys(currentLessonData[yearKey]).length} day-off camp plans`);
js/firebase-data.js-778-      }
js/firebase-data.js:779:      lessonDataLoadedSuccessfully = true;
js/firebase-data.js-780-    } catch (err) {
js/firebase-data.js-781-      // One season failing trips the guard for the whole app: a partially
js/firebase-data.js-782-      // loaded model is not a safe base for any writer, in any semester.
js/firebase-data.js-783-      console.error('❌ Could not load camp season data:', err);
js/firebase-data.js:784:      lessonDataLoadedSuccessfully = false;
js/firebase-data.js-785-    }
js/firebase-data.js-786-  } catch (err) {
js/firebase-data.js-787-    console.error('Error loading lesson data:', err);
js/firebase-data.js-788-    currentLessonData = {};
js/firebase-data.js:789:    lessonDataLoadedSuccessfully = false;
js/firebase-data.js-790-  }
js/firebase-data.js-791-  return currentLessonData;
js/firebase-data.js-792-}
--
js/firebase-data.js-800-// every caller treats a resolved promise as "the write landed" (backtracking
js/firebase-data.js-801-// audit, Phase 11).
js/firebase-data.js-802-async function saveLessonData(semesterKey, lessons) {
js/firebase-data.js:803:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js-804-    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
js/firebase-data.js-805-  }
js/firebase-data.js-806-  if (!curriculumDb) initCurriculumFirestore();
--
js/firebase-data.js-812-    return await saveSummerCampLessonData(semesterKey, lessons);
js/firebase-data.js-813-  }
js/firebase-data.js-814-
js/firebase-data.js:815:  // Regular semester: save to curriculum/lessonData
js/firebase-data.js-816-  const user = getAuthUser();
js/firebase-data.js:817:  await curriculumDb.collection('curriculum').doc('lessonData').set({
js/firebase-data.js-818-    [semesterKey]: lessons,
js/firebase-data.js-819-    lastUpdated: new Date().toISOString(),
js/firebase-data.js-820-    lastUpdatedBy: user?.name || 'Unknown'
--
js/firebase-data.js-827-async function deleteLessonKey(semesterKey, lessonKey) {
js/firebase-data.js-828-  if (!curriculumDb) initCurriculumFirestore();
js/firebase-data.js-829-  const user = getAuthUser();
js/firebase-data.js:830:  await curriculumDb.collection('curriculum').doc('lessonData').update({
js/firebase-data.js-831-    [`${semesterKey}.${lessonKey}`]: firebase.firestore.FieldValue.delete(),
js/firebase-data.js-832-    lastUpdated: new Date().toISOString(),
js/firebase-data.js-833-    lastUpdatedBy: user?.name || 'Unknown'
--
js/firebase-data.js-848-
js/firebase-data.js-849-  let writeCount = 0;
js/firebase-data.js-850-  // Save each lesson as a separate document (lessonKey as doc ID)
js/firebase-data.js:851:  for (const [lessonKey, lessonData] of Object.entries(lessons)) {
js/firebase-data.js-852-    // Never overwrite existing docs with empty content — protects against stale in-memory state
js/firebase-data.js:853:    if (!hasContent(lessonData)) continue;
js/firebase-data.js:854:    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
js/firebase-data.js-855-    // Strip empty content fields so stale in-memory empty strings never overwrite
js/firebase-data.js-856-    // real content that a teacher saved in a different browser session.
js/firebase-data.js:857:    const stripped = { ...lessonData };
js/firebase-data.js-858-    CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
js/firebase-data.js-859-    // JSON round-trip strips undefined values that Firestore rejects with invalid-argument
js/firebase-data.js-860-    const cleanData = JSON.parse(JSON.stringify({
--
js/firebase-data.js-892-// after a failed load the camp view was drawn from nothing, so its checkbox
js/firebase-data.js-893-// state is not something to write back.
js/firebase-data.js-894-async function saveCampComplete(semKey, teacher, campName, campComplete) {
js/firebase-data.js:895:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js-896-    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
js/firebase-data.js-897-  }
js/firebase-data.js-898-  if (!curriculumDb) initCurriculumFirestore();
--
js/firebase-data.js-922-// stamps `season`; a later message never re-stamps or moves a doc between
js/firebase-data.js-923-// seasons (the Summer Camp App's Season.patch() rule).
js/firebase-data.js-924-async function sendSummerLessonQaMessage(semKey, lessonKey, lesson, newMsg) {
js/firebase-data.js:925:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js-926-    throw new Error('Lesson data failed to load — refusing to send until it has. Reload and try again.');
js/firebase-data.js-927-  }
js/firebase-data.js-928-  if (!curriculumDb) initCurriculumFirestore();
--
js/firebase-data.js-960-
js/firebase-data.js-961-async function deleteLessonData(semesterKey) {
js/firebase-data.js-962-  if (!curriculumDb) initCurriculumFirestore();
js/firebase-data.js:963:  await curriculumDb.collection('curriculum').doc('lessonData').update({
js/firebase-data.js-964-    [semesterKey]: firebase.firestore.FieldValue.delete()
js/firebase-data.js-965-  });
js/firebase-data.js-966-}
js/firebase-data.js-967-
js/firebase-data.js:968:// Forced-server read of one semester's whole lesson map in curriculum/lessonData
js/firebase-data.js-969-// (null when absent). Bypasses both the in-memory model and the SDK cache —
js/firebase-data.js-970-// used where the local cache is known to be untrustworthy for this key, e.g.
js/firebase-data.js-971-// createNewSemester()'s pre-check (deleteSemester() drops a key locally even
js/firebase-data.js-972-// when its server-side delete failed). Backtracking audit, Phase 11.
js/firebase-data.js-973-async function readServerSemesterLessonMap(semesterKey) {
js/firebase-data.js-974-  if (!curriculumDb) initCurriculumFirestore();
js/firebase-data.js:975:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
js/firebase-data.js-976-  return snap.exists ? (snap.data()?.[semesterKey] ?? null) : null;
js/firebase-data.js-977-}
js/firebase-data.js-978-
--
js/firebase-data.js-982-  if (!existing || Object.keys(existing).length === 0) return 0;
js/firebase-data.js-983-  const count = Object.keys(existing).length;
js/firebase-data.js-984-  const user = getAuthUser();
js/firebase-data.js:985:  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
js/firebase-data.js-986-    [semesterKey]: existing,
js/firebase-data.js-987-    backupDate: new Date().toISOString(),
js/firebase-data.js-988-    backupBy: user?.name || 'Unknown'
--
js/firebase-data.js-992-
js/firebase-data.js-993-async function restoreFromBackup(semesterKey) {
js/firebase-data.js-994-  if (!curriculumDb) initCurriculumFirestore();
js/firebase-data.js:995:  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
js/firebase-data.js-996-  if (!backupDoc.exists) return null;
js/firebase-data.js-997-  const backupData = backupDoc.data();
js/firebase-data.js-998-  const lessons = backupData?.[semesterKey];
--
js/firebase-data.js-1009-  return Date.parse(lesson?.lastEditedAt || '') || 0;
js/firebase-data.js-1010-}
js/firebase-data.js-1011-
js/firebase-data.js:1012:// The fields a saved summerCamps_lessonData doc contributes to a lesson slot
js/firebase-data.js-1013-// (everything else on the slot — teacher, camp, materials, sharedWith, class
js/firebase-data.js-1014-// size… — is rebuilt from the other collections on every reload and must
js/firebase-data.js-1015-// always come from the fresh read).
--
js/firebase-data.js-1075-}
js/firebase-data.js-1076-
js/firebase-data.js-1077-// Backtracking audit Phase 7 (R2-10, R3-7, R4-10): every snapshot of the
js/firebase-data.js:1078:// shared curriculum/lessonData doc re-runs the summer collection reload.
js/firebase-data.js-1079-// Its outcome now drives the load-guard and the banner like the initial
js/firebase-data.js-1080-// load does — a failure trips them, a later success resets them — and only
js/firebase-data.js-1081-// the LATEST reload's outcome may do so: callbacks resolve out of order, and
--
js/firebase-data.js-1113-  console.log('📚 Setting up lesson data listener...');
js/firebase-data.js-1114-  if (!curriculumDb) initCurriculumFirestore();
js/firebase-data.js-1115-  globalListenerGeneration++; // whatever the previous listener still has in flight is now stale
js/firebase-data.js:1116:  if (lessonDataUnsubscribe) lessonDataUnsubscribe();
js/firebase-data.js-1117-
js/firebase-data.js-1118-  // One reload attempt for one snapshot generation. Only the latest
js/firebase-data.js-1119-  // generation may touch the guard, the banner, or the summer cache.
--
js/firebase-data.js-1140-        currentLessonData[plan.semKey] = mergeSummerReload(plan.semKey, previousSummer?.[plan.semKey], fresh[plan.semKey]);
js/firebase-data.js-1141-      }
js/firebase-data.js-1142-      console.log('📚 Camp seasons loaded:', plans.map(p => `${p.semKey}=${Object.keys(fresh[p.semKey]).length}`).join(' '));
js/firebase-data.js:1143:      lessonDataLoadedSuccessfully = true;
js/firebase-data.js-1144-      document.getElementById('lesson-load-error-banner')?.classList.add('hidden');
js/firebase-data.js-1145-      return 'ok';
js/firebase-data.js-1146-    } catch (err) {
js/firebase-data.js-1147-      console.error('❌ Could not load camp season / day-off camp data:', err);
js/firebase-data.js-1148-      if (!isCurrent()) return 'stale';
js/firebase-data.js:1149:      lessonDataLoadedSuccessfully = false;
js/firebase-data.js-1150-      document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
js/firebase-data.js-1151-      const delay = SUMMER_RELOAD_RETRY_DELAYS_MS[attempt];
js/firebase-data.js-1152-      if (delay !== undefined) {
--
js/firebase-data.js-1168-    return outcome;
js/firebase-data.js-1169-  };
js/firebase-data.js-1170-
js/firebase-data.js:1171:  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
js/firebase-data.js-1172-    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
js/firebase-data.js-1173-      // Skip cache-only updates
js/firebase-data.js-1174-      if (doc.metadata.fromCache && !doc.metadata.hasPendingWrites) {
--
js/firebase-data.js-1179-      if (!doc.exists) return;
js/firebase-data.js-1180-
js/firebase-data.js-1181-      const myGeneration = ++globalListenerGeneration;
js/firebase-data.js:1182:      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
js/firebase-data.js-1183-      // in their own collection, so carry their current maps across the swap
js/firebase-data.js-1184-      // and let the reload below refresh each one (Phase 1, 1.4).
js/firebase-data.js-1185-      const previousSummer = snapshotCampSeasons();
--
js/firebase-data.js-1358-// only means "don't touch this field," never "clear it"). These get
js/firebase-data.js-1359-// Firestore's FieldValue.delete() instead of silent omission, so a genuine
js/firebase-data.js-1360-// clear actually persists (Data Safety Plan Stage 3). This list is
js/firebase-data.js:1361:// authoritative: it overrides whatever (possibly stale) value lessonData
js/firebase-data.js-1362-// happens to carry for that key, since callers may still send the pre-edit
js/firebase-data.js-1363-// value alongside a separate clear signal (see saveLesson()'s contentUpdates).
js/firebase-data.js:1364:async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
js/firebase-data.js:1365:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js-1366-    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
js/firebase-data.js-1367-  }
js/firebase-data.js-1368-  if (!curriculumDb) initCurriculumFirestore();
js/firebase-data.js-1369-  const user = getAuthUser();
js/firebase-data.js:1370:  lessonData.lastEditedBy = user?.name || 'Unknown';
js/firebase-data.js:1371:  lessonData.lastEditedAt = new Date().toISOString();
js/firebase-data.js-1372-
js/firebase-data.js-1373-  // SDOC plans (Phase 2B) branch here — after the stamp, so every SDOC write
js/firebase-data.js-1374-  // (the narrow Plan complete one included) carries lastEditedBy/At — and
js/firebase-data.js-1375-  // BEFORE lessonStoreFor(), which keeps throwing for the type: its other six
js/firebase-data.js:1376:  // callers fall through to curriculum/lessonData on anything that isn't
js/firebase-data.js-1377-  // 'camp', and that throw is what keeps an SDOC key out of it.
js/firebase-data.js:1378:  if (isDayOffYear(semesterKey)) return saveDayOffPlan(semesterKey, lessonKey, lessonData, fieldsToClear, opts.dayOffAuth);
js/firebase-data.js-1379-
js/firebase-data.js-1380-  console.log('💾 Attempting to save lesson:', { semesterKey, lessonKey, user: user?.email });
js/firebase-data.js-1381-
js/firebase-data.js:1382:  const hasContent = lessonHasContent(lessonData);
js/firebase-data.js-1383-  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above.
js/firebase-data.js-1384-  const fieldsToActuallyClear = [...fieldsToClear];
js/firebase-data.js-1385-
--
js/firebase-data.js-1392-    // cleared (Data Safety Plan Stage 2C/3; photo fields added by the
js/firebase-data.js-1393-    // backtracking audit's Phase 10, whose summer editor now sends only the
js/firebase-data.js-1394-    // fields it changed — a photo replacement arrives with no text at all).
js/firebase-data.js:1395:    const hasPhotoField = 'photoUrl' in lessonData || 'photoPath' in lessonData;
js/firebase-data.js:1396:    if (!hasContent && !hasPhotoField && !('planComplete' in lessonData) && fieldsToActuallyClear.length === 0) {
js/firebase-data.js-1397-      console.warn('⛔ saveSingleLesson blocked — all content fields empty, refusing to overwrite:', lessonKey);
js/firebase-data.js-1398-      return;
js/firebase-data.js-1399-    }
js/firebase-data.js-1400-    // Strip empty content fields so stale in-memory empty strings never overwrite
js/firebase-data.js-1401-    // real content that a teacher saved previously (mirrors saveSummerCampLessonData).
js/firebase-data.js:1402:    const stripped = { ...lessonData };
js/firebase-data.js-1403-    CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
js/firebase-data.js-1404-    const cleanData = JSON.parse(JSON.stringify(stripped));
js/firebase-data.js-1405-    // Apply clears AFTER the JSON sanitization pass — FieldValue.delete() is a
--
js/firebase-data.js-1409-    // 0). A plain string, so it goes after the round-trip — and after the
js/firebase-data.js-1410-    // clears, so no clear list can ever strip the stamp.
js/firebase-data.js-1411-    cleanData.season = seasonForSemester(semesterKey);
js/firebase-data.js:1412:    console.log('💾 Saving Summer Camp lesson to summerCamps_lessonData:', lessonKey);
js/firebase-data.js:1413:    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semesterKey, lessonKey));
js/firebase-data.js-1414-    await docRef.set(cleanData, { merge: true });
js/firebase-data.js-1415-    console.log('✅ Saved Summer Camp lesson:', lessonKey);
js/firebase-data.js-1416-
--
js/firebase-data.js-1426-    return;
js/firebase-data.js-1427-  }
js/firebase-data.js-1428-
js/firebase-data.js:1429:  // Regular semester: curriculum/lessonData is one shared doc across every
js/firebase-data.js-1430-  // semester. update() with a whole object assigned to the bare
js/firebase-data.js-1431-  // semesterKey.lessonKey path replaces the ENTIRE lesson there — so write
js/firebase-data.js-1432-  // explicit per-field dotted paths instead, touching only the fields
js/firebase-data.js:1433:  // actually present in lessonData (Data Safety Plan Stage 2D).
js/firebase-data.js:1434:  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear);
js/firebase-data.js-1435-
js/firebase-data.js:1436:  console.log('💾 Saving to curriculum/lessonData with per-field paths:', Object.keys(updates));
js/firebase-data.js-1437-  try {
js/firebase-data.js:1438:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
js/firebase-data.js-1439-    console.log('✅ Successfully saved lesson to Firestore!');
js/firebase-data.js-1440-  } catch (error) {
js/firebase-data.js-1441-    console.error('❌ Error saving lesson:', error);
--
js/firebase-data.js-1444-}
js/firebase-data.js-1445-
js/firebase-data.js-1446-// Backtracking audit, Phase 9: pure helper — computes the dotted-path update
js/firebase-data.js:1447:// object for ONE lesson within the shared curriculum/lessonData document,
js/firebase-data.js:1448:// given an already-finalized lessonData object. Extracted from
js/firebase-data.js-1449-// saveSingleLesson()'s non-summer branch above so it can be reused by
js/firebase-data.js-1450-// saveMultipleLessonFields() below without duplicating the stripping/clearing
js/firebase-data.js-1451-// logic. Strips empty content fields the same way the summer branch does, by
js/firebase-data.js-1452-// omitting their dotted path entirely — never sending an explicit empty
js/firebase-data.js-1453-// string — and applies clears AFTER the JSON sanitization pass, since
js/firebase-data.js-1454-// FieldValue.delete() is a special sentinel a JSON round-trip would corrupt.
js/firebase-data.js:1455:function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = []) {
js/firebase-data.js-1456-  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above saveSingleLesson().
js/firebase-data.js:1457:  const stripped = { ...lessonData };
js/firebase-data.js-1458-  CONTENT_FIELDS.forEach(f => { if (!stripped[f] || !String(stripped[f]).trim()) delete stripped[f]; });
js/firebase-data.js-1459-  const cleanData = JSON.parse(JSON.stringify(stripped));
js/firebase-data.js-1460-  fieldsToClear.forEach(f => { cleanData[f] = firebase.firestore.FieldValue.delete(); });
--
js/firebase-data.js-1469-// whole-lesson deletes into ONE atomic Firestore .update() call — either
js/firebase-data.js-1470-// every write/delete in the call lands, or none do. Closes the
js/firebase-data.js-1471-// PARTIAL-FAILURE race that move/swap's prior sequential-writes design was
js/firebase-data.js:1472:// vulnerable to (does NOT independently verify the given lessonData reflects
js/firebase-data.js-1473-// current server state — see Phase 9's note in the plan for the deliberately
js/firebase-data.js-1474-// deferred, separately-tracked stale-input race).
js/firebase-data.js-1475-async function saveMultipleLessonFields(semesterKey, writes = [], deletes = []) {
js/firebase-data.js:1476:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js-1477-    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
js/firebase-data.js-1478-  }
js/firebase-data.js-1479-  if (lessonStoreFor(semesterKey) === 'camp') {
--
js/firebase-data.js-1487-  if (!curriculumDb) initCurriculumFirestore();
js/firebase-data.js-1488-  const user = getAuthUser();
js/firebase-data.js-1489-  const combined = {};
js/firebase-data.js:1490:  for (const { lessonKey, lessonData, fieldsToClear } of writes) {
js/firebase-data.js:1491:    lessonData.lastEditedBy = user?.name || 'Unknown';
js/firebase-data.js:1492:    lessonData.lastEditedAt = new Date().toISOString();
js/firebase-data.js:1493:    Object.assign(combined, buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear || []));
js/firebase-data.js-1494-  }
js/firebase-data.js-1495-  for (const lessonKey of deletes) {
js/firebase-data.js-1496-    combined[`${semesterKey}.${lessonKey}`] = firebase.firestore.FieldValue.delete();
js/firebase-data.js-1497-  }
js/firebase-data.js-1498-  combined.lastUpdated = new Date().toISOString();
js/firebase-data.js-1499-  combined.lastUpdatedBy = user?.name || 'Unknown';
js/firebase-data.js:1500:  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
js/firebase-data.js-1501-}
js/firebase-data.js-1502-
js/firebase-data.js-1503-// ─── Photo Upload (Firebase Storage) ─────────────────
--
js/firebase-data.js-1551-  // Same load guard as the summer lesson save this upload precedes — refuse
js/firebase-data.js-1552-  // before an object lands in Storage that the (refused) save would then
js/firebase-data.js-1553-  // never reference.
js/firebase-data.js:1554:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js-1555-    throw new Error('Lesson data failed to load — refusing to upload a photo for a save that would be refused. Reload and try again.');
js/firebase-data.js-1556-  }
js/firebase-data.js-1557-  if (typeof firebase.storage !== 'function') {
--
js/firebase-data.js-1574-// SDOC plan photos (Phase 2B): the summer upload's guards, under the
js/firebase-data.js-1575-// curriculum/ prefix storage.rules already allows — no Storage rules change.
js/firebase-data.js-1576-async function uploadDayOffPlanPhoto(yearKey, campId, projectTitle, file) {
js/firebase-data.js:1577:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js-1578-    throw new Error('Lesson data failed to load — refusing to upload a photo for a save that would be refused. Reload and try again.');
js/firebase-data.js-1579-  }
js/firebase-data.js-1580-  if (typeof firebase.storage !== 'function') {
--
js/firebase-data.js-1648-    return season === null ? col : col.where('season', '==', season);
js/firebase-data.js-1649-  };
js/firebase-data.js-1650-  // The registry mode is a PRECONDITION here, not a hint (Phase 1, 1.3).
js/firebase-data.js:1651:  // Every successful summer load sets lessonDataLoadedSuccessfully = true and
js/firebase-data.js-1652-  // re-hides the banner — so a mode set at startup would be wiped by the very
js/firebase-data.js-1653-  // next load, since the summer collections' own rules are fine and only the
js/firebase-data.js-1654-  // registry was denied. Checking it here is what keeps the app refused.
--
js/firebase-data.js-1811-      });
js/firebase-data.js-1812-    });
js/firebase-data.js-1813-
js/firebase-data.js:1814:    // 6. Load saved lesson plans from summerCamps_lessonData
js/firebase-data.js-1815-    try {
js/firebase-data.js-1816-      console.log('📖 Loading saved Summer Camp lesson plans...');
js/firebase-data.js:1817:      const savedLessonsSnap = await scoped('summerCamps_lessonData').get();
js/firebase-data.js-1818-      let mergedCount = 0;
js/firebase-data.js-1819-      let skippedForeignSeason = 0;
js/firebase-data.js-1820-
--
js/firebase-data.js-1851-
js/firebase-data.js-1852-      console.log(`✅ Merged ${mergedCount} saved lesson plans`);
js/firebase-data.js-1853-
js/firebase-data.js:1854:      if (skippedForeignSeason > 0) console.warn(`⚠️ Skipped ${skippedForeignSeason} summerCamps_lessonData document(s) stamped for another season.`);
js/firebase-data.js-1855-    } catch (err) {
js/firebase-data.js-1856-      console.warn('⚠️  Could not load saved Summer Camp lesson plans:', err);
js/firebase-data.js-1857-      // Rethrow — lesson content would be blank, saves would wipe real teacher data
--
js/firebase-data.js-1873-// Plan: tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html
js/firebase-data.js-1874-// A school year is a semester of type 'day-off-camps' in appData. Its events,
js/firebase-data.js-1875-// camps and (from Phase 2) plans are one document each in three collections,
js/firebase-data.js:1876:// every one carrying `yearKey`. Nothing here touches curriculum/lessonData or
js/firebase-data.js-1877-// any summerCamps_* collection.
js/firebase-data.js:1878:const DAY_OFF_COLLECTIONS = { events: 'dayOffCamps_events', camps: 'dayOffCamps_camps', plans: 'dayOffCamps_lessonData' };
js/firebase-data.js-1879-// The same six names the Summer Camp App seeds into its season registry — a
js/firebase-data.js-1880-// constant by Christie's choice (Sep 21): a camp uses whichever subset applies.
js/firebase-data.js-1881-const SDOC_STUDIOS = ['SoBo', 'AG', 'GR', 'MVW', 'Clay Hub', 'Coal Creek'];
--
js/firebase-data.js-1927-let currentDayOffSignoffs = {}; // yearKey → { campId: sign-off doc } (Phase 2A — never a plan, never a slot)
js/firebase-data.js-1928-
js/firebase-data.js-1929-// ─── Phase 2A: materials (planner-built) + prep check-off ────────────────────
js/firebase-data.js:1930:// Materials live on the project's plan record (dayOffCamps_lessonData) as
js/firebase-data.js-1931-// materialItems { [id]: { name, qty, scope, size, notes, order } } with prep
js/firebase-data.js-1932-// ticks in materialChecks { [id]: { by, at } } — written by field path so a
js/firebase-data.js-1933-// planner's edit and a prep tick never collide. NOT `materials`: that name is a
--
js/firebase-data.js-1983-// Every writer below refuses after a failed load, exactly like the lesson
js/firebase-data.js-1984-// writers: a model built from a partial read is not a safe base for a write.
js/firebase-data.js-1985-function assertDayOffWritable() {
js/firebase-data.js:1986:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js-1987-    throw new Error('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
js/firebase-data.js-1988-  }
js/firebase-data.js-1989-  if (!curriculumDb) initCurriculumFirestore();
--
js/firebase-data.js-2570-}
js/firebase-data.js-2571-
js/firebase-data.js-2572-// ─── Phase 2B: teacher plans ────────────────────────────────────────────────
js/firebase-data.js:2573:// A teacher's plan is the camp-project's record in dayOffCamps_lessonData (the
js/firebase-data.js-2574-// same doc 2A's materials live on). The deployed rules let any classbook user
js/firebase-data.js-2575-// write any field there, so these allow-lists are what keep a plan save off
js/firebase-data.js-2576-// materialItems / materialChecks / identity (plan, round 1).
--
js/firebase-data.js-2643-//                  move carried the text to the new title);
js/firebase-data.js-2644-//   'noop'       — nothing changed, nothing written.
js/firebase-data.js-2645-// Throws on anything else (refusals, a real failed write).
js/firebase-data.js:2646:async function saveDayOffPlan(yearKey, lessonKey, lessonData, fieldsToClear = [], auth) {
js/firebase-data.js-2647-  assertDayOffWritable();
js/firebase-data.js-2648-  if (!auth || typeof auth !== 'object') throw new Error('An SDOC plan save needs dayOffAuth — refusing to save without the permission check.');
js/firebase-data.js-2649-  const found = dayOffFindProject(yearKey, lessonKey);
--
js/firebase-data.js-2652-  if (lessonKey !== dayOffLessonKey(yearKey, campId, projectTitle)) throw new Error('This plan key does not match its camp and project — refusing to save.');
js/firebase-data.js-2653-  if (isDayOffNoPlanTitle(projectTitle) || projectTitle === DAY_OFF_SIGNOFF_TITLE) throw new Error(`"${projectTitle}" has no plan — refusing to save.`);
js/firebase-data.js-2654-
js/firebase-data.js:2655:  const extra = Object.keys(lessonData).filter(k => !DAY_OFF_PLAN_WRITABLE.includes(k));
js/firebase-data.js-2656-  if (extra.length) throw new Error(`An SDOC plan save may not write ${extra.join(', ')} — refused.`);
js/firebase-data.js-2657-  const badClears = fieldsToClear.filter(f => !DAY_OFF_PLAN_CLEARABLE.includes(f));
js/firebase-data.js-2658-  if (badClears.length) throw new Error(`An SDOC plan save may not clear ${badClears.join(', ')} — refused.`);
js/firebase-data.js:2659:  if (!lessonData.lastEditedBy || !lessonData.lastEditedAt) throw new Error('An SDOC plan save must carry its edit stamp — refused.');
js/firebase-data.js-2660-
js/firebase-data.js:2661:  const payload = { ...lessonData };
js/firebase-data.js-2662-  const clears = new Set(fieldsToClear);
js/firebase-data.js-2663-  // The photo's URL and Storage path only ever change together — across the
js/firebase-data.js-2664-  // payload AND the clears (a one-sided clear would leave a shown photo whose
--
js/firebase-data.js-2717-  }
js/firebase-data.js-2718-  dayOffInstallVerified(yearKey, lessonKey, server);
js/firebase-data.js-2719-  if (server.lastEditId === editId) return { status: 'saved', doc: server };
js/firebase-data.js:2720:  return { status: 'savedSince', doc: server, by: server.lastEditedBy || 'someone', own: server.lastEditedBy === lessonData.lastEditedBy };
js/firebase-data.js-2721-}
js/firebase-data.js-2722-
js/firebase-data.js-2723-// The SDOC read-back (plan, rounds 1–4): identity always strict; if the server
--
js/app.js-168-
js/app.js-169-  // Pre-load lesson data on startup so any load failure is detected immediately
js/app.js-170-  await loadLessonData();
js/app.js:171:  if (lessonDataLoadedSuccessfully === false) {
js/app.js-172-    document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
js/app.js-173-  }
js/app.js-174-
--
js/app.js-665-  // Not "initialized": the guard can trip transiently now (a listener reload
js/app.js-666-  // that fails and self-heals — Backtracking audit Phase 7), and the next
js/app.js-667-  // visit to this tab must be allowed to build it.
js/app.js:668:  if (lessonDataLoadedSuccessfully === false) {
js/app.js-669-    tvInitialized = false;
js/app.js-670-    document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
js/app.js-671-    return;
--
js/app.js-1760-          const slot = slots[lessonKey];
js/app.js-1761-          if (!slot) return `<div class="sdoc-tv-block" data-block="${key}"><span class="sdoc-tv-label">${label}</span> ${sdocEsc(title)}</div>`;
js/app.js-1762-          const progress = calculateLessonProgress(slot);
js/app.js:1763:          const editable = canEditDayOffPlan(slot) && lessonDataLoadedSuccessfully !== false;
js/app.js-1764-          const pending = dayOffPlanCompleteInFlight.has(`${yearKey}|${lessonKey}`);
js/app.js-1765-          return `<div class="sdoc-tv-block" data-block="${key}">
js/app.js-1766-            <span class="sdoc-tv-label">${label}</span>
--
js/app.js-3620-  // Same load-guard saveSingleLesson() enforced on the old path — after a
js/app.js-3621-  // failed load the cache is empty, so the legacy-thread migration below
js/app.js-3622-  // would run blind against whatever is really on the server.
js/app.js:3623:  if (lessonDataLoadedSuccessfully === false) {
js/app.js-3624-    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
js/app.js-3625-    return;
js/app.js-3626-  }
--
js/app.js-3628-  const semKey = modalSemKey || getTvSemKey();
js/app.js-3629-  // This modal never hosts a camp season (the Today View routes those to the
js/app.js-3630-  // summer editor, whose Q&A lives in summerCamps_prepHelpQueue), so a write
js/app.js:3631:  // under that key into curriculum/lessonData is never right. Routed by TYPE
js/app.js-3632-  // now (Phase 1, 1.1) — a third type is refused out loud rather than written
js/app.js-3633-  // into the shared weekly document.
js/app.js-3634-  let lessonStore;
--
js/app.js-3687-
js/app.js-3688-  try {
js/app.js-3689-    if (!curriculumDb) initCurriculumFirestore();
js/app.js:3690:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
js/app.js-3691-  } catch (err) {
js/app.js-3692-    console.error('Error sending Q&A message:', err);
js/app.js-3693-    alert('Error sending message: ' + err.message);
--
js/app.js-4538-  // companion plan's summer-delete design, which predates seasons.
js/app.js-4539-  // An SDOC year: refused while any event exists (a forced-server count);
js/app.js-4540-  // otherwise only its appData entry goes — it has nothing in
js/app.js:4541:  // curriculum/lessonData, and no collection is ever cleared from here.
js/app.js-4542-  if (isDayOffYear(key)) {
js/app.js-4543-    let events;
js/app.js-4544-    try { events = await countDayOffEvents(key); }
--
js/app.js-4576-    delete currentLessonData[key];
js/app.js-4577-  }
js/app.js-4578-  // …but only a WEEKLY semester has lessons of its own inside
js/app.js:4579:  // curriculum/lessonData to delete. A camp season's lessons live in the
js/app.js-4580-  // shared summerCamps_* collections and are never touched from here.
js/app.js-4581-  if (isDayOff) {
js/app.js-4582-    delete currentDayOffEvents[key]; delete currentDayOffCamps[key]; delete currentDayOffPlans[key]; delete currentDayOffSignoffs[key];
--
js/app.js-4608-  // say so first if some camps have nobody to see them.
js/app.js-4609-  if (published && isDayOffYear(key)) {
js/app.js-4610-    // The camp list below must be real to warn from — never publish on a failed load.
js/app.js:4611:    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
js/app.js-4612-    const bare = (currentDayOffCamps[key] || []).filter(c => !(c.teachers || []).length).length;
js/app.js-4613-    if (bare && !confirm(`${bare} camp${bare === 1 ? ' has' : 's have'} no teacher yet — publish anyway?`)) { renderSemesterSelector(); return; }
js/app.js-4614-  }
--
js/app.js-4684-
js/app.js-4685-// An SDOC school year: one appData entry through the field-path writer, after
js/app.js-4686-// a forced-server absence check. No roster, no lesson slots, no
js/app.js:4687:// curriculum/lessonData write.
js/app.js-4688-async function createDayOffYear() {
js/app.js-4689-  const startDate = document.getElementById('new-sem-dayoff-start')?.value || '';
js/app.js-4690-  const endDate = document.getElementById('new-sem-dayoff-end')?.value || '';
--
js/app.js-4811-}
js/app.js-4812-
js/app.js-4813-// A camp season is created from the registry, never typed in (1.6 / D3): no
js/app.js:4814:// roster, no week grid, no lesson slots and no curriculum/lessonData write —
js/app.js-4815-// its camps arrive from the Summer Camp App when Christie publishes them.
js/app.js-4816-async function createCampSeasonSemester() {
js/app.js-4817-  const season = document.getElementById('new-sem-season')?.value;
--
js/app.js-4892-  // for a semester the admin was told didn't get created, and a retry with the
js/app.js-4893-  // same name would silently reuse them. Track whether the first write landed
js/app.js-4894-  // so the catch can compensate.
js/app.js:4895:  let lessonDataCommitted = false;
js/app.js-4896-  creatingSemester = true;
js/app.js-4897-  try {
js/app.js-4898-    // Copy roster from existing semester if selected
--
js/app.js-4965-        await saveLessonData(key, emptyLessons);
js/app.js-4966-        if (!currentLessonData) currentLessonData = {};
js/app.js-4967-        currentLessonData[key] = emptyLessons;
js/app.js:4968:        lessonDataCommitted = true;
js/app.js-4969-      }
js/app.js-4970-    }
js/app.js-4971-
--
js/app.js-4984-    // Revert both local mutations so a retry isn't blocked by a phantom
js/app.js-4985-    // "already exists" and the grid doesn't render a semester that never saved.
js/app.js-4986-    delete currentConfig.semesters[key];
js/app.js:4987:    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
js/app.js-4988-    // R4-11: the empty lesson slots may already be persisted even though the
js/app.js-4989-    // config never was — clean up the orphaned server-side write, not just the
js/app.js-4990-    // local copy. Safe: this data is template-empty by construction (never had
js/app.js-4991-    // real content), so deleting it loses nothing.
js/app.js:4992:    if (lessonDataCommitted) {
js/app.js-4993-      try {
js/app.js-4994-        await deleteLessonData(key);
js/app.js-4995-      } catch (cleanupErr) {
--
js/app.js-5365-// been moved or deleted elsewhere since" — the existence check runs only for
js/app.js-5366-// the latter. Meaningful for the non-summer schema only: summer cache entries
js/app.js-5367-// are scaffolds regenerated from summerCamps_curriculum whether or not a
js/app.js:5368:// summerCamps_lessonData doc exists yet, so saveAdminEdit() skips the check
js/app.js-5369-// for summer regardless of this flag.
js/app.js-5370-let caEditLessonExisted = false;
js/app.js-5371-// One admin-popup save at a time: the Save button is a bare onclick with no
--
js/app.js-5560-  // Backtracking audit, Phase 1: check the guard BEFORE any Storage mutation
js/app.js-5561-  // (and, now, before the existence check) so a known-bad load state never
js/app.js-5562-  // gets as far as a server read, an upload, or a delete.
js/app.js:5563:  if (lessonDataLoadedSuccessfully === false) {
js/app.js-5564-    alert('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
js/app.js-5565-    return;
js/app.js-5566-  }
--
js/app.js-5630-  // Step 2 — forced-server read of this slot, before any side effect (the
js/app.js-5631-  // photo upload, the write). Non-summer only: a summer cache entry is a
js/app.js-5632-  // scaffold regenerated from summerCamps_curriculum whether or not its
js/app.js:5633:  // summerCamps_lessonData doc exists (a missing doc means "never saved",
js/app.js-5634-  // not "moved") and this app has no move/swap/cut path for summer lessons,
js/app.js-5635-  // so there is no ghost to prevent — the first save legitimately creates
js/app.js-5636-  // the doc. Same routing signal as saveSingleLesson() /
--
js/app.js-5824-// lessonHasContent() now lives in firebase-data.js (CONTENT_FIELDS is the
js/app.js-5825-// single source of truth, Data Safety Plan Stage 4A) — this file just uses it.
js/app.js-5826-
js/app.js:5827:// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
js/app.js-5828-// model. Backtracking audit, Phase 2 (reinstated round 4): adds an optional
js/app.js-5829-// opts.source === 'server' param, needed by Phase 8's
js/app.js-5830-// adminLessonStillExistsWithRetry() existence check below — omitting opts
--
js/app.js-5832-async function readAdminLessonDoc(semKey, lessonKey, opts = {}) {
js/app.js-5833-  if (!curriculumDb) initCurriculumFirestore();
js/app.js-5834-  const getOpts = opts.source === 'server' ? { source: 'server' } : undefined;
js/app.js:5835:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
js/app.js-5836-  return snap.exists ? (snap.data()?.[semKey]?.[lessonKey] || null) : null;
js/app.js-5837-}
js/app.js-5838-
--
js/app.js-5848-  const isSummer = lessonStoreFor(semKey) === 'camp';   // Phase 1, 1.1 — by type, and a third type throws
js/app.js-5849-  const readOnce = async () => {
js/app.js-5850-    if (isSummer) {
js/app.js:5851:      const snap = await curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key)).get({ source: 'server' });
js/app.js-5852-      return { exists: snap.exists, data: snap.exists ? snap.data() : null };
js/app.js-5853-    }
js/app.js-5854-    const data = await readAdminLessonDoc(semKey, key, { source: 'server' });
--
js/app.js-5942-    try {
js/app.js-5943-      await saveMultipleLessonFields(
js/app.js-5944-        semKey,
js/app.js:5945:        [{ lessonKey: newDestKey, lessonData: movedLesson, fieldsToClear: destFieldsToClear }],
js/app.js-5946-        [sourceKeyToDelete]
js/app.js-5947-      );
js/app.js-5948-      moveSucceeded = true;
--
js/app.js-6014-      savePromise = (async () => {
js/app.js-6015-        try {
js/app.js-6016-          await saveMultipleLessonFields(semKey, [
js/app.js:6017:            { lessonKey: sourceKeyForSwap, lessonData: swappedSource, fieldsToClear: sourceFieldsToClear },
js/app.js:6018:            { lessonKey: newDestKey, lessonData: swappedDest, fieldsToClear: destFieldsToClearSwap }
js/app.js-6019-          ]);
js/app.js-6020-          swapSucceeded = true;
js/app.js-6021-        } catch (err) {
--
js/app.js-6034-      currentLessonData[semKey] = lessons;
js/app.js-6035-      savePromise = (async () => {
js/app.js-6036-        try {
js/app.js:6037:          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
js/app.js-6038-          swapSucceeded = true;
js/app.js-6039-        } catch (err) {
js/app.js-6040-          console.error('❌ Swap failed:', err);
--
js/app.js-7143-  // failed reload the listener deliberately KEEPS the previous summer maps, so
js/app.js-7144-  // the cached lesson and the existence check both still pass — without this
js/app.js-7145-  // an admin could write a reply while the banner says saving is disabled.
js/app.js:7146:  if (lessonDataLoadedSuccessfully === false) {
js/app.js-7147-    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
js/app.js-7148-    return;
js/app.js-7149-  }
--
js/app.js-7198-    updates.lastUpdatedBy = user?.name || 'Unknown';
js/app.js-7199-  }
js/app.js-7200-  const docRef = isSummer
js/app.js:7201:    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
js/app.js:7202:    : curriculumDb.collection('curriculum').doc('lessonData');
js/app.js-7203-
js/app.js-7204-  try {
js/app.js-7205-    await docRef.update(updates);
--
js/app.js-7228-  // failed reload the listener deliberately KEEPS the previous summer maps, so
js/app.js-7229-  // the cached lesson and the existence check both still pass — without this
js/app.js-7230-  // an admin could write a reply while the banner says saving is disabled.
js/app.js:7231:  if (lessonDataLoadedSuccessfully === false) {
js/app.js-7232-    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
js/app.js-7233-    return;
js/app.js-7234-  }
--
js/app.js-7281-    updates.lastUpdatedBy = user?.name || 'Unknown';
js/app.js-7282-  }
js/app.js-7283-  const docRef = isSummer
js/app.js:7284:    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
js/app.js:7285:    : curriculumDb.collection('curriculum').doc('lessonData');
js/app.js-7286-
js/app.js-7287-  try {
js/app.js-7288-    await docRef.update(updates);
--
js/app.js-7512-  if (registryMode === 'error' || registryMode === 'unknown') {
js/app.js-7513-    throw new Error(`Can't count summer content: the season registry is ${registryMode === 'unknown' ? 'unreachable' : 'unreadable'}.`);
js/app.js-7514-  }
js/app.js:7515:  const summerSnap = await curriculumDb.collection('summerCamps_lessonData').get();
js/app.js-7516-  summerSnap.forEach(doc => tally(doc.data()));
js/app.js-7517-
js/app.js:7518:  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
js/app.js:7519:  const lessonDataDoc = lessonDataSnap.exists ? lessonDataSnap.data() : {};
js/app.js:7520:  for (const semesterLessons of Object.values(lessonDataDoc)) {
js/app.js-7521-    if (!semesterLessons || typeof semesterLessons !== 'object') continue;
js/app.js-7522-    for (const lesson of Object.values(semesterLessons)) tally(lesson);
js/app.js-7523-  }
--
js/app.js-11834-
js/app.js-11835-  const performSave = async (showStatus, myInvocation, form) => {
js/app.js-11836-    if (showStatus && !closing) { autoSaveStatus.textContent = 'Saving...'; autoSaveStatus.style.color = ''; }
js/app.js:11837:    // The curriculum/lessonData listener rebuilds the whole summer cache from
js/app.js-11838-    // a fresh collection read on every snapshot (any other user's save). If
js/app.js-11839-    // that brought in a newer confirmed copy of this lesson, build on it
js/app.js-11840-    // rather than on the copy this modal last confirmed — but never on an
--
js/app.js-12517-  const year = currentConfig?.semesters?.[yearKey] || {};
js/app.js-12518-  const events = currentDayOffEvents[yearKey] || [];
js/app.js-12519-  const camps = currentDayOffCamps[yearKey] || [];
js/app.js:12520:  const writable = lessonDataLoadedSuccessfully !== false;
js/app.js-12521-  // Planner buttons only for users the rules let save them (Phase 2A);
js/app.js-12522-  // the prep team sees the list read-only, with the materials checklist.
js/app.js-12523-  const planner = canPlanDayOffCamps();
--
js/app.js-13045-  };
js/app.js-13046-  v.detailsBase = base;
js/app.js-13047-  box.dataset.for = `${v.campId}|||${v.title}`;
js/app.js:13048:  const planner = canPlanDayOffCamps() && lessonDataLoadedSuccessfully !== false;
js/app.js-13049-  if (!planner) {
js/app.js-13050-    box.innerHTML = !base.details.trim() && !base.links.length ? '' : `
js/app.js-13051-      <div class="sdoc-details-readonly">
--
js/app.js-13179-  captureDayOffMaterialDrafts();
js/app.js-13180-  const camp = (currentDayOffCamps[v.yearKey] || []).find(c => c.id === v.campId);
js/app.js-13181-  const headcount = dayOffHeadcount(camp);
js/app.js:13182:  const planner = canPlanDayOffCamps() && lessonDataLoadedSuccessfully !== false;
js/app.js:13183:  const ticker = canTickDayOffMaterials() && lessonDataLoadedSuccessfully !== false;
js/app.js-13184-  const items = dayOffSortedItems(v.plan);
js/app.js-13185-  const checks = v.plan?.materialChecks || {};
js/app.js-13186-  const scopeOptions = (sel) => SDOC_MATERIAL_SCOPES.map(o => `<option ${o === sel ? 'selected' : ''}>${sdocEsc(o)}</option>`).join('');
--
js/app.js-13406-  const v = dayOffEventMaterialsView;
js/app.js-13407-  const body = document.getElementById('sdoc-event-materials-body');
js/app.js-13408-  if (!v || !body) return;
js/app.js:13409:  const ticker = canTickDayOffMaterials() && lessonDataLoadedSuccessfully !== false;
js/app.js-13410-  const dis = ticker ? '' : 'disabled';
js/app.js-13411-  let items = 0, ticked = 0;
js/app.js-13412-  const sections = dayOffEventCamps(v.yearKey, v.eventId).map(camp => {

exec
/bin/zsh -lc "git rev-parse HEAD && rg -n \"collection\\(['\\\"]curriculum['\\\"]\\)|\\.doc\\(['\\\"]lessonData['\\\"]\\)|doc\\(['\\\"]lessonData['\\\"]\\)\" js/firebase-config.js js/auth-guard.js js/firebase-data.js js/app.js" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-Cvbastk7' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-sjubA1mM' (errno=Operation not permitted)
2ef2e629cac2d6e8e7ae8ff702a3de3a67e755ca
js/firebase-data.js:172:    const doc = await curriculumDb.collection('curriculum').doc('appData').get();
js/firebase-data.js:230:  const ref = curriculumDb.collection('curriculum').doc('appData');
js/firebase-data.js:245:  const doc = await curriculumDb.collection('curriculum').doc('appData').get({ source: 'server' });
js/firebase-data.js:524:  configUnsubscribe = curriculumDb.collection('curriculum').doc('appData')
js/firebase-data.js:538:    const doc = await curriculumDb.collection('curriculum').doc('prepData').get();
js/firebase-data.js:560:  const docRef = curriculumDb.collection('curriculum').doc('prepData');
js/firebase-data.js:579:  const docRef = curriculumDb.collection('curriculum').doc('prepData');
js/firebase-data.js:600:  prepDataUnsubscribe = curriculumDb.collection('curriculum').doc('prepData')
js/firebase-data.js:709:    const doc = await curriculumDb.collection('curriculum').doc('prepCycleConfig').get();
js/firebase-data.js:727:  await curriculumDb.collection('curriculum').doc('prepCycleConfig').set(toSave);
js/firebase-data.js:762:    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
js/firebase-data.js:817:  await curriculumDb.collection('curriculum').doc('lessonData').set({
js/firebase-data.js:830:  await curriculumDb.collection('curriculum').doc('lessonData').update({
js/firebase-data.js:963:  await curriculumDb.collection('curriculum').doc('lessonData').update({
js/firebase-data.js:975:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
js/firebase-data.js:985:  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
js/firebase-data.js:995:  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
js/firebase-data.js:1171:  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
js/firebase-data.js:1203:    const doc = await curriculumDb.collection('curriculum').doc('cutProjects').get();
js/firebase-data.js:1215:  await curriculumDb.collection('curriculum').doc('cutProjects').set({
js/firebase-data.js:1227:    const doc = await curriculumDb.collection('curriculum').doc('futureProjects').get();
js/firebase-data.js:1239:  await curriculumDb.collection('curriculum').doc('futureProjects').set({
js/firebase-data.js:1252:    const doc = await curriculumDb.collection('curriculum').doc('changeLog').get();
js/firebase-data.js:1277:    await curriculumDb.collection('curriculum').doc('changeLog').set({
js/firebase-data.js:1293:    const doc = await curriculumDb.collection('curriculum').doc('diagnosticDismissals').get();
js/firebase-data.js:1308:    await curriculumDb.collection('curriculum').doc('diagnosticDismissals').set(dismissals);
js/firebase-data.js:1438:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
js/firebase-data.js:1500:  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
js/app.js:3690:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
js/app.js:5835:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
js/app.js:6309:    await curriculumDb.collection('curriculum').doc('cutProjects').set({
js/app.js:6500:    await curriculumDb.collection('curriculum').doc('cutProjects').set({
js/app.js:6622:    await curriculumDb.collection('curriculum').doc('cutProjects').set({
js/app.js:7202:    : curriculumDb.collection('curriculum').doc('lessonData');
js/app.js:7285:    : curriculumDb.collection('curriculum').doc('lessonData');
js/app.js:7518:  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();

web search: 
web search: site:firebase.google.com/docs/firestore/query-data/listen includeMetadataChanges fromCache offline metadata snapshot listener ...
exec
/bin/zsh -lc "rg -n \"deleteLessonData\\(\" js/*.js && nl -ba js/app.js | sed -n '4860,5010p' && nl -ba js/firebase-data.js | sed -n '500,535p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
js/firebase-data.js:961:async function deleteLessonData(semesterKey) {
js/app.js:4585:      await deleteLessonData(key);
js/app.js:4904:      // state even when its server-side deleteLessonData() fails (warn-only),
js/app.js:4994:        await deleteLessonData(key);
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

codex
**NOT EXECUTION-READY**

1. Writer coverage is incomplete operationally. The seven ordinary writers are correctly identified, including ref-based writes; no current batch/transaction writers were missed. But `deleteLessonData()` remains used by failed-create cleanup ([app.js:4994](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4994)), despite the plan treating it as replaced. More critically, `saveLessonData()` runs before the new semester’s appData entry exists ([app.js:4965](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4965), entry written at [app.js:4981](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4981)); the proposed existence assertion would therefore break normal “Copy from” creation.

2. Fail-closed states are not fully sound. `includeMetadataChanges` does provide a `fromCache:true` event after Firestore detects loss of server synchronization, but detection is not instantaneous; a save can pass while state still says `confirmed`, then queue offline. Thus the plan cannot guarantee that offline writes never resurrect deleted keys. A normal latency-compensated lesson write does not itself disturb the separate appData listener, but appData snapshots with `hasPendingWrites:true` should not be treated as server confirmation. [Firebase metadata semantics](https://firebase.google.com/docs/reference/js/firestore.snapshotmetadata).

Minimum: specify create/cleanup handling, and make semester existence atomic with each weekly lessonData write (transaction or equivalent), using the listener only for early UX refusal.
tokens used
59,353
**NOT EXECUTION-READY**

1. Writer coverage is incomplete operationally. The seven ordinary writers are correctly identified, including ref-based writes; no current batch/transaction writers were missed. But `deleteLessonData()` remains used by failed-create cleanup ([app.js:4994](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4994)), despite the plan treating it as replaced. More critically, `saveLessonData()` runs before the new semester’s appData entry exists ([app.js:4965](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4965), entry written at [app.js:4981](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4981)); the proposed existence assertion would therefore break normal “Copy from” creation.

2. Fail-closed states are not fully sound. `includeMetadataChanges` does provide a `fromCache:true` event after Firestore detects loss of server synchronization, but detection is not instantaneous; a save can pass while state still says `confirmed`, then queue offline. Thus the plan cannot guarantee that offline writes never resurrect deleted keys. A normal latency-compensated lesson write does not itself disturb the separate appData listener, but appData snapshots with `hasPendingWrites:true` should not be treated as server confirmation. [Firebase metadata semantics](https://firebase.google.com/docs/reference/js/firestore.snapshotmetadata).

Minimum: specify create/cleanup handling, and make semester existence atomic with each weekly lessonData write (transaction or equivalent), using the listener only for early UX refusal.
