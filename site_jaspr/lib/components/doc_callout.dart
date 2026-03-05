import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

/// Docusaurus-compatible callout/admonition component.
///
/// Replaces jaspr_content's [Callout] to match Docusaurus admonition layout:
///   - Left-border only (5 px), 4 px border-radius
///   - Heading row: filled SVG icon + uppercase type label
///   - Content body below
///
/// SVG icon paths are the exact Octicon paths used by Docusaurus
/// (packages/docusaurus-theme-classic/src/theme/Admonition/Icon/).
///
/// Color values match Infima's admonition tokens from
/// @infima/infima/dist/css/default/default.css.
class DocCallout extends CustomComponentBase {
  DocCallout();

  @override
  final Pattern pattern = RegExp(r'Info|Warning|Error|Success');

  @override
  Component apply(String name, Map<String, String> attributes, Component? child) {
    return _DocCallout(type: name.toLowerCase(), child: child!);
  }

  @css
  static List<StyleRule> get styles => [
    // Base layout: left-border only, Docusaurus sizing + subtle shadow.
    css('.doc-callout').styles(
      padding: Padding.symmetric(vertical: 12.px, horizontal: 16.px),
      margin: Margin.only(bottom: 1.25.rem),
      radius: BorderRadius.circular(4.px),
      raw: {
        'border': '0 solid',
        'border-left-width': '5px',
        'box-shadow': '0 1px 2px 0 rgba(0, 0, 0, 0.1)',
      },
    ),

    // Heading row: icon + uppercase type label.
    // No explicit font-weight: Docusaurus's VGV site only loads Poppins 400,
    // so the browser synthesizes a light faux-bold. Inheriting 400 (normal)
    // matches that visual output exactly.
    css('.doc-callout-heading').styles(
      display: Display.flex,
      margin: Margin.only(bottom: 0.3.rem),
      alignItems: AlignItems.center,
      fontSize: 0.875.rem,
      fontWeight: FontWeight.w600,
      raw: {
        'gap': '0.3em',
        'line-height': '1.25',
        'text-transform': 'uppercase',
      },
    ),

    // Icon: 1.6em relative to heading font, fills current color.
    css('.doc-callout-icon svg').styles(
      raw: {
        'height': '1.6em',
        'width': '1.6em',
        'fill': 'currentColor',
        'flex-shrink': '0',
      },
    ),

    // Remove default paragraph margin inside body.
    css('.doc-callout-body > p').styles(
      margin: Margin.only(bottom: Unit.zero),
    ),

    // --- Per-type colors via CSS variables (auto-switch light/dark) ---
    css('.doc-callout-info').styles(
      color: Color('var(--callout-info-text)'),
      backgroundColor: Color('var(--callout-info-bg)'),
      raw: {'border-color': 'var(--callout-info-border)'},
    ),
    css('.doc-callout-warning').styles(
      color: Color('var(--callout-warning-text)'),
      backgroundColor: Color('var(--callout-warning-bg)'),
      raw: {'border-color': 'var(--callout-warning-border)'},
    ),
    css('.doc-callout-error').styles(
      color: Color('var(--callout-error-text)'),
      backgroundColor: Color('var(--callout-error-bg)'),
      raw: {'border-color': 'var(--callout-error-border)'},
    ),
    css('.doc-callout-success').styles(
      color: Color('var(--callout-success-text)'),
      backgroundColor: Color('var(--callout-success-bg)'),
      raw: {'border-color': 'var(--callout-success-border)'},
    ),

    // Dark mode: text inherits from parent (can't express via CSS variable)
    css(':root[data-theme="dark"] .doc-callout').styles(
      color: Color.inherit,
    ),
  ];
}

class _DocCallout extends StatelessComponent {
  const _DocCallout({required this.type, required this.child});

  final String type;
  final Component child;

