# Code Review — `vgv-ai-bot/issue-441`

23 findings · 🔴 1 critical · 🟡 10 important · 🔵 12 suggestions
Across 17 files (lockfiles excluded). Agents: vgv-review-agent, architecture-review-agent, test-quality-review-agent, code-simplicity-review-agent. All four completed.

## Findings Index

| ID         | Severity      | Rule                                      | Location                                       | Finding                                                                                      |
| ---------- | ------------- | ----------------------------------------- | ---------------------------------------------- | -------------------------------------------------------------------------------------------- |
| FINDING-01 | 🔴 Critical   | `vgv/incorrect-input-precedence-docs`     | `.github/workflows/flutter_package.yml:51`     | `flutter_version_file` does not take precedence over `flutter_version`, it hard-fails        |
| FINDING-02 | 🟡 Important  | `vgv/inconsistent-action-pinning`         | `.github/workflows/ci.yml:17`                  | New Node CI job disagrees with site.yaml on setup-node major and Node version                |
| FINDING-03 | 🟡 Important  | `vgv/narrow-ci-coverage`                  | `.github/workflows/ci.yml:61`                  | `flutter_version_file` CI coverage is limited to `.fvmrc` on Ubuntu                          |
| FINDING-04 | 🟡 Important  | `tests/silent-failure-mode-untested`      | `.github/workflows/dart_package.yml:161`       | Artifact upload's `if-no-files-found: ignore` hides a broken glob from both test layers      |
| FINDING-05 | 🟡 Important  | `simplicity/duplicate-tooling-dependency` | `package.json`                                 | Root package.json duplicates a jest toolchain site/package.json already has                  |
| FINDING-06 | 🟡 Important  | `vgv/missing-lint-and-format-enforcement` | `package.json`                                 | New root JS is under no lint or format gate                                                  |
| FINDING-07 | 🟡 Important  | `architecture/path-input-consistency`     | `site/docs/workflows/flutter_package.md:69`    | `flutter_version_file` is repo-root relative but documented as if working_directory relative |
| FINDING-08 | 🟡 Important  | `vgv/undocumented-platform-constraint`    | `site/docs/workflows/flutter_package.md:69`    | Document the yq requirement for pubspec.yaml version files on Windows                        |
| FINDING-09 | 🟡 Important  | `tests/missing-wiring-assertion`          | `test/workflows.test.js`                       | New inputs aren't checked for correct step-level wiring                                      |
| FINDING-10 | 🟡 Important  | `vgv/missing-undeclared-input-check`      | `test/workflows.test.js:95`                    | Assert every referenced `inputs.X` is declared in `workflow_call`                            |
| FINDING-11 | 🟡 Important  | `vgv/weak-docs-sync-check`                | `test/workflows.test.js:271`                   | Verify docs cover every declared input, not just that a page exists                          |
| FINDING-12 | 🔵 Suggestion | `vgv/redundant-npm-flag`                  | `.github/workflows/ci.yml:24`                  | Simplify the dependency install step                                                         |
| FINDING-13 | 🔵 Suggestion | `architecture/colliding-default-value`    | `.github/workflows/dart_package.yml:10`        | `artifact_name` default "artifacts" collides across jobs in one run                          |
| FINDING-14 | 🔵 Suggestion | `vgv/stray-character-in-step-name`        | `.github/workflows/flutter_pub_publish.yml:60` | Remove the trailing backslash from the step name                                             |
| FINDING-15 | 🔵 Suggestion | `vgv/floating-action-major`               | `.github/workflows/license_check.yml:78`       | Pin subosito/flutter-action to the exact version used elsewhere                              |
| FINDING-16 | 🔵 Suggestion | `vgv/missing-trailing-newline`            | `.gitignore:3`                                 | Add a trailing newline to .gitignore                                                         |
| FINDING-17 | 🔵 Suggestion | `vgv/duplicated-version-pin`              | `examples/flutter_package/.fvmrc:2`            | Guard the .fvmrc pin against ci.yml drift                                                    |
| FINDING-18 | 🔵 Suggestion | `vgv/untested-defensive-branch`           | `test/workflows.test.js:57`                    | Drop or test the YAML 1.1 boolean-key fallback                                               |
| FINDING-19 | 🔵 Suggestion | `simplicity/redundant-assertion`          | `test/workflows.test.js:125`                   | Non-emptiness test is subsumed by the exact-template-set test                                |
| FINDING-20 | 🔵 Suggestion | `vgv/duplicate-parse-in-assertion`        | `test/workflows.test.js:140`                   | Parse each workflow once in the YAML validity test                                           |
| FINDING-21 | 🔵 Suggestion | `vgv/repeated-file-read-in-test`          | `test/workflows.test.js:221`                   | Hoist the README read out of the per-template test                                           |
| FINDING-22 | 🔵 Suggestion | `vgv/source-regex-over-parsed-doc`        | `test/workflows.test.js:234`                   | Collect ci.yml job `uses` from the parsed doc, not raw source                                |
| FINDING-23 | 🔵 Suggestion | `simplicity/meta-test-indirection`        | `test/workflows.test.js:286`                   | Tests assert on the test file's own helper functions rather than workflow behavior           |

