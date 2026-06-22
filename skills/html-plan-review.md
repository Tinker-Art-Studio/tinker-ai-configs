# HTML Plan Review

Use the local plan-reviewer daemon to publish plans and review them in the browser before execution.

## Service

- Runs at: http://127.0.0.1:4317
- Started automatically at login via: `brew services start nodaste-lab/plan-reviewer/plan-reviewer`
- Health check: `curl -fsS http://127.0.0.1:4317/health`
- If not running: `brew services restart nodaste-lab/plan-reviewer/plan-reviewer`

## Plan files

Store all plans in: `~/tinker-ai-configs/thoughts/plans/<slug>.html`

## Register a plan

```bash
plan-review register ~/tinker-ai-configs/thoughts/plans/<slug>.html \
  --repo auto --branch auto --commit auto
plan-review index
```

The CLI prints a `REQUIRED NEXT ACTION:` block with commands to run. Run them before continuing.

Open the printed review URL in the browser.

## After browser review

If the plan is ready to execute:
```bash
plan-review <plan-id> --execution-ready true
```

If not ready (open questions, unresolved risks): leave `execution-ready false` and fix the plan first.

## Adding agent comments

Find anchor targets:
```bash
plan-review show <plan-id> --json --url http://127.0.0.1:4317
```

Add a comment:
```bash
plan-review comments add <plan-id> \
  --plan-node-id <id-from-above> \
  --body "Your comment here" \
  --agent Claude \
  --json --url http://127.0.0.1:4317
```

## Deferred plans

When a plan is blocked (waiting on Christie, a dependency, or a decision):
```bash
plan-review defer <plan-id> --note "Blocked on: <reason>. Resume when: <condition>."
```

## Listing plans

```bash
plan-review index
```

## Downloading a plan for sharing

```bash
plan-review download <plan-id> --output ~/Desktop --url http://127.0.0.1:4317
```

## Integration with planning-workflow

The `/planning-workflow` skill describes when to create a plan and what to put in it. This skill describes the mechanics of publishing and reviewing. Use both together.
