---
sidebar_position: 12
---

# Evals

This workflow runs [`claude plugin eval`](https://docs.claude.com/en/docs/claude-code) for a [Claude Code](https://claude.com/claude-code) plugin. It scopes the eval cases to the skills a change touched (or every skill), runs them under a cost ceiling, summarizes the report, and uploads it as an artifact.

Runs are **advisory**: the run job is `continue-on-error`, so a failing or regressed eval never blocks a merge.

## Steps

The evals workflow consists of two jobs:

1. **Scope** — enumerates the eval cases to run. For `changed-skills` it diffs the triggering change and keeps only the skills with eval cases that it touched; for `all-skills` it selects every skill with eval cases. When nothing is in scope, the run job is skipped.
2. **Run** — installs Claude Code, verifies the API key, runs the scoped evals under the cost ceiling, summarizes the results into the job summary, and uploads the report.

## Inputs

### `scope`

**Optional** Which cases to run: `changed-skills` (only skills a change touched) or `all-skills` (every skill with eval cases).

**Default** `"changed-skills"`

### `runs`

**Optional** Runs per case per arm. `1` is cheapest; `3` separates a real failure from noise.

**Default** `1`

### `include_baseline`

**Optional** Also run the no-plugin baseline arm (doubles the cost; only needed to re-check that cases discriminate).

**Default** `false`

### `max_cost_usd`

**Optional** Cost ceiling in USD. Leave blank to size it from the scope (`$5` for changed skills, `$20` for all skills in one arm, `$40` in both), multiplied by `runs`.

**Default** `""`

### `claude_code_version`

**Optional** The [`@anthropic-ai/claude-code`](https://www.npmjs.com/package/@anthropic-ai/claude-code) version to install.

**Default** `"2.1.270"`

### `model`

**Optional** The model that runs the eval cases.

**Default** `"claude-sonnet-5"`

### `judge_model`

**Optional** The model that grades the output. Deliberately not the agent model: a model grading its own output scores it generously, so the judge should be sonnet-tier or larger.

**Default** `"claude-opus-5"`

### `threshold`

**Optional** The minimum score a case must reach to pass.

**Default** `"0.8"`

### `allow_tools`

**Optional** Space-separated list of tools the eval run is allowed to use (passed to `--allow-tools`).

**Default** `"Write"`

### `working_directory`

**Optional** The path to the root of the plugin to evaluate.

**Default** `"."`

### `runs_on`

**Optional** The operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

## Secrets

### `ANTHROPIC_API_KEY`

**Optional** The Anthropic API key the eval run authenticates with. Required for the run job; locally these evals authenticate through the Claude Code session, but CI has none.

## Example Usage

```yaml
name: evals

on:
  push:
    branches:
      - main
    paths:
      - 'skills/**'
      - 'agents/**'
      - 'evals/**'
  workflow_dispatch:
    inputs:
      scope:
        description: 'Which cases to run'
        type: choice
        default: changed-skills
        options:
          - changed-skills
          - all-skills

jobs:
  evals:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/evals.yml@v2
    with:
      scope: ${{ inputs.scope || 'changed-skills' }}
    secrets:
      ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
```
