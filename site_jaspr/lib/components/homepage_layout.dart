import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/header.dart';
import 'package:jaspr_content/jaspr_content.dart';

import 'icon_link.dart';
import 'nav_link.dart';
import 'site_footer.dart';
import 'theme_toggle.dart';

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
      // data-has-sidebar makes the SidebarToggleButton (hamburger) visible
      // at narrow viewports — it's part of the Header's leading slot.
      div(
        classes: 'header-container',
        attributes: {'data-has-sidebar': ''},
        [
          Header(
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
        ],
      ),
      // Mobile sidebar backdrop — must immediately precede .sidebar-container
      // for the :has(+ .sidebar-container.open) CSS selector to work.
      div(classes: 'sidebar-barrier', attributes: {'role': 'button'}, []),
      // Mobile sidebar panel — same primary nav as the docs sidebar's primary
      // panel (Get Started, VGV Dev Tools, VGV icon, GitHub icon).
      // SidebarToggleButton (in the Header) toggles .open on this container.
      div(classes: 'sidebar-container', [
        nav(classes: 'sidebar', [
          // Mobile header: logo pill + ThemeToggle + close ×
          div(classes: 'sidebar-mobile-header', [
            div(classes: 'sidebar-mobile-nav', [
              a(
                href: '/',
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
            ]),
            button(
              classes: 'sidebar-close',
              attributes: {'type': 'button', 'aria-label': 'Close menu'},
              [
                svg(
                  viewBox: '0 0 24 24',
                  attributes: {
                    'width': '20',
                    'height': '20',
                    'fill': 'none',
                    'stroke': 'currentColor',
                    'stroke-width': '2',
                  },
                  [
                    line(
                      attributes: {'x1': '18', 'y1': '6', 'x2': '6', 'y2': '18'},
                      [],
                    ),
                    line(
                      attributes: {'x1': '6', 'y1': '6', 'x2': '18', 'y2': '18'},
                      [],
                    ),
                  ],
                ),
              ],
            ),
          ]),
          // Primary nav items as sidebar-style links
          div(classes: 'sidebar-home-nav', [
            ul([
              li([
                a(
                  href: '/docs/overview',
                  classes: 'sidebar-primary-link',
                  [Component.text('Get Started')],
                ),
              ]),
              li([
                a(
                  href: 'https://verygood.ventures/dev',
                  target: Target.blank,
                  classes: 'sidebar-primary-link',
                  [Component.text('VGV Dev Tools')],
                ),
              ]),
              li([
                a(
                  href: 'https://verygood.ventures',
                  target: Target.blank,
                  classes: 'sidebar-primary-link',
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
              ]),
              li([
                a(
                  href: 'https://github.com/VeryGoodOpenSource/very_good_workflows',
                  target: Target.blank,
                  classes: 'sidebar-primary-link',
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
              ]),
            ]),
          ]),
        ]),
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
                  href: 'https://verygood.ventures/blog/configuring-workflows-for-your-flutter-projects',
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
          backgroundColor: Color('var(--navbar-bg)'),
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
        css('&').styles(
          width: 400.px,
          margin: Margin.only(bottom: 1.rem),
        ),
      ]),
      // Theme-aware logo switching
      css('.hero-logo-dark').styles(display: Display.none),
      css('.hero-subtitle', [
        css('&').styles(
          margin: Margin.only(bottom: 1.25.rem),
          color: Color('var(--muted-text)'),
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
          backgroundColor: Color('var(--primary)'),
        ),
        css('&:hover').styles(backgroundColor: Color('var(--primary-hover)')),
      ]),
      // Blog section
      css('.blog-section', [
        css('&').styles(
          display: Display.flex,
          padding: Padding.only(top: 4.rem, bottom: 6.5.rem, left: 3.rem, right: 3.rem),
          flexDirection: FlexDirection.column,
          alignItems: AlignItems.center,
          gap: Gap(row: 0.5.rem),
        ),
        css.media(MediaQuery.all(maxWidth: 996.px), [
          css('&').styles(
            padding: Padding.symmetric(horizontal: 1.rem, vertical: 2.rem),
          ),
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
          css('&').styles(
            flexDirection: FlexDirection.column,
            gap: Gap(column: 1.rem, row: 1.rem),
          ),
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
          gap: Gap(row: 1.rem),
          lineHeight: 1.5.rem,
        ),
        css('h2').styles(
          color: Color('var(--text)'),
          fontSize: 1.5.rem,
          fontWeight: FontWeight.w600,
          lineHeight: 2.rem,
        ),
        css('p').styles(color: Color('var(--text)')),
      ]),
      css('.blog-link', [
        css('&').styles(
          margin: Margin.only(top: 0.3.rem),
          color: Color('var(--primary)'),
          fontWeight: FontWeight.bold,
          textDecoration: TextDecoration.none,
        ),
        css('&:hover').styles(textDecoration: TextDecoration(line: TextDecorationLine.underline)),
      ]),
    ]),
    // Hide the empty content section rendered by the Content component
    css('.homepage .content').styles(display: Display.none),
    // Dark mode: swap hero logos
    css('[data-theme="dark"] .hero-logo-light').styles(display: Display.none),
    css('[data-theme="dark"] .hero-logo-dark').styles(
      raw: {'display': 'block !important'},
    ),
    // Dark mode: CTA button text (bg handled by --primary token)
    css('[data-theme="dark"] .cta-button').styles(
      color: Color('var(--background)'),
    ),

    // ── Home page mobile sidebar ─────────────────────────────────────────────
    // The SidebarToggleButton in the Header toggles .open on .sidebar-container.
    // The barrier uses :has(+ .sidebar-container.open) to show the scrim.
    css('.homepage .sidebar-container').styles(
      position: Position.fixed(top: Unit.zero, bottom: Unit.zero),
      zIndex: ZIndex(200),
      overflow: Overflow.only(y: Overflow.auto),
      raw: {
        'width': '83vw',
        'transform': 'translateX(-100%)',
        'transition': 'transform 150ms ease-in-out',
        'background-color': 'var(--navbar-bg)',
      },
    ),
    css('.homepage .sidebar-container.open').styles(
      raw: {'transform': 'translateX(0)'},
    ),
    css('.homepage .sidebar-barrier').styles(
      position: Position.fixed(),
      zIndex: ZIndex(199),
      opacity: 0,
      pointerEvents: PointerEvents.none,
      raw: {'inset': '0', 'background': '#000'},
    ),
    css('.homepage .sidebar-barrier:has(+ .sidebar-container.open)').styles(
      opacity: 0.5,
      pointerEvents: PointerEvents.auto,
    ),
    // Home sidebar nav: reuse CollapsibleSidebar's sidebar-mobile-header layout.
    // The .sidebar-mobile-header, .sidebar-mobile-nav, .sidebar-close styles
    // are injected by CollapsibleSidebar on docs pages, so duplicate them here.
    css('.homepage .sidebar .sidebar-mobile-header').styles(
      display: Display.flex,
      padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.5.rem),
      alignItems: AlignItems.center,
      raw: {'flex-shrink': '0'},
    ),
    css('.homepage .sidebar .sidebar-mobile-nav').styles(
      display: Display.flex,
      alignItems: AlignItems.center,
      gap: Gap.column(0.25.rem),
      flex: Flex(grow: 1),
      raw: {'flex-wrap': 'wrap'},
    ),
    css('.homepage .sidebar .sidebar-close').styles(
      display: Display.flex,
      width: 2.rem,
      height: 2.rem,
      radius: BorderRadius.circular(0.25.rem),
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
      color: Color.inherit,
      raw: {
        'flex-shrink': '0',
        'border': 'none',
        'background': 'none',
        'cursor': 'pointer',
        'opacity': '0.6',
        'transition': 'opacity 0.15s ease, background 0.15s ease',
      },
    ),
    css('.homepage .sidebar .sidebar-close:hover').styles(
      opacity: 0.9,
      backgroundColor: Color('var(--hover-overlay)'),
    ),
    // Home sidebar nav items: .sidebar-home-nav ul/li + .sidebar-primary-link
    css('.homepage .sidebar-home-nav').styles(
      padding: Padding.only(top: 1.5.rem, right: 0.75.rem),
    ),
    css('.homepage .sidebar-home-nav ul').styles(
      padding: Padding.zero,
      margin: Margin.zero,
      listStyle: ListStyle.none,
    ),
    css('.homepage .sidebar-home-nav li').styles(margin: Margin.only(bottom: 2.px)),
    // Sidebar-style link for home primary panel items
    css('.sidebar-primary-link').styles(
      display: Display.flex,
      padding: Padding.symmetric(horizontal: 0.75.rem, vertical: 0.375.rem),
      radius: BorderRadius.circular(0.25.rem),
      alignItems: AlignItems.center,
      color: Color.inherit,
      fontWeight: FontWeight.w400,
      textDecoration: TextDecoration.none,
      raw: {
        'line-height': '1.25',
        'transition': 'background 0.15s ease-in-out',
      },
    ),
    css('.sidebar-primary-link:hover').styles(
      backgroundColor: Color('var(--hover-overlay)'),
    ),
  ];
}
