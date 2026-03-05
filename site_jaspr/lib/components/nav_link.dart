import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

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
      target: href.startsWith('http') ? Target.blank : null,
      [Component.text(text)],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.nav-link').styles(
      padding: Padding.symmetric(horizontal: 0.75.rem, vertical: 0.25.rem),
      color: Color('var(--text)'),
      fontSize: 0.875.rem,
      fontWeight: FontWeight.w500,
      textDecoration: TextDecoration.none,
    ),
    css('.nav-button', [
      css('&').styles(
        padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.5.rem),
        radius: BorderRadius.circular(0.4.rem),
        color: Colors.white,
        fontWeight: FontWeight.w600,
        backgroundColor: Color('var(--primary)'),
        raw: {'line-height': '1.25'},
      ),
      css('&:hover').styles(backgroundColor: Color('var(--primary-hover)')),
      css.media(MediaQuery.all(maxWidth: 996.px), [
        css('&').styles(
          padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.5.rem),
          color: Color('var(--text)'),
          fontWeight: FontWeight.w300,
          backgroundColor: Colors.white,
        ),
      ]),
    ]),
  ];
}
