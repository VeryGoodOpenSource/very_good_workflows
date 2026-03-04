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
  var links = document.querySelectorAll('.toc a');
  if (!links.length) return;
  var ids = [];
  links.forEach(function(a) {
    var h = a.getAttribute('href');
    if (h) { var id = h.split('#')[1]; if (id) ids.push({id:id, el:a}); }
  });
  if (!ids.length) return;
  function update() {
    var active = null;
    for (var i = 0; i < ids.length; i++) {
      var t = document.getElementById(ids[i].id);
      if (t && t.getBoundingClientRect().top <= 100) active = i;
    }
    links.forEach(function(a) { a.classList.remove('toc-active'); });
    if (active !== null) ids[active].el.classList.add('toc-active');
  }
  window.addEventListener('scroll', update, {passive:true});
  update();
})();
''';

  @css
  static List<StyleRule> get styles => [
    css('.site-footer', [
      css('&').styles(
        padding: Padding.all(2.rem),
        color: Color('#606770'),
        textAlign: TextAlign.center,
        fontSize: 1.rem,
        backgroundColor: Colors.white,
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
