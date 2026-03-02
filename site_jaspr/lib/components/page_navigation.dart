import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';

/// Previous/next navigation buttons for docs pages.
///
/// Page order matches the sidebar configuration.
class PageNavigation extends StatelessComponent {
  const PageNavigation({super.key});

  static const _pages = [
    (title: 'Overview', href: '/docs/overview'),
    (title: 'Workflows', href: '/docs/workflows'),
    (title: 'Dart Package', href: '/docs/workflows/dart_package'),
    (title: 'Dart Pub Publish', href: '/docs/workflows/dart_pub_publish'),
    (title: 'Flutter Package', href: '/docs/workflows/flutter_package'),
    (title: 'Flutter Pub Publish', href: '/docs/workflows/flutter_pub_publish'),
    (title: 'License Check', href: '/docs/workflows/license_check'),
    (title: 'Mason Publish', href: '/docs/workflows/mason_publish'),
    (title: 'Pana', href: '/docs/workflows/pana'),
    (title: 'Semantic Pull Request', href: '/docs/workflows/semantic_pull_request'),
    (title: 'Spell Check', href: '/docs/workflows/spell_check'),
  ];

  @override
  Component build(BuildContext context) {
    if (kIsWeb) return Component.fragment([]);

    final url = context.page.url;
    final index = _pages.indexWhere((pg) => pg.href == url);
    if (index == -1) return Component.fragment([]);

    final prev = index > 0 ? _pages[index - 1] : null;
    final next = index < _pages.length - 1 ? _pages[index + 1] : null;

    return nav(classes: 'page-nav', [
      if (prev != null)
        a(classes: 'page-nav-prev', href: prev.href, [
          span(classes: 'page-nav-label', [Component.text('Previous')]),
          span(classes: 'page-nav-title', [Component.text('\u00AB ${prev.title}')]),
        ])
      else
        div([]),
      if (next != null)
        a(classes: 'page-nav-next', href: next.href, [
          span(classes: 'page-nav-label', [Component.text('Next')]),
          span(classes: 'page-nav-title', [Component.text('${next.title} \u00BB')]),
        ])
      else
        div([]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.page-nav', [
      css('&').styles(
        display: Display.flex,
        padding: Padding.symmetric(vertical: 2.rem),
        margin: Margin.only(top: 2.rem),
        border: Border.only(top: BorderSide(color: Color('#0000000d'), width: 1.px)),
        gap: Gap(column: 0.75.rem),
      ),
    ]),
    css('.page-nav-prev, .page-nav-next', [
      css('&').styles(
        display: Display.flex,
        padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.75.rem),
        border: Border.all(color: Color('#0000001a'), width: 1.px),
        radius: BorderRadius.circular(8.px),
        flexDirection: FlexDirection.column,
        gap: Gap(column: 0.25.rem),
        textDecoration: TextDecoration.none,
        raw: {'flex': '1'},
      ),
      css('&:hover').styles(
        border: Border.all(color: ContentColors.links, width: 1.px),
      ),
    ]),
    css('.page-nav-next').styles(
      alignItems: AlignItems.end,
    ),
    css('.page-nav-label').styles(
      opacity: 0.6,
      color: ContentColors.text,
      fontSize: 0.75.rem,
      fontWeight: FontWeight.w600,
    ),
    css('.page-nav-title').styles(
      color: ContentColors.links,
      fontWeight: FontWeight.w600,
    ),
  ];
}
