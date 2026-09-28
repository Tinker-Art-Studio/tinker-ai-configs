Verdict: **CHANGES NEEDED**

One MEDIUM remains:

- The writer contract does not actually carry the two newly required inputs. The signature is still `saveDayOffProjectDetails(yearKey, campId, title, { details, links })`, although the surrounding text requires both mandatory `auth` and `expected` values. The same paragraph also incorrectly says “the rules’ planner condition matches”; the deployed lesson-data rule permits every `classbook` user to write ([firestore.rules](/Users/christiehubley/studio-hub/firestore.rules:699)). Revise the signature explicitly—e.g. `{ details, links, expected, auth }`—state that missing/invalid `auth` or `expected` refuses before writing, and remove the false rules claim. The Decisions Log’s statement that the authorization fix is fully folded is therefore premature.

The stale guard’s intended semantics are otherwise correct: `expected` is the immutable baseline from the popup’s initial server read, not the mutable `dayOffMaterialsView.plan`, which material operations refresh ([app.js](/Users/christiehubley/tinker-spring-curriculum/js/app.js:12920)). That distinction should remain explicit when adding it to the contract.

All other round-one HIGH/MEDIUM findings are correctly addressed: merge-set/delete behavior and absent-record no-op; explicit verifying read-back; separate details draft and expanded redraw/close tests; complete `n/a` helper/site coverage; SDOC-only editor placement; links-only protection; and the safe render path using URL protocol validation plus `sdocEscA`. HEAD is the requested `22ed027`; no files were changed.