## Critical

### FINDING-01 · `vgv/incorrect-input-precedence-docs` · `.github/workflows/flutter_package.yml:51`

`flutter_version_file` does not take precedence over `flutter_version`, it hard-fails. Also affects `flutter_pub_publish.yml:18`, `license_check.yml:30`, `site/docs/workflows/flutter_package.md:69`, `flutter_pub_publish.md:36`, `license_check.md:54`.

- **Why**: subosito/flutter-action@v2.23.0's setup.sh exits 1 with "Cannot specify both a version and a version file", so consumers who follow the docs and set both get a hard CI failure naming inputs they never typed.
- **Fix**: Reword all six descriptions to "mutually exclusive with `flutter_version` — setting both fails the job", or blank the action's `flutter-version` when `flutter_version_file` is set (`flutter-version: ${{ inputs.flutter_version_file != '' && '' || inputs.flutter_version }}`).
- **Reported by**: vgv-review-agent, architecture-review-agent · [details](raw/vgv-review.md) · [details](raw/architecture-review.md)

## Important

### FINDING-02 · `vgv/inconsistent-action-pinning` · `.github/workflows/ci.yml:17`

New Node CI job disagrees with site.yaml on setup-node major and Node version.

- **Why**: `verify-workflow-templates` uses actions/setup-node@v4 with node 20 while site.yaml and site_deploy.yaml use @v7 with 22.x, so the repo has two answers to what Node it builds on.
- **Fix**: Switch the new job to actions/setup-node@v7 with node-version 22.x and an explicit cache-dependency-path, and match `engines.node` in package.json.
- **Reported by**: vgv-review-agent, architecture-review-agent, test-quality-review-agent · [details](raw/vgv-review.md) · [details](raw/architecture-review.md) · [details](raw/test-quality-review.md)

### FINDING-03 · `vgv/narrow-ci-coverage` · `.github/workflows/ci.yml:61`

`flutter_version_file` CI coverage is limited to `.fvmrc` on Ubuntu.

- **Why**: The only exercised path is `.fvmrc` on Ubuntu with `flutter_version` unset, leaving pubspec.yaml, Windows, and the documented both-inputs-set behavior unverified.
- **Fix**: Add a pubspec.yaml variant job and one job that sets both inputs, so the mutual-exclusion contract in FINDING-01 is pinned by CI rather than assumed.
- **Reported by**: vgv-review-agent, test-quality-review-agent · [details](raw/vgv-review.md) · [details](raw/test-quality-review.md)

### FINDING-04 · `tests/silent-failure-mode-untested` · `.github/workflows/dart_package.yml:161`

Artifact upload's `if-no-files-found: ignore` hides a broken glob from both test layers. Mirrored in `flutter_package.yml:190`.

- **Why**: If the `artifact_paths` glob goes stale the step and job stay green, and no Jest assertion inspects the actual path/name values, so a broken artifact upload ships undetected.
- **Fix**: Add a downstream check (a follow-up job using actions/download-artifact) or flip `if-no-files-found` to `warn`/`error` on the examples/ verification jobs to prove the artifact really lands.
- **Reported by**: test-quality-review-agent · [details](raw/test-quality-review.md)

### FINDING-05 · `simplicity/duplicate-tooling-dependency` · `package.json`

Root package.json duplicates a jest toolchain site/package.json already has.

- **Why**: The repo now carries two node_modules trees and two lockfiles, each pinning jest independently, for a repo this small.
- **Fix**: Consolidate into one root package.json (npm workspace covering `site/`), or add the workflow test suite under site's existing jest setup.
- **Reported by**: code-simplicity-review-agent · [details](raw/code-simplicity-review.md)

### FINDING-06 · `vgv/missing-lint-and-format-enforcement` · `package.json`

New root JS is under no lint or format gate.

- **Why**: `site/` enforces eslint and prettier in CI, but `test/workflows.test.js` sits outside `site/eslint.config.js` and `site/.prettierrc` scope and already fails `prettier --check` against the repo's own config.
- **Fix**: Add a root `.prettierrc` and `eslint.config.js` plus lint/format:check scripts, run `prettier --write test/`, and add both steps to `verify-workflow-templates`.
- **Reported by**: vgv-review-agent, architecture-review-agent · [details](raw/vgv-review.md) · [details](raw/architecture-review.md)

