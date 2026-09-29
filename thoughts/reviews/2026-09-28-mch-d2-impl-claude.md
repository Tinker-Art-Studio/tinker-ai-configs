## What I could and couldn't verify

Two limits, stated up front:

- **I could not read the plan.** `~/tinker-ai-configs/thoughts/plans/my-clay-hub-phase-d-project.html` is outside this session's allowed directory (Read and Bash both refused). So I cannot check D-2's acceptance criteria or BDD scenarios verbatim, nor the D-3 table. Question 5 is answered against the commit message, `CLAUDE.md`, the global Firebase rules and `docs/my-clay-hub/`, not against the plan itself — treat that part as incomplete.
- **I could not run `npm test`.** Every invocation (`npm test`, `node --test tests/unit/`, `bash <script>`) needed approval, and this session is non-interactive. Everything below is static analysis plus reading the actual dependency sources in `node_modules` (`firebase-tools/lib/deploy/lifecycleHooks.js`, `firebase-tools/lib/emulator/{env,commandUtils}.js`, `@firebase/rules-unit-testing/dist/index.cjs.js`). **I did not observe a green suite.**

## Direct answers

**1. Do the rules deny everything?** Yes. Both files are `rules_version = '2'` with a single recursive `allow read, write: if false`, and — more to the point — contain **no `allow … if` that can ever be true**, so the default-deny applies to every identity, every depth, and every collection-group query regardless of the wildcard. `match /b/{bucket}/o` covers every bucket; Storage `read` covers get+list, `write` covers create/update/delete. Correct. One accuracy note, not a defect: this denies *client* identities only — Admin SDK / service-account access from functions is unaffected, which is what `ingestMemberUpdate` will rely on.

**2. Do the tests prove it?** Mostly, with real gaps — findings 1, 2, 3, 6. A per-collection non-recursive allow on `members`, `bookings` or `settings` would fail them; on `memberProfiles`, `inbox/*/items` or `events/*/rsvps` it would not. A claim-keyed allow keyed to the doc id (`request.auth.token.memberId == memberId`) would **not** fail them. The allow-everything harness proof is sound in structure — `assertSucceeds` is a no-op pass-through (index.cjs.js:605), so the `.catch(…)` wrapper is what makes it assert, and that works — but it only runs 2 of the 6 identities, so the claim-bearing contexts are never shown to work at all. Flakiness: the two `initializeTestEnvironment` calls on one project are safe, because node:test runs top-level `describe`s in a file sequentially with their hooks, and `--test-concurrency=1` keeps the two files sequential; storage rules are loaded emulator-globally (`/internal/setRules`, no projectId — index.cjs.js:412), which is another reason that flag is load-bearing. `clearStorage()` is non-recursive (see nit 11).

**3. Can the tests reach production or a studio-hub emulator?** No, on four independent layers, and I verified the two I could: `emulators:exec` sets `GCLOUD_PROJECT` from `--project` (commandUtils.js:292) and **overwrites** any inherited `FIRESTORE_EMULATOR_HOST`/`FIREBASE_STORAGE_EMULATOR_HOST` with the emulators it actually started (commandUtils.js:243 → env.js:10-46), so the 8180/9299 assertion really does prove it's this repo's emulator; and `initializeTestEnvironment` prefers an explicit `{host, port}` over both hub discovery and env vars (index.cjs.js:122-139), so a stray `FIREBASE_EMULATOR_HUB` can't redirect it. Plus `demo-` prefix, `singleProjectMode: true`, and `env.js` re-checking. The one way this fails is finding 1 — the checks never running.

**4. `predeploy-check.sh`:** correct and fail-closed on all three checks. `GCLOUD_PROJECT` is set by lifecycleHooks.js:60-64 and *overrides* `process.env`, so it can't be spoofed; `cwd` is `config.projectDir` (lifecycleHooks.js:75), so the relative file paths and the git-common-dir check both resolve in the right tree; and `getReleventConfigs` (lifecycleHooks.js:98-145) includes the firestore config for `--only firestore:rules` and `--only firestore:indexes`, so the hook does fire for the narrow forms the D-3 guard will use. Nice touch: the "is this sha a commit in *this* repo" check is what stops a `TINKER_DEPLOY_SHA` left over from studio-hub's guard. Gaps: findings 4, 5, 8, 13.

**5. D-2 criteria:** can't check against the plan. Finding 7 is the one delivery gap I can see from the repo itself.

---

## Findings

