---
sidebar_position: 7
---

# Spell Check

We use [cspell](https://github.com/streetsidesoftware/cspell) for basic spell check on our projects.

## Steps

The spell check workflow consists of the following steps:

1. Git checkout
2. Run spell check

## Inputs

### `config`

**Optional** The location of the `cspell.json`.

**Default** `".github/cspell.json"`

### `includes`

**Optional** The glob patterns to filter the files to be checked. Use a new line between patterns to define multiple patterns.

**Default** `""`

### `working_directory`

**Optional** The path to the root of the Dart package.

**Default** `"."`

### `runs_on`

**Optional** An optional operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

### `verbose`

**Optional** An optional boolean which determines whether to log verbose output.

**Default** `false`

### `modified_files_only`

**Optional** An optional boolean which determines whether spell check is run on modified files.

**Default** `true`

## Example Usage

```yaml
name: My Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/spell_check.yml@v1
    with:
      includes: |
        **/*.{dart,md,yaml}
        !.dart_tool/**/*.{dart,yaml}
        .*/**/*.yml
      runs_on: macos-latest
      modified_files_only: false
      working_directory: examples/my_project
```
