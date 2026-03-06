import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/components/sidebar.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:jaspr_content/theme.dart';

import '../utils/page_order.dart';
import 'sidebar_toggle.dart';

/// A sidebar entry that can optionally have collapsible children.
///
/// When [autoChildren] is `true`, children are derived at build time from
/// `context.pages` by matching pages whose URL starts with [href]/. This
/// removes the need to hardcode [SidebarLink] entries for each child page.
class SidebarEntry {
  const SidebarEntry({
    required this.text,
    required this.href,
    this.children = const [],
    this.autoChildren = false,
  });

  final String text;
  final String href;
  final List<SidebarLink> children;
  final bool autoChildren;

  bool get hasChildren => children.isNotEmpty || autoChildren;
}

/// A sidebar replicating Docusaurus's collapsible sidebar exactly.
///
/// Matches the Docusaurus `menu__list-item-collapsible` structure:
///   - Category items render a navigable [a] link alongside a separate
///     [button] caret that handles expand/collapse only.
///   - Leaf items render a single [a] link.
///   - The active item and expanded category are determined server-side from
///     the current page URL; client-side toggling uses an inline script.
///
/// On mobile (< 1024 px) a header bar is rendered at the top of the panel
/// containing [mobileNavItems] (all the header nav items — links, icons,
/// ThemeToggle, etc.) and the close button. This mirrors Docusaurus's
/// `navbar-sidebar__brand` + `navbar-sidebar__items` structure.
///
/// When [primaryNavItems] is provided, a two-panel mobile sidebar is rendered:
///   - Secondary panel (default): the doc links + "← Back to main menu"
///   - Primary panel: the [primaryNavItems] shown as a vertical list.
///   Tapping "← Back to main menu" switches to the primary panel.
///
/// Styling follows Infima's sidebar tokens:
///   - Item padding: 0.375rem 0.75rem, border-radius: 0.25rem
///   - Active: var(--primary) color, w600, 10 % primary tint background
///   - Category headers: always w600 (semibold), whether expanded or not
///   - Hover: rgba(0,0,0,0.05) light / rgba(255,255,255,0.05) dark
class CollapsibleSidebar extends StatelessComponent {
  const CollapsibleSidebar({
    required this.items,
    this.mobileNavItems = const [],
    this.primaryNavItems = const [],
    super.key,
  });

  final List<SidebarEntry> items;

  /// Nav items rendered in the mobile-only header bar (hidden on desktop).
  ///
  /// Pass the same items as the desktop header (NavLinks, IconLinks,
  /// ThemeToggle, etc.) so they remain accessible on narrow viewports.
  final List<Component> mobileNavItems;

  /// Nav items shown in the primary panel when "← Back to main menu" is tapped.
  ///
  /// Mirrors Docusaurus's two-panel mobile sidebar: the secondary panel shows
  /// doc links, and the primary panel shows the global site nav items.
  final List<Component> primaryNavItems;

