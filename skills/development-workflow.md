# Development Workflow

Required for any change that writes, deletes, or migrates Firestore data; changes `firestore.rules`; or performs a bulk import/delete. Optional but encouraged for all other changes.

## The rule

**No data-write change ships without a failing test that proves the change works on a real or emulated Firestore — never a mock.**

Mocks hide rule regressions. The May 2026 incident where apps showed empty data after a rules deploy is the canonical example.

## Setup — Firestore emulator

```bash
cd /Users/christiehubley/studio-hub
firebase emulators:start --only firestore
```

Emulator UI: http://localhost:4000  
Firestore endpoint: localhost:8080

For apps without an emulator test suite, write the test inline (Node.js + firebase-admin pointed at the emulator) before fixing the bug.

## Workflow for data-write / rules / delete changes

### Step 1 — Reproduce the problem
Write a test that calls the real Firestore emulator and fails with the current code.

```js
// test-<feature>.js — run with: node test-<feature>.js
process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';
const { initializeApp } = require('firebase/app');
const { getFirestore, doc, getDoc, setDoc, updateDoc } = require('firebase/firestore');
// ... connect to emulator, seed data, assert behavior
```

The test must fail before you touch product code. If it passes, the problem was already fixed or the test is wrong.

### Step 2 — Fix

Make the smallest change that fixes the problem:
- Partial updates: `updateDoc(ref, { field: value })` — never `setDoc(ref, fullObject)` unless intentional overwrite
- Strip empty/undefined fields before writing — Firestore stores them and they cause subtle bugs
- `await` every critical write — fire-and-forget writes cause data loss on page unload
- New collection → add a rule to `/Users/christiehubley/studio-hub/firestore.rules` in the same commit

### Step 3 — Green

Re-run the test. It must pass before proceeding.

### Step 4 — Rules test (if rules changed)

```bash
cd /Users/christiehubley/studio-hub && npm test
```

All 29 tests must pass. If any fail, fix the rules — never deploy failing rules.

### Step 5 — Spot-check in the app

Start the app locally (see repo's localhost port in CLAUDE.md or memory). Perform the action manually. Confirm data in the emulator UI or Firebase Console.

### Step 6 — Commit

```bash
git add <specific files>
git commit -m "fix: <what and why — reference the symptom, not just the mechanism>"
```

## Workflow for other changes (UI, logic, no Firestore writes)

1. Identify the acceptance criteria: what should the user see/do differently?
2. Make the change.
3. Start the local server and manually test the golden path + one edge case.
4. Commit with a clear message.

## Firestore safety invariants (always check)

| Rule | Why |
|------|-----|
| `updateDoc` for partial edits, not `setDoc` | `setDoc` silently deletes fields not in the payload |
| Strip `undefined` and empty-string fields before writes | Firestore stores them; they cause filter bugs |
| `await` all critical writes | Un-awaited writes vanish on page unload |
| Snapshot before any bulk delete or import | No undo in Firestore |
| New collection → new rule, same commit | No rule = silent deny = data appears missing |
| Never bare `firebase deploy` | Use `--only firestore:rules`; bare deploy overwrites everything |
| Rules source of truth: `/Users/christiehubley/studio-hub/firestore.rules` | Never edit in Console or elsewhere |

## Apps with Firestore emulator tests

- `studio-hub` — 29 rules tests via `npm test`
- All other apps: no emulator test suite yet (flag as a gap in the plan)
