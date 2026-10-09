Reading additional input from stdin...
OpenAI Codex v0.147.0
--------
workdir: /Users/christiehubley/tinker-timeclock
model: gpt-5.6-sol
provider: openai
approval: never
sandbox: read-only
reasoning effort: none
reasoning summaries: none
session id: 01a1227d-9ca5-7e20-808e-b5ad5e90157e
--------
user
## Plan under review
/Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-step4-lock-and-checked-writes.html
(read it in full). Repo: /Users/christiehubley/tinker-timeclock at commit 01c1b86 (main). Downstream consumer: /Users/christiehubley/payroll-tool/index.html (pullFromTimeclock ~line 2980).

## What I want reviewed (design review, before any code exists — you are READ-ONLY, do not edit any file)
- Verify every factual claim about current code against the real source (js/app.js, js/firebase-data.js, js/schedule-helpers.js, the tests). Cite file:line.
- Phase 1 (A): is a single Firestore transaction (read lockedPeriods + the entry, then write) the right enforcement point? Any admin/manager write path that changes HOURS in a locked period that the plan misses (e.g. other writes to timeclock_entries, approve paths, anything that changes `date`, `timestamp`, `type`, or changeRequest.status/requestedTime*)? Does calculateDayHours/calcPeriodTotals read any field the plan treats as "doesn't change hours"? Is fail-closed correct and complete? Any compat-SDK transaction gotcha (offline, persistence enabled via enableOfflinePersistence, retries, tx.set of a new doc id)?
- Is the vm-sandbox emulator harness (see pay-period-lock.emulator.test.js) able to exercise runTransaction + tx.update/delete/set as planned?
- Phase 2 (B): is the call-site table complete and correct? Any ignored write result missed (search all writers in firebase-data.js and direct getDb()/db.collection writes in app.js outside the kiosk)? Are the proposed failure behaviours right?
- Are the BDD scenarios sufficient to catch a partial implementation? Are the accepted residuals honestly stated?
- What did I miss? Anything that could cause data loss or a wrong payroll number?

## Constraints
- Rules source: /Users/christiehubley/studio-hub/firestore.rules (no rules change in this plan); project tinker-hq-apps shared by 21 apps
- Kiosk write paths are deliberately out of scope (owner decision)
- Tests that touch Firestore must use the local emulator; never production; never read ~/.config/configstore/firebase-tools.json

## Output
A verdict (READY / READY WITH CHANGES / NOT READY), then numbered findings each with severity (HIGH/MEDIUM/LOW), evidence (file:line), and a concrete fix. Be concise; no praise.
codex
I’ll do a read-only source audit of the full plan, every relevant writer/call site, calculation dependency, and emulator harness. I’ll cite exact lines and return only the verdict and actionable findings.
exec
/bin/zsh -lc "git rev-parse HEAD && git status --short && wc -l /Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-step4-lock-and-checked-writes.html && sed -n '1,240p' /Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-step4-lock-and-checked-writes.html" in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-8sPFh1mQ' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-OS7K6FFr' (errno=Operation not permitted)
01c1b86e1903eb3cdd24d787561846ef7e9753fc
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-kdkAy4YN' (errno=Operation not permitted)
git: warning: confstr() failed with code 5: couldn't get path of DARWIN_USER_TEMP_DIR; using /tmp instead
git: error: couldn't create cache file '/tmp/xcrun_db-d2P01Wjq' (errno=Operation not permitted)
     248 /Users/christiehubley/tinker-ai-configs/thoughts/plans/ticker-step4-lock-and-checked-writes.html
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Plan: Ticker Step 4 — locked periods stay locked, and failed saves say so</title>
<style>
  body { font-family: -apple-system, system-ui, sans-serif; max-width: 900px; margin: 32px auto; padding: 0 20px; color: #222; line-height: 1.5; }
  h1 { font-size: 24px; } h2 { font-size: 19px; margin-top: 32px; border-bottom: 1px solid #ddd; padding-bottom: 4px; } h3 { font-size: 16px; }
  code { background: #f4f4f4; padding: 1px 5px; border-radius: 4px; font-size: 13px; }
  .status { background: #eef5ff; border-left: 4px solid #2b6cb0; padding: 10px 14px; margin: 12px 0; }
  .bdd { background: #f9f9f9; border-left: 4px solid #999; padding: 8px 12px; margin: 8px 0; font-size: 14px; }
  .phase { border: 1px solid #ddd; border-radius: 8px; padding: 12px 16px; margin: 16px 0; }
  .decision-needed { background: #eafaf3; border: 1px solid #4EBFB3; border-radius: 8px; padding: 10px 14px; margin: 14px 0; font-size: 14px; }
  .warn { background: #fef9e7; border-left: 4px solid #e0b93a; padding: 10px 14px; margin: 12px 0; }
  table { border-collapse: collapse; margin: 12px 0; font-size: 14px; }
  th, td { border: 1px solid #ddd; padding: 6px 10px; text-align: left; vertical-align: top; }
  th { background: #f7f7f7; }
</style>
</head>
<body>
<h1>Plan: Ticker Step 4 — locked periods stay locked, and failed saves say so</h1>
<p><strong>App:</strong> Tinker Ticker (<code>~/tinker-timeclock</code>, project <code>tinker-hq-apps</code>) &middot;
<strong>Parent:</strong> Firebase Backend Resilience Plan, Step 4 (<code>firebase-backend-resilience-report.html</code>, plan_QTCn4wTWpk-h); proposal
<code>~/Desktop/tinker-tools-not-deployed/app-data-loss-detection-report.md</code> §3 &middot;
<strong>Drafted:</strong> Oct 9 2026 from <code>main</code> = <code>01c1b86</code> &middot; <strong>v1</strong> &middot;
<strong>execution-ready: false</strong> (awaiting second-model plan review)</p>

<div class="status">
  <strong>Approval:</strong> Christie gave written approval in chat on Oct 9 2026 ("approved to start the Tinker Ticker step 4 work"; then
  "we can do the A &amp; B and then save C, D, E for next session"). That covers editing files in <code>tinker-timeclock</code> for items A and B
  of this plan only. <strong>No rules change, no new collection, no Payroll Tool change.</strong> The Netlify deploy at the end still needs its own
  "okay to deploy tinker ticker &lt;full sha&gt;".
</div>

<div class="status">
  <strong>Goal:</strong> once a pay period is locked, its hours can't be changed from Ticker until someone unlocks it, so the locked
  totals payroll uses always match the punches underneath. And any manager or staff action whose save didn't reach the
  database says so, instead of looking done.
</div>

<h2>Where the August proposal stands (checked against <code>01c1b86</code>, Oct 9)</h2>
<table>
  <tr><th>Aug 14 item</th><th>Status now</th></tr>
  <tr><td>1. The seven save functions don't really wait for the write</td><td>✅ <strong>Done.</strong> All seven <code>await</code> their write and return <code>false</code> on failure (Phase 5 of an earlier Ticker plan, pinned in <code>firebase-data.failure.test.js</code>). <strong>Left over:</strong> about 15 call sites still ignore that <code>false</code>. That's <strong>B</strong> below.</td></tr>
  <tr><td>2. The lock is checked only in the two staff screens</td><td>Lock creation was fixed Sep 28–29 (read fresh → manager confirms the real numbers → a transaction that refuses a double lock).
      <strong>Still open:</strong> admin edit/delete/add of an entry and approving a time correction never check the lock. That's <strong>A</strong> below.</td></tr>
  <tr><td>3. <code>removeEmployee()</code></td><td>✅ Done (roster read before the splice; a failed roster save puts the person back; a failed schedule delete is named).</td></tr>
  <tr><td>4. An unchangeable snapshot/export at lock time</td><td>The snapshot of totals is done (transaction, malformed-total guard). The raw-entries export is <strong>D</strong>, deferred to next session.</td></tr>
  <tr><td>5. Sanity checks on staff edits</td><td><strong>C</strong>, deferred to next session.</td></tr>
  <tr><td>6. The database rules enforce the lock</td><td><strong>E</strong>, deferred. It belongs with the parked <code>ticker-firestore-rules-hardening.html</code>, since it needs a rules release.</td></tr>
</table>

<h2>Decisions already made (Christie, Oct 9)</h2>
<ul>
  <li><strong>The kiosk is out of scope.</strong> Its four clock writes already <code>await</code> directly, and changing the front-door flow is riskier than it's worth here. No in-flight display or double-tap guard is added there. (This settles the Aug §3.4 disagreement, part b.)</li>
  <li><strong>Multi-step saves are listed one by one with their risk</strong> (the table under Phase 2), not rewritten as transactions. Only a sequence whose partial failure would leave payroll or the roster wrong gets a targeted fix. (This settles §3.4 part a.)</li>
  <li><strong>Unlock → edit → relock is the way to change a locked period.</strong> Relock recomputes totals from the current entries. The Payroll Tool picks them up on the next "Pull from Timeclock" (which asks first, then discards manual Review adjustments). Explained to Christie in chat before she approved.</li>
</ul>

<h2>Current state (research, read-only)</h2>
<ul>
  <li><strong>Locks:</strong> <code>timeclock_settings/lockedPeriods</code>, one doc mapping <code>"YYYY-MM-DD_YYYY-MM-DD"</code> → <code>{lockedAt, lockedBy, employeeTotals}</code>.
    <code>isDateInLockedPeriod(dateStr)</code> (<code>js/app.js:1869</code>) compares strings against an in-memory copy refreshed only when timesheets or the staff entry list render.</li>
  <li><strong>Unchecked admin writes to hours:</strong>
    <code>adminEditSaveEntry</code> (2512, <code>updateClockEntry</code>), <code>adminEditDeleteEntry</code> (2581, <code>deleteClockEntry</code>, and no double-click guard),
    <code>adminEditAddEntry</code> (2600, <code>addClockEntry</code>, any date from the date picker), and <code>handleChangeRequest(…, 'approved')</code> (2711).
    Approval changes hours: <code>calculateDayHours</code> counts an approved missed-shift's requested times, and a time correction rewrites <code>timestamp</code>.</li>
  <li><strong>Writes to entries that don't change hours</strong> (unchanged here): change-request <em>denial</em>; staff <code>submitChangeRequest</code>/<code>submitMissingPunch</code> (pending, which counts for nothing until approved; the staff screens already block locked dates);
    excuse paths (<code>excused</code>/<code>flaggedForReview</code>/<code>clock*StreakAfter</code>); kiosk punches (always "now", and a locked period is in the past).</li>
  <li><strong>Rules:</strong> manager+ can write <code>timeclock_entries</code> and read <code>timeclock_settings</code>; nothing in the rules knows about locks (that's item E). This plan needs no rules change.</li>
  <li><strong>Tests:</strong> <code>npm test</code> runs jest inside <code>firebase emulators:exec --only firestore</code>. Data functions are tested by running the real <code>js/firebase-data.js</code> in a <code>vm</code> sandbox
    (against the emulator via the Admin SDK, see <code>pay-period-lock.emulator.test.js</code>, or against a fake db that can reject, see <code>firebase-data.failure.test.js</code>).
    <code>js/app.js</code> callers are pinned by source-wiring tests in <code>schedule-editor-wiring.test.js</code>. This plan follows both conventions.</li>
  <li><strong>Payroll Tool</strong> (<code>~/payroll-tool/index.html:2980</code> <code>pullFromTimeclock</code>) reads entries + <code>lockedPeriods[key].employeeTotals</code> on every pull. No field or format changes here, so no Payroll Tool change.</li>
</ul>

<!-- ═════════════════════════════════════════════ -->
<div class="phase">
<h2>Phase 1 — A: a locked period's hours can't be changed (execution-ready: false)</h2>

<h3>Acceptance criteria (user outcomes)</h3>
<ol>
  <li>A manager who edits, deletes or adds a clock entry on a day inside a locked period gets
      <em>"&lt;Day&gt; is in the locked pay period &lt;Sep 1 – Sep 15&gt; (locked by &lt;name&gt;). Nothing was changed. Unlock the period first, then lock it again after editing."</em>
      and the entry is unchanged in Firestore.</li>
  <li>Approving a time correction or missed-punch request for a locked day is refused the same way, and the request stays pending.
      <strong>Denying</strong> it still works, because a denial doesn't change hours.</li>
  <li>The check runs against the database at the moment of the save, not against what the screen loaded. A period locked in another tab after the editor opened is still respected.</li>
  <li>If the lock can't be confirmed (offline, read denied, any error), the save is refused with "Could not confirm whether this pay period is locked, so nothing was changed. Check your connection and try again." It fails closed.</li>
  <li>The admin entry editor shows a "🔒 This day is in a locked pay period: read-only" note and disables Save/Delete/Add when the editor opens on a locked day.
      That's a courtesy only. Criterion 1 is the real protection.</li>
  <li>Nothing changes for an unlocked period: same toasts, same re-render.</li>
</ol>

<h3>Design</h3>
<ul>
  <li><strong>Pure helper</strong> <code>lockedPeriodForDate(lockedMap, dateStr)</code> in <code>js/schedule-helpers.js</code> (already shared with tests via <code>module.exports</code>).
      It returns <code>{key, lockedBy, lockedAt}</code> or <code>null</code>, with inclusive start/end and a strict <code>YYYY-MM-DD</code> check on both the date and each key (a malformed key is skipped, never treated as locking everything).
      <code>isDateInLockedPeriod</code> becomes a one-line call to it, so the screens and the write share one rule.</li>
  <li><strong>Data layer</strong>, a new function in <code>js/firebase-data.js</code>:<br>
      <code>writeClockEntryIfUnlocked({ op: 'update'|'delete'|'add', entryId, updates, entry })</code> → <code>{ ok, reason, id?, period? }</code>.<br>
      It runs one <code>_db.runTransaction</code>:
      <ol>
        <li><code>tx.get(lockedPeriods)</code></li>
        <li>for <code>update</code>/<code>delete</code>: <code>tx.get(entry)</code>. If it's missing → <code>{ok:false, reason:'not-found'}</code>. The date checked is the <strong>stored</strong> <code>date</code>, never the caller's copy.
            For <code>update</code>, if <code>updates.date</code> is present and differs, both dates are checked (no admin path changes <code>date</code> today; this is defence against a future one).</li>
        <li>for <code>add</code>: the date checked is <code>entry.date</code>. If it isn't a valid <code>YYYY-MM-DD</code> → <code>{ok:false, reason:'bad-date'}</code></li>
        <li>if <code>lockedPeriodForDate</code> matches → <code>{ok:false, reason:'locked', period}</code> and nothing is written</li>
        <li>otherwise <code>tx.update</code> / <code>tx.delete</code> / <code>tx.set(newRef, entry)</code> (a new id from <code>.doc()</code>, the same shape <code>addClockEntry</code> writes today)</li>
      </ol>
      Any thrown error → <code>{ok:false, reason:'error'}</code>, logged. A transaction can't commit without the server, so an offline device fails closed by construction.
      A lock committed by another tab between our read and our commit makes Firestore retry the transaction, and the retry sees the lock.</li>
  <li><strong>Callers</strong> in <code>js/app.js</code>: the three <code>adminEdit*</code> functions and the <code>status === 'approved'</code> branch of <code>handleChangeRequest</code> call the new function instead of
      <code>updateClockEntry</code>/<code>deleteClockEntry</code>/<code>addClockEntry</code>. A shared <code>lockRefusalMessage(result)</code> turns <code>locked</code>/<code>error</code>/<code>not-found</code>/<code>bad-date</code> into the messages above.
      On a <code>locked</code> refusal the caller also refreshes the in-memory <code>lockedPeriods</code> and re-renders, so the screen catches up with the truth.
      The denial branch keeps <code>updateClockEntry</code>. <code>adminEditDeleteEntry</code> gains the same in-flight guard <code>adminEditSaveEntry</code> already has (<code>_aeeSaveInFlight</code>), and <code>adminEditAddEntry</code> disables its button while saving.</li>
  <li><strong>Editor courtesy note:</strong> <code>openAdminEntryEditor</code> reads <code>getLockedPeriods()</code> fresh when it opens. If the day is locked, it shows the note and disables the three controls. If that read fails, the editor stays enabled, since the write still fails closed.</li>
</ul>

<h3>BDD</h3>
<div class="bdd"><strong>Happy:</strong> Given Sep 1–15 is unlocked, when a manager changes Kaitlyn's Sep 3 clock-out to 5:00 PM with a reason, then the entry's timestamp updates, the toast says "Saved", and the timesheet re-renders as today.</div>
<div class="bdd"><strong>Locked edit:</strong> Given Sep 1–15 is locked by Anika, when a manager saves, deletes or adds an entry dated Sep 1, Sep 8 or Sep 15, then each is refused with the locked message naming Anika and the entry docs are byte-identical before and after.</div>
<div class="bdd"><strong>Boundary:</strong> Given Sep 1–15 is locked, when a manager adds an entry dated Sep 16 (or Aug 31), then it saves.</div>
<div class="bdd"><strong>Locked after opening:</strong> Given the editor was opened on an unlocked Sep 8, when another manager locks Sep 1–15 and this manager then presses Save, then it's refused (the transaction reads the lock at save time).</div>
<div class="bdd"><strong>Stale date:</strong> Given the screen's copy of an entry says Sep 16 but the stored doc says Sep 15 (locked), when it's edited, then it's refused (the stored date decides).</div>
<div class="bdd"><strong>Approval:</strong> Given a pending missed-shift request on a locked day, when a manager presses Approve, then it's refused, the request stays pending and no push is sent. When the manager presses Deny, the denial is saved and the push sent.</div>
<div class="bdd"><strong>Failure:</strong> Given the device is offline or the lock read is denied, when a manager saves an edit on any day, then it's refused with "Could not confirm whether this pay period is locked…" and nothing is written. The editor's Save is usable again afterwards.</div>
<div class="bdd"><strong>Gone:</strong> Given the entry was deleted elsewhere, when a manager saves an edit to it, then "That entry no longer exists — refresh" is shown and nothing is created.</div>
<div class="bdd"><strong>Malformed lock key:</strong> Given <code>lockedPeriods</code> holds a key <code>"oops"</code> alongside a real one, then only the real period locks anything.</div>
<div class="bdd"><strong>No lock doc:</strong> Given <code>timeclock_settings/lockedPeriods</code> doesn't exist (a fresh studio), then every edit saves (a missing doc means nothing is locked; it isn't an error).</div>

<h3>Tests (written first, red before the fix)</h3>
<ul>
  <li><code>pay-period-lock-writes.emulator.test.js</code> (new, added to <code>npm test</code>): the real <code>firebase-data.js</code> in the <code>vm</code> harness against the emulator. It covers every BDD above at the data layer: update/delete/add × locked/unlocked/boundary; stored date wins; not-found; malformed key; missing doc; doc contents compared before/after a refusal.</li>
  <li><code>firebase-data.failure.test.js</code>: a <code>runTransaction</code> that rejects → <code>{ok:false, reason:'error'}</code>, never a write.</li>
  <li><code>schedule-helpers.test.js</code>: <code>lockedPeriodForDate</code> covers inclusive edges, a malformed key, a malformed date, and an empty or missing map.</li>
  <li><code>schedule-editor-wiring.test.js</code>: the four call sites use <code>writeClockEntryIfUnlocked</code> and no longer call the old writers; the denial branch doesn't; <code>isDateInLockedPeriod</code> delegates to the helper; the delete in-flight guard exists.</li>
</ul>
</div>

<!-- ═════════════════════════════════════════════ -->
<div class="phase">
<h2>Phase 2 — B: a failed save never looks done (execution-ready: false)</h2>

<h3>Acceptance criteria</h3>
<p>For every call site below: when the save fails, the person sees a plain message saying what did NOT happen, the screen keeps showing the real state (no local
"success" update), and no follow-on step runs that assumes the save landed (a push, an email, a schedule migration). On success, behaviour is unchanged.</p>

<table>
  <tr><th>#</th><th>Where (<code>js/app.js</code>)</th><th>What ignores the result today</th><th>Change</th></tr>
  <tr><td>B1</td><td><code>completeTimeOff</code> 8784</td><td>Marks completed and reloads as if it worked</td><td>Check; on failure alert "Not marked complete — try again", no reload-as-success</td></tr>
  <tr><td>B2</td><td><code>reopenTimeOff</code> 8862</td><td>Same</td><td>Same pattern ("Not reopened")</td></tr>
  <tr><td>B3</td><td><code>autoCompletePassedTimeOff</code> 6950 (runs on load)</td><td>Sets <code>r.status='completed'</code> locally even if the write failed</td><td>Update local state only for writes that landed; failures are logged, with no alert (it retries on next load), and the request stays "approved" on screen</td></tr>
  <tr><td>B4</td><td><code>addTimeOffComment</code> 7895</td><td>Sends push + email for a comment that may not exist</td><td>Check; on failure keep the typed text, alert, send nothing</td></tr>
  <tr><td>B5</td><td><code>checkNameClaim</code> 5972–5973</td><td>Roster save and schedule migration both unchecked</td><td>Roster save fails → undo <code>claimedBy</code> locally, no migration, show the claim error. Migration fails → see table row M1</td></tr>
  <tr><td>B6</td><td><code>handleClaimName</code> 6066</td><td>Migration result ignored (roster save already checked)</td><td>See M1</td></tr>
  <tr><td>B7</td><td><code>mergeDuplicateRosterEntry</code> 6727</td><td>Shows "Merged" whether or not the roster saved</td><td>Check; on failure alert "Not merged — nothing changed", keep the old <code>employeeRoster</code></td></tr>
  <tr><td>B8</td><td><code>confirmAssignUser</code> 6771–6772</td><td>Roster save + migration unchecked, shows "Assigned"</td><td>Roster fails → alert, no migration, no local change. Migration fails → M1</td></tr>
  <tr><td>B9</td><td><code>excuseLateClockOut</code> / <code>excuseLateClockIn</code> 10577 / 10614</td><td>The entry's streak annotation (<code>clock*StreakAfter</code>) unchecked</td><td>Check; on failure a toast says the streak was restored but that entry's 🔥 number may show the old value. Low stakes, display only</td></tr>
  <tr><td>B10</td><td><code>trackLateClockOut</code> 652 (self-service late clock-out, not the kiosk)</td><td>Streak save result ignored</td><td>Check and <code>console.error</code> only. The clock-out itself already saved; the streak is cosmetic and the staff member shouldn't get an alarming popup. Logged as accepted</td></tr>
</table>
<p><em>Already fine, so no change:</em> 7872 <code>appendTimeOffComment</code> returns the result, and its callers check it. Every other site in the call-site sweep checks its result. Execution re-runs the sweep (<code>grep</code> for each writer) and adds any site found since <code>01c1b86</code> to this table before changing code.</p>

<h3>Multi-step saves: risk, case by case (Christie's decision 2)</h3>
<table>
  <tr><th>#</th><th>Sequence</th><th>If it stops halfway</th><th>Decision</th></tr>
  <tr><td>M1</td><td>Name claim / assign: roster <code>claimedBy</code> saved → then <code>migrateSchedule</code> copies <code>emp_*</code> schedule to the uid</td>
      <td>The person is linked but their schedule stays under the old id. Kiosk hours still merge by <code>claimedBy</code> (payroll is safe). Their shifts may not show under their name.</td>
      <td><strong>Targeted:</strong> check the result; on failure tell the manager/staff "Linked, but their schedule couldn't be moved. It still shows under the old entry; try Assign again or tell Christie." Retrying is safe: <code>migrateSchedule</code> returns true when there's nothing left to move.</td></tr>
  <tr><td>M2</td><td><code>approveTimeOff</code>: request status → schedule overrides</td><td>Already handled by Phases 3a/3b/4 of the time-off plans (<code>reversalPending</code>, checked reversals)</td><td>No change; recorded</td></tr>
  <tr><td>M3</td><td>Excuse: entry <code>excused</code> → streak doc → entry annotation</td><td>The streak is restored but the annotation is stale (display only); or the entry is excused but the streak isn't restored (it shows as a lost streak, fixable by excusing again)</td><td><strong>Accept + B9's message.</strong> No payroll effect</td></tr>
  <tr><td>M4</td><td><code>removeEmployee</code>: roster → schedule deletes</td><td>Already handled (Phase 5): named failure, recoverable from All Schedules</td><td>No change</td></tr>
  <tr><td>M5</td><td>Admin edit (Phase 1)</td><td>A single document per write, now in one transaction</td><td>n/a</td></tr>
</table>

<h3>BDD</h3>
<div class="bdd"><strong>Happy:</strong> Given a past approved time-off request, when a manager presses Mark Complete, then it shows Completed exactly as today.</div>
<div class="bdd"><strong>Failure:</strong> Given the write is denied, when a manager presses Mark Complete / Undo Complete / Merge / Assign, or posts a comment, then they see what was NOT done, the screen still shows the old state, and no push or email is sent.</div>
<div class="bdd"><strong>Edge:</strong> Given two passed requests on load and one write fails, then one shows Completed and the other stays Approved (not both Completed).</div>
<div class="bdd"><strong>Partial (M1):</strong> Given the roster save works and <code>migrateSchedule</code> fails, when a manager assigns an account, then the "Linked, but…" message shows and pressing Assign again later completes the move.</div>

<h3>Tests</h3>
<ul>
  <li><code>schedule-editor-wiring.test.js</code>, new describe block "Step 4 B: every save result is read": for each B-row, assert the call's result is bound and branched on, and that the success-only steps (push/email/<code>employeeRoster =</code>/<code>r.status =</code>/<code>migrateSchedule</code>) sit inside the success branch. This is the repo's convention for <code>app.js</code>.</li>
  <li>A sweep test: every <code>await saveEmployeeRoster(</code> / <code>updateTimeOffRequest(</code> / <code>migrateSchedule(</code> / <code>saveStreakData(</code> / <code>updateClockEntry(</code> call in <code>app.js</code> outside the kiosk block has its result used, so a future bare <code>await x(…);</code> fails the suite. The kiosk lines (<code>void updateClockEntry</code> at 9953/10370) are an explicit allowlist with the reason.</li>
</ul>
</div>

<!-- ═════════════════════════════════════════════ -->
<div class="phase">
<h2>Phase 3 — Release (execution-ready: false)</h2>
<ol>
  <li>A second-model <strong>implementation</strong> review after each of Phases 1 and 2 (both write payroll-adjacent data), with findings fixed before moving on.</li>
  <li>Bump the service-worker cache (<code>sw.js</code>) so open pages pick up the change.</li>
  <li>Push to <code>origin/main</code>; <code>npm run deploy:check</code>; ask Christie with the printed sentence; <code>npm run deploy -- --approved &lt;sha&gt;</code> only after "okay to deploy tinker ticker &lt;full sha&gt;".</li>
  <li>Live check with Christie, which can only be done in production: open a day in a <strong>locked</strong> period in the entry editor → read-only note; open an unlocked day → edit works as before. No real entry is changed for the check; she presses Save only on a test edit she chooses, or not at all.</li>
  <li>Update the parent plan's Step 4 status, CLAUDE.md (a short "Pay-period lock enforcement" note) and memory.</li>
</ol>
</div>

<h2>Firebase safety checklist</h2>
<ul>
  <li>Rules change? <strong>No.</strong> Manager+ already writes <code>timeclock_entries</code> and reads <code>timeclock_settings</code>. New collection? <strong>No.</strong></li>
  <li>Partial updates stay <code>update</code> (<code>tx.update</code>); the add is a new doc. No <code>set</code> without merge is introduced.</li>
  <li>Empty fields: the add writes the same object <code>adminEditAddEntry</code> builds today (no empty strings). The edit writes the same <code>updates</code> as today.</li>
  <li>Bulk delete/import? <strong>No.</strong> No snapshot needed.</li>
  <li>Emulator tests first, red before green (Phase 1 data layer); wiring tests for <code>app.js</code>.</li>
  <li>Payroll Tool: no field or format change. A refusal leaves raw entries unchanged, which is exactly what the Payroll Tool's discrepancy check assumes.</li>
  <li>Console spot-check after release: one locked period's <code>lockedPeriods</code> entry unchanged, and one entry Christie tried to edit (if any) unchanged.</li>
</ul>

<h2>Accepted residuals (disclosed, not fixed here)</h2>
<ul>
  <li><strong>Rules don't enforce the lock (E).</strong> Anyone with manager access could still change a locked day via the console or SDK. App-layer only, as the August proposal said.</li>
  <li><strong>An edit that lands between the manager's lock read and their confirm</strong> isn't in the snapshot they confirm. That's pre-existing and rare (two managers acting within seconds), and the Payroll Tool flags the hour discrepancy. Closing it would need the lock to re-read entries inside its transaction; noted for E/D.</li>
  <li><strong>Kiosk punches</strong> aren't lock-checked. They always write "now", and a period is locked only after it ends. If a manager locks the current period early, a later kiosk punch would land in it. Not something the app offers (the lock button is per past period), so this is noted rather than handled.</li>
  <li><strong>Staff screens</strong> keep their existing in-memory lock check. Their requests count for nothing until a manager approves, and approval is now checked.</li>
</ul>

<h2>Completeness: if interrupted midway</h2>
<ul>
  <li>Each phase is one commit (or a few) on <code>main</code>, pushed. Nothing is deployed until Phase 3, so a half-done phase changes nothing for staff.</li>
  <li>Phase 1 is safe to ship alone. Phase 2 doesn't depend on Phase 1.</li>
  <li>No data migration and no data written by this plan's code except through the normal app actions.</li>
</ul>

<h2>Resume instructions</h2>
<ol>
  <li>Read this file's Decisions log (bottom) and <code>git log --oneline -10</code> in <code>~/tinker-timeclock</code>. Commits are titled <code>step4 phase N: …</code>.</li>
  <li>Christie's written Ticker approval (Oct 9) covers A and B only. C, D and E need a new plan and her approval.</li>
  <li>Run <code>npm test</code> in <code>~/tinker-timeclock</code> (it starts the emulator itself). Check the printed count, not a hardcoded one.</li>
  <li>Deploy only via <code>npm run deploy:check</code> → Christie's "okay to deploy tinker ticker &lt;full sha&gt;" → <code>npm run deploy -- --approved &lt;sha&gt;</code>.</li>
</ol>

<h2>Next session (deferred by Christie, Oct 9)</h2>
<ul>
  <li><strong>C</strong>: sanity checks on staff time corrections (out before in, absurd length, how far back).</li>
  <li><strong>D</strong>: a raw-entries export at lock time; scope what's needed beyond <code>employeeTotals</code>.</li>
  <li><strong>E</strong>: rules-layer lock enforcement; fold into <code>ticker-firestore-rules-hardening.html</code>.</li>
</ul>

exec
/bin/zsh -lc "rg -n \"function (calculateDayHours|calcPeriodTotals|adminEdit|handleChangeRequest|completeTimeOff|reopenTimeOff|autoCompletePassedTimeOff|addTimeOffComment|checkNameClaim|handleClaimName|mergeDuplicateRosterEntry|confirmAssignUser|excuseLateClockOut|excuseLateClockIn|trackLateClockOut)|async function (calculateDayHours|calcPeriodTotals|adminEdit|handleChangeRequest|completeTimeOff|reopenTimeOff|autoCompletePassedTimeOff|addTimeOffComment|checkNameClaim|handleClaimName|mergeDuplicateRosterEntry|confirmAssignUser|excuseLateClockOut|excuseLateClockIn|trackLateClockOut)|updateClockEntry\\(|deleteClockEntry\\(|addClockEntry\\(|getDb\\(|\\.collection\\(['\\\"]timeclock_entries|saveEmployeeRoster\\(|updateTimeOffRequest\\(|migrateSchedule\\(|saveStreakData\\(\" js/app.js js/firebase-data.js js/schedule-helpers.js tests package.json" in /Users/christiehubley/tinker-timeclock
 exited 2 in 0ms:
rg: tests: No such file or directory (os error 2)
js/schedule-helpers.js:1266:// because migrateSchedule() failures during claiming are swallowed. handleAiSaveEdits() and the kiosk
js/schedule-helpers.js:1539:// and migrateSchedule() copies from the first to the second on claim. A time-off request records
js/firebase-data.js:26:function getDb() {
js/firebase-data.js:32:async function addClockEntry(entry) {
js/firebase-data.js:35:    const ref = _db.collection('timeclock_entries').doc();
js/firebase-data.js:56:    const snap = await _db.collection('timeclock_entries')
js/firebase-data.js:72:    const snap = await _db.collection('timeclock_entries')
js/firebase-data.js:86:  return _db.collection('timeclock_entries')
js/firebase-data.js:104:    let query = _db.collection('timeclock_entries')
js/firebase-data.js:132:async function updateClockEntry(docId, updates) {
js/firebase-data.js:135:    await _db.collection('timeclock_entries').doc(docId).update(updates);
js/firebase-data.js:143:async function deleteClockEntry(docId) {
js/firebase-data.js:146:    await _db.collection('timeclock_entries').doc(docId).delete();
js/firebase-data.js:467:// Schedule documents that migrateSchedule() / reassignSchedule() created FROM the given id — directly
js/firebase-data.js:516:async function saveEmployeeRoster(roster) {
js/firebase-data.js:530:async function migrateSchedule(oldId, newUid) {
js/firebase-data.js:671:    const snap = await _db.collection('timeclock_entries')
js/firebase-data.js:751:async function updateTimeOffRequest(docId, updates) {
js/firebase-data.js:831:// dependency rather than reaching for getDb() directly.
js/firebase-data.js:843:// Conditional sibling of updateTimeOffRequest(): applies `updates` only if the request's CURRENT status
js/firebase-data.js:917:async function saveStreakData(updates) {
js/app.js:619:async function trackLateClockOut() {
js/app.js:652:    await saveStreakData(updates);
js/app.js:675:  const id = await addClockEntry(entry);
js/app.js:704:  const id = await addClockEntry(entry);
js/app.js:740:  const id = await addClockEntry(entry);
js/app.js:770:  const id = await addClockEntry(entry);
js/app.js:799:  const id = await addClockEntry(entry);
js/app.js:1192:  const success = await updateClockEntry(crTargetEntryId, {
js/app.js:1271:    success = await addClockEntry({
js/app.js:1311:    success = await addClockEntry(entry);
js/app.js:1690:    if (await saveStreakData(streak)) {
js/app.js:1750:    if (await saveStreakData(streak)) {
js/app.js:1945:function calculateDayHours(entries) {
js/app.js:2030:function calcPeriodTotals(allEntries, roster) {
js/app.js:2115:    const streaksSnap = await getDb().collection('timeclock_streaks').get();
js/app.js:2445:    const db = getDb();
js/app.js:2446:    const snap = await db.collection('timeclock_entries')
js/app.js:2512:async function adminEditSaveEntry(entryId) {
js/app.js:2556:    ok = await updateClockEntry(entryId, updates);
js/app.js:2581:async function adminEditDeleteEntry(entryId) {
js/app.js:2589:  const ok = await deleteClockEntry(entryId);
js/app.js:2600:async function adminEditAddEntry() {
js/app.js:2625:  const id = await addClockEntry(entry);
js/app.js:2711:async function handleChangeRequest(entryId, status) {
js/app.js:2717:    const doc = await getDb().collection('timeclock_entries').doc(entryId).get();
js/app.js:2760:  const success = await updateClockEntry(entryId, updates);
js/app.js:2979:  const db = getDb();
js/app.js:3847:        const snap = await getDb().collection('timeclock_schedules').doc(editingScheduleUid).get();
js/app.js:3980:      await getDb().collection('timeclock_schedules').doc(editingScheduleUid).set(
js/app.js:4227:    const db = getDb();
js/app.js:4237:        // same field migrateSchedule() writes. Without it a reassigned schedule was invisible to both
js/app.js:4968:    await getDb().collection('timeclock_hfwa').doc(docId).update({
js/app.js:5038:    const configDoc = await getDb().collection('timeclock_settings').doc('appConfig').get();
js/app.js:5047:    const streaksSnap = await getDb().collection('timeclock_streaks').get();
js/app.js:5132:    const configRef = getDb().collection('timeclock_settings').doc('appConfig');
js/app.js:5952:async function checkNameClaim() {
js/app.js:5972:    await saveEmployeeRoster(employeeRoster);
js/app.js:5973:    await migrateSchedule(match.id, currentUser.uid);
js/app.js:6022:async function handleClaimName() {
js/app.js:6056:  const saved = await saveEmployeeRoster(freshRoster);
js/app.js:6066:  await migrateSchedule(empId, currentUser.uid);
js/app.js:6094:    await getDb().collection('timeclock_settings').doc('appConfig').set({
js/app.js:6139:    const success = await saveEmployeeRoster(roster);
js/app.js:6184:  const success = await saveEmployeeRoster(employeeRoster);
js/app.js:6252:    const db = getDb();
js/app.js:6413:  const db = getDb();
js/app.js:6471:  const db = getDb();
js/app.js:6590:    const db = getDb();
js/app.js:6633:    const db = getDb();
js/app.js:6654:    if (!(await saveEmployeeRoster(employeeRoster))) {
js/app.js:6703:async function mergeDuplicateRosterEntry(unclamedId, name) {
js/app.js:6727:    await saveEmployeeRoster(freshRoster);
js/app.js:6764:async function confirmAssignUser(empId, uid) {
js/app.js:6771:    await saveEmployeeRoster(freshRoster);
js/app.js:6772:    await migrateSchedule(empId, uid);
js/app.js:6950:async function autoCompletePassedTimeOff() {
js/app.js:6955:    await updateTimeOffRequest(r.id, {
js/app.js:7466:      existingDoc = await getDb().collection('timeclock_timeoff').doc(editingTimeOffId).get();
js/app.js:7576:      success = await updateTimeOffRequest(editingTimeOffId, formData);
js/app.js:7646:    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
js/app.js:7853:    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
js/app.js:7872:  return updateTimeOffRequest(requestId, { comments: firebase.firestore.FieldValue.arrayUnion({
js/app.js:7877:async function addTimeOffComment(requestId) {
js/app.js:7883:    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
js/app.js:7895:    await updateTimeOffRequest(requestId, { comments });
js/app.js:7940:    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
js/app.js:8454:      result = { success: await updateTimeOffRequest(requestId, { coverageStatus: status }) };
js/app.js:8471:    result = { success: await updateTimeOffRequest(requestId, { coverageStatus: status }) };
js/app.js:8562:        // Pre-extraction this was a thrown read (or, with _ready false, a TypeError from a null getDb())
js/app.js:8666:    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
js/app.js:8681:  const wrote = await updateTimeOffRequest(requestId, {
js/app.js:8724:    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
js/app.js:8745:    const wrote = await updateTimeOffRequest(requestId, {
js/app.js:8784:async function completeTimeOff(requestId) {
js/app.js:8787:  await updateTimeOffRequest(requestId, {
js/app.js:8816:    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
js/app.js:8828:    const wrote = await updateTimeOffRequest(requestId, {
js/app.js:8862:async function reopenTimeOff(requestId) {
js/app.js:8863:  await updateTimeOffRequest(requestId, {
js/app.js:9461:    const db = getDb();
js/app.js:9620:  const db = getDb();
js/app.js:9751:  const db = getDb();
js/app.js:9783:        db.collection('timeclock_entries')
js/app.js:9901:  const db = getDb();
js/app.js:9923:    const entryRef = await db.collection('timeclock_entries').add({
js/app.js:9953:      void updateClockEntry(entryRef.id, {
js/app.js:9971:    const db = getDb();
js/app.js:10002:  const db = getDb();
js/app.js:10078:  const db = getDb();
js/app.js:10334:  const db = getDb();
js/app.js:10358:    const outRef = await db.collection('timeclock_entries').add(entry);
js/app.js:10370:        void updateClockEntry(outRef.id, {
js/app.js:10387:  const db = getDb();
js/app.js:10395:    await db.collection('timeclock_entries').add({
js/app.js:10414:  const db = getDb();
js/app.js:10422:    await db.collection('timeclock_entries').add({
js/app.js:10554:async function excuseLateClockOut(entryId, uid) {
js/app.js:10556:    const db = getDb();
js/app.js:10557:    const entrySnap = await db.collection('timeclock_entries').doc(entryId).get();
js/app.js:10559:    await db.collection('timeclock_entries').doc(entryId).update({ excused: true, flaggedForReview: false });
js/app.js:10577:        await updateClockEntry(entryId, { clockOutStreakAfter: restoredOutStreak });
js/app.js:10591:async function excuseLateClockIn(entryId, uid) {
js/app.js:10593:    const db = getDb();
js/app.js:10594:    const entrySnap = await db.collection('timeclock_entries').doc(entryId).get();
js/app.js:10596:    await db.collection('timeclock_entries').doc(entryId).update({ excused: true, flaggedForReview: false });
js/app.js:10614:        await updateClockEntry(entryId, { clockInStreakAfter: restoredInStreak });
js/app.js:10634:    const doc = await getDb().collection('timeclock_streaks').doc(uid).get();
js/app.js:10659:    await getDb().collection('timeclock_streaks').doc(uid).update({
js/app.js:10697:    await getDb().collection('timeclock_streaks').doc(uid).set(
js/app.js:10717:    const snap = await getDb().collection('timeclock_streaks').get();
js/app.js:10755:    const overrideSnap = await getDb().collection('timeclock_overrides').doc(uid).get();
js/app.js:10777:    await getDb().collection('timeclock_overrides').doc(_adminExtendUid).set({
js/app.js:10797:    await getDb().collection('timeclock_overrides').doc(_adminExtendUid).delete();

exec
/bin/zsh -lc "rg --files | rg '(test|spec)\\.js"'$|package'"\\.json"'$|firebase-data'"\\.js"'$|app'"\\.js"'$|schedule-helpers'"\\.js"'$'"'" in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
reminder-flag.emulator.test.js
schedule-editor-wiring.test.js
timeoff-sub-confirm.emulator.test.js
package.json
netlify/functions/_lib/email.test.js
netlify/functions/_lib/timeoff-comment.test.js
netlify/functions/_lib/shift-reminder-functions.test.js
netlify/functions/_lib/timeoff-routing.test.js
netlify/functions/_lib/timeoff-confirmation.test.js
netlify/functions/_lib/timeoff-status.test.js
netlify/functions/_lib/schedule-change.test.js
netlify/functions/_lib/shift-reminder.test.js
schedule-partition.emulator.test.js
pay-period-lock.emulator.test.js
timeoff-schedule.test.js
timeoff-schedule.emulator.test.js
firebase-data.failure.test.js
timeoff-status-guard.emulator.test.js
js/schedule-helpers.js
js/app.js
js/firebase-data.js
future-schedule-write.emulator.test.js
reminder-toggle.emulator.test.js
shift-reminder.emulator.test.js
empty-map-guard.emulator.test.js
removals.emulator.test.js
schedule-helpers.test.js
schedule-dates-update.emulator.test.js
remove-timeoff-overrides.emulator.test.js
timeoff-schedule.characterization.test.js

exec
/bin/zsh -lc "nl -ba js/firebase-data.js | sed -n '1,180p'; nl -ba js/firebase-data.js | sed -n '430,575p'; nl -ba js/firebase-data.js | sed -n '640,950p'; nl -ba js/app.js | sed -n '590,820p'; nl -ba js/app.js | sed -n '1850,2075p'; nl -ba js/app.js | sed -n '2400,2800p'" in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
     1	// =====================================================
     2	// Timeclock — Firestore Data Layer
     3	// =====================================================
     4	// Multiple collections (not single-doc pattern):
     5	//   timeclock_entries/{autoId}   — clock in/out/break events
     6	//   timeclock_schedules/{uid}    — per-employee shift schedules
     7	//   timeclock_hfwa/{autoId}      — sick leave submissions
     8	//   timeclock_settings/appConfig — configurable thresholds
     9	
    10	let _db = null;
    11	let _ready = false;
    12	
    13	async function initAppFirestore() {
    14	  try {
    15	    _db = initFirebaseApp();
    16	    if (_db) {
    17	      await enableOfflinePersistence(_db);
    18	      _ready = true;
    19	    }
    20	  } catch (err) {
    21	    console.error('Firestore init failed:', err);
    22	    _ready = false;
    23	  }
    24	}
    25	
    26	function getDb() {
    27	  return _ready ? _db : null;
    28	}
    29	
    30	// ─── Clock Entries ───────────────────────────────────
    31	
    32	async function addClockEntry(entry) {
    33	  if (!_ready) return null;
    34	  try {
    35	    const ref = _db.collection('timeclock_entries').doc();
    36	    // Awaited so a rejected write (e.g. a rules denial — an archived
    37	    // account's now-blocked clock-in) is actually caught below instead of
    38	    // this returning a "success" id before the write is confirmed. Every
    39	    // call site already awaits this function; this was the only thing
    40	    // silently swallowing the failure.
    41	    await ref.set({
    42	      ...entry,
    43	      createdAt: firebase.firestore.FieldValue.serverTimestamp()
    44	    });
    45	    return ref.id;
    46	  } catch (err) {
    47	    console.error('Failed to add clock entry:', err);
    48	    return null;
    49	  }
    50	}
    51	
    52	async function getTodayEntries(uid) {
    53	  if (!_ready) return [];
    54	  const today = getTodayDateStr();
    55	  try {
    56	    const snap = await _db.collection('timeclock_entries')
    57	      .where('uid', '==', uid)
    58	      .where('date', '==', today)
    59	      .orderBy('timestamp', 'asc')
    60	      .get();
    61	    return snap.docs.map(d => ({ id: d.id, ...d.data() }));
    62	  } catch (err) {
    63	    console.error('Failed to get today entries:', err);
    64	    return [];
    65	  }
    66	}
    67	
    68	async function getAllTodayEntries() {
    69	  if (!_ready) return [];
    70	  const today = getTodayDateStr();
    71	  try {
    72	    const snap = await _db.collection('timeclock_entries')
    73	      .where('date', '==', today)
    74	      .orderBy('timestamp', 'asc')
    75	      .get();
    76	    return snap.docs.map(d => ({ id: d.id, ...d.data() }));
    77	  } catch (err) {
    78	    console.error('Failed to get all today entries:', err);
    79	    return [];
    80	  }
    81	}
    82	
    83	function listenTodayEntries(callback) {
    84	  if (!_ready) return () => {};
    85	  const today = getTodayDateStr();
    86	  return _db.collection('timeclock_entries')
    87	    .where('date', '==', today)
    88	    .orderBy('timestamp', 'asc')
    89	    .onSnapshot((snap) => {
    90	      const entries = snap.docs.map(d => ({ id: d.id, ...d.data() }));
    91	      callback(entries);
    92	    }, (err) => {
    93	      console.error('Listener error:', err);
    94	    });
    95	}
    96	
    97	// ─── Clock Entries: Date Range Queries ────────────────
    98	
    99	// Reports failure, because its result is written into the locked payroll snapshot — a swallowed [] here
   100	// becomes employeeTotals:{} in a document the Payroll Tool treats as authoritative (plan review, Sep 28).
   101	async function getEntriesByDateRangeResult(startDate, endDate, uid) {
   102	  if (!_ready) return { ok: false, entries: [] };
   103	  try {
   104	    let query = _db.collection('timeclock_entries')
   105	      .where('date', '>=', startDate)
   106	      .where('date', '<=', endDate)
   107	      .orderBy('date', 'asc')
   108	      .orderBy('timestamp', 'asc');
   109	    if (uid) query = query.where('uid', '==', uid);
   110	    const snap = await query.get();
   111	    // get() defaults to source:'default' — try the server, fall back to the durable local cache, and
   112	    // RESOLVE either way. So `ok` means "no error", not "fresh": offline persistence is on, so a dropped
   113	    // connection is served from cache and is indistinguishable from a good read. Callers that only DISPLAY
   114	    // are right to use it; the caller that writes it into the payroll snapshot must refuse it (both
   115	    // reviewers, Sep 28). Reported rather than gated here, so the display callers keep working offline.
   116	    return { ok: true, fromCache: !!(snap.metadata && snap.metadata.fromCache),
   117	             entries: snap.docs.map(d => ({ id: d.id, ...d.data() })) };
   118	  } catch (err) {
   119	    console.error('Failed to get entries by date range:', err);
   120	    return { ok: false, fromCache: false, entries: [] };
   121	  }
   122	}
   123	
   124	// Unchanged contract for any caller not yet converted: the entries, or [] if the read failed.
   125	async function getEntriesByDateRange(startDate, endDate, uid) {
   126	  const { entries } = await getEntriesByDateRangeResult(startDate, endDate, uid);
   127	  return entries;
   128	}
   129	
   130	// Phase 5 (unawaited-write family): awaited, like addClockEntry above — a rejected write (rules denial,
   131	// locked period, missing doc) now returns false instead of "true" before the write was ever confirmed.
   132	async function updateClockEntry(docId, updates) {
   133	  if (!_ready) return false;
   134	  try {
   135	    await _db.collection('timeclock_entries').doc(docId).update(updates);
   136	    return true;
   137	  } catch (err) {
   138	    console.error('Failed to update entry:', err);
   139	    return false;
   140	  }
   141	}
   142	
   143	async function deleteClockEntry(docId) {
   144	  if (!_ready) return false;
   145	  try {
   146	    await _db.collection('timeclock_entries').doc(docId).delete();
   147	    return true;
   148	  } catch (err) {
   149	    console.error('Failed to delete entry:', err);
   150	    return false;
   151	  }
   152	}
   153	
   154	// ─── Pay Period Locking ──────────────────────────────
   155	
   156	// The write payroll trusts. Two guards, both in the WRITE rather than in a read-gate, because the damage
   157	// they prevent happens when a READ has already failed. (The caller does now refuse a failed or cache-served
   158	// read as well — the two are complementary: this one cannot be bypassed by a future caller, and the
   159	// caller's runs early enough to keep a false summary off the screen.)
   160	//
   161	//   1. A snapshot nobody could have reviewed is refused. Pass { allowEmpty: true } for the genuinely-empty
   162	//      period, which is a thing a human confirms. The caller ALSO reads fresh, refuses a failed or
   163	//      cache-served read, and validates the snapshot before it asks for that confirmation — so this guard
   164	//      is the write's own last line, not the only one.
   165	//   2. An already-locked period is refused, inside a transaction so a stale read cannot get past it. A
   166	//      merge-set would otherwise overwrite lockedAt / lockedBy / employeeTotals — destroying the record of
   167	//      what was actually paid — and, for a PARTIAL snapshot, deep-merge it: people present overwritten,
   168	//      people absent surviving with stale values, producing a hybrid that looks entirely plausible.
   169	//      Re-locking stays possible; Unlock first, whose confirm already warns about invalidating payroll.
   170	//
   171	// Returns { ok, reason?, lockedBy?, lockedAt?, uid?, name?, count? } — not a boolean; the caller has to
   172	// tell these apart. Note the caller ALSO refuses a failed or cache-served read before it gets here: the
   173	// guards below are the write's own, so a future caller cannot bypass them, not the only line of defence.
   174	async function lockPayPeriod(periodKey, employeeTotals, opts) {
   175	  if (!_ready) return { ok: false, reason: 'not-ready' };
   176	  const o = opts || {};
   177	  const totals = employeeTotals && typeof employeeTotals === 'object' && !Array.isArray(employeeTotals)
   178	    ? employeeTotals : null;
   179	  if (!totals) return { ok: false, reason: 'no-totals' };
   180	  const keys = Object.keys(totals);
   430	// { ok, roster }. A FAILED read is distinct from an empty roster — the retry path resolves which schedule
   431	// document to reverse from this, and "the roster could not be loaded" must refuse rather than silently
   432	// become "there is no other id". Same pattern as loadScheduleResult / getTimeOffRequestResult.
   433	async function loadEmployeeRosterResult() {
   434	  if (!_ready) return { ok: false, fromCache: false, exists: false, roster: [] };
   435	  try {
   436	    const doc = await _db.collection('timeclock_settings').doc('employees').get();
   437	    // Same cache caveat as the entries read: get() resolves from the local cache when the server is
   438	    // unreachable, so `ok` is not "fresh". `exists` is reported for callers that care; the LOCK path
   439	    // deliberately does not, because a studio that never seeded a roster has valid uid-keyed hours and
   440	    // nothing to merge — refusing it blocked first-run payroll for no benefit (round four).
   441	    const fromCache = !!(doc.metadata && doc.metadata.fromCache);
   442	    if (!doc.exists) return { ok: true, fromCache, exists: false, roster: [] };
   443	    return { ok: true, fromCache, exists: true, roster: doc.data().roster || [] };
   444	  } catch (err) {
   445	    console.error('Failed to load employee roster:', err);
   446	    return { ok: false, fromCache: false, exists: false, roster: [] };
   447	  }
   448	}
   449	
   450	// Unchanged contract for existing callers: the roster, or [] for both empty and failed.
   451	async function loadEmployeeRoster() {
   452	  const { roster } = await loadEmployeeRosterResult();
   453	  return roster;
   454	}
   455	
   456	// Every id a schedule document has lived under, oldest first — the `migratedFromChain` stamp for a move
   457	// FROM `oldId`. Durable ancestry (Phase 3b review): each move deletes its source, so the single-source
   458	// `migratedFrom` stamp loses A the moment B moves on to C — a query for "migrated from A" then finds
   459	// nothing, and the pending reversal for A is dismissable while C holds its time off. A document stamped
   460	// only the old way contributes its one source.
   461	function migrationChain(data, oldId) {
   462	  const prior = Array.isArray(data && data.migratedFromChain) ? data.migratedFromChain
   463	    : (data && data.migratedFrom ? [data.migratedFrom] : []);
   464	  return [...new Set([...prior, oldId])];
   465	}
   466	
   467	// Schedule documents that migrateSchedule() / reassignSchedule() created FROM the given id — directly
   468	// (`migratedFrom`) or at any remove (`migratedFromChain`). A roster-independent way to learn that a
   469	// schedule has moved — the retry path uses it as a safety net before dismissing a pending reversal,
   470	// because the roster in this tab can be stale. { ok, ids }.
   471	async function findSchedulesMigratedFrom(uid, maxHops) {
   472	  if (!_ready || !uid) return { ok: false, ids: [] };
   473	  // The chain stamp finds every descendant in one query. The single-source stamp is still followed hop
   474	  // by hop for documents written before the chain existed (a copy whose delete failed keeps its stamp).
   475	  // Bounded, and cycle-safe via the seen set.
   476	  const seen = new Set([uid]);
   477	  const ids = [];
   478	  let frontier = [uid];
   479	  try {
   480	    for (let hop = 0; hop < (maxHops || 4) && frontier.length; hop++) {
   481	      const next = [];
   482	      for (const from of frontier) {
   483	        const [byChain, byStamp] = await Promise.all([
   484	          _db.collection('timeclock_schedules').where('migratedFromChain', 'array-contains', from).get(),
   485	          _db.collection('timeclock_schedules').where('migratedFrom', '==', from).get(),
   486	        ]);
   487	        [...byChain.docs, ...byStamp.docs].forEach(d => { if (!seen.has(d.id)) { seen.add(d.id); ids.push(d.id); next.push(d.id); } });
   488	      }
   489	      frontier = next;
   490	    }
   491	    return { ok: true, ids };
   492	  } catch (err) {
   493	    console.error('Failed to query migrated schedules:', err);
   494	    return { ok: false, ids: [] };
   495	  }
   496	}
   497	
   498	// Requests for any of `uids` that carry reversalPending — read FRESH, for the approve-time overlap
   499	// guard. Two equality filters (`in` counts as equality) are served from single-field indexes; no
   500	// composite index. { ok, requests }.
   501	async function findFlaggedTimeOffFor(uids) {
   502	  const list = (uids || []).filter(Boolean);
   503	  if (!_ready || !list.length) return { ok: false, requests: [] };
   504	  try {
   505	    const snap = await _db.collection('timeclock_timeoff')
   506	      .where('uid', 'in', list.slice(0, 10))
   507	      .where('reversalPending', '==', true)
   508	      .get();
   509	    return { ok: true, requests: snap.docs.map(d => ({ id: d.id, ...d.data() })) };
   510	  } catch (err) {
   511	    console.error('Failed to query flagged time off requests:', err);
   512	    return { ok: false, requests: [] };
   513	  }
   514	}
   515	
   516	async function saveEmployeeRoster(roster) {
   517	  if (!_ready) return false;
   518	  try {
   519	    await _db.collection('timeclock_settings').doc('employees').set({
   520	      roster,
   521	      updatedAt: new Date().toISOString()
   522	    });
   523	    return true;
   524	  } catch (err) {
   525	    console.error('Failed to save employee roster:', err);
   526	    return false;
   527	  }
   528	}
   529	
   530	async function migrateSchedule(oldId, newUid) {
   531	  if (!_ready) return false;
   532	  try {
   533	    const oldDoc = await _db.collection('timeclock_schedules').doc(oldId).get();
   534	    if (!oldDoc.exists) return true; // nothing to migrate
   535	    const data = oldDoc.data();
   536	    // Reminder flags stamped before this person claimed an account carry no remindUid; the copy names it
   537	    // ("48-hour shift reminders" plan, Phase 4 — the one place the account becomes known).
   538	    await _db.collection('timeclock_schedules').doc(newUid).set({
   539	      ...stampReminderUids(data, newUid),
   540	      uid: newUid,
   541	      migratedFrom: oldId,
   542	      migratedFromChain: migrationChain(data, oldId),
   543	      migratedAt: new Date().toISOString()
   544	    });
   545	    await _db.collection('timeclock_schedules').doc(oldId).delete();
   546	    return true;
   547	  } catch (err) {
   548	    console.error('Failed to migrate schedule:', err);
   549	    return false;
   550	  }
   551	}
   552	
   553	// ─── Settings ────────────────────────────────────────
   554	
   555	const DEFAULT_SETTINGS = {
   556	  breakAutoEndMinutes: 30,
   557	  extensionAlertThreshold: 2,
   558	  extensionIncrementMinutes: 10,
   559	  defaultEarlyClockInMinutes: 15,
   560	  overtimeWeeklyThreshold: 40,
   561	  overtimeMultiplier: 1.5,
   562	  timeoffMinNoticeDays: 14,
   563	  timeoffCategories: ['wedding', 'family', 'personal', 'medical', 'travel', 'other']
   564	};
   565	
   566	async function loadSettings() {
   567	  if (!_ready) return { ...DEFAULT_SETTINGS };
   568	  try {
   569	    const doc = await _db.collection('timeclock_settings').doc('appConfig').get();
   570	    return doc.exists ? { ...DEFAULT_SETTINGS, ...doc.data() } : { ...DEFAULT_SETTINGS };
   571	  } catch (err) {
   572	    console.error('Failed to load settings:', err);
   573	    return { ...DEFAULT_SETTINGS };
   574	  }
   575	}
   640	  if (!_ready) return { ok: false, entries: [] };
   641	  try {
   642	    const snap = await _db.collection('timeclock_hfwa')
   643	      .where('uid', '==', uid)
   644	      .orderBy('date', 'desc')
   645	      .limit(20)
   646	      .get();
   647	    return { ok: true, entries: snap.docs.map(d => ({ id: d.id, ...d.data() })) };
   648	  } catch (err) {
   649	    console.error('Failed to get my HFWA entries:', err);
   650	    return { ok: false, entries: [] };
   651	  }
   652	}
   653	
   654	// Unchanged contract for any existing caller: the entries, or [] if the read failed.
   655	async function getMyHfwaEntries(uid) {
   656	  const { entries } = await getMyHfwaEntriesResult(uid);
   657	  return entries;
   658	}
   659	
   660	// ─── Recent Entries (for change requests) ────────────
   661	
   662	async function getRecentEntries(uid, days) {
   663	  if (!_ready) return [];
   664	  const now = new Date();
   665	  const startDate = new Date(now);
   666	  startDate.setDate(startDate.getDate() - (days || 7));
   667	  const startStr = startDate.getFullYear() + '-' +
   668	    String(startDate.getMonth() + 1).padStart(2, '0') + '-' +
   669	    String(startDate.getDate()).padStart(2, '0');
   670	  try {
   671	    const snap = await _db.collection('timeclock_entries')
   672	      .where('uid', '==', uid)
   673	      .where('date', '>=', startStr)
   674	      .orderBy('date', 'desc')
   675	      .orderBy('timestamp', 'desc')
   676	      .get();
   677	    return snap.docs.map(d => ({ id: d.id, ...d.data() }));
   678	  } catch (err) {
   679	    console.error('Failed to get recent entries:', err);
   680	    return [];
   681	  }
   682	}
   683	
   684	// ─── Time Off Requests ──────────────────────────────
   685	
   686	async function addTimeOffRequest(request) {
   687	  if (!_ready) return null;
   688	  try {
   689	    const ref = _db.collection('timeclock_timeoff').doc();
   690	    await ref.set({
   691	      ...request,
   692	      submittedAt: firebase.firestore.FieldValue.serverTimestamp(),
   693	      updatedAt: firebase.firestore.FieldValue.serverTimestamp()
   694	    });
   695	    return ref.id;
   696	  } catch (err) {
   697	    console.error('Failed to add time off request:', err);
   698	    return null;
   699	  }
   700	}
   701	
   702	async function getMyTimeOffRequests(uid) {
   703	  if (!_ready) return [];
   704	  try {
   705	    const snap = await _db.collection('timeclock_timeoff')
   706	      .where('uid', '==', uid)
   707	      .orderBy('submittedAt', 'desc')
   708	      .get();
   709	    return snap.docs.map(d => ({ id: d.id, ...d.data() }));
   710	  } catch (err) {
   711	    console.error('Failed to get my time off requests:', err);
   712	    return [];
   713	  }
   714	}
   715	
   716	async function getAllTimeOffRequests() {
   717	  if (!_ready) return [];
   718	  try {
   719	    const snap = await _db.collection('timeclock_timeoff')
   720	      .orderBy('submittedAt', 'desc')
   721	      .get();
   722	    return snap.docs.map(d => ({ id: d.id, ...d.data() }));
   723	  } catch (err) {
   724	    console.error('Failed to get all time off requests:', err);
   725	    return [];
   726	  }
   727	}
   728	
   729	// Requests needing a manager: awaiting review, PLUS any carrying reversalPending whatever its status
   730	// (Phase 3b). Two queries rather than one: the marker query is a single-field equality with no orderBy,
   731	// so it needs no composite index; the two are merged by id and sorted client-side.
   732	async function getPendingTimeOffRequests() {
   733	  if (!_ready) return [];
   734	  try {
   735	    // allSettled, not all: if the newer marker query fails (a rules change, say), the awaiting-review
   736	    // list must still render — degrade to the old behaviour, never to an empty dashboard.
   737	    const [byStatus, byMarker] = await Promise.allSettled([
   738	      _db.collection('timeclock_timeoff').where('status', 'in', ['submitted', 'under_review']).orderBy('submittedAt', 'asc').get(),
   739	      _db.collection('timeclock_timeoff').where('reversalPending', '==', true).get(),
   740	    ]);
   741	    if (byStatus.status === 'rejected') throw byStatus.reason;
   742	    if (byMarker.status === 'rejected') console.error('Failed to get flagged time off requests:', byMarker.reason);
   743	    const docs = [...byStatus.value.docs, ...(byMarker.status === 'fulfilled' ? byMarker.value.docs : [])];
   744	    return mergePendingTimeOff(docs.map(d => ({ id: d.id, ...d.data() })));
   745	  } catch (err) {
   746	    console.error('Failed to get pending time off requests:', err);
   747	    return [];
   748	  }
   749	}
   750	
   751	async function updateTimeOffRequest(docId, updates) {
   752	  if (!_ready) return false;
   753	  try {
   754	    await _db.collection('timeclock_timeoff').doc(docId).update({
   755	      ...updates,
   756	      updatedAt: firebase.firestore.FieldValue.serverTimestamp()
   757	    });
   758	    return true;
   759	  } catch (err) {
   760	    console.error('Failed to update time off request:', err);
   761	    return false;
   762	  }
   763	}
   764	
   765	// The transaction guards below compare with sameStructure() from js/schedule-helpers.js (loaded after this
   766	// file, called only at runtime): key-order-independent, so a value this tab just wrote — which can come back
   767	// from the local cache in insertion order — never refuses a correct write.
   768	
   769	// Transaction-based read-modify-write on a single proposedSubs[] entry, per Plan 2 Phase 3: two admins
   770	// acting on the same request's subs near-simultaneously must never lose either write, which a bare
   771	// updateDoc (the prior toggleSubConfirm() behavior) could. expectedSubName guards against a stale
   772	// in-memory index — if the doc changed shape since the caller last read it, this aborts rather than
   773	// silently patching the wrong sub. Mirrors timeoff-sub-confirm.emulator.test.js's proven write shape.
   774	// `expectApplied` (optional, Phase 3b): the sub's appliedOverrides the caller decided on, compared
   775	// structurally inside the transaction. A same-name re-confirm in another tab replaces that record; without
   776	// this the un-confirm would clear the NEW record on the strength of index+name alone.
   777	// `expectRequest` (optional, Phase 3b review): { statuses, reversalPending, subUid, confirmed } — the
   778	// request must still be in one of `statuses`, its marker must match, and the entry's subUid / confirmed
   779	// flag must match, all inside the transaction. The retry path's un-confirms are only right while the
   780	// request is denied/withdrawn and still flagged; a confirm is only right while the entry is still
   781	// un-confirmed (Phase 4: a confirm modal left open must not overwrite a confirmation made meanwhile). A
   782	// point-in-time pre-check cannot promise either at write time; this can.
   783	async function confirmTimeOffSub(requestId, subIndex, expectedSubName, patch, expectApplied, expectRequest) {
   784	  if (!_ready) return { success: false, reason: 'not-ready' };
   785	  const ref = _db.collection('timeclock_timeoff').doc(requestId);
   786	  try {
   787	    return await _db.runTransaction(async (tx) => {
   788	      const doc = await tx.get(ref);
   789	      if (!doc.exists) return { success: false, reason: 'not-found' };
   790	      const data = doc.data();
   791	      const subs = data.proposedSubs || [];
   792	      if (!subs[subIndex] || subs[subIndex].name !== expectedSubName) {
   793	        return { success: false, reason: 'sub-changed' };
   794	      }
   795	      if (expectApplied !== undefined
   796	          && !sameStructure(subs[subIndex].appliedOverrides || {}, expectApplied || {})) {
   797	        return { success: false, reason: 'sub-changed', field: 'appliedOverrides' };
   798	      }
   799	      const want = expectRequest || {};
   800	      if (want.statuses && !want.statuses.includes(data.status)) return { success: false, reason: 'status-changed', status: data.status };
   801	      if (want.reversalPending !== undefined && !!data.reversalPending !== want.reversalPending) return { success: false, reason: 'changed', field: 'reversalPending' };
   802	      if (want.subUid !== undefined && (subs[subIndex].subUid || null) !== (want.subUid || null)) return { success: false, reason: 'sub-changed', field: 'subUid' };
   803	      if (want.confirmed !== undefined && !!subs[subIndex].confirmed !== want.confirmed) return { success: false, reason: 'sub-changed', field: 'confirmed' };
   804	      // `dates` (optional, plan: ticker-sub-confirm-only-by-manager): the request's dates the confirm box was built
   805	      // from, normalized. AFTER the confirmed/subUid checks on purpose: if someone else confirmed this sub AND the
   806	      // dates moved, the caller must see 'sub-changed' — that path partitions the rollback and keeps their shift;
   807	      // a 'dates' refusal rolls ours back whole, which could delete a colleague's confirmed coverage.
   808	      if (want.dates !== undefined && !sameStructure(normalizeRequestDates(data.dates), want.dates)) return { success: false, reason: 'changed', field: 'dates' };
   809	      subs[subIndex] = { ...subs[subIndex], ...patch };
   810	      const allConfirmed = subs.every(s => s.confirmed);
   811	      const someConfirmed = subs.some(s => s.confirmed);
   812	      const coverageStatus = allConfirmed ? 'secured' : someConfirmed ? 'partial' : 'pending';
   813	      tx.update(ref, {
   814	        proposedSubs: subs,
   815	        coverageStatus,
   816	        updatedAt: firebase.firestore.FieldValue.serverTimestamp()
   817	      });
   818	      return { success: true };
   819	    });
   820	  } catch (err) {
   821	    console.error('Failed to confirm time off sub:', err);
   822	    return { success: false, reason: 'error' };
   823	  }
   824	}
   825	
   826	// Reads one time-off request as { ok, exists, data }. Three states, kept distinct on purpose: a failed
   827	// READ (ok:false) is not the same as a request that has been deleted (ok:true, exists:false), and neither
   828	// is a request that is there (ok:true, exists:true). Collapsing the first two into `null` is the pattern
   829	// that made a rules regression look like deleted data elsewhere in this app — see getHfwaByDateRangeResult.
   830	// Added so the approve orchestration in js/timeoff-schedule.js can take its read through an injected
   831	// dependency rather than reaching for getDb() directly.
   832	async function getTimeOffRequestResult(requestId) {
   833	  if (!_ready) return { ok: false, exists: false, data: null };
   834	  try {
   835	    const doc = await _db.collection('timeclock_timeoff').doc(requestId).get();
   836	    return { ok: true, exists: doc.exists, data: doc.exists ? doc.data() : null };
   837	  } catch (err) {
   838	    console.error('Failed to read time off request:', err);
   839	    return { ok: false, exists: false, data: null };
   840	  }
   841	}
   842	
   843	// Conditional sibling of updateTimeOffRequest(): applies `updates` only if the request's CURRENT status
   844	// is still one the caller considers a legal starting point. Returns { success, reason } — the same shape
   845	// as confirmTimeOffSub() above, so a caller can tell "someone else got there first" apart from "the write
   846	// failed".
   847	//
   848	// Why a transaction rather than a plain re-read: approveTimeOff() reads the request, then loads AND writes
   849	// a schedule, then updates the request. That is several round trips, and another admin (or the same admin
   850	// clicking again) can approve the same request inside that window. Re-reading inside the transaction is
   851	// what makes the second approval abort instead of overwriting the first one's appliedOverrides with a
   852	// record captured after the first one's schedule write — see the comment at approveTimeOff().
   853	// `expect` (optional, Phase 3a): field values the document must STILL hold inside the transaction, or
   854	// the write is refused with { reason: 'changed', field }. Used by the reversal retry so the write that
   855	// clears appliedOverrides can only land against the exact record and marker it was decided on — a
   856	// status-only guard left a one-round-trip window in which another tab could park a different record.
   857	// Values are compared structurally; an absent field compares as null.
   858	async function updateTimeOffRequestIfStatus(requestId, allowedStatuses, updates, expect) {
   859	  if (!_ready) return { success: false, reason: 'not-ready' };
   860	  const ref = _db.collection('timeclock_timeoff').doc(requestId);
   861	  try {
   862	    return await _db.runTransaction(async (tx) => {
   863	      const doc = await tx.get(ref);
   864	      if (!doc.exists) return { success: false, reason: 'not-found' };
   865	      const data = doc.data();
   866	      const status = data.status;
   867	      if (!(allowedStatuses || []).includes(status)) {
   868	        return { success: false, reason: 'status-changed', status };
   869	      }
   870	      for (const field of Object.keys(expect || {})) {
   871	        const have = data[field] === undefined ? null : data[field];
   872	        const want = expect[field] === undefined ? null : expect[field];
   873	        if (!sameStructure(have, want)) return { success: false, reason: 'changed', field };
   874	      }
   875	      tx.update(ref, {
   876	        ...updates,
   877	        updatedAt: firebase.firestore.FieldValue.serverTimestamp()
   878	      });
   879	      return { success: true };
   880	    });
   881	  } catch (err) {
   882	    console.error('Failed to conditionally update time off request:', err);
   883	    return { success: false, reason: 'error' };
   884	  }
   885	}
   886	
   887	// ─── Streak Data ────────────────────────────────────
   888	
   889	const DEFAULT_STREAK = {
   890	  clockInStreak: 0,
   891	  clockOutStreak: 0,
   892	  monthlyClockIns: 0,
   893	  monthlyClockInTotal: 0,
   894	  monthlyClockOuts: 0,
   895	  monthlyClockOutTotal: 0,
   896	  extensionsThisWeek: 0,
   897	  weeklyExtensions: [],
   898	  currentMonth: '',
   899	  currentWeek: '',
   900	  lastUpdated: ''
   901	};
   902	
   903	async function loadStreakData() {
   904	  if (!_ready || !firebase.auth().currentUser) return { ...DEFAULT_STREAK };
   905	  try {
   906	    const uid = firebase.auth().currentUser.uid;
   907	    const doc = await _db.collection('timeclock_streaks').doc(uid).get();
   908	    return doc.exists ? { ...DEFAULT_STREAK, ...doc.data() } : { ...DEFAULT_STREAK };
   909	  } catch (err) {
   910	    console.error('Failed to load streak data:', err);
   911	    return { ...DEFAULT_STREAK };
   912	  }
   913	}
   914	
   915	// Phase 5: awaited. Not on the clock-in/out critical path — updateStreakOnClockIn/Out are fired without
   916	// await by the clock action, so the round-trip only delays the streak card, never the clock write.
   917	async function saveStreakData(updates) {
   918	  if (!_ready || !firebase.auth().currentUser) return false;
   919	  try {
   920	    const uid = firebase.auth().currentUser.uid;
   921	    const authUser = firebase.auth().currentUser;
   922	    const name = (typeof currentUser !== 'undefined' && currentUser && currentUser.name) || authUser.displayName || authUser.email || '';
   923	    await _db.collection('timeclock_streaks').doc(uid).set({ ...updates, name }, { merge: true });
   924	    return true;
   925	  } catch (err) {
   926	    console.error('Failed to save streak data:', err);
   927	    return false;
   928	  }
   929	}
   930	
   931	// ─── Helpers ─────────────────────────────────────────
   932	
   933	function getTodayDateStr() {
   934	  const now = new Date();
   935	  return now.getFullYear() + '-' +
   936	    String(now.getMonth() + 1).padStart(2, '0') + '-' +
   937	    String(now.getDate()).padStart(2, '0');
   938	}
   939	
   940	function getWeekday() {
   941	  return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][new Date().getDay()];
   942	}
   590	  _lateClockOutNow = null;
   591	}
   592	
   593	async function submitStayedLate() {
   594	  if (!_lateClockOutNow) return;
   595	
   596	  document.getElementById('late-clockout-modal').classList.remove('open');
   597	  clearShiftEndTimer();
   598	  clearBreakTimer();
   599	
   600	  const now = _lateClockOutNow;
   601	  const msLate = _lateClockOutEffectiveEnd ? now.getTime() - _lateClockOutEffectiveEnd.getTime() : 0;
   602	  const minsLate = Math.round(msLate / 60000);
   603	
   604	  await doClockOut(now, {
   605	    lateClockOut: true,
   606	    stayedLate: true,
   607	    minutesLate: minsLate,
   608	    scheduledEnd: todayEndOverride || (todayShift ? todayShift.end : null),
   609	    flaggedForReview: false // "stayed late" is intentional — no flag
   610	  });
   611	
   612	  // Don't penalize streak for intentional late stays
   613	  // (streak tracks unexcused late clock-outs, not intentional ones)
   614	
   615	  _lateClockOutEffectiveEnd = null;
   616	  _lateClockOutNow = null;
   617	}
   618	
   619	async function trackLateClockOut() {
   620	  if (!currentUser || !_ready) return;
   621	  try {
   622	    const streakDoc = await loadStreakData();
   623	    const now = new Date();
   624	
   625	    // Calendar week tracking (Mon–Sun)
   626	    const currentWeekMonday = getMondayDateStr(now);
   627	    let lateClockOuts = streakDoc.lateClockOuts || [];
   628	    let lateClockOutWeek = streakDoc.lateClockOutWeek || '';
   629	
   630	    // Reset if new week
   631	    if (lateClockOutWeek !== currentWeekMonday) {
   632	      lateClockOuts = [];
   633	      lateClockOutWeek = currentWeekMonday;
   634	    }
   635	
   636	    lateClockOuts.push(now.toISOString());
   637	    const count = lateClockOuts.length;
   638	
   639	    const updates = {
   640	      lateClockOuts,
   641	      lateClockOutWeek,
   642	      lastUpdated: now.toISOString()
   643	    };
   644	
   645	    if (count >= 3) {
   646	      // Break clock-out streak + show message on kiosk
   647	      updates.previousClockOutStreak = streakDoc.clockOutStreak || 0;
   648	      updates.clockOutStreak = 0;
   649	      // Show message in app
   650	    }
   651	
   652	    await saveStreakData(updates);
   653	  } catch (err) {
   654	    console.error('Failed to track late clock-out:', err);
   655	  }
   656	}
   657	
   658	// ─── Core clock in/out (shared by normal + unscheduled + auto) ──
   659	
   660	async function doClockIn(now, studio, extraFields) {
   661	  // Cancel clock-in nudge — they're clocking in
   662	  if (shiftStartTimer) { clearTimeout(shiftStartTimer); shiftStartTimer = null; }
   663	
   664	  const entry = {
   665	    uid: currentUser.uid,
   666	    name: currentUser.name || currentUser.email,
   667	    type: 'clock-in',
   668	    timestamp: now.toISOString(),
   669	    date: getTodayDateStr(),
   670	    weekday: getWeekday(),
   671	    studio: studio || (currentUser.studios && currentUser.studios[0]) || 'tinker',
   672	    ...(extraFields || {})
   673	  };
   674	
   675	  const id = await addClockEntry(entry);
   676	  if (id) {
   677	    setClockStatus('clocked-in', now);
   678	    document.getElementById('gate-message').classList.add('hidden');
   679	    // Track streak (only for scheduled, non-extension, non-unscheduled clock-ins)
   680	    if (!extraFields || (!extraFields.extended && !extraFields.unscheduled)) {
   681	      updateStreakOnClockIn();
   682	    }
   683	    // Show push notification prompt after clock-in (if not yet granted/dismissed)
   684	    maybeShowPushPrompt();
   685	    return true;
   686	  } else {
   687	    alert('Failed to clock in. Please try again.');
   688	    return false;
   689	  }
   690	}
   691	
   692	async function doClockOut(now, extraFields) {
   693	  const entry = {
   694	    uid: currentUser.uid,
   695	    name: currentUser.name || currentUser.email,
   696	    type: 'clock-out',
   697	    timestamp: now.toISOString(),
   698	    date: getTodayDateStr(),
   699	    weekday: getWeekday(),
   700	    studio: (currentUser.studios && currentUser.studios[0]) || 'tinker',
   701	    ...(extraFields || {})
   702	  };
   703	
   704	  const id = await addClockEntry(entry);
   705	  if (id) {
   706	    setClockStatus('clocked-out', null);
   707	    // Track streak (skip for unscheduled shifts)
   708	    const lastClockIn = [...todayEntries].reverse().find(e => e.uid === currentUser.uid && e.type === 'clock-in');
   709	    const wasUnscheduled = lastClockIn && lastClockIn.unscheduled;
   710	    if (!wasUnscheduled) {
   711	      const isAutoEnded = extraFields && extraFields.autoEnded;
   712	      updateStreakOnClockOut(isAutoEnded);
   713	    }
   714	    return true;
   715	  } else {
   716	    alert('Failed to clock out. Please try again.');
   717	    return false;
   718	  }
   719	}
   720	
   721	// ─── Break Tracking (Phase 4) ────────────────────────
   722	
   723	let breakAutoEndTimer = null;
   724	
   725	async function handleBreakStart() {
   726	  const btn = document.getElementById('btn-break-start');
   727	  btn.disabled = true;
   728	
   729	  const now = new Date();
   730	  const entry = {
   731	    uid: currentUser.uid,
   732	    name: currentUser.name || currentUser.email,
   733	    type: 'break-start',
   734	    timestamp: now.toISOString(),
   735	    date: getTodayDateStr(),
   736	    weekday: getWeekday(),
   737	    studio: (currentUser.studios && currentUser.studios[0]) || 'tinker'
   738	  };
   739	
   740	  const id = await addClockEntry(entry);
   741	  if (id) {
   742	    setClockStatus('on-break', now);
   743	    // Pause shift-end timer while on break
   744	    clearShiftEndTimer();
   745	    // Start break auto-end timer
   746	    const breakLimit = (appSettings && appSettings.breakAutoEndMinutes) || 30;
   747	    breakAutoEndTimer = setTimeout(autoEndBreak, breakLimit * 60000);
   748	  } else {
   749	    alert('Failed to start break. Please try again.');
   750	  }
   751	  btn.disabled = false;
   752	}
   753	
   754	async function handleBreakEnd() {
   755	  const btn = document.getElementById('btn-break-end');
   756	  btn.disabled = true;
   757	  clearBreakTimer();
   758	
   759	  const now = new Date();
   760	  const entry = {
   761	    uid: currentUser.uid,
   762	    name: currentUser.name || currentUser.email,
   763	    type: 'break-end',
   764	    timestamp: now.toISOString(),
   765	    date: getTodayDateStr(),
   766	    weekday: getWeekday(),
   767	    studio: (currentUser.studios && currentUser.studios[0]) || 'tinker'
   768	  };
   769	
   770	  const id = await addClockEntry(entry);
   771	  if (id) {
   772	    const lastClockIn = todayEntries
   773	      .filter(e => e.uid === currentUser.uid && e.type === 'clock-in')
   774	      .pop();
   775	    setClockStatus('clocked-in', lastClockIn ? new Date(lastClockIn.timestamp) : now);
   776	    // Resume shift-end timer (only for scheduled shifts)
   777	    if (todayShift && !(lastClockIn && lastClockIn.unscheduled)) startShiftEndTimer();
   778	  } else {
   779	    alert('Failed to end break. Please try again.');
   780	  }
   781	  btn.disabled = false;
   782	}
   783	
   784	async function autoEndBreak() {
   785	  if (currentStatus !== 'on-break') return;
   786	
   787	  const now = new Date();
   788	  const entry = {
   789	    uid: currentUser.uid,
   790	    name: currentUser.name || currentUser.email,
   791	    type: 'break-end',
   792	    timestamp: now.toISOString(),
   793	    date: getTodayDateStr(),
   794	    weekday: getWeekday(),
   795	    studio: (currentUser.studios && currentUser.studios[0]) || 'tinker',
   796	    autoEnded: true
   797	  };
   798	
   799	  const id = await addClockEntry(entry);
   800	  if (id) {
   801	    const lastClockIn = todayEntries
   802	      .filter(e => e.uid === currentUser.uid && e.type === 'clock-in')
   803	      .pop();
   804	    setClockStatus('clocked-in', lastClockIn ? new Date(lastClockIn.timestamp) : now);
   805	    if (todayShift && !(lastClockIn && lastClockIn.unscheduled)) startShiftEndTimer();
   806	  }
   807	}
   808	
   809	function clearBreakTimer() {
   810	  if (breakAutoEndTimer) {
   811	    clearTimeout(breakAutoEndTimer);
   812	    breakAutoEndTimer = null;
   813	  }
   814	}
   815	
   816	// ─── Status Management ───────────────────────────────
   817	
   818	function setClockStatus(status, since) {
   819	  currentStatus = status;
   820	  clockedInTime = since;
  1850	// ─── Helper: Time string to today's Date ─────────────
  1851	
  1852	function timeStrToDate(timeStr) {
  1853	  if (!timeStr) return new Date();
  1854	  const [h, m] = timeStr.split(':').map(Number);
  1855	  const d = new Date();
  1856	  d.setHours(h, m, 0, 0);
  1857	  return d;
  1858	}
  1859	
  1860	// ═══════════════════════════════════════════════════════
  1861	// PHASE 5: TIMESHEETS & REVIEW
  1862	// ═══════════════════════════════════════════════════════
  1863	
  1864	// Semi-monthly pay periods: 1st–15th and 16th–end of month
  1865	
  1866	let adminTsPeriodOffset = 0;
  1867	let lockedPeriods = {};
  1868	
  1869	function isDateInLockedPeriod(dateStr) {
  1870	  return Object.keys(lockedPeriods).some(key => {
  1871	    const [start, end] = key.split('_');
  1872	    return dateStr >= start && dateStr <= end;
  1873	  });
  1874	}
  1875	
  1876	// ─── Pay Period Helpers ──────────────────────────────
  1877	
  1878	// A period reconstructed from its own key, so an action can name the period it was rendered for rather
  1879	// than whichever one the offset points at by the time it runs.
  1880	function getPayPeriodByKey(key) {
  1881	  // Returns null unless `key` is EXACTLY a key getPayPeriod() can produce. An irreversible delete must not
  1882	  // act on a guess. The shape check alone was not enough: JS normalises impossible dates, so 2026-02-29
  1883	  // silently became March 1 and passed (round-four review, Sep 28). Components are therefore compared back,
  1884	  // and the semi-month semantics enforced: periods run 1-15 or 16-end-of-month, within one month.
  1885	  const m = /^(\d{4})-(\d{2})-(\d{2})_(\d{4})-(\d{2})-(\d{2})$/.exec(String(key || ''));
  1886	  if (!m) return null;
  1887	  const [, y1, m1, d1, y2, m2, d2] = m.map(Number);
  1888	  const start = new Date(y1, m1 - 1, d1, 12);
  1889	  const end = new Date(y2, m2 - 1, d2, 12);
  1890	  // no silent normalisation: 2026-02-29 must not come back as March 1
  1891	  if (start.getFullYear() !== y1 || start.getMonth() !== m1 - 1 || start.getDate() !== d1) return null;
  1892	  if (end.getFullYear() !== y2 || end.getMonth() !== m2 - 1 || end.getDate() !== d2) return null;
  1893	  if (y1 !== y2 || m1 !== m2) return null;
  1894	  const lastDay = new Date(y1, m1, 0).getDate();
  1895	  const canonical = (d1 === 1 && d2 === 15) || (d1 === 16 && d2 === lastDay);
  1896	  if (!canonical) return null;
  1897	  const startStr = `${m[1]}-${m[2]}-${m[3]}`;
  1898	  const endStr = `${m[4]}-${m[5]}-${m[6]}`;
  1899	  const label = start.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })
  1900	    + ' \u2013 ' + end.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
  1901	  return { key, startStr, endStr, label };
  1902	}
  1903	
  1904	function getPayPeriod(offset) {
  1905	  const now = new Date();
  1906	  now.setHours(0, 0, 0, 0);
  1907	
  1908	  // Determine current half-month: day <= 15 → first half, else second half
  1909	  let year = now.getFullYear();
  1910	  let month = now.getMonth();
  1911	  let isFirstHalf = now.getDate() <= 15;
  1912	
  1913	  // Each period is one "half" — offset by halves
  1914	  let totalHalves = month * 2 + (isFirstHalf ? 0 : 1) + offset;
  1915	
  1916	  // Normalize (handle negative offsets wrapping to previous year)
  1917	  while (totalHalves < 0) { totalHalves += 24; year--; }
  1918	  while (totalHalves >= 24) { totalHalves -= 24; year++; }
  1919	
  1920	  month = Math.floor(totalHalves / 2);
  1921	  isFirstHalf = (totalHalves % 2) === 0;
  1922	
  1923	  let start, end;
  1924	  if (isFirstHalf) {
  1925	    start = new Date(year, month, 1);
  1926	    end = new Date(year, month, 15);
  1927	  } else {
  1928	    start = new Date(year, month, 16);
  1929	    end = new Date(year, month + 1, 0); // last day of month
  1930	  }
  1931	
  1932	  return {
  1933	    start,
  1934	    end,
  1935	    startStr: formatDateStr(start),
  1936	    endStr: formatDateStr(end),
  1937	    key: formatDateStr(start) + '_' + formatDateStr(end),
  1938	    label: start.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }) + ' \u2013 ' +
  1939	           end.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
  1940	  };
  1941	}
  1942	
  1943	// ─── Calculate Hours ─────────────────────────────────
  1944	
  1945	function calculateDayHours(entries) {
  1946	  // Sort by timestamp to ensure correct pairing
  1947	  const sorted = [...entries].sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));
  1948	
  1949	  let totalMs = 0;
  1950	  let breakMs = 0;
  1951	  let clockInTime = null;
  1952	  let breakStartTime = null;
  1953	  let hasConsecutiveClockIn = false;
  1954	
  1955	  sorted.forEach(e => {
  1956	    const t = new Date(e.timestamp).getTime();
  1957	    if (e.type === 'missed-shift' && e.changeRequest) {
  1958	      // Approved missed shifts: use the stored in/out times
  1959	      if (e.changeRequest.status === 'approved' && e.changeRequest.requestedTimeIn && e.changeRequest.requestedTimeOut) {
  1960	        const inT = new Date(e.date + 'T' + e.changeRequest.requestedTimeIn + ':00').getTime();
  1961	        const outT = new Date(e.date + 'T' + e.changeRequest.requestedTimeOut + ':00').getTime();
  1962	        totalMs += outT - inT;
  1963	      }
  1964	    } else if (e.type === 'clock-in') {
  1965	      if (clockInTime !== null) {
  1966	        hasConsecutiveClockIn = true; // already clocked in — keep first, skip this one
  1967	      } else {
  1968	        clockInTime = t;
  1969	      }
  1970	    } else if (e.type === 'clock-out' && clockInTime) {
  1971	      totalMs += t - clockInTime;
  1972	      clockInTime = null;
  1973	    } else if (e.type === 'break-start') {
  1974	      breakStartTime = t;
  1975	    } else if (e.type === 'break-end' && breakStartTime) {
  1976	      breakMs += t - breakStartTime;
  1977	      breakStartTime = null;
  1978	    }
  1979	  });
  1980	
  1981	  const paidMs = totalMs - breakMs;
  1982	  return {
  1983	    totalHours: Math.max(0, paidMs / 3600000),
  1984	    breakHours: breakMs / 3600000,
  1985	    grossHours: totalMs / 3600000,
  1986	    hasConsecutiveClockIn
  1987	  };
  1988	}
  1989	
  1990	function calculateOvertimeForPeriod(dailyHours) {
  1991	  // Sum hours per Mon-Sun week, hours > 40 = overtime
  1992	  const threshold = (appSettings && appSettings.overtimeWeeklyThreshold) || 40;
  1993	  const multiplier = (appSettings && appSettings.overtimeMultiplier) || 1.5;
  1994	
  1995	  // Group days into weeks (Mon-Sun)
  1996	  const weeks = {};
  1997	  Object.keys(dailyHours).forEach(dateStr => {
  1998	    const d = new Date(dateStr + 'T12:00:00');
  1999	    const mon = getMonday(d);
  2000	    const weekKey = formatDateStr(mon);
  2001	    if (!weeks[weekKey]) weeks[weekKey] = 0;
  2002	    weeks[weekKey] += dailyHours[dateStr];
  2003	  });
  2004	
  2005	  let regular = 0;
  2006	  let overtime = 0;
  2007	  Object.values(weeks).forEach(weekTotal => {
  2008	    if (weekTotal > threshold) {
  2009	      regular += threshold;
  2010	      overtime += weekTotal - threshold;
  2011	    } else {
  2012	      regular += weekTotal;
  2013	    }
  2014	  });
  2015	
  2016	  return { regular: Math.round(regular * 100) / 100, overtime: Math.round(overtime * 100) / 100, multiplier };
  2017	}
  2018	
  2019	// ─── Period Totals (shared by renderAdminTimesheets + lock) ──
  2020	
  2021	// Which DAY made someone's total non-finite. Uses the same per-date reduction calcPeriodTotals does, so it
  2022	// cannot disagree with it, and returns null rather than guessing when nothing stands out.
  2023	function findBadDayForUid(allEntries, uid) {
  2024	  const mine = (allEntries || []).filter(e => e && e.uid === uid);
  2025	  const byDate = {};
  2026	  mine.forEach(e => { (byDate[e.date] = byDate[e.date] || []).push(e); });
  2027	  return Object.keys(byDate).sort().find(d => !Number.isFinite(calculateDayHours(byDate[d]).totalHours)) || null;
  2028	}
  2029	
  2030	function calcPeriodTotals(allEntries, roster) {
  2031	  const byUid = {};
  2032	  allEntries.forEach(e => {
  2033	    if (!byUid[e.uid]) byUid[e.uid] = { name: e.name, entries: [] };
  2034	    byUid[e.uid].entries.push(e);
  2035	  });
  2036	  roster.forEach(emp => {
  2037	    if (emp.claimedBy && byUid[emp.id]) {
  2038	      if (byUid[emp.claimedBy]) {
  2039	        byUid[emp.claimedBy].entries.push(...byUid[emp.id].entries);
  2040	      } else {
  2041	        byUid[emp.claimedBy] = { name: emp.name || byUid[emp.id].name, entries: byUid[emp.id].entries };
  2042	      }
  2043	      delete byUid[emp.id];
  2044	    }
  2045	  });
  2046	
  2047	  const result = {};
  2048	  Object.keys(byUid).forEach(uid => {
  2049	    const emp = byUid[uid];
  2050	    const byDate = {};
  2051	    emp.entries.forEach(e => {
  2052	      if (!byDate[e.date]) byDate[e.date] = [];
  2053	      byDate[e.date].push(e);
  2054	    });
  2055	    const dailyHours = {};
  2056	    Object.keys(byDate).forEach(dateStr => {
  2057	      dailyHours[dateStr] = calculateDayHours(byDate[dateStr]).totalHours;
  2058	    });
  2059	    const ot = calculateOvertimeForPeriod(dailyHours);
  2060	    result[uid] = {
  2061	      name: emp.name || '',
  2062	      regular: Math.round(ot.regular * 100) / 100,
  2063	      overtime: Math.round(ot.overtime * 100) / 100,
  2064	      totalHours: Math.round((ot.regular + ot.overtime) * 100) / 100
  2065	    };
  2066	  });
  2067	  return result;
  2068	}
  2069	
  2070	// ─── Timesheet Listeners ────────────────────────────────────
  2071	
  2072	function initTimesheetListeners() {
  2073	  document.getElementById('admin-ts-prev').addEventListener('click', () => {
  2074	    adminTsPeriodOffset--;
  2075	    renderAdminTimesheets();
  2400	    styles[rowIdx] = 'total';
  2401	    rowIdx++;
  2402	
  2403	    wsData.push([]); // blank row between employees
  2404	    rowIdx++;
  2405	  });
  2406	
  2407	  // Build worksheet
  2408	  const ws = XLSX.utils.aoa_to_sheet(wsData);
  2409	  ws['!merges'] = merges;
  2410	  ws['!cols'] = [
  2411	    { wch: 22 }, { wch: 16 }, { wch: 10 }, { wch: 10 },
  2412	    { wch: 8 }, { wch: 28 }
  2413	  ];
  2414	
  2415	  const wb = XLSX.utils.book_new();
  2416	  XLSX.utils.book_append_sheet(wb, ws, period.label);
  2417	
  2418	  const filename = `timesheets-${period.startStr}-${period.endStr}.xlsx`;
  2419	  XLSX.writeFile(wb, filename);
  2420	}
  2421	
  2422	// ─── Admin Entry Editor ──────────────────────────────
  2423	
  2424	let _aeeUid = null;
  2425	let _aeeName = null;
  2426	let _aeeEntries = [];
  2427	
  2428	async function openAdminEntryEditor(uid, name, dateStr) {
  2429	  _aeeUid = uid;
  2430	  _aeeName = name;
  2431	  _aeeEntries = [];
  2432	
  2433	  const title = document.getElementById('aee-title');
  2434	  const dateObj = new Date(dateStr + 'T12:00:00');
  2435	  const dateLabel = dateObj.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric', year: 'numeric' });
  2436	  title.textContent = `Edit Entries — ${name} — ${dateLabel}`;
  2437	
  2438	  document.getElementById('aee-new-date').value = dateStr;
  2439	  document.getElementById('aee-new-time').value = '';
  2440	  document.getElementById('aee-reason').value = '';
  2441	  document.getElementById('aee-entries-list').innerHTML = '<div class="empty-state" style="font-size:13px; padding:12px 0;">Loading...</div>';
  2442	  document.getElementById('admin-entry-editor-modal').classList.add('open');
  2443	
  2444	  try {
  2445	    const db = getDb();
  2446	    const snap = await db.collection('timeclock_entries')
  2447	      .where('uid', '==', uid)
  2448	      .where('date', '==', dateStr)
  2449	      .orderBy('timestamp', 'asc')
  2450	      .get();
  2451	    _aeeEntries = snap.docs.map(d => ({ id: d.id, ...d.data() }));
  2452	  } catch (err) {
  2453	    console.error('Failed to load entries:', err);
  2454	    _aeeEntries = [];
  2455	  }
  2456	  renderAeeEntries();
  2457	}
  2458	
  2459	function renderAeeEntries() {
  2460	  const container = document.getElementById('aee-entries-list');
  2461	  if (!_aeeEntries.length) {
  2462	    container.innerHTML = '<div class="empty-state" style="font-size:13px; padding:12px 0;">No entries for this date</div>';
  2463	    return;
  2464	  }
  2465	  container.innerHTML = `
  2466	    <div style="font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:0.06em; color:var(--text-medium); margin-bottom:8px;">Existing Entries</div>
  2467	    ${_aeeEntries.map(e => {
  2468	      const hhmm = aeeIsoToHHMM(e.timestamp);
  2469	      const label = getEntryLabel(e.type);
  2470	      const adminNote = e.adminEdit ? `<span style="font-size:10px; color:var(--purple); margin-left:6px;">admin edit</span>` : '';
  2471	      return `<div style="display:flex; align-items:center; gap:8px; padding:6px 0; border-bottom:1px solid var(--border-light);">
  2472	        <span style="font-size:12px; font-weight:600; width:90px; flex-shrink:0;">${escapeHtml(label)}${adminNote}</span>
  2473	        <input type="time" id="aee-t-${escapeHtml(e.id)}" value="${escapeHtml(hhmm)}"
  2474	               style="flex:1; padding:5px 8px; border:1px solid var(--border-light); border-radius:4px; font-family:inherit; font-size:12px;">
  2475	        <button class="btn btn-sm btn-primary" onclick="adminEditSaveEntry(${jsArg(e.id)})"
  2476	                style="font-size:11px; padding:3px 10px; white-space:nowrap;">Save</button>
  2477	        <button class="btn btn-sm" onclick="adminEditDeleteEntry(${jsArg(e.id)})"
  2478	                style="font-size:11px; padding:3px 10px; color:var(--red); border-color:var(--red); white-space:nowrap;">Delete</button>
  2479	      </div>`;
  2480	    }).join('')}
  2481	  `;
  2482	}
  2483	
  2484	function aeeIsoToHHMM(isoStr) {
  2485	  const d = new Date(isoStr);
  2486	  return d.toLocaleTimeString('en-GB', { timeZone: 'America/Denver' }).substring(0, 5);
  2487	}
  2488	
  2489	function hhmmDateToMTDate(dateStr, hhmmStr) {
  2490	  // Build a UTC Date representing hhmmStr as Mountain Time on dateStr.
  2491	  // Try MDT (UTC-6) first; verify round-trip; fall back to MST (UTC-7).
  2492	  const mdtCandidate = new Date(`${dateStr}T${hhmmStr}:00-06:00`);
  2493	  const rt = mdtCandidate.toLocaleTimeString('en-GB', { timeZone: 'America/Denver' }).substring(0, 5);
  2494	  return rt === hhmmStr ? mdtCandidate : new Date(`${dateStr}T${hhmmStr}:00-07:00`);
  2495	}
  2496	
  2497	function aeeRequireReason() {
  2498	  const reason = (document.getElementById('aee-reason').value || '').trim();
  2499	  if (!reason) {
  2500	    document.getElementById('aee-reason').focus();
  2501	    document.getElementById('aee-reason').style.borderColor = 'var(--red)';
  2502	    setTimeout(() => document.getElementById('aee-reason').style.borderColor = '', 2000);
  2503	    return null;
  2504	  }
  2505	  return reason;
  2506	}
  2507	
  2508	// Edits already being saved in THIS tab (Phase 5 review): the write is awaited now, so a second click
  2509	// during the round-trip would otherwise send a second update.
  2510	const _aeeSaveInFlight = new Set();
  2511	
  2512	async function adminEditSaveEntry(entryId) {
  2513	  if (_aeeSaveInFlight.has(entryId)) return;
  2514	  const reason = aeeRequireReason();
  2515	  if (!reason) return;
  2516	
  2517	  const entry = _aeeEntries.find(e => e.id === entryId);
  2518	  if (!entry) return;
  2519	
  2520	  const timeInput = document.getElementById(`aee-t-${entryId}`);
  2521	  if (!timeInput || !timeInput.value) { alert('Enter a time.'); return; }
  2522	
  2523	  const updated = hhmmDateToMTDate(entry.date, timeInput.value);
  2524	
  2525	  const user = getAuthUser();
  2526	  const fieldDelete = firebase.firestore.FieldValue.delete();
  2527	  const adminEdit = { by: user ? user.name : 'admin', at: new Date().toISOString(), reason };
  2528	  const updates = { timestamp: updated.toISOString(), adminEdit };
  2529	
  2530	  // Recalculate late flags for clock-in entries based on the new time
  2531	  if (entry.type === 'clock-in') {
  2532	    if (entry.scheduledStart) {
  2533	      const shiftStart = hhmmDateToMTDate(entry.date, entry.scheduledStart);
  2534	      const minsLate = Math.round((updated.getTime() - shiftStart.getTime()) / 60000);
  2535	      if (minsLate >= 10) {
  2536	        updates.lateClockIn = true;
  2537	        updates.minutesLate = minsLate;
  2538	        updates.flaggedForReview = true;
  2539	      } else {
  2540	        updates.lateClockIn = fieldDelete;
  2541	        updates.minutesLate = fieldDelete;
  2542	        updates.flaggedForReview = fieldDelete;
  2543	      }
  2544	    } else {
  2545	      updates.lateClockIn = fieldDelete;
  2546	      updates.minutesLate = fieldDelete;
  2547	      updates.flaggedForReview = fieldDelete;
  2548	    }
  2549	  }
  2550	  // Awaited (Phase 5, plan review finding): updateClockEntry now returns a Promise, and an unawaited
  2551	  // Promise is always truthy — this guard would have silently stopped working, and a denied edit on a
  2552	  // locked pay period would have shown "Saved" and updated the row on screen.
  2553	  _aeeSaveInFlight.add(entryId);
  2554	  let ok = false;
  2555	  try {
  2556	    ok = await updateClockEntry(entryId, updates);
  2557	  } finally {
  2558	    _aeeSaveInFlight.delete(entryId);
  2559	  }
  2560	
  2561	  if (ok) {
  2562	    entry.timestamp = updated.toISOString();
  2563	    entry.adminEdit = adminEdit;
  2564	    if (updates.lateClockIn === true) {
  2565	      entry.lateClockIn = true;
  2566	      entry.minutesLate = updates.minutesLate;
  2567	      entry.flaggedForReview = true;
  2568	    } else {
  2569	      delete entry.lateClockIn;
  2570	      delete entry.minutesLate;
  2571	      delete entry.flaggedForReview;
  2572	    }
  2573	    showToast(`Saved — ${entry.name} ${getEntryLabel(entry.type)} updated to ${formatTime(updated)}`);
  2574	    renderAeeEntries();
  2575	    renderAdminTimesheets();
  2576	  } else {
  2577	    alert('Save failed — see console.');
  2578	  }
  2579	}
  2580	
  2581	async function adminEditDeleteEntry(entryId) {
  2582	  const reason = aeeRequireReason();
  2583	  if (!reason) return;
  2584	
  2585	  const entry = _aeeEntries.find(e => e.id === entryId);
  2586	  if (!entry) return;
  2587	  if (!confirm(`Delete ${getEntryLabel(entry.type)} at ${formatTime(new Date(entry.timestamp))} for ${entry.name}?`)) return;
  2588	
  2589	  const ok = await deleteClockEntry(entryId);
  2590	  if (ok) {
  2591	    _aeeEntries = _aeeEntries.filter(e => e.id !== entryId);
  2592	    showToast(`Deleted ${getEntryLabel(entry.type)} for ${entry.name}`);
  2593	    renderAeeEntries();
  2594	    renderAdminTimesheets();
  2595	  } else {
  2596	    alert('Delete failed — see console.');
  2597	  }
  2598	}
  2599	
  2600	async function adminEditAddEntry() {
  2601	  const reason = aeeRequireReason();
  2602	  if (!reason) return;
  2603	
  2604	  const type = document.getElementById('aee-new-type').value;
  2605	  const dateStr = document.getElementById('aee-new-date').value;
  2606	  const timeStr = document.getElementById('aee-new-time').value;
  2607	
  2608	  if (!dateStr || !timeStr) { alert('Enter a date and time.'); return; }
  2609	
  2610	  const ts = hhmmDateToMTDate(dateStr, timeStr);
  2611	
  2612	  const dayNames = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
  2613	  const user = getAuthUser();
  2614	  const entry = {
  2615	    uid: _aeeUid,
  2616	    name: _aeeName,
  2617	    type,
  2618	    timestamp: ts.toISOString(),
  2619	    date: dateStr,
  2620	    weekday: dayNames[new Date(dateStr + 'T12:00:00').getDay()],
  2621	    studio: 'tinker',
  2622	    adminEdit: { by: user ? user.name : 'admin', at: new Date().toISOString(), reason }
  2623	  };
  2624	
  2625	  const id = await addClockEntry(entry);
  2626	  if (id) {
  2627	    _aeeEntries.push({ id, ...entry });
  2628	    _aeeEntries.sort((a, b) => (a.timestamp || '').localeCompare(b.timestamp || ''));
  2629	    document.getElementById('aee-new-time').value = '';
  2630	    showToast(`Added ${getEntryLabel(type)} at ${formatTime(ts)} for ${_aeeName}`);
  2631	    renderAeeEntries();
  2632	    renderAdminTimesheets();
  2633	  } else {
  2634	    alert('Add failed — see console.');
  2635	  }
  2636	}
  2637	
  2638	function closeAdminEntryEditor() {
  2639	  document.getElementById('admin-entry-editor-modal').classList.remove('open');
  2640	}
  2641	
  2642	// ─── Change Requests ─────────────────────────────────
  2643	
  2644	function renderChangeRequests(entries, period) {
  2645	  const container = document.getElementById('change-requests-list');
  2646	  const countEl = document.getElementById('change-req-count');
  2647	
  2648	  if (entries.length === 0) {
  2649	    container.innerHTML = '<div class="empty-state">No pending requests</div>';
  2650	    countEl.textContent = '0';
  2651	    return;
  2652	  }
  2653	
  2654	  countEl.textContent = entries.length;
  2655	  container.innerHTML = entries.map(e => {
  2656	    const req = e.changeRequest;
  2657	    const isMissing = e.missingPunch;
  2658	    const isMissedShift = e.type === 'missed-shift';
  2659	    const typeBadge = isMissing
  2660	      ? `<span style="display:inline-block; font-size:10px; font-weight:800; text-transform:uppercase; background:var(--purple); color:#fff; padding:2px 6px; border-radius:4px; margin-left:6px;">${isMissedShift ? 'Missed Shift' : 'Missing Punch'}</span>`
  2661	      : '';
  2662	    const typeLabel = getEntryLabel(e.type);
  2663	
  2664	    // Find schedule for this employee on this date
  2665	    const schedData = allSchedules.find(s => s.uid === e.uid);
  2666	    const dateObj = new Date(e.date + 'T12:00:00');
  2667	    const dayKey = DAYS[(dateObj.getDay() + 6) % 7];
  2668	    const shift = schedData ? getShiftForDate(schedData, e.date, dayKey) : null;
  2669	    const schedHtml = shift ? `<div style="font-size:11px; color:var(--teal); margin-top:4px;">Scheduled: ${formatTimeStr(shift.start)}\u2013${formatTimeStr(shift.end)} @ ${escapeHtml(shift.studio || 'tinker')}</div>` : '';
  2670	
  2671	    let detailHtml;
  2672	    if (isMissedShift) {
  2673	      detailHtml = `<div style="display:flex; gap:8px; align-items:center; margin:6px 0;">
  2674	          <label style="font-size:12px; font-weight:600;">In:</label>
  2675	          <input type="time" id="cr-in-${escapeHtml(e.id)}" value="${escapeHtml(req.requestedTimeIn)}" style="padding:4px 8px; border:1px solid var(--border-light); border-radius:4px; font-family:inherit; font-size:12px;">
  2676	          <label style="font-size:12px; font-weight:600;">Out:</label>
  2677	          <input type="time" id="cr-out-${escapeHtml(e.id)}" value="${escapeHtml(req.requestedTimeOut)}" style="padding:4px 8px; border:1px solid var(--border-light); border-radius:4px; font-family:inherit; font-size:12px;">
  2678	        </div>
  2679	        Reason: ${escapeHtml(req.reason)}${schedHtml}`;
  2680	    } else {
  2681	      detailHtml = `${isMissing ? `Type: ${escapeHtml(typeLabel)}<br>` : `Current: ${formatTime(new Date(e.timestamp))}<br>`}
  2682	        <div style="display:flex; gap:8px; align-items:center; margin:4px 0;">
  2683	          <label style="font-size:12px; font-weight:600;">Time:</label>
  2684	          <input type="time" id="cr-time-${escapeHtml(e.id)}" value="${escapeHtml(req.requestedTime)}" style="padding:4px 8px; border:1px solid var(--border-light); border-radius:4px; font-family:inherit; font-size:12px;">
  2685	        </div>
  2686	        Reason: ${escapeHtml(req.reason)}${schedHtml}`;
  2687	    }
  2688	
  2689	    return `
  2690	      <div class="change-req-item">
  2691	        <div class="change-req-header">
  2692	          <strong>${escapeHtml(e.name)}</strong> ${typeBadge}
  2693	          <span style="font-size:12px; color:var(--text-light);">${escapeHtml(e.date)}</span>
  2694	        </div>
  2695	        <div class="change-req-detail">${detailHtml}</div>
  2696	        <div class="change-req-actions">
  2697	          <button class="btn btn-sm btn-primary" onclick="handleChangeRequest(${jsArg(e.id)}, 'approved')">Approve</button>
  2698	          <button class="btn btn-sm btn-secondary" onclick="document.getElementById(${jsArg('cr-deny-wrap-' + e.id)}).style.display='block';document.getElementById(${jsArg('cr-deny-reason-' + e.id)}).focus()">Deny</button>
  2699	        </div>
  2700	        <div id="cr-deny-wrap-${escapeHtml(e.id)}" style="display:none; margin-top:8px;">
  2701	          <input type="text" id="cr-deny-reason-${escapeHtml(e.id)}" placeholder="Reason for denial (optional)" style="width:100%; padding:6px 10px; border:1px solid var(--border-light); border-radius:4px; font-family:inherit; font-size:12px; margin-bottom:6px; box-sizing:border-box;">
  2702	          <div style="display:flex; gap:6px;">
  2703	            <button class="btn btn-sm btn-secondary" onclick="handleChangeRequest(${jsArg(e.id)}, 'denied')" style="flex:1;">Confirm Deny</button>
  2704	            <button class="btn btn-sm" style="background:transparent; color:var(--text-medium); border:1px solid var(--border-light);" onclick="document.getElementById(${jsArg('cr-deny-wrap-' + e.id)}).style.display='none'">Cancel</button>
  2705	          </div>
  2706	        </div>
  2707	      </div>`;
  2708	  }).join('');
  2709	}
  2710	
  2711	async function handleChangeRequest(entryId, status) {
  2712	  const user = getAuthUser();
  2713	
  2714	  // First, read the full entry to get the current timestamp + changeRequest
  2715	  let entryDoc;
  2716	  try {
  2717	    const doc = await getDb().collection('timeclock_entries').doc(entryId).get();
  2718	    if (!doc.exists) { alert('Entry not found.'); return; }
  2719	    entryDoc = doc.data();
  2720	  } catch (err) {
  2721	    alert('Failed to read entry.'); return;
  2722	  }
  2723	
  2724	  const isMissedShift = entryDoc.type === 'missed-shift';
  2725	
  2726	  const updates = {
  2727	    'changeRequest.status': status,
  2728	    'changeRequest.reviewedBy': user ? user.name : 'unknown',
  2729	    'changeRequest.reviewedAt': new Date().toISOString()
  2730	  };
  2731	
  2732	  // Read deny reason if provided
  2733	  const denyReasonEl = document.getElementById('cr-deny-reason-' + entryId);
  2734	  const denyReason = denyReasonEl ? denyReasonEl.value.trim() : '';
  2735	  if (status === 'denied' && denyReason) {
  2736	    updates['changeRequest.denialReason'] = denyReason;
  2737	  }
  2738	
  2739	  if (status === 'approved') {
  2740	    if (isMissedShift) {
  2741	      // Read editable time inputs (admin may have adjusted)
  2742	      const inEl = document.getElementById('cr-in-' + entryId);
  2743	      const outEl = document.getElementById('cr-out-' + entryId);
  2744	      const finalTimeIn = inEl ? inEl.value : entryDoc.changeRequest.requestedTimeIn;
  2745	      const finalTimeOut = outEl ? outEl.value : entryDoc.changeRequest.requestedTimeOut;
  2746	      updates['changeRequest.requestedTimeIn'] = finalTimeIn;
  2747	      updates['changeRequest.requestedTimeOut'] = finalTimeOut;
  2748	      updates['timestamp'] = new Date(entryDoc.date + 'T' + finalTimeIn + ':00').toISOString();
  2749	    } else if (entryDoc.changeRequest && entryDoc.changeRequest.requestedTime) {
  2750	      // Read editable time input (admin may have adjusted)
  2751	      const timeEl = document.getElementById('cr-time-' + entryId);
  2752	      const finalTime = timeEl ? timeEl.value : entryDoc.changeRequest.requestedTime;
  2753	      updates['changeRequest.originalTimestamp'] = entryDoc.timestamp;
  2754	      updates['changeRequest.requestedTime'] = finalTime;
  2755	      const newTimestamp = new Date(entryDoc.date + 'T' + finalTime + ':00').toISOString();
  2756	      updates['timestamp'] = newTimestamp;
  2757	    }
  2758	  }
  2759	
  2760	  const success = await updateClockEntry(entryId, updates);
  2761	  if (success) {
  2762	    // Send push to staff member
  2763	    if (entryDoc.uid) {
  2764	      if (status === 'approved') {
  2765	        sendPushToUser(entryDoc.uid, 'Time Correction Approved', 'Your time correction request has been approved.');
  2766	      } else if (status === 'denied') {
  2767	        const msg = denyReason ? `Your time correction request was not approved. ${denyReason}` : 'Your time correction request was not approved.';
  2768	        sendPushToUser(entryDoc.uid, 'Time Correction Update', msg);
  2769	      }
  2770	    }
  2771	    renderAdminTimesheets();
  2772	    renderDashboardPending();
  2773	  } else {
  2774	    alert('Failed to update request.');
  2775	  }
  2776	}
  2777	
  2778	// ─── Change Log (Audit Trail) ───────────────────────
  2779	
  2780	function renderChangeLog(entries) {
  2781	  const container = document.getElementById('change-log-list');
  2782	  if (!container) return;
  2783	
  2784	  if (entries.length === 0) {
  2785	    container.innerHTML = '<div class="empty-state">No resolved requests this period</div>';
  2786	    return;
  2787	  }
  2788	
  2789	  // Sort by review date (most recent first)
  2790	  entries.sort((a, b) => (b.changeRequest.reviewedAt || '').localeCompare(a.changeRequest.reviewedAt || ''));
  2791	
  2792	  container.innerHTML = entries.map(e => {
  2793	    const req = e.changeRequest;
  2794	    const isApproved = req.status === 'approved';
  2795	    const statusIcon = isApproved ? '\u2705' : '\u274C';
  2796	    const statusLabel = isApproved ? 'Approved' : 'Denied';
  2797	    const statusColor = isApproved ? 'var(--green)' : 'var(--red)';
  2798	    const typeLabel = getEntryLabel(e.type);
  2799	    const isMissing = e.missingPunch;
  2800	

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '1840,2070p'; nl -ba js/firebase-data.js | sed -n '740,940p'; nl -ba pay-period-lock.emulator.test.js | sed -n '1,280p'; nl -ba firebase-data.failure.test.js | sed -n '1,260p'; nl -ba package.json | sed -n '1,140p'" in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
  1840	        <div class="staff-name">${escapeHtml(m.name)}</div>
  1841	        <div class="staff-info">
  1842	          <span style="color:var(--red); font-weight:700;">${m.minutesLate} min late</span>
  1843	          <div style="font-size:12px; color:var(--text-medium);">Shift: ${formatTimeStr(m.shiftStart)}</div>
  1844	        </div>
  1845	      </div>
  1846	    `).join('');
  1847	  }
  1848	}
  1849	
  1850	// ─── Helper: Time string to today's Date ─────────────
  1851	
  1852	function timeStrToDate(timeStr) {
  1853	  if (!timeStr) return new Date();
  1854	  const [h, m] = timeStr.split(':').map(Number);
  1855	  const d = new Date();
  1856	  d.setHours(h, m, 0, 0);
  1857	  return d;
  1858	}
  1859	
  1860	// ═══════════════════════════════════════════════════════
  1861	// PHASE 5: TIMESHEETS & REVIEW
  1862	// ═══════════════════════════════════════════════════════
  1863	
  1864	// Semi-monthly pay periods: 1st–15th and 16th–end of month
  1865	
  1866	let adminTsPeriodOffset = 0;
  1867	let lockedPeriods = {};
  1868	
  1869	function isDateInLockedPeriod(dateStr) {
  1870	  return Object.keys(lockedPeriods).some(key => {
  1871	    const [start, end] = key.split('_');
  1872	    return dateStr >= start && dateStr <= end;
  1873	  });
  1874	}
  1875	
  1876	// ─── Pay Period Helpers ──────────────────────────────
  1877	
  1878	// A period reconstructed from its own key, so an action can name the period it was rendered for rather
  1879	// than whichever one the offset points at by the time it runs.
  1880	function getPayPeriodByKey(key) {
  1881	  // Returns null unless `key` is EXACTLY a key getPayPeriod() can produce. An irreversible delete must not
  1882	  // act on a guess. The shape check alone was not enough: JS normalises impossible dates, so 2026-02-29
  1883	  // silently became March 1 and passed (round-four review, Sep 28). Components are therefore compared back,
  1884	  // and the semi-month semantics enforced: periods run 1-15 or 16-end-of-month, within one month.
  1885	  const m = /^(\d{4})-(\d{2})-(\d{2})_(\d{4})-(\d{2})-(\d{2})$/.exec(String(key || ''));
  1886	  if (!m) return null;
  1887	  const [, y1, m1, d1, y2, m2, d2] = m.map(Number);
  1888	  const start = new Date(y1, m1 - 1, d1, 12);
  1889	  const end = new Date(y2, m2 - 1, d2, 12);
  1890	  // no silent normalisation: 2026-02-29 must not come back as March 1
  1891	  if (start.getFullYear() !== y1 || start.getMonth() !== m1 - 1 || start.getDate() !== d1) return null;
  1892	  if (end.getFullYear() !== y2 || end.getMonth() !== m2 - 1 || end.getDate() !== d2) return null;
  1893	  if (y1 !== y2 || m1 !== m2) return null;
  1894	  const lastDay = new Date(y1, m1, 0).getDate();
  1895	  const canonical = (d1 === 1 && d2 === 15) || (d1 === 16 && d2 === lastDay);
  1896	  if (!canonical) return null;
  1897	  const startStr = `${m[1]}-${m[2]}-${m[3]}`;
  1898	  const endStr = `${m[4]}-${m[5]}-${m[6]}`;
  1899	  const label = start.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })
  1900	    + ' \u2013 ' + end.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
  1901	  return { key, startStr, endStr, label };
  1902	}
  1903	
  1904	function getPayPeriod(offset) {
  1905	  const now = new Date();
  1906	  now.setHours(0, 0, 0, 0);
  1907	
  1908	  // Determine current half-month: day <= 15 → first half, else second half
  1909	  let year = now.getFullYear();
  1910	  let month = now.getMonth();
  1911	  let isFirstHalf = now.getDate() <= 15;
  1912	
  1913	  // Each period is one "half" — offset by halves
  1914	  let totalHalves = month * 2 + (isFirstHalf ? 0 : 1) + offset;
  1915	
  1916	  // Normalize (handle negative offsets wrapping to previous year)
  1917	  while (totalHalves < 0) { totalHalves += 24; year--; }
  1918	  while (totalHalves >= 24) { totalHalves -= 24; year++; }
  1919	
  1920	  month = Math.floor(totalHalves / 2);
  1921	  isFirstHalf = (totalHalves % 2) === 0;
  1922	
  1923	  let start, end;
  1924	  if (isFirstHalf) {
  1925	    start = new Date(year, month, 1);
  1926	    end = new Date(year, month, 15);
  1927	  } else {
  1928	    start = new Date(year, month, 16);
  1929	    end = new Date(year, month + 1, 0); // last day of month
  1930	  }
  1931	
  1932	  return {
  1933	    start,
  1934	    end,
  1935	    startStr: formatDateStr(start),
  1936	    endStr: formatDateStr(end),
  1937	    key: formatDateStr(start) + '_' + formatDateStr(end),
  1938	    label: start.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }) + ' \u2013 ' +
  1939	           end.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
  1940	  };
  1941	}
  1942	
  1943	// ─── Calculate Hours ─────────────────────────────────
  1944	
  1945	function calculateDayHours(entries) {
  1946	  // Sort by timestamp to ensure correct pairing
  1947	  const sorted = [...entries].sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));
  1948	
  1949	  let totalMs = 0;
  1950	  let breakMs = 0;
  1951	  let clockInTime = null;
  1952	  let breakStartTime = null;
  1953	  let hasConsecutiveClockIn = false;
  1954	
  1955	  sorted.forEach(e => {
  1956	    const t = new Date(e.timestamp).getTime();
  1957	    if (e.type === 'missed-shift' && e.changeRequest) {
  1958	      // Approved missed shifts: use the stored in/out times
  1959	      if (e.changeRequest.status === 'approved' && e.changeRequest.requestedTimeIn && e.changeRequest.requestedTimeOut) {
  1960	        const inT = new Date(e.date + 'T' + e.changeRequest.requestedTimeIn + ':00').getTime();
  1961	        const outT = new Date(e.date + 'T' + e.changeRequest.requestedTimeOut + ':00').getTime();
  1962	        totalMs += outT - inT;
  1963	      }
  1964	    } else if (e.type === 'clock-in') {
  1965	      if (clockInTime !== null) {
  1966	        hasConsecutiveClockIn = true; // already clocked in — keep first, skip this one
  1967	      } else {
  1968	        clockInTime = t;
  1969	      }
  1970	    } else if (e.type === 'clock-out' && clockInTime) {
  1971	      totalMs += t - clockInTime;
  1972	      clockInTime = null;
  1973	    } else if (e.type === 'break-start') {
  1974	      breakStartTime = t;
  1975	    } else if (e.type === 'break-end' && breakStartTime) {
  1976	      breakMs += t - breakStartTime;
  1977	      breakStartTime = null;
  1978	    }
  1979	  });
  1980	
  1981	  const paidMs = totalMs - breakMs;
  1982	  return {
  1983	    totalHours: Math.max(0, paidMs / 3600000),
  1984	    breakHours: breakMs / 3600000,
  1985	    grossHours: totalMs / 3600000,
  1986	    hasConsecutiveClockIn
  1987	  };
  1988	}
  1989	
  1990	function calculateOvertimeForPeriod(dailyHours) {
  1991	  // Sum hours per Mon-Sun week, hours > 40 = overtime
  1992	  const threshold = (appSettings && appSettings.overtimeWeeklyThreshold) || 40;
  1993	  const multiplier = (appSettings && appSettings.overtimeMultiplier) || 1.5;
  1994	
  1995	  // Group days into weeks (Mon-Sun)
  1996	  const weeks = {};
  1997	  Object.keys(dailyHours).forEach(dateStr => {
  1998	    const d = new Date(dateStr + 'T12:00:00');
  1999	    const mon = getMonday(d);
  2000	    const weekKey = formatDateStr(mon);
  2001	    if (!weeks[weekKey]) weeks[weekKey] = 0;
  2002	    weeks[weekKey] += dailyHours[dateStr];
  2003	  });
  2004	
  2005	  let regular = 0;
  2006	  let overtime = 0;
  2007	  Object.values(weeks).forEach(weekTotal => {
  2008	    if (weekTotal > threshold) {
  2009	      regular += threshold;
  2010	      overtime += weekTotal - threshold;
  2011	    } else {
  2012	      regular += weekTotal;
  2013	    }
  2014	  });
  2015	
  2016	  return { regular: Math.round(regular * 100) / 100, overtime: Math.round(overtime * 100) / 100, multiplier };
  2017	}
  2018	
  2019	// ─── Period Totals (shared by renderAdminTimesheets + lock) ──
  2020	
  2021	// Which DAY made someone's total non-finite. Uses the same per-date reduction calcPeriodTotals does, so it
  2022	// cannot disagree with it, and returns null rather than guessing when nothing stands out.
  2023	function findBadDayForUid(allEntries, uid) {
  2024	  const mine = (allEntries || []).filter(e => e && e.uid === uid);
  2025	  const byDate = {};
  2026	  mine.forEach(e => { (byDate[e.date] = byDate[e.date] || []).push(e); });
  2027	  return Object.keys(byDate).sort().find(d => !Number.isFinite(calculateDayHours(byDate[d]).totalHours)) || null;
  2028	}
  2029	
  2030	function calcPeriodTotals(allEntries, roster) {
  2031	  const byUid = {};
  2032	  allEntries.forEach(e => {
  2033	    if (!byUid[e.uid]) byUid[e.uid] = { name: e.name, entries: [] };
  2034	    byUid[e.uid].entries.push(e);
  2035	  });
  2036	  roster.forEach(emp => {
  2037	    if (emp.claimedBy && byUid[emp.id]) {
  2038	      if (byUid[emp.claimedBy]) {
  2039	        byUid[emp.claimedBy].entries.push(...byUid[emp.id].entries);
  2040	      } else {
  2041	        byUid[emp.claimedBy] = { name: emp.name || byUid[emp.id].name, entries: byUid[emp.id].entries };
  2042	      }
  2043	      delete byUid[emp.id];
  2044	    }
  2045	  });
  2046	
  2047	  const result = {};
  2048	  Object.keys(byUid).forEach(uid => {
  2049	    const emp = byUid[uid];
  2050	    const byDate = {};
  2051	    emp.entries.forEach(e => {
  2052	      if (!byDate[e.date]) byDate[e.date] = [];
  2053	      byDate[e.date].push(e);
  2054	    });
  2055	    const dailyHours = {};
  2056	    Object.keys(byDate).forEach(dateStr => {
  2057	      dailyHours[dateStr] = calculateDayHours(byDate[dateStr]).totalHours;
  2058	    });
  2059	    const ot = calculateOvertimeForPeriod(dailyHours);
  2060	    result[uid] = {
  2061	      name: emp.name || '',
  2062	      regular: Math.round(ot.regular * 100) / 100,
  2063	      overtime: Math.round(ot.overtime * 100) / 100,
  2064	      totalHours: Math.round((ot.regular + ot.overtime) * 100) / 100
  2065	    };
  2066	  });
  2067	  return result;
  2068	}
  2069	
  2070	// ─── Timesheet Listeners ────────────────────────────────────
   740	    ]);
   741	    if (byStatus.status === 'rejected') throw byStatus.reason;
   742	    if (byMarker.status === 'rejected') console.error('Failed to get flagged time off requests:', byMarker.reason);
   743	    const docs = [...byStatus.value.docs, ...(byMarker.status === 'fulfilled' ? byMarker.value.docs : [])];
   744	    return mergePendingTimeOff(docs.map(d => ({ id: d.id, ...d.data() })));
   745	  } catch (err) {
   746	    console.error('Failed to get pending time off requests:', err);
   747	    return [];
   748	  }
   749	}
   750	
   751	async function updateTimeOffRequest(docId, updates) {
   752	  if (!_ready) return false;
   753	  try {
   754	    await _db.collection('timeclock_timeoff').doc(docId).update({
   755	      ...updates,
   756	      updatedAt: firebase.firestore.FieldValue.serverTimestamp()
   757	    });
   758	    return true;
   759	  } catch (err) {
   760	    console.error('Failed to update time off request:', err);
   761	    return false;
   762	  }
   763	}
   764	
   765	// The transaction guards below compare with sameStructure() from js/schedule-helpers.js (loaded after this
   766	// file, called only at runtime): key-order-independent, so a value this tab just wrote — which can come back
   767	// from the local cache in insertion order — never refuses a correct write.
   768	
   769	// Transaction-based read-modify-write on a single proposedSubs[] entry, per Plan 2 Phase 3: two admins
   770	// acting on the same request's subs near-simultaneously must never lose either write, which a bare
   771	// updateDoc (the prior toggleSubConfirm() behavior) could. expectedSubName guards against a stale
   772	// in-memory index — if the doc changed shape since the caller last read it, this aborts rather than
   773	// silently patching the wrong sub. Mirrors timeoff-sub-confirm.emulator.test.js's proven write shape.
   774	// `expectApplied` (optional, Phase 3b): the sub's appliedOverrides the caller decided on, compared
   775	// structurally inside the transaction. A same-name re-confirm in another tab replaces that record; without
   776	// this the un-confirm would clear the NEW record on the strength of index+name alone.
   777	// `expectRequest` (optional, Phase 3b review): { statuses, reversalPending, subUid, confirmed } — the
   778	// request must still be in one of `statuses`, its marker must match, and the entry's subUid / confirmed
   779	// flag must match, all inside the transaction. The retry path's un-confirms are only right while the
   780	// request is denied/withdrawn and still flagged; a confirm is only right while the entry is still
   781	// un-confirmed (Phase 4: a confirm modal left open must not overwrite a confirmation made meanwhile). A
   782	// point-in-time pre-check cannot promise either at write time; this can.
   783	async function confirmTimeOffSub(requestId, subIndex, expectedSubName, patch, expectApplied, expectRequest) {
   784	  if (!_ready) return { success: false, reason: 'not-ready' };
   785	  const ref = _db.collection('timeclock_timeoff').doc(requestId);
   786	  try {
   787	    return await _db.runTransaction(async (tx) => {
   788	      const doc = await tx.get(ref);
   789	      if (!doc.exists) return { success: false, reason: 'not-found' };
   790	      const data = doc.data();
   791	      const subs = data.proposedSubs || [];
   792	      if (!subs[subIndex] || subs[subIndex].name !== expectedSubName) {
   793	        return { success: false, reason: 'sub-changed' };
   794	      }
   795	      if (expectApplied !== undefined
   796	          && !sameStructure(subs[subIndex].appliedOverrides || {}, expectApplied || {})) {
   797	        return { success: false, reason: 'sub-changed', field: 'appliedOverrides' };
   798	      }
   799	      const want = expectRequest || {};
   800	      if (want.statuses && !want.statuses.includes(data.status)) return { success: false, reason: 'status-changed', status: data.status };
   801	      if (want.reversalPending !== undefined && !!data.reversalPending !== want.reversalPending) return { success: false, reason: 'changed', field: 'reversalPending' };
   802	      if (want.subUid !== undefined && (subs[subIndex].subUid || null) !== (want.subUid || null)) return { success: false, reason: 'sub-changed', field: 'subUid' };
   803	      if (want.confirmed !== undefined && !!subs[subIndex].confirmed !== want.confirmed) return { success: false, reason: 'sub-changed', field: 'confirmed' };
   804	      // `dates` (optional, plan: ticker-sub-confirm-only-by-manager): the request's dates the confirm box was built
   805	      // from, normalized. AFTER the confirmed/subUid checks on purpose: if someone else confirmed this sub AND the
   806	      // dates moved, the caller must see 'sub-changed' — that path partitions the rollback and keeps their shift;
   807	      // a 'dates' refusal rolls ours back whole, which could delete a colleague's confirmed coverage.
   808	      if (want.dates !== undefined && !sameStructure(normalizeRequestDates(data.dates), want.dates)) return { success: false, reason: 'changed', field: 'dates' };
   809	      subs[subIndex] = { ...subs[subIndex], ...patch };
   810	      const allConfirmed = subs.every(s => s.confirmed);
   811	      const someConfirmed = subs.some(s => s.confirmed);
   812	      const coverageStatus = allConfirmed ? 'secured' : someConfirmed ? 'partial' : 'pending';
   813	      tx.update(ref, {
   814	        proposedSubs: subs,
   815	        coverageStatus,
   816	        updatedAt: firebase.firestore.FieldValue.serverTimestamp()
   817	      });
   818	      return { success: true };
   819	    });
   820	  } catch (err) {
   821	    console.error('Failed to confirm time off sub:', err);
   822	    return { success: false, reason: 'error' };
   823	  }
   824	}
   825	
   826	// Reads one time-off request as { ok, exists, data }. Three states, kept distinct on purpose: a failed
   827	// READ (ok:false) is not the same as a request that has been deleted (ok:true, exists:false), and neither
   828	// is a request that is there (ok:true, exists:true). Collapsing the first two into `null` is the pattern
   829	// that made a rules regression look like deleted data elsewhere in this app — see getHfwaByDateRangeResult.
   830	// Added so the approve orchestration in js/timeoff-schedule.js can take its read through an injected
   831	// dependency rather than reaching for getDb() directly.
   832	async function getTimeOffRequestResult(requestId) {
   833	  if (!_ready) return { ok: false, exists: false, data: null };
   834	  try {
   835	    const doc = await _db.collection('timeclock_timeoff').doc(requestId).get();
   836	    return { ok: true, exists: doc.exists, data: doc.exists ? doc.data() : null };
   837	  } catch (err) {
   838	    console.error('Failed to read time off request:', err);
   839	    return { ok: false, exists: false, data: null };
   840	  }
   841	}
   842	
   843	// Conditional sibling of updateTimeOffRequest(): applies `updates` only if the request's CURRENT status
   844	// is still one the caller considers a legal starting point. Returns { success, reason } — the same shape
   845	// as confirmTimeOffSub() above, so a caller can tell "someone else got there first" apart from "the write
   846	// failed".
   847	//
   848	// Why a transaction rather than a plain re-read: approveTimeOff() reads the request, then loads AND writes
   849	// a schedule, then updates the request. That is several round trips, and another admin (or the same admin
   850	// clicking again) can approve the same request inside that window. Re-reading inside the transaction is
   851	// what makes the second approval abort instead of overwriting the first one's appliedOverrides with a
   852	// record captured after the first one's schedule write — see the comment at approveTimeOff().
   853	// `expect` (optional, Phase 3a): field values the document must STILL hold inside the transaction, or
   854	// the write is refused with { reason: 'changed', field }. Used by the reversal retry so the write that
   855	// clears appliedOverrides can only land against the exact record and marker it was decided on — a
   856	// status-only guard left a one-round-trip window in which another tab could park a different record.
   857	// Values are compared structurally; an absent field compares as null.
   858	async function updateTimeOffRequestIfStatus(requestId, allowedStatuses, updates, expect) {
   859	  if (!_ready) return { success: false, reason: 'not-ready' };
   860	  const ref = _db.collection('timeclock_timeoff').doc(requestId);
   861	  try {
   862	    return await _db.runTransaction(async (tx) => {
   863	      const doc = await tx.get(ref);
   864	      if (!doc.exists) return { success: false, reason: 'not-found' };
   865	      const data = doc.data();
   866	      const status = data.status;
   867	      if (!(allowedStatuses || []).includes(status)) {
   868	        return { success: false, reason: 'status-changed', status };
   869	      }
   870	      for (const field of Object.keys(expect || {})) {
   871	        const have = data[field] === undefined ? null : data[field];
   872	        const want = expect[field] === undefined ? null : expect[field];
   873	        if (!sameStructure(have, want)) return { success: false, reason: 'changed', field };
   874	      }
   875	      tx.update(ref, {
   876	        ...updates,
   877	        updatedAt: firebase.firestore.FieldValue.serverTimestamp()
   878	      });
   879	      return { success: true };
   880	    });
   881	  } catch (err) {
   882	    console.error('Failed to conditionally update time off request:', err);
   883	    return { success: false, reason: 'error' };
   884	  }
   885	}
   886	
   887	// ─── Streak Data ────────────────────────────────────
   888	
   889	const DEFAULT_STREAK = {
   890	  clockInStreak: 0,
   891	  clockOutStreak: 0,
   892	  monthlyClockIns: 0,
   893	  monthlyClockInTotal: 0,
   894	  monthlyClockOuts: 0,
   895	  monthlyClockOutTotal: 0,
   896	  extensionsThisWeek: 0,
   897	  weeklyExtensions: [],
   898	  currentMonth: '',
   899	  currentWeek: '',
   900	  lastUpdated: ''
   901	};
   902	
   903	async function loadStreakData() {
   904	  if (!_ready || !firebase.auth().currentUser) return { ...DEFAULT_STREAK };
   905	  try {
   906	    const uid = firebase.auth().currentUser.uid;
   907	    const doc = await _db.collection('timeclock_streaks').doc(uid).get();
   908	    return doc.exists ? { ...DEFAULT_STREAK, ...doc.data() } : { ...DEFAULT_STREAK };
   909	  } catch (err) {
   910	    console.error('Failed to load streak data:', err);
   911	    return { ...DEFAULT_STREAK };
   912	  }
   913	}
   914	
   915	// Phase 5: awaited. Not on the clock-in/out critical path — updateStreakOnClockIn/Out are fired without
   916	// await by the clock action, so the round-trip only delays the streak card, never the clock write.
   917	async function saveStreakData(updates) {
   918	  if (!_ready || !firebase.auth().currentUser) return false;
   919	  try {
   920	    const uid = firebase.auth().currentUser.uid;
   921	    const authUser = firebase.auth().currentUser;
   922	    const name = (typeof currentUser !== 'undefined' && currentUser && currentUser.name) || authUser.displayName || authUser.email || '';
   923	    await _db.collection('timeclock_streaks').doc(uid).set({ ...updates, name }, { merge: true });
   924	    return true;
   925	  } catch (err) {
   926	    console.error('Failed to save streak data:', err);
   927	    return false;
   928	  }
   929	}
   930	
   931	// ─── Helpers ─────────────────────────────────────────
   932	
   933	function getTodayDateStr() {
   934	  const now = new Date();
   935	  return now.getFullYear() + '-' +
   936	    String(now.getMonth() + 1).padStart(2, '0') + '-' +
   937	    String(now.getDate()).padStart(2, '0');
   938	}
   939	
   940	function getWeekday() {
     1	/**
     2	 * Pay-period locking — the write that payroll trusts, on REAL documents.
     3	 * Run: npm test (wraps this in `firebase emulators:exec --only firestore`)
     4	 *
     5	 * Runs the REAL js/firebase-data.js in a vm sandbox against the emulator's Firestore via the Admin SDK,
     6	 * the same harness as reminder-toggle.emulator.test.js.
     7	 *
     8	 * What these pin, and why (two-model plan review, Sep 28 2026):
     9	 *
    10	 *   PATH A — `handleLockPeriod` re-reads the period's entries and never checked whether that read worked.
    11	 *   A failed read became [], calcPeriodTotals([]) became {}, and the lock was written with EMPTY totals
    12	 *   while the manager was looking at real hours. lockPayPeriod returned true and the UI said "Locked".
    13	 *   The Payroll Tool then reads those stored totals as authoritative.
    14	 *
    15	 *   PATH B — a failed lock-status read made an already-locked period render as unlocked, and locking
    16	 *   again overwrote lockedAt / lockedBy / employeeTotals — destroying the record of what was paid.
    17	 *
    18	 * The fix is in the WRITE: a transaction that refuses an already-locked period, and a guard that refuses a
    19	 * snapshot nobody could have reviewed. The CALLER also reads fresh, refuses a failed or cache-served read,
    20	 * and validates the snapshot before asking the manager to confirm it — so the two are complementary, not
    21	 * alternatives. These tests cover the write half; the caller half is pinned in schedule-editor-wiring.
    22	 *
    23	 * The merge hazard these protect against is already measured in empty-map-guard.emulator.test.js: a
    24	 * merge-set unions nested maps EXCEPT that an explicitly-written empty map REPLACES the target.
    25	 */
    26	process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';
    27	process.env.GCLOUD_PROJECT = 'tinker-hq-test-ticker';
    28	
    29	const fs = require('fs');
    30	const vm = require('vm');
    31	const admin = require('firebase-admin');
    32	const helpers = require('./js/schedule-helpers.js');
    33	
    34	let app, db, data;
    35	const DOC = () => db.collection('timeclock_settings').doc('lockedPeriods');
    36	const KEY = '2026-09-01_2026-09-15';
    37	// The shape calcPeriodTotals produces and the Payroll Tool reads (totalHours / regular / overtime).
    38	// The earlier fixture used { name, hours }, which no producer or consumer uses (Codex, Sep 28).
    39	const TOTALS = {
    40	  uidA: { name: 'Kaitlyn', regular: 60, overtime: 2.5, totalHours: 62.5 },
    41	  uidB: { name: 'Anika', regular: 71, overtime: 0, totalHours: 71 },
    42	};
    43	
    44	beforeAll(async () => {
    45	  app = admin.initializeApp({ projectId: 'tinker-hq-test-ticker' }, 'pay-period-lock-test');
    46	  db = app.firestore();
    47	  // The one realm seam: the Admin SDK checks the transaction callback's return with `instanceof Promise`
    48	  // against THIS realm's Promise; an async function declared inside the vm returns the context's own.
    49	  const dbForSandbox = {
    50	    collection: (name) => db.collection(name),
    51	    runTransaction: (fn, opts) => db.runTransaction(tx => Promise.resolve(fn(tx)), opts),
    52	  };
    53	  const ctx = {
    54	    console,
    55	    initFirebaseApp: () => dbForSandbox,
    56	    enableOfflinePersistence: async () => {},
    57	    firebase: { firestore: { FieldValue: admin.firestore.FieldValue, FieldPath: admin.firestore.FieldPath } },
    58	    getAuthUser: () => ({ name: 'Christie' }),
    59	    planReminderToggles: () => ({ fields: [], applied: [], skipped: [] }),
    60	    findMalformedTotal: helpers.findMalformedTotal,
    61	    applyScheduleEdits: () => ({}),
    62	    setTimeout, Promise, Date,
    63	  };
    64	  vm.createContext(ctx);
    65	  vm.runInContext(fs.readFileSync(`${__dirname}/js/firebase-data.js`, 'utf8'), ctx, { filename: 'firebase-data.js' });
    66	  await ctx.initAppFirestore();
    67	  data = ctx;
    68	});
    69	
    70	afterAll(async () => { await app.delete(); });
    71	afterEach(async () => { await DOC().delete().catch(() => {}); });
    72	
    73	const read = async () => (await DOC().get()).data() || {};
    74	const seedLocked = () => DOC().set({ [KEY]: { lockedAt: '2026-09-16T10:00:00.000Z', lockedBy: 'Anika', employeeTotals: TOTALS } });
    75	
    76	test('the happy path is unchanged: an unlocked period locks and stores exactly the totals it was given', async () => {
    77	  const r = await data.lockPayPeriod(KEY, TOTALS);
    78	  expect(r).toMatchObject({ ok: true });
    79	  const stored = (await read())[KEY];
    80	  expect(stored.employeeTotals).toEqual(TOTALS);
    81	  expect(stored.lockedBy).toBe('Christie');
    82	  expect(typeof stored.lockedAt).toBe('string');
    83	});
    84	
    85	test('BDD (Path A): a snapshot of {} is REFUSED — a failed entries read can no longer lock everyone at zero', async () => {
    86	  const r = await data.lockPayPeriod(KEY, {});
    87	  expect(r).toMatchObject({ ok: false, reason: 'empty-totals' });
    88	  expect(await read()).toEqual({});                     // nothing written at all
    89	});
    90	
    91	test('BDD (Path A): a missing or malformed snapshot is refused too', async () => {
    92	  for (const bad of [undefined, null, [], 'nope', 0]) {
    93	    const r = await data.lockPayPeriod(KEY, bad);
    94	    expect(r.ok).toBe(false);
    95	    expect(await read()).toEqual({});
    96	  }
    97	});
    98	
    99	test('BDD (the negative control): a genuinely empty period still locks when the manager confirms it', async () => {
   100	  const r = await data.lockPayPeriod(KEY, {}, { allowEmpty: true });
   101	  expect(r).toMatchObject({ ok: true });
   102	  expect((await read())[KEY].employeeTotals).toEqual({});
   103	});
   104	
   105	test('BDD (Path B): locking an ALREADY-LOCKED period is refused and the stored record is byte-identical', async () => {
   106	  await seedLocked();
   107	  const before = await read();
   108	  const r = await data.lockPayPeriod(KEY, { uidC: { name: 'Someone Else', regular: 1, overtime: 0, totalHours: 1 } });
   109	  expect(r).toMatchObject({ ok: false, reason: 'already-locked', lockedBy: 'Anika' });
   110	  expect(await read()).toEqual(before);                  // lockedAt, lockedBy AND employeeTotals untouched
   111	});
   112	
   113	test('BDD (the hybrid): a PARTIAL snapshot cannot deep-merge over a stored one, leaving absent people stale', async () => {
   114	  await seedLocked();
   115	  const before = await read();
   116	  // uidB is missing here. Without the refusal this would merge: uidA overwritten, uidB SURVIVING stale.
   117	  const r = await data.lockPayPeriod(KEY, { uidA: { name: 'Kaitlyn', regular: 0.25, overtime: 0, totalHours: 0.25 } });
   118	  // name the guard: without this the test passes for ANY refusal, including one that never looked at the
   119	  // stored document (both reviewers, Sep 28). There is no partial-detection here — already-locked covers it.
   120	  expect(r).toMatchObject({ ok: false, reason: 'already-locked' });
   121	  expect(await read()).toEqual(before);
   122	  expect((await read())[KEY].employeeTotals.uidB).toEqual(TOTALS.uidB);
   123	});
   124	
   125	test('unlock then re-lock still works — the refusal is not a one-way door', async () => {
   126	  await seedLocked();
   127	  expect(await data.unlockPayPeriod(KEY)).toBe(true);
   128	  expect((await read())[KEY]).toBeUndefined();
   129	  const r = await data.lockPayPeriod(KEY, TOTALS);
   130	  expect(r).toMatchObject({ ok: true });
   131	  expect((await read())[KEY].employeeTotals).toEqual(TOTALS);
   132	});
   133	
   134	test('locking one period never disturbs another', async () => {
   135	  const OTHER = '2026-08-16_2026-08-31';
   136	  await DOC().set({ [OTHER]: { lockedAt: 'x', lockedBy: 'Anika', employeeTotals: TOTALS } });
   137	  const one = { uidA: { name: 'Kaitlyn', regular: 10, overtime: 0, totalHours: 10 } };
   138	  const r = await data.lockPayPeriod(KEY, one);
   139	  expect(r).toMatchObject({ ok: true });
   140	  const stored = await read();
   141	  expect(stored[OTHER].employeeTotals).toEqual(TOTALS);
   142	  expect(stored[KEY].employeeTotals).toEqual(one);
   143	});
   144	
   145	test('BDD: a payroll-incompatible snapshot is refused — a non-empty object is not a usable one', async () => {
   146	  for (const bad of [{ uidA: 1 }, { uidA: { name: 'A' } }, { uidA: null }, { uidA: [1, 2] },
   147	                     { uidA: { name: 'A', regular: 1, overtime: 0, totalHours: '62.5' } },
   148	                     // typeof NaN === 'number', and calcPeriodTotals can emit it from an unparseable
   149	                     // timestamp — regular goes NaN while overtime stays 0 (both reviewers, Sep 28)
   150	                     { uidA: { name: 'A', regular: NaN, overtime: 0, totalHours: NaN } },
   151	                     { uidA: { name: 'A', regular: NaN, overtime: 0, totalHours: 8 } },
   152	                     { uidA: { name: 'A', regular: 8, overtime: Infinity, totalHours: 8 } },
   153	                     { uidA: { name: 'A', totalHours: 8 } }]) {
   154	    const r = await data.lockPayPeriod(KEY, bad);
   155	    // it must also name WHICH employee — one bad record blocks the whole period, and a manager who is not
   156	    // told who cannot fix it (Claude, round four)
   157	    expect(r).toMatchObject({ ok: false, reason: 'malformed-totals', uid: 'uidA' });
   158	    expect(await read()).toEqual({});
   159	  }
   160	});
   161	
   162	test('BDD (the reason the guard is a TRANSACTION): two simultaneous locks — exactly one wins', async () => {
   163	  // Every other test seeds then calls once, which a plain get-then-set would also pass. This is the
   164	  // interleaving the transaction exists for: two managers, or one double-click on a button that is never
   165	  // disabled (both reviewers, Sep 28).
   166	  const [a, b] = await Promise.all([
   167	    data.lockPayPeriod(KEY, TOTALS),
   168	    data.lockPayPeriod(KEY, { uidZ: { name: 'Other', regular: 1, overtime: 0, totalHours: 1 } }),
   169	  ]);
   170	  const wins = [a, b].filter(r => r.ok);
   171	  const refused = [a, b].filter(r => !r.ok);
   172	  expect(wins).toHaveLength(1);
   173	  expect(refused).toHaveLength(1);
   174	  expect(refused[0]).toMatchObject({ reason: 'already-locked' });
   175	  // and exactly one record landed — never a merge of both
   176	  // compare OBJECTS: Firestore does not preserve key order, so JSON string comparison is flaky
   177	  const stored = (await read())[KEY];
   178	  const winner = wins[0] === a ? TOTALS : { uidZ: { name: 'Other', regular: 1, overtime: 0, totalHours: 1 } };
   179	  expect(stored.employeeTotals).toEqual(winner);   // one record landed, never a merge of both
   180	});
   181	
   182	test('BDD: the refusal carries the name, so the alert can say whose hours are wrong', async () => {
   183	  const r = await data.lockPayPeriod(KEY, {
   184	    uidA: { name: 'Kaitlyn', regular: 60, overtime: 2.5, totalHours: 62.5 },
   185	    uidB: { name: 'Anika', regular: NaN, overtime: 0, totalHours: NaN },
   186	  });
   187	  expect(r).toMatchObject({ ok: false, reason: 'malformed-totals', uid: 'uidB', name: 'Anika' });
   188	  expect(await read()).toEqual({});
   189	});
     1	/**
     2	 * Phase 5 — the unawaited-write family. Runs the REAL js/firebase-data.js in a vm sandbox against a fake
     3	 * Firestore whose writes can be made to reject, so the failure path — the one the emulator cannot produce
     4	 * (writes succeed there by default) — is actually exercised: a rejected write must come back as `false`,
     5	 * never as a "true" returned before the write was confirmed.
     6	 *
     7	 * Why a sandbox: js/firebase-data.js is a classic browser script (top-level `let _db`, globals from
     8	 * firebase-config.js, the `firebase` compat namespace). Nothing here mocks the module under test — only
     9	 * the SDK surface it talks to (collection().doc().update/set/delete) and the two config globals.
    10	 */
    11	const fs = require('fs');
    12	const vm = require('vm');
    13	
    14	function boot({ fail = new Set() } = {}) {
    15	  const calls = [];
    16	  const logged = [];
    17	  const op = (name, path) => (...args) => {
    18	    calls.push({ op: name, path, args });
    19	    return fail.has(name) ? Promise.reject(new Error(`denied: ${name} ${path}`)) : Promise.resolve();
    20	  };
    21	  const fakeDb = {
    22	    collection: (col) => ({
    23	      doc: (id) => {
    24	        const path = `${col}/${id || '<auto>'}`;
    25	        return { id: id || 'auto-id', update: op('update', path), set: op('set', path), delete: op('delete', path) };
    26	      },
    27	    }),
    28	  };
    29	  const ctx = {
    30	    console: { error: (...a) => logged.push(a), warn: () => {}, log: () => {} },
    31	    initFirebaseApp: () => fakeDb,
    32	    enableOfflinePersistence: async () => {},
    33	    firebase: {
    34	      firestore: { FieldValue: { serverTimestamp: () => 'ts', delete: () => 'del', arrayUnion: (v) => ({ arrayUnion: v }) } },
    35	      auth: () => ({ currentUser: { uid: 'uid-1', displayName: 'Test', email: 't@x.com' } }),
    36	    },
    37	    currentUser: { name: 'Test User' },
    38	    setTimeout, Promise,
    39	  };
    40	  vm.createContext(ctx);
    41	  vm.runInContext(fs.readFileSync(`${__dirname}/js/firebase-data.js`, 'utf8'), ctx, { filename: 'firebase-data.js' });
    42	  return { ctx, calls, logged };
    43	}
    44	
    45	describe('Phase 5: a rejected write returns false, never a premature true', () => {
    46	  const cases = [
    47	    ['updateClockEntry', 'update', (c) => c.updateClockEntry('e1', { note: 'x' })],
    48	    ['deleteSchedule', 'delete', (c) => c.deleteSchedule('uid-9')],
    49	    ['saveSettings', 'set', (c) => c.saveSettings({ a: 1 })],
    50	    ['saveStreakData', 'set', (c) => c.saveStreakData({ clockInStreak: 3 })],
    51	  ];
    52	
    53	  test.each(cases)('%s: succeeds → true, and the write actually happened', async (name, op, call) => {
    54	    const { ctx, calls, logged } = boot();
    55	    await ctx.initAppFirestore();
    56	    await expect(call(ctx)).resolves.toBe(true);
    57	    expect(calls.map(c => c.op)).toEqual([op]);
    58	    expect(logged).toEqual([]);
    59	  });
    60	
    61	  test.each(cases)('%s: the write is rejected → false (this used to be true), and the REJECTION is what was logged', async (name, op, call) => {
    62	    // Asserting the logged error is the fake's rejection rules out reaching the catch some other way (a
    63	    // ReferenceError inside the try would also return false) — review finding.
    64	    const { ctx, logged } = boot({ fail: new Set([op]) });
    65	    await ctx.initAppFirestore();
    66	    await expect(call(ctx)).resolves.toBe(false);
    67	    expect(logged).toHaveLength(1);
    68	    expect(logged[0][1]).toBeInstanceOf(Error);
    69	    expect(logged[0][1].message).toMatch(new RegExp(`^denied: ${op} timeclock_`));
    70	  });
    71	
    72	  test.each(cases)('%s: returns a Promise — an unawaited caller would see a truthy value regardless', async (name, op, call) => {
    73	    // The plan-review finding: `const ok = updateClockEntry(...)` without await is ALWAYS truthy once the
    74	    // function is async. This pins that the functions are async (so every caller must await) — the wiring
    75	    // test pins that they all do.
    76	    const { ctx } = boot({ fail: new Set([op]) });
    77	    await ctx.initAppFirestore();
    78	    const r = call(ctx);
    79	    expect(typeof r.then).toBe('function');
    80	    await expect(r).resolves.toBe(false);
    81	  });
    82	
    83	  test('not ready → false without touching Firestore', async () => {
    84	    const { ctx, calls } = boot();
    85	    await expect(ctx.updateClockEntry('e1', {})).resolves.toBe(false);
    86	    await expect(ctx.deleteSchedule('u')).resolves.toBe(false);
    87	    await expect(ctx.saveSettings({})).resolves.toBe(false);
    88	    await expect(ctx.saveStreakData({})).resolves.toBe(false);
    89	    expect(calls).toEqual([]);
    90	  });
    91	
    92	  test('saveStreakData writes to the signed-in user\'s doc with merge, carrying the display name', async () => {
    93	    const { ctx, calls } = boot();
    94	    await ctx.initAppFirestore();
    95	    await ctx.saveStreakData({ clockInStreak: 3 });
    96	    expect(calls[0].path).toBe('timeclock_streaks/uid-1');
    97	    expect(calls[0].args).toEqual([{ clockInStreak: 3, name: 'Test User' }, { merge: true }]);
    98	  });
    99	
   100	  test('the already-fixed addClockEntry has the same shape: rejected → null', async () => {
   101	    const { ctx } = boot({ fail: new Set(['set']) });
   102	    await ctx.initAppFirestore();
   103	    await expect(ctx.addClockEntry({ type: 'clock-in' })).resolves.toBeNull();
   104	  });
   105	});
     1	{
     2	  "name": "tinker-timeclock",
     3	  "private": true,
     4	  "scripts": {
     5	    "test": "firebase emulators:exec --only firestore \"node --experimental-vm-modules node_modules/.bin/jest --runInBand schedule-helpers.test.js timeoff-schedule.test.js timeoff-schedule.characterization.test.js schedule-editor-wiring.test.js firebase-data.failure.test.js schedule-dates-update.emulator.test.js schedule-partition.emulator.test.js future-schedule-write.emulator.test.js timeoff-sub-confirm.emulator.test.js timeoff-status-guard.emulator.test.js timeoff-schedule.emulator.test.js remove-timeoff-overrides.emulator.test.js empty-map-guard.emulator.test.js pay-period-lock.emulator.test.js removals.emulator.test.js reminder-flag.emulator.test.js reminder-toggle.emulator.test.js shift-reminder.emulator.test.js netlify/functions/_lib/email.test.js netlify/functions/_lib/shift-reminder.test.js netlify/functions/_lib/shift-reminder-functions.test.js netlify/functions/_lib/timeoff-routing.test.js netlify/functions/_lib/timeoff-confirmation.test.js netlify/functions/_lib/timeoff-comment.test.js netlify/functions/_lib/timeoff-status.test.js netlify/functions/_lib/schedule-change.test.js\"",
     6	    "deploy:check": "bash scripts/preflight.sh",
     7	    "deploy": "bash scripts/deploy.sh"
     8	  },
     9	  "dependencies": {
    10	    "@netlify/functions": "^4.3.0",
    11	    "firebase": "^12.19.0",
    12	    "firebase-admin": "^13.10.0",
    13	    "resend": "^6.26.0",
    14	    "web-push": "^3.6.7"
    15	  },
    16	  "devDependencies": {
    17	    "jest": "^30.5.0"
    18	  }
    19	}

codex
The first sweep confirms the plan’s main enforcement idea is directionally sound, but I’m checking two especially risky edges now: whether all hour-affecting fields/writers are actually routed through it, and whether the proposed UI/wiring tests could pass while the transactional guarantee is incomplete.
exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '1120,1340p'; nl -ba js/app.js | sed -n '2920,3025p'; nl -ba js/app.js | sed -n '9400,10540p'; nl -ba js/app.js | sed -n '10540,10630p'; rg -n \"timeclock_entries\" --glob '*.js' --glob '"'!node_modules/**'"' ." in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
  1120	        else if (s === 'approved') crBadge = '<span class="cr-badge cr-badge-approved">Corrected</span>';
  1121	        else if (s === 'denied') crBadge = '<span class="cr-badge cr-badge-denied">Denied</span>';
  1122	      }
  1123	
  1124	      const parts = [];
  1125	      if (e.autoEnded) parts.push('Auto-ended');
  1126	      if (e.unscheduled) parts.push(e.subNote || 'Unscheduled');
  1127	      if (e.extended) parts.push('Extended +' + finiteOr(e.extensionMinutes, 0) + 'm');
  1128	      if (e.changeRequest && e.changeRequest.status === 'approved' && e.changeRequest.originalTimestamp) {
  1129	        parts.push('Was: ' + formatTime(new Date(e.changeRequest.originalTimestamp)));
  1130	      }
  1131	      const meta = parts.join(' · ');
  1132	
  1133	      // Only clock-in/out without pending/approved request can be tapped; blocked on locked periods
  1134	      const canRequest = isClockEvent && (!e.changeRequest || e.changeRequest.status === 'denied') && !isDateInLockedPeriod(e.date);
  1135	      const clickAttr = canRequest ? `onclick="openChangeRequest(${jsArg(e.id)}, ${jsArg(e.type)}, ${jsArg(e.timestamp)})" style="cursor:pointer;"` : '';
  1136	
  1137	      return `
  1138	        <div class="entry-item ${canRequest ? 'entry-tappable' : ''}" ${clickAttr}>
  1139	          <div class="entry-icon">${icon}</div>
  1140	          <div class="entry-details">
  1141	            <div class="entry-type">${escapeHtml(label)} ${crBadge}</div>
  1142	            <div class="entry-time">${time}</div>
  1143	            ${meta ? `<div class="entry-meta">${escapeHtml(meta)}</div>` : ''}
  1144	          </div>
  1145	          ${canRequest ? '<div class="entry-action">Edit</div>' : ''}
  1146	        </div>`;
  1147	    }).join('');
  1148	  }
  1149	
  1150	  container.innerHTML = html || '<div class="no-entries">No entries in the last 7 days</div>';
  1151	}
  1152	
  1153	function openChangeRequest(entryId, entryType, timestamp) {
  1154	  crTargetEntryId = entryId;
  1155	  crTargetEntryType = entryType;
  1156	  const entryDate = new Date(timestamp);
  1157	  if (isDateInLockedPeriod(formatDateStr(entryDate))) {
  1158	    alert('This pay period has been locked. Contact your manager to make any corrections.');
  1159	    return;
  1160	  }
  1161	  const entryTime = formatTime(entryDate);
  1162	  const entryLabel = getEntryLabel(entryType);
  1163	  const dateLabel = entryDate.toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' });
  1164	
  1165	  document.getElementById('cr-entry-info').innerHTML =
  1166	    `<strong>${escapeHtml(entryLabel)}</strong> at <strong>${entryTime}</strong> &mdash; ${dateLabel}<br>
  1167	     <span style="color:var(--text-light);">Enter the correct time below and a brief reason.</span>`;
  1168	
  1169	  // Pre-fill with the original time
  1170	  const origDate = new Date(timestamp);
  1171	  const hh = String(origDate.getHours()).padStart(2, '0');
  1172	  const mm = String(origDate.getMinutes()).padStart(2, '0');
  1173	  document.getElementById('cr-corrected-time').value = hh + ':' + mm;
  1174	  document.getElementById('cr-reason').value = '';
  1175	  document.getElementById('cr-existing-status').classList.add('hidden');
  1176	  document.getElementById('change-request-modal').classList.add('open');
  1177	}
  1178	
  1179	async function submitChangeRequest() {
  1180	  if (!crTargetEntryId) return;
  1181	
  1182	  const correctedTime = document.getElementById('cr-corrected-time').value;
  1183	  const reason = document.getElementById('cr-reason').value.trim();
  1184	
  1185	  if (!correctedTime) { alert('Please enter the corrected time.'); return; }
  1186	  if (!reason) { alert('Please enter a reason for the correction.'); return; }
  1187	
  1188	  const btn = document.getElementById('btn-submit-change-request');
  1189	  btn.disabled = true;
  1190	  btn.textContent = 'Submitting...';
  1191	
  1192	  const success = await updateClockEntry(crTargetEntryId, {
  1193	    'changeRequest': {
  1194	      requestedTime: correctedTime,
  1195	      reason: reason,
  1196	      status: 'pending',
  1197	      submittedAt: new Date().toISOString(),
  1198	      submittedBy: currentUser.name || currentUser.email
  1199	    }
  1200	  });
  1201	
  1202	  btn.disabled = false;
  1203	  btn.textContent = 'Submit Request';
  1204	
  1205	  if (success) {
  1206	    document.getElementById('change-request-modal').classList.remove('open');
  1207	    crTargetEntryId = null;
  1208	    loadRecentEntries();
  1209	    loadMyStatus(); // Refresh today's entries too
  1210	  } else {
  1211	    alert('Failed to submit request. Please try again.');
  1212	  }
  1213	}
  1214	
  1215	// ─── Missing Punch Report ───────────────────────────
  1216	
  1217	function openMissingPunch() {
  1218	  // Default to yesterday
  1219	  const yesterday = new Date();
  1220	  yesterday.setDate(yesterday.getDate() - 1);
  1221	  const yStr = yesterday.getFullYear() + '-' +
  1222	    String(yesterday.getMonth() + 1).padStart(2, '0') + '-' +
  1223	    String(yesterday.getDate()).padStart(2, '0');
  1224	  document.getElementById('mp-date').value = yStr;
  1225	  document.getElementById('mp-type').value = 'clock-in';
  1226	  document.getElementById('mp-time').value = '';
  1227	  document.getElementById('mp-time-in').value = '';
  1228	  document.getElementById('mp-time-out').value = '';
  1229	  document.getElementById('mp-reason').value = '';
  1230	  document.getElementById('mp-single-time').style.display = 'block';
  1231	  document.getElementById('mp-both-times').style.display = 'none';
  1232	  document.getElementById('missing-punch-modal').classList.add('open');
  1233	}
  1234	
  1235	function toggleMissingPunchFields() {
  1236	  const type = document.getElementById('mp-type').value;
  1237	  document.getElementById('mp-single-time').style.display = type === 'both' ? 'none' : 'block';
  1238	  document.getElementById('mp-both-times').style.display = type === 'both' ? 'block' : 'none';
  1239	}
  1240	
  1241	async function submitMissingPunch() {
  1242	  const date = document.getElementById('mp-date').value;
  1243	  const type = document.getElementById('mp-type').value;
  1244	  const reason = document.getElementById('mp-reason').value.trim();
  1245	
  1246	  if (!date) { alert('Please select a date.'); return; }
  1247	  if (!reason) { alert('Please enter a reason.'); return; }
  1248	
  1249	  const currentPeriod = getPayPeriod(0);
  1250	  if (date < currentPeriod.startStr) {
  1251	    const proceed = confirm(`Heads up: ${date} is from a previous pay period. Your request will be submitted, but let your manager know directly so it doesn't get missed. Continue?`);
  1252	    if (!proceed) return;
  1253	  }
  1254	
  1255	  const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  1256	  const weekday = dayNames[new Date(date + 'T12:00:00').getDay()];
  1257	  const studio = (currentUser.studios && currentUser.studios[0]) || 'tinker';
  1258	
  1259	  const btn = document.getElementById('btn-submit-missing-punch');
  1260	  btn.disabled = true;
  1261	  btn.textContent = 'Submitting...';
  1262	
  1263	  let success = false;
  1264	
  1265	  if (type === 'both') {
  1266	    // Missed entire shift — single consolidated entry
  1267	    const timeIn = document.getElementById('mp-time-in').value;
  1268	    const timeOut = document.getElementById('mp-time-out').value;
  1269	    if (!timeIn || !timeOut) { alert('Please enter both clock in and clock out times.'); btn.disabled = false; btn.textContent = 'Submit Report'; return; }
  1270	
  1271	    success = await addClockEntry({
  1272	      uid: currentUser.uid,
  1273	      name: currentUser.name || currentUser.email,
  1274	      type: 'missed-shift',
  1275	      timestamp: new Date(date + 'T' + timeIn + ':00').toISOString(),
  1276	      date: date,
  1277	      weekday: weekday,
  1278	      studio: studio,
  1279	      missingPunch: true,
  1280	      changeRequest: {
  1281	        requestedTimeIn: timeIn,
  1282	        requestedTimeOut: timeOut,
  1283	        reason: 'Missing punch (entire shift): ' + reason,
  1284	        status: 'pending',
  1285	        submittedAt: new Date().toISOString(),
  1286	        submittedBy: currentUser.name || currentUser.email
  1287	      }
  1288	    });
  1289	  } else {
  1290	    // Single missing punch
  1291	    const time = document.getElementById('mp-time').value;
  1292	    if (!time) { alert('Please enter the time.'); btn.disabled = false; btn.textContent = 'Submit Report'; return; }
  1293	
  1294	    const entry = {
  1295	      uid: currentUser.uid,
  1296	      name: currentUser.name || currentUser.email,
  1297	      type: type,
  1298	      timestamp: new Date(date + 'T' + time + ':00').toISOString(),
  1299	      date: date,
  1300	      weekday: weekday,
  1301	      studio: studio,
  1302	      missingPunch: true,
  1303	      changeRequest: {
  1304	        requestedTime: time,
  1305	        reason: 'Missing punch: ' + reason,
  1306	        status: 'pending',
  1307	        submittedAt: new Date().toISOString(),
  1308	        submittedBy: currentUser.name || currentUser.email
  1309	      }
  1310	    };
  1311	    success = await addClockEntry(entry);
  1312	  }
  1313	
  1314	  btn.disabled = false;
  1315	  btn.textContent = 'Submit Report';
  1316	
  1317	  if (success) {
  1318	    document.getElementById('missing-punch-modal').classList.remove('open');
  1319	    loadRecentEntries();
  1320	    showToast('Missing punch reported — pending admin review');
  1321	  } else {
  1322	    alert('Failed to submit. Please try again.');
  1323	  }
  1324	}
  1325	
  1326	// ─── Render: Admin Dashboard ─────────────────────────
  1327	
  1328	function renderAdminDashboard(allEntries) {
  1329	  // Group by person, find current status for each
  1330	  const people = {};
  1331	  allEntries.forEach(e => {
  1332	    if (!people[e.uid]) {
  1333	      people[e.uid] = { name: e.name, entries: [], lastEntry: null };
  1334	    }
  1335	    people[e.uid].entries.push(e);
  1336	    people[e.uid].lastEntry = e;
  1337	  });
  1338	
  1339	  // Clocked-in list
  1340	  const clockedIn = Object.values(people).filter(p =>
  2920	  } else if (result.reason === 'malformed-totals') {
  2921	    // Unreachable from here now that the caller checks before confirming — kept because the write refuses
  2922	    // independently of any caller, and a silent difference between the two would be worse than a duplicate.
  2923	    alert(`${result.name || 'One employee'} has hours that did not calculate to a valid number. Nothing was locked.`);
  2924	  } else {
  2925	    alert('Failed to lock period — nothing was changed. Please try again.');
  2926	  }
  2927	}
  2928	
  2929	// The period key is rendered INTO the button (like openAdminEntryEditor), not re-derived from the mutable
  2930	// adminTsPeriodOffset. A stale button stays clickable across the two awaited reads after the offset changes,
  2931	// and unlock is an irreversible delete of the record of what was paid (Claude, Sep 28).
  2932	async function handleUnlockPeriod(periodKey) {
  2933	  // No fallback to adminTsPeriodOffset: falling back is exactly the race this parameter closes, and this
  2934	  // deletes the record of what was paid. A key that is absent or not canonical is refused (Codex, Sep 28).
  2935	  const period = getPayPeriodByKey(periodKey);
  2936	  if (!period) {
  2937	    alert('Could not tell which pay period that was, so nothing was unlocked. Reload and try again.');
  2938	    return;
  2939	  }
  2940	  if (!confirm(`Unlock the pay period ${period.label}?\n\nIf payroll has already been run using these totals, unlocking will invalidate those numbers. Re-lock after any edits.`)) return;
  2941	
  2942	  const success = await unlockPayPeriod(period.key);
  2943	  if (success) {
  2944	    renderAdminTimesheets();
  2945	  } else {
  2946	    alert('Failed to unlock period — please try again.');
  2947	  }
  2948	}
  2949	
  2950	function timeStrToDateForStr(timeStr, dateStr) {
  2951	  const [h, m] = timeStr.split(':').map(Number);
  2952	  const d = new Date(dateStr + 'T12:00:00');
  2953	  d.setHours(h, m, 0, 0);
  2954	  return d;
  2955	}
  2956	
  2957	// ═══════════════════════════════════════════════════════
  2958	// PHASE 2: SCHEDULING
  2959	// ═══════════════════════════════════════════════════════
  2960	
  2961	const DAYS = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  2962	const DAY_NAMES = { Mon: 'Monday', Tue: 'Tuesday', Wed: 'Wednesday', Thu: 'Thursday', Fri: 'Friday', Sat: 'Saturday', Sun: 'Sunday' };
  2963	
  2964	// ─── Data Loading ────────────────────────────────────
  2965	
  2966	async function loadSchedulesData() {
  2967	  const rawSchedules = await loadAllSchedules();
  2968	  // NOTE: this assigns [] on a failed read, so everything using the global sees "no staff". handleLockPeriod
  2969	  // does NOT rely on it — it reads the roster itself and refuses a failed or cached read, because
  2970	  // attributing payroll hours is the one place that must not silently see an empty roster.
  2971	  const rosterResult = await loadEmployeeRosterResult();
  2972	  employeeRoster = rosterResult.roster;
  2973	  if (currentUser.role === 'admin' || currentUser.role === 'manager') {
  2974	    const users = await loadAllUsersResult();
  2975	    allUsers = users.users;
  2976	    allUsersLoaded = users.ok;   // a failed read must read as "could not look up", not "no email on file"
  2977	  }
  2978	  // Auto-repair schedules that are missing a name field
  2979	  const db = getDb();
  2980	  if (db) {
  2981	    rawSchedules.forEach(sched => {
  2982	      if (sched.name) return;
  2983	      const resolved = getSchedName(sched);
  2984	      if (resolved !== 'Unknown') {
  2985	        sched.name = resolved;
  2986	        db.collection('timeclock_schedules').doc(sched.uid).update({ name: resolved }).catch(() => {});
  2987	      }
  2988	    });
  2989	  }
  2990	  const partitioned = partitionSchedulesByRosterActive(rawSchedules, employeeRoster);
  2991	  allSchedules = partitioned.active;
  2992	  archivedSchedules = partitioned.archived;
  2993	}
  2994	
  2995	function getSchedName(sched) {
  2996	  if (sched.name) return sched.name;
  2997	  const rosterEntry = employeeRoster.find(e => e.id === sched.uid || e.claimedBy === sched.uid);
  2998	  if (rosterEntry) return rosterEntry.name;
  2999	  if (allUsers) {
  3000	    const user = allUsers.find(u => u.uid === sched.uid);
  3001	    if (user) return user.name || user.email;
  3002	  }
  3003	  return 'Unknown';
  3004	}
  3005	
  3006	// ─── My Schedule (Staff View) ────────────────────────
  3007	
  3008	function renderMySchedule() {
  3009	  const container = document.getElementById('my-schedule-content');
  3010	  let mySchedule = allSchedules.find(s => s.uid === currentUser.uid);
  3011	  // Also check under temp roster ID if not found under real UID
  3012	  if (!mySchedule) {
  3013	    const myRosterEntry = employeeRoster.find(e => e.claimedBy === currentUser.uid);
  3014	    if (myRosterEntry) mySchedule = allSchedules.find(s => s.uid === myRosterEntry.id);
  3015	  }
  3016	
  3017	  if (!mySchedule || !mySchedule.recurring) {
  3018	    container.innerHTML = `
  3019	      <div class="no-schedule">
  3020	        <p>No schedule set up yet.</p>
  3021	        <p style="font-size:13px; color:var(--text-light);">Your manager will add your shift schedule here.</p>
  3022	      </div>`;
  3023	    return;
  3024	  }
  3025	
  9400	  const dismissed = localStorage.getItem('tinkerTicker_pushDismissed');
  9401	  if (dismissed && Date.now() - parseInt(dismissed) < 3 * 86400000) return; // re-show after 3 days
  9402	
  9403	  // Show prompt after a short delay
  9404	  setTimeout(() => {
  9405	    document.getElementById('push-prompt').classList.remove('hidden');
  9406	  }, 2000);
  9407	}
  9408	
  9409	function hidePushPrompt() {
  9410	  document.getElementById('push-prompt').classList.add('hidden');
  9411	}
  9412	
  9413	// ─── Native Notification Helper ──────────────────────
  9414	
  9415	function showNativeNotification(title, body) {
  9416	  if (Notification.permission !== 'granted') return;
  9417	  try {
  9418	    new Notification(title, {
  9419	      body,
  9420	      icon: '/assets/icon-192.png',
  9421	      tag: title.toLowerCase().replace(/\s+/g, '-'),
  9422	      renotify: true
  9423	    });
  9424	  } catch (e) {
  9425	    // Fallback for environments that don't support new Notification()
  9426	    if (navigator.serviceWorker && navigator.serviceWorker.controller) {
  9427	      navigator.serviceWorker.ready.then(reg => {
  9428	        reg.showNotification(title, {
  9429	          body,
  9430	          icon: '/assets/icon-192.png',
  9431	          tag: title.toLowerCase().replace(/\s+/g, '-'),
  9432	          renotify: true
  9433	        });
  9434	      });
  9435	    }
  9436	  }
  9437	}
  9438	
  9439	// ─── Server Push Helper ─────────────────────────────
  9440	
  9441	async function sendPushToUser(targetUid, title, body, data) {
  9442	  // Fire-and-forget — don't block the UI
  9443	  try {
  9444	    const subscription = await getSubscriptionForUser(targetUid);
  9445	    if (!subscription) { console.log('[Push] No subscription for', targetUid); return; }
  9446	
  9447	    fetch('/.netlify/functions/send-notification', {
  9448	      method: 'POST',
  9449	      headers: { 'Content-Type': 'application/json' },
  9450	      body: JSON.stringify({ subscription, title, body, data })
  9451	    }).catch(err => console.warn('[Push] Send failed:', err));
  9452	  } catch (err) {
  9453	    console.warn('[Push] Send failed:', err);
  9454	  }
  9455	}
  9456	
  9457	// ─── Push: All Admins Helper ─────────────────────────────
  9458	
  9459	async function sendPushToAllAdmins(title, body, data) {
  9460	  try {
  9461	    const db = getDb();
  9462	    if (!db) return;
  9463	    // Read adminSubscriptions doc (maintained by admin/manager on login)
  9464	    const doc = await db.collection('timeclock_settings').doc('adminSubscriptions').get();
  9465	    if (!doc.exists) return;
  9466	    const subs = doc.data() || {};
  9467	    // Send to each admin subscription (fire-and-forget)
  9468	    Object.values(subs).forEach(entry => {
  9469	      if (!entry.subscription) return;
  9470	      fetch('/.netlify/functions/send-notification', {
  9471	        method: 'POST',
  9472	        headers: { 'Content-Type': 'application/json' },
  9473	        body: JSON.stringify({ subscription: entry.subscription, title, body, data: data || {} })
  9474	      }).catch(err => console.warn('[Push] Admin push failed:', err));
  9475	    });
  9476	  } catch (err) {
  9477	    console.warn('[Push] Failed to send to admins:', err);
  9478	  }
  9479	}
  9480	
  9481	// ─── Time Off Coordinator Email Helper ──────────────
  9482	
  9483	async function sendTimeOffSubmissionEmail(requesterName, dates, reason, studios, coverageNotes, requesterEmail) {
  9484	  // The Firestore write has already succeeded by the time this is called (inside handleSubmitTimeOff's
  9485	  // `if (success)` branch), so a failure here can never roll it back or lose the request. Unlike push
  9486	  // notifications' quiet console.warn fire-and-forget, a missed time-off email is a real operational miss —
  9487	  // logged with console.error so it's visible, not silently swallowed.
  9488	  try {
  9489	    const res = await fetch('/.netlify/functions/send-timeoff-submission-email', {
  9490	      method: 'POST',
  9491	      headers: { 'Content-Type': 'application/json' },
  9492	      body: JSON.stringify({ requesterName, dates, reason, studios, coverageNotes, requesterEmail })
  9493	    });
  9494	    if (!res.ok) {
  9495	      console.error('[TimeOff Email] Coordinator email failed:', res.status, await res.text().catch(() => ''));
  9496	    }
  9497	  } catch (err) {
  9498	    console.error('[TimeOff Email] Coordinator email failed:', err);
  9499	  }
  9500	}
  9501	
  9502	// ─── Time Off Confirmation Email Helper (Plan 2, Phase 4) ──────────
  9503	
  9504	async function sendTimeOffConfirmationEmail({ requesterEmail, requesterName, subName, subEmail, dates, shiftsWritten, reminderDates, studios, subPlanDelivery, subPlanNotes }) {
  9505	  // Same fire-and-forget-but-logged pattern as sendTimeOffSubmissionEmail: the schedule write and/or the
  9506	  // request doc update have already succeeded by the time this is called, so a failure here can never
  9507	  // roll either back.
  9508	  try {
  9509	    const res = await fetch('/.netlify/functions/send-timeoff-confirmation-email', {
  9510	      method: 'POST',
  9511	      headers: { 'Content-Type': 'application/json' },
  9512	      body: JSON.stringify({ requesterEmail, requesterName, subName, subEmail, dates, shiftsWritten, reminderDates, studios, subPlanDelivery, subPlanNotes })
  9513	    });
  9514	    if (!res.ok) {
  9515	      console.error('[TimeOff Email] Confirmation email failed:', res.status, await res.text().catch(() => ''));
  9516	    }
  9517	  } catch (err) {
  9518	    console.error('[TimeOff Email] Confirmation email failed:', err);
  9519	  }
  9520	}
  9521	
  9522	// ─── Time Off Comment Email Helper ──────────────────
  9523	
  9524	// Reads a Netlify email function's response into { sent, reason }. Any failure — network, non-2xx, or
  9525	// unparseable body — is a definite "not sent"; the caller's toast must never claim otherwise.
  9526	async function readEmailOutcome(res) {
  9527	  if (!res.ok) {
  9528	    console.error('[TimeOff Email] Function returned', res.status, await res.text().catch(() => ''));
  9529	    return { sent: false, reason: 'http-' + res.status };
  9530	  }
  9531	  const body = await res.json().catch(() => null);
  9532	  if (!body) return { sent: false, reason: 'bad-response' };
  9533	  return { sent: !!body.sent, reason: body.reason || (body.sent ? 'ok' : 'unknown') };
  9534	}
  9535	
  9536	// Tells the person who triggered an email whether the requester actually got one. Christie's ask: when an
  9537	// email goes to the requester and NOT to the coordinators/Anika, nobody on the team can see it went out —
  9538	// and more importantly, nobody can see when it DIDN'T. So the failure wording is the important half.
  9539	function toastEmailOutcome(outcome, label) {
  9540	  // "you" is the submission receipt — the requester is the one acting, and "they were NOT emailed" reads
  9541	  // as though the request itself failed. It did not; say so.
  9542	  const self = label === 'you';
  9543	  if (outcome.sent) {
  9544	    showToast(self ? 'Request saved — confirmation email sent to you' : `Email sent to ${label}`);
  9545	  } else if (outcome.reason === 'no-requester-email' || outcome.reason === 'no-recipients') {
  9546	    showToast(self
  9547	      ? 'Request saved, but no email address is on file for you — no confirmation was sent'
  9548	      : `No email address on file for ${label} — they were NOT emailed`, 9000);
  9549	  } else {
  9550	    showToast(self
  9551	      ? 'Request saved, but the confirmation email did not send'
  9552	      : `Email to ${label} did not send — they were NOT emailed`, 9000);
  9553	  }
  9554	}
  9555	
  9556	// The address a decision email goes to. Prefers the requester's CURRENT users-doc email over the snapshot
  9557	// stored on the request: the snapshot goes stale if they change their address, and — found in review —
  9558	// the staff update rule pins nothing but uid, so a modified client could rewrite `email` on its own
  9559	// request and redirect the decision (dates, reason, reviewer's name) to a third party. The users doc is
  9560	// admin-readable and not staff-writable for that field. Falls back to the snapshot for older records.
  9561	function resolveRequesterEmail(request) {
  9562	  const user = (allUsers || []).find(u => u.uid === request.uid);
  9563	  return (user && user.email) || request.email || '';
  9564	}
  9565	
  9566	// Same idea for cc routing: requests created before requestStudios existed (Sep 3 2026) would otherwise
  9567	// go to the requester with no coordinator cc at all. Fall back to the user's own studios, which is what
  9568	// resolveRequestStudios() already does at submission time.
  9569	function resolveRequesterStudios(request) {
  9570	  if (request.requestStudios && request.requestStudios.length) return request.requestStudios;
  9571	  const user = (allUsers || []).find(u => u.uid === request.uid);
  9572	  return (user && user.studios) || [];
  9573	}
  9574	
  9575	async function sendTimeOffCommentEmail({ commenterName, commentText, requesterName, isAdminComment, requesterEmail, studios }, toastLabel) {
  9576	  // Same fire-and-forget-but-logged pattern as the other time-off email helpers: the comment has already
  9577	  // been saved by the time this is called, so a failure here can never roll that back.
  9578	  // `toastLabel`, when given, surfaces the outcome to the commenter — used for admin comments, which go to
  9579	  // the requester only, with nobody else cc'd to notice a failure.
  9580	  let outcome = { sent: false, reason: 'error' };
  9581	  try {
  9582	    const res = await fetch('/.netlify/functions/send-timeoff-comment-email', {
  9583	      method: 'POST',
  9584	      headers: { 'Content-Type': 'application/json' },
  9585	      body: JSON.stringify({ commenterName, commentText, requesterName, isAdminComment, requesterEmail, studios })
  9586	    });
  9587	    outcome = await readEmailOutcome(res);
  9588	  } catch (err) {
  9589	    console.error('[TimeOff Email] Comment email failed:', err);
  9590	  }
  9591	  if (toastLabel) toastEmailOutcome(outcome, toastLabel);
  9592	  return outcome;
  9593	}
  9594	
  9595	// Emails the requester about a status change — approved, denied, returned to review — or a receipt on
  9596	// submission. Fire-and-forget from every caller: the status write has already landed by the time this
  9597	// runs, and this must never be able to block or undo it. The OUTCOME is always surfaced as a toast,
  9598	// because "the requester was not told" is precisely what the admin needs to know and previously could not.
  9599	async function sendTimeOffStatusEmail({ status, previousStatus, reversalPending, reversalReason, requesterEmail, requesterName, dates, reason, denialReason, reviewedBy, studios }, toastLabel) {
  9600	  const label = toastLabel || requesterName || 'the requester';
  9601	  let outcome = { sent: false, reason: 'error' };
  9602	  try {
  9603	    const res = await fetch('/.netlify/functions/send-timeoff-status-email', {
  9604	      method: 'POST',
  9605	      headers: { 'Content-Type': 'application/json' },
  9606	      body: JSON.stringify({ status, previousStatus, reversalPending, reversalReason, requesterEmail, requesterName, dates, reason, denialReason, reviewedBy, studios })
  9607	    });
  9608	    outcome = await readEmailOutcome(res);
  9609	  } catch (err) {
  9610	    console.error('[TimeOff Email] Status email failed:', err);
  9611	  }
  9612	  toastEmailOutcome(outcome, label);
  9613	  return outcome;
  9614	}
  9615	
  9616	async function updateAdminSubscription(subscription) {
  9617	  // Call this when an admin/manager saves their push subscription
  9618	  // Stores their subscription in timeclock_settings/adminSubscriptions for staff→admin pushes
  9619	  const user = firebase.auth().currentUser;
  9620	  const db = getDb();
  9621	  if (!user || !db || !subscription) return;
  9622	  try {
  9623	    await db.collection('timeclock_settings').doc('adminSubscriptions').set({
  9624	      [user.uid]: { name: currentUser ? (currentUser.name || currentUser.email) : user.email, subscription: JSON.parse(JSON.stringify(subscription)) }
  9625	    }, { merge: true });
  9626	  } catch (err) {
  9627	    console.warn('[Push] Failed to update admin subscription:', err);
  9628	  }
  9629	}
  9630	
  9631	// ═══════════════════════════════════════════════════════
  9632	// KIOSK MODE
  9633	// ═══════════════════════════════════════════════════════
  9634	
  9635	async function initKioskMode() {
  9636	  // Sign in as kiosk account if not already signed in
  9637	  const overlay = document.getElementById('kiosk-screen');
  9638	  if (!overlay) {
  9639	    console.error('Kiosk screen element not found');
  9640	    return;
  9641	  }
  9642	
  9643	  // Show kiosk screen, hide everything else
  9644	  document.body.innerHTML = ''; // clear body
  9645	  document.body.appendChild(overlay);
  9646	  overlay.style.display = 'flex';
  9647	
  9648	  // Try to get existing auth or wait for Firebase auth
  9649	  await initAppFirestore();
  9650	
  9651	  firebase.auth().onAuthStateChanged(async (user) => {
  9652	    if (!user) {
  9653	      // Need to sign in as kiosk account
  9654	      showKioskSignInPrompt();
  9655	    } else {
  9656	      showKioskPinEntry();
  9657	    }
  9658	  });
  9659	}
  9660	
  9661	function showKioskSignInPrompt() {
  9662	  document.getElementById('kiosk-pin-screen').innerHTML = `
  9663	    <div style="text-align:center; padding:40px; max-width:320px; margin:0 auto;">
  9664	      <div style="font-size:48px; margin-bottom:16px;">⏰</div>
  9665	      <div style="font-size:20px; font-weight:700; color:var(--teal);">Tinker Ticker</div>
  9666	      <div style="font-size:14px; color:var(--text-medium); margin-top:8px; margin-bottom:24px;">Kiosk Setup — Admin Sign In</div>
  9667	      <input id="kiosk-setup-email" type="email" placeholder="Email" autocomplete="email"
  9668	        style="width:100%; padding:12px; margin-bottom:10px; border:1px solid var(--border); border-radius:8px; font-size:15px; box-sizing:border-box;">
  9669	      <input id="kiosk-setup-password" type="password" placeholder="Password"
  9670	        style="width:100%; padding:12px; margin-bottom:16px; border:1px solid var(--border); border-radius:8px; font-size:15px; box-sizing:border-box;">
  9671	      <div id="kiosk-setup-error" style="color:#e53e3e; font-size:13px; margin-bottom:12px; display:none;"></div>
  9672	      <button id="kiosk-setup-btn" onclick="kioskSignIn()"
  9673	        style="width:100%; padding:14px; background:var(--teal); color:#fff; border:none; border-radius:8px; font-size:16px; font-weight:600; cursor:pointer;">
  9674	        Sign In
  9675	      </button>
  9676	    </div>
  9677	  `;
  9678	  document.getElementById('kiosk-setup-password').addEventListener('keydown', e => {
  9679	    if (e.key === 'Enter') kioskSignIn();
  9680	  });
  9681	}
  9682	
  9683	async function kioskSignIn() {
  9684	  const email = document.getElementById('kiosk-setup-email').value.trim();
  9685	  const password = document.getElementById('kiosk-setup-password').value;
  9686	  const errorEl = document.getElementById('kiosk-setup-error');
  9687	  const btn = document.getElementById('kiosk-setup-btn');
  9688	
  9689	  errorEl.style.display = 'none';
  9690	  btn.disabled = true;
  9691	  btn.textContent = 'Signing in…';
  9692	
  9693	  try {
  9694	    await firebase.auth().signInWithEmailAndPassword(email, password);
  9695	    // onAuthStateChanged will fire and call showKioskPinEntry()
  9696	  } catch (err) {
  9697	    errorEl.textContent = err.message || 'Sign in failed.';
  9698	    errorEl.style.display = 'block';
  9699	    btn.disabled = false;
  9700	    btn.textContent = 'Sign In';
  9701	  }
  9702	}
  9703	
  9704	function showKioskPinEntry() {
  9705	  kioskCurrentUser = null;
  9706	  clearKioskAutoReturn();
  9707	  const screen = document.getElementById('kiosk-pin-screen');
  9708	  if (!screen) return;
  9709	  screen.innerHTML = `
  9710	    <div class="kiosk-logo">
  9711	      <div style="font-size:56px;">⏰</div>
  9712	      <div class="kiosk-title">Tinker Ticker</div>
  9713	      <div class="kiosk-subtitle">Enter your PIN to clock in or out</div>
  9714	    </div>
  9715	    <div class="kiosk-pin-display" id="kiosk-pin-display">_ _ _ _</div>
  9716	    <div class="kiosk-numpad">
  9717	      ${[1,2,3,4,5,6,7,8,9,'',0,'⌫'].map(k => k === '' ? '<div></div>' : `<button class="kiosk-key" onclick="kioskNumpadPress('${k}')">${k}</button>`).join('')}
  9718	    </div>
  9719	    <div id="kiosk-pin-error" class="kiosk-error hidden">PIN not found. Try again.</div>
  9720	  `;
  9721	  window._kioskPin = '';
  9722	}
  9723	
  9724	let _kioskPin = '';
  9725	
  9726	function kioskNumpadPress(key) {
  9727	  if (key === '⌫') {
  9728	    _kioskPin = _kioskPin.slice(0, -1);
  9729	  } else if (_kioskPin.length < 4) {
  9730	    _kioskPin += key;
  9731	  }
  9732	
  9733	  // Update display
  9734	  const display = document.getElementById('kiosk-pin-display');
  9735	  if (display) {
  9736	    const filled = '●'.repeat(_kioskPin.length);
  9737	    const empty = '_ '.repeat(4 - _kioskPin.length);
  9738	    display.textContent = (filled + ' ' + empty).trim();
  9739	  }
  9740	
  9741	  // Auto-submit when 4 digits entered
  9742	  if (_kioskPin.length === 4) {
  9743	    setTimeout(() => kioskSubmitPin(), 150);
  9744	  }
  9745	}
  9746	
  9747	async function kioskSubmitPin() {
  9748	  const pin = _kioskPin;
  9749	  _kioskPin = '';
  9750	
  9751	  const db = getDb();
  9752	  if (!db) return;
  9753	
  9754	  try {
  9755	    // Look up user by PIN from roster (works for claimed + unclaimed staff)
  9756	    const rosterDoc = await db.collection('timeclock_settings').doc('employees').get();
  9757	    const roster = rosterDoc.exists ? (rosterDoc.data().roster || []) : [];
  9758	    kioskRoster = roster; // Store for unscheduled sub-for dropdown
  9759	    const match = roster.find(e => e.active !== false && e.pin === pin);
  9760	
  9761	    if (!match) {
  9762	      document.getElementById('kiosk-pin-display').textContent = '_ _ _ _';
  9763	      const err = document.getElementById('kiosk-pin-error');
  9764	      if (err) {
  9765	        err.classList.remove('hidden');
  9766	        setTimeout(() => err.classList.add('hidden'), 2000);
  9767	      }
  9768	      return;
  9769	    }
  9770	
  9771	    // Use claimed UID if available, otherwise use roster emp_* id
  9772	    const effectiveUid = match.claimedBy || match.id;
  9773	    kioskCurrentUser = { uid: effectiveUid, name: match.name, studios: ['tinker'], ...match };
  9774	
  9775	    const todayStr = new Date().toLocaleDateString('en-CA');
  9776	
  9777	    // Load today's entries, schedule, and any end-time override in parallel
  9778	    // Schedule and entries may be under claimedBy UID or the emp_* roster ID.
  9779	    // Query both to guard against stale roster cache causing a missed clock-in lookup.
  9780	    const schedKeys = [...new Set([effectiveUid, match.id])];
  9781	    const [entryResults, overrideSnap, ...schedSnaps] = await Promise.all([
  9782	      Promise.all(schedKeys.map(uid =>
  9783	        db.collection('timeclock_entries')
  9784	          .where('uid', '==', uid)
  9785	          .where('date', '==', todayStr)
  9786	          .get()
  9787	      )),
  9788	      db.collection('timeclock_overrides').doc(effectiveUid).get(),
  9789	      ...schedKeys.map(k => db.collection('timeclock_schedules').doc(k).get())
  9790	    ]);
  9791	
  9792	    const seenEntryIds = new Set();
  9793	    const entries = [];
  9794	    for (const snap of entryResults) {
  9795	      for (const doc of snap.docs) {
  9796	        if (!seenEntryIds.has(doc.id)) {
  9797	          seenEntryIds.add(doc.id);
  9798	          entries.push({ id: doc.id, ...doc.data() });
  9799	        }
  9800	      }
  9801	    }
  9802	    entries.sort((a, b) => (a.timestamp || '').localeCompare(b.timestamp || ''));
  9803	
  9804	    // Determine today's shift for late clock-out detection
  9805	    kioskCurrentUser.todayShift = null;
  9806	    const schedSnap = schedSnaps.find(s => s.exists);
  9807	    if (schedSnap) {
  9808	      const dayKey = DAYS[(new Date().getDay() + 6) % 7]; // Mon-indexed
  9809	      kioskCurrentUser.todayShift = getShiftForDate(schedSnap.data(), todayStr, dayKey);
  9810	    }
  9811	
  9812	    // Apply end-time override if set for today
  9813	    kioskCurrentUser.todayEndOverride = null;
  9814	    if (overrideSnap.exists) {
  9815	      const ov = overrideSnap.data();
  9816	      if (ov.date === todayStr && ov.endTime) {
  9817	        kioskCurrentUser.todayEndOverride = ov.endTime;
  9818	      }
  9819	    }
  9820	
  9821	    kioskCurrentUser.todayEntries = entries; // Cache for back-button navigation
  9822	    showKioskClockScreen(kioskCurrentUser, entries);
  9823	  } catch (err) {
  9824	    console.error('Kiosk PIN lookup failed:', err);
  9825	    showKioskPinEntry();
  9826	  }
  9827	}
  9828	
  9829	function getKioskStatusFromEntries(entries) {
  9830	  if (!entries.length) return 'clocked-out';
  9831	  // Sort by writtenAt (actual write time) if available, fall back to timestamp
  9832	  const sorted = [...entries].sort((a, b) => (a.writtenAt || a.timestamp).localeCompare(b.writtenAt || b.timestamp));
  9833	  const last = sorted[sorted.length - 1];
  9834	  if (last.type === 'clock-in') return 'clocked-in';
  9835	  if (last.type === 'break-start') return 'on-break';
  9836	  if (last.type === 'break-end') return 'clocked-in';
  9837	  return 'clocked-out';
  9838	}
  9839	
  9840	function showKioskClockScreen(user, entries) {
  9841	  const status = getKioskStatusFromEntries(entries);
  9842	  const name = user.name || user.email || 'Unknown';
  9843	  const screen = document.getElementById('kiosk-pin-screen');
  9844	  if (!screen) return;
  9845	
  9846	  let buttonsHtml = '';
  9847	  if (status === 'clocked-out') {
  9848	    buttonsHtml = `<button class="kiosk-action-btn kiosk-btn-green" onclick="kioskClockIn()">Clock In</button>`;
  9849	  } else if (status === 'clocked-in') {
  9850	    buttonsHtml = `
  9851	      <button class="kiosk-action-btn kiosk-btn-amber" onclick="kioskBreakStart()">Take Break</button>
  9852	      <button class="kiosk-action-btn kiosk-btn-red" onclick="kioskClockOut()">Clock Out</button>`;
  9853	  } else if (status === 'on-break') {
  9854	    buttonsHtml = `<button class="kiosk-action-btn kiosk-btn-green" onclick="kioskBreakEnd()">Clock Back In</button>`;
  9855	  }
  9856	
  9857	  const statusLabels = { 'clocked-out': 'Not Clocked In', 'clocked-in': 'Clocked In', 'on-break': 'On Break' };
  9858	
  9859	  screen.innerHTML = `
  9860	    <div class="kiosk-user-greeting">
  9861	      <div class="kiosk-user-name">Hi, ${escapeHtml(name)}!</div>
  9862	      <div class="kiosk-user-status">${statusLabels[status] || status}</div>
  9863	    </div>
  9864	    <div class="kiosk-action-buttons">
  9865	      ${buttonsHtml}
  9866	    </div>
  9867	    <button class="kiosk-cancel-btn" onclick="showKioskPinEntry()">Not you? Go back</button>
  9868	  `;
  9869	
  9870	  // Auto-return after 20 seconds if no action
  9871	  clearKioskAutoReturn();
  9872	  kioskAutoReturnTimer = setTimeout(() => showKioskPinEntry(), 20000);
  9873	}
  9874	
  9875	function clearKioskAutoReturn() {
  9876	  if (kioskAutoReturnTimer) {
  9877	    clearTimeout(kioskAutoReturnTimer);
  9878	    kioskAutoReturnTimer = null;
  9879	  }
  9880	}
  9881	
  9882	async function kioskClockIn() {
  9883	  if (!kioskCurrentUser) return;
  9884	  clearKioskAutoReturn();
  9885	
  9886	  const now = new Date();
  9887	  const shift = kioskCurrentUser.todayShift;
  9888	
  9889	  // If no shift today, or current time is past shift end → unscheduled flow
  9890	  if (!shift || !shift.end || now > timeStrToDate(shift.end)) {
  9891	    showKioskUnscheduledScreen();
  9892	    return;
  9893	  }
  9894	
  9895	  await doKioskClockIn({});
  9896	}
  9897	
  9898	async function doKioskClockIn(extraFields) {
  9899	  if (!kioskCurrentUser) return;
  9900	  clearKioskAutoReturn();
  9901	  const db = getDb();
  9902	  const now = new Date();
  9903	  const todayStr = now.toLocaleDateString('en-CA');
  9904	  const dayNames = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
  9905	  const weekday = dayNames[now.getDay()];
  9906	  const studio = (kioskCurrentUser.studios && kioskCurrentUser.studios[0]) || 'tinker';
  9907	
  9908	  // Detect late clock-in (10+ min past shift start)
  9909	  const lateClockInFields = {};
  9910	  const shift = kioskCurrentUser.todayShift;
  9911	  if (shift && shift.start && !extraFields.extended && !extraFields.unscheduled) {
  9912	    const shiftStart = timeStrToDate(shift.start);
  9913	    const minsLate = Math.round((now.getTime() - shiftStart.getTime()) / 60000);
  9914	    if (minsLate >= 10) {
  9915	      lateClockInFields.lateClockIn = true;
  9916	      lateClockInFields.minutesLate = minsLate;
  9917	      lateClockInFields.flaggedForReview = true;
  9918	      lateClockInFields.scheduledStart = shift.start;
  9919	    }
  9920	  }
  9921	
  9922	  try {
  9923	    const entryRef = await db.collection('timeclock_entries').add({
  9924	      uid: kioskCurrentUser.uid,
  9925	      name: kioskCurrentUser.name || kioskCurrentUser.email,
  9926	      type: 'clock-in',
  9927	      timestamp: now.toISOString(),
  9928	      date: todayStr,
  9929	      weekday,
  9930	      studio,
  9931	      via: 'kiosk',
  9932	      ...lateClockInFields,
  9933	      ...extraFields
  9934	    });
  9935	
  9936	    if (lateClockInFields.lateClockIn) {
  9937	      await trackLateClockIn(kioskCurrentUser.uid, now);
  9938	    }
  9939	
  9940	    // Update streak and get accurate count for display
  9941	    let clockInStreak = 0;
  9942	    let clockInGraceMsg = null;
  9943	    if (!extraFields.extended && !extraFields.unscheduled) {
  9944	      const streakResult = await updateKioskStreakOnClockIn(kioskCurrentUser, now);
  9945	      clockInStreak = streakResult.streak;
  9946	      clockInGraceMsg = streakResult.graceMessage;
  9947	      // Enrichment on an entry that already landed. DELIBERATELY DETACHED (Phase 5 review): the kiosk's
  9948	      // confirmation screen is below this, and an awaited Firestore write never resolves offline — wifi
  9949	      // dropping in the moment after the punch landed would add a hang here that invites a second punch.
  9950	      // (The punch write and the streak write above are still awaited, so the kiosk can still wait on those
  9951	      // offline — this only avoids widening that window.) The helper catches and logs its own failure;
  9952	      // nothing here depends on the result.
  9953	      void updateClockEntry(entryRef.id, {
  9954	        clockInStreakAfter: clockInStreak,
  9955	        clockInGrace: parseGraceType(clockInGraceMsg)
  9956	      });
  9957	    } else {
  9958	      const streakSnap = await db.collection('timeclock_streaks').doc(kioskCurrentUser.uid).get();
  9959	      clockInStreak = streakSnap.exists ? (streakSnap.data().clockInStreak || 0) : 0;
  9960	    }
  9961	
  9962	    showKioskConfirmation(kioskCurrentUser, 'clocked-in', clockInStreak, clockInGraceMsg);
  9963	  } catch (err) {
  9964	    console.error('Kiosk clock-in failed:', err);
  9965	    showKioskError('Clock-in failed. Please try again.');
  9966	  }
  9967	}
  9968	
  9969	async function trackLateClockIn(uid, now) {
  9970	  try {
  9971	    const db = getDb();
  9972	    const streakRef = db.collection('timeclock_streaks').doc(uid);
  9973	    const streakSnap = await streakRef.get();
  9974	    const streakDoc = streakSnap.exists ? streakSnap.data() : {};
  9975	
  9976	    const currentWeekMonday = getMondayDateStr(now);
  9977	    let lateClockIns = streakDoc.lateClockIns || [];
  9978	    let lateClockInWeek = streakDoc.lateClockInWeek || '';
  9979	
  9980	    if (lateClockInWeek !== currentWeekMonday) {
  9981	      lateClockIns = [];
  9982	      lateClockInWeek = currentWeekMonday;
  9983	    }
  9984	
  9985	    lateClockIns.push(now.toISOString());
  9986	    await streakRef.set({ lateClockIns, lateClockInWeek }, { merge: true });
  9987	  } catch (err) {
  9988	    console.error('Failed to track late clock-in:', err);
  9989	  }
  9990	}
  9991	
  9992	function _graceUsedDateStr(isoStr) {
  9993	  return new Date(isoStr).toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
  9994	}
  9995	
  9996	function _extendedGraceAvailable(streak, now) {
  9997	  if (!streak.extendedGraceUsedAt) return true;
  9998	  return (now.getTime() - new Date(streak.extendedGraceUsedAt).getTime()) > 30 * 24 * 60 * 60 * 1000;
  9999	}
 10000	
 10001	async function updateKioskStreakOnClockIn(kioskUser, now) {
 10002	  const db = getDb();
 10003	  const uid = kioskUser.uid;
 10004	  const today = now.toLocaleDateString('en-CA');
 10005	  const currentMonthStr = now.toISOString().slice(0, 7);
 10006	  try {
 10007	    const streakRef = db.collection('timeclock_streaks').doc(uid);
 10008	    const streakSnap = await streakRef.get();
 10009	    const streak = streakSnap.exists
 10010	      ? { clockInStreak: 0, clockOutStreak: 0, monthlyClockIns: 0, monthlyClockInTotal: 0, monthlyClockOuts: 0, monthlyClockOutTotal: 0, ...streakSnap.data() }
 10011	      : { clockInStreak: 0, clockOutStreak: 0, monthlyClockIns: 0, monthlyClockInTotal: 0, monthlyClockOuts: 0, monthlyClockOutTotal: 0 };
 10012	
 10013	    if (streak.lastClockInDate === today) return { streak: streak.clockInStreak || 0, graceMessage: null };
 10014	
 10015	    if (streak.currentMonth !== currentMonthStr) {
 10016	      streak.monthlyClockIns = 0;
 10017	      streak.monthlyClockInTotal = 0;
 10018	      streak.monthlyClockOuts = 0;
 10019	      streak.monthlyClockOutTotal = 0;
 10020	    }
 10021	
 10022	    streak.monthlyClockInTotal = (streak.monthlyClockInTotal || 0) + 1;
 10023	
 10024	    // Reset monthly clock-in grace counter if calendar month changed
 10025	    if (streak.clockInGraceMonth !== currentMonthStr) {
 10026	      streak.clockInGraceCount = 0;
 10027	      streak.clockInGraceMonth = currentMonthStr;
 10028	    }
 10029	
 10030	    let graceMessage = null;
 10031	    let minsLate = null;
 10032	    if (kioskUser.todayShift && kioskUser.todayShift.start) {
 10033	      const shiftStart = timeStrToDate(kioskUser.todayShift.start);
 10034	      minsLate = (now.getTime() - shiftStart.getTime()) / 60000;
 10035	    }
 10036	
 10037	    if (minsLate === null || minsLate <= 0) {
 10038	      // Early or exactly on time (or no schedule)
 10039	      streak.clockInStreak = (streak.clockInStreak || 0) + 1;
 10040	      streak.monthlyClockIns = (streak.monthlyClockIns || 0) + 1;
 10041	    } else if (minsLate <= 3) {
 10042	      // Within 3-min always-available grace window
 10043	      streak.clockInStreak = (streak.clockInStreak || 0) + 1;
 10044	      streak.monthlyClockIns = (streak.monthlyClockIns || 0) + 1;
 10045	      graceMessage = '(within grace period)';
 10046	    } else if ((streak.clockInGraceCount || 0) < 2) {
 10047	      // Late but monthly grace available (2 per calendar month) — streak stays
 10048	      streak.clockInGraceCount = (streak.clockInGraceCount || 0) + 1;
 10049	      const graceNum = streak.clockInGraceCount;
 10050	      graceMessage = `Monthly grace used (${graceNum} of 2 this month) — streak safe! ✅`;
 10051	    } else {
 10052	      // Late and monthly grace exhausted — reset
 10053	      streak.clockInStreak = 1;
 10054	      streak.monthlyClockIns = (streak.monthlyClockIns || 0) + 1;
 10055	      graceMessage = "Monthly grace limit reached (2 of 2 used) — streak resets to 1. Tomorrow's a fresh start! 🌟";
 10056	    }
 10057	
 10058	    streak.lastClockInDate = today;
 10059	    streak.currentMonth = currentMonthStr;
 10060	    streak.lastUpdated = now.toISOString();
 10061	    streak.name = kioskUser.name || '';
 10062	    await streakRef.set(streak, { merge: true });
 10063	    return { streak: streak.clockInStreak, graceMessage };
 10064	  } catch (err) {
 10065	    console.error('Failed to update kiosk clock-in streak:', err);
 10066	    return { streak: 0, graceMessage: null };
 10067	  }
 10068	}
 10069	
 10070	function parseGraceType(graceMessage) {
 10071	  if (!graceMessage) return null;
 10072	  if (graceMessage.includes('Monthly grace used') || graceMessage.includes('Weekly grace used') || graceMessage.includes('Monthly extended grace')) return 'extended';
 10073	  if (graceMessage.includes('within grace period')) return 'standard';
 10074	  return null;
 10075	}
 10076	
 10077	async function updateKioskStreakOnClockOut(kioskUser, now, isAutoEnded) {
 10078	  const db = getDb();
 10079	  const uid = kioskUser.uid;
 10080	  const today = now.toLocaleDateString('en-CA');
 10081	  const currentMonthStr = now.toISOString().slice(0, 7);
 10082	  try {
 10083	    const streakRef = db.collection('timeclock_streaks').doc(uid);
 10084	    const streakSnap = await streakRef.get();
 10085	    const streak = streakSnap.exists
 10086	      ? { clockInStreak: 0, clockOutStreak: 0, monthlyClockIns: 0, monthlyClockInTotal: 0, monthlyClockOuts: 0, monthlyClockOutTotal: 0, ...streakSnap.data() }
 10087	      : { clockInStreak: 0, clockOutStreak: 0, monthlyClockIns: 0, monthlyClockInTotal: 0, monthlyClockOuts: 0, monthlyClockOutTotal: 0 };
 10088	
 10089	    if (streak.lastClockOutDate === today) return { streak: streak.clockOutStreak || 0, graceMessage: null };
 10090	
 10091	    if (streak.currentMonth !== currentMonthStr) {
 10092	      streak.monthlyClockIns = 0;
 10093	      streak.monthlyClockInTotal = 0;
 10094	      streak.monthlyClockOuts = 0;
 10095	      streak.monthlyClockOutTotal = 0;
 10096	    }
 10097	
 10098	    streak.monthlyClockOutTotal = (streak.monthlyClockOutTotal || 0) + 1;
 10099	    let graceMessage = null;
 10100	
 10101	    if (isAutoEnded) {
 10102	      streak.clockOutStreak = 0;
 10103	    } else if (kioskUser.todayShift && kioskUser.todayShift.end) {
 10104	      const shiftEnd = timeStrToDate(kioskUser.todayShift.end);
 10105	      const absDiffMins = Math.abs(now.getTime() - shiftEnd.getTime()) / 60000;
 10106	
 10107	      if (absDiffMins <= 0) {
 10108	        // Exactly on time
 10109	        streak.clockOutStreak = (streak.clockOutStreak || 0) + 1;
 10110	        streak.monthlyClockOuts = (streak.monthlyClockOuts || 0) + 1;
 10111	      } else if (absDiffMins <= 3) {
 10112	        // Within 3-min grace (either side)
 10113	        streak.clockOutStreak = (streak.clockOutStreak || 0) + 1;
 10114	        streak.monthlyClockOuts = (streak.monthlyClockOuts || 0) + 1;
 10115	        graceMessage = '(within grace period)';
 10116	      } else if ((streak.clockOutGraceWeek || '') !== getMondayDateStr(now) || (streak.clockOutGraceCount || 0) < 1) {
 10117	        // More than 3 min off but weekly grace available (1 per Mon-Sun week)
 10118	        streak.clockOutGraceWeek = getMondayDateStr(now);
 10119	        streak.clockOutGraceCount = 1;
 10120	        graceMessage = 'Weekly grace used (1 of 1 this week) — streak safe! ✅';
 10121	      } else {
 10122	        // Grace exhausted for this week
 10123	        streak.clockOutStreak = 1;
 10124	        streak.monthlyClockOuts = (streak.monthlyClockOuts || 0) + 1;
 10125	        graceMessage = 'Weekly grace already used — streak resets to 1. Tomorrow\'s a fresh start! 🌟';
 10126	      }
 10127	    } else {
 10128	      // No schedule — any manual clock-out counts
 10129	      streak.clockOutStreak = (streak.clockOutStreak || 0) + 1;
 10130	      streak.monthlyClockOuts = (streak.monthlyClockOuts || 0) + 1;
 10131	    }
 10132	
 10133	    streak.lastClockOutDate = today;
 10134	    streak.currentMonth = currentMonthStr;
 10135	    streak.lastUpdated = now.toISOString();
 10136	    streak.name = kioskUser.name || '';
 10137	    await streakRef.set(streak, { merge: true });
 10138	    return { streak: streak.clockOutStreak || 0, graceMessage };
 10139	  } catch (err) {
 10140	    console.error('Failed to update kiosk clock-out streak:', err);
 10141	    return { streak: 0, graceMessage: null };
 10142	  }
 10143	}
 10144	
 10145	function showKioskUnscheduledScreen() {
 10146	  const screen = document.getElementById('kiosk-pin-screen');
 10147	  if (!screen) return;
 10148	
 10149	  screen.innerHTML = `
 10150	    <div class="kiosk-user-name">${escapeHtml(kioskCurrentUser.name || '')}</div>
 10151	    <div class="kiosk-late-message" style="margin-bottom:24px;">You're not on the schedule right now.<br>What brings you in?</div>
 10152	    <div style="display:flex; flex-direction:column; gap:16px; width:100%; max-width:340px;">
 10153	      <button class="kiosk-action-btn kiosk-btn-green" onclick="kioskSelectUnscheduledReason('sub')">Subbing for someone</button>
 10154	      <button class="kiosk-action-btn" style="background:#6c757d;" onclick="kioskSelectUnscheduledReason('additional')">I have other work to do</button>
 10155	    </div>
 10156	    <div style="margin-top:32px;">
 10157	      <button onclick="showKioskClockScreen(kioskCurrentUser, kioskCurrentUser.todayEntries || [])" style="background:none;border:none;color:#999;font-size:14px;cursor:pointer;">← Back</button>
 10158	    </div>
 10159	  `;
 10160	}
 10161	
 10162	function kioskSelectUnscheduledReason(reason) {
 10163	  const screen = document.getElementById('kiosk-pin-screen');
 10164	  if (!screen) return;
 10165	
 10166	  const othersOptions = kioskRoster
 10167	    .filter(e => e.active !== false && (e.claimedBy || e.id) !== kioskCurrentUser.uid)
 10168	    .sort((a, b) => (a.name || '').localeCompare(b.name || ''))
 10169	    .map(e => `<option value="${escapeHtml(e.name)}">${escapeHtml(e.name)}</option>`)
 10170	    .join('');
 10171	
 10172	  if (reason === 'sub') {
 10173	    screen.innerHTML = `
 10174	      <div class="kiosk-user-name">${escapeHtml(kioskCurrentUser.name || '')}</div>
 10175	      <div class="kiosk-late-message" style="margin-bottom:20px;">Who are you subbing for?</div>
 10176	      <div style="width:100%; max-width:340px; display:flex; flex-direction:column; gap:12px;">
 10177	        <select id="kiosk-sub-for" style="font-size:18px; padding:14px; border-radius:10px; border:2px solid #ccc; width:100%;">
 10178	          <option value="">Select person...</option>
 10179	          ${othersOptions}
 10180	        </select>
 10181	        <input id="kiosk-sub-class" type="text" placeholder="Class or activity (optional)" style="font-size:16px; padding:14px; border-radius:10px; border:2px solid #ccc; width:100%; box-sizing:border-box;">
 10182	        <button class="kiosk-action-btn kiosk-btn-green" onclick="kioskConfirmUnscheduled('sub')" style="margin-top:8px;">Clock In</button>
 10183	      </div>
 10184	      <div style="margin-top:24px;">
 10185	        <button onclick="showKioskUnscheduledScreen()" style="background:none;border:none;color:#999;font-size:14px;cursor:pointer;">← Back</button>
 10186	      </div>
 10187	    `;
 10188	  } else {
 10189	    screen.innerHTML = `
 10190	      <div class="kiosk-user-name">${escapeHtml(kioskCurrentUser.name || '')}</div>
 10191	      <div class="kiosk-late-message" style="margin-bottom:20px;">What are you working on?</div>
 10192	      <div style="width:100%; max-width:340px; display:flex; flex-direction:column; gap:12px;">
 10193	        <textarea id="kiosk-unsched-note" placeholder="Describe what you're doing..." style="font-size:16px; padding:14px; border-radius:10px; border:2px solid #ccc; width:100%; box-sizing:border-box; height:100px; resize:none;"></textarea>
 10194	        <button class="kiosk-action-btn kiosk-btn-green" onclick="kioskConfirmUnscheduled('additional')" style="margin-top:8px;">Clock In</button>
 10195	      </div>
 10196	      <div style="margin-top:24px;">
 10197	        <button onclick="showKioskUnscheduledScreen()" style="background:none;border:none;color:#999;font-size:14px;cursor:pointer;">← Back</button>
 10198	      </div>
 10199	    `;
 10200	  }
 10201	}
 10202	
 10203	async function kioskConfirmUnscheduled(reason) {
 10204	  let extraFields = { unscheduled: true };
 10205	
 10206	  if (reason === 'sub') {
 10207	    const subFor = document.getElementById('kiosk-sub-for').value;
 10208	    const subClass = document.getElementById('kiosk-sub-class').value.trim();
 10209	    if (!subFor) {
 10210	      const sel = document.getElementById('kiosk-sub-for');
 10211	      if (sel) sel.style.borderColor = '#e63946';
 10212	      return;
 10213	    }
 10214	    extraFields.subFor = subFor;
 10215	    if (subClass) extraFields.subClass = subClass;
 10216	    extraFields.subNote = 'Subbing for ' + subFor + (subClass ? ' — ' + subClass : '');
 10217	  } else {
 10218	    const note = document.getElementById('kiosk-unsched-note').value.trim();
 10219	    if (!note) {
 10220	      const ta = document.getElementById('kiosk-unsched-note');
 10221	      if (ta) ta.style.borderColor = '#e63946';
 10222	      return;
 10223	    }
 10224	    extraFields.subNote = note;
 10225	  }
 10226	
 10227	  await doKioskClockIn(extraFields);
 10228	}
 10229	
 10230	async function kioskClockOut() {
 10231	  if (!kioskCurrentUser) return;
 10232	  clearKioskAutoReturn();
 10233	
 10234	  const now = new Date();
 10235	  const shift = kioskCurrentUser.todayShift;
 10236	  const effectiveEnd = kioskCurrentUser.todayEndOverride || (shift && shift.end) || null;
 10237	
 10238	  if (effectiveEnd) {
 10239	    const shiftEndDate = timeStrToDate(effectiveEnd);
 10240	    const msPastEnd = now.getTime() - shiftEndDate.getTime();
 10241	    const GRACE_MS = 3 * 60 * 1000;
 10242	
 10243	    if (msPastEnd > GRACE_MS) {
 10244	      showKioskLateClockOut(effectiveEnd, shiftEndDate, now);
 10245	      return;
 10246	    }
 10247	  }
 10248	
 10249	  // Within grace window — normal clock-out
 10250	  await doKioskClockOutNow(now, false, 0, false, null);
 10251	}
 10252	
 10253	function showKioskLateClockOut(scheduledEnd, shiftEndDate, now) {
 10254	  const screen = document.getElementById('kiosk-pin-screen');
 10255	  if (!screen) return;
 10256	
 10257	  const endLabel = formatTimeStr(scheduledEnd);
 10258	  const minsPast = Math.round((now.getTime() - shiftEndDate.getTime()) / 60000);
 10259	  const flagNote = minsPast >= 15
 10260	    ? `<div class="kiosk-late-flag">You're ${minsPast} minutes past your shift — this will be noted for your manager.</div>`
 10261	    : '';
 10262	
 10263	  // Build 5-min interval options from shift end to now
 10264	  let timeOptions = '';
 10265	  let t = new Date(shiftEndDate);
 10266	  while (t <= now) {
 10267	    const hh = String(t.getHours()).padStart(2, '0');
 10268	    const mm = String(t.getMinutes()).padStart(2, '0');
 10269	    const val = hh + ':' + mm;
 10270	    timeOptions += `<option value="${val}">${formatTimeStr(val)}</option>`;
 10271	    t = new Date(t.getTime() + 5 * 60000);
 10272	  }
 10273	
 10274	  screen.innerHTML = `
 10275	    <div class="kiosk-late-header">
 10276	      <div class="kiosk-user-name">${escapeHtml(kioskCurrentUser.name || kioskCurrentUser.email)}</div>
 10277	      <div class="kiosk-late-message">Your shift ended at <strong>${endLabel}</strong>. Did you forget to clock out?</div>
 10278	    </div>
 10279	    ${flagNote}
 10280	    <div style="margin-bottom:16px; width:100%; max-width:320px;">
 10281	      <label style="font-size:13px; font-weight:700; display:block; margin-bottom:8px;">Select your clock-out time:</label>
 10282	      <select id="kiosk-late-time-select" style="width:100%; padding:12px 16px; border:2px solid var(--border-light); border-radius:10px; font-family:inherit; font-size:16px;">
 10283	        ${timeOptions}
 10284	      </select>
 10285	    </div>
 10286	    <div id="kiosk-late-error" style="display:none; color:var(--red); font-size:14px; margin-bottom:12px; max-width:320px; width:100%;"></div>
 10287	    <div class="kiosk-action-buttons">
 10288	      <button class="kiosk-action-btn kiosk-btn-red" onclick="kioskConfirmLateClockOut(${jsArg(scheduledEnd)})">Clock Out at Selected Time</button>
 10289	      <button class="kiosk-action-btn" style="background:white; color:var(--text-medium); border:2px solid var(--border-light);" onclick="kioskStayedLateClockOut()">No, I stayed late — clock out now</button>
 10290	    </div>
 10291	    <button class="kiosk-cancel-btn" onclick="showKioskPinEntry()">Cancel</button>
 10292	  `;
 10293	
 10294	  // Give them more time to interact with the selector
 10295	  kioskAutoReturnTimer = setTimeout(() => showKioskPinEntry(), 30000);
 10296	}
 10297	
 10298	async function kioskConfirmLateClockOut(scheduledEnd) {
 10299	  const select = document.getElementById('kiosk-late-time-select');
 10300	  const selectedTime = select ? select.value : null;
 10301	  if (!selectedTime || !kioskCurrentUser) return;
 10302	
 10303	  const [hh, mm] = selectedTime.split(':').map(Number);
 10304	  const clockOutTime = new Date();
 10305	  clockOutTime.setHours(hh, mm, 0, 0);
 10306	
 10307	  // Validate: clock-out time must be after clock-in time
 10308	  const entries = kioskCurrentUser.todayEntries || [];
 10309	  const lastClockIn = [...entries].sort((a, b) => a.timestamp.localeCompare(b.timestamp)).reverse().find(e => e.type === 'clock-in');
 10310	  if (lastClockIn && clockOutTime.toISOString() <= lastClockIn.timestamp) {
 10311	    const errEl = document.getElementById('kiosk-late-error');
 10312	    if (errEl) {
 10313	      errEl.textContent = 'Clock-out time must be after your clock-in time.';
 10314	      errEl.style.display = 'block';
 10315	    }
 10316	    return;
 10317	  }
 10318	
 10319	  const shiftEndDate = timeStrToDate(scheduledEnd);
 10320	  const minsLate = Math.max(0, Math.round((clockOutTime.getTime() - shiftEndDate.getTime()) / 60000));
 10321	
 10322	  await doKioskClockOutNow(clockOutTime, true, minsLate, minsLate >= 15, scheduledEnd);
 10323	}
 10324	
 10325	async function kioskStayedLateClockOut() {
 10326	  if (!kioskCurrentUser) return;
 10327	  // "Stayed late" — clock out now, no flag (intentional)
 10328	  await doKioskClockOutNow(new Date(), true, 0, false, null);
 10329	}
 10330	
 10331	async function doKioskClockOutNow(clockOutTime, isLate, minsLate, flagForReview, scheduledEnd) {
 10332	  if (!kioskCurrentUser) return;
 10333	  clearKioskAutoReturn();
 10334	  const db = getDb();
 10335	  const todayStr = clockOutTime.toLocaleDateString('en-CA');
 10336	  const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
 10337	  const weekday = dayNames[clockOutTime.getDay()];
 10338	  const studio = (kioskCurrentUser.studios && kioskCurrentUser.studios[0]) || 'tinker';
 10339	
 10340	  try {
 10341	    const entry = {
 10342	      uid: kioskCurrentUser.uid,
 10343	      name: kioskCurrentUser.name || kioskCurrentUser.email,
 10344	      type: 'clock-out',
 10345	      timestamp: clockOutTime.toISOString(),
 10346	      writtenAt: new Date().toISOString(), // actual write time — used for sort order when timestamp is retroactive
 10347	      date: todayStr,
 10348	      weekday,
 10349	      studio,
 10350	      via: 'kiosk'
 10351	    };
 10352	    if (isLate) {
 10353	      entry.lateClockOut = true;
 10354	      entry.minutesLate = minsLate;
 10355	      entry.flaggedForReview = flagForReview;
 10356	      if (scheduledEnd) entry.scheduledEnd = scheduledEnd;
 10357	    }
 10358	    const outRef = await db.collection('timeclock_entries').add(entry);
 10359	
 10360	    // Update clock-out streak (skip for unscheduled shifts)
 10361	    const todayEntriesForUser = (kioskCurrentUser.todayEntries || []);
 10362	    const lastIn = [...todayEntriesForUser].reverse().find(e => e.type === 'clock-in');
 10363	    let clockOutGraceMsg = null;
 10364	    if (!lastIn || !lastIn.unscheduled) {
 10365	      const isAutoEnded = false; // kiosk clock-outs are always intentional
 10366	      const clockOutResult = await updateKioskStreakOnClockOut(kioskCurrentUser, clockOutTime, isAutoEnded);
 10367	      clockOutGraceMsg = clockOutResult ? clockOutResult.graceMessage : null;
 10368	      if (clockOutResult && clockOutResult.streak != null) {
 10369	        // Detached for the same reason as the clock-in enrichment above (Phase 5 review).
 10370	        void updateClockEntry(outRef.id, {
 10371	          clockOutStreakAfter: clockOutResult.streak,
 10372	          clockOutGrace: parseGraceType(clockOutGraceMsg)
 10373	        });
 10374	      }
 10375	    }
 10376	
 10377	    showKioskConfirmation(kioskCurrentUser, 'clocked-out', null, clockOutGraceMsg);
 10378	  } catch (err) {
 10379	    console.error('Kiosk clock-out failed:', err);
 10380	    showKioskError('Clock-out failed. Please try again.');
 10381	  }
 10382	}
 10383	
 10384	async function kioskBreakStart() {
 10385	  if (!kioskCurrentUser) return;
 10386	  clearKioskAutoReturn();
 10387	  const db = getDb();
 10388	  const now = new Date();
 10389	  const todayStr = now.toLocaleDateString('en-CA');
 10390	  const dayNames = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
 10391	  const weekday = dayNames[now.getDay()];
 10392	  const studio = (kioskCurrentUser.studios && kioskCurrentUser.studios[0]) || 'tinker';
 10393	
 10394	  try {
 10395	    await db.collection('timeclock_entries').add({
 10396	      uid: kioskCurrentUser.uid,
 10397	      name: kioskCurrentUser.name || kioskCurrentUser.email,
 10398	      type: 'break-start',
 10399	      timestamp: now.toISOString(),
 10400	      date: todayStr,
 10401	      weekday,
 10402	      studio,
 10403	      via: 'kiosk'
 10404	    });
 10405	    showKioskConfirmation(kioskCurrentUser, 'on-break', null);
 10406	  } catch (err) {
 10407	    showKioskError('Failed. Please try again.');
 10408	  }
 10409	}
 10410	
 10411	async function kioskBreakEnd() {
 10412	  if (!kioskCurrentUser) return;
 10413	  clearKioskAutoReturn();
 10414	  const db = getDb();
 10415	  const now = new Date();
 10416	  const todayStr = now.toLocaleDateString('en-CA');
 10417	  const dayNames = ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];
 10418	  const weekday = dayNames[now.getDay()];
 10419	  const studio = (kioskCurrentUser.studios && kioskCurrentUser.studios[0]) || 'tinker';
 10420	
 10421	  try {
 10422	    await db.collection('timeclock_entries').add({
 10423	      uid: kioskCurrentUser.uid,
 10424	      name: kioskCurrentUser.name || kioskCurrentUser.email,
 10425	      type: 'break-end',
 10426	      timestamp: now.toISOString(),
 10427	      date: todayStr,
 10428	      weekday,
 10429	      studio,
 10430	      via: 'kiosk'
 10431	    });
 10432	    showKioskConfirmation(kioskCurrentUser, 'clocked-in', null);
 10433	  } catch (err) {
 10434	    showKioskError('Failed. Please try again.');
 10435	  }
 10436	}
 10437	
 10438	function showKioskConfirmation(user, newStatus, clockInStreak, graceMessage) {
 10439	  const screen = document.getElementById('kiosk-pin-screen');
 10440	  if (!screen) return;
 10441	
 10442	  const messages = {
 10443	    'clocked-in': 'Clocked In!',
 10444	    'clocked-out': 'Clocked Out — Have a great day!',
 10445	    'on-break': 'Enjoy your break!'
 10446	  };
 10447	
 10448	  // Show streak count on every clock-in; extra fanfare on multiples of 5
 10449	  let milestoneHtml = '';
 10450	  const isMilestone = newStatus === 'clocked-in' && clockInStreak && clockInStreak % 5 === 0;
 10451	  if (newStatus === 'clocked-in' && clockInStreak && clockInStreak > 0) {
 10452	    const streakMsg = isMilestone
 10453	      ? `🎉 ${clockInStreak}-day on-time streak!`
 10454	      : `🔥 ${clockInStreak}-day streak`;
 10455	    milestoneHtml = `<div class="kiosk-milestone${isMilestone ? ' kiosk-milestone-big' : ''}">${streakMsg}</div>`;
 10456	  }
 10457	
 10458	  const graceMsgHtml = graceMessage
 10459	    ? `<div style="font-size:13px; color:#6b7280; margin-top:8px;">${escapeHtml(graceMessage)}</div>`
 10460	    : '';
 10461	
 10462	  screen.innerHTML = `
 10463	    <div class="kiosk-confirmation">
 10464	      <div class="kiosk-check">✓</div>
 10465	      <div class="kiosk-confirm-name">${escapeHtml(user.name || user.email)}</div>
 10466	      <div class="kiosk-confirm-message">${messages[newStatus] || 'Done!'}</div>
 10467	      ${milestoneHtml}
 10468	      ${graceMsgHtml}
 10469	    </div>
 10470	  `;
 10471	
 10472	  if (newStatus === 'clocked-in') {
 10473	    launchKioskConfetti(isMilestone);
 10474	  }
 10475	
 10476	  // Milestone days get 6 seconds, otherwise 4
 10477	  kioskAutoReturnTimer = setTimeout(() => showKioskPinEntry(), isMilestone ? 6000 : 4000);
 10478	}
 10479	
 10480	function launchKioskConfetti(isMilestone) {
 10481	  let canvas = document.getElementById('kiosk-confetti-canvas');
 10482	  if (!canvas) {
 10483	    canvas = document.createElement('canvas');
 10484	    canvas.id = 'kiosk-confetti-canvas';
 10485	    document.body.appendChild(canvas);
 10486	  }
 10487	  canvas.width = window.innerWidth;
 10488	  canvas.height = window.innerHeight;
 10489	  const ctx = canvas.getContext('2d');
 10490	
 10491	  const colors = ['#4EBFB3', '#F59E0B', '#10B981', '#EF4444', '#8B5CF6', '#EC4899', '#3B82F6'];
 10492	  const count = isMilestone ? 180 : 80;
 10493	  const particles = Array.from({ length: count }, () => ({
 10494	    x: Math.random() * canvas.width,
 10495	    y: Math.random() * canvas.height * -1,
 10496	    w: Math.random() * 10 + 6,
 10497	    h: Math.random() * 6 + 4,
 10498	    color: colors[Math.floor(Math.random() * colors.length)],
 10499	    rot: Math.random() * Math.PI * 2,
 10500	    rotSpeed: (Math.random() - 0.5) * 0.2,
 10501	    vx: (Math.random() - 0.5) * 3,
 10502	    vy: Math.random() * 4 + 3,
 10503	    opacity: 1
 10504	  }));
 10505	
 10506	  let frame;
 10507	  const duration = isMilestone ? 3500 : 2500;
 10508	  const start = performance.now();
 10509	
 10510	  function draw(now) {
 10511	    const elapsed = now - start;
 10512	    ctx.clearRect(0, 0, canvas.width, canvas.height);
 10513	    particles.forEach(p => {
 10514	      p.x += p.vx;
 10515	      p.y += p.vy;
 10516	      p.rot += p.rotSpeed;
 10517	      if (elapsed > duration * 0.6) p.opacity = Math.max(0, p.opacity - 0.02);
 10518	      ctx.save();
 10519	      ctx.globalAlpha = p.opacity;
 10520	      ctx.translate(p.x, p.y);
 10521	      ctx.rotate(p.rot);
 10522	      ctx.fillStyle = p.color;
 10523	      ctx.fillRect(-p.w / 2, -p.h / 2, p.w, p.h);
 10524	      ctx.restore();
 10525	    });
 10526	    if (elapsed < duration) {
 10527	      frame = requestAnimationFrame(draw);
 10528	    } else {
 10529	      ctx.clearRect(0, 0, canvas.width, canvas.height);
 10530	    }
 10531	  }
 10532	
 10533	  if (frame) cancelAnimationFrame(frame);
 10534	  requestAnimationFrame(draw);
 10535	}
 10536	
 10537	function showKioskError(msg) {
 10538	  const screen = document.getElementById('kiosk-pin-screen');
 10539	  if (!screen) return;
 10540	  screen.innerHTML = `
 10540	  screen.innerHTML = `
 10541	    <div style="text-align:center; padding:40px;">
 10542	      <div style="font-size:48px; margin-bottom:16px; color:var(--red);">!</div>
 10543	      <div style="font-size:18px; color:var(--red);">${escapeHtml(msg)}</div>
 10544	      <button class="kiosk-action-btn kiosk-btn-green" style="margin-top:24px;" onclick="showKioskPinEntry()">Try Again</button>
 10545	    </div>
 10546	  `;
 10547	  kioskAutoReturnTimer = setTimeout(() => showKioskPinEntry(), 5000);
 10548	}
 10549	
 10550	// ═══════════════════════════════════════════════════════
 10551	// ADMIN TOOLS — Excuse Late Clock-Out, Restore Streak, Extend End Time
 10552	// ═══════════════════════════════════════════════════════
 10553	
 10554	async function excuseLateClockOut(entryId, uid) {
 10555	  try {
 10556	    const db = getDb();
 10557	    const entrySnap = await db.collection('timeclock_entries').doc(entryId).get();
 10558	    const entryDate = entrySnap.exists ? entrySnap.data().date : null;
 10559	    await db.collection('timeclock_entries').doc(entryId).update({ excused: true, flaggedForReview: false });
 10560	
 10561	    // Remove from lateClockOuts array and restore streak if no later unexcused late clock-outs exist
 10562	    const streakRef = db.collection('timeclock_streaks').doc(uid);
 10563	    const streakSnap = await streakRef.get();
 10564	    if (streakSnap.exists) {
 10565	      const streak = streakSnap.data();
 10566	      const entryTs = entrySnap.exists ? entrySnap.data().timestamp : null;
 10567	      const updatedLateOuts = (streak.lateClockOuts || []).filter(ts => ts !== entryTs);
 10568	
 10569	      // Only restore streak if there are no more recent unexcused late clock-outs for this person
 10570	      const laterUnexcused = _dashboardAlerts.filter(a =>
 10571	        a.type === 'late-flagged' && a.uid === uid && a.rawDate > (entryDate || '') && a.entryId !== entryId
 10572	      );
 10573	      const updates = { lateClockOuts: updatedLateOuts };
 10574	      const restoredOutStreak = (streak.previousClockOutStreak || 0) + 1;
 10575	      if (laterUnexcused.length === 0) {
 10576	        updates.clockOutStreak = restoredOutStreak;
 10577	        await updateClockEntry(entryId, { clockOutStreakAfter: restoredOutStreak });
 10578	      }
 10579	      await streakRef.update(updates);
 10580	    }
 10581	
 10582	    const restored = !_dashboardAlerts.some(a => a.type === 'late-flagged' && a.uid === uid && a.rawDate > (entryDate || '') && a.entryId !== entryId);
 10583	    showToast(restored ? 'Late clock-out excused — streak restored.' : 'Late clock-out excused. Streak unchanged (later late entry still pending).');
 10584	    renderDashboardAlerts();
 10585	  } catch (err) {
 10586	    console.error('Failed to excuse late clock-out:', err);
 10587	    showToast('Error excusing clock-out — see console.');
 10588	  }
 10589	}
 10590	
 10591	async function excuseLateClockIn(entryId, uid) {
 10592	  try {
 10593	    const db = getDb();
 10594	    const entrySnap = await db.collection('timeclock_entries').doc(entryId).get();
 10595	    const entryDate = entrySnap.exists ? entrySnap.data().date : null;
 10596	    await db.collection('timeclock_entries').doc(entryId).update({ excused: true, flaggedForReview: false });
 10597	
 10598	    // Remove from lateClockIns array and restore streak if no later unexcused late clock-ins exist
 10599	    const streakRef = db.collection('timeclock_streaks').doc(uid);
 10600	    const streakSnap = await streakRef.get();
 10601	    if (streakSnap.exists) {
 10602	      const streak = streakSnap.data();
 10603	      const entryTs = entrySnap.exists ? entrySnap.data().timestamp : null;
 10604	      const updatedLateIns = (streak.lateClockIns || []).filter(ts => ts !== entryTs);
 10605	
 10606	      // Only restore streak if there are no more recent unexcused late clock-ins for this person
 10607	      const laterUnexcused = _dashboardAlerts.filter(a =>
 10608	        a.type === 'late-clockin' && a.uid === uid && a.rawDate > (entryDate || '') && a.entryId !== entryId
 10609	      );
 10610	      const updates = { lateClockIns: updatedLateIns };
 10611	      const restoredInStreak = (streak.previousClockInStreak || 0) + 1;
 10612	      if (laterUnexcused.length === 0) {
 10613	        updates.clockInStreak = restoredInStreak;
 10614	        await updateClockEntry(entryId, { clockInStreakAfter: restoredInStreak });
 10615	      }
 10616	      await streakRef.update(updates);
 10617	    }
 10618	
 10619	    const restored = !_dashboardAlerts.some(a => a.type === 'late-clockin' && a.uid === uid && a.rawDate > (entryDate || '') && a.entryId !== entryId);
 10620	    showToast(restored ? 'Late clock-in excused — streak restored.' : 'Late clock-in excused. Streak unchanged (later late entry still pending).');
 10621	    renderDashboardAlerts();
 10622	  } catch (err) {
 10623	    console.error('Failed to excuse late clock-in:', err);
 10624	    showToast('Error excusing clock-in — see console.');
 10625	  }
 10626	}
 10627	
 10628	async function showRestoreStreakInput(uid, name) {
 10629	  const rowId = 'alert-row-' + uid;
 10630	  const row = document.getElementById(rowId);
./schedule-editor-wiring.test.js:1679:    expect(data).toMatch(/^async function updateClockEntry\(docId, updates\) \{[\s\S]*?await _db\.collection\('timeclock_entries'\)\.doc\(docId\)\.update\(updates\);/m);
./js/app.js:2446:    const snap = await db.collection('timeclock_entries')
./js/app.js:2717:    const doc = await getDb().collection('timeclock_entries').doc(entryId).get();
./js/app.js:9783:        db.collection('timeclock_entries')
./js/app.js:9923:    const entryRef = await db.collection('timeclock_entries').add({
./js/app.js:10358:    const outRef = await db.collection('timeclock_entries').add(entry);
./js/app.js:10395:    await db.collection('timeclock_entries').add({
./js/app.js:10422:    await db.collection('timeclock_entries').add({
./js/app.js:10557:    const entrySnap = await db.collection('timeclock_entries').doc(entryId).get();
./js/app.js:10559:    await db.collection('timeclock_entries').doc(entryId).update({ excused: true, flaggedForReview: false });
./js/app.js:10594:    const entrySnap = await db.collection('timeclock_entries').doc(entryId).get();
./js/app.js:10596:    await db.collection('timeclock_entries').doc(entryId).update({ excused: true, flaggedForReview: false });
./js/firebase-data.js:5://   timeclock_entries/{autoId}   — clock in/out/break events
./js/firebase-data.js:35:    const ref = _db.collection('timeclock_entries').doc();
./js/firebase-data.js:56:    const snap = await _db.collection('timeclock_entries')
./js/firebase-data.js:72:    const snap = await _db.collection('timeclock_entries')
./js/firebase-data.js:86:  return _db.collection('timeclock_entries')
./js/firebase-data.js:104:    let query = _db.collection('timeclock_entries')
./js/firebase-data.js:135:    await _db.collection('timeclock_entries').doc(docId).update(updates);
./js/firebase-data.js:146:    await _db.collection('timeclock_entries').doc(docId).delete();
./js/firebase-data.js:671:    const snap = await _db.collection('timeclock_entries')

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '580,675p'; nl -ba js/app.js | sed -n '5920,6105p'; nl -ba js/app.js | sed -n '6630,6805p'; nl -ba js/app.js | sed -n '6925,6985p'; nl -ba js/app.js | sed -n '7840,7925p'; nl -ba js/app.js | sed -n '8760,8895p'; nl -ba js/firebase-data.js | sed -n '180,430p'; nl -ba js/firebase-data.js | sed -n '575,750p'; nl -ba js/firebase-data.js | sed -n '940,1250p'" in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
   580	    lateClockOut: true,
   581	    minutesLate: minsLate,
   582	    scheduledEnd: todayEndOverride || (todayShift ? todayShift.end : null),
   583	    flaggedForReview: flagForReview
   584	  });
   585	
   586	  // Update late clock-out streak tracking
   587	  await trackLateClockOut();
   588	
   589	  _lateClockOutEffectiveEnd = null;
   590	  _lateClockOutNow = null;
   591	}
   592	
   593	async function submitStayedLate() {
   594	  if (!_lateClockOutNow) return;
   595	
   596	  document.getElementById('late-clockout-modal').classList.remove('open');
   597	  clearShiftEndTimer();
   598	  clearBreakTimer();
   599	
   600	  const now = _lateClockOutNow;
   601	  const msLate = _lateClockOutEffectiveEnd ? now.getTime() - _lateClockOutEffectiveEnd.getTime() : 0;
   602	  const minsLate = Math.round(msLate / 60000);
   603	
   604	  await doClockOut(now, {
   605	    lateClockOut: true,
   606	    stayedLate: true,
   607	    minutesLate: minsLate,
   608	    scheduledEnd: todayEndOverride || (todayShift ? todayShift.end : null),
   609	    flaggedForReview: false // "stayed late" is intentional — no flag
   610	  });
   611	
   612	  // Don't penalize streak for intentional late stays
   613	  // (streak tracks unexcused late clock-outs, not intentional ones)
   614	
   615	  _lateClockOutEffectiveEnd = null;
   616	  _lateClockOutNow = null;
   617	}
   618	
   619	async function trackLateClockOut() {
   620	  if (!currentUser || !_ready) return;
   621	  try {
   622	    const streakDoc = await loadStreakData();
   623	    const now = new Date();
   624	
   625	    // Calendar week tracking (Mon–Sun)
   626	    const currentWeekMonday = getMondayDateStr(now);
   627	    let lateClockOuts = streakDoc.lateClockOuts || [];
   628	    let lateClockOutWeek = streakDoc.lateClockOutWeek || '';
   629	
   630	    // Reset if new week
   631	    if (lateClockOutWeek !== currentWeekMonday) {
   632	      lateClockOuts = [];
   633	      lateClockOutWeek = currentWeekMonday;
   634	    }
   635	
   636	    lateClockOuts.push(now.toISOString());
   637	    const count = lateClockOuts.length;
   638	
   639	    const updates = {
   640	      lateClockOuts,
   641	      lateClockOutWeek,
   642	      lastUpdated: now.toISOString()
   643	    };
   644	
   645	    if (count >= 3) {
   646	      // Break clock-out streak + show message on kiosk
   647	      updates.previousClockOutStreak = streakDoc.clockOutStreak || 0;
   648	      updates.clockOutStreak = 0;
   649	      // Show message in app
   650	    }
   651	
   652	    await saveStreakData(updates);
   653	  } catch (err) {
   654	    console.error('Failed to track late clock-out:', err);
   655	  }
   656	}
   657	
   658	// ─── Core clock in/out (shared by normal + unscheduled + auto) ──
   659	
   660	async function doClockIn(now, studio, extraFields) {
   661	  // Cancel clock-in nudge — they're clocking in
   662	  if (shiftStartTimer) { clearTimeout(shiftStartTimer); shiftStartTimer = null; }
   663	
   664	  const entry = {
   665	    uid: currentUser.uid,
   666	    name: currentUser.name || currentUser.email,
   667	    type: 'clock-in',
   668	    timestamp: now.toISOString(),
   669	    date: getTodayDateStr(),
   670	    weekday: getWeekday(),
   671	    studio: studio || (currentUser.studios && currentUser.studios[0]) || 'tinker',
   672	    ...(extraFields || {})
   673	  };
   674	
   675	  const id = await addClockEntry(entry);
  5920	  document.getElementById('setting-ext-threshold').value = appSettings.extensionAlertThreshold || 2;
  5921	  document.getElementById('setting-ext-increment').value = appSettings.extensionIncrementMinutes || 15;
  5922	  document.getElementById('setting-ot-threshold').value = appSettings.overtimeWeeklyThreshold || 40;
  5923	  document.getElementById('setting-ot-multiplier').value = appSettings.overtimeMultiplier || 1.5;
  5924	
  5925	  // Time Off settings
  5926	  document.getElementById('setting-timeoff-notice').value = appSettings.timeoffMinNoticeDays ?? 14;
  5927	  const cats = appSettings.timeoffCategories || DEFAULT_SETTINGS.timeoffCategories;
  5928	  document.getElementById('setting-timeoff-categories').value = Array.isArray(cats) ? cats.join(', ') : cats;
  5929	
  5930	  // Render roster list in Settings
  5931	  renderRosterList();
  5932	}
  5933	
  5934	// ═══════════════════════════════════════════════════════
  5935	// EMPLOYEE ROSTER + NAME CLAIM
  5936	// ═══════════════════════════════════════════════════════
  5937	
  5938	const SEED_EMPLOYEES = [
  5939	  'Julia Zuniga', 'Erica Podwoiski', 'Grey Grimm', 'Lindsay Ternes',
  5940	  'Mariah Stotsky', 'Kathy Martin', 'Kaitlyn Shirley', 'Allie Bundy',
  5941	  'Cris Conklin', 'Alexis Bambach', 'Mackenzie Reinhart',
  5942	  'Leah Trumble', 'Sonia Kumar',
  5943	  'Lisa Goodding', 'Cate Keifer'
  5944	];
  5945	
  5946	function nameToId(name) {
  5947	  return 'emp_' + name.toLowerCase().replace(/\s+/g, '_').replace(/[^a-z0-9_]/g, '');
  5948	}
  5949	
  5950	// ─── Name Claim Check ────────────────────────────────
  5951	
  5952	async function checkNameClaim() {
  5953	  if (!employeeRoster.length) return false; // no roster yet, skip
  5954	
  5955	  // Kiosk account should never go through name claim
  5956	  const authUser = firebase.auth().currentUser;
  5957	  if (authUser && authUser.uid === '06ooFxutK5YTaJvu5SkywY9gZqh2') return false;
  5958	
  5959	  const role = currentUser.role || 'staff';
  5960	
  5961	  // Already claimed — nothing to do
  5962	  const alreadyClaimed = employeeRoster.find(e => e.claimedBy === currentUser.uid);
  5963	  if (alreadyClaimed) return false;
  5964	
  5965	  // Auto-claim by exact name match for all roles
  5966	  const match = employeeRoster.find(e =>
  5967	    e.active !== false && !e.claimedBy &&
  5968	    (e.name || '').toLowerCase() === (currentUser.name || '').toLowerCase()
  5969	  );
  5970	  if (match) {
  5971	    match.claimedBy = currentUser.uid;
  5972	    await saveEmployeeRoster(employeeRoster);
  5973	    await migrateSchedule(match.id, currentUser.uid);
  5974	    return false;
  5975	  }
  5976	
  5977	  // Admin/manager with no name match: show modal only if unclaimed entries exist
  5978	  if (role === 'admin' || role === 'manager') {
  5979	    const hasUnclaimed = employeeRoster.some(e => e.active !== false && !e.claimedBy);
  5980	    if (!hasUnclaimed) return false;
  5981	    showClaimModal();
  5982	    return true;
  5983	  }
  5984	
  5985	  // Staff not yet claimed → show claim modal
  5986	  showClaimModal();
  5987	  return true;
  5988	}
  5989	
  5990	function showClaimModal() {
  5991	  const container = document.getElementById('claim-name-list');
  5992	  const unclaimed = employeeRoster
  5993	    .filter(e => e.active !== false && !e.claimedBy)
  5994	    .sort((a, b) => a.name.localeCompare(b.name));
  5995	
  5996	  if (unclaimed.length === 0) {
  5997	    container.innerHTML = '<div class="empty-state">No unclaimed names available. Contact your manager.</div>';
  5998	    document.getElementById('btn-claim-name').style.display = 'none';
  5999	    hideLoading();
  6000	    document.getElementById('claim-modal').classList.add('open');
  6001	    return;
  6002	  }
  6003	
  6004	  container.innerHTML = unclaimed.map(emp => `
  6005	    <label style="display:flex; align-items:center; gap:10px; padding:10px 12px; border:1px solid var(--border-light); border-radius:8px; cursor:pointer; transition:background 0.15s;">
  6006	      <input type="radio" name="claim-name" value="${escapeHtml(emp.id)}" style="accent-color:var(--teal);">
  6007	      <span style="font-weight:600; font-size:15px;">${escapeHtml(emp.name)}</span>
  6008	    </label>
  6009	  `).join('');
  6010	
  6011	  // Enable button when a name is selected
  6012	  container.querySelectorAll('input[name="claim-name"]').forEach(radio => {
  6013	    radio.addEventListener('change', () => {
  6014	      document.getElementById('btn-claim-name').disabled = false;
  6015	    });
  6016	  });
  6017	
  6018	  hideLoading();
  6019	  document.getElementById('claim-modal').classList.add('open');
  6020	}
  6021	
  6022	async function handleClaimName() {
  6023	  const selected = document.querySelector('input[name="claim-name"]:checked');
  6024	  if (!selected) return;
  6025	
  6026	  const empId = selected.value;
  6027	  const btn = document.getElementById('btn-claim-name');
  6028	  const errorEl = document.getElementById('claim-error');
  6029	  btn.disabled = true;
  6030	  btn.textContent = 'Claiming...';
  6031	  errorEl.style.display = 'none';
  6032	
  6033	  // Fresh-read roster to prevent race conditions
  6034	  const freshRoster = await loadEmployeeRoster();
  6035	  const emp = freshRoster.find(e => e.id === empId);
  6036	
  6037	  if (!emp) {
  6038	    errorEl.textContent = 'Employee not found. Please try again.';
  6039	    errorEl.style.display = 'block';
  6040	    btn.disabled = false;
  6041	    btn.textContent = 'Claim This Name';
  6042	    return;
  6043	  }
  6044	
  6045	  if (emp.claimedBy) {
  6046	    errorEl.textContent = 'This name was just claimed by someone else. Please choose another.';
  6047	    errorEl.style.display = 'block';
  6048	    // Refresh the list
  6049	    employeeRoster = freshRoster;
  6050	    showClaimModal();
  6051	    return;
  6052	  }
  6053	
  6054	  // Claim it
  6055	  emp.claimedBy = currentUser.uid;
  6056	  const saved = await saveEmployeeRoster(freshRoster);
  6057	  if (!saved) {
  6058	    errorEl.textContent = 'Failed to save. Please try again.';
  6059	    errorEl.style.display = 'block';
  6060	    btn.disabled = false;
  6061	    btn.textContent = 'Claim This Name';
  6062	    return;
  6063	  }
  6064	
  6065	  // Migrate schedule from temp ID to real UID
  6066	  await migrateSchedule(empId, currentUser.uid);
  6067	
  6068	  // Update local state
  6069	  employeeRoster = freshRoster;
  6070	
  6071	  // Update header display name
  6072	  document.getElementById('header-user').textContent = emp.name;
  6073	
  6074	  // Close modal and continue app init
  6075	  document.getElementById('claim-modal').classList.remove('open');
  6076	
  6077	  // Continue the rest of initialization that was deferred
  6078	  await loadSchedulesData();
  6079	  loadMyShift();
  6080	  await loadMyStatus();
  6081	  renderMySchedule();
  6082	
  6083	  const hfwaDate = document.getElementById('hfwa-date');
  6084	  if (hfwaDate) hfwaDate.value = getTodayDateStr();
  6085	
  6086	  hideLoading();
  6087	}
  6088	
  6089	async function skipClaimModal() {
  6090	  document.getElementById('claim-modal').classList.remove('open');
  6091	
  6092	  // Log a notification for the admin so they know someone skipped
  6093	  try {
  6094	    await getDb().collection('timeclock_settings').doc('appConfig').set({
  6095	      unclaimedLogins: firebase.firestore.FieldValue.arrayUnion({
  6096	        uid: currentUser.uid,
  6097	        email: currentUser.email,
  6098	        name: currentUser.name || currentUser.email,
  6099	        skippedAt: new Date().toISOString()
  6100	      })
  6101	    }, { merge: true });
  6102	  } catch (err) {
  6103	    console.warn('Could not log unclaimed login:', err);
  6104	  }
  6105	
  6630	async function removeOrphanedSchedule(schedId, name) {
  6631	  if (!confirm(`Remove orphaned schedule for "${name}"? This only removes the schedule doc — clock history is preserved.`)) return;
  6632	  try {
  6633	    const db = getDb();
  6634	    await db.collection('timeclock_schedules').doc(schedId).delete();
  6635	    showToast(`Orphaned schedule for ${name} removed.`);
  6636	    renderOrphanedSchedules();
  6637	  } catch (err) {
  6638	    console.error('Failed to remove orphaned schedule:', err);
  6639	    showToast('Error removing schedule — see console.');
  6640	  }
  6641	}
  6642	
  6643	async function removeEmployee(empId, name) {
  6644	  if (!confirm(`Remove ${name} completely? This will delete their roster entry and schedule. Clock history is preserved.`)) return;
  6645	  try {
  6646	    // Read the entry BEFORE it is spliced out (Phase 5): the claimed-UID lookup used to run after the
  6647	    // splice, so it never found anything and a claimed employee's real schedule was never deleted.
  6648	    const idx = employeeRoster.findIndex(e => e.id === empId);
  6649	    if (idx === -1) { showToast(`${name} is no longer on the roster — refresh to see the current list.`); return; }   // a second click while the first is saving
  6650	    const entry = employeeRoster[idx];
  6651	    employeeRoster.splice(idx, 1);
  6652	    // The roster save is checked (Phase 5): if it did not land, the person is still on the roster, so
  6653	    // their schedules must not be deleted and the in-memory list is put back as it was.
  6654	    if (!(await saveEmployeeRoster(employeeRoster))) {
  6655	      employeeRoster.splice(idx, 0, entry);
  6656	      alert(`Could not update the roster, so ${name} was NOT removed. Nothing was changed. Please try again.`);
  6657	      return;
  6658	    }
  6659	
  6660	    // Delete schedule docs (may exist under emp_* id or claimed UID)
  6661	    const toDelete = [empId];
  6662	    if (entry && entry.claimedBy) toDelete.push(entry.claimedBy);
  6663	
  6664	    // Phase 5: the deletes used to be swallowed (`.catch(() => {})`) and "removed." shown regardless. The
  6665	    // roster entry IS gone by here (awaited above), so a schedule that survives is named, not hidden: it
  6666	    // stays visible on the All Schedules list — under its stored name, or as "Unknown" with its id for a
  6667	    // legacy doc without one — and an emp_* one in Orphaned Schedules; Delete / Remove finish the job once
  6668	    // the cause is fixed.
  6669	    const results = await Promise.all(toDelete.map(id => deleteSchedule(id)));
  6670	    const left = toDelete.filter((id, i) => !results[i]);
  6671	    if (left.length) {
  6672	      alert(`${name} was removed from the roster, BUT their schedule document${left.length === 1 ? '' : 's'} could not be deleted (${left.join(', ')}). Their shifts may still show on the schedule — see the console, then delete from the All Schedules list once the cause is fixed.`);
  6673	    }
  6674	
  6675	    showToast(left.length ? `${name} removed from the roster.` : `${name} removed.`);
  6676	    const container = document.getElementById('roster-list');
  6677	    if (container) {
  6678	      const row = [...container.querySelectorAll('div')].find(d => d.textContent.includes(name));
  6679	      if (row) row.remove();
  6680	    }
  6681	    // Re-render to be safe
  6682	    const rosterContainer = document.getElementById('roster-list');
  6683	    if (rosterContainer) {
  6684	      const sorted = [...employeeRoster].filter(e => e.active !== false).sort((a, b) => a.name.localeCompare(b.name));
  6685	      rosterContainer.innerHTML = sorted.length
  6686	        ? sorted.map(emp => {
  6687	            const status = emp.claimedBy ? '<span style="color:var(--green); font-size:11px; font-weight:700;">Claimed</span>' : '<span style="color:var(--text-light); font-size:11px;">Unclaimed</span>';
  6688	            const pinLabel = emp.pin ? 'Change PIN' : 'Set PIN';
  6689	            const pinBtn = `<button class="btn btn-sm" style="font-size:11px; padding:2px 8px;" onclick="openSetPinModal(${jsArg(emp.id)}, ${jsArg(emp.name)})"> ${pinLabel}</button>`;
  6690	            const pinStatus = emp.pin ? '<span style="font-size:11px; color:var(--teal);">PIN set</span>' : '';
  6691	            const removeBtn = `<button class="btn btn-sm" style="font-size:11px; padding:2px 8px; color:var(--red); border-color:var(--red);" onclick="removeEmployee(${jsArg(emp.id)}, ${jsArg(emp.name)})">Remove</button>`;
  6692	            return `<div style="display:flex; justify-content:space-between; align-items:center; padding:6px 0; border-bottom:1px solid var(--border-light);"><span style="font-size:13px; font-weight:600;">${escapeHtml(emp.name)}</span><div style="display:flex; align-items:center; gap:8px;">${status}${pinStatus}${pinBtn}${removeBtn}</div></div>`;
  6693	          }).join('')
  6694	        : '<div class="empty-state">No employees.</div>';
  6695	    }
  6696	    renderArchivedRosterList();
  6697	  } catch (err) {
  6698	    console.error('Failed to remove employee:', err);
  6699	    showToast('Error removing employee — see console.');
  6700	  }
  6701	}
  6702	
  6703	async function mergeDuplicateRosterEntry(unclamedId, name) {
  6704	  // Transfers PIN from the unclaimed duplicate to the claimed entry, then removes the duplicate.
  6705	  if (!confirm(`Merge duplicate "${name}"?\n\nThis will transfer the PIN from the unclaimed entry to the claimed one, then delete the duplicate. Future kiosk clock-ins will be linked to the correct account.`)) return;
  6706	  try {
  6707	    const freshRoster = await loadEmployeeRoster();
  6708	    const unclaimed = freshRoster.find(e => e.id === unclamedId && !e.claimedBy);
  6709	    const claimed = freshRoster.find(e => e.active !== false && e.claimedBy &&
  6710	      (e.name || '').toLowerCase() === (name || '').toLowerCase()
  6711	    );
  6712	
  6713	    if (!unclaimed || !claimed) {
  6714	      showToast('Could not find matching entries — refresh and try again.');
  6715	      return;
  6716	    }
  6717	
  6718	    // Transfer PIN to claimed entry if it doesn't already have one
  6719	    if (unclaimed.pin && !claimed.pin) {
  6720	      claimed.pin = unclaimed.pin;
  6721	    }
  6722	
  6723	    // Remove the unclaimed duplicate
  6724	    const idx = freshRoster.findIndex(e => e.id === unclamedId);
  6725	    if (idx !== -1) freshRoster.splice(idx, 1);
  6726	
  6727	    await saveEmployeeRoster(freshRoster);
  6728	    employeeRoster = freshRoster;
  6729	    showToast(`Merged — ${name}'s kiosk clock-ins will now link to their account.`);
  6730	    renderRosterList();
  6731	  } catch (err) {
  6732	    console.error('Merge failed:', err);
  6733	    showToast('Merge failed — see console.');
  6734	  }
  6735	}
  6736	
  6737	// ─── Assign Roster Entry to User (admin) ─────────────
  6738	
  6739	let _assigningEmpId = null;
  6740	
  6741	async function openAssignUserModal(empId, empName) {
  6742	  _assigningEmpId = empId;
  6743	  const freshUsers = await loadAllUsers();
  6744	  const claimedUids = new Set(employeeRoster.filter(e => e.claimedBy).map(e => e.claimedBy));
  6745	  const available = freshUsers.filter(u => !claimedUids.has(u.uid));
  6746	  if (available.length === 0) {
  6747	    alert(`No unclaimed user accounts found.\n\n"${empName}" needs to log into the app on their phone first — then use Assign.`);
  6748	    return;
  6749	  }
  6750	  const answer = window.prompt(
  6751	    `Assign "${empName}" to which user?\n\nAvailable accounts:\n` +
  6752	    available.map((u, i) => `${i + 1}. ${u.name || u.email} (${u.email})`).join('\n') +
  6753	    '\n\nEnter the number:'
  6754	  );
  6755	  if (!answer) return;
  6756	  const idx = parseInt(answer, 10);
  6757	  if (isNaN(idx) || idx < 1 || idx > available.length) {
  6758	    alert('Invalid selection.');
  6759	    return;
  6760	  }
  6761	  confirmAssignUser(empId, available[idx - 1].uid);
  6762	}
  6763	
  6764	async function confirmAssignUser(empId, uid) {
  6765	  try {
  6766	    const freshRoster = await loadEmployeeRoster();
  6767	    const emp = freshRoster.find(e => e.id === empId);
  6768	    if (!emp) { showToast('Employee not found.'); return; }
  6769	    if (emp.claimedBy) { showToast('Already claimed — refresh the page.'); return; }
  6770	    emp.claimedBy = uid;
  6771	    await saveEmployeeRoster(freshRoster);
  6772	    await migrateSchedule(empId, uid);
  6773	    employeeRoster = freshRoster;
  6774	    showToast(`Assigned — ${emp.name} linked to account.`);
  6775	    renderRosterList();
  6776	  } catch (err) {
  6777	    console.error('Assign user failed:', err);
  6778	    showToast('Failed to assign user — see console.');
  6779	  }
  6780	}
  6781	
  6782	// ═══════════════════════════════════════════════════════
  6783	// TIME OFF TAB
  6784	// ═══════════════════════════════════════════════════════
  6785	
  6786	let timeoffFormDates = [];    // [{date, type, partialStart, partialEnd, flexible}]
  6787	let timeoffFormSubs = [];     // [{name, dates}]
  6788	// What an EDIT form opened with (plan: ticker-sub-confirm-only-by-manager). The form cannot confirm anyone,
  6789	// so at save these decide whether the form is out of date (checkEditAgainstDocument). null until an edit loads.
  6790	let openedSubs = null;        // name -> { confirmed, hasRecord, entry }
  6791	let openedDates = null;       // normalizeRequestDates(document dates) — never timeoffFormDates, whose rows are edited in place
  6792	let allTimeoffRequests = [];  // cached for admin
  6793	let viewingRequestId = null;  // currently open detail modal
  6794	let detailLoadSeq = 0;         // each openTimeOffDetail call's number; only the latest may draw
  6795	let editingTimeOffId = null;  // non-null when editing an existing request
  6796	
  6797	// ─── Init Time Off Listeners ────────────────────────
  6798	
  6799	function initTimeOffListeners() {
  6800	  document.getElementById('btn-new-timeoff').addEventListener('click', openTimeOffForm);
  6801	  document.getElementById('btn-add-date-row').addEventListener('click', () => addTimeOffDateRow());
  6802	  document.getElementById('btn-submit-timeoff').addEventListener('click', handleSubmitTimeOff);
  6803	
  6804	  // Auto-add sub when selecting from dropdown (no extra button needed)
  6805	  document.getElementById('timeoff-sub-picker').addEventListener('change', addTimeOffSub);
  6925	  return formatted[0] + ' \u2013 ' + formatted[formatted.length - 1] + ' (' + formatted.length + ' days)';
  6926	}
  6927	
  6928	// ─── Admin: Pending Count ───────────────────────────
  6929	
  6930	function updatePendingCount() {
  6931	  const countEl = document.getElementById('timeoff-pending-count');
  6932	  if (!countEl) return;
  6933	  const pending = allTimeoffRequests.filter(timeOffNeedsAction);
  6934	  if (pending.length > 0) {
  6935	    countEl.textContent = pending.length + ' needs action';
  6936	    countEl.style.display = 'inline';
  6937	  } else {
  6938	    countEl.style.display = 'none';
  6939	  }
  6940	}
  6941	
  6942	// ─── Admin: All Requests (combined view) ────────────
  6943	
  6944	function isTimeOffPast(r) {
  6945	  if (!r.dates || !r.dates.length) return false;
  6946	  const today = new Date().toISOString().slice(0, 10);
  6947	  return r.dates.every(d => d.date < today);
  6948	}
  6949	
  6950	async function autoCompletePassedTimeOff() {
  6951	  const toComplete = allTimeoffRequests.filter(r =>
  6952	    r.status === 'approved' && isTimeOffPast(r) && !r.reversalPending   // Phase 3b: keep it actionable
  6953	  );
  6954	  for (const r of toComplete) {
  6955	    await updateTimeOffRequest(r.id, {
  6956	      status: 'completed',
  6957	      completedAt: new Date().toISOString()
  6958	    });
  6959	    r.status = 'completed';
  6960	    r.completedAt = new Date().toISOString();
  6961	  }
  6962	}
  6963	
  6964	// A request needs a manager's attention if it is awaiting review OR its schedule reversal never landed
  6965	// (Phase 3b). The second half is what makes "manager completes it" real: a staff member's withdrawal of
  6966	// an approved request lands as reversalPending, and without this it sat under the Past filter where
  6967	// nobody looks. One predicate, used by the filter, the badge count, and the dashboard.
  6968	function timeOffNeedsAction(r) {
  6969	  return ['submitted', 'under_review'].includes(r.status) || !!r.reversalPending;
  6970	}
  6971	
  6972	// From the dashboard's pending list: switch to the tab under Needs Action (so the request is in the list
  6973	// whatever its status) and open it directly. Phase 3b — "View in Time Off" used to land on the default
  6974	// Active filter, where a withdrawn+flagged request was not shown.
  6975	async function openTimeOffFromDashboard(requestId) {
  6976	  const sel = document.getElementById('timeoff-filter-status');
  6977	  if (sel) sel.value = 'needs_action';
  6978	  switchToTab('timeoff');
  6979	  // switchToTab kicks off renderTimeOffTab (async); the detail modal reads allTimeoffRequests, so make
  6980	  // sure it is populated before opening.
  6981	  if (!allTimeoffRequests.length || !allTimeoffRequests.some(r => r.id === requestId)) {
  6982	    allTimeoffRequests = await getAllTimeOffRequests();
  6983	  }
  6984	  openTimeOffDetail(requestId);
  6985	}
  7840	    }
  7841	  }
  7842	
  7843	  html += '</div>';
  7844	
  7845	  body.innerHTML = html;
  7846	}
  7847	
  7848	// ─── Edit Request ──────────────────────────────────
  7849	
  7850	async function editTimeOff(requestId) {
  7851	  // Load the request fresh
  7852	  try {
  7853	    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
  7854	    if (!doc.exists) { alert('Request not found.'); return; }
  7855	    const req = { id: doc.id, ...doc.data() };
  7856	    // Close detail modal, open form pre-populated
  7857	    document.getElementById('timeoff-detail-modal').classList.remove('open');
  7858	    openTimeOffForm(req);
  7859	  } catch (err) {
  7860	    console.error('Failed to load request for edit:', err);
  7861	    alert('Failed to load request. Please try again.');
  7862	  }
  7863	}
  7864	
  7865	// ─── Comment ────────────────────────────────────────
  7866	
  7867	// Appends one comment by the current user to a request (Phase 4: a durable trace for a hand-off, next to
  7868	// the push that may not arrive). Same entry shape as addTimeOffComment. Returns true if it landed.
  7869	async function appendTimeOffComment(requestId, text) {
  7870	  // arrayUnion: an atomic append, so a comment landing from another tab at the same moment is not lost
  7871	  // (review finding on the read→whole-array write the older comment path uses).
  7872	  return updateTimeOffRequest(requestId, { comments: firebase.firestore.FieldValue.arrayUnion({
  7873	    by: currentUser.name || currentUser.email, uid: currentUser.uid, role: currentUser.role || 'staff', text, at: new Date().toISOString(),
  7874	  }) });
  7875	}
  7876	
  7877	async function addTimeOffComment(requestId) {
  7878	  const input = document.getElementById('timeoff-comment-input');
  7879	  const text = (input ? input.value : '').trim();
  7880	  if (!text) return;
  7881	
  7882	  try {
  7883	    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
  7884	    if (!doc.exists) return;
  7885	    const data = doc.data();
  7886	    const comments = data.comments || [];
  7887	    const isAdminComment = currentUser.role === 'admin' || currentUser.role === 'manager';
  7888	    comments.push({
  7889	      by: currentUser.name || currentUser.email,
  7890	      uid: currentUser.uid,
  7891	      role: currentUser.role || 'staff',
  7892	      text,
  7893	      at: new Date().toISOString()
  7894	    });
  7895	    await updateTimeOffRequest(requestId, { comments });
  7896	
  7897	    // Push: admin comment → notify staff owner; staff comment → notify all admins.
  7898	    // Also email — push notifications aren't reliably reaching people, so this is the more dependable
  7899	    // channel now. Same routing as the submission email: admin comment → the requester directly; staff
  7900	    // comment (only the owner or an admin can even reach this detail view, so this is the owner adding
  7901	    // more context) → the studio coordinator(s) for this request + Anika.
  7902	    if (isAdminComment && data.uid && data.uid !== currentUser.uid) {
  7903	      sendPushToUser(data.uid, 'Comment on Your Time Off Request', `${currentUser.name || 'Admin'}: ${text}`);
  7904	      // Requester-only, nobody cc'd — so the admin gets told whether it went out.
  7905	      sendTimeOffCommentEmail({
  7906	        commenterName: currentUser.name || currentUser.email || 'Admin',
  7907	        commentText: text, requesterName: data.name, isAdminComment: true, requesterEmail: data.email,
  7908	      }, data.name || 'the requester');
  7909	    } else if (!isAdminComment) {
  7910	      sendPushToAllAdmins('New Comment on Time Off Request', `${currentUser.name || 'Staff'}: ${text}`);
  7911	      sendTimeOffCommentEmail({
  7912	        commenterName: currentUser.name || currentUser.email || 'Staff',
  7913	        commentText: text, requesterName: data.name, isAdminComment: false, studios: data.requestStudios,
  7914	      });
  7915	    }
  7916	
  7917	    openTimeOffDetail(requestId); // refresh
  7918	  } catch (err) {
  7919	    console.error('Failed to add comment:', err);
  7920	  }
  7921	}
  7922	
  7923	// ─── Sub Confirmation + Auto-Assignment (Plan 2, Phase 3) ─────────
  7924	
  7925	let _confirmSubCtx = null; // tracks requestId/subIndex/dates/uids for the confirm-sub modal flow
  8760	    const isAdmin = currentUser.role === 'admin' || currentUser.role === 'manager';
  8761	    if (!anyPending) {
  8762	      document.getElementById('timeoff-detail-modal').classList.remove('open');
  8763	      showToast('Request withdrawn' + skippedDatesNote(reversal));
  8764	    } else if (isAdmin) {
  8765	      // Leave the modal open: the message tells them to use Retry, which is on this request.
  8766	      openTimeOffDetail(requestId);
  8767	      alert('Request withdrawn, BUT ' + (reversal.ok
  8768	        ? `coverage for ${subs.failed.map(f => f.name).join(', ')} could not be removed from their schedule — open the request and use "Retry schedule reversal".`
  8769	        : reversalFailureMessage(data.name || 'this person', reversal.reason)));
  8770	    } else {
  8771	      // Staff cannot write schedules, so this is the expected path for a staff withdrawal of an approved
  8772	      // request — the "manager completes it" flow. Tell a manager NOW rather than waiting for 3b's
  8773	      // Needs Action surfacing; the promise below is only true if someone is told.
  8774	      sendPushToAllAdmins('Withdrawal needs a schedule fix', `${data.name || 'A staff member'} withdrew an approved request — their time off is still on the schedule. Open the request and use Retry schedule reversal.`);
  8775	      document.getElementById('timeoff-detail-modal').classList.remove('open');
  8776	      alert('Request withdrawn. Your time off is still on the schedule for now — a manager has been notified and will finish removing it.');
  8777	    }
  8778	  } catch (err) {
  8779	    console.error('Failed to withdraw:', err);
  8780	    alert('Failed to withdraw request.');
  8781	  }
  8782	}
  8783	
  8784	async function completeTimeOff(requestId) {
  8785	  if (!confirm('Mark this time off as completed? (Use this after the time off dates have passed.)')) return;
  8786	
  8787	  await updateTimeOffRequest(requestId, {
  8788	    status: 'completed',
  8789	    completedAt: new Date().toISOString()
  8790	  });
  8791	
  8792	  allTimeoffRequests = await getAllTimeOffRequests();
  8793	  renderAdminAllTimeOff();
  8794	  renderAdminAllTimeOff();
  8795	  openTimeOffDetail(requestId);
  8796	  showToast('Marked complete');
  8797	}
  8798	
  8799	// Shares the in-flight guard with approveTimeOff, for a smaller reason: running this twice cannot corrupt
  8800	// the record the way a double approval can — removeTimeOffOverrides() is idempotent for a fixed record,
  8801	// and the Object.keys() check below short-circuits once appliedOverrides is nulled. What a second run DOES
  8802	// do is send the employee a duplicate "returned to under review" push. Same dead-UI trigger, same guard.
  8803	//
  8804	// Phase 3a (Sep 11 2026) closed the other bug this function carried: removeTimeOffOverrides() now
  8805	// reports its result, and the appliedOverrides: null write goes through reversalPatch(), which only
  8806	// clears on success and marks reversalPending otherwise. The status change still proceeds either way.
  8807	async function unapproveTimeOff(requestId, btn) {
  8808	  if (_timeoffActionInFlight.has(requestId)) return;
  8809	  if (!confirm('Return this request to Under Review? Any schedule overrides from approval will be removed.')) return;
  8810	
  8811	  _timeoffActionInFlight.add(requestId);
  8812	  const btnLabel = btn ? btn.textContent : null;
  8813	  if (btn) { btn.disabled = true; btn.textContent = 'Working...'; }
  8814	
  8815	  try {
  8816	    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
  8817	    if (!doc.exists) return;
  8818	    const data = doc.data();
  8819	
  8820	    // Remove applied overrides if any (from a prior approval). Phase 3: the result decides whether the
  8821	    // record is cleared — never clear what did not land.
  8822	    let reversal = { ok: true };
  8823	    if (data.appliedOverrides && Object.keys(data.appliedOverrides).length) {
  8824	      reversal = await removeTimeOffOverrides(data.uid, data.appliedOverrides);
  8825	    }
  8826	
  8827	    // Same gate as confirmDenyTimeOff: a status change that did not land must not be announced.
  8828	    const wrote = await updateTimeOffRequest(requestId, {
  8829	      status: 'under_review',
  8830	      reviewAction: null,
  8831	      denialReason: null,
  8832	      completedAt: null,
  8833	      ...reversalPatch(reversal),
  8834	    });
  8835	    if (!wrote) {
  8836	      alert('Failed to return the request to review — the status was not changed and nobody was notified. Please try again.');
  8837	      return;
  8838	    }
  8839	
  8840	    allTimeoffRequests = await getAllTimeOffRequests();
  8841	    renderAdminAllTimeOff();
  8842	    openTimeOffDetail(requestId);
  8843	    if (data.uid) sendPushToUser(data.uid, 'Time Off Update', 'Your time off request has been returned to under review.');
  8844	    if (reversal.ok) showToast('Returned to under review' + skippedDatesNote(reversal));
  8845	    else alert('Returned to under review, BUT ' + reversalFailureMessage(data.name || 'this person', reversal.reason));
  8846	    // previousStatus drives the wording: this button is offered on BOTH approved and denied requests, and
  8847	    // "no longer approved" is false — and the opposite of the news — when it was denied a minute ago.
  8848	    sendTimeOffStatusEmail({
  8849	      status: 'under_review', previousStatus: data.status, reversalPending: !reversal.ok, reversalReason: reversal.reason,
  8850	      requesterEmail: resolveRequesterEmail(data), requesterName: data.name, dates: data.dates, reason: data.reason,
  8851	      reviewedBy: currentUser.name || currentUser.email, studios: resolveRequesterStudios(data),
  8852	    });
  8853	  } catch (err) {
  8854	    console.error('Failed to unapprove:', err);
  8855	    alert('Failed to return request to review.');
  8856	  } finally {
  8857	    _timeoffActionInFlight.delete(requestId);
  8858	    if (btn && btn.isConnected) { btn.disabled = false; btn.textContent = btnLabel; }
  8859	  }
  8860	}
  8861	
  8862	async function reopenTimeOff(requestId) {
  8863	  await updateTimeOffRequest(requestId, {
  8864	    status: 'approved',
  8865	    completedAt: null
  8866	  });
  8867	
  8868	  allTimeoffRequests = await getAllTimeOffRequests();
  8869	  renderAdminAllTimeOff();
  8870	  renderAdminAllTimeOff();
  8871	  openTimeOffDetail(requestId);
  8872	  showToast('Reopened as approved');
  8873	}
  8874	
  8875	// ─── Schedule Integration ───────────────────────────
  8876	
  8877	// The time-off schedule orchestration lives in js/timeoff-schedule.js (see its header for why). These are
  8878	// thin wrappers with the SAME names and signatures, so the eight external call sites did not change
  8879	// (approveTimeOff's own two calls now go through the module directly). They stay `async function`
  8880	// declarations rather than `const`s so hoisting and the global-scope binding are identical to before.
  8881	//
  8882	// Deps are built PER CALL, never at parse time: firebase.firestore.FieldValue and the data-layer `_ready`
  8883	// flag are not guaranteed to exist when this file is first evaluated, and capturing them eagerly would
  8884	// throw on load. Each function gets only the deps it uses. (The sentinel IS created at wrapper entry
  8885	// rather than inside the delete branch as before — a marginally earlier throw path that can only fire if
  8886	// the compat SDK failed to load, in which case nothing in the app works. Both reviewers judged it harmless;
  8887	// noted so nobody reads the wrappers as literally identical in exceptional environments.)
  8888	//
  8889	// No try/catch in any wrapper: the eight external callers rely on a rejected promise propagating exactly
  8890	// as it did from the original bodies.
  8891	function timeOffApplyDeps() {
  8892	  // deleteField: apply now deletes, per date, the keys a partial-day value does not carry (note-leak fix).
  8893	  return { loadScheduleResult, saveSchedule, deleteField: firebase.firestore.FieldValue.delete() };
  8894	}
  8895	
   180	  const keys = Object.keys(totals);
   181	  if (!keys.length && !o.allowEmpty) return { ok: false, reason: 'empty-totals' };
   182	  // The Payroll Tool reads totalHours / regular / overtime off each entry, so this document is the contract
   183	  // between the two apps. A non-empty object is not automatically a usable snapshot (Codex, Sep 28).
   184	  // Number.isFinite, not typeof: typeof NaN === 'number', and calcPeriodTotals CAN emit NaN — an entry
   185	  // whose timestamp does not parse gives Math.max(0, NaN) === NaN, which then poisons regular via
   186	  // `weeks[k] += NaN` (NaN > 40 is false). All THREE fields are read by the Payroll Tool, and `regular` is
   187	  // precisely the one that goes NaN while overtime stays 0 (both reviewers, Sep 28).
   188	  // Shared with the caller, which checks BEFORE it asks the manager to confirm. This copy is what stops a
   189	  // future writer bypassing that, so both exist deliberately.
   190	  const bad = findMalformedTotal(totals);
   191	  if (bad) return { ok: false, reason: 'malformed-totals', uid: bad.uid, name: bad.name, count: bad.count };
   192	  try {
   193	    const ref = _db.collection('timeclock_settings').doc('lockedPeriods');
   194	    return await _db.runTransaction(async (tx) => {
   195	      const doc = await tx.get(ref);
   196	      const existing = (doc.exists ? (doc.data() || {}) : {})[periodKey];
   197	      if (existing) {
   198	        return { ok: false, reason: 'already-locked',
   199	                 lockedBy: existing.lockedBy || null, lockedAt: existing.lockedAt || null };
   200	      }
   201	      // Strip empty names before writing: calcPeriodTotals emits `name: emp.name || ''` and the repo's
   202	      // non-negotiable invariant is that empty-string fields are stripped before any write. The Payroll
   203	      // Tool reads totalHours / regular / overtime and not name, so omitting it changes nothing downstream
   204	      // (Codex, round five).
   205	      const clean = {};
   206	      Object.keys(totals).forEach(uid => {
   207	        const v = totals[uid];
   208	        const rec = { regular: v.regular, overtime: v.overtime, totalHours: v.totalHours };
   209	        if (typeof v.name === 'string' && v.name.trim()) rec.name = v.name;
   210	        clean[uid] = rec;
   211	      });
   212	      tx.set(ref, {
   213	        [periodKey]: {
   214	          lockedAt: new Date().toISOString(),
   215	          lockedBy: (getAuthUser() || {}).name || 'unknown',
   216	          employeeTotals: clean
   217	        }
   218	      }, { merge: true });
   219	      return { ok: true };
   220	    });
   221	  } catch (err) {
   222	    console.error('Failed to lock period:', err);
   223	    return { ok: false, reason: 'error' };
   224	  }
   225	}
   226	
   227	async function unlockPayPeriod(periodKey) {
   228	  if (!_ready) return false;
   229	  try {
   230	    await _db.collection('timeclock_settings').doc('lockedPeriods').set({
   231	      [periodKey]: firebase.firestore.FieldValue.delete()
   232	    }, { merge: true });
   233	    return true;
   234	  } catch (err) {
   235	    console.error('Failed to unlock period:', err);
   236	    return false;
   237	  }
   238	}
   239	
   240	async function getLockedPeriods() {
   241	  if (!_ready) return {};
   242	  try {
   243	    const doc = await _db.collection('timeclock_settings').doc('lockedPeriods').get();
   244	    return doc.exists ? doc.data() : {};
   245	  } catch (err) {
   246	    console.error('Failed to get locked periods:', err);
   247	    return {};
   248	  }
   249	}
   250	
   251	// ─── Schedules ───────────────────────────────────────
   252	
   253	// Reads a schedule as { ok, schedule }. A FAILED read (ok:false — rules, network, not ready) is kept
   254	// distinct from an employee who simply has no schedule document (ok:true, schedule:null). loadSchedule()
   255	// below collapses both into null, which is how the time-off approval used to treat a rules regression as
   256	// "nothing to override" and report success. Same pattern as getHfwaByDateRangeResult and
   257	// getTimeOffRequestResult.
   258	async function loadScheduleResult(uid) {
   259	  if (!_ready) return { ok: false, schedule: null };
   260	  try {
   261	    const doc = await _db.collection('timeclock_schedules').doc(uid).get();
   262	    // The PATH is the identity — a stored `uid` field never overrides it (Phase 4 review: a mismatched stored
   263	    // value would have redirected a toggle's transaction and the job's claim to a different document).
   264	    return { ok: true, schedule: doc.exists ? { ...doc.data(), uid } : null };
   265	  } catch (err) {
   266	    console.error('Failed to load schedule:', err);
   267	    return { ok: false, schedule: null };
   268	  }
   269	}
   270	
   271	// Unchanged contract for existing callers: the schedule, or null for both absent and failed.
   272	async function loadSchedule(uid) {
   273	  const { schedule } = await loadScheduleResult(uid);
   274	  return schedule;
   275	}
   276	
   277	async function loadAllSchedules() {
   278	  if (!_ready) return [];
   279	  try {
   280	    const snap = await _db.collection('timeclock_schedules').get();
   281	    return snap.docs.map(d => ({ ...d.data(), uid: d.id }));   // path identity wins over a stored `uid` (Phase 4 review)
   282	  } catch (err) {
   283	    console.error('Failed to load schedules:', err);
   284	    return [];
   285	  }
   286	}
   287	
   288	async function saveSchedule(uid, scheduleData) {
   289	  if (!_ready) return false;
   290	  try {
   291	    await _db.collection('timeclock_schedules').doc(uid).set({
   292	      ...scheduleData,
   293	      uid,
   294	      updatedAt: new Date().toISOString(),
   295	      updatedBy: (getAuthUser() || {}).name || 'unknown'
   296	    }, { merge: true });
   297	    return true;
   298	  } catch (err) {
   299	    console.error('Failed to save schedule:', err);
   300	    return false;
   301	  }
   302	}
   303	
   304	// "Notify an employee of a schedule change" plan, Phase 3a: the AI Schedule Changes save. The READ, the
   305	// per-date ROUTING and the WRITE are one transaction: applyScheduleEdits() (js/schedule-helpers.js) runs on
   306	// the document version the transaction will update, so a date is routed by the futureSchedule that is
   307	// there at write time — a plain read-then-update let another manager remove the future schedule in
   308	// between, after which a leaf update recreated a bare `futureSchedule.overrides` with no bounds, masking
   309	// the person's base schedule on every date (implementation review, Sep 17). The write is ONE update() of
   310	// leaf field paths — `overrides.<date>` / `futureSchedule.overrides.<date>` — built from SEGMENTS (a date
   311	// key has dashes) and passed in the VARARGS form (an object keyed by a FieldPath coerces the key to a
   312	// string and writes a top-level field). Leaf replacement: no map is ever written, so nothing stale leaks
   313	// and the empty-map hazard cannot arise; update() creates a missing intermediate map and REFUSES on a
   314	// missing document. Returns { ok, reason?, wrote, before, after, rejected }: `before`/`after` are the
   315	// document as read inside the transaction and as it reads after the write — the exact pair the change
   316	// email should describe. `wrote:false` when nothing valid was left to write (no update is issued, not
   317	// even a stamp).
   318	// `opts` is passed straight through to applyScheduleEdits ({ remind, remindUid } — "48-hour shift
   319	// reminders" plan, Phase 1); omitted, the reminder flag on an edited date is preserved, never set.
   320	async function applyScheduleEditsTransaction(uid, edits, opts) {
   321	  if (!_ready) return { ok: false, reason: 'not-ready' };
   322	  const ref = _db.collection('timeclock_schedules').doc(uid);
   323	  try {
   324	    return await _db.runTransaction(async (tx) => {
   325	      const doc = await tx.get(ref);
   326	      if (!doc.exists) return { ok: false, reason: 'missing' };
   327	      const before = { ...doc.data(), uid };
   328	      const { after, fields, rejected } = applyScheduleEdits(before, edits, opts);
   329	      if (!fields.length) return { ok: true, wrote: false, before, after: before, rejected };
   330	      const FieldPath = firebase.firestore.FieldPath;
   331	      const args = [];
   332	      for (const [segments, value] of fields) args.push(new FieldPath(...segments), value);
   333	      args.push(new FieldPath('updatedAt'), new Date().toISOString());
   334	      args.push(new FieldPath('updatedBy'), (getAuthUser() || {}).name || 'unknown');
   335	      tx.update(ref, ...args);
   336	      return { ok: true, wrote: true, before, after, rejected };
   337	    });
   338	  } catch (err) {
   339	    console.error('Failed to apply schedule edits:', err);
   340	    return { ok: false, reason: 'error' };
   341	  }
   342	}
   343	
   344	// "48-hour shift reminders" plan, Phase 4: the Reminders view's toggles for ONE schedule document, as ONE
   345	// transaction modelled on applyScheduleEditsTransaction above. planReminderToggles() (js/schedule-helpers.js)
   346	// runs on the document version the transaction will update: each toggled date is routed by the future
   347	// window as it is NOW, must still hold a non-null map with start and end at that path, and is otherwise
   348	// SKIPPED and named — never recreated. A bare read-then-leaf-update could turn a date another manager just
   349	// removed into a phantom `{ remind: true }` "shift", or recreate a bounds-less futureSchedule (design
   350	// review). Leaf FieldPaths only (`overrides.<date>.remind`, varargs form — see above); a delete sentinel
   351	// for an untick. Returns { ok, wrote, applied: [date], skipped: [{ date, reason }] }; `wrote:false` when
   352	// every toggle already held (no stamp-only write).
   353	async function toggleShiftRemindersTransaction(uid, toggles, remindUid) {
   354	  if (!_ready) return { ok: false, reason: 'not-ready' };
   355	  const ref = _db.collection('timeclock_schedules').doc(uid);
   356	  try {
   357	    return await _db.runTransaction(async (tx) => {
   358	      const doc = await tx.get(ref);
   359	      if (!doc.exists) return { ok: false, reason: 'missing' };
   360	      const current = { ...doc.data(), uid };
   361	      const { fields, applied, skipped } = planReminderToggles(current, toggles, {
   362	        remindUid, deleteSentinel: firebase.firestore.FieldValue.delete(),
   363	      });
   364	      if (!fields.length) return { ok: true, wrote: false, applied, skipped };
   365	      const FieldPath = firebase.firestore.FieldPath;
   366	      const args = [];
   367	      for (const [segments, value] of fields) args.push(new FieldPath(...segments), value);
   368	      args.push(new FieldPath('updatedAt'), new Date().toISOString());
   369	      args.push(new FieldPath('updatedBy'), (getAuthUser() || {}).name || 'unknown');
   370	      tx.update(ref, ...args);
   371	      return { ok: true, wrote: true, applied, skipped };
   372	    });
   373	  } catch (err) {
   374	    console.error('Failed to toggle shift reminders:', err);
   375	    return { ok: false, reason: 'error' };
   376	  }
   377	}
   378	
   379	// The reminder job's log (timeclock_reminder_log — one claim per schedule document + date), from `fromDate`
   380	// on, for the Reminders view's status column. { ok, logs }: a FAILED read is distinct from "nothing sent
   381	// yet" — the view must say the log could not be loaded rather than show every reminder as unsent.
   382	async function loadReminderLogResult(fromDate) {
   383	  if (!_ready) return { ok: false, logs: [] };
   384	  try {
   385	    const snap = await _db.collection('timeclock_reminder_log').where('date', '>=', fromDate).get();
   386	    return { ok: true, logs: snap.docs.map(d => ({ id: d.id, ...d.data() })) };
   387	  } catch (err) {
   388	    console.error('Failed to load the reminder log:', err);
   389	    return { ok: false, logs: [] };
   390	  }
   391	}
   392	
   393	// Phase 5: awaited — its caller already awaited a value that was never a real result.
   394	async function deleteSchedule(uid) {
   395	  if (!_ready) return false;
   396	  try {
   397	    await _db.collection('timeclock_schedules').doc(uid).delete();
   398	    return true;
   399	  } catch (err) {
   400	    console.error('Failed to delete schedule:', err);
   401	    return false;
   402	  }
   403	}
   404	
   405	// ─── Users (for employee picker) ─────────────────────
   406	
   407	// { ok, users }: a failed read is distinguishable from "no users" (notify plan, Phase 3b — the email
   408	// recipient lookup must say "could not look up" rather than "no email on file" after a failed read).
   409	async function loadAllUsersResult() {
   410	  if (!_ready) return { ok: false, users: [] };
   411	  try {
   412	    const snap = await _db.collection('users').get();
   413	    return { ok: true, users: snap.docs.map(d => ({ ...d.data(), uid: d.id })) };   // path identity wins
   414	  } catch (err) {
   415	    console.error('Failed to load users:', err);
   416	    return { ok: false, users: [] };
   417	  }
   418	}
   419	
   420	// Unchanged contract for existing callers: the list, or [] for both empty and failed.
   421	async function loadAllUsers() {
   422	  const { users } = await loadAllUsersResult();
   423	  return users;
   424	}
   425	
   426	// ─── Employee Roster ─────────────────────────────────
   427	// Pre-seeded roster stored in timeclock_settings/employees
   428	// Each entry: { id, name, claimedBy, active }
   429	
   430	// { ok, roster }. A FAILED read is distinct from an empty roster — the retry path resolves which schedule
   575	}
   576	
   577	// Phase 5: awaited.
   578	async function saveSettings(settings) {
   579	  if (!_ready) return false;
   580	  try {
   581	    await _db.collection('timeclock_settings').doc('appConfig').set({
   582	      ...settings,
   583	      lastUpdated: new Date().toISOString()
   584	    });
   585	    return true;
   586	  } catch (err) {
   587	    console.error('Failed to save settings:', err);
   588	    return false;
   589	  }
   590	}
   591	
   592	// ─── HFWA Sick Leave ─────────────────────────────────
   593	
   594	async function addHfwaEntry(entry) {
   595	  if (!_ready) return null;
   596	  try {
   597	    const ref = _db.collection('timeclock_hfwa').doc();
   598	    await ref.set({
   599	      ...entry,
   600	      submittedAt: firebase.firestore.FieldValue.serverTimestamp()
   601	    });
   602	    return ref.id;
   603	  } catch (err) {
   604	    console.error('Failed to add HFWA entry:', err);
   605	    return null;
   606	  }
   607	}
   608	
   609	// Returns { ok, entries }. `ok: false` means the read FAILED — which is not the same as a year with no
   610	// submissions, and callers that show the result to a human need to tell those two apart. A failed read
   611	// rendered as "nothing here" is this codebase's classic data-loss lookalike (see CLAUDE.md).
   612	async function getHfwaByDateRangeResult(startDate, endDate, uid) {
   613	  if (!_ready) return { ok: false, entries: [] };
   614	  try {
   615	    let query = _db.collection('timeclock_hfwa')
   616	      .where('date', '>=', startDate)
   617	      .where('date', '<=', endDate)
   618	      .orderBy('date', 'asc');
   619	    if (uid) query = query.where('uid', '==', uid);
   620	    const snap = await query.get();
   621	    return { ok: true, entries: snap.docs.map(d => ({ id: d.id, ...d.data() })) };
   622	  } catch (err) {
   623	    console.error('Failed to get HFWA entries:', err);
   624	    return { ok: false, entries: [] };
   625	  }
   626	}
   627	
   628	// Unchanged contract for existing callers: the entries, or [] if the read failed.
   629	async function getHfwaByDateRange(startDate, endDate, uid) {
   630	  const { entries } = await getHfwaByDateRangeResult(startDate, endDate, uid);
   631	  return entries;
   632	}
   633	
   634	// A staff member's own submissions. This is a COMPOSITE query (uid == … + orderBy date), so it needs the
   635	// timeclock_hfwa uid+date index — and until Sep 23 2026 that index did not exist, so the query threw
   636	// `failed-precondition`, the catch returned [], and the card rendered "No submissions yet". A real
   637	// submission looked like no submission: this codebase's classic data-loss lookalike (see CLAUDE.md), and
   638	// the same reason getHfwaByDateRangeResult beside this one reports { ok }. Now this one does too.
   639	async function getMyHfwaEntriesResult(uid) {
   640	  if (!_ready) return { ok: false, entries: [] };
   641	  try {
   642	    const snap = await _db.collection('timeclock_hfwa')
   643	      .where('uid', '==', uid)
   644	      .orderBy('date', 'desc')
   645	      .limit(20)
   646	      .get();
   647	    return { ok: true, entries: snap.docs.map(d => ({ id: d.id, ...d.data() })) };
   648	  } catch (err) {
   649	    console.error('Failed to get my HFWA entries:', err);
   650	    return { ok: false, entries: [] };
   651	  }
   652	}
   653	
   654	// Unchanged contract for any existing caller: the entries, or [] if the read failed.
   655	async function getMyHfwaEntries(uid) {
   656	  const { entries } = await getMyHfwaEntriesResult(uid);
   657	  return entries;
   658	}
   659	
   660	// ─── Recent Entries (for change requests) ────────────
   661	
   662	async function getRecentEntries(uid, days) {
   663	  if (!_ready) return [];
   664	  const now = new Date();
   665	  const startDate = new Date(now);
   666	  startDate.setDate(startDate.getDate() - (days || 7));
   667	  const startStr = startDate.getFullYear() + '-' +
   668	    String(startDate.getMonth() + 1).padStart(2, '0') + '-' +
   669	    String(startDate.getDate()).padStart(2, '0');
   670	  try {
   671	    const snap = await _db.collection('timeclock_entries')
   672	      .where('uid', '==', uid)
   673	      .where('date', '>=', startStr)
   674	      .orderBy('date', 'desc')
   675	      .orderBy('timestamp', 'desc')
   676	      .get();
   677	    return snap.docs.map(d => ({ id: d.id, ...d.data() }));
   678	  } catch (err) {
   679	    console.error('Failed to get recent entries:', err);
   680	    return [];
   681	  }
   682	}
   683	
   684	// ─── Time Off Requests ──────────────────────────────
   685	
   686	async function addTimeOffRequest(request) {
   687	  if (!_ready) return null;
   688	  try {
   689	    const ref = _db.collection('timeclock_timeoff').doc();
   690	    await ref.set({
   691	      ...request,
   692	      submittedAt: firebase.firestore.FieldValue.serverTimestamp(),
   693	      updatedAt: firebase.firestore.FieldValue.serverTimestamp()
   694	    });
   695	    return ref.id;
   696	  } catch (err) {
   697	    console.error('Failed to add time off request:', err);
   698	    return null;
   699	  }
   700	}
   701	
   702	async function getMyTimeOffRequests(uid) {
   703	  if (!_ready) return [];
   704	  try {
   705	    const snap = await _db.collection('timeclock_timeoff')
   706	      .where('uid', '==', uid)
   707	      .orderBy('submittedAt', 'desc')
   708	      .get();
   709	    return snap.docs.map(d => ({ id: d.id, ...d.data() }));
   710	  } catch (err) {
   711	    console.error('Failed to get my time off requests:', err);
   712	    return [];
   713	  }
   714	}
   715	
   716	async function getAllTimeOffRequests() {
   717	  if (!_ready) return [];
   718	  try {
   719	    const snap = await _db.collection('timeclock_timeoff')
   720	      .orderBy('submittedAt', 'desc')
   721	      .get();
   722	    return snap.docs.map(d => ({ id: d.id, ...d.data() }));
   723	  } catch (err) {
   724	    console.error('Failed to get all time off requests:', err);
   725	    return [];
   726	  }
   727	}
   728	
   729	// Requests needing a manager: awaiting review, PLUS any carrying reversalPending whatever its status
   730	// (Phase 3b). Two queries rather than one: the marker query is a single-field equality with no orderBy,
   731	// so it needs no composite index; the two are merged by id and sorted client-side.
   732	async function getPendingTimeOffRequests() {
   733	  if (!_ready) return [];
   734	  try {
   735	    // allSettled, not all: if the newer marker query fails (a rules change, say), the awaiting-review
   736	    // list must still render — degrade to the old behaviour, never to an empty dashboard.
   737	    const [byStatus, byMarker] = await Promise.allSettled([
   738	      _db.collection('timeclock_timeoff').where('status', 'in', ['submitted', 'under_review']).orderBy('submittedAt', 'asc').get(),
   739	      _db.collection('timeclock_timeoff').where('reversalPending', '==', true).get(),
   740	    ]);
   741	    if (byStatus.status === 'rejected') throw byStatus.reason;
   742	    if (byMarker.status === 'rejected') console.error('Failed to get flagged time off requests:', byMarker.reason);
   743	    const docs = [...byStatus.value.docs, ...(byMarker.status === 'fulfilled' ? byMarker.value.docs : [])];
   744	    return mergePendingTimeOff(docs.map(d => ({ id: d.id, ...d.data() })));
   745	  } catch (err) {
   746	    console.error('Failed to get pending time off requests:', err);
   747	    return [];
   748	  }
   749	}
   750	
   940	function getWeekday() {
   941	  return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][new Date().getDay()];
   942	}

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '6758,6792p'; nl -ba js/app.js | sed -n '6940,6972p'; nl -ba js/app.js | sed -n '7860,7925p'; nl -ba js/app.js | sed -n '8775,8885p'; rg -n \"await (addClockEntry|updateClockEntry|deleteClockEntry|saveSchedule|deleteSchedule|saveEmployeeRoster|migrateSchedule|saveSettings|addHfwaEntry|addTimeOffRequest|updateTimeOffRequest|saveStreakData)\\b|void (addClockEntry|updateClockEntry|deleteClockEntry|saveSchedule|deleteSchedule|saveEmployeeRoster|migrateSchedule|saveSettings|addHfwaEntry|addTimeOffRequest|updateTimeOffRequest|saveStreakData)\\b\" js/app.js" in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
  6758	    alert('Invalid selection.');
  6759	    return;
  6760	  }
  6761	  confirmAssignUser(empId, available[idx - 1].uid);
  6762	}
  6763	
  6764	async function confirmAssignUser(empId, uid) {
  6765	  try {
  6766	    const freshRoster = await loadEmployeeRoster();
  6767	    const emp = freshRoster.find(e => e.id === empId);
  6768	    if (!emp) { showToast('Employee not found.'); return; }
  6769	    if (emp.claimedBy) { showToast('Already claimed — refresh the page.'); return; }
  6770	    emp.claimedBy = uid;
  6771	    await saveEmployeeRoster(freshRoster);
  6772	    await migrateSchedule(empId, uid);
  6773	    employeeRoster = freshRoster;
  6774	    showToast(`Assigned — ${emp.name} linked to account.`);
  6775	    renderRosterList();
  6776	  } catch (err) {
  6777	    console.error('Assign user failed:', err);
  6778	    showToast('Failed to assign user — see console.');
  6779	  }
  6780	}
  6781	
  6782	// ═══════════════════════════════════════════════════════
  6783	// TIME OFF TAB
  6784	// ═══════════════════════════════════════════════════════
  6785	
  6786	let timeoffFormDates = [];    // [{date, type, partialStart, partialEnd, flexible}]
  6787	let timeoffFormSubs = [];     // [{name, dates}]
  6788	// What an EDIT form opened with (plan: ticker-sub-confirm-only-by-manager). The form cannot confirm anyone,
  6789	// so at save these decide whether the form is out of date (checkEditAgainstDocument). null until an edit loads.
  6790	let openedSubs = null;        // name -> { confirmed, hasRecord, entry }
  6791	let openedDates = null;       // normalizeRequestDates(document dates) — never timeoffFormDates, whose rows are edited in place
  6792	let allTimeoffRequests = [];  // cached for admin
  6940	}
  6941	
  6942	// ─── Admin: All Requests (combined view) ────────────
  6943	
  6944	function isTimeOffPast(r) {
  6945	  if (!r.dates || !r.dates.length) return false;
  6946	  const today = new Date().toISOString().slice(0, 10);
  6947	  return r.dates.every(d => d.date < today);
  6948	}
  6949	
  6950	async function autoCompletePassedTimeOff() {
  6951	  const toComplete = allTimeoffRequests.filter(r =>
  6952	    r.status === 'approved' && isTimeOffPast(r) && !r.reversalPending   // Phase 3b: keep it actionable
  6953	  );
  6954	  for (const r of toComplete) {
  6955	    await updateTimeOffRequest(r.id, {
  6956	      status: 'completed',
  6957	      completedAt: new Date().toISOString()
  6958	    });
  6959	    r.status = 'completed';
  6960	    r.completedAt = new Date().toISOString();
  6961	  }
  6962	}
  6963	
  6964	// A request needs a manager's attention if it is awaiting review OR its schedule reversal never landed
  6965	// (Phase 3b). The second half is what makes "manager completes it" real: a staff member's withdrawal of
  6966	// an approved request lands as reversalPending, and without this it sat under the Past filter where
  6967	// nobody looks. One predicate, used by the filter, the badge count, and the dashboard.
  6968	function timeOffNeedsAction(r) {
  6969	  return ['submitted', 'under_review'].includes(r.status) || !!r.reversalPending;
  6970	}
  6971	
  6972	// From the dashboard's pending list: switch to the tab under Needs Action (so the request is in the list
  7860	    console.error('Failed to load request for edit:', err);
  7861	    alert('Failed to load request. Please try again.');
  7862	  }
  7863	}
  7864	
  7865	// ─── Comment ────────────────────────────────────────
  7866	
  7867	// Appends one comment by the current user to a request (Phase 4: a durable trace for a hand-off, next to
  7868	// the push that may not arrive). Same entry shape as addTimeOffComment. Returns true if it landed.
  7869	async function appendTimeOffComment(requestId, text) {
  7870	  // arrayUnion: an atomic append, so a comment landing from another tab at the same moment is not lost
  7871	  // (review finding on the read→whole-array write the older comment path uses).
  7872	  return updateTimeOffRequest(requestId, { comments: firebase.firestore.FieldValue.arrayUnion({
  7873	    by: currentUser.name || currentUser.email, uid: currentUser.uid, role: currentUser.role || 'staff', text, at: new Date().toISOString(),
  7874	  }) });
  7875	}
  7876	
  7877	async function addTimeOffComment(requestId) {
  7878	  const input = document.getElementById('timeoff-comment-input');
  7879	  const text = (input ? input.value : '').trim();
  7880	  if (!text) return;
  7881	
  7882	  try {
  7883	    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
  7884	    if (!doc.exists) return;
  7885	    const data = doc.data();
  7886	    const comments = data.comments || [];
  7887	    const isAdminComment = currentUser.role === 'admin' || currentUser.role === 'manager';
  7888	    comments.push({
  7889	      by: currentUser.name || currentUser.email,
  7890	      uid: currentUser.uid,
  7891	      role: currentUser.role || 'staff',
  7892	      text,
  7893	      at: new Date().toISOString()
  7894	    });
  7895	    await updateTimeOffRequest(requestId, { comments });
  7896	
  7897	    // Push: admin comment → notify staff owner; staff comment → notify all admins.
  7898	    // Also email — push notifications aren't reliably reaching people, so this is the more dependable
  7899	    // channel now. Same routing as the submission email: admin comment → the requester directly; staff
  7900	    // comment (only the owner or an admin can even reach this detail view, so this is the owner adding
  7901	    // more context) → the studio coordinator(s) for this request + Anika.
  7902	    if (isAdminComment && data.uid && data.uid !== currentUser.uid) {
  7903	      sendPushToUser(data.uid, 'Comment on Your Time Off Request', `${currentUser.name || 'Admin'}: ${text}`);
  7904	      // Requester-only, nobody cc'd — so the admin gets told whether it went out.
  7905	      sendTimeOffCommentEmail({
  7906	        commenterName: currentUser.name || currentUser.email || 'Admin',
  7907	        commentText: text, requesterName: data.name, isAdminComment: true, requesterEmail: data.email,
  7908	      }, data.name || 'the requester');
  7909	    } else if (!isAdminComment) {
  7910	      sendPushToAllAdmins('New Comment on Time Off Request', `${currentUser.name || 'Staff'}: ${text}`);
  7911	      sendTimeOffCommentEmail({
  7912	        commenterName: currentUser.name || currentUser.email || 'Staff',
  7913	        commentText: text, requesterName: data.name, isAdminComment: false, studios: data.requestStudios,
  7914	      });
  7915	    }
  7916	
  7917	    openTimeOffDetail(requestId); // refresh
  7918	  } catch (err) {
  7919	    console.error('Failed to add comment:', err);
  7920	  }
  7921	}
  7922	
  7923	// ─── Sub Confirmation + Auto-Assignment (Plan 2, Phase 3) ─────────
  7924	
  7925	let _confirmSubCtx = null; // tracks requestId/subIndex/dates/uids for the confirm-sub modal flow
  8775	      document.getElementById('timeoff-detail-modal').classList.remove('open');
  8776	      alert('Request withdrawn. Your time off is still on the schedule for now — a manager has been notified and will finish removing it.');
  8777	    }
  8778	  } catch (err) {
  8779	    console.error('Failed to withdraw:', err);
  8780	    alert('Failed to withdraw request.');
  8781	  }
  8782	}
  8783	
  8784	async function completeTimeOff(requestId) {
  8785	  if (!confirm('Mark this time off as completed? (Use this after the time off dates have passed.)')) return;
  8786	
  8787	  await updateTimeOffRequest(requestId, {
  8788	    status: 'completed',
  8789	    completedAt: new Date().toISOString()
  8790	  });
  8791	
  8792	  allTimeoffRequests = await getAllTimeOffRequests();
  8793	  renderAdminAllTimeOff();
  8794	  renderAdminAllTimeOff();
  8795	  openTimeOffDetail(requestId);
  8796	  showToast('Marked complete');
  8797	}
  8798	
  8799	// Shares the in-flight guard with approveTimeOff, for a smaller reason: running this twice cannot corrupt
  8800	// the record the way a double approval can — removeTimeOffOverrides() is idempotent for a fixed record,
  8801	// and the Object.keys() check below short-circuits once appliedOverrides is nulled. What a second run DOES
  8802	// do is send the employee a duplicate "returned to under review" push. Same dead-UI trigger, same guard.
  8803	//
  8804	// Phase 3a (Sep 11 2026) closed the other bug this function carried: removeTimeOffOverrides() now
  8805	// reports its result, and the appliedOverrides: null write goes through reversalPatch(), which only
  8806	// clears on success and marks reversalPending otherwise. The status change still proceeds either way.
  8807	async function unapproveTimeOff(requestId, btn) {
  8808	  if (_timeoffActionInFlight.has(requestId)) return;
  8809	  if (!confirm('Return this request to Under Review? Any schedule overrides from approval will be removed.')) return;
  8810	
  8811	  _timeoffActionInFlight.add(requestId);
  8812	  const btnLabel = btn ? btn.textContent : null;
  8813	  if (btn) { btn.disabled = true; btn.textContent = 'Working...'; }
  8814	
  8815	  try {
  8816	    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
  8817	    if (!doc.exists) return;
  8818	    const data = doc.data();
  8819	
  8820	    // Remove applied overrides if any (from a prior approval). Phase 3: the result decides whether the
  8821	    // record is cleared — never clear what did not land.
  8822	    let reversal = { ok: true };
  8823	    if (data.appliedOverrides && Object.keys(data.appliedOverrides).length) {
  8824	      reversal = await removeTimeOffOverrides(data.uid, data.appliedOverrides);
  8825	    }
  8826	
  8827	    // Same gate as confirmDenyTimeOff: a status change that did not land must not be announced.
  8828	    const wrote = await updateTimeOffRequest(requestId, {
  8829	      status: 'under_review',
  8830	      reviewAction: null,
  8831	      denialReason: null,
  8832	      completedAt: null,
  8833	      ...reversalPatch(reversal),
  8834	    });
  8835	    if (!wrote) {
  8836	      alert('Failed to return the request to review — the status was not changed and nobody was notified. Please try again.');
  8837	      return;
  8838	    }
  8839	
  8840	    allTimeoffRequests = await getAllTimeOffRequests();
  8841	    renderAdminAllTimeOff();
  8842	    openTimeOffDetail(requestId);
  8843	    if (data.uid) sendPushToUser(data.uid, 'Time Off Update', 'Your time off request has been returned to under review.');
  8844	    if (reversal.ok) showToast('Returned to under review' + skippedDatesNote(reversal));
  8845	    else alert('Returned to under review, BUT ' + reversalFailureMessage(data.name || 'this person', reversal.reason));
  8846	    // previousStatus drives the wording: this button is offered on BOTH approved and denied requests, and
  8847	    // "no longer approved" is false — and the opposite of the news — when it was denied a minute ago.
  8848	    sendTimeOffStatusEmail({
  8849	      status: 'under_review', previousStatus: data.status, reversalPending: !reversal.ok, reversalReason: reversal.reason,
  8850	      requesterEmail: resolveRequesterEmail(data), requesterName: data.name, dates: data.dates, reason: data.reason,
  8851	      reviewedBy: currentUser.name || currentUser.email, studios: resolveRequesterStudios(data),
  8852	    });
  8853	  } catch (err) {
  8854	    console.error('Failed to unapprove:', err);
  8855	    alert('Failed to return request to review.');
  8856	  } finally {
  8857	    _timeoffActionInFlight.delete(requestId);
  8858	    if (btn && btn.isConnected) { btn.disabled = false; btn.textContent = btnLabel; }
  8859	  }
  8860	}
  8861	
  8862	async function reopenTimeOff(requestId) {
  8863	  await updateTimeOffRequest(requestId, {
  8864	    status: 'approved',
  8865	    completedAt: null
  8866	  });
  8867	
  8868	  allTimeoffRequests = await getAllTimeOffRequests();
  8869	  renderAdminAllTimeOff();
  8870	  renderAdminAllTimeOff();
  8871	  openTimeOffDetail(requestId);
  8872	  showToast('Reopened as approved');
  8873	}
  8874	
  8875	// ─── Schedule Integration ───────────────────────────
  8876	
  8877	// The time-off schedule orchestration lives in js/timeoff-schedule.js (see its header for why). These are
  8878	// thin wrappers with the SAME names and signatures, so the eight external call sites did not change
  8879	// (approveTimeOff's own two calls now go through the module directly). They stay `async function`
  8880	// declarations rather than `const`s so hoisting and the global-scope binding are identical to before.
  8881	//
  8882	// Deps are built PER CALL, never at parse time: firebase.firestore.FieldValue and the data-layer `_ready`
  8883	// flag are not guaranteed to exist when this file is first evaluated, and capturing them eagerly would
  8884	// throw on load. Each function gets only the deps it uses. (The sentinel IS created at wrapper entry
  8885	// rather than inside the delete branch as before — a marginally earlier throw path that can only fire if
652:    await saveStreakData(updates);
675:  const id = await addClockEntry(entry);
704:  const id = await addClockEntry(entry);
740:  const id = await addClockEntry(entry);
770:  const id = await addClockEntry(entry);
799:  const id = await addClockEntry(entry);
1192:  const success = await updateClockEntry(crTargetEntryId, {
1271:    success = await addClockEntry({
1311:    success = await addClockEntry(entry);
1690:    if (await saveStreakData(streak)) {
1750:    if (await saveStreakData(streak)) {
2556:    ok = await updateClockEntry(entryId, updates);
2589:  const ok = await deleteClockEntry(entryId);
2625:  const id = await addClockEntry(entry);
2760:  const success = await updateClockEntry(entryId, updates);
4039:    success = await saveSchedule(editingScheduleUid, scheduleData);
4443:  const success = await deleteSchedule(uid);
4595:  const id = await addHfwaEntry(entry);
5624:  const success = await saveSettings(settings);
5972:    await saveEmployeeRoster(employeeRoster);
5973:    await migrateSchedule(match.id, currentUser.uid);
6056:  const saved = await saveEmployeeRoster(freshRoster);
6066:  await migrateSchedule(empId, currentUser.uid);
6139:    const success = await saveEmployeeRoster(roster);
6184:  const success = await saveEmployeeRoster(employeeRoster);
6654:    if (!(await saveEmployeeRoster(employeeRoster))) {
6727:    await saveEmployeeRoster(freshRoster);
6771:    await saveEmployeeRoster(freshRoster);
6772:    await migrateSchedule(empId, uid);
6955:    await updateTimeOffRequest(r.id, {
7576:      success = await updateTimeOffRequest(editingTimeOffId, formData);
7599:    success = await addTimeOffRequest(request);
7895:    await updateTimeOffRequest(requestId, { comments });
8190:    const saveOk = await saveSchedule(ctx.subUid, { overrides: payload });
8454:      result = { success: await updateTimeOffRequest(requestId, { coverageStatus: status }) };
8471:    result = { success: await updateTimeOffRequest(requestId, { coverageStatus: status }) };
8681:  const wrote = await updateTimeOffRequest(requestId, {
8745:    const wrote = await updateTimeOffRequest(requestId, {
8787:  await updateTimeOffRequest(requestId, {
8828:    const wrote = await updateTimeOffRequest(requestId, {
8863:  await updateTimeOffRequest(requestId, {
9953:      void updateClockEntry(entryRef.id, {
10370:        void updateClockEntry(outRef.id, {
10577:        await updateClockEntry(entryId, { clockOutStreakAfter: restoredOutStreak });
10614:        await updateClockEntry(entryId, { clockInStreakAfter: restoredInStreak });

exec
/bin/zsh -lc "rg -n \"schedule-helpers|firebase-data|app\\.js\" index.html; nl -ba js/firebase-config.js | sed -n '1,180p' 2>/dev/null || true; rg -n \"enableOfflinePersistence\" -S . --glob '"'!node_modules/**'"'; nl -ba /Users/christiehubley/payroll-tool/index.html | sed -n '2960,3055p'; nl -ba /Users/christiehubley/studio-hub/firestore.rules | sed -n '1,260p' | rg -n \"timeclock_entries|timeclock_settings|manager|admin\" -C 5" in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
1154:  <script src="js/firebase-data.js"></script>
1156:  <script src="js/schedule-helpers.js"></script>
1158:  <script src="js/app.js"></script>
     1	// =====================================================
     2	// Shared Firebase Config — Tinker HQ Apps
     3	// =====================================================
     4	// Copy this file into any app that needs Firebase.
     5	// Load AFTER the Firebase SDK scripts in your HTML.
     6	
     7	const FIREBASE_CONFIG = {
     8	  apiKey: "AIzaSyByDujAwE7SkKwML52MBIf5kwQfVbX_86s",
     9	  authDomain: "tinker-hq-apps.firebaseapp.com",
    10	  projectId: "tinker-hq-apps",
    11	  storageBucket: "tinker-hq-apps.firebasestorage.app",
    12	  messagingSenderId: "929945075847",
    13	  appId: "1:929945075847:web:cdcfee87ad9ce402fcb822"
    14	};
    15	
    16	function initFirebaseApp() {
    17	  if (typeof firebase === 'undefined') {
    18	    console.warn('Firebase SDK not loaded');
    19	    return null;
    20	  }
    21	  if (!firebase.apps.length) {
    22	    firebase.initializeApp(FIREBASE_CONFIG);
    23	  }
    24	  return firebase.firestore();
    25	}
    26	
    27	// Call once at app startup — resolves when offline persistence is ready
    28	async function enableOfflinePersistence(db) {
    29	  try {
    30	    await db.enablePersistence({ synchronizeTabs: true });
    31	  } catch (err) {
    32	    if (err.code === 'failed-precondition') {
    33	      console.warn('Firestore persistence: multiple tabs open');
    34	    } else if (err.code === 'unimplemented') {
    35	      console.warn('Firestore persistence: browser not supported');
    36	    }
    37	  }
    38	}
./pay-period-lock.emulator.test.js:56:    enableOfflinePersistence: async () => {},
./firebase-data.failure.test.js:32:    enableOfflinePersistence: async () => {},
./reminder-toggle.emulator.test.js:40:    enableOfflinePersistence: async () => {},
./js/firebase-data.js:17:      await enableOfflinePersistence(_db);
./js/firebase-config.js:28:async function enableOfflinePersistence(db) {
  2960	      ? '<span class="badge badge-warning">Unmatched</span>'
  2961	      : configEmp.archived
  2962	        ? '<span class="badge badge-warning">Archived</span>'
  2963	        : m.provisional
  2964	          ? '<span class="badge badge-success">Matched</span> <span class="badge badge-warning" title="Matched by name only — Link in Settings to make it exact">by name</span>'
  2965	          : '<span class="badge badge-success">Matched</span>';
  2966	    return `<tr>
  2967	      <td><strong>${emp.fullName}</strong></td>
  2968	      <td class="mono">${emp.totalHours.toFixed(2)}</td>
  2969	      <td class="mono">${emp.regular.toFixed(2)}</td>
  2970	      <td class="mono">${emp.overtime > 0 ? emp.overtime.toFixed(2) : '-'}</td>
  2971	      <td>${status}</td>
  2972	    </tr>`;
  2973	  }).join('');
  2974	}
  2975	
  2976	/* ============================================================
  2977	   PULL FROM TIMECLOCK
  2978	   ============================================================ */
  2979	
  2980	async function pullFromTimeclock() {
  2981	  // Check that a pay period is set
  2982	  if (!APP_STATE.payPeriod || !APP_STATE.payPeriod.start || !APP_STATE.payPeriod.end) {
  2983	    alert('Please set your pay period dates first (on the Dashboard tab), then come back here.');
  2984	    return;
  2985	  }
  2986	
  2987	  const db = getFirestore();
  2988	  if (!db) {
  2989	    alert('Firebase not initialized. Please refresh the page.');
  2990	    return;
  2991	  }
  2992	
  2993	  // Re-pull: recompute from current settings. Ask BEFORE fetching anything;
  2994	  // "No" leaves everything untouched.
  2995	  if (APP_STATE.reviewData) {
  2996	    if (!confirm('Re-pulling recomputes allocations from the current settings and discards manual Review adjustments.\n\nTips, HFWA entries, Camp Pay and private-event toggles are kept.\n\nContinue?')) return;
  2997	  }
  2998	  // Nothing in APP_STATE is touched until the fetch has succeeded (step 6 below);
  2999	  // a failed read leaves the previous review intact. Derived allocation inputs
  3000	  // are rebuilt from scratch into these locals (they used to accumulate by name).
  3001	  const newDayCounts = {};
  3002	  const newDayHours = {};
  3003	
  3004	  const statusEl = document.getElementById('timeclockPullStatus');
  3005	  const zone = document.getElementById('timeclockPullZone');
  3006	  statusEl.classList.remove('hidden');
  3007	  statusEl.innerHTML = '<div class="alert alert-info"><span class="alert-icon">&#9203;</span><div>Pulling timeclock data for ' + APP_STATE.payPeriod.start + ' to ' + APP_STATE.payPeriod.end + '...</div></div>';
  3008	
  3009	  try {
  3010	    // 1. Read clock entries for the pay period
  3011	    const entriesSnap = await db.collection('timeclock_entries')
  3012	      .where('date', '>=', APP_STATE.payPeriod.start)
  3013	      .where('date', '<=', APP_STATE.payPeriod.end)
  3014	      .orderBy('date', 'asc')
  3015	      .orderBy('timestamp', 'asc')
  3016	      .get();
  3017	
  3018	    const allEntries = entriesSnap.docs.map(d => ({ id: d.id, ...d.data() }));
  3019	
  3020	    // 2. Read HFWA submissions for the pay period
  3021	    const hfwaSnap = await db.collection('timeclock_hfwa')
  3022	      .where('date', '>=', APP_STATE.payPeriod.start)
  3023	      .where('date', '<=', APP_STATE.payPeriod.end)
  3024	      .orderBy('date', 'asc')
  3025	      .get();
  3026	
  3027	    const hfwaEntries = hfwaSnap.docs.map(d => ({ id: d.id, ...d.data() }));
  3028	
  3029	    // 3. Fetch roster + locked period totals
  3030	    const [rosterSnap, lockedPeriodsSnap] = await Promise.all([
  3031	      db.collection('timeclock_settings').doc('employees').get(),
  3032	      db.collection('timeclock_settings').doc('lockedPeriods').get()
  3033	    ]);
  3034	    const roster = (rosterSnap.exists && rosterSnap.data().roster) ? rosterSnap.data().roster : [];
  3035	    const periodKey = APP_STATE.payPeriod.start + '_' + APP_STATE.payPeriod.end;
  3036	    const lockedPeriodData = lockedPeriodsSnap.exists ? (lockedPeriodsSnap.data()[periodKey] || null) : null;
  3037	    const lockedEmployeeTotals = lockedPeriodData && lockedPeriodData.employeeTotals ? lockedPeriodData.employeeTotals : null;
  3038	
  3039	    // 4. Group clock entries by uid
  3040	    const byUid = {};
  3041	    allEntries.forEach(e => {
  3042	      if (!byUid[e.uid]) byUid[e.uid] = { name: e.name, entries: [] };
  3043	      byUid[e.uid].entries.push(e);
  3044	    });
  3045	
  3046	    // Merge emp_ temp-ID entries into their claimed user's group (same logic as Tinker Ticker timesheets)
  3047	    roster.forEach(emp => {
  3048	      if (emp.claimedBy && byUid[emp.id]) {
  3049	        if (byUid[emp.claimedBy]) {
  3050	          byUid[emp.claimedBy].entries.push(...byUid[emp.id].entries);
  3051	        } else {
  3052	          byUid[emp.claimedBy] = { name: emp.name || byUid[emp.id].name, entries: byUid[emp.id].entries };
  3053	        }
  3054	        delete byUid[emp.id];
  3055	      }
18-    18	    }
19-    19	
20-    20	    // Archived users (active:false) lose access everywhere this is required —
21-    21	    // missing `active` defaults to true, so existing users need no migration.
22-    22	    // The reminder bot is never an active user, whatever a users doc keyed to its uid might say — so
23:    23	    // even a doc an admin created by hand can never make isAdmin/isManager/hasAppAccess true for it.
24-    24	    function isActiveUser() {
25-    25	      return isAuthenticated() && !isReminderBot() && getUserData().get('active', true) == true;
26-    26	    }
27-    27	
28-    28	    function isAdmin() {
29:    29	      return isAuthenticated() && isActiveUser() && getUserData().role == 'admin';
30-    30	    }
31-    31	
32-    32	    function isManager() {
33:    33	      return isAuthenticated() && isActiveUser() && getUserData().role == 'manager';
34-    34	    }
35-    35	
36-    36	    function isManagerOrAbove() {
37:    37	      return isAuthenticated() && isActiveUser() && getUserData().role in ['admin', 'manager'];
38-    38	    }
39-    39	
40-    40	    function isKiosk() {
41-    41	      return isAuthenticated() && (
42-    42	        request.auth.uid == '06ooFxutK5YTaJvu5SkywY9gZqh2'
--
72-    72	        && appName in data.appAccess;
73-    73	    }
74-    74	
75-    75	    // Studio isolation. Admin always passes. Everyone else must have
76-    76	    // the studio in their studios array. Needs its own explicit isActiveUser()
77:    77	    // check — the non-admin branch doesn't route through isAdmin()/isManager()/
78-    78	    // hasAppAccess() at all, so gating those four alone would miss this one.
79-    79	    function belongsToStudio(studio) {
80-    80	      return isActiveUser() && (isAdmin() || studio in getUserData().studios);
81-    81	    }
82-    82	
--
109-   109	    // ═══════════════════════════════════════════════════════════════
110-   110	
111-   111	    match /users/{userId} {
112-   112	      // My Clay Hub depends on these (Phase E): the clayhub-link functions read each users doc's
113-   113	      // role, active and appAccess to decide who is in my-clay-hub's staffRoster (who can use its
114:   114	      // /staff screens), and store only name and role there. Staff and managers can't change their
115:   115	      // own role, active or appAccess, so they can't put themselves in. An admin can't change their
116-   116	      // own active; they can edit their own role and appAccess, but that never gives them more
117:   117	      // My Clay Hub access than an admin already has (it keeps it or removes it). name is
118-   118	      // self-editable and display-only there. Pinned by rules.test.js "Users — fields My Clay Hub
119-   119	      // relies on"; loosening any of this changes who is staff in My Clay Hub too.
120-   120	      // Own doc read — all authenticated users (auth guard requires it). Not the reminder bot: its
121-   121	      // grant is GET-only below, and this `read` would let an id-constrained LIST through.
122-   122	      allow read: if isAuthenticated() && request.auth.uid == userId && !isReminderBot();
123:   123	      // Manager+ reads all user docs (team filters, admin panels, etc.)
124-   124	      allow read: if isManagerOrAbove();
125-   125	      // Kiosk: read all users (for PIN lookup)
126-   126	      allow read: if isKiosk();
127-   127	      // Reminder bot: GET one doc by uid (the account it is about to email) — never a list.
128-   128	      allow get: if isReminderBot();
129-   129	
130-   130	      // Self-create: role must be 'staff' (prevents self-promotion), and
131-   131	      // appAccess must be absent or empty — app access is granted by an
132:   132	      // admin/manager via Manage Team, never by the user themselves.
133-   133	      // studios is NOT locked to empty here: the real bootstrap write (see
134-   134	      // js/app.js handleAuthStateChange) always sets studios: ['tinker',
135-   135	      // 'clayhub'] — both known studios, granted to every new user by
136-   136	      // default — so hasOnly() permits exactly that shape while still
137-   137	      // blocking a self-create from injecting any value outside the two
--
160-   160	        && fieldUnchanged('studios')
161-   161	        && fieldUnchanged('active');
162-   162	
163-   163	      // Manager update: cannot change role field, cannot delete.
164-   164	      // Restricted to OTHER users' docs (request.auth.uid != userId) —
165:   165	      // without this guard, a manager editing their OWN doc would satisfy
166-   166	      // isManager() and bypass the appAccess/studios pins on the self-update
167-   167	      // rule above entirely, since Firestore OR's sibling `allow update`
168:   168	      // rules together. A manager's own self-edits go through the
169-   169	      // self-update rule instead, which does pin those fields. Found by
170-   170	      // independent second-model review before this shipped — see
171-   171	      // firebase-agent-defense-hardening.md.
172:   172	      // A manager also cannot flip an admin's `active` field (archive/
173:   173	      // reactivate) — only another admin can. Managers keep full appAccess/
174:   174	      // studios editing on admins; that pre-existing gap stays out of scope.
175-   175	      allow update: if isManager()
176-   176	        && request.auth.uid != userId
177-   177	        && request.resource.data.role == resource.data.role
178:   178	        && (resource.data.role != 'admin' || fieldUnchanged('active'));
179-   179	
180:   180	      // Admin: full create / update / delete on OTHER users' docs. An admin
181-   181	      // can never change their OWN `active` field via this (or any) rule —
182-   182	      // without this guard this blanket rule sits outside the self-update
183-   183	      // rule's fieldUnchanged('active') pin (Firestore ORs sibling `allow`
184:   184	      // rules), so an admin could archive themselves with no recovery path:
185-   185	      // the moment it commits, isAdmin() requires isActiveUser() and denies
186-   186	      // them on every future request, including their own attempt to undo
187:   187	      // it. Same bug shape as the manager self-grant fix above, just for a
188-   188	      // field that didn't exist yet when that one shipped.
189-   189	      // …and never a doc keyed to the reminder bot's uid (a job, not a person): create and update are
190:   190	      // refused so no admin can hand the Netlify-held password a role by typing the uid; delete stays,
191-   191	      // so a doc created by mistake can be removed.
192-   192	      allow write: if isAdmin()
193-   193	        && (request.auth.uid != userId || fieldUnchanged('active'))
194-   194	        && !(isReminderBotUid(userId) && request.method in ['create', 'update']);
195-   195	    }
196-   196	
197-   197	
198-   198	    // ═══════════════════════════════════════════════════════════════
199-   199	    // FINANCE — HARD LOCKED
200:   200	    // payroll and bookkeeping: manager+ ONLY. No appAccess override
201-   201	    // path exists, ever. No exceptions.
202-   202	    // ═══════════════════════════════════════════════════════════════
203-   203	
204-   204	    match /payroll/{docId} {
205-   205	      allow read, write: if isManagerOrAbove();
--
255-   255	
256-   256	
257-   257	    // ═══════════════════════════════════════════════════════════════
258-   258	    // STAFF DIRECTORY
259-   259	    // Manager+ or appAccess('staff-directory'): full read/write.
260:   260	    // Delete: manager+ only.

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/payroll-tool/index.html | sed -n '3038,3145p'; rg -n \"match /timeclock_(entries|settings)|timeclock_entries|timeclock_settings\" /Users/christiehubley/studio-hub/firestore.rules -C 8; rg -n \"function calculateDayHours|changeRequest\\.status|requestedTimeIn|requestedTimeOut|lockedEmployeeTotals|discrep\" /Users/christiehubley/payroll-tool/index.html | head -80" in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
  3038	
  3039	    // 4. Group clock entries by uid
  3040	    const byUid = {};
  3041	    allEntries.forEach(e => {
  3042	      if (!byUid[e.uid]) byUid[e.uid] = { name: e.name, entries: [] };
  3043	      byUid[e.uid].entries.push(e);
  3044	    });
  3045	
  3046	    // Merge emp_ temp-ID entries into their claimed user's group (same logic as Tinker Ticker timesheets)
  3047	    roster.forEach(emp => {
  3048	      if (emp.claimedBy && byUid[emp.id]) {
  3049	        if (byUid[emp.claimedBy]) {
  3050	          byUid[emp.claimedBy].entries.push(...byUid[emp.id].entries);
  3051	        } else {
  3052	          byUid[emp.claimedBy] = { name: emp.name || byUid[emp.id].name, entries: byUid[emp.id].entries };
  3053	        }
  3054	        delete byUid[emp.id];
  3055	      }
  3056	    });
  3057	
  3058	    // Remember each uid's roster id BEFORE the emp_ merge deletes those keys, so
  3059	    // pulled people carry the ids that Link stores (matchEmployee step 1).
  3060	    const rosterIdByUid = {};
  3061	    roster.forEach(r => { if (r.claimedBy) rosterIdByUid[r.claimedBy] = r.id; else if (r.id) rosterIdByUid[r.id] = r.id; });
  3062	
  3063	    // Fix authoritative names: if a roster entry's claimedBy matches a uid, use the roster name
  3064	    const claimedByMap = {};
  3065	    roster.forEach(emp => { if (emp.claimedBy && emp.name) claimedByMap[emp.claimedBy] = emp.name; });
  3066	    Object.keys(byUid).forEach(uid => {
  3067	      if (claimedByMap[uid]) byUid[uid].name = claimedByMap[uid];
  3068	    });
  3069	
  3070	    // 5. Group HFWA by uid
  3071	    const hfwaByUid = {};
  3072	    hfwaEntries.forEach(e => {
  3073	      if (!hfwaByUid[e.uid]) hfwaByUid[e.uid] = [];
  3074	      hfwaByUid[e.uid].push(e);
  3075	    });
  3076	
  3077	    // 5. Calculate per-employee hours
  3078	    const employees = [];
  3079	    const allUids = new Set([...Object.keys(byUid), ...Object.keys(hfwaByUid)]);
  3080	
  3081	    allUids.forEach(uid => {
  3082	      const empData = byUid[uid] || { name: 'Unknown', entries: [] };
  3083	      const empHfwa = hfwaByUid[uid] || [];
  3084	      const name = empData.name || (empHfwa[0] ? empHfwa[0].name : 'Unknown');
  3085	
  3086	      // Group entries by date
  3087	      const byDate = {};
  3088	      empData.entries.forEach(e => {
  3089	        if (!byDate[e.date]) byDate[e.date] = [];
  3090	        byDate[e.date].push(e);
  3091	      });
  3092	
  3093	      // Calculate daily hours + overtime (Mon-Sun weeks, 40h threshold)
  3094	      const dailyHours = {};
  3095	      Object.keys(byDate).forEach(dateStr => {
  3096	        dailyHours[dateStr] = calcDayPaidHours(byDate[dateStr]);
  3097	      });
  3098	
  3099	      // Calculate overtime per Mon-Sun week
  3100	      const weeklyTotals = {};
  3101	      Object.keys(dailyHours).forEach(dateStr => {
  3102	        const d = new Date(dateStr + 'T12:00:00');
  3103	        const monDate = getTimeclockMonday(d);
  3104	        const weekKey = monDate.toISOString().slice(0, 10);
  3105	        if (!weeklyTotals[weekKey]) weeklyTotals[weekKey] = 0;
  3106	        weeklyTotals[weekKey] += dailyHours[dateStr];
  3107	      });
  3108	
  3109	      let regular = 0;
  3110	      let overtime = 0;
  3111	      const OT_THRESHOLD = 40;
  3112	      Object.values(weeklyTotals).forEach(weekTotal => {
  3113	        if (weekTotal > OT_THRESHOLD) {
  3114	          regular += OT_THRESHOLD;
  3115	          overtime += weekTotal - OT_THRESHOLD;
  3116	        } else {
  3117	          regular += weekTotal;
  3118	        }
  3119	      });
  3120	
  3121	      const totalHours = regular + overtime;
  3122	
  3123	      // HFWA sick leave total
  3124	      const sickHours = empHfwa.reduce((sum, h) => sum + (h.hours || 0), 0);
  3125	
  3126	      // Parse name into first/last
  3127	      const nameParts = name.split(' ');
  3128	      const firstName = nameParts[0] || '';
  3129	      const lastName = nameParts.slice(1).join(' ') || '';
  3130	
  3131	      // Build actual day counts and hours (for schedule-based allocation)
  3132	      const dayCounts = { Sun: 0, Mon: 0, Tue: 0, Wed: 0, Thu: 0, Fri: 0, Sat: 0 };
  3133	      const dayHoursMap = { Sun: 0, Mon: 0, Tue: 0, Wed: 0, Thu: 0, Fri: 0, Sat: 0 };
  3134	      const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  3135	
  3136	      Object.keys(dailyHours).forEach(dateStr => {
  3137	        if (dailyHours[dateStr] > 0) {
  3138	          const d = new Date(dateStr + 'T12:00:00');
  3139	          const dayName = dayNames[d.getDay()];
  3140	          dayCounts[dayName]++;
  3141	          dayHoursMap[dayName] += dailyHours[dateStr];
  3142	        }
  3143	      });
  3144	
  3145	      // Store actual day data for schedule allocation
454-    // entries:   Staff with access — own entries only (read/create/update)
455-    // schedules: Staff with access — read-only; manager+ write
456-    // hfwa:      Staff with access — own doc only (create/read)
457-    // timeoff:   Staff with access — own doc only (create/read/update)
458-    // settings:  Staff with access — read-only; manager+ write
459-    // streaks:   Staff with access — own doc only (read/write)
460-    // ═══════════════════════════════════════════════════════════════
461-
462:    match /timeclock_entries/{docId} {
463-      allow read, write: if isManagerOrAbove();
464-      // Kiosk: read + create entries (needs to read today's status after PIN entry)
465-      allow read, create: if isKiosk();
466-      // Staff with access: own entries only
467-      allow create: if hasAppAccess('timeclock')
468-        && request.resource.data.uid == request.auth.uid;
469-      allow read: if hasAppAccess('timeclock')
470-        && resource.data.uid == request.auth.uid;
--
497-      allow create: if hasAppAccess('timeclock')
498-        && request.resource.data.uid == request.auth.uid;
499-      allow read: if hasAppAccess('timeclock')
500-        && resource.data.uid == request.auth.uid;
501-      allow update: if hasAppAccess('timeclock')
502-        && resource.data.uid == request.auth.uid;
503-    }
504-
505:    match /timeclock_settings/{docId} {
506-      allow read, write: if isManagerOrAbove();
507-      // Staff with access: read-only
508-      allow read: if hasAppAccess('timeclock');
509-      // Staff can write the employees doc for name claiming
510-      allow write: if hasAppAccess('timeclock') && docId == 'employees';
511-      // adminSubscriptions: any authenticated user can read (needed for staff→admin push)
512-      allow read: if isAuthenticated() && docId == 'adminSubscriptions';
513-      // Kiosk: read employees (PIN lookup) and schedules
3037:    const lockedEmployeeTotals = lockedPeriodData && lockedPeriodData.employeeTotals ? lockedPeriodData.employeeTotals : null;
3156:        const lockedEntry = lockedEmployeeTotals ? lockedEmployeeTotals[uid] : null;
3229:        (mismatches.length ? '<br><span style="color:var(--warning);">⚠ ' + mismatches.length + ' employee(s) have hour discrepancies — see Review tab for details.</span>' : '') +
3262:      if (e.changeRequest.status === 'approved' && e.changeRequest.requestedTimeIn && e.changeRequest.requestedTimeOut) {
3264:        const inT = new Date(dateStr + 'T' + e.changeRequest.requestedTimeIn + ':00').getTime();
3265:        const outT = new Date(dateStr + 'T' + e.changeRequest.requestedTimeOut + ':00').getTime();

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '6105,6215p'; nl -ba js/app.js | sed -n '6580,6642p'; rg -n \"Assign|confirmAssignUser|handleClaimName|migrateSchedule\" js/app.js | sed -n '1,120p'; nl -ba js/firebase-data.js | sed -n '154,240p'; nl -ba schedule-editor-wiring.test.js | sed -n '1600,1725p'" in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
  6105	
  6106	  // Continue the rest of initialization that was deferred
  6107	  await loadSchedulesData();
  6108	  loadMyShift();
  6109	  await loadMyStatus();
  6110	  renderMySchedule();
  6111	
  6112	  const hfwaDate = document.getElementById('hfwa-date');
  6113	  if (hfwaDate) hfwaDate.value = getTodayDateStr();
  6114	
  6115	  hideLoading();
  6116	}
  6117	
  6118	// ─── Seed Employees ──────────────────────────────────
  6119	
  6120	async function handleSeedEmployees() {
  6121	  const btn = document.getElementById('btn-seed-employees');
  6122	  btn.disabled = true;
  6123	  btn.textContent = 'Seeding...';
  6124	
  6125	  // Load fresh roster
  6126	  let roster = await loadEmployeeRoster();
  6127	  const existingIds = new Set(roster.map(e => e.id));
  6128	
  6129	  let added = 0;
  6130	  SEED_EMPLOYEES.forEach(name => {
  6131	    const id = nameToId(name);
  6132	    if (!existingIds.has(id)) {
  6133	      roster.push({ id, name, claimedBy: null, active: true });
  6134	      added++;
  6135	    }
  6136	  });
  6137	
  6138	  if (added > 0) {
  6139	    const success = await saveEmployeeRoster(roster);
  6140	    if (success) {
  6141	      employeeRoster = roster;
  6142	      renderRosterList();
  6143	    } else {
  6144	      alert('Failed to seed employees.');
  6145	    }
  6146	  }
  6147	
  6148	  btn.disabled = false;
  6149	  btn.textContent = 'Seed Employees from Payroll';
  6150	
  6151	  if (added === 0) {
  6152	    alert('All employees already in roster. Nothing to add.');
  6153	  } else {
  6154	    alert(`Added ${added} employee(s) to roster.`);
  6155	  }
  6156	}
  6157	
  6158	// ─── Seed Time Off (Migration) — RETIRED Sep 11 2026 ──
  6159	// The one-shot importer of the original time-off requests (a hardcoded list + handleSeedTimeOff) lived
  6160	// here. It was removed, not fixed: it had already been run, every entry short-circuited at its duplicate
  6161	// guard, and it created each request as APPROVED before writing the schedule — so a failure left an
  6162	// approved request the rerun would skip forever. Rather than restructure a tool that had served its
  6163	// purpose, Christie chose to retire it. History: git show 9e7aa49:js/app.js for the last version.
  6164	
  6165	// ─── Add Employee ────────────────────────────────────
  6166	
  6167	async function handleAddEmployee() {
  6168	  const nameInput = document.getElementById('add-emp-name');
  6169	  const name = nameInput.value.trim();
  6170	  if (!name) { alert('Enter a name.'); return; }
  6171	
  6172	  const id = nameToId(name);
  6173	
  6174	  // Check for duplicates
  6175	  if (employeeRoster.find(e => e.id === id)) {
  6176	    alert(`"${name}" is already in the roster.`);
  6177	    return;
  6178	  }
  6179	
  6180	  const btn = document.getElementById('btn-add-employee');
  6181	  btn.disabled = true;
  6182	
  6183	  employeeRoster.push({ id, name, claimedBy: null, active: true });
  6184	  const success = await saveEmployeeRoster(employeeRoster);
  6185	
  6186	  if (success) {
  6187	    nameInput.value = '';
  6188	    renderRosterList();
  6189	  } else {
  6190	    // Revert
  6191	    employeeRoster.pop();
  6192	    alert('Failed to add employee.');
  6193	  }
  6194	
  6195	  btn.disabled = false;
  6196	}
  6197	
  6198	async function copyFutureScheduleCsvPrompt() {
  6199	  try {
  6200	    await navigator.clipboard.writeText(FUTURE_SCHEDULE_CSV_PROMPT);
  6201	    showToast('Prompt copied — paste it into a new Claude Chat.');
  6202	  } catch (err) {
  6203	    console.error('Failed to copy CSV prompt:', err);
  6204	    showToast('Could not copy — select the text above manually.');
  6205	  }
  6206	}
  6207	
  6208	// ─── Future Schedule CSV Import ──────────────────────
  6209	// Mirrors this session's one-off Fall 2026 import tool's safety pattern (dry-run, then a downloaded
  6210	// pre-write snapshot required before the write button unlocks) built into the app itself. The write only
  6211	// ever touches `futureSchedule` — and, since the "48-hour shift reminders" plan (Phase 3), only its
  6212	// weekdays and bounds: it never writes `futureSchedule.overrides`, so dated future shifts and their
  6213	// reminder flags survive a re-import. The earlier `set({ futureSchedule }, { mergeFields })` replaced the
  6214	// whole block and wiped every existing future override (a pre-existing hazard, measured on the emulator).
  6215	
  6580	  list.classList.toggle('hidden');
  6581	  renderArchivedRosterList();
  6582	}
  6583	
  6584	async function renderOrphanedSchedules() {
  6585	  const section = document.getElementById('orphaned-schedules-section');
  6586	  const list = document.getElementById('orphaned-schedules-list');
  6587	  if (!section || !list) return;
  6588	
  6589	  try {
  6590	    const db = getDb();
  6591	    const schedulesSnap = await db.collection('timeclock_schedules').get();
  6592	    const scheduleIds = new Set(schedulesSnap.docs.map(d => d.id));
  6593	
  6594	    const orphans = [];
  6595	    schedulesSnap.forEach(doc => {
  6596	      if (!doc.id.startsWith('emp_')) return;
  6597	      // Case 1: no matching roster entry at all. Deliberately active-agnostic —
  6598	      // an archived entry is a distinct, non-destructive state and must never
  6599	      // be treated as "orphaned," which would surface a permanent-delete
  6600	      // button as an unintended side effect of archiving someone.
  6601	      const rosterEntry = employeeRoster.find(e => e.id === doc.id);
  6602	      if (!rosterEntry) {
  6603	        orphans.push({ id: doc.id, name: doc.data().name || doc.id });
  6604	        return;
  6605	      }
  6606	      // Case 2: roster entry is claimed AND a schedule also exists under the real UID — emp_* is the duplicate
  6607	      if (rosterEntry.claimedBy && scheduleIds.has(rosterEntry.claimedBy)) {
  6608	        orphans.push({ id: doc.id, name: doc.data().name || rosterEntry.name || doc.id });
  6609	      }
  6610	    });
  6611	
  6612	    if (orphans.length === 0) {
  6613	      section.classList.add('hidden');
  6614	      return;
  6615	    }
  6616	
  6617	    section.classList.remove('hidden');
  6618	    list.innerHTML = orphans.map(o => `
  6619	      <div style="display:flex; justify-content:space-between; align-items:center; padding:4px 0; border-bottom:1px solid #ffe0b2;">
  6620	        <span style="font-size:13px; font-weight:600;">${escapeHtml(o.name)}</span>
  6621	        <button class="btn btn-sm" style="font-size:11px; padding:2px 8px; color:var(--red); border-color:var(--red);"
  6622	          onclick="removeOrphanedSchedule(${jsArg(o.id)}, ${jsArg(o.name)})">Remove</button>
  6623	      </div>`).join('');
  6624	  } catch (err) {
  6625	    console.warn('Could not check orphaned schedules:', err);
  6626	    section.classList.add('hidden');
  6627	  }
  6628	}
  6629	
  6630	async function removeOrphanedSchedule(schedId, name) {
  6631	  if (!confirm(`Remove orphaned schedule for "${name}"? This only removes the schedule doc — clock history is preserved.`)) return;
  6632	  try {
  6633	    const db = getDb();
  6634	    await db.collection('timeclock_schedules').doc(schedId).delete();
  6635	    showToast(`Orphaned schedule for ${name} removed.`);
  6636	    renderOrphanedSchedules();
  6637	  } catch (err) {
  6638	    console.error('Failed to remove orphaned schedule:', err);
  6639	    showToast('Error removing schedule — see console.');
  6640	  }
  6641	}
  6642	
278:  document.getElementById('btn-claim-name').addEventListener('click', handleClaimName);
4237:        // same field migrateSchedule() writes. Without it a reassigned schedule was invisible to both
5767:  // Label only — the click handler is registered once, via addEventListener at init. Assigning onclick
5973:    await migrateSchedule(match.id, currentUser.uid);
6022:async function handleClaimName() {
6066:  await migrateSchedule(empId, currentUser.uid);
6531:    // Assign-to-user button for unclaimed entries (admin only)
6533:      ? `<button class="btn btn-sm" style="font-size:11px; padding:2px 8px; color:var(--purple); border-color:var(--purple);" onclick="openAssignUserModal(${jsArg(emp.id)}, ${jsArg(emp.name)})">Assign</button>`
6737:// ─── Assign Roster Entry to User (admin) ─────────────
6741:async function openAssignUserModal(empId, empName) {
6747:    alert(`No unclaimed user accounts found.\n\n"${empName}" needs to log into the app on their phone first — then use Assign.`);
6751:    `Assign "${empName}" to which user?\n\nAvailable accounts:\n` +
6761:  confirmAssignUser(empId, available[idx - 1].uid);
6764:async function confirmAssignUser(empId, uid) {
6772:    await migrateSchedule(empId, uid);
6774:    showToast(`Assigned — ${emp.name} linked to account.`);
6777:    console.error('Assign user failed:', err);
7923:// ─── Sub Confirmation + Auto-Assignment (Plan 2, Phase 3) ─────────
9273:      // and got another). migrateSchedule and reassignSchedule stamp `migratedFrom`; the chain is followed.
   154	// ─── Pay Period Locking ──────────────────────────────
   155	
   156	// The write payroll trusts. Two guards, both in the WRITE rather than in a read-gate, because the damage
   157	// they prevent happens when a READ has already failed. (The caller does now refuse a failed or cache-served
   158	// read as well — the two are complementary: this one cannot be bypassed by a future caller, and the
   159	// caller's runs early enough to keep a false summary off the screen.)
   160	//
   161	//   1. A snapshot nobody could have reviewed is refused. Pass { allowEmpty: true } for the genuinely-empty
   162	//      period, which is a thing a human confirms. The caller ALSO reads fresh, refuses a failed or
   163	//      cache-served read, and validates the snapshot before it asks for that confirmation — so this guard
   164	//      is the write's own last line, not the only one.
   165	//   2. An already-locked period is refused, inside a transaction so a stale read cannot get past it. A
   166	//      merge-set would otherwise overwrite lockedAt / lockedBy / employeeTotals — destroying the record of
   167	//      what was actually paid — and, for a PARTIAL snapshot, deep-merge it: people present overwritten,
   168	//      people absent surviving with stale values, producing a hybrid that looks entirely plausible.
   169	//      Re-locking stays possible; Unlock first, whose confirm already warns about invalidating payroll.
   170	//
   171	// Returns { ok, reason?, lockedBy?, lockedAt?, uid?, name?, count? } — not a boolean; the caller has to
   172	// tell these apart. Note the caller ALSO refuses a failed or cache-served read before it gets here: the
   173	// guards below are the write's own, so a future caller cannot bypass them, not the only line of defence.
   174	async function lockPayPeriod(periodKey, employeeTotals, opts) {
   175	  if (!_ready) return { ok: false, reason: 'not-ready' };
   176	  const o = opts || {};
   177	  const totals = employeeTotals && typeof employeeTotals === 'object' && !Array.isArray(employeeTotals)
   178	    ? employeeTotals : null;
   179	  if (!totals) return { ok: false, reason: 'no-totals' };
   180	  const keys = Object.keys(totals);
   181	  if (!keys.length && !o.allowEmpty) return { ok: false, reason: 'empty-totals' };
   182	  // The Payroll Tool reads totalHours / regular / overtime off each entry, so this document is the contract
   183	  // between the two apps. A non-empty object is not automatically a usable snapshot (Codex, Sep 28).
   184	  // Number.isFinite, not typeof: typeof NaN === 'number', and calcPeriodTotals CAN emit NaN — an entry
   185	  // whose timestamp does not parse gives Math.max(0, NaN) === NaN, which then poisons regular via
   186	  // `weeks[k] += NaN` (NaN > 40 is false). All THREE fields are read by the Payroll Tool, and `regular` is
   187	  // precisely the one that goes NaN while overtime stays 0 (both reviewers, Sep 28).
   188	  // Shared with the caller, which checks BEFORE it asks the manager to confirm. This copy is what stops a
   189	  // future writer bypassing that, so both exist deliberately.
   190	  const bad = findMalformedTotal(totals);
   191	  if (bad) return { ok: false, reason: 'malformed-totals', uid: bad.uid, name: bad.name, count: bad.count };
   192	  try {
   193	    const ref = _db.collection('timeclock_settings').doc('lockedPeriods');
   194	    return await _db.runTransaction(async (tx) => {
   195	      const doc = await tx.get(ref);
   196	      const existing = (doc.exists ? (doc.data() || {}) : {})[periodKey];
   197	      if (existing) {
   198	        return { ok: false, reason: 'already-locked',
   199	                 lockedBy: existing.lockedBy || null, lockedAt: existing.lockedAt || null };
   200	      }
   201	      // Strip empty names before writing: calcPeriodTotals emits `name: emp.name || ''` and the repo's
   202	      // non-negotiable invariant is that empty-string fields are stripped before any write. The Payroll
   203	      // Tool reads totalHours / regular / overtime and not name, so omitting it changes nothing downstream
   204	      // (Codex, round five).
   205	      const clean = {};
   206	      Object.keys(totals).forEach(uid => {
   207	        const v = totals[uid];
   208	        const rec = { regular: v.regular, overtime: v.overtime, totalHours: v.totalHours };
   209	        if (typeof v.name === 'string' && v.name.trim()) rec.name = v.name;
   210	        clean[uid] = rec;
   211	      });
   212	      tx.set(ref, {
   213	        [periodKey]: {
   214	          lockedAt: new Date().toISOString(),
   215	          lockedBy: (getAuthUser() || {}).name || 'unknown',
   216	          employeeTotals: clean
   217	        }
   218	      }, { merge: true });
   219	      return { ok: true };
   220	    });
   221	  } catch (err) {
   222	    console.error('Failed to lock period:', err);
   223	    return { ok: false, reason: 'error' };
   224	  }
   225	}
   226	
   227	async function unlockPayPeriod(periodKey) {
   228	  if (!_ready) return false;
   229	  try {
   230	    await _db.collection('timeclock_settings').doc('lockedPeriods').set({
   231	      [periodKey]: firebase.firestore.FieldValue.delete()
   232	    }, { merge: true });
   233	    return true;
   234	  } catch (err) {
   235	    console.error('Failed to unlock period:', err);
   236	    return false;
   237	  }
   238	}
   239	
   240	async function getLockedPeriods() {
  1600	
  1601	  test('the deny/withdraw helper treats a record with no subUid as a failure that keeps the record, never a skip', () => {
  1602	    const bulk = slice('async function reverseConfirmedSubScheduleWrites(proposedSubs, onlyIndexes)', 'async function reverseConfirmedTimeOffSubs(');
  1603	    expect(bulk).toMatch(/if \(!\(sub\.confirmed && sub\.appliedOverrides && Object\.keys\(sub\.appliedOverrides\)\.length\)\) continue;/);
  1604	    expect(bulk).toMatch(/const r = sub\.subUid \? await removeTimeOffOverrides\(sub\.subUid, sub\.appliedOverrides\) : \{ ok: false, reason: 'schedule-missing' \};/);
  1605	    expect(bulk).not.toMatch(/sub\.confirmed && sub\.subUid &&/);
  1606	  });
  1607	
  1608	  test('edit-reopen (status reset): landed subs are un-confirmed transactionally; the saved list carries what the document NOW says is confirmed', () => {
  1609	    const edit = slice("if (['approved', 'completed', 'denied'].includes(existingData.status)) {", '} else {');
  1610	    expect(edit).toMatch(/const subsResult = await reverseConfirmedTimeOffSubs\(editingTimeOffId, existingData\.proposedSubs\);/);
  1611	    // the note BEFORE the fresh read (an open alert must not sit inside the read→save window), then a FRESH
  1612	    // read decides (review finding: restoring the pre-edit snapshot overwrote a confirmation another tab
  1613	    // made meanwhile), then the save guard is armed on exactly what that read saw
  1614	    expect(edit).toMatch(/if \(!subsResult\.ok\) alert\(failedSubsNote\(subsResult\.failed\)\);[^\n]*\n\s*const carried = await carryCurrentSubs\(editingTimeOffId, formData\.proposedSubs\.map\(s => \(\{ \.\.\.s, confirmed: false \}\)\)\);\s*if \(!carried\) \{ giveBack\(\); return; \}\s*formData\.proposedSubs = carried\.subs;\s*(\/\/[^\n]*\n\s*)*saveGuard = \{ reset: reversal\.ok && !!\(existingData\.appliedOverrides && Object\.keys\(existingData\.appliedOverrides\)\.length\), statuses: existingData\.status === 'approved' \? \['approved', 'completed'\] : \[existingData\.status\], expect: \{ proposedSubs: carried\.current, appliedOverrides: requesterRecord \} \};/);   // approved may auto-complete meanwhile
  1615	    expect(edit).not.toMatch(/await reverseConfirmedSubScheduleWrites\(existingData\.proposedSubs\);\s*formData\.proposedSubs = formData\.proposedSubs\.map/);   // the old blind clear
  1616	    expect(edit).not.toMatch(/restoreFailedSubs|existingData\.proposedSubs, subsResult\.failed/);
  1617	  });
  1618	
  1619	  test('edit (no status reset): only the un-ticked/removed subs are reversed, transactionally, and the fresh document decides', () => {
  1620	    const edit = slice('const { subs, toReverse } = reconcileEditedProposedSubs(formData.proposedSubs, existingData.proposedSubs);', '// Update existing request');
  1621	    expect(edit).toMatch(/const subsResult = await reverseConfirmedTimeOffSubs\(editingTimeOffId, existingData\.proposedSubs, new Set\(toReverse\.map\(t => t\.index\)\)\);\s*if \(!subsResult\.ok\) \{/);
  1622	    // the owner cannot write the sub's schedule: for them a write failure is a hand-off, not "retry once fixed"
  1623	    expect(edit).toMatch(/if \(!isManagerUser\(\) && stuck\.length\) \{\s*const noted = await handOffSubRemovalToManager\(\{ id: editingTimeOffId, name: existingData\.name, requestStudios: existingData\.requestStudios \}, stuck\);/);
  1624	    expect(edit).toMatch(/if \(rest\.length\) alert\(failedSubsNote\(rest\)\);/);   // mixed failures: the rest are not hidden behind the hand-off
  1625	    expect(edit).toMatch(/\} else \{\s*alert\(failedSubsNote\(subsResult\.failed\)\);\s*\}\s*\}\s*const carried = await carryCurrentSubs\(editingTimeOffId, subs\);\s*if \(!carried\) \{ giveBack\(\); return; \}/);
  1626	    // the second check (plan: ticker-sub-confirm-only-by-manager) sits between the carry and the save, and the save
  1627	    // guard now also expects the dates that read saw
  1628	    expect(edit).toMatch(/const second = checkEditAgainstDocument\([^)]*docSubs: carried\.current, docDates: carried\.currentDates, reversedNames \}\);\s*if \(!second\.ok\) \{\s*giveBack\(\);/);
  1629	    expect(edit).toMatch(/formData\.proposedSubs = carried\.subs;\s*saveGuard = \{ statuses: \[existingData\.status\], expect: \{ proposedSubs: carried\.current, appliedOverrides: requesterRecord, dates: carried\.currentDates \} \};/);
  1630	    expect(edit).not.toMatch(/await removeTimeOffOverrides\(subUid, appliedOverrides\)/);   // no bare, unchecked reversal remains
  1631	    // the save itself is GUARDED on status + the fresh subs + the requester's record (review finding: an
  1632	    // un-approve/re-approve or withdrawal in another tab was overwritten by the wholesale save)
  1633	    const save = slice('// Update existing request — guarded', '} else {\n    // Create new request');
  1634	    expect(save).toMatch(/const saved = await updateTimeOffRequestIfStatus\(editingTimeOffId, saveGuard\.statuses, formData, saveGuard\.expect\);/);
  1635	    expect(save).toMatch(/if \(!success && \['status-changed', 'changed', 'not-found'\]\.includes\(saved\.reason\)\) \{\s*giveBack\(\);/);
  1636	    expect(save).toMatch(/so your edits were NOT saved\. Any sub coverage removed above stays removed\$\{saveGuard\.reset \? ', and so does the requester\\'s own time off/);
  1637	    expect(src).toMatch(/const requesterRecord = existingData\.appliedOverrides === undefined \? null : existingData\.appliedOverrides;/);   // exact value, {} stays {}
  1638	    // the Save button is given back on every early return (review finding: it was left disabled)
  1639	    expect(src).toMatch(/const giveBack = \(\) => \{ btn\.disabled = false; btn\.textContent = editingTimeOffId \? 'Save Changes' : 'Submit Request'; \};/);
  1640	    // the helpers honour the index filter
  1641	    const bulk = slice('async function reverseConfirmedSubScheduleWrites(proposedSubs, onlyIndexes)', 'async function reverseConfirmedTimeOffSubs(');
  1642	    expect(bulk).toMatch(/if \(onlyIndexes && !onlyIndexes\.has\(i\)\) continue;/);
  1643	    const both = slice('async function reverseConfirmedTimeOffSubs(requestId, proposedSubs, onlyIndexes)', '// ─── Coverage Status Update');
  1644	    expect(both).toMatch(/reverseConfirmedSubScheduleWrites\(proposedSubs, onlyIndexes\)/);
  1645	    expect(both).toMatch(/if \(onlyIndexes && !onlyIndexes\.has\(i\)\) continue;/);
  1646	    // the carry helper refuses the save on an unreadable request
  1647	    const carry = slice('async function carryCurrentSubs(requestId, subs)', '// What to tell the admin when a sub');
  1648	    expect(carry).toMatch(/const current = await getTimeOffRequestResult\(requestId\);\s*if \(!current\.ok \|\| !current\.exists\) \{\s*alert\([^)]*so it was not saved/);
  1649	    expect(carry).toMatch(/return \{ subs: carryConfirmedSubs\(subs, current\.data\.proposedSubs\), current: currentSubs, currentDates \};/);
  1650	    expect(carry).toMatch(/const currentDates = current\.data\.dates === undefined \? null : current\.data\.dates;/);   // absence stays null, never []
  1651	    // the note: per-reason wording, said BEFORE the save so "will be", and record-not-cleared is not a schedule failure
  1652	    const note = slice('function failedSubsNote(failed)', '// Dates a reversal deliberately left alone');
  1653	    expect(note).toMatch(/return `The request will be saved, BUT/);
  1654	    expect(note).toMatch(/is STILL on their schedule \(it could not be updated\)/);
  1655	    expect(note).toMatch(/may still be on their schedule \(it could not be read\)/);
  1656	    expect(note).toMatch(/no schedule document was found for them/);
  1657	    expect(note).toMatch(/changed in another tab while this form was open/);
  1658	    expect(note).toMatch(/WAS removed but their entry could not be updated to say so — use Undo on them/);   // record-clear-failed
  1659	    expect(note).toMatch(/use Undo on/);
  1660	    expect(note).not.toMatch(/was saved/);
  1661	  });
  1662	
  1663	  test('carryConfirmedSubs is the tested helper, exported from schedule-helpers.js; nothing restores a pre-edit snapshot', () => {
  1664	    const helpers = fs.readFileSync(`${__dirname}/js/schedule-helpers.js`, 'utf8');
  1665	    expect(helpers).toMatch(/^function carryConfirmedSubs\(subs, currentSubs\) \{/m);
  1666	    expect(helpers).toMatch(/module\.exports = \{[\s\S]*?carryConfirmedSubs,/);
  1667	    expect(helpers).toMatch(/subUid: prior\.subUid \|\| null, appliedOverrides: prior\.appliedOverrides \|\| \{\}/);   // never undefined in a write
  1668	    expect(src).not.toMatch(/restoreFailedSubs/);
  1669	    expect(helpers).not.toMatch(/restoreFailedSubs/);
  1670	  });
  1671	});
  1672	
  1673	describe('Phase 5: the unawaited-write family', () => {
  1674	  const src = fs.readFileSync(`${__dirname}/js/app.js`, 'utf8');
  1675	  const data = fs.readFileSync(`${__dirname}/js/firebase-data.js`, 'utf8');
  1676	  const slice = (from, to) => { const a = src.indexOf(from); const b = src.indexOf(to, a); expect(a).toBeGreaterThan(-1); expect(b).toBeGreaterThan(a); return src.slice(a, b); };
  1677	
  1678	  test('the four functions are async and await their write (behaviour: firebase-data.failure.test.js)', () => {
  1679	    expect(data).toMatch(/^async function updateClockEntry\(docId, updates\) \{[\s\S]*?await _db\.collection\('timeclock_entries'\)\.doc\(docId\)\.update\(updates\);/m);
  1680	    expect(data).toMatch(/^async function deleteSchedule\(uid\) \{[\s\S]*?await _db\.collection\('timeclock_schedules'\)\.doc\(uid\)\.delete\(\);/m);
  1681	    expect(data).toMatch(/^async function saveSettings\(settings\) \{[\s\S]*?await _db\.collection\('timeclock_settings'\)\.doc\('appConfig'\)\.set\(/m);
  1682	    expect(data).toMatch(/^async function saveStreakData\(updates\) \{[\s\S]*?await _db\.collection\('timeclock_streaks'\)\.doc\(uid\)\.set\(/m);
  1683	    expect(data).not.toMatch(/^function (updateClockEntry|deleteSchedule|saveSettings|saveStreakData)\(/m);
  1684	  });
  1685	
  1686	  test('EVERY caller awaits — an unawaited call would see an always-truthy Promise (plan review finding)', () => {
  1687	    const html = fs.readFileSync(`${__dirname}/index.html`, 'utf8');
  1688	    for (const fn of ['updateClockEntry', 'deleteSchedule', 'saveSettings', 'saveStreakData']) {
  1689	      const calls = [...src.matchAll(new RegExp(`(?<![\\w.])${fn}\\(`, 'g'))].map(m => src.slice(Math.max(0, m.index - 40), m.index));
  1690	      expect(calls.length).toBeGreaterThan(0);
  1691	      // `await fn(`, an arrow returning it into an awaited Promise.all, or an EXPLICIT `void fn(` — the
  1692	      // documented detached form (see below); never a bare call whose result is read
  1693	      calls.forEach(before => expect(before).toMatch(/await\s+$|=> $|void $/));
  1694	      expect(html).not.toMatch(new RegExp(`(?<![\\w.])${fn}\\(`));   // no inline handler calls it
  1695	    }
  1696	    // the arrow form appears exactly once: removeEmployee's Promise.all
  1697	    expect((src.match(/=> deleteSchedule\(/g) || []).length).toBe(1);
  1698	    // the ONLY detached calls are the two kiosk streak-enrichment writes (review finding: the confirmation
  1699	    // screen sits below them, and an awaited write never resolves offline — a hang there invites a second punch)
  1700	    const voids = [...src.matchAll(/void (updateClockEntry|deleteSchedule|saveSettings|saveStreakData)\(/g)].map(m => m.index);
  1701	    expect(voids.length).toBe(2);
  1702	    const kioskIn = src.indexOf('void updateClockEntry(entryRef.id, {');
  1703	    const kioskOut = src.indexOf('void updateClockEntry(outRef.id, {');
  1704	    expect(voids.sort((a, b) => a - b)).toEqual([kioskIn, kioskOut].sort((a, b) => a - b));
  1705	    expect(src.slice(kioskIn, kioskIn + 400)).toMatch(/clockInStreakAfter/);
  1706	    expect(src.slice(kioskOut, kioskOut + 400)).toMatch(/clockOutStreakAfter/);
  1707	    expect(kioskIn).toBeLessThan(src.indexOf('showKioskConfirmation(', kioskIn));   // and the confirmation follows, not waiting
  1708	    // the specific one the review named: the admin time edit's guard — now with an in-flight guard, since a
  1709	    // second click during the awaited round-trip would send a second update
  1710	    const edit = slice('async function adminEditSaveEntry(entryId)', '\n}\n');
  1711	    expect(edit).toMatch(/if \(_aeeSaveInFlight\.has\(entryId\)\) return;/);
  1712	    expect(edit).toMatch(/_aeeSaveInFlight\.add\(entryId\);\s*let ok = false;\s*try \{\s*ok = await updateClockEntry\(entryId, updates\);\s*\} finally \{\s*_aeeSaveInFlight\.delete\(entryId\);\s*\}/);
  1713	    expect(edit).toMatch(/if \(ok\) \{[\s\S]*?\} else \{\s*alert\('Save failed — see console\.'\);/);
  1714	    // the streak card only shows the new streak once it is saved
  1715	    // ... and so does the celebration — a "5 days!" toast over a card still reading 4 would lie
  1716	    expect((src.match(/if \(await saveStreakData\(streak\)\) \{\s*renderStreakCard\(streak\);\s*if \(celebrate\) showCelebration\(celebrate\);\s*\}/g) || []).length).toBe(2);
  1717	    expect(src).not.toMatch(/showCelebration\(getMilestoneMessage\(/);
  1718	  });
  1719	
  1720	  test('removing an employee: the roster save is checked first, the claimed-UID schedule is found, and a surviving schedule is named', () => {
  1721	    const fn = slice('async function removeEmployee(empId, name)', '\n}\n');
  1722	    // an entry already gone (a second click while the first is saving) stops here; otherwise read it
  1723	    // BEFORE the splice (the old lookup ran after it and never found claimedBy)
  1724	    expect(fn).toMatch(/if \(idx === -1\) \{ showToast\([^)]*no longer on the roster[^)]*\); return; \}[^\n]*\n\s*const entry = employeeRoster\[idx\];\s*employeeRoster\.splice\(idx, 1\);/);
  1725	    expect(fn).toMatch(/if \(!\(await saveEmployeeRoster\(employeeRoster\)\)\) \{\s*employeeRoster\.splice\(idx, 0, entry\);\s*alert\([^)]*was NOT removed/);

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '658,820p'; nl -ba js/app.js | sed -n '4000,4060p'; nl -ba js/app.js | sed -n '4420,4460p'; nl -ba js/app.js | sed -n '4565,4610p'; nl -ba js/app.js | sed -n '5595,5640p'; nl -ba js/app.js | sed -n '6510,6550p'; rg -n \"await [A-Za-z_"'$]['"\\w"'$]*'"\\(["'^;]*'"\\);\" js/app.js | sed -n '1,260p'" in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
   658	// ─── Core clock in/out (shared by normal + unscheduled + auto) ──
   659	
   660	async function doClockIn(now, studio, extraFields) {
   661	  // Cancel clock-in nudge — they're clocking in
   662	  if (shiftStartTimer) { clearTimeout(shiftStartTimer); shiftStartTimer = null; }
   663	
   664	  const entry = {
   665	    uid: currentUser.uid,
   666	    name: currentUser.name || currentUser.email,
   667	    type: 'clock-in',
   668	    timestamp: now.toISOString(),
   669	    date: getTodayDateStr(),
   670	    weekday: getWeekday(),
   671	    studio: studio || (currentUser.studios && currentUser.studios[0]) || 'tinker',
   672	    ...(extraFields || {})
   673	  };
   674	
   675	  const id = await addClockEntry(entry);
   676	  if (id) {
   677	    setClockStatus('clocked-in', now);
   678	    document.getElementById('gate-message').classList.add('hidden');
   679	    // Track streak (only for scheduled, non-extension, non-unscheduled clock-ins)
   680	    if (!extraFields || (!extraFields.extended && !extraFields.unscheduled)) {
   681	      updateStreakOnClockIn();
   682	    }
   683	    // Show push notification prompt after clock-in (if not yet granted/dismissed)
   684	    maybeShowPushPrompt();
   685	    return true;
   686	  } else {
   687	    alert('Failed to clock in. Please try again.');
   688	    return false;
   689	  }
   690	}
   691	
   692	async function doClockOut(now, extraFields) {
   693	  const entry = {
   694	    uid: currentUser.uid,
   695	    name: currentUser.name || currentUser.email,
   696	    type: 'clock-out',
   697	    timestamp: now.toISOString(),
   698	    date: getTodayDateStr(),
   699	    weekday: getWeekday(),
   700	    studio: (currentUser.studios && currentUser.studios[0]) || 'tinker',
   701	    ...(extraFields || {})
   702	  };
   703	
   704	  const id = await addClockEntry(entry);
   705	  if (id) {
   706	    setClockStatus('clocked-out', null);
   707	    // Track streak (skip for unscheduled shifts)
   708	    const lastClockIn = [...todayEntries].reverse().find(e => e.uid === currentUser.uid && e.type === 'clock-in');
   709	    const wasUnscheduled = lastClockIn && lastClockIn.unscheduled;
   710	    if (!wasUnscheduled) {
   711	      const isAutoEnded = extraFields && extraFields.autoEnded;
   712	      updateStreakOnClockOut(isAutoEnded);
   713	    }
   714	    return true;
   715	  } else {
   716	    alert('Failed to clock out. Please try again.');
   717	    return false;
   718	  }
   719	}
   720	
   721	// ─── Break Tracking (Phase 4) ────────────────────────
   722	
   723	let breakAutoEndTimer = null;
   724	
   725	async function handleBreakStart() {
   726	  const btn = document.getElementById('btn-break-start');
   727	  btn.disabled = true;
   728	
   729	  const now = new Date();
   730	  const entry = {
   731	    uid: currentUser.uid,
   732	    name: currentUser.name || currentUser.email,
   733	    type: 'break-start',
   734	    timestamp: now.toISOString(),
   735	    date: getTodayDateStr(),
   736	    weekday: getWeekday(),
   737	    studio: (currentUser.studios && currentUser.studios[0]) || 'tinker'
   738	  };
   739	
   740	  const id = await addClockEntry(entry);
   741	  if (id) {
   742	    setClockStatus('on-break', now);
   743	    // Pause shift-end timer while on break
   744	    clearShiftEndTimer();
   745	    // Start break auto-end timer
   746	    const breakLimit = (appSettings && appSettings.breakAutoEndMinutes) || 30;
   747	    breakAutoEndTimer = setTimeout(autoEndBreak, breakLimit * 60000);
   748	  } else {
   749	    alert('Failed to start break. Please try again.');
   750	  }
   751	  btn.disabled = false;
   752	}
   753	
   754	async function handleBreakEnd() {
   755	  const btn = document.getElementById('btn-break-end');
   756	  btn.disabled = true;
   757	  clearBreakTimer();
   758	
   759	  const now = new Date();
   760	  const entry = {
   761	    uid: currentUser.uid,
   762	    name: currentUser.name || currentUser.email,
   763	    type: 'break-end',
   764	    timestamp: now.toISOString(),
   765	    date: getTodayDateStr(),
   766	    weekday: getWeekday(),
   767	    studio: (currentUser.studios && currentUser.studios[0]) || 'tinker'
   768	  };
   769	
   770	  const id = await addClockEntry(entry);
   771	  if (id) {
   772	    const lastClockIn = todayEntries
   773	      .filter(e => e.uid === currentUser.uid && e.type === 'clock-in')
   774	      .pop();
   775	    setClockStatus('clocked-in', lastClockIn ? new Date(lastClockIn.timestamp) : now);
   776	    // Resume shift-end timer (only for scheduled shifts)
   777	    if (todayShift && !(lastClockIn && lastClockIn.unscheduled)) startShiftEndTimer();
   778	  } else {
   779	    alert('Failed to end break. Please try again.');
   780	  }
   781	  btn.disabled = false;
   782	}
   783	
   784	async function autoEndBreak() {
   785	  if (currentStatus !== 'on-break') return;
   786	
   787	  const now = new Date();
   788	  const entry = {
   789	    uid: currentUser.uid,
   790	    name: currentUser.name || currentUser.email,
   791	    type: 'break-end',
   792	    timestamp: now.toISOString(),
   793	    date: getTodayDateStr(),
   794	    weekday: getWeekday(),
   795	    studio: (currentUser.studios && currentUser.studios[0]) || 'tinker',
   796	    autoEnded: true
   797	  };
   798	
   799	  const id = await addClockEntry(entry);
   800	  if (id) {
   801	    const lastClockIn = todayEntries
   802	      .filter(e => e.uid === currentUser.uid && e.type === 'clock-in')
   803	      .pop();
   804	    setClockStatus('clocked-in', lastClockIn ? new Date(lastClockIn.timestamp) : now);
   805	    if (todayShift && !(lastClockIn && lastClockIn.unscheduled)) startShiftEndTimer();
   806	  }
   807	}
   808	
   809	function clearBreakTimer() {
   810	  if (breakAutoEndTimer) {
   811	    clearTimeout(breakAutoEndTimer);
   812	    breakAutoEndTimer = null;
   813	  }
   814	}
   815	
   816	// ─── Status Management ───────────────────────────────
   817	
   818	function setClockStatus(status, since) {
   819	  currentStatus = status;
   820	  clockedInTime = since;
  4000	    // payload, which is unfakeable — rather than everything stored. An earlier version counted all
  4001	    // stored data, so it fired on ordinary saves and materially overstated what was being lost.
  4002	    //
  4003	    // This no longer needs to re-read the document. buildRecurringWrite only emits a sentinel for a day
  4004	    // that was in the open-time snapshot, so a failed load (which yields an empty snapshot) can no
  4005	    // longer delete anything at all — the hazard three rounds of guards were chasing is now impossible
  4006	    // by construction. Two of those guards were themselves disabled by the very failure they guarded
  4007	    // against; this needs no such reasoning.
  4008	    const deletedDays = Object.keys(recurring).filter(k => recurring[k] === DELETE_FIELD).length;
  4009	    const deletedDates = Object.keys(overrides).filter(k => overrides[k] === DELETE_FIELD).length;
  4010	    // Nested note sentinels are real deletions too. Counting only top-level keys made the comment's
  4011	    // claim ("what will ACTUALLY be deleted") false, and cleared notes vanished unmentioned. A cleared
  4012	    // reminder flag (`remind`/`remindUid` sentinels, same mechanism) is deliberately NOT counted: unticking
  4013	    // "email a reminder" loses nothing the employee would miss, so it earns no destructive-save confirm.
  4014	    const deletedNotes = Object.keys(overrides).filter(k => {
  4015	      const v = overrides[k];
  4016	      return v && typeof v === 'object' && v.note === DELETE_FIELD;
  4017	    }).length;
  4018	    if (deletedDays + deletedDates + deletedNotes > 0) {
  4019	      const parts = [];
  4020	      if (deletedDays) parts.push(`${deletedDays} weekly day(s)`);
  4021	      if (deletedDates) parts.push(`${deletedDates} dated change(s)`);
  4022	      if (deletedNotes) parts.push(`${deletedNotes} note(s)`);
  4023	      if (!confirm(`This removes ${parts.join(' and ')} from ${name}'s schedule. Continue?`)) {
  4024	        btn.disabled = false;
  4025	        btn.textContent = 'Save Schedule';
  4026	        return;
  4027	      }
  4028	    }
  4029	
  4030	    // omitEmptyMaps: same exception at the top level — an empty `overrides` here erased every dated
  4031	    // override on the document. Three live paths reached it empty; see the helper's comment.
  4032	    // Bounds go through the same provenance rule as recurring: a blank input clears a bound that was
  4033	    // LOADED (so a bounded schedule can be unbounded again), but is omitted when nothing was loaded — a
  4034	    // failed load renders blank date fields, and writing null there would silently strip a real range.
  4035	    const scheduleData = omitEmptyMaps(
  4036	      { name, earlyClockInMinutes, recurring, overrides,
  4037	        ...buildBoundsWrite({ validFrom, validUntil }, scheduleEditOriginalBounds) },
  4038	      ['recurring', 'overrides']);
  4039	    success = await saveSchedule(editingScheduleUid, scheduleData);
  4040	  }
  4041	
  4042	  if (success) {
  4043	    // Notify plan, Phase 4: ONE consolidated "your schedule changed" email for the dates whose shift
  4044	    // actually changed in this save, in either mode, governed by the checkbox. This REPLACES the
  4045	    // Extra-Shift confirmation (design review: with the box checked by default both would have gone out,
  4046	    // and unticking would still have sent the old one). The "after" document is the open-time snapshot
  4047	    // with the LOGICAL saved maps (gridValues, cleanOverrides — never the sentinel-laden write payloads)
  4048	    // swapped into the place the save wrote them; a wiped future is removed before diffing.
  4049	    const notifyBox = document.getElementById('schedule-notify-employee');
  4050	    if (notifyBox && notifyBox.checked) {
  4051	      const note = ((document.getElementById('schedule-notify-note') || {}).value || '').trim();
  4052	      // The grid renders start/end/studio only; a stored field the grid does not show (a note on a weekday)
  4053	      // survives the merge write, so it survives here too (implementation review).
  4054	      const savedRecurring = {};
  4055	      Object.keys(gridValues).forEach(d => { if (gridValues[d]) savedRecurring[d] = { ...(scheduleEditOriginalRecurring[d] || {}), ...gridValues[d] }; });
  4056	      const before = scheduleEditOriginalDoc || {};
  4057	      let after;
  4058	      if (window._editingFutureSchedule) {
  4059	        after = { ...before };
  4060	        if (wipedFuture) delete after.futureSchedule;
  4420	            <span style="font-weight:600; min-width:110px;">${dateLabel}</span>
  4421	            <span style="font-size:13px;">${formatTimeStr(ov.start)} \u2013 ${formatTimeStr(ov.end)}</span>
  4422	          </div>`;
  4423	        });
  4424	        html += '</div>';
  4425	      }
  4426	    }
  4427	    html += '</div>';
  4428	  }
  4429	
  4430	  document.getElementById('schedule-view-body').innerHTML = html;
  4431	  document.getElementById('schedule-view-modal').classList.add('open');
  4432	
  4433	  // Wire up Edit button
  4434	  const editBtn = document.getElementById('schedule-view-edit-btn');
  4435	  editBtn.onclick = () => {
  4436	    document.getElementById('schedule-view-modal').classList.remove('open');
  4437	    editScheduleFromList(uid);
  4438	  };
  4439	}
  4440	
  4441	async function deleteScheduleFromList(uid, name) {
  4442	  if (!confirm(`Delete schedule for ${name}? This cannot be undone.`)) return;
  4443	  const success = await deleteSchedule(uid);
  4444	  if (success) {
  4445	    await loadSchedulesData();
  4446	    renderAllSchedulesList();
  4447	  } else {
  4448	    alert('Failed to delete schedule.');
  4449	  }
  4450	}
  4451	
  4452	// ─── Schedule Helpers ────────────────────────────────
  4453	
  4454	// getShiftForDate() lives in js/schedule-helpers.js since Sep 17 2026 (one resolver, tested) — a global.
  4455	
  4456	function sortShiftsTinkerFirst(a, b) {
  4457	  // Tinker first, Clay Hub last; within same studio sort by start time
  4458	  const studioA = (a.studio || 'tinker') === 'clayhub' ? 1 : 0;
  4459	  const studioB = (b.studio || 'tinker') === 'clayhub' ? 1 : 0;
  4460	  if (studioA !== studioB) return studioA - studioB;
  4565	  btn.disabled = true;
  4566	  btn.textContent = 'Submitting...';
  4567	
  4568	  // Determine pay period for this date (semi-monthly: 1st-15th, 16th-end)
  4569	  const entryDate = new Date(date + 'T12:00:00');
  4570	  const eYear = entryDate.getFullYear();
  4571	  const eMonth = entryDate.getMonth();
  4572	  const eDay = entryDate.getDate();
  4573	  let periodStart, periodEnd;
  4574	  if (eDay <= 15) {
  4575	    periodStart = new Date(eYear, eMonth, 1);
  4576	    periodEnd = new Date(eYear, eMonth, 15);
  4577	  } else {
  4578	    periodStart = new Date(eYear, eMonth, 16);
  4579	    periodEnd = new Date(eYear, eMonth + 1, 0);
  4580	  }
  4581	  const payPeriod = formatDateStr(periodStart) + '_' + formatDateStr(periodEnd);
  4582	
  4583	  const entry = {
  4584	    uid: currentUser.uid,
  4585	    name: currentUser.name || currentUser.email,
  4586	    date,
  4587	    startTime,
  4588	    endTime,
  4589	    hours,
  4590	    note: note || undefined,
  4591	    payPeriod,
  4592	    reviewed: false
  4593	  };
  4594	
  4595	  const id = await addHfwaEntry(entry);
  4596	  if (id) {
  4597	    dateInput.value = '';
  4598	    startInput.value = '';
  4599	    endInput.value = '';
  4600	    noteInput.value = '';
  4601	    document.getElementById('hfwa-calc-hours').classList.add('hidden');
  4602	    renderMyHfwa();
  4603	    // An admin submitting their own hours is looking straight at the history below this form; leaving it
  4604	    // stale would read as a failed submission.
  4605	    renderHfwaAdmin();
  4606	    sendPushToAllAdmins('New Sick Leave Submission', `${currentUser.name || 'A staff member'} submitted ${hours}h of sick leave.`);
  4607	  } else {
  4608	    alert('Failed to submit. Please try again.');
  4609	  }
  4610	
  5595	      b.className = 'btn btn-sm btn-primary' + (wasHidden ? ' hide-mobile' : '');
  5596	    } else {
  5597	      b.className = 'btn btn-sm btn-secondary' + (wasHidden ? ' hide-mobile' : '');
  5598	    }
  5599	  });
  5600	  renderWhosWorking();
  5601	}
  5602	
  5603	// ─── Settings Save ───────────────────────────────────
  5604	
  5605	async function handleSaveSettings() {
  5606	  const catStr = document.getElementById('setting-timeoff-categories').value;
  5607	  const categories = catStr.split(',').map(s => s.trim().toLowerCase()).filter(Boolean);
  5608	
  5609	  const settings = {
  5610	    defaultEarlyClockInMinutes: parseInt(document.getElementById('setting-early-clock').value) || 15,
  5611	    breakAutoEndMinutes: parseInt(document.getElementById('setting-break-auto').value) || 30,
  5612	    extensionAlertThreshold: parseInt(document.getElementById('setting-ext-threshold').value) || 2,
  5613	    extensionIncrementMinutes: parseInt(document.getElementById('setting-ext-increment').value) || 15,
  5614	    overtimeWeeklyThreshold: parseInt(document.getElementById('setting-ot-threshold').value) || 40,
  5615	    overtimeMultiplier: parseFloat(document.getElementById('setting-ot-multiplier').value) || 1.5,
  5616	    timeoffMinNoticeDays: parseInt(document.getElementById('setting-timeoff-notice').value) || 14,
  5617	    timeoffCategories: categories.length ? categories : DEFAULT_SETTINGS.timeoffCategories
  5618	  };
  5619	
  5620	  const btn = document.getElementById('btn-save-settings');
  5621	  btn.disabled = true;
  5622	  btn.textContent = 'Saving...';
  5623	
  5624	  const success = await saveSettings(settings);
  5625	  if (success) {
  5626	    appSettings = settings;
  5627	    document.getElementById('settings-modal').classList.remove('open');
  5628	  } else {
  5629	    alert('Failed to save settings.');
  5630	  }
  5631	
  5632	  btn.disabled = false;
  5633	  btn.textContent = 'Save Settings';
  5634	}
  5635	
  5636	// ═══════════════════════════════════════════════════════
  5637	// PHASE 8: AI SCHEDULE BUILDER
  5638	// ═══════════════════════════════════════════════════════
  5639	
  5640	let aiParsedEdits = [];
  6510	    return;
  6511	  }
  6512	
  6513	  const sorted = [...employeeRoster].filter(e => e.active !== false).sort((a, b) => a.name.localeCompare(b.name));
  6514	  // Detect duplicate names: unclaimed entries that have a claimed counterpart
  6515	  const claimedNames = new Set(
  6516	    employeeRoster.filter(e => e.active !== false && e.claimedBy).map(e => (e.name || '').toLowerCase())
  6517	  );
  6518	  container.innerHTML = sorted.map(emp => {
  6519	    const status = emp.claimedBy
  6520	      ? '<span style="color:var(--green); font-size:11px; font-weight:700;">Claimed</span>'
  6521	      : '<span style="color:var(--text-light); font-size:11px;">Unclaimed</span>';
  6522	    const pinLabel = emp.pin ? 'Change PIN' : 'Set PIN';
  6523	    const pinBtn = `<button class="btn btn-sm" style="font-size:11px; padding:2px 8px;" onclick="openSetPinModal(${jsArg(emp.id)}, ${jsArg(emp.name)})"> ${pinLabel}</button>`;
  6524	    const pinStatus = emp.pin ? '<span style="font-size:11px; color:var(--teal);">PIN set</span>' : '';
  6525	    const removeBtn = `<button class="btn btn-sm" style="font-size:11px; padding:2px 8px; color:var(--red); border-color:var(--red);" onclick="removeEmployee(${jsArg(emp.id)}, ${jsArg(emp.name)})">Remove</button>`;
  6526	    // Show Merge button for unclaimed entries that have a claimed duplicate
  6527	    const isDuplicate = !emp.claimedBy && claimedNames.has((emp.name || '').toLowerCase());
  6528	    const mergeBtn = isDuplicate
  6529	      ? `<button class="btn btn-sm" style="font-size:11px; padding:2px 8px; color:var(--teal); border-color:var(--teal);" onclick="mergeDuplicateRosterEntry(${jsArg(emp.id)}, ${jsArg(emp.name)})">Merge</button>`
  6530	      : '';
  6531	    // Assign-to-user button for unclaimed entries (admin only)
  6532	    const assignBtn = !emp.claimedBy
  6533	      ? `<button class="btn btn-sm" style="font-size:11px; padding:2px 8px; color:var(--purple); border-color:var(--purple);" onclick="openAssignUserModal(${jsArg(emp.id)}, ${jsArg(emp.name)})">Assign</button>`
  6534	      : '';
  6535	    return `
  6536	      <div style="display:flex; justify-content:space-between; align-items:center; padding:6px 0; border-bottom:1px solid var(--border-light);">
  6537	        <span style="font-size:13px; font-weight:600;">${escapeHtml(emp.name)}</span>
  6538	        <div style="display:flex; align-items:center; gap:8px;">${status}${pinStatus}${pinBtn}${mergeBtn}${assignBtn}${removeBtn}</div>
  6539	      </div>`;
  6540	  }).join('');
  6541	
  6542	  renderArchivedRosterList();
  6543	  renderOrphanedSchedules();
  6544	}
  6545	
  6546	function renderArchivedRosterList() {
  6547	  const section = document.getElementById('archived-roster-section');
  6548	  const toggleBtn = document.getElementById('btn-toggle-archived-roster');
  6549	  const itemsContainer = document.getElementById('archived-roster-items');
  6550	  if (!section || !toggleBtn || !itemsContainer) return;
121:  const user = await requireAuth();
125:  await initAppFirestore();
135:  appSettings = await loadSettings();
136:  await loadSchedulesData();
146:  const needsClaim = await checkNameClaim();
150:  await loadMyStatus();
200:      await removeSubscription();
201:      await authSignOut();
475:    await doClockIn(now, todayShift.studio || 'tinker');
511:  await doClockOut(now);
587:  await trackLateClockOut();
622:    const streakDoc = await loadStreakData();
652:    await saveStreakData(updates);
675:  const id = await addClockEntry(entry);
704:  const id = await addClockEntry(entry);
740:  const id = await addClockEntry(entry);
770:  const id = await addClockEntry(entry);
799:  const id = await addClockEntry(entry);
853:  const myEntries = await getTodayEntries(currentUser.uid);
937:  const entries = await getEntriesByDateRange(startStr, endStr, currentUser.uid);
1075:  lockedPeriods = await getLockedPeriods();
1077:  const entries = await getRecentEntries(currentUser.uid, 3);
1311:    success = await addClockEntry(entry);
1549:  const success = await doClockIn(now, (currentUser.studios && currentUser.studios[0]) || 'tinker', extraFields);
1654:    const streak = await loadStreakData();
1703:    const streak = await loadStreakData();
1786:    const streak = await loadStreakData();
2091:  lockedPeriods = await getLockedPeriods();
2110:  const allEntries = await getEntriesByDateRange(period.startStr, period.endStr);
2115:    const streaksSnap = await getDb().collection('timeclock_streaks').get();
2297:  const allEntries = await getEntriesByDateRange(period.startStr, period.endStr);
2556:    ok = await updateClockEntry(entryId, updates);
2589:  const ok = await deleteClockEntry(entryId);
2625:  const id = await addClockEntry(entry);
2717:    const doc = await getDb().collection('timeclock_entries').doc(entryId).get();
2760:  const success = await updateClockEntry(entryId, updates);
2855:  const read = await getEntriesByDateRangeResult(period.startStr, period.endStr);
2869:  const rosterNow = await loadEmployeeRosterResult();
2912:  const result = await lockPayPeriod(period.key, employeeTotals, { allowEmpty: !people });
2942:  const success = await unlockPayPeriod(period.key);
2967:  const rawSchedules = await loadAllSchedules();
2971:  const rosterResult = await loadEmployeeRosterResult();
2974:    const users = await loadAllUsersResult();
3102:  await loadSchedulesData();
3130:  await loadRemindersView();
3199:  const logs = await loadReminderLogResult(from);
3392:    const r = await toggleShiftRemindersTransaction(g.docId, g.toggles, reminderUidForDoc(g.docId));
3416:    const result = await applyReminderToggles([toggle]);
3430:  await loadSchedulesData();
3431:  await loadRemindersView();
3464:    result = await applyReminderToggles(rows.map(r => ({ docId: r.docId, name: r.name, date: r.date, layer: r.layer, remind, shift: r.shift, shadowed: r.hidden })));
3468:  await loadSchedulesData();
3469:  await loadRemindersView();
3847:        const snap = await getDb().collection('timeclock_schedules').doc(editingScheduleUid).get();
4039:    success = await saveSchedule(editingScheduleUid, scheduleData);
4072:      const persisted = await loadScheduleResult(editingScheduleUid);
4085:      const outcome = await sendScheduleChangeEmail({ uid: editingScheduleUid, personName: name, changes, note });
4095:    await loadSchedulesData();
4097:    await loadRemindersView();
4247:      await loadSchedulesData();
4264:    try { allTimeoffRequests = await getAllTimeOffRequests(); } catch(e) {}
4443:  const success = await deleteSchedule(uid);
4445:    await loadSchedulesData();
4595:  const id = await addHfwaEntry(entry);
4619:  const { ok, entries } = await getMyHfwaEntriesResult(currentUser.uid);
4709:  const { ok, entries } = await getHfwaByDateRangeResult(year + '-01-01', year + '-12-31');
4850:  const recentEntries = await getEntriesByDateRange(lookbackStr, todayStr);
4854:  const pendingTimeOff = await getPendingTimeOffRequests();
4992:  const periodEntries = await getEntriesByDateRange(period.startStr, period.endStr);
5038:    const configDoc = await getDb().collection('timeclock_settings').doc('appConfig').get();
5047:    const streaksSnap = await getDb().collection('timeclock_streaks').get();
5139:    const allEntries = await getEntriesByDateRange(period.startStr, period.endStr);
5291:      const entries = await getEntriesByDateRange(dateStr, dateStr);
5624:  const success = await saveSettings(settings);
5800:    return await readEmailOutcome(res);
5857:    const r = await applyScheduleEditsTransaction(g.uid, g.edits, { remind, remindUid: remindUid || undefined });
5875:      const outcome = await sendScheduleChangeEmail({ uid: g.uid, personName: g.name, changes, note });
5882:  await loadSchedulesData();
5884:  await loadRemindersView();   // the AI tool can set flags too — the card must show them at once
5972:    await saveEmployeeRoster(employeeRoster);
5973:    await migrateSchedule(match.id, currentUser.uid);
6034:  const freshRoster = await loadEmployeeRoster();
6056:  const saved = await saveEmployeeRoster(freshRoster);
6066:  await migrateSchedule(empId, currentUser.uid);
6078:  await loadSchedulesData();
6080:  await loadMyStatus();
6107:  await loadSchedulesData();
6109:  await loadMyStatus();
6126:  let roster = await loadEmployeeRoster();
6139:    const success = await saveEmployeeRoster(roster);
6184:  const success = await saveEmployeeRoster(employeeRoster);
6462:    await loadSchedulesData();
6463:    await loadRemindersView();
6493:  const success = await setStaffPin(empId, pin);
6707:    const freshRoster = await loadEmployeeRoster();
6727:    await saveEmployeeRoster(freshRoster);
6743:  const freshUsers = await loadAllUsers();
6766:    const freshRoster = await loadEmployeeRoster();
6771:    await saveEmployeeRoster(freshRoster);
6772:    await migrateSchedule(empId, uid);
6818:  await renderMyTimeOff();
6823:    allTimeoffRequests = await getAllTimeOffRequests();
6824:    await autoCompletePassedTimeOff();
6837:  myTimeoffRequests = await getMyTimeOffRequests(currentUser.uid);
6982:    allTimeoffRequests = await getAllTimeOffRequests();
7439:    const requesterSchedule = await loadSchedule(currentUser.uid);
7466:      existingDoc = await getDb().collection('timeclock_timeoff').doc(editingTimeOffId).get();
7490:          reversal = await removeTimeOffOverrides(existingData.uid, existingData.appliedOverrides);
7506:        const subsResult = await reverseConfirmedTimeOffSubs(editingTimeOffId, existingData.proposedSubs);
7508:        const carried = await carryCurrentSubs(editingTimeOffId, formData.proposedSubs.map(s => ({ ...s, confirmed: false })));
7533:        const subsResult = await reverseConfirmedTimeOffSubs(editingTimeOffId, existingData.proposedSubs, new Set(toReverse.map(t => t.index)));
7540:            const noted = await handOffSubRemovalToManager({ id: editingTimeOffId, name: existingData.name, requestStudios: existingData.requestStudios }, stuck);
7547:        const carried = await carryCurrentSubs(editingTimeOffId, subs);
7568:      const saved = await updateTimeOffRequestIfStatus(editingTimeOffId, saveGuard.statuses, formData, saveGuard.expect);
7576:      success = await updateTimeOffRequest(editingTimeOffId, formData);
7599:    success = await addTimeOffRequest(request);
7608:    allTimeoffRequests = await getAllTimeOffRequests();
7609:    await renderTimeOffTab();
7646:    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
7853:    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
7883:    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
7895:    await updateTimeOffRequest(requestId, { comments });
7940:    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
7951:      await unconfirmTimeOffSub(req, subIndex, sub);
7970:      const result = await confirmTimeOffSub(requestId, subIndex, sub.name, { confirmed: true }, {}, { confirmed: false, subUid: null, statuses: SUB_TOGGLE_STATUSES });
7975:      allTimeoffRequests = await getAllTimeOffRequests();
8190:    const saveOk = await saveSchedule(ctx.subUid, { overrides: payload });
8215:        const fresh = await getTimeOffRequestResult(ctx.requestId);
8248:    allTimeoffRequests = await getAllTimeOffRequests();
8302:  const noted = await appendTimeOffComment(req.id, text);
8324:    const roster = await loadEmployeeRosterResult();
8328:    if (!r.ok && r.reason === 'schedule-missing') r = await reverseUnderMigratedIds(sub.subUid, record, r);
8344:      const noted = await handOffSubRemovalToManager(req, [sub.name]);
8346:      if (noted) { allTimeoffRequests = await getAllTimeOffRequests(); renderAdminAllTimeOff(); openTimeOffDetail(req.id); }
8349:    reversal = await lookUp();
8360:      reversal = await lookUp();
8368:  const result = await confirmTimeOffSub(req.id, subIndex, sub.name, patch, record, { subUid: sub.subUid || null, confirmed: true });
8374:  allTimeoffRequests = await getAllTimeOffRequests();
8419:  const result = await reverseConfirmedSubScheduleWrites(proposedSubs, onlyIndexes);
8429:    const cleared = await confirmTimeOffSub(requestId, i, sub.name, { confirmed: false, subUid: null, appliedOverrides: {} }, sub.appliedOverrides || {});
8446:    const read = await getTimeOffRequestResult(requestId);
8481:  allTimeoffRequests = await getAllTimeOffRequests();
8509:  const read = await getTimeOffRequestResult(requestId);
8514:  const roster = await loadEmployeeRosterResult();
8518:  const flagged = await findFlaggedTimeOffFor(ids);
8550:    const overlapping = await overlappingFlaggedRequest(requestId);
8573:        allTimeoffRequests = await getAllTimeOffRequests();
8580:        allTimeoffRequests = await getAllTimeOffRequests();
8594:        allTimeoffRequests = await getAllTimeOffRequests();
8606:        allTimeoffRequests = await getAllTimeOffRequests();
8622:        allTimeoffRequests = await getAllTimeOffRequests();
8666:    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
8673:      subsResult = await reverseConfirmedTimeOffSubs(requestId, requestData.proposedSubs);
8700:  allTimeoffRequests = await getAllTimeOffRequests();
8724:    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
8735:      reversal = await removeTimeOffOverrides(data.uid, data.appliedOverrides);
8740:    const subs = await reverseConfirmedTimeOffSubs(requestId, data.proposedSubs);
8758:    allTimeoffRequests = await getAllTimeOffRequests();
8759:    await renderTimeOffTab();
8792:  allTimeoffRequests = await getAllTimeOffRequests();
8816:    const doc = await getDb().collection('timeclock_timeoff').doc(requestId).get();
8824:      reversal = await removeTimeOffOverrides(data.uid, data.appliedOverrides);
8840:    allTimeoffRequests = await getAllTimeOffRequests();
8868:  allTimeoffRequests = await getAllTimeOffRequests();
8949:  const current = await getTimeOffRequestResult(requestId);
9040:      if (!r.ok && r.reason === 'schedule-missing') r = await reverseUnderMigratedIds(sub.subUid, record, r);
9046:    const cleared = await confirmTimeOffSub(requestId, i, sub.name, { confirmed: false, subUid: null, appliedOverrides: {} }, record, guard(sub, Object.keys(record).length > 0));
9059:  const moved = await findSchedulesMigratedFrom(uid);
9066:    const r = await removeTimeOffOverrides(id, appliedOverrides);
9106:    const fresh = await getTimeOffRequestResult(requestId);
9125:      const roster = await loadEmployeeRosterResult();
9129:      if (!r.ok && r.reason === 'schedule-missing') r = await reverseUnderMigratedIds(sub.subUid, sub.appliedOverrides, r);
9142:    const cleared = await confirmTimeOffSub(requestId, index, sub.name, patch, sub.appliedOverrides, guard(sub, r.ok));
9183:    const r = await loadEmployeeRosterResult();
9193:    const read = await getTimeOffRequestResult(requestId);
9213:      const fresh = await getTimeOffRequestResult(requestId);
9221:      const roster = await freshAlias(fresh.data.uid);
9228:    let roster = await freshAlias(data.uid);
9235:    let subsLeft = await retrySubReversals(requestId, data, employeeRoster);
9237:      const left = await dismissMissingSubs(requestId, subsLeft.missing);
9240:      const again = await revalidate('the coverage dialog');
9266:      const park = await updateTimeOffRequestIfStatus(requestId, RECOVERABLE, keepMarker({ reversalPending: firebase.firestore.FieldValue.delete(), reversalReason: firebase.firestore.FieldValue.delete() }), expected);
9277:        reversal = await reverseUnderMigratedIds(data.uid, data.appliedOverrides, reversal);
9294:        const again = await revalidate('the dialog');
9299:          reversal = await reverseUnderMigratedIds(data.uid, data.appliedOverrides, reversal);
9313:          allTimeoffRequests = await getAllTimeOffRequests();
9325:      const park = await updateTimeOffRequestIfStatus(requestId, RECOVERABLE, keepMarker(reversalPatch(reversal)), expected);
9329:    allTimeoffRequests = await getAllTimeOffRequests();
9358:      const success = await requestNotificationPermission();
9444:    const subscription = await getSubscriptionForUser(targetUid);
9587:    outcome = await readEmailOutcome(res);
9608:    outcome = await readEmailOutcome(res);
9649:  await initAppFirestore();
9895:  await doKioskClockIn({});
9937:      await trackLateClockIn(kioskCurrentUser.uid, now);
9944:      const streakResult = await updateKioskStreakOnClockIn(kioskCurrentUser, now);
10227:  await doKioskClockIn(extraFields);
10250:  await doKioskClockOutNow(now, false, 0, false, null);
10322:  await doKioskClockOutNow(clockOutTime, true, minsLate, minsLate >= 15, scheduledEnd);
10328:  await doKioskClockOutNow(new Date(), true, 0, false, null);
10366:      const clockOutResult = await updateKioskStreakOnClockOut(kioskCurrentUser, clockOutTime, isAutoEnded);
10577:        await updateClockEntry(entryId, { clockOutStreakAfter: restoredOutStreak });
10614:        await updateClockEntry(entryId, { clockInStreakAfter: restoredInStreak });
10634:    const doc = await getDb().collection('timeclock_streaks').doc(uid).get();
10717:    const snap = await getDb().collection('timeclock_streaks').get();
10755:    const overrideSnap = await getDb().collection('timeclock_overrides').doc(uid).get();
10797:    await getDb().collection('timeclock_overrides').doc(_adminExtendUid).delete();

exec
/bin/zsh -lc "nl -ba js/app.js | sed -n '430,615p'; nl -ba js/app.js | sed -n '1525,1570p'; rg -n \"doClock(In|Out)\\(\" js/app.js" in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
   430	  const now = new Date();
   431	
   432	  // Archived employees can no longer clock in — kiosk or self-service.
   433	  // Checked independently of todayShift/mySchedule so this holds correctly
   434	  // even before allSchedules itself excludes an archived person's schedule
   435	  // (that exclusion is a separate, later fix) — otherwise an archived person
   436	  // whose old schedule still resolves normally would slip through the
   437	  // "within window" branch below untouched.
   438	  const myRosterEntry = employeeRoster.find(e => e.id === currentUser.uid || e.claimedBy === currentUser.uid);
   439	  if (myRosterEntry && myRosterEntry.active === false) {
   440	    const gateEl = document.getElementById('gate-message');
   441	    gateEl.textContent = 'Your account has been archived. Contact an admin if you believe this is a mistake.';
   442	    gateEl.classList.remove('hidden');
   443	    setTimeout(() => gateEl.classList.add('hidden'), 8000);
   444	    return;
   445	  }
   446	
   447	  // ── Schedule-aware gate ──
   448	  if (todayShift) {
   449	    // Has a scheduled shift today — check if within allowed window
   450	    const earlyMin = (mySchedule && mySchedule.earlyClockInMinutes != null)
   451	      ? mySchedule.earlyClockInMinutes
   452	      : (appSettings.defaultEarlyClockInMinutes || 15);
   453	
   454	    const shiftStartDate = timeStrToDate(todayShift.start);
   455	    const earliestClockIn = new Date(shiftStartDate.getTime() - earlyMin * 60000);
   456	    const shiftEndDate = timeStrToDate(todayShift.end);
   457	
   458	    if (now < earliestClockIn) {
   459	      // Too early — block
   460	      const gateEl = document.getElementById('gate-message');
   461	      gateEl.textContent = `Your shift starts at ${formatTimeStr(todayShift.start)}. You can clock in at ${formatTime(earliestClockIn)}.`;
   462	      gateEl.classList.remove('hidden');
   463	      setTimeout(() => gateEl.classList.add('hidden'), 8000);
   464	      return;
   465	    }
   466	
   467	    if (now > shiftEndDate) {
   468	      // Past shift end — treat as unscheduled
   469	      openUnscheduledModal();
   470	      return;
   471	    }
   472	
   473	    // Within window — normal clock-in
   474	    btn.disabled = true;
   475	    await doClockIn(now, todayShift.studio || 'tinker');
   476	    startShiftEndTimer();
   477	    btn.disabled = false;
   478	
   479	  } else {
   480	    // No shift scheduled — open unscheduled modal
   481	    openUnscheduledModal();
   482	  }
   483	}
   484	
   485	async function handleClockOut() {
   486	  const btn = document.getElementById('btn-clock-out');
   487	  btn.disabled = true;
   488	
   489	  const now = new Date();
   490	
   491	  // Determine effective shift end (admin may have extended for today)
   492	  const effectiveEnd = todayEndOverride ? timeStrToDate(todayEndOverride) : (todayShift ? timeStrToDate(todayShift.end) : null);
   493	  const scheduledEndStr = todayEndOverride || (todayShift ? todayShift.end : null);
   494	
   495	  if (effectiveEnd) {
   496	    const msPastEnd = now.getTime() - effectiveEnd.getTime();
   497	    const GRACE_MS = 3 * 60 * 1000; // 3-minute grace window
   498	
   499	    if (msPastEnd > GRACE_MS) {
   500	      // Show late clock-out modal
   501	      btn.disabled = false;
   502	      const minsPast = Math.round(msPastEnd / 60000);
   503	      openLateClockOutModal(scheduledEndStr, effectiveEnd, now, minsPast);
   504	      return;
   505	    }
   506	  }
   507	
   508	  // Normal clock-out
   509	  clearShiftEndTimer();
   510	  clearBreakTimer();
   511	  await doClockOut(now);
   512	  btn.disabled = false;
   513	}
   514	
   515	let _lateClockOutEffectiveEnd = null;
   516	let _lateClockOutNow = null;
   517	
   518	function openLateClockOutModal(scheduledEndStr, effectiveEnd, now, minsPast) {
   519	  _lateClockOutEffectiveEnd = effectiveEnd;
   520	  _lateClockOutNow = now;
   521	
   522	  const endLabel = formatTimeStr(scheduledEndStr);
   523	  document.getElementById('late-clockout-end-time').textContent = endLabel;
   524	
   525	  // Populate time selector with options from shift end to now (every 5 min)
   526	  const select = document.getElementById('late-clockout-time-select');
   527	  select.innerHTML = '';
   528	  const start = new Date(effectiveEnd.getTime());
   529	  // Round up to nearest 5 min
   530	  const endRounded = new Date(now.getTime());
   531	
   532	  let t = new Date(start);
   533	  while (t <= endRounded) {
   534	    const hh = String(t.getHours()).padStart(2, '0');
   535	    const mm = String(t.getMinutes()).padStart(2, '0');
   536	    const timeVal = hh + ':' + mm;
   537	    const opt = document.createElement('option');
   538	    opt.value = timeVal;
   539	    opt.textContent = formatTimeStr(timeVal);
   540	    select.appendChild(opt);
   541	    t = new Date(t.getTime() + 5 * 60000);
   542	  }
   543	  // Default to shift end time (staff selects when they actually left)
   544	  select.value = scheduledEndStr.substring(0,5);
   545	
   546	  // Flag if 15+ min late
   547	  const flagEl = document.getElementById('late-clockout-flag');
   548	  if (flagEl) {
   549	    if (minsPast >= 15) {
   550	      flagEl.textContent = `Note: You're ${minsPast} minutes past your shift — this will be flagged for manager review.`;
   551	      flagEl.classList.remove('hidden');
   552	    } else {
   553	      flagEl.classList.add('hidden');
   554	    }
   555	  }
   556	
   557	  document.getElementById('late-clockout-modal').classList.add('open');
   558	}
   559	
   560	async function submitLateClockOut() {
   561	  const select = document.getElementById('late-clockout-time-select');
   562	  const selectedTime = select ? select.value : null;
   563	  if (!selectedTime || !_lateClockOutEffectiveEnd) return;
   564	
   565	  document.getElementById('late-clockout-modal').classList.remove('open');
   566	  clearShiftEndTimer();
   567	  clearBreakTimer();
   568	
   569	  // Parse selected time into a Date
   570	  const [hh, mm] = selectedTime.split(':').map(Number);
   571	  const clockOutTime = new Date(_lateClockOutNow);
   572	  clockOutTime.setHours(hh, mm, 0, 0);
   573	
   574	  // Determine if 15+ minutes late for flagging
   575	  const msLate = clockOutTime.getTime() - _lateClockOutEffectiveEnd.getTime();
   576	  const minsLate = Math.round(msLate / 60000);
   577	  const flagForReview = minsLate >= 15;
   578	
   579	  await doClockOut(clockOutTime, {
   580	    lateClockOut: true,
   581	    minutesLate: minsLate,
   582	    scheduledEnd: todayEndOverride || (todayShift ? todayShift.end : null),
   583	    flaggedForReview: flagForReview
   584	  });
   585	
   586	  // Update late clock-out streak tracking
   587	  await trackLateClockOut();
   588	
   589	  _lateClockOutEffectiveEnd = null;
   590	  _lateClockOutNow = null;
   591	}
   592	
   593	async function submitStayedLate() {
   594	  if (!_lateClockOutNow) return;
   595	
   596	  document.getElementById('late-clockout-modal').classList.remove('open');
   597	  clearShiftEndTimer();
   598	  clearBreakTimer();
   599	
   600	  const now = _lateClockOutNow;
   601	  const msLate = _lateClockOutEffectiveEnd ? now.getTime() - _lateClockOutEffectiveEnd.getTime() : 0;
   602	  const minsLate = Math.round(msLate / 60000);
   603	
   604	  await doClockOut(now, {
   605	    lateClockOut: true,
   606	    stayedLate: true,
   607	    minutesLate: minsLate,
   608	    scheduledEnd: todayEndOverride || (todayShift ? todayShift.end : null),
   609	    flaggedForReview: false // "stayed late" is intentional — no flag
   610	  });
   611	
   612	  // Don't penalize streak for intentional late stays
   613	  // (streak tracks unexcused late clock-outs, not intentional ones)
   614	
   615	  _lateClockOutEffectiveEnd = null;
  1525	}
  1526	
  1527	async function handleUnscheduledClockIn() {
  1528	  const reason = document.querySelector('input[name="unsched-reason"]:checked');
  1529	  if (!reason) { alert('Please select a reason.'); return; }
  1530	
  1531	  const now = new Date();
  1532	  let extraFields = { unscheduled: true };
  1533	
  1534	  if (reason.value === 'sub') {
  1535	    const subFor = document.getElementById('unsched-sub-for').value;
  1536	    const subClass = document.getElementById('unsched-sub-class').value.trim();
  1537	    if (!subFor) { alert('Select who you\'re subbing for.'); return; }
  1538	    extraFields.subFor = subFor;
  1539	    extraFields.subClass = subClass || undefined;
  1540	    extraFields.subNote = 'Subbing for ' + subFor + (subClass ? ' — ' + subClass : '');
  1541	  } else {
  1542	    const note = document.getElementById('unsched-note').value.trim();
  1543	    if (!note) { alert('Please describe what you\'re working on.'); return; }
  1544	    extraFields.subNote = note;
  1545	  }
  1546	
  1547	  const btn = document.getElementById('btn-unsched-confirm');
  1548	  btn.disabled = true;
  1549	  const success = await doClockIn(now, (currentUser.studios && currentUser.studios[0]) || 'tinker', extraFields);
  1550	  btn.disabled = false;
  1551	
  1552	  if (success) {
  1553	    document.getElementById('unscheduled-modal').classList.remove('open');
  1554	  }
  1555	}
  1556	
  1557	// ─── Shift Notification Timers ───────────────────────
  1558	
  1559	let shiftStartTimer = null;
  1560	
  1561	function startShiftStartTimer() {
  1562	  if (shiftStartTimer) { clearTimeout(shiftStartTimer); shiftStartTimer = null; }
  1563	  if (!todayShift || currentStatus === 'clocked-in') return;
  1564	
  1565	  const DELAY_MS = 3 * 60 * 1000; // fire 3 min after shift start (matches grace window)
  1566	  const msUntilNudge = timeStrToDate(todayShift.start).getTime() + DELAY_MS - Date.now();
  1567	  if (msUntilNudge <= 0) return; // already past — don't fire retroactively on page load
  1568	  shiftStartTimer = setTimeout(triggerShiftStart, msUntilNudge);
  1569	}
  1570	
475:    await doClockIn(now, todayShift.studio || 'tinker');
511:  await doClockOut(now);
579:  await doClockOut(clockOutTime, {
604:  await doClockOut(now, {
660:async function doClockIn(now, studio, extraFields) {
692:async function doClockOut(now, extraFields) {
1549:  const success = await doClockIn(now, (currentUser.studios && currentUser.studios[0]) || 'tinker', extraFields);

exec
/bin/zsh -lc "nl -ba /Users/christiehubley/payroll-tool/index.html | sed -n '3140,3205p'; nl -ba /Users/christiehubley/payroll-tool/index.html | sed -n '3240,3285p'; rg -n \"sickHours|lockedEntry|lockedEmployeeTotals\" /Users/christiehubley/payroll-tool/index.html | sed -n '1,120p'; rg -n \"reviewed|timeclock_hfwa|HFWA\" js/app.js | head -100" in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
  3140	          dayCounts[dayName]++;
  3141	          dayHoursMap[dayName] += dailyHours[dateStr];
  3142	        }
  3143	      });
  3144	
  3145	      // Store actual day data for schedule allocation
  3146	      const fullName = `${firstName} ${lastName}`.trim();
  3147	      newDayCounts[fullName] = dayCounts;
  3148	      newDayHours[fullName] = dayHoursMap;
  3149	
  3150	      if (totalHours > 0 || sickHours > 0) {
  3151	        const rawTotal = Math.round(totalHours * 100) / 100;
  3152	        const rawRegular = Math.round(regular * 100) / 100;
  3153	        const rawOvertime = Math.round(overtime * 100) / 100;
  3154	
  3155	        // Apply locked totals if available for this employee
  3156	        const lockedEntry = lockedEmployeeTotals ? lockedEmployeeTotals[uid] : null;
  3157	        const finalTotal = lockedEntry ? lockedEntry.totalHours : rawTotal;
  3158	        const finalRegular = lockedEntry ? lockedEntry.regular : rawRegular;
  3159	        const finalOvertime = lockedEntry ? lockedEntry.overtime : rawOvertime;
  3160	        const lockedDiff = lockedEntry ? Math.round((lockedEntry.totalHours - rawTotal) * 100) / 100 : 0;
  3161	        const lockedMatch = lockedEntry ? Math.abs(lockedDiff) <= 0.05 : null;
  3162	
  3163	        const emp = {
  3164	          uid,
  3165	          rosterId: rosterIdByUid[uid] || null,
  3166	          firstName,
  3167	          lastName,
  3168	          fullName,
  3169	          totalHours: finalTotal,
  3170	          totalPaidHours: Math.round((finalTotal + sickHours) * 100) / 100,
  3171	          regular: finalRegular,
  3172	          overtime: finalOvertime,
  3173	          overtimeX15: finalOvertime,
  3174	          jobHours: {},
  3175	          sickLeave: sickHours > 0 ? { 'HFWA Sick Leave': Math.round(sickHours * 100) / 100 } : {},
  3176	          _rawTotal: rawTotal,
  3177	          _lockedMatch: lockedMatch,
  3178	          _lockedDiff: lockedDiff
  3179	        };
  3180	        employees.push(emp);
  3181	      }
  3182	    });
  3183	
  3184	    // Sort by name
  3185	    employees.sort((a, b) => a.fullName.localeCompare(b.fullName));
  3186	
  3187	    // 6. Populate APP_STATE — only now that the read succeeded
  3188	    APP_STATE.reviewData = null;
  3189	    APP_STATE.summaryData = null;
  3190	    APP_STATE.unprocessedAcknowledged = [];
  3191	    APP_STATE.actualDayCounts = newDayCounts;
  3192	    APP_STATE.actualDayHours = newDayHours;
  3193	    APP_STATE.actualWeeklyData = null;
  3194	    APP_STATE.timeclockData = { employees, jobColumns: [], sickLeaveColumns: sickLeaveColumnsFromTimeclock(employees) };
  3195	    // Remember which settings these hours were pulled under (drives the
  3196	    // "settings changed since pull" banner on Review and Summary).
  3197	    APP_STATE.configHashAtPull = await settingsHash(buildFullConfig());
  3198	    refreshSettingsChangedBanners();
  3199	
  3200	    // HFWA detected for the HFWA tab
  3201	    APP_STATE.detectedSickLeave = employees
  3202	      .filter(e => Object.values(e.sickLeave || {}).reduce((a, b) => a + b, 0) > 0)
  3203	      .map(e => ({
  3204	        name: e.firstName,
  3205	        fullName: e.fullName,
  3240	    if (navItem) navItem.classList.add('completed');
  3241	
  3242	  } catch (err) {
  3243	    console.error('Timeclock pull failed:', err);
  3244	    statusEl.innerHTML = '<div class="alert alert-danger"><span class="alert-icon">&#9888;</span><div>Failed to pull timeclock data: ' + err.message + '</div></div>';
  3245	  }
  3246	}
  3247	
  3248	// Helper: calculate paid hours for a single day's entries (total - breaks)
  3249	function calcDayPaidHours(entries) {
  3250	  // Sort by timestamp — matches Tinker Ticker's calculateDayHours behavior
  3251	  const sorted = [...entries].sort((a, b) => new Date(a.timestamp) - new Date(b.timestamp));
  3252	
  3253	  let totalMs = 0;
  3254	  let breakMs = 0;
  3255	  let clockInTime = null;
  3256	  let breakStartTime = null;
  3257	
  3258	  sorted.forEach(e => {
  3259	    const t = new Date(e.timestamp).getTime();
  3260	    if (e.type === 'missed-shift' && e.changeRequest) {
  3261	      // Approved missed shifts: use stored in/out times (matches Tinker Ticker)
  3262	      if (e.changeRequest.status === 'approved' && e.changeRequest.requestedTimeIn && e.changeRequest.requestedTimeOut) {
  3263	        const dateStr = e.date || new Date(e.timestamp).toISOString().slice(0, 10);
  3264	        const inT = new Date(dateStr + 'T' + e.changeRequest.requestedTimeIn + ':00').getTime();
  3265	        const outT = new Date(dateStr + 'T' + e.changeRequest.requestedTimeOut + ':00').getTime();
  3266	        totalMs += outT - inT;
  3267	      }
  3268	    } else if (e.type === 'clock-in') {
  3269	      if (clockInTime !== null) {
  3270	        // Consecutive clock-in: keep first, skip duplicate (matches Tinker Ticker)
  3271	      } else {
  3272	        clockInTime = t;
  3273	      }
  3274	    } else if (e.type === 'clock-out' && clockInTime) {
  3275	      totalMs += t - clockInTime;
  3276	      clockInTime = null;
  3277	    } else if (e.type === 'break-start') {
  3278	      breakStartTime = t;
  3279	    } else if (e.type === 'break-end' && breakStartTime) {
  3280	      breakMs += t - breakStartTime;
  3281	      breakStartTime = null;
  3282	    }
  3283	  });
  3284	
  3285	  return Math.max(0, (totalMs - breakMs) / 3600000);
2197:            <div style="flex:1;"><strong>${escapeHtml(u.name)}</strong> — ${u.hours.toFixed(2)}h${u.sickHours > 0 ? ' + ' + u.sickHours.toFixed(2) + 'h sick' : ''} <span style="color:var(--gray-600);">(${escapeHtml(reason)})</span></div>
3037:    const lockedEmployeeTotals = lockedPeriodData && lockedPeriodData.employeeTotals ? lockedPeriodData.employeeTotals : null;
3124:      const sickHours = empHfwa.reduce((sum, h) => sum + (h.hours || 0), 0);
3150:      if (totalHours > 0 || sickHours > 0) {
3156:        const lockedEntry = lockedEmployeeTotals ? lockedEmployeeTotals[uid] : null;
3157:        const finalTotal = lockedEntry ? lockedEntry.totalHours : rawTotal;
3158:        const finalRegular = lockedEntry ? lockedEntry.regular : rawRegular;
3159:        const finalOvertime = lockedEntry ? lockedEntry.overtime : rawOvertime;
3160:        const lockedDiff = lockedEntry ? Math.round((lockedEntry.totalHours - rawTotal) * 100) / 100 : 0;
3161:        const lockedMatch = lockedEntry ? Math.abs(lockedDiff) <= 0.05 : null;
3170:          totalPaidHours: Math.round((finalTotal + sickHours) * 100) / 100,
3175:          sickLeave: sickHours > 0 ? { 'HFWA Sick Leave': Math.round(sickHours * 100) / 100 } : {},
3206:        sickHours: Object.values(e.sickLeave).reduce((a, b) => a + b, 0),
4503:    const hours = detected.ptoHours || detected.sickHours || 0;
163:  // Set default HFWA date to today
231:  // HFWA submit + auto-calc
236:  // HFWA admin history filters. Changing the year needs a re-query; status and view re-render what is
2728:    'changeRequest.reviewedBy': user ? user.name : 'unknown',
2729:    'changeRequest.reviewedAt': new Date().toISOString()
2790:  entries.sort((a, b) => (b.changeRequest.reviewedAt || '').localeCompare(a.changeRequest.reviewedAt || ''));
2812:    const reviewDate = req.reviewedAt ? new Date(req.reviewedAt).toLocaleDateString('en-US', { month: 'short', day: 'numeric', timeZone: 'America/Denver' }) : '';
2813:    const reviewer = req.reviewedBy || '';
4509:// PHASE 6: HFWA + ADMIN DASHBOARD
4512:// ─── HFWA Submission ─────────────────────────────────
4592:    reviewed: false
4612:  btn.textContent = 'Submit HFWA Hours';
4634:    const statusClass = e.reviewed ? 'reviewed' : 'pending';
4635:    const statusLabel = e.reviewed ? 'Reviewed' : 'Pending';
4655:// ─── Admin: HFWA History (read-only) ─────────────────
4658:// is marked reviewed and only looks back one pay period. Every submission was already stored in
4659:// timeclock_hfwa — this was a missing view, not missing data.
4663:// remaining-hours logic anywhere in it, and `reviewed` means the submission has been passed on — not
4665:// "requested" for the same reason. Read-only: marking reviewed stays on the Dashboard.
4667:const HFWA_FIRST_YEAR = 2026;   // the collection's first year — nothing exists before it
4677:  for (let y = Math.max(thisYear, HFWA_FIRST_YEAR); y >= HFWA_FIRST_YEAR; y--) years.push(y);
4681:// Christie tracks HFWA by calendar year, so the year — not the pay period — is the unit here.
4707:  // Re-read on every tab entry rather than cached across them: an entry marked reviewed on the
4708:  // Dashboard should not still read as unreviewed here.
4727:  const badge = document.getElementById('hfwa-unreviewed-count');
4729:    const unreviewed = adminHfwaLoadOk ? filterHfwaByStatus(adminHfwaEntries, 'needs_action').length : 0;
4730:    badge.textContent = unreviewed + ' unreviewed in ' + adminHfwaYear;
4731:    badge.style.display = unreviewed ? 'inline-block' : 'none';
4798:            <span class="hfwa-card-status ${e.reviewed ? 'reviewed' : 'pending'}">${e.reviewed ? 'Reviewed' : 'Needs review'}</span>
4812:          ${r.unreviewed ? `<div class="hfwa-admin-unreviewed">${r.unreviewed} still to review</div>` : ''}
4829:  // Get HFWA submissions for current AND previous pay period so submissions
4843:  const pendingHfwa = allHfwa.filter(e => !e.reviewed);
4883:  // HFWA submissions
4968:    await getDb().collection('timeclock_hfwa').doc(docId).update({
4969:      reviewed: true,
4970:      reviewedBy: (currentUser || {}).name || 'unknown',
4971:      reviewedAt: new Date().toISOString()
4977:    console.error('Failed to mark HFWA reviewed:', err);
7592:      reviewedAt: null,
7593:      reviewedBy: null,
7764:  if (req.reviewedBy) {
7765:    html += ` &middot; Reviewed by ${escapeHtml(req.reviewedBy)}`;
8631:          reason: data.reason, reviewedBy: currentUser.name || currentUser.email, studios: resolveRequesterStudios(data),
8683:    reviewedAt: new Date().toISOString(),
8684:    reviewedBy: currentUser.name || currentUser.email,
8711:      reviewedBy: currentUser.name || currentUser.email, studios: resolveRequesterStudios(requestData),
8851:      reviewedBy: currentUser.name || currentUser.email, studios: resolveRequesterStudios(data),
9599:async function sendTimeOffStatusEmail({ status, previousStatus, reversalPending, reversalReason, requesterEmail, requesterName, dates, reason, denialReason, reviewedBy, studios }, toastLabel) {
9606:      body: JSON.stringify({ status, previousStatus, reversalPending, reversalReason, requesterEmail, requesterName, dates, reason, denialReason, reviewedBy, studios })

exec
/bin/zsh -lc 'tail -n 100 js/schedule-helpers.js | nl -ba -v $(( $(wc -l < js/schedule-helpers.js) - 99 )); nl -ba js/app.js | sed -n '"'1060,1090p'; nl -ba js/app.js | sed -n '2070,2130p'; nl -ba js/app.js | sed -n '2280,2310p'; nl -ba js/app.js | sed -n '4945,4985p'" in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
  1591	function jsArg(v) {
  1592	  return escapeAttr(JSON.stringify(v == null ? '' : String(v)));
  1593	}
  1594	
  1595	// A finite number, or the caller's own fallback — never a coerced 0 that would hide a placeholder ('—', '').
  1596	// Rejects '', null, undefined, NaN, ±Infinity and anything that is not a number or numeric string.
  1597	function finiteOr(v, fallback) {
  1598	  if (typeof v !== 'number' && typeof v !== 'string') return fallback;   // true → 1, [5] → 5: not counts
  1599	  if (typeof v === 'string' && v.trim() === '') return fallback;
  1600	  const n = Number(v);
  1601	  return Number.isFinite(n) ? n : fallback;
  1602	}
  1603	
  1604	if (typeof module !== 'undefined' && module.exports) {
  1605	  module.exports = {
  1606	    escapeAttr,
  1607	    jsArg,
  1608	    finiteOr,
  1609	    mergePendingTimeOff,
  1610	    resolveScheduleAlias,
  1611	    getShiftForDate,
  1612	    isInFutureWindow,
  1613	    dayKeyForDate,
  1614	    normaliseShift,
  1615	    sameShift,
  1616	    diffScheduleDates,
  1617	    selectRemindersDue,
  1618	    activeOverridesFor,
  1619	    countFlaggedDates,
  1620	    denverNow,
  1621	    addCalendarDays,
  1622	    reminderWindow,
  1623	    reminderNextRunDate,
  1624	    reminderPromiseCutoff,
  1625	    reminderPromiseDates,
  1626	    stampReminderUids,
  1627	    isSendTime,
  1628	    SEND_FROM_HOUR,
  1629	    REMINDER_MAX_ATTEMPTS,
  1630	    REMINDER_STALE_CLAIM_MS,
  1631	    REMINDER_CLAIM_EXPIRY_MS,
  1632	    REMINDER_HISTORY_DAYS,
  1633	    reminderRecipientUid,
  1634	    reminderLogId,
  1635	    listReminderRows,
  1636	    orphanLogRows,
  1637	    reminderRowStatus,
  1638	    planReminderToggles,
  1639	    restampReminderUids,
  1640	    countFlaggedDatesWithoutAccount,
  1641	    CLEARABLE_OVERRIDE_KEYS,
  1642	    REMINDER_KEYS,
  1643	    stripReminderKeys,
  1644	    sameOverrideValue,
  1645	    applyScheduleEdits,
  1646	    isRealDate,
  1647	    carryConfirmedSubs,
  1648	    unconfirmedSubNames,
  1649	    confirmDatePreticks,
  1650	    normalizeRequestDates,
  1651	    checkEditAgainstDocument,
  1652	    subMissingWriteNote,
  1653	    partitionRollback,
  1654	    sameStructure,
  1655	    buildShiftDetail,
  1656	    filterHfwaByStatus,
  1657	    summariseHfwaByPerson,
  1658	    resolveOverrideRestore,
  1659	    scheduleSignature,
  1660	    buildBoundsWrite,
  1661	    findHalfFilledDays,
  1662	    hasNoWeekdays,
  1663	    clearsEverything,
  1664	    commitOverrideEdit,
  1665	    buildRecurringWrite,
  1666	    buildOverridesWrite,
  1667	    resolveReminderRecipient,
  1668	    resolveReminderUid,
  1669	    omitEmptyMaps,
  1670	    resolveScheduleTarget,
  1671	    partitionSchedulesByRosterActive,
  1672	    countUpcomingOverrides,
  1673	    countOverridesFromDate,
  1674	    splitOverridesByDate,
  1675	    parseFutureScheduleCsv,
  1676	    resolveFutureScheduleTargets,
  1677	    rangesOverlap,
  1678	    resolveRequestStudios,
  1679	    resolveSubRosterMatch,
  1680	    getSubCoverageDates,
  1681	    buildSubScheduleOverride,
  1682	    getNormalRecurringShift,
  1683	    reconcileEditedProposedSubs,
  1684	    reminderAttentionSummary,
  1685	    shadowedReminderDates,
  1686	    findMalformedTotal,
  1687	    REMINDER_ATTENTION_LABELS,
  1688	    REMINDER_ATTENTION_SEVERE,
  1689	  };
  1690	}
  1060	  const sep = ciChip && coChip ? '<span class="streak-sep">·</span>' : '';
  1061	  return `<div class="my-hours-streak-row">${ciChip}${sep}${coChip}</div>`;
  1062	}
  1063	
  1064	// ─── Recent Entries + Change Requests (Staff) ────────
  1065	
  1066	let myHoursWeekOffset = 0;
  1067	
  1068	let crTargetEntryId = null;
  1069	let crTargetEntryType = null;
  1070	
  1071	async function loadRecentEntries() {
  1072	  const container = document.getElementById('recent-entries-list');
  1073	  if (!container) return;
  1074	
  1075	  lockedPeriods = await getLockedPeriods();
  1076	
  1077	  const entries = await getRecentEntries(currentUser.uid, 3);
  1078	  if (!entries.length) {
  1079	    container.innerHTML = '<div class="no-entries">No entries in the last 3 days</div>';
  1080	    return;
  1081	  }
  1082	
  1083	  // Group by date
  1084	  const byDate = {};
  1085	  entries.forEach(e => {
  1086	    if (!byDate[e.date]) byDate[e.date] = [];
  1087	    byDate[e.date].push(e);
  1088	  });
  1089	
  1090	  const today = getTodayDateStr();
  2070	// ─── Timesheet Listeners ────────────────────────────────────
  2071	
  2072	function initTimesheetListeners() {
  2073	  document.getElementById('admin-ts-prev').addEventListener('click', () => {
  2074	    adminTsPeriodOffset--;
  2075	    renderAdminTimesheets();
  2076	  });
  2077	  document.getElementById('admin-ts-next').addEventListener('click', () => {
  2078	    adminTsPeriodOffset++;
  2079	    renderAdminTimesheets();
  2080	  });
  2081	  document.getElementById('btn-lock-period').addEventListener('click', handleLockPeriod);
  2082	}
  2083	
  2084	// ─── Admin Timesheets ────────────────────────────────
  2085	
  2086	async function renderAdminTimesheets() {
  2087	  const period = getPayPeriod(adminTsPeriodOffset);
  2088	  document.getElementById('admin-ts-period-label').textContent = period.label;
  2089	
  2090	  // Check lock status
  2091	  lockedPeriods = await getLockedPeriods();
  2092	  const isLocked = !!lockedPeriods[period.key];
  2093	  const lockEl = document.getElementById('admin-ts-lock-status');
  2094	  const lockBtn = document.getElementById('btn-lock-period');
  2095	  if (isLocked) {
  2096	    const lockInfo = lockedPeriods[period.key];
  2097	    const lockedOn = new Date(lockInfo.lockedAt).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric', timeZone: 'America/Denver' });
  2098	    lockEl.innerHTML = `This pay period is locked. ${escapeHtml(lockInfo.lockedBy || '')} locked it on ${escapeHtml(lockedOn)}` +
  2099	      ` &nbsp;<button onclick="handleUnlockPeriod(${jsArg(period.key)})" style="background:none; border:1px solid var(--amber); border-radius:4px; color:var(--amber); font-size:11px; font-weight:600; padding:2px 8px; cursor:pointer; margin-left:4px;">Unlock Period</button>`;
  2100	    lockEl.classList.remove('hidden');
  2101	    lockBtn.disabled = true;
  2102	    lockBtn.textContent = 'Locked';
  2103	  } else {
  2104	    lockEl.classList.add('hidden');
  2105	    lockBtn.disabled = false;
  2106	    lockBtn.textContent = 'Lock Period';
  2107	  }
  2108	
  2109	  // Load all entries for period
  2110	  const allEntries = await getEntriesByDateRange(period.startStr, period.endStr);
  2111	
  2112	  // Load all streak data upfront (one query)
  2113	  const streaksByUid = {};
  2114	  try {
  2115	    const streaksSnap = await getDb().collection('timeclock_streaks').get();
  2116	    streaksSnap.forEach(doc => { streaksByUid[doc.id] = doc.data(); });
  2117	  } catch (e) {}
  2118	
  2119	  // Group by uid
  2120	  const byUid = {};
  2121	  allEntries.forEach(e => {
  2122	    if (!byUid[e.uid]) byUid[e.uid] = { name: e.name, entries: [] };
  2123	    byUid[e.uid].entries.push(e);
  2124	  });
  2125	
  2126	  // Merge emp_ temp-ID entries into their claimed user's group
  2127	  employeeRoster.forEach(emp => {
  2128	    if (emp.claimedBy && byUid[emp.id]) {
  2129	      if (byUid[emp.claimedBy]) {
  2130	        byUid[emp.claimedBy].entries.push(...byUid[emp.id].entries);
  2280	            <span><strong>${total.toFixed(2)}h</strong> total</span>
  2281	            ${ot.overtime > 0 ? '<span style="color:var(--orange);">' + ot.overtime.toFixed(2) + 'h OT</span>' : ''}
  2282	            ${flagText}
  2283	          </div>
  2284	        </div>
  2285	        <div class="admin-ts-body">
  2286	          ${streakRow}
  2287	          ${dayRows || '<div class="empty-state">No entries</div>'}
  2288	        </div>
  2289	      </div>`;
  2290	  }).join('');
  2291	}
  2292	
  2293	// ─── Export Timesheets (.xlsx) ───────────────────────
  2294	
  2295	async function exportTimesheetsXlsx() {
  2296	  const period = getPayPeriod(adminTsPeriodOffset);
  2297	  const allEntries = await getEntriesByDateRange(period.startStr, period.endStr);
  2298	
  2299	  // Group by uid (same logic as renderAdminTimesheets)
  2300	  const byUid = {};
  2301	  allEntries.forEach(e => {
  2302	    if (!byUid[e.uid]) byUid[e.uid] = { name: e.name, entries: [] };
  2303	    byUid[e.uid].entries.push(e);
  2304	  });
  2305	  employeeRoster.forEach(emp => {
  2306	    if (emp.claimedBy && byUid[emp.id]) {
  2307	      if (byUid[emp.claimedBy]) {
  2308	        byUid[emp.claimedBy].entries.push(...byUid[emp.id].entries);
  2309	      } else {
  2310	        byUid[emp.claimedBy] = { name: emp.name || byUid[emp.id].name, entries: byUid[emp.id].entries };
  4945	    html += pendingSection('timeoff', 'Time Off Requests', pendingTimeOff.length, toHtml);
  4946	  }
  4947	
  4948	  container.innerHTML = html;
  4949	}
  4950	
  4951	function togglePendingSection(id) {
  4952	  const body = document.getElementById('body-' + id);
  4953	  const arrow = document.getElementById('arrow-' + id);
  4954	  if (!body) return;
  4955	  const isOpen = !body.classList.contains('collapsed');
  4956	  if (isOpen) {
  4957	    body.classList.add('collapsed');
  4958	    arrow.innerHTML = '&#9654;'; // right arrow
  4959	  } else {
  4960	    body.classList.remove('collapsed');
  4961	    arrow.innerHTML = '&#9660;'; // down arrow
  4962	  }
  4963	}
  4964	
  4965	async function markHfwaReviewed(docId) {
  4966	  if (!_ready) return;
  4967	  try {
  4968	    await getDb().collection('timeclock_hfwa').doc(docId).update({
  4969	      reviewed: true,
  4970	      reviewedBy: (currentUser || {}).name || 'unknown',
  4971	      reviewedAt: new Date().toISOString()
  4972	    });
  4973	    renderDashboardPending();
  4974	    // Keep the Sick Leave history in step if it has already been opened this session.
  4975	    if (adminHfwaYear !== null) renderHfwaAdmin();
  4976	  } catch (err) {
  4977	    console.error('Failed to mark HFWA reviewed:', err);
  4978	    alert('Failed to update. Please try again.');
  4979	  }
  4980	}
  4981	
  4982	let _dashboardAlerts = [];
  4983	
  4984	async function renderDashboardAlerts() {
  4985	  const container = document.getElementById('alerts-list');

exec
/bin/zsh -lc "rg -n \"function isRealDate\" js/schedule-helpers.js; nl -ba js/schedule-helpers.js | sed -n '520,555p'; rg -n \"function setStaffPin|async function setStaffPin\" js/firebase-data.js js/app.js; nl -ba js/firebase-data.js | sed -n '500,575p'" in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
904:function isRealDate(dateStr) {
   520	    if (!map || typeof map !== 'object') return map;
   521	    const out = { ...map };
   522	    Object.keys(out).forEach(d => {
   523	      const v = out[d];
   524	      if (v && typeof v === 'object' && v.remind === true && !(typeof v.remindUid === 'string' && v.remindUid)) out[d] = { ...v, remindUid: uid };
   525	    });
   526	    return out;
   527	  };
   528	  const out = { ...data };
   529	  if (out.overrides) out.overrides = stamp(out.overrides);
   530	  if (out.futureSchedule && typeof out.futureSchedule === 'object' && out.futureSchedule.overrides) {
   531	    out.futureSchedule = { ...out.futureSchedule, overrides: stamp(out.futureSchedule.overrides) };
   532	  }
   533	  return out;
   534	}
   535	
   536	// The job sends from 9 AM Denver onward — every hourly tick from then is a retry of anything unclaimed,
   537	// so a lost tick delays a reminder instead of losing it. One place, so the view and the job agree.
   538	const SEND_FROM_HOUR = 9;
   539	function isSendTime(hour) {
   540	  return Number.isInteger(hour) && hour >= SEND_FROM_HOUR;
   541	}
   542	
   543	// ─── "48-hour shift reminders" plan, Phase 4 — the Reminders view's pure core ─────────────────────────
   544	// The view is one table of every dated shift across all staff, with what the job will do for each. The
   545	// three functions below are the whole of its logic; app.js only renders them and calls the transaction.
   546	
   547	// A claim's bounded retries (the rules cap `attempts` at 3 too). Shared with the job (Phase 5).
   548	const REMINDER_MAX_ATTEMPTS = 3;
   549	// An unresolved claim older than this is presumed dead (a run killed by Netlify's 30 s limit): the job
   550	// re-claims it at its next tick, and the view says "stale claim" rather than "sending…". Shared with the job.
   551	const REMINDER_STALE_CLAIM_MS = 10 * 60 * 1000;
   552	// Resend keeps an idempotency key for 24 h. An unresolved claim older than that cannot be retried safely —
   553	// a re-send would no longer be deduplicated if the first one did go out — so the job leaves it and the view
   554	// says "needs a look" (Phase 5 review). Shared with the job.
   555	const REMINDER_CLAIM_EXPIRY_MS = 24 * 60 * 60 * 1000;
js/app.js:6469:async function setStaffPin(empId, pin) {
   500	// composite index. { ok, requests }.
   501	async function findFlaggedTimeOffFor(uids) {
   502	  const list = (uids || []).filter(Boolean);
   503	  if (!_ready || !list.length) return { ok: false, requests: [] };
   504	  try {
   505	    const snap = await _db.collection('timeclock_timeoff')
   506	      .where('uid', 'in', list.slice(0, 10))
   507	      .where('reversalPending', '==', true)
   508	      .get();
   509	    return { ok: true, requests: snap.docs.map(d => ({ id: d.id, ...d.data() })) };
   510	  } catch (err) {
   511	    console.error('Failed to query flagged time off requests:', err);
   512	    return { ok: false, requests: [] };
   513	  }
   514	}
   515	
   516	async function saveEmployeeRoster(roster) {
   517	  if (!_ready) return false;
   518	  try {
   519	    await _db.collection('timeclock_settings').doc('employees').set({
   520	      roster,
   521	      updatedAt: new Date().toISOString()
   522	    });
   523	    return true;
   524	  } catch (err) {
   525	    console.error('Failed to save employee roster:', err);
   526	    return false;
   527	  }
   528	}
   529	
   530	async function migrateSchedule(oldId, newUid) {
   531	  if (!_ready) return false;
   532	  try {
   533	    const oldDoc = await _db.collection('timeclock_schedules').doc(oldId).get();
   534	    if (!oldDoc.exists) return true; // nothing to migrate
   535	    const data = oldDoc.data();
   536	    // Reminder flags stamped before this person claimed an account carry no remindUid; the copy names it
   537	    // ("48-hour shift reminders" plan, Phase 4 — the one place the account becomes known).
   538	    await _db.collection('timeclock_schedules').doc(newUid).set({
   539	      ...stampReminderUids(data, newUid),
   540	      uid: newUid,
   541	      migratedFrom: oldId,
   542	      migratedFromChain: migrationChain(data, oldId),
   543	      migratedAt: new Date().toISOString()
   544	    });
   545	    await _db.collection('timeclock_schedules').doc(oldId).delete();
   546	    return true;
   547	  } catch (err) {
   548	    console.error('Failed to migrate schedule:', err);
   549	    return false;
   550	  }
   551	}
   552	
   553	// ─── Settings ────────────────────────────────────────
   554	
   555	const DEFAULT_SETTINGS = {
   556	  breakAutoEndMinutes: 30,
   557	  extensionAlertThreshold: 2,
   558	  extensionIncrementMinutes: 10,
   559	  defaultEarlyClockInMinutes: 15,
   560	  overtimeWeeklyThreshold: 40,
   561	  overtimeMultiplier: 1.5,
   562	  timeoffMinNoticeDays: 14,
   563	  timeoffCategories: ['wedding', 'family', 'personal', 'medical', 'travel', 'other']
   564	};
   565	
   566	async function loadSettings() {
   567	  if (!_ready) return { ...DEFAULT_SETTINGS };
   568	  try {
   569	    const doc = await _db.collection('timeclock_settings').doc('appConfig').get();
   570	    return doc.exists ? { ...DEFAULT_SETTINGS, ...doc.data() } : { ...DEFAULT_SETTINGS };
   571	  } catch (err) {
   572	    console.error('Failed to load settings:', err);
   573	    return { ...DEFAULT_SETTINGS };
   574	  }
   575	}

exec
/bin/zsh -lc "nl -ba js/schedule-helpers.js | sed -n '894,918p'; nl -ba js/app.js | sed -n '6440,6510p'" in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
   894	// EACH DATE is routed by that date's future-window membership (the map getShiftForDate reads for it),
   895	// not by whether the future is active today — the previous AI save routed the whole batch by today, so
   896	// a date inside an upcoming window was written where the app never looks (design review, Sep 17).
   897	// Validation: a date key must be a REAL calendar date (2026-02-31 is rejected, not normalised); a value must
   898	// be null, or carry start AND end as H:MM / HH:MM (zero-padded on the way in) with a known studio; a shift
   899	// note is capped. `_type` is the model's own annotation and is stripped.
   900	const HM_RE = /^(\d{1,2}):([0-5]\d)$/;
   901	const YMD_RE = /^\d{4}-\d{2}-\d{2}$/;
   902	const STUDIOS = ['tinker', 'clayhub'];
   903	const MAX_SHIFT_NOTE = 200;
   904	function isRealDate(dateStr) {
   905	  if (!YMD_RE.test(dateStr)) return false;
   906	  const d = new Date(dateStr + 'T12:00:00');
   907	  if (Number.isNaN(d.getTime())) return false;
   908	  const back = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
   909	  return back === dateStr;
   910	}
   911	function toHHMM(v) {
   912	  const m = HM_RE.exec(typeof v === 'string' ? v.trim() : '');
   913	  if (!m || Number(m[1]) > 23) return null;
   914	  return `${m[1].padStart(2, '0')}:${m[2]}`;
   915	}
   916	// `opts` ("48-hour shift reminders" plan, Phase 1): { remind, remindUid }. Reminder mode is SET when
   917	// `remind === true` — every non-null value written carries `remind: true` and `remindUid` (the account to
   918	// email; the caller resolves it, one document is one person) — and PRESERVE otherwise: a value written over
  6440	        if (scheduleSignature(nowFuture) !== scheduleSignature(entry.existingFuture)) {
  6441	          throw new Error('their future schedule changed since the dry run — run the dry run again');
  6442	        }
  6443	        tx.set(ref, payload, { merge: true });
  6444	      });
  6445	      entry.status = 'written';
  6446	      futureCsvLog(`✓ ${entry.name} (${entry.rosterName}) → futureSchedule updated`);
  6447	      written++;
  6448	    } catch (err) {
  6449	      entry.status = 'write-failed';
  6450	      entry.reason = err.message;
  6451	      futureCsvLog(`✗ ${entry.name} — write failed: ${err.message}`);
  6452	      failed++;
  6453	    }
  6454	  }
  6455	
  6456	  futureCsvLog(`\nDone. ${written} written, ${failed} failed.`);
  6457	  renderFutureCsvTable(futureCsvPlan);
  6458	  showToast(`Future schedule import: ${written} written${failed ? `, ${failed} failed` : ''}.`);
  6459	  // This import writes futureSchedule bounds, which is one of the ways a flagged shift becomes hidden — the
  6460	  // Reminders card must not keep showing pre-import flags until someone presses Refresh (design review, Sep 22).
  6461	  if (written) {
  6462	    await loadSchedulesData();
  6463	    await loadRemindersView();
  6464	  }
  6465	}
  6466	
  6467	// ─── PIN Management (Kiosk) ──────────────────────────
  6468	
  6469	async function setStaffPin(empId, pin) {
  6470	  // PINs stored on the roster entry so unclaimed staff can use the kiosk too
  6471	  const db = getDb();
  6472	  if (!db) return false;
  6473	  try {
  6474	    const roster = employeeRoster.map(e =>
  6475	      e.id === empId ? { ...e, pin } : e
  6476	    );
  6477	    await db.collection('timeclock_settings').doc('employees').update({ roster });
  6478	    employeeRoster = roster; // update local cache
  6479	    return true;
  6480	  } catch (err) {
  6481	    console.error('Failed to set PIN:', err);
  6482	    return false;
  6483	  }
  6484	}
  6485	
  6486	async function openSetPinModal(empId, name) {
  6487	  const pin = prompt(`Set PIN for ${name} (4 digits):`);
  6488	  if (pin === null) return;
  6489	  if (!/^\d{4}$/.test(pin)) {
  6490	    alert('PIN must be exactly 4 digits.');
  6491	    return;
  6492	  }
  6493	  const success = await setStaffPin(empId, pin);
  6494	  if (success) {
  6495	    showToast(`PIN set for ${name}`);
  6496	    renderRosterList();
  6497	  } else {
  6498	    alert('Failed to set PIN.');
  6499	  }
  6500	}
  6501	
  6502	// ─── Roster List in Settings ─────────────────────────
  6503	
  6504	function renderRosterList() {
  6505	  const container = document.getElementById('roster-list');
  6506	  if (!container) return;
  6507	
  6508	  if (!employeeRoster.length) {
  6509	    container.innerHTML = '<div class="empty-state">No employees in roster. Use "Seed Employees" to get started.</div>';
  6510	    return;

codex
I found two scope gaps that can affect payroll even if every planned clock-entry transaction is implemented: HFWA hours remain mutable after lock, and roster identity changes can change how locked totals are keyed/applied. I’m validating the transaction semantics and then I’ll give the final severity-ranked review.
web search: 
web search: site:firebase.google.com/docs/firestore/manage-data/transactions web transactions fail offline retry concurrent edit transaction reads writes ...
exec
/bin/zsh -lc "nl -ba /Users/christiehubley/studio-hub/firestore.rules | sed -n '450,520p'; nl -ba js/app.js | sed -n '2825,2925p'" in /Users/christiehubley/tinker-timeclock
 succeeded in 0ms:
   450	    // TIMECLOCK
   451	    // All timeclock collections require appAccess('timeclock') for
   452	    // staff. Manager+ always has full access to everything.
   453	    //
   454	    // entries:   Staff with access — own entries only (read/create/update)
   455	    // schedules: Staff with access — read-only; manager+ write
   456	    // hfwa:      Staff with access — own doc only (create/read)
   457	    // timeoff:   Staff with access — own doc only (create/read/update)
   458	    // settings:  Staff with access — read-only; manager+ write
   459	    // streaks:   Staff with access — own doc only (read/write)
   460	    // ═══════════════════════════════════════════════════════════════
   461	
   462	    match /timeclock_entries/{docId} {
   463	      allow read, write: if isManagerOrAbove();
   464	      // Kiosk: read + create entries (needs to read today's status after PIN entry)
   465	      allow read, create: if isKiosk();
   466	      // Staff with access: own entries only
   467	      allow create: if hasAppAccess('timeclock')
   468	        && request.resource.data.uid == request.auth.uid;
   469	      allow read: if hasAppAccess('timeclock')
   470	        && resource.data.uid == request.auth.uid;
   471	      allow update: if hasAppAccess('timeclock')
   472	        && resource.data.uid == request.auth.uid;
   473	    }
   474	
   475	    match /timeclock_schedules/{uid} {
   476	      allow read, write: if isManagerOrAbove();
   477	      // Staff with access: read-only
   478	      allow read: if hasAppAccess('timeclock');
   479	      // Kiosk: read schedules (to detect late clock-outs)
   480	      allow read: if isKiosk();
   481	      // Reminder bot: read every schedule (list + get) to find flagged shifts; never write.
   482	      allow read: if isReminderBot();
   483	    }
   484	
   485	    match /timeclock_hfwa/{docId} {
   486	      allow read, write: if isManagerOrAbove();
   487	      // Staff with access: own doc only
   488	      allow create: if hasAppAccess('timeclock')
   489	        && request.resource.data.uid == request.auth.uid;
   490	      allow read: if hasAppAccess('timeclock')
   491	        && resource.data.uid == request.auth.uid;
   492	    }
   493	
   494	    match /timeclock_timeoff/{docId} {
   495	      allow read, write: if isManagerOrAbove();
   496	      // Staff with access: own doc only
   497	      allow create: if hasAppAccess('timeclock')
   498	        && request.resource.data.uid == request.auth.uid;
   499	      allow read: if hasAppAccess('timeclock')
   500	        && resource.data.uid == request.auth.uid;
   501	      allow update: if hasAppAccess('timeclock')
   502	        && resource.data.uid == request.auth.uid;
   503	    }
   504	
   505	    match /timeclock_settings/{docId} {
   506	      allow read, write: if isManagerOrAbove();
   507	      // Staff with access: read-only
   508	      allow read: if hasAppAccess('timeclock');
   509	      // Staff can write the employees doc for name claiming
   510	      allow write: if hasAppAccess('timeclock') && docId == 'employees';
   511	      // adminSubscriptions: any authenticated user can read (needed for staff→admin push)
   512	      allow read: if isAuthenticated() && docId == 'adminSubscriptions';
   513	      // Kiosk: read employees (PIN lookup) and schedules
   514	      allow read: if isKiosk();
   515	    }
   516	
   517	    match /timeclock_streaks/{uid} {
   518	      allow read, write: if isManagerOrAbove();
   519	      // Staff with access: own doc only
   520	      allow read, write: if hasAppAccess('timeclock')
  2825	          Reason: ${escapeHtml(req.reason || '')} ${reviewer ? '· Reviewed by ' + escapeHtml(reviewer) + (reviewDate ? ' on ' + reviewDate : '') : ''}
  2826	        </div>
  2827	      </div>`;
  2828	  }).join('');
  2829	}
  2830	
  2831	let changeLogOpen = false;
  2832	function toggleChangeLog() {
  2833	  const list = document.getElementById('change-log-list');
  2834	  const toggle = document.getElementById('change-log-toggle');
  2835	  changeLogOpen = !changeLogOpen;
  2836	  if (changeLogOpen) {
  2837	    list.classList.remove('hidden');
  2838	    toggle.textContent = 'Hide';
  2839	  } else {
  2840	    list.classList.add('hidden');
  2841	    toggle.textContent = 'Show';
  2842	  }
  2843	}
  2844	
  2845	async function handleLockPeriod() {
  2846	  const period = getPayPeriod(adminTsPeriodOffset);
  2847	
  2848	  // READ FIRST, CONFIRM SECOND. The old order confirmed a period LABEL, then read fresh data and stored
  2849	  // totals the manager never saw — the defect this change is named after. It survived three rounds of
  2850	  // patches because each one guarded the reads rather than the ORDER: whatever those reads returned was
  2851	  // still written on the strength of a confirmation given before they ran (round-four review, Sep 28).
  2852	  //
  2853	  // Reading first also means the confirm can state what will actually be stored, computed from exactly the
  2854	  // data that will be stored, with no window in between.
  2855	  const read = await getEntriesByDateRangeResult(period.startStr, period.endStr);
  2856	  if (!read.ok) {
  2857	    alert('Could not read this period\u2019s entries, so nothing was locked. Check your connection and try again.');
  2858	    return;
  2859	  }
  2860	  // A cache-served read RESOLVES, so `ok` alone would let a dropped connection lock stale hours.
  2861	  if (read.fromCache) {
  2862	    alert('These hours came from your device\u2019s offline copy, not the server, so they may be out of date. Nothing was locked \u2014 reconnect and try again.');
  2863	    return;
  2864	  }
  2865	  // The roster decides whether a person's kiosk (emp_) entries merge into their account, so it changes the
  2866	  // ATTRIBUTION of the snapshot. A missing roster document is NOT an error: a studio that has never seeded
  2867	  // one has valid uid-keyed hours and nothing to merge — calcPeriodTotals' merge is simply a no-op
  2868	  // (round-four review; an earlier version refused this and would have blocked first-run payroll).
  2869	  const rosterNow = await loadEmployeeRosterResult();
  2870	  if (!rosterNow.ok || rosterNow.fromCache) {
  2871	    alert('The employee roster could not be read from the server, so hours might not be attributed to the right people. Nothing was locked \u2014 try again.');
  2872	    return;
  2873	  }
  2874	
  2875	  const employeeTotals = calcPeriodTotals(read.entries, rosterNow.roster);
  2876	
  2877	  // Check the snapshot BEFORE asking anyone to approve it. Validating only in lockPayPeriod meant the
  2878	  // summary counted a malformed person as zero hours — `Number(NaN) || 0` — so the manager confirmed
  2879	  // "2 people, 8 hours" and only then was the write refused. The confirmation itself was false, which is
  2880	  // the exact defect this whole change exists to remove (Codex, round five).
  2881	  const bad = findMalformedTotal(employeeTotals);
  2882	  if (bad) {
  2883	    // Describe the CALCULATION, not the screen: these totals come from a fresh read, so the card on screen
  2884	    // may have been drawn from different data and need not show the same thing. An earlier version pointed
  2885	    // at a "red row" that is never drawn; the one after it asserted a card state that can be stale.
  2886	    const who = bad.name || 'One employee';
  2887	    const others = bad.count > 1 ? ` (and ${bad.count - 1} other${bad.count === 2 ? '' : 's'})` : '';
  2888	    // Name the DAY. "Fix that entry" is the instruction, so the message has to be able to locate it — and
  2889	    // the on-screen symptom cannot: a bad clock-OUT renders as "9:00 AM – …" with "-" hours, which looks
  2890	    // exactly like an open punch and says nothing about which day (Claude, round five). The day IS knowable:
  2891	    // calcPeriodTotals already reduces per-date hours, so recompute them for this one person and find the
  2892	    // first date that is not finite.
  2893	    const day = findBadDayForUid(read.entries, bad.uid);
  2894	    const where = day
  2895	      ? ` on ${new Date(day + 'T12:00:00').toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric' })}`
  2896	      : ' in this period';
  2897	    alert(`${who}${others} has hours${where} that did not calculate to a valid number \u2014 usually a clock entry with a time the app cannot read. Nothing was locked. Refresh, open that day\u2019s entries, fix the bad time, then lock again.`);
  2898	    return;
  2899	  }
  2900	
  2901	  const people = Object.keys(employeeTotals).length;
  2902	  // every totalHours is known finite by here — that coercion was what hid the malformed one
  2903	  const hours = Math.round(Object.keys(employeeTotals)
  2904	    .reduce((n, uid) => n + employeeTotals[uid].totalHours, 0) * 100) / 100;
  2905	
  2906	  // What the manager approves is now the snapshot itself, not a date range.
  2907	  const summary = people
  2908	    ? `Lock ${period.label}?\n\n${people} ${people === 1 ? 'person' : 'people'}, ${hours} hours in total.\n\nThese are the numbers payroll will use.`
  2909	    : `Lock ${period.label}?\n\nThis period has NO hours for anyone. Lock it as an empty period?`;
  2910	  if (!confirm(summary)) return;
  2911	
  2912	  const result = await lockPayPeriod(period.key, employeeTotals, { allowEmpty: !people });
  2913	  if (result.ok) {
  2914	    // Only on success, so a refused or failed lock never leaves the global roster ahead of the screen.
  2915	    employeeRoster = rosterNow.roster;
  2916	    renderAdminTimesheets();
  2917	  } else if (result.reason === 'already-locked') {
  2918	    alert(`This period is already locked${result.lockedBy ? ' by ' + result.lockedBy : ''}${result.lockedAt ? ' on ' + new Date(result.lockedAt).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' }) : ''}. Nothing was changed \u2014 unlock it first if you need to re-lock.`);
  2919	    renderAdminTimesheets();
  2920	  } else if (result.reason === 'malformed-totals') {
  2921	    // Unreachable from here now that the caller checks before confirming — kept because the write refuses
  2922	    // independently of any caller, and a silent difference between the two would be worse than a duplicate.
  2923	    alert(`${result.name || 'One employee'} has hours that did not calculate to a valid number. Nothing was locked.`);
  2924	  } else {
  2925	    alert('Failed to lock period — nothing was changed. Please try again.');

codex
# Verdict: NOT READY

1. **HIGH — Denial can change locked hours despite being treated as harmless.**  
   Evidence: missed-shift hours count only while `changeRequest.status === 'approved'` ([js/app.js:1957](/Users/christiehubley/tinker-timeclock/js/app.js:1957)). The denial branch unconditionally writes `status: 'denied'` without checking the stored status ([js/app.js:2726](/Users/christiehubley/tinker-timeclock/js/app.js:2726), [js/app.js:2760](/Users/christiehubley/tinker-timeclock/js/app.js:2760)). A stale manager tab can therefore deny an already-approved missed shift after the period is locked, removing its hours.  
   Concrete fix: route both approval and denial through a transaction that reads the entry and requires the stored request status to still be `pending`. Permit denial inside a locked period only when the transaction confirms the stored request is pending and therefore contributes zero hours. Add a stale-tab BDD covering approved → locked → stale denial.

2. **HIGH — The residual-rules statement materially understates who can bypass locks.**  
   Evidence: rules permit any staff member with Timeclock access to create their own entries and update every field of their existing entries, without preserving `date`, `timestamp`, `type`, `uid`, or `changeRequest` ([firestore.rules:462](/Users/christiehubley/studio-hub/firestore.rules:462)). Managers are not the only SDK/console bypass.  
   Concrete fix: since rules are explicitly deferred, narrow the goal to “supported Ticker UI” and disclose that staff can directly create or rewrite their own locked-period entries through the SDK. Treat this as a HIGH accepted residual, not merely “manager access via console.”

3. **HIGH — Locking does not freeze all hours Payroll pays: HFWA remains mutable.**  
   Evidence: Ticker allows an HFWA entry for an arbitrary date and writes it without consulting the lock ([js/app.js:4568](/Users/christiehubley/tinker-timeclock/js/app.js:4568), [js/app.js:4583](/Users/christiehubley/tinker-timeclock/js/app.js:4583), [js/app.js:4595](/Users/christiehubley/tinker-timeclock/js/app.js:4595)). Payroll reads current HFWA documents ([index.html:3020](/Users/christiehubley/payroll-tool/index.html:3020)), adds their hours ([index.html:3124](/Users/christiehubley/payroll-tool/index.html:3124)), and includes them in `totalPaidHours` even when clock totals are locked ([index.html:3155](/Users/christiehubley/payroll-tool/index.html:3155), [index.html:3170](/Users/christiehubley/payroll-tool/index.html:3170)).  
   Concrete fix: either include HFWA in the locked snapshot/enforcement design, or explicitly redefine the invariant as “worked clock-entry hours only” and disclose that total paid hours can still change after locking.

4. **HIGH — Roster changes can change locked-total attribution, and one direct roster writer can overwrite newer roster data.**  
   Evidence: `calcPeriodTotals` changes UID grouping using current `claimedBy` mappings ([js/app.js:2030](/Users/christiehubley/tinker-timeclock/js/app.js:2030), [js/app.js:2036](/Users/christiehubley/tinker-timeclock/js/app.js:2036)). Payroll repeats that merge using the roster at pull time ([index.html:3030](/Users/christiehubley/payroll-tool/index.html:3030), [index.html:3046](/Users/christiehubley/payroll-tool/index.html:3046)), then looks up locked totals using the resulting UID ([index.html:3155](/Users/christiehubley/payroll-tool/index.html:3155)). A post-lock claim/merge can therefore make the saved key no longer match. Separately, `setStaffPin` writes the entire roster from the possibly stale in-memory copy ([js/app.js:6469](/Users/christiehubley/tinker-timeclock/js/app.js:6469), [js/app.js:6477](/Users/christiehubley/tinker-timeclock/js/app.js:6477)), potentially undoing a concurrent claim.  
   Concrete fix: design an immutable identity/alias mapping into the lock snapshot and update Payroll to use it, or prevent attribution-changing roster operations while affected locked periods exist. Replace stale whole-roster writes with transactional, conditional roster mutations.

5. **MEDIUM — B4 preserves a known lost-comment race.**  
   Evidence: `addTimeOffComment` reads the full comments array, appends locally, then rewrites the whole array ([js/app.js:7883](/Users/christiehubley/tinker-timeclock/js/app.js:7883), [js/app.js:7895](/Users/christiehubley/tinker-timeclock/js/app.js:7895)). The adjacent `appendTimeOffComment` already uses atomic `arrayUnion` specifically to avoid losing simultaneous comments ([js/app.js:7867](/Users/christiehubley/tinker-timeclock/js/app.js:7867), [js/app.js:7872](/Users/christiehubley/tinker-timeclock/js/app.js:7872)). Merely checking the boolean does not prevent data loss.  
   Concrete fix: make B4 call `appendTimeOffComment`; send push/email only after it returns true. Keep the initial read solely for recipient/routing information.

6. **MEDIUM — M1’s proposed recovery instruction is not reachable.**  
   Evidence: after the roster write succeeds, an automatic claim is considered complete on the next load ([js/app.js:5961](/Users/christiehubley/tinker-timeclock/js/app.js:5961)); the admin Assign button exists only for unclaimed entries ([js/app.js:6531](/Users/christiehubley/tinker-timeclock/js/app.js:6531)). Therefore “try Assign again” cannot retry a failed migration once `claimedBy` has landed.  
   Concrete fix: add an explicit “Retry schedule move” repair action for claimed entries whose `emp_*` source still exists, or roll back the claim with a concurrency-safe conditional transaction. Test the actual recovery UI, not only that `migrateSchedule` is idempotent.

7. **MEDIUM — Phase B’s call-site sweep is incomplete and too syntactic.**  
   Evidence: a failed seed save shows a failure alert and then the unconditional “Added N employee(s)” success alert ([js/app.js:6139](/Users/christiehubley/tinker-timeclock/js/app.js:6139), [js/app.js:6151](/Users/christiehubley/tinker-timeclock/js/app.js:6151)). Also, `submitLateClockOut` runs `trackLateClockOut` even if `doClockOut` returned false ([js/app.js:579](/Users/christiehubley/tinker-timeclock/js/app.js:579), [js/app.js:587](/Users/christiehubley/tinker-timeclock/js/app.js:587)); normal clock-in starts its timer regardless of failed `doClockIn` ([js/app.js:473](/Users/christiehubley/tinker-timeclock/js/app.js:473)). These pass a test that merely verifies the underlying writer result is locally read.  
   Concrete fix: add these semantic callers to the table and test that success-only follow-ons are gated by the returned result. Include direct `getDb()` writers, especially whole-document/map writes, in the audited inventory.

8. **MEDIUM — The planned BDD does not prove the transaction’s concurrency property.**  
   Evidence: the current VM harness already bridges transaction callbacks across realms and passes the real transaction object through, so `tx.get/update/delete/set` are usable ([pay-period-lock.emulator.test.js:44](/Users/christiehubley/tinker-timeclock/pay-period-lock.emulator.test.js:44), [pay-period-lock.emulator.test.js:51](/Users/christiehubley/tinker-timeclock/pay-period-lock.emulator.test.js:51)). However, “locked after opening” only proves the lock existed before the save began; it would pass a non-transactional read-then-write implementation. Firestore retries when a document read by a transaction changes concurrently, and requires all reads before writes ([Firebase transaction documentation](https://firebase.google.com/docs/firestore/manage-data/transactions)).  
   Concrete fix: add a controlled interleaving test that pauses the entry transaction after reading `lockedPeriods`, commits a lock, then releases it and asserts retry/refusal. Inject `lockedPeriodForDate` into the VM context. Allocate the add document reference outside the retrying callback and keep the callback side-effect-free. Reuse `isRealDate` for genuine calendar validation ([js/schedule-helpers.js:904](/Users/christiehubley/tinker-timeclock/js/schedule-helpers.js:904)). The proposed transaction itself is otherwise compatible with `tx.update`, `tx.delete`, and `tx.set` of a new document, and correctly fails closed offline.
tokens used
135,321
# Verdict: NOT READY

1. **HIGH — Denial can change locked hours despite being treated as harmless.**  
   Evidence: missed-shift hours count only while `changeRequest.status === 'approved'` ([js/app.js:1957](/Users/christiehubley/tinker-timeclock/js/app.js:1957)). The denial branch unconditionally writes `status: 'denied'` without checking the stored status ([js/app.js:2726](/Users/christiehubley/tinker-timeclock/js/app.js:2726), [js/app.js:2760](/Users/christiehubley/tinker-timeclock/js/app.js:2760)). A stale manager tab can therefore deny an already-approved missed shift after the period is locked, removing its hours.  
   Concrete fix: route both approval and denial through a transaction that reads the entry and requires the stored request status to still be `pending`. Permit denial inside a locked period only when the transaction confirms the stored request is pending and therefore contributes zero hours. Add a stale-tab BDD covering approved → locked → stale denial.

2. **HIGH — The residual-rules statement materially understates who can bypass locks.**  
   Evidence: rules permit any staff member with Timeclock access to create their own entries and update every field of their existing entries, without preserving `date`, `timestamp`, `type`, `uid`, or `changeRequest` ([firestore.rules:462](/Users/christiehubley/studio-hub/firestore.rules:462)). Managers are not the only SDK/console bypass.  
   Concrete fix: since rules are explicitly deferred, narrow the goal to “supported Ticker UI” and disclose that staff can directly create or rewrite their own locked-period entries through the SDK. Treat this as a HIGH accepted residual, not merely “manager access via console.”

3. **HIGH — Locking does not freeze all hours Payroll pays: HFWA remains mutable.**  
   Evidence: Ticker allows an HFWA entry for an arbitrary date and writes it without consulting the lock ([js/app.js:4568](/Users/christiehubley/tinker-timeclock/js/app.js:4568), [js/app.js:4583](/Users/christiehubley/tinker-timeclock/js/app.js:4583), [js/app.js:4595](/Users/christiehubley/tinker-timeclock/js/app.js:4595)). Payroll reads current HFWA documents ([index.html:3020](/Users/christiehubley/payroll-tool/index.html:3020)), adds their hours ([index.html:3124](/Users/christiehubley/payroll-tool/index.html:3124)), and includes them in `totalPaidHours` even when clock totals are locked ([index.html:3155](/Users/christiehubley/payroll-tool/index.html:3155), [index.html:3170](/Users/christiehubley/payroll-tool/index.html:3170)).  
   Concrete fix: either include HFWA in the locked snapshot/enforcement design, or explicitly redefine the invariant as “worked clock-entry hours only” and disclose that total paid hours can still change after locking.

4. **HIGH — Roster changes can change locked-total attribution, and one direct roster writer can overwrite newer roster data.**  
   Evidence: `calcPeriodTotals` changes UID grouping using current `claimedBy` mappings ([js/app.js:2030](/Users/christiehubley/tinker-timeclock/js/app.js:2030), [js/app.js:2036](/Users/christiehubley/tinker-timeclock/js/app.js:2036)). Payroll repeats that merge using the roster at pull time ([index.html:3030](/Users/christiehubley/payroll-tool/index.html:3030), [index.html:3046](/Users/christiehubley/payroll-tool/index.html:3046)), then looks up locked totals using the resulting UID ([index.html:3155](/Users/christiehubley/payroll-tool/index.html:3155)). A post-lock claim/merge can therefore make the saved key no longer match. Separately, `setStaffPin` writes the entire roster from the possibly stale in-memory copy ([js/app.js:6469](/Users/christiehubley/tinker-timeclock/js/app.js:6469), [js/app.js:6477](/Users/christiehubley/tinker-timeclock/js/app.js:6477)), potentially undoing a concurrent claim.  
   Concrete fix: design an immutable identity/alias mapping into the lock snapshot and update Payroll to use it, or prevent attribution-changing roster operations while affected locked periods exist. Replace stale whole-roster writes with transactional, conditional roster mutations.

5. **MEDIUM — B4 preserves a known lost-comment race.**  
   Evidence: `addTimeOffComment` reads the full comments array, appends locally, then rewrites the whole array ([js/app.js:7883](/Users/christiehubley/tinker-timeclock/js/app.js:7883), [js/app.js:7895](/Users/christiehubley/tinker-timeclock/js/app.js:7895)). The adjacent `appendTimeOffComment` already uses atomic `arrayUnion` specifically to avoid losing simultaneous comments ([js/app.js:7867](/Users/christiehubley/tinker-timeclock/js/app.js:7867), [js/app.js:7872](/Users/christiehubley/tinker-timeclock/js/app.js:7872)). Merely checking the boolean does not prevent data loss.  
   Concrete fix: make B4 call `appendTimeOffComment`; send push/email only after it returns true. Keep the initial read solely for recipient/routing information.

6. **MEDIUM — M1’s proposed recovery instruction is not reachable.**  
   Evidence: after the roster write succeeds, an automatic claim is considered complete on the next load ([js/app.js:5961](/Users/christiehubley/tinker-timeclock/js/app.js:5961)); the admin Assign button exists only for unclaimed entries ([js/app.js:6531](/Users/christiehubley/tinker-timeclock/js/app.js:6531)). Therefore “try Assign again” cannot retry a failed migration once `claimedBy` has landed.  
   Concrete fix: add an explicit “Retry schedule move” repair action for claimed entries whose `emp_*` source still exists, or roll back the claim with a concurrency-safe conditional transaction. Test the actual recovery UI, not only that `migrateSchedule` is idempotent.

7. **MEDIUM — Phase B’s call-site sweep is incomplete and too syntactic.**  
   Evidence: a failed seed save shows a failure alert and then the unconditional “Added N employee(s)” success alert ([js/app.js:6139](/Users/christiehubley/tinker-timeclock/js/app.js:6139), [js/app.js:6151](/Users/christiehubley/tinker-timeclock/js/app.js:6151)). Also, `submitLateClockOut` runs `trackLateClockOut` even if `doClockOut` returned false ([js/app.js:579](/Users/christiehubley/tinker-timeclock/js/app.js:579), [js/app.js:587](/Users/christiehubley/tinker-timeclock/js/app.js:587)); normal clock-in starts its timer regardless of failed `doClockIn` ([js/app.js:473](/Users/christiehubley/tinker-timeclock/js/app.js:473)). These pass a test that merely verifies the underlying writer result is locally read.  
   Concrete fix: add these semantic callers to the table and test that success-only follow-ons are gated by the returned result. Include direct `getDb()` writers, especially whole-document/map writes, in the audited inventory.

8. **MEDIUM — The planned BDD does not prove the transaction’s concurrency property.**  
   Evidence: the current VM harness already bridges transaction callbacks across realms and passes the real transaction object through, so `tx.get/update/delete/set` are usable ([pay-period-lock.emulator.test.js:44](/Users/christiehubley/tinker-timeclock/pay-period-lock.emulator.test.js:44), [pay-period-lock.emulator.test.js:51](/Users/christiehubley/tinker-timeclock/pay-period-lock.emulator.test.js:51)). However, “locked after opening” only proves the lock existed before the save began; it would pass a non-transactional read-then-write implementation. Firestore retries when a document read by a transaction changes concurrently, and requires all reads before writes ([Firebase transaction documentation](https://firebase.google.com/docs/firestore/manage-data/transactions)).  
   Concrete fix: add a controlled interleaving test that pauses the entry transaction after reading `lockedPeriods`, commits a lock, then releases it and asserts retry/refusal. Inject `lockedPeriodForDate` into the VM context. Allocate the add document reference outside the retrying callback and keep the callback side-effect-free. Reuse `isRealDate` for genuine calendar validation ([js/schedule-helpers.js:904](/Users/christiehubley/tinker-timeclock/js/schedule-helpers.js:904)). The proposed transaction itself is otherwise compatible with `tx.update`, `tx.delete`, and `tx.set` of a new document, and correctly fails closed offline.
