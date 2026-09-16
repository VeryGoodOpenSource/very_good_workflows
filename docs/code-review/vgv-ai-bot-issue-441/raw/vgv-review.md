# VGV Code Review

Branch: `vgv-ai-bot/issue-441` (diff against `main`)
Repo: `/Users/marcossevilla/development/very_good_oss/very_good_workflows`

## Summary

The headline change is a Jest suite (`test/workflows.test.js`, 143 passing tests) that structurally validates every reusable workflow template, wired into `ci.yml` as `verify-workflow-templates`. The diff also carries the `flutter_version_file` input, the `artifact_paths`/`artifact_name` upload inputs, and a `very_good_cli` 1.4.0 → 1.5.0 bump. The suite is genuinely good: it guards discovery regressions, proves its own validators reject malformed shapes, and ties templates to docs, README, and CI coverage. It needs work before merge on two fronts. First, the `flutter_version_file` documentation is factually wrong in four places: `subosito/flutter-action`'s `setup.sh` hard-errors with `Cannot specify both a version and a version file`, so the promised "takes precedence" behavior is actually a build failure. Second, the new suite validates shape but not the two drift classes that actually bite consumers, and adding those checks immediately surfaces three real defects already in the repo (`inputs.dart_sdk` referenced but never declared in two templates, `timeout_minutes` undocumented in three docs pages). The new JS also sits outside the repo's lint and format enforcement.

Verified locally: `npm ci --include=dev && npm test` → 143 passed, 1 suite, 0.27s.

---

## 🔴 Critical — Must Fix Before Merge

- **`.github/workflows/flutter_package.yml:51`, `.github/workflows/flutter_pub_publish.yml:18`, `.github/workflows/license_check.yml:30`, `site/docs/workflows/flutter_package.md:69`, `site/docs/workflows/flutter_pub_publish.md:36`, `site/docs/workflows/license_check.md:56`** — `flutter_version_file` is documented as taking precedence over `flutter_version`. It does not.
  - Why: `subosito/flutter-action` v2.23.0's `setup.sh` contains

    ```sh
    if [ -n "$VERSION_FILE" ]; then
      if [ -n "$VERSION" ]; then
        echo "Cannot specify both a version and a version file"
        exit 1
      fi
    ```

    Every consumer already passing `flutter_version` who follows this documentation and adds `flutter_version_file` gets a hard job failure, not the documented override. These workflows are consumed by every VGV repo, so the blast radius is every downstream CI.

  - Fix: change the wording to "mutually exclusive with `flutter_version` — setting both fails the job" across all six locations, and add a CI job to `ci.yml` (or a suite assertion) that pins the contract. Consider failing fast inside the template with a clear message instead of leaking the action's error.

---

## 🟡 Important — Should Fix

- **`test/workflows.test.js:95-104`** — The suite never checks that every `inputs.X` referenced in a workflow body is declared under `workflow_call.inputs`.
  - Why: this check finds real bugs today. `.github/workflows/flutter_pub_publish.yml:71` and `.github/workflows/mason_publish.yml:47` both pass `sdk: ${{inputs.dart_sdk}}` to `dart-lang/setup-dart`, but neither declares a `dart_sdk` input. The expression resolves to empty, the SDK silently falls back to the action default, and GitHub rejects any caller who tries to pass `dart_sdk`. A typo guard is exactly what a structural-validation PR is for.
  - Fix: add a test that scrapes `/inputs\.([A-Za-z0-9_]+)/g` from each template's source and asserts the set is a subset of the declared input names, then either declare `dart_sdk` in both templates or drop the reference.

- **`test/workflows.test.js:271-281`** — The "docs stay in sync" block only asserts a `.md` file exists per template; it never checks the docs cover the declared inputs.
  - Why: the same scrape shows `timeout_minutes` is declared in `dart_pub_publish.yml`, `flutter_pub_publish.yml`, and `mason_publish.yml` but documented in none of the three docs pages. File existence is the weakest possible sync guarantee, and per-input drift is what consumers hit.
  - Fix: assert every declared input name appears as a `### \`input_name\`` heading in the matching docs page (and optionally the reverse, that no documented heading names a nonexistent input).

- **`.github/workflows/ci.yml:18-20`** — The new job pins `actions/setup-node@v4` with `node-version: 20`, while `site.yaml:22` and `site_deploy.yaml:27` use `actions/setup-node@v7` with `node-version: 22.x`.
  - Why: two Node toolchains in one repo means the new suite is validated on a runtime nobody else uses, and the older action major drifts away from the cache behavior the rest of CI relies on. Every other action in this repo is on `@v7`.
  - Fix: use `actions/setup-node@v7` with `node-version: 22.x`, and align `engines.node` in `package.json` accordingly.

- **`package.json`** — The new root package declares no lint or format tooling, and `ci.yml` runs neither against `test/workflows.test.js`.
  - Why: `site/` enforces both (`format:check` and `lint` steps in `site.yaml:31-35`, with `site/.prettierrc` and `site/eslint.config.js`). Running that same config over the new file reports style issues, so the repo now has JS held to two different bars. VGV expects every package to carry its own lint config and test directory.
  - Fix: add a root `.prettierrc` (`{"singleQuote": true}`, matching `site/.prettierrc`) and an `eslint.config.js` covering `test/**/*.js`, add `lint` and `format:check` scripts, run `npx prettier --write test/`, and add both steps to `verify-workflow-templates`.