  @override
  Component build(BuildContext context) {
    final currentRoute = context.page.url;

    // Resolve auto-children from context.pages for entries that opt in.
    final resolvedItems = kIsWeb
        ? items
        : items.map((item) {
            if (!item.autoChildren) return item;
            final children = getChildPages(
              context.pages,
              item.href,
            ).map((page) => SidebarLink(text: page.title, href: page.href)).toList();
            return SidebarEntry(text: item.text, href: item.href, children: children);
          }).toList();

    return Component.fragment([
      SidebarToggle(),
      nav(classes: 'sidebar', [
        // Mobile-only header: nav items (flex row) + close button.
        // Mirrors Docusaurus's navbar-sidebar__brand / navbar-sidebar__items.
        // Hidden on desktop (≥ 1024 px) via CSS.
        div(classes: 'sidebar-mobile-header', [
          div(classes: 'sidebar-mobile-nav', mobileNavItems),
          // Close button — the SidebarToggleButton listens for .sidebar-close
          // clicks to collapse the panel.
          button(
            classes: 'sidebar-close',
            attributes: {'type': 'button', 'aria-label': 'Close menu'},
            [
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
                    attributes: {'x1': '18', 'y1': '6', 'x2': '6', 'y2': '18'},
                    [],
                  ),
                  line(
                    attributes: {'x1': '6', 'y1': '6', 'x2': '18', 'y2': '18'},
                    [],
                  ),
                ],
              ),
            ],
          ),
        ]),
        // Mobile-only primary panel — shown when the nav has .show-primary.
        // Contains the global nav items (Get Started, VGV Dev Tools, icons).
        // Hidden on desktop (≥ 1024 px) via CSS.
        if (primaryNavItems.isNotEmpty)
          div(classes: 'sidebar-primary', [
            div(classes: 'sidebar-primary-nav', primaryNavItems),
          ]),
        // Mobile-only "← Back to main menu" — mirrors Docusaurus's secondary
        // panel back-link; switches to the primary panel when clicked.
        // Hidden on desktop (≥ 1024 px) via CSS.
        // Hidden in primary mode (.show-primary on parent .sidebar) via CSS.
        button(
          classes: 'sidebar-back',
          attributes: {'type': 'button'},
          [Component.text('← Back to main menu')],
        ),
        div(classes: 'sidebar-group', [
          ul([
            for (final item in resolvedItems) _buildItem(item, currentRoute),
          ]),
        ]),
      ]),
    ]);
  }

  Component _buildItem(SidebarEntry item, String currentRoute) {
    final isActive = currentRoute == item.href;

    if (!item.hasChildren) {
      return li([
        a(
          href: item.href,
          classes: 'sidebar-link${isActive ? ' active' : ''}',
          [Component.text(item.text)],
        ),
      ]);
    }

    // Expand the category if the current page is the category itself or a child.
    final isChildActive = item.children.any((c) => currentRoute == c.href);
    final isExpanded = isActive || isChildActive;

    return li(
      classes: 'sidebar-collapsible${isExpanded ? ' expanded' : ''}',
      [
        // Category header: navigable link + separate caret toggle button.
        // Mirrors Docusaurus's div.menu__list-item-collapsible structure.
        div(classes: 'sidebar-category-header', [
          a(
            href: item.href,
            // Full .active (color + bg tint) when the category page itself is
            // current; color-only .parent-active when a child page is current.
            classes:
                'sidebar-link sidebar-category-link'
                '${isActive
                    ? ' active'
                    : isChildActive
                    ? ' parent-active'
                    : ''}',
            [Component.text(item.text)],
          ),
          button(
            classes: 'sidebar-caret',
            attributes: {'type': 'button'},
            [
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
                // Right-pointing chevron (>); rotates 90° to point down when expanded.
                [polyline(points: '9 6 15 12 9 18', [])],
              ),
            ],
          ),
        ]),
        // Wrapper div is required for the CSS grid expand animation:
        // grid-template-rows: 0fr → 1fr transitions on the actual content
        // height, giving smooth expand AND collapse (unlike max-height tricks).
        div(classes: 'sidebar-children', [
          ul([
            for (final child in item.children)
              li([
                a(
                  href: child.href,
                  classes: 'sidebar-link${currentRoute == child.href ? ' active' : ''}',
                  [Component.text(child.text)],
                ),
              ]),
          ]),
        ]),
      ],
    );
  }

  @css
  static List<StyleRule> get styles => [
    // ── Sidebar container ────────────────────────────────────────────────────
    css('.sidebar', [
      css('&').styles(
        position: Position.relative(),
        padding: Padding.only(bottom: 1.25.rem),
        fontSize: 0.875.rem,
      ),

      // ── Mobile header: nav items + close button ──────────────────────────
      // Shown only on mobile (< 1024 px). Mirrors Docusaurus's
      // .navbar-sidebar__brand / .navbar-sidebar__items structure.
      css('.sidebar-mobile-header', [
        css('&').styles(
          display: Display.flex,
          height: 3.75.rem,
          padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.5.rem),
          alignItems: AlignItems.center,
          raw: {'flex-shrink': '0'},
        ),
        css.media(MediaQuery.all(minWidth: 1024.px), [
          css('&').styles(display: Display.none),
        ]),
      ]),

      // Flex row inside the mobile header that holds the nav item components.
      css('.sidebar-mobile-nav', [
        css('&').styles(
          display: Display.flex,
          alignItems: AlignItems.center,
          gap: Gap.column(0.5.rem),
          flex: Flex(grow: 1),
          raw: {'flex-wrap': 'wrap'},
        ),
      ]),

      // ── Close button (inside mobile header) ─────────────────────────────
      // Styled as a square icon button; the SidebarToggleButton client
      // component listens for .sidebar-close clicks to dismiss the panel.
      css('.sidebar-close', [
        css('&').styles(
          display: Display.flex,
          width: 2.rem,
          height: 2.rem,
          radius: BorderRadius.circular(0.25.rem),
          justifyContent: JustifyContent.center,
          alignItems: AlignItems.center,
          color: Color.inherit,
          raw: {
            'flex-shrink': '0',
            'border': 'none',
            'background': 'none',
            'cursor': 'pointer',
            'opacity': '0.6',
            'transition': 'opacity 0.15s ease, background 0.15s ease',
          },
        ),
        css('&:hover').styles(
          opacity: 0.9,
          backgroundColor: Color('var(--hover-overlay)'),
        ),
      ]),

      // ── Primary panel ────────────────────────────────────────────────────
      // Shown on mobile when the sidebar has .show-primary (set by JS).
      // Contains the global nav items passed as primaryNavItems.
      // Hidden on desktop (≥ 1024 px) and by default on mobile.
      css('.sidebar-primary', [
        css('&').styles(display: Display.none),
      ]),
      css('.sidebar-primary-nav', [
        css('&').styles(
          display: Display.flex,
          padding: Padding.symmetric(vertical: 0.5.rem),
          flexDirection: FlexDirection.column,
          gap: Gap.column(2.px),
        ),
      ]),

      // ── "← Back to main menu" button ────────────────────────────────────
      // Shown only on mobile. Mirrors Docusaurus's secondary-panel back link.
      // Clicking switches to the primary panel (handled in _toggleScript).
      css('.sidebar-back', [
        css('&').styles(
          display: Display.block,
          width: Unit.percent(100),
          padding: Padding.symmetric(horizontal: 0.75.rem, vertical: 0.625.rem),
          opacity: 0.7,
          cursor: Cursor.pointer,
          transition: Transition('all', duration: 150.ms, curve: Curve.easeInOut),
          fontSize: 0.875.rem,
          raw: {
            'text-align': 'left',
            'background': 'none',
            'border': 'none',
            'color': 'inherit',
          },
        ),
        css('&:hover').styles(
          opacity: 1,
          backgroundColor: Color('var(--hover-overlay)'),
        ),
        css.media(MediaQuery.all(minWidth: 1024.px), [
          css('&').styles(display: Display.none),
        ]),
      ]),

      // ── Sidebar link group ───────────────────────────────────────────────
      css('.sidebar-group', [
        css('&').styles(
          padding: Padding.only(top: 1.5.rem, right: 0.75.rem, left: 8.px),
        ),
        css('ul').styles(
          padding: Padding.zero,
          margin: Margin.zero,
          listStyle: ListStyle.none,
        ),
        css('li').styles(margin: Margin.only(bottom: 2.px)),
      ]),
    ]),

    // ── Sidebar link (Docusaurus menu__link) ─────────────────────────────────
    css('.sidebar-link').styles(
      display: Display.flex,
      padding: Padding.symmetric(horizontal: 0.75.rem, vertical: 0.375.rem),
      radius: BorderRadius.circular(0.25.rem),
      alignItems: AlignItems.center,
      color: Color.inherit,
      fontSize: 1.rem,
      fontWeight: FontWeight.w500,
      textDecoration: TextDecoration.none,
      raw: {
        'line-height': '1.25',
        'transition': 'background 0.15s ease-in-out',
      },
    ),
    css('.sidebar-link:hover').styles(
      backgroundColor: Color('var(--hover-overlay)'),
    ),
    css('.sidebar-link.active').styles(
      color: ContentColors.primary,
      backgroundColor: Color('var(--hover-overlay)'),
    ),
    // Parent category: color only, no background tint.
    css('.sidebar-link.parent-active').styles(
      color: ContentColors.primary,
    ),

    // ── Category header: link + caret side by side ───────────────────────────
    // Mirrors Docusaurus's div.menu__list-item-collapsible.
    css('.sidebar-category-header').styles(
      display: Display.flex,
      alignItems: AlignItems.stretch,
    ),
    // Category link takes remaining width; always semibold (Docusaurus default
    // for menu__link--sublist regardless of expanded/active state).
    css('.sidebar-category-link').styles(
      flex: Flex(grow: 1),
      fontWeight: FontWeight.w600,
    ),

    // ── Caret toggle button (Docusaurus menu__caret) ─────────────────────────
    css('.sidebar-caret').styles(
      display: Display.flex,
      padding: Padding.symmetric(horizontal: 0.25.rem),
      radius: BorderRadius.circular(0.25.rem),
      alignItems: AlignItems.center,
      color: Color.inherit,
      raw: {
        'opacity': '0.4',
        'border': 'none',
        'background': 'none',
        'cursor': 'pointer',
        'transition': 'transform 0.2s ease, opacity 0.15s ease',
        'flex-shrink': '0',
      },
    ),
    css('.sidebar-caret:hover').styles(
      opacity: 0.8,
      backgroundColor: Color('var(--hover-overlay)'),
    ),
    // Caret stays visible (opacity 0.8) and rotates 90° when category is expanded.
    css('.sidebar-collapsible.expanded .sidebar-caret').styles(
      opacity: 0.8,
      raw: {'transform': 'rotate(90deg)'},
    ),

    // ── Children collapse/expand animation (CSS grid trick) ─────────────────
    // grid-template-rows: 0fr → 1fr transitions on the real content height,
    // giving symmetric smooth expand AND collapse animations.
    // The direct child (ul) must have overflow:hidden to clip at 0fr.
    css('.sidebar-children').styles(
      raw: {
        'display': 'grid',
        'grid-template-rows': '0fr',
        'transition': 'grid-template-rows 0.3s ease',
        // Indentation applied here (not on the inner ul) to avoid being
        // overridden by the higher-specificity .sidebar .sidebar-group ul rule.
        'padding-left': '1rem',
      },
    ),
    css('.sidebar-children > ul').styles(
      overflow: Overflow.hidden,
    ),
    css('.sidebar-collapsible.expanded .sidebar-children').styles(
      raw: {'grid-template-rows': '1fr'},
    ),

    // ── Primary panel: mobile two-panel toggle ───────────────────────────────
    // When .show-primary is on the sidebar: show primary panel, hide back
    // button and doc-links group. On desktop these rules have no effect since
    // all mobile-only elements are already display:none at ≥ 1024 px.
    css.media(MediaQuery.all(maxWidth: 1023.px), [
      css('.sidebar.show-primary .sidebar-primary').styles(display: Display.block),
      css('.sidebar.show-primary .sidebar-back').styles(
        raw: {'display': 'none !important'},
      ),
      css('.sidebar.show-primary .sidebar-group').styles(display: Display.none),
    ]),

    // Dark mode: active bg also uses --hover-overlay (auto-switches via token).
    // Active uses var(--primary) color which auto-switches via ContentTheme.
  ];
}
