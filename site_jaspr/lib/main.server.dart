/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

import 'dart:io';

// Server-specific Jaspr import.
import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'package:jaspr_content/components/callout.dart';
import 'package:jaspr_content/components/header.dart';
import 'package:jaspr_content/components/image.dart';
import 'package:jaspr_content/components/sidebar.dart';

import 'components/collapsible_sidebar.dart';
import 'package:jaspr_content/components/theme_toggle.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';

import 'components/breadcrumb.dart';
import 'components/homepage_layout.dart';
import 'components/icon_link.dart';
import 'components/nav_link.dart';
import 'components/page_navigation.dart';
import 'components/safe_code_block.dart';
import 'components/site_footer.dart';

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
      templateEngine: MustacheTemplateEngine(),
      parsers: [
        MarkdownParser(),
      ],
      extensions: [
        HeadingAnchorsExtension(),
        TableOfContentsExtension(),
      ],
      components: [
        Callout(),
        SafeCodeBlock(
          grammars: {
            'yaml': File('grammars/yaml.tmLanguage.json').readAsStringSync(),
            'bash': File('grammars/bash.tmLanguage.json').readAsStringSync(),
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
              IconLink(href: 'https://verygood.ventures', iconSrc: '/images/vgv_logo_black.svg', darkIconSrc: '/images/vgv_logo_fill.svg', alt: 'Very Good Ventures'),
              IconLink(href: 'https://github.com/VeryGoodOpenSource/very_good_workflows', iconSrc: '/images/github.svg', darkIconSrc: '/images/github_white.svg', alt: 'GitHub'),
              ThemeToggle(),
            ],
          ),
          sidebar: CollapsibleSidebar(
            items: [
              SidebarEntry(text: 'Overview', href: '/docs/overview'),
              SidebarEntry(
                text: 'Workflows',
                href: '/docs/workflows',
                children: [
                  SidebarLink(text: 'Dart Package', href: '/docs/workflows/dart_package'),
                  SidebarLink(text: 'Dart Pub Publish', href: '/docs/workflows/dart_pub_publish'),
                  SidebarLink(text: 'Flutter Package', href: '/docs/workflows/flutter_package'),
                  SidebarLink(text: 'Flutter Pub Publish', href: '/docs/workflows/flutter_pub_publish'),
                  SidebarLink(text: 'License Check', href: '/docs/workflows/license_check'),
                  SidebarLink(text: 'Mason Publish', href: '/docs/workflows/mason_publish'),
                  SidebarLink(text: 'Pana', href: '/docs/workflows/pana'),
                  SidebarLink(text: 'Semantic Pull Request', href: '/docs/workflows/semantic_pull_request'),
                  SidebarLink(text: 'Spell Check', href: '/docs/workflows/spell_check'),
                ],
              ),
            ],
          ),
          footer: Component.fragment([const Breadcrumb(), const PageNavigation(), const SiteFooter()]),
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
        ],
        typography: ContentTypography.base,
        reset: true,
      ),
    ),
  );
}
