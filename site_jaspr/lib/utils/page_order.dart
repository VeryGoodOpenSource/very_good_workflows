import 'package:jaspr_content/jaspr_content.dart';

/// A lightweight page reference with title, description, and href.
typedef PageRef = ({String title, String description, String href});

/// Returns all docs pages in depth-first sidebar order.
///
/// Top-level pages (`/docs/overview`, `/docs/workflows`) are sorted by
/// `sidebar_position`. Children (`/docs/workflows/*`) are inserted after
/// their parent, also sorted by `sidebar_position`.
List<PageRef> getOrderedDocPages(List<Page> pages) {
  final docPages = pages.where((p) => p.url.startsWith('/docs/')).toList();

  final topLevel = docPages.where(_isTopLevel).toList()..sort((a, b) => _position(a).compareTo(_position(b)));
  final children = docPages.where(_isChild).toList()..sort((a, b) => _position(a).compareTo(_position(b)));

  final result = <PageRef>[];
  for (final page in topLevel) {
    result.add(_toRef(page));
    for (final child in children.where((c) => c.url.startsWith('${page.url}/'))) {
      result.add(_toRef(child));
    }
  }
  return result;
}

/// Returns direct child pages of [parentUrl], sorted by `sidebar_position`.
List<PageRef> getChildPages(List<Page> pages, String parentUrl) {
  final matched =
      pages
          .where((p) => p.url.startsWith('$parentUrl/') && !p.url.substring(parentUrl.length + 1).contains('/'))
          .toList()
        ..sort((a, b) => _position(a).compareTo(_position(b)));
  return matched.map(_toRef).toList();
}

// -- helpers --

bool _isTopLevel(Page p) => p.url.split('/').where((s) => s.isNotEmpty).length == 2;

bool _isChild(Page p) => p.url.split('/').where((s) => s.isNotEmpty).length == 3;

int _position(Page p) => (p.data.page['sidebar_position'] as num?)?.toInt() ?? 999;

PageRef _toRef(Page p) => (
  title: p.data.page['title'] as String? ?? '',
  description: p.data.page['description'] as String? ?? '',
  href: p.url,
);
