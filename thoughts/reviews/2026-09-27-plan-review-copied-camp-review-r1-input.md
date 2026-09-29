## Plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/summer-camp-copied-camp-review.html — read it in full.

## Repo context
Summer Camp App at /Users/christiehubley/summer-camp-app (vanilla JS, Firebase compat SDK, season-scoped
collections via js/season.js). Phase 3A (js/carry-forward.js) copied 23 Summer 2026 camps into Summer 2027 in
production last night; every copied doc carries `carriedForwardFrom`. This small feature marks those copies
"Not yet reviewed for Summer 2027" until a manager clicks "Mark reviewed" in the curriculum editor.
Key collections: summerCamps_curriculum (shared read-only with The Classbook at
/Users/christiehubley/tinker-spring-curriculum), summerCamps_projects (Lesson Plans topics),
summerCamps_projectDetails, summerCamps_materials.

## What I want reviewed (design, verify claims against the actual code)
- Is deriving "unreviewed" from carriedForwardFrom + absent reviewedAt correct for all 23 production copies and
  for fresh 2027 camps? Any curriculum writer (app.js, camp-admin.js, carry-forward.js, anything else) that
  could drop or rewrite reviewedAt, or copy carriedForwardFrom onto a doc that isn't a copy (e.g. rename via
  camp-admin.js creating a new topic/curriculum)?
- Carry-forward: is adding reviewedAt/reviewedBy to FIELDS.curriculum.dropped enough? Other places that
  classify fields (data-safety, season-migration, completeness checker, receipts)?
- Past-season read-only, role gating (who sees the button; staff/prep/team roles that can view Curriculum),
  the editor's auto-save racing with the Mark reviewed write, stale in-memory camp objects
  (window.CURRICULUM_CAMPS) after marking.
- Phase 2 lookup by campTopic in Lesson Plans / Project Details / Materials — Coal Creek twin names, renames,
  duplicate names.
- Are the BDD scenarios enough to catch a partial implementation? What did I miss?

## Constraints
- Rules source: /Users/christiehubley/studio-hub/firestore.rules (summerCamps_curriculum at ~827)
- All apps share Firebase project tinker-hq-apps
- Tests only on emulators; no mock Firestore
- Do NOT edit any files. Output: numbered findings, each with severity (HIGH/MED/LOW), file:line evidence, and
  a concrete fix; end with one line "execution-ready" or "not execution-ready: <why>".
