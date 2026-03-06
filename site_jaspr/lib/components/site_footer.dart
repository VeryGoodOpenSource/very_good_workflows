import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../styles/site_styles.dart';
import 'footer_relocator.dart';
import 'toc_scrollspy.dart';

/// The site footer with copyright notice.
///
/// Also injects the Poppins font and comprehensive site styles into the
/// document head.
class SiteFooter extends StatelessComponent {
  const SiteFooter({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      Document.head(
        children: [
          link(
            rel: 'preconnect',
            href: 'https://fonts.googleapis.com',
          ),
          link(
            rel: 'stylesheet',
            href: 'https://fonts.googleapis.com/css2?family=Poppins:wght@400&display=swap',
          ),
          Style(styles: siteStyles),
          script(defer: true, content: _mobileToc),
        ],
      ),
      TocScrollspy(),
      FooterRelocator(),
      footer(classes: 'site-footer', [
        p([
          Component.text('Built with \u{1F499} by '),
          a(href: 'https://verygood.ventures', [
            b([Component.text('Very Good Ventures')]),
          ]),
        ]),
        p([
          Component.text('Copyright \u00A9 ${DateTime.now().year} Very Good Ventures.'),
        ]),
      ]),
    ]);
  }

  /// Inline script that creates a collapsible mobile TOC above the content
  /// when the right sidebar TOC is hidden (viewport < 1000px).
  ///
  /// Uses requestAnimationFrame to defer until after Jaspr's client-side
  /// hydration completes (hydration replaces DOM, removing elements added
  /// synchronously during defer script execution).
  static const _mobileToc = '''
(function(){
  function init(){
    if (document.querySelector('.mobile-toc')) return;
    var toc = document.querySelector('aside.toc');
    if (!toc) return;
    var ul = toc.querySelector('ul');
    if (!ul || !ul.children.length) return;

    var mobile = document.createElement('div');
    mobile.className = 'mobile-toc';

    var toggle = document.createElement('button');
    toggle.className = 'mobile-toc-toggle';
    toggle.innerHTML = '<span>On this page</span><svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"></polyline></svg>';

    var content = document.createElement('div');
    content.className = 'mobile-toc-content';
    content.appendChild(ul.cloneNode(true));

    mobile.appendChild(toggle);
    mobile.appendChild(content);

    var cc = document.querySelector('.content-container');
    var section = cc && cc.querySelector('section.content');
    if (cc && section) cc.insertBefore(mobile, section);
  }
  // Defer to next frame so Jaspr hydration completes first.
  requestAnimationFrame(function(){ requestAnimationFrame(init); });
  // Toggle via event delegation (survives any future DOM changes).
  document.addEventListener('click', function(e){
    var btn = e.target.closest('.mobile-toc-toggle');
    if (!btn) return;
    btn.closest('.mobile-toc').classList.toggle('expanded');
  });
})();
''';

  @css
  static List<StyleRule> get styles => [
    css('.site-footer', [
      css('&').styles(
        padding: Padding.all(2.rem),
        color: Color('var(--text)'),
        textAlign: TextAlign.center,
        fontSize: 1.rem,
        backgroundColor: Color('var(--background)'),
        raw: {
          'position': 'relative',
          'z-index': '11',
        },
      ),
      css('a').styles(
        color: Color('var(--primary)'),
        textDecoration: TextDecoration.none,
      ),
    ]),
  ];
}
