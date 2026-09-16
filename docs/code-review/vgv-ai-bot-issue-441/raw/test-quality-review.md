## Test Quality Review

### Context

This repo has no application code. It ships reusable GitHub Actions workflow
templates (YAML) plus a Docusaurus site. The new test suite (`test/workflows.test.js`,
using Jest + js-yaml) statically validates the YAML templates, and `ci.yml`
separately runs each template end-to-end against sample packages in `examples/`.
"Test quality" here means: do the Jest assertions catch a broken template, and
does the CI wiring actually execute and gate on them.

### Coverage Summary

- Test run: **Pass** — `npm ci && npm test` → 143 passed, 143 total, ~0.2s.
- Coverage: not measured (no coverage config/threshold; not meaningful for a
  pure YAML-shape validator, so this is not flagged as a gap).
- Files with tests: the suite covers every file under `.github/workflows/`
  generically (YAML validity for all, schema checks for every `workflow_call`
  template) plus `ci.yml` and the docs/README sync. No untested production
  file in scope.
- Runner wiring: `package.json` → `"test": "jest"`, `jest.testEnvironment: node`,
  `roots: ["<rootDir>/test"]`. Correct and matches the actual file location.
- CI execution: `.github/workflows/ci.yml` adds a `verify-workflow-templates`
  job (`actions/checkout` → `actions/setup-node@v4` → `npm ci --include=dev` →
  `npm test`) and lists it in `build`'s `needs:`, so a Jest failure blocks the
  `build` gate. Confirmed by reading the diff; this wiring is correct.

### Structural Test Quality (`test/workflows.test.js`)

Overall this is a well-built structural suite for the domain:

- Good group organization (`describe` per concern: per-template schema,
  `ci.yml` exercising templates, docs sync, validator self-tests).
