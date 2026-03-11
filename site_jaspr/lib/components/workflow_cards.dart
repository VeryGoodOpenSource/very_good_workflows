import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import 'package:site_jaspr/utils/page_order.dart';

/// A custom component that auto-generates workflow card links from child pages.
///
/// Use `<WorkflowCards />` in markdown to render a grid of cards for all
/// child pages under the current page's URL, sorted by `sidebar_position`.
class WorkflowCards extends CustomComponentBase {
  @override
  final Pattern pattern = 'WorkflowCards';

  @override
  Component apply(String name, Map<String, String> attributes, Component? child) {
    return const _WorkflowCardsGrid();
  }

  @css
  static List<StyleRule> get styles => [
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
  ];
}

class _WorkflowCardsGrid extends StatelessComponent {
  const _WorkflowCardsGrid();

  @override
  Component build(BuildContext context) {
    if (kIsWeb) return Component.fragment([]);

    final parentUrl = context.page.url;
    final children = getChildPages(context.pages, parentUrl);

    return div(classes: 'workflow-cards', [
      for (final child in children)
        a(classes: 'workflow-card', href: child.href, [
          h3([Component.text(child.title)]),
          p([Component.text(child.description)]),
        ]),
    ]);
  }
}
