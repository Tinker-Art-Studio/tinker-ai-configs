# Planning Workflow

Use for any non-trivial feature, bug fix, data migration, or rules change. The goal is a reviewable, resumable plan before a single line of product code changes.

## When to invoke
- Any change that touches Firestore data, rules, or a bulk delete/import
- Any new feature spanning more than one file
- Any task where the right approach isn't immediately obvious

## Phase 1 — Research (read-only)

Do not write any product files in this phase.

1. Read the relevant app's `CLAUDE.md` and `AGENTS.md` (if present).
2. Read the key files: `js/app.js`, `index.html`, `firestore.rules` (from `/Users/christiehubley/studio-hub/firestore.rules`).
3. Identify: current state, what needs to change, what can break, what depends on this.
4. Check for existing tests — note if none exist (that's a gap to flag).
5. Confirm the Firestore collection name(s) involved and verify rules exist for them.

## Phase 2 — Write the plan

Create an HTML plan file at: `~/tinker-ai-configs/thoughts/plans/<slug>.html`

The plan must include:
- **Goal**: one-sentence outcome in user terms
- **Phases**: numbered, each with acceptance criteria written as user outcomes (not implementation steps)
- **BDD scenarios** for each phase: Given / When / Then for happy path, edge case, and failure path
- **Firebase safety checklist**: rules updated? snapshot before bulk ops? `updateDoc` not `setDoc`? empty fields stripped?
- **Completeness check**: what happens if this is interrupted mid-way?
- **Resume instructions**: how to pick this up in a new session
- **Decisions log**: append-only, for any choice made mid-execution

Mark each phase as `execution-ready: false` until a second-model review passes.

## Phase 3 — Register and review

```bash
plan-review register ~/tinker-ai-configs/thoughts/plans/<slug>.html \
  --repo auto --branch auto --commit auto
plan-review index
```

Open the printed URL. Review the plan in the browser before proceeding. Fix any issues in the HTML file — the reviewer live-links it.

If you have time, run `/second-model-review` on the plan before marking it execution-ready.

## Phase 4 — Execute, phase by phase

- Read the plan at the start of each phase.
- Execute only one phase at a time.
- After each phase: commit, run any existing tests, confirm behavior.
- Log deviations in the plan's Decisions log.
- Do NOT mark `execution-ready: true` until at least one review (browser or second-model) has passed.

## Firebase safety gates (required for any data-write phase)

Before executing any phase that writes, deletes, or migrates Firestore data:
1. Is there a Firestore emulator test covering this change? If not, write one first.
2. Is this a partial update? Use `updateDoc` — never `setDoc` without `{merge: true}`.
3. Does the target collection have a rule in `/Users/christiehubley/studio-hub/firestore.rules`?
4. If bulk delete or import: snapshot to a JSON backup file first.
5. After executing: spot-check one real document in the Firebase Console.

## Commit discipline

After every phase that changes files:
```bash
git add <specific files>
git commit -m "phase N: <what changed and why>"
```
Do not batch multiple phases into one commit.
