const js = require('@eslint/js');
const globals = require('globals');

module.exports = [
  {
    files: ['*.js'],
    ignores: ['eslint.config.js'],
    rules: {
      ...globals.rules,
      ...js.configs.recommended.rules,
    },
    languageOptions: {
      globals: { ...globals.node },
    },
  },
];
