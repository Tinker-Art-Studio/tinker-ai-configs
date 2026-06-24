# How to Use the AI Dev OS — Quick Reference

*Copy this into Word or print it. This is your day-to-day cheat sheet.*

---

## THE CORE IDEA

You always work from HERE (the Claude terminal). The plan reviewer (browser) is a reading and commenting space — not a control panel. Skills run automatically based on what you ask for.

---

## FLOWCHART: Starting Any Task

```
You want to change something
           │
           ▼
    Is it a quick, obvious fix?
    (typo, label change, color)
           │
     ┌─────┴─────┐
    YES          NO
     │            │
     ▼            ▼
 Just say it   Describe what you want →
 in terminal   I run /planning-workflow
     │                  │
     │         I read the relevant code
     │         I write an HTML plan
     │         I give you a browser URL
     │                  │
     │         ┌────────┴────────┐
     │         │  You open URL   │
     │         │  Read the plan  │
     │         │  Comment if     │
     │         │  something's    │
     │         │  wrong or       │
     │         │  unclear        │
     │         └────────┬────────┘
     │                  │
     │         You come back here:
     │         "looks good, go" or
     │         "fix phase 2 — don't
     │          touch X collection"
     │                  │
     └──────────────────┤
                        ▼
              I execute, one phase at a time
                        │
              ┌─────────┴─────────┐
              │  Does it touch     │
              │  Firestore data,   │
              │  rules, or delete? │
              └─────────┬─────────┘
                  ┌─────┴─────┐
                 YES          NO
                  │            │
                  ▼            ▼
          I write a         I make
          failing test      the change,
          first (emulator)  test in
          then fix,         browser,
          then green        commit
                  │            │
                  └─────┬──────┘
                        ▼
                 I commit with a
                 clear message
                 and tell you what changed
```

---

## WHAT TO SAY IN THE TERMINAL

You don't need to type slash commands — just describe what you want in plain language. I know which skill to use.

| What you say | What I do |
|---|---|
| "I want to add X to the KPI app" | Run `/planning-workflow`, write a plan, give you the URL |
| "Fix the bug where Y shows blank" | Diagnose first, write a test if data is involved, fix it |
| "We're starting a new app for Z" | Run `/repo-bootstrap` to wire it up, then plan the build |
| "Go check my comments on the plan" | Run `plan-review queue list`, read your comments, reply and/or act |
| "Get a second opinion on this plan" | Run `/second-model-review`, report what it found |
| "Update the /product-principles skill" | Run `/skill-builder`, edit and push |
| "How does the timeclock app work?" | Run `/architecture-docs` to map it out |

---

## THE PLAN REVIEWER (Browser)

**URL:** http://127.0.0.1:4317  
**What it is:** A local web tool (no internet) where plans and reports live as readable documents.

```
IN THE BROWSER you can:            IN THE TERMINAL you can:
─────────────────────────          ────────────────────────
• Read plans clearly               • Ask me to check comments
• Click any section to comment     • Say "go ahead" or "change X"
• See my replies to your comments  • Ask what's in the plan queue
• Read reports (like the           • Describe new work
  Firebase Resilience Report)      • Check status
```

**If the reviewer isn't running** (after a reboot):
```
brew services restart nodaste-lab/plan-reviewer/plan-reviewer
```

**See all your plans:**
```
plan-review index
```

---

## THE SKILLS (what I know how to do)

| Skill | What it does | When it kicks in |
|---|---|---|
| `/planning-workflow` | Research → write plan → register in reviewer → execute by phase | Any non-trivial change |
| `/development-workflow` | Write failing test → fix → green → commit | Any Firestore write, rules change, or delete |
| `/product-principles` | Stack defaults, brand/color guide, app registry | New app, architecture decisions |
| `/html-plan-review` | How to register and manage plans in the reviewer | When working with plans |
| `/second-model-review` | Second Claude instance reviews a plan or change | Before risky deploys or data migrations |
| `/skill-builder` | Build or update skills | When a skill needs changing |
| `/repo-bootstrap` | Stamp CLAUDE.md + AGENTS.md into a new repo | Starting any new app |
| `/architecture-docs` | Map out how an app works | Onboarding, refactors, "how does X work?" |

---

## FIREBASE RULES — ALWAYS

These are automatic every time — you don't need to remind me:

```
❌ Never: firebase deploy
✅ Always: firebase deploy --only firestore:rules  (from ~/studio-hub/)
✅ Always: npm test first (all 29 must pass)
✅ Always: updateDoc for partial edits, never setDoc
✅ Always: snapshot before any bulk delete
```

**If data looks missing:** Check rules FIRST before assuming it was deleted.

---

## DAY-TO-DAY LOOP

```
Morning: Open terminal → Claude Code → describe what you want
   │
   ├── Simple change → I do it → done
   │
   └── Non-trivial → I write a plan → you review in browser
              │
              └── You say "go" → I execute phase by phase
                         │
                         └── Each phase: commit → you can verify
                                   │
                                   └── Next phase when you're ready
```

---

## YOUR APPROVAL PHRASE

For anything that pushes to GitHub, deploys to Netlify, or touches shared systems:

**Say: "yes, do it"**

For everything else (reading, planning, local changes, writing files): I just do it and tell you what I did.

---

## WHERE THINGS LIVE

| Thing | Location |
|---|---|
| Skills (source) | `~/tinker-ai-configs/skills/` |
| Skills (active) | `~/.claude/commands/` (symlinked) |
| Plans | `~/tinker-ai-configs/thoughts/plans/` |
| Brand guides | `~/Desktop/Logos, Branding, and Photos/` and `~/Downloads/` |
| Firebase rules | `/Users/christiehubley/studio-hub/firestore.rules` |
| Plan reviewer data | `~/.plan-reviewer/plan-reviewer.sqlite` |
| Skills on GitHub | https://github.com/Tinker-Art-Studio/tinker-ai-configs |