### FINDING-07 · `architecture/path-input-consistency` · `site/docs/workflows/flutter_package.md:69`

`flutter_version_file` is repo-root relative but documented as if working_directory relative.

- **Why**: The PR added an explicit repo-root note for `artifact_paths` but omitted it here, so monorepo consumers with `working_directory` set will pass `pubspec.yaml` and resolve the wrong file.
- **Fix**: Add the same "resolved from the repository root, not `working_directory`" note to `flutter_version_file` in all three doc pages and the input descriptions.
- **Reported by**: architecture-review-agent · [details](raw/architecture-review.md)

### FINDING-08 · `vgv/undocumented-platform-constraint` · `site/docs/workflows/flutter_package.md:69`

Document the yq requirement for pubspec.yaml version files on Windows.

- **Why**: setup.sh needs `yq` for any version file other than `.fvmrc` or `fvm_config.json`, and yq is absent from the Windows runners `flutter_package.yml` explicitly supports.
- **Fix**: Note the Windows yq constraint and recommend `.fvmrc` or `fvm_config.json` for Windows runs.
- **Reported by**: vgv-review-agent · [details](raw/vgv-review.md)

### FINDING-09 · `tests/missing-wiring-assertion` · `test/workflows.test.js`

New inputs aren't checked for correct step-level wiring.

- **Why**: A swapped or removed `artifact_name`/`artifact_paths`/`flutter_version_file` reference inside a step's `with:` block still passes all 143 assertions, since the suite only checks `workflow_call.inputs` shape and job-level `steps`/`runs-on`/`uses`.
- **Fix**: Assert per template that `jobs.build.steps` uses each new input in the expected step's `with:` (Upload Artifacts for artifact_name/artifact_paths, Flutter setup for flutter_version_file, and the `is_flutter` env expression in license_check.yml).
- **Reported by**: test-quality-review-agent · [details](raw/test-quality-review.md)

### FINDING-10 · `vgv/missing-undeclared-input-check` · `test/workflows.test.js:95`

Assert every referenced `inputs.X` is declared in `workflow_call`.

- **Why**: The check finds live bugs — `flutter_pub_publish.yml:71` and `mason_publish.yml:47` pass `${{ inputs.dart_sdk }}` to setup-dart but never declare `dart_sdk`, so it silently resolves to empty.
- **Fix**: Scrape `/inputs\.([A-Za-z0-9_]+)/g` per template, assert the set is a subset of declared input names, then declare or remove `dart_sdk`.
- **Reported by**: vgv-review-agent · [details](raw/vgv-review.md)

### FINDING-11 · `vgv/weak-docs-sync-check` · `test/workflows.test.js:271`

Verify docs cover every declared input, not just that a page exists.

- **Why**: File existence is the weakest sync guarantee — `timeout_minutes` is declared in three publish templates and documented in none of their docs pages, and this branch adds inputs to four templates.
- **Fix**: Assert each declared input appears as a `### input_name` heading in the matching `site/docs/workflows/<base>.md`, and vice versa.
- **Reported by**: vgv-review-agent, architecture-review-agent · [details](raw/vgv-review.md) · [details](raw/architecture-review.md)

## Suggestions

### FINDING-12 · `vgv/redundant-npm-flag` · `.github/workflows/ci.yml:24`

Simplify the dependency install step.

- **Why**: The `--include=dev` comment guards against a `NODE_ENV=production` case that does not occur on GitHub-hosted runners, and site.yaml uses plain `npm ci`.
- **Fix**: Use `npm ci` to match the existing convention.
- **Reported by**: vgv-review-agent · [details](raw/vgv-review.md)

### FINDING-13 · `architecture/colliding-default-value` · `.github/workflows/dart_package.yml:10`

`artifact_name` default "artifacts" collides across jobs in one run.

- **Why**: Two jobs in the same caller workflow that both set `artifact_paths` and leave the default fail on upload-artifact's duplicate-name conflict, which is the monorepo case the docs target.
- **Fix**: Use a non-colliding default (or require `artifact_name` whenever `artifact_paths` is set) instead of documenting the footgun.
- **Reported by**: architecture-review-agent · [details](raw/architecture-review.md)

### FINDING-14 · `vgv/stray-character-in-step-name` · `.github/workflows/flutter_pub_publish.yml:60`

Remove the trailing backslash from the step name.

