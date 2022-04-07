# Very Good Workflows

[![Very Good Ventures][logo_white]][very_good_ventures_link_dark]
[![Very Good Ventures][logo_black]][very_good_ventures_link_light]

Developed with 💙 by [Very Good Ventures][very_good_ventures_link] 🦄

[![ci][ci_badge]][ci_link]
[![License: MIT][license_badge]][license_link]

---

Reusable [GitHub Workflows][github_workflows_link] used at [Very Good Ventures][very_good_ventures_link] 🦄

## Quick Start

To get started add very good workflows to an existing GitHub workflow:

```yaml
# A reusable workflow for Dart packages
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/dart_package.yml@v1

# A reusable workflow for Flutter packages
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/flutter_package.yml@v1
```

For a more detailed guide, including tips and tricks, check out [our blog][very_good_workflows_blog_link].

## Dart Package Workflow

### Steps

The Dart package workflow consists of the following steps:

1. Install Dependencies
2. Format
3. Analyze
4. Run tests
5. Check Code Coverage

### Inputs

#### `coverage_excludes`

**Optional** List of paths to exclude from the coverage report, separated by an empty space. Supports `globs` to describe file patterns.

**Default** `""`

#### `dart_sdk`

**Optional** Which Dart SDK version to use. It can be a version (e.g. `2.12.0`) or a channel (e.g. `stable`):

**Default** `"stable"`

#### `min_coverage`

**Optional** The minimum coverage percentage allowed.

**Default** 100

#### `working_directory`

**Optional** The path to the root of the Dart package.

**Default** `"."`

### Example Usage

```yaml
name: My Dart Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/dart_package.yml@v1
    with:
      coverage_excludes: "*.g.dart"
      dart_sdk: "stable"
      working_directory: "examples/my_dart_package"
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

#### `coverage_excludes`

**Optional** List of paths to exclude from the coverage report, separated by an empty space. Supports `globs` to describe file patterns.

**Default** `""`

#### `flutter_channel`

**Optional** The Flutter release channel to use (e.g. `stable`).

**Default** `"stable"`

#### `flutter_version`

**Optional** The Flutter SDK version to use (e.g. `2.8.1`).

**Default** `""`

#### `min_coverage`

**Optional** The minimum coverage percentage allowed.

**Default** 100

#### `working_directory`

**Optional** The path to the root of the Flutter package.

**Default** `"."`

#### `test_recursion`

**Optional** If it should run the test recursively.

**Default** `false`

### Example Usage

```yaml
name: My Flutter Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/flutter_package.yml@v1
    with:
      coverage_excludes: "*.g.dart"
      flutter_channel: "stable"
      flutter_version: "2.8.1"
      working_directory: "examples/my_flutter_package"
      test_recursion: true
```

[ci_badge]: https://github.com/VeryGoodOpenSource/very_good_workflows/actions/workflows/ci.yml/badge.svg
[ci_link]: https://github.com/VeryGoodOpenSource/very_good_workflows/actions
[github_workflows_link]: https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link]: https://verygood.ventures
[very_good_workflows_blog_link]: https://verygood.ventures/blog/configuring-workflows-for-your-flutter-projects?utm_source=github&utm_medium=readme&utm_campaign=workflows_readme