import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../utils/page_order.dart';

/// Previous/next navigation buttons for docs pages.
///
/// Page order is derived automatically from `context.pages` and each page's
/// `sidebar_position` frontmatter field, matching the sidebar order.
class PageNavigation extends StatelessComponent {
  const PageNavigation({super.key});

  @override
  Component build(BuildContext context) {
    if (kIsWeb) return Component.fragment([]);

    final url = context.page.url;
    final pages = getOrderedDocPages(context.pages);
    final index = pages.indexWhere((pg) => pg.href == url);
    if (index == -1) return Component.fragment([]);

    final prev = index > 0 ? pages[index - 1] : null;
    final next = index < pages.length - 1 ? pages[index + 1] : null;

    return nav(classes: 'page-nav', [
      if (prev != null)
        a(classes: 'page-nav-prev', href: prev.href, [
          span(classes: 'page-nav-label', [Component.text('Previous')]),
          span(classes: 'page-nav-title', [Component.text('\u00AB ${prev.title}')]),
        ]),
      if (next != null)
        a(classes: 'page-nav-next', href: next.href, [
          span(classes: 'page-nav-label', [Component.text('Next')]),
          span(classes: 'page-nav-title', [Component.text('${next.title} \u00BB')]),
        ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    css('.page-nav', [
      css('&').styles(
        display: Display.flex,
        padding: Padding.zero,
        margin: Margin.only(top: 48.px),
        border: Border.only(
          top: BorderSide(color: Color('var(--hover-overlay)'), width: 1.px),
        ),
        gap: Gap(column: 0.75.rem),
      ),
    ]),
    css('.page-nav-prev, .page-nav-next').styles(
      display: Display.flex,
      padding: Padding.all(1.rem),
      border: Border.all(color: Color('var(--border)'), width: 1.px),
      radius: BorderRadius.circular(0.4.rem),
      flexDirection: FlexDirection.column,
      gap: Gap(row: 0.25.rem),
      textDecoration: TextDecoration.none,
      raw: {'flex': '0 1 calc(50% - 0.375rem)', 'line-height': '1.25'},
    ),
    css('.page-nav-prev:hover, .page-nav-next:hover').styles(
      border: Border.all(color: Color('var(--primary)'), width: 1.px),
    ),
    css('.page-nav-next').styles(
      margin: Margin.only(left: Unit.auto),
      alignItems: AlignItems.end,
    ),
    css('.page-nav-label').styles(
      color: Color('var(--secondary-text)'),
      fontSize: 0.875.rem,
      fontWeight: FontWeight.w500,
    ),
    css('.page-nav-title').styles(
      color: Color('var(--primary)'),
      fontWeight: FontWeight.w700,
    ),
  ];
}
