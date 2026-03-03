import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

/// A breadcrumb navigation component for docs pages.
///
/// Derives the breadcrumb path from the current page URL.
/// Only renders on docs pages (URLs starting with `/docs/`).
class Breadcrumb extends StatelessComponent {
  const Breadcrumb({super.key});

  @override
  Component build(BuildContext context) {
    if (kIsWeb) return Component.fragment([]);

    final page = context.page;
    final url = page.url;
    if (!url.startsWith('/docs/')) return Component.fragment([]);

    final segments = url.split('/').where((seg) => seg.isNotEmpty).toList();
    // e.g. ['docs', 'overview'] or ['docs', 'workflows', 'dart_package']

    final title = page.data.page['title'] as String? ?? _formatSegment(segments.last);

    final items = <Component>[];

    // Home icon
    items.add(
      a(classes: 'breadcrumb-link', href: '/', [
        svg(
          viewBox: '0 0 24 24',
          attributes: {'width': '16', 'height': '16', 'fill': 'currentColor'},
          [path(d: 'M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z', [])],
        ),
      ]),
    );

    // Middle segments (skip 'docs' prefix and last segment)
    for (var i = 1; i < segments.length - 1; i++) {
      final href = '/${segments.sublist(0, i + 1).join('/')}';
      items.add(span(classes: 'breadcrumb-sep', [Component.text('>')]));
      items.add(
        a(classes: 'breadcrumb-link', href: href, [Component.text(_formatSegment(segments[i]))]),
      );
    }

    // Current page
    items.add(span(classes: 'breadcrumb-sep', [Component.text('>')]));
    items.add(span(classes: 'breadcrumb-current', [Component.text(title)]));

    return nav(classes: 'breadcrumb', items);
  }

  static String _formatSegment(String segment) {
    return segment.split('_').map((w) => '${w[0].toUpperCase()}${w.substring(1)}').join(' ');
  }

  @css
  static List<StyleRule> get styles => [
    css('.breadcrumb', [
      css('&').styles(
        display: Display.flex,
        padding: Padding.only(bottom: 1.rem),
        alignItems: AlignItems.center,
        gap: Gap(column: 0.5.rem),
        fontSize: 0.875.rem,
      ),
    ]),
    css('.breadcrumb-link', [
      css('&').styles(
        color: Color('#606770'),
        textDecoration: TextDecoration.none,
      ),
      css('&:hover').styles(color: Color('#2a48df')),
    ]),
    css('.breadcrumb-sep').styles(
      opacity: 0.5,
      color: Color('#606770'),
      fontSize: 0.75.rem,
    ),
    css('.breadcrumb-current').styles(
      padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.125.rem),
      radius: BorderRadius.circular(12.px),
      color: Color('#2a48df'),
      fontSize: 0.8.rem,
      backgroundColor: Color('color-mix(in srgb, currentColor 8%, transparent)'),
    ),
  ];
}
