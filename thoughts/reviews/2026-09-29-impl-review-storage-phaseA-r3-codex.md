Reading additional input from stdin...
OpenAI Codex v0.147.0
--------
workdir: /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
model: gpt-5.6-sol
provider: openai
approval: never
sandbox: read-only
reasoning effort: none
reasoning summaries: none
session id: 01a0ef3c-c635-76f0-82eb-ee12dba0a388
--------
user
## Implementation review round 3 — Phase A rules (narrow)
Your round 2: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA-r2-codex.md. Diff vs main: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA-r3.diff. Worktree (read-only): /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence.
Check only: your round-2 blocker (RESOLVED / NOT, file:line) and whether the getAfter/existsAfter change introduced anything wrong (e.g. getAfter(lessonData) cost/limits when lessonData isn't part of the request; the move transaction; standalone verify). Verdict: SAFE TO MERGE AND DEPLOY or NOT. Be brief. Do not edit files or run tests.
codex
I’ll inspect the round-2 review, the supplied diff, and the relevant current rules/tests only. I won’t edit anything or run tests.
exec
/bin/zsh -lc "sed -n '1,240p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA-r2-codex.md && sed -n '1,320p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA-r3.diff" in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
 succeeded in 0ms:
Reading additional input from stdin...
OpenAI Codex v0.147.0
--------
workdir: /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
model: gpt-5.6-sol
provider: openai
approval: never
sandbox: read-only
reasoning effort: none
reasoning summaries: none
session id: 01a0ef3a-2ffa-7cb1-a0d7-4e26eab721b2
--------
user
## Implementation review round 2 — Phase A rules
Your round 1: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA-codex.md. Full diff vs main now: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA-r2.diff. Worktree (read-only): /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence.
Check: (1) your two blocking findings — RESOLVED / NOT with file:line; (2) anything the fix introduced (e.g. the get() of the ~1 MiB lessonData inside the storageMigrations rule — limits; the move transaction itself writing storageMigrations with verified:false; the verify step as a standalone manager update; the ternary in a rules condition); (3) any remaining bypass. Verdict: SAFE TO MERGE AND DEPLOY or NOT (minimum list). Be brief. Do not edit files or run tests.
codex
I’ll review the round-one findings and the supplied round-two diff, then trace the affected rules and write paths. I’ll keep this read-only and won’t run tests.
exec
/bin/zsh -lc "sed -n '1,240p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA-codex.md && sed -n '1,320p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA-r2.diff" in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
 succeeded in 0ms:
Reading additional input from stdin...
OpenAI Codex v0.147.0
--------
workdir: /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
model: gpt-5.6-sol
provider: openai
approval: never
sandbox: read-only
reasoning effort: none
reasoning summaries: none
session id: 01a0ef35-2397-7ab2-9f9b-b518010a7205
--------
user
## Implementation review — Phase A (Firestore rules), before merge and deploy
Plan: /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase A, rev 5).
Diff: /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA.diff
Worktree (read-only): /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence (firestore.rules, rules.test.js). These rules govern EVERY staff app in the tinker-hq-apps project.
Adversarially review the actual code:
1. Does the new /curriculum/{docId} block preserve exactly the old behaviour for every doc other than lessonData / lessons_spring-2026 / storageMigrations, for every role (admin, manager, classbook, classbook-admin, curriculum-admin, no access, archived users, kiosk, reminder bot)? Any statement that now grants more than before?
2. Does it implement Phase A exactly (fence, move, rollback with existsAfter, verified gating, delete rules)? Any bypass (set with merge, set without merge, batch vs transaction, field-path tricks, creating lessonData when absent, map-valued 'spring-2026' vs dotted paths)?
3. Will the Classbook's real current writes to lessonData keep working (saveSingleLesson dotted per-field updates, saveMultipleLessonFields, saveLessonData merge-set, deleteLessonKey, Q&A/help replies — see /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js and js/app.js), including when lessonData is near 1 MiB? Anything in Studio Hub or other apps writing /curriculum?
4. Rules limits/cost: get/exists call counts per request, evaluation on a near-1 MiB doc.
5. Are the tests meaningful (would a wrong rule pass them)? Gaps?
Verdict: SAFE TO MERGE AND DEPLOY or NOT (minimum list). Do not edit files or run tests.
codex
I’ll inspect the reviewed plan, supplied diff, current rules/tests, and the named Classbook write paths. I’ll keep this strictly read-only and won’t execute the test suite.
exec
/bin/zsh -lc 'wc -l /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA.diff firestore.rules rules.test.js /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js && git status --short && rg -n "match /curriculum|lessonData|lessons_spring-2026|storageMigrations|saveSingleLesson|saveMultipleLessonFields|saveLessonData|deleteLessonKey|Q&A|help|reply|curriculum/" firestore.rules rules.test.js /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js' in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
 succeeded in 0ms:
     256 /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html
     373 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA.diff
    1161 firestore.rules
    2836 rules.test.js
    3123 /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js
   13555 /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js
   21304 total
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-hShqQ1Bh' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-dyvPBpPw' (errno=Operation not permitted)
?? node_modules
rules.test.js:80:  // Seed user docs so helper functions (isAdmin, isManager, hasAppAccess) work
rules.test.js:1482:  'summerCamps_curriculum', 'summerCamps_schedule', 'summerCamps_lessonData',
rules.test.js:2186:// plans (dayOffCamps_lessonData) are teacher create/update like summerCamps_lessonData, admin-only
rules.test.js:2189:const SDOC_COLLECTIONS = ['dayOffCamps_events', 'dayOffCamps_camps', 'dayOffCamps_lessonData'];
rules.test.js:2255:  // Plans are the teacher's to write (Phase 2), exactly as summerCamps_lessonData — per-teacher
rules.test.js:2259:    await assertSucceeds(setDoc(doc(db, 'dayOffCamps_lessonData', 'teacher-new'), { yearKey: 'sdoc-2026-27', introPitch: 'hi' }));
rules.test.js:2260:    await assertSucceeds(updateDoc(doc(db, 'dayOffCamps_lessonData', SDOC_SEED_ID), { introPitch: 'edited' }));
rules.test.js:2433:  test('the Booking helper functions no longer exist in firestore.rules', () => {
rules.test.js:2542:  test('waitlist and appData are unchanged for Clay Hub staff (shared helper refactor)', async () => {
rules.test.js:2558:  test('managers keep full access to waitlist and appData (shared helper refactor)', async () => {
rules.test.js:2590:// ─── CLASSBOOK — SPRING 2026 STORAGE MOVE (lessonData fence) ────────────────
rules.test.js:2592:// curriculum/lessonData (every Fall/Spring semester in ONE document) was at 95% of Firestore's
rules.test.js:2593:// 1 MiB cap on Sep 29 2026. Spring 2026 moves to curriculum/lessons_spring-2026 in one
rules.test.js:2594:// manager transaction. These rules: nobody changes lessonData's spring-2026 key except the
rules.test.js:2596:// same transaction); nobody deletes the whole lessonData doc; the new doc is created by a
rules.test.js:2597:// manager, edited only once storageMigrations says the move is verified, and deleted only by a
rules.test.js:2601:const SPRING_DOC = 'lessons_spring-2026';
rules.test.js:2602:const MIGRATIONS = 'storageMigrations';
rules.test.js:2617:    const lessonData = { 'fall-2026': { 'allie-wednesday-1': { teacher: 'Allie', shortDetails: 'Print' } }, lastUpdated: 'x' };
rules.test.js:2618:    if (spring) lessonData[SPRING] = springMap();
rules.test.js:2619:    await setDoc(doc(db, 'curriculum', 'lessonData'), lessonData);
rules.test.js:2628:    const ld = await tx.get(doc(db, 'curriculum', 'lessonData'));
rules.test.js:2634:    tx.update(doc(db, 'curriculum', 'lessonData'), { [SPRING]: deleteField() });
rules.test.js:2641:    await tx.get(doc(db, 'curriculum', 'lessonData'));
rules.test.js:2643:    tx.update(doc(db, 'curriculum', 'lessonData'), { [SPRING]: springMap() });
rules.test.js:2648:describe('Classbook storage move — lessonData spring-2026 fence', () => {
rules.test.js:2651:  test.each(FENCE_ROLES)('%s can still update another semester in lessonData', async (_l, uid) => {
rules.test.js:2652:    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026.allie-wednesday-1.shortDetails': 'Updated' }));
rules.test.js:2654:  test.each(FENCE_ROLES)('%s CANNOT change a spring-2026 lesson in lessonData', async (_l, uid) => {
rules.test.js:2655:    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.mariah-tuesday-1.shortDetails': 'Changed' }));
rules.test.js:2657:  test.each(FENCE_ROLES)('%s CANNOT add a new spring-2026 lesson in lessonData', async (_l, uid) => {
rules.test.js:2658:    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.new-lesson': { teacher: 'X' } }));
rules.test.js:2661:    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField() }));
rules.test.js:2664:    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField() }));
rules.test.js:2667:    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField(), 'fall-2026.allie-wednesday-1.shortDetails': 'x' }));
rules.test.js:2669:  test.each(FENCE_ROLES)('%s CANNOT delete the whole lessonData document', async (_l, uid) => {
rules.test.js:2670:    await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', 'lessonData')));
rules.test.js:2672:  test.each(FENCE_ROLES)('%s CANNOT replace lessonData with a set() that changes spring-2026', async (_l, uid) => {
rules.test.js:2673:    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': {}, [SPRING]: { stale: true } }));
rules.test.js:2675:  test.each(FENCE_ROLES)('%s can still merge-set another semester into lessonData (saveLessonData shape)', async (_l, uid) => {
rules.test.js:2676:    await assertSucceeds(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': { 'new-slot': { teacher: 'Allie' } } }, { merge: true }));
rules.test.js:2680:describe('Classbook storage move — lessonData cannot be recreated with spring-2026', () => {
rules.test.js:2683:    await testEnv.withSecurityRulesDisabled(async (ctx) => { await deleteDoc(doc(ctx.firestore(), 'curriculum', 'lessonData')); });
rules.test.js:2685:  test.each(FENCE_ROLES)('%s CANNOT create lessonData containing spring-2026', async (_l, uid) => {
rules.test.js:2686:    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
rules.test.js:2688:  test.each(FENCE_ROLES)('%s can create lessonData without spring-2026 (as today)', async (_l, uid) => {
rules.test.js:2689:    await assertSucceeds(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': {} }));
rules.test.js:2701:  test.each(NON_MANAGER_ROLES)('%s CANNOT create lessons_spring-2026', async (_l, uid) => {
rules.test.js:2704:  test.each(NON_MANAGER_ROLES)('%s CANNOT write storageMigrations', async (_l, uid) => {
rules.test.js:2707:  test.each(FENCE_ROLES)('%s can read storageMigrations once it exists', async (_l, uid) => {
rules.test.js:2716:  test.each(FENCE_ROLES)('%s CANNOT edit lessons_spring-2026 before verification', async (_l, uid) => {
rules.test.js:2719:  test.each(FENCE_ROLES)('%s can read lessons_spring-2026', async (_l, uid) => {
rules.test.js:2731:  test.each(FENCE_ROLES)('%s CANNOT plainly re-add spring-2026 to lessonData', async (_l, uid) => {
rules.test.js:2732:    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
rules.test.js:2734:  test.each(MANAGER_ROLES)('%s can delete lessons_spring-2026 before verification', async (_l, uid) => {
rules.test.js:2737:  test.each(NON_MANAGER_ROLES)('%s CANNOT delete lessons_spring-2026', async (_l, uid) => {
rules.test.js:2743:  test.each(MANAGER_ROLES)('%s CANNOT create lessons_spring-2026 again while it exists (set over it is an update, refused while unverified)', async (_l, uid) => {
rules.test.js:2751:  test.each(FENCE_ROLES)('%s can edit a Spring lesson in lessons_spring-2026', async (_l, uid) => {
rules.test.js:2754:  test.each(FENCE_ROLES)('%s CANNOT delete lessons_spring-2026 after verification', async (_l, uid) => {
rules.test.js:2760:  test.each(FENCE_ROLES)('%s CANNOT re-create spring-2026 in lessonData', async (_l, uid) => {
rules.test.js:2761:    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.stale': { teacher: 'X' } }));
rules.test.js:2763:  test.each(FENCE_ROLES)('%s still updates Fall in lessonData normally', async (_l, uid) => {
rules.test.js:2764:    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026.allie-wednesday-1.shortDetails': 'Updated' }));
rules.test.js:2793:    await assertFails(updateDoc(doc(getDb(STAFF_NOACCESS_UID), 'curriculum', 'lessonData'), { 'fall-2026.x': {} }));
rules.test.js:2797:// A near-1 MiB lessonData (how production looked on Sep 29 2026): prove the fence evaluates on a
rules.test.js:2799:describe('Classbook storage move — fence on a near-1 MiB lessonData', () => {
rules.test.js:2819:      await setDoc(doc(ctx.firestore(), 'curriculum', 'lessonData'), big);
rules.test.js:2830:    await assertSucceeds(updateDoc(doc(getDb(CLASSBOOK_UID), 'curriculum', 'lessonData'), { 'fall-2026.teacher-class-1.shortDetails': 'Updated' }));
rules.test.js:2831:    await assertFails(updateDoc(doc(getDb(CLASSBOOK_UID), 'curriculum', 'lessonData'), { 'spring-2026.teacher-class-1.shortDetails': 'Changed' }));
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:5://   curriculum/appData     — semester config (URLs, GIDs, settings)
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:6://   curriculum/prepData    — prep team data by semester/week
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:7://   curriculum/lessonData  — all lesson content by semester (imported from classbooks)
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:8://   curriculum/cutProjects — projects removed from schedule, saved for reuse
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:9://   curriculum/changeLog   — audit trail of moves/swaps/cuts
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:14:let lessonDataUnsubscribe = null;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:56:// lesson in summerCamps_lessonData) or 'weekly' (one nested map inside the
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:57:// shared curriculum/lessonData document). The seven sites that choose between
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:58:// those two stores — the four lesson writers, the two admin reply writers and
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:60:// rather than treated as weekly: the reply writers' weekly branch update()s
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:128:let lessonDataLoadedSuccessfully = null; // null = not yet loaded, true = ok, false = failed
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:146:// ─── Config (curriculum/appData) ─────────────────────
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:148:// True once a read of curriculum/appData has FAILED (as opposed to the
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:164://                                   lessonDataLoadedSuccessfully = false makes
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:175:    console.error('❌ Could not read curriculum/appData — refusing to guess at the configuration:', err);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:177:    lessonDataLoadedSuccessfully = false;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:241:// Forced-server read of curriculum/appData — bypasses the SDK cache. Used
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:339:  // lessonDataLoadedSuccessfully = true and re-hide the banner this mode just
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:345:    lessonDataLoadedSuccessfully = false;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:533:// ─── Prep Data (curriculum/prepData) ─────────────────
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:609:// ─── Prep Cycle Config (curriculum/prepCycleConfig) ──
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:730:// ─── Lesson Data (curriculum/lessonData) ─────────────
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:762:    const doc = await curriculumDb.collection('curriculum').doc('lessonData').get();
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:779:      lessonDataLoadedSuccessfully = true;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:784:      lessonDataLoadedSuccessfully = false;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:789:    lessonDataLoadedSuccessfully = false;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:796:// saveSingleLesson(): after a failed load, `lessons` is built from an empty or
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:802:async function saveLessonData(semesterKey, lessons) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:803:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:815:  // Regular semester: save to curriculum/lessonData
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:817:  await curriculumDb.collection('curriculum').doc('lessonData').set({
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:827:async function deleteLessonKey(semesterKey, lessonKey) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:830:  await curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:851:  for (const [lessonKey, lessonData] of Object.entries(lessons)) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:853:    if (!hasContent(lessonData)) continue;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:854:    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocId(encodeFirestoreKey(lessonKey), season));
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:857:    const stripped = { ...lessonData };
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:891:// Same load guard as the lesson writers (saveLessonData/saveSingleLesson):
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:895:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:925:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:963:  await curriculumDb.collection('curriculum').doc('lessonData').update({
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:968:// Forced-server read of one semester's whole lesson map in curriculum/lessonData
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:975:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get({ source: 'server' });
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:985:  await curriculumDb.collection('curriculum').doc('lessonData_backup').set({
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:995:  const backupDoc = await curriculumDb.collection('curriculum').doc('lessonData_backup').get();
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1000:  await saveLessonData(semesterKey, lessons);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1012:// The fields a saved summerCamps_lessonData doc contributes to a lesson slot
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1065:      // else that was sitting on it (e.g. legacy Q&A mirror fields another
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1078:// shared curriculum/lessonData doc re-runs the summer collection reload.
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1116:  if (lessonDataUnsubscribe) lessonDataUnsubscribe();
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1143:      lessonDataLoadedSuccessfully = true;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1149:      lessonDataLoadedSuccessfully = false;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1171:  lessonDataUnsubscribe = curriculumDb.collection('curriculum').doc('lessonData')
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1182:      // curriculum/lessonData holds the WEEKLY semesters; the camp seasons live
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1198:// ─── Cut Projects (curriculum/cutProjects) ───────────
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1222:// ─── Future Projects / Idea Bank (curriculum/futureProjects) ──
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1247:// ─── Change Log (curriculum/changeLog) ───────────────
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1286:// ─── Diagnostic Dismissals (curriculum/diagnosticDismissals) ──
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1361:// authoritative: it overrides whatever (possibly stale) value lessonData
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1364:async function saveSingleLesson(semesterKey, lessonKey, lessonData, fieldsToClear = [], opts = {}) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1365:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1370:  lessonData.lastEditedBy = user?.name || 'Unknown';
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1371:  lessonData.lastEditedAt = new Date().toISOString();
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1376:  // callers fall through to curriculum/lessonData on anything that isn't
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1378:  if (isDayOffYear(semesterKey)) return saveDayOffPlan(semesterKey, lessonKey, lessonData, fieldsToClear, opts.dayOffAuth);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1382:  const hasContent = lessonHasContent(lessonData);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1395:    const hasPhotoField = 'photoUrl' in lessonData || 'photoPath' in lessonData;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1396:    if (!hasContent && !hasPhotoField && !('planComplete' in lessonData) && fieldsToActuallyClear.length === 0) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1397:      console.warn('⛔ saveSingleLesson blocked — all content fields empty, refusing to overwrite:', lessonKey);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1402:    const stripped = { ...lessonData };
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1412:    console.log('💾 Saving Summer Camp lesson to summerCamps_lessonData:', lessonKey);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1413:    const docRef = curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semesterKey, lessonKey));
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1429:  // Regular semester: curriculum/lessonData is one shared doc across every
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1433:  // actually present in lessonData (Data Safety Plan Stage 2D).
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1434:  const updates = buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1436:  console.log('💾 Saving to curriculum/lessonData with per-field paths:', Object.keys(updates));
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1438:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1446:// Backtracking audit, Phase 9: pure helper — computes the dotted-path update
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1447:// object for ONE lesson within the shared curriculum/lessonData document,
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1448:// given an already-finalized lessonData object. Extracted from
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1449:// saveSingleLesson()'s non-summer branch above so it can be reused by
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1450:// saveMultipleLessonFields() below without duplicating the stripping/clearing
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1455:function buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear = []) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1456:  // Not restricted to CONTENT_FIELDS — see the fieldsToClear comment above saveSingleLesson().
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1457:  const stripped = { ...lessonData };
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1472:// vulnerable to (does NOT independently verify the given lessonData reflects
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1475:async function saveMultipleLessonFields(semesterKey, writes = [], deletes = []) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1476:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1485:    throw new Error('saveMultipleLessonFields() does not support camp seasons — use saveSingleLesson() per lesson instead.');
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1490:  for (const { lessonKey, lessonData, fieldsToClear } of writes) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1491:    lessonData.lastEditedBy = user?.name || 'Unknown';
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1492:    lessonData.lastEditedAt = new Date().toISOString();
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1493:    Object.assign(combined, buildLessonFieldUpdates(semesterKey, lessonKey, lessonData, fieldsToClear || []));
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1500:  await curriculumDb.collection('curriculum').doc('lessonData').update(combined);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1530:  // Store at curriculum/{semester}/{lessonKey}/demo-{unique}.jpg
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1531:  return `curriculum/${semesterKey}/${lessonKey}/demo-${uniquePhotoSuffix()}.jpg`;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1554:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1575:// curriculum/ prefix storage.rules already allows — no Storage rules change.
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1577:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1584:  const path = `curriculum/${yearKey}/${dayOffPlanDocId(yearKey, campId, projectTitle)}/demo-${uniquePhotoSuffix()}.jpg`;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1651:  // Every successful summer load sets lessonDataLoadedSuccessfully = true and
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1814:    // 6. Load saved lesson plans from summerCamps_lessonData
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1817:      const savedLessonsSnap = await scoped('summerCamps_lessonData').get();
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1854:      if (skippedForeignSeason > 0) console.warn(`⚠️ Skipped ${skippedForeignSeason} summerCamps_lessonData document(s) stamped for another season.`);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1876:// every one carrying `yearKey`. Nothing here touches curriculum/lessonData or
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1878:const DAY_OFF_COLLECTIONS = { events: 'dayOffCamps_events', camps: 'dayOffCamps_camps', plans: 'dayOffCamps_lessonData' };
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1930:// Materials live on the project's plan record (dayOffCamps_lessonData) as
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:1986:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:2027:// field counts — text, photo, Q&A, Plan Complete, materials — so a photo-only
diff --git a/firestore.rules b/firestore.rules
index ec41acd..28f95be 100644
--- a/firestore.rules
+++ b/firestore.rules
@@ -650,8 +650,54 @@ service cloud.firestore {
     // ═══════════════════════════════════════════════════════════════
 
     match /curriculum/{docId} {
-      // Manager+: full access to everything including appData
-      allow read, write: if isManagerOrAbove();
+      // ── Spring 2026 storage move (Sep 29 2026) ──────────────────────────
+      // Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase A).
+      // curriculum/lessonData holds every Fall/Spring semester in ONE document and was at 95% of
+      // Firestore's 1 MiB cap. Spring 2026 moves to curriculum/lessons_spring-2026 in one manager
+      // transaction. Three docs therefore get their own rules below; every other curriculum doc
+      // keeps exactly the rules it had (the "ordinary docs" lines).
+      //   lessonData          — nobody changes its 'spring-2026' key, except manager+ deleting ONLY
+      //                         that key (the move) or re-adding ONLY that key while the move is
+      //                         unverified AND the new doc is deleted in the same transaction
+      //                         (the rollback). Nobody deletes the whole document.
+      //   lessons_spring-2026 — created by manager+; edited only once storageMigrations says the move
+      //                         is verified; deleted only by manager+ and only while unverified.
+      //   storageMigrations   — manager+ writes; classbook roles read.
+      function isClassbookRole() {
+        return hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook');
+      }
+      function isClassbookAdminRole() {
+        return hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin');
+      }
+      function isStorageMoveDoc() {
+        return docId in ['lessonData', 'lessons_spring-2026', 'storageMigrations'];
+      }
+      function springMoveVerified() {
+        let path = /databases/$(database)/documents/curriculum/storageMigrations;
+        return exists(path) && get(path).data.get('spring-2026', {}).get('verified', false) == true;
+      }
+      function lessonDataChangedKeys() {
+        return request.resource.data.diff(resource.data).affectedKeys();
+      }
+      function springKeyUntouched() {
+        return !lessonDataChangedKeys().hasAny(['spring-2026']);
+      }
+      function springKeyRemovedOnly() {
+        return lessonDataChangedKeys().hasOnly(['spring-2026'])
+          && !('spring-2026' in request.resource.data);
+      }
+      function springKeyRolledBack() {
+        return lessonDataChangedKeys().hasOnly(['spring-2026'])
+          && ('spring-2026' in request.resource.data)
+          && !('spring-2026' in resource.data)
+          && exists(/databases/$(database)/documents/curriculum/lessons_spring-2026)
+          && !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
+          && !springMoveVerified();
+      }
+
+      // Manager+: full access to everything including appData (reads; ordinary-doc writes)
+      allow read: if isManagerOrAbove();
+      allow create, update, delete: if isManagerOrAbove() && !isStorageMoveDoc();
 
       // classbook-admin, curriculum-admin (legacy key), and classbook: full read/write except appData and prepCycleConfig
       // appData (Settings) is manager+ only, always
@@ -662,24 +708,68 @@ service cloud.firestore {
       // by these rules. This is a known, accepted gap (see
       // firebase-agent-defense-hardening.md) pending a possible future
       // data-model change, not something this rule can close on its own.
-      allow read: if hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook');
+      allow read: if isClassbookRole();
       allow create, update: if
-        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook'))
+        isClassbookRole()
         && docId != 'appData'
-        && docId != 'prepCycleConfig';
+        && docId != 'prepCycleConfig'
+        && !isStorageMoveDoc();
       // Whole-document delete is classbook-admin/curriculum-admin only.
       // Plain 'classbook' (teacher) access never calls a full-document
       // delete in the app (only FieldValue.delete() on specific lesson
       // fields, which is an update, not a delete) — so this closes an
       // unused, high-blast-radius capability with no functional change.
       allow delete: if
-        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin'))
+        isClassbookAdminRole()
         && docId != 'appData'
-        && docId != 'prepCycleConfig';
+        && docId != 'prepCycleConfig'
+        && !isStorageMoveDoc();
       // prepCycleConfig: classbook-admin and curriculum-admin write only
       allow create, update, delete: if
-        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin'))
+        isClassbookAdminRole()
         && docId == 'prepCycleConfig';
+
+      // lessonData: as before for every semester except 'spring-2026'; no whole-document delete.
+      allow create: if docId == 'lessonData'
+        && (isManagerOrAbove() || isClassbookRole())
+        && !('spring-2026' in request.resource.data);
+      allow update: if docId == 'lessonData'
+        && (isManagerOrAbove() || isClassbookRole())
+        && springKeyUntouched();
+      allow update: if docId == 'lessonData'
+        && isManagerOrAbove()
+        && (springKeyRemovedOnly() || springKeyRolledBack());
+
+      // lessons_spring-2026: Spring 2026's lessons after the move.
+      allow create: if docId == 'lessons_spring-2026' && isManagerOrAbove();
+      allow update: if docId == 'lessons_spring-2026'
+        && (isManagerOrAbove() || isClassbookRole())
+        && springMoveVerified();
+      allow delete: if docId == 'lessons_spring-2026'
+        && isManagerOrAbove()
+        && !springMoveVerified();
+
+      // storageMigrations: the move's record (manager+ writes; read via the read lines above).
+      // 'verified' is one-way: once true it can never be turned off, removed or replaced (that
+      // would reopen delete/rollback). It may become true only when, AFTER the write (existsAfter/getAfter, so it
+      // can't be combined with a delete or rollback in one batch), lessons_spring-2026 exists and
+      // lessonData no longer holds 'spring-2026'. No role deletes the record.
+      function springVerifiedIn(data) {
+        return data.get('spring-2026', {}).get('verified', false) == true;
+      }
+      function springVerifyTransitionOk() {
+        return !springVerifiedIn(request.resource.data)
+          || (existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
+              && !('spring-2026' in getAfter(/databases/$(database)/documents/curriculum/lessonData).data));
+      }
+      allow create: if docId == 'storageMigrations'
+        && isManagerOrAbove()
+        && springVerifyTransitionOk();
+      allow update: if docId == 'storageMigrations'
+        && isManagerOrAbove()
+        && (springVerifiedIn(resource.data)
+              ? springVerifiedIn(request.resource.data)
+              : springVerifyTransitionOk());
     }
 
     // ═══════════════════════════════════════════════════════════════
diff --git a/rules.test.js b/rules.test.js
index 11bb541..484490c 100644
--- a/rules.test.js
+++ b/rules.test.js
@@ -21,7 +21,7 @@
  */
 
 const { initializeTestEnvironment, assertFails, assertSucceeds } = require('@firebase/rules-unit-testing');
-const { doc, getDoc, setDoc, updateDoc, deleteDoc, deleteField, increment, collection, addDoc, query, where, getDocs, runTransaction, serverTimestamp, orderBy, limit, documentId } = require('firebase/firestore');
+const { doc, getDoc, setDoc, updateDoc, deleteDoc, deleteField, increment, collection, addDoc, query, where, getDocs, runTransaction, serverTimestamp, orderBy, limit, documentId, writeBatch } = require('firebase/firestore');
 const fs = require('fs');
 
 const PROJECT_ID = 'tinker-hq-test';
@@ -2585,3 +2585,326 @@ describe('Clay Hub Membership — the database protects memberId and freezes ret
     await assertFails(setDoc(doc(db, 'clayHub_appData', 'b0-app-x'), { a: 1 }));
   });
 });
+
+
+// ─── CLASSBOOK — SPRING 2026 STORAGE MOVE (lessonData fence) ────────────────
+// Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html, Phase A.
+// curriculum/lessonData (every Fall/Spring semester in ONE document) was at 95% of Firestore's
+// 1 MiB cap on Sep 29 2026. Spring 2026 moves to curriculum/lessons_spring-2026 in one
+// manager transaction. These rules: nobody changes lessonData's spring-2026 key except the
+// move (delete only) and its rollback (re-add only, while unverified, target deleted in the
+// same transaction); nobody deletes the whole lessonData doc; the new doc is created by a
+// manager, edited only once storageMigrations says the move is verified, and deleted only by a
+// manager during a rollback. Every other /curriculum doc behaves exactly as before.
+
+const SPRING = 'spring-2026';
+const SPRING_DOC = 'lessons_spring-2026';
+const MIGRATIONS = 'storageMigrations';
+const FENCE_ROLES = [
+  ['teacher (classbook)', CLASSBOOK_UID],
+  ['classbook-admin', CLASSBOOK_ADMIN_UID],
+  ['curriculum-admin (legacy key)', CURRICULUM_ADMIN_ONLY_UID],
+  ['manager', MANAGER_UID],
+  ['admin', ADMIN_UID],
+];
+const NON_MANAGER_ROLES = FENCE_ROLES.slice(0, 3);
+const MANAGER_ROLES = FENCE_ROLES.slice(3);
+const springMap = () => ({ 'mariah-tuesday-1': { teacher: 'Mariah', shortDetails: 'Clay' }, 'kathy-monday-2': { teacher: 'Kathy', processStep1: 'Paint' } });
+
+async function resetStorageMoveFixtures({ spring = true, target = null, migrations = null } = {}) {
+  await testEnv.withSecurityRulesDisabled(async (ctx) => {
+    const db = ctx.firestore();
+    const lessonData = { 'fall-2026': { 'allie-wednesday-1': { teacher: 'Allie', shortDetails: 'Print' } }, lastUpdated: 'x' };
+    if (spring) lessonData[SPRING] = springMap();
+    await setDoc(doc(db, 'curriculum', 'lessonData'), lessonData);
+    if (target) await setDoc(doc(db, 'curriculum', SPRING_DOC), target); else await deleteDoc(doc(db, 'curriculum', SPRING_DOC));
+    if (migrations) await setDoc(doc(db, 'curriculum', MIGRATIONS), migrations); else await deleteDoc(doc(db, 'curriculum', MIGRATIONS));
+  });
+}
+
+// The Phase C move, as the console procedure will run it (one transaction).
+async function runMove(db) {
+  return runTransaction(db, async (tx) => {
+    const ld = await tx.get(doc(db, 'curriculum', 'lessonData'));
+    const target = await tx.get(doc(db, 'curriculum', SPRING_DOC));
+    await tx.get(doc(db, 'curriculum', MIGRATIONS));
+    if (target.exists()) throw new Error('target exists');
+    const map = ld.data()[SPRING];
+    tx.set(doc(db, 'curriculum', SPRING_DOC), { ...map, lastUpdated: 'now', lastUpdatedBy: 'test' });
+    tx.update(doc(db, 'curriculum', 'lessonData'), { [SPRING]: deleteField() });
+    tx.set(doc(db, 'curriculum', MIGRATIONS), { [SPRING]: { lessonCount: Object.keys(map).length, sha256: 'h', verified: false } }, { merge: true });
+  });
+}
+// The rollback: re-add the key and delete the target in the same transaction.
+async function runRollback(db, { deleteTarget = true } = {}) {
+  return runTransaction(db, async (tx) => {
+    await tx.get(doc(db, 'curriculum', 'lessonData'));
+    await tx.get(doc(db, 'curriculum', SPRING_DOC));
+    tx.update(doc(db, 'curriculum', 'lessonData'), { [SPRING]: springMap() });
+    if (deleteTarget) tx.delete(doc(db, 'curriculum', SPRING_DOC));
+  });
+}
+
+describe('Classbook storage move — lessonData spring-2026 fence', () => {
+  beforeEach(() => resetStorageMoveFixtures());
+
+  test.each(FENCE_ROLES)('%s can still update another semester in lessonData', async (_l, uid) => {
+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026.allie-wednesday-1.shortDetails': 'Updated' }));
+  });
+  test.each(FENCE_ROLES)('%s CANNOT change a spring-2026 lesson in lessonData', async (_l, uid) => {
+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.mariah-tuesday-1.shortDetails': 'Changed' }));
+  });
+  test.each(FENCE_ROLES)('%s CANNOT add a new spring-2026 lesson in lessonData', async (_l, uid) => {
+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.new-lesson': { teacher: 'X' } }));
+  });
+  test.each(MANAGER_ROLES)('%s can delete ONLY the spring-2026 key', async (_l, uid) => {
+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField() }));
+  });
+  test.each(NON_MANAGER_ROLES)('%s CANNOT delete the spring-2026 key', async (_l, uid) => {
+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField() }));
+  });
+  test.each(MANAGER_ROLES)('%s CANNOT delete spring-2026 together with another change', async (_l, uid) => {
+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField(), 'fall-2026.allie-wednesday-1.shortDetails': 'x' }));
+  });
+  test.each(FENCE_ROLES)('%s CANNOT delete the whole lessonData document', async (_l, uid) => {
+    await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', 'lessonData')));
+  });
+  test.each(FENCE_ROLES)('%s CANNOT replace lessonData with a set() that changes spring-2026', async (_l, uid) => {
+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': {}, [SPRING]: { stale: true } }));
+  });
+  test.each(FENCE_ROLES)('%s can still merge-set another semester into lessonData (saveLessonData shape)', async (_l, uid) => {
+    await assertSucceeds(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': { 'new-slot': { teacher: 'Allie' } } }, { merge: true }));
+  });
+});
+
+describe('Classbook storage move — lessonData cannot be recreated with spring-2026', () => {
+  beforeEach(async () => {
+    await resetStorageMoveFixtures();
+    await testEnv.withSecurityRulesDisabled(async (ctx) => { await deleteDoc(doc(ctx.firestore(), 'curriculum', 'lessonData')); });
+  });
+  test.each(FENCE_ROLES)('%s CANNOT create lessonData containing spring-2026', async (_l, uid) => {
+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
+  });
+  test.each(FENCE_ROLES)('%s can create lessonData without spring-2026 (as today)', async (_l, uid) => {
+    await assertSucceeds(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': {} }));
+  });
+});
+
+describe('Classbook storage move — the move transaction', () => {
+  beforeEach(() => resetStorageMoveFixtures());
+  test.each(MANAGER_ROLES)('%s can run the one-step move', async (_l, uid) => {
+    await assertSucceeds(runMove(getDb(uid)));
+  });
+  test.each(NON_MANAGER_ROLES)('%s CANNOT run the move', async (_l, uid) => {
+    await assertFails(runMove(getDb(uid)));
+  });
+  test.each(NON_MANAGER_ROLES)('%s CANNOT create lessons_spring-2026', async (_l, uid) => {
+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', SPRING_DOC), springMap()));
+  });
+  test.each(NON_MANAGER_ROLES)('%s CANNOT write storageMigrations', async (_l, uid) => {
+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: { verified: true } }, { merge: true }));
+  });
+  test.each(FENCE_ROLES)('%s can read storageMigrations once it exists', async (_l, uid) => {
+    await testEnv.withSecurityRulesDisabled(async (ctx) => { await setDoc(doc(ctx.firestore(), 'curriculum', MIGRATIONS), { [SPRING]: { verified: false } }); });
+    await assertSucceeds(getDoc(doc(getDb(uid), 'curriculum', MIGRATIONS)));
+  });
+});
+
+describe('Classbook storage move — moved, NOT yet verified (edits paused; rollback allowed)', () => {
+  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: false } } }));
+
+  test.each(FENCE_ROLES)('%s CANNOT edit lessons_spring-2026 before verification', async (_l, uid) => {
+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', SPRING_DOC), { 'mariah-tuesday-1.shortDetails': 'Changed' }));
+  });
+  test.each(FENCE_ROLES)('%s can read lessons_spring-2026', async (_l, uid) => {
+    await assertSucceeds(getDoc(doc(getDb(uid), 'curriculum', SPRING_DOC)));
+  });
+  test.each(MANAGER_ROLES)('%s can run the rollback (re-add + delete target, one transaction)', async (_l, uid) => {
+    await assertSucceeds(runRollback(getDb(uid)));
+  });
+  test.each(NON_MANAGER_ROLES)('%s CANNOT run the rollback', async (_l, uid) => {
+    await assertFails(runRollback(getDb(uid)));
+  });
+  test.each(MANAGER_ROLES)('%s CANNOT re-add spring-2026 without deleting the target', async (_l, uid) => {
+    await assertFails(runRollback(getDb(uid), { deleteTarget: false }));
+  });
+  test.each(FENCE_ROLES)('%s CANNOT plainly re-add spring-2026 to lessonData', async (_l, uid) => {
+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
+  });
+  test.each(MANAGER_ROLES)('%s can delete lessons_spring-2026 before verification', async (_l, uid) => {
+    await assertSucceeds(deleteDoc(doc(getDb(uid), 'curriculum', SPRING_DOC)));
+  });
+  test.each(NON_MANAGER_ROLES)('%s CANNOT delete lessons_spring-2026', async (_l, uid) => {
+    await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', SPRING_DOC)));
+  });
+  test.each(MANAGER_ROLES)('%s can mark the move verified', async (_l, uid) => {
+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
+  });
+  test.each(MANAGER_ROLES)('%s CANNOT create lessons_spring-2026 again while it exists (set over it is an update, refused while unverified)', async (_l, uid) => {
+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', SPRING_DOC), { replaced: true }));
+  });
+});
+
+describe('Classbook storage move — moved AND verified (edits back on; no delete, no rollback)', () => {
+  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: true } } }));
+
+  test.each(FENCE_ROLES)('%s can edit a Spring lesson in lessons_spring-2026', async (_l, uid) => {
+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', SPRING_DOC), { 'mariah-tuesday-1.shortDetails': 'Changed' }));
+  });
+  test.each(FENCE_ROLES)('%s CANNOT delete lessons_spring-2026 after verification', async (_l, uid) => {

exec
/bin/zsh -lc 'tail -n 80 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA-r2-codex.md; rg -n "''^diff --git|''^@@|''^[+-].*(getAfter|existsAfter|springVerify|lessonData|storageMigrations|verified|runMove|standalone|verify)" /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA-r3.diff; nl -ba firestore.rules | sed -n '"'640,790p'; nl -ba rules.test.js | sed -n '2580,2870p'" in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
 succeeded in 0ms:
118:  <li><strong>Writes to Spring:</strong> they go to <code>lessons_K</code> only when <code>storageMigrations.spring-2026.verified</code> is true, read by a small <code>storageMigrations</code> listener. Otherwise the app shows the "editing is paused" message; the rules refuse those writes anyway. <code>not-found</code> is handled the same way.</li>
123:  <li><strong>Ratchet:</strong> no <code>doc('lessonData')</code> in the loaded scripts outside the helpers, the legacy load/listener and the dead backup helpers. <code>e2e/</code> is exempt. The seed gains a <code>lessons_spring-2026</code> + <code>storageMigrations</code> fixture set for the own-doc scenarios, and the default seed is unchanged.</li>
129:Scenario: Spring moved and verified works end to end (emulator)
133:Scenario: moved but not yet verified — edits paused
134:  Given lessons_spring-2026 exists, verified false
152:  <li><strong>Stale-tab cutoff</strong> (Codex 4): the day before, Christie asks staff to close and reopen the Classbook. A tab still running pre-Phase-B code can't lose anything, because the Phase A rules refuse its Spring writes. It could show Spring as empty until it's reloaded, and that's the accepted residual.</li>
158:  <li><strong>One transaction:</strong> read <code>lessonData</code>, <code>lessons_spring-2026</code> (which must not exist) and <code>storageMigrations</code>. Then:
162:      <li><code>tx.set(storageMigrations, { 'spring-2026': { movedAt, movedBy, lessonCount, sha256, verified: false } }, { merge: true })</code></li>
166:  <li><strong>If verification passes:</strong> <code>storageMigrations.spring-2026.verified = true</code>, and Spring becomes editable. Spot-check one Spring lesson in the Firebase Console.</li>
167:  <li><strong>If it fails:</strong> nothing has been edited since the copy, so the reverse transaction is safe: it puts <code>map</code> back into <code>lessonData</code>, which Phase A's rollback allowance permits (a manager/admin, only this key, only while unverified, and only together with deleting <code>lessons_spring-2026</code>), deletes <code>lessons_spring-2026</code>, and records the failure. The download from step 1 remains the last resort.</li>
170:  Then lessons_spring-2026 deep-equals the old map (+ lastUpdated*), lessonData has no spring-2026, storageMigrations records count + hash, verified → true, Spring editable, Fall untouched
189:  <li><strong>Rules:</strong> Phase A is a shared-rules change: tests for all five roles, a near-1 MB fixture, the whole suite green, then <code>deploy-rules.sh --approved &lt;sha&gt;</code> after the phrase. The new docs (<code>lessons_spring-2026</code>, <code>storageMigrations</code>) get explicit conditions in the <code>curriculum/{docId}</code> block.</li>
190:  <li><strong>Backups (checked Sep 29):</strong> <code>backup.js</code> fetches <em>every</em> document in each listed collection (<code>fetchCollection</code>, <code>:221-247</code>), so <code>lessons_spring-2026</code> and <code>storageMigrations</code> are in every 30-minute backup automatically. The Tier-1 count check counts documents, and <code>curriculum</code> gains two, so there's no false alarm there. The per-teacher content count is covered by the five-line edit.</li>
192:  <li><strong>Atomic:</strong> the copy, the old-copy removal and the migration record are one transaction.</li>
194:  <li><strong>Reversible:</strong> a reverse transaction until verified. After that, the download and backups.</li>
203:  <li><strong>Mid-C:</strong> the transaction either committed or didn't. If it committed but isn't verified, Spring is viewable, edits are paused, and the reverse transaction exists.</li>
209:  <li>Phase A in <code>studio-hub</code> (branch, merge to main, then the guard). Phase B in a Classbook worktree off <code>origin/main</code>, plus Studio Hub for the alerts. Re-check the line numbers.</li>
210:  <li>Per phase: commit, run the full suite, then a second-model implementation review. Each deploy, the backup.js edit, and Phase C each need Christie's own yes. Phase A needs the sha phrase.</li>
215:  <strong>Sep 29, 2026: revision 5, EXECUTION-READY.</strong> Codex round 3 (<code>…-codex-r3.md</code>) confirmed fixes 2 and 3, and confirmed the rules design is implementable (<code>existsAfter</code>, all split statements constrained). Its single remaining item: the Phase A update-condition summary was missing the rollback branch, which is now added with Codex's exact form. All phases are marked execution-ready. Build waits for Christie's go-ahead. Deploys, the backup.js edit and Phase C each still need her own yes, and Phase A needs the sha phrase.
218:  <strong>Sep 29, 2026: revision 4, after Codex round 2 (<code>…-codex-r2.md</code>).</strong> Codex confirmed 6 of its 8 round-1 items resolved, including that the forward transaction works under the Phase A rules. Three fixes taken:
220:    <li>The rollback re-add is explicitly allowed for manager/admin, only while unverified and only with <code>lessons_spring-2026</code> deleted in the same transaction (<code>getAfter</code>). This replaces the test that contradicted it.</li>
221:    <li>Deleting the new document is manager/admin-only and only while unverified. Other roles are always denied, and everyone is denied after verification until the follow-up plan.</li>
226:  <strong>Sep 29, 2026: revision 3, after Codex's independent round 1 (<code>…-codex-r1.md</code>): NOT ready, 8-point minimum list, all verified and taken.</strong>
228:    <li>Adopted Codex's "simpler safe option": the copy and the old-copy removal are <strong>one transaction</strong>, with Spring edits paused by rule until the move is verified. That closes the verification/rollback race (1), the target-missing-at-delete risk (2) and double counting (5), since there's no dual-copy window, and Phases C and D merge.</li>
233:    <li>(8) Merged <code>storageMigrations</code> writes, target-disappearance behaviour, and a Firestore-size estimator for the readout with an 85% warning.</li>
239:  <strong>Sep 29, 2026: Christie's answers.</strong> (Q1) Spring 2026 being view-only from Phase A until Phase C is fine. (Q2) Christie will paste the <code>backup.js</code> change herself (option a) before Phase D. The exact lines, for <code>tinker-backups/backup.js</code> inside <code>computeClassbookContentByTeacher</code>, just before <code>return counts;</code>:
249:  <strong>Open questions for Christie:</strong> (Q1) Is it OK that Spring 2026 is read-only ("editing is paused") from Phase A until Phase C, probably a few days? (Q2) Will you make the small <code>backup.js</code> edit before Phase D, or accept one expected content-loss alarm for Spring teachers? (Q3, for the reviewer) Undoing a bad Phase C copy needs a whole-doc delete of <code>lessons_spring-2026</code>; today only classbook-admin/curriculum-admin may whole-doc delete (<code>:675-678</code>). Should Phase A's split give managers delete as well (they have it today through <code>:654</code>'s <code>write</code>)? The plan assumes yes: the split keeps manager delete.

exec
/bin/zsh -lc "rg -n \"\\?.*:\" firestore.rules | head -30; rg -n \"function isManagerOrAbove|function hasAppAccess|function isAdmin|archived\" firestore.rules | head -40; git diff --no-index /dev/null /dev/null >/dev/null 2>&1 || true" in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
 succeeded in 0ms:
28:    function isAdmin() {
36:    function isManagerOrAbove() {
67:    function hasAppAccess(appName) {

web search: 
web search: site:firebase.google.com/docs/rules rules language ternary operator Cloud Firestore security rules conditional operator
web search: 
web search: site:firebase.google.com/docs/firestore/security/rules-conditions getAfter atomic operations get current data getAfter future data
codex
## Verdict: NOT SAFE TO MERGE OR DEPLOY

Prior blockers:

1. **RESOLVED** — rollback now requires the target both to exist before and be absent after the request: [firestore.rules:693](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/firestore.rules:693).
2. **RESOLVED** — `verified:true` is irreversible: [firestore.rules:756](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/firestore.rules:756) and [firestore.rules:767](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/firestore.rules:767).

One remaining blocker:

- Verification validates the **pre-write** state with `exists()`/`get()` at [firestore.rules:761](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/firestore.rules:761). A manager can batch/transaction:

  - set `verified:true`; and
  - delete `lessons_spring-2026`, or perform the rollback.

  Each write sees the old unverified/valid state, leaving an invalid but permanently verified final state. Firestore requires `getAfter()`/`existsAfter()` to validate final atomic state. [Firebase documentation](https://firebase.google.com/docs/firestore/security/rules-conditions)

Minimum fix: use `existsAfter(target)` and `getAfter(lessonData)` in `springVerifyTransitionOk()`, with tests for verify+delete and verify+rollback in one atomic request.

Other checks: the false-valued move record short-circuits before the ~1 MiB `get()`; standalone verification is otherwise valid; access-call limits remain comfortable; the ternary is supported Rules syntax. No additional bypass found.
tokens used
51,013
## Verdict: NOT SAFE TO MERGE OR DEPLOY

Prior blockers:

1. **RESOLVED** — rollback now requires the target both to exist before and be absent after the request: [firestore.rules:693](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/firestore.rules:693).
2. **RESOLVED** — `verified:true` is irreversible: [firestore.rules:756](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/firestore.rules:756) and [firestore.rules:767](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/firestore.rules:767).

One remaining blocker:

- Verification validates the **pre-write** state with `exists()`/`get()` at [firestore.rules:761](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/firestore.rules:761). A manager can batch/transaction:

  - set `verified:true`; and
  - delete `lessons_spring-2026`, or perform the rollback.

  Each write sees the old unverified/valid state, leaving an invalid but permanently verified final state. Firestore requires `getAfter()`/`existsAfter()` to validate final atomic state. [Firebase documentation](https://firebase.google.com/docs/firestore/security/rules-conditions)

Minimum fix: use `existsAfter(target)` and `getAfter(lessonData)` in `springVerifyTransitionOk()`, with tests for verify+delete and verify+rollback in one atomic request.

Other checks: the false-valued move record short-circuits before the ~1 MiB `get()`; standalone verification is otherwise valid; access-call limits remain comfortable; the ternary is supported Rules syntax. No additional bypass found.
1:diff --git a/firestore.rules b/firestore.rules
5:@@ -650,8 +650,54 @@ service cloud.firestore {
13:+      // curriculum/lessonData holds every Fall/Spring semester in ONE document and was at 95% of
17:+      //   lessonData          — nobody changes its 'spring-2026' key, except manager+ deleting ONLY
19:+      //                         unverified AND the new doc is deleted in the same transaction
21:+      //   lessons_spring-2026 — created by manager+; edited only once storageMigrations says the move
22:+      //                         is verified; deleted only by manager+ and only while unverified.
23:+      //   storageMigrations   — manager+ writes; classbook roles read.
31:+        return docId in ['lessonData', 'lessons_spring-2026', 'storageMigrations'];
34:+        let path = /databases/$(database)/documents/curriculum/storageMigrations;
35:+        return exists(path) && get(path).data.get('spring-2026', {}).get('verified', false) == true;
37:+      function lessonDataChangedKeys() {
41:+        return !lessonDataChangedKeys().hasAny(['spring-2026']);
44:+        return lessonDataChangedKeys().hasOnly(['spring-2026'])
48:+        return lessonDataChangedKeys().hasOnly(['spring-2026'])
52:+          && !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
62:@@ -662,24 +708,68 @@ service cloud.firestore {
93:+      // lessonData: as before for every semester except 'spring-2026'; no whole-document delete.
94:+      allow create: if docId == 'lessonData'
97:+      allow update: if docId == 'lessonData'
100:+      allow update: if docId == 'lessonData'
113:+      // storageMigrations: the move's record (manager+ writes; read via the read lines above).
114:+      // 'verified' is one-way: once true it can never be turned off, removed or replaced (that
115:+      // would reopen delete/rollback). It may become true only when, AFTER the write (existsAfter/getAfter, so it
117:+      // lessonData no longer holds 'spring-2026'. No role deletes the record.
119:+        return data.get('spring-2026', {}).get('verified', false) == true;
121:+      function springVerifyTransitionOk() {
123:+          || (existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
124:+              && !('spring-2026' in getAfter(/databases/$(database)/documents/curriculum/lessonData).data));
126:+      allow create: if docId == 'storageMigrations'
128:+        && springVerifyTransitionOk();
129:+      allow update: if docId == 'storageMigrations'
133:+              : springVerifyTransitionOk());
137:diff --git a/rules.test.js b/rules.test.js
141:@@ -21,7 +21,7 @@
150:@@ -2585,3 +2585,326 @@ describe('Clay Hub Membership — the database protects memberId and freezes ret
156:+// ─── CLASSBOOK — SPRING 2026 STORAGE MOVE (lessonData fence) ────────────────
158:+// curriculum/lessonData (every Fall/Spring semester in ONE document) was at 95% of Firestore's
160:+// manager transaction. These rules: nobody changes lessonData's spring-2026 key except the
161:+// move (delete only) and its rollback (re-add only, while unverified, target deleted in the
162:+// same transaction); nobody deletes the whole lessonData doc; the new doc is created by a
163:+// manager, edited only once storageMigrations says the move is verified, and deleted only by a
168:+const MIGRATIONS = 'storageMigrations';
183:+    const lessonData = { 'fall-2026': { 'allie-wednesday-1': { teacher: 'Allie', shortDetails: 'Print' } }, lastUpdated: 'x' };
184:+    if (spring) lessonData[SPRING] = springMap();
185:+    await setDoc(doc(db, 'curriculum', 'lessonData'), lessonData);
192:+async function runMove(db) {
194:+    const ld = await tx.get(doc(db, 'curriculum', 'lessonData'));
200:+    tx.update(doc(db, 'curriculum', 'lessonData'), { [SPRING]: deleteField() });
201:+    tx.set(doc(db, 'curriculum', MIGRATIONS), { [SPRING]: { lessonCount: Object.keys(map).length, sha256: 'h', verified: false } }, { merge: true });
207:+    await tx.get(doc(db, 'curriculum', 'lessonData'));
209:+    tx.update(doc(db, 'curriculum', 'lessonData'), { [SPRING]: springMap() });
214:+describe('Classbook storage move — lessonData spring-2026 fence', () => {
217:+  test.each(FENCE_ROLES)('%s can still update another semester in lessonData', async (_l, uid) => {
218:+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026.allie-wednesday-1.shortDetails': 'Updated' }));
220:+  test.each(FENCE_ROLES)('%s CANNOT change a spring-2026 lesson in lessonData', async (_l, uid) => {
221:+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.mariah-tuesday-1.shortDetails': 'Changed' }));
223:+  test.each(FENCE_ROLES)('%s CANNOT add a new spring-2026 lesson in lessonData', async (_l, uid) => {
224:+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.new-lesson': { teacher: 'X' } }));
227:+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField() }));
230:+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField() }));
233:+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField(), 'fall-2026.allie-wednesday-1.shortDetails': 'x' }));
235:+  test.each(FENCE_ROLES)('%s CANNOT delete the whole lessonData document', async (_l, uid) => {
236:+    await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', 'lessonData')));
238:+  test.each(FENCE_ROLES)('%s CANNOT replace lessonData with a set() that changes spring-2026', async (_l, uid) => {
239:+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': {}, [SPRING]: { stale: true } }));
241:+  test.each(FENCE_ROLES)('%s can still merge-set another semester into lessonData (saveLessonData shape)', async (_l, uid) => {
242:+    await assertSucceeds(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': { 'new-slot': { teacher: 'Allie' } } }, { merge: true }));
246:+describe('Classbook storage move — lessonData cannot be recreated with spring-2026', () => {
249:+    await testEnv.withSecurityRulesDisabled(async (ctx) => { await deleteDoc(doc(ctx.firestore(), 'curriculum', 'lessonData')); });
251:+  test.each(FENCE_ROLES)('%s CANNOT create lessonData containing spring-2026', async (_l, uid) => {
252:+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
254:+  test.each(FENCE_ROLES)('%s can create lessonData without spring-2026 (as today)', async (_l, uid) => {
255:+    await assertSucceeds(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': {} }));
262:+    await assertSucceeds(runMove(getDb(uid)));
265:+    await assertFails(runMove(getDb(uid)));
270:+  test.each(NON_MANAGER_ROLES)('%s CANNOT write storageMigrations', async (_l, uid) => {
271:+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: { verified: true } }, { merge: true }));
273:+  test.each(FENCE_ROLES)('%s can read storageMigrations once it exists', async (_l, uid) => {
274:+    await testEnv.withSecurityRulesDisabled(async (ctx) => { await setDoc(doc(ctx.firestore(), 'curriculum', MIGRATIONS), { [SPRING]: { verified: false } }); });
279:+describe('Classbook storage move — moved, NOT yet verified (edits paused; rollback allowed)', () => {
280:+  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: false } } }));
297:+  test.each(FENCE_ROLES)('%s CANNOT plainly re-add spring-2026 to lessonData', async (_l, uid) => {
298:+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
306:+  test.each(MANAGER_ROLES)('%s can mark the move verified', async (_l, uid) => {
307:+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
309:+  test.each(MANAGER_ROLES)('%s CANNOT create lessons_spring-2026 again while it exists (set over it is an update, refused while unverified)', async (_l, uid) => {
314:+describe('Classbook storage move — moved AND verified (edits back on; no delete, no rollback)', () => {
315:+  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: true } } }));
326:+  test.each(FENCE_ROLES)('%s CANNOT re-create spring-2026 in lessonData', async (_l, uid) => {
327:+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.stale': { teacher: 'X' } }));
329:+  test.each(FENCE_ROLES)('%s still updates Fall in lessonData normally', async (_l, uid) => {
330:+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026.allie-wednesday-1.shortDetails': 'Updated' }));
359:+    await assertFails(updateDoc(doc(getDb(STAFF_NOACCESS_UID), 'curriculum', 'lessonData'), { 'fall-2026.x': {} }));
363:+// A near-1 MiB lessonData (how production looked on Sep 29 2026): prove the fence evaluates on a
365:+describe('Classbook storage move — fence on a near-1 MiB lessonData', () => {
385:+      await setDoc(doc(ctx.firestore(), 'curriculum', 'lessonData'), big);
396:+    await assertSucceeds(updateDoc(doc(getDb(CLASSBOOK_UID), 'curriculum', 'lessonData'), { 'fall-2026.teacher-class-1.shortDetails': 'Updated' }));
397:+    await assertFails(updateDoc(doc(getDb(CLASSBOOK_UID), 'curriculum', 'lessonData'), { 'spring-2026.teacher-class-1.shortDetails': 'Changed' }));
400:+    await assertSucceeds(runMove(getDb(MANAGER_UID)));
405:+// transaction (not merely find it absent), and "verified" can never be switched back off.
406:+describe('Classbook storage move — review fixes (rollback needs the target; verified is one-way)', () => {
408:+    await resetStorageMoveFixtures({ spring: false, target: null, migrations: { [SPRING]: { verified: false } } });
409:+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
411:+  test.each(MANAGER_ROLES)('%s CANNOT merge-set a changed spring-2026 into lessonData', async (_l, uid) => {
413:+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: { 'mariah-tuesday-1': { shortDetails: 'x' } } }, { merge: true }));
417:+    beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: true, sha256: 'h' } } }));
418:+    test.each(MANAGER_ROLES)('%s CANNOT set verified back to false', async (_l, uid) => {
419:+      await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: false }));
421:+    test.each(MANAGER_ROLES)('%s CANNOT delete the verified field', async (_l, uid) => {
422:+      await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: deleteField() }));
433:+    test.each(MANAGER_ROLES)('%s can still add other fields to the record (verified stays true)', async (_l, uid) => {
438:+  test.each(MANAGER_ROLES)('%s CANNOT mark verified while lessons_spring-2026 does not exist', async (_l, uid) => {
439:+    await resetStorageMoveFixtures({ spring: false, target: null, migrations: { [SPRING]: { verified: false } } });
440:+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
442:+  test.each(MANAGER_ROLES)('%s CANNOT mark verified while spring-2026 is still in lessonData', async (_l, uid) => {
443:+    await resetStorageMoveFixtures({ spring: true, target: { ...springMap() }, migrations: { [SPRING]: { verified: false } } });
444:+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
446:+  test.each(MANAGER_ROLES)('%s CANNOT create the record already verified before the move', async (_l, uid) => {
448:+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: { verified: true } }));
452:+// Implementation review round 2 (Codex): "verified" must describe the state AFTER the write,
454:+describe('Classbook storage move — verify can\'t be combined with delete or rollback', () => {
455:+  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: false } } }));
456:+  test.each(MANAGER_ROLES)('%s CANNOT verify and delete lessons_spring-2026 in one batch', async (_l, uid) => {
459:+    b.update(doc(db, 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true });
463:+  test.each(MANAGER_ROLES)('%s CANNOT verify and roll back in one transaction', async (_l, uid) => {
466:+      await tx.get(doc(db, 'curriculum', 'lessonData'));
468:+      tx.update(doc(db, 'curriculum', 'lessonData'), { [SPRING]: springMap() });
470:+      tx.update(doc(db, 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true });
473:+  test.each(MANAGER_ROLES)('%s can still verify on its own when the move is complete', async (_l, uid) => {
474:+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
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
   653	      // ── Spring 2026 storage move (Sep 29 2026) ──────────────────────────
   654	      // Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase A).
   655	      // curriculum/lessonData holds every Fall/Spring semester in ONE document and was at 95% of
   656	      // Firestore's 1 MiB cap. Spring 2026 moves to curriculum/lessons_spring-2026 in one manager
   657	      // transaction. Three docs therefore get their own rules below; every other curriculum doc
   658	      // keeps exactly the rules it had (the "ordinary docs" lines).
   659	      //   lessonData          — nobody changes its 'spring-2026' key, except manager+ deleting ONLY
   660	      //                         that key (the move) or re-adding ONLY that key while the move is
   661	      //                         unverified AND the new doc is deleted in the same transaction
   662	      //                         (the rollback). Nobody deletes the whole document.
   663	      //   lessons_spring-2026 — created by manager+; edited only once storageMigrations says the move
   664	      //                         is verified; deleted only by manager+ and only while unverified.
   665	      //   storageMigrations   — manager+ writes; classbook roles read.
   666	      function isClassbookRole() {
   667	        return hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook');
   668	      }
   669	      function isClassbookAdminRole() {
   670	        return hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin');
   671	      }
   672	      function isStorageMoveDoc() {
   673	        return docId in ['lessonData', 'lessons_spring-2026', 'storageMigrations'];
   674	      }
   675	      function springMoveVerified() {
   676	        let path = /databases/$(database)/documents/curriculum/storageMigrations;
   677	        return exists(path) && get(path).data.get('spring-2026', {}).get('verified', false) == true;
   678	      }
   679	      function lessonDataChangedKeys() {
   680	        return request.resource.data.diff(resource.data).affectedKeys();
   681	      }
   682	      function springKeyUntouched() {
   683	        return !lessonDataChangedKeys().hasAny(['spring-2026']);
   684	      }
   685	      function springKeyRemovedOnly() {
   686	        return lessonDataChangedKeys().hasOnly(['spring-2026'])
   687	          && !('spring-2026' in request.resource.data);
   688	      }
   689	      function springKeyRolledBack() {
   690	        return lessonDataChangedKeys().hasOnly(['spring-2026'])
   691	          && ('spring-2026' in request.resource.data)
   692	          && !('spring-2026' in resource.data)
   693	          && exists(/databases/$(database)/documents/curriculum/lessons_spring-2026)
   694	          && !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
   695	          && !springMoveVerified();
   696	      }
   697	
   698	      // Manager+: full access to everything including appData (reads; ordinary-doc writes)
   699	      allow read: if isManagerOrAbove();
   700	      allow create, update, delete: if isManagerOrAbove() && !isStorageMoveDoc();
   701	
   702	      // classbook-admin, curriculum-admin (legacy key), and classbook: full read/write except appData and prepCycleConfig
   703	      // appData (Settings) is manager+ only, always
   704	      // prepCycleConfig (Prep Cycle workflow config) is classbook-admin only
   705	      // NOTE: 'classbook' (plain teacher) access is intentionally NOT
   706	      // isolated per-teacher here — each semester's lessons live in one
   707	      // shared doc, and per-field isolation is enforced by the UI, not
   708	      // by these rules. This is a known, accepted gap (see
   709	      // firebase-agent-defense-hardening.md) pending a possible future
   710	      // data-model change, not something this rule can close on its own.
   711	      allow read: if isClassbookRole();
   712	      allow create, update: if
   713	        isClassbookRole()
   714	        && docId != 'appData'
   715	        && docId != 'prepCycleConfig'
   716	        && !isStorageMoveDoc();
   717	      // Whole-document delete is classbook-admin/curriculum-admin only.
   718	      // Plain 'classbook' (teacher) access never calls a full-document
   719	      // delete in the app (only FieldValue.delete() on specific lesson
   720	      // fields, which is an update, not a delete) — so this closes an
   721	      // unused, high-blast-radius capability with no functional change.
   722	      allow delete: if
   723	        isClassbookAdminRole()
   724	        && docId != 'appData'
   725	        && docId != 'prepCycleConfig'
   726	        && !isStorageMoveDoc();
   727	      // prepCycleConfig: classbook-admin and curriculum-admin write only
   728	      allow create, update, delete: if
   729	        isClassbookAdminRole()
   730	        && docId == 'prepCycleConfig';
   731	
   732	      // lessonData: as before for every semester except 'spring-2026'; no whole-document delete.
   733	      allow create: if docId == 'lessonData'
   734	        && (isManagerOrAbove() || isClassbookRole())
   735	        && !('spring-2026' in request.resource.data);
   736	      allow update: if docId == 'lessonData'
   737	        && (isManagerOrAbove() || isClassbookRole())
   738	        && springKeyUntouched();
   739	      allow update: if docId == 'lessonData'
   740	        && isManagerOrAbove()
   741	        && (springKeyRemovedOnly() || springKeyRolledBack());
   742	
   743	      // lessons_spring-2026: Spring 2026's lessons after the move.
   744	      allow create: if docId == 'lessons_spring-2026' && isManagerOrAbove();
   745	      allow update: if docId == 'lessons_spring-2026'
   746	        && (isManagerOrAbove() || isClassbookRole())
   747	        && springMoveVerified();
   748	      allow delete: if docId == 'lessons_spring-2026'
   749	        && isManagerOrAbove()
   750	        && !springMoveVerified();
   751	
   752	      // storageMigrations: the move's record (manager+ writes; read via the read lines above).
   753	      // 'verified' is one-way: once true it can never be turned off, removed or replaced (that
   754	      // would reopen delete/rollback). It may become true only when, AFTER the write (existsAfter/getAfter, so it
   755	      // can't be combined with a delete or rollback in one batch), lessons_spring-2026 exists and
   756	      // lessonData no longer holds 'spring-2026'. No role deletes the record.
   757	      function springVerifiedIn(data) {
   758	        return data.get('spring-2026', {}).get('verified', false) == true;
   759	      }
   760	      function springVerifyTransitionOk() {
   761	        return !springVerifiedIn(request.resource.data)
   762	          || (existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
   763	              && !('spring-2026' in getAfter(/databases/$(database)/documents/curriculum/lessonData).data));
   764	      }
   765	      allow create: if docId == 'storageMigrations'
   766	        && isManagerOrAbove()
   767	        && springVerifyTransitionOk();
   768	      allow update: if docId == 'storageMigrations'
   769	        && isManagerOrAbove()
   770	        && (springVerifiedIn(resource.data)
   771	              ? springVerifiedIn(request.resource.data)
   772	              : springVerifyTransitionOk());
   773	    }
   774	
   775	    // ═══════════════════════════════════════════════════════════════
   776	    // CLASSBOOK — SCHOOL DAY OFF CAMPS (SDOCs)
   777	    // Plan: tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html (Phase 1, §1.1)
   778	    //   dayOffCamps_events / dayOffCamps_camps: the admin's planning list for a school year.
   779	    //     classbook-admin (+ manager+) write, plain classbook teachers read.
   780	    //   dayOffCamps_lessonData: one shared plan per camp-project. Teachers create/update like
   781	    //     summerCamps_lessonData (per-teacher isolation is UI-enforced — the same accepted gap as
   782	    //     summer); whole-document delete is admin-only, like /curriculum's delete clause.
   783	    //   The legacy 'curriculum-admin' key is deliberately NOT extended to these new collections.
   784	    //   Visibility of an unpublished year is UI gating only: every classbook teacher can read these.
   785	    // ═══════════════════════════════════════════════════════════════
   786	
   787	    match /dayOffCamps_events/{docId} {
   788	      allow read: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
   789	      allow create, update, delete: if isManagerOrAbove() || hasAppAccess('classbook-admin');
   790	    }
  2580	    const db = getDb(STAFF_NOACCESS_UID);
  2581	    await assertFails(updateDoc(doc(db, 'clayHub_members', NO_ID), { notes: 'nope' }));
  2582	    await assertFails(getDoc(doc(db, 'clayHub_members', NO_ID)));
  2583	    await assertFails(setDoc(doc(db, 'clayHub_waitlist', 'b0-wl-x@example_com'), { email: 'x@example.com' }));
  2584	    await assertFails(getDoc(doc(db, 'clayHub_appData', 'b0-app')));
  2585	    await assertFails(setDoc(doc(db, 'clayHub_appData', 'b0-app-x'), { a: 1 }));
  2586	  });
  2587	});
  2588	
  2589	
  2590	// ─── CLASSBOOK — SPRING 2026 STORAGE MOVE (lessonData fence) ────────────────
  2591	// Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html, Phase A.
  2592	// curriculum/lessonData (every Fall/Spring semester in ONE document) was at 95% of Firestore's
  2593	// 1 MiB cap on Sep 29 2026. Spring 2026 moves to curriculum/lessons_spring-2026 in one
  2594	// manager transaction. These rules: nobody changes lessonData's spring-2026 key except the
  2595	// move (delete only) and its rollback (re-add only, while unverified, target deleted in the
  2596	// same transaction); nobody deletes the whole lessonData doc; the new doc is created by a
  2597	// manager, edited only once storageMigrations says the move is verified, and deleted only by a
  2598	// manager during a rollback. Every other /curriculum doc behaves exactly as before.
  2599	
  2600	const SPRING = 'spring-2026';
  2601	const SPRING_DOC = 'lessons_spring-2026';
  2602	const MIGRATIONS = 'storageMigrations';
  2603	const FENCE_ROLES = [
  2604	  ['teacher (classbook)', CLASSBOOK_UID],
  2605	  ['classbook-admin', CLASSBOOK_ADMIN_UID],
  2606	  ['curriculum-admin (legacy key)', CURRICULUM_ADMIN_ONLY_UID],
  2607	  ['manager', MANAGER_UID],
  2608	  ['admin', ADMIN_UID],
  2609	];
  2610	const NON_MANAGER_ROLES = FENCE_ROLES.slice(0, 3);
  2611	const MANAGER_ROLES = FENCE_ROLES.slice(3);
  2612	const springMap = () => ({ 'mariah-tuesday-1': { teacher: 'Mariah', shortDetails: 'Clay' }, 'kathy-monday-2': { teacher: 'Kathy', processStep1: 'Paint' } });
  2613	
  2614	async function resetStorageMoveFixtures({ spring = true, target = null, migrations = null } = {}) {
  2615	  await testEnv.withSecurityRulesDisabled(async (ctx) => {
  2616	    const db = ctx.firestore();
  2617	    const lessonData = { 'fall-2026': { 'allie-wednesday-1': { teacher: 'Allie', shortDetails: 'Print' } }, lastUpdated: 'x' };
  2618	    if (spring) lessonData[SPRING] = springMap();
  2619	    await setDoc(doc(db, 'curriculum', 'lessonData'), lessonData);
  2620	    if (target) await setDoc(doc(db, 'curriculum', SPRING_DOC), target); else await deleteDoc(doc(db, 'curriculum', SPRING_DOC));
  2621	    if (migrations) await setDoc(doc(db, 'curriculum', MIGRATIONS), migrations); else await deleteDoc(doc(db, 'curriculum', MIGRATIONS));
  2622	  });
  2623	}
  2624	
  2625	// The Phase C move, as the console procedure will run it (one transaction).
  2626	async function runMove(db) {
  2627	  return runTransaction(db, async (tx) => {
  2628	    const ld = await tx.get(doc(db, 'curriculum', 'lessonData'));
  2629	    const target = await tx.get(doc(db, 'curriculum', SPRING_DOC));
  2630	    await tx.get(doc(db, 'curriculum', MIGRATIONS));
  2631	    if (target.exists()) throw new Error('target exists');
  2632	    const map = ld.data()[SPRING];
  2633	    tx.set(doc(db, 'curriculum', SPRING_DOC), { ...map, lastUpdated: 'now', lastUpdatedBy: 'test' });
  2634	    tx.update(doc(db, 'curriculum', 'lessonData'), { [SPRING]: deleteField() });
  2635	    tx.set(doc(db, 'curriculum', MIGRATIONS), { [SPRING]: { lessonCount: Object.keys(map).length, sha256: 'h', verified: false } }, { merge: true });
  2636	  });
  2637	}
  2638	// The rollback: re-add the key and delete the target in the same transaction.
  2639	async function runRollback(db, { deleteTarget = true } = {}) {
  2640	  return runTransaction(db, async (tx) => {
  2641	    await tx.get(doc(db, 'curriculum', 'lessonData'));
  2642	    await tx.get(doc(db, 'curriculum', SPRING_DOC));
  2643	    tx.update(doc(db, 'curriculum', 'lessonData'), { [SPRING]: springMap() });
  2644	    if (deleteTarget) tx.delete(doc(db, 'curriculum', SPRING_DOC));
  2645	  });
  2646	}
  2647	
  2648	describe('Classbook storage move — lessonData spring-2026 fence', () => {
  2649	  beforeEach(() => resetStorageMoveFixtures());
  2650	
  2651	  test.each(FENCE_ROLES)('%s can still update another semester in lessonData', async (_l, uid) => {
  2652	    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026.allie-wednesday-1.shortDetails': 'Updated' }));
  2653	  });
  2654	  test.each(FENCE_ROLES)('%s CANNOT change a spring-2026 lesson in lessonData', async (_l, uid) => {
  2655	    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.mariah-tuesday-1.shortDetails': 'Changed' }));
  2656	  });
  2657	  test.each(FENCE_ROLES)('%s CANNOT add a new spring-2026 lesson in lessonData', async (_l, uid) => {
  2658	    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.new-lesson': { teacher: 'X' } }));
  2659	  });
  2660	  test.each(MANAGER_ROLES)('%s can delete ONLY the spring-2026 key', async (_l, uid) => {
  2661	    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField() }));
  2662	  });
  2663	  test.each(NON_MANAGER_ROLES)('%s CANNOT delete the spring-2026 key', async (_l, uid) => {
  2664	    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField() }));
  2665	  });
  2666	  test.each(MANAGER_ROLES)('%s CANNOT delete spring-2026 together with another change', async (_l, uid) => {
  2667	    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField(), 'fall-2026.allie-wednesday-1.shortDetails': 'x' }));
  2668	  });
  2669	  test.each(FENCE_ROLES)('%s CANNOT delete the whole lessonData document', async (_l, uid) => {
  2670	    await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', 'lessonData')));
  2671	  });
  2672	  test.each(FENCE_ROLES)('%s CANNOT replace lessonData with a set() that changes spring-2026', async (_l, uid) => {
  2673	    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': {}, [SPRING]: { stale: true } }));
  2674	  });
  2675	  test.each(FENCE_ROLES)('%s can still merge-set another semester into lessonData (saveLessonData shape)', async (_l, uid) => {
  2676	    await assertSucceeds(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': { 'new-slot': { teacher: 'Allie' } } }, { merge: true }));
  2677	  });
  2678	});
  2679	
  2680	describe('Classbook storage move — lessonData cannot be recreated with spring-2026', () => {
  2681	  beforeEach(async () => {
  2682	    await resetStorageMoveFixtures();
  2683	    await testEnv.withSecurityRulesDisabled(async (ctx) => { await deleteDoc(doc(ctx.firestore(), 'curriculum', 'lessonData')); });
  2684	  });
  2685	  test.each(FENCE_ROLES)('%s CANNOT create lessonData containing spring-2026', async (_l, uid) => {
  2686	    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
  2687	  });
  2688	  test.each(FENCE_ROLES)('%s can create lessonData without spring-2026 (as today)', async (_l, uid) => {
  2689	    await assertSucceeds(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': {} }));
  2690	  });
  2691	});
  2692	
  2693	describe('Classbook storage move — the move transaction', () => {
  2694	  beforeEach(() => resetStorageMoveFixtures());
  2695	  test.each(MANAGER_ROLES)('%s can run the one-step move', async (_l, uid) => {
  2696	    await assertSucceeds(runMove(getDb(uid)));
  2697	  });
  2698	  test.each(NON_MANAGER_ROLES)('%s CANNOT run the move', async (_l, uid) => {
  2699	    await assertFails(runMove(getDb(uid)));
  2700	  });
  2701	  test.each(NON_MANAGER_ROLES)('%s CANNOT create lessons_spring-2026', async (_l, uid) => {
  2702	    await assertFails(setDoc(doc(getDb(uid), 'curriculum', SPRING_DOC), springMap()));
  2703	  });
  2704	  test.each(NON_MANAGER_ROLES)('%s CANNOT write storageMigrations', async (_l, uid) => {
  2705	    await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: { verified: true } }, { merge: true }));
  2706	  });
  2707	  test.each(FENCE_ROLES)('%s can read storageMigrations once it exists', async (_l, uid) => {
  2708	    await testEnv.withSecurityRulesDisabled(async (ctx) => { await setDoc(doc(ctx.firestore(), 'curriculum', MIGRATIONS), { [SPRING]: { verified: false } }); });
  2709	    await assertSucceeds(getDoc(doc(getDb(uid), 'curriculum', MIGRATIONS)));
  2710	  });
  2711	});
  2712	
  2713	describe('Classbook storage move — moved, NOT yet verified (edits paused; rollback allowed)', () => {
  2714	  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: false } } }));
  2715	
  2716	  test.each(FENCE_ROLES)('%s CANNOT edit lessons_spring-2026 before verification', async (_l, uid) => {
  2717	    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', SPRING_DOC), { 'mariah-tuesday-1.shortDetails': 'Changed' }));
  2718	  });
  2719	  test.each(FENCE_ROLES)('%s can read lessons_spring-2026', async (_l, uid) => {
  2720	    await assertSucceeds(getDoc(doc(getDb(uid), 'curriculum', SPRING_DOC)));
  2721	  });
  2722	  test.each(MANAGER_ROLES)('%s can run the rollback (re-add + delete target, one transaction)', async (_l, uid) => {
  2723	    await assertSucceeds(runRollback(getDb(uid)));
  2724	  });
  2725	  test.each(NON_MANAGER_ROLES)('%s CANNOT run the rollback', async (_l, uid) => {
  2726	    await assertFails(runRollback(getDb(uid)));
  2727	  });
  2728	  test.each(MANAGER_ROLES)('%s CANNOT re-add spring-2026 without deleting the target', async (_l, uid) => {
  2729	    await assertFails(runRollback(getDb(uid), { deleteTarget: false }));
  2730	  });
  2731	  test.each(FENCE_ROLES)('%s CANNOT plainly re-add spring-2026 to lessonData', async (_l, uid) => {
  2732	    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
  2733	  });
  2734	  test.each(MANAGER_ROLES)('%s can delete lessons_spring-2026 before verification', async (_l, uid) => {
  2735	    await assertSucceeds(deleteDoc(doc(getDb(uid), 'curriculum', SPRING_DOC)));
  2736	  });
  2737	  test.each(NON_MANAGER_ROLES)('%s CANNOT delete lessons_spring-2026', async (_l, uid) => {
  2738	    await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', SPRING_DOC)));
  2739	  });
  2740	  test.each(MANAGER_ROLES)('%s can mark the move verified', async (_l, uid) => {
  2741	    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
  2742	  });
  2743	  test.each(MANAGER_ROLES)('%s CANNOT create lessons_spring-2026 again while it exists (set over it is an update, refused while unverified)', async (_l, uid) => {
  2744	    await assertFails(setDoc(doc(getDb(uid), 'curriculum', SPRING_DOC), { replaced: true }));
  2745	  });
  2746	});
  2747	
  2748	describe('Classbook storage move — moved AND verified (edits back on; no delete, no rollback)', () => {
  2749	  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: true } } }));
  2750	
  2751	  test.each(FENCE_ROLES)('%s can edit a Spring lesson in lessons_spring-2026', async (_l, uid) => {
  2752	    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', SPRING_DOC), { 'mariah-tuesday-1.shortDetails': 'Changed' }));
  2753	  });
  2754	  test.each(FENCE_ROLES)('%s CANNOT delete lessons_spring-2026 after verification', async (_l, uid) => {
  2755	    await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', SPRING_DOC)));
  2756	  });
  2757	  test.each(MANAGER_ROLES)('%s CANNOT roll back after verification', async (_l, uid) => {
  2758	    await assertFails(runRollback(getDb(uid)));
  2759	  });
  2760	  test.each(FENCE_ROLES)('%s CANNOT re-create spring-2026 in lessonData', async (_l, uid) => {
  2761	    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.stale': { teacher: 'X' } }));
  2762	  });
  2763	  test.each(FENCE_ROLES)('%s still updates Fall in lessonData normally', async (_l, uid) => {
  2764	    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026.allie-wednesday-1.shortDetails': 'Updated' }));
  2765	  });
  2766	});
  2767	
  2768	describe('Classbook storage move — every other /curriculum doc exactly as before', () => {
  2769	  beforeEach(async () => {
  2770	    await testEnv.withSecurityRulesDisabled(async (ctx) => {
  2771	      const db = ctx.firestore();
  2772	      await setDoc(doc(db, 'curriculum', 'cutProjects'), { 'fall-2026': [] });
  2773	      await setDoc(doc(db, 'curriculum', 'prepCycleConfig'), { a: 1 });
  2774	      await setDoc(doc(db, 'curriculum', 'ordinary-delete-target'), { a: 1 });
  2775	    });
  2776	  });
  2777	  test.each(FENCE_ROLES)('%s can update cutProjects', async (_l, uid) => {
  2778	    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'cutProjects'), { 'fall-2026': ['x'] }));
  2779	  });
  2780	  test.each(MANAGER_ROLES)('%s can still delete an ordinary curriculum doc', async (_l, uid) => {
  2781	    await assertSucceeds(deleteDoc(doc(getDb(uid), 'curriculum', 'ordinary-delete-target')));
  2782	  });
  2783	  test('classbook-admin can still write prepCycleConfig; a plain teacher cannot', async () => {
  2784	    await assertSucceeds(updateDoc(doc(getDb(CLASSBOOK_ADMIN_UID), 'curriculum', 'prepCycleConfig'), { a: 2 }));
  2785	    await assertFails(updateDoc(doc(getDb(CLASSBOOK_UID), 'curriculum', 'prepCycleConfig'), { a: 3 }));
  2786	  });
  2787	  test.each(MANAGER_ROLES)('%s can still update appData and prepCycleConfig', async (_l, uid) => {
  2788	    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'appData'), { settings: true }));
  2789	    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'prepCycleConfig'), { a: 4 }));
  2790	  });
  2791	  test('staff without classbook access still cannot read or write curriculum', async () => {
  2792	    await assertFails(getDoc(doc(getDb(STAFF_NOACCESS_UID), 'curriculum', 'cutProjects')));
  2793	    await assertFails(updateDoc(doc(getDb(STAFF_NOACCESS_UID), 'curriculum', 'lessonData'), { 'fall-2026.x': {} }));
  2794	  });
  2795	});
  2796	
  2797	// A near-1 MiB lessonData (how production looked on Sep 29 2026): prove the fence evaluates on a
  2798	// full-size document. Built from many sub-fields; its Firestore size is estimated and asserted.
  2799	describe('Classbook storage move — fence on a near-1 MiB lessonData', () => {
  2800	  const firestoreSize = (v) => {
  2801	    const s = (x) => Buffer.byteLength(x, 'utf8') + 1;
  2802	    if (v === null || v === undefined) return 1;
  2803	    if (typeof v === 'string') return s(v);
  2804	    if (typeof v === 'number') return 8;
  2805	    if (typeof v === 'boolean') return 1;
  2806	    return Object.entries(v).reduce((t, [k, x]) => t + s(k) + firestoreSize(x), 0);
  2807	  };
  2808	  const bigSemester = (n) => {
  2809	    const out = {};
  2810	    for (let i = 0; i < n; i++) out[`teacher-class-${i}`] = { teacher: `T${i % 7}`, shortDetails: 'x'.repeat(600), processStep1: 'y'.repeat(600), introPitch: 'z'.repeat(500) };
  2811	    return out;
  2812	  };
  2813	  let big;
  2814	  beforeAll(() => {
  2815	    big = { 'fall-2026': bigSemester(230), [SPRING]: bigSemester(300), lastUpdated: 'x' };
  2816	  });
  2817	  beforeEach(async () => {
  2818	    await testEnv.withSecurityRulesDisabled(async (ctx) => {
  2819	      await setDoc(doc(ctx.firestore(), 'curriculum', 'lessonData'), big);
  2820	      await deleteDoc(doc(ctx.firestore(), 'curriculum', SPRING_DOC));
  2821	      await deleteDoc(doc(ctx.firestore(), 'curriculum', MIGRATIONS));
  2822	    });
  2823	  });
  2824	  test('the fixture really is near the cap (≈ 0.9–1.0 MiB estimated)', () => {
  2825	    const kb = firestoreSize(big) / 1024;
  2826	    expect(kb).toBeGreaterThan(900);
  2827	    expect(kb).toBeLessThan(1020);
  2828	  });
  2829	  test('teacher can update Fall; cannot touch Spring', async () => {
  2830	    await assertSucceeds(updateDoc(doc(getDb(CLASSBOOK_UID), 'curriculum', 'lessonData'), { 'fall-2026.teacher-class-1.shortDetails': 'Updated' }));
  2831	    await assertFails(updateDoc(doc(getDb(CLASSBOOK_UID), 'curriculum', 'lessonData'), { 'spring-2026.teacher-class-1.shortDetails': 'Changed' }));
  2832	  });
  2833	  test('manager can run the one-step move on the full-size document', async () => {
  2834	    await assertSucceeds(runMove(getDb(MANAGER_UID)));
  2835	  });
  2836	});
  2837	
  2838	// Implementation review (Codex, Sep 29): the rollback must DELETE the target in the same
  2839	// transaction (not merely find it absent), and "verified" can never be switched back off.
  2840	describe('Classbook storage move — review fixes (rollback needs the target; verified is one-way)', () => {
  2841	  test.each(MANAGER_ROLES)('%s CANNOT re-add spring-2026 when both copies are already absent', async (_l, uid) => {
  2842	    await resetStorageMoveFixtures({ spring: false, target: null, migrations: { [SPRING]: { verified: false } } });
  2843	    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
  2844	  });
  2845	  test.each(MANAGER_ROLES)('%s CANNOT merge-set a changed spring-2026 into lessonData', async (_l, uid) => {
  2846	    await resetStorageMoveFixtures();
  2847	    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: { 'mariah-tuesday-1': { shortDetails: 'x' } } }, { merge: true }));
  2848	  });
  2849	
  2850	  describe('after verification', () => {
  2851	    beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: true, sha256: 'h' } } }));
  2852	    test.each(MANAGER_ROLES)('%s CANNOT set verified back to false', async (_l, uid) => {
  2853	      await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: false }));
  2854	    });
  2855	    test.each(MANAGER_ROLES)('%s CANNOT delete the verified field', async (_l, uid) => {
  2856	      await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: deleteField() }));
  2857	    });
  2858	    test.each(MANAGER_ROLES)('%s CANNOT remove the spring-2026 entry', async (_l, uid) => {
  2859	      await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: deleteField() }));
  2860	    });
  2861	    test.each(MANAGER_ROLES)('%s CANNOT replace the whole record with set()', async (_l, uid) => {
  2862	      await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { other: true }));
  2863	    });
  2864	    test.each(FENCE_ROLES)('%s CANNOT delete the migration record', async (_l, uid) => {
  2865	      await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', MIGRATIONS)));
  2866	    });
  2867	    test.each(MANAGER_ROLES)('%s can still add other fields to the record (verified stays true)', async (_l, uid) => {
  2868	      await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.note`]: 'spot-checked' }));
  2869	    });
  2870	  });

exec
/bin/zsh -lc "nl -ba firestore.rules | sed -n '680,785p'; nl -ba rules.test.js | sed -n '2835,2925p'; tail -n 140 /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA-r3.diff" in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
 succeeded in 0ms:
   680	        return request.resource.data.diff(resource.data).affectedKeys();
   681	      }
   682	      function springKeyUntouched() {
   683	        return !lessonDataChangedKeys().hasAny(['spring-2026']);
   684	      }
   685	      function springKeyRemovedOnly() {
   686	        return lessonDataChangedKeys().hasOnly(['spring-2026'])
   687	          && !('spring-2026' in request.resource.data);
   688	      }
   689	      function springKeyRolledBack() {
   690	        return lessonDataChangedKeys().hasOnly(['spring-2026'])
   691	          && ('spring-2026' in request.resource.data)
   692	          && !('spring-2026' in resource.data)
   693	          && exists(/databases/$(database)/documents/curriculum/lessons_spring-2026)
   694	          && !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
   695	          && !springMoveVerified();
   696	      }
   697	
   698	      // Manager+: full access to everything including appData (reads; ordinary-doc writes)
   699	      allow read: if isManagerOrAbove();
   700	      allow create, update, delete: if isManagerOrAbove() && !isStorageMoveDoc();
   701	
   702	      // classbook-admin, curriculum-admin (legacy key), and classbook: full read/write except appData and prepCycleConfig
   703	      // appData (Settings) is manager+ only, always
   704	      // prepCycleConfig (Prep Cycle workflow config) is classbook-admin only
   705	      // NOTE: 'classbook' (plain teacher) access is intentionally NOT
   706	      // isolated per-teacher here — each semester's lessons live in one
   707	      // shared doc, and per-field isolation is enforced by the UI, not
   708	      // by these rules. This is a known, accepted gap (see
   709	      // firebase-agent-defense-hardening.md) pending a possible future
   710	      // data-model change, not something this rule can close on its own.
   711	      allow read: if isClassbookRole();
   712	      allow create, update: if
   713	        isClassbookRole()
   714	        && docId != 'appData'
   715	        && docId != 'prepCycleConfig'
   716	        && !isStorageMoveDoc();
   717	      // Whole-document delete is classbook-admin/curriculum-admin only.
   718	      // Plain 'classbook' (teacher) access never calls a full-document
   719	      // delete in the app (only FieldValue.delete() on specific lesson
   720	      // fields, which is an update, not a delete) — so this closes an
   721	      // unused, high-blast-radius capability with no functional change.
   722	      allow delete: if
   723	        isClassbookAdminRole()
   724	        && docId != 'appData'
   725	        && docId != 'prepCycleConfig'
   726	        && !isStorageMoveDoc();
   727	      // prepCycleConfig: classbook-admin and curriculum-admin write only
   728	      allow create, update, delete: if
   729	        isClassbookAdminRole()
   730	        && docId == 'prepCycleConfig';
   731	
   732	      // lessonData: as before for every semester except 'spring-2026'; no whole-document delete.
   733	      allow create: if docId == 'lessonData'
   734	        && (isManagerOrAbove() || isClassbookRole())
   735	        && !('spring-2026' in request.resource.data);
   736	      allow update: if docId == 'lessonData'
   737	        && (isManagerOrAbove() || isClassbookRole())
   738	        && springKeyUntouched();
   739	      allow update: if docId == 'lessonData'
   740	        && isManagerOrAbove()
   741	        && (springKeyRemovedOnly() || springKeyRolledBack());
   742	
   743	      // lessons_spring-2026: Spring 2026's lessons after the move.
   744	      allow create: if docId == 'lessons_spring-2026' && isManagerOrAbove();
   745	      allow update: if docId == 'lessons_spring-2026'
   746	        && (isManagerOrAbove() || isClassbookRole())
   747	        && springMoveVerified();
   748	      allow delete: if docId == 'lessons_spring-2026'
   749	        && isManagerOrAbove()
   750	        && !springMoveVerified();
   751	
   752	      // storageMigrations: the move's record (manager+ writes; read via the read lines above).
   753	      // 'verified' is one-way: once true it can never be turned off, removed or replaced (that
   754	      // would reopen delete/rollback). It may become true only when, AFTER the write (existsAfter/getAfter, so it
   755	      // can't be combined with a delete or rollback in one batch), lessons_spring-2026 exists and
   756	      // lessonData no longer holds 'spring-2026'. No role deletes the record.
   757	      function springVerifiedIn(data) {
   758	        return data.get('spring-2026', {}).get('verified', false) == true;
   759	      }
   760	      function springVerifyTransitionOk() {
   761	        return !springVerifiedIn(request.resource.data)
   762	          || (existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
   763	              && !('spring-2026' in getAfter(/databases/$(database)/documents/curriculum/lessonData).data));
   764	      }
   765	      allow create: if docId == 'storageMigrations'
   766	        && isManagerOrAbove()
   767	        && springVerifyTransitionOk();
   768	      allow update: if docId == 'storageMigrations'
   769	        && isManagerOrAbove()
   770	        && (springVerifiedIn(resource.data)
   771	              ? springVerifiedIn(request.resource.data)
   772	              : springVerifyTransitionOk());
   773	    }
   774	
   775	    // ═══════════════════════════════════════════════════════════════
   776	    // CLASSBOOK — SCHOOL DAY OFF CAMPS (SDOCs)
   777	    // Plan: tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html (Phase 1, §1.1)
   778	    //   dayOffCamps_events / dayOffCamps_camps: the admin's planning list for a school year.
   779	    //     classbook-admin (+ manager+) write, plain classbook teachers read.
   780	    //   dayOffCamps_lessonData: one shared plan per camp-project. Teachers create/update like
   781	    //     summerCamps_lessonData (per-teacher isolation is UI-enforced — the same accepted gap as
   782	    //     summer); whole-document delete is admin-only, like /curriculum's delete clause.
   783	    //   The legacy 'curriculum-admin' key is deliberately NOT extended to these new collections.
   784	    //   Visibility of an unpublished year is UI gating only: every classbook teacher can read these.
   785	    // ═══════════════════════════════════════════════════════════════
  2835	  });
  2836	});
  2837	
  2838	// Implementation review (Codex, Sep 29): the rollback must DELETE the target in the same
  2839	// transaction (not merely find it absent), and "verified" can never be switched back off.
  2840	describe('Classbook storage move — review fixes (rollback needs the target; verified is one-way)', () => {
  2841	  test.each(MANAGER_ROLES)('%s CANNOT re-add spring-2026 when both copies are already absent', async (_l, uid) => {
  2842	    await resetStorageMoveFixtures({ spring: false, target: null, migrations: { [SPRING]: { verified: false } } });
  2843	    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
  2844	  });
  2845	  test.each(MANAGER_ROLES)('%s CANNOT merge-set a changed spring-2026 into lessonData', async (_l, uid) => {
  2846	    await resetStorageMoveFixtures();
  2847	    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: { 'mariah-tuesday-1': { shortDetails: 'x' } } }, { merge: true }));
  2848	  });
  2849	
  2850	  describe('after verification', () => {
  2851	    beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: true, sha256: 'h' } } }));
  2852	    test.each(MANAGER_ROLES)('%s CANNOT set verified back to false', async (_l, uid) => {
  2853	      await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: false }));
  2854	    });
  2855	    test.each(MANAGER_ROLES)('%s CANNOT delete the verified field', async (_l, uid) => {
  2856	      await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: deleteField() }));
  2857	    });
  2858	    test.each(MANAGER_ROLES)('%s CANNOT remove the spring-2026 entry', async (_l, uid) => {
  2859	      await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: deleteField() }));
  2860	    });
  2861	    test.each(MANAGER_ROLES)('%s CANNOT replace the whole record with set()', async (_l, uid) => {
  2862	      await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { other: true }));
  2863	    });
  2864	    test.each(FENCE_ROLES)('%s CANNOT delete the migration record', async (_l, uid) => {
  2865	      await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', MIGRATIONS)));
  2866	    });
  2867	    test.each(MANAGER_ROLES)('%s can still add other fields to the record (verified stays true)', async (_l, uid) => {
  2868	      await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.note`]: 'spot-checked' }));
  2869	    });
  2870	  });
  2871	
  2872	  test.each(MANAGER_ROLES)('%s CANNOT mark verified while lessons_spring-2026 does not exist', async (_l, uid) => {
  2873	    await resetStorageMoveFixtures({ spring: false, target: null, migrations: { [SPRING]: { verified: false } } });
  2874	    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
  2875	  });
  2876	  test.each(MANAGER_ROLES)('%s CANNOT mark verified while spring-2026 is still in lessonData', async (_l, uid) => {
  2877	    await resetStorageMoveFixtures({ spring: true, target: { ...springMap() }, migrations: { [SPRING]: { verified: false } } });
  2878	    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
  2879	  });
  2880	  test.each(MANAGER_ROLES)('%s CANNOT create the record already verified before the move', async (_l, uid) => {
  2881	    await resetStorageMoveFixtures();
  2882	    await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: { verified: true } }));
  2883	  });
  2884	});
  2885	
  2886	// Implementation review round 2 (Codex): "verified" must describe the state AFTER the write,
  2887	// so it can't be turned on in the same atomic request that deletes the target or rolls back.
  2888	describe('Classbook storage move — verify can\'t be combined with delete or rollback', () => {
  2889	  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: false } } }));
  2890	  test.each(MANAGER_ROLES)('%s CANNOT verify and delete lessons_spring-2026 in one batch', async (_l, uid) => {
  2891	    const db = getDb(uid);
  2892	    const b = writeBatch(db);
  2893	    b.update(doc(db, 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true });
  2894	    b.delete(doc(db, 'curriculum', SPRING_DOC));
  2895	    await assertFails(b.commit());
  2896	  });
  2897	  test.each(MANAGER_ROLES)('%s CANNOT verify and roll back in one transaction', async (_l, uid) => {
  2898	    const db = getDb(uid);
  2899	    await assertFails(runTransaction(db, async (tx) => {
  2900	      await tx.get(doc(db, 'curriculum', 'lessonData'));
  2901	      await tx.get(doc(db, 'curriculum', SPRING_DOC));
  2902	      tx.update(doc(db, 'curriculum', 'lessonData'), { [SPRING]: springMap() });
  2903	      tx.delete(doc(db, 'curriculum', SPRING_DOC));
  2904	      tx.update(doc(db, 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true });
  2905	    }));
  2906	  });
  2907	  test.each(MANAGER_ROLES)('%s can still verify on its own when the move is complete', async (_l, uid) => {
  2908	    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
  2909	  });
  2910	});
