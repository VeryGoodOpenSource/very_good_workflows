# Architecture Review

Branch: `vgv-ai-bot/issue-441` (10 commits ahead of `main`, merge base `d3c8ac2`)
Repo: reusable GitHub Actions workflow templates + Docusaurus site + a new root Jest suite.

There is no Dart/Flutter source here, so the VGV layer model maps onto this repo as:

| VGV layer               | This repo                                                                 |
| ----------------------- | ------------------------------------------------------------------------- |
| Public contract / API   | `workflow_call` inputs, secrets, and outputs of `.github/workflows/*.yml` |
| Implementation          | the `jobs:`/`steps:` inside each template                                 |
| Consumer / presentation | `site/docs/workflows/*.md`, `README.md`, and `ci.yml`'s verification jobs |
| Test layer              | `test/workflows.test.js` + root `package.json`                            |
| Site project            | `site/` (its own npm project, its own CI in `site.yaml`)                  |

Dependency direction should flow one way: docs and `ci.yml` depend on the templates; templates depend on nothing in the repo. That direction holds. The problems are in contract correctness, contract documentation, and tooling placement.

---

## Layer Separation

- Violations found: 0 structural, 1 contract-consistency

  - `.github/workflows/flutter_package.yml:47` / `license_check.yml:26` / `flutter_pub_publish.yml:14` — `flutter_version_file` is resolved by `subosito/flutter-action` relative to `$GITHUB_WORKSPACE`, not relative to the template's own `working_directory` default. Every other path-shaped input in these templates (`working_directory`, `format_directories`, `collect_coverage_from`, `package_get_excludes`) is working-directory relative. The PR recognised exactly this asymmetry for `artifact_paths` and documented it loudly (`dart_package.md:146`, `flutter_package.md:165`), then omitted the same note for `flutter_version_file`. `ci.yml:65` and `ci.yml:131` pass the full `examples/flutter_package/.fvmrc` prefix, confirming the behaviour, while the docs example says `pubspec.yaml`.

- Clean: no template imports or reaches into `site/`, `test/`, or `examples/`. `test/workflows.test.js` reads the templates, docs, and README but is never referenced back by them — the test layer depends on the contract layer and not the reverse, which is correct. `site/` remains a self-contained npm project.

---

## Contract Design Assessment (state-management analogue)

### `flutter_version_file` — Issues found (Critical)

`.github/workflows/flutter_package.yml:51`, `flutter_pub_publish.yml:18`, `license_check.yml:30`, and the four doc pages all state some form of:

> "Takes precedence over `flutter_version` when set."

That is the opposite of what the action does. `subosito/flutter-action@v2.23.0` `setup.sh` lines 100-104:

```sh
if [ -n "$VERSION_FILE" ]; then
	if [ -n "$VERSION" ]; then
		echo "Cannot specify both a version and a version file"
		exit 1
	fi
```

The two inputs are **mutually exclusive**. Setting both hard-fails the Setup Flutter step with a message that names action inputs (`version` / `version file`) the consumer never typed, so the failure does not point back at `flutter_version` / `flutter_version_file`.

Impact: the docs actively invite the broken configuration. A consumer already pinning `flutter_version: "3.47.x"` who follows the docs to adopt `.fvmrc` for a "single source of truth" adds `flutter_version_file`, expects the file to win, and gets a red pipeline instead. This is the most likely adoption path for the feature.

Nothing guards it: `ci.yml:61` and `ci.yml:126` each set only one of the two, so the conflicting combination is never exercised, and `test/workflows.test.js` has no assertion about mutually exclusive inputs.

Two fixes, either acceptable:

1. Correct all seven descriptions to say the inputs are mutually exclusive and that setting both fails; add a `ci.yml` job or a unit assertion covering the combination.
2. Make the claim true in the template — blank out `flutter-version` when `flutter_version_file` is set, e.g. `flutter-version: ${{inputs.flutter_version_file != '' && '' || inputs.flutter_version}}` — and keep the docs as written.

### `artifact_paths` / `artifact_name` — Mostly correct

- The `if: ${{!cancelled() && inputs.artifact_paths != ''}}` guard is the right shape: opt-in, runs on failure, and `if-no-files-found: ignore` keeps the step silent when nothing matches. Good.
- Placement after the test step in both `dart_package.yml:163` and `flutter_package.yml:192` is symmetric across the two templates. Good.
- `artifact_name` defaults to `"artifacts"`. Two jobs in one caller workflow that both set `artifact_paths` and leave `artifact_name` alone collide, and `upload-artifact@v7` fails the job on a duplicate name. The default therefore breaks in precisely the monorepo/matrix case the docs spend three examples on. It is documented (`dart_package.md`, `flutter_package.md`) rather than designed away. A default that cannot collide (or making `artifact_name` required whenever `artifact_paths` is set) would remove the footgun.
- The repo-root-relative note is well written and correctly placed. No change needed there.

