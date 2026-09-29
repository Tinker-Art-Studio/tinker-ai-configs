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
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:916:e2e/data-safety.spec.js:8490:        window.updateAppData = async (u) => { appDataWrites.push(Object.keys(u)); delete currentConfig.semesters[sem]; };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:918:e2e/data-safety.spec.js:8497:          window.updateAppData = realUpdate; window.deleteLessonData = realDeleteLessons;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:919:e2e/data-safety.spec.js:8531:        const realUpdate = window.updateAppData; const realDelete = window.deleteLessonData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:920:e2e/data-safety.spec.js:8533:        window.updateAppData = async () => { delete currentConfig.semesters[sem]; };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:922:e2e/data-safety.spec.js:8536:        finally { window.confirm = realConfirm; window.updateAppData = realUpdate; window.deleteLessonData = realDelete; delete currentConfig.semesters[sem]; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:923:e2e/data-safety.spec.js:8553:        const realUpdate = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:924:e2e/data-safety.spec.js:8555:        window.updateAppData = async (u) => { writes.push(u); };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:925:e2e/data-safety.spec.js:8571:        } finally { window.readAppDataFromServer = realRead; window.updateAppData = realUpdate; pendingSemesterTypeStamps = null; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:926:e2e/data-safety.spec.js:8592:        const realUpdate = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:927:e2e/data-safety.spec.js:8601:          window.updateAppData = async () => {};
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:928:e2e/data-safety.spec.js:8608:          window.updateAppData = async (u) => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:929:e2e/data-safety.spec.js:8621:        } finally { window.readAppDataFromServer = realRead; window.updateAppData = realUpdate; pendingSemesterTypeStamps = null; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:930:e2e/data-safety.spec.js:8645:        const realUpdate = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:931:e2e/data-safety.spec.js:8657:          window.updateAppData = async (u) => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:932:e2e/data-safety.spec.js:8669:        } finally { window.readAppDataFromServer = realRead; window.updateAppData = realUpdate; pendingSemesterTypeStamps = null; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:933:e2e/data-safety.spec.js:8693:        const realUpdate = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:934:e2e/data-safety.spec.js:8694:        window.updateAppData = async (u) => { writes.push(JSON.parse(JSON.stringify(u))); };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:935:e2e/data-safety.spec.js:8715:          window.updateAppData = realUpdate;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:936:e2e/data-safety.spec.js:8792:            update: await attempt(() => updateAppData({ 'semesters.test-x.published': true })),
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:937:e2e/data-safety.spec.js:8838:        const realUpdate = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:939:e2e/data-safety.spec.js:8847:          window.updateAppData = async (u) => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:941:e2e/data-safety.spec.js:8861:          window.updateAppData = async (u) => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:942:e2e/data-safety.spec.js:8873:        } finally { window.readAppDataFromServer = realRead; window.updateAppData = realUpdate; pendingSemesterTypeStamps = null; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:947:e2e/data-safety.spec.js:9068:        const realList = window.listRegisteredSeasons; const realUpdate = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:948:e2e/data-safety.spec.js:9077:          window.updateAppData = async () => { throw new Error('TEST simulated write failure'); };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:949:e2e/data-safety.spec.js:9082:          window.alert = realAlert; window.listRegisteredSeasons = realList; window.updateAppData = realUpdate;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:950:e2e/data-safety.spec.js:9111:        const realUpdate = window.updateAppData;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:951:e2e/data-safety.spec.js:9112:        window.updateAppData = async () => { throw new Error('TEST simulated write failure'); };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:953:e2e/data-safety.spec.js:9120:          window.alert = realAlert; window.confirm = realConfirm; window.updateAppData = realUpdate;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:965:   249	    <li><strong>The Delete exposure (finding 3):</strong> making a weekly semester non-active makes it deletable, which is already true of Spring 2026 in production. Phase 1 adds the lesson count and the typed name to that delete, and the activation confirm says so. Until Phase 1 ships: <strong>don't click Delete on Spring 2026</strong>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:966:   250	    <li><strong>Partial update:</strong> <code>updateAppData</code> (<code>update()</code> of named dotted paths; its <code>set(merge)</code> fallback fires only if appData doesn't exist, which isn't the case here). Only <code>activeSemester</code>, optionally <code>semesters.&lt;key&gt;.published</code> and <code>activeSemesterSwitch</code>, plus the existing <code>lastUpdated</code>/<code>lastUpdatedBy</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:969:   253	    <li><strong>No bulk op, no delete:</strong> no snapshot needed. The previous value is shown in the confirmation. To roll back, make the old semester active again with the same button (or the console line).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:970:   254	    <li><strong>Refuses on a bad load:</strong> inherited from <code>updateAppData</code> (config load failed, season registry unknown or error).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:979:   263	      <li><strong>Payload/shape scenarios</strong> stub <code>window.updateAppData</code> and assert <code>Object.keys(payload).sort()</code> (as <code>data-safety.spec.js:7596-7610</code> does). The in-memory test semester is added to <code>currentConfig</code> in the page only, with an explicit <code>semesterType: 'weekly'</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:981:   265	      <li><strong>One real round-trip</strong> runs in a manager context (<code>MANAGER_STATE_PATH</code>, first spec to use it). The test semester is created and removed through the app's own <code>updateAppData</code> in that page, and <code>activeSemester</code> is restored to <code>spring-2026</code> and <code>activeSemesterSwitch</code> deleted in <code>afterEach</code> <strong>and</strong> <code>afterAll</code>, each read back. Reason: with <code>workers: 1</code> this file runs <strong>first</strong> alphabetically, and a leak would break <code>day-off-camps.spec.js</code> "SDOC R6" and <code>day-off-teacher.spec.js</code> "T20", which read the active semester.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:982:   266	      <li><strong>The restore can't run from Node</strong> (the helper is staff, and appData writes are manager-only). <code>afterEach</code>/<code>afterAll</code> open a manager browser context and call the page's own <code>updateAppData</code> (<code>activeSemester: 'spring-2026'</code>, <code>activeSemesterSwitch: FieldValue.delete()</code>, <code>semesters.&lt;test&gt;: FieldValue.delete()</code>), then read back with <code>readAppDataFromServer()</code> (<code>firebase-data.js:243-247</code>).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:984:   268	      <li>Payloads: use the <code>window.updateAppData</code> stub pattern (<code>data-safety.spec.js:3947-3958</code>), whose payload holds only the caller's keys. <code>withAppDataSpy</code> is file-local and adds <code>lastUpdated</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:985:   269	      <li><strong>One real rules refusal</strong> uses the staff account and asserts <code>permission-denied</code> specifically (the seeded season registry is valid, so <code>updateAppData</code>'s own guard won't fire first).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1002:   286	  <li>Read this plan. Check the Decisions Log for Christie's answers to Q1/Q2 and any review findings.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1009:   293	<h2 id="decisions">Decisions Log (append-only)</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1022:   306	  Also taken: an <code>isPublishableType</code> check before auto-publish, the name fallback in the confirm, filtering Settings' options by <code>canSeeSemester</code>, the camp-active consequences named in the confirm and BDD, and the stale-seen asymmetry recorded as a decision.<br>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1033:   317	    <li>(6) An invisible target isn't marked seen.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1045:   329	  <strong>Sep 29, 2026: production switched by console.</strong> Christie ran <code>await updateAppData({ activeSemester: 'fall-2026' })</code> on the live app. Fall 2026 is now active. Semesters at that point: summer-2026 (published), fall-2026 (published), sdoc-2026-27 (published:false), spring-2026 (published field absent, so visible). Returning browsers still remember Spring until they pick Fall. Phase 2's "switch everyone" is what fixes that next time.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1157:   102	  // Hide/show Prep Dashboard tab based on semester type
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1159:   104	  const prepDashboardTab = document.querySelector('.tab-btn[data-tab="prep-dashboard"]');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1164:   109	      if (document.querySelector('.tab-btn.active')?.dataset.tab === 'prep-dashboard') {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1173:   118	  // Hide/show Curriculum Admin tab for non-manager users on summer semesters
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1176:   121	  // Refresh all tabs to use new semester
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1177:   122	  const activeTab = document.querySelector('.tab-btn.active')?.dataset.tab;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1217:   162	  // listener — never awaited — so this tab follows the Summer Camp App
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1230:   175	  // Hide Prep Dashboard tab for summer camp semesters (prep is done in Summer Camp App)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1232:   177	  const prepDashboardTab = document.querySelector('.tab-btn[data-tab="prep-dashboard"]');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1242:   187	  // Initialize Curriculum Admin (default tab)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1253:   198	function switchTab(tabId) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1254:   199	  const btn = document.querySelector(`.tab-btn[data-tab="${tabId}"]`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1259:   204	  document.querySelectorAll('.tab-btn').forEach(btn => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1261:   206	      const tabId = btn.dataset.tab;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1263:   208	      document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1267:   212	      document.getElementById(tabId)?.classList.add('active');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1269:   214	      if (tabId === 'teacher-view') {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1271:   216	      } else if (tabId === 'prep-dashboard') {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1273:   218	      } else if (tabId === 'curriculum-admin') {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1275:   220	      } else if (tabId === 'settings') {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1303:   297	// Hide/show Curriculum Admin tab based on semester type for non-manager users.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1312:   306	  const caTab = document.querySelector('.tab-btn[data-tab="curriculum-admin"]');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1317:   311	    if (document.querySelector('.tab-btn.active')?.dataset.tab === 'curriculum-admin') {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1329:   323	  // Manager+: full access to all tabs including Settings
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1332:   326	  // classbook-admin / curriculum-admin / prep role: all tabs EXCEPT Settings
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1335:   329	    document.querySelector('.tab-btn[data-tab="settings"]')?.style.setProperty('display', 'none');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1341:   335	  // Hide admin tabs (Curriculum Admin, Settings) and Prep Dashboard
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1345:   339	  // Switch active tab to Teacher View since Curriculum Admin is hidden for teachers
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1364:   358	  // Settings link switches to Settings tab — through the tab button, so it gets
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1365:   359	  // the same form refresh as clicking the tab (review: it used to bypass it).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1446:  4463	      <table style="border-collapse:collapse;width:100%;">${rows}</table>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1542:  4559	  // this tab if the write is refused, or the config would be missing a
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1548:  4565	    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1602:  4619	    await updateAppData({ [`semesters.${key}.published`]: published });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1654: 10660	  // Now uses global semester instead of per-tab selection
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1666: 10672	// to the tab for the same semester keeps any unsaved edits.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1790: 11270	      // The SERVER's pool, not this tab's: the × button edits
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1791: 11271	      // currentConfig's list before Save runs, and another tab may have added
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1798: 11278	        // Put just those names back in this tab's list (other unsaved edits in
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1825: 11305	  // Keep this tab's copy in step with exactly what is being written.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1842: 11322	    await updateAppData({ ...settingsPaths, ...extraPaths });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1843: 11323	    // Keep this tab's config in step with exactly what was written. Before
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1866: 11346	    // Reload other tabs if active
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1867: 11347	    const activeTab = document.querySelector('.tab-btn.active')?.dataset.tab;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1898:     8	//   curriculum/cutProjects — projects removed from schedule, saved for reuse
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1899:     9	//   curriculum/changeLog   — audit trail of moves/swaps/cuts
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:1929:    39	// pressing "Stamp semester types", and a stale pre-Phase-1 tab whose
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:2003:   212	async function updateAppData(updates) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:2306:./e2e/data-safety.spec.js:7637:          await updateAppData({ 'semesters.test-x.name': 'TEST X', 'activeSemester': 'test-x' });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:2336:e2e/day-off-camps.spec.js:318:  test('SDOC R2: a stale camp editor is refused instead of replacing a projects map another tab changed', async ({ page }) => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:2339:e2e/day-off-camps.spec.js:324:    // This tab edits Monday's projects from its stale copy.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:2380:e2e/emulators/seed.js:31:    [`http://${firestore.host}:${firestore.port}/emulator/v1/projects/${PROJECT_ID}/databases/(default)/documents`, 'Firestore'],
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:2481:    12	 * 2. Signs in ONCE and snapshots the browser's authenticated session
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:2484:    15	 *    browser context then starts from this snapshot already signed in (see
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:2492:    23	 *    tests' login() path identical to what they had. The snapshot file holds
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:2939:   130	  "cutProjects": {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:2967:   158	  "changeLog": {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3053:   102	  // Hide/show Prep Dashboard tab based on semester type
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3055:   104	  const prepDashboardTab = document.querySelector('.tab-btn[data-tab="prep-dashboard"]');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3060:   109	      if (document.querySelector('.tab-btn.active')?.dataset.tab === 'prep-dashboard') {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3069:   118	  // Hide/show Curriculum Admin tab for non-manager users on summer semesters
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3072:   121	  // Refresh all tabs to use new semester
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3073:   122	  const activeTab = document.querySelector('.tab-btn.active')?.dataset.tab;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3113:   162	  // listener — never awaited — so this tab follows the Summer Camp App
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3126:   175	  // Hide Prep Dashboard tab for summer camp semesters (prep is done in Summer Camp App)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3128:   177	  const prepDashboardTab = document.querySelector('.tab-btn[data-tab="prep-dashboard"]');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3138:   187	  // Initialize Curriculum Admin (default tab)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3149:   198	function switchTab(tabId) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3150:   199	  const btn = document.querySelector(`.tab-btn[data-tab="${tabId}"]`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3155:   204	  document.querySelectorAll('.tab-btn').forEach(btn => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3157:   206	      const tabId = btn.dataset.tab;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3159:   208	      document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3163:   212	      document.getElementById(tabId)?.classList.add('active');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3165:   214	      if (tabId === 'teacher-view') {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3174:   297	// Hide/show Curriculum Admin tab based on semester type for non-manager users.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3183:   306	  const caTab = document.querySelector('.tab-btn[data-tab="curriculum-admin"]');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3188:   311	    if (document.querySelector('.tab-btn.active')?.dataset.tab === 'curriculum-admin') {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3200:   323	  // Manager+: full access to all tabs including Settings
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3203:   326	  // classbook-admin / curriculum-admin / prep role: all tabs EXCEPT Settings
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3206:   329	    document.querySelector('.tab-btn[data-tab="settings"]')?.style.setProperty('display', 'none');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3212:   335	  // Hide admin tabs (Curriculum Admin, Settings) and Prep Dashboard
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3216:   339	  // Switch active tab to Teacher View since Curriculum Admin is hidden for teachers
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3235:   358	  // Settings link switches to Settings tab — through the tab button, so it gets
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3236:   359	  // the same form refresh as clicking the tab (review: it used to bypass it).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3337:  4559	  // this tab if the write is refused, or the config would be missing a
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3343:  4565	    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3397:  4619	    await updateAppData({ [`semesters.${key}.published`]: published });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3429: 10660	  // Now uses global semester instead of per-tab selection
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3441: 10672	// to the tab for the same semester keeps any unsaved edits.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3517:   407	        <p class="settings-panel-desc">Configure semester settings, data source URLs, and Week tab GIDs. These settings are shared across all users.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3571:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-data-safety-remaining-stages.html:1206:    <strong>🛑 Correction, Aug 15, 2026 (round 10) — the claim above that "two admins acting on either bank... can no longer clobber each other" is TRUE for Cut Bank but was FALSE as originally stated for Idea Bank.</strong> Both round-10 reviewers, independently, found and confirmed <code>curriculum/futureProjects</code> (the Idea Bank's backing document) has FIVE other live, unaudited writers that still use the old local-splice-then-full-array-overwrite pattern via <code>saveFutureProjects()</code>: <code>saveNewIdea()</code>, <code>saveIdeaEdit()</code>, <code>deleteIdeaProject()</code>, <code>archiveIdeaProject()</code>, and <code>unarchiveIdeaProject()</code> (all <code>app.js:5305-5383</code>). <code>pasteFromIdeaBank()</code>'s <code>arrayRemove()</code> only wins the race against itself and against Phase-17-style atomic appends — it loses against any of these five. Concretely: an admin pastes (correctly removes) idea X; a moment later, a different admin archives, edits, deletes, or adds a DIFFERENT idea from a stale snapshot that still contains X — that admin's full-array overwrite silently resurrects X. <strong>Cut Bank has no equivalent gap</strong> — both reviewers confirmed, via exhaustive grep, that <code>cutProject()</code> (Phase 17, <code>arrayUnion</code>), <code>pasteFromCutBank()</code>, and <code>deleteCutProject()</code> (both this phase, <code>arrayRemove</code>) are the ONLY three functions that ever touch <code>currentCutProjects</code> — the Cut Bank race is genuinely, completely closed. <strong>Fixing the Idea Bank's remaining five writers, and a broader pattern of the same "shared document/array last-write-wins" vulnerability class found the same round in unrelated features (<code>curriculum/appData</code>/Settings, Prep Dashboard, Prep Cycle config, diagnostic dismissals), is deliberately OUT OF SCOPE for this plan</strong> — Christie's explicit decision, given this is a distinct vulnerability class from Vulnerability #11 (shared config/array documents, not lesson content) that reaches well beyond anything this plan has otherwise touched. It will be addressed by a separate, dedicated plan, covering the whole app comprehensively rather than the incidentally-discovered subset found here. See "Not in scope" below for the specific pointer.</div>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3574:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-data-safety-remaining-stages.html:2273:  <div class="danger">🛑 <strong>Residual gap, found Aug 15, 2026 (round 9, Codex): this guard is go-forward only — it has no effect on a "summer-"-prefixed, non-camp-type key that might already exist in <code>currentConfig.semesters</code> before this phase ever ships.</strong> The check only runs inside <code>createNewSemester()</code>, at the moment of creation — it cannot retroactively repair or flag an already-existing ambiguous key, and (as established above) Settings can edit a semester's display name without ever touching its underlying key, so there is no in-app remediation path for one either. <strong>No such semester is known to exist in production today</strong> — <code>semesterType: 'summer-camp'</code> is confirmed set in exactly two places in the codebase (both for <code>summer-2026</code>, see Phase 14/15's danger boxes), and creating an ambiguous key requires a deliberate, unusual admin naming choice that would need to have already happened. Before or during deployment of this phase, a one-time, read-only check of the real <code>curriculum/appData</code> config document is recommended — confirm no key other than <code>summer-2026</code> starts with <code>"summer-"</code> — rather than assuming this from the app's UI-reachability analysis alone. Not a code change; a deployment-time verification step, noted here so it isn't silently skipped.</div>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3874:   106	  await page.click('.tab-btn[data-tab="teacher-view"]');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3911:   102	    await page.evaluate(() => { window.__appDataWrites = 0; const u = window.updateAppData; window.updateAppData = async (...a) => { window.__appDataWrites++; return u(...a); }; });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3928:   452	    // Without this a tab whose rule was removed mid-session would sit on
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:3931:   455	    // tab that then can't write has to be reloaded — accepted: reviewed and
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4024:    54	  <div class="danger">🛑 <strong>Correction, Aug 18, 2026 (backtracking audit plan's Phase 11 execution session).</strong> This entry originally said "five remaining writers," implying <code>pasteFromIdeaBank()</code> itself was already fixed with <code>arrayRemove()</code> the way Cut Bank's paste was. That was wrong — direct code reading confirmed <code>pasteFromIdeaBank()</code> had never been touched by that fix at all; instead it carried a separate, deterministic, live production bug (it passed the whole <code>{projects:[...]}</code> wrapper into <code>saveFutureProjects()</code>, which expects a bare array, double-nesting <code>curriculum/futureProjects</code> on every single use). That bug is now fixed (backtracking audit plan, Phase 11), and the fix was hardened through two rounds of Codex+Claude implementation review. But the underlying write primitive is still the same plain <code>saveFutureProjects()</code> <code>.set()</code> as the other five — <code>pasteFromIdeaBank()</code> was never actually an exception to this instance, it's a sixth writer sharing the identical race, not a already-solved case. See the Decisions Log entry below for the specific narrow sub-case a reviewer found in this session's hardened version.</div>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4025:    55	  <p><strong>File:</strong> <code>js/app.js</code>. <strong>Functions:</strong> <code>saveNewIdea()</code> (~5305-5330, write ~5327), <code>saveIdeaEdit()</code> (~5340-5357, write ~5354), <code>deleteIdeaProject()</code> (~5359-5369, write ~5367), <code>archiveIdeaProject()</code> (~5371-5376, write ~5374), <code>unarchiveIdeaProject()</code> (~5378-5383, write ~5381), and <code>pasteFromIdeaBank()</code> (~5648-5741, write via <code>saveFutureProjects()</code> inside its own try/catch). All call <code>saveFutureProjects(projects)</code> (<code>firebase-data.js:581-589</code>), which does a plain <code>.set({projects, lastUpdated, lastUpdatedBy})</code> on the whole <code>curriculum/futureProjects</code> document — no <code>arrayUnion</code>/<code>arrayRemove</code>, no merge-at-the-element-level. There is no <code>onSnapshot</code> listener on this document (confirmed — the only listeners in <code>firebase-data.js</code> are on <code>curriculum/lessonData</code> and <code>curriculum/appData</code>), so a tab's cached <code>currentFutureProjects</code> can go stale indefinitely with no self-correction.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4026:    56	  <p><strong>Concrete failure:</strong> Admin A pastes idea X from the bank (a plain <code>.set()</code> of the post-removal array, same as every other writer here — NOT an atomic <code>arrayRemove()</code>, see the correction above). Admin B, in a separate tab with a snapshot loaded before A's removal propagated, archives, edits, deletes, or adds a <em>different</em> idea moments later — B's full-array overwrite silently resurrects X. <code>deleteIdeaProject()</code> is the direct sibling of the companion plan's already-fixed <code>deleteCutProject()</code> — same shape, same likely fix (<code>FieldValue.arrayRemove()</code>) — and <code>pasteFromIdeaBank()</code>'s own removal step is now effectively a second instance of that exact same sibling shape. <code>saveNewIdea()</code>/<code>saveIdeaEdit()</code> would need care: an "edit" mutates an existing array element in place, so the fix isn't a simple append/remove — it likely needs the element's stable identity (an id field, if one exists — check <code>app.js:5317</code>'s id-generation convention, already referenced elsewhere in the companion plan) to target a transaction or a keyed sub-collection instead of an in-array edit, since Firestore's array transforms can't update one element by identity — only add or remove whole elements.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4036:    66	  <p><strong>Concrete failure:</strong> User A adds a class association to a project. User B, from a snapshot that hasn't received A's change, marks a different material complete and autosaves. Each autosave replaces the entire week map — B's later write can silently remove A's association; A's later write can revert B's material update. A live listener on this data narrows the window but doesn't make the read-modify-write atomic.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4045:    75	  <h3>6. (Already fixed, in the companion plan) Cut Bank — <code>curriculum/cutProjects</code></h3>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4049:    79	  <p><strong>File:</strong> <code>js/app.js</code>, <code>handleGridAction()</code>'s move and swap branches, backed by <code>js/firebase-data.js</code>'s <code>saveMultipleLessonFields()</code> (a new helper added by the backtracking audit plan's Phase 9). <strong>A different shape from instances 1-5 above:</strong> those are all about a write that ISN'T atomic — a local read-modify-write racing against another admin's concurrent write to the same document. This instance is about a write that already IS atomic (one Firestore <code>.update()</code> call, guaranteed all-or-nothing by <code>saveMultipleLessonFields()</code>'s single-document design) but whose CONTENT can still be stale — <code>movedLesson</code>/<code>swappedSource</code>/<code>swappedDest</code> are built from a <code>currentLessonData</code> snapshot taken at grid-click time, with no freshness check before the atomic write fires.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4054:rg -n \"settings-link|data-tab=\\\"settings\\\"|switchTab\\('settings'\\)|#settings|footer-dot\\.write-control|write-control\" css js index.html e2e --glob '"'!e2e/test-results/**'"'
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4067:   160	//                                   memory, writes allowed (updateAppData()
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4103:js/app.js:329:    document.querySelector('.tab-btn[data-tab="settings"]')?.style.setProperty('display', 'none');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4115:index.html:54:    <button class="tab-btn write-control active" data-tab="curriculum-admin">Curriculum Admin</button>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4116:index.html:57:    <button class="tab-btn write-control" data-tab="settings">Settings</button>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4122:e2e/day-off-camps.spec.js:344:      await page.click('.tab-btn[data-tab="settings"]');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4123:e2e/day-off-camps.spec.js:453:      await page.click('.tab-btn[data-tab="settings"]');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4126:e2e/day-off-camps.spec.js:473:      await page.click('.tab-btn[data-tab="settings"]');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4131:e2e/day-off-camps.spec.js:494:    await page.click('.tab-btn[data-tab="settings"]');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4136:e2e/day-off-camps.spec.js:504:    await page.click('.tab-btn[data-tab="settings"]');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4139:e2e/day-off-camps.spec.js:639:      await page.click('.tab-btn[data-tab="settings"]');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4170:    10	- `updateAppData` one `update()` of named paths, refuses on failed load / bad registry — `firebase-data.js:212-239` ✓
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4173:    13	- **No other Tinker app reads `activeSemester`** ✓ — and I checked wider than the plan's list. The only cross-app reader of the `curriculum` collection is `studio-hub/js/alerts.js:562`, which reads `curriculum/lessonData` and iterates *all* semesters (`:573`), plus `summer-camp-app/scripts/backup-firestore.js:39` which just backs the collection up. Neither depends on the active flag. `summer-camp-app`'s `'curriculum'` (`js/app.js:85`, `js/config.js:63`) is its own tab/field name, not this collection.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4181:    21	Worth knowing *why* this has never bitten: **no spec has ever written `appData` for real.** Every existing appData test stubs `window.updateAppData` and asserts the payload (`data-safety.spec.js:3947-3949, 7596-7610, 7774, 7789`). Your spec would be the first to mutate shared emulator config. I'd follow the house pattern — stub-and-assert-payload for the shape scenarios, plus one real manager write for the round-trip and one real non-manager write for the rules refusal — rather than inventing a manager-authenticated helper and a restore protocol.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4197:    37	**6. Marking a switch "seen" for someone who wasn't moved consumes it permanently.** Your invisible-active-semester scenario asserts exactly this. If the semester is published later, that browser is never moved. Narrow window given auto-publish, but make it a decision rather than a side effect.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4205:    45	- **`updateAppData` isn't purely one `update()`** — on `not-found` it falls back to `set(nestFieldPaths(payload), {merge:true})` (`firebase-data.js:233-238`). Irrelevant for a document that exists, but the atomicity claim should say so.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4216:    56	Missing: (a) a payload-keys assertion for the auto-publish case, in the house style `expect(Object.keys(payload).sort()).toEqual([...])` (`data-safety.spec.js:7610`); (b) "a second tab already open is unaffected until reload" — Phase 2 asserts this in prose, nothing tests it; (c) the manager who performs the switch is themselves subject to it on their next load; (d) a UI-level check that the button is absent for a non-manager (cheap — `setupRoleAccess` hides Settings at `app.js:328-329`); (e) `updateAppData` refusing because `seasonRegistryMode` is `error`/`unknown` (`firebase-data.js:221-223`) — a live failure mode of this exact button, and the one most likely to hit Christie mid-term-change.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4221:    61	- **Multiple tabs / shared devices / clock skew**: the design holds. Tabs are consistent because `globalSemesterKey` is shared localStorage; a shared studio device consumes the switch once and every subsequent user on it lands on the new semester anyway, which is what you want; the not-equal comparison does neutralise skew as claimed. Ordering relative to `app.js:65-70` is correct — pre-setting a visible key makes the condition at `:65` false, so it won't override you, and nothing reads `globalSemesterKey` between `app.js:13` and the call at `:158`. First load after deploy moves nobody (verified: nothing reads the field until it exists).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4252:3. The browser has `seen=T1` and `globalSemesterKey=spring-2026`, so B is not switched.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4256:Required change: either explicitly change the promise to “once per browser,” or namespace the seen marker by authenticated UID. The latter matches the UI wording “switch everyone.”
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4258:### 3. Weekly deletion remains non-atomic and lacks the required snapshot
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4268:The plan also says “No bulk op, no delete: no snapshot needed” ([plan:253](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:253>)), although Phase 1 explicitly deletes an entire semester lesson map. That conflicts with the repository’s snapshot-before-bulk-delete requirement.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4274:- Snapshot the forced-server lesson map and abort if the snapshot fails.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4313:- The proposed Settings hiding, `switchTab` refusal, role check in `makeSemesterActive`, and Firestore manager-only write rule are sufficient for normal UI access. For a literal “cannot enter the panel” invariant, also reject Settings inside the tab button’s own click handler at [app.js:203](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:203), not only through `switchTab`.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4344:3. The browser has `seen=T1` and `globalSemesterKey=spring-2026`, so B is not switched.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4348:Required change: either explicitly change the promise to “once per browser,” or namespace the seen marker by authenticated UID. The latter matches the UI wording “switch everyone.”
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4350:### 3. Weekly deletion remains non-atomic and lacks the required snapshot
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4360:The plan also says “No bulk op, no delete: no snapshot needed” ([plan:253](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:253>)), although Phase 1 explicitly deletes an entire semester lesson map. That conflicts with the repository’s snapshot-before-bulk-delete requirement.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4366:- Snapshot the forced-server lesson map and abort if the snapshot fails.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md:4405:- The proposed Settings hiding, `switchTab` refusal, role check in `makeSemesterActive`, and Firestore manager-only write rule are sufficient for normal UI access. For a literal “cannot enter the panel” invariant, also reject Settings inside the tab button’s own click handler at [app.js:203](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:203), not only through `switchTab`.
/Users/christiehubley/studio-hub/firestore.rules:206:    match /payroll/appData/settingsHistory/{histId} {
/Users/christiehubley/studio-hub/firestore.rules:220:        && request.resource.data.rev == getAfter(/databases/$(database)/documents/payroll/appData).data.settingsRev;
/Users/christiehubley/studio-hub/firestore.rules:639:    //   Full read/write on all curriculum docs EXCEPT 'appData'.
/Users/christiehubley/studio-hub/firestore.rules:640:    //   appData (Settings doc): manager+ only, always.
/Users/christiehubley/studio-hub/firestore.rules:643:    //   Full read/write on all curriculum docs EXCEPT 'appData'.
/Users/christiehubley/studio-hub/firestore.rules:647:    //   appData (Settings doc): manager+ only, always.
/Users/christiehubley/studio-hub/firestore.rules:649:    // Manager+: full access including appData.
/Users/christiehubley/studio-hub/firestore.rules:652:    match /curriculum/{docId} {
/Users/christiehubley/studio-hub/firestore.rules:653:      // Manager+: full access to everything including appData
/Users/christiehubley/studio-hub/firestore.rules:656:      // classbook-admin, curriculum-admin (legacy key), and classbook: full read/write except appData and prepCycleConfig
/Users/christiehubley/studio-hub/firestore.rules:657:      // appData (Settings) is manager+ only, always
/Users/christiehubley/studio-hub/firestore.rules:668:        && docId != 'appData'
/Users/christiehubley/studio-hub/firestore.rules:677:        && docId != 'appData'
/Users/christiehubley/studio-hub/firestore.rules:690:    //   dayOffCamps_lessonData: one shared plan per camp-project. Teachers create/update like
/Users/christiehubley/studio-hub/firestore.rules:691:    //     summerCamps_lessonData (per-teacher isolation is UI-enforced — the same accepted gap as
/Users/christiehubley/studio-hub/firestore.rules:707:    match /dayOffCamps_lessonData/{docId} {
/Users/christiehubley/studio-hub/firestore.rules:729:    match /rosterManager/appData {
/Users/christiehubley/studio-hub/firestore.rules:746:    // curriculum, lessonData, projectDetails, projectLibrary, schedule:
/Users/christiehubley/studio-hub/firestore.rules:840:    match /summerCamps_lessonData/{docId} {
/Users/christiehubley/studio-hub/firestore.rules:956:    match /clayHub_appData/{docId} {
/Users/christiehubley/studio-hub/firestore.rules:1064:    // Written by ~/tinker-backups/backup.js after each local backup run (authenticated
/Users/christiehubley/studio-hub/firestore.rules:1068:    match /backupStatus/{docId} {
./CLAUDE.md:24:- `summerCamps_lessonData` — lesson-level detail records (shared with Summer Camp App)
./e2e/day-off-teacher.spec.js:11: * The TEST year lives only in each page's currentConfig (never in appData);
./e2e/day-off-teacher.spec.js:71:  page.evaluate(({ Y, id, title }) => __sdocT.read('lessonData', dayOffPlanDocId(Y, id, title)), { Y, id: camp.id, title });
./e2e/day-off-teacher.spec.js:86:  await p.waitForFunction(() => typeof lessonDataLoadedSuccessfully !== 'undefined' && lessonDataLoadedSuccessfully === true && !!currentLessonData, null, { timeout: 25_000 });
./e2e/day-off-teacher.spec.js:185:    await planner.evaluate(({ Y, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'Clay Creatures'))
./e2e/day-off-teacher.spec.js:203:      const real = window.getAuthUser;
./e2e/day-off-teacher.spec.js:204:      const as = (name) => { window.getAuthUser = () => ({ ...real(), name }); };
./e2e/day-off-teacher.spec.js:220:      } finally { window.getAuthUser = real; delete currentConfig.teacherMappings[real().uid]; }
./e2e/day-off-teacher.spec.js:237:    await planner.evaluate(({ Y, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'Clay Creatures'))
./e2e/day-off-teacher.spec.js:248:        await curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, campId, title)).update(coWrite);
./e2e/day-off-teacher.spec.js:269:    const me = await t.evaluate(() => getAuthUser().name);
./e2e/day-off-teacher.spec.js:281:        const ref = curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, campId, title));
./e2e/day-off-teacher.spec.js:294:    await planner.evaluate(({ Y, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'Clay Creatures'))
./e2e/day-off-teacher.spec.js:311:        await curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId('TEST_DATA_SAFETY_sdoc', id, 'Clay Creatures'))
./e2e/day-off-teacher.spec.js:443:      const real = window.getAuthUser;
./e2e/day-off-teacher.spec.js:444:      window.getAuthUser = () => ({ ...real(), appAccess: ['curriculum-admin'] });
./e2e/day-off-teacher.spec.js:446:      finally { window.getAuthUser = real; }
./e2e/day-off-teacher.spec.js:454:    await t.evaluate(() => { const real = window.getAuthUser; window.__realUser = real; window.getAuthUser = () => ({ ...real(), appAccess: ['curriculum-admin'] }); });
./e2e/day-off-teacher.spec.js:490:      const out = []; const real = window.updateAppData;
./e2e/day-off-teacher.spec.js:491:      window.updateAppData = async (u) => { out.push(u); };
./e2e/day-off-teacher.spec.js:492:      try { await toggleSemesterPublish(Y, true); } finally { window.updateAppData = real; }
./e2e/day-off-teacher.spec.js:503:  test('T14: the six other lesson writers still refuse an SDOC key, and curriculum/lessonData never gets one', async ({ browser }) => {
./e2e/day-off-teacher.spec.js:528:      const plan = await __sdocT.read('lessonData', dayOffPlanDocId(Y, campId, title));
./e2e/day-off-teacher.spec.js:530:      const d = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
./e2e/day-off-teacher.spec.js:637:    const signoffBefore = await planner.evaluate(({ Y, c }) => __sdocT.read('lessonData', dayOffSignoffDocId(Y, c)), { Y, c: clay.id });
./e2e/day-off-teacher.spec.js:654:    expect(await planner.evaluate(({ Y, c }) => __sdocT.read('lessonData', dayOffSignoffDocId(Y, c)), { Y, c: clay.id })).toEqual(signoffBefore);
./e2e/day-off-teacher.spec.js:697:    await planner.evaluate(({ Y, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'Clay Creatures'))
./e2e/day-off-teacher.spec.js:727:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'Glaze Day')).set({ yearKey: Y, campId: c, projectTitle: 'Glaze Day', projectLinks: 'https://not-an-array.test', projectDetails: { oops: 1 } }), { Y, c: clay.id });
./e2e/helpers/sdoc.js:34:    return el && el.children.length > 0 && !el.children[0].textContent.includes('Loading') && lessonDataLoadedSuccessfully === true;
./e2e/helpers/sdoc.js:48:    const COLLS = ['dayOffCamps_events', 'dayOffCamps_camps', 'dayOffCamps_lessonData'];
./e2e/helpers/firestore.js:85:// ─── Summer shape: summerCamps_lessonData/{lessonKey} (one document per lesson) ───
./e2e/helpers/firestore.js:101:  await setDoc(doc(db, 'summerCamps_lessonData', docId), { season: seasonOfTestDocId(docId), ...fields }, { merge: true });
./e2e/helpers/firestore.js:110:  const snap = await getDocFromServer(doc(db, 'summerCamps_lessonData', docId));
./e2e/helpers/firestore.js:117:  await deleteDoc(doc(db, 'summerCamps_lessonData', docId));
./e2e/helpers/firestore.js:164:// ─── Non-summer shape: curriculum/lessonData, one shared doc nested as
./e2e/helpers/firestore.js:179:const LESSON_DOC = (db) => doc(db, 'curriculum', 'lessonData');
./e2e/helpers/firestore.js:226:// deleteLessonKey(). Never deletes the shared lessonData document itself.
./e2e/helpers/firestore.js:243:// Cleanup — removes an entire TEST semester key from curriculum/lessonData.
./e2e/helpers/firestore.js:257:// ─── curriculum/cutProjects: { [semesterKey]: [...archiveEntries] } ───
./e2e/helpers/firestore.js:262:const CUT_PROJECTS_DOC = (db) => doc(db, 'curriculum', 'cutProjects');
./e2e/helpers/firestore.js:279:// Cleanup — removes the entire semesterKey field from curriculum/cutProjects.
./e2e/helpers/login.js:65:  // requireAuth() initialises Firebase on DOMContentLoaded, so this normally
./e2e/static-checks.spec.js:121:  test('1.2: no whole-document write of curriculum/appData remains', () => {
./e2e/static-checks.spec.js:123:    // seen. Every appData write goes through updateAppData()'s field paths.
./e2e/static-checks.spec.js:129:        if (/\.doc\(\s*['"]appData['"]\s*\)\s*\.set\(/.test(code)) offenders.push(`${rel}:${i + 1}: ${line.trim()}`);
./e2e/static-checks.spec.js:133:    expect(offenders, `whole-document appData writes remain:\n${offenders.join('\n')}`).toEqual([]);
./e2e/day-off-materials.spec.js:42:  page.evaluate(async ({ Y, id, title }) => __sdocT.read('lessonData', dayOffPlanDocId(Y, id, title)), { Y, id: camp.id, title });
./e2e/day-off-materials.spec.js:44:  page.evaluate(async ({ Y, id }) => __sdocT.read('lessonData', dayOffSignoffDocId(Y, id)), { Y, id: camp.id });
./e2e/day-off-materials.spec.js:64:      const writes = (await planner.evaluate(() => window.__spy.calls)).filter(c => c.via === 'tx.update' && c.path.startsWith('dayOffCamps_lessonData/'));
./e2e/day-off-materials.spec.js:171:    await planner.evaluate(({ Y, c }) => __sdocT.write('lessonData', dayOffPlanDocId(Y, c, 'Glaze Party'), { yearKey: Y, campId: c, projectTitle: 'Glaze Party' }), { Y, c: camp.id });
./e2e/day-off-materials.spec.js:193:    await planner.evaluate(({ Y, c }) => __sdocT.write('lessonData', dayOffPlanDocId(Y, c, 'TEST Taken'), { yearKey: Y, campId: c, projectTitle: 'TEST Taken', introPitch: 'TEST' }), { Y, c: camp.id });
./e2e/day-off-materials.spec.js:218:    await planner.evaluate(({ Y, c }) => __sdocT.write('lessonData', dayOffSignoffDocId(Y, c), { yearKey: Y, campId: c, kind: 'campSignoff', projectTitle: '#signoff', complete: false }), { Y, c: camp.id });
./e2e/day-off-materials.spec.js:290:      await curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, id, 'TEST Late')).set({ yearKey: Y, campId: id, projectTitle: 'TEST Late', materialItems: { mlate: { name: 'TEST late', qty: 1, scope: 'class set', order: 0 } } });
./e2e/day-off-materials.spec.js:307:      await curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, window.__renameCamp, 'Clay Creatures')).update({ [`materialChecks.${window.__tickItem}`]: { by: 'TEST other tab', at: new Date().toISOString() } });
./e2e/day-off-materials.spec.js:345:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'Clay Creatures'))
./e2e/day-off-materials.spec.js:401:        const realUser = window.getAuthUser;
./e2e/day-off-materials.spec.js:402:        window.getAuthUser = () => ({ ...realUser(), appAccess: ['classbook'] });   // a plain teacher
./e2e/day-off-materials.spec.js:404:        window.getAuthUser = realUser;
./e2e/day-off-materials.spec.js:556:      const signoffPath = await prep.evaluate(({ Y, c }) => `dayOffCamps_lessonData/${dayOffSignoffDocId(Y, c)}`, { Y, c: clay.id });
./e2e/day-off-materials.spec.js:667:      const realUser = window.getAuthUser;
./e2e/day-off-materials.spec.js:668:      window.getAuthUser = () => ({ ...realUser(), role: 'staff', appAccess: ['classbook'] });   // a plain teacher
./e2e/day-off-materials.spec.js:670:      finally { window.getAuthUser = realUser; renderDayOffAdmin(Y); }
./e2e/day-off-materials.spec.js:681:      await planner.evaluate(({ Y, c, t, id }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, t))
./e2e/day-off-materials.spec.js:885:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'Clay Creatures')).update({ projectLinks: ['https://example.test/theirs'] }), { Y, c: camp.id });
./e2e/day-off-materials.spec.js:904:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'Clay Creatures')).set({
./e2e/day-off-materials.spec.js:1000:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'Clay Creatures')).set({
./e2e/day-off-materials.spec.js:1053:    await planner.evaluate(({ Y, c }) => curriculumDb.collection('dayOffCamps_lessonData').doc(dayOffPlanDocId(Y, c, 'n/a')).set({ yearKey: Y, campId: c, projectTitle: 'n/a', materialItems: { mstray0000001: { name: 'TEST stray', qty: 1, scope: 'class set', order: 0 } } }), { Y, c: c2.id });
./AGENTS.md:26:- Fixture data is synthetic — never paste names, emails, uids or free text from a backup
./e2e/fixtures/seed/curriculum.json:2:  "appData": {
./e2e/fixtures/seed/curriculum.json:59:  "lessonData": {
./e2e/fixtures/seed/curriculum.json:130:  "cutProjects": {
./e2e/fixtures/seed/curriculum.json:158:  "changeLog": {
./e2e/fixtures/seed/curriculum.json:168:  "prepData": {
./e2e/day-off-camps.spec.js:11: * this tab's config — it is never written to appData — except in the one
./e2e/day-off-camps.spec.js:58:        const d = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
./e2e/day-off-camps.spec.js:93:        await curriculumDb.collection('curriculum').doc('appData').update({ [`semesters.${k}`]: firebase.firestore.FieldValue.delete() });
./e2e/day-off-camps.spec.js:102:    await page.evaluate(() => { window.__appDataWrites = 0; const u = window.updateAppData; window.updateAppData = async (...a) => { window.__appDataWrites++; return u(...a); }; });
./e2e/day-off-camps.spec.js:110:    expect(await page.evaluate(() => window.__appDataWrites)).toBe(0);
./e2e/day-off-camps.spec.js:232:    await page.evaluate(({ Y, id, planId }) => __sdocT.write('lessonData', planId, { yearKey: Y, campId: id, projectTitle: 'Clay Creatures', introPitch: 'TEST pitch' }), { Y, id: camp.id, planId });
./e2e/day-off-camps.spec.js:239:    expect(await page.evaluate(({ planId }) => __sdocT.read('lessonData', planId), { planId })).toBeNull();
./e2e/day-off-camps.spec.js:240:    expect(await page.evaluate(({ newId }) => __sdocT.read('lessonData', newId), { newId })).toMatchObject({ introPitch: 'TEST pitch', projectTitle: 'Clay Critters' });
./e2e/day-off-camps.spec.js:250:    expect(await page.evaluate(({ newId }) => __sdocT.read('lessonData', newId), { newId })).toMatchObject({ introPitch: 'TEST pitch' });
./e2e/day-off-camps.spec.js:282:      await page.evaluate(({ Y, id, planId, fields }) => __sdocT.write('lessonData', planId, { yearKey: Y, campId: id, projectTitle: 'Glaze Day', ...fields }), { Y, id: camp.id, planId, fields });
./e2e/day-off-camps.spec.js:287:      expect(await page.evaluate(({ planId }) => __sdocT.read('lessonData', planId), { planId })).not.toBeNull();
./e2e/day-off-camps.spec.js:295:    await page.evaluate(({ Y, id, planId }) => __sdocT.write('lessonData', planId, { yearKey: Y, campId: id, projectTitle: 'Glaze Day', introPitch: '  ', planComplete: false, materialsList: [], qaThread: [] }), { Y, id: camp.id, planId });
./e2e/day-off-camps.spec.js:299:    expect(await page.evaluate(({ planId }) => __sdocT.read('lessonData', planId), { planId })).toBeNull();
./e2e/day-off-camps.spec.js:338:      await curriculumDb.collection('curriculum').doc('appData').update({ [`semesters.${Y}`]: currentConfig.semesters[Y] });
./e2e/day-off-camps.spec.js:342:    await page.evaluate(() => { window.__captured = []; window.__origUpdate = window.updateAppData; window.updateAppData = async (u) => { window.__captured.push(u); }; });
./e2e/day-off-camps.spec.js:354:        window.updateAppData = window.__origUpdate;
./e2e/day-off-camps.spec.js:355:        await curriculumDb.collection('curriculum').doc('appData').update({ [`semesters.${Y}`]: firebase.firestore.FieldValue.delete() });
./e2e/day-off-camps.spec.js:362:      const realUser = window.getAuthUser;
./e2e/day-off-camps.spec.js:365:        window.getAuthUser = () => ({ ...realUser(), role: 'staff', appAccess: ['classbook'] });   // a plain teacher
./e2e/day-off-camps.spec.js:369:        window.getAuthUser = realUser;
./e2e/day-off-camps.spec.js:374:      } finally { window.getAuthUser = realUser; currentConfig.semesters[Y].name = realName; }
./e2e/day-off-camps.spec.js:400:      const realUser = window.getAuthUser;
./e2e/day-off-camps.spec.js:403:        window.getAuthUser = () => ({ ...realUser(), role: 'staff', appAccess: ['classbook'] });   // a plain teacher
./e2e/day-off-camps.spec.js:408:      } finally { window.getAuthUser = realUser; currentConfig.activeSemester = realActive; }
./e2e/day-off-camps.spec.js:423:    // The TEST year is not in server appData, so the in-tab pool is the fallback: the save is REFUSED
./e2e/day-off-camps.spec.js:451:    await page.evaluate(() => { window.__origUpdate = window.updateAppData; window.updateAppData = async () => { throw new Error('should not write'); }; });
./e2e/day-off-camps.spec.js:462:    } finally { await page.evaluate(() => { window.updateAppData = window.__origUpdate; }); }
./e2e/day-off-camps.spec.js:507:    await page.evaluate(() => { window.__writes = 0; window.__origUpdate = window.updateAppData; window.updateAppData = async () => { window.__writes++; }; });
./e2e/day-off-camps.spec.js:514:    } finally { await page.evaluate(() => { window.updateAppData = window.__origUpdate; }); }
./e2e/day-off-camps.spec.js:635:    await page.evaluate(() => { window.__captured = []; window.__origUpdate = window.updateAppData; window.updateAppData = async (u) => { window.__captured.push(JSON.parse(JSON.stringify(u))); }; });
./e2e/day-off-camps.spec.js:671:      await page.evaluate(() => { window.updateAppData = window.__origUpdate; });
./e2e/day-off-camps.spec.js:679:    await page.evaluate(() => { window.__appDataWrites = 0; const u = window.updateAppData; window.updateAppData = async (...a) => { window.__appDataWrites++; return u(...a); }; });
./e2e/day-off-camps.spec.js:682:    expect(await page.evaluate(() => window.__appDataWrites)).toBe(0);
./e2e/day-off-camps.spec.js:706:      const lessonDoc = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
./e2e/day-off-camps.spec.js:731:        const guard = lessonDataLoadedSuccessfully;
./e2e/day-off-camps.spec.js:742:    expect(await page.evaluate(() => lessonDataLoadedSuccessfully)).toBe(true);
./e2e/README.md:68:behave the same way; one spec test depends on it (`backupStatus` is
./e2e/README.md:72:Fixture shapes follow the Sep 2026 production backup. **Every name, email,
./e2e/README.md:74:backup goes in here without being replaced. The spec relies on the
./index.html:355:      <section class="ca-section ca-backup-health-section">
./index.html:356:        <button class="ca-section-toggle" id="ca-backup-health-toggle" onclick="toggleBackupHealth()">
./index.html:360:        <div class="ca-section-content" id="ca-backup-health-content" style="display:none"></div>
./e2e/data-safety.spec.js:136:// Instead, we test the mechanism directly: set lessonDataLoadedSuccessfully=false
./e2e/data-safety.spec.js:140:// Wait for the DOMContentLoaded init sequence to finish (lesson data attempted).
./e2e/data-safety.spec.js:161:    lessonDataLoadedSuccessfully = false;
./e2e/data-safety.spec.js:165:// Stops the curriculum/lessonData listener so it cannot overwrite injected
./e2e/data-safety.spec.js:171:// lessonDataUnsubscribe / globalListenerGeneration are `let`s in
./e2e/data-safety.spec.js:175:    if (typeof lessonDataUnsubscribe === 'function') lessonDataUnsubscribe();
./e2e/data-safety.spec.js:289:    // currentLessonData and lessonDataLoadedSuccessfully are `let` variables in firebase-data.js.
./e2e/data-safety.spec.js:327:    await page.evaluate(() => { lessonDataLoadedSuccessfully = true; });
./e2e/data-safety.spec.js:471:// All three operate on the non-summer curriculum/lessonData shared doc — the
./e2e/data-safety.spec.js:513:  // flip lessonDataLoadedSuccessfully back to true under a test that has just
./e2e/data-safety.spec.js:518:    lessonDataLoadedSuccessfully = true;
./e2e/data-safety.spec.js:803:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; });
./e2e/data-safety.spec.js:998:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; });
./e2e/data-safety.spec.js:1305:      const docRef = curriculumDb.collection('summerCamps_lessonData').doc(encodeFirestoreKey(key));
./e2e/data-safety.spec.js:1569:// ─── Phase 5: 4B — backup health panel ──────────────────────────────────────
./e2e/data-safety.spec.js:1573:// backupStatus/latest doc, which is a shared singleton written by the real
./e2e/data-safety.spec.js:1574:// ~/tinker-backups/backup.js script every 30 min. Writing test fixtures there
./e2e/data-safety.spec.js:1575:// would momentarily corrupt production backup status for every app reading it.
./e2e/data-safety.spec.js:1579:  test('healthy recent backup with no errors renders OK, no flags', async ({ browser }) => {
./e2e/data-safety.spec.js:1594:    const text = await page.locator('#ca-backup-health-content').innerText();
./e2e/data-safety.spec.js:1617:    const text = await page.locator('#ca-backup-health-content').innerText();
./e2e/data-safety.spec.js:1639:    const text = await page.locator('#ca-backup-health-content').innerText();
./e2e/data-safety.spec.js:1656:        errorCollections: ['summerCamps_lessonData'],
./e2e/data-safety.spec.js:1661:    const text = await page.locator('#ca-backup-health-content').innerText();
./e2e/data-safety.spec.js:1662:    expect(text).toContain('Errors backing up: summerCamps_lessonData');
./e2e/data-safety.spec.js:1676:    const text = await page.locator('#ca-backup-health-content').innerText();
./e2e/data-safety.spec.js:1677:    expect(text).toContain('No backup status recorded yet');
./e2e/data-safety.spec.js:1683:  test('real end-to-end: renderBackupHealth() reads the actual backupStatus/latest doc without crashing (read-only smoke test)', async ({ browser }) => {
./e2e/data-safety.spec.js:1691:    // real profile of a non-manager curriculum admin. backupStatus is
./e2e/data-safety.spec.js:1694:    const text = await page.locator('#ca-backup-health-content').innerText();
./e2e/data-safety.spec.js:1697:    expect(text).not.toContain('Failed to load backup status');
./e2e/data-safety.spec.js:1706:// renderContentCountData(liveCounts, backupCounts) is a pure render function —
./e2e/data-safety.spec.js:1708:// real backupStatus/latest doc (see the Phase 5: 4B block above for why).
./e2e/data-safety.spec.js:1712:  test('a drop of more than 10% since the backup baseline is flagged; a small drop is not', async ({ browser }) => {
./e2e/data-safety.spec.js:1720:        { TeacherWiped: 50, TeacherStable: 50 }  // backup-derived baseline
./e2e/data-safety.spec.js:1737:  test('a teacher with no backup baseline (new, nothing to compare) is never flagged', async ({ browser }) => {
./e2e/data-safety.spec.js:1757:  test('no backup comparison available yet renders a neutral note, not an alarm, and live counts still show', async ({ browser }) => {
./e2e/data-safety.spec.js:1767:    expect(text).toContain('No backup-derived comparison available yet');
./e2e/data-safety.spec.js:1774:  test('real end-to-end: renderContentCount() computes live counts and degrades gracefully without a backup comparison (read-only smoke test)', async ({ browser }) => {
./e2e/data-safety.spec.js:1782:    // manager+ access to backupStatus/latest, so this exercises the graceful
./e2e/data-safety.spec.js:1992:      // Force ONLY the cutProjects doc's write to fail — cutProject() reads
./e2e/data-safety.spec.js:1993:      // curriculum/lessonData first (the existence check), which must keep
./e2e/data-safety.spec.js:1995:      // wrong reason. Delegate everything except .doc('cutProjects').set()
./e2e/data-safety.spec.js:2004:            doc: (docId) => docId === 'cutProjects'
./e2e/data-safety.spec.js:2396:            doc: (docId) => docId === 'cutProjects'
./e2e/data-safety.spec.js:2433:// (unlike the per-semester cutProjects doc), so every test below intercepts
./e2e/data-safety.spec.js:2827:          return { doc: () => ({ set: async () => { throw new Error('Simulated changeLog write failure'); } }) };
./e2e/data-safety.spec.js:2949:  test('sendQaReply() routes a summer-semester reply to summerCamps_lessonData, not curriculum/lessonData', async ({ browser }) => {
./e2e/data-safety.spec.js:2978:      expect(nonSummerDoc).toBeNull(); // must NOT have landed in curriculum/lessonData under a 'summer-2026' key
./e2e/data-safety.spec.js:3079:          await curriculumDb.collection('curriculum').doc('lessonData').update({
./e2e/data-safety.spec.js:3100:  test('sendHelpResponse() routes a summer-semester reply to summerCamps_lessonData, not curriculum/lessonData', async ({ browser }) => {
./e2e/data-safety.spec.js:3134:      expect(nonSummerDoc).toBeNull(); // must NOT have landed in curriculum/lessonData under a 'summer-2026' key
./e2e/data-safety.spec.js:3203:          await curriculumDb.collection('curriculum').doc('lessonData').update({
./e2e/data-safety.spec.js:3832:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; });
./e2e/data-safety.spec.js:3899:// appData is Manager+-only under Firestore rules (this repo's TEST_ account
./e2e/data-safety.spec.js:3943:      // Phase 1 (1.2): the config writer is updateAppData(), which is handed
./e2e/data-safety.spec.js:3947:        const original = window.updateAppData;
./e2e/data-safety.spec.js:3948:        window.updateAppData = async (updates) => { captured = JSON.parse(JSON.stringify(updates)); };
./e2e/data-safety.spec.js:3949:        try { await createNewSemester(); } finally { window.updateAppData = original; }
./e2e/data-safety.spec.js:3956:      // (the stub stands in for updateAppData itself, so the lastUpdated/
./e2e/data-safety.spec.js:3968:  // semester's empty lesson slots to curriculum/lessonData FIRST, then writes
./e2e/data-safety.spec.js:3977:  // account can't write curriculum/appData), same pattern as the test above.
./e2e/data-safety.spec.js:4035:        const originalSaveConfig = window.updateAppData;
./e2e/data-safety.spec.js:4040:        window.updateAppData = async () => {
./e2e/data-safety.spec.js:4046:          throw new Error('TEST simulated appData write failure');
./e2e/data-safety.spec.js:4055:          window.updateAppData = originalSaveConfig;
./e2e/data-safety.spec.js:4065:          lessonDataHasKey: !!currentLessonData && Object.prototype.hasOwnProperty.call(currentLessonData, newKey),
./e2e/data-safety.spec.js:4083:      expect(result.lessonDataHasKey).toBe(false);
./e2e/data-safety.spec.js:4141:        const originalSaveConfig = window.updateAppData;
./e2e/data-safety.spec.js:4143:        window.updateAppData = async () => { saveConfigCalls++; };
./e2e/data-safety.spec.js:4151:          window.updateAppData = originalSaveConfig;
./e2e/data-safety.spec.js:4214:        const originalSaveConfig = window.updateAppData;
./e2e/data-safety.spec.js:4216:        window.updateAppData = async () => { saveConfigCalls++; };
./e2e/data-safety.spec.js:4221:          window.updateAppData = originalSaveConfig;
./e2e/data-safety.spec.js:4243:  // Round-3 review (mutation gap): the `if (lessonDataCommitted)` gate on the
./e2e/data-safety.spec.js:4274:        const originalSaveConfig = window.updateAppData;
./e2e/data-safety.spec.js:4276:        window.updateAppData = async () => { throw new Error('TEST simulated appData write failure'); };
./e2e/data-safety.spec.js:4284:          window.updateAppData = originalSaveConfig;
./e2e/data-safety.spec.js:4332:        const originalSaveConfig = window.updateAppData;
./e2e/data-safety.spec.js:4342:        window.updateAppData = async () => { saveConfigCalls++; };
./e2e/data-safety.spec.js:4364:          window.updateAppData = originalSaveConfig;
./e2e/data-safety.spec.js:4434:      await page.evaluate(({ semKey, key, entry }) => curriculumDb.collection('curriculum').doc('lessonData').update({
./e2e/data-safety.spec.js:4462:      const role = await page.evaluate(() => getAuthUser()?.role);
./e2e/data-safety.spec.js:4463:      const me = await page.evaluate(() => getAuthUser()?.name);
./e2e/data-safety.spec.js:4512:      // leave the real curriculum/lessonData listener subscribed, so the
./e2e/data-safety.spec.js:4546:      await page.evaluate(({ semKey, key, entry }) => curriculumDb.collection('curriculum').doc('lessonData').update({
./e2e/data-safety.spec.js:4624:  test('guard (review): a summer-camp semester key is refused — nothing is written into curriculum/lessonData under it', async ({ browser }) => {
./e2e/data-safety.spec.js:4655:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; });
./e2e/data-safety.spec.js:4711:  // The curriculum/lessonData listener (re-subscribed by initSummerContext's
./e2e/data-safety.spec.js:4719:      if (typeof lessonDataUnsubscribe === 'function') lessonDataUnsubscribe();
./e2e/data-safety.spec.js:4723:    // cache undefined until its ~1.5 s read lands (curriculum/lessonData has
./e2e/data-safety.spec.js:5312:// ─── Backtracking audit Phase 7: the curriculum/lessonData listener ──────────
./e2e/data-safety.spec.js:5326:test.describe('Data Safety — lessonData listener: summer reload outcomes (Backtracking audit Phase 7)', () => {
./e2e/data-safety.spec.js:5327:  // These tests wait on real snapshots of the shared curriculum/lessonData doc,
./e2e/data-safety.spec.js:5332:  // Land a write on curriculum/lessonData so every subscribed listener gets a snapshot.
./e2e/data-safety.spec.js:5364:    flag: lessonDataLoadedSuccessfully,
./e2e/data-safety.spec.js:5414:      await page.waitForFunction(() => lessonDataLoadedSuccessfully === false, null, { timeout: 5_000 });
./e2e/data-safety.spec.js:5440:      await page.waitForFunction(() => lessonDataLoadedSuccessfully === false, null, { timeout: 5_000 });
./e2e/data-safety.spec.js:5548:      await page.evaluate(() => { lessonDataLoadedSuccessfully = false; document.getElementById('lesson-load-error-banner').classList.remove('hidden'); });
./e2e/data-safety.spec.js:5676:      await page.evaluate(() => { if (typeof lessonDataUnsubscribe === 'function') lessonDataUnsubscribe(); window.setupLessonDataListener = () => {}; });
./e2e/data-safety.spec.js:5724:    await page.evaluate(() => { if (typeof lessonDataUnsubscribe === 'function') lessonDataUnsubscribe(); window.setupLessonDataListener = () => {}; });
./e2e/data-safety.spec.js:5812:        const uid = getAuthUser()?.uid;
./e2e/data-safety.spec.js:6235:  test('RED (summer first save): a generated, never-saved summer lesson — present in the cache, NO doc in summerCamps_lessonData — saves on the first try; the existence check is skipped for the summer schema', async ({ browser }) => {
./e2e/data-safety.spec.js:7173:        // block only — never swap currentConfig itself (appData is written from it).
./e2e/data-safety.spec.js:7368:// created a nested map for it inside the shared curriculum/lessonData
./e2e/data-safety.spec.js:7393:  test('RED (1.1): a WEEKLY semester whose key starts with summer- saves to curriculum/lessonData, not the camp collection', async ({ browser }) => {
./e2e/data-safety.spec.js:7401:      // Pre-Phase-1 this routed on the key: it went to summerCamps_lessonData
./e2e/data-safety.spec.js:7476:          saveMultipleLessonFields: await attempt(() => saveMultipleLessonFields(semKey, [{ lessonKey: key, lessonData: lesson, fieldsToClear: [] }])),
./e2e/data-safety.spec.js:7540:// ─── Camp seasons Phase 1 (1.2): curriculum/appData ──────────────────────────
./e2e/data-safety.spec.js:7551:// It is gone. Every appData write is now one update() of dotted field paths
./e2e/data-safety.spec.js:7552:// through updateAppData(), so a writer can only ever touch the paths it names.
./e2e/data-safety.spec.js:7557:// curriculum/appData is manager+ under the real rules and the e2e account is
./e2e/data-safety.spec.js:7562:test.describe('Data Safety — camp seasons Phase 1: appData writes are field paths, and loadConfig() goes loud', () => {
./e2e/data-safety.spec.js:7564:  // Replaces curriculum/appData's document ref with a spy for one block.
./e2e/data-safety.spec.js:7573:        doc: (docId) => docId !== 'appData' ? real.doc(docId) : {
./e2e/data-safety.spec.js:7576:          get: async () => real.doc('appData').get(),
./e2e/data-safety.spec.js:7596:  test('RED (1.2): updateAppData() writes ONE update() of exactly the paths it was given, plus the two stamps — never a whole document', async ({ browser }) => {
./e2e/data-safety.spec.js:7603:        await updateAppData({ 'semesters.test-x.published': true });
./e2e/data-safety.spec.js:7617:  test('RED (1.2): on not-found (no appData document yet) updateAppData() falls back to a NESTED merge-set, never a bare set', async ({ browser }) => {
./e2e/data-safety.spec.js:7630:            doc: (docId) => docId !== 'appData' ? real.doc(docId) : {
./e2e/data-safety.spec.js:7637:          await updateAppData({ 'semesters.test-x.name': 'TEST X', 'activeSemester': 'test-x' });
./e2e/data-safety.spec.js:7653:  test('RED (1.2): a read ERROR on appData is loud — banner, no lesson load, every writer refusing; a MISSING document is just initialisation', async ({ browser }) => {
./e2e/data-safety.spec.js:7663:        const savedConfig = currentConfig, savedFlag = lessonDataLoadedSuccessfully;
./e2e/data-safety.spec.js:7669:          return { doc: (d) => d !== 'appData' ? realCollection('curriculum').doc(d) : {
./e2e/data-safety.spec.js:7676:            flag: lessonDataLoadedSuccessfully,
./e2e/data-safety.spec.js:7685:          currentConfig = savedConfig; lessonDataLoadedSuccessfully = savedFlag;
./e2e/data-safety.spec.js:7698:        const savedConfig = currentConfig, savedFlag = lessonDataLoadedSuccessfully;
./e2e/data-safety.spec.js:7701:          return { doc: (d) => d !== 'appData' ? realCollection('curriculum').doc(d) : {
./e2e/data-safety.spec.js:7708:            flag: lessonDataLoadedSuccessfully,
./e2e/data-safety.spec.js:7715:          currentConfig = savedConfig; lessonDataLoadedSuccessfully = savedFlag;
./e2e/data-safety.spec.js:7740:          return { doc: (d) => d !== 'appData' ? realCollection('curriculum').doc(d) : {
./e2e/data-safety.spec.js:7886:// successful load would otherwise set lessonDataLoadedSuccessfully = true and
./e2e/data-safety.spec.js:7898:      const saved = { mode: getSeasonRegistryMode(), flag: lessonDataLoadedSuccessfully };
./e2e/data-safety.spec.js:7905:        lessonDataLoadedSuccessfully = saved.flag;
./e2e/data-safety.spec.js:7925:        const deniedFlag = lessonDataLoadedSuccessfully;
./e2e/data-safety.spec.js:7928:        const offlineFlag = lessonDataLoadedSuccessfully;
./e2e/data-safety.spec.js:7961:        out.flagAfter = lessonDataLoadedSuccessfully;
./e2e/data-safety.spec.js:8060:          flag: lessonDataLoadedSuccessfully,
./e2e/data-safety.spec.js:8356:        const appDataWrites = [];
./e2e/data-safety.spec.js:8358:        const realUpdate = window.updateAppData;
./e2e/data-safety.spec.js:8361:        window.updateAppData = async (u) => { appDataWrites.push(JSON.parse(JSON.stringify(u))); };
./e2e/data-safety.spec.js:8369:          return { appDataWrites, lessonWrites, created: JSON.parse(JSON.stringify(currentConfig.semesters[`summer-${reg.season}`] || null)) };
./e2e/data-safety.spec.js:8371:          window.updateAppData = realUpdate; window.saveLessonData = realSaveLessons; window.readAppDataFromServer = realRead;
./e2e/data-safety.spec.js:8377:      expect(r.appDataWrites.length).toBe(1);
./e2e/data-safety.spec.js:8378:      expect(Object.keys(r.appDataWrites[0])).toEqual(['semesters.summer-2031']);
./e2e/data-safety.spec.js:8436:        const realUpdate = window.updateAppData;
./e2e/data-safety.spec.js:8438:        window.updateAppData = async (u) => { writes.push(JSON.parse(JSON.stringify(u))); };
./e2e/data-safety.spec.js:8448:          window.updateAppData = realUpdate; window.readAppDataFromServer = realRead;
./e2e/data-safety.spec.js:8487:        const realUpdate = window.updateAppData;
./e2e/data-safety.spec.js:8489:        const appDataWrites = []; const lessonDeletes = [];
./e2e/data-safety.spec.js:8490:        window.updateAppData = async (u) => { appDataWrites.push(Object.keys(u)); delete currentConfig.semesters[sem]; };
./e2e/data-safety.spec.js:8494:          return { confirms, appDataWrites, lessonDeletes, stillInMemory: !!currentLessonData[sem] };
./e2e/data-safety.spec.js:8497:          window.updateAppData = realUpdate; window.deleteLessonData = realDeleteLessons;
./e2e/data-safety.spec.js:8506:      // Only the appData entry is written, and curriculum/lessonData is never
./e2e/data-safety.spec.js:8508:      expect(r.appDataWrites).toEqual([['semesters.summer-2031']]);
./e2e/data-safety.spec.js:8531:        const realUpdate = window.updateAppData; const realDelete = window.deleteLessonData;
./e2e/data-safety.spec.js:8533:        window.updateAppData = async () => { delete currentConfig.semesters[sem]; };
./e2e/data-safety.spec.js:8536:        finally { window.confirm = realConfirm; window.updateAppData = realUpdate; window.deleteLessonData = realDelete; delete currentConfig.semesters[sem]; }
./e2e/data-safety.spec.js:8553:        const realUpdate = window.updateAppData;
./e2e/data-safety.spec.js:8555:        window.updateAppData = async (u) => { writes.push(u); };
./e2e/data-safety.spec.js:8571:        } finally { window.readAppDataFromServer = realRead; window.updateAppData = realUpdate; pendingSemesterTypeStamps = null; }
./e2e/data-safety.spec.js:8578:      expect(r.output).toMatch(/backup/i);                        // it tells her to back up first
./e2e/data-safety.spec.js:8592:        const realUpdate = window.updateAppData;
./e2e/data-safety.spec.js:8601:          window.updateAppData = async () => {};
./e2e/data-safety.spec.js:8608:          window.updateAppData = async (u) => {
./e2e/data-safety.spec.js:8621:        } finally { window.readAppDataFromServer = realRead; window.updateAppData = realUpdate; pendingSemesterTypeStamps = null; }
./e2e/data-safety.spec.js:8645:        const realUpdate = window.updateAppData;
./e2e/data-safety.spec.js:8657:          window.updateAppData = async (u) => {
./e2e/data-safety.spec.js:8669:        } finally { window.readAppDataFromServer = realRead; window.updateAppData = realUpdate; pendingSemesterTypeStamps = null; }
./e2e/data-safety.spec.js:8693:        const realUpdate = window.updateAppData;
./e2e/data-safety.spec.js:8694:        window.updateAppData = async (u) => { writes.push(JSON.parse(JSON.stringify(u))); };
./e2e/data-safety.spec.js:8715:          window.updateAppData = realUpdate;
./e2e/data-safety.spec.js:8755:          const duringFlag = lessonDataLoadedSuccessfully;
./e2e/data-safety.spec.js:8760:            afterFlag: lessonDataLoadedSuccessfully,
./e2e/data-safety.spec.js:8780:  test('RED (review HIGH): appData writers refuse while the season registry is unreadable', async ({ browser }) => {
./e2e/data-safety.spec.js:8792:            update: await attempt(() => updateAppData({ 'semesters.test-x.published': true })),
./e2e/data-safety.spec.js:8838:        const realUpdate = window.updateAppData;
./e2e/data-safety.spec.js:8847:          window.updateAppData = async (u) => {
./e2e/data-safety.spec.js:8861:          window.updateAppData = async (u) => {
./e2e/data-safety.spec.js:8873:        } finally { window.readAppDataFromServer = realRead; window.updateAppData = realUpdate; pendingSemesterTypeStamps = null; }
./e2e/data-safety.spec.js:9032:        const savedFlag = lessonDataLoadedSuccessfully;
./e2e/data-safety.spec.js:9034:        lessonDataLoadedSuccessfully = false;
./e2e/data-safety.spec.js:9041:          lessonDataLoadedSuccessfully = savedFlag;
./e2e/data-safety.spec.js:9068:        const realList = window.listRegisteredSeasons; const realUpdate = window.updateAppData;
./e2e/data-safety.spec.js:9077:          window.updateAppData = async () => { throw new Error('TEST simulated write failure'); };
./e2e/data-safety.spec.js:9082:          window.alert = realAlert; window.listRegisteredSeasons = realList; window.updateAppData = realUpdate;
./e2e/data-safety.spec.js:9111:        const realUpdate = window.updateAppData;
./e2e/data-safety.spec.js:9112:        window.updateAppData = async () => { throw new Error('TEST simulated write failure'); };
./e2e/data-safety.spec.js:9120:          window.alert = realAlert; window.confirm = realConfirm; window.updateAppData = realUpdate;
./CLASSBOOK-DATA-SAFETY-PLAN.md:10:Two separate wipe events destroyed teacher lesson plan content (introPitch, processStep1–4, closure, dayOfMaterials) in the `summerCamps_lessonData` Firestore collection.
./CLASSBOOK-DATA-SAFETY-PLAN.md:18:**Data recovery**: All content restored from `~/tinker-backups/tinker-backup-2026-05-15T21-17-31.json` (3:17 PM pre-wipe backup). Photos restored by fetching current Firebase Storage download tokens. All 25 teacher photos verified HTTP 200.
./CLASSBOOK-DATA-SAFETY-PLAN.md:26:- ✅ All teacher content restored from backup
./CLASSBOOK-DATA-SAFETY-PLAN.md:41:  - **4A — Content Count by Teacher**: new admin panel (Curriculum Admin, below Change History) computing today's live per-teacher lesson-content count from `summerCamps_lessonData` + `curriculum/lessonData` and comparing it to a backup-derived baseline (see 4B). Only a >10% drop is red-flagged (same threshold `~/tinker-backups/backup.js` already uses for its own collection-level check) — a teacher with no recorded baseline, or a small routine edit, is never falsely flagged. `CONTENT_FIELDS`/`lessonHasContent()` — previously duplicated across 4 call sites in `app.js`/`firebase-data.js` — consolidated into one shared constant in `firebase-data.js` as part of this work.
./CLASSBOOK-DATA-SAFETY-PLAN.md:42:  - **4B — Backup Health**: new admin panel reads the existing `backupStatus/latest` Firestore doc (already written every 30 min by `~/tinker-backups/backup.js`, part of the Firebase Backend Resilience plan's Step 1) rather than building a second, local-log-only check. Flags a stale `lastSuccessAt` (>2h old, business hours only), `errorCollections`, and `dataLossWarningCollections`. `backupStatus` is manager/admin-only by existing rule (shared across every Tinker HQ app) — a curriculum-admin appAccess staff member (not a manager) gets a neutral "visible to admins and managers only" note instead of a false "failed to load" alarm; found and fixed by testing against real Firestore rules with the actual e2e test account, which is exactly that profile.
./CLASSBOOK-DATA-SAFETY-PLAN.md:43:  - **4A's backup-derived baseline**: `~/tinker-backups/backup.js` extended (isolated in its own try/catch so a bug there can never break the shared backup run for every other app) to tally per-teacher content-doc counts from data it already fetches every run, written into a new `classbookContentByTeacher` field on `backupStatus/latest`. `writeBackupStatus()`'s value-conversion helper generalized to a recursive `toFirestoreValue()` so a nested per-teacher count map round-trips as a Firestore `mapValue` instead of the previous string/number/array-only converter silently stringifying it to `"[object Object]"`. Verified against real production Firestore: a live `--force` run's written `classbookContentByTeacher` was read back and matched an independent recomputation from the same run's raw backup JSON file, teacher-by-teacher.
./CLASSBOOK-DATA-SAFETY-PLAN.md:45:- ✅ Stage 5 — Expand test coverage (Aug 13, 2026). Checked all 7 items on this stage's original checklist against tests already added while shipping Phases 1–5: 6 of 7 were already covered as a side effect (admin move abort/restore, admin swap targeted-saves + canary, Plan Complete checkbox / Test 5, non-summer stripping, read-back verification error, intentional field clear). Only "content-count dashboard shows correct numbers for a seeded test teacher" was genuinely open — added one test seeding known content across both `summerCamps_lessonData` and `curriculum/lessonData` for a dedicated test teacher, asserting `computeLiveContentCountByTeacher()` returns exactly the expected count and excludes a deliberately contentless lesson. Validated the test's own worth by temporarily breaking the `hasContent` filter, confirming the test failed (4 instead of 3), then restoring and confirming green — same discipline as every prior phase's red/green cycle, applied here to prove a coverage test actually exercises what it claims. Test-only change, no app code touched. **This closes the Classbook Data Safety Plan — all 5 remaining-stages phases (and the earlier Stages 0/1A/1B/1C) are shipped, tested, committed, and deployed to production.**
./CLASSBOOK-DATA-SAFETY-PLAN.md:69:- **4B (6 tests)**: healthy/no-errors renders OK with no flags; a >2h-stale `lastSuccessAt` is flagged only when `isBusinessHours` is true (the same stale timestamp outside business hours is not flagged); `errorCollections`/`dataLossWarningCollections` both surface as flags; no recorded status yet renders a neutral message, not an alarm; a real end-to-end read of the live `backupStatus/latest` doc — the test account is `role:'staff'` with `curriculum-admin` appAccess (a real non-manager admin profile), so this exercises and confirms the permission-denied → neutral-message path, not a generic failure.
./CLASSBOOK-DATA-SAFETY-PLAN.md:70:- **4A (4 tests)**: a >10% drop against a real backup baseline is flagged with the correct "Dropped from X to Y" text and flagged-count summary, while a 4% drop on a sibling teacher in the same render is not; a teacher with no recorded backup baseline is never flagged; no backup comparison available yet still renders live counts with a neutral note, not an alarm; a real end-to-end call to `renderContentCount()` computes live counts against real Firestore and degrades gracefully when the backup comparison is inaccessible.
./CLASSBOOK-DATA-SAFETY-PLAN.md:71:- 9 of these 12 touch no Firestore at all — `renderBackupHealthData`/`renderContentCountData` are pure functions tested directly with synthetic data, since `backupStatus/latest` is a shared singleton written by the real 30-min backup script and isn't safe to overwrite with test fixtures. The 4C wipe-flag test exercises a real save through existing Firestore infra (same pattern as every other save-path test in this file). The 4B and 4A "real end-to-end" tests are genuine read-only smoke tests against real production Firestore. 34/34 tests green.
./CLASSBOOK-DATA-SAFETY-PLAN.md:94:| 10 | Backup failure goes undetected for days | backup system | **HIGH** | 1 |
./CLASSBOOK-DATA-SAFETY-PLAN.md:158:**Test data strategy**: Tests write to real `summerCamps_lessonData` in `tinker-hq-apps`. To avoid polluting real teacher data, all test docs use a dedicated teacher name `"TEST"` and a camp name `"TEST_DATA_SAFETY"`. These will never appear in the real teacher views because no curriculum camp is assigned to teacher "TEST". Clean up after each test run.
./CLASSBOOK-DATA-SAFETY-PLAN.md:160:In the Classbook's Firestore rules, teacher "TEST" must have write access to `summerCamps_lessonData`. Check `studio-hub/firestore.rules` — if the rule grants write to any authenticated user with `appAccess: ['classbook']`, the test account already qualifies.
./CLASSBOOK-DATA-SAFETY-PLAN.md:238:  // Block the summerCamps_lessonData Firestore fetch
./CLASSBOOK-DATA-SAFETY-PLAN.md:239:  await page.route('**/summerCamps_lessonData**', route => route.abort());
./CLASSBOOK-DATA-SAFETY-PLAN.md:258:  await page.route('**/summerCamps_lessonData**', route => route.abort());
./CLASSBOOK-DATA-SAFETY-PLAN.md:397:  const url = new URL(`https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/summerCamps_lessonData/${encodedId}`);
./CLASSBOOK-DATA-SAFETY-PLAN.md:413:    `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/summerCamps_lessonData/${encodeURIComponent(docId)}`,
./CLASSBOOK-DATA-SAFETY-PLAN.md:426:    `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/summerCamps_lessonData/${encodeURIComponent(docId)}`,
./CLASSBOOK-DATA-SAFETY-PLAN.md:504:**What to change**: Add a module-level flag `lessonDataLoadedSuccessfully`. Set it `false` before the fetch, `true` after successful merge, leave `false` if catch fires.
./CLASSBOOK-DATA-SAFETY-PLAN.md:507:**What to change**: After `loadSummerCampData()` returns, if `lessonDataLoadedSuccessfully` is false, render a blocking error banner instead of the normal view:
./CLASSBOOK-DATA-SAFETY-PLAN.md:517:if (!lessonDataLoadedSuccessfully) {
./CLASSBOOK-DATA-SAFETY-PLAN.md:522:**Why**: If the Firestore read for `summerCamps_lessonData` fails (network error, rules regression, quota exceeded), teachers currently see blank lesson plans with no warning. With the stripping fix in place, saves won't wipe content — but teachers don't know their content is missing and may re-enter work or be confused. The banner makes the failure visible and the save guard prevents any writes until data is confirmed loaded.
./CLASSBOOK-DATA-SAFETY-PLAN.md:524:**Verify**: In browser devtools, block the `summerCamps_lessonData` network request. Confirm banner appears and Save button is disabled.
./CLASSBOOK-DATA-SAFETY-PLAN.md:589:**File**: `~/Library/LaunchAgents/com.tinkerhq.classbook-backup.plist`
./CLASSBOOK-DATA-SAFETY-PLAN.md:592:**Why**: The next-session notes say to switch to daily after May 22 to reduce backup overhead. But summer camp teachers are actively entering lesson plans daily June–August. A daily backup means up to 24 hours of work is at risk in a wipe event. The 30-minute backup is the entire recovery window. Keep it until summer camp ends.
./CLASSBOOK-DATA-SAFETY-PLAN.md:596:**Verify**: `cat ~/tinker-backups/logs/backup.log | tail -5` — confirm backups are running. Should see a ✅ entry within the last 30 minutes.
./CLASSBOOK-DATA-SAFETY-PLAN.md:633:const destDoc = await curriculumDb.collection('summerCamps_lessonData').doc(encodeFirestoreKey(newDestKey)).get();
./CLASSBOOK-DATA-SAFETY-PLAN.md:682:  lastEditedBy: getAuthUser()?.name || 'Unknown',
./CLASSBOOK-DATA-SAFETY-PLAN.md:702:const stripped = { ...lessonData };
./CLASSBOOK-DATA-SAFETY-PLAN.md:705:await curriculumDb.collection('curriculum').doc('lessonData').update({
./CLASSBOOK-DATA-SAFETY-PLAN.md:720:await curriculumDb.collection('summerCamps_lessonData').doc(encodeFirestoreKey(lessonKey)).set(cleanData, { merge: true });
./CLASSBOOK-DATA-SAFETY-PLAN.md:723:const verification = await curriculumDb.collection('summerCamps_lessonData').doc(encodeFirestoreKey(lessonKey)).get();
./CLASSBOOK-DATA-SAFETY-PLAN.md:792:- Comparison to yesterday's backup count
./CLASSBOOK-DATA-SAFETY-PLAN.md:795:Data source: read `summerCamps_lessonData` and group by teacher. Compare to latest backup file.
./CLASSBOOK-DATA-SAFETY-PLAN.md:798:Display the timestamp of the last backup file and whether it succeeded (read `~/tinker-backups/logs/backup.log` — or more practically, check the Firebase Admin if accessible). Show a red warning if last backup is >2 hours old during business hours.
./CLASSBOOK-DATA-SAFETY-PLAN.md:800:Note: the backup log is at `~/tinker-backups/logs/backup.log` and is a local file — not accessible from the web app. Options: (a) write a status JSON to a public Firebase Storage path after each backup run, (b) build a local health check script, (c) just keep the manual check: `cat ~/tinker-backups/logs/backup.log | tail -3`.
./CLASSBOOK-DATA-SAFETY-PLAN.md:849:| `~/tinker-backups/` | Backup JSON files. Structure: `{ exportedAt, collections: { summerCamps_lessonData: { docId: { fields } } } }` |
./CLASSBOOK-DATA-SAFETY-PLAN.md:850:| `~/tinker-backups/restore-lesson-data.js` | Restore script — UNCONDITIONAL for wiped teachers, reads from backup files, uses REST API with field mask PATCH |
./CLASSBOOK-DATA-SAFETY-PLAN.md:851:| `~/tinker-backups/check-recent-saves.js` | Read-only spot check — shows most recent saves and their content status |
./CLASSBOOK-DATA-SAFETY-PLAN.md:852:| `~/Library/LaunchAgents/com.tinkerhq.classbook-backup.plist` | Backup cron config. `StartInterval: 1800` = every 30 min. Do NOT change to 86400 until summer camp ends |
./CLASSBOOK-DATA-SAFETY-PLAN.md:877:- A backup failure is **visible within hours** (health check)
./CLASSBOOK-DATA-SAFETY-PLAN.md:878:- Recovery from a wipe takes **minutes** (backup restore script already written and tested)
./js/auth-guard.js:123:    passwordToggle.addEventListener('click', () => {
./js/auth-guard.js:152:function getAuthUser() {
./js/firebase-data.js:5://   curriculum/appData     — semester config (URLs, GIDs, settings)
./js/firebase-data.js:6://   curriculum/prepData    — prep team data by semester/week
./js/firebase-data.js:7://   curriculum/lessonData  — all lesson content by semester (imported from classbooks)
./js/firebase-data.js:8://   curriculum/cutProjects — projects removed from schedule, saved for reuse
./js/firebase-data.js:9://   curriculum/changeLog   — audit trail of moves/swaps/cuts
./js/firebase-data.js:13:let prepDataUnsubscribe = null;
./js/firebase-data.js:14:let lessonDataUnsubscribe = null;
./js/firebase-data.js:56:// lesson in summerCamps_lessonData) or 'weekly' (one nested map inside the
./js/firebase-data.js:57:// shared curriculum/lessonData document). The seven sites that choose between
./js/firebase-data.js:128:let lessonDataLoadedSuccessfully = null; // null = not yet loaded, true = ok, false = failed
./js/firebase-data.js:146:// ─── Config (curriculum/appData) ─────────────────────
./js/firebase-data.js:148:// True once a read of curriculum/appData has FAILED (as opposed to the
./js/firebase-data.js:153:// appData decides what every semester is. Until Phase 1 a read error here fell
./js/firebase-data.js:160://                                   memory, writes allowed (updateAppData()
./js/firebase-data.js:164://                                   lessonDataLoadedSuccessfully = false makes
./js/firebase-data.js:172:    const doc = await curriculumDb.collection('curriculum').doc('appData').get();
./js/firebase-data.js:175:    console.error('❌ Could not read curriculum/appData — refusing to guess at the configuration:', err);
./js/firebase-data.js:177:    lessonDataLoadedSuccessfully = false;
./js/firebase-data.js:196:// ─── appData writes — one update(), only the paths named (Phase 1, 1.2) ──────
./js/firebase-data.js:212:async function updateAppData(updates) {
./js/firebase-data.js:224:  const user = getAuthUser();
./js/firebase-data.js:230:  const ref = curriculumDb.collection('curriculum').doc('appData');
./js/firebase-data.js:235:    // Initialisation only: no appData document exists yet. update() cannot
./js/firebase-data.js:241:// Forced-server read of curriculum/appData — bypasses the SDK cache. Used
./js/firebase-data.js:245:  const doc = await curriculumDb.collection('curriculum').doc('appData').get({ source: 'server' });
./js/firebase-data.js:249:// Which appData paths a Settings save may write, by the semester's TYPE. A
./js/firebase-data.js:339:  // lessonDataLoadedSuccessfully = true and re-hide the banner this mode just
./js/firebase-data.js:345:    lessonDataLoadedSuccessfully = false;
./js/firebase-data.js:467:// Pure: given the server's appData, the dotted paths that would stamp it.
./js/firebase-data.js:477:    throw new Error('Cannot stamp semester types: the appData document has no semesters map.');
./js/firebase-data.js:524:  configUnsubscribe = curriculumDb.collection('curriculum').doc('appData')
./js/firebase-data.js:533:// ─── Prep Data (curriculum/prepData) ─────────────────
./js/firebase-data.js:538:    const doc = await curriculumDb.collection('curriculum').doc('prepData').get();
./js/firebase-data.js:553:  const user = getAuthUser();
./js/firebase-data.js:560:  const docRef = curriculumDb.collection('curriculum').doc('prepData');
./js/firebase-data.js:579:  const docRef = curriculumDb.collection('curriculum').doc('prepData');
./js/firebase-data.js:599:  if (prepDataUnsubscribe) prepDataUnsubscribe();
./js/firebase-data.js:600:  prepDataUnsubscribe = curriculumDb.collection('curriculum').doc('prepData')
./js/firebase-data.js:721:  const user = getAuthUser();
./js/firebase-data.js:730:// ─── Lesson Data (curriculum/lessonData) ─────────────
./js/firebase-data.js:762:    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
./js/firebase-data.js:779:      lessonDataLoadedSuccessfully = true;
./js/firebase-data.js:784:      lessonDataLoadedSuccessfully = false;
./js/firebase-data.js:789:    lessonDataLoadedSuccessfully = false;
./js/firebase-data.js:803:  if (lessonDataLoadedSuccessfully === false) {
./js/firebase-data.js:815:  // Regular semester: save to curriculum/lessonData
./js/firebase-data.js:816:  const user = getAuthUser();
./js/firebase-data.js:817:  await curriculumDb.collection('curriculum').doc('lessonData').set({
./js/firebase-data.js:829:  const user = getAuthUser();
./js/firebase-data.js:830:  await curriculumDb.collection('curriculum').doc('lessonData').update({
./js/firebase-data.js:842:  const user = getAuthUser();
./js/firebase-data.js:851:  for (const [lessonKey, lessonData] of Object.entries(lessons)) {
./js/firebase-data.js:853:    if (!hasContent(lessonData)) continue;
./js/firebase-data.js:854:    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
./js/firebase-data.js:857:    const stripped = { ...lessonData };
./js/firebase-data.js:895:  if (lessonDataLoadedSuccessfully === false) {
./js/firebase-data.js:925:  if (lessonDataLoadedSuccessfully === false) {
./js/firebase-data.js:963:  await curriculumDb.collection('curriculum').doc('lessonData').update({
./js/firebase-data.js:968:// Forced-server read of one semester's whole lesson map in curriculum/lessonData
./js/firebase-data.js:975:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
./js/firebase-data.js:979:async function backupLessonData(semesterKey) {
./js/firebase-data.js:984:  const user = getAuthUser();
./js/firebase-data.js:985:  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
./js/firebase-data.js:987:    backupDate: new Date().toISOString(),
./js/firebase-data.js:988:    backupBy: user?.name || 'Unknown'
./js/firebase-data.js:995:  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
./js/firebase-data.js:996:  if (!backupDoc.exists) return null;
./js/firebase-data.js:997:  const backupData = backupDoc.data();
./js/firebase-data.js:998:  const lessons = backupData?.[semesterKey];
./js/firebase-data.js:1012:// The fields a saved summerCamps_lessonData doc contributes to a lesson slot
./js/firebase-data.js:1078:// shared curriculum/lessonData doc re-runs the summer collection reload.
./js/firebase-data.js:1116:  if (lessonDataUnsubscribe) lessonDataUnsubscribe();
./js/firebase-data.js:1143:      lessonDataLoadedSuccessfully = true;
./js/firebase-data.js:1149:      lessonDataLoadedSuccessfully = false;
./js/firebase-data.js:1171:  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
./js/firebase-data.js:1182:      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
./js/firebase-data.js:1198:// ─── Cut Projects (curriculum/cutProjects) ───────────
./js/firebase-data.js:1203:    const doc = await curriculumDb.collection('curriculum').doc('cutProjects').get();
./js/firebase-data.js:1214:  const user = getAuthUser();
./js/firebase-data.js:1215:  await curriculumDb.collection('curriculum').doc('cutProjects').set({
./js/firebase-data.js:1238:  const user = getAuthUser();
./js/firebase-data.js:1247:// ─── Change Log (curriculum/changeLog) ───────────────
./js/firebase-data.js:1252:    const doc = await curriculumDb.collection('curriculum').doc('changeLog').get();
./js/firebase-data.js:1269:  const user = getAuthUser();
./js/firebase-data.js:1277:    await curriculumDb.collection('curriculum').doc('changeLog').set({
./js/firebase-data.js:1304:  const user = getAuthUser();
./js/firebase-data.js:1361:// authoritative: it overrides whatever (possibly stale) value lessonData
./js/firebase-data.js:1364:async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
./js/firebase-data.js:1365:  if (lessonDataLoadedSuccessfully === false) {
./js/firebase-data.js:1369:  const user = getAuthUser();
./js/firebase-data.js:1370:  lessonData.lastEditedBy = user?.name || 'Unknown';
./js/firebase-data.js:1371:  lessonData.lastEditedAt = new Date().toISOString();
./js/firebase-data.js:1376:  // callers fall through to curriculum/lessonData on anything that isn't
./js/firebase-data.js:1378:  if (isDayOffYear(semesterKey)) return saveDayOffPlan(semesterKey, lessonKey, lessonData, fieldsToClear, opts.dayOffAuth);
./js/firebase-data.js:1382:  const hasContent = lessonHasContent(lessonData);
./js/firebase-data.js:1395:    const hasPhotoField = 'photoUrl' in lessonData || 'photoPath' in lessonData;
./js/firebase-data.js:1396:    if (!hasContent && !hasPhotoField && !('planComplete' in lessonData) && fieldsToActuallyClear.length === 0) {
./js/firebase-data.js:1402:    const stripped = { ...lessonData };
./js/firebase-data.js:1412:    console.log('💾 Saving Summer Camp lesson to summerCamps_lessonData:', lessonKey);
./js/firebase-data.js:1413:    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semesterKey, lessonKey));
./js/firebase-data.js:1429:  // Regular semester: curriculum/lessonData is one shared doc across every
./js/firebase-data.js:1433:  // actually present in lessonData (Data Safety Plan Stage 2D).
./js/firebase-data.js:1434:  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear);
./js/firebase-data.js:1436:  console.log('💾 Saving to curriculum/lessonData with per-field paths:', Object.keys(updates));
./js/firebase-data.js:1438:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
./js/firebase-data.js:1447:// object for ONE lesson within the shared curriculum/lessonData document,
./js/firebase-data.js:1448:// given an already-finalized lessonData object. Extracted from
./js/firebase-data.js:1455:function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = []) {
./js/firebase-data.js:1457:  const stripped = { ...lessonData };
./js/firebase-data.js:1472:// vulnerable to (does NOT independently verify the given lessonData reflects
./js/firebase-data.js:1476:  if (lessonDataLoadedSuccessfully === false) {
./js/firebase-data.js:1488:  const user = getAuthUser();
./js/firebase-data.js:1490:  for (const { lessonKey, lessonData, fieldsToClear } of writes) {
./js/firebase-data.js:1491:    lessonData.lastEditedBy = user?.name || 'Unknown';
./js/firebase-data.js:1492:    lessonData.lastEditedAt = new Date().toISOString();
./js/firebase-data.js:1493:    Object.assign(combined, buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear || []));
./js/firebase-data.js:1500:  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
./js/firebase-data.js:1554:  if (lessonDataLoadedSuccessfully === false) {
./js/firebase-data.js:1577:  if (lessonDataLoadedSuccessfully === false) {
./js/firebase-data.js:1651:  // Every successful summer load sets lessonDataLoadedSuccessfully = true and
./js/firebase-data.js:1814:    // 6. Load saved lesson plans from summerCamps_lessonData
./js/firebase-data.js:1817:      const savedLessonsSnap = await scoped('summerCamps_lessonData').get();
./js/firebase-data.js:1854:      if (skippedForeignSeason > 0) console.warn(`⚠️ Skipped ${skippedForeignSeason} summerCamps_lessonData document(s) stamped for another season.`);
./js/firebase-data.js:1874:// A school year is a semester of type 'day-off-camps' in appData. Its events,
./js/firebase-data.js:1876:// every one carrying `yearKey`. Nothing here touches curriculum/lessonData or
./js/firebase-data.js:1878:const DAY_OFF_COLLECTIONS = { events: 'dayOffCamps_events', camps: 'dayOffCamps_camps', plans: 'dayOffCamps_lessonData' };
./js/firebase-data.js:1930:// Materials live on the project's plan record (dayOffCamps_lessonData) as
./js/firebase-data.js:1986:  if (lessonDataLoadedSuccessfully === false) {
./js/firebase-data.js:2309:  const user = getAuthUser();
./js/firebase-data.js:2573:// A teacher's plan is the camp-project's record in dayOffCamps_lessonData (the
./js/firebase-data.js:2646:async function saveDayOffPlan(yearKey, lessonKey, lessonData, fieldsToClear = [], auth) {
./js/firebase-data.js:2655:  const extra = Object.keys(lessonData).filter(k => !DAY_OFF_PLAN_WRITABLE.includes(k));
./js/firebase-data.js:2659:  if (!lessonData.lastEditedBy || !lessonData.lastEditedAt) throw new Error('An SDOC plan save must carry its edit stamp — refused.');
./js/firebase-data.js:2661:  const payload = { ...lessonData };
./js/firebase-data.js:2720:  return { status: 'savedSince', doc: server, by: server.lastEditedBy || 'someone', own: server.lastEditedBy === lessonData.lastEditedBy };
./js/firebase-data.js:2986:  const user = getAuthUser();
./js/firebase-data.js:3036:  const user = getAuthUser();
./js/app.js:53:  const user = getAuthUser();
./js/app.js:147:document.addEventListener('DOMContentLoaded', async () => {
./js/app.js:171:  if (lessonDataLoadedSuccessfully === false) {
./js/app.js:205:    btn.addEventListener('click', () => {
./js/app.js:249:  const user = getAuthUser();
./js/app.js:262:  const user = getAuthUser();
./js/app.js:269:  const user = getAuthUser();
./js/app.js:278:  const user = getAuthUser();
./js/app.js:292:  const user = getAuthUser();
./js/app.js:300:  const user = getAuthUser();
./js/app.js:320:  const user = getAuthUser();
./js/app.js:350:  document.getElementById('help-link')?.addEventListener('click', (e) => {
./js/app.js:354:  document.getElementById('help-close')?.addEventListener('click', () => {
./js/app.js:360:  document.getElementById('settings-link')?.addEventListener('click', (e) => {
./js/app.js:365:  document.getElementById('footer-sign-out')?.addEventListener('click', (e) => {
./js/app.js:371:    overlay.addEventListener('click', (e) => {
./js/app.js:528:  const user = getAuthUser();
./js/app.js:565:  const user = getAuthUser();
./js/app.js:590:  const user = getAuthUser();
./js/app.js:613:    hasClassbook: !!getAuthUser()?.appAccess?.includes('classbook'),
./js/app.js:641:  const user = getAuthUser();
./js/app.js:668:  if (lessonDataLoadedSuccessfully === false) {
./js/app.js:781:    btn.addEventListener('click', () => {
./js/app.js:790:  document.getElementById('tv-this-week-btn').addEventListener('click', scrollToThisWeek);
./js/app.js:799:  const user = getAuthUser();
./js/app.js:1038:  document.getElementById('progress-dashboard-toggle').addEventListener('click', () => {
./js/app.js:1059:  const user = getAuthUser();
./js/app.js:1221:  document.getElementById('progress-dashboard-toggle').addEventListener('click', () => {
./js/app.js:1268:  const user = getAuthUser();
./js/app.js:1350:    item.addEventListener('click', () => {
./js/app.js:1763:          const editable = canEditDayOffPlan(slot) && lessonDataLoadedSuccessfully !== false;
./js/app.js:1940:  const user = getAuthUser();
./js/app.js:2339:      lesson.lastEditedBy = getAuthUser()?.name || 'Unknown';
./js/app.js:2805:    btn.addEventListener('click', () => {
./js/app.js:2816:    btn.addEventListener('click', (e) => {
./js/app.js:2824:    btn.addEventListener('click', (e) => {
./js/app.js:2856:    title.addEventListener('click', () => {
./js/app.js:2863:    link.addEventListener('click', () => {
./js/app.js:2935:  document.getElementById('tv-back-btn').addEventListener('click', tvGoBack);
./js/app.js:3039:  document.getElementById('te-detail-close-btn').addEventListener('click', () => modal.remove());
./js/app.js:3040:  document.getElementById('te-detail-done-btn').addEventListener('click', () => modal.remove());
./js/app.js:3041:  document.getElementById('te-detail-print-btn').addEventListener('click', () => printLesson(lessonKey));
./js/app.js:3042:  modal.addEventListener('click', (e) => { if (e.target === modal) modal.remove(); });
./js/app.js:3045:    document.getElementById('te-detail-edit-btn')?.addEventListener('click', () => {
./js/app.js:3074:  const user = getAuthUser();
./js/app.js:3238:  document.getElementById('te-close-btn').addEventListener('click', closeModal);
./js/app.js:3239:  document.getElementById('te-cancel-btn').addEventListener('click', closeModal);
./js/app.js:3240:  modal.addEventListener('click', (e) => {
./js/app.js:3253:  document.getElementById('te-save-btn').addEventListener('click', manualTeSave);
./js/app.js:3266:  document.getElementById('te-qa-send-btn').addEventListener('click', () => sendTeacherQaMessage(lessonKey, semKey));
./js/app.js:3299:        document.getElementById('te-photo-remove-btn')?.addEventListener('click', () => {
./js/app.js:3314:  document.getElementById('te-photo-remove-btn')?.addEventListener('click', () => {
./js/app.js:3347:  document.getElementById('te-add-material-btn')?.addEventListener('click', () => {
./js/app.js:3375:  tr.querySelector('.te-mat-delete').addEventListener('click', () => tr.remove());
./js/app.js:3623:  if (lessonDataLoadedSuccessfully === false) {
./js/app.js:3631:  // under that key into curriculum/lessonData is never right. Routed by TYPE
./js/app.js:3664:  const user = getAuthUser();
./js/app.js:3690:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
./js/app.js:3771:  const user = getAuthUser();
./js/app.js:3800:  const user = getAuthUser();
./js/app.js:3829:  const user = getAuthUser();
./js/app.js:3879:  const user = getAuthUser();
./js/app.js:3989:  modal.addEventListener('click', (e) => {
./js/app.js:3993:  document.getElementById('print-just-teacher').addEventListener('click', () => {
./js/app.js:4001:    allTeachersBtn.addEventListener('click', () => {
./js/app.js:4482:  const user = getAuthUser();
./js/app.js:4540:  // otherwise only its appData entry goes — it has nothing in
./js/app.js:4541:  // curriculum/lessonData, and no collection is ever cleared from here.
./js/app.js:4565:    await updateAppData({ [`semesters.${key}`]: firebase.firestore.FieldValue.delete() });
./js/app.js:4579:  // curriculum/lessonData to delete. A camp season's lessons live in the
./js/app.js:4611:    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
./js/app.js:4619:    await updateAppData({ [`semesters.${key}.published`]: published });
./js/app.js:4685:// An SDOC school year: one appData entry through the field-path writer, after
./js/app.js:4687:// curriculum/lessonData write.
./js/app.js:4707:    await updateAppData({ [`semesters.${key}`]: newSem });
./js/app.js:4814:// roster, no week grid, no lesson slots and no curriculum/lessonData write —
./js/app.js:4841:    await updateAppData({ [`semesters.${key}`]: newSem });
./js/app.js:4895:  let lessonDataCommitted = false;
./js/app.js:4968:        lessonDataCommitted = true;
./js/app.js:4981:    await updateAppData({ [`semesters.${key}`]: newSem });
./js/app.js:4987:    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
./js/app.js:4992:    if (lessonDataCommitted) {
./js/app.js:5032:  document.getElementById('ca-modal-close')?.addEventListener('click', closeAdminModal);
./js/app.js:5033:  document.getElementById('ca-detail-modal')?.addEventListener('click', (e) => {
./js/app.js:5368:// summerCamps_lessonData doc exists yet, so saveAdminEdit() skips the check
./js/app.js:5563:  if (lessonDataLoadedSuccessfully === false) {
./js/app.js:5633:  // summerCamps_lessonData doc exists (a missing doc means "never saved",
./js/app.js:5827:// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
./js/app.js:5835:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
./js/app.js:5851:      const snap = await curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key)).get({ source: 'server' });
./js/app.js:5945:        [{ lessonKey: newDestKey, lessonData: movedLesson, fieldsToClear: destFieldsToClear }],
./js/app.js:6017:            { lessonKey: sourceKeyForSwap, lessonData: swappedSource, fieldsToClear: sourceFieldsToClear },
./js/app.js:6018:            { lessonKey: newDestKey, lessonData: swappedDest, fieldsToClear: destFieldsToClearSwap }
./js/app.js:6037:          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
./js/app.js:6262:// against curriculum/cutProjects (not saveCutProjects()'s local-splice-then-
./js/app.js:6297:  const user = getAuthUser();
./js/app.js:6309:    await curriculumDb.collection('curriculum').doc('cutProjects').set({
./js/app.js:6358:  const cutProjects = currentCutProjects?.[semKey] || [];
./js/app.js:6370:  const totalCuts = cutProjects.length + otherSemesters.reduce((sum, s) => sum + s.projects.length, 0);
./js/app.js:6381:  if (cutProjects.length > 0) {
./js/app.js:6383:    cutProjects.forEach((proj, idx) => {
./js/app.js:6431:  const cutProjects = currentCutProjects?.[srcSemKey] || [];
./js/app.js:6432:  const proj = cutProjects[cutIndex];
./js/app.js:6500:    await curriculumDb.collection('curriculum').doc('cutProjects').set({
./js/app.js:6532:  const cutProjects = currentCutProjects?.[semKey] || [];
./js/app.js:6537:  if (cutProjects.length === 0) {
./js/app.js:6543:  badge.textContent = cutProjects.length;
./js/app.js:6547:  cutProjects.forEach((proj, idx) => {
./js/app.js:6601:// Backtracking audit, Phase 8: a third live writer of curriculum/cutProjects,
./js/app.js:6610:  const cutProjects = currentCutProjects?.[semKey] || [];
./js/app.js:6611:  const proj = cutProjects[idx];
./js/app.js:6615:  // ordering in this same commit. There's no live listener on cutProjects, so mutating
./js/app.js:6622:    await curriculumDb.collection('curriculum').doc('cutProjects').set({
./js/app.js:6632:  currentCutProjects[semKey] = cutProjects.filter((_, i) => i !== idx);
./js/app.js:6638:  const cutProjects = currentCutProjects?.[semKey] || [];
./js/app.js:6639:  if (cutProjects.length === 0) { alert('No cut projects to export.'); return; }
./js/app.js:6642:  for (const proj of cutProjects) {
./js/app.js:6784:  const user = getAuthUser();
./js/app.js:7146:  if (lessonDataLoadedSuccessfully === false) {
./js/app.js:7177:  const user = getAuthUser();
./js/app.js:7201:    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
./js/app.js:7202:    : curriculumDb.collection('curriculum').doc('lessonData');
./js/app.js:7231:  if (lessonDataLoadedSuccessfully === false) {
./js/app.js:7262:  const user = getAuthUser();
./js/app.js:7284:    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
./js/app.js:7285:    : curriculumDb.collection('curriculum').doc('lessonData');
./js/app.js:7411:// ~/tinker-backups/backup.js runs every 30 min, 8am-6pm Mountain Time,
./js/app.js:7421:// Pure render — takes already-fetched backupStatus/latest data (or null) and
./js/app.js:7425:  const container = document.getElementById('ca-backup-health-content');
./js/app.js:7429:    container.innerHTML = '<p class="ca-empty-hint">No backup status recorded yet.</p>';
./js/app.js:7440:  let html = `<p class="ca-empty-hint">Last successful backup: ${escHtml(lastSuccessAt ? lastSuccessAt.toLocaleString() : 'never recorded')}</p>`;
./js/app.js:7444:    html += `<p class="ca-backup-flag">⚠️ Last successful backup is over 2 hours old during business hours. If unexpected, check Firebase CLI auth on the machine running the backup script (a common cause is an expired "invalid_rapt" session).</p>`;
./js/app.js:7447:    html += `<p class="ca-backup-flag">⚠️ Errors backing up: ${escHtml(errorCollections.join(', '))}</p>`;
./js/app.js:7450:    html += `<p class="ca-backup-flag">⚠️ Possible data loss detected in: ${escHtml(dataLossWarningCollections.join(', '))}</p>`;
./js/app.js:7453:    html += `<p class="ca-backup-ok">&#10003; Backup system healthy.</p>`;
./js/app.js:7455:  html += `<p class="ca-backup-caveat">This reflects the local backup script's health, not the native Google-managed Firestore backups (which run independently).</p>`;
./js/app.js:7461:  const container = document.getElementById('ca-backup-health-content');
./js/app.js:7463:  container.innerHTML = '<p class="ca-empty-hint">Loading backup status…</p>';
./js/app.js:7466:    const snap = await curriculumDb.collection('backupStatus').doc('latest').get();
./js/app.js:7469:    // backupStatus is manager/admin-only (shared across every Tinker HQ app) —
./js/app.js:7478:    console.error('Error loading backup health:', err);
./js/app.js:7479:    container.innerHTML = '<p class="ca-backup-flag">⚠️ Failed to load backup status.</p>';
./js/app.js:7484:  const content = document.getElementById('ca-backup-health-content');
./js/app.js:7492:// Same >10% drop threshold ~/tinker-backups/backup.js already uses for its
./js/app.js:7515:  const summerSnap = await curriculumDb.collection('summerCamps_lessonData').get();
./js/app.js:7518:  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
./js/app.js:7519:  const lessonDataDoc = lessonDataSnap.exists ? lessonDataSnap.data() : {};
./js/app.js:7520:  for (const semesterLessons of Object.values(lessonDataDoc)) {
./js/app.js:7528:// Pure render — takes already-computed live and backup-derived per-teacher
./js/app.js:7529:// counts (backupCounts may be null if unavailable/inaccessible), so it's
./js/app.js:7531:function renderContentCountData(liveCounts, backupCounts) {
./js/app.js:7537:    ...Object.keys(backupCounts || {}),
./js/app.js:7549:    const hasBaseline = !!backupCounts && typeof backupCounts[teacher] === 'number';
./js/app.js:7550:    const backupCount = hasBaseline ? backupCounts[teacher] : null;
./js/app.js:7551:    const isDrop = hasBaseline && backupCount > 0 &&
./js/app.js:7552:      ((backupCount - today) / backupCount) > CONTENT_COUNT_DROP_THRESHOLD;
./js/app.js:7558:      <td>${hasBaseline ? backupCount : '—'}</td>
./js/app.js:7559:      <td class="${isDrop ? 'ca-backup-flag' : ''}">${isDrop ? `⚠️ Dropped from ${backupCount} to ${today}` : 'OK'}</td>
./js/app.js:7564:  if (!backupCounts) {
./js/app.js:7565:    html += '<p class="ca-empty-hint">No backup-derived comparison available yet.</p>';
./js/app.js:7568:    html += `<p class="ca-backup-flag">⚠️ ${flaggedCount} teacher${flaggedCount !== 1 ? 's' : ''} show a content-count drop of more than 10% since the last backup.</p>`;
./js/app.js:7584:    let backupCounts = null;
./js/app.js:7587:      const snap = await curriculumDb.collection('backupStatus').doc('latest').get();
./js/app.js:7588:      backupCounts = snap.exists ? (snap.data().classbookContentByTeacher || null) : null;
./js/app.js:7590:      // backupStatus is manager/admin-only (same boundary as Backup Health) —
./js/app.js:7593:      backupCounts = null;
./js/app.js:7595:    renderContentCountData(liveCounts, backupCounts);
./js/app.js:7598:    container.innerHTML = '<p class="ca-backup-flag">⚠️ Failed to load content counts.</p>';
./js/app.js:7793:  document.getElementById('forecast-toggle')?.addEventListener('click', () => {
./js/app.js:7803:    header.addEventListener('click', () => {
./js/app.js:7813:    btn.addEventListener('click', async (e) => {
./js/app.js:7849:    link.addEventListener('click', (e) => {
./js/app.js:8478:function renderWeekContent(items, prepData, weekNum) {
./js/app.js:8493:    if (prepData.items?.[item.key]?.isComplete) completedMaterials++;
./js/app.js:8503:      <textarea id="prep-week-notes" class="prep-week-notes" placeholder="Week notes — jot down anything your prep team needs to remember this week..." rows="3">${escHtml(prepData.notes || '')}</textarea>
./js/app.js:8518:  if (prepData.lastUpdatedBy) {
./js/app.js:8519:    const time = prepData.lastUpdated ? new Date(prepData.lastUpdated).toLocaleString() : '';
./js/app.js:8520:    html += `<div class="prep-last-updated">Last updated by ${escHtml(prepData.lastUpdatedBy)} ${time ? 'at ' + time : ''}</div>`;
./js/app.js:8623:          const pd = prepData.items?.[mat.key] || {};
./js/app.js:8710:document.addEventListener('click', (e) => {
./js/app.js:8767:  const userName = getAuthUser()?.name || 'Unknown';
./js/app.js:8799:  currentWeekPrepData.items[key].updatedBy = getAuthUser()?.name || 'Unknown';
./js/app.js:8842:  currentWeekPrepData.items[key].updatedBy = getAuthUser()?.name || 'Unknown';
./js/app.js:9005:function renderPrepCalculator(items, prepData) {
./js/app.js:9035:  const selectedClasses = prepData.calculator?.selectedClasses || [];
./js/app.js:9204:    btn.addEventListener('click', () => {
./js/app.js:9245:async function renderTodayView(items, prepData, weekNum) {
./js/app.js:9255:  const user = getAuthUser();
./js/app.js:9359:    btn.addEventListener('click', () => {
./js/app.js:9440:  document.getElementById('prep-cycle-close').addEventListener('click', closeModal);
./js/app.js:9441:  document.getElementById('prep-cycle-cancel').addEventListener('click', closeModal);
./js/app.js:9442:  modal.addEventListener('click', e => { if (e.target === modal) closeModal(); });
./js/app.js:9446:    btn.addEventListener('click', () => {
./js/app.js:9461:  modal.addEventListener('click', e => {
./js/app.js:9468:  document.getElementById('prep-cycle-save').addEventListener('click', async () => {
./js/app.js:9691:function renderProjectView(items, prepData, weekNum) {
./js/app.js:9710:    if (prepData.items?.[item.key]?.isComplete) completedMaterials++;
./js/app.js:9719:      <textarea id="prep-week-notes" class="prep-week-notes" placeholder="Week notes — jot down anything your prep team needs to remember this week..." rows="3">${escHtml(prepData.notes || '')}</textarea>
./js/app.js:9733:  if (prepData.lastUpdatedBy) {
./js/app.js:9734:    const time = prepData.lastUpdated ? new Date(prepData.lastUpdated).toLocaleString() : '';
./js/app.js:9735:    html += `<div class="prep-last-updated">Last updated by ${escHtml(prepData.lastUpdatedBy)} ${time ? 'at ' + time : ''}</div>`;
./js/app.js:9756:    const associations = prepData.classAssociations?.[normTitleForAssoc] || [];
./js/app.js:9864:        const pd = prepData.items?.[mat.key] || {};
./js/app.js:9931:function mergeManualItems(sheetItems, prepData) {
./js/app.js:9932:  const manual = prepData?.manualItems || {};
./js/app.js:10049:    createdBy: getAuthUser()?.name || 'Unknown',
./js/app.js:10162:    addedBy: getAuthUser()?.name || 'Unknown',
./js/app.js:10493:    btn.addEventListener('click', () => {
./js/app.js:10527:    btn.addEventListener('click', () => {
./js/app.js:10537:        dismissals[semKey][fp] = { ...existing, at: new Date().toISOString(), by: getAuthUser()?.name || 'Unknown' };
./js/app.js:10546:    btn.addEventListener('click', () => {
./js/app.js:10570:    toggleBtn.addEventListener('click', () => {
./js/app.js:10600:          dismissals[semKey][fp].noteBy = getAuthUser()?.name || 'Unknown';
./js/app.js:10628:    btn.addEventListener('click', () => {
./js/app.js:10643:    btn.addEventListener('click', () => {
./js/app.js:10811:      await updateAppData(paths);
./js/app.js:10848:// Dry run first, always: it reads the SERVER's appData (not this tab's copy),
./js/app.js:10857:  const user = getAuthUser();
./js/app.js:10885:    console.log('📋 appData snapshot before stamping semester types:', JSON.stringify(serverConfig, null, 2));
./js/app.js:10892:      + `\n\nRun a backup (backup.js --force) before pressing Stamp.`);
./js/app.js:10905:    await updateAppData(stamps);
./js/app.js:10941:      stampOutput(`⚠️ The write landed but the read-back does not match:\n${problems.join('\n')}\n\nCheck curriculum/appData in the Firebase Console before doing anything else.`);
./js/app.js:11322:    await updateAppData({ ...settingsPaths, ...extraPaths });
./js/app.js:11706:  document.getElementById('summer-qa-send-btn')?.addEventListener('click', () => sendSummerQaMessage(semKey, lessonKey, lesson));
./js/app.js:11741:        document.getElementById('summer-photo-remove-btn')?.addEventListener('click', () => {
./js/app.js:11756:  document.getElementById('summer-photo-remove-btn')?.addEventListener('click', () => {
./js/app.js:11837:    // The curriculum/lessonData listener rebuilds the whole summer cache from
./js/app.js:11878:        lastEditedBy: getAuthUser()?.name || 'Unknown',
./js/app.js:12187:  document.getElementById('summer-lesson-save').addEventListener('click', async () => {
./js/app.js:12193:  document.getElementById('summer-lesson-print')?.addEventListener('click', () => {
./js/app.js:12197:  document.getElementById('summer-lesson-close').addEventListener('click', () => closeModal(true));
./js/app.js:12198:  document.getElementById('summer-lesson-cancel').addEventListener('click', () => closeModal(true));
./js/app.js:12200:  if (!sdoc) modal.addEventListener('click', (e) => { if (e.target === modal) closeModal(false); });
./js/app.js:12520:  const writable = lessonDataLoadedSuccessfully !== false;
./js/app.js:13048:  const planner = canPlanDayOffCamps() && lessonDataLoadedSuccessfully !== false;
./js/app.js:13182:  const planner = canPlanDayOffCamps() && lessonDataLoadedSuccessfully !== false;
./js/app.js:13183:  const ticker = canTickDayOffMaterials() && lessonDataLoadedSuccessfully !== false;
./js/app.js:13409:  const ticker = canTickDayOffMaterials() && lessonDataLoadedSuccessfully !== false;
./css/styles.css:2378:.ca-backup-flag {
./css/styles.css:2385:.ca-backup-ok {
./css/styles.css:2392:.ca-backup-caveat {

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md | sed -n '1,240p'; nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html | sed -n '70,115p'; nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html | sed -n '215,240p'; nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html | sed -n '288,355p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
     1	Reading additional input from stdin...
     2	OpenAI Codex v0.147.0
     3	--------
     4	workdir: /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
     5	model: gpt-5.6-sol
     6	provider: openai
     7	approval: never
     8	sandbox: read-only
     9	reasoning effort: none
    10	reasoning summaries: none
    11	session id: 01a0ee4d-2063-73f2-a7a0-f0cde8db4ea7
    12	--------
    13	user
    14	## Independent review — plan under review
    15	/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html (revision 3, marked execution-ready after three Claude review rounds; those reviews are in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-r{1,2,3}-claude.md — read them so you don't repeat settled points, but do not trust them).
    16	Repo (read-only; main at 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Firestore rules: /Users/christiehubley/studio-hub/firestore.rules .
    17	
    18	You are the independent second model. Be adversarial and verify against the code, citing file:line and concrete failing inputs:
    19	1. Anything in Phase 1 or Phase 2 that is unsafe for production data (curriculum/appData, curriculum/lessonData) or would lose/hide data?
    20	2. Anything the three Claude rounds missed: other readers of activeSemester / globalSemesterKey / localStorage keys; interactions with the Summer camp season as active; the "switch everyone" once-per-browser logic; the weekly-delete modal; the Settings access gating.
    21	3. Is the e2e plan workable with the harness in e2e/ and safe for the other specs (shared emulator state, restore)?
    22	4. Verdict: EXECUTION-READY or NOT, with the minimum list of changes.
    23	Do not edit files. Do not run tests.
    24	codex
    25	I’ll review the revision-3 plan, all three prior reviews, and the actual reader/write paths in the repo and Firestore rules. I’ll keep this strictly read-only and won’t run tests.
    26	exec
    27	/bin/zsh -lc "pwd && sed -n '1,260p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html && for f in /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-r{1,2,3}-claude.md; do echo \"FILE:"'$f"; sed -n '"'1,260p' \""'$f"; done' in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
    28	 succeeded in 0ms:
    29	/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
    30	<!DOCTYPE html>
    31	<html lang="en">
    32	<head>
    33	<meta charset="UTF-8">
    34	<title>Plan: Classbook — "Make this the active semester" in Settings</title>
    35	<style>
    36	  body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif; max-width: 860px; margin: 2rem auto; padding: 0 1.5rem; color: #1a1a1a; line-height: 1.5; }
    37	  h1 { font-size: 1.6rem; border-bottom: 2px solid #8B30BC; padding-bottom: .5rem; }
    38	  h2 { font-size: 1.15rem; margin-top: 2rem; color: #6052C8; }
    39	  h3 { font-size: 1rem; margin-top: 1.2rem; }
    40	  .meta { background: #f5f0ff; border-left: 4px solid #8B30BC; padding: .75rem 1rem; border-radius: 4px; margin: 1rem 0; font-size: .9rem; }
    41	  .phase { border: 1px solid #e5e7eb; border-radius: 6px; padding: 1rem 1.25rem; margin: 1rem 0; }
    42	  .phase h3 { margin-top: 0; }
    43	  .bdd { background: #fafafa; border: 1px solid #e5e7eb; border-radius: 4px; padding: .5rem .75rem; margin: .5rem 0; font-size: .88rem; font-family: monospace; white-space: pre-wrap; }
    44	  .safe { background: #f0fdf4; border-left: 4px solid #16a34a; padding: .6rem 1rem; border-radius: 4px; font-size: .9rem; margin: .5rem 0; }
    45	  .note { background: #fffbeb; border-left: 4px solid #f59e0b; padding: .6rem 1rem; border-radius: 4px; font-size: .9rem; margin: .5rem 0; }
    46	  .danger { background: #fef2f2; border-left: 4px solid #dc2626; padding: .6rem 1rem; border-radius: 4px; font-size: .9rem; margin: .5rem 0; }
    47	  .decision { background: #eff6ff; border-left: 4px solid #2563eb; padding: .6rem 1rem; border-radius: 4px; font-size: .9rem; margin: .5rem 0; }
    48	  code { background: #f3f4f6; padding: .1rem .35rem; border-radius: 3px; font-size: .88rem; }
    49	  table { border-collapse: collapse; width: 100%; margin: .75rem 0; }
    50	  th, td { border: 1px solid #e5e7eb; padding: .4rem .75rem; font-size: .88rem; text-align: left; vertical-align: top; }
    51	  th { background: #f9fafb; }
    52	  .status-tag { display: inline-block; font-size: .75rem; font-weight: 700; padding: .15rem .5rem; border-radius: 999px; }
    53	  .not-ready { background: #fef3c7; color: #92400e; }
    54	  .ready { background: #dcfce7; color: #166534; }
    55	</style>
    56	</head>
    57	<body>
    58	
    59	<h1 id="plan-title">Plan: Classbook — "Make this the active semester" in Settings</h1>
    60	
    61	<div class="meta" id="plan-meta">
    62	  <strong>Goal:</strong> At each term change, Christie can make the new semester the Classbook's active one from Settings in one step, and choose to put everyone (teachers included) onto it the next time they open the app. No console commands needed.<br>
    63	  <strong>App:</strong> tinker-spring-curriculum (The Classbook): <code>js/app.js</code>, <code>js/firebase-data.js</code>, one new e2e spec. <strong>No</strong> Firestore rules change, no new collection.<br>
    64	  <strong>Context:</strong> Created Sep 29, 2026. Christie asked how to move "active" from Spring 2026 to Fall 2026 and found there is no UI for it. She is doing a one-time console switch meanwhile (<code>await updateAppData({ activeSemester: 'fall-2026' })</code>). Her answer to "want me to plan it?": <em>"yes we should do this."</em><br>
    65	  <strong>Line numbers</strong> are at <code>2ef2e62</code> (main, live on Netlify).<br>
    66	  <strong>Status:</strong> <span class="status-tag ready">execution-ready: true</span>. Christie answered Q1/Q2. Reviewed in three rounds; round 3 verdict: EXECUTION-READY. Waiting for Christie's go-ahead to build.
    67	</div>
    68	
    69	<h2 id="open-questions">Christie's decisions (Sep 29)</h2>
    70	<div class="decision">
    71	  <strong>Q1: Which semesters can be made active? Answer: class semesters (Fall/Spring) and Summer camp seasons.</strong> SDOC years are excluded: they're a whole school year running alongside the class semesters, so they're never "the" current term. Making a camp season active has to be checked everywhere "active" is read (see the Phase 1 camp-season scenarios).<br><br>
    72	  <strong>Q2: "Switch everyone to it" ticked by default? Answer: yes, ticked.</strong>
    73	</div>
    74	
    75	<h2 id="today">What exists today (research)</h2>
    76	<table>
    77	  <tr><th>Fact</th><th>Where</th></tr>
    78	  <tr><td><code>curriculum/appData.activeSemester</code> is set only when missing (first semester created) and never re-pointed. There is no UI to change it.</td><td><code>js/app.js:11318-11319</code> (comment "only ever SET when missing"), <code>:11247</code></td></tr>
    79	  <tr><td>What "active" controls: the "(active)"/"(current)" labels; the fallback semester for a browser with nothing remembered; Curriculum Admin's semester after a delete; the active semester can't be deleted and its Publish toggle is hidden (the badge says "always visible to teachers").</td><td><code>app.js:68, 76, 818, 4492-4530, 4590, 10687-10712</code></td></tr>
    80	  <tr><td>What it does <strong>not</strong> control: what a returning user sees. Each browser remembers <code>globalSemesterKey</code> in localStorage and keeps it while it exists and is visible.</td><td><code>app.js:13, 65-70, 96-100</code></td></tr>
    81	  <tr><td><code>getActiveSemesterKey()</code> despite its name returns the <em>selected</em> semester first, and <code>activeSemester</code> only as a fallback. So <code>getCurrentWeekNum()</code> follows the selection, not the flag.</td><td><code>firebase-data.js:3117-3123</code>, <code>app.js:1243</code></td></tr>
    82	  <tr><td>"Active" does <strong>not</strong> imply visible: <code>canSeeSemester()</code> ignores it, so an unpublished active semester is hidden from teachers (the fallback at :68 already guards for that).</td><td><code>app.js:277-284</code></td></tr>
    83	  <tr><td>Rules: <code>curriculum/{docId}</code> is read/write for manager+, and appData is manager+ only. Settings is hidden for everyone below manager.</td><td><code>studio-hub/firestore.rules:652-657</code>; <code>app.js:318-329</code></td></tr>
    84	  <tr><td>All appData writes go through <code>updateAppData(flatPaths)</code>: one <code>update()</code> of only the named paths, refused after a failed config load or a bad season registry.</td><td><code>firebase-data.js:212-240</code></td></tr>
    85	  <tr><td>The template to follow is <code>toggleSemesterPublish()</code>: optimistic in-memory change, <code>updateAppData</code>, exact restore plus an alert on failure, then re-render.</td><td><code>app.js:4604-4630</code></td></tr>
    86	  <tr><td>Config is read once per page load. There is no live listener (<code>setupConfigListener</code> is never called), so open tabs see a change on their next reload.</td><td><code>firebase-data.js:521</code>, <code>app.js:11328</code></td></tr>
    87	  <tr><td>No other Tinker app reads <code>activeSemester</code> (grep of studio-hub, summer-camp-app, roster-manager, schedule-viewer, playbook, materials, enrollment-board).</td><td>—</td></tr>
    88	  <tr><td><strong>Settings' "Editing Semester" dropdown doesn't work.</strong> <code>onchange="loadSettingsForm()"</code> redraws the form for <code>getSettingsSemKey()</code> = the header's <code>globalSemesterKey</code>, so the pick snaps back. Today the only way to point Settings at another semester is the header dropdown. (Round-1 review, finding 2; confirmed.)</td><td><code>index.html:411</code>; <code>app.js:10659-10661, 10681-10689</code></td></tr>
    89	  <tr><td><strong>Making a weekly semester non-active arms its Delete.</strong> Curriculum Admin's bar (manager/admin only) shows Delete for every non-active semester. For a weekly one, <code>deleteSemester</code> removes the appData entry (manager-only), then <code>deleteLessonData(key)</code> removes that semester's whole lesson map, behind two generic confirms. Since the Sep 29 console switch this is already true of Spring 2026 in production. (Finding 3; confirmed.)</td><td><code>app.js:4481-4483, 4522, 4527-4590</code>; <code>firebase-data.js:961-966</code></td></tr>
    90	  <tr><td>The header selector's <code>change</code> listener is attached on every <code>initGlobalSemesterSelector()</code> call, with no attach-once guard (the Teacher View selector has one). It's already re-called after creating a semester. (Finding 7; confirmed.)</td><td><code>app.js:86</code>, <code>:825</code>, <code>:4724, 4845</code></td></tr>
    91	  <tr><td>Teacher View's own selector labels the active semester "(current)".</td><td><code>app.js:818-819</code>, <code>:653-655</code></td></tr>
    92	  <tr><td>Teachers can <em>read</em> appData (<code>classbook</code> / <code>classbook-admin</code> / <code>curriculum-admin</code>). Only create/update is manager+. That read is what lets Phase 2 work for teachers.</td><td><code>firestore.rules:665-669</code></td></tr>
    93	  <tr><td>e2e: no spec has ever written appData for real. They stub <code>window.updateAppData</code> and assert the payload. The Node helper signs in as the staff account, which the rules refuse on appData. There is a saved <em>manager</em> session but no saved teacher session.</td><td><code>data-safety.spec.js:3947, 7596-7610</code>; <code>helpers/firestore.js:57</code>; <code>global-setup.js:63-70</code></td></tr>
    94	  <tr><td>e2e seed: <code>activeSemester: spring-2026</code>; semesters spring-2026 (weekly, published) and summer-2026 (camp, unpublished). Specs that touch activeSemester or publishing: day-off-camps, day-off-teacher, data-safety.</td><td><code>e2e/fixtures/seed/curriculum.json</code></td></tr>
    95	</table>
    96	
    97	<h2 id="phases">Phases</h2>
    98	<p>Two phases, committed separately and <strong>deployed once</strong> (one Netlify credit) after both are reviewed.</p>
    99	
   100	<div class="phase" id="phase-1">
   101	<h3>Phase 1: "Make active" in Settings, plus the two things it depends on <span class="status-tag ready">execution-ready: true</span></h3>
   102	<p><strong>Acceptance (user outcomes):</strong></p>
   103	<ul>
   104	  <li><strong>Settings' "Editing Semester" dropdown works.</strong> Picking a semester there switches the app to it, the same as the header and Teacher View dropdowns already do. The header dropdown shows the new semester too, and the Settings form shows that semester. It lists only semesters the user can see.</li>
   105	  <li><strong>Settings is reachable only by managers and admins.</strong> Today curriculum-admin and prep users can open it through the footer "Settings" link, because only the tab button is hidden. That link and its dot get hidden for them as well, and <code>switchTab('settings')</code> refuses for them.</li>
   106	  <li>When Settings is on a non-active Fall/Spring class semester or Summer camp season (Q1; never an SDOC year), a manager sees <strong>"Make this the active semester"</strong> in the publish group.</li>
   107	  <li>Clicking it asks one confirmation that names both semesters, "Make Fall 2026 the active semester? Spring 2026 stops being active.", and adds, when true:
   108	    <ul>
   109	      <li>New semester is a draft: "It's a draft — it will be published so teachers can see it." Activation publishes it in the same single write. That makes the existing "Active Semester — always visible to teachers" badge true, which it isn't today for an unpublished active semester.</li>
   110	      <li>Old semester is a weekly class semester: "Spring 2026 can then be deleted from Curriculum Admin — its lessons stay unless someone deletes it."</li>
   111	      <li>New semester is a camp season: "While Summer 2026 is active it can't be removed or unpublished — make another semester active first."</li>
   112	    </ul></li>
   113	  <li>After confirming, every place that labels the active semester updates without a reload: the header, Teacher View ("(current)"), Settings' badge/toggle, and Curriculum Admin's badge/toggle/Delete.</li>
   114	  <li><strong>Deleting a weekly semester gets a real guard:</strong> the confirmation states how many lessons it holds, read fresh from the server, and says truthfully what goes. That's its lessons; its cut bank and change history stay, which the current text wrongly says are removed. You must type the semester's name to proceed (trimmed, case-insensitive). If the server read fails, nothing is deleted. Camp seasons and SDOC years keep their current (non-destructive) flows.</li>
   115	  <li>If the write fails for any reason (rules, a failed config load, or the season registry being unknown or in error), nothing changes on screen and an alert names the reason and says "Nothing was changed."</li>
   116	  <li>Nobody below manager sees the control: it's rendered only for <code>admin</code>/<code>manager</code> roles, <code>makeSemesterActive</code> refuses otherwise, and the rules refuse the write regardless.</li>
   117	</ul>
   118	<p><strong>Shape:</strong></p>
   119	<ul>
   120	  <li><code>index.html:411</code>: a new <code>onSettingsSemesterChange(value)</code> that does what Teacher View's selector does (<code>app.js:826-830</code>): set <code>#global-semester-select</code>'s value <em>first</em>, then <code>setGlobalSemester(value)</code>. Without the header sync, the header would keep showing the old semester and re-picking it would fire no change event (round 2, finding 1). Settings' options are filtered by <code>canSeeSemester</code>, like the header's.</li>
   121	  <li><code>setupRoleAccess</code> (<code>app.js:318-336</code>): hide <code>#settings-link</code> and its dot (<code>.footer-dot.write-control</code>; other <code>.footer-dot</code>s stay) for non-managers too. <code>switchTab('settings')</code> and the footer handler refuse for non-managers.</li>
   122	  <li>New <code>makeSemesterActive(key)</code> beside <code>toggleSemesterPublish</code>. Eligibility is by type (<code>isWeeklySemester(key) || isCampSeason(key)</code>), never by key prefix (there's a ratchet against prefix routing). It refuses if the user isn't admin/manager, or the key is missing or already active. It checks <code>isPublishableType(key)</code> before any auto-publish, so the two gates can't drift. The old semester's name falls back to its key if the name is missing. Then it confirms through <code>confirmModal</code> (built in this phase, so Phase 2 only adds the checkbox and the activation tests aren't rewritten), then writes <code>updateAppData({ activeSemester: key, ['semesters.'+key+'.published']: true /* only if it was false */, …Phase 2 fields })</code>. It changes <code>currentConfig</code> optimistically and restores it exactly on failure, including "field was absent".</li>
   123	  <li>Re-render set after success or failure: header options, Teacher View selector, <code>renderSemesterSelector()</code>, <code>loadSettingsForm()</code>. The header's <code>change</code> listener gets the attach-once guard Teacher View already uses (<code>dataset.listenerAttached</code>), so re-rendering doesn't stack handlers.</li>
   124	  <li><code>deleteSemester</code>, weekly branch only: the count comes from <code>readServerSemesterLessonMap(key)</code> (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
   125	  <li>Left alone on purpose: <code>app.js:5069-5074</code> and the <code>caCurrentSemester</code> assignment at <code>:4590</code> are dead code (round 2 confirmed that nothing reads them). This plan doesn't touch them.</li>
   126	  <li>The Curriculum Admin bar stays read-only for "active" (it's the same audience, but one place to change it is enough).</li>
   127	</ul>
   128	
   129	<div class="bdd">Scenario: the Settings dropdown switches semester (fix)
   130	  Given a manager on Settings with the header on Spring 2026
   131	  When they pick Fall 2026 in "Editing Semester"
   132	  Then the header shows Fall 2026 and the Settings form shows Fall's name/start date
   133	
   134	Scenario: manager makes Fall active (happy path) — real write, manager session
   135	  Given a manager on Settings for Fall 2026 (published, weekly), active = Spring 2026
   136	  When they click "Make this the active semester" and confirm
   137	  Then curriculum/appData.activeSemester reads back from the emulator as "fall-2026"
   138	   And a whole-document diff of appData, ignoring lastUpdated/lastUpdatedBy (as app.js:10918 does), shows only activeSemester changed
   139	   And header "Fall 2026 (active)", Teacher View "Fall 2026 (current)", Settings badge on Fall,
   140	       Curriculum Admin shows Spring with Publish toggle and Delete
   141	
   142	Scenario: making a draft semester active publishes it (edge) — stubbed updateAppData
   143	  Given Fall 2026 is published:false
   144	  When the manager makes it active and confirms (dialog mentions publishing)
   145	  Then exactly one updateAppData call, and
   146	       Object.keys(payload).sort() equals ["activeSemester", "semesters.fall-2026.published", …Phase 2 keys]
   147	
   148	Scenario: a Summer camp season can be made active (Q1)
   149	  Given Settings on Summer 2026 (camp season)
   150	  When the manager makes it active
   151	  Then activeSemester = "summer-2026"; with nothing remembered a user lands on Summer 2026;
   152	       Prep Dashboard hidden (as for any camp selection); Teacher View and Curriculum Admin render as they do when Summer is merely selected (so a curriculum-admin/prep user with nothing remembered lands with the Curriculum Admin tab hidden, as today for Summer)
   153	
   154	Scenario: back from Summer to a class semester (edge)
   155	  Given Summer 2026 is active
   156	  When the manager makes Fall 2026 active
   157	  Then the Prep Dashboard tab reappears for Fall
   158	
   159	Scenario: cancel changes nothing (edge)
   160	  When the manager cancels the confirmation
   161	  Then updateAppData is not called and nothing on screen changes
   162	
   163	Scenario: ineligible or already active: no button (edge)
   164	  Given Settings on an SDOC year, or on the active semester
   165	  Then no "Make this the active semester" button
   166	
   167	Scenario: non-manager never sees it (UI)
   168	  Given a curriculum-admin (staff) user
   169	  Then the Settings tab button AND the footer "Settings" link are hidden
   170	   And calling switchTab('settings') leaves them where they were
   171	   And the button is not visible even though loadSettingsForm ran (assert not visible, not count 0)
   172	
   173	Scenario: the Settings dropdown keeps the header in step (regression, round 2)
   174	  Given the header shows Spring 2026
   175	  When Settings' dropdown picks Fall 2026, then the header picks Spring 2026
   176	  Then the app is back on Spring 2026 (the header change fired)
   177	
   178	Scenario: a camp season active can't be removed (edge)
   179	  Given Summer 2026 is active
   180	  Then Curriculum Admin shows no Delete and no Publish toggle for it, and the activation confirm said so
   181	
   182	Scenario: write refused by the rules (failure) — real write, staff session
   183	  Given the staff test account
   184	  When updateAppData({ activeSemester: "spring-2026" }) is called
   185	  Then it rejects with permission-denied and appData is unchanged
   186	
   187	Scenario: write refused by the app's own guard (failure)
   188	  Given seasonRegistryMode = "error" (or configLoadFailed)
   189	  When the manager confirms
   190	  Then the alert names the reason, says "Nothing was changed", and the labels, activeSemester and published flag are exactly as before
   191	
   192	Scenario: deleting a weekly semester needs its name typed (safety)
   193	  Given Spring 2026 is not active and the server holds N lessons for it
   194	  When the manager clicks Delete
   195	  Then the modal states N lessons, says the cut bank and change history stay, and requires "Spring 2026"
   196	       (trimmed, case-insensitive); a wrong or empty answer deletes nothing
   197	       (updateAppData and deleteLessonData not called)
   198	
   199	Scenario: the lesson count can't be read (failure)
   200	  Given readServerSemesterLessonMap rejects
   201	  When the manager clicks Delete
   202	  Then an alert says nothing was deleted, and nothing was
   203	
   204	Scenario: re-render does not stack handlers (regression)
   205	  After makeSemesterActive runs twice, one header change calls setGlobalSemester exactly once</div>
   206	</div>
   207	
   208	<div class="phase" id="phase-2">
   209	<h3>Phase 2: "Switch everyone to it" <span class="status-tag ready">execution-ready: true</span></h3>
   210	<p><strong>Acceptance (user outcomes):</strong></p>
   211	<ul>
   212	  <li>The Phase 1 confirmation has a checkbox, <strong>"Also switch everyone to Fall 2026 the next time they open the Classbook"</strong>, ticked by default (Q2). Because a plain <code>confirm()</code> can't hold a checkbox, the confirmation becomes a small in-app modal, reusing the existing <code>simple-modal</code> styling.</li>
   213	  <li>With it ticked, every user who can see that semester lands on it the next time they load the Classbook, once. That includes the manager who made the switch, on their next load. After that, any semester they pick sticks as usual.</li>
   214	  <li>The switch is tied to <strong>that</strong> semester. If someone later makes a different semester active without ticking the box, browsers that haven't loaded yet are not moved anywhere.</li>
   215	  <li>A user who can't see the semester yet (unpublished; rare, since activation publishes) isn't moved, and isn't marked done either. If it becomes visible while the switch still stands, they move then.</li>
   216	  <li>With it unticked, nobody's remembered semester moves.</li>
   217	  <li>Tabs already open move on their next reload, not live.</li>
   218	</ul>
   219	<p><strong>Shape:</strong> when ticked, the same single <code>update()</code> writes <code>activeSemesterSwitch: { to: key, at: new Date().toISOString() }</code>. It must be a <strong>client ISO string</strong>, the way <code>lastUpdated</code> is: a <code>serverTimestamp()</code> reads back as a Timestamp, would never equal the stored string, and would re-switch on every load. Compare <code>String(sw.at)</code>. <strong>Placement is load-bearing:</strong> the check runs <em>once</em> in the <code>DOMContentLoaded</code> sequence, after <code>requireAuth</code> and <code>loadConfig()</code> (<code>app.js:148-152</code>) and before <code>initGlobalSemesterSelector()</code> (<code>:158</code>). Never inside <code>initGlobalSemesterSelector</code>, which is re-called after creating a semester and after <code>makeSemesterActive</code>, and would consume the manager's own switch in the same page load. It's one map field, so it replaces the previous switch whole. On load, before the existing pick at <code>app.js:65</code>, with <code>sw = currentConfig.activeSemesterSwitch</code> and <code>seen = localStorage.activeSemesterSwitchSeen</code>:</p>
   220	<ul>
   221	  <li>If <code>sw</code> is missing, or <code>sw.at === seen</code>: do nothing.</li>
   222	  <li>If <code>sw.to !== currentConfig.activeSemester</code>: the switch is stale, so mark it seen and do nothing.</li>
   223	  <li>If <code>canSeeSemester(sw.to)</code>: set <code>globalSemesterKey = sw.to</code> and <strong>write <code>localStorage.globalSemesterKey</code> here</strong> (the <code>setItem</code> at :69 sits in the fallback branch, which this makes false), then mark it seen.</li>
   224	  <li>Otherwise (can't see it yet): don't move and don't mark it seen.</li>
   225	</ul>
   226	<p><strong>Decided asymmetry:</strong> a browser that marked a switch seen through the stale branch isn't moved if that same target becomes active again later without a new tick, while a browser that never loaded would be. That's acceptable: a later switch is a new <code>at</code> and moves everyone.</p>
   227	<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
   228	<div class="note">A new <strong>field</strong> on existing <code>curriculum/appData</code>. It's not a new collection, so no rules change. Nothing reads it until the first switch, so deploying Phase 2 moves nobody.</div>
   229	
   230	<div class="bdd">Scenario: teachers are moved once (happy path)
   231	  Given a teacher's browser remembers "spring-2026" (fresh context, teacher signed in via the form)
   232	   And appData.activeSemester = "fall-2026", activeSemesterSwitch = { to: "fall-2026", at: T1 }
   233	  When the teacher loads the Classbook
   234	  Then they land on Fall 2026, localStorage.globalSemesterKey = "fall-2026", activeSemesterSwitchSeen = T1
   235	  When they pick Spring 2026 and reload
   236	  Then they stay on Spring 2026
   237	
   238	Scenario: the manager who switched is moved too (edge)
   239	  Given the manager made Fall active with the box ticked, then picked Spring
   240	  When they reload
    70	
    71	<div class="phase" id="phase-1">
    72	<h3>Phase 1: "Make active" in Settings, plus the two things it depends on <span class="status-tag not-ready">execution-ready: false</span></h3>
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
    85	  <li><strong>Deleting a weekly semester gets a real guard, and becomes all-or-nothing:</strong>
    86	    <ul>
    87	      <li>The confirmation states how many lessons it holds, read fresh from the server, and says truthfully what happens. Its lessons are deleted. Its cut bank and change history stay stored but are no longer reachable in the Classbook unless a semester with the same key is recreated. (The current text wrongly says they're removed.)</li>
    88	      <li>You must type the semester's name to proceed (trimmed, case-insensitive).</li>
    89	      <li>Before anything is deleted, the Classbook <strong>downloads a JSON snapshot</strong> of that semester: its appData entry, lesson map, cut bank and change history, all read fresh from the server. If a read fails, nothing is deleted.</li>
    90	      <li>The semester's entry and its lessons are removed <strong>in one Firestore transaction</strong>: either both go or neither does. Today they're two separate writes, and a failure of the second is only logged to the console, which can leave lessons orphaned and unreachable (Codex finding 3).</li>
    91	    </ul>
    92	    Camp seasons and SDOC years keep their current (non-destructive) flows.</li>
    93	  <li>If the write fails for any reason (rules, a failed config load, or the season registry being unknown or in error), nothing changes on screen and an alert names the reason and says "Nothing was changed."</li>
    94	  <li>Nobody below manager sees the control: it's rendered only for <code>admin</code>/<code>manager</code> roles, <code>makeSemesterActive</code> refuses otherwise, and the rules refuse the write regardless.</li>
    95	</ul>
    96	<p><strong>Shape:</strong></p>
    97	<ul>
    98	  <li><code>index.html:411</code>: a new <code>onSettingsSemesterChange(value)</code> that does what Teacher View's selector does (<code>app.js:826-830</code>): set <code>#global-semester-select</code>'s value <em>first</em>, then <code>setGlobalSemester(value)</code>. Without the header sync, the header would keep showing the old semester and re-picking it would fire no change event (round 2, finding 1). Settings' options are filtered by <code>canSeeSemester</code>, like the header's.</li>
    99	  <li><code>setupRoleAccess</code> (<code>app.js:318-336</code>): hide <code>#settings-link</code> and its dot (<code>.footer-dot.write-control</code>; other <code>.footer-dot</code>s stay) for non-managers too. <code>switchTab('settings')</code>, the footer handler, <strong>and the tab button's own click handler</strong> (<code>app.js:203</code>) refuse for non-managers.</li>
   100	  <li>New <code>makeSemesterActive(key)</code> beside <code>toggleSemesterPublish</code>. Eligibility is by type (<code>isWeeklySemester(key) || isCampSeason(key)</code>), never by key prefix (there's a ratchet against prefix routing). It refuses if the user isn't admin/manager, or the key is missing or already active. It checks <code>isPublishableType(key)</code> before any auto-publish, so the two gates can't drift. The old semester's name falls back to its key if the name is missing. Then it confirms through <code>confirmModal</code> (built in this phase, so Phase 2 only adds the checkbox and the activation tests aren't rewritten), then writes through a new <code>activateSemesterTx(key, expectedActive, { publish, switchEveryone })</code> in <code>firebase-data.js</code> (Codex finding 4). It's one <code>runTransaction</code> that re-reads appData from the server and refuses, with "reload and try again", unless <code>semesters[key]</code> still exists with a name and an eligible type, and <code>activeSemester === expectedActive</code> (what the confirmation showed). Only then does it <code>tx.update</code> <code>activeSemester</code>, the publish flag if needed, the Phase 2 switch field, and <code>lastUpdated</code>/<code>lastUpdatedBy</code>. This way a stale tab can't point "active" at a semester another tab deleted, or recreate a half-semester through the dotted publish path. It honours the same guards as <code>updateAppData</code>. <code>currentConfig</code> changes only after the commit succeeds; on failure nothing local changes.</li>
   101	  <li>Re-render set after success or failure: header options, Teacher View selector, <code>renderSemesterSelector()</code>, <code>loadSettingsForm()</code>. The header's <code>change</code> listener gets the attach-once guard Teacher View already uses (<code>dataset.listenerAttached</code>), so re-rendering doesn't stack handlers.</li>
   102	  <li><code>deleteSemester</code>, weekly branch only, in this order:
   103	    <ol>
   104	      <li>Forced-server reads: <code>readServerSemesterLessonMap(key)</code> plus the semester's <code>cutProjects[key]</code> and <code>changeLog[key]</code>. Any rejection refuses. <code>null</code> means 0 lessons and proceeds.</li>
   105	      <li>The modal (count, truthful text, typed name).</li>
   106	      <li>A JSON snapshot download: <code>classbook-&lt;key&gt;-snapshot-&lt;ISO&gt;.json</code> through a Blob link, containing <code>{ appDataEntry, lessons, cutProjects, changeLog, takenAt, takenBy }</code>.</li>
   107	      <li>New <code>deleteWeeklySemesterTx(key)</code> in <code>firebase-data.js</code>: one <code>runTransaction</code> (the house pattern, e.g. <code>firebase-data.js:2452</code>) that re-reads appData and verifies <code>semesters[key]</code> still exists and <code>activeSemester !== key</code>. It then <code>tx.update</code>s appData (<code>semesters.&lt;key&gt;</code> delete, plus <code>lastUpdated</code>/<code>lastUpdatedBy</code>) and lessonData (<code>&lt;key&gt;</code> delete). It honours <code>updateAppData</code>'s guards (<code>configLoadFailed</code>, season registry).</li>
   108	    </ol>
   109	    The old two-write path and its warn-only catch are removed for weekly semesters. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
   110	  <li>Left alone on purpose: <code>app.js:5069-5074</code> and the <code>caCurrentSemester</code> assignment at <code>:4590</code> are dead code (round 2 confirmed that nothing reads them). This plan doesn't touch them.</li>
   111	  <li>The Curriculum Admin bar stays read-only for "active" (it's the same audience, but one place to change it is enough).</li>
   112	</ul>
   113	
   114	<div class="bdd">Scenario: the Settings dropdown switches semester (fix)
   115	  Given a manager on Settings with the header on Spring 2026
   215	<h3>Phase 2: "Switch everyone to it" <span class="status-tag not-ready">execution-ready: false</span></h3>
   216	<p><strong>Acceptance (user outcomes):</strong></p>
   217	<ul>
   218	  <li>The Phase 1 confirmation has a checkbox, <strong>"Also switch everyone to Fall 2026 the next time they open the Classbook"</strong>, ticked by default (Q2). Because a plain <code>confirm()</code> can't hold a checkbox, the confirmation becomes a small in-app modal, reusing the existing <code>simple-modal</code> styling.</li>
   219	  <li>With it ticked, every <strong>person</strong> who can see that semester lands on it the next time they load the Classbook, once per person, not once per browser. On a shared studio computer, each teacher who signs in is moved once (Codex finding 2). That includes the manager who made the switch, on their next load. After that, any semester they pick sticks as usual.</li>
   220	  <li>The switch is tied to <strong>that</strong> semester. If someone later makes a different semester active without ticking the box, browsers that haven't loaded yet are not moved anywhere.</li>
   221	  <li>A user who can't see the semester yet (unpublished; rare, since activation publishes) isn't moved, and isn't marked done either. If it becomes visible while the switch still stands, they move then.</li>
   222	  <li>With it unticked, nobody's remembered semester moves. An unticked activation <strong>deletes</strong> any earlier switch record in the same transaction, so an old switch can never come back to life (Codex finding 1).</li>
   223	  <li>Tabs already open move on their next reload, not live.</li>
   224	</ul>
   225	<p><strong>Shape:</strong> the "seen" marker is per signed-in user: <code>localStorage['activeSemesterSwitchSeen:' + uid]</code>. <code>globalSemesterKey</code> stays browser-wide as today. When unticked, the transaction writes <code>activeSemesterSwitch: FieldValue.delete()</code>. When ticked, the same transaction writes <code>activeSemesterSwitch: { to: key, at: new Date().toISOString() }</code>. It must be a <strong>client ISO string</strong>, the way <code>lastUpdated</code> is: a <code>serverTimestamp()</code> reads back as a Timestamp, would never equal the stored string, and would re-switch on every load. Compare <code>String(sw.at)</code>. <strong>Placement is load-bearing:</strong> the check runs <em>once</em> in the <code>DOMContentLoaded</code> sequence, after <code>requireAuth</code> and <code>loadConfig()</code> (<code>app.js:148-152</code>) and before <code>initGlobalSemesterSelector()</code> (<code>:158</code>). Never inside <code>initGlobalSemesterSelector</code>, which is re-called after creating a semester and after <code>makeSemesterActive</code>, and would consume the manager's own switch in the same page load. It's one map field, so it replaces the previous switch whole. On load, before the existing pick at <code>app.js:65</code>, with <code>sw = currentConfig.activeSemesterSwitch</code> and <code>seen = localStorage['activeSemesterSwitchSeen:' + getAuthUser().uid]</code>:</p>
   226	<ul>
   227	  <li>If <code>sw</code> is missing, or <code>sw.at === seen</code>: do nothing.</li>
   228	  <li>If <code>sw.to !== currentConfig.activeSemester</code>: the switch is stale, so mark it seen and do nothing.</li>
   229	  <li>If <code>canSeeSemester(sw.to)</code>: set <code>globalSemesterKey = sw.to</code> and <strong>write <code>localStorage.globalSemesterKey</code> here</strong> (the <code>setItem</code> at :69 sits in the fallback branch, which this makes false), then mark it seen.</li>
   230	  <li>Otherwise (can't see it yet): don't move and don't mark it seen.</li>
   231	</ul>
   232	<p><strong>Decided asymmetry:</strong> a browser that marked a switch seen through the stale branch isn't moved if that same target becomes active again later without a new tick, while a browser that never loaded would be. That's acceptable: a later switch is a new <code>at</code> and moves everyone.</p>
   233	<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
   234	<div class="note">A new <strong>field</strong> on existing <code>curriculum/appData</code>. It's not a new collection, so no rules change. Nothing reads it until the first switch, so deploying Phase 2 moves nobody.</div>
   235	
   236	<div class="bdd">Scenario: teachers are moved once (happy path) — staged so the first sign-in can't consume it (Codex finding 5)
   237	  Given a teacher signed in via the form in a fresh context while NO switch exists
   238	   And their browser then remembers "spring-2026"
   239	   And a manager context then makes Fall active with the box ticked (T1)
   240	  When the teacher reloads the Classbook
   288	  Then their remembered semester is unchanged</div>
   289	</div>
   290	
   291	<h2 id="safety">Firebase safety checklist</h2>
   292	<div class="safe">
   293	  <ul>
   294	    <li><strong>Rules:</strong> none needed. <code>curriculum/appData</code>: read for classbook users, write for manager+ only (<code>firestore.rules:652-669</code>). No new collection. Phase 1's e2e includes the non-manager refusal against the real rules.</li>
   295	    <li><strong>The Delete exposure (finding 3):</strong> making a weekly semester non-active makes it deletable, which is already true of Spring 2026 in production. Phase 1 adds the lesson count and the typed name to that delete, and the activation confirm says so. Until Phase 1 ships: <strong>don't click Delete on Spring 2026</strong>.</li>
   296	    <li><strong>Partial update:</strong> <code>updateAppData</code> (<code>update()</code> of named dotted paths; its <code>set(merge)</code> fallback fires only if appData doesn't exist, which isn't the case here). Only <code>activeSemester</code>, optionally <code>semesters.&lt;key&gt;.published</code> and <code>activeSemesterSwitch</code>, plus the existing <code>lastUpdated</code>/<code>lastUpdatedBy</code>.</li>
   297	    <li><strong>No undefined or empty values:</strong> every path is a known string or <code>true</code>. The key is validated against <code>currentConfig.semesters</code> before writing.</li>
   298	    <li><strong>Awaited:</strong> the one write is awaited, and on failure the in-memory state is restored exactly (the <code>toggleSemesterPublish</code> pattern, including "field was absent").</li>
   299	    <li><strong>Activation</strong> deletes nothing. The previous value is shown in the confirmation. To roll back, make the old semester active again.</li>
   300	    <li><strong>Weekly-semester delete is a bulk delete</strong>, so it gets the repo's snapshot rule (JSON download of everything it makes unreachable, taken from forced-server reads, aborting if a read fails) and one transaction across <code>appData</code> and <code>lessonData</code>, with a failure test proving neither document changes.</li>
   301	    <li><strong>Refuses on a bad load:</strong> inherited from <code>updateAppData</code> (config load failed, season registry unknown or error).</li>
   302	    <li><strong>Production spot-check</strong> after deploy: Christie uses the button once for real (or the console line has already done it), then checks <code>curriculum/appData.activeSemester</code> in the Firebase Console.</li>
   303	  </ul>
   304	</div>
   305	
   306	<h2 id="tests">Tests</h2>
   307	<ul>
   308	  <li>New <code>e2e/active-semester.spec.js</code> (emulator only), following the house pattern (finding 1):
   309	    <ul>
   310	      <li><strong>Payload/shape scenarios</strong> stub <code>window.updateAppData</code> and assert <code>Object.keys(payload).sort()</code> (as <code>data-safety.spec.js:7596-7610</code> does). The in-memory test semester is added to <code>currentConfig</code> in the page only, with an explicit <code>semesterType: 'weekly'</code>.</li>
   311	      <li><strong>Top leak risk:</strong> a leaked <code>activeSemesterSwitch</code> would silently move <em>every</em> later test (their contexts carry no <code>activeSemesterSwitchSeen</code>) to <code>sw.to</code>. The restore below is mandatory and read back, and a final assertion in this spec checks appData has no <code>activeSemesterSwitch</code>.</li>
   312	      <li><strong>One real round-trip</strong> runs in a manager context (<code>MANAGER_STATE_PATH</code>, first spec to use it). The test semester is created and removed through the app's own <code>updateAppData</code> in that page, and <code>activeSemester</code> is restored to <code>spring-2026</code> and <code>activeSemesterSwitch</code> deleted in <code>afterEach</code> <strong>and</strong> <code>afterAll</code>, each read back. Cleanup is self-contained and doesn't rely on file order. With <code>workers: 1</code> this file happens to run first alphabetically, and a leak would break <code>day-off-camps.spec.js</code> "SDOC R6" and <code>day-off-teacher.spec.js</code> "T20", which read the active semester.</li>
   313	      <li><strong>The restore can't run from Node</strong> (the helper is staff, and appData writes are manager-only). <code>afterEach</code>/<code>afterAll</code> open a manager browser context and call the page's own <code>updateAppData</code> (<code>activeSemester: 'spring-2026'</code>, <code>activeSemesterSwitch: FieldValue.delete()</code>, <code>semesters.&lt;test&gt;: FieldValue.delete()</code>), then read back with <code>readAppDataFromServer()</code> (<code>firebase-data.js:243-247</code>).</li>
   314	      <li>The <strong>camp-season scenario runs stubbed</strong>. Its auto-publish would otherwise flip the seed's <code>summer-2026.published: false</code>, which <code>day-off-materials</code> M10 and <code>day-off-camps</code> enumerate.</li>
   315	      <li>Payloads: use the <code>window.updateAppData</code> stub pattern (<code>data-safety.spec.js:3947-3958</code>), whose payload holds only the caller's keys. <code>withAppDataSpy</code> is file-local and adds <code>lastUpdated</code>.</li>
   316	      <li><strong>One real rules refusal</strong> uses the staff account and asserts <code>permission-denied</code> specifically (the seeded season registry is valid, so <code>updateAppData</code>'s own guard won't fire first).</li>
   317	      <li><strong>Phase 2's teacher</strong> is a fresh context (blank storageState) signed in with <code>signInViaForm(page, 'teacher')</code>, because <code>login(page,'teacher')</code> on the default state returns the admin. The remembered <code>globalSemesterKey</code> is set <em>after</em> that first load, followed by a reload, because the app writes it itself on first load and the test would otherwise pass vacuously.</li>
   318	    </ul></li>
   319	  <li>Assertions that must use types, not key prefixes: <code>isWeeklySemester</code> / <code>isCampSeason</code> (the ratchet at <code>static-checks.spec.js:108</code>).</li>
   320	  <li>The full suite stays green. Re-count at execution time; don't trust a number in this plan.</li>
   321	</ul>
   322	
   323	<h2 id="completeness">Completeness: what if this is interrupted?</h2>
   324	<ul>
   325	  <li><strong>Mid-code, before deploy:</strong> nothing is live. Resume from the branch.</li>
   326	  <li><strong>The write itself is atomic:</strong> one <code>update()</code>, so the active flag and the auto-publish can't half-happen.</li>
   327	  <li><strong>Phase 1 shipped without Phase 2:</strong> still coherent. The button works and moves nobody. (The plan still deploys both together.)</li>
   328	  <li><strong>After a switch:</strong> browsers pick it up on their next load, whenever that is. There's no deadline and nothing to finish.</li>
   329	</ul>
   330	
   331	<h2 id="resume">Resume instructions</h2>
   332	<ol>
   333	  <li>Read this plan. Check the Decisions Log for Christie's answers to Q1/Q2 and any review findings.</li>
   334	  <li>Work in a worktree on branch <code>claude/make-active-semester</code> off <code>origin/main</code>.</li>
   335	  <li>Check line numbers against current main. They were recorded at <code>2ef2e62</code>.</li>
   336	  <li>e2e: <code>npm test -- --grep "active semester"</code>. The emulator ports are fixed, so if another session's suite holds 8180, wait or shift ports locally without committing (see the memory note on classbook worktree deploys).</li>
   337	  <li>Per phase: commit, run the full suite, then a second-model implementation review. Deploy once after both, only after Christie says yes, via <code>NETLIFY_SITE_ID=… npm run deploy</code> from a clean, pushed main.</li>
   338	</ol>
   339	
   340	<h2 id="decisions">Decisions Log (append-only)</h2>
   341	<div class="decision">
   342	  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
   343	  <ul>
   344	    <li>(1) An unticked activation now deletes any old <code>activeSemesterSwitch</code>, with a three-activation regression test.</li>
   345	    <li>(2) The "seen" marker is per user (<code>activeSemesterSwitchSeen:&lt;uid&gt;</code>), so on a shared computer every person moves once. That matches the promise "switch everyone".</li>
   346	    <li>(3) Weekly delete takes a JSON snapshot download (forced-server reads) first and removes the appData entry and lesson map in one transaction, with a failure test. The text now says the cut bank and change history stay stored but become unreachable.</li>
   347	    <li>(4) Activation runs in a transaction that verifies the target still exists and "active" hasn't changed since the confirmation, so no ghost semester can be created.</li>
   348	    <li>(5) The teacher test is staged so the first sign-in can't consume the switch, and the Phase 1 happy path unticks the box.</li>
   349	  </ul>
   350	  Also taken: the tab button's own click handler refuses Settings for non-managers.<br>
   351	  <strong>Scope note for Christie:</strong> finding 3 grows Phase 1 (a snapshot download plus a transaction for delete). It's needed because this feature is what exposes Delete on the old semester.<br>
   352	  <strong>Execution-ready reverted to false</strong> until a Codex confirmation round.
   353	</div>
   354	<div class="decision">
   355	  <strong>Sep 29, 2026: round 3 (confirmation) — EXECUTION-READY</strong> (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md</code>). All round-2 blockers were confirmed resolved. Its four clarifications are folded in: hide only <code>.footer-dot.write-control</code>; <code>readServerSemesterLessonMap</code> returning <code>null</code> means 0 lessons, not a failure; the three delete tests must split their <code>page.evaluate</code> to drive the modal; the activation uses <code>confirmModal</code> from Phase 1. Also named: a curriculum-admin/prep user with nothing remembered lands with Curriculum Admin hidden when Summer is active. All phases are marked execution-ready. Execution waits for Christie's go-ahead. Codex didn't review this plan (out of credits); all three rounds were Claude.

exec
/bin/zsh -lc 'rg -n "''^##|''^###|Finding|EXECUTION|NOT RESOLVED|Minimum|unticked|per-browser|snapshot|ghost|teacher test|tab" /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md | tail -n 100; tail -n 180 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md' in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
1345:   339	  // Switch active tab to Teacher View since Curriculum Admin is hidden for teachers
1364:   358	  // Settings link switches to Settings tab — through the tab button, so it gets
1365:   359	  // the same form refresh as clicking the tab (review: it used to bypass it).
1446:  4463	      <table style="border-collapse:collapse;width:100%;">${rows}</table>
1542:  4559	  // this tab if the write is refused, or the config would be missing a
1654: 10660	  // Now uses global semester instead of per-tab selection
1666: 10672	// to the tab for the same semester keeps any unsaved edits.
1790: 11270	      // The SERVER's pool, not this tab's: the × button edits
1791: 11271	      // currentConfig's list before Save runs, and another tab may have added
1798: 11278	        // Put just those names back in this tab's list (other unsaved edits in
1825: 11305	  // Keep this tab's copy in step with exactly what is being written.
1843: 11323	    // Keep this tab's config in step with exactly what was written. Before
1866: 11346	    // Reload other tabs if active
1867: 11347	    const activeTab = document.querySelector('.tab-btn.active')?.dataset.tab;
1929:    39	// pressing "Stamp semester types", and a stale pre-Phase-1 tab whose
2256:A new blocker has emerged in Phase 2: leaving the prior switch record untouched when the checkbox is unticked can later reactivate an old “switch everyone” instruction. I’m tracing that alongside the destructive weekly-delete sequence and the test restore mechanics before giving the verdict.
2336:e2e/day-off-camps.spec.js:318:  test('SDOC R2: a stale camp editor is refused instead of replacing a projects map another tab changed', async ({ page }) => {
2339:e2e/day-off-camps.spec.js:324:    // This tab edits Monday's projects from its stale copy.
2380:e2e/emulators/seed.js:31:    [`http://${firestore.host}:${firestore.port}/emulator/v1/projects/${PROJECT_ID}/databases/(default)/documents`, 'Firestore'],
2481:    12	 * 2. Signs in ONCE and snapshots the browser's authenticated session
2484:    15	 *    browser context then starts from this snapshot already signed in (see
2492:    23	 *    tests' login() path identical to what they had. The snapshot file holds
3053:   102	  // Hide/show Prep Dashboard tab based on semester type
3055:   104	  const prepDashboardTab = document.querySelector('.tab-btn[data-tab="prep-dashboard"]');
3060:   109	      if (document.querySelector('.tab-btn.active')?.dataset.tab === 'prep-dashboard') {
3069:   118	  // Hide/show Curriculum Admin tab for non-manager users on summer semesters
3072:   121	  // Refresh all tabs to use new semester
3073:   122	  const activeTab = document.querySelector('.tab-btn.active')?.dataset.tab;
3113:   162	  // listener — never awaited — so this tab follows the Summer Camp App
3126:   175	  // Hide Prep Dashboard tab for summer camp semesters (prep is done in Summer Camp App)
3128:   177	  const prepDashboardTab = document.querySelector('.tab-btn[data-tab="prep-dashboard"]');
3138:   187	  // Initialize Curriculum Admin (default tab)
3149:   198	function switchTab(tabId) {
3150:   199	  const btn = document.querySelector(`.tab-btn[data-tab="${tabId}"]`);
3155:   204	  document.querySelectorAll('.tab-btn').forEach(btn => {
3157:   206	      const tabId = btn.dataset.tab;
3159:   208	      document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
3163:   212	      document.getElementById(tabId)?.classList.add('active');
3165:   214	      if (tabId === 'teacher-view') {
3174:   297	// Hide/show Curriculum Admin tab based on semester type for non-manager users.
3183:   306	  const caTab = document.querySelector('.tab-btn[data-tab="curriculum-admin"]');
3188:   311	    if (document.querySelector('.tab-btn.active')?.dataset.tab === 'curriculum-admin') {
3200:   323	  // Manager+: full access to all tabs including Settings
3203:   326	  // classbook-admin / curriculum-admin / prep role: all tabs EXCEPT Settings
3206:   329	    document.querySelector('.tab-btn[data-tab="settings"]')?.style.setProperty('display', 'none');
3212:   335	  // Hide admin tabs (Curriculum Admin, Settings) and Prep Dashboard
3216:   339	  // Switch active tab to Teacher View since Curriculum Admin is hidden for teachers
3235:   358	  // Settings link switches to Settings tab — through the tab button, so it gets
3236:   359	  // the same form refresh as clicking the tab (review: it used to bypass it).
3337:  4559	  // this tab if the write is refused, or the config would be missing a
3429: 10660	  // Now uses global semester instead of per-tab selection
3441: 10672	// to the tab for the same semester keeps any unsaved edits.
3517:   407	        <p class="settings-panel-desc">Configure semester settings, data source URLs, and Week tab GIDs. These settings are shared across all users.</p>
3571:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-data-safety-remaining-stages.html:1206:    <strong>🛑 Correction, Aug 15, 2026 (round 10) — the claim above that "two admins acting on either bank... can no longer clobber each other" is TRUE for Cut Bank but was FALSE as originally stated for Idea Bank.</strong> Both round-10 reviewers, independently, found and confirmed <code>curriculum/futureProjects</code> (the Idea Bank's backing document) has FIVE other live, unaudited writers that still use the old local-splice-then-full-array-overwrite pattern via <code>saveFutureProjects()</code>: <code>saveNewIdea()</code>, <code>saveIdeaEdit()</code>, <code>deleteIdeaProject()</code>, <code>archiveIdeaProject()</code>, and <code>unarchiveIdeaProject()</code> (all <code>app.js:5305-5383</code>). <code>pasteFromIdeaBank()</code>'s <code>arrayRemove()</code> only wins the race against itself and against Phase-17-style atomic appends — it loses against any of these five. Concretely: an admin pastes (correctly removes) idea X; a moment later, a different admin archives, edits, deletes, or adds a DIFFERENT idea from a stale snapshot that still contains X — that admin's full-array overwrite silently resurrects X. <strong>Cut Bank has no equivalent gap</strong> — both reviewers confirmed, via exhaustive grep, that <code>cutProject()</code> (Phase 17, <code>arrayUnion</code>), <code>pasteFromCutBank()</code>, and <code>deleteCutProject()</code> (both this phase, <code>arrayRemove</code>) are the ONLY three functions that ever touch <code>currentCutProjects</code> — the Cut Bank race is genuinely, completely closed. <strong>Fixing the Idea Bank's remaining five writers, and a broader pattern of the same "shared document/array last-write-wins" vulnerability class found the same round in unrelated features (<code>curriculum/appData</code>/Settings, Prep Dashboard, Prep Cycle config, diagnostic dismissals), is deliberately OUT OF SCOPE for this plan</strong> — Christie's explicit decision, given this is a distinct vulnerability class from Vulnerability #11 (shared config/array documents, not lesson content) that reaches well beyond anything this plan has otherwise touched. It will be addressed by a separate, dedicated plan, covering the whole app comprehensively rather than the incidentally-discovered subset found here. See "Not in scope" below for the specific pointer.</div>
3574:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-data-safety-remaining-stages.html:2273:  <div class="danger">🛑 <strong>Residual gap, found Aug 15, 2026 (round 9, Codex): this guard is go-forward only — it has no effect on a "summer-"-prefixed, non-camp-type key that might already exist in <code>currentConfig.semesters</code> before this phase ever ships.</strong> The check only runs inside <code>createNewSemester()</code>, at the moment of creation — it cannot retroactively repair or flag an already-existing ambiguous key, and (as established above) Settings can edit a semester's display name without ever touching its underlying key, so there is no in-app remediation path for one either. <strong>No such semester is known to exist in production today</strong> — <code>semesterType: 'summer-camp'</code> is confirmed set in exactly two places in the codebase (both for <code>summer-2026</code>, see Phase 14/15's danger boxes), and creating an ambiguous key requires a deliberate, unusual admin naming choice that would need to have already happened. Before or during deployment of this phase, a one-time, read-only check of the real <code>curriculum/appData</code> config document is recommended — confirm no key other than <code>summer-2026</code> starts with <code>"summer-"</code> — rather than assuming this from the app's UI-reachability analysis alone. Not a code change; a deployment-time verification step, noted here so it isn't silently skipped.</div>
3874:   106	  await page.click('.tab-btn[data-tab="teacher-view"]');
3928:   452	    // Without this a tab whose rule was removed mid-session would sit on
3931:   455	    // tab that then can't write has to be reloaded — accepted: reviewed and
4025:    55	  <p><strong>File:</strong> <code>js/app.js</code>. <strong>Functions:</strong> <code>saveNewIdea()</code> (~5305-5330, write ~5327), <code>saveIdeaEdit()</code> (~5340-5357, write ~5354), <code>deleteIdeaProject()</code> (~5359-5369, write ~5367), <code>archiveIdeaProject()</code> (~5371-5376, write ~5374), <code>unarchiveIdeaProject()</code> (~5378-5383, write ~5381), and <code>pasteFromIdeaBank()</code> (~5648-5741, write via <code>saveFutureProjects()</code> inside its own try/catch). All call <code>saveFutureProjects(projects)</code> (<code>firebase-data.js:581-589</code>), which does a plain <code>.set({projects, lastUpdated, lastUpdatedBy})</code> on the whole <code>curriculum/futureProjects</code> document — no <code>arrayUnion</code>/<code>arrayRemove</code>, no merge-at-the-element-level. There is no <code>onSnapshot</code> listener on this document (confirmed — the only listeners in <code>firebase-data.js</code> are on <code>curriculum/lessonData</code> and <code>curriculum/appData</code>), so a tab's cached <code>currentFutureProjects</code> can go stale indefinitely with no self-correction.</p>
4026:    56	  <p><strong>Concrete failure:</strong> Admin A pastes idea X from the bank (a plain <code>.set()</code> of the post-removal array, same as every other writer here — NOT an atomic <code>arrayRemove()</code>, see the correction above). Admin B, in a separate tab with a snapshot loaded before A's removal propagated, archives, edits, deletes, or adds a <em>different</em> idea moments later — B's full-array overwrite silently resurrects X. <code>deleteIdeaProject()</code> is the direct sibling of the companion plan's already-fixed <code>deleteCutProject()</code> — same shape, same likely fix (<code>FieldValue.arrayRemove()</code>) — and <code>pasteFromIdeaBank()</code>'s own removal step is now effectively a second instance of that exact same sibling shape. <code>saveNewIdea()</code>/<code>saveIdeaEdit()</code> would need care: an "edit" mutates an existing array element in place, so the fix isn't a simple append/remove — it likely needs the element's stable identity (an id field, if one exists — check <code>app.js:5317</code>'s id-generation convention, already referenced elsewhere in the companion plan) to target a transaction or a keyed sub-collection instead of an in-array edit, since Firestore's array transforms can't update one element by identity — only add or remove whole elements.</p>
4036:    66	  <p><strong>Concrete failure:</strong> User A adds a class association to a project. User B, from a snapshot that hasn't received A's change, marks a different material complete and autosaves. Each autosave replaces the entire week map — B's later write can silently remove A's association; A's later write can revert B's material update. A live listener on this data narrows the window but doesn't make the read-modify-write atomic.</p>
4049:    79	  <p><strong>File:</strong> <code>js/app.js</code>, <code>handleGridAction()</code>'s move and swap branches, backed by <code>js/firebase-data.js</code>'s <code>saveMultipleLessonFields()</code> (a new helper added by the backtracking audit plan's Phase 9). <strong>A different shape from instances 1-5 above:</strong> those are all about a write that ISN'T atomic — a local read-modify-write racing against another admin's concurrent write to the same document. This instance is about a write that already IS atomic (one Firestore <code>.update()</code> call, guaranteed all-or-nothing by <code>saveMultipleLessonFields()</code>'s single-document design) but whose CONTENT can still be stale — <code>movedLesson</code>/<code>swappedSource</code>/<code>swappedDest</code> are built from a <code>currentLessonData</code> snapshot taken at grid-click time, with no freshness check before the atomic write fires.</p>
4054:rg -n \"settings-link|data-tab=\\\"settings\\\"|switchTab\\('settings'\\)|#settings|footer-dot\\.write-control|write-control\" css js index.html e2e --glob '"'!e2e/test-results/**'"'
4103:js/app.js:329:    document.querySelector('.tab-btn[data-tab="settings"]')?.style.setProperty('display', 'none');
4115:index.html:54:    <button class="tab-btn write-control active" data-tab="curriculum-admin">Curriculum Admin</button>
4116:index.html:57:    <button class="tab-btn write-control" data-tab="settings">Settings</button>
4122:e2e/day-off-camps.spec.js:344:      await page.click('.tab-btn[data-tab="settings"]');
4123:e2e/day-off-camps.spec.js:453:      await page.click('.tab-btn[data-tab="settings"]');
4126:e2e/day-off-camps.spec.js:473:      await page.click('.tab-btn[data-tab="settings"]');
4131:e2e/day-off-camps.spec.js:494:    await page.click('.tab-btn[data-tab="settings"]');
4136:e2e/day-off-camps.spec.js:504:    await page.click('.tab-btn[data-tab="settings"]');
4139:e2e/day-off-camps.spec.js:639:      await page.click('.tab-btn[data-tab="settings"]');
4173:    13	- **No other Tinker app reads `activeSemester`** ✓ — and I checked wider than the plan's list. The only cross-app reader of the `curriculum` collection is `studio-hub/js/alerts.js:562`, which reads `curriculum/lessonData` and iterates *all* semesters (`:573`), plus `summer-camp-app/scripts/backup-firestore.js:39` which just backs the collection up. Neither depends on the active flag. `summer-camp-app`'s `'curriculum'` (`js/app.js:85`, `js/config.js:63`) is its own tab/field name, not this collection.
4195:    35	**5. Phase 2 stores a time, not a target.** `activeSemesterSwitchAt` says "someone asked for a switch at T"; the browser then lands on whatever `activeSemester` is at load time. Sequence: Fall made active, ticked (T1) → before all browsers have loaded, someone makes Summer active, unticked → those browsers jump to Summer, which nobody asked to switch everyone to. Store `activeSemesterSwitchTo` alongside and apply only if it still equals `activeSemester`, or state the "go to whatever's active" semantics deliberately.
4216:    56	Missing: (a) a payload-keys assertion for the auto-publish case, in the house style `expect(Object.keys(payload).sort()).toEqual([...])` (`data-safety.spec.js:7610`); (b) "a second tab already open is unaffected until reload" — Phase 2 asserts this in prose, nothing tests it; (c) the manager who performs the switch is themselves subject to it on their next load; (d) a UI-level check that the button is absent for a non-manager (cheap — `setupRoleAccess` hides Settings at `app.js:328-329`); (e) `updateAppData` refusing because `seasonRegistryMode` is `error`/`unknown` (`firebase-data.js:221-223`) — a live failure mode of this exact button, and the one most likely to hit Christie mid-term-change.
4221:    61	- **Multiple tabs / shared devices / clock skew**: the design holds. Tabs are consistent because `globalSemesterKey` is shared localStorage; a shared studio device consumes the switch once and every subsequent user on it lands on the new semester anyway, which is what you want; the not-equal comparison does neutralise skew as claimed. Ordering relative to `app.js:65-70` is correct — pre-setting a visible key makes the condition at `:65` false, so it won't override you, and nothing reads `globalSemesterKey` between `app.js:13` and the call at `:158`. First load after deploy moves nobody (verified: nothing reads the field until it exists).
4225:## Verdict: NOT EXECUTION-READY
4229:### 1. Unticking “switch everyone” can reactivate an old switch
4231:Phase 2 says an unticked activation writes no `activeSemesterSwitch` ([plan:214](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:214>)). That leaves the previous switch record in Firestore.
4240:This violates “with it unticked, nobody’s remembered semester moves” ([plan:187](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:187>)).
4244:### 2. “Once per browser” does not mean “switch every user”
4258:### 3. Weekly deletion remains non-atomic and lacks the required snapshot
4268:The plan also says “No bulk op, no delete: no snapshot needed” ([plan:253](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:253>)), although Phase 1 explicitly deletes an entire semester lesson map. That conflicts with the repository’s snapshot-before-bulk-delete requirement.
4274:- Snapshot the forced-server lesson map and abort if the snapshot fails.
4279:### 4. Activation trusts stale local config and can create a ghost active semester
4294:### 5. The e2e plan contains two impossible/contradictory scenarios
4309:### Other checks
4313:- The proposed Settings hiding, `switchTab` refusal, role check in `makeSemesterActive`, and Firestore manager-only write rule are sufficient for normal UI access. For a literal “cannot enter the panel” invariant, also reject Settings inside the tab button’s own click handler at [app.js:203](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:203), not only through `switchTab`.
4317:## Verdict: NOT EXECUTION-READY
4321:### 1. Unticking “switch everyone” can reactivate an old switch
4323:Phase 2 says an unticked activation writes no `activeSemesterSwitch` ([plan:214](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:214>)). That leaves the previous switch record in Firestore.
4332:This violates “with it unticked, nobody’s remembered semester moves” ([plan:187](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:187>)).
4336:### 2. “Once per browser” does not mean “switch every user”
4350:### 3. Weekly deletion remains non-atomic and lacks the required snapshot
4360:The plan also says “No bulk op, no delete: no snapshot needed” ([plan:253](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:253>)), although Phase 1 explicitly deletes an entire semester lesson map. That conflicts with the repository’s snapshot-before-bulk-delete requirement.
4366:- Snapshot the forced-server lesson map and abort if the snapshot fails.
4371:### 4. Activation trusts stale local config and can create a ghost active semester
4386:### 5. The e2e plan contains two impossible/contradictory scenarios
4401:### Other checks
4405:- The proposed Settings hiding, `switchTab` refusal, role check in `makeSemesterActive`, and Firestore manager-only write rule are sufficient for normal UI access. For a literal “cannot enter the panel” invariant, also reject Settings inside the tab button’s own click handler at [app.js:203](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:203), not only through `switchTab`.
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

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/studio-hub/firestore.rules | sed -n '620,685p'; nl -ba js/firebase-data.js | sed -n '190,265p'; nl -ba js/firebase-data.js | sed -n '930,990p'; nl -ba js/firebase-data.js | sed -n '2425,2485p'; nl -ba js/app.js | sed -n '1,225p'; nl -ba js/auth-guard.js | sed -n '1,125p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
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
   261	  }
   262	  if (type === SEMESTER_TYPES.weekly) {
   263	    return {
   264	      [p('name')]: values.name,
   265	      [p('startDate')]: values.startDate,
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
  2425	  // to other fields survive). Compare against the original in the CURRENT
  2426	  // shape: a camp stored as lists of titles (the first deploy) must not look
  2427	  // "changed" just because the editor now speaks blocks.
  2428	  const originalForDiff = { ...original, projects: Object.fromEntries((original.dates || []).map(d => [d, normaliseDayOffDayBlocks(original.projects?.[d])])) };
  2429	  const updates = dayOffUpdateFields(originalForDiff, next, DAY_OFF_CAMP_FIELDS);
  2430	  if (Object.keys(updates).length === 0) return original;
  2431	
  2432	  // Renames are moves (Phase 2A): a leaving title pairs with an arriving one
  2433	  // that occupies exactly the same day/block cells. Unpaired leaving titles
  2434	  // are removals — asked about here, OUTSIDE the transaction (it may retry).
  2435	  const pairs = 'projects' in updates || 'dates' in updates ? dayOffRenamePairs(originalForDiff, next) : [];
  2436	  const moved = new Set(pairs.map(p => p.from));
  2437	  if ('projects' in updates || 'dates' in updates) {
  2438	    const after = new Set(dayOffCampTitles(next).keys());
  2439	    const leaving = [...dayOffCampTitles(originalForDiff).keys()].filter(t => !after.has(t) && !moved.has(t));
  2440	    if (leaving.length) {
  2441	      const orphaned = await countDayOffPlansWithUserData(yearKey, original.id, leaving);
  2442	      if (orphaned.length && !(await confirmOrphans(orphaned))) return { cancelled: true };
  2443	    }
  2444	  }
  2445	  const clearsSignoff = ['projects', 'dates', 'placements'].some(f => f in updates);
  2446	  const campRef = coll.doc(original.id);
  2447	  const plansColl = curriculumDb.collection(DAY_OFF_COLLECTIONS.plans);
  2448	  const moveRefs = pairs.map(p => ({ ...p, fromRef: plansColl.doc(dayOffPlanDocId(yearKey, original.id, p.from)), toRef: plansColl.doc(dayOffPlanDocId(yearKey, original.id, p.to)) }));
  2449	  const signoffRef = plansColl.doc(dayOffSignoffDocId(yearKey, original.id));
  2450	  const movedData = {};
  2451	
  2452	  await curriculumDb.runTransaction(async (tx) => {
  2453	    // Every read before any write.
  2454	    const campSnap = await tx.get(campRef);
  2455	    const moveSnaps = [];
  2456	    for (const m of moveRefs) moveSnaps.push([await tx.get(m.fromRef), await tx.get(m.toRef)]);
  2457	    const signoffSnap = clearsSignoff ? await tx.get(signoffRef) : null;
  2458	    if (!campSnap.exists) throw new DayOffValidationError(['This camp was removed in another tab — reload before editing it.']);
  2459	    // Stale-editor guard: a whole field this save replaces must still be what
  2460	    // the editor opened with (raw, not shape-normalised), or another tab's
  2461	    // newer value would be overwritten.
  2462	    const server = campSnap.data();
  2463	    for (const f of ['projects', 'placements', 'dates', 'teachers']) {
  2464	      if (f in updates && stableJson(server[f] ?? null) !== stableJson(original[f] ?? null)) {
  2465	        throw new DayOffValidationError(['This camp was changed in another tab since you opened it — close the editor, reopen the camp and make your change again.']);
  2466	      }
  2467	    }
  2468	    moveRefs.forEach((m, i) => {
  2469	      const [fromSnap, toSnap] = moveSnaps[i];
  2470	      if (toSnap.exists && dayOffPlanHasUserData(toSnap.data())) {
  2471	        throw new DayOffValidationError([`"${m.to}" already has a list or plan in this camp — rename to a different title, or clean up the leftover one first.`]);
  2472	      }
  2473	    });
  2474	    tx.update(campRef, { ...updates, ...dayOffStamp('updated') });
  2475	    moveRefs.forEach((m, i) => {
  2476	      const [fromSnap, toSnap] = moveSnaps[i];
  2477	      if (fromSnap.exists) {
  2478	        const data = { ...fromSnap.data(), projectTitle: m.to };
  2479	        tx.set(m.toRef, data);
  2480	        tx.delete(m.fromRef);
  2481	        movedData[m.to] = data;
  2482	      } else if (toSnap.exists) {
  2483	        tx.delete(m.toRef);   // an empty leftover under the new title — replaced by nothing
  2484	      }
  2485	    });
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
   221	        ensureSettingsFormMatchesHeader();
   222	      }
   223	      if (tabId === 'settings' && lastDiagFingerprint) {
   224	        // Scroll back to the diagnostic item we came from
   225	        setTimeout(() => {
     1	// =====================================================
     2	// Shared Auth Guard — Tinker HQ Apps
     3	// =====================================================
     4	// Copy this file into any app that needs login protection.
     5	// Requires: firebase-config.js loaded first, Firebase SDK in HTML.
     6	//
     7	// Usage in your app's init:
     8	//   const user = await requireAuth();
     9	//   if (!user) return; // auth guard is showing login screen
    10	//   // ... continue loading your app
    11	//
    12	// HTML required: Add this overlay div at the top of <body>:
    13	//   <div id="auth-guard" class="auth-guard">
    14	//     <div class="auth-guard-content">
    15	//       <img src="assets/logo.png" alt="Tinker Art Studio" class="auth-logo">
    16	//       <h2>Sign In Required</h2>
    17	//       <p>You need to be signed in to use this app.</p>
    18	//       <form id="auth-guard-form" class="auth-guard-form">
    19	//         <input type="email" id="auth-email" placeholder="Email" required>
    20	//         <input type="password" id="auth-password" placeholder="Password" required>
    21	//         <button type="submit" class="btn btn-primary">Sign In</button>
    22	//         <p id="auth-error" class="error-message"></p>
    23	//       </form>
    24	//       <p class="auth-help">Need access? Contact your administrator.</p>
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

codex
The rules permit manager writes to both transaction documents. I’m now checking the subtler race: `lessonData` is a shared, frequently updated document, and revision 4’s delete transaction description may not actually read it inside the transaction. That distinction determines whether Firestore retries on concurrent lesson saves.
exec
/bin/zsh -lc "rg -n \"function (save|update).*Lesson|async function (save|update).*Lesson|lessonData.*update|doc\\('lessonData'\\).*update|setupLessonDataListener|onSnapshot\" js/firebase-data.js js/app.js | head -n 160; rg -n \"currentCutProjects|currentChange|changeLog|cutProjects|prepData|backup\" js/firebase-data.js js/app.js | head -n 260" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
js/firebase-data.js:352:// onSnapshot never errors when offline and, with cache-only snapshots skipped,
js/firebase-data.js:461:    currentSeasonDocRef().onSnapshot({ includeMetadataChanges: true }, next, error));
js/firebase-data.js:525:    .onSnapshot(doc => {
js/firebase-data.js:601:    .onSnapshot(doc => {
js/firebase-data.js:802:async function saveLessonData(semesterKey, lessons) {
js/firebase-data.js:830:  await curriculumDb.collection('curriculum').doc('lessonData').update({
js/firebase-data.js:837:async function saveSummerCampLessonData(semKey, lessons) {
js/firebase-data.js:963:  await curriculumDb.collection('curriculum').doc('lessonData').update({
js/firebase-data.js:1083:// generation counter is module-scoped across every setupLessonDataListener()
js/firebase-data.js:1102:// Set by setupLessonDataListener() so a season-registry mode change (legacy →
js/firebase-data.js:1112:function setupLessonDataListener(callback) {
js/firebase-data.js:1172:    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
js/firebase-data.js:1323:// distinction setupLessonDataListener already makes for snapshots, above).
js/firebase-data.js:1364:async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
js/firebase-data.js:1436:  console.log('💾 Saving to curriculum/lessonData with per-field paths:', Object.keys(updates));
js/firebase-data.js:1438:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
js/firebase-data.js:1475:async function saveMultipleLessonFields(semesterKey, writes = [], deletes = []) {
js/firebase-data.js:1500:  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
js/app.js:676:  setupLessonDataListener((data) => {
js/app.js:3440:async function saveTeacherEdit(lessonKey, originalLesson) {
js/app.js:3690:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
js/app.js:5038:  setupLessonDataListener((data) => {
js/firebase-data.js:6://   curriculum/prepData    — prep team data by semester/week
js/firebase-data.js:8://   curriculum/cutProjects — projects removed from schedule, saved for reuse
js/firebase-data.js:9://   curriculum/changeLog   — audit trail of moves/swaps/cuts
js/firebase-data.js:13:let prepDataUnsubscribe = null;
js/firebase-data.js:129:let currentCutProjects = null;
js/firebase-data.js:130:let currentChangeLog = null;
js/firebase-data.js:533:// ─── Prep Data (curriculum/prepData) ─────────────────
js/firebase-data.js:538:    const doc = await curriculumDb.collection('curriculum').doc('prepData').get();
js/firebase-data.js:560:  const docRef = curriculumDb.collection('curriculum').doc('prepData');
js/firebase-data.js:579:  const docRef = curriculumDb.collection('curriculum').doc('prepData');
js/firebase-data.js:599:  if (prepDataUnsubscribe) prepDataUnsubscribe();
js/firebase-data.js:600:  prepDataUnsubscribe = curriculumDb.collection('curriculum').doc('prepData')
js/firebase-data.js:979:async function backupLessonData(semesterKey) {
js/firebase-data.js:985:  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
js/firebase-data.js:987:    backupDate: new Date().toISOString(),
js/firebase-data.js:988:    backupBy: user?.name || 'Unknown'
js/firebase-data.js:995:  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
js/firebase-data.js:996:  if (!backupDoc.exists) return null;
js/firebase-data.js:997:  const backupData = backupDoc.data();
js/firebase-data.js:998:  const lessons = backupData?.[semesterKey];
js/firebase-data.js:1198:// ─── Cut Projects (curriculum/cutProjects) ───────────
js/firebase-data.js:1203:    const doc = await curriculumDb.collection('curriculum').doc('cutProjects').get();
js/firebase-data.js:1204:    currentCutProjects = doc.exists ? doc.data() : {};
js/firebase-data.js:1207:    currentCutProjects = {};
js/firebase-data.js:1209:  return currentCutProjects;
js/firebase-data.js:1215:  await curriculumDb.collection('curriculum').doc('cutProjects').set({
js/firebase-data.js:1247:// ─── Change Log (curriculum/changeLog) ───────────────
js/firebase-data.js:1252:    const doc = await curriculumDb.collection('curriculum').doc('changeLog').get();
js/firebase-data.js:1253:    currentChangeLog = doc.exists ? doc.data() : {};
js/firebase-data.js:1256:    currentChangeLog = {};
js/firebase-data.js:1258:  return currentChangeLog;
js/firebase-data.js:1262:// call site benefits. This function mutates the local currentChangeLog array
js/firebase-data.js:1273:  if (!currentChangeLog) currentChangeLog = {};
js/firebase-data.js:1274:  if (!currentChangeLog[semesterKey]) currentChangeLog[semesterKey] = [];
js/firebase-data.js:1275:  currentChangeLog[semesterKey] = [...currentChangeLog[semesterKey], entry];
js/firebase-data.js:1277:    await curriculumDb.collection('curriculum').doc('changeLog').set({
js/firebase-data.js:1281:    currentChangeLog[semesterKey] = currentChangeLog[semesterKey].filter(e => e !== entry);
js/app.js:5020:  if (!currentChangeLog) await loadChangeLog();
js/app.js:5021:  if (!currentCutProjects) await loadCutProjects();
js/app.js:6262:// against curriculum/cutProjects (not saveCutProjects()'s local-splice-then-
js/app.js:6309:    await curriculumDb.collection('curriculum').doc('cutProjects').set({
js/app.js:6333:  if (!currentCutProjects) currentCutProjects = {};
js/app.js:6334:  currentCutProjects[semKey] = [...(currentCutProjects[semKey] || []), archiveEntry];
js/app.js:6358:  const cutProjects = currentCutProjects?.[semKey] || [];
js/app.js:6362:  for (const [key, projects] of Object.entries(currentCutProjects || {})) {
js/app.js:6370:  const totalCuts = cutProjects.length + otherSemesters.reduce((sum, s) => sum + s.projects.length, 0);
js/app.js:6381:  if (cutProjects.length > 0) {
js/app.js:6383:    cutProjects.forEach((proj, idx) => {
js/app.js:6431:  const cutProjects = currentCutProjects?.[srcSemKey] || [];
js/app.js:6432:  const proj = cutProjects[cutIndex];
js/app.js:6500:    await curriculumDb.collection('curriculum').doc('cutProjects').set({
js/app.js:6503:    if (currentCutProjects?.[srcSemKey]) {
js/app.js:6504:      currentCutProjects[srcSemKey] = currentCutProjects[srcSemKey].filter(p => p !== proj);
js/app.js:6532:  const cutProjects = currentCutProjects?.[semKey] || [];
js/app.js:6537:  if (cutProjects.length === 0) {
js/app.js:6543:  badge.textContent = cutProjects.length;
js/app.js:6547:  cutProjects.forEach((proj, idx) => {
js/app.js:6601:// Backtracking audit, Phase 8: a third live writer of curriculum/cutProjects,
js/app.js:6610:  const cutProjects = currentCutProjects?.[semKey] || [];
js/app.js:6611:  const proj = cutProjects[idx];
js/app.js:6615:  // ordering in this same commit. There's no live listener on cutProjects, so mutating
js/app.js:6622:    await curriculumDb.collection('curriculum').doc('cutProjects').set({
js/app.js:6631:  if (!currentCutProjects) currentCutProjects = {};
js/app.js:6632:  currentCutProjects[semKey] = cutProjects.filter((_, i) => i !== idx);
js/app.js:6638:  const cutProjects = currentCutProjects?.[semKey] || [];
js/app.js:6639:  if (cutProjects.length === 0) { alert('No cut projects to export.'); return; }
js/app.js:6642:  for (const proj of cutProjects) {
js/app.js:7312:  if (!currentChangeLog) await loadChangeLog();
js/app.js:7313:  const entries = currentChangeLog?.[semKey] || [];
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
js/app.js:8478:function renderWeekContent(items, prepData, weekNum) {
js/app.js:8493:    if (prepData.items?.[item.key]?.isComplete) completedMaterials++;
js/app.js:8503:      <textarea id="prep-week-notes" class="prep-week-notes" placeholder="Week notes — jot down anything your prep team needs to remember this week..." rows="3">${escHtml(prepData.notes || '')}</textarea>
js/app.js:8518:  if (prepData.lastUpdatedBy) {
js/app.js:8519:    const time = prepData.lastUpdated ? new Date(prepData.lastUpdated).toLocaleString() : '';
js/app.js:8520:    html += `<div class="prep-last-updated">Last updated by ${escHtml(prepData.lastUpdatedBy)} ${time ? 'at ' + time : ''}</div>`;
js/app.js:8623:          const pd = prepData.items?.[mat.key] || {};
js/app.js:9005:function renderPrepCalculator(items, prepData) {
js/app.js:9035:  const selectedClasses = prepData.calculator?.selectedClasses || [];
js/app.js:9245:async function renderTodayView(items, prepData, weekNum) {
js/app.js:9691:function renderProjectView(items, prepData, weekNum) {
js/app.js:9710:    if (prepData.items?.[item.key]?.isComplete) completedMaterials++;
js/app.js:9719:      <textarea id="prep-week-notes" class="prep-week-notes" placeholder="Week notes — jot down anything your prep team needs to remember this week..." rows="3">${escHtml(prepData.notes || '')}</textarea>
js/app.js:9733:  if (prepData.lastUpdatedBy) {
js/app.js:9734:    const time = prepData.lastUpdated ? new Date(prepData.lastUpdated).toLocaleString() : '';
js/app.js:9735:    html += `<div class="prep-last-updated">Last updated by ${escHtml(prepData.lastUpdatedBy)} ${time ? 'at ' + time : ''}</div>`;
js/app.js:9756:    const associations = prepData.classAssociations?.[normTitleForAssoc] || [];
js/app.js:9864:        const pd = prepData.items?.[mat.key] || {};
js/app.js:9931:function mergeManualItems(sheetItems, prepData) {
js/app.js:9932:  const manual = prepData?.manualItems || {};
js/app.js:10892:      + `\n\nRun a backup (backup.js --force) before pressing Stamp.`);

exec
/bin/zsh -lc "nl -ba js/firebase-data.js | sed -n '525,620p'; nl -ba js/firebase-data.js | sed -n '790,850p'; nl -ba js/firebase-data.js | sed -n '1100,1300p'; nl -ba js/firebase-data.js | sed -n '1350,1510p'; nl -ba js/app.js | sed -n '665,690p'; nl -ba js/app.js | sed -n '4470,4635p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
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
   536	  if (!curriculumDb) initCurriculumFirestore();
   537	  try {
   538	    const doc = await curriculumDb.collection('curriculum').doc('prepData').get();
   539	    if (doc.exists) {
   540	      currentPrepData = doc.data();
   541	    } else {
   542	      currentPrepData = {};
   543	    }
   544	  } catch (err) {
   545	    console.error('Error loading prep data:', err);
   546	    currentPrepData = {};
   547	  }
   548	  return currentPrepData;
   549	}
   550	
   551	async function savePrepWeekData(semesterKey, weekKey, weekData) {
   552	  if (!curriculumDb) initCurriculumFirestore();
   553	  const user = getAuthUser();
   554	  weekData.lastUpdated = new Date().toISOString();
   555	  weekData.lastUpdatedBy = user?.name || 'Unknown';
   556	
   557	  const updateObj = {};
   558	  updateObj[`${semesterKey}.${weekKey}`] = weekData;
   559	
   560	  const docRef = curriculumDb.collection('curriculum').doc('prepData');
   561	  try {
   562	    await docRef.update(updateObj);
   563	  } catch (err) {
   564	    if (err.code === 'not-found') {
   565	      const nested = {};
   566	      nested[semesterKey] = {};
   567	      nested[semesterKey][weekKey] = weekData;
   568	      await docRef.set(nested);
   569	    } else {
   570	      throw err;
   571	    }
   572	  }
   573	}
   574	
   575	async function saveForecastDismissals(semesterKey, dismissals) {
   576	  if (!curriculumDb) initCurriculumFirestore();
   577	  const updateObj = {};
   578	  updateObj[`${semesterKey}.forecastDismissed`] = dismissals;
   579	  const docRef = curriculumDb.collection('curriculum').doc('prepData');
   580	  try {
   581	    await docRef.update(updateObj);
   582	  } catch (err) {
   583	    if (err.code === 'not-found') {
   584	      const nested = {};
   585	      nested[semesterKey] = { forecastDismissed: dismissals };
   586	      await docRef.set(nested);
   587	    } else {
   588	      throw err;
   589	    }
   590	  }
   591	}
   592	
   593	function getForecastDismissals(semesterKey) {
   594	  return currentPrepData?.[semesterKey]?.forecastDismissed || {};
   595	}
   596	
   597	function setupPrepDataListener(callback) {
   598	  if (!curriculumDb) initCurriculumFirestore();
   599	  if (prepDataUnsubscribe) prepDataUnsubscribe();
   600	  prepDataUnsubscribe = curriculumDb.collection('curriculum').doc('prepData')
   601	    .onSnapshot(doc => {
   602	      if (doc.exists) {
   603	        currentPrepData = doc.data();
   604	        if (callback) callback(currentPrepData);
   605	      }
   606	    });
   607	}
   608	
   609	// ─── Prep Cycle Config (curriculum/prepCycleConfig) ──
   610	
   611	const DEFAULT_PREP_CYCLE_CONFIG = {
   612	  phases: [
   613	    {
   614	      id: 'monitor-plan',
   615	      name: 'Monitor & Plan',
   616	      emoji: '📋',
   617	      days: ['Monday', 'Thursday'],
   618	      description: 'Check on Thurs for Friday and Monday; make action plan on Mon for Tues.',
   619	      goals: [
   620	        'Prioritized prep task list ready for Tuesday morning',
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
  1216	    [semesterKey]: projects,
  1217	    lastUpdated: new Date().toISOString(),
  1218	    lastUpdatedBy: user?.name || 'Unknown'
  1219	  }, { merge: true });
  1220	}
  1221	
  1222	// ─── Future Projects / Idea Bank (curriculum/futureProjects) ──
  1223	
  1224	async function loadFutureProjects() {
  1225	  if (!curriculumDb) initCurriculumFirestore();
  1226	  try {
  1227	    const doc = await curriculumDb.collection('curriculum').doc('futureProjects').get();
  1228	    currentFutureProjects = doc.exists ? doc.data() : { projects: [] };
  1229	  } catch (err) {
  1230	    console.error('Error loading future projects:', err);
  1231	    currentFutureProjects = { projects: [] };
  1232	  }
  1233	  return currentFutureProjects;
  1234	}
  1235	
  1236	async function saveFutureProjects(projects) {
  1237	  if (!curriculumDb) initCurriculumFirestore();
  1238	  const user = getAuthUser();
  1239	  await curriculumDb.collection('curriculum').doc('futureProjects').set({
  1240	    projects: projects,
  1241	    lastUpdated: new Date().toISOString(),
  1242	    lastUpdatedBy: user?.name || 'Unknown'
  1243	  });
  1244	  currentFutureProjects = { projects };
  1245	}
  1246	
  1247	// ─── Change Log (curriculum/changeLog) ───────────────
  1248	
  1249	async function loadChangeLog() {
  1250	  if (!curriculumDb) initCurriculumFirestore();
  1251	  try {
  1252	    const doc = await curriculumDb.collection('curriculum').doc('changeLog').get();
  1253	    currentChangeLog = doc.exists ? doc.data() : {};
  1254	  } catch (err) {
  1255	    console.error('Error loading change log:', err);
  1256	    currentChangeLog = {};
  1257	  }
  1258	  return currentChangeLog;
  1259	}
  1260	
  1261	// Backtracking audit, Phase 8 (R3-18): fixed once, at the source — every
  1262	// call site benefits. This function mutates the local currentChangeLog array
  1263	// synchronously BEFORE its own Firestore await (so a caller's immediate
  1264	// renderChangeHistory() sees the new entry) — R2-13 already added a re-render
  1265	// on SUCCESS; this adds the missing FAILURE-path rollback, removing the
  1266	// optimistic entry and rethrowing so the caller's own catch still sees it.
  1267	async function appendChangeLogEntry(semesterKey, entry) {
  1268	  if (!curriculumDb) initCurriculumFirestore();
  1269	  const user = getAuthUser();
  1270	  entry.timestamp = new Date().toISOString();
  1271	  entry.by = user?.name || 'Unknown';
  1272	  // Update local cache immediately so renderChangeHistory reflects the change
  1273	  if (!currentChangeLog) currentChangeLog = {};
  1274	  if (!currentChangeLog[semesterKey]) currentChangeLog[semesterKey] = [];
  1275	  currentChangeLog[semesterKey] = [...currentChangeLog[semesterKey], entry];
  1276	  try {
  1277	    await curriculumDb.collection('curriculum').doc('changeLog').set({
  1278	      [semesterKey]: firebase.firestore.FieldValue.arrayUnion(entry)
  1279	    }, { merge: true });
  1280	  } catch (err) {
  1281	    currentChangeLog[semesterKey] = currentChangeLog[semesterKey].filter(e => e !== entry);
  1282	    throw err;
  1283	  }
  1284	}
  1285	
  1286	// ─── Diagnostic Dismissals (curriculum/diagnosticDismissals) ──
  1287	
  1288	let currentDiagDismissals = null;
  1289	
  1290	async function loadDiagDismissals() {
  1291	  if (!curriculumDb) initCurriculumFirestore();
  1292	  try {
  1293	    const doc = await curriculumDb.collection('curriculum').doc('diagnosticDismissals').get();
  1294	    currentDiagDismissals = doc.exists ? doc.data() : {};
  1295	  } catch (err) {
  1296	    console.error('Error loading diagnostic dismissals:', err);
  1297	    currentDiagDismissals = {};
  1298	  }
  1299	  return currentDiagDismissals;
  1300	}
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
   665	  // Not "initialized": the guard can trip transiently now (a listener reload
   666	  // that fails and self-heals — Backtracking audit Phase 7), and the next
   667	  // visit to this tab must be allowed to build it.
   668	  if (lessonDataLoadedSuccessfully === false) {
   669	    tvInitialized = false;
   670	    document.getElementById('lesson-load-error-banner')?.classList.remove('hidden');
   671	    return;
   672	  }
   673	
   674	  // Set up real-time listener FIRST so the retry mechanism fires even if
   675	  // summer camp data isn't ready yet when we reach the early-return below.
   676	  setupLessonDataListener((data) => {
   677	    currentLessonData = data;
   678	    renderProgressDashboard();
   679	    // SDOC (Phase 2B): a camp with only empty blocks has no slots, and there is
   680	    // no sharedWith — so re-render on every reload while the year is showing
   681	    // (the list and the teacher picker are rebuilt from the camps each time).
   682	    if (isDayOffYear(getTvSemKey())) {
   683	      if (document.querySelector('.tab-btn.active')?.dataset.tab === 'teacher-view') renderTeacherView();
   684	      renderTeacherMappingTable();
   685	      return;
   686	    }
   687	    // If teacher view initialized early without data, reset so it re-runs with the now-loaded data
   688	    const semKey = getTvSemKey();
   689	    const lessons = currentLessonData?.[semKey];
   690	    if (lessons && Object.keys(lessons).length > 0 && tvInitialized && isAdminOrManager()) {
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

exec
/bin/zsh -lc "rg -n \"\\[semesterKey\\]|\\[semKey\\]|\\"'$'"\\{semesterKey\\}|\\"'$'"\\{semKey\\}\" js/firebase-data.js js/app.js | rg \"doc\\('|current[A-Z]|Dismiss|prep|backup|semester|change|cut\" | head -n 300; rg -n \"diagnosticDismissals|saveDiag|dismissals\\[|currentDiag\" js/firebase-data.js js/app.js" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
js/firebase-data.js:46:  const stored = currentConfig?.semesters?.[semKey]?.semesterType;
js/firebase-data.js:114:  const stored = currentConfig?.semesters?.[semKey]?.season;
js/firebase-data.js:139:function summerSessionsFor(semKey) { return currentSummerSessionsBySemester[semKey] || NO_SUMMER_SESSIONS; }
js/firebase-data.js:256:  const type = (semesters || currentConfig?.semesters)?.[semKey]?.semesterType
js/firebase-data.js:566:      nested[semesterKey] = {};
js/firebase-data.js:567:      nested[semesterKey][weekKey] = weekData;
js/firebase-data.js:585:      nested[semesterKey] = { forecastDismissed: dismissals };
js/firebase-data.js:594:  return currentPrepData?.[semesterKey]?.forecastDismissed || {};
js/firebase-data.js:818:    [semesterKey]: lessons,
js/firebase-data.js:964:    [semesterKey]: firebase.firestore.FieldValue.delete()
js/firebase-data.js:976:  return snap.exists ? (snap.data()?.[semesterKey] ?? null) : null;
js/firebase-data.js:981:  const existing = currentLessonData?.[semesterKey];
js/firebase-data.js:986:    [semesterKey]: existing,
js/firebase-data.js:998:  const lessons = backupData?.[semesterKey];
js/firebase-data.js:1097:    if ((isCampSeason(semKey) || isDayOffYear(semKey)) && currentLessonData[semKey]) out[semKey] = currentLessonData[semKey];
js/firebase-data.js:1187:      for (const [semKey, map] of Object.entries(previousSummer)) currentLessonData[semKey] = map;
js/firebase-data.js:1216:    [semesterKey]: projects,
js/firebase-data.js:1274:  if (!currentChangeLog[semesterKey]) currentChangeLog[semesterKey] = [];
js/firebase-data.js:1275:  currentChangeLog[semesterKey] = [...currentChangeLog[semesterKey], entry];
js/firebase-data.js:1278:      [semesterKey]: firebase.firestore.FieldValue.arrayUnion(entry)
js/firebase-data.js:1281:    currentChangeLog[semesterKey] = currentChangeLog[semesterKey].filter(e => e !== entry);
js/app.js:305:  const semester = currentConfig?.semesters?.[semKey];
js/app.js:393:  const lessons = currentLessonData?.[semKey];
js/app.js:537:  const lessons = currentLessonData?.[semKey];
js/app.js:644:  const lessons = currentLessonData?.[semKey];
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
js/app.js:1610:  const semester = currentConfig?.semesters?.[semKey];
js/app.js:1826:  renderSummerCampView(document.getElementById('tv-content'), currentLessonData?.[semKey]);
js/app.js:1831:  const semester = currentConfig?.semesters?.[semKey];
js/app.js:2292:      const lessons = currentLessonData?.[semKey];
js/app.js:2350:      const liveLesson = () => currentLessonData?.[semKey]?.[lessonKey];
js/app.js:2451:  const semester = currentConfig?.semesters?.[semKey] || getActiveSemester();
js/app.js:2835:      const lessons = currentLessonData?.[semKey];
js/app.js:2870:      const lessons = currentLessonData?.[semKey];
js/app.js:2964:  const lessons = currentLessonData?.[semKey];
js/app.js:3059:  const lessons = currentLessonData?.[semKey];
js/app.js:3544:    if (currentLessonData[semKey]) {
js/app.js:3545:      currentLessonData[semKey][lessonKey] = updatedLesson;
js/app.js:3704:  if (currentLessonData?.[semKey]?.[lessonKey]) {
js/app.js:3705:    const cached = currentLessonData[semKey][lessonKey];
js/app.js:3708:    currentLessonData[semKey][lessonKey] = {
js/app.js:3773:  const lessons = currentLessonData?.[semKey];
js/app.js:3919:  const lessons = currentLessonData?.[semKey];
js/app.js:4121:  const lesson = currentLessonData?.[semKey]?.[key];
js/app.js:4175:  const sem = currentConfig?.semesters?.[semKey] || {};
js/app.js:5050:  const lessons = currentLessonData?.[semKey];
js/app.js:5066:  const semester = currentConfig?.semesters?.[semKey] || getActiveSemester();
js/app.js:5227:  const lessons = currentLessonData?.[semKey];
js/app.js:5519:  const lesson = currentLessonData?.[semKey]?.[key] || null;
js/app.js:5589:  const lessons = { ...(currentLessonData?.[semKey] || {}) };
js/app.js:5791:  currentLessonData[semKey] = lessons;
js/app.js:5869:  if (!currentLessonData[semKey]) currentLessonData[semKey] = {};
js/app.js:5870:  currentLessonData[semKey][sourceKey] = sourceLesson;
js/app.js:5872:    currentLessonData[semKey][destKey] = destLesson;
js/app.js:5874:    delete currentLessonData[semKey][destKey];
js/app.js:5881:  const lessons = { ...currentLessonData[semKey] };
js/app.js:5923:    currentLessonData[semKey] = lessons;
js/app.js:6008:      currentLessonData[semKey] = lessons;
js/app.js:6034:      currentLessonData[semKey] = lessons;
js/app.js:6087:  const lessons = currentLessonData?.[semKey];
js/app.js:6157:  const liveLessons = currentLessonData?.[semKey];
js/app.js:6200:      if (currentLessonData[semKey]) currentLessonData[semKey][targetKey] = updatedTarget;
js/app.js:6268:  const lessons = { ...currentLessonData[semKey] };
js/app.js:6284:    if (currentLessonData[semKey]) delete currentLessonData[semKey][key];
js/app.js:6331:    currentLessonData[semKey] = lessons;
js/app.js:6334:  currentCutProjects[semKey] = [...(currentCutProjects[semKey] || []), archiveEntry];
js/app.js:6358:  const cutProjects = currentCutProjects?.[semKey] || [];
js/app.js:6532:  const cutProjects = currentCutProjects?.[semKey] || [];
js/app.js:6610:  const cutProjects = currentCutProjects?.[semKey] || [];
js/app.js:6632:  currentCutProjects[semKey] = cutProjects.filter((_, i) => i !== idx);
js/app.js:6638:  const cutProjects = currentCutProjects?.[semKey] || [];
js/app.js:6908:  const existingLesson = currentLessonData?.[semKey]?.[key] || {};
js/app.js:6950:    if (currentLessonData[semKey]) currentLessonData[semKey][key] = newLesson;
js/app.js:7028:  const lessons = currentLessonData?.[semKey];
js/app.js:7160:  const cachedExisting = currentLessonData?.[semKey]?.[key];
js/app.js:7212:  currentLessonData[semKey][key] = {
js/app.js:7245:  const cachedExisting = currentLessonData?.[semKey]?.[key];
js/app.js:7299:  currentLessonData[semKey][key] = updatedLesson;
js/app.js:7313:  const entries = currentChangeLog?.[semKey] || [];
js/app.js:7629:  const lessons = currentLessonData?.[semKey];
js/app.js:7947:  const lessons = currentLessonData?.[semKey];
js/app.js:7955:  const currentSemester = currentConfig?.semesters?.[semKey];
js/app.js:8063:  currentWeekPrepData = currentPrepData?.[semKey]?.[weekKey] || { items: {}, calculator: {} };
js/app.js:8360:  const lessons = currentLessonData?.[semKey];
js/app.js:10210:  const lessons = currentLessonData?.[semKey];
js/app.js:10408:  const semDismissals = dismissals[semKey] || {};
js/app.js:10693:  const semester = config.semesters?.[semKey] || {};
js/app.js:10787:  const sem = currentConfig?.semesters?.[semKey];
js/app.js:10964:  const semester = currentConfig?.semesters?.[semKey] || {};
js/app.js:10980:  currentConfig.semesters[semKey].teacherNames = currentNames;
js/app.js:10983:  currentConfig.semesters[semKey].teacherNames.push('');
js/app.js:10996:  currentConfig.semesters[semKey].teacherNames = currentNames;
js/app.js:10999:  currentConfig.semesters[semKey].teacherNames.splice(idx, 1);
js/app.js:11020:  const semester = currentConfig?.semesters?.[semKey] || {};
js/app.js:11082:  const semester = currentConfig?.semesters?.[semKey] || {};
js/app.js:11116:  const lessons = currentLessonData?.[semKey] || {};
js/app.js:11273:      const serverPool = (await readAppDataFromServer())?.semesters?.[semKey]?.teacherNames || [];
js/app.js:11280:        currentConfig.semesters[semKey].teacherNames = [...teacherNames, ...inUse.map(u => u.name).filter(n => !teacherNames.includes(n))];
js/app.js:11306:  config.semesters[semKey] = { ...(config.semesters[semKey] || {}) };
js/app.js:11308:    config.semesters[semKey][path.split('.').pop()] = value;
js/app.js:11331:    currentConfig.semesters[semKey] = currentConfig.semesters[semKey] || {};
js/app.js:11333:      currentConfig.semesters[semKey][path.split('.').pop()] = value;
js/app.js:11339:    await createLessonSlotsForRoster(semKey, classRoster, config.semesters[semKey].numWeeks);
js/app.js:11383:  // persistence succeeds — previously `currentLessonData[semKey] = {}` was
js/app.js:11386:  const lessons = { ...(currentLessonData[semKey] || {}) };
js/app.js:11429:    currentLessonData[semKey] = lessons; // only commit locally after Firestore confirms
js/app.js:11467:  const lessons = currentLessonData?.[semKey];
js/app.js:11512:  let lesson = currentLessonData?.[semKey]?.[lessonKey];
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
js/firebase-data.js:1286:// ─── Diagnostic Dismissals (curriculum/diagnosticDismissals) ──
js/firebase-data.js:1288:let currentDiagDismissals = null;
js/firebase-data.js:1293:    const doc = await curriculumDb.collection('curriculum').doc('diagnosticDismissals').get();
js/firebase-data.js:1294:    currentDiagDismissals = doc.exists ? doc.data() : {};
js/firebase-data.js:1297:    currentDiagDismissals = {};
js/firebase-data.js:1299:  return currentDiagDismissals;
js/firebase-data.js:1302:async function saveDiagDismissals(dismissals) {
js/firebase-data.js:1308:    await curriculumDb.collection('curriculum').doc('diagnosticDismissals').set(dismissals);
js/firebase-data.js:1309:    currentDiagDismissals = dismissals;
js/app.js:10407:  const dismissals = currentDiagDismissals || {};
js/app.js:10408:  const semDismissals = dismissals[semKey] || {};
js/app.js:10534:        const dismissals = currentDiagDismissals || {};
js/app.js:10535:        if (!dismissals[semKey]) dismissals[semKey] = {};
js/app.js:10536:        const existing = dismissals[semKey][fp] || {};
js/app.js:10537:        dismissals[semKey][fp] = { ...existing, at: new Date().toISOString(), by: getAuthUser()?.name || 'Unknown' };
js/app.js:10538:        await saveDiagDismissals(dismissals);
js/app.js:10552:        const dismissals = currentDiagDismissals || {};
js/app.js:10553:        if (dismissals[semKey] && dismissals[semKey][fp]) {
js/app.js:10554:          const entry = dismissals[semKey][fp];
js/app.js:10558:            delete dismissals[semKey][fp];
js/app.js:10560:          await saveDiagDismissals(dismissals);
js/app.js:10595:        const dismissals = currentDiagDismissals || {};
js/app.js:10596:        if (!dismissals[semKey]) dismissals[semKey] = {};
js/app.js:10597:        if (!dismissals[semKey][fp]) dismissals[semKey][fp] = {};
js/app.js:10599:          dismissals[semKey][fp].note = note;
js/app.js:10600:          dismissals[semKey][fp].noteBy = getAuthUser()?.name || 'Unknown';
js/app.js:10601:          dismissals[semKey][fp].noteAt = new Date().toISOString();
js/app.js:10603:          delete dismissals[semKey][fp].note;
js/app.js:10604:          delete dismissals[semKey][fp].noteBy;
js/app.js:10605:          delete dismissals[semKey][fp].noteAt;
js/app.js:10607:        await saveDiagDismissals(dismissals);

exec
/bin/zsh -lc "sed -n '1,220p' e2e/fixtures/seed/curriculum.json; rg -n \"collection\\('curriculum'\\)\\.doc\\('["'^'"']+'\\)\" js/*.js | sed -E \"s/.*doc\\('(["'^'"']+)'.*/\\1/\" | sort -u" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
{
  "appData": {
    "activeSemester": "spring-2026",
    "semesters": {
      "spring-2026": {
        "name": "Spring 2026",
        "startDate": "2026-01-12",
        "numWeeks": 16,
        "breakWeeks": [
          10
        ],
        "closureDates": [],
        "published": true,
        "dataSource": "firestore",
        "teacherNames": [
          "Fixture Teacher",
          "Second Fixture"
        ],
        "classRoster": {
          "Fixture Class": {
            "teacher": "Fixture Teacher",
            "day": "Monday",
            "time": "4:00 PM",
            "enrollment": 8,
            "waitlist": 0,
            "sessions": 15
          },
          "Second Class": {
            "teacher": "Second Fixture",
            "day": "Thursday",
            "time": "5:30 PM",
            "enrollment": 6,
            "waitlist": 1,
            "sessions": 15
          }
        }
      },
      "summer-2026": {
        "name": "Summer 2026",
        "semesterType": "summer-camp",
        "startDate": "2026-05-26",
        "numWeeks": 11,
        "breakWeeks": [
          6
        ],
        "published": false,
        "dataSource": "summer-camp-app",
        "teacherNames": [],
        "campRoster": {},
        "classRoster": {}
      }
    },
    "teacherMappings": {
      "e2e-teacher-uid": "Fixture Teacher"
    },
    "lastUpdated": "2026-09-01T12:00:00.000Z",
    "lastUpdatedBy": "E2E Admin"
  },
  "lessonData": {
    "spring-2026": {
      "fixtureteacher-fixtureclass-1": {
        "teacher": "Fixture Teacher",
        "className": "Fixture Class",
        "weekNum": 1,
        "weekDate": "2026-01-12",
        "classSize": 8,
        "projectTitle": "Fixture Watercolor Skies",
        "shortDetails": "Wet-on-wet sky studies",
        "inspoLink": "",
        "introPitch": "Fixture intro pitch for week 1",
        "processStep1": "Fixture step 1",
        "processStep2": "Fixture step 2",
        "processStep3": "",
        "processStep4": "",
        "closure": "Fixture closure",
        "materials": "Watercolor paper\nBrushes",
        "materialsList": [],
        "dayOfMaterials": "",
        "teacherNotes": "",
        "adminResponse": "",
        "qaThread": [],
        "planComplete": false,
        "lastEditedBy": "Fixture Teacher",
        "lastEditedAt": "2026-01-10T18:00:00.000Z"
      },
      "fixtureteacher-fixtureclass-2": {
        "teacher": "Fixture Teacher",
        "className": "Fixture Class",
        "weekNum": 2,
        "weekDate": "2026-01-19",
        "classSize": 8,
        "projectTitle": "",
        "shortDetails": "",
        "inspoLink": "",
        "introPitch": "",
        "processStep1": "",
        "processStep2": "",
        "processStep3": "",
        "processStep4": "",
        "closure": "",
        "materials": "",
        "dayOfMaterials": ""
      },
      "secondfixture-secondclass-1": {
        "teacher": "Second Fixture",
        "className": "Second Class",
        "weekNum": 1,
        "weekDate": "2026-01-15",
        "classSize": 6,
        "projectTitle": "Fixture Clay Creatures",
        "shortDetails": "",
        "inspoLink": "",
        "introPitch": "Fixture intro for the second class",
        "processStep1": "Fixture step 1",
        "processStep2": "",
        "processStep3": "",
        "processStep4": "",
        "closure": "",
        "materials": "Air-dry clay",
        "dayOfMaterials": "",
        "qaThread": [],
        "planComplete": true,
        "lastEditedBy": "Second Fixture",
        "lastEditedAt": "2026-01-14T18:00:00.000Z"
      }
    },
    "lastUpdated": "2026-09-01T12:00:00.000Z",
    "lastUpdatedBy": "E2E Admin"
  },
  "cutProjects": {
    "spring-2026": [
      {
        "projectTitle": "Fixture Cut Project",
        "shortDetails": "Cut from week 4 for time",
        "inspoLink": "",
        "introPitch": "Fixture cut intro",
        "processStep1": "Fixture step 1",
        "processStep2": "",
        "processStep3": "",
        "processStep4": "",
        "closure": "",
        "materials": "",
        "dayOfMaterials": "",
        "teacherNotes": "",
        "adminResponse": "",
        "publishToPrep": false,
        "status": "cut",
        "originalTeacher": "Fixture Teacher",
        "originalClassName": "Fixture Class",
        "originalWeek": 4,
        "cutDate": "2026-02-01T12:00:00.000Z",
        "cutBy": "E2E Admin"
      }
    ],
    "lastUpdated": "2026-09-01T12:00:00.000Z",
    "lastUpdatedBy": "E2E Admin"
  },
  "changeLog": {
    "spring-2026": [
      {
        "action": "cut",
        "details": "Fixture Cut Project cut from Fixture Teacher / Fixture Class week 4",
        "timestamp": "2026-02-01T12:00:00.000Z",
        "by": "E2E Admin"
      }
    ]
  },
  "prepData": {
    "spring-2026": {}
  },
  "futureProjects": {
    "projects": [
      {
        "title": "Fixture Idea: Cardboard Cities",
        "details": "Saved for a future semester",
        "addedBy": "E2E Admin",
        "addedAt": "2026-03-01T12:00:00.000Z"
      }
    ],
    "lastUpdated": "2026-03-01T12:00:00.000Z",
    "lastUpdatedBy": "E2E Admin"
  },
  "diagnosticDismissals": {
    "spring-2026": {},
    "lastUpdated": "2026-09-01T12:00:00.000Z",
    "lastUpdatedBy": "E2E Admin"
  }
}
appData
changeLog
cutProjects
diagnosticDismissals
futureProjects
lessonData
lessonData_backup
prepCycleConfig
prepData

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/studio-hub/firestore.rules | sed -n '1,95p'; nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html | sed -n '95,112p'; nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html | sed -n '165,215p'; nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html | sed -n '236,289p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
     1	rules_version = '2';
     2	
     3	service cloud.firestore {
     4	  match /databases/{database}/documents {
     5	
     6	    // ═══════════════════════════════════════════════════════════════
     7	    // HELPER FUNCTIONS
     8	    // Change a function here → every rule that uses it updates.
     9	    // Never repeat logic inline.
    10	    // ═══════════════════════════════════════════════════════════════
    11	
    12	    function isAuthenticated() {
    13	      return request.auth != null;
    14	    }
    15	
    16	    function getUserData() {
    17	      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data;
    18	    }
    19	
    20	    // Archived users (active:false) lose access everywhere this is required —
    21	    // missing `active` defaults to true, so existing users need no migration.
    22	    // The reminder bot is never an active user, whatever a users doc keyed to its uid might say — so
    23	    // even a doc an admin created by hand can never make isAdmin/isManager/hasAppAccess true for it.
    24	    function isActiveUser() {
    25	      return isAuthenticated() && !isReminderBot() && getUserData().get('active', true) == true;
    26	    }
    27	
    28	    function isAdmin() {
    29	      return isAuthenticated() && isActiveUser() && getUserData().role == 'admin';
    30	    }
    31	
    32	    function isManager() {
    33	      return isAuthenticated() && isActiveUser() && getUserData().role == 'manager';
    34	    }
    35	
    36	    function isManagerOrAbove() {
    37	      return isAuthenticated() && isActiveUser() && getUserData().role in ['admin', 'manager'];
    38	    }
    39	
    40	    function isKiosk() {
    41	      return isAuthenticated() && (
    42	        request.auth.uid == '06ooFxutK5YTaJvu5SkywY9gZqh2'
    43	        || request.auth.token.email == 'kiosk@tinkerartstudio.com'
    44	        || request.auth.token.email == 'kiosk2@tinkerartstudio.com'
    45	      );
    46	    }
    47	
    48	    // Tinker Ticker's 48-hour shift-reminder job (reminders@tinkerartstudio.com), a Netlify Scheduled
    49	    // Function that signs in with the client SDK — no service account, no key. Pinned by uid ONLY: an
    50	    // email/password account's address is unverified, so the kiosk's email clause is deliberately not
    51	    // copied. It has no users doc and never will (see the users create rule). What it may do is listed
    52	    // per collection below and nowhere else: read schedules, GET (never list) a users doc, and create /
    53	    // resolve its own claim documents in timeclock_reminder_log. Never OR this with a helper that
    54	    // reads users (isManagerOrAbove etc.) — each grant is its own allow line.
    55	    function isReminderBotUid(uid) {
    56	      return uid == 'JO8U8EYw2tgVBbsUXvbqNrbCPlh1';
    57	    }
    58	    function isReminderBot() {
    59	      return isAuthenticated() && isReminderBotUid(request.auth.uid);
    60	    }
    61	
    62	    // Checks if an authenticated user has been explicitly granted
    63	    // access to an app via their appAccess array.
    64	    // Manager+ never need this — they're covered by isManagerOrAbove().
    65	    // Finance collections (payroll, bookkeeping) have NO override path —
    66	    // this function is intentionally never called for those.
    67	    function hasAppAccess(appName) {
    68	      let data = getUserData();
    69	      return isAuthenticated()
    70	        && isActiveUser()
    71	        && ('appAccess' in data)
    72	        && appName in data.appAccess;
    73	    }
    74	
    75	    // Studio isolation. Admin always passes. Everyone else must have
    76	    // the studio in their studios array. Needs its own explicit isActiveUser()
    77	    // check — the non-admin branch doesn't route through isAdmin()/isManager()/
    78	    // hasAppAccess() at all, so gating those four alone would miss this one.
    79	    function belongsToStudio(studio) {
    80	      return isActiveUser() && (isAdmin() || studio in getUserData().studios);
    81	    }
    82	
    83	    // True if `field` is unchanged by this write: same presence
    84	    // (both missing or both present) and, if present, the same value.
    85	    // Used to pin privilege-bearing fields (role, appAccess, studios)
    86	    // during self-writes to the users collection.
    87	    function fieldUnchanged(field) {
    88	      return (field in resource.data) == (field in request.resource.data)
    89	        && (!(field in resource.data) || request.resource.data[field] == resource.data[field]);
    90	    }
    91	
    92	    // True if `field` was not set before this write, or keeps the same value:
    93	    // a first-time set is allowed; changing or removing it once set is denied.
    94	    // (request.resource.data is the whole document after the write.)
    95	    function fieldUnchangedOnceSet(field) {
    95	</ul>
    96	<p><strong>Shape:</strong></p>
    97	<ul>
    98	  <li><code>index.html:411</code>: a new <code>onSettingsSemesterChange(value)</code> that does what Teacher View's selector does (<code>app.js:826-830</code>): set <code>#global-semester-select</code>'s value <em>first</em>, then <code>setGlobalSemester(value)</code>. Without the header sync, the header would keep showing the old semester and re-picking it would fire no change event (round 2, finding 1). Settings' options are filtered by <code>canSeeSemester</code>, like the header's.</li>
    99	  <li><code>setupRoleAccess</code> (<code>app.js:318-336</code>): hide <code>#settings-link</code> and its dot (<code>.footer-dot.write-control</code>; other <code>.footer-dot</code>s stay) for non-managers too. <code>switchTab('settings')</code>, the footer handler, <strong>and the tab button's own click handler</strong> (<code>app.js:203</code>) refuse for non-managers.</li>
   100	  <li>New <code>makeSemesterActive(key)</code> beside <code>toggleSemesterPublish</code>. Eligibility is by type (<code>isWeeklySemester(key) || isCampSeason(key)</code>), never by key prefix (there's a ratchet against prefix routing). It refuses if the user isn't admin/manager, or the key is missing or already active. It checks <code>isPublishableType(key)</code> before any auto-publish, so the two gates can't drift. The old semester's name falls back to its key if the name is missing. Then it confirms through <code>confirmModal</code> (built in this phase, so Phase 2 only adds the checkbox and the activation tests aren't rewritten), then writes through a new <code>activateSemesterTx(key, expectedActive, { publish, switchEveryone })</code> in <code>firebase-data.js</code> (Codex finding 4). It's one <code>runTransaction</code> that re-reads appData from the server and refuses, with "reload and try again", unless <code>semesters[key]</code> still exists with a name and an eligible type, and <code>activeSemester === expectedActive</code> (what the confirmation showed). Only then does it <code>tx.update</code> <code>activeSemester</code>, the publish flag if needed, the Phase 2 switch field, and <code>lastUpdated</code>/<code>lastUpdatedBy</code>. This way a stale tab can't point "active" at a semester another tab deleted, or recreate a half-semester through the dotted publish path. It honours the same guards as <code>updateAppData</code>. <code>currentConfig</code> changes only after the commit succeeds; on failure nothing local changes.</li>
   101	  <li>Re-render set after success or failure: header options, Teacher View selector, <code>renderSemesterSelector()</code>, <code>loadSettingsForm()</code>. The header's <code>change</code> listener gets the attach-once guard Teacher View already uses (<code>dataset.listenerAttached</code>), so re-rendering doesn't stack handlers.</li>
   102	  <li><code>deleteSemester</code>, weekly branch only, in this order:
   103	    <ol>
   104	      <li>Forced-server reads: <code>readServerSemesterLessonMap(key)</code> plus the semester's <code>cutProjects[key]</code> and <code>changeLog[key]</code>. Any rejection refuses. <code>null</code> means 0 lessons and proceeds.</li>
   105	      <li>The modal (count, truthful text, typed name).</li>
   106	      <li>A JSON snapshot download: <code>classbook-&lt;key&gt;-snapshot-&lt;ISO&gt;.json</code> through a Blob link, containing <code>{ appDataEntry, lessons, cutProjects, changeLog, takenAt, takenBy }</code>.</li>
   107	      <li>New <code>deleteWeeklySemesterTx(key)</code> in <code>firebase-data.js</code>: one <code>runTransaction</code> (the house pattern, e.g. <code>firebase-data.js:2452</code>) that re-reads appData and verifies <code>semesters[key]</code> still exists and <code>activeSemester !== key</code>. It then <code>tx.update</code>s appData (<code>semesters.&lt;key&gt;</code> delete, plus <code>lastUpdated</code>/<code>lastUpdatedBy</code>) and lessonData (<code>&lt;key&gt;</code> delete). It honours <code>updateAppData</code>'s guards (<code>configLoadFailed</code>, season registry).</li>
   108	    </ol>
   109	    The old two-write path and its warn-only catch are removed for weekly semesters. Details: (<code>firebase-data.js:973-977</code>, already used by <code>createNewSemester</code>'s pre-check), and a failed read (a rejection) refuses. <code>null</code> means the doc or key is absent, which is 0 lessons: the delete proceeds, and an empty semester isn't blocked. The two <code>confirm()</code>s become <strong>one modal</strong>, the same component Phase 2 uses (<code>confirmModal({ title, body, checkbox?, typeToConfirm? })</code> built on <code>simple-modal</code>): one confirmation idiom, no <code>prompt()</code>. Its text is corrected as above. Camp and SDOC branches keep their current dialogs. <strong>Three existing tests change in the same commit:</strong> <code>data-safety.spec.js</code> around 8537 (asserts two confirms), around 7778-7790 (delete payload shape), and "a refused delete or publish toggle reverts this tab" (asserts the <code>Could not remove</code> alert). All three stub <code>window.confirm</code> and <code>await deleteSemester(...)</code> inside one <code>page.evaluate</code>. Each must be split: start the call, drive the modal from Playwright, then await the result.</li>
   110	  <li>Left alone on purpose: <code>app.js:5069-5074</code> and the <code>caCurrentSemester</code> assignment at <code>:4590</code> are dead code (round 2 confirmed that nothing reads them). This plan doesn't touch them.</li>
   111	  <li>The Curriculum Admin bar stays read-only for "active" (it's the same audience, but one place to change it is enough).</li>
   112	</ul>
   165	  Then Curriculum Admin shows no Delete and no Publish toggle for it, and the activation confirm said so
   166	
   167	Scenario: write refused by the rules (failure) — real write, staff session
   168	  Given the staff test account
   169	  When updateAppData({ activeSemester: "spring-2026" }) is called
   170	  Then it rejects with permission-denied and appData is unchanged
   171	
   172	Scenario: write refused by the app's own guard (failure)
   173	  Given seasonRegistryMode = "error" (or configLoadFailed)
   174	  When the manager confirms
   175	  Then the alert names the reason, says "Nothing was changed", and the labels, activeSemester and published flag are exactly as before
   176	
   177	Scenario: deleting a weekly semester needs its name typed (safety)
   178	  Given Spring 2026 is not active and the server holds N lessons for it
   179	  When the manager clicks Delete
   180	  Then the modal states N lessons, says the cut bank and change history stay, and requires "Spring 2026"
   181	       (trimmed, case-insensitive); a wrong or empty answer deletes nothing
   182	       (updateAppData and deleteLessonData not called)
   183	
   184	Scenario: the delete is all-or-nothing (failure) — real transaction, manager session
   185	  Given a test weekly semester with lessons in the emulator
   186	  When the transaction is made to fail (e.g. the appData entry is removed by a second writer between the read and the commit, or a stubbed commit rejects)
   187	  Then both curriculum/appData.semesters.<key> and curriculum/lessonData.<key> read back unchanged
   188	
   189	Scenario: a snapshot is taken first (safety)
   190	  When the manager confirms a weekly delete
   191	  Then a download named classbook-<key>-snapshot-*.json happens before the transaction
   192	   And it contains the appData entry, the lessons, cutProjects and changeLog for that key
   193	
   194	Scenario: a stale tab can't activate a deleted semester (failure, Codex finding 4)
   195	  Given tab A loaded Fall; the Fall entry is then deleted on the server
   196	  When tab A makes Fall active
   197	  Then the transaction refuses, asks for a reload, and appData.activeSemester and semesters are unchanged
   198	   (no semesters.fall-2026 = {published:true} ghost)
   199	
   200	Scenario: someone changed "active" meanwhile (failure)
   201	  Given tab A's confirmation showed Spring as active, but the server now says Summer
   202	  When tab A confirms
   203	  Then it refuses and asks for a reload
   204	
   205	Scenario: the lesson count can't be read (failure)
   206	  Given readServerSemesterLessonMap rejects
   207	  When the manager clicks Delete
   208	  Then an alert says nothing was deleted, and nothing was
   209	
   210	Scenario: re-render does not stack handlers (regression)
   211	  After makeSemesterActive runs twice, one header change calls setGlobalSemester exactly once</div>
   212	</div>
   213	
   214	<div class="phase" id="phase-2">
   215	<h3>Phase 2: "Switch everyone to it" <span class="status-tag not-ready">execution-ready: false</span></h3>
   236	<div class="bdd">Scenario: teachers are moved once (happy path) — staged so the first sign-in can't consume it (Codex finding 5)
   237	  Given a teacher signed in via the form in a fresh context while NO switch exists
   238	   And their browser then remembers "spring-2026"
   239	   And a manager context then makes Fall active with the box ticked (T1)
   240	  When the teacher reloads the Classbook
   241	  Then they land on Fall 2026, localStorage.globalSemesterKey = "fall-2026", activeSemesterSwitchSeen = T1
   242	  When they pick Spring 2026 and reload
   243	  Then they stay on Spring 2026
   244	
   245	Scenario: the manager who switched is moved too (edge)
   246	  Given the manager made Fall active with the box ticked, then picked Spring
   247	  When they reload
   248	  Then they land on Fall 2026 once
   249	
   250	Scenario: an unticked activation clears an old switch (regression, Codex finding 1)
   251	  Given Fall activated ticked (T1), then Summer activated unticked, then Fall activated unticked
   252	  When a browser that never loaded since T1 loads
   253	  Then it is not moved, and appData has no activeSemesterSwitch
   254	
   255	Scenario: a shared computer moves each person once (Codex finding 2)
   256	  Given teacher A on a shared browser consumed T1, then picked Spring and signed out
   257	  When teacher B signs in on that browser for the first time since T1
   258	  Then B is moved to Fall; A, signing in again, is not
   259	
   260	Scenario: unticked moves nobody (edge)
   261	  Given the box was unticked (no activeSemesterSwitch written; payload keys asserted)
   262	  When a teacher who remembers Spring loads
   263	  Then they stay on Spring; the header shows "Fall 2026 (active)"
   264	
   265	Scenario: a stale switch does not move anyone (edge, finding 5)
   266	  Given activeSemesterSwitch.to = "fall-2026" but activeSemester was since set to "summer-2026" (unticked)
   267	  When a not-yet-loaded browser loads
   268	  Then it is not moved, and the switch is marked seen
   269	
   270	Scenario: invisible target waits (edge, finding 6)
   271	  Given activeSemesterSwitch.to is unpublished and the user is a teacher
   272	  When they load
   273	  Then not moved, not marked seen; after it is published and they reload, they are moved
   274	
   275	Scenario: a second switch later in the year (edge)
   276	  Given a browser has seen switch A
   277	  When switch B is written (different at)
   278	  Then that browser is moved on its next load
   279	
   280	Scenario: open tabs are unaffected until reload (edge)
   281	  Given a second tab already open on Spring
   282	  When the switch is written
   283	  Then that tab stays on Spring until it reloads
   284	
   285	Scenario: deploy alone moves nobody (safety)
   286	  Given appData has no activeSemesterSwitch
   287	  When any user loads the new build
   288	  Then their remembered semester is unchanged</div>
   289	</div>

exec
/bin/zsh -lc "rg -n \"function getAuthUser\" js/auth-guard.js js/*.js; nl -ba js/auth-guard.js | sed -n '180,220p'; rg -n \"activeSemesterSwitchSeen|activeSemesterSwitch\" /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
js/auth-guard.js:152:function getAuthUser() {
js/auth-guard.js:152:function getAuthUser() {
225:<p><strong>Shape:</strong> the "seen" marker is per signed-in user: <code>localStorage['activeSemesterSwitchSeen:' + uid]</code>. <code>globalSemesterKey</code> stays browser-wide as today. When unticked, the transaction writes <code>activeSemesterSwitch: FieldValue.delete()</code>. When ticked, the same transaction writes <code>activeSemesterSwitch: { to: key, at: new Date().toISOString() }</code>. It must be a <strong>client ISO string</strong>, the way <code>lastUpdated</code> is: a <code>serverTimestamp()</code> reads back as a Timestamp, would never equal the stored string, and would re-switch on every load. Compare <code>String(sw.at)</code>. <strong>Placement is load-bearing:</strong> the check runs <em>once</em> in the <code>DOMContentLoaded</code> sequence, after <code>requireAuth</code> and <code>loadConfig()</code> (<code>app.js:148-152</code>) and before <code>initGlobalSemesterSelector()</code> (<code>:158</code>). Never inside <code>initGlobalSemesterSelector</code>, which is re-called after creating a semester and after <code>makeSemesterActive</code>, and would consume the manager's own switch in the same page load. It's one map field, so it replaces the previous switch whole. On load, before the existing pick at <code>app.js:65</code>, with <code>sw = currentConfig.activeSemesterSwitch</code> and <code>seen = localStorage['activeSemesterSwitchSeen:' + getAuthUser().uid]</code>:</p>
241:  Then they land on Fall 2026, localStorage.globalSemesterKey = "fall-2026", activeSemesterSwitchSeen = T1
253:  Then it is not moved, and appData has no activeSemesterSwitch
261:  Given the box was unticked (no activeSemesterSwitch written; payload keys asserted)
266:  Given activeSemesterSwitch.to = "fall-2026" but activeSemester was since set to "summer-2026" (unticked)
271:  Given activeSemesterSwitch.to is unpublished and the user is a teacher
286:  Given appData has no activeSemesterSwitch
296:    <li><strong>Partial update:</strong> <code>updateAppData</code> (<code>update()</code> of named dotted paths; its <code>set(merge)</code> fallback fires only if appData doesn't exist, which isn't the case here). Only <code>activeSemester</code>, optionally <code>semesters.&lt;key&gt;.published</code> and <code>activeSemesterSwitch</code>, plus the existing <code>lastUpdated</code>/<code>lastUpdatedBy</code>.</li>
311:      <li><strong>Top leak risk:</strong> a leaked <code>activeSemesterSwitch</code> would silently move <em>every</em> later test (their contexts carry no <code>activeSemesterSwitchSeen</code>) to <code>sw.to</code>. The restore below is mandatory and read back, and a final assertion in this spec checks appData has no <code>activeSemesterSwitch</code>.</li>
312:      <li><strong>One real round-trip</strong> runs in a manager context (<code>MANAGER_STATE_PATH</code>, first spec to use it). The test semester is created and removed through the app's own <code>updateAppData</code> in that page, and <code>activeSemester</code> is restored to <code>spring-2026</code> and <code>activeSemesterSwitch</code> deleted in <code>afterEach</code> <strong>and</strong> <code>afterAll</code>, each read back. Cleanup is self-contained and doesn't rely on file order. With <code>workers: 1</code> this file happens to run first alphabetically, and a leak would break <code>day-off-camps.spec.js</code> "SDOC R6" and <code>day-off-teacher.spec.js</code> "T20", which read the active semester.</li>
313:      <li><strong>The restore can't run from Node</strong> (the helper is staff, and appData writes are manager-only). <code>afterEach</code>/<code>afterAll</code> open a manager browser context and call the page's own <code>updateAppData</code> (<code>activeSemester: 'spring-2026'</code>, <code>activeSemesterSwitch: FieldValue.delete()</code>, <code>semesters.&lt;test&gt;: FieldValue.delete()</code>), then read back with <code>readAppDataFromServer()</code> (<code>firebase-data.js:243-247</code>).</li>
344:    <li>(1) An unticked activation now deletes any old <code>activeSemesterSwitch</code>, with a three-activation regression test.</li>
345:    <li>(2) The "seen" marker is per user (<code>activeSemesterSwitchSeen:&lt;uid&gt;</code>), so on a shared computer every person moves once. That matches the promise "switch everyone".</li>
363:    <li>(d) The e2e restore runs through a manager browser context, not Node. The camp scenario is stubbed so <code>summer-2026.published</code> can't leak. The <code>activeSemesterSwitch</code> leak is flagged as the top risk.</li>

exec
/bin/zsh -lc "nl -ba js/auth-guard.js | sed -n '145,160p'; nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html | sed -n '340,370p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
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
   340	<h2 id="decisions">Decisions Log (append-only)</h2>
   341	<div class="decision">
   342	  <strong>Sep 29, 2026: revision 4, after Codex's independent review (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-codex.md</code>): NOT execution-ready, 5 findings, all verified and taken.</strong>
   343	  <ul>
   344	    <li>(1) An unticked activation now deletes any old <code>activeSemesterSwitch</code>, with a three-activation regression test.</li>
   345	    <li>(2) The "seen" marker is per user (<code>activeSemesterSwitchSeen:&lt;uid&gt;</code>), so on a shared computer every person moves once. That matches the promise "switch everyone".</li>
   346	    <li>(3) Weekly delete takes a JSON snapshot download (forced-server reads) first and removes the appData entry and lesson map in one transaction, with a failure test. The text now says the cut bank and change history stay stored but become unreachable.</li>
   347	    <li>(4) Activation runs in a transaction that verifies the target still exists and "active" hasn't changed since the confirmation, so no ghost semester can be created.</li>
   348	    <li>(5) The teacher test is staged so the first sign-in can't consume the switch, and the Phase 1 happy path unticks the box.</li>
   349	  </ul>
   350	  Also taken: the tab button's own click handler refuses Settings for non-managers.<br>
   351	  <strong>Scope note for Christie:</strong> finding 3 grows Phase 1 (a snapshot download plus a transaction for delete). It's needed because this feature is what exposes Delete on the old semester.<br>
   352	  <strong>Execution-ready reverted to false</strong> until a Codex confirmation round.
   353	</div>
   354	<div class="decision">
   355	  <strong>Sep 29, 2026: round 3 (confirmation) — EXECUTION-READY</strong> (<code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r3-claude.md</code>). All round-2 blockers were confirmed resolved. Its four clarifications are folded in: hide only <code>.footer-dot.write-control</code>; <code>readServerSemesterLessonMap</code> returning <code>null</code> means 0 lessons, not a failure; the three delete tests must split their <code>page.evaluate</code> to drive the modal; the activation uses <code>confirmModal</code> from Phase 1. Also named: a curriculum-admin/prep user with nothing remembered lands with Curriculum Admin hidden when Summer is active. All phases are marked execution-ready. Execution waits for Christie's go-ahead. Codex didn't review this plan (out of credits); all three rounds were Claude.
   356	</div>
   357	<div class="decision">
   358	  <strong>Sep 29, 2026: revision 3, after round-2 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r2-claude.md</code>).</strong> Round 2 found the write shape safe and listed five blockers, all verified and taken:
   359	  <ul>
   360	    <li>(a) The Settings dropdown fix syncs the header first, as Teacher View does.</li>
   361	    <li>(b) Phase 2's check is a one-shot in <code>DOMContentLoaded</code>, never in <code>initGlobalSemesterSelector</code>, and <code>at</code> is a client ISO string.</li>
   362	    <li>(c) "Nobody below manager sees it" was false: curriculum-admin and prep can open Settings through the footer link. Phase 1 hides that link, gates <code>switchTab</code>, and renders the button only for admin/manager.</li>
   363	    <li>(d) The e2e restore runs through a manager browser context, not Node. The camp scenario is stubbed so <code>summer-2026.published</code> can't leak. The <code>activeSemesterSwitch</code> leak is flagged as the top risk.</li>
   364	    <li>(e) The weekly-delete guard counts from the server (<code>readServerSemesterLessonMap</code>), corrects the false "cut bank and change history" text, and uses the same modal as Phase 2 (no <code>prompt()</code>). Three existing <code>data-safety</code> tests change in the same commit.</li>
   365	  </ul>
   366	  Also taken: an <code>isPublishableType</code> check before auto-publish, the name fallback in the confirm, filtering Settings' options by <code>canSeeSemester</code>, the camp-active consequences named in the confirm and BDD, and the stale-seen asymmetry recorded as a decision.<br>
   367	  <strong>Not taken (out of scope, noted):</strong> the dead code at <code>app.js:5069-5074</code> and <code>:4590</code>. <code>deleteLessonData</code> lacks a <code>lessonDataLoadedSuccessfully</code> guard and runs after the appData entry is gone inside a warn-only catch (pre-existing, and the server-read count now gates the whole delete). Cut bank and change history are orphaned by a weekly delete (pre-existing, and the text is now honest about it).
   368	</div>
   369	<div class="decision">
   370	  <strong>Sep 29, 2026: revision 2, after round-1 review (Claude; <code>thoughts/reviews/2026-09-29-plan-review-make-active-semester-r1-claude.md</code>).</strong> Verified against the code and taken:

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html | sed -n '120,165p'; nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html | sed -n '215,260p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
   120	  Given a manager on Settings for Fall 2026 (published, weekly), active = Spring 2026
   121	  When they click "Make this the active semester", UNTICK "switch everyone" (Phase 2), and confirm
   122	  Then curriculum/appData.activeSemester reads back from the emulator as "fall-2026"
   123	   And a whole-document diff of appData, ignoring lastUpdated/lastUpdatedBy (as app.js:10918 does), shows only activeSemester changed
   124	   And header "Fall 2026 (active)", Teacher View "Fall 2026 (current)", Settings badge on Fall,
   125	       Curriculum Admin shows Spring with Publish toggle and Delete
   126	
   127	Scenario: making a draft semester active publishes it (edge) — stubbed updateAppData
   128	  Given Fall 2026 is published:false
   129	  When the manager makes it active and confirms (dialog mentions publishing)
   130	  Then exactly one updateAppData call, and
   131	       Object.keys(payload).sort() equals ["activeSemester", "semesters.fall-2026.published", …Phase 2 keys]
   132	
   133	Scenario: a Summer camp season can be made active (Q1)
   134	  Given Settings on Summer 2026 (camp season)
   135	  When the manager makes it active
   136	  Then activeSemester = "summer-2026"; with nothing remembered a user lands on Summer 2026;
   137	       Prep Dashboard hidden (as for any camp selection); Teacher View and Curriculum Admin render as they do when Summer is merely selected (so a curriculum-admin/prep user with nothing remembered lands with the Curriculum Admin tab hidden, as today for Summer)
   138	
   139	Scenario: back from Summer to a class semester (edge)
   140	  Given Summer 2026 is active
   141	  When the manager makes Fall 2026 active
   142	  Then the Prep Dashboard tab reappears for Fall
   143	
   144	Scenario: cancel changes nothing (edge)
   145	  When the manager cancels the confirmation
   146	  Then updateAppData is not called and nothing on screen changes
   147	
   148	Scenario: ineligible or already active: no button (edge)
   149	  Given Settings on an SDOC year, or on the active semester
   150	  Then no "Make this the active semester" button
   151	
   152	Scenario: non-manager never sees it (UI)
   153	  Given a curriculum-admin (staff) user
   154	  Then the Settings tab button AND the footer "Settings" link are hidden
   155	   And calling switchTab('settings') leaves them where they were
   156	   And the button is not visible even though loadSettingsForm ran (assert not visible, not count 0)
   157	
   158	Scenario: the Settings dropdown keeps the header in step (regression, round 2)
   159	  Given the header shows Spring 2026
   160	  When Settings' dropdown picks Fall 2026, then the header picks Spring 2026
   161	  Then the app is back on Spring 2026 (the header change fired)
   162	
   163	Scenario: a camp season active can't be removed (edge)
   164	  Given Summer 2026 is active
   165	  Then Curriculum Admin shows no Delete and no Publish toggle for it, and the activation confirm said so
   215	<h3>Phase 2: "Switch everyone to it" <span class="status-tag not-ready">execution-ready: false</span></h3>
   216	<p><strong>Acceptance (user outcomes):</strong></p>
   217	<ul>
   218	  <li>The Phase 1 confirmation has a checkbox, <strong>"Also switch everyone to Fall 2026 the next time they open the Classbook"</strong>, ticked by default (Q2). Because a plain <code>confirm()</code> can't hold a checkbox, the confirmation becomes a small in-app modal, reusing the existing <code>simple-modal</code> styling.</li>
   219	  <li>With it ticked, every <strong>person</strong> who can see that semester lands on it the next time they load the Classbook, once per person, not once per browser. On a shared studio computer, each teacher who signs in is moved once (Codex finding 2). That includes the manager who made the switch, on their next load. After that, any semester they pick sticks as usual.</li>
   220	  <li>The switch is tied to <strong>that</strong> semester. If someone later makes a different semester active without ticking the box, browsers that haven't loaded yet are not moved anywhere.</li>
   221	  <li>A user who can't see the semester yet (unpublished; rare, since activation publishes) isn't moved, and isn't marked done either. If it becomes visible while the switch still stands, they move then.</li>
   222	  <li>With it unticked, nobody's remembered semester moves. An unticked activation <strong>deletes</strong> any earlier switch record in the same transaction, so an old switch can never come back to life (Codex finding 1).</li>
   223	  <li>Tabs already open move on their next reload, not live.</li>
   224	</ul>
   225	<p><strong>Shape:</strong> the "seen" marker is per signed-in user: <code>localStorage['activeSemesterSwitchSeen:' + uid]</code>. <code>globalSemesterKey</code> stays browser-wide as today. When unticked, the transaction writes <code>activeSemesterSwitch: FieldValue.delete()</code>. When ticked, the same transaction writes <code>activeSemesterSwitch: { to: key, at: new Date().toISOString() }</code>. It must be a <strong>client ISO string</strong>, the way <code>lastUpdated</code> is: a <code>serverTimestamp()</code> reads back as a Timestamp, would never equal the stored string, and would re-switch on every load. Compare <code>String(sw.at)</code>. <strong>Placement is load-bearing:</strong> the check runs <em>once</em> in the <code>DOMContentLoaded</code> sequence, after <code>requireAuth</code> and <code>loadConfig()</code> (<code>app.js:148-152</code>) and before <code>initGlobalSemesterSelector()</code> (<code>:158</code>). Never inside <code>initGlobalSemesterSelector</code>, which is re-called after creating a semester and after <code>makeSemesterActive</code>, and would consume the manager's own switch in the same page load. It's one map field, so it replaces the previous switch whole. On load, before the existing pick at <code>app.js:65</code>, with <code>sw = currentConfig.activeSemesterSwitch</code> and <code>seen = localStorage['activeSemesterSwitchSeen:' + getAuthUser().uid]</code>:</p>
   226	<ul>
   227	  <li>If <code>sw</code> is missing, or <code>sw.at === seen</code>: do nothing.</li>
   228	  <li>If <code>sw.to !== currentConfig.activeSemester</code>: the switch is stale, so mark it seen and do nothing.</li>
   229	  <li>If <code>canSeeSemester(sw.to)</code>: set <code>globalSemesterKey = sw.to</code> and <strong>write <code>localStorage.globalSemesterKey</code> here</strong> (the <code>setItem</code> at :69 sits in the fallback branch, which this makes false), then mark it seen.</li>
   230	  <li>Otherwise (can't see it yet): don't move and don't mark it seen.</li>
   231	</ul>
   232	<p><strong>Decided asymmetry:</strong> a browser that marked a switch seen through the stale branch isn't moved if that same target becomes active again later without a new tick, while a browser that never loaded would be. That's acceptable: a later switch is a new <code>at</code> and moves everyone.</p>
   233	<p>The comparison is equality, so clock skew can't block a switch. No existing appData writer touches this field: Settings' save writes only <code>semesters.&lt;key&gt;.*</code>, <code>teacherMappings</code> and <code>activeSemester</code> (<code>app.js:11295-11319</code>).</p>
   234	<div class="note">A new <strong>field</strong> on existing <code>curriculum/appData</code>. It's not a new collection, so no rules change. Nothing reads it until the first switch, so deploying Phase 2 moves nobody.</div>
   235	
   236	<div class="bdd">Scenario: teachers are moved once (happy path) — staged so the first sign-in can't consume it (Codex finding 5)
   237	  Given a teacher signed in via the form in a fresh context while NO switch exists
   238	   And their browser then remembers "spring-2026"
   239	   And a manager context then makes Fall active with the box ticked (T1)
   240	  When the teacher reloads the Classbook
   241	  Then they land on Fall 2026, localStorage.globalSemesterKey = "fall-2026", activeSemesterSwitchSeen = T1
   242	  When they pick Spring 2026 and reload
   243	  Then they stay on Spring 2026
   244	
   245	Scenario: the manager who switched is moved too (edge)
   246	  Given the manager made Fall active with the box ticked, then picked Spring
   247	  When they reload
   248	  Then they land on Fall 2026 once
   249	
   250	Scenario: an unticked activation clears an old switch (regression, Codex finding 1)
   251	  Given Fall activated ticked (T1), then Summer activated unticked, then Fall activated unticked
   252	  When a browser that never loaded since T1 loads
   253	  Then it is not moved, and appData has no activeSemesterSwitch
   254	
   255	Scenario: a shared computer moves each person once (Codex finding 2)
   256	  Given teacher A on a shared browser consumed T1, then picked Spring and signed out
   257	  When teacher B signs in on that browser for the first time since T1
   258	  Then B is moved to Fall; A, signing in again, is not
   259	
   260	Scenario: unticked moves nobody (edge)

codex
Verdict: **NOT EXECUTION-READY**

### Prior findings

1. **RESOLVED** — unticked activation deletes the prior switch atomically: plan lines [222–225](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:222>) and regression lines [250–253](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:250>).

2. **RESOLVED** — seen marker is UID-scoped: lines [219–225](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:219>) and shared-device scenario [255–258](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:255>).

3. **NOT RESOLVED** — atomicity is proposed, but the snapshot and concurrency design remain incomplete: lines [102–109](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:102>) and [184–192](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:184>).

4. **RESOLVED** — activation transaction verifies target existence/type and expected active value: lines [100–101](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:100>) and tests [194–203](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:194>).

5. **RESOLVED** — teacher setup is correctly staged and Phase 1 explicitly unticks the default checkbox: lines [120–123](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:120>) and [236–243](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:236>).

6. **Tab-click-handler item: RESOLVED** — the plan explicitly gates the tab button itself: line [99](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:99>).

### Revision 4 checks

- **Rules:** Manager/admin may transact across both `curriculum/appData` and `curriculum/lessonData`; both fall under manager full access at [firestore.rules:652](</Users/christiehubley/studio-hub/firestore.rules:652>). No rules change is required for those writes.
- **Guards:** Both proposed helpers explicitly preserve `configLoadFailed` and season-registry guards at plan lines [100](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:100>) and [107](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:107>), matching [firebase-data.js:212](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:212>).
- **Delete race:** The plan says the transaction reads only `appData`, then updates `lessonData` ([plan:107](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:107>)). Therefore concurrent lesson writes do not trigger transaction retries for `lessonData`. Frequent per-field saves target that same document at [firebase-data.js:1436](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1436>) and can recreate the deleted semester path from a stale open tab. Reading the large shared document in the transaction would detect overlapping writes, but may retry because saves to any weekly semester change the document.
- **Snapshot:** `cutProjects` and `changeLog` are indeed semester-keyed ([firebase-data.js:1212](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1212>), [firebase-data.js:1267](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1267>)). The snapshot omits other semester-keyed data that becomes unreachable: `prepData` ([firebase-data.js:551](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:551>)), `lessonData_backup` ([firebase-data.js:979](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:979>)), and `diagnosticDismissals` ([app.js:10407](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:10407>)).
- **UID availability:** Yes. `requireAuth()` resolves only after `authCurrentUser` containing `uid` is assigned, so `getAuthUser().uid` is available at the proposed point after line 148 ([auth-guard.js:61](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/auth-guard.js:61>), [app.js:147](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:147>)).

Minimum changes:

1. Include forced-server `prepData[key]`, `lessonData_backup[key]`, and `diagnosticDismissals[key]` in the snapshot.
2. Make deletion coordinate with `lessonData`: read/validate it inside the transaction against the downloaded snapshot, and define/test how stale open lesson editors are prevented from recreating the deleted semester afterward.

No files edited; no tests run.
tokens used
84,062
Verdict: **NOT EXECUTION-READY**

### Prior findings

1. **RESOLVED** — unticked activation deletes the prior switch atomically: plan lines [222–225](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:222>) and regression lines [250–253](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:250>).

2. **RESOLVED** — seen marker is UID-scoped: lines [219–225](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:219>) and shared-device scenario [255–258](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:255>).

3. **NOT RESOLVED** — atomicity is proposed, but the snapshot and concurrency design remain incomplete: lines [102–109](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:102>) and [184–192](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:184>).

4. **RESOLVED** — activation transaction verifies target existence/type and expected active value: lines [100–101](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:100>) and tests [194–203](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:194>).

5. **RESOLVED** — teacher setup is correctly staged and Phase 1 explicitly unticks the default checkbox: lines [120–123](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:120>) and [236–243](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:236>).

6. **Tab-click-handler item: RESOLVED** — the plan explicitly gates the tab button itself: line [99](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:99>).

### Revision 4 checks

- **Rules:** Manager/admin may transact across both `curriculum/appData` and `curriculum/lessonData`; both fall under manager full access at [firestore.rules:652](</Users/christiehubley/studio-hub/firestore.rules:652>). No rules change is required for those writes.
- **Guards:** Both proposed helpers explicitly preserve `configLoadFailed` and season-registry guards at plan lines [100](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:100>) and [107](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:107>), matching [firebase-data.js:212](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:212>).
- **Delete race:** The plan says the transaction reads only `appData`, then updates `lessonData` ([plan:107](</Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-make-active-semester.html:107>)). Therefore concurrent lesson writes do not trigger transaction retries for `lessonData`. Frequent per-field saves target that same document at [firebase-data.js:1436](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1436>) and can recreate the deleted semester path from a stale open tab. Reading the large shared document in the transaction would detect overlapping writes, but may retry because saves to any weekly semester change the document.
- **Snapshot:** `cutProjects` and `changeLog` are indeed semester-keyed ([firebase-data.js:1212](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1212>), [firebase-data.js:1267](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1267>)). The snapshot omits other semester-keyed data that becomes unreachable: `prepData` ([firebase-data.js:551](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:551>)), `lessonData_backup` ([firebase-data.js:979](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:979>)), and `diagnosticDismissals` ([app.js:10407](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:10407>)).
- **UID availability:** Yes. `requireAuth()` resolves only after `authCurrentUser` containing `uid` is assigned, so `getAuthUser().uid` is available at the proposed point after line 148 ([auth-guard.js:61](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/auth-guard.js:61>), [app.js:147](</Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:147>)).

Minimum changes:

1. Include forced-server `prepData[key]`, `lessonData_backup[key]`, and `diagnosticDismissals[key]` in the snapshot.
2. Make deletion coordinate with `lessonData`: read/validate it inside the transaction against the downloaded snapshot, and define/test how stale open lesson editors are prevented from recreating the deleted semester afterward.

No files edited; no tests run.
