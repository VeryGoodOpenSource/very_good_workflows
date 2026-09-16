---
sidebar_position: 4
---

# Flutter Pub Publish

We use this workflow to publish a Flutter package to [pub.dev](https://pub.dev).

## Steps

The Flutter Pub Publish workflow consists of the following steps:

1. Install dependencies
2. Setup Flutter & Dart, including pub.dev publish token
3. Dry run
4. Publish

This workflow uses the automated publishing of packages to pub.dev which is part of the [Dart documentation](https://dart.dev/tools/pub/automated-publishing). Before using this workflow ensure that you have configured your package on pub.dev correctly to allow the publish process to complete.

## Inputs

### `flutter_channel`

**Optional** The Flutter release channel to use (e.g. `stable`).

**Default** `"stable"`

### `flutter_version`

**Optional** The Flutter SDK version to use (e.g. `3.24.0`).

**Default** `""`

### `flutter_version_file`

**Optional** The path to a file containing the Flutter version to use (e.g. `pubspec.yaml` or `.fvmrc`), resolved from the repository root rather than `working_directory`. This lets you keep a single source of truth for the Flutter version.

:::caution
`flutter_version_file` and `flutter_version` are mutually exclusive. Setting both fails the job with `Cannot specify both a version and a version file`.

Version files other than `.fvmrc` and `fvm_config.json` (such as `pubspec.yaml`) are parsed with `yq`, which is not available on Windows runners. Prefer `.fvmrc` or `fvm_config.json` when running on Windows.
:::

**Default** `""`

### `working_directory`

**Optional** The path to the root of the Flutter package.

**Default** `"."`

### `runs_on`

**Optional** An optional operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

### `dart_sdk`

**Optional** The Dart SDK version used when publishing via the `Setup Dart` action.

**Default** `"stable"`

### `timeout_minutes`

**Optional** The maximum number of minutes the publish job is allowed to run before it is cancelled.

**Default** `5`

## Example Usage

We recommend using [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets) for safely storing and reading the credentials.

```yaml
name: My Flutter Pub Publish Workflow

on:
  push:
    tags:
      - 'my_flutter_package-v*.*.*'

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/flutter_pub_publish.yml@v1
    with:
      flutter_channel: 'stable'
      flutter_version: '3.35.0'
      working_directory: 'packages/my_flutter_package'
```
