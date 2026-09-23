## Change under review

Commit d43a171 in /Users/christiehubley/studio-hub — a bug fix to a Firebase deploy guard.
Only scripts/deploy-rules.sh and scripts/deploy-rules.test.sh changed. No rules, no deploy.

## What the guard is

scripts/deploy-rules.sh is the ONLY sanctioned way to run `firebase deploy` for the shared
Firebase project `tinker-hq-apps`. All Tinker apps share one Firestore rules file edited in one
working tree by many concurrent Claude sessions. The operator (Christie) approves a COMMIT by
saying a literal phrase; the guard deploys that commit from a temporary git worktree, runs the
rules test suite first, and leaves an immutable annotated git tag ("receipt") recording what
shipped:

    deployed/tinker-hq-apps/<target-slug>/<UTC yyyymmddTHHMMSSZ>-<sha7>

Before deploying, the guard prints "replaces: <newest receipt>" and a full diff from that
receipt's commit to the commit being deployed. That printed diff is what the operator reads to
decide whether to approve. `--status` and `--diff` modes print the same relationship.

## The bug being fixed

latest_receipt() found "the newest receipt" with:

    git for-each-ref --count=1 --sort=-refname --format='%(refname:short)' "refs/tags/${TAG_PREFIX}"

Receipt names carry only SECOND resolution. Two deploys in the same second produce names that tie
on the timestamp, so -refname breaks the tie on the trailing sha7 — which is arbitrary. The older
receipt can out-sort the newer one, and the guard then diffs against the wrong base. When that
wrong base IS the commit being deployed, the printed diff is EMPTY — which reads to an operator as
"nothing is changing, safe to approve".

Observed as a flaky test: scripts/deploy-rules.test.sh gave "89 passed, 1 failed" one run and
"90 passed, 0 failed" the next with no code change. Baseline reruns also produced "86 passed,
4 failed".

## The fix (two halves)

READ side: order by the tag object's own creation date, with refname as an explicit tiebreaker,
and count only ANNOTATED tags as receipts (a lightweight tag reports the pointed-to commit's date,
not a deploy time).

WRITE side: a new receipt must be strictly NEWER than every receipt already recorded for that
target, not merely not-a-duplicate — the guard waits out the second. Capped at 10 iterations with
a warning, so a future-stamped tag cannot trap a deploy that has already shipped.

Note: `--sort=-creatordate` ALONE was verified insufficient — git tag dates are also whole
seconds, so same-second receipts tie there too. With only the read-side fix the suite still failed
4, 4 and 2 across three runs.

## Acceptance criteria

1. "Newest receipt" is deterministic and genuinely newest-first — total and monotonic ordering.
2. The tag NAME format is unchanged; receipts are immutable and existing ones must still be found.
   (The repo has exactly one real receipt today: an ANNOTATED tag
   deployed/tinker-hq-apps/firestore-rules/20260921T220500Z-1da12e3.)
3. The test scenario is deterministic by construction, not papered over with an unexplained sleep.
4. The guard must still fail CLOSED: it must never deploy bytes other than the approved commit's.
5. The suite must be green repeatedly.

## What I want reviewed — be adversarial

- Is the ordering now actually total and monotonic, or is there still a case where the guard can
  name the wrong receipt as "what shipped last"?
- Shell correctness: the script runs under `set -euo pipefail`. Can any new line abort the script
  unexpectedly, or (worse) silently return the wrong value? Pay attention to the herestring loops,
  `local` usage, the arithmetic comparison of stamps, and the `{ ...; } || ... || break` condition.
- The new wait sits AFTER a successful `firebase deploy`. What is the worst case if the process
  dies during it? Is that worse than before?
- Can the capped-wait escape hatch produce a receipt that MISREPRESENTS what shipped?
- Are the new tests genuine regression tests, or do they pass vacuously?
- Anything that makes the operator's printed diff less trustworthy than before this change.
- Two concerns I already suspect, judge them independently and tell me if I am wrong or if they
  matter more than I think: (a) a receipt written BY HAND via the script's own EX_RECEIPT recovery
  instructions, after a later deploy, would carry a newer tag date than the genuinely-newer
  receipt, so the new date ordering would read it as "what shipped last" where the old name
  ordering would have been right; (b) the annotated-only filter changes which tags count as
  receipts at all.

