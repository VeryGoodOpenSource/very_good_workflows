import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/theme.dart';

/// The site footer with copyright notice.
///
/// Also injects the Poppins font into the document head.
class SiteFooter extends StatelessComponent {
  const SiteFooter({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      Document.head(children: [
        link(
          rel: 'preconnect',
          href: 'https://fonts.googleapis.com',
        ),
        link(
          rel: 'stylesheet',
          href: 'https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap',
        ),
        Style(styles: _fontStyles),
      ]),
      footer(classes: 'site-footer', [
        p([
          Component.text('Built with \u{1F499} by '),
          a(href: 'https://verygood.ventures', [Component.text('Very Good Ventures')]),
        ]),
        p([
          Component.text('Copyright \u00A9 ${DateTime.now().year} Very Good Ventures.'),
        ]),
      ]),
    ]);
  }

  static List<StyleRule> get _fontStyles => [
    // Override the content font variable to use Poppins
    css(':root').styles(
      raw: {
        '--content-font':
            "'Poppins', ui-sans-serif, system-ui, sans-serif, "
            "'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', "
            "'Noto Color Emoji'",
      },
    ),
    // Apply Poppins font directly (for pages without the theme base styles)
    css('html, body').styles(
      raw: {'font-family': "var(--content-font)"},
    ),
    // Opaque header background for both modes
    css('.header-container').styles(backgroundColor: Colors.white),
    css('[data-theme="dark"] .header-container').styles(
      backgroundColor: Color('#081842'),
    ),
    // Hide the title text in the header (original only shows the logo badge)
    css('.header-title > span').styles(display: Display.none),
    // Hide the duplicate title, description, and image rendered from frontmatter
    css('.content-header').styles(display: Display.none),
    // Hide the repo name and stats in the GitHub button (icon-only)
    css('.github-button .github-info').styles(raw: {'display': 'none !important'}),
    // Larger font for the "Workflows" logo badge in the header
    css('.header-title img').styles(height: 2.5.rem),
    // Dark mode icon inversion for the VGV logo
    css('[data-theme="dark"] .icon-link img').styles(
      raw: {'filter': 'brightness(0) invert(1)'},
    ),
    // Dark mode "Get Started" button color
    css('[data-theme="dark"] .nav-button').styles(
      color: Color('#020f30'),
      backgroundColor: Color('#66fbd1'),
    ),
    css('[data-theme="dark"] .nav-button:hover').styles(
      backgroundColor: Color('#4de0b8'),
    ),
    // Reverse theme toggle icons: show current mode instead of target mode
    // Light mode: hide moon (first span), show sun (last span)
    css('[data-theme="light"] .theme-toggle > span:first-child').styles(
      raw: {'display': 'none !important'},
    ),
    css('[data-theme="light"] .theme-toggle > span:last-child').styles(
      raw: {'display': 'inline !important'},
    ),
    // Dark mode: show moon (first span), hide sun (last span)
    css('[data-theme="dark"] .theme-toggle > span:first-child').styles(
      raw: {'display': 'inline !important'},
    ),
    css('[data-theme="dark"] .theme-toggle > span:last-child').styles(
      raw: {'display': 'none !important'},
    ),
    // Position breadcrumb above content header using flexbox order
    css('.content-container').styles(
      display: Display.flex,
      flexDirection: FlexDirection.column,
    ),
    css('.content-footer').styles(raw: {'display': 'contents'}),
    css('.breadcrumb').styles(raw: {'order': '-1'}),
    // Vertically center nav links with icons in the header
    css('.header .header-items').styles(alignItems: AlignItems.center),
    // Dark mode scrollbars (sidebar, code blocks, etc.)
    css('[data-theme="dark"]').styles(
      raw: {'scrollbar-color': '#ffffff30 transparent'},
    ),
    // Content link styling: green without underlines (matching original)
    css('.content-container a:not(.breadcrumb-link)').styles(
      color: ContentColors.links,
      textDecoration: TextDecoration.none,
    ),
    css('.content-container a:not(.breadcrumb-link):hover').styles(
      textDecoration: TextDecoration(line: TextDecorationLine.underline),
    ),
  ];

  @css
  static List<StyleRule> get styles => [
    css('.site-footer', [
      css('&').styles(
        padding: .symmetric(vertical: 2.rem),
        border: Border.only(top: BorderSide(color: Color('#0000000d'), width: 1.px)),
        color: ContentColors.lead,
        textAlign: TextAlign.center,
        fontSize: 0.875.rem,
      ),
      css('a').styles(
        color: ContentColors.links,
        textDecoration: TextDecoration.none,
      ),
    ]),
  ];
}
