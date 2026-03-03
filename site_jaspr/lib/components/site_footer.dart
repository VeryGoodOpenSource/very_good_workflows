import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../styles/site_styles.dart';

/// The site footer with copyright notice.
///
/// Also injects the Poppins font and comprehensive site styles into the
/// document head.
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
        Style(styles: siteStyles),
      ]),
      footer(classes: 'site-footer', [
        p([
          Component.text('Built with \u{1F499} by '),
          a(href: 'https://verygood.ventures', [b([Component.text('Very Good Ventures')])]),
        ]),
        p([
          Component.text('Copyright \u00A9 ${DateTime.now().year} Very Good Ventures.'),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.site-footer', [
      css('&').styles(
        padding: Padding.all(2.rem),
        color: Color('#606770'),
        textAlign: TextAlign.center,
        fontSize: 1.rem,
        backgroundColor: Colors.white,
      ),
      css('a').styles(
        color: Color('#2a48df'),
        textDecoration: TextDecoration.none,
      ),
    ]),
    css('[data-theme="dark"] .site-footer').styles(
      backgroundColor: Color('#020f30'),
    ),
  ];
}
