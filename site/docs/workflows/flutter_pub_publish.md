---
sidebar_position: 4
---

# Flutter Pub Publish

We use this workflow to publish a Flutter package to [pub.dev](https://pub.dev).

## Steps

The Flutter Pub Publish workflow consists of the following steps:

1. Install dependencies
2. Setup pub credentials
3. Dry run
4. Publish

## Inputs

### `flutter_channel`

**Optional** The Flutter release channel to use (e.g. `stable`).

**Default** `"stable"`

### `flutter_version`

**Optional** The Flutter SDK version to use (e.g. `2.8.1`).

**Default** `""`

### `working_directory`

**Optional** The path to the root of the Flutter package.

**Default** `"."`

### `runs_on`

**Optional** An optional operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

### `pub_credentials`

**Required** The pub credentials needed for publishing. This can be retrieved by reading out your `pub-credentials.json` on your system after you ran a `flutter pub login`. The location of the file is different per operating system:

| OS      | Path                                                                                      |
| ------- | ----------------------------------------------------------------------------------------- |
| Linux   | `$XDG_CONFIG_HOME/dart/pub-credentials.json` or `$HOME/.config/dart/pub-credentials.json` |
| macOS   | `~/Library/Application\ Support/dart/pub-credentials.json`                                |
| Windows | `%APPDATA%/dart/pub-credentials.json`                                                     |

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
      flutter_version: '2.8.1'
      working_directory: 'packages/my_flutter_package'
      pub_credentials: secrets.PUB_CREDENTIALS
```
