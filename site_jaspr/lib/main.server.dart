/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

// Server-specific Jaspr import.
import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'package:jaspr_content/components/callout.dart';
import 'package:jaspr_content/components/github_button.dart';
import 'package:jaspr_content/components/header.dart';
import 'package:jaspr_content/components/image.dart';
import 'package:jaspr_content/components/sidebar.dart';
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
        SafeCodeBlock(),
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
              IconLink(href: 'https://verygood.ventures', iconSrc: '/images/vgv_logo_black.svg', alt: 'Very Good Ventures'),
              GitHubButton(repo: 'VeryGoodOpenSource/very_good_workflows'),
              ThemeToggle(),
            ],
          ),
          sidebar: Sidebar(
            groups: [
              SidebarGroup(
                links: [
                  SidebarLink(text: 'Overview', href: '/docs/overview'),
                  SidebarLink(text: 'Workflows', href: '/docs/workflows'),
                ],
              ),
              SidebarGroup(
                title: 'Workflows',
                links: [
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
      theme: ContentTheme(
        primary: ThemeColor(Color('#2a48df'), dark: Color('#66fbd1')),
        background: ThemeColor(Colors.white, dark: Color('#020f30')),
        colors: [
          ContentColors.links.apply(ThemeColor(Color('#2a48df'), dark: Color('#66fbd1'))),
          ContentColors.quoteBorders.apply(Color('#2a48df')),
        ],
      ),
    ),
  );
}
