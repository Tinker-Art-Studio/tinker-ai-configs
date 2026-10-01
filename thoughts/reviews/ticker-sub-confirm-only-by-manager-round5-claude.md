I read v5 in full, both round‑4 reviews, and checked every v5 edit against the code it names. **No files edited, no tests run, nothing deployed** (repo treated as read‑only).

## Does each v5 edit resolve its round‑4 finding?

| Round 4 | v5 edit | Verdict |
|---|---|---|
| **M1** D1 message presumes authorship | `openedDates` + `dates-changed-elsewhere`, **checked before D1** | **Resolved, and the order is the load-bearing part.** Both-changed case: doc≠opened fires first, so the user never gets "Undo Sam" for someone else's move. Only-this-user case: doc==opened, so D1 still fires with the right advice. See M2/M3 below for two gaps in the *new* reason. |
| **M2** `:7485` has no `dates` arm | `saved.field === 'dates' ? 'its dates changed'` | Resolved. `app.js:7485`'s chain falls through to `'its schedule record changed'` today; the ratchet at `schedule-editor-wiring.test.js` only pins the tail (`so your edits were NOT saved…`), so the new arm needs its own pin — which the plan adds. |
| **M3** five shapes unreachable through the helper | helper owns the gate; literal `:7615` line given | Resolved on substance: with the gate inside, *real record* and *record without `subUid`* are now decided by the helper, so all five are assertable. One unspecified detail — M4 below. |
| **L1** close handlers | names `index.html:1183` (×) and `:1201` (Cancel) | Accurate: both are inline `getElementById('confirm-sub-modal').classList.remove('open')`. ✅ |
| **L2** re-add rebuilt `dates`/`email` | "restores the original entry **verbatim**" + can't-re-add limit | Right intent, but contradicts the declared `openedSubs` shape — M1 below. |
| **L3** move the re-add test claim | moved to the wiring ratchet | Right place, wrong line numbers — L3 below. |
| **L4/L6/L7/L8/L9/L10** | Phase 3 reasons; null-override ratchet; manager-re-confirm exception; status-before-confirmed note; D1 wording; unmatched-path note | All accurate against `firebase-data.js:800-803`, `app.js:7865`, `:7973`, `timeoff-schedule.js:194`. ✅ |
| **L5** mirror copies `normalizeRequestDates` | "the source ratchet pins both copies" | Overstated — L2 below. |

**No v5 edit introduces a wrong schedule write or a false confirmation.** Specifically re-checked: the verbatim re-add still only *re-states* `confirmed` (the link comes from the fresh doc via `schedule-helpers.js:992-994`), and a stale restore is still refused at step 1 in both directions; restoring a raw doc entry can't leak `subUid` into the write because `app.js:7372` re-maps to `{name,email,dates,confirmed}`; hoisting `resolveSubRosterMatch` out of the D3 gate is harmless (pure roster filter, `schedule-helpers.js:193-202`); the transaction's `expect.dates = carried.currentDates` is an identity compare against the same document, so no false refusal; the manager-re-confirm exception paragraph is accurate (`carryConfirmedSubs` re-appends at `:1031`, and the guard expects the read that saw it).

## BLOCKING
**None.**

## MEDIUM

**M1. The verbatim re-add is unimplementable as specified: `openedSubs`' declared shape holds no entry.**
The plan declares `openedSubs`: name → `{ confirmed, hasRecord }` twice (the one-rule paragraph, and Phase 1 Changes), then says the restore uses "its own `dates` and `email`, kept in `openedSubs`". Following the declared shape, an implementer can only rebuild — which is `addTimeOffSub`'s current behaviour (`app.js:7280-7285`: `dates` from `timeoffFormDates`, `email` from the picker), i.e. exactly the round‑4 L2 defect. Fix: declare `{ confirmed, hasRecord, entry }`, with `entry` the form-shaped copy already built at `:7068`, and say the restore pushes a copy of it (so a second ×/re-add cycle can't mutate the memory).

**M2. The new reason's message says "nothing was saved" — and it can fire at step 2, after a reversal has landed.**
Reachable: Ivy removes confirmed Sam and touches no dates → step 1 passes → `reverseConfirmedTimeOffSubs` lands (`app.js:7459`) → a manager moves the dates → the step‑2 read inside `carryCurrentSubs` (`:7473`) returns `dates-changed-elsewhere`. The plan gives that reason one unconditional wording ("…so nothing was saved. Close this form and reopen the request."), while the step‑2 paragraph separately says a step‑2 refusal is *not* clean and must carry "Any sub coverage removed above stays removed". A reason→message mapping (which the bullet list invites) reproduces the false "nothing was saved" that round‑3 B1 blocked v3 for. One clause: the per-reason wordings are step‑1 only; step 2 uses the single generic sentence for all three reasons.

