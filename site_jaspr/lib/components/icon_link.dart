import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// An icon-only navigation link for the header.
class IconLink extends StatelessComponent {
  const IconLink({
    required this.href,
    required this.iconSrc,
    required this.alt,
    this.size = 24,
    super.key,
  });

  final String href;
  final String iconSrc;
  final String alt;
  final int size;

  @override
  Component build(BuildContext context) {
    return a(
      classes: 'icon-link',
      href: href,
      target: Target.blank,
      [
        img(
          src: iconSrc,
          alt: alt,
          attributes: {
            'width': '$size',
            'height': '$size',
          },
        ),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    css('.icon-link', [
      css('&').styles(
        display: Display.flex,
        padding: Padding.symmetric(horizontal: 0.5.rem),
        opacity: 0.8,
        alignItems: AlignItems.center,
        textDecoration: TextDecoration.none,
      ),
      css('&:hover').styles(opacity: 1),
    ]),
  ];
}
