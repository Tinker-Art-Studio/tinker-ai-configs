# Second-Model Review

Get an independent review of a plan or implementation from a second Claude Code instance. Use before marking any plan `execution-ready` or before shipping a non-trivial change.

## Available reviewer

Only Claude Code is installed. Codex CLI and OMP are not available.

## When to use

- Before marking a plan execution-ready
- Before pushing a non-trivial Firestore data migration
- Before deploying a rules change that affects multiple apps
- When you're uncertain whether an approach is correct
- Any time Christie asks for a second opinion

## How to run

### For a plan review

1. Write a concise review-input file:

```bash
cat > /tmp/review-input.md << 'EOF'
## Plan under review
[paste or reference the plan slug/path]

## What I want reviewed
- Is the approach safe given the Firebase safety invariants?
- Are there any phases that could cause data loss?
- Are the BDD scenarios sufficient to catch a partial implementation?
- What did I miss?

## Repo context
[app name, what it does, key Firestore collections involved]

## Constraints
- Rules source: /Users/christiehubley/studio-hub/firestore.rules
- All apps share Firebase project tinker-hq-apps
- No mock Firestore tests — must use emulator
EOF
```

2. Launch a second Claude Code instance:

```bash
claude --print < /tmp/review-input.md > /tmp/review-output.md
cat /tmp/review-output.md
```

3. Read the output critically. Claude is a reviewer, not an oracle — verify its claims against the code.

### For an implementation review

```bash
cat > /tmp/impl-review.md << 'EOF'
## Change under review
[describe what changed: which files, what the diff does]

## Acceptance criteria
[what should be true when this is correct]

## Firebase invariants to check
- Does this use updateDoc or setDoc? (updateDoc for partial edits)
- Are all writes awaited?
- Are empty fields stripped before writing?
- Does a new collection have a matching rule?

## Diff or key code
[paste the relevant diff or code sections]
EOF

claude --print < /tmp/impl-review.md > /tmp/review-output.md
cat /tmp/review-output.md
```

## What to do with the output

- If the reviewer finds a real issue: fix it before proceeding
- If the reviewer raises something that's already handled: note it in the plan's Decisions log with why it's not a concern
- Do not dismiss findings without verifying them against the actual code
- A passing review does not replace manual testing in the app

## Non-recursion rule

Do not run a second-model review from inside a second-model review session.
