# Very Good Workflows

[![Very Good Ventures][logo_white]][very_good_ventures_link_dark]
[![Very Good Ventures][logo_black]][very_good_ventures_link_light]

Developed with 💙 by [Very Good Ventures][very_good_ventures_link] 🦄

[![ci][ci_badge]][ci_link]
[![License: MIT][license_badge]][license_link]

---

Reusable [GitHub workflows][github_workflows_link] used internally at [Very Good Ventures][very_good_ventures_link].

## Documentation 📝

For official documentation, please visit https://workflows.vgv.dev.

## Quick Start 🚀

To get started, add very good workflows to an existing GitHub workflow:

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

# A reusable workflow to keep track of the rights and restrictions external dependencies might impose on Dart or Flutter projects
uses: VeryGoodOpenSource/very_good_workflows/.github/workflows/license_check.yml@v1
```

For configuration details, check out our [official docs][workflows_docs].

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
[workflows_docs]: https://workflows.vgv.dev
