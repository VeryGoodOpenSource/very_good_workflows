// @ts-check
// Note: type annotations allow type checking and IDEs autocompletion

const lightCodeTheme = require('prism-react-renderer/themes/vsLight');
const darkCodeTheme = require('prism-react-renderer/themes/vsDark');

/** @type {import('@docusaurus/types').Config} */
const config = {
  title: 'Very Good Workflows',
  tagline: 'A collection of helpful, reusable GitHub workflows used by VGV.',
  url: 'https://workflows.vgv.dev',
  baseUrl: '/',
  onBrokenLinks: 'throw',
  onBrokenMarkdownLinks: 'warn',
  favicon: 'img/favicon.ico',
  trailingSlash: false,

  // GitHub pages deployment config.
  // If you aren't using GitHub pages, you don't need these.
  organizationName: 'my-org', // Usually your GitHub org/user name.
  projectName: 'my_docs_site', // Usually your repo name.

  // Even if you don't use internalization, you can use this field to set useful
  // metadata like html lang. For example, if your site is Chinese, you may want
  // to replace "en" with "zh-Hans".
  i18n: {
    defaultLocale: 'en',
    locales: ['en'],
  },

  presets: [
    [
      'classic',
      /** @type {import('@docusaurus/preset-classic').Options} */
      ({
        docs: {
          sidebarPath: require.resolve('./sidebars.js'),
          // Please change this to your repo.
          // Remove this to remove the "edit this page" links.
          editUrl: 'https://github.com/my-org/my_docs_site/tree/main/',
        },
        theme: {
          customCss: require.resolve('./src/css/custom.css'),
        },
      }),
    ],
  ],

  themeConfig:
    /** @type {import('@docusaurus/preset-classic').ThemeConfig} */
    ({
      navbar: {
        logo: {
          alt: 'Very Good Workflows',
          src: 'img/workflows_nav_icon.svg',
        },
        items: [
          {
            to: '/docs/overview',
            label: 'Get Started',
            position: 'right',
            className: 'button nav-button',
          },
          {
            label: 'VGV.DEV',
            to: 'https://vgv.dev',
            position: 'right',
          },
          {
            href: 'https://verygood.ventures',
            position: 'right',
            className: 'navbar-vgv-icon',
            'aria-label': 'VGV website',
          },
          {
            href: 'https://github.com/VeryGoodOpenSource/very_good_workflows',
            position: 'right',
            className: 'navbar-github-icon',
            'aria-label': 'GitHub repository',
          },
        ],
      },
      footer: {
        copyright: `Copyright © ${new Date().getFullYear()} Very Good Ventures.<br/>Built with 💙 by <a target="_blank" rel="noopener" aria-label="Very Good Ventures" href="https://verygood.ventures">Very Good Ventures</a>.`,
      },
      prism: {
        additionalLanguages: ['bash', 'dart', 'yaml'],
        theme: lightCodeTheme,
        darkTheme: darkCodeTheme,
      },
    }),
};

module.exports = config;
