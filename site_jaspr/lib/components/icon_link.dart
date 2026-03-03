import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// An icon-only navigation link for the header.
class IconLink extends StatelessComponent {
  const IconLink({
    required this.href,
    required this.iconSrc,
    required this.alt,
    this.darkIconSrc,
    this.size = 24,
    super.key,
  });

  final String href;
  final String iconSrc;
  final String alt;
  final String? darkIconSrc;
  final int size;

  @override
  Component build(BuildContext context) {
    final attrs = {'width': '$size', 'height': '$size'};
    final children = <Component>[
      img(
        classes: darkIconSrc != null ? 'icon-light' : null,
        src: iconSrc,
        alt: alt,
        attributes: attrs,
      ),
      if (darkIconSrc != null)
        img(
          classes: 'icon-dark',
          src: darkIconSrc!,
          alt: alt,
          attributes: attrs,
        ),
    ];
    return a(
      classes: 'icon-link',
      href: href,
      target: Target.blank,
      children,
    );
  }

  // Item 7: opacity 1 default, 0.6 on hover (matching original)
  @css
  static List<StyleRule> get styles => [
    css('.icon-link', [
      css('&').styles(
        display: Display.flex,
        padding: Padding.symmetric(horizontal: 0.5.rem),
        alignItems: AlignItems.center,
        textDecoration: TextDecoration.none,
      ),
      css('&:hover').styles(opacity: 0.6),
      css('.icon-dark').styles(display: Display.none),
    ]),
  ];
}
