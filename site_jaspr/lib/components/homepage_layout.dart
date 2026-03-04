import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/header.dart';
import 'package:jaspr_content/components/theme_toggle.dart';
import 'package:jaspr_content/jaspr_content.dart';

import 'icon_link.dart';
import 'nav_link.dart';
import 'site_footer.dart';

/// A custom page layout for the homepage.
class HomepageLayout extends PageLayoutBase {
  const HomepageLayout();

  @override
  String get name => 'homepage';

  @override
  Iterable<Component> buildHead(Page page) sync* {
    yield* super.buildHead(page);
    yield Style(styles: _styles);
  }

  @override
  Component buildBody(Page page, Component child) {
    return div(classes: 'homepage', [
      div(classes: 'header-container', [
        Header(
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
      ]),
      header(classes: 'hero-banner', [
        div(classes: 'hero-content', [
          img(
            classes: 'hero-logo hero-logo-light',
            src: '/images/workflows_logo.svg',
            alt: 'Very Good Workflows Logo',
          ),
          img(
            classes: 'hero-logo hero-logo-dark',
            src: '/images/workflows_logo_dark.svg',
            alt: 'Very Good Workflows Logo',
          ),
          p(
            classes: 'hero-subtitle',
            [
              Component.text(
                'A collection of helpful, reusable GitHub workflows used by VGV.',
              ),
            ],
          ),
          img(
            classes: 'hero-image',
            src: '/images/workflows_hero.png',
            alt: 'Very Good Workflows Hero',
            attributes: {'width': '720'},
          ),
          div(classes: 'cta', [
            a(
              classes: 'cta-button',
              href: '/docs/overview',
              [Component.text('Get Started >')],
            ),
          ]),
        ]),
      ]),
      child,
      main_([
        div(classes: 'blog-section', [
          div(classes: 'blog-row', [
            div(classes: 'blog-column', [
              img(
                src:
                    'https://uploads-ssl.webflow.com/5ee12d8e99cde2e20255c16c/61ef1d505cfdeb570f714a7f_Very%20good%20workflows.jpg',
                alt: 'Configuring workflows for your Flutter projects',
                attributes: {'width': '452', 'height': '254'},
              ),
            ]),
            div(classes: 'blog-column', [
              div(classes: 'blog-content', [
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
                  classes: 'blog-link',
                  href:
                      'https://verygood.ventures/blog/configuring-workflows-for-your-flutter-projects',
                  [Component.text('Read the Blog >')],
                ),
              ]),
            ]),
          ]),
        ]),
      ]),
      const SiteFooter(),
    ]);
  }

