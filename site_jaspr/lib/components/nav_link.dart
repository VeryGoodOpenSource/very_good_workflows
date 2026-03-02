import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/theme.dart';

/// A simple navigation link for the header.
///
/// Set [isButton] to `true` to render as a styled button (e.g. "Get Started").
class NavLink extends StatelessComponent {
  const NavLink({
    required this.text,
    required this.href,
    this.isButton = false,
    super.key,
  });

  final String text;
  final String href;
  final bool isButton;

  @override
  Component build(BuildContext context) {
    return a(
      classes: isButton ? 'nav-link nav-button' : 'nav-link',
      href: href,
      [Component.text(text)],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.nav-link').styles(
      padding: Padding.symmetric(horizontal: 0.75.rem, vertical: 0.25.rem),
      color: ContentColors.text,
      fontSize: 0.875.rem,
      fontWeight: FontWeight.w500,
      textDecoration: TextDecoration.none,
    ),
    css('.nav-button', [
      css('&').styles(
        padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.5.rem),
        radius: BorderRadius.circular(6.px),
        color: Colors.white,
        fontWeight: FontWeight.w600,
        backgroundColor: Color('#2a48df'),
      ),
      css('&:hover').styles(backgroundColor: Color('#1e38b0')),
    ]),
  ];
}
