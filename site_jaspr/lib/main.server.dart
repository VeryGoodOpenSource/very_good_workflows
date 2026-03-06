/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

import 'dart:io';

// Server-specific Jaspr import.
import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'package:jaspr_content/components/header.dart';
import 'package:jaspr_content/components/image.dart';
import 'components/collapsible_sidebar.dart';
import 'components/theme_toggle.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';

import 'components/breadcrumb.dart';
import 'components/doc_callout.dart';
import 'extensions/code_aware_toc.dart';
import 'components/edit_page_link.dart';
import 'components/homepage_layout.dart';
import 'components/icon_link.dart';
import 'components/nav_link.dart';
import 'components/page_navigation.dart';
import 'components/safe_code_block.dart';
import 'components/site_footer.dart';
import 'components/workflow_cards.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(
    options: defaultServerOptions,
  );

  // Starts the app.
  runApp(
    ContentApp(
      eagerlyLoadAllPages: true,
      templateEngine: MustacheTemplateEngine(),
      parsers: [
        MarkdownParser(),
      ],
      extensions: [
        HeadingAnchorsExtension(),
        TableOfContentsExtension(),
        CodeAwareTocPostProcessor(),
      ],
      components: [
        DocCallout(),
        WorkflowCards(),
        SafeCodeBlock(
          grammars: {
            'yaml': File('grammars/yaml.tmLanguage.json').readAsStringSync(),
            'bash': File('grammars/bash.tmLanguage.json').readAsStringSync(),
            'json': File('grammars/json.tmLanguage.json').readAsStringSync(),
          },
        ),
        Image(zoom: true),
      ],
      layouts: [
        DocsLayout(
          header: Header(
            title: 'Very Good Workflows',
            logo: '/images/workflows_nav_icon.svg',
            items: [
              NavLink(text: 'Get Started', href: '/docs/overview', isButton: true),
              NavLink(text: 'VGV Dev Tools', href: 'https://verygood.ventures/dev'),
              IconLink(
                href: 'https://verygood.ventures',
                iconSrc: '/images/vgv_logo_black.svg',
                darkIconSrc: '/images/vgv_logo_fill.svg',
                alt: 'Very Good Ventures',
              ),
              IconLink(
                href: 'https://github.com/VeryGoodOpenSource/very_good_workflows',
                iconSrc: '/images/github.svg',
                darkIconSrc: '/images/github_white.svg',
                alt: 'GitHub',
              ),
              ThemeToggle(),
            ],
          ),
          sidebar: CollapsibleSidebar(
            // Mobile sidebar header: CTA button + ThemeToggle, matching
            // Docusaurus's navbar-sidebar primary row (CTA · toggle · ×).
            // Icon links and secondary text links are intentionally omitted
            // to keep the header to a single row.
            mobileNavItems: [
              a(
                href: '/docs/workflows',
                classes: 'mobile-workflows-btn',
                [
                  img(
                    src: '/images/workflows_nav_icon.svg',
                    alt: 'Workflows',
                    attributes: {'height': '32', 'width': '105'},
                  ),
                ],
              ),
              ThemeToggle(),
            ],
            // Primary panel: global nav items shown when "← Back to main menu"
            // is tapped — mirrors Docusaurus's primary sidebar panel.
            primaryNavItems: [
              a(
                href: '/docs/overview',
                classes: 'sidebar-link',
                [Component.text('Get Started')],
              ),
              a(
                href: 'https://verygood.ventures/dev',
                target: Target.blank,
                classes: 'sidebar-link',
                [Component.text('VGV Dev Tools')],
              ),
              a(
                href: 'https://verygood.ventures',
                target: Target.blank,
                classes: 'sidebar-link',
                [
                  img(
                    classes: 'sidebar-icon-light',
                    src: '/images/vgv_logo_black.svg',
                    alt: 'Very Good Ventures',
                    attributes: {'width': '24', 'height': '24'},
                  ),
                  img(
                    classes: 'sidebar-icon-dark',
                    src: '/images/vgv_logo_fill.svg',
                    alt: 'Very Good Ventures',
                    attributes: {'width': '24', 'height': '24'},
                  ),
                ],
              ),
              a(
                href: 'https://github.com/VeryGoodOpenSource/very_good_workflows',
                target: Target.blank,
                classes: 'sidebar-link',
                [
                  img(
                    classes: 'sidebar-icon-light',
                    src: '/images/github.svg',
                    alt: 'GitHub',
                    attributes: {'width': '24', 'height': '24'},
                  ),
                  img(
                    classes: 'sidebar-icon-dark',
                    src: '/images/github_white.svg',
                    alt: 'GitHub',
                    attributes: {'width': '24', 'height': '24'},
                  ),
                ],
              ),
            ],
            items: [
              SidebarEntry(text: 'Overview', href: '/docs/overview'),
              SidebarEntry(
                text: 'Workflows',
                href: '/docs/workflows',
                autoChildren: true,
              ),
            ],
          ),
          footer: Component.fragment([
            const Breadcrumb(),
            const EditPageLink(),
            const PageNavigation(),
            const SiteFooter(),
          ]),
        ),
        const HomepageLayout(),
      ],
      theme: ContentTheme.raw(
        colors: [
          // Exact Docusaurus/Infima color values from site/src/css/custom.css.
          ColorToken('primary', Color('#2a48df'), dark: Color('#66fbd1')),
          ColorToken('background', Color('#fbfcff'), dark: Color('#020f30')),
          ColorToken('text', Color('#1c1e21'), dark: Color('#e3e3e3')),
          ColorToken('content-headings', Color('#1c1e21'), dark: Color('#ffffff')),
          ColorToken('content-lead', Color('#606770'), dark: Color('#a0a0a0')),
          ColorToken('content-links', Color('#2a48df'), dark: Color('#66fbd1')),
          ColorToken('content-bold', Color('#1c1e21'), dark: Color('#ffffff')),
          ColorToken('content-counters', Color('#606770'), dark: Color('#a0a0a0')),
          ColorToken('content-bullets', Color('#dadde1'), dark: Color('#444950')),
          ColorToken('content-hr', Color('#dadde1'), dark: Color('#444950')),
          ColorToken('content-quotes', Color('#606770'), dark: Color('#a0a0a0')),
          ColorToken(
            'content-quote-borders',
            Color('#2a48df'),
            dark: Color('#66fbd1'),
          ),
          ColorToken('content-captions', Color('#606770'), dark: Color('#a0a0a0')),
          ColorToken('content-kbd', Color('#1c1e21'), dark: Color('#ffffff')),
          ColorToken('content-kbd-shadows', Color('#1c1e21'), dark: Color('#ffffff')),
          ColorToken('content-code', Color('#1c1e21'), dark: Color('#ffffff')),
          ColorToken(
            'content-pre-code',
            Color('#393a34'),
            dark: Color('#e3e3e3'),
          ),
          ColorToken(
            'content-pre-bg',
            Color('#ffffff'),
            dark: Color('rgb(0 0 0 / 50%)'),
          ),
          ColorToken('content-th-borders', Color('#dadde1'), dark: Color('#444950')),
          ColorToken('content-td-borders', Color('#dadde1'), dark: Color('#444950')),
          // UI component tokens (non-content).
          ColorToken('navbar-bg', Color('#fbfcff'), dark: Color('#081842')),
          ColorToken(
            'primary-hover',
            Color('#1e38b0'),
            dark: Color('#44fac7'),
          ),
          ColorToken('border', Color('#dadde1'), dark: Color('#444950')),
          ColorToken(
            'secondary-text',
            Color('#606770'),
            dark: Color('#a0a0a0'),
          ),
          ColorToken('surface', Color('#ffffff'), dark: Color('#1e1e1e')),
          // Shared UI tokens (hover overlays, muted text, callout colors).
          ColorToken(
            'hover-overlay',
            Color('rgba(0, 0, 0, 0.05)'),
            dark: Color('rgba(255, 255, 255, 0.05)'),
          ),
          ColorToken('muted-text', Color('#444950'), dark: Color('#ebedf0')),
          // Callout / admonition tokens.
          ColorToken('callout-info-text', Color('#193c47')),
          ColorToken(
            'callout-info-bg',
            Color('#eef9fd'),
            dark: Color('rgba(84, 199, 236, 0.15)'),
          ),
          ColorToken('callout-info-border', Color('#54c7ec')),
          ColorToken('callout-warning-text', Color('#4d3800')),
          ColorToken(
            'callout-warning-bg',
            Color('#fff8e6'),
            dark: Color('rgba(230, 167, 0, 0.15)'),
          ),
          ColorToken('callout-warning-border', Color('#e6a700')),
          ColorToken('callout-error-text', Color('#4b1113')),
          ColorToken(
            'callout-error-bg',
            Color('#ffebec'),
            dark: Color('rgba(250, 82, 82, 0.15)'),
          ),
          ColorToken('callout-error-border', Color('#fa5252')),
          ColorToken('callout-success-text', Color('#003100')),
          ColorToken(
            'callout-success-bg',
            Color('#e6fce6'),
            dark: Color('rgba(0, 164, 0, 0.15)'),
          ),
          ColorToken('callout-success-border', Color('#00a400')),
        ],
        typography: ContentTypography.base,
        reset: true,
      ),
    ),
  );
}