  // Field order from Styles: display, position, zIndex, width, height,
  // minWidth, minHeight, maxWidth, maxHeight, padding, margin, border, radius,
  // opacity, ..., flexDirection, justifyContent, alignItems, gap, flex, color,
  // textAlign, fontSize, fontWeight, textDecoration, lineHeight, backgroundColor, raw
  static List<StyleRule> get _styles => [
    css('.homepage', [
      css('&').styles(minHeight: 100.vh),
      css('.header-container', [
        css('&').styles(
          position: Position.fixed(top: Unit.zero, left: Unit.zero, right: Unit.zero),
          zIndex: ZIndex(10),
          backgroundColor: Colors.white,
        ),
      ]),

      // Hero banner
      css('.hero-banner', [
        css('&').styles(
          padding: Padding.only(top: 8.rem, bottom: 4.rem, left: 2.rem, right: 2.rem),
          textAlign: TextAlign.center,
          backgroundColor: Color('var(--background)'),
        ),
        css.media(MediaQuery.all(maxWidth: 996.px), [
          css('&').styles(
            padding: Padding.only(top: 6.rem, right: 2.rem, bottom: 2.rem, left: 2.rem),
          ),
        ]),
      ]),
      css('.hero-content', [
        css('&').styles(
          display: Display.flex,
          flexDirection: FlexDirection.column,
          alignItems: AlignItems.center,
        ),
      ]),
      css('.hero-logo', [
        css('&').styles(width: 400.px, margin: Margin.only(bottom: 1.rem)),
      ]),
      // Theme-aware logo switching
      css('.hero-logo-dark').styles(display: Display.none),
      css('.hero-subtitle', [
        css('&').styles(
          margin: Margin.only(bottom: 1.25.rem),
          color: Color('#444950'),
          fontSize: 1.5.rem,
        ),
      ]),
      css('.hero-image', [
        css('&').styles(
          height: Unit.auto,
          maxWidth: 100.percent,
          margin: Margin.symmetric(vertical: 1.rem),
        ),
      ]),

      // CTA button
      css('.cta', [
        css('&').styles(
          display: Display.flex,
          justifyContent: JustifyContent.center,
          alignItems: AlignItems.center,
          gap: Gap(column: 2.rem),
        ),
      ]),
      css('.cta-button', [
        css('&').styles(
          display: Display.inlineBlock,
          padding: Padding.symmetric(horizontal: 2.rem, vertical: 0.5.rem),
          radius: BorderRadius.circular(0.4.rem),
          color: Colors.white,
          fontSize: 1.2.rem,
          fontWeight: FontWeight.w700,
          textDecoration: TextDecoration.none,
          backgroundColor: Color('#2a48df'),
        ),
        css('&:hover').styles(backgroundColor: Color('#1e38b0')),
      ]),
      // Blog section
      css('.blog-section', [
        css('&').styles(
          display: Display.flex,
          padding: Padding.symmetric(horizontal: 3.rem, vertical: 4.rem),
          flexDirection: FlexDirection.column,
          alignItems: AlignItems.center,
          gap: Gap(row: 0.5.rem),
        ),
        css.media(MediaQuery.all(maxWidth: 996.px), [
          css('&').styles(padding: Padding.symmetric(horizontal: 1.rem, vertical: 2.rem)),
        ]),
      ]),
      css('.blog-row', [
        css('&').styles(
          display: Display.flex,
          flexDirection: FlexDirection.row,
          justifyContent: JustifyContent.center,
          alignItems: AlignItems.center,
          gap: Gap(column: 2.rem, row: 2.rem),
        ),
        css.media(MediaQuery.all(maxWidth: 996.px), [
          css('&').styles(flexDirection: FlexDirection.column, gap: Gap(column: 1.rem, row: 1.rem)),
        ]),
      ]),
      css('.blog-column', [
        css('&').styles(
          display: Display.flex,
          maxWidth: 452.px,
          flexDirection: FlexDirection.column,
          alignItems: AlignItems.center,
          gap: Gap(row: 1.rem),
        ),
        css('img').styles(height: Unit.auto, maxWidth: 100.percent, radius: BorderRadius.circular(8.px)),
      ]),
      css('.blog-content', [
        css('&').styles(
          display: Display.flex,
          flexDirection: FlexDirection.column,
          alignItems: AlignItems.start,
          gap: Gap(row: 0.75.rem),
          lineHeight: 1.5.rem,
        ),
        css('h2').styles(
          color: Color('#1c1e21'),
          fontSize: 1.5.rem,
          fontWeight: FontWeight.w600,
        ),
        css('p').styles(color: Color('#1c1e21')),
      ]),
      css('.blog-link', [
        css('&').styles(
          color: Color('#2a48df'),
          fontWeight: FontWeight.bold,
          textDecoration: TextDecoration.none,
        ),
        css('&:hover').styles(textDecoration: TextDecoration(line: TextDecorationLine.underline)),
      ]),
    ]),
    // Opaque header in dark mode for homepage
    css('[data-theme="dark"] .homepage .header-container').styles(
      backgroundColor: Color('#081842'),
    ),
    // Hide the empty content section rendered by the Content component
    css('.homepage .content').styles(display: Display.none),
    // Dark mode: swap hero logos
    css('[data-theme="dark"] .hero-logo-light').styles(display: Display.none),
    css('[data-theme="dark"] .hero-logo-dark').styles(
      raw: {'display': 'block !important'},
    ),
    // Dark mode: CTA button
    css('[data-theme="dark"] .cta-button').styles(
      color: Color('#020f30'),
      backgroundColor: Color('#66fbd1'),
    ),
    css('[data-theme="dark"] .cta-button:hover').styles(
      backgroundColor: Color('#4de0b8'),
    ),
    // Dark mode: blog section text colors
    css('[data-theme="dark"] .blog-content h2').styles(color: Color('#e3e3e3')),
    css('[data-theme="dark"] .blog-content p').styles(color: Color('#e3e3e3')),
    css('[data-theme="dark"] .blog-link').styles(color: Color('#66fbd1')),
    css('[data-theme="dark"] .hero-subtitle').styles(color: Colors.white),
  ];
}
