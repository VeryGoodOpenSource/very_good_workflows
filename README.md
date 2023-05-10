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

# A reusable workflow for ensuring commits are semantic
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/semantic_pull_request.yml@v1

# A reusable workflow for verifying package scores on pub.dev
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/pana.yml@v1

# A reusable workflow for running a spell check
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/spell_check.yml@v1

# A reusable workflow for publishing flutter packages
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/flutter_pub_publish.yml@v1

# A reusable workflow for publishing dart packages
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/dart_pub_publish.yml@v1
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

#### `concurrency`

**Optional** The number of concurrent test suites run.

**Default** `4`

#### `coverage_excludes`

**Optional** List of paths to exclude from the coverage report, separated by an empty space. Supports `globs` to describe file patterns.

**Default** `""`

#### `dart_sdk`

**Optional** Which Dart SDK version to use. It can be a version (e.g. `2.12.0`) or a channel (e.g. `stable`):

**Default** `"stable"`

#### `format_line_length`

**Optional** The line-length preferred to run the `dart format` command with. Be aware that this does not change the behavior of the analysis step and longer lines could still make the workflow fail if the rule `lines_longer_than_80_chars` is used.

**Default** `"80"`

#### `min_coverage`

**Optional** The minimum coverage percentage allowed.

**Default** 100

#### `working_directory`

**Optional** The path to the root of the Dart package.

**Default** `"."`

#### `analyze_directories`

**Optional** A space separated list of folders that should be analyzed.

**Default** `"lib test"`

#### `format_directories`

**Optional** A space separated list of folders that should be formatted.

**Default** `"."`

#### `check_ignore`

**Optional** Allows ignoring lines from [coverage][coverage].

**Default** `false`

#### `report_on`

**Optional** A comma separated list of folders that should be checked in code coverage.

**Default** `"lib"`

#### `runs_on`

**Optional** An optional operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

#### `setup`

**Optional** An optional command that should be executed immediately after dependencies are installed.

**Default** `""`

#### `platform`

**Optional** An optional, comma-separated list of platform(s) on which to run the tests.
`[vm (default), chrome, firefox, safari, node]`

**Default** `"vm"`

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
      platform: "chrome,vm"
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

#### `analyze_directories`

**Optional** A space separated list of folders that should be analyzed.

**Default** `"lib test"`

#### `format_directories`

**Optional** A space separated list of folders that should be formatted.

**Default** `"lib test"`

#### `concurrency`

**Optional** The number of concurrent test suites run.

**Default** `4`

#### `coverage_excludes`

**Optional** List of paths to exclude from the coverage report, separated by an empty space. Supports `globs` to describe file patterns.

**Default** `""`

#### `flutter_channel`

**Optional** The Flutter release channel to use (e.g. `stable`).

**Default** `"stable"`

#### `flutter_version`

**Optional** The Flutter SDK version to use (e.g. `2.8.1`).

**Default** `""`

#### `format_line_length`

**Optional** The line-length preferred to run the `dart format` command with. Be aware that this does not change the behavior of the analysis step and longer lines could still make the workflow fail if the rule `lines_longer_than_80_chars` is used.

**Default** `"80"`

#### `min_coverage`

**Optional** The minimum coverage percentage allowed.

**Default** 100

#### `setup`

**Optional** An optional command that should be executed immediately after dependencies are installed.

**Default** `""`

#### `working_directory`

**Optional** The path to the root of the Flutter package.

**Default** `"."`

#### `test_optimization`

**Optional** Enable the test optimization.

**Default** `true`

**Note**: Since the optimization process groups tests into a single file, golden tests will not work properly. Consider disabling optimizations if you are using golden tests.

#### `test_recursion`

**Optional** Whether to recursively run tests in nested directories.

**Default** `false`

#### `runs_on`

**Optional** An optional operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

#### `package_get_excludes`

**Optional** List of paths to exclude from `packages get`. Supports `globs` to describe file patterns.

**Default** `"!*"`

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

## Semantic Pull Request Workflow

### Inputs

#### `types`

**Optional** Configure which types are allowed (e.g. `"feat, fix, docs"`).

**Note**: If not set then the action uses the list of Conventional Commits type of the [commitizen][commitizen].

#### `scopes`

**Optional** Configure which scopes are allowed (e.g. `"dart_package, flutter_package"`).

### Steps

The semantic pull request package workflow consists of the following steps:

1. Ensure Commit is Semantic

### Example Usage

```yaml
name: My Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/semantic_pull_request.yml@v1
```

## Pana Workflow

### Steps

The pana workflow consists of the following steps:

1. Install Pana
2. Verify Pana Score

### Inputs

#### `pana_version`

**Optional** Which version of `package:pana` to use (e.g. `0.21.15`).

#### `min_score`

**Optional** The minimum score allowed.

**Default** `120`

#### `working_directory`

**Optional** The path to the root of the Dart package.

**Default** `"."`

#### `runs_on`

**Optional** An optional operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

### Example Usage

```yaml
name: My Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/pana.yml@v1
    with:
      min_score: 95
      working_directory: "examples/my_flutter_package"
```

## Spell Check Workflow

### Steps

The spell check workflow consists of the following steps:

1. Git Checkout
2. Run Spell Check

### Inputs

#### `config`

**Optional** The location of the `cspell.json`.

**Default** `".github/cspell.json"`

#### `includes`

**Optional** The glob patterns to filter the files to be checked. Use a new line between patterns to define multiple patterns.

