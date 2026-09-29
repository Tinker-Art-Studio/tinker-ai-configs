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
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:2028:// or Q&A-only plan is never classified "empty" and deleted (round 1 review).
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:2573:// A teacher's plan is the camp-project's record in dayOffCamps_lessonData (the
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:2638:// saveSingleLesson()'s SDOC branch. Returns { status, doc, by, own }:
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:2646:async function saveDayOffPlan(yearKey, lessonKey, lessonData, fieldsToClear = [], auth) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:2655:  const extra = Object.keys(lessonData).filter(k => !DAY_OFF_PLAN_WRITABLE.includes(k));
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:2659:  if (!lessonData.lastEditedBy || !lessonData.lastEditedAt) throw new Error('An SDOC plan save must carry its edit stamp — refused.');
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:2661:  const payload = { ...lessonData };
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:2720:  return { status: 'savedSince', doc: server, by: server.lastEditedBy || 'someone', own: server.lastEditedBy === lessonData.lastEditedBy };
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js:2814:    if (badDetails || badLinks) throw new DayOffValidationError(["This project's stored details are in an unexpected format — nothing was changed. Ask for help before editing them."]);
firestore.rules:53:    // resolve its own claim documents in timeclock_reminder_log. Never OR this with a helper that
firestore.rules:652:    match /curriculum/{docId} {
firestore.rules:655:      // curriculum/lessonData holds every Fall/Spring semester in ONE document and was at 95% of
firestore.rules:656:      // Firestore's 1 MiB cap. Spring 2026 moves to curriculum/lessons_spring-2026 in one manager
firestore.rules:659:      //   lessonData          — nobody changes its 'spring-2026' key, except manager+ deleting ONLY
firestore.rules:663:      //   lessons_spring-2026 — created by manager+; edited only once storageMigrations says the move
firestore.rules:665:      //   storageMigrations   — manager+ writes; classbook roles read.
firestore.rules:673:        return docId in ['lessonData', 'lessons_spring-2026', 'storageMigrations'];
firestore.rules:676:        let path = /databases/$(database)/documents/curriculum/storageMigrations;
firestore.rules:679:      function lessonDataChangedKeys() {
firestore.rules:683:        return !lessonDataChangedKeys().hasAny(['spring-2026']);
firestore.rules:686:        return lessonDataChangedKeys().hasOnly(['spring-2026'])
diff --git a/firestore.rules b/firestore.rules
index ec41acd..3c805de 100644
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
@@ -662,24 +708,67 @@ service cloud.firestore {
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
+      // would reopen delete/rollback). It may become true only when lessons_spring-2026 exists and
+      // lessonData no longer holds 'spring-2026'. No role deletes the record.
+      function springVerifiedIn(data) {
+        return data.get('spring-2026', {}).get('verified', false) == true;
+      }
+      function springVerifyTransitionOk() {
+        return !springVerifiedIn(request.resource.data)
+          || (exists(/databases/$(database)/documents/curriculum/lessons_spring-2026)
+              && !('spring-2026' in get(/databases/$(database)/documents/curriculum/lessonData).data));
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
index 11bb541..08fdd1b 100644
--- a/rules.test.js
+++ b/rules.test.js
@@ -2585,3 +2585,300 @@ describe('Clay Hub Membership — the database protects memberId and freezes ret
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
+    await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', SPRING_DOC)));
+  });
+  test.each(MANAGER_ROLES)('%s CANNOT roll back after verification', async (_l, uid) => {
+    await assertFails(runRollback(getDb(uid)));
+  });
+  test.each(FENCE_ROLES)('%s CANNOT re-create spring-2026 in lessonData', async (_l, uid) => {
+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.stale': { teacher: 'X' } }));
+  });
+  test.each(FENCE_ROLES)('%s still updates Fall in lessonData normally', async (_l, uid) => {
+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026.allie-wednesday-1.shortDetails': 'Updated' }));

exec
/bin/zsh -lc 'rg -n "''^(##|###|Verdict|SAFE|NOT)|blocking|Finding|Bypass|MiB|verified|ternary" /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA-codex.md && nl -ba firestore.rules | sed -n '"'640,790p' && rg -n \""'^diff --git|''^@@|springVerify|springMove|storageMigrations|near-1|standalone|verified" /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA-r2.diff' in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
 succeeded in 0ms:
14:## Implementation review — Phase A (Firestore rules), before merge and deploy
20:2. Does it implement Phase A exactly (fence, move, rollback with existsAfter, verified gating, delete rules)? Any bypass (set with merge, set without merge, batch vs transaction, field-path tricks, creating lessonData when absent, map-valued 'spring-2026' vs dotted paths)?
21:3. Will the Classbook's real current writes to lessonData keep working (saveSingleLesson dotted per-field updates, saveMultipleLessonFields, saveLessonData merge-set, deleteLessonKey, Q&A/help replies — see /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js and js/app.js), including when lessonData is near 1 MiB? Anything in Studio Hub or other apps writing /curriculum?
22:4. Rules limits/cost: get/exists call counts per request, evaluation on a near-1 MiB doc.
24:Verdict: SAFE TO MERGE AND DEPLOY or NOT (minimum list). Do not edit files or run tests.
54:rules.test.js:2593:// 1 MiB cap on Sep 29 2026. Spring 2026 moves to curriculum/lessons_spring-2026 in one
57:rules.test.js:2597:// manager, edited only once storageMigrations says the move is verified, and deleted only by a
98:rules.test.js:2743:  test.each(MANAGER_ROLES)('%s CANNOT create lessons_spring-2026 again while it exists (set over it is an update, refused while unverified)', async (_l, uid) => {
106:rules.test.js:2797:// A near-1 MiB lessonData (how production looked on Sep 29 2026): prove the fence evaluates on a
107:rules.test.js:2799:describe('Classbook storage move — fence on a near-1 MiB lessonData', () => {
232:firestore.rules:656:      // Firestore's 1 MiB cap. Spring 2026 moves to curriculum/lessons_spring-2026 in one manager
491:<h2 id="today">What exists today (research, verified in review round 1)</h2>
494:  <tr><td><code>curriculum/lessonData</code> = <code>{ &lt;semKey&gt;: { &lt;lessonKey&gt;: lesson }, lastUpdated, lastUpdatedBy, qaData? }</code>. Firestore caps a document at 1 MiB.</td><td>measured Sep 29</td></tr>
515:  <li><strong>Spring edits stay paused, enforced by the rules, until the move is verified.</strong> A rule on <code>curriculum/lessons_spring-2026</code> allows updates only when <code>curriculum/storageMigrations</code> has <code>spring-2026.verified == true</code> (a <code>get()</code> on Spring writes only; Spring is dormant, so the cost is negligible). So nothing can change the new document between the copy and the verification: its hash is stable, and a rollback can't discard a real edit.</li>
524:  <li>No role can create, add to, or change the <code>spring-2026</code> key, with exactly two manager/admin exceptions. (1) An update that <em>only deletes</em> it, for the Phase C transaction. (2) The <strong>rollback</strong>: an update that <em>only re-adds</em> it, allowed only while <code>storageMigrations.spring-2026.verified != true</code> and only if <code>getAfter(lessons_spring-2026)</code> shows that document deleted in the same transaction (Codex round 2, fix 1).</li>
528:<p>For <code>curriculum/lessons_spring-2026</code>: create by a manager only, and only if it doesn't exist. Updates only when <code>storageMigrations.spring-2026.verified == true</code>, for the roles that can update lessons today. Whole-doc delete by <strong>manager/admin only, and only while not yet verified</strong> (the rollback). classbook-admin and curriculum-admin may never delete it, and <strong>nobody</strong> may delete it after verification, until the follow-up plan adds a routed delete/archive (Codex round 2, fix 2).</p>
531:<p><strong>Shape:</strong> split <code>:654</code> (<code>allow read, write: if isManagerOrAbove()</code>) into <code>read</code> / <code>create</code> / <code>update</code> / <code>delete</code> statements, because rules OR across statements. Manager <code>delete</code> is kept for every curriculum doc except <code>lessonData</code>. The classbook-role statements at <code>:666</code> and <code>:675-678</code> get the same <code>lessonData</code>/<code>lessons_spring-2026</code> conditions. The <code>lessonData</code> update condition is <code>!affectedKeys().hasAny(['spring-2026'])</code>, OR (manager/admin, removal) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; !('spring-2026' in request.resource.data)</code>, OR (manager/admin, <strong>rollback re-add</strong>) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; ('spring-2026' in request.resource.data) &amp;&amp; !('spring-2026' in resource.data) &amp;&amp; !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026) &amp;&amp; get(/databases/$(database)/documents/curriculum/storageMigrations).data.get('spring-2026', {}).get('verified', false) != true</code>. Every split statement is constrained this way, because <code>allow</code> statements OR together.</p>
540:  rollback: manager/admin re-adds only spring-2026 AND deletes lessons_spring-2026 in one transaction, while unverified → allowed
541:  the same rollback after verified                                  → denied
544:  lessons_spring-2026 update before verified                        → denied (every role); after verified → allowed as for lessons today
545:  lessons_spring-2026 delete before verified                        → manager/admin allowed (rollback); teacher/classbook-admin/curriculum-admin denied
546:  lessons_spring-2026 delete after verified                         → denied (every role)
555:<p><strong>Acceptance:</strong> in production (no <code>lessons_spring-2026</code> yet), everything behaves as today, and Spring is view-only ("editing is paused while Spring 2026 moves to new storage"). In the emulator, with Spring moved and verified, Spring works end to end, and Fall and every other semester are untouched. This is one Classbook deploy (one Netlify credit) plus one Studio Hub deploy.</p>
565:  <li><strong>Writes to Spring:</strong> they go to <code>lessons_K</code> only when <code>storageMigrations.spring-2026.verified</code> is true, read by a small <code>storageMigrations</code> listener. Otherwise the app shows the "editing is paused" message; the rules refuse those writes anyway. <code>not-found</code> is handled the same way.</li>
576:Scenario: Spring moved and verified works end to end (emulator)
580:Scenario: moved but not yet verified — edits paused
581:  Given lessons_spring-2026 exists, verified false
609:      <li><code>tx.set(storageMigrations, { 'spring-2026': { movedAt, movedBy, lessonCount, sha256, verified: false } }, { merge: true })</code></li>
613:  <li><strong>If verification passes:</strong> <code>storageMigrations.spring-2026.verified = true</code>, and Spring becomes editable. Spot-check one Spring lesson in the Firebase Console.</li>
614:  <li><strong>If it fails:</strong> nothing has been edited since the copy, so the reverse transaction is safe: it puts <code>map</code> back into <code>lessonData</code>, which Phase A's rollback allowance permits (a manager/admin, only this key, only while unverified, and only together with deleting <code>lessons_spring-2026</code>), deletes <code>lessons_spring-2026</code>, and records the failure. The download from step 1 remains the last resort.</li>
617:  Then lessons_spring-2026 deep-equals the old map (+ lastUpdated*), lessonData has no spring-2026, storageMigrations records count + hash, verified → true, Spring editable, Fall untouched
641:  <li><strong>Reversible:</strong> a reverse transaction until verified. After that, the download and backups.</li>
650:  <li><strong>Mid-C:</strong> the transaction either committed or didn't. If it committed but isn't verified, Spring is viewable, edits are paused, and the reverse transaction exists.</li>
667:    <li>The rollback re-add is explicitly allowed for manager/admin, only while unverified and only with <code>lessons_spring-2026</code> deleted in the same transaction (<code>getAfter</code>). This replaces the test that contradicted it.</li>
668:    <li>Deleting the new document is manager/admin-only and only while unverified. Other roles are always denied, and everyone is denied after verification until the follow-up plan.</li>
673:  <strong>Sep 29, 2026: revision 3, after Codex's independent round 1 (<code>…-codex-r1.md</code>): NOT ready, 8-point minimum list, all verified and taken.</strong>
675:    <li>Adopted Codex's "simpler safe option": the copy and the old-copy removal are <strong>one transaction</strong>, with Spring edits paused by rule until the move is verified. That closes the verification/rollback race (1), the target-missing-at-delete risk (2) and double counting (5), since there's no dual-copy window, and Phases C and D merge.</li>
717:+      // Firestore's 1 MiB cap. Spring 2026 moves to curriculum/lessons_spring-2026 in one manager
722:+      //                         unverified AND the new doc is deleted in the same transaction
725:+      //                         is verified; deleted only by manager+ and only while unverified.
738:+        return exists(path) && get(path).data.get('spring-2026', {}).get('verified', false) == true;
833:+// 1 MiB cap on Sep 29 2026. Spring 2026 moves to curriculum/lessons_spring-2026 in one
835:+// move (delete only) and its rollback (re-add only, while unverified, target deleted in the
837:+// manager, edited only once storageMigrations says the move is verified, and deleted only by a
875:+    tx.set(doc(db, 'curriculum', MIGRATIONS), { [SPRING]: { lessonCount: Object.keys(map).length, sha256: 'h', verified: false } }, { merge: true });
945:+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: { verified: true } }, { merge: true }));
948:+    await testEnv.withSecurityRulesDisabled(async (ctx) => { await setDoc(doc(ctx.firestore(), 'curriculum', MIGRATIONS), { [SPRING]: { verified: false } }); });
953:+describe('Classbook storage move — moved, NOT yet verified (edits paused; rollback allowed)', () => {
954:+  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: false } } }));
980:+  test.each(MANAGER_ROLES)('%s can mark the move verified', async (_l, uid) => {
981:+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
983:+  test.each(MANAGER_ROLES)('%s CANNOT create lessons_spring-2026 again while it exists (set over it is an update, refused while unverified)', async (_l, uid) => {
988:+describe('Classbook storage move — moved AND verified (edits back on; no delete, no rollback)', () => {
989:+  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: true } } }));
1037:+// A near-1 MiB lessonData (how production looked on Sep 29 2026): prove the fence evaluates on a
1039:+describe('Classbook storage move — fence on a near-1 MiB lessonData', () => {
1064:+  test('the fixture really is near the cap (≈ 0.9–1.0 MiB estimated)', () => {
1126:    // email/password account's address is unverified, so the kiosk's email clause is deliberately not
1205:      // blocking a self-create from injecting any value outside the two
1601:    50	    // email/password account's address is unverified, so the kiosk's email clause is deliberately not
1680:   129	      // blocking a self-create from injecting any value outside the two
1758:   656	      // Firestore's 1 MiB cap. Spring 2026 moves to curriculum/lessons_spring-2026 in one manager
1763:   661	      //                         unverified AND the new doc is deleted in the same transaction
1766:   664	      //                         is verified; deleted only by manager+ and only while unverified.
1779:   677	        return exists(path) && get(path).data.get('spring-2026', {}).get('verified', false) == true;
1871:   108	<p><strong>Acceptance:</strong> in production (no <code>lessons_spring-2026</code> yet), everything behaves as today, and Spring is view-only ("editing is paused while Spring 2026 moves to new storage"). In the emulator, with Spring moved and verified, Spring works end to end, and Fall and every other semester are untouched. This is one Classbook deploy (one Netlify credit) plus one Studio Hub deploy.</p>
1881:   118	  <li><strong>Writes to Spring:</strong> they go to <code>lessons_K</code> only when <code>storageMigrations.spring-2026.verified</code> is true, read by a small <code>storageMigrations</code> listener. Otherwise the app shows the "editing is paused" message; the rules refuse those writes anyway. <code>not-found</code> is handled the same way.</li>
1892:   129	Scenario: Spring moved and verified works end to end (emulator)
1896:   133	Scenario: moved but not yet verified — edits paused
1897:   134	  Given lessons_spring-2026 exists, verified false
1925:   162	      <li><code>tx.set(storageMigrations, { 'spring-2026': { movedAt, movedBy, lessonCount, sha256, verified: false } }, { merge: true })</code></li>
1929:   166	  <li><strong>If verification passes:</strong> <code>storageMigrations.spring-2026.verified = true</code>, and Spring becomes editable. Spot-check one Spring lesson in the Firebase Console.</li>
1930:   167	  <li><strong>If it fails:</strong> nothing has been edited since the copy, so the reverse transaction is safe: it puts <code>map</code> back into <code>lessonData</code>, which Phase A's rollback allowance permits (a manager/admin, only this key, only while unverified, and only together with deleting <code>lessons_spring-2026</code>), deletes <code>lessons_spring-2026</code>, and records the failure. The download from step 1 remains the last resort.</li>
1933:   170	  Then lessons_spring-2026 deep-equals the old map (+ lastUpdated*), lessonData has no spring-2026, storageMigrations records count + hash, verified → true, Spring editable, Fall untouched
1957:    14	+      // Firestore's 1 MiB cap. Spring 2026 moves to curriculum/lessons_spring-2026 in one manager
1962:    19	+      //                         unverified AND the new doc is deleted in the same transaction
1965:    22	+      //                         is verified; deleted only by manager+ and only while unverified.
1978:    35	+        return exists(path) && get(path).data.get('spring-2026', {}).get('verified', false) == true;
2073:   130	+// 1 MiB cap on Sep 29 2026. Spring 2026 moves to curriculum/lessons_spring-2026 in one
2075:   132	+// move (delete only) and its rollback (re-add only, while unverified, target deleted in the
2077:   134	+// manager, edited only once storageMigrations says the move is verified, and deleted only by a
2115:   172	+    tx.set(doc(db, 'curriculum', MIGRATIONS), { [SPRING]: { lessonCount: Object.keys(map).length, sha256: 'h', verified: false } }, { merge: true });
2185:   242	+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: { verified: true } }, { merge: true }));
2188:   245	+    await testEnv.withSecurityRulesDisabled(async (ctx) => { await setDoc(doc(ctx.firestore(), 'curriculum', MIGRATIONS), { [SPRING]: { verified: false } }); });
2193:   250	+describe('Classbook storage move — moved, NOT yet verified (edits paused; rollback allowed)', () => {
2194:   251	+  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: false } } }));
2220:   277	+  test.each(MANAGER_ROLES)('%s can mark the move verified', async (_l, uid) => {
2221:   278	+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
2223:   280	+  test.each(MANAGER_ROLES)('%s CANNOT create lessons_spring-2026 again while it exists (set over it is an update, refused while unverified)', async (_l, uid) => {
2228:   285	+describe('Classbook storage move — moved AND verified (edits back on; no delete, no rollback)', () => {
2229:   286	+  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: true } } }));
2277:   334	+// A near-1 MiB lessonData (how production looked on Sep 29 2026): prove the fence evaluates on a
2279:   336	+describe('Classbook storage move — fence on a near-1 MiB lessonData', () => {
2304:   361	+  test('the fixture really is near the cap (≈ 0.9–1.0 MiB estimated)', () => {
2319:The central fence structure matches the plan’s intended split, but I’m now tracing two higher-risk areas: whether “verified” can be reversed to reopen rollback/delete, and whether every real SDK write shape produces only the intended top-level affected key.
2336:    14	+      // Firestore's 1 MiB cap. Spring 2026 moves to curriculum/lessons_spring-2026 in one manager
2341:    19	+      //                         unverified AND the new doc is deleted in the same transaction
2344:    22	+      //                         is verified; deleted only by manager+ and only while unverified.
2357:    35	+        return exists(path) && get(path).data.get('spring-2026', {}).get('verified', false) == true;
2452:   130	+// 1 MiB cap on Sep 29 2026. Spring 2026 moves to curriculum/lessons_spring-2026 in one
2596:  2593	// 1 MiB cap on Sep 29 2026. Spring 2026 moves to curriculum/lessons_spring-2026 in one
2598:  2595	// move (delete only) and its rollback (re-add only, while unverified, target deleted in the
2600:  2597	// manager, edited only once storageMigrations says the move is verified, and deleted only by a
2638:  2635	    tx.set(doc(db, 'curriculum', MIGRATIONS), { [SPRING]: { lessonCount: Object.keys(map).length, sha256: 'h', verified: false } }, { merge: true });
2708:  2705	    await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: { verified: true } }, { merge: true }));
2711:  2708	    await testEnv.withSecurityRulesDisabled(async (ctx) => { await setDoc(doc(ctx.firestore(), 'curriculum', MIGRATIONS), { [SPRING]: { verified: false } }); });
2716:  2713	describe('Classbook storage move — moved, NOT yet verified (edits paused; rollback allowed)', () => {
2717:  2714	  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: false } } }));
2743:  2740	  test.each(MANAGER_ROLES)('%s can mark the move verified', async (_l, uid) => {
2744:  2741	    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
2746:  2743	  test.each(MANAGER_ROLES)('%s CANNOT create lessons_spring-2026 again while it exists (set over it is an update, refused while unverified)', async (_l, uid) => {
2751:  2748	describe('Classbook storage move — moved AND verified (edits back on; no delete, no rollback)', () => {
2752:  2749	  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: true } } }));
2800:  2797	// A near-1 MiB lessonData (how production looked on Sep 29 2026): prove the fence evaluates on a
2802:  2799	describe('Classbook storage move — fence on a near-1 MiB lessonData', () => {
2827:  2824	  test('the fixture really is near the cap (≈ 0.9–1.0 MiB estimated)', () => {
3091:   969	// (null when absent). Bypasses both the in-memory model and the SDK cache —
3139:  1346	  console.log('✅ Save verified on server:', writtenContentFields);
3840:   969	// (null when absent). Bypasses both the in-memory model and the SDK cache —
3888:  1346	  console.log('✅ Save verified on server:', writtenContentFields);
4118:  2705	    await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: { verified: true } }, { merge: true }));
4121:  2708	    await testEnv.withSecurityRulesDisabled(async (ctx) => { await setDoc(doc(ctx.firestore(), 'curriculum', MIGRATIONS), { [SPRING]: { verified: false } }); });
4126:  2713	describe('Classbook storage move — moved, NOT yet verified (edits paused; rollback allowed)', () => {
4127:  2714	  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: false } } }));
4153:  2740	  test.each(MANAGER_ROLES)('%s can mark the move verified', async (_l, uid) => {
4154:  2741	    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
4156:  2743	  test.each(MANAGER_ROLES)('%s CANNOT create lessons_spring-2026 again while it exists (set over it is an update, refused while unverified)', async (_l, uid) => {
4161:  2748	describe('Classbook storage move — moved AND verified (edits back on; no delete, no rollback)', () => {
4162:  2749	  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: true } } }));
4210:  2797	// A near-1 MiB lessonData (how production looked on Sep 29 2026): prove the fence evaluates on a
4212:  2799	describe('Classbook storage move — fence on a near-1 MiB lessonData', () => {
4237:  2824	  test('the fixture really is near the cap (≈ 0.9–1.0 MiB estimated)', () => {
4351:    77	  <li>No role can create, add to, or change the <code>spring-2026</code> key, with exactly two manager/admin exceptions. (1) An update that <em>only deletes</em> it, for the Phase C transaction. (2) The <strong>rollback</strong>: an update that <em>only re-adds</em> it, allowed only while <code>storageMigrations.spring-2026.verified != true</code> and only if <code>getAfter(lessons_spring-2026)</code> shows that document deleted in the same transaction (Codex round 2, fix 1).</li>
4355:    81	<p>For <code>curriculum/lessons_spring-2026</code>: create by a manager only, and only if it doesn't exist. Updates only when <code>storageMigrations.spring-2026.verified == true</code>, for the roles that can update lessons today. Whole-doc delete by <strong>manager/admin only, and only while not yet verified</strong> (the rollback). classbook-admin and curriculum-admin may never delete it, and <strong>nobody</strong> may delete it after verification, until the follow-up plan adds a routed delete/archive (Codex round 2, fix 2).</p>
4358:    84	<p><strong>Shape:</strong> split <code>:654</code> (<code>allow read, write: if isManagerOrAbove()</code>) into <code>read</code> / <code>create</code> / <code>update</code> / <code>delete</code> statements, because rules OR across statements. Manager <code>delete</code> is kept for every curriculum doc except <code>lessonData</code>. The classbook-role statements at <code>:666</code> and <code>:675-678</code> get the same <code>lessonData</code>/<code>lessons_spring-2026</code> conditions. The <code>lessonData</code> update condition is <code>!affectedKeys().hasAny(['spring-2026'])</code>, OR (manager/admin, removal) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; !('spring-2026' in request.resource.data)</code>, OR (manager/admin, <strong>rollback re-add</strong>) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; ('spring-2026' in request.resource.data) &amp;&amp; !('spring-2026' in resource.data) &amp;&amp; !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026) &amp;&amp; get(/databases/$(database)/documents/curriculum/storageMigrations).data.get('spring-2026', {}).get('verified', false) != true</code>. Every split statement is constrained this way, because <code>allow</code> statements OR together.</p>
4367:    93	  rollback: manager/admin re-adds only spring-2026 AND deletes lessons_spring-2026 in one transaction, while unverified → allowed
4368:    94	  the same rollback after verified                                  → denied
4371:    97	  lessons_spring-2026 update before verified                        → denied (every role); after verified → allowed as for lessons today
4372:    98	  lessons_spring-2026 delete before verified                        → manager/admin allowed (rollback); teacher/classbook-admin/curriculum-admin denied
4373:    99	  lessons_spring-2026 delete after verified                         → denied (every role)
4828:/bin/zsh -lc "rg -n \"verified|storageMigrations|rollback|Phase C\" /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html | sed -n '1,180p'; rg -n \"lessonData.*(set|update)|lessonsRef|curriculumRef\" /Users/christiehubley/studio-hub --glob '"'!**/node_modules/**'"' --glob '*.{js,html}'" in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
4831:44:<h2 id="today">What exists today (research, verified in review round 1)</h2>
4832:68:  <li><strong>Spring edits stay paused, enforced by the rules, until the move is verified.</strong> A rule on <code>curriculum/lessons_spring-2026</code> allows updates only when <code>curriculum/storageMigrations</code> has <code>spring-2026.verified == true</code> (a <code>get()</code> on Spring writes only; Spring is dormant, so the cost is negligible). So nothing can change the new document between the copy and the verification: its hash is stable, and a rollback can't discard a real edit.</li>
4833:77:  <li>No role can create, add to, or change the <code>spring-2026</code> key, with exactly two manager/admin exceptions. (1) An update that <em>only deletes</em> it, for the Phase C transaction. (2) The <strong>rollback</strong>: an update that <em>only re-adds</em> it, allowed only while <code>storageMigrations.spring-2026.verified != true</code> and only if <code>getAfter(lessons_spring-2026)</code> shows that document deleted in the same transaction (Codex round 2, fix 1).</li>
4834:81:<p>For <code>curriculum/lessons_spring-2026</code>: create by a manager only, and only if it doesn't exist. Updates only when <code>storageMigrations.spring-2026.verified == true</code>, for the roles that can update lessons today. Whole-doc delete by <strong>manager/admin only, and only while not yet verified</strong> (the rollback). classbook-admin and curriculum-admin may never delete it, and <strong>nobody</strong> may delete it after verification, until the follow-up plan adds a routed delete/archive (Codex round 2, fix 2).</p>
4836:84:<p><strong>Shape:</strong> split <code>:654</code> (<code>allow read, write: if isManagerOrAbove()</code>) into <code>read</code> / <code>create</code> / <code>update</code> / <code>delete</code> statements, because rules OR across statements. Manager <code>delete</code> is kept for every curriculum doc except <code>lessonData</code>. The classbook-role statements at <code>:666</code> and <code>:675-678</code> get the same <code>lessonData</code>/<code>lessons_spring-2026</code> conditions. The <code>lessonData</code> update condition is <code>!affectedKeys().hasAny(['spring-2026'])</code>, OR (manager/admin, removal) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; !('spring-2026' in request.resource.data)</code>, OR (manager/admin, <strong>rollback re-add</strong>) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; ('spring-2026' in request.resource.data) &amp;&amp; !('spring-2026' in resource.data) &amp;&amp; !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026) &amp;&amp; get(/databases/$(database)/documents/curriculum/storageMigrations).data.get('spring-2026', {}).get('verified', false) != true</code>. Every split statement is constrained this way, because <code>allow</code> statements OR together.</p>
4837:93:  rollback: manager/admin re-adds only spring-2026 AND deletes lessons_spring-2026 in one transaction, while unverified → allowed
4838:94:  the same rollback after verified                                  → denied
4839:97:  lessons_spring-2026 update before verified                        → denied (every role); after verified → allowed as for lessons today
4840:98:  lessons_spring-2026 delete before verified                        → manager/admin allowed (rollback); teacher/classbook-admin/curriculum-admin denied
4841:99:  lessons_spring-2026 delete after verified                         → denied (every role)
4843:108:<p><strong>Acceptance:</strong> in production (no <code>lessons_spring-2026</code> yet), everything behaves as today, and Spring is view-only ("editing is paused while Spring 2026 moves to new storage"). In the emulator, with Spring moved and verified, Spring works end to end, and Fall and every other semester are untouched. This is one Classbook deploy (one Netlify credit) plus one Studio Hub deploy.</p>
4845:118:  <li><strong>Writes to Spring:</strong> they go to <code>lessons_K</code> only when <code>storageMigrations.spring-2026.verified</code> is true, read by a small <code>storageMigrations</code> listener. Otherwise the app shows the "editing is paused" message; the rules refuse those writes anyway. <code>not-found</code> is handled the same way.</li>
4848:129:Scenario: Spring moved and verified works end to end (emulator)
4849:133:Scenario: moved but not yet verified — edits paused
4850:134:  Given lessons_spring-2026 exists, verified false
4854:162:      <li><code>tx.set(storageMigrations, { 'spring-2026': { movedAt, movedBy, lessonCount, sha256, verified: false } }, { merge: true })</code></li>
4855:166:  <li><strong>If verification passes:</strong> <code>storageMigrations.spring-2026.verified = true</code>, and Spring becomes editable. Spot-check one Spring lesson in the Firebase Console.</li>
4856:167:  <li><strong>If it fails:</strong> nothing has been edited since the copy, so the reverse transaction is safe: it puts <code>map</code> back into <code>lessonData</code>, which Phase A's rollback allowance permits (a manager/admin, only this key, only while unverified, and only together with deleting <code>lessons_spring-2026</code>), deletes <code>lessons_spring-2026</code>, and records the failure. The download from step 1 remains the last resort.</li>
4857:170:  Then lessons_spring-2026 deep-equals the old map (+ lastUpdated*), lessonData has no spring-2026, storageMigrations records count + hash, verified → true, Spring editable, Fall untouched
4862:194:  <li><strong>Reversible:</strong> a reverse transaction until verified. After that, the download and backups.</li>
4863:203:  <li><strong>Mid-C:</strong> the transaction either committed or didn't. If it committed but isn't verified, Spring is viewable, edits are paused, and the reverse transaction exists.</li>
4866:220:    <li>The rollback re-add is explicitly allowed for manager/admin, only while unverified and only with <code>lessons_spring-2026</code> deleted in the same transaction (<code>getAfter</code>). This replaces the test that contradicted it.</li>
4867:221:    <li>Deleting the new document is manager/admin-only and only while unverified. Other roles are always denied, and everyone is denied after verification until the follow-up plan.</li>
4868:226:  <strong>Sep 29, 2026: revision 3, after Codex's independent round 1 (<code>…-codex-r1.md</code>): NOT ready, 8-point minimum list, all verified and taken.</strong>
4869:228:    <li>Adopted Codex's "simpler safe option": the copy and the old-copy removal are <strong>one transaction</strong>, with Spring edits paused by rule until the move is verified. That closes the verification/rollback race (1), the target-missing-at-delete risk (2) and double counting (5), since there's no dual-copy window, and Phases C and D merge.</li>
4889:## Verdict: NOT SAFE TO MERGE OR DEPLOY
4893:### Blocking findings
4903:If a manager first deletes `lessons_spring-2026` while unverified—which is explicitly allowed—then a later standalone update can re-add any `spring-2026` map to `lessonData`. Because the target was already absent, `!existsAfter()` succeeds without any same-transaction deletion.
4917:[`storageMigrations`](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/firestore.rules:751) permits managers to modify the migration record without preserving `spring-2026.verified == true`.
4921:- set `verified` back to `false`;
4922:- delete the `verified` field;
4928:Minimum fix: make `verified: true` irreversible at the rules layer. Ideally, also require the target to exist and legacy Spring to be absent when transitioning from false to true. Add tests for false assignment, field deletion, entry removal, and whole-map replacement after verification, followed by delete/rollback attempts.
4930:## Other conclusions
4943:- Near 1 MiB, the rules add no size-dependent reads or iteration. They cannot prevent Firestore’s document-size limit itself: any Fall or Q&A write that pushes the resulting document over 1 MiB will still fail.
4946:  - verified target update/delete: user plus migration document;
4948:  Repeated reads of the same path are cacheable. The near-1 MiB document is `resource`/`request.resource`, not an additional `get()`.
4950:## Test assessment
4952:The new tests exercise most happy paths and common denials, including a useful large-document fixture. However, they would pass both blocking defects:
4955:- The verified tests never try to downgrade or remove the verification marker before deleting or rolling back.
4962:## Verdict: NOT SAFE TO MERGE OR DEPLOY
4966:### Blocking findings
4976:If a manager first deletes `lessons_spring-2026` while unverified—which is explicitly allowed—then a later standalone update can re-add any `spring-2026` map to `lessonData`. Because the target was already absent, `!existsAfter()` succeeds without any same-transaction deletion.
4990:[`storageMigrations`](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/firestore.rules:751) permits managers to modify the migration record without preserving `spring-2026.verified == true`.
4994:- set `verified` back to `false`;
4995:- delete the `verified` field;
5001:Minimum fix: make `verified: true` irreversible at the rules layer. Ideally, also require the target to exist and legacy Spring to be absent when transitioning from false to true. Add tests for false assignment, field deletion, entry removal, and whole-map replacement after verification, followed by delete/rollback attempts.
5003:## Other conclusions
5016:- Near 1 MiB, the rules add no size-dependent reads or iteration. They cannot prevent Firestore’s document-size limit itself: any Fall or Q&A write that pushes the resulting document over 1 MiB will still fail.
5019:  - verified target update/delete: user plus migration document;
5021:  Repeated reads of the same path are cacheable. The near-1 MiB document is `resource`/`request.resource`, not an additional `get()`.
5023:## Test assessment
5025:The new tests exercise most happy paths and common denials, including a useful large-document fixture. However, they would pass both blocking defects:
5028:- The verified tests never try to downgrade or remove the verification marker before deleting or rolling back.
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
   754	      // would reopen delete/rollback). It may become true only when lessons_spring-2026 exists and
   755	      // lessonData no longer holds 'spring-2026'. No role deletes the record.
   756	      function springVerifiedIn(data) {
   757	        return data.get('spring-2026', {}).get('verified', false) == true;
   758	      }
   759	      function springVerifyTransitionOk() {
   760	        return !springVerifiedIn(request.resource.data)
   761	          || (exists(/databases/$(database)/documents/curriculum/lessons_spring-2026)
   762	              && !('spring-2026' in get(/databases/$(database)/documents/curriculum/lessonData).data));
   763	      }
   764	      allow create: if docId == 'storageMigrations'
   765	        && isManagerOrAbove()
   766	        && springVerifyTransitionOk();
   767	      allow update: if docId == 'storageMigrations'
   768	        && isManagerOrAbove()
   769	        && (springVerifiedIn(resource.data)
   770	              ? springVerifiedIn(request.resource.data)
   771	              : springVerifyTransitionOk());
   772	    }
   773	
   774	    // ═══════════════════════════════════════════════════════════════
   775	    // CLASSBOOK — SCHOOL DAY OFF CAMPS (SDOCs)
   776	    // Plan: tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html (Phase 1, §1.1)
   777	    //   dayOffCamps_events / dayOffCamps_camps: the admin's planning list for a school year.
   778	    //     classbook-admin (+ manager+) write, plain classbook teachers read.
   779	    //   dayOffCamps_lessonData: one shared plan per camp-project. Teachers create/update like
   780	    //     summerCamps_lessonData (per-teacher isolation is UI-enforced — the same accepted gap as
   781	    //     summer); whole-document delete is admin-only, like /curriculum's delete clause.
   782	    //   The legacy 'curriculum-admin' key is deliberately NOT extended to these new collections.
   783	    //   Visibility of an unpublished year is UI gating only: every classbook teacher can read these.
   784	    // ═══════════════════════════════════════════════════════════════
   785	
   786	    match /dayOffCamps_events/{docId} {
   787	      allow read: if isManagerOrAbove() || hasAppAccess('classbook') || hasAppAccess('classbook-admin');
   788	      allow create, update, delete: if isManagerOrAbove() || hasAppAccess('classbook-admin');
   789	    }
   790	
1:diff --git a/firestore.rules b/firestore.rules
5:@@ -650,8 +650,54 @@ service cloud.firestore {
19:+      //                         unverified AND the new doc is deleted in the same transaction
21:+      //   lessons_spring-2026 — created by manager+; edited only once storageMigrations says the move
22:+      //                         is verified; deleted only by manager+ and only while unverified.
23:+      //   storageMigrations   — manager+ writes; classbook roles read.
31:+        return docId in ['lessonData', 'lessons_spring-2026', 'storageMigrations'];
33:+      function springMoveVerified() {
34:+        let path = /databases/$(database)/documents/curriculum/storageMigrations;
35:+        return exists(path) && get(path).data.get('spring-2026', {}).get('verified', false) == true;
53:+          && !springMoveVerified();
62:@@ -662,24 +708,67 @@ service cloud.firestore {
108:+        && springMoveVerified();
111:+        && !springMoveVerified();
113:+      // storageMigrations: the move's record (manager+ writes; read via the read lines above).
114:+      // 'verified' is one-way: once true it can never be turned off, removed or replaced (that
118:+        return data.get('spring-2026', {}).get('verified', false) == true;
120:+      function springVerifyTransitionOk() {
125:+      allow create: if docId == 'storageMigrations'
127:+        && springVerifyTransitionOk();
128:+      allow update: if docId == 'storageMigrations'
132:+              : springVerifyTransitionOk());
136:diff --git a/rules.test.js b/rules.test.js
140:@@ -2585,3 +2585,300 @@ describe('Clay Hub Membership — the database protects memberId and freezes ret
151:+// move (delete only) and its rollback (re-add only, while unverified, target deleted in the
153:+// manager, edited only once storageMigrations says the move is verified, and deleted only by a
158:+const MIGRATIONS = 'storageMigrations';
191:+    tx.set(doc(db, 'curriculum', MIGRATIONS), { [SPRING]: { lessonCount: Object.keys(map).length, sha256: 'h', verified: false } }, { merge: true });
260:+  test.each(NON_MANAGER_ROLES)('%s CANNOT write storageMigrations', async (_l, uid) => {
261:+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: { verified: true } }, { merge: true }));
263:+  test.each(FENCE_ROLES)('%s can read storageMigrations once it exists', async (_l, uid) => {
264:+    await testEnv.withSecurityRulesDisabled(async (ctx) => { await setDoc(doc(ctx.firestore(), 'curriculum', MIGRATIONS), { [SPRING]: { verified: false } }); });
269:+describe('Classbook storage move — moved, NOT yet verified (edits paused; rollback allowed)', () => {
270:+  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: false } } }));
296:+  test.each(MANAGER_ROLES)('%s can mark the move verified', async (_l, uid) => {
297:+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
299:+  test.each(MANAGER_ROLES)('%s CANNOT create lessons_spring-2026 again while it exists (set over it is an update, refused while unverified)', async (_l, uid) => {
304:+describe('Classbook storage move — moved AND verified (edits back on; no delete, no rollback)', () => {
305:+  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: true } } }));
353:+// A near-1 MiB lessonData (how production looked on Sep 29 2026): prove the fence evaluates on a
355:+describe('Classbook storage move — fence on a near-1 MiB lessonData', () => {
395:+// transaction (not merely find it absent), and "verified" can never be switched back off.
396:+describe('Classbook storage move — review fixes (rollback needs the target; verified is one-way)', () => {
398:+    await resetStorageMoveFixtures({ spring: false, target: null, migrations: { [SPRING]: { verified: false } } });
407:+    beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: true, sha256: 'h' } } }));
408:+    test.each(MANAGER_ROLES)('%s CANNOT set verified back to false', async (_l, uid) => {
409:+      await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: false }));
411:+    test.each(MANAGER_ROLES)('%s CANNOT delete the verified field', async (_l, uid) => {
412:+      await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: deleteField() }));
423:+    test.each(MANAGER_ROLES)('%s can still add other fields to the record (verified stays true)', async (_l, uid) => {
428:+  test.each(MANAGER_ROLES)('%s CANNOT mark verified while lessons_spring-2026 does not exist', async (_l, uid) => {
429:+    await resetStorageMoveFixtures({ spring: false, target: null, migrations: { [SPRING]: { verified: false } } });
430:+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
432:+  test.each(MANAGER_ROLES)('%s CANNOT mark verified while spring-2026 is still in lessonData', async (_l, uid) => {
433:+    await resetStorageMoveFixtures({ spring: true, target: { ...springMap() }, migrations: { [SPRING]: { verified: false } } });
434:+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
436:+  test.each(MANAGER_ROLES)('%s CANNOT create the record already verified before the move', async (_l, uid) => {
438:+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: { verified: true } }));

codex
Both prior blockers are addressed in the rule shape. I’m checking whether the new verification guard creates a rules-limit issue or leaves a cross-request state transition that can reopen rollback.
exec
/bin/zsh -lc "sed -n '4880,4960p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA-codex.md && nl -ba rules.test.js | sed -n '2825,2915p' && sed -n '500,625p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html 2>/dev/null || true && rg -n \"getAfter|existsAfter|one transaction|only delete|verified|Phase A|storageMigrations\" /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html | head -80" in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
 succeeded in 0ms:
/Users/christiehubley/studio-hub/test-alerts-browser.html:227:        const curriculumRef = db.collection('curriculum').doc('lessonData');
/Users/christiehubley/studio-hub/test-alerts-browser.html:228:        const doc = await curriculumRef.get();
/Users/christiehubley/studio-hub/test-alerts-browser.html:246:        await curriculumRef.set({ qaData }, { merge: true });
/Users/christiehubley/studio-hub/test-alerts-browser.html:278:        const curriculumRef = db.collection('curriculum').doc('lessonData');
/Users/christiehubley/studio-hub/test-alerts-browser.html:279:        const doc = await curriculumRef.get();
/Users/christiehubley/studio-hub/test-alerts-browser.html:288:            await curriculumRef.update({ qaData });
/Users/christiehubley/studio-hub/rules.test.js:2186:// plans (dayOffCamps_lessonData) are teacher create/update like summerCamps_lessonData, admin-only

codex
## Verdict: NOT SAFE TO MERGE OR DEPLOY

Two rule defects violate Phase A’s safety guarantees.

### Blocking findings

1. Rollback does not require the target to exist before the atomic operation.

[`springKeyRolledBack()`](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/firestore.rules:689) checks only:

```rules
!existsAfter(.../lessons_spring-2026)
```

If a manager first deletes `lessons_spring-2026` while unverified—which is explicitly allowed—then a later standalone update can re-add any `spring-2026` map to `lessonData`. Because the target was already absent, `!existsAfter()` succeeds without any same-transaction deletion.

That contradicts the acceptance requirement that rollback be allowed only when the target “is deleted in the same transaction” ([plan line 77](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:77)).

Minimum fix: require both pre- and post-state:

```rules
exists(targetPath) && !existsAfter(targetPath)
```

Add a failing test where both Spring copies are absent and a manager attempts a standalone re-add.

2. Verification can be reversed, reopening delete and rollback after verification.

[`storageMigrations`](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/firestore.rules:751) permits managers to modify the migration record without preserving `spring-2026.verified == true`.

After verification, a manager can:

- set `verified` back to `false`;
- delete the `verified` field;
- remove or replace the entire `spring-2026` migration entry;
- then delete `lessons_spring-2026` and use the rollback branch.

This defeats the stated guarantee that nobody may delete or roll back after verification ([plan lines 81 and 94–99](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html:81)).

Minimum fix: make `verified: true` irreversible at the rules layer. Ideally, also require the target to exist and legacy Spring to be absent when transitioning from false to true. Add tests for false assignment, field deletion, entry removal, and whole-map replacement after verification, followed by delete/rollback attempts.

## Other conclusions

- Other `/curriculum` documents retain the old authorization logic. I found no new grant for managers, admins, the three Classbook access keys, no-access staff, archived users, kiosks, or the reminder bot. The existing broad Classbook read of `appData` remains broad—it is not newly introduced.
- The post-write `diff(...).affectedKeys()` fence correctly covers update, full set, merge-set, batch/transaction writes, nested dotted paths, and map-valued `spring-2026`. A literal top-level field whose name contains a dot would not modify the protected Spring map.
- A batch satisfies the same atomic property as a transaction; that is not a bypass.
- Current non-Spring Classbook writes remain authorized:
  - `saveSingleLesson`
  - `saveMultipleLessonFields`
  - `saveLessonData` merge-set
  - `deleteLessonKey`
  - teacher/admin Q&A replies
  - Studio Hub’s top-level `qaData` test writes
- Current Spring writes are intentionally denied until Phase B/C routing and verification.
- Near 1 MiB, the rules add no size-dependent reads or iteration. They cannot prevent Firestore’s document-size limit itself: any Fall or Q&A write that pushes the resulting document over 1 MiB will still fail.
- Access cost is comfortably within limits:
  - ordinary curriculum operations: one distinct `users/{uid}` lookup;
  - verified target update/delete: user plus migration document;
  - rollback: user, target, and migration documents.
  Repeated reads of the same path are cacheable. The near-1 MiB document is `resource`/`request.resource`, not an additional `get()`.

## Test assessment

The new tests exercise most happy paths and common denials, including a useful large-document fixture. However, they would pass both blocking defects:

- [`runRollback(..., {deleteTarget:false})`](/Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence/rules.test.js:2728) is tested only while the target currently exists.
- The verified tests never try to downgrade or remove the verification marker before deleting or rolling back.
- The “every other curriculum doc” coverage is a sample, not the promised every-operation/every-role matrix; archived Classbook users, kiosk, reminder bot, unauthenticated users, and ordinary-document create/read/delete combinations are not covered here.
- There are no explicit merge-set/merge-field Spring mutation cases, although the post-image rule logic appears sound.

No files were edited and no tests were run, as requested.
tokens used
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
44:<h2 id="today">What exists today (research, verified in review round 1)</h2>
67:  <li><strong>One-step move (Codex round 1, "simpler safe option"):</strong> Spring's copy and the removal of its old copy happen <em>in one transaction</em>. There's never a multi-day period with two copies, so nothing is double-counted, and the old copy can't be deleted while the new one is missing.</li>
68:  <li><strong>Spring edits stay paused, enforced by the rules, until the move is verified.</strong> A rule on <code>curriculum/lessons_spring-2026</code> allows updates only when <code>curriculum/storageMigrations</code> has <code>spring-2026.verified == true</code> (a <code>get()</code> on Spring writes only; Spring is dormant, so the cost is negligible). So nothing can change the new document between the copy and the verification: its hash is stable, and a rollback can't discard a real edit.</li>
74:<h3>Phase A: rules that protect Spring during and after the move <span class="status-tag ready">execution-ready: true</span></h3>
77:  <li>No role can create, add to, or change the <code>spring-2026</code> key, with exactly two manager/admin exceptions. (1) An update that <em>only deletes</em> it, for the Phase C transaction. (2) The <strong>rollback</strong>: an update that <em>only re-adds</em> it, allowed only while <code>storageMigrations.spring-2026.verified != true</code> and only if <code>getAfter(lessons_spring-2026)</code> shows that document deleted in the same transaction (Codex round 2, fix 1).</li>
81:<p>For <code>curriculum/lessons_spring-2026</code>: create by a manager only, and only if it doesn't exist. Updates only when <code>storageMigrations.spring-2026.verified == true</code>, for the roles that can update lessons today. Whole-doc delete by <strong>manager/admin only, and only while not yet verified</strong> (the rollback). classbook-admin and curriculum-admin may never delete it, and <strong>nobody</strong> may delete it after verification, until the follow-up plan adds a routed delete/archive (Codex round 2, fix 2).</p>
82:<p>For <code>curriculum/storageMigrations</code>: manager write, and read for the classbook roles.</p>
84:<p><strong>Shape:</strong> split <code>:654</code> (<code>allow read, write: if isManagerOrAbove()</code>) into <code>read</code> / <code>create</code> / <code>update</code> / <code>delete</code> statements, because rules OR across statements. Manager <code>delete</code> is kept for every curriculum doc except <code>lessonData</code>. The classbook-role statements at <code>:666</code> and <code>:675-678</code> get the same <code>lessonData</code>/<code>lessons_spring-2026</code> conditions. The <code>lessonData</code> update condition is <code>!affectedKeys().hasAny(['spring-2026'])</code>, OR (manager/admin, removal) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; !('spring-2026' in request.resource.data)</code>, OR (manager/admin, <strong>rollback re-add</strong>) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; ('spring-2026' in request.resource.data) &amp;&amp; !('spring-2026' in resource.data) &amp;&amp; !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026) &amp;&amp; get(/databases/$(database)/documents/curriculum/storageMigrations).data.get('spring-2026', {}).get('verified', false) != true</code>. Every split statement is constrained this way, because <code>allow</code> statements OR together.</p>
93:  rollback: manager/admin re-adds only spring-2026 AND deletes lessons_spring-2026 in one transaction, while unverified → allowed
94:  the same rollback after verified                                  → denied
97:  lessons_spring-2026 update before verified                        → denied (every role); after verified → allowed as for lessons today
98:  lessons_spring-2026 delete before verified                        → manager/admin allowed (rollback); teacher/classbook-admin/curriculum-admin denied
99:  lessons_spring-2026 delete after verified                         → denied (every role)
100:  storageMigrations write                                           → manager/admin only; read → classbook roles
108:<p><strong>Acceptance:</strong> in production (no <code>lessons_spring-2026</code> yet), everything behaves as today, and Spring is view-only ("editing is paused while Spring 2026 moves to new storage"). In the emulator, with Spring moved and verified, Spring works end to end, and Fall and every other semester are untouched. This is one Classbook deploy (one Netlify credit) plus one Studio Hub deploy.</p>
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
