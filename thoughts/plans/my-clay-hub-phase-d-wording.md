# D-3 wording — v2 (round-1 Codex fixes applied)

Round 1 (Codex, Sep 28): "ready after fixes". Current-text quotes confirmed accurate. Fixes applied here:
(a) CLAUDE.md sections that assume one project are edited directly instead of a blanket "applies to both";
(b) approval is bound to a project as well as a sha, everywhere;
(c) "staff in its /staff section" restored to the table;
(d) the table column says "Firestore rules source".
Kept from v1: hook message points to --status only (Codex: no loss, provided the new guard's --status prints
its project, the sentence and the exact command — added to the D-3 checks).

`<PROJECT_ID>` = whichever ID Google accepts. New guard path: `/Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh`.

---

## 1. `~/.claude/CLAUDE.md`

### 1a. "### Single source of truth" — replace its body
CURRENT body: "All Firestore security rules live in ONE file:" + the studio-hub path + "**Never edit rules anywhere else.** Not in the Firebase Console. Not in another project's directory. Only this file."

PROPOSED body:
```
Each Firebase project's Firestore rules live only in the one file listed for it under PROJECT STRUCTURE — KEY FACTS (for `tinker-hq-apps`: `/Users/christiehubley/studio-hub/firestore.rules`).
**Never edit rules anywhere else.** Not in the Firebase Console. Not in the other project's directory.
```

### 1b. "### Deploy — ONLY through the guard" — heading + first sentence only
CURRENT: "### Deploy — ONLY through the guard (since Sep 21 2026)" / "Every Firebase deploy for `tinker-hq-apps` goes through one script, callable from any cwd. It deploys a COMMIT Christie named, from a temporary git worktree of that commit — never the shared working tree:"

PROPOSED:
```
### Deploy — ONLY through that project's own guard (since Sep 21 2026)
Each project has its own guard (listed under PROJECT STRUCTURE); never use one project's guard for the other. Each is callable from any cwd and deploys a COMMIT Christie named, from a temporary git worktree of that commit — never the shared working tree. For `tinker-hq-apps`:
```
(The existing studio-hub command block and the paragraph after it stay as they are.)

### 1c. "### Approval phrase…" — heading + first sentence only
CURRENT: "### Approval phrase for production Firebase changes — REQUIRED, and sha-specific" / "Per the Firebase Backend Resilience Plan (…), **do not run `deploy-rules.sh --approved` until Christie has said "approved to change firebase <full 40-char sha>"** in the current session, naming exactly the commit to ship. `--status` prints that sentence so it is copy-paste. Approval of one sha never carries to another."

PROPOSED:
```
### Approval phrase for production Firebase changes — REQUIRED, sha-specific and project-specific
Per the Firebase Backend Resilience Plan (`firebase-backend-resilience-plan` memory), **do not run either guard with `--approved` until Christie has said "approved to change firebase <full 40-char sha>"** in the current session, naming exactly the commit to ship, after seeing that same guard's `--diff`. `--status` prints that sentence so it is copy-paste. An approval counts only for that sha AND that project's guard — never for another sha or the other project.
```
(The three bullets under it stay.)

### 1d. "### Before every rules deploy — run tests first" — replace the code block + first sentence
PROPOSED:
```
### Before every rules deploy — run that project's tests first
`npm test` in the project being deployed — `/Users/christiehubley/studio-hub` or `/Users/christiehubley/my-clay-hub`.
```
(The rest — "All tests must pass…" — stays.)

### 1e. "## FIREBASE CLI — SAFE DEPLOY PATTERNS" — one line added above the table
```
Examples use `tinker-hq-apps`'s guard; for `<PROJECT_ID>` use its own guard (`/Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh`) the same way.
```

