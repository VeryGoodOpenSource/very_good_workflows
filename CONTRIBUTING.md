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

## 🦦 Releasing

1. Go to the **main** branch and ensure it is up to date with the remote:

    ```bash
    git checkout main
    git pull
    ```

1. Run the script that will generate the CHANGELOG for you:

    ```bash
    sh tool/release_ready.sh <new-version>
    ```

    **Note 💡** : You should follow semantic versioning and bump according to the changes the new version makes.

    `<new-version>`: The version of this new extension release, for example: 0.2.1

    The release_ready script will:

    - Create a new branch just for this release and checkout to it.
    - Automatically update the CHANGELOG file with the associated changes.

1. Manually remove the *(deps-dev)* scope or other entries of the conventional commits entries in the CHANGELOG
1. Add the changes and commit with the commit message that the *release_ready* script outputted.
1. Raise a Pull Request, the title should be the same as the commit message outputted by the *release_ready* script.
1. When the Pull Request is merged, tag a new release to the commit. When adding the tag ensure:
    - The tag is pointing to the commit that you recently merged.
    - The title of the tag should be v<new-version>
    - The title of the release should be v<new-version>
    - The description should be a raw copy of the CHANGELOG’s file version’s body you recently crafted (without the version header). If in doubt, see the other released tags as an example.
1. After the release is tagged the new changes will be available by the the following syntax:

    ```yaml
    VeryGoodOpenSource/..@v<new-version>
    ```

    Where:

    - `<new-version>`: The version of this new workflow or action, for example: 0.2.1

1. Go to the **main** branch and ensure it is up to date with the remote:

    ```yaml
    git checkout main
    git pull
    ```

1. Retag the major release.

    For the Workflow or Action to be updated for those users using the `@<major-version` syntax we will require to retag the major release.

    ```yaml
    sh tool/retag_v<major-version>.sh <new-version>
    ```

    Where:

    - `<major-version>`: Is the major version of the release, for example in 2.16.3 the major version is 2. For more information see the [semantic versioning documentation](https://semver.org/).
    - `<new-version>`: The version of this new workflow or action, for example: 0.2.1.

    If your change is a breaking change and requires a new major release you should update the name of the retag script and its `v<major-version>` instances.

1. After the retag the new changes will be available by the the following syntax:

    ```yaml
    VeryGoodOpenSource/..@v<major-version>
    ```

    Where: `<major-version>`: Is the major version of the release, for example in 2.16.3 the major version is 2. For more information see the [semantic versioning documentation](https://semver.org/).

[conventional_commits_link]: https://www.conventionalcommits.org/en/v1.0.0
[bug_report_link]: https://github.com/VeryGoodOpenSource/very_good_workflows/issues/new?assignees=&labels=bug&template=bug_report.md&title=fix%3A+
[very_good_ventures_link]: https://verygood.ventures
