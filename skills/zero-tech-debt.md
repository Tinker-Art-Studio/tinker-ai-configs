# Zero Tech Debt

Rework a change as if the intended UX and architecture existed from day one — deleting compatibility cruft and accidental complexity instead of accumulating it. Source: [jnsahaj/skills](https://github.com/jnsahaj/skills/blob/main/skills/zero-tech-debt/SKILL.md).

## When to invoke

- Christie asks for a refactor, cleanup, or "do this properly" pass on an existing feature
- A feature has grown mode flags, wrapper functions, or fallback paths from being patched incrementally over time
- Before finishing a change that would otherwise leave a compatibility shim, an unused prop, or a dead code path behind "just in case"

Not for a first-time feature build with no prior shape to rework, and not for a quick bug fix that doesn't touch the surrounding design.

## Steps

1. **State the intended end state** in one or two sentences — what should this look like if it were built today, knowing everything you know now?

2. **Search for real callers before preserving compatibility.** Grep for actual usage of every mode, prop, wrapper, route alias, or fallback touched by this change. If nothing calls it, delete it — don't keep it "in case something needs it."

3. **Reshape around the final product surface.** Prefer one clear component or flow over mode flags bolted onto an existing one. Split code only when it creates an obvious boundary — state, layout, controls, or domain commands — not by habit.

4. **Move shared rules to one place.** Feature flags, permissions, route gating, URL state, and command naming should live in a single source, not be duplicated across pages or buried inside view components.

5. **Verify the intended flow**, including anything that depended on a deleted assumption — navigation, permissions, persisted state. A deleted fallback can break a path that wasn't obviously connected to it.

## Rules

- Optimize for the code that should exist, not the smallest diff from the old shape.
- Delete dead compatibility paths instead of making them better.
- Do not invent a generic framework for one feature.
- Keep the refactor scoped to what makes the final shape coherent — this is not a license to rewrite unrelated code.
- Prefer names that describe product intent over implementation history.

## Relationship to this repo's other conventions

This complements, not replaces, the Firebase safety invariants (`/development-workflow`) and planning gates (`/planning-workflow`) — a "zero tech debt" rework of a data-write path still needs a reviewed plan and a failing-test-first change, it doesn't skip either one.
