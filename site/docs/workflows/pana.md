---
sidebar_position: 7
---

# Pana

We use the Dart tool [pana](https://pub.dev/packages/pana) to validate that your pub score will be the max possible score before publishing a package to [pub.dev](https://pub.dev).

## Steps

The pana workflow consists of the following steps:

1. Install pana
2. Verify pana score

## Inputs

### `pana_version`

**Optional** Which version of `package:pana` to use (See the available versions [here](https://pub.dev/packages/pana/changelog)).

### `min_score`

**Optional** The minimum score allowed.

**Default** `120`

### `working_directory`

**Optional** The path to the root of the Dart package.

**Default** `"."`

### `runs_on`

**Optional** The operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

## Example Usage

```yaml
name: My Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/pana.yml@v1
    with:
      min_score: 95
      working_directory: 'examples/my_flutter_package'
```
