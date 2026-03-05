# AGENTS.md — Very Good Workflows

## Project Overview

This repository is a collection of reusable [GitHub Actions workflows](https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions) maintained by [Very Good Ventures](https://verygood.ventures). The primary deliverable is the YAML workflow files consumed by other repositories. Two example packages exist solely to validate the workflows in CI, and a Docusaurus site provides public documentation.

## Project Structure

```
.github/
  workflows/          # Reusable workflow YAML files (primary deliverable)
    ci.yml            # Internal CI — runs all checks against the examples
    dart_package.yml  # Reusable workflow for Dart packages
    flutter_package.yml
    dart_pub_publish.yml
    flutter_pub_publish.yml
    pana.yml
    spell_check.yml
    semantic_pull_request.yml
    license_check.yml
    mason_publish.yml
    release_please.yml
  cspell.json         # Spell check dictionary configuration
  dependabot.yaml     # Automated dependency updates
  ISSUE_TEMPLATE/     # Issue templates (one per conventional commit type)
  pull_request_template.md
examples/
  dart_package/       # Minimal Dart package used to verify dart_package.yml
  flutter_package/    # Minimal Flutter package used to verify flutter_package.yml
site/                 # Docusaurus documentation site (workflows.vgv.dev)
  docs/workflows/     # One .md file per reusable workflow
  package.json
  docusaurus.config.js
.release-please-config.json   # Release automation configuration
.release-please-manifest.json # Tracks current version (currently 1.18.1)
```

## Build / Lint / Test Commands

### Example Dart Package (`examples/dart_package/`)

These commands mirror what `.github/workflows/dart_package.yml` runs in CI.

```sh
# Install dependencies (very_good_cli is used for testing)
dart pub global activate very_good_cli
dart pub get

# Check formatting (fails on any diff)
dart format --set-exit-if-changed .

# Analyze (all infos and warnings are fatal)
dart analyze --fatal-infos --fatal-warnings lib test

# Run all tests with coverage + enforce minimum (CI uses very_good dart test)
very_good dart test -j 4 --coverage --platform vm --min-coverage 100

# Exclude generated files from coverage
very_good dart test --coverage --min-coverage 100 --exclude-coverage '**/*.g.dart'

# Show uncovered lines (bonus over the old very_good_coverage action)
very_good dart test --coverage --min-coverage 100 --show-uncovered

# Run a single test file
dart test test/src/dart_package_test.dart

# Run a single test by name
dart test --name "can be instantiated"

# Bloc lint (enabled by default in dart_package.yml)
dart pub global activate bloc_tools
bloc lint .
```

### Example Flutter Package (`examples/flutter_package/`)

These commands mirror what `.github/workflows/flutter_package.yml` runs in CI.

```sh
# Install dependencies (very_good_cli is used for testing)
flutter pub global activate very_good_cli
flutter pub get

# Check formatting
dart format --set-exit-if-changed lib test

# Analyze
flutter analyze lib test

# Run all tests with coverage + enforce minimum (CI uses very_good test)
very_good test -j 4 --coverage --min-coverage 100 --test-randomize-ordering-seed random

# Exclude generated files from coverage
very_good test --coverage --min-coverage 100 --exclude-coverage '**/*.g.dart'

# Show uncovered lines (bonus over the old very_good_coverage action)
very_good test --coverage --min-coverage 100 --show-uncovered

# Run a single test file
flutter test test/src/flutter_package_test.dart

# Run a single test by name
flutter test --name "can be instantiated"

# Bloc lint
flutter pub global activate bloc_tools
bloc lint .
```

### Documentation Site (`site/`)

```sh
cd site
npm install

npm run build          # Production build
npm run typecheck      # TypeScript type check
npm run lint           # ESLint
npm run format:check   # Prettier check
npm run format         # Prettier fix
npm start              # Local dev server
```

### Spell Check

```sh
# Uses the config at .github/cspell.json
npx cspell --config .github/cspell.json "**"
```

> **Coverage:** 100% test coverage is enforced. The `min_coverage` input in both
> `dart_package.yml` and `flutter_package.yml` defaults to `100`.

## Workflow YAML Conventions

Reference: all files in `.github/workflows/`

- **Trigger:** All reusable workflows use `on: workflow_call`. Internal CI in
  `ci.yml` composes them using `uses: ./.github/workflows/<name>.yml`.
- **File naming:** `snake_case.yml`
- **Inputs:** Every configurable value is an explicit typed input with a
  sensible default. Secrets (e.g., `ssh_key`, `pub_credentials`) are declared
  separately under `secrets:`.
- **Step naming:** Steps use emoji prefixes consistently across all workflows:

  | Emoji | Meaning                                                    |
  |-------|------------------------------------------------------------|
  | 📚    | Git Checkout                                               |
  | 🎯    | Setup Dart                                                 |
  | 🐦    | Setup Flutter                                              |
  | 🤫    | Set SSH Key                                                |
  | 📦    | Install Dependencies                                       |
  | ⚙️    | Run Setup                                                  |
  | ✨    | Check Formatting                                           |
  | 🕵️   | Analyze                                                    |
  | ✅    | Bloc Lint                                                  |
  | 🧪    | Run Tests (includes coverage collection and min-% check)   |
  | 🔐    | Setup Credentials                                          |
  | 🌵    | Dry Run                                                    |
  | 📢    | Publish                                                    |

- **Action versions:** Always pin to a specific version tag (e.g.,
  `actions/checkout@v6`, `dart-lang/setup-dart@v1`). Security-sensitive
  actions are additionally pinned to a full commit SHA with a version comment.
- **`runs_on`:** Defaults to `ubuntu-latest`; exposed as an input so callers
  can override.

## Dart Code Style

Reference: `examples/*/analysis_options.yaml`, `examples/*/pubspec.yaml`

- **Linter:** `very_good_analysis` (`^10.0.0`). Both example packages include
  only `include: package:very_good_analysis/analysis_options.yaml`.
- **Formatting:** `dart format` with the default 80-character line length.
- **Source layout:** Public API lives in `lib/src/`. The top-level barrel file
  (`lib/<package_name>.dart`) re-exports from `src/`:
  ```dart
  export 'src/dart_package.dart';
  ```
- **Test layout:** Tests mirror `lib/src/` under `test/src/`.
- **Doc comments:** Use `{@template <name>}` on the class and `{@macro <name>}`
  on the constructor. See `examples/dart_package/lib/src/dart_package.dart`.
- **Constructors:** Prefer `const` constructors where possible.
- **Test structure:** Group tests by class using `group(ClassName, () { ... })`
  with `test()` calls inside. Add `// ignore_for_file: prefer_const_constructors`
  at the top of test files to avoid false positives.
- **Imports:** Package imports before relative imports; no unused imports.

## Site Code Style

Reference: `site/.prettierrc`, `site/.eslintrc.js`, `site/eslint.config.js`

- **Prettier:** single quotes (`"singleQuote": true` in `site/.prettierrc`).
- **ESLint:** Docusaurus ESLint plugin (`plugin:@docusaurus/recommended`) with
  Babel parser. A flat config (`eslint.config.js`) is also present for JS files.
- **Docs:** One Markdown file per workflow under `site/docs/workflows/`. Each
  doc covers: steps, all inputs with defaults, secrets, and an example usage
  snippet. See `site/docs/workflows/dart_package.md` as the canonical template.
- **Site config:** `site/docusaurus.config.js` — do not change `url`,
  `projectName`, or `organizationName` without a corresponding deployment update.

## Git & Release Conventions

Reference: `CONTRIBUTING.md`, `.release-please-config.json`,
`.github/workflows/semantic_pull_request.yml`, `.github/workflows/release_please.yml`

- **Commits:** [Conventional Commits](https://www.conventionalcommits.org/) are
  required. Valid types: `feat`, `fix`, `refactor`, `chore`, `docs`.
- **PR titles:** Must be semantic. Allowed scopes (from `ci.yml`):
  `dart_package`, `deps`, `flutter_package`, `pana`, `semantic_pull_request`,
  `spell_check`.
- **Squash commits** before opening a PR.
- **Releases:** Automated via `release-please`. Only changes to workflow files
  (not `.github/`, `site/`, `examples/`, or doc files) trigger a version bump.
  Major version tags (e.g., `v1`) are automatically moved to the latest release.
- **Branch:** Work from a fork; target `main`.

## CI Pipeline

Reference: `.github/workflows/ci.yml`

The internal CI runs the following jobs in parallel, all of which must pass
before the `build` gate job succeeds:

| Job                        | Workflow used                     | What it checks                                                    |
|----------------------------|-----------------------------------|-------------------------------------------------------------------|
| `verify-dart`              | `dart_package.yml`                | Format, analyze, bloc lint, test + coverage (via very_good_cli)   |
| `verify-flutter`           | `flutter_package.yml`             | Format, analyze, bloc lint, test + coverage (via very_good_cli)   |
| `verify-pana-dart`         | `pana.yml`                        | pub.dev score ≥ 95                          |
| `verify-pana-flutter`      | `pana.yml`                        | pub.dev score ≥ 95                          |
| `verify-semantic-pull-request` | `semantic_pull_request.yml`   | PR title follows Conventional Commits       |
| `verify-spell-check`       | `spell_check.yml`                 | Spelling via cspell (`.github/cspell.json`) |
| `verify-license-check`     | `license_check.yml`               | No `unknown` licenses in direct-dev deps    |

## Key References

| File | Purpose |
|------|---------|
| `.github/workflows/ci.yml` | Internal CI — start here to understand how everything fits together |
| `.github/workflows/dart_package.yml` | Canonical Dart package workflow; defines all CI steps |
| `.github/workflows/flutter_package.yml` | Canonical Flutter package workflow |
| `examples/dart_package/` | Minimal Dart package that exercises `dart_package.yml` |
| `examples/flutter_package/` | Minimal Flutter package that exercises `flutter_package.yml` |
| `examples/*/analysis_options.yaml` | Dart lint config (`very_good_analysis`) |
| `.github/cspell.json` | Spell check config; add project-specific words here |
| `.github/dependabot.yaml` | Automated updates for Actions, pub, and npm dependencies |
| `.release-please-config.json` | Release automation config; lists excluded paths |
| `CONTRIBUTING.md` | PR checklist and release process documentation |
| `site/docs/workflows/` | Public documentation for each workflow |
