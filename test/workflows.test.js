const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

const repoRoot = path.resolve(__dirname, '..');
const workflowsDir = path.join(repoRoot, '.github', 'workflows');
const docsDir = path.join(repoRoot, 'site', 'docs', 'workflows');
const readmePath = path.join(repoRoot, 'README.md');
const ciWorkflowPath = path.join(workflowsDir, 'ci.yml');

// Publish workflows push artifacts to external registries (pub.dev, brickhub.dev)
// and therefore cannot be exercised end-to-end from CI without real credentials.
// They are still validated structurally like every other template below, but they
// are exempt from the "must be exercised by ci.yml" guard.
const PUBLISH_ONLY_TEMPLATES = new Set([
  'dart_pub_publish.yml',
  'flutter_pub_publish.yml',
  'mason_publish.yml',
]);

// Valid types for a `workflow_call` input, per the GitHub Actions schema.
const VALID_INPUT_TYPES = new Set(['string', 'number', 'boolean']);

// The reusable templates advertised in the README quick start. Kept explicit so
// that adding or removing a template is a deliberate, reviewed change and a
// discovery regression can never silently skip a template's validations.
const EXPECTED_TEMPLATES = [
  'dart_package.yml',
  'dart_pub_publish.yml',
  'flutter_package.yml',
  'flutter_pub_publish.yml',
  'license_check.yml',
  'mason_publish.yml',
  'pana.yml',
  'semantic_pull_request.yml',
  'skills_lint.yml',
  'spell_check.yml',
];

/**
 * Parse a YAML file into a JavaScript object.
 */
function loadYaml(filePath) {
  return yaml.load(fs.readFileSync(filePath, 'utf8'));
}

/**
 * Returns the `on:` trigger mapping for a workflow document.
 *
 * With js-yaml v4 (YAML 1.2 core schema) the key parses as the string "on", but
 * we defensively also handle the YAML 1.1 boolean coercion (`true`) so the tests
 * are resilient to the parser configuration.
 */
function getTriggers(doc) {
  if (!doc || typeof doc !== 'object') return undefined;
  if (doc.on !== undefined) return doc.on;
  if (doc[true] !== undefined) return doc[true];
  return undefined;
}

/**
 * A reusable workflow template is any workflow that declares a `workflow_call`
 * trigger, meaning consumers can reference it via `uses:`.
 */
function isReusableTemplate(doc) {
  const triggers = getTriggers(doc);
  return Boolean(
    triggers &&
      typeof triggers === 'object' &&
      Object.prototype.hasOwnProperty.call(triggers, 'workflow_call'),
  );
}

/**
 * Returns the names of jobs that neither run steps (with a declared runner) nor
 * delegate to another reusable workflow via `uses`.
 */
function findInvalidJobs(doc) {
  const jobs = (doc && doc.jobs) || {};
  return Object.entries(jobs)
    .filter(([, job]) => {
      if (!job || typeof job !== 'object') return true;
      const runsSteps = Array.isArray(job.steps) && job.steps.length > 0;
      const callsWorkflow = typeof job.uses === 'string';
      if (runsSteps) return job['runs-on'] === undefined;
      return !callsWorkflow;
    })
    .map(([name]) => name);
}

/**
 * Returns `"name: type"` descriptors for every `workflow_call` input that does
 * not declare a valid type, as required by the GitHub Actions schema.
 */
function findInvalidInputs(doc) {
  const workflowCall = (getTriggers(doc) || {}).workflow_call || {};
  const inputs = workflowCall.inputs || {};
  return Object.entries(inputs)
    .filter(
      ([, spec]) =>
        !spec || typeof spec !== 'object' || !VALID_INPUT_TYPES.has(spec.type),
    )
    .map(([name, spec]) => `${name}: ${spec && spec.type}`);
}

const allWorkflowFiles = fs
  .readdirSync(workflowsDir)
  .filter((file) => file.endsWith('.yml') || file.endsWith('.yaml'))
  .sort();

