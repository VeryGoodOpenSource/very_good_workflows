---
sidebar_position: 9
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

## CSpell File Example

More information can be found in [cspell docs](https://cspell.org/configuration/).

Our custom dictionaries are available [here](https://github.com/verygoodopensource/very_good_dictionaries/) for everyone to use.

```json
{
  "$schema": "https://raw.githubusercontent.com/streetsidesoftware/cspell/main/cspell.schema.json",
  "version": "0.2",
  // List of the names of the dictionaries to use.
  "dictionaries": ["vgv_allowed", "vgv_forbidden"],
  // List of custom dictionary definitions.
  "dictionaryDefinitions": [
    // Remote dictionary example. URLs will be retrieved via HTTP GET.
    {
      "name": "vgv_allowed",
      "path": "https://raw.githubusercontent.com/verygoodopensource/very_good_dictionaries/main/allowed.txt",
      "description": "Allowed VGV Spellings"
    },
    // Local dictionary example. Relative paths are relative to the config file.
    {
      "name": "vgv_forbidden",
      "path": "./vgv_forbidden.txt",
      "addWords": true
    }
  ],
  // Ignores files found in .gitignore.
  "useGitignore": true,
  // List of allowed words that are not part of dictionaries.
  "words": ["Contador", "localizable", "mostrado", "página", "Texto"],
  // List of not-allowed words.
  // For example "hte" should be "the".
  "flagWords": ["hte"]
}
```
