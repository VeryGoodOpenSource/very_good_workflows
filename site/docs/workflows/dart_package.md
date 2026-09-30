---
sidebar_position: 1
---

# Dart Package

This workflow runs helpful checks on a Dart package according to the steps below. As with any workflow, it can be customized.

## Steps

The Dart package workflow consists of the following steps:

1. Setup Dart
2. Set SSH Key (if provided)
3. Install dependencies
4. Run Setup (if provided)
5. Format
6. Analyze
7. Bloc Lint (if enabled)
8. Cognitive Complexity (if enabled)
9. Run tests (includes coverage collection and enforcement)
10. Upload artifacts (if configured)

## Inputs

### `concurrency`

**Optional** The number of concurrent test suites run.

**Default** `4`

### `coverage_excludes`

**Optional** Space-separated list of globs to exclude files from the coverage report (e.g. '**/\*.g.dart **/gen/\*.dart').

**Default** `""`

### `dart_sdk`

**Optional** Which Dart SDK version to use. It can be a version (e.g. `3.5.0`) or a channel (e.g. `stable`):

**Default** `"stable"`

### `format_line_length`

**Optional** The preferred line length preferred for running the `dart format` command. Be aware that this does not change the behavior of the analysis step and longer lines could still make the workflow fail if the rule `lines_longer_than_80_chars` is used.

### `min_coverage`

**Optional** The minimum coverage percentage allowed.

**Default** 100

### `working_directory`

**Optional** The path to the root of the Dart package.

**Default** `"."`

### `analyze_directories`

**Optional** A space-separated list of folders that should be analyzed.

**Default** `"lib test"`

### `format_directories`

**Optional** A space-separated list of folders that should be formatted.

**Default** `"."`

### `check_ignore`

**Optional** Whether to check for and respect coverage ignore comments (e.g. `// coverage:ignore-line`).

**Default** `false`

### `report_on`

**Optional** A comma-separated list of folders that should be checked in code coverage.

**Default** `"lib"`

### `runs_on`

**Optional** The operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

### `timeout_minutes`

**Optional** The maximum number of minutes to let the job run before GitHub automatically cancels it.

**Default** `360`

### `setup`

