# Code Simplicity Review — vgv-ai-bot/issue-441

## Core Purpose

Add structural validation (a Jest + js-yaml test suite) for the reusable GitHub Actions
workflow templates in `.github/workflows/`, wire that suite into `ci.yml`, and document how
it fits alongside the existing functional (example-package) verification. The diff against
`main` also carries forward already-released work (artifact upload, `flutter_version_file`,
a `very_good_cli` bump, the 1.21.0 release commit) that landed on this branch before the
test commit; that part is reviewed here only where it introduces duplication, not
re-litigated as new work.

## Unnecessary Complexity Found

- `package.json` (new, root) adds `jest@^30.5.1` and `js-yaml@^4.1.0` as a second,
  independent Node toolchain. `site/package.json` already depends on `jest@^30.5.1`.
  The repo now carries two `node_modules` trees, two lockfiles, and two places that must be
  bumped in lockstep for the same package. The two jest installs serve different purposes
  today (site's is for `eslint-plugin-jest` linting, root's actually runs tests), so this
  isn't a pure duplicate, but a single root-level `package.json` (with `site` as a
  sub-project or npm workspace) would remove one lockfile and one `npm ci` step from CI.
- `test/workflows.test.js:120-129` — `'at least one reusable workflow template is
provided'` asserts `templateFiles.length > 0`. The very next test,
  `'discovers exactly the expected set of templates'`, asserts `templateFiles` equals the
  hardcoded, non-empty `EXPECTED_TEMPLATES` list. The first test can never fail without the
  second also failing; it adds a second assertion path for no extra coverage.
- `test/workflows.test.js:286-324` (`'validators reject malformed workflows'`) unit-tests
  the test file's own helper functions (`isReusableTemplate`, `findInvalidJobs`,
  `findInvalidInputs`) rather than the workflow files themselves. The in-file comment
  justifies this as a guard against "vacuous validators," which is a reasonable rationale,
  but it is still meta-testing the test harness — a form of complexity a reviewer should
  double check stays cheap to maintain as the helpers evolve.

## Code to Remove

- `test/workflows.test.js:125-129` — the `'at least one reusable workflow template is
provided'` test. Estimated LOC reduction: 5.

## Simplification Recommendations

1. Consolidate the two Node toolchains.
   - Current: root `package.json` (jest, js-yaml, `npm test`) and `site/package.json`
     (jest, eslint, docusaurus) are independent projects with separate lockfiles.
   - Proposed: use a single root `package.json` with an npm workspace for `site/`, or move
     the workflow-template test suite under `site` (it already has jest as a dependency and
     a working CI install step) if the coupling to Docusaurus tooling is acceptable.
   - Impact: one lockfile instead of two, one `npm ci` in CI instead of two, one version of
     jest to track. This is a judgment call — the domains (infra YAML tests vs. docs site)
     are different enough that separate configs are defensible — but it's worth a deliberate
     decision rather than an accidental byproduct of adding the test suite.
2. Drop the redundant non-emptiness test in `test/workflows.test.js`.
   - Current: two tests assert overlapping facts about `templateFiles`.
   - Proposed: keep only `'discovers exactly the expected set of templates'`.
   - Impact: 5 fewer lines, one fewer test to keep in sync with no coverage loss.

## YAGNI Violations

None found that rise to the level of a violation. The new `verify-workflow-templates` job
in `ci.yml`, the `artifact_name`/`artifact_paths` inputs, and the `flutter_version_file`
input are all exercised by the test suite and referenced in the docs, so nothing here is
speculative or unused.

## Notes on pre-existing (already-released) portions of the diff

These are not new to this PR's actual intent (they were already shipped in 1.21.0 per
`CHANGELOG.md`) but showed up in `main...HEAD` because `main` hasn't caught up:

- The `📤 Upload Artifacts` step is duplicated verbatim (module differences only in the
  `artifact_paths` description wording) between `dart_package.yml` and
  `flutter_package.yml`. GitHub Actions reusable workflows have no mechanism to share a
  step across two separate `workflow_call` files, so this duplication is close to
  unavoidable given the current file-per-template structure. Not actionable without a
  larger restructuring; flagged only for awareness.
- `flutter_version_file`'s description is repeated near-verbatim across
  `flutter_package.yml`, `flutter_pub_publish.yml`, `license_check.yml`, and their three
  corresponding docs pages. This matches the site's existing convention of each workflow
  doc page fully self-documenting its own inputs (the same is true of `ssh_key`,
  `working_directory`, etc. today), so it isn't a new problem introduced by this change.

## Final Assessment

Total potential LOC reduction: under 1% of the diff (roughly 5-10 lines in the test file;
the toolchain consolidation is a structural call, not a line-count issue).
Complexity score: Low.
Recommended action: Minor tweaks only. The test suite is well-scoped to its stated purpose
(catch a missing docs page, a missing CI wiring, a malformed `workflow_call` input) and
does not over-engineer beyond that.
