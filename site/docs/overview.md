---
sidebar_position: 1
---

# Overview

[GitHub workflows][github_workflows_link] are configurable, automated processes that can run at various points during the development process. For example, a workflow can run when a pull request is created or updated to perform various code quality checks before allowing the changes to be merged.

Very Good Workflows is a collection of workflows that we use at VGV to run automated checks in our CI pipelines. While built by VGV to be used internally, they can be used by anyone.

## Quick Start 🚀

To get started, add Very Good Workflows to an existing GitHub workflow:

```yaml
# A reusable workflow for Dart packages
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/dart_package.yml@v1

# A reusable workflow for Flutter packages
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/flutter_package.yml@v1

# A reusable workflow for ensuring commits are semantic
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/semantic_pull_request.yml@v1

# A reusable workflow for verifying package scores on pub.dev
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/pana.yml@v1

# A reusable workflow for running a spell check
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/spell_check.yml@v1

# A reusable workflow for publishing Flutter packages
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/flutter_pub_publish.yml@v1

# A reusable workflow for publishing Dart packages
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/dart_pub_publish.yml@v1

# A reusable workflow for publishing Mason bricks
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/mason_publish.yml@v1

```

[github_workflows_link]: https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions
[very_good_ventures_link]: https://verygood.ventures
