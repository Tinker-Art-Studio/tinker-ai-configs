1. **Medium — existing UID can be silently dropped** — `js/app.js:478-479`  
   `!names[uid]` is not an ownership check. An existing UID such as `constructor` or `__proto__` is inherited from `{}`, so it is neither emitted by `Object.entries(names)` nor added as unknown. Once the list is marked loaded, Save removes that grant from `sharedWith`, affecting Classbook access. Fix: use `Object.create(null)`, `Map`, or `Object.hasOwn(names, uid)`.

2. **Low — duplicate unknown UIDs make removal ambiguous** — `js/app.js:479`, `js/app.js:447-450`  
   Duplicate known UIDs collapse to one checkbox, but duplicate unknown UIDs produce multiple identical checked boxes. Unchecking only one appears to remove the person but Save retains the other. Fix: deduplicate `existingSharedWith` before rendering and deduplicate collected values.

3. **Low — cache completeness is inferred incorrectly** — `js/app.js:488`, `js/app.js:13227`  
   A truthy `STAFF_NAMES` suppresses the users read even when `STAFF_INFO` is absent or stale. Existing co-teachers remain checked, so this does not silently drop them, but eligible staff disappear and existing staff may be mislabeled. Fix: populate both caches atomically and track an explicit loaded/version flag.

Other `STAFF_NAMES` callers only consume names and are unaffected.

The test at `e2e/curriculum-co-teachers.spec.js:158-179` proves its stated normal, unique-UID scenario, including labels and exact saved membership, but not duplicates, missing `STAFF_INFO`, or prototype-key UIDs.

not safe to ship: an inherited-property UID can be omitted from the controls and silently removed from shared Classbook access.