**1. should-fix — `scripts/emulator-safety.js:53`: the entry-point check can silently no-op, turning `npm run test:rules` green with zero tests run.**
`process.argv[1] === fileURLToPath(import.meta.url)` compares a path Node resolves to absolute but does *not* realpath against `import.meta.url`, which *is* realpathed by the ESM loader. If any component of the repo path is ever a symlink (a moved repo, a checkout under `/tmp` → `/private/tmp`, a synced folder), the `if` is false, the script does nothing, exits 0, `emulators:exec` prints "Script exited successfully", and `npm test` passes having run **no rules tests at all**. The existing launcher test doesn't catch it: it passes an absolute realpath (`tests/unit/emulator-safety.test.js:9,49`), not the cwd-relative `scripts/emulator-safety.js` that `package.json:9` actually uses. Failure mode is silent vacuity, which is the worst one for a safety launcher.
Fix — add `realpathSync` to the existing `node:fs` import and:
```js
const entry = process.argv[1] ? realpathSync(process.argv[1]) : '';
if (entry === fileURLToPath(import.meta.url)) {
```
and add the invocation the npm script really uses:
```js
test('the launcher runs the command when invoked the way package.json does', () => {
  const r = spawnSync(process.execPath, ['scripts/emulator-safety.js', '--', process.execPath, '-e', 'console.log("RAN")'],
    { cwd: fileURLToPath(new URL('../../', import.meta.url)), env: { PATH: process.env.PATH, ...SAFE }, encoding: 'utf8' });
  assert.equal(r.status, 0, r.stderr);
  assert.match(r.stdout, /RAN/);
});
```

**2. should-fix — `tests/rules/firestore.test.js:59` and `tests/rules/storage.test.js:49`: the harness proof covers 2 of 6 identities, so the four claim-bearing contexts are never proven to work.**
Under deny-all, "denied because the rules say no" and "denied because this context never reached the emulator or dropped its claims" are indistinguishable. Nothing in the suite asserts that `authenticatedContext('fake-admin', {admin:true})` produces a working client carrying that claim — so `env.js:24`'s promise that a claim-trusting rule "shows up here first" rests on untested plumbing, which Phase F will inherit. (The usage itself is right: `authenticatedContext` spreads `tokenOptions` at the token top level, index.cjs.js:208-215, so the claims land as `request.auth.token.admin` etc.)
Fix, in both files: `for (const who of STRANGERS) {` — the proof stage is allow-everything, so it costs only runtime.

**3. should-fix — `tests/rules/env.js:26-33` vs `firestore.test.js:16`: no identity's claims match a seeded document, so a self-keyed claim allow passes the suite.**
The member identity carries `memberId: 'm_fake'` while the seeded doc is `members/m1`. A future `allow read: if request.auth.token.memberId == memberId` — the exact "claim-keyed allow" class — would be denied for every identity here and the tests would stay green.
Fix — add to `STRANGERS`:
```js
{ label: 'signed in as the seeded member (uid and memberId = m1)', uid: 'm1', claims: { member: true, memberId: 'm1' } },
{ label: 'signed in as the seeded staff uid', uid: 'u1', claims: { staff: true, role: 'admin' } },
```
and seed `staffRoster/staff_u1` so the staff one has a matching target.

**4. should-fix — `tests/unit/predeploy-check.test.js`: the script is never exercised from a linked `git worktree`, which is D-3's only deploy path.**
Every case runs in the fixture's main worktree, so `git rev-parse --path-format=absolute --git-common-dir` is only ever tested where it trivially returns `<repo>/.git`. In a linked worktree the common dir is derived from the `commondir` file (historically emitted with unnormalized `../..` segments); `--path-format=absolute` is documented as "absolute and canonical", so `scripts/predeploy-check.sh:41`'s string equality most likely holds — but it is unverified, and I could not run the probe I wrote to settle it. If it doesn't hold, the D-3 guard is refused on its first deploy (fail-closed, so not unsafe — just dead on arrival). It also pins the `--path-format` flag's git ≥ 2.31 requirement.
Fix — the fixture already commits the REPO-rewritten script, so this works as-is:
```js
test('passes from a linked worktree of this repo (how the D-3 guard deploys)', () => {
  const wt = join(tmpdir(), `mch-predeploy-wt-${Date.now()}`);
  git(repo, 'worktree', 'add', '-q', '--detach', wt, sha);
  try {
    const r = spawnSync('bash', [join(wt, 'scripts/predeploy-check.sh'), 'firestore'],
      { cwd: wt, env: { PATH: process.env.PATH, HOME: process.env.HOME, ...GOOD() }, encoding: 'utf8' });
    assert.equal(r.status, 0, r.stderr);
  } finally { git(repo, 'worktree', 'remove', '--force', wt); }
});
```

**5. should-fix — nothing asserts `firebase.json` still wires the backstop.**
Delete `firebase.json:5-7` or `:11-13` and the entire predeploy defence vanishes with a fully green `npm test`. The script's own correctness is well covered; its *wiring* isn't covered at all.
Fix — add to `tests/unit/`:
```js
const cfg = JSON.parse(readFileSync(new URL('../../firebase.json', import.meta.url), 'utf8'));
assert.deepEqual(cfg.firestore.predeploy, ['bash scripts/predeploy-check.sh firestore']);
assert.deepEqual(cfg.storage.predeploy, ['bash scripts/predeploy-check.sh storage']);
assert.equal(cfg.firestore.rules, 'firestore.rules');
assert.equal(cfg.firestore.indexes, 'firestore.indexes.json');
assert.equal(cfg.storage.rules, 'storage.rules');
assert.equal(cfg.emulators.singleProjectMode, true);
```