const templateFiles = allWorkflowFiles.filter((file) => {
  try {
    return isReusableTemplate(loadYaml(path.join(workflowsDir, file)));
  } catch {
    return false;
  }
});

describe('workflow templates', () => {
  test('the workflows directory exists and contains workflows', () => {
    expect(fs.existsSync(workflowsDir)).toBe(true);
    expect(allWorkflowFiles.length).toBeGreaterThan(0);
  });

  test('at least one reusable workflow template is provided', () => {
    // Guards against a discovery regression that would silently skip every
    // per-template assertion below.
    expect(templateFiles.length).toBeGreaterThan(0);
  });

  test('discovers exactly the expected set of templates', () => {
    // If this fails, a template was added or removed: update EXPECTED_TEMPLATES
    // (and the README quick start + docs) to match.
    expect(templateFiles).toEqual([...EXPECTED_TEMPLATES].sort());
  });

  describe('every workflow file is syntactically valid YAML', () => {
    test.each(allWorkflowFiles)('%s parses without error', (file) => {
      const filePath = path.join(workflowsDir, file);
      expect(() => loadYaml(filePath)).not.toThrow();
      expect(loadYaml(filePath)).not.toBeNull();
    });
  });

  describe.each(templateFiles)('%s', (file) => {
    const doc = loadYaml(path.join(workflowsDir, file));
    const base = file.replace(/\.ya?ml$/, '');

    test('is an object with a human-readable name', () => {
      expect(doc).toBeInstanceOf(Object);
      expect(typeof doc.name).toBe('string');
      expect(doc.name.trim().length).toBeGreaterThan(0);
    });

    test('declares a workflow_call trigger so it can be reused', () => {
      const triggers = getTriggers(doc);
      expect(triggers).toBeTruthy();
      expect(triggers).toHaveProperty('workflow_call');
    });

    test('defines at least one job', () => {
      expect(doc.jobs).toBeInstanceOf(Object);
      expect(Object.keys(doc.jobs).length).toBeGreaterThan(0);
    });

    test('every job runs steps or calls another workflow', () => {
      // A job is valid if it either runs steps (with a declared runner) or
      // delegates to another reusable workflow via `uses`.
      expect(findInvalidJobs(doc)).toEqual([]);
    });

    test('every workflow_call input declares a valid type', () => {
      // GitHub requires an explicit, valid type for reusable-workflow inputs.
      expect(findInvalidInputs(doc)).toEqual([]);
    });

    test('every workflow_call input has a boolean "required" when present', () => {
      const workflowCall = getTriggers(doc).workflow_call || {};
      const inputs = workflowCall.inputs || {};
      const badRequired = Object.entries(inputs)
        .filter(
          ([, spec]) =>
            spec &&
            'required' in spec &&
            typeof spec.required !== 'boolean',
        )
        .map(([name]) => name);
      expect(badRequired).toEqual([]);
    });

    test('required inputs do not declare a default', () => {
      const workflowCall = getTriggers(doc).workflow_call || {};
      const inputs = workflowCall.inputs || {};
      // A default only makes sense for optional inputs.
      const contradictory = Object.entries(inputs)
        .filter(([, spec]) => spec && spec.required === true && 'default' in spec)
        .map(([name]) => name);
      expect(contradictory).toEqual([]);
    });

    test('every declared secret is well-formed', () => {
      const workflowCall = getTriggers(doc).workflow_call || {};
      const secrets = workflowCall.secrets;
      if (secrets === undefined || secrets === 'inherit') return;
      expect(secrets).toBeInstanceOf(Object);
      const badSecrets = Object.entries(secrets)
        .filter(
          ([, spec]) =>
            !spec ||
            typeof spec !== 'object' ||
            ('required' in spec && typeof spec.required !== 'boolean'),
        )
        .map(([name]) => name);
      expect(badSecrets).toEqual([]);
    });

    test('is documented on the docs site', () => {
      expect(fs.existsSync(path.join(docsDir, `${base}.md`))).toBe(true);
    });

    test('is advertised in the README quick start', () => {
      const readme = fs.readFileSync(readmePath, 'utf8');
      expect(readme).toContain(`/.github/workflows/${file}@`);
    });
  });
});