## The diff

```diff
diff --git a/scripts/deploy-rules.sh b/scripts/deploy-rules.sh
index 134c41e..4e39d7e 100755
--- a/scripts/deploy-rules.sh
+++ b/scripts/deploy-rules.sh
@@ -22,7 +22,8 @@
 #   - Every successful deploy leaves an immutable annotated RECEIPT tag
 #       deployed/tinker-hq-apps/<target-slug>/<UTC yyyymmddTHHMMSSZ>-<sha7>
 #     recording the commit, the file and its sha256. Receipts are never moved or force-pushed; the newest
-#     one is "what shipped last". They are receipts of GUARDED deploys, not proof of production — a deploy
+#     one is "what shipped last" — newest by the tag object's own date, not by the name, whose stamp has
+#     only second resolution. They are receipts of GUARDED deploys, not proof of production — a deploy
 #     that dodged everything leaves none; the predeploy hook makes dodging a deliberate act (it can be
 #     skipped with `firebase --config other.json`, so it stops accidents, not intent).
 #   - A deploy that succeeds but whose receipt fails to push exits with a distinct code, and the next run
@@ -73,7 +74,37 @@ say()  { printf '%s\n' "$*"; }
 warn() { printf 'WARNING: %s\n' "$*" >&2; }
 die()  { local code=$1; shift; printf 'REFUSED: %s\n' "$*" >&2; exit "$code"; }
 
-latest_receipt() { git for-each-ref --count=1 --sort=-refname --format='%(refname:short)' "refs/tags/${TAG_PREFIX}"; }
+# "What shipped last": the base of the diff Christie reads before approving, and the thing an operator
+# trusts when the guard says "replaces: <receipt>". Receipt NAMES carry only second resolution, so two
+# deploys that land in the same second tie on the name and `--sort=-refname` breaks the tie on the
+# trailing sha7 — which says nothing about order. The older receipt can then out-sort the newer one and
+# the guard diffs against the wrong base (an EMPTY diff, when that wrong base is the commit being
+# deployed). Seen Sep 22 2026 as a rollback test that passed or failed run to run with no code change.
+# So: order by the tag object's own creation time, not by its name. `--sort` keys are applied LAST-first,
+# so creatordate below is the PRIMARY key and refname is a deliberate, documented tiebreaker for anything
+# still level. Only annotated tags are receipts — step 9 writes nothing else under the namespace, and a
+# lightweight tag has no creation time of its own (git reports the commit's date, which for a rollback
+# receipt is not the deploy time at all). Step 9 keeps every new receipt strictly newer than the last in
+# BOTH keys, so name order and date order cannot disagree.
+latest_receipt() {   # the newest receipt for this target; '' if there is none
+  local type ref out=""
+  while read -r type ref; do
+    [ "$type" = tag ] || continue
+    out="$ref"; break
+  done <<< "$(git for-each-ref --sort=-refname --sort=-creatordate --format='%(objecttype) %(refname:short)' "refs/tags/${TAG_PREFIX}")"
+  printf '%s' "$out"
+}
+# The largest well-formed stamp already recorded for this target; '' if there is none. Names are
+# fixed-width UTC, so the largest NAME carries the largest stamp. A hand-made tag whose name does not
+# parse is skipped rather than compared against.
+newest_stamp() {
+  local ref stamp out=""
+  while read -r ref; do
+    stamp="${ref#"$TAG_PREFIX"}"; stamp="${stamp%%-*}"
+    if [[ "$stamp" =~ ^[0-9]{8}T[0-9]{6}Z$ ]]; then out="$stamp"; break; fi
+  done <<< "$(git for-each-ref --sort=-refname --format='%(refname:short)' "refs/tags/${TAG_PREFIX}")"
+  printf '%s' "$out"
+}
 receipt_commit() { git rev-list -n 1 "$1"; }
 dirty_files()    { git status --porcelain --untracked-files=no | cut -c4- | sed 's/^.* -> //'; }
 PENDING="$(git rev-parse --git-dir)/tinker-deploy-pending"   # the one receipt whose push failed last time
@@ -246,12 +277,27 @@ fi
 
 # 9. The receipt — only after a successful release.
 HASH="$(shasum -a 256 "$TMP/$FILE" | awk '{print $1}')"
-STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
-TAG="${TAG_PREFIX}${STAMP}-${SHA:0:7}"
-# Receipt names have second resolution; a second deploy of the same commit within one second must not
-# collide with (or, worse, fail after) a successful release — wait for the next second instead.
-while git rev-parse --verify --quiet "refs/tags/${TAG}" >/dev/null; do
-  sleep 1; STAMP="$(date -u +%Y%m%dT%H%M%SZ)"; TAG="${TAG_PREFIX}${STAMP}-${SHA:0:7}"
+# Receipt names have second resolution and the record is read as an ORDER, so a new receipt must be
+# strictly NEWER than every receipt already recorded for this target — not merely not-a-duplicate. Two
+# deploys inside one second would otherwise be separated only by their sha7s, which is no order at all,
+# and the same second also ties the tag dates latest_receipt sorts on. Waiting out the second makes both
+# keys total and monotonic, keeps the name format untouched, and costs at most a second — after the
+# release, with nothing else pending. (It subsumes the old duplicate-name wait: the same commit deployed
+# twice inside a second collided outright.) Capped, because a receipt stamped in the FUTURE — a bad clock,
+# a hand-made tag — must not trap a deploy that has already shipped; past the cap the receipt is written
+# anyway and the ambiguity is reported. latest_receipt still reads these two in the right order: it sorts
+# on the tag objects' dates, and ours is genuinely the later one.
+PREV_STAMP="$(newest_stamp)"; WAITED=0
+while :; do
+  STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
+  TAG="${TAG_PREFIX}${STAMP}-${SHA:0:7}"
+  { [ -n "$PREV_STAMP" ] && [ "${STAMP//[TZ]/}" -le "${PREV_STAMP//[TZ]/}" ]; } \
+    || git rev-parse --verify --quiet "refs/tags/${TAG}" >/dev/null || break
+  if [ "$WAITED" -ge 10 ]; then
+    warn "after ${WAITED}s this clock still cannot stamp a receipt newer than what is already under ${TAG_PREFIX} (newest stamp there: ${PREV_STAMP:-none}) — writing ${TAG} anyway, because the deploy has already shipped and no receipt is worse than an out-of-order one. Check this machine's clock and the tags: by NAME the receipts now read out of order. The guard itself reads them by tag date, which is still right."
+    break
+  fi
+  sleep 1; WAITED=$((WAITED+1))
 done
 MSG="project=${PROJECT} target=${TARGET} commit=${SHA} file=${FILE} sha256=${HASH} at=${STAMP} by=deploy-rules.sh"
 if ! git tag -a "$TAG" "$SHA" -m "$MSG"; then
diff --git a/scripts/deploy-rules.test.sh b/scripts/deploy-rules.test.sh
index 1111283..3626f03 100755
--- a/scripts/deploy-rules.test.sh
+++ b/scripts/deploy-rules.test.sh
@@ -126,6 +126,43 @@ echo "// v3" >> firestore.rules; git commit --quiet -am "rules v3"; git push --q
 run --approved "$SHA3"; assert_eq "second deploy ok" "$CODE" "0"; assert_has "…shows the diff from the last receipt" "$OUT" "+// v3"
 run --approved "$SHA2"; assert_eq "an OLDER commit on main (a rollback) is a guarded deploy" "$CODE" "0"; assert_has "…whose diff shows the removal" "$OUT" "-// v3"
 assert_eq "three receipts now" "$(git tag -l 'deployed/tinker-hq-apps/firestore-rules/*' | wc -l | tr -d ' ')" "3"
+# Those three receipts were written back-to-back — with a fake firebase and a fake npm, well inside one
+# second of each other. Receipt names carry only seconds, so "the newest receipt" would come down to the
+# trailing sha7, which is arbitrary: that is exactly how the rollback diff above used to come out EMPTY
+# (SHA2 diffed against SHA2) on some runs and correct on others, with no code change. The guard now waits
+# out the second so each receipt is strictly newer than the last in both keys. Assert that directly —
+# the diff assertion above only notices the flake when the coin happens to land badly.
+NS='refs/tags/deployed/tinker-hq-apps/firestore-rules/'
+assert_eq "…each receipt got its own second (no same-second tie for the sha7 to break)" \
+  "$(git for-each-ref --format='%(refname:short)' "$NS" | sed 's#.*/##; s#-.*##' | sort -u | wc -l | tr -d ' ')" "3"
+assert_eq "…so ordering them by name and by tag date give the same answer" \
+  "$(git for-each-ref --sort=refname --format='%(refname:short)' "$NS")" \
+  "$(git for-each-ref --sort=refname --sort=creatordate --format='%(refname:short)' "$NS")"
+
+# ── the read side on its own: two receipts stamped in the SAME second, forced ──
+# Hand-made so the tie is guaranteed rather than hoped for, and stacked against the old behaviour: the
+# stamps are identical and the OLDER receipt's sha7 sorts ABOVE the newer one's, so `--sort=-refname`
+# picks precisely the wrong receipt. The sleep is the subject of the test, not a workaround for it —
+# git tag dates are whole seconds, so the two tag objects have to be written a second apart for "which
+# one was created later" to be a question at all.
+fixture_reset
+SAME="20260922T134504Z"
+git tag -a "deployed/tinker-hq-apps/firestore-rules/${SAME}-zzzzzzz" "$SHA1" -m "older receipt, higher sha7"
+sleep 1
+git tag -a "deployed/tinker-hq-apps/firestore-rules/${SAME}-aaaaaaa" "$SHA2" -m "newer receipt, lower sha7"
+run --status; assert_eq "--status exits 0 with same-second receipts" "$CODE" "0"
+assert_has "…the later-written receipt is what shipped last" "$OUT" "${SAME}-aaaaaaa"
+assert_lacks "…not the one whose sha7 sorts higher" "$OUT" "${SAME}-zzzzzzz"
+assert_has "…and the state is read against the right one" "$OUT" "nothing to deploy"
+# A hand-made LIGHTWEIGHT tag in the namespace is not a receipt. It has no creation time of its own —
+# git reports the commit's date — so pointing one at a brand-new commit must not let it pose as the
+# newest receipt now that the guard sorts on dates.
+git commit --quiet --allow-empty -m "a commit made after both receipts"
+git tag "deployed/tinker-hq-apps/firestore-rules/29990101T000000Z-handmade" HEAD
+run --status
+assert_has "a lightweight tag in the namespace is not a receipt" "$OUT" "${SAME}-aaaaaaa"
+assert_lacks "…even pointing at a commit newer than every real receipt" "$OUT" "handmade"
+git reset --quiet --hard origin/main
 
 # ── the deploy machinery comes from origin/main, not the approved commit ──
 fixture_reset
```

