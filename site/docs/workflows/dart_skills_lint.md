---
sidebar_position: 10
---

# Dart Skills Lint

We use [`dart_skills_lint`](https://github.com/flutter/skills/tree/main/tool/dart_skills_lint) to validate agent skill directories against the [Agent Skills Specification](https://github.com/flutter/skills/blob/main/tool/dart_skills_lint/documentation/knowledge/SPECIFICATION.md).

This workflow only validates skill linting — no tests, coverage, formatting, or pana scoring. It serves as a pre-merge check to ensure skill definitions (e.g., `SKILL.md` files, YAML front matter, directory structure, relative paths) are valid.

## Steps

The dart skills lint workflow consists of the following steps:

1. Git checkout
2. Setup Dart
3. Activate `dart_skills_lint`
4. Lint skills

## Inputs

### `skills_directories`

**Optional** Space-separated list of root directories containing skill sub-folders to validate (passed as `--skills-directory` flags). If empty, `dart_skills_lint` falls back to its defaults (`.claude/skills` and `.agents/skills`).

**Default** `""`

### `dart_skills_lint_version`

**Optional** Version constraint for `dart pub global activate dart_skills_lint` (e.g., `^0.2.0`). If empty, activates the latest version.

**Default** `""`

### `dart_sdk`

**Optional** The Dart SDK version to use.

**Default** `"stable"`

### `working_directory`

**Optional** The path to the root of the project.

**Default** `"."`

### `runs_on`

**Optional** The operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

## Example Usage

```yaml
name: Lint Skills

on:
  pull_request:
    paths:
      - '.agents/skills/**'
      - '.claude/skills/**'

jobs:
  lint-skills:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/dart_skills_lint.yml@v1
    with:
      skills_directories: ".agents/skills .claude/skills"
```
