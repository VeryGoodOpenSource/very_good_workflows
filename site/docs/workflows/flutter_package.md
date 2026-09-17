---
sidebar_position: 3
---

# Flutter Package

This workflow runs helpful checks on a Flutter package according to the steps below. As with any workflow, it can be customized.

## Steps

The Flutter package workflow consists of the following steps:

1. Setup Flutter
2. Set SSH Key (if provided)
3. Install dependencies
4. Run Setup (if provided)
5. Format
6. Analyze
7. Bloc Lint (if enabled)
8. Run tests (includes coverage collection and enforcement)
9. Upload artifacts (if configured)

## Inputs

### `analyze_directories`

**Optional** A space-separated list of folders that should be analyzed.

**Default** `"lib test"`

### `format_directories`

**Optional** A space-separated list of folders that should be formatted.

**Default** `"lib test"`

### `concurrency`

**Optional** The number of concurrent test suites run.

**Default** `4`

### `coverage_excludes`

**Optional** Space-separated list of globs to exclude files from the coverage report (e.g. '**/\*.g.dart **/gen/\*.dart').

**Default** `""`

### `dart_define`

**Optional** Space-separated list of key-value pairs passed to the tests as `--dart-define` (e.g. `dart.vm.product=true FLAVOR=staging`). Each pair is forwarded as a separate `--dart-define` flag.

**Default** `""`

### `flutter_channel`

**Optional** The Flutter release channel to use (e.g. `stable`).

**Default** `"stable"`

### `flutter_version`

**Optional** The Flutter SDK version to use (e.g. `3.24.0`).

**Default** `""`

### `flutter_version_file`

**Optional** Path to a file that holds the Flutter version to use, such as `pubspec.yaml` or `.fvmrc`, resolved from the repository root rather than `working_directory`. This lets you keep a single source of truth for the Flutter version.

:::caution
`flutter_version_file` and `flutter_version` are mutually exclusive. Setting both fails the job with `Cannot specify both a version and a version file`.

Files other than `.fvmrc` and `fvm_config.json` (such as `pubspec.yaml`) are parsed with `yq`, which Windows runners don't provide. On Windows, use `.fvmrc` or `fvm_config.json`.
:::

**Default** `""`

### `format_line_length`

**Optional** The preferred line length preferred for running the `dart format` command. Be aware that this does not change the behavior of the analysis step and longer lines could still make the workflow fail if the rule `lines_longer_than_80_chars` is used.

### `min_coverage`

**Optional** The minimum coverage percentage allowed.

**Default** 100

### `setup`

**Optional** A command that should be executed immediately after dependencies are installed.

**Default** `""`

### `working_directory`

**Optional** The path to the root of the Flutter package.

**Default** `"."`

### `test_optimization`

**Optional** Enable the test optimization.

**Default** `true`

**Note**: Since the optimization process groups tests into a single file, golden tests will not work properly. Consider disabling optimizations if you are using golden tests.

### `test_recursion`

**Optional** Whether to recursively run tests in nested directories.

**Default** `false`

### `runs_on`

**Optional** The operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

### `package_get_excludes`

**Optional** List of paths to exclude from `packages get`. Supports `globs` to describe file patterns.

**Default** `"!*"`

### `platform`

**Optional** The platform to run tests on (e.g., `chrome`, `android`, `ios`).

**Default** `""`

### `report_on`

**Optional** A comma-separated list of folders that should be checked in code coverage.

**Default** `"lib"`

### `run_bloc_lint`

**Optional** Whether to run [bloc lint](https://pub.dev/packages/bloc_tools) on the package.

**Default** `true`

### `run_skipped`

**Optional** Run skipped tests instead of skipping them.

**Default** `false`

### `show_uncovered`

**Optional** Whether to show uncovered lines when coverage is below 100%. Implicitly enables coverage collection when used alone.

**Default** `true`

### `collect_coverage_from`

**Optional** Whether to collect coverage from imported files only or all files. Counting untested files against coverage (`all`) results in stricter enforcement.

**Allowed values** `imports`, `all`

**Default** `"imports"`

### `artifact_paths`

**Optional** A newline-separated list of globs to upload as a workflow artifact once the tests finish. Runs on both passing and failing test runs, so it captures golden test failures as well as reports produced by a green run. An empty value disables the upload entirely.

**Default** `""`

**Note**: Unlike the other path inputs, these globs are resolved from the **repository root**, not from [`working_directory`](#working_directory). This is a constraint of [`actions/upload-artifact`](https://github.com/actions/upload-artifact), which has no working directory setting. See [Uploading artifacts](#uploading-artifacts).

### `artifact_name`

**Optional** The name given to the uploaded artifact. Must be unique across every job in the same workflow run, otherwise the upload fails with a conflict. Only relevant when [`artifact_paths`](#artifact_paths) is set.

**Default** `"artifacts"`

## Secrets

### `ssh_key`

**Optional** An SSH key used to access private repositories when installing dependencies.

## Uploading artifacts

Set [`artifact_paths`](#artifact_paths) to keep files produced by the run. The step executes whether the tests pass or fail, and quietly does nothing when no file matches.

The main use case is golden tests. When `matchesGoldenFile` fails, Flutter writes the expected and actual images, plus pixel diffs when the two share the same dimensions, into a `failures` directory next to the test. That directory normally disappears along with the runner:

```yaml
with:
  test_optimization: false
  artifact_paths: '**/failures/**'
```

Both settings are needed here. As noted under [`test_optimization`](#test_optimization), the optimization step groups tests into a single file and breaks golden tests, so it has to be off before there are any failures worth uploading.

Globs are resolved from the repository root rather than from [`working_directory`](#working_directory), so `**/failures/**` matches every package in a monorepo. To scope the upload to one package, write the prefix out in full:

```yaml
with:
  working_directory: packages/my_package
  artifact_paths: 'packages/my_package/**/failures/**'
```

Pass several globs on separate lines, and use [`artifact_name`](#artifact_name) to keep names unique when more than one job uploads in the same run:

```yaml
with:
  artifact_paths: |
    **/failures/**
    coverage/lcov.info
  artifact_name: 'artifacts-${{matrix.package}}'
```

Exclusions and the rest of the pattern syntax work as described in the [`actions/upload-artifact` documentation](https://github.com/actions/upload-artifact#upload-using-multiple-paths-and-exclusions).

## Example Usage

```yaml
name: My Flutter Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/flutter_package.yml@v1
    with:
      coverage_excludes: '**/*.g.dart'
      dart_define: 'dart.vm.product=true FLAVOR=staging'
      flutter_channel: 'stable'
      flutter_version: '3.35.0'
      working_directory: 'examples/my_flutter_package'
      test_recursion: true
    secrets:
      ssh_key: ${{secrets.EXAMPLE_KEY}}
```
