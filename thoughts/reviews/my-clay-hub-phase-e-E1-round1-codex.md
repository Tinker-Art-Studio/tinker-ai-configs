codex
I found no incorrect expected value among the cases currently present. The 17 member envelopes/doc pairs, two tombstones, ten staff cases, conflict envelope, and four reconcile envelopes agree with the written contract. The files are byte-identical with SHA-256 `003a7149…93`, and the nine My Clay Hub self-checks pass.

The change is still incomplete for E-1.

## Blocking

- **Case “active, every forbidden top-level field present” does not satisfy “every forbidden field at every nesting level.”** The nested source shapes omit real source-only fields that E-1 is supposed to prove cannot leak:

  - `scheduledPause`: no `loggedAt`.
  - `pauseHistory`: no `type`, `completedAt`, `autoStarted`, `lastBilling`, or `importedFrom`.
  - `scheduledCancellation`: no `loggedAt`.
  - An unknown sentinel field at each nested level would also prove normalization is allowlist-based rather than merely dropping today’s known fields.

  The incomplete inventory is visible in [build.py](/Users/christiehubley/my-clay-hub/tests/fixtures/link-contract/build.py:47).

- **The malformed-value matrix is incomplete.** Missing cases required by E-1 include:

  - A **processed `scheduledPause` with a malformed date**, especially the plan’s explicit numeric `endDate: 20270201`, on an `active` member, producing `endDate: "!malformed"`, `status: "review"`, and profile `pause: null`.
  - A non-list `pauseHistory` on a stage where pause validation is reached. The existing case “onboarding stage wins over malformed pause data” correctly produces `not_yet`, but it cannot pin the ordinary `review` behavior.
  - Reversed pause dates, which are individually valid strings but must derive `review`.
  - A `scheduledCancellation` object with missing/null `finalAccessDate` versus empty-string `finalAccessDate`; those have different absent/malformed meanings.
  - `touring` precedence over malformed pause data. Only `onboarding` is represented.
  - Removed/retired precedence over malformed nested data.
  - Trigger-side malformed/missing `memberId` outcomes. The only such cases are reconcile aborts.

  Relevant existing cases begin at [build.py](/Users/christiehubley/my-clay-hub/tests/fixtures/link-contract/build.py:102).

- **Decision #74’s staff-name rule is not fully pinned.** “staff with my-clay-hub in appAccess” proves trimming, but no granted user has a non-string `name` and expected `staff.name: null`. Missing malformed-user variants also include:

  - `appAccess` as an array containing a non-string.
  - Missing/non-string role.
  - `active: null`.
  - A staff-role user with absent `appAccess`, which must be ungranted.

  The current staff matrix is at [build.py](/Users/christiehubley/my-clay-hub/tests/fixtures/link-contract/build.py:173).

- **Held and abort fixtures lack exact outcome data.** “two live docs share a memberId” supplies `envelope: null`, and the reconcile includes the ID in `held`, but there is no `storedBefore`/expected stored result proving the held record is untouched. Likewise, the two abort cases have no expected “nothing sent/nothing stored” structure or logging metadata; their case names are effectively the only specification. That falls short of E-1’s “exact envelopes and stored documents” requirement for held/abort behavior. See [build.py](/Users/christiehubley/my-clay-hub/tests/fixtures/link-contract/build.py:163) and [build.py](/Users/christiehubley/my-clay-hub/tests/fixtures/link-contract/build.py:202).

- **The self-checks can pass with materially wrong fixtures.** In particular:

  - Member normalization is never recomputed from `sourceDocs`; the test only checks that the expected snapshot equals the expected stored document.
  - `deriveStatus` is run on the expected stored document, so it catches wrong expected status but not a wrong normalized snapshot.
  - `firstName` and `lastInitial` are never checked.
  - Profile tests do not assert the exact required shape or values for `name`, `email`, `memberSince`, `firstName`, `pause`, `finalAccessDate`, or timestamps.
  - Staff grant decisions are inferred from the expected envelope rather than independently evaluated from `source`.
  - `FX.conflicts` is not checked at all.
  - Abort checks assert only that `sourceDocs.length > 0`.
  - Reconcile checks rely on array positions and do not verify envelope keys, version, kind, read time, scope, item shapes, held validity, or abort results.
  - The phone test reimplements the expected algorithm against the hand-authored pair; it does not connect member source phones to their expected `phoneLast4`.
  - The studio-hub test checks only the hash and top-level `v`.

  These weaknesses are concentrated in [link-contract-fixtures.test.js](/Users/christiehubley/my-clay-hub/tests/unit/link-contract-fixtures.test.js:50) and [clayhub-link-contract.test.js](/Users/christiehubley/studio-hub/clayhub-link-contract.test.js:12).

## Should-fix

- **Add structural-type phone cases.** The current list covers common textual formats, `null`, and a number, but not boolean, array, or object values. Because `formatPhone` stringifies arbitrary input and source rules do not guarantee shape, “phones of every shape” is not fully demonstrated. See [build.py](/Users/christiehubley/my-clay-hub/tests/fixtures/link-contract/build.py:170).

- **Make reconcile fixtures self-contained.** The member and staff reconcile cases contain only expected envelopes; E-3 must reconstruct the input by combining separate `members`, `staff`, and `conflicts` sections. Supplying the complete `sourceDocs` alongside each reconcile expectation would make sender tests direct and prevent composition mistakes.

- **Use exact profile and tombstone shape assertions.** The profile test currently accepts missing required fields because it only checks that present keys belong to an allowlist. The member tombstone test similarly does not prove that all Q7-preserved snapshot fields remain or that no other keys survive.

- **Define a fixture materialization helper for `$readTime` and `$serverTime`.** The placeholders are documented, but E-2 cannot directly compare these JSON strings with Firestore `Timestamp` values. A shared test helper or explicit comparison convention would prevent each E-2 test from inventing its own substitution semantics. `$serverTime` must be treated as “a commit timestamp,” not a literal expected value.

## Nit

- The studio hash test is appended to the Firestore emulator-backed `test:rules` command even though it neither uses Firestore nor tests rules: [package.json](/Users/christiehubley/studio-hub/package.json:4). A small non-emulator contract test script would preserve the Phase E isolation boundary and avoid paying emulator startup cost for a hash check.

- The forbidden-phone assertion `!out.includes('555')` is brittle: it detects this fixture’s chosen phone fragments, not the rule “no more than four digits.” A legitimate last four such as `5555` would fail, while another leaked full number without `555` could pass.

NOT SAFE TO MERGE
