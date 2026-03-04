import 'package:jaspr/dom.dart';

/// Comprehensive site styles matching the original Docusaurus/Infima design.
///
/// This file provides ALL visual overrides in one place, replacing the scattered
/// CSS rules that were previously in `_fontStyles` in `site_footer.dart`.
///
/// Color reference (from `site/src/css/custom.css`):
///
/// | Variable              | Light     | Dark      |
/// |-----------------------|-----------|-----------|
/// | primary               | #2a48df   | #66fbd1   |
/// | primary-dark (hover)  | #1f3ccf   | #44fac7   |
/// | background            | #fbfcff   | #020f30   |
/// | navbar-bg             | #fbfcff   | #081842   |
/// | code-bg (inline dark) | —         | #081842   |

/// Global site styles injected into `<head>` via [Document.head].
List<StyleRule> get siteStyles => [
  // ───────────────────────────────────────────────────────────────────────
  // 1. FONT & BASE
  // ───────────────────────────────────────────────────────────────────────
  css(':root').styles(
    raw: {
      '--content-font':
          "'Poppins', ui-sans-serif, system-ui, sans-serif, "
          "'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', "
          "'Noto Color Emoji'",
      // Infima monospace font stack
      '--ifm-font-family-monospace':
          "SFMono-Regular, Menlo, Monaco, Consolas, 'Liberation Mono', "
          "'Courier New', monospace",
    },
  ),
  css('html, body').styles(
    raw: {
      'font-family': 'var(--content-font)',
      'line-height': '1.65',
    },
  ),

  // ───────────────────────────────────────────────────────────────────────
  // 2. TYPOGRAPHY OVERRIDES
  //    Match Docusaurus/Infima heading sizes and spacing exactly.
  //    jaspr_content's ContentTypography uses smaller headings (h1=2.25em,
  //    h2=1.5em) and different line-height (1.75). Override to match Infima.
  // ───────────────────────────────────────────────────────────────────────
  // Heading sizes: Infima uses h1=3rem, h2=2rem, h3=1.5rem, h4=1.25rem
  css('.content h1').styles(
    fontSize: 3.rem,
    fontWeight: FontWeight.w700,
    lineHeight: 1.25.em,
    raw: {'margin': '0 0 1.5625rem'},
  ),
  css('.content h2').styles(
    fontSize: 2.rem,
    fontWeight: FontWeight.w700,
    lineHeight: 1.5.em,
    raw: {'margin': '2.5rem 0 1.25rem'},
  ),
  css('.content h3').styles(
    fontSize: 1.5.rem,
    lineHeight: 1.5.em,
    raw: {'margin': '2rem 0 0.75rem'},
  ),
  css('.content h4').styles(
    fontSize: 1.25.rem,
    lineHeight: 1.5.em,
    raw: {'margin': '1.5rem 0 0.5rem'},
  ),
  // Content line-height: Infima uses 1.65 (not jaspr_content's 1.75)
  css('.content').styles(raw: {'line-height': '1.65'}),
  // Paragraphs: Docusaurus uses bottom-only margin (1.25rem); Jaspr default is top+bottom
  css('.content p').styles(raw: {'margin': '0 0 1.25rem'}),
  // Remove backtick pseudo-elements and quote marks (Docusaurus doesn't have these)
  css('.content code::before').styles(raw: {'content': 'none'}),
  css('.content code::after').styles(raw: {'content': 'none'}),
  css('.content blockquote p:first-of-type::before').styles(
    raw: {'content': 'none'},
  ),
  css('.content blockquote p:last-of-type::after').styles(
    raw: {'content': 'none'},
  ),
  // Inline code: light gray background, smaller font (matching Infima)
  // Use :not(pre) > code to avoid styling code inside pre blocks
  css('.content :not(pre) > code').styles(
    padding: Padding.only(
      top: 0.1.rem,
      right: 0.4.rem,
      bottom: 0.1.rem,
      left: 0.4.rem,
    ),
    radius: BorderRadius.circular(0.2.rem),
    fontSize: Unit.percent(95),
    raw: {
      'background-color': 'rgba(0, 0, 0, 0.06)',
      'font-family': 'var(--ifm-font-family-monospace)',
    },
  ),
  // Pre/code blocks: match Docusaurus sizing (15.2px font, 22px line-height)
  // Docusaurus: pre has no padding/margin, code has 16px padding.
  // Jaspr base: pre has padding+margin from ContentTypography. Override to match.
  css('.content pre').styles(
    padding: Padding.zero,
    fontSize: 0.95.rem,
    raw: {
      'font-family': 'var(--ifm-font-family-monospace)',
      'line-height': '1.45',
      'margin': '1.25rem 0',
    },
  ),
  css('.content pre code').styles(
    padding: Padding.all(1.rem),
    fontSize: Unit.percent(100),
    raw: {
      'font-family': 'var(--ifm-font-family-monospace)',
      'background': 'transparent',
      'border-radius': '0',
      'display': 'block',
      'line-height': 'inherit',
    },
  ),
  // Content links: primary color, no underline by default (matching original)
  css('.content a:not(.workflow-card)').styles(
    textDecoration: TextDecoration.none,
  ),
  css('.content a:not(.workflow-card):hover').styles(
    textDecoration: TextDecoration(line: TextDecorationLine.underline),
  ),
  // Blockquote: no italic, normal weight (matching Infima defaults)
  css('.content blockquote').styles(
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.normal,
  ),

  // ───────────────────────────────────────────────────────────────────────
  // 3. HEADER / NAVBAR
  //    Docusaurus navbar: 60px height (3.75rem), padding 8px 16px
  // ───────────────────────────────────────────────────────────────────────
  // Opaque header background for both modes
  css('.header-container').styles(backgroundColor: Color('#fbfcff')),
  css('[data-theme="dark"] .header-container').styles(
    backgroundColor: Color('#081842'),
  ),
  // Match Docusaurus navbar height: 60px with padding 0.5rem 1rem
  css('.header').styles(
    height: 3.75.rem,
    padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.5.rem),
  ),
  // Hide the title text in the header (original only shows the logo badge)
  css('.header-title > span').styles(display: Display.none),
  // Hide the duplicate title, description, and image rendered from frontmatter
  css('.content-header').styles(display: Display.none),
  // Larger logo badge in the header (matching Docusaurus 32px)
  css('.header .header-title img').styles(height: 2.rem),
  // Vertically center nav links with icons in the header
  css('.header .header-items').styles(alignItems: AlignItems.center),
  // Hamburger menu button: match Docusaurus 30×30 SVG (jaspr_content default is 20×20)
  css('.sidebar-toggle-button svg').styles(
    width: 30.px,
    height: 30.px,
  ),
  // Hide header nav items on narrow viewports
  css.media(MediaQuery.all(maxWidth: 1000.px), [
    css('.header .header-items').styles(display: Display.none),
  ]),

  // ───────────────────────────────────────────────────────────────────────
  // 4. DARK MODE ICON SWITCHING
  //    Show .icon-light in light mode, .icon-dark in dark mode.
  // ───────────────────────────────────────────────────────────────────────
  css('[data-theme="dark"] .icon-link .icon-light').styles(
    display: Display.none,
  ),
  css('[data-theme="dark"] .icon-link .icon-dark').styles(
    raw: {'display': 'flex !important'},
  ),

  // ───────────────────────────────────────────────────────────────────────
  // 5. DARK MODE "GET STARTED" BUTTON
  // ───────────────────────────────────────────────────────────────────────
  css('[data-theme="dark"] .nav-button').styles(
    color: Color('#020f30'),
    backgroundColor: Color('#66fbd1'),
  ),
  css('[data-theme="dark"] .nav-button:hover').styles(
    backgroundColor: Color('#44fac7'),
  ),
  // Nav links (e.g. "VGV Dev Tools"): lighter weight, slightly smaller
  css('.nav-link:not(.nav-button)').styles(
    fontSize: 0.975.rem,
    fontWeight: FontWeight.w400,
  ),
  // Dark mode: nav links should be white
  css('[data-theme="dark"] .nav-link:not(.nav-button)').styles(color: Colors.white),

  // ───────────────────────────────────────────────────────────────────────
  // 5b. DARK MODE BREADCRUMB
  // ───────────────────────────────────────────────────────────────────────
  css('[data-theme="dark"] .breadcrumb-current').styles(
    color: Color('#44fac7'),
  ),
  css('[data-theme="dark"] .breadcrumb-link').styles(
    color: Color('#a0a0a0'),
  ),
  css('[data-theme="dark"] .breadcrumb-link:hover').styles(
    color: Color('#44fac7'),
  ),
  css('[data-theme="dark"] .breadcrumb-sep').styles(
    color: Color('#a0a0a0'),
  ),

  // ───────────────────────────────────────────────────────────────────────
  // 6. THEME TOGGLE
  //    Reverse the icons: show current-mode icon instead of target-mode.
  //    Light mode: hide moon (first span), show sun (last span).
  //    Dark mode: show moon (first span), hide sun (last span).
  // ───────────────────────────────────────────────────────────────────────
  css('[data-theme="light"] .theme-toggle > span:first-child').styles(
    raw: {'display': 'none !important'},
  ),
  css('[data-theme="light"] .theme-toggle > span:last-child').styles(
    raw: {'display': 'inline !important'},
  ),
  css('[data-theme="dark"] .theme-toggle > span:first-child').styles(
    raw: {'display': 'inline !important'},
  ),
  css('[data-theme="dark"] .theme-toggle > span:last-child').styles(
    raw: {'display': 'none !important'},
  ),

  // ───────────────────────────────────────────────────────────────────────
  // 7. DOCS LAYOUT SPACING & BREADCRUMB
  //    Docusaurus: sticky navbar 60px + 16px gap = content at 76px.
  //    Jaspr default: fixed header 60px + main padding-top 4rem + div
  //    padding-top 2rem = 96px. Reduce to match Docusaurus.
  // ───────────────────────────────────────────────────────────────────────
  // Reduce main padding-top to exactly header height
  css('.docs .main-container main').styles(
    padding: Padding.only(top: 3.75.rem),
  ),
  // Reduce inner div padding to match Docusaurus 16px gap
  css('.docs .main-container main > div').styles(
    padding: Padding.only(top: 1.rem, left: 1.rem, right: 1.rem),
  ),
  // Breadcrumb: position above content using flexbox order
  css('.content-container').styles(
    display: Display.flex,
    flexDirection: FlexDirection.column,
  ),
  css('.content-footer').styles(raw: {'display': 'contents'}),
  css('.breadcrumb').styles(raw: {'order': '-1'}),
  // Override breadcrumb font-size to 16px (matching Docusaurus)
  css('.docs .breadcrumb').styles(fontSize: 1.rem),

  // ───────────────────────────────────────────────────────────────────────
  // 8. SIDEBAR — layout/sizing only.
  //    Link/hover/active styles live in CollapsibleSidebar.styles using
  //    var(--primary) (theme-aware). Width matches Docusaurus 300px.
  // ───────────────────────────────────────────────────────────────────────
  // Sidebar width: match Docusaurus 300px (--doc-sidebar-width)
  // Use high specificity to override DocsLayout's .docs .main-container .sidebar-container
  css('.docs .main-container .sidebar-container').styles(width: 300.px),
  css('.docs .sidebar').styles(width: 300.px),
  // Sidebar border-right: match Docusaurus 1px solid border
  css('.docs .sidebar-container').styles(
    border: Border.only(
      right: BorderSide(width: 1.px, color: Color('#dadde1')),
    ),
  ),
  css('[data-theme="dark"] .docs .sidebar-container').styles(
    border: Border.only(
      right: BorderSide(width: 1.px, color: Color('#444950')),
    ),
  ),
  // Adjust main padding-left to match wider sidebar (desktop only)
  css.media(MediaQuery.all(minWidth: 1024.px), [
    css('.docs .main-container main').styles(
      padding: Padding.only(left: 300.px),
    ),
  ]),

  // ───────────────────────────────────────────────────────────────────────
  // 9. CONTENT AREA LINKS
  //    Primary color, no underline; underline on hover (matching original).
  // ───────────────────────────────────────────────────────────────────────
  css('.content-container a:not(.breadcrumb-link):not(.workflow-card)').styles(
    color: Color('var(--content-links)'),
    textDecoration: TextDecoration.none,
  ),
  css('.content-container a:not(.breadcrumb-link):not(.workflow-card):hover').styles(
    textDecoration: TextDecoration(line: TextDecorationLine.underline),
  ),
  // Callout links: inherit foreground color + always underlined (Infima alert behavior).
  // Overrides the blue `.content-container a` rule above via cascade order.
  css('.content-container .doc-callout a').styles(
    color: Color.inherit,
    fontWeight: FontWeight.w400,
    textDecoration: TextDecoration(line: TextDecorationLine.underline),
  ),
  css('.content-container .doc-callout a:hover').styles(
    raw: {'text-decoration-thickness': '2px'},
  ),
  // Underline color matches the left border color per type.
  css('.content-container .doc-callout-info a').styles(
    raw: {'text-decoration-color': '#54c7ec'},
  ),
  css('.content-container .doc-callout-warning a').styles(
    raw: {'text-decoration-color': '#e6a700'},
  ),
  css('.content-container .doc-callout-error a').styles(
    raw: {'text-decoration-color': '#fa5252'},
  ),
  css('.content-container .doc-callout-success a').styles(
    raw: {'text-decoration-color': '#00a400'},
  ),

  // ───────────────────────────────────────────────────────────────────────
  // 10. DARK MODE: CODE BLOCKS & SCROLLBARS
  // ───────────────────────────────────────────────────────────────────────
  // Dark mode: all code (inline + blocks) uses navy background
  // Matches Docusaurus custom.css: html[data-theme='dark'] code { background: #081842 }
  css('[data-theme="dark"] code').styles(
    raw: {'background': '#081842 !important'},
  ),
  css('[data-theme="dark"]').styles(
    raw: {'scrollbar-color': '#ffffff30 transparent'},
  ),

  // ───────────────────────────────────────────────────────────────────────
  // 11. FOOTER & PAGE NAVIGATION SPACING
  //     Docusaurus: footer margin-top 64px, pagination margin-top 48px.
  // ───────────────────────────────────────────────────────────────────────
  css('.site-footer').styles(margin: Margin.only(top: 4.rem)),
  css('.page-nav').styles(
    padding: Padding.zero,
    margin: Margin.only(top: 3.rem),
  ),
  // Dark mode: page nav prev/next blocks
  css('[data-theme="dark"] .page-nav-prev, [data-theme="dark"] .page-nav-next')
      .styles(
    border: Border.all(color: Color('#444950'), width: 1.px),
  ),
  css('[data-theme="dark"] .page-nav-prev:hover, [data-theme="dark"] .page-nav-next:hover')
      .styles(
    border: Border.all(color: Color('#66fbd1'), width: 1.px),
  ),
  css('[data-theme="dark"] .page-nav-label').styles(
    color: Colors.white,
  ),
  css('[data-theme="dark"] .page-nav-title').styles(
    color: Color('#66fbd1'),
  ),

  // ───────────────────────────────────────────────────────────────────────
  // 12. TABLE OF CONTENTS & CONTENT WIDTH
  //     Docusaurus: 213px TOC, 12.8px font, 703px content width.
  //     Jaspr default: 272px TOC, extra padding → only 588px content.
  //     Fix TOC width and reduce padding to match Docusaurus layout.
  // ───────────────────────────────────────────────────────────────────────
  // TOC: hide "On this page" heading (Docusaurus doesn't show it)
  css('.docs .main-container main > div aside.toc h3').styles(
    display: Display.none,
  ),
  // Show TOC at >=1000px (DocsLayout default is 1280px)
  css.media(MediaQuery.all(minWidth: 1000.px), [
    css('.docs .main-container main > div aside.toc').styles(
      display: Display.block,
    ),
  ]),
  // TOC: match Docusaurus styling (left border, link colors, sub-item pills)
  css('.docs .main-container main > div aside.toc').styles(width: 213.px),
  css('.docs .main-container main > div aside.toc > div').styles(
    padding: Padding.only(left: 0.5.rem),
    border: Border.only(
      left: BorderSide(width: 1.px, color: Color('#dadde1')),
    ),
  ),
  css('.docs .main-container main > div aside.toc li').styles(
    fontSize: 12.8.px,
  ),
  // TOC links: gray by default, blue when active (matching Docusaurus)
  css('.toc a').styles(
    color: Color('#525860'),
    textDecoration: TextDecoration.none,
  ),
  css('.toc a:hover').styles(
    color: Color('#2a48df'),
  ),
  css('.toc a.toc-active').styles(
    color: Color('#2a48df'),
    fontWeight: FontWeight.w500,
  ),
  // TOC sub-items (h3+): rounded pill border (matching Docusaurus nested items)
  css('.toc li[style*="0.75"] a').styles(
    padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.125.rem),
    border: Border.all(color: Color('#dadde1'), width: 1.px),
    radius: BorderRadius.circular(12.px),
    fontSize: 11.px,
  ),
  // Dark mode TOC
  css('[data-theme="dark"] .docs .main-container main > div aside.toc > div').styles(
    border: Border.only(
      left: BorderSide(width: 1.px, color: Color('#444950')),
    ),
  ),
  css('[data-theme="dark"] .toc a').styles(
    color: Color('#a0a0a0'),
  ),
  css('[data-theme="dark"] .toc a:hover').styles(
    color: Color('#66fbd1'),
  ),
  css('[data-theme="dark"] .toc a.toc-active').styles(
    color: Color('#66fbd1'),
  ),
  css('[data-theme="dark"] .toc li[style*="0.75"] a').styles(
    border: Border.all(color: Color('#444950'), width: 1.px),
  ),
  // ───────────────────────────────────────────────────────────────────────
  // 12b. MOBILE TOC (collapsible "On this page" above content < 1000px)
  // ───────────────────────────────────────────────────────────────────────
  css('.mobile-toc', [
    css('&').styles(
      margin: Margin.only(bottom: 1.rem),
      radius: BorderRadius.circular(0.4.rem),
      raw: {
        'background': 'rgba(0, 0, 0, 0.05)',
      },
    ),
  ]),
  // Hide mobile TOC at wide viewports where sidebar TOC is visible
  css.media(MediaQuery.all(minWidth: 1000.px), [
    css('.mobile-toc').styles(display: Display.none),
  ]),
  css('.mobile-toc-toggle', [
    css('&').styles(
      display: Display.flex,
      width: Unit.percent(100),
      padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.75.rem),
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
      raw: {
        'transition': 'transform 0.2s ease',
      },
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
      padding: Padding.only(
        left: 1.rem,
        right: 1.rem,
        bottom: 0.75.rem,
      ),
      margin: Margin.zero,
      listStyle: ListStyle.none,
    ),
    css('li').styles(
      padding: Padding.symmetric(vertical: 0.25.rem),
    ),
  ]),
  // Mobile TOC links: use higher specificity to override .content-container a
  css('.mobile-toc .mobile-toc-content a').styles(
    color: Color('#1c1e21'),
    fontSize: 0.8125.rem,
    textDecoration: TextDecoration.none,
  ),
  css('.mobile-toc .mobile-toc-content a:hover').styles(
    color: Color('#2a48df'),
  ),
  css('.mobile-toc.expanded .mobile-toc-content').styles(
    raw: {'max-height': '500px'},
  ),
  // Dark mode mobile TOC
  css('[data-theme="dark"] .mobile-toc').styles(
    raw: {
      'background': 'rgba(255, 255, 255, 0.05)',
    },
  ),
  css('[data-theme="dark"] .mobile-toc .mobile-toc-content a').styles(
    color: Color('#e3e3e3'),
  ),
  css('[data-theme="dark"] .mobile-toc .mobile-toc-content a:hover').styles(
    color: Color('#66fbd1'),
  ),

  // Dark mode TOC: remove pill borders
  css('[data-theme="dark"] .toc li[style] a').styles(
    border: Border.none,
  ),

  // ───────────────────────────────────────────────────────────────────────
  // 13. WORKFLOW CARDS
  //     Docusaurus category page: 2-column card grid with icon, title,
  //     and truncated description. Matches /docs/category/workflows.
  // ───────────────────────────────────────────────────────────────────────
  css('.workflow-cards', [
    css('&').styles(
      display: Display.grid,
      gap: Gap(column: 1.rem, row: 1.rem),
      raw: {'grid-template-columns': '1fr', 'margin': '1.5rem 0'},
    ),
  ]),
  css.media(MediaQuery.all(minWidth: 1024.px), [
    css('.workflow-cards').styles(
      raw: {'grid-template-columns': 'repeat(2, 1fr)'},
    ),
  ]),
  css('.workflow-card', [
    css('&').styles(
      display: Display.block,
      padding: Padding.all(1.5.rem),
      radius: BorderRadius.circular(0.5.rem),
      textDecoration: TextDecoration.none,
      raw: {
        'border': '1px solid #dadde1',
        'background': '#ffffff',
        'color': 'inherit',
        'transition': 'border-color 0.2s ease',
      },
    ),
    css('&:hover').styles(
      textDecoration: TextDecoration.none,
      raw: {'border-color': '#2a48df'},
    ),
    css('h3').styles(
      margin: Margin.only(bottom: 0.25.rem),
      fontSize: 1.25.rem,
      fontWeight: FontWeight.w700,
      textDecoration: TextDecoration.none,
      raw: {'margin-top': '0'},
    ),
    css('p').styles(
      margin: Margin.zero,
      opacity: 0.6,
      overflow: Overflow.hidden,
      color: Color('#000000'),
      fontSize: 0.875.rem,
      textDecoration: TextDecoration.none,
      raw: {
        'display': '-webkit-box',
        '-webkit-line-clamp': '2',
        '-webkit-box-orient': 'vertical',
      },
    ),
  ]),
  // Dark mode workflow cards
  css('[data-theme="dark"] .workflow-card').styles(
    raw: {
      'background': '#1b2a4a',
      'border-color': '#444950',
    },
  ),
  css('[data-theme="dark"] .workflow-card p').styles(
    color: Color('#ffffff'),
  ),
  css('[data-theme="dark"] .workflow-card:hover').styles(
    raw: {'border-color': '#66fbd1'},
  ),

  // Remove main-container side padding at wide viewports
  css.media(MediaQuery.all(minWidth: 1280.px), [
    css('.docs .main-container').styles(
      padding: Padding.symmetric(horizontal: Unit.zero),
    ),
  ]),
  // Content-container right padding: 32px gap to TOC (matching Docusaurus)
  // Must use high-specificity selector to override jaspr_content's 3rem default
  css('.docs .main-container main > div .content-container').styles(
    padding: Padding.only(right: 2.rem),
  ),
];