### `is_flutter` derivation — Correct

`license_check.yml:64` widening to `inputs.flutter_version != '' || inputs.flutter_version_file != ''` keeps the Dart/Flutter branch selection a single derived value consumed by both the setup step conditions and the `pub get` step at line 95. The derivation stays in one place. Good.

---

## Dependency Direction

- Direction violations: 0 (no circular or reverse dependency).
- `test/workflows.test.js` depends on three separate external shapes it does not own:
  - the filename set under `.github/workflows/` (`EXPECTED_TEMPLATES`, line 27),
  - the literal README substring `/.github/workflows/<file>@` (line 223),
  - the `site/docs/workflows/<base>.md` naming convention (line 218).

  This coupling is deliberate and documented in `CONTRIBUTING.md`, and the inline comments justify it. Acceptable, but it means a README restructure (table, matrix, or a different `uses:` spelling) fails the suite for a non-regression.

- Clean: `site/` has no dependency on the root npm project and vice versa. The two `package.json` files do not reference each other.

---

## Package / Project Structure

### Root npm project (`package.json`, `test/`) — Missing items

- Manifest exists, is `private: true`, has a clear description and a single `test` script. Good.
- **No lint or format tooling.** `site/package.json` carries `eslint`, `@eslint/js`, `eslint-plugin-jest`, and `prettier`, and `site.yaml` runs `npm run format:check` and `npm run lint` on every PR. The new root project has neither the devDependencies, the `eslint.config.js`, a `.prettierrc`, nor the CI steps. `site/eslint.config.js` scopes `files: ['*.js']` inside `site/`, and `site/.prettierrc` likewise never reaches the repo root, so `test/workflows.test.js` — the only JS the repo ships outside `site/` — is the one JS file with no quality gate. Existing JS is gated; new JS is not.
- Test directory exists (`test/`) and `jest.roots` is scoped to `<rootDir>/test`. Good.
- Single clear responsibility (validate the shipped templates). Good.
- Dependencies are minimal and appropriate (`jest`, `js-yaml`). No dependency on `site/`. Good.
- Duplicate jest declaration across `package.json` (`^30.5.1`) and `site/package.json` (`^30.5.1`) is unavoidable given two independent npm projects. Not a finding.

### `verify-workflow-templates` job (`ci.yml:10-28`) — Convention drift

`site.yaml` (the repo's existing Node job) uses `actions/setup-node@v7`, `node-version: 22.x`, and an explicit `cache-dependency-path`. The new job uses `actions/setup-node@v4` and `node-version: 20`. Two Node CI jobs in one repo now disagree on both the action major and the runtime. `package.json` `engines` says `>=20.0`, so nothing breaks, but the repo no longer has one answer to "what Node do we build on".

The `--include=dev` comment on line 24 is a defensive workaround for a `NODE_ENV` the repo never sets; `npm ci` already installs dev dependencies. Harmless but noise.

### Test suite coverage of the contract it exists to protect

The suite validates workflow _shape_: valid YAML, a `workflow_call` trigger, valid input `type`, boolean `required`, no default on a required input, well-formed secrets, a docs file exists, a README mention exists, and the template is exercised by `ci.yml`. The "validators reject malformed workflows" block (line 286) correctly guards against vacuous assertions — that is a good instinct and worth keeping.

What it does not check is the drift this very PR creates. This branch adds inputs to four templates and prose to four doc pages, and the only docs assertion is _a file with the right name exists_. An input added to a template with no matching `### input_name` heading in its doc page passes today, as does a doc heading for an input that no longer exists. An input-level docs-sync assertion would have caught nothing on this branch's structure but is the single highest-value addition given what the branch changes, and it is cheap: parse `workflow_call.inputs` keys, assert each appears as a heading in `site/docs/workflows/<base>.md`.

### `examples/flutter_package/.fvmrc` — Acceptable, with drift risk

The fixture is the right way to exercise `flutter_version_file` end to end. The Flutter version for the example package is now declared in `ci.yml:43` (`3.47.x`), `examples/flutter_package/.fvmrc` (`3.47.2`), and the example's `pubspec.yaml` environment constraint. Nothing keeps the three aligned.

---

## Verdict

Fix 1 Critical before merging. The `flutter_version_file` precedence claim is wrong in three workflow input descriptions and four doc pages, and the configuration it recommends hard-fails the pipeline. The remaining findings are contract-consistency and tooling-placement issues that should be fixed but do not break consumers.
