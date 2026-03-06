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
      // Color tokens (hover-overlay, muted-text, callout-*) are defined as
      // ColorToken entries in main.server.dart so that dark mode values update
      // dynamically with the theme toggle.
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
    raw: {'margin': '2.5rem 0 1.25rem', 'line-height': '1.25'},
  ),
  css('.content h3').styles(
    fontSize: 1.5.rem,
    fontWeight: FontWeight.w700,
    raw: {'margin': '1.875rem 0 1.25rem', 'line-height': '1.25'},
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
  // Lists: match Docusaurus/Infima spacing (bottom-only margin, left padding)
  css('.content ul, .content ol').styles(
    margin: Margin.only(top: Unit.zero, bottom: 1.25.rem),
    raw: {'padding-left': '2rem'},
  ),
  css('.content li').styles(
    padding: Padding.zero,
    margin: Margin.zero,
  ),
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
    padding: Padding.all(0.1.rem),
    border: Border.all(color: Color('rgba(0, 0, 0, 0.1)'), width: 1.px),
    radius: BorderRadius.circular(0.4.rem),
    fontSize: Unit.percent(95),
    raw: {
      'background-color': '#f6f7f8',
      'font-family': 'var(--ifm-font-family-monospace)',
      'font-weight': 'inherit',
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
      'margin': '0 0 1.25rem',
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
  // Code block copy button: match Docusaurus style.
  // Framework sets opacity:0 and position:absolute AFTER our styles,
  // so we use !important to override.
  css('.code-block button').styles(
    display: Display.flex,
    padding: Padding.all(0.25.rem),
    border: Border.all(color: Color('var(--border)'), width: 1.px),
    radius: BorderRadius.circular(0.4.rem),
    justifyContent: JustifyContent.center,
    alignItems: AlignItems.center,
    backgroundColor: Color('var(--surface)'),
    raw: {
      'position': 'absolute !important',
      'top': '0.5rem',
      'right': '0.5rem',
      'width': 'auto !important',
      'height': 'auto !important',
      'opacity': '0 !important',
      'color': 'var(--secondary-text) !important',
      'cursor': 'pointer',
      'transition': 'opacity 0.2s, color 0.2s',
    },
  ),
  css('.code-block button svg').styles(
    raw: {'width': '18px !important', 'height': '18px !important'},
  ),
  css('.code-block:hover button').styles(
    raw: {'opacity': '0.5 !important'},
  ),
  css('.code-block button:hover').styles(
    raw: {'opacity': '1 !important', 'color': 'var(--text) !important'},
  ),
  // Green check icon after successful copy (CheckIcon has no <rect>, CopyIcon does).
  // Needs both light and dark mode rules to beat specificity of dark hover rule.
  css('.code-block button:not(:has(svg rect))').styles(
    raw: {'color': '#00a86b !important', 'opacity': '1 !important'},
  ),
  css('.code-block button:not(:has(svg rect)):hover').styles(
    raw: {'color': '#00a86b !important'},
  ),
  css('[data-theme="dark"] .code-block button:not(:has(svg rect))').styles(
    raw: {'color': '#00a86b !important', 'opacity': '1 !important'},
  ),
  css('[data-theme="dark"] .code-block button:not(:has(svg rect)):hover').styles(
    raw: {'color': '#00a86b !important'},
  ),
  // Content links: primary color, no underline by default (matching original)
  css('.content a:not(.workflow-card):not(.page-nav-prev):not(.page-nav-next)').styles(
    textDecoration: TextDecoration.none,
  ),
  css('.content a:not(.workflow-card):not(.page-nav-prev):not(.page-nav-next):hover').styles(
    textDecoration: TextDecoration(line: TextDecorationLine.underline),
  ),
  // Heading anchors: bold '#' to match Docusaurus hash-link styling
  css('.content :is(h1, h2, h3, h4, h5, h6)[anchor="true"] > a').styles(
    fontWeight: FontWeight.w700,
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
  css('.docs .header-container').styles(
    backgroundColor: Color('var(--navbar-bg)'),
    raw: {'z-index': '20'},
  ),
  // Match Docusaurus navbar: 60px height, box-shadow (not border-bottom)
  css('.header').styles(
    height: 3.75.rem,
    padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.5.rem),
    border: Border.none,
    raw: {'box-shadow': 'rgba(0, 0, 0, 0.1) 0px 1px 2px 0px'},
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
  //    .sidebar-icon-* are used in sidebar primary-panel icon links.
  // ───────────────────────────────────────────────────────────────────────
  css('[data-theme="dark"] .icon-link .icon-light').styles(
    display: Display.none,
  ),
  css('[data-theme="dark"] .icon-link .icon-dark').styles(
    raw: {'display': 'flex !important'},
  ),
  // Sidebar primary-panel icon switching (sidebar-icon-light / sidebar-icon-dark)
  css('.sidebar-icon-dark').styles(display: Display.none),
  css('[data-theme="dark"] .sidebar-icon-light').styles(display: Display.none),
  css('[data-theme="dark"] .sidebar-icon-dark').styles(
    raw: {'display': 'inline !important'},
  ),

  // ───────────────────────────────────────────────────────────────────────
  // 5. DARK MODE "GET STARTED" BUTTON
  // ───────────────────────────────────────────────────────────────────────
  css('[data-theme="dark"] .nav-button').styles(
    color: Color('var(--background)'),
  ),
  // Nav links (e.g. "VGV Dev Tools"): lighter weight, slightly smaller
  css('.nav-link:not(.nav-button)').styles(
    fontSize: 0.975.rem,
    fontWeight: FontWeight.w400,
  ),
  // Dark mode: nav links should be white
  css('[data-theme="dark"] .nav-link:not(.nav-button)').styles(color: Colors.white),
  // Dark mode mobile: "Get Started" becomes a plain transparent link, matching
  // Docusaurus custom.css html[data-theme='dark'] @media (max-width:996px) rule.
  css.media(MediaQuery.all(maxWidth: 996.px), [
    css('[data-theme="dark"] .nav-button').styles(
      raw: {'background-color': 'transparent', 'color': '#ffffff'},
    ),
  ]),

  // ───────────────────────────────────────────────────────────────────────
  // 5b. BREADCRUMB COLORS
  // ───────────────────────────────────────────────────────────────────────
  // Light mode: breadcrumb links match Docusaurus body text (#1c1e21)
  css('.breadcrumb-link').styles(color: Color('var(--text)')),
  // Dark mode: separator needs explicit override (--secondary-text dark ≠ #e3e3e3)
  css('[data-theme="dark"] .breadcrumb-sep').styles(
    color: Color('var(--text)'),
  ),

  // ───────────────────────────────────────────────────────────────────────
  // 6. THEME TOGGLE
  //    Reverse the icons: show current-mode icon instead of target-mode.
  //    Light mode: hide moon (first span), show sun (last span).
  //    Dark mode: show moon (first span), hide sun (last span).
  // ───────────────────────────────────────────────────────────────────────
  css('.theme-toggle').styles(
    padding: Padding.zero,
    justifyContent: JustifyContent.center,
    alignItems: AlignItems.center,
    raw: {
      'width': '32px',
      'height': '32px',
      'border-radius': '50% !important',
      'box-sizing': 'border-box',
      'cursor': 'pointer',
    },
  ),
  css('.theme-toggle:hover').styles(
    backgroundColor: Color('rgba(0, 0, 0, 0.1)'),
  ),
  css('[data-theme="dark"] .theme-toggle:hover').styles(
    backgroundColor: Color('rgba(255, 255, 255, 0.1)'),
  ),
  css('.theme-toggle svg').styles(
    raw: {'width': '24px', 'height': '24px'},
  ),
  // Reverse icons: show current state (sun in light, moon in dark).
  // Framework default: moon in light, sun in dark.
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
  // max-width 1320px matches Docusaurus .container constraint
  css('.docs .main-container main > div').styles(
    padding: Padding.only(top: 1.rem, left: 1.rem, right: 1.rem),
    raw: {'max-width': '1320px', 'margin': '0 auto'},
  ),
  // Breadcrumb: position above content using flexbox order
  css('.content-container').styles(
    display: Display.flex,
    flexDirection: FlexDirection.column,
  ),
  css('.content-footer').styles(raw: {'display': 'contents'}),
  css('.breadcrumb').styles(raw: {'order': '-1'}),
  // Breadcrumb: match Docusaurus sizing (12.8px font, link padding, bottom margin)
  css('.docs .breadcrumb').styles(
    padding: Padding.zero,
    margin: Margin.only(bottom: 12.8.px),
    fontSize: 12.8.px,
  ),
  css('.docs .breadcrumb-link, .docs .breadcrumb-current').styles(
    padding: Padding.symmetric(vertical: 5.12.px, horizontal: 10.24.px),
  ),

  // ───────────────────────────────────────────────────────────────────────
  // 8. SIDEBAR — layout/sizing only.
  //    Link/hover/active styles live in CollapsibleSidebar.styles using
  //    var(--primary) (theme-aware). Width matches Docusaurus 300px.
  // ───────────────────────────────────────────────────────────────────────
  // Sidebar width: match Docusaurus 300px (--doc-sidebar-width)
  // Use high specificity to override DocsLayout's .docs .main-container .sidebar-container
  css('.docs .main-container .sidebar-container').styles(
    width: 300.px,
    padding: Padding.only(bottom: 8.rem),
    raw: {
      'overflow-y': 'auto',
      'overflow-x': 'hidden',
      'scrollbar-width': 'none',
      '-ms-overflow-style': 'none',
    },
  ),
  css('.docs .main-container .sidebar-container::-webkit-scrollbar').styles(
    display: Display.none,
  ),
  css('.docs .sidebar').styles(width: 300.px, raw: {'overflow-x': 'hidden'}),
  // Sidebar border-right: match Docusaurus 1px solid border
  css('.docs .sidebar-container').styles(
    border: Border.only(
      right: BorderSide(width: 1.px, color: Color('var(--border)')),
    ),
  ),
  // Dark mode sidebar links: Docusaurus uses #dadde1
  css('[data-theme="dark"] .docs .sidebar a').styles(
    color: Color('#dadde1'),
  ),
  // Dark mode: restore primary color for active/parent-active sidebar links.
  // Needs higher specificity than [data-theme="dark"] .docs .sidebar a (0,3,1).
  css('[data-theme="dark"] .docs .sidebar .sidebar-link.active').styles(
    color: Color('var(--primary)'),
    backgroundColor: Color('var(--hover-overlay)'),
  ),
  css('[data-theme="dark"] .docs .sidebar .sidebar-link.parent-active').styles(
    color: Color('var(--primary)'),
  ),
  // Adjust main padding-left to match wider sidebar (desktop only)
  css.media(MediaQuery.all(minWidth: 1024.px), [
    css('.docs .main-container main').styles(
      padding: Padding.only(left: 300.px),
    ),
  ]),
  // Desktop: align sidebar top with bottom of 3.75rem header.
  // DocsLayout defaults to top: 4rem — override to close the 4px gap.
  css.media(MediaQuery.all(minWidth: 1024.px), [
    css('.docs .main-container .sidebar-container').styles(
      raw: {'top': '3.75rem'},
    ),
  ]),
  // Mobile: 83 vw width (matches Docusaurus --ifm-navbar-sidebar-width) + z-index
  // above the fixed header (z-index 10) so the panel slides over the navbar.
  // .sidebar must also be 100% so nav items fill the panel (not the 300px
  // desktop value which would leave dead space on wider phones).
  css.media(MediaQuery.all(maxWidth: 1023.px), [
    css('.docs .main-container .sidebar-container').styles(
      zIndex: ZIndex(200),
      raw: {'width': '83vw'},
    ),
    css('.docs .sidebar').styles(width: Unit.percent(100)),
  ]),
  // Mobile sidebar: Workflows image-button (the SVG pill used in the header).
  css('.mobile-workflows-btn').styles(
    display: Display.flex,
    alignItems: AlignItems.center,
    textDecoration: TextDecoration.none,
  ),
  css('.mobile-workflows-btn:hover').styles(opacity: 0.8),

  // Dark mode mobile: sidebar panel uses the navbar background (#081842),
  // matching Docusaurus where --ifm-navbar-background-color is applied to
  // the mobile overlay instead of the page background (#020f30).
  css.media(MediaQuery.all(maxWidth: 1023.px), [
    css('[data-theme="dark"] .docs .main-container .sidebar-container').styles(
      backgroundColor: Color('var(--navbar-bg)'),
    ),
  ]),
  // Fix DocsLayout's sidebar-barrier:
  //   • position:fixed so it covers the full viewport (including the header).
  //   • background:#000 so that at DocsLayout's opacity:0.5 it reads as
  //     rgba(0,0,0,0.5) — the standard Docusaurus dark scrim.
  css('.docs .main-container .sidebar-barrier').styles(
    raw: {'position': 'fixed', 'inset': '0', 'background': '#000'},
  ),

  // ───────────────────────────────────────────────────────────────────────
  // 9. CONTENT AREA LINKS
  //    Primary color, no underline; underline on hover (matching original).
  // ───────────────────────────────────────────────────────────────────────
  css('.content-container a:not(.breadcrumb-link):not(.workflow-card):not(.page-nav-prev):not(.page-nav-next)').styles(
    color: Color('var(--content-links)'),
    textDecoration: TextDecoration.none,
  ),
  css(
    '.content-container a:not(.breadcrumb-link):not(.workflow-card):not(.page-nav-prev):not(.page-nav-next):hover',
  ).styles(
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
    raw: {'text-decoration-color': 'var(--callout-info-border)'},
  ),
  css('.content-container .doc-callout-warning a').styles(
    raw: {'text-decoration-color': 'var(--callout-warning-border)'},
  ),
  css('.content-container .doc-callout-error a').styles(
    raw: {'text-decoration-color': 'var(--callout-error-border)'},
  ),
  css('.content-container .doc-callout-success a').styles(
    raw: {'text-decoration-color': 'var(--callout-success-border)'},
  ),

  // ───────────────────────────────────────────────────────────────────────
  // 10. DARK MODE: CODE BLOCKS & SCROLLBARS
  // ───────────────────────────────────────────────────────────────────────
  // Dark mode: all code (inline + blocks) uses navy background
  // Matches Docusaurus custom.css: html[data-theme='dark'] code { background: #081842 }
  css('[data-theme="dark"] code').styles(
    raw: {'background': '#081842 !important'},
  ),
  // Dark mode inline code: match Docusaurus border and text color
  css('[data-theme="dark"] .content :not(pre) > code').styles(
    border: Border.all(color: Color('rgba(0, 0, 0, 0.1)'), width: 1.px),
    color: Color('#e3e3e3'),
  ),
  css('[data-theme="dark"]').styles(
    raw: {'scrollbar-color': '#ffffff30 transparent'},
  ),
  // Dark mode headings: Docusaurus uses #e3e3e3, not pure white
  css('[data-theme="dark"] .content h1, [data-theme="dark"] .content h2, [data-theme="dark"] .content h3').styles(
    color: Color('#e3e3e3'),
  ),

  // ───────────────────────────────────────────────────────────────────────
  // 11. FOOTER & PAGE NAVIGATION SPACING
  //     Docusaurus: footer margin-top 64px, pagination margin-top 48px.
  // ───────────────────────────────────────────────────────────────────────
  css('.site-footer').styles(margin: Margin.only(top: 4.rem)),
  // page-nav spacing is set in PageNavigation.styles (48px margin-top, zero padding)
  // Dark mode: page nav prev/next blocks
  css('[data-theme="dark"] .page-nav-prev, [data-theme="dark"] .page-nav-next').styles(
    border: Border.all(color: Color('#606770'), width: 1.px),
  ),
  css('[data-theme="dark"] .page-nav-label').styles(
    color: Colors.white,
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
  css('.docs .main-container main > div aside.toc').styles(
    raw: {'min-width': '140px', 'flex': '0 1 25%'},
  ),
  css('.docs .main-container main > div aside.toc > div').styles(
    padding: Padding.only(left: 0.5.rem),
    border: Border.only(
      left: BorderSide(width: 1.px, color: Color('var(--border)')),
    ),
  ),
  css('.docs .main-container main > div aside.toc li').styles(
    fontSize: 12.8.px,
  ),
  // TOC links: gray by default, blue when active (matching Docusaurus)
  css('.toc a').styles(
    color: Color('var(--secondary-text)'),
    textDecoration: TextDecoration.none,
  ),
  css('.toc a:hover').styles(
    color: Color('var(--primary)'),
  ),
  css('.toc a.toc-active').styles(
    color: Color('var(--primary)'),
    fontWeight: FontWeight.w500,
  ),
  // TOC code sub-items (backtick headings): rounded pill border
  css('.toc a code').styles(
    padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.125.rem),
    border: Border.all(color: Color('var(--border)'), width: 1.px),
    radius: BorderRadius.circular(12.px),
    fontSize: 11.px,
    raw: {'font-family': 'inherit'},
  ),
  // Dark mode TOC: override link color (--secondary-text dark is #a0a0a0, need white)
  css('[data-theme="dark"] .toc a').styles(
    color: Colors.white,
  ),
  // Dark mode TOC: restore primary color for the active link.
  // Needs higher specificity than [data-theme="dark"] .toc a (0,2,1) to win.
  css('[data-theme="dark"] .toc a.toc-active').styles(
    color: Color('var(--primary)'),
  ),
  // ───────────────────────────────────────────────────────────────────────
  // 12b. MOBILE TOC (collapsible "On this page" above content < 1000px)
  // ───────────────────────────────────────────────────────────────────────
  css('.mobile-toc', [
    css('&').styles(
      margin: Margin.only(bottom: 1.rem),
      radius: BorderRadius.circular(0.4.rem),
      raw: {
        'background': 'var(--hover-overlay)',
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
  // Mobile TOC code sub-items: pill border (same as sidebar TOC)
  css('.mobile-toc .mobile-toc-content a code').styles(
    padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.125.rem),
    border: Border.all(color: Color('var(--border)'), width: 1.px),
    radius: BorderRadius.circular(12.px),
    fontSize: 11.px,
    raw: {'font-family': 'inherit'},
  ),
  // Mobile TOC links: use higher specificity to override .content-container a
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

  // ───────────────────────────────────────────────────────────────────────
  // 12c. TABLES (matching Docusaurus/Infima table styling)
  // ───────────────────────────────────────────────────────────────────────
  css('.content-container table').styles(
    width: Unit.percent(100),
    raw: {'display': 'table', 'border-collapse': 'collapse', 'margin-bottom': '1.25rem'},
  ),
  css('.content-container th, .content-container td').styles(
    padding: Padding.all(0.75.rem),
    border: Border.all(color: Color('var(--border)'), width: 1.px),
  ),
  css('.content-container thead tr').styles(
    raw: {'background': '#f6f7f8'},
  ),
  css('.content-container th').styles(
    fontWeight: FontWeight.w700,
  ),
  css('.content-container tr:nth-child(2n)').styles(
    raw: {'background': '#fbfcfd'},
  ),
  // Dark mode tables
  css('[data-theme="dark"] .content-container thead tr').styles(
    raw: {'background': 'var(--hover-overlay)'},
  ),
  css('[data-theme="dark"] .content-container tr:nth-child(2n)').styles(
    raw: {'background': 'rgba(255, 255, 255, 0.02)'},
  ),

  // ───────────────────────────────────────────────────────────────────────
  // 13. WORKFLOW CARDS
  //     Docusaurus category page: 2-column card grid with icon, title,
  //     and truncated description. Matches /docs/category/workflows.
  // ───────────────────────────────────────────────────────────────────────
  css('.workflow-cards', [
    css('&').styles(
      display: Display.grid,
      gap: Gap(column: 2.rem, row: 2.rem),
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
      padding: Padding.all(2.rem),
      radius: BorderRadius.circular(0.8.rem),
      textDecoration: TextDecoration.none,
      raw: {
        'border': '1px solid #ebedf0',
        'background': '#fbfcff',
        'color': 'inherit',
        'transition': 'border-color 0.2s ease',
        'box-shadow': 'rgba(0, 0, 0, 0.15) 0px 1.5px 3px 0px',
      },
    ),
    css('&:hover').styles(
      textDecoration: TextDecoration.none,
      raw: {'border-color': 'var(--primary)'},
    ),
    css('h3').styles(
      margin: Margin.only(bottom: 1.rem),
      fontSize: 1.2.rem,
      fontWeight: FontWeight.w700,
      textDecoration: TextDecoration.none,
      raw: {'margin-top': '0'},
    ),
    css('p').styles(
      margin: Margin.zero,
      overflow: Overflow.hidden,
      color: Color('var(--muted-text)'),
      fontSize: 0.8.rem,
      textDecoration: TextDecoration.none,
      raw: {
        'display': '-webkit-box',
        '-webkit-line-clamp': '1',
        '-webkit-box-orient': 'vertical',
      },
    ),
  ]),
  // Dark mode workflow cards
  css('[data-theme="dark"] .workflow-card').styles(
    raw: {
      'background': '#314155',
      'border-color': '#444950',
    },
  ),

  // Remove main-container side padding (jaspr_content adds 1.25rem at 768px+)
  // Docusaurus has no container-level padding — padding lives inside content column
  css.media(MediaQuery.all(minWidth: 768.px), [
    css('.docs .main-container').styles(
      padding: Padding.symmetric(horizontal: Unit.zero),
    ),
  ]),
  // Desktop content layout: remove inner div horizontal padding and move it
  // to content-container, so 75% is calculated on the full available space
  // (matching Docusaurus where contentCol = 75% of docMainContainer width)
  css.media(MediaQuery.all(minWidth: 1000.px), [
    css('.docs .main-container main > div').styles(
      padding: Padding.only(top: 1.rem, left: Unit.zero, right: Unit.zero),
    ),
    css('.docs .main-container main > div .content-container').styles(
      padding: Padding.symmetric(horizontal: 1.rem),
      raw: {'max-width': '75%'},
    ),
  ]),
];
