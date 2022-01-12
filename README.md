# Very Good Workflows

[![Very Good Ventures][logo_white]][very_good_ventures_link_dark]
[![Very Good Ventures][logo_black]][very_good_ventures_link_light]

Developed with 💙 by [Very Good Ventures][very_good_ventures_link] 🦄

---

Reusable [GitHub Workflows][github_workflows_link] used at [Very Good Ventures][very_good_ventures_link] 🦄

## Quick Start

To get started add very good workflows to an existing GitHub workflow:

```yaml
# A reusable workflow for Dart packages
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/dart_package.yml@main

# A reusable workflow for Flutter packages
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/flutter_package.yml@main
```

## Dart Package Workflow

### Steps

The Dart package workflow consists of the following steps:

1. Install Dependencies
2. Format        
3. Analyze
4. Run tests
5. Check Code Coverage

### Inputs

#### `working_directory`

**Optional** The path to the root of the dart package.

**Default** `"."`

#### `coverage_excludes`

**Optional** List of paths to exclude from the coverage report, separated by an empty space. Supports `globs` to describe file patterns.

**Default** `""`

### Example Usage

```yaml
name: My Dart Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/dart_package.yml@main
    with:
      working_directory: examples/my_dart_package
      coverage_excludes: "*.g.dart"
```

## Flutter Package Workflow

### Steps

The Flutter package workflow consists of the following steps:

1. Install Dependencies
2. Format        
3. Analyze
4. Run tests
5. Check Code Coverage

### Inputs

#### `working_directory`

**Optional** The path to the root of the dart package.

**Default** `"."`

#### `coverage_excludes`

**Optional** List of paths to exclude from the coverage report, separated by an empty space. Supports `globs` to describe file patterns.

**Default** `""`

### Example Usage

```yaml
name: My Flutter Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/flutter_package.yml@main
    with:
      working_directory: examples/my_flutter_package
      coverage_excludes: "*.g.dart"
```

[github_workflows_link]: https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link]: https://verygood.ventures