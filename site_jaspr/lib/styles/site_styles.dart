import 'package:jaspr/dom.dart';

/// Global site styles injected into `<head>` via `SiteFooter`.
///
/// Contains only brand-level and framework-integration rules that are not
/// owned by any single component:
///   - Brand font (Poppins) activation
///   - Header background (jaspr_content default is transparent)
///   - Content-header suppression (frontmatter title/description/image)
///   - Mobile TOC (JS-injected element with no component class of its own)
List<StyleRule> get siteStyles => [
  // ── Brand font ──────────────────────────────────────────────────────────────
  // Poppins is the VGV brand font. The Google Font <link> is in SiteFooter.
  // --content-font activates it; line-height matches Infima's 1.65 default.
  css(':root').styles(
    raw: {
      '--content-font':
          "'Poppins', ui-sans-serif, system-ui, sans-serif, "
          "'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', "
          "'Noto Color Emoji'",
    },
  ),
  css('html, body').styles(
    raw: {
      'font-family': 'var(--content-font)',
      'line-height': '1.65',
    },
  ),

  // ── Content header ──────────────────────────────────────────────────────────
  // jaspr_content renders frontmatter (title, description, image) as a
  // .content-header block above each page's content. Hide it — the sidebar
  // and breadcrumb already provide navigation context.
  css('.content-header').styles(display: Display.none),

  // ── Header background ───────────────────────────────────────────────────────
  // jaspr_content's header is transparent by default; apply the brand navbar
  // color so it is always opaque in both light and dark modes.
  css('.header-container').styles(
    backgroundColor: Color('var(--navbar-bg)'),
  ),

  // ── Mobile navbar collapse ──────────────────────────────────────────────────
  // jaspr_content shows the hamburger (.sidebar-toggle-button) at ≤ 1024 px.
  // We override that to ≤ 996 px (matching the Docusaurus breakpoint) and hide
  // the nav-items row (.header-content) at the same threshold, so the header
  // shows only the logo + hamburger on narrow viewports.
  css('.sidebar-toggle-button').styles(raw: {'display': 'none'}),
  css.media(MediaQuery.all(maxWidth: 996.px), [
    css('.sidebar-toggle-button').styles(raw: {'display': 'flex'}),
    // Match jaspr_content's two-class specificity (.header .header-content)
    // so this rule wins at equal cascade position.
    css('.header .header-content').styles(display: Display.none),
  ]),

  // ── Mobile TOC ──────────────────────────────────────────────────────────────
  // The mobile TOC is a JS-injected DOM element (see SiteFooter._mobileToc).
  // Its CSS lives here because there is no component class to attach @css to.
  css('.mobile-toc', [
    css('&').styles(
      margin: Margin.only(bottom: 1.rem),
      radius: BorderRadius.circular(0.4.rem),
      raw: {'background': 'var(--hover-overlay)'},
    ),
  ]),
  // Hide mobile TOC at wide viewports where the sidebar TOC is visible.
  css.media(MediaQuery.all(minWidth: 1000.px), [
    css('.mobile-toc').styles(display: Display.none),
  ]),
  css('.mobile-toc-toggle', [
    css('&').styles(
      display: Display.flex,
      width: Unit.percent(100),
      padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.5.rem),
      cursor: Cursor.pointer,
      fontSize: 0.875.rem,
      fontWeight: FontWeight.w700,
      raw: {
        'align-items': 'center',
        'justify-content': 'space-between',
        'background': 'none',
        'border': 'none',
        'color': 'inherit',
        'font-family': 'inherit',
      },
    ),
    css('svg').styles(
      opacity: 0.5,
      raw: {'transition': 'transform 0.2s ease'},
    ),
  ]),
  css('.mobile-toc.expanded .mobile-toc-toggle svg').styles(
    raw: {'transform': 'rotate(180deg)'},
  ),
  css('.mobile-toc-content', [
    css('&').styles(
      overflow: Overflow.hidden,
      raw: {
        'max-height': '0',
        'transition': 'max-height 0.3s ease',
      },
    ),
    css('ul').styles(
      padding: Padding.only(left: 1.rem, right: 1.rem, bottom: 0.75.rem),
      margin: Margin.zero,
      listStyle: ListStyle.none,
    ),
    css('li').styles(padding: Padding.symmetric(vertical: 0.25.rem)),
  ]),
  css('.mobile-toc .mobile-toc-content a code').styles(
    padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.125.rem),
    border: Border.all(color: Color('var(--border)'), width: 1.px),
    radius: BorderRadius.circular(12.px),
    fontSize: 11.px,
    raw: {'font-family': 'inherit'},
  ),
  css('.mobile-toc .mobile-toc-content a').styles(
    color: Color('var(--text)'),
    fontSize: 0.8125.rem,
    textDecoration: TextDecoration.none,
  ),
  css('.mobile-toc .mobile-toc-content a:hover').styles(
    color: Color('var(--primary)'),
  ),
  css('.mobile-toc.expanded .mobile-toc-content').styles(
    raw: {'max-height': '500px'},
  ),
];
