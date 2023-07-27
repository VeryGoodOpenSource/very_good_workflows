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

## GitHub Permissions

When running this workflow, the `GITHUB_TOKEN` has to have the correct permissions to run successfully. On public repositories, the default settings grant the token enough permissions to run correctly. However, on private repositories, settings have to be updated. There are two ways of doing so:

- **Repository wide update.** Inside your repository, go to _Settings > Actions > General_, scroll down to the _Workflow permissions_ section and update it to allow _Read and write permissions_. Don't forget to save the changes.
- **Workflow specific update.** In your workflow `yaml` file, you can modify the permissions for the `GITHUB_TOKEN`. For this workflow to work you have to enable write permissions for pull requests in your job as follows.

  ```yaml
  jobs:
    build:
      permissions:
        pull-requests: write
      uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/semantic_pull_request.yml@v1
  ```

  You can read more about this in the [github documentation](https://docs.github.com/en/actions/security-guides/automatic-token-authentication#modifying-the-permissions-for-the-github_token).

## Example Usage

```yaml
name: My Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/semantic_pull_request.yml@v1
```

[commitizen]: https://github.com/commitizen/conventional-commit-types
