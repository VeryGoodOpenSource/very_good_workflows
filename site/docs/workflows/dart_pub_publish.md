---
sidebar_position: 2
---

# Dart Pub Publish

We use this workflow to publish a Dart package to [pub.dev](https://pub.dev).

## Steps

The Dart Pub Publish workflow consists of the following steps:

1. Setup Dart, including pub.dev publish token
2. Install dependencies
3. Dry run
4. Publish

This workflow uses the automated publishing of packages to pub.dev which is part of the [Dart documentation](https://dart.dev/tools/pub/automated-publishing). Before using this workflow ensure that you have configured your package on pub.dev correctly to allow the publish process to complete.

## Inputs

### `dart_sdk`

**Optional** Which Dart SDK version to use. It can be a version (e.g. `3.5.0`) or a channel (e.g. `stable`):

**Default** `"stable"`

### `working_directory`

**Optional** The path to the root of the Dart package.

**Default** `"."`

### `runs_on`

**Optional** An optional operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

## Example Usage

```yaml
name: My Dart Pub Publish Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/dart_pub_publish.yml@v1
    with:
      dart_sdk: 'stable'
      working_directory: 'packages/my_dart_package'
```
