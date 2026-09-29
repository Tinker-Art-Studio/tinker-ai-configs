Reviewed `846501c..9b9221b`. I found six issues.

1. High — Short Spring sessions are priced as full semesters.

   `template.html@9b9221b:1203,1227` halves every `U26` series but ignores duration. In `hist-rows.txt`, Spring’s 7-week “Sewing Stuffies” and “Intro to Watercolors” should also be half-price.

   Concrete impact:

   - Sewing Stuffies `0/18`: offered is overstated by 9 units.
   - Intro to Watercolors `8/8`: filled and offered are each overstated by about 5.38 units.
   - Combined: Tinker is overstated by 5.38 filled and 14.38 offered units, changing both its percentage and “units to next” result.

2. High — A missing per-view target silently substitutes the wrong bonus thresholds.

   `template.html@9b9221b:1341` falls back to `{good:72, better:78, best:85}` whenever one nested view is missing from `GOALSDOC.levels`.

   If `levels.clayhub` is omitted or malformed, Clay Hub silently uses 72/78/85 instead of 78/84/90. At 75%, it could display “Good” even though the actual Clay Hub Good threshold is 78%. It should report that this view’s targets are missing.

3. High — The refresh can permanently discard a cancelled section.

   [refresh recipe:256](</private/tmp/claude-501/-Users-christiehubley-summer-camp-app/f6debd21-e5d2-45fb-a97f-e9a9f88ef55e/scratchpad/refresh-recipe-for-review.txt:256>) says to report a cancelled section that disappears from Sawyer, but does not carry its prior `RAW` row forward or abort. The full replacement at [line 317](</private/tmp/claude-501/-Users-christiehubley-summer-camp-app/f6debd21-e5d2-45fb-a97f-e9a9f88ef55e/scratchpad/refresh-recipe-for-review.txt:317>) then writes the newly scraped `RAW`.

   Scenario: Sawyer removes a cancelled card rather than retaining it as `0/0`. The refresh reports the omission but still overwrites the document without that row. The `CANCELLED` key survives, but the board, Goals calculation, and eventual historical freeze no longer have the section or its capacity.

4. Medium — Term-view rollups still include cancelled capacity.

   [template.html:1622](/Users/christiehubley/tinker-enrollment-board/template.html:1622) passes all filtered rows into the table and rollups. Although the headline tiles remove cancellations, [template.html:1935](/Users/christiehubley/tinker-enrollment-board/template.html:1935) recomputes the table footer from all rows, and [template.html:1994](/Users/christiehubley/tinker-enrollment-board/template.html:1994) does the same for day/time/location fill rates.

   With the existing Spring 2026 data:

   - Headline correctly uses `1111/1440`, or 77%.
   - Table footer uses `1111/1472`, or 75%.
   - The day/time/location charts distribute the 32 withdrawn seats into Wednesday, Thursday, and evening capacity.

   Thus the same term view presents contradictory fill rates.

5. Medium — Party counts can be overwritten by a partially rendered page.

   [refresh recipe:131](</private/tmp/claude-501/-Users-christiehubley-summer-camp-app/f6debd21-e5d2-45fb-a97f-e9a9f88ef55e/scratchpad/refresh-recipe-for-review.txt:131>) uses a fixed 3.5-second delay for both birthday-party pages. The only stated rejection check at [line 137](</private/tmp/claude-501/-Users-christiehubley-summer-camp-app/f6debd21-e5d2-45fb-a97f-e9a9f88ef55e/scratchpad/refresh-recipe-for-review.txt:137>) principally catches zero results.

   If a slow page has rendered one of five cards after 3.5 seconds, the nonzero result appears plausible and replaces the correct prior month. That silently alters both filled and offered party units. Step 3 already uses a content-based readiness loop; Step 3b needs an equivalent completeness/stability check.

6. Medium — Display rounding can claim the threshold percentage before it is reached.

   `template.html@9b9221b:1370` uses `toFixed(1)`, while `goalLevel` compares the unrounded percentage.

   Example: Together is actually 73.96% against a 74% Good line. The card displays `74.0% full` but says “Not yet at Good” and still requests units. For a bonus-facing screen, that is internally contradictory; the display should not round upward across a threshold.

Tests: the current working tree reports 12/12 passing with `npm test`. Those tests exercise the pure unit engine but not refresh retention, partial party rendering, per-view configuration fallback, or term-view integration.

The working tree changed concurrently during review; uncommitted edits now appear to address findings 1, 2, and 6. I made no file changes.