  @override
  Component build(BuildContext context) {
    final label = switch (type) {
      'info' => 'info',
      'warning' => 'warning',
      'error' => 'danger',
      'success' => 'tip',
      _ => type,
    };

    return div(classes: 'doc-callout doc-callout-$type', [
      div(classes: 'doc-callout-heading', [
        span(classes: 'doc-callout-icon', [_buildIcon(type)]),
        Component.text(label),
      ]),
      div(classes: 'doc-callout-body', [child]),
    ]);
  }

  static Component _buildIcon(String type) => switch (type) {
    'info' => svg(
      viewBox: '0 0 14 16',
      attributes: {'fill': 'currentColor'},
      [
        path(
          d: 'M7 2.3c3.14 0 5.7 2.56 5.7 5.7s-2.56 5.7-5.7 5.7A5.71 5.71 0 0 1 1.3 8c0-3.14 2.56-5.7 5.7-5.7zM7 1C3.14 1 0 4.14 0 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7zm1 3H6v5h2V4zm0 6H6v2h2v-2z',
          attributes: {'fill-rule': 'evenodd'},
          [],
        ),
      ],
    ),
    'warning' => svg(
      viewBox: '0 0 16 16',
      attributes: {'fill': 'currentColor'},
      [
        path(
          d: 'M8.893 1.5c-.183-.31-.52-.5-.887-.5s-.703.19-.886.5L.138 13.499a.98.98 0 0 0 0 1.001c.193.31.53.501.886.501h13.964c.367 0 .704-.19.877-.5a1.03 1.03 0 0 0 .01-1.002L8.893 1.5zm.133 11.497H6.987v-2.003h2.039v2.003zm0-3.004H6.987V5.987h2.039v4.006z',
          attributes: {'fill-rule': 'evenodd'},
          [],
        ),
      ],
    ),
    'error' => svg(
      viewBox: '0 0 12 16',
      attributes: {'fill': 'currentColor'},
      [
        path(
          d: 'M5.05.31c.81 2.17.41 3.38-.52 4.31C3.55 5.67 1.98 6.45.9 7.98c-1.45 2.05-1.7 6.53 3.53 7.7-2.2-1.16-2.67-4.52-.3-6.61-.61 2.03.53 3.33 1.94 2.86 1.39-.47 2.3.53 2.27 1.67-.02.78-.31 1.44-1.13 1.81 3.42-.59 4.78-3.42 4.78-5.56 0-2.84-2.53-3.22-1.25-5.61-1.52.13-2.03 1.13-1.89 2.75.09 1.08-1.02 1.8-1.86 1.33-.67-.41-.66-1.19-.06-1.78C8.18 5.31 8.68 2.45 5.05.32L5.03.3l.02.01z',
          attributes: {'fill-rule': 'evenodd'},
          [],
        ),
      ],
    ),
    _ => svg(
      // success → tip (lightbulb)
      viewBox: '0 0 12 16',
      attributes: {'fill': 'currentColor'},
      [
        path(
          d: 'M6.5 0C3.48 0 1 2.19 1 5c0 .92.55 2.25 1 3 1.34 2.25 1.78 2.78 2 4v1h5v-1c.22-1.22.66-1.75 2-4 .45-.75 1-2.08 1-3 0-2.81-2.48-5-5.5-5zm3.64 7.48c-.25.44-.47.8-.67 1.11-.86 1.41-1.25 2.06-1.45 3.23-.02.05-.02.11-.02.17H5c0-.06 0-.13-.02-.17-.2-1.17-.59-1.83-1.45-3.23-.2-.31-.42-.67-.67-1.11C2.44 6.78 2 5.65 2 5c0-2.2 2.02-4 4.5-4 1.22 0 2.36.42 3.22 1.19C10.55 2.94 11 3.94 11 5c0 .66-.44 1.78-.86 2.48zM4 14h5c-.23 1.14-1.3 2-2.5 2s-2.27-.86-2.5-2z',
          attributes: {'fill-rule': 'evenodd'},
          [],
        ),
      ],
    ),
  };
}