### 1f. "## PROJECT STRUCTURE — KEY FACTS" — replace the whole section
```
## PROJECT STRUCTURE — KEY FACTS

### Firebase projects — exactly TWO
| Project | For | Firestore rules source (the only place to edit) | Deploy guard |
|---|---|---|---|
| `tinker-hq-apps` | Every staff app, including every NEW staff app | `/Users/christiehubley/studio-hub/firestore.rules` | `/Users/christiehubley/studio-hub/scripts/deploy-rules.sh` |
| `<PROJECT_ID>` | ONLY My Clay Hub: members, plus staff in its `/staff` section. No other app, ever. | `/Users/christiehubley/my-clay-hub/firestore.rules` | `/Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh` |

- One project for ALL staff apps, not one per app. Never create another Firebase project without Christie's explicit decision.
- The only link between them is the one-way `clayhub-link` functions (Membership Manager → `<PROJECT_ID>`).
- Each project uses its own rules file, tests and guard. Never use one project's file, guard or approval for the other.
- **`tinker-hq-apps` rules affect ALL staff apps at once** — a rules regression breaks every one of them
- **Christie calls "Tinker HQ" the Studio Hub app** — located at `/Users/christiehubley/studio-hub/`
```

---

## 2. `~/.claude/settings.json` autoMode — four entries

### Line 33 (soft_deny) — full replacement
```
Before running either Firebase deploy guard (`/Users/christiehubley/studio-hub/scripts/deploy-rules.sh --approved <full sha>` for tinker-hq-apps, or `/Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh --approved <full sha>` for <PROJECT_ID>): require that Christie has said the literal phrase "approved to change firebase <that full sha>" earlier in this session, after the session pasted that same guard's `--diff` output for her. An approval counts only for that sha and that project's guard; never use it with the other project's guard. Raw `firebase deploy` in any form is denied by a hook and refused by the CLI's predeploy byte-check; never work around either. Per the Firebase Backend Resilience Plan these are production changes and require explicit approval of the exact commit every time.
```

### Line 39 (hard_deny) — one sentence replaced
CURRENT: "The ONLY sanctioned way to deploy is the guard `/Users/christiehubley/studio-hub/scripts/deploy-rules.sh`, which deploys an approved commit from git and leaves a receipt."
PROPOSED: "The ONLY sanctioned way to deploy is that project's own guard — `/Users/christiehubley/studio-hub/scripts/deploy-rules.sh` (tinker-hq-apps) or `/Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh` (<PROJECT_ID>) — which deploys an approved commit from git and leaves a receipt."
Also: "Bare `firebase deploy` deploys every Firebase service in tinker-hq-apps at once" → "…in the target project at once".

### Line 46 (environment) — full replacement
```
Approval phrase for any production Firebase change: the literal phrase "approved to change firebase <full commit sha>" (Firebase Backend Resilience Plan). It counts only for that sha and that project. The sha is what that project's guard prints with `--status` (studio-hub's for tinker-hq-apps, my-clay-hub's for <PROJECT_ID>); `--diff` prints the change to paste when asking. Deploys run only through that guard.
```

### Line 47 (environment) — full replacement
```
Firebase deploys happen only through the project's own guard: `/Users/christiehubley/studio-hub/scripts/deploy-rules.sh` for tinker-hq-apps, `/Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh` for <PROJECT_ID> (both callable from any cwd; each deploys from a git worktree of the approved commit). Emulator and test commands run from that project's folder.
```

---

## 3. Hook refusal message (`firebase-deploy-hook.sh` lines 35–38) — message only
```
firebase deploy is gated (Firebase Backend Resilience Plan). Each project deploys only through its own guard, from any cwd — start with --status:
    tinker-hq-apps:  /Users/christiehubley/studio-hub/scripts/deploy-rules.sh --status
    <PROJECT_ID>:    /Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh --status
Christie's phrase is 'approved to change firebase <full sha>' — --status prints the exact sentence and command, and --diff the change to paste when asking. An approval counts only for that project's guard, never the other one. If you only meant to read text containing 'firebase deploy', use Read/Grep instead of Bash. See ~/.claude/CLAUDE.md → FIREBASE RULES.
```

---

## Checks added to D-3 (before the new guard is first used)
- Every `<PROJECT_ID>` filled with the ID Google accepted.
- New guard pinned to the my-clay-hub repo and project; its `--status` prints the project ID, the exact sentence and the runnable command (tested).
- `settings.json` still parses as JSON after the edit; the hook still denies a raw deploy (existing hook tests).

## Question for the round-2 reviewer
Are the round-1 fixes applied correctly and completely? Anything still contradictory, or anything that can be cut
without losing safety? Verdict: ready / ready after fixes / not ready.