**M3. `openedDates` has no stated source and no ratchet — and one plausible reading inverts the guard.**
"The request's dates as loaded" is ambiguous. Filled from `existingRequest.dates` it is safe (the form pushes *new* row objects at `app.js:7063`, so the document array is never mutated, and doc-vs-opened is an identity compare). Filled from `timeoffFormDates` it aliases live rows that the inline handlers mutate in place (`:7120-7122` `timeoffFormDates[i].partialStart=this.value`; `updateTimeOffDate`) — then `openedDates` tracks every edit, so **every legitimate date change refuses with "someone else changed the dates" and D1 never fires**. Nothing catches it: the wiring-ratchet list pins `openedSubs` reset + fill but never mentions `openedDates`, and neither call site's `openedDates` argument is pinned. Name the source array (copied, never `timeoffFormDates`) and add it to the ratchet list beside `openedSubs`.

**M4. `subMissingWriteNote` now owns the gate, but not whether it returns markup or text.**
The plan's literal line `const matchNote = subMissingWriteNote(s, resolveSubRosterMatch(s.name, employeeRoster).status)` replaces `app.js:7614-7625`, where `matchNote` is the whole `<div style="…color:var(--amber)…">` interpolated raw at `:7629`. A text-returning helper therefore renders D3's line unstyled — and D3's amber line is named as "the net for anything that slips through". `js/schedule-helpers.js` contains no markup today (no `<div`, no `style=`, no `escapeHtml`), so either the helper becomes the first, or the caller wraps (`const note = …; matchNote = note ? '<div …>'+note+'</div>' : ''`) — both keep the five shapes as helper assertions. Pick one. No escaping concern either way: the notes are constants and carry no name.

## LOW

**L1.** `dates-changed-elsewhere` has no confirmed-sub gate, so it refuses saves that v4 and today's code accept (form opens Oct 3 → someone else moves it to Oct 4 → reason-only save, no sub confirmed). That's an improvement — today `formData.dates` (`:7363`) silently writes Oct 3 back over the other person's change — but it's an unstated scope expansion: no acceptance bullet, no BDD (the new BDD has Sam confirmed), and the test list should add "with no confirmed sub".

**L2.** "The source ratchet pins both copies against `js/schedule-helpers.js`" describes a mechanism that doesn't exist. Today's ratchets pin the *sources* (`schedule-editor-wiring.test.js:987-993`, `:1403`); nothing reads `timeoff-sub-confirm.emulator.test.js`, whose `sameStructure` copy (`:37`) is held verbatim by comment and convention only. Say it's a new assertion, and list it in the wiring ratchets.

**L3.** Wrong test range for the re-add protection. `schedule-helpers.test.js:637-643` is "a record-less confirmed prior that is UN-TICKED or removed is queued too" — the opposite direction. The protection is `:618-627` (both sides confirmed → link carried, `toReverse` empty), with `:629-635` its record-less sibling. (The Tests section cites `:629-635` for the same file, so the two references disagree.)

**L4.** "Checked first" is stated only against D1; the order versus `subs-changed` is unspecified. Both refuse and both messages are reason-neutral, so nothing is unsafe — but the round‑1/round‑2 race BDDs assert "refused (subs-changed)", so the order needs to be decidable.

**L5.** Unstated whether the **reset** branch's `saveGuard` (`app.js:7448`) also gains `dates`; the named ratchet is the non-reset literal at `:7476`. As written the reset path still writes the form's dates over a concurrent change. Defensible (everything is reversed before any check could run) — worth one clause either way.

**L6.** The edit transaction compares `dates` **raw** through the generic loop (`firebase-data.js:865-868`), while both step checks and Phase 2's confirm guard normalize on purpose (round‑3 Claude M2). A concurrent save that only rewrites a legacy date shape therefore refuses with "its dates changed". In practice that save also rewrites `proposedSubs`, so it refuses anyway — but the asymmetry deserves the same one-line explanation Phase 2 got.

**L7.** The "…and Sam can't be added back from this form" condition must test the picker's actual contents: `openTimeOffForm` excludes the editor's own name (`app.js:7036`), so an admin editing a request that names *them* as the sub also can't re-add. The plan lists only "inactive roster entry, legacy free text".

**L8.** The manager-re-confirm exception is correct but silent: the save reports plain success with the editor's removal dropped and no notice. The plan's own standard elsewhere (`failedSubsNote`, "stays removed") is to name what didn't happen.

**L9.** Phase 3's guarded write passes `[read.status]` only, so a benign `approved → completed` auto-complete refuses the label change, where the edit path deliberately allows both (`:7448`). v5 at least now gives that refusal an honest message.

## Verdict

The v5 edits resolve all three round‑4 MEDIUMs on substance, and the new reason's **ordering before D1 is right** — it is what makes M1's fix work rather than just reword it. What's left is four clauses of plan text, three of them about the new mechanism itself: `openedSubs` must be able to hold the entry it now promises to restore (M1), the new reason needs the step‑2 "stays removed" wording (M2), `openedDates` needs a named source and a ratchet (M3), and the D3 helper needs to say markup or text (M4). None require another design round; none of the LOWs are safety-relevant.

Per the Tinker Ticker rule, no repo file may be edited without your written approval in session, and I made none.

**execution-ready: no** — four plan-text clauses short (M1–M4); no BLOCKING, and no v5 edit introduces a wrong schedule write, a false confirmation, or a contradiction with the rest of the plan.

Want me to write this up as `~/tinker-ai-configs/thoughts/reviews/ticker-sub-confirm-only-by-manager-round5-claude.md`? That's outside the repo, so it'll prompt — and say if that name is already someone else's.
