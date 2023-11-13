---
sidebar_position: 1
---

# Dart Package

This workflow runs helpful checks on a Dart package according to the steps below. As with any workflow, it can be customized.

## Steps

The Dart package workflow consists of the following steps:

1. Install dependencies
2. Format
3. Analyze
4. Run tests
5. Check code coverage

## Inputs

### `concurrency`

**Optional** The number of concurrent test suites run.

**Default** `4`

### `coverage_excludes`

**Optional** List of paths to exclude from the coverage report, separated by an empty space. Supports `globs` to describe file patterns.

**Default** `""`

### `dart_sdk`

**Optional** Which Dart SDK version to use. It can be a version (e.g. `2.12.0`) or a channel (e.g. `stable`):

**Default** `"stable"`

### `format_line_length`

**Optional** The preferred line length preferred for running the `dart format` command. Be aware that this does not change the behavior of the analysis step and longer lines could still make the workflow fail if the rule `lines_longer_than_80_chars` is used.

**Default** `"80"`

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

**Optional** Allows ignoring lines from [coverage](https://pub.dev/packages/coverage).

**Default** `false`

### `report_on`

**Optional** A comma-separated list of folders that should be checked in code coverage.

**Default** `"lib"`

### `runs_on`

**Optional** The operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

### `setup`

**Optional** A command that should be executed immediately after dependencies are installed.

**Default** `""`

### `platform`

**Optional** A comma-separated list of platforms on which to run the tests.
`[vm (default), chrome, firefox, safari, node]`

**Default** `"vm"`

### `run_skipped`

**Optional** Run skipped tests instead of skipping them.

**Default** `false`

## Secrets

### `ssh_key`

**Optional** An SSH key used to access private repositories when installing dependencies.

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