**Default** `""`

#### `working_directory`

**Optional** The path to the root of the Dart package.

**Default** `"."`

#### `runs_on`

**Optional** An optional operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

#### `verbose`

**Optional** An optional boolean which determines whether to log verbose output.

**Default** `false`

#### `modified_files_only`

**Optional** An optional boolean which determines whether spell check is run on modified files.

**Default** `true`

### Example Usage

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

## Flutter Pub Publish Workflow

### Steps

The Flutter Pub Publish workflow consists of the following steps:

1. Install dependencies
2. Setup pub credentials
3. Dry run
4. Publish

### Inputs

#### `flutter_channel`

**Optional** The Flutter release channel to use (e.g. `stable`).

**Default** `"stable"`

#### `flutter_version`

**Optional** The Flutter SDK version to use (e.g. `2.8.1`).

**Default** `""`

#### `working_directory`

**Optional** The path to the root of the Flutter package.

**Default** `"."`

#### `runs_on`

**Optional** An optional operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

#### `pub_credentials`

**Required** The pub credentials needed for publishing. This can be retrieved by reading out your `pub-credentials.json` on your system after you ran a `flutter pub login`. The location of the file is different per operating system:

| OS      | Path                                                                                      |
| ------- | ----------------------------------------------------------------------------------------- |
| Linux   | `$XDG_CONFIG_HOME/dart/pub-credentials.json` or `$HOME/.config/dart/pub-credentials.json` |
| macOS   | `~/Library/Application\ Support/dart/pub-credentials.json`                                |
| Windows | `%APPDATA%/dart/pub-credentials.json`                                                     |

### Example Usage

We recommend using [GitHub Secrets][github_actions_secrets_docs] for safely storing and reading the credentials.

```yaml
name: My Flutter Pub Publish Workflow

on:
  push:
    tags:
      - 'my_flutter_package-v*.*.*'

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/flutter_pub_publish.yml@v1
    with:
      flutter_channel: "stable"
      flutter_version: "2.8.1"
      working_directory: "packages/my_flutter_package"
      pub_credentials: ${{ secrets.PUB_CREDENTIALS }}
```

## Dart Pub Publish Workflow

### Steps

The Dart Pub Publish workflow consists of the following steps:

1. Install dependencies
2. Setup pub credentials
3. Dry run
4. Publish

### Inputs

#### `dart_sdk`

**Optional** Which Dart SDK version to use. It can be a version (e.g. `2.12.0`) or a channel (e.g. `stable`):

**Default** `"stable"`

#### `working_directory`

**Optional** The path to the root of the Dart package.

**Default** `"."`

#### `runs_on`

**Optional** An optional operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

#### `pub_credentials`

**Required** The pub credentials needed for publishing. This can be retrieved by reading out your `pub-credentials.json` on your system after you ran a `dart pub login`, the location of the file is different per operating system:

| OS      | Path                                                                                      |
| ------- | ----------------------------------------------------------------------------------------- |
| Linux   | `$XDG_CONFIG_HOME/dart/pub-credentials.json` or `$HOME/.config/dart/pub-credentials.json` |
| macOS   | `~/Library/Application\ Support/dart/pub-credentials.json`                                |
| Windows | `%APPDATA%/dart/pub-credentials.json`                                                     |

### Example Usage

We recommend using [GitHub Secrets][github_actions_secrets_docs] for safely storing and reading the credentials.

```yaml
name: My Dart Pub Publish Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/dart_pub_publish.yml@v1
    with:
      dart_sdk: "stable"
      working_directory: "packages/my_dart_package"
      pub_credentials: ${{ secrets.PUB_CREDENTIALS }}
```

## Mason Publish Workflow

### Steps

The Mason Publish workflow consists of the following steps:

1. Install Mason
2. Setup Mason credentials
3. Dry run
4. Publish

### Inputs

#### `mason_version`

**Optional** Which Mason version to use (e.g. `0.1.0-dev.50`).

**Default** `""`

#### `working_directory`

**Optional** The path to the root of the Mason brick.

**Default** `"."`

#### `runs_on`

**Optional** An optional operating system on which to run the workflow.

**Default** `"ubuntu-latest"`

#### `mason_credentials`

**Required** The mason credentials needed for publishing. This can be retrieved by reading out your `mason-credentials.json` on your system after you ran a `mason login`, the location of the file is different per operating system:

| OS      | Path                                                                                            |
| ------- | ----------------------------------------------------------------------------------------------- |
| Linux   | `$XDG_CONFIG_HOME/mason/mason-credentials.json` or `$HOME/.config/mason/mason-credentials.json` |
| macOS   | `~/Library/Application\ Support/mason/mason-credentials.json`                                   |
| Windows | `%APPDATA%/mason/mason-credentials.json`                                                        |

### Example Usage

We recommend using [GitHub Secrets][github_actions_secrets_docs] for safely storing and reading the credentials.

```yaml
name: My Mason Brick Publish Workflow

on: pull_request

jobs:
  build:
    uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/mason_publish.yml@v1
    with:
      mason_version: "0.1.0-dev.50"
      working_directory: "packages/my_mason_brick"
      mason_credentials: ${{ secrets.MASON_CREDENTIALS }}
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
[commitizen]: https://github.com/commitizen/conventional-commit-types
[coverage]: https://pub.dev/packages/coverage
[github_actions_secrets_docs]: https://docs.github.com/en/rest/actions/secrets
