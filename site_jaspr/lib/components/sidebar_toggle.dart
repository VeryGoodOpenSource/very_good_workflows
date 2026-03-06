import 'package:jaspr/jaspr.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

/// Client-side handler for collapsible sidebar interactions.
///
/// Uses event delegation on `document` to handle:
///   - `.sidebar-caret` clicks: toggle `.expanded` on the parent
///     `.sidebar-collapsible` list item.
///   - `.sidebar-back` clicks: add `.show-primary` to the nearest `.sidebar`
///     to switch to the primary mobile panel.
///   - `.sidebar-close` / `.sidebar-barrier` clicks: remove `.show-primary`
///     from the sidebar, resetting to the secondary panel.
@client
class SidebarToggle extends StatefulComponent {
  const SidebarToggle({super.key});

  @override
  State createState() => _SidebarToggleState();
}

class _SidebarToggleState extends State<SidebarToggle> {
  JSExportedDartFunction? _listener;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    _listener = ((JSAny? raw) {
      if (raw == null) return;
      final target = (raw as web.Event).target;
      if (target == null || !target.isA<web.Element>()) return;
      final element = target as web.Element;

      final caret = element.closest('.sidebar-caret');
      if (caret != null) {
        caret.closest('.sidebar-collapsible')?.classList.toggle('expanded');
        return;
      }

      if (element.closest('.sidebar-back') != null) {
        element.closest('.sidebar')?.classList.add('show-primary');
        return;
      }

      if (element.closest('.sidebar-close') != null || element.closest('.sidebar-barrier') != null) {
        web.document.querySelector('.sidebar')?.classList.remove('show-primary');
      }
    }).toJS;
    web.document.addEventListener('click', _listener! as web.EventListener);
  }

  @override
  void dispose() {
    final listener = _listener;
    if (listener != null) {
      web.document.removeEventListener('click', listener as web.EventListener);
      _listener = null;
    }
    super.dispose();
  }

  @override
  Component build(BuildContext context) => Component.fragment([]);
}