+      const db = ctx.firestore();
+      await setDoc(doc(db, 'curriculum', 'cutProjects'), { 'fall-2026': [] });
+      await setDoc(doc(db, 'curriculum', 'prepCycleConfig'), { a: 1 });
+      await setDoc(doc(db, 'curriculum', 'ordinary-delete-target'), { a: 1 });
+    });
+  });
+  test.each(FENCE_ROLES)('%s can update cutProjects', async (_l, uid) => {
+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'cutProjects'), { 'fall-2026': ['x'] }));
+  });
+  test.each(MANAGER_ROLES)('%s can still delete an ordinary curriculum doc', async (_l, uid) => {
+    await assertSucceeds(deleteDoc(doc(getDb(uid), 'curriculum', 'ordinary-delete-target')));
+  });
+  test('classbook-admin can still write prepCycleConfig; a plain teacher cannot', async () => {
+    await assertSucceeds(updateDoc(doc(getDb(CLASSBOOK_ADMIN_UID), 'curriculum', 'prepCycleConfig'), { a: 2 }));
+    await assertFails(updateDoc(doc(getDb(CLASSBOOK_UID), 'curriculum', 'prepCycleConfig'), { a: 3 }));
+  });
+  test.each(MANAGER_ROLES)('%s can still update appData and prepCycleConfig', async (_l, uid) => {
+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'appData'), { settings: true }));
+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'prepCycleConfig'), { a: 4 }));
+  });
+  test('staff without classbook access still cannot read or write curriculum', async () => {
+    await assertFails(getDoc(doc(getDb(STAFF_NOACCESS_UID), 'curriculum', 'cutProjects')));
+    await assertFails(updateDoc(doc(getDb(STAFF_NOACCESS_UID), 'curriculum', 'lessonData'), { 'fall-2026.x': {} }));
+  });
+});
+
+// A near-1 MiB lessonData (how production looked on Sep 29 2026): prove the fence evaluates on a
+// full-size document. Built from many sub-fields; its Firestore size is estimated and asserted.
+describe('Classbook storage move — fence on a near-1 MiB lessonData', () => {
+  const firestoreSize = (v) => {
+    const s = (x) => Buffer.byteLength(x, 'utf8') + 1;
+    if (v === null || v === undefined) return 1;
+    if (typeof v === 'string') return s(v);
+    if (typeof v === 'number') return 8;
+    if (typeof v === 'boolean') return 1;
+    return Object.entries(v).reduce((t, [k, x]) => t + s(k) + firestoreSize(x), 0);
+  };
+  const bigSemester = (n) => {
+    const out = {};
+    for (let i = 0; i < n; i++) out[`teacher-class-${i}`] = { teacher: `T${i % 7}`, shortDetails: 'x'.repeat(600), processStep1: 'y'.repeat(600), introPitch: 'z'.repeat(500) };
+    return out;
+  };
+  let big;
+  beforeAll(() => {
+    big = { 'fall-2026': bigSemester(230), [SPRING]: bigSemester(300), lastUpdated: 'x' };
+  });
+  beforeEach(async () => {
+    await testEnv.withSecurityRulesDisabled(async (ctx) => {
+      await setDoc(doc(ctx.firestore(), 'curriculum', 'lessonData'), big);
+      await deleteDoc(doc(ctx.firestore(), 'curriculum', SPRING_DOC));
+      await deleteDoc(doc(ctx.firestore(), 'curriculum', MIGRATIONS));
+    });
+  });
+  test('the fixture really is near the cap (≈ 0.9–1.0 MiB estimated)', () => {
+    const kb = firestoreSize(big) / 1024;
+    expect(kb).toBeGreaterThan(900);
+    expect(kb).toBeLessThan(1020);
+  });
+  test('teacher can update Fall; cannot touch Spring', async () => {
+    await assertSucceeds(updateDoc(doc(getDb(CLASSBOOK_UID), 'curriculum', 'lessonData'), { 'fall-2026.teacher-class-1.shortDetails': 'Updated' }));
+    await assertFails(updateDoc(doc(getDb(CLASSBOOK_UID), 'curriculum', 'lessonData'), { 'spring-2026.teacher-class-1.shortDetails': 'Changed' }));
+  });
+  test('manager can run the one-step move on the full-size document', async () => {
+    await assertSucceeds(runMove(getDb(MANAGER_UID)));
+  });
+});
+
+// Implementation review (Codex, Sep 29): the rollback must DELETE the target in the same
+// transaction (not merely find it absent), and "verified" can never be switched back off.
+describe('Classbook storage move — review fixes (rollback needs the target; verified is one-way)', () => {
+  test.each(MANAGER_ROLES)('%s CANNOT re-add spring-2026 when both copies are already absent', async (_l, uid) => {
+    await resetStorageMoveFixtures({ spring: false, target: null, migrations: { [SPRING]: { verified: false } } });
+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
+  });
+  test.each(MANAGER_ROLES)('%s CANNOT merge-set a changed spring-2026 into lessonData', async (_l, uid) => {
+    await resetStorageMoveFixtures();
+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: { 'mariah-tuesday-1': { shortDetails: 'x' } } }, { merge: true }));
+  });
+
+  describe('after verification', () => {
+    beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: true, sha256: 'h' } } }));
+    test.each(MANAGER_ROLES)('%s CANNOT set verified back to false', async (_l, uid) => {
+      await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: false }));
+    });
+    test.each(MANAGER_ROLES)('%s CANNOT delete the verified field', async (_l, uid) => {
+      await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: deleteField() }));
+    });
+    test.each(MANAGER_ROLES)('%s CANNOT remove the spring-2026 entry', async (_l, uid) => {
+      await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: deleteField() }));
+    });
+    test.each(MANAGER_ROLES)('%s CANNOT replace the whole record with set()', async (_l, uid) => {
+      await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { other: true }));
+    });
+    test.each(FENCE_ROLES)('%s CANNOT delete the migration record', async (_l, uid) => {
+      await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', MIGRATIONS)));
+    });
+    test.each(MANAGER_ROLES)('%s can still add other fields to the record (verified stays true)', async (_l, uid) => {
+      await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.note`]: 'spot-checked' }));
+    });
+  });
+
+  test.each(MANAGER_ROLES)('%s CANNOT mark verified while lessons_spring-2026 does not exist', async (_l, uid) => {
+    await resetStorageMoveFixtures({ spring: false, target: null, migrations: { [SPRING]: { verified: false } } });
+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
+  });
+  test.each(MANAGER_ROLES)('%s CANNOT mark verified while spring-2026 is still in lessonData', async (_l, uid) => {
+    await resetStorageMoveFixtures({ spring: true, target: { ...springMap() }, migrations: { [SPRING]: { verified: false } } });
+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
+  });
+  test.each(MANAGER_ROLES)('%s CANNOT create the record already verified before the move', async (_l, uid) => {
+    await resetStorageMoveFixtures();
+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: { verified: true } }));
+  });
+});
+
+// Implementation review round 2 (Codex): "verified" must describe the state AFTER the write,
+// so it can't be turned on in the same atomic request that deletes the target or rolls back.
+describe('Classbook storage move — verify can\'t be combined with delete or rollback', () => {
+  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: false } } }));
+  test.each(MANAGER_ROLES)('%s CANNOT verify and delete lessons_spring-2026 in one batch', async (_l, uid) => {
+    const db = getDb(uid);
+    const b = writeBatch(db);
+    b.update(doc(db, 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true });
+    b.delete(doc(db, 'curriculum', SPRING_DOC));
+    await assertFails(b.commit());
+  });
+  test.each(MANAGER_ROLES)('%s CANNOT verify and roll back in one transaction', async (_l, uid) => {
+    const db = getDb(uid);
+    await assertFails(runTransaction(db, async (tx) => {
+      await tx.get(doc(db, 'curriculum', 'lessonData'));
+      await tx.get(doc(db, 'curriculum', SPRING_DOC));
+      tx.update(doc(db, 'curriculum', 'lessonData'), { [SPRING]: springMap() });
+      tx.delete(doc(db, 'curriculum', SPRING_DOC));
+      tx.update(doc(db, 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true });
+    }));
+  });
+  test.each(MANAGER_ROLES)('%s can still verify on its own when the move is complete', async (_l, uid) => {
+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
+  });
+});

exec
/bin/zsh -lc "nl -ba firestore.rules | sed -n '1,90p'; git diff -- firestore.rules rules.test.js | sed -n '1,260p'" in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
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
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-0PcvZhoF' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-mFRfG79F' (errno=Operation not permitted)

codex
## Verdict: SAFE TO MERGE AND DEPLOY

- Round-2 blocker: **RESOLVED**. Verification now checks final atomic state using `existsAfter()` and `getAfter()` at [firestore.rules:762](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/firestore.rules:762).
- Verify+delete and verify+rollback are explicitly covered at [rules.test.js:2890](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/rules.test.js:2890) and [rules.test.js:2897](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/rules.test.js:2897).
- `getAfter(lessonData)` on standalone verification is valid even though that document is not written. It adds one document-access read—including the near-1 MiB document—but remains comfortably within rule access-call and transaction limits.
- The move’s `verified:false` path short-circuits before both `existsAfter`/`getAfter`, so the move transaction does not incur that extra large-document lookup.
- Standalone verification remains allowed at [rules.test.js:2907](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/rules.test.js:2907).

No new bypass or blocker found. Tests were not run, as requested.
tokens used
39,264
## Verdict: SAFE TO MERGE AND DEPLOY

- Round-2 blocker: **RESOLVED**. Verification now checks final atomic state using `existsAfter()` and `getAfter()` at [firestore.rules:762](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/firestore.rules:762).
- Verify+delete and verify+rollback are explicitly covered at [rules.test.js:2890](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/rules.test.js:2890) and [rules.test.js:2897](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/rules.test.js:2897).
- `getAfter(lessonData)` on standalone verification is valid even though that document is not written. It adds one document-access read—including the near-1 MiB document—but remains comfortably within rule access-call and transaction limits.
- The move’s `verified:false` path short-circuits before both `existsAfter`/`getAfter`, so the move transaction does not incur that extra large-document lookup.
- Standalone verification remains allowed at [rules.test.js:2907](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/rules.test.js:2907).

No new bypass or blocker found. Tests were not run, as requested.
