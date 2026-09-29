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
firestore.rules:690:        return lessonDataChangedKeys().hasOnly(['spring-2026'])
firestore.rules:693:          && !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
firestore.rules:731:      // lessonData: as before for every semester except 'spring-2026'; no whole-document delete.
firestore.rules:732:      allow create: if docId == 'lessonData'
firestore.rules:735:      allow update: if docId == 'lessonData'
firestore.rules:738:      allow update: if docId == 'lessonData'
firestore.rules:742:      // lessons_spring-2026: Spring 2026's lessons after the move.
firestore.rules:743:      allow create: if docId == 'lessons_spring-2026' && isManagerOrAbove();
firestore.rules:744:      allow update: if docId == 'lessons_spring-2026'
firestore.rules:747:      allow delete: if docId == 'lessons_spring-2026'
firestore.rules:751:      // storageMigrations: the move's record (manager+ writes; read via the read lines above).
firestore.rules:752:      allow create, update: if docId == 'storageMigrations' && isManagerOrAbove();
firestore.rules:760:    //   dayOffCamps_lessonData: one shared plan per camp-project. Teachers create/update like
firestore.rules:761:    //     summerCamps_lessonData (per-teacher isolation is UI-enforced — the same accepted gap as
firestore.rules:777:    match /dayOffCamps_lessonData/{docId} {
firestore.rules:816:    // curriculum, lessonData, projectDetails, projectLibrary, schedule:
firestore.rules:905:    match /summerCamps_curriculum/{docId} {
firestore.rules:910:    match /summerCamps_lessonData/{docId} {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:171:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:350:  document.getElementById('help-link')?.addEventListener('click', (e) => {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:352:    document.getElementById('help-modal').classList.add('open');
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:354:  document.getElementById('help-close')?.addEventListener('click', () => {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:355:    document.getElementById('help-modal').classList.remove('open');
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:668:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:1260:// ─── Teacher Q&A Activity Panel ──────────────────────
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:1265:  // No Q&A for SDOC plans (Christie, Sep 25) — never a card, even for a stray qaThread.
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:1279:  // Find all lessons for this teacher that have Q&A threads
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:1322:      <h4>Q&A Activity ${countLabel}</h4>
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:1359:        // Open modal to view Q&A
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:1381:            // Auto-expand details to show Q&A
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:1404:// ─── Q&A Viewer Modal ──────────────────────
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:1479:  // Q&A at the end
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:1481:    html += `<div class="tv-detail-section tv-qa-section"><h5>Q&A with Admin</h5>${renderQaThread(thread)}</div>`;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:1520:  // Build Q&A HTML
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:1523:    qaHtml = '<div class="sheet-section"><h3>Q&A with Admin</h3>';
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:1647:  // Always render progress dashboard and Q&A panel (Spring only)
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:1763:          const editable = canEditDayOffPlan(slot) && lessonDataLoadedSuccessfully !== false;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:1807:    const result = await saveSingleLesson(yearKey, lessonKey, { planComplete: requested }, [], { dayOffAuth: dayOffAuthFor(yearKey) });
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:1957:  // checkboxes instead. The unread-reply read stays non-fatal — it only feeds
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:1971:  // The Q&A read failed: say so, rather than rendering zero unread badges,
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:2029:    <div id="summer-qa-reply-banner"></div>
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:2070:      ? `<span class="qa-camp-unread-badge">💬 ${campUnreadCount} new ${campUnreadCount === 1 ? 'reply' : 'replies'}</span>`
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:2141:        ? `<span class="qa-project-unread-badge">💬 New reply</span>`
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:2359:        await saveSingleLesson(semKey, lessonKey, payload);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:2360:        // saveSingleLesson() stamps the payload it writes; keep the in-memory
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:2713:  // Q&A indicator badge
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:2719:      html += `<div class="tv-qa-badge tv-qa-badge-new">&#128172; Awaiting reply</div>`;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:2782:      html += `<div class="tv-detail-section tv-qa-section"><h5>Q&A with Admin</h5>${renderQaThread(qaThread)}</div>`;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:2843:        await saveSingleLesson(semKey, lessonKey, { planComplete: cb.checked });
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3026:        ${qaThread.length > 0 ? `<div class="tv-detail-section tv-qa-section"><h5>Q&A with Admin</h5>${renderQaThread(qaThread)}</div>` : ''}
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3182:        <!-- Q&A Section -->
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3184:          <div class="te-section-title">Q&A with Admin</div>
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3265:  // Q&A send handler
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3497:    // is now empty is an intentional clear — saveSingleLesson needs this list
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3507:    // saveSingleLesson's per-field dotted-path write always writes them
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3511:    // Backtracking audit Phase 10: the Q&A fields are written only by the
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3520:    await saveSingleLesson(semKey, lessonKey, writePayload, fieldsToClear);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3521:    // saveSingleLesson() stamps lastEditedBy/At onto the object it is given.
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3605:// Q&A thread from the modal's lesson object and hand the ENTIRE lesson to
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3606:// saveSingleLesson() — a full-lesson write from a possibly stale copy, which
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3609:// only this lesson's own Q&A paths, with arrayUnion() for the thread — the
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3611:// plus the lesson-level lastEditedBy/lastEditedAt saveSingleLesson() used to
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3614:// update under the wrong semester would create a Q&A-only ghost lesson there.
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3620:  // Same load-guard saveSingleLesson() enforced on the old path — after a
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3623:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3630:  // summer editor, whose Q&A lives in summerCamps_prepHelpQueue), so a write
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3631:  // under that key into curriculum/lessonData is never right. Routed by TYPE
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3648:  // recreate the old key as a Q&A-only ghost lesson. Same forced read and
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3690:    await curriculumDb.collection('curriculum').doc('lessonData').update(updates);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3692:    console.error('Error sending Q&A message:', err);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3723:// ─── Q&A Reply Notification Banner ───────────────
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3726:// lesson keys, so a bare key would mark 2027's reply read because the
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3761:    `<a class="qa-reply-banner-link" href="#" onclick="${item.openFn}; return false;">${escHtml(item.label)}</a>`
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3763:  return `<div class="qa-reply-banner">
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3764:    <span class="qa-reply-banner-icon">💬</span>
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3765:    <span class="qa-reply-banner-text">New ${items.length === 1 ? 'reply' : 'replies'} from admin:</span>
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3766:    <div class="qa-reply-banner-links">${links}</div>
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3792:// The prep-help queue, scoped to the Teacher View's season (Phase 1, 1.4).
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3831:  const bannerEl = document.getElementById('summer-qa-reply-banner');
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3851:    console.error('Error loading summer Q&A replies:', err);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3864:    console.error('Error loading summer Q&A:', err);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3865:    container.innerHTML = '<p style="color: var(--error); font-size: 13px;">Error loading Q&A.</p>';
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:3893:    console.error('Error sending summer Q&A message:', err);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4541:  // curriculum/lessonData, and no collection is ever cleared from here.
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4579:  // curriculum/lessonData to delete. A camp season's lessons live in the
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4611:    if (lessonDataLoadedSuccessfully === false) { alert('Lesson data failed to load — reload before publishing.'); renderSemesterSelector(); return; }
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4687:// curriculum/lessonData write.
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4814:// roster, no week grid, no lesson slots and no curriculum/lessonData write —
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4895:  let lessonDataCommitted = false;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4965:        await saveLessonData(key, emptyLessons);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4968:        lessonDataCommitted = true;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4975:    // existing residual on the Q&A path.
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4987:    if (lessonDataCommitted && currentLessonData) delete currentLessonData[key];
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:4992:    if (lessonDataCommitted) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5182:          tooltipHtml += `<div class="ca-tooltip-qa ${unanswered ? 'ca-tooltip-qa-needs' : 'ca-tooltip-qa-replied'}">${unanswered ? 'Q&A: Needs reply' : 'Q&A: Replied'}</div>`;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5305:    // Q&A with Admin (replaces old Teacher Notes / Admin Response)
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5368:// summerCamps_lessonData doc exists yet, so saveAdminEdit() skips the check
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5563:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5613:  // saveSingleLesson must apply with FieldValue.delete() rather than let the
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5633:  // summerCamps_lessonData doc exists (a missing doc means "never saved",
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5636:  // the doc. Same routing signal as saveSingleLesson() /
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5753:    await saveSingleLesson(semKey, key, firestorePayload, fieldsToClear);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5786:    lastEditedBy: firestorePayload.lastEditedBy,   // stamped by saveSingleLesson()
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5822:// Data Safety Plan Stage 2A/2B: shared helpers for the admin grid's move/swap
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5827:// Forced read of the shared curriculum/lessonData doc, bypassing the in-memory
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5835:  const snap = await curriculumDb.collection('curriculum').doc('lessonData').get(getOpts);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5844:// identical helper — bounded by human click-to-click timing, not a tight
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5851:      const snap = await curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key)).get({ source: 'server' });
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5915:    // cleared — saveSingleLesson omits empty fields from the write rather
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5943:      await saveMultipleLessonFields(
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:5945:        [{ lessonKey: newDestKey, lessonData: movedLesson, fieldsToClear: destFieldsToClear }],
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6016:          await saveMultipleLessonFields(semKey, [
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6017:            { lessonKey: sourceKeyForSwap, lessonData: swappedSource, fieldsToClear: sourceFieldsToClear },
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6018:            { lessonKey: newDestKey, lessonData: swappedDest, fieldsToClear: destFieldsToClearSwap }
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6037:          await saveMultipleLessonFields(semKey, [{ lessonKey: newDestKey, lessonData: movedLesson }], [sourceKeyForSwap]);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6145:// cached semester via saveLessonData() — any lesson whose local copy was stale
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6149:// had actually been written. Now: one targeted saveSingleLesson() per target
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6192:      // Send ONLY the copied fields (saveSingleLesson writes per-field paths
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6198:      await saveSingleLesson(semKey, targetKey, payload, targetFieldsToClear);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6262:// against curriculum/cutProjects (not saveCutProjects()'s local-splice-then-
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6320:    await deleteLessonKey(semKey, key);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6414:// saveLessonData() semester overwrite), removal via FieldValue.arrayRemove()
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6425:// Q&A thread from teacherNotes/adminResponse whenever qaThread is absent, so
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6465:    // silently reconstruct the original Q&A conversation from these alone).
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6470:  // and resurrect an unrelated Q&A thread under the newly-pasted content.
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6476:    await saveSingleLesson(destSemKey, key, lessons[key], NON_CONTENT_FIELDS_TO_CLEAR);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6601:// Backtracking audit, Phase 8: a third live writer of curriculum/cutProjects,
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6886:// saveLessonData() write passed the WHOLE {projects:[...]} wrapper into
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6888:// curriculum/futureProjects and corrupting renderIdeaBank()'s cache — a
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6891:// targeted saveSingleLesson() write (unrelated lessons in the same semester
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6944:  // Q&A thread, photo, completion flag, or materials list would silently
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:6949:    await saveSingleLesson(semKey, key, newLesson, [...fieldsToClear, ...NON_CONTENT_FIELDS_TO_CLEAR]);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7029:  const container = document.getElementById('ca-help-content');
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7030:  const badge = document.getElementById('ca-help-badge');
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7039:  // Show lessons with active Q&A threads (has messages from teachers)
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7040:  const helpItems = Object.entries(lessons)
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7048:  const needsResponse = helpItems.filter(([, l]) => hasUnansweredQuestion(l));
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7050:  if (helpItems.length === 0) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7051:    container.innerHTML = '<p class="ca-empty-hint">No teachers need help right now.</p>';
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7056:  badge.textContent = needsResponse.length || helpItems.length;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7061:    html += `<div class="ca-help-summary" style="display:flex;align-items:center;gap:0.75rem;">
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7070:  const displayItems = hqFilterNeedsReply ? needsResponse : helpItems;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7077:    html += `<div class="ca-help-item ${unanswered ? 'ca-help-unanswered' : 'ca-help-answered'}">
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7078:      <div class="ca-help-item-header">
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7079:        ${unanswered ? '<span class="ca-help-new-badge">Needs Reply</span>' : '<span class="ca-help-replied-badge">Replied</span>'}
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7081:        ${timeAgo ? `<span class="ca-help-time">${timeAgo}</span>` : ''}
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7083:      <div class="ca-help-item-project">${escHtml(lesson.projectTitle)}</div>
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7085:      <div class="ca-help-respond">
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7086:        <input type="text" class="ca-help-input" placeholder="Type a response..." id="ca-help-input-${escAttr(key)}">
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7087:        <button class="btn-primary ca-help-send-btn" onclick="sendHelpResponse('${escAttr(key)}')">Respond</button>
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7116:// lesson's FIRST atomic-append reply, so that legacy content isn't silently
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7124:// Backtracking audit Phase 11 fix: both admin Q&A reply functions used to
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7125:// resave the ENTIRE cached semester via saveLessonData() — a Firestore
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7129:// up, that reply would silently revert the teacher's edit back to this
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7131:// one in the reply. Now a single targeted Firestore .update() touching only
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7136:  const input = document.getElementById(`ca-help-input-${key}`);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7145:  // an admin could write a reply while the banner says saving is disabled.
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7146:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7201:    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7202:    : curriculumDb.collection('curriculum').doc('lessonData');
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7207:    console.error('Error sending help response:', err);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7221:  const input = document.getElementById(`qa-reply-${key}`);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7230:  // an admin could write a reply while the banner says saving is disabled.
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7231:  if (lessonDataLoadedSuccessfully === false) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7257:    alert('This lesson was moved or removed elsewhere. Your reply was not sent — please close this window and check the grid for its new location.');
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7284:    ? curriculumDb.collection('summerCamps_lessonData').doc(summerDocIdFor(semKey, key))
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7285:    : curriculumDb.collection('curriculum').doc('lessonData');
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7290:    console.error('Error sending Q&A reply:', err);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7291:    alert('Error sending reply: ' + err.message);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7304:  const content = document.getElementById('ca-help-content');
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7515:  const summerSnap = await curriculumDb.collection('summerCamps_lessonData').get();
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7518:  const lessonDataSnap = await curriculumDb.collection('curriculum').doc('lessonData').get();
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7519:  const lessonDataDoc = lessonDataSnap.exists ? lessonDataSnap.data() : {};
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:7520:  for (const semesterLessons of Object.values(lessonDataDoc)) {
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:8213:// The result must still go through escAttr (or the print helpers' esc) at
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:8401:// ─── Q&A Thread Helpers ─────────────────────────────
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:8416:// Get Q&A thread for a lesson (supports both new qaThread and legacy fields)
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:8430:// Check if Q&A has an unanswered teacher question
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:8437:// Render Q&A thread as chat bubbles
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:8456:// Render Q&A section with reply input (for admin detail modal)
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:8460:  html += '<label>Q&A with Admin</label>';
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:8468:  // Reply input (admin can always reply)
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:8469:  html += `<div class="qa-reply-box">
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:8470:    <input type="text" class="qa-reply-input" id="qa-reply-${escAttr(key)}" placeholder="Type a reply...">
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:8471:    <button class="btn-primary qa-reply-btn" onclick="sendQaReply('${escAttr(key)}')">Send</button>
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:10908:    // the two the helper always sets, so they are excluded from the diff.
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:10918:    const IGNORE_TOP = new Set(['lastUpdated', 'lastUpdatedBy']);   // the helper always sets these
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:10941:      stampOutput(`⚠️ The write landed but the read-back does not match:\n${problems.join('\n')}\n\nCheck curriculum/appData in the Firebase Console before doing anything else.`);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:11428:    await saveLessonData(semKey, lessons);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:11502:// handful of pieces differ — materials from the planner's list, no Q&A, no
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:11654:        ${sdoc ? '' : `<!-- Q&A with Admin Section -->
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:11704:  // Load Q&A thread and wire up send button (summer only — no SDOC Q&A, Christie Sep 25)
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:11837:    // The curriculum/lessonData listener rebuilds the whole summer cache from
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:11885:      // that reaches saveSingleLesson telling it to actually delete the field
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:11930:      // summer branch of saveSingleLesson() is a set-merge, so everything
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:11932:      // reply in qaThread, a photo another client replaced, a planComplete
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:11963:      const result = await saveSingleLesson(semKey, lessonKey, payload, fieldsToClear, sdoc ? { dayOffAuth: dayOffAuthFor(semKey) } : undefined);
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:11964:      // saveSingleLesson() stamps lastEditedBy/At onto the object it is given;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:12520:  const writable = lessonDataLoadedSuccessfully !== false;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:13048:  const planner = canPlanDayOffCamps() && lessonDataLoadedSuccessfully !== false;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:13182:  const planner = canPlanDayOffCamps() && lessonDataLoadedSuccessfully !== false;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:13183:  const ticker = canTickDayOffMaterials() && lessonDataLoadedSuccessfully !== false;
/Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js:13409:  const ticker = canTickDayOffMaterials() && lessonDataLoadedSuccessfully !== false;

exec
/bin/zsh -lc "sed -n '1,320p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html && sed -n '1,430p' /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA.diff && sed -n '1,280p' firestore.rules && sed -n '330,520p' firestore.rules" in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
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
    The hash is SHA-256 of canonical (sorted-key) JSON of <code>map</code>. It's all or nothing.</li>
  <li><strong>Verify</strong> from forced-server reads: <code>lessons_spring-2026</code> minus its <code>lastUpdated*</code> hashes to the recorded <code>sha256</code>, its lesson count matches, <code>lessonData</code> no longer has <code>spring-2026</code>, and <code>lessonData</code>'s size is re-estimated (expected about 420 KB). Edits are paused by rule, so these checks are stable.</li>
  <li><strong>If verification passes:</strong> <code>storageMigrations.spring-2026.verified = true</code>, and Spring becomes editable. Spot-check one Spring lesson in the Firebase Console.</li>
  <li><strong>If it fails:</strong> nothing has been edited since the copy, so the reverse transaction is safe: it puts <code>map</code> back into <code>lessonData</code>, which Phase A's rollback allowance permits (a manager/admin, only this key, only while unverified, and only together with deleting <code>lessons_spring-2026</code>), deletes <code>lessons_spring-2026</code>, and records the failure. The download from step 1 remains the last resort.</li>
</ol>
<div class="bdd">Scenario: move (emulator, the same procedure as an e2e test)
  Then lessons_spring-2026 deep-equals the old map (+ lastUpdated*), lessonData has no spring-2026, storageMigrations records count + hash, verified → true, Spring editable, Fall untouched
Scenario: target already exists → refuses before any write
Scenario: verification fails (simulated) → the reverse transaction restores lessonData['spring-2026'] byte-identical and removes the target
Scenario: a pre-Phase-B tab after the move → its Spring edit is refused by the rules (no data loss)</div>
<div class="note"><strong>The backup script edit (Christie gave permission for this change, Sep 29):</strong> <em>before</em> Phase C, and with Christie's go-ahead confirmed again at that moment, Claude adds the five lines recorded in the Decisions Log to <code>tinker-backups/backup.js</code> (<code>computeClassbookContentByTeacher</code>, just before <code>return counts;</code>). It keeps a <code>.bak</code> copy, checks the syntax with <code>node --check</code>, doesn't run the script, and touches nothing else, above all not the credential code. Because the move is one step, the backup never sees Spring twice.</div>
</div>

<h2 id="followup">Follow-up plan (required before the next semester is created)</h2>
<div class="note">After Phase C, <code>lessonData</code> holds Fall (about 420 KB and growing). <strong>Before Spring 2027 is created</strong> (or before <code>lessonData</code> passes about 70%), a follow-up plan must:
<ul>
  <li>move Fall at the end of its term</li>
  <li>create new semesters in their own document (config set before <code>saveLessonData</code>, <code>app.js:4965</code> vs <code>:4980</code>; <code>not-found</code> on the first write)</li>
  <li>route <code>deleteSemester</code>/Archive for own-doc semesters (re-enabling Spring's delete or archive)</li>
  <li>generalise the constant and the rules fence</li>
</ul>
The make-active-semester plan resumes after that.</div>

<h2 id="safety">Firebase safety checklist</h2>
<div class="safe"><ul>
  <li><strong>Rules:</strong> Phase A is a shared-rules change: tests for all five roles, a near-1 MB fixture, the whole suite green, then <code>deploy-rules.sh --approved &lt;sha&gt;</code> after the phrase. The new docs (<code>lessons_spring-2026</code>, <code>storageMigrations</code>) get explicit conditions in the <code>curriculum/{docId}</code> block.</li>
  <li><strong>Backups (checked Sep 29):</strong> <code>backup.js</code> fetches <em>every</em> document in each listed collection (<code>fetchCollection</code>, <code>:221-247</code>), so <code>lessons_spring-2026</code> and <code>storageMigrations</code> are in every 30-minute backup automatically. The Tier-1 count check counts documents, and <code>curriculum</code> gains two, so there's no false alarm there. The per-teacher content count is covered by the five-line edit.</li>
  <li><strong>Snapshot:</strong> a JSON download right before the move, plus <code>tinker-backups/backup.js</code>'s automatic 30-minute backups of the <code>curriculum</code> collection (Tier 1).</li>
  <li><strong>Atomic:</strong> the copy, the old-copy removal and the migration record are one transaction.</li>
  <li><strong>Verified</strong> from forced-server reads while edits are paused by rule, before anything is unpaused.</li>
  <li><strong>Reversible:</strong> a reverse transaction until verified. After that, the download and backups.</li>
  <li><strong>Partial updates:</strong> per-field dotted paths as today. <code>saveLessonData</code>'s whole-semester merge-set becomes a whole-document merge-set for own-doc semesters (still <code>merge: true</code>).</li>
  <li><strong>Spot check:</strong> one Spring lesson in the Firebase Console after verification.</li>
</ul></div>

<h2 id="completeness">If interrupted</h2>
<ul>
  <li><strong>After A:</strong> Spring is view-only, and nothing else changes.</li>
  <li><strong>After B:</strong> the same, plus the readout and fixed Studio Hub alerts.</li>
  <li><strong>Mid-C:</strong> the transaction either committed or didn't. If it committed but isn't verified, Spring is viewable, edits are paused, and the reverse transaction exists.</li>
</ul>

<h2 id="resume">Resume instructions</h2>
<ol>
  <li>Read this plan and its Decisions Log. Re-measure lessonData first.</li>
  <li>Phase A in <code>studio-hub</code> (branch, merge to main, then the guard). Phase B in a Classbook worktree off <code>origin/main</code>, plus Studio Hub for the alerts. Re-check the line numbers.</li>
  <li>Per phase: commit, run the full suite, then a second-model implementation review. Each deploy, the backup.js edit, and Phase C each need Christie's own yes. Phase A needs the sha phrase.</li>
</ol>

<h2 id="decisions">Decisions Log (append-only)</h2>
<div class="decision">
  <strong>Sep 29, 2026: revision 5, EXECUTION-READY.</strong> Codex round 3 (<code>…-codex-r3.md</code>) confirmed fixes 2 and 3, and confirmed the rules design is implementable (<code>existsAfter</code>, all split statements constrained). Its single remaining item: the Phase A update-condition summary was missing the rollback branch, which is now added with Codex's exact form. All phases are marked execution-ready. Build waits for Christie's go-ahead. Deploys, the backup.js edit and Phase C each still need her own yes, and Phase A needs the sha phrase.
</div>
<div class="decision">
  <strong>Sep 29, 2026: revision 4, after Codex round 2 (<code>…-codex-r2.md</code>).</strong> Codex confirmed 6 of its 8 round-1 items resolved, including that the forward transaction works under the Phase A rules. Three fixes taken:
  <ol>
    <li>The rollback re-add is explicitly allowed for manager/admin, only while unverified and only with <code>lessons_spring-2026</code> deleted in the same transaction (<code>getAfter</code>). This replaces the test that contradicted it.</li>
    <li>Deleting the new document is manager/admin-only and only while unverified. Other roles are always denied, and everyone is denied after verification until the follow-up plan.</li>
    <li>Studio Hub dismissals are ID-based, so an alert counts as dismissed under its old ID too, and nothing dismissed resurfaces.</li>
  </ol>
</div>
<div class="decision">
  <strong>Sep 29, 2026: revision 3, after Codex's independent round 1 (<code>…-codex-r1.md</code>): NOT ready, 8-point minimum list, all verified and taken.</strong>
  <ul>
    <li>Adopted Codex's "simpler safe option": the copy and the old-copy removal are <strong>one transaction</strong>, with Spring edits paused by rule until the move is verified. That closes the verification/rollback race (1), the target-missing-at-delete risk (2) and double counting (5), since there's no dual-copy window, and Phases C and D merge.</li>
    <li>(3) The rules also fence <code>lessonData</code> create and whole-doc delete, keep manager delete for other docs, and the tests cover admin and curriculum-admin. Q3 is resolved: manager delete is kept, except for <code>lessonData</code>.</li>
    <li>(4) A stale-tab cutoff: Phase B live for 3 days or more, staff asked to reopen the Classbook, and an old tab can only mis-display, never lose data.</li>
    <li>(6) Studio Hub alerts reconcile a union across sources, with semester-qualified IDs.</li>
    <li>(7) Spring's delete is disabled in Phase B.</li>
    <li>(8) Merged <code>storageMigrations</code> writes, target-disappearance behaviour, and a Firestore-size estimator for the readout with an 85% warning.</li>
  </ul>
  The inventory adds <code>studio-hub/test-alerts-browser.html:227</code> and <code>TESTING-GUIDE.md:115</code> (manual, root <code>qaData</code> only).<br>
  <strong>Christie (Sep 29):</strong> she can't edit <code>backup.js</code> herself, and gave <strong>permission for Claude to make that one five-line change</strong> (keep a .bak, <code>node --check</code>, don't run it, touch nothing else), to be confirmed again at the time.
</div>
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
diff --git a/firestore.rules b/firestore.rules
index ec41acd..897ba93 100644
--- a/firestore.rules
+++ b/firestore.rules
@@ -650,8 +650,53 @@ service cloud.firestore {
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
+          && !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
+          && !springMoveVerified();
+      }
+
+      // Manager+: full access to everything including appData (reads; ordinary-doc writes)
+      allow read: if isManagerOrAbove();
+      allow create, update, delete: if isManagerOrAbove() && !isStorageMoveDoc();
 
       // classbook-admin, curriculum-admin (legacy key), and classbook: full read/write except appData and prepCycleConfig
       // appData (Settings) is manager+ only, always
@@ -662,24 +707,49 @@ service cloud.firestore {
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
+      allow create, update: if docId == 'storageMigrations' && isManagerOrAbove();
     }
 
     // ═══════════════════════════════════════════════════════════════
diff --git a/rules.test.js b/rules.test.js
index 11bb541..32cd0b2 100644
--- a/rules.test.js
+++ b/rules.test.js
@@ -2585,3 +2585,252 @@ describe('Clay Hub Membership — the database protects memberId and freezes ret
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
+  });
+});
+
+describe('Classbook storage move — every other /curriculum doc exactly as before', () => {
+  beforeEach(async () => {
+    await testEnv.withSecurityRulesDisabled(async (ctx) => {
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
rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {

    // ═══════════════════════════════════════════════════════════════
    // HELPER FUNCTIONS
    // Change a function here → every rule that uses it updates.
    // Never repeat logic inline.
    // ═══════════════════════════════════════════════════════════════

    function isAuthenticated() {
      return request.auth != null;
    }

    function getUserData() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data;
    }

    // Archived users (active:false) lose access everywhere this is required —
    // missing `active` defaults to true, so existing users need no migration.
    // The reminder bot is never an active user, whatever a users doc keyed to its uid might say — so
    // even a doc an admin created by hand can never make isAdmin/isManager/hasAppAccess true for it.
    function isActiveUser() {
      return isAuthenticated() && !isReminderBot() && getUserData().get('active', true) == true;
    }

    function isAdmin() {
      return isAuthenticated() && isActiveUser() && getUserData().role == 'admin';
    }

    function isManager() {
      return isAuthenticated() && isActiveUser() && getUserData().role == 'manager';
    }

    function isManagerOrAbove() {
      return isAuthenticated() && isActiveUser() && getUserData().role in ['admin', 'manager'];
    }

    function isKiosk() {
      return isAuthenticated() && (
        request.auth.uid == '06ooFxutK5YTaJvu5SkywY9gZqh2'
        || request.auth.token.email == 'kiosk@tinkerartstudio.com'
        || request.auth.token.email == 'kiosk2@tinkerartstudio.com'
      );
    }

    // Tinker Ticker's 48-hour shift-reminder job (reminders@tinkerartstudio.com), a Netlify Scheduled
    // Function that signs in with the client SDK — no service account, no key. Pinned by uid ONLY: an
    // email/password account's address is unverified, so the kiosk's email clause is deliberately not
    // copied. It has no users doc and never will (see the users create rule). What it may do is listed
    // per collection below and nowhere else: read schedules, GET (never list) a users doc, and create /
    // resolve its own claim documents in timeclock_reminder_log. Never OR this with a helper that
    // reads users (isManagerOrAbove etc.) — each grant is its own allow line.
    function isReminderBotUid(uid) {
      return uid == 'JO8U8EYw2tgVBbsUXvbqNrbCPlh1';
    }
    function isReminderBot() {
      return isAuthenticated() && isReminderBotUid(request.auth.uid);
    }

    // Checks if an authenticated user has been explicitly granted
    // access to an app via their appAccess array.
    // Manager+ never need this — they're covered by isManagerOrAbove().
    // Finance collections (payroll, bookkeeping) have NO override path —
    // this function is intentionally never called for those.
    function hasAppAccess(appName) {
      let data = getUserData();
      return isAuthenticated()
        && isActiveUser()
        && ('appAccess' in data)
        && appName in data.appAccess;
    }

    // Studio isolation. Admin always passes. Everyone else must have
    // the studio in their studios array. Needs its own explicit isActiveUser()
    // check — the non-admin branch doesn't route through isAdmin()/isManager()/
    // hasAppAccess() at all, so gating those four alone would miss this one.
    function belongsToStudio(studio) {
      return isActiveUser() && (isAdmin() || studio in getUserData().studios);
    }

    // True if `field` is unchanged by this write: same presence
    // (both missing or both present) and, if present, the same value.
    // Used to pin privilege-bearing fields (role, appAccess, studios)
    // during self-writes to the users collection.
    function fieldUnchanged(field) {
      return (field in resource.data) == (field in request.resource.data)
        && (!(field in resource.data) || request.resource.data[field] == resource.data[field]);
    }

    // True if `field` was not set before this write, or keeps the same value:
    // a first-time set is allowed; changing or removing it once set is denied.
    // (request.resource.data is the whole document after the write.)
    function fieldUnchangedOnceSet(field) {
      return !(field in resource.data)
        || (field in request.resource.data && request.resource.data[field] == resource.data[field]);
    }


    // ═══════════════════════════════════════════════════════════════
    // USERS COLLECTION
    // Self-read/create: always allowed for any authenticated user
    // (required for the auth guard to load the app).
    // Manager+: read all user docs.
    // Self-update: role field must not change.
    // Manager update: cannot change role field, cannot delete.
    // Admin: full create / update / delete.
    // ═══════════════════════════════════════════════════════════════

    match /users/{userId} {
      // Own doc read — all authenticated users (auth guard requires it). Not the reminder bot: its
      // grant is GET-only below, and this `read` would let an id-constrained LIST through.
      allow read: if isAuthenticated() && request.auth.uid == userId && !isReminderBot();
      // Manager+ reads all user docs (team filters, admin panels, etc.)
      allow read: if isManagerOrAbove();
      // Kiosk: read all users (for PIN lookup)
      allow read: if isKiosk();
      // Reminder bot: GET one doc by uid (the account it is about to email) — never a list.
      allow get: if isReminderBot();

      // Self-create: role must be 'staff' (prevents self-promotion), and
      // appAccess must be absent or empty — app access is granted by an
      // admin/manager via Manage Team, never by the user themselves.
      // studios is NOT locked to empty here: the real bootstrap write (see
      // js/app.js handleAuthStateChange) always sets studios: ['tinker',
      // 'clayhub'] — both known studios, granted to every new user by
      // default — so hasOnly() permits exactly that shape while still
      // blocking a self-create from injecting any value outside the two
      // known studios (there's no smaller "safe default" to enforce here
      // since the app already grants both to everyone; appAccess is the
      // field that actually gates privilege).
      // The reminder bot is a job, not a person: it can never bootstrap a users doc for itself, so it
      // can never become "an active staff user" to isActiveUser()/hasAppAccess().
      allow create: if isAuthenticated()
        && request.auth.uid == userId
        && !isReminderBot()
        && request.resource.data.role == 'staff'
        && (!('appAccess' in request.resource.data) || request.resource.data.appAccess.size() == 0)
        && (!('studios' in request.resource.data) || request.resource.data.studios.hasOnly(['tinker', 'clayhub']));

      // Self-update: role, appAccess, and studios must not change.
      // Without pinning appAccess/studios here, any authenticated staff
      // user could grant themselves access to any app (KPI, Classbook,
      // Payroll-adjacent tools, etc.) with a direct Firestore write that
      // bypasses the Manage Team UI entirely.
      allow update: if isAuthenticated()
        && request.auth.uid == userId
        && !isReminderBot()
        && request.resource.data.role == resource.data.role
        && fieldUnchanged('appAccess')
        && fieldUnchanged('studios')
        && fieldUnchanged('active');

      // Manager update: cannot change role field, cannot delete.
      // Restricted to OTHER users' docs (request.auth.uid != userId) —
      // without this guard, a manager editing their OWN doc would satisfy
      // isManager() and bypass the appAccess/studios pins on the self-update
      // rule above entirely, since Firestore OR's sibling `allow update`
      // rules together. A manager's own self-edits go through the
      // self-update rule instead, which does pin those fields. Found by
      // independent second-model review before this shipped — see
      // firebase-agent-defense-hardening.md.
      // A manager also cannot flip an admin's `active` field (archive/
      // reactivate) — only another admin can. Managers keep full appAccess/
      // studios editing on admins; that pre-existing gap stays out of scope.
      allow update: if isManager()
        && request.auth.uid != userId
        && request.resource.data.role == resource.data.role
        && (resource.data.role != 'admin' || fieldUnchanged('active'));

      // Admin: full create / update / delete on OTHER users' docs. An admin
      // can never change their OWN `active` field via this (or any) rule —
      // without this guard this blanket rule sits outside the self-update
      // rule's fieldUnchanged('active') pin (Firestore ORs sibling `allow`
      // rules), so an admin could archive themselves with no recovery path:
      // the moment it commits, isAdmin() requires isActiveUser() and denies
      // them on every future request, including their own attempt to undo
      // it. Same bug shape as the manager self-grant fix above, just for a
      // field that didn't exist yet when that one shipped.
      // …and never a doc keyed to the reminder bot's uid (a job, not a person): create and update are
      // refused so no admin can hand the Netlify-held password a role by typing the uid; delete stays,
      // so a doc created by mistake can be removed.
      allow write: if isAdmin()
        && (request.auth.uid != userId || fieldUnchanged('active'))
        && !(isReminderBotUid(userId) && request.method in ['create', 'update']);
    }


    // ═══════════════════════════════════════════════════════════════
    // FINANCE — HARD LOCKED
    // payroll and bookkeeping: manager+ ONLY. No appAccess override
    // path exists, ever. No exceptions.
    // ═══════════════════════════════════════════════════════════════

    match /payroll/{docId} {
      allow read, write: if isManagerOrAbove();
    }

    // Payroll Tool settings history — an append-only recovery log.
    // Manager+ may read and create; nothing may update or delete an entry.
    // A create must ride in the same transaction that moves the parent's
    // settingsRev (getAfter tie), carry the caller's own email and a server
    // timestamp, and have exactly the declared shape.
    // Plan: tinker-ai-configs/thoughts/plans/payroll-settings-safety-and-seasons.html
    match /payroll/appData/settingsHistory/{histId} {
      allow read: if isManagerOrAbove();
      allow create: if isManagerOrAbove()
        && request.resource.data.keys().hasAll(['settings','hash','rev','savedAt','savedBy','kind','summary','configVersion'])
        && request.resource.data.keys().hasOnly(['settings','hash','rev','savedAt','savedBy','kind','summary','configVersion','recovered'])
        && request.resource.data.settings is map
        && request.resource.data.hash is string
        && request.resource.data.rev is int
        && request.resource.data.summary is string
        && request.resource.data.configVersion is int
        && request.resource.data.savedBy == request.auth.token.email
        && request.resource.data.savedAt == request.time
        && request.resource.data.kind in ['baseline','edit','restore','import','before-import']
        && (!('recovered' in request.resource.data) || request.resource.data.recovered is bool)
        && request.resource.data.rev == getAfter(/databases/$(database)/documents/payroll/appData).data.settingsRev;
      // append-only: no update, no delete
    }

    match /bookkeeping/{docId} {
      allow read, write: if isManagerOrAbove();
    }


    // ═══════════════════════════════════════════════════════════════
    // KPI DASHBOARD
    // Manager+ always. Staff: requires appAccess('kpi').
    // ═══════════════════════════════════════════════════════════════

    match /kpiData/{docId} {
      allow read, write: if isManagerOrAbove() || hasAppAccess('kpi');
    }


    // ═══════════════════════════════════════════════════════════════
    // HIRING
    // Manager+ always. Staff: requires appAccess('hiring').
    // ═══════════════════════════════════════════════════════════════

    match /hiring/{docId} {
      allow read, write: if isManagerOrAbove() || hasAppAccess('hiring');
    }


    // ═══════════════════════════════════════════════════════════════
    // STAFF DIRECTORY
    // Manager+ or appAccess('staff-directory'): full read/write.
    // Delete: manager+ only.
    // ═══════════════════════════════════════════════════════════════

    match /staffDirectory/{docId} {
      allow read, create, update: if isManagerOrAbove() || hasAppAccess('staff-directory');
      allow delete: if isManagerOrAbove();
    }


    // ═══════════════════════════════════════════════════════════════
    // TRAINING
    // modules, programs:
    //   Manager+ or appAccess('training'): read/write (create+update).
    //   Delete: manager+ only.
    //
    // assignments:
    //   Manager+ can read/write all.
    //   Staff with appAccess('training') can create/read/update only
    //   their own assignment docs (memberId == request.auth.uid).
    //   Delete: manager+ only.
    // ═══════════════════════════════════════════════════════════════

    match /trainingModules/{docId} {
      allow read, create, update: if isManagerOrAbove() || hasAppAccess('training');
      allow delete: if isManagerOrAbove();
    }

    match /trainingPrograms/{docId} {
      allow read, create, update: if isManagerOrAbove() || hasAppAccess('training');
      // Split deliberately into get and list, because the two need different guards.
      //
      // GET (one document, known contents): `is list` is load-bearing, not defensive noise.
      // In rules `in` tests MAP KEYS, so a sharedWith written as {someUid: true} would
      // otherwise grant that uid a read. Only managers can write here, so it is not an
      // escalation path -- but the shape ambiguity is removed rather than trusted.
      allow get: if hasAppAccess('training')
        && resource.data.get('sharedWith', []) is list
        && request.auth.uid in resource.data.get('sharedWith', [])
        && resource.data.status == 'published';

      // LIST (a query): `is list` cannot be used here at all. Firestore evaluates a list
      // operation against a hypothetical document shaped by the query's constraints, and it
      // cannot prove a type predicate about it -- adding `is list` denies the whole query.
      // It is also unnecessary: array-contains matches only real arrays, so a map- or
      // string-shaped sharedWith can never appear in these results. The query must still
      // constrain BOTH fields, since rules are not filters. Needs the
      // (sharedWith CONTAINS, status ASC) composite index in firestore.indexes.json.
      allow list: if hasAppAccess('training')
        && request.auth.uid in resource.data.get('sharedWith', [])
        && resource.data.status == 'published';
    }

    match /trainingObservationSchedule/{docId} {
      // Only managers can create and manage scheduled observations
      allow read, write: if isManagerOrAbove();
    }


    // ═══════════════════════════════════════════════════════════════
    // MATERIALS LOCATOR — FULLY PUBLIC (no auth required)
    // App has no login — anyone with the link can read and write.
    // Data is not sensitive (art supply locations).
    // ═══════════════════════════════════════════════════════════════

    match /materials/{docId} {
      allow read, write: if true;  // intentionally public — no auth required
    }


    // ═══════════════════════════════════════════════════════════════
    // SUPPLY LOW LIST
    // Manager+ or appAccess('supply-list'): read/create/update.
    // Delete: manager+ only.
    // ═══════════════════════════════════════════════════════════════

    match /supplyList/{docId} {
      allow read, create, update: if isManagerOrAbove() || hasAppAccess('supply-list');
      allow delete: if isManagerOrAbove();
    }


    // ═══════════════════════════════════════════════════════════════
    // SCHEDULE VIEWER
    // Manager+ or appAccess('schedule-viewer'): read/create/update.
    // Delete: manager+ only.
    // ═══════════════════════════════════════════════════════════════

    match /scheduleData/{docId} {
      allow read, create, update: if isManagerOrAbove() || hasAppAccess('schedule-viewer');
      allow delete: if isManagerOrAbove();
    }


    // ═══════════════════════════════════════════════════════════════
    // TIMECLOCK
    // All timeclock collections require appAccess('timeclock') for
    // staff. Manager+ always has full access to everything.
    //
    // entries:   Staff with access — own entries only (read/create/update)
    // schedules: Staff with access — read-only; manager+ write
    // hfwa:      Staff with access — own doc only (create/read)
    // timeoff:   Staff with access — own doc only (create/read/update)
    // settings:  Staff with access — read-only; manager+ write
    // streaks:   Staff with access — own doc only (read/write)
    // ═══════════════════════════════════════════════════════════════

    match /timeclock_entries/{docId} {
      allow read, write: if isManagerOrAbove();
      // Kiosk: read + create entries (needs to read today's status after PIN entry)
      allow read, create: if isKiosk();
      // Staff with access: own entries only
      allow create: if hasAppAccess('timeclock')
        && request.resource.data.uid == request.auth.uid;
      allow read: if hasAppAccess('timeclock')
        && resource.data.uid == request.auth.uid;
      allow update: if hasAppAccess('timeclock')
        && resource.data.uid == request.auth.uid;
    }

    match /timeclock_schedules/{uid} {
      allow read, write: if isManagerOrAbove();
      // Staff with access: read-only
      allow read: if hasAppAccess('timeclock');
      // Kiosk: read schedules (to detect late clock-outs)
      allow read: if isKiosk();
      // Reminder bot: read every schedule (list + get) to find flagged shifts; never write.
      allow read: if isReminderBot();
    }

    match /timeclock_hfwa/{docId} {
      allow read, write: if isManagerOrAbove();
      // Staff with access: own doc only
      allow create: if hasAppAccess('timeclock')
        && request.resource.data.uid == request.auth.uid;
      allow read: if hasAppAccess('timeclock')
        && resource.data.uid == request.auth.uid;
    }

    match /timeclock_timeoff/{docId} {
      allow read, write: if isManagerOrAbove();
      // Staff with access: own doc only
      allow create: if hasAppAccess('timeclock')
        && request.resource.data.uid == request.auth.uid;
      allow read: if hasAppAccess('timeclock')
        && resource.data.uid == request.auth.uid;
      allow update: if hasAppAccess('timeclock')
        && resource.data.uid == request.auth.uid;
    }

    match /timeclock_settings/{docId} {
      allow read, write: if isManagerOrAbove();
      // Staff with access: read-only
      allow read: if hasAppAccess('timeclock');
      // Staff can write the employees doc for name claiming
      allow write: if hasAppAccess('timeclock') && docId == 'employees';
      // adminSubscriptions: any authenticated user can read (needed for staff→admin push)
      allow read: if isAuthenticated() && docId == 'adminSubscriptions';
      // Kiosk: read employees (PIN lookup) and schedules
      allow read: if isKiosk();
    }

    match /timeclock_streaks/{uid} {
      allow read, write: if isManagerOrAbove();
      // Staff with access: own doc only
      allow read, write: if hasAppAccess('timeclock')
        && request.auth.uid == uid;
      // Kiosk: read/write streaks (tracks clock-in/out streaks directly)
      allow read, write: if isKiosk();
    }

    match /timeclock_overrides/{uid} {
      // Manager+: read/write (set and clear overrides via admin UI)
      allow read, write: if isManagerOrAbove();
      // Kiosk: read-only (applies override when staff clocks out)
      allow read: if isKiosk();
      // Any timeclock account (e.g. kiosk2): read-only
      allow read: if hasAppAccess('timeclock');
    }

    // Tinker Ticker — 48-hour shift reminders: one document per (schedule document, date), created by the
    // reminder bot as a CLAIM before it sends and then resolved (sentAt, or attempts/error). The claim is
    // the dedupe — two overlapping runs cannot both send — and the audit trail the Reminders view shows.
    // Managers read it (it holds staff email addresses, so staff never can). Nobody updates a resolved
    // claim, nobody deletes, and the bot can only create a claim for a schedule that exists.
    match /timeclock_reminder_log/{logId} {
      allow read: if isManagerOrAbove();
      allow get: if isReminderBot();
      allow create: if isReminderBot()
        && request.resource.data.keys().hasOnly(['uid', 'date', 'to', 'shift', 'claimedAt', 'sentAt', 'attempts'])
        && request.resource.data.keys().hasAll(['uid', 'date', 'to', 'shift', 'claimedAt', 'sentAt', 'attempts'])
        && request.resource.data.uid is string
        && request.resource.data.uid.size() > 0 && request.resource.data.uid.size() <= 64
        && request.resource.data.date is string
        && request.resource.data.date.matches('^[0-9]{4}-[0-9]{2}-[0-9]{2}$')
        && logId == request.resource.data.uid + '_' + request.resource.data.date
        && request.resource.data.to is string
        && request.resource.data.to.size() > 0 && request.resource.data.to.size() <= 254
        && request.resource.data.shift is map
        && request.resource.data.shift.keys().hasOnly(['start', 'end', 'studio', 'note'])
        && request.resource.data.shift.keys().hasAll(['start', 'end', 'studio', 'note'])
        && request.resource.data.shift.start is string && request.resource.data.shift.start.size() <= 20
        && request.resource.data.shift.end is string && request.resource.data.shift.end.size() <= 20
        && request.resource.data.shift.studio is string && request.resource.data.shift.studio.size() <= 40
        && request.resource.data.shift.note is string && request.resource.data.shift.note.size() <= 200
        && request.resource.data.claimedAt == request.time
        && request.resource.data.sentAt == null
        && request.resource.data.attempts == 0
        && exists(/databases/$(database)/documents/timeclock_schedules/$(request.resource.data.uid));
      // Resolving a claim: only while unresolved, only the outcome fields, bounded attempts, server time.
      allow update: if isReminderBot()
        && resource.data.sentAt == null
        && request.resource.data.diff(resource.data).affectedKeys().hasOnly(['sentAt', 'attempts', 'lastAttemptAt', 'error'])
        && request.resource.data.attempts is int
        && request.resource.data.attempts >= resource.data.attempts
        && request.resource.data.attempts <= 3
        && (request.resource.data.sentAt == null || request.resource.data.sentAt == request.time)
        // request.resource.data is the whole POST-write document, so a lastAttemptAt stamped by an earlier
        // failed attempt is still there when a later update only marks sentAt — check it only when this
        // write changes it (implementation review: the first version denied every mark-sent after a retry).
        && (!request.resource.data.diff(resource.data).affectedKeys().hasAny(['lastAttemptAt'])

exec
/bin/zsh -lc "nl -ba firestore.rules | sed -n '1,180p'; nl -ba firestore.rules | sed -n '630,760p'; nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html | sed -n '100,180p'; nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA.diff | sed -n '1,430p'" in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
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
   131	      // since the app already grants both to everyone; appAccess is the
   132	      // field that actually gates privilege).
   133	      // The reminder bot is a job, not a person: it can never bootstrap a users doc for itself, so it
   134	      // can never become "an active staff user" to isActiveUser()/hasAppAccess().
   135	      allow create: if isAuthenticated()
   136	        && request.auth.uid == userId
   137	        && !isReminderBot()
   138	        && request.resource.data.role == 'staff'
   139	        && (!('appAccess' in request.resource.data) || request.resource.data.appAccess.size() == 0)
   140	        && (!('studios' in request.resource.data) || request.resource.data.studios.hasOnly(['tinker', 'clayhub']));
   141	
   142	      // Self-update: role, appAccess, and studios must not change.
   143	      // Without pinning appAccess/studios here, any authenticated staff
   144	      // user could grant themselves access to any app (KPI, Classbook,
   145	      // Payroll-adjacent tools, etc.) with a direct Firestore write that
   146	      // bypasses the Manage Team UI entirely.
   147	      allow update: if isAuthenticated()
   148	        && request.auth.uid == userId
   149	        && !isReminderBot()
   150	        && request.resource.data.role == resource.data.role
   151	        && fieldUnchanged('appAccess')
   152	        && fieldUnchanged('studios')
   153	        && fieldUnchanged('active');
   154	
   155	      // Manager update: cannot change role field, cannot delete.
   156	      // Restricted to OTHER users' docs (request.auth.uid != userId) —
   157	      // without this guard, a manager editing their OWN doc would satisfy
   158	      // isManager() and bypass the appAccess/studios pins on the self-update
   159	      // rule above entirely, since Firestore OR's sibling `allow update`
   160	      // rules together. A manager's own self-edits go through the
   161	      // self-update rule instead, which does pin those fields. Found by
   162	      // independent second-model review before this shipped — see
   163	      // firebase-agent-defense-hardening.md.
   164	      // A manager also cannot flip an admin's `active` field (archive/
   165	      // reactivate) — only another admin can. Managers keep full appAccess/
   166	      // studios editing on admins; that pre-existing gap stays out of scope.
   167	      allow update: if isManager()
   168	        && request.auth.uid != userId
   169	        && request.resource.data.role == resource.data.role
   170	        && (resource.data.role != 'admin' || fieldUnchanged('active'));
   171	
   172	      // Admin: full create / update / delete on OTHER users' docs. An admin
   173	      // can never change their OWN `active` field via this (or any) rule —
   174	      // without this guard this blanket rule sits outside the self-update
   175	      // rule's fieldUnchanged('active') pin (Firestore ORs sibling `allow`
   176	      // rules), so an admin could archive themselves with no recovery path:
   177	      // the moment it commits, isAdmin() requires isActiveUser() and denies
   178	      // them on every future request, including their own attempt to undo
   179	      // it. Same bug shape as the manager self-grant fix above, just for a
   180	      // field that didn't exist yet when that one shipped.
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
   693	          && !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
   694	          && !springMoveVerified();
   695	      }
   696	
   697	      // Manager+: full access to everything including appData (reads; ordinary-doc writes)
   698	      allow read: if isManagerOrAbove();
   699	      allow create, update, delete: if isManagerOrAbove() && !isStorageMoveDoc();
   700	
   701	      // classbook-admin, curriculum-admin (legacy key), and classbook: full read/write except appData and prepCycleConfig
   702	      // appData (Settings) is manager+ only, always
   703	      // prepCycleConfig (Prep Cycle workflow config) is classbook-admin only
   704	      // NOTE: 'classbook' (plain teacher) access is intentionally NOT
   705	      // isolated per-teacher here — each semester's lessons live in one
   706	      // shared doc, and per-field isolation is enforced by the UI, not
   707	      // by these rules. This is a known, accepted gap (see
   708	      // firebase-agent-defense-hardening.md) pending a possible future
   709	      // data-model change, not something this rule can close on its own.
   710	      allow read: if isClassbookRole();
   711	      allow create, update: if
   712	        isClassbookRole()
   713	        && docId != 'appData'
   714	        && docId != 'prepCycleConfig'
   715	        && !isStorageMoveDoc();
   716	      // Whole-document delete is classbook-admin/curriculum-admin only.
   717	      // Plain 'classbook' (teacher) access never calls a full-document
   718	      // delete in the app (only FieldValue.delete() on specific lesson
   719	      // fields, which is an update, not a delete) — so this closes an
   720	      // unused, high-blast-radius capability with no functional change.
   721	      allow delete: if
   722	        isClassbookAdminRole()
   723	        && docId != 'appData'
   724	        && docId != 'prepCycleConfig'
   725	        && !isStorageMoveDoc();
   726	      // prepCycleConfig: classbook-admin and curriculum-admin write only
   727	      allow create, update, delete: if
   728	        isClassbookAdminRole()
   729	        && docId == 'prepCycleConfig';
   730	
   731	      // lessonData: as before for every semester except 'spring-2026'; no whole-document delete.
   732	      allow create: if docId == 'lessonData'
   733	        && (isManagerOrAbove() || isClassbookRole())
   734	        && !('spring-2026' in request.resource.data);
   735	      allow update: if docId == 'lessonData'
   736	        && (isManagerOrAbove() || isClassbookRole())
   737	        && springKeyUntouched();
   738	      allow update: if docId == 'lessonData'
   739	        && isManagerOrAbove()
   740	        && (springKeyRemovedOnly() || springKeyRolledBack());
   741	
   742	      // lessons_spring-2026: Spring 2026's lessons after the move.
   743	      allow create: if docId == 'lessons_spring-2026' && isManagerOrAbove();
   744	      allow update: if docId == 'lessons_spring-2026'
   745	        && (isManagerOrAbove() || isClassbookRole())
   746	        && springMoveVerified();
   747	      allow delete: if docId == 'lessons_spring-2026'
   748	        && isManagerOrAbove()
   749	        && !springMoveVerified();
   750	
   751	      // storageMigrations: the move's record (manager+ writes; read via the read lines above).
   752	      allow create, update: if docId == 'storageMigrations' && isManagerOrAbove();
   753	    }
   754	
   755	    // ═══════════════════════════════════════════════════════════════
   756	    // CLASSBOOK — SCHOOL DAY OFF CAMPS (SDOCs)
   757	    // Plan: tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html (Phase 1, §1.1)
   758	    //   dayOffCamps_events / dayOffCamps_camps: the admin's planning list for a school year.
   759	    //     classbook-admin (+ manager+) write, plain classbook teachers read.
   760	    //   dayOffCamps_lessonData: one shared plan per camp-project. Teachers create/update like
   100	  storageMigrations write                                           → manager/admin only; read → classbook roles
   101	  every other /curriculum doc (appData, prepCycleConfig, prepData, cutProjects, changeLog, …) → exactly as today
   102	  A near-1 MB lessonData fixture built from many sub-fields, with its estimated size asserted, reset per mutating test: the allow/deny cases above evaluate correctly
   103	  The whole existing studio-hub suite passes</div>
   104	</div>
   105	
   106	<div class="phase" id="phase-b">
   107	<h3>Phase B: the Classbook (and Studio Hub) understand Spring's new home. No data moves yet. <span class="status-tag ready">execution-ready: true</span></h3>
   108	<p><strong>Acceptance:</strong> in production (no <code>lessons_spring-2026</code> yet), everything behaves as today, and Spring is view-only ("editing is paused while Spring 2026 moves to new storage"). In the emulator, with Spring moved and verified, Spring works end to end, and Fall and every other semester are untouched. This is one Classbook deploy (one Netlify credit) plus one Studio Hub deploy.</p>
   109	<ul>
   110	  <li><strong>The listener doesn't drop Spring</strong> (round 1 A). The legacy snapshot's swap carries own-doc semesters across, the way it already carries camp seasons. The <code>lessons_K</code> listener updates only <code>currentLessonData[K]</code>, doesn't bump <code>globalListenerGeneration</code>, and never touches <code>lessonDataLoadedSuccessfully</code>. Its errors go to a visible banner and make Spring unwritable.</li>
   111	  <li><strong>Transitions are loud, never blank.</strong>
   112	    <ul>
   113	      <li>If <code>lessons_K</code> appears (the move committed), Spring switches to it.</li>
   114	      <li>If it disappears (a rollback), the app reloads Spring from the legacy source, or shows "reload the page" if that's gone too.</li>
   115	      <li>If the legacy snapshot lacks a key this tab was rendering from <code>lessonData</code>, the app shows "moved — reload the page".</li>
   116	    </ul>
   117	    The whole teardown uses one unsubscribe array (the listener is registered from <code>app.js:676</code> and <code>:5038</code>).</li>
   118	  <li><strong>Writes to Spring:</strong> they go to <code>lessons_K</code> only when <code>storageMigrations.spring-2026.verified</code> is true, read by a small <code>storageMigrations</code> listener. Otherwise the app shows the "editing is paused" message; the rules refuse those writes anyway. <code>not-found</code> is handled the same way.</li>
   119	  <li><strong>Counts come from one source per semester</strong> (Codex 5). <code>computeLiveContentCountByTeacher</code> uses <code>lessons_K</code> when it exists and skips <code>lessonData[K]</code>, otherwise the legacy map. There's never a dual-copy window anyway, but this protects against a failed rollback state.</li>
   120	  <li><strong>Deleting Spring is disabled</strong> (Codex 7). <code>deleteSemester('spring-2026')</code> refuses with "Spring 2026 can't be deleted while its storage is being changed", until the follow-up plan routes it properly.</li>
   121	  <li><strong>Headroom readout</strong> in Curriculum Admin → Diagnostics (managers): an approximate Firestore-size estimate of <code>lessonData</code>, using the same field-size method as the Sep 29 snippet (not <code>JSON.stringify</code> length). It's labelled "approx.", and it warns above 85%, a conservative buffer.</li>
   122	  <li><strong>Studio Hub alerts</strong> (Codex 6). The listener keeps per-source state: legacy <code>lessonData</code>, plus <code>lessons_spring-2026</code>. It reconciles the <em>union</em>, so each source's snapshot no longer removes the other's alerts. It prefers the own-doc copy for Spring. Alert IDs become <code>classbook-qa-&lt;semKey&gt;-&lt;lessonKey&gt;</code>, fixing today's cross-semester collisions. Studio Hub stores dismissals <em>by ID</em> (<code>alerts.js:6-7, 54-68, 654</code>), so an alert also counts as dismissed if its <strong>old</strong> ID <code>classbook-qa-&lt;lessonKey&gt;</code> is in the dismissed set. This is a one-line compatibility check in <code>addOrUpdateAlert</code>, so nothing already dismissed comes back (Codex round 2, fix 3). An old dismissal applies to that lesson key in every semester, which matches today's behaviour, since today the two collide into one alert.</li>
   123	  <li><strong>Ratchet:</strong> no <code>doc('lessonData')</code> in the loaded scripts outside the helpers, the legacy load/listener and the dead backup helpers. <code>e2e/</code> is exempt. The seed gains a <code>lessons_spring-2026</code> + <code>storageMigrations</code> fixture set for the own-doc scenarios, and the default seed is unchanged.</li>
   124	</ul>
   125	<div class="bdd">Scenario: production state after deploy — regression
   126	  Given no lessons_spring-2026
   127	  Then every existing e2e test passes; Fall behaves as today; Spring is viewable and edits show "editing is paused"
   128	
   129	Scenario: Spring moved and verified works end to end (emulator)
   130	  When a teacher views/saves a Spring lesson, sends Q&A; an admin replies, edits, moves/swaps
   131	  Then every write lands in lessons_spring-2026 at lessonKey.field paths; lessonData is untouched
   132	
   133	Scenario: moved but not yet verified — edits paused
   134	  Given lessons_spring-2026 exists, verified false
   135	  Then Spring shows the moved lessons and edits show "editing is paused"
   136	
   137	Scenario: a Fall save doesn't blank Spring (round 1 A)
   138	Scenario: the target doc disappears (rollback) → Spring falls back to legacy or "reload", never an empty grid
   139	Scenario: own-doc listener error → banner, Spring unwritable, Fall unaffected
   140	Scenario: counts: a teacher with 10 Spring + 5 Fall lessons counts 15, before and after the move
   141	Scenario: deleteSemester('spring-2026') refuses with the storage message
   142	Scenario: Studio Hub: a Fall question and a Spring question both alert, and answering one leaves the other; identical lesson keys in two semesters give two alerts
   143	Scenario: Studio Hub: an alert dismissed under its old ID stays dismissed after the re-key
   144	Scenario: headroom readout shows ≈ N KB of 1,024 (approx.) and warns above 85%</div>
   145	</div>
   146	
   147	<div class="phase" id="phase-c">
   148	<h3>Phase C: move Spring in one step (production, one-off, manager) <span class="status-tag ready">execution-ready: true</span></h3>
   149	<p><strong>Preconditions:</strong>
   150	<ul>
   151	  <li>Phase B has been live at least 3 days, and it's a quiet time (evening).</li>
   152	  <li><strong>Stale-tab cutoff</strong> (Codex 4): the day before, Christie asks staff to close and reopen the Classbook. A tab still running pre-Phase-B code can't lose anything, because the Phase A rules refuse its Spring writes. It could show Spring as empty until it's reloaded, and that's the accepted residual.</li>
   153	  <li>Christie's go-ahead.</li>
   154	</ul></p>
   155	<p><strong>How:</strong> a console procedure that Christie pastes while signed in as manager. The procedure is written into this plan and reviewed before execution, and rehearsed in the emulator by an e2e test that runs the same code.</p>
   156	<ol>
   157	  <li>A forced-server read of <code>lessonData</code>. It refuses if <code>spring-2026</code> is missing or <code>lessons_spring-2026</code> exists. Then it downloads <code>classbook-spring-2026-lessons-&lt;ISO&gt;.json</code>.</li>
   158	  <li><strong>One transaction:</strong> read <code>lessonData</code>, <code>lessons_spring-2026</code> (which must not exist) and <code>storageMigrations</code>. Then:
   159	    <ul>
   160	      <li><code>tx.set(lessons_spring-2026, { ...map, lastUpdated, lastUpdatedBy })</code>, where <code>map</code> is the <code>spring-2026</code> map read <em>inside</em> the transaction</li>
   161	      <li><code>tx.update(lessonData, { 'spring-2026': FieldValue.delete() })</code></li>
   162	      <li><code>tx.set(storageMigrations, { 'spring-2026': { movedAt, movedBy, lessonCount, sha256, verified: false } }, { merge: true })</code></li>
   163	    </ul>
   164	    The hash is SHA-256 of canonical (sorted-key) JSON of <code>map</code>. It's all or nothing.</li>
   165	  <li><strong>Verify</strong> from forced-server reads: <code>lessons_spring-2026</code> minus its <code>lastUpdated*</code> hashes to the recorded <code>sha256</code>, its lesson count matches, <code>lessonData</code> no longer has <code>spring-2026</code>, and <code>lessonData</code>'s size is re-estimated (expected about 420 KB). Edits are paused by rule, so these checks are stable.</li>
   166	  <li><strong>If verification passes:</strong> <code>storageMigrations.spring-2026.verified = true</code>, and Spring becomes editable. Spot-check one Spring lesson in the Firebase Console.</li>
   167	  <li><strong>If it fails:</strong> nothing has been edited since the copy, so the reverse transaction is safe: it puts <code>map</code> back into <code>lessonData</code>, which Phase A's rollback allowance permits (a manager/admin, only this key, only while unverified, and only together with deleting <code>lessons_spring-2026</code>), deletes <code>lessons_spring-2026</code>, and records the failure. The download from step 1 remains the last resort.</li>
   168	</ol>
   169	<div class="bdd">Scenario: move (emulator, the same procedure as an e2e test)
   170	  Then lessons_spring-2026 deep-equals the old map (+ lastUpdated*), lessonData has no spring-2026, storageMigrations records count + hash, verified → true, Spring editable, Fall untouched
   171	Scenario: target already exists → refuses before any write
   172	Scenario: verification fails (simulated) → the reverse transaction restores lessonData['spring-2026'] byte-identical and removes the target
   173	Scenario: a pre-Phase-B tab after the move → its Spring edit is refused by the rules (no data loss)</div>
   174	<div class="note"><strong>The backup script edit (Christie gave permission for this change, Sep 29):</strong> <em>before</em> Phase C, and with Christie's go-ahead confirmed again at that moment, Claude adds the five lines recorded in the Decisions Log to <code>tinker-backups/backup.js</code> (<code>computeClassbookContentByTeacher</code>, just before <code>return counts;</code>). It keeps a <code>.bak</code> copy, checks the syntax with <code>node --check</code>, doesn't run the script, and touches nothing else, above all not the credential code. Because the move is one step, the backup never sees Spring twice.</div>
   175	</div>
   176	
   177	<h2 id="followup">Follow-up plan (required before the next semester is created)</h2>
   178	<div class="note">After Phase C, <code>lessonData</code> holds Fall (about 420 KB and growing). <strong>Before Spring 2027 is created</strong> (or before <code>lessonData</code> passes about 70%), a follow-up plan must:
   179	<ul>
   180	  <li>move Fall at the end of its term</li>
     1	diff --git a/firestore.rules b/firestore.rules
     2	index ec41acd..897ba93 100644
     3	--- a/firestore.rules
     4	+++ b/firestore.rules
     5	@@ -650,8 +650,53 @@ service cloud.firestore {
     6	     // ═══════════════════════════════════════════════════════════════
     7	 
     8	     match /curriculum/{docId} {
     9	-      // Manager+: full access to everything including appData
    10	-      allow read, write: if isManagerOrAbove();
    11	+      // ── Spring 2026 storage move (Sep 29 2026) ──────────────────────────
    12	+      // Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase A).
    13	+      // curriculum/lessonData holds every Fall/Spring semester in ONE document and was at 95% of
    14	+      // Firestore's 1 MiB cap. Spring 2026 moves to curriculum/lessons_spring-2026 in one manager
    15	+      // transaction. Three docs therefore get their own rules below; every other curriculum doc
    16	+      // keeps exactly the rules it had (the "ordinary docs" lines).
    17	+      //   lessonData          — nobody changes its 'spring-2026' key, except manager+ deleting ONLY
    18	+      //                         that key (the move) or re-adding ONLY that key while the move is
    19	+      //                         unverified AND the new doc is deleted in the same transaction
    20	+      //                         (the rollback). Nobody deletes the whole document.
    21	+      //   lessons_spring-2026 — created by manager+; edited only once storageMigrations says the move
    22	+      //                         is verified; deleted only by manager+ and only while unverified.
    23	+      //   storageMigrations   — manager+ writes; classbook roles read.
    24	+      function isClassbookRole() {
    25	+        return hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook');
    26	+      }
    27	+      function isClassbookAdminRole() {
    28	+        return hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin');
    29	+      }
    30	+      function isStorageMoveDoc() {
    31	+        return docId in ['lessonData', 'lessons_spring-2026', 'storageMigrations'];
    32	+      }
    33	+      function springMoveVerified() {
    34	+        let path = /databases/$(database)/documents/curriculum/storageMigrations;
    35	+        return exists(path) && get(path).data.get('spring-2026', {}).get('verified', false) == true;
    36	+      }
    37	+      function lessonDataChangedKeys() {
    38	+        return request.resource.data.diff(resource.data).affectedKeys();
    39	+      }
    40	+      function springKeyUntouched() {
    41	+        return !lessonDataChangedKeys().hasAny(['spring-2026']);
    42	+      }
    43	+      function springKeyRemovedOnly() {
    44	+        return lessonDataChangedKeys().hasOnly(['spring-2026'])
    45	+          && !('spring-2026' in request.resource.data);
    46	+      }
    47	+      function springKeyRolledBack() {
    48	+        return lessonDataChangedKeys().hasOnly(['spring-2026'])
    49	+          && ('spring-2026' in request.resource.data)
    50	+          && !('spring-2026' in resource.data)
    51	+          && !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
    52	+          && !springMoveVerified();
    53	+      }
    54	+
    55	+      // Manager+: full access to everything including appData (reads; ordinary-doc writes)
    56	+      allow read: if isManagerOrAbove();
    57	+      allow create, update, delete: if isManagerOrAbove() && !isStorageMoveDoc();
    58	 
    59	       // classbook-admin, curriculum-admin (legacy key), and classbook: full read/write except appData and prepCycleConfig
    60	       // appData (Settings) is manager+ only, always
    61	@@ -662,24 +707,49 @@ service cloud.firestore {
    62	       // by these rules. This is a known, accepted gap (see
    63	       // firebase-agent-defense-hardening.md) pending a possible future
    64	       // data-model change, not something this rule can close on its own.
    65	-      allow read: if hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook');
    66	+      allow read: if isClassbookRole();
    67	       allow create, update: if
    68	-        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook'))
    69	+        isClassbookRole()
    70	         && docId != 'appData'
    71	-        && docId != 'prepCycleConfig';
    72	+        && docId != 'prepCycleConfig'
    73	+        && !isStorageMoveDoc();
    74	       // Whole-document delete is classbook-admin/curriculum-admin only.
    75	       // Plain 'classbook' (teacher) access never calls a full-document
    76	       // delete in the app (only FieldValue.delete() on specific lesson
    77	       // fields, which is an update, not a delete) — so this closes an
    78	       // unused, high-blast-radius capability with no functional change.
    79	       allow delete: if
    80	-        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin'))
    81	+        isClassbookAdminRole()
    82	         && docId != 'appData'
    83	-        && docId != 'prepCycleConfig';
    84	+        && docId != 'prepCycleConfig'
    85	+        && !isStorageMoveDoc();
    86	       // prepCycleConfig: classbook-admin and curriculum-admin write only
    87	       allow create, update, delete: if
    88	-        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin'))
    89	+        isClassbookAdminRole()
    90	         && docId == 'prepCycleConfig';
    91	+
    92	+      // lessonData: as before for every semester except 'spring-2026'; no whole-document delete.
    93	+      allow create: if docId == 'lessonData'
    94	+        && (isManagerOrAbove() || isClassbookRole())
    95	+        && !('spring-2026' in request.resource.data);
    96	+      allow update: if docId == 'lessonData'
    97	+        && (isManagerOrAbove() || isClassbookRole())
    98	+        && springKeyUntouched();
    99	+      allow update: if docId == 'lessonData'
   100	+        && isManagerOrAbove()
   101	+        && (springKeyRemovedOnly() || springKeyRolledBack());
   102	+
   103	+      // lessons_spring-2026: Spring 2026's lessons after the move.
   104	+      allow create: if docId == 'lessons_spring-2026' && isManagerOrAbove();
   105	+      allow update: if docId == 'lessons_spring-2026'
   106	+        && (isManagerOrAbove() || isClassbookRole())
   107	+        && springMoveVerified();
   108	+      allow delete: if docId == 'lessons_spring-2026'
   109	+        && isManagerOrAbove()
   110	+        && !springMoveVerified();
   111	+
   112	+      // storageMigrations: the move's record (manager+ writes; read via the read lines above).
   113	+      allow create, update: if docId == 'storageMigrations' && isManagerOrAbove();
   114	     }
   115	 
   116	     // ═══════════════════════════════════════════════════════════════
   117	diff --git a/rules.test.js b/rules.test.js
   118	index 11bb541..32cd0b2 100644
   119	--- a/rules.test.js
   120	+++ b/rules.test.js
   121	@@ -2585,3 +2585,252 @@ describe('Clay Hub Membership — the database protects memberId and freezes ret
   122	     await assertFails(setDoc(doc(db, 'clayHub_appData', 'b0-app-x'), { a: 1 }));
   123	   });
   124	 });
   125	+
   126	+
   127	+// ─── CLASSBOOK — SPRING 2026 STORAGE MOVE (lessonData fence) ────────────────
   128	+// Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html, Phase A.
   129	+// curriculum/lessonData (every Fall/Spring semester in ONE document) was at 95% of Firestore's
   130	+// 1 MiB cap on Sep 29 2026. Spring 2026 moves to curriculum/lessons_spring-2026 in one
   131	+// manager transaction. These rules: nobody changes lessonData's spring-2026 key except the
   132	+// move (delete only) and its rollback (re-add only, while unverified, target deleted in the
   133	+// same transaction); nobody deletes the whole lessonData doc; the new doc is created by a
   134	+// manager, edited only once storageMigrations says the move is verified, and deleted only by a
   135	+// manager during a rollback. Every other /curriculum doc behaves exactly as before.
   136	+
   137	+const SPRING = 'spring-2026';
   138	+const SPRING_DOC = 'lessons_spring-2026';
   139	+const MIGRATIONS = 'storageMigrations';
   140	+const FENCE_ROLES = [
   141	+  ['teacher (classbook)', CLASSBOOK_UID],
   142	+  ['classbook-admin', CLASSBOOK_ADMIN_UID],
   143	+  ['curriculum-admin (legacy key)', CURRICULUM_ADMIN_ONLY_UID],
   144	+  ['manager', MANAGER_UID],
   145	+  ['admin', ADMIN_UID],
   146	+];
   147	+const NON_MANAGER_ROLES = FENCE_ROLES.slice(0, 3);
   148	+const MANAGER_ROLES = FENCE_ROLES.slice(3);
   149	+const springMap = () => ({ 'mariah-tuesday-1': { teacher: 'Mariah', shortDetails: 'Clay' }, 'kathy-monday-2': { teacher: 'Kathy', processStep1: 'Paint' } });
   150	+
   151	+async function resetStorageMoveFixtures({ spring = true, target = null, migrations = null } = {}) {
   152	+  await testEnv.withSecurityRulesDisabled(async (ctx) => {
   153	+    const db = ctx.firestore();
   154	+    const lessonData = { 'fall-2026': { 'allie-wednesday-1': { teacher: 'Allie', shortDetails: 'Print' } }, lastUpdated: 'x' };
   155	+    if (spring) lessonData[SPRING] = springMap();
   156	+    await setDoc(doc(db, 'curriculum', 'lessonData'), lessonData);
   157	+    if (target) await setDoc(doc(db, 'curriculum', SPRING_DOC), target); else await deleteDoc(doc(db, 'curriculum', SPRING_DOC));
   158	+    if (migrations) await setDoc(doc(db, 'curriculum', MIGRATIONS), migrations); else await deleteDoc(doc(db, 'curriculum', MIGRATIONS));
   159	+  });
   160	+}
   161	+
   162	+// The Phase C move, as the console procedure will run it (one transaction).
   163	+async function runMove(db) {
   164	+  return runTransaction(db, async (tx) => {
   165	+    const ld = await tx.get(doc(db, 'curriculum', 'lessonData'));
   166	+    const target = await tx.get(doc(db, 'curriculum', SPRING_DOC));
   167	+    await tx.get(doc(db, 'curriculum', MIGRATIONS));
   168	+    if (target.exists()) throw new Error('target exists');
   169	+    const map = ld.data()[SPRING];
   170	+    tx.set(doc(db, 'curriculum', SPRING_DOC), { ...map, lastUpdated: 'now', lastUpdatedBy: 'test' });
   171	+    tx.update(doc(db, 'curriculum', 'lessonData'), { [SPRING]: deleteField() });
   172	+    tx.set(doc(db, 'curriculum', MIGRATIONS), { [SPRING]: { lessonCount: Object.keys(map).length, sha256: 'h', verified: false } }, { merge: true });
   173	+  });
   174	+}
   175	+// The rollback: re-add the key and delete the target in the same transaction.
   176	+async function runRollback(db, { deleteTarget = true } = {}) {
   177	+  return runTransaction(db, async (tx) => {
   178	+    await tx.get(doc(db, 'curriculum', 'lessonData'));
   179	+    await tx.get(doc(db, 'curriculum', SPRING_DOC));
   180	+    tx.update(doc(db, 'curriculum', 'lessonData'), { [SPRING]: springMap() });
   181	+    if (deleteTarget) tx.delete(doc(db, 'curriculum', SPRING_DOC));
   182	+  });
   183	+}
   184	+
   185	+describe('Classbook storage move — lessonData spring-2026 fence', () => {
   186	+  beforeEach(() => resetStorageMoveFixtures());
   187	+
   188	+  test.each(FENCE_ROLES)('%s can still update another semester in lessonData', async (_l, uid) => {
   189	+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026.allie-wednesday-1.shortDetails': 'Updated' }));
   190	+  });
   191	+  test.each(FENCE_ROLES)('%s CANNOT change a spring-2026 lesson in lessonData', async (_l, uid) => {
   192	+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.mariah-tuesday-1.shortDetails': 'Changed' }));
   193	+  });
   194	+  test.each(FENCE_ROLES)('%s CANNOT add a new spring-2026 lesson in lessonData', async (_l, uid) => {
   195	+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.new-lesson': { teacher: 'X' } }));
   196	+  });
   197	+  test.each(MANAGER_ROLES)('%s can delete ONLY the spring-2026 key', async (_l, uid) => {
   198	+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField() }));
   199	+  });
   200	+  test.each(NON_MANAGER_ROLES)('%s CANNOT delete the spring-2026 key', async (_l, uid) => {
   201	+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField() }));
   202	+  });
   203	+  test.each(MANAGER_ROLES)('%s CANNOT delete spring-2026 together with another change', async (_l, uid) => {
   204	+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: deleteField(), 'fall-2026.allie-wednesday-1.shortDetails': 'x' }));
   205	+  });
   206	+  test.each(FENCE_ROLES)('%s CANNOT delete the whole lessonData document', async (_l, uid) => {
   207	+    await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', 'lessonData')));
   208	+  });
   209	+  test.each(FENCE_ROLES)('%s CANNOT replace lessonData with a set() that changes spring-2026', async (_l, uid) => {
   210	+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': {}, [SPRING]: { stale: true } }));
   211	+  });
   212	+  test.each(FENCE_ROLES)('%s can still merge-set another semester into lessonData (saveLessonData shape)', async (_l, uid) => {
   213	+    await assertSucceeds(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': { 'new-slot': { teacher: 'Allie' } } }, { merge: true }));
   214	+  });
   215	+});
   216	+
   217	+describe('Classbook storage move — lessonData cannot be recreated with spring-2026', () => {
   218	+  beforeEach(async () => {
   219	+    await resetStorageMoveFixtures();
   220	+    await testEnv.withSecurityRulesDisabled(async (ctx) => { await deleteDoc(doc(ctx.firestore(), 'curriculum', 'lessonData')); });
   221	+  });
   222	+  test.each(FENCE_ROLES)('%s CANNOT create lessonData containing spring-2026', async (_l, uid) => {
   223	+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
   224	+  });
   225	+  test.each(FENCE_ROLES)('%s can create lessonData without spring-2026 (as today)', async (_l, uid) => {
   226	+    await assertSucceeds(setDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026': {} }));
   227	+  });
   228	+});
   229	+
   230	+describe('Classbook storage move — the move transaction', () => {
   231	+  beforeEach(() => resetStorageMoveFixtures());
   232	+  test.each(MANAGER_ROLES)('%s can run the one-step move', async (_l, uid) => {
   233	+    await assertSucceeds(runMove(getDb(uid)));
   234	+  });
   235	+  test.each(NON_MANAGER_ROLES)('%s CANNOT run the move', async (_l, uid) => {
   236	+    await assertFails(runMove(getDb(uid)));
   237	+  });
   238	+  test.each(NON_MANAGER_ROLES)('%s CANNOT create lessons_spring-2026', async (_l, uid) => {
   239	+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', SPRING_DOC), springMap()));
   240	+  });
   241	+  test.each(NON_MANAGER_ROLES)('%s CANNOT write storageMigrations', async (_l, uid) => {
   242	+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [SPRING]: { verified: true } }, { merge: true }));
   243	+  });
   244	+  test.each(FENCE_ROLES)('%s can read storageMigrations once it exists', async (_l, uid) => {
   245	+    await testEnv.withSecurityRulesDisabled(async (ctx) => { await setDoc(doc(ctx.firestore(), 'curriculum', MIGRATIONS), { [SPRING]: { verified: false } }); });
   246	+    await assertSucceeds(getDoc(doc(getDb(uid), 'curriculum', MIGRATIONS)));
   247	+  });
   248	+});
   249	+
   250	+describe('Classbook storage move — moved, NOT yet verified (edits paused; rollback allowed)', () => {
   251	+  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: false } } }));
   252	+
   253	+  test.each(FENCE_ROLES)('%s CANNOT edit lessons_spring-2026 before verification', async (_l, uid) => {
   254	+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', SPRING_DOC), { 'mariah-tuesday-1.shortDetails': 'Changed' }));
   255	+  });
   256	+  test.each(FENCE_ROLES)('%s can read lessons_spring-2026', async (_l, uid) => {
   257	+    await assertSucceeds(getDoc(doc(getDb(uid), 'curriculum', SPRING_DOC)));
   258	+  });
   259	+  test.each(MANAGER_ROLES)('%s can run the rollback (re-add + delete target, one transaction)', async (_l, uid) => {
   260	+    await assertSucceeds(runRollback(getDb(uid)));
   261	+  });
   262	+  test.each(NON_MANAGER_ROLES)('%s CANNOT run the rollback', async (_l, uid) => {
   263	+    await assertFails(runRollback(getDb(uid)));
   264	+  });
   265	+  test.each(MANAGER_ROLES)('%s CANNOT re-add spring-2026 without deleting the target', async (_l, uid) => {
   266	+    await assertFails(runRollback(getDb(uid), { deleteTarget: false }));
   267	+  });
   268	+  test.each(FENCE_ROLES)('%s CANNOT plainly re-add spring-2026 to lessonData', async (_l, uid) => {
   269	+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { [SPRING]: springMap() }));
   270	+  });
   271	+  test.each(MANAGER_ROLES)('%s can delete lessons_spring-2026 before verification', async (_l, uid) => {
   272	+    await assertSucceeds(deleteDoc(doc(getDb(uid), 'curriculum', SPRING_DOC)));
   273	+  });
   274	+  test.each(NON_MANAGER_ROLES)('%s CANNOT delete lessons_spring-2026', async (_l, uid) => {
   275	+    await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', SPRING_DOC)));
   276	+  });
   277	+  test.each(MANAGER_ROLES)('%s can mark the move verified', async (_l, uid) => {
   278	+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', MIGRATIONS), { [`${SPRING}.verified`]: true }));
   279	+  });
   280	+  test.each(MANAGER_ROLES)('%s CANNOT create lessons_spring-2026 again while it exists (set over it is an update, refused while unverified)', async (_l, uid) => {
   281	+    await assertFails(setDoc(doc(getDb(uid), 'curriculum', SPRING_DOC), { replaced: true }));
   282	+  });
   283	+});
   284	+
   285	+describe('Classbook storage move — moved AND verified (edits back on; no delete, no rollback)', () => {
   286	+  beforeEach(() => resetStorageMoveFixtures({ spring: false, target: { ...springMap(), lastUpdated: 'now' }, migrations: { [SPRING]: { verified: true } } }));
   287	+
   288	+  test.each(FENCE_ROLES)('%s can edit a Spring lesson in lessons_spring-2026', async (_l, uid) => {
   289	+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', SPRING_DOC), { 'mariah-tuesday-1.shortDetails': 'Changed' }));
   290	+  });
   291	+  test.each(FENCE_ROLES)('%s CANNOT delete lessons_spring-2026 after verification', async (_l, uid) => {
   292	+    await assertFails(deleteDoc(doc(getDb(uid), 'curriculum', SPRING_DOC)));
   293	+  });
   294	+  test.each(MANAGER_ROLES)('%s CANNOT roll back after verification', async (_l, uid) => {
   295	+    await assertFails(runRollback(getDb(uid)));
   296	+  });
   297	+  test.each(FENCE_ROLES)('%s CANNOT re-create spring-2026 in lessonData', async (_l, uid) => {
   298	+    await assertFails(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'spring-2026.stale': { teacher: 'X' } }));
   299	+  });
   300	+  test.each(FENCE_ROLES)('%s still updates Fall in lessonData normally', async (_l, uid) => {
   301	+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'lessonData'), { 'fall-2026.allie-wednesday-1.shortDetails': 'Updated' }));
   302	+  });
   303	+});
   304	+
   305	+describe('Classbook storage move — every other /curriculum doc exactly as before', () => {
   306	+  beforeEach(async () => {
   307	+    await testEnv.withSecurityRulesDisabled(async (ctx) => {
   308	+      const db = ctx.firestore();
   309	+      await setDoc(doc(db, 'curriculum', 'cutProjects'), { 'fall-2026': [] });
   310	+      await setDoc(doc(db, 'curriculum', 'prepCycleConfig'), { a: 1 });
   311	+      await setDoc(doc(db, 'curriculum', 'ordinary-delete-target'), { a: 1 });
   312	+    });
   313	+  });
   314	+  test.each(FENCE_ROLES)('%s can update cutProjects', async (_l, uid) => {
   315	+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'cutProjects'), { 'fall-2026': ['x'] }));
   316	+  });
   317	+  test.each(MANAGER_ROLES)('%s can still delete an ordinary curriculum doc', async (_l, uid) => {
   318	+    await assertSucceeds(deleteDoc(doc(getDb(uid), 'curriculum', 'ordinary-delete-target')));
   319	+  });
   320	+  test('classbook-admin can still write prepCycleConfig; a plain teacher cannot', async () => {
   321	+    await assertSucceeds(updateDoc(doc(getDb(CLASSBOOK_ADMIN_UID), 'curriculum', 'prepCycleConfig'), { a: 2 }));
   322	+    await assertFails(updateDoc(doc(getDb(CLASSBOOK_UID), 'curriculum', 'prepCycleConfig'), { a: 3 }));
   323	+  });
   324	+  test.each(MANAGER_ROLES)('%s can still update appData and prepCycleConfig', async (_l, uid) => {
   325	+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'appData'), { settings: true }));
   326	+    await assertSucceeds(updateDoc(doc(getDb(uid), 'curriculum', 'prepCycleConfig'), { a: 4 }));
   327	+  });
   328	+  test('staff without classbook access still cannot read or write curriculum', async () => {
   329	+    await assertFails(getDoc(doc(getDb(STAFF_NOACCESS_UID), 'curriculum', 'cutProjects')));
   330	+    await assertFails(updateDoc(doc(getDb(STAFF_NOACCESS_UID), 'curriculum', 'lessonData'), { 'fall-2026.x': {} }));
   331	+  });
   332	+});
   333	+
   334	+// A near-1 MiB lessonData (how production looked on Sep 29 2026): prove the fence evaluates on a
   335	+// full-size document. Built from many sub-fields; its Firestore size is estimated and asserted.
   336	+describe('Classbook storage move — fence on a near-1 MiB lessonData', () => {
   337	+  const firestoreSize = (v) => {
   338	+    const s = (x) => Buffer.byteLength(x, 'utf8') + 1;
   339	+    if (v === null || v === undefined) return 1;
   340	+    if (typeof v === 'string') return s(v);
   341	+    if (typeof v === 'number') return 8;
   342	+    if (typeof v === 'boolean') return 1;
   343	+    return Object.entries(v).reduce((t, [k, x]) => t + s(k) + firestoreSize(x), 0);
   344	+  };
   345	+  const bigSemester = (n) => {
   346	+    const out = {};
   347	+    for (let i = 0; i < n; i++) out[`teacher-class-${i}`] = { teacher: `T${i % 7}`, shortDetails: 'x'.repeat(600), processStep1: 'y'.repeat(600), introPitch: 'z'.repeat(500) };
   348	+    return out;
   349	+  };
   350	+  let big;
   351	+  beforeAll(() => {
   352	+    big = { 'fall-2026': bigSemester(230), [SPRING]: bigSemester(300), lastUpdated: 'x' };
   353	+  });
   354	+  beforeEach(async () => {
   355	+    await testEnv.withSecurityRulesDisabled(async (ctx) => {
   356	+      await setDoc(doc(ctx.firestore(), 'curriculum', 'lessonData'), big);
   357	+      await deleteDoc(doc(ctx.firestore(), 'curriculum', SPRING_DOC));
   358	+      await deleteDoc(doc(ctx.firestore(), 'curriculum', MIGRATIONS));
   359	+    });
   360	+  });
   361	+  test('the fixture really is near the cap (≈ 0.9–1.0 MiB estimated)', () => {
   362	+    const kb = firestoreSize(big) / 1024;
   363	+    expect(kb).toBeGreaterThan(900);
   364	+    expect(kb).toBeLessThan(1020);
   365	+  });
   366	+  test('teacher can update Fall; cannot touch Spring', async () => {
   367	+    await assertSucceeds(updateDoc(doc(getDb(CLASSBOOK_UID), 'curriculum', 'lessonData'), { 'fall-2026.teacher-class-1.shortDetails': 'Updated' }));
   368	+    await assertFails(updateDoc(doc(getDb(CLASSBOOK_UID), 'curriculum', 'lessonData'), { 'spring-2026.teacher-class-1.shortDetails': 'Changed' }));
   369	+  });
   370	+  test('manager can run the one-step move on the full-size document', async () => {
   371	+    await assertSucceeds(runMove(getDb(MANAGER_UID)));
   372	+  });
   373	+});

codex
The central fence structure matches the plan’s intended split, but I’m now tracing two higher-risk areas: whether “verified” can be reversed to reopen rollback/delete, and whether every real SDK write shape produces only the intended top-level affected key.
exec
/bin/zsh -lc "nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/reviews/2026-09-29-impl-review-storage-phaseA.diff | sed -n '1,130p'; nl -ba rules.test.js | sed -n '1,130p'; nl -ba rules.test.js | sed -n '2580,2845p'; nl -ba /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js | sed -n '45,90p;730,845p;880,1010p;1340,1530p'; nl -ba /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/app.js | sed -n '3600,3720p;7120,7305p'" in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
 succeeded in 0ms:
     1	diff --git a/firestore.rules b/firestore.rules
     2	index ec41acd..897ba93 100644
     3	--- a/firestore.rules
     4	+++ b/firestore.rules
     5	@@ -650,8 +650,53 @@ service cloud.firestore {
     6	     // ═══════════════════════════════════════════════════════════════
     7	 
     8	     match /curriculum/{docId} {
     9	-      // Manager+: full access to everything including appData
    10	-      allow read, write: if isManagerOrAbove();
    11	+      // ── Spring 2026 storage move (Sep 29 2026) ──────────────────────────
    12	+      // Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html (Phase A).
    13	+      // curriculum/lessonData holds every Fall/Spring semester in ONE document and was at 95% of
    14	+      // Firestore's 1 MiB cap. Spring 2026 moves to curriculum/lessons_spring-2026 in one manager
    15	+      // transaction. Three docs therefore get their own rules below; every other curriculum doc
    16	+      // keeps exactly the rules it had (the "ordinary docs" lines).
    17	+      //   lessonData          — nobody changes its 'spring-2026' key, except manager+ deleting ONLY
    18	+      //                         that key (the move) or re-adding ONLY that key while the move is
    19	+      //                         unverified AND the new doc is deleted in the same transaction
    20	+      //                         (the rollback). Nobody deletes the whole document.
    21	+      //   lessons_spring-2026 — created by manager+; edited only once storageMigrations says the move
    22	+      //                         is verified; deleted only by manager+ and only while unverified.
    23	+      //   storageMigrations   — manager+ writes; classbook roles read.
    24	+      function isClassbookRole() {
    25	+        return hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook');
    26	+      }
    27	+      function isClassbookAdminRole() {
    28	+        return hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin');
    29	+      }
    30	+      function isStorageMoveDoc() {
    31	+        return docId in ['lessonData', 'lessons_spring-2026', 'storageMigrations'];
    32	+      }
    33	+      function springMoveVerified() {
    34	+        let path = /databases/$(database)/documents/curriculum/storageMigrations;
    35	+        return exists(path) && get(path).data.get('spring-2026', {}).get('verified', false) == true;
    36	+      }
    37	+      function lessonDataChangedKeys() {
    38	+        return request.resource.data.diff(resource.data).affectedKeys();
    39	+      }
    40	+      function springKeyUntouched() {
    41	+        return !lessonDataChangedKeys().hasAny(['spring-2026']);
    42	+      }
    43	+      function springKeyRemovedOnly() {
    44	+        return lessonDataChangedKeys().hasOnly(['spring-2026'])
    45	+          && !('spring-2026' in request.resource.data);
    46	+      }
    47	+      function springKeyRolledBack() {
    48	+        return lessonDataChangedKeys().hasOnly(['spring-2026'])
    49	+          && ('spring-2026' in request.resource.data)
    50	+          && !('spring-2026' in resource.data)
    51	+          && !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026)
    52	+          && !springMoveVerified();
    53	+      }
    54	+
    55	+      // Manager+: full access to everything including appData (reads; ordinary-doc writes)
    56	+      allow read: if isManagerOrAbove();
    57	+      allow create, update, delete: if isManagerOrAbove() && !isStorageMoveDoc();
    58	 
    59	       // classbook-admin, curriculum-admin (legacy key), and classbook: full read/write except appData and prepCycleConfig
    60	       // appData (Settings) is manager+ only, always
    61	@@ -662,24 +707,49 @@ service cloud.firestore {
    62	       // by these rules. This is a known, accepted gap (see
    63	       // firebase-agent-defense-hardening.md) pending a possible future
    64	       // data-model change, not something this rule can close on its own.
    65	-      allow read: if hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook');
    66	+      allow read: if isClassbookRole();
    67	       allow create, update: if
    68	-        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin') || hasAppAccess('classbook'))
    69	+        isClassbookRole()
    70	         && docId != 'appData'
    71	-        && docId != 'prepCycleConfig';
    72	+        && docId != 'prepCycleConfig'
    73	+        && !isStorageMoveDoc();
    74	       // Whole-document delete is classbook-admin/curriculum-admin only.
    75	       // Plain 'classbook' (teacher) access never calls a full-document
    76	       // delete in the app (only FieldValue.delete() on specific lesson
    77	       // fields, which is an update, not a delete) — so this closes an
    78	       // unused, high-blast-radius capability with no functional change.
    79	       allow delete: if
    80	-        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin'))
    81	+        isClassbookAdminRole()
    82	         && docId != 'appData'
    83	-        && docId != 'prepCycleConfig';
    84	+        && docId != 'prepCycleConfig'
    85	+        && !isStorageMoveDoc();
    86	       // prepCycleConfig: classbook-admin and curriculum-admin write only
    87	       allow create, update, delete: if
    88	-        (hasAppAccess('classbook-admin') || hasAppAccess('curriculum-admin'))
    89	+        isClassbookAdminRole()
    90	         && docId == 'prepCycleConfig';
    91	+
    92	+      // lessonData: as before for every semester except 'spring-2026'; no whole-document delete.
    93	+      allow create: if docId == 'lessonData'
    94	+        && (isManagerOrAbove() || isClassbookRole())
    95	+        && !('spring-2026' in request.resource.data);
    96	+      allow update: if docId == 'lessonData'
    97	+        && (isManagerOrAbove() || isClassbookRole())
    98	+        && springKeyUntouched();
    99	+      allow update: if docId == 'lessonData'
   100	+        && isManagerOrAbove()
   101	+        && (springKeyRemovedOnly() || springKeyRolledBack());
   102	+
   103	+      // lessons_spring-2026: Spring 2026's lessons after the move.
   104	+      allow create: if docId == 'lessons_spring-2026' && isManagerOrAbove();
   105	+      allow update: if docId == 'lessons_spring-2026'
   106	+        && (isManagerOrAbove() || isClassbookRole())
   107	+        && springMoveVerified();
   108	+      allow delete: if docId == 'lessons_spring-2026'
   109	+        && isManagerOrAbove()
   110	+        && !springMoveVerified();
   111	+
   112	+      // storageMigrations: the move's record (manager+ writes; read via the read lines above).
   113	+      allow create, update: if docId == 'storageMigrations' && isManagerOrAbove();
   114	     }
   115	 
   116	     // ═══════════════════════════════════════════════════════════════
   117	diff --git a/rules.test.js b/rules.test.js
   118	index 11bb541..32cd0b2 100644
   119	--- a/rules.test.js
   120	+++ b/rules.test.js
   121	@@ -2585,3 +2585,252 @@ describe('Clay Hub Membership — the database protects memberId and freezes ret
   122	     await assertFails(setDoc(doc(db, 'clayHub_appData', 'b0-app-x'), { a: 1 }));
   123	   });
   124	 });
   125	+
   126	+
   127	+// ─── CLASSBOOK — SPRING 2026 STORAGE MOVE (lessonData fence) ────────────────
   128	+// Plan: tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html, Phase A.
   129	+// curriculum/lessonData (every Fall/Spring semester in ONE document) was at 95% of Firestore's
   130	+// 1 MiB cap on Sep 29 2026. Spring 2026 moves to curriculum/lessons_spring-2026 in one
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

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js | sed -n '730,845p'; nl -ba /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js | sed -n '880,1010p'; nl -ba /Users/christiehubley/tinker-spring-curriculum/.claude/worktrees/funny-nash-6aab81/js/firebase-data.js | sed -n '1340,1510p'; nl -ba rules.test.js | sed -n '2640,2840p'" in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
 succeeded in 0ms:
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

exec
/bin/zsh -lc "rg -n \"collection\\(['\\\"]curriculum['\\\"]\\)|doc\\(['\\\"]curriculum/|curriculum/lessonData|curriculum',\\s*'\" . --glob '"'!node_modules/**'"' --glob '"'!rules.test.js'"' --glob '"'!firestore.rules'"'; rg -n \"curriculum\" rules.test.js | head -n 120; rg -n \"ARCHIVED_CLASSBOOK|ARCHIVED_ADMIN|ARCHIVED_MANAGER|KIOSK_UID|REMINDER_BOT_UID\" rules.test.js | tail -n 100; rg -n \"curriculum/lessonData|collection\\(['\\\"]curriculum['\\\"]\\)\" /Users/christiehubley --glob '"'!**/node_modules/**'"' --glob '"'!**/.git/**'"' --glob '"'!**/.claude/worktrees/lessondata-spring-fence/**'"' --glob '*.{js,ts,mjs,cjs,html}'" in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
 exited 2 in 7988ms:
rg: /Users/christiehubley/Library/Calendars: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Caches/com.apple.homed: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Caches/FamilyCircle: Operation not permitted (os error 1)
/Users/christiehubley/Desktop/delete-script.js:3:  const lessonsRef = db.collection('curriculum').doc('lessonData');
rg: /Users/christiehubley/Library/Application Support/CallHistoryTransactions: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/CloudStorage/GoogleDrive-Christie@tinkerartstudio.com/My Drive/All Photos/Shared Photos/Shared Photos: Fall 2026/Intro to Oils(Grey)- Fall '26: Operation timed out (os error 60)
rg: /Users/christiehubley/Library/IdentityServices: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Autosave Information: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Daemon Containers: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.siri.userfeedbacklearning: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.ip.redirects: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.newsd: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.shortcuts: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.calendar: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.notes.import: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.SiriTTS: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.amsondevicestoraged: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.portrait.BackgroundReplacement: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.appstoreagent: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.private.translation: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/com.apple.MailPersonaStorage: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.chronod: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.secure-control-center-preferences: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.VoiceMemos.shared: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.usernoted: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.stocks: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.siri.referenceResolution: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.accessibility.voicebanking: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.ArchiveUtility.PKSignedContainer: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.coreservices.useractivityd: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.swtransparency: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.siri.inference: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.feedback: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.photolibraryd.private: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.stocks-news: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.tipsnext: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.UserNotifications: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.news: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.printtool: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.tv.sharedcontainer: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.tips: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.gamecenter: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.studentd: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.spotlight: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.ManagedSettings: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.sharingd: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.feedbacklogger: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/com.apple.systempreferences.cache: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.weather: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Caches/com.apple.Safari: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.scopedbookmarkagent: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.notes: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.siri.remembers: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/com.apple.stickersd.group: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.screencapture: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.energykit: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Containers/com.apple.VoiceMemos: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Containers/com.apple.archiveutility: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.PegasusConfiguration: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.Maps: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.FamilyControls: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.mlhost: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.AppleSpell: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.Photos.PhotosFileProvider: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.replicatord: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/com.apple.PreviewLegacySignaturesConversion: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Containers/com.apple.Maps/Data/Maps: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Containers/com.apple.Safari: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Containers/com.apple.Home: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.iCloudDrive: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/com.apple.Home.group: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Containers/com.apple.mail: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Containers/com.apple.Safari.WebApp: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.replayd: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.DeviceActivity: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/com.apple.bird: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.mail: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.reminders: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.transparency: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Group Containers/group.com.apple.Safari.SandboxBroker: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Containers/com.apple.Notes: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Containers/com.apple.MobileSMS: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Containers/com.apple.stocks: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Containers/com.apple.news: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Containers/com.apple.corerecents.recentsd/Data/Library/Recents: Operation not permitted (os error 1)
rg: /Users/christiehubley/Library/Containers/com.apple.Passwords/Data/tmp: Interrupted system call (os error 4)

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html | sed -n '70,106p'; nl -ba rules.test.js | sed -n '710,805p'; nl -ba rules.test.js | sed -n '1340,1410p'; nl -ba js/alerts.js | sed -n '540,610p'; nl -ba test-alerts-browser.html | sed -n '205,292p'; nl -ba test-alerts.js | sed -n '80,155p'; nl -ba /Users/christiehubley/Desktop/delete-script.js | sed -n '1,120p'" in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
 succeeded in 0ms:
    70	
    71	<h2 id="phases">Phases</h2>
    72	
    73	<div class="phase" id="phase-a">
    74	<h3>Phase A: rules that protect Spring during and after the move <span class="status-tag ready">execution-ready: true</span></h3>
    75	<p><strong>Acceptance:</strong> every other <code>/curriculum</code> document behaves exactly as today for every role. For <code>curriculum/lessonData</code>:</p>
    76	<ul>
    77	  <li>No role can create, add to, or change the <code>spring-2026</code> key, with exactly two manager/admin exceptions. (1) An update that <em>only deletes</em> it, for the Phase C transaction. (2) The <strong>rollback</strong>: an update that <em>only re-adds</em> it, allowed only while <code>storageMigrations.spring-2026.verified != true</code> and only if <code>getAfter(lessons_spring-2026)</code> shows that document deleted in the same transaction (Codex round 2, fix 1).</li>
    78	  <li>No role can delete the <strong>whole</strong> <code>lessonData</code> document. This closes Codex's bypass: delete it, then recreate it with a stale Spring.</li>
    79	  <li><code>create</code> of <code>lessonData</code> is refused if it contains <code>spring-2026</code>.</li>
    80	</ul>
    81	<p>For <code>curriculum/lessons_spring-2026</code>: create by a manager only, and only if it doesn't exist. Updates only when <code>storageMigrations.spring-2026.verified == true</code>, for the roles that can update lessons today. Whole-doc delete by <strong>manager/admin only, and only while not yet verified</strong> (the rollback). classbook-admin and curriculum-admin may never delete it, and <strong>nobody</strong> may delete it after verification, until the follow-up plan adds a routed delete/archive (Codex round 2, fix 2).</p>
    82	<p>For <code>curriculum/storageMigrations</code>: manager write, and read for the classbook roles.</p>
    83	<p>It deploys through <code>deploy-rules.sh --approved &lt;sha&gt;</code> after Christie's phrase. It ships first: it breaks nothing, because Spring's edits are already paused (Christie approved view-only).</p>
    84	<p><strong>Shape:</strong> split <code>:654</code> (<code>allow read, write: if isManagerOrAbove()</code>) into <code>read</code> / <code>create</code> / <code>update</code> / <code>delete</code> statements, because rules OR across statements. Manager <code>delete</code> is kept for every curriculum doc except <code>lessonData</code>. The classbook-role statements at <code>:666</code> and <code>:675-678</code> get the same <code>lessonData</code>/<code>lessons_spring-2026</code> conditions. The <code>lessonData</code> update condition is <code>!affectedKeys().hasAny(['spring-2026'])</code>, OR (manager/admin, removal) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; !('spring-2026' in request.resource.data)</code>, OR (manager/admin, <strong>rollback re-add</strong>) <code>affectedKeys().hasOnly(['spring-2026']) &amp;&amp; ('spring-2026' in request.resource.data) &amp;&amp; !('spring-2026' in resource.data) &amp;&amp; !existsAfter(/databases/$(database)/documents/curriculum/lessons_spring-2026) &amp;&amp; get(/databases/$(database)/documents/curriculum/storageMigrations).data.get('spring-2026', {}).get('verified', false) != true</code>. Every split statement is constrained this way, because <code>allow</code> statements OR together.</p>
    85	<div class="bdd">Rules tests (studio-hub/rules.test.js), roles: teacher (classbook), classbook-admin, curriculum-admin, manager, admin.
    86	  lessonData update fall-2026.x.field                              → allowed (every role that can today)
    87	  lessonData update spring-2026.x.field                            → denied (every role)
    88	  lessonData update { spring-2026: delete } only                    → manager/admin allowed; others denied
    89	  lessonData update { spring-2026: delete, fall-2026.x: … }         → denied
    90	  lessonData whole-doc delete                                       → denied (every role)
    91	  lessonData create containing spring-2026                          → denied; create without it → as today
    92	  re-add spring-2026 after removal, plain                           → denied (every role)
    93	  rollback: manager/admin re-adds only spring-2026 AND deletes lessons_spring-2026 in one transaction, while unverified → allowed
    94	  the same rollback after verified                                  → denied
    95	  re-add spring-2026 without deleting lessons_spring-2026 in the same transaction → denied
    96	  lessons_spring-2026 create when absent                            → manager/admin allowed; others denied
    97	  lessons_spring-2026 update before verified                        → denied (every role); after verified → allowed as for lessons today
    98	  lessons_spring-2026 delete before verified                        → manager/admin allowed (rollback); teacher/classbook-admin/curriculum-admin denied
    99	  lessons_spring-2026 delete after verified                         → denied (every role)
   100	  storageMigrations write                                           → manager/admin only; read → classbook roles
   101	  every other /curriculum doc (appData, prepCycleConfig, prepData, cutProjects, changeLog, …) → exactly as today
   102	  A near-1 MB lessonData fixture built from many sub-fields, with its estimated size asserted, reset per mutating test: the allow/deny cases above evaluate correctly
   103	  The whole existing studio-hub suite passes</div>
   104	</div>
   105	
   106	<div class="phase" id="phase-b">
   710	// it is intentionally NOT fixed in this pass. This test documents and pins
   711	// the current (unsafe) behavior so a future fix has a red test to turn green,
   712	// and so nobody mistakes silence here for the gap having been closed.
   713	describe('Timeclock — KNOWN GAP: locked pay periods do not block entry edits at the rules layer', () => {
   714	  test('staff can still update their own entry inside a locked period', async () => {
   715	    const db = getDb(STAFF_TIMECLOCK_UID);
   716	    // If this ever starts failing, the gap has been closed — update this
   717	    // test to assertFails and remove the KNOWN GAP framing.
   718	    await assertSucceeds(updateDoc(doc(db, 'timeclock_entries', 'locked-period-entry'), {
   719	      type: 'clockOut',
   720	    }));
   721	  });
   722	});
   723	
   724	
   725	// ─── CLASSBOOK — appData PROTECTION ─────────────────────────────────────────
   726	
   727	describe('Classbook — appData protected from staff', () => {
   728	  test('staff with classbook access can read curriculum doc', async () => {
   729	    const db = getDb(CLASSBOOK_UID);
   730	    await assertSucceeds(getDoc(doc(db, 'curriculum', 'spring-2026')));
   731	  });
   732	
   733	  test('staff with classbook access can update curriculum doc', async () => {
   734	    const db = getDb(CLASSBOOK_UID);
   735	    await assertSucceeds(updateDoc(doc(db, 'curriculum', 'spring-2026'), { updated: true }));
   736	  });
   737	
   738	  test('staff with classbook access CANNOT update appData', async () => {
   739	    const db = getDb(CLASSBOOK_UID);
   740	    await assertFails(updateDoc(doc(db, 'curriculum', 'appData'), { settings: false }));
   741	  });
   742	
   743	  test('manager can update appData', async () => {
   744	    const db = getDb(MANAGER_UID);
   745	    await assertSucceeds(updateDoc(doc(db, 'curriculum', 'appData'), { settings: false }));
   746	  });
   747	});
   748	
   749	
   750	// ─── CLASSBOOK — WHOLE-DOCUMENT DELETE IS ADMIN-ONLY ────────────────────────
   751	// Fix applied in this pass: plain 'classbook' (teacher) access previously
   752	// could delete ANY curriculum doc outright — including another teacher's
   753	// entire semester. The app never calls a full-document delete for plain
   754	// teacher access (only FieldValue.delete() on specific lesson fields, which
   755	// is an update), so restricting delete to classbook-admin/curriculum-admin
   756	// closes an unused, high-blast-radius capability with no functional change.
   757	
   758	describe('Classbook — curriculum delete restricted to classbook-admin', () => {
   759	  beforeEach(async () => {
   760	    await testEnv.withSecurityRulesDisabled(async (ctx) => {
   761	      await setDoc(doc(ctx.firestore(), 'curriculum', 'delete-target'), { title: 'Section to delete' });
   762	    });
   763	  });
   764	
   765	  test('plain classbook (teacher) access CANNOT delete a curriculum doc', async () => {
   766	    const db = getDb(CLASSBOOK_UID);
   767	    await assertFails(deleteDoc(doc(db, 'curriculum', 'delete-target')));
   768	  });
   769	
   770	  test('classbook-admin access CAN delete a curriculum doc', async () => {
   771	    const db = getDb(CLASSBOOK_ADMIN_UID);
   772	    await assertSucceeds(deleteDoc(doc(db, 'curriculum', 'delete-target')));
   773	  });
   774	
   775	  test('manager can delete a curriculum doc', async () => {
   776	    const db = getDb(MANAGER_UID);
   777	    await assertSucceeds(deleteDoc(doc(db, 'curriculum', 'delete-target')));
   778	  });
   779	});
   780	
   781	// ─── CLASSBOOK — KNOWN GAP: no per-teacher field isolation in rules ─────────
   782	// Documented, accepted tradeoff (see the comment above the curriculum match
   783	// block in firestore.rules): each semester's lessons live in one shared doc,
   784	// so per-teacher write isolation is enforced by the UI only, not by these
   785	// rules. This is NOT fixed in this pass — it would require restructuring
   786	// curriculum data into per-teacher documents, which is a product/data-model
   787	// decision, not a rules tweak. This test pins the current behavior so it
   788	// stays visible and intentional rather than silently assumed.
   789	describe('Classbook — KNOWN GAP: any classbook-access teacher can write any other teacher\'s doc', () => {
   790	  test('staff with classbook access can update a curriculum doc regardless of which teacher "owns" it', async () => {
   791	    const db = getDb(CLASSBOOK_UID);
   792	    // spring-2026 is not "owned" by CLASSBOOK_UID in any rules-visible sense
   793	    // — there is no ownership field the rules check. This succeeding is the
   794	    // gap, tracked in firebase-agent-defense-hardening.md as an unresolved risk.
   795	    await assertSucceeds(updateDoc(doc(db, 'curriculum', 'spring-2026'), { touchedBy: 'someone-elses-teacher' }));
   796	  });
   797	});
   798	
   799	
   800	// ─── USERS — PRIVILEGE ESCALATION VIA SELF-WRITE (FIX APPLIED) ──────────────
   801	// Fix applied in this pass: the self-create/self-update rules previously
   802	// pinned only the `role` field. `appAccess` and `studios` were completely
   803	// unprotected, so any authenticated staff user could grant themselves access
   804	// to nearly every app on the platform (KPI, Classbook, Training, Roster
   805	// Manager, Summer Camp, Clay Hub, Social Media, Playbook, etc.) with a
  1340	    await assertSucceeds(getDoc(doc(db, 'summerCamps_seasons', '2026')));
  1341	    await assertSucceeds(getDoc(doc(db, 'summerCamps_seasons', '_current')));
  1342	  });
  1343	
  1344	  // The registry is read at startup, so "any active user" would have been the easy rule — and the
  1345	  // only one in this file a self-bootstrapped users doc could satisfy. It is deliberately the union
  1346	  // of the grants this section already hands out, so this denial is the point, not an oversight.
  1347	  test('a signed-in user with no grant in this section cannot read the registry', async () => {
  1348	    const db = getDb(STAFF_NOACCESS_UID);
  1349	    await assertFails(getDoc(doc(db, 'summerCamps_seasons', '_current')));
  1350	  });
  1351	
  1352	  test('an active user can list the registry (the Phase 2 season switcher reads it)', async () => {
  1353	    const db = getDb(TEAM_ONLY_UID);
  1354	    await assertSucceeds(getDocs(collection(db, 'summerCamps_seasons')));
  1355	  });
  1356	
  1357	  test('a signed-out visitor cannot read the registry', async () => {
  1358	    const db = getUnauthDb();
  1359	    await assertFails(getDoc(doc(db, 'summerCamps_seasons', '_current')));
  1360	    await assertFails(getDocs(collection(db, 'summerCamps_seasons')));
  1361	  });
  1362	
  1363	  test.each([
  1364	    ['an archived admin', () => ARCHIVED_ADMIN_UID],
  1365	    ['an archived manager', () => ARCHIVED_MANAGER_UID],
  1366	    ['an archived staff member', () => ARCHIVED_STAFF_UID],
  1367	  ])('%s cannot read the registry (active:false revokes it like everything else)', async (_label, uid) => {
  1368	    const db = getDb(uid());
  1369	    await assertFails(getDoc(doc(db, 'summerCamps_seasons', '_current')));
  1370	  });
  1371	
  1372	  test('the reminder bot cannot read the registry — it is never an active user', async () => {
  1373	    const db = getDb(REMINDER_BOT_UID);
  1374	    await assertFails(getDoc(doc(db, 'summerCamps_seasons', '_current')));
  1375	  });
  1376	});
  1377	
  1378	describe('Summer Camp — only manager+ may write the season registry', () => {
  1379	  test('a manager can create, update and delete a season doc', async () => {
  1380	    const db = getDb(MANAGER_UID);
  1381	    await assertSucceeds(setDoc(doc(db, 'summerCamps_seasons', '2099'), { season: '2099' }));
  1382	    await assertSucceeds(updateDoc(doc(db, 'summerCamps_seasons', '2099'), { name: 'Summer 2099' }));
  1383	    await assertSucceeds(deleteDoc(doc(db, 'summerCamps_seasons', 'disposable-for-delete')));
  1384	  });
  1385	
  1386	  test('an admin can create a season doc', async () => {
  1387	    const db = getDb(ADMIN_UID);
  1388	    await assertSucceeds(setDoc(doc(db, 'summerCamps_seasons', '2098'), { season: '2098' }));
  1389	  });
  1390	
  1391	  test.each([
  1392	    ['staff with summer-camp access', () => SUMMER_CAMP_UID],
  1393	    ['a prep-role user', () => SUMMER_PREP_UID],
  1394	    ['staff whose only grant is team', () => TEAM_ONLY_UID],
  1395	    ['staff with classbook access', () => CLASSBOOK_UID],
  1396	    ['staff with classbook-admin access', () => CLASSBOOK_ADMIN_UID],
  1397	    ['staff with no appAccess at all', () => STAFF_NOACCESS_UID],
  1398	    ['an archived manager', () => ARCHIVED_MANAGER_UID],
  1399	  ])('%s cannot create, update or delete a season doc', async (_label, uid) => {
  1400	    const db = getDb(uid());
  1401	    await assertFails(setDoc(doc(db, 'summerCamps_seasons', 'never-created'), { season: '2097' }));
  1402	    await assertFails(updateDoc(doc(db, 'summerCamps_seasons', '2026'), { numWeeks: 1 }));
  1403	    await assertFails(deleteDoc(doc(db, 'summerCamps_seasons', '2026')));
  1404	  });
  1405	
  1406	  test('nobody below manager can move _current — the switch-on is a manager act', async () => {
  1407	    for (const uid of [SUMMER_CAMP_UID, SUMMER_PREP_UID, TEAM_ONLY_UID, CLASSBOOK_ADMIN_UID]) {
  1408	      const db = getDb(uid);
  1409	      await assertFails(updateDoc(doc(db, 'summerCamps_seasons', '_current'), { season: '2027' }));
  1410	      await assertFails(deleteDoc(doc(db, 'summerCamps_seasons', '_current')));
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
     1	(async function() {
     2	  const db = firebase.firestore();
     3	  const lessonsRef = db.collection('curriculum').doc('lessonData');
     4	
     5	  console.log('Searching for Tues/Thurs Teacher lessons...');
     6	
     7	  const doc = await lessonsRef.get();
     8	  if (!doc.exists) {
     9	    console.log('No lesson data found.');
    10	    return;
    11	  }
    12	
    13	  const allData = doc.data();
    14	  const allLessons = allData['spring-2026'];
    15	  const keysToDelete = [];
    16	
    17	  for (const [key, lesson] of Object.entries(allLessons)) {
    18	    if (lesson.teacher === 'Tues/Thurs Teacher') {
    19	      keysToDelete.push(key);
    20	    }
    21	  }
    22	
    23	  if (keysToDelete.length === 0) {
    24	    console.log('No Tues/Thurs Teacher lessons found!');
    25	    return;
    26	  }
    27	
    28	  console.log('Found ' + keysToDelete.length + ' lessons. Deleting...');
    29	
    30	  const updatedLessons = { ...allLessons };
    31	  for (const key of keysToDelete) {
    32	    delete updatedLessons[key];
    33	  }
    34	
    35	  await lessonsRef.set({
    36	    'spring-2026': updatedLessons,
    37	    lastUpdated: new Date().toISOString(),
    38	    lastUpdatedBy: 'Christie (cleanup)'
    39	  }, { merge: true });
    40	
    41	  console.log('Successfully deleted ' + keysToDelete.length + ' lessons!');
    42	  console.log('Refresh the page to see changes.');
    43	})();

exec
/bin/zsh -lc "rg -n \"verified|storageMigrations|rollback|Phase C\" /Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-per-semester-lesson-storage.html | sed -n '1,180p'; rg -n \"lessonData.*(set|update)|lessonsRef|curriculumRef\" /Users/christiehubley/studio-hub --glob '"'!**/node_modules/**'"' --glob '*.{js,html}'" in /Users/christiehubley/studio-hub/.claude/worktrees/lessondata-spring-fence
 succeeded in 0ms:
41:  <strong>If headroom runs out early:</strong> the move itself is already a single step (Phase C), so the fastest safe route is to do Phases A and B promptly and run Phase C as soon as the 3-day stale-tab cutoff allows. Never remove Spring from <code>lessonData</code> before Phase B's code, which can read the new location, is live. Doing so would make Spring look empty, which is the May 2026 incident on purpose. Phase B adds a headroom readout, so nobody has to remember to paste a snippet.
44:<h2 id="today">What exists today (research, verified in review round 1)</h2>
68:  <li><strong>Spring edits stay paused, enforced by the rules, until the move is verified.</strong> A rule on <code>curriculum/lessons_spring-2026</code> allows updates only when <code>curriculum/storageMigrations</code> has <code>spring-2026.verified == true</code> (a <code>get()</code> on Spring writes only; Spring is dormant, so the cost is negligible). So nothing can change the new document between the copy and the verification: its hash is stable, and a rollback can't discard a real edit.</li>
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
114:      <li>If it disappears (a rollback), the app reloads Spring from the legacy source, or shows "reload the page" if that's gone too.</li>
118:  <li><strong>Writes to Spring:</strong> they go to <code>lessons_K</code> only when <code>storageMigrations.spring-2026.verified</code> is true, read by a small <code>storageMigrations</code> listener. Otherwise the app shows the "editing is paused" message; the rules refuse those writes anyway. <code>not-found</code> is handled the same way.</li>
119:  <li><strong>Counts come from one source per semester</strong> (Codex 5). <code>computeLiveContentCountByTeacher</code> uses <code>lessons_K</code> when it exists and skips <code>lessonData[K]</code>, otherwise the legacy map. There's never a dual-copy window anyway, but this protects against a failed rollback state.</li>
123:  <li><strong>Ratchet:</strong> no <code>doc('lessonData')</code> in the loaded scripts outside the helpers, the legacy load/listener and the dead backup helpers. <code>e2e/</code> is exempt. The seed gains a <code>lessons_spring-2026</code> + <code>storageMigrations</code> fixture set for the own-doc scenarios, and the default seed is unchanged.</li>
129:Scenario: Spring moved and verified works end to end (emulator)
133:Scenario: moved but not yet verified — edits paused
134:  Given lessons_spring-2026 exists, verified false
138:Scenario: the target doc disappears (rollback) → Spring falls back to legacy or "reload", never an empty grid
148:<h3>Phase C: move Spring in one step (production, one-off, manager) <span class="status-tag ready">execution-ready: true</span></h3>
158:  <li><strong>One transaction:</strong> read <code>lessonData</code>, <code>lessons_spring-2026</code> (which must not exist) and <code>storageMigrations</code>. Then:
162:      <li><code>tx.set(storageMigrations, { 'spring-2026': { movedAt, movedBy, lessonCount, sha256, verified: false } }, { merge: true })</code></li>
166:  <li><strong>If verification passes:</strong> <code>storageMigrations.spring-2026.verified = true</code>, and Spring becomes editable. Spot-check one Spring lesson in the Firebase Console.</li>
167:  <li><strong>If it fails:</strong> nothing has been edited since the copy, so the reverse transaction is safe: it puts <code>map</code> back into <code>lessonData</code>, which Phase A's rollback allowance permits (a manager/admin, only this key, only while unverified, and only together with deleting <code>lessons_spring-2026</code>), deletes <code>lessons_spring-2026</code>, and records the failure. The download from step 1 remains the last resort.</li>
170:  Then lessons_spring-2026 deep-equals the old map (+ lastUpdated*), lessonData has no spring-2026, storageMigrations records count + hash, verified → true, Spring editable, Fall untouched
174:<div class="note"><strong>The backup script edit (Christie gave permission for this change, Sep 29):</strong> <em>before</em> Phase C, and with Christie's go-ahead confirmed again at that moment, Claude adds the five lines recorded in the Decisions Log to <code>tinker-backups/backup.js</code> (<code>computeClassbookContentByTeacher</code>, just before <code>return counts;</code>). It keeps a <code>.bak</code> copy, checks the syntax with <code>node --check</code>, doesn't run the script, and touches nothing else, above all not the credential code. Because the move is one step, the backup never sees Spring twice.</div>
178:<div class="note">After Phase C, <code>lessonData</code> holds Fall (about 420 KB and growing). <strong>Before Spring 2027 is created</strong> (or before <code>lessonData</code> passes about 70%), a follow-up plan must:
189:  <li><strong>Rules:</strong> Phase A is a shared-rules change: tests for all five roles, a near-1 MB fixture, the whole suite green, then <code>deploy-rules.sh --approved &lt;sha&gt;</code> after the phrase. The new docs (<code>lessons_spring-2026</code>, <code>storageMigrations</code>) get explicit conditions in the <code>curriculum/{docId}</code> block.</li>
190:  <li><strong>Backups (checked Sep 29):</strong> <code>backup.js</code> fetches <em>every</em> document in each listed collection (<code>fetchCollection</code>, <code>:221-247</code>), so <code>lessons_spring-2026</code> and <code>storageMigrations</code> are in every 30-minute backup automatically. The Tier-1 count check counts documents, and <code>curriculum</code> gains two, so there's no false alarm there. The per-teacher content count is covered by the five-line edit.</li>
194:  <li><strong>Reversible:</strong> a reverse transaction until verified. After that, the download and backups.</li>
203:  <li><strong>Mid-C:</strong> the transaction either committed or didn't. If it committed but isn't verified, Spring is viewable, edits are paused, and the reverse transaction exists.</li>
210:  <li>Per phase: commit, run the full suite, then a second-model implementation review. Each deploy, the backup.js edit, and Phase C each need Christie's own yes. Phase A needs the sha phrase.</li>
215:  <strong>Sep 29, 2026: revision 5, EXECUTION-READY.</strong> Codex round 3 (<code>…-codex-r3.md</code>) confirmed fixes 2 and 3, and confirmed the rules design is implementable (<code>existsAfter</code>, all split statements constrained). Its single remaining item: the Phase A update-condition summary was missing the rollback branch, which is now added with Codex's exact form. All phases are marked execution-ready. Build waits for Christie's go-ahead. Deploys, the backup.js edit and Phase C each still need her own yes, and Phase A needs the sha phrase.
220:    <li>The rollback re-add is explicitly allowed for manager/admin, only while unverified and only with <code>lessons_spring-2026</code> deleted in the same transaction (<code>getAfter</code>). This replaces the test that contradicted it.</li>
221:    <li>Deleting the new document is manager/admin-only and only while unverified. Other roles are always denied, and everyone is denied after verification until the follow-up plan.</li>
226:  <strong>Sep 29, 2026: revision 3, after Codex's independent round 1 (<code>…-codex-r1.md</code>): NOT ready, 8-point minimum list, all verified and taken.</strong>
228:    <li>Adopted Codex's "simpler safe option": the copy and the old-copy removal are <strong>one transaction</strong>, with Spring edits paused by rule until the move is verified. That closes the verification/rollback race (1), the target-missing-at-delete risk (2) and double counting (5), since there's no dual-copy window, and Phases C and D merge.</li>
233:    <li>(8) Merged <code>storageMigrations</code> writes, target-disappearance behaviour, and a Firestore-size estimator for the readout with an 85% warning.</li>
239:  <strong>Sep 29, 2026: Christie's answers.</strong> (Q1) Spring 2026 being view-only from Phase A until Phase C is fine. (Q2) Christie will paste the <code>backup.js</code> change herself (option a) before Phase D. The exact lines, for <code>tinker-backups/backup.js</code> inside <code>computeClassbookContentByTeacher</code>, just before <code>return counts;</code>:
245:  It's generic over <code>lessons_*</code>, so Fall's later move needs no second edit. <code>tally</code> ignores non-lesson values (<code>lastUpdated</code> strings have no <code>.teacher</code>). Also: Christie asked whether Spring stays reachable after the move. Yes: it stays in every semester list and is fully viewable, and it's editable again after Phase C.
249:  <strong>Open questions for Christie:</strong> (Q1) Is it OK that Spring 2026 is read-only ("editing is paused") from Phase A until Phase C, probably a few days? (Q2) Will you make the small <code>backup.js</code> edit before Phase D, or accept one expected content-loss alarm for Spring teachers? (Q3, for the reviewer) Undoing a bad Phase C copy needs a whole-doc delete of <code>lessons_spring-2026</code>; today only classbook-admin/curriculum-admin may whole-doc delete (<code>:675-678</code>). Should Phase A's split give managers delete as well (they have it today through <code>:654</code>'s <code>write</code>)? The plan assumes yes: the split keeps manager delete.
/Users/christiehubley/studio-hub/test-alerts.js:98:  const curriculumRef = db.collection('curriculum').doc('lessonData');
/Users/christiehubley/studio-hub/test-alerts.js:99:  const doc = await curriculumRef.get();
/Users/christiehubley/studio-hub/test-alerts.js:117:  await curriculumRef.set({ qaData }, { merge: true });
/Users/christiehubley/studio-hub/test-alerts.js:143:  const curriculumRef = db.collection('curriculum').doc('lessonData');
/Users/christiehubley/studio-hub/test-alerts.js:144:  const doc = await curriculumRef.get();
/Users/christiehubley/studio-hub/test-alerts.js:150:    await curriculumRef.update({ qaData });
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
99,422
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