## Full current text of the two changed functions and the receipt-writing block

```bash

# "What shipped last": the base of the diff Christie reads before approving, and the thing an operator
# trusts when the guard says "replaces: <receipt>". Receipt NAMES carry only second resolution, so two
# deploys that land in the same second tie on the name and `--sort=-refname` breaks the tie on the
# trailing sha7 — which says nothing about order. The older receipt can then out-sort the newer one and
# the guard diffs against the wrong base (an EMPTY diff, when that wrong base is the commit being
# deployed). Seen Sep 22 2026 as a rollback test that passed or failed run to run with no code change.
# So: order by the tag object's own creation time, not by its name. `--sort` keys are applied LAST-first,
# so creatordate below is the PRIMARY key and refname is a deliberate, documented tiebreaker for anything
# still level. Only annotated tags are receipts — step 9 writes nothing else under the namespace, and a
# lightweight tag has no creation time of its own (git reports the commit's date, which for a rollback
# receipt is not the deploy time at all). Step 9 keeps every new receipt strictly newer than the last in
# BOTH keys, so name order and date order cannot disagree.
latest_receipt() {   # the newest receipt for this target; '' if there is none
  local type ref out=""
  while read -r type ref; do
    [ "$type" = tag ] || continue
    out="$ref"; break
  done <<< "$(git for-each-ref --sort=-refname --sort=-creatordate --format='%(objecttype) %(refname:short)' "refs/tags/${TAG_PREFIX}")"
  printf '%s' "$out"
}
# The largest well-formed stamp already recorded for this target; '' if there is none. Names are
# fixed-width UTC, so the largest NAME carries the largest stamp. A hand-made tag whose name does not
# parse is skipped rather than compared against.
newest_stamp() {
  local ref stamp out=""
  while read -r ref; do
    stamp="${ref#"$TAG_PREFIX"}"; stamp="${stamp%%-*}"
    if [[ "$stamp" =~ ^[0-9]{8}T[0-9]{6}Z$ ]]; then out="$stamp"; break; fi
  done <<< "$(git for-each-ref --sort=-refname --format='%(refname:short)' "refs/tags/${TAG_PREFIX}")"
  printf '%s' "$out"
}
...
fi

# 9. The receipt — only after a successful release.
HASH="$(shasum -a 256 "$TMP/$FILE" | awk '{print $1}')"
# Receipt names have second resolution and the record is read as an ORDER, so a new receipt must be
# strictly NEWER than every receipt already recorded for this target — not merely not-a-duplicate. Two
# deploys inside one second would otherwise be separated only by their sha7s, which is no order at all,
# and the same second also ties the tag dates latest_receipt sorts on. Waiting out the second makes both
# keys total and monotonic, keeps the name format untouched, and costs at most a second — after the
# release, with nothing else pending. (It subsumes the old duplicate-name wait: the same commit deployed
# twice inside a second collided outright.) Capped, because a receipt stamped in the FUTURE — a bad clock,
# a hand-made tag — must not trap a deploy that has already shipped; past the cap the receipt is written
# anyway and the ambiguity is reported. latest_receipt still reads these two in the right order: it sorts
# on the tag objects' dates, and ours is genuinely the later one.
PREV_STAMP="$(newest_stamp)"; WAITED=0
while :; do
  STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
  TAG="${TAG_PREFIX}${STAMP}-${SHA:0:7}"
  { [ -n "$PREV_STAMP" ] && [ "${STAMP//[TZ]/}" -le "${PREV_STAMP//[TZ]/}" ]; } \
    || git rev-parse --verify --quiet "refs/tags/${TAG}" >/dev/null || break
  if [ "$WAITED" -ge 10 ]; then
    warn "after ${WAITED}s this clock still cannot stamp a receipt newer than what is already under ${TAG_PREFIX} (newest stamp there: ${PREV_STAMP:-none}) — writing ${TAG} anyway, because the deploy has already shipped and no receipt is worse than an out-of-order one. Check this machine's clock and the tags: by NAME the receipts now read out of order. The guard itself reads them by tag date, which is still right."
    break
  fi
  sleep 1; WAITED=$((WAITED+1))
done
MSG="project=${PROJECT} target=${TARGET} commit=${SHA} file=${FILE} sha256=${HASH} at=${STAMP} by=deploy-rules.sh"
if ! git tag -a "$TAG" "$SHA" -m "$MSG"; then
  printf 'DEPLOY SUCCEEDED; RECEIPT NOT WRITTEN.\nProduction is now %s. Write the receipt by hand, then push it:\n    git tag -a %s %s -m "%s"\n    git push %s refs/tags/%s\n' "${SHA:0:12}" "$TAG" "$SHA" "$MSG" "$REMOTE" "$TAG" >&2
  exit $EX_RECEIPT
```