- **`site/docs/workflows/flutter_package.md:69`** — The `pubspec.yaml` example for `flutter_version_file` omits the Windows constraint.
  - Why: `setup.sh` requires `yq` for any version file that is not `.fvmrc` or `fvm_config.json`, and `yq` is not pre-installed on GitHub's Windows runners. `flutter_package.yml` explicitly supports `runs_on: windows-latest` (there is a dedicated `verify-flutter-windows` job for it), so a Windows consumer following this doc gets `yq not found`.
  - Fix: note that `pubspec.yaml` requires `yq` on Windows runners and recommend `.fvmrc` or `fvm_config.json` there.

- **`.github/workflows/ci.yml:61-68`** — `verify-flutter-version-file` exercises exactly one path: `.fvmrc` on Ubuntu with `flutter_version` unset.
  - Why: the untested combinations are the ones that fail. `pubspec.yaml` as the version file, a Windows runner, and the both-inputs-set conflict all go unverified, and the last one is the case the docs actively get wrong.
  - Fix: add a `pubspec.yaml` variant and, if the mutual-exclusion contract matters, assert it in the Jest suite rather than burning a CI job on a deliberate failure.

---

## 🔵 Suggestions — Nice to Have

- **`.github/workflows/license_check.yml:78`** — Uses the floating `subosito/flutter-action@v2`, while `flutter_package.yml:125` and `flutter_pub_publish.yml:51` pin `@v2.23.0`.
  - Suggestion: pin `@v2.23.0` here too. Floating majors in a workflow that handles an SSH key is a supply-chain risk, and the inconsistency means the two paths can resolve to different action behavior for the same `flutter_version_file` input.

- **`examples/flutter_package/.fvmrc:2`** — Pins `3.47.2` while `ci.yml` pins `"3.47.x"` for the sibling jobs.
  - Suggestion: these drift the next time the SDK is bumped and nothing catches it. Either assert the `.fvmrc` major/minor matches the `ci.yml` value in the Jest suite, or note the pairing in `CONTRIBUTING.md`'s SDK-bump instructions.

- **`.github/workflows/flutter_pub_publish.yml:60`** — Step name is `🔐 Setup Pub Credentials\` with a stray trailing backslash.
  - Suggestion: drop the backslash; it renders literally in the Actions UI.

- **`test/workflows.test.js:221-224`** — `fs.readFileSync(readmePath)` runs inside a per-template test, re-reading the README once per template.
  - Suggestion: hoist the read to module scope alongside `ciSource`, which the `ci.yml` block already does correctly.

- **`test/workflows.test.js:140-141`** — `loadYaml(filePath)` is called twice per file to assert "does not throw" and "not null".
  - Suggestion: call once into a local and assert against it.

- **`test/workflows.test.js:234-238`** — The `uses:` regex scrapes raw source, so a commented-out `uses: ./.github/workflows/foo.yml` would count as "exercised".
  - Suggestion: walk `ciDoc.jobs` for `job.uses` instead of regexing the source; the doc is already parsed on line 229.

- **`.gitignore:3`** — No trailing newline (pre-existing, but the file was touched).
  - Suggestion: add one.

- **`package.json` / `site/package.json`** — Jest is now a devDependency in two packages with two lockfiles.
  - Suggestion: acceptable given the root suite tests `.github/workflows` and the site suite tests the site, but keep the two Jest majors in step so contributors do not hit two different runners.

- **`.github/workflows/ci.yml:24`** — The `--include=dev` comment explains a defense against `NODE_ENV=production` that does not apply to GitHub-hosted runners.
  - Suggestion: harmless, but `npm ci` alone matches `site.yaml:29` and is one less thing to explain.

---

## Simplicity Assessment

- **Lines that could be removed:** ~10 in `test/workflows.test.js` (duplicate `loadYaml` calls, the per-test README read, the `doc[true]` YAML 1.1 fallback on line 57 that js-yaml v4 can never produce).
- **Unnecessary abstractions:** none. The four module-level helpers each have more than one caller and are directly unit-tested by the `validators reject malformed workflows` block.
- **YAGNI violations:** `getTriggers`' `doc[true]` branch is defensive code for a parser configuration this repo does not use. It is three lines and well-commented, so it stays cheap, but it is untested for the `true` path.
- **Complexity verdict:** already minimal. The suite is well-proportioned to the problem. The gap is coverage, not complexity.

## Testing Assessment

- **New code with tests:** ✅ — the suite tests its own validators (`test/workflows.test.js:286-324`), which is the right instinct and the thing most workflow-validation suites skip.
- **Test quality:** meaningful, with real edge cases. No tautologies, no vacuous assertions. The `at least one reusable template` and `discovers exactly the expected set` guards correctly defend against a silent-skip regression in `test.each`.
- **Structural coverage:** complete for YAML validity, `workflow_call` shape, input types, `required`/`default` contradictions, and secret shape.
- **Behavioral coverage:** partial. Undeclared `inputs.*` references and per-input docs drift are unchecked, and both classes have live defects in the repo right now. The `flutter_version_file`/`flutter_version` mutual exclusion is unverified anywhere.
- **CI coverage:** the new `verify-flutter-version-file` and `verify-license-check-flutter-version-file` jobs are correctly added to the `build` needs list, so the gate cannot pass while they fail.
