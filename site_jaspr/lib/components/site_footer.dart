import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../styles/site_styles.dart';

/// The site footer with copyright notice.
///
/// Also injects the Poppins font and comprehensive site styles into the
/// document head.
class SiteFooter extends StatelessComponent {
  const SiteFooter({super.key});

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      Document.head(children: [
        link(
          rel: 'preconnect',
          href: 'https://fonts.googleapis.com',
        ),
        link(
          rel: 'stylesheet',
          href: 'https://fonts.googleapis.com/css2?family=Poppins:wght@400&display=swap',
        ),
        Style(styles: siteStyles),
        script(defer: true, content: _tocScrollspy),
        script(defer: true, content: _mobileToc),
        script(defer: true, content: _relocateFooter),
      ]),
      footer(classes: 'site-footer', [
        p([
          Component.text('Built with \u{1F499} by '),
          a(href: 'https://verygood.ventures', [b([Component.text('Very Good Ventures')])]),
        ]),
        p([
          Component.text('Copyright \u00A9 ${DateTime.now().year} Very Good Ventures.'),
        ]),
      ]),
    ]);
  }

  /// Inline script that highlights the active TOC link based on scroll position.
  static const _tocScrollspy = '''
(function(){
  function update() {
    var links = document.querySelectorAll('.toc a');
    if (!links.length) return;
    var ids = [];
    links.forEach(function(a) {
      var h = a.getAttribute('href');
      if (h) { var id = h.split('#')[1]; if (id) ids.push({id:id, el:a}); }
    });
    if (!ids.length) return;
    var active = null;
    for (var i = 0; i < ids.length; i++) {
      var t = document.getElementById(ids[i].id);
      if (t && t.getBoundingClientRect().top <= 100) active = i;
    }
    links.forEach(function(a) { a.classList.remove('toc-active'); });
    if (active === null) active = 0;
    ids[active].el.classList.add('toc-active');
  }
  window.addEventListener('scroll', update, {passive:true});
  update();
})();
''';

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

  /// Moves `.site-footer` from inside `.content-container` to be a direct
  /// child of `.main-container`, so its background spans the full viewport
  /// width and paints above the sidebar border.
  static const _relocateFooter = '''
(function(){
  function move(){
    var footer = document.querySelector('.site-footer');
    var mc = document.querySelector('.main-container');
    if (footer && mc && footer.parentElement !== mc) {
      mc.appendChild(footer);
    }
  }
  requestAnimationFrame(function(){ requestAnimationFrame(move); });
})();
''';

  @css
  static List<StyleRule> get styles => [
    css('.site-footer', [
      css('&').styles(
        padding: Padding.all(2.rem),
        color: Color('#606770'),
        textAlign: TextAlign.center,
        fontSize: 0.875.rem,
        backgroundColor: Colors.white,
        raw: {
          'position': 'relative',
          'z-index': '11',
        },
      ),
      css('a').styles(
        color: Color('#2a48df'),
        textDecoration: TextDecoration.none,
      ),
    ]),
    css('[data-theme="dark"] .site-footer').styles(
      color: Color('#e3e3e3'),
      backgroundColor: Color('#020f30'),
    ),
    css('[data-theme="dark"] .site-footer a').styles(
      color: Color('#44fac7'),
    ),
  ];
}
