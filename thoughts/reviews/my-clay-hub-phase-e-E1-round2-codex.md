codex
## Blocking

- `readTime` validation is not faithful to the contract. [link-contract-fixtures.test.js:87](/Users/christiehubley/my-clay-hub/tests/unit/link-contract-fixtures.test.js:87) accepts arbitrarily large seconds even though out-of-range timestamps must return 400, and rejects valid canonical negative Timestamp seconds. The rejected set has no seconds-range boundary cases. This could let E-2 implement a validator that throws while constructing a Firestore Timestamp instead of returning 400.

- The processed-pause reference differs from Membership Manager. [link-contract-fixtures.test.js:45](/Users/christiehubley/my-clay-hub/tests/unit/link-contract-fixtures.test.js:45) treats `scheduledAt: false` and `scheduledAt: 0` as processed, while Membership Manager uses `!!scheduledAt`, making both unprocessed. Add malformed/falsy `scheduledAt` cases and use the source test exactly.

- The 400 fixture set remains incomplete for Decision #75’s set rule. [build.py:343](/Users/christiehubley/my-clay-hub/tests/fixtures/link-contract/build.py:343) covers duplicate member items and an item/held collision, but not duplicate staff items or duplicate IDs within `held`. An E-2 receiver could mishandle either and still pass every fixture.

- Staff reconcile validation is internally inconsistent. Single-staff envelopes require a nonempty string `uid`, but [link-contract-fixtures.test.js:139](/Users/christiehubley/my-clay-hub/tests/unit/link-contract-fixtures.test.js:139) applies no equivalent UID check to staff reconcile items. A null/non-string UID is therefore considered valid by the reference. Pin it with rejected cases.

- Decision #75 is explicitly still pending Christie’s approval in [DECISIONS.md:92](/Users/christiehubley/my-clay-hub/docs/my-clay-hub/DECISIONS.md:92). Under the repository’s source-of-truth rule, the branches cannot merge while those new contract decisions remain unapproved.

## Verified

I found no wrong expected value among the existing member, profile, tombstone, staff, gate, conflict, trigger-skip, phone, or reconcile cases. The round-one value errors and named coverage gaps are otherwise resolved, including the stale tombstone prior time, nested source-only fields, precedence cases, trigger-side IDs, staff cases, held/abort outcomes, self-contained reconcile input, and replacement of the brittle phone check.

The files are byte-identical at SHA-256 `2a70759533b2a86c06fc900be9cba5ceace47a01ee2e1eb35d589bb31f32e66c`. The placeholders are clearly documented and should be straightforward for E-2/E-3. The my-clay-hub self-check passed all 12 tests. The studio-hub pin test could not run because the read-only sandbox prevented Jest from writing its cache; static inspection confirmed its hash and separate `test:contract` wiring.

NOT SAFE TO MERGE
