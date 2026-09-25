# Plan review — Classbook SDOC Phase 2A.1 + Phase 2B (design, revision 1)

## Plan under review
~/tinker-ai-configs/thoughts/plans/classbook-school-day-off-camps.html — review ONLY the sections
id="phase-2a1" (event-level materials checklist) and id="phase-2b" (teachers plan their days), plus the top
Decisions Log entry (Sep 25). Read the "model" section for context. Phases 1 and 2A are built and live;
do not re-review them except where 2A.1/2B interact with them.

## Code (read-only — do NOT edit anything)
- App: /Users/christiehubley/tinker-spring-curriculum @ 2894adf — js/app.js, js/firebase-data.js, e2e/ (Playwright on emulators)
- Rules: /Users/christiehubley/studio-hub/firestore.rules (dayOffCamps_* blocks), /Users/christiehubley/studio-hub/storage.rules
- The plan cites file:line at 2894adf. Verify claims against the code; say where a citation or claim is wrong.

## What I want reviewed
1. Data safety: can any 2A.1 or 2B path lose or corrupt a teacher plan, a materials list, ticks, or the sign-off doc?
   (Firebase invariants: targeted writes, never whole-doc overwrite of partial data; strip empty fields; await writes;
   forced read-back; photo delete only after a confirmed save.)
2. The saveSingleLesson() day-off branch: transaction that re-checks the camp still has the title, payload allow-list,
   identity stamped from the camp, no season stamp. Is this sound with the compat SDK and with 2A's camp-save rename
   transaction (firebase-data.js ~2394-2429) and 2A's tick/sign-off transactions on the SAME doc? Any race left?
3. Adding 'dayOff' to lessonStoreFor(): are all seven callers really made safe? Anything that would silently
   treat an SDOC key as weekly/camp?
4. Splitting openLessonModal() into a summer lookup + shared openPlanEditor(semKey, lessonKey): is the summer path
   truly behaviour-preserving? What in the ~700-line editor still assumes summer (seasonForSemester, campName ids,
   hub materials, unread maps, finishClose) that the table misses?
5. Teacher View: teacher list from camps, name matching, SDOC renderer, Plan complete by data-lesson-key; every
   `l.teacher === name` site that would misbehave for SDOC's joined teacher string — did the plan miss any?
6. Permissions: canEditDayOffPlan (planners + the camp's teachers) and read-only for prep (not hasPrepAccess) —
   consistent with the deployed rules and 2A's capability functions?
7. Publish toggle un-hiding: anything else gating SDOC as unpublishable?
8. 2A.1: reuse of setDayOffMaterialCheck/setDayOffCampSignoff/markDayOffCampComplete from a second modal —
   state/re-render hazards, pendingDayOffTicks keying, XSS.
9. Are the BDD scenarios sufficient to catch a partial implementation? What is missing?
10. Anything else I missed.

## Output format
Verdict per section (READY / CHANGES NEEDED). Then numbered findings, each: severity (HIGH/MEDIUM/LOW),
the plan text concerned, the code evidence (file:line), and the concrete fix. Keep it under ~1500 words.
Shared Firebase project tinker-hq-apps across many apps; tests must use emulators, never production.
