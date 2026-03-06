import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

/// Moves `.site-footer` from inside `.content-container` to be a direct
/// child of `.main-container`, so its background spans the full viewport
/// width and renders above the sidebar border.
///
/// Deferred to the second event loop tick to ensure Jaspr's client-side
/// hydration completes before DOM manipulation (hydration replaces DOM nodes).
@client
class FooterRelocator extends StatefulComponent {
  const FooterRelocator({super.key});

  @override
  State createState() => _FooterRelocatorState();
}

class _FooterRelocatorState extends State<FooterRelocator> {
  @override
  void initState() {
    super.initState();
    if (!kIsWeb) return;
    Future.delayed(Duration.zero, () => Future.delayed(Duration.zero, _move));
  }

  void _move() {
    final footer = web.document.querySelector('.site-footer');
    final mainContainer = web.document.querySelector('.main-container');
    if (footer == null || mainContainer == null) return;
    if (footer.parentElement == mainContainer) return;
    mainContainer.appendChild(footer);
  }

  @override
  Component build(BuildContext context) => Component.fragment([]);
}
