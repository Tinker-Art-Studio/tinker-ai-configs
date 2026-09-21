1. **Blocker** — [firestore.rules:462](/Users/christiehubley/studio-hub/firestore.rules:462): successful retries cannot be marked sent. After a failure stores `lastAttemptAt`, a later `updateDoc(ref, { sentAt: serverTimestamp() })` leaves the old `lastAttemptAt` in the resulting document. Because `request.resource.data` is the complete post-update document, line 462 compares that old timestamp with the new `request.time` and denies the write. The existing tests separately cover failure and immediate success, never failure → retry → success. Exact change: validate `lastAttemptAt == request.time` only when `lastAttemptAt` is affected, e.g.:
   ```rules
   && (
     !request.resource.data.diff(resource.data).affectedKeys().hasAny(['lastAttemptAt'])
     || request.resource.data.lastAttemptAt == request.time
   )
   ```
   Add an emulator test that creates a claim, records a failed attempt with `lastAttemptAt`, then successfully updates only `sentAt`. Firestore documents that partial updates appear in rules as the complete future document, which is the source of this failure. [Firebase rules conditions](https://firebase.google.com/docs/firestore/security/rules-conditions)

2. **Should-fix** — [firestore.rules:100](/Users/christiehubley/studio-hub/firestore.rules:100): the bot’s access to `users` is not strictly GET-only. It also satisfies the pre-existing own-document `allow read` when `userId == REMINDER_BOT_UID`. A document-ID-constrained collection query such as:
   ```js
   getDocs(query(
     collection(db, 'users'),
     where(documentId(), '==', REMINDER_BOT_UID)
   ))
   ```
   is a `list` request whose potential result set contains only that permitted path. The existing unfiltered `getDocs(collection(...))` denial does not pin this case. Exact change: exclude the bot from the self-read grant:
   ```rules
   allow read: if isAuthenticated()
     && request.auth.uid == userId
     && !isReminderBot();
   ```
   The dedicated `allow get: if isReminderBot()` will still permit direct gets. Add the constrained-list denial test. Firestore authorizes queries from their potential result set, not merely whether the query is unfiltered. [Firebase query rules](https://firebase.google.com/docs/firestore/security/rules-query)

3. **Should-fix** — [firestore.rules:22](/Users/christiehubley/studio-hub/firestore.rules:22), [firestore.rules:133](/Users/christiehubley/studio-hub/firestore.rules:133), [firestore.rules:166](/Users/christiehubley/studio-hub/firestore.rules:166): “the bot can never become a user” is not fully enforced. The bot cannot bootstrap its own document today, including via merge-to-missing. However, an admin can create `users/{BOT_UID}` through the blanket admin rule. If that document has `role: 'admin'` or granted `appAccess`, the bot then satisfies `isActiveUser()` and inherits unrelated permissions across the shared rules file. It could also use the direct self-update branch on an existing document.

   Exact change:

   - Exclude the pinned UID centrally from `isActiveUser()`, ensuring no bot document can activate role/app-access helpers.
   - Add `!isReminderBot()` to the users self-update rule.
   - To enforce the literal “no users document” invariant, split the admin blanket write and deny create/update when `userId` is the bot UID; retain admin delete so an accidental document can be removed.
   - Add a fixture created with rules disabled for `users/{BOT_UID}` carrying admin privileges, then assert the bot still cannot read the roster, write schedules, or patch that user document.

4. **Should-fix** — [firestore.rules:449](/Users/christiehubley/studio-hub/firestore.rules:449): the nested `shift` does not have an exact shape. `hasOnly()` permits any subset, so `{ shift: {} }`, `{ shift: {start: null} }`, or missing `end/studio/note` all pass. The top-level shape is effectively pinned, but the nested snapshot is not. Exact change: add `shift.keys().hasAll(['start', 'end', 'studio', 'note'])` and type checks for all four values, with appropriate string-size bounds. Add denial tests for an empty shift, each missing required field, and wrong field types. Firebase explicitly defines `hasOnly()` as allowing subsets and recommends combining it with `hasAll()` for required fields. [Firebase field validation](https://firebase.google.com/docs/firestore/security/rules-fields)

5. **Should-fix** — [rules.test.js:1644](/Users/christiehubley/studio-hub/rules.test.js:1644): the bot’s log access is only tested as a GET of a nonexistent document. There is no assertion that the bot cannot list `timeclock_reminder_log`; changing line 437 from `allow get` to `allow read` would therefore pass this new suite. Exact change: assert both GET of the seeded resolved claim succeeds and `getDocs(collection(botDb, 'timeclock_reminder_log'))` fails.

6. **Nit** — [auth-guard.js:49](/Users/christiehubley/tinker-timeclock/js/auth-guard.js:49): the refusal does not precede the reload branch in every event order. If the app initialized as another UID and then receives the bot user, line 50 reloads before line 59 can sign it out. The reloaded page will then refuse and sign out the bot, so this is not a bootstrap or privilege escape, but it causes an unnecessary reload and contradicts the wiring test’s stated ordering guarantee. Exact change: move the bot block above the different-user reload check and make the test assert the source indices or, preferably, exercise the callback behavior. `signOut()` itself does not loop: the re-entered callback receives `user == null`, skips the bot block, and shows the guard.

What I checked and found sound:

- `isReminderBot()` is pinned solely to the exact UID and is false for anonymous requests because authentication is checked first.
- `allow read` on schedules correctly grants both get and list. The dedicated bot grant does not widen access for any other principal.
- The log’s manager/admin read rule excludes staff, kiosk, anonymous, and archived managers through the existing active-manager helper. No sibling rule grants log writes, and no delete grant exists.
- The bot cannot currently create a user document itself: full set, merge-to-missing, and the auth-guard bootstrap are all create operations and hit `!isReminderBot()`. Without a pre-existing bot user document it also cannot satisfy the manager/admin update branches.
- `diff().affectedKeys().hasOnly(...)` prevents changes to `uid`, `date`, `to`, `shift`, and `claimedAt`. A resolved claim cannot be resurrected because every update requires the old `resource.data.sentAt == null`. Attempts cannot decrease or exceed 3.
- The rule permits attempts to remain unchanged or jump directly up to 3. That matches “monotonic and capped,” though it does not enforce an exact counter. Marking the initial successful send with `attempts: 0` is consistent with the planned create-at-zero flow.
- Explicit `sentAt: null` is valid client data and satisfies the create rule. [Firestore supports literal null values](https://firebase.google.com/docs/firestore/manage-data/add-data)
- Firestore Lite exports `serverTimestamp()` and `runTransaction()`. Server timestamp transforms compare equal to `request.time`, including in transactional writes. [Firestore Lite API](https://firebase.google.com/docs/reference/js/firestore_lite.md), [rules request-time reference](https://firebase.google.com/docs/reference/rules/rules.firestore.Request)
- The actual regex uses valid rules/RE2-compatible syntax: anchors, ASCII digit classes, and fixed repetition. It validates formatting only; values such as `2026-99-99` still match, but that is consistent with a “date shape” check rather than calendar validation.
- `exists(/databases/$(database)/documents/timeclock_schedules/$(uid))` is correctly formed. Since the bot can read every schedule, there is no schedule document that satisfies this existence check but is unreadable to it.
- Manager merge writes to the log are still denied: merge against an existing document is an update, and merge against a missing document is a create. Neither manager/admin has a log write grant.
- The positive tests are meaningful: schedule list/get, user get, claim creation, sent update, and failed-attempt update would fail under default deny. The pure-denial assertions naturally cannot prove the intended grant exists, but they do pin restrictions once paired with those positive paths.

I made no edits. I did not rerun the reported 195-test suite because no emulator was running in this read-only environment.
