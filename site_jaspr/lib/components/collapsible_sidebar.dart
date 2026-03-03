import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/components/sidebar.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';

/// A sidebar entry that can optionally have collapsible children.
class SidebarEntry {
  const SidebarEntry({
    required this.text,
    required this.href,
    this.children = const [],
  });

  final String text;
  final String href;
  final List<SidebarLink> children;

  bool get hasChildren => children.isNotEmpty;
}

/// A sidebar with support for collapsible nested items.
///
/// Items with [SidebarEntry.children] render as a toggle row with a chevron
/// on the right. Clicking the row expands/collapses the children with a
/// 0.5s max-height animation.
///
/// The initial expanded/collapsed state is determined at build time from the
/// current page URL.
class CollapsibleSidebar extends StatelessComponent {
  const CollapsibleSidebar({required this.items, super.key});

  final List<SidebarEntry> items;

  @override
  Component build(BuildContext context) {
    final currentRoute = context.page.url;

    return Component.fragment([
      Document.head(children: [
        Style(styles: styles),
        script(defer: true, content: _toggleScript),
      ]),
      nav(classes: 'sidebar', [
        // Close button for mobile overlay
        button(classes: 'sidebar-close', [
          svg(
            viewBox: '0 0 24 24',
            attributes: {
              'width': '20',
              'height': '20',
              'fill': 'none',
              'stroke': 'currentColor',
              'stroke-width': '2',
            },
            [
              line(
                attributes: {
                  'x1': '18',
                  'y1': '6',
                  'x2': '6',
                  'y2': '18',
                },
                [],
              ),
              line(
                attributes: {
                  'x1': '6',
                  'y1': '6',
                  'x2': '18',
                  'y2': '18',
                },
                [],
              ),
            ],
          ),
        ]),
        div(classes: 'sidebar-group', [
          ul([
            for (final item in items) _buildItem(item, currentRoute),
          ]),
        ]),
      ]),
    ]);
  }

  Component _buildItem(SidebarEntry item, String currentRoute) {
    final isActive = currentRoute == item.href;

    if (!item.hasChildren) {
      // Simple link item
      return li([
        div(
          classes: isActive ? 'active' : null,
          [a(href: item.href, [Component.text(item.text)])],
        ),
      ]);
    }

    // Collapsible item: expanded if current route matches any child
    final isExpanded = item.children.any(
      (child) => currentRoute == child.href,
    );

    return li(
      classes: [
        'sidebar-collapsible',
        if (isExpanded) 'expanded',
      ].join(' '),
      [
        // Toggle row: text + chevron (clicking toggles, no navigation)
        div(classes: isActive ? 'sidebar-toggle active' : 'sidebar-toggle', [
          span([Component.text(item.text)]),
          span(classes: 'sidebar-chevron', [
            svg(
              viewBox: '0 0 24 24',
              attributes: {
                'width': '16',
                'height': '16',
                'fill': 'none',
                'stroke': 'currentColor',
                'stroke-width': '2.5',
                'stroke-linecap': 'round',
                'stroke-linejoin': 'round',
              },
              [
                // Right-pointing chevron (>) — rotated 90° when expanded
                polyline(points: '9 6 15 12 9 18', []),
              ],
            ),
          ]),
        ]),
        // Collapsible children
        ul(classes: 'sidebar-children', [
          for (final child in item.children)
            li([
              div(
                classes: currentRoute == child.href ? 'active' : null,
                [a(href: child.href, [Component.text(child.text)])],
              ),
            ]),
        ]),
      ],
    );
  }

  /// Inline script that toggles the expanded class on collapsible items.
  static const _toggleScript = '''
(function(){
  document.addEventListener('click', function(e){
    var toggle = e.target.closest('.sidebar-toggle');
    if (!toggle) return;
    e.preventDefault();
    toggle.closest('.sidebar-collapsible').classList.toggle('expanded');
  });
})();
''';

  @css
  static List<StyleRule> get styles => [
    // Base sidebar styles (matching jaspr_content Sidebar)
    css('.sidebar', [
      css('&').styles(
        fontSize: 0.875.rem,
        lineHeight: 1.25.rem,
        padding: Padding.only(left: 0.5.rem, bottom: 1.25.rem, top: 0.75.rem),
        position: Position.relative(),
      ),
      css.media(MediaQuery.all(minWidth: 1024.px), [
        css('&').styles(padding: Padding.only(top: Unit.zero)),
      ]),
      css('.sidebar-close', [
        css('&').styles(
          position: Position.absolute(top: 0.75.rem, right: 0.75.rem),
        ),
        css.media(MediaQuery.all(minWidth: 1024.px), [
          css('&').styles(display: Display.none),
        ]),
      ]),
      css('.sidebar-group', [
        css('&').styles(
          padding: Padding.only(top: 1.5.rem, right: 0.75.rem),
        ),
        css('ul').styles(
          listStyle: ListStyle.none,
          margin: Margin.zero,
          padding: Padding.zero,
        ),
        css('li', [
          css('div', [
            css('&').styles(
              display: Display.flex,
              margin: Margin.only(bottom: 1.px),
              opacity: 0.75,
              overflow: Overflow.hidden,
              radius: BorderRadius.circular(.375.rem),
              textOverflow: TextOverflow.ellipsis,
              transition:
                  Transition('all', duration: 150.ms, curve: Curve.easeInOut),
              whiteSpace: WhiteSpace.noWrap,
            ),
            css('&:hover').styles(
              opacity: 1,
              backgroundColor: Color('#0000000d'),
            ),
            css('&.active').styles(
              opacity: 1,
              color: ContentColors.primary,
              fontWeight: FontWeight.w700,
              backgroundColor:
                  Color('color-mix(in srgb, currentColor 15%, transparent)'),
            ),
          ]),
          css('a').styles(
            display: Display.inlineFlex,
            flex: Flex(grow: 1),
            padding: Padding.only(left: 12.px, top: .5.rem, bottom: .5.rem),
          ),
        ]),
      ]),
    ]),

    // Toggle row: flex with space-between so chevron goes to the right
    css('.sidebar-toggle', [
      css('&').styles(
        alignItems: AlignItems.center,
        cursor: Cursor.pointer,
        raw: {'justify-content': 'space-between', 'user-select': 'none'},
      ),
      css('span').styles(
        display: Display.inlineFlex,
        flex: Flex(grow: 1),
        padding: Padding.only(left: 12.px, top: .5.rem, bottom: .5.rem),
      ),
    ]),

    // Chevron: sits on the right, rotates when expanded
    css('.sidebar-chevron', [
      css('&').styles(
        alignItems: AlignItems.center,
        display: Display.flex,
        opacity: 0.4,
        padding: Padding.all(0.25.rem),
        transition: Transition('transform', duration: 300.ms, curve: Curve.ease),
      ),
    ]),
    css('.sidebar-toggle:hover .sidebar-chevron').styles(opacity: 0.8),
    css('.sidebar-collapsible.expanded .sidebar-chevron').styles(
      raw: {'transform': 'rotate(90deg)'},
    ),

    // Collapsible children: animated via max-height
    css('.sidebar-children').styles(
      overflow: Overflow.hidden,
      raw: {
        'max-height': '0',
        'transition': 'max-height 0.5s ease',
      },
    ),
    css('.sidebar-collapsible.expanded .sidebar-children').styles(
      raw: {'max-height': '500px'},
    ),
  ];
}
