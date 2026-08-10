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
8. Run tests (includes coverage collection and enforcement)

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

## Secrets

### `ssh_key`

**Optional** An SSH key used to access private repositories when installing dependencies.

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
      working_directory: 'examples/my_dart_package'
    secrets:
      ssh_key: ${{secrets.EXAMPLE_KEY}}
```
