import 'package:universal_web/js_interop.dart';

import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

/// Client-side workaround for a Jaspr framework bug where [Document.html]
/// does not reliably update the `data-theme` attribute during client rebuilds.
///
/// After any `.theme-toggle` click, reads the stored theme from `localStorage`
/// after a microtask — giving Jaspr's click handler time to write first —
/// and applies it directly to `document.documentElement`.
@client
class ThemeToggleFix extends StatefulComponent {
  const ThemeToggleFix({super.key});

  @override
  State createState() => _ThemeToggleFixState();
}

class _ThemeToggleFixState extends State<ThemeToggleFix> {
  JSExportedDartFunction? _listener;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    _listener = ((JSAny? raw) {
      final target = (raw as web.Event).target;
      if (target == null || !target.isA<web.Element>()) return;
      final el = target as web.Element;
      if (el.closest('.theme-toggle') == null) return;
      Future.delayed(Duration.zero, () {
        final theme = web.window.localStorage.getItem('jaspr:theme') ?? 'light';
        web.document.documentElement?.setAttribute('data-theme', theme);
      });
    }).toJS;
    web.document.addEventListener('click', _listener! as web.EventListener);
  }

  @override
  void dispose() {
    final l = _listener;
    if (l != null) {
      web.document.removeEventListener('click', l as web.EventListener);
      _listener = null;
    }
    super.dispose();
  }

  @override
  Component build(BuildContext context) => Component.fragment([]);
}