describe('ci.yml exercises the templates', () => {
  const ciDoc = loadYaml(ciWorkflowPath);
  const ciSource = fs.readFileSync(ciWorkflowPath, 'utf8');

  // Collect every local template referenced via `uses: ./.github/workflows/*`.
  const localUses = new Set();
  for (const match of ciSource.matchAll(
    /uses:\s*\.\/\.github\/workflows\/([\w.-]+)/g,
  )) {
    localUses.add(match[1]);
  }

  test('ci.yml is valid and defines jobs', () => {
    expect(ciDoc).toBeInstanceOf(Object);
    expect(ciDoc.jobs).toBeInstanceOf(Object);
    expect(Object.keys(ciDoc.jobs).length).toBeGreaterThan(0);
  });

  test('every locally referenced workflow in ci.yml exists', () => {
    const missing = [...localUses].filter(
      (referenced) => !fs.existsSync(path.join(workflowsDir, referenced)),
    );
    expect(missing).toEqual([]);
  });

  const nonPublishTemplates = templateFiles.filter(
    (file) => !PUBLISH_ONLY_TEMPLATES.has(file),
  );

  test.each(nonPublishTemplates)('%s is exercised by ci.yml', (file) => {
    // If this fails, add a verification job to ci.yml, or add the template to
    // PUBLISH_ONLY_TEMPLATES if it genuinely cannot be run in CI.
    expect(localUses.has(file)).toBe(true);
  });

  test.each([...PUBLISH_ONLY_TEMPLATES])(
    'publish-only template %s exists and is a template',
    (file) => {
      expect(templateFiles).toContain(file);
    },
  );
});

describe('docs stay in sync with the templates', () => {
  const docFiles = fs
    .readdirSync(docsDir)
    .filter((file) => file.endsWith('.md'))
    .sort();

  test.each(docFiles)('%s documents an existing workflow template', (docFile) => {
    const workflowFile = `${docFile.replace(/\.md$/, '')}.yml`;
    expect(templateFiles).toContain(workflowFile);
  });
});

// Guard against vacuous validators: prove the structural checks actually reject
// the malformed shapes they are meant to catch, so a passing suite above is
// meaningful rather than accidentally trivial.
describe('validators reject malformed workflows', () => {
  test('isReusableTemplate ignores non-reusable workflows', () => {
    expect(isReusableTemplate({ on: { push: null }, jobs: {} })).toBe(false);
    expect(isReusableTemplate({ on: { workflow_call: {} } })).toBe(true);
  });

  test('findInvalidJobs flags jobs without steps, runner, or uses', () => {
    expect(findInvalidJobs({ jobs: { build: {} } })).toEqual(['build']);
    expect(
      findInvalidJobs({ jobs: { build: { steps: [{ run: 'echo hi' }] } } }),
    ).toEqual(['build']); // missing runs-on
    expect(
      findInvalidJobs({
        jobs: { build: { 'runs-on': 'ubuntu-latest', steps: [{ run: 'x' }] } },
      }),
    ).toEqual([]);
    expect(
      findInvalidJobs({ jobs: { call: { uses: './other.yml' } } }),
    ).toEqual([]);
  });

  test('findInvalidInputs flags inputs with missing or invalid types', () => {
    const doc = {
      on: {
        workflow_call: {
          inputs: {
            good: { type: 'string' },
            missing: { required: false },
            wrong: { type: 'object' },
          },
        },
      },
    };
    expect(findInvalidInputs(doc)).toEqual([
      'missing: undefined',
      'wrong: object',
    ]);
  });
});