- **Why**: `🔐 Setup Pub Credentials\` renders the backslash literally in the Actions UI.
- **Fix**: Delete the trailing backslash.
- **Reported by**: vgv-review-agent · [details](raw/vgv-review.md)

### FINDING-15 · `vgv/floating-action-major` · `.github/workflows/license_check.yml:78`

Pin subosito/flutter-action to the exact version used elsewhere.

- **Why**: This workflow handles an SSH key yet floats on `@v2` while `flutter_package.yml` and `flutter_pub_publish.yml` pin `@v2.23.0`, so the new flutter-version-file input rides an unpinned dependency.
- **Fix**: Pin to `@v2.23.0`.
- **Reported by**: vgv-review-agent, architecture-review-agent · [details](raw/vgv-review.md) · [details](raw/architecture-review.md)

### FINDING-16 · `vgv/missing-trailing-newline` · `.gitignore:3`

Add a trailing newline to .gitignore.

- **Why**: The file still ends without a newline after the additions.
- **Fix**: Append a newline.
- **Reported by**: vgv-review-agent · [details](raw/vgv-review.md)

### FINDING-17 · `vgv/duplicated-version-pin` · `examples/flutter_package/.fvmrc:2`

Guard the .fvmrc pin against ci.yml drift.

- **Why**: `.fvmrc` pins 3.47.2 while ci.yml pins `3.47.x` for sibling jobs, and nothing catches the two diverging on the next SDK bump.
- **Fix**: Assert the `.fvmrc` version matches ci.yml's `flutter_version` in the Jest suite, or document the pairing in CONTRIBUTING.md.
- **Reported by**: vgv-review-agent, architecture-review-agent · [details](raw/vgv-review.md) · [details](raw/architecture-review.md)

### FINDING-18 · `vgv/untested-defensive-branch` · `test/workflows.test.js:57`

Drop or test the YAML 1.1 boolean-key fallback.

- **Why**: js-yaml v4 never produces a `true` key for `on:`, so the branch is dead defensive code with no test.
- **Fix**: Remove it, or add a case to the validators block that covers it.
- **Reported by**: vgv-review-agent · [details](raw/vgv-review.md)

### FINDING-19 · `simplicity/redundant-assertion` · `test/workflows.test.js:125`

Non-emptiness test is subsumed by the exact-template-set test.

- **Why**: "discovers exactly the expected set of templates" already fails whenever `templateFiles` is empty, since `EXPECTED_TEMPLATES` is a hardcoded non-empty list.
- **Fix**: Delete the "at least one reusable workflow template is provided" test.
- **Reported by**: code-simplicity-review-agent · [details](raw/code-simplicity-review.md)

### FINDING-20 · `vgv/duplicate-parse-in-assertion` · `test/workflows.test.js:140`

Parse each workflow once in the YAML validity test.

- **Why**: `loadYaml` runs twice per file to assert "does not throw" and "not null".
- **Fix**: Assign the parse result to a local and assert against it.
- **Reported by**: vgv-review-agent · [details](raw/vgv-review.md)

### FINDING-21 · `vgv/repeated-file-read-in-test` · `test/workflows.test.js:221`

Hoist the README read out of the per-template test.

- **Why**: `readFileSync` runs once per template inside `test.each` when the content never changes.
- **Fix**: Read it once at module scope alongside `ciSource`.
- **Reported by**: vgv-review-agent · [details](raw/vgv-review.md)

### FINDING-22 · `vgv/source-regex-over-parsed-doc` · `test/workflows.test.js:234`

Collect ci.yml job `uses` from the parsed doc, not raw source.

- **Why**: The regex scrapes raw text, so a commented-out `uses: ./.github/workflows/foo.yml` would count as exercised.
- **Fix**: Iterate `ciDoc.jobs` and read `job.uses`, since the doc is already parsed nearby.
- **Reported by**: vgv-review-agent · [details](raw/vgv-review.md)

### FINDING-23 · `simplicity/meta-test-indirection` · `test/workflows.test.js:286`

Tests assert on the test file's own helper functions rather than workflow behavior.

- **Why**: The "validators reject malformed workflows" block tests `isReusableTemplate`/`findInvalidJobs`/`findInvalidInputs` directly instead of through real workflow fixtures, adding a layer that must stay in sync with the helpers.
- **Fix**: Keep only if it stays cheap to maintain, or fold the malformed-shape cases into small fixture workflow files exercised through the normal assertions.
- **Reported by**: code-simplicity-review-agent · [details](raw/code-simplicity-review.md)

## Why this matters

The test suite this branch adds is a real step up, and it passes (143 tests). The gap is that it validates workflow _shape_ rather than workflow _wiring_, so the defects it would most usefully catch still slip through: an undeclared `dart_sdk` input resolving to empty, undocumented inputs, and a `flutter_version_file` contract the docs describe backwards. The biggest lever is FINDING-01 plus FINDING-09/10/11 — correct the precedence claim, then extend the suite to assert input wiring and docs coverage so the claim can't drift again.