**Optional** A command that should be executed immediately after dependencies are installed. It can also be used to export environment variables for later steps (see [Providing environment variables](#providing-environment-variables)).

**Default** `""`

### `platform`

**Optional** A comma-separated list of platforms on which to run the tests.
`[vm (default), chrome, firefox, safari, node]`

**Default** `"vm"`

### `run_skipped`

**Optional** Run skipped tests instead of skipping them.

**Default** `false`

### `no_example`

**Optional** To avoid getting packages in `example/` when running `dart pub get` (if it exists).

**Default** `false`

### `show_uncovered`

**Optional** Whether to show uncovered lines when coverage is below 100%. Implicitly enables coverage collection when used alone.

**Default** `true`

### `collect_coverage_from`

**Optional** Whether to collect coverage from imported files only or all files. Counting untested files against coverage (`all`) results in stricter enforcement.

**Allowed values** `imports`, `all`

**Default** `"imports"`

### `test_optimization`

**Optional** Whether to apply optimizations for test performance.

**Default** `true`

### `run_bloc_lint`

**Optional** Whether to run [bloc lint](https://pub.dev/packages/bloc_tools) on the package.

**Default** `true`

### `run_cognitive_complexity`

**Optional** Whether to run the [cognitive_complexity](https://pub.dev/packages/cognitive_complexity) audit on the package. See [Cognitive complexity](#cognitive-complexity).

**Default** `false`

### `cognitive_complexity_targets`

**Optional** Space-separated list of directories or files to scan for cognitive complexity.

:::note
Like [`artifact_paths`](#artifact_paths), these paths are resolved from the **repository root**, not from [`working_directory`](#working_directory). For a package nested in a monorepo, write the prefix out in full (e.g. `packages/my_package/lib`).
:::

**Default** `"lib"`

### `cognitive_complexity_fail_threshold`

**Optional** The maximum cognitive complexity score a function may reach before the job fails.

**Default** `15`

### `cognitive_complexity_fail_on_increase`

**Optional** Whether to fail the job when cognitive complexity increases relative to [`cognitive_complexity_diff_base`](#cognitive_complexity_diff_base). Requires the full git history, which is fetched automatically when [`run_cognitive_complexity`](#run_cognitive_complexity) is enabled.

**Default** `false`

### `cognitive_complexity_diff_base`

**Optional** Git reference to compare against when computing complexity changes (e.g. `origin/main`). An empty value lets the action auto-detect the base.

**Default** `""`

### `artifact_paths`

**Optional** A newline-separated list of globs to upload as a workflow artifact once the tests finish. Runs on both passing and failing test runs, so it captures output from a failed run as well as reports produced by a green one. An empty value disables the upload entirely.

**Default** `""`

**Note**: Unlike the other path inputs, these globs are resolved from the **repository root**, not from [`working_directory`](#working_directory). This is a constraint of [`actions/upload-artifact`](https://github.com/actions/upload-artifact), which has no working directory setting. See [Uploading artifacts](#uploading-artifacts).

### `artifact_name`

**Optional** The name given to the uploaded artifact. Must be unique across every job in the same workflow run, otherwise the upload fails with a conflict. Only relevant when [`artifact_paths`](#artifact_paths) is set.

**Default** `"artifacts"`

## Secrets

### `ssh_key`

**Optional** An SSH key used to access private repositories when installing dependencies.

## Uploading artifacts

Set [`artifact_paths`](#artifact_paths) to keep files produced by the run, such as the coverage report. The step executes whether the tests pass or fail, and quietly does nothing when no file matches.

```yaml
with:
  artifact_paths: 'coverage/lcov.info'
```

Globs are resolved from the repository root rather than from [`working_directory`](#working_directory), so a package nested in a monorepo needs the prefix written out in full:

```yaml
with:
  working_directory: packages/my_package
  artifact_paths: 'packages/my_package/coverage/lcov.info'
```

Pass several globs on separate lines, and use [`artifact_name`](#artifact_name) to keep names unique when more than one job uploads in the same run:

```yaml
with:
  artifact_paths: |
    coverage/lcov.info
    build/reports/**
  artifact_name: 'artifacts-${{matrix.package}}'
```

Exclusions and the rest of the pattern syntax work as described in the [`actions/upload-artifact` documentation](https://github.com/actions/upload-artifact#upload-using-multiple-paths-and-exclusions).

## Cognitive complexity

Enable [`run_cognitive_complexity`](#run_cognitive_complexity) to audit the package with [`package:cognitive_complexity`](https://pub.dev/packages/cognitive_complexity). The step fails when any function's score exceeds [`cognitive_complexity_fail_threshold`](#cognitive_complexity_fail_threshold), and can additionally block increases relative to a base ref via [`cognitive_complexity_fail_on_increase`](#cognitive_complexity_fail_on_increase) and [`cognitive_complexity_diff_base`](#cognitive_complexity_diff_base).

```yaml
with:
  run_cognitive_complexity: true
  cognitive_complexity_targets: 'lib'
  cognitive_complexity_fail_threshold: 15
```

To post the complexity report as a pull request comment, grant the caller workflow `pull-requests: write` permission:

```yaml
jobs:
  build:
    permissions:
      contents: read
      pull-requests: write
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/dart_package.yml@v1
    with:
      run_cognitive_complexity: true
```

## Providing environment variables

Tests sometimes read values from the environment via [`Platform.environment`](https://api.dart.dev/dart-io/Platform/environment.html), for example:

```dart
import 'dart:io';

final myVar = Platform.environment['MY_VAR'];
```

Because this is a [reusable workflow](https://docs.github.com/en/actions/using-workflows/reusing-workflows), an `env` block defined in your caller workflow is **not** inherited by the steps that run inside `dart_package.yml`. To make a variable available to the test step, use the [`setup`](#setup) input to append it to [`$GITHUB_ENV`](https://docs.github.com/en/actions/using-workflows/workflow-commands-for-github-actions#setting-an-environment-variable). Variables written to `$GITHUB_ENV` are exported to every subsequent step in the job, including the one that runs your tests.

```yaml
name: My Dart Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/dart_package.yml@v1
    with:
      setup: echo "MY_VAR=true" >> $GITHUB_ENV
```

To provide multiple variables, chain the commands:

```yaml
with:
  setup: |
    echo "MY_VAR=true" >> $GITHUB_ENV
    echo "ANOTHER_VAR=some-value" >> $GITHUB_ENV
```

If a value is sensitive, pass it through a [secret](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions) instead of hardcoding it:

```yaml
with:
  setup: echo "API_TOKEN=${{secrets.API_TOKEN}}" >> $GITHUB_ENV
```

:::note
Setting the variable inline before the test command (e.g. `MY_VAR="true" dart test`) is not possible through the `setup` input, because `setup` and the test step run in separate shells. Writing to `$GITHUB_ENV` is the supported way to share values across steps.
:::

## Example Usage

```yaml
name: My Dart Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/dart_package.yml@v1
    with:
      coverage_excludes: '*.g.dart'
      dart_sdk: 'stable'
      platform: 'chrome,vm'
      timeout_minutes: 10
      working_directory: 'examples/my_dart_package'
    secrets:
      ssh_key: ${{secrets.EXAMPLE_KEY}}
```
