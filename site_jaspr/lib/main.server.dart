/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'package:jaspr_content/components/header.dart';
import 'package:jaspr_content/components/image.dart';
import 'package:jaspr_content/components/theme_toggle.dart';
import 'package:jaspr_content/jaspr_content.dart';

import 'package:very_good_jaspr/very_good_jaspr.dart';

// This file is generated automatically by Jaspr, do not remove or edit.
import 'main.server.options.dart';

void main() {
  Jaspr.initializeApp(options: defaultServerOptions);

  runApp(
    ContentApp(
      eagerlyLoadAllPages: true,
      templateEngine: MustacheTemplateEngine(),
      parsers: [MarkdownParser()],
      extensions: [
        HeadingAnchorsExtension(),
        TableOfContentsExtension(),
        CodeAwareTocPostProcessor(),
      ],
      components: [
        DocCallout(),
        CategoryCards(),
        SafeCodeBlock(
          grammars: {
            // Add grammar files as needed:
            // 'yaml': File('grammars/yaml.tmLanguage.json').readAsStringSync(),
            // 'bash': File('grammars/bash.tmLanguage.json').readAsStringSync(),
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
              NavLink(
                text: 'Get Started',
                href: '/docs/overview',
                isButton: true,
              ),
              const NavLink(
                text: 'VGV Dev Tools',
                href: 'https://verygood.ventures/dev',
              ),
              const IconLink(
                href: 'https://verygood.ventures',
                iconSrc: '/images/vgv_logo_black.svg',
                darkIconSrc: '/images/vgv_logo_fill.svg',
                alt: 'Very Good Ventures',
              ),
              const IconLink(
                href:
                    'https://github.com/VeryGoodOpenSource/very_good_workflows',
                iconSrc: '/images/github.svg',
                darkIconSrc: '/images/github_white.svg',
                alt: 'GitHub',
              ),
              ThemeToggle(),
            ],
          ),
          sidebar: CollapsibleSidebar(
            mobileNavItems: [
              a(href: '/docs/overview', classes: 'mobile-workflows-btn', [
                img(
                  src: '/images/workflows_nav_icon.svg',
                  alt: 'Very Good Workflows',
                  attributes: const {'height': '32', 'width': '32'},
                ),
              ]),
              ThemeToggle(),
            ],
            primaryNavItems: [
              a(href: '/docs/overview', classes: 'sidebar-link', [
                Component.text('Get Started'),
              ]),
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
                    attributes: const {'width': '24', 'height': '24'},
                  ),
                  img(
                    classes: 'sidebar-icon-dark',
                    src: '/images/vgv_logo_fill.svg',
                    alt: 'Very Good Ventures',
                    attributes: const {'width': '24', 'height': '24'},
                  ),
                ],
              ),
              a(
                href:
                    'https://github.com/VeryGoodOpenSource/very_good_workflows',
                target: Target.blank,
                classes: 'sidebar-link',
                [
                  img(
                    classes: 'sidebar-icon-light',
                    src: '/images/github.svg',
                    alt: 'GitHub',
                    attributes: const {'width': '24', 'height': '24'},
                  ),
                  img(
                    classes: 'sidebar-icon-dark',
                    src: '/images/github_white.svg',
                    alt: 'GitHub',
                    attributes: const {'width': '24', 'height': '24'},
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
            EditPageLink(
              editUrlBase:
                  'https://github.com/VeryGoodOpenSource/very_good_workflows/tree/main/site_jaspr/',
              excludePaths: const {'/'},
            ),
            const PageNavigation(),
            const SiteFooter(),
          ]),
        ),
        HomepageLayout(
          title: 'Very Good Workflows',
          logo: '/images/workflows_nav_icon.svg',
          heroLogoLight: '/images/workflows_logo.svg',
          heroLogoDark: '/images/workflows_logo_dark.svg',
          heroSubtitle:
              'A collection of helpful, reusable GitHub workflows used by VGV.',
          ctaHref: '/docs/overview',
          ctaLabel: 'Get Started',
          githubUrl:
              'https://github.com/VeryGoodOpenSource/very_good_workflows',
          heroImage: '/images/workflows_hero.png',
          blogSection: div(classes: 'homepage-blogs', [
            div(classes: 'homepage-blog-row', [
              div(classes: 'homepage-blog-image', [
                img(
                  src:
                      'https://uploads-ssl.webflow.com/5ee12d8e99cde2e20255c16c/61ef1d505cfdeb570f714a7f_Very%20good%20workflows.jpg',
                  alt: 'Configuring workflows for your Flutter projects',
                  attributes: const {'width': '452', 'height': '254'},
                ),
              ]),
              div(classes: 'homepage-blog-content', [
                h2([
                  Component.text(
                    'Configuring workflows for your Flutter projects',
                  ),
                ]),
                p([
                  Component.text(
                    'A guide for using Very Good Workflows in your projects.',
                  ),
                ]),
                a(
                  href:
                      'https://verygood.ventures/blog/configuring-workflows-for-your-flutter-projects',
                  classes: 'homepage-blog-link',
                  [Component.text('Read the Blog >')],
                ),
              ]),
            ]),
          ]),
        ),
      ],
      theme: VgvTheme.contentTheme,
    ),
  );
}
