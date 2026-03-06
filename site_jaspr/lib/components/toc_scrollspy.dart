import 'package:universal_web/js_interop.dart';

import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

/// Highlights the active table-of-contents link based on scroll position.
///
/// On every scroll event, finds the heading nearest the top of the viewport
/// (≤ 100px) and adds `.toc-active` to its corresponding TOC link, falling
/// back to the first link when the page is scrolled above all headings.
@client
class TocScrollspy extends StatefulComponent {
  const TocScrollspy({super.key});

  @override
  State createState() => _TocScrollspyState();
}

class _TocScrollspyState extends State<TocScrollspy> {
  JSExportedDartFunction? _listener;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    _listener = ((JSAny? _) => _update()).toJS;
    web.window.addEventListener('scroll', _listener! as web.EventListener);
    _update();
  }

  void _update() {
    final links = web.document.querySelectorAll('.toc a');
    if (links.length == 0) return;

    final entries = <({String id, web.Element el})>[];
    for (var i = 0; i < links.length; i++) {
      final node = links.item(i);
      if (node == null || !node.isA<web.Element>()) continue;
      final el = node as web.Element;
      final href = el.getAttribute('href');
      if (href == null || !href.contains('#')) continue;
      final id = href.split('#').last;
      if (id.isNotEmpty) entries.add((id: id, el: el));
    }
    if (entries.isEmpty) return;

    int? active;
    for (var i = 0; i < entries.length; i++) {
      final el = web.document.getElementById(entries[i].id);
      if (el != null && el.getBoundingClientRect().top <= 100) active = i;
    }

    for (var i = 0; i < links.length; i++) {
      final node = links.item(i);
      if (node != null && node.isA<web.Element>()) {
        (node as web.Element).classList.remove('toc-active');
      }
    }
    entries[active ?? 0].el.classList.add('toc-active');
  }

  @override
  void dispose() {
    final l = _listener;
    if (l != null) {
      web.window.removeEventListener('scroll', l as web.EventListener);
      _listener = null;
    }
    super.dispose();
  }

  @override
  Component build(BuildContext context) => Component.fragment([]);
}
