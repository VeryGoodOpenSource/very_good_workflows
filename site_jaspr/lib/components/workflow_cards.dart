import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../utils/page_order.dart';

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
