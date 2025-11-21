# Contributing to Very Good Workflows

First off, thanks for taking the time to contribute! 🎉👍

This project is opinionated and follows patterns and practices used by the team at [Very Good Ventures][very_good_ventures_link]. **At this time, we welcome bug tickets but will not be accepting feature requests because the roadmap and scope of this project is still being defined.**

## Creating a Bug Report

We highly recommend [creating an issue][bug_report_link] if you have found a bug rather than immediately opening a pull request. This lets us reach an agreement on a fix before you put significant effort into a pull request. Please use the built-in [Bug Report][bug_report_link] template and provide as much information as possible including detailed reproduction steps. Once one of the package maintainers has reviewed the issue and an agreement is reached regarding the fix, a pull request can be created.

## Creating a Pull Request

Before creating a pull request please:

1. Fork the repository and create your branch from `main`.
1. Install all dependencies (`flutter packages get` or `pub get`).
1. Squash your commits and ensure you have a meaningful, [semantic][conventional_commits_link] commit message.
1. Add tests! Pull Requests without 100% test coverage will not be approved.
1. Ensure the existing test suite passes locally.
1. Format your code (`dart format .`).
1. Analyze your code (`dart analyze --fatal-infos --fatal-warnings .`).
1. Create the Pull Request.
1. Verify that all status checks are passing.

While the prerequisites above must be satisfied prior to having your
pull request reviewed, the reviewer(s) may ask you to complete additional
work, tests, or other changes before your pull request can be ultimately
accepted.

## Release Process 🚀

This project uses [release-please-action](https://github.com/googleapis/release-please-action) to automate releases. Versioning
and changelog generation are handled automatically based on [Conventional Commits](https://www.conventionalcommits.org/).

### How It Works

- 📌 **On every commit to `main`:**
    - Commits are analyzed using Conventional Commits standards
    - A release PR is automatically created or updated if a version bump is needed
    - The **release PR** includes:
        - An updated `CHANGELOG.md` 
        - A version bump in `.release-please-manifest.json`

    ##### 💡 Notes

    - The GitHub Action workflow that automates the release process is configured in `.github/workflows/release_please.yml`
    - release-please settings are defined in `.release-please-config.json` and `.release-please-manifest.json`
    - The release PR can be manually edited before merging
    - The release PR should be merged **ONLY** when a new release is needed.

<br />

- ✅ **When the release PR is merged:**
    - A new Git tag is created
    - A GitHub Release is published with the changelog
    - The new version is immediately available using: `VeryGoodOpenSource/very_good_workflows/.github/workflows/<workflow_name>@v<version>`

    ##### 💡 Notes

    - Changes to excluded paths (.github/, site/, examples/, docs) will not trigger releases
    - Only workflow file changes will result in version bumps
    - Major version tags (e.g., `v1`) are automatically updated to point to the latest release within that major version

<br />

[conventional_commits_link]: https://www.conventionalcommits.org/en/v1.0.0
[bug_report_link]: https://github.com/VeryGoodOpenSource/very_good_workflows/issues/new?assignees=&labels=bug&template=bug_report.md&title=fix%3A+
[very_good_ventures_link]: https://verygood.ventures
