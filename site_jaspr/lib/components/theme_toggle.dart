import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

/// A two-state theme toggle: light ↔ dark.
///
/// On first load of a session, the OS preference is used as the default.
/// Clicking writes to sessionStorage and flips `data-theme` on `<html>`,
/// so the choice persists while navigating between pages in the same tab.
/// Closing the tab resets to the OS preference on the next visit.
@client
class ThemeToggle extends StatelessComponent {
  const ThemeToggle({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      // Synchronous script: resolves the theme before first paint to prevent
      // a flash of the wrong icon or background.
      if (!kIsWeb)
        Document.head(
          children: [
            script(
              id: 'theme-script',
              content: '''
            var stored = window.sessionStorage.getItem('jaspr:theme');
            var theme = stored || (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light');
            document.documentElement.setAttribute('data-theme', theme);
          ''',
            ),
          ],
        ),
      button(
        classes: 'theme-toggle',
        attributes: {'aria-label': 'Toggle theme'},
        onClick: () {
          final current =
              web.document.documentElement?.getAttribute('data-theme') ??
              'light';
          final next = current == 'light' ? 'dark' : 'light';
          web.window.sessionStorage.setItem('jaspr:theme', next);
          web.document.documentElement?.setAttribute('data-theme', next);
        },
        [
          // Span 1: sun icon — shown when data-theme = light.
          span([
            svg(
              viewBox: '0 0 24 24',
              attributes: {
                'fill': 'none',
                'stroke': 'currentColor',
                'stroke-width': '2',
                'stroke-linecap': 'round',
                'stroke-linejoin': 'round',
              },
              [
                circle(cx: '12', cy: '12', r: '4', []),
                path(d: 'M12 4h.01', []),
                path(d: 'M20 12h.01', []),
                path(d: 'M12 20h.01', []),
                path(d: 'M4 12h.01', []),
                path(d: 'M17.657 6.343h.01', []),
                path(d: 'M17.657 17.657h.01', []),
                path(d: 'M6.343 17.657h.01', []),
                path(d: 'M6.343 6.343h.01', []),
              ],
            ),
          ]),
          // Span 2: moon icon — shown when data-theme = dark.
          span([
            svg(
              viewBox: '0 0 24 24',
              attributes: {
                'fill': 'none',
                'stroke': 'currentColor',
                'stroke-width': '2',
                'stroke-linecap': 'round',
                'stroke-linejoin': 'round',
              },
              [path(d: 'M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z', [])],
            ),
          ]),
        ],
      ),
    ]);
  }
}
