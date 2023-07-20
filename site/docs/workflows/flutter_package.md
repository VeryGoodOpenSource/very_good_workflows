---
sidebar_position: 3
---

# Flutter Package

This workflow runs helpful checks on a Flutter package according to the steps below. As with any workflow, it can be customized.

## Steps

The Flutter package workflow consists of the following steps:

1. Install dependencies
2. Format
3. Analyze
4. Run tests
5. Check code coverage

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

**Optional** A space-separated list of paths to exclude from the coverage report. Supports `globs` to describe file patterns.

**Default** `""`

### `flutter_channel`

**Optional** The Flutter release channel to use (e.g. `stable`).

**Default** `"stable"`

### `flutter_version`

**Optional** The Flutter SDK version to use (e.g. `2.8.1`).

**Default** `""`

### `format_line_length`

**Optional** The preferred line length preferred for running the `dart format` command. Be aware that this does not change the behavior of the analysis step and longer lines could still make the workflow fail if the rule `lines_longer_than_80_chars` is used.

**Default** `"80"`

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

## Secrets

### `ssh_key`

**Optional** An SSH key used to access private repositories when installing dependencies.

## Example Usage

```yaml
name: My Flutter Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/flutter_package.yml@v1
    with:
      coverage_excludes: '*.g.dart'
      flutter_channel: 'stable'
      flutter_version: '2.8.1'
      working_directory: 'examples/my_flutter_package'
      test_recursion: true
    secrets:
      ssh_key: ${{secrets.EXAMPLE_KEY}}
```
