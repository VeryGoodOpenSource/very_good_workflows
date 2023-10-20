---
sidebar_position: 6
---

# Mason Publish

We use this workflow to publish a brick to [brickhub.dev](https://brickhub.dev/).

## Steps

The Mason Publish workflow consists of the following steps:

1. Install Mason
2. Setup Mason credentials
3. Dry run
4. Publish

## Inputs

### `mason_version`

**Optional** Which Mason version to use (e.g. `0.1.0-dev.50`).

**Default** `""`

### `working_directory`

**Optional** The path to the root of the Mason brick.

**Default** `"."`

### `runs_on`

**Optional** An optional operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

### `mason_credentials`

**Required** The mason credentials needed for publishing. This can be retrieved by reading out your `mason-credentials.json` on your system after you ran a `mason login`, the location of the file is different per operating system:

| OS      | Path                                                                                            |
| ------- | ----------------------------------------------------------------------------------------------- |
| Linux   | `$XDG_CONFIG_HOME/mason/mason-credentials.json` or `$HOME/.config/mason/mason-credentials.json` |
| macOS   | `~/Library/Application\ Support/mason/mason-credentials.json`                                   |
| Windows | `%APPDATA%/mason/mason-credentials.json`                                                        |

## Example Usage

We recommend using [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets) for safely storing and reading the credentials.

```yaml
name: My Mason Brick Publish Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/mason_publish.yml@v1
    with:
      mason_version: '0.1.0-dev.50'
      working_directory: 'packages/my_mason_brick'
      mason_credentials: secrets.MASON_CREDENTIALS
```
