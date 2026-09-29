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
session id: 01a0ef08-fb5e-7330-ad27-3c91bdb898a0
--------
user
## Codex round 2 — plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (revision 3; read the Decisions Log entry "revision 3"). Your round 1: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md.
Repo (read-only, main 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Rules/tests: /Users/christiehubley/studio-hub/firestore.rules, rules.test.js . Also /Users/christiehubley/studio-hub/js/alerts.js and /Users/christiehubley/tinker-backups/backup.js (read only).
1. For each of your 8 minimum items: RESOLVED / NOT, with plan-line citations.
2. Check what revision 3 introduced, against the code: the rule-enforced edit pause on lessons_spring-2026 (get() on storageMigrations; roles; create-only-if-absent; delete before/after verified); the Phase C transaction (can one transaction do tx.set on a new doc + tx.update deleting a key in a ~1 MB doc + tx.set merge, under the Phase A rules for a manager?); the reverse transaction needing a manager re-add of spring-2026 while not verified (is it in the Phase A rules?); Studio Hub alert re-keying; the headroom estimator.
3. Anything that can still lose, hide, or misroute a lesson.
Verdict: EXECUTION-READY or NOT (minimum list). Be concise. Do not edit files or run tests.
codex
I’ll compare revision 3’s decision-log changes and each round-1 minimum item directly against the plan and current code/rules. I’ll keep this read-only and won’t run tests.
exec
/bin/zsh -lc 'wc -l /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md /Users/christiehubley/studio-hub/firestore.rules /Users/christiehubley/studio-hub/rules.test.js /Users/christiehubley/studio-hub/js/alerts.js /Users/christiehubley/tinker-backups/backup.js && rg -n "revision 3|Revision 3|Decisions Log|minimum|storageMigrations|lessons_spring-2026|headroom|transaction|alert|reverse|verified|manager" /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md' in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
     240 /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html
    8883 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md
    1091 /Users/christiehubley/studio-hub/firestore.rules
    2587 /Users/christiehubley/studio-hub/rules.test.js
     923 /Users/christiehubley/studio-hub/js/alerts.js
     490 /Users/christiehubley/tinker-backups/backup.js
   14214 total
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:36:  <strong>Touches:</strong> the Classbook (<code>js/firebase-data.js</code>, <code>js/app.js</code>), <code>studio-hub/firestore.rules</code> + <code>studio-hub/rules.test.js</code> (sha phrase + guard), <code>studio-hub/js/alerts.js</code> (Studio Hub deploy), and <code>tinker-backups/backup.js</code>, <strong>which only Christie edits</strong> (memory: <code>backup-js-uses-cli-token</code>).<br>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:37:  <strong>Line numbers</strong> at <code>2ef2e62</code>. <strong>Status:</strong> <span class="status-tag not-ready">execution-ready: false</span>. Revision 3, after Claude round 1 and Codex round 1.
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:41:  <strong>If headroom runs out early:</strong> the move itself is already a single step (Phase C), so the fastest safe route is to do Phases A and B promptly and run Phase C as soon as the 3-day stale-tab cutoff allows. Never remove Spring from <code>lessonData</code> before Phase B's code, which can read the new location, is live. Doing so would make Spring look empty, which is the May 2026 incident on purpose. Phase B adds a headroom readout, so nobody has to remember to paste a snippet.
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:44:<h2 id="today">What exists today (research, verified in review round 1)</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:52:  <tr><td>Rules: <code>:654</code> is <code>allow read, write: if isManagerOrAbove()</code>, and <code>:666</code> is a separate create/update for classbook roles (not appData/prepCycleConfig). Rules OR across statements, so fencing a key for managers too means <strong>splitting <code>:654</code></strong> into per-operation statements. Whole-doc delete is limited to classbook-admin/curriculum-admin (<code>:675-678</code>). <code>studio-hub/rules.test.js</code> has no <code>curriculum/lessonData</code> fixture today.</td><td><code>studio-hub/firestore.rules:652-678</code></td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:55:      <li>Studio Hub's Q&amp;A alerts (<code>studio-hub/js/alerts.js:559-580</code>, iterating every top-level key).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:57:      <li><code>studio-hub/test-alerts.js:98, 143</code>: an Admin SDK test script that writes <code>lessonData.qaData</code>. It bypasses rules and isn't part of the app.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:62:<h2 id="design">Design (revision 3)</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:65:  <li><strong>Where Spring lives:</strong> <code>curriculum/lessons_spring-2026</code> = <code>{ &lt;lessonKey&gt;: lesson, lastUpdated, lastUpdatedBy }</code>. <code>lessonStoreFor</code> returns <code>'ownDoc'</code> for keys in the constant. Every weekly site goes through <code>weeklyLessonRef(semKey)</code> / <code>weeklyLessonPath(semKey, lessonKey, field?)</code>: paths are rooted at <code>lessonKey</code> for <code>'ownDoc'</code> and at <code>semKey.lessonKey</code> for legacy.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:67:  <li><strong>One-step move (Codex round 1, "simpler safe option"):</strong> Spring's copy and the removal of its old copy happen <em>in one transaction</em>. There's never a multi-day period with two copies, so nothing is double-counted, and the old copy can't be deleted while the new one is missing.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:68:  <li><strong>Spring edits stay paused, enforced by the rules, until the move is verified.</strong> A rule on <code>curriculum/lessons_spring-2026</code> allows updates only when <code>curriculum/storageMigrations</code> has <code>spring-2026.verified == true</code> (a <code>get()</code> on Spring writes only; Spring is dormant, so the cost is negligible). So nothing can change the new document between the copy and the verification: its hash is stable, and a rollback can't discard a real edit.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:77:  <li>No role can create, add to, or change the <code>spring-2026</code> key. The one exception is a manager update that <em>only deletes</em> it, which the Phase C transaction needs.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:81:<p>For <code>curriculum/lessons_spring-2026</code>: create by a manager only, and only if it doesn't exist. Updates only when <code>storageMigrations.spring-2026.verified == true</code>, for the roles that can update lessons today. Whole-doc delete by a manager (needed for a rollback) and by classbook-admin/curriculum-admin as today, both only while not yet verified; after verification, only a manager can delete it.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:82:<p>For <code>curriculum/storageMigrations</code>: manager write, and read for the classbook roles.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:84:<p><strong>Shape:</strong> split <code>:654</code> (<code>allow read, write: if isManagerOrAbove()</code>) into <code>read</code> / <code>create</code> / <code>update</code> / <code>delete</code> statements, because rules OR across statements. Manager <code>delete</code> is kept for every curriculum doc except <code>lessonData</code>. The classbook-role statements at <code>:666</code> and <code>:675-678</code> get the same <code>lessonData</code>/<code>lessons_spring-2026</code> conditions. The <code>lessonData</code> update condition is <code>!affectedKeys().hasAny(['spring-2026'])</code>, OR (manager) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; !('spring-2026' in request.resource.data)</code>.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:85:<div class="bdd">Rules tests (studio-hub/rules.test.js), roles: teacher (classbook), classbook-admin, curriculum-admin, manager, admin.
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:88:  lessonData update { spring-2026: delete } only                    → manager/admin allowed; others denied
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:93:  lessons_spring-2026 create when absent                            → manager/admin allowed; others denied
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:94:  lessons_spring-2026 update before verified                        → denied (every role); after verified → allowed as for lessons today
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:95:  lessons_spring-2026 delete before verified                        → manager allowed (rollback); after → manager only
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:96:  storageMigrations write                                           → manager/admin only; read → classbook roles
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:104:<p><strong>Acceptance:</strong> in production (no <code>lessons_spring-2026</code> yet), everything behaves as today, and Spring is view-only ("editing is paused while Spring 2026 moves to new storage"). In the emulator, with Spring moved and verified, Spring works end to end, and Fall and every other semester are untouched. This is one Classbook deploy (one Netlify credit) plus one Studio Hub deploy.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:114:  <li><strong>Writes to Spring:</strong> they go to <code>lessons_K</code> only when <code>storageMigrations.spring-2026.verified</code> is true, read by a small <code>storageMigrations</code> listener. Otherwise the app shows the "editing is paused" message; the rules refuse those writes anyway. <code>not-found</code> is handled the same way.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:117:  <li><strong>Headroom readout</strong> in Curriculum Admin → Diagnostics (managers): an approximate Firestore-size estimate of <code>lessonData</code>, using the same field-size method as the Sep 29 snippet (not <code>JSON.stringify</code> length). It's labelled "approx.", and it warns above 85%, a conservative buffer.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:118:  <li><strong>Studio Hub alerts</strong> (Codex 6). The listener keeps per-source state: legacy <code>lessonData</code>, plus <code>lessons_spring-2026</code>. It reconciles the <em>union</em>, so each source's snapshot no longer removes the other's alerts. It prefers the own-doc copy for Spring. Alert IDs become <code>classbook-qa-&lt;semKey&gt;-&lt;lessonKey&gt;</code>, fixing today's cross-semester collisions; at the deploy, existing Q&amp;A alerts are re-keyed once, with no re-notification if Studio Hub dedupes by content, which the executor checks.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:119:  <li><strong>Ratchet:</strong> no <code>doc('lessonData')</code> in the loaded scripts outside the helpers, the legacy load/listener and the dead backup helpers. <code>e2e/</code> is exempt. The seed gains a <code>lessons_spring-2026</code> + <code>storageMigrations</code> fixture set for the own-doc scenarios, and the default seed is unchanged.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:122:  Given no lessons_spring-2026
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:125:Scenario: Spring moved and verified works end to end (emulator)
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:127:  Then every write lands in lessons_spring-2026 at lessonKey.field paths; lessonData is untouched
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:129:Scenario: moved but not yet verified — edits paused
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:130:  Given lessons_spring-2026 exists, verified false
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:138:Scenario: Studio Hub: a Fall question and a Spring question both alert, and answering one leaves the other; identical lesson keys in two semesters give two alerts
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:139:Scenario: headroom readout shows ≈ N KB of 1,024 (approx.) and warns above 85%</div>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:143:<h3>Phase C: move Spring in one step (production, one-off, manager) <span class="status-tag not-ready">execution-ready: false</span></h3>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:150:<p><strong>How:</strong> a console procedure that Christie pastes while signed in as manager. The procedure is written into this plan and reviewed before execution, and rehearsed in the emulator by an e2e test that runs the same code.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:152:  <li>A forced-server read of <code>lessonData</code>. It refuses if <code>spring-2026</code> is missing or <code>lessons_spring-2026</code> exists. Then it downloads <code>classbook-spring-2026-lessons-&lt;ISO&gt;.json</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:153:  <li><strong>One transaction:</strong> read <code>lessonData</code>, <code>lessons_spring-2026</code> (which must not exist) and <code>storageMigrations</code>. Then:
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:155:      <li><code>tx.set(lessons_spring-2026, { ...map, lastUpdated, lastUpdatedBy })</code>, where <code>map</code> is the <code>spring-2026</code> map read <em>inside</em> the transaction</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:157:      <li><code>tx.set(storageMigrations, { 'spring-2026': { movedAt, movedBy, lessonCount, sha256, verified: false } }, { merge: true })</code></li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:160:  <li><strong>Verify</strong> from forced-server reads: <code>lessons_spring-2026</code> minus its <code>lastUpdated*</code> hashes to the recorded <code>sha256</code>, its lesson count matches, <code>lessonData</code> no longer has <code>spring-2026</code>, and <code>lessonData</code>'s size is re-estimated (expected about 420 KB). Edits are paused by rule, so these checks are stable.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:161:  <li><strong>If verification passes:</strong> <code>storageMigrations.spring-2026.verified = true</code>, and Spring becomes editable. Spot-check one Spring lesson in the Firebase Console.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:162:  <li><strong>If it fails:</strong> nothing has been edited since the copy, so the reverse transaction is safe: it puts <code>map</code> back into <code>lessonData</code>, which the rules allow (a manager, and only this key, while not verified; the executor adds this allowance and its test to Phase A), deletes <code>lessons_spring-2026</code>, and records the failure. The download from step 1 remains the last resort.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:165:  Then lessons_spring-2026 deep-equals the old map (+ lastUpdated*), lessonData has no spring-2026, storageMigrations records count + hash, verified → true, Spring editable, Fall untouched
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:167:Scenario: verification fails (simulated) → the reverse transaction restores lessonData['spring-2026'] byte-identical and removes the target
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:169:<div class="note"><strong>The backup script edit (Christie gave permission for this change, Sep 29):</strong> <em>before</em> Phase C, and with Christie's go-ahead confirmed again at that moment, Claude adds the five lines recorded in the Decisions Log to <code>tinker-backups/backup.js</code> (<code>computeClassbookContentByTeacher</code>, just before <code>return counts;</code>). It keeps a <code>.bak</code> copy, checks the syntax with <code>node --check</code>, doesn't run the script, and touches nothing else, above all not the credential code. Because the move is one step, the backup never sees Spring twice.</div>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:184:  <li><strong>Rules:</strong> Phase A is a shared-rules change: tests for all five roles, a near-1 MB fixture, the whole suite green, then <code>deploy-rules.sh --approved &lt;sha&gt;</code> after the phrase. The new docs (<code>lessons_spring-2026</code>, <code>storageMigrations</code>) get explicit conditions in the <code>curriculum/{docId}</code> block.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:185:  <li><strong>Backups (checked Sep 29):</strong> <code>backup.js</code> fetches <em>every</em> document in each listed collection (<code>fetchCollection</code>, <code>:221-247</code>), so <code>lessons_spring-2026</code> and <code>storageMigrations</code> are in every 30-minute backup automatically. The Tier-1 count check counts documents, and <code>curriculum</code> gains two, so there's no false alarm there. The per-teacher content count is covered by the five-line edit.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:187:  <li><strong>Atomic:</strong> the copy, the old-copy removal and the migration record are one transaction.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:189:  <li><strong>Reversible:</strong> a reverse transaction until verified. After that, the download and backups.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:197:  <li><strong>After B:</strong> the same, plus the readout and fixed Studio Hub alerts.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:198:  <li><strong>Mid-C:</strong> the transaction either committed or didn't. If it committed but isn't verified, Spring is viewable, edits are paused, and the reverse transaction exists.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:203:  <li>Read this plan and its Decisions Log. Re-measure lessonData first.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:204:  <li>Phase A in <code>studio-hub</code> (branch, merge to main, then the guard). Phase B in a Classbook worktree off <code>origin/main</code>, plus Studio Hub for the alerts. Re-check the line numbers.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:208:<h2 id="decisions">Decisions Log (append-only)</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:210:  <strong>Sep 29, 2026: revision 3, after Codex's independent round 1 (<code>…-codex-r1.md</code>): NOT ready, 8-point minimum list, all verified and taken.</strong>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:212:    <li>Adopted Codex's "simpler safe option": the copy and the old-copy removal are <strong>one transaction</strong>, with Spring edits paused by rule until the move is verified. That closes the verification/rollback race (1), the target-missing-at-delete risk (2) and double counting (5), since there's no dual-copy window, and Phases C and D merge.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:213:    <li>(3) The rules also fence <code>lessonData</code> create and whole-doc delete, keep manager delete for other docs, and the tests cover admin and curriculum-admin. Q3 is resolved: manager delete is kept, except for <code>lessonData</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:215:    <li>(6) Studio Hub alerts reconcile a union across sources, with semester-qualified IDs.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:217:    <li>(8) Merged <code>storageMigrations</code> writes, target-disappearance behaviour, and a Firestore-size estimator for the readout with an 85% warning.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:219:  The inventory adds <code>studio-hub/test-alerts-browser.html:227</code> and <code>TESTING-GUIDE.md:115</code> (manual, root <code>qaData</code> only).<br>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:232:  <strong>Sep 29, 2026: revision 2, after review round 1 (Claude; <code>thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md</code>): NOT ready, 11-point minimum list, all taken.</strong> Re-scoped to <strong>Spring only, hard-coded</strong>, with no appData flags, <code>migratedSemesters</code>, UI buttons or "Move back". The copy and the removal are reviewed console procedures. The rules fence uses a literal key (no <code>get(appData)</code>), splits <code>:654</code>, and ships <strong>first</strong>. Fixed: the listener drops own-doc semesters (A); verify races (B, moot now that the fence freezes the source first); Phase D's precondition compares against the hash of what was written (C); vanished keys are loud (D); <code>not-found</code> on first write (E); <code>createNewSemester</code>/<code>deleteSemester</code> deferred to the follow-up plan, with a deadline (F, delete); the missing readers are added (<code>tinker-backups/backup.js</code>, which is Christie's edit, the in-app content count, <code>test-alerts.js</code>, dead backup helpers, e2e exemptions, seed); the backup citation and "nightly" are corrected; the listener generation is decided (no bump); teardown uses an array; a near-1 MB rules fixture is added; there's a headroom readout; and the emergency lever's order is fixed.<br>
/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:233:  <strong>Open questions for Christie:</strong> (Q1) Is it OK that Spring 2026 is read-only ("editing is paused") from Phase A until Phase C, probably a few days? (Q2) Will you make the small <code>backup.js</code> edit before Phase D, or accept one expected content-loss alarm for Spring teachers? (Q3, for the reviewer) Undoing a bad Phase C copy needs a whole-doc delete of <code>lessons_spring-2026</code>; today only classbook-admin/curriculum-admin may whole-doc delete (<code>:675-678</code>). Should Phase A's split give managers delete as well (they have it today through <code>:654</code>'s <code>write</code>)? The plan assumes yes: the split keeps manager delete.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:15:/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (revision 2; read the whole Decisions Log). Context: production curriculum/lessonData (one Firestore doc holding every Fall/Spring semester's lessons) is at 972 KB of the 1 MiB cap; this plan moves the finished Spring 2026 semester into its own document. A Claude round-1 review is at /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md — read it so you don't repeat settled points, but don't trust it.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:16:Repo (read-only, main 2ef2e62): /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81 . Rules + rules tests: /Users/christiehubley/studio-hub/firestore.rules, /Users/christiehubley/studio-hub/rules.test.js . Other readers: /Users/christiehubley/studio-hub/js/alerts.js, /Users/christiehubley/tinker-backups/backup.js (read only; an agent must never edit or run it).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:18:1. Can any phase lose, hide, duplicate, or misroute a lesson edit? Consider tabs on old code (pre-Phase-B), tabs loaded between phases, in-flight saves, the listener/generation logic, the "editing is paused" window, the copy transaction and hash verification, and the delete.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:19:2. Phase A rules: is splitting line 654 and the affectedKeys fence correct for every role and every other /curriculum doc and every other app touching /curriculum? Is the near-1 MB test fixture approach sound? Is Q3 (manager whole-doc delete) handled right?
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:21:4. Is anything simpler and equally safe being missed, given ~52 KB headroom?
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:22:Verdict: EXECUTION-READY or NOT (minimum list). Do not edit files or run tests.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:24:I’ll do a read-only, adversarial review of the full revision-2 plan and Decisions Log, then cross-check every referenced reader, writer, rule, and test. I’ll cite exact lines and use concrete failure scenarios; I won’t edit files or run tests.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:66:  <strong>Touches:</strong> the Classbook (<code>js/firebase-data.js</code>, <code>js/app.js</code>), <code>studio-hub/firestore.rules</code> + <code>studio-hub/rules.test.js</code> (sha phrase + guard), <code>studio-hub/js/alerts.js</code> (Studio Hub deploy), and <code>tinker-backups/backup.js</code>, <strong>which only Christie edits</strong> (memory: <code>backup-js-uses-cli-token</code>).<br>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:71:  <strong>Emergency lever (corrected order).</strong> Only after Phase B's read-side code is live, never before, and only with Christie's explicit go-ahead: run Phases C and D back-to-back instead of days apart. Deleting Spring from <code>lessonData</code> before the app can read <code>lessons_spring-2026</code> would make Spring look empty, which is the May 2026 incident on purpose. Phase B adds a headroom readout, so nobody has to remember to paste a snippet.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:74:<h2 id="today">What exists today (research, verified in review round 1)</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:82:  <tr><td>Rules: <code>:654</code> is <code>allow read, write: if isManagerOrAbove()</code>, and <code>:666</code> is a separate create/update for classbook roles (not appData/prepCycleConfig). Rules OR across statements, so fencing a key for managers too means <strong>splitting <code>:654</code></strong> into per-operation statements. Whole-doc delete is limited to classbook-admin/curriculum-admin (<code>:675-678</code>). <code>studio-hub/rules.test.js</code> has no <code>curriculum/lessonData</code> fixture today.</td><td><code>studio-hub/firestore.rules:652-678</code></td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:85:      <li>Studio Hub's Q&amp;A alerts (<code>studio-hub/js/alerts.js:559-580</code>, iterating every top-level key).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:87:      <li><code>studio-hub/test-alerts.js:98, 143</code>: an Admin SDK test script that writes <code>lessonData.qaData</code>. It bypasses rules and isn't part of the app.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:95:  <li><strong>Where Spring lives:</strong> <code>curriculum/lessons_spring-2026</code> = <code>{ &lt;lessonKey&gt;: lesson, lastUpdated, lastUpdatedBy }</code>. <code>lessonStoreFor</code> returns <code>'ownDoc'</code> for keys in the constant. Every weekly site listed above goes through two helpers: <code>weeklyLessonRef(semKey)</code> and <code>weeklyLessonPath(semKey, lessonKey, field?)</code>. The paths are rooted at <code>lessonKey</code> for <code>'ownDoc'</code> and at <code>semKey.lessonKey</code> for legacy.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:97:  <li><strong>Writes to Spring</strong> go to <code>lessons_K</code>. If it doesn't exist yet (before Phase C), <code>update()</code> would throw <code>not-found</code>, and the rules fence (Phase A) already refuses Spring writes to <code>lessonData</code>. <strong>So from Phase A until Phase C, Spring is read-only</strong> and saves show "Spring 2026 is being moved to new storage — editing is paused." Spring is finished, so Christie confirms this is acceptable (Decisions Log). After Phase C, writes work normally.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:104:<p><strong>Acceptance:</strong> nobody, managers included, can change the <code>spring-2026</code> key of <code>curriculum/lessonData</code>, except a manager update that <em>only deletes</em> that key (Phase D). Everything else about <code>/curriculum</code> behaves exactly as today for every role. It deploys through <code>deploy-rules.sh --approved &lt;sha&gt;</code> after Christie says the phrase. It ships first because it's small, breaks nothing (Spring is dormant), and stops Spring's copy changing while the rest lands.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:105:<p><strong>Shape:</strong> split <code>:654</code> into <code>allow read</code>, <code>allow create</code>, <code>allow update</code> and <code>allow delete</code> for manager+. Both update allowances (manager's, and the classbook roles' at <code>:666</code>) add, for <code>docId == 'lessonData'</code>: <code>!request.resource.data.diff(resource.data).affectedKeys().hasAny(['spring-2026'])</code>, OR (manager only) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; !('spring-2026' in request.resource.data)</code>, which means deleting it and nothing else. <code>diff().affectedKeys()</code> reports top-level keys, so a dotted write to <code>spring-2026.x.qaThread</code> and a stale tab re-creating the key after Phase D both surface as <code>spring-2026</code>.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:107:  teacher / classbook-admin / manager: update fall-2026.x.field            → allowed (as today)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:108:  teacher / classbook-admin / manager: update spring-2026.x.field          → denied
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:109:  manager: update { spring-2026: delete } only                              → allowed
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:110:  manager: update { spring-2026: delete, fall-2026.x: … }                   → denied
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:113:  manager/classbook roles: every other /curriculum doc (appData, prepData, cutProjects, changeLog, lessons_spring-2026, …) → exactly as today
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:116:<div class="note">The Classbook side, before Phase B: a Spring edit fails with the app's normal save-error alert. Spring is dormant, so this should be rare. Studio Hub's alerts only read.</div>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:123:  <li>With <code>lessons_spring-2026</code> absent (the production state after this deploy), the app behaves as today, except Spring edits show "editing is paused" (see Design).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:125:  <li>A <strong>headroom readout</strong> appears in Curriculum Admin → Diagnostics (managers): "Lesson storage: N KB of 1,024 KB", with a warning above 90%.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:126:  <li>Studio Hub alerts include <code>lessons_spring-2026</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:135:  <li><strong>Readers:</strong> <code>readServerSemesterLessonMap</code>, <code>readAdminLessonDoc</code> and <code>computeLiveContentCountByTeacher</code> route through the helpers. The live count sums <code>lessonData</code> plus <code>lessons_spring-2026</code>, so the content-loss comparison stays whole.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:137:  <li><strong>Studio Hub alerts:</strong> add a second listener on <code>curriculum/lessons_spring-2026</code>, iterating its lessons the same way. A missing doc is fine.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:138:  <li><strong>Seed:</strong> a <code>lessons_spring-2026</code> fixture for the emulator scenarios. The default seed keeps Spring in <code>lessonData</code>, so the existing suites are unchanged.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:140:<div class="bdd">Scenario: production state after deploy (lessons_spring-2026 absent) — regression
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:145:  Given lessons_spring-2026 exists and lessonData has no spring-2026
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:147:  Then every write lands in lessons_spring-2026 at lessonKey.field paths; lessonData is untouched
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:155:  Given reading lessons_spring-2026 fails
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:158:Scenario: headroom readout
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:166:<h3>Phase C: copy Spring into its own document (production, one-off, manager) <span class="status-tag not-ready">execution-ready: false</span></h3>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:167:<p><strong>Acceptance:</strong> <code>curriculum/lessons_spring-2026</code> holds exactly what <code>lessonData['spring-2026']</code> holds, the app now serves Spring from it (per the transitional read rule), and Spring is editable again. The old copy stays, frozen by the Phase A fence. It needs Christie's go-ahead, and she runs it at a quiet time.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:168:<p><strong>How:</strong> a console procedure that Christie pastes while signed in as manager, written into this plan before execution and reviewed:</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:171:  <li>One transaction: read <code>lessonData</code> and <code>lessons_spring-2026</code> (which must not exist), then <code>tx.set(lessons_spring-2026, { ...lessonData['spring-2026'], lastUpdated, lastUpdatedBy })</code>, using the map read <em>inside</em> the transaction. It also writes a small record <code>curriculum/storageMigrations</code> → <code>{ 'spring-2026': { copiedAt, copiedBy, lessonCount, sha256 } }</code>, the SHA-256 of a canonical (sorted-key) JSON of the copied map.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:172:  <li>Verify from a forced-server read: every lesson key present, and the hash of <code>lessons_spring-2026</code> minus its <code>lastUpdated*</code> fields equals the recorded hash. Because the Phase A fence means <strong>nothing can change the source</strong>, a deep-equal is valid, which answers round-1 finding B. A mismatch is loud. To undo, a manager deletes the new doc (whole-doc delete; see Q3) and the app falls back to <code>lessonData</code>, which is intact.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:175:  Then lessons_spring-2026 deep-equals lessonData['spring-2026'] (+ lastUpdated*), storageMigrations records count + hash, the app serves Spring from the new doc and edits work
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:181:<h3>Phase D: remove Spring's old copy and free the space (production, one-off, manager) <span class="status-tag not-ready">execution-ready: false</span></h3>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:183:<p><strong>How (console procedure):</strong> a forced-server read of <code>lessonData</code>. It refuses unless the SHA-256 of <code>lessonData['spring-2026']</code> equals the Phase C recorded hash. The fence kept it frozen, so it must equal what the transaction <em>wrote</em>, not the pre-transaction download (round-1 finding C). Then it downloads that copy again as JSON and runs one manager <code>update({ 'spring-2026': FieldValue.delete() })</code>, the one write the fence allows. <strong>This is the plan's only deletion, and it removes a verified, frozen duplicate.</strong></p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:185:  Then lessonData has no spring-2026, lessons_spring-2026 unchanged, Spring fully visible, Fall unaffected
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:188:<div class="note"><strong>Christie's edit to <code>tinker-backups/backup.js</code></strong> must land <em>before</em> Phase D. An agent may not touch that file. After Phase D, <code>computeClassbookContentByTeacher</code> (<code>:370-389</code>) would stop seeing Spring and trip the 10% content-loss alarm for every Spring teacher. The change is to also tally lessons from <code>collections.curriculum['lessons_spring-2026']</code>, and the exact lines will be written out for her in this plan before Phase D.</div>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:196:  <li><strong>Rules:</strong> Phase A is a shared-rules change: rules tests including a near-1 MB fixture, the whole suite green, then <code>deploy-rules.sh --approved &lt;sha&gt;</code> after the phrase. New <code>lessons_*</code> and <code>storageMigrations</code> docs are covered by <code>curriculum/{docId}</code>, so no new rule is needed. The executor re-checks <code>storageMigrations</code> is writable by manager and readable by classbook roles.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:198:  <li><strong>Atomic:</strong> the copy is one transaction. The removal is one update that the rules restrict to deleting exactly that key.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:209:  <li><strong>Mid-C:</strong> the transaction either committed or didn't. If it committed but verify fails, the original is intact, and deleting the new doc restores the old behaviour.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:215:  <li>Read this plan and its Decisions Log. Re-measure lessonData first (Phase B's readout, or the Sep 29 snippet).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:220:<h2 id="decisions">Decisions Log (append-only)</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:231:  <strong>Sep 29, 2026: revision 2, after review round 1 (Claude; <code>thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md</code>): NOT ready, 11-point minimum list, all taken.</strong> Re-scoped to <strong>Spring only, hard-coded</strong>, with no appData flags, <code>migratedSemesters</code>, UI buttons or "Move back". The copy and the removal are reviewed console procedures. The rules fence uses a literal key (no <code>get(appData)</code>), splits <code>:654</code>, and ships <strong>first</strong>. Fixed: the listener drops own-doc semesters (A); verify races (B, moot now that the fence freezes the source first); Phase D's precondition compares against the hash of what was written (C); vanished keys are loud (D); <code>not-found</code> on first write (E); <code>createNewSemester</code>/<code>deleteSemester</code> deferred to the follow-up plan, with a deadline (F, delete); the missing readers are added (<code>tinker-backups/backup.js</code>, which is Christie's edit, the in-app content count, <code>test-alerts.js</code>, dead backup helpers, e2e exemptions, seed); the backup citation and "nightly" are corrected; the listener generation is decided (no bump); teardown uses an array; a near-1 MB rules fixture is added; there's a headroom readout; and the emergency lever's order is fixed.<br>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:232:  <strong>Open questions for Christie:</strong> (Q1) Is it OK that Spring 2026 is read-only ("editing is paused") from Phase A until Phase C, probably a few days? (Q2) Will you make the small <code>backup.js</code> edit before Phase D, or accept one expected content-loss alarm for Spring teachers? (Q3, for the reviewer) Undoing a bad Phase C copy needs a whole-doc delete of <code>lessons_spring-2026</code>; today only classbook-admin/curriculum-admin may whole-doc delete (<code>:675-678</code>). Should Phase A's split give managers delete as well (they have it today through <code>:654</code>'s <code>write</code>)? The plan assumes yes: the split keeps manager delete.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:240:I read the plan in full and verified its claims against the code. Here's what holds and what doesn't.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:252:Failing input: Spring migrated, Fall still legacy. A Fall teacher saves a lesson → legacy snapshot fires → `currentLessonData['spring-2026']` becomes `undefined` in every tab until the `lessons_spring-2026` listener happens to re-fire (it won't; nothing changed there). Spring renders empty. This is the May 2026 incident reproduced on a schedule. The plan's "the live listener follows the same split" doesn't cover it.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:254:**B. Phase 3's verification produces false mismatches that discard real edits.** Step 3 requires `lessons_K` to deep-equal the transaction's source map. But the moment the transaction commits, the fence is live and *all* legitimate saves go to `lessons_K`. Manager clicks Move at 4:00:00; a teacher's save lands in `lessons_K` at 4:00:01; verify reads at 4:00:02 → not equal → loud alert → manager clicks "Move back" → the app reads `lessonData[K]` again and that 4:00:01 edit is orphaned in a document nothing reads. The verify needs to be "every source key present and equal-or-newer by `lastEditedAt`", not deep-equal.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:256:**C. Phase 4's precondition contradicts Phase 3 and will refuse forever.** Phase 4 refuses unless `lessonData[K]` deep-equals *the Phase 3 snapshot*. Phase 3's own BDD says: "a lesson is saved between the snapshot and the transaction → the transaction copies the newer data; the snapshot is older." So one autosave in that window makes the two permanently unequal, and the only phase that actually frees space can never run. Phase 4 must compare against **what the transaction wrote**, persisted at move time — not the pre-transaction download.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:262:**F. `createNewSemester` writes the copied slots to the wrong document.** `saveLessonData(key, emptyLessons)` runs at `app.js:4965`; `currentConfig.semesters[key] = newSem` (carrying `lessonStore:'doc'`) is not assigned until `:4980`. `semesterTypeOf`/`lessonStoreFor` read `currentConfig.semesters[semKey]`, so at write time the new key is still `'weekly'` → the slots land in `curriculum/lessonData`, the new semester reads an empty `lessons_key` and shows zero lessons, and the shared document you're shrinking gains dead weight. The compensating `deleteLessonData(key)` at `:4994` has the same problem in reverse.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:274:| `studio-hub/test-alerts.js:98, 143` | Admin SDK writer of `curriculum/lessonData` (the `qaData` key in the plan's doc shape) | Bypasses rules entirely, so "enforced on the server for every role" isn't literally true. |
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:281:**Also missed — `deleteSemester` breaks for migrated semesters.** `app.js:4585` calls `deleteLessonData(key)` = `update({K: delete})` on `lessonData`. Under Phase 2's stated exception ("a **manager** update that only deletes exactly that key"), a `classbook-admin` deleting a migrated semester is denied — a capability they have today (`firestore.rules:675-678`). And `curriculum/lessons_K` is left orphaned either way.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:291:- **"Narrowing the manager catch-all" is not a narrowing.** `firestore.rules:654` is `allow read, write: if isManagerOrAbove();` and `:666` is a separate `allow create, update`. Rules OR across statements, so you cannot add a condition — you have to split `:654` into separate `read` / `create` / `update` / `delete` statements. The blast radius is contained (only the Classbook and Studio Hub's read-only alerts touch `/curriculum`), but it's a bigger edit than the plan implies, in the file that governs every staff app.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:293:- **Drop the `get(appData)`.** It costs `exists()` + `get()` = two extra billed document reads and a round trip on *every* teacher lesson save; `get()` on a missing doc returns null and `.data` on null denies, so the "behaves as an empty list" BDD needs explicit `exists()` guarding; and — worst — it makes the fence depend on a document managers can write, so "Move back" or a stray appData edit silently disarms it. There are exactly two semesters to migrate. Put the literal in the rule: `!...affectedKeys().hasAny(['spring-2026'])`. One extra rules deploy for Fall, which Phase 5 already plans for. The fence then can only be changed through the guard + sha phrase, which matches your posture everywhere else.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:311:**The ordering is right but the relief is last, and there's no headroom instrumentation.** Nothing is freed until Phase 4, which sits behind: a large Phase 1 refactor + one Netlify deploy + one Studio Hub deploy → a shared rules change + sha approval + deploy → new manager UI with a transaction → a production run → "a few days" → Phase 4. Realistically one to three weeks against 52 KB of headroom, while Fall is actively being written into the same document. Meanwhile the only headroom monitor is "run a console snippet every few days" — a human polling loop.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:317:1. **Narrow the first pass to Spring, hard-coded.** Spring 2026 ran Jan–May; it is finished and nobody edits it. Drop `migratedSemesters`, the `lessonStore` config flag, the appData `get()` in rules, "Move back", and both manager buttons. Phase 3 becomes a one-off snapshot + copy + verify (the same manual, console-driven shape you already use for migrations), not a new transaction-plus-two-buttons UI surface that is itself new code capable of losing data. Generalize for Fall in Phase 5, where the second semester justifies the abstraction.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:319:3. **Add a headroom readout to the admin Diagnostics panel in Phase 1** (client-side, read-only), so 52 KB isn't tracked by a human remembering to paste a snippet.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:328:3. Phase 3 verification: equal-or-newer by `lastEditedAt`, not deep-equal, and persist the transaction's source map (or hash) as the record.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:329:4. Phase 4 precondition: compare against what the transaction wrote, not the pre-transaction snapshot. As written it can never run.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:336:11. Re-scope to one hard-coded semester for the first pass; add a headroom readout; fix the emergency lever's ordering.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:380:    36	  <strong>Touches:</strong> the Classbook (<code>js/firebase-data.js</code>, <code>js/app.js</code>), <code>studio-hub/firestore.rules</code> + <code>studio-hub/rules.test.js</code> (sha phrase + guard), <code>studio-hub/js/alerts.js</code> (Studio Hub deploy), and <code>tinker-backups/backup.js</code>, <strong>which only Christie edits</strong> (memory: <code>backup-js-uses-cli-token</code>).<br>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:385:    41	  <strong>Emergency lever (corrected order).</strong> Only after Phase B's read-side code is live, never before, and only with Christie's explicit go-ahead: run Phases C and D back-to-back instead of days apart. Deleting Spring from <code>lessonData</code> before the app can read <code>lessons_spring-2026</code> would make Spring look empty, which is the May 2026 incident on purpose. Phase B adds a headroom readout, so nobody has to remember to paste a snippet.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:388:    44	<h2 id="today">What exists today (research, verified in review round 1)</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:396:    52	  <tr><td>Rules: <code>:654</code> is <code>allow read, write: if isManagerOrAbove()</code>, and <code>:666</code> is a separate create/update for classbook roles (not appData/prepCycleConfig). Rules OR across statements, so fencing a key for managers too means <strong>splitting <code>:654</code></strong> into per-operation statements. Whole-doc delete is limited to classbook-admin/curriculum-admin (<code>:675-678</code>). <code>studio-hub/rules.test.js</code> has no <code>curriculum/lessonData</code> fixture today.</td><td><code>studio-hub/firestore.rules:652-678</code></td></tr>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:399:    55	      <li>Studio Hub's Q&amp;A alerts (<code>studio-hub/js/alerts.js:559-580</code>, iterating every top-level key).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:401:    57	      <li><code>studio-hub/test-alerts.js:98, 143</code>: an Admin SDK test script that writes <code>lessonData.qaData</code>. It bypasses rules and isn't part of the app.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:409:    65	  <li><strong>Where Spring lives:</strong> <code>curriculum/lessons_spring-2026</code> = <code>{ &lt;lessonKey&gt;: lesson, lastUpdated, lastUpdatedBy }</code>. <code>lessonStoreFor</code> returns <code>'ownDoc'</code> for keys in the constant. Every weekly site listed above goes through two helpers: <code>weeklyLessonRef(semKey)</code> and <code>weeklyLessonPath(semKey, lessonKey, field?)</code>. The paths are rooted at <code>lessonKey</code> for <code>'ownDoc'</code> and at <code>semKey.lessonKey</code> for legacy.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:411:    67	  <li><strong>Writes to Spring</strong> go to <code>lessons_K</code>. If it doesn't exist yet (before Phase C), <code>update()</code> would throw <code>not-found</code>, and the rules fence (Phase A) already refuses Spring writes to <code>lessonData</code>. <strong>So from Phase A until Phase C, Spring is read-only</strong> and saves show "Spring 2026 is being moved to new storage — editing is paused." Spring is finished, so Christie confirms this is acceptable (Decisions Log). After Phase C, writes work normally.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:418:    74	<p><strong>Acceptance:</strong> nobody, managers included, can change the <code>spring-2026</code> key of <code>curriculum/lessonData</code>, except a manager update that <em>only deletes</em> that key (Phase D). Everything else about <code>/curriculum</code> behaves exactly as today for every role. It deploys through <code>deploy-rules.sh --approved &lt;sha&gt;</code> after Christie says the phrase. It ships first because it's small, breaks nothing (Spring is dormant), and stops Spring's copy changing while the rest lands.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:419:    75	<p><strong>Shape:</strong> split <code>:654</code> into <code>allow read</code>, <code>allow create</code>, <code>allow update</code> and <code>allow delete</code> for manager+. Both update allowances (manager's, and the classbook roles' at <code>:666</code>) add, for <code>docId == 'lessonData'</code>: <code>!request.resource.data.diff(resource.data).affectedKeys().hasAny(['spring-2026'])</code>, OR (manager only) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; !('spring-2026' in request.resource.data)</code>, which means deleting it and nothing else. <code>diff().affectedKeys()</code> reports top-level keys, so a dotted write to <code>spring-2026.x.qaThread</code> and a stale tab re-creating the key after Phase D both surface as <code>spring-2026</code>.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:421:    77	  teacher / classbook-admin / manager: update fall-2026.x.field            → allowed (as today)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:422:    78	  teacher / classbook-admin / manager: update spring-2026.x.field          → denied
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:423:    79	  manager: update { spring-2026: delete } only                              → allowed
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:424:    80	  manager: update { spring-2026: delete, fall-2026.x: … }                   → denied
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:427:    83	  manager/classbook roles: every other /curriculum doc (appData, prepData, cutProjects, changeLog, lessons_spring-2026, …) → exactly as today
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:430:    86	<div class="note">The Classbook side, before Phase B: a Spring edit fails with the app's normal save-error alert. Spring is dormant, so this should be rare. Studio Hub's alerts only read.</div>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:437:    93	  <li>With <code>lessons_spring-2026</code> absent (the production state after this deploy), the app behaves as today, except Spring edits show "editing is paused" (see Design).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:439:    95	  <li>A <strong>headroom readout</strong> appears in Curriculum Admin → Diagnostics (managers): "Lesson storage: N KB of 1,024 KB", with a warning above 90%.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:440:    96	  <li>Studio Hub alerts include <code>lessons_spring-2026</code>.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:449:   105	  <li><strong>Readers:</strong> <code>readServerSemesterLessonMap</code>, <code>readAdminLessonDoc</code> and <code>computeLiveContentCountByTeacher</code> route through the helpers. The live count sums <code>lessonData</code> plus <code>lessons_spring-2026</code>, so the content-loss comparison stays whole.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:451:   107	  <li><strong>Studio Hub alerts:</strong> add a second listener on <code>curriculum/lessons_spring-2026</code>, iterating its lessons the same way. A missing doc is fine.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:452:   108	  <li><strong>Seed:</strong> a <code>lessons_spring-2026</code> fixture for the emulator scenarios. The default seed keeps Spring in <code>lessonData</code>, so the existing suites are unchanged.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:454:   110	<div class="bdd">Scenario: production state after deploy (lessons_spring-2026 absent) — regression
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:459:   115	  Given lessons_spring-2026 exists and lessonData has no spring-2026
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:461:   117	  Then every write lands in lessons_spring-2026 at lessonKey.field paths; lessonData is untouched
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:469:   125	  Given reading lessons_spring-2026 fails
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:472:   128	Scenario: headroom readout
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:480:   136	<h3>Phase C: copy Spring into its own document (production, one-off, manager) <span class="status-tag not-ready">execution-ready: false</span></h3>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:481:   137	<p><strong>Acceptance:</strong> <code>curriculum/lessons_spring-2026</code> holds exactly what <code>lessonData['spring-2026']</code> holds, the app now serves Spring from it (per the transitional read rule), and Spring is editable again. The old copy stays, frozen by the Phase A fence. It needs Christie's go-ahead, and she runs it at a quiet time.</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:482:   138	<p><strong>How:</strong> a console procedure that Christie pastes while signed in as manager, written into this plan before execution and reviewed:</p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:485:   141	  <li>One transaction: read <code>lessonData</code> and <code>lessons_spring-2026</code> (which must not exist), then <code>tx.set(lessons_spring-2026, { ...lessonData['spring-2026'], lastUpdated, lastUpdatedBy })</code>, using the map read <em>inside</em> the transaction. It also writes a small record <code>curriculum/storageMigrations</code> → <code>{ 'spring-2026': { copiedAt, copiedBy, lessonCount, sha256 } }</code>, the SHA-256 of a canonical (sorted-key) JSON of the copied map.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:486:   142	  <li>Verify from a forced-server read: every lesson key present, and the hash of <code>lessons_spring-2026</code> minus its <code>lastUpdated*</code> fields equals the recorded hash. Because the Phase A fence means <strong>nothing can change the source</strong>, a deep-equal is valid, which answers round-1 finding B. A mismatch is loud. To undo, a manager deletes the new doc (whole-doc delete; see Q3) and the app falls back to <code>lessonData</code>, which is intact.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:489:   145	  Then lessons_spring-2026 deep-equals lessonData['spring-2026'] (+ lastUpdated*), storageMigrations records count + hash, the app serves Spring from the new doc and edits work
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:495:   151	<h3>Phase D: remove Spring's old copy and free the space (production, one-off, manager) <span class="status-tag not-ready">execution-ready: false</span></h3>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:497:   153	<p><strong>How (console procedure):</strong> a forced-server read of <code>lessonData</code>. It refuses unless the SHA-256 of <code>lessonData['spring-2026']</code> equals the Phase C recorded hash. The fence kept it frozen, so it must equal what the transaction <em>wrote</em>, not the pre-transaction download (round-1 finding C). Then it downloads that copy again as JSON and runs one manager <code>update({ 'spring-2026': FieldValue.delete() })</code>, the one write the fence allows. <strong>This is the plan's only deletion, and it removes a verified, frozen duplicate.</strong></p>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:499:   155	  Then lessonData has no spring-2026, lessons_spring-2026 unchanged, Spring fully visible, Fall unaffected
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:502:   158	<div class="note"><strong>Christie's edit to <code>tinker-backups/backup.js</code></strong> must land <em>before</em> Phase D. An agent may not touch that file. After Phase D, <code>computeClassbookContentByTeacher</code> (<code>:370-389</code>) would stop seeing Spring and trip the 10% content-loss alarm for every Spring teacher. The change is to also tally lessons from <code>collections.curriculum['lessons_spring-2026']</code>, and the exact lines will be written out for her in this plan before Phase D.</div>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:510:   166	  <li><strong>Rules:</strong> Phase A is a shared-rules change: rules tests including a near-1 MB fixture, the whole suite green, then <code>deploy-rules.sh --approved &lt;sha&gt;</code> after the phrase. New <code>lessons_*</code> and <code>storageMigrations</code> docs are covered by <code>curriculum/{docId}</code>, so no new rule is needed. The executor re-checks <code>storageMigrations</code> is writable by manager and readable by classbook roles.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:512:   168	  <li><strong>Atomic:</strong> the copy is one transaction. The removal is one update that the rules restrict to deleting exactly that key.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:523:   179	  <li><strong>Mid-C:</strong> the transaction either committed or didn't. If it committed but verify fails, the original is intact, and deleting the new doc restores the old behaviour.</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:529:   185	  <li>Read this plan and its Decisions Log. Re-measure lessonData first (Phase B's readout, or the Sep 29 snippet).</li>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:534:   190	<h2 id="decisions">Decisions Log (append-only)</h2>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:545:   201	  <strong>Sep 29, 2026: revision 2, after review round 1 (Claude; <code>thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md</code>): NOT ready, 11-point minimum list, all taken.</strong> Re-scoped to <strong>Spring only, hard-coded</strong>, with no appData flags, <code>migratedSemesters</code>, UI buttons or "Move back". The copy and the removal are reviewed console procedures. The rules fence uses a literal key (no <code>get(appData)</code>), splits <code>:654</code>, and ships <strong>first</strong>. Fixed: the listener drops own-doc semesters (A); verify races (B, moot now that the fence freezes the source first); Phase D's precondition compares against the hash of what was written (C); vanished keys are loud (D); <code>not-found</code> on first write (E); <code>createNewSemester</code>/<code>deleteSemester</code> deferred to the follow-up plan, with a deadline (F, delete); the missing readers are added (<code>tinker-backups/backup.js</code>, which is Christie's edit, the in-app content count, <code>test-alerts.js</code>, dead backup helpers, e2e exemptions, seed); the backup citation and "nightly" are corrected; the listener generation is decided (no bump); teardown uses an array; a near-1 MB rules fixture is added; there's a headroom readout; and the emergency lever's order is fixed.<br>
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:546:   202	  <strong>Open questions for Christie:</strong> (Q1) Is it OK that Spring 2026 is read-only ("editing is paused") from Phase A until Phase C, probably a few days? (Q2) Will you make the small <code>backup.js</code> edit before Phase D, or accept one expected content-loss alarm for Spring teachers? (Q3, for the reviewer) Undoing a bad Phase C copy needs a whole-doc delete of <code>lessons_spring-2026</code>; today only classbook-admin/curriculum-admin may whole-doc delete (<code>:675-678</code>). Should Phase A's split give managers delete as well (they have it today through <code>:654</code>'s <code>write</code>)? The plan assumes yes: the split keeps manager delete.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:558:/bin/zsh -lc "git rev-parse --short HEAD && git status --short && rg -n --hidden --glob '"'!node_modules/**'"' \"lessonData|lessons_spring|storageMigrations|setupLessonDataListener|lessonStoreFor|currentLessonData\" js e2e *.html 2>/dev/null" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:674:js/app.js:4611:    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:1003:e2e/data-safety.spec.js:3539:        return { alerts, logged, cacheTarget: JSON.parse(JSON.stringify(currentLessonData[semKey][targetKey])) };
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:1150:nl -ba /Users/christiehubley/studio-hub/js/alerts.js | sed -n '500,620p'
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:1731:  1346	  console.log('✅ Save verified on server:', writtenContentFields);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2145:  3624	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2159:  3638	    alert(err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2163:  3642	    alert('Summer camp questions are sent from the camp lesson editor.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2176:  3655	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2180:  3659	    alert('This lesson was moved or removed elsewhere. Your message was not sent — please close this and check the classbook for its new location.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2186:  3665	  const isAdmin = ['admin', 'manager'].includes(user?.role);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2214:  3693	    alert('Error sending message: ' + err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2293:  4531	    alert('Cannot delete the active semester.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2307:  4545	    catch (err) { alert(`Could not check "${sem.name}" for events: ${err.message}\n\nNothing was changed.`); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2308:  4546	    if (events > 0) { alert(`"${sem.name}" still has ${events} event${events === 1 ? '' : 's'}. Remove its events first.`); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2322:  4560	  // semester the server still has — with no alert and no re-render to show it
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2331:  4569	    alert(`Could not remove "${sem.name}": ${err.message}\n\nNothing was changed.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2368:  4606	  if (!isPublishableType(key)) { alert('This semester type can\'t be published.'); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2373:  4611	    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2389:  4627	    alert(`Could not ${published ? 'publish' : 'unpublish'} that semester: ${err.message}\n\nNothing was changed.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2454:  4692	  if (!isIsoDate(startDate) || !isIsoDate(endDate)) { alert('Pick the school year\'s start and end dates.'); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2455:  4693	  if (endDate <= startDate) { alert('The school year has to end after it starts.'); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2456:  4694	  if (!name) { alert('Give the school year a name.'); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2458:  4696	  if (currentConfig.semesters?.[key]) { alert(`${currentConfig.semesters[key].name} already exists (${key}).`); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2464:  4702	      alert(`A school year with key "${key}" was already created (in another tab, or by another admin). Reload to see it.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2473:  4711	    alert(`Could not create that school year: ${err.message}`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2487:  4725	    alert(`${name} created. It stays hidden from teachers. Next: add its teacher names in Settings, then its day-off dates and camps in Curriculum Admin.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2490:  4728	    alert(`${name} was created, but the page didn't refresh properly — reload to see it.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2581:  4819	  if (!season || !registry) { alert('Pick a season first.'); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2584:  4822	  if (currentConfig.semesters?.[key]) { alert(`Summer ${season} is already in the Classbook.`); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2590:  4828	    alert(`Summer ${season} isn't ready yet: the Summer Camp App's season still needs ${problems.join(', ')}. Finish setting it up there, then add it here.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2599:  4837	      alert(`Summer ${season} was already added (in another tab, or by another admin). Reload to see it.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2608:  4846	    alert(`${newSem.name} added. It stays hidden from teachers until you publish it, and its camps appear here as the Summer Camp App publishes them.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2612:  4850	    alert(`Could not add that season: ${err.message}`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2623:  4861	  if (!name) { alert('Semester name is required.'); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2627:  4865	    alert(`A semester with key "${key}" already exists.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2675:  4913	      // surviving lesson data — the remedy this alert points at.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2678:  4916	        alert(`Lesson content already exists in Firestore under the key "${key}".\n\nIf it was left over from a deleted semester, create this semester again without "Copy from" to adopt that data.\n\nIf another admin may have just created it, reload this page first.\n\nOtherwise choose a different name.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2761:  4999	    alert('Could not create the new semester. Please try again.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2901:  5558	  if (!title) { alert('Project title is required.'); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2907:  5564	    alert('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2993:  5650	      alert("Couldn't confirm this lesson still exists — check your connection and try saving again.");
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:2997:  5654	      alert('This lesson was moved or removed elsewhere while you had it open. Your changes were not saved — please close this window and check the grid for its new location.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3025:  5682	    alert('This lesson is no longer in the summer schedule — reload and try again. Nothing was saved.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3042:  5699	      alert(`Summer camp ${refused.map(f => labels[f]).join(', ')} are managed in the Summer Camp App — that change is not saved here.` + (changedFields.length > refused.length || hasNewPhoto || pendingRemove ? ' Your other edits will still be saved.' : ''));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3077:  5734	      if (file.size > 5 * 1024 * 1024) { alert('Photo must be under 5MB.'); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3115:  5772	    alert('This edit could not be saved. Please try again.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3188:  5845	// machine loop; closing it fully would need a Firestore transaction.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3295:  5952	      alert(`Move could not be saved — "${preMoveSourceLesson.projectTitle}" has been restored to its original slot. Nothing was changed.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3367:  6024	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" and "${destLesson.projectTitle}" have been restored to their original slots.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3385:  6042	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" has been restored to its original slot.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3444:  6860	    alert('No ideas in the bank. Add some in the Future Projects section first.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3537:  6953	    alert(`Could not paste "${proj.title}" — please try again. The idea is still in the bank.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3572:  6988	    alert(`"${proj.title}" was placed on the grid, but could NOT be removed from the Idea Bank — it may now appear in both places. Please reload and check.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3731:  7147	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3741:  7157	    alert(err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3752:  7168	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3756:  7172	    alert('This lesson was moved or removed elsewhere. Your response was not sent — please close this and check the grid for its new location.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3792:  7208	    alert('Error sending response: ' + err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3816:  7232	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3826:  7242	    alert(err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3837:  7253	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3841:  7257	    alert('This lesson was moved or removed elsewhere. Your reply was not sent — please close this window and check the grid for its new location.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3875:  7291	    alert('Error sending reply: ' + err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3911:  7471	    // panel without being a manager, and would hit this on every load. That's
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:3915:  7475	      container.innerHTML = '<p class="ca-empty-hint">Backup status is visible to admins and managers only.</p>';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4030:  7590	      // backupStatus is manager/admin-only (same boundary as Backup Health) —
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4063: 11282	        alert(`Can't remove ${inUse.map(u => `${u.name} (on ${u.camps.join(', ')})`).join('; ')} — take them off those camps first.\n\nNothing was saved.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4068: 11287	        alert(`These day-off dates would fall outside the school year: ${outside.map(o => `${o.label} ${o.date}`).join(', ')}. Edit those events first.\n\nNothing was saved.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4072: 11291	      alert(`Could not check the school year's camps and events: ${err.message}\n\nNothing was saved.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4122: 11341	    alert('Settings saved!');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4135: 11354	    alert('Error saving settings: ' + err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4217:   605	          // Shared, non-manager user — tick action items and nothing else.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4252:   640	    //   appData (Settings doc): manager+ only, always.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4259:   647	    //   appData (Settings doc): manager+ only, always.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4269:   657	      // appData (Settings) is manager+ only, always
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4301:   689	    //     classbook-admin (+ manager+) write, plain classbook teachers read.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4339:   516	              // Only show alert if meeting is older than 3 days
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4342:   519	                const alertId = `recap-meeting-${doc.id}`;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4345:   522	                  id: alertId,
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4360:   537	        // Remove old Recap alerts that are no longer valid
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4362:   539	        alerts.forEach(alert => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4363:   540	          if (alert.type === 'recap' && !currentRecapAlertIds.includes(alert.id)) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4364:   541	            removeAlert(alert.id);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4368:   545	        // Update all meeting alerts
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4369:   546	        meetingAlerts.forEach(alert => addOrUpdateAlert(alert));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4384:   561	    // Teacher questions - ALL unanswered questions (immediate alerts)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4415:   592	              const alertId = `classbook-qa-${lessonKey}`;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4416:   593	              currentClassbookAlertIds.push(alertId);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4439:   616	              const alert = {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4440:   617	                id: alertId,
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4689:rg -n \"curriculum|lessonData|classbook|curriculum-admin|manager\" /Users/christiehubley/studio-hub/rules.test.js" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4711:   640	    //   appData (Settings doc): manager+ only, always.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4718:   647	    //   appData (Settings doc): manager+ only, always.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4728:   657	      // appData (Settings) is manager+ only, always
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4760:   689	    //     classbook-admin (+ manager+) write, plain classbook teachers read.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4771:    10	 *   managerUser  — role: 'manager'
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4780:    19	 *   archivedManagerUser — role: 'manager', active: false
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4795:    34	const MANAGER_UID = 'manager-uid';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4818:    57	const ARCHIVED_MANAGER_UID = 'archived-manager-uid';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4827:    66	const DISPOSABLE_ARCHIVED_MANAGER_FOR_REACTIVATE_UID = 'disposable-archived-manager-for-reactivate-uid';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4845:    84	    await setDoc(doc(db, 'users', MANAGER_UID),        { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [] });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4862:   101	    await setDoc(doc(db, 'users', ARCHIVED_MANAGER_UID), { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [], active: false });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4869:   108	    await setDoc(doc(db, 'users', DISPOSABLE_ARCHIVED_MANAGER_FOR_REACTIVATE_UID), { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [], active: false });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4894:   133	      '2026-01-01_2026-01-14': { lockedAt: '2026-01-15T00:00:00.000Z', lockedBy: 'manager', employeeTotals: {} },
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4901:   140	    // A manager's in-progress draft about the same staff member. Drafts are unfinished,
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4905:   144	    // status was enforced. Staff must fail CLOSED on it; the manager must NOT be locked out.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4909:   148	    // Shared with a non-manager coordinator (TRAINING_UID) -- a record about someone else.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4946:   185	    // Only ever deleted by the manager delete test — nothing else may depend on it.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4957:   196	    // by a non-manager staff member" case)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:4971:   210	    // bypass tests (a manager attempting to flip someone else's meeting to personal)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5046:   285	  test('manager can read payroll', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5076:   315	  test('manager can write payroll', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5088:   327	// ─── FINANCE — PAYROLL SETTINGS HISTORY (append-only, transaction-tied) ──────
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5091:   330	// Every entry must be created inside the same transaction that writes the
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5096:   335	const MANAGER_EMAIL = 'manager@tinkerartstudio.com';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5102:10: *   managerUser  — role: 'manager'
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5104:19: *   archivedManagerUser — role: 'manager', active: false
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5105:34:const MANAGER_UID = 'manager-uid';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5110:57:const ARCHIVED_MANAGER_UID = 'archived-manager-uid';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5111:66:const DISPOSABLE_ARCHIVED_MANAGER_FOR_REACTIVATE_UID = 'disposable-archived-manager-for-reactivate-uid';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5112:84:    await setDoc(doc(db, 'users', MANAGER_UID),        { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [] });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5115:101:    await setDoc(doc(db, 'users', ARCHIVED_MANAGER_UID), { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [], active: false });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5118:108:    await setDoc(doc(db, 'users', DISPOSABLE_ARCHIVED_MANAGER_FOR_REACTIVATE_UID), { role: 'manager', studios: ['tinker', 'clayhub'], appAccess: [], active: false });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5119:133:      '2026-01-01_2026-01-14': { lockedAt: '2026-01-15T00:00:00.000Z', lockedBy: 'manager', employeeTotals: {} },
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5120:140:    // A manager's in-progress draft about the same staff member. Drafts are unfinished,
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5121:144:    // status was enforced. Staff must fail CLOSED on it; the manager must NOT be locked out.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5122:148:    // Shared with a non-manager coordinator (TRAINING_UID) -- a record about someone else.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5125:185:    // Only ever deleted by the manager delete test — nothing else may depend on it.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5126:196:    // by a non-manager staff member" case)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5127:210:    // bypass tests (a manager attempting to flip someone else's meeting to personal)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5131:285:  test('manager can read payroll', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5132:315:  test('manager can write payroll', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5133:335:const MANAGER_EMAIL = 'manager@tinkerartstudio.com';
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5134:400:  test('manager can get a history entry', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5135:405:  test('manager can list/query history', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5136:425:  test('archived manager cannot read history', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5137:431:  test('manager can create an entry inside the transaction that bumps the parent rev (real serverTimestamp)', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5138:466:  test('archived manager cannot create history', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5139:521:  test('manager cannot update a history entry', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5140:526:  test('manager cannot delete a history entry', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5141:551:  test('manager can read kpiData without appAccess', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5142:559:// enrollment numbers (fill rates, teacher first names) behind the same manager+/appAccess
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5143:569:  test('manager can read enrollmentBoard/current without appAccess', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5144:636:  test('manager can read any entry', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5151:743:  test('manager can update appData', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5162:775:  test('manager can delete a curriculum doc', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5171:879:  // no request.auth.uid != userId guard, so a manager writing to THEIR OWN
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5172:883:  // clayInventory) doesn't accept isManagerOrAbove(), so a manager scoped to
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5173:885:  test('manager CANNOT self-grant studios via the manager-update rule (regression)', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5174:892:  test('manager CANNOT self-grant appAccess via the manager-update rule (regression)', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5175:899:  test('manager CAN still grant appAccess/studios to ANOTHER user (legitimate team management, unaffected by the fix)', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5176:947:  test('manager CANNOT archive an admin (write active:false to an active admin doc)', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5177:954:  test('manager CANNOT reactivate an admin (write active:true to an archived admin doc)', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5178:961:  test('manager CAN archive another staff member (unchanged from existing appAccess/studios capability)', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5179:968:  test('manager CAN reactivate another manager (unchanged from existing appAccess/studios capability)', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5180:979:  // recovery path — same bug shape as the manager self-grant regression
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5181:1010:  test('archived manager cannot read payroll (previously isManagerOrAbove()-gated)', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5182:1032:  test('manager can delete a training module', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5183:1047:  test('manager can delete a training assignment', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5184:1052:  test('staff cannot create/write an observation record about themselves (manager-authored only)', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5185:1063:  // is a manager's unfinished, unreviewed assessment; the Training Hub only hides drafts
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5186:1072:  test('manager can read a draft observation record', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5187:1119:  // ─── Sharing a single observation with a named non-manager ───
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5188:1148:  test('a manager can still read a malformed-sharedWith record', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5189:1152:  // The whole point of the design: sharing is manager-written. Staff have no write on this
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5190:1210:  // ...but the manager branch never touches resource.data, so it must not be caught by the
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5191:1211:  // missing-field evaluation error. This is the lockout guard: managers keep full access.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5192:1212:  test('manager can still read a status-less legacy observation', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5193:1227:  // Guards the manager branch against a future edit adding a resource.data condition to it,
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5194:1228:  // which would break the manager's own observation list with nothing else noticing.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5195:1229:  test('manager can run an unfiltered query including drafts', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5196:1258:// appAccess('training') override for these collections: only manager+ can
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5197:1262:describe('Training Hub — onboarding/compliance collections are manager-only', () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5198:1273:  test('manager can read and delete onboarding checklists', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5203:1294:  test('manager can delete shared curriculum', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5207:1329:    ['manager', () => MANAGER_UID],
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5210:1365:    ['an archived manager', () => ARCHIVED_MANAGER_UID],
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5211:1378:describe('Summer Camp — only manager+ may write the season registry', () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5212:1379:  test('a manager can create, update and delete a season doc', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5215:1398:    ['an archived manager', () => ARCHIVED_MANAGER_UID],
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5216:1406:  test('nobody below manager can move _current — the switch-on is a manager act', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5217:1421:// left to the app, because a manager (or a migration resumed by hand) getting either one wrong
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5219:1539:      season: '2031', setAt: new Date().toISOString(), setBy: 'manager'
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5221:1546:  ])('%s cannot run the migration — stamping is a manager+ write', async (_label, uid) => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5223:1562:  test('manager CANNOT read another user\'s personal meeting', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5224:1567:  test('manager can read a non-personal meeting', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5225:1577:  test('non-creator, non-manager, non-shared staff CANNOT read a non-personal meeting', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5226:1580:    // doesn't throw on a missing field for a requester who fails the manager branch too.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5227:1608:  test('manager cannot create a business:personal meeting', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5228:1610:    await assertFails(setDoc(doc(db, 'meetings', 'disposable-manager-personal-create'), {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5229:1629:  test('a manager cannot flip someone else\'s non-personal meeting to business:personal', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5230:1662:// cannot be made a manager) and must tick off tasks on meetings Christie shares
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5231:1665:// non-manager user to change that and only that: no other top-level field in the
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5232:1742:  test('a user NOT in sharedWith (and not creator or manager) is still denied the same write', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5233:1848:describe('Recap — Phase 3: the creator and manager branches are unchanged', () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5234:1849:  test('a manager can still edit any field on a non-personal meeting they did not create', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5235:1850:    await seedDisposableSharedMeeting('disposable-phase3-manager-edit');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5236:1852:    await assertSucceeds(updateDoc(doc(db, 'meetings', 'disposable-phase3-manager-edit'), {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5237:1853:      title: 'Renamed by manager',
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5238:1854:      'summary.keyDiscussion': ['rewritten by manager'],
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5239:1869:// ─── RECAP — sharedWith is pinned for non-manager creators ──────────────────
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5240:1871:// Sharing is a manager/admin call (UI-level since Sep 5, 2026). This closes the
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5241:1890:    // manager shares it. Second-review finding: no test covered absence.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5242:1913:  test('a manager can still share someone else\'s non-personal meeting (the Share modal write)', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5243:1914:    await seedDisposableSharedMeeting('disposable-phase3-manager-share', { sharedWith: [] });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5244:1916:    await assertSucceeds(updateDoc(doc(db, 'meetings', 'disposable-phase3-manager-share'), {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5245:1939:  test('a manager can create a meeting that is already shared', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5246:1941:    await assertSucceeds(setDoc(doc(db, 'meetings', 'disposable-manager-create-shared'), {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5247:1942:      createdBy: MANAGER_UID, business: 'tinker', title: 'Pre-shared by manager', sharedWith: [OTHER_RECAP_UID],
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5248:1946:  test('a manager can still share their OWN meeting', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5249:1947:    await seedDisposableSharedMeeting('disposable-phase3-manager-own-share', { createdBy: MANAGER_UID, sharedWith: [] });
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5250:1949:    await assertSucceeds(updateDoc(doc(db, 'meetings', 'disposable-phase3-manager-own-share'), {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5251:2010:    await assertFails(setDoc(doc(admin, 'users', REMINDER_BOT_UID), { role: 'manager', studios: ['tinker'], appAccess: [] }));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5252:2013:    // so a manager-role doc still opens nothing, and the bot cannot patch it either.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5253:2024:      await assertFails(updateDoc(doc(admin, 'users', REMINDER_BOT_UID), { role: 'manager' }));   // admin update of it: denied
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5254:2047:describe('Tinker Ticker — timeclock_reminder_log: the bot claims, resolves, and can do nothing else; managers read; staff never', () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5255:2166:  test('managers and admins read the log (get + list); nobody else can, and nobody but the bot can write it', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5261:2190:const SDOC_ADMIN_WRITERS = [['admin', ADMIN_UID], ['manager', MANAGER_UID], ['classbook-admin', CLASSBOOK_ADMIN_UID]];
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5262:2193:  ['archived admin', ARCHIVED_ADMIN_UID], ['archived manager', ARCHIVED_MANAGER_UID], ['archived staff', ARCHIVED_STAFF_UID],
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5273:2323:// Reassign is manager-only in the UI; a staff creator reassigns by dragging in
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5274:2329:  test('a manager can reassign AND share in one write (beforeNextMeeting + sharedWith + share metadata)', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5275:2485:  test.each([['Clay Hub staff', CLAY_MEMBERSHIP_STAFF_UID], ['a manager', MANAGER_UID], ['an admin', ADMIN_UID]])(
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5276:2495:  test.each([['Clay Hub staff', CLAY_MEMBERSHIP_STAFF_UID], ['a manager', MANAGER_UID], ['an admin', ADMIN_UID]])(
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5277:2538:  test('delete is unchanged: manager yes, Clay Hub staff no', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5278:2558:  test('managers keep full access to waitlist and appData (shared helper refactor)', async () => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5283:nl -ba /Users/christiehubley/studio-hub/js/alerts.js | sed -n '556,670p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5702:  3624	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5716:  3638	    alert(err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5720:  3642	    alert('Summer camp questions are sent from the camp lesson editor.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5733:  3655	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5737:  3659	    alert('This lesson was moved or removed elsewhere. Your message was not sent — please close this and check the classbook for its new location.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5743:  3665	  const isAdmin = ['admin', 'manager'].includes(user?.role);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5771:  3693	    alert('Error sending message: ' + err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5804:  4560	  // semester the server still has — with no alert and no re-render to show it
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5813:  4569	    alert(`Could not remove "${sem.name}": ${err.message}\n\nNothing was changed.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5850:  4606	  if (!isPublishableType(key)) { alert('This semester type can\'t be published.'); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5855:  4611	    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5871:  4627	    alert(`Could not ${published ? 'publish' : 'unpublish'} that semester: ${err.message}\n\nNothing was changed.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5936:  4692	  if (!isIsoDate(startDate) || !isIsoDate(endDate)) { alert('Pick the school year\'s start and end dates.'); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5937:  4693	  if (endDate <= startDate) { alert('The school year has to end after it starts.'); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5938:  4694	  if (!name) { alert('Give the school year a name.'); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5940:  4696	  if (currentConfig.semesters?.[key]) { alert(`${currentConfig.semesters[key].name} already exists (${key}).`); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5946:  4702	      alert(`A school year with key "${key}" was already created (in another tab, or by another admin). Reload to see it.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5955:  4711	    alert(`Could not create that school year: ${err.message}`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5969:  4725	    alert(`${name} created. It stays hidden from teachers. Next: add its teacher names in Settings, then its day-off dates and camps in Curriculum Admin.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:5972:  4728	    alert(`${name} was created, but the page didn't refresh properly — reload to see it.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6063:  4819	  if (!season || !registry) { alert('Pick a season first.'); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6066:  4822	  if (currentConfig.semesters?.[key]) { alert(`Summer ${season} is already in the Classbook.`); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6072:  4828	    alert(`Summer ${season} isn't ready yet: the Summer Camp App's season still needs ${problems.join(', ')}. Finish setting it up there, then add it here.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6081:  4837	      alert(`Summer ${season} was already added (in another tab, or by another admin). Reload to see it.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6090:  4846	    alert(`${newSem.name} added. It stays hidden from teachers until you publish it, and its camps appear here as the Summer Camp App publishes them.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6094:  4850	    alert(`Could not add that season: ${err.message}`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6105:  4861	  if (!name) { alert('Semester name is required.'); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6109:  4865	    alert(`A semester with key "${key}" already exists.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6157:  4913	      // surviving lesson data — the remedy this alert points at.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6160:  4916	        alert(`Lesson content already exists in Firestore under the key "${key}".\n\nIf it was left over from a deleted semester, create this semester again without "Copy from" to adopt that data.\n\nIf another admin may have just created it, reload this page first.\n\nOtherwise choose a different name.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6243:  4999	    alert('Could not create the new semester. Please try again.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6259:  5564	    alert('Lesson data failed to load — refusing to save to avoid writing over unconfirmed server state. Reload and try again.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6345:  5650	      alert("Couldn't confirm this lesson still exists — check your connection and try saving again.");
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6349:  5654	      alert('This lesson was moved or removed elsewhere while you had it open. Your changes were not saved — please close this window and check the grid for its new location.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6377:  5682	    alert('This lesson is no longer in the summer schedule — reload and try again. Nothing was saved.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6394:  5699	      alert(`Summer camp ${refused.map(f => labels[f]).join(', ')} are managed in the Summer Camp App — that change is not saved here.` + (changedFields.length > refused.length || hasNewPhoto || pendingRemove ? ' Your other edits will still be saved.' : ''));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6429:  5734	      if (file.size > 5 * 1024 * 1024) { alert('Photo must be under 5MB.'); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6467:  5772	    alert('This edit could not be saved. Please try again.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6540:  5845	// machine loop; closing it fully would need a Firestore transaction.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6647:  5952	      alert(`Move could not be saved — "${preMoveSourceLesson.projectTitle}" has been restored to its original slot. Nothing was changed.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6719:  6024	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" and "${destLesson.projectTitle}" have been restored to their original slots.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6737:  6042	          alert(`Swap did not complete — "${sourceLesson.projectTitle}" has been restored to its original slot.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6778:  7147	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6788:  7157	    alert(err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6799:  7168	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6803:  7172	    alert('This lesson was moved or removed elsewhere. Your response was not sent — please close this and check the grid for its new location.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6839:  7208	    alert('Error sending response: ' + err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6863:  7232	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6873:  7242	    alert(err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6884:  7253	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6888:  7257	    alert('This lesson was moved or removed elsewhere. Your reply was not sent — please close this window and check the grid for its new location.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:6922:  7291	    alert('Error sending reply: ' + err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7042:  7590	      // backupStatus is manager/admin-only (same boundary as Backup Health) —
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7068:   561	    // Teacher questions - ALL unanswered questions (immediate alerts)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7099:   592	              const alertId = `classbook-qa-${lessonKey}`;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7100:   593	              currentClassbookAlertIds.push(alertId);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7123:   616	              const alert = {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7124:   617	                id: alertId,
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7134:   627	              unansweredQuestions.push(alert);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7139:   632	        // Remove old Classbook alerts that are no longer unanswered
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7140:   633	        alerts.forEach(alert => {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7141:   634	          if (alert.type === 'curriculum' && !currentClassbookAlertIds.includes(alert.id)) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7142:   635	            removeAlert(alert.id);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7146:   639	        // Update all Q&A alerts
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7147:   640	        unansweredQuestions.forEach(alert => addOrUpdateAlert(alert));
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7161:   654	  function addOrUpdateAlert(alert) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7162:   655	    if (dismissedAlertIds.has(alert.id)) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7163:   656	      // Route to dismissed list — alert is still tracked but not shown as active
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7164:   657	      alert.dismissed = true;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7165:   658	      const existingIndex = dismissedAlerts.findIndex(a => a.id === alert.id);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7167:   660	        dismissedAlerts[existingIndex] = alert;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7169:   662	        dismissedAlerts.push(alert);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7174:   667	    const existingIndex = alerts.findIndex(a => a.id === alert.id);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7176:   669	      alerts[existingIndex] = alert;
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7180:One unresolved transition race is now concrete: Phase A freezes only the old source, not the new target. The instant Phase C creates `lessons_spring-2026`, a Phase-B tab’s listener can enable a Spring save before the plan’s forced-read verification. That legitimate save changes the target hash; the prescribed “verify fails → delete target” recovery would discard the edit. I’m tracing the same concurrency issue through Phase D and the Studio Hub alert aggregation now.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7197:/Users/christiehubley/studio-hub/test-alerts-browser.html:227:        const curriculumRef = db.collection('curriculum').doc('lessonData');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7198:/Users/christiehubley/studio-hub/test-alerts-browser.html:278:        const curriculumRef = db.collection('curriculum').doc('lessonData');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7200:/Users/christiehubley/studio-hub/js/alerts.js:563:      .doc('lessonData')
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7320:  3624	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7334:  3638	    alert(err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7338:  3642	    alert('Summer camp questions are sent from the camp lesson editor.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7351:  3655	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7355:  3659	    alert('This lesson was moved or removed elsewhere. Your message was not sent — please close this and check the classbook for its new location.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7361:  3665	  const isAdmin = ['admin', 'manager'].includes(user?.role);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7389:  3693	    alert('Error sending message: ' + err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7462:  5845	// machine loop; closing it fully would need a Firestore transaction.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7588:  6480	    alert(`Could not paste "${proj.projectTitle}" — please try again.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7617:  6509	    alert('The lesson saved successfully, but this project could not be removed from the Cut Bank — it may still appear there. Reload to check.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7707:/bin/zsh -lc "nl -ba /Users/christiehubley/studio-hub/test-alerts.js | sed -n '70,165p'
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7708:nl -ba /Users/christiehubley/studio-hub/test-alerts-browser.html | sed -n '200,300p'
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7723:    81	    notes: 'TEST DATA - Added by alert testing script'
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7728:    86	  console.log('Expected alert: "Action item: Follow up with test customer..." (priority: info)');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7756:   114	    notes: 'TEST DATA - Added by alert testing script'
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7761:   119	  console.log('Expected alert: "Teacher question: How should I handle students..." (priority: warning)');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7770:   128	    { name: 'clayHub_members', query: ['notes', '==', 'TEST DATA - Added by alert testing script'] },
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7771:   129	    { name: 'privateEvents', query: ['notes', '==', 'TEST DATA - Added by alert testing script'] },
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7772:   130	    { name: 'meetings', query: ['notes', '==', 'TEST DATA - Added by alert testing script'] }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7790:   148	      qa.notes !== 'TEST DATA - Added by alert testing script'
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7800:   158	const alertType = process.argv[2];
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7804:   162	    switch(alertType) {
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7815:   207	          notes: 'TEST DATA - Added by alert testing script'
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7851:   243	          notes: 'TEST DATA - Added by alert testing script'
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7873:   265	            .where('notes', '==', 'TEST DATA - Added by alert testing script')
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7892:   284	            qa.notes !== 'TEST DATA - Added by alert testing script'
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7915:    96	  console.log('Expected alert: "Action item: Follow up with test customer..." (info)');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:7954:   135	  console.log('Expected alert: "Teacher question: How should I handle students..." (warning)');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8020:   125	   - Overview cards (% complete, items flagged, help queue alerts)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8058:  4531	    alert('Cannot delete the active semester.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8072:  4545	    catch (err) { alert(`Could not check "${sem.name}" for events: ${err.message}\n\nNothing was changed.`); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8073:  4546	    if (events > 0) { alert(`"${sem.name}" still has ${events} event${events === 1 ? '' : 's'}. Remove its events first.`); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8087:  4560	  // semester the server still has — with no alert and no re-render to show it
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8096:  4569	    alert(`Could not remove "${sem.name}": ${err.message}\n\nNothing was changed.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8133:  4606	  if (!isPublishableType(key)) { alert('This semester type can\'t be published.'); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8138:  4611	    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8154:  4627	    alert(`Could not ${published ? 'publish' : 'unpublish'} that semester: ${err.message}\n\nNothing was changed.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8231:  4913	      // surviving lesson data — the remedy this alert points at.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8234:  4916	        alert(`Lesson content already exists in Firestore under the key "${key}".\n\nIf it was left over from a deleted semester, create this semester again without "Copy from" to adopt that data.\n\nIf another admin may have just created it, reload this page first.\n\nOtherwise choose a different name.`);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8317:  4999	    alert('Could not create the new semester. Please try again.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8468:  3624	    alert('Lesson data failed to load — refusing to send until it has. Reload and try again.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8482:  3638	    alert(err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8486:  3642	    alert('Summer camp questions are sent from the camp lesson editor.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8499:  3655	    alert("Couldn't confirm this lesson still exists — check your connection and try again.");
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8503:  3659	    alert('This lesson was moved or removed elsewhere. Your message was not sent — please close this and check the classbook for its new location.');
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8509:  3665	  const isAdmin = ['admin', 'manager'].includes(user?.role);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8537:  3693	    alert('Error sending message: ' + err.message);
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8616:The fence freezes only `lessonData['spring-2026']`; it does not freeze the newly created target. As soon as the transaction creates `lessons_spring-2026`, a Phase-B listener can enable editing and the existing writers can update it ([firebase-data.js:1364](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1364), [app.js:3615](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3615), [app.js:7135](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7135)).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8620:1. Phase C transaction copies hash `H`.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8630:Phase D checks only the frozen source against the recorded hash, then deletes the source ([plan:153](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:153)). It does not require a forced-server read proving that `lessons_spring-2026` exists and is usable.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8635:- They accidentally delete `lessons_spring-2026` between C and D.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8640:At minimum, Phase D must refuse unless a forced-server target read succeeds. For a rigorous hash comparison, target writes must remain paused; otherwise legitimate edits make equality impossible. The migration record should also be written with merge semantics so `storageMigrations` is not accidentally overwritten.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8652:A manager/admin can likewise delete the whole source document, contrary to “only deletes that key.”
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8658:- Preserve manager whole-document delete for other curriculum docs, including rollback deletion of `lessons_spring-2026`.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8660:Q3: yes, splitting line 654 should preserve manager delete for ordinary curriculum documents and the new target. It should not preserve whole-document deletion of `lessonData` while that document is the protected source.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8662:The test matrix also needs explicit `admin` and legacy `curriculum-admin`, not only teacher/classbook-admin/manager. The existing suite has fixtures for both ([rules.test.js:33](/Users/christiehubley/studio-hub/rules.test.js:33), [rules.test.js:49](/Users/christiehubley/studio-hub/rules.test.js:49)).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8680:Phase B says the live count will sum `lessonData` and `lessons_spring-2026` ([plan:105](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:105)). Christie’s backup snippet likewise tallies both ([plan:192](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:192)). Existing counting walks every semester in the shared document ([app.js:7518](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7518), [backup.js:381](/Users/christiehubley/tinker-backups/backup.js:381)).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8690:Both implementations must choose one source per semester: use `lessons_spring-2026` when present and skip `lessonData['spring-2026']`; otherwise use the legacy map.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8692:6. Adding a second Studio Hub listener “the same way” makes alerts erase each other.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8694:The existing listener removes every curriculum alert not present in its own snapshot’s ID list ([alerts.js:632](/Users/christiehubley/studio-hub/js/alerts.js:632)). With independent legacy and Spring listeners:
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8696:- Fall snapshot produces alert `F` and removes Spring alert `S`.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8700:Alert IDs also omit the semester, using only `lessonKey` ([alerts.js:592](/Users/christiehubley/studio-hub/js/alerts.js:592)); identical teacher/class/week keys across Fall and Spring collide.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8702:Phase B must maintain per-source snapshot state and reconcile their union, prefer the target over the frozen legacy Spring copy during C–D, and key alerts by semester plus lesson key.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8708:After migration, deleting Spring can remove its config entry while leaving `lessons_spring-2026` orphaned and invisible. Deferring this until “before the next semester is created” ([plan:161](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:161)) is insufficient. Phase B must either route deletion correctly and make it failure-atomic, or disable Spring deletion with a clear message until the follow-up lands.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8714:- [test-alerts-browser.html:227](/Users/christiehubley/studio-hub/test-alerts-browser.html:227)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8719:The near-1 MiB emulator fixture is worthwhile and sound as a rules-semantics regression test. It does not prove production latency or exact remaining document headroom. Build it from multiple subfields, assert its actual encoded/estimated size, and isolate/reset it per mutating test. The diagnostics plan also needs to define how `N KB` is computed; `JSON.stringify(doc.data()).length` is not the Firestore document’s encoded size. Label it approximate and retain a conservative buffer unless an actual Firestore-size estimator is used.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8723:Given only ~52 KB of headroom, the safer simplification is:
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8727:3. In one manager transaction, require the target absent, copy Spring, record the merged migration entry, and delete the old Spring field atomically.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8740:6. Aggregate Studio Hub alert sources instead of letting listeners remove each other’s alerts.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8742:8. Specify merged `storageMigrations` writes, target-disappearance behavior, and a conservative headroom measurement.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8755:The fence freezes only `lessonData['spring-2026']`; it does not freeze the newly created target. As soon as the transaction creates `lessons_spring-2026`, a Phase-B listener can enable editing and the existing writers can update it ([firebase-data.js:1364](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1364), [app.js:3615](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3615), [app.js:7135](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7135)).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8759:1. Phase C transaction copies hash `H`.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8769:Phase D checks only the frozen source against the recorded hash, then deletes the source ([plan:153](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:153)). It does not require a forced-server read proving that `lessons_spring-2026` exists and is usable.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8774:- They accidentally delete `lessons_spring-2026` between C and D.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8779:At minimum, Phase D must refuse unless a forced-server target read succeeds. For a rigorous hash comparison, target writes must remain paused; otherwise legitimate edits make equality impossible. The migration record should also be written with merge semantics so `storageMigrations` is not accidentally overwritten.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8791:A manager/admin can likewise delete the whole source document, contrary to “only deletes that key.”
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8797:- Preserve manager whole-document delete for other curriculum docs, including rollback deletion of `lessons_spring-2026`.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8799:Q3: yes, splitting line 654 should preserve manager delete for ordinary curriculum documents and the new target. It should not preserve whole-document deletion of `lessonData` while that document is the protected source.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8801:The test matrix also needs explicit `admin` and legacy `curriculum-admin`, not only teacher/classbook-admin/manager. The existing suite has fixtures for both ([rules.test.js:33](/Users/christiehubley/studio-hub/rules.test.js:33), [rules.test.js:49](/Users/christiehubley/studio-hub/rules.test.js:49)).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8819:Phase B says the live count will sum `lessonData` and `lessons_spring-2026` ([plan:105](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:105)). Christie’s backup snippet likewise tallies both ([plan:192](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:192)). Existing counting walks every semester in the shared document ([app.js:7518](/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7518), [backup.js:381](/Users/christiehubley/tinker-backups/backup.js:381)).
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8829:Both implementations must choose one source per semester: use `lessons_spring-2026` when present and skip `lessonData['spring-2026']`; otherwise use the legacy map.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8831:6. Adding a second Studio Hub listener “the same way” makes alerts erase each other.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8833:The existing listener removes every curriculum alert not present in its own snapshot’s ID list ([alerts.js:632](/Users/christiehubley/studio-hub/js/alerts.js:632)). With independent legacy and Spring listeners:
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8835:- Fall snapshot produces alert `F` and removes Spring alert `S`.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8839:Alert IDs also omit the semester, using only `lessonKey` ([alerts.js:592](/Users/christiehubley/studio-hub/js/alerts.js:592)); identical teacher/class/week keys across Fall and Spring collide.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8841:Phase B must maintain per-source snapshot state and reconcile their union, prefer the target over the frozen legacy Spring copy during C–D, and key alerts by semester plus lesson key.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8847:After migration, deleting Spring can remove its config entry while leaving `lessons_spring-2026` orphaned and invisible. Deferring this until “before the next semester is created” ([plan:161](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:161)) is insufficient. Phase B must either route deletion correctly and make it failure-atomic, or disable Spring deletion with a clear message until the follow-up lands.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8853:- [test-alerts-browser.html:227](/Users/christiehubley/studio-hub/test-alerts-browser.html:227)
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8858:The near-1 MiB emulator fixture is worthwhile and sound as a rules-semantics regression test. It does not prove production latency or exact remaining document headroom. Build it from multiple subfields, assert its actual encoded/estimated size, and isolate/reset it per mutating test. The diagnostics plan also needs to define how `N KB` is computed; `JSON.stringify(doc.data()).length` is not the Firestore document’s encoded size. Label it approximate and retain a conservative buffer unless an actual Firestore-size estimator is used.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8862:Given only ~52 KB of headroom, the safer simplification is:
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8866:3. In one manager transaction, require the target absent, copy Spring, record the merged migration entry, and delete the old Spring field atomically.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8879:6. Aggregate Studio Hub alert sources instead of letting listeners remove each other’s alerts.
/Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md:8881:8. Specify merged `storageMigrations` writes, target-disappearance behavior, and a conservative headroom measurement.

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html | sed -n '60,240p'; nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-plan-review-per-semester-storage-codex-r1.md | sed -n '8858,8885p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
    60	</table>
    61	
    62	<h2 id="design">Design (revision 3)</h2>
    63	<ul>
    64	  <li><strong>One constant, <code>OWN_DOC_SEMESTERS = ['spring-2026']</code></strong>, in <code>firebase-data.js</code>. It changes only by a code deploy, and the rules fence changes only by a rules deploy.</li>
    65	  <li><strong>Where Spring lives:</strong> <code>curriculum/lessons_spring-2026</code> = <code>{ &lt;lessonKey&gt;: lesson, lastUpdated, lastUpdatedBy }</code>. <code>lessonStoreFor</code> returns <code>'ownDoc'</code> for keys in the constant. Every weekly site goes through <code>weeklyLessonRef(semKey)</code> / <code>weeklyLessonPath(semKey, lessonKey, field?)</code>: paths are rooted at <code>lessonKey</code> for <code>'ownDoc'</code> and at <code>semKey.lessonKey</code> for legacy.</li>
    66	  <li><strong>Transitional read rule:</strong> for an own-doc semester, if <code>lessons_K</code> exists, read it; otherwise read <code>lessonData[K]</code> as today. The code can deploy before the move, and Spring stays viewable at every step.</li>
    67	  <li><strong>One-step move (Codex round 1, "simpler safe option"):</strong> Spring's copy and the removal of its old copy happen <em>in one transaction</em>. There's never a multi-day period with two copies, so nothing is double-counted, and the old copy can't be deleted while the new one is missing.</li>
    68	  <li><strong>Spring edits stay paused, enforced by the rules, until the move is verified.</strong> A rule on <code>curriculum/lessons_spring-2026</code> allows updates only when <code>curriculum/storageMigrations</code> has <code>spring-2026.verified == true</code> (a <code>get()</code> on Spring writes only; Spring is dormant, so the cost is negligible). So nothing can change the new document between the copy and the verification: its hash is stable, and a rollback can't discard a real edit.</li>
    69	</ul>
    70	
    71	<h2 id="phases">Phases</h2>
    72	
    73	<div class="phase" id="phase-a">
    74	<h3>Phase A: rules that protect Spring during and after the move <span class="status-tag not-ready">execution-ready: false</span></h3>
    75	<p><strong>Acceptance:</strong> every other <code>/curriculum</code> document behaves exactly as today for every role. For <code>curriculum/lessonData</code>:</p>
    76	<ul>
    77	  <li>No role can create, add to, or change the <code>spring-2026</code> key. The one exception is a manager update that <em>only deletes</em> it, which the Phase C transaction needs.</li>
    78	  <li>No role can delete the <strong>whole</strong> <code>lessonData</code> document. This closes Codex's bypass: delete it, then recreate it with a stale Spring.</li>
    79	  <li><code>create</code> of <code>lessonData</code> is refused if it contains <code>spring-2026</code>.</li>
    80	</ul>
    81	<p>For <code>curriculum/lessons_spring-2026</code>: create by a manager only, and only if it doesn't exist. Updates only when <code>storageMigrations.spring-2026.verified == true</code>, for the roles that can update lessons today. Whole-doc delete by a manager (needed for a rollback) and by classbook-admin/curriculum-admin as today, both only while not yet verified; after verification, only a manager can delete it.</p>
    82	<p>For <code>curriculum/storageMigrations</code>: manager write, and read for the classbook roles.</p>
    83	<p>It deploys through <code>deploy-rules.sh --approved &lt;sha&gt;</code> after Christie's phrase. It ships first: it breaks nothing, because Spring's edits are already paused (Christie approved view-only).</p>
    84	<p><strong>Shape:</strong> split <code>:654</code> (<code>allow read, write: if isManagerOrAbove()</code>) into <code>read</code> / <code>create</code> / <code>update</code> / <code>delete</code> statements, because rules OR across statements. Manager <code>delete</code> is kept for every curriculum doc except <code>lessonData</code>. The classbook-role statements at <code>:666</code> and <code>:675-678</code> get the same <code>lessonData</code>/<code>lessons_spring-2026</code> conditions. The <code>lessonData</code> update condition is <code>!affectedKeys().hasAny(['spring-2026'])</code>, OR (manager) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; !('spring-2026' in request.resource.data)</code>.</p>
    85	<div class="bdd">Rules tests (studio-hub/rules.test.js), roles: teacher (classbook), classbook-admin, curriculum-admin, manager, admin.
    86	  lessonData update fall-2026.x.field                              → allowed (every role that can today)
    87	  lessonData update spring-2026.x.field                            → denied (every role)
    88	  lessonData update { spring-2026: delete } only                    → manager/admin allowed; others denied
    89	  lessonData update { spring-2026: delete, fall-2026.x: … }         → denied
    90	  lessonData whole-doc delete                                       → denied (every role)
    91	  lessonData create containing spring-2026                          → denied; create without it → as today
    92	  re-add spring-2026 after removal                                  → denied
    93	  lessons_spring-2026 create when absent                            → manager/admin allowed; others denied
    94	  lessons_spring-2026 update before verified                        → denied (every role); after verified → allowed as for lessons today
    95	  lessons_spring-2026 delete before verified                        → manager allowed (rollback); after → manager only
    96	  storageMigrations write                                           → manager/admin only; read → classbook roles
    97	  every other /curriculum doc (appData, prepCycleConfig, prepData, cutProjects, changeLog, …) → exactly as today
    98	  A near-1 MB lessonData fixture built from many sub-fields, with its estimated size asserted, reset per mutating test: the allow/deny cases above evaluate correctly
    99	  The whole existing studio-hub suite passes</div>
   100	</div>
   101	
   102	<div class="phase" id="phase-b">
   103	<h3>Phase B: the Classbook (and Studio Hub) understand Spring's new home. No data moves yet. <span class="status-tag not-ready">execution-ready: false</span></h3>
   104	<p><strong>Acceptance:</strong> in production (no <code>lessons_spring-2026</code> yet), everything behaves as today, and Spring is view-only ("editing is paused while Spring 2026 moves to new storage"). In the emulator, with Spring moved and verified, Spring works end to end, and Fall and every other semester are untouched. This is one Classbook deploy (one Netlify credit) plus one Studio Hub deploy.</p>
   105	<ul>
   106	  <li><strong>The listener doesn't drop Spring</strong> (round 1 A). The legacy snapshot's swap carries own-doc semesters across, the way it already carries camp seasons. The <code>lessons_K</code> listener updates only <code>currentLessonData[K]</code>, doesn't bump <code>globalListenerGeneration</code>, and never touches <code>lessonDataLoadedSuccessfully</code>. Its errors go to a visible banner and make Spring unwritable.</li>
   107	  <li><strong>Transitions are loud, never blank.</strong>
   108	    <ul>
   109	      <li>If <code>lessons_K</code> appears (the move committed), Spring switches to it.</li>
   110	      <li>If it disappears (a rollback), the app reloads Spring from the legacy source, or shows "reload the page" if that's gone too.</li>
   111	      <li>If the legacy snapshot lacks a key this tab was rendering from <code>lessonData</code>, the app shows "moved — reload the page".</li>
   112	    </ul>
   113	    The whole teardown uses one unsubscribe array (the listener is registered from <code>app.js:676</code> and <code>:5038</code>).</li>
   114	  <li><strong>Writes to Spring:</strong> they go to <code>lessons_K</code> only when <code>storageMigrations.spring-2026.verified</code> is true, read by a small <code>storageMigrations</code> listener. Otherwise the app shows the "editing is paused" message; the rules refuse those writes anyway. <code>not-found</code> is handled the same way.</li>
   115	  <li><strong>Counts come from one source per semester</strong> (Codex 5). <code>computeLiveContentCountByTeacher</code> uses <code>lessons_K</code> when it exists and skips <code>lessonData[K]</code>, otherwise the legacy map. There's never a dual-copy window anyway, but this protects against a failed rollback state.</li>
   116	  <li><strong>Deleting Spring is disabled</strong> (Codex 7). <code>deleteSemester('spring-2026')</code> refuses with "Spring 2026 can't be deleted while its storage is being changed", until the follow-up plan routes it properly.</li>
   117	  <li><strong>Headroom readout</strong> in Curriculum Admin → Diagnostics (managers): an approximate Firestore-size estimate of <code>lessonData</code>, using the same field-size method as the Sep 29 snippet (not <code>JSON.stringify</code> length). It's labelled "approx.", and it warns above 85%, a conservative buffer.</li>
   118	  <li><strong>Studio Hub alerts</strong> (Codex 6). The listener keeps per-source state: legacy <code>lessonData</code>, plus <code>lessons_spring-2026</code>. It reconciles the <em>union</em>, so each source's snapshot no longer removes the other's alerts. It prefers the own-doc copy for Spring. Alert IDs become <code>classbook-qa-&lt;semKey&gt;-&lt;lessonKey&gt;</code>, fixing today's cross-semester collisions; at the deploy, existing Q&amp;A alerts are re-keyed once, with no re-notification if Studio Hub dedupes by content, which the executor checks.</li>
   119	  <li><strong>Ratchet:</strong> no <code>doc('lessonData')</code> in the loaded scripts outside the helpers, the legacy load/listener and the dead backup helpers. <code>e2e/</code> is exempt. The seed gains a <code>lessons_spring-2026</code> + <code>storageMigrations</code> fixture set for the own-doc scenarios, and the default seed is unchanged.</li>
   120	</ul>
   121	<div class="bdd">Scenario: production state after deploy — regression
   122	  Given no lessons_spring-2026
   123	  Then every existing e2e test passes; Fall behaves as today; Spring is viewable and edits show "editing is paused"
   124	
   125	Scenario: Spring moved and verified works end to end (emulator)
   126	  When a teacher views/saves a Spring lesson, sends Q&A; an admin replies, edits, moves/swaps
   127	  Then every write lands in lessons_spring-2026 at lessonKey.field paths; lessonData is untouched
   128	
   129	Scenario: moved but not yet verified — edits paused
   130	  Given lessons_spring-2026 exists, verified false
   131	  Then Spring shows the moved lessons and edits show "editing is paused"
   132	
   133	Scenario: a Fall save doesn't blank Spring (round 1 A)
   134	Scenario: the target doc disappears (rollback) → Spring falls back to legacy or "reload", never an empty grid
   135	Scenario: own-doc listener error → banner, Spring unwritable, Fall unaffected
   136	Scenario: counts: a teacher with 10 Spring + 5 Fall lessons counts 15, before and after the move
   137	Scenario: deleteSemester('spring-2026') refuses with the storage message
   138	Scenario: Studio Hub: a Fall question and a Spring question both alert, and answering one leaves the other; identical lesson keys in two semesters give two alerts
   139	Scenario: headroom readout shows ≈ N KB of 1,024 (approx.) and warns above 85%</div>
   140	</div>
   141	
   142	<div class="phase" id="phase-c">
   143	<h3>Phase C: move Spring in one step (production, one-off, manager) <span class="status-tag not-ready">execution-ready: false</span></h3>
   144	<p><strong>Preconditions:</strong>
   145	<ul>
   146	  <li>Phase B has been live at least 3 days, and it's a quiet time (evening).</li>
   147	  <li><strong>Stale-tab cutoff</strong> (Codex 4): the day before, Christie asks staff to close and reopen the Classbook. A tab still running pre-Phase-B code can't lose anything, because the Phase A rules refuse its Spring writes. It could show Spring as empty until it's reloaded, and that's the accepted residual.</li>
   148	  <li>Christie's go-ahead.</li>
   149	</ul></p>
   150	<p><strong>How:</strong> a console procedure that Christie pastes while signed in as manager. The procedure is written into this plan and reviewed before execution, and rehearsed in the emulator by an e2e test that runs the same code.</p>
   151	<ol>
   152	  <li>A forced-server read of <code>lessonData</code>. It refuses if <code>spring-2026</code> is missing or <code>lessons_spring-2026</code> exists. Then it downloads <code>classbook-spring-2026-lessons-&lt;ISO&gt;.json</code>.</li>
   153	  <li><strong>One transaction:</strong> read <code>lessonData</code>, <code>lessons_spring-2026</code> (which must not exist) and <code>storageMigrations</code>. Then:
   154	    <ul>
   155	      <li><code>tx.set(lessons_spring-2026, { ...map, lastUpdated, lastUpdatedBy })</code>, where <code>map</code> is the <code>spring-2026</code> map read <em>inside</em> the transaction</li>
   156	      <li><code>tx.update(lessonData, { 'spring-2026': FieldValue.delete() })</code></li>
   157	      <li><code>tx.set(storageMigrations, { 'spring-2026': { movedAt, movedBy, lessonCount, sha256, verified: false } }, { merge: true })</code></li>
   158	    </ul>
   159	    The hash is SHA-256 of canonical (sorted-key) JSON of <code>map</code>. It's all or nothing.</li>
   160	  <li><strong>Verify</strong> from forced-server reads: <code>lessons_spring-2026</code> minus its <code>lastUpdated*</code> hashes to the recorded <code>sha256</code>, its lesson count matches, <code>lessonData</code> no longer has <code>spring-2026</code>, and <code>lessonData</code>'s size is re-estimated (expected about 420 KB). Edits are paused by rule, so these checks are stable.</li>
   161	  <li><strong>If verification passes:</strong> <code>storageMigrations.spring-2026.verified = true</code>, and Spring becomes editable. Spot-check one Spring lesson in the Firebase Console.</li>
   162	  <li><strong>If it fails:</strong> nothing has been edited since the copy, so the reverse transaction is safe: it puts <code>map</code> back into <code>lessonData</code>, which the rules allow (a manager, and only this key, while not verified; the executor adds this allowance and its test to Phase A), deletes <code>lessons_spring-2026</code>, and records the failure. The download from step 1 remains the last resort.</li>
   163	</ol>
   164	<div class="bdd">Scenario: move (emulator, the same procedure as an e2e test)
   165	  Then lessons_spring-2026 deep-equals the old map (+ lastUpdated*), lessonData has no spring-2026, storageMigrations records count + hash, verified → true, Spring editable, Fall untouched
   166	Scenario: target already exists → refuses before any write
   167	Scenario: verification fails (simulated) → the reverse transaction restores lessonData['spring-2026'] byte-identical and removes the target
   168	Scenario: a pre-Phase-B tab after the move → its Spring edit is refused by the rules (no data loss)</div>
   169	<div class="note"><strong>The backup script edit (Christie gave permission for this change, Sep 29):</strong> <em>before</em> Phase C, and with Christie's go-ahead confirmed again at that moment, Claude adds the five lines recorded in the Decisions Log to <code>tinker-backups/backup.js</code> (<code>computeClassbookContentByTeacher</code>, just before <code>return counts;</code>). It keeps a <code>.bak</code> copy, checks the syntax with <code>node --check</code>, doesn't run the script, and touches nothing else, above all not the credential code. Because the move is one step, the backup never sees Spring twice.</div>
   170	</div>
   171	
   172	<h2 id="followup">Follow-up plan (required before the next semester is created)</h2>
   173	<div class="note">After Phase C, <code>lessonData</code> holds Fall (about 420 KB and growing). <strong>Before Spring 2027 is created</strong> (or before <code>lessonData</code> passes about 70%), a follow-up plan must:
   174	<ul>
   175	  <li>move Fall at the end of its term</li>
   176	  <li>create new semesters in their own document (config set before <code>saveLessonData</code>, <code>app.js:4965</code> vs <code>:4980</code>; <code>not-found</code> on the first write)</li>
   177	  <li>route <code>deleteSemester</code>/Archive for own-doc semesters (re-enabling Spring's delete or archive)</li>
   178	  <li>generalise the constant and the rules fence</li>
   179	</ul>
   180	The make-active-semester plan resumes after that.</div>
   181	
   182	<h2 id="safety">Firebase safety checklist</h2>
   183	<div class="safe"><ul>
   184	  <li><strong>Rules:</strong> Phase A is a shared-rules change: tests for all five roles, a near-1 MB fixture, the whole suite green, then <code>deploy-rules.sh --approved &lt;sha&gt;</code> after the phrase. The new docs (<code>lessons_spring-2026</code>, <code>storageMigrations</code>) get explicit conditions in the <code>curriculum/{docId}</code> block.</li>
   185	  <li><strong>Backups (checked Sep 29):</strong> <code>backup.js</code> fetches <em>every</em> document in each listed collection (<code>fetchCollection</code>, <code>:221-247</code>), so <code>lessons_spring-2026</code> and <code>storageMigrations</code> are in every 30-minute backup automatically. The Tier-1 count check counts documents, and <code>curriculum</code> gains two, so there's no false alarm there. The per-teacher content count is covered by the five-line edit.</li>
   186	  <li><strong>Snapshot:</strong> a JSON download right before the move, plus <code>tinker-backups/backup.js</code>'s automatic 30-minute backups of the <code>curriculum</code> collection (Tier 1).</li>
   187	  <li><strong>Atomic:</strong> the copy, the old-copy removal and the migration record are one transaction.</li>
   188	  <li><strong>Verified</strong> from forced-server reads while edits are paused by rule, before anything is unpaused.</li>
   189	  <li><strong>Reversible:</strong> a reverse transaction until verified. After that, the download and backups.</li>
   190	  <li><strong>Partial updates:</strong> per-field dotted paths as today. <code>saveLessonData</code>'s whole-semester merge-set becomes a whole-document merge-set for own-doc semesters (still <code>merge: true</code>).</li>
   191	  <li><strong>Spot check:</strong> one Spring lesson in the Firebase Console after verification.</li>
   192	</ul></div>
   193	
   194	<h2 id="completeness">If interrupted</h2>
   195	<ul>
   196	  <li><strong>After A:</strong> Spring is view-only, and nothing else changes.</li>
   197	  <li><strong>After B:</strong> the same, plus the readout and fixed Studio Hub alerts.</li>
   198	  <li><strong>Mid-C:</strong> the transaction either committed or didn't. If it committed but isn't verified, Spring is viewable, edits are paused, and the reverse transaction exists.</li>
   199	</ul>
   200	
   201	<h2 id="resume">Resume instructions</h2>
   202	<ol>
   203	  <li>Read this plan and its Decisions Log. Re-measure lessonData first.</li>
   204	  <li>Phase A in <code>studio-hub</code> (branch, merge to main, then the guard). Phase B in a Classbook worktree off <code>origin/main</code>, plus Studio Hub for the alerts. Re-check the line numbers.</li>
   205	  <li>Per phase: commit, run the full suite, then a second-model implementation review. Each deploy, the backup.js edit, and Phase C each need Christie's own yes. Phase A needs the sha phrase.</li>
   206	</ol>
   207	
   208	<h2 id="decisions">Decisions Log (append-only)</h2>
   209	<div class="decision">
   210	  <strong>Sep 29, 2026: revision 3, after Codex's independent round 1 (<code>…-codex-r1.md</code>): NOT ready, 8-point minimum list, all verified and taken.</strong>
   211	  <ul>
   212	    <li>Adopted Codex's "simpler safe option": the copy and the old-copy removal are <strong>one transaction</strong>, with Spring edits paused by rule until the move is verified. That closes the verification/rollback race (1), the target-missing-at-delete risk (2) and double counting (5), since there's no dual-copy window, and Phases C and D merge.</li>
   213	    <li>(3) The rules also fence <code>lessonData</code> create and whole-doc delete, keep manager delete for other docs, and the tests cover admin and curriculum-admin. Q3 is resolved: manager delete is kept, except for <code>lessonData</code>.</li>
   214	    <li>(4) A stale-tab cutoff: Phase B live for 3 days or more, staff asked to reopen the Classbook, and an old tab can only mis-display, never lose data.</li>
   215	    <li>(6) Studio Hub alerts reconcile a union across sources, with semester-qualified IDs.</li>
   216	    <li>(7) Spring's delete is disabled in Phase B.</li>
   217	    <li>(8) Merged <code>storageMigrations</code> writes, target-disappearance behaviour, and a Firestore-size estimator for the readout with an 85% warning.</li>
   218	  </ul>
   219	  The inventory adds <code>studio-hub/test-alerts-browser.html:227</code> and <code>TESTING-GUIDE.md:115</code> (manual, root <code>qaData</code> only).<br>
   220	  <strong>Christie (Sep 29):</strong> she can't edit <code>backup.js</code> herself, and gave <strong>permission for Claude to make that one five-line change</strong> (keep a .bak, <code>node --check</code>, don't run it, touch nothing else), to be confirmed again at the time.
   221	</div>
   222	<div class="decision">
   223	  <strong>Sep 29, 2026: Christie's answers.</strong> (Q1) Spring 2026 being view-only from Phase A until Phase C is fine. (Q2) Christie will paste the <code>backup.js</code> change herself (option a) before Phase D. The exact lines, for <code>tinker-backups/backup.js</code> inside <code>computeClassbookContentByTeacher</code>, just before <code>return counts;</code>:
   224	<pre style="font-size:.85rem">  // Own-document semesters: curriculum/lessons_&lt;semKey&gt; = { lessonKey: lesson, lastUpdated, … }.
   225	  for (const [docId, doc] of Object.entries(collections['curriculum'] || {})) {
   226	    if (!docId.startsWith('lessons_') || !doc || typeof doc !== 'object') continue;
   227	    for (const lesson of Object.values(doc)) if (lesson &amp;&amp; typeof lesson === 'object') tally(lesson);
   228	  }</pre>
   229	  It's generic over <code>lessons_*</code>, so Fall's later move needs no second edit. <code>tally</code> ignores non-lesson values (<code>lastUpdated</code> strings have no <code>.teacher</code>). Also: Christie asked whether Spring stays reachable after the move. Yes: it stays in every semester list and is fully viewable, and it's editable again after Phase C.
   230	</div>
   231	<div class="decision">
   232	  <strong>Sep 29, 2026: revision 2, after review round 1 (Claude; <code>thoughts/reviews/2026-09-29-plan-review-per-semester-storage-r1-claude.md</code>): NOT ready, 11-point minimum list, all taken.</strong> Re-scoped to <strong>Spring only, hard-coded</strong>, with no appData flags, <code>migratedSemesters</code>, UI buttons or "Move back". The copy and the removal are reviewed console procedures. The rules fence uses a literal key (no <code>get(appData)</code>), splits <code>:654</code>, and ships <strong>first</strong>. Fixed: the listener drops own-doc semesters (A); verify races (B, moot now that the fence freezes the source first); Phase D's precondition compares against the hash of what was written (C); vanished keys are loud (D); <code>not-found</code> on first write (E); <code>createNewSemester</code>/<code>deleteSemester</code> deferred to the follow-up plan, with a deadline (F, delete); the missing readers are added (<code>tinker-backups/backup.js</code>, which is Christie's edit, the in-app content count, <code>test-alerts.js</code>, dead backup helpers, e2e exemptions, seed); the backup citation and "nightly" are corrected; the listener generation is decided (no bump); teardown uses an array; a near-1 MB rules fixture is added; there's a headroom readout; and the emergency lever's order is fixed.<br>
   233	  <strong>Open questions for Christie:</strong> (Q1) Is it OK that Spring 2026 is read-only ("editing is paused") from Phase A until Phase C, probably a few days? (Q2) Will you make the small <code>backup.js</code> edit before Phase D, or accept one expected content-loss alarm for Spring teachers? (Q3, for the reviewer) Undoing a bad Phase C copy needs a whole-doc delete of <code>lessons_spring-2026</code>; today only classbook-admin/curriculum-admin may whole-doc delete (<code>:675-678</code>). Should Phase A's split give managers delete as well (they have it today through <code>:654</code>'s <code>write</code>)? The plan assumes yes: the split keeps manager delete.
   234	</div>
   235	<div class="decision">
   236	  <strong>Sep 29, 2026: plan created (draft 1).</strong> Found while reviewing the make-active plan's Archive design (now paused behind this plan). Christie measured 972 KB / 1,024 KB.
   237	</div>
   238	
   239	</body>
   240	</html>
  8858	The near-1 MiB emulator fixture is worthwhile and sound as a rules-semantics regression test. It does not prove production latency or exact remaining document headroom. Build it from multiple subfields, assert its actual encoded/estimated size, and isolate/reset it per mutating test. The diagnostics plan also needs to define how `N KB` is computed; `JSON.stringify(doc.data()).length` is not the Firestore document’s encoded size. Label it approximate and retain a conservative buffer unless an actual Firestore-size estimator is used.
  8859	
  8860	## Simpler safe option
  8861	
  8862	Given only ~52 KB of headroom, the safer simplification is:
  8863	
  8864	1. Deploy Phase B and establish a stale-client cutoff.
  8865	2. Keep Spring writes paused.
  8866	3. In one manager transaction, require the target absent, copy Spring, record the merged migration entry, and delete the old Spring field atomically.
  8867	4. Forced-server verify target hash and source absence.
  8868	5. Unpause target writes only after verification.
  8869	
  8870	That removes the multi-day duplicate interval, the double-counting window, and the C-to-D target-loss exposure. It does require an explicit write-unpause step, but Spring’s temporary read-only state has already been approved.
  8871	
  8872	## Minimum list
  8873	
  8874	1. Close the Phase-C target-write/verification/rollback race.
  8875	2. Make Phase D verify the target and migration record from the server before deletion.
  8876	3. Fence `lessonData` create and whole-document delete, and add admin/curriculum-admin tests.
  8877	4. Add a defensible stale-pre-Phase-B-tab cutoff.
  8878	5. Deduplicate live and backup content counts during the dual-copy interval.
  8879	6. Aggregate Studio Hub alert sources instead of letting listeners remove each other’s alerts.
  8880	7. Handle or disable `deleteSemester('spring-2026')` in Phase B.
  8881	8. Specify merged `storageMigrations` writes, target-disappearance behavior, and a conservative headroom measurement.
  8882	
  8883	Until those are in the plan, execution can hide Spring, discard a legitimate edit during rollback, or delete the last live copy.

codex
The main new atomic-move design is technically viable, but I’ve found a direct contradiction in the rollback path: Phase A explicitly denies re-adding `spring-2026`, while Phase C requires that exact write. I’m checking the remaining rule predicates and reader/count/alert details for any second blocker.
exec
/bin/zsh -lc "nl -ba /Users/christiehubley/studio-hub/firestore.rules | sed -n '1,130p;620,695p'; rg -n \"computeLiveContentCountByTeacher|deleteSemester|saveLessonData|lessonDataLoadedSuccessfully|globalListenerGeneration|doc\\(['\\\"]lessonData|currentLessonData|onSnapshot\" js/firebase-data.js js/app.js; nl -ba /Users/christiehubley/studio-hub/js/alerts.js | sed -n '540,650p'; nl -ba /Users/christiehubley/tinker-backups/backup.js | sed -n '215,250p;350,405p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
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
    96	      return !(field in resource.data)
    97	        || (field in request.resource.data && request.resource.data[field] == resource.data[field]);
    98	    }
    99	
   100	
   101	    // ═══════════════════════════════════════════════════════════════
   102	    // USERS COLLECTION
   103	    // Self-read/create: always allowed for any authenticated user
   104	    // (required for the auth guard to load the app).
   105	    // Manager+: read all user docs.
   106	    // Self-update: role field must not change.
   107	    // Manager update: cannot change role field, cannot delete.
   108	    // Admin: full create / update / delete.
   109	    // ═══════════════════════════════════════════════════════════════
   110	
   111	    match /users/{userId} {
   112	      // Own doc read — all authenticated users (auth guard requires it). Not the reminder bot: its
   113	      // grant is GET-only below, and this `read` would let an id-constrained LIST through.
   114	      allow read: if isAuthenticated() && request.auth.uid == userId && !isReminderBot();
   115	      // Manager+ reads all user docs (team filters, admin panels, etc.)
   116	      allow read: if isManagerOrAbove();
   117	      // Kiosk: read all users (for PIN lookup)
   118	      allow read: if isKiosk();
   119	      // Reminder bot: GET one doc by uid (the account it is about to email) — never a list.
   120	      allow get: if isReminderBot();
   121	
   122	      // Self-create: role must be 'staff' (prevents self-promotion), and
   123	      // appAccess must be absent or empty — app access is granted by an
   124	      // admin/manager via Manage Team, never by the user themselves.
   125	      // studios is NOT locked to empty here: the real bootstrap write (see
   126	      // js/app.js handleAuthStateChange) always sets studios: ['tinker',
   127	      // 'clayhub'] — both known studios, granted to every new user by
   128	      // default — so hasOnly() permits exactly that shape while still
   129	      // blocking a self-create from injecting any value outside the two
   130	      // known studios (there's no smaller "safe default" to enforce here
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
js/firebase-data.js:127:let currentLessonData = null;
js/firebase-data.js:128:let lessonDataLoadedSuccessfully = null; // null = not yet loaded, true = ok, false = failed
js/firebase-data.js:164://                                   lessonDataLoadedSuccessfully = false makes
js/firebase-data.js:177:    lessonDataLoadedSuccessfully = false;
js/firebase-data.js:303:let globalListenerGeneration = 0;
js/firebase-data.js:339:  // lessonDataLoadedSuccessfully = true and re-hide the banner this mode just
js/firebase-data.js:341:  if (changed) globalListenerGeneration++;
js/firebase-data.js:345:    lessonDataLoadedSuccessfully = false;
js/firebase-data.js:352:// onSnapshot never errors when offline and, with cache-only snapshots skipped,
js/firebase-data.js:461:    currentSeasonDocRef().onSnapshot({ includeMetadataChanges: true }, next, error));
js/firebase-data.js:525:    .onSnapshot(doc => {
js/firebase-data.js:601:    .onSnapshot(doc => {
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
js/firebase-data.js:802:async function saveLessonData(semesterKey, lessons) {
js/firebase-data.js:803:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js:817:  await curriculumDb.collection('curriculum').doc('lessonData').set({
js/firebase-data.js:830:  await curriculumDb.collection('curriculum').doc('lessonData').update({
js/firebase-data.js:891:// Same load guard as the lesson writers (saveLessonData/saveSingleLesson):
js/firebase-data.js:895:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js:925:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js:963:  await curriculumDb.collection('curriculum').doc('lessonData').update({
js/firebase-data.js:971:// createNewSemester()'s pre-check (deleteSemester() drops a key locally even
js/firebase-data.js:975:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
js/firebase-data.js:981:  const existing = currentLessonData?.[semesterKey];
js/firebase-data.js:985:  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
js/firebase-data.js:995:  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
js/firebase-data.js:1000:  await saveLessonData(semesterKey, lessons);
js/firebase-data.js:1096:  for (const semKey of Object.keys(currentLessonData || {})) {
js/firebase-data.js:1097:    if ((isCampSeason(semKey) || isDayOffYear(semKey)) && currentLessonData[semKey]) out[semKey] = currentLessonData[semKey];
js/firebase-data.js:1115:  globalListenerGeneration++; // whatever the previous listener still has in flight is now stale
js/firebase-data.js:1123:    const isCurrent = () => myGeneration === globalListenerGeneration;
js/firebase-data.js:1133:        currentLessonData[yearKey] = mergeSummerReload(yearKey, previousSummer?.[yearKey], fresh[yearKey]);
js/firebase-data.js:1140:        currentLessonData[plan.semKey] = mergeSummerReload(plan.semKey, previousSummer?.[plan.semKey], fresh[plan.semKey]);
js/firebase-data.js:1143:      lessonDataLoadedSuccessfully = true;
js/firebase-data.js:1149:      lessonDataLoadedSuccessfully = false;
js/firebase-data.js:1155:          reloadSummer(myGeneration, snapshotCampSeasons(), attempt + 1).then(outcome => { if (outcome === 'ok' && callback) callback(currentLessonData); });
js/firebase-data.js:1165:    const myGeneration = ++globalListenerGeneration;
js/firebase-data.js:1167:    if (outcome !== 'stale' && callback) callback(currentLessonData);
js/firebase-data.js:1171:  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
js/firebase-data.js:1172:    .onSnapshot({ includeMetadataChanges: false }, async (doc) => {
js/firebase-data.js:1181:      const myGeneration = ++globalListenerGeneration;
js/firebase-data.js:1186:      currentLessonData = doc.data();
js/firebase-data.js:1187:      for (const [semKey, map] of Object.entries(previousSummer)) currentLessonData[semKey] = map;
js/firebase-data.js:1188:      console.log('📚 Loaded lesson data for semesters:', Object.keys(currentLessonData));
js/firebase-data.js:1194:      if (outcome !== 'stale' && callback) callback(currentLessonData);
js/firebase-data.js:1365:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js:1438:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
js/firebase-data.js:1476:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js:1500:  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
js/firebase-data.js:1554:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js:1577:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js:1651:  // Every successful summer load sets lessonDataLoadedSuccessfully = true and
js/firebase-data.js:1986:  if (lessonDataLoadedSuccessfully === false) {
js/firebase-data.js:2157:  if (!currentLessonData) currentLessonData = {};
js/firebase-data.js:2158:  currentLessonData[yearKey] = buildDayOffSlots(yearKey, currentDayOffEvents[yearKey], currentDayOffCamps[yearKey], currentDayOffPlans[yearKey]);
js/firebase-data.js:2615:// slot map (a reload can briefly swap currentLessonData out from under a save).
js/firebase-data.js:2633:  return currentLessonData[yearKey]?.[lessonKey] || null;
js/app.js:171:  if (lessonDataLoadedSuccessfully === false) {
js/app.js:392:  if (!currentLessonData) await loadLessonData();
js/app.js:393:  const lessons = currentLessonData?.[semKey];
js/app.js:537:  const lessons = currentLessonData?.[semKey];
js/app.js:644:  const lessons = currentLessonData?.[semKey];
js/app.js:660:  if (!currentLessonData) {
js/app.js:668:  if (lessonDataLoadedSuccessfully === false) {
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
js/app.js:3690:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
js/app.js:3704:  if (currentLessonData?.[semKey]?.[lessonKey]) {
js/app.js:3705:    const cached = currentLessonData[semKey][lessonKey];
js/app.js:3708:    currentLessonData[semKey][lessonKey] = {
js/app.js:3773:  const lessons = currentLessonData?.[semKey];
js/app.js:3919:  const lessons = currentLessonData?.[semKey];
js/app.js:4121:  const lesson = currentLessonData?.[semKey]?.[key];
js/app.js:4344:  const lessons = currentLessonData?.[getAdminSemKey()];
js/app.js:4522:      ${!isActive ? `<button class="btn-text ca-delete-sem-btn" onclick="deleteSemester('${escAttr(currentKey)}')" title="Delete this semester">&#128465; Delete</button>` : ''}
js/app.js:4527:async function deleteSemester(key) {
js/app.js:4575:  if (currentLessonData?.[key]) {
js/app.js:4576:    delete currentLessonData[key];
js/app.js:4611:    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
js/app.js:4721:    if (currentLessonData) currentLessonData[key] = {};
js/app.js:4903:      // before this call. It can: deleteSemester() drops a key from local
js/app.js:4929:      const sourceLessons = currentLessonData?.[copyFromKey] || {};
js/app.js:4965:        await saveLessonData(key, emptyLessons);
js/app.js:4966:        if (!currentLessonData) currentLessonData = {};
js/app.js:4967:        currentLessonData[key] = emptyLessons;
js/app.js:4987:    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
js/app.js:5019:  if (!currentLessonData) await loadLessonData();
js/app.js:5039:    currentLessonData = data;
js/app.js:5050:  const lessons = currentLessonData?.[semKey];
js/app.js:5227:  const lessons = currentLessonData?.[semKey];
js/app.js:5519:  const lesson = currentLessonData?.[semKey]?.[key] || null;
js/app.js:5563:  if (lessonDataLoadedSuccessfully === false) {
js/app.js:5589:  const lessons = { ...(currentLessonData?.[semKey] || {}) };
js/app.js:5768:    // execution falls through to commit currentLessonData, close the modal,
js/app.js:5791:  currentLessonData[semKey] = lessons;
js/app.js:5835:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
js/app.js:5869:  if (!currentLessonData[semKey]) currentLessonData[semKey] = {};
js/app.js:5870:  currentLessonData[semKey][sourceKey] = sourceLesson;
js/app.js:5872:    currentLessonData[semKey][destKey] = destLesson;
js/app.js:5874:    delete currentLessonData[semKey][destKey];
js/app.js:5881:  const lessons = { ...currentLessonData[semKey] };
js/app.js:5923:    currentLessonData[semKey] = lessons;
js/app.js:6008:      currentLessonData[semKey] = lessons;
js/app.js:6034:      currentLessonData[semKey] = lessons;
js/app.js:6087:  const lessons = currentLessonData?.[semKey];
js/app.js:6133:      <button class="btn-secondary ca-action-btn" onclick="openDetailModal(currentLessonData['${escAttr(semKey)}']['${escAttr(sourceKey)}'], '${escAttr(sourceKey)}', '${escAttr(source.teacher)}', '${escAttr(source.className)}', ${source.weekNum})">Back</button>
js/app.js:6145:// cached semester via saveLessonData() — any lesson whose local copy was stale
js/app.js:6157:  const liveLessons = currentLessonData?.[semKey];
js/app.js:6200:      if (currentLessonData[semKey]) currentLessonData[semKey][targetKey] = updatedTarget;
js/app.js:6268:  const lessons = { ...currentLessonData[semKey] };
js/app.js:6284:    if (currentLessonData[semKey]) delete currentLessonData[semKey][key];
js/app.js:6331:    currentLessonData[semKey] = lessons;
js/app.js:6414:// saveLessonData() semester overwrite), removal via FieldValue.arrayRemove()
js/app.js:6443:  const lessons = { ...(currentLessonData?.[destSemKey] || {}) };
js/app.js:6494:  currentLessonData[destSemKey] = lessons;
js/app.js:6886:// saveLessonData() write passed the WHOLE {projects:[...]} wrapper into
js/app.js:6908:  const existingLesson = currentLessonData?.[semKey]?.[key] || {};
js/app.js:6950:    if (currentLessonData[semKey]) currentLessonData[semKey][key] = newLesson;
js/app.js:7028:  const lessons = currentLessonData?.[semKey];
js/app.js:7125:// resave the ENTIRE cached semester via saveLessonData() — a Firestore
js/app.js:7146:  if (lessonDataLoadedSuccessfully === false) {
js/app.js:7160:  const cachedExisting = currentLessonData?.[semKey]?.[key];
js/app.js:7202:    : curriculumDb.collection('curriculum').doc('lessonData');
js/app.js:7212:  currentLessonData[semKey][key] = {
js/app.js:7231:  if (lessonDataLoadedSuccessfully === false) {
js/app.js:7245:  const cachedExisting = currentLessonData?.[semKey]?.[key];
js/app.js:7285:    : curriculumDb.collection('curriculum').doc('lessonData');
js/app.js:7299:  currentLessonData[semKey][key] = updatedLesson;
js/app.js:7499:async function computeLiveContentCountByTeacher() {
js/app.js:7518:  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
js/app.js:7583:    const liveCounts = await computeLiveContentCountByTeacher();
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
js/app.js:11428:    await saveLessonData(semKey, lessons);
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
js/app.js:12520:  const writable = lessonDataLoadedSuccessfully !== false;
js/app.js:13048:  const planner = canPlanDayOffCamps() && lessonDataLoadedSuccessfully !== false;
js/app.js:13182:  const planner = canPlanDayOffCamps() && lessonDataLoadedSuccessfully !== false;
js/app.js:13183:  const ticker = canTickDayOffMaterials() && lessonDataLoadedSuccessfully !== false;
js/app.js:13409:  const ticker = canTickDayOffMaterials() && lessonDataLoadedSuccessfully !== false;
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
   215	    result[key] = firestoreValueToJs(val);
   216	  }
   217	  return result;
   218	}
   219	
   220	// Fetch all documents in a collection (handles pagination)
   221	async function fetchCollection(token, collectionId) {
   222	  const docs = {};
   223	  let pageToken = null;
   224	  let pageCount = 0;
   225	
   226	  do {
   227	    const url = new URL(
   228	      `https://firestore.googleapis.com/v1/projects/${PROJECT_ID}/databases/(default)/documents/${collectionId}`
   229	    );
   230	    url.searchParams.set('pageSize', '300');
   231	    if (pageToken) url.searchParams.set('pageToken', pageToken);
   232	
   233	    const res = await fetch(url.toString(), {
   234	      headers: { Authorization: `Bearer ${token}` },
   235	    });
   236	    const data = await res.json();
   237	
   238	    if (data.error) throw new Error(`Firestore error on ${collectionId}: ${JSON.stringify(data.error)}`);
   239	
   240	    for (const doc of data.documents || []) {
   241	      const docId = doc.name.split('/').pop();
   242	      docs[docId] = firestoreDocFieldsToJs(doc.fields || {});
   243	    }
   244	
   245	    pageToken = data.nextPageToken || null;
   246	    pageCount++;
   247	  } while (pageToken);
   248	
   249	  return docs;
   250	}
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

exec
/bin/zsh -lc "rg -n \"function addOrUpdateAlert|Notification|notify|notification|alerts =|localStorage|classbook-qa\" /Users/christiehubley/studio-hub/js/alerts.js /Users/christiehubley/studio-hub/test-alerts-browser.html /Users/christiehubley/studio-hub/TESTING-GUIDE.md; nl -ba /Users/christiehubley/studio-hub/js/alerts.js | sed -n '1,180p;650,760p'; nl -ba js/app.js | sed -n '7490,7555p'; nl -ba js/firebase-data.js | sed -n '790,845p;1080,1210p;1350,1510p'" in /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81
 succeeded in 0ms:
/Users/christiehubley/studio-hub/js/alerts.js:5:  let alerts = []; // In-memory alert storage
/Users/christiehubley/studio-hub/js/alerts.js:29:    alerts = [];
/Users/christiehubley/studio-hub/js/alerts.js:54:    // Load from localStorage first (fast, same-browser)
/Users/christiehubley/studio-hub/js/alerts.js:56:      const local = localStorage.getItem('studioHub_dismissedAlerts');
/Users/christiehubley/studio-hub/js/alerts.js:68:          localStorage.setItem('studioHub_dismissedAlerts', JSON.stringify(ids));
/Users/christiehubley/studio-hub/js/alerts.js:79:    // Save to localStorage immediately (always works)
/Users/christiehubley/studio-hub/js/alerts.js:80:    localStorage.setItem('studioHub_dismissedAlerts', JSON.stringify(ids));
/Users/christiehubley/studio-hub/js/alerts.js:288:            subtitle: 'Send waitlist number notification',
/Users/christiehubley/studio-hub/js/alerts.js:592:              const alertId = `classbook-qa-${lessonKey}`;
/Users/christiehubley/studio-hub/js/alerts.js:654:  function addOrUpdateAlert(alert) {
/Users/christiehubley/studio-hub/js/alerts.js:676:    alerts = alerts.filter(a => a.id !== alertId);
/Users/christiehubley/studio-hub/js/alerts.js:691:      alerts = alerts.filter(a => a.id !== alertId);
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
   131	          }
   132	        });
   133	
   134	        updateUI();
   135	      }, error => {
   136	        console.error('Timeclock entries listener error:', error);
   137	      });
   138	
   139	    // Pending time-off requests (status = submitted or under_review)
   140	    const timeoffListener = db.collection('timeclock_timeoff')
   141	      .where('status', 'in', ['submitted', 'under_review'])
   142	      .onSnapshot(snapshot => {
   143	        snapshot.docChanges().forEach(change => {
   144	          const request = change.doc.data();
   145	          const alertId = `timeoff-${change.doc.id}`;
   146	
   147	          if (change.type === 'added' || change.type === 'modified') {
   148	            const statusLabel = request.status === 'under_review' ? 'Under Review' : 'Submitted';
   149	            addOrUpdateAlert({
   150	              id: alertId,
   151	              type: 'timeclock',
   152	              priority: 'info',
   153	              title: `Time-off request: ${request.name || request.employeeName || 'Employee'}`,
   154	              subtitle: `${request.category || 'Request'} - ${formatDateRange(request.dates?.[0], request.dates?.[request.dates.length - 1])} (${statusLabel})`,
   155	              timestamp: request.submittedAt || new Date().toISOString(),
   156	              actionLabel: 'Review Request',
   157	              actionUrl: 'https://tinker-timeclock.netlify.app#timeoff',
   158	              metadata: { requestId: change.doc.id, employeeName: request.name || request.employeeName }
   159	            });
   160	          } else if (change.type === 'removed') {
   161	            removeAlert(alertId);
   162	          }
   163	        });
   164	
   165	        updateUI();
   166	      }, error => {
   167	        console.error('Timeclock timeoff listener error:', error);
   168	      });
   169	
   170	    listeners.push(entriesListener, timeoffListener);
   171	  }
   172	
   173	  // =====================================================
   174	  // Private Events Alerts
   175	  // =====================================================
   176	
   177	  function listenToPrivateEvents(db) {
   178	    // New inquiries (status = new)
   179	    const newInquiriesListener = db.collection('privateEvents')
   180	      .where('status', '==', 'new')
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
   671	      alerts.push(alert);
   672	    }
   673	  }
   674	
   675	  function removeAlert(alertId) {
   676	    alerts = alerts.filter(a => a.id !== alertId);
   677	    // If the underlying data resolved, auto-clean the dismissal too
   678	    if (dismissedAlertIds.has(alertId)) {
   679	      dismissedAlertIds.delete(alertId);
   680	      dismissedAlerts = dismissedAlerts.filter(a => a.id !== alertId);
   681	      saveDismissedAlerts();
   682	    }
   683	  }
   684	
   685	  function dismissAlert(alertId) {
   686	    const alert = alerts.find(a => a.id === alertId);
   687	    if (alert) {
   688	      alert.dismissed = true;
   689	      alert.dismissedAt = new Date().toISOString();
   690	      dismissedAlerts.push(alert);
   691	      alerts = alerts.filter(a => a.id !== alertId);
   692	      dismissedAlertIds.add(alertId);
   693	      saveDismissedAlerts();
   694	      updateUI();
   695	    }
   696	  }
   697	
   698	  function restoreAlert(alertId) {
   699	    const alert = dismissedAlerts.find(a => a.id === alertId);
   700	    if (alert) {
   701	      delete alert.dismissed;
   702	      delete alert.dismissedAt;
   703	      alerts.push(alert);
   704	      dismissedAlerts = dismissedAlerts.filter(a => a.id !== alertId);
   705	      dismissedAlertIds.delete(alertId);
   706	      saveDismissedAlerts();
   707	      updateUI();
   708	    }
   709	  }
   710	
   711	  function toggleDismissed() {
   712	    showDismissed = !showDismissed;
   713	
   714	    // Update toggle button state
   715	    const toggleBtn = document.getElementById('toggle-dismissed');
   716	    if (toggleBtn) {
   717	      if (showDismissed) {
   718	        toggleBtn.classList.add('active');
   719	        toggleBtn.innerHTML = '<span class="toggle-icon">📋</span> Hide Dismissed';
   720	      } else {
   721	        toggleBtn.classList.remove('active');
   722	        const count = dismissedAlerts.length;
   723	        toggleBtn.innerHTML = `<span class="toggle-icon">📋</span> Show Dismissed (<span id="dismissed-count">${count}</span>)`;
   724	      }
   725	    }
   726	
   727	    renderAlertFeed();
   728	  }
   729	
   730	  // =====================================================
   731	  // UI Updates
   732	  // =====================================================
   733	
   734	  function updateUI() {
   735	    updateStatCards();
   736	    renderAlertFeed();
   737	    updateDismissedCount();
   738	  }
   739	
   740	  function updateDismissedCount() {
   741	    const countEl = document.getElementById('dismissed-count');
   742	    if (countEl) {
   743	      countEl.textContent = dismissedAlerts.length;
   744	    }
   745	  }
   746	
   747	  function updateStatCards() {
   748	    // Count alerts by priority (matches category badges)
   749	    const pending = alerts.filter(a => a.priority === 'info').length;
   750	    const overdue = alerts.filter(a => a.priority === 'warning').length;
   751	    const urgent = alerts.filter(a => a.priority === 'urgent').length;
   752	
   753	    // Update stat card values
   754	    const pendingStat = document.getElementById('stat-pending');
   755	    const overdueStat = document.getElementById('stat-overdue');
   756	    const urgentStat = document.getElementById('stat-urgent');
   757	
   758	    if (pendingStat) pendingStat.textContent = pending;
   759	    if (overdueStat) overdueStat.textContent = overdue;
   760	    if (urgentStat) urgentStat.textContent = urgent;
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

web search: 
web search: site:firebase.google.com/docs/firestore/manage-data/transactions transaction maximum request size 10 MiB reads before writes ...
codex
## Verdict: NOT EXECUTION-READY

Revision 3 substantially improves the plan, but the rollback rules contradict the required reverse transaction, and target-document deletion remains unsafe.

### Round-1 minimum items

1. **NOT — close verification/rollback race.** Updates are paused until verification ([plan:68](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:68)), but classbook-admin/curriculum-admin may delete the only new copy before verification ([plan:81](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:81)). Worse, rollback requires re-adding Spring ([plan:162](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:162)), while Phase A expressly denies that operation ([plan:77](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:77), [plan:84](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:84), [plan:92](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:92)).

2. **RESOLVED — verify target before source deletion.** Copy, source removal, and migration record are now atomic ([plan:153-159](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:153)); forced-server verification covers target hash/count, source absence, and migration hash ([plan:160](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:160)).

3. **RESOLVED — source create/delete fence and role coverage.** Whole-document deletion and recreation with Spring are denied, with all five roles covered ([plan:75-99](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:75)).

4. **RESOLVED — stale-tab cutoff.** Three-day deployment interval, staff reopen request, and rule-denied legacy writes are specified ([plan:146-147](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:146)).

5. **RESOLVED — double counting.** There is no dual-copy interval, and live counts explicitly choose one source ([plan:67](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:67), [plan:115](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:115)). The backup’s generic `lessons_*` count is safe under that atomic move.

6. **NOT — Studio Hub alert transition.** Per-source union and semester-qualified IDs correctly fix erasure and collisions ([plan:118](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:118)). However, current Studio Hub deduplicates and persists dismissals strictly by ID ([alerts.js:654](/Users/christiehubley/studio-hub/js/alerts.js:654)); changing IDs will resurrect dismissed alerts. “If Studio Hub dedupes by content” is false against this code.

7. **RESOLVED — Spring deletion UI.** `deleteSemester('spring-2026')` is disabled with a clear message ([plan:116](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:116), [plan:137](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:137)).

8. **RESOLVED — merge, disappearance, headroom.** Migration writes use merge ([plan:157](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:157)); disappearance falls back or becomes visibly loud ([plan:107-114](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:107)); the estimate is explicitly approximate, field-size based rather than JSON length, with an 85% warning ([plan:117](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:117)).

### Revision-3 technical checks

- **Forward transaction:** Yes. With all three reads performed first, one transaction can create the Spring document, update the near-1-MB source into a smaller post-write document, and merge the small migration record. The proposed Phase A predicates permit those three manager operations. Re-measuring immediately before execution remains necessary ([plan:203](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:203)).
- **Reverse transaction:** No. The required manager re-add while unverified is absent from—and contradicted by—the Phase A rules.
- **Edit pause:** Updates are correctly gated by `storageMigrations`, but deletes are not safely gated: non-manager admins can delete before verification, and a manager can delete the sole copy after verification.
- **Alert re-keying:** Union logic is sound; dismissal migration is unspecified and current code is ID-only.
- **Headroom:** Adequately conservative as a diagnostic, provided the implementation includes UTF-8 field/value sizing and tests known nested values.

### Minimum fixes

1. Add a narrowly bounded manager/admin rollback allowance to re-add only `spring-2026` while unverified, ideally requiring with `getAfter()` that `lessons_spring-2026` is deleted in the same transaction; replace the contradictory denial test.
2. Permit target deletion only for the manager/admin rollback while unverified. Deny it to classbook-admin/curriculum-admin and deny everyone after verification until routed deletion/archive exists. Add all-role tests for both states.
3. Define migration of old dismissed alert IDs to semester-qualified IDs, or explicitly accept and test that dismissed alerts resurface.

No files were edited and no tests were run.
tokens used
54,212
## Verdict: NOT EXECUTION-READY

Revision 3 substantially improves the plan, but the rollback rules contradict the required reverse transaction, and target-document deletion remains unsafe.

### Round-1 minimum items

1. **NOT — close verification/rollback race.** Updates are paused until verification ([plan:68](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:68)), but classbook-admin/curriculum-admin may delete the only new copy before verification ([plan:81](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:81)). Worse, rollback requires re-adding Spring ([plan:162](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:162)), while Phase A expressly denies that operation ([plan:77](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:77), [plan:84](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:84), [plan:92](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:92)).

2. **RESOLVED — verify target before source deletion.** Copy, source removal, and migration record are now atomic ([plan:153-159](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:153)); forced-server verification covers target hash/count, source absence, and migration hash ([plan:160](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:160)).

3. **RESOLVED — source create/delete fence and role coverage.** Whole-document deletion and recreation with Spring are denied, with all five roles covered ([plan:75-99](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:75)).

4. **RESOLVED — stale-tab cutoff.** Three-day deployment interval, staff reopen request, and rule-denied legacy writes are specified ([plan:146-147](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:146)).

5. **RESOLVED — double counting.** There is no dual-copy interval, and live counts explicitly choose one source ([plan:67](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:67), [plan:115](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:115)). The backup’s generic `lessons_*` count is safe under that atomic move.

6. **NOT — Studio Hub alert transition.** Per-source union and semester-qualified IDs correctly fix erasure and collisions ([plan:118](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:118)). However, current Studio Hub deduplicates and persists dismissals strictly by ID ([alerts.js:654](/Users/christiehubley/studio-hub/js/alerts.js:654)); changing IDs will resurrect dismissed alerts. “If Studio Hub dedupes by content” is false against this code.

7. **RESOLVED — Spring deletion UI.** `deleteSemester('spring-2026')` is disabled with a clear message ([plan:116](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:116), [plan:137](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:137)).

8. **RESOLVED — merge, disappearance, headroom.** Migration writes use merge ([plan:157](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:157)); disappearance falls back or becomes visibly loud ([plan:107-114](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:107)); the estimate is explicitly approximate, field-size based rather than JSON length, with an 85% warning ([plan:117](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:117)).

### Revision-3 technical checks

- **Forward transaction:** Yes. With all three reads performed first, one transaction can create the Spring document, update the near-1-MB source into a smaller post-write document, and merge the small migration record. The proposed Phase A predicates permit those three manager operations. Re-measuring immediately before execution remains necessary ([plan:203](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:203)).
- **Reverse transaction:** No. The required manager re-add while unverified is absent from—and contradicted by—the Phase A rules.
- **Edit pause:** Updates are correctly gated by `storageMigrations`, but deletes are not safely gated: non-manager admins can delete before verification, and a manager can delete the sole copy after verification.
- **Alert re-keying:** Union logic is sound; dismissal migration is unspecified and current code is ID-only.
- **Headroom:** Adequately conservative as a diagnostic, provided the implementation includes UTF-8 field/value sizing and tests known nested values.

### Minimum fixes

1. Add a narrowly bounded manager/admin rollback allowance to re-add only `spring-2026` while unverified, ideally requiring with `getAfter()` that `lessons_spring-2026` is deleted in the same transaction; replace the contradictory denial test.
2. Permit target deletion only for the manager/admin rollback while unverified. Deny it to classbook-admin/curriculum-admin and deny everyone after verification until routed deletion/archive exists. Add all-role tests for both states.
3. Define migration of old dismissed alert IDs to semester-qualified IDs, or explicitly accept and test that dismissed alerts resurface.

No files were edited and no tests were run.
