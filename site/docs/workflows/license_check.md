---
sidebar_position: 5
---

# License Check

At VGV, we keep track of the rights and restrictions external dependencies might impose on Dart or Flutter projects.

:::info
The License Check functionality is powered by [Very Good CLI's license checker](https://cli.vgv.dev/docs/commands/check_licenses), for a deeper understanding of some [inputs](#inputs) refer to its [documentation](https://cli.vgv.dev/docs/commands/check_licenses).
:::

## Steps

The License Check workflow consists of the following steps:

1. Setup Dart
2. Set SSH Key (if provided)
3. Install project dependencies
4. Check licenses

## Inputs

### `working_directory`

**Optional** The path to the root of the Dart or Flutter package.

**Default** `"."`

### `runs_on`

**Optional** An optional operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

### `dart_sdk`

**Optional** Which Dart SDK version to use. It can be a version (e.g. `3.5.0`) or a channel (e.g. `stable`). This parameter is ignored if a flutter_version is specified.

**Default** `"stable"`

### `flutter_version`

**Optional** Which Flutter SDK version to use.

**Default** `""`

### `allowed`

**Optional** Only allow the use of certain licenses. The expected format is a comma-separated list.

**Default** `"MIT,BSD-3-Clause,BSD-2-Clause,Apache-2.0"`

### `forbidden`

**Optional** Deny the use of certain licenses. The expected format is a comma-separated list.

**Default** `""`

:::warning
The allowed and forbidden options can't be used at the same time. If you want to use `forbidden` set `allowed` to an empty string.
:::

### `skip_packages`

**Optional** Skip packages from having their licenses checked.

**Default** `""`

### `dependency_type`

**Optional** The type of dependencies to check licenses for.

**Default** `"direct-main,transitive"`

### `ignore_retrieval_failures`

**Optional** Disregard licenses that failed to be retrieved.

**Default** `false`

## Secrets

### `ssh_key`

**Optional** An SSH key to use for setting up the credentials for fetching dependencies that are not publicly available.

## Example Usage

```yaml
name: license_check

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

on:
  pull_request:
    paths:
      - 'pubspec.yaml'
      - '.github/workflows/license_check.yaml'
  push:
    branches:
      - main
    paths:
      - 'pubspec.yaml'
      - '.github/workflows/license_check.yaml'

jobs:
  license_check:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/license_check.yml@v1
    with:
      flutter_version: '3.32.0'
      allowed: 'MIT,BSD-3-Clause,BSD-2-Clause,Apache-2.0,Zlib'
```

The example [workflow file](https://docs.github.com/en/actions/quickstart#creating-your-first-workflow) will [trigger](https://docs.github.com/en/actions/using-workflows/triggering-a-workflow) the `license_check` job on every push to the `main` branch and on every pull request that modifies the `pubspec.yaml` or the `license_check.yaml` workflow file.

If you are [committing the `pubspec.lock`](https://dart.dev/guides/libraries/private-files#pubspec-lock) file for an application package you may consider adding it to the list of paths to trigger the workflow.

:::tip
For repositories with multiple packages we recommend adding a workflow file per package to avoid triggering a license check for packages which dependencies haven't been modified.
:::
