---
sidebar_position: 11
---

# Jaspr Site

This workflow runs helpful checks on a [Jaspr][jaspr_link] site according to the steps below. As with any workflow, it can be customized.

## Steps

The Jaspr site workflow consists of the following steps:

1. Setup Dart
2. Set SSH Key (if provided)
3. Install dependencies
4. Run Setup (if provided)
5. Format
6. Analyze
7. Build (if enabled)

## Inputs

### `analyze_directories`

**Optional** A space-separated list of folders that should be analyzed.

**Default** `"."`

### `build`

**Optional** Whether to build the site with the [Jaspr CLI][jaspr_cli_link] (`jaspr build`). The build is the primary validation that the site compiles, since Jaspr sites frequently ship without tests.

**Default** `true`

### `build_args`

**Optional** Extra arguments passed to `jaspr build` (e.g. `--no-ssr --sitemap-domain https://example.com`). The rendering mode is read from `pubspec.yaml`, so it is not configured here.

**Default** `""`

### `dart_sdk`

**Optional** Which Dart SDK version to use. It can be a version (e.g. `3.13.2`) or a channel (e.g. `stable`).

**Default** `"stable"`

### `format_directories`

**Optional** A space-separated list of folders that should be formatted.

**Default** `"."`

### `format_line_length`

**Optional** The preferred line length used when running the `dart format` command. Be aware that this does not change the behavior of the analysis step and longer lines could still make the workflow fail if the rule `lines_longer_than_80_chars` is used.

### `jaspr_cli_version`

**Optional** The version of [`jaspr_cli`][jaspr_cli_link] to activate (e.g. `0.23.5`). An empty value installs the latest version. Only relevant when [`build`](#build) is enabled.

**Default** `""`

### `runs_on`

**Optional** The operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

### `timeout_minutes`

**Optional** The maximum number of minutes to let the job run before GitHub automatically cancels it.

**Default** `360`

### `setup`

**Optional** A command that should be executed immediately after dependencies are installed. It can also be used to export environment variables for later steps.

**Default** `""`

### `working_directory`

**Optional** The path to the root of the Jaspr site.

**Default** `"."`

## Secrets

### `ssh_key`

**Optional** An SSH key used to access private repositories when installing dependencies.

## Example Usage

```yaml
name: My Jaspr Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/jaspr_site.yml@v1
    with:
      dart_sdk: 'stable'
      jaspr_cli_version: '0.23.5'
      timeout_minutes: 10
      working_directory: 'examples/my_jaspr_site'
    secrets:
      ssh_key: ${{secrets.EXAMPLE_KEY}}
```

[jaspr_link]: https://docs.jaspr.site
[jaspr_cli_link]: https://pub.dev/packages/jaspr_cli
