---
sidebar_position: 8
---

# Semantic Pull Request

At VGV, we use [conventional commits](https://www.conventionalcommits.org/en/v1.0.0/). This way, our commit history is clean and useful when we squash and merge — we can easily see the type and brief description of each PR. Note that this workflow can be customized to reflect the pull request types you want to enforce (e.g. feat, fix, docs, chore).

## Steps

The semantic pull request package workflow consists of the following step:

1. Ensure commit is semantic

## Inputs

### `types`

**Optional** Configure which types are allowed (e.g. `"feat, fix, docs"`).

**Note**: If not set, then the action uses the list of [Commitizen conventional commit types][commitizen].

### `scopes`

**Optional** Configure which scopes are allowed (e.g. `"dart_package, flutter_package"`).

## Example Usage

```yaml
name: My Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/semantic_pull_request.yml@v1
```

[commitizen]: https://github.com/commitizen/conventional-commit-types
