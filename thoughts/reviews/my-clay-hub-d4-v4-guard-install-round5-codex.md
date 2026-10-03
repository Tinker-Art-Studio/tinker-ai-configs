## Findings

### Should-fix

1. The functions suite still does not test that `--diff` names a changed `shared/` tree. The new scenario checks only `--approved` refusal and its error text ([deploy-functions.test.sh:537](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:537)). The round-4 request explicitly asked for the equivalent of the other-codebase coverage, which includes running `--diff` and finding the path ([deploy-functions.test.sh:535](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:535)). Production behavior is correct through `show_machinery` ([deploy-functions.sh:135](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.sh:135)); the regression coverage is incomplete.

2. The new `--codebase vault` scenario does not prove the run successfully deploys vault. After `run`, it never asserts `CODE=0` or positively finds `cli deploy --only functions:vault`; it only proves npm test ran and that core was not requested ([deploy-functions.test.sh:554](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:554), [deploy-functions.test.sh:563](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:563)). A failure after npm test could therefore leave every new assertion passing. Add the exit-code and positive vault CLI assertions.

### Nits

- Both harnesses still reject and leak a successfully created scratch directory directly under `/`, because their accepted patterns require an intermediate directory ([deploy-functions.test.sh:26](/Users/christiehubley/my-clay-hub/scripts/deploy-functions.test.sh:26), [deploy-rules.test.sh:31](/Users/christiehubley/my-clay-hub/scripts/deploy-rules.test.sh:31)).
- The rules-harness comment still overstates the former cleanup risk: quoted `rm -rf "$T"` with empty `T` would not target the repository ([deploy-rules.test.sh:28](/Users/christiehubley/my-clay-hub/scripts/deploy-rules.test.sh:28)).

## Requested checks

- Rules-side `shared/` pinning is correctly implemented ([deploy-rules.sh:102](/Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh:102)), with a real fixture ([deploy-rules.test.sh:148](/Users/christiehubley/my-clay-hub/scripts/deploy-rules.test.sh:148)) and refusal test ([deploy-rules.test.sh:432](/Users/christiehubley/my-clay-hub/scripts/deploy-rules.test.sh:432)).
- Functions-side fixture and refusal coverage exist, but the requested `--diff` assertion remains absent.
- The vault/core direction is exercised, but its successful deployment is not established.
- Pinning `shared/` does not newly break either relevant rules case:
  - The last released rules commit, `2ad11ad`, already differs from today’s tip first at `firebase.json`, before `shared` is reached by the ordered comparison ([deploy-rules.sh:102](/Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh:102), [deploy-rules.sh:105](/Users/christiehubley/my-clay-hub/scripts/deploy-rules.sh:105)). It remains refused for the same earlier reason.
  - Today’s tip compares its `shared/` tree to itself and passes. `af5a87d` and branch HEAD also have the identical `shared/` tree ID.
- No blocking defect found anywhere in `main...d4-guard-install-all`.

`bash -n` and `git diff --check` passed. I did not run either guard suite because the sandbox cannot create its temporary directory. No files were modified, and no deployment or Google call occurred.

**merge after fixes**
