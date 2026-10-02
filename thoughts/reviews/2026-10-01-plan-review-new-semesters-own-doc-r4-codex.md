# READY WITH FIXES

1. **Major — the rejected `appData`-absent create path remains in two instructions.**  
   **Evidence:** Revision 4 correctly requires refusal when `appData` is absent ([plan:68](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:68), [plan:202](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:202)), but Edge Cases still says creation merge-creates `appData` ([plan:278](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:278)), and the safety checklist still specifies a merge-set fallback ([plan:287](/Users/christiehubley/tinker-ai-configs/thoughts/plans/classbook-new-semesters-own-doc.html:287)).  
   **Fix:** Change both passages to require refusal with neither document created; restore/initialize `appData` separately from verified configuration.

The new `semesterInConfigAfter` update condition is otherwise safe: generic own-doc writes remain allowed for manager/admin and all three Classbook roles while membership exists; creation, roster slots, ordinary saves, Q&A, moves/cuts, and replies retain membership. Removal makes stale writes fail as intended. `lessons_spring-2026` remains under its literal rule and is unaffected. All round-3 findings are otherwise addressed.