**6. should-fix — `tests/rules/firestore.test.js:15-16`: `DOCS` covers 3 of the ~16 collections in `DATA-MODEL.md`, and the comment overstates it as "the three collections the app will have".**
Missing are exactly the paths a wrong rule will target: `memberProfiles/{memberId}` (the only member-readable collection), `staffRoster` and `members` (documented as readable by *no* client), and the real subcollection shapes `inbox/{m}/items/{i}`, `posts/{p}/loves/{m}`, `events/{e}/rsvps/{m}`. The synthetic `members/m1/anything/deep1` proves depth but not those names.
Fix — add at least `'memberProfiles/m1'`, `'staffRoster/staff_u1'`, `'inbox/m1/items/i1'`, `'posts/p1/loves/m1'`, `'events/e1/rsvps/m1'` to `DOCS`, and fix the comment. Note the cost: paths × identities × 9 ops, so with finding 3 that's ~10 × 8 × 9 ≈ 720 operations — pair it with nit 9.

**7. should-fix — `CLAUDE.md:34` and `:45-46` are now false, and this branch is what made them false.**
`:34` says "**This app has no Firebase project yet** (it's created in plan Phase D)" while `OPEN-ITEMS.md` in this same commit records it created Sep 28, 2026. `:45-46` says "Local development — Not built yet" although `npm test`, the pinned emulator ports and the deny-all-until-Phase-F convention now exist and are precisely what a future session needs before touching rules. A session reading `CLAUDE.md` first would believe there is no project and no rules file. Per this repo's own rule ("When a build change affects the spec, update `SPEC.md` in the same commit"), the agent-facing doc should move with it.
Fix — replace `:34` with the created-project facts (ID, `nam5`, Blaze) and note that rules are deny-all until each collection's Phase F commit; replace `:45-46` with `npm test` / `npm run test:rules`, the 8180/9299 pins, and that the guard arrives in D-3 so nothing can deploy yet.

**8. nit — `scripts/predeploy-check.sh:29-31`: `firebase.json` and the script itself aren't byte-checked, so the two files that define the backstop are outside it.**
Editing `firebase.json`'s `"rules"` path while leaving the `predeploy` line intact ships an unchecked file with a passing check. This is a deliberate bypass, which the header (`:10-11`) already scopes out — but it's two words to close.
Fix: `firestore) files="firebase.json scripts/predeploy-check.sh firestore.rules firestore.indexes.json" ;;` and the same prefix for `storage`. `tests/unit/predeploy-check.test.js:24` then needs `firebase.json` added to the copied fixture files (the rewritten script already matches its own committed bytes).

**9. nit — `package.json:8-9`: no test timeout.** node:test's default is no timeout. A mid-run emulator stall leaves a Firestore write promise pending forever and hangs `npm test` rather than failing it. Add `--test-timeout=120000` to both scripts.

**10. nit — `firestore.rules:11` and `storage.rules:6` state `scripts/deploy-rules.sh` as the deploy path as though it exists.** `predeploy-check.sh:25` is honest ("arrives in D-3"); the rules files should match — "will deploy only through `scripts/deploy-rules.sh` (arrives in D-3)".

**11. nit — `tests/rules/storage.test.js:41,46,68`: `clearStorage()` is non-recursive.** It deletes only `ref().listAll().items` at the root (index.cjs.js:260-268), so `members/m1/photos/deep/pot.jpg` and every random `new-*.txt` from the proof stage survive both `after` hooks. Harmless today — emulator storage is in-memory per run, and stage 2's `before` re-seeds `pot.jpg` back to 4 bytes so `:90` holds — but don't rely on it for isolation, and say so in a comment.

**12. nit — `scripts/emulator-safety.js:28`: `^([^:]+):(\d+)$` rejects bracketed IPv6.** If `firebase.json` ever used `::1`, `formatHost` emits `[::1]:8180` and the suite refuses with a misleading "not host:port". Fail-closed, so cosmetic — worth a comment given the hosts are pinned to `127.0.0.1`.

**13. nit — forward gap for D-4.** `firebase.json` has no `functions` block yet. When the vault-export function lands, it needs its own `predeploy` entry: a refusal in any hook aborts the whole deploy, but `firebase deploy --only functions` would run no hook at all. Also worth recording for D-3: the plan's guard, not this script, is what must enforce "the sha is on `origin/main`" — `predeploy-check.sh` only checks the sha is *a commit in this repo*, and a human who exports `TINKER_DEPLOY_SHA=$(git rev-parse HEAD)` passes the backstop.

---

**Verdict: merge after fixes.** Nothing on this branch is unsafe to have in the repo — the rules genuinely deny everything, the emulator pinning holds on four independent layers, and every predeploy path I traced is fail-closed. But finding 1 can make the rules suite pass while running nothing, findings 2, 3 and 6 mean the suite proves less than its comments claim right as Phase F starts leaning on it, and 4 and 5 leave D-3's only deploy path and the backstop's wiring untested. I'd do 1, 2, 4 and 5 before merging; 3, 6 and 7 before the first Phase F rule; the nits whenever.
