---
sidebar_position: 2
---

# Dart Pub Publish

We use this workflow to publish a Dart package to [pub.dev](https://pub.dev).

## Steps

The Dart Pub Publish workflow consists of the following steps:

1. Install dependencies
2. Setup pub credentials
3. Dry run
4. Publish

## Inputs

### `dart_sdk`

**Optional** Which Dart SDK version to use. It can be a version (e.g. `2.12.0`) or a channel (e.g. `stable`):

**Default** `"stable"`

### `working_directory`

**Optional** The path to the root of the Dart package.

**Default** `"."`

### `runs_on`

**Optional** An optional operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

### `pub_credentials`

**Required** The pub credentials needed for publishing. This can be retrieved by reading out your `pub-credentials.json` on your system after you ran a `dart pub login`, the location of the file is different per operating system:

| OS      | Path                                                                                      |
| ------- | ----------------------------------------------------------------------------------------- |
| Linux   | `$XDG_CONFIG_HOME/dart/pub-credentials.json` or `$HOME/.config/dart/pub-credentials.json` |
| macOS   | `~/Library/Application\ Support/dart/pub-credentials.json`                                |
| Windows | `%APPDATA%/dart/pub-credentials.json`                                                     |

## Example Usage

We recommend using [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets) for safely storing and reading the credentials.

```yaml
name: My Dart Pub Publish Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/dart_pub_publish.yml@v1
    with:
      dart_sdk: 'stable'
      working_directory: 'packages/my_dart_package'
      pub_credentials: secrets.PUB_CREDENTIALS
```
