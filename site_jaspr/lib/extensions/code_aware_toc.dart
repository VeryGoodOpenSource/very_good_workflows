import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_router/jaspr_router.dart';

/// A post-processing extension that runs after [TableOfContentsExtension]
/// to preserve `<code>` formatting in TOC entries.
///
/// Headings written with backticks in markdown (e.g. `` ### `types` ``) will
/// render their TOC link text inside a `<code>` element, matching Docusaurus
/// behavior where code-styled headings look visually distinct from regular
/// headings in the table of contents.
class CodeAwareTocPostProcessor implements PageExtension {
  static final _headerRegex = RegExp(r'^h(\d)$', caseSensitive: false);

  @override
  Future<List<Node>> apply(Page page, List<Node> nodes) async {
    final codeHeadingIds = <String>{};
    _findCodeHeadings(nodes, codeHeadingIds);

    if (codeHeadingIds.isNotEmpty) {
      final toc = page.data['toc'];
      if (toc is TableOfContents) {
        page.apply(data: {
          'toc': _CodeAwareTableOfContents(toc.entries, codeHeadingIds),
        });
      }
    }

    return nodes;
  }

  void _findCodeHeadings(List<Node> nodes, Set<String> codeIds) {
    for (final node in nodes) {
      if (node is ElementNode) {
        if (_headerRegex.hasMatch(node.tag)) {
          final id = node.attributes['id'];
          if (id != null && _hasCodeChild(node)) {
            codeIds.add(id);
          }
        }
        if (node.children != null) {
          _findCodeHeadings(node.children!, codeIds);
        }
      }
    }
  }

  bool _hasCodeChild(ElementNode node) {
    for (final child in node.children ?? const <Node>[]) {
      if (child is ElementNode) {
        if (child.tag == 'code') return true;
        if (_hasCodeChild(child)) return true;
      }
    }
    return false;
  }
}

class _CodeAwareTableOfContents extends TableOfContents {
  _CodeAwareTableOfContents(super.entries, this._codeEntryIds);

  final Set<String> _codeEntryIds;

  @override
  Component build() {
    return ul([..._buildToc(entries)]);
  }

  Iterable<Component> _buildToc(List<TocEntry> toc, [int indent = 0]) sync* {
    for (final entry in toc) {
      final isCode = _codeEntryIds.contains(entry.id);
      yield li(
        styles: Styles(padding: Padding.only(left: (0.75 * indent).em)),
        [
          Builder(
            builder: (context) {
              final route = RouteState.of(context);
              return a(
                href: '${route.path}#${entry.id}',
                [
                  if (isCode)
                    code([Component.text(entry.text)])
                  else
                    Component.text(entry.text),
                ],
              );
            },
          ),
        ],
      );
      if (entry.children.isNotEmpty) {
        yield* _buildToc(entry.children, indent + 1);
      }
    }
  }
}