- Descriptive, specification-style test names (e.g. "every workflow_call input
  declares a valid type", "%s is exercised by ci.yml").
- A dedicated `describe('validators reject malformed workflows', …)` block
  feeds synthetic malformed fixtures into `isReusableTemplate`,
  `findInvalidJobs`, and `findInvalidInputs` to prove those helper functions
  actually reject bad shapes rather than being accidentally vacuous. This is
  exactly the kind of guard this review looks for, and it's present and
  correct — a genuine strength worth preserving as a pattern for future test
  additions in this repo.
- `EXPECTED_TEMPLATES` is an explicit, hand-maintained list, so adding/removing
  a template is a deliberate, reviewed change rather than a silent discovery
  regression — good design.
- No anti-patterns from the standard checklist apply here (no mocks to
  overuse, no tautological `expect(true).toBe(true)`, no empty-assertion
  tests, no implementation mirroring of production logic — the helper
  functions under test in the "malformed workflows" block are test-support
  code, not a re-implementation of a production algorithm).

However, the suite is **entirely structural/shape-level**. It checks that
`workflow_call` inputs declare a valid `type`, that jobs have `runs-on` or
`uses`, that docs/README entries exist, and that every template file is
_referenced_ somewhere in `ci.yml`. It does not check that a workflow's steps
correctly _use_ those inputs. That distinction matters for this PR because the
PR's actual behavioral changes — new `artifact_name`/`artifact_paths` inputs
wired to a new "📤 Upload Artifacts" step, and a new `flutter_version_file`
input wired into `subosito/flutter-action`'s `flutter-version-file:` field and
into `license_check.yml`'s `is_flutter` OR-condition — are not exercised by
any assertion in `test/workflows.test.js`. They fall entirely to `ci.yml`'s
functional layer.

### Would any test pass even if the workflow were broken?

Yes, in two concrete ways:

1. **Wiring bugs in the new inputs are invisible to the Jest suite.** If a
   future edit swapped `artifact_name`/`artifact_paths` in the `with:` block
   of the "📤 Upload Artifacts" step (`.github/workflows/dart_package.yml:161-166`,
   `.github/workflows/flutter_package.yml:190-195`), removed the `if:` guard,
   or dropped `flutter-version-file: ${{inputs.flutter_version_file}}` from
   the `subosito/flutter-action` step, every one of the 143 Jest assertions
   would still pass — `findInvalidInputs`/`findInvalidJobs` only look at the
   `workflow_call.inputs` block and job-level `steps`/`runs-on`/`uses`
   shape, never at whether a given input is referenced inside a specific
   step's `with:`.

2. **`if-no-files-found: ignore` masks a broken glob in both testing layers.**
   The new "📤 Upload Artifacts" step in `dart_package.yml` and
   `flutter_package.yml` sets `if-no-files-found: ignore`. `ci.yml`'s
   `verify-dart`/`verify-flutter` jobs pass real `artifact_paths` values
   (`examples/dart_package/coverage/lcov.info`, etc.), which is good
   functional coverage of the happy path today — but if that path ever goes
   stale (renamed coverage dir, wrong working-directory-relative prefix,
   etc.), the upload step will not fail, the job will not fail, and nothing
   in the Jest suite inspects the actual `path:`/`name:` values either. A
   silently-broken artifact upload would ship undetected by any test in the
   repo.

### Precedence claim for `flutter_version_file` is untested

The docs for `flutter_package.yml`, `flutter_pub_publish.yml`, and
`license_check.yml` all state `flutter_version_file` "takes precedence over
flutter_version when set." `ci.yml`'s new `verify-flutter-version-file` and
`verify-license-check-flutter-version-file` jobs only ever set
`flutter_version_file` alone (`flutter_version` is left at its default `""`),
so the actual precedence behavior when _both_ inputs are non-empty is never
exercised anywhere in the repo — it rests entirely on an assumption about how
`subosito/flutter-action@v2`/`v2.23.0` resolves the two inputs together.

### Minor: new CI job uses an inconsistent action version

`ci.yml`'s new `verify-workflow-templates` job pins `actions/setup-node@v4`
(`.github/workflows/ci.yml:18`), while the repo's other Node-using jobs
(`site.yaml`, `site_deploy.yaml`) pin `actions/setup-node@v7`. Not a
correctness bug, but an avoidable inconsistency introduced by this PR.

### Anti-Patterns Found

None of the standard anti-patterns (tautological assertions, mocking the
unit under test, no-assertion tests, over-verification, missing async waits)
apply to this suite — it's synchronous file/YAML inspection with real
fixtures throughout.

### Recommendations

1. Add step-level assertions for the new inputs: parse each template's
   `jobs.build.steps` and assert that `artifact_name`/`artifact_paths` appear
   in the "Upload Artifacts" step's `with:` and that `flutter_version_file`
   appears in the Flutter-setup step's `with:` (and, for `license_check.yml`,
   that `env.is_flutter` references `inputs.flutter_version_file`). This
   closes the "would pass even if broken" gap for exactly the inputs this PR
   adds.
2. Consider a `ci.yml` job (or a follow-up step) that asserts the uploaded
   artifact actually exists — e.g., `actions/download-artifact` in a
   dependent job, or switching `if-no-files-found` to `warn`/`error` for the
   `examples/` verification jobs specifically — so a stale glob path surfaces
   as a real CI failure instead of silently doing nothing.
3. Add (or explicitly scope out) a case that sets both `flutter_version` and
   `flutter_version_file` together, so the documented precedence behavior is
   actually exercised once rather than assumed.
4. Align `actions/setup-node` version in the new `verify-workflow-templates`
   job with the rest of the repo (`@v7`).

### Verdict

Fix the two Important findings before merge is optional but recommended —
the suite is well-constructed for what it tests, but the specific inputs this
PR introduces are only covered at the "file exists and is referenced"
granularity, not at the "wired correctly" granularity. No blocking defects
found; the test suite passes, and CI is correctly wired to run it.
