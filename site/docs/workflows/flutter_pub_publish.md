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

### `working_directory`

**Optional** The path to the root of the Flutter package.

**Default** `"."`

### `runs_on`

**Optional** An optional operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

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
      flutter_version: '3.24.0'
      working_directory: 'packages/my_flutter_package'
```
