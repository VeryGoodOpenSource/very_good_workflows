# Evals example

A fixture used by `ci.yml` to exercise the [`evals.yml`](../../.github/workflows/evals.yml)
reusable workflow.

It deliberately contains **no eval cases**. The workflow's `scope` job finds
nothing to run and skips the paid `run` job, so CI exercises the workflow end to
end without an `ANTHROPIC_API_KEY` or any API cost. A real consumer points
`working_directory` at a Claude Code plugin that holds `skills/` and `evals/`
directories.
